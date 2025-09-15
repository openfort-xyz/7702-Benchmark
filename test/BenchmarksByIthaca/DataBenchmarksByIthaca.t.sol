// SPDX-License-Identifier: MIT

pragma solidity ^0.8.29;

import {IKey} from "src/interfaces/IKey.sol";
import {SpendLimit} from "src/utils/SpendLimit.sol";
import {Test, console2 as console} from "lib/forge-std/src/Test.sol";

contract DataBenchmarksByIthaca is Test, IKey {
    struct Call {
        address target;
        uint256 value;
        bytes data;
    }

    struct KeyDatJson {
        bytes authenticatorData;
        string clientDataJSON;
        uint256 challengeIndex;
        uint256 typeIndex;
        bytes32 r;
        bytes32 s;
        bytes32 x;
        bytes32 y;
    }

    uint256 constant RECOVERY_PERIOD = 2 days;
    uint256 constant LOCK_PERIOD = 5 days;
    uint256 constant SECURITY_PERIOD = 1.5 days;
    uint256 constant SECURITY_WINDOW = 0.5 days;

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

    uint256 internal ownerPK = vm.envUint("PRIVATE_KEY_OWNER");
    address internal owner = vm.addr(ownerPK);

    uint256 internal sessionKeyPk = vm.envUint("PRIVATE_KEY_SESSIONKEY");
    address internal sessionKey = vm.addr(sessionKeyPk);

    uint256 internal senderPK = vm.envUint("PRIVATE_KEY_SENDER");
    address internal sender = vm.addr(senderPK);

    uint256 internal pmPK;
    address internal pmAddr;

    Key internal keyMK;
    PubKey internal pubKeyMK;

    Key internal keySK;
    PubKey internal pubKeySK;

    PubKey internal pubKeyExecuteBatch;

    KeyReg internal keyReg;
    SpendLimit.SpendTokenInfo internal spendInfo;

    bytes32 internal initialGuardian;
}
