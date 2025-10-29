# CoinbaseSmartWallet Benchmark Requirements

**Date Created:** 2025-10-29
**Project:** 7702-Benchmark - CoinbaseSmartWallet Standardization
**Purpose:** Document requirements, decisions, and implementation notes for CoinbaseSmartWallet benchmark refactoring

---

## Task Overview

Refactor `test/benchmarks/OtherAccounts/benchmarks/CoinbaseSmartWallet.t.sol` to match the RootKey benchmark design pattern while maintaining compatibility with Coinbase Smart Wallet's ERC-4337 V0.6 architecture.

---

## Requirements

### User Requirements
1. **Keep ERC-4337 V0.6** - Use `UserOperation` struct (not `PackedUserOperation` from V0.7)
2. **Single File Structure** - Keep all tests in one file (no split like RootKey)
3. **ERC-4337 Only** - No Direct execution tests (Coinbase is ERC-4337 native)
4. **Batch Pattern** - Change from "10 accounts × 1 call" to "1 account × 10 calls" (match RootKey)
5. **RootKey Naming** - Use pattern: `test_Operation_CoinbaseSmartWallet_PaymentMode()`
6. **Skip Empty Test** - No empty operation test (not relevant for Coinbase)
7. **Two Payment Modes** - Support only SELF_ETH and SELF_ERC20 (remove APP_SPONSOR)

### Reference Pattern (RootKey Benchmarks)
- File: `test/benchmarks/RootKey/BenchmarksRootKey*.t.sol`
- Structure: Separate file per operation, comprehensive warming, standardized naming
- Key difference: RootKey uses ERC-4337 V0.7 with `PackedUserOperation`

---

## Design Decisions

### 1. EntryPoint Version
**Decision:** Keep ERC-4337 V0.6 (UserOperation)
**Rationale:** Coinbase Smart Wallet currently supports V0.6 EntryPoint. Upgrading would require infrastructure changes beyond benchmark scope.

### 2. File Structure
**Decision:** Keep single file `CoinbaseSmartWallet.t.sol`
**Rationale:** Easier maintenance for third-party account benchmarks. RootKey's multi-file approach is for primary account types.

### 3. Batch Operations
**Decision:** 1 account with 10 calls via `executeBatch()`
**Implementation:**
```solidity
// OLD: 10 accounts × 1 call each
_createCoinbaseSmartWallet(10); // Creates 10 accounts
// handleOps([userOp1, userOp2, ..., userOp10])

// NEW: 1 account × 10 calls
_createCoinbaseSmartWallet(1); // Creates 1 account
Call[] memory calls = _getCalls(10, target, value, data);
bytes memory payload = abi.encodeWithSignature("executeBatch((address,uint256,bytes)[])", calls);
// handleOps([userOpWithBatch])
```

**Rationale:** Matches RootKey pattern, tests actual batch execution efficiency in single account.

### 4. Payment Modes
**Decision:** SELF_ETH and SELF_ERC20 only (remove APP_SPONSOR)
**Rationale:** Focus on self-pay scenarios that are most common. APP_SPONSOR adds complexity without additional benchmark value.

### 5. Direct Execution Tests
**Decision:** No Direct execution tests
**Rationale:** Coinbase Smart Wallet is ERC-4337 native, doesn't support direct `account.execute()` calls without EntryPoint.

### 6. Empty Operation Test
**Decision:** Skip Empty test
**Rationale:** Not relevant for Coinbase Smart Wallet benchmarking. Focus on practical operations (ERC20, Native, Uniswap, Batch).

---

## Implementation Details

### Test Naming Convention

**Pattern:** `test_Send{Operation}_{AccountType}_{PaymentMode}()`

**Examples:**
- `test_SendERC20Transfer_CoinbaseSmartWallet_DirectAA()` - ERC20 + SELF_ETH
- `test_SendERC20Transfer_CoinbaseSmartWallet_DirectAAERC20()` - ERC20 + SELF_ERC20
- `test_SendERC20Transfer_Batch10_CoinbaseSmartWallet_DirectAA()` - Batch ERC20 + SELF_ETH

**Suffix Meanings:**
- `DirectAA` = ERC-4337 with SELF_ETH payment
- `DirectAAERC20` = ERC-4337 with SELF_ERC20 payment (via Pimlico paymaster)

### Operation Types

1. **ERC20 Transfer** - Transfer 1 ether of payment token to 0xbabe
2. **Native Transfer** - Transfer 1 ether ETH to 0xbabe
3. **UniswapV2 Swap** - Swap tokens via Uniswap V2 router
4. **Batch Operations** - Execute 10 operations in single UserOp

### Batch Operation Structure

Using Coinbase's `executeBatch((address,uint256,bytes)[])` function:

```solidity
// Create Call array with 10 identical operations
Call[] memory calls = _getCalls(
    10,                      // 10 calls
    paymentToken,            // target address
    0,                       // value (0 for ERC20)
    abi.encodeWithSignature("transfer(address,uint256)", address(0xbabe), 1 ether)
);

// Encode for Coinbase's executeBatch
bytes memory payload = abi.encodeWithSignature(
    "executeBatch((address,uint256,bytes)[])",
    calls
);

// Create single Coinbase account
(address[] memory accounts, address[] memory eoas, uint256[] memory privateKeys) =
    _createCoinbaseSmartWallet(1); // ← Only 1 account!

// Execute batch via ERC-4337
UserOperation[] memory u = _getPayload_CoinbaseSmartWallet(
    payload, "", accounts, eoas, privateKeys, PaymentType.SELF_ETH
);

vm.startPrank(relayer);
erc4337EntryPointV6.handleOps(u, payable(relayer));
vm.snapshotGasLastCall("test_SendERC20Transfer_Batch10_CoinbaseSmartWallet_DirectAA");
```

### Warming Strategy

Improved `_warmUp()` function matches RootKey pattern:
1. Warm SELF_ETH payment mode
2. Warm SELF_ERC20 payment mode
3. Warm batch operations
4. Ensures consistent warm storage for accurate measurements

---

## Test Structure

### Final Test Suite (8 tests total)

**ERC20 Transfers:**
1. `test_SendERC20Transfer_CoinbaseSmartWallet_DirectAA()` - Single ERC20 + SELF_ETH
2. `test_SendERC20Transfer_CoinbaseSmartWallet_DirectAAERC20()` - Single ERC20 + SELF_ERC20
3. `test_SendERC20Transfer_Batch10_CoinbaseSmartWallet_DirectAA()` - Batch ERC20 + SELF_ETH
4. `test_SendERC20Transfer_Batch10_CoinbaseSmartWallet_DirectAAERC20()` - Batch ERC20 + SELF_ERC20

**Native Transfers:**
5. `test_SendNativeTransfer_CoinbaseSmartWallet_DirectAA()` - Single Native + SELF_ETH
6. `test_SendNativeTransfer_CoinbaseSmartWallet_DirectAAERC20()` - Single Native + SELF_ERC20

**UniswapV2 Swaps:**
7. `test_SendUniswapV2Swap_CoinbaseSmartWallet_DirectAA()` - Uniswap + SELF_ETH
8. `test_SendUniswapV2Swap_CoinbaseSmartWallet_DirectAAERC20()` - Uniswap + SELF_ERC20

---

## Changes Made

### 1. Test Naming Updates
- ✅ Renamed all test functions to match RootKey pattern
- ✅ Used `test_Send*` prefix with operation name
- ✅ Added `DirectAA` and `DirectAAERC20` suffixes for payment modes

### 2. Removed Tests
- ❌ `testERC20Transfer_CoinbaseSmartWallet_AppSponsor()`
- ❌ `testERC20Transfer_Batch10_CoinbaseSmartWallet_AppSponsor()`

### 3. Batch Refactoring
- ✅ Changed from 10 accounts to 1 account
- ✅ Added `executeBatch` encoding with `Call[]` array
- ✅ Fixed naming bugs: "Batch100" → "Batch10"
- ✅ Updated assertions to expect 11 ether (1 from warmup + 10 from batch)

### 4. New Tests Added
- ✅ `test_SendNativeTransfer_CoinbaseSmartWallet_DirectAAERC20()` - Native with ERC20 payment
- ✅ `test_SendUniswapV2Swap_CoinbaseSmartWallet_DirectAAERC20()` - Uniswap with ERC20 payment
- ✅ Batch variants for Native and UniswapV2 operations

### 5. Warmup Improvements
- ✅ Enhanced `_warmUp()` to warm multiple payment modes
- ✅ Added batch warmup operations
- ✅ Added comments explaining warming purpose

---

## Deviations from RootKey Pattern

### Intentional Deviations
1. **EntryPoint Version** - V0.6 (UserOperation) vs V0.7 (PackedUserOperation)
2. **File Structure** - Single file vs multiple files per operation
3. **No Direct Execution** - Only ERC-4337 flow (no `account.execute()` direct calls)
4. **No Empty Test** - Skipped as not relevant for Coinbase
5. **Fewer Payment Modes** - 2 modes (SELF_ETH, SELF_ERC20) vs 4 modes in RootKey

### Maintained Patterns
- ✅ Test naming convention with underscores
- ✅ Batch operations: 1 account × 10 calls
- ✅ Warming strategy before measurements
- ✅ Gas measurement on `entryPoint.handleOps()`
- ✅ Consistent operation types (ERC20, Native, Uniswap, Batch)

---

## Technical Notes

### Call Struct
Reused from `test/helpers/ExecutionHelper.t.sol`:
```solidity
struct Call {
    address target;
    uint256 value;
    bytes data;
}
```

This struct is **identical** to Coinbase Smart Wallet's expected format.

### Helper Functions Used
- `_getCalls(count, target, value, data)` - Creates Call array
- `_createCoinbaseSmartWallet(count)` - Creates Coinbase accounts
- `_getPayload_CoinbaseSmartWallet(...)` - Constructs UserOperation
- `_giveAccountSomeTokens(account)` - Funds account
- `_eoaSig(privateKey, hash)` - Creates EOA signature

### EntryPoint V0.6 vs V0.7 Differences

**V0.6 (Current):**
```solidity
struct UserOperation {
    address sender;
    uint256 nonce;
    bytes callData;
    uint256 callGasLimit;
    uint256 verificationGasLimit;
    uint256 preVerificationGas;
    uint256 maxFeePerGas;
    uint256 maxPriorityFeePerGas;
    bytes paymasterAndData;
    bytes signature;
}
```

**V0.7 (RootKey):**
```solidity
struct PackedUserOperation {
    address sender;
    uint256 nonce;
    bytes callData;
    bytes32 accountGasLimits;  // ← Packed
    uint256 preVerificationGas;
    bytes32 gasFees;            // ← Packed
    bytes paymasterAndData;
    bytes signature;
}
```

Main difference: V0.7 packs gas limits and fees into bytes32 for efficiency.

---

## Gas Snapshot Names

Updated to match RootKey pattern:
- `test_SendERC20Transfer_CoinbaseSmartWallet_DirectAA`
- `test_SendERC20Transfer_CoinbaseSmartWallet_DirectAAERC20`
- `test_SendERC20Transfer_Batch10_CoinbaseSmartWallet_DirectAA`
- `test_SendERC20Transfer_Batch10_CoinbaseSmartWallet_DirectAAERC20`
- `test_SendNativeTransfer_CoinbaseSmartWallet_DirectAA`
- `test_SendNativeTransfer_CoinbaseSmartWallet_DirectAAERC20`
- `test_SendUniswapV2Swap_CoinbaseSmartWallet_DirectAA`
- `test_SendUniswapV2Swap_CoinbaseSmartWallet_DirectAAERC20`

---

## Success Criteria

- ✅ All tests compile successfully
- ✅ All tests pass with correct assertions
- ✅ Batch tests measure 1 account executing 10 calls (not 10 accounts)
- ✅ Test naming matches RootKey pattern
- ✅ Only SELF_ETH and SELF_ERC20 payment modes
- ✅ Gas snapshots generate with correct names
- ✅ Code follows existing helper patterns
- ✅ Documentation complete in Requirements.md

---

## Future Improvements

1. **Upgrade to V0.7** - When Coinbase Smart Wallet supports EntryPoint V0.7
2. **Add More Operations** - Deploy contract, upgrade account, etc.
3. **Cross-Account Comparison** - Compare Coinbase vs RootKey vs other account types
4. **Paymaster Variations** - Test different paymaster configurations

---

## References

### Codebase References
- **RootKey Benchmarks:** `test/benchmarks/RootKey/`
- **Helper Contracts:** `test/helpers/ExecutionHelper.t.sol`
- **Coinbase Interface:** `test/benchmarks/OtherAccounts/interfaces/ICoinbaseSmartWallet.sol`
- **Pimlico Paymaster:** `test/benchmarks/OtherAccounts/interfaces/IPimlicoPaymaster.sol`

### External References
- **ERC-4337:** https://eips.ethereum.org/EIPS/eip-4337
- **Coinbase Smart Wallet:** https://github.com/coinbase/smart-wallet
- **EntryPoint V0.6:** https://github.com/eth-infinitism/account-abstraction/tree/v0.6.0
- **EntryPoint V0.7:** https://github.com/eth-infinitism/account-abstraction/tree/v0.7.0

---

**END OF REQUIREMENTS DOCUMENTATION**
