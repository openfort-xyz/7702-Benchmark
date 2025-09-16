// SPDX-License-Identifier: MIT

pragma solidity ^0.8.29;

import {LibClone} from "lib/solady/src/utils/LibClone.sol";
import {SafeTransferLib} from "lib/solady/src/utils/SafeTransferLib.sol";
import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {PackedUserOperation} from
    "lib/account-abstraction/contracts/interfaces/PackedUserOperation.sol";
import {InitBenchmarksByIthaca} from "test/BenchmarksByIthaca/InitBenchmarksByIthaca.t.sol";
import {
    UniSwapV2, MockPaymentToken, IUniswapV2Router
} from "test/BenchmarksByIthaca/UniSwapV2.sol";
import {MessageHashUtils} from
    "lib/openzeppelin-contracts/contracts/utils/cryptography/MessageHashUtils.sol";

contract BenchmarksWithPaymasterERC20ByIthaca is InitBenchmarksByIthaca, UniSwapV2 {
    modifier mint() {
        _mint();
        _;
    }

    modifier approvePM() {
        vm.prank(owner);
        erc20.approve(address(pm), type(uint256).max);
        _;
    }

    modifier depositAndStakeEP() {
        vm.startPrank(ownerPM);
        pm.deposit{value: 5 ether}();
        pm.addStake{value: 5 ether}(860);
        vm.stopPrank();
        _;
    }

    bytes32 mode_1 = bytes32(uint256(0x01000000000000000000) << (22 * 8));
    address random = makeAddr("random");

    function setUp() public override {
        super.setUp();
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
        uniswapV2Router.addLiquidity(
            token0, token1, 1 ether, 1 ether, 1, 1, address(this), block.timestamp + 999
        );
    }

    function testNativeTransfer_OPFAccount_VERIFYING_MODE()
        external
        depositAndStakeEP
        mint
        approvePM
    {
        uint256 balanceBefore = random.balance;

        address[] memory targets = new address[](1);
        uint256[] memory values = new uint256[](1);
        bytes[] memory datas = new bytes[](1);

        targets[0] = random;
        values[0] = 0.1 ether;
        datas[0] = hex"";

        PackedUserOperation[] memory ops = new PackedUserOperation[](1);
        ops[0] = _buildUserOp(targets, values, datas, mode_1, 1);

        _etch();
        vm.prank(pmAddr);
        ep.handleOps(ops, payable(pmAddr));
        vm.snapshotGasLastCall("testNativeTransfer_OPFAccount");

        uint256 balanceAfter = random.balance;
        assertEq(balanceBefore + 0.1 ether, balanceAfter);
    }

    function testERC20Transfer_OPFAccount_VERIFYING_MODE()
        external
        depositAndStakeEP
        mint
        approvePM
    {
        uint256 balanceBefore = IERC20(erc20).balanceOf(random);

        bytes memory data = abi.encodeWithSelector(IERC20.transfer.selector, random, 1e18);

        address[] memory targets = new address[](1);
        uint256[] memory values = new uint256[](1);
        bytes[] memory datas = new bytes[](1);

        targets[0] = address(erc20);
        values[0] = 0 ether;
        datas[0] = data;

        PackedUserOperation[] memory ops = new PackedUserOperation[](1);
        ops[0] = _buildUserOp(targets, values, datas, mode_1, 1);

        _etch();
        vm.prank(pmAddr);
        ep.handleOps(ops, payable(pmAddr));
        vm.snapshotGasLastCall("testERC20Transfer_OPFAccount");

        uint256 balanceAfter = IERC20(erc20).balanceOf(random);
        assertEq(balanceBefore + 1 ether, balanceAfter);
    }

    function testUniswapV2Swap_OPFAccount_VERIFYING_MODE()
        external
        depositAndStakeEP
        mint
        approvePM
    {
        _mintForUniSwapV2(token0, owner, 20 ether);
        _mintForUniSwapV2(token1, owner, 20 ether);

        uint256 balanceBefore_token0 = IERC20(token0).balanceOf(random);
        uint256 balanceBefore_token1 = IERC20(token1).balanceOf(random);

        bytes memory data = _uniswapV2SwapPayload();

        address[] memory targets = new address[](1);
        uint256[] memory values = new uint256[](1);
        bytes[] memory datas = new bytes[](1);

        targets[0] = _UNISWAP_V2_ROUTER_ADDRESS;
        values[0] = 0 ether;
        datas[0] = data;

        PackedUserOperation[] memory ops = new PackedUserOperation[](1);
        ops[0] = _buildUserOp(targets, values, datas, mode_1, 1);

        _approveTokens();

        _etch();
        vm.prank(pmAddr);
        ep.handleOps(ops, payable(pmAddr));
        vm.snapshotGasLastCall("testUniswapV2Swap_OPFAccount");

        uint256 balanceAfter_token0 = IERC20(token0).balanceOf(random);
        uint256 balanceAfter_token1 = IERC20(token1).balanceOf(random);
        // assertEq(balanceBefore + 1 ether, balanceAfter);
    }

    function test10Batch_OPFAccount_VERIFYING_MODE() external depositAndStakeEP mint approvePM {
        uint256 balanceBefore = IERC20(erc20).balanceOf(random);

        bytes memory data = abi.encodeWithSelector(IERC20.transfer.selector, random, 1e18);

        address[] memory targets = new address[](10);
        uint256[] memory values = new uint256[](10);
        bytes[] memory datas = new bytes[](10);

        for (uint256 i = 0; i < targets.length;) {
            targets[i] = address(erc20);
            values[i] = 0 ether;
            datas[i] = data;
            unchecked {
                i++;
            }
        }

        PackedUserOperation[] memory ops = new PackedUserOperation[](1);
        ops[0] = _buildUserOp(targets, values, datas, mode_1, 10);

        _etch();
        vm.prank(pmAddr);
        ep.handleOps(ops, payable(pmAddr));
        vm.snapshotGasLastCall("test10Batch_OPFAccount");

        uint256 balanceAfter = IERC20(erc20).balanceOf(random);
        assertEq(balanceBefore + 10 ether, balanceAfter);
    }

    function _buildUserOp(
        address[] memory _target,
        uint256[] memory _value,
        bytes[] memory _data,
        bytes32 _mode,
        uint256 _calls
    ) internal returns (PackedUserOperation memory userOp) {
        Call[] memory calls = new Call[](_calls);
        for (uint256 i = 0; i < calls.length;) {
            calls[i] = Call({target: _target[i], value: _value[i], data: _data[i]});
            unchecked {
                i++;
            }
        }
        bytes memory payload = abi.encode(calls);
        bytes memory callData =
            abi.encodeWithSelector(bytes4(keccak256("execute(bytes32,bytes)")), _mode, payload);

        userOp = _getFreshUserOp();
        userOp.sender = owner;
        userOp.nonce = ep.getNonce(owner, 0);
        userOp.callData = callData;
        userOp.accountGasLimits = _packAccountGasLimits(600000, 400000);
        userOp.preVerificationGas = 800000;
        userOp.gasFees = _packGasFees(80 gwei, 15 gwei);
        userOp.paymasterAndData = _createPaymasterDataMode(userOp, ERC20_MODE, combinedByteBasic);
        bytes memory paymasterSignature = this._signPaymasterData(ERC20_MODE, userOp, 1);
        userOp.paymasterAndData = abi.encodePacked(userOp.paymasterAndData, paymasterSignature);
        userOp.signature = _signUserOpWithEOA(userOp);
    }

    function _approveTokens() internal {
        bytes memory approve = abi.encodeWithSelector(
            IERC20.approve.selector, _UNISWAP_V2_ROUTER_ADDRESS, type(uint256).max
        );

        Call[] memory calls = new Call[](2);
        calls[0] = Call({target: address(token0), value: 0, data: approve});
        calls[1] = Call({target: address(token1), value: 0, data: approve});

        bytes memory payload = abi.encode(calls);

        _etch();
        vm.prank(owner);
        account.execute(mode_1, payload);
    }

    function _createPaymasterDataMode(
        PackedUserOperation memory userOp,
        uint8 _mode,
        uint8 _combinedByte
    ) internal returns (bytes memory paymasterData) {
        uint128 verificationGasLimit = uint128(uint256(bytes32(userOp.accountGasLimits)) >> 128);
        _validWindow();
        if (_mode == VERIFYING_MODE) {
            paymasterData = abi.encodePacked(
                address(pm),
                verificationGasLimit,
                postGas,
                (_mode << 1) | MODE_AND_ALLOW_ALL_BUNDLERS_LENGTH,
                validUntil,
                validAfter
            );
        } else if (_mode == ERC20_MODE) {
            paymasterData = abi.encodePacked(
                address(pm),
                verificationGasLimit,
                postGas,
                (_mode << 1) | MODE_AND_ALLOW_ALL_BUNDLERS_LENGTH,
                _combinedByte,
                validUntil,
                validAfter,
                address(erc20),
                postGas,
                exchangeRate,
                paymasterValidationGasLimit,
                treasury
            );
            if ((_combinedByte & 0x04) != 0) {
                // preFundPresent
                uint128 reasonablePreFund = uint128((requiredPreFund * exchangeRate) / 1e18 / 2);
                paymasterData = abi.encodePacked(paymasterData, reasonablePreFund);
            }

            if ((_combinedByte & 0x01) != 0) {
                // constantFeePresent
                paymasterData = abi.encodePacked(paymasterData, uint128(10000)); // constantFee (16 bytes)
            }

            if ((_combinedByte & 0x02) != 0) {
                // recipientPresent
                paymasterData = abi.encodePacked(paymasterData, address(sender)); // recipient (20 bytes)
            }
        }
    }

    function _signPaymasterData(
        uint8 _mode,
        PackedUserOperation calldata _userOp,
        uint256 _signerIndx
    ) external view returns (bytes memory paymasterSignature) {
        bytes32 rawHash = pm.getHash(_mode, _userOp);
        bytes32 ethSignedHash = MessageHashUtils.toEthSignedMessageHash(rawHash);
        uint256 PK = signersPM_PK[_signerIndx];
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(PK, ethSignedHash);

        paymasterSignature = abi.encodePacked(r, s, v);
    }

    function _validWindow() internal {
        validUntil = uint48(block.timestamp + 1 days);
        validAfter = 0;
    }
}
