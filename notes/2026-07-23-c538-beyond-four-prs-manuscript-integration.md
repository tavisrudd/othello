# C538 — beyond-four PRS manuscript integration

**Lane:** `reed-solomon` · **Date:** 2026-07-23 · **Status:** complete

## Result

The integrated manuscript
`papers/beyond4_prs/main.tex` and its cleanly compiled fifteen-page PDF now exist. The package also
contains:

- `refs.bib`;
- `theorem-map.md`;
- `claim-proof-novelty-ledger.md`;
- `verification-map.md`;
- a local warning-gated `Makefile`; and
- a refreshed `README.md`.

The paper’s headline is the complete all-field redundancy-five classification. The red-team review
refined the title to *Projective Reed–Solomon syndromes beyond redundancy four: deep holes,
coherent polar flags, and modular carriers*. The main theorem spine labels redundancy six as a
complete all-field deep-hole classification, redundancy seven as a complete all-field split-free
syndrome classification and a `q >= 11` deep-hole classification, redundancy eight and nine as
high-field classifications at `q >= 43` and `q >= 53`, C512 as a conditional
effective induction theorem, C525 as a characteristic-two containment theorem, and C529/C530 as
arithmetic component theorems. No clause depends on C531/C532 or implies a completed
redundancy-ten classification.

## Adopted proof spine

1. The characteristic-free syndrome/Hankel dictionary turns deepness into absence of a split
   squarefree member.
2. Redundancy five becomes exceptional arithmetic for cubic pencils: gcd strata, cyclic covers,
   characteristic-three nucleus/wild strata, and the genus-one `S3` fiber square.
3. Marked contraction roots produce coherent polar flags; the contained-or-transverse theorem
   explains the persistent, modular, and arithmetically bounded trichotomy.
4. Redundancies six/seven instantiate the all-field mechanism, while redundancies eight/nine add
   exact marker-deletion and contained-nucleus calculations.
5. The characteristic-two ordered-Hessian `(2,2)` curve replaces the doubled discriminant and
   yields the arbitrary-degree persistent/Lucas containment theorem.
6. Lucas arithmetic identifies the power-of-two endpoint cover, and the degree-nine `e_7`
   normalization shows that its `F8`-linear order-three cover is a proper section of a larger
   `AGL_3(F2)` additive cover.

The exact adoption and exclusion tables are in `papers/beyond4_prs/theorem-map.md`.

## Literature and novelty boundary

The bibliography and introduction position the manuscript against Zhang–Wan–Kaipa, Kaipa,
Seroussi–Roth, Kaipa–Patanker–Pradhan, Cesaratto–Matera–Pérez, Aubry–Perret,
Gmainer–Havlicek, and Wang. The integrated priority sentence remains qualified “to our
knowledge” because the predecessor audits did not cover MathSciNet. The paper does not claim
novelty for the scalar covering radius, the tangent/sigma families, binary-quartic invariant
theory, generic factorization statistics, Hasse–Weil, NRC nuclei, or the general
Frobenius/monodromy dictionary.

## Verification and trust boundary

`make check` in `papers/beyond4_prs/` passes under XeLaTeX with no undefined references,
undefined citations, package warnings, or overfull/underfull boxes. The resulting PDF is fifteen
pages and was cold-read in rendered form.

The paper-facing verification map names every generator, compact certificate, independent replay
or explicit absence of one, checksum manifest, finite domain, and trusted boundary. All
load-bearing generator/certificate/replay hashes pass. Two predecessor manifests, C491 and C498,
also hash their living theorem reports; later closeout expansions made only those report entries
stale. C538 records the discrepancy and does not silently mutate predecessor evidence bundles.
Every other adopted manifest passes as written.

C517’s Lean boundary is stated exactly: the residual algebra and synthesis implication are
kernel-checked, while geometric integrality, Hasse–Weil existence, PRS-family identification, and
exhaustion remain visible hypotheses. The axiom audit uses no project-specific axioms or opaque
computational oracle.

## Cold structural review

The first cold pass checked the rendered title page, abstract, theorem hierarchy, verification
table, and open-boundary section. The abstract separates all-field from high-field results and
calls C525 a containment theorem. The final section repeats the six exact nonclaims, so a reader
cannot reasonably infer redundancy-ten closure or arbitrary-degree classification.

Three independent paragraph-by-paragraph reviews covered claim strength/editorial structure,
mathematical consistency, and reproducibility, followed by a dedicated red team of the title,
abstract, and theorem spine. They produced the following material corrections:

- the title now says “syndromes” and “modular carriers,” avoiding an arbitrary-redundancy
  classification implication;
- split-free syndromes are defined before deep holes, and every deep-hole statement now displays
  its radius premise;
- the C509 `q=7,8,9` tables are no longer called code deep holes: they are exact split-free
  syndrome tables, while Seroussi–Roth makes the `q>=11` range a genuine deep-hole theorem;
- C516’s `q=7` characteristic-seven result is labeled a formal carrier calibration because
  `PRS(q-8)` is inadmissible there;
- C512’s scheme-theoretic contained-carrier hypothesis, C529’s `s>=2` and `BC!=0` hypotheses,
  C530’s `A1!=0` and collision-open hypotheses, and the ordered-Hessian ambient parameter spaces
  are now explicit;
- repeated finite orbit sizes are identified by canonical certificate representatives,
  stabilizers, histograms, and Frobenius links rather than by size alone; and
- the verification table now uses literal paths and checksum names, while the companion map gives
  exact searched domains, stop conditions, replay commands, working directories, and predecessor
  packaging defects.

## Extra-juice and Tao closeout

The closeout made three free upgrades.

1. It promoted the theorem-strength distinctions from prose cautions to a frozen theorem-adoption
   table and repeated them in the abstract, main theorem, and exact-boundary section.
2. It turned the scattered predecessor artifact lists into one paper-facing verification map with
   trusted-boundary clauses rather than implying that every computation has two exhaustive
   implementations.
3. It exposed the C491/C498 report-only checksum drift during an actual manifest audit. The
   load-bearing artifacts remain intact; the manuscript now says exactly what passes and what is
   stale.

The Tao-style stress question was whether the manuscript has one conceptual reason, rather than a
sequence of fixed-level classifications. It does: parameterized polar coherence decides which
lower bad fibers propagate, the ordered Hessian repairs the characteristic-two discriminant, and
normalized root-cover Frobenius decides arithmetic deepness on the retained modular pieces. The
`q=19` pointed-bad but noncoherent fiber and C530’s proper-section correction are the two sharp
falsifiers that keep this architecture honest.

## Mystery ledger

Settled:

- **Why does the same count `q(q+1)^2/2` persist?** It is the uniform tangent plus
  conjugate-secant rank-two carrier; only its torus quotient and tangent cocycle change with
  redundancy.
- **Could C529’s order-three component law be advertised as a new deepness law?** No. C530 proves
  it belongs to a proper `F8`-linear section, while additive subspace polynomials make the full
  `e_7` orbit shallow in every admissible field.
- **Does the characteristic-two discriminant support the generic proof?** No. Its doubled-quadric
  degeneration is replaced by the ordered-Hessian `(2,2)` curve, and the manuscript labels the
  resulting theorem as containment.
- **Did manifest validation find a paper-facing evidence failure?** No computational artifact
  failed. The only drift is the two predecessor report hashes described above.

Open, with exact owner:

- **Proof-complete public Version 1 and DOI:** C545 owns release preparation, venue-policy
  verification, immutable release manifest, and the public timestamp.
- **Redundancy-seven small-field code radius:** C509’s certificate classifies split-free syndrome
  directions at `q=7,8,9`, but does not supply the separate radius premise needed to call them code
  deep holes; C545 must preserve this distinction unless a separately reproducible proof is added.
- **Paper-facing Lean closure:** C539–C544 own the shared foundation, fixed-level terminals,
  characteristic-two package, and aggregate reconciliation.
- **Remaining degree-nine Lucas strata and redundancy ten:** C531/C532; neither is a gate for this
  manuscript freeze.

No other genuine C538 mystery remains.

## Acceptance

- Compilable source and PDF: pass.
- Exact theorem-strength labels: pass.
- Generator/replay/certificate/checksum map: pass, with the two report-only stale hashes disclosed.
- Cited/external and Lean hypotheses exposed: pass.
- C500 absent from the live queue: pass.
