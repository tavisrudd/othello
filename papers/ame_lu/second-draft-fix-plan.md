# Paper I sharpening plan

## Closed in the manuscript split

- Paper II independently builds, verifies all 17 inherited artifacts, and
  owns every MDS--CSS exact-group, six-point, scalar, transport, and
  party-extension theorem.
- Paper I now has the title *Local-Unitary Rigidity and Quantitative Rounding
  for Stabilizer AME States*.
- The abstract and first two pages lead with exact rigidity and the
  cleaning-based quantitative theorem.
- The body order is support geometry, exact rigidity, atlas/encoder
  consequence, cleaning-based rounding, robust atlas compatibility, trust
  boundary, and conclusion.
- Partial-Weyl recognition, two-/`k`-uniform stability, the budget-free
  residual estimate, and the single-marginal and aggregate routes are
  appendices.
- Paper II source sections, figures, and the computational supplement have
  been removed from this root.
- The manuscript, README, provenance, Zenodo metadata, and internal theorem,
  novelty, verification, formalization, and adversarial ledgers use the Paper
  I boundary.

## Validation gate — passed

- warning-free `make check`;
- 32--36 total pages;
- theorem-only cold read passes the three questions in
  `adversarial-proof-evidence-audit.md`;
- title, theorem openings, figures, appendix transition, and conclusion pass
  rendered inspection;
- no source reference to a removed Paper II section, label, figure, or
  computational supplement.

## Deliberately pending

- create and validate the Paper I semantic Lean gate and axiom audit;
- replace the broad pre-split release closure by a formal-root contract;
- regenerate the release manifest and public source identity;
- synchronize the existing standalone by a forward commit;
- obtain the final release cold read and public citation.

These are formal-split and release phases, not part of manuscript sharpening.
