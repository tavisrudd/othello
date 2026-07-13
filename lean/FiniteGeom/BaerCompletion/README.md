# BaerCompletion Lean lane

Proof lane for
[`paper-baer-equivariant-robust-completion.md`](../../../notes/2026-07-12-riffing-on-applications/paper-baer-equivariant-robust-completion.md).

The abstract proof spine and abstract-projective-plane consumers are kernel-checked. See
[`TRUST.md`](TRUST.md) for the theorem manifest and formalization boundaries, and the
[`paper-specific novelty audit`](../../../notes/2026-07-13-baer-completion-adversarial-novelty-review.md)
for the independent claim boundary. Shared support lives in `FiniteGeom.Completion`, `FiniteGeom.Hypergraph`,
`FiniteGeom.MomentCurve`, and `FiniteGeom.Code`.

The completion/transversal, clutter, weighted, prescribed-set, secant-index, involution-orbit,
Hilbert-90, and elementary incidence-counting declarations are classical infrastructure that this
lane formalizes for trust and reuse. The principal plausibly unrecorded mathematical assembly is
the exact quadratic-Frobenius orbit-extension criterion. Formalization is not evidence of priority.

Planned modules, in dependency order:

1. `Obstruction.lean` — **landed:** hereditary systems, complete dependent traces, the semantic
   insertion equivalence, and `insertionDistance_eq_transversalNumber`;
2. `Clutter.lean` — **landed:** minimal-edge reduction preserves all transversals and `τ`;
3. `Weighted.lean` — **landed:** weighted insertion distance equals weighted transversal cost;
4. `MultiInsertion.lean` — **landed:** simultaneous insertion of any prescribed finite set has
   exact obstruction-transversal distance; singleton insertion is recovered definitionally;
5. `Secant.lean` — **landed:** pairwise-disjoint transversal theorem and abstract secant
   resilience `insertionDistance_eq_secantCount`;
6. `BaerPlane.lean` — **landed abstractly:** involutive incidence, conjugate trace transport,
   fixed-line pair classification, and disjoint conjugate-line traces; the abstract projective-plane
   instance is in `RelativeConicArcs.BaerIncidence`, the coordinate semilinear action is in
   `RelativeConicArcs.ProjectiveConjugation`, and the quadratic relative-Frobenius instance is in
   `RelativeConicArcs.QuadraticFrobenius`, including its Hilbert-90 fixed-locus and linewise
   candidate-pair counts; `RelativeConicArcs.QuadraticPairExtension` packages the resulting
   automatic `candidate_count` field;
7. `PairExtension.lean` — **landed:** exact distinct-forbidden-support counting, heterogeneous and
   uniform upper-bound forms, positive-surplus
   existence, and the exact quadratic data wrapper; `RelativeConicArcs.QuadraticLineCounting` and
   `RelativeConicArcs.QuadraticForbidden` discharge its coordinate count fields and prove that a
   surviving candidate really extends the arc;
8. `CollisionProfile.lean` — **landed:** exact visible-support, invisible-mass, and collision-
   redundancy decompositions, linewise and in aggregate, together with the capped-multiplicity
   inequalities used by the order-five moment argument; `RelativeConicArcs.QuadraticCollision`
   identifies the support with the coordinate forbidden set and proves a semantic aggregate
   extension criterion;
9. `OrbitCounting.lean` — **landed:** constant-fiber candidate counting, complement counting for
   empty fixed lines, and injective charging for forbidden candidates reduce the three wrapper
   fields to elementary incidence maps;
10. `OrbitSaturation.lean` — **landed:** denominator-free split-product and quadratic
   orbit-saturation bounds;
11. `RobustHole.lean` — **landed:** below-`τ` surviving obstructions and stability whenever old
   obstructions persist;
12. `Core.lean` — **landed in abstract form:** completion cores and the sharp unique-completion
   deletion theorem;
13. `ClassicalFamilies.lean` — future exact radii once family-specific incidence counts are supplied.

No theorem is formalized merely because it is listed here. The paper's theorem-by-theorem
formalization boundaries remain authoritative until declarations land.
