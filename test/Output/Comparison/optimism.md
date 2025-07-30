# Smart Account Provider Gas Cost Comparison (Optimism)

[Ethereum Mainnet](./ethereum.md) | [Base Mainnet](./base.md) | [Arbitrum Mainnet](./arbitrum.md) | **Optimism Mainnet**

## Account Creation/Deployment

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| Openfort | Deploy OPF (Direct) | 5,432,749 | $0.0253 |
| Alchemy Modular Account v2 | Account creation | 97,772 | $0.00047 |
| Biconomy Nexus | Account creation | 210,309 | $0.00094 |
| ZeroDev Kernel v3.1 | Account creation | 180,465 | $0.00089 |
| Safe v1.4.1 (non-modular) | Account creation | 289,207 | $0.00136 |
| Alchemy Light Account v2 (non-modular) | Account creation | 169,655 | $0.00075 |
| Coinbase Smart Wallet (non-modular) | Account creation | 190,525 | $0.00086 |
| Simple Account (non-modular) | Account creation | 174,219 | $0.00077 |

## User Operations (UOP/Sponsored Transactions)

### Native Transfer (UOP)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| Openfort | Send ETH (UOP) | 139,786 | $0.0005 |
| Openfort | Send ETH P256 (UOP) | 338,809 | $0.0012 |
| Openfort | Send ETH w/ MK (UOP) | 556,561 | $0.0020 |
| Openfort | Send ETH w/ SK-EOA (UOP) | 132,835 | $0.0005 |
| Alchemy Light Account v2 (non-modular) | Native transfer (UOP) | 151,148 | $0.00088 |
| Simple Account (non-modular) | Native transfer (UOP) | 151,045 | $0.00088 |
| Alchemy Modular Account v2 | Native transfer (UOP) | 158,725 | $0.00091 |
| Coinbase Smart Wallet (non-modular) | Native transfer (UOP) | 156,812 | $0.00094 |
| Biconomy Nexus | Native transfer (UOP) | 164,351 | $0.00095 |
| Safe v1.4.1 (non-modular) | Native transfer (UOP) | 176,479 | $0.00100 |
| ZeroDev Kernel v3.1 | Native transfer (UOP) | 190,912 | $0.00105 |

### ERC-20 Transfer (UOP)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| Openfort | Transfer ERC20 (UOP) | 138,733 | $0.0005 |
| Openfort | Transfer ERC20 w/ P256 (UOP) | 363,470 | $0.0013 |
| Openfort | Transfer ERC20 w/ MK (UOP) | 566,788 | $0.0021 |
| Alchemy Light Account v2 (non-modular) | ERC-20 transfer (UOP) | 175,294 | $0.00100 |
| Simple Account (non-modular) | ERC-20 transfer (UOP) | 175,283 | $0.00100 |
| Alchemy Modular Account v2 | ERC-20 transfer (UOP) | 182,665 | $0.00103 |
| Coinbase Smart Wallet (non-modular) | ERC-20 transfer (UOP) | 181,014 | $0.00106 |
| Biconomy Nexus | ERC-20 transfer (UOP) | 188,136 | $0.00106 |
| Safe v1.4.1 (non-modular) | ERC-20 transfer (UOP) | 200,732 | $0.00112 |
| ZeroDev Kernel v3.1 | ERC-20 transfer (UOP) | 214,817 | $0.00117 |

### Uniswap V3 ERC-20 Swap (UOP)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| Openfort | Swap ETH for USDC (UOP) | 215,869 | $0.0008 |
| Openfort | Swap ETH for USDC w/ P256 (UOP) | 426,090 | $0.0016 |
| Openfort | Swap ETH for USDC w/ MK (UOP) | 647,811 | $0.0024 |
| Alchemy Light Account v2 (non-modular) | Uniswap V3 ERC-20 swap (UOP) | 194,407 | $0.00114 |
| Simple Account (non-modular) | Uniswap V3 ERC-20 swap (UOP) | 194,829 | $0.00114 |
| Alchemy Modular Account v2 | Uniswap V3 ERC-20 swap (UOP) | 201,790 | $0.00117 |
| Coinbase Smart Wallet (non-modular) | Uniswap V3 ERC-20 swap (UOP) | 200,573 | $0.00120 |
| Biconomy Nexus | Uniswap V3 ERC-20 swap (UOP) | 207,286 | $0.00120 |
| Safe v1.4.1 (non-modular) | Uniswap V3 ERC-20 swap (UOP) | 220,464 | $0.00126 |
| ZeroDev Kernel v3.1 | Uniswap V3 ERC-20 swap (UOP) | 234,378 | $0.00130 |

### Session Key Operations (UOP)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| Openfort | Register EOA (UOP) | 326,688 | $0.0012 |
| Openfort | Register P256 (Non-Extrac UOP) | 406,818 | $0.0015 |
| Openfort | Register P256 (UOP) | 406,818 | $0.0015 |
| Openfort | Register P256 (Non-Extrac w/ MK UOP) | 842,591 | $0.0031 |
| Alchemy Modular Account v2 | Session key creation | 495,041 | $0.00250 |
| Alchemy Modular Account v2 | Session key native transfer | 172,036 | $0.00097 |
| Alchemy Modular Account v2 | Session key ERC-20 transfer | 197,295 | $0.00109 |
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
| Openfort | Send ETH | 64,918 | $0.0002 |
| Simple Account (non-modular) | Native transfer (Runtime) | 39,381 | $0.00027 |
| Alchemy Light Account v2 (non-modular) | Native transfer (Runtime) | 39,463 | $0.00027 |
| Coinbase Smart Wallet (non-modular) | Native transfer (Runtime) | 39,681 | $0.00027 |
| Biconomy Nexus | Native transfer (Runtime) | 39,685 | $0.00028 |
| ZeroDev Kernel v3.1 | Native transfer (Runtime) | 48,615 | $0.00031 |
| Alchemy Modular Account v2 | Native transfer (Runtime) | 49,021 | $0.00031 |
| Safe v1.4.1 (non-modular) | Native transfer (Runtime) | 75,840 | $0.00051 |

### ERC-20 Transfer (Direct)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| Openfort | Transfer ERC20 | 63,813 | $0.0002 |
| Simple Account (non-modular) | ERC-20 transfer (Runtime) | 63,503 | $0.00039 |
| Alchemy Light Account v2 (non-modular) | ERC-20 transfer (Runtime) | 63,505 | $0.00039 |
| Biconomy Nexus | ERC-20 transfer (Runtime) | 63,384 | $0.00039 |
| Coinbase Smart Wallet (non-modular) | ERC-20 transfer (Runtime) | 63,803 | $0.00039 |
| ZeroDev Kernel v3.1 | ERC-20 transfer (Runtime) | 72,317 | $0.00042 |
| Alchemy Modular Account v2 | ERC-20 transfer (Runtime) | 72,946 | $0.00043 |
| Safe v1.4.1 (non-modular) | ERC-20 transfer (Runtime) | 99,715 | $0.00063 |

### Uniswap V3 ERC-20 Swap (Direct)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| Openfort | Swap ETH for USDC | 163,514 | $0.0006 |
| Simple Account (non-modular) | Uniswap V3 ERC-20 swap (Runtime) | 136,943 | $0.00073 |
| Alchemy Light Account v2 (non-modular) | Uniswap V3 ERC-20 swap (Runtime) | 136,524 | $0.00073 |
| Biconomy Nexus | Uniswap V3 ERC-20 swap (Runtime) | 136,403 | $0.00073 |
| Coinbase Smart Wallet (non-modular) | Uniswap V3 ERC-20 swap (Runtime) | 137,243 | $0.00073 |
| ZeroDev Kernel v3.1 | Uniswap V3 ERC-20 swap (Runtime) | 145,355 | $0.00076 |
| Alchemy Modular Account v2 | Uniswap V3 ERC-20 swap (Runtime) | 145,956 | $0.00077 |
| Safe v1.4.1 (non-modular) | Uniswap V3 ERC-20 swap (Runtime) | 155,690 | $0.00090 |
