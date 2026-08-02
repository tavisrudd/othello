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

**Status after the C807 audit: a definition plus an elementary observation, not
a new theorem, and it must be presented that way.** At local dimension two the
group property has no content, because every subset of `F_2²` containing `0`
and one further element is already a subgroup and the intermediate size cannot
occur. Gross and Van den Nest prove that this group is nontrivial at every
party for fully entangled qubit stabilizer states, and that credit belongs with
any statement of it. The lemma becomes non-vacuous only above local dimension
two. Do not name the object "semi-Clifford": that term is taken by the Clifford
hierarchy literature.

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

**Wording constraint from the C807 audit.** At local dimension two this is a
*unification* of their own two arguments plus Rains, not a strengthening: their
four-element branch is Rains's Theorem 13, their two-element branch is the
`N = 2` case of Theorem P, and their concluding step is Corollary G with two
recovered labels. Say "unifies" there. "Generalizes" is earned only by the move
to arbitrary local dimension and intermediate index size, which is where the
audit found the territory unoccupied.

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
prime field. Suppose every coordinate `i` lies in two minimal supports of the
stabilizer, each with at least three coordinates, one whose label group
contains a nonzero `X`-type label and one whose label group contains a nonzero
`Z`-type label. Then every product-unitary equivalence to another such state
has Clifford factors.

*Proof.* The first contributes a label `(x,0)` and the second a label `(0,z)`
with `x, z ≠ 0` to `Λ_i`; over a prime field these are independent and generate
`F_q²`. Apply Corollary G. ∎

The hypothesis must be read carefully and is stated the way it is because the
obvious simplification is false. A minimal-support codeword of the `X` code
need not give a minimal support of the *stabilizer*: if the `Z` code has a
codeword supported strictly inside it, the support is not minimal and its label
group fails the injectivity of Lemma M. What the classical fact behind their
case (ii) does give for free is coverage — minimal codewords span an additive
code, so every coordinate of a full-support stabilizer lies in some minimal
support. Coverage is free; the `X`/`Z` flavour at each coordinate is the real
hypothesis.

Even so this is checkable from the two classical codes alone, with no AME, MDS,
or maximal-distance hypothesis anywhere. It is the statement I would put
forward as the paper's answer to "what is the prime-power form of their
criterion", which the survey listed as an open question.

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

## What else the invariant predicts or explains

### The minimal supports are exactly the charts, so the method has a computable ceiling

For a stabilizer state, ask which subsets `S` make `ρ_S` partial-Weyl diagonal.
By Lemma M's argument this needs every nonzero element of `L(S)` to have
support exactly `S` — and that condition says precisely that `S` is a minimal
support. There is no larger supply of usable marginals to find. Hence the
largest recognition group this entire family of arguments can produce at party
`i` is

  Λ_i^max = ⟨ π_i(L(ω)) : ω a minimal support containing i ⟩ = π_i(M(ψ)),

the local label projection of the subgroup generated by all minimal elements.
So Van den Nest, Dehaene and De Moor's hypothesis is not merely a sufficient
condition they happened to find: it is the exact ceiling of the single-marginal
mechanism, the weakest hypothesis under which any argument of this shape can
work. Corollary G at `Λ_i^max` is therefore the optimal form of the criterion
at every prime power.

**Scope of that ceiling, stated precisely, because the natural gloss is
wrong.** This bounds arguments that feed one partial-Weyl diagonal marginal at
a time into an axis-recovery lemma. It does not bound the problem, and it does
not license saying that states failing the condition are beyond reach. The
concrete escape route is identified in the adversarial section below: relaxing
injectivity at some parties while keeping it at the party of interest takes the
marginal outside the partial-Weyl class but leaves it inside the reach of
general tensor-uniqueness theorems. Whether that route recovers anything for
stabilizer marginals is open; asserting a ceiling over it would be the mistake
this framework was built to avoid.

### Finiteness of the symmetry group, for every stabilizer state with full recognition groups

**Scoped after the C807 audit: claim this only above local dimension two.**
Englbrecht and Kraus characterise all local symmetries of every qubit
stabilizer state and pin where continuous symmetries occur, which is strictly
stronger than finiteness on that domain. The corollary below is new content
only at larger local dimension, and their work must be cited wherever it is
stated.

This one is free and does not need the atlas. If `Λ_i = F_q²` at every party,
every product-unitary symmetry of `|ψ⟩` has Clifford factors, so it induces an
`F_p`-linear symplectic similitude of the label group at each party. The kernel
of that induced action consists of symmetries whose factors are Weyl operators
up to phase, which is the projective Pauli stabilizer `L_ψ`. Hence the
fixed-party projective symmetry group is an extension of a subgroup of
`Sp_{2e}(F_p)^n` by `L_ψ`, and in particular finite. The manuscript proves
finiteness for stabilizer AME states; the same conclusion holds for every
stabilizer state whose recognition groups are full, which is a much larger
class. This is also the cross-link to the survey's item 2: the 2026 literature
carries finiteness of the local symmetry group as a standing side hypothesis,
and this discharges it on a class defined by a condition checkable from the
stabilizer alone.

### It explains why their Corollary 1 has the cases it has

Their four cases have always looked like an unstructured list of sufficient
conditions. In this language they split cleanly into two jobs. Case (iv) is the
single-chart rigidity condition — one minimal support per party already fills
the recognition group — and it is the case our Corollary `full-weyl-cover`
specializes to. Case (i), that the stabilizer is generated by its minimal
elements, is not a rigidity condition at all: it is the hypothesis that makes
the chart data determine the whole state, which is exactly what our atlas
classification theorem needs and what its AME hypothesis currently supplies.
Case (ii), GF(4)-linearity, implies (i) by the classical fact that a linear
code is spanned by its minimal codewords, and that fact holds over every finite
field, so the implication survives verbatim at every prime power for `F_q`-linear
stabilizers. Case (iii) is a bookkeeping route to (i). Their list is a rigidity
condition, a classification condition, and two ways of checking the second.

### A predicted extension of the atlas, with its obstruction named

The atlas classification currently assumes every chart carries the full label
group, so a single chart supplies a complete Weyl frame at each of its parties
and transports between charts compose into holonomies in `SL_2(q)`. With
partial charts the frame at a party is assembled from several charts, and the
transport structure becomes a groupoid over the incidence hypergraph of minimal
supports rather than a system of pairwise transports. I expect the exact
sequence and a centralizer description to survive for every stabilizer state
with full recognition groups and `S(ψ) = M(ψ)`, but this is a prediction, not a
proof, and the obstruction is specific: one must show that compatibility with
every chart pins the induced label map, and that every compatible system of
maps lifts to an actual product unitary. Neither is supplied by anything proved
here.

### It explains why the extension-field work kept meeting the prime field

Recognition groups are `F_p`-subspaces of `F_q²` and the induced label maps are
`F_p`-linear, never `F_q`-linear, because the only structure the argument uses
is that Weyl operators multiply additively in their labels. At `q = p` that
distinction is invisible. At `q = p^e` with `e ≥ 2` it is exactly the room in
which C623's nonsemilinear kernels and the Frobenius–Gale sector live: those
were found empirically as Clifford elements whose label action is `F_p`-linear
symplectic without being `F_q`-semilinear, and this framework says that is the
generic expectation rather than an anomaly. The manuscript's own exact sequence
(2.0) already has `Sp_{2e}(F_p)` in it, so nothing here is new mathematics —
but it does supply the reason the census found what it found, which the C623
mystery ledger left unexplained.

### The cheapest falsifier available: the qudit counterexample

**Rewritten after the C807 audit; the qubit version of this paragraph was
worthless.** It said that every qubit state witnessing the failure of the two
equivalence relations must have a party with a proper label projection. That is
the contrapositive of Van den Nest, Dehaene and De Moor's published Theorem 1,
so it is known unconditionally and predicts nothing about this framework.

Above local dimension two it is a real test, and the audit located the state to
run it on: Wong and Jiang exhibit a three-party state at local dimension nine
that is local-unitarily but not local-Cliffordly equivalent to the
Greenberger–Horne–Zeilinger state (arXiv:2507.09416, recorded at
abstract/metadata depth in the audit, so its details must be read before
anything is concluded). Their Theorem 1 does not reach it. Corollary G says its
recognition group must be a proper subgroup at some party, and that is
checkable from the state's stabilizer data with no new theory. A pass makes the
criterion near-necessary in the only regime where necessity is currently
testable; a failure kills Corollary G outright.

### Operational reading

Each chart marginal is a correlation measurement on a bounded number of
parties, so the criterion says exactly which local measurement data certifies
that an unknown local-unitary equivalence is Clifford: enough charts through
each party to generate the label group. That is the same object the ceilings
document's correlation-tensor tomography level-up is reaching for, arrived at
from the rigidity side.

### A stability version worth attempting

C581 proves quantitative ambient-Clifford rigidity from full-Weyl marginals.
The partial-chart version should follow the same route — approximate axis
recovery on an `N`-dimensional span gives approximate recognition of a
subgroup, and the subgroup closure of Lemma R is exact and costs nothing — with
the error constants presumably degrading with `N` rather than with the local
dimension. Not attempted here, and the degradation rate is the whole question.

## Adversarial and method review (`tt` pass)

Run against the routed proof persona for this manuscript
(`papers/expert-profiles/11-ame-lu.md`, Van den Nest–Gross lens). Findings are
ordered by what they change.

### The prime-power hypothesis is not needed anywhere in the engine

Everything above uses exactly one property of the labels: they form a finite
abelian group on which Weyl operators multiply additively up to phase. Take
`ℂ^d` for arbitrary `d`, `X` the shift and `Z` the clock operator,
`W_{(a,b)} = X^a Z^b` for `(a,b) ∈ Z_d²`. Then the `d²` Weyl operators are an
orthogonal Hilbert–Schmidt basis, Clifford still means permuting their
projective axes, Lemma R goes through verbatim over `Z_d²` (an injective
additive endomorphism of a finite abelian group is bijective), Theorem P is
pure linear algebra and never mentions the field, and Lemma M's kernel argument
uses only that the kernel is a subgroup. **The entire criterion holds at every
local dimension, prime power or not.** The prime-power restriction in the
manuscript comes from the arc and MDS geometry of the applications, not from
the rigidity engine.

This is the most valuable thing in this pass, because it reaches an object the
paper cannot currently discuss at all: absolutely maximally entangled states at
local dimension six, where no stabilizer formalism exists but Weyl operators do,
and where a genuinely non-stabilizer four-party state is known. Whether the
criterion says anything there is a concrete finite question — compute the Weyl
support of that state's three-party marginals and read off the recognition
groups — and it is worth asking precisely because a positive answer would be a
rigidity statement about an object with no code-theoretic description.

### The three-party floor is Kruskal's boundary, and that is a citation duty

Lemma `diagonal-axes` is a special case of the uniqueness theory for tensor
decompositions. Kruskal's condition for an `r`-factor decomposition of rank `N`
is that the sum of the factor k-ranks be at least `2N + r − 1`. Our factors are
sets of `N` distinct Weyl operators, which are linearly independent, so every
k-rank is `N`, and the condition reads `rN ≥ 2N + r − 1`, i.e. `r ≥ 3` for
`N ≥ 2` and `N ≥ 2` for `r ≥ 3` — exactly the two boundaries found
independently in the sharpness section. That the two-party case fails is the
same fact as the rotation freedom in a singular value decomposition with
repeated singular values. Any manuscript adoption should cite the tensor
uniqueness literature rather than present the boundary as ours.

The same identification supplies the escape route from the ceiling. Kruskal's
condition is stated in k-ranks, not in injectivity, so a marginal whose labels
collide at *some* parties can still have recoverable axes at the others if
enough parties compensate. Such a marginal is not partial-Weyl diagonal, so the
ceiling proposition does not apply to it. The catch, and the reason this is
posed as a question rather than a result: repeated columns drop a factor's
k-rank to one, so the compensation demanded of the remaining parties is severe,
and for stabilizer marginals the repeats come in whole cosets of the projection
kernel. Whether any non-minimal support survives that arithmetic is untested.

### Why the tensor structure is doing all the work

Worth recording because it forecloses a tempting simplification. At a single
party the constraint is vacuous: the marginal of a stabilizer state on a
minimal support is a multiple of a projector, so it generates no algebra, and
the group of Weyl operators fixing that projector is mapped by conjugation to
the group of *conjugated* operators fixing the image, which are not Weyl
operators and carry no information. There is no one-party or operator-algebraic
shortcut; the multiparty product structure is the entire source of rigidity.

### Stabilizer marginals are the best-conditioned instances

For the stability version, the quantitative content of the axis recovery is a
singular value gap in the flattening, so the constants must degrade with the
spread of the coefficients `|λ_v|`. A stabilizer marginal has all coefficients
of equal modulus, which is the best-conditioned case. That is a plausible
explanation for why C581's constants came out clean, and it predicts that any
partial-chart stability estimate will degrade with the chart size `N` and with
coefficient spread, but not with the local dimension.

### The criterion may not be efficiently checkable, which explains their paper's shape

Deciding whether `π_i(M(ψ))` is everything requires knowing minimal elements,
and enumerating minimal codewords of a linear code is not a benign
computational problem. Van den Nest, Dehaene and De Moor explicitly single out
their cases (iii) and (iv) as "much more operational" than Theorem 1 — that
remark is the shadow of exactly this issue, and it is a second reason their
list has the shape it has. It is also a caveat on the CSS corollary above:
exhibiting two minimal supports of the right flavour at each coordinate is easy
for structured codes and not obviously easy in general. Any operational claim
in a manuscript must be scoped to cases where the required supports are
exhibited, not merely asserted to exist.

### The partial-chart atlas is a gluing problem with a named obstruction

Theorem P returns more than Cliffordness: it returns the induced injective
additive map on the recognized labels. Overlapping charts then impose
compatibility conditions on those maps, and the predicted extension of the
atlas is precisely the question of when a compatible system over the
minimal-support hypergraph glues to a global label map and lifts to a product
unitary. That is a Čech-style gluing problem with a nonabelian first
obstruction, and the manuscript already has the machinery for exactly this
shape in its party-extension factor sets. Formulating the extension that way,
rather than as an ad hoc generalization of pairwise transports, is the route I
would take.

### The converse question, posed the way it should be

Asking whether a full recognition group is necessary for local unitary and
local Clifford equivalence to coincide is the wrong question, since the
criterion is one mechanism among possible others. The right form is a
dichotomy: either the recognition groups are full, in which case the state is
rigid, or the state admits a specific structural description — the known
failures of the equivalence arise from diagonal local operations, which is a
structure, not a random accident. Formulating and testing that dichotomy is a
research programme, but the counterexample check already queued is its first
data point and costs almost nothing.

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
  question the invariant makes askable, and no answer is attempted here. The
  cheapest probe is the published counterexample check described above, which
  is unrun.
- **Settled by this pass: why C623's exceptional kernels were `F_p`-linear and
  not `F_q`-semilinear.** The mechanism only ever sees additive label
  arithmetic, so `F_p` is the correct category throughout and semilinearity is
  an extra condition with no reason to hold. C623 recorded the nonsemilinear
  witnesses as a surprise; they are the expected case.
- **Settled by this pass: why their sufficient-condition list has four
  entries.** Two jobs, not four conditions — one rigidity hypothesis and one
  generation hypothesis, with two checkable routes to the second.
- **Open: whether the atlas classification extends to partial charts.** The
  named obstruction is that transports become a groupoid over the
  minimal-support hypergraph, and neither the pinning nor the lifting step is
  proved. Owning successor: a separate allocated task, not this one.
- **Open: the error rate of a partial-chart stability estimate.** Whether the
  C581 constants degrade with the chart size is untested. The `tt` pass
  predicts degradation in chart size and coefficient spread but not in local
  dimension, and identifies equal-modulus stabilizer coefficients as the
  best-conditioned case.
- **Corrected by the `tt` pass: the ceiling's scope.** It was first written as a
  bound on marginal-axis arguments in general. It bounds only single-marginal
  partial-Weyl arguments; tensor-uniqueness theory admits marginals with
  colliding labels at some parties, which fall outside the partial-Weyl class.
  Whether any such marginal survives the k-rank arithmetic for stabilizer
  states is open and is the first thing to test before the ceiling is quoted
  anywhere.
- **Settled by the `tt` pass: why the three-party floor is where it is.** It is
  Kruskal's uniqueness boundary, not a feature of Weyl geometry, and the
  two-party failure is the repeated-singular-value rotation freedom.
- **Open, and the largest opportunity found: local dimension six.** The engine
  never used the prime-power hypothesis, so it applies to every local
  dimension. Whether it says anything about the known non-stabilizer four-party
  absolutely maximally entangled state at local dimension six is a finite
  computation nobody here has run.
