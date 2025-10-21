// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { OPFMain } from "src/core/OPFMain.sol";
import { ExecutionHelper } from "test/helpers/ExecutionHelper.t.sol";

contract DeployAccount is ExecutionHelper {
    function setUp() public virtual override {
        super.setUp();
        vm.startPrank(sender);
        implementation =
            new OPFMain(address(entryPoint), address(webAuthn), address(gasPolicy), address(socialRecoveryManager));
        _etch();
        vm.stopPrank();

        _deal();
    }

    function _deal() public {
        deal(owner7702, 10e18);
        deal(sender, 10e18);
    }
}
