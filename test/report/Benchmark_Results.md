## Benchmark Results

### Empty Operations

Empty `execute()` calls - baseline overhead measurement.

| Key Type | Direct | ERC4337 | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
|----------|--------|----------|-------------|------------------|
| **RootKey** | 31,679 | 92,995 (+193.5%) | 104,083 (+11.9%) | 132,755 (+27.5%) |
| **WebAuthn MasterKey** | - | 281,888 | 293,898 (+4.3%) | 323,601 (+10.1%) |
| **EOA SessionKey** | - | 124,430 | 135,508 (+8.9%) | 164,184 (+21.1%) |
| **EOA SessionKey (Custodial)** | - | 139,941 | 151,528 (+8.3%) | 180,223 (+18.9%) |
| **WebAuthn SessionKey** | - | 316,628 | 329,085 (+3.9%) | 350,660 (+6.6%) |
| **WebAuthn SessionKey (Custodial)** | - | 332,259 | 345,226 (+3.9%) | 366,803 (+6.2%) |
| **P256 SessionKey** | - | 304,406 | 313,124 (+2.9%) | 345,087 (+10.2%) |
| **P256 SessionKey (Custodial)** | - | 319,930 | 329,157 (+2.9%) | 361,138 (+9.7%) |

### Native Transfers

Transfer 0.1 ETH to recipient.

| Key Type | Direct | ERC4337 | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
|----------|--------|----------|-------------|------------------|
| **RootKey** | 38,451 | 99,755 (+159.4%) | 110,855 (+11.1%) | 139,539 (+25.9%) |
| **WebAuthn MasterKey** | - | 290,850 | 300,658 (+3.4%) | 329,706 (+9.7%) |
| **EOA SessionKey** | - | 140,030 | 151,132 (+7.9%) | 179,808 (+19.0%) |
| **EOA SessionKey (Custodial)** | - | 155,541 | 167,152 (+7.5%) | 195,847 (+17.2%) |
| **WebAuthn SessionKey** | - | 367,753 | 378,071 (+2.8%) | 407,968 (+7.9%) |
| **WebAuthn SessionKey (Custodial)** | - | 383,367 | 394,212 (+2.8%) | 424,111 (+7.6%) |
| **P256 SessionKey** | - | 357,784 | 368,463 (+3.0%) | 395,399 (+7.3%) |
| **P256 SessionKey (Custodial)** | - | 373,308 | 384,496 (+3.0%) | 411,450 (+7.0%) |

### ERC20 Transfers

Transfer ERC20 tokens to recipient.

| Key Type | Direct | ERC4337 | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
|----------|--------|----------|-------------|------------------|
| **RootKey** | 45,275 | 106,677 (+135.6%) | 117,787 (+10.4%) | 139,195 (+18.2%) |
| **WebAuthn MasterKey** | - | 296,884 | 308,916 (+4.1%) | 329,824 (+6.8%) |
| **EOA SessionKey** | - | 147,628 | 158,764 (+7.5%) | 180,176 (+13.5%) |
| **EOA SessionKey (Custodial)** | - | 163,139 | 174,784 (+7.1%) | 196,215 (+12.3%) |
| **WebAuthn SessionKey** | - | 377,164 | 385,205 (+2.1%) | 409,698 (+6.4%) |
| **WebAuthn SessionKey (Custodial)** | - | 392,797 | 401,329 (+2.2%) | 425,860 (+6.1%) |
| **P256 SessionKey** | - | 364,955 | 376,970 (+3.3%) | 395,304 (+4.9%) |
| **P256 SessionKey (Custodial)** | - | 380,479 | 393,003 (+3.3%) | 411,356 (+4.7%) |

### Batch Operations (10 Calls)

Execute 10 empty calls in single transaction.

| Key Type | Direct | ERC4337 | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
|----------|--------|----------|-------------|------------------|
| **RootKey** | 102,673 | 165,855 (+61.5%) | 178,058 (+7.4%) | 199,511 (+12.0%) |
| **WebAuthn MasterKey** | - | 355,629 | 369,203 (+3.8%) | 390,152 (+5.7%) |
| **EOA SessionKey** | - | 281,105 | 293,334 (+4.3%) | 314,779 (+7.3%) |
| **EOA SessionKey (Custodial)** | - | 296,789 | 309,511 (+4.3%) | 330,965 (+6.9%) |
| **WebAuthn SessionKey** | - | 512,884 | 523,777 (+2.1%) | 543,872 (+3.8%) |
| **WebAuthn SessionKey (Custodial)** | - | 528,631 | 540,007 (+2.2%) | 560,111 (+3.7%) |
| **P256 SessionKey** | - | 500,664 | 509,609 (+1.8%) | 531,263 (+4.2%) |
| **P256 SessionKey (Custodial)** | - | 516,359 | 525,797 (+1.8%) | 547,460 (+4.1%) |

### UniswapV2 Swaps

Token swap via UniswapV2 router.

| Key Type | Direct | ERC4337 | ERC4337 Sponsored | ERC4337 Sponsored ERC20 |
|----------|--------|----------|-------------|------------------|
| **RootKey** | 101,032 | 162,568 (+60.9%) | 173,758 (+6.9%) | 202,469 (+16.5%) |
| **WebAuthn MasterKey** | - | 355,404 | 367,606 (+3.4%) | 390,494 (+6.2%) |
| **EOA SessionKey** | - | 194,813 | 206,016 (+5.8%) | 234,730 (+13.9%) |
| **EOA SessionKey (Custodial)** | - | 210,324 | 222,036 (+5.6%) | 250,769 (+12.9%) |
| **WebAuthn SessionKey** | - | 385,648 | 396,941 (+2.9%) | 426,014 (+7.3%) |
| **WebAuthn SessionKey (Custodial)** | - | 401,261 | 413,084 (+2.9%) | 442,156 (+7.0%) |
| **P256 SessionKey** | - | 374,364 | 383,854 (+2.5%) | 414,734 (+8.0%) |
| **P256 SessionKey (Custodial)** | - | 389,887 | 399,886 (+2.6%) | 430,785 (+7.7%) |

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
| RegisterKeySelf | 389,880 | 417,637 (+7.1%) |
| RegisterKeyCustodial | 440,056 | 468,030 (+6.4%) |
| SetTokenSpend | 367,581 | 395,349 (+7.5%) |
| SetCanCall | 320,500 | 349,570 (+9.1%) |
| UpdateKeyData | 293,270 | 322,364 (+9.9%) |
| UpdateTokenSpend | 309,703 | 335,743 (+8.4%) |
| RevokeKeySelf | 307,412 | 333,864 (+8.6%) |
| RemoveTokenSpend | 304,338 | 331,207 (+8.8%) |
| RemoveCanCall | 300,120 | 327,945 (+9.3%) |

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
| ECDSA (RootKey) | 104,083 | Baseline |
| WebAuthn (MasterKey) | 293,898 | +182% |
| ECDSA (EOA SessionKey) | 135,508 | +30% |
| WebAuthn (SessionKey) | 329,085 | +216% |
| P256 (SessionKey) | 313,124 | +201% |

**Insight**: P256 signature verification adds ~209k gas overhead. WebAuthn adds ~190k-225k gas overhead - a significant improvement over previous implementations due to optimizations.

### Custodial Overhead

Comparing self-custody vs third-party custody (AASponsored, empty):

| Key Type | Self-Custody | Third-Party | Overhead |
|----------|--------------|-------------|----------|
| EOA SessionKey | 135,508 | 151,528 | +12% (16,020 gas) |
| WebAuthn SessionKey | 329,085 | 345,226 | +5% (16,141 gas) |
| P256 SessionKey | 313,124 | 329,157 | +5% (16,033 gas) |

**Insight**: Custodial overhead is consistent (~16k gas) across signature types.

### Paymaster Mode Overhead

Comparing paymaster modes (RootKey, empty):

| Mode | Gas Cost | vs Direct | vs ERC4337 |
|------|----------|-----------|-------------|
| Direct | 31,679 | Baseline | - |
| ERC4337 | 92,995 | +194% | Baseline |
| ERC4337 Sponsored | 104,083 | +229% | +12% |
| ERC4337 Sponsored ERC20 | 132,755 | +319% | +43% |

**Overhead Breakdown**:
- **EntryPoint**: ~61k gas
- **Native paymaster**: ~11k gas
- **ERC20 paymaster**: ~29k gas additional

### Batch Operation Efficiency

Gas per operation when batching (RootKey AASponsored):

| Operation | Total Gas | Per-Call Cost | vs Single |
|-----------|-----------|---------------|-----------|
| Single Call | 104,083 | 104,083 | Baseline |
| Batch (10 calls) | 178,058 | 17,806 | **83% savings** |

**Recommendation**: Always batch when possible for 5-10x efficiency.

---