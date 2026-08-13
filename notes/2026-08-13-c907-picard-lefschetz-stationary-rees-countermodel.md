# C907 Picard--Lefschetz parity does not kill the stationary \(D_5\) Rees square

**Lane:** clebsch

**Status:** theorem-grade formal obstruction.  At a one-node cubic-surface
fibre, Picard--Lefschetz equivariance has the opposite parity from the hoped
root-targeting shortcut: the square of a sign/vanishing-root arrow is
stationary.  Formal \(1/6\)-monodromy, a self-dual integral
\(\mathbf Z[1/6]\)-lattice, a skew Rees arrow, and Rees weight can coexist
with a nonzero stationary \(D_5\) square.  Therefore none of those visible
data proves that the strict cubic Rees product has zero stationary projection.

This is not a quantum/Stokes counterexample.  It isolates the exact missing
analytic input: a strict, sectorially normalized selection rule which forces
the product through the \(A\)-clean sign/root object, or directly proves that
its \(D_5\) projection is zero.

## 1. The parity calculation

Let \(A=\mathbf Z[1/6]\).  At a Lefschetz nodal fibre of a cubic-surface
fibration, the primitive lattice has the Picard--Lefschetz decomposition

\[
 \Lambda=E_6(-1)\otimes A=M\oplus A\delta ,
 \qquad M=\delta^\perp\cap\Lambda\cong D_5(-1)\otimes A,
 \tag{1}
\]

where \(\delta^2=-2\), and the local monodromy \(\tau\) is

\[
 \tau|_M=1,\qquad \tau(\delta)=-\delta . \tag{2}
\]

Here (1) is integral over \(A\): projection along \(\delta\) only divides by
\(2\).

Suppose a local positive Rees arrow \(e\) has the natural sign character
\(\tau(e)=-e\), and its multiplication is Picard--Lefschetz equivariant.
Then

\[
 \tau(e^2)=\tau(e)^2=e^2. \tag{3}
\]

Thus a nonzero square is automatically stationary.  In particular, there is
no nonzero \(\tau\)-equivariant map

\[
 (A\delta)^{\otimes2}\longrightarrow A\delta, \tag{4}
\]

because the source is trivial and the target is sign.  Conversely,

\[
 \operatorname{Hom}_{\langle\tau\rangle}
 \bigl((A\delta)^{\otimes2},M\bigr)\cong M \tag{5}
\]

is nonzero.  Since \(2\) is a unit in \(A\), an additional theorem which
forced \(e^2\) into the sign line would indeed force \(e^2=0\).  But
Picard--Lefschetz equivariance itself forces no such target; it permits every
stationary target in \(M\).

If instead an arrow is strictly \(\tau\)-invariant, it already has a
stationary component before multiplication.  Hence neither possible local
character supplies the desired \(D_5\)-vanishing.

## 2. A filtered Frobenius algebra with a stationary square

Choose any nonzero \(m\in M\), for instance a \(D_5\) root, and define the
graded \(A\)-algebra

\[
 B=A\cdot1\oplus A e\oplus A m,\qquad
 \deg(1,e,m)=(0,1,2), \tag{6}
\]

with multiplication

\[
 e^2=m,\qquad em=0,\qquad m^2=0. \tag{7}
\]

Let \(\lambda:B\to A\) extract the coefficient of \(m\), and set

\[
 \langle x,y\rangle_B=\lambda(xy). \tag{8}
\]

In the ordered basis \((1,e,m)\), this pairing has matrix

\[
 \begin{pmatrix}
 0&0&1\\
 0&1&0\\
 1&0&0
 \end{pmatrix}, \tag{9}
\]

so it is a unimodular symmetric Frobenius pairing.  The Rees ideal

\[
 I=Ae\oplus Am \tag{10}
\]

satisfies

\[
 I^2=Am\ne0,\qquad I^3=0. \tag{11}
\]

The involution

\[
 \tau_B(1)=1,\qquad\tau_B(e)=-e,\qquad\tau_B(m)=m \tag{12}
\]

is an algebra isometry.  It is exactly the local sign/stationary
decomposition of (1): the arrow is sign, whereas its nonzero square is
labelled by the selected stationary \(D_5\) vector \(m\).

## 3. Adding the formal \(1/6\) monodromy and self-duality

The preceding algebra is not evading the formal-monodromy or pairing
constraints.  Let \(W=A^2\), with its standard unimodular alternating form

\[
 J=\begin{pmatrix}0&1\\-1&0\end{pmatrix}, \tag{13}
\]

and define

\[
 g=\begin{pmatrix}0&-1\\1&1\end{pmatrix},
 \qquad s=2g-1=
 \begin{pmatrix}-1&-2\\2&1\end{pmatrix}. \tag{14}
\]

Then \(g\in\operatorname{Sp}(W,J)\) has characteristic polynomial
\(z^2-z+1\), hence formal eigenvalues \(\zeta_6,\zeta_6^{-1}\);
\(s\) commutes with \(g\), is \(J\)-skew, and satisfies

\[
 s^2=-3\cdot1_W. \tag{15}
\]

On the self-dual \(A\)-lattice

\[
 H=B\otimes_AW,\qquad
 Q(b\otimes u,b'\otimes u')
 =\langle b,b'\rangle_B\,J(u,u'), \tag{16}
\]

put

\[
 M_{\mathrm f}=1_B\otimes g,\qquad
 N=\ell_e\otimes s,\qquad
 T=\tau_B\otimes1_W. \tag{17}
\]

The identities are immediate:

\[
 \begin{aligned}
 &M_{\mathrm f}\text{ preserves }Q,\quad [M_{\mathrm f},N]=0,\\
 &Q(Nx,y)+Q(x,Ny)=0,\quad TNT^{-1}=-N,\\
 &N^2=-3\,\ell_m\otimes1_W\ne0,\quad N^3=0.
 \end{aligned} \tag{18}
\]

Thus the model simultaneously has:

- a self-dual integral lattice, which can play the formal role of the visible
  Gamma lattice;
- formal monodromy with the cubic \(\pm1/6\) eigenvalues;
- a formal-monodromy-equivariant, pairing-skew Rees operator;
- a sign-equivariant Picard--Lefschetz arrow; and
- a nonzero stationary \(D_5\) square.

The factor \(-3\) is a unit in \(A\), so localization at \(1/6\) does not
weaken the obstruction.

The model is deliberately finite and formal.  It does not claim that
\(N\) is the quantum Rees operator or that \(B\) is an actual vanishing-cycle
algebra.  It proves that the listed structural constraints cannot establish
the needed vanishing.

## 4. Consequence for the cubic Lefschetz test

Let \(\mu_p\) denote the putative strict local multiplication at a nodal
fibre, and write

\[
 \operatorname{pr}_M\mu_p:
 I_p\otimes I_p\longrightarrow M \tag{19}
\]

for its stationary primitive projection.  The formal model has

\[
 \operatorname{pr}_M\mu_p(e,e)=m\ne0. \tag{20}
\]

Therefore the following data do not prove
\(\operatorname{pr}_M\mu_p=0\):

1. local Picard--Lefschetz monodromy;
2. the Rees/weight degree of the product;
3. formal \(1/6\) monodromy;
4. a self-dual \(\mathbf Z[1/6]\)-lattice and pairing; or
5. skewness of the Rees operator.

The minimal positive input is one of the following strictly stronger
statements.

1. **Clean-root product factorization.**  The product factors through the
   sign local system \(A\delta\) with its clean extension
   \(Rj_!(A\delta)=Rj_*(A\delta)\).  Then (3)--(4) force it to vanish.
2. **Stationary-projection theorem.**  The sectorially normalized
   Stokes/Gamma multiplication has zero projection (19).  This is the exact
   local analytic statement needed for the cubic Lefschetz pencil.
3. **Primitive direct-image factorization with product support.**  The two
   arrows factor through a functorial vanishing-root summand, and their
   composite factors through its zero stalk/costalk rather than through the
   stationary summand of the full primitive direct image.

The ordinary primitive sheaf proves none of these: at a nodal cubic fibre it
contains the nonzero stationary \(D_5\) stalk and costalk described in
the prior del Pezzo primitive-monodromy obstruction note.

## EJ/TT and mystery ledger

- **EJ:** the local test is exactly \(\operatorname{pr}_M\mu_p\), not an
  abstract monodromy or duality condition.  If it vanishes, the clean sign
  calculation closes the remaining same-point product.
- **TT:** a sign arrow does not have a sign square.  Picard--Lefschetz
  parity sends its square into the stationary sector, which is precisely the
  sector the direct-image sheaf leaves alive.
- **Settled:** monodromy equivariance, weight, formal cubic monodromy, and a
  Gamma-like self-dual lattice leave a nonzero \(D_5\) square possible.
- **Open:** construct the strict local Stokes/Gamma multiplication for the
  cubic Lefschetz pencil and compute its stationary projection.
