// SPDX-License-Identifier: MIT

pragma solidity 0.8.29;

contract Constants {
    /// --------------------------------------------------------------------------------- Payment Types
    enum PaymentType {
        SELF_ETH,
        SELF_ERC20,
        APP_SPONSOR, // App sponsoring transaction cost (in native tokens)
        APP_SPONSOR_ERC20 // App sponsoring transaction cost (in ERC20 tokens)

    }

    /// --------------------------------------------------------------------------------- Constants
    address internal constant ENTRY_POINT_V6 = 0x5FF137D4b0FDCD49DcA30c7CF57E578a026d2789;
    address internal constant ENTRY_POINT_V7 = 0x0000000071727De22E5E9d8BAf0edAc6f37da032;
    address constant _PIMLICO_PAYMASTER_V06 = 0x6666666666667849c56f2850848cE1C4da65c68b;
    address constant _PIMLICO_PAYMASTER_V07 = 0x777777777777AeC03fd955926DbF81597e66834C;

    /// --------------------------------------------------------------------------------- Accounts
    address internal constant _COINBASE_SMART_WALLET_IMPL_ADDR = 0x000100abaad02f1cfC8Bbe32bD5a564817339E72;
    address internal constant _COINBASE_SMART_WALLET_FACTORY_ADDR = 0x0BA5ED0c6AA8c49038F819E587E2633c4A9F428a;

    /// --------------------------------------------------------------------------------- Uniswap V2
    address internal constant _UNISWAP_V2_FACTORY_ADDRESS = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address internal constant _UNISWAP_V2_ROUTER_ADDRESS = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
}
