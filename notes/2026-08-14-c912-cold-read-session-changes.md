# C912 cold read: session changes to the cubic-stabilization epilogue

Date: 2026-08-14
Reader: independent cold read, read-only on `papers/cubic-stabilization-m1/`
Scope: commits `0db2a97fc`, `131e926d6`, `d92f27904`, `ac0bfee7b`, `9c3518861`,
`87b6170e1`, `a9fd9b84e`, `011580e55` (delta `27649bc3a..HEAD` restricted to
`papers/cubic-stabilization-m1`).

## Overall verdict

**GO.** Every one of the eight items holds up on the mathematics. The two
claims I expected to be most fragile -- the sign paragraph that had already been
rewritten once after an error, and the Iritani-Koto locator repair -- are both
correct, and the version-history claim about Theorem 5.1(5) is confirmed word
for word by the arXiv v4 comment. Nine defects are recorded, all of them
locator or exposition imprecisions; the most substantive (D1) is that the
coefficient automorphism named in the divisor-tagging endgame is the identity
under the application as written, which leaves the conclusion intact but makes
the explanatory paragraph describe a split with an empty half.

---
## 1. Introduction repositioning and the three corollaries

**Verdict: CONFIRMED** (one exposition nit, no defect).

Structure as it now stands in `sections/01-introduction.tex`: Theorem
`thm:every-cubic` (for every smooth complex cubic threefold `X`, `X x P^1` is
irrational), then `cor:voisin-separation`, `cor:fermat-separation`,
`cor:coprime-separation`, then Theorem `thm:separation-family` on the
`A_5`-pencil.

### Sources checked verbatim

Voisin, arXiv:1407.7261v2, line 1468:

> Theorem 4.5. There exists a non-empty countable union of proper subvarieties
> of codimension <= 3 in the moduli space of smooth cubic threefolds
> parametrizing threefolds X with universally trivial CH0 group.

line 1529:

> Lemma 4.6. Each choice of sublattices H1, H2 as above provides us with a
> subvariety of codimension <= 3 in the moduli space of X along which the class
> theta^4/4! is algebraic.

line 1452:

> Corollary 4.4. (cf. Theorem 1.7) A smooth cubic threefold admits a
> Chow-theoretic decomposition of the diagonal (that is, its CH0 group is
> universally trivial) if and only if the class theta^4/4! is algebraic on J(X).

These support the intro sentence at lines 33-38 and the synthesis proof at
`sections/05-synthesis.tex:9-14` exactly, including "codimension at most
three". The claimed moduli dimension ten is correct: 35 cubic monomials in five
variables, so `dim P^34 - dim PGL_5 = 34 - 24 = 10`. (Voisin's own Lemma 4.6
proof writes `dim U = 12` for the cubic-threefold deformation base, which is a
slip in the source; the stated codimension bound survives either way, since
`dim V = 12`, `dim U = 10`, `dim A~_5 = 15` still give `dim G >= 7` and
`codim U' <= 3`. The manuscript does not repeat the slip.)

Colliot-Thelene, arXiv:1607.05673v3, abstract:

> If a smooth cubic hypersurface of dimension at least 2 over the complex field
> is defined by the vanishing of a sum of cubic forms in independent variables
> and each of these forms involves at most 3 variables, then the cubic
> hypersurface is universally CH0-trivial: there is an integral Chow
> decomposition of the diagonal.

The Fermat quintic-variable cubic is a sum of five forms in one variable each,
so the hypothesis holds a fortiori; `{sum x_i^3 = 0} subset P^4` is smooth.
`cor:fermat-separation` and its proof at `05-synthesis.tex:16-19` are correct.

Yang-Yu-Zhu, arXiv:2508.03623v2:

- Theorem 1.1 (line 36): "There exists a 2-dimensional family of smooth cubic
  threefolds admitting unirational parametrizations of coprime degrees";
  Theorem 3.3 (line 574) supplies the degree-3 parametrization for the explicit
  family `F' = t1 x1^2 x3 + t2 x2^3 + t3 x1 x3^2 + t4 x4^2 x5 + t5 x4 x5^2 +
  t6 x1 x2 x3 + t7 x2 x4 x5`; degree 2 is CG72 Appendix B. Matches the intro
  sentence at lines 59-61.
- Corollary 3.5 (line 602): "Let X be a smooth cubic hypersurface as in Theorems
  1.1 and 1.2. Then for any integer m >= 1, X x P^m admits unirational
  parametrizations of coprime degrees." Matches line 64.
- Intro (line 86-87): "If a variety admits unirational parametrizations of
  coprime degrees, then it has a Chow-theoretic decomposition of the diagonal;
  equivalently, it is universally CH0-trivial (see [ACTP17])." Matches the
  `\cite[Section~1]{YYZ}` attribution at `05-synthesis.tex:26`.
- Question 1.4 (line 88): "Is there a smooth complex projective variety
  admitting unirational parametrizations of coprime degrees which is not stably
  rational?" Matches line 73-74.
- Remark 3.7 (line 610) lists exactly "the blow-up of X in a line, the blow-up
  of X in a plane cubic curve and the Fano threefolds of degree 14 and Picard
  number 1 associated to X". Matches lines 27-29.
- Remark 3.6 (line 604) gives the explicit degree-3 dominant map `P^3 -->`
  Fermat cubic threefold. Matches line 133-134.

### Logic of the transfer step

The shared preamble at `05-synthesis.tex:4-7` carries the projective-bundle
step for all three corollaries. That step is correct: for a `P^1`-bundle,
`CH_0(P(E)) = CH_0(X) (+) CH_{-1}(X) = CH_0(X)` via `p_*`, which is
degree-preserving, and the identity persists over every `L/C` because
`(X x P^1)_L = X_L x P^1_L`. So universal `CH_0`-triviality transfers, and the
irrationality half is `thm:every-cubic`.

### Priority

No overclaim found. YYZ themselves already record (line 80-81) that the Voisin
codimension-3 subvarieties "contain the smooth cubic threefolds in Theorem
3.3", and the manuscript does not present the Voisin locus or the CT result as
its own. Lines 76-78 explicitly say `cor:coprime-separation` "does not settle"
YYZ Question 1.4, which is the right hedge: `X x P^1` irrational leaves
`X x P^m`, `m >= 2`, open, and stable rationality of `X` is exactly what
Question 1.4 asks about. Lines 174-193 correctly attribute the Voisin
criterion, the EdGFS evenness theorem, and state that
`thm:six-axis-divided-powers` "does not enlarge that union".

### Exposition nit (not a defect)

The three corollary proofs at `05-synthesis.tex:9-27` each supply only the
`CH_0` source and leave the bundle step and `thm:every-cubic` to the shared
preamble sentence. A referee reading a proof environment in isolation will see
a proof that stops before proving the stated conclusion. One clause
("hence `cor:...` follows by the preamble") in each would close it.

---

## 2. The Fermat-membership remark (`rem:fermat-in-pencil`)

**Verdict: CONFIRMED.** Both the representation theory and the Hartlieb
attribution hold.

### Representation theory, verified from scratch

Character table of `A_5` on classes `1, 2A, 3A, 5A, 5B` with sizes
`1, 15, 20, 12, 12`. The five-dimensional irreducible `W_5` has character
`(5, 1, -1, 0, 0)`. This matches Hartlieb's Table 3 row `chi_5` verbatim
(arXiv:2304.03214v2, line ~795: `chi5  5  1  -1  0  0`), so the manuscript's
line 104-105 is right.

*Dimension count (line 108).* With
`chi_{Sym^3}(g) = (chi(g)^3 + 3 chi(g) chi(g^2) + 2 chi(g^3))/6`:

| class | `chi(g)` | `chi(g^2)` | `chi(g^3)` | `chi_{Sym^3}(g)` |
|-------|----------|------------|------------|------------------|
| `1`   | 5        | 5          | 5          | 35               |
| `2A`  | 1        | 5          | 1          | 3                |
| `3A`  | -1       | -1         | 5          | 2                |
| `5A`  | 0        | 0          | 0          | 0                |
| `5B`  | 0        | 0          | 0          | 0                |

Then `<chi_{Sym^3}, 1> = (1/60)(1*35 + 15*3 + 20*2 + 12*0 + 12*0) = 120/60 = 2`.
`W_5` is self-dual, so `dim (Sym^3 W_5^*)^{A_5} = 2`. The pencil claim is
correct, and `dim Sym^3(C^5) = C(7,3) = 35` cross-checks the identity row.

*Frobenius reciprocity (lines 120-128).* The point stabilizer of `A_5` acting
on five letters is `A_4`; `A_4^{ab} = Z/3`, so nontrivial cubic characters
`chi` exist. Restricting `W_5` to `A_4`, the class function is `(5, 1, -1, -1)`
on `1`, the three double transpositions, and the two `A_4`-classes of 3-cycles
(sizes `1, 3, 4, 4`). Against the `A_4` character table:

- trivial: `(1/12)(5 + 3 - 4 - 4) = 0`
- `chi_omega` (values `1, 1, omega, omega^2`):
  `(1/12)(5 + 3 - 4 omega^2 - 4 omega) = (1/12)(8 + 4) = 1`
- `chi_{omega^2}`: `1` by conjugation
- the 3-dimensional `(3, -1, 0, 0)`: `(1/12)(15 - 3) = 1`

So `Res_{A_4} W_5 = chi_omega (+) chi_{omega^2} (+) (3-dim)`, giving
`<chi, Res_{A_4} W_5> = 1`, hence `<Ind_{A_4}^{A_5} chi, W_5> = 1`. Since
`[A_5 : A_4] = 5`, `dim Ind chi = 5 = dim W_5`, so `Ind chi = W_5`. The
manuscript's "both sides have dimension five" step is exactly this and is
valid.

*Monomial realization and Fermat invariance (lines 128-130).* In the induced
model with basis indexed by the five cosets, the matrix of `g` has entries
`chi(g_i^{-1} g g_j)` when that element lies in `A_4` and `0` otherwise, so
each row and column carries exactly one nonzero entry, a value of `chi`, i.e. a
cube root of unity. If `(Mx)_i = eps_i x_{sigma(i)}` with `eps_i^3 = 1`, then
`sum_i (Mx)_i^3 = sum_i eps_i^3 x_{sigma(i)}^3 = sum_j x_j^3`. So the Fermat
form is `A_5`-invariant in this model, and `{sum x_i^3 = 0}` is a smooth member,
hence lies in `B^circ`. Correct as written.

### Hartlieb attribution, verified against the cached source

arXiv:2304.03214v2, line 831 and following:

> Lemma 5.5. The locus of of smooth cubic threefolds admitting an action by
> Alt(5) has two irreducible components `M~^{Alt(5)} = M_{H_1} u M_{H_2}`,
> where `Alt(5) ~= H_1 subset PSL(2,11)` and `H_2` is the image of `Alt(5)
> subset Sym(5) --> GL(5,C)`, given by permutation of coordinates. Moreover, we
> have `M_{H_1} n M_{H_2} = {Y_1, Y_6}`.

and from the proof:

> The character `chi_5` corresponds to `H_1` and `chi_1 + chi_4` corresponds to
> `H_2`.

`Y_1` is identified as the Fermat cubic threefold at line 471 ("Since the
Fermat cubic threefold `Y_1` is a cyclic cubic threefold and `J(Y_1) ~= E^5`").
So Lemma 5.5 does say (i) the `W_5 = chi_5` component is `M_{H_1}`, (ii) the
other component is the `1 (+) W_4 = chi_1 + chi_4` permutation one, and
(iii) the Fermat threefold is one of exactly two members lying in both. Every
clause the manuscript hangs on `\cite[Lemma~5.5]{Hartlieb}` at lines 111-112
and 118-120 is present in that lemma. Attribution CONFIRMED.

---
## 3. Iritani-Koto and Iritani-blowup locators in `sections/04-one-step.tex`

**Verdict: CONFIRMED** for every locator's content, with three low-severity
imprecisions listed in the defect table (D2, D3, D4).

The version claim itself is now independently confirmed. The arXiv submission
history for 2307.03696 gives, for v4 (Sat, 31 Jan 2026):

> proof of Theorem 1.1 streamlined, log q term in the change of coordinates for
> Theorem 1.7 removed, error in Theorem 5.1(5) corrected, a reconstruction
> algorithm added in Section 5.8

So the manuscript's parenthesis at line 647-649 ("an item corrected in the
fourth version of that preprint, dated 31 January 2026") is exactly right, and
it also explains the old locator's failure: Section 5.8 is v4-new material
(the Hinault-Yu-Zhang-Zhang reconstruction algorithm), which is not where the
coordinate formula is proved. The bibliography pins `arXiv:2307.03696v4 (2026)`
and `arXiv:2307.13555v3 (2025)`, matching the cached extractions.

### Iritani-Koto (arXiv:2307.03696v4)

| Manuscript | Locator | Source content | Verdict |
|------------|---------|----------------|---------|
| 610-615 | Thm 5.1(4) | `ς_j(τ̂)\|_{Q=τ̂=0} = r λ_j − 2πi j/r c_1(V) + O(q^{−1/r})` | CONFIRMED, term for term |
| 606-609 | Prop 5.6 | `σ_j ∈ −2πi j/r c_1(V) + τ(λ_j) + m H*(B)[[q^{−1/r}, q^{−c1(V)/r}Q, q^{•/r}τ]]`, with `m` the closed ideal generated by `q^{−1/r}` and `q^{−c1(V)·d/r}Q^d`, `d ∈ Eff(B)\{0}` | CONFIRMED: this is precisely "puts the normalized target coordinate in the maximal ideal", and `m` plus the bulk components is the manuscript's `J_j` |
| 647-650 | Thm 5.1(5) | "the Jacobian matrix of `ς(τ̂) = ⊕ς_j(τ̂)` along `Q = τ̂ = 0` ... is invertible over `C((q^{−1/r}))`" | CONFIRMED |
| 649-650 | Cor 1.8 | "The derivative of the map `ς` induces an isomorphism of the quantum cohomology rings `(H*(P(V)), ⋆_τ̂) ≅ ⊕_i (H*(B), ⋆_{ς_i(τ̂)})` over the localized base `C((q^{−1/r}))[[Q]]`" | CONFIRMED |
| 573-575 | (5.1) | `r' := r` when `r−1` is even, `2r` when `r−1` is odd | CONFIRMED verbatim |
| 625-631 | (5.3) | `QDM(B)^ext := QDM(B) ⊗ C[z][[q^{−1/r'}, q^{−c1(V)/r}Q, σ]]` | content right, locator imprecise (D3) |
| 636-639 | Sec 5.1, (5.1)-(5.3) | the graded-completion convention | CONFIRMED |
| 679 | (1.1), Rem 5.2 | (1.1) is `Q_B^d ↦ q^{−c1(V)·d/r}Q^d`, `C[[Q_B]] ↪ C((q^{−1/r'}))[[Q]]`; Rem 5.2 gives its geometric meaning as a splitting of `π_*: H_2(P(V),Z) ↠ H_2(B,Z)`. The paper's own footnote 2 says "See Remark 5.2 for the geometric interpretation of this embedding." | CONFIRMED |
| 680-682 | Rem 1.2 | "By tensoring `V` with a sufficiently negative line bundle, we can always assume that `V^∨` is generated by global sections, without changing `P(V)`." | CONFIRMED verbatim |

Note for the record: the *old* locator was not empty either. Iritani-Koto v4
Section 5.8 does define `ς_j° := ς_j(τ̂)|_{Q=τ̂=0} = r λ_j + σ_j|_{Q=τ=0}` just
before (5.11), and (5.13) there is literally `s_j(τ̂) = ς_j(τ̂) − ς_j°`, which is
the manuscript's `ς_j = ς_j° + s_j`. The repair trades the provenance of that
notation for a sharper anchor on the formula. Nothing is lost mathematically.

### Iritani, blowups (arXiv:2307.13555v3)

| Manuscript | Locator | Source content | Verdict |
|------------|---------|----------------|---------|
| 400-408 | Thm 5.18 | `Ψ : QDM(X~)^la → τ*QDM(X)^la ⊕ ⊕_{j=0}^{r−2} ς_j*QDM(Z)^la` over `C[z]((q^{−1/s}))[[Q,τ̃]]`, commuting with the quantum connection | CONFIRMED (`r−1` center copies, manuscript's `c−1` with `c` the codimension) |
| 410-411 | (5.11) | `s = r−1` if `r` even, `2(r−1)` if `r` odd | CONFIRMED verbatim |
| 415-424 | Sec 5.8.2 | "5.8.2. Reconstruction. ... we write `τ(τ̃) = τ° + t(τ̃)`, `ς_j(τ̃) = ς_j° + s_j(τ̃)`" | CONFIRMED |
| 460-465 | (5.45), (5.47), (5.27)-(5.30) | (5.45) gives `ς_j° = −(r−1)λ_j + [z^{−1}] log q^{ρ_Z/((r−1)z)} F_{Z,j}(1)`; (5.30) gives `ς_j(0)\|_{Q=0} ∈ −(r−1)λ_j + h_{Z,j} + q^{−1/(r−1)}H*(Z)[q^{−1/(r−1)}]`; (5.47) is `τ = τ° + t`, `ς_j = ς_j° + s_j`; (5.27) is the initial asymptotic `FT^_{Z,j}(c)\|_{Q=θ=0} = q_{Z,j}λ_j^n(b + O(q^{−1/(r−1)}))` | CONFIRMED; (5.30) is literally the manuscript's `ς_j° = −(c−1)λ_j + h_{C,j} + O(u)` |
| 458-459 | Rem 5.6 | "the structure of `QDM(Z)^La` can be reduced to a smaller ring, namely, the image `R` of `C[z][[Q_Z e^σ, σ']][σ^0]` under (5.15)" | CONFIRMED |
| 486-491 | Prop 5.4, (5.13)-(5.14) | the filtration `F_N` from `Ω_N` in the proof | content right, description wrong (D2) |
| 491-494 | Rems 1.3-1.5 | Rem 1.3: "Throughout the paper, we work with completions in the category of graded rings or modules ... `C((q^{−1/(r−1)}))[[Q]]` is the same as `C[q^{±1/(r−1)}][[Q]]` since `q` has positive degree." Rem 1.5: "The base ring can also be written as `C[q^{±1/s}][[Q,τ̃]][[z]] because of our convention on the graded completion" | CONFIRMED; this is exactly "the graded meaning ... rather than an ordinary `J_j`-adic completion after `v` has been inverted" |
| 506-507 | Cor 1.2, Thm 5.18 | Cor 1.2: "The map `τ̃ ↦ (τ(τ̃), {ς_j(τ̃)}_{0≤j≤r−2})` defines an isomorphism of quantum cohomology F-manifolds over `C((q^{−1/(r−1)}))[[Q]]`" | CONFIRMED |
| 691-692 | (5.15) | "the (not necessarily injective but degree-preserving) extension of rings" | CONFIRMED verbatim; this is the exact wording the manuscript needs |

No locator was found that fails to carry its attributed content.

---

## 4. `rem:pro-laurent-concrete` and `G^pro = GL` over the inverse-limit ring

**Verdict: CONFIRMED.** All three ring-theoretic claims are correct, and the
remark does dispose of the concern.

*The concrete description (lines 220-223).* An element of
`L_{B,F} = lim_N (B/F^N B)((z))` is a compatible family `(f_N)`. Reading off
coefficients, `(c_{k,N})_N` is compatible for each fixed `k`, and `B` is
complete separated, so it defines `c_k ∈ B`. The truncation bound at level `N`
says `c_k ∈ F^N B` for all `k` below some `−m_N`. That is verbatim "for every
`N`, all but finitely many `k < 0` have `c_k ∈ F^N B`", and the correspondence
is a bijection.

*Closure under multiplication (line 222).* Fix `N`. Choose `J_N`, `K_N` with
`a_j ∈ F^N B` for `j < J_N` and `b_k ∈ F^N B` for `k < K_N`. In
`Σ_{j+k=n} a_j b_k`, any term with `j < J_N` or `k < K_N` lies in `F^N B`
because `F^N B` is an ideal, so at most the finitely many `j ∈ [J_N, n−K_N]`
survive modulo `F^N B`. The same bookkeeping shows the product's coefficient
of `z^n` lies in `F^N B` whenever `n < J_N + K_N`, so the product satisfies the
membership condition. Multiplicativity of the filtration is exactly what is
needed and exactly what is invoked.

*The matrix claim (lines 223-228).* With `dim V = n < ∞`,
`M_n(lim_N R_N) = lim_N M_n(R_N)`. A compatible family of invertible matrices
has a compatible family of inverses (inverses are unique), so
`lim_N GL_n(R_N) ⊆ GL_n(lim_N R_N)`; the reverse inclusion is reduction. Hence
`G^pro_{B,F}(V) = GL(V ⊗ L_{B,F})`, and "a compatible family has its inverse in
the same group" is the uniqueness-of-inverse step. Finite-dimensionality of `V`
is used and is stated.

*Does it dispose of the concern?* Yes, and the proof of
`lem:formal-base-shift` supplies the missing quantitative fact. There
`G = Σ_α G_α η^α` with `G_α` carrying no `z`-power below `−|α|`, and
`η ∈ F^1 B`, so the coefficient of `z^{−k}` in `G` is a sum of terms with
`|α| ≥ k` and therefore lies in `F^k B`. That is strictly stronger than the
membership condition of `L_{B,F}`, so `G ∈ L_{B,F}` even though its Laurent
lower bound `−(N−1)` runs to minus infinity in `N`. The revised sentence at
lines 306-308 ("That bound decreases with `N`, which costs nothing ... the
transported operator is formed over `L_{B,F}` and never over `B((z))`") is
correct and is the right place to put it.

---

## 5. The divisor-tagging endgame

**Verdict: CONFIRMED on the mathematics; one clarity defect (D1) on the role of
the substitution `σ`.**

*Injectivity of the tagging map (lines 741-771).* Sound and checked step by
step. `S_μ` is finite and nonempty by properness of `ℓ`. Each displayed
summand coefficient `c_d in_v(χ(Q^d))` is nonzero: `c_d ≠ 0` by construction,
`in_v(χ(Q^d)) ≠ 0` because `v(χ(Q^d)) = ℓ(d) = μ` exactly, and `gr_v(A)` is a
domain containing `C`. The characters `exp(Σ_i t_i (D_i·d))` for `d ∈ S_μ` have
pairwise distinct integer exponent vectors because the `D_i` separate `N_1(T)`.
`Z^ρ` is not covered by the finitely many hyperplanes `⟨a, n^{(d)} − n^{(d')}⟩ = 0`,
so a valid `a` exists; substituting `t_i = a_i s` gives distinct integers `m_d`,
and the matrix `(m_d^j)` of derivatives at `s = 0` is Vandermonde with nonzero
integer determinant, invertible over any characteristic-zero field. Linear
independence, hence a nonzero initial form, hence `χ_t(f) ≠ 0`. Correct.

*The domain hypothesis (lines 773-780).* Correct where it is claimed: a domain
associated graded makes `in_v(a) in_v(b) ≠ 0`, so `v(ab) = v(a) + v(b)` and `v`
is a valuation rather than a filtration. That is what licenses
`v(χ(Q^d) exp(Σ t_i D_i·d)) = ℓ(d) + 0`, and hence the clean degree-`μ` initial
form. Two caveats: (i) "each monomial image has valuation exactly `ℓ(d)`" is
hypothesis (4.5) of `def:strict-novikov-admissible`, not a consequence of the
domain hypothesis, so the "so" chain is loose; (ii) "enters exactly here" is
under-inclusive, since the immediately preceding sentence forms
`Frac(gr_v A)`, which exists only because `gr_v A` is a domain (D6).

*The two comparisons and the evaluation (lines 782-824).* The chain is valid
and the equivalences do run both ways:

- (4.6a) `p^tag = p^int` is an equality of polynomials over a common algebraic
  closure, so `p^int(ζ) = 0 ⟺ p^tag(ζ) = 0` needs nothing further. The
  supporting step (injectivity embeds the intrinsic Novikov fraction field in
  `Frac(A[[t]])`) is legitimate: `A` is a domain by
  `def:strict-novikov-admissible`, so `A[[t]]` is a domain and the fraction
  field exists.
- (4.6b) `p^tag = σ(p^spec)` with `σ` a coefficient automorphism fixing `C`.
  Writing `p^spec = Σ a_i X^i`, `p^tag(ζ) = Σ σ(a_i) ζ^i = σ(Σ a_i ζ^i)` since
  `σ` fixes `ζ ∈ C`. An automorphism is injective, so
  `p^tag(ζ) = 0 ⟺ p^spec(ζ) = 0`. Both directions, as claimed. Multiplicity is
  preserved too: `p^spec = (X−ζ)^m g` with `g(ζ) ≠ 0` gives
  `σ(p^spec) = (X−ζ)^m σ(g)` and `σ(g)(ζ) = σ(g(ζ)) ≠ 0`.

So `p^int(ζ) ≠ 0` for every primitive sixth root implies `p^spec(ζ) ≠ 0`, which
is the lemma. In fact the chain proves the stronger two-sided statement, and
line 823-824 correctly declines to lean on it.

*The defect (D1).* The application at lines 800-803 is "Apply
`lem:formal-base-shift` with `η = Σ_i t_i D_i`". That places the entire divisor
direction in the positive-filtration slot `η ∈ F^1 B ⊗̂ H^ev(T)`, hence
`a_2^circ = 0`, hence the substitution (4.1) `Q^d ↦ e^{⟨a_2^circ, d⟩}Q^d` is the
identity and `σ = id`. The alternative reading, that `σ` is
`Q^d ↦ e^{Σ t_i (D_i·d)}Q^d` (i.e. `a_2^circ = Σ t_i D_i`), violates the lemma's
own hypothesis at line 247 that `a_0` and `a_2^circ` are "constant in the
positive filtration", since the `t_i` are the positive-filtration variables. The
conclusion survives either way, so this is not a wrong result. But the closing
paragraph at lines 826-834 ("The substitution and the gauge do not compete ...
The two act on different factors") describes a split whose first factor is empty
under the application as written, and that is exactly the point a referee will
press. The fix is one sentence: say that `a_2^circ = 0` here, so `σ` is the
identity and (4.6b) reads `p^tag = p^spec`; or widen the lemma to allow
`a_2^circ ∈ F^1`.

---

## 6. The plus-or-minus-one sign paragraph (`sections/02-envelope.tex:91-101`)

**Verdict: CONFIRMED. No clause is still wrong.** Checked clause by clause.

1. "Each target identification is determined only up to a sign." Correct: the
   generic fibre is non-CM, so `End(E) = Z` and `Aut(E, 0) = {±1}`; an
   isomorphism `E_H → E` is unique up to composition with `[−1]`.
2. "Replacing the chosen isomorphism `E_H → E` by its negative replaces `q_H` by
   `−q_H` and, by functoriality of Rosati duality, `i_H` by `−i_H` at the same
   time." Correct. A single choice of identification presents both maps; through
   `−φ_H`, the quotient becomes `(−1) ∘ q_H = −q_H` and the inclusion becomes
   `i_H ∘ (−1) = −i_H`. Since `q_H` is the Rosati dual of `i_H`, the dual of
   `−i_H` is `−q_H`, so the two signs move together rather than independently.
   This is the clause the earlier version got wrong; as written it is right.
3. "`N_H = i_H q_H` is unchanged." Correct: `(−i_H)(−q_H) = i_H q_H`.
4. "and so is `D_H = q_H^*[0]`, since `[−1]^*[0] = [0]`." Correct: the origin is
   fixed by `[−1]`, so `((−1) ∘ q_H)^*[0] = q_H^*((−1)^*[0]) = q_H^*[0]`.
5. "The diagonal entry `q_H i_H` is likewise unchanged." Correct, `(−1)^2 = 1`.
6. "the Gram matrix changes by a signed congruence `D G_6 D` with
   `D = diag(±1)`." Correct: with independent signs `ε_H`, the `(H,H')` entry
   becomes `ε_H ε_{H'} G_{H,H'}`, which is `(D G_6 D)_{H,H'}`, and the diagonal
   is fixed, consistent with clause 5.
7. "which alters neither the Smith type of the pulled-back polarization nor
   anything below." Correct: `D` is unimodular, and Smith normal form is
   invariant under `G ↦ U G V` for unimodular `U, V`.
8. "The coherent choice is the one making all off-diagonal entries equal; it is
   unique up to a global sign, which acts trivially." Correct, and the "six"
   matters. Requiring `ε_H ε_{H'} m` constant over all pairs from a set of size
   at least three forces all `ε_H` equal (from `ε_1ε_2 = ε_1ε_3` one gets
   `ε_2 = ε_3`, and so on), so `D = ±I` and `D G_6 D = G_6`.

Nothing in the paragraph is left wrong. Two supporting facts it leans on are
also correct: `N_{A_5}(H) = H` for a `D_5` subgroup (index six, and `A_5` has no
subgroup of order 20, 30, or a normal `D_5`), and `dim W_5^H = 1`
(`⟨Res_{D_5} χ_5, 1⟩ = (5·1 + 5·1 + 4·0)/10 = 1`), which is what makes the
axis one-dimensional.

---

## 7. The remaining cycle-side seams

**Verdict: CONFIRMED on all six, with one exposition seam (D5).**

*Generic-point non-CM qualification (`02-envelope.tex:23-41`).* The argument is
sound: a CM endomorphism fixes an imaginary-quadratic order, so the generic
`j`-invariant is a root of the corresponding Hilbert class polynomial, hence
algebraic over `Q`, hence constant on the irreducible base; isotriviality after
finite base change plus `J_b ~ E_b^5` would put the whole family in one
countable isogeny class, contradicting a positive-dimensional image. The
supporting citation holds:

> Proposition 5.7. The closure of `J(M_{H_1})` in `A_5` is a one-dimensional
> special subvariety. (arXiv:2304.03214v2, line 884)

and Remark 5.8 supplies `J(Y) ~ E^5` for *each* `Y ∈ M_{H_1}`, not merely
generically, which is what the fibrewise use at line 166-170 needs:

> Remark 5.8. The intermediate Jacobians of members of the family `M_{H_1}` are
> all isogeneous to the self-product of an elliptic curve ... for each cubic
> threefold `Y ∈ M_{H_1}`, there is an elliptic curve `E` such that the
> self-product `E^5` is isogeneous to `J(Y)`.

The new qualification (lines 36-41) is accurate and its forward reference is
real: `03-minimal-class.tex:229-234` does record, immediately after the proof of
`thm:all-degree-graph-saturation`, that "The theorem concerns the divisor
lattice selected by the marked elliptic-power presentation. If `E` has no
complex multiplication, this is the full Neron-Severi lattice. At a CM fibre
extra divisor classes need not satisfy the graph hypotheses." Since
`f_b^* Θ_b = λ_{A_b}` puts the principal polarization inside the prescribed
lattice (`03-minimal-class.tex:349-352`), the conclusion for `Θ^4/4!` is not
weakened at CM fibres. The residual seam is D5 below.

*Abelian-scheme image and relative dimension (`02-envelope.tex:172-180`).* The
citation is exact. ACMW (arXiv:2312.13262v2), Theorem A:

> (b) the scheme theoretic image `f(X) ⊆ Y` is a sub-abelian scheme over `S`,
> and (c) `f` factors as `X ↠ Z ↪ Y` ... Moreover, `Z = f(X)`, and the
> factorization (0.1) is stable under base change. Moreover, if `S` is of
> characteristic 0 ... then (a), (b), and (c) hold.

That covers both halves of the manuscript's sentence, including "commutes with
base change", verbatim. The relative-dimension repair is also correct and is
genuinely independent of the citation: `n_H = Σ_{h∈H} h` with `|H| = 10` gives
`n_H^2 = 10 n_H`, so `n_H/10` is idempotent; on
`H^1(J,Q) ≅ W_5 ⊗ H^1(E,Q)` the fixed part is `W_5^H ⊗ H^1(E,Q)` of rank
`1 × 2 = 2`, so the image abelian subvariety has dimension one on every fibre.
`dim W_5^H = 1` verified independently above.

*Separatedness extending a generic-fibre equality (`02-envelope.tex:191-195`).*
Correct. The equalizer of two morphisms into a scheme separated over the base is
a closed subscheme of the source. `E` is integral and dominates `B°`, so its
unique generic point lies in the generic fibre; a closed subset containing the
generic point is everything, and reducedness upgrades that to a scheme-theoretic
equality. The revised wording states the equalizer step explicitly, which the
old one-liner did not. The same argument is reused at lines 213-216 to push the
Gram entries from the generic fibre to all of `B°`, and that reuse is legitimate:
`q_H i_{H'}` and `[m]` are two morphisms `E → E` over `B°` agreeing generically,
so they agree at CM fibres too even though `End` is larger there.

*Two- and three-primary dependency (`02-envelope.tex:355-358`).* Correct.
`|ker f| = 6^4 = 2^4 · 3^4`, and the `p`-primary parts have fibrewise order
`p^4` (line 231), so a finite abelian group of that order is the direct sum of
its two- and three-primary parts. Both parts being `S_6`-fixed therefore makes
`ker f` `S_6`-stable. The rewritten sentence states the dependency in the right
order and no longer leaves the exhaustion implicit.

*Polarization class and semicharacter (`02-envelope.tex:359-364`).* Correct. A
polarization is the class `c_1(L) ∈ NS`; by Appell-Humbert, line bundles
realizing a given Hermitian form `H` differ only in the semicharacter, and
translation changes `L` within `Pic^0`. Neither moves `c_1`, so the descent of
the `S_6`-action through the isogeny quotient is a statement about `NS` classes
and is unaffected by those choices. The faithfulness clause that follows is also
correct: `x ↦ g(x) − x` is a homomorphism from a connected group into a finite
group, hence zero.

The downstream contradiction is verified against the source. Hartlieb Theorem
3.1 gives "a natural isomorphism `Aut(J(Y), Ξ) ≅ Aut(Y) × ⟨−1⟩`", which is the
displayed exact sequence, and the kernel of `S_6 → Aut(X)` would be a normal
subgroup of `S_6` of order at most two, so trivial (the normal subgroups of
`S_6` are `1`, `A_6`, `S_6`). Hartlieb Theorem 2.1 ([WY20]) lists exactly six
ambient groups:

> `(Z/3Z)^4 ⋊ Sym(5)`, `(((Z/3Z)^2 ⋊ Z/3Z) ⋊ Z/4Z) × Sym(3)`, `Z/24Z`,
> `Z/16Z`, `PSL(2,11)`, `Z/3Z × Sym(5)`

with orders `9720, 648, 24, 16, 660, 360`. Five are below `720` as the
manuscript says, and `9720 / 720 = 13.5` is not an integer, so Lagrange excludes
`S_6` from the sixth. Every arithmetic claim in that paragraph checks out.

*Finite-generation clause (`03-minimal-class.tex:346-348`).* Correct. For a
finitely generated abelian group `M ≅ Z^r ⊕ T`, `M ⊗ Z_p ≅ Z_p^r ⊕ T_p`; the
free part injects for any single `p`, and the torsion part is detected across
all `p`. So an element vanishing in every `M ⊗ Z_p` is zero. The added clause
states exactly the right reason.

---

## 8. Minor items

**Verdict: CONFIRMED.**

*Explicit reductions (`04-one-step.tex:875-883`).* Correct against
`eq:projective-bundle-nu` (`ν_6(P_T(V)) = rank(V) · ν_6(T)`): `P^1 = P_pt(C^2)`
gives `2 ν_6(pt) = 0`, `P^2 = P_pt(C^3)` gives `3 ν_6(pt) = 0`, and a ruled
surface `P_C(V)` with `V` of rank two gives `2 ν_6(C) = 0` from the curve case.
The classification premise is also right: the minimal surfaces with
non-nef canonical class are `P^2` and the ruled surfaces, and `P^1` is the only
such curve. Blowups of surfaces have point centers, so `eq:blowup-nu` adds only
point summands.

*Genus-eight bundles as fourfolds (`04-one-step.tex:1206-1210`).* Correct, and
the new citation holds. Kuznetsov (arXiv:math/0303037v1) Theorem 2.17: "The map
`θ` is a flop in the surface `S_Y`. The map `θ^{−1}` is a flop in the surface
`S_X`", with the setup listing `θ : P_Y(E^*) → P_X(U)` and Theorem 2.18
assembling the diagram for a smooth `V_14` Fano threefold. Kuznetsov's letters
are transposed relative to the manuscript (his `X` is the genus-eight threefold,
his `Y` the Pfaffian cubic), and the manuscript declares its own convention at
lines 1189-1192, so `P_V(U)` and `P_X(E^*)` correspond correctly. Both `U` and
`E^*` are rank two on smooth projective threefolds, so both projectivizations
are smooth projective fourfolds, which is what
`thm:nu6-birational-invariance` needs; the added clause supplies precisely the
hypothesis that was previously left implicit. The arithmetic
`2 ν_6(V) = ν_6(P_V(U)) = ν_6(P_X(E^*)) = 2 ν_6(X) = 4` is consistent, and the
introduction's claim that this is obtained "without using the classical
birationality with a cubic" is accurate: the proof uses the flop of the two
projective bundles, not the birational equivalence `V ⇢ X`.

*Coefficient-extension reminders (`04-one-step.tex:410-414`, `572-576`).*
Correct and consistent with the paper's own frame discipline at lines 153-156
("Adjoining roots of Novikov monomials is an algebraic coefficient extension and
is harmless ... Adjoining a root of `z`, by contrast, would replace the original
loop"). `q` is a Novikov variable in both papers, so adjoining `q^{−1/s_c}` or
`q^{−1/r'}` leaves `z` untouched. Both parity rules match their sources verbatim
(blowup (5.11) and Iritani-Koto (5.1)).

---

## Defects, ranked by severity

| # | Severity | File and line | Defect |
|---|----------|---------------|--------|
| D1 | medium-low | `sections/04-one-step.tex:805-811`, `826-834` | The coefficient automorphism `σ` in (4.6b) is the identity under the application as written. Line 801 applies `lem:formal-base-shift` "with `η = Σ_i t_i D_i`", putting the whole divisor direction in the positive-filtration slot, so `a_2^circ = 0` and (4.1) is trivial. Reading `σ` instead as `Q^d ↦ e^{Σ t_i (D_i·d)} Q^d` would need `a_2^circ = Σ t_i D_i`, which violates the lemma's hypothesis at line 247 that `a_2^circ` is constant in the positive filtration. The conclusion holds either way; the closing "do not compete" paragraph describes a split with an empty first factor. |
| D2 | low | `sections/04-one-step.tex:489-491` | Iritani's `F_N` (proof of Prop 5.4, via `Ω_N`) is described as ordering monomials "first by ample Novikov degree and then by bulk weight" and as "multiplicative". `Ω_N` is a disjunction of three conditions, not a lexicographic order, and the filtration is not multiplicative: `Q^δ` with `ω_W·δ = N` times `θ_{i,M}` lies in neither `Ω_{N+M}` clause. Not load-bearing (the paper builds its own weight `w` at 440-457 and its own `J_j`-adic filtration), but the cited object is mischaracterized. |
| D3 | low | `sections/04-one-step.tex:625-631` | The scaled generator family `q^{k/r} τ̂_{i,k}` is attributed to `\cite[(5.3)]{IritaniKoto}`. (5.3) is `C[z][[q^{−1/r'}, q^{−c1(V)/r}Q, σ]]` with the unscaled base bulk parameter; the scaled convention `q^{•/r}τ = {q^{k/r}τ^{i,k}}` is Proposition 5.6's. Cite Prop 5.6 for the third family. |
| D4 | low | `sections/04-one-step.tex:632-634` | "Its exponent monoid is generated by these variables, finitely many because `0 ≤ k ≤ r−1`." The bulk generators are finite, but the Novikov generators `Q^d`, `d ∈ Eff(B)`, are generally infinite. What the argument needs (finitely many monomials below any ample degree) does hold; the sentence overstates. |
| D5 | low | `sections/02-envelope.tex:43-52` vs `82-83` | `prop:six-axis-polarization` is stated for the Fano surface of "a smooth member" (lines 17-19) but its proof invokes "the preceding generic non-CM argument" and "the generic elliptic quotients", which the new qualification at lines 36-41 restricts to the geometric generic point. The extension to all smooth fibres is made only later, at lines 213-216. The overall logic is complete; the statement/proof boundary of the proposition is not. |
| D6 | low | `sections/04-one-step.tex:773` | "The domain hypothesis on `gr_v(A)` enters exactly here" under-counts: it also enters at lines 768-770, where `Frac(gr_v A)` is formed. Also the "so" chain at 774-775 presents `v(χ(Q^d)) = ℓ(d)` as a consequence of the domain hypothesis when it is hypothesis (4.5). |
| D7 | very low | `sections/05-synthesis.tex:9-27` | Each corollary proof supplies only the `CH_0` source; the projective-bundle step and `thm:every-cubic` are carried by the preamble at 4-7. A proof environment read in isolation stops short of its stated conclusion. |
| D8 | very low | `sections/01-introduction.tex:27-29` | `\cite[Remark~3.7]{YYZ}` is scoped to the cubics of YYZ Theorem 1.1, but the manuscript's sentence needs only "birational to some smooth cubic threefold", which is classical for genus-eight Fano threefolds. The citation reads as broader than it is. |
| D9 | very low | `sections/04-one-step.tex:460-461` | "(5.45), (5.47), and the initial asymptotics (5.27)-(5.30)" are bare equation numbers with no `\cite` key in that sentence. All four belong to `IritaniBlowup` and all four carry the attributed content, but the reader has to infer the source. |

None of these invalidates a theorem, corollary, or lemma.

---

## Not verified, and why

1. **That `X x P^1` irrational is new for the loci in question.** Judging
   priority against the whole literature is outside a cold read of the session
   diff. What I did check is that the manuscript does not misattribute the
   sources it names, and that its hedges (lines 76-78, 137-139, and the closing
   paragraphs of `05-synthesis.tex`) are accurate.
2. **The Riemann-Roch trace formula at `02-envelope.tex:106-115`.** Grieve
   (arXiv:1603.06425v2) Theorem 4.1(a) is the reduced-norm Riemann-Roch
   identity `(D^g)/g! = deg φ_λ · Nrd_λ(α)`. The manuscript says the displayed
   trace identity is "obtained by polarizing" it, which correctly flags the step
   as a derivation, but I did not re-derive the second polarization of a degree-five
   reduced norm. It is not among the numbered items and was not touched by this
   session's diff.
3. **Roulleau's intersection data** (`\cite[Theorem~11(D), Lemma~14,
   Corollary~16, (3.1), Lemma~17]{Roulleau}`, arXiv:1002.4467). Cached but not
   checked; unchanged by this session's diff, and the numbered items do not
   cover it. The Gram computation `D_tot^2 = 180`, `F_H · F_{H'} = 24` depends
   on it.
4. **The Brauer-atlas endomorphism rings** `End_{A_5}(H_2) = F_4` and
   `End_{A_5}(H_3) = F_3` (`02-envelope.tex:10-15`). Cited to an online table;
   not independently recomputed. Unchanged by this session.
5. **`prop:cubic-packet` and the Cai input** (`\cite{Cai}`,
   arXiv:2608.01577v1), and the KKPYY nef-canonical normal form. Outside the
   eight numbered items and unchanged by the session's diff except for the
   introduction's framing sentence, which matches the bibliography.

---

## Build gate

`make check` in `papers/cubic-stabilization-m1` exits 0; latexmk reports
all targets up to date, so the committed PDF matches the committed sources.

---

## Resolution of the nine defects (author, 2026-08-14)

Everything above this line is the cold reader's text, unedited. All nine
defects were repaired in the commit that adds this section; the paper still
builds warning-free at 29 pages.

- **D1.** The application does put the whole tagging direction in the positive
  filtration, so `a_2^circ = 0` and the lemma's substitution is the identity.
  Equation (4.6b) now reads `p^tag = p^spec`, the application says explicitly
  that it is invoked with `a_0 = 0` and `a_2^circ = 0`, and the closing
  paragraph now states the dichotomy correctly: a constant divisor component
  becomes the coefficient substitution, a positive-filtration component is
  removed by the gauge, tagging uses only the second, and the blowup and
  projective-bundle comparisons are where the first is used.
- **D2.** The order and its multiplicativity are now presented as the paper's
  own, with Proposition 5.4 cited only for the fact used, that the comparison
  maps respect Iritani's filtration.
- **D3.** The scaled bulk variables are now attributed to Proposition 5.6,
  with (5.3) cited for the unscaled ring.
- **D4.** The finite-generation overstatement is gone: the bulk generators are
  finitely many, and the Novikov generators are handled by ampleness leaving
  finitely many below a given degree.
- **D5.** The proof of the six-axis polarization proposition now opens by
  saying the entries are computed at the geometric generic point and extend to
  every smooth fibre by the separatedness argument in the relative six-axis
  lemma.
- **D6.** The domain hypothesis is now said to be used twice: for
  `Frac(gr_v A)` and for multiplicativity of the valuation. The valuation of a
  monomial image is credited to the admissibility hypothesis, not to the
  domain hypothesis.
- **D7.** Each corollary proof now ends by handing off to the shared preamble.
- **D8.** The Yang-Yu-Zhu Remark 3.7 citation is scoped to their own cubics,
  and the birational-class sentence no longer leans on it.
- **D9.** The bare equation numbers now sit inside a `\cite` to the blowup
  paper.

The reader's exposition nit under item 1 is the same point as D7 and was fixed
with it. Nothing in the report's "not verified" list was resolved here; those
items remain open and are unchanged by this session.
