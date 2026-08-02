# C804: specialization inversion — red-team pass on the local-dimension-two concession

**Date:** 2026-08-02
**Lane:** `ame-lu`
**Stage:** closed after adversarial review, blind A/B, Fable red team,
manuscript adoption, exposition pass, and consistency reconciliation.  The
first-gate analysis below records the narrower full-Weyl comparison; the final
disposition records the later recognition-group strengthening.

## Question put to the pass

`papers/ame_lu/sections/01-introduction.tex` currently concedes that the
LU-to-LC conclusion of Theorem `lu-lc-rigidity` "is therefore already covered
by" Van den Nest, Dehaene and De Moor (VdN-DDM, quant-ph/0411115).
`notes/2026-08-02-priority-judo-survey.md` item 1 asserts the concession is
written backwards at the engine level: Corollary `full-weyl-cover` is stated
for arbitrary states at any local dimension with no stabilizer hypothesis, and
VdN-DDM's Corollary 1 case (iv) is its local-dimension-two stabilizer
specialization.

The brief here was to break that assertion, not to confirm it: instantiate the
engine at their parameters, test the implication in both directions, and hunt
specifically for a hypothesis that is free at our generality but binding at
theirs, or a conclusion of theirs that is strictly stronger on their domain.

**Sources.** VdN-DDM read at full text from the cache (key
`arXiv:quant-ph/0411115`, SHA-256
`c0f8e192552369d5af9304ebf08995f59b6917e243a570f37ff1b29f3b4cb735`), against
`papers/ame_lu/sections/03-lu-rigidity.tex` (Lemma `diagonal-axes`,
Proposition `full-weyl-marginal`, Corollary `full-weyl-cover`, Proposition
`stabilizer-ame-support`) and `sections/01-introduction.tex` lines 108–129.
No new literature search was run and none is needed for this verdict.

## Verdict

**The specialization survives, in the direction the reframing needs, with three
qualifications that must appear in the rewritten wording.** Their case (iv) is
implied by our engine at local dimension two for fully entangled stabilizer
states; the reverse implication is false, so the containment is strict. Their
Theorem 1 is genuinely not swallowed and must stay conceded. One imprecision in
our own corollary's statement surfaced and should be repaired before that
corollary is promoted to a headline criterion.

## The reduction, checked step by step

Their case (iv): there exist minimal supports `ω1, ω2, …` with
`3 = A_{ω1}(ψ) = A_{ω2}(ψ) = …` such that every qubit lies in at least one
`ωj`; conclusion `LU(ψ) = LC(ψ)`.

1. **`A_ω = 3` gives exactly our full-Weyl diagonal condition (3.2) at `q = 2`.**
   By their Lemma 1, the stabilizer elements supported inside a minimal support
   `ω` are `{I, M, M′, MM′}`, of order `4 = q²`, and at every `i ∈ ω` the local
   components `{M_i, M′_i, (MM′)_i}` are exactly `{σx, σy, σz}`. Hence
   `ρ_ω = 2^{-|ω|}(I + M + M′ + MM′)|_ω` is a sum over a `q²`-element index set
   whose coordinate projection at each retained party is a bijection onto the
   complete local Weyl basis, with nonzero coefficients. That is (3.2) verbatim,
   with `P` the four-element group and `f_i(I) = 0`. The per-site phase between
   `σy` and the Weyl operator `X(1)Z(1) = -iσy` multiplies out to one scalar per
   index element and is absorbed into `λ_v`, which our definition permits.
2. **The hypothesis transfers to the second state.** Our corollary demands the
   full-Weyl condition on *both* reduced operators. At their parameters this is
   supplied by LU-invariance of `A_ω` and of the set of minimal supports (their
   §"Minimal supports"), so `ρ_ω(ψ′)` is full-Weyl diagonal on the same `ω`.
   This is a one-line input, but it is an input: the specialization is not
   hypothesis-free and the rewrite must say where the second-state condition
   comes from rather than assume it silently.
3. **The arity floor clears.** Our Lemma `diagonal-axes` needs `r ≥ 3`.
   Their Lemma 1 forces `|ω|` even, and full entanglement forces `|ω| ≠ 2`
   (a two-element minimal support with `A_ω = 3` makes `ρ_ω` pure, i.e. an EPR
   factor), so `|ω| ≥ 4`.
4. **Our conclusion implies theirs.** Factorwise Cliffordness of every
   intertwiner puts every `ψ′ ∈ LU(ψ)` in `LC(ψ)`; with `LC ⊆ LU` always, that
   is their equality. So on the overlap our conclusion is at least as strong.

## Qualification 1: full entanglement is load-bearing for us and is missing from their Corollary 1

Their Theorem 1 carries "fully entangled" explicitly; their Corollary 1 does
not restate it, and (iv) is proved by reduction to Theorem 1. The gap is real
but harmless to them and fatal to a careless inversion: take `ψ = Bell ⊗ Bell`
on four qubits. Its minimal supports `{1,2}` and `{3,4}` have `A_ω = 3` and
cover every qubit, so (iv) is literally satisfied, and `LU(ψ) = LC(ψ)` does
hold, because every state locally unitarily equivalent to it is a product of two
maximally entangled pairs and all of those are LC-equivalent to `Bell ⊗ Bell`.
Our corollary says nothing there — no covering set has size three — and our
factorwise conclusion is **false** there, since `U ⊗ Ū ⊗ I ⊗ I` fixes the state
for every `U`.

This is the same `m = 1` boundary the paper already states as sharp, so it costs
nothing mathematically, but it fixes the exact wording: the claim to make is
that their case (iv) **for fully entangled states** is our criterion's local
dimension two stabilizer specialization. Claiming case (iv) as stated is
claiming something our engine does not cover.

## Qualification 2: their Theorem 1 is finer at local dimension two, and its proof is equally strong

Theorem 1 assumes only that `σx, σy, σz` each occur at every qubit within the
subgroup `M(ψ)` generated by all minimal elements. Its `A_ω = 1` branch takes
two *different* minimal elements `M, N` with `M_1 ≠ N_1`, reads
`U_1 M_1 U_1^† = ±M_1′` and `U_1 N_1 U_1^† = ±N_1′` off the two rank-one
marginals, and concludes `U_1` is Clifford. That mechanism plays two supports
against each other; our diagonal-marginal argument needs the whole local Weyl
basis carried by a *single* support, and has no analogue for the mixed case.

Two consequences the reframing must respect. First, our engine does not imply
Theorem 1, and cases (i)–(iii) of their Corollary 1 reduce to Theorem 1 rather
than to (iv), so they are not swallowed either. Second — and this is the point a
referee will press — their Theorem 1's proof yields the same factorwise-Clifford
conclusion we do, not merely orbit equality. So on their qubit domain there is
no strength deficit to exploit: the honest statement is that we generalize one
branch of their argument to every prime power and to arbitrary states, while the
other branch remains theirs alone and covers qubit states we cannot reach.

## Qualification 3: two axes of generality, and one of them is not the local dimension

Even at `q = 2`, Proposition `full-weyl-marginal` is strictly broader than the
lemma their (iv) branch runs on. Their Lemma 2 (attributed to Rains) requires
both marginals to be LC-equivalent to the fixed normal form
`ρ[2m,2m−2,2]`, which has equal coefficients. Ours requires only that some
`q²`-element index set run bijectively through the complete local Weyl basis at
each party, with arbitrary nonzero coefficients and no linearity of the index
set or the bijections, and applies to arbitrary — in particular non-stabilizer —
operators. So the generalization is along two independent axes: from local
dimension two to every prime power, and from the stabilizer normal form to
arbitrary full-Weyl diagonal marginals. The second axis is worth stating
explicitly, because it is what makes the criterion free-standing rather than a
stabilizer lemma.

## Reverse direction: strictly one-way

Their (iv) does not imply our corollary. (iv) is a statement about binary
stabilizer states only; our hypothesis is satisfied by operators with unequal
coefficients and non-linear index sets that arise from no stabilizer group at
any local dimension. Nothing in their paper supplies the `q > 2` Weyl-basis
axis recovery. The containment is therefore strict in the direction the judo
needs, and the mechanism credit already carried in Section 3 — Rains's
three-Pauli axis recovery, used by VdN-DDM in a minimal-support criterion — is
correct as written and should not change.

## Defect found in our own statement, to repair before promotion

Corollary `full-weyl-cover` reads "suppose a product unitary, after a party
relabelling, carries `|ψ⟩` to `|φ⟩` … both reduced operators `ρ^ψ_S` and
`ρ^φ_S`". With a permutation `π` in play the second operator to compare is
`ρ^φ_{π(S)}`. The proof of Theorem `lu-lc-rigidity` (03-lu-rigidity.tex line
140) resolves this by absorbing the permutation into a relabelling of `|φ⟩`
before applying the corollary, so the mathematics is right and no result is
affected. But a corollary promoted to a named free-standing criterion will be
read on its own, and as written it is ambiguous. Either state it for a fixed
party labelling and note that a permutation is absorbed first, or index the
second marginal by `π(S)`.

## What the size of the local-dimension-two domain actually is

At `q = 2` our theorem's stabilizer-AME instances are governed by the same
parity constraint their Lemma 1 imposes: minimum supports have `m + 1` parties,
`A_ω = 3` requires `|ω|` even, and `m ≥ 2` is required for the arity floor.
Since no absolutely maximally entangled state of four qubits exists while the
six-qubit one does, the whole conceded overlap at local dimension two is the
six-qubit case. The current wording therefore cedes a theorem proved for every
prime power, every `m ≥ 2`, and arbitrary additive stabilizers to a result
whose intersection with it is one qubit state family. If this observation is
adopted into the manuscript it needs the standard nonexistence and existence
citations (Higuchi–Sudbery for four qubits, Scott for six), which the reframing
does not otherwise require.

## Consequences at the first gate (superseded by the recognition criterion)

The survey's steps 1–3 stand, with amendments:

- Step 1 (present the criterion as free-standing, any local dimension, any
  states) — adopt, and repair the relabelling wording at the same time.
- Step 2 (state the specialization) — adopt with the full-entanglement
  restriction inserted, and with the second-state transfer named rather than
  assumed. Cite Corollary 1(iv), never Theorem 1, as the specialized statement.
  State both generality axes, not only the local dimension.
- Step 3 (concede Theorem 1 plainly) — adopt, and strengthen it: their Theorem 1
  reaches qubit states we cannot, with the same factorwise conclusion. A
  concession that mentions only "a finer criterion" understates it.
- Step 4 (pose the residual open question: is there a prime-power
  minimal-support criterion whose local-dimension-two case is their full
  Theorem 1, with the single-support full-Weyl hypothesis relaxed to labels
  drawn from several minimal supports exhausting `F_q²` at each party) —
  keep as optional new work, not part of the reframing.

## The Tan half: not settled here, and its falsifier is arithmetically sharp

The companion demotion of the four-qutrit concession remains gated on
reproducing Tan's local symmetry group of order 5832 from the minimum-support
atlas, and that computation was not run in this pass. The gate is sharper than
"reproduce a number", and the arithmetic is worth recording before anyone
attempts it. For the four-qutrit state, Theorem `atlas-classification` gives the
exact sequence `1 → L_ψ → Γ_ψ → 𝒢_ψ → 1` with `|L_ψ| = 3⁴ = 81` and, for prime
`q`, `𝒢_ψ` the centralizer in `SL₂(3)` of the atlas holonomies, so
`|𝒢_ψ|` divides 24 and the fixed-party projective group has order at most
`81 · 24 = 1944`. Since `5832 = 3 · 1944`, matching Tan's count requires the
fixed-party group to be the full `1944` — that is, `𝒢_ψ` all of `SL₂(3)`,
meaning trivial atlas holonomy — together with a realized party-permutation
image of order exactly 3. Those are two independent, individually checkable
predictions, and either one failing falsifies the identification rather than
merely leaving it unproved. That makes this a genuine falsifier for the atlas
as a computing device, which is the property the ceilings document's level-up
wanted.

## Final adoption and consistency closeout

The first adversarial pass showed only that the existing full-Weyl cover
contains case (iv) of Van den Nest--Dehaene--De Moor's corollary.  The
recognition-group criterion subsequently proved in
`2026-08-02-c804-recognition-group-criterion.md` combines labels from several
partial-Weyl marginals.  At local dimension two its two-term and four-term
branches recover their full Theorem 1, while intermediate subgroup sizes give
the new higher-dimensional content.  C807 supplied the claim-specific audit;
the blind A/B preferred the reframing subject to named repairs; the Fable red
team verified the criterion at the predecessor's exact hypotheses and exposed
the integer-modulus, parity, attribution, and phase-convention defects recorded
in its report.

The adopted manuscript now:

- replaces the introduction's pre-emption concession by the strictly scoped
  recognition-group positioning;
- proves the partial-Weyl criterion, recognition subgroup, generation
  criterion, minimal-support realization, prime-field CSS corollary, and
  arbitrary-integer-dimension extension in Section 3;
- states explicitly how marginal purity transfers the minimal-support charts
  to the second stabilizer state and why full entanglement excludes the
  two-party four-term obstruction;
- explains the sharp two-party failure for three or more equal-modulus terms;
- uses the exponent identities `W_a^d=I` for odd `d` and `W_a^{2d}=I` for even
  `d`, rather than the false assertion that every odd-dimensional Weyl operator
  has exact order `d`;
- replaces the false qubit-subset claim by the exact line-or-full subgroup
  dichotomy; and
- synchronizes the theorem, claim, verification, formalization, and formal
  adequacy maps, with Section 7's trust crosswalk marking the package as
  manuscript-only and unsupported by certificates or Lean.

The bounded Section 3 number audit found one stale reference: the
coordinatewise propagation homomorphism is equation `(3.16)`, not `(3.8)`.
The other mentions in the five controlling files refer correctly to the
second-moment identity `(3.8)` and stability estimate `(3.10)`; the evidence
manifest and formal crosswalk contained no numbered Section 3 references.
`make check` passes without TeX warnings on the 49-page PDF, and pages 2--3,
9--12, and 37 were rendered and inspected after the final build.

## Extra-juice and Tao closeout

The closeout asked whether the new generality concealed a stronger
two-party statement, a field/integer-modulus conflation, or an unnecessary
stabilizer hypothesis.  The two-party obstruction is structural: with three
or more equal-modulus terms the Schmidt axes are not intrinsic, while the
two-term case is pinned by the identity.  The integer-modulus and finite-field
Weyl systems are now separated at first use, and the even-dimensional Pauli
phase convention is discharged by the exponent argument.  No further free
strengthening survives these checks.

## Mystery ledger

- **Why the predecessor's two proof branches looked unrelated.** Settled.  They
  are the only two nontrivial subgroup sizes in \(\F_2^2\); the recognition
  group makes them one generation argument.
- **Why their Corollary 1 omits the standing fully-entangled, \(n\geq3\)
  boundary.** Settled for this manuscript by restating the boundary exactly.
  The EPR factor is the sharp obstruction to factorwise Cliffordness.
- **Whether the partial-Weyl theorem extends to two parties with at least three
  terms.** Open beyond the present criterion.  Equal-modulus Schmidt
  degeneracy defeats the axis proof; exploiting the Weyl multiplication on
  both sides would require a different argument.  No successor is allocated,
  and the manuscript claims nothing there.
- **Whether Tan's four-qutrit group is reproduced by the atlas.** Open and
  outside this adoption.  The exact falsifier remains the pair of predictions
  above: trivial atlas holonomy and realized party image of order three.  This
  requires a separately allocated computation before Tan's concession can be
  changed.
- No other genuine mystery remains.
