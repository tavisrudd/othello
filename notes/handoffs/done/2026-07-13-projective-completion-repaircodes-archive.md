# Projectively completed cubic–axis RepairCodes — companion log

Append-only session history for
[`2026-07-13-projective-completion-repaircodes.md`](../2026-07-13-projective-completion-repaircodes.md).
The live handoff contains only the current claim and gate map.

## 2026-07-13 — lane opened

Allocated C111–C114 after a diagnostic q9 enumeration suggested that adding the omitted projective
twisted-cubic point gives a `[20,4,9]_9` seed with two repair types. The q9 numbers and proposed
general formulas remain evidence-only. The strict route is independent refutation, written proof,
Lean proof and axiom audit, bounded-support transfer, exact-claim literature review, then paper
promotion. The supplied 2015 *Open Problems in Coding Theory* survey was checked: it supplies broad
code/design, projective/MDS, and TVZ context but does not discuss locality, repair hypergraphs,
matroid ports, or the twisted-cubic-axis union; its silence is not novelty evidence.

## 2026-07-13 — C111 parameter slice

Added `FiniteGeom/ProjectiveAxisTwistedCubic.lean`. The proof explicitly separates finite cubic
parameters from cubic infinity. If infinity lies in the plane, the finite section reduces to a
degree-two moment-curve section; if the plane contains the axis, Frobenius injectivity and the
finite/infinity cross-case give at most one projective cubic point. The maximum section remains
`q+2`, the length is `2q+2`, and the module derives dimension four and distance `q`.

Focused validation:

```text
choom -n 1000 -- nix develop --command lake env lean \
  FiniteGeom/ProjectiveAxisTwistedCubic.lean
```

passes. `#print axioms` for the full-cubic section bound, completed-system section bound, and
bundled code parameters reports only `propext`, `Classical.choice`, and `Quot.sound`. C111 remains
open: projective distinctness, dual distance, independent small-field replay/mutations, aggregate
wiring/build, scans, and xhigh review are not yet done.

## 2026-07-13 — Discovery Track register established

The live register is reserved for incidental mathematical findings encountered during execution,
not planned deliverables or progress records. Its first entry is D-PC9, the exact five-section/
five-weight distribution suggested by the independent C111 replay.

## 2026-07-13 — D-PC9 exact section-distribution candidate

The independent q=3,9,27 replay returned projective plane-section distributions

```text
q=3:  {1:8,    2:12,   3:12,  4:4,    5:4}
q=9:  {1:240,  2:360,  3:90,  4:120, 11:10}
q=27: {1:6552, 2:9828, 3:756, 4:3276, 29:28}
```

These agree exactly with
`N1=q(q²-1)/3`, `N2=q(q²-1)/2`, `N3=q(q+1)`, `N4=q(q²-1)/6`, and
`N(q+2)=q+1`. The verifier now asserts those formulas. Since nonzero scalar multiples of a plane
form give distinct codewords and the message map is injective, the conjectural ordinary weight
enumerator has five nonzero weights and exactly `(q-1)(q+1)=q²-1` minimum-weight words. A general
proof should follow from the zero-through-third plane-section moments: all triples except the
all-axis triples span a unique plane, while an axis triple lies in `q+1` planes. This is CHECKED
finite evidence only until XH7, Lean, and literature gates pass.

## 2026-07-13 — C111 closed after XH1

Completed the strict-trust seed layer in `FiniteGeom.ProjectiveAxisTwistedCubic` and
`RepairCodes.ProjectiveAxisTwistedCubic`. In addition to the parameter theorem, the final geometry
module proves that every nonzero plane containing the axis meets the projective cubic in exactly
one point. The code layer proves nonzero columns, pairwise projective distinctness via linear
independence, an explicit axis-triple dual word, and exact global dual distance three.

The XH1 audit reviewed the finite/infinity section split, all cubic/cubic, cubic/axis, and axis/axis
pair cases, the explicit word support, and the q=3 boundary. No repair-port classification or
D-PC9 weight distribution was used to close C111.

Validation passed:

```text
choom -n 1000 -- nix develop --command lake build \
  FiniteGeom.ProjectiveAxisTwistedCubic RepairCodes.ProjectiveAxisTwistedCubic RepairCodes

python3 notes/2026-07-13-projective-completion-verifier.py
q=3:  n=8  rank=4 max_section=5  d=3  forms=40    distribution={1:8, 2:12, 3:12, 4:4, 5:4}
q=9:  n=20 rank=4 max_section=11 d=9  forms=820   distribution={1:240, 2:360, 3:90, 4:120, 11:10}
q=27: n=56 rank=4 max_section=29 d=27 forms=20440 distribution={1:6552, 2:9828, 3:756, 4:3276, 29:28}
```

The verifier also passed coordinate conjugation, deletion back to the affine seed, duplicate
mutation rejection, and a nonduplicate spectrum-changing mutation. The relevant forbidden-token
scan (`sorry`, `admit`, `native_decide`, `unsafe`) and `git diff --check` were empty. Printed axiom
reports contain only `propext`, `Classical.choice`, and `Quot.sound`.

## 2026-07-13 — C112 projective-boundary circuit slice

Added `FiniteGeom.ProjectiveAxisTwistedCubicCircuits`. For distinct finite parameters `s,t`, it
proves directly that the family consisting of cubic `s`, cubic `t`, cubic infinity, and the finite
axis point `s+t` is dependent, that deleting any member leaves an independent triple, and that no
other normalized axis point makes the four-family dependent. This closes the circuit case absent
from the affine module; it does not yet assert completeness of either radius-three repair clutter.

Focused validation passes, and both printed headlines use only `propext`, `Classical.choice`, and
`Quot.sound`:

```text
choom -n 1000 -- nix develop --command lake env lean \
  FiniteGeom/ProjectiveAxisTwistedCubicCircuits.lean
```

## 2026-07-13 — independent C112 circuit/row replay

Extended the independent verifier to enumerate all matroid circuits of total size at most five,
derive the minimal helper clutters at radii three and four, and solve matching and transversal
numbers exactly. It also computes `Z3(q)` independently by maximum triple-free subset search.

```text
q=3: repair_rows={cubic r3:(1,2), axis r3:(2,3), cubic r4:(1,2), axis r4:(2,3)}
     circuits_le_5=20 Z3=2
q=9: repair_rows={cubic r3:(4,8), axis r3:(7,13), cubic r4:(4,8), axis r4:(7,15)}
     circuits_le_5=6072 Z3=4
```

Thus the proposed formulas survive both the smallest characteristic-three field and q=9 without
assuming target transitivity or a selected repair family. This remains independent finite evidence;
the general clutter equivalence and invariant formulas stay open under XH2–XH4.

## 2026-07-13 — D-PC10 ambient shifted-inversion symmetry

While implementing XH2, shifted inversion was found to lift to the ambient coordinate map

```text
T_a(x₀,x₁,x₂,x₃) =
  (a³x₀+x₃, a²x₀-ax₁+x₂, ax₀+x₁, x₀).
```

In characteristic three, `T_a C(s)=(s+a)³ C((s+a)⁻¹)` when `s≠-a`, `T_a C(-a)=C(∞)`,
and `T_a C(∞)=C(0)`. On the axis, `T_a A(y)=(0,y-a,1,0)`, so `A(a)` maps to
`A(∞)`. This realizes the desired completion-fiber equivalence through an ambient invertible
linear transformation rather than a case-by-case coincidence.

`RepairCodes.ProjectiveAxisTwistedCubicInvariants` now kernel-proves the induced projective
parameter equivalence, its unique preimage of infinity, invertibility of `T_a`, and the direct
normalized action formulas on finite cubic and axis points together with all pole/infinity cases.
The aggregate build and standard axiom scan pass. Generic circuit/support transport and the exact
zero-sum fiber equivalence remain open under XH2; until those compile, D-PC10 is not used to claim
uniform repair rows.

## 2026-07-13 — D-PC10 family-level transport

Extended the ambient symmetry to an equivalence of the full completed coordinate type and defined
the accompanying scalar at every coordinate. Lean proves every scale is nonzero and the exact
column identity

```text
T_a(P_j) = λ_j P_{σ_a(j)}.
```

Using the ambient linear equivalence and unit-valued scales, the module proves that an arbitrary
indexed family of completed columns is linearly independent iff its `σ_a`-image is. This is the
family-level circuit-preservation statement needed by XH2 and has the standard axiom profile.

The completed seed module now also defines its complete and minimal repair hypergraphs, proves
repair edges nonempty, supplies the generic circuit-to-repair bridge, and records the standard
minimal-clutter matching/transversal reductions. The aggregate `RepairCodes` build passes. Exact
finite-support relabeling and identification of the axis-infinity cubic component with the full
zero-sum triple hypergraph remain open.

The next slice added an explicit equivalence between a finite support `S` and its image under the
D-PC10 coordinate permutation, then proved kernel-side that the selected columns on `S` are
linearly independent exactly when the selected columns on the relabeled support are. Thus the
remaining transport work is restricted to compatibility of one-point deletions and the repair
target/helper convention, rather than any further ambient linear algebra.

That deletion step is now closed. The module defines the completed column-circuit predicate as
dependence plus independence after deleting every selected point and proves that D-PC10 relabeling
preserves it in both directions. The remaining repair transport is a generic code/matroid API
lemma: an inclusion-minimal dual support whose target coefficient is nonzero is exactly a column
circuit containing that target. This is logically separate from the projective symmetry and should
be proved once in `FiniteGeom.Repair`, not reconstructed for this family.

## 2026-07-13 — completed mixed-triple independence

Extended `FiniteGeom.ProjectiveAxisTwistedCubicCircuits` with the shape lemmas needed to classify
short repairs at axis infinity. It now proves:

- every three distinctly indexed points of the full projective cubic are independent;
- any two distinct full-projective cubic points together with any axis point are independent;
- any full-projective cubic point together with two distinct axis points is independent.

The proof treats all positions of cubic infinity explicitly and reuses the affine Vandermonde and
axis-pair lemmas where applicable. Focused Lean validation passes with the standard axiom profile.
Consequently, among selected triples, only the all-axis case can be dependent; the corresponding
Finset/repair-edge shape theorem is the next implementation slice.

## 2026-07-13 — exact radius-two completed-axis repairs

Lifted the indexed mixed-triple results to arbitrary selected Finsets of cardinality at most three
that contain a cubic coordinate. Using this together with pairwise independence, the completed
seed module now proves that every radius-two repair edge of an axis target has exactly two helpers
and that both are distinct axis coordinates different from the target. Thus no finite or infinite
cubic coordinate participates in a radius-two axis repair.

Focused validation passes, and the new selected-family and repair-shape theorems use only
`propext`, `Classical.choice`, and `Quot.sound`. This closes the direct short-edge alternative in
XH2; it does not yet classify radius-three cubic triples or transport repair clutters.

## 2026-07-13 — exact radius-three clutter at axis infinity

Completed the distinguished completion-fiber classification. New strict-trust theorems prove:

- two distinct full-projective cubic columns and two distinct axis columns are independent;
- a three-helper support containing two cubics and an extra axis point cannot repair an axis
  target;
- the cubic triple containing projective cubic infinity completes at a finite axis point and
  cannot repair axis infinity;
- three distinct finite cubic helpers repair axis infinity exactly when their parameters sum to
  zero, with the converse constructed as an actual full-support four-circuit repair;
- the complete minimal radius-three clutter at axis infinity consists exactly of the complete
  pair graph on the other axis points and the finite zero-sum cubic triples.

The resulting minimal completed clutter is kernel-proved equal to the natural embedding of the
existing affine nucleus clutter. Reusing the prior affine extremal theorem gives exact invariants
`nu=(5q-3)/6` and `tau=2q-1-Z3(q)` at axis infinity. Focused builds use only the standard axiom
profile. Uniformity over finite axis targets still requires repair-hypergraph transport under
D-PC10 and is not inferred merely from circuit preservation.

## 2026-07-13 — D-PC11 monomial repair transport and uniform axis row

Added a generic theorem to `FiniteGeom.Repair`: if an ambient linear equivalence sends each
generator column to a nonzero scalar multiple of a permuted generator column, then the coordinate
permutation relabels the complete bounded repair hypergraph exactly, at every target and radius.
The proof transports the full-support dual relation in both directions; it does not infer the
claim from dependence or circuit preservation alone.

Instantiating the theorem with D-PC10 proves exact repair-hypergraph transport from every finite
axis target to axis infinity. Combining relabel invariance of matching/transversal numbers with
the distinguished clutter theorem closes the uniform radius-three axis row:

```text
nu  = (5q-3)/6
tau = 2q-1-Z3(q).
```

The focused theorem uses only `propext`, `Classical.choice`, and `Quot.sound`. This closes XH2 for
the axis row. The cubic row and radius-four/full-inner classification remain C112 obligations.

## 2026-07-13 — exact completed cubic row and adversarial pass

Closed the radius-three cubic half of C112. The boundary four-circuit is now lifted to an actual
repair edge, and the complete cubic-infinity repair hypergraph is classified as
`{C(s),C(t),A(s+t)}` for distinct finite parameters `s,t`. The converse audit treats every support
shape separately. In particular, an all-axis helper triple is excluded from the full-support dual
relation by its final coordinate; axis dependence is not misused as a repair relation for the
cubic target. No cubic-infinity repair with at most two helpers exists.

The numerical invariants are also kernel-proved. The existing consecutive-power matching on the
nonzero field elements embeds as a rainbow matching, giving `nu=(q-1)/2`; an explicit
covered/uncovered endpoint argument forces every transversal to have at least `q-1` vertices, and
all but one finite cubic coordinate attain the bound. D-PC10/D-PC11 transports the result from
cubic infinity to every projective cubic target, and generic clutter reduction gives the same
minimal-clutter row.

Adversarial checks included the q=3 boundary (`nu=1`, `tau=2`), separation of dependence from
full-support repair, exact helper-cardinality before shape enumeration, target exclusion, and the
odd-cardinality step in the matching upper bound. Focused builds and the aggregate `RepairCodes`
build pass; headline axiom prints contain only `propext`, `Classical.choice`, and `Quot.sound`; the
changed files contain no `sorry`, `admit`, `native_decide`, or `unsafe`. C112 now remains open only
for the rank-four radius-four/full-inner classification and invariants.

## 2026-07-13 — C112 complete-inner theorem and XH3/XH4 adversarial pass

Closed the remaining radius-four/full-inner obligations without importing an axiom and without
assuming an exhaustive five-circuit catalogue. The generic repair layer now proves:

- a relation nonzero at the target extracts an actual repair support;
- a full-port transversal separates the target column from all surviving columns;
- a target-nonzero functional gives a transversal consisting of its nonzero helper evaluations;
- target-avoiding section size therefore determines the full-port transversal number;
- helpers in every inclusion-minimal repair are linearly independent;
- every minimal repair of a `k`-row generator has at most `k` helpers, so the minimal clutter
  stabilizes at radius `k`;
- bounded minimal repair clutters are monotone in radius and monomial automorphisms relabel them
  exactly.

For the completed cubic–axis seed, an explicit target-avoiding four-section and its matching upper
bound prove the axis full-port transversal `2q-3`; the existing maximum `q+2` section avoids cubic
infinity and gives cubic transversal `q-1`. Every radius-four cubic-target edge consumes at least
two cubic helpers. Every radius-four axis-target edge satisfies the weighted inequality
`2|C|+3|A|>=6`; summing over a matching gives `6|M|<=5q+2`, and characteristic-three cardinal
arithmetic sharpens this to the old optimum `(5q-3)/6`. Thus the exact uniform full minimal rows
are cubic `((q-1)/2,q-1)` and axis `((5q-3)/6,2q-3)`.

XH3/XH4 reviewed the following failure modes explicitly: inner full port versus a future lift's
unbounded port; target removal and both `-1` conventions in the section complement; the possibility
that a transversal contains the target; dependence versus a target-nonzero full-support relation;
new five-circuit edges increasing a matching; cubic infinity adding one resource vertex; `q=3` and
natural-number subtraction/division; transport of minimality rather than only dependence; and
standard-axiom closure. The focused modules and aggregate `RepairCodes` build pass. Headline axiom
prints contain only `propext`, `Classical.choice`, and `Quot.sound`; forbidden-token and whitespace
scans pass.

The original plan requested a complete radius-four circuit catalogue. The exact paper-facing
invariants do not require or claim such a catalogue: the Lean upper bounds quantify over every
minimal edge, and the generic rank cutoff proves radius-four exhaustiveness. An explicit catalogue
would be an optional enumerative strengthening, not a remaining correctness blocker for C112.

## 2026-07-13 — C113 completed lift, asymptotic family, and XH5 adversarial pass

For a degree-four extension-field outer `[N,K,D]` code, Lean proves the q9 concatenation has
parameters `[20N,4K,>=9D]_9`, exactly `10N` completed cubic and `10N` axis coordinates, exact
locality three/two, and exact radius-four rows `(nu,tau)=(4,8)` and `(7,15)`. Ordinary outer dual
distance six is sufficient: the trace-functional gate needs `r+2=6`, while the inner gate is
`r+1<2*3` at `r=4`.

The Stichtenoth specialization proves unbounded length, exact rate `1/10`, and eventual relative
distance above every fixed `c<351/1600 = 9(39/80)/20`; it separately packages the clean eventual
`1/5` bound. The theorem contains exactly the quarantined
`Imported.stichtenoth_selfDual_TVZ_6561` beyond Lean's standard logical axioms.

XH5 checked confusion between the inner full minimal port and the lift's unbounded port; outer
dual distance five versus six; complete bounded-hypergraph transfer versus selected repairs;
both projective infinity coordinates in the `10N/10N` count; scalar-restriction dimension
scaling; direction of the distance inequality; strict `c<351/1600` versus an endpoint claim;
the eventual gate used to obtain dual distance six; and natural/real arithmetic in the `1/5`
corollary. The formal statement exposes only bounded radius-four equality. Focused and aggregate
builds, forbidden-token and whitespace scans, and axiom audits pass.

## 2026-07-13 — C114 novelty, publication, and XH6 closure

The targeted literature pass separated the classical full twisted cubic/common-axis geometry,
standard projective-system parameters, generic rank-four cutoff, ordinary concatenation, and
rate/distance arithmetic from the family-specific repair computation. No checked source was found
stating the completed system's exact coordinatewise matching/transversal rows or equality of its
complete bounded radius-four repair hypergraph under the transfer gates. The manuscript therefore
uses only “candidate contribution” and “we did not locate”; it makes no priority or “first” claim.

The adversarial paper--Lean comparison found one packaging mismatch: the paper states exact
locality uniformly over the characteristic-three family, while the lift module exposed the axis
result only through a q9-named wrapper and the cubic result had only just been generalized. The
underlying proofs were already uniform. The final API now exports
`projectiveAxisTwistedCubic_cubic_exact_locality_three` and
`projectiveAxisTwistedCubic_axis_exact_locality_two`, with q9 wrappers retained for the lift.
Focused and aggregate builds and the axiom audit confirm the generic declarations use only the
standard logical axioms.

XH6 checked all manuscript headline constants, generic-versus-q9 quantifiers, inner full port
versus lifted bounded port, the strict asymptotic endpoints, theorem labels and citations, the
proof ledger, TRUST boundary, README, paper index, planning registry, queue, and both handoffs.
The regenerated PDF and synchronized package pass the internal release checklist. External
specialist citation-chain review remains a submission preflight gate only.

## 2026-07-13 — cross-lane review and C115–C120 spin-off

The D-PC10/11 equivariance was externally verified:
`⟨T_a,inv,scaling⟩ = PGL(2,q)` has order `q³−q`, preserves the completed cubic–axis system, and
makes its repair invariants orbit-constant. Consequently D-PC9's weight distribution reduces to
orbit counting. The review also corrected the D-PC9 register: the minimum weight `q` has `q+1`
words, not `q²−1`.

The BDMP corpus and Günay–Lavrauw comparison did not locate the `(C∪axis)` five-weight code, but
showed it to be a modest, readily absorbed consequence of the classical twisted-cubic orbit
tables. It is therefore banked as a certified five-weight family without a discovery claim. The
high-value surviving direction is the external-point transversal spectrum from completion §6.5,
now tracked separately in the
[twisted-cubic transversal-spectrum handoff](../2026-07-13-twisted-cubic-transversal-spectrum.md)
as C115–C120.


## Live-file snapshot before pruning — 2026-07-15

# Projectively completed cubic–axis RepairCodes — C111–C114

**Lane**: `repaircodes` — see CLAUDE.md § Lane routing.

**Date**: 2026-07-13
**Status**: COMPLETE. C111–C114 are proved, adversarially reviewed, and synchronized with the
paper and registries. The sole deep formal dependency is the quarantined Stichtenoth theorem;
external specialist citation-chain review remains a submission preflight gate, not a theorem gap.
**Parent track**: [completed RepairCodes formalization](2026-07-11-lean-formalization-plan.md)
**Paper**: [`coding-repair-hypergraphs`](../../papers/coding-repair-hypergraphs/README.md)
**Companion log**: [archive](done/2026-07-13-projective-completion-repaircodes-archive.md)

**Follow-up:** the twisted-cubic transversal spectrum spun off to
[C115–C120](2026-07-13-twisted-cubic-transversal-spectrum.md); the cross-lane review is recorded in
the [companion archive](done/2026-07-13-projective-completion-repaircodes-archive.md).
Two bounded expert-review follow-ups are queued without reopening C111–C114: C202 classifies the
q=9 extremal blockers/disjoint repair families up to automorphism, and C203 tests whether retaining
repair coefficients yields an exact access, bandwidth, or availability consequence. See the
[expert-question portfolio](../2026-07-15-expert-questions-upgrade-portfolio.md).

## Goal and claim ledger

Study the full projective twisted cubic over a finite characteristic-three field together with its
common osculating axis. Keep the existing affine-cubic seed unchanged; this is a candidate second,
Pareto-incomparable seed and asymptotic family.

| Claim | Current status | Permitted wording |
|---|---|---|
| completed seed has parameters `[2q+2,4,q]_q` and exact global dual distance `3` | strict-trust Lean, independent q=3,9,27 replay/mutations, aggregate build, and XH1 passed | proved and paper-promoted |
| completed seed has exactly cubic and axis radius-three repair row types | strict-trust Lean; target transitivity is explicit monomial repair transport, not an orbit assumption | proved through radius three and paper-promoted |
| radius-three cubic row is `((q-1)/2,q-1)` | strict-trust Lean for every projective cubic target; q=3,9 independently checked | proved and paper-promoted |
| radius-three axis row is `((5q-3)/6,2q-1-Z3(q))` | strict-trust Lean for every axis target; q=3,9 independently checked | proved; retained in the formal ledger while the paper emphasizes the full radius-four row |
| radius four exhausts the complete inner minimal port | strict-trust generic Lean theorem: minimal helpers are independent and every `k`-row minimal port stabilizes at radius `k` | proved; inner port only |
| radius-four/full-inner rows are cubic `((q-1)/2,q-1)` and axis `((5q-3)/6,2q-3)` | strict-trust Lean for every completed coordinate; q=3,9 independently enumerated; XH3/XH4 passed | proved and paper-promoted |
| q9 lift has `[20N,4K,>=9D]_9`, exact rate `1/10`, and eventual relative distance above every `c<351/1600` | strict-trust Lean; exact bounded radius-four transfer; only the quarantined Stichtenoth import in the family theorem; XH5 passed | proved and paper-promoted |
| exact completed repair rows and bounded transfer have no located predecessor | targeted exact-claim search; XH6 passed | candidate contribution only; no priority claim |

Here `Z3(q)` is the already formalized maximum size of a zero-sum-free subset of the additive
group, represented in Lean by `zeroSumCapNumber`.

## Task and gate map

| Task | Deliverable | Hard completion gates |
|---|---|---|
| C111 | completed projective seed | independent small-field replay and mutations; written proof; strict-trust Lean theorem; axiom scan; focused and aggregate builds |
| C112 | exact radius-three and radius-four/full-inner ports | exact radius-three classification; exhaustive rank cutoff and resource inequalities at radius four; matching and transversal lower and upper bounds; `q=3` audit; independent enumeration; strict-trust Lean |
| C113 | finite lift and asymptotic family | transfer inequalities checked at radius four; exact multiplicities; analytic arithmetic; only the existing quarantined Stichtenoth import; Lean and PDF builds |
| C114 | novelty and publication closure | exact-claim primary-source citation chains; adversarial review; claim-strength audit; paper/ledger/TRUST/index synchronization |

## Current implementation state

- `FiniteGeom/ProjectiveAxisTwistedCubic.lean` defines the completed indices and columns and proves
  the exact one-point cubic section for planes containing the axis, the full-cubic section bounds,
  maximum section `q+2`, spanning dimension four, minimum distance `q`, and the bundled
  `[2q+2,4,q]_q` theorem.
- `RepairCodes/ProjectiveAxisTwistedCubic.lean` packages the row code, proves all columns nonzero
  and every distinct pair linearly independent, and proves exact global dual distance `3` from an
  explicit three-axis-point dual word.
- `RepairCodes.lean` imports the module. The focused modules and aggregate build pass; every
  printed headline has exactly the standard axiom profile. The independent verifier passes at
  q=3,9,27 with coordinate conjugation, affine deletion, duplicate rejection, and a nonduplicate
  spectrum-changing mutation. The forbidden-token and whitespace scans pass.
- C112 is complete. Its radius-three cubic classification uses the projective-boundary circuit hinge in
  `FiniteGeom/ProjectiveAxisTwistedCubicCircuits.lean` proves that two distinct finite cubic
  points `s,t`, cubic infinity, and axis point `s+t` form a four-circuit, and proves uniqueness of
  that normalized axis completion. The all-finite completion theorem remains the existing
  determinant result. The module now also proves independence of every distinct three-cubic,
  two-cubic/one-axis, and one-cubic/two-axis family in the completed system, with all infinity
  placements explicit, including cubic infinity with three finite cubic points.
- The independent verifier now enumerates every circuit of size at most five at q=3 and q=9 and
  solves the resulting matching and transversal problems exactly. It confirms all proposed
  radius-three and radius-four rows, including the q=3 boundary. This is a refutation gate, not a
  substitute for the general Lean proofs.
- `RepairCodes/ProjectiveAxisTwistedCubicInvariants.lean` proves the D-PC10 projective parameter
  permutation and its ambient invertible linear realization, including normalized action formulas
  on every finite, pole, and infinity case. It now packages the full index permutation and
  everywhere-nonzero column scales and proves preservation of linear independence for every
  indexed column family and every finite selected support, then proves exact preservation of the
  column-circuit predicate including all one-point deletions. The generic minimal-dual-support/
  column-circuit bridge and exact zero-sum clutter identification are the current XH2 obligations.
- `RepairCodes/ProjectiveAxisTwistedCubic.lean` now exposes the complete and inclusion-minimal
  repair hypergraphs, proves every repair edge nonempty, reduces their matching/transversal
  invariants to the minimal clutter, and supplies the circuit-to-actual-repair bridge. It also
  lifts the mixed-triple geometry to arbitrary selected Finsets and proves the exact radius-two
  axis-repair shape: every such edge consists of two distinct other axis coordinates, with no
  cubic helper. This direct theorem removes the short-edge part of the generic support-bridge
  obligation. It now also proves the exact radius-three clutter at axis infinity: the minimal
  edges are precisely pairs of other axis coordinates and finite cubic triples with parameter sum
  zero. All mixed shapes and every cubic-helper triple containing cubic infinity are excluded.
- `RepairCodes/ProjectiveAxisTwistedCubicInvariants.lean` proves that this distinguished completed
  clutter is exactly the natural embedding of the already formalized affine nucleus clutter.
  Consequently its matching and transversal numbers are kernel-proved as
  `(5q-3)/6` and `2q-1-Z3(q)`. The generic monomial repair-transport theorem in
  `FiniteGeom/Repair.lean` now proves that D-PC10 relabels the complete bounded repair hypergraph
  exactly, so the same row is kernel-proved for every finite or infinite axis target. XH2 is
  closed for the axis row, and the same transport is now reused for the completed cubic row.
- `RepairCodes/ProjectiveAxisTwistedCubic.lean` now classifies the complete radius-three repair
  hypergraph at cubic infinity: its edges are exactly
  `{C(s),C(t),A(s+t)}` for `s≠t`. The proof separately excludes three finite cubic helpers, one
  finite cubic plus two axes, and three axes; the last case uses the final coordinate of an actual
  full-support dual relation and is not inferred from dependence alone. It also proves there are
  no shorter cubic-infinity repairs.
- `RepairCodes/ProjectiveAxisTwistedCubicInvariants.lean` embeds the existing consecutive-power
  rainbow matching to prove `nu=(q-1)/2`, proves `tau=q-1` by an explicit covered/uncovered
  endpoint-and-color count, and transports both invariants to every projective cubic target via
  D-PC10/D-PC11. Matching/transversal invariance under clutter reduction yields the exact uniform
  minimal-clutter row. The focused and aggregate `RepairCodes` builds, forbidden-token scan, and
  standard-axiom audit pass.
- `FiniteGeom/Repair.lean` now proves the generic complete-inner chain: a minimal repair's helper
  columns are linearly independent; every `k`-row minimal repair has at most `k` helpers; minimal
  repair clutters stabilize at radius `k`; and full-port transversals are equivalent to separating
  linear functionals. The latter makes the exact transversal number the complement of the largest
  target-avoiding hyperplane section, minus the target.
- For the completed seed, the largest target-avoiding sections have sizes `q+2` at a cubic target
  and `4` at an axis target. Radius four therefore exhausts the full minimal inner port and has
  exact uniform rows `((q-1)/2,q-1)` and `((5q-3)/6,2q-3)`. The matching proof covers all
  radius-four minimal edges through resource inequalities; it does not assume or claim an explicit
  catalogue of every five-circuit. Generic monomial transport now relabels minimal clutters as well
  as complete bounded repair hypergraphs. Focused and aggregate builds, forbidden-token and
  whitespace scans, standard-axiom prints, q=3 arithmetic, target/off-by-one review, and XH3/XH4
  pass.
- `RepairCodes/ProjectiveAxisTwistedCubicLift.lean` proves `[20N,4K,>=9D]_9`, the exact
  `10N/10N` cubic/axis partition, exact locality three/two, and exact radius-four rows
  `(nu,tau)=(4,8)` and `(7,15)`. Ordinary outer dual distance six is the checked gate. The
  conclusion is bounded hypergraph equality through radius four, never an unbounded full-port
  statement for the concatenated code.
- `RepairCodes/ProjectiveAxisTwistedCubicAsymptotic.lean` specializes the quarantined Stichtenoth
  family to unbounded length, exact rate `1/10`, every eventual relative-distance bound
  `c<351/1600`, the clean eventual `1/5` bound, exact coordinate multiplicities, locality, and
  radius-four rows. XH5, focused and aggregate builds, scans, and the axiom audit pass. C113 is
  complete; C114 owns literature and publication promotion.

## Mandatory xhigh review checkpoints

Lower-effort implementation may proceed between these checkpoints, but must not close or publish
the corresponding claim before xhigh review.

1. **XH1 — C111 final audit.** Review the finite/infinity section split, projective-distinctness
   statement, exact dual-distance proof, small-field edge case `q=3`, and independent mutation
   controls before marking C111 reported.
2. **XH2 — completion-fiber equivalence.** Review the claimed equivalence between every projective
   cubic-triple completion fiber and the existing zero-sum hypergraph before using it to derive the
   uniform axis row. This is the main new finite-geometry hinge.
3. **XH3 — complete-inner-port theorem [PASSED 2026-07-13].** Review the rank-four circuit cutoff together with the
   blocker/local-primal equivalence and all off-by-one conventions. The theorem may identify the
   full *inner* minimal port only; it must not silently become the unbounded port of a lift.
4. **XH4 — exact radius-four axis row [PASSED 2026-07-13].** Review both the weighted matching upper bound and the
   target-conditioned primal/section calculation giving `tau=2q-3`, including `q=3`.
5. **XH5 — transfer/asymptotic promotion [PASSED 2026-07-13].** Review `r=4` transfer gates, coordinate
   multiplicities, rate/distance arithmetic, and the exact scope of transferred supports before
   C113 is stated in prose.
6. **XH6 — novelty and headline language [PASSED 2026-07-13].** Review the primary-source citation chain and separate
   classical geometry, standard matroid consequences, family-specific repair formulas, and the
   asymptotic synthesis before any novelty or priority wording is committed.
7. **XH7 — exact section/weight distribution.** Before expanding scope, review the moment-count
   derivation, its dependence on the complete triple classification, the conversion from
   projective plane classes to codeword multiplicities, and the twisted-cubic/code weight-enumerator
   literature.

## Discovery Track register

This register contains only unplanned mathematical findings encountered while executing C111–C114.
It does not duplicate planned deliverables, implementation progress, validation results, or task
closure. `CHECKED` means independently replayed finite evidence; `LEAN` means kernel-proved;
`LIT-OPEN` means no exact predecessor has yet been located; and `PAPER` is allowed only after proof
and novelty promotion.

| ID | Discovery | Proof status | Novelty posture | Next gate / destination |
|---|---|---|---|---|
| D-PC9 | The completed seed appears to have exactly five nonzero weights: projective section counts `N1=q(q²-1)/3`, `N2=q(q²-1)/2`, `N3=q(q+1)`, `N4=q(q²-1)/6`, `N(q+2)=q+1`; hence exactly `q²-1` minimum-weight words | `CHECKED` independently at q=3,9,27; general moment proof sketched, not Lean | potentially stronger coding-theoretic contribution; `LIT-OPEN` | XH7; prove from plane moments/triple classification, then targeted weight-enumerator search |
| D-PC10 | Projective shifted inversion is induced by the explicit ambient coordinate change `(x₀,x₁,x₂,x₃) ↦ (a³x₀+x₃, a²x₀-ax₁+x₂, ax₀+x₁, x₀)`; it preserves the completed cubic–axis system and sends finite axis target `A(a)` to `A(∞)` | full monomial action, exact circuit preservation, exact complete-repair-hypergraph relabeling, and the uniform axis row `LEAN` | structural unification, not by itself a novelty claim | XH2 axis gate closed; reuse the same transport for the cubic row |
| D-PC11 | Any monomial automorphism of a generator's column configuration—an ambient linear equivalence, coordinate permutation, and nonzero column scales—relabels every complete bounded repair hypergraph exactly | generic forward/backward full-support relation transport `LEAN`; instantiated by D-PC10 to close the uniform completed-axis row | reusable formal infrastructure; expected standard, no novelty claim | reuse for cubic-target transitivity and future repair-code symmetries; mention in proof architecture only |

When a discovery becomes planned work, allocate it separately but keep this row as the concise
discovery verdict. Negative investigations belong in the companion archive.

## C111 proof obligations and refutation gates

1. Define the cubic index `F + Unit`, with infinity column `(0,0,0,1)`, and keep the axis index
   `F + Unit` with columns `(0,1,u,0)` and `(0,0,1,0)`.
2. Prove all columns are nonzero and no projective duplicate occurs, including across the two
   blocks.
3. Prove a plane containing the axis meets the full cubic in exactly one point: if the `X3`
   coefficient vanishes the point is cubic infinity; otherwise Frobenius gives the unique finite
   point.
4. Prove a plane not containing the axis meets it in at most one point and the full cubic in at
   most three points, treating the cubic-infinity branch explicitly.
5. Exhibit a `q+2` section, prove spanning dimension four, and derive `[2q+2,4,q]_q`.
6. Prove dual distance three from axis triples and pairwise projective independence.
7. Refute against independent exhaustive data at `q=3,9,27` where feasible; require coordinate
   conjugation and one-column mutation controls. Failed formulas are rewritten or demoted before
   further formalization.

## C112 proof obligations and off-ramps

1. Classify the radius-three clutters exactly. At radius four, prove statements over every minimal
   repair edge; an explicit five-circuit catalogue is optional and is not a paper claim. Never infer
   completeness from a selected repair family.
2. Cubic target, radius three: **closed in strict-trust Lean**. Every edge is a pair of other
   projective cubic points with its unique axis completion; `nu=(q-1)/2` and `tau=q-1` uniformly.
3. Axis target, radius three: split the clutter into the complete pair graph on the other `q` axis
   points and a projective cubic-triple completion fiber; prove the fiber is equivalent to the
   existing zero-sum system and derive `nu=(5q-3)/6`, `tau=2q-1-Z3(q)`.
4. Prove the rank-four circuit-size bound in the code-derived API, so radius four contains every
   minimal inner repair.
5. Prove the full-inner transversal formula from a kernel-checked blocker/local-primal statement
   or an equally explicit direct argument. Prove the axis matching upper bound by a weighted
   vertex budget and reuse the radius-three matching for equality.
6. State separately what transfers to a lift: equality of bounded radius-four supports, not the
   unbounded full port of the concatenated code.

If the general projective completion fiber does not reduce cleanly to the existing zero-sum
hypergraph, retain C111 as a seed theorem and demote C112–C113. If exact radius-four transversals
require substantial new finite-geometry input, ship the proved radius-three family first and keep
the full-port result queued.

## Publication boundary

C114 promoted the proved projective-completion results into the manuscript, PDF, proof ledger, and
paper registries. Formal correctness is not novelty evidence. The bare twisted cubic, common axis,
ordinary code parameters, generic rank-four circuit cutoff, concatenation, and asymptotic
rate/distance arithmetic are classical or derived. Only the exact union-code repair profiles and
their complete bounded-support transfer retain cautious “candidate contribution” / “we did not
locate” wording. External specialist citation-chain review remains required before submission.
