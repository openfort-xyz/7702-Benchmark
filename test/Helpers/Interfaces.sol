// SDPX-license-Identifier: MIT

pragma solidity ^0.8.29;

interface Interfaces {
    struct ChainRPC {
        string url;
        string name;
    }

    struct OPStackFeeParams {
        uint256 l2GasPrice;
        uint256 l1BaseFee;
        uint256 l1BaseFeeScalar;
        uint256 blobBaseFee;
        uint256 blobBaseFeeScalar;
    }

    struct ChainFees {
        uint256 gasPrice;
        bool isOPStack;
        OPStackFeeParams op;
    }
}