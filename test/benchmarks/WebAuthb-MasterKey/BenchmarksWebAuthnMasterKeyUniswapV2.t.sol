// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { VmSafe } from "lib/forge-std/src/Vm.sol";
import { DeployAccount } from "test/DeployAccount.t.sol";
import { LibClone } from "lib/solady/src/utils/LibClone.sol";
import { console2 as console } from "lib/forge-std/src/console2.sol";
import { SafeTransferLib } from "lib/solady/src/utils/SafeTransferLib.sol";
import { IUniswapV2Router, MockPaymentToken } from "test/helpers/UniswapV2Helper.t.sol";
import { PackedUserOperation } from "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";

contract BenchmarksWebAuthnMasterKeyUniswapV2 is DeployAccount {
    address internal reciver;
    PubKey internal pK;

    function setUp() public override {
        super.setUp();
        reciver = makeAddr("reciver");
        _populateWebAuthn("WebAuthnMasterKey.json", ".uniswapV2.DirectAA");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });
        _createCustomFreshKey(true, KeyType.WEBAUTHN, type(uint48).max, 0, 0, _getKeyP256(pK), KeyControl.Self);
        _createQuickFreshKey(false);
        _initializeAccount();
        _mint(owner7702, 3000e18);
        _approveAll(address(erc20), owner7702, type(uint256).max, address(pm));
        _initUniswap();
        _warmUpAccount();
    }

    function test_SendUniswapV2CallWithWebAuthnMasterKeyDirectAA() external {
        bytes memory data = _uniswapV2SwapPayload();
        Call[] memory calls = _getCalls(1, _UNISWAP_V2_ROUTER_ADDRESS, 0, data);

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

        _populateWebAuthn("WebAuthnMasterKey.json", ".uniswapV2.DirectAA");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_SendUniswapV2CallWithWebAuthnMasterKeyDirectAA");
    }

    function test_SendUniswapV2CallWithWebAuthnMasterKeyDirectAASponsored() external {
        bytes memory data = _uniswapV2SwapPayload();
        Call[] memory calls = _getCalls(1, _UNISWAP_V2_ROUTER_ADDRESS, 0, data);

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

        _populateWebAuthn("WebAuthnMasterKey.json", ".uniswapV2.AASponsored");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_SendUniswapV2CallWithWebAuthnMasterKeyDirectAASponsored");
    }

    function test_SendUniswapV2CallWithWebAuthnMasterKeyDirectAASponsoredERC20() external {
        bytes memory data = _uniswapV2SwapPayload();
        Call[] memory calls = _getCalls(1, _UNISWAP_V2_ROUTER_ADDRESS, 0, data);

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

        _populateWebAuthn("WebAuthnMasterKey.json", ".uniswapV2.AASponsoredERC20");
        pK = PubKey({ x: DEF_WEBAUTHN.X, y: DEF_WEBAUTHN.Y });

        userOp.signature = _getSignedUserOpByWebAuthn(DEF_WEBAUTHN, pK);

        _relayUserOp(userOp, "test_SendUniswapV2CallWithWebAuthnMasterKeyDirectAASponsoredERC20");
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

    function _initUniswap() internal {
        paymentToken = new MockPaymentToken();

        token0 = LibClone.clone(address(paymentToken));
        _mintForUniSwapV2(token0, address(this), type(uint128).max);
        token1 = LibClone.clone(address(paymentToken));
        _mintForUniSwapV2(token1, address(this), type(uint128).max);
        if (uint160(token0) > uint160(token1)) {
            (token0, token1) = (token1, token0);
        }

        uniswapV2Router = IUniswapV2Router(_UNISWAP_V2_ROUTER_ADDRESS);
        SafeTransferLib.safeApprove(token0, _UNISWAP_V2_ROUTER_ADDRESS, type(uint256).max);
        SafeTransferLib.safeApprove(token1, _UNISWAP_V2_ROUTER_ADDRESS, type(uint256).max);
        uniswapV2Router.addLiquidity(token0, token1, 1 ether, 1 ether, 1, 1, address(this), block.timestamp + 999);

        _mintForUniSwapV2(token0, owner7702, 20 ether);
        _mintForUniSwapV2(token1, owner7702, 20 ether);
        _approveAll(token0, owner7702, type(uint256).max, _UNISWAP_V2_ROUTER_ADDRESS);
    }

    function _warmUpAccount() internal {
        _depositToPM();

        bytes memory data = _uniswapV2SwapPayload();
        Call[] memory calls = _getCalls(1, _UNISWAP_V2_ROUTER_ADDRESS, 0, data);
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
