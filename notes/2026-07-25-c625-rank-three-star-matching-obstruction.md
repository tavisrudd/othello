# C625: polarity-stabilizer obstruction to the rank-three equality candidate

**Lane:** `relconic`

**Date:** 2026-07-25

**Status:** complete.  The sole non-hyperoval characteristic-two zero-defect
candidate \((q,k)=(4096,92)\) is impossible.  Conic polarity turns the 92 arc
points into distinct involutions stabilizing the same 91-point subset of the
conic.  Either tangent pair generates a four-group fixing exactly its contact
point, so the other 90 points would have to split into four-element orbits.
The contradiction \(90\not\equiv0\pmod4\) is the complete primary proof.
The characteristic-two subgroup classification and subfield-orbit sieve
remain as a stronger reusable backup for candidates that pass this congruence.

## Result

Let \(\mathcal C\) be a nonsingular conic in
\(\operatorname{PG}(2,4096)\), and let \(A\) be a 92-arc disjoint from
\(\mathcal C\).  There is no zero-defect \(\mathcal C\)-complete pair
\((A,\mathcal C)\).

Equivalently, the rank-three star--matching realization forced by zero defect
at this parameter cannot be compatible with the prescribed conic and its
forced secant-type split.  The theorem does not claim that the naked abstract
\(\operatorname{MATCH}(92,46,1)\) design has no rank-three realization after
the conic data are discarded.

Combined with the arithmetic classification already recorded in the cold-read
frontier, this closes the even characteristic-two equality spectrum:
for even \(k\ge 6\), zero relative defect can occur only at the hyperoval
scale \(k=q+2\).  At that scale the existing geometric criterion remains
exact: a hyperoval disjoint from the prescribed nonsingular conic gives a
zero-defect pair.

## Input forced at \((4096,92)\)

Put \(m=46\), let \(N\) be the nucleus of \(\mathcal C\), and set
\[
 E=\{y\in\mathcal C:r(y)=46\}.
\]
The completed equality and parity calculations give
\[
 |E|=91,\qquad r(N)=46,
\]
and the arc secants split relative to \(\mathcal C\) as
\[
 (T,B,X)=(46,2070,2070),
\]
where \(T,B,X\) count tangent, bisecant, and external secants.  In
particular the 46 tangent secants form a perfect matching on \(A\).  Each
arc point lies on the unique tangent through it, and the arc condition
allows at most two arc points on that line.

There is also a useful equivalent hyperfocused formulation.  For every edge
\(\{P,Q\}\subset A\), the 89 maximum centres on \(PQ\) resolve the secants of
\(A\setminus\{P,Q\}\) into 89 perfect matchings.  Thus every two-point
deletion is a hyperfocused 90-arc on the deleted secant.  This is a genuine
rank-three consequence, but by itself it does not supply the obstruction
below; the decisive extra datum is the common prescribed conic.

## The conic involution lemma

Work over a perfect field \(K\) of characteristic two and normalize
\[
 \mathcal C:\ XZ=Y^2,\qquad
 c(t)=(t^2,t,1),\qquad c(\infty)=(1,0,0),
\]
with nucleus \(N=(0,1,0)\).

For \(P=(a,b,c)\notin\mathcal C\cup\{N\}\), the pencil through \(P\)
induces the projective involution
\[
 \sigma_P(t)=\frac{bt+a}{ct+b},
 \qquad
 M_P=\begin{pmatrix}b&a\\c&b\end{pmatrix}.
\]
Indeed, for distinct finite \(t,u\),
\[
 \det(P,c(t),c(u))
 =(t+u)\bigl(a+b(t+u)+ctu\bigr),
\]
and \(M_P^2=(b^2+ac)I\).  Since \(P\notin\mathcal C\), the scalar
\(b^2+ac\) is nonzero, so \(\sigma_P\) is a nonidentity involution.
The assignment \(P\mapsto\sigma_P\) is injective because the projective
matrix recovers \((a,b,c)\).

For every \(P\in A\), the involution \(\sigma_P\) stabilizes \(E\).
To see this, take \(y\in E\).  The 46 arc secants through \(y\) form a
perfect matching, so \(Py\) contains a second arc point \(Q\).  If
\(y'\) is the other intersection of \(PQ\) with \(\mathcal C\), then
\(y'=\sigma_P(y)\).  The secant \(PQ\) gives \(r(y')\ge1\), while zero
defect on the hole gives \(r(y')\in\{0,46\}\).  Hence \(y'\in E\).

Thus
\[
 G=\operatorname{Stab}_{\operatorname{PGL}_2(K)}(E)
\]
contains the 92 distinct involutions \(\sigma_P\), \(P\in A\).

## Klein-four orbit obstruction

Every nonidentity involution of \(\operatorname{PGL}_2(K)\) in
characteristic two has one fixed point on \(\mathcal C\).  For
\(\sigma_P\), it is the contact point of the unique conic tangent through
\(P\).

Choose any one of the 46 tangent secants, with arc points \(P,Q\) and
contact point \(t\in\mathcal C\).  It supports the two distinct involutions
\(\sigma_P,\sigma_Q\in G\).
After moving \(t\) to infinity, all involutions fixing \(t\) are
translations \(x\mapsto x+\gamma\).  The two coming from the tangent pair
generate a four-group \(V_t\), whose third nonidentity element is another
involution fixing \(t\).

Every nonidentity element of \(V_t\) has \(t\) as its unique fixed point on
the conic.  Since \(t\in E\), the action of \(V_t\) on
\(E\setminus\{t\}\) is free.  Therefore
\[
 |E|\equiv1\pmod4.
\]
But \(|E|=91\equiv3\pmod4\), a contradiction.

Equivalently, each \(\sigma_P\) acts on \(E\) as one fixed point and 45
transpositions, hence as an odd permutation.  The product
\(\sigma_P\sigma_Q\) must be even, but it is a third involution with the same
one-fixed-point cycle type and would have to be odd.  The four-orbit argument
is the sign contradiction without choosing generators.

This is the step missed by the earlier binary-residue and quadratic/Arf
gates: one tangent pair does not merely give a parity word.  Once both local
involutions act on the same global conic set, their product locks the orbit
size modulo four.

### Reusable root-group sieve

The preceding argument gives a parameter-free first gate.  Let
\(K=\mathbf F_{2^n}\), let \(|A|=2m\ge6\), and let
\[
 E=\{y\in\mathcal C:r(y)=m\},
 \qquad G=\operatorname{Stab}_{\operatorname{PGL}_2(K)}(E),
\]
for any zero-defect pair.  If \(A\) has even one tangent secant to
\(\mathcal C\), then
\[
 |E|\equiv1\pmod4.
\]

If \(A\) has \(T\ge2\) tangent secants, their contacts are distinct and give
\(T\) distinct root groups with \(|G\cap U_t|\ge4\).  The
characteristic-two subgroup classification then
forces
\[
 G\ \text{to be conjugate to}
 \operatorname{PGL}_2(2^d)
 \quad\text{for some }d\mid n,
 \qquad 2^d+1\ge T.
\]
Moreover all \(T\) tangent contacts lie on the corresponding conjugate
\(\mathbf P^1(\mathbf F_{2^d})\), and \(E\) must be a union of its orbits
on \(\mathbf P^1(K)\).

Thus any future candidate with a tangent secant faces a congruence gate
before bracket or census work.  If it has at least two tangent secants and
passes that gate, it faces two further arithmetic gates:

1. a proper subfield must have at least \(T-1\) elements; and
2. the prescribed value of \(|E|\) must be a sum of subfield-group orbit
   lengths.

At \((q,m,T)=(4096,46,46)\), the congruence already closes the candidate.
If deliberately ignored, the subfield-size step leaves only
\(2^d=64\) or \(4096\), and the orbit-sum step gives the independent
contradiction below.

## Independent subfield-orbit backup

Apply the characteristic-two classification of finite \(2\)-irregular
subgroups of \(\operatorname{PGL}_2(K)\).

- A \(2\)-semi-elementary subgroup has a unique fixed point on the
  projective line, so it cannot support the displayed 46 root groups.
- A dihedral subgroup in characteristic two has Sylow 2-subgroups of order
  two, so it cannot contain even one of the displayed four-groups.
- The remaining possibility is a conjugate of
  \(\operatorname{PSL}_2(Q)=\operatorname{PGL}_2(Q)\) for a subfield
  \(\mathbf F_Q\subseteq K\).  The \(A_5\) case is the instance \(Q=4\).

For a subfield group, the fixed points of all its involutions lie on its
conjugate \(\mathbf P^1(\mathbf F_Q)\), which has \(Q+1\) points.  Hence
\[
 Q+1\ge46.
\]
With \(K=\mathbf F_{2^{12}}\), the subfield condition leaves only
\[
 Q=64\quad\text{or}\quad Q=4096.
\]

The full group at \(Q=4096\) is transitive on the 4097 conic points, so it
cannot stabilize a 91-point proper subset.  For \(Q=64\), the action on
\(\mathbf P^1(\mathbf F_{4096})\) has exactly two orbits:
\[
 \mathbf P^1(\mathbf F_{64})\quad\text{of size }65,
 \qquad
 \mathbf P^1(\mathbf F_{4096})\setminus
 \mathbf P^1(\mathbf F_{64})\quad\text{of size }4032.
\]
For completeness, an element outside the subline has degree two over
\(\mathbf F_{64}\); its stabilizer is the nonsplit torus of order 65, so
its orbit has size
\[
 \frac{|\operatorname{PGL}_2(64)|}{65}
 =64\cdot63=4032.
\]
Every invariant subset therefore has size \(0,65,4032\), or \(4097\),
never 91.  This independently contradicts \(|E|=91\), but is no longer
load-bearing.

## Literature boundary

The secondary root-group sieve uses Xander Faber, *Finite
\(p\)-Irregular Subgroups of \(\operatorname{PGL}(2,k)\)*,
arXiv:1112.1999 (2011), especially the definitions and Theorems A--B in
Section 2.  Read depth: partial, exact theorem statements and their
characteristic-two cases.  Cached key `arXiv:1112.1999`, SHA-256
`2c32c6ec0cef4f6a5d92fba5cf899e67d16c2413ccbb517df1c03be5ab3f1e00`.
The theorem gives both the list of \(2\)-irregular types and the subfield
condition used in the independent backup.  The primary Klein-four
congruence proof uses no external classification theorem.  The orbit
calculation and the conic-involution lemma are proved directly here.

The hyperfocused terminology is background already audited in C593 through
Giulietti--Montanucci, *On Hyperfocused Arcs in
\(\operatorname{PG}(2,q)\)*, arXiv:math/0601488.  No classification theorem
from that paper is used here.  No novelty or priority claim is made for the
polarity-stabilizer argument.

## Validation

The geometric proof has the following independently checkable gates:

1. the prior exact equality data
   \(|E|=91\) and \((T,B,X)=(46,2070,2070)\);
2. the displayed determinant factorization and matrix square;
3. injectivity of \(P\mapsto[M_P]\);
4. zero-defect closure of \(E\) under every \(\sigma_P\);
5. the four-group generated by the two involutions on one tangent pair; and
6. its free action on the other 90 points of \(E\).

Faber's finite-subgroup classification and the \(65+4032\) orbit
decomposition independently replay the contradiction but are not theorem
dependencies.

The finite group-action terminal is kernel-checked in
`RelativeConicArcs.KleinFourOrbitCongruence`:

- `card_mod_group_order_eq_one_of_unique_fixed_point_action` proves the
  stronger ambient statement: for any nontrivial finite group with the
  common-singleton fixed-point pattern, the set cardinality is one modulo
  the group order;
- `card_mod_four_eq_one_of_unique_fixed_point_action` proves the general
  order-four congruence as a specialization;
- `no_unique_fixed_point_four_group_action_on_card_ninety_one` specializes it
  to the 91-point contradiction.

The remaining geometric bridge is now kernel-checked as well.
`ConicSecantInvolution` constructs the standard-conic involution and proves
its chord-incidence formula.  `ZeroDefectConicInvariance` proves that the
91-point maximum-index parameter set is invariant.  Finally,
`TangentPairFourGroup.no_exceptional_candidate_standardConic` chooses a
tangent arc secant, proves that its two involutions and their product have the
same unique fixed point, restricts them to that set, and derives the
contradiction from permutation sign.  These declarations are imported and
axiom-audited by `RelativeConicArcs.Gates.Relconic`.

No finite census, heuristic search, or untracked computational artifact is
part of the theorem.

## `ej` + `tt` closeout

The cheap upgrade is the full even characteristic-two corollary: the
Ramanujan--Nagell arithmetic reduction from C593 had left only the
hyperoval scale and \((4096,92)\); the present theorem removes the latter.
This is stronger than merely classifying one matching design because it
closes the complete zero-defect equality branch relevant to the paper.

The explicit `ej` pass also extracted the reusable root-group sieve above.
It separates the global mechanism into a subfield-size gate and an orbit-sum
gate, so later work can test a candidate without repeating the special
\(4096\) calculation.

The `tt`+`ej2` pass then removed the classification from the primary proof.
Tao's question is not “which large subgroup can contain 46 root groups?” but
“what does one four-group do to the 91-point set?”  It fixes one point and
acts freely on the rest, forcing \(|E|\equiv1\pmod4\).  The same pass weakens
the reusable sieve's hypothesis: one tangent secant gives the congruence, and
two distinct tangent secants already force the subfield-group alternative.
The formal closeout exposes the still more invariant statement: for any
nontrivial finite acting group with the same common-singleton fixed-point
pattern, Burnside's lemma gives
\[
 |E|\equiv 1\pmod{|G|}.
\]
Thus the number four belongs to the geometric construction of the subgroup,
not to the orbit argument itself.

The proof genuinely uses the prescribed conic twice and indispensably: to
place the involutions in one \(\operatorname{PGL}_2\), and to make the same
set \(E\) invariant under them.  It therefore does not silently claim
nonrealizability of the naked star--matching design.

## Degrees of freedom audit

- **Number of tangent pairs:** locked down.  The primary contradiction needs
  one, not all 46.  The exact value 46 matters only for the independent
  subfield sieve.
- **Maximum nucleus index:** removed from the reusable first gate.  Any
  tangent secant in a zero-defect pair forces \(|E|\equiv1\pmod4\).
- **Coordinates and choice of tangent:** quotiented out.  Projective
  normalization identifies the common-fixed-point involutions with
  translations, and every tangent pair gives the same four-orbit argument.
- **Subfield choice:** irrelevant to the primary proof and locked to
  \(64\) or \(4096\) only in the independent backup.
- **Unexplained geometric freedom:** exactly one remains: without the
  prescribed conic there is no canonical common \(\mathbf P^1\), invariant
  set \(E\), or conic involution product.  Producing such a carrier from the
  naked star--matching design would be a different theorem, not a loose
  parameter in C625.

## Mystery ledger

- **The \((4096,92)\) equality candidate:** settled negatively by the
  one-tangent Klein-four congruence; the subfield-orbit calculation is an
  independent backup.
- **Even characteristic-two zero defect:** settled completely at the
  parameter level; only the hyperoval scale remains.
- **Why the local residues failed:** settled conceptually.  Two involutions
  on one tangent pair amplify to a four-orbit congruence only after both act
  on the same global conic set.
- **Generality of the mechanism:** settled at the reusable level by the
  congruence and root-group sieves.  One tangent forces
  \(|E|\equiv1\pmod4\); two force a subfield
  \(\operatorname{PGL}_2\) stabilizer and orbit-sum constraint.
- **Naked rank-three \(\operatorname{MATCH}(92,46,1)\) realizability:** open
  and explicitly outside the theorem's scope; it is not a residual mystery
  of the prescribed-conic equality branch.
- **Manuscript integration:** settled.  The characteristic-two discussion,
  verification appendix, and a compact exclusion corollary now incorporate
  the tangent-pair proof.
- **Formal boundary:** settled locally for the geometric exclusion.  Lean
  constructs the conic involutions, proves zero-defect invariance, and checks
  the terminal 91-point contradiction.  The preceding Ramanujan--Nagell
  classification remains an independently formalized theorem in Banwait's
  separately pinned Lean package rather than a dependency of this package.
- **Mystery close:** no genuine task-owned mathematical mystery remains.
  The candidate, proof mechanism, minimal hypothesis, and reusable boundary
  are all locked down.
