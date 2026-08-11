# C904: primitive theta support and the exact \(D_{3,3}\) gate

Date: 2026-08-10
Status: quarantined Paper V research; no manuscript or Lean promotion
Scope: the unordered theta fibre, primitive one-cycles supported on theta,
Fano-surface carriers, and the rank-three theta resolution

> **Superseded fixed-fibre checkpoint.**  The parity and no-go theorems below
> remain valid, but the executive conclusion predates the common-line
> unordered lift in
> `notes/2026-08-10-c904-common-line-unordered-shen-route.md`.  The
> fixed-fibre support/index ambiguity is now closed positively: the
> degree-two Shen lift and Beauville's exceptional degree-five lift combine
> by `3*2-5=1` on `Sym^2 F subset Sym^2 Theta`.  Do not route the older
> “sole live intrinsic class/index-two” conclusion forward.  The surviving
> gate is relative horizontality of the minimal curve on `D_+` (and the
> centered lift needed for the literal relative Bezout identity), or an
> exact descent obstruction/minimal base change.

## Executive verdict

Let \((J,\Theta)\) be a marked \(A_5\)-intermediate Jacobian in the C904
pencil and put

\[
 c=\frac{\Theta^4}{4!}\in CH^4(J).
\]

C904 already proves that \(c\) is the cohomology class of an algebraic
signed one-cycle.  The remaining \(D_{3,3}\) question has now been reduced
to one exact support coset, whose *cohomological* ambient shadow has order
two.

For the generic \(a\in J\), set

\[
 Z_a=\Theta\cap(a-\Theta),\qquad
 Y_a=Z_a/(x\mapsto a-x).
\]

Then

\[
                         \operatorname{ind}(Y_a)\in\{1,2\},
\]

and Voisin's \(D_{3,3}\) carrier has an odd generic zero-cycle if and only
if \(\operatorname{ind}(Y_a)=1\).  An integral signed one-cycle
\(\gamma\) on \(\Theta\) satisfying

\[
                         i_*\gamma=c
\]

would settle this positively: the honest quotient cycle

\[
          \delta=q_*(\gamma\times[\Theta])
          \in CH^3(\operatorname{Sym}^2\Theta)
\]

has generic degree five.  There is no division by two in this construction.
Its pullback is the two-coordinate orbit sum, of ordered degree ten, and the
degree-two quotient returns degree five.

The exact algebraic Hodge-lattice calculation gives the conceptual parity
theorem

\[
 \frac{\operatorname{Hdg}^8(J,\mathbf Z)}
      {\Theta\operatorname{Hdg}^6(J,\mathbf Z)}\cong\mathbf Z/2,
 \qquad [c]\text{ generates}.
\]

Every class in both Hodge lattices is algebraic on the marked pencil.  Thus
\(2c\), but not \(c\), is the cohomology class of a cycle supported on
\(\Theta\) by an *ambient divisor cube*.  Choose a minimal algebraic cycle
\(\Gamma_c\) on \(J\), put \(U=J\setminus\Theta\), and write

\[
             \beta:=[\Gamma_c|_U]\in CH^4(U).
\]

Then the cycle class of \(2\beta\) vanishes, but the lattice computation
alone does **not** prove \(2\beta=0\) in integral Chow.  O'Sullivan's theorem
identifies symmetric-divisor expressions only with rational coefficients;
an integral torsion or Griffiths correction remains possible.  The desired
exact Chow support of \(\Gamma_c\) exists exactly when \(\beta=0\).  A
theta cycle with the right cohomology class is a weaker sufficient condition
for the degree argument.  Affineness and the vanishing of high singular
cohomology on \(U\) do not imply either Chow-theoretic statement.

Three attractive geometric attempts fail uniformly:

1. the entire descended divisor-triple algebra on
   \(\operatorname{Sym}^2\Theta\) has degree ideal \(8\mathbf Z\);
2. every curve in a translate of the Fano surface has even theta degree;
3. every natural genus-two difference surface \(B_g\subset\Theta\) has
   restricted polarization type \((2,2)\), hence all its curves have even
   theta degree.  The two \(D_5\)-axis elliptics attached to \(g\) are in the
   plus eigenspace and cannot lie in \(B_g\).

The larger mixed Fano construction also fails: for every divisor
\(D\in NS(F\times F)\), including all 25 cross-Hom directions and the
intrinsic half-theta incidence classes, the map
\((a,b,c)\mapsto a+b-c\) on \(F\times D\) has degree in
\(12\mathbf Z\).

The resolution \(M\simeq\operatorname{Bl}_0\Theta\) as a rank-three sheaf
moduli space removes two technical obstructions but not the last one.  The
moduli problem is fine, the required off-diagonal
\(\operatorname{Ext}^2\)-vanishing holds, and the integral top-Chern
diagonal formula is available.  What is still missing
is an *algebraic* factorization of the odd \(H^3(X)\)-Kunneth contribution,
or an explicit tautological curve of odd theta degree.  Markman's rational
surface theorem does not supply that step for a cubic threefold.

The honest conclusion is therefore sharp but not positive or negative:

> The \(D_{3,3}\) gate is the vanishing of one explicit support coset
> \(\beta\in CH^4(J\setminus\Theta)\), whose ambient cohomological shadow is
> the unique nonzero class of order two.  All ambient, Picard-generated,
> Fano-translate, and genus-two anti-invariant carriers retain the factor
> two.  A signed intrinsic theta cycle could still kill it.

## 1. The generic unordered theta fibre

Let

\[
 m:\Theta\times\Theta\longrightarrow J,
 \qquad (x,y)\longmapsto x+y,
\]

and let \(q:\Theta\times\Theta\to\operatorname{Sym}^2\Theta\).  The
generic ordered fibre over \(K=k(J)\) is

\[
 Z=\{x\in\Theta:a-x\in\Theta\}
   =\Theta\cap(a-\Theta).
\]

The transposition becomes \(x\mapsto a-x\).  A fixed point would satisfy
\(2x=a\); its image is contained in the proper divisor \([2](\Theta)\).
Thus the generic involution is free and \(Z\to Y\) is etale of degree two.
Voisin's isolated-singularity argument shows that the general ordered
intersection is smooth.

An existing degree-two algebraic cut on \(Z\), followed by transfer through
the quotient, gives

\[
                         \operatorname{ind}(Y)\mid2.
\]

The branch diagonal has codimension four in \(\Theta\times\Theta\), so it
is invisible to \(CH^3\).  Integral descent is equivariant Chow descent,
not mere invariance of a Chow class.  Nakaoka--Gugnin also gives no
cohomological factor two in total degree six: the torsion-free pullback
lattice is the saturated swap-invariant lattice in that degree.  Hence a
genuine orbit-stable algebraic cycle of upstairs degree two is allowed to
descend to degree one.  Formal quotient topology neither produces such a
cycle nor forbids it.

This corrects the discarded draft argument that called the coordinate
transfer primitive and therefore non-halvable.  The relevant Nakaoka
factorial-two generator is \(2b\otimes b\) for an even-degree repeated
class.  An equal split in total degree six is \(3+3\), where the Koszul sign
is odd; it does not impose that factor.

## 2. The \(D_{3,3}\) relay is exactly equivalent to index one

Voisin's divisor \(D_{3,3}\) parametrizes unions of two rational cubic
curves meeting in two points.  Their Abel--Jacobi values define a dominant
map

\[
                  D_{3,3}\dashrightarrow\operatorname{Sym}^2\Theta.
\]

Over a generic unordered pair its fibre is birational to
\(\operatorname{Sym}^2(E_3)\), where \(E_3\) is a smooth plane cubic.  The
plane polarization gives a degree-three zero-cycle on \(E_3\), and the Abel
map

\[
 \operatorname{Sym}^2(E_3)\longrightarrow\operatorname{Pic}^2(E_3)
\]

has projective-line fibres.  Consequently

\[
                \operatorname{ind}(\operatorname{Sym}^2(E_3))\mid3.
\]

Let \(T\) be a smooth proper model of the generic \(D_{3,3}\)-fibre over
\(J\).  A degree-one zero-cycle on \(Y\) lifts through odd-degree fibre
cycles to an odd zero-cycle on \(T\).  Conversely an odd cycle on \(T\)
pushes to an odd cycle on \(Y\); since \(\operatorname{ind}(Y)\mid2\), this
forces index one.  Therefore

\[
 T\text{ has an odd zero-cycle}
 \quad\Longleftrightarrow\quad
 \operatorname{ind}(Y)=1.
\]

An odd cycle on \(T\) then pushes to Voisin's charge-three fourfold over
\(J\).  The converse for the whole fourfold is not claimed: an intrinsic odd
point could lie outside the \(D_{3,3}\) image.

## 3. A primitive theta cycle gives degree five downstairs

Let \(i:\Theta\hookrightarrow J\).  Suppose that an integral signed
one-cycle \(\gamma\in CH^3(\Theta)\) satisfies
\(i_*\operatorname{cl}(\gamma)=c\).  Define

\[
 \delta=q_*(\gamma\times[\Theta])
       \in CH^3(\operatorname{Sym}^2\Theta).
\]

This is an integral pushforward, with no descent choice.  Away from the
codimension-four diagonal,

\[
 q^*\delta=gamma\times[\Theta]+[\Theta]\times\gamma.
\]

Each coordinate term has ordered addition degree

\[
             \int_J\Theta\,i_*\gamma
             =\int_J\frac{\Theta^5}{4!}=5.
\]

Thus \(q^*\delta\) has ordered degree ten.  Since \(q\) has degree two over
the generic fibre, \(\delta\) has degree five on \(Y\).  The same argument
works for any odd multiple of \(c\), or more generally for any theta cycle
whose pushforward has odd theta degree.

This is the cleanest surviving positive gate.  It also explains why a
signed cycle is enough: effectivity is never used in the pushforward or the
degree computation.

## 4. The uniform ambient index theorem

The exact exotic principal lattice has Neron--Severi rank fifteen.  Its
divisor cubes span and saturate the full rank-fifty integral Hodge lattice in
degree six.  Multiply all 680 unordered divisor cubes by \(\Theta\), and
compare the resulting rank-fifteen lattice with the saturated degree-eight
Hodge lattice generated by divisor fourth powers.  Smith reduction gives

\[
 \operatorname{Hdg}^8(J,\mathbf Z)/
 \Theta\operatorname{Hdg}^6(J,\mathbf Z)
          \cong\mathbf Z/2.
\]

The class \(c\) is not in the theta image and \(2c\) is.  This is stronger
than a parity census: it proves that *every* ambient algebraic support
construction has the same single obstruction, and that no other finite
factor is hidden in the full Hodge lattice.

Because C904 proves all the relevant Hodge classes algebraic, there is an
algebraic \(z\in CH^3(J)\) whose theta intersection has cohomology class
\(2c\).  Localization for \(U=J\setminus\Theta\) gives

\[
 CH^3(\Theta)\xrightarrow{i_*}CH^4(J)
      \longrightarrow CH^4(U)\longrightarrow0,
 \qquad \beta=[\Gamma_c|_U].
\]

The cohomology class of \(2\Gamma_c-i_*(i^*z)\) is zero, so \(2\beta\) is
homologically trivial.  It need not vanish in integral Chow.  Even if all
divisors are chosen symmetric, O'Sullivan's distinguished-cycle theorem
only upgrades the equality in \(CH^4(J)_{\mathbf Q}\); it does not control
integral torsion.  Thus the exact equivalence is simply

\[
 \beta=0
 \quad\Longleftrightarrow\quad
 \text{there is }\gamma\in CH^3(\Theta)\text{ with }i_*\gamma=\Gamma_c
 \text{ in }CH^4(J).
\]

For the degree-five construction it is enough to ask for the weaker
cohomological equality \(i_*\operatorname{cl}(\gamma)=c\).  The Chow
support equality is a natural sufficient formulation, but not logically
necessary for the generic-degree argument.

At the level of algebraic Hodge classes, any odd theta-degree support class
represents the nonzero coset \([c]\); subtracting an ambient theta multiple
reduces it to the same primitive *cohomological* support problem.  This is
the promised uniform conceptual index theorem.  It must not be promoted to
an integral Chow quotient theorem without separately killing the
homologically trivial correction.

## 5. Why the primitive class must be intrinsic to theta

For a smooth theta divisor \(D\) in a principally polarized fivefold, weak
Lefschetz and Poincare duality identify the Gysin map

\[
                   H^6(D,\mathbf Z)\longrightarrow H^8(J,\mathbf Z)
\]

with an integral isomorphism on the relevant primitive target.  Thus the
minimal class has a unique integral topological support lift.  It is not the
restriction of an ambient class.

The nonambient defect is elementary and exact.  Choose five symplectic
pairs \(p_i=e_i\wedge f_i\), so \(\Theta=\sum p_i\) and

\[
 c=\sum_{|I|=4}p_I.
\]

Modulo two, the functional that sums the five coefficients of the
four-pair monomials annihilates \(\Theta\wedge H^6(J,\mathbf F_2)\): each
triple-pair coefficient occurs in two four-pair supersets.  It takes value
one on \(c\).  Hence \(c\notin\Theta H^6(J,\mathbf Z)\).  Conversely, take
the five triple-pair monomials complementary to the edges of a five-cycle;
their sum wedges with \(\Theta\) to \(2c\).  The exact matrix audit gives
rank \(44/45\) modulo two.

This smooth calculation is a topological model for the same \(\mathbf Z/2\)
found in the marked algebraic Hodge lattice.  It is not being used to assert
smoothness of the cubic theta divisor, whose singularity is resolved in
Section 8.

There is also a useful effective obstruction.  An effective curve of
minimal class in an indecomposable principally polarized abelian variety
forces the ppav to be a Jacobian, by the Matsusaka--Ran criterion.  The
cubic-threefold intermediate Jacobian is not a Jacobian.  Therefore the
needed theta carrier, if it exists, must be a signed algebraic one-cycle;
searching for a single effective minimal curve is impossible from the
outset.

## 6. Visible theta carriers all retain evenness

### 6.1 The complete divisor-triple subalgebra

On \(J\times J\), the swap-invariant Neron--Severi lattice has rank thirty:
fifteen equal diagonal blocks and fifteen symmetric cross/Poincare blocks.
The exact script evaluates all \(\binom{32}{3}=4960\) triple products on
\(\Theta\times\Theta\) against the addition fibre.  Ordered degrees are
divided by two only after passing to the quotient.  The resulting downstairs
degree ideal is

\[
                              8\mathbf Z.
\]

This exhausts the divisor-generated codimension-three algebra, not all of
\(CH^3(\operatorname{Sym}^2\Theta)\).  It is a strong no-go for Picard-only
constructions and nothing more.

### 6.2 Curves on a Fano translate

For the Abel--Jacobi embedding \(F\hookrightarrow J\), the restriction of
the principal polarization is numerically

\[
                         \Theta|_F=2C_s,
\]

where \(C_s\) is an incidence divisor.  Hence every curve in every translate
of \(F\) has even theta degree.  Roulleau's genus-two curve satisfies
\(C_sD_g=2\), so its theta degree is four; an incidence curve has theta
degree ten.  No curve lying in a single Fano translate can be the odd
carrier.

### 6.3 The genus-two difference surface

For a harmonic involution \(g\), Roulleau constructs a smooth genus-two
curve \(D_g\subset F\).  Its cotangent line is the projectivization of the
two-dimensional minus eigenspace of \(g\) on \(H^0(\Omega_F)^*\).  Therefore
the image

\[
 B_g=\operatorname{im}(J(D_g)\to J)=D_g-D_g
\]

is the connected anti-invariant abelian surface.  The classical difference
description \(F-F=\Theta\) puts \(B_g\) inside \(\Theta\).

The exact integral homology calculation was performed for all fifteen
involutions in the actual exotic principal lattice.  The saturated
anti-invariant lattice always has rank four, and the restricted principal
symplectic form has elementary divisors

\[
                              (2,2).
\]

Thus \(\Theta|_{B_g}=2\Xi_g\) for a principal polarization \(\Xi_g\), and
every curve in \(B_g\) has even theta degree.

Each involution lies in two \(D_5\) subgroups.  The tangent line of the
associated \(D_5\)-axis elliptic is fixed by that subgroup, hence is a plus
line for \(g\).  Since \(T_0B_g\) is the minus eigenspace, neither axis
elliptic can lie in \(B_g\).  This rules out the proposed containment before
any polarization calculation.

### 6.4 The full \(F\times D\) middle channel

Fix \(p\in F\).  The two theta components

\[
                        F-p\subset\Theta,
 \qquad F-F=\Theta
\]

turn any divisor \(D\subset F\times F\) into a fivefold
\(F\times D\) mapping to \(J\) by

\[
                         (a,b,c)\longmapsto a+b-c.
\]

Up to the harmless translation by \(p\), its degree is

\[
 \int_{F^3}p_{23}^*[D]\,(a+b-c)^*[0].
\]

The full product Neron--Severi lattice is

\[
 NS(F\times F)=p_1^*NS(F)\oplus p_2^*NS(F)
     \oplus\operatorname{Hom}(\operatorname{Alb}F,\operatorname{Pic}^0F),
\]

of rank \(15+15+25=55\).  The restriction of \(NS(J)\) to \(F\) has
index two in its saturation; the missing generator is
\(C_s=\Theta|_F/2\).  The exact exterior-algebra calculation uses
\([F]=\Theta^3/3!\), both half-theta generators, and the complete integral
cross-Hom order.  It gives

\[
\begin{array}{c|c}
\text{part of the lattice}&\text{degree ideal}\\ \hline
NS(J)|_F\text{ on either diagonal}&24\mathbf Z\\
\text{all 25 cross-Hom divisors}&24\mathbf Z\\
\text{full saturation after }C_s&12\mathbf Z.
\end{array}
\]

In particular no cross-Poincare divisor escapes parity.  This closes the
mixed surface/threefold divisor carrier, not the non-divisor-generated
group \(CH_1(F\times F)\).

## 7. The localization shortcut does not close the gate

The complement \(U=J\setminus\Theta\) is affine of complex dimension five.
Andreotti--Frankel implies that it has the homotopy type of a CW complex of
real dimension at most five, so the singular cycle class of
\(\beta\in CH^4(U)\) vanishes automatically.  This supplies no Chow
injectivity.

The familiar torsion Abel--Jacobi injectivity theorems concern codimension
two.  Here the class has codimension four, and the motivic degree lies beyond
the range where Beilinson--Lichtenbaum comparison with etale cohomology is an
isomorphism.  No primary source found in the bounded audit proves

\[
                         CH^4(J\setminus\Theta)[2]=0.
\]

Thus topology explains why \(\beta\) is invisible, not why it vanishes.
Nor does the Hodge-lattice factor two make \(\beta\) two-torsion in integral
Chow.  This route is an exact reformulation of the problem rather than a
solution.

## 8. The theta resolution removes two gates, not the algebraicity gate

Bayer--Beentjes--Feyzbakhsh--Hein--Martinelli--Rezaee--Schmidt identify

\[
 M=M_X(v)\simeq\operatorname{Bl}_0\Theta,
 \qquad
 v=(3,-H,-H^2/2,H^3/6),
\]

as a smooth four-dimensional moduli space; its exceptional divisor is the
cubic threefold \(X\).

Two useful checks succeed.

First, on a cubic threefold

\[
 \operatorname{td}(X)=1+H+\frac23H^2+\frac13H^3,
 \qquad H^3=3.
\]

The Euler weights \(\chi(v\otimes\mathcal O_X(k))\) for
\(k=-2,-1,0,1,2\) are

\[
                         -3,0,0,6,27.
\]

Line bundles alone therefore see weight gcd three.  They are not the full
determinant-weight lattice: a point and a line have weights three and two,
respectively.  Their difference has weight one.  Hence the moduli problem is
fine and admits a universal sheaf; there is no gerbe obstruction at any
prime.

Second, for any two objects \(E,F\in M\), the stability estimates used in
the paper give

\[
 \operatorname{Ext}^2(E,F)
 =\operatorname{Hom}(F,E(-2H)[1])^*=0,
\]

because \(F\) has tilt slope zero while \(E(-2H)[1]\) has slope
\(-1/2\).  The same slope argument kills \(\operatorname{Ext}^3\).
Off the diagonal stability also gives \(\operatorname{Hom}(E,F)=0\).
Thus the relative Hom complex has the expected two-term degeneracy exactly
along the diagonal, and the usual top-Chern diagonal formula is available
integrally.

There is an independent integral description of the remaining factor two.
Let \(a\in H_2(M,\mathbf Z)\) be the unique lift of \(c\) orthogonal to the
exceptional divisor, and let \(\ell\) be a line in the exceptional cubic.
The strict transform \(z\) of a translated Fano incidence curve has

\[
                         z=2a-\ell,
 \qquad\text{hence}\qquad 2a=z+\ell.
\]

Both \(z\) and \(\ell\) are algebraic.  This proves that the obvious
tautological lattice has index two in the primitive direction, but it does
not divide that Chow relation by two.

The integral-Fourier construction does not improve the scalar.  Beckmann--de
Gaay Fortman's Proposition 3.11, applied to the algebraic minimal class,
starts with

\[
 \tau=j_{1,*}Z+j_{2,*}Z-\Delta_*Z,
 \qquad [\tau]=\frac{P^9}{9!}
\]

for \(g=5\).  The sign is positive.  In the Pontryagin PD algebra, the
codimension-three part of \(-E(-\tau)\) is

\[
                         S=\tau^{[7]},
 \qquad [S]=\frac{P^3}{3!}.
\]

Pulling \(S\) back along \(a\times a:F\times F\to J\times J\) gives an
integral codimension-three cycle.  However, for
\(\alpha,\beta\in H^1(F)\), exact exterior algebra gives

\[
 \int_{F\times F}\alpha_1\beta_2\frac{P^3}{3!}
 =4\langle\alpha,\beta\rangle_\Theta.
\]

Consequently, composing this cycle with the two universal-line incidence
correspondences acts as \(\pm4\operatorname{Id}\) on \(H^3(X)\), not as the
identity.  The factor is \(g-1=4\), coming from the two insertions
\([F]=\Theta^3/3!\).  It therefore does not beat the existing factor two.

There is also a relative caveat.  Moonen--Polishchuk prove the canonical
Pontryagin PD structure for a monoid scheme over a field.  Over the marked
curve base, relative symmetric powers of flat components construct the same
divided powers after shrinking, but extension through bad fibres is not a
stated consequence of their theorem.  This boundary issue is moot for the
identity goal because the fibrewise scalar is already four.

This still does **not** prove the integral Hodge conjecture for curves on
\(M\) at the prime two.  Markman's theorem constructs topological universal
K-classes and integral cohomology generators for moduli on Poisson
*surfaces*.  His Chow decomposition result assumes a rational source
surface.  A cubic threefold has the odd middle group \(H^3(X)\), and the
corresponding Kunneth components of the universal class are precisely the
part not separated by algebraic projectors.  An algebraic diagonal on
\(M\times M\) does not by itself make those individual factors algebraic.

The remaining moduli-theoretic gate is therefore concrete:

- algebraically factor the contracted pair of odd \(H^3(X)\)-components in
  the diagonal formula; or
- exhibit a tautological curve on \(M\) whose pushforward to \(\Theta\) has
  odd theta degree.

The Picard-bundle construction of
Engel--de Gaay Fortman--Schreieder does not provide this.  Their Lemma 2.9
starts with a curve already representing a prime-to-\(\ell\) multiple of the
minimal class and builds the bundle from it.  Using it here to produce the
primitive theta carrier would be circular, and the resulting bundle lives
on \(J\), not as a support lift on \(\Theta\).

### 8.1 The relative finite-component refinement

For the relative Paper V goal one does not need an odd point over the
generic point of all of \(J\).  The fixed integral divisor identity for
\(c\) has finitely many relative complete-intersection components
\(S_i\); after shrinking the marked curve base, each \(S_i\) is a surface
fibred by curves.  It would suffice to give an odd zero-cycle on the pullback
of \(M_9\to J\) over every field \(k(S_i)\).

This is a genuine weakening, but it is not automatic.  The generic point of
each movable component can be kept in the open where the \(M_9\)-fibre is
rationally connected.  Graber--Harris--Starr then gives a section after
restricting to each *fixed complex curve* \((S_i)_b\).  It does not give a
section over the function field of the total complex surface \(S_i\).
That would require a two-stage section-space theorem or rational simple
connectedness of the fourfold fibre, neither of which is established for
this moduli space.

The known compactified Hecke construction base-changes to the generic point
of every such \(S_i\) and gives index dividing two.  Determining oddness is
therefore a finite list of \(1\)-versus-\(2\) tests.  The existing nonzero
charge-two residue makes these tests completely explicit.  Let
\(D=F+F\subset J\) be the strictly semistable boundary and let
\(C_i=S_i\cap D\).  At every component of \(C_i\), the residue of the
restricted conic is the base change of

\[
                 F\times F\longrightarrow\operatorname{Sym}^2F
\]

along the map sending an unordered pair of lines to its sum in \(D\).
Thus one nontrivial ordered-pair double cover over a component of \(C_i\)
certifies index two on \(k(S_i)\).  To make the charge-two conic split, all
these covers must split and the remaining unramified Brauer class must also
vanish.  The exact divisor identity has not yet been expanded far enough to
compute those finitely many covers.  Likewise, the charge-three
\(D_{3,3}\) model replaces the problem by the unordered-theta index on
\(S_i\); it does not furnish an odd section formally.

The exact divisor relation cannot be moved wholesale into either currently
known explicit odd locus.  Putting every component in \(\Theta\) would
solve the primitive theta-support problem already ruled out for ambient
divisor cubes, and putting it in the visible Fano/genus-two carriers retains
the even degree theorems of Section 6.  Thus the finite-component
refinement is the best next geometric gate, but not a completed bypass.

## 9. Strongest honest theorem and proof spine

The current package can be stated as follows.

> **Theta-support reduction theorem.**  On the marked \(A_5\) cubic pencil,
> the full ambient algebraic Hodge quotient in curve degree is
> \(\mathbf Z/2\), generated by the minimal class \(c\).  The class \(2c\)
> is the cohomology class of a one-cycle supported on \(\Theta\).  A chosen
> minimal algebraic cycle is supported on \(\Theta\) if and only if its
> support coset \(\beta\) vanishes in \(CH^4(J\setminus\Theta)\).  If a
> theta-supported cycle has cohomology class \(c\), the generic unordered
> theta fibre has a degree-five zero-cycle and
> Voisin's \(D_{3,3}\) carrier has odd index.  All cycles generated by
> descended divisors, Fano translates, or the fifteen natural genus-two
> difference surfaces have even degree.  The larger full-rank
> \(F\times D\) construction has exact degree ideal \(12\mathbf Z\).
> None can perform this lift.

Proof spine:

1. identify the generic quotient \(Y=Z/(x\mapsto a-x)\) and obtain
   \(\operatorname{ind}(Y)\mid2\);
2. use the plane-cubic \(\operatorname{Sym}^2(E_3)\) fibre to prove that
   \(D_{3,3}\) is odd exactly when \(Y\) has index one;
3. push \(\gamma\times\Theta\) through the symmetric quotient and compute
   its degree as \(\Theta c=5\);
4. compute the full Hodge-lattice quotient by theta multiplication as
   \(\mathbf Z/2[c]\), giving the cohomological shadow of the localization
   obstruction \(\beta\);
5. close the visible geometric subalgebras by the divisor-gcd-eight,
   full-Fano-gcd-twelve, \(\Theta|_F=2C_s\), and
   \((2,2)\)-polarization calculations;
6. verify fineness and off-diagonal Ext vanishing, identify
   \(2a=z+\ell\), reject the Fourier candidate at scalar four, and isolate
   the unseparated odd Kunneth algebraicity step.

This is an obstruction/reduction theorem, not yet an Annals-level positive
theorem.  Its value is that the last parity is a single named Chow class,
not an open-ended search over constructions.

## 10. Primary-source audit

- Claire Voisin, *Abel--Jacobi map, integral Hodge classes and decomposition
  of the diagonal*, arXiv:`1005.5621`, SHA-256
  `ca7103f6529128a24425dbfc1c87589402b17b12719329239fccdb590f74b547`.
  Read: PDF pp. 11 and 14--16.  These pages describe
  \(D_{3,3}\to\operatorname{Sym}^2\Theta\), its plane-cubic symmetric-square
  fibre, the generic theta quotient, and the smoothness argument.

- Dmitry V. Gugnin, *On Integral Cohomology Ring of Symmetric Products*,
  arXiv:`1502.01862`, SHA-256
  `74c1d9704d7ddd24f76f314162a44c05727db9770648f6d285679e23b67b4107`.
  Read: Theorem 1, PDF pp. 4--7.  It supplies the exact integral
  symmetric-product pullback lattice and corrects the false degree-six
  factor-two argument.

- Peter O'Sullivan, *Algebraic cycles on an abelian variety*,
  arXiv:`0908.0626`, SHA-256
  `3de652b9426e202c7ad12cbb11a99e335012163e371e8fbee07ceeec98422f66`.
  Read: the introduction and main theorem on PDF pp. 1--3.  The theorem
  provides the unique symmetrically distinguished lift only in
  \(CH_{\mathbf Q}\), which is exactly why it does not settle the integral
  theta-support equality.

- Xavier Roulleau, *Genus 2 curve configurations on Fano surfaces*,
  arXiv:`1002.4467`, SHA-256
  `c66706bfa8977656043a8c068d9f2cabc7e72dc0f53eac3fab680ac82172c7bd`.
  Read: Theorem 3, Lemmas 5--6 and 9, Corollary 8, PDF pp. 3--7.  These give
  the fifteen genus-two curves, \(C_sD_g=2\), the Jacobian tangent-space
  description, and the harmonic-involution eigenspaces.

- Clemens--Griffiths, *The intermediate Jacobian of the cubic threefold*,
  DOI `10.2307/1970801`, SHA-256
  `6cfe5892f9e6da4f4550803072322484ed60e2df4e1ea236742ea529d22c1b02`.
  Read previously in C904 at the Fano difference and non-Jacobian results.
  It supplies \(F-F=\Theta\) and the non-Jacobian obstruction used with the
  Matsusaka--Ran criterion.

- Andreas Hoering, *M-regularity of the Fano surface*, arXiv:`0704.0558`,
  SHA-256
  `c764f7777cab37d0136f1f0194d8d1192f9706df395423c0fbfa0b5ad74e96d0`.
  Read previously at the polarization restriction; it records
  \(\Theta|_F\equiv2C_s\).

- Arend Bayer, Sjoerd Beentjes, Soheyla Feyzbakhsh, Georg Hein, Diletta
  Martinelli, Fatemeh Rezaee, and Benjamin Schmidt, *The desingularization
  of the theta divisor of a cubic threefold as a moduli space*,
  arXiv:`2011.12240`, SHA-256
  `ce005e812a7223208938c266281b88c2dbcfc3e125079eb98fcba76b8d365c8a`.
  Read: Theorem 7.1 and Corollary 6.9 with Lemmas 6.5 and 6.8.  The cache
  author field was corrected on 2026-08-10 to match the PDF and arXiv record.

- Eyal Markman, *Integral generators for the cohomology ring of moduli
  spaces of sheaves over Poisson surfaces*, arXiv:`math/0406016`, SHA-256
  `7e92ef402f3aa3a9bc87e5970afdaa8e4a8348ec36029590d7633e9b587ac0ea`.
  Read: Theorems 1--2, Theorem 8, and Sections 3.1--3.2/Proposition 24.
  The source restrictions are why its algebraic conclusion cannot simply
  be imported.

- Thorsten Beckmann and Olivier de Gaay Fortman, *Integral Fourier
  transforms and the integral Hodge conjecture for one-cycles on abelian
  varieties*, arXiv:`2202.05230`, SHA-256
  `ab63a64cc5be9444c4eb36609f4831e662e0f95b19e9be07d5ddb5d7d82f9fbc`.
  Read: Lemma 3.5, Theorem 3.8 and Propositions 3.11--3.12, PDF pp. 8--11.
  These give the signs, the Pontryagin exponential, and the integral
  cohomological lift of \(\operatorname{ch}(P)\).

- Ben Moonen and Alexander Polishchuk, *Divided powers in Chow rings and
  integral Fourier transforms*, arXiv:`0904.3995`, SHA-256
  `ecb7b3882c96609b1c66f8012fd1adc9dd61a82c936c7fbecd17f097192007c4`.
  Read: Theorem 1.6 and Corollary 1.7.  Their theorem is stated for a monoid scheme over a field;
  it does not by itself provide the boundary extension for a relative
  abelian scheme over the marked curve.

- Thorsten Beckmann and Olivier de Gaay Fortman, together with Philip
  Engel and Stefan Schreieder in the later Picard-bundle work, are used only
  through the already audited C904 minimal-class theorem and the explicit
  hypothesis of Lemma 2.9 in arXiv:`2507.15704`, SHA-256
  `f0284c8249c07ab5e3d9e5e49504662fad26de205563ab5a48aea27e742741ee`.
  No priority claim is made here.

The bounded localization search checked the standard torsion Abel--Jacobi
and motivic/etale comparison routes.  It found no primary theorem killing
\(CH^4(J\setminus\Theta)[2]\).  This is an absence in the searched routes,
not a global literature nonexistence claim.

## 11. Reproducibility

Replay from the repository root:

```sh
python3 notes/2026-08-10-c904-primitive-theta-obstruction.py
nix shell nixpkgs#sage -c sage \
  notes/2026-08-10-c904-theta-support-lattice.sage
nix shell nixpkgs#sage -c sage \
  notes/2026-08-10-c904-genus2-theta-carrier.sage
python3 notes/2026-08-10-c904-theta-resolution-weight.py
nix shell nixpkgs#sage -c sage \
  notes/2026-08-10-c904-sym2-theta-divisor-index.sage
nix shell nixpkgs#sage -c sage \
  notes/2026-08-10-c904-fano-middle-divisor-index.sage
python3 notes/2026-08-10-c904-poincare-fano-scalar.py
```

The theta-support and genus-two scripts import the exact exotic principal
lattice from
`2026-08-10-c904-minimal-class-divisor-lattice.sage`.  The first script
computes the full Hodge quotient, not a sample.  The genus-two script checks
all fifteen involutions.  They have no independent implementation in this
bundle: all involutions are conjugate, while the conceptual mod-two
five-cycle proof independently confirms the same two-primary ambient
defect.  The divisor-gcd-eight calculation is separate and uses the full
rank-thirty invariant divisor lattice.  The full Fano-middle calculation is
independently checked modulo two by the Rosati trace proof in
`2026-08-10-c904-primitive-theta-fano-resolution-lattice.md`; that proof
does not compute the sharper gcd twelve.  The Poincare scalar certificate is
a direct standard-symplectic calculation; its independent conceptual check
is the Fourier normalization \([F]=\Theta^3/3!\), which predicts the factor
\(g-1=4\), not a second software implementation.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-08-10-c904-primitive-theta-obstruction.py` | 3,592 | `e91450ea5431660cf2271a658b621c6f263320a9b6ae8ad87cf75793be5e9095` |
| `2026-08-10-c904-primitive-theta-obstruction.out` | 204 | `78ae5b353d05c17a140ac22e0051df23f79442bd7b909f3875fe2e7c395c1eef` |
| `2026-08-10-c904-theta-support-lattice.sage` | 3,411 | `3f611f00e352aea9c0f8016b86e670bc07939eeb624572242841d4cb1daca257` |
| `2026-08-10-c904-theta-support-lattice.out` | 266 | `847b97f2812f1842eebf5471a3e786da48ff579347fbb5b5de13c7cbab86d35d` |
| `2026-08-10-c904-genus2-theta-carrier.sage` | 2,851 | `7b706562ec3a73976dc7111242c7a990d62301bdfe268bca77d2c4fe2ad50cf4` |
| `2026-08-10-c904-genus2-theta-carrier.out` | 137 | `ba999cc556817a4d266f95f7894f7425b16167c2b66cb1ef7de9b20b6435ceb0` |
| `2026-08-10-c904-theta-resolution-weight.py` | 2,245 | `8553afcbfe2bf19f3f3b8b869279de78eca1d9c3787501da85dd097c31522401` |
| `2026-08-10-c904-theta-resolution-weight.out` | 219 | `1c2a0619e246402875c00f670a904b919aa7bf3f089a35b7a5938f8a7bbb6976` |
| `2026-08-10-c904-sym2-theta-divisor-index.sage` | 3,984 | `c5c18170fa67b57e7ba4f3eb9144e680f31ddf3498c5a036c9510907aa8dda02` |
| `2026-08-10-c904-sym2-theta-divisor-index.out` | 136 | `2e8a59503d9b75cb48e5ebd6e0c43c710299e87beb530ebb8d231e45e3655613` |
| `2026-08-10-c904-fano-middle-divisor-index.sage` | 7,415 | `89bbc3c8845165960068838bdc5f0a320d7f079e117f4d5d10c1ef0aa9d14a57` |
| `2026-08-10-c904-fano-middle-divisor-index.out` | 285 | `1eacd5004893327241bd033b14c73e2d41f3a879815cb72c712029d80364003a` |
| `2026-08-10-c904-poincare-fano-scalar.py` | 2,913 | `b18594cbdc2e9e6c85a636ff7375a9061fb42db78a09c38a872cee7a55e89187` |
| `2026-08-10-c904-poincare-fano-scalar.out` | 210 | `72783c299b710949ae43904e4586873d59475a1cbd3746e6cbbf5a39b90784a5` |

## 12. Mystery ledger

- **Why exactly one factor two?**  Settled for ambient Hodge classes: the
  quotient is \(\mathbf Z/2[c]\), with an independent five-cycle explanation.
- **Can an effective theta curve represent \(c\)?**  Settled negatively by
  Matsusaka--Ran plus Clemens--Griffiths.
- **Can the genus-two/Fano carriers provide the odd class?**  Settled
  negatively: their polarization restrictions are two-divisible, and the
  full mixed \(F\times D\) divisor channel has degree ideal \(12\mathbf Z\).
- **Does integral Fourier theory give the identity correspondence?**
  Settled negatively for the proposed pullback: its exact scalar is four,
  not one.  Relative boundary extension is additionally unproved.
- **Does the rank-three moduli presentation remove the obstruction?**
  Partly settled.  The moduli is fine and the \(\operatorname{Ext}^2\) gate
  vanishes; \(2a=z+\ell\) makes the residual index two explicit.
  Algebraicity of the odd Kunneth contraction remains open.
- **What is the sole surviving datum?**  Whether the support coset
  \(\beta=[\Gamma_c|_U]\) vanishes, or more weakly whether a signed intrinsic
  theta one-cycle has cohomology class of odd theta degree.  Its ambient
  cohomological quotient has order two; its integral Chow order is not
  determined.
- **Could \(\operatorname{ind}(Y)=1\) for a different reason?**  Yes.  The
  support lift is sufficient and cohomologically universal among odd
  algebraic classes, but a non-spread generic zero-cycle might evade a
  global relative cycle.  No converse from generic index one to a global
  \(\gamma\) is claimed.
