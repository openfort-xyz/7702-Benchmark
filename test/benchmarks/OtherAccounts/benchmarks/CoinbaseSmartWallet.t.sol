// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

import { Helpers } from "test/benchmarks/OtherAccounts/helpers/Helpers.t.sol";
import { SignatureCheckerLib } from "lib/solady/src/utils/SignatureCheckerLib.sol";
import { UserOperation } from "test/benchmarks/OtherAccounts/interfaces/IERC4337EntryPoint.sol";
import { PimlicoHelpers } from "test/benchmarks/OtherAccounts/interfaces/IPimlicoPaymaster.sol";
import {
    ICoinbaseSmartWalletFactory,
    SignatureWrapper
} from "test/benchmarks/OtherAccounts/interfaces/ICoinbaseSmartWallet.sol";

contract CoinbaseSmartWallet is Helpers {
    address internal receiver;

    function setUp() public virtual override {
        super.setUp();
        receiver = makeAddr("receiver");
        _warmUp();
    }

    function test_SendERC20Transfer_CoinbaseSmartWallet_DirectAA() public {
        bytes memory payload = abi.encodeWithSignature(
            "execute(address,uint256,bytes)",
            paymentToken,
            0,
            abi.encodeWithSignature("transfer(address,uint256)", receiver, 1 ether)
        );

        (address account, address eoa, uint256 privateKey) = _createSingleCoinbaseSmartWallet();
        UserOperation memory userOp = _buildCoinbaseUserOp(account, payload, PaymentType.SELF_ETH, eoa, privateKey);

        _relayUserOp(userOp, "test_SendERC20Transfer_CoinbaseSmartWallet_DirectAA");

        assertEq(paymentToken.balanceOf(receiver), 3 ether);
    }

    function test_SendERC20Transfer_CoinbaseSmartWallet_DirectAAERC20() public {
        bytes memory payload = abi.encodeWithSignature(
            "execute(address,uint256,bytes)",
            paymentToken,
            0,
            abi.encodeWithSignature("transfer(address,uint256)", receiver, 1 ether)
        );

        (address account, address eoa, uint256 privateKey) = _createSingleCoinbaseSmartWallet();
        UserOperation memory userOp = _buildCoinbaseUserOp(account, payload, PaymentType.SELF_ERC20, eoa, privateKey);

        _relayUserOp(userOp, "test_SendERC20Transfer_CoinbaseSmartWallet_DirectAAERC20");

        assertEq(paymentToken.balanceOf(receiver), 3 ether);
    }

    function test_SendERC20Transfer_Batch10_CoinbaseSmartWallet_DirectAA() public {
        Call[] memory calls = new Call[](10);
        for (uint256 i = 0; i < 10; i++) {
            calls[i].target = address(paymentToken);
            calls[i].value = 0;
            calls[i].data = abi.encodeWithSignature("transfer(address,uint256)", receiver, 1 ether);
        }

        bytes memory payload = abi.encodeWithSignature("executeBatch((address,uint256,bytes)[])", calls);

        (address account, address eoa, uint256 privateKey) = _createSingleCoinbaseSmartWallet();
        UserOperation memory userOp = _buildCoinbaseUserOp(account, payload, PaymentType.SELF_ETH, eoa, privateKey);

        _relayUserOp(userOp, "test_SendERC20Transfer_Batch10_CoinbaseSmartWallet_DirectAA");

        assertEq(paymentToken.balanceOf(receiver), 12 ether);
    }

    function test_SendERC20Transfer_Batch10_CoinbaseSmartWallet_DirectAAERC20() public {
        Call[] memory calls = new Call[](10);
        for (uint256 i = 0; i < 10; i++) {
            calls[i].target = address(paymentToken);
            calls[i].value = 0;
            calls[i].data = abi.encodeWithSignature("transfer(address,uint256)", receiver, 1 ether);
        }

        bytes memory payload = abi.encodeWithSignature("executeBatch((address,uint256,bytes)[])", calls);

        (address account, address eoa, uint256 privateKey) = _createSingleCoinbaseSmartWallet();
        UserOperation memory userOp = _buildCoinbaseUserOp(account, payload, PaymentType.SELF_ERC20, eoa, privateKey);

        _relayUserOp(userOp, "test_SendERC20Transfer_Batch10_CoinbaseSmartWallet_DirectAAERC20");

        assertEq(paymentToken.balanceOf(receiver), 12 ether);
    }

    function test_SendNativeTransfer_CoinbaseSmartWallet_DirectAA() public {
        bytes memory payload = abi.encodeWithSignature("execute(address,uint256,bytes)", receiver, 1 ether, "");
        (address account, address eoa, uint256 privateKey) = _createSingleCoinbaseSmartWallet();
        UserOperation memory userOp = _buildCoinbaseUserOp(account, payload, PaymentType.SELF_ETH, eoa, privateKey);

        _relayUserOp(userOp, "test_SendNativeTransfer_CoinbaseSmartWallet_DirectAA");

        assertEq(receiver.balance, 2 ether);
    }

    function test_SendNativeTransfer_CoinbaseSmartWallet_DirectAAERC20() public {
        bytes memory payload = abi.encodeWithSignature("execute(address,uint256,bytes)", receiver, 1 ether, "");
        (address account, address eoa, uint256 privateKey) = _createSingleCoinbaseSmartWallet();
        UserOperation memory userOp = _buildCoinbaseUserOp(account, payload, PaymentType.SELF_ERC20, eoa, privateKey);

        _relayUserOp(userOp, "test_SendNativeTransfer_CoinbaseSmartWallet_DirectAAERC20");

        assertEq(receiver.balance, 2 ether);
    }

    function test_SendUniswapV2Swap_CoinbaseSmartWallet_DirectAA() public {
        bytes memory payload = abi.encodeWithSignature(
            "execute(address,uint256,bytes)", _UNISWAP_V2_ROUTER_ADDRESS, 0, _uniswapV2SwapPayload()
        );
        (address account, address eoa, uint256 privateKey) = _createSingleCoinbaseSmartWallet();
        UserOperation memory userOp = _buildCoinbaseUserOp(account, payload, PaymentType.SELF_ETH, eoa, privateKey);

        _relayUserOp(userOp, "test_SendUniswapV2Swap_CoinbaseSmartWallet_DirectAA");
    }

    function test_SendUniswapV2Swap_CoinbaseSmartWallet_DirectAAERC20() public {
        bytes memory payload = abi.encodeWithSignature(
            "execute(address,uint256,bytes)", _UNISWAP_V2_ROUTER_ADDRESS, 0, _uniswapV2SwapPayload()
        );
        (address account, address eoa, uint256 privateKey) = _createSingleCoinbaseSmartWallet();
        UserOperation memory userOp = _buildCoinbaseUserOp(account, payload, PaymentType.SELF_ERC20, eoa, privateKey);

        _relayUserOp(userOp, "test_SendUniswapV2Swap_CoinbaseSmartWallet_DirectAAERC20");
    }

    function _createSingleCoinbaseSmartWallet() internal returns (address account, address eoa, uint256 privateKey) {
        (eoa, privateKey) = makeAddrAndKey("csw_single");
        bytes[] memory owners = new bytes[](1);
        owners[0] = abi.encode(eoa);
        account = ICoinbaseSmartWalletFactory(_COINBASE_SMART_WALLET_FACTORY_ADDR).createAccount(
            owners, uint256(uint160(eoa))
        );
        _giveAccountSomeTokens(account);
    }

    function _buildCoinbaseUserOp(
        address _account,
        bytes memory _payload,
        PaymentType _paymentType,
        address,
        uint256 _privateKey
    )
        internal
        view
        returns (UserOperation memory userOp)
    {
        userOp.sender = _account;
        userOp.nonce = erc4337EntryPointV6.getNonce(_account, 0);
        userOp.callData = _payload;
        userOp.callGasLimit = 1_000_000;
        userOp.verificationGasLimit = 1_000_000;
        userOp.preVerificationGas = 1_000_000;
        userOp.maxFeePerGas = 1_000_000;
        userOp.maxPriorityFeePerGas = 1_000_000;

        if (_paymentType == PaymentType.SELF_ERC20) {
            userOp.paymasterAndData = abi.encodePacked(
                _PIMLICO_PAYMASTER_V06,
                uint8(1) | uint8(1 << 1),
                uint8(0),
                type(uint48).max,
                uint48(0),
                paymentToken,
                uint128(100_000),
                uint256(1e18),
                uint128(100_000),
                relayer
            );

            userOp.paymasterAndData = abi.encodePacked(
                userOp.paymasterAndData,
                _eoaSig(
                    paymasterPrivateKey, SignatureCheckerLib.toEthSignedMessageHash(PimlicoHelpers.getHashV6(1, userOp))
                )
            );
        } else if (_paymentType == PaymentType.APP_SPONSOR) {
            userOp.paymasterAndData = abi.encodePacked(_PIMLICO_PAYMASTER_V06, uint8(1), type(uint48).max, uint48(0));

            userOp.paymasterAndData = abi.encodePacked(
                userOp.paymasterAndData,
                _eoaSig(
                    paymasterPrivateKey, SignatureCheckerLib.toEthSignedMessageHash(PimlicoHelpers.getHashV6(0, userOp))
                )
            );
        }

        bytes memory rawSig = _signUserOpV6(userOp, _privateKey);
        userOp.signature = abi.encode(SignatureWrapper({ ownerIndex: 0, signatureData: rawSig }));
    }

    function _relayUserOp(UserOperation memory _userOp, string memory _testName) internal {
        UserOperation[] memory ops = new UserOperation[](1);
        ops[0] = _userOp;

        vm.startPrank(relayer);
        erc4337EntryPointV6.handleOps(ops, payable(relayer));
        vm.stopPrank();

        if (bytes(_testName).length > 0) {
            vm.snapshotGasLastCall(_testName);
        }
    }

    function _warmUp() internal {
        bytes memory payload = abi.encodeWithSignature(
            "execute(address,uint256,bytes)",
            paymentToken,
            0,
            abi.encodeWithSignature("transfer(address,uint256)", receiver, 1 ether)
        );

        (address account, address eoa, uint256 privateKey) = _createSingleCoinbaseSmartWallet();
        UserOperation memory userOp = _buildCoinbaseUserOp(account, payload, PaymentType.SELF_ETH, eoa, privateKey);

        _relayUserOp(userOp, "");
    
        payload = abi.encodeWithSignature(
            "execute(address,uint256,bytes)",
            paymentToken,
            0,
            abi.encodeWithSignature("transfer(address,uint256)", receiver, 1 ether)
        );
        userOp = _buildCoinbaseUserOp(account, payload, PaymentType.SELF_ERC20, eoa, privateKey);

        _relayUserOp(userOp, "");

        payload = abi.encodeWithSignature("execute(address,uint256,bytes)", receiver, 1 ether, "");
        userOp = _buildCoinbaseUserOp(account, payload, PaymentType.SELF_ETH, eoa, privateKey);

        _relayUserOp(userOp, "");

        payload = abi.encodeWithSignature(
            "execute(address,uint256,bytes)", _UNISWAP_V2_ROUTER_ADDRESS, 0, _uniswapV2SwapPayload()
        );
        userOp = _buildCoinbaseUserOp(account, payload, PaymentType.SELF_ETH, eoa, privateKey);

        _relayUserOp(userOp, "");
    }
}
