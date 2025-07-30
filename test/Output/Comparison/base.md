# Smart Account Provider Gas Cost Comparison (Base)
**Disclaimer: We have prepared a comparison report between the Openfort 7702 Account and a standard Smart Contract Account (AA).**

[Ethereum Mainnet](./ethereum.md) | **Base Mainnet** | [Arbitrum Mainnet](./arbitrum.md) | [Optimism Mainnet](./optimism.md)

## Account Creation/Deployment

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| **Openfort** | Deploy OPF | **5,422,292** | **$0.1384** |
| Alchemy Modular Account v2 | Account Creation | 97,772 | $0.00156 |
| Alchemy Light Account v2 (non-modular) | Account Creation | 169,655 | $0.00267 |
| Simple Account (non-modular) | Account Creation | 174,219 | $0.00274 |
| ZeroDev Kernel v3.1 | Account Creation | 180,465 | $0.00288 |
| Coinbase Smart Wallet (non-modular) | Account Creation | 190,525 | $0.00300 |
| Biconomy Nexus | Account Creation | 210,309 | $0.00331 |
| Safe v1.4.1 (non-modular) | Account Creation | 289,207 | $0.00458 |

> *Creation account with Openfort is type 4 transaction. Approximate gas cost ~46,400-50,000*


## User Operations (UOP/Sponsored Transactions)

### Native Transfer (UOP)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| **Openfort** | Send ETH w/ SK-EOA (UOP) | **132,847** | **$0.0033** |
| **Openfort** | Send ETH (UOP) | **139,786** | **$0.0035** |
| **Openfort** | Send ETH w/ MK (UOP) | **552,956** | **$0.0138** |
| **Openfort** | Send ETH P256 (UOP) | **335,743** | **$0.0084** |
| Alchemy Light Account v2 (non-modular) | Native Transfer | 151,148 | $0.00247 |
| Coinbase Smart Wallet (non-modular) | Native Transfer | 156,812 | $0.00257 |
| Alchemy Modular Account v2 | Native Transfer | 158,725 | $0.00259 |
| Biconomy Nexus | Native Transfer | 164,351 | $0.00268 |
| Safe v1.4.1 (non-modular) | Native Transfer | 176,479 | $0.00287 |
| ZeroDev Kernel v3.1 | Native Transfer | 190,912 | $0.00309 |

### ERC-20 Transfer (UOP)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| **Openfort** | Transfer ERC20 (UOP) | **138,721** | **$0.0034** |
| **Openfort** | Transfer ERC20 w/ MK (UOP) | **572,238** | **$0.0143** |
| **Openfort** | Transfer ERC20 w/ P256 (UOP) | **361,742** | **$0.0090** |
| Alchemy Light Account v2 (non-modular) | ERC20 Transfer | 175,294 | $0.00285 |
| Simple Account (non-modular) | ERC20 Transfer | 175,283 | $0.00285 |
| Alchemy Modular Account v2 | ERC20 Transfer | 182,665 | $0.00297 |
| Coinbase Smart Wallet (non-modular) | ERC20 Transfer | 181,014 | $0.00296 |
| Biconomy Nexus | ERC20 Transfer | 188,136 | $0.00306 |
| Safe v1.4.1 (non-modular) | ERC20 Transfer | 200,732 | $0.00326 |
| ZeroDev Kernel v3.1 | ERC20 Transfer | 214,817 | $0.00347 |

### Uniswap V3 ERC-20 Swap (UOP)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| **Openfort** | Swap ETH for USDC (UOP) | **121,405** | **$0.0030** |
| **Openfort** | Swap ETH for USDC w/ MK (UOP) | **540,329** | **$0.0135** |
| **Openfort** | Swap ETH for USDC w/ P256 (UOP) | **331,188** | **$0.0083** |
| Alchemy Light Account v2 (non-modular) | Uniswap V3 Swap | 194,407 | $0.00318 |
| Simple Account (non-modular) | Uniswap V3 Swap | 194,829 | $0.00318 |
| Coinbase Smart Wallet (non-modular) | Uniswap V3 Swap | 200,573 | $0.00329 |
| Alchemy Modular Account v2 | Uniswap V3 Swap | 201,790 | $0.00329 |
| Biconomy Nexus | Uniswap V3 Swap | 207,286 | $0.00338 |
| Safe v1.4.1 (non-modular) | Uniswap V3 Swap | 220,464 | $0.00359 |
| ZeroDev Kernel v3.1 | Uniswap V3 Swap | 234,378 | $0.00380 |

### Session Key Operations (UOP)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| **Openfort** | Send ETH w/ SK-EOA (UOP) | **132,847** | **$0.0033** |
| **Openfort** | Register EOA | **253,377** | **$0.0063** |
| **Openfort** | Register EOA (UOP) | **326,688** | **$0.0082** |
| **Openfort** | Register P256 | **333,507** | **$0.0083** |
| **Openfort** | Register P256 (UOP) | **406,818** | **$0.0102** |
| **Openfort** | Register P256 (Non-Extrac w/ MK UOP) | **844,167** | **$0.0211** |
| Alchemy Modular Account v2 | Session Key Native Transfer | 172,036 | $0.00279 |
| Alchemy Modular Account v2 | Session Key ERC20 Transfer | 197,295 | $0.00320 |
| Alchemy Modular Account v2 | Session Key Creation | 495,041 | $0.00791 |
| Biconomy Nexus | Session Key Operations | Unsupported | - |
| ZeroDev Kernel v3.1 | Session Key Operations | Unsupported | - |
| Safe v1.4.1 (non-modular) | Session Key Operations | Unsupported | - |
| Alchemy Light Account v2 (non-modular) | Session Key Operations | Unsupported | - |
| Coinbase Smart Wallet (non-modular) | Session Key Operations | Unsupported | - |
| Simple Account (non-modular) | Session Key Operations | Unsupported | - |

## Direct Transactions (Runtime Operations)

## Native Transfer (Direct)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| **Openfort** | Send ETH | **64,918** | **$0.0016** |
| Simple Account (non-modular) | Native Transfer | 39,381 | $0.00066 |
| Alchemy Light Account v2 (non-modular) | Native Transfer | 39,463 | $0.00066 |
| Coinbase Smart Wallet (non-modular) | Native Transfer | 39,681 | $0.00066 |
| Biconomy Nexus | Native Transfer | 39,685 | $0.00067 |
| ZeroDev Kernel v3.1 | Native Transfer | 48,615 | $0.00081 |
| Alchemy Modular Account v2 | Native Transfer | 49,021 | $0.00081 |
| Safe v1.4.1 (non-modular) | Native Transfer | 75,840 | $0.00127 |

## ERC20 Transfer (Direct)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| **Openfort** | Transfer ERC20 | **63,813** | **$0.0016** |
| Biconomy Nexus | ERC20 Transfer | 63,384 | $0.00104 |
| Simple Account (non-modular) | ERC20 Transfer | 63,503 | $0.00105 |
| Alchemy Light Account v2 (non-modular) | ERC20 Transfer | 63,505 | $0.00105 |
| Coinbase Smart Wallet (non-modular) | ERC20 Transfer | 63,803 | $0.00105 |
| ZeroDev Kernel v3.1 | ERC20 Transfer | 72,317 | $0.00118 |
| Alchemy Modular Account v2 | ERC20 Transfer | 72,946 | $0.00119 |
| Safe v1.4.1 (non-modular) | ERC20 Transfer | 99,715 | $0.00165 |

## Uniswap V3 Swap (Direct)

| Account Provider | Operation | Gas Used | USD Cost |
|------------------|-----------|----------|----------|
| **Openfort** | Swap ETH for USDC | **69,050** | **$0.0017** |
| Biconomy Nexus | Uniswap V3 Swap | 136,403 | $0.00220 |
| Alchemy Light Account v2 (non-modular) | Uniswap V3 Swap | 136,524 | $0.00220 |
| Simple Account (non-modular) | Uniswap V3 Swap | 136,943 | $0.00221 |
| Coinbase Smart Wallet (non-modular) | Uniswap V3 Swap | 137,243 | $0.00221 |
| ZeroDev Kernel v3.1 | Uniswap V3 Swap | 145,355 | $0.00234 |
| Alchemy Modular Account v2 | Uniswap V3 Swap | 145,956 | $0.00235 |
| Safe v1.4.1 (non-modular) | Uniswap V3 Swap | 155,690 | $0.00254 |
