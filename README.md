#  Openfort 7702 Delegator Smart Contract Benchmarks

This benchmark suite provides comprehensive performance analysis of Openfort's EIP-7702 delegator smart contract across multiple blockchain networks. The benchmarks measure gas consumption, transaction costs, and performance characteristics for various operations including deployment, initialization, key registration, token transfers, and batch executions.

## EIP-7702 Delegator Contract
Openfort's 7702 delegator smart contract implements account abstraction features that enable:

- Account Delegation: EOAs can delegate execution to smart contract logic
- Sponsored Transactions: Third-party gas payment (account abstraction)
- Session Keys: Temporary authentication for improved UX
- Batch Operations: Multiple operations in a single transaction
- Advanced Signatures: Support for P256 and other signature schemes

##  Benchmark Categories
- Deploy Smart Contract
- Initialize Account
- Register-Key
- ERC20 Operations
- Native Transfer
- Batch Execution

#### Full Benchmark Report
[Full Report](/test/Output/enhanced-benchmark-report.md) | [Benchmarks Report](/test/Output/benchmark-report.md)

#### Benchmarks for EVM Networks
[Ethereum Mainnet](/test/Output/mainnet-benchmark-report.md) | [Base Mainnet](/test/Output/base-benchmark-report.md) | [Arbitrum Mainnet](/test/Output/arbitrum-benchmark-report.md) | [Optimism Mainnet](/test/Output/optimism-benchmark-report.md)

#### Comperison Benchmarks (aa-benchmarks)
**Disclaimer: We have prepared a comparison report between the Openfort 7702 Account and a standard Smart Contract Account (AA).**
[Ethereum Mainnet](test/Output/Comparison/ethereum.md) | [Base Mainnet](test/Output/Comparison/base.md) | [Arbitrum Mainnet](test/Output/Comparison/arbitrum.md) | [Optimism Mainnet](test/Output/Comparison/optimism.md)

<br></br>
Generated: 7/28/2025, 4:35:19 PM

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

| Test                       | MAINNET | BASE   | ARBITRUM | OPTIMISM |    Best      |
| -------------------------- | ------- | ------ | -------- | -------- | ------------ |
| Deploy OPF                 | 16.4848 | 0.1279 | 1.5451   | 0.0238   | **OPTIMISM** |
| Initialize TX              | 1.1765  | 0.0089 | 0.1101   | 0.0014   | **OPTIMISM** |
| Initialize + Session Key   | 2.1698  | 0.0165 | 0.2031   | 0.0025   | **OPTIMISM** |
| Register EOA               | 0.7345  | 0.0056 | 0.0687   | 0.0008   | **OPTIMISM** |
| Register P256              | 0.9969  | 0.0076 | 0.0933   | 0.0011   | **OPTIMISM** |
| Register P256 (Non-Extrac) | 0.9969  | 0.0076 | 0.0933   | 0.0011   | **OPTIMISM** |


## Openfort Benchmarks

## Openfort Benchmarks — Slides (README Pager)

> Tip: For a real slider, see GitHub Pages: https://openfort-xyz.github.io/7702-Benchmark/

<p id="slide-1"></p>

### Slide 1 / 14
<img src="./docs/slides/slide-1.png" alt="Slide 1" width="100%" />
<p align="right"><a href="#slide-2">Next ➜</a></p>

---

<p id="slide-2"></p>

### Slide 2 / 14
<img src="./docs/slides/slide-2.png" alt="Slide 2" width="100%" />
<p align="space-between">
  <a href="#slide-1">⬅ Prev</a> · <a href="#slide-3">Next ➜</a>
</p>

---

<p id="slide-3"></p>

### Slide 3 / 14
<img src="./docs/slides/slide-3.png" alt="Slide 3" width="100%" />
<p><a href="#slide-2">⬅ Prev</a> · <a href="#slide-4">Next ➜</a></p>

---

<p id="slide-4"></p>

### Slide 4 / 14
<img src="./docs/slides/slide-4.png" alt="Slide 4" width="100%" />
<p><a href="#slide-3">⬅ Prev</a> · <a href="#slide-5">Next ➜</a></p>

---

<p id="slide-5"></p>

### Slide 5 / 14
<img src="./docs/slides/slide-5.png" alt="Slide 5" width="100%" />
<p><a href="#slide-4">⬅ Prev</a> · <a href="#slide-6">Next ➜</a></p>

---

<p id="slide-6"></p>

### Slide 6 / 14
<img src="./docs/slides/slide-6.png" alt="Slide 6" width="100%" />
<p><a href="#slide-5">⬅ Prev</a> · <a href="#slide-7">Next ➜</a></p>

---

<p id="slide-7"></p>

### Slide 7 / 14
<img src="./docs/slides/slide-7.png" alt="Slide 7" width="100%" />
<p><a href="#slide-6">⬅ Prev</a> · <a href="#slide-8">Next ➜</a></p>

---

<p id="slide-8"></p>

### Slide 8 / 14
<img src="./docs/slides/slide-8.png" alt="Slide 8" width="100%" />
<p><a href="#slide-7">⬅ Prev</a> · <a href="#slide-9">Next ➜</a></p>

---

<p id="slide-9"></p>

### Slide 9 / 14
<img src="./docs/slides/slide-9.png" alt="Slide 9" width="100%" />
<p><a href="#slide-8">⬅ Prev</a> · <a href="#slide-10">Next ➜</a></p>

---

<p id="slide-10"></p>

### Slide 10 / 14
<img src="./docs/slides/slide-10.png" alt="Slide 10" width="100%" />
<p><a href="#slide-9">⬅ Prev</a> · <a href="#slide-11">Next ➜</a></p>

---

<p id="slide-11"></p>

### Slide 11 / 14
<img src="./docs/slides/slide-11.png" alt="Slide 11" width="100%" />
<p><a href="#slide-10">⬅ Prev</a> · <a href="#slide-12">Next ➜</a></p>

---

<p id="slide-12"></p>

### Slide 12 / 14
<img src="./docs/slides/slide-12.png" alt="Slide 12" width="100%" />
<p><a href="#slide-11">⬅ Prev</a> · <a href="#slide-13">Next ➜</a></p>

---

<p id="slide-13"></p>

### Slide 13 / 14
<img src="./docs/slides/slide-13.png" alt="Slide 13" width="100%" />
<p><a href="#slide-12">⬅ Prev</a> · <a href="#slide-14">Next ➜</a></p>

---

<p id="slide-14"></p>

### Slide 14 / 14
<img src="./docs/slides/slide-14.png" alt="Slide 14" width="100%" />
<p><a href="#slide-13">⬅ Prev</a></p>

## Key Insights

- **Cheapest Network**: OPTIMISM consistently offers the lowest costs
- **Most Expensive**: MAINNET has the highest transaction costs
- **Gas Consistency**: Gas usage remains the same across networks
- **Cost Savings**: Using OPTIMISM vs MAINNET saves ~99.9% (Total: $22.5287)
- **Price Variation**: Up to 735x difference between most/least expensive networks
- **Total Costs**: MAINNET: $22.5594 | BASE: $0.1741 | ARBITRUM: $2.1136 | OPTIMISM: $0.0307
- **Most Expensive Operation**: "Deploy OPF" ($16.4848 on MAINNET)
- **Most Efficient Operation**: "Register EOA" (222,841 gas)

