# C860 — shared projective-cap closure remediation

**Lane:** `clebsch` · **Date:** 2026-08-03

## Outcome

The paper Lean closures no longer carry cap-game material or undocumented
shared modules. The route executed is lighter than the card's full
dependency inversion, by explicit user acceptance:

1. **Game/geometry split (C855 window).** The five "Separate the …" commits
   (`ef5f9d2c`–`a14fefa1`) split the cap library so `CapGame.BuildGame`,
   `FrameGridBridge`, `GridGame`, and `GridSeed` left the paper gates'
   transitive closures, and the `ProjectiveCap.Sym2ConicBridge` reverse
   references were removed. The accepted `Q11Residual` residue (Paper I and
   the arcs paper keeping `BuildGame`/`Mirror`/`GraphMirror`) is unchanged.
2. **Documentation pass (commit `566ab195`).** The five geometry modules
   still imported by `RelativeConicArcs` — `ProjectiveCap.Grid`,
   `PlaneAffineChart`, `PlaneTransitivity`, `Projective`, `Sym2ConicBridge` —
   now have a self-contained mathematical docstring on every public
   declaration (89 added: 11, 36, 31, 5, 6 respectively), a repaired
   `Grid.lean` header that previously carried status prose, and clarified
   prose where existing docstrings leaned on unexplained project jargon.
   Negative checks are clean across the five files: no `sorry`, `axiom`,
   `native_decide`, task identifier, status vocabulary, or machine-local
   path. All four Paper II gates rebuilt green through the guarded queue
   with the edited modules elaborating inside that closure.
3. **Not performed.** The thirty-seven used declarations were not moved into
   a `RelativeConicArcs` base module; the `ProjectiveCap` imports remain,
   now pointing at documented referee-standard modules.

The Paper II transitive closure is therefore at the referee documentation
standard end to end, retiring the "referee-ready on the project-owned
closure only" qualifier from the C856 closeout. The independent review that
preceded this pass is `notes/2026-08-03-c856-review-verification.md`.

## Stage-5 revalidation finding

The only paper surface pinning the edited files,
`papers/ame_lu/release/RELEASE-MANIFEST.json`, was already broken before
this work: commit `47ad5311` (2026-08-02) deleted `papers/ame_lu/supplement/`
without regenerating the manifest, its generator
(`papers/ame_lu/release/verify_release.py`) crashes on the missing
`EVIDENCE-MANIFEST.json`, thirty of forty-three public-export entries point
at files no longer on disk, and the two ProjectiveCap entries were stale
before the docstring pass. No AME/LU file was modified; the repair —
restoring the supplement or changing the generator — is an `ame-lu` lane
decision recorded on the C860 card.

## Process note

A doc comment cannot precede a `set_option … in` combinator; the docstrings
for the two decidability instances guarded that way had to sit below the
`set_option` line to parse.
