// SPDX-License-Identifier: MIT

pragma solidity ^0.8.29;

import {OPFMain} from "src/core/OPFMain.sol";
import {MockERC20} from "src/mocks/MockERC20.sol";
import {Paymaster} from "src/paymaster/paymaster.sol";
import {WebAuthnVerifierV2} from "src/utils/WebAuthnVerifierV2.sol";
import {Test, console2 as console} from "lib/forge-std/src/Test.sol";
import {MockPaymentToken} from "test/BenchmarksByIthaca/UniSwapV2.sol";
import {IEntryPoint} from "lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";
import {PackedUserOperation} from
    "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";
import {MessageHashUtils} from
    "lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol";
import {BaseBenchmarksByIthaca} from "test/BenchmarksByIthaca/BaseBenchmarksByIthaca.t.sol";

contract InitBenchmarksByIthaca is BaseBenchmarksByIthaca {
    IEntryPoint internal ep;
    WebAuthnVerifierV2 internal webAuthn;
    MockERC20 internal erc20;
    Paymaster internal pm;

    OPFMain public account;
    OPFMain public implementation;

    function setUp() public virtual {
        (pmAddr, pmPK) = makeAddrAndKey("paymaster");

        erc20 = new MockERC20();
        ep = IEntryPoint(payable(_ENTRY_POINT_V8));

        initialGuardian = keccak256(abi.encodePacked(makeAddr("initialGuardian")));

        _deploy();
        _initialize();
        _deal();
        _mint();
    }

    function test_AfterInitialize() public view {
        Key memory k = account.getKeyById(0);
        assertEq(k.pubKey.x, pubKeyMK.x);
        assertEq(k.pubKey.y, pubKeyMK.y);
    }

    function _deploy() internal {
        webAuthn = new WebAuthnVerifierV2();
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
        (Key memory keyMK, KeyReg memory keyRegMK) = _getFreshMKWebAuthn();
        (Key memory keySK, KeyReg memory keyRegSK) = _getSKEmpty();
        (bytes memory sig,) = _signInitialize();
        _etch();
        vm.prank(owner);
        account.initialize(keyMK, keyRegMK, keySK, keyRegSK, sig, initialGuardian);
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

    function _deal() internal {
        deal(owner, 10e18);
        deal(sender, 10e18);
        deal(pmAddr, 10e18);
    }

    function _mint() internal {
        erc20.mint(owner, 200e18);
    }

    function _mintForUniSwapV2(address token, address to, uint256 amount) internal {
        MockPaymentToken(token).mint(to, amount);
    }

    function _depositEP() internal {
        vm.prank(pmAddr);
        ep.depositTo{value: 1e18}(owner);
    }

    function _etch() internal {
        vm.etch(owner, abi.encodePacked(bytes3(0xef0100), address(implementation)));
        account = OPFMain(payable(owner));
    }

    function _getFreshUserOp() internal pure returns (PackedUserOperation memory userOp) {
        userOp = PackedUserOperation({
            sender: address(0),
            nonce: 0,
            initCode: hex"7702",
            callData: hex"",
            accountGasLimits: hex"",
            preVerificationGas: 0,
            gasFees: hex"",
            paymasterAndData: hex"",
            signature: hex""
        });
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
}
