// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { VmSafe } from "lib/forge-std/src/Vm.sol";
import { DeployAccount } from "test/DeployAccount.t.sol";
import { IKeysManager } from "src/interfaces/IKeysManager.sol";
import { console2 as console } from "lib/forge-std/src/Test.sol";
import { EfficientHashLib } from "lib/solady/src/utils/EfficientHashLib.sol";
import { PackedUserOperation } from "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";

contract BenchmarksWebAuthnP256Diamo is DeployAccount {
    address internal reciver;
    PubKey internal pK;
    PubKey internal pK_SK;

    function setUp() public override {
        super.setUp();
    }

    function test_WebAuthn() external {
        bytes32 challenge = 0x19f15de2bdee93bd00abcbb19fa12d777d27e08c163c3341ae1034ef70665341;
        _populateWebAuthn("WebAuthnMasterKey.json", ".empty.DirectAA");
        vm.prank(owner7702);
        bool isValid = webAuthnDaimo.verifySignature(
            challenge,
            DEF_WEBAUTHN.UVR,
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
        bytes32 challenge = EfficientHashLib.sha2(0x19f15de2bdee93bd00abcbb19fa12d777d27e08c163c3341ae1034ef70665341);
        _populateP256NON("P256SessionKey.json", ".empty.DirectAA.result2");
        uint256 rUint = uint256(DEF_P256.R);
        uint256 sUint = uint256(DEF_P256.S);
        uint256 xUint = uint256(DEF_P256.X);
        uint256 yUint = uint256(DEF_P256.Y);
        vm.prank(owner7702);
        bool isValid = webAuthnDaimo.verifyP256Signature(challenge, rUint, sUint, xUint, yUint);
        vm.snapshotGasLastCall("test_P256");
        assertTrue(isValid);
    }
}
