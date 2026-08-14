# C907 — the `dP7` carrier peak fixes rank by an aggregate supported residue

Date: 2026-08-13

Status: exact integral `K_0` calculation and product-QDM calibration.  This is
the smallest genuine two-contraction peak with the cubic carrier attached.
It is safe.  Its change matrix has ambient-looking entries, but the complete
correction is a supported class and the rank row is fixed.  Consequently a
Gold proof should constrain the **aggregate image** of a contour/residue
block; requiring each coordinate term to look supported is too strong and
not basis invariant.

## 1. The peak

Let

\[
 S=\operatorname{Bl}_{p_1,p_2}\mathbf P^2
\]

with divisor classes `H,E1,E2`, and put

\[
 C=H-E_1-E_2.
\]

Both `E1` and `C` are `(-1)`-curves.  Contracting `E1` gives
`S -> F1`; contracting `C` gives `S -> P1 times P1`.  Their blowdown
Novikov charts have the Laurent transition `B=qq'` recorded in the peak
confluence audit.

For a smooth cubic threefold `X`,

\[
 Y=X\times S                                                     \tag{1}
\]

is a smooth projective fivefold peak.  The cubic quantum connection is an
honest carrier factor, while the two wall structures lie on `S`.

## 2. Two integral window bases

Expand the `k=0` blowup windows using the standard exceptional collections
on the two bases.  On the `E1` side use

\[
 \mathcal B_L=(\mathcal O,\mathcal O(H),\mathcal O(2H),
                \mathcal O_{E_2},\mathcal O_{E_1}).              \tag{2}
\]

On the `C` side use the pullback of the rectangular collection on
`P1 times P1`, followed by the center object:

\[
 \mathcal B_R=(\mathcal O,\mathcal O(H-E_1),\mathcal O(H-E_2),
 \mathcal O(2H-E_1-E_2),\mathcal O_C).                           \tag{3}
\]

The exact divisor sequences give

\[
\begin{aligned}
[\mathcal O(H-E_1)]&=[\mathcal O(H)]-[\mathcal O_{E_1}],\\
[\mathcal O(H-E_2)]&=[\mathcal O(H)]-[\mathcal O_{E_2}],\\
[\mathcal O(2H-E_1-E_2)]
 &=[\mathcal O(2H)]-[\mathcal O_{E_1}]-[\mathcal O_{E_2}].       \tag{4}
\end{aligned}
\]

Since `H+C=2H-E1-E2` and `(H+C)|_C` has degree zero, the divisor
sequence for `C` also gives

\[
 [\mathcal O_C]
 =[\mathcal O(2H-E_1-E_2)]-[\mathcal O(H)]
 =[\mathcal O(2H)]-[\mathcal O(H)]
  -[\mathcal O_{E_1}]-[\mathcal O_{E_2}].                        \tag{5}
\]

Thus, with columns expressing `B_R` in `B_L`, the exact integral matrix is

\[
 T_{L\leftarrow R}=
 \begin{pmatrix}
 1&0&0&0&0\\
 0&1&1&0&-1\\
 0&0&0&1&1\\
 0&0&-1&-1&-1\\
 0&-1&0&-1&-1
 \end{pmatrix}.                                                   \tag{6}
\]

The rank rows in the two bases are

\[
 r_L=(1,1,1,0,0),\qquad r_R=(1,1,1,1,0),                        \tag{7}
\]

and direct multiplication gives

\[
 \boxed{r_LT_{L\leftarrow R}=r_R}.                               \tag{8}
\]

The last column is the important warning.  In `B_L` coordinates the
supported class `O_C` contains the two ambient line-bundle terms
`O(2H)-O(H)`, of ranks `+1` and `-1`.  Looking at either coordinate alone
produces a false ambient target; the aggregate class has rank zero because
it is supported on `C`.

## 3. Cubic carrier and the primitive-sixth packet

Tensor (2)--(6) with any complexified Gamma `K`-class `e` on `X`, in
particular with either primitive-sixth cubic branch lift.  Every matrix entry
is unchanged, while every rank is multiplied by `rk(e)`.  Hence (8) remains
true even though `rk(e)` is nonzero for both cubic primitive-sixth lifts.

On the analytic side the product quantum connection is the exterior tensor
product.  The toric surface is weak Fano, so its wall Gamma/window
comparisons are in Iritani's proved toric range; Gamma product naturality
then identifies the carrier-dressed comparison with `id_X tensor T`.
Therefore the whole primitive-sixth packet is transported invertibly and
the rank Boolean is unchanged.

This also explains why the neutral class in this peak is harmless despite
the incompatible Laurent blowdown charts: it lives entirely in the surface
factor.  Thom--Sebastiani prevents it from manufacturing the mixed
carrier-to-ambient extension exhibited by the incomplete-Gamma
countermodel.

## 4. Consequence for the target lemma

The invariant Gold target should be stated as

\[
 r_p(T-1)|_{P_6}=0,                                               \tag{9}
\]

or as factorization of `T-1` through the **span** of supported output
classes.  It should not demand that every term in an arbitrarily refined
line-bundle or thimble coordinate expansion is individually supported.
Equation (5) is the smallest geometric reason: supported residues can have
ambient coordinate shadows whose ranks cancel only after the complete
residue block is assembled.

Accordingly the remaining two-wall Fourier theorem may allow several pole
residues per unstable stratum.  What must be shown is that their sum is the
Gamma image of a class supported on that stratum.  This is precisely the
pattern in the one-wall Mellin--Barnes/Fourier--Mukai formula.

## EJ / TT / AA

- **EJ:** the first genuine carrier peak is safe by the integral identity
  (5), not by termwise vanishing.
- **TT:** an ambient coordinate is not an ambient target.  Test the support
  and rank of the complete residue block.
- **AA:** formulate the final Fourier-residue lemma blockwise.  The smallest
  counterexample must have a complete pole-residue block whose output class
  has nonzero common-open rank; a nonzero individual coordinate is not
  enough.
