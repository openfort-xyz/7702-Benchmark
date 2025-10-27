// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { Test } from "lib/forge-std/src/Test.sol";
import { OPFMain } from "src/core/OPFMain.sol";

contract DeployOPFAcc7702 is Test {
    function deployOPFMain(
        address _entryPoint,
        address _webAuthnVerifier,
        address _gasPolicy,
        address _recoveryManager
    )
        external
    {
        new OPFMain(_entryPoint, _webAuthnVerifier, _gasPolicy, _recoveryManager);
    }

    function test_DeployContractCall() external {
        this.deployOPFMain(address(0x1), address(0x2), address(0x3), address(0x4));
        vm.snapshotGasLastCall("test_DeployContractCall");
    }
}
