# Module 4. A reusable rank-two observation

**Packet part:** Modules 4--6.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

This module supplies one possible observation for a marker package.  Other
packages may ignore it entirely.

Let \(B\) be a generic even spectral block of rank two.  Center its Euler
eigenvalue and write its horizontal \(z\)-equation as
\[
z\partial_z y=A(z)y,
\qquad
A(z)=z^{-1}N+A_0+zA_1+\cdots.
\tag{4.1}
\]
Concretely, centering subtracts \(z^{-1}\lambda I\) from the horizontal
matrix and adds \(z^{-1}(\partial\lambda)I\) to a base-direction matrix.  It is
the connection-level form of the scalar factor \(e^{-\lambda/z}\), but no
exponential is adjoined.  The scalar factors at \(-z\) and \(z\) cancel in the
horizontal pairing, so centering preserves it.

Assume \(N\ne0\).  Since \(N\) is a nilpotent \(2\times2\) matrix,
\[
N^2=0,
\qquad
L:=\operatorname{im}N=\ker N
\tag{4.2}
\]
is an intrinsic line.

## Lemma 4.1 — the regular coefficient preserves the intrinsic line

\[
A_0L\subset L.
\tag{4.3}
\]

### Proof

Write the horizontal pairing as
\[
P(z)=P_0+zP_1+\cdots.
\]
Pairing horizontality for the convention (4.1) reads
\[
z\partial_zP+A(-z)^TP+PA(z)=0.
\tag{4.4}
\]
The \(z^{-1}\)-coefficient gives
\[
N^TP_0=P_0N.
\tag{4.5}
\]
Thus \(N\) is self-adjoint for the nondegenerate symmetric form \(P_0\).
The line \(L\) is isotropic, and in dimension two \(L^\perp=L\).

The constant coefficient of (4.4) is
\[
A_0^TP_0+P_0A_0-N^TP_1+P_1N=0.
\tag{4.6}
\]
For \(0\ne x\in L=\ker N\), sandwiching (4.6) between \(x\) and \(x\)
gives \((A_0x,x)_{P_0}=0\).  Hence \(A_0x\in L^\perp=L\). ∎

## Definition 4.2 — canonical shear and modified residue

Define the elementary modification
\[
B^\sharp=\{s\in B:s\bmod z\in L\}.
\tag{4.7}
\]
Choose an adapted frame with
\[
N=\nu E_{12},\qquad \nu\ne0,
\]
and use the new lattice basis \((e_1,ze_2)\), represented by
\[
S=\operatorname{diag}(1,z).
\]
The transformed horizontal matrix is
\[
A^\sharp=S^{-1}AS-S^{-1}z\partial_zS.
\tag{4.8}
\]
The irregular term becomes the regular term \(\nu E_{12}\).  The only
possible pole from \(A_0\) would be its \(E_{21}\)-entry, which vanishes by
Lemma 4.1.  Every higher term remains regular.  Thus
\[
A^\sharp=R+zR_1+z^2R_2+\cdots.
\tag{4.9}
\]
Define
\[
\delta^\sharp(B)=(\operatorname{tr}R)^2-4\det R.
\tag{4.10}
\]

## Lemma 4.3 — regular-gauge invariance

The rank, the condition \(N\ne0\), and \(\delta^\sharp\) satisfy the two marker
laws in Definition 2.1.

### Proof

Let \(T(z)=T_0+T_1z+\cdots\) be a regular invertible connection gauge.  Then
\[
N'=T_0^{-1}NT_0,
\qquad
L'=T_0^{-1}L.
\]
So \(T\) identifies the intrinsic modified lattices.  Its induced map there is
regular and invertible at \(z=0\), and the two modified residues are conjugate.
Rank, nonvanishing of \(N\), and the discriminant are therefore invariant.
The same statements plainly survive field extension. ∎

## Lemma 4.4 — flatness makes the modified spectrum constant

Along every formal even bulk direction, the modified residue evolves by a Lax
equation.  In particular, \(\delta^\sharp\) is constant.

### Proof

For a centered base direction \(\partial\), write
\[
\partial y=B_\partial(z)y,
\qquad
B_\partial=z^{-1}C_\partial+C_{\partial,0}+O(z).
\]
To justify the trace condition used below, start before centering with leading
Euler term \(\lambda I+N\).  The \(z^{-1}\)-coefficient of uncentered flatness
has trace
\[
2\,\partial\lambda+\operatorname{tr}C_\partial^{\mathrm{old}}=0.
\]
The scalar centering adds \((\partial\lambda)I\) to the base leading
coefficient, so
\[
C_\partial=C_\partial^{\mathrm{old}}+(\partial\lambda)I,
\qquad \operatorname{tr}C_\partial=0.
\]
The \(z^{-2}\)-coefficient of flatness gives
\[
[N,C_\partial]=0.
\]
Centering makes \(C_\partial\) traceless.  The commutant of a nonzero
rank-one nilpotent in dimension two is \(KI\oplus KN\), hence
\[
C_\partial=q_\partial N.
\tag{4.11}
\]

After the shear, the only possible base pole is
\[
B_\partial^\sharp=z^{-1}K_\partial+G_\partial+O(z),
\qquad K_\partial=kE_{21}.
\]
The \(z^{-1}\)-coefficient of modified flatness says
\[
K_\partial+[R,K_\partial]=0.
\]
Because \(R_{12}=\nu\ne0\), the diagonal entries force \(k=0\).  The modified
base connection is regular.  The constant term of flatness is therefore
\[
\partial R=[G_\partial,R].
\tag{4.12}
\]
Trace and determinant are constant under this Lax equation. ∎

## Example 4.5 — the qualitative rank-two observer

Take
\[
O_{\mathrm{rt}}
=\{(r,n,s):r\in\mathbf N,\ n,s\in\{0,1\}\},
\]
where
\[
r=\operatorname{rank}B,
\quad
n=[N\ne0],
\quad
s=[\delta^\sharp\ne0].
\]
For blocks not satisfying \(r=2,n=1\), set \(s=0\) by convention.  Lemma 4.3
makes this a lawful observation.  A caller can retain the entire triple, count
only \((2,1,1)\), or map it to a Boolean.

---

# Module 5. Direct sums and comparison adapters

## Lemma 5.1 — independent units separate summand spectra

Suppose QDM summands \(B_i\) have independent unit bulk coordinates \(u_i\).
Then their Euler spectra are pairwise disjoint at the generic point.

### Proof

The string equation makes the quantum product independent of \(u_i\), while
the Euler multiplication on the \(i\)-th summand is translated by \(u_iI\).
If \(p_i(T)\) and \(p_j(T)\) are the characteristic polynomials before unit
translation, the resultant of
\[
p_i(T-u_i),\qquad p_j(T-u_j)
\]
is a polynomial in \(u_i-u_j\) whose leading term, up to sign, is
\[
(u_i-u_j)^{(\deg p_i)(\deg p_j)}.
\]
It is not identically zero. ∎

## Proposition 5.2 — direct-sum adapter

Let a regular parity-preserving QDM isomorphism identify the generic even QDM
of \(Y\), after lawful coefficient extension and an invertible bulk-coordinate
change, with
\[
\bigoplus_{i=1}^m \mathscr Q_i.
\]
If the summands have independent unit coordinates, then for every lawful marker
package
\[
I_{\mathcal M}(Y)=\sum_{i=1}^m I_{\mathcal M}(\mathscr Q_i).
\tag{5.1}
\]

### Proof

Lemma 5.1 prevents blocks from different summands from merging.  Regularity,
parity, and the marker laws identify each even block with exactly one summand
block and preserve its weight.  Sum the weights. ∎

## Parity adapter

Both comparison papers work with supercommutative QDMs.  After odd bulk
coordinates are set to zero, all scalar coefficients—including roots of even
Novikov variables—have even parity.  The comparison constructions are
parity-even: their leading terms use only even hyperplane powers, even Gysin
degree shifts, and even Laurent scalars, and the formal coordinate maps are
maps of supermanifolds.  Therefore their comparison isomorphisms restrict to
the even QDMs used in this packet.

The Jacobian of a parity-even formal coordinate map is block diagonal by
parity at the odd-zero slice.  Invertibility of the full Jacobian therefore
implies invertibility of its even-even block.  The target even coordinates,
including all target unit coordinates, remain independent after the
restriction.

This is the only parity fact needed.  No odd block rank is retained.

## Regularity adapter

Iritani's blowup comparison is an isomorphism over a ring of the form
\[
\mathbf C[z]((\mathfrak q^{-1/s}))[[Q,t]],
\]
and Iritani--Koto's projective-bundle comparison is over
\[
\mathbf C[z]((q^{-1/r'}))[[Q,t]].
\]
Their maps and inverses require no negative powers of \(z\).  Iritani--Koto
Remark 5.3 explicitly places the homogeneous coefficient ring in a formal
power-series ring in \(z\).  Hence both comparisons are regular and invertible
at \(z=0\), as required by the marker interface.

---

# Module 6. Faithful center pullback

Iritani's raw center Novikov map can identify distinct curve classes.  The
following adapter repairs it without recursively composing asymptotic
completions.

Let \(i:Z\hookrightarrow Y\) be a smooth projective center.  After numerical
Novikov reduction, the raw map has the form
\[
Q_Z^d\longmapsto
c_d:=Q^{i_*d}\mathfrak q^{-\rho_Z\cdot d/(r-1)}.
\tag{6.1}
\]
Choose divisor classes \(D_1,\ldots,D_\rho\) separating \(N_1(Z)\) and put
\[
\ell_d(s)=\sum_i(D_i\cdot d)s_i.
\]

## Lemma 6.1 — finite-to-one character twisting is faithful

The reduced map
\[
Q_Z^d e^{\ell_d(s)}
\longmapsto
c_d e^{\ell_d(s)}
\tag{6.2}
\]
is injective on the numerical reduced completed coefficient algebra.

### Proof

First, every fibre of \(d\mapsto c_d\) is finite.  Equality \(c_d=c_{d'}\)
implies \(i_*d=i_*d'\).  For an ample divisor \(H\) on \(Y\), all elements of
one fibre have the same \(i^*H\)-degree.  The slice
\[
\{x\in\overline{NE}(Z):(i^*H)\cdot x\le M\}
\]
is compact and contains finitely many numerical lattice points.

Now group a series in the kernel by its target monomial \(c\).  Distinct
Laurent-Novikov monomials are linearly independent, and the finite-fibre
statement makes every such coefficient a finite sum
\[
\sum_{d:c_d=c}a_de^{\ell_d(s)}=0,
\tag{6.3}
\]
where the \(a_d\) are independent of the divisor variables.  Choose
\(v\in\mathbf C^\rho\) such that the finitely many numbers
\(\ell_d(v)\) are distinct.  Restrict to \(s=uv\) and differentiate at
\(u=0\) through one less than the fibre size.  The resulting Vandermonde
matrix has nonzero complex determinant, hence is invertible over the remaining
coefficient ring.  Every \(a_d\) vanishes. ∎

Iritani Remark 2.3 says that the intrinsic QDM uses divisor and Novikov
variables only in the combinations \(Q^de^{\ell_d(s)}\).  Remark 5.6 applies
the same reduction to each center QDM.  Theorem 5.18(7) makes the bulk systems
of all summands independent, so every center copy retains its own divisor and
unit coordinates.  Lemma 6.1 therefore identifies each center summand with a
faithful scalar extension and formal reparametrization of the intrinsic
generic numerical reduced QDM of \(Z\).

---
