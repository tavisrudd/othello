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

## 3. The parallel census driver (what made items 2 and 4 reachable)

The 2026-08-30 cells were blocked by two limits of `c1018_prs_deephole`, both
recorded there: a `u32` point index with a one-byte-per-point weight array
(`|PG(8,19)| = 1.79·10^10` needs 17.9 GB, above the machine's ceiling), and an
exact-rank routine that enumerates every `j`-subset of `PG(1,q)` at every level
`j = 1..d`.  `ergodis-private/src/bin/c1018_prs_census.rs` (new, task-owned)
lifts both:

1. **`u64` indices and a one-bit visited bitmap.**  The weight histogram is
   accumulated per orbit at discovery, so no per-point weight storage exists;
   memory is `N/8` bytes.  `|PG(8,19)|` costs 2.2 GB rather than 17.9 GB.
2. **Lock-free parallel orbit enumeration** over `std::thread::scope`.  An
   orbit is owned by whichever thread wins an atomic test-and-set on the bit of
   the orbit's *minimum* point index.  That index is a property of the orbit,
   not of the traversal, so ownership is single-valued under every interleaving
   and a losing thread simply discards its traversal.  The run aborts unless the
   weight histogram sums to exactly `N`.
3. **Apolar-kernel exact rank.**  `w(s) ≤ j` needs a nonzero element of
   `ker H^(j)_s`, so levels below the apolar degree `e(s)` are skipped instead
   of being searched — the old routine enumerated `C(q+1,j)` subsets at levels
   that provably contain no annihilator at all.  Above `e(s)` the search runs
   over whichever set is smaller, the `(q^k-1)/(q-1)` projective points of the
   kernel or the `C(q+1,j)` split squarefree forms.  Typically `k = 1` at
   `j = e(s)`, so one candidate replaces `C(q+1,e)`.

The two drivers share no code: different index type, different traversal,
different orbit-ownership rule, different exact-rank algorithm.  Only the field,
the projective indexing, and nothing else come from the same Ergodis core
primitives, which is deliberate — it is what makes the field model identical and
representative-level comparison meaningful.  Agreement on a cell is therefore an
independent replay of that cell at the algorithmic level.

**Cross-validation.**  Ten cells were run through both drivers and agreed on
every reported quantity (`ρ`, deep count, deep orbit count, and — where the old
driver emits them — the representatives): `r=5` at `q = 7, 8, 16`; `r=6` at
`q=9`; `r=7` at `q = 8, 13`; `r=8` at `q = 8, 9, 11, 13`.  Eight more cells were
run through the new driver and matched the 2026-08-30 tables: `r=8` at
`q = 16, 17, 19`, `r=9` at `q = 9, 11, 13`, and the stratum sweeps
`(9,13,m=3)`, `(11,13,m=4)`.  The measured cost of the redundancy-nine decider
`(9,13)` fell from 396 s and 968 MB to 40 s and 139 MB.

### 3b. What "exceptional" counts, and the characteristic caveat

The driver reports a deep syndrome as **exceptional** exactly when its apolar
degree is at least 3, i.e. when the consecutive three-row catalecticant
`C^{(2)}_s` has rank 3 and the point is outside the persistent locus `P_r`.
That is the criterion 2026-08-30 §5.3c used, and it is what the Python verifier
recomputes independently as `cat2_rank`.

`X(r)` is a strictly smaller set: deep outside `P_r ∪ M^max_{r,p}`, where
`M^max_{r,p}` is the modular (Lucas) carrier `P⟨ e_i : C(d,i) ≡ 0 (mod p) ⟩`,
which is nonempty only when `p ≤ d`.  So in a cell of characteristic `p ≤ d`
the reported exceptional count may include modular-carrier points that do not
witness `q ∈ X(r)`.  The distinction is visible and was checked:

* `r = 5, q = 16` (`p = 2 ≤ d = 4`) has deep `= 2432 = q^2(q+3)/2` in four
  orbits — `17 + 255` tangent (split in two because `p | r-1`), `2040`
  conjugate-secant, and one further orbit of size 120 with apolar degree 3 and
  representative `(0,1,1,8,0)`.  Since `C(4,i) ≡ 0 (mod 2)` exactly for
  `i ∈ {1,2,3}`, that orbit lies in `M^max_{5,2} = P⟨e_1,e_2,e_3⟩`.  It is a
  modular carrier, not a member of `X(5)`, which is why 2026-08-30 §5.1 records
  this cell as having no sporadics.
* `r = 8` has `d = 7` and `C(7,i)` odd for every `i`, so `M^max_{8,2} = ∅` —
  this is C513's "no additional modular-nucleus family", and it means that at
  redundancy eight in characteristic two the reported exceptional count *is*
  the `X(8)` witness count.  For the other characteristics appearing in the
  band, `M^max_{8,3} = P⟨e_2,e_5⟩` and `M^max_{8,5} = P⟨e_3,e_4⟩`.

Every cell in this wave with a nonzero exceptional count had its
representatives checked against the relevant `M^max_{r,p}` support condition
before being read as an `X(r)` witness.

