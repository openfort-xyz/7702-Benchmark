## Benchmark Results

### Empty Operations

Empty `execute()` calls - baseline overhead measurement.

| Key Type | Direct | ERC4337 | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
|----------|--------|----------|-------------|------------------|
| **RootKey** | 31,679 | 92,983 | 104,059 | 132,743 |
| **EOA SessionKey** | - | 124,418 | 135,508 | 164,196 |
| **EOA SessionKey (Custodial)** | - | 139,929 | 151,528 | 180,235 |
| **P256 SessionKey** | - | 305,262 | 312,839 | 344,581 |
| **P256 SessionKey (Custodial)** | - | 320,786 | 328,872 | 360,632 |
| **WebAuthn SessionKey** | - | 499,969 | 507,889 | 536,285 |
| **WebAuthn SessionKey (Custodial)** | - | 515,583 | 524,012 | 552,445 |
| **WebAuthn MasterKey** | - | 469,222 | 477,142 | 505,524 |

### Native Transfers

Transfer 0.1 ETH to recipient.

| Key Type | Direct | ERC4337 | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
|----------|--------|----------|-------------|------------------|
| **RootKey** | 38,451 | 99,767 | 110,843 | 139,515 |
| **EOA SessionKey** | - | 140,030 | 151,120 | 179,796 |
| **EOA SessionKey (Custodial)** | - | 155,541 | 167,140 | 195,835 |
| **P256 SessionKey** | - | 357,314 | 368,407 | 397,959 |
| **P256 SessionKey (Custodial)** | - | 372,838 | 384,440 | 414,010 |
| **WebAuthn SessionKey** | - | 551,261 | 563,916 | 589,663 |
| **WebAuthn SessionKey (Custodial)** | - | 566,875 | 580,039 | 605,806 |
| **WebAuthn MasterKey** | - | 474,358 | 487,013 | 512,739 |

### ERC20 Transfers

Transfer ERC20 tokens to recipient.

| Key Type | Direct | ERC4337 | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
|----------|--------|----------|-------------|------------------|
| **RootKey** | 45,275 | 106,677 | 117,775 | 139,183 |
| **EOA SessionKey** | - | 147,640 | 158,752 | 180,164 |
| **EOA SessionKey (Custodial)** | - | 163,151 | 174,772 | 196,203 |
| **P256 SessionKey** | - | 362,295 | 375,162 | 397,888 |
| **P256 SessionKey (Custodial)** | - | 377,819 | 391,195 | 413,940 |
| **WebAuthn SessionKey** | - | 557,968 | 567,508 | 600,911 |
| **WebAuthn SessionKey (Custodial)** | - | 573,582 | 583,632 | 617,054 |
| **WebAuthn MasterKey** | - | 480,365 | 489,905 | 523,287 |

### Batch Operations (10 Calls)

Execute 10 empty calls in single transaction.

| Key Type | Direct | ERC4337 | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
|----------|--------|----------|-------------|------------------|
| **RootKey** | 102,673 | 165,855 | 178,034 | 199,499 |
| **EOA SessionKey** | - | 281,105 | 293,310 | 314,743 |
| **EOA SessionKey (Custodial)** | - | 296,789 | 309,487 | 330,929 |
| **P256 SessionKey** | - | 501,058 | 512,390 | 534,711 |
| **P256 SessionKey (Custodial)** | - | 516,753 | 528,578 | 550,908 |
| **WebAuthn SessionKey** | - | 697,369 | 722,135 | 728,266 |
| **WebAuthn SessionKey (Custodial)** | - | 713,106 | 738,375 | 744,505 |
| **WebAuthn MasterKey** | - | 543,671 | 568,443 | 574,466 |

### UniswapV2 Swaps

Token swap via UniswapV2 router.

| Key Type | Direct | ERC4337 | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
|----------|--------|----------|-------------|------------------|
| **RootKey** | 101,032 | 162,568 | 173,758 | 202,469 |
| **EOA SessionKey** | - | 194,813 | 206,016 | 234,730 |
| **EOA SessionKey (Custodial)** | - | 210,324 | 222,036 | 250,769 |
| **P256 SessionKey** | - | 375,208 | 387,728 | 415,128 |
| **P256 SessionKey (Custodial)** | - | 390,731 | 403,760 | 431,179 |
| **WebAuthn SessionKey** | - | 568,488 | 577,015 | 607,852 |
| **WebAuthn SessionKey (Custodial)** | - | 584,101 | 593,138 | 623,994 |
| **WebAuthn MasterKey** | - | 536,930 | 545,457 | 576,274 |

### Account Management Actions

#### RootKey Operations
| Action | Direct | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
|--------|--------|-------------|------------------|
| RegisterKeySelf | 126,410 | 198,751 | 227,458 |
| RegisterKeyCustodial | 177,450 | 249,779 | 278,498 |
| SetTokenSpend | 103,434 | 175,565 | 204,270 |
| SetCanCall | 57,667 | 129,810 | 158,503 |
| UpdateKeyData | 30,500 | 102,568 | 131,273 |
| UpdateTokenSpend | 44,716 | 116,859 | 145,540 |
| RevokeKey | 45,854 | 115,408 | 144,111 |
| RemoveTokenSpend | 41,230 | 109,201 | 137,881 |
| RemoveCanCall | 35,547 | 107,678 | 136,371 |

#### WebAuthn MasterKey Operations
| Action | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
|--------|-------------|------------------|
| RegisterKeySelf | 565,397 | 604,914 |
| RegisterKeyCustodial | 622,032 | 646,970 |
| SetTokenSpend | 548,449 | 580,505 |
| SetCanCall | 508,681 | 529,203 |
| UpdateKeyData | 485,299 | 507,962 |
| UpdateTokenSpend | 481,900 | 521,581 |
| RevokeKeySelf | 483,801 | 510,758 |
| RemoveTokenSpend | 488,185 | 512,526 |
| RemoveCanCall | 465,906 | 500,911 |

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