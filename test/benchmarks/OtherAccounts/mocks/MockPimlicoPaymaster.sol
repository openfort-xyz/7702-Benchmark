// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { IPaymaster06 } from "lib/account-abstraction/contracts/legacy/v06/IPaymaster06.sol";
import { IPaymaster } from "lib/account-abstraction/contracts/interfaces/IPaymaster.sol";
import { PackedUserOperation } from "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";
import { UserOperation } from "test/benchmarks/OtherAccounts/interfaces/IERC4337EntryPoint.sol";

contract MockPimlicoPaymaster {
    mapping(address => bool) internal _signers;
    address internal _token;
    address internal _tokenOracle;

    function setSigner(address signer, bool allowed) external {
        _signers[signer] = allowed;
    }

    function setToken(address token_) external {
        _token = token_;
    }

    function setTokenOracle(address oracle) external {
        _tokenOracle = oracle;
    }

    function tokenOracle() external view returns (address) {
        return _tokenOracle;
    }

    function token() external view returns (address) {
        return _token;
    }

    function signers(address signer) external view returns (bool) {
        return _signers[signer];
    }

    // --- ERC-4337 v0.6 compatibility -------------------------------------------------
    function validatePaymasterUserOp(
        UserOperation calldata,
        bytes32,
        uint256
    )
        external
        pure
        returns (bytes memory context, uint256 validationData)
    {
        context = "";
        validationData = 0;
    }

    function postOp(IPaymaster06.PostOpMode, bytes calldata, uint256) external pure { }

    // --- ERC-4337 v0.7+ compatibility -------------------------------------------------
    function validatePaymasterUserOp(
        PackedUserOperation calldata,
        bytes32,
        uint256
    )
        external
        pure
        returns (bytes memory context, uint256 validationData)
    {
        context = "";
        validationData = 0;
    }

    function postOp(IPaymaster.PostOpMode, bytes calldata, uint256, uint256) external pure { }
}
