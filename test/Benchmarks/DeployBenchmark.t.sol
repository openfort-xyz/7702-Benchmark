// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {OPFMain} from "src/core/OPFMain.sol";
import {BaseBenchmark} from "test/BaseBenchmark.t.sol";
import {FeeCalc} from "test/helpers/FeeCalc.sol";
import {console2 as console} from "lib/forge-std/src/Test.sol";

contract DeployBenchmark is BaseBenchmark {
    function test_DeployOPFMain() public {
        vm.pauseGasMetering();

        for (uint256 i = 0; i < rpcs.length; ) {
            uint256 forkId = vm.createFork(rpcs[i].url);
            vm.selectFork(forkId);
            vm.resumeGasMetering();

            uint256 g0 = gasleft();
            new OPFMain(
                address(ep),
                address(webAuthn),
                RECOVERY_PERIOD,
                LOCK_PERIOD,
                SECURITY_PERIOD,
                SECURITY_WINDOW
            );
            uint256 gasUsedLocal = g0 - gasleft();

            vm.pauseGasMetering();

            bytes memory creationTxData = abi.encodePacked(
                type(OPFMain).creationCode,
                abi.encode(
                    address(ep),
                    address(webAuthn),
                    RECOVERY_PERIOD,
                    LOCK_PERIOD,
                    SECURITY_PERIOD,
                    SECURITY_WINDOW
                )
            );

            (uint256 zeros, uint256 nonZeros) = FeeCalc.countData(creationTxData);

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
            string memory usdHuman = FeeCalc.usdE8ToString(usdE8, 2);

            console.log("Deploying on %s", rpcs[i].name);
            console.log("Used Gas Deploy OPFMain: %s", gasUsedLocal);
            console.log("weiCost: %s", weiCost);
            console.log("usd: %s$", usdHuman);
            console.log("==================================================");
            console.log("==================================================");
            unchecked {
                ++i;
            }
        }
    }
}