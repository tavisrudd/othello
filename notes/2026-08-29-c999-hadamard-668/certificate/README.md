# C999 certificate bundle — twelve decoded Hadamard matrices

Date: 2026-08-29. Lane: `gem-mining`.

One `H<n>.json` per order, produced by the `had668` crate in `../verify/`. Each record carries
the order, the SHA-256 of the source file and of both canonical text forms, the exact
`max |(H Hᵀ)_ij|` over `i ≠ j`, the row-sum multiset, the full classification test ledger, and
the automorphism result.

## Replay

```bash
cd notes/2026-08-29-c999-hadamard-668
CARGO_TARGET_DIR=~/.cache/c999-target cargo build --release --manifest-path verify/Cargo.toml
~/.cache/c999-target/release/had668 certify evidence/H*.txt \
    --outdir certificate --workdir /tmp/persistent/tavis/c999-work
sha256sum certificate/H*.json evidence/H*.txt > certificate/SHA256SUMS
```

`--with-aut --traces --aut-timeout 900` adds the automorphism group; see the caveat below.
`sha256sum -c certificate/SHA256SUMS` checks the bundle, run from the `2026-08-29-c999-hadamard-668`
directory.

## Result

All twelve files are genuine Hadamard matrices: `max |(H Hᵀ)_ij| = 0` for `i ≠ j`, checked in
exact `i64` arithmetic, and every entry is `±1`. The SHA-256 of each source file matches the
table in `../README.md` written by the decoding work, so the two accounts are of the same bytes.

| order | structure | block order | sub-block | PAF sum | block row sums | shift automorphism |
|---:|---|---:|---:|---:|---|---:|
| 668  | bordered GS, border 4  | 166 | circulant | −4 | 2, 0, 0, 0     | 83 (order 2) |
| 716  | bordered GS, border 4  | 178 | circulant | −4 | 2, 0, 0, 0     | 89 (order 2) |
| 892  | GS                     | 223 | circulant |  0 | 11, 11, 11, 23 | none (order 1) |
| 1132 | GS                     | 283 | circulant |  0 | 19, 19, 19, 7  | none (order 1) |
| 1244 | GS                     | 311 | circulant |  0 | 21, 19, 21, 1  | none (order 1) |
| 1388 | bordered GS, border 20 | 342 | 6 × 57    | —  | —              | none (order 1) |
| 1436 | bordered GS, border 28 | 352 | 32 × 11   | —  | —              | none (order 1) |
| 1676 | bordered GS, border 4  | 418 | circulant | −4 | 2, 0, 0, 0     | 209 (order 2) |
| 1772 | bordered GS, border 4  | 442 | circulant | −4 | 2, 0, 0, 0     | 221 (order 2) |
| 1916 | bordered GS, border 12 | 476 | 4 × 119   | —  | —              | none (order 1) |
| 1948 | GS                     | 487 | circulant |  0 | 17, 1, 17, 37  | none (order 1) |
| 1964 | GS                     | 491 | circulant |  0 | 29, 27, 15, 13 | none (order 1) |

"GS" is the Goethals–Seidel array. The three orders with sub-blocks use a *generalized*
transpose rather than the matrix transpose, and their blocks are block-circulant super-blocks
rather than circulants, so the sequence-level columns do not apply to them.

Every structural claim above was recovered from the matrix entries by `classify`, independently
of the decoder's account of the script. The block orders, border widths and sub-block counts
agree with that account in all twelve cases.

### The sequence conditions hold exactly

For the five unbordered orders the four circulant first rows satisfy `Σᵢ PAF_i(s) = 0` at every
nonzero shift, and `Σᵢ (row sum_i)² = n`. Both are exactly the conditions the Goethals–Seidel
array needs. For the four bordered orders with circulant blocks the corresponding identities are
`Σᵢ PAF_i(s) = −4` and `Σᵢ (row sum_i)² = 4`, again exactly. These were computed from the
decoded entries and were not assumed.

### Automorphisms

`shift_automorphisms` in the classification record is an exact, solver-free result. For each
shift `s` it forms the permuted matrix "fix the border, rotate each of the four blocks by `s`"
and asks whether the pair is realised by a monomial automorphism `P H Q = H`. Dephasing is a
complete invariant for the row/column sign group — the dephased form is
`Y_ij = X_00 X_i0 X_0j X_ij`, independent of any choice — so equality of dephasings is necessary
and sufficient. A listed shift is therefore a **proved** automorphism and an omitted one is
**proved** not to be.

The pattern is forced, not accidental. In the Goethals–Seidel array the diagonal blocks are
circulant, which forces row shift = column shift, while the off-diagonal blocks are
back-circulant, which forces row shift = −column shift. A common shift `s` therefore needs
`2s ≡ 0 (mod m)`: for even `m` the half-shift `m/2` is the unique possibility, and for odd `m`
no nonzero shift can work. The four even block orders (166, 178, 418, 442) each realise exactly
their half-shift; the five odd ones (223, 283, 311, 487, 491) realise nothing. This gives
`|Aut(graph)| ≥ 4` for those four orders, counting the central swap.

The three super-block orders were searched twice, once rotating whole super-blocks and once
rotating inside each sub-block. Both come back empty, and the same parity rule explains why:
their sub-block lengths 57, 11 and 119 are all odd.

### The full automorphism group

`|Aut(H668)| = 4`, and the Hadamard automorphism group modulo the central swap has order 2.

Getting there needed a real vertex invariant. The 4n-vertex graph is regular, so nauty's
refinement never splits a cell unaided; dense nauty made no progress in 20 minutes with or
without the `twopaths`, `adjtriang` and `cellquads` invariants, and Traces ran its full 900 s
budget without getting past its first level. The reason is structural, and it is worth stating
because it says which invariant can possibly work:

- **pairs** are useless: `#{c : H_ic = H_jc} = n/2` for every pair, by orthogonality;
- **triples** are useless too: `indicator(x=y=z) = (1 + xy + xz + yz)/4`, so
  `#{c : H_ic = H_jc = H_kc} = n/4` for *every* triple, again by orthogonality;
- **odd-order products are not even invariants**: under a column sign flip `eps_c`, a product of
  three entries picks up `eps_c^3 = eps_c`, so `|sum_c H_ic H_jc H_kc|` is not preserved by the
  monomial group at all;
- **quadruples** are the first level that both is invariant and varies:
  `indicator(all four equal) = (1 + xy+xz+xw+yz+yw+zw + xyzw)/8`, so the count is
  `(n + J)/8` with `J(i,j,k,l) = sum_c H_ic H_jc H_kc H_lc`.

Colouring each row by the multiset `{ |J(i,j,k,l)| : j<k<l }` (and each column likewise on the
transpose) splits the 668 rows into **336 classes: 4 singletons and 332 pairs**, and the columns
identically. The 4 singletons are the border rows; the 332 pairs are exactly the orbits of the
half-shift. In bit terms `J = n - 2*popcount(b_i ^ b_j ^ b_k ^ b_l)`, so the whole computation is
`C(668,4) = 8.2e9` XOR-popcounts, 28 s on 16 cores at 100 MB. With that colouring dense nauty
finishes in about 4 s.

| order | \|Aut(graph)\| | mod centre | generators | orbit sizes |
|---:|---:|---:|---:|---|
| 668 | 4 | 2 | central swap; shift by 83 | 8 × 2, 664 × 4 |
| 716 | 4 | 2 | central swap; shift by 89 | 8 × 2, 712 × 4 |
| 892 | 6 | 3 | central swap; an order-3 element | 8 × 2, 592 × 6 |

For 668 the group is exactly the central swap times the half-shift — order 4, nothing more. The
two generators nauty returns are precisely the two elements already proved by hand above, so the
solver adds only the upper bound: there is nothing else.

**Independent confirmation.** bliss 0.73 was given the same graph and the same colouring in
DIMACS format and returned `|Aut| = 4` in 0.30 s, with the same two generators. Two
independent symmetry solvers therefore agree, and one of the two generators is independently
proved by the dephasing argument with no solver at all.

**A surprise at order 892.** Its group has order 6, not 2: there is an element of order 3 fixing
four rows and four columns (one position in each of the four circulant blocks). It is *not* in
either family the exact search covers — neither a common block shift nor a common block
multiplier `i -> t*i` — so it must combine a map on positions with a permutation of the four
blocks. The exact searches remain a proved lower bound; here the solver found more than they
cover, which is exactly what a lower bound is for.

## Relation to the C736–C741 Legendre-pair census

**Order 668 here is outside the census route.** Those tasks study Legendre pairs of length 333
with fixed common multipliers, which would give a Hadamard matrix of order 668 as a *bordered
two-circulant* `[A B; Bᵀ −Aᵀ]` with a 2-row border and two circulants of order 333. The decoded
H668 is a *bordered Goethals–Seidel array* with a 4-row border and four circulants of order 166.
`classify` tests the Legendre-pair form explicitly and it does not fire: the order-334 and
order-333 candidate blocks are not circulant, in the matrix as given or after dephasing.

Three consequences:

1. No census exclusion is contradicted. IDs 2, 7, 9 and 10 were excluded in C736, C738 and C740;
   nothing here bears on them.
2. No census survivor is realised. IDs 0, 1, 3, 4 and 5 remain exactly as open as before.
3. **The existence question for a Legendre pair of length 333 is still open.** Order 668 is now
   settled by a construction that never passes through LP(333), so the external resolution of the
   order does not resolve the pair. Any residual value in the census line is now in the Legendre
   pair itself, not in the Hadamard order it would have implied.

## Independent replay

The orthogonality of all twelve files was checked independently by the decoding work with numpy,
using the snippet recorded in `../README.md` under "Replay"; it reported
`max |H Hᵀ − nI| = 0` for all twelve on 2026-08-29. The check in this bundle is a separate
implementation: exact `i64` accumulation in Rust over all `i < k` row pairs, reached through a
different parser and a different arithmetic path, and it agrees. Two independent implementations
therefore certify the same twelve files.

There is no Lean formalization of any of this and none is claimed. The trusted boundary is
`i64` integer arithmetic in Rust, numpy's `int32` matrix product in the cross-check, and — for
the automorphism statements only — the argument recorded above, which is elementary and needs no
solver. `sha256sum -c SHA256SUMS` ties every number in this bundle to specific bytes.
