// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { UserOpHelper } from "./UserOpHelper.t.sol";
import { SocialRecoveryManager } from "src/utils/SocialRecover.sol";

abstract contract ExecutionHelper is UserOpHelper {
    /// --------------------------------------------------------------------------------- Struct
    struct Call {
        address target;
        uint256 value;
        bytes data;
    }

    function _createCall(
        address _target,
        uint256 _value,
        bytes memory _data
    )
        internal
        pure
        returns (Call memory call)
    {
        call = Call({ target: _target, value: _value, data: _data });
    }

    function _getCalls(
        uint256 _indx,
        address _target,
        uint256 _value,
        bytes memory _data
    )
        internal
        pure
        returns (Call[] memory calls)
    {
        calls = new Call[](_indx);
        for (uint256 i = 0; i < _indx;) {
            calls[i] = _createCall(_target, _value, _data);
            unchecked {
                ++i;
            }
        }
    }

    function _callRecoveryManager(bytes memory data) internal {
        Call[] memory calls = new Call[](1);
        calls[0] = _createCall(address(socialRecoveryManager), 0, data);

        _etch();
        vm.prank(owner7702);
        account.execute(mode_1, abi.encode(calls));
    }

    function _proposeGuardian(bytes32 guardian) internal {
        bytes memory data =
            abi.encodeWithSelector(SocialRecoveryManager.proposeGuardian.selector, address(account), guardian);
        _callRecoveryManager(data);
    }

    function _confirmGuardian(bytes32 guardian) internal {
        bytes memory data =
            abi.encodeWithSelector(SocialRecoveryManager.confirmGuardianProposal.selector, address(account), guardian);
        _callRecoveryManager(data);
    }

    function _cancelGuardianProposal(bytes32 guardian) internal {
        bytes memory data =
            abi.encodeWithSelector(SocialRecoveryManager.cancelGuardianProposal.selector, address(account), guardian);
        _callRecoveryManager(data);
    }

    function _revokeGuardian(bytes32 guardian) internal {
        bytes memory data =
            abi.encodeWithSelector(SocialRecoveryManager.revokeGuardian.selector, address(account), guardian);
        _callRecoveryManager(data);
    }

    function _confirmGuardianRevocation(bytes32 guardian) internal {
        bytes memory data =
            abi.encodeWithSelector(SocialRecoveryManager.confirmGuardianRevocation.selector, address(account), guardian);
        _callRecoveryManager(data);
    }

    function _cancelGuardianRevocation(bytes32 guardian) internal {
        bytes memory data =
            abi.encodeWithSelector(SocialRecoveryManager.cancelGuardianRevocation.selector, address(account), guardian);
        _callRecoveryManager(data);
    }

    function _cancelRecovery() internal {
        bytes memory data = abi.encodeWithSelector(SocialRecoveryManager.cancelRecovery.selector, address(account));
        _callRecoveryManager(data);
    }
}
