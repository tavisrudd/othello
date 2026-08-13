# C907 del Pezzo primitive sheaf: the finite-discriminant obstruction

**Lane:** `clebsch`

**Status:** theorem-grade negative result for the proposed
finite-discriminant primitive-sheaf argument.  A zero-dimensional
discriminant does not force the strict cubic-isotypic Rees ideal to be square
zero.  A nodal cubic-surface fibre has a large stationary primitive summand at
the discriminant point, with nonzero stalk and costalk.  The vanishing-root
summand is clean after inverting \(6\), but the stationary summand permits a
same-point product.  A square-zero theorem needs an additional strict
root-targeting/factorization statement.

This is not a counterexample to the desired C907 carrier bound: no
Stokes/Gamma comparison with the sheaf below is presently available.  It is a
counterexample to deriving that bound from the dimension of the discriminant
or from the primitive direct image alone.

## 1. The actual smooth terminal test family

Let \(X\subset\mathbf P^4\) be a smooth cubic threefold and take a Lefschetz
pencil of hyperplane sections.  Its base is a smooth plane cubic
\(\Gamma\).  Blowing up the base gives


\[
 f:\widetilde X=\operatorname{Bl}_{\Gamma}X\longrightarrow\mathbf P^1.
 \tag{1}
\]

The total space is smooth (therefore terminal), the discriminant \(D\) is
finite, and every Lefschetz critical fibre has one \(A_1\) singularity.  The
fibre is still a degree-three del Pezzo surface: blowing up the Cartier base
curve in a member of the pencil changes no fibre.  This is the terminal
degree-three Mori fibration already used in
`2026-08-12-c907-mori-fibre-carrier-regression.md`.

Put \(A=\mathbf Z[1/6]\), let \(h=c_1(\mathcal O_{\mathbf P^3}(1))\) on a
cubic-surface fibre, and set

\[
 \mathcal P_f=\operatorname{coker}
 \bigl(A_{\mathbf P^1}\,h\longrightarrow R^2f_*A\bigr).
 \tag{2}
\]

Since \(h^2=3\in A^\times\), this is equivalently the primitive summand.
At a smooth cubic surface \(S\),

\[
 H^2(S,A)=Ah\oplus L,\qquad L\cong E_6(-1)\otimes A,
 \tag{3}
\]

so \(\mathcal P_f\) has rank six over the complement of \(D\).

## 2. One nodal fibre: stalk, costalk, and the clean root

Fix \(p\in D\), write \(j:\Delta^*\hookrightarrow\Delta\) for a small
analytic disk around it, and let \(\delta\in L\) be the vanishing root.  The
local total-space equation is analytically

\[
 z_1^2+z_2^2+z_3^2=t,
 \tag{4}
\]

and Picard--Lefschetz gives

\[
 T(x)=x+(x,\delta)\delta,\qquad \delta^2=-2.\tag{5}
\]

Thus \(T(\delta)=-\delta\).  As \(2\in A^\times\), the orthogonal
projection along \(\delta\) is integral over \(A\), giving the exact
monodromy decomposition

\[
 L=M\oplus A\delta,
 \qquad M=\delta^\perp\cap L,
 \qquad T|_M=1,\quad T|_{A\delta}=-1.\tag{6}
\]

Here \(M\) has rank five; its root system is \(D_5\).  Topologically the
nodal surface is obtained by collapsing the vanishing two-sphere.  Hence
specialization identifies its \(H^2\) with the invariant lattice, and after
removing \(h\) one gets

\[
 (\mathcal P_f)_p\cong M\cong L^T.\tag{7}
\]

This is the crucial contrast with the conic double line: the nodal cubic
surface has a nonzero primitive stalk.

There is an equally important costalk statement.  The sign local system on
\(A\delta\) is clean because \(T-1=-2\) is a unit.  Consequently

\[
 Rj_*(A\delta)=j_!(A\delta),\qquad
 \mathcal P_f|_\Delta\cong M_\Delta\oplus j_!(A\delta).\tag{8}
\]

In the constructible derived category,

\[
 i^*\mathcal P_f=M,
 \qquad i^!\mathcal P_f=M[-2],\qquad i:\{p\}\hookrightarrow\Delta.
 \tag{9}
\]

The sign factor has zero stalk **and** zero costalk; the stationary factor has
both.  Equation (9), not merely (7), is what rules out an argument that a
point-supported composition must vanish by a stalk/costalk convention.

For comparison, the derived clean test for an arbitrary primitive local
system \(V\) on \(\Delta^*\) is

\[
 Rj_*V=j_!V
 \quad\Longleftrightarrow\quad T-1:V\xrightarrow{\sim}V
 \text{ over }A.\tag{10}
\]

Indeed the stalk complex of \(Rj_*V\) is
\([V\xrightarrow{T-1}V]\).  Vanishing of its rational invariants is not
enough over \(A\): its coinvariants must vanish as well.

## 3. Why a finite support does not make the ideal square-zero

Suppose a future strict Rees realization assigns a positive ideal \(I\) to a
del Pezzo fibration and its product is support-local.  Finiteness of \(D\)
then only implies

\[
 I_pI_q=0\quad(p\ne q).\tag{11}
\]

It says nothing about \(I_p^2\).  In the actual local model above, a product
at \(p\) can land in \(M\), which is nonzero in both senses in (9).  This is
not merely an abstract vector-space loophole: \(D_5\subset M\) contains a
root \(r\), and on the nodal cubic surface its intersection product is

\[
 r\smile r=-2[\mathrm{pt}]\ne0\quad\text{in }H^4(S_p,A).\tag{12}
\]

Thus the primitive geometry itself has room for a nonzero same-point
composition.  More minimally, the filtered algebra

\[
 A[\varepsilon]/(\varepsilon^3),\qquad I=(\varepsilon),\qquad
 I^2=A\varepsilon^2\ne0,\tag{13}
\]

can be supported at this one point and labelled by any nonzero line in \(M\).
It satisfies every conclusion obtainable from zero-dimensional support alone.
It is a countermodel to the proposed *formal implication*, not an assertion
that (13) is a quantum/Stokes packet.

Consequently, the smooth terminal fibration (1) refutes the hoped-for
primitive-sheaf proof in its strongest naive form:

> A zero-dimensional discriminant or support does **not** force
> \(I_{1/6}^2=0\).

It may still be true for the C907 Rees ideal for a separate analytic reason.

## 4. The exact extra hypothesis that would prove square-zero

The conic argument has a valid del Pezzo analogue only under all of the
following additional hypotheses.

1. **Clean root targeting.**  At every \(p\in D\), the positive local Rees
   arrow factors through a monodromy subobject \(V_p\) for which
   \(T_p-1\) is an \(A\)-isomorphism.  In the one-node cubic case this means
   the arrow is forced into the sign/root summand \(A\delta\), not merely
   into the full primitive sheaf.
2. **Strict point factorization.**  A product of two arrows with support
   \(p\) factors through the stalk or costalk of the clean object
   \(Rj_*V_p=j_!V_p\).  Those targets vanish by (10).
3. **Support locality.**  Products of arrows based at distinct points vanish,
   as in (11), and no horizontal primitive summand enters the product.
4. **Integral comparison.**  The comparison is over \(A=\mathbf Z[1/6]\)
   and respects the Stokes filtration, Rees product, and Gamma lattice; a
   rational comparison alone cannot eliminate residual torsion.

Under (1)--(4), every same-point product and every different-point product is
zero, hence \(I_{1/6}^2=0\).  This is a genuine conditional square-zero
theorem.  The present primitive direct image establishes none of its
root-targeting clause for C907.

Equivalently, for the nodal cubic model it would suffice to prove directly
that the strict Rees multiplication has zero projection to the stationary
\(D_5\) summand \(M\).  That is the smallest missing datum.

## 5. A second integral obstruction: ADE torsion

Even when the primitive local system has no stationary complement, rational
cleanness need not be integral cleanness.  For an \(A_n\) surface singularity
the vanishing-lattice monodromy is a Coxeter element \(c\), and

\[
 \det(1-c)=n+1.\tag{14}
\]

It has no rational fixed vector, but \(1-c\) fails to be an isomorphism over
\(A\) whenever \(n+1\) has a prime factor other than \(2\) or \(3\).  For an
\(A_4\) fibre, for example,

\[
 \operatorname{coker}(1-c)\cong A/5A\ne0.\tag{15}
\]

So the local derived direct image retains a five-primary point contribution.
This is an independent obstruction to using a rational vanishing-cycle
argument for the \(1/6\)-localized Gamma lattice.  It disappears only after
proving that the relevant singularities and monodromies satisfy (10), or
after a separate strict argument annihilates this torsion.

## 6. Scope and conclusion

The calculation assumes a smooth-total-space, Gorenstein, one-parameter
Lefschetz cubic-surface fibration.  This lies inside the requested
terminal/smooth Mori-fibre class, so it is already sufficient to disprove a
universal finite-discriminant implication.  More singular terminal models
require an additional nearby-cycle comparison; they cannot improve the
conclusion without excluding the smooth example.

The surviving del Pezzo carrier target is therefore precise:

\[
 \text{strict Rees multiplication has zero stationary-primitive projection}
 \quad\text{and}\quad
 \text{the remaining local monodromy is \(A\)-clean}.\tag{16}
\]

Neither a finite discriminant, a zero-dimensional support, nor a
semiorthogonal block count supplies (16).

## EJ/TT and mystery ledger

- **EJ:** the nodal cubic model reduces the entire del Pezzo branch to one
  testable local map: the projection of the strict Stokes/Gamma product to
  the stationary \(D_5\) lattice.  A proof that this map is zero would leave
  only the clean-root argument.
- **TT:** the useful dichotomy is not smooth versus singular fibre but
  stationary versus \(A\)-clean monodromy.  This also exposes the otherwise
  hidden five-primary \(A_4\) obstruction.
- **Settled:** finite discriminant alone cannot force square-zero, even for a
  smooth terminal degree-three Mori fibration; both stalk and costalk at a
  nodal fibre can be nonzero.
- **Open:** construct the strict Stokes/Gamma realization and prove its
  stationary-primitive projection vanishes, or compute it on the cubic
  Lefschetz pencil and obtain a genuine counterexample to the C907 carrier
  bound.
