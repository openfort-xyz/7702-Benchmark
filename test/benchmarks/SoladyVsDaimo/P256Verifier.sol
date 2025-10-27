// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/// @notice P256 verifier contract.
/// @author Solady (https://github.com/vectorized/solady/blob/main/src/utils/P256.sol)
/// @author Modified from OpenZeppelin
/// (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/P256.sol)
/// @dev Optimized for a balance between runtime gas and bytecode size.
/// Returns `uint256(1)` on verification success.
/// Unlike RIP-7212, this verifier returns `uint256(0)` on failure instead of empty return data.
/// This contract will never revert.
/// About 168k gas per call.
/// For more details on the math, please refer to the comments in OpenZeppelin's implementation.
contract P256Verifier {
    uint256 private constant GX = 0x6B17D1F2E12C4247F8BCE6E563A440F277037D812DEB33A0F4A13945D898C296;
    uint256 private constant GY = 0x4FE342E2FE1A7F9B8EE7EB4A7C0F9E162BCE33576B315ECECBB6406837BF51F5;
    uint256 private constant P = 0xFFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF; // `A = P - 3`.
    uint256 private constant N = 0xFFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551;
    uint256 private constant B = 0x5AC635D8AA3A93E7B3EBBD55769886BC651D06B0CC53B0F63BCE3C3E27D2604B;

    fallback() external payable {
        assembly {
            // For this implementation, we will use the memory without caring about
            // the free memory pointer or zero pointer.
            // The slots `0x00`, `0x20`, `0x60`, will not be accessed for the `Points[16]` array,
            // and can be used for storing other variables.
            // The slot `0x40` will be the zeroth element of the `Points[16]` array, which will be zero.

            mstore(0x40, returndatasize())

            function setJPoint(i, x, y, z) {
                mstore(i, x)
                mstore(add(i, returndatasize()), y)
                mstore(add(i, 0x40), z)
            }

            function jPointDouble(x, y, z) -> rx, ry, rz {
                let p := P
                let yy := mulmod(y, y, p)
                let zz := mulmod(z, z, p)
                let s := mulmod(4, mulmod(x, yy, p), p)
                let m := addmod(mulmod(3, mulmod(x, x, p), p), mulmod(mload(returndatasize()), mulmod(zz, zz, p), p), p)
                rx := addmod(mulmod(m, m, p), sub(p, addmod(s, s, p)), p)
                ry := addmod(mulmod(m, addmod(s, sub(p, rx), p), p), sub(p, mulmod(8, mulmod(yy, yy, p), p)), p)
                rz := mulmod(2, mulmod(y, z, p), p)
            }

            function setJPointDouble(i, j) {
                let x := mload(j)
                let y := mload(add(j, returndatasize()))
                let z := mload(add(j, 0x40))
                let p := P
                let yy := mulmod(y, y, p)
                let zz := mulmod(z, z, p)
                let s := mulmod(4, mulmod(x, yy, p), p)
                let m := addmod(mulmod(3, mulmod(x, x, p), p), mulmod(mload(returndatasize()), mulmod(zz, zz, p), p), p)
                let x2 := addmod(mulmod(m, m, p), sub(p, addmod(s, s, p)), p)
                setJPoint(
                    i,
                    x2,
                    addmod(mulmod(m, addmod(s, sub(p, x2), p), p), sub(p, mulmod(8, mulmod(yy, yy, p), p)), p),
                    mulmod(2, mulmod(y, z, p), p)
                )
            }

            function setJPointAdd(i, j, k) {
                let x1 := mload(j)
                let y1 := mload(add(j, returndatasize()))
                let z1 := mload(add(j, 0x40))
                let x2 := mload(k)
                let y2 := mload(add(k, returndatasize()))
                let z2 := mload(add(k, 0x40))
                if iszero(z1) {
                    setJPoint(i, x2, y2, z2)
                    leave
                }
                if iszero(z2) {
                    setJPoint(i, x1, y1, z1)
                    leave
                }
                let p := P
                let zz1 := mulmod(z1, z1, p)
                let zz2 := mulmod(z2, z2, p)
                let u1 := mulmod(x1, zz2, p)
                let s1 := mulmod(y1, mulmod(zz2, z2, p), p)
                let h := addmod(mulmod(x2, zz1, p), sub(p, u1), p)
                let r := addmod(mulmod(y2, mulmod(zz1, z1, p), p), sub(p, s1), p)
                if iszero(r) {
                    if iszero(h) {
                        setJPointDouble(i, k)
                        leave
                    }
                }
                let hh := mulmod(h, h, p)
                let hhh := mulmod(h, hh, p)
                let v := mulmod(u1, hh, p)
                let x3 := addmod(addmod(mulmod(r, r, p), sub(p, hhh), p), sub(p, addmod(v, v, p)), p)
                setJPoint(
                    i,
                    x3,
                    addmod(mulmod(r, addmod(v, sub(p, x3), p), p), sub(p, mulmod(s1, hhh, p)), p),
                    mulmod(h, mulmod(z1, z2, p), p)
                )
            }

            let r := calldataload(0x20)
            let n := N
            let i := returndatasize()

            {
                let s := calldataload(0x40)
                if lt(shr(1, n), s) { s := sub(n, s) }

                // Perform `modExp(s, N - 2, N)`.
                // After which, we can abuse `returndatasize()` to get `0x20`.
                mstore(0x800, 0x20)
                mstore(0x820, 0x20)
                mstore(0x840, 0x20)
                mstore(0x860, s)
                mstore(0x880, sub(n, 2))
                mstore(0x8a0, n)

                let p := P
                mstore(0x20, xor(3, p)) // Set `0x20` to `A`.
                let Qx := calldataload(0x60)
                let Qy := calldataload(0x80)

                if iszero(
                    and( // The arguments of `and` are evaluated last to first.
                        and(
                            and(
                                and(gt(calldatasize(), 0x9f), and(lt(iszero(r), lt(r, n)), lt(iszero(s), lt(s, n)))),
                                and(lt(Qx, p), lt(Qy, p))
                            ),
                            eq(
                                mulmod(Qy, Qy, p),
                                addmod(mulmod(addmod(mulmod(Qx, Qx, p), mload(returndatasize()), p), Qx, p), B, p)
                            )
                        ),
                        and(
                            // We need to check that the `returndatasize` is indeed 32,
                            // so that we can return false if the chain does not have the modexp precompile.
                            eq(returndatasize(), 0x20),
                            staticcall(gas(), 0x05, 0x800, 0xc0, returndatasize(), 0x20)
                        )
                    )
                ) { return(0x80, 0x20) }

                // We will multiply by `0x80` (i.e. `shl(7, i)`) instead
                // since the memory expansion costs are cheaper than doing `mul(0x60, i)`.
                // Also help combine the lookup expression for `u1` and `u2` in `jMultShamir`.
                setJPoint(shl(7, 0x01), Qx, Qy, 1)
                setJPoint(shl(7, 0x04), GX, GY, 1)
                setJPointDouble(shl(7, 0x02), shl(7, 0x01))
                setJPointDouble(shl(7, 0x08), shl(7, 0x04))
                setJPointAdd(shl(7, 0x03), shl(7, 0x01), shl(7, 0x02))
                setJPointAdd(shl(7, 0x05), shl(7, 0x01), shl(7, 0x04))
                setJPointAdd(shl(7, 0x06), shl(7, 0x02), shl(7, 0x04))
                setJPointAdd(shl(7, 0x07), shl(7, 0x03), shl(7, 0x04))
                setJPointAdd(shl(7, 0x09), shl(7, 0x01), shl(7, 0x08))
                setJPointAdd(shl(7, 0x0a), shl(7, 0x02), shl(7, 0x08))
                setJPointAdd(shl(7, 0x0b), shl(7, 0x03), shl(7, 0x08))
                setJPointAdd(shl(7, 0x0c), shl(7, 0x04), shl(7, 0x08))
                setJPointAdd(shl(7, 0x0d), shl(7, 0x01), shl(7, 0x0c))
                setJPointAdd(shl(7, 0x0e), shl(7, 0x02), shl(7, 0x0c))
                setJPointAdd(shl(7, 0x0f), shl(7, 0x03), shl(7, 0x0c))
            }

            let u1 := mulmod(calldataload(i), mload(i), n)
            let u2 := mulmod(r, mload(i), n)
            let y := i
            let x := i
            let z := i
            let p := P
            let A := mload(returndatasize())
            for { } 1 { } {
                if z {
                    let yy := mulmod(y, y, p)
                    let zz := mulmod(z, z, p)
                    let s := mulmod(4, mulmod(x, yy, p), p)
                    let m := addmod(mulmod(3, mulmod(x, x, p), p), mulmod(A, mulmod(zz, zz, p), p), p)
                    let x2 := addmod(mulmod(m, m, p), sub(p, addmod(s, s, p)), p)
                    let y2 := addmod(mulmod(m, addmod(s, sub(p, x2), p), p), sub(p, mulmod(8, mulmod(yy, yy, p), p)), p)
                    let z2 := mulmod(2, mulmod(y, z, p), p)
                    yy := mulmod(y2, y2, p)
                    zz := mulmod(z2, z2, p)
                    s := mulmod(4, mulmod(x2, yy, p), p)
                    m := addmod(mulmod(3, mulmod(x2, x2, p), p), mulmod(A, mulmod(zz, zz, p), p), p)
                    x := addmod(mulmod(m, m, p), sub(p, addmod(s, s, p)), p)
                    z := mulmod(2, mulmod(y2, z2, p), p)
                    y := addmod(mulmod(m, addmod(s, sub(p, x), p), p), sub(p, mulmod(8, mulmod(yy, yy, p), p)), p)
                }
                for { let o := or(and(shr(245, shl(i, u1)), 0x600), and(shr(247, shl(i, u2)), 0x180)) } 1 { } {
                    let z2 := mload(add(o, 0x40))
                    if or(iszero(z), iszero(z2)) {
                        if iszero(z2) { break }
                        x := mload(o)
                        y := mload(add(o, returndatasize()))
                        z := z2
                        break
                    }
                    let zz1 := mulmod(z, z, p)
                    let zz2 := mulmod(z2, z2, p)
                    let u1_ := mulmod(x, zz2, p)
                    let s1 := mulmod(y, mulmod(zz2, z2, p), p)
                    let h := addmod(mulmod(mload(o), zz1, p), sub(p, u1_), p)
                    let r_ := addmod(mulmod(mload(add(o, returndatasize())), mulmod(zz1, z, p), p), sub(p, s1), p)
                    if iszero(r_) {
                        if iszero(h) {
                            x, y, z := jPointDouble(x, y, z)
                            break
                        }
                    }
                    let hh := mulmod(h, h, p)
                    let hhh := mulmod(h, hh, p)
                    let v := mulmod(u1_, hh, p)
                    x := addmod(addmod(mulmod(r_, r_, p), sub(p, hhh), p), sub(p, addmod(v, v, p)), p)
                    y := addmod(mulmod(r_, addmod(v, sub(p, x), p), p), sub(p, mulmod(s1, hhh, p)), p)
                    z := mulmod(h, mulmod(z, z2, p), p)
                    break
                }
                // Just unroll twice. Fully unrolling will only save around 1% to 2% gas, but make the
                // bytecode very bloated, which may incur more runtime costs after Verkle.
                // See: https://notes.ethereum.org/%40vbuterin/verkle_tree_eip
                // It's very unlikely that Verkle will come before the P256 precompile. But who knows?
                if z {
                    let yy := mulmod(y, y, p)
                    let zz := mulmod(z, z, p)
                    let s := mulmod(4, mulmod(x, yy, p), p)
                    let m := addmod(mulmod(3, mulmod(x, x, p), p), mulmod(A, mulmod(zz, zz, p), p), p)
                    let x2 := addmod(mulmod(m, m, p), sub(p, addmod(s, s, p)), p)
                    let y2 := addmod(mulmod(m, addmod(s, sub(p, x2), p), p), sub(p, mulmod(8, mulmod(yy, yy, p), p)), p)
                    let z2 := mulmod(2, mulmod(y, z, p), p)
                    yy := mulmod(y2, y2, p)
                    zz := mulmod(z2, z2, p)
                    s := mulmod(4, mulmod(x2, yy, p), p)
                    m := addmod(mulmod(3, mulmod(x2, x2, p), p), mulmod(A, mulmod(zz, zz, p), p), p)
                    x := addmod(mulmod(m, m, p), sub(p, addmod(s, s, p)), p)
                    z := mulmod(2, mulmod(y2, z2, p), p)
                    y := addmod(mulmod(m, addmod(s, sub(p, x), p), p), sub(p, mulmod(8, mulmod(yy, yy, p), p)), p)
                }
                for { let o := or(and(shr(243, shl(i, u1)), 0x600), and(shr(245, shl(i, u2)), 0x180)) } 1 { } {
                    let z2 := mload(add(o, 0x40))
                    if or(iszero(z), iszero(z2)) {
                        if iszero(z2) { break }
                        x := mload(o)
                        y := mload(add(o, returndatasize()))
                        z := z2
                        break
                    }
                    let zz1 := mulmod(z, z, p)
                    let zz2 := mulmod(z2, z2, p)
                    let u1_ := mulmod(x, zz2, p)
                    let s1 := mulmod(y, mulmod(zz2, z2, p), p)
                    let h := addmod(mulmod(mload(o), zz1, p), sub(p, u1_), p)
                    let r_ := addmod(mulmod(mload(add(o, returndatasize())), mulmod(zz1, z, p), p), sub(p, s1), p)
                    if iszero(r_) {
                        if iszero(h) {
                            x, y, z := jPointDouble(x, y, z)
                            break
                        }
                    }
                    let hh := mulmod(h, h, p)
                    let hhh := mulmod(h, hh, p)
                    let v := mulmod(u1_, hh, p)
                    x := addmod(addmod(mulmod(r_, r_, p), sub(p, hhh), p), sub(p, addmod(v, v, p)), p)
                    y := addmod(mulmod(r_, addmod(v, sub(p, x), p), p), sub(p, mulmod(s1, hhh, p)), p)
                    z := mulmod(h, mulmod(z, z2, p), p)
                    break
                }
                i := add(i, 4)
                if eq(i, 256) { break }
            }

            // Returns 0 if `z == 0` which indicates that the result is a point at infinity.
            if iszero(z) { return(0x40, returndatasize()) }

            // Perform `modExp(z, P - 2, P)`.
            // `0x800`, `0x820, `0x840` are still set to `0x20`.
            mstore(0x860, z)
            mstore(0x880, sub(p, 2))
            mstore(0x8a0, p)

            mstore(
                returndatasize(),
                and( // The arguments of `and` are evaluated last to first.
                    eq(mod(mulmod(x, mulmod(mload(returndatasize()), mload(returndatasize()), p), p), n), r),
                    staticcall(gas(), 0x05, 0x800, 0xc0, returndatasize(), returndatasize())
                )
            )
            return(returndatasize(), returndatasize())
        }
    }
}
