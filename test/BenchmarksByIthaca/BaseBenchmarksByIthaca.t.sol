// SPDX-License-Identifier: MIT

pragma solidity ^0.8.29;

import {SpendLimit} from "src/utils/SpendLimit.sol";
import {DataBenchmarksByIthaca} from "test/BenchmarksByIthaca/DataBenchmarksByIthaca.t.sol";

contract BaseBenchmarksByIthaca is DataBenchmarksByIthaca {
    address internal _ENTRY_POINT_V8 = 0x4337084D9E255Ff0702461CF8895CE9E3b5Ff108;

    bytes32 constant RECOVER_TYPEHASH =
        0x9f7aca777caf11405930359f601a4db01fad1b2d79ef3f2f9e93c835e9feffa5;
    bytes32 constant TYPE_HASH = keccak256(
        "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
    );

    function _getFreshMKWebAuthn() internal returns (Key memory, KeyReg memory) {
        pubKeyMK = PubKey({x: PUBLIC_KEY_X, y: PUBLIC_KEY_Y});
        keyMK = Key({pubKey: pubKeyMK, eoaAddress: address(0), keyType: KeyType.WEBAUTHN});
        keyReg = _getKeyReg(type(uint48).max, 0, 0, false, address(0), address(0), 0, 0);
        return (keyMK, keyReg);
    }

    function _getSKEmpty() internal returns (Key memory, KeyReg memory) {
        pubKeySK = PubKey({x: bytes32(0), y: bytes32(0)});
        keySK = Key({pubKey: pubKeySK, eoaAddress: address(0), keyType: KeyType.P256NONKEY});
        keyReg = _getKeyReg(
            uint48(1784980532), 0, uint48(10), true, address(0), address(0), 10e18, 0.1 ether
        );
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
        sel = new bytes4[](6);
        sel[0] = 0xa9059cbb; // ERC20.transfer
        sel[1] = 0x40c10f19; // ERC20.mint
        sel[2] = 0x095ea7b3; // ERC20.approve
        sel[3] = 0x00000000; // Send Native
    }

    function _packAccountGasLimits(uint256 callGasLimit, uint256 verificationGasLimit)
        internal
        pure
        returns (bytes32)
    {
        return bytes32((callGasLimit << 128) | verificationGasLimit);
    }

    function _packGasFees(uint256 maxFeePerGas, uint256 maxPriorityFeePerGas)
        internal
        pure
        returns (bytes32)
    {
        return bytes32((maxFeePerGas << 128) | maxPriorityFeePerGas);
    }
}
