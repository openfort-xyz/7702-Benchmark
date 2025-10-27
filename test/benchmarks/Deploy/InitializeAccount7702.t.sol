// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { DeployAccount } from "test/DeployAccount.t.sol";
import { MessageHashUtils } from "lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol";

contract InitializeAccount7702 is DeployAccount {
    function setUp() public override {
        super.setUp();
    }

    function test_InitializeWithoutSessionKeyBenchmark() external {
        _createQuickFreshKey(true);
        vm.prank(owner7702);
        account.initialize(mkReg, skReg, _getSignature(), _initialGuardian);
        vm.snapshotGasLastCall("test_InitializeWithoutSessionKeyBenchmark");
    }

    function test_InitializeWithSessionKeyBenchmark() external {
        _quickInitializeAccount();
        vm.prank(owner7702);
        account.initialize(mkReg, skReg, _getSignature(), _initialGuardian);
        vm.snapshotGasLastCall("test_InitializeWithSessionKeyBenchmark");
    }

    function _getSignature() internal view returns (bytes memory signature) {
        bytes memory mkDataEnc =
            abi.encode(mkReg.keyType, mkReg.validUntil, mkReg.validAfter, mkReg.limits, mkReg.key, mkReg.keyControl);

        bytes memory skDataEnc =
            abi.encode(skReg.keyType, skReg.validUntil, skReg.validAfter, skReg.limits, skReg.key, skReg.keyControl);

        bytes32 structHash = keccak256(abi.encode(INIT_TYPEHASH, mkDataEnc, skDataEnc, _initialGuardian));

        string memory name = "OPF7702Recoverable";
        string memory version = "1";

        bytes32 domainSeparator = keccak256(
            abi.encode(TYPE_HASH, keccak256(bytes(name)), keccak256(bytes(version)), block.chainid, owner7702)
        );
        bytes32 digest = MessageHashUtils.toTypedDataHash(domainSeparator, structHash);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(owner7702PK, digest);
        signature = abi.encodePacked(r, s, v);
    }
}
