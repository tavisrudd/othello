# Conic-involution residual graphs — program integration

**Date:** 2026-07-12. How the conic-bulk Schreier structure attacks the odd-plane escape
kernel. The full mathematical writeup — the Schreier reframing, the two-centre decomposition,
and the V₄/D₈/S₄ exact-value theorems with the orbit-template theorem — is in
[conic-involution Schreier graphs](2026-07-12-conic-involution-schreier-graphs.md) (with
independent field-geometry verification at q=11–19). This note is the game-side framing only.
Companions: [C80 probe](2026-07-12-c80-bulk-exhaustion-probe.md),
[C83 quotient](2026-07-12-c83-bisimulation-quotient.md).

## The object, in one line

After the opening pair and some off-conic centres `S`, conic-only play is Node-Kayles on the
induced Schreier graph of `H_S = ⟨σ_x : x∈S⟩ ≤ PGL(2,q)` on the live conic points — so the
bulk's value is governed by the **subgroup type** of `H_S`, not by `q` directly. Two elementary
facts fix the local structure (both specializations of standard Nofil/Node-Kayles facts, HHS):
selecting a live point removes its closed neighborhood (capacity-2 move), and two centres'
matchings share ≤1 edge (no-3-collinear).

## Role of the catalogue: exact boundary evaluators, not a forcing mechanism

The odd-plane escape crux is the **size-3 residual → size-4 child** question. The size-3 *state*
carries ≤3 off-conic intruders, so where its `H_S` is small the catalogue evaluates it exactly.
But you cannot **stay** small: a `V₄` or `D₈` triple has **no** subgroup-preserving fourth move,
and an `S₄` triple survives at most one, after which play jumps to the full `PSL/PGL`
two-parameter family (verified, `c84_escape_probe.py`: V₄/D₈ → 0 preserving 4th moves, S₄ → ≤1,
q=11,13,17). So the size-4 **children we actually need to evaluate are generic**, with varied
conic-only values.

**(Correction to the first commit of this note, 2026-07-12: it claimed the crux "lives in the
tractable regime by construction" and that forcing "resolves favorably." That is wrong — the
escape leaves the small-subgroup regime immediately. The catalogue gives exact leaf/boundary
values, not a forcing mechanism; the surviving route is abundance + (ON) below, not staying
small.)**

## The surviving route: abundance over the escape family + (ON)

Since the size-4 children are generic (two-parameter, no finite quotient — the same wall as
C75/C76/C83), the escape cannot be settled by *predicting* a child's value. It can still be
settled by **counting**: a size-3 state has `≥ q² − O(kq)` legal children, and the mechanism to
aim for is a q-uniform lower bound showing a **bounded-condition packet of them is entirely
winning** — existence, no selector. This is C80(a) abundance, and it dovetails with the
**(ON)** conjecture (some P child lies on the conic): conic-only Grundy = full value under (ON),
so an abundance bound on conic-only-P escaping children would close the escape. `Schreier + (ON)`
is then boundary evaluation + abundance, not a forcing engine.

## The √q-sealing bridge to A5 depletion

The alternative to abundance is a **sealing** argument: preventing escape needs `Θ(√q)`
pre-existing blockers of the off-conic supply. The `q + √q + 1` scale is the blocking-set / Baer
subplane threshold, which plausibly ties the sealing problem to the program's **A5 arc-depletion**
lane (odd-plane escape fails only at the depleted orders `{11,17}` through q=25, studied with a
Baer census). If the minimal sealing set is Baer-shaped, the √q sealing problem and the depletion
condition may be one obstruction — the open cross-lane question.

## The drain resource and a minimax potential

`|live conic|` is a computable well-founded measure (drops by `1 + deg` per conic move — the
closed-neighborhood move), and the centre matchings give the edge lower bound
`|E(G_live)| ≥ Σ_x max(0, (q+1−f_x)/2 − d)` (`d` = dead conic points). Upgrading this from an
available greedy move to a **minimax potential** tracking both live vertices and live coloured
edges is the game-semantic step C80(b) targets — the piece that would turn "the bulk is
structured" into "the responder can steer play into an exact family."

## Grounding

`rust/scripts/c80_drain_rate.py` (drain identity, q=11 exhaustive to size 6, zero exceptions)
and `rust/scripts/c80_schreier_verify.py` (the V₄/D₈/S₄ classification, q=11–19). Details and
the full theorem statements are in the
[Schreier note](2026-07-12-conic-involution-schreier-graphs.md).
