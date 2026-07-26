# The Hitchin–Clebsch bridge

## Incidence double covers, cubic factorization memory, the golden arithmetic torsor, and reduction to \(T_{11}\)

**Date:** 25 July 2026  
**Status:** proof report and focused novelty audit  
**Scope:** the bridge between Hitchin’s degree-three spherical-harmonic geometry and the Clebsch factorization-memory/orientation program

---

## Executive summary

There is an exact bridge, but it is not an equality between two spatial sextic harmonics. The relevant object is Hitchin’s generically two-sheeted incidence map

\[
\pi:\mathcal I\longrightarrow \mathbf P(H_3),
\qquad
\mathcal I=\{(I,[f]):f\text{ vanishes on the axes of the icosahedron }I\},
\]

where \(H_3\) is the seven-dimensional space of harmonic cubics. Generically, an admissible harmonic cubic contains exactly two icosahedral axis sets. Their exchange is the deck involution. The branch divisor is Hitchin’s invariant sextic \(J=0\).

After one icosahedron \(I\) is marked, its four-dimensional vanishing space has Clebsch coordinates

\[
V_I=\left\{\sum_{\alpha=1}^{5}y_\alpha q_\alpha:\sum_\alpha y_\alpha=0\right\}.
\]

The branch divisor restricts to the Clebsch diagonal cubic

\[
\sigma_3(y)=0,
\qquad
\sigma_3=e_3(y_1,\ldots,y_5)=\frac13\sum_\alpha y_\alpha^3,
\]

with Hitchin’s exact square relation

\[
\boxed{J_0|_{V_I}=16\sigma_3^2.}
\]

Thus the global sextic remembers only the square of a cubic sheet coordinate. Once a sheet is marked, its square root is \(\pm4\sigma_3\). This is the characteristic-zero form of the factorization-memory hierarchy: the unmarked object forgets orientation, while the first oriented quantity is cubic.

The arithmetic specialization at

\[
f_0(x,y,z)=xyz
\]

is stronger. Its two icosahedra are

\[
I_t,\qquad t^2-t-1=0,
\]

so the incidence fibre is \(\operatorname{Spec}\mathbf Q(\sqrt5)\). Since \(J_0(f_0)\) is a rational square, the rational form of the incidence double cover is the quadratic twist

\[
\boxed{w^2=5J_0}
\]

up to the normalization of \(J_0\) and multiplication of the right side by a rational square.

Reducing modulo \(11\) gives \(t=4,8\), precisely the two golden sheets. The order-four rotation

\[
R=
\begin{pmatrix}
1&0&0\\
0&0&-1\\
0&1&0
\end{pmatrix}
\]

exchanges them, normalizes their common \(A_4\), and has nonsquare spinor norm over \(\mathbf F_{11}\). Under

\[
SO_3(11)/\Omega_3(11)
\cong
\mathrm{PGL}_2(11)/\mathrm{PSL}_2(11),
\]

it therefore represents the nontrivial element of \(T_{11}\). Consequently, on this fibre,

\[
\boxed{
\text{Hitchin sheet exchange}
=
\text{golden Galois exchange}
=
\text{outer }S_4/A_4\text{ hinge}
=
\text{nontrivial class in }T_{11}.
}
\]

Two parts are new deductions from established ingredients:

1. the arithmetic \(5\)-twist of the Hitchin incidence cover;
2. its explicit reduction to the determinant/spinor torsor at \(q=11\).

No exact prior statement of either was found in the focused search. That is evidence of likely novelty, not a definitive novelty certificate.

The most valuable remaining calculation is finite. The banked rank-ten signed cubic tensor should be compared with Hitchin’s ten-label cubic cycle tensor. If its restriction to the four-dimensional Clebsch summand is nonzero, representation-theoretic uniqueness forces it to be a scalar multiple of \(\sigma_3\), closing the identity

\[
J_0=c\,T_{\mathrm{signed}}^2.
\]

---

## 1. Context and distinction between the two sextics

Two degree-six objects occur in the surrounding program and must not be conflated.

### 1.1 The spatial icosahedral sextic

Starting from six icosahedral axes \(a_i\in\mathbf R^3\), one obtains degree-six polynomials in the spatial coordinates \(x,y,z\), including the classical Dye sextic

\[
\sum_{i=1}^{6}(a_i\cdot x)^6
\]

and its harmonic projection. Braden and Disney-Hogg describe Dye’s golden Clebsch hexagon

\[
(1,\pm j,0),\quad(0,1,\pm j),\quad(\pm j,0,1),
\qquad j^2-j-1=0,
\]

and the associated sextic pencil. This is a spatial \(l=6\) icosahedral harmonic construction.

The earlier signed-face calculation also produces a spatial sextic after substituting

\[
u_i=(a_i\cdot x)^2
\]

into a cubic in the six \(u_i\). That calculation lands in this classical Dye/icosahedral invariant line.

### 1.2 Hitchin’s coefficient-space sextic

Hitchin’s \(J\) is instead a degree-six polynomial on the seven-dimensional coefficient space \(H_3\) of harmonic cubics. Its variable is a cubic \(f\), not a spatial point \(x\). It detects how many icosahedral axis sets lie in the nodal cubic \(f=0\).

There is no natural literal identity

\[
\text{spatial }l=6\text{ harmonic}=J(f).
\]

The correct bridge is through:

- the same golden six-axis configuration;
- the Clebsch four-space \(V_I\);
- the ordered/unordered pair of nodal icosahedra;
- a cubic sheet coordinate whose square descends to \(J\);
- arithmetic specialization and reduction.

This distinction should be stated explicitly in any manuscript. It prevents the strongest new claim from being obscured by a classical invariant-theory coincidence.

---

## 2. Hitchin’s incidence geometry

Let \(U\) be a three-dimensional quadratic space and let

\[
H_3=\{f\in\operatorname{Sym}^3 U^*:\Delta f=0\}.
\]

Then \(\dim H_3=7\). For \(a\in U\), the harmonic projection of \((a,x)^3\) is

\[
f_a(x)=(a,x)^3-\frac35(a,a)(a,x)(x,x).
\]

For a regular icosahedron with opposite vertex pairs \(\pm a_1,\ldots,\pm a_6\), the span

\[
X_I=\langle f_{a_1},\ldots,f_{a_6}\rangle
\]

has dimension three and is isotropic for the natural three-dimensional space of skew forms on \(H_3\). Its orthogonal complement

\[
V_I=X_I^\perp
\]

is the four-dimensional space of harmonic cubics vanishing on the six axes.

Mukai’s Fano threefold compactifies the variety of such isotropic three-spaces. Hitchin’s later treatment packages this as the Mukai–Umemura threefold \(Z\), equipped with a universal rank-three bundle \(E\). A cubic \(f\in H_3\) gives a section of \(E^*\), and its zeros are precisely the isotropic three-spaces orthogonal to \(f\), hence the icosahedral sets on \(f=0\) on the nondegenerate open orbit.

Hitchin computes

\[
c_3(E^*)=2.
\]

Therefore a generic section has two zeros. This is the algebro-geometric degree-two statement underlying the incidence cover.

### Proposition 2.1: generic incidence degree

Let

\[
\mathcal I=\mathbf P(E^\perp)\longrightarrow Z
\]

be the projective bundle whose point over an isotropic three-space \(X\) is a cubic line \([f]\subset X^\perp\). The natural evaluation map

\[
\pi:\mathcal I\longrightarrow\mathbf P(H_3)
\]

is generically finite of degree two.

#### Proof

For fixed \([f]\), the fibre consists of zeros of the section of \(E^*\) induced by \(f\). On the open set where the zero scheme is transverse, its length is \(c_3(E^*)=2\). Hence the generic fibre has length two. \(\square\)

Hitchin further identifies the divisor on which the two points coalesce with an \(SO(3)\)-invariant sextic \(J=0\). Over the reals:

- \(J(f)>0\): two real icosahedra;
- \(J(f)<0\): no real icosahedron;
- \(J(f)=0\): generically one, with special positive-dimensional fibres on a lower-dimensional locus.

The algebraic double cover used below is the Stein factor of \(\pi\), restricted away from the loci where the incidence fibre is positive-dimensional and then normalized.

---

## 3. The marked Clebsch chart and the cubic square root

Fix an icosahedron \(I\). Its rotational \(A_5\) permutes five triples of mutually orthogonal planes containing all twelve vertices. Let their product cubics be

\[
q_1,\ldots,q_5.
\]

They satisfy

\[
\sum_{\alpha=1}^{5}q_\alpha=0
\]

and span \(V_I\). Write

\[
f=\sum_{\alpha=1}^{5}y_\alpha q_\alpha,
\qquad
\sum_{\alpha=1}^{5}y_\alpha=0.
\]

The blow-up of the six axes embeds as the Clebsch diagonal cubic surface

\[
\sum_{\alpha=1}^{5}y_\alpha^3=0.
\]

Since \(\sum y_\alpha=0\),

\[
\sum_\alpha y_\alpha^3=3e_3(y),
\]

so its equation may be written \(\sigma_3=e_3=0\).

Hitchin’s invariant computation gives, with a convenient algebraic normalization \(J_0\),

\[
\boxed{J_0(f)=16\sigma_3(y)^2\qquad(f\in V_I).}
\]

### Interpretation

The pullback of the global incidence double cover to the marked chart \(V_I\) splits geometrically:

- one component is the already marked icosahedron \(I\);
- the second component is the other icosahedron on \(f=0\).

Over an algebraic closure, a coordinate on the ordered cover satisfies

\[
w'^2=J_0.
\]

On the marked chart this factors as

\[
(w'-4\sigma_3)(w'+4\sigma_3)=0.
\]

Thus \(4\sigma_3\) is a local sheet coordinate. The deck involution sends

\[
w'\longmapsto-w',
\qquad
\sigma_3\longmapsto-\sigma_3
\]

when one changes which icosahedron is used to trivialize the cover.

### Proposition 3.1: uniqueness of the marked cubic

The space of \(A_5\)-invariant cubic forms on the four-dimensional standard module

\[
V_4=\{(y_1,\ldots,y_5):\sum y_i=0\}
\]

is one-dimensional, spanned by \(\sigma_3\).

#### Proof

An \(A_5\)-invariant polynomial decomposes under \(S_5/A_5\) into an \(S_5\)-invariant and a sign-isotypic part. A nonzero alternating polynomial in five variables is divisible by the Vandermonde determinant, of degree ten. Hence in degree three every \(A_5\)-invariant is already \(S_5\)-invariant. Modulo \(e_1=0\), the symmetric cubics are spanned by \(e_3\). \(\square\)

This proposition makes the final tensor comparison unusually rigid: any nonzero \(A_5\)-invariant cubic obtained from the banked signed tensor on the Clebsch four-summand must be proportional to Hitchin’s \(\sigma_3\).

---

## 4. The golden fibre \(f_0=xyz\)

Choose the standard orthogonal-plane cubic

\[
f_0(x,y,z)=xyz=q_1.
\]

For any root \(t\) of

\[
t^2-t-1=0,
\]

define six projective axes

\[
\begin{aligned}
a_1&=[0:t:1], &a_2&=[0:t:-1],\\
a_3&=[1:0:t], &a_4&=[-1:0:t],\\
a_5&=[t:-1:0],&a_6&=[-t:-1:0].
\end{aligned}
\]

Let \(I_t=\{a_1,\ldots,a_6\}\), representing the six opposite vertex pairs of a twelve-vertex configuration.

### Proposition 4.1: \(I_t\) is an icosahedral six-axis set

Assume \(\operatorname{char}k\ne2,5\) and \(t^2-t-1=0\). Then:

1. all six axes lie on \(xyz=0\);
2. all have the same norm \(t+2\);
3. for distinct axes,
   \[
   \frac{\langle a_i,a_j\rangle^2}
        {\langle a_i,a_i\rangle\langle a_j,a_j\rangle}
   =\frac15;
   \]
4. no three axes are collinear.

#### Proof

Every representative has a zero coordinate, so \(xyz=0\).

Using \(t^2=t+1\),

\[
\langle a_i,a_i\rangle=t^2+1=t+2.
\]

Every pairwise inner product is \(\pm t\). Moreover,

\[
(t+2)^2=t^2+4t+4=5(t+1)=5t^2.
\]

Therefore

\[
\frac{t^2}{(t+2)^2}=\frac15.
\]

For collinearity, direct expansion of the twenty \(3\times3\) determinants gives only the values

\[
\pm2t,\qquad \pm2(1+t)=\pm2t^2.
\]

These are nonzero under the stated characteristic assumptions. \(\square\)

The two roots

\[
t=\phi=\frac{1+\sqrt5}{2},
\qquad
t'=1-\phi=\frac{1-\sqrt5}{2}
\]

therefore give two icosahedra on \(xyz=0\), exchanged by the nontrivial automorphism of \(\mathbf Q(\sqrt5)/\mathbf Q\).

Hitchin proves that \(q_1\) has precisely these two icosahedral sets. Hence:

\[
\boxed{
\pi^{-1}([xyz])
\cong
\operatorname{Spec}\mathbf Q[t]/(t^2-t-1)
=
\operatorname{Spec}\mathbf Q(\sqrt5).
}
\]

---

## 5. Determination of the arithmetic twist

The geometric double cover is determined over an algebraic closure by the branch divisor \(J_0=0\). Over \(\mathbf Q\), its equation may differ by a constant quadratic twist.

### Proposition 5.1: the incidence cover is the \(5\)-twist

Let \(\widetilde{\mathbf P(H_3)}\to\mathbf P(H_3)\) be the normalized Stein factor of the icosahedral incidence map on the generic degree-two locus. Normalize the sextic so that

\[
J_0|_{V_I}=16\sigma_3^2.
\]

Then its quadratic function-field extension is

\[
\boxed{
\mathbf Q(\mathbf P(H_3))
\subset
\mathbf Q(\mathbf P(H_3))\bigl(\sqrt{5J_0}\bigr).
}
\]

Equivalently, the rational double cover is \(w^2=5J_0\), up to multiplying \(J_0\) by a rational square.

#### Proof

Over \(\overline{\mathbf Q}\), the extension is quadratic and ramified along \(J_0=0\). Two quadratic covers of \(\mathbf P^6\) with the same branch divisor differ by a constant square class: \(\operatorname{Pic}(\mathbf P^6)\cong\mathbf Z\) has no two-torsion, so a rational function with even valuation at every geometric divisor is a constant times a square.

It remains to determine the constant square class.

Represent \(q_1\) using coefficients whose sum is zero:

\[
q_1
=
\frac45q_1-\frac15(q_2+q_3+q_4+q_5).
\]

Thus

\[
y=\frac15(4,-1,-1,-1,-1).
\]

A direct calculation gives

\[
\sigma_3(y)=e_3(y)=\frac4{25}.
\]

Therefore

\[
J_0(q_1)=16\left(\frac4{25}\right)^2
=\left(\frac{16}{25}\right)^2,
\]

a rational square.

But Proposition 4.1 and Hitchin’s two-icosahedron theorem show that the incidence fibre over \(q_1=xyz\) is \(\mathbf Q(\sqrt5)\). Hence the constant twist class is \(5\in\mathbf Q^\times/\mathbf Q^{\times2}\). \(\square\)

### Centered golden coordinate

Put

\[
\epsilon=2t-1.
\]

Then

\[
\epsilon^2=4t^2-4t+1=5.
\]

The fibre coordinate can be normalized as

\[
w=\frac{16}{25}\epsilon,
\]

which satisfies

\[
w^2=5J_0(q_1).
\]

This makes the arithmetic content explicit: the golden field is the splitting field of the Hitchin incidence fibre.

### Caveat on scope

The proof determines the quadratic function field and the generic normalized double cover. A publication version should construct an integral model over a specified base such as \(\mathbf Z[1/10]\), identify all additional bad-reduction loci, and state precisely where the incidence map is finite étale. These are scheme-theoretic completion tasks, not gaps in the generic square-class calculation.

---

## 6. A finite-field Hitchin criterion

Proposition 5.1 immediately suggests a finite-field analogue of Hitchin’s real sign theorem.

### Corollary 6.1: generic finite-field fibre count

Let \(k=\mathbf F_q\) have odd characteristic different from \(5\). On an open set where the normalized incidence map is finite étale of degree two, a rational harmonic cubic \(f\) has

\[
\#\{\text{\(k\)-rational ordered icosahedral sets on }f\}
=
1+\chi_q(5J_0(f)),
\]

where \(\chi_q\) is the quadratic character and \(J_0(f)\ne0\).

Thus:

\[
\begin{array}{c|c}
\chi_q(5J_0(f))&\text{rational icosahedra}\\ \hline
+1&2\\
-1&0
\end{array}
\]

and the generic branch fibre has one geometric point with multiplicity two.

#### Proof

The fibre equation is \(w^2=5J_0(f)\). Over a finite field of odd order, a nonzero right-hand side has two roots when it is a square and no root when it is a nonsquare. \(\square\)

This result is potentially broader than the special Clebsch application. It converts Hitchin’s real sign condition into a Legendre-symbol criterion and provides a natural setting in which the factor \((5/q)\) appears.

For \(f_0=xyz\), \(J_0(f_0)\) is already a square, so the criterion reduces to

\[
\#I_{f_0}(\mathbf F_q)=1+\left(\frac5q\right).
\]

Hence the two golden sheets split exactly when \(5\) is a square, fuse over the quadratic extension when it is a nonsquare, and ramify in characteristic \(5\).

This explains the \((5/q)\) existence character in the later-paper ledger. It does not explain the distinct \((2/q)\) fusion character or the \((-1/q)\) Fourier character; keeping these mechanisms separate is a strength rather than a defect.

---

## 7. Reduction modulo \(11\)

Over \(\mathbf F_{11}\),

\[
t^2-t-1=(t-4)(t-8).
\]

Thus the two rational configurations are \(I_4\) and \(I_8\). Their centered selectors are

\[
2\cdot4-1=7=-4,
\qquad
2\cdot8-1=15=4.
\]

Each configuration is a six-arc by Proposition 4.1. The common normalized squared inner product is

\[
\frac15=9\pmod{11}.
\]

After choosing signs and normalizing, their Gram matrices have the Seidel form

\[
G=I+\frac1{\sqrt5}S,
\qquad
S^2=5I.
\]

### Comparison with the working Clebsch coordinates

The Clebsch six-arc used in the computational work was

\[
\begin{aligned}
A=\{&
[1:10:0],[1:9:1],[1:4:7],\\
&[1:8:5],[0:1:4],[1:1:7]\}.
\end{aligned}
\]

The matrices

\[
M_4=
\begin{pmatrix}
1&4&7\\
5&10&3\\
1&8&1
\end{pmatrix},
\qquad
M_8=
\begin{pmatrix}
4&5&5\\
9&10&7\\
4&7&10
\end{pmatrix}
\]

satisfy, by direct projective substitution,

\[
M_4I_4=A,
\qquad
M_8I_8=A.
\]

Their determinants are \(1\) and \(9\). Moreover,

\[
M_8^{-1}M_4
=
3
\begin{pmatrix}
1&0&0\\
0&0&-1\\
0&1&0
\end{pmatrix}.
\]

Thus the relative projective comparison is the same order-four rotation that exchanges the characteristic-zero golden conjugates.

This gives a concrete certificate that both Hitchin sheets reduce to the working Clebsch arc after the unmarked projective child forgets their relative orientation.

---

## 8. The order-four lift and the \(S_4/A_4\) hinge

Define

\[
R=
\begin{pmatrix}
1&0&0\\
0&0&-1\\
0&1&0
\end{pmatrix}.
\]

Then

\[
R^TR=I,\qquad\det R=1,\qquad R^4=I.
\]

Using \(1-t=-1/t\), direct substitution gives

\[
R(I_t)=I_{1-t}.
\]

Also,

\[
R^2=\operatorname{diag}(1,-1,-1),
\]

which stabilizes each \(I_t\), while

\[
R\cdot xyz=-xyz
\]

under the corresponding action on cubic forms. Therefore \(R\) fixes the projective cubic \([xyz]\) but exchanges its two icosahedral sheets.

Let

\[
G_t=\operatorname{Stab}_{SO_3}(I_t)\cong A_5.
\]

Then

\[
RG_tR^{-1}=G_{1-t}.
\]

The intersection contains the tetrahedral rotations fixing the orthogonal-plane cubic \(xyz\). Conversely, within \(G_t\), the stabilizer of the distinguished plane-triple cubic \(q_1\) has index five and is \(A_4\). Since the pair \(I_t,I_{1-t}\) determines \(q_1\) up to scalar,

\[
\boxed{G_t\cap G_{1-t}=A_4.}
\]

The signed coordinate-permutation rotations preserving \([xyz]\) form the octahedral group \(S_4\). Its index-two subgroup fixing the affine cubic \(xyz\) is \(A_4\), and \(R\) lies in the nontrivial coset:

\[
R\in S_4\setminus A_4.
\]

This supplies a characteristic-zero geometric model of the outer \(S_4/A_4\) hinge in the later-paper ledger.

---

## 9. Spinor norm and the determinant torsor at \(q=11\)

For odd \(q\),

\[
SO_3(q)\cong \mathrm{PGL}_2(q),
\qquad
\Omega_3(q)\cong \mathrm{PSL}_2(q).
\]

The quotient

\[
SO_3(q)/\Omega_3(q)
\]

is detected by the spinor norm and identifies with

\[
T_q=\mathrm{PGL}_2(q)/\mathrm{PSL}_2(q).
\]

### Proposition 9.1: \(R\) is the nontrivial class at \(q=11\)

The reduction of \(R\) modulo \(11\) has nonsquare spinor norm. Therefore it represents the nontrivial element of \(T_{11}\).

#### Proof

Let \(s_v\) denote reflection in the vector \(v\) for the form

\[
Q(x,y,z)=x^2+y^2+z^2.
\]

On the \(yz\)-plane,

\[
R=s_{e_2}\,s_{e_2-e_3}.
\]

The spinor norm is therefore

\[
\theta(R)=Q(e_2)Q(e_2-e_3)=1\cdot2=2
\quad\text{in}\quad
\mathbf F_{11}^{\times}/\mathbf F_{11}^{\times2}.
\]

The nonzero squares modulo \(11\) are

\[
\{1,3,4,5,9\},
\]

so \(2\) is nonsquare. Hence \(R\notin\Omega_3(11)\). \(\square\)

Equivalently, the Zassenhaus determinant expression gives the same square class:

\[
\det\!\left(\frac{I+R}{2}\right)=6,
\]

and \(6/2=3\) is a square modulo \(11\).

Since every homomorphism \(A_5\to C_2\) is trivial, both \(A_5\) stabilizers lie inside \(\Omega_3(11)\), while their exchanging hinge \(R\) lies outside it. Combining this with the banked theorem that the two \(A_5\) subgroups generate \(\mathrm{PSL}_2(11)\) gives the exact specialization

\[
\boxed{
\{\text{two Hitchin icosahedra on }xyz\}
\cong
\{4,8\}
\cong
T_{11}.
}
\]

This is stronger than observing that both are free \(C_2\)-sets: the explicit exchanging element maps to the nontrivial quotient class.

---

## 10. Why cubic moments are the first orientation-sensitive moments

Hitchin’s invariant calculation already contains a ten-label moment mechanism closely parallel to the rank-ten factorization-memory result.

The five cubics \(q_\alpha\) give ten unordered pairs

\[
e=\{\alpha,\beta\}.
\]

Geometrically these correspond to opposite pairs of icosahedral faces and to axes through their centres. Choose unit representatives \(v_{\alpha\beta}\) and define rank-one projectors

\[
P_{\alpha\beta}=v_{\alpha\beta}v_{\alpha\beta}^{T}.
\]

For

\[
f=\sum_\alpha y_\alpha q_\alpha,
\]

Hitchin constructs a symmetric matrix of the form

\[
M(y)=
\sum_{\alpha\ne\beta}
y_\alpha y_\beta P_{\alpha\beta}.
\]

The first two trace moments use

\[
\operatorname{tr}(P_e)=1,
\qquad
\operatorname{tr}(P_eP_f)=(v_e\cdot v_f)^2.
\]

They see only squared inner products and therefore forget all switching signs.

At degree three,

\[
\operatorname{tr}(P_eP_fP_g)
=
(v_e\cdot v_f)(v_f\cdot v_g)(v_g\cdot v_e).
\]

This is a Seidel switching-invariant triple product. It is exactly the type of signed triple quantity that distinguishes the two mirror/two-graph structures in the Clebsch calculations.

Writing \(\tau_i=e_i(M)\) for the elementary symmetric functions of the eigenvalues of \(M\), Hitchin’s cancellation is

\[
3\tau_3-4\tau_1\tau_2=16\sigma_3(y)^2.
\]

Since \(M\) is quadratic in \(y\), the left side is cubic in the ten pair weights and sextic in \(y\). Lower moment contributions cancel, leaving the square of the cubic orientation coordinate.

### Structural conclusion

The two programs have the same information-theoretic mechanism:

\[
\begin{array}{c|c|c}
\text{layer}&\text{Hitchin}&\text{factorization-memory program}\\ \hline
\text{unmarked object}&J_0&\text{even/unsigned quotient data}\\
\text{two sheets}&\text{two nodal icosahedra}&\text{two factorization sheets}\\
\text{moments 1--2}&\text{squared Gram data}&\text{unordered sheet recovery}\\
\text{moment 3}&\sigma_3\text{ after marking}&\text{signed cubic tensor}\\
\text{descent}&\sigma_3^2=J_0/16&\text{orientation erased after quotient}\\
\text{arithmetic fibre}&\mathbf Q(\sqrt5)&\text{golden orientation torsor}\\
\text{mod }11&T_{11}&T_{11}
\end{array}
\]

What is already proved is the equality of architecture, the arithmetic torsor, and the transformation law. Equality of the two particular cubic tensors remains a finite comparison.

---

## 11. Exact remaining tensor test

Let \(W\) be the banked rank-ten \(A_5\)-module carrying the signed third-moment tensor

\[
T_{\mathrm{sgn}}\in\operatorname{Sym}^3(W^*).
\]

The expected permutation-module decomposition is

\[
W\cong 1\oplus4\oplus5.
\]

The four-dimensional summand is the Clebsch module

\[
V_4=\{(y_1,\ldots,y_5):\sum y_i=0\}.
\]

The following calculation would close the strongest form of the bridge.

### Tensor comparison protocol

1. Construct the \(A_5\)-action matrices on \(W\).
2. Project to the \(4\)-isotypic component using
   \[
   e_4=\frac4{60}\sum_{g\in A_5}\chi_4(g)g,
   \]
   with character values
   \[
   \chi_4=(4,0,1,-1,-1)
   \]
   on \(1,2A,3A,5A,5B\).
3. Restrict \(T_{\mathrm{sgn}}\) to \(e_4W\).
4. Evaluate it on one generic vector.

If the evaluation is nonzero, Proposition 3.1 gives

\[
T_{\mathrm{sgn}}|_{e_4W}=c\,\sigma_3
\]

for a unique nonzero scalar \(c\). One further evaluation determines \(c\), and then

\[
\boxed{
J_0|_{V_4}=\frac{16}{c^2}
\left(T_{\mathrm{sgn}}|_{V_4}\right)^2.
}
\]

### Alternative orbit-table test

Hitchin’s cubic cycle tensor is

\[
C(e,f,g)=
(v_e\cdot v_f)(v_f\cdot v_g)(v_g\cdot v_e)
\]

on ten unordered-pair labels. Both \(C\) and \(T_{\mathrm{sgn}}\) are determined by their values on \(A_5\)-orbits of triples of labels. Comparing the finite orbit-value tables may be simpler than constructing an explicit intertwiner first.

### Required input

The pasted results inventory establishes nonvanishing of the signed cubic tensor but does not include the rank-ten coordinates or \(A_5\)-action matrices. Those data are the only missing computational input.

---

## 12. Publication recommendations

### 12.1 Recommended principal theorem for Paper III

The best organizing statement is:

> **Arithmetic Hitchin–Clebsch orientation theorem.**  
> The generically quadratic incidence cover of harmonic cubics by ordered nodal icosahedra is the \(5\)-twist of Hitchin’s sextic cover. On a marked Clebsch chart its sheet coordinate is the unique invariant cubic \(\sigma_3\); the fibre over \(xyz\) is \(\operatorname{Spec}\mathbf Q(\sqrt5)\); and reduction modulo \(11\) identifies its deck exchange with the nontrivial element of \(\mathrm{PGL}_2(11)/\mathrm{PSL}_2(11)\).

This theorem would organize:

- the determinant-sign torsor;
- the characteristic-zero golden object;
- the \(S_4/A_4\) hinge;
- the two \(A_5\) parents;
- cubic orientation memory;
- the distinction between marked and unmarked passages;
- the mod-\(11\) realization.

It is a stronger principal theorem than a catalogue of passages because it supplies one object whose specializations account for several of them.

### 12.2 Prove the integral form

Construct the incidence correspondence and its Stein factor over

\[
\mathbf Z[1/10]
\]

or the largest justified base. Determine:

- the exact discriminant divisor;
- whether \(J_0\) remains reduced in each characteristic;
- the exceptional loci where the incidence fibre is positive-dimensional;
- degeneration in characteristics \(2\) and \(5\);
- whether characteristic \(3\) introduces normalization issues.

This would promote the square-class calculation to a clean arithmetic theorem.

### 12.3 State and prove the finite-field Hitchin theorem

On the finite étale locus, prove

\[
\#I_f(\mathbf F_q)=1+\chi_q(5J_0(f)).
\]

This is potentially useful beyond the Clebsch case. It gives an explicit finite-field discriminant criterion for rational icosahedral decompositions of harmonic cubics.

### 12.4 Close the rank-ten tensor comparison

This is the highest-EV short calculation. A nonzero four-summand projection immediately forces equality with \(\sigma_3\). If it succeeds, the factorization-memory cubic becomes an explicit finite avatar of the square root of Hitchin’s \(J\).

### 12.5 Integrate the order-four lift

The explicit matrix \(R\) should be compared with:

- the canonical \(C_4\)-companion torsor;
- the characteristic-zero quaternion comparison matrix;
- the outer \(S_4/A_4\) hinge;
- the Hadamard row–column exchange.

The correct claim is not automatically that all order-four operations coincide. The first test is whether their squares, spinor norms, and actions on the two \(A_5\) parents agree.

### 12.6 Keep three characters separate

The Hitchin bridge naturally explains \((5/q)\), the existence/splitting character of the golden fibre. It does not by itself explain \((2/q)\) or \((-1/q)\). A paper should present this separation explicitly:

\[
\begin{array}{c|c}
(5/q)&\text{Hitchin/golden incidence splitting}\\
(2/q)&\text{finite fusion or hinge behaviour}\\
(-1/q)&\text{Fourier phase}
\end{array}
\]

An eventual theorem relating all three should arise from a biquadratic or quaternionic refinement, not by identifying the characters prematurely.

### 12.7 Do not headline the spatial sextic as new

The golden six-axis sextic and its harmonic projection are already in the Dye/Bring-curve literature. The new claim is the route from finite factorization memory to Hitchin’s coefficient-space incidence cover and its arithmetic reduction.

---

## 13. Significance assessment

| Result | Status | Specialist significance | Novelty confidence |
|---|---|---:|---:|
| Hitchin double cover and \(J_0|_{V_I}=16\sigma_3^2\) | Classical, explicitly in Hitchin | 9/10 historically | not new |
| Golden fibre \(\pi^{-1}(xyz)=\operatorname{Spec}\mathbf Q(\sqrt5)\) | Deduction from explicit axes and Hitchin’s count | 7.5/10 | medium-high |
| Global arithmetic twist \(w^2=5J_0\) | Proved generically here | 8.5–9/10 | medium |
| Mod-\(11\) spinor-norm identification with \(T_{11}\) | Proved here plus standard \(SO_3/PGL_2\) identification | 9/10 | medium-high |
| Order-four geometric lift \(R\) of sheet exchange | Explicitly proved here | 8/10 | medium |
| Finite-field count \(1+\chi_q(5J_0(f))\) on the étale locus | Immediate corollary of the integral cover | 8.5/10 if integral model is completed | medium |
| Identification of the banked signed tensor with \(\sigma_3\) | Open finite comparison | 9–9.5/10 if successful | unknown |

These are specialist scores, not “Annals-level” scores. The combined theorem could support a strong algebraic-geometry/finite-geometry paper, especially if the integral model and tensor comparison are completed. It is unlikely to be an Annals headline by itself without a broader theorem—for example, a general arithmetic theory of polyhedral incidence covers or a new structural result about Mukai–Umemura reductions.

---

## 14. Literature search

### 14.1 Search scope

The search targeted:

- Hitchin’s sextic invariant, two-icosahedron theorem, and marked Clebsch chart;
- the Mukai–Umemura incidence interpretation;
- golden Clebsch hexagons and Dye’s sextic pencil;
- rational or finite-field forms of the Hitchin cover;
- \(SO_3(q)\cong PGL_2(q)\), \(\Omega_3(q)\cong PSL_2(q)\), and spinor norms;
- \(A_5\), \(A_4\), and outer fusion in \(PGL_2(11)\);
- two \(A_5\)-equivariant blowdowns/double-sixes of the Clebsch cubic;
- any explicit occurrence of the equation \(w^2=5J\), the roots \(4,8\), or a Hitchin–\(T_{11}\) identification.

Representative query families included:

- `"Spherical harmonics and the icosahedron" Clebsch sigma_3 J`
- `"Vector bundles and the icosahedron" Mukai Clebsch`
- `"Hitchin" "Q(sqrt(5))" icosahedron Clebsch`
- `"Spherical harmonics and the icosahedron" finite fields`
- `"golden Clebsch hexagon"`, `"Dye sextic"`
- `SO(3,q) PGL(2,q) Omega(3,q) PSL(2,q)`
- `spinor norm det((1+g)/2)`
- `PGL2(11) A5 A4 outer automorphism`
- `PSL2(11) two A5 subgroups intersection A4`

### 14.2 Reading-depth codes

| Code | Detail |
|---|---|
| D4 | full relevant theorem chain and calculations read |
| D3 | abstract, introduction, relevant sections, theorem statements, and local proofs read |
| D2 | relevant passages and metadata read |
| D1 | metadata, abstract, or search snippets only |
| U | potential hit located but relevant full text unavailable |

### 14.3 Sources inspected

| Source | Depth | What was checked |
|---|---:|---|
| Hitchin, *Spherical harmonics and the icosahedron* | D4 | definition of \(J\); two/zero/one icosahedron theorem; four-space \(V_I\); Clebsch surface; double-cover argument; appendix proving \(J|_V=16\sigma_3^2\); ten face-pair moment calculation |
| Hitchin, *Vector bundles and the icosahedron* | D3 | Mukai–Umemura threefold; universal bundle; \(c_3(E^*)=2\); generic two-zero incidence; degenerate strata; tangential intersection with the Clebsch cubic |
| Mukai, *Fano 3-folds* | D2 | construction context for the relevant Fano threefold and bibliographic verification |
| Braden–Disney-Hogg, *Bring’s curve: old and new* | D3 | Dye’s \(j^2-j-1\) Clebsch hexagon; spatial sextic pencil; fields of definition; relation to Bring’s curve |
| Dye, *Hexagons, Conics, \(A_5\) and \(PSL_2(K)\)* | U/D1 | exact metadata and citations located; publisher full text was paywalled; no claim from the inaccessible body was used as proof |
| Prokhorov, arXiv:2411.15334 | D2 | two \(A_5\)-equivariant blowdowns of the Clebsch cubic switched by \(S_5\setminus A_5\); adjacent to the sheet-exchange picture but not the Hitchin arithmetic twist |
| Dolgachev, *Quartic surfaces with icosahedral symmetry* | D2 | two outer-related three-dimensional \(A_5\)-representations; Clebsch realization; adjacent invariant-theory context |
| Borovik–Yalçınkaya, *Natural representations of black box groups \(SL_2(\mathbb F_q)\)* | D2 | explicit \(SO_3(K)\leftrightarrow PGL_2(K)\) construction and restriction to \(\Omega_3/PSL_2\) |
| Murray–Roney-Dougal, *Constructive homomorphisms for classical groups* | D1/D2 | general quotient-by-\(\Omega\) and spinor-norm context; the report’s calculation instead uses an elementary two-reflection factorization |
| Giudici, *Maximal subgroups of almost simple groups with socle \(PSL(2,q)\)* | D1/D2 | fusion of \(A_5\) classes under \(PGL_2(q)\) and \(A_4\) containment; no exact Hitchin specialization found |
| Kundu, *Generating vectors of the finite groups \(PSL_2(\mathbb F_7)\) and \(PSL_2(\mathbb F_{11})\)* | D1/D2 | subgroup inventory for \(PSL_2(11)\), including its \(A_5\) maximal subgroups |

### 14.4 Findings

The following are clearly prior art:

1. the generic pair of icosahedra on a harmonic cubic;
2. the sextic branch invariant \(J\);
3. the Clebsch surface as the one/infinite-icosahedron locus in a marked four-space;
4. the exact restriction \(J|_V=16\sigma_3^2\);
5. the golden Clebsch hexagon with parameter \(j^2-j-1=0\);
6. the spatial Dye sextic pencil;
7. the exceptional group isomorphisms involving \(SO_3(q)\), \(\Omega_3(q)\), \(PGL_2(q)\), and \(PSL_2(q)\).

The search did **not** locate an explicit statement of:

1. the rational Hitchin incidence cover as the \(5\)-twist \(w^2=5J_0\);
2. the fibre over \(xyz\) being used to determine that global twist;
3. the reduction \(t=4,8\) being identified with a Clebsch-code orientation pair;
4. the sheet-exchanging rotation having nontrivial spinor norm and realizing \(T_{11}\);
5. the factorization-memory signed cubic being compared with Hitchin’s ten-label cubic cycle tensor;
6. the finite-field fibre formula \(1+\chi_q(5J_0(f))\).

### 14.5 Potential prior-art risks

1. **Dye 1991 was not fully accessible.** It is the largest classical risk for explicit finite-field hexagon/arithmetic statements. Its title explicitly includes \(PSL_2(K)\).
2. **Mukai–Umemura arithmetic forms may contain the twist implicitly.** The searched Hitchin and Mukai texts work principally over \(\mathbf C\) or \(\mathbf R\); a specialist source on rational forms of the Mukai–Umemura threefold could encode the same square class without using Hitchin’s \(J\).
3. **Classical invariant theory of binary sextics may express the double cover differently.** Hitchin’s second paper translates the sextic to Igusa invariants. A rational-form statement may be hidden under binary-sextic covariants.
4. **Finite-group subgroup fusion is classical.** The novelty cannot be the abstract existence of \(A_5\), \(A_4\), or the \(PGL_2/PSL_2\) quotient. It is their identification with this particular Hitchin incidence fibre.

The appropriate current language is therefore:

> The arithmetic twist and finite Clebsch-torsor specialization were not found in the searched sources and appear new, subject especially to a specialist check of Dye and the arithmetic Mukai–Umemura literature.

---

## 15. BibTeX

```bibtex
@incollection{Hitchin2009Spherical,
  author    = {Nigel Hitchin},
  title     = {Spherical Harmonics and the Icosahedron},
  booktitle = {Groups and Symmetries: From Neolithic Scots to John McKay},
  series    = {CRM Proceedings \& Lecture Notes},
  volume    = {47},
  pages     = {215--231},
  publisher = {American Mathematical Society},
  address   = {Providence, RI},
  year      = {2009},
  eprint    = {0706.0088},
  archivePrefix = {arXiv},
  primaryClass  = {math.AG},
  doi       = {10.48550/arXiv.0706.0088}
}

@incollection{Hitchin2010VectorBundles,
  author    = {Nigel Hitchin},
  title     = {Vector Bundles and the Icosahedron},
  booktitle = {Vector Bundles and Complex Geometry},
  series    = {Contemporary Mathematics},
  volume    = {522},
  pages     = {71--88},
  publisher = {American Mathematical Society},
  address   = {Providence, RI},
  year      = {2010},
  eprint    = {0906.4208},
  archivePrefix = {arXiv},
  primaryClass  = {math.AG},
  doi       = {10.48550/arXiv.0906.4208}
}

@incollection{Mukai1992Fano,
  author    = {Shigeru Mukai},
  title     = {Fano 3-Folds},
  booktitle = {Complex Projective Geometry},
  series    = {London Mathematical Society Lecture Note Series},
  volume    = {179},
  pages     = {255--263},
  publisher = {Cambridge University Press},
  address   = {Cambridge},
  year      = {1992}
}

@article{Dye1991Hexagons,
  author  = {R. H. Dye},
  title   = {Hexagons, Conics, {$A_5$} and {$PSL_2(K)$}},
  journal = {Journal of the London Mathematical Society},
  series  = {2},
  volume  = {44},
  number  = {2},
  pages   = {270--286},
  year    = {1991},
  doi     = {10.1112/jlms/s2-44.2.270}
}

@article{BradenDisneyHogg2024Bring,
  author  = {H. W. Braden and Linden Disney-Hogg},
  title   = {Bring's Curve: Old and New},
  journal = {European Journal of Mathematics},
  volume  = {10},
  pages   = {3},
  year    = {2024},
  doi     = {10.1007/s40879-023-00706-0},
  eprint  = {2208.13692},
  archivePrefix = {arXiv},
  primaryClass  = {math.AG}
}

@article{Dolgachev2018Quartic,
  author  = {Igor V. Dolgachev},
  title   = {Quartic Surfaces with Icosahedral Symmetry},
  journal = {Advances in Geometry},
  volume  = {18},
  number  = {1},
  pages   = {119--132},
  year    = {2018},
  doi     = {10.1515/advgeom-2017-0040}
}

@article{BorovikYalcinkaya2025Natural,
  author  = {Alexandre Borovik and {\c{S}}{\"u}kr{\"u} Yal{\c{c}}{\i}nkaya},
  title   = {Natural Representations of Black Box Groups {$SL_2(\mathbb F_q)$}},
  journal = {Axioms},
  volume  = {14},
  number  = {12},
  pages   = {895},
  year    = {2025},
  doi     = {10.3390/axioms14120895},
  eprint  = {2001.10292},
  archivePrefix = {arXiv},
  primaryClass  = {math.GR}
}

@misc{MurrayRoneyDougal2010Constructive,
  author  = {Scott H. Murray and Colva M. Roney-Dougal},
  title   = {Constructive Homomorphisms for Classical Groups},
  year    = {2010},
  eprint  = {1009.1672},
  archivePrefix = {arXiv},
  primaryClass  = {math.GR}
}

@misc{Giudici2007Maximal,
  author  = {Michael Giudici},
  title   = {Maximal Subgroups of Almost Simple Groups with Socle {$PSL(2,q)$}},
  year    = {2007},
  eprint  = {math/0703685},
  archivePrefix = {arXiv},
  primaryClass  = {math.GR}
}
```

---

## 16. Bottom line

The strongest defensible conclusion is:

\[
\boxed{
\text{The golden Clebsch orientation torsor is a finite arithmetic fibre of Hitchin’s ordered-icosahedron double cover.}
}
\]

Hitchin supplies the geometric double cover and the local square

\[
J_0=16\sigma_3^2.
\]

The golden fibre determines its rational twist to be \(5\). Reduction modulo \(11\) turns the Galois pair into the roots \(4,8\), and the explicit order-four exchanger has nonsquare spinor norm, so its sheet bit is exactly \(T_{11}\).

The remaining step needed for a completely unified theorem is to show that the banked signed cubic tensor projects nontrivially to the Clebsch four-module. If it does, uniqueness forces it to be Hitchin’s cubic square root.
