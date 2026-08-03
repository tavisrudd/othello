# C855 — Lean ecosystem survey: does anything outside Mathlib supply our missing classical pieces?

Date: 2026-08-03. Lane: relconic (Paper I Lean remediation, C855).
Scope: read-only web/API survey. Question: for each classical ingredient our Paper I
formalization needs and our pinned Mathlib lacks, does a *non-Mathlib* Lean 4 development
already contain it, at statement level, in an importable or adaptable form?

Method: GitHub REST repository search (unauthenticated, bounded), raw-file inspection of
candidate repositories (declaration headers and `sorry` counts, not READMEs), arXiv search
for 2024–2026 Lean formalization papers, Lean Zulip archive, Mathlib PR search.
Every "what it proves" line below is read off actual `theorem`/`def` headers in the source,
not off project self-description.

Verdict labels used per hit:

- **import-as-dependency** — could be added to `lakefile` and used directly.
- **adapt-the-proofs** — license and content permit copying/porting statements or proof
  ideas into our tree; not worth a dependency edge.
- **cite-as-prior-art-only** — relevant to a novelty claim, but supplies no usable Lean code.

---

## 1. Finite projective plane coordinate geometry (conics, arcs, ovals, hyperovals, nuclei, tangent/secant/passant lines)

### PSchwahn/IncidenceGeometry — closest existing Lean 4 development

- Repository: https://github.com/PSchwahn/IncidenceGeometry
- Toolchain: `leanprover/lean4:v4.24.0-rc1`; `require mathlib from git` on master (unpinned).
- License: **none declared** (all rights reserved). This alone blocks both import and copying.
- Maintenance: last push 2025-10-11; 0 stars; single author; no blueprint, no CI badge observed.

What it actually contains (from declaration headers):

- `IncidenceGeometry/Defs.lean`: `class IncidenceGeometry` (points `P`, lines `L`, incidence
  `𝐈`), `Intersect`, `Collinear`, `Concurrent`, `IncidenceEquiv`, `Collineation` with its
  `Group` instance; `class ProjectivePlane`, `class ProjectiveSpace`, `class AffinePlane`.
- `ProjectivePlane/Basic.lean`: non-degeneracy quadrangle (`nondeg`), the dual plane instance
  (`instance Dual : ProjectivePlane L P`), `join`/`meet` with `join_symm`, `meet_symm`,
  `meet_join`, `join_cancel`, and the existence lemmas (`exists_point_not_on_line` etc.).
- `ProjectivePlane/Counting.lean`: `order` as a `Cardinal`, `card_points_on_a_line`,
  `card_lines_through_a_point`, `card_points`, `card_lines` (the `n²+n+1` count), self-duality
  of the order. One `sorry` in this file.
- `ProjectivePlane/ExtraAxioms.lean`: `CentrallyPerspective`, `AxiallyPerspective`,
  `IsDesarguesian`, `IsPappian`, `IsLittleDesargian` — **definitions only**; no Desargues⇒
  coordinatization, no Hessenberg, no Pappian⇒field.
- `ProjectivePlane/AffineSubplane.lean`: 12 `sorry`s — unfinished.
- `AffinePlane/*`: order, direction/parallel-class counting, projective closure. No `sorry`s.

What it does **not** contain, and this is the decisive point for us: there is **no coordinate
model at all**. No `Projectivization`-based instance, no `PG(2,q)`, no field appears in the
projective-plane files. Consequently no conics, no arcs, no ovals, hyperovals, nuclei, and no
tangent/secant/passant classification. It is pure synthetic incidence axiomatics plus counting.

Verdict: **cite-as-prior-art-only**. Even if it were licensed, it sits on the wrong side of the
synthetic/analytic divide — our Paper I work is coordinate geometry over `GF(q)`, and the one
thing this repo would save us (the `n²+n+1` counting lemmas) we do not need in synthetic form.

### Other finite-geometry repositories

- https://github.com/CAPiedade/IncidenceGeometryLEAN — a single `IncidenceGeometryLEAN.lean`
  file, 27 KB repository total, no license. Effectively a stub.
- https://github.com/loewenheim/projective-plane — self-described "toy axiomatization",
  two Lean files, last push 2023-01-26, no license. Dead.

No repository anywhere in the GitHub search surface matches `hyperoval`, `Segre`, `arcs` over
finite fields, `nucleus`, or `complete arc` in Lean.

**Negative result (usable in the paper): there is no Lean formalization, in Mathlib or outside
it, of conics in `PG(2,q)`, of arcs/ovals/hyperovals, of the tangent/secant/passant trichotomy,
of the nucleus of a conic in even characteristic, or of complete arcs and exterior sets.**

---

## 2. Segre's lemma of tangents

No hit of any kind. GitHub repository search for `lean4 Segre` returns nothing; no arXiv Lean
formalization paper mentions it; no Zulip thread. Segre's 1954 theorem (every oval in `PG(2,q)`,
`q` odd, is a conic) and the lemma of tangents underlying it are **unformalized in Lean**.

**Negative result — build in-house.**

---

## 3. Bézout's theorem for plane curves

Nothing exists. Mathlib's algebraic-geometry tree has no `Bezout`, `IntersectionMultiplicity`,
or plane-curve intersection file; the only plane-curve machinery is the Weierstrass/elliptic
line (`Mathlib/AlgebraicGeometry/EllipticCurve/{Affine,Jacobian,Projective,DivisionPolynomial}`),
which proves the group law by explicit formulas rather than by a Bézout count. A GitHub PR
text search over `leanprover-community/mathlib4` for Bézout-plus-curve returns only the 2024
projective-coordinates elliptic-curve PR (#9416), which is unrelated.

Outside Mathlib: no Lean repository matches intersection multiplicity or Bézout for curves.
In other provers the situation is barely better — Bézout's *identity* (the gcd statement) is
everywhere, and Cohen's Coq algebraic-numbers development uses resultants, but a formalization
of the projective plane-curve intersection count with multiplicities does not appear in the
Coq or Isabelle/HOL literature either.

**Negative result — build in-house.** For our purposes the cheaper route is plainly to avoid
general Bézout entirely and prove the specific bounded-intersection facts we need (a line meets
a conic in at most 2 points; two distinct conics meet in at most 4) directly from resultants or
from `Polynomial.card_roots`, which our pinned Mathlib does support.

Verdict: no candidate. **cite-as-prior-art-only** is not even available — there is no prior art.

---

## 4. Association schemes, distance-regular graphs, Sylvester graph

- Mathlib has `Mathlib/Combinatorics/SimpleGraph/StronglyRegular.lean` (strongly regular graphs
  as a predicate with basic parameter lemmas) and nothing else in this direction. There is **no**
  association scheme, no Bose–Mesner algebra, no Terwilliger algebra, no intersection array, no
  distance-regular graph.
- GitHub repository search for Lean plus association scheme, Bose–Mesner, Terwilliger,
  distance-regular, or Sylvester graph returns nothing. A PR-text search over mathlib4 for
  "association scheme" returns zero results; "distance-regular" matches only unrelated PRs
  (a wikidata-attribute doc PR and an Archive entry on a "dual Langer graph", #39702).
- The one graph-adjacent Lean repository found, `jzuiddam/asymptotic-spectrum-distance`
  (formalizing the asymptotic spectrum distance and Shannon capacity), is about graph limits,
  not schemes.
- Named specific graphs: Lean has no Petersen graph, no Sylvester graph, no Hoffman–Singleton.
  Mathlib's `Archive` contains isolated named-graph work but nothing in this family.

**Negative result: association schemes, distance-regular graphs, intersection arrays, and any
identification of the Sylvester graph are entirely unformalized in Lean.** Building the
Sylvester-graph identification in-house is unavoidable, and the strongly-regular-graph file in
Mathlib is the only reusable foothold.

---

## 5. Brauer / modular character theory

Mathlib's `Mathlib/RepresentationTheory/` tree has `Character.lean` (ordinary characters of
finite-dimensional representations), `FDRep.lean`, `FinGroupCharZero.lean`, and homological
machinery. There is **no Brauer character, no p-regular class machinery, no block theory, no
decomposition matrix, no Brauer–Nesbitt**. (`Mathlib/Algebra/BrauerGroup/` is the Brauer group
of central simple algebras — a different Brauer, and a common false positive in searches.)

In-flight: PR #42377 (opened 2026-08-02) only adds Brauer's theorem on induced characters to
the `1000.yaml` "wanted theorems" list — that is a documentation entry recording that the
theorem is *not* formalized, not a formalization.

No non-Mathlib Lean repository formalizes modular representation theory.

**Negative result — build in-house, and note this is the single most expensive missing piece,
since even the ordinary-character prerequisites for a modular theory (orthogonality over a
splitting field in characteristic p) are absent.** Where Paper I can be restructured to use
ordinary characters plus a congruence, that is by far the cheaper path.

---

## 6. One-factorizations of complete graphs (uniqueness for K6)

Nothing in Lean. Mathlib has matchings and (recently) Tutte's theorem via Pim Otte's
educational formalization project (arXiv:2504.18146), and Hall's marriage theorem, but no
1-factorization, no edge-colouring decomposition of `K_n`, and certainly no enumeration or
uniqueness statement for `K6`. A search of the Lean ecosystem, and of the Isabelle AFP and Coq
literature, turns up no formalization of one-factorizations of complete graphs anywhere.

Nearest prior art in *any* prover: Chelsea Edmonds and Lawrence Paulson's Isabelle/HOL
`Design_Theory` and `Fishers_Inequality` AFP entries (arXiv:2105.13583, arXiv:2207.02728),
which formalize block designs, incidence matrices, and the rank/linear-bound arguments. That
is genuinely the closest existing formal treatment of the combinatorial-design world, but it
is Isabelle, so it is **cite-as-prior-art-only** and cannot be imported or ported cheaply.

**Negative result: one-factorizations of `K_n`, and the uniqueness of the one-factorization of
`K6` up to isomorphism, have no formalization in Lean.** Since our use is a fixed small case,
a `Decidable`-plus-`decide` enumeration over `K6` in-house is the realistic route.

---

## 9. Quadratic fields, `Z[φ]`, golden-ratio arithmetic

Mathlib suffices, as suspected. `Mathlib/NumberTheory/Zsqrtd/Basic.lean` gives `Zsqrtd d` —
the ring `Z[√d]` — with its `CommRing`, conjugation, norm, and (for the Gaussian case)
Euclidean structure; `Mathlib/NumberTheory/Real/GoldenRatio.lean` gives `goldenRatio`,
`goldenConj`, the defining quadratic, and the Fibonacci/Binet connection over `ℝ`.

Caveat worth recording: `goldenRatio` in Mathlib is a *real* number, so it does not specialize
to `GF(q)` directly. For finite specialization the right base is either `Zsqrtd 5` mapped into
`GF(q)` by sending `√5` to a chosen square root, or simply `Polynomial.X^2 - X - 1` and its
splitting behaviour, which is decided by whether `5` is a square mod `p`
(`ZMod.exists_sq_eq_iff` / quadratic reciprocity, all present). No third-party library is
needed and none would help.

Verdict: **no external dependency required.**

---

## 10. Ecosystem projects checked and found irrelevant

Recorded so the negative is auditable rather than assumed:

- **LeanCamCombi** (https://github.com/YaelDillies/cam-combi, Apache-2.0, active 2026-07):
  Cambridge combinatorics courses — extremal/probabilistic combinatorics, random graphs. Its
  file tree contains no design theory, incidence geometry, coding theory, association schemes,
  projectivization, or matroid material.
- **b-mehta/combinatorics**: Kruskal–Katona and finite-set combinatorics. Not relevant.
- **FLT (Fermat's Last Theorem)**, **PFR (polynomial Freiman–Ruzsa)**,
  **equational_theories**: no finite geometry, coding theory, or modular representation theory.
- **PhysLean/HepLean**, **cslib**, Duper and other automation projects: out of domain.
- **Ivan-Sergeyev/seymour** (regular matroid decomposition, Seymour's theorem): matroid-theoretic
  and genuinely substantial, but about regular matroids and totally unimodular matrices, not
  about arcs, MDS codes over `GF(q)`, or `PG(2,q)`. No usable overlap.
- **LeanGeo**, **Euclean**, **pgallardo/Euclidian_geometry_Lean**: Euclidean/olympiad geometry.
  Wrong subject.

---

## 11. Mathlib-side footholds our own build should lean on

Not third-party, but the survey turned these up and they change the in-house build estimate.
Confirm each against our pinned checkout before relying on it — several are recent additions on
master and may postdate our pin.

- `Mathlib/Combinatorics/Configuration.lean` — already contains
  `Configuration.ProjectivePlane` (as `HasPoints` + `HasLines` + nondegeneracy), the `Dual`
  construction, `lineCount`/`pointCount`, `HasLines.lineCount_eq_pointCount`, and the order-based
  cardinality results. This makes the whole of `PSchwahn/IncidenceGeometry` redundant for us:
  the synthetic layer we would want is already in Mathlib.
- `Mathlib/LinearAlgebra/Projectivization/` — `Basic`, `Collinear`, `Independence`, `Subspace`,
  `Cardinality`, `Constructions`, and a `PSL/PSL2` subdirectory. This is the right home for our
  `PG(2,q)` coordinate work: points as `Projectivization (GF q) (Fin 3 → GF q)`, with collinearity
  already defined and the point count already available.
- `Mathlib/Combinatorics/SimpleGraph/StronglyRegular.lean` — the only scheme-adjacent foothold.
- `Mathlib/InformationTheory/Hamming.lean` — Hamming distance/weight, the base for any
  coset-leader development we write.

---

## Bottom line

**Worth taking:** essentially nothing as a dependency. The only two permissively licensed,
technically real developments are ArkLib (Apache-2.0; Reed–Solomon codes as evaluation
submodules, Vandermonde generator matrix, MDS codes, Berlekamp–Welch, list decoding) and
florath/covering-codes-lean (BSD-3-Clause; q-ary covering numbers `K_q(n,r)` for unstructured
codes). Both are pinned to Lean toolchains newer than ours (v4.31.0 and v4.30.0-rc2), and
neither supplies the structured objects we actually need — generalized Reed–Solomon with column
multipliers, the arc/NRC dictionary, or coset leaders of a linear code. Taking ArkLib as a
dependency would import an entire SNARK framework to obtain a handful of short lemmas, which is
a bad trade against a release gate that requires a reproducible pinned build. Classify ArkLib as
**adapt-the-proofs** (copy the two or three RS lemmas under Apache-2.0 with attribution, if we
even want them) and covering-codes-lean as **cite-as-prior-art-only**.

**Definitively absent from Lean, anywhere:** conics/arcs/ovals/hyperovals/nuclei and the
tangent–secant–passant trichotomy in `PG(2,q)`; Segre's lemma of tangents; Bézout for plane
curves; complete arcs and exterior sets; association schemes, distance-regular graphs and
intersection arrays; the Sylvester graph; Brauer/modular character theory; one-factorizations
of complete graphs and the `K6` uniqueness; coset-leader theory for linear codes; and the
generalized Reed–Solomon ↔ normal rational curve ↔ arc dictionary. Every one of these is an
in-house build, which is exactly the formalization-novelty claim the paper wants to make — and
the claim is defensible in the strong form, since for most of these items no formalization
exists in Isabelle/HOL or Coq either. The one qualification the prose must carry: Edmonds and
Paulson's Isabelle/HOL `Design_Theory` and `Fishers_Inequality` AFP entries formalize block
designs and incidence-matrix rank arguments, so a blanket "no formal treatment of combinatorial
designs exists" would be wrong; the correct claim is that none of it is in Lean and none of it
covers the finite-geometry objects above.

**Recommended adoptions:** none as a `lakefile` dependency. Adopt instead the Mathlib-internal
footholds in section 11 — `Configuration.ProjectivePlane` for the synthetic layer and
`LinearAlgebra/Projectivization` for the coordinate layer — after confirming what our pinned
checkout actually contains.


## 7. Covering codes / coset-leader theory

### florath/covering-codes-lean

- Repository: https://github.com/florath/covering-codes-lean
- Paper: "Formal Foundations and Proof-Carrying Certificates for q-ary Covering Codes in
  Lean 4", arXiv:2606.09600 (CC-BY 4.0 for the paper).
- License: **BSD-3-Clause** (permissive — import or copy both legally fine).
- Toolchain: `leanprover/lean4:v4.30.0-rc2`. Last push 2026-07-20. 0 stars.
- Size: ~7.5 MB, dominated by a machine-generated bound table sharded into
  `CoveringCodes/Database/GeneratedTable/Chunk*.lean` (hundreds of chunk files).

What it proves: `CoveringCodes/Basic.lean`, `Balls.lean`, `Covers.lean`, `CoveringNumber.lean`
set up q-ary Hamming balls and the covering number `K_q(n,r)`; `Bounds/SphereCoveringBound.lean`
proves the sphere-covering lower bound; `Bounds/Balls.lean` the ball-volume formula;
`Constructions/Product.lean` and `Constructions/CoordinateDeletion.lean` give the product and
coordinate-deletion (relation) rules; `Database/*` is a proof-carrying table replaying stored
bounds from van Laarhoven et al. (1989) football-pool literature into Lean proofs.

What it does **not** give us: the whole development is about *unstructured* codes as sets in
`(Fin q)^n`. There is no linear-code structure, no syndrome map, no coset decomposition, and
therefore **no coset-leader theory and no covering radius of a specific linear code family**.
Ours is exactly the structured case.

Verdict: **cite-as-prior-art-only** for the covering-number framing; it does not reduce our
work. The generated-chunk architecture is, separately, a mildly interesting precedent for our
own finite-certificate sharding, but we already have that pattern.

**Negative result: coset-leader theory for linear codes over `GF(q)` — the weight distribution
of coset leaders, covering radius via syndromes — has no Lean formalization anywhere.**

---

## 8. Generalized Reed–Solomon / normal rational curve dictionary

### Verified-zkEVM/ArkLib — the substantive coding-theory development in Lean

- Repository: https://github.com/Verified-zkEVM/ArkLib
- License: **Apache-2.0** (permissive).
- Toolchain: `leanprover/lean4:v4.31.0`. Last push 2026-08-03 (actively developed), 321 stars,
  multi-institution (Verified zkEVM effort).

Coding-theory content, by file:

- `Data/CodingTheory/Basic/LinearCode.lean`, `Distance.lean`, `RelativeDistance.lean`,
  `BlockRelDistance.lean`, `DecodingRadius.lean` — linear codes, Hamming distance, minimum
  distance, decoding radii.
- `Basic/MDSCode.lean` — MDS codes.
- `ReedSolomon.lean` — `ReedSolomon.code (domain : ι ↪ F) (deg : ℕ) : Submodule F (ι → F)` as
  the image of `degreeLT` under evaluation; `genMatrix` proved Vandermonde
  (`genMatIsVandermonde`), `checkMatrix`, `encode`, monotonicity in the degree, and the
  membership characterization `mem_code_iff_exists_polynomial`.
- `BerlekampWelch/*` — Berlekamp–Welch decoding (note a dedicated `Sorries.lean`).
- `GuruswamiSudan/*`, `JohnsonBound/*`, `ListDecodability.lean`, `PolishchukSpielman/*`,
  `ProximityGap/*` (BCIKS20 and DG25 lines), `InterleavedCode.lean`.

Relevance to us: the RS code here is the *primitive* evaluation code, defined by an embedding
`ι ↪ F` of the evaluation domain. There are **no column multipliers**, so this is not
generalized Reed–Solomon; and there is **no geometric dictionary** — nothing identifies the
columns of the generator matrix with points of the normal rational curve, and no arc/MDS
correspondence is proved (`MDSCode.lean` states the MDS property, not its equivalence with an
arc in `PG(k-1,q)`).

Verdict: **adapt-the-proofs**, and even that only marginally. Apache-2.0 makes copying the RS
definitions and the Vandermonde generator lemma legal and easy, but they are short lemmas we
can restate; ArkLib is pinned to Lean v4.31.0 and carries a very large dependency surface
(the whole IOR/SNARK framework), so **import-as-dependency is not advisable** for a paper whose
release gate requires a reproducible pinned build.

**Negative result: the GRS ↔ normal rational curve ↔ arc dictionary is unformalized in Lean.
ArkLib has RS codes but no generalized RS and no geometry.**

---
