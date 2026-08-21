# C936 — Modular resolvent companion

**Lane:** `cubic-threefolds`

**Date:** 2026-08-21

**Status:** accepted by the independent repair audit 2026-08-21 with confidence
0.94.  The relative degree-one polarized comparison, exact Fourier
and twist bridges, candidate-packet/actual-kernel distinction, chordal
catalecticant identification, and boundary equivariance argument are now
proved; the integrated `make check` gate passes.  The audit's one minor wording
item and optional full-support certificate assertion are also closed.  The
final style-guide pass compresses the abstract to 142 source words, adds one
proof-mechanism paragraph after the main theorem, and makes the higher-prime
aside skippable without changing a claim.  Referee report
`../2026-08-21-c936-van-geemen-cold-referee.md`; project report
`../2026-08-21-c936-modular-resolvent-companion.md`; strategy memo
`../2026-08-21-c936-resolvent-rigidity-package-memo.md`.  The verified
standalone repository is `~/src/math-papers/cubic-gluing-resolvent` at
commit `92a7d79`.

## Goal

Write a short standalone paper proving that the signed parameter of the
nonstandard `A_5` cubic pencil is the sign/discriminant resolvent of the
relative norm-axis elliptic two-division cover.  The paper should turn the
finite `3+2` packet into one exact modular diagram without identifying objects
at stronger levels than the geometry supports.

## Owned paths

- `papers/cubic-gluing-resolvent/`;
- this card and one dated C936 report;
- the cubic-threefold lane queue, handoff, archive, and discovery companion;
- a paper-local reproducibility bundle copied or distilled from the exact C904
  certificates with its own checksums and replay entry point.

No edit to the `m=1` epilogue, its Lean companion, the all-`m` manuscript, or
any standalone mirror follows automatically.

## Theorem spine

1. Define the marked pencil `X_t:P+tQ=0`, the outer involution `t -> -t`,
   and the unmarked coordinate `T=81t^2`.
2. Derive the Prym/norm-axis elliptic factor and its cyclic order-three
   structure from the van Geemen--Yamauchi chart, including the quadratic
   twist that preserves two-torsion.
3. Use the relative six-axis isogeny and the degree-one polarized Prym/axis
   comparison to transport the universal two-division packet to the actual
   principal kernel.
4. Prove that the exotic complement is the sign resolvent and that the signed
   cubic line is `r^2=T`, with `r=9t` after one deck convention.
5. Identify the rational degree-three quotient with `X_0(6)` and the common
   degree-six Galois closure with `Gamma_0(3) ∩ Gamma(2)`.
6. Prove the congruence subgroup, genus, elliptic-point, cusp-width, and eta
   Hauptmodul statements with the coarse/stack distinction explicit.
7. State the exact smooth and compactified boundaries: finite-etale over the
   modular open, ramified at the two cusps after compactification, and no claim
   that every cubic boundary point is a modular cusp.

## Acceptance gates

- self-contained human proofs of the theorem spine;
- source-level literature pinpoints and a priority boundary obeying the
  literature-audit conventions;
- tracked deterministic evidence script, compact output, SHA-256 manifest,
  and an independent algebraic or subgroup cross-check;
- clean manuscript build, warning rejection, page inspection, and a hostile
  mathematical cold read;
- `ej` + `tt` closeout and a mystery ledger before completion;
- mirror/export only after the paper passes locally and the export conventions
  have been read.

## Scope brake

The paper is about the modular resolvent of the actual gluing packet.  Fricke
correspondences, arithmetic trace laws, rational elliptic surfaces, Winger
shadow-sister comparisons, motivic fifth-power decompositions, and explicit
Mordell--Weil generators remain outside unless one short corollary materially
clarifies the main theorem without adding a new proof dependency.

The warning-free eleven-page paper, deterministic algebra certificate,
independent subgroup enumeration, SHA-256 manifest, rendered-page inspection,
literature record, and EJ/TT mystery ledger are recorded in the project report.
The standalone export is synchronized and verified.  A genuinely blind cold
read found that the initial certificates did not close two geometric
identifications on which the paper's strongest claims depended; the repairs
below are included in the exported version.

## Cold-referee findings and repairs

1. **Fatal:** construct the relative map from the van Geemen--Yamauchi
   elliptic curve to the programme's primitive norm axis and prove the two
   polarization identities, degree-one conclusion, special-parameter
   extension, coordinate bridge `u^2=5t^2`, twist, and marked level-three
   comparison.  The cited source proves only an isogeny to the invariant
   elliptic factor.
2. **Major:** state the imported programme input precisely, separating the
   five-sheet packet of candidate stable halves from the one actual geometric
   kernel section that orients the pulled-back sign torsor.
3. **Major:** prove scheme-theoretically that the `t^2=9/5` fibre has the
   asserted rational normal quartic as its full singular scheme and is its
   secant cubic.  Conditional on this identification, the tracked orbit/rank
   certificate and published Allcock--Carlson--Toledo Lemma 2.5 do prove the
   reduced transverse twelve-divisor and normal-space statement.
4. **Minor:** complete Corollary 5.2 with the perfection/no-character argument
   for `A_5` and the orbit sizes `12,20,30,60`.

All four repairs are implemented.  The actual-axis proof now derives the
factor-five Prym pullback polarization, compares it with the factor-five axis
restriction, and forces degree one.  A Fourier transform proves `u=ct`,
`c^2=5`, and an invariant ratio proves the twist.  At the chordal value the
same Fourier equation is four times a Hankel catalecticant, whose reduced
singular locus is the rank-one rational normal quartic and whose zero cubic is
its secant variety.  The exact findings, source trust boundaries, and repair
audit are in `../2026-08-21-c936-van-geemen-cold-referee.md`.

The reopened mathematical pass adds two theorem-level clarifications.  At
the chordal value `h=5`, the icosahedral genus-five hyperelliptic
limit has Jacobian isogenous to the fifth power of the same elliptic curve
printed by the norm-axis modular coordinate.  The finite `3+2` lemma is also placed in its
general-prime context: the two orbits are the Borel and nonsplit-Cartan
quotients, and only at two does the nonsplit orbit itself become a discriminant
double cover.  The unresolved questions and their literature boundaries are in
the report's reopened-supplement section.
