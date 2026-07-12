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
But you cannot **stay** small: a `V₄` or `D₈` triple has **no** subgroup-preserving fourth move;
an `S₄` triple admits a few (up to 3) subgroup-preserving fourth moves but no legal fifth — its 9
involution-centres have maximum cap 4, so internal play halts at size 4 and every further move
escapes to the full `PSL/PGL` two-parameter family (verified, `c84_escape_probe.py` /
`s4_escape_probe.py`, q=7–23). So the size-4 **children we actually need to evaluate are generic**,
with varied conic-only values.

Caveat on the catalogue (Codex, 2026-07-12): order 24 does **not** identify `S₄` — the dihedral
`D₂₄` also occurs in `PGL(2,q)` and must be separated by element-order profile
(`{1:1, 2:9, 3:8, 4:6}` for `S₄` vs `{1:1, 2:13, 3:2, 4:2, 6:2, 12:4}` for `D₂₄`). The abundance
rows below are genuine-`S₄`, profile-verified at q=7–23.

**(Correction to the first commit of this note, 2026-07-12: it claimed the crux "lives in the
tractable regime by construction" and that forcing "resolves favorably." That is wrong — the
escape leaves the small-subgroup regime immediately. The catalogue gives exact leaf/boundary
values, not a forcing mechanism; the surviving route is abundance + (ON) below, not staying
small.)**

## The surviving route: abundance first, then transfer to (ON)

Since the size-4 children are generic (two-parameter, no finite quotient — the same wall as
C75/C76/C83), the escape cannot be settled by *predicting* a child's value. It can still be
settled by **counting**: a size-3 state has `≥ q² − O(kq)` legal children, and the mechanism to
aim for is a q-uniform lower bound showing a **positive density of them is P** — existence, no
selector.

**Abundance measured (S₄-rooted escape; reproduced two independent ways).** Fraction of escaping
fourth centres with conic-only Grundy 0, over the four `S₄` triple classes A,B,C,D:

| q | class fractions (A, B, C, D) | min |
|---:|---|---:|
| 7  | 0.323, 0.276, 0.067, 0.259 | 0.067 |
| 11 | 0.212, 0.195, 0.233, 0.195 | 0.195 |
| 13 | 0.188, 0.156, 0.343, 0.183 | 0.156 |
| 17 | 0.234, 0.216, 0.168, 0.201 | 0.168 |
| 19 | 0.248, 0.187, 0.147, 0.131 | 0.131 |
| 23 | 0.245, 0.187, 0.153, 0.155 | 0.153 |

The min over classes sits in `[0.13, 0.20]` for every q ≥ 11 (q=7 is the lone small-q dip) and
does **not** depress at the depleted orders `{11,17}`. So the conjecture

```
#{ y : 𝒢(R_{T∪{y}}) = 0 } ≥ c·q²   with absolute c > 0  (c ≈ 0.13 empirically)
```

is plausible beyond small exceptions. It is **not** yet theoretically supported: Grundy-0 is a
global property, and identical pair-product-order signatures already carry different values (the
`ambig` counts grow with q).

**The density proof will not be a pairing/mirror argument.** A residual `R` is Grundy 0 whenever
it has a fixed-point-free involutory automorphism with no `{v, τv}` edge (2nd player mirrors).
That sufficient condition covers only a **minority** of the P escape children and is unstable per
class (q=11: 11/72 total, class B `0/17`; q=13: 37/116) — most P children are Grundy 0 for a
non-pairing reason, so `pairing/τ` is not the density mechanism (same adaptive-not-symmetric wall
as A5/C75). A provable positive-density bound must be **Grundy-arithmetic** — a bounded functional
of `R`'s decomposition that hits 0 on a counted family — not a symmetry construction.

**Logical separation from (ON).** These abundant P children are **off-conic** fourth centres with
conic-only value 0; that does **not** by itself produce an **on-conic** P child. Closing the
escape via (ON) needs a separate **exchange / transfer lemma** carrying an off-conic
conic-only-P escape to an on-conic P child. Abundance and (ON) are two problems, not one.

**Revised ranking (Codex, 2026-07-12):**
1. Prove a positive-density P bound — first for the `S₄`-rooted escape families, then uniformly
   over all triple types.
2. Determine whether that abundance transfers to (ON).
3. Study relative complete arcs as the sealing alternative (below).
4. Pursue the edge/drain minimax potential (below) if abundance fails.

## Sealing is a complete-arc / saturating-set problem (ranking item #3)

The alternative to abundance is a **sealing** argument: preventing escape needs enough
pre-existing structure to cover the off-conic supply. **Correction (Codex, 2026-07-12): this is a
complete-arc / saturating-set problem, not a blocking-set problem.** A Baer subplane has
`q+√q+1` points but contains long lines, so it is **not** a cap — the earlier "√q blocking-set /
Baer subplane" bridge does not apply. Subfield arcs inside a Baer subplane might help for
**square** `q`, but that needs a separate secant-cover proof; and the depletion orders `{11,17}`
are **nonsquares**, which argues against any universal Baer explanation. The right objects are
complete (unextendable) arcs and saturating sets — see
[complete arcs](https://arxiv.org/abs/1011.3347) and
[saturating sets](https://arxiv.org/abs/1505.01426).

## The drain resource and a minimax potential (ranking item #4 — fallback)

`|live conic|` is a computable well-founded measure (drops by `1 + deg` per conic move — the
closed-neighborhood move), and the centre matchings give the edge lower bound
`|E(G_live)| ≥ Σ_x max(0, (q+1−f_x)/2 − d)` (`d` = dead conic points). Upgrading this from an
available greedy move to a **minimax potential** tracking both live vertices and live coloured
edges is the game-semantic step C80(b) targets — the piece that would turn "the bulk is
structured" into "the responder can steer play into an exact family."

## Grounding

`rust/scripts/c80_drain_rate.py` (drain identity, q=11 exhaustive to size 6, zero exceptions),
`rust/scripts/c80_schreier_verify.py` (the V₄/D₈/S₄ classification, q=11–19), and
`rust/scripts/s4_escape_probe.py` (the escape gating measurement + the abundance table above).
The abundance rows, the genuine-`S₄` (element-order profile) check, and the pairing-witness
minority result were independently reproduced at q=7–23 (Claude, 2026-07-12). Details and the
full theorem statements are in the
[Schreier note](2026-07-12-conic-involution-schreier-graphs.md).
