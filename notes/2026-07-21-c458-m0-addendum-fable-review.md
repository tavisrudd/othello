# C458 / M0 addendum — Fable gate: two-frame theorem wording and golden-sheet-frame freeze

**Lane**: `crowns` (read-only `clebsch` inputs)

**Date:** 2026-07-21

**Status:** independent Fable-gate review of the C458 evidence bundle
([`2026-07-21-c458-golden-sheet-frame-freeze.md`](2026-07-21-c458-golden-sheet-frame-freeze.md),
`.json`, `.py`, `-replay.py`). Review note only; no C458 artifact, manuscript, or Lean file is
edited here.

**VERDICT: AMBER-needs-wording-fix — the mathematics of the two-frame theorem, the bridge, and the
binding of claim 3 is fully confirmed by independent computation, but the frozen JSON misdescribes
its own central construction (finding F1) and one JSON `verified: true` outruns its committed
witness (finding F2); after those two regeneration-level fixes, GREEN-to-freeze and M2 AMBER→GREEN
are both warranted.**

## 1. Independent computation

Both tracked checks pass as committed: `...freeze.py --check` prints `CHECK OK`;
`...freeze-replay.py` prints `ALL PASS (16/16)`.

Beyond that, every load-bearing fact of the two-frame theorem and bridge was rebuilt from scratch
in a separate construction (`c458_fable_check.py`, session scratchpad, run from the repository
root; exact `Fraction` arithmetic in own `Q(phi)` and `Q(zeta5)` implementations, own projective
closure/orbit/matching/Moebius code, no floats, no recalled group facts). The only frozen code
reused is `C399.conic_parameterization(11)`, because the C406 point labels are that convention.
All checks pass. The load-bearing ones:

| frame        | fact independently recomputed                                                                              | result |
|:-------------|:-----------------------------------------------------------------------------------------------------------|:-------|
| golden char0 | closure of reflections in the 15 H3 root axes at `tau=phi` has projective order 60 and permutes the six-arc | PASS   |
| golden char0 | `sigma(S) = ` conjugate six-arc, disjoint; `sigma(A5_phi) = A5_{1-phi}`; intersection order 12               | PASS   |
| golden char0 | `Rz` maps six-arc onto conjugate arc, conjugates the two `A5`s; `Rz = r_(1,1,0) r_(1,0,0)` (spinor norm 2·1) | PASS   |
| golden char0 | quaternion lift `1+k` of reduced norm 2 conjugates to exactly `Rz`                                           | PASS   |
| golden char0 | all 66 cross-products of distinct axes in the union of the two six-arcs are anisotropic over `Q(phi)` — the two 12-vertex conic point sets are genuinely disjoint in char 0 | PASS |
| reduction    | `phi->8` (`sqrt5->4`) and `phi->4` (`sqrt5->7`) are the two prime reductions; `reduce_pi(sigma g) = reduce_pibar(g)` | PASS |
| mod 11       | `a5(8) != a5(4)`, each order 60, intersection order 12; both inside my own Moebius `PSL_2(11)`               | PASS   |
| mod 11       | polar matching of the reduced six-arc at `pi` == C406 base `{0,1}{2,5}{3,7}{4,9}{6,8}{10,inf}`; at `pibar` == J-mate `{0,10}{1,inf}{2,7}{3,5}{4,8}{6,9}` | PASS |
| mod 11       | pair-orbits under each sheet are 6/30/30; the size-6 orbit is the polar matching (uniqueness downstairs)      | PASS   |
| mod 11       | `<a5(8), a5(4)>` has order 660 and EQUALS my independently generated `PSL_2(11)` permutation group, not just matches its order | PASS |
| mod 11       | `Rz`-bar is in `PGL` minus `PSL`; its Moebius representative has det class 2 (nonsquare, `legendre(2,11) = -1`); it conjugates `a5(8)` onto `a5(4)` and maps base to J-mate | PASS |
| binary char0 | own `Q(zeta5)` field; `<S,T>` projective order 60; `sigma(S) = S^2`, `sigma(T) in A5`; the FULL cyclotomic Galois group (`z->z^2, z^3, z^4`) normalizes the Klein `A5` | PASS |
| binary mod 11| reductions `zeta->3` (`phi->8`) and `zeta->9` (`phi->4`) give the IDENTICAL order-60 subgroup of `PGL_2(11)` — sheet-blindness at group level | PASS |
| binary mod 11| unique invariant matching `M0bin = {0,inf}{1,6}{2,4}{3,7}{5,8}{9,10}`, same at both primes; PGL-stabilizer exactly the reduced Klein `A5` (order 60, in PSL); PGL-orbit 22, PSL-orbit 11; outer image distinct and not PSL-equivalent | PASS |
| cross-check  | `mu3` D-profiles in the C458 JSON (`base = [-6,0,12,-12]`, `jmate = -base`) match the frozen C442 JSON verbatim | PASS |

Not recomputed here: the `mu_3` D-profiles themselves (consumed from the frozen, hash-pinned C442
certificate — M3/C443 owns commuting-with-reduction) and the quaternionic Schur-index mechanism
(classical representation theory, not a finite computation; see F4).

## 2. Rulings on the gate questions

**(1) Two-frame theorem wording — correct, and the stated mechanisms are the right ones.**
"Sheet-blind by Galois-normalization" is exactly what the computation shows: `f` has integer
coefficients, `sigma(S) = S^2` and `sigma(T)` land in the char-0 Klein `A5` (verified for the full
cyclotomic Galois group, not only the golden `sigma`), the two reduced groups are literally the
same subgroup of `PGL_2(11)`, and the unique invariant matching is therefore one prime-independent
object with stabilizer the reduced `A5`, PGL-orbit 22, PSL-orbit 11. "Golden frame sheet-faithful"
is grounded precisely as stated: `sigma` moves the six-arc to a disjoint conjugate arc and moves
the `A5`; the one polar matching reduces at `pi` to base and at `pibar` to J-mate, two distinct
singletons with distinct stabilizers `a5(8) != a5(4)` meeting in the common `A4`. The theorem
block is instance-scoped to the primes above 11 throughout — no unproved generality is smuggled
in. One precision nit: F3.

**(2) Bridge — correct and non-overclaiming.** `Rz` is presented as a rational, det-1, integer
rotation whose spinor norm is 2, with char-11 entering only through the reduction: verified,
including the reflection factorization and the quaternion lift `1+k` (norm 2). "The swap is outer
precisely because 2 is a nonsquare mod 11" matches the computed det class of the reduced Moebius
representative. No sentence in the report or JSON implies the swap element exists only mod 11;
"Char-11 makes the shadow outer" is the right scoping. What is claimed as purely char-11 — the
collision and the finite closure `= PSL_2(11)` — is exactly what has no char-0 avatar, and the
closure equality (not merely the order) is confirmed. Two caveats: the collision witness
under-covers its prose (F2), and the quaternion-mechanism sentence is classical background, not a
computed fact (F4).

**(3) Extension, not change — justified.** Nothing in the frozen C440 JSON is contradicted: the
binary form remains the correct vertex-set model, its sheet-independence remains a feature where
M1 used it, and C458 introduces no new conventions (all coordinates, labels, and matchings are
C379/C399/C406's, hash-pinned). M1's certificate is consumed by hash only. One upstream *prose*
erratum in the C440 report surfaced during this review (F5); the C440 JSON is unaffected, so the
"nothing frozen becomes wrong" sentence stands at the artifact level.

**(4) Binding of claim 3 / M2 AMBER→GREEN — sufficient; nothing mathematical is missing.** The
C442 ruling C asked for exactly three things: co-equal freeze under M0's JSON discipline, the
two-frame theorem, and the bridge. All three are present, computed, and independently replayed
(the replay is a genuinely separate code path: C379+C399 only, own matching/closure code). The
covariation binding restates ruling D's canonical convention-free invariant verbatim, and the
frozen profiles match C442's certificate. Claim 3's sentence now has a frozen antecedent whose
reduction tables ARE the C406 singletons. The transition is legitimate once F1 (and preferably
F2) land; both are string/assert-level fixes to regenerate, not changes to any verified object.

**(5) Overclaim / novelty audit.** No novelty or priority language anywhere; the literature
boundary section correctly disclaims and pins the classical territory. The single non-computed
assertion in the frozen JSON is the quaternion-mechanism prose (F4). Remaining items are wording
precision (F3, F6).

## 3. Findings and exact corrections

**F1 (fix required; in the frozen JSON).** `golden_sheet_frame.golden_A5.construction` reads
"projective closure of the reflections in the six golden axes (a5(tau) at tau=phi)". The frozen
construction (C442 `clause_ii_char0_exhibition`, consuming C379 `roots`/`a5`) reflects in the
**fifteen H3 root axes** (the two-fold axes), not the six golden vertex axes. The six-arc points
are not H3 roots (verified: `roots(phi)` and the six-arc are disjoint), and the literal reading is
not a harmless synonym: the projective closure of the reflections in the six vertex axes was run
and exceeds 200 elements — it is not the frozen order-60 `A5` at all. Recommended replacement:
`"projective closure of the reflections in the fifteen golden H3 root axes (C379 roots(tau)/a5(tau)
read at tau=phi); the six-arc points are the five-fold vertex axes, permuted by this group, not
reflected in"`. Fix in the generator string and regenerate JSON + sha256 + the hash table in the
C458 report atomically; never hand-edit the JSON.

**F2 (fix strongly recommended).** `bridge.char11_collision` states the disjointness of the two
char-0 **12-vertex** sets with `verified: true`, but the committed witness
(`char11_collision_disjoint_char0_reduce_onto_one_P1`) checks six-arc (axis-level) disjointness
plus mod-11 coverage. Axis disjointness does not by itself exclude two distinct axes sharing one
isotropic direction. The vertex-level statement is true — verified here via the 66 cross-product
anisotropy checks (`(v x w)·(v x w) != 0` in `Q(phi)` for all distinct axis pairs across both
arcs) — and that check is a cheap exact assert. Either add it to the generator at the next
regeneration or weaken the JSON statement to the axis level. As committed, the flag outruns its
witness.

**F3 (minor).** Report line "`sigma = Gal(Q(sqrt5)/Q)` exchanges the two reductions": `sigma` is
the nontrivial *element* of the Galois group, not the group. C442's wording ("the nontrivial
element `sigma` of ...") is the correct form.

**F4 (minor).** The quaternion-mechanism sentence (Schur index 2, `K`-home, splitting at 11) is
classical structure, not a computation, and is the only assertion in the frozen JSON without a
machine witness. Add a qualifier at next regeneration, e.g. "(structural/classical; not
machine-verified here — C442 review finding 6)", in the `.md` bridge bullet and the JSON
`quaternion_mechanism` field.

**F5 (upstream erratum, C440 report prose; C440 JSON unaffected).** C440's report says the
involution `z -> -1/z` "pairs the 12 roots into exactly 6 pairs (the antipodal matching)". The
involution does fix `f` and pair the roots, but the pairing it induces is **not** the
`A5`-invariant antipodal matching: computed here, the unique invariant matching of the reduced
Klein `A5` (identical at both primes) is `{0,inf}{1,6}{2,4}{3,7}{5,8}{9,10}` — the reduction of
the same-phase pairing `{eps^nu(eps+eps^4), eps^nu(eps^2+eps^3)}` — while the `z -> -1/z` pairing
reduces to `{0,inf}{1,10}{2,5}{3,7}{4,8}{6,9}`, a different, non-invariant matching (M1's root
bijection lifts the distinction to char 0). No Moebius involution can induce the antipodal
matching (the sphere's antipodal map is anti-holomorphic and the centralizer of `A5` in `PGL_2`
is trivial). C440's `alpha*beta = -1` coefficient remark stays correct — reciprocity of the two
pentagon radii is exactly what the same-phase pairing uses. Since M2/C458 ground "the antipodal
matching" as the unique invariant one, a one-line erratum against the C440 report (not a
re-freeze; its JSON records only the pair count and the coefficient identity) should be recorded
in the next C440-touching commit.

**F6 (minor).** "In this frame the two singletons are not two reductions: one is the
prime-independent reduction, the other its char-11 outer image" is true only through the
`PGL_2(11)`-conjugacy identifying the binary frame with the golden one: under the naive label
identification the binary-frame matching is neither C406 singleton (verified). The in-frame
content (matching + outer image distinct, PSL-inequivalent, PGL-orbit 22 splitting as 11 + 11) is
verified. Suggested qualifier: "...its char-11 outer image (under the frame identification
conjugating the reduced Klein `A5` onto a sheet stabilizer)". Same sentence already appears in
the frozen C442 report; fixing it in C458 alone is acceptable.

## 4. Forward note — mid-review input, outside this gate

A Codex note from its C446 work (relayed mid-review; the coordinator is following it up
separately) proposes extending the freeze with the two 15-point Fregier clouds of base/J-mate,
their claimed 3-point common triangle, its claimed `S4` stabilizer, and a claimed unique
nonconcurrent `S4`-invariant matching. None of that is needed to bind claim 3, none of it is part
of the C458 bundle reviewed here, and none of its claims were checked in this review. The C458
freeze is intentionally minimal and should stay so; freezing derived cloud/triangle objects is
new scope for the task that owns it, and this verdict is unaffected by that proposal either way.

## 5. Evidence and boundary

Independent checker: `c458_fable_check.py` under the session scratchpad
(`/tmp/claude-1000/-home-tavis-src-othello-rust/d77c9333-978c-4192-8984-de6930f095b2/scratchpad/`),
run from the repository root with `python3 <path>`; prints one PASS/FAIL line per fact and exits
nonzero on any failure. Run logs under `/tmp/claude-run-quiet/20260721-13*` (tracked-check runs
and the independent battery). These are review evidence, session-scoped by design — the note
records every construction and constant needed to re-derive them. Trusted boundary: exact
`Fraction` arithmetic in own `Q(phi)`, `Q(zeta5)`, and quaternion implementations; exact `F_11`
arithmetic; the C406 point-label convention taken from `C399.conic_parameterization(11)`; group
closures, orbits, matchings, stabilizers, and both Moebius groups computed, never assumed. Not
certified here: everything in C458's own boundary section (M3/M4/M5/C459 territory), the `mu_3`
profile computation (frozen C442), and the Schur-index mechanism (classical).

**VERDICT: AMBER-needs-wording-fix** — F1 required, F2 strongly recommended, F3/F4/F6 polish, F5
upstream erratum; no mathematical defect anywhere; with F1+F2 regenerated, C458 is
GREEN-to-freeze and M2's AMBER→GREEN stands.
