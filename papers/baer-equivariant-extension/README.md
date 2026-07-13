# Paper: Equivariant extension of Galois-invariant arcs

**Working title:** *Equivariant extensions of Galois-invariant arcs over finite fields.*

**Object:** extension of Frobenius/Baer-invariant arcs in PG(2,s²) (and higher-dim caps /
MDS codes) over finite fields — the unit of extension is a Galois orbit (a fixed point or a
conjugate pair). Headline = the orbit-valued conjugate-pair extension criterion (Thm 3.1) +
the √2·s orbit-saturation lower bound (Cor 3.4).

**Status:** theorem-package plan, no manuscript yet. Core theorems are marked `[PROVED]`
(elementary incidence counting). Prior-art audit verdict = **SOFTEN**: the √2·s bound is the
classical Lunelli–Sce √(2q) complete-arc bound at q=s², *not* a new constant — the surviving
headline is the orbit-valued criterion (a packaging contribution), and the decisive open gate
is sharpness of the √2 constant (an unbuilt construction).

**Lean:** planned `BaerExtension` library (Phase 4 of the formalization plan), **not yet
built**; only the shared `lean/FiniteGeom/` base exists.

**Absorption flag:** `completion-core-rigidity` is the likely companion — its own Stage C says
it may fold in here as a section if its headline computation fails. Keep an eye on that call.

## Files here (symlinks into ../../notes/)

- `2026-07-10-baer-equivariant-extension-upgrades.md` — the theorem-package note
- `2026-07-11-baer-extension-audit-scope.md` — external citation audit (the SOFTEN verdict)
- `2026-07-10-codex-odd-plane-round7-generator-growth-baer.md` — origin (Baer obstruction, q=25 block)
- `2026-07-09-codex-q25-baer-census.md` — q=25 Baer census (supporting data)

See `../papers-index.md` and `../papers-planning.md`. Parent audit: Package 2 in
`../../notes/2026-07-10-codex-publishable-spinout-audit.md`.
