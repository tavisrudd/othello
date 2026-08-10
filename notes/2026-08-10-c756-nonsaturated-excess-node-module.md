# C756 nonsaturated excess-node module

**Lane:** `clebsch` · **Date:** 2026-08-10 · **Scope:** purely structural
nonsaturated reduction; no census and no manuscript edit

## Verdict

The nonsaturated Moore quotient has a canonical finite-module carrier that
retains both direction and intercept while having dimension exactly the
defect \(\delta\).

Fix an arc point and a spare external line as in the direction-cover
reduction.  Let \(n=k-1\), and let \(\mathcal N\) be the set of the
\(\binom n2=q+\delta\) affine chord nodes
\[
 (t_{ij},u_{ij})=
 \left(\frac{y_i-y_j}{x_i-x_j},\ y_i-t_{ij}x_i\right),
 \qquad i<j.                                              \tag{1}
\]
The slope map \(\pi:\mathcal N\to\mathbb F_q\) is surjective.  Its fibre
over \(t\) has size \(\mu_t\), the number of chords of that direction.
Define the split coordinate algebras
\[
 B=\operatorname{Map}(\mathbb F_q,\mathbb F_q),qquad
 A=\operatorname{Map}(\mathcal N,\mathbb F_q),            \tag{2}
\]
and the canonical excess module
\[
 \boxed{M=A/\pi^*B.}                                      \tag{3}
\]
Then
\[
 \boxed{\dim_{\mathbb F_q}M
        =\sum_t(\mu_t-1)=\delta,}                         \tag{4}
\]
and multiplication by the slope coordinate induces an operator \(T_M\) on
\(M\) whose characteristic polynomial is precisely the residual direction
polynomial:
\[
 \boxed{E_P(Z)\doteq\det(ZI-T_M).}                        \tag{5}
\]

Thus \(E_P\) is not merely the quotient left after removing \(T^q-T\).  It
is the spectral polynomial of the canonical excess node module.  The
classes of the intercept powers \([U^a]\in M\) record
the relative intercepts inside repeated-direction fibres and vanish
automatically on every unique direction.  This gives the masked Redei
problem a uniform, coordinate-honest form on the Frobenius-fixed base.

The remaining theorem is not module existence: abstract modules (3) exist
for every surjective finite cover.  It is to show that no \(\delta\)-module
with the special star realization, conic square class, and all-center
covering identities can occur.  This is the correct nonsaturated structural
gate after the fixed-size census stops.

The carrier extends to a canonical filtration \(M^{[d]}\) with dual
barycentric edge-weight spaces.  Its conic determinant splits into a zero
norm on the reduced triple-direction support \(K_P\) and, when nonzero, a
quadratic-character resultant only on the odd-multiplicity support
\(K_{\rm odd}\).  Writing the node conic values as \(\eta s^2\) identifies
zero trace with isotropy and lifts all nodes to the smooth branched quadric
\(\mathscr X_\eta\).  On its direction-conic pencil, each trace is the trace
of \(z^2\) over the doubled repeated-node divisor.  Deriving the resulting
cross-direction divisor trace law is the current exact nonsaturated gate.

## 1. The reduced node cover

Put
\[
 F(U,T)=\prod_{i=1}^n(U+Tx_i-y_i).                        \tag{6}
\]
Two factors meet at (1).  Because the primal points form an arc, no three
factors meet and two different pairs cannot define the same affine node.
Hence \(\mathcal N\) consists of \(\binom n2\) distinct rational ordinary
nodes of the line arrangement \(F=0\).  Intrinsically it is the reduced
singular scheme
\[
 \mathcal N=V(F,F_U,F_T)_{\mathrm{red}}.                  \tag{7}
\]

Every finite direction occurs by the spare-line covering lemma.  Chords of
one direction form a matching, so their intercepts are distinct; therefore
\[
 \pi^{-1}(t)=\{(t,u):F(U,t)\text{ has a double root at }u\}
\]
has exactly \(\mu_t\) points.  The familiar direction discriminant is
\[
 \operatorname{Disc}_U F(U,T)
 \doteq\prod_{i<j}\bigl((x_i-x_j)T-(y_i-y_j)\bigr)^2
 =(T^q-T)^2E_P(T)^2.                                     \tag{8}
\]
Equation (8) sees the branch directions but forgets the distinct intercepts
in a repeated fibre.  The algebra \(A\) retains them.

## 2. Quotient by the forced Moore base

The pullback \(\pi^*:B\hookrightarrow A\) identifies a function of slope
with the function that is constant on each node fibre.  Since both algebras
are products of copies of \(\mathbb F_q\), there is a canonical fibrewise
decomposition of the quotient as a vector space:
\[
 M=\bigoplus_{t\in\mathbb F_q}
   \mathbb F_q^{\mu_t}/\langle(1,\ldots,1)\rangle.         \tag{9}
\]
This proves (4).  It is the exact algebraic meaning of removing one forced
node from every rational direction without choosing which node to remove.

The algebra \(B\) acts on \(A\) by pullback and preserves \(\pi^*B\), so
\(M\) is canonically a \(B\)-module.  On the summand at \(t\), the slope
coordinate acts as the scalar \(t\) with multiplicity \(\mu_t-1\).  Hence
\[
 \det(ZI-T_M)
 =\prod_{t\in\mathbb F_q}(Z-t)^{\mu_t-1},                 \tag{10}
\]
which is (5) by the direction-factorization theorem.

Under a projective change of coordinate on the direction line, (5)
homogenizes in the expected way.  Therefore the construction is not tied to
one affine slope chart; intrinsically, \(M\) is a length-\(\delta\) module
on the Frobenius-fixed direction base, and (5) is its binary characteristic
form.

## 3. The intercept flag

Let \(U\in A\) denote the intercept function.  Although multiplication by
\(U\) does not descend to an endomorphism of \(M\) (the subspace
\(\pi^*B\) is not \(U\)-stable), the classes
\[
 [U],[U^2],\ldots\in M                                  \tag{11}
\]
are canonical.  In a fibre of size one every class vanishes.  In a fibre
of size \(\mu\ge2\), the intercepts \(u_1,\ldots,u_\mu\) are distinct, and
the Vandermonde matrix shows that
\[
 [U],[U^2],\ldots,[U^{\mu-1}]
 \quad\text{span}\quad
 \mathbb F_q^\mu/\langle\mathbf1\rangle.                  \tag{12}
\]
Thus the increasing spans of (11) form a canonical intercept flag on the
excess module.  It retains exactly the information lost by the scalar
direction discriminant (8).

This also explains the earlier first-subresultant failure.  Before passing
to (3), the subresultant lives over all \(q\) rational directions and has
degree \(\Theta(q)\).  In \(M\), every unique-direction fibre is zero and
only the \(\delta\) excess dimensions remain.  The compression is a quotient
of the finite Frobenius-fixed node algebra, not a nonexistent subtraction of
a global Moore Cartier divisor on the whole geometric pencil.

## 4. Canonical covariance form on the quotient

Let
\[
 \operatorname{Tr}_{A/B}:A\longrightarrow B,\qquad
 \mu=\operatorname{Tr}_{A/B}(1),                          \tag{13}
\]
where the trace is fibrewise summation, so \(\mu(t)=\mu_t\).  The formula
\[
 \boxed{\mathcal C([f],[g])
 =\mu\,\operatorname{Tr}(fg)
  -\operatorname{Tr}(f)\operatorname{Tr}(g)}              \tag{14}
\]
defines a \(B\)-valued symmetric bilinear form on
\(M=A/\pi^*B\).  It is
unchanged if \(f\) or \(g\) is altered by a fibrewise constant function, and
therefore requires neither division by \(\mu_t\) nor a choice of fibrewise
mean.

On a fibre with values \(f_a,g_a\), the form is
\[
 \mathcal C_t([f],[g])
 =\sum_{a<b}(f_a-f_b)(g_a-g_b).                           \tag{15}
\]
In particular, the first intercept invariant is
\[
 \mathcal C_t([U],[U])
 =\sum_{a<b}(u_a-u_b)^2.                                  \tag{16}
\]
It vanishes on every unique direction and is carried entirely by the
repeated-direction support; for fibres of size at least three it may be
isotropic.

The whole intercept flag has an exact discriminant.  For a fibre of size
\(\mu\ge2\), put
\[
 G_\mu=\bigl(\mathcal C_t([U^a],[U^b])\bigr)_
               {1\le a,b\le\mu-1}.
\]
The power-evaluation map to
\(\mathbb F_q^\mu/\langle\mathbf1\rangle\) has determinant equal to the
Vandermonde in the distinct intercepts.  In difference coordinates, the
matrix of \(\mathcal C_t\) is \(\mu I-J\), of determinant
\(\mu^{\mu-2}\).  Hence
\[
 \boxed{\det G_\mu
 =\mu^{\mu-2}\prod_{a<b}(u_a-u_b)^2.}                     \tag{17}
\]
If \(p\nmid\mu\), the covariance form is nondegenerate and its square class
is the fixed class of \(\mu^{\mu-2}\), independent of the intercepts.  If
\(p\mid\mu\), its degeneration is an explicit characteristic seam rather
than a failure of canonicity.

Equation (17) is the first uniform scalar that can be compared with the
constant conic square class.  At defect two, a double direction
(\(\mu=2\)) contributes a square, while a triple direction (\(\mu=3\))
contributes the square class of \(3\); this recovers the two local residual
shapes without choosing their intercepts.

## 5. Conic type as a square-class element

In the dual-star model every node of \(\mathcal N\) has the prescribed
internal conic type.  If \(Q(T,U)\) is an affine equation for the dual conic,
then
\[
 q_{\mathcal N}=Q(T,U)\in A^\times                         \tag{18}
\]
has constant quadratic-character class in every factor of the split algebra
\(A\).  Equivalently, for the fixed sign \(\epsilon\),
\[
 q_{\mathcal N}\in\epsilon\,(A^\times)^2.                \tag{19}
\]
This is the coordinate-free home of the node-character condition.  It
should be combined with the intercept flag (11), not projected immediately
to the direction polynomial (5).

There is a canonical weighted version of the covariance form that performs
this combination.  On a fibre put
\[
 q_i=Q(t,u_i),\qquad \sigma_t=\sum_i q_i,
\]
and define
\[
 \mathcal C_{Q,t}([f],[g])
 =\sigma_t\sum_iq_if_ig_i
  -\left(\sum_iq_if_i\right)\left(\sum_iq_ig_i\right).
                                                               \tag{20}
\]
Adding a constant to either \(f\) or \(g\) leaves (20) unchanged, so it
descends to the same quotient module without choosing a splitting.

In difference coordinates, the determinant of the weighted form is
\[
 \det(\mathcal C_{Q,t})
 =\sigma_t^{\mu-2}\prod_iq_i.                              \tag{21}
\]
Transporting it through the intercept-power evaluation map gives
\[
 \boxed{
 \det\bigl(\mathcal C_{Q,t}([U^a],[U^b])\bigr)_
                 {1\le a,b\le\mu-1}
 =\sigma_t^{\mu-2}
  \left(\prod_iq_i\right)
  \prod_{i<j}(u_i-u_j)^2.}                                \tag{22}
\]
The proof is the matrix determinant lemma applied to
\(\sigma_t\operatorname{diag}(q_1,\ldots,q_{\mu-1})-vv^{\mathsf T}\),
\(v=(q_1,\ldots,q_{\mu-1})\), followed by the Vandermonde determinant.

Extend the quadratic character by \(\chi(0)=0\).  By (19),
\(\prod_iq_i\) has square class \(\epsilon^\mu\).  Therefore (22)
reduces the entire conic contribution to one fibre trace:
\[
\chi(\det\mathcal C_{Q,t})
 =\chi(\sigma_t)^{\mu-2}\epsilon^\mu,                     \tag{23}
\]
including the degenerate case.  Since \(Q(t,U)\) is quadratic in
\(U\),
\[
 \sigma_t
 =a(t)\operatorname{Tr}(U^2)
  +b(t)\operatorname{Tr}(U)+\mu_t c(t),                  \tag{24}
\]
so this trace is already contained in the first two levels of the intercept
flag.

There is a useful orthogonal model behind (23).  Choose once and for all
\(\eta\in\mathbb F_q^*\) with \(\chi(\eta)=\epsilon\).  The split-algebra
condition (19) permits
\[
 q_{\mathcal N}=\eta s^2,
 \qquad s\in A^\times,                                  \tag{23a}
\]
where changing any component sign of \(s\) has no effect below.  On a fibre,
write \(s=(s_1,\ldots,s_\mu)\) and
\(\tau=s^{\mathsf T}s=\sum_i s_i^2\).  Then
\[
 \sigma_t=\eta\tau,
\]
and after the diagonal change of variables \(z_i=s_if_i\), the weighted
covariance is
\[
 \boxed{
 \mathcal C_{Q,t}=\eta^2\,\operatorname{diag}(s)
       (\tau I-ss^{\mathsf T})\operatorname{diag}(s).}   \tag{23b}
\]
The middle matrix kills \(s\), exactly corresponding to constants before
the diagonal change.  Thus \(\mathcal C_{Q,t}\) is the orthogonal quotient
of the rank-one projector \(\tau I-ss^{\mathsf T}\).  In particular,
\[
 \boxed{
 \sigma_t=0\quad\Longleftrightarrow\quad
 s^{\mathsf T}s=0,}                                     \tag{23c}
\]
and for \(\mu\ge3\) this makes the quotient form degenerate.  The zero-trace
gate is therefore an isotropic-square-root gate on each direction matching;
the nonzero sign gate is the discriminant of these orthogonal quotients.
This formulation suggests retaining the deck-sign compatibility of
the square roots supplied by the endpoint Gram determinants, rather than
discarding it after squaring.
It is also a stop rule: every nondegenerate quadratic space of dimension at
least three over a finite field of odd order is isotropic.  Therefore the
abstract fibre dimension and square class cannot exclude (23c).  Any proof
must use that the particular square-root vectors on different matchings come
from one endpoint Gram system (or from the all-center identities), not merely
that each vector has nonzero coordinates.

Those square roots have a global geometric carrier.  Homogenize the dual
conic equation and form the quadratic twist of its branched double plane
\[
 \boxed{
 \mathscr X_\eta:
 z^2=\eta^{-1}Q_{\rm du}(T,U,W)\subset\mathbf P^3.}      \tag{23d}
\]
Because the characteristic is odd and the conic is nonsingular,
\(\mathscr X_\eta\) is a smooth quadric surface.  Condition (19) says
exactly that every star node has two rational lifts to \(\mathscr X_\eta\),
exchanged by \(z\mapsto-z\), and the affine \(z\)-coordinates are the
components \(s_i\) in (23a).

Each line factor of the endpoint arrangement pulls back to a plane conic on
\(\mathscr X_\eta\).  Two such lifted conics meet in the two deck-conjugate
points lying over their node, because that node is off the branch conic.
Hence the choices of signs in \(s\) form a deck-labeled doubled-edge
incidence system on the complete endpoint graph, realized by one fixed
branched quadric rather than by unrelated choices on the direction fibres.
This is not yet a two-sheeted cover of the endpoint vertices: a genuine
voltage cocycle would have to be derived from the incidence of the lifted
conics.  The remaining value-level theorem may therefore
be stated geometrically:

> derive the zero norm (49c) and parity resultant (51b) from the incidence
> and divisor relations among these lifted endpoint conics on
> \(\mathscr X_\eta\).

This is the precise cross-matching structure absent from the abstract
orthogonal model.  It does not yet supply a canonical sheet choice or a
trace identity; those are the new geometric gates.

The direction fibres have an exact divisor interpretation on this surface.
Let \(D_i\subset\mathscr X_\eta\) be the pullback of the \(i\)-th arrangement
line, and let \(C_t\) be the pullback of the dual-plane line \(T=tW\).
All are hyperplane sections of the quadric.  If
\(\widetilde N_t\) is the reduced degree-\(2\mu_t\) divisor consisting of
both lifts of the repeated nodes of direction \(t\), and
\(\widetilde U_t\) is the scheme-theoretic pullback of the unmatched
endpoint-line divisor, then
\[
 \boxed{
 \left.\sum_{i=1}^nD_i\right|_{C_t}
 =2\widetilde N_t+\widetilde U_t.}                       \tag{23e}
\]
Indeed, two endpoint lines pass through each repeated node, whereas only one
passes through every unmatched intersection.  The repeated nodes are off
the branch conic and split into two rational lifts.  An unmatched point may
instead be split, inert, or ramified; its scheme-theoretic inverse image
always has degree two, so (23e) and the trace formulas below remain valid
without an unstated rationality assumption.  Moreover the coordinate section
\(z\) satisfies
\[
 \boxed{
 \sigma_t=\frac\eta2
   \operatorname{Tr}_{\widetilde N_t/\mathbb F_q}(z^2).} \tag{23f}
\]
Both lifts contribute the same square, so (23f) is exactly (23a) with no
sheet choice.  The nonsaturated resultant has therefore become a norm of
divisor traces of one fixed quadratic section on the pencil of hyperplane
conics \(C_t\).  A successful all-center law can now be sought as a trace or
residue identity on that pencil; (23e) supplies the multiplicity divisor it
must use.

The first such trace identity is exact and global.  The \(i\)-th arrangement
line meets the affine direction line at
\[
 a_i(t)=y_i-tx_i.
\]
Let \(I_t\) be the endpoints unmatched by the direction-\(t\) chord
matching, and put
\[
 L(T)=\sum_{i=1}^nQ_{\rm du}(T,y_i-Tx_i),
 \qquad
 \nu_t=\sum_{i\in I_t}Q_{\rm du}(t,a_i(t)).             \tag{23g}
\]
Because \(Q_{\rm du}\) is quadratic and each \(a_i(T)\) is linear,
\(L(T)\) has degree at most two.  Every matched pair contributes the same
node value twice, while every unmatched endpoint contributes once.  Hence
\[
 \boxed{L(t)=2\sigma_t+\nu_t.}                          \tag{23h}
\]
On \(\mathscr X_\eta\), this is exactly the trace of \(z^2\) in the divisor
identity (23e):
\[
 \operatorname{Tr}_{\widetilde U_t/\mathbb F_q}(z^2)
 =\frac2\eta\nu_t,
 \qquad
 \operatorname{Tr}_{(\sum_iD_i)|C_t/\mathbb F_q}(z^2)
 =\frac2\eta L(t).
\]

Let \(\Upsilon_3\) be the degree-less-than-\(s\) interpolation polynomial for
\(t\mapsto\nu_t\) on the roots of \(K_P\).  Reduction of (23h) gives
\[
 \boxed{
 \Sigma_3\equiv\frac{L-\Upsilon_3}{2}\pmod {K_P}.}     \tag{23i}
\]
Consequently the two remaining gates admit the exact complementary-divisor
formulas
\[
 \operatorname N_{C_3/\mathbb F_q}(\Sigma_3)
 =2^{-s}\operatorname{Res}_T(K_P,L-\Upsilon_3),          \tag{23j}
\]
and, whenever this norm is nonzero,
\[
 \chi\!\left(\operatorname{Res}_T(K_{\rm odd},\Sigma_3)\right)
 =\chi(2)^{-\deg K_{\rm odd}}
  \chi\!\left(\operatorname{Res}_T
       (K_{\rm odd},L-\Upsilon_3)\right).               \tag{23k}
\]
Thus the zero norm and parity resultant are norms of a degree-two endpoint
trace minus the trace on the unmatched divisor.  A fibre of multiplicity
\(\mu_t\) leaves only \(n-2\mu_t\) unmatched endpoints, so this
complementary trace carrier becomes smaller precisely where \(J_P\) has
higher multiplicity.  The next nonsaturated lemma is to control \(\Upsilon_3\)
from the moving residual divisors \(\widetilde U_t\) on the same quadric
pencil.

This residual trace also has a division-free coefficient interface.  On a
direction fibre write
\[
 F(U,t)=G_t(U)^2H_t(U),
\]
where the roots of the monic polynomial \(G_t\) are the repeated nodes and
the roots of \(H_t\) are the unmatched intersections.  Put
\[
 \begin{aligned}
 F(U,t)&=U^n+f_1(t)U^{n-1}+f_2(t)U^{n-2}+\cdots,\\
 G_t(U)&=U^{\mu_t}+g_1(t)U^{\mu_t-1}
                    +g_2(t)U^{\mu_t-2}+\cdots,\\
 H_t(U)&=U^{n-2\mu_t}+h_1(t)U^{n-2\mu_t-1}
                    +h_2(t)U^{n-2\mu_t-2}+\cdots.
 \end{aligned}                                          \tag{23l}
\]
Here coefficients beyond the degree of a factor are interpreted as zero,
or equivalently as its elementary symmetric coefficients.
Coefficient comparison in \(F=G_t^2H_t\) gives
\[
 \boxed{
 h_1=f_1-2g_1,
 \qquad
 h_2=f_2+3g_1^2-2g_2-2f_1g_1.}                         \tag{23m}
\]
If \(Q_{\rm du}(t,U)=a(t)U^2+b(t)U+c(t)\), Newton's identities on
the roots of \(H_t\) therefore give
\[
 \boxed{
 \begin{aligned}
 \nu_t={}&a(t)\bigl(f_1(t)^2-2f_2(t)-2g_1(t)^2
                         +4g_2(t)\bigr)\\
          &-b(t)\bigl(f_1(t)-2g_1(t)\bigr)
            +(n-2\mu_t)c(t).
 \end{aligned}}                                        \tag{23n}
\]
The complementary expression
\[
 L(t)-\nu_t
 =2\{a(t)(g_1(t)^2-2g_2(t))-b(t)g_1(t)+\mu_tc(t)\}
 =2\sigma_t                                             \tag{23o}
\]
recovers both (23h) and (30).  Thus the divisor and subresultant routes are
the same interface: over the bounded algebra \(C_3\), controlling
\(\Upsilon_3\) requires only the degree, first coefficient, and second
coefficient of the unmatched factor, equivalently the first two
coefficients of the repeated-root factor.  No full fibre gcd or enumeration
is needed.

Equivalently, these coefficient formulas are logarithmic residues on the
direction line.  With residues taken in the \(U\)-line over a fixed \(t\),
\[
 \boxed{
 \begin{aligned}
 \sigma_t&=-\operatorname{Res}_{U=\infty}
       \left(Q_{\rm du}(t,U)\frac{G_t'(U)}{G_t(U)}\,dU\right),\\
 \nu_t&=-\operatorname{Res}_{U=\infty}
       \left(Q_{\rm du}(t,U)\frac{H_t'(U)}{H_t(U)}\,dU\right),\\
 L(t)&=-\operatorname{Res}_{U=\infty}
       \left(Q_{\rm du}(t,U)\frac{F_U(U,t)}{F(U,t)}\,dU\right).
 \end{aligned}}                                        \tag{23p}
\]
At a finite root the logarithmic derivative has residue equal to its
multiplicity, so the global residue theorem proves each line.  The identity
\(d\log F=2d\log G_t+d\log H_t\) then proves (23h) directly.  On the
branched quadric, replace \(Q_{\rm du}\) by \(\eta z^2\); the two deck lifts
account for the factor two in the divisor traces following (23h).
Thus the moving unmatched term is a residue of one quadratic section against
the logarithmic derivative of the residual divisor.  A global control of
that residue over \(C_3\) would immediately control both resultants
(23j)--(23k).

The same factorization gives a complementary norm law.  Define the fixed
endpoint polynomial
\[
 \Pi(T)=\operatorname{Res}_U(F(U,T),Q_{\rm du}(T,U))
       =\prod_{i=1}^nQ_{\rm du}(T,y_i-Tx_i),
 qquad \deg\Pi\le2n.                                   \tag{23q}
\]
Multiplicativity of the resultant and \(F_t=G_t^2H_t\) give
\[
 \boxed{
 \Pi(t)=operatorname{Res}_U(G_t,Q_{\rm du}(t,U))^2
        \operatorname{Res}_U(H_t,Q_{\rm du}(t,U)).}    \tag{23r}
\]
Hence, including the zero case,
\[
 \boxed{
 [\operatorname{Res}_U(H_t,Q_{\rm du}(t,U))]
 =[\Pi(t)]\quad\text{in }\mathbb F_q^\times/
                  (\mathbb F_q^\times)^2}              \tag{23s}
\]
whenever the two sides are nonzero.  Thus the unmatched divisor has both a
trace carrier \(\nu_t\) and a globally prescribed norm square class.  In the
perfect-matching case \(H_t=1\), one gets \(\nu_t=0\) and
\(\sigma_t=L(t)/2\) outright; near-perfect fibres reduce the open trace to a
residual divisor of degree one or two.  This supplies a second invariant for
the complementary-divisor resultant without assuming that unmatched lifts
are rational.

The factors of \(\Pi\) retain the original point types.  Let \(D\) be a
symmetric matrix for \(Q_{\rm du}\), choose the compatible primal form
\[
 Q_{\rm pr}(v)=v^{\mathsf T}\operatorname{adj}(D)v,
\]
and put
\[
 v_i=(x_i,1,-y_i),
 \qquad q_i(T)=Q_{\rm du}(T,y_i-Tx_i,1).
\]
Writing \(p_i(T)=p_{i,0}+Tp_{i,1}\), one has
\(p_{i,0}\times p_{i,1}=v_i\).  The Gram-determinant identity for the
restriction of a ternary quadratic form to a line gives
\[
 \boxed{
 \operatorname{disc}_T q_i
 =-4\,v_i^{\mathsf T}\operatorname{adj}(D)v_i
 =-4Q_{\rm pr}(v_i).}                                  \tag{23t}
\]
Indeed, if the Gram matrix of the restriction in the basis
\((p_{i,1},p_{i,0})\) is
\(\left(\begin{smallmatrix}a&b/2\\b/2&c\end{smallmatrix}\right)\),
then \(b^2-4ac=-4\det\), while the determinant is the adjugate value on
the cross product.  Consequently
\[
 \boxed{
 \Pi(T)=\prod_{i=1}^nq_i(T),
 \qquad [\operatorname{disc}q_i]=[-Q_{\rm pr}(v_i)]}   \tag{23u}
\]
in square classes.  Thus the complementary norm carrier is not an arbitrary
degree-\(2n\) polynomial: it is a product of quadratic restrictions whose
split types are exactly the primal conic types of the endpoint lines.  This
is the direct point-type input available for a character evaluation of
(23r), including mixed arrangements.

There is also an aggregate discriminant consequence.  After a projective
change of direction coordinate avoiding roots at infinity, the standard
product formula gives
\[
 \operatorname{disc}\Pi
 =\prod_i\operatorname{disc}(q_i)
   \prod_{i<j}\operatorname{Res}(q_i,q_j)^2.            \tag{23v}
\]
The identity is homogeneous and therefore extends back to the binary
direction line.  If \(\Pi\) is squarefree, (23t) yields
\[
 \boxed{
 [\operatorname{disc}\Pi]
 =\prod_{i=1}^n[-Q_{\rm pr}(v_i)]}                      \tag{23w}
\]
in square classes.  If two endpoint factors share a branch direction, the
corresponding resultant and \(\operatorname{disc}\Pi\) both vanish.  Thus
the product of the endpoint point types is exactly the discriminant class
of the global complementary-norm carrier; all pairwise interactions drop
out as squares.

There is a second direction cover hidden in the endpoint values themselves.
Define the monic value polynomial
\[
 \mathfrak F(V,T)=\prod_{i=1}^n(V-q_i(T))
 =V^n-L(T)V^{n-1}+\cdots.                              \tag{23x}
\]
At a direction \(t\), put
\[
 \begin{aligned}
 \mathfrak G_t(V)
   &=\prod_{\{i,j\}\in\mathcal M_t}
       (V-Q_{\rm du}(t,u_{ij})),\\
 \mathfrak H_t(V)
   &=\prod_{i\in I_t}(V-q_i(t)).
 \end{aligned}
\]
The endpoint matching gives the exact value-factorization
\[
 \boxed{
 \mathfrak F(V,t)=\mathfrak G_t(V)^2\mathfrak H_t(V),
 \quad
 -[V^{\mu_t-1}]\mathfrak G_t=\sigma_t,
 \quad
 -[V^{n-2\mu_t-1}]\mathfrak H_t=\nu_t.}                \tag{23y}
\]
When \(\mathfrak H_t=1\), its displayed first coefficient is interpreted as
zero.
This remains true when distinct nodes have the same conic value: the
displayed factors need not be coprime.  Thus the open divisor trace is the
first coefficient of a forced square factor in one scalar value polynomial,
not merely a fibrewise sum.

Write
\[
 Q_{\rm du}(T,U,1)=aT^2+bTU+cU^2+dT+eU+f.
\]
Since \(a_i(T)-a_j(T)=(y_i-y_j)-T(x_i-x_j)\), direct subtraction gives
\[
 \boxed{
 q_i(T)-q_j(T)
 =\bigl((y_i-y_j)-T(x_i-x_j)\bigr)\ell_{ij}(T),
 \quad
 \ell_{ij}(T)=\bigl(b-c(x_i+x_j)\bigr)T
                    +c(y_i+y_j)+e.}                    \tag{23z}
\]
The first factor vanishes at the ordinary chord direction \(t_{ij}\); the
second is a conic-balanced mirror direction.  If \(c\ne0\), it is the slope
joining \((x_i,y_i)\) to
\[
 \iota_Q(x_j,y_j)=\left(\frac bc-x_j,-\frac ec-y_j\right),
\]
where \(\iota_Q\) is the central involution about
\((b/(2c),-e/(2c))\).  The expression is symmetric in \(i,j\), as required.

Completing the square makes the two factors canonical.  Put
\[
 r_i(T)=y_i+\frac e{2c}
       -T\left(x_i-\frac b{2c}\right),
 \qquad
 \psi(T)=aT^2+dT+f-\frac{(bT+e)^2}{4c}.                \tag{23al}
\]
Then the centered fibre coordinate
\(\widetilde U=U+(bT+e)/(2c)\) gives
\[
 \boxed{
 Q_{\rm du}(T,U,1)=c\widetilde U^2+\psi(T),
 \qquad
 q_i(T)=c\,r_i(T)^2+\psi(T).}                          \tag{23am}
\]
Consequently
\[
 q_i-q_j=c(r_i-r_j)(r_i+r_j),
\]
where \(r_i-r_j\) is the ordinary chord factor and
\(c(r_i+r_j)=\ell_{ij}\) is the mirror factor.  The quadric involution
\(\jmath\) is simply \(\widetilde U\mapsto-\widetilde U\).

The three traces are therefore centered second moments.  If
\(\mathcal M_t\) is the ordinary matching, write \(r_e(t)\) for the common
centered intercept on an edge \(e\), and retain \(r_i(t)\) on unmatched
vertices.  Then
\[
 \boxed{
 \begin{aligned}
 L(t)&=c\sum_{i=1}^nr_i(t)^2+n\psi(t),\\
 \sigma_t&=c\sum_{e\in\mathcal M_t}r_e(t)^2+\mu_t\psi(t),\\
 \nu_t&=c\sum_{i\in I_t}r_i(t)^2+(n-2\mu_t)\psi(t).
 \end{aligned}}                                        \tag{23an}
\]
The identity \(L=2\sigma+\nu\) is now the partition of the centered second
moment into doubled matched values and unmatched values.  If
\(Q_{\rm du}(t,u_e)=\eta s_e^2\), every matched edge lies on the same binary
quadratic level set
\[
 \eta s_e^2-c\,r_e(t)^2=\psi(t).                       \tag{23ao}
\]
Thus the zero-trace gate is a constrained second-moment problem on one
common norm conic, while the mirror involution is its sign change in the
\(r\)-coordinate.  This is the simplest fibre model in which to compare the
ordinary and mirror incidence cycles.

The degree-two polynomial \(L\) is the endpoint inertia tensor about the
conic center.  Set
\[
 X_i=x_i-\frac b{2c},
 \qquad
 Y_i=y_i+\frac e{2c},
\]
and homogenize \(\psi\) in \((T,W)\).  Since
\(r_i(T,W)=Y_iW-X_iT\), equation (23an) becomes
\[
 \boxed{
 L(T,W)=c\sum_{i=1}^n(Y_iW-X_iT)^2+n\psi(T,W).}         \tag{23av}
\]
Equivalently, if
\[
 \mathsf I_B=
 \begin{pmatrix}
  \sum_iX_i^2&-\sum_iX_iY_i\\
  -\sum_iX_iY_i&\sum_iY_i^2
 \end{pmatrix},
\]
then the matrix of \(L\) is
\[
 \boxed{\operatorname{Mat}(L)=c\,\mathsf I_B
                         +n\,\operatorname{Mat}(\psi).} \tag{23aw}
\]
Thus the globally known part of the complementary trace law is precisely a
binary covariance/inertia form, not an arbitrary quadratic interpolant.  In
particular, perfect-matching fibres evaluate \(\sigma=L/2\) directly on this
tensor.  Any all-center covariance identity can now be compared with the
unmatched residual trace in the same centered coordinates.

The entire value polynomial is the norm for this sign involution.  Define
\[
 \mathcal A(Z,T)=\prod_{i=1}^n(Z-r_i(T)),
 \qquad
 \mathcal V(W,T)=\prod_{i=1}^n(W-r_i(T)^2).             \tag{23ap}
\]
Then
\[
 \boxed{
 (-1)^n\mathcal A(Z,T)\mathcal A(-Z,T)
   =\mathcal V(Z^2,T),
 \qquad
 \mathfrak F(V,T)
   =c^n\mathcal V\left(\frac{V-\psi(T)}c,T\right).}     \tag{23aq}
\]
Thus \(\mathfrak F\) is the invariant-theoretic quotient of the centered
endpoint arrangement by \(Z\mapsto-Z\).  Collisions before the quotient
split into equal-sign and opposite-sign pairs:
\[
 \boxed{
 \begin{aligned}
 \operatorname{disc}_Z\mathcal A
   &=\prod_{i<j}(r_i-r_j)^2
     \doteq(T^q-T)^2E_P^2,\\
 \operatorname{Res}_Z\bigl(\mathcal A(Z,T),
                    (-1)^n\mathcal A(-Z,T)\bigr)
   &=\prod_{i,j}(r_i+r_j)\\
   &=\left(\prod_i2r_i\right)
     \left(\prod_{i<j}(r_i+r_j)^2\right).
 \end{aligned}}                                        \tag{23ar}
\]
After multiplication by the fixed powers of \(c\), the off-diagonal square
in the second line is \(\Theta_Q^2\), while its diagonal factor is
\(\Delta_Q\).  Equations (23aa), (23ac), and (23ad) are therefore the
discriminant--resultant identities of one elementary \(\mathbb Z/2\)-norm,
not three unrelated eliminations.

At an ordinary matched edge, simultaneous vanishing of its ordinary and
mirror factors means \(r_i=r_j=0\): that node lies on the fixed axis of
\(\jmath\).  All other overlap between the ordinary and mirror covers comes
from distinct endpoint pairs becoming equal only after the sign quotient.
This separates fixed-axis overlap from genuine cross-pair overlap inside
\(K_{\rm mir}\), and gives a natural two-stage analysis of the remaining
mirror-support algebra.

The sign norm also commutes with the repeated/unmatched factorization.  On a
direction fibre define
\[
 \mathcal G_t(Z)=\prod_{e\in\mathcal M_t}(Z-r_e(t)),
 \qquad
 \mathcal H_t(Z)=\prod_{i\in I_t}(Z-r_i(t)).
                                                               \tag{23as}
\]
Then
\[
 \mathcal A(Z,t)=\mathcal G_t(Z)^2\mathcal H_t(Z).
\]
For a monic polynomial \(P\), let
\[
 \mathcal N_\pm(P)(W)
 =(-1)^{\deg P}P(Z)P(-Z)\big|_{Z^2=W}.
\]
This sign norm is multiplicative, and therefore
\[
 \boxed{
 \mathcal V(W,t)
 =\mathcal N_\pm(\mathcal G_t)(W)^2
  \mathcal N_\pm(\mathcal H_t)(W).}                    \tag{23at}
\]
Under \(V=\psi(t)+cW\), the two factors on the right become exactly
\(\mathfrak G_t(V)\) and \(\mathfrak H_t(V)\), up to their monic powers of
\(c\).  In particular, if
\[
 \mathcal G_t(Z)=Z^{\mu_t}+g_1^r(t)Z^{\mu_t-1}
                         +g_2^r(t)Z^{\mu_t-2}+\cdots,
\]
then
\[
 \boxed{
 \sigma_t
 =c\bigl((g_1^r(t))^2-2g_2^r(t)\bigr)+\mu_t\psi(t).}   \tag{23au}
\]
This is the centered form of (30), now obtained functorially as the first
coefficient of the sign norm of the repeated-root factor.  Mirror overlap
is precisely the failure of the sign norms in (23at) to keep the ordinary
root classes distinct: roots \(r\) and \(-r\) coalesce after descent to
\(W=r^2\).  Thus ordinary subresultants may be computed before taking the
sign norm, with the overlap correction supported exactly on \(K_{\rm mir}\).

Let \(\Theta_Q(T)=\prod_{i<j}\ell_{ij}(T)\).  Taking the discriminant of
(23x) in the value variable and using the direction factorization (8) gives
\[
 \boxed{
 \operatorname{disc}_V\mathfrak F(V,T)
 \doteq (T^q-T)^2E_P(T)^2\Theta_Q(T)^2.}                \tag{23aa}
\]
Thus equality of endpoint conic values has two completely explicit sources:
the original chord matching and the mirror matching against
\(\iota_Q(B)\).  Formula (23y) places the desired trace in the square factor
belonging to the first source, while (23aa) packages both sources globally.
Separating these two square divisors, rather than reconstructing every
fibre gcd, is a new structural route to \(\Upsilon_3\).

The mirror factor is itself a cross-resultant.  Assume \(c\ne0\) in the
chosen affine chart and form the reflected endpoint arrangement
\[
 F^\iota(U,T)=
 \prod_{j=1}^n
 \left(U+T\left(\frac bc-x_j\right)+\frac ec+y_j\right).
                                                               \tag{23ab}
\]
The intercept difference between the \(i\)-th original factor and the
\(j\)-th reflected factor is \(c^{-1}\ell_{ij}(T)\).  Hence, with
\(\Delta_Q(T)=\prod_i\ell_{ii}(T)\),
\[
 \boxed{
 \operatorname{Res}_U(F,F^\iota)
 \doteq\prod_{i,j}\ell_{ij}(T)
 =\Delta_Q(T)\Theta_Q(T)^2.}                            \tag{23ac}
\]
The off-diagonal factors occur twice because \(\ell_{ij}=\ell_{ji}\);
\(\Delta_Q\) records the directions joining an endpoint to its own
\(\iota_Q\)-image.  Equivalently, comparison of (8) and (23aa) gives
\[
 \boxed{
 \Theta_Q(T)^2
 \doteq
 \frac{\operatorname{disc}_V\mathfrak F(V,T)}
      {\operatorname{disc}_UF(U,T)}.}                  \tag{23ad}
\]
Thus the mirror cover can be constructed either as the off-diagonal square
part of one cross-resultant or as a quotient of two discriminants.

This mirror is induced by a global automorphism of the branched quadric, not
just by the endpoint-coordinate formula.  Homogenize
\[
 Q_{\rm du}
 =aT^2+bTU+cU^2+dTW+eUW+fW^2
\]
and define
\[
 \boxed{
 \jmath(T,U,W,z)
 =\left(T,-U-\frac{bT+eW}{c},W,z\right).}               \tag{23ag}
\]
Completing the square in \(U\) shows
\(Q_{\rm du}\circ\jmath=Q_{\rm du}\).  Hence \(\jmath\) is an involution of
\(\mathscr X_\eta\), it preserves every direction conic \(C_t\), and it
commutes with the deck involution \(z\mapsto-z\).  The image under
\(\jmath\) of the line
\(U+Tx_i-y_iW=0\) is precisely
\[
 U+T\left(\frac bc-x_i\right)
   +\left(\frac ec+y_i\right)W=0,
\]
the corresponding factor of \(F^\iota\).  Therefore \(\Theta_Q\) is the
off-diagonal direction divisor of intersections between the lifted endpoint
conics \(D_i\) and their \(\jmath\)-images; \(\Delta_Q\) is the diagonal
part.  The two commuting involutions generate a Klein four action on each
direction conic:
\[
 (U,z),\qquad
 \left(-U-\frac{bt+e}{c},z\right),\qquad
 (U,-z),\qquad
 \left(-U-\frac{bt+e}{c},-z\right).                    \tag{23ah}
\]
Ordinary chord nodes are intersections among the \(D_i\), while mirror
collisions are intersections between \(D_i\) and \(\jmath(D_j)\).  This
places both covers in one incidence geometry on \(\mathscr X_\eta\).  A
comparison of their off-diagonal intersection cycles, retaining the
\(z^2\)-trace before passing to character, is now the precise geometric
route to the missing cross-direction law.

The involution preserves the endpoint point types as well.  On line
coefficients it induces
\[
 \boxed{
 v_i=(x_i,1,-y_i)
 \longmapsto
 v_i^\iota=
 \left(\frac bc-x_i,1,\frac ec+y_i\right),
 \qquad
 Q_{\rm pr}(v_i^\iota)=Q_{\rm pr}(v_i).}                \tag{23ai}
\]
The last equality follows because the contragredient of an isometry of
\(Q_{\rm du}\) is an isometry of its adjugate form.  If \(B_{\rm pr}\) is
the polar form of \(Q_{\rm pr}\), the three-dimensional Lagrange identity
therefore gives parallel formulas for the ordinary and mirror intersection
values:
\[
 \begin{aligned}
 Q_{\rm du}(v_i\times v_j)
   &\doteq Q_{\rm pr}(v_i)Q_{\rm pr}(v_j)
              -B_{\rm pr}(v_i,v_j)^2,\\
 Q_{\rm du}(v_i\times v_j^\iota)
   &\doteq Q_{\rm pr}(v_i)Q_{\rm pr}(v_j)
              -B_{\rm pr}(v_i,v_j^\iota)^2.
 \end{aligned}                                         \tag{23aj}
\]
Here the projective proportionalities become the affine formulas after
division by the corresponding squared last coordinates, exactly as in
(32).  Hence the mirror cover carries a twisted copy of the same endpoint
Gram data, with no change in the internal/external type vector.  Comparing
the ordinary Gram matching sum with this reflected Gram matching sum is the
value-level refinement unavailable to the Euler-character projection.

The comparison is in fact a rank-two perturbation before affine
normalization.  Let \(\mathcal J\) be the involution on line vectors in
(23ai), and decompose the primal quadratic space orthogonally as
\[
 V=V_+\perp V_-,
 \qquad v=v^++v^-,
 \qquad \mathcal Jv=v^+-v^-.
\]
For the chosen sign of \(\mathcal J\), one has
\(\dim V_+=1\) and \(\dim V_-=2\).  Put
\[
 G^\pm_{ij}=B_{\rm pr}(v_i^\pm,v_j^\pm).
\]
Then
\[
 B_{\rm pr}(v_i,v_j)=G^+_{ij}+G^-_{ij},
 \qquad
 B_{\rm pr}(v_i,v_j^\iota)=G^+_{ij}-G^-_{ij}.
\]
If \(\mathcal L\) and \(\mathcal L^\iota\) are the ordinary and mirror
Lagrange-numerator matrices,
\[
 \mathcal L_{ij}=Q_iQ_j-B_{\rm pr}(v_i,v_j)^2,
 \qquad
 \mathcal L^\iota_{ij}
   =Q_iQ_j-B_{\rm pr}(v_i,v_j^\iota)^2,
\]
then
\[
 \boxed{
 \mathcal L^\iota-\mathcal L
 =4\,G^+\circ G^-,
 \qquad
 \operatorname{rank}(\mathcal L^\iota-\mathcal L)\le2.} \tag{23ak}
\]
Indeed \(G^+\) has rank at most one, so
\(G^+\circ G^-\) is a diagonal rescaling of \(G^-\), whose rank is at most
two.  Thus the mirror incidence does not introduce an unrelated Gram
system: it is a rank-two deformation of the ordinary one.  After restoring
the squared affine last-coordinate denominators, (23ak) gives a
low-rank homogeneous numerator identity for the two matching sums.  A
successful trace comparison should carry those denominators as line-bundle
weights rather than discard this rank bound.

More importantly, it isolates every accidental collision of conic values.
Formula (23z) says
\[
 q_i(t)=q_j(t)
 \quad\Longrightarrow\quad
 t=t_{ij}\ \text{or}\ \ell_{ij}(t)=0.
\]
If \(\Theta_Q(t)\ne0\), equality classes among the \(q_i(t)\) are therefore
exactly the matched endpoint pairs of direction \(t\).  Different matched
pairs cannot share a value, nor can a matched value equal an unmatched one,
because either event would give a second chord incident with an already
matched endpoint.  Since the characteristic is odd,
\[
 \boxed{
 \mathfrak G_t(V)
 =\gcd_V\bigl(\mathfrak F(V,t),\partial_V\mathfrak F(V,t)\bigr)
 \qquad(\Theta_Q(t)\ne0).}                              \tag{23ae}
\]

Put
\[
 K_{\rm mir}=\gcd(K_P,\Theta_Q),
 \qquad K_{\rm tr}=K_P/K_{\rm mir}.                     \tag{23af}
\]
Because \(K_P\) is squarefree, these are coprime reduced supports.  On the
transverse algebra \(\mathbb F_q[T]/(K_{\rm tr})\), the desired trace
\(\Sigma_3\) is the negative first coefficient of the canonical repeated
factor (23ae), obtainable stratumwise by ordinary subresultants of the
single global value polynomial \(\mathfrak F\).  Every failure of this clean
separation is confined to the mirror-overlap algebra
\(\mathbb F_q[T]/(K_{\rm mir})\).  This does not yet evaluate the trace
character on the transverse part, but it splits the geometric difficulty
from the algebraic extraction and identifies one explicit smaller support
for the former.

Equations (17) and (22) are the promised bridge between the residual
direction polynomial and conic type.  They do not yet give a sign
contradiction: one must use star realization or a new value-level
cross-center identity to control \(\chi(\sigma_t)\).  They reduce that task
to one explicit scalar per repeated direction.

There is also a canonical global version.  Regard
\[
 \sigma=\operatorname{Tr}_{A/B}(q_{\mathcal N})\in B      \tag{25}
\]
as the function \(t\mapsto\sigma_t\), and let \(\Sigma(T)\) be its unique
representative of degree less than \(q\) modulo \(T^q-T\).  Its norm is
\[
 \operatorname{N}_{B/\mathbb F_q}(\sigma)
 =\prod_{t\in\mathbb F_q}\sigma_t
 =\operatorname{Res}_T(T^q-T,\Sigma(T)).                 \tag{26}
\]
On a unique-direction fibre, \(\sigma_t=q_i\), so its character is the
fixed sign \(\epsilon\).  Consequently (26) separates the known unique
fibres from the unknown repeated-fibre trace characters.  It is the right
shape for an aggregate constraint, although the existing Euler-character
all-center norm is too coarse, as (33) below makes explicit.

More precisely, compose the \(B\)-valued forms with fibrewise summation
\(B\to\mathbb F_q\).  Their matrices are block diagonal over the slope
fibres.  If \(R_0=\{t:\mu_t\ge2\}\) and \(r=|R_0|\), then
\[
 \sum_{t\in R_0}(\mu_t-1)=\delta,
 \qquad
 \sum_{t\in R_0}\mu_t=\delta+r,                          \tag{27}
\]
and (22) gives the basis-independent discriminant character
\[
 \boxed{
 \chi(\operatorname{disc}\mathcal C_Q|_M)
 =\epsilon^{\delta+r}
  \prod_{t\in R_0}\chi(\sigma_t)^{\mu_t-2}.}             \tag{28}
\]
The Vandermonde factors disappear because they are squares.  In particular,
double fibres carry no unknown trace character at all; only fibres of
multiplicity at least three contribute to the product in (28).  The
character in (28) is independent of scaling the conic equation: scaling
\(Q\) by \(\lambda\) scales a block of dimension \(\mu-1\) by
\(\lambda^2\), changing its determinant by a square.  The
unweighted comparison is
\[
 \chi(\operatorname{disc}\mathcal C|_M)
 =\prod_{t\in R_0}\chi(\mu_t)^{\mu_t-2}.                 \tag{29}
\]
Thus the nonsaturated conic problem has been reduced further: it is enough
to control a single global discriminant character, or equivalently the
weighted product of trace characters in (28), rather than every node value.

That weighted product is itself a bounded resultant.  Take \(E_P\) monic
in the affine slope chart and define the second excess polynomial
\[
 J_P(T)=\frac{E_P(T)}{\operatorname{rad}E_P(T)}
       =\prod_{t\in R_0}(T-t)^{\mu_t-2},
 \qquad \deg J_P=\delta-r.                               \tag{34}
\]
Then the interpolation polynomial \(\Sigma\) from (26) satisfies
\[
 \operatorname{Res}_T(J_P,\Sigma)
 =\prod_{t\in R_0}\sigma_t^{\mu_t-2},                   \tag{35}
\]
and hence
\[
 \boxed{
 \chi(\operatorname{disc}\mathcal C_Q|_M)
 =\epsilon^{\delta+r}
  \chi\!\left(\operatorname{Res}_T(J_P,\Sigma)\right).} \tag{36}
\]
Thus the remaining conic character lives on a divisor of degree
\(\delta-r\), supported exactly where a direction has a third or later
chord.  Formula (36) is the nonsaturated analogue of quotienting the
saturated first-ghost space by its three-dimensional conic subspace.

The trace itself is accessible from the repeated-root polynomial.  If
\[
 G_t(U)=\prod_{i=1}^{\mu_t}(U-u_i)
       =U^{\mu_t}+g_1(t)U^{\mu_t-1}+g_2(t)U^{\mu_t-2}+\cdots
\]
and \(Q(t,U)=a(t)U^2+b(t)U+c(t)\), Newton's first two identities give
\[
 \sigma_t
 =a(t)\bigl(g_1(t)^2-2g_2(t)\bigr)
  -b(t)g_1(t)+\mu_tc(t).                                 \tag{30}
\]
Here \(G_t\) is the squarefree common-root factor of
\(F(U,t)\) and \(F_U(U,t)\).  Formula (30) identifies the exact first-two
subresultant data that the star realization must control; it introduces no
new enumeration.

The star realization gives a second exact formula for the same trace.  Write
the normalized line factors of \(F\) as coefficient vectors \(v_i\), let
\(A\) be a symmetric matrix for the primal conic form \(Q_{\rm pr}\), and
use \(A^\#=\operatorname{adj}(A)\) for the dual conic form
\(Q_{\rm du}\).  The node belonging to the pair \(\{i,j\}\) is represented
projectively by \(v_i\times v_j\).  The
three-dimensional Lagrange identity says
\[
 (v_i\times v_j)^{\mathsf T}A^\#(v_i\times v_j)
 =Q_{\rm pr}(v_i)Q_{\rm pr}(v_j)-B(v_i,v_j)^2,            \tag{31}
\]
where \(Q_{\rm pr}(v)=v^{\mathsf T}Av\) and
\(B(v,w)=v^{\mathsf T}Aw\).  If \(\mathcal M_t\) is the matching of endpoint
pairs whose chords have direction \(t\), let \(\omega_{ij}\ne0\) be the
last coordinate of \(v_i\times v_j\), so division by \(\omega_{ij}\) gives
the affine representative \((t,u,1)\).  Then
\[
 \boxed{\sigma_t
 =\sum_{\{i,j\}\in\mathcal M_t}
   \frac{Q_{\rm pr}(v_i)Q_{\rm pr}(v_j)-B(v_i,v_j)^2}
        {\omega_{ij}^2}.}                                \tag{32}
\]
In the coordinates of (6), \(\omega_{ij}=x_j-x_i\), up to the fixed sign
convention.  Thus the missing scalar is a square-normalized matching sum in
the conic Gram matrix.  Formula (32), rather than the abstract module alone,
is the concrete star input for the next obstruction.

These fibrewise matching sums have a canonical cross-direction
interpolation.  For \(t\in\mathbb F_q\), put
\[
 \Lambda_t(T)=1-(T-t)^{q-1}.
\]
This is the delta function of \(t\) on \(\mathbb F_q\).  Since every chord
pair belongs to exactly one direction, the degree-less-than-\(q\)
representative in (26) is
\[
 \boxed{
 \Sigma(T)=
 \sum_{i<j}Q_{\rm du}(t_{ij},u_{ij})\Lambda_{t_{ij}}(T).} \tag{37}
\]
Substituting the Lagrange identity (31) gives the endpoint-only formula
\[
 \boxed{
\Sigma(T)=\sum_{i<j}
 \frac{Q_{\rm pr}(v_i)Q_{\rm pr}(v_j)-B(v_i,v_j)^2}
      {\omega_{ij}^2}
 \left(1-(T-t_{ij})^{q-1}\right).}                       \tag{38}
\]
Thus the required trace polynomial is a single sum over all endpoint pairs;
the direction fibres no longer need to be separated or their gcds computed.
Equivalently, introduce the weighted Cauchy transform
\[
 \mathscr G_Q(Z)=\sum_{i<j}
   \frac{Q_{\rm du}(t_{ij},u_{ij})}{Z-t_{ij}}
 =\sum_t\frac{\sigma_t}{Z-t}.
\]
The finite-field Lagrange identity
\[
 1-(T-t)^{q-1}=-\frac{T^q-T}{T-t}
\]
turns (37) into the compact rational formula
\[
 \boxed{\Sigma(T)=-(T^q-T)\mathscr G_Q(T).}              \tag{38a}
\]
Thus the remaining scalars are exactly the residues of one endpoint-Gram
Cauchy transform.  A structural evaluation of that transform modulo
\(K_P\), rather than separate matching calculations, would settle both the
zero detector and the parity resultant.

Lucas' theorem for the all-\((p-1)\)-digit integer \(q-1\) gives
\[
 (T-t)^{q-1}=\sum_{m=0}^{q-1}T^mt^{q-1-m}.               \tag{39}
\]
Hence every coefficient of \(\Sigma\) is an ordinary conic-weighted slope
moment of the star nodes.  Since (36) depends only on \(\Sigma\bmod J_P\),
define the bounded Gram carrier
\[
 \boxed{
 \Sigma_J(T)\equiv\Sigma(T)\pmod {J_P},
 \qquad \deg\Sigma_J<\delta-r.}                          \tag{40}
\]
Then
\[
 \chi(\operatorname{disc}\mathcal C_Q|_M)
 =\epsilon^{\delta+r}
  \chi\!\left(\operatorname{Res}_T(J_P,\Sigma_J)\right). \tag{41}
\]
Equations (38)--(41) are the requested cross-direction law.  The remaining
problem is no longer to construct the trace: it is to evaluate the character
of one degree-\((\delta-r)\) resultant from the star endpoint relations.

The second excess also has a canonical module realization.  For \(d\ge0\),
let
\[
 \mathcal F_d=\sum_{a=0}^d U^a\pi^*B\subseteq A,
 \qquad
 M^{[d]}=A/\mathcal F_d.                                 \tag{42}
\]
On a fibre of size \(\mu\), the distinct intercepts make
\(1,U,\ldots,U^d\) have rank \(\min(d+1,\mu)\).  Therefore
\[
 \boxed{
 \dim M^{[d]}
 =\sum_t\max(\mu_t-d-1,0),}                              \tag{43}
\]
and slope multiplication on this quotient has characteristic polynomial
\[
 \boxed{
 E_P^{[d]}(Z)=
 \prod_{t\in\mathbb F_q}(Z-t)^{\max(\mu_t-d-1,0)}.}      \tag{44}
\]
More generally, if \(\varphi\in B\) and \(\Phi(T)\) represents it modulo
\(T^q-T\), then fibrewise scalar multiplication gives the norm identity
\[
 \boxed{
 \det(m_\varphi\mid M^{[d]})
 =\prod_t\varphi(t)^{\max(\mu_t-d-1,0)}
 =\operatorname{Res}_T(E_P^{[d]},\Phi).}                 \tag{44a}
\]
For \(d=0\), this recovers \(M\) and \(E_P\).  For \(d=1\), it gives the
canonical second-excess module
\[
 M^{[1]}=A/(\pi^*B+U\pi^*B),
 \qquad \dim M^{[1]}=\delta-r,
 \qquad E_P^{[1]}=J_P.                                  \tag{45}
\]
Because \(M^{[1]}\) remains a \(B\)-module, the trace function
\(\sigma\in B\) acts on it.  Fibrewise scalar multiplication gives
\[
 \boxed{
 \det(m_\sigma\mid M^{[1]})
 =\prod_t\sigma_t^{\max(\mu_t-2,0)}
 =\operatorname{Res}_T(J_P,\Sigma_J).}                  \tag{46}
\]
Thus the open conic character is the determinant of a canonical operator on
a canonical \((\delta-r)\)-dimensional module.  More generally, (42)--(44)
give an all-multiplicity excess filtration; they do not make any
\(M^{[d]}\) an algebra or make multiplication by \(U\) descend.
The spectral polynomials require no new elimination: they satisfy the
radical recursion
\[
 E_P^{[d+1]}
 =\frac{E_P^{[d]}}{\operatorname{rad}E_P^{[d]}}.         \tag{47}
\]

The filtration has one reduced support layer at a time.  For \(d\ge1\),
the natural quotient map gives
\[
 0\longrightarrow \mathcal F_d/\mathcal F_{d-1}
 \longrightarrow M^{[d-1]}
 \longrightarrow M^{[d]}\longrightarrow0,              \tag{47a}
\]
and the left term has one dimension over each direction with
\(\mu_t\ge d+1\), and zero dimensions elsewhere.  Consequently
\[
 \boxed{
 \det\!\left(Z-T\mid\mathcal F_d/\mathcal F_{d-1}\right)
 =\operatorname{rad}E_P^{[d-1]}
 =\prod_{\mu_t\ge d+1}(Z-t).}                           \tag{47b}
\]
Thus the multiplicity partition is the conjugate of the sequence of reduced
support lengths:
\[
 \boxed{
 \delta=\sum_{d\ge1}|\{t:\mu_t\ge d+1\}|.}             \tag{47c}
\]
This is an all-defect, all-multiplicity decomposition of the direction
quotient into reduced spectral layers.  It also proves that the construction
does not depend on translating or rescaling the intercept coordinate:
if \(U'=\alpha(T)U+\beta(T)\) with \(\alpha\in B^\times\), then triangular
binomial expansion gives
\(\sum_{a=0}^d(U')^aB=\sum_{a=0}^dU^aB\).

The same filtration is exactly what the all-center collision identity
measures.  For one projection put
\[
 \rho=\sum_t\binom{\mu_t}{2},
 \qquad s_d=|\{t:\mu_t\ge d+1\}|\quad(d\ge1).
\]
Since \(\binom\mu2=1+2+\cdots+(\mu-1)\), equations (43) and (47b) give
the equivalent identities
\[
 \boxed{
 \rho=\sum_{d\ge1}d\,s_d
      =\sum_{d\ge0}\dim M^{[d]}.}                       \tag{47g}
\]
In particular
\[
 \boxed{
 \delta\le\rho\le\binom{\delta+1}{2}.}                \tag{47h}
\]
The lower equality means that every repeated direction is double, while the
upper equality means that all excess is concentrated in one direction.
Thus the familiar defect-two alternatives \(\rho=2,3\) are the first case
of a uniform Hilbert-function statement.

The matching constraint sharpens the upper end.  Put
\(m=\lfloor n/2\rfloor\), so \(\mu_t\le m\), and write
\[
 \delta=a(m-1)+b,
 \qquad 0\le b<m-1.
\]
Convexity of \(x(x+1)/2\), applied to \(x_t=\mu_t-1\), gives
\[
 \boxed{
 \rho\le a\binom m2+\binom{b+1}{2}.}                   \tag{47j}
\]
Equality packs the excess into \(a\) fibres of size \(m\), one fibre of
size \(b+1\) when \(b>0\), and unique fibres everywhere else.

More importantly for the conic gate, (47g) starts with
\[
 \boxed{
 \rho-\delta=\sum_{d\ge1}\dim M^{[d]},
 \qquad
 \deg J_P=\dim M^{[1]}\le\rho-\delta.}                 \tag{47k}
\]
Thus collision energy above the all-double minimum pays directly for the
dimension of the unresolved resultant carrier.  Summed over deleted-point
centers, the all-center collision identity therefore bounds the total
second-excess dimension before any conic-value calculation is made.

There is a signed spectral form as well.  For a direction character
\(\varepsilon(t)\in\{1,-1\}\), let
\(C_d=\mathbb F_q[T]/(\operatorname{rad}E_P^{[d-1]})\).
Then, as an integer signed count and after reduction to \(\mathbb F_q\) as
an algebra trace,
\[
 \boxed{
 \sum_t\varepsilon(t)\binom{\mu_t}{2}
 =\sum_{d\ge1}d\sum_{\mu_t\ge d+1}\varepsilon(t)
 =\sum_{d\ge1}d\operatorname{Tr}_{C_d/\mathbb F_q}
                    (\varepsilon).}                    \tag{47i}
\]
Consequently the all-center collision law couples the reduced support
layers of the excess modules across deleted-point centers.  It controls the
multiplicity Hilbert functions, whereas the open resultant requires the
unprojected conic-value trace \(\sigma_t\); this pinpoints, uniformly in the
defect, the exact information lost by Euler-character projection.

There is a dual barycentric model for every layer.  Use the perfect trace
pairing on the split node algebra,
\[
 \langle a,f\rangle=\sum_{(t,u)\in\mathcal N}a(t,u)f(t,u).
\]
The annihilator of \(\mathcal F_d\) is
\[
 W^{[d]}=\left\{a\in A:
   \sum_{u\in\pi^{-1}(t)}a(t,u)u^r=0
   \text{ for every }t\text{ and }0\le r\le d\right\}, \tag{47d}
\]
so the pairing identifies
\[
 \boxed{(M^{[d]})^\vee\cong W^{[d]}.}                  \tag{47e}
\]
This is a node-edge chain model: \(\mathcal N\) is the edge set of the
complete endpoint graph, each slope fibre is a matching, and \(W^{[d]}\)
consists of edge weights whose first \(d+1\) intercept moments vanish on
every color matching.

It is also division-free up to the canonical barycentric weights inside
each fibre.  If
\(G_t(U)=\prod_{i=1}^{\mu_t}(U-u_i)\), the standard partial-fraction
identity gives
\[
 \boxed{
 W_t^{[d]}=
 \left\{
   \left(\frac{P(u_i)}{G_t'(u_i)}\right)_{i=1}^{\mu_t}:
   \deg P\le\mu_t-d-2
 \right\}.}                                             \tag{47f}
\]
The right side is zero when \(\mu_t\le d+1\).  Thus the nonsaturated excess
flag and the saturated ghost system have the same local mechanism:
Reed--Solomon moment annihilators represented by inverse derivatives of a
split polynomial.  What differs is the coupling.  In the saturated branch
one factor \(R\) couples all roots; here the endpoint graph and its
direction-matching coloring couple the fibrewise factors \(G_t\).

The scalar trace carrier is smaller still, because a resultant against
\(J_P\) uses values at its roots but no derivatives.  Put
\[
 K_P=\operatorname{rad}J_P
 =\prod_{\mu_t\ge3}(T-t),
 \qquad
 s=\deg K_P=|\{t:\mu_t\ge3\}|,                           \tag{48}
\]
If \(s=0\), then \(J_P=1\) and the determinant is already trivial.
Otherwise let \(\Sigma_3\) be the degree-less-than-\(s\) representative of
\(\Sigma\) modulo \(K_P\).  Then
\[
 \boxed{
 \operatorname{Res}(J_P,\Sigma_J)
 =\operatorname{Res}(J_P,\Sigma_3),
 \qquad \deg\Sigma_3<s\le\min(\delta-r,\lfloor\delta/2\rfloor).}
                                                               \tag{49}
\]
Thus multiplicities belong to the module \(M^{[1]}\) and to \(J_P\), while
the endpoint-pair scalar input lives only on the reduced support of
triple-or-higher directions.  Each such direction consumes at least two
units of \(\delta\), which gives the bound \(s\le\lfloor\delta/2\rfloor\)
in (49).
There is no need to construct the degree-\(q\) polynomial \(\Sigma\) before
making this reduction.  Since \(K_P\) is squarefree, its Lagrange idempotent
at a root \(t\) is
\[
 \ell_t^{K}(T)=\frac{K_P(T)}{(T-t)K_P'(t)}.
\]
Consequently the reduced trace has the direct bounded formula
\[
 \boxed{
 \Sigma_3(T)=
 \sum_{\mu_t\ge3}\sigma_t\ell_t^K(T)
 =\sum_{\substack{i<j\\ \mu_{t_{ij}}\ge3}}
 Q_{\rm du}(t_{ij},u_{ij})
 \frac{K_P(T)}{(T-t_{ij})K_P'(t_{ij})}.}                \tag{49a}
\]
The repeated terms with the same direction add to \(\sigma_t\).  Formula
(49a) is an endpoint-Gram interpolation of degree less than \(s\) from the
outset; all unique and merely double directions have disappeared before any
resultant is formed.
Equivalently, the reduced support algebra
\[
 C_3=\mathbb F_q[T]/(K_P)
   \cong\prod_{\mu_t\ge3}\mathbb F_q                 \tag{49b}
\]
has dimension \(s\), and the class of \(\Sigma_3\) is exactly the trace
vector \((\sigma_t)_{\mu_t\ge3}\).  Its norm is the universal zero detector
\[
 \boxed{
 N_{C_3/\mathbb F_q}(\Sigma_3)
 =\operatorname{Res}(K_P,\Sigma_3)
 =\prod_{\mu_t\ge3}\sigma_t.}                           \tag{49c}
\]
This separates invertibility of the trace vector from the multiplicity
weights carried by \(M^{[1]}\).

There is a final parity compression.  From (35),
\[
 \operatorname{Res}(J_P,\Sigma_3)=0
 \quad\Longleftrightarrow\quad
 \sigma_t=0\text{ for some }\mu_t\ge3.                  \tag{50}
\]
If the determinant is nonzero, even exponents \(\mu_t-2\) disappear under
quadratic character, so
\[
 \boxed{
 \chi\!\left(\operatorname{Res}(J_P,\Sigma_3)\right)
 =\prod_{\substack{t:\mu_t\ge3\\ \mu_t\text{ odd}}}
   \chi(\sigma_t).}                                      \tag{51}
\]
Thus the remaining nonsaturated theorem splits cleanly into two structural
claims: exclude zero conic-value traces on triple-or-higher fibres, and
control the product of trace signs only on odd-multiplicity fibres.
The latter has its own polynomial carrier.  Write the unique square-class
factorization
\[
 J_P=K_{\rm odd}L^2,
 \qquad
 K_{\rm odd}=\prod_{\substack{t:\mu_t\ge3\\
                              \mu_t\text{ odd}}}(T-t).  \tag{51a}
\]
Once the zero detector in (50) is nonzero, multiplicativity of the resultant
gives
\[
 \boxed{
 \chi\!\left(\operatorname{Res}(J_P,\Sigma_3)\right)
 =\chi\!\left(\operatorname{Res}(K_{\rm odd},\Sigma_3)\right).} \tag{51b}
\]
Thus \(K_P=\operatorname{rad}J_P\) is the support needed to detect
degeneracy, whereas the squarefree parity part \(K_{\rm odd}\) is the
strictly smaller support needed for the nonzero sign.  These roles must not
be conflated: a zero trace on an even-multiplicity fibre kills the original
determinant although it is absent from \(K_{\rm odd}\).

This also separates the present trace from the earlier all-center
Euler-character norm.  If the weights \(q_i\) in (20) are replaced by their
Euler signs \(q_i^{(q-1)/2}=\epsilon\), then
\[
 \mathcal C_{\chi(Q),t}=\epsilon^2\mathcal C_t=\mathcal C_t.
                                                               \tag{33}
\]
The character projection therefore erases precisely the value-level trace
\(\sigma_t\).  The existing all-center norm polynomial is compatible with
(28), but does not evaluate it.  A successful cross-center law must retain
the actual quadratic values in (31)--(32), not only their signs.

The exact next lemma can now be stated without a fixed defect:

> **Excess-module obstruction.**  No reduced star-node cover arising from a
> dual arc can have surjective slope map, constant conic square class (19),
> and the all-center covering identities in the nonsaturated regime.

A more modest first target is to control the global character (28), using
either the norm (26), the first-two repeated-root coefficients (30), or the
matching sum (32), through the star realization.  At \(\delta=2\) this
specializes to the old split quadratic residual, but (3)--(33) make the
statement uniform in \(\delta\).

## 6. Relation to the saturated complementary-factor reduction

The two current structural carriers have the same architecture:

| branch | forced Frobenius base | finite excess carrier | all-\(q\) target |
|---|---|---|---|
| saturated-internal | \(X^q-X=RS\) | \(\mathcal G_R=\mathcal V_R/\mathcal C_R\), dimension \(q/p-1\) | classify \(\mathcal K_R\), then use \(j=2\) for \(p\ne5\) or \(j=3\) for \(p=5\) |
| nonsaturated | one node over every root of \(T^q-T\) | filtered modules \(M^{[d]}\), with dual barycentric edge-chain spaces \(W^{[d]}\) | control the zero norm on \(K_P\) and the parity resultant on \(K_{\rm odd}\) from the conic-Gram matching sums |

In both cases the correct operation is quotienting on the Frobenius-fixed
finite base.  The residual statement is then finite-dimensional for a
structural reason, but its dimension is a formula in \(q\) or \(\delta\),
not a fixed search window.  This is the reusable pattern for the all-\(q\)
proof: forced Moore/Frobenius factor, canonical excess quotient, then a
Cartier or discriminant obstruction on that quotient.  Neither branch is
helped by extending the fixed-field census.

## EJ + TT closeout

**EJ.**  The residual polynomial \(E_P\) has acquired an intrinsic spectral
meaning: it is the characteristic polynomial of slope on the excess node
module.  This makes defect localization functorial and preserves intercepts
through the flag (11).

**TT.**  Do not treat \(M\) as an algebra or multiplication by \(U\) as an
endomorphism of the quotient; neither is canonical.  The canonical data are
the \(B\)-module, the slope operator, the distinguished intercept-power
classes, the covariance forms (14) and (20), and the square-class element in
the ambient split algebra \(A\).  An abstract \(\delta\)-module alone cannot
prove nonexistence.

## Mystery ledger

| feature | status | exact remaining boundary |
|---|---|---|
| Can the forced \(q\) directions be removed without choosing one node per fibre? | settled | quotient module (3) |
| What is \(E_P\) intrinsically? | settled | characteristic polynomial (5) |
| Are intercepts retained after compression? | settled | canonical flag (11)--(12) |
| Is there a canonical quadratic invariant without choosing means? | settled | covariance form (14) and determinant (17) |
| Where does the conic character live? | settled | square class (19) in the split node algebra |
| Can the conic class be coupled to the intercept flag canonically? | settled | weighted determinant (22), reduced globally to (28) |
| Is there an orthogonal model for the weighted form? | settled | square-root projector (23b); zero trace is isotropy (23c) |
| Are the square-root signs globally geometric? | settled | rational node lifts on the branched quadric \(\mathscr X_\eta\), formula (23d) |
| What divisor carries a direction trace? | settled | doubled repeated-node divisor (23e), with trace formula (23f) |
| Can the unknown product be bounded by defect? | settled | resultant (36) on the degree-\(\delta-r\) second excess polynomial \(J_P\) |
| Is the second excess intrinsic? | settled | module \(M^{[1]}\) and determinant identity (46) |
| Is there a carrier for every multiplicity layer? | settled | intercept-degree filtration (42)--(44) |
| Does every layer have a dual edge-chain model? | settled | moment-annihilator and fibrewise barycentric spaces (47d)--(47f) |
| How small is the scalar trace carrier? | settled | degree \(s\) support reduction \(\Sigma_3\) in (49) |
| Can \(\Sigma_3\) be formed without degree-\(q\) interpolation? | settled | direct reduced-support Lagrange formula (49a) |
| Which fibres affect the nonzero determinant character? | settled | only odd \(\mu_t\ge3\), formula (51) |
| Which arrangement data determine the remaining trace? | settled | first two repeated-root coefficients (30), equivalently the Gram matching sum (32) |
| Is there a cross-direction trace formula? | settled | endpoint-pair interpolation (38), reduced to \(\Sigma_J\) in (40) |
| Does the prior Euler-character norm determine this trace? | no | character projection gives the tautology (33) and loses the conic values |
| Does the abstract module force a contradiction? | no | must use star realization and covering identities |
| What is the uniform nonsaturated theorem target? | open | excess-module obstruction above |

## Next action

Evaluate the character of the bounded endpoint-pair resultant
\(\operatorname{Res}(J_P,\Sigma_3)\) in (49), using the star endpoint
relations in (38).  Preserve actual conic values: the Euler-character
projection (33) is too coarse.  First exclude the zero-trace case (50), then
prove the odd-fibre sign law (51), equivalently the parity resultant (51b).
Use the dual edge-chain model (47d)--(47f) and retain any coherent
 deck-sign law in the Gram square roots (23a), since (23c) turns zero
trace into isotropy.  Equivalently, derive a trace/residue law for the
section \(z^2\) on the hyperplane-conic pencil of \(\mathscr X_\eta\), using
the doubled-node divisor (23e).  Do not resolve this by a fixed-field census.
