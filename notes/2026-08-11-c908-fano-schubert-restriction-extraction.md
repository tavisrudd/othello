# C908 — Fano surface of lines: Schubert restriction, incidence, and span-map literature extraction

**Date**: 2026-08-11
**Task**: C908 support extraction. No `C908` row was found in
`notes/2026-07-07-codex-task-queue.md` or its archive at extraction time, so no lane peg is
asserted here; the owning lane's handoff should record it.
**Kind**: literature extraction (background + anchors), recorded under
`notes/literature-audit-conventions.md`.

## Opening summary

This report extracts the classical cohomology data of the Fano surface of lines on a smooth
cubic threefold, with exact loci, and records for each item whether the statement is integral
or only rational, and whether it holds for every smooth cubic threefold or only the very
general one.

**Read-depth summary.** Twelve sources are named below. **None was read at `full text`.**
Seven were read at `partial` depth, over exactly the sections named in the Consulted-sources
table: Clemens–Griffiths (Ann. of Math. 1972), Roulleau (arXiv:0804.1861), Roulleau
(arXiv:1001.4855), Voisin (arXiv:2212.03046), Bayer–Beentjes–Feyzbakhsh–Hein–Martinelli–
Rezaee–Schmidt (arXiv:2011.12240), Li–Lin–Pertusi–Zhao (arXiv:2406.09124), and Krämer
(arXiv:1501.00226). The remaining five are `secondary only`, `abstract/metadata only`, or
`not accessed`. Every load-bearing formula in §A–§C rests on one of the seven `partial` reads,
and every quoted formula was checked against the extracted page text of the cached bytes,
never from memory.

**Coverage gap carried forward**: Huybrechts, *The Geometry of Cubic Hypersurfaces*
(Cambridge 2023) — the single best modern reference for §A — is NOT in the shared cache. See
"Gaps and negatives".

### Fixed notation (used throughout; a dictionary to each source's notation is given per item)

- `X ⊂ P^4` a smooth cubic threefold over `C`; `F = F(X)` its Fano surface of lines.
- `F ⊂ Gr(2,5)` the Plücker/tautological embedding (lines in `P^4` = 2-planes in `C^5`).
- `S` the tautological rank-2 subbundle of `O^{⊕5}` on `Gr(2,5)`, `Q` the rank-3 quotient.
- `σ_1 = c_1(S^∨)`, `σ_{1,1} = c_2(S^∨)`, `σ_2 = c_2(Q)` the Schubert classes.
- `J = J(X)` the intermediate Jacobian (ppav, `dim 5`), `Θ` its theta divisor.
- `a : F → J` the Albanese embedding, normalized so `[a(F)] = Θ^3/3!` in `H^6(J,Z)`.
- `C_s ∈ H^2(F,Z)` the incidence divisor class (lines meeting a fixed general line `s`);
  `a^*Θ = 2 C_s`.
- `ψ : F×F → J`, `ψ(ℓ,ℓ') = a(ℓ') − a(ℓ)` the difference map.

**Notation dictionary for Clemens–Griffiths** (the dominant source below): their `V` = our
`X`; their `S` = our `F` (careful: their `S` is the *surface*, not a bundle — where the
tautological bundle is meant this report always writes `S` in bundle context and says so);
their `D_s` = our `C_s` (incidence divisor of a line `L_s`); their `D_K` = the divisor of
lines meeting a fixed plane `K ⊂ P^4`, i.e. the Plücker hyperplane section `σ_1|_F`; their
`J(V)` = our `J`; their `Ω_V` = our `Θ` (polarizing class); their `Φ` = our span map `g`;
their `D`/`𝒟` = the dual (Gauss) map `P^4 → (P^4)^∨`, `x ↦ T_x X`. Their difference map
`ψ(s_1,s_2) = φ(α_S(s_1) − α_S(s_2)) = a(s_1) − a(s_2)` is our `ψ` **with the two legs
swapped**; nothing in this report depends on that, because every formula derived here is
invariant under the swap (see the sign note at the end of B1).

---

## A. Tautological restriction to F

### A1. `c_1(S^∨)|_F = K_F = 3 C_s`

**Anchor 1 (Plücker = canonical).** Clemens–Griffiths, *The intermediate Jacobian of the
cubic threefold*, Ann. of Math. (2) 95 (1972), §10, **Proposition 10.3**, p. 324:

> "PROPOSITION 10.3. For a plane `K` in `P^4`, `D_K` is a canonical divisor on `S`."

with `D_K = {s ∈ S : L_s ∩ K ≠ ∅}` defined immediately above, and the preceding sentence
"Each `K` determines a hyperplane section of `Gr(2,5)` under the standard Plücker embedding
`(10.1) Gr(2,5) ⊂ P^9`". So `D_K` *is* the restriction of the Plücker hyperplane class, i.e.
`σ_1|_F`.

**Status**: this is an identity of *divisors up to linear equivalence*, i.e. in `Pic(F)` —
strictly stronger than "modulo torsion" in `H^2(F,Z)`. Holds for every smooth `X` (the
running hypothesis of §10 is "`V` will be a nonsingular cubic threefold").

**Dictionary**: their `D_K = σ_1|_F`; their `K_S` = our `K_F`. Hence `σ_1|_F = K_F` in
`Pic(F)`.

**Anchor 2 (the factor 3).** Same paper, **(10.9)**, p. 326:

> "Picking a plane `K` such that `(K · V) = L_{s_1} + L_{s_2} + L_{s_3}` (`s_i ≠ s_j` for
> `i ≠ j`), we have `(10.9) D_K ∼ D_{s_1} + D_{s_2} + D_{s_3}`"

("`∼`" is CG's own symbol for linear equivalence; they say so in the next line: "where '`∼`'
denotes linear equivalence.").

**Status**: `K_F ∼ C_{s_1} + C_{s_2} + C_{s_3}` in `Pic(F)` for the three lines of a
tritangent plane. Passing to `H^2(F,Z)`: the `{D_s}_{s∈S}` form an *algebraic* family
(CG Lemma 10.4 / (2.6): "The algebraic family of divisors `{D_s}_{s∈S}` will be called the
family of incidence divisors on `S`"), `F` is connected, so all `[C_s]` coincide in
`H^2(F,Z)`. Therefore

> `K_F = 3 C_s` **exactly in `H^2(F,Z)`, torsion included** — not merely modulo torsion.

This is stronger than the "expected shape (modulo torsion)" in the task statement. The
strengthening is my own inference from CG (10.9) + the algebraic-family statement; CG do not
write `K_F ≡ 3D_s` as a displayed formula. In `Pic(F)` the equality is only up to the
difference `C_{s_1}+C_{s_2}+C_{s_3} − 3C_s`, which lies in `Pic^0(F) = J` and is generally
nonzero — so the *linear*-equivalence statement `K_F ∼ 3C_s` is FALSE in general and must not
be quoted; only the homological one holds.

**Anchor 3 (the tangent-bundle theorem: why `S^∨|_F ≅ Ω^1_F`).** Same paper, §12, diagram
**(12.4)**, p. 338 (called there "the central geometric fact of the paper"):

> "there is a commutative diagram `S → α_S(S)`, `↓ ε`, `↓ 𝒢`, `Gr(2,5) ≅ Gr(2, T(Alb(S),0))`
> where `ε` is the standard inclusion of `S` (see (7.1))"

with `𝒢` the Gauss map `(12.3)` of the Albanese image `α_S(S) ⊂ Alb(S)` sending `u` to
`T(α_S(S) − u, 0)`. Since the Gauss map's tautological pullback is the tangent bundle, this
says `S|_F ≅ T_F`, equivalently

> `S^∨|_F ≅ Ω^1_F`  (tangent bundle theorem).

CG state the weaker projective form as **Lemma 12.5** ("There is an automorphism `σ` of `P_9`
such that `(d∘𝒢∘α_S) = (σ∘d∘ε)`") and the full (12.4) is proved twice in §12. All smooth `X`.

This is the structural reason the three-line item A1–A2 is forced: `c_1(S^∨)|_F =
c_1(Ω^1_F) = K_F` and `c_2(S^∨)|_F = c_2(Ω^1_F) = c_2(F)`.

Consistency check, CG **Lemma 10.13**, p. 326: "The Plücker embedding `S ⊂ Gr(2,5) ⊂ P_9` is a
canonical embedding of `S`" — so `σ_1|_F = K_F` is very ample and `h^0(K_F) = 10`.

### A2. `c_2(S^∨)|_F = 27`, `c_2(Q)|_F = 18`

**`∫_F σ_{1,1}`.** By the tangent-bundle theorem (A1, Anchor 3), `σ_{1,1}|_F = c_2(Ω^1_F) =
c_2(T_F) = c_2(F) = χ_top(F)`. Clemens–Griffiths, §10, p. 326:

> "We have already seen that the second Chern number `c_2[S] = 27` in (9.14)."

So `∫_F σ_{1,1} = 27`. Integral (a Chern number). All smooth `X`.

**`∫_F σ_2`.** On `Gr(2,5)`, `σ_1^2 = σ_2 + σ_{1,1}`, so `∫_F σ_2 = ∫_F σ_1^2 − ∫_F σ_{1,1}
= 45 − 27 = 18` using A3 below. Integral. All smooth `X`. (Derivation mine; the Schubert
relation `σ_1^2 = σ_2 + σ_{1,1}` is Pieri on `Gr(2,5)` and is not taken from any source read
here.)

**Expressibility as a multiple of `C_s`**: `H^4(F,Z) ≅ Z` is generated by the point class, so
`σ_{1,1}|_F` and `σ_2|_F` are just the integers 27 and 18; there is no "multiple of `C_s`"
question at this degree beyond `C_s^2 = 5` (A3), and 27 and 18 are not multiples of 5 — the
classes `σ_{1,1}|_F, σ_2|_F` are NOT in `Z·C_s^2`.

### A3. Intersection numbers and topological invariants

All from Clemens–Griffiths §10, pp. 325–326, in their numbering:

| Ours | CG statement | CG locus | Status |
|-----------------|--------------------------------------------------|--------------|-------------------|
| `C_s^2 = 5` | "`({D_s}·{D_s})_S = 5`" | (10.8), p. 326 | integral; all smooth `X` |
| `g(C_s) = 11` | "`genus (D_s) = 11`" | (10.10), p. 326 | integral; generic `s` (CG Lemma 10.5: `D_s` nonsingular for generic `s`) |
| `χ_top(F) = c_2 = 27` | "`c_2[S] = 27` in (9.14)" | §10 p. 326, from (9.14) | integral; all smooth `X` |
| `K_F^2 = σ_1^2[F] = 45` | "`c_1^2[S] = ({D_K}·{D_K})_S = 45`" | (10.11), p. 326 (the OCR of the cached scan misprints the left side as `c_2[S]`; the sentence before it reads "To get the first Chern number, use Proposition 10.3") | integral; all smooth `X` |
| `p_g = h^{2,0}(F) = 10` | "`h^{2,0}(S) = 10`" | (10.12), p. 326, from `12(h^0 − h^{1,0} + h^{2,0}) = c_2 + c_1^2` | all smooth `X` |
| `q = h^{1,0} = 5`, `b_1 = 10` | "`dim Alb(S) = 5`" (§11, after (11.1)) and `χ(S) = 27 = 2 − 2β_1 + β_2` | §11 p. 329; §10 (10.14) p. 326 | all smooth `X` |
| `b_2 = 45` | "Since `χ(S) = 27 = (2 − 2β_1 + β_2)` … `β_2 = 45`" | just after (10.13)/before (10.14), p. 326 | integral; all smooth `X` |

Note the arithmetic CG rely on: `2 − 2·10 + 45 = 27`. Consistency: `K_F^2 = 45 = 9·5 = 9C_s^2`
matches `K_F = 3C_s` from A1, and `C_s·K_F = 3C_s^2 = 15`. CG do not display `C_s·K_F` as such;
`15` is my arithmetic from (10.8)+(10.9).

Degree of `F` in the Plücker embedding = `∫_F σ_1^2 = 45`, which is CG (10.11) read as a
degree; CG do not use the word "degree" there.

### A4. `[F] ∈ H^8(Gr(2,5),Z)` in the Schubert basis

**Anchor status: DERIVED, no literature anchor obtained.** See "Gaps and negatives" — the
natural anchors (Huybrechts' book §2.x, Altman–Kleiman) were not reachable in the cache.

`F` is the zero locus of the section of `Sym^3 S^∨` induced by the defining cubic, so
`[F] = c_4(Sym^3 S^∨)`. With Chern roots `x,y` of `S^∨` (`x+y = σ_1`, `xy = σ_{1,1}`),
`Sym^3 S^∨` has roots `3x, 2x+y, x+2y, 3y`, so

    c_4(Sym^3 S^∨) = 9xy(2x+y)(x+2y) = 9σ_{1,1}(2σ_1^2 + σ_{1,1})
                   = 18 σ_1^2 σ_{1,1} + 9 σ_{1,1}^2
                   = 18 σ_{3,1} + 27 σ_{2,2},

using Pieri `σ_{1,1}σ_2 = σ_{3,1}`, `σ_{1,1}^2 = σ_{2,2}`, `σ_1^2 = σ_2 + σ_{1,1}`.

Cross-check against A2/A3 by Schubert duality on `Gr(2,5)` (`σ_{3,1}` dual to `σ_2`,
`σ_{2,2}` dual to `σ_{1,1}`):
`∫_F σ_2 = 18` ✓, `∫_F σ_{1,1} = 27` ✓ (= CG's `c_2[S] = 27`), `∫_F σ_1^2 = 18+27 = 45` ✓
(= CG (10.11)). The three independent CG numbers therefore *confirm* the derived class.

**Status**: integral in `H^8(Gr(2,5),Z)`; all smooth `X` (indeed all `X` with `F` of expected
dimension, by the standard excess-free zero-locus argument).

### A5. Integral structure of `H^*(F,Z)`

**A5.a — `H^*(F,Z)` is torsion free. FOUND, with a definite statement.**

Voisin, *Cycle classes on abelian varieties and the geometry of the Abel–Jacobi map*,
arXiv:2212.03046v4, §3, **Remark 3.8** (her `Σ` = our `F`):

> "Remark 3.8. The integral cohomology of `Σ` is torsion free (see [4]), so the `δ_{i,Σ}` are
> well defined."

Her `[4]` is **A. Collino, "The fundamental group of the Fano surface. I, II", in Algebraic
threefolds (Varenna 1981)** — read here at `secondary only` depth, through Voisin. Collino's
paper is not in the shared cache and was not obtained; the torsion-freeness claim therefore
rests on Voisin's citation of it, not on Collino's own text.

**Status**: integral; stated by Voisin for *the* Fano surface of a smooth cubic threefold with
no genericity hypothesis, i.e. all smooth `X`.

Consequence used repeatedly below: `H^2(F,Z)_f = H^2(F,Z)`, `H^3(F,Z) ≅ H_1(F,Z) ≅ H^1(F,Z)^∨`
is free of rank 10, and Poincaré duality over `Z` is available in every degree.

**A5.b — `a^* : H^1(J,Z) → H^1(F,Z)` is an isomorphism. FOUND.**

Clemens–Griffiths §11 is devoted to exactly this. The chain is:
**Lemma 11.2** (p. 329) "`φ : Alb(S) → J(V)` is an isogeny" (attributed to Gherardelli),
**Lemma 11.6** (p. 331) "Let `χ : J(V) → Pic(S)` be as in (4.3). Then `χ` is an isogeny and
`deg(χ) = deg(φ)`", and the section's conclusion, announced in the introduction as
**(0.8)**, p. 285: "(Abel's theorem and the Jacobi inversion theorem). In the diagram (0.6),
all three mappings are isomorphisms." So `Alb(F) ≅ J` as ppav, hence `a^*` is an isomorphism
`H^1(J,Z) ≅ H^1(F,Z)` and dually on `H_1`. Integral; all smooth `X`.

Modern restatement in the notation used here: Voisin, arXiv:2212.03046v4, (32): "the universal
line `P ⊂ Σ × X` induces an embedding `j = Φ_X ∘ P_* : Σ → J^3(X) = J` and an isomorphism
`P_* = j_* : Alb(Σ) → J`", cited there to `[3]` = Clemens–Griffiths.

**A5.c — `a^*Θ = 2C_s`, integrally. FOUND (two independent statements).**

Clemens–Griffiths, **Lemma 11.27**, p. 336:

> "LEMMA 11.27. On `S`, the Poincaré dual of `{D_s}` is the class
> `(1/2)(Σ_{k=1}^{5} ξ_k ∧ ξ_{5+k})`"

(the `ξ`'s are the basis of `H^1(J(V))` fixed in Prop. 13.1 by `Ω_V = Σ_{k=1}^5 ξ_k ∧
ξ_{5+k}`). That is `C_s = (1/2) a^*Θ`, i.e. `a^*Θ = 2C_s`.

Voisin, arXiv:2212.03046v4, **(38)** (proof of Lemma 3.7), citing `[3]` = Clemens–Griffiths:

> "We know by [3] that the class `l ∈ H^2(Σ,Z)` of the curve `C_Δ ⊂ Σ` of lines meeting a
> given line `Δ ⊂ X` satisfies `(38) 2l = j^*θ`, where `θ ∈ H^2(J,Z)` is the class of a
> Theta-divisor."

Voisin states this **in `H^2(Σ,Z)`**, i.e. integrally. All smooth `X`. Note this is a
*homological* identity; the divisor class `C_s` itself depends on `s`, only its cohomology
class does not.

**A5.d — `H^2(F,Z) / a^*H^2(J,Z) ≅ Z/2`, i.e. index two. FOUND — this is the literature
anchor the repo corpus was missing.**

Roulleau, *Fano surfaces with 12 or 30 elliptic curves*, arXiv:1001.4855, §1 (the paragraph
proving part b) of his first proposition), p. 5 — his `S` = our `F`, `A` = `Alb(S)` = our `J`,
`ϑ` = our `a`, subscript `f` = "modulo torsion":

> "By duality, this yields:  `0 → H^2(A,Z) --ϑ^*--> H^2(S,Z)_f → Z/2Z → 0`.
> As the spaces `H^{1,1}(A)` and `H^{1,1}(S)` have dimension 25 (see [5]), we have
> `ϑ^*(H^{1,1}(A)) = H^{1,1}(S)`. This implies that the sequence
> `0 → NS(A) --ϑ^*--> NS(S) → Z/2Z` is exact. This sequence is exact on the right also because
> `ϑ^*Θ = 2C_s` by Lemma 11.27 of [5] (`Θ` is a principal polarization, it is not divisible by
> 2, hence the class of `C_s` and `ϑ^*NS(A)` generate `NS(S)`)."

His `[5]` is Clemens–Griffiths, and the Lemma 11.27 he cites is exactly the one transcribed in
A5.c. His `[6]`, supplying the input exact sequence "By [6], 2.3.5.1", is Collino's
fundamental-group paper.

**Reading.** Combining with A5.a (`H^2(F,Z)_f = H^2(F,Z)`):

> `a^* : H^2(J,Z) → H^2(F,Z)` is injective with cokernel exactly `Z/2`, and
> `H^2(F,Z) = a^*H^2(J,Z) + Z·C_s`, with `C_s` the class generating the quotient.

**Status**: integral. Roulleau's derivation of the *exactness on the right* only uses
`ϑ^*Θ = 2C_s` and the non-divisibility of a principal polarization, so it holds for every
smooth `X`. The `NS`-level corollary `0 → NS(A) → NS(S) → Z/2 → 0` likewise holds for all
smooth `X`; the *further* statement he draws two paragraphs later, "`ρ_A = 1` for a generic
Fano surface" (so `NS(J) = ZΘ` and `NS(F) = ZΘ ⊕ ...` collapses to rank 1 generated by `C_s`),
is a **very general** statement only.

Contrast with the rational-only classical statement, Clemens–Griffiths **(10.14)**, p. 326:

> "(10.14) The natural map `(H^1(S_V) ⊗ Q) ∧ (H^1(S_V) ⊗ Q) → H^2(S_V) ⊗ Q` is an isomorphism."

CG state this **only with `Q` coefficients**. A5.d is precisely its integral refinement, and
the refinement is *not* an isomorphism — the cokernel is `Z/2`.

**A5.e — `H^3(F,Z)` and `a^* : H^3(J,Z) → H^3(F,Z)`. PARTIAL; the key integral input is
classical, the conclusion is my own derivation.**

Literature input, Clemens–Griffiths **(13.2)**, p. 347 (restating (11.28), p. 337) — with
`{ξ_1,…,ξ_10}` a basis of `H^1(J(V))` such that `Ω_V = Σ_{k=1}^5 ξ_k ∧ ξ_{5+k}`, and `ξ_k`
also denoting its pullback to `S`:

> "`∫_{D_s} ξ_k ∧ ξ_{5+k} = 2` for `k = 1, …, 5`; `∫_{D_s} ξ_l ∧ ξ_k = 0` for other `l > k`."

Equivalently, for all `α, β ∈ H^1(F,Z) = Λ`:

    ∫_F  C_s ∪ α ∪ β  =  2 E(α,β),      E = the principal-polarization symplectic form on Λ.

**My derivation from this** (marked as the auditor's own): `H^3(F,Z) ≅ Hom(H^1(F,Z),Z)` by
Poincaré duality (legitimate over `Z` by A5.a), and under that identification the hard-Lefschetz
map

    C_s ∪ (·) : H^1(F,Z) → H^3(F,Z)

is the matrix `2E`, with `E` unimodular. Hence it is injective with

> **cokernel `(Z/2)^{10}`** — `C_s ∪ H^1(F,Z)` has index `2^10` in `H^3(F,Z)`.

A fortiori the "Lefschetz part" `a^*(Θ ∪ H^1(J,Z)) = 2C_s ∪ Λ` has index `4^10` in
`H^3(F,Z)`. Whether `a^* : H^3(J,Z) → H^3(F,Z)` is surjective therefore depends entirely on the
image of the **primitive** part `H^3(J,Z)_prim`, and I located **no source that settles this
integrally**. Voisin, arXiv:2212.03046v4, **Lemma 3.10** is the closest reachable statement and
it is a `2`-divisibility one in the other direction:

> "Lemma 3.10. The image of `j_* ∘ [Γ']_* : H_3(J,Z) → H_3(J,Z)` is contained in
> `2 j_* H_3(Σ,Z)`."

with the Hodge-theoretic input (her (41)) that `H^7(J,Q) = θ^2 ∪ H^3(J,Q)_prim ⊕ θ^3 ∪
H^1(J,Q)` has simple, mutually non-isogenous summands *because the Mumford–Tate group of
`H^1(J,Q)` is the full symplectic group* — i.e. a **very general** hypothesis, explicitly
flagged as "by assumption" in her proof. Carry that genericity forward if this branch is used.

---

## B. The incidence correspondence `I ⊂ F×F`

Definition used throughout, Clemens–Griffiths **(2.4)**, p. 290:

> "`I = (union of all components of dimension three of the set
> `{(s_1,s_2) ∈ (S×S) : (Z_{s_1} ∩ Z_{s_2}) ≠ ∅}`)"

with `Z_s = L_s` the line, and **(2.6)** `D_s = pr_2(({s}×S) ∩ I)`, "The algebraic family of
divisors `{D_s}_{s∈S}` will be called the family of incidence divisors on `S`."

Note carefully, Clemens–Griffiths **Lemma 10.7**, p. 326:

> "LEMMA 10.7. `L_s` is of second type if and only if `s ∈ D_s`."

Since the generic line is of the first type, **the diagonal `Δ` is NOT contained in `I`**;
`Δ ∩ I` is the curve `D ⊂ F` of lines of the second type. This is the fact that pins the sign
in B1.

And Clemens–Griffiths **Proposition 10.21**, p. 329 ("the result of Fano"), with (10.20)
`D ∼ 2D_K`:

> "PROPOSITION 10.21. The set `D` is of pure dimension one and, considered as a divisor on `S`,
> is linearly equivalent to twice the canonical divisor."

So `[D] = 2K_F = 6C_s`. Integral (linear equivalence). All smooth `X`.

### B1. The Künneth decomposition of `[I] ∈ H^2(F×F,Z)`

**No source read here displays this formula.** What follows is my derivation; every input is a
quoted literature statement, and the result is triply cross-checked in B2/C2 below.

Write `A = pr_1^*C_s`, `B = pr_2^*C_s`, and let

    P ∈ H^1(F,Z) ⊗ H^1(F,Z) ⊂ H^2(F×F,Z),
    P = Σ_{k=1}^5 ( pr_1^*ξ_k ∧ pr_2^*ξ_{5+k} − pr_1^*ξ_{5+k} ∧ pr_2^*ξ_k )

be the **polarization tensor**: the element of `Λ ⊗ Λ` corresponding to `id_Λ` under
`Λ ⊗ Λ ≅ Hom(Λ,Λ)` via `E`. `P` is symmetric under the factor swap.

1. **Legs.** `[I]|_{{ℓ}×F} = [C_ℓ] = C_s` and symmetrically, by CG (2.6). So the `(2,0)` and
   `(0,2)` Künneth components of `[I]` are `A` and `B`.
2. **Cross term is `c·P`.** The `(1,1)` component lies in `Λ⊗Λ ≅ End(Λ)` and is the class of
   the endomorphism `I_*` of `H^1(F,Z)`. It is a multiple `c·P` of the identity because
   Clemens–Griffiths, proof of **Lemma 11.6**, p. 331, identify the correspondence `I` (their
   `γ(S;T) = φ(S,S;I)`, (2.5) p. 290) with the composite of the two legs of the universal line
   and compute "`deg(γ) = |det E|`", `E` the polarization form, which their §11 conclusion
   forces to be `±1`. Hence `c^{10} = 1`, `c = ±1`. (For the very general `X` one can argue
   instead from Beauville's `Sp(10,Z)` monodromy, which makes `End_{mon}(Λ) = Z`; the CG route
   avoids the genericity.)
3. **Sign, from the diagonal.** Pulling back along `i_Δ : F → F×F` gives `i_Δ^*A = i_Δ^*B =
   C_s` and `i_Δ^*P = 2 Σ_k ξ_k ∧ ξ_{5+k} = 2 a^*Θ = 4C_s` (using A5.c). So
   `i_Δ^*[I] = (2 + 4c) C_s`. By CG Lemma 10.7, `Δ ⊄ I`, so `i_Δ^*[I] = [Δ · I]` is the class
   of an honest effective cycle: `c = −1` would give `−2C_s`, impossible. Hence **`c = +1`**,
   `i_Δ^*[I] = 6C_s`, and this equals `[D] = 2K_F = 6C_s` by CG Proposition 10.21 — the
   intersection `Δ·I` is the second-type curve `D`, **reduced**.

**Conclusion.**

    [I]  =  pr_1^*C_s + pr_2^*C_s + P              in H^2(F×F,Z),

    ψ^*Θ =  2 pr_1^*C_s + 2 pr_2^*C_s − P,

hence the clean identity

    ψ^*Θ  =  3 pr_1^*C_s + 3 pr_2^*C_s − [I]
          =  pr_1^*K_F + pr_2^*K_F − [I]
          =  K_{F×F} − [I],      i.e.   ψ^*O_J(Θ) ≅ ω_{F×F}(−I).

The expression for `ψ^*Θ` is elementary (`ψ = d ∘ (a×a)` with `d(x,y) = y−x`, and
`d^*Θ = pr_1^*Θ + pr_2^*Θ − P` on `J×J` by the theorem of the cube with `Θ` symmetric) plus
`a^*Θ = 2C_s` from A5.c.

**Note on the task's expected shape.** The predicted form
`[I] = ψ^*Θ − pr_1^*(αC_s) − pr_2^*(αC_s)` is **not** attainable: `[I]` and `ψ^*Θ` have
*opposite* signs on the `P`-leg, so no `α` works. The correct relation replaces `ψ^*Θ` by
`K_{F×F} − ψ^*Θ`, with `α = 3` (the canonical multiple), not `α = 1`.

**Status**: integral in `H^2(F×F,Z)` (all inputs are integral, and `H^*(F×F,Z)` is torsion-free
by A5.a and Künneth). All smooth `X`. **Sign convention**: `ψ(ℓ,ℓ') = a(ℓ') − a(ℓ)`; the
formula is invariant under swapping the legs because `P` is swap-symmetric and `Θ` is symmetric,
so the convention does not matter here.

**Consistency check 1** (leg restriction): `(3A + 3B − [I])|_{{ℓ}×F} = 3C_s − C_s = 2C_s =
a^*Θ` ✓, which is what `ψ|_{{ℓ}×F} = a − a(ℓ)` demands.
**Consistency check 2** (diagonal): `i_Δ^*(ψ^*Θ) = 2C_s + 2C_s − 4C_s = 0` ✓, as required
because `ψ|_Δ ≡ 0`.

### B2. `ψ : F×F → Θ` is generically finite of degree 6

**FOUND, classical, with three loci.**

Clemens–Griffiths, §13, p. 348 (after (13.3), `ψ(s_1,s_2) = φ(α_S(s_1) − α_S(s_2))`):

> "The pair `((s_1, s_2, …, s_6), (s'_1, s'_2, …, s'_6))` is known classically as a
> 'double-six' of lines on a cubic surface (see [18; page 7]). Since `dim ψ(S×S) = 4`, `ψ` is
> generically finite-to-one and, by what we have seen, `ψ` is generically at least six-to-one.
> But by Proposition 13.1, `ψ_*({S×S})` has as its Poincaré dual on `J(V)` the class `6Ω_V`."

followed by **Theorem 13.4**, p. 348:

> "THEOREM 13.4. `{Θ_S}` has as its Poincaré dual on `J(V)` the polarizing class `Ω_V`."

(and the six lines are produced two lines above: "there are five lines `t_2,…,t_6 ∈ S` such
that `L_{t_j}` is incident to both `L_{s_1}` and `L_{s'_1}`" — this is the same "five common
transversals" fact that gives `C_s^2 = 5`.) Also **Proposition 13.1**, p. 347:

> "PROPOSITION 13.1. `(φ ∘ α_S)_*({S})` has as its Poincaré dual on `J(V)` the class `(Ω^3/3!)`."

and the introduction **(0.10)**, p. 285:

> "(0.10) (Theorems of Riemann and Poincaré). The image variety `ψ^{(2)}(S×S)` coincides, up to
> translation, with `Θ_V`."

Modern restatements, both explicitly citing CG:
- Bayer–Beentjes–Feyzbakhsh–Hein–Martinelli–Rezaee–Schmidt, arXiv:2011.12240v2, **Remark 2.3**:
  "According to [CG72] the morphism `F × F → J(X)` that maps `(L,L') ↦ [L] − [L']` is
  generically a 6 to 1 cover of `Θ`." The same remark supplies the mechanism: "there are
  precisely six ways to write `D − H^2` as the difference of two lines" on a cubic surface.
- Li–Lin–Pertusi–Zhao, arXiv:2406.09124, **Example 5.7**: "In the general case that `S_{ℓ,ℓ'}`
  is a smooth cubic surface, there are exactly six ordered pairs of lines `(ℓ_i, ℓ'_i)` on
  `S_{ℓ,ℓ'}` such that `[ℓ_i − ℓ'_i] = [ℓ − ℓ']`. So the degree of the morphism `ẽ_{β,γ}` is 6."

**Status**: integral (a class identity `ψ_*[F×F] = 6[Θ]` in `H^2(J,Z)`). All smooth `X`.

Numerical consequence used in C2: by the projection formula,
`∫_{F×F} (ψ^*Θ)^4 = ∫_J Θ^4 ∪ ψ_*[F×F] = 6 ∫_J Θ^5 = 6 · 120 = 720`.

**Do not confuse with the other 6.** Roulleau, arXiv:0804.1861, §2.2 (just after Theorem 7):
"The cotangent map has degree 6: there are 6 lines through a generic point of `F`." That is the
6 lines of `X` through a general point of `X`, a different statement.

### B3. The incidence curve `C_ℓ ⊂ F`

All Clemens–Griffiths §10:

- **Lemma 10.4**, p. 325: "The family `{D_s}` is a family of ample divisors on `S`."
  (Via Corollary 2.12, "If `V` has Picard number = 1, then `D_s` is ample" — but Lemma 10.4 is
  stated unconditionally for the nonsingular cubic threefold.)
- **Lemma 10.5**, p. 325: "For generic `s ∈ S`, `D_s` is non-singular." The proof identifies the
  exception, **(10.6)**: `s'` is a singular point of `D_s` only if `L_{s'}` is of second type and
  "`L_s` lies in the plane `[𝒟(L_{s'})]` tangent to `V` along `L_{s'}`".
- **(10.8)**, p. 326: "`({D_s}·{D_s})_S = 5`", justified by "two skew lines in a non-singular
  cubic surface have exactly five common incident lines ([18; pages 3–5])". So `C_ℓ^2 = 5`.
- **(10.10)**, p. 326: "`genus (D_s) = 11`", by adjunction from Prop. 10.3 and (10.9).
  Roulleau, arXiv:0804.1861, **Proposition 9** restates it as *arithmetic* genus 11, valid for
  every `s`: "The incidence divisor `C_s` is ample, has self-intersection `C_s^2 = 5` and
  arithmetical genus 11. The divisor `3C_s` is numerically equivalent to a canonical divisor."
  (Roulleau cites "[4, Parag. 10]" = Clemens–Griffiths §10.) Note Roulleau says **numerically**
  equivalent — see the A1 caution: linear equivalence to `3C_s` is false in general.
- Smoothness of `I`, **Lemma 12.18**, p. 342: "`I` is non-singular except possibly at a finite
  set of points lying on the diagonal of `S×S`."

**Theta-divisor facts requested under "second symmetric product".** Two distinct things carry
that name in this literature and must not be conflated:

1. *Degenerate case.* Clemens–Griffiths **Introduction**, p. 285, on a cubic threefold `V_0`
   acquiring one ordinary double point: "The corresponding surface of lines `S_0` has an
   ordinary double curve `D_0` given by the lines on `V_0` which pass through the double
   point. … Furthermore the surface `S_0` has as its normalization the second symmetric product
   `D_0^{(2)}`" (`D_0` a nonsingular curve of genus four). This is CG §8–9, the plumbing model.
   It is a statement about the **nodal** degeneration, not about a smooth `X`.
2. *Singularity of `Θ`.* Bayer et al., arXiv:2011.12240v2, **Theorem 7.1**: "The moduli space
   `M_X(v)` is smooth and irreducible of dimension 4. More precisely, it is the blow up of `Θ`
   in its unique singular point. The exceptional divisor is isomorphic to the cubic threefold
   `X` itself, and parametrizes non-locally free sheaves in `M_X(v)`." So `Θ` is singular at
   exactly one point, with projectivized tangent cone `X` (hence multiplicity 3). This paper
   reproves Beauville's classical description; Beauville's own paper ("Les singularités du
   diviseur `Θ` …", Varenna LNM 947) was **not obtained** — see Gaps.

---

## C. The span map `g : F×F ⇢ (P^4)^∨`

### C1. The span map exists in the literature, twice, and is a *morphism* off the diagonal

**FOUND — and stronger than the task's framing.** The map is not merely rational away from the
incidence locus: it extends holomorphically *across* the incident locus, with an explicit
canonical value.

Clemens–Griffiths, §12, **Lemma 12.16**, pp. 341–342 (their `𝒟 = Φ_D : P_4 → P^*` is the dual/Gauss
map `x ↦ T_x V`, §5):

> "LEMMA 12.16. Let `(S×S)^0 = ((S×S) − (diagonal))`. For `(s,t) ∈ (S×S)^0` define:
> `Φ(s,t) = ([L_s] ∩ [L_t])`, the hyperplane spanned by `L_s ∪ L_t`, if `(L_s ∩ L_t) = ∅`;
> `= 𝒟(x)` if `{x} = (L_s ∩ L_t)` (see §5).
> Then `Φ : (S×S)^0 → P^*` is analytic."

So `g = Φ` is a **morphism on `F×F − Δ`**, and on the incidence locus off the diagonal its
value is the tangent hyperplane `T_x X` at the intersection point. That answers C3 outright.

Li–Lin–Pertusi–Zhao, arXiv:2406.09124, **Example 5.7**, p. 28, give the identical definition
in the moduli-theoretic setting (their `Y_3` = our `X`):

> "Denote by `P_{ℓ,ℓ'}` the projective subspace spanned by `ℓ` and `ℓ'` in `P^4` when
> `ℓ ∩ ℓ' = ∅`, or the tangent space of `Y_3` at `ℓ ∩ ℓ'` when `ℓ ∩ ℓ'` is a point. In
> particular, the space `P_{ℓ,ℓ'} ≅ P^3`. Denote by `S_{ℓ,ℓ'} := P_{ℓ,ℓ'} ∩ Y_3` and
> `ι : S_{ℓ,ℓ'} → Y_3` the embedding. … In other words, a general object in `M_σ^s(β+γ)` is of
> the form `ι_* O_{S_{ℓ,ℓ'}}(ℓ' − ℓ)`. **This induces a rational map from `M_σ^s(β+γ)` to
> `(P^4)^*` of degree 72.**"

Two independent sources therefore give the *same* canonical extension `ℓ ∩ ℓ' = {x} ↦ T_x X`.
Both are unconditional in `X` smooth.

**Factorization through the Gauss map of `Θ`.** Clemens–Griffiths, §13, **(13.6)**, p. 348: for
an appropriate choice of the isomorphism (12.2) there is a commutative diagram of rational maps

    S × S  --ψ-->  Θ_S ⊂ J(V)
      | Φ                | 𝒢
      v                  v
     P^*   ⊂-------  Gr(4, T(J(V),0))

"where `Φ` is as in Lemma 12.16", with `𝒢` the Gauss map (13.5) of `Θ_S`. So **the span map is
the Gauss map of the theta divisor composed with the difference map**. Since for a ppav the
Gauss map satisfies `𝒢^*O(1) = O_Θ(Θ)`, this gives `g^*O(1) = ψ^*O_J(Θ)` — the input to C2.

### C2. The class of `D_p = {(ℓ_1,ℓ_2) : p ∈ span(ℓ_1,ℓ_2)}` and the resolution of `g`

**No source read here displays this divisor class.** Negative recorded in "Gaps and negatives".
The following is my derivation, and it closes against **three independent literature numbers**.

By C1, `g^*O_{(P^4)^∨}(1) = ψ^*O_J(Θ)`, so on `F×F`

    [D_p]  =  ψ^*Θ  =  2 pr_1^*C_s + 2 pr_2^*C_s − P  =  K_{F×F} − [I]      (B1).

`g` is undefined only along `Δ`. Let `μ : Y = Bl_Δ(F×F) → F×F` with exceptional divisor
`E = P(N_{Δ/F×F}) = P(T_F)` — which by the tangent-bundle theorem (A1, Anchor 3; Roulleau,
arXiv:0804.1861, Theorem 7: "the triple `(P(T_S), π, ψ)` is the universal family of lines of
`F`") **is the universal line of `X`**. Then:

- `ψ|_Δ ≡ 0`, so `(ψ^*Θ)|_Δ = 0`, hence `μ^*(ψ^*Θ) · E = 0` and all mixed terms vanish.
- `E^4 = −∫_F s_2(T_F) = −(c_1^2 − c_2)(T_F) = −(45 − 27) = −18`, using A3.
- `∫_{F×F}(ψ^*Θ)^4 = 720` (B2).

Writing `g̃^*O(1) = μ^*(ψ^*Θ) − m E`, `deg(g̃) = 720 − 18 m^4`. The literature fixes `m`:
`F×F → M_σ^s(β+γ)` has degree 6 and `M_σ^s(β+γ) ⇢ (P^4)^*` has degree 72 (LLPZ Example 5.7,
quoted above), so `deg(g) = 6 · 72 = 432`, forcing

> **`m = 2`:  `g̃^* O_{(P^4)^∨}(1) = μ^*(ψ^*Θ) − 2E` on `Bl_Δ(F×F)`, and `deg(g) = 432`.**

Three independent confirmations of `m = 2`:

1. **Direct line count.** For general `h ∈ (P^4)^∨` the fibre `g^{-1}(h)` is the set of ordered
   pairs of **skew** lines on the smooth cubic surface `X ∩ h`. Each of the 27 lines meets
   exactly 10 others, hence is skew to 16, giving `27 · 16 = 432`. ✓
2. **Restriction to the exceptional divisor.** `g̃^*O(1)|_E = −2E|_E = 2ξ` (`ξ = c_1(O_{P(T_F)}(1))`),
   so `∫_E (g̃^*O(1)|_E)^3 = 8 s_2(T_F) = 8 · 18 = 144`. Independently, `E` is the universal
   line, which maps 6:1 to `X` (Roulleau, arXiv:0804.1861 §2.2: "there are 6 lines through a
   generic point of `F`") and then birationally to the dual `X^∨` of degree
   `3·(3−1)^3 = 24`, giving `6 · 24 = 144`. ✓
3. **The same multiplicity 2 on the `Θ` side.** `M_X(v) = Bl_0 Θ` with exceptional divisor
   `X` (Bayer et al., Theorem 7.1, quoted in B3). The Gauss map of `Θ` has degree
   `∫_J Θ^5 = 120`; on the blow-up, `E_X^4 = ∫_X c_1(O_X(−1))^3 = −deg X = −3`, so
   `deg = 120 − 3m^4`, and LLPZ's 72 forces `m = 2` there too. ✓

**A discrepancy in Clemens–Griffiths worth flagging.** In the branch-locus argument just after
(13.7), p. 348, CG write:

> "Then `E_h` contains `n_0 = (2 × (27 choose 2))` points since `(V ∩ [h])` is a non-singular
> cubic surface."

`2 · C(27,2) = 702` is the number of *all* ordered pairs of distinct lines on the cubic surface.
But by their own Lemma 12.16 the 270 ordered **incident** pairs have `Φ = 𝒟(x) ∈ V^*`, so for
`h ∉ V^*` they are not in `E_h`. The correct generic fibre is `27 · 16 = 432`. Everything CG do
with `n_0` (Lemma 13.8, `b(Φ) = V^*`) only needs `n_0` to be a fixed finite number, so the slip
is harmless for them — but **432, not 702, is the degree of the span map**, and it is exactly
what the two modern computations and the blow-up formula independently give.

**Status**: the identity `g^*O(1) = ψ^*Θ` is integral (in `Pic`), all smooth `X`. The resolution
formula `μ^*(ψ^*Θ) − 2E` and `deg(g) = 432` are integral and hold for all smooth `X`. The
`deg = 432` figure is corroborated by LLPZ (72 × 6), by the 27-lines count, and by the two
Segre-class computations; `m = 2` is *derived*, not quoted.

### C3. Behaviour on the incidence locus, and along the diagonal

**FOUND, and canonical.**

- **Off the diagonal**: for distinct incident lines meeting at `x`, `g(ℓ,ℓ') = T_x X`, the
  tangent hyperplane of `X` at `x`. Two sources: Clemens–Griffiths Lemma 12.16 (quoted in C1,
  their `𝒟(x)`) and Li–Lin–Pertusi–Zhao Example 5.7 (quoted in C1, "the tangent space of `Y_3`
  at `ℓ ∩ ℓ'`"). **No blow-up is needed on `I − Δ`.** The plane spanned by two incident lines
  is contained in `T_x X`, and `T_x X` is the canonical limit.
- **On the diagonal**: `g` genuinely is indeterminate. Clemens–Griffiths **Lemma 12.17**, p. 342:

  > "LEMMA 12.17. Let `ν : Δ → S × S` be an analytic mapping of the unit disc into `S × S` such
  > that for `z ∈ Δ`, `z ≠ 0`, `ν(z) ∉ (diagonal of S × S)` but `ν(0) = (s_0,s_0)`. Then
  > `limit_{z→0} Φ(ν(z)) ∈ 𝒟(L_{s_0})`."

  i.e. the set of limit hyperplanes over `(ℓ,ℓ)` is exactly the pencil `{T_x X : x ∈ ℓ}` — a
  line in `(P^4)^∨`. One blow-up of `Δ` resolves this: the exceptional `P^1` over `ℓ` is `ℓ`
  itself (`E = P(T_F)` = universal line), and it maps isomorphically onto that pencil. The
  resolved pullback is `μ^*(ψ^*Θ) − 2E` (C2).

- Structure of `I` needed for any such argument, Clemens–Griffiths **Lemma 12.18**, p. 342:
  "`I` is non-singular except possibly at a finite set of points lying on the diagonal of
  `S × S`", the singular points being confined by (10.6) and Lemma 10.15/10.16 to `s = s'` with
  `(V · [𝒟(L_s)]) = 3L_s`, a finite set (Lemma 10.15: "Let `E = {s ∈ D : ([𝒟(L_s)] ∩ V) =
  3L_s}`. Then `E` is a finite set.").

---

## D. The 27-lines relative Picard local system over the span family (context only)

**FOUND for the hyperplane-section family; only indirectly for the `F×F` family.**

Krämer, *Cubic threefolds, Fano surfaces and the monodromy of the Gauss map*, arXiv:1501.00226v2,
§4 (proof of his theorem 2, part (2)) — his `S` = our `F`, `A` = our `J`, `V` = our `X`,
`PΩ` = the space of hyperplanes:

> "`PΛ_S = {(p,H) ∈ S × PΩ | L_p ⊂ H ∩ V}`. So the fibre of the Gauss map `γ_S` over a general
> point `H ∈ PΩ` is identified with the 27 lines on the smooth cubic surface `H ∩ V`, and the
> monodromy group `M_S` is the group of permutations of these 27 lines which is induced by
> variations of the hyperplane `H ∈ PΩ`. By [22, VI.20] this group is `W(E_6)`, so (2) follows."

His `[22]` is Manin's *Cubic forms* (from the bibliography of that paper; the exact reference
line was not re-read at full text, so treat the pointer as unverified). Krämer's Theorem 1:
"Let `Θ ⊂ A` be the theta divisor on the intermediate Jacobian `A` of a smooth cubic threefold.
Then `G_Θ ≅ E_6(C)/Z`", and the universal cover `E_6(C)` is the Tannaka group of the Fano
surface itself.

**Reading for our family** (my inference, marked as such): the family of cubic surfaces
`S_{ℓ_1,ℓ_2} = X ∩ P^3(ℓ_1,ℓ_2)` over `F×F − I` is the pullback along the span map `g` of the
universal hyperplane-section family over `(P^4)^∨ − X^∨`. Since `g` is dominant (C2, degree
432), the monodromy of the relative `Pic`/`H^2`-local system over `F×F − I` is a **subgroup** of
`W(E_6)` of index dividing 432 — the image of `π_1(F×F − I − g^{-1}(X^∨))` in `W(E_6)`. Whether
it is all of `W(E_6)` is **not settled by any source read here**; the 432-sheeted cover being
connected (the incidence variety of ordered skew line pairs is connected, since `W(E_6)` is
transitive on ordered skew pairs) is consistent with, but does not prove, full monodromy. Record
this as an open point if it becomes load-bearing.

Complementary anchor for the ambient monodromy: Beauville, *Le groupe de monodromie des familles
universelles d'hypersurfaces et d'intersections complètes* (LNM 1194) is in the cache under key
`BEAUVILLE:LNM1194-monodromie` but was **not read** for this report; it is the standard source
for the `Sp(10,Z)` monodromy on `H^3(X,Z)` used in the B1 alternative argument, and that argument
is not the one relied on.

---

## Consulted sources

Read depth per `notes/literature-audit-conventions.md`. "partial" records exactly which sections
were read; all cached bytes were read through `pdftotext` extractions in the shared cache and
every quoted formula was checked against the extracted page text.

| Source | Version | Access / cache key | SHA-256 | Read depth | Sections relied on |
|---|---|---|---|---|---|
| Clemens, Griffiths, *The intermediate Jacobian of the cubic threefold*, Ann. of Math. (2) 95 (1972) | published, 77 pp. scan | cache `10.2307/1970801` | `6cfe96ecb81179ce2756cb114414d3db1eab46274665c96c582d7f42c7a60a60` | partial | Introduction (0.8)–(0.12); §2 (2.4)–(2.7); §10 in full (Lemmas 10.2–10.21); §11 (11.2, 11.5, 11.6, 11.27, 11.28); §12 (12.1–12.5, 12.16–12.20); §13 (13.1–13.8) |
| Roulleau, *Elliptic curve configurations on Fano surfaces*, arXiv:0804.1861 | arXiv v-as-cached | cache `arXiv:0804.1861` | `afc1e45e608aaad153251dd22f4f19f7d23aa082f0afb35a592d28a8ba2803b3` | partial | §2.1–2.2 (Theorem 7, Lemma 8, Proposition 9) |
| Roulleau, *Fano surfaces with 12 or 30 elliptic curves*, arXiv:1001.4855 | arXiv v-as-cached | cache `arXiv:1001.4855` | `6cfe901586441afa6d875d17bd4c33c6675705d6658848e9b82b5bd5fbd77bec` | partial | §1, the `H^2`/`NS` exact-sequence paragraph and the `ρ_A = 1` paragraph |
| Voisin, *Cycle classes on abelian varieties and the geometry of the Abel–Jacobi map*, arXiv:2212.03046 | v4, 6 Jul 2023 | cache `arXiv:2212.03046` | `f61faf4c9b4e9a75ab8a99c749c04df93d858ca29a7057b895ecf56c87c83b43` | partial | §3: (32), Lemma 3.7 and its proof incl. (38)–(40), Remark 3.8, Corollary 3.9, Lemma 3.10 and (41) |
| Bayer, Beentjes, Feyzbakhsh, Hein, Martinelli, Rezaee, Schmidt, *The desingularization of the theta divisor of a cubic threefold as a moduli space*, arXiv:2011.12240 | v2, 23 Mar 2022 | cache `arXiv:2011.12240` | `ce005e812a7223208938c266281b88c2dbcfc3e125079eb98fcba76b8d365c8a` | partial | Abstract; §2 Prop. 2.2, Remark 2.3; §7 Theorem 7.1 |
| Li, Lin, Pertusi, Zhao, *Higher dimensional moduli spaces on Kuznetsov components of Fano threefolds*, arXiv:2406.09124 | arXiv as cached, 68 pp. | cache `arXiv:2406.09124` | `c1aa5d752c9c081827d0aa2cec4ab6408e3868449ef3f7e7ba11a7f936bbdb25` | partial | Example 5.7 only |
| Krämer, *Cubic threefolds, Fano surfaces and the monodromy of the Gauss map*, arXiv:1501.00226 | v2, 19 Mar 2016 | cache `arXiv:1501.00226` | `bad27e7b9eee618e83259d392d706e0738756fa57cd33f021641c2f1b4fed9f6` | partial | Introduction (Theorem 1); §4, proof of theorem 2 parts (2)–(3) |
| Collino, *The fundamental group of the Fano surface. I, II*, in Algebraic threefolds (Varenna 1981) | not obtained | — | — | secondary only (via Voisin arXiv:2212.03046 Remark 3.8, and via Roulleau arXiv:1001.4855 ref. [6] "2.3.5.1") | torsion-freeness of `H^*(F,Z)`; the `H_2` exact sequence behind A5.d |
| Manin, *Cubic forms* | not obtained | — | — | secondary only (via Krämer arXiv:1501.00226, "[22, VI.20]") | `W(E_6)` as the monodromy of the 27 lines |
| Beauville, *Variétés de Prym et jacobiennes intermédiaires*, Ann. Sci. ENS 1977 | published | cache `10.24033/asens.1329` | `4cf7ebf67a7d0d58c643efdb2d090b3b5fb61b8b7a4dd8e8a743079e9600e1c0` | abstract/metadata only | not relied on; listed because it was screened and set aside (Prym-theoretic, not Fano-cohomological) |
| Beauville, *Le groupe de monodromie des familles universelles…*, LNM 1194 | published | cache `BEAUVILLE:LNM1194-monodromie` | `4f6eb4e0bbe04ce8787754aba897e1552f47f47853fa34f421f8b30ac58ed045` | abstract/metadata only | named in §D as the `Sp(10,Z)` anchor; **not read**, and the B1 argument does not depend on it |
| Beauville, *Les singularités du diviseur `Θ` de la jacobienne intermédiaire…*, Varenna LNM 947 | not obtained | — | — | not accessed | would have anchored B3's `Θ`-singularity; substituted by Bayer et al. Theorem 7.1 |
| Huybrechts, *The Geometry of Cubic Hypersurfaces*, Cambridge 2023 | not obtained | — | — | not accessed | would have anchored A4 (`[F] = c_4(Sym^3 S^∨)`) and consolidated all of §A |

**Full-text count**: **zero** of the twelve sources above were read at `full text`. **Seven**
were read at `partial` depth over the sections named (Clemens–Griffiths; Roulleau
arXiv:0804.1861; Roulleau arXiv:1001.4855; Voisin arXiv:2212.03046; Bayer et al.
arXiv:2011.12240; Li–Lin–Pertusi–Zhao arXiv:2406.09124; Krämer arXiv:1501.00226); the
remaining five are `secondary only`, `abstract/metadata only`, or `not accessed`. Every
load-bearing formula in §A–§C rests on one of those seven `partial` reads.

**Screened set.** The shared cache was enumerated (`litcache.py list`, 705 entries) and filtered
by the regexes `cubic|fano|intermediate jacobian|clemens|huybrechts|threefold|prym|theta` over
the title field, then by full-text grep for `Fano surface` over the extraction files (30 hits).
The 30-file set was screened by grep for the discriminators `torsion`, `H^2(S,Z)`/`H 2 (Σ, Z)`,
`Sym`, `c_4`, `incidence`, `span`, `Gauss map`. Promoted out of the set for individual reading:
Roulleau arXiv:0804.1861 and arXiv:1001.4855, Voisin arXiv:2212.03046, Krämer arXiv:1501.00226.
The remaining members are covered by this set record only.

---

## Gaps and negatives

**Negative searches** (searched and found nothing — these license a "not located" but not a
"does not exist"):

1. **`[F] = c_4(Sym^3 S^∨)` in the Schubert basis (A4).** Searched: Clemens–Griffiths full text
   for `symmetric|Sym|c4|Chern class|Grassmann` (10 hits, all unrelated — CG never write the
   class of `F` in `H^8(Gr(2,5))`); the four Roulleau Fano-surface papers for `c_4|c4(|Sym|S^3`
   (zero hits). Stop condition: the two natural anchors outside the cache (Huybrechts' book
   §2/§5, Altman–Kleiman's Fano-scheme papers) are unreachable here. The class
   `18σ_{3,1} + 27σ_{2,2}` in A4 is therefore **derived and cross-checked against three CG
   numbers**, not quoted.

2. **The Künneth decomposition of `[I] ∈ H^2(F×F)` (B1).** Searched: Clemens–Griffiths for
   `S x S|SxS` (16 hits, all read — they define `I` at (2.4) and use it at 12.18/13.3 but never
   give its class); arXiv:2011.12240 and arXiv:2406.09124 for `incidence|span|F × F|difference
   map` (2 and 30 hits respectively, all inspected). Stop condition: exhausted the cached
   cubic-threefold corpus. The formula `[I] = pr_1^*C_s + pr_2^*C_s + P` is **derived**, from
   CG Lemma 10.7 + Proposition 10.21 + Lemma 11.6 + Lemma 11.27.

3. **The class `[D_p] = g^*O(1)` and the graph of the span map (C2).** Searched: the same two
   modern papers plus Krämer; the only quantitative statement located anywhere is LLPZ's
   "degree 72" for the map out of the moduli space. Stop condition: no cached source treats
   `g` as a map *from `F×F`* with a divisor-class computation. The formula
   `g̃^*O(1) = μ^*(ψ^*Θ) − 2E` and `deg(g) = 432` are **derived**, with three independent
   confirmations recorded in C2.

4. **Integral surjectivity of `a^* : H^3(J,Z) → H^3(F,Z)` (A5.e).** Searched: Voisin
   arXiv:2212.03046 §3 in full, Roulleau's four papers, Clemens–Griffiths §§9–11. Nothing
   integral was located beyond Voisin's Lemma 3.10 (a `2`-divisibility statement in homology,
   under a very general Mumford–Tate hypothesis). The `(Z/2)^{10}` cokernel of `C_s ∪ (·)` is
   derived from CG (13.2).

5. **Monodromy of the relative Picard local system over `F×F − I` specifically (D).** Searched:
   Krämer §4 (which does the hyperplane-section family, not the `F×F` family). No source
   located that identifies the monodromy of the span family over `F×F`. Only the containment in
   `W(E_6)` is available, and that by pullback.

**Could not access** (licenses nothing; open gaps carried forward):

- **Huybrechts, *The Geometry of Cubic Hypersurfaces*, Cambridge 2023.** Not in the shared
  cache; no key resolves (`10.1017/9781108932967` returns "not cached"). This is the single
  highest-value missing source: it would give A1–A5 as a single coherent chapter with modern
  integral statements, and would anchor A4 directly. **If C908 leans on A4 or A5.e, obtain this
  first.**
- **Collino, *The fundamental group of the Fano surface* I, II (LNM 947).** Not obtained; the
  torsion-freeness of `H^*(F,Z)` (A5.a) and the `H_2` exact sequence behind A5.d both trace back
  to it and are held at `secondary only`.
- **Beauville, *Les singularités du diviseur Θ …* (LNM 947).** Not obtained; substituted for B3
  by Bayer et al. Theorem 7.1, which reproves the same description.
- **Tyurin's cubic-threefold papers.** Cited by Roulleau ("The main references are the works of
  Clemens, Griffiths [4] and of Tyurin [14]") but not in the cache and not obtained. Not
  load-bearing for anything above.
- **MathSciNet / zbMATH forward-citation screening.** NOT COVERED — no absence claim in this
  report is offered as a novelty verdict, so the citation-graph width requirement of
  `notes/literature-audit-conventions.md` § "Negatives from citation graphs" is not triggered.
  If any of the negatives 1–5 above is later promoted into a novelty claim, that width
  requirement (OpenAlex + Crossref + Semantic Scholar, counted separately) must be discharged
  first.

## Surprises worth flagging

1. **`K_F = 3C_s` is exact in `H^2(F,Z)`, torsion included** — not just modulo torsion — because
   `H^*(F,Z)` is torsion-free and CG (10.9) is a *linear* equivalence to `C_{s_1}+C_{s_2}+C_{s_3}`
   for a tritangent triple. But `K_F ∼ 3C_s` in `Pic(F)` is **false**; only the homological
   statement holds.
2. **The predicted shape of `[I]` fails on a sign.** `[I] = pr_1^*C_s + pr_2^*C_s + P` while
   `ψ^*Θ = 2pr_1^*C_s + 2pr_2^*C_s − P`. The right identity is `[I] = K_{F×F} − ψ^*Θ`, i.e.
   `ψ^*O_J(Θ) ≅ ω_{F×F}(−I)`.
3. **Clemens–Griffiths overcount the span map's generic fibre** (702 instead of 432) just after
   (13.7), by including incident ordered pairs that their own Lemma 12.16 sends into `V^*`.
   Harmless in their argument, but 432 is the correct degree and it is what the modern
   moduli-theoretic count (6 × 72) and the blow-up formula `720 − 18·2^4` both give.
4. **The span map needs no resolution on the incidence locus** away from the diagonal: the
   canonical value at an incident pair is `T_x X`, stated independently by Clemens–Griffiths
   (1972) and Li–Lin–Pertusi–Zhao (2024). Only the diagonal is indeterminate, and one blow-up
   fixes it with multiplicity **2**.
5. **`C_s ∪ (·) : H^1(F,Z) → H^3(F,Z)` has cokernel `(Z/2)^{10}`**, since CG (13.2) makes it
   the matrix `2E`. Any integral argument that treats hard Lefschetz on `F` as unimodular is
   wrong by a factor `2` in each of ten directions.
