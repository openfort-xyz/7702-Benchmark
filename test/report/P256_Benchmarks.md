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
| **Solady** | 174,848 | Baseline | 1st |
| **Daimo** | 341,743 | +95.4% (+166,895 gas) | 2nd |
| **OpenZeppelin** | 371,652 | +112.5% (+196,804 gas) | 3rd |

**Key Finding**: Solady is **2x more efficient** than Daimo and OpenZeppelin for P256 verification.

---

### WebAuthn Signature Verification

Full WebAuthn signature verification including authenticator data parsing.

| Implementation | Gas Used | vs Solady | Rank |
|----------------|----------|-----------|------|
| **Solady** | 178,496 | Baseline | 1st |
| **Daimo** | 363,695 | +103.7% (+185,199 gas) | 2nd |
| **OpenZeppelin** | 376,998 | +111.2% (+198,502 gas) | 3rd |

**Key Finding**: Solady maintains **2x efficiency** for WebAuthn verification, offering ~185k-198k gas savings per signature.

---

## Network Cost Analysis

Gas costs converted to USD across four major networks.

### P256 Signature Verification Costs

| Implementation | Gas Used | Ethereum | Base | Polygon | Optimism |
|----------------|----------|----------|------|---------|----------|
| **Solady** | 174,848 | $0.09540 | $0.01402 | $0.00104 | $0.02026 |
| **Daimo** | 341,743 | $0.18646 | $0.01872 | $0.00203 | $0.02095 |
| **OpenZeppelin** | 371,652 | $0.20278 | $0.01956 | $0.00221 | $0.02108 |

**Savings vs OpenZeppelin**:
- Ethereum: $0.107/signature (53% cheaper)
- Base: $0.006/signature (28% cheaper)
- Polygon: $0.001/signature (53% cheaper)
- Optimism: $0.001/signature (4% cheaper)

---

### WebAuthn Signature Verification Costs

| Implementation | Gas Used | Ethereum | Base | Polygon | Optimism |
|----------------|----------|----------|------|---------|----------|
| **Solady** | 178,496 | $0.09739 | $0.01412 | $0.00106 | $0.02027 |
| **Daimo** | 363,695 | $0.19844 | $0.01934 | $0.00216 | $0.02104 |
| **OpenZeppelin** | 376,998 | $0.20570 | $0.01972 | $0.00224 | $0.02110 |

**Savings vs OpenZeppelin**:
- Ethereum: $0.108/signature (53% cheaper)
- Base: $0.006/signature (28% cheaper)
- Polygon: $0.001/signature (53% cheaper)
- Optimism: $0.001/signature (4% cheaper)

---

## Comparative Analysis

### Gas Overhead Breakdown

Comparing overhead between implementations (WebAuthn test):

| Implementation | Gas Used | Overhead vs Solady | % Increase |
|----------------|----------|--------------------|------------|
| Solady | 178,496 | Baseline | 0% |
| Daimo | 363,695 | +185,199 gas | +103.7% |
| OpenZeppelin | 376,998 | +198,502 gas | +111.2% |

**Insight**: OpenZeppelin has 13k more overhead than Daimo (~7% additional cost over Daimo).

---

### WebAuthn vs P256 Overhead

Additional gas for WebAuthn authenticator data parsing:

| Implementation | P256 Gas | WebAuthn Gas | WebAuthn Overhead |
|----------------|----------|--------------|-------------------|
| **Solady** | 174,848 | 178,496 | +3,648 gas (+2.1%) |
| **Daimo** | 341,743 | 363,695 | +21,952 gas (+6.4%) |
| **OpenZeppelin** | 371,652 | 376,998 | +5,346 gas (+1.4%) |

**Insight**: All implementations have relatively low WebAuthn parsing overhead (1.4-6.4%), with Daimo having the highest overhead.

### Source:

* Solady P256: https://github.com/Vectorized/solady/blob/836c169fe357b3c23ad5d5755a9b4fbbfad7a99b/src/utils/P256.sol
* Solady WebAuthn0: https://github.com/Vectorized/solady/blob/836c169fe357b3c23ad5d5755a9b4fbbfad7a99b/src/utils/WebAuthn.sol#L5
* Daimo P256: https://github.com/daimo-eth/p256-verifier/blob/master/src/P256.sol
* Daimo WebAuthn: https://github.com/daimo-eth/p256-verifier/blob/master/src/WebAuthn.sol
* OZ P256: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/P256.sol
* OZ WebAuthn: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/WebAuthn.sol