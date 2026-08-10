# C902 cold algebra review

**Date:** 2026-08-09

**Lane:** `clebsch`

**Scope:** mathematical correctness only, for the current worktree version of
`papers/clebsch-passages/sections/05-golden-operator.tex` (blob
`d1308a454c355ec6d54fceb315871d75a031b388`).  I did not read C902's proposed
wording or any other C902 cold review.

## Verdict

**PASS.  No mathematical defect found.**

The triangle--Pfaffian theorem has the right hypotheses, conclusion, sign
covariance, and boundary.  The determinant-line norm has the right constant
and is compatible with the marked scalar normalization.  The closing spectral
sentence does not conflate squared singular data with oriented determinant or
cubic data.

## Independent checks

- Both sides of a nonzero proportionality are homogeneous of degrees \(n/2\)
  and \(3\), hence \(n=6\).  Translation invariance of the commutator gives

  \[
  [t x_i x_j]\,\mathcal T_A(x+t\mathbf1)
   =a_{ij}\sum_{r\ne i,j}a_{ir}a_{rj}=a_{ij}(A^2)_{ij}.
  \]

  Nonzero off-diagonal entries therefore make \(A^2\) diagonal; commuting
  \(A\) with \(A^2\) makes that diagonal scalar.  Over the reals its scalar is
  \(\sum_{r\ne i}a_{ir}^2>0\).
- On the equal-absolute-value locus, scaling gives a sign matrix \(B\) with
  \(B^2=5I\).  Gauging one star positive makes every remaining vertex have two
  edges of each sign, so either sign graph is the unique five-cycle up to
  relabelling.  A diagonal switching \(D\) multiplies the Pfaffian by
  \(\det D\) and leaves every triangle product fixed; a permutation contributes
  its sign after variable transport.  Thus the ratio is multiplied by the
  determinant of the signed relabelling, giving precisely the two values
  \(\pm4\).
- In the golden splitting the commutator has blocks

  \[
  \begin{pmatrix}0&-2\sqrt5 B^{\mathsf T}\\2\sqrt5 B&0\end{pmatrix}.
  \]

  Its determinant is \((2\sqrt5)^6\det(B^{\mathsf T}B)\), and
  \((2\sqrt5)^6=8000\).  Galois exchange and the symmetric pairing identify
  this product with the determinant-line norm, so
  \(\det[D_x,C_T]=8000N_{E/\mathbf Q}(\det B_T(x))\).  Combining this with
  \(\det[D_x,C_T]=16Z_T(x)^2\) yields
  \(Z_T=10\sqrt5\det B_T\) after the already specified compatible orientation.
  Here \(N\) must be read, as the manuscript says, as the determinant-line norm,
  not as the naive field norm of a scalar chosen in unrelated bases.
- The exclusions are honest: zero proportionality and zero edges are outside
  the proof, and the theorem does not claim a converse or classification on the
  remaining weighted locus \(A^2=\lambda I\).  The spectral paragraph likewise
  says only that squared singular spectrum forgets the determinant-line sign.

## Authority and trust boundary

The calculation agrees with the C809 proof authority and the C862 theorem
packet.  The existing Lean maps prove the fixed-conference commutator
determinant factor, including \(8000\), and the exact \(10s\)-Pfaffian formula
in `RelativeConicArcs.CrossGoldenDeterminant`.  That module explicitly leaves
the restricted three-by-three determinant-line comparison as human linear
algebra; the manuscript's norm paragraph supplies that comparison correctly
and does not claim otherwise.

## EJ + Tao closeout and mystery ledger

The closeout found no cheap strengthening needed for correctness.  No genuine
mathematical mystery remains within this review's scope.  Classification of
weighted solutions and any formalization of the determinant-line comparison
are expressly outside the stated theorem and remain owned elsewhere.

## Repair regrade — 2026-08-09

**PASS on repaired blob
e5633e75001d8c21504b14de3dbd2a858863a925.**  The repaired minus sign in
\[
 \det[D_x,C_T]
 =-8000\,N_{E/\mathbf Q}\!\left(\det B_T(x)\right)
\]
is exact.  This regrade supersedes the positive-norm assertion in the initial
review above.

Write \(s=\sqrt5\) and let \(b\) be the scalar of the restricted
three-dimensional determinant in the compatible oriented frames.  The marked
identity is \(Z=10sb\), with \(Z\) rational and \(\sigma(s)=-s\).  Conjugating
therefore gives \(\sigma(b)=-b\), so the ordinary field norm is
\[
 N_{E/\mathbf Q}(b)=b\,\sigma(b)=-b^2.
\]
On the other hand, the commutator block matrix
\[
 \begin{pmatrix}0&-2sB^{\mathsf T}\\2sB&0\end{pmatrix}
\]
has determinant \((2s)^6b^2=8000b^2\).  Hence its determinant is
\(-8000N_{E/\mathbf Q}(b)\), and this also equals
\(16Z^2\).  The odd rank is essential: exchanging the two determinant
three-spaces contributes the sign that distinguishes the signed
determinant-line contraction from a positive square.  No further repair is
needed in the reviewed passage.
