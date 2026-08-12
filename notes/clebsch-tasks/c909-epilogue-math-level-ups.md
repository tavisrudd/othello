# C909 — Structural level-ups beyond the cubic epilogue

**Lane:** `clebsch`

**Status:** active. The finite-etale graph theorem now gives every integral
divided power of the distinguished principal polarization in the ordinary
divisor-product lattice, not only its minimal cofactor. Factorial-active
nonsplit trace-transfer root-weight families are proved polarized-
indecomposable, and their labelled local slopes have a one-orbit
classification. The ordinary atom route is exhausted at one stabilization,
while a uniform conditional graded-support theorem isolates the exact C907
input for all higher stabilizations. This task extracts and proves
the strongest general theorems suggested by the epilogue. It does not edit a
manuscript, PDF, mirror, Lean source, or reviewer dossier until a result has a
human proof, a hostile audit, and a closed predecessor boundary.

## Objective

Raise the epilogue from a striking conjunction of two cubic-threefold results
to the visible special case of reusable structural mathematics. Seek the next
theorem whose statement is intrinsic, whose proof explains the mechanism, and
whose applications extend beyond the six-axis family. Prefer one inevitable
classification over several additional examples.

The task is deliberately open-ended, but not unbounded in method: every pass
freezes one theorem, obstruction, or counterexample target; finite computation
may falsify or normalize it but may not be the proof.

## Separation from adjacent tasks

- C907 owns the quantum-monodromy route toward irrationality of
  `X x P^m`, especially `m >= 2`, and its analytic/Stokes enhancement gates.
- C908 owns the relative Chow index and the full `p`-typical gluing
  classification as potential Annals crowns.
- C909 owns epilogue-level extraction and synthesis: general criteria,
  intrinsic formulations, new families where both detectors fire, and the
  search for a single theorem explaining why the separation occurs.

C909 may import a proved C907/C908 theorem, but does not duplicate their live
proof searches.

## Crown ladder

### I. Intrinsic cofactor saturation

Turn the current local block lemma into a chart-free theorem for a polarized
isogeny `E^g -> A`. Define the ordinary divisor-product defect intrinsically,
identify its local support and functorialities, and classify the zero-defect
regime without choosing graph coordinates.

Immediate targets:

1. prove the local cofactor theorem for arbitrary finite unramified
   coefficient rings and descend it faithfully;
2. formulate squarefree self-adjoint gluing as an intrinsic etale-algebra
   condition on the discriminant packet;
3. determine whether squarefree gluing is necessary after passage to the
   primary semisimplification, or only sufficient;
4. derive deformation, product, and isogeny functoriality of the defect.

Acceptance-grade upgrade: a clean local-global saturation theorem with at
least one new family not built into the proof. Crown: an iff classification or
exact elementary-divisor formula.

### II. Atomic stabilization beyond the cubic corollary

Extract the exact birational principle behind the one-stabilization theorem.
The basic projective-bundle formula is formal because `P(V)` is birational to
`Z x P^r`; the mathematical content must instead be an intrinsic carrier-height
or atom-filtration theorem.

Immediate targets:

1. state the correct abstract-atom criterion with its dimension hypothesis
   and prove it directly from the KKPYY composition formulas;
2. classify low-dimensional carriers of a prescribed fractional formal
   monodromy, beginning with primitive sixth roots;
3. decide whether the cubic atom has a carrier-height invariant strong enough
   to survive `P^2`, or prove the exact first self-carrier obstruction;
4. test whether the same criterion applies to another Fano or complete-
   intersection family without weakening the cubic theorem.

Acceptance-grade upgrade: a reusable carrier-exclusion theorem with a second
application. Crown: irrationality of `X x P^2`, all stabilizations, or a sharp
general stable-height formula.

### III. Systematic separation families

Find a theorem producing varieties that are universally `CH_0`-trivial but
remain irrational after a controlled stabilization from two independent
inputs:

- an integral minimal-class/divisor-product condition on an intermediate
  Jacobian or related cycle carrier; and
- a birational atom outside the center-dimension filtration.

The theorem must make the independence of the two detectors explicit and
state checkable hypotheses. A second non-isotrivial family where both
hypotheses are verified would turn the epilogue from an exceptional example
into a method.

### IV. Exact boundary and converse questions

If the positive criteria resist generalization, identify a theorem-grade
boundary rather than adding examples:

- characterize when the cofactor condition is invariant under changing an
  isogeny presentation;
- determine whether universal `CH_0`-triviality can force any restriction on
  atomic carrier height in a natural geometric class;
- isolate the weakest hypotheses under which one-step irrationality follows
  from a filtered additive invariant;
- exhibit a counterexample proving that either detector cannot be inferred
  from the other.

## Required proof style

1. Final statements are coordinate-free and independent of the Clebsch
   naming. Coordinates may appear only in a verification lemma or example.
2. Every integrality proof displays the divided-power, off-diagonal, and
   descent normalizations. No certificate substitutes for saturation.
3. Every quantum statement distinguishes abstract `G`-atoms, geometric atom
   classes, formal blocks, and their comparison maps.
4. A broad criterion is promoted only if its hypotheses are verified in at
   least one genuinely new case or it materially compresses the cubic proof.
5. Run a primary-source priority audit before any novelty sentence and a
   hostile specialist audit before manuscript promotion.
6. After each accepted theorem, run the required `ej`+`tt` pass and maintain a
   mystery ledger in the dated report.

## Initial theorem target

The first pass attacks the intrinsic version of cofactor saturation:

> For a polarized elliptic-power isogeny, squarefree self-adjoint primary
> gluing makes the local Neron--Severi coefficient algebra etale; its primitive
> block idempotents force the polarization cofactor into the ordinary
> `(g-1)`-fold divisor-product lattice, and faithful unramified descent plus
> localization gives the integral minimal class globally.

The pass must decide which parts of that sentence are canonical, prove the
unramified descent without trace denominators, and produce either a second
application or an exact obstruction to necessity.

## Current theorem package

1. **Etale graph saturation.** For an elementary prime graph whose
   self-adjoint slope algebra is finite etale, the primitive minimal class is
   in the ordinary divisor-product lattice. The condition is intrinsic to the
   marked elliptic-power presentation under transverse ruling changes, not to
   a bare ppav. Squarefree slope is sufficient but not necessary.
2. **Prime-power extension.** For a block-respecting graph over
   `Z/p^a`, literal finite etaleness of `(Z/p^a)[T]` supplies exact orthogonal
   idempotent blocks after unramified splitting. The full weighted divisor
   blocks descend, mixed cofactors give the primitive class, and faithful
   flatness removes every trace multiplier.
3. **Nontrivial families.** Root-weight forms with `N=p^a` admit nonscalar
   split-etale slopes beyond the factorial wall. Nonsplit unramified local-
   etale slopes are constructed by trace transfer and are polarized-
   indecomposable. Their labelled self-adjoint embeddings form one local
   orbit in the odd rank-one and dyadic hyperbolic root cases; an independent
   audit closed the dyadic Arf and stabilizer normalizations.
4. **All polarization divided powers.** Finite-etale block splitting writes
   the distinguished principal polarization as an integral signed sum of
   square-zero divisor classes. Hence `Theta^k/k!` lies in the ordinary
   `k`-fold divisor-product image for every `0 <= k <= g`, with faithful-flat
   descent and no factorial. More strongly, on a pure equal-depth `p^a` block
   the complete graph Neron--Severi lattice is rank-one generated, including
   its exact `p^(2a)` cross-eigenblock terms. Thus its full divided-power
   envelope equals the ordinary divisor-product image in every degree. This
   is cohomological, not a Chow identity; mixed unit/primary and unequal-depth
   blocks remain gated by a valuation-compatible straightening theorem.
   The underlying chart-free algebra has now been isolated: any symmetric
   matrix-of-ideals divisor lattice with
   `I_ij subset I_ii intersect I_jj` is rank-one square-zero generated and
   has full divided-power saturation. An independent hostile read passes this
   theorem. Applying it at arbitrary graph depths still needs compatible
   slotwise etale splitting.
   TT sharpens the sufficient containment to an exact iff classification:
   for diagonal depths `a_i` and cross depths `e_ij`, rank-one generation is
   equivalent to `2e_ij >= a_i+a_j`, or intrinsically
   `I_ij^2 subset I_ii I_jj`. This tropical Cauchy--Schwarz condition also
   passes an independent dyadic/cancellation audit.
   For arbitrary block-respecting graph data finite-etale separately at every
   Jordan depth, no cross-depth compatibility hypothesis is needed. After
   splitting, a cross slot has exact depth
   `max(a,b,a+b-v_p(t_j-t_i))`, always at least `max(a,b)`. Hence the tropical
   criterion holds automatically and gives full cohomological `PD(NS)`
   saturation in every degree.
5. **Atomic boundary.** Ordinary abstract carrier height proves exactly the
   `P^1` stabilization and is silent at `P^2`. Every additive refinement of
   the ordinary chemical formula is merely an atom weight and cannot recover
   lost Tate positions.
6. **Uniform C907 bridge.** For every `m`, a strict support module
   `T_m=<1,L,...,L^m>` whose `s`-dimensional cubic carriers lie in absolute
   degrees `0,...,s-3` formally proves `X x P^m` irrational. Width alone is
   insufficient. Constructing this presentation-independent strict measure
   is C907's Gamma/Rees/Stokes gate.
7. **Second-family boundary.** `V_4` is rational and hence impossible;
   currently sourced special cubic-fourfold loci are rational or lack the
   stabilized carrier theorem. No second separation family is claimed.

## Highest-EV next moves

1. Recast the tropical ideal condition and arbitrary-depth theorem without a
   chosen coefficient-line decomposition, or prove that the marked
   elliptic-power presentation is the optimal intrinsic scope. The
   block-respecting finite-etale graph case is now fully classified.
2. Give the dyadic root isometry `I+J ~= H^q` a printed constructive induction
   or a pinpoint primary citation before manuscript promotion.
3. Integrate the all-degree finite-etale theorem into the epilogue only after
   the current prose cost is compared against the headline cycle proof; keep
   the orbit classification and indecomposable families as successor material
   unless they materially improve the narrative.
4. Treat the uniform graded-support theorem as C907's exact algebraic
   acceptance surface; do not restart ordinary atom or multiplicity searches.

## Acceptance and stopping conditions

- **Bronze:** one structural theorem strictly broader than the epilogue's
  application, with a human proof and independent hostile audit.
- **Silver:** an intrinsic iff/elementary-divisor classification, a second
  geometric separation family, or irrationality after two stabilizations.
- **Gold:** a systematic separation theorem with multiple families,
  unbounded indecomposable divisor defects, or full stable irrationality for
  cubic threefolds.
- **Block:** three consecutive bounded passes hit the same precise theorem or
  source obstruction without meaningful progress. Record the gate and stop;
  do not replace it with more census data.

## Starting authority

- `papers/cubic-stabilization-epilogue/sections/03-minimal-class.tex`;
- `papers/cubic-stabilization-epilogue/sections/04-one-step.tex`;
- `notes/clebsch-tasks/c907-quantum-monodromy-stabilization.md`;
- `notes/clebsch-tasks/c908-annals-math-upgrades.md`;
- `notes/2026-08-11-c904-adjacent-annals-crown-audit.md`;
- `notes/2026-08-11-c904-semisimple-graph-slope-primitivity.md`;
- `notes/2026-08-11-c904-prime-gluing-divided-power-obstruction.md`;
- `notes/2026-08-11-c904-spectral-stabilization-defect-towers.md`;
- `notes/2026-08-11-c904-regular-primary-ghost-bridge-reduction.md`.

## Invocation

`go C909 clebsch — structural epilogue level-ups: begin with intrinsic
cofactor saturation, then pursue carrier-height and systematic separation
theorems without duplicating C907 or C908.`
