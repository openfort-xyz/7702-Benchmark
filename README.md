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
| **DirectAA** | None | Account pays ETH |
| **AASponsored** | Native | Paymaster pays ETH |
| **AASponsoredERC20** | ERC20 | User refunds ERC20 |

---

## Benchmark Snippet Results

### Empty Operations

Empty `execute()` calls - baseline overhead measurement.

| Key Type | Direct | DirectAA | AASponsored | AASponsoredERC20 |
|----------|--------|----------|-------------|------------------|
| **RootKey** | 31,679 | 92,983 (+193.5%) | 104,059 (+11.9%) | 132,743 (+27.6%) |
| **EOA SessionKey** | - | 124,418 | 135,508 (+8.9%) | 164,196 (+21.2%) |
| **EOA SessionKey (Custodial)** | - | 139,929 | 151,528 (+8.3%) | 180,235 (+18.9%) |
| **P256 SessionKey** | - | 305,262 | 312,839 (+2.5%) | 344,581 (+10.1%) |
| **P256 SessionKey (Custodial)** | - | 320,786 | 328,872 (+2.5%) | 360,632 (+9.7%) |
| **WebAuthn SessionKey** | - | 499,969 | 507,889 (+1.6%) | 536,285 (+5.6%) |
| **WebAuthn SessionKey (Custodial)** | - | 515,583 | 524,012 (+1.6%) | 552,445 (+5.4%) |
| **WebAuthn MasterKey** | - | 469,222 | 477,142 (+1.7%) | 505,524 (+5.9%) |

### Full Benchmark Report

[Benchmark Results](/test/report/Benchmark_Results.md) | [Full Report]() | [Network Costs](/test/report/Network_Costs.md)

---

## Comparative Analysis

### Signature Type Gas Overhead

Comparing signature verification costs (AASponsored, empty operation):

| Signature Type | Gas Cost | Overhead vs ECDSA |
|----------------|----------|-------------------|
| ECDSA (RootKey) | 104,059 | Baseline |
| ECDSA (EOA SessionKey) | 135,508 | +30% |
| P256 (SessionKey) | 312,839 | +200% |
| WebAuthn (SessionKey) | 507,889 | +388% |
| WebAuthn (MasterKey) | 477,142 | +359% |

**Insight**: P256 and WebAuthn incur ~180-370k gas overhead due to signature verification complexity.

### Custodial Overhead

Comparing self-custody vs third-party custody (AASponsored, empty):

| Key Type | Self-Custody | Third-Party | Overhead |
|----------|--------------|-------------|----------|
| EOA SessionKey | 135,508 | 151,528 | +12% (16,020 gas) |
| P256 SessionKey | 312,839 | 328,872 | +5% (16,033 gas) |
| WebAuthn SessionKey | 507,889 | 524,012 | +3% (16,123 gas) |

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
forge test

# Run specific categories
forge test --match-contract "BenchmarksRootKey*"
forge test --match-contract "BenchmarksWebAuthnSessionKey*"
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

