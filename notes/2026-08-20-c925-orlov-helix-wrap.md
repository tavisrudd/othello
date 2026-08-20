# Module 32. Orlov helix wrap and center-supported leakage

**Packet part:** Module 32.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** derived ambient-projection theorem proved; cyclotomic/QDM
realization remains open

## 32.1 The exceptional twist is a helix translation

Let

\[
\pi:\widetilde Y=\operatorname{Bl}_Z Y\to Y
\tag{32.1}
\]

be the blowup of a smooth connected center of codimension \(c\ge2\), with
exceptional divisor \(i:E\hookrightarrow\widetilde Y\) and
\(p:E=\mathbf P(N_{Z/Y})\to Z\).  Use Orlov's decomposition

\[
D^b(\widetilde Y)
=
\left\langle
\Phi_{c-1}D^b(Z),\ldots,\Phi_1D^b(Z),\pi^*D^b(Y)
\right\rangle,
\tag{32.2}
\]

where

\[
\Phi_j(F)=i_*\!\left(p^*F\otimes\mathcal O_E(-j)\right).
\tag{32.3}
\]

Since
\(\mathcal O_{\widetilde Y}(-E)|_E\cong\mathcal O_E(1)\),

\[
\Phi_j(F)\otimes\mathcal O_{\widetilde Y}(-aE)
\cong
i_*\!\left(p^*F\otimes\mathcal O_E(a-j)\right).
\tag{32.4}
\]

Thus the mobile correction translates the exceptional index by \(a\).
For \(1\le j-a\le c-1\), it stays inside the exceptional window.  For
\(a\ge j\), it crosses the \(j=0\) boundary and can acquire an ambient
component.

## 32.2 Exact ambient projection

Let

\[
\operatorname{Amb}:D^b(\widetilde Y)\longrightarrow
L\pi^*D^b(Y)
\tag{32.5}
\]

denote the rightmost-component projection in (32.2).  Since the inclusion
\(L\pi^*\) has right adjoint \(R\pi_*\), its value is represented by the
counit term

\[
\operatorname{Amb}(G)\cong L\pi^*R\pi_*G.
\tag{32.6}
\]

### Theorem 32.1 -- helix-wrap factorization

For \(F\in D^b(Z)\) and \(k\in\mathbf Z\),

\[
\operatorname{Amb}
\left(i_*(p^*F\otimes\mathcal O_E(k))\right)
\cong
L\pi^*i_{Z*}
\left(F\overset L\otimes Rp_*\mathcal O_E(k)\right).
\tag{32.7}
\]

In particular:

1. if \(-c<k<0\), the ambient projection is zero; and
2. if \(k\ge0\), it factors through the center-to-ambient Gysin functor
   \(i_{Z*}:D^b(Z)\to D^b(Y)\).

For \(k\ge0\), \(Rp_*\mathcal O_E(k)\) is concentrated in degree zero and
is the corresponding symmetric power of \(N_{Z/Y}\) or its dual, according
to the chosen convention for \(\mathbf P(N_{Z/Y})\).  We keep the
convention-free expression \(Rp_*\mathcal O_E(k)\), since the
center-factorization does not depend on that choice.

#### Proof

Using \(\pi i=i_Zp\), derived functoriality, and projection formula,

\[
\begin{aligned}
R\pi_*i_*(p^*F\otimes\mathcal O_E(k))
&\cong
i_{Z*}Rp_*(p^*F\otimes\mathcal O_E(k))\\
&\cong
i_{Z*}\left(F\overset L\otimes Rp_*\mathcal O_E(k)\right).
\end{aligned}
\]

Apply \(L\pi^*\) and (32.6).  The projective-bundle cohomology formula gives
\(Rp_*\mathcal O_E(k)=0\) throughout the Orlov window
\(-c<k<0\), and gives the stated symmetric-power object for \(k\ge0\).
\(\square\)

### Corollary 32.1A -- mobile correction

For the mobile multiplicity \(a\ge0\),

\[
\operatorname{Amb}
\left(\Phi_j(F)\otimes\mathcal O(-aE)\right)=0
\qquad\text{if }a<j,
\tag{32.8}
\]

whereas for \(a\ge j\),

\[
\operatorname{Amb}
\left(\Phi_j(F)\otimes\mathcal O(-aE)\right)
\cong
L\pi^*i_{Z*}
\left(F\overset L\otimes
Rp_*\mathcal O_E(a-j)\right).
\tag{32.9}
\]

The first helix wrap is therefore not an arbitrary ambient error.  It is a
center-supported Gysin term with an explicit normal-bundle coefficient.

### Theorem 32.2 -- the ambient-input defect is center-supported

Let \(G\in D^b(Y)\), and write \(I_Z\subset\mathcal O_Y\) for the center
ideal.  For every \(a\ge0\),

\[
\operatorname{Amb}
\left(L\pi^*G\otimes\mathcal O_{\widetilde Y}(-aE)\right)
\cong
L\pi^*\left(G\overset L\otimes I_Z^a\right).
\tag{32.9a}
\]

The canonical map from (32.9a) to \(L\pi^*G\) has cone

\[
L\pi^*\left(G\overset L\otimes\mathcal O_Y/I_Z^a\right).
\tag{32.9b}
\]

For \(a\ge1\), this cone has a finite filtration whose graded terms are

\[
L\pi^*i_{Z*}
\left(Li_Z^*G\overset L\otimes\operatorname{Sym}^rN_{Z/Y}^{\vee}\right),
\qquad 0\le r<a.
\tag{32.9c}
\]

Thus tensoring the ambient block by the mobile correction is the identity
modulo the thickened-center subcategory; it is not literally the identity on
the ambient block.

#### Proof

For a blowup of a smooth center,
\(R\pi_*\mathcal O_{\widetilde Y}(-aE)\cong I_Z^a\) for \(a\ge0\), with no
higher direct images.  Projection formula and (32.6) give (32.9a).  Apply
\(L\pi^*\) to the triangle induced by
\(0\to I_Z^a\to\mathcal O_Y\to\mathcal O_Y/I_Z^a\to0\) to obtain
(32.9b).  Finally, the regular embedding has
\(I_Z^r/I_Z^{r+1}\cong i_{Z*}\operatorname{Sym}^rN_{Z/Y}^{\vee}\);
projection formula gives the filtration (32.9c).  \(\square\)

## 32.3 Codimension two

When \(c=2\), there is one exceptional component \(\Phi_1\).  For every
positive mobile multiplicity,

\[
\operatorname{Amb}
\left(\Phi_1(F)\otimes\mathcal O(-aE)\right)
\cong
L\pi^*i_{Z*}
\left(F\overset L\otimes
Rp_*\mathcal O_E(a-1)\right).
\tag{32.10}
\]

At \(a=1\), this is simply

\[
L\pi^*i_{Z*}F.
\tag{32.11}
\]

This recovers the \(j=-1\) to \(j=0\) wrap isolated in the C907
base-ideal obstruction, while identifying its ambient component functorially.

The coefficient \(a\) changes only the perfect center coefficient
\(Rp_*\mathcal O_E(a-1)\).  Therefore a receiver which kills the **entire**
relevant center category and is compatible with \(i_{Z*}\) kills every
positive-\(a\) wrap at once.  Vanishing of one distinguished center object
would not be enough.

## 32.4 Categorical specialization theorem

Let \(\mathcal R_\chi\) be an exact/triangulated operation-framed realization on the
actual occurrence, with:

1. a lawful primitive-character projection;
2. compatibility with Orlov's component functors and ambient projection;
3. compatibility with the center Gysin \(i_{Z*}\); and
4. compatibility with tensoring by the perfect coefficients
   \(Rp_*\mathcal O_E(k)\) and
   \(\operatorname{Sym}^rN_{Z/Y}^{\vee}\).

### Corollary 32.2A -- center-null consumers kill the whole mobile defect

Assume that

\[
\mathcal R_\chi(F)=0
\quad\text{for every }F\in D^b(Z)
\tag{32.12}
\]

in every admitted occurrence of the center category.  Then every
exceptional-block wrap
(32.9) vanishes, and the ambient-block map (32.9a) becomes an isomorphism,
after \(\mathcal R_\chi\).

#### Proof

The exceptional-block claim follows from (32.9).  The cone of the
ambient-block map is filtered by the Gysin terms (32.9c), so the same
center-null hypothesis kills that cone.  \(\square\)

The conclusion is stronger than intrinsic packet-count vanishing only
because the hypothesis is stronger: it supplies one supported/Gysin
realization of the whole center category, and exactness kills its thick
closure, including the filtered thickening in (32.9c).  Theorems 32.1 and
32.2 do not construct that realization.

## 32.5 What this resolves at \(m=2\)

Assume the baseline inputs already isolated in Modules 24--30: a common
primitive-character receiver, the local divisor-cocharacter/Levelt
pure-pullback certificate, typed endpoint identification, and the
independent exceptional exponent bound.  Then, on the **correction side**
of a fivefold weak factorization:

1. point, curve, and surface mobile corrections are formally reduced by
   Theorems 32.1 and 32.2 to their supported center receivers;
2. if the same primitive-character provider proves those entire receivers
   zero, neither their exceptional twists nor their ambient-input defects
   can manufacture projected
   \(\operatorname{Top}_2\), despite the raw \(K_0\) counterexample; and
3. the genuinely new codimension-two case is a threefold center, where the
   center receiver need not vanish.

Thus the mobile correction does not create a new classification problem
for every base multiplicity.  After the baseline inputs above, its new
correction-side remainder asks for:

\[
\boxed{
\text{one thickened-center/Gysin realization}
+\text{ one threefold carrier-and-mixed-boundary theorem}.
}
\tag{32.13}
\]

This remains conditional.  Existing intrinsic low-dimensional QDM
vanishing does not by itself give the functorial hypothesis (32.12).

## 32.6 General \(m\)

Theorems 32.1 and 32.2 are independent of \(m\).  At any stabilization
index, every exceptional-twist wrap and every ambient-input defect factors
through a center or thickened-center object with a symmetric normal-bundle
coefficient.  After the same baseline common-receiver, cocharacter/Levelt,
endpoint, and exponent inputs, the **correction-side** provider needs only:

1. the finitely many mixed logarithmic words;
2. their ambient projections and cones through (32.9) and (32.9c); and
3. the indexed carrier bound on the resulting center packets.

This is a finite list of operation **shapes** at each \(m\), but not a finite
computational problem: the center occurrences, mobile multiplicities, and
normal-bundle coefficients range over unbounded families.  Nor is there a
uniform bound on the number of mixed words as \(m\) grows.  A uniform
all-\(m\) theorem would need a tensor-ideal or filtration law killing the
whole parameterized family at once.

## 32.7 Sparse-shadow interpretation

The full mutation history is unnecessary for the ambient consumer.  Put
\(\omega=(i_Z:Z\hookrightarrow Y,N_{Z/Y},p:E\to Z)\) for the geometric
Reader environment of the actual occurrence.  For each exceptional block
the sparse shadow retains only:

\[
(\omega;j,a,F)
\longmapsto
\begin{cases}
0,&a<j,\\
i_{Z*}\!\left(F\otimes Rp_*\mathcal O_E(a-j)\right),&a\ge j,
\end{cases}
\tag{32.14}
\]

The ambient-input branch additionally retains
\((\omega;a,G)\mapsto G\otimes^L I_Z^a\to G\), whose cone is reconstructed
from the finite list in (32.9c).  This is a path-dependent mapping function
from an occurrence-index shadow
to a supported ambient shadow.  It is exactly the “remember the forgetting
path, then read through a parallel projection” mechanism proposed earlier.
The forgotten helix index \(j\), Writer value \(a\), and Reader environment
\(\omega\) reconstruct exactly the center-supported terms needed later,
without reconstructing the rich mutation object.

## 32.8 Finite calibration

The shared finite replay checks for \(2\le c\le8\),
\(1\le j\le c-1\), and \(0\le a\le12\) that:

1. \(a<j\) lands in the acyclic Orlov window
   \(-c<a-j<0\); and
2. \(a\ge j\) is exactly the first nonnegative helix-wrap regime.

This is only the index arithmetic.  Theorem 32.1, not the replay, proves the
derived factorization.

## 32.9 EJ/TT audit

**EJ.** The exceptional twist's ambient leakage is not arbitrary: it is a
Gysin image of a center object with an explicit symmetric normal-bundle
coefficient.  All positive base multiplicities are handled by one
center-null tensor-ideal statement.

**TT.** Intrinsic center packet vanishing remains too weak.  The provider
must realize tensoring by every coefficient in (32.9) and the supported
pushforward \(i_{Z*}\).  This is exactly where earlier residual-category and
raw-\(K_0\) shortcuts failed.

## 32.10 Mystery ledger

| question | status | exact evidence or gate |
|---|---|---|
| When does an exceptional shift reach the ambient block? | **settled** | exactly \(a\ge j\), Corollary 32.1A |
| Through what does the ambient term factor? | **settled** | center Gysin with \(Rp_*\mathcal O_E(a-j)\), Theorem 32.1 |
| Can a center-null tensor ideal kill every multiplicity? | **settled formally** | Corollary 32.2A |
| Does ordinary Gamma projection define that tensor ideal/Gysin receiver? | **no** | Module 33 point-support collision |
| Can a corrected intrinsic support/Gysin receiver do so? | **open** | construct the relative framed localizing quantum motive |
| What remains for a threefold center at \(m=2\)? | **open** | projected mixed graph/boundary plus carrier exponent |
| What is the uniform all-\(m\) law? | **open** | tensor ideal or filtration killing all mixed Gysin words |

## Boundary

Theorems 32.1--32.2 and Corollaries 32.1A and 32.2A are proved at the derived/exact
interface.  They identify the exact center-supported shape of mobile
exceptional leakage but do not construct its cyclotomic QDM realization.
Module 33 proves that ordinary Gamma projection cannot be that realization;
only a corrected intrinsic Gysin theory remains open on this branch.
No unconditional \(m=2\) or all-\(m\) theorem follows.
