// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Strings} from "lib/openzeppelin-contracts/contracts/utils/Strings.sol";

library FeeCalc {
    using Strings for uint256;

    uint256 internal constant SCALAR_BASE = 1e6;

    function ethOrArbCostWei(uint256 gasUsed, uint256 gasPrice) internal pure returns (uint256) {
        return gasUsed * gasPrice;
    }

    function opStackCostWeiEcotone(
        uint256 l2GasUsed,
        uint256 l2GasPrice,
        uint256 zeroBytes,
        uint256 nonZeroBytes,
        uint256 baseFee,
        uint256 baseFeeScalar,
        uint256 blobBaseFee,
        uint256 blobBaseFeeScalar
    ) internal pure returns (uint256 total) {
        uint256 l2Cost = l2GasUsed * l2GasPrice;

        uint256 txCompressedSize = (zeroBytes * 4 + nonZeroBytes * 16) / 16;

        uint256 weightedGasPrice =
            (16 * baseFeeScalar * baseFee + blobBaseFeeScalar * blobBaseFee) / SCALAR_BASE;

        uint256 l1Cost = txCompressedSize * weightedGasPrice;

        total = l2Cost + l1Cost;
    }

    function opStackCostWeiFjord(
        uint256 l2GasUsed,
        uint256 l2GasPrice,
        uint256 estimatedCompressedSize,
        uint256 baseFee,
        uint256 baseFeeScalar,
        uint256 blobBaseFee,
        uint256 blobBaseFeeScalar
    ) internal pure returns (uint256 total) {
        uint256 l2Cost = l2GasUsed * l2GasPrice;
        uint256 weightedGasPrice =
            (16 * baseFeeScalar * baseFee + blobBaseFeeScalar * blobBaseFee) / SCALAR_BASE;
        uint256 l1Cost = estimatedCompressedSize * weightedGasPrice;
        total = l2Cost + l1Cost;
    }

    function countData(bytes memory data) internal pure returns (uint256 zeroBytes, uint256 nonZeroBytes) {
        uint256 len = data.length;
        for (uint256 i; i < len; i++) {
            if (data[i] == 0) zeroBytes++;
            else nonZeroBytes++;
        }
    }

    function toUsdE8(uint256 weiAmount, uint256 ethPriceUsdE8) internal pure returns (uint256) {
        return (weiAmount * ethPriceUsdE8) / 1e18;
    }

    function usdE8ToString(uint256 usdE8, uint8 decimals) internal pure returns (string memory) {
        uint256 intPart = usdE8 / 1e8;

        if (decimals == 0) {
            return intPart.toString();
        }

        uint256 scale = 10 ** decimals;
        uint256 fracRaw = (usdE8 % 1e8) / (1e8 / scale);

        string memory frac = fracRaw.toString();
        uint256 len = bytes(frac).length;
        while (len < decimals) {
            frac = string.concat("0", frac);
            len++;
        }

        return string.concat(intPart.toString(), ".", frac);
    }
}