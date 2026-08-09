# C894 — unnumbered saturated-exterior and local-Paley companion

**Lane:** clebsch · **Status:** active architecture freeze · **Allocated:** 2026-08-08

## Objective

Scope, referee-harden, and build an unnumbered specialist companion around two
proved all-field results from C756:

1. the qualified candidate-novel local theorem
   \[
   \operatorname{Aut}(P(q)[S])
   =S\rtimes\operatorname{Gal}(\mathbb F_q/\mathbb F_p),
   \qquad q=p^n\equiv3\pmod4,
   \]
   equivalently the unique extension of every Paley out-neighbourhood
   automorphism to a full semilinear Paley automorphism fixing the base
   vertex; and
2. the geometric headline that an exterior set of a nonsingular conic
   consisting of \((q+1)/2\) exterior points and forming an arc exists only
   for \(q=3,7,11\), with one conic-stabilizer orbit per field, while covering
   selects the \(q=11\) Clebsch hexagon.

This is an unnumbered companion to the four-paper Clebsch series, not Paper V.

## Frozen claim hierarchy

- **Candidate novelty, qualified:** exact local-Paley automorphism group and
  unique local-to-global extension.  Use “to our knowledge” until the human
  MathSciNet/Scopus check is recorded.
- **Geometric headline:** complete saturated-exterior/extremal exterior-arc
  classification and the Clebsch covering corollary.
- **Corollaries, not separate novelty:** normal cyclic Cayley structure,
  automorphism-group order \(n(q-1)/2\), prime-field DRR, and primitive-block
  coordinate recovery up to translation and Frobenius.
- **Named arithmetic engine, separately qualified:** the faithful local-Paley
  eigenvalue collision class is exactly its Frobenius orbit and contains no
  imprimitive competitor.  Add this exact Jacobi-spectrum statement to the
  human predecessor query before making any independent novelty claim.
- **Free arithmetic corollary:** a faithful eigenvalue generates the
  decomposition field
  \(\mathbb Q(\zeta_{(q-1)/2})^{\langle p\rangle}\), and its square generates
  the maximal real subfield.  At \(q=11\), this recovers
  \(\mathbb Q(\sqrt5)\).  Treat this as proved but separately un-audited for
  attribution.
- **Proof device, no novelty claim:** flat Sidon lemma and the one-faithful-
  eigenblock Cayley criterion.
- **Partial context only:** the all-\(k\) LP bound, saturation dichotomy,
  passant-code equality bridge, Baer exclusion, and bounded-field evidence.
- **Explicitly open:** saturated-internal equality and every nonsaturated
  conic-filling branch.

## Mandatory pre-draft gates

1. Obtain or record a human MathSciNet/Scopus exact-statement search for local
   Paley subconstituent automorphisms and unique extension.
2. Obtain an external finite-geometry/character-sum cold read of the Segre
   scale pinning and primitive-Jacobi valuation normalization.
3. Freeze a theorem/lemma/corollary inventory against the two consolidated
   C756 proofs, with no superseded bispectral or conditional language.
4. Freeze terminology: exterior point, passant line, exterior set of a conic,
   and saturated-exterior branch.
5. Decide title and venue after the claims survive gates 1--4.  Current fit:
   *Designs, Codes and Cryptography*; *Discrete Mathematics* backup.

No manuscript file may be created before gates 1--4 are either passed or
explicitly recorded as submission-stage human safeguards approved by the
user.

## Authoritative inputs

- `notes/2026-08-08-c756-local-paley-proof-consolidation-and-jacobi-audit.md`
- `notes/2026-08-08-c756-saturated-exterior-consolidated-proof.md`
- `notes/2026-08-08-c756-consolidated-proof-cold-referee-read.md`
- `notes/2026-08-08-c756-local-paley-rigidity-literature-audit.md`
- `notes/2026-08-08-c756-predecessor-audit-and-companion-scope.md`
- `notes/2026-08-08-c894-ej-theorem-inventory-and-architecture.md`
- `notes/2026-08-08-c894-tt-cyclotomic-compression.md`

The discovery-stage matrices \(C,K\), anticommutator, simple-spectrum branch,
Gaussian/Pfaffian obstruction, theta fitting, and field sweeps are not part of
the paper spine.

## Acceptance

- the two main theorems are stated at exactly proved strength;
- every external theorem has a version-of-record locator;
- the primitive-Jacobi proof exposes its cyclotomic prime and \(p-1\)
  ramification normalization;
- \(q=3,7,11\), inversion-orbit uniqueness, and the \(q=11\) chord-union
  identity are inline;
- finite certificates are labeled independent corroboration, never proof;
- the 2025/2026 Javier--Llano--Zuazua result is credited for the prime
  multiplicative-circulant model, so no normality/DRR/circulant overclaim
  remains;
- all saturated-internal and nonsaturated gaps are explicit;
- a clean standalone source, bibliography, reproducibility note, and referee
  claim map pass the eventual release checks.

## Next action

Build the claim--proof--citation matrix from the frozen lean architecture in
`notes/2026-08-08-c894-ej-theorem-inventory-and-architecture.md`, then route
the two human safeguards.  The paper spine now excludes the broad all-\(k\)
partial-results package: internal/passant-code results belong only in a short
outlook.  Add the exact primitive Jacobi collision theorem to the human
novelty query.  Do not draft prose until the matrix is stable.

The matrix must also include the cyclotomic decomposition-field corollary and
the four-stage rigidity cascade frozen in
`notes/2026-08-08-c894-tt-cyclotomic-compression.md`.  Add field-generation,
Galois-stabilizer, and Gaussian-period/Jacobi-sum terms to the human search;
do not widen the paper to other cyclotomic conductors.
