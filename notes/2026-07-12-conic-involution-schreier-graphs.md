# Conic-involution Schreier graphs

**Date:** 2026-07-12
**Scope:** odd prime powers unless restricted to primes; characteristic ≠ 2, 3 for the
polyhedral rows (char 3 action is wild).

Full mathematical writeup of the conic bulk as a Schreier graph. Program integration and the
odd-plane-escape framing (drain resource, `Schreier + (ON)` synthesis, escape-crux use) are in
the companion [conic-involution residual graphs](2026-07-12-conic-involution-residual-graphs.md);
the bisimulation-quotient measurement is [C83](2026-07-12-c83-bisimulation-quotient.md).

Independent verification: every value theorem below (V₄, D₈, and the S₄ four-class table) is
reproduced at q = 11, 13, 17, 19 by `rust/scripts/c80_schreier_verify.py`, which builds the
residual from this repo's `PrimeGridGame` field geometry — a different conic normalization,
sigma derivation, and centre domain from the standalone enumerator. See §6.

## 1. The object

Let `C = {[t²:t:1] : t ∈ F_q} ∪ {[1:0:0]}` be the conic `XZ = Y²`, identified with `P¹(q)`. An
off-conic point `x = [a:b:c]` induces the projection involution
```
σ_x(t) = (bt − a)/(ct − b),   A_x = [[b, −a],[c, −b]],   A_x² = (b² − ac) I,
```
so `σ_x` is a non-identity involution exactly when `x ∉ C`. For selected centres `S`, the
coloured multigraph with edges `t — σ_x(t)` (`x ∈ S`) is the Schreier multigraph of
`H_S = ⟨σ_x : x ∈ S⟩ ≤ PGL(2,q)` on `P¹(q)`. The live conic graph is the simple induced graph
after removing the saturated set — conic points on a line through two selected centres:
```
D(S) = ⋃_{{x,y}⊂S} Fix(σ_x σ_y).
```
(`σ_x σ_y(t) = t ⟺ σ_x(t) = σ_y(t) ⟺ x,y both lie on line `t·partner` or on the tangent at
`t` ⟺ `t ∈ xy`.) Conic-only play is Node-Kayles on
`Sch(H_S, P¹(q), {σ_x})[P¹(q) \ D(S)]` (loops removed, coincident coloured edges merged).

## 2. Two centres: uniform alternating components

Let `x ≠ y`, `g = σ_x σ_y`, `r = |g|`.

**Theorem 2.1.** After removing the conic points on line `xy`: (1) the residual two-colour
graph is simple; (2) it has at most two path components; (3) every cycle has length `2r`.

*Proof.* `C ∩ xy` is a common fixed point of `σ_x, σ_y` (tangent) or the endpoints of their
unique shared edge (secant) — the saturated degeneracies. Each remaining component has degree
≤2 and is properly two-edge-coloured; path endpoints are fixed points of one involution, and
each involution has ≤2 fixed points, so ≤4 endpoints and ≤2 paths. Two successive coloured
edges apply `g` or `g⁻¹`, and every orbit of a non-identity element of `PGL(2,q)` has length
`|g|` (split/unipotent/nonsplit normal forms), so cycles have length `2r`. ∎

**Corollary 2.2.** With `P_n` = Node-Kayles path Grundy (`P_m = 0` for `m ≤ 0`),
`P_n = mex_{1≤i≤n}{P_{i−2} ⊕ P_{n−i−1}}`, and `C_n = mex{P_{n−3}} = 1` if `P_{n−3}=0` else 0.
The two-centre residual value is the xor of ≤2 path values and the parity of the identical
`2r`-cycles — no bulk search.

## 3. Self-polar triangles: only K₄'s

The conic polarity has form `B(x,y) = af + cd − 2be`, and `tr(A_x A_y) = −B(x,y)`; since
`A_x A_y + A_y A_x = tr(A_x A_y) I` for traceless 2×2 matrices, polar-conjugate centres give
projectively commuting involutions.

**Theorem 3.1.** If `x,y,z` form a self-polar triangle then `{1,σ_x,σ_y,σ_z} ≅ V₄` with
`σ_x σ_y = σ_z`. If exactly `s` of the three involutions are split, the saturated set has size
`2s` and the live conic graph is `((q+1−2s)/4) · K₄`, so `𝒢 = (q+1−2s)/4 (mod 2)`.

*Proof.* Pairwise polarity gives `tr(A_x A_y)=0` ⇒ commuting involutions ⇒ Klein four. Side
`xy` is the polar of `z`, meeting `C` in `Fix(σ_z)`, so saturation removes all three
involutions' fixed points (pairwise disjoint in odd char). `V₄` acts freely on the rest, every
orbit has 4 points, and the three involutions give the three perfect matchings of `K₄`. A move
in `K₄` deletes the whole component, so `𝒢(K₄)=1` and disjoint sums are parity. ∎

**Corollary 3.2** (mod-8 P condition for the self-polar family):

| q mod 4 | s | #K₄ | P exactly when |
|---|---:|---:|---|
| 1 | 1 | (q−1)/4 | q ≡ 1 (mod 8) |
| 1 | 3 | (q−5)/4 | q ≡ 5 (mod 8) |
| 3 | 0 | (q+1)/4 | q ≡ 7 (mod 8) |
| 3 | 2 | (q−3)/4 | q ≡ 3 (mod 8) |

Orthogonal-basis counting: `|PGL(2,q)|/24` self-polar triangles of the `s ∈ {0,3}` type,
`|PGL(2,q)|/8` of the other — large explicit families, not coincidences. (Conic-only value
only; off-conic continuations can change the full-position value.)

## 4. Subgroup classification

For three centres the pre-saturation graph is the Schreier graph of a three-involution
subgroup of `PGL(2,q)`; use the finite-subgroup classification, not arbitrary subcubic graphs.
Exhaustive prime-`q` profiles `(h,m):n` (`n` subgroups of order `h`, each from `m` legal
triples):

| q | profiles (h,m):n |
|---:|---|
| 3 | (4,1):4, (8,4):3, (24,52):1 |
| 5 | (4,1):20, (8,4):15, (12,12):10, (24,52):5, (60,380):1, (120,1140):1 |
| 7 | (4,1):56, (8,4):42, (12,12):28, (16,16):21, (24,52):14, (168,392):1, (336,14392):1 |

**A₄ cannot occur** as `H_S`: all its involutions lie in its normal `V₄`, so three conic
involutions in `A₄` generate only that `V₄`. The order-12 subgroups that occur are dihedral
`D₁₂`.

**Theorem 4.1** (order eight). A legal triple generating `H ≅ D₈` has residual conic graph
`a·M₈ ⊔ b·K₂` (`M₈` = 8-vertex Möbius ladder), so `𝒢 = a + b (mod 2)`.

*Proof.* `D₈ = ⟨r,s : r⁴=s²=1, srs=r⁻¹⟩`; its involutions are `r²` and the four reflections.
Three reflection matrices are projectively collinear (illegal triple), so a legal generating
triple is `{r², s, rs}` up to automorphism. On a free orbit its Schreier graph is
`Cay(D₈, {r², s, rs}) = M₈`; a non-free orbit's stabilizer is a cyclic 2-subgroup and, after
deleting `Fix` of the three pairwise products `r²s, r³s, r`, leaves one edge. `M₈` is
vertex-transitive and deleting `N[v]` leaves `P₄` (`𝒢(P₄)=0`), so `𝒢(M₈)=1=𝒢(K₂)`. ∎

**Theorem 4.2** (order-eight arithmetic — proven via split/nonsplit torus normal forms; the
mod-8 table follows from the square classes of `i` and `2` plus orbit counting):

| q mod 8 | (a, b, \|D\|) |
|---:|---|
| 1 | ((q−1)/8, 0, 2) or ((q−9)/8, 2, 6) |
| 3 | ((q−3)/8, 1, 2) |
| 5 | ((q−5)/8, 1, 4) |
| 7 | ((q+1)/8, 0, 0) or ((q−7)/8, 2, 4) |

**S₄** (tame, char ≠ 2,3): four conjugacy classes of generating triples, indexed by the
pairwise product orders, with conic-only Grundy:

| class | pair orders | Grundy value |
|---|---|---|
| A | 3,3,3 | 1 iff q ≡ 1,3 (mod 8) |
| B | 3,4,4 | 1 iff q ≡ 1,3 (mod 8) |
| C | 2,3,3 | 2 iff q ≡ 3,5 (mod 8) |
| D | 2,3,4 | 1 iff q ≡ 1,3 (mod 8) |

otherwise 0. The striking point: every **generic** 24-point `S₄` orbit has Grundy 0; only the
exceptional octahedral orbits `S₄/C₄, S₄/C₃, S₄/C₂` contribute.

**Orbit-template theorem** (unifies V₄, D₈, S₄; gives the route to `D₁₂, D₁₆, A₅`):
```
𝒢(R_T(Ω)) = ⊕_{[K]} (m_K mod 2) · 𝒢(R(H,K,T)),
```
reducing every fixed-subgroup position to a finite table indexed by point-stabilizer classes.
For tame `PGL₂` subgroups the stabilizers are cyclic, so values across finite fields are
congruence-periodic.

Full labelled-triple enumeration (not iso classes): q=3 → 68 legal / 3 P / max 𝒢 1; q=5 → 1980
/ 625 / 3; q=7 → 16408 / 6258 / 4; q=11 → 265980 / 109175 / 5. Generic triples generate all of
`PGL(2,q)` (max Grundy grows), so this is not a full-game solution — the exact families are the
small-subgroup rows.

## 5. Strengthened drain bound

The closed-neighbourhood deletion identity is generic Node-Kayles; the geometric quantitative
content is an edge lower bound. With `k` centres, `d` unavailable conic points `D`, and `f_x ≤ 2`
fixed points of `σ_x` (matching size `(q+1−f_x)/2`), and distinct colours never sharing a live
edge:
```
|E(G[C \ D])| ≥ Σ_{x∈S} max(0, (q+1−f_x)/2 − d),
```
so a live move exists with drain ≥ `1 + ⌈ (2/(q+1−d)) Σ_x max(0, (q+1−f_x)/2 − d) ⌉`. This is
existence, not minimax; a viable potential must track live vertices **and** live coloured edges.

## 6. Independent verification (field geometry)

`rust/scripts/c80_schreier_verify.py` classifies `PrimeGridGame` off-conic centre-triples by
`H_S`, builds the residual (remove `D(S)`, keep isolated live vertices), and computes
per-component Node-Kayles Grundy — independent of the abstract-group template and the standalone
`XZ=Y²` enumerator. Results:

- **V₄** (order 4): components are `K₄` (n4e6); Grundy = `#K₄` parity, matching Cor 3.2 at
  q = 11, 13, 17, 19.
- **D₈** (order 8): components `M₈`(n8e12) ⊔ `K₂`; matches Thm 4.2 including the q≡1 **mixed**
  branch (both `(2,0,2)` Grundy-0 and `(1,2,6)` Grundy-1 present at q=17).
- **S₄** (order 24): the four classes reproduce the §4 table **12/12** across q ≡ 1,3,5 — in
  particular the flip A,B,D: 1 (q≡1,3) → 0 (q≡5,7), confirmed at q=13 vs q=11/17/19.
- order-12 rows are `D₁₂` (mixed Grundy), consistent with A₄ excluded.

Nothing disagrees.

## 7. Next programme

1. **Larger dihedral / polyhedral rows.** `D₁₂, D₁₆, A₅` via the orbit-template theorem — a
   finite catalogue of Cayley components + truncated non-free orbits.
2. **Trace classifier.** Index triples by `tr(A_x A_y)²/(det A_x det A_y)` and the triple
   invariant; test whether these predict subgroup type and residual Grundy.
3. **Minimax potential.** Combine live-vertex count with the coloured-edge bound (§5); test
   whether a player can force entry into an exact small-subgroup family.
4. **The escape connection** (companion note): the odd-plane escape crux is size-3 → size-4, i.e.
   `H_S` generated by ≤3 involutions — the small-subgroup regime this catalogue covers. The gap
   is conic-only vs full value, which is exactly the `(ON)` conjecture. `Schreier + (ON)` is the
   synthesis; the measurement that gates it is classifying the actual escape-crux states by `H_S`.
5. Only then revisit RSA/MDS analogies — neither presently contributes to the game theorem.

## 8. Reproduction and references

```bash
# field-geometry cross-check (this repo)
python3 scripts/c80_schreier_verify.py 11 13
python3 scripts/c80_schreier_verify.py 13 17 19 --full-max 13 --sample 80000
# standalone enumerator + abstract subgroup templates
python3 scripts/three_centre_probe.py 3 5 7 11
python3 scripts/three_centre_probe.py --group-orders 3 5 7
python3 scripts/schreier_templates.py 3 5 7 11 13 17 --s4
```

Prior art: Huggan–Huntemann–Stevens, *Nofil on Steiner Triple Systems*
(arXiv:2103.13501) — the general Nofil → Node-Kayles reduction. Kobayashi, *On Structural
Parameterizations of Node Kayles* (arXiv:2003.11775) — tractability targets for the residual
graphs. A targeted search found no direct precedent for the conic-involution `PGL(2,q)` Schreier
positions; the possible novelty is the fixed-point-deletion rule combined with the explicit
Node-Kayles template classifications, not the classical ingredients individually.
```
