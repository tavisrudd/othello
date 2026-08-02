# The recognition group: one criterion with both Van den Nest–Dehaene–De Moor's Theorem 1 and our full-Weyl cover as special cases

**Date:** 2026-08-02
**Lane:** `ame-lu`
**Status:** new mathematics, proved here, not adopted. No manuscript source was
edited. Novelty is **not** claimed and cannot be until the audit gate below is
run.

Companion: `notes/2026-08-02-c804-specialization-inversion.md`, which found that
our Corollary `full-weyl-cover` covers case (iv) of their Corollary 1 but not
their Theorem 1, leaving the reframing open to the charge of generalizing the
weaker of their two statements. This note removes that charge by proving the
statement that has both of their branches and ours as corollaries.

## What they missed, in one paragraph

Their Theorem 1 has two branches proved by two unrelated arguments: a
Rains-type rank argument when a minimal support carries four stabilizer
elements, and a direct factorization when it carries two. The dichotomy is not
a feature of the mathematics. It is an artifact of the local dimension being
two. For a minimal support `ω` of a stabilizer state over `F_q`, the group
`L(ω)` of labels supported inside `ω` injects into `F_q²` under the coordinate
projection at every party of `ω`, so it is an `F_p`-subspace of `F_q²`, of any
dimension from 1 to 2e where `q = p^e`. At `q = 2` the only subspaces are the
two extremes — one nonidentity label, or all three — which is exactly their
`A_ω ∈ {1,3}` dichotomy, and it is why they needed two arguments and saw no
interpolation. Both branches are the same rank statement at different sizes,
and the object both are computing is the same: the additive group of Weyl
labels at a party that a local unitary is forced to carry to Weyl labels. Call
it the **recognition group** `Λ_i`. Every diagonal marginal injects labels into
it, `Λ_i` is a subgroup, and the local factor is Clifford exactly when
`Λ_i = F_q²`. Their Theorem 1 fills `Λ_i` from many small supports; our
Corollary `full-weyl-cover` fills it from one maximal support. Neither
argument reaches the intermediate sizes, which do not exist at `q = 2` and are
the generic case for CSS states at every larger `q`.

## Definitions

Conventions are the manuscript's (`sections/02-geometry-ame-dictionary.tex`):
`W_v = X(a)Z(b)` for `v = (a,b) ∈ F_q²`, so `W_v W_w` is a phase times
`W_{v+w}`, the `q²` operators `W_v` are an orthogonal Hilbert–Schmidt basis, and
a unitary is Clifford when conjugation permutes the projective axes `ℂW_v`.
Labels form the additive group `F_q² ≅ F_p^{2e}`.

Call an operator `R` on `r` parties **partial-Weyl diagonal** if there are a
finite set `P` with a distinguished element `0`, injections `f_i : P → F_q²`
with `f_i(0) = 0`, and nonzero coefficients `λ_v`, such that

  R = Σ_{v ∈ P} λ_v ⊗_{i=1}^r W_{f_i(v)}.

The manuscript's full-Weyl diagonal condition is the case `|P| = q²`, where the
injections are forced to be bijections. Dropping `|P| = q²` to `|P| = N ≥ 2` is
the whole change.

Given a product unitary `U = U_1 ⊗ … ⊗ U_n` carrying `|ψ⟩` to `|φ⟩` up to
phase, define the **recognition group at party `i`**

  Λ_i := { a ∈ F_q² : U_i W_a U_i† ∈ ℂ^× · W_b for some b }.

## Lemma R (the recognition group is a group, and recognizing everything is Cliffordness)

`Λ_i` is a subgroup of `F_q²`, the induced map `a ↦ b` is an injective additive
homomorphism `Λ_i → F_q²`, and `U_i` is Clifford if and only if `Λ_i = F_q²`.

*Proof.* If `U W_a U† = α W_{a'}` and `U W_b U† = β W_{b'}`, then since
`W_a W_b` is a phase times `W_{a+b}`, conjugating that product gives that
`U W_{a+b} U†` is a scalar times `W_{a'} W_{b'}`, hence a scalar times
`W_{a'+b'}`. So `Λ_i` is closed under addition and the induced map is additive;
it is injective because distinct labels give distinct projective axes. If
`Λ_i = F_q²` the induced map is an injective endomorphism of a finite group,
hence bijective, so conjugation permutes all projective Weyl axes, which is the
Clifford condition. The converse is immediate. ∎

Nothing here is deep; the point is that it makes `Λ_i` a *monotone* invariant.
Every marginal that recognizes some labels enlarges it, and independent
marginals compose. That is the structure neither their argument nor ours
exposes, because each of them fills `Λ_i` in a single step.

## Theorem P (partial-Weyl marginal criterion)

Let `R` and `R'` be partial-Weyl diagonal operators on the same `r` parties,
with index sets of the same size `N ≥ 2`, possibly different injections and
coefficients, and suppose

  R' = (U_1 ⊗ … ⊗ U_r) R (U_1 ⊗ … ⊗ U_r)†.

Assume either `r ≥ 3`, or `N = 2`. Then for every `i` and every `v ∈ P`,
conjugation by `U_i` carries `W_{f_i(v)}` to a phase times `W_{f'_i(v')}` for
some `v' ∈ P'`; that is, `f_i(P) ⊆ Λ_i`, and `U_i` induces a bijection
`f_i(P) → f'_i(P')` fixing `0`.

*Proof.* Case `r ≥ 3`. Let `E_i ⊆ HS(ℂ^q)` be the span of
`{ W_{f_i(v)} : v ∈ P }` and `E'_i` the span of `{ W_{f'_i(v')} : v' ∈ P' }`;
both are `N`-dimensional because the `W` are linearly independent and the
labelling injections are injective, and the rescaled operators `q^{-1/2}W`
are orthonormal. Conjugation by `U_i` is a unitary map of the Hilbert–Schmidt
space, and `R` lies in `E_1 ⊗ … ⊗ E_r` with all `N` coefficients nonzero, so
by the rank computation in Lemma `diagonal-axes` the smallest subspace of
factor `i` supporting `R` is exactly `E_i`; likewise for `R'` and `E'_i`. Hence
the product map carries `E_i` onto `E'_i`. Lemma `diagonal-axes` applies
verbatim to the two tensors in `⊗E_i` and `⊗E'_i` — its proof uses only
`r ≥ 3`, nonzero coefficients, and orthonormal bases, never `N = q²` — and
gives that the maps are monomial in the displayed bases. Unitarity of
conjugation makes each scalar a phase.

Case `N = 2`. Write `R = λ_0 I + λ_1 ⊗_i W_{f_i(1)}` and
`R' = λ'_0 I + λ'_1 ⊗_i W_{f'_i(1)}`. Conjugation fixes the identity, so
comparing traces gives `λ_0 = λ'_0`, and subtracting leaves
`(⊗ U_i)(⊗ W_{f_i(1)})(⊗ U_i)† = (λ'_1/λ_1) ⊗_i W_{f'_i(1)}`. A tensor
factorization of an equality of nonzero product operators gives
`U_i W_{f_i(1)} U_i† = c_i W_{f'_i(1)}` with `∏ c_i = λ'_1/λ_1`, and each `c_i`
is a phase by unitarity. ∎

The `N = 2` case is exactly the argument in the second branch of their
Theorem 1, and it is the only case that survives at `r = 2`; see the sharpness
section.

## Corollary G (generation criterion)

Let `|ψ⟩, |φ⟩` be `n`-party states with `(U_1 ⊗ … ⊗ U_n)|ψ⟩ = |φ⟩` up to phase
and, if a party permutation is present, after absorbing it by relabelling `φ`.
Suppose that for each party `i` there is a family of subsets `S ∋ i`, each with
`|S| ≥ 3` or with a two-element index set, such that `ρ^ψ_S` and `ρ^φ_S` are
partial-Weyl diagonal with index sets of equal size. If the labels recovered at
`i` over that family generate `F_q²` as an additive group, then `U_i` is
Clifford.

*Proof.* Theorem P puts each recovered label in `Λ_i`; Lemma R closes `Λ_i`
under addition and converts `Λ_i = F_q²` into Cliffordness. ∎

## Corollary A: our own criterion is the one-support case

Corollary `full-weyl-cover` is Corollary G with a single covering set per party
and `N = q²`, where the recovered labels are all of `F_q²` at once and
generation is automatic. Nothing in the manuscript's application changes.

## Corollary B: their Theorem 1 is the local-dimension-two stabilizer case

Two facts about minimal supports at arbitrary `q`, which are the general-`q`
form of their Lemma 1.

**Lemma M.** Let `|ψ⟩` be a stabilizer state and `ω` a minimal support of its
stabilizer. Let `L(ω)` be the group of labels of stabilizer elements supported
inside `ω`. Then for every `i ∈ ω` the coordinate projection
`π_i : L(ω) → F_q²` is injective. Consequently `L(ω)` is isomorphic to an
`F_p`-subspace of `F_q²`, every nonzero element of `L(ω)` has support exactly
`ω`, and `ρ_ω` is partial-Weyl diagonal with index set `L(ω)` and injections
`π_i`.

*Proof.* An element of the kernel has support contained in `ω \ {i}`, which is
a proper subset of `ω`, so by minimality it is zero. The partial trace of
`|ψ⟩⟨ψ|` over the complement of `ω` retains exactly the stabilizer elements
supported inside `ω`, each with a phase coefficient of modulus one. ∎

At `q = 2` this reads: `|L(ω)| ∈ {2,4}`, i.e. `A_ω ∈ {1,3}` — their Lemma 1,
with the parity statement being the separate consequence of commutativity.

**Their Theorem 1 follows.** Let `|ψ⟩` be a fully entangled `n`-qubit
stabilizer state with `σx, σy, σz` occurring at every qubit within the subgroup
`M(ψ)` generated by all minimal elements, and let `|φ⟩` be a stabilizer state
locally unitarily equivalent to it. The labels of minimal elements through `i`
are exactly `∪_ω π_i(L(ω))` over minimal supports `ω ∋ i`, so their hypothesis
says precisely that these generate `F_2²`. Each such `ρ_ω` is partial-Weyl
diagonal by Lemma M, with `N = |L(ω)| ∈ {2,4}`; the second state's marginal on
the same `ω` is partial-Weyl diagonal with the same `N`, because minimal
supports and the purity invariant `Tr(ρ_ω²) = |L(ω)|/q^{|ω|}` are preserved by
local unitaries. The arity condition of Corollary G holds: for `N = 4` full
entanglement forces `|ω| ≥ 4`, and `N = 2` needs no arity condition. Corollary
G gives every `U_i` Clifford, hence `LU(ψ) = LC(ψ)`. ∎

Their cases (i)–(iii) of Corollary 1 reduce to their Theorem 1 by their own
arguments and so are covered as well; case (iv) is the sub-case where a single
support suffices at each party. So the whole of their Corollary 1, and the
theorem behind it, is now a specialization rather than a finer neighbour.

## What is genuinely new, beyond the local dimension

The intermediate sizes `2 < N < q²` do not occur at `q = 2` and are the generic
situation above it. For prime `q` the possibilities for `L(ω)` are a line of
`q` labels or all of `F_q²`, and the line case is exactly what a CSS state
produces: a minimum-weight `X`-type codeword whose support carries no `Z`-type
stabilizer gives `L(ω) = { (x,0) }`, of size `q`. Our full-Weyl criterion sees
nothing there, and their factorization argument does not apply because `N > 2`.
Corollary G does, which yields a criterion for a family the paper currently
says nothing about:

**Corollary C (CSS states, prime `q`).** Let `|ψ⟩` be a CSS coset state over a
prime field, and suppose every coordinate lies in the support of a minimal
`X`-type support and of a minimal `Z`-type support, each with at least three
coordinates. Then every product-unitary equivalence to another such state has
Clifford factors.

*Proof.* Each side contributes a label `(x,0)` respectively `(0,z)` with
`x, z ≠ 0` to `Λ_i`; over a prime field these generate `F_q²`. Apply
Corollary G. ∎

This is checkable from the two classical codes alone, with no AME, MDS, or
maximal-distance hypothesis anywhere. It is the statement I would put forward
as the paper's answer to "what is the prime-power form of their criterion",
which the survey listed as an open question.

## Sharpness, stated plainly

The arity condition is real, not an artifact. At `r = 2` the tensor
`Σ_j λ_j e_{1j} ⊗ e_{2j}` has intrinsic axes only through the moduli `|λ_j|`,
and a stabilizer marginal has all moduli equal, so the coordinate axes are not
recoverable once `N ≥ 3`. For `N = 2` the identity term is pinned by
conjugation and the remaining axis is determined, which is why the two-element
case alone survives at two parties — and why their EPR remark and our sharp
`m ≥ 2` boundary are the same phenomenon seen from two sides. Whether the
two-party case with `3 ≤ N < q²` can be rescued by using the Weyl form of
*both* sides, rather than the bare tensor, is open and is not claimed here.

Two further limits worth recording. Corollary G needs the partial-Weyl
condition on both states; for stabilizer-to-stabilizer equivalences it is
automatic by the marginal purity invariant, but for a non-stabilizer second
state it is a hypothesis, exactly as in the manuscript's existing corollary.
And the criterion is sufficient, not necessary: a party whose recognition group
is a proper subgroup may still have a Clifford factor, so nothing here says
anything about states where `LU = LC` fails.

## Gates before any of this reaches the manuscript

1. **Novelty audit, blocking.** The specialization inversion needed no audit
   because it claimed only what the manuscript already proved. This does not
   qualify: Theorem P, Corollary G, and Corollary C are new statements, and the
   qudit local-unitary-versus-local-Clifford literature after 2005 is not
   audited in this repository at the depth required. A claim-specific audit
   under `notes/literature-audit-conventions.md` must run before any wording
   asserts generality over the published criteria, and it should specifically
   screen the later local-unitary/local-Clifford work that followed Van den
   Nest, Dehaene and De Moor, including the counterexample line and the
   diagonal-local-operation reductions.
2. **Adoption is a scope decision.** This adds a theorem branch to a manuscript
   whose theorem package was frozen; that is the user's call, not a routine
   edit.
3. **Formalization.** Lemma `diagonal-axes` is already kernel checked. Theorem
   P is the same lemma with the dimension hypothesis relaxed, and Lemma R is
   elementary group theory, so the Lean layer is a small extension rather than
   a new development. It should follow adoption, not precede it.
4. **The blind A/B changes shape if this is adopted.** The frozen baseline
   stays, but version B would then claim a genuine generalization of their
   Theorem 1 rather than of case (iv) alone, and the reader's correctness
   question becomes the harder and more useful one.

## Mystery ledger

- **Why their proof needed two arguments.** Settled: at local dimension two the
  label group of a minimal support has no intermediate size, so the two extreme
  cases are the only cases, and each extreme has its own cheap proof. The
  interpolation they could not see is the content of Theorem P.
- **Why our engine needed the full Weyl basis on one support.** Settled: it did
  not. The dimension hypothesis in Lemma `diagonal-axes` was inherited from the
  AME application, where the support theorem supplies `N = q²` for free, and
  was never the lemma's requirement. The engine was always a partial criterion.
- **Open: the two-party case at intermediate size.** Whether the Weyl form of
  both marginals restores rigidity at `r = 2`, `3 ≤ N < q²`, is untested here.
  The evidence gap is complete and it owns any future claim about two-party
  minimal supports above local dimension two.
- **Open, and now sharply posed: necessity.** The recognition group is a
  sufficient statistic for this method, not for the problem. What states have
  `Λ_i` a proper subgroup at some party yet still satisfy `LU = LC` is the
  question the invariant makes askable, and no answer is attempted here.
