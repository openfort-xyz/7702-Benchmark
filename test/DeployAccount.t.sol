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

    function test_AfterDeploy7702() external view {
        assertEq(address(entryPoint), address(implementation.entryPoint()));
        assertEq(address(webAuthn), implementation.webAuthnVerifier());
        assertEq(address(gasPolicy), implementation.gasPolicy());
        assertEq(address(implementation), implementation._OPENFORT_CONTRACT_ADDRESS());
    }

    function test_AfterDeployPaymaster() external view {
        uint256 sC = pm.signerCount();
        assertEq(sC, signersPM.length);
        for (uint256 i = 0; i < sC;) {
            address signer = pm.signerAt(i);
            assertEq(signer, signersPM[i]);
            unchecked {
                i++;
            }
        }
        address getOwner = pm.OWNER();
        address getManager = pm.MANAGER();

        assertEq(ownerPM, getOwner);
        assertEq(managerPM, getManager);
    }

    function test_Attched7702() external view {
        bytes memory code = owner7702.code;
        bytes memory designator = abi.encodePacked(bytes3(0xef0100), address(implementation));

        assertEq(code, designator);
    }
}
