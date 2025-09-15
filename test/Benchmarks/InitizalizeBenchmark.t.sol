// SPDX-License-Identifier: MIT

pragma solidity ^0.8.29;

import {OPFMain} from "src/core/OPFMain.sol";
import {BaseBenchmark} from "test/BaseBenchmark.t.sol";
import {FeeCalc} from "test/helpers/FeeCalc.sol";
import {console2 as console} from "lib/forge-std/src/Test.sol";
import {PackedUserOperation} from
    "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";

contract InitializeBenchmark is BaseBenchmark {
    function test_InitializeTX() public {
        vm.pauseGasMetering();

        _beginTest("Register_Benchmark", "test_InitializeTX");
        _beginMode("Direct");

        (Key memory keyMK, KeyReg memory keyRegMK) = _getMK();
        (Key memory keySK, KeyReg memory keyRegSK) = _getSKEmpty();

        for (uint256 i = 0; i < rpcs.length;) {
            uint256 forkId = vm.createFork(rpcs[i].url);
            vm.selectFork(forkId);

            (bytes memory sig,) = _signInitialize();

            _deploy();
            _attach7702();

            bytes memory initCallData = abi.encodeWithSelector(
                account.initialize.selector, keyMK, keyRegMK, keySK, keyRegSK, sig, initialGuardian
            );

            vm.resumeGasMetering();
            uint256 g0 = gasleft();

            vm.prank(owner);
            account.initialize(keyMK, keyRegMK, keySK, keyRegSK, sig, initialGuardian);

            uint256 gasUsedLocal = g0 - gasleft();
            vm.pauseGasMetering();

            (uint256 zeros, uint256 nonZeros) = FeeCalc.countData(initCallData);

            bytes32 k = keccak256(bytes(rpcs[i].name));
            ChainFees storage f = fees[k];

            uint256 weiCost;
            if (!f.isOPStack) {
                weiCost = FeeCalc.ethOrArbCostWei(gasUsedLocal, f.gasPrice);
            } else {
                weiCost = FeeCalc.opStackCostWeiEcotone(
                    gasUsedLocal,
                    f.op.l2GasPrice,
                    zeros,
                    nonZeros,
                    f.op.l1BaseFee,
                    f.op.l1BaseFeeScalar,
                    f.op.blobBaseFee,
                    f.op.blobBaseFeeScalar
                );
            }

            uint256 usdE8 = FeeCalc.toUsdE8(weiCost, ethPriceUsdE8);
            string memory usdHuman = FeeCalc.usdE8ToString(usdE8, 4);

            console.log("Initialize on %s", rpcs[i].name);
            console.log("Used Gas initialize(): %s", gasUsedLocal);
            console.log("weiCost: %s", weiCost);
            console.log("usd: %s$", usdHuman);
            console.log("==================================================");
            console.log("==================================================");

            _push(rpcs[i].name, gasUsedLocal, weiCost, usdHuman);

            unchecked {
                ++i;
            }
        }
        _flushTo("test/Output/Initialize/test_InitializeTX.json");
    }

    function test_InitializeTX_UOP() public {
        vm.pauseGasMetering();

        _beginTest("Register_Benchmark", "test_InitializeTX_UOP");
        _beginMode("Sponsored");

        (Key memory keyMK, KeyReg memory keyRegMK) = _getMK();
        (Key memory keySK, KeyReg memory keyRegSK) = _getSKEmpty();

        PackedUserOperation memory userOp = _buildUserOp();

        for (uint256 i = 0; i < rpcs.length;) {
            uint256 forkId = vm.createFork(rpcs[i].url);
            vm.selectFork(forkId);

            (bytes memory sig,) = _signInitialize();

            _deploy();
            _attach7702();
            _paymaster();

            bytes memory initCallData = abi.encodeWithSelector(
                account.initialize.selector, keyMK, keyRegMK, keySK, keyRegSK, sig, initialGuardian
            );
            userOp.nonce = _getNonce(owner, 0);
            userOp.callData = initCallData;
            userOp.signature = _signUserOpWithEOA(userOp);

            PackedUserOperation[] memory ops = new PackedUserOperation[](1);
            ops[0] = userOp;

            vm.resumeGasMetering();
            uint256 g0 = gasleft();

            vm.prank(pmAddr);
            ep.handleOps(ops, payable(pmAddr));

            uint256 gasUsedLocal = g0 - gasleft();
            vm.pauseGasMetering();

            (uint256 zeros, uint256 nonZeros) =
                FeeCalc.countData(abi.encodePacked(hex"02FFFFFFFF", userOp.callData));

            bytes32 k = keccak256(bytes(rpcs[i].name));
            ChainFees storage f = fees[k];

            uint256 weiCost;
            if (!f.isOPStack) {
                weiCost = FeeCalc.ethOrArbCostWei(gasUsedLocal, f.gasPrice);
            } else {
                weiCost = FeeCalc.opStackCostWeiEcotone(
                    gasUsedLocal,
                    f.op.l2GasPrice,
                    zeros,
                    nonZeros,
                    f.op.l1BaseFee,
                    f.op.l1BaseFeeScalar,
                    f.op.blobBaseFee,
                    f.op.blobBaseFeeScalar
                );
            }

            uint256 usdE8 = FeeCalc.toUsdE8(weiCost, ethPriceUsdE8);
            string memory usdHuman = FeeCalc.usdE8ToString(usdE8, 4);

            console.log("Initialize on %s", rpcs[i].name);
            console.log("Used Gas with EP initialize(): %s", gasUsedLocal);
            console.log("weiCost: %s", weiCost);
            console.log("usd: %s$", usdHuman);
            console.log("==================================================");
            console.log("==================================================");

            _push(rpcs[i].name, gasUsedLocal, weiCost, usdHuman);

            unchecked {
                ++i;
            }
        }
        _flushTo("test/Output/Initialize/test_InitializeTX_UOP.json");
    }

    function test_InitializeTXWithRegisteringSessionKey() public {
        vm.pauseGasMetering();
        _beginTest("InitializeBenchmark", "test_InitializeTXWithRegisteringSessionKey");
        _beginMode("Direct");

        (Key memory keyMK, KeyReg memory keyRegMK) = _getMK();
        (Key memory keySK, KeyReg memory keyRegSK) = _getSK();

        for (uint256 i = 0; i < rpcs.length;) {
            uint256 forkId = vm.createFork(rpcs[i].url);
            vm.selectFork(forkId);

            (bytes memory sig,) = _signInitialize();

            _deploy();
            _attach7702();

            bytes memory initCallData = abi.encodeWithSelector(
                account.initialize.selector, keyMK, keyRegMK, keySK, keyRegSK, sig, initialGuardian
            );

            vm.resumeGasMetering();
            uint256 g0 = gasleft();

            vm.prank(owner);
            account.initialize(keyMK, keyRegMK, keySK, keyRegSK, sig, initialGuardian);

            uint256 gasUsedLocal = g0 - gasleft();
            vm.pauseGasMetering();

            (uint256 zeros, uint256 nonZeros) = FeeCalc.countData(initCallData);

            bytes32 k = keccak256(bytes(rpcs[i].name));
            ChainFees storage f = fees[k];

            uint256 weiCost;
            if (!f.isOPStack) {
                weiCost = FeeCalc.ethOrArbCostWei(gasUsedLocal, f.gasPrice);
            } else {
                weiCost = FeeCalc.opStackCostWeiEcotone(
                    gasUsedLocal,
                    f.op.l2GasPrice,
                    zeros,
                    nonZeros,
                    f.op.l1BaseFee,
                    f.op.l1BaseFeeScalar,
                    f.op.blobBaseFee,
                    f.op.blobBaseFeeScalar
                );
            }

            uint256 usdE8 = FeeCalc.toUsdE8(weiCost, ethPriceUsdE8);
            string memory usdHuman = FeeCalc.usdE8ToString(usdE8, 4);

            console.log("Initialize on %s", rpcs[i].name);
            console.log("Used Gas initialize(): %s", gasUsedLocal);
            console.log("weiCost: %s", weiCost);
            console.log("usd: %s$", usdHuman);
            console.log("==================================================");
            console.log("==================================================");

            _push(rpcs[i].name, gasUsedLocal, weiCost, usdHuman);

            unchecked {
                ++i;
            }
        }
        _flushTo("test/Output/Initialize/test_InitializeTXWithRegisteringSessionKey.json");
    }

    function test_InitializeTXWithRegisteringSessionKey_UOP() public {
        vm.pauseGasMetering();

        _beginTest("Register_Benchmark", "test_InitializeTXWithRegisteringSessionKey_UOP");
        _beginMode("Sponsored");

        (Key memory keyMK, KeyReg memory keyRegMK) = _getMK();
        (Key memory keySK, KeyReg memory keyRegSK) = _getSK();

        PackedUserOperation memory userOp = _buildUserOp();

        for (uint256 i = 0; i < rpcs.length;) {
            uint256 forkId = vm.createFork(rpcs[i].url);
            vm.selectFork(forkId);

            (bytes memory sig,) = _signInitialize();

            _deploy();
            _attach7702();
            _paymaster();

            bytes memory initCallData = abi.encodeWithSelector(
                account.initialize.selector, keyMK, keyRegMK, keySK, keyRegSK, sig, initialGuardian
            );
            userOp.nonce = ep.getNonce(owner, 1);
            userOp.callData = initCallData;
            userOp.signature = _signUserOpWithEOA(userOp);

            PackedUserOperation[] memory ops = new PackedUserOperation[](1);
            ops[0] = userOp;

            vm.resumeGasMetering();
            uint256 g0 = gasleft();

            vm.prank(pmAddr);
            ep.handleOps(ops, payable(pmAddr));

            uint256 gasUsedLocal = g0 - gasleft();
            vm.pauseGasMetering();

            (uint256 zeros, uint256 nonZeros) =
                FeeCalc.countData(abi.encodePacked(hex"02FFFFFFFF", userOp.callData));

            bytes32 k = keccak256(bytes(rpcs[i].name));
            ChainFees storage f = fees[k];

            uint256 weiCost;
            if (!f.isOPStack) {
                weiCost = FeeCalc.ethOrArbCostWei(gasUsedLocal, f.gasPrice);
            } else {
                weiCost = FeeCalc.opStackCostWeiEcotone(
                    gasUsedLocal,
                    f.op.l2GasPrice,
                    zeros,
                    nonZeros,
                    f.op.l1BaseFee,
                    f.op.l1BaseFeeScalar,
                    f.op.blobBaseFee,
                    f.op.blobBaseFeeScalar
                );
            }

            uint256 usdE8 = FeeCalc.toUsdE8(weiCost, ethPriceUsdE8);
            string memory usdHuman = FeeCalc.usdE8ToString(usdE8, 4);

            console.log("Initialize on %s", rpcs[i].name);
            console.log("Used Gas initialize(): %s", gasUsedLocal);
            console.log("weiCost: %s", weiCost);
            console.log("usd: %s$", usdHuman);
            console.log("==================================================");
            console.log("==================================================");

            _push(rpcs[i].name, gasUsedLocal, weiCost, usdHuman);

            unchecked {
                ++i;
            }
        }

        _flushTo("test/Output/Initialize/test_InitializeTXWithRegisteringSessionKey_UOP.json");
    }
}
