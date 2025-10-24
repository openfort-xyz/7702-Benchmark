// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { VmSafe } from "lib/forge-std/src/Vm.sol";
import { DeployAccount } from "test/DeployAccount.t.sol";
import { IKeysManager } from "src/interfaces/IKeysManager.sol";
import { console2 as console } from "lib/forge-std/src/Test.sol";
import { PackedUserOperation } from "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";

contract BenchmarksWebAuthnMasterKeyAccountActions is DeployAccount {
    address internal reciver;
    PubKey internal pK;

    function setUp() public override {
        super.setUp();
        reciver = makeAddr("reciver");
        _populateWebAuthn("WebAuthnMasterKeyAccountActions.json", ".RegisterKeySelf.AASponsored");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });
        _createCustomFreshKey(true, KeyType.WEBAUTHN, type(uint48).max, 0, 0, _getKeyP256(pK), KeyControl.Self);
        _createQuickFreshKey(false);
        _initializeAccount();
        _mint(owner7702, 3000e18);
        _approveAll(address(erc20), owner7702, type(uint256).max, address(pm));
        _warmUpAccount();
    }

    function test_RegisterKeySelfCallWithWebAuthnMasterKeyDirectAASponsored() external {
        _createCustomFreshKey(false, KeyType.EOA, 1_824_367_044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        bytes memory callData = abi.encodeCall(account.registerKey, (skReg));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, VERIFYING_MODE, 0);
        userOp = _populateUserOp(
            userOp, callData, accountGasLimits, 800_000, _packGasFees(80 gwei, 15 gwei), paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(VERIFYING_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateWebAuthn("WebAuthnMasterKeyAccountActions.json", ".RegisterKeySelf.AASponsored");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_RegisterKeySelfCallWithWebAuthnMasterKeyDirectAASponsored");
    }

    function test_RegisterKeySelfCallWithWebAuthnMasterKeyDirectAASponsoredERC20() external {
        _createCustomFreshKey(false, KeyType.EOA, 1_824_367_044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        bytes memory callData = abi.encodeCall(account.registerKey, (skReg));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        userOp = _populateUserOp(
            userOp, callData, accountGasLimits, 800_000, _packGasFees(80 gwei, 15 gwei), paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateWebAuthn("WebAuthnMasterKeyAccountActions.json", ".RegisterKeySelf.AASponsoredERC20");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_RegisterKeySelfCallWithWebAuthnMasterKeyDirectAASponsoredERC20");
    }

    function test_RegisterKeyCustodialCallWithWebAuthnMasterKeyDirectAASponsored() external {
        _createCustomFreshKey(
            false, KeyType.EOA, 1_824_367_044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Custodial
        );
        bytes memory callData = abi.encodeCall(account.registerKey, (skReg));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, VERIFYING_MODE, 0);
        userOp = _populateUserOp(
            userOp, callData, accountGasLimits, 800_000, _packGasFees(80 gwei, 15 gwei), paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(VERIFYING_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateWebAuthn("WebAuthnMasterKeyAccountActions.json", ".RegisterKeyCustodial.AASponsored");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_RegisterKeyCustodialCallWithWebAuthnMasterKeyDirectAASponsored");
    }

    function test_RegisterKeyCustodialCallWithWebAuthnMasterKeyDirectAASponsoredERC20() external {
        _createCustomFreshKey(
            false, KeyType.EOA, 1_824_367_044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Custodial
        );
        bytes memory callData = abi.encodeCall(account.registerKey, (skReg));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        userOp = _populateUserOp(
            userOp, callData, accountGasLimits, 800_000, _packGasFees(80 gwei, 15 gwei), paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateWebAuthn("WebAuthnMasterKeyAccountActions.json", ".RegisterKeyCustodial.AASponsoredERC20");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_RegisterKeyCustodialCallWithWebAuthnMasterKeyDirectAASponsoredERC20");
    }

    function test_SetTokenSpendCallWithWebAuthnMasterKeyDirectAASponsored() external {
        _createCustomFreshKey(false, KeyType.EOA, 1_824_367_044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        bytes memory callData = abi.encodeCall(
            account.setTokenSpend,
            (
                _computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))),
                address(erc20),
                1000 ether,
                IKeysManager.SpendPeriod.Month
            )
        );

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, VERIFYING_MODE, 0);
        userOp = _populateUserOp(
            userOp, callData, accountGasLimits, 800_000, _packGasFees(80 gwei, 15 gwei), paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(VERIFYING_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateWebAuthn("WebAuthnMasterKeyAccountActions.json", ".SetTokenSpend.AASponsored");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_SetTokenSpendCallWithWebAuthnMasterKeyDirectAASponsored");
    }

    function test_SetTokenSpendCallWithWebAuthnMasterKeyDirectAASponsoredERC20() external {
        _createCustomFreshKey(false, KeyType.EOA, 1_824_367_044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        bytes memory callData = abi.encodeCall(
            account.setTokenSpend,
            (
                _computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))),
                address(erc20),
                1000 ether,
                IKeysManager.SpendPeriod.Month
            )
        );

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        userOp = _populateUserOp(
            userOp, callData, accountGasLimits, 800_000, _packGasFees(80 gwei, 15 gwei), paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateWebAuthn("WebAuthnMasterKeyAccountActions.json", ".SetTokenSpend.AASponsoredERC20");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_SetTokenSpendCallWithWebAuthnMasterKeyDirectAASponsoredERC20");
    }

    function test_SetCanCallCallWithWebAuthnMasterKeyDirectAASponsored() external {
        _createCustomFreshKey(false, KeyType.EOA, 1_824_367_044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        bytes memory callData = abi.encodeCall(
            account.setCanCall,
            (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), ANY_FN_SEL, true)
        );

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, VERIFYING_MODE, 0);
        userOp = _populateUserOp(
            userOp, callData, accountGasLimits, 800_000, _packGasFees(80 gwei, 15 gwei), paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(VERIFYING_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateWebAuthn("WebAuthnMasterKeyAccountActions.json", ".SetCanCall.AASponsored");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_SetCanCallCallWithWebAuthnMasterKeyDirectAASponsored");
    }

    function test_SetCanCallCallWithWebAuthnMasterKeyDirectAASponsoredERC20() external {
        _createCustomFreshKey(false, KeyType.EOA, 1_824_367_044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        bytes memory callData = abi.encodeCall(
            account.setCanCall,
            (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), ANY_FN_SEL, true)
        );

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        userOp = _populateUserOp(
            userOp, callData, accountGasLimits, 800_000, _packGasFees(80 gwei, 15 gwei), paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateWebAuthn("WebAuthnMasterKeyAccountActions.json", ".SetCanCall.AASponsoredERC20");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_SetCanCallCallWithWebAuthnMasterKeyDirectAASponsoredERC20");
    }

    function test_UpdateKeyDataCallWithWebAuthnMasterKeyDirectAASponsored() external {
        _createCustomFreshKey(false, KeyType.EOA, 1_824_367_044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        bytes memory callData = abi.encodeCall(
            account.updateKeyData, (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), 1_855_989_444, 10_000)
        );

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, VERIFYING_MODE, 0);
        userOp = _populateUserOp(
            userOp, callData, accountGasLimits, 800_000, _packGasFees(80 gwei, 15 gwei), paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(VERIFYING_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateWebAuthn("WebAuthnMasterKeyAccountActions.json", ".UpdateKeyData.AASponsored");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_UpdateKeyDataCallWithWebAuthnMasterKeyDirectAASponsored");
    }

    function test_UpdateKeyDataCallWithWebAuthnMasterKeyDirectAASponsoredERC20() external {
        _createCustomFreshKey(false, KeyType.EOA, 1_824_367_044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        bytes memory callData = abi.encodeCall(
            account.updateKeyData, (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), 1_855_989_444, 10_000)
        );

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        userOp = _populateUserOp(
            userOp, callData, accountGasLimits, 800_000, _packGasFees(80 gwei, 15 gwei), paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateWebAuthn("WebAuthnMasterKeyAccountActions.json", ".UpdateKeyData.AASponsoredERC20");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_UpdateKeyDataCallWithWebAuthnMasterKeyDirectAASponsoredERC20");
    }

    function test_UpdateTokenSpendCallWithWebAuthnMasterKeyDirectAASponsored() external {
        _createCustomFreshKey(false, KeyType.EOA, 1_824_367_044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        _etch();
        vm.prank(owner7702);
        account.setTokenSpend(
            _computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))),
            address(erc20),
            1000 ether,
            IKeysManager.SpendPeriod.Month
        );

        bytes memory callData = abi.encodeCall(
            account.updateTokenSpend,
            (
                _computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))),
                address(erc20),
                10_000 ether,
                IKeysManager.SpendPeriod.Year
            )
        );

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, VERIFYING_MODE, 0);
        userOp = _populateUserOp(
            userOp, callData, accountGasLimits, 800_000, _packGasFees(80 gwei, 15 gwei), paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(VERIFYING_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateWebAuthn("WebAuthnMasterKeyAccountActions.json", ".UpdateTokenSpend.AASponsored");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_UpdateTokenSpendCallWithWebAuthnMasterKeyDirectAASponsored");
    }

    function test_UpdateTokenSpendCallWithWebAuthnMasterKeyDirectAASponsoredERC20() external {
        _createCustomFreshKey(false, KeyType.EOA, 1_824_367_044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        _etch();
        vm.prank(owner7702);
        account.setTokenSpend(
            _computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))),
            address(erc20),
            1000 ether,
            IKeysManager.SpendPeriod.Month
        );

        bytes memory callData = abi.encodeCall(
            account.updateTokenSpend,
            (
                _computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))),
                address(erc20),
                10_000 ether,
                IKeysManager.SpendPeriod.Year
            )
        );

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        userOp = _populateUserOp(
            userOp, callData, accountGasLimits, 800_000, _packGasFees(80 gwei, 15 gwei), paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateWebAuthn("WebAuthnMasterKeyAccountActions.json", ".UpdateTokenSpend.AASponsoredERC20");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_UpdateTokenSpendCallWithWebAuthnMasterKeyDirectAASponsoredERC20");
    }

    function test_RevokeKeySelfCallWithWebAuthnMasterKeyDirectAASponsored() external {
        _createCustomFreshKey(false, KeyType.EOA, 1_824_367_044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        bytes memory callData =
            abi.encodeCall(account.revokeKey, (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010)))));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, VERIFYING_MODE, 0);
        userOp = _populateUserOp(
            userOp, callData, accountGasLimits, 800_000, _packGasFees(80 gwei, 15 gwei), paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(VERIFYING_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateWebAuthn("WebAuthnMasterKeyAccountActions.json", ".RevokeKeySelf.AASponsored");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_RevokeKeySelfCallWithWebAuthnMasterKeyDirectAASponsored");
    }

    function test_RevokeKeySelfCallWithWebAuthnMasterKeyDirectAASponsoredERC20() external {
        _createCustomFreshKey(false, KeyType.EOA, 1_824_367_044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        bytes memory callData =
            abi.encodeCall(account.revokeKey, (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010)))));

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        userOp = _populateUserOp(
            userOp, callData, accountGasLimits, 800_000, _packGasFees(80 gwei, 15 gwei), paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateWebAuthn("WebAuthnMasterKeyAccountActions.json", ".RevokeKeySelf.AASponsoredERC20");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_RevokeKeySelfCallWithWebAuthnMasterKeyDirectAASponsoredERC20");
    }

    function test_RemoveTokenSpendCallWithWebAuthnMasterKeyDirectAASponsored() external {
        _createCustomFreshKey(false, KeyType.EOA, 1_824_367_044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        _etch();
        vm.prank(owner7702);
        account.setTokenSpend(
            _computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))),
            address(erc20),
            1000 ether,
            IKeysManager.SpendPeriod.Month
        );

        bytes memory callData = abi.encodeCall(
            account.removeTokenSpend, (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20))
        );

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, VERIFYING_MODE, 0);
        userOp = _populateUserOp(
            userOp, callData, accountGasLimits, 800_000, _packGasFees(80 gwei, 15 gwei), paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(VERIFYING_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateWebAuthn("WebAuthnMasterKeyAccountActions.json", ".RemoveTokenSpend.AASponsored");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_RemoveTokenSpendCallWithWebAuthnMasterKeyDirectAASponsored");
    }

    function test_RemoveTokenSpendCallWithWebAuthnMasterKeyDirectAASponsoredERC20() external {
        _createCustomFreshKey(false, KeyType.EOA, 1_824_367_044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        _etch();
        vm.prank(owner7702);
        account.setTokenSpend(
            _computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))),
            address(erc20),
            1000 ether,
            IKeysManager.SpendPeriod.Month
        );

        bytes memory callData = abi.encodeCall(
            account.removeTokenSpend, (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20))
        );

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        userOp = _populateUserOp(
            userOp, callData, accountGasLimits, 800_000, _packGasFees(80 gwei, 15 gwei), paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateWebAuthn("WebAuthnMasterKeyAccountActions.json", ".RemoveTokenSpend.AASponsoredERC20");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_RemoveTokenSpendCallWithWebAuthnMasterKeyDirectAASponsoredERC20");
    }

    function test_RemoveCanCallCallWithWebAuthnMasterKeyDirectAASponsored() external {
        _createCustomFreshKey(false, KeyType.EOA, 1_824_367_044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        _etch();
        vm.prank(owner7702);
        account.setCanCall(_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), ANY_FN_SEL, true);

        bytes memory callData = abi.encodeCall(
            account.setCanCall,
            (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), ANY_FN_SEL, false)
        );

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, VERIFYING_MODE, 0);
        userOp = _populateUserOp(
            userOp, callData, accountGasLimits, 800_000, _packGasFees(80 gwei, 15 gwei), paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(VERIFYING_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateWebAuthn("WebAuthnMasterKeyAccountActions.json", ".RemoveCanCall.AASponsored");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_RemoveCanCallCallWithWebAuthnMasterKeyDirectAASponsored");
    }

    function test_RemoveCanCallCallWithWebAuthnMasterKeyDirectAASponsoredERC20() external {
        _createCustomFreshKey(false, KeyType.EOA, 1_824_367_044, 0, 100, _getKeyEOA(address(1010)), KeyControl.Self);
        _etch();
        vm.prank(owner7702);
        account.registerKey(skReg);

        _etch();
        vm.prank(owner7702);
        account.setCanCall(_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), ANY_FN_SEL, true);

        bytes memory callData = abi.encodeCall(
            account.setCanCall,
            (_computeKeyId(KeyType.EOA, _getKeyEOA(address(1010))), address(erc20), ANY_FN_SEL, false)
        );

        PackedUserOperation memory userOp = _getFreshUserOp(owner7702);
        bytes32 accountGasLimits = _packAccountGasLimits(600_000, 400_000);
        userOp.accountGasLimits = accountGasLimits;
        bytes memory paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        userOp = _populateUserOp(
            userOp, callData, accountGasLimits, 800_000, _packGasFees(80 gwei, 15 gwei), paymasterAndData
        );

        bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);

        bytes32 userOpHash = _getUserOpHash(userOp);
        console.log("userOpHash:", vm.toString(userOpHash));

        _populateWebAuthn("WebAuthnMasterKeyAccountActions.json", ".RemoveCanCall.AASponsoredERC20");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_RemoveCanCallCallWithWebAuthnMasterKeyDirectAASponsoredERC20");
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
