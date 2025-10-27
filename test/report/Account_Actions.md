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

| Action | Direct | AASponsored | AASponsoredERC20 |
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

| Action | AASponsored | AASponsoredERC20 |
|--------|-------------|------------------|
| RegisterKeySelf | 565,397 | 604,914 (+7.0%) |
| RegisterKeyCustodial | 622,032 | 646,970 (+4.0%) |
| SetTokenSpend | 548,449 | 580,505 (+5.8%) |
| SetCanCall | 508,681 | 529,203 (+4.0%) |
| UpdateKeyData | 485,299 | 507,962 (+4.7%) |
| UpdateTokenSpend | 481,900 | 521,581 (+8.2%) |
| RevokeKeySelf | 483,801 | 510,758 (+5.6%) |
| RemoveTokenSpend | 488,185 | 512,526 (+5.0%) |
| RemoveCanCall | 465,906 | 500,911 (+7.5%) |

### WebAuthn MasterKey Insights

- **Most Expensive Operations**: Key registration operations (565k-622k gas)
- **Least Expensive Operations**: Permission removal and updates (465k-508k gas)
- **ERC20 Paymaster Overhead**: Consistent 4-8% overhead (~25k-40k gas)
- **WebAuthn Overhead vs RootKey**: ~366k-444k gas additional cost

---

## Comparative Analysis

### Signature Type Comparison (AASponsored)

Comparing WebAuthn MasterKey vs RootKey signature costs:

| Operation | RootKey | WebAuthn | Overhead |
|-----------|---------|----------|----------|
| RegisterKeySelf | 198,751 | 565,397 | +184% (366,646 gas) |
| RegisterKeyCustodial | 249,779 | 622,032 | +149% (372,253 gas) |
| SetTokenSpend | 175,565 | 548,449 | +212% (372,884 gas) |
| SetCanCall | 129,810 | 508,681 | +292% (378,871 gas) |
| UpdateKeyData | 102,568 | 485,299 | +373% (382,731 gas) |
| UpdateTokenSpend | 116,859 | 481,900 | +312% (365,041 gas) |
| RevokeKey | 115,408 | 483,801 | +319% (368,393 gas) |
| RemoveTokenSpend | 109,201 | 488,185 | +347% (378,984 gas) |
| RemoveCanCall | 107,678 | 465,906 | +333% (358,228 gas) |

**Key Finding**: WebAuthn signature verification adds **~366k-383k gas** overhead for account management operations, representing **150-375%** increase over ECDSA.

### Paymaster Mode Overhead

#### RootKey Paymaster Overhead

| Operation | Direct→AASponsored | AASponsored→ERC20 |
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

| Operation | AASponsored→ERC20 |
|-----------|-------------------|
| RegisterKeySelf | +39,517 gas |
| RegisterKeyCustodial | +24,938 gas |
| SetTokenSpend | +32,056 gas |
| SetCanCall | +20,522 gas |
| UpdateKeyData | +22,663 gas |
| UpdateTokenSpend | +39,681 gas |
| RevokeKeySelf | +26,957 gas |
| RemoveTokenSpend | +24,341 gas |
| RemoveCanCall | +35,005 gas |

**Average**: ~29k gas for ERC20 paymaster (consistent with RootKey)

### Operation Type Analysis

#### Most Expensive Operations (AASponsored)

1. **RegisterKeyCustodial** (RootKey: 249,779 | WebAuthn: 622,032)
   - Requires additional storage for custodial relationship
   - Highest gas consumption in both key types

2. **RegisterKeySelf** (RootKey: 198,751 | WebAuthn: 565,397)
   - New key registration with storage writes
   - Second highest gas consumption

3. **SetTokenSpend** (RootKey: 175,565 | WebAuthn: 548,449)
   - Configure token spending permissions
   - Complex permission logic

#### Least Expensive Operations (AASponsored)

1. **UpdateKeyData** (RootKey: 102,568 | WebAuthn: 485,299)
   - Metadata update without permission changes
   - Lowest gas consumption

2. **RemoveCanCall** (RootKey: 107,678 | WebAuthn: 465,906)
   - Simple permission removal
   - Minimal storage changes

3. **RemoveTokenSpend** (RootKey: 109,201 | WebAuthn: 488,185)
   - Token permission removal
   - Low complexity operation

---

## Recommendations

### For RootKey Operations

1. **Direct Calls**: Use when possible for 70k+ gas savings vs AA
2. **Batch Operations**: Group multiple account actions in single transaction
3. **AA Benefits**: Use when gasless experience required despite overhead

### For WebAuthn MasterKey Operations

1. **Cost Consideration**: Account for ~370k additional gas vs ECDSA
2. **UX Priority**: WebAuthn provides superior UX (biometric auth, no seed phrases)
3. **Network Selection**: Deploy on L2s to reduce absolute costs
4. **Batch Operations**: Critical for amortizing WebAuthn overhead

### Operation-Specific Guidance

- **Key Registration**: Most expensive - plan gas budget accordingly
- **Permission Updates**: Relatively cheap - can be done frequently
- **Custodial Mode**: Adds 40-56k gas - evaluate trade-offs
- **ERC20 Paymaster**: Consistent ~29k overhead - acceptable for gasless UX

---

**Last Updated**: 2025-10-27
**Benchmark Version**: 1.0.0
**Measurement Method**: Foundry `vm.snapshotGasLastCall()` with warmed storage
