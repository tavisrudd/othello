# C1018 — Landing the sharpened PRS deep-hole conjecture

**Lane:** `gem-mining`
**Date:** 2026-08-31
**Status:** complete for the re-baseline, the redundancy-nine band `16 ≤ q ≤ 19`,
the `r = 13` carrier discriminator, the first redundancy-ten censuses, and the
redundancy-eight threshold band as far as memory reaches.  See §10.

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

All twenty cells reproduce exactly.  So do the four classical redundancy-three
cells (`q = 5,7,8,9` giving deep `25, 49, 1, 81`, with `ρ = 3` and the single
nucleus point at `q = 8`) and the whole redundancy-four sweep over
`q ∈ {4,5,7,8,9,11,13,16,25,27,32,64}`, where deep `= q(q+1)^2/2` with zero
exceptional excess in every cell and the orbit counts
`2,3,2,3,3,3,2,2,2,3,3,2` match 2026-08-30 §5.2 term by term.  `X(4) = ∅`
stands.

The `(9,13)` falsifying witness reproduces
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

The two exact-rank algorithms were also pinned against each other with
`--rank-mode`, which is a cross-check of the new algorithm against the old one
inside a single binary, on four cells with nontrivial exceptional structure:

| cell | kernel enumeration | subset enumeration |
|---|---|---|
| `r=6, q=8`  | 5,037 deep / 13 orbits / 4,713 exceptional in 11 | identical |
| `r=6, q=13` | 1,820 deep / 3 orbits / 546 exceptional in 1 | identical |
| `r=7, q=11` | 3,080 deep / 10 orbits / 2,288 exceptional in 5 | identical |
| `r=5, q=16` | 2,432 deep / 4 orbits / 120 exceptional in 1 | identical |

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

## 4. Redundancy nine above `q = 13`: the three out-of-budget cells (item 2)

2026-08-30 §5.3e recorded `r = 9` at `q = 16, 17, 19` as out of budget by
2–9× in time, with `q = 19` exceeding available memory outright, and §5.5 item 4
recorded `X(9) ∩ [16,52]` as untested.  All three are now exhaustive censuses of
the full projective space, with the deep-orbit representatives independently
re-derived in Python from the definition of the coset weight.

| `r` | `q` | `k` | `N = \|PG(8,q)\|` | wall | peak RSS | `ρ` | deep | `PGL_2` orbits | persistent `q(q+1)^2/2` | **exceptional** |
|---:|---:|---:|------------------:|-----:|---------:|----:|-----:|---------------:|------------------------:|----------------:|
| 9 | 13 | 5 |    883,708,281 |  40 s | 139 MB | 8 | 1,638 | 4 | 1,274 | **364** |
| 9 | 16 | 8 |  4,581,298,449 | 126 s | 562 MB | 8 | 2,312 | 3 | 2,312 | **0** |
| 9 | 17 | 9 |  7,411,742,281 | 334 s | 912 MB | 8 | 2,754 | 3 | 2,754 | **0** |
| 9 | 19 | 11 | 17,927,094,321 | 644 s | 2.20 GB | 8 | 3,800 | 4 | 3,800 | **0** |

Orbit structure matches the persistent orbit law exactly in each clean cell:
at `q = 16` the tangent family splits in two because `p = 2 \| r-1 = 8`, and
`gcd(8,17) = 1` gives one conjugate-secant orbit, total 3; at `q = 17`,
`p = 17 ∤ 8` gives one tangent orbit and `gcd(8,18) = 2` gives
`⌊2/2⌋ + 1 = 2` conjugate-secant orbits, total 3; at `q = 19`,
`gcd(8,20) = 4` gives `⌊4/2⌋ + 1 = 3` conjugate-secant orbits of sizes
`855 + 855 + 1710 = 3420 = q(q^2-1)/2` plus one tangent orbit of size
`380 = q(q+1)`, total 4.

For reference, 2026-08-30 §5.3e estimated these three cells at 34, 55 and
134 minutes and 4.6, 7.4 and 17.9 GB, with `q = 19` exceeding available memory.
Measured on the new driver they cost 2, 6 and 11 minutes and 0.56, 0.91 and
2.20 GB, all under load from concurrent runs.

**Independent replay.**  Every deep orbit representative of every cell was
re-checked in Python by computing the coset weight from its definition — the
least number of parity-check columns whose `F_q`-span contains the syndrome,
decided by Gaussian rank — with no Hankel criterion and no orbit machinery:

| cell | reps checked | weight disagreements | listed deep orbit sizes | driver deep total | catalecticant ranks |
|---|---:|---:|---:|---:|---|
| `r=9, q=13` | 4 | 0 | 1,638 | 1,638 | `{2,3}` |
| `r=9, q=16` | 3 | 0 | 2,312 | 2,312 | `{2}` |
| `r=9, q=17` | 3 | 0 | 2,754 | 2,754 | `{2}` |
| `r=9, q=19` | 4 | 0 | 3,800 | 3,800 | `{2}` |
| `r=8, q=16` | 2 | 0 | 2,312 | 2,312 | `{2}` |
| `r=8, q=19` | 2 | 0 | 3,800 | 3,800 | `{2}` |

The `r=8, q=16` row is the cell that produced 30 spurious weight disagreements
on 2026-08-30 through a field-model mismatch.  With both sides reading
`defining_poly` and rebuilding `GF(16) = F_2[x]/(x^4+x+1)`, it agrees exactly.

**What this settles.**  `q_0(9) = 16`: the redundancy-nine exceptional band
closes immediately above `q = 13`, and `X(9) ∩ [16,19] = ∅`.  2026-08-30
mystery-ledger item 8 asked precisely this and named the `q = 16` cell as the
gate; the answer is the comfortable one for Conjecture B′, not the fragile one.
Combined with the positive cells, `X(9) ∩ [9,19] = {9,11,13}` exactly.

Note that `q = 16` and `q = 19` both satisfy `3 \| q-1`, so the cyclic-cubic
carrier that produces the exceptional orbit at `q = 13` is *admissible* at both
and fires at neither.  The full census confirms what the 2026-08-30 stratum
sweep could only show on the `S_3`-fixed locus: at those fields there is no
exceptional deep hole anywhere in `PG(8,q)`, with or without cyclic symmetry.
That is the exact upgrade from stratum-only to full-space evidence that item 2
was for.

## 4b. The redundancy-eight threshold band (item 4)

`notes/2026-07-23-c513-prs-redundancy-eight.md` proves that for every prime
power `q ≥ 43` the deep syndromes of `PRS(q-7)` are exactly the persistent
tangent and conjugate-secant families, and records two open items: *"What
happens below 43?  No bounded census or exceptional normal-form theorem was
attempted"* and *"Is 43 sharp?"*.  2026-08-30 answered the first over
`8 ≤ q ≤ 19` and left `X(8) ∩ [23,42]` — the fields `23, 25, 27, 29, 31, 32,
37, 41` — untested.  Exhaustive censuses of the full `PG(7,q)`:

<!-- R8BAND TABLE -->

## 4c. First redundancy-ten censuses

`r = 10` was recorded on 2026-08-30 §5.5 item 5 as **not searched at all**, with
Conjecture C's prediction `X(10) ⊆ {11}` untested.  The new driver reaches it.

<!-- R10 TABLE -->

## 5. The cyclic-pullback carriers (item 3, and what it settled)

2026-08-30 §5.3f left Conjecture D′ with one escape clause — some `(r,m)` pairs
carry nothing, `(10,7)` being the only known instance — and mystery-ledger
item 6 with one open question: is the orbit stabilizer dihedral because `m` is
odd, or because `m = 3`?  The queued discriminator was `m = 5` at `r = 13`.
It is answered, and a cheaper cell answers the stabilizer question outright.

### 5a. `m = 5` at `r = 13` is a second empty pair

`r = 13` has `r-3 = 10`, so its cyclic-pullback carriers are `m ∈ {2,5,10}`,
each requiring `m | q-1` and `q ≥ r-1 = 12`.  Exhaustive sweeps of the full
stratum, every point evaluated exactly:

| `r` | `m` | stratum | `q` | stratum points | max weight | deep | exceptional |
|---:|---:|---|---:|---:|---:|---:|---:|
| 13 | 5  | `{1,6,11}` | 16 | 273 | 12 | 2 | **0** |
| 13 | 5  | `{1,6,11}` | 31 | 993 | 12 | 2 | **0** |
| 13 | 10 | `{1,11}`   | 31 |  32 | 12 | 2 | **0** |

`q = 16` is the least admissible field for `m = 5` (`5 | 15`, `16 ≥ 12`) and
`q = 31` is the least admissible one of characteristic exceeding `d = 12`, where
the syndrome is honestly a binary form of degree 12 and the factorisation
`XY·G(X^5,Y^5)` is available.  Both are clean, and in both the stratum's only
deep points are the two persistent ones it meets.  `q = 31` is also the least
admissible field for `m = 10`, and it too is clean.

So **`(13,5)` and `(13,10)` are empty pairs, joining `(10,7)`.**  The
prediction recorded as 2026-08-30 mystery-ledger item 7 — that `(13,5)` would
fire at `q = 16` because its stratum `{1,6,11}` has the same three-index,
quadratic-`G` shape that fires at `(9,3)` — is **false**.  Shape alone does not
predict firing.

### 5b. The `(r,m) = (8,5)` carrier fires, and names the `r=8, q=11` orbit

`r = 8` has `r-3 = 5`, so its only cyclic-pullback carrier is `m = 5`, on the
two-index stratum `{1,6}` (`a = b = 1`, `G` linear), admissible when `5 | q-1`
and `q ≥ 7`:

| `r` | `m` | stratum | `q` | stratum points | deep | exceptional |
|---:|---:|---|---:|---:|---:|---:|
| 8 | 5 | `{1,6}` | 11 | 12 | 6 | **4** |
| 8 | 5 | `{1,6}` | 16 | 17 | 2 | 0 |
| 8 | 5 | `{1,6}` | 31 | 32 | 2 | 0 |
| 8 | 5 | `{1,6}` | 41 | 42 | 2 | 0 |

It fires at `q = 11`, the least admissible field, and at no larger one — D′'s
field law holds for a fifth `(r,m)` pair.  The four exceptional stratum points
are `(0,1,0,0,0,0,c,0)` for `c ∈ {2,5,6,9}`, i.e. the binary septics

```text
s = X Y ( Y^5 + c X^5 ),      c ∈ {2,5,6,9} ⊂ F_11^* .
```

The five classes of `F_11^*/(F_11^*)^5` are `{1,10}, {2,9}, {4,7}, {3,8},
{5,6}`, and `{2,5,6,9} = {2,9} ∪ {5,6}` is exactly a union of two of them —
Conjecture E′'s cut, now confirmed on a two-index carrier as well as on the
three-index ones.  Each has apolar degree 4 with a one-dimensional kernel
spanned by the quartic `x^2` (root type "double at 0 plus double at ∞"), so
there is a unique apolar quartic and it is not split squarefree.

Independent Python (definition-level weight, independent orbit closure)
confirms: orbit size 264 in `PGL_2(11)` of order 1320, stabilizer of order 5
with element orders `{1,5,5,5,5}`, minimal-support points exactly those four,
weight 7 with minimal spanning set `{0,1,2,3,5,7,8}`.

**This names the orbit that 2026-08-30 mystery-ledger item 3 left
undescribed.**  The three exceptional orbits at `r = 8, q = 11` have sizes
`264, 1320, 1320` and stabilizer orders `5, 1, 1`; the 264 one is the `m = 5`
cyclic-quintic carrier above.  The two regular orbits remain unidentified and
are invisible to every stratum sweep, exactly as 2026-08-30 §5.3f's scope note
says.

### 5b′. The redundancy-five carrier is empty, and the strata are nested

`r = 5` has `r-3 = 2`, so `m = 2` on the stratum `{1,3}` is its only
cyclic-pullback carrier, admissible for every odd `q ≥ 4`.  Exhaustive sweeps:

| `q` | 5 | 7 | 9 | 11 | 13 | 17 | 19 | 23 | 25 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| stratum points | 6 | 8 | 10 | 12 | 14 | 18 | 20 | 24 | 26 |
| deep | 4 | 5 | 6 | 7 | 8 | 10 | 11 | 13 | 14 |
| **exceptional** | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |

Every deep stratum point is persistent, at every field, and the deep count is
exactly `(q+3)/2`.  So `(5,2)` is a **fourth empty pair**, and it matters more
than the others: `X(5) = {7,8,9,11,13,17,19}` is the largest exceptional band of
any redundancy, and *none* of it comes from a cyclic-pullback carrier.  The
`r = 5` sporadics — C491's, classified there by branch divisor — are a different
mechanism, and they are the sole reason Conjecture B′ needed a bound of 23
rather than 16.

One caveat on the carrier taxonomy that the data force.  The strata are nested:
`{i ≡ 1 mod m'} ⊆ {i ≡ 1 mod m}` whenever `m | m'`, so the `m = 2` stratum
contains every even-`m` stratum, and the `m = 3` stratum contains the `m = 6`
one.  That is why 2026-08-30 §5.3f found 40 exceptional points on the `m = 2`
stratum at `(11,13)` containing the 12 on the `m = 4` stratum.  Statements about
"the `m` carrier" are therefore only sharp when phrased through the orbit
stabilizer, which is what §5c does, rather than through stratum membership.

### 5c. The stabilizer is not governed by the parity of `m`

Stabilizers of carrier orbits, all computed independently in Python:

| `(r,q,m)` | shape of `G` | orbit(s) | stabilizer | stratum points per orbit |
|---|---|---|---|---:|
| `(9,13,3)`  | quadratic | one, size 364 | `S_3`, order 6 — dihedral | 4 |
| `(11,13,4)` | quadratic | two, size 546 | `C_4`, order 4 — cyclic | 6 |
| `(8,11,5)`  | linear    | one, size 264 | `C_5`, order 5 — cyclic | 4 |

`m = 5` is odd and its stabilizer is **cyclic**, so the reading recorded as
mystery-ledger item 6 — "the involution `t ↦ μ/t` stabilises carrier points only
in the odd case" — is **false**.  There is no odd/even dichotomy: `m = 3` is
simply the one carrier tested whose stabilizer is dihedral.

The mechanism is visible in the orbit counts and needs no new computation.  The
subgroup of `PGL_2(q)` preserving the stratum is the normaliser `N` of the
diagonal torus, dihedral of order `2(q-1)`, and every carrier orbit's stabilizer
is `Stab_N(s)`, which always contains the order-`m` torus element.  Counting
`|N| / |O ∩ stratum|` reproduces each row: `24/4 = 6` at `(9,13,3)`,
`24/6 = 4` at `(11,13,4)`, `20/4 = 5` at `(8,11,5)`.  So the stabilizer is the
cyclic group `μ_m` in general and doubles to dihedral order `2m` exactly when
some involution `t ↦ μ/t` fixes `s`, i.e. when the carrier polynomial `G` is
self-reciprocal up to the torus action.  That happens at `(9,13,3)` and not at
the other two; it is a condition on `G`, not on the parity of `m`.

## 6. The landed conjecture (item 5)

Notation.  `X(r) = { q : q ≥ r-1 a prime power, PRS_{q+1-r}(q) has a deep hole
outside P_r ∪ M^max_{r,p} }`, and `q_0(r)` = the least prime power beyond which
no exceptional deep hole occurs, i.e. `1 + max X(r)` rounded up to the next
prime power, with the 2026-08-30 convention `q_0(4) = 4` when `X(r) = ∅`.
`P_r` is the persistent locus — deep part the tangent and
conjugate-secant families, of total size `q(q+1)^2/2` — and `M^max_{r,p}` is the
modular Lucas carrier `P⟨ e_i : C(r-1,i) ≡ 0 (mod p) ⟩`.

Three statements, in decreasing order of how well the data pin them.

### Conjecture PRS-1 (exceptional band).  `X(r) ⊆ {7,8,9,11,13}` for every `r ≥ 6`.

Equivalently: **for every redundancy `r ≥ 6` and every prime power `q ≥ 16` with
`q ≥ r-1`, the deep holes of `PRS_{q+1-r}(q)` are exactly `P_r ∪ M^max_{r,p}`,
of deep size `q(q+1)^2/2` plus the modular carrier's deep part.**  The
exceptional set is contained in the prime powers of the interval `[7,13]`, and
the threshold is the constant 16 rather than the linearly growing proved
threshold `Q*_r = 6r-16+⌊2√(6r-18)⌋` (which is 29, 37, 43, 53, 59 at
`r = 6,…,10`).

Redundancies 4 and 5 sit outside the statement and are the reason it starts at
`r = 6`: `X(4) = ∅` and `X(5) = {7,8,9,11,13,17,19}`, the only redundancy known
to have an exceptional field above 13.

This replaces Conjecture B′ of 2026-08-30 §5.3c (`q_0(r) ≤ 23` for every `r`),
which it implies for `r ≥ 6` and sharpens from 23 to 16.  B′'s bound of 23 was
set entirely by `r = 5`; every redundancy from 6 up has `q_0(r) ≤ 16`.

*Falsifier.*  One deep syndrome over a field of order at least 16, at any
redundancy at least 6, with catalecticant rank at least 3 and support not
contained in `M^max_{r,p}`.

### Conjecture PRS-2 (cyclic-pullback carriers).

The exceptional deep holes with nontrivial cyclic stabilizer are the
`PGL_2(q)`-orbits of syndromes `X Y · G(X^m, Y^m)` with `m | r-3` and
`m | q-1`.  For each pair `(r,m)` they occur at **at most one field**, and if
at any, then at the least prime power `q` with `m | q-1` and `q ≥ r-1`.  The
orbit's stabilizer is `Stab_N(s)` for `N` the dihedral normaliser of the torus,
always containing `μ_m` and equal to it unless `G` is self-reciprocal up to the
torus, in which case it is dihedral of order `2m`.

This is 2026-08-30's Conjecture D′ with the escape clause promoted from a
footnote to part of the statement (three empty pairs are now known, not one),
and with the stabilizer clause corrected — see §5c.

*Falsifier.*  A carrier firing at a field other than the least admissible one,
or a stabilizer not of the stated form.

### Conjecture PRS-3 (carrier cut).

Each exceptional orbit of a cyclic carrier meets its stratum in the set cut out
by one value of the absolute invariant `u` together with a union of classes of
`c` in `F_q^*/(F_q^*)^m`, where for a three-index carrier `{1,1+m,1+2m}`

```text
c = s_{1+m}/s_1 ,        u = s_{1+m}^2/(s_1 s_{1+2m}) ,
```

and for a two-index carrier `{1,1+m}` the cut is by `c = s_{1+m}/s_1` alone.
`u` separates orbits; neither invariant alone suffices.

This is 2026-08-30's Conjecture E′ extended to the two-index case by the
`(8,11,m=5)` carrier, where the four exceptional points are exactly the union of
two of the five classes of `F_11^*/(F_11^*)^5`.

*Falsifier.*  An exceptional carrier orbit whose stratum intersection is not a
union of `m`-th power classes at a single `u`.

## 7. What the exceptional deep holes are, in classical language

This section is a reading of the data in standard terminology, not a new
result, and a literature check is owed before any of it is claimed as one.

Under apolarity, `s ∈ span{ P_{t_1}, …, P_{t_j} }` says exactly that the binary
form dual to `s` is a sum of `j` `d`-th powers of linear forms with **distinct
`F_q`-rational** base points.  So the NRC rank `w(s)` is the Waring rank of a
binary form of degree `d`, computed over `F_q` with rational and distinct
summands, and `ρ = d` says the maximum such rank is `d`.

Over an algebraically closed field the maximum Waring rank of a binary form of
degree `d` is `d`, attained precisely by the forms `L_1^{d-1} L_2` with `L_1`
and `L_2` independent (Comas–Seiguer).  That is exactly the **tangent** family:
apolar quadric a perfect square.  The **conjugate-secant** family is the other
classical source of a rank jump — algebraic-closure rank 2, but the two base
points are Galois-conjugate, so no rational decomposition of size 2 exists and
the `F_q`-rank rises to `d`.  Together they are the persistent locus, of size
`q(q+1)^2/2`, and their deepness is classical plus arithmetic bookkeeping.

The exceptional deep holes are therefore precisely the syndromes whose
**`F_q`-Waring rank exceeds their algebraic-closure rank by more than that
bookkeeping accounts for**.  The `(9,13)` witness makes the size of the jump
concrete: its apolar ideal is a complete intersection of type `(5,5)` in degree
`d = 8`, so over the algebraic closure it has rank 5, the generic value for a
binary octic; over `F_13` every annihilator of degree 5, 6 and 7 fails to be
split squarefree and the rank jumps to 8.

That reframing turns 2026-08-30 mystery-ledger item 5 — "why does a carrier fire
at exactly one field, and why the least admissible one?" — into a concrete
counting question with a standard tool.  For a fixed carrier `(r,m)` the stratum
is a projective space of dimension `M-1` that does **not** grow with `q`, while
the apolar space at level `j` has `(q^{k_j}-1)/(q-1) ≈ q^{k_j - 1}` members and
the split squarefree fraction of degree-`j` forms is `1/j! + O(q^{-1/2})` by
Lang–Weil applied to the configuration space.  The expected number of split
squarefree annihilators therefore grows like `q^{k_j-1}/j!` with an error term
one power of `q^{1/2}` smaller, so past an explicit constant the count is
positive and no point of the stratum can be deep.  **The threshold is a constant
for each carrier, not a function of `r`** — which is precisely the shape the
data show (13, then 16) and precisely what the Hasse–Weil deletion budget
`6r-18` behind the proved thresholds `Q*_r` fails to capture, because that
budget is applied to a family whose dimension it lets grow with `r`.

Making this an argument rather than a heuristic needs the explicit error term
for the carrier's own pencil, not for a generic form.  That is a well-posed
successor task and it is the single highest-value follow-up this wave exposes.

## 7b. Relation to the two open questions in C513, and to the MDS fence

`notes/2026-07-23-c513-prs-redundancy-eight.md` records two open items that this
wave speaks to directly.

* *"What happens below 43?  No bounded census or exceptional normal-form theorem
  was attempted."*  Answered by exhaustive census over the range §4b reaches:
  `X(8)` is exactly `{8, 9, 11}` there, and the one exceptional orbit with
  cyclic symmetry — the size-264 orbit at `q = 11` — has the closed normal form
  `XY(Y^5 + cX^5)`, `c` in two of the five fifth-power classes of `F_11^*`
  (§5b).  The two regular orbits at `q = 11` still have no normal form.
* *"Is 43 sharp?"*  No, and by a wide margin: the persistent-only
  classification holds unbroken from `q = 13` upward across every field
  censused.  The proved threshold is not merely non-sharp; §7 argues the true
  threshold should be a constant, while `Q*_r = 6r-16+⌊2√(6r-18)⌋` grows
  linearly, so the gap widens with `r` rather than closing.

The MDS fence of `notes/open-problems/plausible-bridges/mds.md` is respected
exactly as on 2026-08-30 and this wave sharpens the same point.  Kaipa's
deep-hole/MDS-extension dictionary is an equivalence only at covering radius
`r`, and across every census cell in this wave the radius was `r-1` except the
two classical even-field cases `k ∈ {2, q-2}` — `(r,q) = (3, q even)` and
`(7,8)` — both already known.  Nothing here touches MDS length.

## 8. Mystery ledger

Carried forward from 2026-08-30 §8, with this wave's `ej` + `tt` closeout pass
folded in.  Items settled here are marked; everything still open names its
evidence gap and its owner.

1. **Where does `q_0(9)` sit?**  *Settled.*  It is 16.  The three cells
   `r = 9` at `q = 16, 17, 19` are now exhaustive censuses of 4.58, 7.41 and
   17.9 billion projective directions, all with deep set exactly the persistent
   locus and zero exceptional excess.  The band closes immediately above 13.
   Nothing open.

2. **The GF(2^h) field-labelling hazard.**  *Settled and closed by
   construction.*  Both drivers now take the field from the core's
   `SmallField::new`, emit `defining_poly`, and the verifier rebuilds the same
   model; the `r=8, q=16` cell that produced 30 spurious disagreements on
   2026-08-30 now agrees representative-for-representative.  The standing
   caution survives for the committed R5–R7 certificates at
   `q = 8, 9, 16, 25, 27, 32` if they are ever re-checked by a program that
   picks its own modulus.

3. **What the `r = 8, q = 11` exceptional orbits are.**  *Half settled.*  The
   size-264 orbit with `C_5` stabilizer is the `m = 5` cyclic-quintic carrier
   `XY(Y^5 + cX^5)` with `c` in two of the five fifth-power classes of `F_11^*`,
   and it fires at `q = 11` and nowhere above (§5b).  The two size-1320 orbits
   have trivial stabilizer, are invisible to every stratum sweep, and remain
   undescribed.  Evidence gap: the analogue of C491's branch-divisor
   classification for regular exceptional orbits at redundancy eight.

4. **Is the carrier stabilizer governed by the parity of `m`?**  *Settled: no.*
   `m = 5` is odd with a cyclic `C_5` stabilizer.  The stabilizer is `Stab_N(s)`
   for `N` the dihedral normaliser of the torus; it is `μ_m` in general and
   doubles only when `G` is self-reciprocal up to the torus, which happens at
   `m = 3` and not at `m = 4` or `m = 5` (§5c).  The 2026-08-30 reading was
   drawn from two data points that happened to be `m = 3` and `m = 4`.

5. **Why does a carrier fire at exactly one field, and why the least admissible
   one?**  *Reframed, not settled.*  §7 turns the question into a Lang–Weil
   count: the carrier stratum has fixed dimension while the apolar space at
   level `j` grows like `q^{k_j-1}` and the split squarefree fraction is
   `1/j! + O(q^{-1/2})`, so past an explicit constant no stratum point can be
   deep, and that constant does not depend on `r`.  This explains the *shape* of
   the observed constant threshold and why the proved thresholds `Q*_r` grow.
   Evidence gap: the explicit error term for the carrier's own apolar pencil
   rather than for a generic form.  Owner: a successor task; this is the highest
   value follow-up the wave exposes.

6. **Why some `(r,m)` pairs carry nothing.**  *Sharpened, not settled.*  Four
   empty pairs are now known — `(5,2)`, `(10,7)`, `(13,5)`, `(13,10)` — against
   five that fire: `(6,3)`, `(8,5)`, `(9,3)`, `(11,4)`, `(12,3)`.  The
   2026-08-30 hypothesis that emptiness comes from the stratum being too small
   for `G` to be irreducible (`(10,7)` has a two-index stratum) is **refuted**:
   `(8,5)` has the same two-index, linear-`G` shape and fires, while `(13,5)`
   has the same three-index, quadratic-`G` shape as the firing `(9,3)` and is
   empty.  Nor does the least admissible field separate them: `(5,2)` has
   `q_min = 5`, the smallest of any pair, and carries nothing at any of the nine
   fields swept.  Every firing pair has `m ∈ {3,4,5}`; no pair with `m = 2` or
   `m ≥ 6` has ever fired on its own stratum.  That is the strongest pattern in
   the data and nothing explains it.  Evidence gap: a firing or clean verdict
   for a pair with `m = 6` or `m = 7` at a small `q_min`; `(9,6)` at `q = 13` is
   the cheapest and was already swept clean on 2026-08-30.

7. **The exceptional band is not monotone in `r`.**  *Standing, from
   2026-08-30.*  Now with a fuller table (§6): `q_0(r) = 4, 23, 16, 13, 13, 16`
   at `r = 4,…,9`.  The dip to 13 at `r = 7, 8` and the rise back to 16 at
   `r = 9` are unexplained by any counting budget.  §7 predicts the threshold
   should be constant per carrier, which is consistent with a small oscillation
   coming from *which* carriers are admissible at each `r` (via `m | r-3`) but
   does not derive the values.  Owner: the same successor as item 5.

8. **Redundancy four has no exceptional field at all.**  *Standing, from
   2026-08-30.*  `X(4) = ∅` over twelve fields in three characteristics, while
   `X(5)` is the largest band of all.  Unexplained.  Note that `r-3 = 1` at
   `r = 4`, so there is no cyclic-pullback carrier at all — consistent with, but
   not an explanation of, the emptiness.

9. **`r = 5` is the outlier that sets Conjecture B′'s bound, and it is not a
   carrier.**  *New this wave, half settled.*  Every redundancy from 6 up has
   `q_0(r) ≤ 16`; only `r = 5` reaches 17 and 19.  The sweep of §5b′ settles the
   mechanism question negatively: `r = 5`'s only cyclic-pullback carrier is
   `m = 2`, and it carries zero exceptional points at every odd `q` from 5 to
   25.  So the entire `r = 5` band — the largest of any redundancy and the sole
   reason Conjecture B′ needed 23 rather than 16 — comes from orbits with no
   cyclic symmetry, the same invisible class as the two size-1320 orbits of
   item 3.  Evidence gap: why that class survives to `q = 19` at `r = 5` and
   dies by `q = 13` at every larger redundancy.  Owner: the same successor as
   item 3; C491 classifies the `r = 5` sporadics by branch divisor, so half the
   answer may already be committed.

10. **Nothing anomalous in the validation layer.**  Twenty committed-certificate
    cells reproduced exactly on the new core, ten cells cross-run through two
    structurally different drivers, six cells re-derived in Python from the
    definition of the coset weight with zero disagreements, and every run
    self-checked by requiring its weight histogram to sum to the exact point
    count of the space.  No genuine mystery here and none is claimed.

## 9. Evidence bundle, replay, and trusted boundary

### Task-owned files (all committed)

```text
notes/2026-08-31-c1018-prs-deephole-conjecture.md   this report
notes/2026-08-31-c1018-prs-certificate.py           certificate builder / checker
notes/2026-08-31-c1018-prs-certificate.json         compact certificate, one record per cell
notes/2026-08-30-c1018-prs-helper.py                independent Python verifier (extended
                                                    to read the new driver's JSON schema)
ergodis-private/src/bin/c1018_prs_census.rs         parallel u64 census + stratum driver
ergodis-private/src/bin/c1018_prs_deephole.rs       2026-08-30 driver (ported onto the core
                                                    by a concurrent session; unchanged here)
```

Bulk per-cell JSON lives outside the repository under
`~/.cache/ergodis/c1018/prs/`; the committed certificate folds every
load-bearing field of every cell together with the SHA-256 and byte count of the
file it came from, so no claim in this report rests on an untracked file.

### Replay

```bash
cd ~/src/othello/ergodis-private
cargo build --release --bin c1018_prs_census --bin c1018_prs_deephole
C=~/.cache/ergodis/c1018/prs && mkdir -p $C

# a full PG(r-1,q) census cell
./target/release/c1018_prs_census --r 9 --q 19 --max-reps 16 --out $C/r9-q19.json

# the same cell through the 2026-08-30 driver, where it fits in u32 and 2 GB
./target/release/c1018_prs_deephole --r 8 --q 13 --max-reps 16

# a carrier-stratum sweep
./target/release/c1018_prs_census --r 13 --q 31 --stratum-mod 5 --stratum-class 1 \
  --max-reps 512 --out $C/r13-m5-q31.json

# pin the exact-rank algorithm, to cross-check kernel enumeration against
# subset enumeration on the same cell
./target/release/c1018_prs_census --r 8 --q 13 --rank-mode kernel
./target/release/c1018_prs_census --r 8 --q 13 --rank-mode subset

# independent Python re-derivation from the definition of the coset weight
cd ~/src/othello
python3 notes/2026-08-30-c1018-prs-helper.py verify 19 9 $C/r9-q19.json

# rebuild / re-check the committed certificate
python3 notes/2026-08-31-c1018-prs-certificate.py build $C \
  notes/2026-08-31-c1018-prs-certificate.json
python3 notes/2026-08-31-c1018-prs-certificate.py check $C \
  notes/2026-08-31-c1018-prs-certificate.json
```

### What the computation certifies, and what it does not

* **Certified.**  For each census cell, the exact NRC rank `w(s)` of every point
  of `PG(r-1,q)`, hence the exact covering radius, the exact number of deep
  projective directions, the exact `PGL_2(q)`-orbit decomposition of the deep
  set, and the exact split of that set by catalecticant rank.  Arithmetic is
  exact in `F_q` throughout (table-driven `SmallField`, no floating point, no
  modular reduction outside the field).  Enumeration is complete: the run aborts
  unless the weight histogram sums to the exact point count of the space.
* **Certified for a stratum sweep.**  The same quantities over the named
  arithmetic-progression stratum, exhaustively.  Nothing outside that stratum.
* **Not certified.**  Anything about a field or redundancy not listed.  A
  stratum sweep sees only orbits whose stabilizer contains the corresponding
  cyclic group; it cannot show `q ∉ X(r)`.
* **No independent Python replay exists for the `r = 13` strata.**  The Python
  verifier decides the coset weight by enumerating `j`-subsets of `PG(1,q)` and
  taking Gaussian ranks; at `r = 13, q = 31` that is `Σ_{j≤12} C(32,j) ≈ 4.4·10^8`
  rank computations *per stratum point*, over 993 points.  It is not a budget
  question but an interpreted-language one, and no second implementation was
  written.  What stands in its place for those cells is the `--rank-mode`
  cross-check (kernel enumeration against subset enumeration, structurally the
  2026-08-30 driver's algorithm) and, at `q = 16`, agreement with the 2026-08-30
  driver itself, which shares no code with the census driver.
* **Trusted boundary of the checker.**  The Ergodis core's `SmallField`
  (irreducibility test and arithmetic tables), `ProjectiveIndex` (rank/unrank of
  `PG(d,q)`), and the standard library's atomics.  The exact-rank criterion
  itself is the Hankel/apolarity equivalence of 2026-08-30 §1, which the Python
  verifier does *not* assume: it decides `w(s)` from the definition, as the
  least number of parity-check columns whose `F_q`-span contains the syndrome,
  by Gaussian rank.

## 10. Status

<!-- STATUS -->

