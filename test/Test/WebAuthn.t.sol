// SPDX-License-Identifier: MIT

pragma solidity ^0.8.29;

import {WebAuthnVerifierV2} from "src/utils/WebAuthnVerifierV2.sol";
import {Test, console2 as console} from "lib/forge-std/src/Test.sol";

contract WebAuthn is Test {
    WebAuthnVerifierV2 internal webAuthn;

    function setUp() public {
        webAuthn = new WebAuthnVerifierV2();
    }

    function test_WebAuthn() public view {
        bool isValid = webAuthn.verifySignature(
            hex"9abf2f87e49505bceda5b7db9eba90738e76c710d38021f27460587bf7885a50",
            true,
            hex"49960de5880e8c687434170f6476605b8fe4aeb9a28632c7995cf3ba831d97631d00000000",
            "{\"type\":\"webauthn.get\",\"challenge\":\"mr8vh-SVBbztpbfbnrqQc452xxDTgCHydGBYe_eIWlA\",\"origin\":\"http://localhost:5173\",\"crossOrigin\":false}",
            23,
            1,
            hex"a7b43cf77581d61371a727b5fc41c5c6aa7d32257dc9ebf5fca4f0ebc0c9642d",
            hex"1c9f262b4a9b7d50d1ec8b89869cbaa9bd2ebc87701cf0971002e22716e6629c",
            hex"c16fa71467ff69cd195443e45a9218e30512057cfc0ca391adef354b1bbaf1ff",
            hex"85a8d9b4fba799b33cad08da24c96e6745919540a23c6510c6dc4e3ede58547e"
        );
        console.log("isValid", isValid);
    }
}
