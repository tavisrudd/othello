2026-07-09 Review by 5.6 Sol

**Part III Findings**

1. **Items 12 and 7 need a narrower semantic claim.**
   The proposed reply-book format in [Part III item 12](/home/tavis/src/othello/notes/2026-07-07-post-fable-agenda.md:282) covers finite, acyclic normal-play games. It is not yet universal for finite perfect-information games: cyclic games, draws, player-specific pieces, and achievement objectives need different semantics.

   Qubic is therefore not “near-zero marginal tooling.” The current certificates concern impartial common-set placement; Qubic needs alternating ownership, winning-line terminals, and an explicit treatment of draws. Moreover, QBF already has solver-independent strategy certificates in AIGER form via [QBFcert](https://fmv.jku.at/qbfcert), and board-game-to-QBF work already validates winning strategies using certificates in [Shaik–van de Pol](https://arxiv.org/abs/2303.16949). The novel wedge is **domain-native, rules-level, human-inspectable certificates**, not the first universal strategy certificate.

2. **Items 2 and 16 overstate the isomorph-rejection gap.**
   There is already an Isabelle formalization of general isomorph-free exhaustive generation in [Marić et al.](https://pmc.ncbi.nlm.nih.gov/articles/PMC7324030/), and an independently checkable proof system for graph canonical forms in [Banković–Drecun–Marić](https://arxiv.org/abs/2112.14303). Thus “first-of-kind verified classification certificates” and “proof logging has not reached isomorph rejection” are false broadly.

   A still-strong contribution is the **first scalable finite-geometry application**, or integration of canonical-form proofs with enumeration coverage and game-strategy certificates.

3. **The agenda misses the best bridge between Part III and the odd-\(q\) work.**
   I would add a project combining items 2, 12, and 16:

   > **Certified symmetry-reduced finite search:** independently check group actions, orbit-representative coverage, domain legality, and strategy/classification certificates.

   The first instance should be the q23 on-conic orbit reduction plus P certificates. That simultaneously:
   - closes the odd-plane q23 trust chain;
   - formalizes the full `PGL(2,q)` bridge;
   - exercises a generic group-action certificate format;
   - provides a credible methods paper before attempting an old complete-arc classification.

   This is more mature than the queens C11 route, which is currently NO-GO in [the queue](/home/tavis/src/othello/notes/2026-07-07-codex-task-queue.md:267). Projective-cap certificate emission, independent checking, and Lean checking already work for several \(q\).

4. **The torus item misses finite-ring/Hjelmslev geometry.**
   [Item 1](/home/tavis/src/othello/notes/2026-07-07-post-fable-agenda.md:194) must distinguish:
   - all cyclic-subgroup cosets in \(\mathbb Z_n^2\);
   - three-term-AP collinearity;
   - affine Hjelmslev lines, whose directions are unimodular.

   These produce different problems. Also, the evident symmetry group contains the full affine group `Z_n² ⋊ GL(2,Z_n)`, not merely a monomial-affine group.

   More importantly, arcs over finite chain rings have an active literature and current open tables: see the [Bayreuth Hjelmslev arc table](https://www.algorithm.uni-bayreuth.de/en/research/Coding_Theory/PHG_arc_table/) and [2024 updated small-ring bounds](https://arxiv.org/abs/2409.02099). A verified exact result closing one of those bounds may be more valuable than a miscellaneous composite-\(n\) torus census. It also naturally combines items 1, 2, and 13.

5. **Items 3 and 10 should be rebased, not deferred.**
   Segre in Lean remains high-value, but current mathlib already has projective-plane configurations, projectivization collinearity, unique lines, and projective group actions; see [Configuration.ProjectivePlane](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Combinatorics/Configuration.html) and [Projectivization.Collinear](https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/Projectivization/Collinear.html).

   The immediate upstreamable layer is now narrower:
   - arcs and ovals;
   - projective quadratic forms and conics;
   - conic parametrization and stabilizer action;
   - five-arc conic uniqueness;
   - the symmetric-square `PGL(2) -> PGL(3)` construction.

   Those pieces directly advance the odd-\(q\) proof and form genuine partial credit toward Segre. They should start before the whole Segre theorem, not wait for it.

6. **Item 15 is based on stale Lean infrastructure and an overly easy claimed connection.**
   Mathlib no longer contains `SetTheory.Game`; it moved to the external [CombinatorialGames package](https://github.com/vihdzp/combinatorial-games), as the local [Lean README](/home/tavis/src/othello/lean/README.md) records. More importantly, composing Joyal strategy morphisms is not supplied “for free” by serializing reply books. This remains interesting, but it is an independent formalization project and should be removed from item 12’s critical path.

7. **Items 9, 11, and 13 are not currently bankers.**
   - JOSS presently requires an OSI license, coherent reusable software, documented community significance, and evidence beyond a newly released one-off tool. The repo currently has no visible license, one contributor, and several research programs mixed into one repository. [JOSS’s criteria](https://joss.readthedocs.io/en/latest/review_criteria.html) make the stated 85% unrealistic. A Zenodo release is immediate; JOSS should follow extraction and public use.
   - I do not see evidence that the complete affine-cap spectra through q19 in item 11 have actually been enumerated. Existing runs count selected maximal-cap classes for game diagnostics. Item 11 needs a sizing and definition gate.
   - Database rows cannot individually certify that a census is complete. Item 13 needs release-level manifests containing the universe specification, enumeration-coverage certificate, canonicalization certificate, representative hashes, and checker versions. Otherwise it certifies objects but not omitted objects.

8. **Item 14 needs an experiment, not only a case study.**
   The caught-error ledger is valuable evidence, but a publishable “soundness engineering” claim needs prospective comparison: the same research tasks with and without audit gates, measuring false-claim survival, correction rate, cost, and time. Public repo tasks are contaminated as a benchmark, so the benchmark needs held-out mutations or newly generated falsification cases.

**Revised Part III Priority**

1. Certified symmetry-reduced search, instantiated on q23.
2. Upstreamable conic/PGL formalization supporting that certificate.
3. Torus versus Hjelmslev specification and one-day open-bound scout.
4. Domain-native acyclic-game certificate specification, explicitly positioned against QBF certificates.
5. Empirical soundness-engineering study.
6. Segre formalization.
7. Qubic only after the certificate semantics support it.
8. Database and JOSS after the underlying artifacts become coherent releases.
