// SPDX-license-Identifier: MIT

pragma solidity ^0.8.29;

import {OPFMain} from "src/core/OPFMain.sol";
import {FeeCalc} from "test/helpers/FeeCalc.sol";
import {BaseBenchmark} from "test/BaseBenchmark.t.sol";
import {console2 as console} from "lib/forge-std/src/Test.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {PackedUserOperation} from
    "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";

contract BatchExecution is BaseBenchmark {
    function test_BatchExecution() public {
        vm.pauseGasMetering();

        _beginTest("BatchExecution_Benchmark", "test_BatchExecution");
        _beginMode("Direct");
        _mintErc20(owner, 10e18);
        for (uint256 i = 0; i < rpcs.length; ) {
            uint256 forkId = vm.createFork(rpcs[i].url);
            vm.selectFork(forkId);

            _deploy();
            _attach7702();
            _initialize();

            Call[] memory calls = new Call[](2);
            bytes memory dataHex = abi.encodeWithSelector(erc20.mint.selector, owner, 10e18);
            bytes memory dataHex2 = abi.encodeWithSelector(IERC20.transfer.selector, sessionKey, 2e18);
            calls[0] = Call({target: address(erc20), value: 0, data: dataHex});
            calls[1] = Call({target: address(erc20), value: 0, data: dataHex2});

            bytes32 mode = bytes32(uint256(0x01000000000000000000) << (22 * 8));
            bytes memory executionData = abi.encode(calls);

            bytes memory callData =
            abi.encodeWithSelector(bytes4(keccak256("execute(bytes32,bytes)")), mode, executionData);

            vm.resumeGasMetering();
            uint256 g0 = gasleft();
            vm.prank(owner);
            account.execute(mode, executionData);
            uint256 gasUsedLocal = g0 - gasleft();
            vm.pauseGasMetering();

            (uint256 zeros, uint256 nonZeros) = FeeCalc.countData(abi.encodePacked(hex"02FFFFFFFF", callData));

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

            console.log("Batch Execute on %s", rpcs[i].name);
            console.log("Used Gas execute(): %s", gasUsedLocal);
            console.log("weiCost: %s", weiCost);
            console.log("usd: %s$", usdHuman);
            console.log("==================================================");
            console.log("==================================================");

            _push(rpcs[i].name, gasUsedLocal, weiCost, usdHuman);

            unchecked { ++i; }
        }
        _flushTo("test/Output/Batch/test_BatchExecution.json");
    }

    function test_BatchExecution_UOP() public {
        vm.pauseGasMetering();

        _beginTest("BatchExecution_Benchmark", "test_BatchExecution_UOP");
        _beginMode("Sponsored");
        _mintErc20(owner, 10e18);
        
        PackedUserOperation memory userOp = _buildUserOp();

        for (uint256 i = 0; i < rpcs.length; ) {
            uint256 forkId = vm.createFork(rpcs[i].url);
            vm.selectFork(forkId);

            _deploy();
            _attach7702();
            _initialize();
            _paymaster();

            Call[] memory calls = new Call[](2);
            bytes memory dataHex = abi.encodeWithSelector(erc20.mint.selector, owner, 10e18);
            bytes memory dataHex2 = abi.encodeWithSelector(IERC20.transfer.selector, sessionKey, 2e18);
            calls[0] = Call({target: address(erc20), value: 0, data: dataHex});
            calls[1] = Call({target: address(erc20), value: 0, data: dataHex2});

            bytes32 mode = bytes32(uint256(0x01000000000000000000) << (22 * 8));
            bytes memory executionData = abi.encode(calls);

            bytes memory callData =
            abi.encodeWithSelector(bytes4(keccak256("execute(bytes32,bytes)")), mode, executionData);

            userOp.nonce = _getNonce(owner, 0);
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

            (uint256 zeros, uint256 nonZeros) = FeeCalc.countData(abi.encodePacked(hex"02FFFFFFFF", callData));

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

            console.log("Batch Execute on %s", rpcs[i].name);
            console.log("Used Gas execute(): %s", gasUsedLocal);
            console.log("weiCost: %s", weiCost);
            console.log("usd: %s$", usdHuman);
            console.log("==================================================");
            console.log("==================================================");

            _push(rpcs[i].name, gasUsedLocal, weiCost, usdHuman);

            unchecked { ++i; }
        }
        _flushTo("test/Output/Batch/test_BatchExecution_UOP.json");
    }
}

