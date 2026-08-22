# C910 — gap audit after the 2026-08-16 atomic restructure

**Task:** C910 (`cubic-threefolds`) — Lean companion for
`papers/cubic-stabilization-m1/`.
**Date:** 2026-08-18.
**Inputs read:** manuscript sections `01`–`06` at authority `4ef6c743c`
(Section 4 in full), `lean/verification/claims.json`, `PaperInterface.lean`
headline block, `check_formal_artifact.py` coverage rules, and the claim-map
diff between `d92f27904` (pre-restructure) and `4ef6c743c`.
**Nothing was built or edited in the Lean package for this audit.**

## What changed under the companion

The author's atomic restructure replaced the paper's proof of the headline.
Before, Theorem~1.1 (`thm:every-cubic`) was proved from the framed
primitive-sixth invariant `nu_6`: value two on a cubic threefold, value four
on the stabilized fourfold, birational invariance through dimension four via
weak factorization, and `nu_6(P^4) = 0`.  That deduction is exactly what the
Lean package formalizes.  Now Theorem~1.1 is proved in Section 4 from the
ordinary Hodge-atom ledger of Katzarkov--Kontsevich--Pantev--Yu: the
projective-bundle formula gives `CF(X x P^1) = 2 CF(X)`, so the cubic atom
`alpha_X` occurs on the fourfold; a new rank-two invariant, the residue
discriminant `delta^sharp`, takes the value `4/9` on `alpha_X` and `0` on every
curve atom, which excludes representation in dimension at most two; and their
ordinary non-rationality criterion (Proposition~5.30) concludes.  The framed
route survives in Section 5 as a conditional refinement under Hypotheses 5.7R
and 5.7T, and Section 5 says so explicitly in its remark on a conditional
second proof.

The claim-map resync recorded the consequence mechanically: 26 labels added,
all `absent`; three labels dropped, freeing 46 kernel-checked terminals into the
new `machinery` bucket.  The coverage snapshot is 49 claims, 46 machinery rows,
29 absent / 10 fragmentary / 9 conditional / 1 complete, and `make check` is
green.  What the resync did not do is re-examine the rows it left alone.

## Finding 1: the headline row is mis-anchored, not merely incomplete

`thm:every-cubic` is byte-identical in the claim map before and after the
restructure — same coverage, same declarations, same hypothesis prose.  Its two
terminals, `irrational_of_nonzero_packet` and
`cubicThreefold_oneStep_irrational_of_packet_inputs`, take a packet
multiplicity, a `DimensionFourBirationalInput`, a rank-two projective-bundle
formula, a dimension bound, and vanishing on the rational comparison object.
Those are the premises of the *old* proof.  The manuscript's current proof of
that label uses none of them.

The Lean theorems are not wrong: they remain valid conditional deductions, and
they now mirror the Section 5 remark's conditional second proof.  But the claim
map asserts that the package's formal image of Theorem~1.1 follows the paper's
proof of Theorem~1.1, and that is no longer true.  A referee reading the claim
map would be told the headline is covered as a conditional deduction, then find
in the paper an unconditional proof by a different mechanism with nothing formal
behind it.  This is the one finding that is a correctness problem in the
artifact rather than a coverage shortfall.

The same mis-anchoring propagates to three dependent rows:

- `thm:separation-family` and the three separation corollaries take their
  irrationality input from Theorem~1.1.  Their caution text names the
  "every-cubic input", meaning the packet input.  Section 6 now derives all four
  from the unconditional atom route.
- `cor:v14-one-step` has been split by the author into an unconditional half
  (genus-eight `V x P^1` is birational to `X x P^1`, which Theorem~1.1 excludes)
  and a conditional half (`nu_6(V) = 2` under 5.7R and 5.7T).  Lean has three
  terminals, all serving the conditional half.  The unconditional half — a
  two-line birational-comparison argument — has no terminal at all.
- `prop:cubic-packet` is unconditional in the paper but conditional in Lean on a
  supplied characteristic polynomial.  Section 4's
  `prop:cubic-block-data` now derives that polynomial inside the paper from
  Cai's displayed matrix, so the premise Lean assumes is a statement the
  manuscript proves. That is a dischargeable premise, not a permanent boundary.

## Finding 2: the 26 new labels, tiered by what Lean can actually reach

The new labels are not homogeneous.  Roughly half are self-contained algebra
that the package's existing style handles directly; the rest are rigid-analytic
or `F`-bundle statements that can only become typed premise interfaces until
someone formalizes non-archimedean analytic geometry, which is out of scope.

**Tier 1 — closed-form arithmetic, reachable now, high value per unit effort.**

- The cubic residue computation: `R_X = [[-19/18, 2], [-8/81, 1/18]]`, trace
  `-1`, determinant `5/36`, characteristic polynomial `(T + 1/6)(T + 5/6)`, and
  hence `delta^sharp(alpha_X) = 4/9`.  Rational 2x2 arithmetic.
- The curve computation: `R_C = a E_21 - I/2`, repeated eigenvalue `-1/2`, and
  `delta^sharp(C) = 0`.  Same shape.
- Together these two are the entire contradiction that drives
  `prop:no-curve`, so they are the cheapest way to put real content behind the
  new route.  Mathlib's `discrim` is literally the invariant used:
  `delta^sharp = (tr R)^2 - 4 det R`.
- `cor:p3-nu6` and `cor:cubic-product-nu` are arithmetic corollaries of
  `prop:projective-product-nu` (`nu_6(T x P^m) = (m+1) nu_6(T)`); once that
  formula is a typed premise or theorem, each is one line.
- `lem:six-point-hearts` is a special case: the package already proves the
  `p = 2` half.  `sixPointHeartGeneratorStable_simple` gives simplicity and
  `sixPointHeart_fullActionCommutant_classification` gives the commutant, and
  `SixPointThreePrimary.lean` carries the `p = 3` heart, but no reviewer
  terminal states the lemma as the manuscript states it, so the row reads
  `absent` while the mathematics is largely present.  This is a mapping gap.

**Tier 2 — structured algebra, reachable with real but bounded work.**

- `prop:cubic-block-data`.  Explicit constant change of basis `C` with
  `det C = -486 r^5`, the resulting block form, and the unique normalized
  block-off-diagonal gauge solving order-by-order Sylvester equations.  Every
  step is matrix algebra over `Q(r)` plus a formal-power-series induction.
  Formalizing it discharges the standing premise of `prop:cubic-packet`.
- `lem:disc`.  The four Witt-frame derivations of the quartic discriminant.  The
  paper's own proof is the formalizable one: work universally in the polynomial
  ring on four formal roots, identify the derivations with
  `D_s = sum mu_i^s d/d mu_i`, and evaluate
  `D_s(Delta)/Delta = 2 sum_{i<j} (mu_i^s - mu_j^s)/(mu_i - mu_j)`.  Mathlib has
  no root discriminant of a quartic, so the package would define
  `Delta = prod_{i<j} (mu_i - mu_j)^2` itself, which is what the proof uses
  anyway.  The germ-vanishing tail is a lowest-homogeneous-part argument in a
  formal power series ring plus Euler's identity — also reachable, with the
  passage from completion to analytic germ left as a typed premise.
- `lem:spectrum-transfer`.  Finite-dimensional commutative algebra: idempotent
  decomposition of the even quantum algebra and nilpotence of `E - lambda_i` on
  each finite module.  Mathlib-native.
- `lem:horiz`, `lem:orthogonal`, `lem:A0preserve`, `prop:rank2-rigidity`,
  `prop:residue-discriminant-exponents`.  These are power-series matrix
  identities: horizontality coefficientwise, invertibility of the Sylvester
  operator `X -> U_i^T X - X U_j` when the leading eigenvalues differ by a unit,
  isotropy of `im N` for `N^2 = 0` in a nondegenerate rank-two symmetric space,
  and the 2x2 flatness computation forcing `K_delta = 0` and
  `delta R = [G_delta, R]`.  Every one is finite linear algebra over a
  commutative ring once the connection is presented as coefficient matrices.
  `prop:rank2-rigidity`'s conclusion, constancy of `(tr R)^2 - 4 det R`, is the
  natural terminal.
- `lem:simple-euler-block` and `prop:projective-product-nu`.  The first is a
  rank-one block computation with `P mu P = 0`; the second needs the
  Levelt--Turrittin tensor compatibility and Behrend's product formula as typed
  premises, but its arithmetic core (the `m+1` distinct eigenvalues of
  multiplication by `c_1(P^m)` and the resulting multiplicity count) is
  formalizable.

**Tier 3 — typed premise interfaces only.**

`lem:euler-sign`, `lem:hodge-base`, `prop:cubic-atom`, `lem:factor-glue`,
`lem:crossing`, `prop:atom-invariant`, `prop:no-curve`, `prop:no-surface`,
`prop:ranktwo-framed-germ`, `lem:exact-low-degree-shifts`,
`prop:direct-specialized-lowdim`.  These rest on the maximal `A`-model
`F`-bundle, the reduced spectral cover over the maximal-eigenvalue locus,
Conrad's identity principle for connected normal rigid spaces, the blowup and
projective-bundle chemical formulas, the nef-canonical lemma, and the minimal
model classification of surfaces.  None of that is in Mathlib and none of it is
in scope for this companion.  The right formal image is the package's existing
pattern: a premise structure naming each external input, with Lean proving only
the combinatorial deduction on top.  `prop:no-curve` and `prop:no-surface` are
the valuable ones, because their deduction — parity ranks force genus five,
`delta^sharp` separates `4/9` from `0`, blowups and projective bundles reduce a
surface to a point or curve atom — is real content that Lean can check once the
inputs are typed.

## Finding 3: the machinery bucket is a standing liability

The three dropped labels freed 46 terminals, grouped into six themes: the
pro-Laurent gauge tower, coefficientwise and flat base change, divisor and
string substitution, ideal-filtration and adic quotient towers, normalized flat
gauges with zero-curvature integrability, and the positive-filtration evaluation
branch.  Each row carries a reason, and the checker enforces that every terminal
is registered exactly once across claims and machinery, so the partition is
sound and the coverage snapshot discloses the count.

The liability is that a third of the package's exported surface now serves no
manuscript claim.  Two of the six themes — base change and the normalized flat
gauge — are direct prerequisites for Tier 2 items above, so they can be reclaimed
by the new work.  The other four support statements the paper deleted.  A future
pass should decide, per theme, whether to reconnect it to a Section 5 claim or to
retire it from the reviewer interface entirely.  Retiring is not free: it changes
the terminal count and the axiom audit, so it belongs in a deliberate commit, not
in a coverage sweep.

## Recommended work order

1. Re-anchor the headline.  Add an atom-route deduction to `PaperInterface`
   whose premises are the projective-bundle chemical formula, occurrence of the
   atom with positive multiplicity, non-representability in dimension at most
   two, and the ordinary non-rationality criterion; point `thm:every-cubic` at
   it; re-point the existing packet terminals to the Section 5 conditional
   second proof; and rewrite the caution text on `thm:separation-family` and the
   three separation corollaries to name the atom input.  Add the missing
   unconditional half of `cor:v14-one-step`.  This is the only item that repairs
   a false impression rather than adding coverage.
2. Land Tier 1.  The two residue computations, the two product-formula
   corollaries, and a terminal for `lem:six-point-hearts` built from the
   declarations already in `GraphLattices`.
3. Land `prop:cubic-block-data` and discharge the `prop:cubic-packet` premise,
   which converts the package's cubic input from an assumption into a proof.
4. Land the rank-two invariant chain: `lem:horiz`, `lem:orthogonal`,
   `lem:A0preserve`, `prop:rank2-rigidity`, `prop:residue-discriminant-exponents`,
   then `prop:no-curve` and `prop:no-surface` as typed deductions on top.
5. Land `lem:disc` and `lem:spectrum-transfer`.
6. Decide the fate of the four orphaned machinery themes.

Steps 1 through 4 would move the artifact from "the whole unconditional route is
unformalized" to "the unconditional route's arithmetic core and its final
deduction are kernel-checked, with the `F`-bundle inputs typed" — which is the
same standard the package already meets on the cycle side.

## Constraints that still bind

The formal standard is unchanged: no `sorry`, no `native_decide`, no project
axiom standing in for a proof, a self-contained docstring on every public
declaration, and exact bijection among manuscript claims, reviewer terminals,
and expected axiom rows.  Conditional scaffolding must never be reported as
unconditional coverage — which is precisely what Finding 1 is about.  Any Lean
work runs through the guarded build queue, and the paper repository under
`~/src/math-papers/` is downstream: the monorepo is edited and validated first.

## Observations worth keeping

The residue discriminant is a quadratic discriminant of a 2x2 residue, so the
invariant separating a cubic threefold's atom from every curve atom is
`(tr R)^2 - 4 det R` — arithmetic a proof assistant checks instantly.  The
mathematically deep part of Section 4 is entirely in showing the number is
well defined; the number itself is `4/9`.  That asymmetry is what makes Tier 1
cheap and Tier 3 expensive, and it is the reason a partial formalization here is
worth more than the coverage fraction suggests.

Second, `prop:cubic-block-data` is shared by Sections 4 and 5.  Formalizing it
once serves the unconditional atom route and the conditional framed route
simultaneously, which no other single item does.

## Addendum: the four labels this audit first omitted

The tiering above covered the Section 4 and Section 5 additions and
`lem:six-point-hearts`, but silently skipped `prop:A5-nonseparated` and the
three separation corollaries.  The cause was a reading gap: the audit was
written after reading Sections 1, 4, and 6 in full and Section 5 in part, with
Sections 2 and 3 seen only through their label lists.  Both sections have now
been read in full and the four labels are tiered here.

**`prop:A5-nonseparated`: mostly citation plumbing, with one small reachable
piece.  Low priority.**  The proposition says that the coarse-moduli image of
the `A_5`-pencil meets the separated-variable locus in finitely many points.
Its proof has five steps, and only two of them are Lean-shaped.  A form split
into blocks of at most three variables in five variables must have a block of
size one or two — that is a finite combinatorial statement about partitions of
a five-element set and is reachable immediately, though it carries little
weight on its own.  The closing deduction is also checkable once typed: a
proper closed subset of an irreducible curve of finite type is finite, and a
locus contained in the union of two such subsets is finite.  Everything in
between is imported — Gonz\'alez-Aguilera and Liendo's classification of
order-three families and their signatures, the Klein cubic's membership in the
signature `(0, 0, 1, 1, 2)` family, and Hartlieb's closedness and
irreducibility of the moduli images.  Formalizing the proposition would mean
typing four external statements to check two short steps.

**The three separation corollaries: mechanical, and worth doing for uniformity
rather than for new checking.**  `cor:voisin-separation`,
`cor:fermat-separation`, and `cor:coprime-separation` each combine an external
universal `CH_0`-triviality input with the projective-bundle formula for Chow
groups and the one-step irrationality theorem.  That is exactly the shape the
package already implements for `cor:universal-ch0` and
`thm:separation-family`, so each is a premise structure plus a two-line
composition.  The reason to land them is that all four separation statements
would then visibly consume the atomic irrationality terminal, which is what the
manuscript now uses; at present they are `absent` rows whose only connection to
the headline is prose.

**`lem:six-point-hearts`, confirmed against the statement.**  The lemma asserts
simplicity of the six-point heart over `F_2` and `F_3` together with the
endomorphism algebras `F_4` and `F_3`.  The manuscript proves it by exhibiting
the two generators as explicit four-by-four matrices in each characteristic,
noting that the minimal polynomial of the order-five generator is the fifth
cyclotomic polynomial and is irreducible because `p` has order four modulo
five, and solving the commutant equations, with the modular Atlas cited as
agreement rather than as evidence.  The Lean package proves the `p = 2`
simplicity and commutant classification and carries the `p = 3` heart with its
form and action.  A terminal stating the lemma as the manuscript states it
would make it internal to the artifact.  The Tier 1 placement stands.

**New finding: the exclusion that selects the exotic gluing ends in an
unformalized arithmetic check.**  The proof of
`prop:principal-gluing-packet` rules out a rational two-primary kernel by
showing that `S_6` would then act faithfully on a smooth cubic threefold, and
closes by comparing orders against Hartlieb's classification of faithful
automorphism groups: `|S_6| = 720`, five of the six listed ambient groups are
smaller, and the sixth has order `9720`, which is not divisible by `720`.  The
claim row is `fragment` with fifteen terminals, and those cover the `F_4` and
`A_5` side — the projective-line packets, isotropy, the Frobenius exchange, and
the identification of the exceptional stabilizer with the alternating group of
order sixty.  They do not cover this final comparison: neither `720` nor `9720`
occurs anywhere in the Lean sources.  The check is Tier 1 arithmetic once the
six group orders are supplied as a premise, and it is the step that actually
selects the exotic pair, so it is worth more than its size suggests.
