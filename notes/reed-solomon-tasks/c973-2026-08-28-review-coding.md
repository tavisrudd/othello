# C973 external cold-read review — coding promotion and finite certificates

**Lane:** `reed-solomon` · **Date:** 2026-08-28 · **Reviewer scope:** independent
cold read of the coding-theoretic promotion (syndrome → Hankel/apolarity →
split locator → coset weight → deep hole), the Seroussi--Roth--Dür radius
gate, the finite closures at GF(16), GF(32), GF(27) and `q=49`, the
paper-successor map, and the census-rule bookkeeping.  Read-only review; this
file is the only artifact written.

Documents read in full: the C973 card, `c973-2026-08-26-first-lucas-boundary.md`,
`c973-2026-08-26-characteristic-seven-closure.md`,
`c973-2026-08-27-r11-gf16-pointed-closure.md`,
`c973-2026-08-27-r11-gf32-pointed-closure.md`,
`c973-2026-08-28-gf27-switch-probe.md` (§1--§4, §8),
`c973-2026-08-26-paper-successor-map.md`.  Also consulted for cross-checking:
the committed certificates and replay scripts, `notes/2026-07-23-c531-...py`,
`c973-2026-08-26-simultaneous-marker-theorem.md` §5, and the manuscript
sections `01-introduction.tex`, `03-dictionary.tex`, `06-high-weight-cosets.tex`,
`07-recursive-carriers.tex` (for the exact form of the imported radius gate).

---

## 1. Summary verdict

The mathematical chain is sound and, where I could test it, correct.  The
dictionary, the radius promotion, the characteristic-seven module reduction and
its seven `q=49` certificates, and the whole GF(27) 402M-class sweep all
survive a hostile independent re-derivation.

**One finding is severe and it is an evidence failure, not a mathematical one.**
The GF(16) and GF(32) pointed certificates are built on the wrong group.  Their
replay constructs the "upper Borel" action matrices by calling C531's
`action_entry`, which is the PGL_2 action on **degree-nine** binary forms (the
R10 syndrome space), and then truncates that action to the coordinate slice
`e_3..e_7`, which is not invariant under it (`e_3 ↦ e_2 + e_3`).  The resulting
matrices are not symmetries of the R11 Hankel system that the same script's
`is_locator` checks: on 1,200 independently generated `(syndrome, support)`
pairs, the correct translation matrix is equivariant 1,200 times and C531's
truncated one 9 times.  Consequently the stored 317 and 1,129 "orbit
representatives" meet only **75 of the 317** true Borel orbits at GF(16) and
**135 of the 1,129** at GF(32); projective transport from the committed
representatives covers 12,125 of 69,905 carrier points at GF(16) and 97,345 of
1,082,401 at GF(32).

**Both conclusions are nevertheless true.**  I re-established them
independently: exhaustively over all 69,905 GF(16) carrier points, and with
explicit verified nine-point witnesses for all 1,129 true GF(32) Borel orbits.
So `GF(16)` and `GF(32)` do leave the R11 modular-exception set and the binary
R12 lift stands; but the committed evidence bundles do not prove that, and must
be regenerated with the correct action before any paper or registry cites them.

A striking accident hid the bug: the wrong group has *exactly the same number of
orbits* as the right one at both fields (317 and 1,129), even though the two
groups are not conjugate — their orbit-size multisets differ
(`{1:3, 5:3, 15:17, 16:2, 80:3, 240:289}` versus
`{1:1, 16:4, 20:1, 60:9, 80:5, 120:20, 240:277}` at GF(16)).  Any repair must
therefore re-derive the orbit count from the degree-`r-1` divided-power action,
not check it against 317/1,129.

Secondary: two reports use incompatible conventions for a degree-deficient
locator without saying so; the successor map's evidence-registry instruction
denies a computational dependency that the manuscript asserts; the
"no finite census" rule and its authorized GF(27) exception live in different
places in the card; and a free strengthening of the GF(27) result (pointedness,
hence characteristic-three R12 over GF(27)) is available and unclaimed.

**Repair status.**  The severe finding and most of the secondary ones were
fixed on the same day under a scope expansion; see §7.  Both certificates were
rebuilt on the correct action, both now carry a fail-closed equivariance gate,
and both replays pass from a clean run.  Verdicts 16, 17, 20, 32 and 33 in the
table below describe the state that was reviewed, not the state on disk;
§7 gives the corrected figures and §8 lists what is still open.

---

## 2. Verdict table

| # | Claim (one line) | Verdict | Location |
|---|---|---|---|
| 1 | Locator of degree `d` with `d` distinct rational roots in `W_f` ⟺ syndrome spans ≤ `d` normal-rational-curve points ⟺ coset weight ≤ `d` | ACCEPT | `03-dictionary.tex` Lem. `lem:hankel` |
| 2 | Split-free (no split squarefree degree-`r-2` member) ⟺ deep, gated on radius `r-1` | ACCEPT | `03-dictionary.tex` Cor. `cor:splitfree` |
| 3 | Degree-exactness `r-2` is harmless: a lower-degree split witness pads to degree `r-2` | ACCEPT (unstated) | implicit everywhere |
| 4 | GF(16)'s ten degree-eight witnesses are admissible pointed witnesses | ACCEPT, but convention clash with GF(27) §4.4 | gf16 §2; gf27 §4.4 |
| 5 | Seroussi--Roth range `2 ≤ r ≤ |S| − ⌊(q−1)/2⌋` is implied by `q ≥ Q*_{r,s}` | ACCEPT | `06-high-weight-cosets.tex` l.54 |
| 6 | Full-support form `r ≤ ⌊q/2⌋+2` agrees with the cofinite form at `s=0` | ACCEPT | `07-recursive-carriers.tex` `prop:upper-radius` |
| 7 | Seroussi--Roth's even-`q`, dimension-three exception is excluded because `r ≥ 6` | ACCEPT | same |
| 8 | Dür/Kaipa completeness ⟺ covering-radius equivalence as cited | UNVERIFIED (primary sources not consulted) | same |
| 9 | Deep-hole count `q(q+1)^2/2`, and `(q−1)s(2q+1−s)/2` for `s>0` | ACCEPT (both re-derived) | `01-introduction.tex` `thm:main` |
| 10 | char-7 R11 carrier `P<e_4,e_5,e_6> ≅ P(Γ^2 E)`, three discriminant orbits, five pointed orbits | ACCEPT | char7 §2 |
| 11 | char-7 R12 carrier `P<e_5,e_6>` is the standard module, two pointed orbits | ACCEPT | char7 §3 |
| 12 | The `q=49` nonsplit representative `(1,0,15)` is genuinely nonsplit | ACCEPT | char7 §2 |
| 13 | The seven `q=49` certificates satisfy the exact apolarity system and avoid their forbidden roots | ACCEPT (re-verified) | char7 §4 |
| 14 | char-7 R12/R13 propagation by one-marker lifting; R14 carrier empty | ACCEPT | char7 §6 |
| 15 | `s`-pointed inequalities `q > 114+12s`, `q+1−2√q > 38+6s` hold at `q=343` for `s ≤ 19` | ACCEPT | char7 §5 |
| 16 | GF(16): the 317 stored records are a complete marked-orbit quotient | **BROKEN** (wrong group; 75/317) | gf16 §2--§3 |
| 17 | GF(32): the 1,129 stored records are a complete marked-orbit quotient | **BROKEN** (wrong group; 135/1,129) | gf32 "Exact quotient proof" |
| 18 | GF(16)/GF(32) R11 carriers are pointedly shallow; both leave the exception set | ACCEPT (re-proved here by other means) | gf16 §1, gf32 "Result" |
| 19 | Binary R12 shallow over GF(16)/GF(32) by one-marker lifting | ACCEPT, given #18 | gf16 §1, gf32 |
| 20 | Compression audit: "503 of 1,129" and "168 of 317" orbits missed | **BROKEN as stated** (orbit-indexed under the wrong group); qualitative negative survives | gf32 "Structural-compression audit" |
| 21 | GF(27): `402,321,277 = (27^7−1)/26 = 20440·19683 + 757`, stratum sizes, rank split `784 = 28^2` | ACCEPT | gf27 §8 |
| 22 | GF(27) geometry: 117 lines, 39 planes, 4 planes per line, 1,404 candidates, `λ^4+λ+1=0`, one `λ=1` plane per line | ACCEPT (re-derived) | gf27 §1, §3 |
| 23 | GF(27) minimum profile `1326/156/546/78` at the 27 minimizers | ACCEPT (re-derived on 6 of them) | gf27 §4.4, §7 |
| 24 | GF(27) 200-witness sample: nine distinct roots, both Hankel equations | ACCEPT (re-verified) | gf27 §8.4 |
| 25 | "the sweep is the whole projective space … holds a fortiori on the maximal carrier" | REPAIRABLE (the swept set *equals* the carrier) | gf27 §8.1 |
| 26 | GF(27) result is stated unpointed; pointedness is free and unclaimed | REPAIRABLE (missed strengthening) | gf27 §8.1, card |
| 27 | R11 exception set `{16,27,32,64}` | ACCEPT, but admissibility `r ≤ q+1−s` is never stated in the C973 notes | char7 §6 |
| 28 | Successor map thresholds `28,35,42,50,56` → prime powers `29,37,43,53,59` | ACCEPT (recomputed) | map §1 |
| 29 | `Q*_r = 6r−16+⌊2√(6r−18)⌋` is exactly `D+2+⌊2√D⌋` for `D = 6r−18` | ACCEPT | map §1, boundary (5) |
| 30 | Empty-carrier criterion: for `r ≥ p+2`, empty ⟺ `r−1` or `r` has a single nonzero base-`p` digit | ACCEPT (verified `p ≤ 11`, `r−2 ≤ 399`) | map §3 |
| 31 | Abundance corollary `≥ q^{r−4}/(r−2)! − O_r(q^{r−9/2})` | ACCEPT (exponents and multiplicity re-derived) | map §5 |
| 32 | "Evidence registry: no computation supports the arbitrary-`r` escape" | **REPAIRABLE overclaim** — the manuscript's own proof cites a Gröbner-elimination certificate for the reduced terminal carrier | map §6 |
| 33 | Successor map is current with the manuscript | REPAIRABLE (stale: the manuscript already carries the cofinite `Q*_{r,s}` and the `s>0` shells) | map §1 |
| 34 | "No finite census" rule and the authorized GF(27) exception are recorded consistently | REPAIRABLE (exception only in the status header and queue row; §3 and the acceptance rules still read as a blanket prohibition) | card |
| 35 | GF(27) report header "measurements only, no new proof" versus §8 "What was certified" | REPAIRABLE (label mismatch) | gf27 header vs §8.1 |
| 36 | Queue row "GF(16)/GF(32)/GF(64) POINTED CLOSURES COMPLETE" | REPAIRABLE (two of the three rest on the broken bundles; GF(64) still carries a named open audit) | queue l.262 |

---

## 3. Findings by severity

### 3.1 Severe — the GF(16) and GF(32) marked quotients use a non-symmetry (#16, #17)

**What the certificates do.**  `c973-r11-gf16-pointed-quotient-replay.py` builds
its two "Borel generators" through

```python
C531_PATH = ROOT / "notes/2026-07-23-c531-degree-nine-lucas-carrier-pgl2-strata.py"
INDICES = tuple(range(3, 8))
def matrix(matrix_data):
    return tuple(tuple(action_entry(source, target, matrix_data) for target in INDICES)
                 for source in INDICES)
```

and the GF(32) replay imports the same builder.  C531's `action_entry` is
documented as the *"Coefficient of `x^(9-source) y^source` in target monomial
after substitution"* — the degree-**nine** binary-form action, i.e. the R10
syndrome space, where C531's own carrier is `P<e_2,…,e_7>`.  Restricting
`source`/`target` to `{3,…,7}` silently discards the `e_2` components: under
`[[1,1],[0,1]]`, C531 gives `e_3 ↦ e_2 + e_3` and `e_7 ↦ e_2 + e_3 + e_6 + e_7`.

**Why that is not the R11 symmetry.**  The same file's `is_locator` fixes the
convention unambiguously.  Its `first_shift = 3 - (11 - degree - 1)` produces
`11 - d` equations for a degree-`d` locator, i.e. `ι_g f ∈ Γ^{10-d}` with the
syndrome of divided-power degree `n = r - 1 = 10`.  (I checked the indexing
term by term: the `shift = 3 - l` row is exactly `Σ_m z_{m+3} g_{m+3-l}` for
`l = 0,…,10-d`.  It is the correct apolarity system, including for the
degree-eight records, where it correctly imposes three equations rather than
two.)  The translation symmetry of that system is the degree-10 divided-power
matrix `e_j ↦ Σ_{i≥j} binom(i,j) a^{i-j} e_i`, which does preserve
`<e_3,…,e_7>` because `binom(i,j) ≡ 0 mod 2` for `i ∈ {8,9,10}`, `j ∈ {3,…,7}`.

Measured (script 3 below), on 1,200 `(z,S)` pairs generated independently of the
certificate by choosing a random 9-subset and solving the two Hankel equations
for `z`:

| translation matrix | equivariant with `t ↦ t+1` |
|---|---|
| degree-10 divided-power (correct) | 1200 / 1200 |
| C531 truncated to `e_3..e_7` (used) | 9 / 1200 |

The diagonal generator survives by accident: C531 gives
`diag(λ^6,λ^5,λ^4,λ^3,λ^2)`, which is projectively the correct torus with `λ`
replaced by `λ^{-1}`, and `λ = 2` is primitive, so the *subgroup* is right.
Only the unipotent direction is wrong — which is exactly the direction that
carries the whole reduction.

**Consequence.**  Under the true Borel stabiliser of infinity:

| field | true orbits | stored records | true orbits met | carrier points reached by valid transport |
|---|---:|---:|---:|---|
| GF(16) | 317 | 317 | 75 | 12,125 / 69,905 |
| GF(32) | 1,129 | 1,129 | 135 | 97,345 / 1,082,401 |

So the certificates prove the pointed statement on 17.3 % and 9.0 % of their
respective carriers, not on all of it.

**The conclusions are still true.**  I verified them by routes that do not use
the certificates at all:

* GF(16), exhaustive.  For every subset `S ⊆ GF(16)` with `|S| ≤ 9` I solved the
  correct apolarity system and accumulated the projective solutions.  Every one
  of the 69,905 carrier points is reached: 10,840 already at degree 7, 51,473 at
  degree 8, all 69,905 at degree 9.  Since all supports are finite, this *is*
  the pointed-at-infinity statement, and `<e_3,…,e_7>` is PGL_2-stable
  (`j ↦ 10 − j` maps `{3,…,7}` to itself), so PGL_2 transport gives pointed
  shallowness for every carrier syndrome and every prescribed projective root.
* GF(32), per true orbit.  For each of the 1,129 true Borel-orbit
  representatives I ran a two-point-switch search (seven random roots, solve the
  2×2 system for the completing quadratic, require it to split with distinct
  roots off the seven).  All 1,129 produced an explicit nine-point witness, each
  re-checked against the full apolarity system.

Both stored witness sets are themselves valid: all 317 GF(16) records and all
1,129 GF(32) records satisfy the *complete* apolarity system for their degree
(zero failures).  It is only the quotient and the transport step that fail.

**Repair.**  Regenerate both quotients with the degree-`r−1` divided-power
action.  The five matrix entries are `binom(i,j) mod 2` for `3 ≤ j ≤ i ≤ 7`:

```
e_3 ↦ e_3 + a^4 e_7
e_4 ↦ e_4 + a e_5 + a^2 e_6 + a^3 e_7
e_5 ↦ e_5 + a^2 e_7
e_6 ↦ e_6 + a e_7
e_7 ↦ e_7
```

together with `e_j ↦ λ^j e_j`.  Do **not** validate the repair against the
numbers 317 and 1,129: the wrong group has the same orbit counts at both
fields.  Validate it against equivariance — check that
`is_locator(z, S) ⟺ is_locator(z·M, φ(S))` for the generators, which is a
three-line assertion the current replays lack.  Adding that assertion is the
single highest-value hardening for this family of certificates.

**Blast radius.**  I checked the other two finite bundles: the `q=49` generator
constructs its orbit representatives by hand from the `Γ^2 E` module structure
and never touches C531, and the GF(27) probe sweeps every class with no group
reduction at all.  Both are immune.  `c973-binary-pointed-support-structure.py`
(the compression audit) reports orbit-indexed numbers and is affected — see 3.3.

### 3.2 Moderate — the point at infinity is handled under two different conventions (#4)

The GF(16) report accepts ten pointed witnesses of degree eight; the GF(27)
report §4.4 states that "an eight-affine-plus-infinity locator is excluded by
the problem statement".  Read carelessly, the second invalidates the first.
They are in fact about different objects and both are right:

* a *degree-nine binary form vanishing at infinity* satisfies only the two
  equations `E1 = E2 = 0`, has infinity in its support, and is correctly
  excluded by GF(27) §4.4;
* a *degree-eight apolar form* satisfies three equations
  (`ι_g f = 0` in `Γ^2`), has eight finite roots and no root at infinity, and
  certifies coset weight ≤ 8.

The GF(16) certificate imposes the three-equation version for its degree-eight
records — I re-checked all ten — so they are the second kind.  Nothing is
broken, but the two reports must say which object they mean; the distinction is
exactly two versus three linear conditions and is invisible in the prose.

The same paragraph should record the padding step that the manuscript's
degree-exactness convention needs: a split squarefree witness of degree `d < r−2`
extends to degree `r−2` by adjoining any `r−2−d` further distinct rational
points, which exist because `r − 2 ≤ q − 1` and, in the pointed case, because
the prescribed point can be avoided (`GF(16)`: 8 spare finite points after the
8 used).  The R12 lifts inherit this: multiplying a degree-eight witness by one
marker gives degree nine, not ten, and needs one padding point.

### 3.3 Moderate — the compression audit's negatives are stated per orbit (#20)

`c973-2026-08-27-r11-gf32-pointed-closure.md` reports that the affine
three-space-plus-one-root family "misses 503 of the 1,129 GF(32) marked orbits"
and "168 of 317" at GF(16).  Those counts are indexed by the broken quotient.
Recomputing the GF(16) case under the correct group: the 240 supports of that
shape cover 42,481 of 69,905 carrier points and meet 178 of the 317 true orbits,
i.e. they miss 139, not 168.  The qualitative conclusion — the family does not
cover the carrier, so it is not a hidden small support atlas — is untouched and
I confirm it.  Restate both negatives as point counts, which are
group-independent, or recompute them after the quotient repair.

### 3.4 Minor — evidence-level and bookkeeping mismatches

* **#32 (map §6).**  "Evidence registry: no computation supports the
  arbitrary-`r` escape or digit-stripping theorems."  The manuscript states the
  opposite for the escape theorem: *"The only computer-algebra input to the
  uniform theorem is the exact reduced terminal-carrier decomposition in
  Proposition~\ref{prop:reduced-terminal-carrier}, verified by the registered
  Gröbner-elimination certificate."*  The escape proof uses that proposition to
  make the selector nonzero.  Following the map's instruction would delete a
  real registry edge.  Restrict the sentence to the digit-stripping theorems.
* **#25 (gf27 §8.1).**  The maximal R11 characteristic-three carrier *is*
  `P<e_2,…,e_8> = PG(6,27)` (Pascal row 9 mod 3 is nonzero only at `j ∈ {0,9}`),
  so the swept set equals the carrier.  "A fortiori" suggests a strict
  superset that does not exist.
* **#34 (card).**  The card's §3 still says "Do not replace this proof by an
  unstructured field census.  Small exact computations are permitted only as
  falsification tests or as compact certificates below a theorem-derived
  bound", and the acceptance rules still say "No ambient `PG(r-1,q)` census …
  counts as progress".  The 402M-class sweep is neither small nor below a
  theorem-derived bound.  The 2026-08-28 authorization appears only in the
  status header and the queue row.  Move it into §3 and the acceptance rules so
  the rule and its exception are read together; note there that the sweep is a
  *carrier* census (`PG(6,27)`), not the ambient `PG(10,27)` the rule forbids.
* **#35.**  The GF(27) report's header says "computational probe report;
  measurements only, no new proof" while §8.1 opens "What was certified" with a
  quantified theorem.  Split the header, or move §8 into its own dated
  certificate report.
* **#36.**  The queue row asserts three completed pointed closures; two rest on
  the bundles broken above and the third (GF(64)) ends with "Explicit quartic
  divisors on the two worst fibres remain as an independent audit".
* **#27.**  Every closure statement is qualified by "admissible", but no C973
  note defines it.  It is the manuscript's `r ≤ q+1−s`; at `r = 11, s = 0` this
  is `q ≥ 11`, which is what makes `{16,27,32,64}` the complete exception list
  (`GF(2),GF(4),GF(8),GF(9)` carry no R11 code at all, and every other field
  either has characteristic `> r−2` or exceeds the closure threshold).  One
  sentence in the first-Lucas-boundary report would close this.
* **char-7 trust boundary.**  The report says the generator "replays every
  nested locator through the independent public `verify` command".  That
  verifier is part of the same frozen toolkit as the search; it is an
  independent *code path*, not an independent implementation, unlike the GF(16)
  and GF(32) bundles which ship a separate replay.  I supplied the missing
  independent replay (§4 below, all seven pass); adding it to the bundle would
  make the wording accurate.

### 3.5 Free strengthening not claimed (#26)

The GF(27) sweep certifies a locator with **nine finite roots** for every class
of `PG(6,27)`.  Since the carrier is PGL_2-stable and `W_f` is PGL_2-equivariant
(the manuscript's Hankel criterion says so explicitly), normalising an arbitrary
prescribed root to infinity turns that into the *pointed* statement at no cost:
for every carrier syndrome and every prescribed projective root there is a split
squarefree nonic avoiding it.  One-marker lifting then closes the
characteristic-three R12 carrier over GF(27) as well, exactly as GF(16) and
GF(32) do for the binary R12 block.  Neither the report nor the card claims
either.  This is two extra results for two sentences.

---

## 4. Computations I ran

All in the session scratchpad, Python 3 standard library only, no toolkit and
no project modules except where noted.

1. **Independent Borel-orbit count.**  Built GF(16) and GF(32) from their stated
   moduli, built the translation matrix from `binom(i,j) mod 2` for
   `3 ≤ j ≤ i ≤ 7` and the torus `e_j ↦ λ^j e_j`, and closed the projective
   carrier under both.  Result: 69,905 points → **317** orbits; 1,082,401
   points → **1,129** orbits; identical under the transposed (contragredient)
   convention.  This confirms the two headline orbit counts by a route that
   shares nothing with the certificates.
2. **Full apolarity check of every stored witness.**  Re-derived the root
   polynomial of each stored support and imposed all `11 − d` equations.  All
   317 GF(16) records (307 of degree nine, 10 of degree eight) and all 1,129
   GF(32) records pass with zero failures.
3. **Equivariance test.**  Generated 1,200 `(z, S)` pairs independently of the
   certificates and tested `is_loc(z,S) ⟹ is_loc(z·M, S+1)`.  Correct matrix
   1200/1200; C531 truncated matrix 9/1200.  Also on the 317 stored records:
   1200-style test gives 317/317 and 2/317 respectively.
4. **Coverage.**  Mapped every stored representative into the true orbit
   partition: 75/317 orbits and 12,125/69,905 points at GF(16); 135/1,129 and
   97,345/1,082,401 at GF(32).
5. **GF(16) exhaustive existence.**  For all `S ⊆ GF(16)`, `|S| ≤ 9`, solved the
   apolarity system and unioned the projective solution sets.  All 69,905
   carrier points are covered (10,840 at degree ≤ 7; 51,473 at degree ≤ 8).
6. **GF(32) per-orbit existence.**  Two-point-switch search on each of the 1,129
   true orbit representatives; 1,129/1,129 succeeded, each witness re-verified
   against the full apolarity system.
7. **Orbit-size multisets.**  Certificate group `{1:3, 5:3, 15:17, 16:2, 80:3,
   240:289}` versus true Borel `{1:1, 16:4, 20:1, 60:9, 80:5, 120:20, 240:277}`
   at GF(16) — the two groups are not conjugate, so the shared orbit count is a
   coincidence.
8. **`q=49` independent replay.**  Reimplemented `GF(49) = F_7[x]/(x^2+1)` in
   its stated base-7 integer encoding and checked all seven records: monic
   degree `r−2`, distinct roots, both apolarity equations zero, forbidden root
   disjoint from the support, and the normalised syndrome projectively equal to
   the requested one.  All pass.
9. **`q=49` orbit arithmetic by hand.**  Verified the module identification
   (`f_0,f_1,f_2 = e_4, 5e_5, e_6` gives `f_0 ↦ f_0 + a f_1 + a^2 f_2`,
   `f_1 ↦ f_1 + 2a f_2` from `binom(5,4)=5`, `binom(6,4)≡1`, `binom(6,5)=6`,
   and `binom(i,j) ≡ 0 mod 7` for `i ∈ {7,…,10}`), the exact invariance of
   `Δ = B^2 − AC`, the stratum sizes `50 + 1225 + 1176 = 2451`, the five pointed
   orbits and the two R12 ones, the correspondence `(A,B,C) ↦ AX^2 − 2BX + C`
   which makes `(1,0,6)` split with roots `{1,6}` and `(1,0,0)` a double root at
   `0`, and the nonsquare norm `N(1+2x) = 5`.
10. **GF(27) geometry and profile.**  Rebuilt `GF(27) = F_3[x]/(x^3−x−1)` from
    scratch: 117 affine `F_3`-lines, 39 planes, exactly 4 planes per line, 1,404
    switch candidates; `λ = κ/d^6` satisfies `λ^4+λ+1 = 0` on all 468
    (line, plane) incidences with exactly one `λ = 1` plane per line and
    `λ ∈ {1,9,13,16}`.  Reproduced the switch profile `(1326, 156, 546, 78)` for
    `z = e_3` and for five more of the 27 listed minimizers, each exactly.
11. **GF(27) witness sample.**  Re-verified all 200 rows of
    `certify-witness-sample.tsv` (nine distinct roots, monic degree nine, both
    Hankel equations): zero failures.  Plus 150 further uniformly random
    projective classes: `n_good ∈ [276, 398]`, none zero.
12. **GF(27) arithmetic.**  `(27^7−1)/26 = 402,321,277 = 20440·19683 + 757`;
    `28·19683 = 551,124`; `756·19683 = 14,880,348`; `19656·19683 = 386,889,048`;
    rank-one quotient points `(q+1)^2 = 784`.  All consistent.  Note the §8.3
    table's "total 20,441 quotient points" counts the zero quotient alongside
    the 20,440 points of `PG(3,27)`.
13. **Threshold arithmetic.**  `Q*_r = 6r−16+⌊2√(6r−18)⌋` equals
    `D+2+⌊2√D⌋` for `D = 6r−18 = 12+6(r−5)`, matching the boundary report's
    `1+⌊(1+√48)^2⌋ = 63` at `r=11` and `70` for the R12 characteristic-five
    budget 54.  R6--R10: `28,35,42,50,56`; least prime powers at or above:
    `29,37,43,53,59`.
14. **Deep-hole counts.**  `q(q+1) + (q^2−q)(q+1)/2 = q(q+1)^2/2` for tangent
    plus conjugate-secant points; `(q−1)[s(q+1−s) + binom(s,2)] =
    (q−1)s(2q+1−s)/2` for secants meeting the deleted set.  Both match.
15. **Empty-carrier criterion.**  For `p ∈ {2,3,5,7,11}` and `d = r−2` from `p`
    to 399, "Pascal row `d` has no two adjacent zeros mod `p`" agrees with
    "`d+1` or `d+2` has a single nonzero base-`p` digit" in every case.
16. **Seroussi--Roth range.**  `q ≥ Q*_{r,s} ⟹ q ≥ 2(r+s)−3` (needs
    `4(r+s) ≥ 13`, true for `r ≥ 6`), hence `r ≤ (q+3)/2 − s`, and
    `q+1−s−⌊(q−1)/2⌋ ≥ (q+3)/2 − s` for both parities.  The two forms used in
    §06 and §07 of the manuscript coincide at `s = 0`.
17. **Abundance exponents.**  `6·G·L/(m+3)!` with `G ~ q^m`, `L ~ q/6`,
    `m = r−5` gives leading term `q^{r−4}/(r−2)!`; the dominant correction is
    `O(q^{m+1/2}) = O(q^{r−9/2})`, which exceeds the `O(q^{r−5})` selector
    correction.  The multiplicity `binom(m+3,m)·m! = (m+3)!/6` is right.
18. **Checksum gates.**  `sha256sum -c` passes for the GF(16), GF(32) and `q=49`
    bundles; the GF(27) `src/main.rs`, `Cargo.toml`, `verify_witnesses.py`,
    `certify-summary.txt` and `certify-unsaturated.tsv` hashes match the report
    table.  `git status` on `notes/reed-solomon-tasks/` is clean.

---

## 5. What I took on trust

* **Seroussi--Roth Thm. 1 and Dür's equivalence as primary sources.**  I checked
  only that the manuscript's two stated forms of the range hypothesis are
  mutually consistent, that they are implied by `q ≥ Q*_{r,s}`, and that the
  `k = 3` even-`q` exception is excluded by `r ≥ 6`.  I did not consult the
  papers, so the exact hypotheses of the imported theorems remain UNVERIFIED
  here; gate 3 of the successor map ("coding review of the improved threshold
  against the radius range") is still open on that point.
* **ZWK2020 Thms I.5--I.6**, used to give weight `r−1` on off-curve tangent and
  conjugate-secant points, i.e. the lower half of the radius statement.
* **C820's reduced terminal carrier and its Gröbner certificate**, C536's
  coherent-Fano theorem, and C530/C531/C578/C620's binary constructions.  I
  treated their statements as given; only C531's `action_entry` was examined,
  and it is correct for its own R10 setting.
* **The arbitrary-`r` simultaneous-marker theorem itself.**  I checked its
  numerology (thresholds, deletion budget, abundance exponents) but not its
  geometry; the two-seam reconstruction already lists five inherited inputs left
  for external reconstruction.
* **The GF(64) chain** in the card summary — trace balance, forced-root surface
  stratification, the cubic-resolvent 3-isogeny.  Out of scope here.
* **The GF(27) sweep's global claims beyond what I sampled.**  I re-derived the
  geometry, the extremal profile, 200 declared witnesses and 150 random classes;
  I did not re-run the 402M-class sweep.
* **The Rust probe's fibre-specialised inner loop.**  Its agreement with the
  general scan on 2,000 cross-checked classes is the probe's own check, not
  mine; my 150 random classes were computed with an independent implementation
  and agreed with the reported distribution.

---

## 6. Recommended actions, in priority order

1. Regenerate the GF(16) and GF(32) marked quotients with the degree-`r−1`
   divided-power action, and add an equivariance assertion to both replay
   scripts so a wrong action can never pass again.  Until then, cite neither
   bundle in the manuscript, the evidence registry, or the queue.  The
   conclusions survive — §4 items 5 and 6 above establish them — so this is a
   rebuild, not a retraction.
2. Restate the compression-audit negatives as point counts, or recompute them
   after step 1.
3. Add the infinity/degree-deficiency convention paragraph (3.2), including the
   padding step used by the R12 lifts.
4. Fix the successor map's evidence-registry sentence (#32) and refresh the map
   against the manuscript's current cofinite theorem (#33).
5. Claim the free GF(27) pointed statement and the characteristic-three R12
   closure over GF(27) (3.5).
6. Reconcile the census rule with its authorization inside the card's §3 and
   acceptance rules, and correct the two status labels (#35, #36).
7. Ship an implementation-independent replay for the `q=49` bundle, or reword
   its "independent" claim.

---

## 7. Applied repairs (2026-08-28)

Recommendations 1--4 and 6 were applied under an explicit scope expansion.
Recommendations 5 and 7, and the card-side half of 6, fall outside the
authorized paths and are left as open items in §8.

### 7.1 Certificates rebuilt (recommendation 1)

Both binary quotients were regenerated on the degree-`r-1` divided-power
upper-Borel action.  The generators no longer depend on C531 at all: they carry
their own field arithmetic and build the translation matrix directly from
`binom(i,j) mod 2`.  Both the generator and the replay now run a fail-closed,
seeded 1,000-pair equivariance gate (`splitmix64`, seed `0xC973_2026_0828`)
asserting `is_locator(z, S) == is_locator(z.M, phi(S))` for every recorded
generator, on a syndrome drawn from the kernel of `S` and on an independent
uniform syndrome; the generator additionally asserts the structural fact that
makes the slice a submodule, `binom(i,j) = 0 mod 2` for `i in {8,9,10}` and
`j in {3,...,7}`.  A negative control confirms the gate rejects the 2026-08-27
action on its first pair.

The replays share no code with the generators, never call the toolkit, rebuild
the field and the action from scratch, recompute the full orbit partition (on
packed integers, so GF(32) peaks at 112 MB), require the stored representatives
to be exactly the orbit minima, re-verify every stored support against the
complete apolarity system `iota_g f = 0` in `Gamma^(10-d)`, and re-derive the
declared orbit, witness, and degree-histogram counts rather than trusting them.

| quantity | GF(16) before | GF(16) after | GF(32) before | GF(32) after |
|---|---:|---:|---:|---:|
| marked orbits | 317 (wrong group) | 317 (true Borel) | 1,129 (wrong group) | 1,129 (true Borel) |
| true orbits actually certified | 75 | 317 | 135 | 1,129 |
| carrier points covered | 12,125 / 69,905 | 69,905 / 69,905 | 97,345 / 1,082,401 | 1,082,401 / 1,082,401 |
| degree-nine witnesses | 307 | 315 | 1,129 | 1,129 |
| degree-eight witnesses | 10 | 2 | 0 | 0 |
| orbits with no pointed locator | 0 | 0 | 0 | 0 |
| largest stored search count | 856,832 | 333,918 | 12,866 | 139 |
| equivariance pairs asserted | 0 | 1,000 | 0 | 1,000 |

Witness provenance after the rebuild: GF(16) 314 orbits from the public
`simultaneous-locator --forbid-infinity`, 2 from the public `classify`
locator certificate, 1 from the generator's own deterministic two-point switch;
GF(32) all 1,129 from `simultaneous-locator --forbid-infinity`.  The two
GF(16) degree-eight orbits are `e_7` with support `[8,…,15]` and
`(0,0,1,1,8)` with support `[6,…,13]`, both affine three-space cosets, both
satisfying the three-equation degree-eight system.

Deterministic regeneration takes 17 s (GF(16)) and 95 s (GF(32)); the replays
take 1 s and 20 s.

### 7.2 Notes corrected (recommendations 2 and 3)

Each closure note gained a **Review repair (2026-08-28)** section carrying the
diagnosis, the equivariance measurement, the coverage shortfall, the reason the
conclusion survives, the corrected tables, the replay commands, and the new
hashes.  Header status lines now say the quotient was rebuilt.  Superseded
figures are tagged `[corrected 2026-08-28]` in place rather than overwritten,
including the GF(16) degree table, its largest search count, its two mystery
ledger rows and `tt` paragraph, and the GF(32) search count and ledger rows.
Both repair sections state that the discarded group has the same orbit count,
so a future change must be validated against equivariance and never against
317 or 1,129.

The infinity/degree-deficiency convention is now stated once, in the GF(16)
note §2, and applied in both replays: a stored support of size `d < r-2` is
held to the full `11-d`-equation system, so it certifies a coset representation
on `d` finite points with no infinity column and pads to degree exactly nine by
adjoining spare finite points.  That is a different object from a degree-nine
form vanishing at infinity, which satisfies only two equations; the GF(27)
report's §4.4 exclusion is about the second object and does not bear on the
degree-eight records.  The `is_locator` docstring in the GF(16) replay carries
the same paragraph.

The compression-audit negatives were recomputed.  The audit script reads the
certificates, so rerunning it on the rebuilt bundles emits corrected numbers
with no edit to the script: the affine three-space-plus-one family now misses
62 of the 1,129 GF(32) orbits (was 503) and 139 of the 317 GF(16) orbits (was
168), and the witness supports occupy 882 affine divisor types with largest
multiplicity 11 (was 795 and 14).  Both notes now also give the
group-independent form, which is how such negatives should be stated: the
family covers 1,052,513 of 1,082,401 GF(32) carrier points and 42,481 of 69,905
GF(16) carrier points.  The GF(16) figure agrees exactly with the independent
computation in §4 item 5 of this review.

### 7.3 Successor map corrected (recommendations 4 and 6, paper half)

* The evidence-registry sentence now says what is proved: no computation
  supports the digit-stripping theorems, while the arbitrary-`r` escape theorem
  has exactly one computational dependency that must stay registered — the
  reduced terminal-carrier decomposition and its Gröbner-elimination
  certificate, which is what makes the terminal selector nonzero.
* A new evidence-registry bullet tells the successor to register the three
  finite small-field closures separately, to say for each whether the
  quantifier comes from an orbit reduction plus transport or from an exhaustive
  sweep, to record the GF(27) sweep as a user-authorized certificate closure
  under the C578 `q=64` precedent covering the carrier `PG(6,27)` rather than
  the ambient `PG(10,27)` the task rule forbids, and to keep the
  certificate-free switch lemma listed as open.
* The retention list now names the repaired binary certificates, forbids citing
  the 2026-08-27 bundles, and requires any reported orbit count to name its
  group.
* A staleness warning at the top records that the manuscript's `thm:main`
  already carries the cofinite `Q*_{r,s}` and the `s>0` shells, so §1 of the map
  is the `s=0` specialization of what is already written.
* Successor gate 11 was added: every orbit-quotient certificate the paper cites
  must carry a fail-closed equivariance assertion, because an orbit count is
  not evidence that the group is right.

### 7.4 Changed paths and hashes

| path | SHA-256 |
|---|---|
| `notes/reed-solomon-tasks/c973-r11-gf16-pointed-quotient.py` | `81d2faa0679077fb007353dce5803768d9ee2a5e4bdc9b1d2edbfff6fe85498f` |
| `notes/reed-solomon-tasks/c973-r11-gf16-pointed-quotient-replay.py` | `3b4995e57f670ba98b7f774059733f41ee08807ecc64a45234dccf344e5c8b01` |
| `notes/reed-solomon-tasks/c973-r11-gf16-pointed-quotient.json` | `fa7a8c21511bb923ba52ef983d5626851de78943409d684476a23072dd08268f` |
| `notes/reed-solomon-tasks/c973-r11-gf16-pointed-quotient.sha256` | manifest of the three above |
| `notes/reed-solomon-tasks/c973-r11-gf32-pointed-quotient.py` | `5c89bd64f9d80f52d1d2d419f373a5bcc00e8a8966f477c3ab4b420170bf208e` |
| `notes/reed-solomon-tasks/c973-r11-gf32-pointed-quotient-replay.py` | `87f37d494f97dbd837ff5c843ed54579d9ec7c5617add6b39b4cc52b5bac2a30` |
| `notes/reed-solomon-tasks/c973-r11-gf32-pointed-quotient.json` | `4b7ff0d8eddcd71819657b7cd3cd724ecd6ceedd83c6a36acb67601633c7979f` |
| `notes/reed-solomon-tasks/c973-r11-gf32-pointed-quotient.sha256` | manifest of the three above plus the unchanged audit script |
| `notes/reed-solomon-tasks/c973-2026-08-27-r11-gf16-pointed-closure.md` | `babee3b02376ae47ac6dea188160f94b6cabd93143dbb19dc9d3873e0b718a6c` |
| `notes/reed-solomon-tasks/c973-2026-08-27-r11-gf32-pointed-closure.md` | `58684dd75fb51caa5b4628dae325e79cf08792a78b3be71e8e722dbe8cb2c6bd` |
| `notes/reed-solomon-tasks/c973-2026-08-26-paper-successor-map.md` | `2b4b10c1eea0fee50f14d20401dbc1e1dcde95bdda2b4305c61fea79a6d7b012` |
| `notes/reed-solomon-tasks/c973-2026-08-28-review-coding.md` | this file |

`c973-binary-pointed-support-structure.py` is unchanged
(`bd2503d9f22026c103d2f2aa59c692de9b5fd561c8a846acd903d5bb6001da2d`); it reads
the certificates, so it now reports the corrected numbers without an edit.
Nothing outside `notes/reed-solomon-tasks/` was touched, and no git command was
run.

### 7.5 Clean-run verification

```text
python3 notes/reed-solomon-tasks/c973-r11-gf16-pointed-quotient.py --check
  -> C973 GF(16) pointed quotient: PASS (317 orbits)
python3 notes/reed-solomon-tasks/c973-r11-gf16-pointed-quotient-replay.py
  -> C973 independent GF(16) replay: PASS (317 pointed orbits,
     317 verified finite witnesses, degrees {'8': 2, '9': 315},
     1000 equivariance pairs)
python3 notes/reed-solomon-tasks/c973-r11-gf32-pointed-quotient.py --check
  -> C973 GF(32) pointed quotient: PASS (1129 orbits)
python3 notes/reed-solomon-tasks/c973-r11-gf32-pointed-quotient-replay.py
  -> C973 independent GF(32) replay: PASS (1129 pointed orbits,
     1129 verified finite witnesses, degrees {'9': 1129},
     1000 equivariance pairs)
sha256sum -c c973-r11-gf16-pointed-quotient.sha256   -> 3 OK
sha256sum -c c973-r11-gf32-pointed-quotient.sha256   -> 4 OK
```

---

## 8. Still open after the repair

1. **The GF(27) pointed strengthening is available and unclaimed.**  It follows
   directly from already-recorded outputs, but the switch-probe report is
   outside the authorized edit paths, so it is recorded here instead.  The
   evidence is `c973-gf27-switch-probe/out/certify-summary.txt`, whose
   `unsaturated classes (no split nine-affine locator at all): 0` and
   `classes with n_good = 0 (fallback invocations): 0` lines cover all
   402,321,277 classes, together with
   `c973-gf27-switch-probe/out/certify-unsaturated.tsv`, which is header-only,
   and the per-fibre minimum column of
   `c973-gf27-switch-probe/out/certify-quotient-rows.tsv`, which is at least 78
   in all 20,440 rows.  Every witness there has nine roots in `GF(27)`, hence
   avoids infinity.  The R11 characteristic-three carrier `P<e_2,...,e_8>` is
   `PGL_2`-stable (translation preserves it because `binom(i,j) = 0 mod 3` for
   `i in {9,10}` and `j in {2,...,8}`, and `j -> 10-j` maps `{2,...,8}` to
   itself), and `W_f` is `PGL_2`-equivariant by the manuscript's Hankel
   criterion.  Normalising an arbitrary prescribed root to infinity therefore
   upgrades the sweep to the pointed statement at no computational cost, and
   one-marker lifting then closes the characteristic-three R12 carrier over
   `GF(27)` exactly as the binary bundles close binary R12.  Two results for
   two sentences, in `c973-2026-08-28-gf27-switch-probe.md` §8.1 and the card.
2. **Census-rule bookkeeping in the card.**  The paper-side half was applied in
   the successor map.  The task card's §3 and its acceptance rules still read
   as a blanket prohibition on a finite census while the 2026-08-28
   authorization appears only in the status header and the queue row; the card
   is outside the authorized edit paths.
3. **The `q=49` bundle still has no implementation-independent replay.**  Its
   generator calls the toolkit's own `verify`, which is a separate code path
   but the same implementation.  The seven records were re-verified from
   scratch during this review (§4 item 8); folding that check into the bundle
   would make the wording in `c973-2026-08-26-characteristic-seven-closure.md`
   §4 accurate.
4. **Queue and card status lines** still assert three completed binary pointed
   closures without distinguishing the rebuilt GF(16)/GF(32) evidence from the
   author-side GF(64) chain, which retains a named open audit.
5. **Primary-source verification of Seroussi--Roth and Dür** remains open, as
   in §5.
