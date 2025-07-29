# Enhanced Blockchain Network Benchmark Results

Generated: 7/29/2025, 3:08:47 PM

## Direct vs Sponsored Transaction Comparison

| Test                                 | Type      | MAINNET  | BASE    | ARBITRUM | OPTIMISM | Gas Used  |
| ------------------------------------ | --------- | -------- | ------- | -------- | -------- | --------- |
| Deploy OPF                           | Direct    | $16.3935 | $0.1272 | $1.5365  | $0.0237  | 4,973,383 |
| Initialize TX                        | Direct    | $1.1775  | $0.0090 | $0.1102  | $0.0014  | 357,246   |
| Initialize TX                        | Sponsored | $1.3442  | $0.0102 | $0.1258  | $0.0016  | 407,799   |
| Initialize + Session Key             | Direct    | $2.1639  | $0.0165 | $0.2025  | $0.0025  | 656,473   |
| Initialize + Session Key             | Sponsored | $1.4972  | $0.0114 | $0.1401  | $0.0018  | 454,215   |
| Register EOA                         | Direct    | $0.7382  | $0.0056 | $0.0691  | $0.0008  | 223,953   |
| Register EOA                         | Sponsored | $0.9038  | $0.0068 | $0.0846  | $0.0010  | 274,212   |
| Register P256                        | Direct    | $1.0005  | $0.0076 | $0.0936  | $0.0011  | 303,555   |
| Register P256                        | Sponsored | $1.1662  | $0.0088 | $0.1091  | $0.0013  | 353,814   |
| Register P256 (Non-Extrac)           | Direct    | $1.0005  | $0.0076 | $0.0936  | $0.0011  | 303,555   |
| Register P256 (Non-Extrac UOP)       | Sponsored | $1.1662  | $0.0088 | $0.1091  | $0.0013  | 353,814   |
| Register P256 (Non-Extrac w/ MK UOP) | Sponsored | $2.5671  | $0.0195 | $0.2395  | $0.0029  | 778,813   |
| Approve ERC20                        | Direct    | $0.0198  | $0.0007 | $0.0094  | $0.0001  | 6,018     |
| Approve ERC20                        | Sponsored | $0.1907  | $0.0020 | $0.0254  | $0.0003  | 57,874    |
| Transfer ERC20                       | Direct    | $0.0198  | $0.0007 | $0.0095  | $0.0001  | 6,018     |
| Transfer ERC20                       | Sponsored | $0.1907  | $0.0020 | $0.0255  | $0.0003  | 57,874    |
| Approve ERC20 w/ MK                  | Sponsored | $1.5936  | $0.0126 | $0.1532  | $0.0019  | 483,481   |
| Approve ERC20 w/ P256                | Sponsored | $0.8424  | $0.0070 | $0.0861  | $0.0010  | 255,565   |
| Transfer ERC20 w/ MK                 | Sponsored | $1.5945  | $0.0126 | $0.1567  | $0.0018  | 483,754   |
| Transfer ERC20 w/ P256               | Sponsored | $0.8365  | $0.0069 | $0.0857  | $0.0010  | 253,775   |
| Send ETH                             | Direct    | $0.1324  | $0.0010 | $0.0123  | $0.0001  | 40,178    |
| Send ETH                             | Sponsored | $0.3031  | $0.0023 | $0.0283  | $0.0003  | 91,970    |
| Send ETH P256                        | Sponsored | $0.8706  | $0.0065 | $0.0813  | $0.0010  | 264,145   |
| Send ETH w/ MK                       | Sponsored | $1.5783  | $0.0123 | $0.1522  | $0.0018  | 478,841   |
| Send ETH w/ SK-EOA                   | Sponsored | $0.2380  | $0.0018 | $0.0222  | $0.0002  | 72,231    |
| Batch Execution                      | Direct    | $0.0245  | $0.0009 | $0.0108  | $0.0001  | 7,434     |
| Batch Execution                      | Sponsored | $0.1960  | $0.0022 | $0.0269  | $0.0003  | 59,485    |
| Batch Execution w/ MK                | Sponsored | $1.5848  | $0.0130 | $0.1578  | $0.0019  | 480,812   |
| Batch Execution w/ P256              | Sponsored | $0.8631  | $0.0072 | $0.0889  | $0.0011  | 261,864   |

## Signature Method Comparison

### Register - Signature Methods

| Method      | MAINNET | BASE    | ARBITRUM | OPTIMISM | Gas Used |
| ----------- | ------- | ------- | -------- | -------- | -------- |
| Direct      | $1.0005 | $0.0076 | $0.0936  | $0.0011  | 303,555  |
| P256 Direct | $1.1662 | $0.0088 | $0.1091  | $0.0013  | 353,814  |

### Register (Non-Extrac UOP) - Signature Methods

| Method      | MAINNET | BASE    | ARBITRUM | OPTIMISM | Gas Used |
| ----------- | ------- | ------- | -------- | -------- | -------- |
| P256 Direct | $1.1662 | $0.0088 | $0.1091  | $0.0013  | 353,814  |
| Master Key  | $2.5671 | $0.0195 | $0.2395  | $0.0029  | 778,813  |

### Approve ERC20 - Signature Methods

| Method         | MAINNET | BASE    | ARBITRUM | OPTIMISM | Gas Used |
| -------------- | ------- | ------- | -------- | -------- | -------- |
| Standard UOP   | $0.1907 | $0.0020 | $0.0254  | $0.0003  | 57,874   |
| Master Key     | $1.5936 | $0.0126 | $0.1532  | $0.0019  | 483,481  |
| P256 Signature | $0.8424 | $0.0070 | $0.0861  | $0.0010  | 255,565  |

### Transfer ERC20 - Signature Methods

| Method         | MAINNET | BASE    | ARBITRUM | OPTIMISM | Gas Used |
| -------------- | ------- | ------- | -------- | -------- | -------- |
| Standard UOP   | $0.1907 | $0.0020 | $0.0255  | $0.0003  | 57,874   |
| Master Key     | $1.5945 | $0.0126 | $0.1567  | $0.0018  | 483,754  |
| P256 Signature | $0.8365 | $0.0069 | $0.0857  | $0.0010  | 253,775  |

### Send ETH - Signature Methods

| Method          | MAINNET | BASE    | ARBITRUM | OPTIMISM | Gas Used |
| --------------- | ------- | ------- | -------- | -------- | -------- |
| Standard UOP    | $0.3031 | $0.0023 | $0.0283  | $0.0003  | 91,970   |
| P256 Direct     | $0.8706 | $0.0065 | $0.0813  | $0.0010  | 264,145  |
| Master Key      | $1.5783 | $0.0123 | $0.1522  | $0.0018  | 478,841  |
| Session Key EOA | $0.2380 | $0.0018 | $0.0222  | $0.0002  | 72,231   |

### Batch Execution - Signature Methods

| Method         | MAINNET | BASE    | ARBITRUM | OPTIMISM | Gas Used |
| -------------- | ------- | ------- | -------- | -------- | -------- |
| Standard UOP   | $0.1960 | $0.0022 | $0.0269  | $0.0003  | 59,485   |
| Master Key     | $1.5848 | $0.0130 | $0.1578  | $0.0019  | 480,812  |
| P256 Signature | $0.8631 | $0.0072 | $0.0889  | $0.0011  | 261,864  |

## Deploy Benchmarks

| Test Name  | Type   | Network  | Gas Used  | Wei Cost     | USD Cost |
| ---------- | ------ | -------- | --------- | ------------ | -------- |
| Deploy OPF | Direct | MAINNET  | 4,973,383 | 4.44M Gwei   | $16.3935 |
| Deploy OPF | Direct | BASE     | 4,974,518 | 34.48K Gwei  | $0.1272  |
| Deploy OPF | Direct | ARBITRUM | 4,979,720 | 416.42K Gwei | $1.5365  |
| Deploy OPF | Direct | OPTIMISM | 4,984,975 | 6.43K Gwei   | $0.0237  |

## Initialize Benchmarks

| Test Name                      | Type      | Network  | Gas Used | Wei Cost     | USD Cost |
| ------------------------------ | --------- | -------- | -------- | ------------ | -------- |
| Initialize TX                  | Direct    | MAINNET  | 357,246  | 319.13K Gwei | $1.1775  |
| Initialize TX                  | Direct    | BASE     | 357,246  | 2.44K Gwei   | $0.0090  |
| Initialize TX                  | Direct    | ARBITRUM | 357,246  | 29.87K Gwei  | $0.1102  |
| Initialize TX                  | Direct    | OPTIMISM | 357,246  | 391.74 Gwei  | $0.0014  |
| Initialize + Session Key       | Direct    | MAINNET  | 656,473  | 586.43K Gwei | $2.1639  |
| Initialize + Session Key       | Direct    | BASE     | 656,473  | 4.47K Gwei   | $0.0165  |
| Initialize + Session Key       | Direct    | ARBITRUM | 656,473  | 54.90K Gwei  | $0.2025  |
| Initialize + Session Key       | Direct    | OPTIMISM | 656,473  | 695.40 Gwei  | $0.0025  |
| Initialize TX (UOP)            | Sponsored | MAINNET  | 407,799  | 364.29K Gwei | $1.3442  |
| Initialize TX (UOP)            | Sponsored | BASE     | 407,799  | 2.78K Gwei   | $0.0102  |
| Initialize TX (UOP)            | Sponsored | ARBITRUM | 407,799  | 34.10K Gwei  | $0.1258  |
| Initialize TX (UOP)            | Sponsored | OPTIMISM | 407,799  | 442.72 Gwei  | $0.0016  |
| Initialize + Session Key (UOP) | Sponsored | MAINNET  | 454,215  | 405.75K Gwei | $1.4972  |
| Initialize + Session Key (UOP) | Sponsored | BASE     | 454,215  | 3.10K Gwei   | $0.0114  |
| Initialize + Session Key (UOP) | Sponsored | ARBITRUM | 454,215  | 37.98K Gwei  | $0.1401  |
| Initialize + Session Key (UOP) | Sponsored | OPTIMISM | 454,215  | 492.91 Gwei  | $0.0018  |

## Register-Key Benchmarks

| Test Name                            | Type      | Network  | Gas Used | Wei Cost     | USD Cost |
| ------------------------------------ | --------- | -------- | -------- | ------------ | -------- |
| Register EOA                         | Direct    | MAINNET  | 223,953  | 200.06K Gwei | $0.7382  |
| Register EOA                         | Direct    | BASE     | 223,953  | 1.53K Gwei   | $0.0056  |
| Register EOA                         | Direct    | ARBITRUM | 223,953  | 18.73K Gwei  | $0.0691  |
| Register EOA                         | Direct    | OPTIMISM | 223,953  | 237.86 Gwei  | $0.0008  |
| Register P256                        | Direct    | MAINNET  | 303,555  | 271.16K Gwei | $1.0005  |
| Register P256                        | Direct    | BASE     | 303,555  | 2.07K Gwei   | $0.0076  |
| Register P256                        | Direct    | ARBITRUM | 303,555  | 25.38K Gwei  | $0.0936  |
| Register P256                        | Direct    | OPTIMISM | 303,555  | 319.62 Gwei  | $0.0011  |
| Register P256 (Non-Extrac)           | Direct    | MAINNET  | 303,555  | 271.16K Gwei | $1.0005  |
| Register P256 (Non-Extrac)           | Direct    | BASE     | 303,555  | 2.07K Gwei   | $0.0076  |
| Register P256 (Non-Extrac)           | Direct    | ARBITRUM | 303,555  | 25.38K Gwei  | $0.0936  |
| Register P256 (Non-Extrac)           | Direct    | OPTIMISM | 303,555  | 319.62 Gwei  | $0.0011  |
| Register EOA (UOP)                   | Sponsored | MAINNET  | 274,212  | 244.95K Gwei | $0.9038  |
| Register EOA (UOP)                   | Sponsored | BASE     | 274,212  | 1.87K Gwei   | $0.0068  |
| Register EOA (UOP)                   | Sponsored | ARBITRUM | 274,212  | 22.93K Gwei  | $0.0846  |
| Register EOA (UOP)                   | Sponsored | OPTIMISM | 274,212  | 288.25 Gwei  | $0.0010  |
| Register P256 (UOP)                  | Sponsored | MAINNET  | 353,814  | 316.06K Gwei | $1.1662  |
| Register P256 (UOP)                  | Sponsored | BASE     | 353,814  | 2.41K Gwei   | $0.0088  |
| Register P256 (UOP)                  | Sponsored | ARBITRUM | 353,814  | 29.59K Gwei  | $0.1091  |
| Register P256 (UOP)                  | Sponsored | OPTIMISM | 353,814  | 370.01 Gwei  | $0.0013  |
| Register P256 (Non-Extrac UOP)       | Sponsored | MAINNET  | 353,814  | 316.06K Gwei | $1.1662  |
| Register P256 (Non-Extrac UOP)       | Sponsored | BASE     | 353,814  | 2.41K Gwei   | $0.0088  |
| Register P256 (Non-Extrac UOP)       | Sponsored | ARBITRUM | 353,814  | 29.59K Gwei  | $0.1091  |
| Register P256 (Non-Extrac UOP)       | Sponsored | OPTIMISM | 353,814  | 370.01 Gwei  | $0.0013  |
| Register P256 (Non-Extrac w/ MK UOP) | Sponsored | MAINNET  | 778,813  | 695.71K Gwei | $2.5671  |
| Register P256 (Non-Extrac w/ MK UOP) | Sponsored | BASE     | 779,643  | 5.30K Gwei   | $0.0195  |
| Register P256 (Non-Extrac w/ MK UOP) | Sponsored | ARBITRUM | 776,329  | 64.92K Gwei  | $0.2395  |
| Register P256 (Non-Extrac w/ MK UOP) | Sponsored | OPTIMISM | 778,067  | 795.35 Gwei  | $0.0029  |

## ERC20 Benchmarks

| Test Name                    | Type      | Network  | Gas Used | Wei Cost     | USD Cost |
| ---------------------------- | --------- | -------- | -------- | ------------ | -------- |
| Approve ERC20                | Direct    | MAINNET  | 6,018    | 5.38K Gwei   | $0.0198  |
| Approve ERC20                | Direct    | BASE     | 30,572   | 212.14 Gwei  | $0.0007  |
| Approve ERC20                | Direct    | ARBITRUM | 30,572   | 2.56K Gwei   | $0.0094  |
| Approve ERC20                | Direct    | OPTIMISM | 30,572   | 39.91 Gwei   | $0.0001  |
| Transfer ERC20               | Direct    | MAINNET  | 6,018    | 5.38K Gwei   | $0.0198  |
| Transfer ERC20               | Direct    | BASE     | 31,077   | 215.57 Gwei  | $0.0007  |
| Transfer ERC20               | Direct    | ARBITRUM | 31,077   | 2.60K Gwei   | $0.0095  |
| Transfer ERC20               | Direct    | OPTIMISM | 31,077   | 40.42 Gwei   | $0.0001  |
| Approve ERC20 (UOP)          | Sponsored | MAINNET  | 57,874   | 51.70K Gwei  | $0.1907  |
| Approve ERC20 (UOP)          | Sponsored | BASE     | 82,428   | 564.12 Gwei  | $0.0020  |
| Approve ERC20 (UOP)          | Sponsored | ARBITRUM | 82,428   | 6.89K Gwei   | $0.0254  |
| Approve ERC20 (UOP)          | Sponsored | OPTIMISM | 82,428   | 91.90 Gwei   | $0.0003  |
| Transfer ERC20 (UOP)         | Sponsored | MAINNET  | 57,874   | 51.70K Gwei  | $0.1907  |
| Transfer ERC20 (UOP)         | Sponsored | BASE     | 82,933   | 567.55 Gwei  | $0.0020  |
| Transfer ERC20 (UOP)         | Sponsored | ARBITRUM | 82,933   | 6.94K Gwei   | $0.0255  |
| Transfer ERC20 (UOP)         | Sponsored | OPTIMISM | 82,933   | 92.41 Gwei   | $0.0003  |
| Approve ERC20 w/ MK (UOP)    | Sponsored | MAINNET  | 483,481  | 431.89K Gwei | $1.5936  |
| Approve ERC20 w/ MK (UOP)    | Sponsored | BASE     | 505,953  | 3.44K Gwei   | $0.0126  |
| Approve ERC20 w/ MK (UOP)    | Sponsored | ARBITRUM | 496,803  | 41.54K Gwei  | $0.1532  |
| Approve ERC20 w/ MK (UOP)    | Sponsored | OPTIMISM | 504,395  | 514.96 Gwei  | $0.0019  |
| Approve ERC20 w/ P256 (UOP)  | Sponsored | MAINNET  | 255,565  | 228.30K Gwei | $0.8424  |
| Approve ERC20 w/ P256 (UOP)  | Sponsored | BASE     | 280,995  | 1.91K Gwei   | $0.0070  |
| Approve ERC20 w/ P256 (UOP)  | Sponsored | ARBITRUM | 279,243  | 23.35K Gwei  | $0.0861  |
| Approve ERC20 w/ P256 (UOP)  | Sponsored | OPTIMISM | 281,433  | 291.42 Gwei  | $0.0010  |
| Transfer ERC20 w/ MK (UOP)   | Sponsored | MAINNET  | 483,754  | 432.14K Gwei | $1.5945  |
| Transfer ERC20 w/ MK (UOP)   | Sponsored | BASE     | 504,906  | 3.43K Gwei   | $0.0126  |
| Transfer ERC20 w/ MK (UOP)   | Sponsored | ARBITRUM | 507,920  | 42.47K Gwei  | $0.1567  |
| Transfer ERC20 w/ MK (UOP)   | Sponsored | OPTIMISM | 499,456  | 510.01 Gwei  | $0.0018  |
| Transfer ERC20 w/ P256 (UOP) | Sponsored | MAINNET  | 253,775  | 226.70K Gwei | $0.8365  |
| Transfer ERC20 w/ P256 (UOP) | Sponsored | BASE     | 277,958  | 1.89K Gwei   | $0.0069  |
| Transfer ERC20 w/ P256 (UOP) | Sponsored | ARBITRUM | 277,737  | 23.23K Gwei  | $0.0857  |
| Transfer ERC20 w/ P256 (UOP) | Sponsored | OPTIMISM | 279,710  | 289.69 Gwei  | $0.0010  |

## NativeTransfer Benchmarks

| Test Name                | Type      | Network  | Gas Used | Wei Cost     | USD Cost |
| ------------------------ | --------- | -------- | -------- | ------------ | -------- |
| Send ETH                 | Direct    | MAINNET  | 40,178   | 35.89K Gwei  | $0.1324  |
| Send ETH                 | Direct    | BASE     | 40,178   | 276.04 Gwei  | $0.0010  |
| Send ETH                 | Direct    | ARBITRUM | 40,178   | 3.36K Gwei   | $0.0123  |
| Send ETH                 | Direct    | OPTIMISM | 40,178   | 46.95 Gwei   | $0.0001  |
| Send ETH (UOP)           | Sponsored | MAINNET  | 91,970   | 82.16K Gwei  | $0.3031  |
| Send ETH (UOP)           | Sponsored | BASE     | 91,970   | 627.59 Gwei  | $0.0023  |
| Send ETH (UOP)           | Sponsored | ARBITRUM | 91,970   | 7.69K Gwei   | $0.0283  |
| Send ETH (UOP)           | Sponsored | OPTIMISM | 91,970   | 98.87 Gwei   | $0.0003  |
| Send ETH P256 (UOP)      | Sponsored | MAINNET  | 264,145  | 235.96K Gwei | $0.8706  |
| Send ETH P256 (UOP)      | Sponsored | BASE     | 261,955  | 1.78K Gwei   | $0.0065  |
| Send ETH P256 (UOP)      | Sponsored | ARBITRUM | 263,707  | 22.05K Gwei  | $0.0813  |
| Send ETH P256 (UOP)      | Sponsored | OPTIMISM | 265,021  | 272.37 Gwei  | $0.0010  |
| Send ETH w/ MK (UOP)     | Sponsored | MAINNET  | 478,841  | 427.75K Gwei | $1.5783  |
| Send ETH w/ MK (UOP)     | Sponsored | BASE     | 491,916  | 3.34K Gwei   | $0.0123  |
| Send ETH w/ MK (UOP)     | Sponsored | ARBITRUM | 493,327  | 41.25K Gwei  | $0.1522  |
| Send ETH w/ MK (UOP)     | Sponsored | OPTIMISM | 497,213  | 505.16 Gwei  | $0.0018  |
| Send ETH w/ SK-EOA (UOP) | Sponsored | MAINNET  | 72,231   | 64.52K Gwei  | $0.2380  |
| Send ETH w/ SK-EOA (UOP) | Sponsored | BASE     | 72,231   | 493.61 Gwei  | $0.0018  |
| Send ETH w/ SK-EOA (UOP) | Sponsored | ARBITRUM | 72,231   | 6.04K Gwei   | $0.0222  |
| Send ETH w/ SK-EOA (UOP) | Sponsored | OPTIMISM | 72,231   | 79.08 Gwei   | $0.0002  |

## Batch Benchmarks

| Test Name                     | Type      | Network  | Gas Used | Wei Cost     | USD Cost |
| ----------------------------- | --------- | -------- | -------- | ------------ | -------- |
| Batch Execution               | Direct    | MAINNET  | 7,434    | 6.64K Gwei   | $0.0245  |
| Batch Execution               | Direct    | BASE     | 35,158   | 246.33 Gwei  | $0.0009  |
| Batch Execution               | Direct    | ARBITRUM | 35,158   | 2.94K Gwei   | $0.0108  |
| Batch Execution               | Direct    | OPTIMISM | 35,158   | 50.65 Gwei   | $0.0001  |
| Batch Execution (UOP)         | Sponsored | MAINNET  | 59,485   | 53.14K Gwei  | $0.1960  |
| Batch Execution (UOP)         | Sponsored | BASE     | 87,209   | 599.63 Gwei  | $0.0022  |
| Batch Execution (UOP)         | Sponsored | ARBITRUM | 87,209   | 7.29K Gwei   | $0.0269  |
| Batch Execution (UOP)         | Sponsored | OPTIMISM | 87,209   | 102.83 Gwei  | $0.0003  |
| Batch Execution w/ MK (UOP)   | Sponsored | MAINNET  | 480,812  | 429.51K Gwei | $1.5848  |
| Batch Execution w/ MK (UOP)   | Sponsored | BASE     | 521,524  | 3.55K Gwei   | $0.0130  |
| Batch Execution w/ MK (UOP)   | Sponsored | ARBITRUM | 511,553  | 42.78K Gwei  | $0.1578  |
| Batch Execution w/ MK (UOP)   | Sponsored | OPTIMISM | 509,195  | 525.91 Gwei  | $0.0019  |
| Batch Execution w/ P256 (UOP) | Sponsored | MAINNET  | 261,864  | 233.92K Gwei | $0.8631  |
| Batch Execution w/ P256 (UOP) | Sponsored | BASE     | 287,836  | 1.96K Gwei   | $0.0072  |
| Batch Execution w/ P256 (UOP) | Sponsored | ARBITRUM | 288,274  | 24.11K Gwei  | $0.0889  |
| Batch Execution w/ P256 (UOP) | Sponsored | OPTIMISM | 289,150  | 305.29 Gwei  | $0.0011  |

## Gas Usage Summary

| Test                                 | Type      | MAINNET   | BASE      | ARBITRUM  | OPTIMISM  |
| ------------------------------------ | --------- | --------- | --------- | --------- | --------- |
| Deploy OPF                           | Direct    | 4,973,383 | 4,974,518 | 4,979,720 | 4,984,975 |
| Initialize TX                        | Direct    | 357,246   | 357,246   | 357,246   | 357,246   |
| Initialize + Session Key             | Direct    | 656,473   | 656,473   | 656,473   | 656,473   |
| Initialize TX (UOP)                  | Sponsored | 407,799   | 407,799   | 407,799   | 407,799   |
| Initialize + Session Key (UOP)       | Sponsored | 454,215   | 454,215   | 454,215   | 454,215   |
| Register EOA                         | Direct    | 223,953   | 223,953   | 223,953   | 223,953   |
| Register P256                        | Direct    | 303,555   | 303,555   | 303,555   | 303,555   |
| Register P256 (Non-Extrac)           | Direct    | 303,555   | 303,555   | 303,555   | 303,555   |
| Register EOA (UOP)                   | Sponsored | 274,212   | 274,212   | 274,212   | 274,212   |
| Register P256 (UOP)                  | Sponsored | 353,814   | 353,814   | 353,814   | 353,814   |
| Register P256 (Non-Extrac UOP)       | Sponsored | 353,814   | 353,814   | 353,814   | 353,814   |
| Register P256 (Non-Extrac w/ MK UOP) | Sponsored | 778,813   | 779,643   | 776,329   | 778,067   |
| Approve ERC20                        | Direct    | 6,018     | 30,572    | 30,572    | 30,572    |
| Transfer ERC20                       | Direct    | 6,018     | 31,077    | 31,077    | 31,077    |
| Approve ERC20 (UOP)                  | Sponsored | 57,874    | 82,428    | 82,428    | 82,428    |
| Transfer ERC20 (UOP)                 | Sponsored | 57,874    | 82,933    | 82,933    | 82,933    |
| Approve ERC20 w/ MK (UOP)            | Sponsored | 483,481   | 505,953   | 496,803   | 504,395   |
| Approve ERC20 w/ P256 (UOP)          | Sponsored | 255,565   | 280,995   | 279,243   | 281,433   |
| Transfer ERC20 w/ MK (UOP)           | Sponsored | 483,754   | 504,906   | 507,920   | 499,456   |
| Transfer ERC20 w/ P256 (UOP)         | Sponsored | 253,775   | 277,958   | 277,737   | 279,710   |
| Send ETH                             | Direct    | 40,178    | 40,178    | 40,178    | 40,178    |
| Send ETH (UOP)                       | Sponsored | 91,970    | 91,970    | 91,970    | 91,970    |
| Send ETH P256 (UOP)                  | Sponsored | 264,145   | 261,955   | 263,707   | 265,021   |
| Send ETH w/ MK (UOP)                 | Sponsored | 478,841   | 491,916   | 493,327   | 497,213   |
| Send ETH w/ SK-EOA (UOP)             | Sponsored | 72,231    | 72,231    | 72,231    | 72,231    |
| Batch Execution                      | Direct    | 7,434     | 35,158    | 35,158    | 35,158    |
| Batch Execution (UOP)                | Sponsored | 59,485    | 87,209    | 87,209    | 87,209    |
| Batch Execution w/ MK (UOP)          | Sponsored | 480,812   | 521,524   | 511,553   | 509,195   |
| Batch Execution w/ P256 (UOP)        | Sponsored | 261,864   | 287,836   | 288,274   | 289,150   |

## Cost Comparison (USD)

| Test                                 | Type      | MAINNET  | BASE    | ARBITRUM | OPTIMISM |    Best Network |
| ------------------------------------ | --------- | -------- | ------- | -------- | -------- | --------------- |
| Deploy OPF                           | Direct    | $16.3935 | $0.1272 | $1.5365  | $0.0237  | **OPTIMISM**    |
| Initialize TX                        | Direct    | $1.1775  | $0.0090 | $0.1102  | $0.0014  | **OPTIMISM**    |
| Initialize + Session Key             | Direct    | $2.1639  | $0.0165 | $0.2025  | $0.0025  | **OPTIMISM**    |
| Initialize TX (UOP)                  | Sponsored | $1.3442  | $0.0102 | $0.1258  | $0.0016  | **OPTIMISM**    |
| Initialize + Session Key (UOP)       | Sponsored | $1.4972  | $0.0114 | $0.1401  | $0.0018  | **OPTIMISM**    |
| Register EOA                         | Direct    | $0.7382  | $0.0056 | $0.0691  | $0.0008  | **OPTIMISM**    |
| Register P256                        | Direct    | $1.0005  | $0.0076 | $0.0936  | $0.0011  | **OPTIMISM**    |
| Register P256 (Non-Extrac)           | Direct    | $1.0005  | $0.0076 | $0.0936  | $0.0011  | **OPTIMISM**    |
| Register EOA (UOP)                   | Sponsored | $0.9038  | $0.0068 | $0.0846  | $0.0010  | **OPTIMISM**    |
| Register P256 (UOP)                  | Sponsored | $1.1662  | $0.0088 | $0.1091  | $0.0013  | **OPTIMISM**    |
| Register P256 (Non-Extrac UOP)       | Sponsored | $1.1662  | $0.0088 | $0.1091  | $0.0013  | **OPTIMISM**    |
| Register P256 (Non-Extrac w/ MK UOP) | Sponsored | $2.5671  | $0.0195 | $0.2395  | $0.0029  | **OPTIMISM**    |
| Approve ERC20                        | Direct    | $0.0198  | $0.0007 | $0.0094  | $0.0001  | **OPTIMISM**    |
| Transfer ERC20                       | Direct    | $0.0198  | $0.0007 | $0.0095  | $0.0001  | **OPTIMISM**    |
| Approve ERC20 (UOP)                  | Sponsored | $0.1907  | $0.0020 | $0.0254  | $0.0003  | **OPTIMISM**    |
| Transfer ERC20 (UOP)                 | Sponsored | $0.1907  | $0.0020 | $0.0255  | $0.0003  | **OPTIMISM**    |
| Approve ERC20 w/ MK (UOP)            | Sponsored | $1.5936  | $0.0126 | $0.1532  | $0.0019  | **OPTIMISM**    |
| Approve ERC20 w/ P256 (UOP)          | Sponsored | $0.8424  | $0.0070 | $0.0861  | $0.0010  | **OPTIMISM**    |
| Transfer ERC20 w/ MK (UOP)           | Sponsored | $1.5945  | $0.0126 | $0.1567  | $0.0018  | **OPTIMISM**    |
| Transfer ERC20 w/ P256 (UOP)         | Sponsored | $0.8365  | $0.0069 | $0.0857  | $0.0010  | **OPTIMISM**    |
| Send ETH                             | Direct    | $0.1324  | $0.0010 | $0.0123  | $0.0001  | **OPTIMISM**    |
| Send ETH (UOP)                       | Sponsored | $0.3031  | $0.0023 | $0.0283  | $0.0003  | **OPTIMISM**    |
| Send ETH P256 (UOP)                  | Sponsored | $0.8706  | $0.0065 | $0.0813  | $0.0010  | **OPTIMISM**    |
| Send ETH w/ MK (UOP)                 | Sponsored | $1.5783  | $0.0123 | $0.1522  | $0.0018  | **OPTIMISM**    |
| Send ETH w/ SK-EOA (UOP)             | Sponsored | $0.2380  | $0.0018 | $0.0222  | $0.0002  | **OPTIMISM**    |
| Batch Execution                      | Direct    | $0.0245  | $0.0009 | $0.0108  | $0.0001  | **OPTIMISM**    |
| Batch Execution (UOP)                | Sponsored | $0.1960  | $0.0022 | $0.0269  | $0.0003  | **OPTIMISM**    |
| Batch Execution w/ MK (UOP)          | Sponsored | $1.5848  | $0.0130 | $0.1578  | $0.0019  | **OPTIMISM**    |
| Batch Execution w/ P256 (UOP)        | Sponsored | $0.8631  | $0.0072 | $0.0889  | $0.0011  | **OPTIMISM**    |

## Direct vs Sponsored Analysis

### MAINNET Network Analysis

| Test                     | Direct Cost | Sponsored Cost | Difference        | Direct Gas | Sponsored Gas | Gas Overhead        |
| ------------------------ | ----------- | -------------- | ----------------- | ---------- | ------------- | ------------------- |
| Initialize TX            | $1.1775     | $1.3442        | $0.1667 (14.2%)   | 357,246    | 407,799       | +50,553 (+14.2%)    |
| Initialize + Session Key | $2.1639     | $1.4972        | $-0.6667 (-30.8%) | 656,473    | 454,215       | +-202,258 (+-30.8%) |
| Register EOA             | $0.7382     | $0.9038        | $0.1656 (22.4%)   | 223,953    | 274,212       | +50,259 (+22.4%)    |
| Register P256            | $1.0005     | $1.1662        | $0.1657 (16.6%)   | 303,555    | 353,814       | +50,259 (+16.6%)    |
| Approve ERC20            | $0.0198     | $0.1907        | $0.1709 (863.1%)  | 6,018      | 57,874        | +51,856 (+861.7%)   |
| Transfer ERC20           | $0.0198     | $0.1907        | $0.1709 (863.1%)  | 6,018      | 57,874        | +51,856 (+861.7%)   |
| Send ETH                 | $0.1324     | $0.3031        | $0.1707 (128.9%)  | 40,178     | 91,970        | +51,792 (+128.9%)   |
| Batch Execution          | $0.0245     | $0.1960        | $0.1715 (700.0%)  | 7,434      | 59,485        | +52,051 (+700.2%)   |

### BASE Network Analysis

| Test                     | Direct Cost | Sponsored Cost | Difference        | Direct Gas | Sponsored Gas | Gas Overhead        |
| ------------------------ | ----------- | -------------- | ----------------- | ---------- | ------------- | ------------------- |
| Initialize TX            | $0.0090     | $0.0102        | $0.0012 (13.3%)   | 357,246    | 407,799       | +50,553 (+14.2%)    |
| Initialize + Session Key | $0.0165     | $0.0114        | $-0.0051 (-30.9%) | 656,473    | 454,215       | +-202,258 (+-30.8%) |
| Register EOA             | $0.0056     | $0.0068        | $0.0012 (21.4%)   | 223,953    | 274,212       | +50,259 (+22.4%)    |
| Register P256            | $0.0076     | $0.0088        | $0.0012 (15.8%)   | 303,555    | 353,814       | +50,259 (+16.6%)    |
| Approve ERC20            | $0.0007     | $0.0020        | $0.0013 (185.7%)  | 30,572     | 82,428        | +51,856 (+169.6%)   |
| Transfer ERC20           | $0.0007     | $0.0020        | $0.0013 (185.7%)  | 31,077     | 82,933        | +51,856 (+166.9%)   |
| Send ETH                 | $0.0010     | $0.0023        | $0.0013 (130.0%)  | 40,178     | 91,970        | +51,792 (+128.9%)   |
| Batch Execution          | $0.0009     | $0.0022        | $0.0013 (144.4%)  | 35,158     | 87,209        | +52,051 (+148.0%)   |

### ARBITRUM Network Analysis

| Test                     | Direct Cost | Sponsored Cost | Difference        | Direct Gas | Sponsored Gas | Gas Overhead        |
| ------------------------ | ----------- | -------------- | ----------------- | ---------- | ------------- | ------------------- |
| Initialize TX            | $0.1102     | $0.1258        | $0.0156 (14.2%)   | 357,246    | 407,799       | +50,553 (+14.2%)    |
| Initialize + Session Key | $0.2025     | $0.1401        | $-0.0624 (-30.8%) | 656,473    | 454,215       | +-202,258 (+-30.8%) |
| Register EOA             | $0.0691     | $0.0846        | $0.0155 (22.4%)   | 223,953    | 274,212       | +50,259 (+22.4%)    |
| Register P256            | $0.0936     | $0.1091        | $0.0155 (16.6%)   | 303,555    | 353,814       | +50,259 (+16.6%)    |
| Approve ERC20            | $0.0094     | $0.0254        | $0.0160 (170.2%)  | 30,572     | 82,428        | +51,856 (+169.6%)   |
| Transfer ERC20           | $0.0095     | $0.0255        | $0.0160 (168.4%)  | 31,077     | 82,933        | +51,856 (+166.9%)   |
| Send ETH                 | $0.0123     | $0.0283        | $0.0160 (130.1%)  | 40,178     | 91,970        | +51,792 (+128.9%)   |
| Batch Execution          | $0.0108     | $0.0269        | $0.0161 (149.1%)  | 35,158     | 87,209        | +52,051 (+148.0%)   |

### OPTIMISM Network Analysis

| Test                     | Direct Cost | Sponsored Cost | Difference        | Direct Gas | Sponsored Gas | Gas Overhead        |
| ------------------------ | ----------- | -------------- | ----------------- | ---------- | ------------- | ------------------- |
| Initialize TX            | $0.0014     | $0.0016        | $0.0002 (14.3%)   | 357,246    | 407,799       | +50,553 (+14.2%)    |
| Initialize + Session Key | $0.0025     | $0.0018        | $-0.0007 (-28.0%) | 656,473    | 454,215       | +-202,258 (+-30.8%) |
| Register EOA             | $0.0008     | $0.0010        | $0.0002 (25.0%)   | 223,953    | 274,212       | +50,259 (+22.4%)    |
| Register P256            | $0.0011     | $0.0013        | $0.0002 (18.2%)   | 303,555    | 353,814       | +50,259 (+16.6%)    |
| Approve ERC20            | $0.0001     | $0.0003        | $0.0002 (200.0%)  | 30,572     | 82,428        | +51,856 (+169.6%)   |
| Transfer ERC20           | $0.0001     | $0.0003        | $0.0002 (200.0%)  | 31,077     | 82,933        | +51,856 (+166.9%)   |
| Send ETH                 | $0.0001     | $0.0003        | $0.0002 (200.0%)  | 40,178     | 91,970        | +51,792 (+128.9%)   |
| Batch Execution          | $0.0001     | $0.0003        | $0.0002 (200.0%)  | 35,158     | 87,209        | +52,051 (+148.0%)   |

## Key Insights

### Network Cost Analysis
- **Cheapest Network Overall**: OPTIMISM (consistently lowest costs across all operations)
- **Most Expensive Network**: MAINNET (highest transaction costs across all networks)
- **Best L2 Alternative**: BASE (good balance of cost and performance)

### Direct vs Sponsored Transaction Analysis
- **Average Gas Overhead**: Sponsored transactions use ~321.8% more gas than direct transactions
- **Cost Premium**: Sponsored transactions cost more due to additional gas usage for UserOp handling
- **UX Trade-off**: Sponsored transactions provide better UX but at higher operational cost

### Signature Method Analysis
- **Standard UOP**: Most common sponsored transaction method
- **Master Key (MK)**: Alternative signature method with different gas characteristics
- **P256 Signatures**: Advanced cryptographic signature method
- **Session Key EOA**: Session-based signing for improved UX

### Total Cost Comparison
- **MAINNET**: Direct: 22.6706 | Sponsored: 19.5270
- **BASE**: Direct: 0.1768 | Sponsored: 0.1539
- **ARBITRUM**: Direct: 2.1475 | Sponsored: 1.8984
- **OPTIMISM**: Direct: 0.0310 | Sponsored: 0.0228

### Operation Highlights
- **Most Expensive**: Deploy OPF (Direct) (16.3935 on MAINNET)
- **Most Gas Intensive**: Deploy OPF (Direct) (4,973,383 gas)

### Recommendations
- **For Cost Optimization**: Use OPTIMISM network for ~90% cost savings vs MAINNET
- **For User Experience**: Consider sponsored transactions for better UX, budget ~322% extra gas
- **For Development**: BASE offers good cost-performance balance for testing and development
- **For High-Volume Operations**: The gas overhead of sponsored transactions can be significant at scale
- **Signature Methods**: Test different signature methods (MK, P256, Session Keys) to optimize for your use case
