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

## Why this reaches the escape crux

The odd-plane escape crux is the **size-3 residual → size-4 child** question, so it carries only
**1–3 off-conic intruders** — exactly the small-`H_S` regime the Schreier catalogue solves:

- **≤2 intruders → dihedral → fully soluble** (Theorem 2.1: ≤2 paths + uniform `2r`-cycles,
  closed Grundy). A large fraction of escape configurations should fall here.
- **3 intruders → the V₄/D₈/S₄/D₁₂/… catalogue** with exact congruence-periodic values.

Deep play generating all of `PGL(2,q)` is irrelevant to a size-4 escape; the crux lives in the
tractable regime by construction. This is the sense in which the "can play be forced into
small-subgroup configurations?" question resolves favorably **for the crux** even though it may
fail for arbitrary deep positions.

## The one real gap: conic-only vs full value = (ON)

The Schreier theorems give exact values for the **conic-only** residual. The full escape value
also has **off-conic** continuations, so conic-only Grundy ≠ full-position value in general.
That gap is *precisely the (ON) conjecture* — "some P-valued size-4 child lies on the conic." If
(ON) holds, the conic-only Schreier value **is** the escape value, and Theorem 2.1 + the
three-centre catalogue become an escape engine. **`Schreier + (ON)`** is the synthesis to aim
for; Schreier alone is an exact bulk sub-theory, not an escape theorem.

## The gating measurement

Classify the **actual escape-crux states** (balanced-root / size-3 residuals through q=19, the
C79/C77 corpus) by their `H_S` subgroup type: what fraction sit in the dihedral (solved) and
small-polyhedral (catalogued) regimes vs generic? This directly tests whether the Schreier
engine reaches the crux, and is the next concrete probe (pairs with C80(a) abundance).

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
