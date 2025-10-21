// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { Data } from "test/data/Data.t.sol";

abstract contract KeysHelper is Data {
    function _createQuickFreshKey(bool _isMK) internal {
        if (_isMK) {
            mkReg = KeyDataReg({
                keyType: KeyType.WEBAUTHN,
                validUntil: type(uint48).max,
                validAfter: 0,
                limits: 0,
                key: abi.encode(keccak256("x.WebAuthn"), keccak256("y.WebAuthn")),
                keyControl: KeyControl.Self
            });
        } else if (!_isMK) {
            skReg = KeyDataReg({
                keyType: KeyType.P256NONKEY,
                validUntil: uint48(block.timestamp + 10 days),
                validAfter: 0,
                limits: 10,
                key: abi.encode(keccak256("x.P256"), keccak256("y.P256")),
                keyControl: KeyControl.Self
            });
        }
    }

    function _createCustomFreshKey(
        bool _isMK,
        KeyType _kT,
        uint48 _vU,
        uint48 _vA,
        uint48 _l,
        bytes memory _key,
        KeyControl _kC
    )
        internal
    {
        if (_isMK) {
            mkReg =
                KeyDataReg({ keyType: _kT, validUntil: _vU, validAfter: _vA, limits: _l, key: _key, keyControl: _kC });
        } else if (!_isMK) {
            skReg =
                KeyDataReg({ keyType: _kT, validUntil: _vU, validAfter: _vA, limits: _l, key: _key, keyControl: _kC });
        }
    }

    function _getKeyEOA(address _eoa) internal pure returns (bytes memory _key) {
        _key = abi.encode(_eoa);
    }

    function _getKeyP256(PubKey memory _pK) internal pure returns (bytes memory _key) {
        _key = abi.encode(_pK.x, _pK.y);
    }

    function _computeKeyId(KeyType _keyType, bytes memory _key) internal pure returns (bytes32 result) {
        uint256 v0 = uint8(_keyType);
        uint256 v1 = uint256(keccak256(_key));
        assembly {
            mstore(0x00, v0)
            mstore(0x20, v1)
            result := keccak256(0x00, 0x40)
        }
    }

    function _computeKeyId(KeyDataReg memory _keyData) internal pure returns (bytes32) {
        return _computeKeyId(_keyData.keyType, _keyData.key);
    }

    function _encodeEOASignature(bytes memory _signature) internal pure returns (bytes memory) {
        return abi.encode(KeyType.EOA, _signature);
    }

    function _encodeWebAuthnSignature(
        bool requireUserVerification,
        bytes memory authenticatorData,
        string memory clientDataJSON,
        uint256 challengeIndex,
        uint256 typeIndex,
        bytes32 r,
        bytes32 s,
        PubKey memory pubKey
    )
        internal
        pure
        returns (bytes memory)
    {
        bytes memory inner = abi.encode(
            requireUserVerification, authenticatorData, clientDataJSON, challengeIndex, typeIndex, r, s, pubKey
        );

        return abi.encode(KeyType.WEBAUTHN, inner);
    }

    function _encodeP256Signature(
        bytes32 r,
        bytes32 s,
        PubKey memory pubKey,
        KeyType _keyType
    )
        internal
        pure
        returns (bytes memory)
    {
        bytes memory inner = abi.encode(r, s, pubKey);
        return abi.encode(_keyType, inner);
    }
}
