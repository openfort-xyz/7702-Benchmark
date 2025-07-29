# Blockchain Network Benchmark Results

Generated: 7/28/2025, 4:35:19 PM

## Deploy Benchmarks

| Test Name  | Network  | Gas Used  | Wei Cost     | USD Cost |
| ---------- | -------- | --------- | ------------ | -------- |
| Deploy OPF | MAINNET  | 5,001,063 | 4.47M Gwei   | 16.4848  |
| Deploy OPF | BASE     | 5,002,249 | 34.67K Gwei  | 0.1279   |
| Deploy OPF | ARBITRUM | 5,007,503 | 418.74K Gwei | 1.5451   |
| Deploy OPF | OPTIMISM | 5,012,809 | 6.47K Gwei   | 0.0238   |

## Initialize Benchmarks

| Test Name                | Network  | Gas Used | Wei Cost     | USD Cost |
| ------------------------ | -------- | -------- | ------------ | -------- |
| Initialize TX            | MAINNET  | 356,932  | 318.85K Gwei | 1.1765   |
| Initialize TX            | BASE     | 356,932  | 2.44K Gwei   | 0.0089   |
| Initialize TX            | ARBITRUM | 356,932  | 29.85K Gwei  | 0.1101   |
| Initialize TX            | OPTIMISM | 356,932  | 390.19 Gwei  | 0.0014   |
| Initialize + Session Key | MAINNET  | 658,262  | 588.02K Gwei | 2.1698   |
| Initialize + Session Key | BASE     | 658,262  | 4.49K Gwei   | 0.0165   |
| Initialize + Session Key | ARBITRUM | 658,262  | 55.05K Gwei  | 0.2031   |
| Initialize + Session Key | OPTIMISM | 658,262  | 695.95 Gwei  | 0.0025   |

## Register-Key Benchmarks

| Test Name                  | Network  | Gas Used | Wei Cost     | USD Cost |
| -------------------------- | -------- | -------- | ------------ | -------- |
| Register EOA               | MAINNET  | 222,841  | 199.06K Gwei | 0.7345   |
| Register EOA               | BASE     | 222,841  | 1.52K Gwei   | 0.0056   |
| Register EOA               | ARBITRUM | 222,841  | 18.63K Gwei  | 0.0687   |
| Register EOA               | OPTIMISM | 222,841  | 235.33 Gwei  | 0.0008   |
| Register P256              | MAINNET  | 302,442  | 270.17K Gwei | 0.9969   |
| Register P256              | BASE     | 302,442  | 2.06K Gwei   | 0.0076   |
| Register P256              | ARBITRUM | 302,442  | 25.29K Gwei  | 0.0933   |
| Register P256              | OPTIMISM | 302,442  | 317.85 Gwei  | 0.0011   |
| Register P256 (Non-Extrac) | MAINNET  | 302,442  | 270.17K Gwei | 0.9969   |
| Register P256 (Non-Extrac) | BASE     | 302,442  | 2.06K Gwei   | 0.0076   |
| Register P256 (Non-Extrac) | ARBITRUM | 302,442  | 25.29K Gwei  | 0.0933   |
| Register P256 (Non-Extrac) | OPTIMISM | 302,442  | 317.85 Gwei  | 0.0011   |

## Gas Usage Summary

| Test                       | MAINNET   | BASE      | ARBITRUM  | OPTIMISM  |
| -------------------------- | --------- | --------- | --------- | --------- |
| Deploy OPF                 | 5,001,063 | 5,002,249 | 5,007,503 | 5,012,809 |
| Initialize TX              | 356,932   | 356,932   | 356,932   | 356,932   |
| Initialize + Session Key   | 658,262   | 658,262   | 658,262   | 658,262   |
| Register EOA               | 222,841   | 222,841   | 222,841   | 222,841   |
| Register P256              | 302,442   | 302,442   | 302,442   | 302,442   |
| Register P256 (Non-Extrac) | 302,442   | 302,442   | 302,442   | 302,442   |

## Cost Comparison (USD)

| Test                       | MAINNET | BASE   | ARBITRUM | OPTIMISM |  Best        |
| -------------------------- | ------- | ------ | -------- | -------- | ------------ |
| Deploy OPF                 | 16.4848 | 0.1279 | 1.5451   | 0.0238   | **OPTIMISM** |
| Initialize TX              | 1.1765  | 0.0089 | 0.1101   | 0.0014   | **OPTIMISM** |
| Initialize + Session Key   | 2.1698  | 0.0165 | 0.2031   | 0.0025   | **OPTIMISM** |
| Register EOA               | 0.7345  | 0.0056 | 0.0687   | 0.0008   | **OPTIMISM** |
| Register P256              | 0.9969  | 0.0076 | 0.0933   | 0.0011   | **OPTIMISM** |
| Register P256 (Non-Extrac) | 0.9969  | 0.0076 | 0.0933   | 0.0011   | **OPTIMISM** |

## Key Insights

- **Cheapest Network**: OPTIMISM consistently offers the lowest costs
- **Most Expensive**: MAINNET has the highest transaction costs
- **Gas Consistency**: Gas usage remains the same across networks
- **Cost Savings**: Using OPTIMISM vs MAINNET saves ~99.9% (Total: $22.5287)
- **Price Variation**: Up to 735x difference between most/least expensive networks
- **Total Costs**: MAINNET: $22.5594 | BASE: $0.1741 | ARBITRUM: $2.1136 | OPTIMISM: $0.0307
- **Most Expensive Operation**: "Deploy OPF" ($16.4848 on MAINNET)
- **Most Efficient Operation**: "Register EOA" (222,841 gas)

