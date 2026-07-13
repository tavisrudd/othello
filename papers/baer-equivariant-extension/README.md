# Paper: Equivariant extension of Galois-invariant arcs

**Working title:** *Equivariant extensions of Galois-invariant arcs over finite fields.*

**Object:** extension of Frobenius/Baer-invariant arcs in PG(2,s²) (and higher-dim caps /
MDS codes) over finite fields — the unit of extension is a Galois orbit (a fixed point or a
conjugate pair). Headline = the orbit-valued conjugate-pair extension criterion (Thm 3.1) +
the √2·s orbit-saturation lower bound (Cor 3.4).

**Status:** source/staging directory folded into the canonical combined paper
`../equivariant-robust-completion/`. The abstract proof spine and exact coordinate quadratic
pair-extension theorem are Lean-built. Prior-art audit verdict = **SOFTEN**: the √2·s bound is the
classical Lunelli–Sce √(2q) complete-arc bound at q=s², *not* a new constant — the surviving
headline is the orbit-valued criterion (a packaging contribution), and the decisive open gate
is sharpness of the √2 constant (an unbuilt construction).

**Lean:** the proof spine is built under `lean/FiniteGeom/BaerCompletion/`, with projective-plane,
coordinate-conjugation, quadratic-Frobenius, exact line-counting, and forbidden-charge consumers
under `lean/RelativeConicArcs/`. See the lane's `TRUST.md`.

**Merge decision:** `completion-core-rigidity` is folded into this development draft as the
robustness and reconstruction layer.

**Combined development draft:**
[`paper-baer-equivariant-robust-completion.md`](../../notes/2026-07-12-riffing-on-applications/paper-baer-equivariant-robust-completion.md).

## Files here (symlinks into ../../notes/)

- `2026-07-10-baer-equivariant-extension-upgrades.md` — the theorem-package note
- `2026-07-11-baer-extension-audit-scope.md` — external citation audit (the SOFTEN verdict)
- `2026-07-10-codex-odd-plane-round7-generator-growth-baer.md` — origin (Baer obstruction, q=25 block)
- `2026-07-09-codex-q25-baer-census.md` — q=25 Baer census (supporting data)

See `../papers-index.md` and `../papers-planning.md`. Parent audit: Package 2 in
`../../notes/2026-07-10-codex-publishable-spinout-audit.md`.
