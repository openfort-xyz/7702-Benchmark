# Network Cost Analysis: EIP-7702 Operations

## Overview

A comprehensive cost analysis of EIP-7702 account operations across four major networks:
- **Ethereum** (L1)
- **Base** (OP Stack L2)
- **Polygon** (L1)
- **Optimism** (OP Stack L2)

All costs are calculated using real gas consumption from benchmarks and current network pricing data captured on **2025-10-27**.

---

## Price Report

**Snapshot Date**: 2025-10-27 10:04:31 UTC

### Gas Prices

| Network | L2 Gas Price | L1 Base Fee | Base Fee Scalar | Blob Base Fee | Blob Fee Scalar |
|---------|--------------|-------------|-----------------|---------------|-----------------|
| **Ethereum** | 0.131 gwei | - | - | - | - |
| **Base** | 0.0068 gwei | 141,605,330 wei | 2,269 | 1 wei | 1,055,762 |
| **Polygon** | 29.686 gwei | - | - | - | - |
| **Optimism** | 0.001 gwei | 132,148,960 wei | 5,227 | 1 wei | 1,014,213 |

### Token Prices

| Token | Price (USD) |
|-------|-------------|
| **ETH** | $4,160.44 |
| **MATIC** | $0.20 |

### Calculated L1 Data Fees (OP Stack)

Using the Ecotone formula with estimated UserOperation size of 500 bytes:

| Network | L1 Data Fee (wei) | L1 Data Fee (USD) |
|---------|-------------------|-------------------|
| **Base** | 2,185,319 | $0.00909 |
| **Optimism** | 4,694,010 | $0.01953 |

**Note**: L1 data fees are relatively constant per transaction and independent of execution complexity.

---

## Cost Tables by Operation Type

### 1. Empty Call Operations

**Operation**: `execute()` with empty calldata

| Configuration | Gas Used | Ethereum | Base | Polygon | Optimism |
|---------------|----------|----------|------|---------|----------|
| **RootKey Direct** | 31,679 | $0.01728 | $0.00990 | $0.00188 | $0.01966 |
| **RootKey ERC4337** | 92,983 | $0.05073 | $0.00963 | $0.00553 | $0.01992 |
| **RootKey ERC4337 Sponsored** | 104,059 | $0.05677 | $0.00970 | $0.00619 | $0.01996 |
| **RootKey ERC4337 Sponsored ERC20** | 132,743 | $0.07243 | $0.00994 | $0.00790 | $0.02008 |
| **EOA SessionKey ERC4337** | 103,835 | $0.05664 | $0.00970 | $0.00618 | $0.01996 |
| **EOA SessionKey ERC4337 Sponsored** | 114,899 | $0.06267 | $0.00977 | $0.00684 | $0.02001 |
| **EOA SessionKey ERC4337 Sponsored ERC20** | 143,595 | $0.07834 | $0.01001 | $0.00854 | $0.02013 |
| **P256 SessionKey ERC4337** | 247,075 | $0.13480 | $0.01085 | $0.01470 | $0.02098 |
| **P256 SessionKey ERC4337 Sponsored** | 258,151 | $0.14084 | $0.01093 | $0.01536 | $0.02103 |
| **P256 SessionKey ERC4337 Sponsored ERC20** | 286,835 | $0.15651 | $0.01116 | $0.01707 | $0.02115 |
| **WebAuthn SessionKey ERC4337** | 390,727 | $0.21317 | $0.01201 | $0.02325 | $0.02213 |
| **WebAuthn SessionKey ERC4337 Sponsored** | 401,803 | $0.21921 | $0.01209 | $0.02391 | $0.02218 |
| **WebAuthn SessionKey ERC4337 Sponsored ERC20** | 430,487 | $0.23488 | $0.01232 | $0.02562 | $0.02230 |
| **WebAuthn MasterKey ERC4337** | 390,083 | $0.21282 | $0.01201 | $0.02321 | $0.02213 |
| **WebAuthn MasterKey ERC4337 Sponsored** | 401,147 | $0.21885 | $0.01208 | $0.02387 | $0.02218 |
| **WebAuthn MasterKey ERC4337 Sponsored ERC20** | 429,843 | $0.23452 | $0.01231 | $0.02558 | $0.02229 |
| **EOA SessionKey Custodial ERC4337** | 107,691 | $0.05874 | $0.00973 | $0.00641 | $0.01998 |
| **P256 SessionKey Custodial ERC4337** | 250,931 | $0.13691 | $0.01088 | $0.01493 | $0.02100 |
| **WebAuthn SessionKey Custodial ERC4337** | 394,583 | $0.21528 | $0.01204 | $0.02348 | $0.02215 |

**Key Insights**:
- Polygon offers lowest costs for RootKey operations ($0.00188)
- Base provides consistent low costs with small L1 overhead ($0.009 base + execution)
- Ethereum costs scale linearly with signature complexity
- WebAuthn operations cost 7-12x more than RootKey on Ethereum

---

### 2. Native Transfer Operations

**Operation**: Transfer 0.1 ETH/MATIC to recipient

| Configuration | Gas Used | Ethereum | Base | Polygon | Optimism |
|---------------|----------|----------|------|---------|----------|
| **RootKey Direct** | 38,079 | $0.02077 | $0.00991 | $0.00227 | $0.01967 |
| **RootKey ERC4337** | 99,383 | $0.05422 | $0.00966 | $0.00591 | $0.01994 |
| **RootKey ERC4337 Sponsored** | 110,459 | $0.06026 | $0.00973 | $0.00657 | $0.01998 |
| **RootKey ERC4337 Sponsored ERC20** | 139,143 | $0.07593 | $0.00996 | $0.00828 | $0.02010 |
| **EOA SessionKey ERC4337** | 110,235 | $0.06014 | $0.00973 | $0.00656 | $0.01998 |
| **EOA SessionKey ERC4337 Sponsored** | 121,299 | $0.06617 | $0.00981 | $0.00722 | $0.02002 |
| **EOA SessionKey ERC4337 Sponsored ERC20** | 149,995 | $0.08184 | $0.01004 | $0.00892 | $0.02015 |
| **P256 SessionKey ERC4337** | 253,475 | $0.13829 | $0.01089 | $0.01508 | $0.02101 |
| **P256 SessionKey ERC4337 Sponsored** | 264,551 | $0.14434 | $0.01097 | $0.01574 | $0.02106 |
| **P256 SessionKey ERC4337 Sponsored ERC20** | 293,235 | $0.16001 | $0.01120 | $0.01745 | $0.02118 |
| **WebAuthn SessionKey ERC4337** | 397,127 | $0.21666 | $0.01205 | $0.02363 | $0.02216 |
| **WebAuthn SessionKey ERC4337 Sponsored** | 408,203 | $0.22270 | $0.01213 | $0.02429 | $0.02221 |
| **WebAuthn SessionKey ERC4337 Sponsored ERC20** | 436,887 | $0.23837 | $0.01236 | $0.02600 | $0.02233 |
| **WebAuthn MasterKey ERC4337** | 396,483 | $0.21631 | $0.01204 | $0.02359 | $0.02215 |
| **WebAuthn MasterKey ERC4337 Sponsored** | 407,547 | $0.22234 | $0.01212 | $0.02425 | $0.02220 |
| **WebAuthn MasterKey ERC4337 Sponsored ERC20** | 436,243 | $0.23801 | $0.01235 | $0.02596 | $0.02232 |
| **EOA SessionKey Custodial ERC4337** | 114,091 | $0.06224 | $0.00977 | $0.00679 | $0.02001 |
| **P256 SessionKey Custodial ERC4337** | 257,331 | $0.14040 | $0.01092 | $0.01531 | $0.02104 |
| **WebAuthn SessionKey Custodial ERC4337** | 400,983 | $0.21876 | $0.01208 | $0.02386 | $0.02218 |

**Key Insights**:
- Native transfers add ~6,400 gas vs empty calls
- Polygon remains most cost-effective for simple transfers
- Base costs remain stable due to fixed L1 overhead dominance
- Optimism L1 fee ($0.020) dominates total cost for all operations

---

### 3. ERC20 Transfer Operations

**Operation**: Transfer ERC20 tokens to recipient

| Configuration | Gas Used | Ethereum | Base | Polygon | Optimism |
|---------------|----------|----------|------|---------|----------|
| **RootKey Direct** | 61,379 | $0.03349 | $0.01007 | $0.00365 | $0.01978 |
| **RootKey ERC4337** | 122,683 | $0.06694 | $0.00981 | $0.00730 | $0.02006 |
| **RootKey ERC4337 Sponsored** | 133,759 | $0.07298 | $0.00989 | $0.00796 | $0.02011 |
| **RootKey ERC4337 Sponsored ERC20** | 162,443 | $0.08865 | $0.01012 | $0.00967 | $0.02022 |
| **EOA SessionKey ERC4337** | 133,535 | $0.07286 | $0.00988 | $0.00795 | $0.02010 |
| **EOA SessionKey ERC4337 Sponsored** | 144,599 | $0.07889 | $0.00995 | $0.00861 | $0.02015 |
| **EOA SessionKey ERC4337 Sponsored ERC20** | 173,295 | $0.09456 | $0.01019 | $0.01031 | $0.02027 |
| **P256 SessionKey ERC4337** | 276,775 | $0.15102 | $0.01105 | $0.01647 | $0.02120 |
| **P256 SessionKey ERC4337 Sponsored** | 287,851 | $0.15706 | $0.01113 | $0.01713 | $0.02125 |
| **P256 SessionKey ERC4337 Sponsored ERC20** | 316,535 | $0.17273 | $0.01136 | $0.01884 | $0.02137 |
| **WebAuthn SessionKey ERC4337** | 420,427 | $0.22938 | $0.01220 | $0.02502 | $0.02235 |
| **WebAuthn SessionKey ERC4337 Sponsored** | 431,503 | $0.23542 | $0.01228 | $0.02568 | $0.02239 |
| **WebAuthn SessionKey ERC4337 Sponsored ERC20** | 460,187 | $0.25109 | $0.01251 | $0.02739 | $0.02251 |
| **WebAuthn MasterKey ERC4337** | 419,783 | $0.22903 | $0.01220 | $0.02498 | $0.02234 |
| **WebAuthn MasterKey ERC4337 Sponsored** | 430,847 | $0.23507 | $0.01227 | $0.02564 | $0.02239 |
| **WebAuthn MasterKey ERC4337 Sponsored ERC20** | 459,543 | $0.25074 | $0.01250 | $0.02735 | $0.02251 |
| **EOA SessionKey Custodial ERC4337** | 137,391 | $0.07496 | $0.00992 | $0.00818 | $0.02013 |
| **P256 SessionKey Custodial ERC4337** | 280,631 | $0.15313 | $0.01108 | $0.01670 | $0.02123 |
| **WebAuthn SessionKey Custodial ERC4337** | 424,283 | $0.23148 | $0.01223 | $0.02525 | $0.02237 |

**Key Insights**:
- ERC20 transfers add ~23k gas overhead vs native transfers
- Polygon costs increase more than Ethereum due to higher base gas price
- Base execution fees remain minimal (~$0.001-0.002)
- L1 data fees on OP Stack chains dominate for low-gas operations

---

### 4. Batch Operations (10 Calls)

**Operation**: Execute 10 operations in a single UserOperation

| Configuration | Gas Used | Ethereum | Base | Polygon | Optimism |
|---------------|----------|----------|------|---------|----------|
| **RootKey Direct** | 92,579 | $0.05051 | $0.00963 | $0.00551 | $0.01992 |
| **RootKey ERC4337** | 153,883 | $0.08396 | $0.01013 | $0.00916 | $0.02027 |
| **RootKey ERC4337 Sponsored** | 164,959 | $0.09000 | $0.01020 | $0.00982 | $0.02032 |
| **RootKey ERC4337 Sponsored ERC20** | 193,643 | $0.10567 | $0.01043 | $0.01152 | $0.02044 |
| **EOA SessionKey ERC4337** | 164,735 | $0.08988 | $0.01020 | $0.00980 | $0.02032 |
| **EOA SessionKey ERC4337 Sponsored** | 175,799 | $0.09591 | $0.01028 | $0.01046 | $0.02036 |
| **EOA SessionKey ERC4337 Sponsored ERC20** | 204,495 | $0.11158 | $0.01051 | $0.01217 | $0.02048 |
| **P256 SessionKey ERC4337** | 308,075 | $0.16814 | $0.01126 | $0.01833 | $0.02147 |
| **P256 SessionKey ERC4337 Sponsored** | 319,151 | $0.17418 | $0.01134 | $0.01899 | $0.02152 |
| **P256 SessionKey ERC4337 Sponsored ERC20** | 347,835 | $0.18985 | $0.01157 | $0.02070 | $0.02164 |
| **WebAuthn SessionKey ERC4337** | 451,727 | $0.24650 | $0.01241 | $0.02688 | $0.02254 |
| **WebAuthn SessionKey ERC4337 Sponsored** | 462,803 | $0.25254 | $0.01249 | $0.02754 | $0.02259 |
| **WebAuthn SessionKey ERC4337 Sponsored ERC20** | 491,487 | $0.26821 | $0.01272 | $0.02925 | $0.02271 |
| **WebAuthn MasterKey ERC4337** | 451,083 | $0.24615 | $0.01241 | $0.02684 | $0.02254 |
| **WebAuthn MasterKey ERC4337 Sponsored** | 462,147 | $0.25219 | $0.01248 | $0.02750 | $0.02258 |
| **WebAuthn MasterKey ERC4337 Sponsored ERC20** | 490,843 | $0.26786 | $0.01271 | $0.02921 | $0.02270 |
| **EOA SessionKey Custodial ERC4337** | 168,591 | $0.09198 | $0.01024 | $0.01003 | $0.02034 |
| **P256 SessionKey Custodial ERC4337** | 311,931 | $0.17025 | $0.01129 | $0.01856 | $0.02150 |
| **WebAuthn SessionKey Custodial ERC4337** | 455,583 | $0.24861 | $0.01244 | $0.02711 | $0.02256 |

**Key Insights**:
- Batch operations show best per-call efficiency
- 10 calls cost ~3x single call (not 10x) - significant savings
- Polygon advantage grows with batch size due to low per-gas cost
- Optimism L1 fee remains constant, making batching highly attractive

---

### 5. UniswapV2 Swap Operations

**Operation**: Execute token swap via UniswapV2 router

| Configuration | Gas Used | Ethereum | Base | Polygon | Optimism |
|---------------|----------|----------|------|---------|----------|
| **RootKey Direct** | 137,479 | $0.07501 | $0.00992 | $0.00818 | $0.02013 |
| **RootKey ERC4337** | 198,783 | $0.10846 | $0.01044 | $0.01183 | $0.02046 |
| **RootKey ERC4337 Sponsored** | 209,859 | $0.11450 | $0.01052 | $0.01249 | $0.02051 |
| **RootKey ERC4337 Sponsored ERC20** | 238,543 | $0.13017 | $0.01075 | $0.01420 | $0.02063 |
| **EOA SessionKey ERC4337** | 209,635 | $0.11438 | $0.01051 | $0.01248 | $0.02051 |
| **EOA SessionKey ERC4337 Sponsored** | 220,699 | $0.12041 | $0.01059 | $0.01313 | $0.02055 |
| **EOA SessionKey ERC4337 Sponsored ERC20** | 249,395 | $0.13608 | $0.01082 | $0.01484 | $0.02067 |
| **P256 SessionKey ERC4337** | 352,975 | $0.19260 | $0.01168 | $0.02100 | $0.02166 |
| **P256 SessionKey ERC4337 Sponsored** | 364,051 | $0.19864 | $0.01176 | $0.02166 | $0.02171 |
| **P256 SessionKey ERC4337 Sponsored ERC20** | 392,735 | $0.21431 | $0.01199 | $0.02337 | $0.02183 |
| **WebAuthn SessionKey ERC4337** | 496,627 | $0.27098 | $0.01283 | $0.02955 | $0.02273 |
| **WebAuthn SessionKey ERC4337 Sponsored** | 507,703 | $0.27702 | $0.01291 | $0.03021 | $0.02278 |
| **WebAuthn SessionKey ERC4337 Sponsored ERC20** | 536,387 | $0.29269 | $0.01314 | $0.03192 | $0.02290 |
| **WebAuthn MasterKey ERC4337** | 495,983 | $0.27063 | $0.01282 | $0.02951 | $0.02272 |
| **WebAuthn MasterKey ERC4337 Sponsored** | 507,047 | $0.27666 | $0.01290 | $0.03017 | $0.02277 |
| **WebAuthn MasterKey ERC4337 Sponsored ERC20** | 535,743 | $0.29234 | $0.01313 | $0.03188 | $0.02289 |
| **EOA SessionKey Custodial ERC4337** | 213,491 | $0.11649 | $0.01055 | $0.01271 | $0.02053 |
| **P256 SessionKey Custodial ERC4337** | 356,831 | $0.19470 | $0.01171 | $0.02123 | $0.02169 |
| **WebAuthn SessionKey Custodial ERC4337** | 500,483 | $0.27309 | $0.01286 | $0.02978 | $0.02275 |

**Key Insights**:
- Complex DeFi operations show gas costs 3-5x higher than simple transfers
- Polygon provides 36x cost savings vs Ethereum for WebAuthn swaps
- Base total costs dominated by L1 fee (~70% of total for complex operations)
- Optimism L1 fee becomes smaller percentage as execution gas increases

---

### 6. Account Management Actions

**Operation**: Administrative account operations including key registration, permission management, and revocation.

#### RootKey Account Actions

| Operation | Mode | Gas Used | Ethereum | Base | Polygon | Optimism |
|-----------|------|----------|----------|------|---------|----------|
| **RegisterKeySelf** | Direct | 126,410 | $0.06894 | $0.00987 | $0.00751 | $0.02006 |
| **RegisterKeySelf** | ERC4337 Sponsored | 198,751 | $0.10844 | $0.01024 | $0.01182 | $0.02036 |
| **RegisterKeySelf** | ERC4337 Sponsored ERC20 | 227,458 | $0.12412 | $0.01050 | $0.01353 | $0.02048 |
| **RegisterKeyCustodial** | Direct | 177,450 | $0.09682 | $0.01014 | $0.01056 | $0.02027 |
| **RegisterKeyCustodial** | ERC4337 Sponsored | 249,779 | $0.13626 | $0.01063 | $0.01486 | $0.02056 |
| **RegisterKeyCustodial** | ERC4337 Sponsored ERC20 | 278,498 | $0.15194 | $0.01089 | $0.01657 | $0.02068 |
| **SetTokenSpend** | Direct | 103,434 | $0.05644 | $0.00978 | $0.00615 | $0.01998 |
| **SetTokenSpend** | ERC4337 Sponsored | 175,565 | $0.09581 | $0.01013 | $0.01045 | $0.02026 |
| **SetTokenSpend** | ERC4337 Sponsored ERC20 | 204,270 | $0.11147 | $0.01039 | $0.01215 | $0.02038 |
| **SetCanCall** | Direct | 57,667 | $0.03146 | $0.00998 | $0.00343 | $0.01977 |
| **SetCanCall** | ERC4337 Sponsored | 129,810 | $0.07082 | $0.00986 | $0.00772 | $0.02009 |
| **SetCanCall** | ERC4337 Sponsored ERC20 | 158,503 | $0.08648 | $0.01012 | $0.00943 | $0.02021 |
| **UpdateKeyData** | Direct | 30,500 | $0.01664 | $0.00990 | $0.00181 | $0.01966 |
| **UpdateKeyData** | ERC4337 Sponsored | 102,568 | $0.05597 | $0.00977 | $0.00610 | $0.01997 |
| **UpdateKeyData** | ERC4337 Sponsored ERC20 | 131,273 | $0.07163 | $0.01001 | $0.00781 | $0.02008 |
| **UpdateTokenSpend** | Direct | 44,716 | $0.02439 | $0.00994 | $0.00266 | $0.01972 |
| **UpdateTokenSpend** | ERC4337 Sponsored | 116,859 | $0.06377 | $0.00982 | $0.00695 | $0.02002 |
| **UpdateTokenSpend** | ERC4337 Sponsored ERC20 | 145,540 | $0.07941 | $0.01008 | $0.00866 | $0.02013 |
| **RevokeKey** | Direct | 45,854 | $0.02501 | $0.00995 | $0.00273 | $0.01972 |
| **RevokeKey** | ERC4337 Sponsored | 115,408 | $0.06298 | $0.00981 | $0.00687 | $0.02001 |
| **RevokeKey** | ERC4337 Sponsored ERC20 | 144,111 | $0.07863 | $0.01007 | $0.00858 | $0.02013 |
| **RemoveTokenSpend** | Direct | 41,230 | $0.02249 | $0.00992 | $0.00245 | $0.01970 |
| **RemoveTokenSpend** | ERC4337 Sponsored | 109,201 | $0.05959 | $0.00976 | $0.00650 | $0.01998 |
| **RemoveTokenSpend** | ERC4337 Sponsored ERC20 | 137,881 | $0.07523 | $0.01004 | $0.00821 | $0.02010 |
| **RemoveCanCall** | Direct | 35,547 | $0.01939 | $0.00991 | $0.00212 | $0.01968 |
| **RemoveCanCall** | ERC4337 Sponsored | 107,678 | $0.05876 | $0.00974 | $0.00641 | $0.01997 |
| **RemoveCanCall** | ERC4337 Sponsored ERC20 | 136,371 | $0.07441 | $0.01003 | $0.00812 | $0.02010 |

#### WebAuthn MasterKey Account Actions

| Operation | Mode | Gas Used | Ethereum | Base | Polygon | Optimism |
|-----------|------|----------|----------|------|---------|----------|
| **RegisterKeySelf** | ERC4337 Sponsored | 565,397 | $0.30850 | $0.01299 | $0.03363 | $0.02285 |
| **RegisterKeySelf** | ERC4337 Sponsored ERC20 | 604,914 | $0.33006 | $0.01325 | $0.03598 | $0.02302 |
| **RegisterKeyCustodial** | ERC4337 Sponsored | 622,032 | $0.33937 | $0.01335 | $0.03700 | $0.02314 |
| **RegisterKeyCustodial** | ERC4337 Sponsored ERC20 | 646,970 | $0.35298 | $0.01361 | $0.03848 | $0.02331 |
| **SetTokenSpend** | ERC4337 Sponsored | 548,449 | $0.29925 | $0.01291 | $0.03262 | $0.02277 |
| **SetTokenSpend** | ERC4337 Sponsored ERC20 | 580,505 | $0.31673 | $0.01317 | $0.03453 | $0.02294 |
| **SetCanCall** | ERC4337 Sponsored | 508,681 | $0.27754 | $0.01272 | $0.03026 | $0.02259 |
| **SetCanCall** | ERC4337 Sponsored ERC20 | 529,203 | $0.28873 | $0.01286 | $0.03148 | $0.02267 |
| **UpdateKeyData** | ERC4337 Sponsored | 485,299 | $0.26478 | $0.01259 | $0.02887 | $0.02250 |
| **UpdateKeyData** | ERC4337 Sponsored ERC20 | 507,962 | $0.27714 | $0.01273 | $0.03022 | $0.02258 |
| **UpdateTokenSpend** | ERC4337 Sponsored | 481,900 | $0.26292 | $0.01257 | $0.02867 | $0.02249 |
| **UpdateTokenSpend** | ERC4337 Sponsored ERC20 | 521,581 | $0.28455 | $0.01283 | $0.03103 | $0.02266 |
| **RevokeKeySelf** | ERC4337 Sponsored | 483,801 | $0.26396 | $0.01258 | $0.02878 | $0.02249 |
| **RevokeKeySelf** | ERC4337 Sponsored ERC20 | 510,758 | $0.27874 | $0.01275 | $0.03039 | $0.02259 |
| **RemoveTokenSpend** | ERC4337 Sponsored | 488,185 | $0.26635 | $0.01261 | $0.02904 | $0.02251 |
| **RemoveTokenSpend** | ERC4337 Sponsored ERC20 | 512,526 | $0.27970 | $0.01276 | $0.03049 | $0.02260 |
| **RemoveCanCall** | ERC4337 Sponsored | 465,906 | $0.25420 | $0.01251 | $0.02771 | $0.02242 |
| **RemoveCanCall** | ERC4337 Sponsored ERC20 | 500,911 | $0.27327 | $0.01270 | $0.02979 | $0.02256 |

**Key Insights**:
- **RootKey operations**: Most expensive are key registration (126k-278k gas), cheapest are permission removal (30k-158k gas)
- **WebAuthn MasterKey operations**: All operations range from 465k-647k gas, adding ~366k-444k gas overhead vs RootKey
- **Network costs**:
  - Ethereum: $0.017-$0.353 (highest)
  - Base: $0.010-$0.014 (most consistent, L1 fee dominates)
  - Polygon: $0.002-$0.038 (lowest for most operations)
  - Optimism: $0.020-$0.023 (L1 fee floor dominates)
- **Best network**: Polygon for infrequent admin operations, Base for frequent WebAuthn operations

---

### 7. Deployment and Initialization Operations

**Operation**: One-time setup costs for contract deployment and account initialization.

| Operation | Gas Used | Ethereum | Base | Polygon | Optimism |
|-----------|----------|----------|------|---------|----------|
| **Deploy OPFMain Contract** | 5,019,232 | $2.73647 | $0.15099 | $0.02980 | $0.04043 |
| **Initialize Account (without SessionKey)** | 289,959 | $0.15820 | $0.01730 | $0.00172 | $0.02074 |
| **Initialize Account (with SessionKey)** | 411,339 | $0.22442 | $0.02067 | $0.00244 | $0.02124 |
| **Total Setup (Deploy + Init w/ SessionKey)** | 5,430,571 | $2.96089 | $0.17166 | $0.03224 | $0.06167 |

**Key Insights**:
- **Contract Deployment**: One-time cost of ~$2.74 on Ethereum, $0.03 on Polygon, $0.04 on Optimism, $0.15 on Base
- **Account Initialization**: $0.16-0.22 on Ethereum, $0.017-0.021 on Base, $0.0017-0.0024 on Polygon
- **SessionKey Registration Overhead**: Adding SessionKey during initialization costs +121k gas (+41.9%)
- **Network comparisons**:
  - **Polygon**: Most cost-effective for deployment ($0.03 vs $2.74 on Ethereum = 98.9% savings)
  - **Base**: L1 data fee ($0.009) is negligible compared to large deployment gas cost
  - **Optimism**: L1 fee dominates for low-gas initialization but is minimal for deployment
  - **Total setup cost**: Polygon offers 91x cheaper total setup vs Ethereum

---

## Network Comparison Analysis

### Cost Rankings by Operation Type

#### Empty Calls (RootKey ERC4337)
1. **Polygon**: $0.00553 ✓ Cheapest
2. **Base**: $0.00963
3. **Optimism**: $0.01992
4. **Ethereum**: $0.05073 (9.2x more than Polygon)

#### Native Transfers (RootKey ERC4337)
1. **Polygon**: $0.00591 ✓ Cheapest
2. **Base**: $0.00966
3. **Optimism**: $0.01994
4. **Ethereum**: $0.05422 (9.2x more than Polygon)

#### ERC20 Transfers (RootKey ERC4337)
1. **Polygon**: $0.00730 ✓ Cheapest
2. **Base**: $0.00981
3. **Optimism**: $0.02006
4. **Ethereum**: $0.06694 (9.2x more than Polygon)

#### Batch Operations (RootKey ERC4337, 10 calls)
1. **Base**: $0.01013 ✓ Cheapest
2. **Polygon**: $0.00916
3. **Optimism**: $0.02027
4. **Ethereum**: $0.08396 (8.3x more than Polygon)

**Note**: Base becomes competitive for batch operations as L1 fee is amortized across more execution gas.

#### UniswapV2 Swaps (RootKey ERC4337)
1. **Polygon**: $0.01183 ✓ Cheapest
2. **Base**: $0.01044
3. **Optimism**: $0.02046
4. **Ethereum**: $0.10846 (9.2x more than Polygon)

#### WebAuthn Operations (SessionKey ERC4337, Empty Call)
1. **Polygon**: $0.02325 ✓ Cheapest
2. **Base**: $0.01201
3. **Optimism**: $0.02213
4. **Ethereum**: $0.21317 (9.2x more than Polygon)

#### Account Management - RootKey (RegisterKeySelf Direct)
1. **Polygon**: $0.00751 ✓ Cheapest
2. **Base**: $0.00987
3. **Optimism**: $0.02006
4. **Ethereum**: $0.06894 (9.2x more than Polygon)

#### Account Management - WebAuthn MasterKey (RegisterKeySelf ERC4337 Sponsored)
1. **Base**: $0.01299 ✓ Cheapest
2. **Optimism**: $0.02285
3. **Polygon**: $0.03363
4. **Ethereum**: $0.30850 (23.7x more than Base)

**Note**: For high-gas WebAuthn operations, Base's fixed L1 fee makes it most cost-effective despite Polygon's lower gas price.

#### Deployment and Initialization (Deploy OPFMain Contract)
1. **Polygon**: $0.02980 ✓ Cheapest
2. **Optimism**: $0.04043
3. **Base**: $0.15099
4. **Ethereum**: $2.73647 (91.8x more than Polygon)

#### Initialization Only (with SessionKey)
1. **Polygon**: $0.00244 ✓ Cheapest
2. **Base**: $0.02067
3. **Optimism**: $0.02124
4. **Ethereum**: $0.22442 (92.0x more than Polygon)

**Note**: For very high-gas operations like contract deployment (5M gas), Polygon's low per-gas cost dramatically outperforms L2s despite their fixed L1 fees.

### Cost Efficiency Ratios

**Ethereum as baseline (1.00x):**

| Operation Type | Ethereum | Base | Polygon | Optimism |
|----------------|----------|------|---------|----------|
| Empty Call | 1.00x | 0.19x | 0.11x | 0.39x |
| Native Transfer | 1.00x | 0.18x | 0.11x | 0.37x |
| ERC20 Transfer | 1.00x | 0.15x | 0.11x | 0.30x |
| Batch (10 calls) | 1.00x | 0.12x | 0.11x | 0.24x |
| UniswapV2 Swap | 1.00x | 0.10x | 0.11x | 0.19x |
| WebAuthn Empty | 1.00x | 0.06x | 0.11x | 0.10x |
| RootKey Account Mgmt | 1.00x | 0.14x | 0.11x | 0.29x |
| WebAuthn Account Mgmt | 1.00x | 0.04x | 0.11x | 0.07x |
| Contract Deployment | 1.00x | 0.06x | 0.01x | 0.01x |
| Account Initialization | 1.00x | 0.09x | 0.01x | 0.09x |

**Key Findings**:
- **Polygon** consistently offers ~1-11% of Ethereum costs (9-100x cheaper) across all operations
- **Base** ranges from 4-19% of Ethereum costs, excels for high-gas WebAuthn operations
- **Optimism** ranges from 1-39% of Ethereum costs
- L2s show greatest advantage for high-gas operations where L1 data fee is proportionally smaller
- **Contract deployment**: Polygon offers 99% cost savings vs Ethereum (92x cheaper)
- **WebAuthn account management**: Base offers 96% cost savings vs Ethereum (25x cheaper)