# Module 14. Configuration menu and optional enrichments

**Packet part:** Modules 14--18.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

The proof above used a counting consumer because it makes the contradiction
read \(2=0\).  The interface permits strictly less or substantially more
retention.

| Configuration | Observation | Selector | Value monoid | Information retained |
| --- | --- | --- | --- | --- |
| `CubicExists` | \((r,[N\ne0],[\delta^\sharp\ne0])\) | equals \((2,1,1)\) | Boolean `or` | existence only |
| `CubicCount` | same | same | \((\mathbf N,+)\) | multiplicity |
| `ResidueProfile` | rank, Jordan type, \(\chi_R\) | caller supplied | free multiset | exact selected residue profiles |
| `ParityProfile` | even/odd ranks plus residue profile | caller supplied | free multiset | parity-enriched signatures |
| `Universal` | full block class | keep all | \(\mathbf N^{(\Pi)}\) | complete generic even-block multiset |

## 14.1 Boolean existence: a compact sufficient consumer

Let
\[
\mathbf N\longrightarrow(\{0,1\},\lor),
\qquad
n\longmapsto[n>0].
\tag{14.1}
\]
This is a commutative-monoid homomorphism.  Postcomposing \(\mathcal C\) gives
a Boolean package \(\mathcal C_{\exists}\).  Then
\[
I_{\mathcal C_{\exists}}(X\times\mathbf P^1)=\mathrm{true},
\qquad
I_{\mathcal C_{\exists}}(\mathbf P^4)=\mathrm{false}.
\]
Thus existence alone proves irrationality.  The multiplicity two is optional.

## 14.2 Exact signature multiset

One may instead observe
\[
(\operatorname{rank},\operatorname{Jordan}(N),\chi_R(T))
\]
and take the free commutative monoid on such observations.  This retains the
entire distribution of rank-two modified-residue characteristic polynomials.
The cubic observer is obtained by the forgetful predicate
\[
\operatorname{rank}=2,\qquad N\ne0,\qquad
\operatorname{disc}\chi_R\ne0.
\]

## 14.3 Parity-enriched blocks

If odd ranks are wanted for another application, replace the even block
groupoid by the parity-graded block groupoid
\(\mathsf{QBlock}^{\mathrm{gr}}\).  This enrichment is available because the
even quantum algebra acts unitally on total cohomology.

### Lemma 14.1 — spectrum transfer

Multiplication by an even element has the same set of eigenvalues on the even
quantum algebra and on total cohomology.

### Proof

After a splitting-field extension, decompose the even Artinian algebra by its
generalized-eigenvalue idempotents:
\[
A=\bigoplus_\lambda A_\lambda,
\qquad 1=\sum_\lambda e_\lambda.
\]
Then
\[
H^\bullet(Y)=\bigoplus_\lambda e_\lambda H^\bullet(Y).
\]
Every summand is nonzero because \(e_\lambda=e_\lambda\cdot1\).  On
\(A_\lambda\), \(U-\lambda\) is nilpotent, so it acts nilpotently on every
finite \(A_\lambda\)-module.  There are no additional total-cohomology
eigenvalues. ∎

There is a forgetful functor
\[
\mathsf{QBlock}^{\mathrm{gr}}
\longrightarrow
\mathsf{QBlock}^{\mathrm{ev}}.
\tag{14.2}
\]
A parity-enriched observer may retain
\((r_{\bar0},r_{\bar1})\); the earlier \((2,10)\) cubic signature is one such
configuration.  The proof in Modules 10--13 factors through the forgetful
functor and deliberately discards \(r_{\bar1}\).

## 14.4 Formal-monodromy observer

One may emit the conjugacy class, characteristic polynomial, or eigenvalue
ratio of formal monodromy after the canonical shear.  This is lawful under
meromorphic connection isomorphism and is independent of the choice of
regular lattice.  It is not used here because proving its constancy invokes an
isomonodromy statement, whereas Lemma 4.4 gives discriminant constancy
directly from coefficients of flatness.

## 14.5 Full block observer

At the maximal setting, take \(O=\Pi\), keep every block, and emit its basis
vector in \(\mathbf N^{(\Pi)}\).  Then the marker invariant is exactly the
universal spectrum \(\mathcal B^{\mathrm{ev}}\).  Every other even-block
configuration in this packet is a postcomposition of this maximal observer.

The dependency direction is therefore
\[
\boxed{
\text{full block multiset}
\longrightarrow
\text{exact signature multiset}
\longrightarrow
\text{qualitative count}
\longrightarrow
\text{Boolean existence}.}
\tag{14.3}
\]

## 14.6 Coarsening by finite Kan extension

Let \(f:O_{\mathrm{rich}}\to O_{\mathrm{coarse}}\) forget part of an
observation.  On free commutative monoids it induces
\[
f_!: \mathbf N^{(O_{\mathrm{rich}})}
\longrightarrow \mathbf N^{(O_{\mathrm{coarse}})},
\qquad
(f_!m)(c)=\sum_{f(o)=c}m(o).
\tag{14.4}
\]
This is the finite-support left Kan extension along the map of discrete
observation categories.  It gives aggregation automatically: all rich
signatures with the same coarse signature have their multiplicities added.
For Boolean-valued predicates the same left-Kan formula uses `or` and means
"there exists a rich signature over \(c\)"; the right-Kan formula uses `and`
and means "every rich signature over \(c\)".  Infinite fibres require the
corresponding target colimits or limits, so this packet uses only finite
support or explicitly supplies that completeness.

Postcomposition from Definition 2.4 and Kan aggregation solve different
problems.  Postcomposition changes the answer attached to each block.  The
map \(f_!\) changes the indexing set on which a whole signature multiset is
reported.  Their standard mate/fusion square commutes, so one may aggregate
before or after applying a compatible monoid-valued marker.

## 14.7 Retention through endomorphism categories

For a nilpotent leading term, a block may be regarded first as an object
\((V,N)\) of the category of finite-length \(K[t]\)-modules, with \(t\)
acting as \(N\).  There is a strict retention ladder
\[
\text{isomorphism groupoid}
\longrightarrow K_0^{\mathrm{split}}
\longrightarrow K_0^{\mathrm{exact}}
\longrightarrow \mathbf Z.
\tag{14.5}
\]
Over an algebraically closed field, Krull--Schmidt makes the split group free
on the Jordan blocks \(J_n\), so it retains the Jordan partition.  The exact
group of nilpotent finite-length \(K[t]\)-modules remembers only total length,
because every composition factor is \(K[t]/(t)\).  Thus passing from split to
exact \(K_0\) destroys precisely the extension data that distinguish Jordan
blocks.

Likewise, an invertible formal-monodromy operator is an object of
\(\operatorname{Rep}_K(\mathbf Z)\), equivalently a finite-dimensional
\(K[t,t^{-1}]\)-module.  Direct sum sends it to multiplication of
characteristic polynomials.  One may therefore retain the full representation
groupoid, its split class, or only the characteristic polynomial.  This
categorical ladder explains why a higher-stabilization theory should not pass
to an exact Grothendieck group before deciding whether extension classes are
part of the marking.

---

# Module 15. Hostile audit

## H1. Does the marker interface assume additivity?

No.  Additivity occurs in the free block monoid before a marker is chosen.
Every marker consumer is required only to be a commutative-monoid
homomorphism.  Noncancellative consumers such as Boolean `or` are allowed.

## H2. Can spectra from different comparison summands collide?

Not generically.  The combined bulk Jacobians in the two source theorems are
invertible.  Their even-even blocks remain invertible on the even slice, so
the summands have independent unit coordinates.  Lemma 5.1 separates their
Euler spectra by a nonzero resultant.

## H2A. Does separation make every coordinate-dependent observer lawful?

No.  Independent unit translations separate spectra, but they also change an
uncentered Euler-eigenvalue function.  Definition 2.1 therefore includes the
formal-coordinate pseudonaturality law, and the universal ledger localizes
the indexed Grothendieck construction by coordinate pullback.  The cubic
marker is centered and coordinate-insensitive; the general interface may not
silently compare values at unrelated coordinate names.

## H3. Is an opposite Laurent completion treated as a localization?

No.  Module 3 uses the common spine
\[
R_{\mathrm{full}}\leftarrow R_0\rightarrow R_\infty
\]
and compares algebraic generic data over field extensions of
\(\operatorname{Frac}(R_0)\).  No map between the outer completions is used.

## H4. Can the raw center specialization kill a block?

Not after numerical reduction and divisor tagging.  Lemma 6.1 proves the
reduced coefficient map injective.  The proof uses both finite fibres and
independent divisor characters; neither alone is sufficient.

## H5. Are successive Iritani comparisons composed?

No.  Every ledger equation is intrinsic.  A later center calculation starts
again from that center's numerical reduced QDM and its own coefficient spine.

## H6. Can a regular comparison change the modified residue?

It conjugates it.  The intrinsic line \(L=\operatorname{im}N\) and the
modified lattice are transported by the constant term of the regular gauge.
Negative powers of \(z\), which could shift exponents, are excluded by the
source coefficient rings.

## H7. Does the cubic repeated eigenvalue split on the big base?

No.  Equation (10.10) places every partial derivative of \(\det N\) in its own
principal ideal.  Lemma 10.1 forces \(\det N=0\), while a unit matrix entry
forces \(N\ne0\).

## H8. Is algebra semisimplicity confused with simple Euler spectrum?

No.  For \(\mathbf P^2\) and \(\mathbf P^4\), the proof checks directly that
multiplication by the Euler element has distinct eigenvalues at a small point.
This makes the Euler discriminant, not merely the algebra discriminant,
generically nonzero.

## H9. Does low-dimensional vanishing use the discarded odd rank?

No.  Curves are separated by \(N=0\) or \(\delta^\sharp=0\); nef-canonical
surfaces have even rank at least three; the remaining surfaces reduce to
rank-one blocks or curves.  The number \(b_3(X)=10\) never enters.

## H10. Is the categorical diagram claiming a false equality of raw spectra?

No.  Raw block spectra may differ by center summands.  Equality occurs only in
the center quotient \(\mathcal L_{>2}\), after which any center-vanishing
marker functor may be applied.

## H11. Does group completion silently discard Boolean obstructions?

No.  Center localization is performed in the effective symmetric-monoidal
category or its commutative monoid.  The Bittner/Grothendieck-group backend is
optional and explicitly unavailable for Boolean `or`, whose group completion
is trivial.

## H12. Is Guéré's evaluation map being treated as a field extension?

No.  It is a probe in an indexed theory.  Its cofinite quantifier and possible
spectral collisions are retained.  The direct-sum law is invoked only after
the unit-shift separation used in Guéré's own proof.

## H13. Does the KKPYY specialization invent a category of atoms?

No.  Local spectral blocks form the categorified input.  The published atom
equivalence is then represented by its presented thin groupoid solely so that
the free symmetric-monoidal compiler may act on it.  No natural atom
morphisms are asserted.

## H14. Does the generalized compiler prove the imported frameworks?

No.  It subsumes their transport, atomization, marking, and retention laws.
Non-Archimedean convergence, motivic actions, monodromy irreducibility, and
the Iritani comparison theorems remain provider obligations.

## H15. Can a coarsening destroy extension data accidentally?

Yes, unless its target is chosen deliberately.  Module 14.7 records the exact
loss: split \(K_0\) retains Jordan-block multiplicities, while exact \(K_0\)
retains only total length.  The interface therefore makes the retention
quotient an explicit parameter rather than a default.

## H16. Does categorical packaging alone prove \(m=2\)?

No.  It proves the constituent-additive no-go, the ideal-quotient composition
theorem, and the \(\mathbf G_a\) coherence laws.  The enriched QDM comparison
functor landing in the augmented-row category is still a geometric/analytic
input.  Once that functor exists, its row-output kernel ideal is formal by
Theorem 19.3A.

## H17. Can finite deck monodromy replace the nilpotent operation?

No.  A finite cyclic action is semisimple in characteristic zero.  It can
retain branch provenance through a Burnside or Mackey marker, but cannot
distinguish the extension \(J_3\) from three split constituents.  The needed
operation lives in the commuting \(\mathbf G_a\) factor.

## H18. Is wall-local annihilation enough for a long factorization?

Not when the identities live in separately chosen receivers.  Actual
row-line-compatible isomorphisms in one augmented category compose and invert
without a quotient.  Alternatively, Theorem 19.3 applies after all receivers
and overlap 2-cells map through one retained-shadow functor, whose kernel is
then two-sided.  Constructing that global provider, not constructing the
ideal algebra, is the composition gate.

## H19. May higher-codimension exceptional copies remain split?

Not in an operation-framed rig lift.  Equation (19.13) forces their total
Jordan type to be \(J_{m-1}\).  Treating them as
\(J_1^{\oplus(m-1)}\) is compatible only after forgetting the operation, or
in the accidental case \(m=2\).

## H20. Does a lens invert a forgetful map?

No.  An ordinary lens can update a focus while the original source, including
its residual context, is still present.  It does not reconstruct the source
from the focus alone.  Reconstruction requires either a retained residual, a
contractible forgetful fibre, or a second jointly conservative shadow.

## H21. Does recording the name of a forgetting path preserve its payload?

No.  A path label supplies provenance and selects possible Beck--Chevalley
transport, but two rich objects can traverse the same path to the same shadow.
The path becomes reconstructive only when it carries an optic residual or a
cartesian lift to a common source on which the desired marker is constant.

## H22. Is every sparse reconstruction shadow closed under composition?

No.  The complete nilpotent kernel profile is closed under direct sums and,
in characteristic zero, determines the tensor decomposition.  The single bit
\(D^m\ne0\) detects the desired endpoint string but is not by itself a lawful
provider for arbitrary tensors or wall comparisons.  Consumer sufficiency
must not be confused with provider closure.

## H23. Is a function on path labels enough to transport retained data?

No.  A path translator must preserve identities and composition, at least up
to coherent 2-cells, and the shadow map must be natural with respect to it.
Without that naturality square, mapping a route and mapping the payload are
unrelated operations.

## H24. Is the naked row annihilator a two-sided ideal?

No.  The \(2\times2\) matrix counterexample before Theorem 19.3A disproves
this, and its two-sided closure can contain the identity.  A lawful quotient
uses the kernel of the augmented-row output functor or another named additive
retained-shadow functor.  For an ordered path of actual row-compatible
isomorphisms, no quotient is needed.

## H25. Is the point row transported covariantly?

No.  On column carriers it is a covector.  The typed comparison law is
\[
r_{\mathrm{target}}\circ f=\ell\circ r_{\mathrm{source}},
\]
with \(fT= T'f\).  Exact normalization is unnecessary for the nonvanishing
Boolean when \(\ell\) is invertible.

---

# Module 16. Source boundary

The proof uses the following external inputs.

1. Beauville, *Quantum cohomology of complete intersections*,
   arXiv:alg-geom/9501008, main theorem and formulas (2.1)--(2.3), for the
   cubic small quantum ring.
2. Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555v3, Remark 2.3,
   Remark 5.6, equations (5.15) and (5.38)--(5.43), and Theorem 5.18.
3. Iritani--Koto, *Quantum cohomology of projective bundles*,
   arXiv:2307.03696v4, equation (5.2), Theorem 5.1, and Remark 5.3.
4. Abramovich--Karu--Matsuki--Włodarczyk, arXiv:math/9904135, Theorem 0.1.1,
   including the projective conclusion.
5. The standard classification of minimal smooth projective surfaces with
   non-nef canonical class.

The optional backend in Module 7.8 additionally uses F. Bittner,
*The universal Euler characteristic for varieties of characteristic zero*,
Compositio Math. 140 (2004), for the smooth-projective blowup presentation of
\(K_0(\mathsf{Var}_{\mathbf C})\).  It is not an input to the cubic proof.

The proof does not use Cai, KKPYY/HYZZ reconstruction, Hodge atoms,
David--Hertling, or a recursive comparison of asymptotic completions.
Module 17 cites Guéré, Benedetti--Fay--Guéré--Manivel--Perrin, and
KKPYY only to test the general interface against their frameworks; none is an
additional input to Modules 10--13.

The exact identities in §10.3 were replayed in rational symbolic arithmetic by
`notes/cubic-threefolds-tasks/c924-finite-cubic-check.py`; its checked output is
`notes/cubic-threefolds-tasks/c924-finite-cubic-check.json`.  The displayed
matrix calculation remains the mathematical proof.

---

# Module 17. External-framework specialization audit

This module asks for literal law-preserving instances of Module 7.6.  It does
not count a shared slogan or a similar blowup formula as subsumption.

## 17.1 Guéré's evaluated coarse-block instance

Fix the morphism and coefficient ring used to define Guéré's evaluations.
The instance data are as follows.

- A probe is a nonvanishing \(K\)-evaluation map
  \[
  \mathrm{ev}:\widehat R^*_{Z,K}\longrightarrow S_K^*.
  \tag{17.1}
  \]
  The filter is the cofinite filter: a statement is eventual when it fails for
  only finitely many evaluation maps.
- The local blocks are the generalized eigenspaces
  \[
  E^Y_{\mathrm{ev},\alpha}
  =\ker(\mathrm{ev}(\kappa_\tau)-\alpha)^m,
  \qquad m\gg0.
  \tag{17.2}
  \]
- The decoration remembers Guéré's tuple
  \[
  o_Y(\mathrm{ev},\alpha)
  =(\rho,\nu,\nu',\gamma),
  \tag{17.3}
  \]
  measuring the Hodge-class part, Hochschild-degree-two and degree-one
  parts, and the rank of \(\mathrm{ev}(\kappa_\tau)-\alpha\) on the block.
- Scaling an evaluation and translating it in the unit direction reindex the
  spectrum by a bijection and preserve (17.3).  They are therefore lawful
  probe morphisms, not changes to the retained value.

Define Boolean violation markers
\[
\begin{aligned}
\operatorname{bad}_{\clubsuit}(\rho,\nu,\nu',\gamma)
&=[\nu\ne0\ \text{and}\ \rho\le2],\\
\operatorname{bad}_{\heartsuit}(\rho,\nu,\nu',\gamma)
&=[\nu\ne0,\ \nu'=0,\ \gamma\le1].
\end{aligned}
\tag{17.4}
\]
For each probe, fold these values with Boolean `or` over all eigenblocks.
The resulting function on probes is considered in the quotient Boolean
algebra
\[
\{0,1\}^{P(Y)}/\mathrm{Fin},
\tag{17.5}
\]
where two functions agree if they differ on only finitely many probes.  Then
Guéré's Properties \(\clubsuit\) and \(\heartsuit\) are exactly the
statements that the corresponding violation class in (17.5) is zero.

Iritani's evaluated blowup isomorphism, in Guéré's Corollary 37, gives the
comparison span and adds the four measurements at a fixed eigenvalue.  A
unit translation of a center evaluation can make its finite spectrum disjoint
from any prescribed finite collection.  Guéré's Proposition 38 uses exactly
this separation operation, and Corollary 41 composes it along weak
factorization.  Thus the \(\clubsuit/\heartsuit\) formalism is a genuine
instance of the probe-indexed interface.

Equivalently, let \(V_\diamond(Y)\) be `true` when the support of the
violation function is infinite, i.e. when its class in (17.5) is nonzero.
Guéré's Proposition 38 is exactly the Boolean blowup law
\[
V_\diamond(\operatorname{Bl}_Z Y)
=V_\diamond(Y)\lor V_\diamond(Z),
\qquad \diamond\in\{\clubsuit,\heartsuit\}.
\tag{17.6}
\]
Multiplicity \(r-1\) is invisible to the idempotent `or` consumer.

It is **not** an instance of Definition 2.1 without the extension in Module
7.6: evaluation is a specialization rather than a generic field extension,
specialized spectra can collide, and the invariant contains a cofinite
quantifier over probes.

## 17.2 The Benedetti--Fay--Guéré--Manivel--Perrin marked instance

The BFGMP criterion uses the same evaluated blocks, but adds a transported
mark.  For a Hodge-general Fano fourfold in their hypotheses, monodromy
irreducibility and equivariance put the whole vanishing cohomology into one
generalized eigenspace.  Define a marked local block to be
\[
(E_{\mathrm{ev},\alpha},
  H^4_{\mathrm{van}}\hookrightarrow E_{\mathrm{ev},\alpha}),
\tag{17.7}
\]
and retain its Hochschild-degree pieces and the codimension of its Hodge
classes.  Their pairwise-disjoint maximal-spectrum choice supplies the
separation contract along a chosen weak factorization.  Surface inequalities
then rule out every possible carrier of the marked block.

This is a specialization of the **pointed** or **marked** version of Module
7.6, in which the fibre over a local block is a groupoid of retained labels or
subobjects and comparison spans must transport the label.  It demonstrates
why `select` cannot always be merely a predicate on an unmarked isomorphism
class: the distinguished monodromy subrepresentation is part of the proof
state.

The framework recovers the architecture of BFGMP Theorem 4.1, conditional on
its geometric inputs (Hodge generality, monodromy irreducibility, and the
surface bounds).  It does not turn those inputs into formal consequences of
the QDM ledger.

## 17.3 The KKPYY atom and chemical-formula instance

For a \((G,\epsilon_G)\)-symmetric Weil cohomology theory, take as carrier the
non-Archimedean maximal \(G\)-equivariant A-model \(F\)-bundle on the
\(G\)-fixed base.  Over the locus where the reduced spectral cover is
unramified, a local block is a connected component of that cover together
with its generalized-eigenvalue \(F\)-bundle and \(G\)-representation.
The split object records such a component with multiplicity equal to the
degree of that component over the base; this is the multiplicity in the
chemical formula.

The atomizer is the quotient generated by:

1. automorphisms and disjoint-union identifications;
2. the local correspondence induced by the canonical blowup decomposition;
3. the local correspondence induced by the projective-bundle decomposition.

This is precisely KKPYY Definition 5.16.  Since KKPYY explicitly note that
atoms have no natural morphisms and do not themselves form a category, the
categorical implementation uses the **thin groupoid presented by this
equivalence relation**.  It does not invent morphisms between the underlying
atoms.

Applying \(\operatorname{Sym}\) and \(\pi_0\) gives
\[
\operatorname{CF}_G(Y)
\in\mathbf N^{(\operatorname{Atoms}^K_G)},
\tag{17.8}
\]
the KKPYY chemical formula.  Their spectral, blowup, and projective-bundle
Theorems 4.1, 4.5, and 4.11 discharge the split/comparison laws.  Their
dimension filtration
\[
\operatorname{Atoms}_{G,\dim\le0}^K
\subset\operatorname{Atoms}_{G,\dim\le1}^K
\subset\cdots
\tag{17.9}
\]
is the atom-level form of center localization, and Proposition 5.17 is the
corresponding non-rationality theorem.

Thus the positive chemical-formula and dimension-filtration portion of
KKPYY is an exact specialization of the generalized compiler.  The internal
construction of maximal analytic \(F\)-bundles, motivic \(G\)-actions,
pairings, integral structures, and enhanced Serre operators remains inside
the carrier provider.  The compiler organizes and forgets such data; it does
not derive it.

## 17.4 Subsumption theorem

Let a probe-indexed block theory satisfy:

1. pseudofunctorial base change and Beck--Chevalley;
2. coherent finite splitting under \(\operatorname{Sym}\);
3. a filter-exact comparison span for every geometric adapter enabled by the
   instance, meaning that it preserves and reflects eventual marker classes;
4. spectral separation or persistent summand labels; and
5. a comparison-natural atomizer and marker.

Then its variety assignment, atomized spectrum, marker folds, and
center-localized birational obstructions are obtained functorially from the
single pipeline
\[
\boxed{
\mathsf{Geometry}
\longrightarrow
\int_{p\in P(-)}\operatorname{Sym}(\mathsf{MarkedBlock}_p)
\longrightarrow
\operatorname{Sym}(\mathsf{Atom})
\xrightarrow{L_d}
\operatorname{Sym}(\mathsf{Atom})_{>d}
\longrightarrow\underline A.}
\tag{17.10}
\]

### Proof

Pseudofunctoriality and Beck--Chevalley make the first two arrows independent
of coefficient refinements and of how comparison spans are composed.
The 2-monad laws make all finite decompositions coherent.  Separation makes
the atomizer blockwise; naturality lets it descend through comparisons.
The universal property (7.21) gives the last factorization for every marker
that kills centers through dimension \(d\).  Fold fusion proves compatibility
with every subsequent coarsening. ∎

The principal instances are:

| instance | probes | local block | atomizer | final consumer | exact scope |
| --- | --- | --- | --- | --- | --- |
| direct QDM in this packet | one algebraic generic point | regular even QDM spectral block | regular isomorphism and generic base change | arbitrary lawful monoid marker | all of Modules 1--16 |
| Guéré \(\clubsuit/\heartsuit\) | nonvanishing evaluations, cofinite filter | evaluated generalized eigenspace with \((\rho,\nu,\nu',\gamma)\) | evaluation equivalence and separated comparison | eventual Boolean violation | Definitions 20, 25, 27; Proposition 38; Corollary 41 |
| BFGMP coarse criterion | separated maximal evaluations along a factorization | evaluated eigenspace marked by vanishing cohomology | transport of the mark | surface-carrier inequality | Theorem 4.1, given its Hodge/monodromy inputs |
| KKPYY | connected non-Archimedean analytic domains | component of the unramified reduced spectral cover with \(G\)-decoration | generated elementary atom equivalence | positive chemical formula or dimension cutoff | Theorems 4.1, 4.5, 4.11; Definition 5.16; Proposition 5.17 |

The verdict is therefore:
\[
\boxed{
\text{one generalized compiler has direct QDM, Guéré/BFGMP, and KKPYY
as sibling specializations of its transport-and-retention layer}.}
\tag{17.11}
\]
It would be inaccurate to say that the current unindexed marker package alone
subsumes the other two, or that the compiler reproduces their analytic,
motivic, or monodromy theorems.

## 17.5 Law-test matrix

| law | direct QDM witness | Guéré/BFGMP witness | KKPYY witness |
| --- | --- | --- | --- |
| identity/composite base change | Definition 2.1 and Module 3 | equivalence and extension of evaluation maps | analytic base change of maximal \(F\)-bundles |
| Beck--Chevalley for comparison | common spines, Modules 3 and 6 | Iritani comparison plus variable changes in Corollary 37 | canonical comparison on common analytic domains |
| finite-sum coherence | Lemma 5.1 and Proposition 5.2 | direct sums after unit-shift separation | disjoint unions of spectral-cover components |
| separation | independent generic unit coordinates | chosen unit translations; maximal pairwise-disjoint spectra | restriction to the unramified cover and connected domains |
| atomizer naturality | regular gauge/base change | preservation of \((\rho,\nu,\nu',\gamma)\) | elementary equivalences defining \(\operatorname{Atoms}^K_G\) |
| center localization | Theorem 9.2 | center satisfies the relevant eventual property | dimension filtration and Proposition 5.17 |
| coarsening/fusion | Proposition 2.5 | change of violation predicate | forgetful maps from enhanced to coarse atoms |

## 17.6 Primary-source check

The comparison above was checked against the following cached primary-source
texts, not against secondary descriptions.

1. J. Guéré, *On the irrationality of cubic fourfolds*,
   arXiv:2603.04518v1: Definitions 20, 25, 27; Corollary 37; Proposition 38;
   Corollary 41; Theorem 56.  Cached PDF SHA-256:
   `eb84753911c97a6b618975be5da4dc3b5bdec2b66edf11063d09d75e475abfdc`.
2. V. Benedetti, A. Fay, J. Guéré, L. Manivel, N. Perrin,
   *An atomic criterion for irrationality without quantum computations*,
   arXiv:2607.26718v1: Definition 2.1, Theorem 4.1, Remarks 4.2 and 4.5.
   Cached PDF SHA-256:
   `bb1ee656bd55008a5403e057d0856e65c81b100f2fa07d1c90e184766dd0f407`.
3. L. Katzarkov, M. Kontsevich, T. Pantev, T. Y. Yu,
   *Birational invariants from Hodge structures and quantum multiplication*,
   arXiv:2508.05105v2: Theorems 4.1, 4.5, 4.11; Definition 5.16;
   Proposition 5.17; Example 6.21.  Cached PDF SHA-256:
   `2c5c9f0a2f9eaf230605eaf844c3b7d08e0181e6dbc921153156a071d616ff64`.

The finite algebraic shadow of the laws in Modules 7, 17, and 19--21 is replayed by
`notes/cubic-threefolds-tasks/c925-categorical-law-check.py`; its checked
output is `notes/cubic-threefolds-tasks/c925-categorical-law-check.json`.
The typed effect/optic toy is
`notes/cubic-threefolds-tasks/c925-sparse-shadow-path-toy.hs`, with checked
output in the adjacent `-output.txt` file.  These replays test finite
coherence, collision, sparse reconstruction, and type-level path laws.  They
are not evidence for the analytic comparison theorems, which remain primary
inputs.

Exact replay:

```bash
nix shell nixpkgs#python3 --command \
  python3 notes/cubic-threefolds-tasks/c925-categorical-law-check.py \
  | diff -u notes/cubic-threefolds-tasks/c925-categorical-law-check.json -

nix shell nixpkgs#ghc --command \
  runghc notes/cubic-threefolds-tasks/c925-sparse-shadow-path-toy.hs \
  | diff -u \
      notes/cubic-threefolds-tasks/c925-sparse-shadow-path-toy-output.txt -
```

The SHA-256 hashes are
`cd4129e493e5b98393ed7e59e2fb56de149675fbc762c3d1279c888c5977ffcd`
for the script and
`a13e408408432ff5c36323998157d475ae9f9d9484158591c97eab201186631d`
for its checked output; and
`4d77f6d103b20bacd3ecdc7a30a2dc78039018c69c7c119ff301cd5612af8adb`
and
`9406cab21b4e8536ec42403e84accb39e67556f017df2d69c52821413d706360`
for the Haskell toy and its checked output respectively.

---


# Module 18. Final modular statement

The proof is an instance of the following schema.

## Theorem 18.1 — parameterized fourfold obstruction

Let \(\mathcal M\) be any lawful QDM marker package with values in a
commutative monoid \(A\).  Suppose:

1. \(I_{\mathcal M}(Z)=0\) for every smooth projective \(Z\) of dimension at
   most two;
2. the projective-bundle and blowup comparison adapters satisfy the
   coefficient, parity, regularity, and independent-unit contracts of Modules
   3--6; and
3. two smooth projective fourfolds \(Y_0,Y_1\) have
   \(I_{\mathcal M}(Y_0)\ne I_{\mathcal M}(Y_1)\).

Then \(Y_0\) and \(Y_1\) are not birational.

For the cubic marker, take
\[
Y_0=X\times\mathbf P^1,
\qquad
Y_1=\mathbf P^4.
\]
The values are \(2\) and \(0\) for the counting consumer, or `true` and
`false` for the Boolean consumer.  Either configuration proves the theorem.

---
