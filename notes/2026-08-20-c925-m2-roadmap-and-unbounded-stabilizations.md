# C925 -- updated \(m=2\) roadmap and unbounded stabilization strategy

**Lane:** `cubic-threefolds`

**Status:** birational and representation recodings proved; three geometric
inputs remain open, though they need only be supplied on one cofinal family

## Purpose

This note records two related conclusions.

1. It reconciles the original direct-QDM agent's assessment of \(m=2\) and
   all \(m\) with the later hostile audits of marked rows, deck actions,
   Stokes transport, and arbitrary blowups.
2. It proves that irrationality on any unbounded set of stabilization indices
   is already an all-\(m\) result, then recodes the source through
   \((\mathbf P^1)^m\) and isolates a uniform Jordan-length carrier theorem.

The formal statements are promoted as Module 24 of
`notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md`.

No manuscript or Lean source was edited.

## External benchmark

Engel--de Gaay Fortman--Schreieder prove that a very general cubic threefold
has no decomposition of the diagonal and hence is neither stably nor retract
rational:

- `https://arxiv.org/abs/2507.15704`, Theorem 1.3 and Corollary 1.4;
- Schreieder's current hypersurface survey,
  `https://www.iag.uni-hannover.de/fileadmin/iag/homepages/schreieder/publications/ICM-survey.pdf`,
  Theorem 1.3.

Their theorem is explicitly very-general.  The primary paper also notes that
smooth cubic threefolds admitting a decomposition of the diagonal form a
nonempty countable union of subvarieties in moduli.  The all-smooth stable
irrationality problem is therefore not supplied by this benchmark.  The QDM
program remains distinctive precisely because its target is every smooth
cubic threefold.

## Updated status of the original assessment

| goal | original assessment | status after the modular and hostile audits |
|---|---|---|
| \(m=0\) | classical | unchanged |
| \(m=1\) | essentially proof engineering | mathematically closed by the unconditional atomic route and independently audited direct-QDM route |
| \(m=2\) | correlated source understood; transport missing | correct, but the missing theorem is row/extension transport, not merely exclusion of a raw \(\mu_3\)-orbit |
| fixed \(m\ge3\) | increasingly complicated centers | correct for one-off center classification; avoid this route |
| all \(m\) | one relational transport principle away | still the right strategic description; the principle now has two exact candidate forms |

The numerical percentages in the original memo are best interpreted as
problem localization, not proof mass.  The \(m=2\) problem is sharply stated
but not proof-close.

## What survives at \(m=2\)

The source is genuinely correlated:

\[
\mathscr A_X\boxtimes QDM(\mathbf P^2),
\]

with branches

\[
\lambda_X+3q^{1/3},\qquad
\lambda_X+3\omega q^{1/3},\qquad
\lambda_X+3\omega^2q^{1/3}.
\]

They are not three unrelated copies of \(\mathscr A_X\).  Moreover, only
threefold centers are newly dimensional in weak factorization of the
fivefold \(X\times\mathbf P^2\).  For the old additive cubic packet, points,
curves, and surfaces form the lower-dimensional layer treated by the \(m=1\)
program.  Those results do not automatically discharge the stronger
occurrence-indexed row or operation-framed clauses below.

This remains the correct conceptual compression:

\[
\boxed{\text{Can arbitrary threefold-center transport erase the correlated source?}}
\]

## What failed or remains unproved

### The irregular triangle

The three uncentered irregular values are not presently canonical under the
Iritani comparison.  Independent scalar/unit shifts and reconstruction
coordinates can move them.  Centering removes precisely the absolute
placement one hoped to use.

### The bare deck orbit

After adjoining \(q^{1/3}\), the three branches form a coefficient-field
orbit.  But a bare orbit is not automatically a transported invariant:
comparison base change must preserve the descent action and its marking.
No general theorem currently supplies that equivariance.

### A simple formal-monodromy character

Each primitive-sixth character occurs in three projective copies at \(m=2\).
The corresponding eigenspace is not multiplicity one, so the
simple-character row-forcing theorem does not apply.  Hodge data, raw grading,
pairing, integrality, and formal monodromy likewise do not select the point
row.

### An isolated scalar marker

The constituent-additive no-go theorem explains why another scalar attached
to one cubic block will not solve the problem.  The necessary information is
relational, marked, or extension-valued.

## The marking must be a quotient row

The appropriate augmented object is

\[
(V,T,r),\qquad r:V\to K,
\]

where \(V\) is the retained primitive-sixth sector, \(T\) is its
formal/operation structure, and \(r\) is the fixed-phase Gamma point/rank
functional.  When both endpoint rows \(r_\pm\) are nonzero (hence surjective
over the coefficient field), a comparison
\(\Phi:V_-\xrightarrow{\sim}V_+\) is lawful for the row exactly when

\[
r_+\Phi=c_\Phi r_-,\qquad c_\Phi\in K^\times.
\]

Equivalently in this nonzero-row case, its leakage covector vanishes:

\[
\delta_\Phi=r_+\Phi|_{\ker r_-}=0.
\]

This is stronger than transporting a chosen vector.  A row gives a canonical
one-dimensional quotient and a genuine two-sided output-kernel ideal.  A
chosen vector instead carries variance and holonomy choices and does not make
its naive annihilator into a two-sided ideal.
The zero-row case must be retained separately by the isomorphism-class
Boolean marker; leakage-zero alone does not imply nonzero scalar row
proportionality there.

## Why the proposed local triple lemma is insufficient

The original memo proposed proving that a threefold center cannot contain a
transitive marked \(\mu_3\)-triple of the source type.  That would be useful,
but it is not yet a complete telescope:

1. several centers at different steps could contribute separate pieces;
2. Stokes comparisons can mix ambient and exceptional directions;
3. a cubic threefold center already carries the relevant primitive-sixth
   packet and a nonzero Gamma point component; and
4. absence of a literal direct summand is not stable under extensions.

One therefore needs a global quotient law or a strict operation-framed
Krull--Schmidt law.  Local nonoccurrence of the semisimple triple alone does
not prevent later assembly.

## Exact route A: fixed-phase Gamma/rank transport

The desired blowup theorem is:

> For every actual blowup step in one chosen weak factorization of a
> hypothetical fivefold birational map, the fixed-phase Gamma/Stokes/Orlov
> comparison preserves the rank row up to nonzero scalar, every exceptional
> direction is row-null, and the law is natural under products, composition,
> inverse, and the induced occurrence specializations.

In symbols,

\[
r_{\operatorname{Bl}}\Phi
=c\,(r_Y\oplus0_{\mathrm{exc}}),
\qquad c\in K^\times.
\]

Generic-point localization shows that rank is the universal additive
functional killing proper support.  Therefore the same theorem for arbitrary
blowups would prove every stabilization, not only \(m=2\).

The codimension-two threefold step is only the newly difficult carrier case.
Point, curve, and surface steps remain obligations unless separate adapters
in the same indexed pointed provider make their exceptional sectors row-null
and exclude mixing into the ambient row.  The earlier unpointed \(m=1\)
exclusions do not imply this.

This route's remaining geometric regression is arbitrary nonsplit normal
bundles.  The following cases are already positive in the C907 dossier:

- the first nonvacuous center \(\operatorname{Bl}_X\mathbf P^5\);
- centers cut by two nef line bundles, through reciprocal-Gamma cancellation;
- toric calibrations and ordinary flops.

Birational normal splitting reduces the remaining case to point-row purity
for the inserted blowups and preservation through deformation-to-the-normal-
cone gluing.  Empty packet multiplicity alone does not control Stokes mixing.

## Exact route B: operation-framed Jordan length

The alternative retains the nilpotent extension in
\(\operatorname{Rep}(\mu_6\times\mathbf G_a)\).  The \(m=2\) source is a
genuine \(J_3\) phenomenon rather than merely three semisimple branches.

The new top-dimensional carrier clause is

\[
\ell_\theta(Z;\sigma)\le2
\]

for every actual operation-framed occurrence of a smooth threefold center.
The same provider also needs the indexed surface bound \(\ell_\theta\le1\),
empty point/curve sectors, and globally coherent strict transport in every
codimension.  Formal grading and duality do not prove the threefold clause:
the stationary Picard--Lefschetz length-three model with \(N^2\ne0\) is an
exact formal countermodel.  The missing input is geometric.

This route is narrower than the rank route but has a uniform extrapolation.

## Unbounded stabilization indices suffice

Rationality is upward closed in the stabilization index.  If
\(X\times\mathbf P^a\) is rational and \(b\ge a\), then

\[
X\times\mathbf P^b
\dashsim
(X\times\mathbf P^a)\times\mathbf P^{b-a}
\]

is rational.  Hence irrationality on any unbounded subset
\(S\subseteq\mathbf N\) implies irrationality for every \(m\): a hypothetical
rational index would force every larger index, including some element of
\(S\), to be rational.

Thus any of the following is a complete stable-irrationality endgame:

- all \(m\ge k\);
- all multiples of one \(k\);
- one unbounded arithmetic progression; or
- any other unbounded sequence.

This is Theorem 24.1 and Corollary 24.1A in the packet.

## Fixed-factor recoding

For \(m=kr\),

\[
X\times\mathbf P^{kr}
\dashsim
X\times(\mathbf P^k)^r.
\]

The source becomes a tensor power of one operation object:

\[
QDM(X)\boxtimes QDM(\mathbf P^k)^{\boxtimes r}.
\]

For coverage and generator arity, the best choice is \(k=1\), because

\[
X\times\mathbf P^m
\dashsim
X\times(\mathbf P^1)^m
\]

for every \(m\).  It replaces the growing \((m+1)\)-gon of
\(QDM(\mathbf P^m)\) by repeated application of one binary operation.
A larger fixed \(k\) could nevertheless be strategically better if its
operation-framed geometric provider were easier.

No QDM birational invariance is assumed here.  The varieties are birational
because the projective factors are rational of the same dimension, and
rationality itself is birationally invariant.

## The unique highest string

For nilpotent indecomposables in characteristic zero,

\[
J_a\otimes J_b
\cong
\bigoplus_{i=1}^{\min(a,b)}J_{a+b-2i+1}.
\]

Induction gives

\[
J_{k+1}^{\otimes r}
=J_{kr+1}\oplus\{\text{strictly shorter strings}\},
\]

with the top \(J_{kr+1}\) occurring once.  In particular,

\[
J_2^{\otimes m}
=J_{m+1}\oplus\{\text{strings shorter than }m+1\}.
\]

For the cubic packet, a primitive-sixth \(J_1\) tensored with the diagonal
\(\mathcal O(1,\ldots,1)\) operation on \((\mathbf P^1)^m\) therefore gives
a unique top \(J_{m+1}\) for each primitive character, provided the
operation-framed QDM lift is monoidal for these products.  The packet records
this source realization separately as Input 24.S; Proposition 24.3 proves
the representation-theoretic consequence, not the QDM lift itself.

More generally, for a nonempty finite family \(a_j\ge1\),

\[
\bigotimes_j J_{a_j}
\cong J_{1+\sum_j(a_j-1)}\oplus W,
\qquad \ell(W)<1+\sum_j(a_j-1),
\]

with one top string.  This covers a finite menu of projective factors and
offset-plus-repeated-factor presentations whenever the corresponding product
providers exist.

There is also a useful weakening of the uniform goal.  Fix one \(k\ge1\).
If the monoidal source, indexed carrier, and coherent transport inputs can be
proved only for

\[
X\times(\mathbf P^k)^r,\qquad r\ge1,
\]

they yield irrationality at the cofinal indices \(m=kr\), hence at every
index by upward closure.  Uniformity over all ambient dimensions is therefore
not logically necessary; uniformity over one cofinal fixed-factor family is.

## Uniform carrier theorem and the codimension correction

Let \(\theta\in\{\zeta_6,\zeta_6^{-1}\}\) be the formal character and let
\(\sigma\) record the actual comparison-generated Novikov specialization,
reconstruction value, normalization, and path provenance of a center
occurrence.  The ideal center bound is

\[
\ell_\theta(Z;\sigma)\le\max(0,\dim Z-1)
\]

for every actual occurrence.  Intrinsic length cannot replace this indexed
statement.

One must include the exceptional projective string.  In an
\((m+3)\)-fold, a center of dimension \(d\) and codimension

\[
c=m+3-d
\]

contributes, for a nontrivial blowup with \(c\ge2\), the operation-framed package

\[
V_{Z;\sigma}\otimes J_{c-1}.
\]

The Clebsch--Gordan law and the carrier bound give maximum length

\[
(d-1)+(c-1)-1=d+c-3=m.
\]

The binary cubic source has length \(m+1\).  Thus every exceptional term is
at least one Jordan step too short.  The minimal consumer is merely the
isomorphism-class Boolean high-length marker on the strict-biproduct core,
with target \((\mathbb B,\vee,0)\),

\[
h_m(V)=\mathbf 1\{\ell_\theta(V)>m\}.
\]

Globally coherent strict biproduct transport makes \(h_m\) invariant and
prevents multiple shorter strings from assembling into the source string;
top-block uniqueness and marking are not load-bearing for this route.

This proves the conditional criterion:

> If the monoidal binary source identification, occurrence-indexed uniform
> carrier bound, and one globally coherent strict operation-framed blowup
> transport hold at every step of a chosen factorization for every
> hypothetical birational map, then \(X\times\mathbf P^m\) is irrational for
> every \(m\ge0\) and every smooth cubic threefold \(X\).

The transport must preserve one common character and diagonal nilpotent
through both orientations and every induced specialization.  Unrelated
objectwise decompositions are insufficient.  The proof first gives every
\(m\ge1\); upward closure then forces \(m=0\) as well.

At \(m=2\), the newly dimensional clause is the threefold bound
\(\ell_\theta(Z;\sigma)\le2\) against the source \(J_3\).  The same enriched
provider still needs the indexed surface bound \(\ell_\theta\le1\) and empty
point/curve sectors: a codimension-three surface contribution includes
\(J_2\), so a surface \(J_2\) would already manufacture \(J_3\).  The earlier
low-dimensional results do not automatically transfer to this operation-
framed theory.  Once those clauses are discharged, \(m=2\) is the first new
top-dimensional case of the uniform theorem.

## Strategic conclusion

An arithmetic progression is a logically complete target but does not, by
itself, make the arbitrary-center provider easier.  Its real value is the
fixed-factor presentation: \((\mathbf P^1)^m\) exposes one tensor recursion
which a uniform provider must respect.

The two highest-value routes are therefore:

1. **rank route:** prove fixed-phase Gamma/rank-row purity under arbitrary
   nonsplit normal-bundle blowups; success gives all \(m\) directly;
2. **Jordan route:** prove the indexed threefold case of the uniform carrier
   bound, the same-provider lower-center clauses, and coherent transport in
   every codimension, then test whether the carrier proof scales to
   \(\ell_\theta(Z;\sigma)\le\dim Z-1\).

The raw \(\mathbf P^2\) triangle, isolated scalar markers, and unmarked deck
orbits should not receive further priority.

## Validation plan

The finite categorical law model checks:

1. a hypothetical rational stabilization generates an upward-closed tail and
   therefore intersects every unbounded arithmetic progression; and
2. tensor powers \(J_{k+1}^{\otimes r}\) have a unique top
   \(J_{kr+1}\) across a bounded family of \((k,r)\), using the exact
   Clebsch--Gordan recursion, and nonempty heterogeneous products of up to
   five factors \(J_{a_j}\), \(1\le a_j\le6\), have the predicted unique top;
   and
3. the center bound and codimension-dependent exceptional string leave the
   contribution exactly one Jordan step below the source in a bounded family
   of dimensions.

These checks validate the finite algebra and index logic only.  They verify
none of the monoidal source realization, indexed geometric carrier bound, or
strict analytic transport inputs.

## EJ / TT closeout

### Cheap consequences

- An all-multiples theorem is already an all-\(m\) theorem by upward closure
  of rationality.
- Accordingly, the QDM source and transport packages need only be constructed
  on one cofinal fixed-factor family, not in every ambient dimension.
- \(k=1\) dominates under the coverage-and-generator-arity criterion: it uses
  one binary generator and covers every index without passing to a
  subsequence.  A larger \(k\) could win if its geometric provider is easier.
- The exceptional \(J_{c-1}\) factor does not close the source-center gap;
  the dimension identity leaves the center contribution exactly one step
  short.
- The recursive enemy \(X\times\mathbf P^{m-2}\) has a shorter operation
  string and is compatible with the proposed carrier bound; it does not by
  itself refute the uniform theorem.

### Highest-value next calculation

For the rank route, compute the leakage through the normal-splitting and
deformation-to-normal-cone square for an arbitrary rank-two normal bundle.
For the Jordan route, isolate the geometric input that rules out the exact
stationary Picard--Lefschetz length-three model with \(N^2\ne0\) on a smooth
threefold, then prove the lower-center clauses in the same operation frame.

## Mystery ledger

| mystery | status | exact gate |
|---|---|---|
| Does an unbounded subsequence suffice? | **settled: yes** | upward closure of rationality, Theorem 24.1 |
| Must the provider be uniform in every ambient dimension? | **settled: no** | one cofinal fixed-factor family suffices, Corollary 24.4A |
| Which fixed factor is best? | **settled only for coverage/arity: \(\mathbf P^1\)** | every \(\mathbf P^m\) is birational to \((\mathbf P^1)^m\); geometric provider difficulty may favor another \(k\) |
| Does the binary source have growing complexity? | **settled algebraically** | unique top \(J_{m+1}\) in \(J_2^{\otimes m}\) |
| Does the operation-framed QDM realize a fixed-factor tensor on a cofinal family? | **open interface beyond the established product cases** | Input 24.S or its fixed-\(k\) version: monoidal diagonal-operation lift |
| Do higher-codimension exceptional strings erase the gap? | **settled algebraically: no** | \((d-1)+(c-1)-1=m<m+1\) |
| Is the raw irregular triangle canonical? | **settled: not from current comparison laws** | independent shifts and coordinate changes |
| Does a bare deck orbit force the marking? | **settled: no** | multiplicity-three primitive characters and missing descent equivariance |
| Does the rank-row theorem hold for arbitrary normal bundles? | **open** | fixed-phase Gamma/Stokes/Orlov leakage under normal splitting and deformation gluing |
| Does \(\ell_\theta(Z;\sigma)\le\dim Z-1\) hold geometrically? | **open** | first newly dimensional case is the indexed smooth-threefold bound \(\ell_\theta\le2\), after the enriched lower-dimensional clauses |
| Is strict operation-framed blowup transport available? | **open** | arbitrary-center Rees/Stokes extension and composition coherence |

## Boundary

Theorem 24.1, fixed-factor birational recoding, and the unique-top-string
proposition are proved.  The all-\(m\) Jordan criterion is conditional on its
monoidal source input and two named provider hypotheses.  The rank-row route
remains conditional on its distinct arbitrary-blowup transport theorem.  No
new unconditional \(m=2\) or stable-irrationality theorem is claimed.
