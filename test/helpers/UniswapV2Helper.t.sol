// SPDX-License-Identifier: MIT

pragma solidity ^0.8.29;

import { PaymasterHelper } from "test/helpers/PaymasterHelper.t.sol";

interface IUniswapV2Router {
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (uint256 amountA, uint256 amountB, uint256 liquidity);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    )
        external
        returns (uint256[] memory amounts);
}

abstract contract UniswapV2Helper is PaymasterHelper {
    function _uniswapV2SwapPayload() internal view returns (bytes memory) {
        address[] memory path = new address[](2);
        path[0] = token0;
        path[1] = token1;

        return abi.encodeWithSelector(
            IUniswapV2Router.swapTokensForExactTokens.selector, 1, 11, path, address(0xbabe), block.timestamp + 999
        );
    }
}

import { ERC20 } from "lib/solady/src/tokens/ERC20.sol";

contract MockPaymentToken is ERC20 {
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function anotherTransfer(address to, uint256 amount) public returns (bool) {
        transfer(to, amount);
        return true;
    }

    function name() public view virtual override returns (string memory) {
        return "Name";
    }

    function symbol() public view virtual override returns (string memory) {
        return "SYM";
    }
}
