# Paper: Dihedral Schreier Node-Kayles catalogue

**Working title:** *Node Kayles on Conic Schreier Graphs: Dihedral and Polyhedral Templates.*

**Status:** All pre-submission mathematics gates are closed. C306 has migrated the markdown source
into the canonical LaTeX manuscript `dihedral_schreier_node_kayles.tex` on the adopted eight-section
spine; the remaining C264 phases are C307 correctness integration, C308 scholarly/trust apparatus,
C309 reproducibility, C310 adversarial review, and C311 two cold-prose passes. The LaTeX source
carries `\phasenote` boxes marking every owed integration, and C309 must disable them. Fable
adopted the universal-reduction/three-applications spine, with the full `D₂ₘ` pair family first,
the `D₄ₙ` ladder family second, and the complete tame `S₄/A₅` polyhedral boundary in the body.
Wild polyhedral characteristic and the growing full/subfield `PSL₂/PGL₂` escape residual remain
outside the paper.

**Technique:** Schreier-residual graph nimbers from conic involutions. Distinct from the
`nofil-finite-geometry-outcomes` paper, which uses the pairing/mirror method — the two are
split by technique, not by geometry.

## Files here

- `dihedral_schreier_node_kayles.tex` — **the manuscript**; build with `make dihedral` from
  `papers/`
- `dihedral_schreier_node_kayles.pdf` — the built artifact

## Also here (symlinks into ../../notes/)

- `2026-07-12-dihedral-schreier-node-kayles-submission.md` — the superseded markdown source,
  retained until the LaTeX migration is verified complete (C311)
- `2026-07-12-conic-involution-schreier-graphs.md` — the mathematical writeup (§3 V₄, enumeration)
- `2026-07-12-conic-involution-residual-graphs.md` — game-side program integration
- `2026-07-12-polyhedral-nk-templates.md` — S₄/A₅ regular-template nimber table (Appendix A source)
- `2026-07-04-cayley-nodekayles-outcome-law.md` — background outcome law

## Elsewhere (not symlinked)

- **Lean:** `lean/DihedralSchreier/` — certifies the reduction plumbing and the V₄→K₄ core
  (`KleinFour.lean`, `KleinFourBridge.lean`) only; template nimbers are not Lean-certified.
- **Solver:** `rust/scripts/nodekayles_cayley.rs` — S₄ nimbers cross-checked by three
  independent solvers; the A₅ template rows are now independently cross-checked (C260), with all
  five values reproduced by a separate solver — see
  `notes/2026-07-17-c260-a5-template-nimber-crosscheck.md`.
- Driver / next-programme: C84 in `notes/handoffs/2026-07-06-projective-cap-game-handoff.md`.

See `../papers-index.md` for the registry and `../papers-planning.md` for cross-paper strategy.
The executable C264 runbook is
`../../notes/2026-07-17-c264-dihedral-latex-adversarial-review.md`.
