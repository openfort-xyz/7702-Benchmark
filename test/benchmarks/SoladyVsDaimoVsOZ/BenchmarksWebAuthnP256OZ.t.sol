// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { VmSafe } from "lib/forge-std/src/Vm.sol";
import { DeployAccount } from "test/DeployAccount.t.sol";
import { IKeysManager } from "src/interfaces/IKeysManager.sol";
import { console2 as console } from "lib/forge-std/src/Test.sol";
import { EfficientHashLib } from "lib/solady/src/utils/EfficientHashLib.sol";
import { PackedUserOperation } from "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";

contract BenchmarksWebAuthnP256OZ is DeployAccount {
    address internal reciver;
    PubKey internal pK;
    PubKey internal pK_SK;

    function setUp() public override {
        super.setUp();
    }

    function test_WebAuthn() external {
        bytes32 challenge = 0x4d565978a82a98ccf6e2c5c4ed19645fd05339c2b2fdb9659ceacb76464c8616;
        _populateWebAuthn("WebAuthnMasterKey.json", ".empty.DirectAA");
        vm.prank(owner7702);
        bool isValid = webAuthnOz.verifySignature(
            challenge,
            DEF_WEBAUTHN.AUTHENTICATOR_DATA,
            DEF_WEBAUTHN.CLIENT_DATA_JSON,
            DEF_WEBAUTHN.CHALLENGE_INDEX,
            DEF_WEBAUTHN.TYPE_INDEX,
            DEF_WEBAUTHN.R,
            DEF_WEBAUTHN.S,
            DEF_WEBAUTHN.X,
            DEF_WEBAUTHN.Y
        );
        vm.snapshotGasLastCall("test_WebAuthn");
        assertTrue(isValid);
    }

    function test_P256() external {
        bytes32 challenge = EfficientHashLib.sha2(0x4d565978a82a98ccf6e2c5c4ed19645fd05339c2b2fdb9659ceacb76464c8616);
        _populateP256NON("P256SessionKey.json", ".empty.DirectAA.result2");
        vm.prank(owner7702);
        bool isValid = webAuthnOz.verifyP256Signature(challenge, DEF_P256.R, DEF_P256.S, DEF_P256.X, DEF_P256.Y);
        vm.snapshotGasLastCall("test_P256");
        assertTrue(isValid);
    }
}
