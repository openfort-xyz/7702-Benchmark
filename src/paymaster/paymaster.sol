// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {BasePaymaster} from "lib/account-abstraction/contracts/core/BasePaymaster.sol";
import {IEntryPoint} from "lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";
import {PackedUserOperation} from
    "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";

contract Paymaster is BasePaymaster {
    constructor(IEntryPoint _ep) BasePaymaster(_ep) {}

    function _validatePaymasterUserOp(
        PackedUserOperation calldata userOp,
        bytes32 userOpHash,
        uint256 maxCost
    ) internal pure override returns (bytes memory context, uint256 validationData) {
        (userOp, userOpHash, maxCost);
        return ("", 0);
    }

    function _postOp(
        PostOpMode mode,
        bytes calldata context,
        uint256 actualGasCost,
        uint256 actualUserOpFeePerGas
    ) internal pure override {
        (mode, context, actualGasCost, actualUserOpFeePerGas);
    }
}
