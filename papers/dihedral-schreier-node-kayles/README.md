# Paper: Dihedral Schreier Node-Kayles catalogue

**Working title:** *Node Kayles on Fixed-Point-Deleted Schreier Graphs from Conic
Involutions: The Dihedral Case.*

**Status:** Markdown submission draft, near-complete and committed. This is the
small-subgroup catalogue — V₄ (Klein-four boundary) + dihedral D_{4n} + the S₄/A₅
regular-template rows. Deferred (§14): the nonregular polyhedral coset templates and their
field-dependent orbit formulas, and the full PSL₂/PGL₂ escape residual.

**Technique:** Schreier-residual graph nimbers from conic involutions. Distinct from the
`nofil-finite-geometry-outcomes` paper, which uses the pairing/mirror method — the two are
split by technique, not by geometry.

## Files here (symlinks into ../../notes/)

- `2026-07-12-dihedral-schreier-node-kayles-submission.md` — **the manuscript**
- `2026-07-12-conic-involution-schreier-graphs.md` — the mathematical writeup (§3 V₄, enumeration)
- `2026-07-12-conic-involution-residual-graphs.md` — game-side program integration
- `2026-07-12-polyhedral-nk-templates.md` — S₄/A₅ regular-template nimber table (Appendix A source)
- `2026-07-04-cayley-nodekayles-outcome-law.md` — background outcome law

## Elsewhere (not symlinked)

- **Lean:** `lean/DihedralSchreier/` — certifies the reduction plumbing and the V₄→K₄ core
  (`KleinFour.lean`, `KleinFourBridge.lean`) only; template nimbers are not Lean-certified.
- **Solver:** `rust/scripts/nodekayles_cayley.rs` — S₄ nimbers cross-checked by three
  independent solvers; the A₅ template rows are single-solver, with an independent cross-check
  pending (queued as C260).
- Driver / next-programme: C84 in `notes/handoffs/2026-07-06-projective-cap-game-handoff.md`.

See `../papers-index.md` for the registry and `../papers-planning.md` for cross-paper strategy.
