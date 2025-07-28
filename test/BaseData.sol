// SPDX-License-Identifier: MIT

pragma solidity ^0.8.29;

import {IKey} from "src/interfaces/IKey.sol";
import {SpendLimit} from "src/utils/SpendLimit.sol";

abstract contract BaseData is IKey {
    struct Call {
        address target;
        uint256 value;
        bytes data;
    }

    bytes32 constant RECOVER_TYPEHASH =
        0x9f7aca777caf11405930359f601a4db01fad1b2d79ef3f2f9e93c835e9feffa5;

    uint256 constant RECOVERY_PERIOD = 2 days;
    uint256 constant LOCK_PERIOD = 5 days;
    uint256 constant SECURITY_PERIOD = 1.5 days;
    uint256 constant SECURITY_WINDOW = 0.5 days;

    bytes32 constant TYPE_HASH = keccak256(
        "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
    );

    address constant DEAD_ADDRESS = 0xDeaDbeefdEAdbeefdEadbEEFdeadbeEFdEaDbeeF;
    address constant TOKEN_ADDRESS = 0x9C0b94fb071Ed4066d7C18F4b68968e311A66209;
    address constant UNISWAP_V2 = 0xE592427A0AEce92De3Edee1F18E0157C05861564;

    bytes32 constant PUBLIC_KEY_X =
        hex"1a0b944bca1dd7ced19d36a5d4ef60564789bd611a445ae39f79aa7e384f0d19";
    bytes32 constant PUBLIC_KEY_Y =
        hex"783aa6d5e41a41b1531c3240e0732a3cdc8fd62e4292223fe3ca3716856679c1";

    bytes32 constant P256_PUBLIC_KEY_X =
        hex"0ae5310a8ef116cac6ccd2214edec24f9da2f95b350b9d02547199ebbd4be494";
    bytes32 constant P256_PUBLIC_KEY_Y =
        hex"6521daec3991c406f19a51b43b6c713290dca97719c051e0c35dd4cf4d415835";

    bytes32 constant P256SK_PUBLIC_KEY_X =
        hex"8807f0905b7d439f35e6d992c1998af91b30327350d060cb2e5e8f7434509bdb";
    bytes32 constant P256SK_PUBLIC_KEY_Y =
        hex"e543ea8ba58bd597ef592f834693973c8fcf227e58e446c9524074ceff850034";

    Key internal keyMK;
    PubKey internal pubKeyMK;

    Key internal keySK;
    PubKey internal pubKeySK;

    KeyReg internal keyReg;
    SpendLimit.SpendTokenInfo internal spendInfo;

    bytes32 internal initialGuardian;

    uint256 internal gasUsed;

    function _getMK() internal returns (Key memory, KeyReg memory) {
        pubKeyMK = PubKey({x: PUBLIC_KEY_X, y: PUBLIC_KEY_Y});
        keyMK = Key({pubKey: pubKeyMK, eoaAddress: address(0), keyType: KeyType.WEBAUTHN});
        keyReg = _getKeyReg(type(uint48).max, 0, 0, false, DEAD_ADDRESS, DEAD_ADDRESS, 0, 0);
        return (keyMK, keyReg);
    }

    function _getSK() internal returns (Key memory, KeyReg memory) {
        pubKeySK = PubKey({x: P256_PUBLIC_KEY_X, y: P256_PUBLIC_KEY_Y});
        keySK = Key({pubKey: pubKeySK, eoaAddress: address(0), keyType: KeyType.P256NONKEY});
        keyReg = _getKeyReg(
            uint48(1784980532), 0, uint48(10), true, UNISWAP_V2, TOKEN_ADDRESS, 10e18, 0.1 ether
        );
        return (keySK, keyReg);
    }

    function _getSKP256() internal returns (Key memory, KeyReg memory) {
        pubKeySK = PubKey({x: P256SK_PUBLIC_KEY_X, y: P256SK_PUBLIC_KEY_Y});
        keySK = Key({pubKey: pubKeySK, eoaAddress: address(0), keyType: KeyType.P256NONKEY});
        keyReg = _getKeyReg(
            uint48(1784980532), 0, uint48(10), true, UNISWAP_V2, TOKEN_ADDRESS, 10e18, 0.1 ether
        );
        return (keySK, keyReg);
    }

    function _getSKP256NonExtract() internal returns (Key memory, KeyReg memory) {
        pubKeySK = PubKey({x: P256SK_PUBLIC_KEY_X, y: P256SK_PUBLIC_KEY_Y});
        keySK = Key({pubKey: pubKeySK, eoaAddress: address(0), keyType: KeyType.P256});
        keyReg = _getKeyReg(
            uint48(1784980532), 0, uint48(10), true, UNISWAP_V2, TOKEN_ADDRESS, 10e18, 0.1 ether
        );
        return (keySK, keyReg);
    }

    function _getSKEOA() internal returns (Key memory, KeyReg memory) {
        pubKeySK = PubKey({x: bytes32(0), y: bytes32(0)});
        keySK = Key({pubKey: pubKeySK, eoaAddress: address(1111), keyType: KeyType.EOA});
        keyReg = _getKeyReg(
            uint48(1784980532), 0, uint48(10), true, UNISWAP_V2, TOKEN_ADDRESS, 10e18, 0.1 ether
        );
        return (keySK, keyReg);
    }

    function _getSKEmpty() internal returns (Key memory, KeyReg memory) {
        pubKeySK = PubKey({x: bytes32(0), y: bytes32(0)});
        keySK = Key({pubKey: pubKeySK, eoaAddress: address(0), keyType: KeyType.P256NONKEY});
        keyReg = _getKeyReg(0, 0, 0, false, UNISWAP_V2, TOKEN_ADDRESS, 0, 0);
        return (keySK, keyReg);
    }

    function _getKeyReg(
        uint48 _validUntil,
        uint48 _validAfter,
        uint48 _limit,
        bool _whitelisting,
        address _contractAddress,
        address _token,
        uint256 _limitToken,
        uint256 _ethLimit
    ) internal returns (KeyReg memory) {
        keyReg = KeyReg({
            validUntil: _validUntil,
            validAfter: _validAfter,
            limit: _limit,
            whitelisting: _whitelisting,
            contractAddress: _contractAddress,
            spendTokenInfo: _getSpendTokenInfo(_token, _limitToken),
            allowedSelectors: _allowedSelectors(),
            ethLimit: _ethLimit
        });

        return keyReg;
    }

    function _getSpendTokenInfo(address _token, uint256 _limit)
        internal
        returns (SpendLimit.SpendTokenInfo memory)
    {
        spendInfo = SpendLimit.SpendTokenInfo({token: _token, limit: _limit});
        return spendInfo;
    }

    function _allowedSelectors() internal pure returns (bytes4[] memory sel) {
        sel = new bytes4[](3);
        sel[0] = 0xa9059cbb; // ERC20.transfer
        sel[1] = 0x40c10f19; // ERC20.mint
        sel[2] = 0x00000000; // sentinel/unused
    }
}
