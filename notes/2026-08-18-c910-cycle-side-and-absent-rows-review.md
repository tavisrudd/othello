# C910 — review of the nine remaining fragment rows and the ten absent rows

**Task:** C910 (`cubic-threefolds`) — Lean companion for
`papers/cubic-stabilization-epilogue/`.
**Date:** 2026-08-18.  **Authority commit at review start:** `97d42fa6b`.
**Predecessor:** `2026-08-18-c910-claim-map-review.md`, which reviewed the
eighteen conditional deductions, the single complete row, and twelve of the
twenty-one fragments, and left these nineteen rows open.

## Method and scope

Unchanged from the predecessor.  For each row: read the manuscript statement
with its annotations stripped, read the elaborated signature of every terminal
the row registers, and ask whether the recorded conclusion states what the
terminals prove, whether the cautions name what is missing at the strength the
theorem types actually have, and whether the coverage label is right.  For an
`absent` row the check is lighter: the row must register no terminal, carry no
`\lean`, and describe the absence accurately.

The predecessor called the nine remaining fragments the cycle-side rows.  Eight
of them are: `lem:six-point-hearts`, `prop:six-axis-polarization`,
`lem:relative-six-axis`, and `prop:principal-gluing-packet` in the envelope
section, and `lem:graph-coefficient-lattice`, `thm:all-degree-graph-saturation`,
`lem:six-axis-local-chart`, and `thm:six-axis-divided-powers` in the
minimal-class section.  The ninth, `lem:numerical-base-change`, is a
framed-monodromy row and not cycle-side; it is reviewed here with the others.
Between them the nine register eighty-eight terminals.

## The nine fragments: verdict

All nine are correctly labelled `fragment`.  In every case the objects the
manuscript statement speaks about — the relative elliptic scheme and its
isogeny, the geometric axes, the marked finite-étale graph presentation, the
quantum connection — are not constructed in the package, and the terminals are
about explicit algebraic surrogates, which is what the convention's fragment
value means.  No row overstates its coverage value, and no row registers a
terminal that fails to support the clause it is registered for.

Six of the nine needed a change to their recorded prose.  All six changes are
applied and the gate is green; the digests are untouched, because the digests
cover the manuscript statement and the terminal signatures, not the row's
description of them.

**`lem:six-point-hearts`.**  The conclusion is exact.  The last caution clause
said the six labels "are not identified with dihedral subgroups arising from a
geometric object", which misdirects for this statement.  The manuscript indexes
the module by the six conjugate order-ten dihedral subgroups of the alternating
group, equivalently the six Sylow-five subgroups with their normalizers — a
purely group-theoretic object, and one the package does realize: it constructs
the six order-five subgroups, proves that the two generators conjugate them by
exactly the displayed label permutations, and computes each normalizer's order
as ten, and it separately proves that the generated six-point action is the
whole alternating group.  What actually keeps the row short of `complete` is
that those two facts are not composed into this terminal's type and that the
commutants are exhibited by generators and relations rather than by an
isomorphism with named field objects.  The caution now says that, and says that
identifying the labels with the six geometric axes is required by later
statements rather than by this one.  This is the fragment nearest to
`conditional_deduction` or better in the whole map.

**`prop:six-axis-polarization`.**  Accurate as recorded.  The three typed
hypotheses of the parameter-uniqueness terminal — positivity of the diagonal,
the vanishing invariant sum, and the intersection equation — are exactly the
three inputs of the manuscript's numerical step, and the Gram matrix Lean
reduces is the five-axis minor with diagonal five and off-diagonal minus one,
as the coherent identification produces it.  The cautions named the geometric
absences but not the imported results that supply the two typed equations, so
they now also name Roulleau's intersection table, the Clemens–Griffiths
minimal-class identity, and Grieve's polarized Riemann–Roch trace formula, and
record that the generic-fibre isogeny asserted by the statement's second
sentence is not constructed.

**`lem:relative-six-axis`.**  Accurate, with one thing left unsaid.  The main
terminal takes an opaque geometric-input structure and returns a conclusion
structure whose first field merely asserts that such an input exists; every
other field — the Smith witness, the tensor-kernel equivalence, the coefficient
and polarization form properties, and both stable maximal-isotropic packet
classifications — is an unconditional statement about explicit objects that
does not mention the supplied input at all.  The caution said the terminal
"repackages" the supplied propositions; it now also says the supplied packet is
inert for the independent content and reappears in the conclusion only as the
assertion that it exists.

**`prop:principal-gluing-packet`.**  Accurate as recorded, and the most
detailed row in the map.  Two clauses were checked against the manuscript in
full.  The exclusion terminal matches the manuscript passage exactly: the order
of the symmetric group on six letters is computed, the classification of
faithful automorphism groups enters as the hypothesis that the ambient order is
drawn from a supplied list each of whose entries is below seven hundred twenty
or equal to nine thousand seven hundred twenty, and the conclusion is that no
injective homomorphism exists.  The Frobenius normalizer terminal likewise
matches its recorded sentence clause for clause.  The projective-line,
Sylow-five, and two-transitivity content the conclusion describes is present,
inside the quadratic-commutant terminal.  No change.

**`lem:graph-coefficient-lattice`.**  The conclusion described the Lean
architecture rather than the manuscript's displayed content.  The three things
the terminals actually establish about the cross depth are that divisibility by
its uniformizer power is exactly the conjunction of the three power-divisibility
conditions, that the sum of the two diagonal depths is at most twice it, which
is the statement's midpoint bound, and that pairing depth zero with a
positive-depth block returns that positive depth, which is the unit-block
clause.  The conclusion now states all three.  A caution was added recording
that the cross-depth formula is the Lean definition of the pairwise depth, with
truncated slope-difference subtraction and an infinite valuation contributing
nothing, so it is not itself a derived identity.

**`thm:all-degree-graph-saturation`.**  The composite terminal's conclusion is
the manuscript's own: the supplied divided power lies in the ordinary
degree-`k` product submodule and its factorial multiple is the `k`-th power of
the base class.  The label is nonetheless `fragment`, correctly, because the
marked finite-étale graph presentation does not exist in the package and the
basis, realization, and compatibility data are supplied.  One caution carried a
wrong equation number: it blamed the divided-power compatibility on the
manuscript's rank-one cross-block generation identity rather than on its
divided-power expansion, and it understated what is proved.  The corrected
caution records that the division-free square-zero expansion is proved, that
rank-one classes on the canonical elliptic source are proved decomposable and
square-zero, and that what remains assumed is only the identification of the
manuscript's divided power with the resulting squarefree product sum after
extension.

**`lem:six-axis-local-chart`.**  The conclusion is accurate and the cautions
were thorough about the geometric absences, but two clauses of the statement
had no caution at all: that the principal quotient is trivial on the rank-one
summand, and that the slope has a depth-preserving integral lift self-adjoint
for the dual coefficient form.  Nothing in the package formalizes that lift.
It is worse than uncovered: the manuscript's construction of it runs in the
text between statements, so no statement digest covers it either, and it is the
clause that turns these data into the marked finite-étale graph presentation
that the all-degree saturation theorem consumes.  A caution recording both
omissions was added.

**`thm:six-axis-divided-powers`.**  Accurate as recorded, including the caution
that the fourth divided power of the theta class is not proved to lie in the
product image.  The recorded observation that the elementwise denominator
witnesses make finite generation unnecessary matches the terminal.  No change.

**`lem:numerical-base-change`.**  Accurate as recorded, and the cautions are
the sharpest in this group.  The manuscript asserts three things: that the
quotient extends continuously to completed monoid rings, and that the quantum
connection and the two comparison theorems base-change along it.  Lean covers
the first with an explicitly non-topological surrogate, and the cautions say so
in those words — cutoff continuity is a quantified coefficient-agreement
predicate, with no topology, uniform space, limit cone, or universal property
represented — and they say the quantum connection and the base change of the
comparison isomorphisms are not represented at all.  No change.

## The ten absent rows: verdict

All ten register no terminal, carry no `\lean` annotation, and describe their
absence accurately.  Three are the separation corollaries of the introduction,
one is the finite separated-variable intersection in the minimal-class section,
and six are in the framed-monodromy section.

Four of the ten do more than assert absence, and usefully so: they say where
the adjacent Lean material lives and why it does not cover the row.  The exact
string and fixed-divisor shifts row records that the manuscript no longer routes
that argument through the machinery the companion formalizes.  The rank-two
formal-germ rigidity row records that the companion's formal-germ material
treats gauge and base-change invariance rather than rigidity.  The direct
specialized low-dimensional vanishing row records that the Lean material is
registered under the combined conditional vanishing claim.  The products with
projective space row records that the formula enters the two product-formula
corollaries as a typed premise and that the companion's projective-bundle
formula is registered under the framed-operations claim and proved under the
reconstruction-tail hypothesis, whereas this statement is unconditional.

One change was made.  The multiplicity-one Euler block row said only "Not
formalized."  That lemma is the shared input of three further uncovered
statements in the same section — the product formula for the framed sixth-root
count, the projective-line and projective-plane cases of direct specialized
low-dimensional vanishing, and formal-germ persistence of the cubic packet — so
the caution now names them and records that the cluster is uncovered as a whole.

## Findings that outlive the individual rows

**The imported-source annotations are recorded only for the atomic route.**
Every `\imports` annotation in the manuscript is in the atomic one-step section.
The envelope section imports Roulleau's intersection table, the
Clemens–Griffiths minimal-class identity, Grieve's polarized Riemann–Roch, and
both of Hartlieb's theorems, and carries none; the minimal-class,
framed-monodromy, introduction, and synthesis sections carry none either.  The
verification README said this of the dependency edges but not of the imported
sources, so a reader could take an unannotated statement for one with no
external input.  The README now says it of both.  Filling the envelope and
minimal-class imports is the natural successor, and the six-axis polarization
row is where it would start.

**The Section 5 absent rows form one closed cluster.**  Of the six absent rows
in the framed-monodromy section, four depend on each other: the
multiplicity-one Euler block lemma feeds the product formula, the direct
low-dimensional vanishing cases, and formal-germ persistence of the cubic
packet, and the last of those also needs rank-two formal-germ rigidity.  The
cluster is entered from covered territory in exactly one place — the product
formula is a typed premise of the framed-operations claim and of the cubic
product corollary.  Closing the Euler block lemma and the product formula would
therefore discharge a premise that two conditional deductions currently expose,
and is the highest-leverage next coverage on the absent side.

**One manuscript clause is invisible to both digests and to the claim map.**
The depth-one self-adjoint lifting construction is stated and proved in running
text between two statements of the minimal-class section.  It is what licenses
the last clause of the local-chart lemma, and through it the marked
finite-étale graph presentation the saturation theorem consumes.  No statement
digest covers text between environments, no terminal covers it, and until this
review no caution mentioned it.  This is the known limit of the layer meeting a
load-bearing step rather than an incidental remark, and it is the strongest
argument yet for the proof-level dependency edges the conventions recommend.

## Changes applied

Six fragment cautions or conclusions, one absent-row caution, one earlier
fragment caution left over from the predecessor review, and one README
paragraph:

- `lem:six-point-hearts` — caution rewritten to name the real gap.
- `prop:six-axis-polarization` — caution extended with the imported inputs and
  the unconstructed isogeny.
- `lem:relative-six-axis` — caution extended to say the supplied packet is inert.
- `lem:graph-coefficient-lattice` — conclusion extended with the three proved
  depth facts; caution extended to say the formula is a definition.
- `thm:all-degree-graph-saturation` — caution corrected to the divided-power
  expansion and to what is proved.
- `lem:six-axis-local-chart` — caution extended with the two uncovered clauses.
- `lem:simple-euler-block` — caution extended with its dependent cluster.
- `lem:horiz` — the doubled phrase "the mathematical content of the manuscript
  lemma", which the predecessor review's rewrite left referring to two different
  things, reduced to one referent.
- `verification/README.md` — imported-source annotations declared limited to
  the atomic route, as the dependency edges already were.

## Gates

`make check` passes after the edits: source-only mode over 115 sources, 220
terminals, 50 manuscript claims, 46 machinery rows, 14 imported sources, and the
coverage snapshot of 10 absent, 21 fragmentary, 18 conditional, 1 complete.  No
digest was refreshed, and none needed to be: the statement and terminal digests
cover the manuscript text and the elaborated terminal signatures, neither of
which this review touched.

Every row of the claim map has now been reviewed against its statement and its
terminals, which is the fifth and last step of the adoption order in the
annotation conventions.  The digest baseline recorded earlier is now backed by a
review of every row it freezes.
