# Conic-involution residual graphs — program integration

**Date:** 2026-07-12. How the conic-bulk Schreier structure attacks the odd-plane escape
kernel. The full mathematical writeup — the Schreier reframing, the two-centre decomposition,
and the V₄/D₈/S₄ exact-value theorems with the orbit-template theorem — is in
[conic-involution Schreier graphs](2026-07-12-conic-involution-schreier-graphs.md) (with
independent field-geometry verification at q=11–19). This note is the game-side framing only.
Companions: [C80 probe](2026-07-12-c80-bulk-exhaustion-probe.md),
[C83 quotient](2026-07-12-c83-bisimulation-quotient.md).

Current routing and next-step authority: [C84 umbrella handoff](handoffs/c84/README.md).

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
as A5/C75). A provable positive-density bound cannot be a symmetry construction; the precise
target is sharpened in **§The frontier** below.

**Pairing also fails as a uniform existence mechanism (C84 follow-up, 2026-07-17).** An exact
dependency-free automorphism census over all S₄-rooted escapes at prime
`q=7,11,13,17,19,23,29,31` found that class D at `q=29` has zero pairing-certified children among
all 753 legal escapes—not merely zero `PGL₂`-induced mirrors, but zero fixed-point-free
nonadjacent involutory graph automorphisms of any kind. Thus pairing cannot supply one P child in
every S₄ class. The surviving existence route must use an adaptive certificate, a non-pairing
bounded core/quotient, or explicit exceptions. This is a bounded obstruction, not a claim that the
q=29 children are N. Evidence: `notes/2026-07-17-c84-pairing-obstruction.md`.

**The mirror-free fiber is adaptively P-rich (C84 follow-up, 2026-07-17).** Exact Node-Kayles
solution of all 753 q=29 class-D escapes gives 139 P children (`0.1846`), so the zero-pairing result
is a mechanism obstruction, not P-depletion. Among those P roots, 91 have an opponent move with a
unique winning reply. Conversely, every P root has a worst opponent move for which every winning
reply leaves a connected component of size at least 14 (one-reply component widths range 14–20),
closing any immediate component-core theorem with bound at most 13. The next target is the
algebraic relation carried by the unique-response transitions, not another static signature.
Evidence: `notes/2026-07-17-c84-adaptive-core.md`.

**The first forced-reply algebra is context-dependent (C84 follow-up, 2026-07-17).** Across
q=13,17,19,23,29, the exact extraction contains 470 opponent/unique-winning-reply pairs in 209 P
roots. Their 88 canonical shortest coloured words in the four conic involutions all also occur on
nonwinning legal responses; at q=29 the collision already holds internally for every one of its
63 used words. Thus no fixed context-free involution word certifies the adaptive reply. The next
test is the rooted-S4/fourth-centre contextual double-coset packet, not another individual static
signature. Evidence: `notes/2026-07-17-c84-forced-reply-algebra.md`.

**The contextual double-coset packet also fails (C84 follow-up, 2026-07-17).** Quotient replies by
their minimum layer in `H, HsH, HsHsH, ...`, where `H≅S4` is the rooted group and `s` the fourth
involution. No q=23 or q=29 P root has every opponent move covered by a pure-winning layer packet;
at q=29 only one of 195 forced replies lies in a singleton packet. Stop one-ply response-signature
refinement. The last bounded adaptive test was two-ply forced-transition descent; its failure below
closed finite-template mining and led to the certificate-density viability gate. Evidence:
`notes/2026-07-17-c84-double-coset-packets.md`.

**The ledger does not transport into C84 (C84 follow-up, 2026-07-17).** C63's reservoir requires
the residual-grid frame and burned row/column directions, which the conic-only Schreier artifact
does not retain; its xor-zero term is the target P/N label in C84 and is therefore circular.
An exact audit of the shared conic measures plus a deliberately naive reservoir proxy found no
field-stable two-ply contract: winning proxy descent falls from 30/30 at q13 to 1/62 at q19 and
0/125, 0/195 at q23,q29, while q13's descent holds for every losing alternative as well. This does
not refute C63/C77 in their residual-grid domain. It triggers C84's stop rule: retire adaptive
finite-template mining and move to the certificate-density viability gate. Evidence:
`notes/2026-07-17-c84-two-ply-ledger.md`.

**Logical separation from (ON).** These abundant P children are **off-conic** fourth centres with
conic-only value 0; that does **not** by itself produce an **on-conic** P child. Closing the
escape via (ON) needs a separate **exchange / transfer lemma** carrying an off-conic
conic-only-P escape to an on-conic P child. Abundance and (ON) are two problems, not one.

**Current ranking (2026-07-17):**
1. Pass the C84 certificate-density gate: state a noncircular deterministic P-certificate event
   whose fourth-centre locus could be full-dimensional.
2. Only if that event exists, specify and prove the counting/equidistribution input for class D,
   then extend to the other rooted triple types.
3. Treat transfer from abundance to `(ON)` as a separate theorem.
4. Keep relative complete arcs as a separate sealing alternative.

The edge/drain minimax idea is not an active fallback. Greedy drain and the natural finite ledger
transport have failed; reopen a global minimax route only after stating a new theorem-level
contract that is not another local potential or feature fit.

## The frontier, stated precisely

Two refinements (Fable consult + Fricke test, 2026-07-12) fix what the density proof actually
requires.

**The value is a conjugacy invariant — no bounded quotient helps.** `𝒢(R_y)` factors through the
character-variety coordinates of the 4-tuple `(σ₁,σ₂,σ₃,σ_y)`: the exact normalized Fricke traces
(pair `tr(A_iA_j)²/∏det`, triple `tr(A_iA_jA_y)²/∏det`, quad) determine the value with **zero**
ambiguity at q=11–19 — but *vacuously*, since on the generic S₄ classes the Fricke coordinate is
near-injective (q=19 class D: 305 signatures for 305 children). This just restates that `𝒢` is a
PGL-conjugacy invariant (fibers are `Stab(T)`-orbits). The coarse invariant (order + split-type)
failed only because it is an *incomplete* orbit invariant. Net: no bounded *local* invariant of `y`
gives a dimension reduction, so signature-equidistribution is dead. (Probes:
`exact_fricke.py`, `refined_signature.py`.)

**Density ≡ definability, at equal strength.** By Chatzidakis–van den Dries–Macintyre, a
bounded-complexity, uniform-in-q definable subset of a variety over `F_q` has cardinality
`c·q^d + O(q^{d−1/2})`. So "`{y : 𝒢=0}` is a dimension-2 CvdDM-definable set" **is** the density
conjecture, at equal strength — one cannot be *assumed* to attack the other. The mex-recursion and
C79's moment-cap are heuristic against definability, not a proof.

**The real open lemma is one-sided.** Density does not need the full value-0 locus definable — only
a definable **dimension-2 subset** of it: one full-dimensional constructible family of escape `y`
carrying a uniform-in-q value-0 proof. Every certificate we have (catalogue decomposition; pairing
homography) is a **homography fixed locus ⇒ divisor ⇒ dimension 1 ⇒ Θ(q)**; density needs dimension
2. The local-invariant negatives do **not** rule out a *global* full-dimensional certificate — that
gap, on the **graph** (not the character variety), is the frontier.

**Spectral/probabilistic counting is conditional, not yet a proof program.** The varying fourth
involution is algebraically correlated with its fixed points, the dead-vertex deletion, and the
rooted-S4 action; it is not an independent random near-perfect matching. Expansion or
equidistribution cannot imply Grundy zero by itself. The first gate is a noncircular event
`E_q(y,w)` with a deterministic Node--Kayles proof `E_q(y,w) → 𝒢(R_y)=0` and a plausibly
two-dimensional y-locus. Only then may spectral, orbital, or character-sum estimates be used to
count that event. If no event passes both gates, mark C84 conceptually gated and deprioritize it.
The exact obligations and red-team failure modes are in the dedicated
[C84 umbrella handoff](handoffs/c84/README.md) and its
[certificate-density child](handoffs/c84/certificate-density-gate.md).

The separate existence lever remains logically available: a Θ(q) certificate family suffices
only if the outer induction's bad set is proved to lie on O(1) curves. No such bad-set theorem is
currently available; do not treat this observation as a C84 next step.

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
