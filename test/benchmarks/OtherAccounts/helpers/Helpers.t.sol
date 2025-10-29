// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { Data } from "test/benchmarks/OtherAccounts/data/Data.t.sol";
import { IUniswapV2Router } from "test/benchmarks/OtherAccounts/interfaces/IUniswapV2Router.sol";
import { UserOperation, IERC4337EntryPointV6 } from "test/benchmarks/OtherAccounts/interfaces/IERC4337EntryPoint.sol";
import { PimlicoHelpers } from "test/benchmarks/OtherAccounts/interfaces/IPimlicoPaymaster.sol";
import { SignatureCheckerLib } from "lib/solady/src/utils/SignatureCheckerLib.sol";

contract Helpers is Data {
    struct Call {
        address target;
        uint256 value;
        bytes data;
    }

    function _uniswapV2SwapPayload() internal view returns (bytes memory) {
        address[] memory path = new address[](2);
        path[0] = token0;
        path[1] = token1;

        return abi.encodeWithSelector(
            IUniswapV2Router.swapTokensForExactTokens.selector, 1, 11, path, address(0xbabe), block.timestamp + 999
        );
    }

    function _eoaSig(uint256 privateKey, bytes32 digest) internal pure returns (bytes memory) {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, digest);
        return abi.encodePacked(r, s, v);
    }

    function _createCall(address _target, uint256 _value, bytes memory _data) internal pure returns (Call memory) {
        return Call({ target: _target, value: _value, data: _data });
    }

    function _getCalls(
        uint256 _count,
        address _target,
        uint256 _value,
        bytes memory _data
    )
        internal
        pure
        returns (Call[] memory calls)
    {
        calls = new Call[](_count);
        for (uint256 i = 0; i < _count; i++) {
            calls[i] = _createCall(_target, _value, _data);
        }
    }

    function _getFreshUserOpV6(address _sender) internal pure returns (UserOperation memory) {
        return UserOperation({
            sender: _sender,
            nonce: 0,
            initCode: hex"",
            callData: hex"",
            callGasLimit: 0,
            verificationGasLimit: 0,
            preVerificationGas: 0,
            maxFeePerGas: 0,
            maxPriorityFeePerGas: 0,
            paymasterAndData: hex"",
            signature: hex""
        });
    }

    function _populateUserOpV6(
        UserOperation memory _userOp,
        bytes memory _callData,
        uint256 _callGasLimit,
        uint256 _verificationGasLimit,
        uint256 _preVerificationGas,
        uint256 _maxFeePerGas,
        uint256 _maxPriorityFeePerGas,
        bytes memory _paymasterAndData
    )
        internal
        view
        returns (UserOperation memory)
    {
        _userOp.nonce = erc4337EntryPointV6.getNonce(_userOp.sender, 0);
        _userOp.callData = _callData;
        _userOp.callGasLimit = _callGasLimit;
        _userOp.verificationGasLimit = _verificationGasLimit;
        _userOp.preVerificationGas = _preVerificationGas;
        _userOp.maxFeePerGas = _maxFeePerGas;
        _userOp.maxPriorityFeePerGas = _maxPriorityFeePerGas;
        _userOp.paymasterAndData = _paymasterAndData;
        return _userOp;
    }

    function _signUserOpV6(UserOperation memory _userOp, uint256 _privateKey) internal view returns (bytes memory) {
        bytes32 userOpHash = erc4337EntryPointV6.getUserOpHash(_userOp);
        return _eoaSig(_privateKey, userOpHash);
    }

    function _createPimlicoPaymasterDataERC20(UserOperation calldata _userOp) internal view returns (bytes memory) {
        bytes memory paymasterData = abi.encodePacked(
            _PIMLICO_PAYMASTER_V06,
            uint8(1) | uint8(1 << 1),
            uint8(0),
            type(uint48).max,
            uint48(0),
            paymentToken,
            uint128(100_000),
            uint256(1e18),
            uint128(100_000),
            relayer
        );

        bytes32 hash = PimlicoHelpers.getHashV6(1, _userOp);
        bytes memory signature = _eoaSig(paymasterPrivateKey, SignatureCheckerLib.toEthSignedMessageHash(hash));

        return abi.encodePacked(paymasterData, signature);
    }

    function _createPimlicoPaymasterDataVerifying(UserOperation calldata _userOp)
        internal
        view
        returns (bytes memory)
    {
        bytes memory paymasterData = abi.encodePacked(_PIMLICO_PAYMASTER_V06, uint8(1), type(uint48).max, uint48(0));

        bytes32 hash = PimlicoHelpers.getHashV6(0, _userOp);
        bytes memory signature = _eoaSig(paymasterPrivateKey, SignatureCheckerLib.toEthSignedMessageHash(hash));

        return abi.encodePacked(paymasterData, signature);
    }
}
