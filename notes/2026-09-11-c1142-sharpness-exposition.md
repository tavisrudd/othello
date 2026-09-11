# C1142 — sharpness exposition

**Lane:** cubic-threefolds. **Status:** active, authorized 11 September 2026.

Implement the uninterrupted surface → uniform cubic → arithmetic narrative;
move named examples and higher-dimensional series after it. Name the existing
universal tangent-cover assertion in Appendix E and connect its smoothness,
evaluation and parameter-coverage responsibilities to the main proof. Compress
peripheral prose while preserving all results and the rank-four/finite-index
limitations. No expanded nonsplit parametrization is in scope.

Audience: birational geometers, with arithmetic geometers as adjacent readers.
Preserve the abstract, title, AI disclosure, existing theorem statements,
mathematical proof content and certificate data. Add only the named interface
lemma and its absent-coverage row. Validate with the existing full gate and
export the committed authority, including all generated provenance.

## Changes

Sections 4–6 now give surface rationalization → uniform cubic family →
arithmetic separation without interruption. The named examples and
higher-dimensional series are in Section 7. Existing semantic labels remain
stable, including `sec:rationality` for the moved examples. The introduction,
README and reviewer guide describe the new order.

Appendix E now starts with `lem:universal-tangent-cover`, collecting smooth
tangent point, four-dimensional tangent-hyperplane space, invertible
evaluation and universal smooth-parameter coverage. Its proof is the existing
symbolic witness/branch calculation. The new claim-map row has absent Lean
coverage and cites the existing certificate. Properties of an individual
witness are explicitly restricted to Delta nonzero. The main proposition
retains general tangent-projection compatibility and ground-field density;
the certificate lemma does not purport to prove either.

Compression removes the duplicate finite-coefficient descent proof after
moving it behind the uniform-family proof, the duplicate series proof summary,
and routine repetition in affine-line, partner and fibration consequences.
All existing theorem-like statement digests still match. The finite-index
and rank-four appendices, abstract and AI disclosure are byte-identical.
Source whitespace word count falls from 10038 to 9912 despite the new lemma.
No consequence is deleted, no literature verdict changed, and no expanded
ground-field parametrization is claimed.

## Validation

The metadata gate accepts 22 absent-coverage statements. It checks the new
lemma against the existing slice-cover evidence; no certificate bytes or
acceptance criteria were weakened. The first TeX build found the previously
unused `lemma` environment undeclared. Adding its shared theorem-counter
declaration corrected that source error before rerunning the gate.
Full build and export identities are recorded at closeout below.

The authority `make check` passes (run-quiet
`20260911-023856-make-C-cubic-stabilization-irrationality-check`). The rebuilt
PDF remains 24 pages. Rendered page 14 now contains the named examples as a
self-contained later section; page 20 presents Lemma E.1 and its witness
table together without a broken table or orphaned heading.

## Mystery ledger

This is an exposition-only task. No new mathematical mystery was introduced.
The requested explicit nonsplit ground-field parametrization remains an
optional separate project, as authorized; it is not needed by this revision.
No incidental discovery-log entry is warranted.

Post-gate **ej+tt** pass: the move made it possible to replace the duplicated
descent argument by a backward reference to the uniform theorem's proof.
The certificate interface was checked against its actual quantifiers:
splitting-field nonemptiness is separated from the general-point and
ground-field steps, and witness properties are restricted to smooth
parameters. No additional result or hypothesis is needed.
