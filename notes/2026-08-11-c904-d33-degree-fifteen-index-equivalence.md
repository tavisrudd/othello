# C904: the degree-fifteen \(D_{3,3}\) packet and the exact index equivalence

Date: 2026-08-11
Status: theorem-grade for a general cubic and general charge-three bundle;
specialization of the all-good packet to the marked \(A_5\) pencil remains
Scope: Paper V upgrade research only; no manuscript or Lean change

## Verdict

The finite packet isolated in
`2026-08-11-c904-d33-factorable-quadric-index-reduction.md` has now been
counted in an exact characteristic-zero model.  It is a prime degree-fifteen
scheme over \(\mathbf Q\), with fifteen reduced geometric points and no
rank-one quadric.  An independent Macaulay2 computation reproduces the
degree, radicality, rank-one exclusion, and primality.

The count is useful, but its consequence must be stated precisely.  For a
general cubic, the geometric comparison in Sections 3--4 gives an odd
multisection of the generic \(D_{3,3}\)-curve over \(M_9\); it does
**not** give an odd zero-cycle on the generic Abel--Jacobi fourfold
\(M_9\to J\).  Combining the degree-fifteen packet with Voisin's
\(\operatorname{Pic}^2(E_3)\) relay proves instead the exact equivalence

\[
 v_2(\operatorname {ind}V)
   =v_2(\operatorname {ind}D)
   =v_2(\operatorname {ind}Y),
\]

where \(V\) is the generic charge-three Abel--Jacobi fibre, \(D\) is its
type-\((3,3)\) incidence, and \(Y\) is the generic fibre of
\(\operatorname{Sym}^2\Theta\to J\).  Since the visible constructions bound
both endpoint indices by two, they are simultaneously one or two.  Thus the
degree-fifteen theorem removes the intervening charge-three cancellation
problem and identifies the original gate exactly with the unordered-theta
halving gate.

## 1. The exact charge-three model

Fix a hyperplane \(H=\{z=0\}\simeq\mathbf P^3\) in \(\mathbf P^4\).  Start
with four generating sections of a null-correlation bundle \(N(1)\) on
\(H\).  In the frozen coordinates their six wedge quadrics are

\[
\begin{aligned}
 q_{01}|_H&=-x_0^2,&q_{02}|_H&=-x_2^2,
 &q_{03}|_H&=-x_0x_1-x_2x_3,\\
 q_{12}|_H&= x_0x_1-x_2x_3,&q_{13}|_H&=-x_3^2,
 &q_{23}|_H&=-x_1^2.
\end{aligned}
\]

They have no common projective zero.  Lift them to quadrics on
\(\mathbf P^4\) by

\[
                         q_{ij}=q_{ij}|_H+z\ell_{ij}.
\]

Their Pfaffian is divisible by \(z\):

\[
 q_{01}q_{23}-q_{02}q_{13}+q_{03}q_{12}=zF.
\]

For the deterministic seed 904, the first lift has smooth cubic residual
\(X=\{F=0\}\), and the six quadrics have no common point on \(X\).  They
therefore define a morphism \(X\to G(2,4)\).  Pulling back the universal
quotient gives a globally generated rank-two bundle \(E\) with
\(\det E={\cal O}_X(2)\).

The exact residual-ideal check for the section \((1,1,1,1)\) gives

\[
 P_{C_s}(t)=6t,\qquad h_C(1)=5,\qquad h_C(2)=12,
\]

and proves that \(C_s\) is smooth and prime.  Hence it is a nondegenerate
elliptic sextic and

\[
 h^0(I_{C_s}(2))=3,qquad h^0(E)=4.
\]

Twisting the Serre sequence by \({\cal O}_X(-1)\) and using
\(H^0(I_{C_s}(1))=0\) proves that \(E(-1)\) is stable.  Moreover
\(c_1(E(-1))=0\) and \(c_2(E(-1))=3[\ell]\).  Thus the example lies on the
ordinary charge-three component \(M_9\), rather than merely on a formal
quadratic-wedge parameter space.

## 2. The finite packet

Let \(V=H^0(X,E)\), with \(\dim V=4\), and write the six wedge quadrics as
symmetric matrices \(A_{ij}\).  In Pluecker coordinates on
\(\mathbf P(\bigwedge^2V)\), put

\[
                  A(p)=\sum_{i<j}p_{ij}A_{ij}.
\]

The packet is cut out by the Pluecker equation and all \(3\times3\) minors
of \(A(p)\), saturated by the irrelevant ideal.  Exact Sage computation
proves

\[
 \dim \widehat R=1,qquad P_R(t)=15,qquad \deg R=15,
\]

that the ideal is radical, and that its intersection with the rank-one
locus is empty.  Independent Macaulay2 computation additionally proves that
the ideal is prime over \(\mathbf Q\).  Because the resulting degree-fifteen
field is separable, the geometric packet consists of fifteen reduced points.

The count is not an intersection-number surrogate: it is the exact Artin
scheme defined by the symmetric rank condition inside the Pluecker
Grassmannian.

### 2.1 A conceptual count

The integer fifteen also has a uniform intersection-theoretic explanation.
For the null-correlation restriction on \(H\), the symmetric matrix is block
diagonal.  Its rank-at-most-two discriminant is the join of the two Veronese
conics.  A normalization is

\[
 Y=\mathbf P_{\mathbf P^1\times\mathbf P^1}
       \bigl({\cal O}(-2,0)\oplus{cal O}(0,-2)\bigr).
\]

Write \(\xi=c_1({\cal O}_Y(1))\) and let \(h_1,h_2\) be the two base
classes.  A point of \(Y\) represents
\(q=aL^2+bM^2\).  Requiring the transverse linear term of the lifted
five-variable quadric to lie in the two image lines gives divisors

\[
                         \xi+h_1,\qquad \xi+h_2.
\]

After those two conditions, the last rank condition is the Schur determinant

\[
                   4abc-a\beta^2-b\alpha^2=0,
\]

whose divisor class is \(3\xi-2h_1-2h_2\).  The projective-bundle pushdowns
are

\[
       \pi_*\xi=1,qquad
       \pi_*\xi^2=2(h_1+h_2),qquad
       \pi_*\xi^3=4h_1h_2.
\]

Therefore the generic packet length is

\[
 \int_Y(\xi+h_1)(\xi+h_2)(3\xi-2h_1-2h_2)
       =12+4-1=15.
\]

The explicit model proves that the packet avoids the two collapsed boundary
conics and the rank-one locus, so no boundary correction is hidden in this
number.  This calculation explains deformation invariance and replaces a
mere observed degree by a uniform theorem for general null-correlation
lifts.

## 3. Why the packet is the type-\((3,3)\) packet

A rank-two quadric factors geometrically as \(h_1h_2\).  For the corresponding
section pencil \(U\subset V\), every section curve lies on

\[
                (X\cap H_1)\cup(X\cap H_2).
\]

The intended scheme-theoretic evaluation-image argument on the two cubic
surfaces identifies the two rank-zero corrections and hence gives equal
hyperplane degree for the two residual components.  Their
total degree is six, hence both have degree three.  Finiteness excludes a
plane-cubic component: varying the second hyperplane through its plane would
otherwise give a positive-dimensional family of rank-two quadrics in
\(H^0(I_C(2))\).  On the general locus the two nondegenerate integral cubic
components are twisted cubics, and their intersection has length two because
the total curve has arithmetic genus one.

There is also an independent arithmetic witness.  Modulo five the packet has
the rational point

\[
                       [4:1:2:3:0:1].
\]

Its projective tangent space is zero-dimensional, its quadric splits into
two distinct hyperplanes, and a generic section has saturated component
Hilbert polynomials

\[
                         (3t+1,3t+1).
\]

The transverse point lifts uniquely to characteristic zero.  Since the
degree-fifteen packet is prime over \(\mathbf Q\), Galois transitivity then
places all fifteen geometric points in the same open type-\((3,3)\) stratum.
The type audit at \(p=7,11\) independently finds the same component Hilbert
polynomials after the required quadratic splitting extension.

The proposed deformation to the generic charge-three bundle uses the
standard open parameterization by:

\[
 \begin{array}{c|c}
 \text{datum}&\text{dimension}\\ \hline
 H\subset\mathbf P^4&4\\
 N\text{ on }H&5\\
 W\in G(4,H^0(N(1)))&4\\
 \text{six transverse linear lifts}&30
 \end{array}
\]

for total dimension \(43=34+9\), the dimension of smooth cubic equations
plus the charge-three component.  To promote the exact model count to the
generic theorem, one must print that this expected-dimension family has the
following rational inverse on the basepoint-free open: recover \(H\) from
the residual linear factor in
\(\operatorname{Pf}(w_E)=L_EF_X\), then recover \(N(1)\), the generating
space, and the six lifts.  The null-correlation classification supplies the
key identification on \(H\).  Dimension equality alone is not being used as
a proof of dominance.

## 4. The two-equivalence and index-compression theorem

The only index lemma needed is the following.  If \(f:Z\dashrightarrow W\)
is dominant between smooth proper varieties and its generic fibre has a
zero-cycle of degree \(n\), then

\[
            \operatorname {ind}(W)\mid\operatorname {ind}(Z)
       \mid n\operatorname {ind}(W).
\]

The first divisibility is pushforward.  For the second, spread a generic
degree-\(n\) cycle to a multisection and move zero-cycles on \(W\) into its
domain.

For the general-cubic theorem, apply this twice over the generic field of the
relative Abel--Jacobi base.  For the special marked \(A_5\) pencil, the same
conclusion is conditional only on the finite all-good packet open meeting its
generic \(M_9\)-fibre.

1. The normalized \(D_{3,3}\)-fibre over a general \(E\in M_9\) is a
   projective-line bundle over the degree-fifteen packet.  Its generic fibre
   over \(V\) therefore has a degree-fifteen zero-cycle.
2. Voisin's map from the full \(D_{3,3}\) incidence to
   \(\operatorname{Sym}^2\Theta\) has generic fibre birational to
   \(\operatorname{Sym}^2(E_3)\) for a plane cubic \(E_3\).  A degree-three
   point on \(E_3\) gives a degree-three zero-cycle on this symmetric square,
   so its index divides three.

It follows that

\[
 \begin{aligned}
   \operatorname {ind}(V)&\mid\operatorname {ind}(D)
                  \mid15\operatorname {ind}(V),\\
   \operatorname {ind}(Y)&\mid\operatorname {ind}(D)
                  \mid3\operatorname {ind}(Y),
 \end{aligned}
\]

and therefore their 2-primary indices agree.  This is the strongest licensed
index consequence of the odd packet.

There is a cleaner formulation.  The degree-fifteen generic cycle on
\(D\to V\), pushed through \(D\dashrightarrow Y\), gives a zero-cycle of
odd degree on \(Y_{k(V)}\).  Conversely the degree-three generic cycle on
\(D\to Y\), pushed through \(D\dashrightarrow V\), gives a zero-cycle of
odd degree on \(V_{k(Y)}\).  Thus \(V\) and \(Y\) are **2-equivalent**:
there are correspondences of odd multiplicity in both directions.  The
index equality is the first concrete consequence.  Standard
\(p\)-equivalence theory also gives equal canonical 2-dimension, and the
index equality persists after every field extension.  Do not strengthen
this to isomorphic Chow motives or a common upper 2-motive: those assertions
require geometric splitting and Rost nilpotence, neither of which has been
proved here.

## 5. What died, and what remains live

- **Dead:** treating degree fifteen as an odd point on \(M_9\to J\).  It is
  an odd multisection of the intervening \(D_{3,3}\)-curve, not of the
  Abel--Jacobi fourfold.
- **Dead:** a hidden 2-primary cancellation inside the charge-three curve.
  The degree-fifteen and degree-three relays are both odd, so they preserve
  the endpoint 2-primary index exactly and, conditionally on the generic
  comparison, give 2-equivalence of the endpoints.
- **Dead:** reviving numerical symmetric-square, divisor saturation,
  six-axis averaging, Hecke-conic, or Poincare-kernel routes.  Their even
  ceilings were proved in the earlier audits.
- **Live:** decide whether the generic unordered-theta fibre \(Y\) has index
  one or two, equivalently whether the intrinsic horizontal Chow half on
  \(D_+\) exists over the marked base.
- **Live comparison:** prove that the finite all-good packet open meets the
  generic \(M_9\) over the special \(A_5\) pencil.  The ordinary generic
  cubic theorem and the exact displayed model do not by themselves certify
  this specialization.
- **Live adjacent Annals upgrade:** classify arbitrary integral gluings by
  their primitive divisor-product obstruction.  The Jordan-scalar theorem
  gives the positive infinite family and the exotic \(\mathbf F_4\) gluing
  is the first non-scalar boundary.

There is one quarantined \(A_5\) coincidence.  The six \(D_5\) axes have
fifteen unordered pairs, canonically identified with the fifteen involutions
of \(A_5\); the stabilizer is \(V_4\) and the permutation character is
\(1\oplus4\oplus5\oplus5\).  This does **not** label the generic packet:
\(A_5\) carries \(R(E)\) to \(R(g^*E)\), while a generic charge-three bundle
has no fibrewise \(A_5\)-linearization.  Identifying the two fifteen-sets
would first require an \(A_5\)-fixed bundle with section module the
four-dimensional heart and a packet orbit with stabilizer \(V_4\).  In fact
the ordinary fixed test is obstructed: \(\operatorname{Pf}(w_E)=F_XL_E\)
would be \(A_5\)-invariant, but the irreducible ambient five-space has no
invariant linear form \(L_E\).  An \(A_5\)-linearized bundle must therefore
fall into the different excess stratum \(\operatorname{Pf}(w_E)=0\), not the
ordinary \(L_E\ne0\) packet.  Thus \(15=\binom62\) is a high-value fishing
clue, not a theorem or a source of rational packet sections.

## 6. Priority boundary

Voisin proves dominance and one-dimensionality of
\(D_{3,3}\dashrightarrow M_9\), and identifies the
\(\operatorname{Pic}^2(E_3)\) relay.  The source does not count the finite
packet.  No checked source states the factorable-wedge degree fifteen or the
resulting equality of the two endpoint 2-primary indices.

The degree-fifteen theorem is a strong structural ingredient, plausibly at
the JEMS/Inventiones level when combined with the modular correspondence and
integral boundary results.  It is not by itself an Annals crown.  The Annals
exit remains either:

1. prove the unordered-theta index is one and obtain the relative universal
   cycle; or
2. compute its nonzero two-primary obstruction and minimal splitting cover;
   or
3. prove an if-and-only-if arbitrary-gluing theorem that explains both the
   Jordan-scalar saturation and the exotic \(\mathbf F_4\) exception.

Any paper-facing use of the generic degree-fifteen statement should print
the three short lemmas proved in the audit rather than cite the computation
alone:

1. the null-correlation normal form dominates the general framed
   charge-three component;
2. the generic raw rank-two packet has no unbalanced, nonintegral, or
   multicomponent residual stratum; and
3. the projective line attached to a packet point is generically one-to-one
   onto the corresponding component of the \(D_{3,3}\)-fibre.  Identifying
   this line with the Abel fibre used in Voisin's further quotient \(Z\)
   would require an additional linearity calculation and is not needed for
   the two-equivalence theorem.

## 7. Replay

From the repository root:

```bash
nix shell nixpkgs#sage -c sage -c \
  'exec(preparse(open("notes/2026-08-11-c904-factorable-quadric-packet.sage").read()))'
nix shell nixpkgs#macaulay2 -c M2 --script \
  notes/2026-08-11-c904-factorable-quadric-packet-replay.m2
nix shell nixpkgs#sage -c sage -c \
  'exec(preparse(open("notes/2026-08-11-c904-factorable-quadric-type-audit.sage").read()))'
```

The expected outputs are stored beside the three scripts.  No manuscript or
Lean file is part of this certificate.
