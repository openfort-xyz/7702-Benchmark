# EIP-7702 Delegator Smart Contract Benchmarks Benchmark Suite

Comprehensive gas benchmarks for EIP-7702 Account Abstraction implementations across different key types, operation modes, and transaction scenarios.

## Table of Contents
- [Introduction](#introduction)
- [EIP-7702 Overview](#eip-7702-overview)
- [Benchmark Methodology](#benchmark-methodology)
- [Key Types & Operation Modes](#key-types--operation-modes)
- [Benchmark Snippet Results](#benchmark-snippet-results)
- [Comparative Analysis](#comparative-analysis)

---

## Introduction

This benchmark suite provides comprehensive gas consumption measurements for EIP-7702 implementations across:
- **Key Types**: RootKey, WebAuthn MasterKey, SessionKey (EOA, P256, WebAuthn)
- **Operation Modes**: Direct Call, ERC4377 AA Call (Not Sponsored, Sponsored, Sponsored ERC20)
- **Transaction Types**: Empty Calls, Native transfers, ERC20 transfers, Batch operations, UniswapV2 swaps
- **Custodial Variants**: Self-custody vs third-party custody models

> **All benchmarks measure real gas consumption using Foundry's `vm.snapshotGasLastCall()` with warmed storage to ensure accurate, production-representative measurements.**

---

## EIP-7702 Overview

**EIP-7702** enables Externally Owned Accounts (EOAs) to temporarily delegate execution to smart contracts, providing Account Abstraction features while maintaining private key security.

### Key Features
- Native EOA Support (no contract deployment)
- Temporary Delegation (transaction-scoped)
- Session Keys (granular permissions)
- Flexible Signatures (ECDSA, P256, WebAuthn)
- ERC-4337 Compatible

---

## Benchmark Methodology

### Warming Strategy

All benchmarks use consistent warming to ensure accurate measurements:

1. **EntryPoint Warm-up**: Execute initial operations to warm EntryPoint storage
2. **Account Warm-up**: Run sample transactions through each operation mode
3. **Storage Warm-up**: Call `_etch()` immediately before measured operations

**What's Measured**: `entryPoint.handleOps()` - Complete ERC-4337 UserOperation execution including signature verification, execution, and gas accounting.

---

## Key Types & Operation Modes

### Key Types

| Key Type | Signature Method | Use Case |
|----------|------------------|----------|
| **RootKey** | ECDSA (secp256k1) | Full account control |
| **MasterKey (WebAuthn)** | WebAuthn P256 | Full account control |
| **SessionKey (EOA)** | ECDSA (secp256k1) | Limited permissions |
| **SessionKey (WebAuthn)** | WebAuthn P256 | Limited permissions |
| **SessionKey (P256)** | P256 (secp256r1) | Limited permissions |

### Operation Modes

| Mode | Paymaster | Gas Payment |
|------|-----------|-------------|
| **Direct** | None | Sender pays ETH |
| **ERC4337** | None | Account pays ETH |
| **ERC4337 Sponsored** | Native | Paymaster pays ETH |
| **ERC4337 Sponsored ERC20** | ERC20 |  Paymaster pays ERC20 |

---

## Benchmark Snippet Results

### Empty Operations

Empty `execute()` calls - baseline overhead measurement.

| Key Type | Direct | ERC4337 | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
|----------|--------|----------|-------------|------------------|
| **RootKey** | 31,679 | 92,995 (+193.5%) | 104,083 (+11.9%) | 132,755 (+27.5%) |
| **EOA SessionKey** | - | 124,430 | 135,508 (+8.9%) | 164,184 (+21.1%) |
| **EOA SessionKey (Custodial)** | - | 139,941 | 151,528 (+8.3%) | 180,223 (+18.9%) |
| **P256 SessionKey** | - | 304,406 | 313,124 (+2.9%) | 345,087 (+10.2%) |
| **P256 SessionKey (Custodial)** | - | 319,930 | 329,157 (+2.9%) | 361,138 (+9.7%) |
| **WebAuthn SessionKey** | - | 316,628 | 329,085 (+3.9%) | 350,660 (+6.6%) |
| **WebAuthn SessionKey (Custodial)** | - | 332,259 | 345,226 (+3.9%) | 366,803 (+6.2%) |
| **WebAuthn MasterKey** | - | 281,888 | 293,898 (+4.3%) | 323,601 (+10.1%) |

### Full Benchmark Report

[Benchmark Results](/test/report/Benchmark_Results.md) | [Account Management](/test/report/Account_Actions.md) | [Network Costs](/test/report/Network_Costs.md)

---

## Comparative Analysis

### Signature Type Gas Overhead

Comparing signature verification costs (AASponsored, empty operation):

| Signature Type | Gas Cost | Overhead vs ECDSA |
|----------------|----------|-------------------|
| ECDSA (RootKey) | 104,083 | Baseline |
| ECDSA (EOA SessionKey) | 135,508 | +30% |
| P256 (SessionKey) | 313,124 | +201% |
| WebAuthn (SessionKey) | 329,085 | +216% |
| WebAuthn (MasterKey) | 293,898 | +182% |

**Insight**: P256 signature verification adds ~209k gas overhead. WebAuthn adds ~189k-225k gas overhead - a **40% improvement** over previous implementations due to optimizations.

### Custodial Overhead

Comparing self-custody vs third-party custody (AASponsored, empty):

| Key Type | Self-Custody | Third-Party | Overhead |
|----------|--------------|-------------|----------|
| EOA SessionKey | 135,508 | 151,528 | +12% (16,020 gas) |
| P256 SessionKey | 313,124 | 329,157 | +5% (16,033 gas) |
| WebAuthn SessionKey | 329,085 | 345,226 | +5% (16,141 gas) |

**Insight**: Custodial overhead is consistent (~16k gas) across signature types.

---

## Running Benchmarks

```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Install dependencies
forge install

# Run all benchmarks
forge test --isolate

# Run specific categories
forge test --mc "BenchmarksRootKey*"  --isolate
forge test --mc "BenchmarksWebAuthnSessionKey*"  --isolate
```

---

## Repository Structure

```
7702-Benchmark/
│ 
├── test/benchmarks/              # Benchmark test files
│   ├── RootKey/
│   ├── EOA-SessionKey/
│   ├── P256-SessionKey/
│   ├── WebAuthn-SessionKey/
│   ├── WebAuthb-MasterKey/
│   ├── 3rd-Party-SessionKey/
│   └── SoladyVsDaimo/
├── snapshots/                    # Gas measurements (43 files)
├── README.md                     # This file
└── *.md                          # Additional documentation
```

---

## Acknowledgments

- **EIP-7702**: [Specification](https://eips.ethereum.org/EIPS/eip-7702)
- **ERC-4337**: [Account Abstraction](https://eips.ethereum.org/EIPS/eip-4337)
- **RIP-7212**: [P256 Precompile](https://github.com/ethereum/RIPs/blob/master/RIPS/rip-7212.md)
- **Solady**: [Gas-optimized libraries](https://github.com/vectorized/solady)
- **FreshCryptoLib**: [P256 implementation](https://github.com/rdubois-crypto/FreshCryptoLib)
- **Daimo**: [WebAuthn verifier](https://github.com/daimo-eth/p256-verifier)

---

**Last Updated**: 2025-10-27
**Benchmark Version**: 1.0.0
**Solidity**: 0.8.29
**Foundry**: Latest

