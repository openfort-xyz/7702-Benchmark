// SPDX-License-Identifier: MIT

pragma solidity ^0.8.29;

import {UserOperationLib} from "lib/account-abstraction/contracts/core/UserOperationLib.sol";

contract PaymasterDataBenchmarksByIthaca {
    uint256 ownerPM_PK;
    address ownerPM;
    uint256 managerPM_PK;
    address managerPM;
    uint256[] signersPM_PK;
    address[] signersPM;

    uint256 constant signersLength = 3;

    address treasury;
    uint8 constant ERC20_MODE = 1;
    uint8 constant VERIFYING_MODE = 0;
    uint8 constant ERC20_PAYMASTER_DATA_LENGTH = 117;
    uint8 immutable VERIFYING_PAYMASTER_DATA_LENGTH = 12;
    uint8 immutable MODE_AND_ALLOW_ALL_BUNDLERS_LENGTH = 1;
    uint256 immutable PAYMASTER_DATA_OFFSET = UserOperationLib.PAYMASTER_DATA_OFFSET;

    uint48 validUntil;
    uint48 validAfter;
    uint128 constant postGas = 50000;
    uint128 constant paymasterValidationGasLimit = 100000;
    uint256 constant preVerificationGas = 800_000;
    uint256 exchangeRate = 1_000_000;
    uint256 requiredPreFund = 1000000;
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
}
