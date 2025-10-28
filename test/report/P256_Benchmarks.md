# P256 Signature Verification: Implementation Comparison

## Overview

This report compares three different P256 and WebAuthn signature verification implementations:
- **Solady**: Gas-optimized library by Vectorized
- **Daimo**: WebAuthn-focused verifier by Daimo
- **OpenZeppelin (OZ)**: Standard cryptography library

All benchmarks measure signature verification gas costs for both raw P256 signatures and full WebAuthn signature verification.

---

## Gas Consumption Benchmarks

### P256 Signature Verification

Direct P256 (secp256r1) signature verification without WebAuthn overhead.

| Implementation | Gas Used | vs Solady | Rank |
|----------------|----------|-----------|------|
| **Solady** | 173,972 | Baseline | 1st |
| **Daimo** | 347,292 | +99.6% (+173,320 gas) | 2nd |
| **OpenZeppelin** | 369,358 | +112.3% (+195,386 gas) | 3rd |

**Key Finding**: Solady is **2x more efficient** than Daimo and OpenZeppelin for P256 verification.

---

### WebAuthn Signature Verification

Full WebAuthn signature verification including authenticator data parsing.

| Implementation | Gas Used | vs Solady | Rank |
|----------------|----------|-----------|------|
| **Solady** | 176,306 | Baseline | 1st |
| **Daimo** | 354,448 | +101.0% (+178,142 gas) | 2nd |
| **OpenZeppelin** | 371,263 | +110.6% (+194,957 gas) | 3rd |

**Key Finding**: Solady maintains **2x efficiency** for WebAuthn verification, offering ~178k-195k gas savings per signature.

---

## Network Cost Analysis

Gas costs converted to USD across four major networks.

### P256 Signature Verification Costs

| Implementation | Gas Used | Ethereum | Base | Polygon | Optimism |
|----------------|----------|----------|------|---------|----------|
| **Solady** | 173,972 | $0.09492 | $0.01399 | $0.00103 | $0.02025 |
| **Daimo** | 347,292 | $0.18949 | $0.01888 | $0.00206 | $0.02098 |
| **OpenZeppelin** | 369,358 | $0.20153 | $0.01950 | $0.00219 | $0.02107 |

**Savings vs OpenZeppelin**:
- Ethereum: $0.107/signature (53% cheaper)
- Base: $0.006/signature (28% cheaper)
- Polygon: $0.001/signature (53% cheaper)
- Optimism: $0.001/signature (4% cheaper)

---

### WebAuthn Signature Verification Costs

| Implementation | Gas Used | Ethereum | Base | Polygon | Optimism |
|----------------|----------|----------|------|---------|----------|
| **Solady** | 176,306 | $0.09620 | $0.01406 | $0.00105 | $0.02026 |
| **Daimo** | 354,448 | $0.19340 | $0.01908 | $0.00210 | $0.02101 |
| **OpenZeppelin** | 371,263 | $0.20257 | $0.01955 | $0.00220 | $0.02108 |

**Savings vs OpenZeppelin**:
- Ethereum: $0.106/signature (53% cheaper)
- Base: $0.005/signature (28% cheaper)
- Polygon: $0.001/signature (53% cheaper)
- Optimism: $0.001/signature (4% cheaper)

---

## Comparative Analysis

### Gas Overhead Breakdown

Comparing overhead between implementations (WebAuthn test):

| Implementation | Gas Used | Overhead vs Solady | % Increase |
|----------------|----------|--------------------|------------|
| Solady | 176,306 | Baseline | 0% |
| Daimo | 354,448 | +178,142 gas | +101.0% |
| OpenZeppelin | 371,263 | +194,957 gas | +110.6% |

**Insight**: OpenZeppelin has 17k more overhead than Daimo (~9% additional cost over Daimo).

---

### WebAuthn vs P256 Overhead

Additional gas for WebAuthn authenticator data parsing:

| Implementation | P256 Gas | WebAuthn Gas | WebAuthn Overhead |
|----------------|----------|--------------|-------------------|
| **Solady** | 173,972 | 176,306 | +2,334 gas (+1.3%) |
| **Daimo** | 347,292 | 354,448 | +7,156 gas (+2.1%) |
| **OpenZeppelin** | 369,358 | 371,263 | +1,905 gas (+0.5%) |

**Insight**: All implementations have relatively low WebAuthn parsing overhead (0.5-2.1%), with Daimo having the highest overhead.

### Source:

* Solady P256: https://github.com/Vectorized/solady/blob/836c169fe357b3c23ad5d5755a9b4fbbfad7a99b/src/utils/P256.sol
* Solady WebAuthn0: https://github.com/Vectorized/solady/blob/836c169fe357b3c23ad5d5755a9b4fbbfad7a99b/src/utils/WebAuthn.sol#L5
* Daimo P256: https://github.com/daimo-eth/p256-verifier/blob/master/src/P256.sol
* Daimo WebAuthn: https://github.com/daimo-eth/p256-verifier/blob/master/src/WebAuthn.sol
* OZ P256: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/P256.sol
* OZ WebAuthn: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/WebAuthn.sol