# C742 — Unmarked Golden reconstruction and global degeneracy complex

**Date:** 2026-07-31

**Lane:** `golden`

**Status:** complete with a sharp obstruction crown

## Executive verdict

The strongest unmarked reconstruction statement fails at its category
boundary.  There is no source-free six-cell skew target that simultaneously
has the evident product action and supports the signed Joubert lift.

Let (X) be the natural six-set, let \(\mathcal T\) be the outer six-set,
put (A=\mathbf Q^X/\mathbf Q\mathbf1), and define the genuinely unmarked
product target

\[
 \mathscr W_0=\mathbf Q[\mathcal T]\otimes
               \bigwedge^2(\mathbf Q^X)^*.
\]

For the ordinary product action,

\[
 \dim\operatorname{Hom}_{S_6}(A,\mathscr W_0)=1,
\]

but its unique map repeats the difference form
\(\alpha_{ij}(x)=x_i-x_j\) in every cell.  This alternating matrix has rank
at most two, so its order-six Pfaffian is zero.  Twisting the target by the
sign character, as required for a cubic top coordinate with signed outer
covariance, gives

\[
 \dim\operatorname{Hom}_{S_6}
 (A,\operatorname{sgn}\otimes\mathscr W_0)=0.
\]

The nonzero Golden lift appears only after the product action is replaced by
the coherent monomial switching cocycle.  That cocycle is equivalent, at the
projective level, to the coherent regular two-graph family to be recovered.
Thus the marked C739 rigidity theorem is correct, but deleting “marked” does
not strengthen it: either the source-free target has no Joubert lift, or the
target action already carries the missing source datum.

The global-complex crown fails independently.  A selected cross-golden block
does not descend from the pole-marked cover to (M_{0,6}).  Even on the
pole-marked cover, the first Fitting divisor of one block is the Majorana wall
\(Z_T=0\), and for all six blocks it is \(\prod_T Z_T=0\).  These are not the
degree-fifteen pair-collision divisor.  Hence the collision divisor,
Jacobian rank-drop scheme, simultaneous-Pfaffian base, and Segre polar base
cannot be successive Fitting strata of the proposed cross-block complex.
The viable global object is a diagram: the logarithmic boundary and GIT
contraction on \(\overline M_{0,6}\), the intrinsic Pfaffian bundle and its
Koszul base complex, the Joubert Jacobian complex, and the pole-marked
cross-block matrix factorization on \(\overline M_{0,7}\).

This is a sharp obstruction rather than a failed calculation.  The
representation and moduli/Fitting attacks reach the same missing datum from
independent directions.  The weakest viable reconstruction theorem is the
projective group-action theorem below; it recovers the family from the paired
natural and outer six-sets, while stating plainly that this exceptional action
already contains the projective two-graph information.

## 1. Phase 0 placement

C739 has been placed under C735's operator-first architecture.

- Marked lift rigidity now sharpens the synchronized Cartan-cell theorem.
- The pole-descent obstruction sits where the six-point quotient meets the
  cross-golden block and C715 inverse fibre.
- The classical matching carrier and order-six hypersurface criterion are
  compressed HMSV/Kempe context, not a novelty crown.
- The canonical \(S_6/F_{20}\cong X\times\mathcal T\) return closes the
  balanced-cut section.
- The strict collision filtration has one body schematic and one appendix
  statement.  Its nilpotent refinement is marked as one-CAS evidence.
- The order-eight comparison and detailed multiplicity tables remain outside
  the Paper IV main line.

The C735 architecture, proof/trust, attribution, and length ledgers and the
paper verification README were refreshed.  The isolated paper build is
warning-free at fifteen pages.

## 2. Category and torsors

The input category must distinguish three targets.

1. The **source-free product target** is \(\mathscr W_0\) above, with the
   natural action on axes and the exceptional permutation action on cells.
   It contains no switching matrices or conference coefficients.
2. The **switching local system** replaces the product transport between
   cells by monomial maps \(M_{g,T}\) satisfying the cocycle law, modulo
   diagonal gauge.  This is the target used in C728 and C739.
3. A **fully marked target** chooses literal frames for that local system,
   a common support orientation, and, when a rank-one cross-golden summand is
   selected, a golden embedding and determinant-line orientation.

The four ambiguities are:

| ambiguity | nature | removed by |
|---|---|---|
| support orientation | one common sign bit | choosing one triple-orbit half |
| switching frame | diagonal gauge torsor in every cell | choosing literal monomial frames |
| affine pole | one-dimensional geometric fibre | choosing the seventh point |
| golden conjugation | one quadratic bit | choosing one embedding of \(\mathbf Q(\sqrt5)\) |

They are independent.  Projectivization removes the support bit but not the
continuous pole needed by a fixed cross block.  Rational descent pairs the
golden summands but does not choose one.  A switching gauge changes literal
matrices while fixing their two-graphs and every even projective shadow.

## 3. The source-free target obstruction

### Theorem 3.1 (product-target dichotomy)

Over characteristic zero, let
\(\mathscr W_0=\mathbf Q[\mathcal T]\otimes\bigwedge^2(\mathbf Q^X)^*\)
with its product action.  Then

\[
 \dim\operatorname{Hom}_{S_6}(A,\mathscr W_0)=1,
 \qquad
 \dim\operatorname{Hom}_{S_6}
 (A,\operatorname{sgn}\otimes\mathscr W_0)=0.
\]

The nonzero map to \(\mathscr W_0\) has zero top Pfaffian in every cell.
Consequently neither source-free product target admits an outer-equivariant
synchronized Pfaffian system with nonzero signed Joubert top cubic.

#### Proof

For (g\in S_6), write (f_X(g)) and (f_{\mathcal T}(g)) for the fixed
points in the natural and outer actions.  The relevant characters are

\[
 \chi_A(g)=f_X(g)-1,
 \qquad
 \chi_{\wedge^2\mathbf Q^X}(g)
 =\frac{f_X(g)^2-f_X(g^2)}2,
\]

and their product with (f_{\mathcal T}(g)), with or without
\(\operatorname{sgn}(g)\).  Averaging over all 720 permutations gives the
two displayed multiplicities.

The ordinary Hom-space contains

\[
 x\longmapsto
 \bigl((x_i-x_j)_{i,j\in X}\bigr)_{T\in\mathcal T}.
\]

It therefore spans.  Each cell is
\(x\mathbf1^{\mathsf T}-\mathbf1x^{\mathsf T}\), of rank at most two,
so every \(6\times6\) Pfaffian vanishes.  The signed Hom-space is zero, so
there is no alternative signed lift.  \(\square\)

The full-permutation certificate and the independent conjugacy-class replay
both verify the multiplicities.  The rank-two argument is human and does not
depend on the computation.

### Corollary 3.2 (minimal target datum)

A nonzero synchronized Joubert lift requires a nonproduct monomial switching
local system.  Supplying such a local system together with its primitive
normalized lift is equivalent to supplying the coherent projective
conference family: the coefficients of the difference forms recover the
switching classes cell by cell, and covariance recovers their coherence.

Thus C739's marked uniqueness is the maximal noncircular multiplicity-one
statement.  The cubic alone does not select a six-cell skew local system;
the local system plus normalized lift reconstructs the source because it is
an equivalent presentation of it.

## 4. The weakest viable unmarked reconstruction

There is a canonical projective theorem, but its input is the exceptional
pairing of the two six-sets rather than the observable tensor.

### Theorem 4.1 (exceptional-action reconstruction)

Let one abstract (S_6) act naturally on (X) and through its outer action
on \(\mathcal T\).  For (T\in\mathcal T), let
\(H_T=\operatorname{Stab}_{S_6}(T)\cong S_5\), and let
\(A_T=[H_T,H_T]\cong A_5\).  The action of (A_T) on
\(\binom X3\) has two complementary orbits of size ten.  Their unordered
pair is a regular two-graph and determines an unoriented conference
switching line \(\ell_T\).  The six lines \((\ell_T)_T\) form a canonical
coherent outer family.

One common choice of orbit half orients the odd family.  Literal matrices
still require switching frames, and one cross-golden rank-one summand still
requires a golden embedding.  No weaker datum that forgets the exceptional
pairing of (X) with \(\mathcal T\) determines an input-relative coherent
family.

#### Proof

The nonstandard (A_5\) is two-transitive on (X) and has two complementary
ten-element triple orbits.  Incidence counting gives two triples from each
orbit in every four-subset, which is the two-graph parity condition.  The
standard switching construction then gives a symmetric sign matrix with
\(C^2=5I\), unique up to diagonal switching; exchanging the orbit halves
replaces (C) by (-C).  Conjugation by (S_6) transports
\(H_T,A_T\), the orbit pair, and hence \(\ell_T\) to the corresponding data
for (gT).  This proves coherence.  Forgetting the outer pairing leaves only
the abstract isomorphism class of the unique order-six conference matrix and
does not identify its axes or sister coordinate.  \(\square\)

This theorem also explains the circularity test: the full exceptional action
already reconstructs the projective family before the cubic or skew map is
evaluated.

## 5. Pole descent and the Fitting obstruction

### Theorem 5.1 (no cross-block master complex)

No complex functorially generated by one selected pole-marked cross-golden
block can have, as successive determinantal/Fitting supports, the
pair-collision divisor, the Joubert-Jacobian rank-drop scheme, and the
simultaneous-Pfaffian base scheme.

#### Proof

First, a selected block does not descend to (M_{0,6}).  Under
\(y_i=(ax_i+b)/(cx_i+d)\),

\[
 [D_y,C_T]=(ad-bc)\Lambda[D_x,C_T]\Lambda,
 \qquad \Lambda_{ii}=(cx_i+d)^{-1}.
\]

The Pfaffian absorbs this diagonal congruence in its determinant line.  A
fixed golden eigenspace does not: \([\Lambda,C_T]=0\) forces \(\Lambda\)
to be scalar, hence (c=0) for six distinct points.  The block therefore
lives on the pole-marked cover.

Second, on that cover the zeroth Fitting support of
\(\operatorname{coker}B_T\) is its determinant wall (Z_T=0).  This cubic
wall meets the stable distinct-point locus and is not the pair-collision
divisor.  Taking all six blocks replaces it by the degree-eighteen divisor
\(\prod_TZ_T=0\), again not the degree-fifteen Vandermonde divisor.  Thus
the proposed succession already fails at its first support; taking adjugates,
duals, or the associated matrix factorization does not change that support.
The Jacobian and simultaneous-zero schemes require respectively the
differential of the whole Joubert map and its six-coordinate Koszul data,
neither of which is a Fitting stratum of one cross block.  \(\square\)

The minimal replacement is the following diagram of related, unequal
objects:

\[
 \begin{array}{c}
 \text{log boundary of }\overline M_{0,6}
 \longrightarrow \text{Segre GIT contraction}\\
 \downarrow \hspace{45mm}\downarrow\\
 \text{Joubert Jacobian complex}
 \qquad \text{Pfaffian Koszul base complex}\\
 \uparrow\\
 \text{pole-marked cross-block factorization on }\overline M_{0,7}.
 \end{array}
\]

The boundary has (15\Delta_{2|4}+10\Delta_{3|3}).  Its contraction
explains why the twenty complementary triple-collision planes meet over ten
nodes, but it does not identify their scheme structures.  The exact Singular
calculation still shows a nilpotent Jacobian defect at those ten points.  No
local-algebra proof or second CAS was obtained here, so that refinement
remains appendix-level evidence and is not used in Theorem 5.1.

## 6. Return compatibility

The canonical return is induced by the same exceptional action, but not by a
new Gram iteration.  A Sylow (5)-subgroup (H<S_6) lies in exactly one
standard and one outer (S_5).  Hence

\[
 S_6/F_{20}\cong X\times\mathcal T.
\]

The outer projection sends each of the 36 extremal cuts to the same sister
(T) selected by Theorem 4.1.  Therefore the projective
\(6\to10\to36\to6\) cycle commutes after the exceptional pairing is fixed.
The return does not recover the common support orientation or a golden
summand, exactly as required by the torsor table.

## 7. Claim ladder

| claim | verdict |
|---|---|
| category | three categories separated; the source-free and switching-local-system targets are not conflated |
| generic reconstruction | obstructed from a genuinely source-free skew target; projective family recovered instead from the exceptional paired action |
| integral rigidity | marked theorem survives; no unmarked integral theorem exists before the switching local system is chosen |
| coherent-family recovery | proved projectively from the paired natural/outer actions |
| pole descent | Pfaffian descends to six-point quotient; selected cross block only to pole-marked cover |
| global degeneracy complex | proposed cross-block Fitting complex obstructed at its first divisor; replaced by a diagram of boundary, Jacobian, Koszul, and pole-marked complexes |
| nilpotent mechanism | exact support retained, but human/independent mechanism remains unclosed and is not promoted |
| return compatibility | proved projectively by the double-(S_5) incidence |

## 8. Red-team and `aa` gate

The required attacks had the following outcomes.

- **Remove the target/full action.**  The nonstandard-(S_5) Pfaffian model
  remains a competing presentation of the Segre cubic.  General Pfaffian
  existence results make cubic-only uniqueness untenable.
- **Use the genuinely unmarked product target.**  The signed Hom-space is
  zero; the only untwisted lift has zero Pfaffian.  This is the decisive
  counterexample-first obstruction.
- **Vary the four ambiguities.**  Common scale is fixed only after primitive
  normalization; support orientation, switching frame, pole, and golden
  embedding remain independent in exactly the stated ways.
- **Ask for two integral lifts with the same cubic.**  In the marked target,
  C739 multiplicity one excludes them.  In the source-free target no nonzero
  signed lift exists.  The comparison cannot repair the missing category.
- **Separate abstract type from labels.**  The abstract order-six conference
  isomorphism type does not recover axes or sisters.  The exceptional paired
  action does, before any tensor observation.
- **Test stack strata.**  At the ten (3+3) points the polar map is based and
  the Jacobian thickening is nonreduced, so no generic reconstruction claim is
  promoted there.
- **Reject finite norm and global MCM descent.**  The forgetful map has
  one-dimensional fibres; the diagonal-congruence formula blocks descent of
  a selected summand.
- **Change the nilpotent thickening.**  Reduced collision support alone cannot
  fix it.  The absent independent local calculation remains a real trust gap.

The five `aa` routes were compared at the first categorical stall.

1. **Representation/classification** produced Theorem 3.1 and the exact
   source-free obstruction.
2. **Moduli/Fitting** independently produced Theorem 5.1: descent fails and
   the first Fitting divisor is the wrong divisor.
3. **Local algebra** confirms that the unequal schemes cannot be collapsed,
   but did not independently close the nilpotent thickening.
4. **Groupoid/gerbe** identifies the switching local system as the minimal
   missing datum and separates it from pole and golden descent.
5. **Certificate first** independently replayed the character obstruction and
   ruled out a character-table transcription error.

Routes 1 and 2 dominate because they meet the same obstruction without
sharing inputs: the desired object exists only after adding source-equivalent
transport data.  Route 4 explains that datum geometrically.  Route 3 was not
used to inflate the negative theorem beyond its evidence.

## 9. Literature audit

This report makes no novelty or priority claim.  The focused audit checked
whether the source-free target dichotomy, an outer-equivariant classification
of the Segre Pfaffian presentation, or the proposed cross-block/Fitting
unification was already stated.  Two of the five individually named sources
were read at full text.

Searches on 2026-07-31 used the exact families `equivariant Pfaffian
representation Segre cubic S6 switching conference matrix`, `Segre cubic
Pfaffian representation classification outer S6`, `M0,6 Segre cubic Jacobian
rank drop nonreduced scheme Fitting`, and `conference matrix switching cocycle
outer automorphism S6 two graph`.  The web interface supplied no stable total
result counts.  The promotion rule retained primary sources whose displayed
metadata joined at least two of Segre cubic, equivariant Pfaffian, outer
(S_6), switching/two-graphs, or moduli/Fitting geometry.  No source located
states the product-target character dichotomy or the cross-block first-Fitting
obstruction.  This negative is used only to delimit attribution; it does not
license “new”, “first”, or “unique in the literature”.  MathSciNet and Google
Scholar were **not covered**, and no forward-citation closure was attempted.

Sources and read depth:

1. Howard--Millson--Snowden--Vakil, *The relations among invariants of
   points on the projective line*, arXiv:0906.2437v1 — **full text**, all six
   pages, reused from the C739 audit.  Cache key `arXiv:0906.2437`, SHA-256
   `dfbdb89c3061b5987f59602a55d5eb40c7c29eab18f9203c0e43c6f765d37508`.
   This supplies the classical matching carrier and six-point quotient.
2. Howard--Millson--Snowden--Vakil, *A description of the outer automorphism
   of S6, and the invariants of six points in projective space*,
   arXiv:0710.5916v1 — **full text**, especially Sections 1 and 2.1--2.4,
   reused from the C715/C739 audit.  Cache key `arXiv:0710.5916`, SHA-256
   `d2da258cd8513a9b782a8270baa82acc51bc8d552e18db104967c2a08bffebfc`.
   This supplies the classical exceptional paired action and Joubert quotient.
3. Tschinkel--Zhang, *Stable equivariant birationalities of cubic and degree
   14 Fano threefolds*, arXiv:2409.08392 — **partial**, Introduction and the
   (S_5) classification on extracted pages 20--21.  Cache SHA-256
   `f8a72383325e8e6e9ab3113f5b9a0e2b7ea3cc5edf5d8e2f35ae2fe07b8557ab`.
   It supplies the competing nonstandard-(S_5) Segre Pfaffian target, not a
   synchronized outer-six classification.
4. Comaschi, *Pfaffian representations of cubic threefolds*,
   arXiv:2005.06593v1 — **partial**, abstract and Introduction.  Cache
   SHA-256
   `a2f7e8cb0cabf68a35dff4bdb4b431d557bf58efe1b66304fd81dab5e3968984`.
   It proves existence of Pfaffian presentations for cubic threefolds and
   confirms that cubic-only reconstruction is the wrong category; it does
   not classify the Golden synchronized system.
5. Alexeev--Swinarski, *Nef divisors on \(\overline M_{0,n}\) from GIT*,
   arXiv:0812.0778v2 — **partial**, Introduction and Section 2 through the
   setup of Lemma 2.2, reused from C739.  Cache SHA-256
   `4cd66727a1d98c8361c40d977aa45bc14b17a224554f56eafe34a92c4b205f29`.
   It supplies the general GIT contraction framework, not the C739/C742
   nonreduced Jacobian or Fitting claims.

## 10. Reproducibility and trust

From the repository root, run

```text
python3 notes/2026-07-31-c742-unmarked-target-audit.py --check
python3 notes/2026-07-31-c742-unmarked-target-audit-replay.py
```

The primary generator constructs the six synthematic totals and enumerates
all 720 permutations.  The replay instead uses the hard-coded outer
conjugacy-class map and class sizes.  Both compute multiplicities (1,0).
The JSON certificate records the target definitions, multiplicities, and
rank-two/Pfaffian-zero conclusion.  The human rank argument and the source
reconstruction proof are independent of both programs.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-07-31-c742-unmarked-target-audit.py` | 4181 | `0bcedb394503a640e6c5cdfe4c067c22252bcc5317242e563515d894f32643bf` |
| `2026-07-31-c742-unmarked-target-audit.json` | 594 | `9853c3360d9d182736a3b9a9b4773fea8590170a8a6de7bc94721c58cadf7e32` |
| `2026-07-31-c742-unmarked-target-audit-replay.py` | 1862 | `1e9fa0f91a32f6fd9b01ac0f5b6d64375520667f5119b8e1c887b90a459722e1` |

The C739 Singular bundle remains the sole exact implementation of the
nilpotent Jacobian refinement.  C742 neither changes that artifact nor uses
the refinement to prove its obstruction crown.

## 11. Placement verdict

Paper IV should receive one short boundary theorem after recovery and minimal
marking.  It should state the product-target dichotomy, the fact that the
exceptional paired action already reconstructs the projective family, and the
cross-block first-Fitting obstruction.  It should not advertise an unmarked
uniqueness theorem, a global matrix factorization on (M_{0,6}), or an
independently proved nilpotent mechanism.  The exact character table belongs
in the verification supplement, not the proof line.

## 12. `ej` + `tt` closeout and Mystery ledger

- **Settled by `ej`:** the obvious source-free target is not merely
  nonunique; its signed Hom-space is zero.  The untwisted near miss is unique
  but rank two, so its cubic Pfaffian vanishes.
- **Settled by `tt`:** the full exceptional action on (X\) and
  \(\mathcal T\) already recovers the projective family by stabilizer-orbit
  incidence.  Calling reconstruction from that action “observable-tensor
  reconstruction” would hide the causal input.
- **Settled independently by `aa`:** the representation obstruction and the
  first-Fitting/descent obstruction identify the same missing switching and
  pole data from different input shapes.
- **Settled:** the projective (6\to10\to36\to6\) cycle commutes through the
  exceptional action and introduces no extra torsor.
- **Open evidence gap:** the ten-point nilpotent Jacobian defect still lacks a
  human local normal form or second-CAS replay.  It remains appendix evidence;
  no successor is allocated solely for it.
- **No remaining reconstruction mystery:** after separating the three target
  categories, every apparent ambiguity is one of the four explicit torsors or
  the deliberate loss of labels/exceptional pairing.

**Vibe check:** strong negative in the useful sense.  The hoped-for unmarked
crown was not merely hard; its natural category cannot carry the claimed
object.  The obstruction leaves a clean marked theorem, a genuinely unmarked
projective replacement, and a sharper global boundary for the paper without
forcing unequal schemes together.
