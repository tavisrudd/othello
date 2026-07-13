# Paper: Equivariant extension of Galois-invariant arcs

**Working title:** *Equivariant extensions of Galois-invariant arcs over finite fields.*

**Object:** extension of Frobenius/Baer-invariant arcs in PG(2,s²) (and higher-dim caps /
MDS codes) over finite fields — the unit of extension is a Galois orbit (a fixed point or a
conjugate pair). Headline = the orbit-valued conjugate-pair extension criterion (Thm 3.1) +
the √2·s orbit-saturation lower bound (Cor 3.4).

**Status:** combined Markdown development draft with the completion-core project. The abstract
proof spine and coordinate Frobenius incidence layer are Lean-built; the exact quadratic count-data
instance remains conditional. Prior-art audit verdict = **SOFTEN**: the √2·s bound is the
classical Lunelli–Sce √(2q) complete-arc bound at q=s², *not* a new constant — the surviving
headline is the orbit-valued criterion (a packaging contribution), and the decisive open gate
is sharpness of the √2 constant (an unbuilt construction).

**Lean:** the proof spine is built under `lean/FiniteGeom/BaerCompletion/`, with projective-plane,
coordinate-conjugation, and quadratic-Frobenius consumers under `lean/RelativeConicArcs/`. The
exact quadratic pair-count data instance remains conditional on the fixed-locus and incidence-map
obligations in the lane's `TRUST.md`.

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
