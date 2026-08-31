# C1018 — Landing the sharpened PRS deep-hole conjecture

**Lane:** `gem-mining`
**Date:** 2026-08-31
**Status:** in progress (written incrementally)

Predecessor report: `notes/2026-08-30-c1018-hunt-prs-deepholes.md` (authority on
setup, conventions, prior art, and every cell run before today).  Notation,
`PRS_k(q)`, the NRC rank `w(s)`, the persistent locus `P_r`, the apolar/Hankel
criterion, and the carrier strata are all defined there and are not restated.

## 0. Plan for this wave

1. **Re-baseline** the driver against the new Ergodis core (`SmallField`,
   `ProjectiveIndex`, `GeneratorClosureWorkspace`, `Matrix::null_space_with`),
   reproducing the committed R5/R6/R7 certificate cells and the `(9,13)`
   falsifying witness bit-for-bit, and resolving the GF(16) field-labelling
   hazard now that both sides can be pinned to one core field model.
2. **Close the three out-of-budget redundancy-nine census cells**
   `r=9, q ∈ {16,17,19}` by streaming the census instead of materialising a
   per-point weight array.
3. **Run the discriminating cell `m = 5` at `r = 13`** (carrier `{1,6,11}`),
   which separates "odd `m`" from "`m = 3`" in the stabilizer ladder and is the
   odd/cubic discriminator for Conjectures D′ and E′.
4. **Close the redundancy-eight threshold band** `X(8) ∩ [23,42]`
   (`q = 23,25,27,29,31,32,37,41`).
5. **State the landed conjecture** with exact verified domain, exact unverified
   boundary, and falsifiers.

## 1. What the new Ergodis core supplies, and what the driver now uses

The 2026-08-30 report's §6 listed five interface gaps.  Reading the core as it
stands today (`papers/complete-repair-ports/ergodis`, commits `adefc99dc`,
`55f02c341`, `62fcd5f28`, `163a4ea26`), **all five have landed**:

| §6 gap | What landed | Where |
|---|---|---|
| 1. no general `GF(p^h)` | `SmallField`: runtime `(characteristic, degree)`, flat add/sub/mul/inverse tables, `from_modulus` for a pinned model | `src/field.rs` |
| 2. no kernel / null-space API | `Matrix::null_space`, `null_space_field`, `null_space_with` | `src/matrix.rs` |
| 3. `const P: u8` forces macro dispatch | `SmallField` is a value type; `Matrix::new_with_field` / `canonical_row_basis_with` take `&SmallField` | `src/field.rs`, `src/matrix.rs` |
| 4. no generic `PG(d,q)` indexing | `ProjectiveIndex::new(field, d)` with `index` / `point` / `point_owned` / `point_count`, leading-one normal form | `src/projective.rs` |
| 5. no orbit closure over an indexed point set | `compile_generator_closure`, `GeneratorClosure`, `GeneratorClosureWorkspace` | `src/group_action.rs` |

The 2026-08-30 driver `ergodis-private/src/bin/c1018_prs_deephole.rs` has since
been ported onto `SmallField`, `ProjectiveIndex` and `GeneratorClosureWorkspace`
and its local table-driven field is gone.  Nothing in the core was modified by
this task; the core builds clean, so the `BOUND_PULSE_COUNT_MASK` breakage in
`css_distance.rs` reported on 2026-08-30 is resolved.

**The GF(2^h) field-labelling hazard is now closed by construction.**  The
hazard (2026-08-30 §5.4, mystery-ledger item 9) was that two programs choosing
different irreducible moduli give the same coordinate tuple different meanings,
so representative-level comparisons are not model-free.  Both drivers now take
their field from `SmallField::new(p, h)`, which pins the lexicographically first
monic irreducible in polynomial-basis encoding, and both emit it as
`defining_poly` in their JSON.  The emitted moduli are `x^3+x+1` for `GF(8)`,
`x^2+1` for `GF(9)`, `x^4+x+1` for `GF(16)` — identical to the 2026-08-30
driver's own runtime search, which is why every reproduced cell below is
bit-for-bit rather than only aggregate-for-aggregate.  Any future cross-check
must read `defining_poly` and rebuild the same model via
`SmallField::from_modulus`; only aggregate counts are model-free.

## 2. Re-baseline against the new core (item 1)

Every cell rerun with the ported `c1018_prs_deephole` and compared against the
2026-08-30 tables, which in turn were compared against the committed R5/R6/R7
certificates.

| `r` | `q` | `N = \|PG(r-1,q)\|` | `ρ` | deep | `PGL_2` orbits | modulus | vs 2026-08-30 |
|----:|----:|------------------:|----:|-----:|---------------:|---|---|
| 5 | 7  | 2,801     | 4 | 889    | 10  | `x` (prime) | ✓ |
| 5 | 8  | 4,681     | 4 | 1,116  | 7   | `x^3+x+1` | ✓ |
| 5 | 9  | 7,381     | 4 | 1,391  | 8   | `x^2+1` | ✓ |
| 5 | 11 | 16,105    | 4 | 1,848  | 7   | prime | ✓ |
| 5 | 13 | 30,941    | 4 | 2,080  | 6   | prime | ✓ |
| 5 | 16 | 69,905    | 4 | 2,432  | 4   | `x^4+x+1` | ✓ |
| 6 | 7  | 19,608    | 5 | 5,376  | 20  | prime | ✓ |
| 6 | 8  | 37,449    | 5 | 5,037  | 13  | `x^3+x+1` | ✓ |
| 6 | 9  | 66,430    | 5 | 2,250  | 8   | `x^2+1` | ✓ |
| 6 | 11 | 177,156   | 5 | 1,584  | 4   | prime | ✓ |
| 6 | 13 | 402,234   | 5 | 1,820  | 3   | prime | ✓ |
| 7 | 7  | 137,257   | 6 | 55,860 | 197 | prime | ✓ |
| 7 | 8  | 299,593   | **7** | 10 | 2   | `x^3+x+1` | ✓ |
| 7 | 9  | 597,871   | 6 | 28,350 | 58  | `x^2+1` | ✓ |
| 7 | 11 | 1,948,717 | 6 | 3,080  | 10  | prime | ✓ |
| 7 | 13 | 5,229,043 | 6 | 1,274  | 3   | prime | ✓ |
| 8 | 8  | 2,396,745   | 7 | 865,080 | 1,734 | `x^3+x+1` | ✓ |
| 8 | 9  | 5,380,840   | 7 | 523,028 | 751   | `x^2+1` | ✓ |
| 8 | 11 | 21,435,888  | 7 | 3,696   | 5     | prime | ✓ |
| 8 | 13 | 67,977,560  | 7 | 1,274   | 5     | prime | ✓ |

All twenty cells reproduce exactly.  The `(9,13)` falsifying witness reproduces
representative-for-representative, not merely count-for-count: the four
`PGL_2(13)`-orbits of deep syndromes in `PG(8,13)` come back as

```text
size 182  rep (1,0,1,3,10,7,5,9,6)   apolar degree 2, kernel dim 1, quadric "double"  (tangent)
size 546  rep (1,0,1,1, 2,3,5,8,0)   apolar degree 2, kernel dim 1, quadric "inert"   (conjugate secant)
size 546  rep (1,0,2,0, 4,0,8,0,3)   apolar degree 2, kernel dim 1, quadric "inert"   (conjugate secant)
size 364  rep (1,0,1,2, 4,12,4,3,6)  apolar degree 5, kernel dim 2                    (exceptional)
```

with `182 + 546 + 546 = 1274 = q(q+1)^2/2` persistent and the exceptional orbit
of size 364 exactly the witness `(1,0,1,2,4,12,4,3,6)` of 2026-08-30 §5.3c.
Conjecture B stays falsified, on the new core, with the identical witness.

