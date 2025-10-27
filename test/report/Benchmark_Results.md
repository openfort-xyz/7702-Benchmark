## Benchmark Results

### Empty Operations

Empty `execute()` calls - baseline overhead measurement.

| Key Type | Direct | ERC4337 | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
|----------|--------|----------|-------------|------------------|
| **RootKey** | 31,679 | 92,983 (+193.5%) | 104,059 (+11.9%) | 132,743 (+27.6%) |
| **EOA SessionKey** | - | 124,418 | 135,508 (+8.9%) | 164,196 (+21.2%) |
| **EOA SessionKey (Custodial)** | - | 139,929 | 151,528 (+8.3%) | 180,235 (+18.9%) |
| **P256 SessionKey** | - | 305,262 | 312,839 (+2.5%) | 344,581 (+10.1%) |
| **P256 SessionKey (Custodial)** | - | 320,786 | 328,872 (+2.5%) | 360,632 (+9.7%) |
| **WebAuthn SessionKey** | - | 499,969 | 507,889 (+1.6%) | 536,285 (+5.6%) |
| **WebAuthn SessionKey (Custodial)** | - | 515,583 | 524,012 (+1.6%) | 552,445 (+5.4%) |
| **WebAuthn MasterKey** | - | 469,222 | 477,142 (+1.7%) | 505,524 (+5.9%) |

### Native Transfers

Transfer 0.1 ETH to recipient.

| Key Type | Direct | ERC4337 | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
|----------|--------|----------|-------------|------------------|
| **RootKey** | 38,451 | 99,767 (+159.5%) | 110,843 (+11.1%) | 139,515 (+25.9%) |
| **EOA SessionKey** | - | 140,030 | 151,120 (+7.9%) | 179,796 (+19.0%) |
| **EOA SessionKey (Custodial)** | - | 155,541 | 167,140 (+7.5%) | 195,835 (+17.2%) |
| **P256 SessionKey** | - | 357,314 | 368,407 (+3.1%) | 397,959 (+8.0%) |
| **P256 SessionKey (Custodial)** | - | 372,838 | 384,440 (+3.1%) | 414,010 (+7.7%) |
| **WebAuthn SessionKey** | - | 551,261 | 563,916 (+2.3%) | 589,663 (+4.6%) |
| **WebAuthn SessionKey (Custodial)** | - | 566,875 | 580,039 (+2.3%) | 605,806 (+4.4%) |
| **WebAuthn MasterKey** | - | 474,358 | 487,013 (+2.7%) | 512,739 (+5.3%) |

### ERC20 Transfers

Transfer ERC20 tokens to recipient.

| Key Type | Direct | ERC4337 | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
|----------|--------|----------|-------------|------------------|
| **RootKey** | 45,275 | 106,677 (+135.6%) | 117,775 (+10.4%) | 139,183 (+18.2%) |
| **EOA SessionKey** | - | 147,640 | 158,752 (+7.5%) | 180,164 (+13.5%) |
| **EOA SessionKey (Custodial)** | - | 163,151 | 174,772 (+7.1%) | 196,203 (+12.3%) |
| **P256 SessionKey** | - | 362,295 | 375,162 (+3.6%) | 397,888 (+6.1%) |
| **P256 SessionKey (Custodial)** | - | 377,819 | 391,195 (+3.5%) | 413,940 (+5.8%) |
| **WebAuthn SessionKey** | - | 557,968 | 567,508 (+1.7%) | 600,911 (+5.9%) |
| **WebAuthn SessionKey (Custodial)** | - | 573,582 | 583,632 (+1.8%) | 617,054 (+5.7%) |
| **WebAuthn MasterKey** | - | 480,365 | 489,905 (+2.0%) | 523,287 (+6.8%) |

### Batch Operations (10 Calls)

Execute 10 empty calls in single transaction.

| Key Type | Direct | ERC4337 | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
|----------|--------|----------|-------------|------------------|
| **RootKey** | 102,673 | 165,855 (+61.5%) | 178,034 (+7.3%) | 199,499 (+12.1%) |
| **EOA SessionKey** | - | 281,105 | 293,310 (+4.3%) | 314,743 (+7.3%) |
| **EOA SessionKey (Custodial)** | - | 296,789 | 309,487 (+4.3%) | 330,929 (+6.9%) |
| **P256 SessionKey** | - | 501,058 | 512,390 (+2.3%) | 534,711 (+4.4%) |
| **P256 SessionKey (Custodial)** | - | 516,753 | 528,578 (+2.3%) | 550,908 (+4.2%) |
| **WebAuthn SessionKey** | - | 697,369 | 722,135 (+3.6%) | 728,266 (+0.8%) |
| **WebAuthn SessionKey (Custodial)** | - | 713,106 | 738,375 (+3.5%) | 744,505 (+0.8%) |
| **WebAuthn MasterKey** | - | 543,671 | 568,443 (+4.6%) | 574,466 (+1.1%) |

### UniswapV2 Swaps

Token swap via UniswapV2 router.

| Key Type | Direct | ERC4337 | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
|----------|--------|----------|-------------|------------------|
| **RootKey** | 101,032 | 162,568 (+60.9%) | 173,758 (+6.9%) | 202,469 (+16.5%) |
| **EOA SessionKey** | - | 194,813 | 206,016 (+5.8%) | 234,730 (+13.9%) |
| **EOA SessionKey (Custodial)** | - | 210,324 | 222,036 (+5.6%) | 250,769 (+12.9%) |
| **P256 SessionKey** | - | 375,208 | 387,728 (+3.3%) | 415,128 (+7.1%) |
| **P256 SessionKey (Custodial)** | - | 390,731 | 403,760 (+3.3%) | 431,179 (+6.8%) |
| **WebAuthn SessionKey** | - | 568,488 | 577,015 (+1.5%) | 607,852 (+5.3%) |
| **WebAuthn SessionKey (Custodial)** | - | 584,101 | 593,138 (+1.5%) | 623,994 (+5.2%) |
| **WebAuthn MasterKey** | - | 536,930 | 545,457 (+1.6%) | 576,274 (+5.6%) |

### Account Management Actions

#### RootKey Operations
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

#### WebAuthn MasterKey Operations
| Action | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
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

### Deployment and Initialization

One-time operations for account setup and contract deployment.

| Operation | Gas Used | Description |
|-----------|----------|-------------|
| **Deploy OPFMain Contract** | 5,019,232 | Deploy the OPFMain implementation contract (one-time) |
| **Initialize Account (without SessionKey)** | 289,959 | Initialize account with MasterKey only |
| **Initialize Account (with SessionKey)** | 411,339 (+41.9%) | Initialize account with MasterKey and SessionKey |

**Key Insights**:
- **Contract Deployment**: One-time cost of ~5M gas for OPFMain implementation
- **Account Initialization**: 290k-411k gas depending on whether SessionKey is registered
- **SessionKey Registration Overhead**: +121k gas (+41.9%) to register SessionKey during initialization
- **Total Setup Cost** (deploy + initialize): 5.3M-5.4M gas for first account, then 290k-411k for each additional account

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

### Paymaster Mode Overhead

Comparing paymaster modes (RootKey, empty):

| Mode | Gas Cost | vs Direct | vs ERC4337 |
|------|----------|-----------|-------------|
| Direct | 31,679 | Baseline | - |
| ERC4337 | 92,983 | +194% | Baseline |
| ERC4337 Sponsored | 104,059 | +229% | +12% |
| ERC4337 Sponsored ERC20 | 132,743 | +319% | +43% |

**Overhead Breakdown**:
- **EntryPoint**: ~61k gas
- **Native paymaster**: ~11k gas
- **ERC20 paymaster**: ~29k gas additional

### Batch Operation Efficiency

Gas per operation when batching (RootKey AASponsored):

| Operation | Total Gas | Per-Call Cost | vs Single |
|-----------|-----------|---------------|-----------|
| Single Call | 104,059 | 104,059 | Baseline |
| Batch (10 calls) | 178,034 | 17,803 | **83% savings** |

**Recommendation**: Always batch when possible for 5-10x efficiency.

---