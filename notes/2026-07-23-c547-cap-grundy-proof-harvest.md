# C547 — explanatory Lean proof harvest for the cap residual Grundy structure

**Lane:** `cap`. **Status:** queued for a fresh session. **Predecessors:** C80/C523/C524/C528.

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
