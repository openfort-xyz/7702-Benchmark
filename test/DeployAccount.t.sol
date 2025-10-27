// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { OPFMain } from "src/core/OPFMain.sol";
import { IKeysManager } from "src/interfaces/IKeysManager.sol";
import { IERC20 } from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import { UniswapV2Helper, MockPaymentToken } from "test/helpers/UniswapV2Helper.t.sol";
import { MessageHashUtils } from "lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol";

contract DeployAccount is UniswapV2Helper {
    modifier setTokenSpendM(
        KeyType _keyType,
        bytes memory _key,
        address _token,
        uint256 _limit,
        IKeysManager.SpendPeriod _period
    ) {
        _etch();
        vm.prank(owner7702);
        account.setTokenSpend(_computeKeyId(_keyType, _key), _token, _limit, _period);
        _;
    }

    modifier setCanCallM(KeyType _keyType, bytes memory _key, address _target, bytes4 _funSel, bool _can) {
        _etch();
        vm.prank(owner7702);
        account.setCanCall(_computeKeyId(_keyType, _key), _target, _funSel, _can);
        _;
    }

    function setUp() public virtual override {
        super.setUp();
        vm.startPrank(sender);
        implementation =
            new OPFMain(address(entryPoint), address(webAuthn), address(gasPolicy), address(socialRecoveryManager));
        _etch();
        vm.stopPrank();

        _deal();
    }

    function _deal() public {
        deal(owner7702, 10e18);
        deal(sender, 10e18);
        deal(ownerPM, 10e18);
    }

    function test_AfterDeploy7702() external view {
        assertEq(address(entryPoint), address(implementation.entryPoint()));
        assertEq(address(webAuthn), implementation.webAuthnVerifier());
        assertEq(address(gasPolicy), implementation.gasPolicy());
        assertEq(address(implementation), implementation._OPENFORT_CONTRACT_ADDRESS());
    }

    function test_AfterDeployPaymaster() external view {
        uint256 sC = pm.signerCount();
        assertEq(sC, signersPM.length);
        for (uint256 i = 0; i < sC;) {
            address signer = pm.signerAt(i);
            assertEq(signer, signersPM[i]);
            unchecked {
                i++;
            }
        }
        address getOwner = pm.OWNER();
        address getManager = pm.MANAGER();

        assertEq(ownerPM, getOwner);
        assertEq(managerPM, getManager);
    }

    function test_Attched7702() external view {
        bytes memory code = owner7702.code;
        bytes memory designator = abi.encodePacked(bytes3(0xef0100), address(implementation));

        assertEq(code, designator);
    }

    function _initializeAccount() internal {
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
        bytes memory sig = abi.encodePacked(r, s, v);

        vm.prank(owner7702);
        account.initialize(mkReg, skReg, sig, _initialGuardian);
    }

    function _depositTo(address _sender, address _depositToAddress) internal {
        vm.prank(_sender);
        entryPoint.depositTo{ value: 1e18 }(_depositToAddress);
    }

    function _depositToPM() internal {
        vm.prank(ownerPM);
        pm.deposit{ value: 1 ether }();
    }

    function _mint(address _addr, uint256 _amount) internal {
        vm.prank(owner7702);
        erc20.mint(_addr, _amount);
    }

    function _approveAll(address _token, address _owner, uint256 _amount, address _spender) internal {
        vm.prank(_owner);
        IERC20(_token).approve(_spender, _amount);
    }

    function _mintForUniSwapV2(address token, address to, uint256 amount) internal {
        MockPaymentToken(token).mint(to, amount);
    }
}
