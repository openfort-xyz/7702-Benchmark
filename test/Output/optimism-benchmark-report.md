# OPTIMISM Network Benchmark Report

[Ethereum Mainnet](/test/Output/mainnet-benchmark-report.md) | [Base Mainnet](/test/Output/base-benchmark-report.md) | [Arbitrum Mainnet](/test/Output/arbitrum-benchmark-report.md) | **Optimism Mainnet**
Generated: 7/30/2025, 10:24:01 AM
Network: **OPTIMISM**

## OPTIMISM Network Insights

- **Total Operations**: 33 (11 Direct, 22 Sponsored)
- **Total Cost**: 0.0663
- **Average Cost**: 0.0020 per operation
- **Total Gas**: 16,504,883 gas
- **Average Gas**: 500,148 gas per operation

### Performance Highlights
- **Most Expensive**: Deploy OPF (Direct) - 0.0253
- **Cheapest**: Approve ERC20 (Direct) - 0.0002
- **Most Gas Intensive**: Deploy OPF (Direct) - 5,432,749 gas
- **Most Efficient**: Approve ERC20 (Direct) - 58,508 gas

## Complete Operations Overview

| Operation | Category | Type | Signature Method | Gas Used | Wei Cost | USD Cost |
|-----------|----------|------|------------------|----------|----------|----------|
| Batch Execution | Batch | Direct | Direct | 74,366 | 89.96 Gwei | 0.0003 |
| Batch Execution (UOP) | Batch | Sponsored | Standard UOP | 149,481 | 165.27 Gwei | 0.0006 |
| Batch Execution w/ MK (UOP) | Batch | Sponsored | Master Key | 582,999 | 599.90 Gwei | 0.0022 |
| Batch Execution w/ P256 (UOP) | Batch | Sponsored | P256 Signature | 379,418 | 395.80 Gwei | 0.0014 |
| Deploy OPF | Deploy | Direct | Direct | 5,432,749 | 6.88K Gwei | 0.0253 |
| Approve ERC20 | ERC20 | Direct | Direct | 58,508 | 67.92 Gwei | 0.0002 |
| Approve ERC20 (UOP) | ERC20 | Sponsored | Standard UOP | 133,428 | 143.04 Gwei | 0.0005 |
| Approve ERC20 w/ MK (UOP) | ERC20 | Sponsored | Master Key | 566,927 | 577.65 Gwei | 0.0021 |
| Approve ERC20 w/ P256 (UOP) | ERC20 | Sponsored | P256 Signature | 360,429 | 370.62 Gwei | 0.0013 |
| Transfer ERC20 | ERC20 | Direct | Direct | 63,813 | 73.24 Gwei | 0.0002 |
| Transfer ERC20 (UOP) | ERC20 | Sponsored | Standard UOP | 138,733 | 148.35 Gwei | 0.0005 |
| Transfer ERC20 w/ MK (UOP) | ERC20 | Sponsored | Master Key | 566,788 | 577.51 Gwei | 0.0021 |
| Transfer ERC20 w/ P256 (UOP) | ERC20 | Sponsored | P256 Signature | 363,470 | 373.67 Gwei | 0.0013 |
| Initialize + Session Key | Initialize | Direct | Direct | 687,573 | 726.58 Gwei | 0.0026 |
| Initialize + Session Key (UOP) | Initialize | Sponsored | Standard UOP | 508,379 | 547.21 Gwei | 0.0020 |
| Initialize TX | Initialize | Direct | Direct | 387,356 | 421.93 Gwei | 0.0015 |
| Initialize TX (UOP) | Initialize | Sponsored | Standard UOP | 460,967 | 496.02 Gwei | 0.0018 |
| Send ETH | NativeTransfer | Direct | Direct | 64,918 | 71.75 Gwei | 0.0002 |
| Send ETH (UOP) | NativeTransfer | Sponsored | Standard UOP | 139,786 | 146.81 Gwei | 0.0005 |
| Send ETH P256 (UOP) | NativeTransfer | Sponsored | P256 Direct | 338,809 | 346.35 Gwei | 0.0012 |
| Send ETH w/ MK (UOP) | NativeTransfer | Sponsored | Master Key | 556,561 | 564.66 Gwei | 0.0020 |
| Send ETH w/ SK-EOA (UOP) | NativeTransfer | Sponsored | Session Key EOA | 132,835 | 139.84 Gwei | 0.0005 |
| Register EOA | Register-Key | Direct | Direct | 253,377 | 267.36 Gwei | 0.0009 |
| Register EOA (UOP) | Register-Key | Sponsored | Standard UOP | 326,688 | 340.86 Gwei | 0.0012 |
| Register P256 | Register-Key | Direct | Direct | 333,507 | 349.65 Gwei | 0.0012 |
| Register P256 (Non-Extrac UOP) | Register-Key | Sponsored | P256 Direct | 406,818 | 423.15 Gwei | 0.0015 |
| Register P256 (Non-Extrac w/ MK UOP) | Register-Key | Sponsored | Master Key | 842,591 | 860.04 Gwei | 0.0031 |
| Register P256 (Non-Extrac) | Register-Key | Direct | Direct | 333,507 | 349.65 Gwei | 0.0012 |
| Register P256 (UOP) | Register-Key | Sponsored | P256 Direct | 406,818 | 423.15 Gwei | 0.0015 |
| Swap ETH for USDC | Uniswap | Direct | Direct | 163,514 | 185.47 Gwei | 0.0006 |
| Swap ETH for USDC (UOP) | Uniswap | Sponsored | Standard UOP | 215,869 | 237.96 Gwei | 0.0008 |
| Swap ETH for USDC w/ MK (UOP) | Uniswap | Sponsored | Master Key | 647,811 | 671.02 Gwei | 0.0024 |
| Swap ETH for USDC w/ P256 (UOP) | Uniswap | Sponsored | P256 Signature | 426,090 | 447.60 Gwei | 0.0016 |

## Category Analysis

### Batch

- **Operations**: 4
- **Total Cost**: 0.0045
- **Average Cost**: 0.0011
- **Total Gas**: 1,186,264
- **Average Gas**: 296,566

| Operation | Type | Signature Method | Gas Used | USD Cost |
|-----------|------|------------------|----------|----------|
| Batch Execution | Direct | Direct | 74,366 | 0.0003 |
| Batch Execution (UOP) | Sponsored | Standard UOP | 149,481 | 0.0006 |
| Batch Execution w/ MK (UOP) | Sponsored | Master Key | 582,999 | 0.0022 |
| Batch Execution w/ P256 (UOP) | Sponsored | P256 Signature | 379,418 | 0.0014 |

### Deploy

- **Operations**: 1
- **Total Cost**: 0.0253
- **Average Cost**: 0.0253
- **Total Gas**: 5,432,749
- **Average Gas**: 5,432,749

| Operation | Type | Signature Method | Gas Used | USD Cost |
|-----------|------|------------------|----------|----------|
| Deploy OPF | Direct | Direct | 5,432,749 | 0.0253 |

### ERC20

- **Operations**: 8
- **Total Cost**: 0.0082
- **Average Cost**: 0.0010
- **Total Gas**: 2,252,096
- **Average Gas**: 281,512

| Operation | Type | Signature Method | Gas Used | USD Cost |
|-----------|------|------------------|----------|----------|
| Approve ERC20 | Direct | Direct | 58,508 | 0.0002 |
| Approve ERC20 (UOP) | Sponsored | Standard UOP | 133,428 | 0.0005 |
| Approve ERC20 w/ MK (UOP) | Sponsored | Master Key | 566,927 | 0.0021 |
| Approve ERC20 w/ P256 (UOP) | Sponsored | P256 Signature | 360,429 | 0.0013 |
| Transfer ERC20 | Direct | Direct | 63,813 | 0.0002 |
| Transfer ERC20 (UOP) | Sponsored | Standard UOP | 138,733 | 0.0005 |
| Transfer ERC20 w/ MK (UOP) | Sponsored | Master Key | 566,788 | 0.0021 |
| Transfer ERC20 w/ P256 (UOP) | Sponsored | P256 Signature | 363,470 | 0.0013 |

### Initialize

- **Operations**: 4
- **Total Cost**: 0.0079
- **Average Cost**: 0.0020
- **Total Gas**: 2,044,275
- **Average Gas**: 511,069

| Operation | Type | Signature Method | Gas Used | USD Cost |
|-----------|------|------------------|----------|----------|
| Initialize + Session Key | Direct | Direct | 687,573 | 0.0026 |
| Initialize + Session Key (UOP) | Sponsored | Standard UOP | 508,379 | 0.0020 |
| Initialize TX | Direct | Direct | 387,356 | 0.0015 |
| Initialize TX (UOP) | Sponsored | Standard UOP | 460,967 | 0.0018 |

### NativeTransfer

- **Operations**: 5
- **Total Cost**: 0.0044
- **Average Cost**: 0.0009
- **Total Gas**: 1,232,909
- **Average Gas**: 246,582

| Operation | Type | Signature Method | Gas Used | USD Cost |
|-----------|------|------------------|----------|----------|
| Send ETH | Direct | Direct | 64,918 | 0.0002 |
| Send ETH (UOP) | Sponsored | Standard UOP | 139,786 | 0.0005 |
| Send ETH P256 (UOP) | Sponsored | P256 Direct | 338,809 | 0.0012 |
| Send ETH w/ MK (UOP) | Sponsored | Master Key | 556,561 | 0.0020 |
| Send ETH w/ SK-EOA (UOP) | Sponsored | Session Key EOA | 132,835 | 0.0005 |

### Register-Key

- **Operations**: 7
- **Total Cost**: 0.0106
- **Average Cost**: 0.0015
- **Total Gas**: 2,903,306
- **Average Gas**: 414,758

| Operation | Type | Signature Method | Gas Used | USD Cost |
|-----------|------|------------------|----------|----------|
| Register EOA | Direct | Direct | 253,377 | 0.0009 |
| Register EOA (UOP) | Sponsored | Standard UOP | 326,688 | 0.0012 |
| Register P256 | Direct | Direct | 333,507 | 0.0012 |
| Register P256 (Non-Extrac UOP) | Sponsored | P256 Direct | 406,818 | 0.0015 |
| Register P256 (Non-Extrac w/ MK UOP) | Sponsored | Master Key | 842,591 | 0.0031 |
| Register P256 (Non-Extrac) | Direct | Direct | 333,507 | 0.0012 |
| Register P256 (UOP) | Sponsored | P256 Direct | 406,818 | 0.0015 |

### Uniswap

- **Operations**: 4
- **Total Cost**: 0.0054
- **Average Cost**: 0.0013
- **Total Gas**: 1,453,284
- **Average Gas**: 363,321

| Operation | Type | Signature Method | Gas Used | USD Cost |
|-----------|------|------------------|----------|----------|
| Swap ETH for USDC | Direct | Direct | 163,514 | 0.0006 |
| Swap ETH for USDC (UOP) | Sponsored | Standard UOP | 215,869 | 0.0008 |
| Swap ETH for USDC w/ MK (UOP) | Sponsored | Master Key | 647,811 | 0.0024 |
| Swap ETH for USDC w/ P256 (UOP) | Sponsored | P256 Signature | 426,090 | 0.0016 |

## Signature Method Analysis

| Signature Method | Operations | Avg Gas | Avg Cost | Total Cost |
|------------------|------------|---------|----------|------------|
| Direct | 11 | 713,926 | 0.0031 | 0.0342 |
| Standard UOP | 8 | 259,166 | 0.0010 | 0.0079 |
| Master Key | 6 | 627,280 | 0.0023 | 0.0139 |
| P256 Signature | 4 | 382,352 | 0.0014 | 0.0056 |
| P256 Direct | 3 | 384,148 | 0.0014 | 0.0042 |
| Session Key EOA | 1 | 132,835 | 0.0005 | 0.0005 |

### Sponsored Transaction Methods Comparison

**Standard UOP**:
- Average Gas: 259,166
- Average Cost: 0.0010
- Operations: 8

**Master Key**:
- Average Gas: 627,280
- Average Cost: 0.0023
- Operations: 6

**P256 Signature**:
- Average Gas: 382,352
- Average Cost: 0.0014
- Operations: 4

**P256 Direct**:
- Average Gas: 384,148
- Average Cost: 0.0014
- Operations: 3

**Session Key EOA**:
- Average Gas: 132,835
- Average Cost: 0.0005
- Operations: 1

## Cost Analysis

### Cost Distribution

| Cost Range | Operations | Percentage |
|------------|------------|------------|
| Ultra Low (< $0.001) | 12 | 36.4% |
| Low ($0.001 - $0.01) | 20 | 60.6% |
| Medium ($0.01 - $0.1) | 1 | 3.0% |
| High ($0.1 - $1) | 0 | 0.0% |
| Very High (> $1) | 0 | 0.0% |

### Direct vs Sponsored Cost Impact

- **Average Direct Cost**: 0.0031
- **Average Sponsored Cost**: 0.0015
- **Cost Multiplier**: 0.47x
- **Premium**: -53.1% more expensive for sponsored transactions

## Gas Efficiency Analysis

### Gas Usage Distribution

| Gas Range | Operations | Percentage |
|-----------|------------|------------|
| Very Efficient (< 50K gas) | 0 | 0.0% |
| Efficient (50K - 100K gas) | 4 | 12.1% |
| Moderate (100K - 500K gas) | 20 | 60.6% |
| High (500K - 1M gas) | 8 | 24.2% |
| Very High (> 1M gas) | 1 | 3.0% |

### Gas Efficiency by Category

| Category | Avg Gas | Most Efficient | Least Efficient |
|----------|---------|----------------|------------------|
| Batch | 296,566 | 74,366 | 582,999 |
| Deploy | 5,432,749 | 5,432,749 | 5,432,749 |
| ERC20 | 281,512 | 58,508 | 566,927 |
| Initialize | 511,069 | 387,356 | 687,573 |
| NativeTransfer | 246,582 | 64,918 | 556,561 |
| Register-Key | 414,758 | 253,377 | 842,591 |
| Uniswap | 363,321 | 163,514 | 647,811 |

## OPTIMISM Network Recommendations

### Optimism Network Considerations
- **Lowest Cost**: Average operation costs 0.0020
- **Ideal for High-Volume**: Perfect for applications with many transactions
- **Development Environment**: Excellent for testing and development
- **Optimistic Rollup**: Understand the dispute resolution process
- **Cost Optimization**: Best choice for cost-sensitive applications

### High-Cost Operations to Monitor
- **Deploy OPF** (Direct): 0.0253 - Consider optimization

### Most Cost-Efficient Operations
- **Approve ERC20** (Direct): 0.0002 - Great choice for high-frequency use
- **Transfer ERC20** (Direct): 0.0002 - Great choice for high-frequency use
- **Send ETH** (Direct): 0.0002 - Great choice for high-frequency use
- **Batch Execution** (Direct): 0.0003 - Great choice for high-frequency use
- **Approve ERC20 (UOP)** (Sponsored): 0.0005 - Great choice for high-frequency use

### Signature Method Recommendations
- **Standard UOP**: Avg 0.0010, 259,166 gas
- **Master Key**: Avg 0.0023, 627,280 gas
- **P256 Signature**: Avg 0.0014, 382,352 gas
- **P256 Direct**: Avg 0.0014, 384,148 gas
- **Session Key EOA**: Avg 0.0005, 132,835 gas

