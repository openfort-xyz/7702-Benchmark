// SPDX-License-Identifier: MIT

pragma solidity ^0.8.29;

import {OPFMain} from "src/core/OPFMain.sol";
import {FeeCalc} from "test/helpers/FeeCalc.sol";
import {BaseBenchmark} from "test/BaseBenchmark.t.sol";
import {console2 as console} from "lib/forge-std/src/Test.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {PackedUserOperation} from
    "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";
import {SafeTransferLib} from "lib/solady/src/utils/SafeTransferLib.sol";
import {LibClone} from "lib/solady/src/utils/LibClone.sol";

interface IUniswapV2Router {
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}

contract SwapERC20Uniswap is BaseBenchmark {
    address constant _UNISWAP_V2_FACTORY_ADDRESS = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address constant _UNISWAP_V2_ROUTER_ADDRESS = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    IUniswapV2Router uniswapV2Router;
    address token0;
    address token1;

    MockPaymentToken paymentToken;

    function setUp() public override {
        super.setUp();
        paymentToken = new MockPaymentToken();

        token0 = LibClone.clone(address(paymentToken));
        _mint(token0, address(this), type(uint128).max);
        token1 = LibClone.clone(address(paymentToken));
        _mint(token1, address(this), type(uint128).max);
        if (uint160(token0) > uint160(token1)) {
            (token0, token1) = (token1, token0);
        }
        uniswapV2Router = IUniswapV2Router(_UNISWAP_V2_ROUTER_ADDRESS);
        SafeTransferLib.safeApprove(token0, _UNISWAP_V2_ROUTER_ADDRESS, type(uint256).max);
        SafeTransferLib.safeApprove(token1, _UNISWAP_V2_ROUTER_ADDRESS, type(uint256).max);
        uniswapV2Router.addLiquidity(
            token0, token1, 1 ether, 1 ether, 1, 1, address(this), block.timestamp + 999
        );
    }

    function test_UniswapV2Swap() public {
        bytes memory payload = abi.encodeWithSignature(
            "execute(address,uint256,bytes)", _UNISWAP_V2_ROUTER_ADDRESS, 0, _uniswapV2SwapPayload()
        );

        _deploy();
        _attach7702();
        _initialize();
        _deal(owner, 1e18);

        Call[] memory calls = new Call[](1);
        calls[0] = Call({target: _UNISWAP_V2_ROUTER_ADDRESS, value: 0 ether, data: payload});
        bytes memory executionData = abi.encode(calls);
        bytes32 mode = bytes32(uint256(0x01000000000000000000) << (22 * 8));

        bytes memory callData =
            abi.encodeWithSelector(bytes4(keccak256("execute(bytes32,bytes)")), mode, executionData);
        PackedUserOperation memory userOp = _buildUserOp();
        userOp.nonce = ep.getNonce(owner, 1);
        userOp.callData = callData;
        userOp.signature = _signUserOpWithEOA(userOp);

        PackedUserOperation[] memory ops = new PackedUserOperation[](1);
        ops[0] = userOp;

        vm.prank(pmAddr);
        ep.handleOps(ops, payable(pmAddr));
        vm.snapshotGasLastCall("test_UniswapV2Swap");
    }

    function _mint(address token, address to, uint256 amount) internal {
        if (token == address(0)) {
            vm.deal(to, amount);
        } else {
            MockPaymentToken(token).mint(to, amount);
        }
    }

    function _uniswapV2SwapPayload() internal view returns (bytes memory) {
        address[] memory path = new address[](2);
        path[0] = token0;
        path[1] = token1;

        return abi.encodeWithSelector(
            IUniswapV2Router.swapTokensForExactTokens.selector,
            1,
            11,
            path,
            address(0xbabe),
            block.timestamp + 999
        );
    }
}

import {ERC20} from "lib/solady/src/tokens/ERC20.sol";

/// @dev WARNING! This mock is strictly intended for testing purposes only.
/// Do NOT copy anything here into production code unless you really know what you are doing.
contract MockPaymentToken is ERC20 {
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function anotherTransfer(address to, uint256 amount) public returns (bool) {
        transfer(to, amount);
        return true;
    }

    function name() public view virtual override returns (string memory) {
        return "Name";
    }

    function symbol() public view virtual override returns (string memory) {
        return "SYM";
    }
}
