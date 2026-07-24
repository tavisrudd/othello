# Gateway lane — archive (append-only)

History and distilled provenance for the `gateway` lane. The live map is
`notes/handoffs/2026-07-24-gateway.md`. This file exists so the source documents need not be
reopened: each section below distills the parts of a prior document that the lane's work depends on.

## 2026-07-24 — lane created

Created from a cross-lane cold read of the three published/in-flight geometry-coding manuscripts
plus a review of the gateway-object notes and the `ame-lu` lane, after the user asked whether the
cross-avatar unification is a new paper or a shared thread and, if a lane, what to call it. The
answer that produced this lane: the unifying object is a *thread* already split by mechanism across
existing papers; the genuinely new content is the **field-dependence contrast** (sporadic incidence
and module avatars beside a uniform quantum avatar), which is worth its own exploration lane before
any manuscript decision. Reserved block C584–C589 (ledger `notes/codex-task-id-allocations.json`).

## Distilled: the three geometry-coding manuscripts

**Shared dictionary (identical across all three, cited to the same sources — Davydov–Marcugini–
Pambianco 2021, Kaipa 2017, Storme–Thas NRC/GRS).** For a redundancy-`r` MDS code the parity-check
columns are a projective arc / normal rational curve; a syndrome's coset distance is the least
number of columns whose span contains it; the deep holes are the directions on no `(r−2)`-secant. So
the uncovered locus of an arc *is* the deep-hole syndrome locus. One Lean library serves all three.

**`arcs` (redundancy three, general field).** Central result is the prescribed-hole defect identity
`m·Δ = Σ_{x}(r(x)−1)(m−r(x)) + Σ_{y}r(y)(m−r(y))`, from splitting the two classical secant moments
over a hole set; equality is a `MATCH(k,m,1)` matching design realized in rank three (ten-point case
forced to the `PG(2,8)` regular hyperoval). Reconstruction: `U(A)=U(B) ⟹ A=B` and
`Stab(U(A))=Stab(A)` when `q+1 > C(k,2)` — the uncovered locus is a parent fingerprint. Exact
values `ρ_C(5)=4`, `ρ_C(16)=9` (the latter by a certified quadratic-avoidance covering list). Owns
the `q=11` deep-holes = conic identification for publication.

**`clebsch-rigidity` (redundancy three, `q=11`).** Rigidity TFAE: `U(A)` on some conic ⟺ `U(A)` =
all `F_11`-points of a nonsingular conic ⟺ `A` PGL-equivalent to the Clebsch hexagon ⟺
`Stab(A) ⊇ A_5` — `A_5` recovered from a coding hypothesis, via the six-arc line bound
(`≤ q−5` per line), the chord-defect identity, and Dye's Brianchon bound `c ≤ 10`. Low-degree
strengthening: a form of degree ≤ 3 contains `U(A)` iff Clebsch (cubic evaluation rank 10 for
non-Clebsch, 7 for Clebsch); degree four is sharp. Why `q=11`: `c(A)=(q−6)(q−9)` with `0 ≤ c ≤ 15`
gives `q ∈ {4,5,9,11}`; `q=9` excluded by the Sylvester graph (`eq_2` clique number five). Family
formula `|U(K)| = q²−14q+45`; off-conic excess `(q−4)(q−11)` for `q ≡ 3 (mod 4)` isolates `q=11`
(at `q=19` the configuration persists with 140 deep holes on no conic).

**`beyond4_prs` (redundancy five and up, full curve).** Deep holes of `PRS(q+1−r)` via a
characteristic-free Hankel / apolar system `W_f`. At redundancy five: persistent tangent and
conjugate-secant families (the latter parameterized by the norm-one torus `T/T^{r−1}` mod inversion
and Frobenius) plus sporadic `PGL_2(q)`-orbits exactly at `q ∈ {7,8,9,11,13,17,19}`. Coherent polar
flags (marked contractions retaining the removed point) push classification to redundancies six and
seven; the `S_3`-monodromy branch produces an arithmetic-genus-one fiber-square curve controlled by
the singular-curve Weil bound (Aubry–Perret), split for `q ≥ 23`. Char-two ordered Hessian and
power-of-two Lucas arithmetic handle the modular carriers. The `r=3` specialization of this
framework is degenerate (the conjugate-secant family is empty), which is why `q=11` is *the*
exception at `r=3` but only one of seven sporadic fields at `r=5`.

## Distilled: Modular Gateway Theorem (C474)

Seven-gate recognition theorem. Gates: (1) semisimple line `|Ω| ≠ 0` in `k`; (2) cross-code
`D = k1 ⊕ S`, `S = D^⊥`; (3) augmentation has no equivariant retraction; (4) local Picard —
`dim S ≠ 0` in `k`, trace-zero `End(S)` projective on a Sylow; (5) fusion-descent line is
one-dimensional; (6) simple-core — `S`, `S*` nonisomorphic simple; (7) rigidity — both endpoint
endomorphism rings equal `k`. Conclusions: shared-code and disjoint-code recovery agree on `S`; `S`
is a simple stable Lagrangian and an invertible object of `stmod(kG)`; the augmentation is the
unique nonsplit extension; the carrier is a brick / Picard-graded cone; the unpointed groupoid
forgets scalar orientation. Chain: `cross-design → perfect code → endotrivial core → unique
augmentation carrier`.

Two proved realizations: `q=7` over `F_2` — binary Hamming `[7,4,3]`, `dim(S,D,A)=(3,4,6)`,
nonsplit rank gap `18<19`, local `H^1` dimension two on `D_8`, unpointed groupoid a point; `q=11`
over `F_3` — ternary Golay `[11,6,5]`, `dim(S,D,A)=(5,6,10)`, gap `50<51`, local `H^1` dimension one
on `C_3`, unpointed groupoid `B(C_2)`. Boundary `q=23`: binary Golay supplies the analogous
11-dimensional endotrivial core, but `PSL_2(23)` has no index-23 subgroup, so no degree-23
permutation sheet realizes the geometric packaging — the carrier extends where the geometry does
not. Deliberately a two-case-plus-boundary theorem, not all-field.

## Distilled: the `ame-lu` lane (quantum avatar)

Same six-arc / MDS / CSS / AME dictionary, quantum layer added. Headline (C560/C561, frozen): for
equal-phase CSS states of every linear `[6,3,4]_q` MDS code over every prime power, LU-equivalence
coincides with LC-equivalence — via MDS-shortening to a `q²` stabilizer whose nonidentity
correlation tensor is diagonal on the full local Weyl basis, forcing every local action to permute
Weyl axes (hence Clifford). Uniform across all `q`. The exceptional `H_3`/Clebsch state separates
from every six-point GRS state (C374); C562 records the novelty boundary (Rains / Van den Nest
mechanism credited, exact `q²−1` Weyl-axis scope stated with "to our knowledge"); C580 adds a
growing packet of scalar-LU-blind but marginal-covariant-separated classes. This is the avatar whose
rigidity is field-uniform, sitting beside two field-sporadic avatars.

## Distilled: gateway-objects search map (2026-07-20 brainstorm)

Definition and six usefulness criteria (reversible presentations; small forgotten decoration;
intrinsic carrier; exceptional parameter; operational endpoint; cheap falsifier). Ranked candidate
carriers, by field: `q=7` — B3 matching sheets → Fano anti-flags / 28 bitangents → Hoggar SIC (best
operational endpoint, three-qubit tomography); `q=11` — the self-dual regular 11-cell and the
`2-(11,5,2)` biplane (cleanest structural inevitability); `q=19` — the 57-cell and Perkel geometry,
`|PSL_2(19)|/|A_5| = 57` (best chance of turning the `q=19` boundary into a second theorem member);
the doily `GQ(2,2)` (six labels, outer-`S_6`, two-qubit Paulis); Paley/Hadamard/ternary-Golay
completions; an independent Hesse–Burkhardt characteristic-three basin. Bounded novelty check on the
top three found the unmarked carriers all classical (Stacey; Leemans–Schulte; Monson–Schulte;
Xiao–Zhang–Zhang); what survives is transport of the *marked* decoration or operational statistic.
Overall lesson: further gateways live in the exceptional biplane / self-duality sequence at
`q = 7, 11, 19`, not in unrelated exceptional names. Not a priority audit — any claim needs its own.

## Distilled: cross-paper incidence agenda (2026-07-15)

Unifying question for `arcs`/`clebsch`/`repaircodes`/`baer`: when a code invariant records a
complete incidence *pattern* rather than only its cardinality, what forces the pattern rigid locally
and transportable globally? Structural questions retained for this lane: a common
capacity-minus-locus defect identity; low-degree containment forcing a large automorphism group;
census-to-invariant-theory replacement. Named highest-value bridge there: an orbit-valued transfer
statement. The gateway lane is the natural home for the cross-avatar half of that agenda.

## Distilled: cold-read synthesis and the torus negative (2026-07-24)

Four themes tie the geometry-coding papers: one shared object (the deep-hole locus); one shared
dictionary; rigidity (pattern forces uniqueness and symmetry); arithmetic factorization isolating
the exceptional field. Reading also produced a decisive negative used to aim this lane: the naive
"`A_5` is the `r=3` instance of `beyond4`'s persistent torus family" does not typecheck — Clebsch is
a short length-six non-GRS code while the torus family is on the full length-`(q+1)` curve and is
empty at `r=3`. Clebsch's real cousin is `beyond4`'s sporadic orbits. Hence the lane's spine is
sporadic-vs-uniform field-dependence, not a torus specialization.
