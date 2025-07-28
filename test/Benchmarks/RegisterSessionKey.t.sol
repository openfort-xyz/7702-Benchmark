// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {OPFMain} from "src/core/OPFMain.sol";
import {FeeCalc} from "test/helpers/FeeCalc.sol";
import {BaseBenchmark} from "test/BaseBenchmark.t.sol";
import {console2 as console} from "lib/forge-std/src/Test.sol";

contract RegisterSessionKey is BaseBenchmark {
    function test_RegisterEOA() public {
        vm.pauseGasMetering();

        _beginTest("Register_Benchmark", "test_RegisterEOA");
        _beginMode("Direct");

        for (uint256 i = 0; i < rpcs.length; ) {
            uint256 forkId = vm.createFork(rpcs[i].url);
            vm.selectFork(forkId);

            _deploy();
            _attach7702();
            _initialize();
            _getSKEOA();

            bytes memory callData =
                abi.encodeWithSelector(account.registerKey.selector, keySK, keyReg);

            vm.resumeGasMetering();
            uint256 g0 = gasleft();
            vm.prank(owner);
            account.registerKey(keySK, keyReg);
            uint256 gasUsedLocal = g0 - gasleft();
            vm.pauseGasMetering();

            (uint256 zeros, uint256 nonZeros) = FeeCalc.countData(callData);

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

            console.log("Register Key on %s", rpcs[i].name);
            console.log("Used Gas registerKey(): %s", gasUsedLocal);
            console.log("weiCost: %s", weiCost);
            console.log("usd: %s$", usdHuman);
            console.log("==================================================");
            console.log("==================================================");

            _push(rpcs[i].name, gasUsedLocal, weiCost, usdHuman);

            unchecked { ++i; }
        }
        _flushTo("test/Output/Register-Key/test_RegisterEOA.json");
    }

    function test_RegisterP256() public {
        vm.pauseGasMetering();

        _beginTest("Register_Benchmark", "test_RegisterP256");
        _beginMode("Direct");

        for (uint256 i = 0; i < rpcs.length; ) {
            uint256 forkId = vm.createFork(rpcs[i].url);
            vm.selectFork(forkId);

            _deploy();
            _attach7702();
            _initialize();
            _getSKP256();

            bytes memory callData =
                abi.encodeWithSelector(account.registerKey.selector, keySK, keyReg);

            vm.resumeGasMetering();
            uint256 g0 = gasleft();
            vm.prank(owner);
            account.registerKey(keySK, keyReg);
            uint256 gasUsedLocal = g0 - gasleft();
            vm.pauseGasMetering();

            (uint256 zeros, uint256 nonZeros) = FeeCalc.countData(callData);

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

            console.log("Register Key on %s", rpcs[i].name);
            console.log("Used Gas registerKey(): %s", gasUsedLocal);
            console.log("weiCost: %s", weiCost);
            console.log("usd: %s$", usdHuman);
            console.log("==================================================");
            console.log("==================================================");

            _push(rpcs[i].name, gasUsedLocal, weiCost, usdHuman);

            unchecked { ++i; }
        }
        _flushTo("test/Output/Register-Key/test_RegisterP256.json");
    }

    function test_RegisterP256NonExtrac() public {
        vm.pauseGasMetering();

        _beginTest("Register_Benchmark", "test_RegisterP256NonExtrac");
        _beginMode("Direct");

        for (uint256 i = 0; i < rpcs.length; ) {
            uint256 forkId = vm.createFork(rpcs[i].url);
            vm.selectFork(forkId);

            _deploy();
            _attach7702();
            _initialize();
            _getSKP256NonExtract();

            bytes memory callData =
                abi.encodeWithSelector(account.registerKey.selector, keySK, keyReg);

            vm.resumeGasMetering();
            uint256 g0 = gasleft();
            vm.prank(owner);
            account.registerKey(keySK, keyReg);
            uint256 gasUsedLocal = g0 - gasleft();
            vm.pauseGasMetering();

            (uint256 zeros, uint256 nonZeros) = FeeCalc.countData(callData);

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

            console.log("Register Key on %s", rpcs[i].name);
            console.log("Used Gas registerKey(): %s", gasUsedLocal);
            console.log("weiCost: %s", weiCost);
            console.log("usd: %s$", usdHuman);
            console.log("==================================================");
            console.log("==================================================");

            _push(rpcs[i].name, gasUsedLocal, weiCost, usdHuman);

            unchecked { ++i; }
        }
        _flushTo("test/Output/Register-Key/test_RegisterP256NonExtrac.json");
    }
}