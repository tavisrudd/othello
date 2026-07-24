# C547 — explanatory Lean proof harvest for the cap residual Grundy structure

**Lane:** `cap`. **Status:** complete. **Predecessors:** C80/C523/C524/C528.

## Verdict

The exact explanatory package is now Lean-checked in:

- `ProjectiveCap.ResidualHypergraph`;
- `ProjectiveCap.ResidualPairBudget`.

The formalization proves the rank-three residual decomposition, its
no-active-triples/Node--Kayles specialization, the pair-budget and overload
bounds, generic and cap-height Grundy bounds, isolated-gadget zero, and the
follower-signature mex bound.

The proposed clean-leaf truncation has the right **one-boundary** shape but the
wrong general replacement rule once a gadget has two boundary vertices. A
five-versus-six-vertex counterexample shows that replacing every `k≥3` gadget
by a 3-gadget can change SG from `0` to `1`. The corrected boundary signature
must retain:

```text
the labelled boundary vertices and their ambient constraints
+ min(2, number of private vertices)
+ the selected occupancy (0, 1, or 2) of the gadget.
```

For one boundary vertex and `k≥3`, there are automatically at least two
private vertices, so truncation to a 3-gadget preserves this signature. For
two boundary vertices, a 3-gadget has one private vertex while a 4-gadget has
two, and that lost bit is game-visible.

No uniform `SG≤5` statement is claimed. The formal results explain why
isolated size and duplicate followers are harmless; they do not yet prove
that projective residual cores have a bounded number of boundary signatures.

## Lean theorem dependency map

```text
FiniteBuildGame.mex_le_card
  ├─ grundy_le_followerValues_card
  │    └─ grundy_le_card_of_follower_signature
  ├─ grundy_le_remaining
  └─ grundy_le_of_valid_card_bound
       └─ ResidualHypergraph.gridGrundy_le_of_extension_card_bound

ResidualHypergraph.gridCap_iff_allSmallSubsetsCap
  ├─ gridCap_pair_iff
  ├─ minimal_not_gridCap_card
  └─ exists_small_bad_extension
       ├─ minimal_bad_extension_card
       └─ gridCap_union_iff_all_pairs
            [under NoActiveResidualTriples]

FiniteBuildGame.grundy_atMostTwo_empty_eq_zero
  [isolated load-zero gadget SG = 0]

ResidualHypergraph.pairBudget
  ├─ three_mul_card_le_pairBudget
  │    └─ card_le_pairBudget_div_three
  ├─ choose_mul_largeMembers_card_le_pairBudget
  │    └─ largeMembers_card_le_pairBudget_div_choose
  └─ three_mul_totalOverload_le_pairBudget
       └─ totalOverload_le_pairBudget_div_three
```

Bearing on the C528 mystery:

- `gridCap_iff_allSmallSubsetsCap` and `minimal_bad_extension_card` prove that
  every residual really is a fixed rank-at-most-three hypergraph game.
- `gridCap_union_iff_all_pairs` is the exact static `Y_NK` specialization:
  once minimal triples are absent, pair constraints completely determine
  continuation validity. Combined with the already reviewed persistence
  argument, this is the static half of the full game-tree Node--Kayles bridge.
- `grundy_atMostTwo_empty_eq_zero` proves neutral isolated bulk for every
  gadget size, not merely for the computed orders.
- the pair-budget theorems control gadget count, large-gadget count, and total
  overload, but grow quadratically with the legal set and therefore do not
  explain `SG≤5`.
- `grundy_le_card_of_follower_signature` identifies the missing theorem
  exactly: a uniform bound on rooted boundary signatures would imply a
  uniform SG bound immediately.

## Exact rank-three and `Y_NK` statements

`gridCap_iff_allSmallSubsetsCap` proves:

```text
GridCap X
↔ every U⊆X with |U|≤3 is a GridCap.
```

`exists_small_bad_extension` keeps the old state fixed: every invalid
continuation `S∪T` contains an invalid `S∪U` with `U⊆T`, `|U|≤3`.
If the new points are individually legal, `two_le_card_of_bad_extension`
excludes sizes zero and one. Thus `minimal_bad_extension_card` gives exactly
`|U|=2` or `|U|=3`.

`gridCap_pair_iff` identifies the size-two case geometrically: for distinct
cells `p,q`, the pair is forbidden exactly when they share a row or a column,
the two load-one projective line families through the fixed opening points.
After those pair obstructions are removed, the only remaining rank-three
failure is an affine-collinear triple on a load-zero line.

`NoActiveResidualTriples S` says every inclusion-minimal invalid extension on
the legal vertex set has size two. Under that hypothesis,
`gridCap_union_iff_all_pairs` proves:

```text
GridCap (S∪T)
↔ every two-element U⊆T has GridCap (S∪U).
```

This is the precise static collapse to the conflict graph. It deliberately
does not restate game-tree persistence or compute the graph's Grundy value.

## Proof-grade numerical bounds

For a linear family `family` of overloaded-line supports inside a legal set
`V`, `PairSupportsDisjoint` records the projective-plane fact that distinct
lines cannot contain the same unordered point pair. Lean proves:

```text
Σ_A choose(|A|,2) ≤ choose(|V|,2)

|family| ≤ choose(|V|,2)/3                   if |A|≥3

#{A: |A|≥r} ≤ choose(|V|,2)/choose(r,2)      if r≥2

Σ_A (|A|-2) ≤ choose(|V|,2)/3                if |A|≥3.
```

`FiniteBuildGame.grundy_le_of_valid_card_bound` proves the general height
principle from a continuation-cardinality bound. Its grid specialization
`gridGrundy_le_of_extension_card_bound` yields

```text
SG(S) ≤ q-1-|S|
```

as soon as the standard odd-plane arc bound is supplied in residual form
`|T|≤q-1` for every valid continuation `T⊇S`. The general theorem is checked;
this task does not newly formalize the classical odd-plane arc bound.

## Isolated gadget and follower signatures

`FiniteBuildGame.AtMostTwo` is the isolated load-zero line game. Lean proves
`grundy_atMostTwo_empty_eq_zero` whenever the gadget has at least two
vertices. The proof is the direct second-player strategy: reply with a
different vertex; every third move is then illegal.

`FollowerValues` deduplicates option nimbers before mex.
`grundy_le_followerValues_card` bounds SG by the number of distinct option
values, and `grundy_le_card_of_follower_signature` proves the reusable
factorization form:

```text
child SG factors through a finite signature type β
⇒ root SG ≤ |β|.
```

This theorem covers automorphism orbits and rooted game-tree equivalence
without falsely claiming that generic projective stabilizers are large.

## Clean-leaf boundary: counterexample and corrected conjecture

Let `A` be one load-zero gadget, so at most two vertices of `A` may be chosen.
Take boundary vertices `v₁,v₂∈A`, private vertices `U`, and ambient leaves
`w₁,w₂` with the only ambient constraints

```text
{v₁,w₁} forbidden,  {v₂,w₂} forbidden.
```

There are no other constraints involving private vertices.

- For the 3-gadget `A={v₁,v₂,u}`, the root option nimbers are
  `{2,2,0,0,0}` (play `v₁`, `v₂`, `u`, `w₁`, `w₂`), hence root SG is `1`.
- For the 4-gadget `A={v₁,v₂,u₁,u₂}`, the root option nimbers are
  `{2,2,3,3,3,3}`, hence root SG is `0`.

Thus a two-boundary 4-gadget cannot be replaced by a 3-gadget. This is not a
fixed-field table: it is a six-vertex abstract residual counterexample to the
proposed local rewrite.

The corrected minimal-boundary conjecture is:

> If all constraints outside the complete triple family on
> `A=B∪U` meet `A` only in the labelled boundary `B`, then the rooted game
> depends on the private set `U` only through `min(2,|U|)`, together with the
> selected occupancy of `A` and the ambient state on `B`.

The `min(2,|U|)` truncation is forced by the counterexample and is sufficient
at the option-type level: no legal play selects more than two gadget vertices,
and all private vertices have identical followers. Turning this last
bisimulation argument into Lean is the exact remaining local lemma. The
original one-boundary claim is its immediate `|U|≥2` corollary.

## Mystery ledger (ej+tt closeout)

- **[OPEN — load-bearing] Why is the full residual SG at most 5 in the
  q17/q19 corpus?** The formal package eliminates raw gadget size, duplicate
  followers, and isolated components as explanations. The remaining evidence
  gap is a uniform bound on the number of private-count-truncated boundary
  signatures in the coupled incidence core.
- **[SETTLED] What is the exact residual rank?** At most three, with
  inclusion-minimal legal-vertex obstructions exactly pairs or triples.
- **[SETTLED] What exactly is the static `Y_NK` boundary?** Absence of
  inclusion-minimal residual triples; then all continuation validity is
  determined by two-element subsets.
- **[SETTLED] Can large isolated gadgets carry value merely because `k`
  grows?** No; every isolated `k≥2` gadget has SG zero.
- **[SETTLED negative] Does “one attachment vertex” generalize to arbitrary
  bounded boundary while always truncating to a 3-gadget?** No; the explicit
  two-boundary 3-versus-4 example changes SG.
- **[SETTLED correction] What boundary datum did the first conjecture omit?**
  The private multiplicity class `0`, `1`, or `≥2`. For one boundary and
  `k≥3`, it is automatically `≥2`.
- **[OPEN] Does the corrected `min(2,|U|)` boundary signature admit a
  kernel-checked rooted-game bisimulation?** The option analysis says yes; a
  formal theorem would be the clean local successor, but is not needed to
  state the corrected boundary precisely.
- **[OPEN, inherited] Why does SG 3 dominate q17 but disappear at q19?**
  None of the q-uniform scaffolding distinguishes the orders. Its owner
  remains the coupled defect-skeleton/component analysis, not conic type.

The `ej` pass exposed the division-form overload corollaries and the generic
valid-card height theorem as free reusable upgrades, and both were proved.
The `tt` pass forced the two-boundary test rather than accepting the
one-boundary proof sketch as evidence for a broader truncation law; that test
found the missing private-count bit.

## Validation and trust boundary

Scoped single-file elaboration passed for both new modules:

```text
lean/scripts/guarded-lean ProjectiveCap/ResidualHypergraph.lean
lean/scripts/guarded-lean ProjectiveCap/ResidualPairBudget.lean
```

The modules carry their own terminal `#print axioms` audits. The isolated
gadget theorem, static `Y_NK` specialization, follower-signature theorem, and
total-overload division bound each report exactly:

```text
[propext, Classical.choice, Quot.sound]
```

There are no project-specific axioms, `sorry`, native decisions, generated
tables, or external certificates in this proof package. The standard
odd-plane arc bound used to instantiate `SG(S)≤q-1-|S|` is an explicit
upstream hypothesis of the grid height theorem, not silently assumed or
reproved here.

## Purpose

Turn the C80/C528 structural picture into proofs that explain why a residual cap
game is simpler than its raw overloaded-line count. Lean is a theorem-design
instrument here: definition friction, failed generality, and missing hypotheses
are expected deliverables when they identify the true boundary object.

This is **not** a fixed-q certificate task and does not formalize the empirical
claim `SG≤5` as though it were uniform.

Evidence hierarchy:

```text
computation discovers the phenomenon
→ certificates secure the finite headline and prevent regression
→ mechanisms/theorems explain it and support generalization.
```

The C528 certificates remain load-bearing evidence for the q17/q19 SG≤5
headline and should not be removed or discounted. They are the second tier:
C547 may consume them as falsifiers, examples, and theorem regression tests,
but its primary output is the third-tier explanatory mathematics.

## Cold start

Read, in order:

1. the cap handoff's C523/C524/C528 bullets;
2. `notes/2026-07-23-c523-ynk-guard-proof.md`;
3. `notes/2026-07-23-c80-descent-fable-review.md`;
4. `notes/2026-07-23-c528-grundy-conic-census.md`;
5. the complete nested `lean/AGENTS.md` before any Lean operation.

Then inspect only the existing definitions needed from `CapGame/BuildGame.lean`,
`ProjectiveCap/GridGame.lean`, and `ProjectiveCap/IntrusionCalculus.lean`.

## Theorem program

### A. Exact static residual object

For a cap state `F={a,b}∪S` with legal set `V=L(S)`, prove that legal
continuations `T⊆V` are exactly those satisfying

```text
|T∩ℓ| ≤ 2-|F∩ℓ|
```

for every projective line `ℓ`. Extract the minimal forbidden sets:

- pairs on load-one lines;
- triples on load-zero lines.

Corollary: every residual is a fixed rank-at-most-three hypergraph-building
game, and C523's `Y_NK` theorem is exactly the no-active-triples specialization.

### B. Proof-grade bounds

For overloaded lines with legal sizes `k_ℓ≥3` among `n` legal points, prove

```text
Σ_ℓ binom(k_ℓ,2) ≤ binom(n,2),
g ≤ binom(n,2)/3,
#{ℓ:k_ℓ≥r} ≤ binom(n,2)/binom(r,2),
Φ=Σ_ℓ(k_ℓ-2) ≤ binom(n,2)/3.
```

Also isolate the generic SG-height bound `SG(S)≤h(S)` and, using the odd-plane
arc bound, `SG(S)≤q-1-|S|` for residual affine state `S`.

### C. Neutral bulk and boundary signatures

Prove first:

- an isolated load-zero `k`-gadget has SG 0 for every `k≥2`;
- disjoint isolated gadgets cancel as a zero sum;
- duplicate/isomorphic followers do not enlarge mex, hence
  `SG(S)` is bounded by the number of distinct follower-equivalence classes
  (automorphism orbits are one sufficient upper bound).

Then formulate and test the **clean-leaf truncation lemma**:

> If a `k≥3` gadget meets all other minimal forbidden constraints through at
> most one boundary vertex and its other vertices are private, replacing it by
> the corresponding 3-gadget preserves the rooted game.

If this hypothesis is too strong in the projective residual, the formalization
must identify the minimal replacement boundary data. That corrected boundary
object—not a forced proof of the first statement—is the main research output.

### D. Toward the observed bounded defect

Use the proved local rewrites to define the full constraint-incidence core.
Determine whether tree tendrils admit finitely many rooted boundary signatures
and whether the remaining paths/cycles reduce to the Dawson/octal component
calculus. State the exact additional lemma needed to turn this into a uniform SG
bound; do not claim `SG≤5` without it.

## Acceptance

C547 succeeds if it delivers:

1. Lean-checked versions of A and the elementary bounds in B, reusing existing
   cap-game definitions rather than building an unrelated framework;
2. at least the isolated-gadget and follower-signature lemmas from C;
3. either a Lean-checked leaf/boundary reduction or a precise counterexample and
   corrected minimal-boundary conjecture;
4. a paper-readable theorem dependency map explaining which result bears on
   C528's SG≤5 mystery and which results are only scaffolding;
5. an `ej+tt` mystery ledger and scoped builds/axiom audit under the nested Lean
   rules.

It does **not** succeed merely by encoding q17/q19 tables, translating the
Python checker, or adding definitions with no explanatory theorem.

## Guardrails

- Do not formalize the empirical q17/q19 SG ceiling as a general theorem.
- Preserve and cite the fixed-q certificates where they support finite
  headlines; do not substitute their formal verification for a mechanism.
- Do not start a broad generic hypergraph-game library unless the existing
  `BuildGame` abstractions provably cannot express A.
- Do not use ordinary homotopy/collapse arguments as value preservation without
  a game-tree or Grundy-equivalence theorem.
- Do not assume bounded-depth winning strategies bound SG; they do not.
- Treat conic type as rejected as a value decomposition by C528.
