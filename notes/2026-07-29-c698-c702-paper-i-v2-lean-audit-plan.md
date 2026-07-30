# Paper I v2 Lean and literature audit

**Date:** 2026-07-29
**Lane:** `build-sys`
**Disposition:** five-task implementation stream, C698--C702

## Outcome

Paper I v2 has substantially outrun its current formal companion.  The
human-scale `finitegeom` gate still certifies the original chord-defect,
\(q=9\), and small-\(k\) statements, while the revised paper now adds:

- the balanced signed two-graph and golden operator;
- the cubic determinant identity, six-node reconstruction, and
  \(S_5/A_5\) symmetry distinction;
- the integral order \(\mathbf Z[\sqrt5]\);
- the \(q=13\) tangent code with parameters \([78,36,12]_2\), 364 minimum
  words, four minimum-word orbits, reconstruction, and automorphism group.

The right boundary remains the extracted one-way architecture:
human-scale reusable mathematics belongs in `finitegeom`; large finite
catalogues belong in field-specific downstream certificate repositories.
Do not put the \(q=13\) generated closure back into `finitegeom`.

The implementation should preserve the existing v1 trust gate and add a
new v2 gate.  C698--C702 split the work at the human/generated and
general/specialized boundaries.

## Repository inventory

| Surface | Audited identity | Present boundary |
|---|---|---|
| `~/src/lean/finitegeom` | `9711f4a1adf4fca40729d41442dce9e76c7db3a0` | clean, 239 Lean modules, Lean `v4.32.0-rc1`; 27-module Paper I human closure and 8 terminal `#print axioms` |
| `~/src/lean/finitegeom-clebsch-q11-certificates` | `f6912c4c020b8bf9e3e7bd67c486af9275634989` | clean, 118 Lean modules, 24 terminals; pins obsolete `finitegeom` commit `ef6317c5e1a348a91a1928104f9c8e1831bfb03d` |
| Paper I source | manuscript commit `bdd5568d` followed by trust-pin commit `473d453e` | C693 content is integrated, although its task card and live queue row still say queued |

The current human trust declaration is
`trust/areas/clebsch_rigidity_human.toml`, rendered in
`trust/CLEBSCH_RIGIDITY_HUMAN.md`, with aggregate gate
`RelativeConicArcs.Gates.ClebschRigidityHuman`.  It deliberately excludes
the generated \(q=11\) closure.  The downstream \(q=11\) gate is
`RelativeConicArcs.Gates.ClebschRigidityTrust`.

The stale downstream pin is a real integration hazard: a v2 aggregate must
not load two revisions of `finitegeom`.  C699 therefore updates the q11
package to the C698 revision before C702 composes q11 and q13.

## Formal coverage gap

| Paper claim | Existing reusable Lean | Missing proof/certificate |
|---|---|---|
| switching class and triangle signs | involutive odd-unit and eigenspace infrastructure | signed complete graph, switching, triangle holonomy, four-point reconstruction |
| \(B^2=5I\), determinant identity, unique pentagon class | elementary matrix/polynomial libraries | explicit `Fin 6` calculation and abstract equivalences |
| six ordinary nodes and projective frame | general polynomial algebra only | exhaustive singular-locus proof, Hessian ranks, frame recovery |
| full \(S_5\), oriented \(A_5\) | finite permutations and existing concrete actions | stabilizer bridge from cubic zero-locus to polynomial line; oriented subgroup |
| integral commutant \(\mathbf Z[\sqrt5]\) | integer matrices | explicit signed \(A_5\) action and integral centralizer computation |
| q11 syndrome locus reconstructs the orientation | existing q11 support/deep-hole catalogues | bridge from the actual two support orbits and continuation orbitals to the abstract \(B\) |
| q13 dimension \(36\) | generic code/rank APIs | concrete incidence matrix and exact rank certificate |
| q13 distance \(12\) | no Segre lemma | formal Lemma of Tangents, clique classification, weight-10 exclusion, weight-12 witness |
| 364 minimum words and four orbits | no q13 data in main | generated catalogues, membership/completeness, orbit and rank certificates |
| q13 reconstruction and automorphisms | generic incidence/group APIs | concurrence scheme, recovery of 78 rows, group generation and completeness |

Pinned Mathlib contains no declarations named `TwoGraph`, `ConferenceMatrix`,
or `Seidel`, and no ready-made Gröbner-basis or singular-locus framework.
This is a bounded local API screen, not a claim that no formalization exists
elsewhere.

## Literature audit

**Coverage outcome:** 0 sources read in full; 5 sources read partially.
This is a targeted attribution and formal-dependency audit, not a global
novelty or priority audit.  MathSciNet, zbMATH, and a systematic
forward-citation search were not covered, and no “first formalization”
claim is licensed.

Cached source records use the project literature cache:

1. Simeon Ball and Michel Lavrauw, *Arcs in finite projective spaces*,
   arXiv:1908.10772v2, DOI `10.4171/EMSS/33`, cache SHA-256
   `00d13c01fa869889c9ab9e4e76928235c5e7b441a815059fd0f3f177365e76a4`.
   **Partial:** §7 and the proof of Lemma 27.  This is the exact
   coordinate-free Lemma of Tangents needed to turn a hypothetical
   weight-eight q13 word into the holonomy obstruction.  It should be
   cited in the C700 module docstring and theorem provenance.
2. Brent Madison and Qing Xiang Wu, *On Binary Codes from Conics in
   PG(2,q)*, arXiv:1104.0324v1, DOI
   `10.1016/j.ejc.2011.08.001`, cache SHA-256
   `f3edf20a2b63286164b3aced06a04a9039d7bbba2eb955a6461b7f7e793f6343`.
   **Partial:** introduction and Corollary 6.3.  It gives the general
   nullspace dimension \((q-1)^2/4\), hence 36 for \(q=13\), but not the
   distance or minimum layer.
3. H. D. L. Hollmann and Qing Xiang, *Association schemes from the action
   of PGL(2,q) fixing a nonsingular conic in PG(2,q)*,
   arXiv:math/0503573, cache SHA-256
   `c7da1c736b1d229228f74cbcc22a77dd848a512e206c1cb88462fc3fd513ab4b`.
   **Partial:** introduction and scheme setup.  This supplies the
   classical elliptic association-scheme carrier, not the paper's
   minimum-layer reconstruction theorem.
4. David Duncan, Peter M. Hoffman, and Jason P. Solazzo, *Numerical
   Measures for Two-Graphs*, arXiv:0810.3189, cache SHA-256
   `47b184d9e56da34cb24b7289b5a4ad54b4f922164e8831a367e1f79354f5f01e`.
   **Partial:** §2.  It records the standard Seidel-matrix/switching-class
   dictionary.  The paper's balanced six-vertex identity and cubic
   reconstruction remain project-specific elementary results.
5. Ivan Cheltsov, Yuri Tschinkel, and Zhijia Zhang, *Equivariant geometry
   of singular cubic threefolds*, arXiv:2401.10974v2, DOI
   `10.1017/fms.2024.148`, cache SHA-256
   `5fb44374d4a2c1790c6246a522e12df32afc7c9a81c9ca8bcd1ade62215df089`.
   **Partial:** §7, especially equations (7.4), (7.5), and Proposition
   7.3.  Their equation (7.5), restricted by \(x_0=0\), is exactly the
   Paper I cubic after swapping the third and fifth of the five remaining
   coordinates (1-based \(y_3\leftrightarrow y_5\)); no signs or scalar
   change are needed.  The source identifies this as the \(S_5\)-symmetric
   six-nodal cubic in general linear position and relates its hyperplane
   section to the Clebsch diagonal cubic surface.

The fifth item is the actionable attribution finding.  The current Paper I
bibliography does not cite Cheltsov--Tschinkel--Zhang.  The `clebsch` lane
should add the citation and state the coordinate equivalence; it should not
present the six-nodal model itself as new.  The orientation/two-graph
reconstruction may still be the paper's contribution, but this audit does
not issue a novelty verdict on it.

A bounded web and GitHub screen for Lean declarations matching TwoGraph,
conference/Seidel matrices, and Segre's Lemma returned no candidate beyond
the pinned local Mathlib search.  Because the screen was not systematic, it
is recorded only as implementation reconnaissance.

## Package architecture

```text
finitegeom @ C698/C700
  ├── human gate: signed two-graph, cubic, nodes, symmetry, integral order
  ├── general gate: Segre lemma and q13 definitions/reductions
  └── finitegeom-clebsch-q11-certificates @ C699
         └── q11 orientation/reconstruction bridge

finitegeom-clebsch-q13-certificates @ C701
  ├── pins the same finitegeom revision
  ├── depends on the updated q11 package only for the final v2 aggregate
  └── owns q13 generated catalogues and certificate checkers
         └── v2 aggregate/release gate @ C702
```

Putting the v2 aggregate in the q13 package avoids a third umbrella
repository while retaining one-way dependencies.  The aggregate must have
a new name, proposed
`RelativeConicArcs.Gates.ClebschRigidityV2Trust`; the v1 gate remains
unchanged and buildable.

## Work plan

### C698 — human signed-two-graph and cubic core

Add a reusable `FiniteGeom.SignedTwoGraph` API for Seidel matrices,
switching, triangle holonomy, four-point reconstruction, and pair balance.
Add `RelativeConicArcs.ClebschOrientationTwoGraph` for the explicit
six-vertex matrix, \(B^2=5I\), determinant identity, unique pentagon class,
nodes, frame, stabilizers, and integral commutant.  Give each headline
result its own terminal before the aggregate gate.

Do not silently identify a computed polynomial-line stabilizer with the
full projective automorphism group.  The latter is accepted only after the
singular-locus completeness and frame bridge are formal.  Similarly,
\(\mathbf Z[\sqrt5]\) requires an integral centralizer theorem, not merely
the rational relation \(B^2=5I\).

### C699 — q11 orientation bridge

Update the q11 package to the C698 `finitegeom` commit and connect its
actual support/deep-hole data to the abstract orientation object.  Formalize
\((A-A')^2=10(I-R)\), the odd restriction \(B^2=5I\), agreement of triangle
signs with the two support orbits, and reconstruction from the syndrome
locus.  Regenerate manifests and rerun its exact axiom and clean-checkout
gates.

### C700 — Segre lemma and q13 reduction

Formalize the planar specialization of Ball--Lavrauw Lemma 27, preferably
from a reusable coordinate-free statement.  Define the q13 conic,
internal/passant incidence code, tangent graph, and checker semantics.
Prove that a weight-eight word would yield the forbidden holonomy clique,
and expose narrow certificate predicates for the q13 finite leaves.

### C701 — q13 certificate package

Create `~/src/lean/finitegeom-clebsch-q13-certificates` as a fresh-history,
one-way-dependent package.  Shard generated data by mathematical family and
module boundary: incidence/rank; tangent cliques; the two weight-ten
profiles; weight-twelve witness; minimum-word catalogue and four orbits;
concurrence scheme/reconstruction; and automorphism group.

The current Python replay's raw profile counts
\(6{,}531{,}840\) and \(166{,}561{,}920\) are not acceptable Lean
enumeration plans.  Use proved meet-in-the-middle checker reductions and
small independently checkable shards.  Kernel-checked certificate
predicates are preferred; any native-evaluation trust enlargement must be
declared and separately audited.

### C702 — aggregate trust and paper release surface

Compose the human, q11, and q13 terminals in the new v2 gate.  Freeze exact
source and dependency commits, manifests, theorem maps, generated-data
provenance, terminal axiom sets, and a clean-checkout replay.  Update the
standalone Paper I formal pin and claim map only after all gates pass.
Hand the literature attribution change to `clebsch`; do not edit the
manuscript from this lane without explicit routing.

## Execution order and gates

Recommended order is C698, C699, C700, C701, C702.  C700 is mathematically
independent of C698 and may be developed before C699 if that shortens the
critical path, but all packages must converge on one immutable
`finitegeom` revision before C701 validation.

Every task must:

- use the pinned toolchain and the build-owner lock for real Lean work;
- keep generated data outside the main repository;
- state the exact consuming checker for every data shard;
- run terminal `#print axioms` audits, not only aggregate builds;
- prove clean-checkout replay from exact dependency commits;
- preserve the v1 gate and distinguish human proof, generated certificate,
  and executable replay in prose.

This was a read-only source, repository, and literature audit.  No Lean or
Lake build was started.
