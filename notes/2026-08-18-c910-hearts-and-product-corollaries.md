# C910 — the six-point hearts and the product-formula corollaries in Lean

**Task:** C910 (`cubic-threefolds`) — Lean companion for
`papers/cubic-stabilization-epilogue/`.
**Date:** 2026-08-18.  **Authority commit:** `cd932d7c5`.
**Predecessors:** the gap audit `2026-08-18-c910-post-restructure-gap-audit.md`
(priority 0b), the anchor report `2026-08-18-c910-atom-route-anchor.md`, and the
block-reduction report `2026-08-18-c910-block-reduction.md`.

This closes the rest of the gap audit's priority 0b: `cor:p3-nu6`,
`cor:cubic-product-nu`, and a terminal for `lem:six-point-hearts`.

## The two hearts

`lem:six-point-hearts` asserts that the six-point heart
`H_p = Aug(F_p^Omega)/<1>` is a simple module over the alternating group on
five letters for `p = 2, 3`, with endomorphism algebras `F_4` and `F_3`.  The
audit's finding was that the mathematics was largely present in `GraphLattices`
but no reviewer terminal stated the lemma, so the claim row read `absent`.

The new module
`GraphLattices/SixPointHeartEndomorphisms.lean` states it as one theorem across
both characteristics.  For each `p` the terminal records the four-coordinate
chart onto the augmentation quotient, the two generator matrices induced by the
label permutations `z + 1` and `-1/z` of the projective line over the field with
five elements, simplicity under the generated action, and the exact matrix
commutant of that action.  In characteristic two the commutant is
`{0, 1, W, W + 1}` with `W^2 + W + 1 = 0`; the new arithmetic is
`W (W + 1) = 1` together with distinctness of the four elements, which is what
turns the classification into the statement that the commutant is a field with
four elements.  In characteristic three the commutant is the scalar matrices,
the field with three elements.

Three things were new rather than assembled.  The three-primary side had no word
action, so the module defines the word matrix, derives simplicity and the
commutant classification for the whole generated action from the two-generator
statements, and thereby matches the two-primary side.  The characteristic-two
inverse relation and the distinctness facts are new.  Everything else is
composed from declarations already in `GraphLattices`.

The row is registered as `fragment`, not `complete`, for two stated reasons.
The endomorphism algebras are exhibited by generators and relations rather than
by an isomorphism with named field objects; and the six labels are the six
order-five subgroups of the concrete alternating group, which this package
proves elsewhere
(`GraphLattices.sixPointFiveSubgroup_injective`, `..._card`, and the two
conjugation theorems) and which
`GraphLattices.sixPointGeneratedAction_realizes_alternatingGroup` identifies
with the whole group, but neither fact is inside this terminal's type.

## The product-formula corollaries

`prop:projective-product-nu` — that `nu_6(T x P^m) = (m+1) nu_6(T)` — rests on
the Gromov-Witten product formula, the numerical Novikov base change, and
compatibility of the Levelt-Turrittin decomposition with tensor products.  None
of that is formalized, so the formula enters
`Applications/ProjectiveProductMultiplicity.lean` as a typed premise, stated for
every base variety and every `m`, exactly as the manuscript states the
proposition.

Two further premises are supplied: a projective space is the product of a point
with it, and the framed monodromy of a point is involutive.  The second is
weaker than what the manuscript uses, which is that a point has the rank-one
trivial connection; involutivity already forces the primitive-sixth
multiplicity to vanish through the existing spectral endpoint
`Quantum.FramedMonodromyMatrix.sixthMultiplicity_eq_zero_of_sq_eq_one`.

From those premises Lean deduces:

- `nu_6(pt) = 0` and hence `nu_6(P^m) = 0` for every `m`.  This is `cor:p3-nu6`
  at `m = 3` and, at `m = 4`, the value the framed-monodromy proof of one-step
  irrationality uses for a rational fourfold.
- `nu_6(X x P^1) = 4` for any variety of multiplicity two, and then for every
  smooth cubic threefold without assuming that value: the multiplicity two comes
  from the block-reduction terminal, whose only premise is the passage from the
  exponents of the reduced small even system to framed formal monodromy.

So `cor:cubic-product-nu` now rests on the product formula and that passage, and
on nothing else.

## Gates

All green at `cd932d7c5`.  The two new modules were elaborated singly, then
built through the guarded queue, followed by `PaperInterface` and
`Verification.AxiomAudit`.  `make check` and the axiom-log check pass: 100
sources, 179 reviewer terminals, 50 manuscript claims, 46 machinery rows,
coverage 25 absent / 12 fragmentary / 12 conditional / 1 complete.  Each of the
four new terminals reports `propext, Classical.choice, Quot.sound`.  No
manuscript source was edited, so the tracked PDF is unchanged at 49 pages.

Coverage moved by three rows: `lem:six-point-hearts` from absent to fragment,
and `cor:p3-nu6` and `cor:cubic-product-nu` from absent to conditional
deduction.  `prop:projective-product-nu` stays absent, with its caution now
recording that the two corollaries consume it as an explicit typed premise.

## Observations

The characteristic asymmetry in the lemma is not accidental.  Over `F_4` the
group is the special linear group of a two-dimensional space, and `H_2` is the
restriction to the prime field of that natural two-dimensional module; the
endomorphism algebra `F_4` is the coefficient field of that smaller module.  In
characteristic three no such descent exists and the four-dimensional module is
absolutely irreducible, so the commutant collapses to scalars.  The formal proof
does not use this; it solves the commutant equations directly.

The product formula premise is stated in full generality even though the
corollaries use only `m = 1, 3, 4`.  That is deliberate: the premise is then the
manuscript's proposition verbatim, and a reader comparing the two does not have
to check that a specialized Lean premise is implied by it.

## Mystery ledger

- Why the two commutants differ is settled, by the descent explanation above; it
  is an explanation of the formal result, not an open question.
- The endomorphism algebra in characteristic two is exhibited as a four-element
  field by generators, relations, and inverses rather than by an isomorphism
  with a named field object.  Closing that gap needs a commutative-ring and
  field structure on the commutant subring plus a cardinality computation, after
  which Mathlib's uniqueness of finite fields supplies the isomorphism.  Owner:
  a successor to this item; it would move the row from fragment toward complete.
- The framed second proof of one-step irrationality is now one bridging module
  away from being assembled end to end in Lean: the product-formula premises
  supply both the doubling formula and the vanishing at projective four-space
  that `Applications.CubicThreefoldOneStepInput` currently assumes.  What is
  missing is a signature identifying the abstract packet multiplicity with the
  framed sixth-root count and the two product operations with each other.  This
  is the highest-value open item created by this pass.
- Nothing else about the three landed statements is unexplained.

## Next

From the gap audit, still open: the rank-two invariant chain behind
`prop:rank2-rigidity` and its `prop:no-curve` and `prop:no-surface`
consequences, `lem:disc` and `lem:spectrum-transfer`, the missing unconditional
half of `cor:v14-one-step`, the order comparison that selects the exotic gluing,
and the disposition of the four orphaned machinery themes.

## Export status

Not exported.  The paper repository under `~/src/math-papers/` is now three
commits behind the authority.
