# C538 second-draft referee-fix implementation

Date: 2026-07-23

## Decision

The external full-draft review is accepted.  The fifteen-page integrated
artifact had a strong theorem spine and honest computational boundaries, but
was an extended research announcement rather than a refereeable,
proof-complete paper.  C545 may not publish that artifact under a
proof-complete label.

The unified-paper architecture remains unchanged under
`papers/papers-planning.md`: redundancy five is the headline, coherent polar
contraction organizes redundancies six through nine, and the
ordered-Hessian/Lucas material is the modular contained-component layer.  A
two-paper split would require a separate strategy decision.

## Paragraph-by-paragraph reads

Two independent reads were used.

The proof read identified the hidden contained-case premise in the original
Theorem 4.1, the mixed point-bound convention, the need for public orbit
identifiers, and the missing proposition-level expansions at R5--R9,
ordered Hessian, and `e_7`.  It recommended an intrinsic polar construction,
a separately named degree-specific contained-component assertion, and a
conditional transverse theorem.

A follow-up adversarial read closed the first of those component assertions.
For a rank-three upper catalecticant, lower rank drop forces the entire upper
kernel into the factor hyperplane; containment for every geometric factor
would put that kernel in the zero intersection of all factor hyperplanes.
This characteristic-free rank--nullity proof closes `CC(6,1)` and the
ordinary persistent rank-two carrier in every later degree.
The next contained-component pass closes `CC(7,1)` as well: the binary
central lift is empty, an identically colliding five-dimensional
$g^4_6$ is impossible, and the characteristic-three/five nucleus lifts
are shallow.  The remaining R8 hypothesis is now the explicitly named
pointed lower package `LP(6,1)`, whose recursive equations and monodromy
checks are not supplied by the C513 certificate.

The editorial/reproducibility read confirmed that the source already used
`q>=43` consistently, isolated the real `kappa` inconsistency, recommended a
shorter abstract, notation/terminology, stable public certificate names, a
breakable verification table, immutable release metadata, and a role-based
bibliography audit.

A further read of the Clebsch and complete-repair trust ledgers supplied the
status vocabulary and separation among mathematical proof, finite
certificate, imported theorem, and kernel-checked implication.  A read of
`papers/papers-planning.md` added the mandatory statement-adequacy appendix,
titled provenance section, exact release checklist, and dormant DOI gate.

## Implemented corrections

1. Added `papers/beyond4_prs/second-draft-fix-plan.md`, with correctness,
   proof, classification, reproducibility, exposition, literature, and
   release gates plus acceptance tests.
2. Refactored the polar section into:
   - formal ambient, marker, and lower-package definitions;
   - an intrinsic polar-flag construction theorem;
   - a named level-specific contained-component assertion `CC(n,j)`;
   - a conditional effective transverse-induction theorem.
3. Replaced the mixed point-count formula by
   `q+kappa-2g*sqrt(q)>delta` and added a threshold table.  It records:
   - R5: `(1,12,0)`, first prime power 23;
   - R6: `(1,18,1)`, first prime power 29;
   - R7: `(1,24,1)`, first prime power 37;
   - R8: `(1,30,1)`, first prime power 43;
   - R9: `(1,36,1)`, first prime power 53.
4. Added a complete finite-field closure ledger for R5--R7 and retained the
   separate R7 covering-radius gate.
5. Shortened the abstract; added notation, terminology, upright theorem
   bodies, and ordinary mathematical prior-work comparison.
6. Added four functional diagrams:
   - a proof-level guided tour from syndrome to lifted witness;
   - the formal contraction, contained/transverse branching, deletion, and
     lifting mechanism;
   - ordered-Hessian degeneracy and root-compatible carrier selection;
   - claim-level proof/import/certificate/Lean trust routes.
7. Replaced the floating filename inventory by a compact breakable public
   verification table.
8. Added stable public certificate labels and:
   - `supplement/CERTIFICATE-SCHEMA.md`;
   - `supplement/REPRODUCING.md`;
   - `supplement/RELEASE-MANIFEST.md`.
9. Rebuilt `claim-proof-novelty-ledger.md` using the established repository
   trust vocabulary and added `adversarial-proof-evidence-audit.md`.
10. Added a titled provenance/responsibility section and a verbatim
    statement-adequacy appendix for the adopted C517 Lean synthesis
    interface and headline theorem.
11. Repaired the warning gate so `make check` works after `make clean`.
12. Gated C545 consistently in the live queue, task card, handoff, and paper
    README.  It remains the release route, but cannot publish the current
    announcement as proof-complete.
13. Recorded that the development monorepo is never published.  The eventual
    artifact is a reviewed paper-only fresh-history export containing the
    manuscript, public supplement, minimal verifiers/certificates, and a pin
    to one shared-public-Lean commit and exact target list.
14. Began the source split: `main.tex` is becoming a thin driver, with the
    guided overview and Hankel dictionary already isolated under `sections/`.
    Remaining major sections and appendices are split as their proof
    expansions stabilize.

## Diagrams considered

The four included diagrams were selected because each exposes a relationship
that prose or a short list obscures.  An orbit-count graphic was rejected
because it would repeat tables without identifying orbits.  A field-threshold
timeline was rejected because the normalized threshold and field-range tables
are clearer.  A full theorem-dependency graph remains useful only after the
expanded proof propositions exist; adding it now would disguise open proof
gates as completed dependencies.

## Exact formal boundary

The appendix prints the `ResidualSliceInput`, `PersistentFamilyData`, and
`redundancyNineSynthesis` interfaces used by C517.  The guarded audit reports
only `propext`, `Classical.choice`, and `Quot.sound` at the headline terminal.
Geometric integrality, rational-point existence after deletions, family
identification, exhaustion, and the genuine `PGL2/PGammaL2` action remain
explicit inputs.

## Remaining proof-critical work

The proof extraction initially exposed three gaps beyond the referee's
presentation critique.  The first is now closed:

- the R7/R8 kernel--hyperplane sentence was incomplete as written; the
  missing nullity calculation now proves the ordinary rank-two
  contained-line classification and closes R7;
- R9 does not yet print the six-slice Bézout data or the nonzero
  rational-base polynomial and degree calculation;
- the Hessian argument bounds individual degeneracy generators but does not
  exhibit one polynomial of the same degree containing the whole bad union.

The manuscript retains conditional language only for the later marker,
slice, and Hessian gates not discharged by the rank-two proposition.

The revision does not manufacture the missing mathematics.  Before a
proof-complete release:

- R5 needs expanded normal-form, stabilizer, degeneration, and cubic-cover
  proofs.
- R6--R9 need a named proof for every degree, ramification, collision,
  containment, genus, and deletion number.
- the ordered-Hessian outline must become a full component/pullback proof;
- the `e_7` theorem must be split into ordered-root normalization, additive
  cover, and direct shallow-orbit proofs;
- public classification records must expose the canonical representatives
  and exhaustion data;
- the literature audit and immutable release manifest must close;
- a cold mathematical reread must turn every `OPEN-MATH` and `REVIEW-GATE`
  row green.

## Validation

The revised source builds as a twenty-nine-page, 230,866-byte PDF with the
local warning-gated Makefile.  The rendered
PDF was inspected at the polar-flow, ordered-Hessian, trust-map,
verification-table, provenance, boundary, and statement-adequacy pages.
Final staged checks and commit are recorded at closeout.
