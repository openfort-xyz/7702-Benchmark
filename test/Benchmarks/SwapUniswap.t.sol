// SPDX-License-Identifier: MIT

pragma solidity ^0.8.29;

import {OPFMain} from "src/core/OPFMain.sol";
import {FeeCalc} from "test/helpers/FeeCalc.sol";
import {BaseBenchmark} from "test/BaseBenchmark.t.sol";
import {console2 as console} from "lib/forge-std/src/Test.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {PackedUserOperation} from
    "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";

interface ISwapRouter {
    struct ExactInputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountIn;
        uint256 amountOutMinimum;
        uint160 sqrtPriceLimitX96;
    }

    function exactInputSingle(ExactInputSingleParams calldata params)
        external
        payable
        returns (uint256 amountOut);
}

interface IWETH {
    function deposit() external payable;
    function withdraw(uint256 wad) external;
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
}

contract SwapUniswap is BaseBenchmark {
    struct NetAddrs {
        address weth;
        address usdc;
        bool routerLive;
    }

    mapping(string => NetAddrs) private net;

    address constant SWAP_ROUTER = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    ISwapRouter public swapRouter;
    IWETH public weth;
    uint24 constant POOL_FEE = 3000;

    function test_SwapETHForUSDC() public {
        vm.pauseGasMetering();
        swapRouter = ISwapRouter(SWAP_ROUTER);
        weth = IWETH(WETH);
        _beginTest("SwapUniswap_Benchmark", "test_SwapETHForUSDC");
        _beginMode("Direct");
        
        _initAddrBook();

        for (uint256 i = 0; i < rpcs.length; ) {
            uint256 forkId = vm.createFork(rpcs[i].url);
            vm.selectFork(forkId);

            (address WETH_, address USDC_) = _loadAddresses(rpcs[i].name);
            if (WETH_ == address(0)) continue;

            swapRouter = ISwapRouter(SWAP_ROUTER);
            weth       = IWETH(WETH_);

            _deploy();
            _attach7702();
            _initialize();
            _deal(owner, 1e18);
            
            Call[] memory calls = new Call[](3);

            ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
                .ExactInputSingleParams({
                    tokenIn: WETH_,
                    tokenOut: USDC_,
                    fee: POOL_FEE,
                    recipient: owner,
                    deadline: 2164027884,
                    amountIn: 0.1 ether,
                    amountOutMinimum: 0,
                    sqrtPriceLimitX96: 0
            });

            bytes memory callDeposit = abi.encodeWithSelector(weth.deposit.selector);
            calls[0] = Call({target: WETH_, value: 0.1 ether, data: callDeposit});

            bytes memory callApprove =
                abi.encodeWithSelector(weth.approve.selector, SWAP_ROUTER, type(uint256).max);
            calls[1] = Call({target: WETH_, value: 0, data: callApprove});

            bytes memory callSwap =
                abi.encodeWithSelector(swapRouter.exactInputSingle.selector, params);
            calls[2] = Call({target: SWAP_ROUTER, value: 0, data: callSwap});

            bytes32 mode = bytes32(uint256(0x01000000000000000000) << (22 * 8));
            bytes memory executionData = abi.encode(calls);

            vm.resumeGasMetering();
            uint256 g0 = gasleft();
            vm.prank(owner);
            account.execute(mode, executionData);
            uint256 gasUsedLocal = g0 - gasleft();
            vm.pauseGasMetering();

            (uint256 zeros, uint256 nonZeros) = FeeCalc.countData(abi.encodePacked(hex"02FFFFFFFF", executionData));
            
            bytes32 k = keccak256(bytes(rpcs[i].name));
            ChainFees storage f = fees[k];

            uint256 weiCost = !f.isOPStack
                ? FeeCalc.ethOrArbCostWei(gasUsedLocal, f.gasPrice)
                : FeeCalc.opStackCostWeiEcotone(
                    gasUsedLocal,
                    f.op.l2GasPrice,
                    zeros,
                    nonZeros,
                    f.op.l1BaseFee,
                    f.op.l1BaseFeeScalar,
                    f.op.blobBaseFee,
                    f.op.blobBaseFeeScalar
                );

            uint256 usdE8 = FeeCalc.toUsdE8(weiCost, ethPriceUsdE8);
            string memory usdHuman = FeeCalc.usdE8ToString(usdE8, 4);

            console.log("Send ETH on %s", rpcs[i].name);
            console.log("Used Gas execute(): %s", gasUsedLocal);
            console.log("weiCost: %s", weiCost);
            console.log("usd: %s$", usdHuman);
            console.log("==================================================");
            console.log("==================================================");

            _push(rpcs[i].name, gasUsedLocal, weiCost, usdHuman);

            unchecked { ++i; }
        }
        _flushTo("test/Output/Uniswap/test_SwapETHForUSDC.json");
    }

    function test_SwapETHForUSDC_UOP() public {
        vm.pauseGasMetering();
        swapRouter = ISwapRouter(SWAP_ROUTER);
        weth = IWETH(WETH);
        _beginTest("SwapUniswap_Benchmark", "test_SwapETHForUSDC_UOP");
        _beginMode("Sponsored");
        
        _initAddrBook();
        PackedUserOperation memory userOp = _buildUserOp();

        for (uint256 i = 0; i < rpcs.length; ) {
            uint256 forkId = vm.createFork(rpcs[i].url);
            vm.selectFork(forkId);

            (address WETH_, address USDC_) = _loadAddresses(rpcs[i].name);
            if (WETH_ == address(0)) continue;

            swapRouter = ISwapRouter(SWAP_ROUTER);
            weth       = IWETH(WETH_);

            _deploy();
            _attach7702();
            _initialize();
            _paymaster();
            _deal(owner, 1e18);
            
            Call[] memory calls = new Call[](3);

            ISwapRouter.ExactInputSingleParams memory params = ISwapRouter
                .ExactInputSingleParams({
                    tokenIn: WETH_,
                    tokenOut: USDC_,
                    fee: POOL_FEE,
                    recipient: owner,
                    deadline: 2164027884,
                    amountIn: 0.1 ether,
                    amountOutMinimum: 0,
                    sqrtPriceLimitX96: 0
            });

            bytes memory callDeposit = abi.encodeWithSelector(weth.deposit.selector);
            calls[0] = Call({target: WETH_, value: 0.1 ether, data: callDeposit});

            bytes memory callApprove =
                abi.encodeWithSelector(weth.approve.selector, SWAP_ROUTER, type(uint256).max);
            calls[1] = Call({target: WETH_, value: 0, data: callApprove});

            bytes memory callSwap =
                abi.encodeWithSelector(swapRouter.exactInputSingle.selector, params);
            calls[2] = Call({target: SWAP_ROUTER, value: 0, data: callSwap});

            bytes32 mode = bytes32(uint256(0x01000000000000000000) << (22 * 8));
            bytes memory executionData = abi.encode(calls);

            bytes memory callData =
            abi.encodeWithSelector(bytes4(keccak256("execute(bytes32,bytes)")), mode, executionData);
    
            userOp.nonce = ep.getNonce(owner, 1);
            userOp.callData = callData;
            userOp.signature = _signUserOpWithEOA(userOp);
    
            PackedUserOperation[] memory ops = new PackedUserOperation[](1);
            ops[0] = userOp;
            
            vm.resumeGasMetering();
            uint256 g0 = gasleft();
            vm.prank(pmAddr);
            ep.handleOps(ops, payable(pmAddr));
            uint256 gasUsedLocal = g0 - gasleft();
            vm.pauseGasMetering();

            (uint256 zeros, uint256 nonZeros) = FeeCalc.countData(abi.encodePacked(hex"02FFFFFFFF", executionData));
            
            bytes32 k = keccak256(bytes(rpcs[i].name));
            ChainFees storage f = fees[k];

            uint256 weiCost = !f.isOPStack
                ? FeeCalc.ethOrArbCostWei(gasUsedLocal, f.gasPrice)
                : FeeCalc.opStackCostWeiEcotone(
                    gasUsedLocal,
                    f.op.l2GasPrice,
                    zeros,
                    nonZeros,
                    f.op.l1BaseFee,
                    f.op.l1BaseFeeScalar,
                    f.op.blobBaseFee,
                    f.op.blobBaseFeeScalar
                );

            uint256 usdE8 = FeeCalc.toUsdE8(weiCost, ethPriceUsdE8);
            string memory usdHuman = FeeCalc.usdE8ToString(usdE8, 4);

            console.log("Send ETH on %s", rpcs[i].name);
            console.log("Used Gas execute(): %s", gasUsedLocal);
            console.log("weiCost: %s", weiCost);
            console.log("usd: %s$", usdHuman);
            console.log("==================================================");
            console.log("==================================================");

            _push(rpcs[i].name, gasUsedLocal, weiCost, usdHuman);

            unchecked { ++i; }
        }
        _flushTo("test/Output/Uniswap/test_SwapETHForUSDC_UOP.json");
    }

    function _initAddrBook() internal {
        net["MAINNET"] = NetAddrs({
            weth: 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
            usdc: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48,
            routerLive: true
        });
        net["BASE"] = NetAddrs({
            weth: 0x4200000000000000000000000000000000000006,
            usdc: 0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913,
            routerLive: true
        });
        net["ARBITRUM"] = NetAddrs({
            weth: 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1,
            usdc: 0xaf88d065e77c8cC2239327C5EDb3A432268e5831,
            routerLive: true
        });
        net["OPTIMISM"] = NetAddrs({
            weth: 0x4200000000000000000000000000000000000006,
            usdc: 0x0b2C639c533813f4Aa9D7837CAf62653d097Ff85,
            routerLive: true
        });
    }

    function _loadAddresses(string memory _name) internal view returns (address weth_, address usdc_) {
        NetAddrs memory a = net[_name];
        return (a.weth, a.usdc);
    }
}