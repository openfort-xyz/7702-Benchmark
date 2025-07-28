// SPDX-License-Identifier: MIT

pragma solidity ^0.8.29;

import {BaseData} from "test/BaseData.sol";
import {OPFMain} from "src/core/OPFMain.sol";
import {MockERC20} from "src/mocks/MockERC20.sol";
import {Paymaster} from "src/paymaster/paymaster.sol";
import {ChainsData} from "test/helpers/ChainsData.sol";
import {RecoverSigner} from "test/Helpers/RecoverSigner.sol";
import {WebAuthnVerifierV2} from "src/utils/WebAuthnVerifierV2.sol";
import {Test, console2 as console} from "lib/forge-std/src/Test.sol";
import {EntryPoint} from "lib/account-abstraction/contracts/core/EntryPoint.sol";
import {IEntryPoint} from "lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";
import {PackedUserOperation} from
    "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";
import {MessageHashUtils} from
    "lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol";

contract BaseBenchmark is ChainsData, BaseData, RecoverSigner {
    IEntryPoint internal ep;
    WebAuthnVerifierV2 internal webAuthn;
    MockERC20 internal erc20;
    Paymaster internal pm;

    OPFMain public account;
    OPFMain public implementation;

    uint256 internal ownerPK = vm.envUint("PRIVATE_KEY_OWNER");
    address internal owner = vm.addr(ownerPK);

    uint256 internal sessionKeyPk = vm.envUint("PRIVATE_KEY_SESSIONKEY");
    address internal sessionKey = vm.addr(sessionKeyPk);

    uint256 internal senderPK = vm.envUint("PRIVATE_KEY_SENDER");
    address internal sender = vm.addr(senderPK);

    uint256 internal pmPK;
    address internal pmAddr;

    function setUp() public virtual override {
        super.setUp();
        // ep = new EntryPoint();
        ep = IEntryPoint(payable(ENTRYPOINT));
        erc20 = new MockERC20();
        webAuthn = new WebAuthnVerifierV2();

        (pmAddr, pmPK) = makeAddrAndKey("paymaster");
        // vm.prank(pmAddr);
        // pm = new Paymaster(IEntryPoint(ep));
        // _paymaster();

        initialGuardian = keccak256(abi.encodePacked(makeAddr("initialGuardian")));
    }

    function _buildUserOp() internal view returns (PackedUserOperation memory) {
        return PackedUserOperation({
            sender: owner,
            nonce: 0,
            initCode: hex"",
            callData: hex"",
            accountGasLimits: _packAccountGasLimits(600000, 400000),
            preVerificationGas: 800000,
            gasFees: _packGasFees(80 gwei, 15 gwei),
            // paymasterAndData: abi.encodePacked(address(pm)),
            paymasterAndData:  hex"",
            signature: hex""
        });
    }

    function _getNonce(address _owner, uint192 _k) internal view returns (uint256) {
        return ep.getNonce(_owner, _k);
    }

    function _getUserOpHash(PackedUserOperation memory _userOp) internal view returns (bytes32) {
        return IEntryPoint(ep).getUserOpHash(_userOp);
    }

    function _signUserOpWithEOA(PackedUserOperation memory _userOp)
        internal
        view
        returns (bytes memory)
    {
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPK, _getUserOpHash(_userOp));
        return account.encodeEOASignature(abi.encodePacked(r, s, v));
    }

    function _signInitialize() internal view returns (bytes memory sig, bytes32 digest) {
        string memory name = "OPF7702Recoverable";
        string memory version = "1";

        bytes32 domainSeparator = keccak256(
            abi.encode(
                TYPE_HASH, keccak256(bytes(name)), keccak256(bytes(version)), block.chainid, owner
            )
        );

        bytes32 structHash = keccak256(
            abi.encode(
                RECOVER_TYPEHASH,
                keyMK.pubKey.x,
                keyMK.pubKey.y,
                keyMK.eoaAddress,
                keyMK.keyType,
                initialGuardian
            )
        );

        digest = MessageHashUtils.toTypedDataHash(domainSeparator, structHash);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPK, digest);

        sig = abi.encodePacked(r, s, v);
    }

    function _packAccountGasLimits(uint256 callGasLimit, uint256 verificationGasLimit)
        internal
        pure
        returns (bytes32)
    {
        return bytes32((callGasLimit << 128) | verificationGasLimit);
    }

    function _packGasFees(uint256 maxFeePerGas, uint256 maxPriorityFeePerGas)
        internal
        pure
        returns (bytes32)
    {
        return bytes32((maxFeePerGas << 128) | maxPriorityFeePerGas);
    }

    function _attach7702() internal {
        bytes memory code = abi.encodePacked(bytes3(0xef0100), address(implementation));
        vm.etch(owner, code);
    }

    function _deploy() internal {
        implementation = new OPFMain(
            address(ep),
            address(webAuthn),
            RECOVERY_PERIOD,
            LOCK_PERIOD,
            SECURITY_PERIOD,
            SECURITY_WINDOW
        );
        account = OPFMain(payable(owner));
    }

    function _initialize() internal {
        (Key memory keyMK, KeyReg memory keyRegMK) = _getMK();
        (Key memory keySK, KeyReg memory keyRegSK) = _getSK();
        (bytes memory sig,) = _signInitialize();
        vm.prank(owner);
        account.initialize(keyMK, keyRegMK, keySK, keyRegSK, sig, initialGuardian);
    }

    function _mintErc20(address _to, uint256 _amount) internal {
        erc20.mint(_to, _amount);
    }

    function _deal(address _account, uint256 _amount) internal {
        deal(_account, _amount);
    }

    // function _paymaster() internal {
    //     _deal(pmAddr, 10e18);
    //     vm.startPrank(pmAddr);
    //     pm.addStake{value: 1e18}(8600);
    //     pm.deposit{value: 2e18}();
    //     vm.stopPrank();
    // }
    function _paymaster() internal {
        _deal(pmAddr, 10e18);
        vm.startPrank(pmAddr);
        ep.depositTo{value: 0.09e18}(owner);
        vm.stopPrank();
    }
}
