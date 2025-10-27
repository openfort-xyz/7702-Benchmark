// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { VmSafe } from "lib/forge-std/src/Vm.sol";
import { DeployAccount } from "test/DeployAccount.t.sol";
import { IKeysManager } from "src/interfaces/IKeysManager.sol";
import { console2 as console } from "lib/forge-std/src/Test.sol";
import { PackedUserOperation } from "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";

contract BenchmarksP256SessionKeyNative is DeployAccount {
    address internal reciver;
    PubKey internal pK_SK;

    function setUp() public override {
        super.setUp();
        reciver = makeAddr("reciver");
        _createQuickFreshKey(true);
        _populateP256NON("P256SessionKey.json", ".native.DirectAA.result2");
        pK_SK = PubKey({ x: DEF_P256.X, y: DEF_P256.Y });
        _createCustomFreshKey(
            false, KeyType.P256NONKEY, uint48(block.timestamp + 1 days), 0, 10, _getKeyP256(pK_SK), KeyControl.Self
        );
        _initializeAccount();
        _mint(owner7702, 3000e18);
        _approveAll(address(erc20), owner7702, type(uint256).max, address(pm));
        _warmUpAccount();
    }

    function test_SendNativeCallWithP256SessionKeyDirectAA() external {
        Call[] memory calls = _getCalls(1, reciver, 0.3 ether, hex"");

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        userOp = _populateUserOp(
            userOp,
            _packCallData(mode_1, calls),
            _packAccountGasLimits(600_000, 400_000),
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            hex""
        );

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateP256NON("P256SessionKey.json", ".native.DirectAA.result2");
        pK_SK = PubKey({ x: DEF_P256.X, y: DEF_P256.Y });

        userOp.signature = _encodeP256Signature(DEF_P256.R, DEF_P256.S, pK_SK, KeyType.P256NONKEY);

        _relayUserOp(userOp, "test_SendNativeCallWithP256SessionKeyDirectAA");
    }

    function test_SendNativeCallWithP256SessionKeyAASponsored() external {
        Call[] memory calls = _getCalls(1, reciver, 0.3 ether, hex"");

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, VERIFYING_MODE, 0);
        userOp = _populateUserOp(
            userOp,
            _packCallData(mode_1, calls),
            accountGasLimits,
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(VERIFYING_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateP256NON("P256SessionKey.json", ".native.AASponsored.result2");
        pK_SK = PubKey({ x: DEF_P256.X, y: DEF_P256.Y });

        userOp.signature = _encodeP256Signature(DEF_P256.R, DEF_P256.S, pK_SK, KeyType.P256NONKEY);

        _relayUserOp(userOp, "test_SendNativeCallWithP256SessionKeyAASponsored");
    }

    function test_SendNativeCallWithP256SessionKeyAASponsoredERC20() external {
        Call[] memory calls = _getCalls(1, reciver, 0.3 ether, hex"");

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        userOp = _populateUserOp(
            userOp,
            _packCallData(mode_1, calls),
            accountGasLimits,
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateP256NON("P256SessionKey.json", ".native.AASponsoredERC20.result2");
        pK_SK = PubKey({ x: DEF_P256.X, y: DEF_P256.Y });

        userOp.signature = _encodeP256Signature(DEF_P256.R, DEF_P256.S, pK_SK, KeyType.P256NONKEY);

        _relayUserOp(userOp, "test_SendNativeCallWithP256SessionKeyAASponsoredERC20");
    }

    function _relayUserOp(PackedUserOperation memory _userOp, string memory _testName) internal {
        PackedUserOperation[] memory ops = new PackedUserOperation[](1);
        ops[0] = _userOp;

        _etch();
        vm.prank(sender);
        entryPoint.handleOps(ops, payable(sender));
        if (bytes(_testName).length > 0) {
            vm.snapshotGasLastCall(_testName);
            VmSafe.Gas memory gas = vm.lastCallGas();
        }
    }

    function _warmUpAccount()
        internal
        setTokenSpendM(KeyType.P256NONKEY, _getKeyP256(pK_SK), NATIVE_ADDRESS, 30 ether, IKeysManager.SpendPeriod.Month)
        setCanCallM(KeyType.P256NONKEY, _getKeyP256(pK_SK), NATIVE_ADDRESS, EMPTY_CALLDATA_FN_SEL, true)
        setCanCallM(KeyType.P256NONKEY, _getKeyP256(pK_SK), reciver, EMPTY_CALLDATA_FN_SEL, true)
    {
        _depositToPM();

        Call[] memory calls = _getCalls(1, reciver, 0.1 ether, hex"");

        bytes memory executionData = abi.encode(calls);
        _etch();
        vm.prank(owner7702);
        account.execute(mode_1, executionData);

        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        bytes32 gasFees = _packGasFees(80 gwei, 15 gwei);
        uint256 preVerificationGas = 800_000;

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        userOp =
            _populateUserOp(userOp, _packCallData(mode_1, calls), accountGasLimits, preVerificationGas, gasFees, hex"");

        bytes memory signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "");

        userOp = _getFreshUserOp(owner7702);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, VERIFYING_MODE, 0);
        userOp = _populateUserOp(
            userOp, _packCallData(mode_1, calls), accountGasLimits, preVerificationGas, gasFees, paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(VERIFYING_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "");

        userOp = _getFreshUserOp(owner7702);
        userOp.accountGasLimits = accountGasLimits;
        paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        userOp = _populateUserOp(
            userOp, _packCallData(mode_1, calls), accountGasLimits, preVerificationGas, gasFees, paymasterAndData
        );

        paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "");
    }
}
