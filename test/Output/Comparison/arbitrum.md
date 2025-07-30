# Smart Account Provider Gas Cost Comparison (Arbitrum)
**Disclaimer: We have prepared a comparison report between the Openfort 7702 Account and a standard Smart Contract Account (AA).**

[Ethereum Mainnet](./ethereum.md) | [Base Mainnet](./base.md) | **Arbitrum Mainnet** | [Optimism Mainnet](./optimism.md)

## Account Creation/Deployment

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| Openfort | Deploy OPF (Direct) | 5,427,494 | $1.6747 |
| Alchemy Modular Account v2 | Account creation | 97,772 | $0.00374 |
| Biconomy Nexus | Account creation | 210,309 | $0.00804 |
| ZeroDev Kernel v3.1 | Account creation | 180,465 | $0.00689 |
| Safe v1.4.1 (non-modular) | Account creation | 289,207 | $0.01105 |
| Alchemy Light Account v2 (non-modular) | Account creation | 169,655 | $0.00648 |
| Coinbase Smart Wallet (non-modular) | Account creation | 190,525 | $0.00728 |
| Simple Account (non-modular) | Account creation | 174,219 | $0.00666 |

> *Creation account with Openfort is type 4 transaction. Approximate gas cost ~46,400-50,000*

## User Operations (UOP/Sponsored Transactions)

### Native Transfer (UOP)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| Openfort | Send ETH (UOP) | 139,786 | $0.0431 |
| Openfort | Send ETH P256 (UOP) | 337,495 | $0.1041 |
| Openfort | Send ETH w/ MK (UOP) | 552,663 | $0.1705 |
| Openfort | Send ETH w/ SK-EOA (UOP) | 132,847 | $0.0409 |
| Alchemy Modular Account v2 | Native transfer (UOP) | 158,725 | $0.00606 |
| Biconomy Nexus | Native transfer (UOP) | 164,351 | $0.00628 |
| ZeroDev Kernel v3.1 | Native transfer (UOP) | 190,912 | $0.00729 |
| Safe v1.4.1 (non-modular) | Native transfer (UOP) | 176,479 | $0.00674 |
| Alchemy Light Account v2 (non-modular) | Native transfer (UOP) | 151,148 | $0.00577 |
| Coinbase Smart Wallet (non-modular) | Native transfer (UOP) | 156,812 | $0.00599 |
| Simple Account (non-modular) | Native transfer (UOP) | 151,045 | $0.00577 |

### ERC-20 Transfer (UOP)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| Openfort | Transfer ERC20 (UOP) | 138,733 | $0.0428 |
| Openfort | Transfer ERC20 w/ MK (UOP) | 575,240 | $0.1775 |
| Openfort | Transfer ERC20 w/ P256 (UOP) | 361,521 | $0.1115 |
| Alchemy Modular Account v2 | ERC-20 transfer (UOP) | 182,665 | $0.00698 |
| Biconomy Nexus | ERC-20 transfer (UOP) | 188,136 | $0.00719 |
| ZeroDev Kernel v3.1 | ERC-20 transfer (UOP) | 214,817 | $0.00821 |
| Safe v1.4.1 (non-modular) | ERC-20 transfer (UOP) | 200,732 | $0.00767 |
| Alchemy Light Account v2 (non-modular) | ERC-20 transfer (UOP) | 175,294 | $0.00670 |
| Coinbase Smart Wallet (non-modular) | ERC-20 transfer (UOP) | 181,014 | $0.00692 |
| Simple Account (non-modular) | ERC-20 transfer (UOP) | 175,283 | $0.00670 |

### Uniswap V3 ERC-20 Swap (UOP)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| Openfort | Swap ETH for USDC (UOP) | 222,080 | $0.0685 |
| Openfort | Swap ETH for USDC w/ MK (UOP) | 654,678 | $0.2020 |
| Openfort | Swap ETH for USDC w/ P256 (UOP) | 432,301 | $0.1333 |
| Alchemy Modular Account v2 | Uniswap V3 ERC-20 swap (UOP) | 201,790 | $0.00771 |
| Biconomy Nexus | Uniswap V3 ERC-20 swap (UOP) | 207,286 | $0.00792 |
| ZeroDev Kernel v3.1 | Uniswap V3 ERC-20 swap (UOP) | 234,378 | $0.00895 |
| Safe v1.4.1 (non-modular) | Uniswap V3 ERC-20 swap (UOP) | 220,464 | $0.00842 |
| Alchemy Light Account v2 (non-modular) | Uniswap V3 ERC-20 swap (UOP) | 194,407 | $0.00743 |
| Coinbase Smart Wallet (non-modular) | Uniswap V3 ERC-20 swap (UOP) | 200,573 | $0.00766 |
| Simple Account (non-modular) | Uniswap V3 ERC-20 swap (UOP) | 194,829 | $0.00744 |

### Session Key Operations (UOP)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| Openfort | Register EOA (UOP) | 326,676 | $0.1008 |
| Openfort | Register P256 (Non-Extrac UOP) | 406,818 | $0.1255 |
| Openfort | Register P256 (Non-Extrac w/ MK UOP) | 840,853 | $0.2594 |
| Openfort | Register P256 (UOP) | 406,806 | $0.1255 |
| Alchemy Modular Account v2 | Session key creation | 495,041 | $0.01891 |
| Alchemy Modular Account v2 | Session key native transfer | 172,036 | $0.00657 |
| Alchemy Modular Account v2 | Session key ERC-20 transfer | 197,295 | $0.00754 |
| Biconomy Nexus | Session key operations | Unsupported | Unsupported |
| ZeroDev Kernel v3.1 | Session key operations | Unsupported | Unsupported |
| Safe v1.4.1 (non-modular) | Session key operations | Unsupported | Unsupported |
| Alchemy Light Account v2 (non-modular) | Session key operations | Unsupported | Unsupported |
| Coinbase Smart Wallet (non-modular) | Session key operations | Unsupported | Unsupported |
| Simple Account (non-modular) | Session key operations | Unsupported | Unsupported |

## Direct Transactions (Runtime Operations)

### Native Transfer (Direct)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| Openfort | Send ETH | 64,918 | $0.0200 |
| Alchemy Modular Account v2 | Native transfer (Runtime) | 49,021 | $0.00187 |
| Biconomy Nexus | Native transfer (Runtime) | 39,685 | $0.00152 |
| ZeroDev Kernel v3.1 | Native transfer (Runtime) | 48,615 | $0.00186 |
| Safe v1.4.1 (non-modular) | Native transfer (Runtime) | 75,840 | $0.00290 |
| Alchemy Light Account v2 (non-modular) | Native transfer (Runtime) | 39,463 | $0.00151 |
| Coinbase Smart Wallet (non-modular) | Native transfer (Runtime) | 39,681 | $0.00152 |
| Simple Account (non-modular) | Native transfer (Runtime) | 39,381 | $0.00150 |

### ERC-20 Transfer (Direct)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| Openfort | Transfer ERC20 | 63,813 | $0.0196 |
| Alchemy Modular Account v2 | ERC-20 transfer (Runtime) | 72,946 | $0.00279 |
| Biconomy Nexus | ERC-20 transfer (Runtime) | 63,384 | $0.00242 |
| ZeroDev Kernel v3.1 | ERC-20 transfer (Runtime) | 72,317 | $0.00276 |
| Safe v1.4.1 (non-modular) | ERC-20 transfer (Runtime) | 99,715 | $0.00381 |
| Alchemy Light Account v2 (non-modular) | ERC-20 transfer (Runtime) | 63,505 | $0.00243 |
| Coinbase Smart Wallet (non-modular) | ERC-20 transfer (Runtime) | 63,803 | $0.00244 |
| Simple Account (non-modular) | ERC-20 transfer (Runtime) | 63,503 | $0.00243 |

### Uniswap V3 ERC-20 Swap (Direct)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| Openfort | Swap ETH for USDC | 169,725 | $0.0523 |
| Alchemy Modular Account v2 | Uniswap V3 ERC-20 swap (Runtime) | 145,956 | $0.00558 |
| Biconomy Nexus | Uniswap V3 ERC-20 swap (Runtime) | 136,403 | $0.00521 |
| ZeroDev Kernel v3.1 | Uniswap V3 ERC-20 swap (Runtime) | 145,355 | $0.00555 |
| Safe v1.4.1 (non-modular) | Uniswap V3 ERC-20 swap (Runtime) | 155,690 | $0.00595 |
| Alchemy Light Account v2 (non-modular) | Uniswap V3 ERC-20 swap (Runtime) | 136,524 | $0.00522 |
| Coinbase Smart Wallet (non-modular) | Uniswap V3 ERC-20 swap (Runtime) | 137,243 | $0.00524 |
| Simple Account (non-modular) | Uniswap V3 ERC-20 swap (Runtime) | 136,943 | $0.00523 |

### Session Key Registration (Direct)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| Openfort | Register EOA | 253,377 | $0.0781 |
| Openfort | Register P256 | 333,507 | $0.1029 |
| Openfort | Register P256 (Non-Extrac) | 333,507 | $0.1029 |
