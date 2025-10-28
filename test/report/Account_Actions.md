# Account Management Actions - Gas Benchmarks

## Overview

This report provides comprehensive gas consumption measurements for account management operations in EIP-7702 implementations. Account management actions include key registration, permission configuration, and revocation operations that control account behavior and access.

### Operation Categories

**Key Registration:**
- `RegisterKeySelf` - Register a new key with self-custody
- `RegisterKeyCustodial` - Register a new key with third-party custody

**Permission Configuration:**
- `SetTokenSpend` - Configure ERC20 token spending limits
- `SetCanCall` - Configure contract call permissions

**Key Management:**
- `UpdateKeyData` - Update existing key metadata
- `UpdateTokenSpend` - Modify token spending limits
- `RevokeKey` - Revoke key access

**Permission Removal:**
- `RemoveTokenSpend` - Remove token spending permissions
- `RemoveCanCall` - Remove contract call permissions

---

## RootKey Operations

Account management operations using ECDSA RootKey signature.

| Action | Direct | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
|--------|--------|-------------|------------------|
| RegisterKeySelf | 126,410 | 198,751 (+57.2%) | 227,458 (+14.4%) |
| RegisterKeyCustodial | 177,450 | 249,779 (+40.8%) | 278,498 (+11.5%) |
| SetTokenSpend | 103,434 | 175,565 (+69.7%) | 204,270 (+16.3%) |
| SetCanCall | 57,667 | 129,810 (+125.1%) | 158,503 (+22.1%) |
| UpdateKeyData | 30,500 | 102,568 (+236.3%) | 131,273 (+28.0%) |
| UpdateTokenSpend | 44,716 | 116,859 (+161.4%) | 145,540 (+24.5%) |
| RevokeKey | 45,854 | 115,408 (+151.7%) | 144,111 (+24.9%) |
| RemoveTokenSpend | 41,230 | 109,201 (+164.9%) | 137,881 (+26.2%) |
| RemoveCanCall | 35,547 | 107,678 (+202.9%) | 136,371 (+26.6%) |

### RootKey Insights

- **Most Expensive Operations**: Key registration operations (126k-177k gas direct)
- **Least Expensive Operations**: Permission removal and updates (30k-57k gas direct)
- **AA Overhead**: Account Abstraction adds 72k-125k gas overhead
- **ERC20 Paymaster Overhead**: Additional 24k-29k gas for ERC20 payment

---

## WebAuthn MasterKey Operations

Account management operations using WebAuthn P256 MasterKey signature.

| Action | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
|--------|-------------|------------------|
| RegisterKeySelf | 389,880 | 417,637 (+7.1%) |
| RegisterKeyCustodial | 440,056 | 468,030 (+6.4%) |
| SetTokenSpend | 367,581 | 395,349 (+7.5%) |
| SetCanCall | 320,500 | 349,570 (+9.1%) |
| UpdateKeyData | 293,270 | 322,364 (+9.9%) |
| UpdateTokenSpend | 309,703 | 335,743 (+8.4%) |
| RevokeKeySelf | 307,412 | 333,864 (+8.6%) |
| RemoveTokenSpend | 304,338 | 331,207 (+8.8%) |
| RemoveCanCall | 300,120 | 327,945 (+9.3%) |

### WebAuthn MasterKey Insights

- **Most Expensive Operations**: Key registration operations (390k-440k gas)
- **Least Expensive Operations**: Permission removal and updates (293k-320k gas)
- **ERC20 Paymaster Overhead**: Consistent 7-10% overhead (~26k-29k gas)
- **WebAuthn Overhead vs RootKey**: ~190k-195k gas additional cost

---

## Comparative Analysis

### Signature Type Comparison (AASponsored)

Comparing WebAuthn MasterKey vs RootKey signature costs:

| Operation | RootKey | WebAuthn | Overhead |
|-----------|---------|----------|----------|
| RegisterKeySelf | 198,751 | 389,880 | +96% (191,129 gas) |
| RegisterKeyCustodial | 249,779 | 440,056 | +76% (190,277 gas) |
| SetTokenSpend | 175,565 | 367,581 | +109% (192,016 gas) |
| SetCanCall | 129,810 | 320,500 | +147% (190,690 gas) |
| UpdateKeyData | 102,568 | 293,270 | +186% (190,702 gas) |
| UpdateTokenSpend | 116,859 | 309,703 | +165% (192,844 gas) |
| RevokeKey | 115,408 | 307,412 | +166% (192,004 gas) |
| RemoveTokenSpend | 109,201 | 304,338 | +179% (195,137 gas) |
| RemoveCanCall | 107,678 | 300,120 | +179% (192,442 gas) |

**Key Finding**: WebAuthn signature verification adds **~190k-195k gas** overhead for account management operations, representing **76-186%** increase over ECDSA.

### Paymaster Mode Overhead

#### RootKey Paymaster Overhead

| Operation | Direct→ERC4337 Sponsored| AASponsored→ERC4337 Sponsored ERC20 |
|-----------|-------------------|-------------------|
| RegisterKeySelf | +72,341 gas | +28,707 gas |
| RegisterKeyCustodial | +72,329 gas | +28,719 gas |
| SetTokenSpend | +72,131 gas | +28,705 gas |
| SetCanCall | +72,143 gas | +28,693 gas |
| UpdateKeyData | +72,068 gas | +28,705 gas |
| UpdateTokenSpend | +72,143 gas | +28,681 gas |
| RevokeKey | +69,554 gas | +28,703 gas |
| RemoveTokenSpend | +67,971 gas | +28,680 gas |
| RemoveCanCall | +72,131 gas | +28,693 gas |

**Average**: ~71k gas for AA, ~29k gas for ERC20 paymaster

#### WebAuthn MasterKey Paymaster Overhead

| Operation | ERC4337 Sponsored→ERC4337 Sponsored ERC20 |
|-----------|-------------------|
| RegisterKeySelf | +27,757 gas |
| RegisterKeyCustodial | +27,974 gas |
| SetTokenSpend | +27,768 gas |
| SetCanCall | +29,070 gas |
| UpdateKeyData | +29,094 gas |
| UpdateTokenSpend | +26,040 gas |
| RevokeKeySelf | +26,452 gas |
| RemoveTokenSpend | +26,869 gas |
| RemoveCanCall | +27,825 gas |

**Average**: ~29k gas for ERC20 paymaster (consistent with RootKey)

### Operation Type Analysis

#### Most Expensive Operations (AASponsored)

1. **RegisterKeyCustodial** (RootKey: 249,779 | WebAuthn: 440,056)
   - Requires additional storage for custodial relationship
   - Highest gas consumption in both key types

2. **RegisterKeySelf** (RootKey: 198,751 | WebAuthn: 389,880)
   - New key registration with storage writes
   - Second highest gas consumption

3. **SetTokenSpend** (RootKey: 175,565 | WebAuthn: 367,581)
   - Configure token spending permissions
   - Complex permission logic

#### Least Expensive Operations (AASponsored)

1. **UpdateKeyData** (RootKey: 102,568 | WebAuthn: 293,270)
   - Metadata update without permission changes
   - Lowest gas consumption

2. **RemoveCanCall** (RootKey: 107,678 | WebAuthn: 300,120)
   - Simple permission removal
   - Minimal storage changes

3. **RemoveTokenSpend** (RootKey: 109,201 | WebAuthn: 304,338)
   - Token permission removal
   - Low complexity operation

---

## Recommendations

### For RootKey Operations

1. **Direct Calls**: Use when possible for 70k+ gas savings vs AA
2. **Batch Operations**: Group multiple account actions in single transaction
3. **AA Benefits**: Use when gasless experience required despite overhead

### For WebAuthn MasterKey Operations

1. **Cost Consideration**: Account for ~190k additional gas vs ECDSA
2. **UX Priority**: WebAuthn provides superior UX (biometric auth, no seed phrases)
3. **Network Selection**: Deploy on L2s to reduce absolute costs
4. **Batch Operations**: Critical for amortizing WebAuthn overhead

### Operation-Specific Guidance

- **Key Registration**: Most expensive - plan gas budget accordingly
- **Permission Updates**: Relatively cheap - can be done frequently
- **Custodial Mode**: Adds 28k-50k gas - evaluate trade-offs
- **ERC20 Paymaster**: Consistent ~27k-29k overhead - acceptable for gasless UX

---

**Last Updated**: 2025-10-27
**Benchmark Version**: 1.0.0
**Measurement Method**: Foundry `vm.snapshotGasLastCall()` with warmed storage
