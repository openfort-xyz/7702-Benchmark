// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { IKey } from "src/interfaces/IKey.sol";
import { OPFMain } from "src/core/OPFMain.sol";
import { MockERC20 } from "src/mocks/MockERC20.sol";
import { GasPolicy } from "src/utils/GasPolicy.sol";
import { WebAuthnHelper } from "./WebAuthnHelper.t.sol";
import { WebAuthnVerifier } from "src/utils/WebAuthnVerifier.sol";
import { SocialRecoveryManager } from "src/utils/SocialRecover.sol";
import { WebAuthnVerifierV2 } from "src/utils/WebAuthnVerifierV2.sol";
import { OPFPaymasterV3 as Paymaster } from "src/PaymasterV3/OPFPaymasterV3.sol";
import { EntryPoint } from "lib/account-abstraction/contracts/core/EntryPoint.sol";
import { IUniswapV2Router, MockPaymentToken } from "test/helpers/UniswapV2Helper.t.sol";
import { IEntryPoint } from "lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";
import { WenAuthnVerifierOz } from "test/benchmarks/SoladyVsDaimoVsOZ/WenAuthnVerifierOz.sol";

abstract contract Data is WebAuthnHelper, IKey {
    /// --------------------------------------------------------------------------------- Chain
    string internal RPC_URL = vm.envString("MAINNET_RPC_URL");
    uint256 internal forkId;

    /// --------------------------------------------------------------------------------- Contracts
    OPFMain internal opf7702;
    GasPolicy internal gasPolicy;
    IEntryPoint public entryPoint;
    WebAuthnVerifier internal webAuthn;
    WebAuthnVerifierV2 internal webAuthnDaimo;
    WenAuthnVerifierOz internal webAuthnOz;
    WebAuthnVerifier internal webAuthnSolady;
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

    /// --------------------------------------------------------------------------------- Uniswap V2
    address constant _UNISWAP_V2_FACTORY_ADDRESS = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address constant _UNISWAP_V2_ROUTER_ADDRESS = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    IUniswapV2Router uniswapV2Router;
    address token0;
    address token1;
    MockPaymentToken paymentToken;

    function setUp() public virtual {
        forkId = vm.createFork(RPC_URL);
        vm.selectFork(forkId);

        _createAddresses();
        _createPMsigners();

        vm.startPrank(sender);
        EntryPoint deployedEntryPoint = new EntryPoint();
        vm.etch(ENTRY_POINT_V8, address(deployedEntryPoint).code);
        vm.label(ENTRY_POINT_V8, "EntryPointV8");
        entryPoint = IEntryPoint(payable(ENTRY_POINT_V8));
        vm.etch(
            P256_VERIFIER,
            hex"3d604052610216565b60008060006ffffffffeffffffffffffffffffffffff60601b19808687098188890982838389096004098384858485093d510985868b8c096003090891508384828308850385848509089650838485858609600809850385868a880385088509089550505050808188880960020991505093509350939050565b81513d83015160408401516ffffffffeffffffffffffffffffffffff60601b19808384098183840982838388096004098384858485093d510985868a8b096003090896508384828308850385898a09089150610102848587890960020985868787880960080987038788878a0387088c0908848b523d8b015260408a0152565b505050505050505050565b81513d830151604084015185513d87015160408801518361013d578287523d870182905260408701819052610102565b80610157578587523d870185905260408701849052610102565b6ffffffffeffffffffffffffffffffffff60601b19808586098183840982818a099850828385830989099750508188830383838809089450818783038384898509870908935050826101be57836101be576101b28a89610082565b50505050505050505050565b808485098181860982828a09985082838a8b0884038483860386898a09080891506102088384868a0988098485848c09860386878789038f088a0908848d523d8d015260408c0152565b505050505050505050505050565b6020357fffffffff00000000ffffffffffffffffbce6faada7179e84f3b9cac2fc6325513d6040357f7fffffff800000007fffffffffffffffde737d56d38bcf4279dce5617e3192a88111156102695782035b60206108005260206108205260206108405280610860526002830361088052826108a0526ffffffffeffffffffffffffffffffffff60601b198060031860205260603560803560203d60c061080060055afa60203d1416837f5ac635d8aa3a93e7b3ebbd55769886bc651d06b0cc53b0f63bce3c3e27d2604b8585873d5189898a09080908848384091484831085851016888710871510898b108b151016609f3611161616166103195760206080f35b60809182523d820152600160c08190527f6b17d1f2e12c4247f8bce6e563a440f277037d812deb33a0f4a13945d898c2966102009081527f4fe342e2fe1a7f9b8ee7eb4a7c0f9e162bce33576b315ececbb6406837bf51f53d909101526102405261038992509050610100610082565b610397610200610400610082565b6103a7610100608061018061010d565b6103b7610200608061028061010d565b6103c861020061010061030061010d565b6103d961020061018061038061010d565b6103e9610400608061048061010d565b6103fa61040061010061050061010d565b61040b61040061018061058061010d565b61041c61040061020061060061010d565b61042c610600608061068061010d565b61043d61060061010061070061010d565b61044e61060061018061078061010d565b81815182350982825185098283846ffffffffeffffffffffffffffffffffff60601b193d515b82156105245781858609828485098384838809600409848586848509860986878a8b096003090885868384088703878384090886878887880960080988038889848b03870885090887888a8d096002098882830996508881820995508889888509600409945088898a8889098a098a8b86870960030908935088898687088a038a868709089a5088898284096002099950505050858687868709600809870387888b8a0386088409089850505050505b61018086891b60f71c16610600888a1b60f51c16176040810151801585151715610564578061055357506105fe565b81513d8301519750955093506105fe565b83858609848283098581890986878584098b0991508681880388858851090887838903898a8c88093d8a015109089350836105b957806105b9576105a9898c8c610008565b9a509b50995050505050506105fe565b8781820988818309898285099350898a8586088b038b838d038d8a8b0908089b50898a8287098b038b8c8f8e0388088909089c5050508788868b098209985050505050505b5082156106af5781858609828485098384838809600409848586848509860986878a8b096003090885868384088703878384090886878887880960080988038889848b03870885090887888a8d096002098882830996508881820995508889888509600409945088898a8889098a098a8b86870960030908935088898687088a038a868709089a5088898284096002099950505050858687868709600809870387888b8a0386088409089850505050505b61018086891b60f51c16610600888a1b60f31c161760408101518015851517156106ef57806106de5750610789565b81513d830151975095509350610789565b83858609848283098581890986878584098b0991508681880388858851090887838903898a8c88093d8a01510908935083610744578061074457610734898c8c610008565b9a509b5099505050505050610789565b8781820988818309898285099350898a8586088b038b838d038d8a8b0908089b50898a8287098b038b8c8f8e0388088909089c5050508788868b098209985050505050505b50600488019760fb19016104745750816107a2573d6040f35b81610860526002810361088052806108a0523d3d60c061080060055afa898983843d513d510987090614163d525050505050505050503d3df3fea264697066735822122063ce32ec0e56e7893a1f6101795ce2e38aca14dd12adb703c71fe3bee27da71e64736f6c634300081a0033"
        );
        vm.label(P256_VERIFIER, "P256Verifier");
        webAuthnDaimo = new WebAuthnVerifierV2();
        webAuthn = new WebAuthnVerifier();
        webAuthnOz = new WenAuthnVerifierOz();
        webAuthnSolady = new WebAuthnVerifier();
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
