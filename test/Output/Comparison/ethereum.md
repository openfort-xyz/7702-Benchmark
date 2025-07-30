# Smart Account Provider Gas Cost Comparison (Mainnet)

**Ethereum Mainnet** | [Base Mainnet](./base.md) | [Arbitrum Mainnet](./arbitrum.md) | [Optimism Mainnet](./optimism.md)

## Account Creation/Deployment

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| **Openfort** | Deploy OPF | **5,417,157** | **$17.86** |
| Alchemy Modular Account v2 | Account Creation | 97,772 | $0.75 |
| Biconomy Nexus | Account Creation | 210,309 | $1.62 |
| ZeroDev Kernel v3.1 | Account Creation | 180,465 | $1.39 |
| Safe v1.4.1 (non-modular) | Account Creation | 289,207 | $2.23 |
| Alchemy Light Account v2 (non-modular) | Account Creation | 169,655 | $1.31 |
| Coinbase Smart Wallet (non-modular) | Account Creation | 190,525 | $1.47 |
| Simple Account (non-modular) | Account Creation | 174,219 | $1.34 |

## User Operations (UOP/Sponsored Transactions)

### Native Transfer (UOP)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| **Openfort** | Send ETH (UOP) | **139,786** | **$0.46** |
| **Openfort** | Send ETH P256 (UOP) | **337,933** | **$1.11** |
| **Openfort** | Send ETH w/ MK (UOP) | **538,189** | **$1.77** |
| **Openfort** | Send ETH w/ SK-EOA (UOP) | **132,847** | **$0.44** |
| Simple Account (non-modular) | Native Transfer | 151,045 | $1.16 |
| Alchemy Light Account v2 (non-modular) | Native Transfer | 151,148 | $1.17 |
| Alchemy Modular Account v2 | Native Transfer | 158,725 | $1.22 |
| Biconomy Nexus | Native Transfer | 164,351 | $1.27 |
| Coinbase Smart Wallet (non-modular) | Native Transfer | 156,812 | $1.21 |
| Safe v1.4.1 (non-modular) | Native Transfer | 176,479 | $1.36 |
| ZeroDev Kernel v3.1 | Native Transfer | 190,912 | $1.47 |

### ERC-20 Transfer (UOP)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| **Openfort** | Transfer ERC20 (UOP) | **108,874** | **$0.36** |
| **Openfort** | Transfer ERC20 w/ P256 (UOP) | **332,759** | **$1.10** |
| **Openfort** | Transfer ERC20 w/ MK (UOP) | **547,978** | **$1.81** |
| Alchemy Light Account v2 (non-modular) | ERC20 Transfer | 175,294 | $1.35 |
| Simple Account (non-modular) | ERC20 Transfer | 175,283 | $1.35 |
| Coinbase Smart Wallet (non-modular) | ERC20 Transfer | 181,014 | $1.40 |
| Alchemy Modular Account v2 | ERC20 Transfer | 182,665 | $1.41 |
| Biconomy Nexus | ERC20 Transfer | 188,136 | $1.45 |
| Safe v1.4.1 (non-modular) | ERC20 Transfer | 200,732 | $1.55 |
| ZeroDev Kernel v3.1 | ERC20 Transfer | 214,817 | $1.66 |

### Uniswap V3 ERC-20 Swap (UOP)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| **Openfort** | Swap ETH for USDC (UOP) | **206,597** | **$0.68** |
| **Openfort** | Swap ETH for USDC w/ P256 (UOP) | **414,628** | **$1.37** |
| **Openfort** | Swap ETH for USDC w/ MK (UOP) | **633,350** | **$2.09** |
| Alchemy Light Account v2 (non-modular) | Uniswap V3 Swap | 194,407 | $1.50 |
| Simple Account (non-modular) | Uniswap V3 Swap | 194,829 | $1.50 |
| Coinbase Smart Wallet (non-modular) | Uniswap V3 Swap | 200,573 | $1.55 |
| Alchemy Modular Account v2 | Uniswap V3 Swap | 201,790 | $1.56 |
| Biconomy Nexus | Uniswap V3 Swap | 207,286 | $1.60 |
| Safe v1.4.1 (non-modular) | Uniswap V3 Swap | 220,464 | $1.70 |
| ZeroDev Kernel v3.1 | Uniswap V3 Swap | 234,378 | $1.81 |

### Session Key Operations (UOP)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| **Openfort** | Register EOA (UOP) | **326,688** | **$1.08** |
| **Openfort** | Register P256 | **333,507** | **$1.10** |
| **Openfort** | Register P256 (UOP) | **406,818** | **$1.34** |
| **Openfort** | Register P256 (Non-Extrac UOP) | **406,818** | **$1.34** |
| **Openfort** | Register P256 (Non-Extrac) | **333,507** | **$1.10** |
| **Openfort** | Register P256 (Non-Extrac w/ MK UOP) | **843,337** | **$2.78** |
| Alchemy Modular Account v2 | Session Key Creation | 495,041 | $3.82 |
| Biconomy Nexus | Session Key Creation | Unsupported | - |
| ZeroDev Kernel v3.1 | Session Key Creation | Unsupported | - |
| Safe v1.4.1 (non-modular) | Session Key Creation | Unsupported | - |
| Alchemy Light Account v2 (non-modular) | Session Key Creation | Unsupported | - |
| Coinbase Smart Wallet (non-modular) | Session Key Creation | Unsupported | - |
| Simple Account (non-modular) | Session Key Creation | Unsupported | - |

### Session Key Operations (UOP)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| **Openfort** | Send ETH w/ SK-EOA (UOP) | **132,847** | **$0.44** |
| **Openfort** | Send ETH P256 (UOP) | **337,933** | **$1.11** |
| **Openfort** | Send ETH w/ MK (UOP) | **538,189** | **$1.77** |
| Alchemy Modular Account v2 | Session Key Native Transfer | 172,036 | $1.33 |
| Biconomy Nexus | Session Key Native Transfer | Unsupported | - |
| ZeroDev Kernel v3.1 | Session Key Native Transfer | Unsupported | - |
| Safe v1.4.1 (non-modular) | Session Key Native Transfer | Unsupported | - |
| Alchemy Light Account v2 (non-modular) | Session Key Native Transfer | Unsupported | - |
| Coinbase Smart Wallet (non-modular) | Session Key Native Transfer | Unsupported | - |
| Simple Account (non-modular) | Session Key Native Transfer | Unsupported | - |

# Session Key ERC20 Transfer Comparison

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| **Openfort** | Transfer ERC20 w/ P256 (UOP) | **332,759** | **$1.10** |
| **Openfort** | Transfer ERC20 w/ MK (UOP) | **547,978** | **$1.81** |
| Alchemy Modular Account v2 | Session Key ERC20 Transfer | 197,295 | $1.52 |
| Biconomy Nexus | Session Key ERC20 Transfer | Unsupported | - |
| ZeroDev Kernel v3.1 | Session Key ERC20 Transfer | Unsupported | - |
| Safe v1.4.1 (non-modular) | Session Key ERC20 Transfer | Unsupported | - |
| Alchemy Light Account v2 (non-modular) | Session Key ERC20 Transfer | Unsupported | - |
| Coinbase Smart Wallet (non-modular) | Session Key ERC20 Transfer | Unsupported | - |
| Simple Account (non-modular) | Session Key ERC20 Transfer | Unsupported | - |

## Direct Transactions (Runtime Operations)

### Native Transfer (Direct)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| **Openfort** | Send ETH | **64,918** | **$0.21** |
| Simple Account (non-modular) | Native Transfer | 39,381 | $0.30 |
| Alchemy Light Account v2 (non-modular) | Native Transfer | 39,463 | $0.30 |
| Biconomy Nexus | Native Transfer | 39,685 | $0.31 |
| Coinbase Smart Wallet (non-modular) | Native Transfer | 39,681 | $0.31 |
| ZeroDev Kernel v3.1 | Native Transfer | 48,615 | $0.37 |
| Alchemy Modular Account v2 | Native Transfer | 49,021 | $0.38 |
| Safe v1.4.1 (non-modular) | Native Transfer | 75,840 | $0.58 |

### ERC-20 Transfer (Direct)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| **Openfort** | Transfer ERC20 | **33,954** | **$0.11** |
| Simple Account (non-modular) | ERC20 Transfer | 63,503 | $0.49 |
| Alchemy Light Account v2 (non-modular) | ERC20 Transfer | 63,505 | $0.49 |
| Biconomy Nexus | ERC20 Transfer | 63,384 | $0.49 |
| Coinbase Smart Wallet (non-modular) | ERC20 Transfer | 63,803 | $0.49 |
| ZeroDev Kernel v3.1 | ERC20 Transfer | 72,317 | $0.56 |
| Alchemy Modular Account v2 | ERC20 Transfer | 72,946 | $0.56 |
| Safe v1.4.1 (non-modular) | ERC20 Transfer | 99,715 | $0.77 |


### Uniswap V3 ERC-20 Swap (Direct)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| **Openfort** | Swap ETH for USDC | **154,242** | **$0.51** |
| Simple Account (non-modular) | Uniswap V3 Swap | 136,943 | $1.06 |
| Alchemy Light Account v2 (non-modular) | Uniswap V3 Swap | 136,524 | $1.05 |
| Biconomy Nexus | Uniswap V3 Swap | 136,403 | $1.05 |
| Coinbase Smart Wallet (non-modular) | Uniswap V3 Swap | 137,243 | $1.06 |
| ZeroDev Kernel v3.1 | Uniswap V3 Swap | 145,355 | $1.12 |
| Alchemy Modular Account v2 | Uniswap V3 Swap | 145,956 | $1.13 |
| Safe v1.4.1 (non-modular) | Uniswap V3 Swap | 155,690 | $1.20 |

