// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { P256 } from "lib/openzeppelin-contracts/contracts/utils/cryptography/P256.sol";
import { WebAuthn } from "lib/openzeppelin-contracts/contracts/utils/cryptography/WebAuthn.sol";

contract WenAuthnVerifierOz {
    function verifySignature(
        bytes32 challenge,
        bytes memory authenticatorData,
        string memory clientDataJSON,
        uint256 challengeIndex,
        uint256 typeIndex,
        bytes32 r,
        bytes32 s,
        bytes32 x,
        bytes32 y
    )
        external
        view
        returns (bool isValid)
    {
        WebAuthn.WebAuthnAuth memory auth = WebAuthn.WebAuthnAuth({
            authenticatorData: authenticatorData,
            clientDataJSON: clientDataJSON,
            challengeIndex: challengeIndex,
            typeIndex: typeIndex,
            r: r,
            s: s
        });

        bytes memory challengeBytes = toBytes(challenge);
        isValid = WebAuthn.verify(challengeBytes, auth, x, y);

        return isValid;
    }

    function verifyP256Signature(
        bytes32 hash,
        bytes32 r,
        bytes32 s,
        bytes32 x,
        bytes32 y
    )
        external
        view
        returns (bool isValid)
    {
        return P256.verify(hash, r, s, x, y);
    }

    function toBytes(bytes32 data) private pure returns (bytes memory result) {
        result = new bytes(32);
        assembly {
            mstore(add(result, 32), data)
        }
    }
}
