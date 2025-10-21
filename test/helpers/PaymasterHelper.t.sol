// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { ExecutionHelper } from "test/helpers/ExecutionHelper.t.sol";
import { PackedUserOperation } from "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";
import { MessageHashUtils } from "lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol";

contract PaymasterHelper is ExecutionHelper {
    uint48 validUntil;
    uint48 validAfter;
    uint128 constant postGas = 50_000;
    uint128 constant paymasterValidationGasLimit = 100_000;
    uint256 constant preVerificationGas = 800_000;
    uint256 exchangeRate = 1_000_000;
    uint256 requiredPreFund = 1_000_000;
    // Basic ERC20 mode - no optional fields
    uint8 combinedByteBasic = 0x00;

    // With constant fee
    uint8 combinedByteFee = 0x01;

    // Only recipient included
    uint8 combinedByteRecipient = 0x02;

    // Only preFund included
    uint8 combinedBytePreFund = 0x04;

    // All three optional fields included (0x01 | 0x02 | 0x04)
    uint8 combinedByteAll = 0x07;

    function _createPaymasterDataMode(
        PackedUserOperation memory userOp,
        uint8 _mode,
        uint8 _combinedByte
    )
        internal
        returns (bytes memory paymasterData)
    {
        uint128 verificationGasLimit = uint128(uint256(bytes32(userOp.accountGasLimits)) >> 128);
        _validWindow();
        if (_mode == VERIFYING_MODE) {
            paymasterData = abi.encodePacked(
                address(pm),
                verificationGasLimit,
                postGas,
                (_mode << 1) | MODE_AND_ALLOW_ALL_BUNDLERS_LENGTH,
                validUntil,
                validAfter
            );
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
                paymasterData = abi.encodePacked(paymasterData, uint128(10_000)); // constantFee (16 bytes)
            }

            if ((_combinedByte & 0x02) != 0) {
                // recipientPresent
                paymasterData = abi.encodePacked(paymasterData, address(sender)); // recipient (20 bytes)
            }
        }
    }

    function _validWindow() internal {
        validUntil = uint48(block.timestamp + 1 days);
        validAfter = 0;
    }

    function _signPaymasterData(
        uint8 _mode,
        PackedUserOperation calldata _userOp,
        uint256 _signerIndx
    )
        external
        view
        returns (bytes memory paymasterSignature)
    {
        bytes32 rawHash = pm.getHash(_mode, _userOp);
        bytes32 ethSignedHash = MessageHashUtils.toEthSignedMessageHash(rawHash);
        uint256 PK = signersPM_PK[_signerIndx];
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(PK, ethSignedHash);

        paymasterSignature = abi.encodePacked(r, s, v);
    }
}
