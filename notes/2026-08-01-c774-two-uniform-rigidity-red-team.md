# C774 — adversarial red-team of the 2-uniform approximate-rigidity note (2026-08-01)

**Lane**: `ame-lu`. Read-only outside this report and artifacts on the `2026-08-01-c774-*` stem.

Source under review: `2026-08-01-external-session-notes/approximate_rigidity_of_2uniform_states.md`
(with the known-defect list in that directory's `README.md`).
Numerical context already certified elsewhere: `2026-08-01-external-source-numerics.md`.

No novelty assertion is made anywhere in this report; priority is C775's job.

## Summary

Nothing in the note is broken. The engine — the second-moment identity — is sound and is in fact
stronger than claimed (a genuine isometry, not only a norm identity), so all four results stand.
Two proofs need repairs, both of the kind the task brief anticipated, and both are supplied here as
statements ready to drop into a manuscript. The one substantive scope correction is that Theorem B's
advertised independence of the number of parties applies to the *constant* but not to the *region of
validity*: I exhibit an infinite family of 2-uniform states on which the bound fails at defect
`≈ 1.34 n^{-1/2}`, so no threshold uniform in `n` can exist. The flagged risk of a lost factor of `q`
in the 2-unitary gate normalization is not real — that normalization is correct. The cross-programme
falsifier passes, and yields a sharper purely coding-theoretic statement with a direct proof.

Verdicts are tabulated in §7. Computational artifacts are on this task's stem:
`2026-08-01-c774-red-team-checks.py` / `.json` / `.sha256`.

## 1. The second-moment identity

**Verdict: SOUND**, and in fact stronger than the note claims.

Checked by hand, line by line. With `M = Σ_j h_j^(j)`, `h_j` traceless Hermitian, and ψ
2-uniform:

- `<M> = Σ_j tr(ρ_j h_j) = Σ_j tr(h_j)/q = 0`. This uses only 1-uniformity, which follows from
  2-uniformity by partial trace, so the note's parenthetical is correct.
- Diagonal terms: `<(h_j^(j))²> = tr(h_j²)/q = ||h_j||_F²/q`.
- Cross terms: `tr(ρ_jk (h_j ⊗ h_k)) = tr(h_j) tr(h_k)/q² = 0`. Vanishing needs both maximal
  mixedness of the pair marginal *and* tracelessness; the note says so.
- Hence `||Mψ||² = <M²> = (1/q) Σ_j ||h_j||_F²`, which is (★).

**The strengthening.** The note asserts an isometry but only proves the norm identity. The full
polarized statement holds. For two tuples `(h_j)`, `(h'_j)`,

```
<Mψ, M'ψ> = <ψ| M M' |ψ> = (1/q) Σ_j tr(h_j h'_j) ,
```

with the imaginary part exactly zero. Real part: the anticommutator's cross terms are again
`tr(h_j) tr(h'_k)/q² = 0`. Imaginary part: `<[M,M']>/2i = Σ_j tr([h_j, h'_j])/(2iq) = 0`, because
operators on distinct sites commute and every commutator is traceless. So the map
`(h_1,…,h_n) ↦ √q · Mψ` is a genuine real-linear isometry from `⊕_j {traceless Hermitian}` with the
product Frobenius inner product into the Hilbert space viewed as a real inner-product space. That
is the statement the manuscript should make; it is what makes "the Hessian is exactly isotropic"
literally true rather than a norm-only coincidence.

**Scope.** The identity uses 2-uniformity only through `ρ_jk = I/q²`; the exact hypothesis needed is
`ρ_jk = ρ_j ⊗ ρ_k = I/q²` for every pair, i.e. nothing weaker than 2-uniformity but nothing more.
Nothing about stabilizer structure, about `n`, or about AME-ness enters. Confirmed: this is the
engine, and the engine runs.

## 2. Theorem A — discreteness

**Verdict: SOUND WITH REPAIR.** The conclusion is correct as stated; the proof as written skips one
genuine step, and the repair proposed in the task brief is the right one and is correct. I checked
it and give the exact statement below.

**The gap.** The note starts "let `t ↦ U(t)` be a one-parameter subgroup of `G(ψ)` with generator
`(iH_1,…,iH_n)`". A one-parameter subgroup of `G(ψ)` is a priori only a continuous homomorphism
`R → U(q^n)` landing in `G(ψ)`; its generator is some anti-Hermitian `X` on the full `q^n`-dimensional
space. That `X` has summed local form `i Σ_j H_j^(j)` is exactly what needs proof. Choosing local
factors `U_j(t)` continuously in `t` is also not free: the factors of a product unitary are only
determined up to phases, so a naive "differentiate each factor" argument has a lifting obligation.

**The repair, verified.** Let `π : U(q)^n → U(q^n)`, `(U_1,…,U_n) ↦ ⊗_j U_j`. Then:

1. `π` is a homomorphism of Lie groups (the tensor product of unitaries is multiplicative
   factorwise), and it is smooth.
2. `U(q)^n` is compact, so `P := π(U(q)^n)` is a compact, hence closed, subgroup of `U(q^n)`. By
   Cartan's closed-subgroup theorem `P` is an embedded Lie subgroup, and since `π` is a surjective
   smooth homomorphism onto the compact Lie group `P`, its differential is surjective onto `Lie(P)`.
   Therefore
   ```
   Lie(P) = dπ( u(q)^n ) = { i Σ_j H_j^(j) : H_j Hermitian on C^q } ,
   ```
   with `ker dπ = {(iτ_1 I,…,iτ_n I) : Σ_j τ_j = 0}` of dimension `n−1`.
3. `G(ψ) = P ∩ { U : Uψ ∈ Cψ }` is an intersection of closed subgroups of `U(q^n)`, hence a compact
   Lie group, and `Lie(G(ψ)) ⊆ Lie(P)`.

Consequently any `X ∈ Lie(G(ψ))` is `X = iL` with `L = Σ_j H_j^(j)` Hermitian, and the note's
two-line computation then applies verbatim: `Lψ = θ'(0) ψ`, split `L = M + cI` with `M` the
traceless-part sum, take the inner product with ψ, use `<M> = 0` to get `θ'(0) = c`, hence `Mψ = 0`,
hence by (★) every `h_j = 0`. So `Lie(G(ψ)) = i R I`.

Finally `U(1)·I ⊆ G(ψ)` is a closed central subgroup of dimension 1, so `G(ψ)/U(1)` is a compact
Lie group of dimension 0, i.e. finite.

**Statement the manuscript needs** (insert as a lemma before Theorem A):

> **Lemma A0.** The product map `π : U(q)^n → U(q^n)` is a homomorphism of compact Lie groups. Its
> image `P` is a closed subgroup of `U(q^n)` with `Lie(P) = { i Σ_j H_j^(j) : H_j = H_j† }`. Hence
> every one-parameter subgroup of any closed subgroup of `P` — in particular of `G(ψ)` — has a
> generator of summed local form.

**One bookkeeping point the manuscript must not fumble.** Upstairs in `U(q)^n` the symmetry group
`G̃ = π^{-1}(G(ψ))` contains the full local-phase torus `T = {(e^{iθ_1}I,…,e^{iθ_n}I)} ≅ U(1)^n`, of
dimension `n`, not 1. There is no conflict with Theorem A: `π(T) = U(1)·I` and `ker π ⊂ T` has
dimension `n−1`, so `G̃/T ≅ G(ψ)/U(1)·I` is finite. Theorem B' works upstairs, so it must quotient by
`T`, i.e. work on `PU(q)^n`, not by a single global phase. The note's phrase "modulo the phase
identifications" is right but is doing more work than it looks like.

**Adversarial checks that passed.** `G(ψ)` is genuinely a group (products and inverses of product
unitaries are product unitaries). `U(1)·I ⊆ G(ψ)` since `e^{iθ}I = ⊗_j e^{iθ/n} I`. The claim
"2-uniform states require `n ≥ 4`" is correct: at `n = 3`, `rank ρ_12 = q²` but `rank ρ_12 = rank ρ_3
≤ q`. The claim "every AME(2m,q), m ≥ 2, is 2-uniform" is correct by definition. The Bell remark
(remark 2) is correct: for `n = 2`, `M = h ⊗ I − I ⊗ h^T` kills `|Φ⟩` and the cross term in (★) is
exactly what survives. The GHZ remark (remark 3) is correct and is re-derived independently in §5
below.

**No hidden stabilizer or AME hypothesis.** Confirmed: only `ρ_jk = I/q²` is used. The note's claim
that the stabilizer hypothesis in the exact rigidity theorem is doing only the group-identification
job is supported by this proof.

## 3. Theorem B — stability, and Corollary B'

### 3.1 The inequality itself: SOUND

Every step of the proof checks out, including the two places where a Taylor argument for operators
usually goes wrong.

- `U = ⊗_j e^{i h_j} = e^{iM}` exactly, with no leftover scalar, because the `h_j` are traceless.
  (The note's "up to the scalar already absorbed" is a harmless leftover from §1.)
- `eps(U)² = 2 − 2|<U>|` is the correct closed form of `min_θ ||Uψ − e^{iθ}ψ||`.
- The remainder bound is legitimate as an operator statement: `r(M)` is normal with eigenvalues
  `r(λ_i)`, so `|<r(M)>| ≤ Σ_i p_i |λ_i|³/6 = <|M|³>/6 ≤ t <M²>/6` with `p_i = |<ψ|v_i>|² ≥ 0`.
- The step to `|<e^{iM}>|` is a modulus bound on a complex number and is valid:
  `|<e^{iM}>| ≤ |1 − <M²>/2| + |<r(M)>|`, and `|1 − <M²>/2| = 1 − <M²>/2` needs `<M²> ≤ 2`, supplied
  by `<M²> ≤ t² ≤ 1/4`.
- `1/2 − t/6 ≥ 5/12` at `t ≤ 1/2`, so `eps² ≥ (5/6)<M²> = (5/6q) D²`. Arithmetic confirmed;
  `√(6/5) = 1.0954… < 1.096`.

The lower bound also holds in the other direction (`|z| ≥ Re z` gives `eps² ≤ <M²>(1 + t/3)`), so the
two-sided statement is `eps² = (D²/q)(1 + O(t))` with explicit constant `1/3`. The note's
"asymptotically sharp" is a wording defect: the constant `√(6q/5)` is not sharp, it is within 9.5%
of the sharp constant `√q`. The manuscript should say "sharp up to 9.5%" or prove the sharp form.

**A remark worth adopting.** The true constant `√q` is not merely numerical, as the note's §6
narration ("the D/(√q·eps) → 1 column confirms the Hessian constant is exactly 1/q") suggests. It is
proved: the two-sided estimate above plus (★) gives `eps²/D² → 1/q` uniformly in `n`, for every
2-uniform state. That deserves to be a displayed corollary rather than a comment on a table.

### 3.2 The advertised n-independence: NARROWER THAN STATED

This is the substantive finding of the section, and it is the one a referee will push on.

The **constant** `√(6q/5)` is genuinely independent of `n`. The **region where the theorem says
anything** is not, and this is not an artifact of the crude Taylor step.

First, the hypothesis is intrinsically an `O(1/n)` per-site condition. For traceless `h_j`,

```
||Σ_j h_j^(j)||_op = max( Σ_j λ_max(h_j), − Σ_j λ_min(h_j) )  ≥  (1/2) Σ_j ||h_j||_op ,
```

because the operator norm of a sum of single-site terms is attained on a product of extremal local
eigenvectors. So `t` and `Σ_j ||h_j||_op` are equivalent up to a factor of 2, and demanding `t ≤ 1/2`
forces the per-site generators to shrink like `1/n`. Inside that window, generators spread evenly
over the sites satisfy `D² ≤ q Σ_j ||h_j||_op² ≤ q/(4n)`, i.e. the certified radius in the product
Frobenius metric is `D = O(√(q/n))` and in defect is `eps = O(n^{-1/2})`.

Second, that shrinkage is real. Take the CSS coset state of `RM(1,m)`, length `N = 2^m`, which is
3-uniform for `m ≥ 3` (`d = N/2`, `d(C^⊥) = 4`) and therefore 2-uniform, and take the aligned
generators `h_j = c Z` on every site. The weight enumerator has weights `{0, N/2, N}` with
multiplicities `1, 2N−2, 1`, so with `θ := N c` everything is closed-form:

```
<U>   = 1 − (1 − cos θ)/N ,
eps   = 2 |sin(θ/2)| / √N ,
D     = θ √2 / √N ,
D / (√q · eps)  =  θ / ( 2 sin(θ/2) )        (independent of N).
```

The ratio function `θ ↦ θ/(2 sin(θ/2))` crosses `√(6/5)` at `θ* = 1.46562` (computed in the
certificate), and `Σ_j ||h_j||_op = θ` exactly for this family. Consequences:

1. **The smallness hypothesis is necessary, and the constant `1/2` in it is within a factor 2.9 of
   sharp.** Theorem B's conclusion is false once `Σ_j ||h_j||_op` exceeds about 1.47, for every
   length in this infinite family.
2. **No `n`-uniform version of Theorem B exists.** At `θ = θ*` the defect is
   `eps = 2 sin(θ*/2)/√N ≈ 1.338 / √N`, which tends to 0. So over the class of all 2-uniform states
   there is no absolute `ε₀ > 0` such that `eps(U) < ε₀` implies `D ≤ √(6q/5) eps(U)`; any valid
   threshold satisfies `ε₀ ≲ 1.34 n^{-1/2}`.

Verified numerically at `N = 16` on the explicit 65536-amplitude state, by two independent routes
(overlap formula and phase-optimized norm, agreeing to ten decimals):

| `c`     | sum of op norms | `D`     | `eps`   | `D/(√q·eps)` | hypothesis | bound   |
|---------|-----------------|---------|---------|--------------|------------|---------|
| 0.03125 | 0.50            | 0.17678 | 0.12370 | 1.01049      | holds      | holds   |
| 0.05    | 0.80            | 0.28284 | 0.19471 | 1.02717      | fails      | holds   |
| 0.0625  | 1.00            | 0.35355 | 0.23971 | 1.04291      | fails      | holds   |
| 0.09375 | 1.50            | 0.53033 | 0.34082 | **1.10029**  | fails      | **fails** |
| 0.1     | 1.60            | 0.56569 | 0.35868 | **1.11521**  | fails      | **fails** |

To close the escape route that the violating `U` might simply be near a *different* exact symmetry,
I enumerated the entire diagonal symmetry group of the `RM(1,4)` coset state — order `2^17`,
invariant factors `1^5 2^6 4^4 8^1`, recomputed here independently of the diagonal-note figures and
agreeing with them — and computed the exact minimum product-Frobenius distance from `U` to it. The
minimum is attained at the identity, at `0.53033`. Every non-identity diagonal exact symmetry is at
distance `≥ 2.2`, and the nearest Pauli and transversal-`T` symmetries are at `2.2` or beyond. So no
rebasing rescues the bound in the diagonal sector.

Artifacts: `2026-08-01-c774-red-team-checks.py`, `.json`, `.sha256` (replay command in the script
docstring; `--check` recomputes and compares, exiting nonzero on mismatch).

**What the manuscript must therefore not say.** The §3 "two features worth emphasizing" bullet
("verifying an AME resource state with local Clifford measurements inherits an n-uniform robustness
constant") overstates the result. The correct sentence is: the *ratio* constant is `n`-independent,
but the certified neighbourhood shrinks like `n^{-1/2}` in defect, and this rate is attained. That
is still a useful theorem — it is exactly the regime a self-testing argument reaches after a union
bound over sites — but it is not `n`-uniform certification.

### 3.3 Corollary B' — the compressed proof: SOUND WITH REPAIR

The corollary is true as literally stated (`ε₀` is allowed to depend on ψ), but its proof
compresses three separate things and drops one hypothesis outright.

**Dropped hypothesis (a genuine defect).** As written, `U = g · ⊗_j e^{i h_j}` puts no size
constraint on the `h_j`, so `D` is the norm of an arbitrary traceless logarithm and the conclusion is
false as stated. For `q = 2`, `h_j = π·diag(1,−1)` is traceless with `⊗_j e^{i h_j} = (−1)^n I`, so
`eps = 0` while `D = π √(2n) > 0`. The statement needs the minimal-lift condition — cleanest is to
carry Theorem B's own hypothesis, `Σ_j ||h_j||_op ≤ 1/2`, into the conclusion.

**The two steps the proof runs together.** Separate them as follows.

> **Step 1 (quadratic growth; uses only Theorem B, hence only (★)).** Work on `X = PU(q)^n`, on which
> `f(U) = eps(U)²` is well defined. Let `B ⊂ X` be the image of `{ (h_j) traceless : Σ_j ||h_j||_op ≤
> 1/2 }` under the exponential. Theorem B gives `f ≥ (5/6q) D²` on `B`, where `D` is the product
> Frobenius distance to the identity coset. Because the product Frobenius metric on `U(q)^n` is
> bi-invariant and `f(Vg) = f(V)` for every `g ∈ G̃`, the same estimate holds on `gB` with `D` the
> distance to `g`, for every `g` in the zero set.

> **Step 2 (isolation and the global threshold; uses finiteness).** The zero set of `f` on `X` is
> `Z = G̃/T`, finite by Theorem A. Hence `⋃_{g ∈ Z} gB` is an open neighbourhood of `Z`, its
> complement `K ⊂ X` is compact, and `f > 0` on `K`, so `δ := min_K f > 0`. Put
> `ε₀ = min( √δ , (5/6q)^{1/2} · ρ )` where `ρ` is the `D`-radius of `B`. If `eps(U) < ε₀` then
> `U ∉ K`, so `U ∈ gB` for some `g ∈ Z`, and Step 1 applies at that `g`.

Two corrections this separation exposes.

1. **The note attributes isolation of zeros to the Hessian and finiteness to the exact rigidity
   theorem plus Theorem A. That is backwards in one direction and redundant in the other.**
   Isolation follows from Step 1 alone. Finiteness then follows from isolation plus compactness of
   `X` — so it is a *consequence* of (★), not an extra input. What the exact rigidity theorem
   contributes to B′ is only the *identification* of the `g` as local Clifford operators. B′'s
   existence half needs no stabilizer hypothesis at all and holds for every 2-uniform state; only
   the words "exact local-Clifford symmetry" need the stabilizer AME hypothesis. This is a
   strengthening the manuscript should take.
2. **"Hessian bounded below by `(5/6q)·(product Frobenius metric)"` mixes conventions** (a Hessian
   lower bound of `H` gives `f ≳ (1/2) H D²`). Theorem B already delivers the stronger,
   convention-free statement `f ≥ (5/6q) D²` on a ball of definite radius, so the Hessian language
   should be dropped rather than repaired.

**And the scope caveat carries over.** `ε₀` in B′ depends on `n` through both ingredients: the
radius of `B` shrinks like `n^{-1/2}` in defect (§3.2), and `δ` is a compactness constant on an
`n(q²−1)`-dimensional manifold with no uniformity in `n`. §3.2 shows the first dependence is not
removable.

## 4. Proposition C and Corollary D

### 4.1 Proposition C — Fisher isotropy: SOUND

`U(s) = ⊗_j e^{i s h_j} = e^{i s M}` with `M` independent of `s`, so the family is a genuine
one-parameter unitary family with constant generator, and for pure states the quantum Fisher
information of such a family is `F_Q = 4 Var_ψ(M)`. With `<M> = 0` and (★),
`F_Q = 4 <M²> = (4/q) Σ_j ||h_j||_F²`. Nothing else is used. The isotropy statement is exactly the
polarized form of (★) established in §1, so §1's strengthening is what makes "exactly isotropic
multiple of the Euclidean form" a theorem about the quadratic *form* rather than about its diagonal
only.

The interpretive claims check out too. Kernel directions: for a pure state `Var_ψ(M) = 0` iff
`Mψ = <M>ψ` iff `e^{isM}ψ ∝ ψ` for all `s`, so degenerate Fisher directions are *exactly* continuous
product symmetries — the equivalence the note asserts. The GHZ contrast is right by a direct check:
for `h_j = Z` on `GHZ_n`, `M = Σ_j Z_j` has `<M²> = n²`, against `<M²> = n` that (★) would give for a
2-uniform state with the same generators, so the Heisenberg-versus-standard-limit gap is a factor
`n` in `F_Q` as claimed.

The only thing to tighten for a manuscript is the quantifier: "no direction is enhanced and none is
degenerate" is a statement about the traceless *local* generator space, not about all generators;
non-product generators are untouched by (★).

### 4.2 Corollary D — 2-unitary gauge groups: SOUND WITH REPAIR

**The metric normalization is correct.** I checked this explicitly, since it is the flagged risk.
Vectorize `ψ ∈ (C^q)^{⊗4}` across `(12|34)` as `ψ_{ijkl} = W_{kl,ij} / q`. Normalization is
consistent: `<ψ|ψ> = ||W||_F² / q² = q²/q² = 1`, using `||W||_F² = q²` for a unitary on `C^q ⊗ C^q`.
A product unitary acts as `W ↦ (u_3 ⊗ u_4) W (u_1 ⊗ u_2)^T`, so

```
|| Uψ − e^{iθ}ψ ||  =  q^{-1} · || W' − e^{iθ} W ||_F ,
```

i.e. the state defect equals the gate defect in the metric `q^{-1}||·||_F`. That is exactly what the
note writes. The factor of `q` is **not** lost: the normalization is `1/√(dim) = 1/√(q²) = 1/q`.
Verdict on the normalization: correct.

Three repairs the corollary does need.

1. **State the correspondence as an isometric isomorphism, not a slogan.** The right-hand factors
   appear transposed. Transposition preserves the Frobenius norm and `u ↦ ū` is a group automorphism
   of `U(q)`, so `(u_1,u_2,u_3,u_4) ↦ (ū_1, ū_2, u_3, u_4)` is an isometric group isomorphism
   carrying `G(ψ)` onto the gauge group of `W`, and it fixes `D = (Σ_j ||h_j||_F²)^{1/2}`. Without
   this sentence "Theorem B holds verbatim" is an assertion.
2. **"Finite modulo global phase" should read "modulo the local phases".** The gauge group lives in
   `U(q)^4` and contains the 4-torus of local phases; what is finite is its quotient by that torus.
   Same bookkeeping point as §2, and it matters more here because the dual-unitary literature's
   gauge group is customarily written with independent local phases.
3. **The corollary inherits both of Theorem B's hypotheses and B′'s non-explicit threshold.**
   "Theorem B holds verbatim" omits `Σ_j ||h_j||_op ≤ 1/2`, and "lies within `√(6q/5)·eps` of an
   exact one" is a B′-type statement requiring an `ε₀(W)` that is not exhibited. Here `n = 4` is
   fixed, so the `n`-dependence of §3.2 is harmless — but the threshold is still non-explicit, and
   the corollary should say so rather than reading as an unconditional bound.

With those three, the corollary is correct. Note also that its hypothesis class is exactly right:
2-unitary gates correspond to AME(4,q) states, which are 2-uniform by definition, so the corollary
covers every 2-unitary gate with no extra assumption (and is vacuous at `q = 2`, where AME(4,2) does
not exist).

## 5. Cross-programme check: CSS coset states

**Result: the two programmes agree, and the coding-theoretic statement is sharper than what
discreteness gives. No falsification.**

### 5.1 What each side says

For a binary linear code `C ⊆ F_2^n`, the CSS coset state `|C⟩ ∝ Σ_{x ∈ C} |x⟩` is `k`-uniform with
`k = min(d(C), d(C^⊥)) − 1`, so it is 2-uniform exactly when `d(C) ≥ 3` and `d(C^⊥) ≥ 3`. Theorem 1
of the diagonal-rigidity note gives its diagonal symmetry group as
`A = Hom(Z^n / Λ_C, R/2πZ) ≅ T^{n−r} × ∏_i Z/d_i` with `r = rank_Q Λ_C`, where `Λ_C` is the Z-span
of the 0/1 lifts of the codewords. So `A` is finite iff `r = n`.

Theorem A of the 2-uniform note says the whole product-symmetry group is finite mod phase, hence in
particular `A` is finite. Therefore Theorem A *implies*:

> `d(C) ≥ 3` and `d(C^⊥) ≥ 3`  ⟹  `rank_Q Λ_C = n`.

### 5.2 The direct coding-theoretic proof, and a sharpening

The implication is true, and only the dual condition is needed.

> **Proposition.** For every binary linear code `C ⊆ F_2^n`,
> `rank_Q Λ_C = n` **if and only if** `d(C^⊥) ≥ 3`.
> (Convention: `d(C^⊥) = ∞` when `C^⊥ = 0`.)

**Proof.** Write `C = {uG : u ∈ F_2^k}` for a generator matrix `G` with columns `g_1,…,g_n ∈ F_2^k`.
Over `F_2`, `d(C^⊥) ≥ 3` says precisely that `G` — the parity-check matrix of `C^⊥` — has no zero
column and no two equal columns.

*(⇐)* Let `φ ∈ R^n` annihilate `Λ_C`, i.e. `φ · lift(x) = 0` for every `x ∈ C`. The lift identity
gives, for `x_1,…,x_m ∈ {0,1}^n`,
`lift(x_1 ⊕ ⋯ ⊕ x_m) = Σ_{∅ ≠ T} (−2)^{|T|−1} ∧_{i ∈ T} x_i`
(per coordinate, `⊕ a_i = (1 − ∏(1 − 2a_i))/2`). Induct on `m`: the left side is annihilated because
`x_1 ⊕ ⋯ ⊕ x_m ∈ C`, every proper term is annihilated by the inductive hypothesis, so the surviving
term forces `φ · (x_1 ∧ ⋯ ∧ x_m) = 0`. Hence `φ` annihilates every meet of codewords.

Now fix a coordinate `j` and let `m_j = ∧ { x ∈ C : x_j = 1 }`. The set is nonempty because `g_j ≠ 0`
(there is `u` with `u·g_j = 1`). For `k ≠ j`, `g_j ≠ g_k` and both are nonzero, so over `F_2` they are
linearly independent, so there is `u` with `u·g_j = 1` and `u·g_k = 0`; that codeword is in the meet
and kills coordinate `k`. Hence `m_j = e_j`, so `φ_j = 0`. As `j` was arbitrary, `φ = 0` and
`rank_Q Λ_C = n`.

*(⇒)* If some `g_j = 0` then every codeword has `x_j = 0` and `Λ_C ⊆ {v : v_j = 0}`. If `g_j = g_k`
for `j ≠ k` then every codeword has `x_j = x_k` and `Λ_C ⊆ {v : v_j = v_k}`. Either way the rank is
at most `n − 1`. ∎

The forward direction is the same lift-identity mechanism as the diagonal note's Cascade Lemma
(case `N = 2^ℓ` with the divisibility bookkeeping dropped, since over `Q` powers of 2 are units); the
new content is the meet-isolation step and the exact converse.

**Why this is a sharpening.** Theorem A delivers the implication only under the two-sided hypothesis
`min(d, d^⊥) ≥ 3`. The proposition shows `d(C) ≥ 3` is irrelevant to lattice rank — which is what one
should expect, since only the `X`-type stabilizers (the codewords) enter the diagonal sector at all.
Combined with the diagonal note's Theorem 1: **the diagonal symmetry group of a CSS coset state is
finite exactly when `d(C^⊥) ≥ 3`**, a clean and decidable criterion.

### 5.3 Exhaustive falsifier run

The equivalence was tested on **every** binary linear code of length `n ≤ 7` — all 32,501 subspaces
of `F_2^n` for `n = 1..7`, enumerated by reduced row echelon form, with `rank_Q Λ_C` computed by
exact rational elimination on the lifts of all codewords and `d(C^⊥)` by full enumeration of the dual.

| `n` | subspaces | agreements | counterexamples |
|-----|-----------|------------|-----------------|
| 1   | 2         | 2          | 0               |
| 2   | 5         | 5          | 0               |
| 3   | 16        | 16         | 0               |
| 4   | 67        | 67         | 0               |
| 5   | 374       | 374        | 0               |
| 6   | 2825      | 2825       | 0               |
| 7   | 29212     | 29212      | 0               |

Consistency with the existing bundle: the repetition code, the one code in
`2026-08-01-external-source-numerics.md` with a rank-deficient lattice, has
`C^⊥ =` even-weight code with `d = 2`, so the proposition predicts exactly the deficiency observed
there, and its state is the GHZ state — the same object the 2-uniform note's remark 3 and its GHZ
control identify as the continuous-symmetry case. The two programmes and both numerical batteries
meet at that single point and agree.

Independent cross-check of a shared figure: this task's certificate recomputes the invariant factors
of `Λ_{RM(1,4)}` from scratch (own Smith-normal-form implementation) and gets `1^5 2^6 4^4 8^1`,
matching the diagonal note and the earlier replay.

## 6. Assessment of the existing numerical bundle

**Sufficient for C774's purposes as far as it goes, with one gap that this task has now closed.**

What `2026-08-01-external-source-numerics.md` and its certificates do establish, and what I am
therefore not repeating: exact 2-uniformity of the AME(4,3) state, the Fisher identity to ten
decimals, the ratio column converging to 1, the GHZ control's exactly-zero defect and its pair
marginal at 0.471, and the 16-qubit Reed–Muller witness carrying a non-Clifford transversal-`T`
symmetry. All of it is consistent with the analysis above, and the ratio column is the numerical
shadow of the two-sided estimate in §3.1 rather than independent evidence for it.

Its own two flagged findings, assessed:

- **The two out-of-hypothesis rows.** Confirmed and quantified. At the source's `s = 0.3` and
  `s = 0.1` the summed operator norms are 2.157 and 0.719 against a hypothesis of 0.5, so those rows
  illustrate a theorem they lie outside. The bundle's recommendation (restrict the range or mark the
  rows) is right, and §3.2 supplies the sharper fix: give the closed-form ratio function
  `θ/(2 sin(θ/2))` for the Reed–Muller family, which shows both why the bound survives just outside
  the hypothesis and where it stops surviving.
- **The defect formula square-rooting machine epsilon.** Real, and the bundle's advice to report
  `||Uψ − e^{iθ}ψ||` is right, but it does not affect any conclusion here: my scan computes the
  defect by both routes at defects between 0.12 and 0.36, where they agree to ten decimals. The
  issue bites only in tables that quote defects near exact symmetries, which the manuscript's §6 does
  not.

**The gap it left, now closed.** Every certified data point in that bundle lies in the regime where
Theorem B's conclusion *holds*; nothing probed the failure side, so nothing tested whether the
smallness hypothesis is load-bearing or decorative. That was the single most important thing to
check about Theorem B, and §3.2 shows the hypothesis is load-bearing and near-sharp. The new
artifacts on this task's stem supply it.

**Still missing, and not needed for a verdict.** No explicit `ε₀` exists for any state (the source's
own follow-up item 1). No test of a non-stabilizer 2-uniform state, so Theorem A's headline claim —
that discreteness holds for non-stabilizer AME states — has no numerical instance anywhere in the
corpus; the proof does not need one, but a referee-facing manuscript would benefit from a single
AME(4,q) non-stabilizer example. Neither affects any verdict below.

## 7. Verdicts

| Claim | Verdict |
|---|---|
| Second-moment identity (★) | **SOUND**, and provably stronger: a true isometry, not just a norm identity |
| Theorem A, discreteness | **SOUND WITH REPAIR** — needs Lemma A0 (§2); no stabilizer hypothesis is hidden |
| Theorem B, the inequality | **SOUND** as stated; "asymptotically sharp" should read "sharp to 9.5%" |
| Theorem B, `n`-independence as advertised | **NARROWER THAN STATED** — certified radius shrinks like `n^{-1/2}`, and that rate is attained |
| Corollary B′, decomposition | **SOUND WITH REPAIR** — add the minimal-lift hypothesis, split the proof into §3.3's two steps; existence half needs no stabilizer input |
| Proposition C, Fisher isotropy | **SOUND** |
| Corollary D, 2-unitary gauge | **SOUND WITH REPAIR** — metric normalization is correct; needs the isometric-isomorphism sentence, "modulo local phases", and the inherited hypotheses |
| Cross-programme coset check | **CONSISTENT**, and sharpened to an iff with `d(C^⊥) ≥ 3` alone |

Method labels: everything in §1–§5.2 is verified by direct hand checking of each step. §3.2's table,
§5.3's exhaustive run, the nearest-symmetry enumeration, and the invariant-factor recomputation are
verified computationally, with a tracked script, certificate and hashes. The scope judgments — that
the `n`-independence sentence overstates the result, that the manuscript should adopt the isometry
form of (★) and the sharp-constant corollary, and that the numerical bundle is sufficient — are my
judgment.

## 8. Mystery ledger

- **Why is the breakdown threshold a constant `Σ_j ||h_j||_op ≈ 1.466` and not length-dependent?**
  Settled by the `ej`/`tt` pass. The ratio for the Reed–Muller family depends on the generators only
  through `θ = Σ_j ||h_j||_op`, because the state's weight enumerator is supported on three weights
  and the aligned generator sees only the total. The apparent `n`-independence of the threshold and
  the `n^{-1/2}` shrinkage of the defect are the same fact in two coordinates.
- **Is `n^{-1/2}` the true rate, or only the rate this family attains?** Open. The Reed–Muller family
  gives the upper bound `ε₀ ≲ 1.34 n^{-1/2}`; no matching lower bound is proved, and the proof of
  Theorem B gives `Ω(n^{-1/2})` only for evenly spread generators. Closing this would turn §3.2 from
  a caveat into a theorem with a matching rate. Evidence gap: a lower bound on `ε₀` uniform over
  2-uniform states at fixed `n`. Owning successor: the explicit-`ε₀` follow-up (source §6 item 1).
- **The `√q` versus `√(6q/5)` gap.** Settled: the sharp constant is `√q` and this is proved, not
  numerical (§3.1). What remains open is whether `√q` is attainable as a *uniform* constant on a
  region of definite radius rather than only asymptotically; the Taylor remainder is the only
  obstruction and a second-order remainder with a `<M⁴>` bound would improve it — but `<M⁴>` needs
  4-uniformity, not 2-uniformity, so the improvement is genuinely conditional on more entanglement.
  That is a clean, well-posed follow-up rather than an unexplained gap.
- **Why does the coset cross-check need only the dual distance when 2-uniformity is two-sided?**
  Settled: only `X`-type stabilizers (the codewords themselves) enter the diagonal sector, so
  `d(C)` is invisible to `Λ_C`. The corollary is that Theorem A is strictly weaker than the truth on
  this class, which is expected — Theorem A constrains all product symmetries, not just diagonal
  ones, and pays for that generality with a stronger hypothesis.
- No other genuine mystery. The remaining soft spots in the source note (non-explicit `ε₀`, the
  literature question) are known open items, not surprises.

---

**Superseded in scope, 2026-08-02.** Section 3.2's shrinkage result is correct and its
family is genuine, but the inference from it was drawn too widely. C786 showed the certified radius
is governed by the uniformity order, not the party count, and that the Reed--Muller family used here
holds uniformity at three for every length. So the conclusion applies to the 2-uniform class and not
to the absolutely-maximally-entangled class the decomposition corollary is stated for, where the
region grows linearly in the party count. The mystery-ledger item asking for a matching lower bound
is resolved by reparameterization rather than by that bound. See
`2026-08-01-c786-explicit-stability-threshold.md`; the manuscript correction is C795.
