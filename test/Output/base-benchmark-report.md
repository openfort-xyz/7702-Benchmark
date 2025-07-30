# BASE Network Benchmark Report

[Ethereum Mainnet](/test/Output/mainnet-benchmark-report.md) | **Base Mainnet** | [Arbitrum Mainnet](/test/Output/arbitrum-benchmark-report.md) | [Optimism Mainnet](/test/Output/optimism-benchmark-report.md)

Generated: 7/30/2025, 10:24:01 AM
Network: **BASE**

## BASE Network Insights

- **Total Operations**: 33 (11 Direct, 22 Sponsored)
- **Total Cost**: 0.4054
- **Average Cost**: 0.0123 per operation
- **Total Gas**: 16,115,568 gas
- **Average Gas**: 488,351 gas per operation

### Performance Highlights
- **Most Expensive**: Deploy OPF (Direct) - 0.1384
- **Cheapest**: Approve ERC20 (Direct) - 0.0014
- **Most Gas Intensive**: Deploy OPF (Direct) - 5,422,292 gas
- **Most Efficient**: Approve ERC20 (Direct) - 58,508 gas

## Complete Operations Overview

| Operation | Category | Type | Signature Method | Gas Used | Wei Cost | USD Cost |
|-----------|----------|------|------------------|----------|----------|----------|
| Batch Execution | Batch | Direct | Direct | 74,366 | 512.46 Gwei | 0.0018 |
| Batch Execution (UOP) | Batch | Sponsored | Standard UOP | 149,481 | 1.02K Gwei | 0.0037 |
| Batch Execution w/ MK (UOP) | Batch | Sponsored | Master Key | 597,020 | 4.06K Gwei | 0.0149 |
| Batch Execution w/ P256 (UOP) | Batch | Sponsored | P256 Signature | 378,104 | 2.57K Gwei | 0.0094 |
| Deploy OPF | Deploy | Direct | Direct | 5,422,292 | 37.52K Gwei | 0.1384 |
| Approve ERC20 | ERC20 | Direct | Direct | 58,508 | 401.76 Gwei | 0.0014 |
| Approve ERC20 (UOP) | ERC20 | Sponsored | Standard UOP | 133,428 | 910.29 Gwei | 0.0033 |
| Approve ERC20 w/ MK (UOP) | ERC20 | Sponsored | Master Key | 568,485 | 3.86K Gwei | 0.0142 |
| Approve ERC20 w/ P256 (UOP) | ERC20 | Sponsored | P256 Signature | 359,991 | 2.45K Gwei | 0.0090 |
| Transfer ERC20 | ERC20 | Direct | Direct | 63,813 | 437.77 Gwei | 0.0016 |
| Transfer ERC20 (UOP) | ERC20 | Sponsored | Standard UOP | 138,721 | 946.22 Gwei | 0.0034 |
| Transfer ERC20 w/ MK (UOP) | ERC20 | Sponsored | Master Key | 572,238 | 3.89K Gwei | 0.0143 |
| Transfer ERC20 w/ P256 (UOP) | ERC20 | Sponsored | P256 Signature | 361,742 | 2.46K Gwei | 0.0090 |
| Initialize + Session Key | Initialize | Direct | Direct | 687,573 | 4.69K Gwei | 0.0172 |
| Initialize + Session Key (UOP) | Initialize | Sponsored | Standard UOP | 508,379 | 3.47K Gwei | 0.0128 |
| Initialize TX | Initialize | Direct | Direct | 387,356 | 2.65K Gwei | 0.0097 |
| Initialize TX (UOP) | Initialize | Sponsored | Standard UOP | 460,967 | 3.15K Gwei | 0.0116 |
| Send ETH | NativeTransfer | Direct | Direct | 64,918 | 443.97 Gwei | 0.0016 |
| Send ETH (UOP) | NativeTransfer | Sponsored | Standard UOP | 139,786 | 952.15 Gwei | 0.0035 |
| Send ETH P256 (UOP) | NativeTransfer | Sponsored | P256 Direct | 335,743 | 2.28K Gwei | 0.0084 |
| Send ETH w/ MK (UOP) | NativeTransfer | Sponsored | Master Key | 552,956 | 3.76K Gwei | 0.0138 |
| Send ETH w/ SK-EOA (UOP) | NativeTransfer | Sponsored | Session Key EOA | 132,847 | 905.05 Gwei | 0.0033 |
| Register EOA | Register-Key | Direct | Direct | 253,377 | 1.73K Gwei | 0.0063 |
| Register EOA (UOP) | Register-Key | Sponsored | Standard UOP | 326,688 | 2.22K Gwei | 0.0082 |
| Register P256 | Register-Key | Direct | Direct | 333,507 | 2.27K Gwei | 0.0083 |
| Register P256 (Non-Extrac UOP) | Register-Key | Sponsored | P256 Direct | 406,818 | 2.77K Gwei | 0.0102 |
| Register P256 (Non-Extrac w/ MK UOP) | Register-Key | Sponsored | Master Key | 844,167 | 5.74K Gwei | 0.0211 |
| Register P256 (Non-Extrac) | Register-Key | Direct | Direct | 333,507 | 2.27K Gwei | 0.0083 |
| Register P256 (UOP) | Register-Key | Sponsored | P256 Direct | 406,818 | 2.77K Gwei | 0.0102 |
| Swap ETH for USDC | Uniswap | Direct | Direct | 69,050 | 479.44 Gwei | 0.0017 |
| Swap ETH for USDC (UOP) | Uniswap | Sponsored | Standard UOP | 121,405 | 834.81 Gwei | 0.0030 |
| Swap ETH for USDC w/ MK (UOP) | Uniswap | Sponsored | Master Key | 540,329 | 3.68K Gwei | 0.0135 |
| Swap ETH for USDC w/ P256 (UOP) | Uniswap | Sponsored | P256 Signature | 331,188 | 2.26K Gwei | 0.0083 |

## Category Analysis

### Batch

- **Operations**: 4
- **Total Cost**: 0.0298
- **Average Cost**: 0.0075
- **Total Gas**: 1,198,971
- **Average Gas**: 299,743

| Operation | Type | Signature Method | Gas Used | USD Cost |
|-----------|------|------------------|----------|----------|
| Batch Execution | Direct | Direct | 74,366 | 0.0018 |
| Batch Execution (UOP) | Sponsored | Standard UOP | 149,481 | 0.0037 |
| Batch Execution w/ MK (UOP) | Sponsored | Master Key | 597,020 | 0.0149 |
| Batch Execution w/ P256 (UOP) | Sponsored | P256 Signature | 378,104 | 0.0094 |

### Deploy

- **Operations**: 1
- **Total Cost**: 0.1384
- **Average Cost**: 0.1384
- **Total Gas**: 5,422,292
- **Average Gas**: 5,422,292

| Operation | Type | Signature Method | Gas Used | USD Cost |
|-----------|------|------------------|----------|----------|
| Deploy OPF | Direct | Direct | 5,422,292 | 0.1384 |

### ERC20

- **Operations**: 8
- **Total Cost**: 0.0562
- **Average Cost**: 0.0070
- **Total Gas**: 2,256,926
- **Average Gas**: 282,116

| Operation | Type | Signature Method | Gas Used | USD Cost |
|-----------|------|------------------|----------|----------|
| Approve ERC20 | Direct | Direct | 58,508 | 0.0014 |
| Approve ERC20 (UOP) | Sponsored | Standard UOP | 133,428 | 0.0033 |
| Approve ERC20 w/ MK (UOP) | Sponsored | Master Key | 568,485 | 0.0142 |
| Approve ERC20 w/ P256 (UOP) | Sponsored | P256 Signature | 359,991 | 0.0090 |
| Transfer ERC20 | Direct | Direct | 63,813 | 0.0016 |
| Transfer ERC20 (UOP) | Sponsored | Standard UOP | 138,721 | 0.0034 |
| Transfer ERC20 w/ MK (UOP) | Sponsored | Master Key | 572,238 | 0.0143 |
| Transfer ERC20 w/ P256 (UOP) | Sponsored | P256 Signature | 361,742 | 0.0090 |

### Initialize

- **Operations**: 4
- **Total Cost**: 0.0513
- **Average Cost**: 0.0128
- **Total Gas**: 2,044,275
- **Average Gas**: 511,069

| Operation | Type | Signature Method | Gas Used | USD Cost |
|-----------|------|------------------|----------|----------|
| Initialize + Session Key | Direct | Direct | 687,573 | 0.0172 |
| Initialize + Session Key (UOP) | Sponsored | Standard UOP | 508,379 | 0.0128 |
| Initialize TX | Direct | Direct | 387,356 | 0.0097 |
| Initialize TX (UOP) | Sponsored | Standard UOP | 460,967 | 0.0116 |

### NativeTransfer

- **Operations**: 5
- **Total Cost**: 0.0306
- **Average Cost**: 0.0061
- **Total Gas**: 1,226,250
- **Average Gas**: 245,250

| Operation | Type | Signature Method | Gas Used | USD Cost |
|-----------|------|------------------|----------|----------|
| Send ETH | Direct | Direct | 64,918 | 0.0016 |
| Send ETH (UOP) | Sponsored | Standard UOP | 139,786 | 0.0035 |
| Send ETH P256 (UOP) | Sponsored | P256 Direct | 335,743 | 0.0084 |
| Send ETH w/ MK (UOP) | Sponsored | Master Key | 552,956 | 0.0138 |
| Send ETH w/ SK-EOA (UOP) | Sponsored | Session Key EOA | 132,847 | 0.0033 |

### Register-Key

- **Operations**: 7
- **Total Cost**: 0.0726
- **Average Cost**: 0.0104
- **Total Gas**: 2,904,882
- **Average Gas**: 414,983

| Operation | Type | Signature Method | Gas Used | USD Cost |
|-----------|------|------------------|----------|----------|
| Register EOA | Direct | Direct | 253,377 | 0.0063 |
| Register EOA (UOP) | Sponsored | Standard UOP | 326,688 | 0.0082 |
| Register P256 | Direct | Direct | 333,507 | 0.0083 |
| Register P256 (Non-Extrac UOP) | Sponsored | P256 Direct | 406,818 | 0.0102 |
| Register P256 (Non-Extrac w/ MK UOP) | Sponsored | Master Key | 844,167 | 0.0211 |
| Register P256 (Non-Extrac) | Direct | Direct | 333,507 | 0.0083 |
| Register P256 (UOP) | Sponsored | P256 Direct | 406,818 | 0.0102 |

### Uniswap

- **Operations**: 4
- **Total Cost**: 0.0265
- **Average Cost**: 0.0066
- **Total Gas**: 1,061,972
- **Average Gas**: 265,493

| Operation | Type | Signature Method | Gas Used | USD Cost |
|-----------|------|------------------|----------|----------|
| Swap ETH for USDC | Direct | Direct | 69,050 | 0.0017 |
| Swap ETH for USDC (UOP) | Sponsored | Standard UOP | 121,405 | 0.0030 |
| Swap ETH for USDC w/ MK (UOP) | Sponsored | Master Key | 540,329 | 0.0135 |
| Swap ETH for USDC w/ P256 (UOP) | Sponsored | P256 Signature | 331,188 | 0.0083 |

## Signature Method Analysis

| Signature Method | Operations | Avg Gas | Avg Cost | Total Cost |
|------------------|------------|---------|----------|------------|
| Direct | 11 | 704,388 | 0.0178 | 0.1963 |
| Standard UOP | 8 | 247,357 | 0.0062 | 0.0495 |
| Master Key | 6 | 612,533 | 0.0153 | 0.0918 |
| P256 Signature | 4 | 357,756 | 0.0089 | 0.0357 |
| P256 Direct | 3 | 383,126 | 0.0096 | 0.0288 |
| Session Key EOA | 1 | 132,847 | 0.0033 | 0.0033 |

### Sponsored Transaction Methods Comparison

**Standard UOP**:
- Average Gas: 247,357
- Average Cost: 0.0062
- Operations: 8

**Master Key**:
- Average Gas: 612,533
- Average Cost: 0.0153
- Operations: 6

**P256 Signature**:
- Average Gas: 357,756
- Average Cost: 0.0089
- Operations: 4

**P256 Direct**:
- Average Gas: 383,126
- Average Cost: 0.0096
- Operations: 3

**Session Key EOA**:
- Average Gas: 132,847
- Average Cost: 0.0033
- Operations: 1

## Cost Analysis

### Cost Distribution

| Cost Range | Operations | Percentage |
|------------|------------|------------|
| Ultra Low (< $0.001) | 0 | 0.0% |
| Low ($0.001 - $0.01) | 21 | 63.6% |
| Medium ($0.01 - $0.1) | 11 | 33.3% |
| High ($0.1 - $1) | 1 | 3.0% |
| Very High (> $1) | 0 | 0.0% |

### Direct vs Sponsored Cost Impact

- **Average Direct Cost**: 0.0178
- **Average Sponsored Cost**: 0.0095
- **Cost Multiplier**: 0.53x
- **Premium**: -46.7% more expensive for sponsored transactions

## Gas Efficiency Analysis

### Gas Usage Distribution

| Gas Range | Operations | Percentage |
|-----------|------------|------------|
| Very Efficient (< 50K gas) | 0 | 0.0% |
| Efficient (50K - 100K gas) | 5 | 15.2% |
| Moderate (100K - 500K gas) | 19 | 57.6% |
| High (500K - 1M gas) | 8 | 24.2% |
| Very High (> 1M gas) | 1 | 3.0% |

### Gas Efficiency by Category

| Category | Avg Gas | Most Efficient | Least Efficient |
|----------|---------|----------------|------------------|
| Batch | 299,743 | 74,366 | 597,020 |
| Deploy | 5,422,292 | 5,422,292 | 5,422,292 |
| ERC20 | 282,116 | 58,508 | 572,238 |
| Initialize | 511,069 | 387,356 | 687,573 |
| NativeTransfer | 245,250 | 64,918 | 552,956 |
| Register-Key | 414,983 | 253,377 | 844,167 |
| Uniswap | 265,493 | 69,050 | 540,329 |

## BASE Network Recommendations

### Base Network Considerations
- **Cost-Effective L2**: Average operation costs 0.0123
- **Good for Development**: Excellent cost-performance balance
- **Production Ready**: Suitable for production applications
- **Coinbase Ecosystem**: Leverage Coinbase integrations
- **Fast Finality**: Quick transaction confirmations

### High-Cost Operations to Monitor
- **Deploy OPF** (Direct): 0.1384 - Consider optimization

### Most Cost-Efficient Operations
- **Approve ERC20** (Direct): 0.0014 - Great choice for high-frequency use
- **Transfer ERC20** (Direct): 0.0016 - Great choice for high-frequency use
- **Send ETH** (Direct): 0.0016 - Great choice for high-frequency use
- **Swap ETH for USDC** (Direct): 0.0017 - Great choice for high-frequency use
- **Batch Execution** (Direct): 0.0018 - Great choice for high-frequency use

### Signature Method Recommendations
- **Standard UOP**: Avg 0.0062, 247,357 gas
- **Master Key**: Avg 0.0153, 612,533 gas
- **P256 Signature**: Avg 0.0089, 357,756 gas
- **P256 Direct**: Avg 0.0096, 383,126 gas
- **Session Key EOA**: Avg 0.0033, 132,847 gas

