# Module 41. The unit neutral overlap and its canonical-character completion

**Packet part:** Module 41.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** the quasi-symmetry obstruction, the five-signature genuine-unit
\((1,1)\) completion classification, and its four-signature
total-unimodular pruning are proved; realization of an actual AKMW overlap by
a classified matrix and descent from the completion to the fixed-phase QDM
packet remain open

## 41.1 Discrepancy itself excludes raw quasi-symmetry

Let a torus \(T\) act on a vector space with weights

\[
                    \beta_1,\ldots,\beta_N\in X^*(T).            \tag{41.1}
\]

Set

\[
                    \kappa(W):=\sum_{j=1}^N\beta_j.              \tag{41.2}
\]

Recall that \(W\) is quasi-symmetric when, on every real line
\(\ell\subset X^*(T)_{\mathbf R}\), the sum of the weights lying on \(\ell\)
is zero.

### Proposition 41.1 -- discrepancy obstruction

If \(W\) is quasi-symmetric, then \(\kappa(W)=0\).  Consequently, if a wall
cocharacter \(\lambda\in X_*(T)\) has

\[
                     \langle\lambda,\kappa(W)\rangle\ne0,        \tag{41.3}
\]

the representation is not quasi-symmetric.

#### Proof

Discard the zero weights, which contribute zero, and partition the remaining
weights by their unique real weight lines.  Quasi-symmetry makes the sum on
each line zero, hence their total sum is zero.  Pairing with \(\lambda\) gives
the contrapositive.  \(\square\)

For a toric wall, the left side of (41.3) is the sum of its normal weights,
equivalently the oriented canonical/discrepancy degree.  Thus any genuinely
discrepant wall is outside the quasi-symmetric hypothesis.  This holds even
when two opposite walls admit a neutral effective combination:

\[
 \langle\lambda_1,\kappa\rangle=-a,\qquad
 \langle\lambda_2,\kappa\rangle=b,\qquad
 \langle b\lambda_1+a\lambda_2,\kappa\rangle=0                  \tag{41.4}
\]

does not imply \(\kappa=0\).

This closes one proposed use of Module 40.  The nonresonant
Spenko--Van den Bergh theorem cannot be applied directly to the **raw**
two-wall representation at any consecutive-discrepant overlap.

## 41.2 Canonical-character completion

There is a canonical algebraic repair of the necessary total-weight
condition: adjoin one coordinate of weight \(-\kappa(W)\).  Write

\[
              W^{\mathrm{can}}:=W\oplus\mathbf C_{-\kappa(W)}.   \tag{41.5}
\]

Then \(\kappa(W^{\mathrm{can}})=0\).  Total weight zero is necessary but, for
\(\operatorname{rank}T\ge2\), it is not sufficient for quasi-symmetry.

### Proposition 41.2 -- exact one-coordinate criterion

Assume \(\kappa(W)\ne0\).

Let \(L_\kappa\) be the line spanned by \(\kappa(W)\), and let
\(s_\ell\) denote the sum of the original weights of \(W\) lying on a line
\(\ell\).  Then \(W^{\mathrm{can}}\) is quasi-symmetric if and only if

\[
                     s_\ell=0
       \qquad\text{for every }\ell\ne L_\kappa.                  \tag{41.6}
\]

#### Proof

The added weight lies on \(L_\kappa\), so it cannot repair any other line.
Thus (41.6) is necessary.  If (41.6) holds, then

\[
                 s_{L_\kappa}=\sum_\ell s_\ell=\kappa(W),
\]

and the added weight \(-\kappa(W)\) also balances \(L_\kappa\).
\(\square\)

For a one-dimensional wall representation this condition is automatic.
For a genuine two-ray face it is a restrictive incidence theorem.

## 41.3 The primitive \((1,1)\) unit matrices

In dimension five, a discrepancy-one wall is either a codimension-two
blowup/down or a curve \((1,2)\) standard flip.  Thus the primitive unit
slope has four ordered wall-type pairs.  Encode the negative wall type by
\(A\in\{1,2\}\) and the positive wall type by \(B\in\{1,2\}\), where \(1\)
means blowup and \(2\) means curve flip.

A common rank-two affine toric pilot has seven coordinate weights

\[
                 w_j=(a_j,b_j)\in\{-1,0,1\}^2,\qquad 1\le j\le7,             \tag{41.7}
\]

with row multisets

\[
\begin{aligned}
 (a_1,\ldots,a_7)&\sim
   (1^{\times A},-1^{\times(A+1)},0^{\times(6-2A)}),\\
 (b_1,\ldots,b_7)&\sim
   (1^{\times(B+1)},-1^{\times B},0^{\times(6-2B)}).           \tag{41.8}
\end{aligned}
\]

The opposite row sums are

\[
                      \kappa(W)=(-1,1).                         \tag{41.9}
\]

The following extra conditions are a strong local pilot, not yet a theorem
about every AKMW overlap:

1. the weights span the character lattice:
   \[
                      \langle w_1,\ldots,w_7\rangle_{\mathbf Z}
                            =\mathbf Z^2;                       \tag{41.10a}
   \]
   and
2. the matrix is totally unimodular in rank two:
   \[
                 |\det(w_i,w_j)|\le1\quad\text{for all }i,j.     \tag{41.10}
   \]

Individual pi-nonsingular circuits have unit coefficients, but that fact
alone does not prove (41.10) for one common two-ray matrix.

### Theorem 41.3 -- classification of quasi-symmetric unit completions

Assume (41.7)--(41.10), including the lattice-spanning condition (41.10a).
Then \(W^{\mathrm{can}}\), obtained by adjoining
the weight

\[
                         -\kappa(W)=(1,-1),                     \tag{41.11}
\]

is quasi-symmetric if and only if, up to permutation, there is an integer
\(u\) satisfying

\[
 \max(0,A+B-3)\le u\le\min(A,B),
 \qquad (A,B,u)\ne(A,A,A),                                     \tag{41.12}
\]

and the nonzero incidence counts are

\[
\boxed{
\begin{aligned}
 n_{1,0}=n_{-1,0}&=A-u,\\
 n_{0,1}=n_{0,-1}&=B-u,\\
 n_{1,-1}&=u,\\
 n_{-1,1}&=u+1,\\
 n_{0,0}&=2(3-A-B+u),
\end{aligned}}
                                                                    \tag{41.13}
\]

with every other \(n_{p,q}\) zero.  The four wall-type pairs have the
following complete list:

| negative wall | positive wall | \((A,B)\) | admissible \(u\) | signatures |
|---|---|---:|---:|---:|
| blowup | blowdown | \((1,1)\) | \(0\) | 1 |
| blowup | reverse curve flip | \((1,2)\) | \(0,1\) | 2 |
| curve flip | blowdown | \((2,1)\) | \(0,1\) | 2 |
| curve flip | reverse curve flip | \((2,2)\) | \(1\) | 1 |

In the flip--flip case, (41.13) is the seven-weight multiset

\[
 (1,0),\ (-1,0),\ (0,1),\ (0,-1),\
 (1,-1),\ (-1,1),\ (-1,1),                                    \tag{41.13a}
\]

and adjoining (41.11) produces two balanced copies of each anti-diagonal
weight together with the two balanced axis pairs.

#### Proof

Let line balance after adjoining \((1,-1)\) be written as

\[
\begin{aligned}
 x&=n_{1,0}=n_{-1,0},&
 y&=n_{0,1}=n_{0,-1},\\
 d&=n_{1,1}=n_{-1,-1},&
 u&=n_{1,-1},&
 n_{-1,1}&=u+1,\\
 z&=n_{0,0}.
\end{aligned}                                                   \tag{41.14}
\]

These are exactly the line-balance equations after adding one
\((1,-1)\): the axes and slope-\(+1\) line already balance, while the raw
slope-\(-1\) line must have one extra \((-1,1)\).

The row counts (41.8) give

\[
\begin{aligned}
 x+d+u&=A,& y+d+u&=B,\\
 2y+z&=6-2A,&2x+z&=6-2B.                                      \tag{41.15}
\end{aligned}
\]

Because \(n_{-1,1}=u+1\ge1\), any \(d>0\) would place both
\((1,1)\) and \((-1,1)\) among the weights.  Their determinant is \(2\),
contradicting (41.10).  Hence \(d=0\).  Solving (41.15) gives

\[
 x=A-u,\qquad y=B-u,\qquad z=2(3-A-B+u).                        \tag{41.15a}
\]

Nonnegativity is exactly the interval in (41.12).  The weights fail to span
rank two precisely when \(x=y=0\), namely \(A=B=u\); this is the excluded
case.  Substitution gives (41.13).  Conversely those counts balance every
weight line after adding \((1,-1)\), and their nonzero determinants have
absolute value one.  Evaluating the four choices of \((A,B)\) gives the
table.  \(\square\)

### Corollary 41.3A -- genuine-wall pruning

Assume in addition that both coordinate hyperplanes are genuine rank-two
VGIT walls:

\[
 \operatorname{span}_{\mathbf R}\{w_j:a_j=0\}=\ker(a),\qquad
 \operatorname{span}_{\mathbf R}\{w_j:b_j=0\}=\ker(b).          \tag{41.15b}
\]

Then there is exactly one completed signature for each ordered wall-type
pair.  Its parameter is

\[
 (A,B,u)=(1,1,0),\ (1,2,0),\ (2,1,0),\ (2,2,1),                \tag{41.15c}
\]

respectively.

#### Proof

After Theorem 41.3 has forced \(d=0\), the nonzero weights with first
coordinate zero are the \(y\) vertical pairs, while those with second
coordinate zero are the \(x\) horizontal pairs.  Thus (41.15b) is equivalent
to

\[
                         y=B-u>0,\qquad x=A-u>0.                \tag{41.15d}
\]

Adding \(u<\min(A,B)\) to (41.12) leaves precisely the four values in
(41.15c).  \(\square\)

### Theorem 41.4 -- genuine unit walls without total unimodularity

Drop (41.10), but retain (41.7)--(41.9) and the genuine-wall condition
(41.15b).  Then \(W^{\mathrm{can}}\) is quasi-symmetric if and only if there
are integers \(d,u\ge0\), with \(s=d+u\), such that

\[
 \max(0,A+B-3)\le s<\min(A,B),                                 \tag{41.15e}
\]

and the nonzero counts are

\[
\boxed{
\begin{aligned}
 n_{1,0}=n_{-1,0}&=A-s,\\
 n_{0,1}=n_{0,-1}&=B-s,\\
 n_{1,1}=n_{-1,-1}&=d,\\
 n_{1,-1}&=u,\\
 n_{-1,1}&=u+1,\\
 n_{0,0}&=2(3-A-B+s).
\end{aligned}}                                                  \tag{41.15f}
\]

Consequently the ordered pairs \((1,1),(1,2),(2,1)\) each have one
signature, with \((d,u)=(0,0)\), while \((2,2)\) has exactly two, with

\[
                         (d,u)=(1,0)\quad\text{or}\quad(0,1).   \tag{41.15g}
\]

The second is the totally-unimodular signature in (41.15c).  The first has
both slope-(+1) weights and one raw slope-(-1) weight; it is compatible
with smooth adjacent wall rays but contains a nonadjacent determinant-two
pair.

#### Proof

The line-balance variables in (41.14) apply without (41.10).  Equations
(41.15) now give

\[
 x=A-d-u=A-s,\quad y=B-d-u=B-s,\quad
 z=2(3-A-B+s).                                                  \tag{41.15h}
\]

Nonnegativity gives the weak bounds in (41.15e), and the two genuine-wall
spanning conditions sharpen the upper bound to \(s<\min(A,B)\).  Conversely,
the counts (41.15f) balance each line and realize both walls.  For the first
three ordered pairs (41.15e) forces \(s=0\).  For \((2,2)\) it forces
\(s=1\), whose two ordered decompositions are (41.15g).  The
\((d,u)=(1,0)\) model contains \((1,1)\) and \((-1,1)\), of determinant
two, while \((0,1)\) is exactly the model retained by (41.10).  \(\square\)

### Corollary 41.4A -- oriented chamber selector

In the affine rank-two weight-ray pilot, specify which open quadrant between
the two coordinate wall rays is the intermediate GIT chamber.  If
consecutiveness is certified by the absence of a nonzero raw weight ray in
that quadrant, then for every ordered wall-type pair:

1. the northeast, southeast, and southwest choices each select exactly one
   of the signatures in Theorem 41.4; and
2. the northwest choice selects none.

For the three non-flip--flip ordered types, their unique signature works in
all three admissible quadrants.  For flip--flip, northeast and southwest
select \((d,u)=(0,1)\), while southeast selects \((d,u)=(1,0)\).

#### Proof

Every signature contains the raw discrepancy ray \((-1,1)\), so northwest
is never empty.  For the three unique signatures \(d=u=0\), no other open
quadrant contains a diagonal weight.  In the flip--flip case, \((d,u)=(1,0)\)
adds the northeast and southwest rays \(\pm(1,1)\), leaving only southeast
empty; \((d,u)=(0,1)\) adds the southeast ray \((1,-1)\), leaving northeast
and southwest empty.  \(\square\)

This is a combinatorial selector, not yet an identification theorem for an
AKMW overlap: the occurrence must first be realized by this common affine
weight-ray fan with the stated oriented chamber.

## 41.4 What the classification buys

The raw seven-weight model is necessarily non-quasi-symmetric by Proposition
41.1.  Each of the five genuine-wall completed models in Theorem 41.4,
however, lies in the
quasi-symmetric torus-representation class of the nonresonant schober/GKZ
theorem.  Thus, **if** an actual \((1,1)\) overlap admits a common matrix
satisfying the unit row data (41.7)--(41.9) and the genuine-wall condition
(41.15b), with one of the five classified incidences, and
**if** its canonical-character coordinate has the required QDM
interpretation, the generic-calibration box of Module 40 has a finite list of
five concrete candidates.  If the stronger total-unimodularity certificate
(41.10) is available, Corollary 41.3A reduces this to four.
If the oriented intermediate chamber is also known in the affine weight-ray
model, Corollary 41.4A selects at most one candidate for that occurrence.

Two vertical arrows remain:

\[
\begin{CD}
 \text{window/schober of }W^{\mathrm{can}}
   @>{\sim\text{ generically}}>>
 \text{GKZ of }W^{\mathrm{can}}\\
 @V{\text{remove canonical coordinate}}VV
 @VV{\text{QDM descent}}V\\
 \text{window data of }W
   @>{\dashrightarrow}>
 \text{marked packet coimage of the actual overlap}.
\end{CD}                                                        \tag{41.16}
\]

Neither vertical arrow is supplied by quasi-symmetry.  They must preserve
the occurrence labels, fixed phase, primitive packet, rank row, canonical
trait lattice, and exact closed-fibre base change of Module 40.  Restricting
or specializing the added coordinate can itself create the parameter
torsion detected by Theorems 40.1--40.2.

### Corollary 41.3B -- exact \((1,1)\) completion route

The primitive unit overlap is rank-safe if the following are supplied:

1. an occurrence-local common two-ray model satisfying (41.7)--(41.9);
2. the genuine-wall certificate (41.15b), hence identification of its weight
   incidence with one of the five signatures in Theorem 41.4;
3. a canonical-character QDM completion realizing the chosen signature
   (41.15f), with (41.13) as the total-unimodular subcase;
4. the faithful completed torus action and a chosen nonresonant generic
   parameter at which the schober/GKZ comparison applies;
5. a descent square (41.16) satisfying the marked trait, saturation, and
   exact-base-change conditions of Theorem 40.4.

This is a conditional specialization of Theorem 40.4, not a new
unconditional wall theorem.

## 41.5 Why Lawrence doubling is not yet a shortcut

For any representation \(W\),

\[
                         W\oplus W^\vee                         \tag{41.17}
\]

is quasi-symmetric, since every weight is paired with its negative.  This is
the universal cheap completion.  It changes the quotient dimension and
introduces a second copy of every exceptional direction.  No current source
identifies restriction from its GKZ/window comparison with the original
discrepant QDM overlap.  The required descent is at least as strong as
(41.16), and can again carry closed-support torsion.

Thus a Lawrence lift is a lawful **generic receiver generator**, but not an
eliminator into the geometric \(m=2\) consumer.

## 41.6 Executable calibration

For each of the four ordered pairs \((A,B)\), the shared finite replay fixes
one first-row ordering and exhausts every distinct assignment of the second
row in (41.8), \(630\) assignments in total.  It verifies:

- no raw assignment is quasi-symmetric, in agreement with
  \(\kappa=(-1,1)\ne0\); and
- among effective totally-unimodular assignments whose one-coordinate
  completion is quasi-symmetric, the labelled-assignment and signature counts
  are

  \[
  \begin{array}{c|cccc}
  (A,B)&(1,1)&(1,2)&(2,1)&(2,2)\\ \hline
  \text{labelled assignments}&24&24&12&12\\
  \text{incidence signatures}&1&2&2&1.
  \end{array}                                                   \tag{41.18}
  \]

  The six abstract totally-unimodular signatures are exactly those produced
  by (41.12)--(41.13).  Imposing the two genuine-wall spanning conditions
  leaves exactly one totally-unimodular signature for each ordered type, as
  in (41.15c).  A second replay without the total-unimodularity filter checks
  Theorem 41.4: the genuine-wall signature counts are \(1,1,1,2\), and the
  labelled-assignment counts are \(24,12,6,36\).
  A final finite check applies the empty-open-quadrant criterion and verifies
  that northeast, southeast, and southwest each retain exactly one signature
  per ordered type, while northwest retains none.

The proof of Theorem 41.3 is the symbolic argument (41.14)--(41.15); the
enumeration is only a bounded regression.

## 41.7 Source and scope audit

The external comparison scope is Spenko--Van den Bergh,
*Perverse schobers and GKZ systems*, arXiv:2007.04924v3: the theorem assumes
a faithful quasi-symmetric torus representation and a nonresonant parameter.
Every genuine-wall signature in Theorem 41.4 contains both an axis weight and
its opposite on each coordinate axis, so its completed torus action is
faithful.  The theorem applies only after choosing a nonresonant parameter for
the completed model and after supplying the remaining geometric
identifications.

The unit-coefficient input for individual AKMW circuits comes from
notes/2026-08-13-c907-akmw-pi-nonsingular-circuits-are-unit.md.  That result
does not assert one common rank-two unit matrix for a consecutive pair, so
(41.7)--(41.9) and (41.15b) remain occurrence-level pilot hypotheses.  It
also does not assert the optional total-unimodularity condition (41.10).

Propositions 41.1--41.2, Theorems 41.3--41.4, and Corollaries 41.3A and 41.4A
are proved in this module.  No source is being read as a descent theorem for
(41.16).

## 41.8 EJ/TT and mystery ledger

**EJ.** The first neutral slope has only five genuine unit-wall completed
incidences even without total unimodularity.  Three ordered wall-type pairs
have a unique model; flip--flip has two.  Total unimodularity removes exactly
the determinant-two flip--flip model and leaves four calculations.  More
cheaply, the oriented intermediate chamber selects at most one model for each
actual occurrence.

**TT.** Neutrality is a statement about one combination of cocharacters;
quasi-symmetry is a line-by-line statement about the whole weight
representation.  Do not confuse them.  Also do not celebrate the completed
generic theorem until the canonical coordinate can be removed without
creating the resonant torsion isolated in Module 40.

| question | status | exact evidence or gate |
|---|---|---|
| Can a raw discrepant overlap be quasi-symmetric? | **no** | Proposition 41.1 |
| Does a neutral slope repair that? | **no** | (41.4) |
| Does one canonical weight always repair rank-two quasi-symmetry? | **no** | Proposition 41.2 |
| What are the abstract completed \((1,1)\) unit signatures under (41.10)? | **six total; \(1,2,2,1\) by ordered type** | Theorem 41.3 |
| Which can represent two genuine walls? | **four; one per ordered type** | Corollary 41.3A |
| Without total unimodularity, how large is the genuine-wall search? | **five; \(1,1,1,2\) by ordered type** | Theorem 41.4 |
| Does the oriented chamber select among them? | **yes in the affine weight-ray pilot; NE/SE/SW give one, NW none** | Corollary 41.4A |
| Is the common total-unimodular matrix forced by AKMW unit circuits? | **open** | individual circuit units do not imply (41.10) |
| Does the completed schober comparison descend to the QDM overlap? | **open** | square (41.16) |
| Does this prove the \((1,1)\) overlap safe? | **no** | Corollary 41.3B remains conditional |

## Boundary

The direct raw quasi-symmetric-GKZ route is closed negative for every
discrepant wall.  For the primitive \((1,1)\) overlap, a single
canonical-character coordinate produces only five genuine unit-wall
quasi-symmetric eight-weight signatures without total unimodularity.  There
is one per ordered wall-type pair except for two flip--flip models; the
strong total-unimodularity pilot removes the determinant-two model.  The next
theorem is no longer an
arbitrary two-wall Stokes statement: it is the occurrence realization and
oriented-chamber identification, followed by marked saturated descent of the
selected model.  No unconditional
\(m=2\) result follows.
