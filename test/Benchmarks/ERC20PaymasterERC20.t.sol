// SPDX-License-Identifier: MIT

pragma solidity ^0.8.29;

import {OPFMain} from "src/core/OPFMain.sol";
import {FeeCalc} from "test/helpers/FeeCalc.sol";
import {BaseBenchmark} from "test/BaseBenchmark.t.sol";
import {console2 as console} from "lib/forge-std/src/Test.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {PackedUserOperation} from
    "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";
import {MessageHashUtils} from
    "lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol";

contract ERC20PaymasterERC20 is BaseBenchmark {
    function test_TransferErc20_UOP_ERC20_MODE_combinedByteBasic() public {
        vm.pauseGasMetering();

        _beginTest("ERC20Paymaster", "test_TransferErc20_UOP_ERC20_MODE_combinedByteBasic");
        _beginMode("Sponsored");

        PackedUserOperation memory userOp = _buildUserOp();

        for (uint256 i = 0; i < rpcs.length;) {
            uint256 forkId = vm.createFork(rpcs[i].url);
            vm.selectFork(forkId);

            _deploy();
            _attach7702();
            _initialize();
            _mintErc20(owner, 100e18);
            _depositAndStakeEP();
            _approvePM();

            Call[] memory calls = new Call[](1);
            bytes memory dataHex =
                abi.encodeWithSelector(IERC20.transfer.selector, sessionKey, 2e18);
            calls[0] = Call({target: address(erc20), value: 0, data: dataHex});

            bytes32 mode = bytes32(uint256(0x01000000000000000000) << (22 * 8));
            bytes memory executionData = abi.encode(calls);

            bytes memory callData = abi.encodeWithSelector(
                bytes4(keccak256("execute(bytes32,bytes)")), mode, executionData
            );

            userOp.nonce = _getNonce(owner, 0);
            userOp.callData = callData;
            userOp.paymasterAndData =
                _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
            bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
            userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);
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
                FeeCalc.countData(abi.encodePacked(hex"02FFFFFFFF", callData));

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

            console.log("Transfer Erc20 on %s", rpcs[i].name);
            console.log("Used Gas execute(): %s", gasUsedLocal);
            console.log("weiCost: %s", weiCost);
            console.log("usd: %s$", usdHuman);
            console.log("==================================================");
            console.log("==================================================");

            _push(rpcs[i].name, gasUsedLocal, weiCost, usdHuman);

            unchecked {
                ++i;
            }
        }
        _flushTo("test/Output/ERC20Paymaster/test_TransferErc20_UOP_ERC20_MODE_combinedByteBasic.json");
    }

    function _createPaymasterDataMode(
        PackedUserOperation memory userOp,
        uint8 _mode,
        uint8 _combinedByte
    ) internal returns (bytes memory paymasterData) {
        uint128 verificationGasLimit = uint128(uint256(bytes32(userOp.accountGasLimits)) >> 128);
        _validWindow();
        if (_mode == VERIFYING_MODE) {
            console.log("A");
            paymasterData = abi.encodePacked(
                address(pm),
                verificationGasLimit,
                postGas,
                (_mode << 1) | MODE_AND_ALLOW_ALL_BUNDLERS_LENGTH,
                validUntil,
                validAfter
            );
            console.log("B");
        } else if (_mode == ERC20_MODE) {
            paymasterData = abi.encodePacked(
                address(pm),
                verificationGasLimit,
                postGas,
                (_mode << 1) | MODE_AND_ALLOW_ALL_BUNDLERS_LENGTH,
                _combinedByte,
                validUntil,
                validAfter,
                address(erc20),
                postGas,
                exchangeRate,
                paymasterValidationGasLimit,
                treasury
            );
            if ((_combinedByte & 0x04) != 0) {
                // preFundPresent
                uint128 reasonablePreFund = uint128((requiredPreFund * exchangeRate) / 1e18 / 2);
                paymasterData = abi.encodePacked(paymasterData, reasonablePreFund);
            }

            if ((_combinedByte & 0x01) != 0) {
                // constantFeePresent
                paymasterData = abi.encodePacked(paymasterData, uint128(10000)); // constantFee (16 bytes)
            }

            if ((_combinedByte & 0x02) != 0) {
                // recipientPresent
                paymasterData = abi.encodePacked(paymasterData, address(sender)); // recipient (20 bytes)
            }
        }
    }

    function _signPaymasterData(
        uint8 _mode,
        PackedUserOperation calldata _userOp,
        uint256 _signerIndx
    ) external view returns (bytes memory paymasterSignature) {
        bytes32 rawHash = pm.getHash(_mode, _userOp);
        bytes32 ethSignedHash = MessageHashUtils.toEthSignedMessageHash(rawHash);
        uint256 PK = signersPM_PK[_signerIndx];
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(PK, ethSignedHash);

        paymasterSignature = abi.encodePacked(r, s, v);
    }

    function _validWindow() internal {
        validUntil = uint48(block.timestamp + 20 minutes);
        validAfter = 0;
    }

    function _approvePM() internal {
        vm.prank(owner);
        erc20.approve(address(pm), type(uint256).max);
    }
}
