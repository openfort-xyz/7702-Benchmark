// SPDX-License-Identifier: MIT

pragma solidity ^0.8.29;

import {ECDSA} from "lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol";

abstract contract RecoverSigner {
    function recoverSigenr(bytes32 _hash, bytes memory _signature) public pure returns (address) {
        return ECDSA.recover(_hash, _signature);
    }
}
