// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { VmSafe } from "lib/forge-std/src/Vm.sol";
import { DeployAccount } from "test/DeployAccount.t.sol";
import { IKeysManager } from "src/interfaces/IKeysManager.sol";
import { console2 as console } from "lib/forge-std/src/Test.sol";
import { IERC20 } from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import { PackedUserOperation } from "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";

contract BenchmarksP256SessionKeyBatch10 is DeployAccount {
    address internal reciver;
    PubKey internal pK_SK;

    function setUp() public override {
        super.setUp();
        reciver = makeAddr("reciver");
        _createQuickFreshKey(true);
        _populateP256NON("P256SessionKey.json", ".batch10.DirectAA.result2");
        pK_SK = PubKey({ x: DEF_P256.X, y: DEF_P256.Y });
        _createCustomFreshKey(
            false, KeyType.P256NONKEY, uint48(block.timestamp + 1 days), 0, 1000, _getKeyP256(pK_SK), KeyControl.Self
        );
        _initializeAccount();
        _mint(owner7702, 3000e18);
        _approveAll(address(erc20), owner7702, type(uint256).max, address(pm));
        _warmUpAccount();
    }

    function test_SendBatch10CallWithP256SessionKeyDirectAA() external {
        bytes memory data = abi.encodeWithSelector(IERC20.transfer.selector, reciver, 10e18);
        Call[] memory calls = _getCalls(10, address(erc20), 0, data);

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

        _populateP256NON("P256SessionKey.json", ".batch10.DirectAA.result2");
        pK_SK = PubKey({ x: DEF_P256.X, y: DEF_P256.Y });

        userOp.signature = _encodeP256Signature(DEF_P256.R, DEF_P256.S, pK_SK, KeyType.P256NONKEY);

        _relayUserOp(userOp, "test_SendBatch10CallWithP256SessionKeyDirectAA");
    }

    function test_SendBatch10CallWithP256SessionKeyAASponsored() external {
        bytes memory data = abi.encodeWithSelector(IERC20.transfer.selector, reciver, 10e18);
        Call[] memory calls = _getCalls(10, address(erc20), 0, data);

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

        _populateP256NON("P256SessionKey.json", ".batch10.AASponsored.result2");
        pK_SK = PubKey({ x: DEF_P256.X, y: DEF_P256.Y });

        userOp.signature = _encodeP256Signature(DEF_P256.R, DEF_P256.S, pK_SK, KeyType.P256NONKEY);

        _relayUserOp(userOp, "test_SendBatch10CallWithP256SessionKeyAASponsored");
    }

    function test_SendBatch10CallWithP256SessionKeyAASponsoredERC20() external {
        bytes memory data = abi.encodeWithSelector(IERC20.transfer.selector, reciver, 10e18);
        Call[] memory calls = _getCalls(10, address(erc20), 0, data);

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

        _populateP256NON("P256SessionKey.json", ".batch10.AASponsoredERC20.result2");
        pK_SK = PubKey({ x: DEF_P256.X, y: DEF_P256.Y });

        userOp.signature = _encodeP256Signature(DEF_P256.R, DEF_P256.S, pK_SK, KeyType.P256NONKEY);

        _relayUserOp(userOp, "test_SendBatch10CallWithP256SessionKeyAASponsoredERC20");
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
        setTokenSpendM(KeyType.P256NONKEY, _getKeyP256(pK_SK), address(erc20), 1_000_000 ether, IKeysManager.SpendPeriod.Month)
        setCanCallM(KeyType.P256NONKEY, _getKeyP256(pK_SK), address(erc20), ANY_FN_SEL, true)
    {
        _depositToPM();

        bytes memory data = abi.encodeWithSelector(IERC20.transfer.selector, reciver, 10e18);
        Call[] memory calls = _getCalls(10, address(erc20), 0, data);

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
