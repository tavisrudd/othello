# C1120: stabilization corollaries at their natural strength

**Lane:** `cubic-threefolds`
**Date:** 2026-09-07

## Results and placement

All five requested deductions are proved in the authority manuscripts.
The lower-bound paper strengthens its existing threefold marker corollary.
Sharpness strengthens its principal exact-level statement and puts the
generic-surface, specified-partner and fibration consequences together in
Section 5, beside their proofs. These are consequences of the established
arguments; no separate novelty claim or new quantum computation is made.

1. **Positive-marker threefolds.** For a smooth projective complex
   threefold Y with I(Y)>0, the projective-bundle formula gives
   I(Y x P1)=2I(Y)>0. Every center in a weak factorization of fourfolds has
   dimension at most two, hence contributes zero. Since I(P4)=0, Y x P1
   is irrational. Rationality of Y itself would imply rationality of its
   product, so the former unstabilized conclusion remains a consequence.
   Statement: `cor:threefold-marker` in m1.
2. **Every characteristic-zero field.** The rationalization at level two
   is defined over Q and base-changes. A supposed rationalization at level
   zero or one over F descends together with its inverse, their composition
   identities, and nonzero denominators to a finitely generated F0/Q.
   Embed F0 into C to contradict the complex lower bound. F itself need
   not embed into C. Statement: `thm:cubic-level` in sharpness.
3. **Generic surfaces.** For the actual S_j/Q(t) in the two cubic
   fibrations, base change gives F(X_j)=F(t)((S_j)_F(t)) and preserves the
   two-variable surface rationalization. Rationality of the surface after
   one stabilization would make F(X_j)(u) a rational function field in
   four variables over F, contradicting item 2. Hence its level over
   F(t) is two. This does not assume the original Galois type survives
   extension. Statement: `cor:generic-surface-level`.
4. **Specified partners.** If V x P1 is F-birational to (X_j)_F x P1,
   the product is irrational. One further P1 factor gives
   V x P2 birational to (X_j)_F x P2, hence rational. This gives level
   two for those V. Genus-eight Fano partners are included where the
   required correspondence exists over F; there is no assertion of
   exact level two for every genus-eight Fano.
   Statement/application: `cor:partner-level`, `rem:fano-partners`.
5. **Fibrations.** For a dominant rational map Y to B of geometrically
   integral characteristic-zero varieties whose generic fibre is
   birational to a quartic del Pezzo surface satisfying the surface
   theorem, k(Y)(u,v)=k(B)(z1,z2,z3,z4) up to k(B)-isomorphism. Thus
   Y x A2 is birational to B x A4. The definition directly gives
   ell(W x A^a)=max(ell(W)-a,0), including infinity. Therefore

       max(ell(Y)-2,0) = max(ell(B)-4,0).

   If ell(B)<=4, this only bounds ell(Y) by two. If 4<ell(B)<infinity,
   it gives ell(Y)=ell(B)-2. The infinite case proves that Y is stably
   rational if and only if B is. Statement: `prop:fibration-level`.

## Source and dependency checks

- The exact generic-fibre identification is the one used in the current
  proof of `cor:cubics`, supplied by Tschinkel--Zhang v2 Propositions 5.1
  and 5.3. It is a function-field identification following contraction
  of the distinguished line, not specialization of rational fibres.
  C1116's source report and the full v1/v2 comparison supply the source
  review. A stale 5.2 reference in the public claim-map prose is now 5.3.
- The imported lower bound remains the complex one-stabilization theorem
  at its existing public pin. The finite-coefficient descent is written
  here rather than attributed to that source or to an embedding of F.
- Kuznetsov, *Derived categories of cubic and V14 threefolds*,
  arXiv:math/0303037v1: the Notation paragraph on page 3 specifies an
  algebraically closed characteristic-zero field. Theorems 2.17--2.18
  and their preceding construction give birational rank-two
  projectivizations over the Fano and Pfaffian cubic. These exact passages
  were read from the cached primary source. PDF SHA-256:
  `3223183a958572759e6f8ac3a26a7801c1dd13c6e6edd04f917d1646b5ec2a74`.
  The application records that field range and requires a correspondence
  defined over F elsewhere. No arithmetic descent theorem is inferred.
- Generic triviality here is for vector bundles, so the projectivization
  is birational to a product with P1; a nonsplit Severi--Brauer fibration
  would not justify that step.

## Formal and computational scope

The m1 corollary retains **fragment** coverage. Its existing terminal
`threefold_not_rational_of_occurrenceIndexedMarker` proves the unstabilized
endpoint contradiction. The new product conclusion is a manuscript proof,
not silently attributed to that terminal. The caution and statement digest
were updated after checking this distinction, and the authored dependency
graph now includes the projective-bundle comparison used in the proof.

Sharpness's four new claim rows all have **absent** formal coverage. The
strengthened cubic row, imported-source matches, bibliography, README,
reviewer guide and Zenodo description agree on their domains and dependencies.
No Lean source, numerical certificate, computation implementation, or
validation gate changed. No new computation or full Lean build is claimed.

## Validation

Both authority gates passed after the final source/metadata edits:

```sh
make -C papers/cubic-stabilization-m1 check
make -C papers/cubic-stabilization-irrationality check
```

Logs: `/tmp/claude-run-quiet/20260907-152508-make-C-cubic-stabilization-m1-check/`
and `/tmp/claude-run-quiet/20260907-152508-make-C-cubic-stabilization-irrationality-check/`.
These include the m1 source-only annotation/fragment check and the
sharpness retained certificate derivation, separate checker, metadata and
LaTeX checks. Both warning gates and `git diff --check` passed.
The changed m1 statement on page 2 and the sharpness new consequences and
field-descent proof on pages 9--10 were visually reviewed. The PDFs have
14 and 13 pages respectively.

| PDF | SHA-256 |
|---|---|
| m1 | `a5845fd9769e9cb65d57539bce907713f42f427b788e6e172542a500e39f99a9` |
| sharpness | `f0a3c47a251ce3fcb8588bfa7978404929afa0a5e91c1a5017f870edd80a182b` |

Downstream synchronization follows this committed authority checkpoint.

## Mystery ledger — ej + tt closeout

The post-gate pass rechecked quantifiers, function-field transcendence
degrees, the zero and infinite levels, and the difference between vector
bundles and arbitrary projective-space fibrations.

- **Settled:** fields too large to embed in C pose no obstruction to
  the descent argument; the map and inverse use finitely many coefficients.
- **Settled:** a shrinking Galois image does not endanger the generic-surface
  result; the established rational map base-changes, and the lower bound
  uses the preserved function-field relation.
- **Settled:** the fibration formula gives both directions of stable
  rationality, while preserving the necessary truncation for small levels.
  The equivalence is included in the proposition.
- **Settled boundary:** the Fano application is limited to the specified
  associated cubics and an actual ground-field correspondence. Arithmetic
  construction of further correspondences is not required or claimed.
- No unresolved mathematical mystery remains within these five deductions.
  C1117 still owns additive motivic/spectrum work and C1119 finite-index
  slices; neither is promoted here. These observations were assigned work,
  so there is no incidental discovery-track entry.

No push, deposit, or correspondence is authorized by this task. The
friendly email remains held until the planned paper updates are complete,
with thanks and observations only and no request for feedback.
