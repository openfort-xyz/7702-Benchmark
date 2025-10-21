// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { KeysHelper } from "./KeysHelper.t.sol";
import { PackedUserOperation } from "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";

abstract contract UserOpHelper is KeysHelper {
    function _getFreshUserOp(address _owner) internal pure returns (PackedUserOperation memory userOp) {
        userOp = PackedUserOperation({
            sender: _owner,
            nonce: 0,
            initCode: hex"7702",
            callData: hex"",
            accountGasLimits: hex"",
            preVerificationGas: 0,
            gasFees: hex"",
            paymasterAndData: hex"",
            signature: hex""
        });
    }

    function _populateUserOp(
        PackedUserOperation memory _userOp,
        bytes memory _callData,
        bytes32 _accountGasLimits,
        uint256 _preVerificationGas,
        bytes32 _gasFees,
        bytes memory _paymasterAndData
    )
        internal
        view
        returns (PackedUserOperation memory)
    {
        _userOp.nonce = _getNonce();
        _userOp.callData = _callData;
        _userOp.accountGasLimits = _accountGasLimits;
        _userOp.preVerificationGas = _preVerificationGas;
        _userOp.gasFees = _gasFees;
        _userOp.paymasterAndData = _paymasterAndData;

        return _userOp;
    }

    function _getUserOpHash(PackedUserOperation memory _userOp) internal view returns (bytes32 hash) {
        hash = entryPoint.getUserOpHash(_userOp);
    }

    function _getNonce() internal view returns (uint256) {
        return entryPoint.getNonce(owner7702, 1);
    }

    function _signUserOp(PackedUserOperation memory _userOp) internal view returns (bytes memory signature) {
        bytes32 userOpHash = _getUserOpHash(_userOp);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(owner7702PK, userOpHash);
        signature = abi.encodePacked(r, s, v);
    }

    function _signUserOp(
        PackedUserOperation memory _userOp,
        uint256 _pK
    )
        internal
        view
        returns (bytes memory signature)
    {
        bytes32 userOpHash = _getUserOpHash(_userOp);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(_pK, userOpHash);
        signature = abi.encodePacked(r, s, v);
    }

    function _signUserOpWithSK(PackedUserOperation memory _userOp) internal view returns (bytes memory signature) {
        bytes32 userOpHash = _getUserOpHash(_userOp);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(sessionKeyPK, userOpHash);
        signature = abi.encodePacked(r, s, v);
    }

    function _getSignedUserOpByWebAuthn(
        WebAuthn memory _wA,
        PubKey memory _pK_
    )
        internal
        pure
        returns (bytes memory signature)
    {
        signature = _encodeWebAuthnSignature(
            _wA.UVR,
            _wA.AUTHENTICATOR_DATA,
            _wA.CLIENT_DATA_JSON,
            _wA.CHALLENGE_INDEX,
            _wA.TYPE_INDEX,
            _wA.R,
            _wA.S,
            _pK_
        );
    }

    function _packAccountGasLimits(
        uint256 callGasLimit,
        uint256 verificationGasLimit
    )
        internal
        pure
        returns (bytes32)
    {
        return bytes32((callGasLimit << 128) | verificationGasLimit);
    }

    function _packGasFees(uint256 maxFeePerGas, uint256 maxPriorityFeePerGas) internal pure returns (bytes32) {
        return bytes32((maxFeePerGas << 128) | maxPriorityFeePerGas);
    }
}
