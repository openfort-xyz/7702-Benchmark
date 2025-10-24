// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { VmSafe } from "lib/forge-std/src/Vm.sol";
import { DeployAccount } from "test/DeployAccount.t.sol";
import { IKeysManager } from "src/interfaces/IKeysManager.sol";
import { console2 as console } from "lib/forge-std/src/Test.sol";
import { PackedUserOperation } from "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";

contract BenchmarksAccountActions is DeployAccount {
    address internal reciver;

    function setUp() public override {
        super.setUp();
        reciver = makeAddr("reciver");
        _quickInitializeAccount();
        _initializeAccount();
        _mint(owner7702, 3000e18);
        _approveAll(address(erc20), owner7702, type(uint256).max, address(pm));
        _warmUpAccount();
    }

    function test_RegisterKeySelfCallWithRootKeyDirect() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);
        vm.snapshotGasLastCall("test_RegisterKeySelfCallWithRootKeyDirect");
    }

    function test_RegisterKeySelfCallWithRootKeyDirectAASponsored() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        bytes memory callData = abi.encodeCall(account.registerKey, (skReg));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, VERIFYING_MODE, 0);
        userOp = _populateUserOp(
            userOp,
            callData,
            accountGasLimits,
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(VERIFYING_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes memory signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "test_RegisterKeySelfCallWithRootKeyDirectAASponsored");
    }

    function test_RegisterKeySelfCallWithRootKeyDirectAASponsoredERC20() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        bytes memory callData = abi.encodeCall(account.registerKey, (skReg));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        userOp = _populateUserOp(
            userOp,
            callData,
            accountGasLimits,
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes memory signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "test_RegisterKeySelfCallWithRootKeyDirectAASponsoredERC20");
    }

    function test_RegisterKeyCustodialCallWithRootKeyDirect() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Custodial);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);
        vm.snapshotGasLastCall("test_RegisterKeyCustodialCallWithRootKeyDirect");
    }

    function test_RegisterKeyCustodialCallWithRootKeyDirectAASponsored() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Custodial);
        bytes memory callData = abi.encodeCall(account.registerKey, (skReg));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, VERIFYING_MODE, 0);
        userOp = _populateUserOp(
            userOp,
            callData,
            accountGasLimits,
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(VERIFYING_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes memory signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "test_RegisterKeyCustodialCallWithRootKeyDirectAASponsored");
    }

    function test_RegisterKeyCustodialCallWithRootKeyDirectAASponsoredERC20() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Custodial);
        bytes memory callData = abi.encodeCall(account.registerKey, (skReg));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        userOp = _populateUserOp(
            userOp,
            callData,
            accountGasLimits,
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes memory signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "test_RegisterKeyCustodialCallWithRootKeyDirectAASponsoredERC20");
    }

    function test_SetTokenSpendCallWithRootKeyDirect() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        _etch();
        vm.prank(owner7702);
        account.setTokenSpend(_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), 1000 ether, IKeysManager.SpendPeriod.Month);
        vm.snapshotGasLastCall("test_SetTokenSpendCallWithRootKeyDirect");
    }

    function test_SetTokenSpendCallWithRootKeyDirectAASponsored() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        bytes memory callData = abi.encodeCall(account.setTokenSpend, (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), 1000 ether, IKeysManager.SpendPeriod.Month));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, VERIFYING_MODE, 0);
        userOp = _populateUserOp(
            userOp,
            callData,
            accountGasLimits,
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(VERIFYING_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes memory signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "test_SetTokenSpendCallWithRootKeyDirectAASponsored");
    }

    function test_SetTokenSpendCallWithRootKeyDirectAASponsoredERC20() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        bytes memory callData = abi.encodeCall(account.setTokenSpend, (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), 1000 ether, IKeysManager.SpendPeriod.Month));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        userOp = _populateUserOp(
            userOp,
            callData,
            accountGasLimits,
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes memory signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "test_SetTokenSpendCallWithRootKeyDirectAASponsoredERC20");
    }

    function test_SetCanCallCallWithRootKeyDirect() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        _etch();
        vm.prank(owner7702);
        account.setCanCall(_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), ANY_FN_SEL, true);
        vm.snapshotGasLastCall("test_SetCanCallCallWithRootKeyDirect");
    }

    function test_SetCanCallCallWithRootKeyDirectAASponsored() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        bytes memory callData = abi.encodeCall(account.setCanCall, (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), ANY_FN_SEL, true));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, VERIFYING_MODE, 0);
        userOp = _populateUserOp(
            userOp,
            callData,
            accountGasLimits,
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(VERIFYING_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes memory signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "test_SetCanCallCallWithRootKeyDirectAASponsored");
    }

    function test_SetCanCallCallWithRootKeyDirectAASponsoredERC20() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        bytes memory callData = abi.encodeCall(account.setCanCall, (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), ANY_FN_SEL, true));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        userOp = _populateUserOp(
            userOp,
            callData,
            accountGasLimits,
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes memory signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "test_SetCanCallCallWithRootKeyDirectAASponsoredERC20");
    }

    function test_UpdateKeyDataCallWithRootKeyDirect() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        _etch();
        vm.prank(owner7702);
        account.updateKeyData(_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), 1855989444, 10000);
        vm.snapshotGasLastCall("test_UpdateKeyDataCallWithRootKeyDirect");
    }

    function test_UpdateKeyDataCallWithRootKeyDirectAASponsored() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        bytes memory callData = abi.encodeCall(account.updateKeyData, (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), 1855989444, 10000));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, VERIFYING_MODE, 0);
        userOp = _populateUserOp(
            userOp,
            callData,
            accountGasLimits,
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(VERIFYING_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes memory signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "test_UpdateKeyDataCallWithRootKeyDirectAASponsored");
    }

    function test_UpdateKeyDataCallWithRootKeyDirectAASponsoredERC20() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        bytes memory callData = abi.encodeCall(account.updateKeyData, (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), 1855989444, 10000));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        userOp = _populateUserOp(
            userOp,
            callData,
            accountGasLimits,
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes memory signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "test_UpdateKeyDataCallWithRootKeyDirectAASponsoredERC20");
    }

    function test_UpdateTokenSpendCallWithRootKeyDirect() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        _etch();
        vm.prank(owner7702);
        account.setTokenSpend(_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), 1000 ether, IKeysManager.SpendPeriod.Month);

        _etch();
        vm.prank(owner7702);
        account.updateTokenSpend(_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), 10000 ether, IKeysManager.SpendPeriod.Year);
        vm.snapshotGasLastCall("test_UpdateTokenSpendCallWithRootKeyDirect");
    }

    function test_UpdateTokenSpendCallWithRootKeyDirectAASponsored() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        _etch();
        vm.prank(owner7702);
        account.setTokenSpend(_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), 1000 ether, IKeysManager.SpendPeriod.Month);

        bytes memory callData = abi.encodeCall(account.updateTokenSpend, (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), 10000 ether, IKeysManager.SpendPeriod.Year));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, VERIFYING_MODE, 0);
        userOp = _populateUserOp(
            userOp,
            callData,
            accountGasLimits,
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(VERIFYING_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes memory signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "test_UpdateTokenSpendCallWithRootKeyDirectAASponsored");
    }

    function test_UpdateTokenSpendCallWithRootKeyDirectAASponsoredERC20() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        _etch();
        vm.prank(owner7702);
        account.setTokenSpend(_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), 1000 ether, IKeysManager.SpendPeriod.Month);

        bytes memory callData = abi.encodeCall(account.updateTokenSpend, (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), 10000 ether, IKeysManager.SpendPeriod.Year));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        userOp = _populateUserOp(
            userOp,
            callData,
            accountGasLimits,
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes memory signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "test_UpdateTokenSpendCallWithRootKeyDirectAASponsoredERC20");
    }

    function test_RevokeKeyCallWithRootKeyDirect() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        _etch();
        vm.prank(owner7702);
        account.revokeKey(_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))));
        vm.snapshotGasLastCall("test_RevokeKeyCallWithRootKeyDirect");
    }

    function test_RevokeKeySelfCallWithRootKeyDirectAASponsored() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        bytes memory callData = abi.encodeCall(account.revokeKey, (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010)))));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, VERIFYING_MODE, 0);
        userOp = _populateUserOp(
            userOp,
            callData,
            accountGasLimits,
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(VERIFYING_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes memory signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "test_RevokeKeySelfCallWithRootKeyDirectAASponsored");
    }

    function test_RevokeKeySelfCallWithRootKeyDirectAASponsoredERC20() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        bytes memory callData = abi.encodeCall(account.revokeKey, (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010)))));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        userOp = _populateUserOp(
            userOp,
            callData,
            accountGasLimits,
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes memory signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "test_RevokeKeySelfCallWithRootKeyDirectAASponsoredERC20");
    }

    function test_RemoveTokenSpendCallWithRootKeyDirect() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        _etch();
        vm.prank(owner7702);
        account.setTokenSpend(_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), 1000 ether, IKeysManager.SpendPeriod.Month);

        _etch();
        vm.prank(owner7702);
        account.removeTokenSpend(_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20));
        vm.snapshotGasLastCall("test_RemoveTokenSpendCallWithRootKeyDirect");
    }

    function test_RemoveTokenSpendCallWithRootKeyDirectAASponsored() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        _etch();
        vm.prank(owner7702);
        account.setTokenSpend(_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), 1000 ether, IKeysManager.SpendPeriod.Month);

        bytes memory callData = abi.encodeCall(account.removeTokenSpend, (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20)));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, VERIFYING_MODE, 0);
        userOp = _populateUserOp(
            userOp,
            callData,
            accountGasLimits,
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(VERIFYING_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes memory signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "test_RemoveTokenSpendCallWithRootKeyDirectAASponsored");
    }

    function test_RemoveTokenSpendCallWithRootKeyDirectAASponsoredERC20() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        _etch();
        vm.prank(owner7702);
        account.setTokenSpend(_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), 1000 ether, IKeysManager.SpendPeriod.Month);

        bytes memory callData = abi.encodeCall(account.removeTokenSpend, (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20)));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        userOp = _populateUserOp(
            userOp,
            callData,
            accountGasLimits,
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes memory signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "test_RemoveTokenSpendCallWithRootKeyDirectAASponsoredERC20");
    }

    function test_RemoveCanCallCallWithRootKeyDirect() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        _etch();
        vm.prank(owner7702);
        account.setCanCall(_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), ANY_FN_SEL, true);

        _etch();
        vm.prank(owner7702);
        account.setCanCall(_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), ANY_FN_SEL, false);
        vm.snapshotGasLastCall("test_RemoveCanCallCallWithRootKeyDirect");
    }

    function test_RemoveCanCallCallWithRootKeyDirectAASponsored() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        _etch();
        vm.prank(owner7702);
        account.setCanCall(_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), ANY_FN_SEL, true);

        bytes memory callData = abi.encodeCall(account.setCanCall, (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), ANY_FN_SEL, false));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, VERIFYING_MODE, 0);
        userOp = _populateUserOp(
            userOp,
            callData,
            accountGasLimits,
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(VERIFYING_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes memory signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "test_RemoveCanCallCallWithRootKeyDirectAASponsored");
    }

    function test_RemoveCanCallCallWithRootKeyDirectAASponsoredERC20() external {
        _createCustomFreshKey(false, KeyType.EOA, 1824367044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        _etch();
        vm.prank(owner7702);
        account.setCanCall(_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), ANY_FN_SEL, true);

        bytes memory callData = abi.encodeCall(account.setCanCall, (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), ANY_FN_SEL, false));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        userOp = _populateUserOp(
            userOp,
            callData,
            accountGasLimits,
            800_000,
            _packGasFees(80 gwei, 15 gwei),
            paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes memory signature = _signUserOp(userOp);
        userOp.signature = _encodeEOASignature(signature);

        _relayUserOp(userOp, "test_RemoveCanCallCallWithRootKeyDirectAASponsoredERC20");
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

    function _warmUpAccount() internal {
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