// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { IKey } from "src/interfaces/IKey.sol";
import { OPFMain } from "src/core/OPFMain.sol";
import { MockERC20 } from "src/mocks/MockERC20.sol";
import { GasPolicy } from "src/utils/GasPolicy.sol";
import { WebAuthnHelper } from "./WebAuthnHelper.t.sol";
import { SocialRecoveryManager } from "src/utils/SocialRecover.sol";
import { WebAuthnVerifierV2 } from "src/utils/WebAuthnVerifierV2.sol";
import {OPFPaymasterV3 as Paymaster} from "src/PaymasterV3/OPFPaymasterV3.sol";
import { IEntryPoint } from "lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";

abstract contract Data is WebAuthnHelper, IKey {
    /// --------------------------------------------------------------------------------- Contracts
    OPFMain internal opf7702;
    GasPolicy internal gasPolicy;
    IEntryPoint public entryPoint;
    WebAuthnVerifierV2 internal webAuthn;
    SocialRecoveryManager internal socialRecoveryManager;
    MockERC20 internal erc20;
    Paymaster internal pm;

    /// --------------------------------------------------------------------------------- Account Owner
    uint256 internal owner7702PK;
    address internal owner7702;

    /// --------------------------------------------------------------------------------- Key EOA
    uint256 internal sessionKeyPK;
    address internal sessionKey;

    /// --------------------------------------------------------------------------------- Relayer EOA
    uint256 internal senderPK;
    address internal sender;

    /// --------------------------------------------------------------------------------- Guardian
    uint256 internal guardianPK;
    address internal guardian;
    bytes32 internal _initialGuardian;

    /// --------------------------------------------------------------------------------- PubKey
    PubKey internal pubK;
    KeyDataReg internal KDR;

    /// --------------------------------------------------------------------------------- Key Data
    KeyDataReg internal mkReg;
    KeyDataReg internal skReg;

    /// --------------------------------------------------------------------------------- 7702 account
    OPFMain public implementation;
    OPFMain public account;

    /// --------------------------------------------------------------------------------- Paymaster
    uint256 ownerPM_PK;
    address ownerPM;

    uint256 managerPM_PK;
    address managerPM;

    uint256[] signersPM_PK;
    address[] signersPM;

    address treasury;
    uint256 constant signersLength = 3;

    function setUp() public virtual {
        _createAddresses();
        _createPMsigners();

        vm.startPrank(sender);
        entryPoint = IEntryPoint(payable(ENTRY_POINT_V8));
        webAuthn = new WebAuthnVerifierV2();
        gasPolicy = new GasPolicy(DEFAULT_PVG, DEFAULT_VGL, DEFAULT_CGL, DEFAULT_PMV, DEFAULT_PO);
        socialRecoveryManager =
            new SocialRecoveryManager(RECOVERY_PERIOD, LOCK_PERIOD, SECURITY_PERIOD, SECURITY_WINDOW);
        pm = new Paymaster(ownerPM, managerPM, signersPM);
        _createInitialGuradian();
        erc20 = new MockERC20();
        vm.stopPrank();
    }

    function _createAddresses() internal {
        (sender, senderPK) = makeAddrAndKey("sender");
        (guardian, guardianPK) = makeAddrAndKey("guardian");
        (owner7702, owner7702PK) = makeAddrAndKey("owner7702");
        (sessionKey, sessionKeyPK) = makeAddrAndKey("sessionKey");

        treasury = makeAddr("treasury");
        (ownerPM, ownerPM_PK) = makeAddrAndKey("owner");
        (managerPM, managerPM_PK) = makeAddrAndKey("manager");
    }

    function _createPMsigners() internal {
        for (uint256 i = 0; i < signersLength;) {
            (address signer, uint256 signerPK) = makeAddrAndKey(string.concat("signer", vm.toString(i)));
            signersPM.push(signer);
            signersPM_PK.push(signerPK);
            unchecked {
                i++;
            }
        }
    }

    function _etch() internal {
        vm.etch(owner7702, abi.encodePacked(bytes3(0xef0100), address(implementation)));
        account = OPFMain(payable(owner7702));
    }

    function _createInitialGuradian() internal {
        _initialGuardian = keccak256(abi.encode(guardian));
    }
}
