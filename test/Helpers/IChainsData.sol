// SPDX-License-Identifier: MIT

pragma solidity ^0.8.29;

import {Interfaces} from "test/helpers/Interfaces.sol";

interface IChainsData is Interfaces {
    function getRPCs() external view returns (ChainRPC[] memory);
    function getFeesFlat(string calldata name)
        external
        view
        returns (
            uint256 gasPrice,
            bool    isOPStack,
            uint256 l2GasPrice,
            uint256 l1BaseFee,
            uint256 l1BaseFeeScalar,
            uint256 blobBaseFee,
            uint256 blobBaseFeeScalar
        );
    function getEthPriceUsdE8() external view returns (uint256);
}