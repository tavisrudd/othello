# C278 — Conditional close of Theorem 12.1's density-½ gap

**Lane**: `dihedral`
**Task**: C278 — close the density-½ gap of the dihedral paper's Theorem 12.1 *conditionally*:
quarantine the classical equidistribution of primes in arithmetic progressions as exactly one
named axiom, then kernel-derive the manuscript conclusion "the P-classes have relative density
1/2 within each torus family" for each of the three legal triple types.

## Scope

Closes the numerical `1/2` value of Theorem 12.1
(`notes/2026-07-12-dihedral-schreier-node-kayles-submission.md`, §12), which C262 had left as a
reported gap (mathlib has qualitative Dirichlet but no quantitative equidistribution). The close
is conditional on a single quarantined classical axiom; everything else is kernel-checked and
consumes the already-committed finite classification in `DihedralSchreier/Density.lean`
(`candidate_coprime`, `candidate_distinct`, `card_P_*`) without weakening or restating it.

The unconditional results in `Density.lean` are untouched and remain axiom-clean; only the new
conditional layer carries the axiom.

## Files

Split into an axiom file plus a consequences file, mirroring the house pattern
(`RepairCodes/Imported.lean` + consumers; `RelativeConicArcs/Q11DyeAxioms.lean`), so the axiom
is structurally isolated and its `#print axioms` audit shows exactly the one import.

- `lean/DihedralSchreier/DensityAxioms.lean` — the single axiom `primes_equidistribute`, plus
  the two counting primitives (`primeCount`, `primeCountMod`) needed to state it. This file
  contains no other mathematical assertion.
- `lean/DihedralSchreier/DensityConditional.lean` — `RelativeDensity`, the residue-set counting
  `primeCountIn` and its class-sum decomposition, the torus-family/P-class residue sets, and the
  headline theorems. Imports `DensityAxioms` and `Density`.
- Both wired into the root `lean/DihedralSchreier.lean`.

## The one axiom and its faithfulness to the classical theorem

```lean
axiom primes_equidistribute
    (m : ℕ) (hm : 1 ≤ m) (a : ZMod m) (ha : IsUnit a) :
    Tendsto (fun x => (primeCountMod m a x : ℝ) / (primeCount x : ℝ))
      atTop (nhds ((Nat.totient m : ℝ)⁻¹))
```

where `primeCount x = #{p < x : p prime}` and `primeCountMod m a x = #{p < x : p prime,
p ≡ a (mod m)}` (residue read in `ZMod m`).

**Faithfulness (the load-bearing trust claim).** This is exactly the prime number theorem for
arithmetic progressions (Davenport, *Multiplicative Number Theory*, 3rd ed., GTM 74, Chs. 20–22):
for `gcd(a, m) = 1`, `π(x; m, a) ∼ (1/φ(m)) · π(x)`, i.e. the primes are equidistributed among
the `φ(m)` reduced residue classes mod `m`, each with natural density `1/φ(m)` among the primes.
Point by point:

- **Reduced-class hypothesis.** `IsUnit a` in `ZMod m` is exactly `gcd(a, m) = 1`
  (`ZMod.isUnit_iff_coprime`); the axiom says nothing about non-reduced classes.
- **The asserted value.** `π(x;m,a)/π(x) → 1/φ(m)` is the natural-density normalization of
  PNT-in-AP. The manuscript states the *Dirichlet*-density form; natural density (this axiom)
  implies the Dirichlet-density statement with the same value, and the manuscript itself cites
  "the prime number theorem for arithmetic progressions, equivalently its standard
  Dirichlet-density consequence." So the axiom is the textbook theorem the paper invokes.
- **No more than the textbook fact.** The axiom carries *no* effective error term
  (no Siegel–Walfisz remainder), *no* uniformity in `m` (it is a limit for each fixed `m`), and
  *no* statement about a union of classes or about non-prime moduli. A referee can check it is a
  single fixed-modulus, fixed-reduced-class asymptotic — precisely PNT-in-AP, nothing stronger.
- **Why it is quarantined.** mathlib currently proves only the qualitative Dirichlet theorem
  (`Nat.forall_exists_prime_gt_and_zmodEq`: infinitude in each reduced class), not this
  quantitative equidistribution. When mathlib gains PNT-in-AP the axiom should be replaced by it.

## Definitions

- `RelativeDensity (num den : ℕ → ℕ) (d : ℝ) : Prop := Tendsto (fun x => num x / den x) atTop
  (nhds d)` — relative natural density of the `num`-primes within the `den`-primes.
- `primeCountIn m R x = #{p < x : p prime, (p mod m) ∈ R}` for a residue set `R : Finset (ZMod m)`,
  with `primeCountIn_eq_sum : primeCountIn m R x = ∑ a ∈ R, primeCountMod m a x` (classes are
  disjoint and cover `R`).
- `cls n s : ZMod 4 → ZMod (8n)`, `h ↦ (2·n·h + s : ZMod 8n)` — the residue class of the
  candidate `q = 2·n·h + s` as a function of `h mod 4` (well defined: `h ↦ h+4` shifts `q` by
  `8n ≡ 0`).
- `familyR n s = image cls univ` — the torus family (four residue classes mod `8n`).
- `PR n s Pset = image cls Pset` — the P-classes (image of the P-selection `Pset ⊆ ZMod 4`).

`cls_injective` (four distinct classes) is derived from `candidate_distinct`; `cls_isUnit`
(each class reduced) from `candidate_coprime`; `card_familyR = 4` from injectivity + `card_classes`;
`card_PR = 2` from injectivity + `card_P_*`.

## Headline theorems

General (either sign `s = ±1` via `s^2 = 1`; any 2-element P-selection):

```lean
theorem relative_density_P_eq_half (n : ℕ) (s : ℤ) (hn : 1 ≤ n) (hs : s ^ 2 = 1)
    (Pset : Finset (ZMod 4)) (hP : Pset.card = 2) :
    RelativeDensity (primeCountIn (8 * n) (PR n s Pset))
      (primeCountIn (8 * n) (familyR n s)) (1 / 2)
```

Derivation: each reduced class contributes density `1/φ(8n)` among all primes
(`primes_equidistribute`, summed over a residue set via `primeCountIn_eq_sum`); the family
carries `4/φ(8n)` and the P-classes `2/φ(8n)`; the shared `φ(8n)` cancels in the ratio
`(2/φ)/(4/φ) = 1/2`, so the value never requires computing `φ(8n)`. Genuinely consumes
`candidate_coprime` (reduced), `candidate_distinct` (4 distinct classes), and `Pset.card = 2`.

Three triple-type corollaries, each holding for either sign:

- `relative_density_dodd_nodd` (`P = {1,2}`, via `card_P_dodd_nodd`)
- `relative_density_dodd_neven` (`P = {2,3}`, via `card_P_dodd_neven`)
- `relative_density_deven` (`P = {0,2}`, via `card_P_deven`)

Since the N-selection is the two remaining classes (`card_compl_* = 2` in `Density.lean`), the
same theorem applied to the complement gives the N-density `1/2`.

## Axiom audits

From the full-target build log (`#print axioms`, inline in the sources):

```text
'DihedralSchreier.DensityAxioms.primes_equidistribute' depends on axioms:
  [propext, Classical.choice, Quot.sound, primes_equidistribute]
'DihedralSchreier.DensityConditional.relative_density_dodd_nodd' depends on axioms:
  [propext, Classical.choice, Quot.sound, primes_equidistribute]
'DihedralSchreier.DensityConditional.relative_density_dodd_neven' depends on axioms:
  [propext, Classical.choice, Quot.sound, primes_equidistribute]
'DihedralSchreier.DensityConditional.relative_density_deven' depends on axioms:
  [propext, Classical.choice, Quot.sound, primes_equidistribute]
```

Each headline depends on exactly
`[propext, Classical.choice, Quot.sound, DihedralSchreier.DensityAxioms.primes_equidistribute]`.
No `sorryAx`, no `Lean.ofReduceBool`/`native_decide`. The unconditional `Density.lean` results
were not touched and their axiom profiles are unchanged (dependence only on
`[propext, Classical.choice, Quot.sound]`).

## Build evidence

Full `DihedralSchreier` target, unattended legacy queue (single profile, one thread, cores
20–23), after the foreign RelativeConicArcs lane released the shared build-owner lock:

- Run directory: `/home/tavis/.cache/othello-lean-build/run-20260718-011501-29fbedfa`
- `passed DihedralSchreier {wall_clock 0:12.48, exit_status 0}`, then the trace-only aggregate
  gate; `status.json` state `success`.

Fast inner loop used `lean/scripts/guarded-lean DihedralSchreier/DensityConditional.lean`
(single-file elaboration, exit 0) to iterate two errors before the full build:
`ZMod.val_injective` takes the modulus explicitly (`ZMod.val_injective 4 hv`), and the
`Int.castRingHom` coercion had to be beta-reduced via `simp only [Int.coe_castRingHom]` before
rewriting the modulus to `0`.

## Out of scope

- **Unconditional PNT-in-AP.** The quantitative equidistribution remains a quarantined axiom
  pending mathlib; this task does not formalize it.
- Effective/uniform (Siegel–Walfisz) forms — deliberately not assumed.
- The remaining unformalized manuscript items unchanged from C262 (Lemma 2.1 bridge, Thm 7.2
  isos, template nimbers, orbit counts).

## Vibe check

Good. The gap C262 flagged is now closed at the right altitude: the entire analytic debt is a
single, textbook-exact axiom that a referee can check line-by-line against Davenport, and the
`1/2` falls out of the committed finite classification by pure cancellation — no `φ(8n)`
arithmetic, no re-proving the 2-of-4 selection. The only real judgement call is natural-density vs
Dirichlet-density: the axiom asserts the (stronger) natural-density limit `π(x;m,a)/π(x) → 1/φ(m)`,
which implies the manuscript's Dirichlet-density statement with the same value and is what the
paper cites, so this is faithful rather than an overclaim. The trust boundary is plainly one axiom
wide and structurally isolated in its own file. Remaining risk is nil for this deliverable; the
only "open" item is the deliberate one — replacing the axiom when mathlib ships PNT-in-AP.
