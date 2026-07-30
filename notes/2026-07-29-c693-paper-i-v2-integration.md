# C693 — Paper I v2 integration

**Lane:** `clebsch`

**Date:** 2026-07-29

## Verdict

Paper I v2 integrates the complete C611/C690/C691 package without a
statement, proof, executable, certificate, or trust-manifest dependency on
Paper III.

The human paper now reconstructs the unordered support-orientation torsor,
its cubic line, and the fibre-odd continuation operator \(B\) with
\(B^2=5I\).  The intrinsic identity
\[
 c_{ijk}=B_{ij}B_{jk}B_{ki}
\]
makes them mutually recoverable presentations of one signed two-graph.
The homogenized diagonal determinant isolates the cubic as the
golden-conjugation odd term, signed pair balance is equivalent to
\(B^2=5I\), and a pentagon classifies the unique balanced switching class.
The cubic threefold on the augmentation space has exactly six ordinary
nodes forming a projective frame, so it recovers the unlabelled axis carrier
and has full projective automorphism group \(S_5\), with oriented subgroup
\(A_5\).  The integral commutant is the conductor-two order
\(\mathbf Z[\sqrt5]\); no wider conductor table is imported.

The computational companion now proves that the binary
passant/internal-point incidence code over \(\mathbf F_{13}\) has parameters
\([78,36,12]_2\).  Its \(364\) minimum words form four
\(\operatorname{PGL}(2,13)\)-orbits, each spanning the code; their pair and
triple concurrence reconstruct the six elliptic orbitals and all \(78\)
passant rows.  Segre tangent triples replace the conic-filling
eight-point exclusion at \(q=13\) by a six-difference-set, five-row
unique-closure argument.  The stronger maximum-six statement remains
separately owned by the pre-existing orbit search.

## Frozen v1 baseline

The approved v1 baseline was recorded before editing:

- monorepo commit:
  `ba31fb6b13b592728a5b0a135ae9bac68231fa4f`;
- human TeX blob:
  `6609851f0d76d60c89ccafab65b41c4ef016bc79`;
- companion TeX blob:
  `dff0649e8c599d8a4c5b7cd43c3f11faf57f1dea`;
- standalone mirror commit:
  `5c7e535967888b1423670ef6bb8c54c1260b2701`.

The v2 commits are ordinary forward commits.  They do not rewrite, replace,
or delay the approved v1 release surface.

The authoritative integration is the forward series
`bdd5568d`, `473d453e`, `1b2c5b9a`, `fc2d7943`, and `dd3659e0`.
The synchronized standalone release is commit `90ef98d`.

## Manuscript and replay surface

The title is now *Reconstructing the Clebsch code and its golden orientation
from its deep-hole syndrome locus*.  The abstract, introduction, headline
ordering, conclusion, metadata, theorem map, and public verification
documentation agree with the new scope.

Two paper-owned standard-library replays were added:

- `papers/clebsch-rigidity/check_orientation_two_graph.py` constructs
  \(A_5/C_5\) and \(A_5/D_5\) from scratch and checks the orbital operator,
  triangle products, inverse gauge, determinant pencil, moment balance,
  twelve balanced gauges, chartwise gradient Gröbner bases, Hessian ranks,
  projective frame, automorphism groups, and mod-two degeneration;
- `papers/clebsch-rigidity/check_q13_tangent_code.py` independently checks
  the cyclic tangent certificate, both weight-ten profiles, exact distance
  twelve, all four minimum-word orbits, incidence reconstruction, and the
  exact \(\operatorname{PGL}(2,13)\) automorphism group.

The statement identity remains nineteen rows by grouping the orientation
upgrade with the support-bipartition row and the tangent-code theorem with
the small-arc row.  The release manifest admits eighteen checks and the
checker-output certificate contains thirteen exact replays.

## Paper III boundary

A scoped source audit found no occurrence of `C682`, `Mukai`, `dodecic`,
`clebsch-covers`, `Paper III`, or `E_8` in the Paper I TeX, Python, Markdown,
or JSON surface.  The orientation replay constructs its groups and
polynomials internally and reads no upstream Clebsch certificate.

The manuscript uses only:

- the reconstructed \(A_5/C_5\) syndrome locus;
- its intrinsic \(A_5/D_5\) antipodal quotient;
- the two support orbits already reconstructed by Paper I; and
- elementary signed-graph, determinant, and exact elimination arguments.

It does not mention the Mukai--Umemura geometry, the dodecic operator,
Schläfli geometry, the primes \(11,23\) conductor comparison, or an ambient
degree-three/degree-six covariant.

## Source record

One new cited input is used: Segre's coordinate-free lemma of tangents.

- S. Ball and M. Lavrauw, *Arcs in finite projective spaces*, 2019,
  arXiv:1908.10772.
- Read depth: **partial**, cached full-text preprint, Section 7,
  Lemmas 27--29 and their proofs.
- Cache key: `arXiv:1908.10772`.
- Cached PDF SHA-256:
  `00d13c01fa869889c9ab9e4e76928235c5e7b441a815059fd0f3f177365e76a4`.
- Exact use: Lemma 27 supplies the three-point tangent-product identity
  with sign \((-1)^{t+1}=1\) for the saturated eight-arc reduction.

No new priority wording was added.  The existing v1 positioning paragraph
was not extended to claim novelty for the orientation or tangent-code
theorems, so no absence-of-prior-work verdict is part of this deliverable.

## Validation and cold read

Both PDFs build without LaTeX warnings.  The human paper is eighteen pages
and the companion is nine pages.  A PDF cold read inspected the title and
abstract, the complete orientation theorem and proof, the tangent-code
theorem and cyclic tables, the exact-distance continuation, and the
transition back to the frozen field-window spine.  The theorem hierarchy,
tables, displayed matrices, page breaks, and cross-references are legible.

The authoritative and standalone release surfaces pass the full clean
Paper I gate against the frozen Lean checkout at
`6d4766d1ea5e9a36f1a507e549c223416a6b506f`.  That gate rebuilds the
manuscript in isolation, checks the nineteen-row statement identity and
trust manifest, runs all thirteen exact replays, and elaborates the pinned
Lean aggregate gate.

## Extra-juice and Tao closeout

The repeated C691 closeout upgrades were all cheap at integration time and
were admitted:

1. the diagonal determinant identifies the cubic as the sole nonsymmetric
   coefficient;
2. homogenization identifies it as the conjugation-odd coefficient;
3. \(B^2=5I\) forces every lower signed moment and the augmentation-space
   descent;
4. pair balance conversely recovers \(B^2=5I\);
5. the pentagon gauge proves uniqueness of the balanced switching class;
6. the six ordinary nodes recover the projective axis frame and promote
   the order-\(120\) coordinate normalizer to the full projective
   automorphism group.

The resulting theorem is stronger and shorter conceptually than presenting
the cubic and continuation algebra as adjacent reconstructions.  The
q=13 tangent proof likewise replaces the finite eight-support search by a
reader-checkable local closure table while leaving the stronger exhaustive
claim honestly separated.

## Mystery ledger

- **Why the support cubic and golden operator carry the same sign:**
  settled by triangle holonomy and inverse switching reconstruction.
- **Why lower signed moments vanish:** settled structurally by the
  off-diagonal entries of \(B^2=5I\).
- **Whether the cubic needs the six axis labels as input:** settled; its
  six ordinary nodes form the intrinsic projective frame.
- **Why the outer order-\(120\) group is the full projective group:** settled;
  every projective automorphism permutes the complete node frame.
- **Prime \(2\) within Paper I:** settled at the permitted level by the
  conductor-two order and the rank-one square-zero reduction of \(B-I\).
- **Uniform all-\(q\) tangent exclusion and the wider \(2,11,23\) conductor
  comparison:** not Paper I integration gaps.  The former remains outside
  the finite \(q=13\) theorem; the latter remains reserved for Paper III.

No genuine mystery remains inside C693's admitted Paper I v2 package.

## Disposition

Paper I v2 is integrated, replayed, cold-read, and synchronized.  Paper I
v1 remains an approved frozen baseline and is not held by this work.
C693 is complete.
