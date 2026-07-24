# Paper: Beyond redundancy four for projective Reed--Solomon codes

**Working title:** *Projective Reed--Solomon syndromes beyond redundancy four: deep holes,
coherent polar flags, and modular carriers.*

**Status:** 41-page proof-complete local manuscript candidate.  The manuscript
proofs, claim-level trust map, statement-adequacy boundary, public
classification records, certificate schema, literature audit, and rendered
referee-polish gates are closed.  DOI publication remains gated on the
C541--C544 aggregate formalization/reconciliation, an independent final
reader, a clean public export/replay, immutable identifiers, and author/account
confirmation.  This merged paper supersedes the former plan for a
redundancy-five-only manuscript.

## Build

From this directory:

```text
make check
```

The principal files are `main.tex`,
`prs-beyond-redundancy-four.pdf`,
`refs.bib`, `theorem-map.md`,
`claim-proof-novelty-ledger.md`, `adversarial-proof-evidence-audit.md`,
`second-draft-fix-plan.md`, and `verification-map.md`.  Major TeX units live
under `sections/`; `main.tex` is the build driver described in
`sections/README.md`.  Public certificates and release material are under
`supplement/`.  Run `python3 supplement/verify.py` for the local manifest and
classification-record check, or add `--replay` for every paper-local replay.

## Results

The paper begins immediately beyond the published redundancy-at-most-four frontier and keeps the
exact strength of each proved level visible:

1. the complete all-field classification of deep holes of `PRS(q-4)` at redundancy five;
2. the transition from cubic-pencil exceptional covers to coherent consecutive-polar flags;
3. the all-field redundancy-six deep-hole classification and the complete
   all-field redundancy-seven split-free classification, with its separate
   small-field covering-radius boundary;
4. the complete redundancy-eight/nine high-field arguments, with their exact
   thresholds, orbit laws, modular boundaries, and closed pointed
   lower-package/slice gates;
5. the general coherent-polar induction theorem;
6. the characteristic-two ordered-Hessian degeneracy theorem and the explicit
   root-compatible/base-selection gates on its persistent/Lucas corollary;
7. the proved Lucas-carrier arithmetic through the degree-nine `e_7` orbit.

The manuscript must distinguish complete classifications from containment, high-field, and
obstruction statements.  Redundancy ten is not a gate: C531/C532 may be incorporated only if their
theorem closes before manuscript freeze.

## Deliberate exclusions

- C481--C490 projection/Gale reconstruction belongs to the separate reconstruction-paper decision.
- Twisted Reed--Solomon results C510/C514/C515/C518 are not part of the projective-RS spine.
- A standalone modular-Hessian paper is considered only if C535 proves naturality beyond the
  contraction/PRS setting.
- No ambient syndrome census substitutes for the proved geometric and arithmetic mechanisms.

## Verification plan

- C517 already supplies the redundancy-nine residual-quadratic algebra and synthesis gate.
- C539 builds the shared paper-facing PRS/Hankel formal interface and exact coverage ledger.
- C540 closes the redundancy-five Lean package.
- C541 closes the coherent-polar engine and redundancy-six/seven applications.
- C542 closes the redundancy-eight application.
- C543 closes the characteristic-two ordered-Hessian and Lucas-carrier layer.
- C544 supplies the aggregate import gate, axiom audit, referee-facing trust map, and final
  manuscript-to-formalization reconciliation.

All computational claims retain their committed generators, independent replays, compact
certificates, and checksum manifests.  Lean terminals must expose rather than conceal cited
geometric or arithmetic inputs that are not formalized.

## Release gate

A release described as proof-complete requires:

1. theorem/proof completeness review;
2. claim-by-claim trust map;
3. statement-adequacy appendix;
4. data/code availability and assistance disclosure;
5. exact shared-Lean commit, targets, and axiom audit;
6. immutable source/certificate manifest;
7. clean-checkout replay and build;
8. reviewed paper-only fresh-history repository export and versioned DOI
   (the development monorepo is never published);
9. target-policy check;
10. cold-prose and adversarial review.

The present draft passes the local proof and supplement-schema gates but not
the aggregate formalization, clean public replay, immutable-release, or
author/account gates.

## Rapid priority record

The quick note is not a second publication.  It is a concise, proof-complete Version 1 of this
paper only after the release gate above closes, carrying the same title family, authorship, theorem
numbering map, and later-version relationship.  C545 will then verify the selected journal's current
preprint policy, prepare the exact release artifact and metadata, and use a recognized preprint
route that supplies both a public timestamp and DOI.  Later manuscript versions must cite and
supersede that record rather than presenting overlapping material as an independent paper.  An
earlier research-announcement release would require an explicit re-scope and must not claim proof
completeness.

## Initial source set

- `notes/2026-07-22-c491-prs-redundancy-five.md`
- `notes/2026-07-22-c498-prs-redundancy-six.md`
- `notes/2026-07-23-c509-prs-redundancy-seven.md`
- `notes/2026-07-23-c512-general-polar-flag-theorem.md`
- `notes/2026-07-23-c513-prs-redundancy-eight.md`
- `notes/2026-07-23-c516-prs-redundancy-nine.md`
- `notes/2026-07-23-c517-prs-redundancy-nine-lean.md`
- `notes/2026-07-23-c525-ordered-hessian-arf-pullback.md`
- `notes/2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.md`
- `notes/2026-07-23-c530-degree-nine-lucas-e7-quotient-cover.md`
- the associated literature audits and reproducibility bundles named by those reports
