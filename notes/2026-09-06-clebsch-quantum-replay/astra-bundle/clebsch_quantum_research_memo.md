# Clebsch → quantum
## From quadratic trades to certified, coupled cubic-phase resources

**Research memo — 4 September 2026**  
**Prepared for Tavis Rudd**  
**Status:** explicit derivations and exact finite-field computations; not an independent peer review or an established novelty claim.

## Executive findings

The connection survives the full calculation, but its correct interpretation is **a small-block factory for a coupled non-Clifford gate**, not a factory for six or ten independent magic states.

Starting from the two matching configurations in *Quadratic Trade Rigidity and Cubic Orientation in Conic Matching Quotients* [R1], the construction gives:

| Field | Quantum code | X distance | Z distance | Logical resource |
|---|---:|---:|---:|---|
| $\mathbb F_7$ | $[[14,6,2]]_7$ | $6$ | $2$ | A six-qudit cubic phase |
| $\mathbb F_{11}$ | $[[22,10,2]]_{11}$ | $8$ | $2$ | A ten-qudit cubic phase |

Here “X distance” and “Z distance” mean the minimum weights of nontrivial pure-X and pure-Z logical operators. The quantum distance is their minimum, not their maximum.

The substantive outcomes are:

1. **The codes and transversal gates are explicit.** Their matrices, logical phase polynomials, complete ordinary weight enumerators, and a reproducible verifier accompany this memo. The finite examples were reconstructed independently from the base matchings; the quantum results do not require accepting the manuscript’s all-field classification.
2. **The logical gates have invariant-theoretic normal forms.** Over $\mathbb F_7$, the phase is $4sI+3J$, with $I,J$ the familiar quadratic and cubic invariants of a binary quartic in a stated normalization. Over $\mathbb F_{11}$, the phase is $4sI_2+2I_3$ for explicitly normalized binary-octavic invariants.
3. **The resources are genuinely different from independent cubic-phase states.** Neither is Clifford-equivalent to a tensor product containing even one nontrivial single-qudit cubic-phase factor. A short Hessian-rank certificate and a quadratic-Gauss-sum argument prove this. This does not prohibit extraction by measurement.
4. **The native resource preparation has exact quadratic error suppression.** Under independent, uniformly distributed nonzero Z errors on the injected magic states and ideal Clifford operations, its conditional block infidelity is $\frac{91}{6}\delta^2+O(\delta^3)$ or $\frac{231}{10}\delta^2+O(\delta^3)$, respectively. Exact formulas are given below.
5. **Two apparent development routes are blocked.** The unchanged evaluation space permits only one X-check direction compatible with this cubic phase. Also, the paper’s noncoalescent fixed-line deformations give the same physical evaluation code, not a new quantum-code family.

The strongest next research target is **certified synthesis and resource conversion for these two invariant-defined gates**. Neither a magic-state yield advantage nor a hardware-level commercial advantage has been demonstrated.

---

## 1. Conventions and the exact finite input

All linear algebra below is over $\mathbb F_p$, with $p\in\{7,11\}$. Put $n=2p$ and $k=p-1$. Vectors in the physical computational basis are columns in $\mathbb F_p^n$.

For $a,b\in\mathbb F_p^n$, define

$$
X(a)|z\rangle=|z+a\rangle,\qquad
Z(b)|z\rangle=\omega^{b^Tz}|z\rangle,\qquad
\omega=e^{2\pi i/p}.
$$

Thus $Z(b)X(a)=\omega^{b^Ta}X(a)Z(b)$.

The two configurations supply a matrix $E\in\mathbb F_p^{n\times k}$, with distinct rows $x_i^T$, and signs

$$
\epsilon=(\underbrace{1,\ldots,1}_{p},
            \underbrace{-1,\ldots,-1}_{p})^T,
\qquad D=\operatorname{diag}(\epsilon).
$$

Define the affine evaluation space

$$
L=\{a\mathbf1+Eu:a\in\mathbb F_p,\ u\in\mathbb F_p^k\}
\subseteq\mathbb F_p^n,
$$

and the row generator matrix

$$
G=\begin{pmatrix}\mathbf1^T\\E^T\end{pmatrix}.
$$

The relevant input is

$$
\operatorname{rank}G=p,\qquad GDG^T=0,\qquad
L^{\circ2}=\epsilon^\perp,
\tag{1}
$$

where $L^{\circ2}$ denotes the span of coordinatewise products of pairs of elements of $L$. In particular, its dimension is $2p-1$.

The manuscript obtains these properties from its quadratic-trade mechanism [R1]. For this memo they were also checked directly on the matrices in Appendix A. Consequently, all later finite-code assertions have a concrete matrix-level starting point.

### 1.1 Reconstructing the matrices without using the manuscript’s proof

Use the conic $Q=XZ-Y^2$ and label its rational points by $a\mapsto(1:a:a^2)$, with $\infty\mapsto(0:0:1)$. The normalized secant factors are

$$
L_{ab}=abX-(a+b)Y+Z \quad(a,b\ne\infty),
\qquad L_{a\infty}=aX-Y.
$$

The base matchings are

$$
\begin{aligned}
M_7&=\{\{0,2\},\{1,4\},\{3,\infty\},\{5,6\}\},\\
M_{11}&=\{\{0,1\},\{2,5\},\{3,7\},\{4,9\},
              \{6,8\},\{10,\infty\}\}.
\end{aligned}
$$

Enumerate their $\operatorname{PGL}_2(p)$ orbits, labeling an orbit point by the square class of the determinant of a transformation carrying the base matching to it. The labels are well-defined; the verifier checks this during orbit enumeration.

For $P_M=\prod_{\{a,b\}\in M}L_{ab}$, form

$$
x_M=\frac{P_M-P_{M_p}}{Q}.
$$

Exact polynomial division gives zero remainder. Extract the coefficient columns listed in Appendix A. They have ranks $6$ and $10$, and adding the constant column increases the rank by one. Sorting the positive sheet first gives precisely the displayed matrices.

This construction also fixes all signs, normalizations, coordinate choices, and finite-field representatives used in the memo.

---

## 2. The CSS code and its exact distances

### Proposition 1 — The code

Let

$$
S_X=\langle\mathbf1\rangle,\qquad S_Z=L^\perp.
$$

Then the CSS stabilizer generated by $X(S_X)$ and $Z(S_Z)$ defines an $[[2p,p-1,2]]_p$ code. Its encoded computational basis is

$$
|u\rangle_L=\frac1{\sqrt p}\sum_{a\in\mathbb F_p}
             |a\mathbf1+Eu\rangle.
\tag{2}
$$

**Proof.** Since $\mathbf1\in L$, every $z\in L^\perp$ has $z^T\mathbf1=0$, so the X and Z stabilizers commute. There are $1+p$ independent stabilizer generators, hence $2p-(p+1)=p-1$ logical qudits. The cosets in (2) are distinct because $G$ has full row rank; they are normalized, mutually orthogonal, and fixed by all the stabilizers.

The signed form $v^TDw$ is nondegenerate. Equation (1) says that $L$ is isotropic of half the ambient dimension. Therefore

$$
L^\perp=DL.
\tag{3}
$$

A fully explicit choice of Z-check matrix is consequently

$$
H_Z=GD.
\tag{4}
$$

The pure-X normalizer is $L$, and the pure-Z normalizer is $\mathbf1^\perp$. Thus

$$
d_X=\min\{\operatorname{wt}(v):v\in L\setminus\langle\mathbf1\rangle\},
\qquad
 d_Z=\min\{\operatorname{wt}(z):z\in\mathbf1^\perp\setminus L^\perp\}.
\tag{5}
$$

Every single-site Z error has a nonzero syndrome against $X(\mathbf1)$. For $i\ne j$, the vector $e_i-e_j$ lies in $\mathbf1^\perp$, but not in $L^\perp$, because its pairing with the rows of $E^T$ is $x_i-x_j\ne0$. Hence $d_Z=2$.

The exact enumerators in Section 8 show that the classical minimum distance of $L$ is $6$ for $p=7$ and $8$ for $p=11$. Nonzero multiples of $\mathbf1$ have weight $n$, so these are also the X distances. The distance of a CSS code is $\min(d_X,d_Z)=2$. ∎

For completeness, logical X operators are $X(Ev)$. Choose any matrix $B\in\mathbb F_p^{n\times k}$ satisfying $GB=(0;I_k)$; such a matrix exists because $G$ has full row rank. Then $Z(Bw)$ realizes logical $Z(w)$, since $\mathbf1^TB=0$ and $E^TB=I_k$. This fixes the logical Pauli convention without requiring a particular decoder circuit.

**Interpretation.** These are good detectors of an isolated fault, not single-error-correcting quantum codes. Their larger X distances do not improve the suppression order for the diagonal noise model used below: that order is controlled by $d_Z=2$.

---

## 3. The transversal gate: a complete derivation

Define a physical single-qudit cubic phase

$$
M_c|z\rangle=\omega^{cz^3}|z\rangle,
\qquad M=M_1,
$$

and the signed transversal operation

$$
\mathcal M=\bigotimes_{i=1}^{n}M_{\epsilon_i}.
$$

### Proposition 2 — The logical cubic

The transversal operation preserves the code and induces

$$
V_F|u\rangle=\omega^{F(u)}|u\rangle,
\qquad
F(u)=\sum_{i=1}^{n}\epsilon_i(x_i^Tu)^3.
\tag{6}
$$

It belongs to the third level of the Clifford hierarchy and is not Clifford.

**Proof.** On a term of (2), the physical phase is

$$
\begin{aligned}
\sum_i\epsilon_i(a+x_i^Tu)^3
={}&a^3\sum_i\epsilon_i
 +3a^2\sum_i\epsilon_i x_i^Tu\\
 &+3a\sum_i\epsilon_i(x_i^Tu)^2
 +\sum_i\epsilon_i(x_i^Tu)^3.
\end{aligned}
$$

The first three terms vanish by (1), because $\mathbf1$, $Eu$, and their pairwise products are in the relevant evaluation spaces. Thus the phase is independent of the stabilizer variable $a$, establishing (6).

For later use, define the symmetric trilinear form

$$
T(v,w,z)=\sum_i\epsilon_i v_iw_iz_i\qquad(v,w,z\in L).
\tag{7}
$$

Its radical on $L$ is exactly the constant line. Indeed,

$$
\begin{aligned}
T(v,L,L)=0
&\Longleftrightarrow Dv\in(L^{\circ2})^\perp\\
&\Longleftrightarrow Dv\in\langle\epsilon\rangle\\
&\Longleftrightarrow v\in\langle\mathbf1\rangle.
\end{aligned}
\tag{8}
$$

It therefore descends to a radical-free trilinear form on

$$
V=L/\langle\mathbf1\rangle\cong\mathbb F_p^k.
$$

In logical coordinates, $F(u)=T(u,u,u)$, where the quotient identification is understood. Since $6$ is invertible, the cubic determines $T$ by polarization. In particular, $F$ is nonzero and concise: it cannot be written in fewer than $k$ linear variables.

Conjugating $X(v)$ by $V_F$ produces an X translation times a phase whose exponent is the finite difference of $F$, hence is quadratic. Such a diagonal quadratic is Clifford. Therefore $V_F$ is in the third level. Since $T$ is nonzero, some difference has a genuinely quadratic part, so $V_F$ is not Clifford. There is no polynomial-function ambiguity here: all coordinate degrees are less than $p$. ∎

### 3.1 Orientation is gate inversion

Replacing $\epsilon$ by $-\epsilon$ replaces $F$ by $-F$ and $V_F$ by $V_F^\dagger$.

More structurally, let a physical coordinate permutation preserve $L$ and exchange the two sheets. It preserves the CSS code and induces a logical linear Clifford $C_R$. Its action satisfies

$$
F(Ru)=-F(u),\qquad C_RV_FC_R^\dagger=V_F^\dagger.
\tag{9}
$$

A sheet-preserving permutation instead preserves $F$. This is an operational meaning of the orientation character, not just a formal analogy.

### 3.2 A three-block version

On three encoded blocks, apply the physical gate

$$
|x,y,z\rangle\longmapsto\omega^{\epsilon_i xyz}|x,y,z\rangle
$$

at each coordinate $i$. Expanding the three affine representatives shows that every term containing a stabilizer variable vanishes by the same degree-at-most-two identities. The induced logical phase is

$$
|u,v,w\rangle\longmapsto\omega^{T(u,v,w)}|u,v,w\rangle.
\tag{10}
$$

This gives a second use of the cubic tensor: as a nondegenerate trilinear interaction between logical blocks. It does not make a claim about a completed fault-tolerant implementation of the physical three-qudit gates.

---

## 4. Explicit logical gates and their invariant-theoretic normal forms

The raw coefficient expressions appear in Appendix B. The following changes of logical coordinates are invertible and therefore correspond to Clifford circuits built from linear reversible operations.

### 4.1 The six-qudit gate over $\mathbb F_7$

In the coordinates of Appendix A, set

$$
u=(a,b,s+c,3s+c,d,e)^T.
\tag{11}
$$

Then the exact phase is

$$
\boxed{F_7(s,a,b,c,d,e)=4sI(a,b,c,d,e)+3J(a,b,c,d,e),}
\tag{12}
$$

where

$$
I=ae-4bd+3c^2,
$$

$$
J=ace+2bcd-ad^2-b^2e-c^3
 =\det\begin{pmatrix}a&b&c\\b&c&d\\c&d&e\end{pmatrix}.
\tag{13}
$$

These are the classical quadratic and cubic invariants in the binomial normalization of the binary quartic

$$
f(S,T)=aS^4+4bS^3T+6cS^2T^2+4dST^3+eT^4.
$$

Classical sources often use ordinary rather than binomial coefficients, and consequently rescale $I,J$; such rescalings must not be imported silently into a quantum phase. The broader connection of binary-quartic invariants to elliptic-curve arithmetic is established background [R7]. The gate identity (12) is the specific calculation here, not an elliptic-curve algorithm or advantage claim.

### 4.2 The ten-qudit gate over $\mathbb F_{11}$

Set

$$
u=(z_0,z_1,7z_2,6z_3,3s+6z_4,s+3z_4,
           6z_5,7z_6,z_7,z_8)^T.
\tag{14}
$$

Then

$$
\boxed{F_{11}(s,z)=4sI_2(z)+2I_3(z),}
\tag{15}
$$

with

$$
I_2=2z_0z_8+6z_1z_7+z_2z_6+9z_3z_5+4z_4^2,
\tag{16}
$$

and

$$
\begin{aligned}
I_3={}&6z_0z_4z_8+9z_0z_5z_7+7z_0z_6^2
 +9z_1z_3z_8+6z_1z_4z_7+7z_1z_5z_6\\
 &+7z_2^2z_8+7z_2z_3z_7+z_2z_5^2+z_3^2z_6
 +4z_3z_4z_5+2z_4^3.
\end{aligned}
\tag{17}
$$

For a precise invariant-theoretic definition, put

$$
f(S,T)=\sum_{i=0}^{8}\binom8i z_iS^{8-i}T^i
$$

and use the normalized transvectant of degree-$m$ and degree-$n$ binary forms

$$
(f,g)_r=
\frac{(m-r)!(n-r)!}{m!n!}
\sum_{j=0}^{r}(-1)^j\binom rj
\frac{\partial^r f}{\partial S^{r-j}\partial T^j}
\frac{\partial^r g}{\partial S^j\partial T^{r-j}}.
\tag{18}
$$

All denominators used here are invertible modulo $11$. The displayed invariants are exactly

$$
I_2=(f,f)_8,\qquad I_3=((f,f)_4,f)_8.
$$

In particular, the absence of a $z_2z_4z_6$ term in (17) is real: its coefficient vanishes modulo $11$.

### 4.3 A useful gate operation: remove the residual cubic by an echo

Both normal forms have the shape

$$
F(s,z)=sQ(z)+C(z),\qquad \operatorname{rank}Q=k-1.
\tag{19}
$$

Consequently,

$$
F(s,z)-F(-s,z)=2sQ(z).
\tag{20}
$$

Two uses of the native gate, with a sign flip of $s$ and one inverse, produce a phase controlled by a nondegenerate quadratic form. Fourier conjugation on the $s$ register converts that phase into a reversible quadratic addition on that register, with the sign fixed by the Fourier convention.

The quadratic forms are already close to split form: two hyperbolic pairs plus a square for seven-level qudits, and four hyperbolic pairs plus a square for eleven-level qudits. Thus the native gate has a concrete relationship to shared-control CCZ-type interactions and controlled-square operations.

This is a functional interpretation, not a favorable resource comparison. A circuit that directly synthesizes the resulting quadratic addition may be cheaper than this two-gate echo.

### 4.4 A geometric consequence: rational nodal cubic hypersurfaces

At $[s:z]=[1:0]$, the hypersurface $F=0$ has local equation

$$
Q(z)+C(z)=0.
$$

Since $Q$ has full rank $k-1$, this point is an ordinary double point. The hypersurfaces have dimensions four and eight, respectively.

They are irreducible. The rank of $Q$ is at least three, so $Q$ is irreducible even over the algebraic closure. Moreover $Q$ does not divide $C$: in (12), take $a=d=1$ and $b=c=e=0$; in (15), take $z_0=z_6=1$ and all other $z_i=0$. In each case $Q=0$ but $C\ne0$. Primitivity and degree one in $s$ now prove irreducibility.

Projection from the node gives an explicit birational parametrization:

$$
[z]\longmapsto[-C(z):Q(z)z],\qquad Q(z)\ne0.
\tag{21}
$$

This is a genuine bridge to the programme’s cubic geometry, but these are **singular cubic hypersurfaces**, not the smooth cubic threefolds in the stabilization papers. No transfer of those papers’ rationality statements is being asserted.

---

## 5. What kind of magic resource is this?

Define the decoded resource state

$$
|F\rangle=p^{-k/2}\sum_{u\in\mathbb F_p^k}\omega^{F(u)}|u\rangle.
\tag{22}
$$

Two different notions of decomposition need to be separated: decomposition under linear changes of computational variables, and equivalence under the full Clifford group.

### 5.1 No direct-sum decomposition under linear changes

For a symmetric trilinear form $T$, define its centroid by

$$
\operatorname{Cent}(T)=
\{A:T(Au,v,w)=T(u,Av,w)=T(u,v,Aw)\ \text{for all }u,v,w\}.
\tag{23}
$$

It is obtained by solving linear equations in the $k^2$ entries of $A$. The exact ranks of those equations are $35$ and $99$, so in both cases

$$
\operatorname{Cent}(T)=\mathbb F_p\,I.
\tag{24}
$$

If $F$ were a nontrivial sum of cubics in disjoint groups of linear variables, projection onto one group would be a nonscalar idempotent in the centroid. Thus (24) rules out every such decomposition. Since the calculation is a matrix-rank computation over $\mathbb F_p$, the conclusion also holds after field extension.

This alone would not rule out a more general Clifford transformation. The next argument does.

### 5.2 A Pauli-spectrum obstruction to independent cubic-phase factors

For $v,w\in\mathbb F_p^k$,

$$
\langle F|X(v)Z(w)|F\rangle
=p^{-k}\sum_u\omega^{F(u)-F(u+v)+w^Tu}.
\tag{25}
$$

The exponent is quadratic in $u$. Its quadratic part has the same rank as

$$
B_v=T(v,-,-),
$$

or equivalently as the Hessian matrix of $F$ evaluated at $v$. A quadratic Gauss sum of rank $r$ has normalized magnitude either zero or $p^{-r/2}$: a linear term nonzero on its radical gives zero; otherwise diagonalizing the nondegenerate part gives $r$ one-variable Gauss sums.

For these two cubics, there is no nonzero $v$ with $\operatorname{rank}B_v=1$. This has a small exact certificate.

**Rank-one exclusion, $p=7$.** Use the raw polynomial (B1). Its Hessian entries $H_{00}$ and $H_{55}$ vanish identically. A symmetric rank-one matrix is a scalar multiple of $\ell\ell^T$; zero diagonal entries force the corresponding rows and columns to vanish. The equations making rows $0$ and $5$ vanish imply

$$
v_0=v_1=v_4=v_5=0,\qquad v_2=4v_3.
$$

Then $H_{11}=0$ as well, so row $1$ must vanish. But

$$
H_{14}=3(v_2+v_3)=v_3,
$$

forcing $v=0$.

**Rank-one exclusion, $p=11$.** In (B2), the diagonal Hessian entries indexed $0,1,8,9$ vanish identically. Requiring these rows to vanish is already a rank-ten linear system on $v$, so $v=0$. More explicitly, row $0$ forces $v_6=v_7=v_8=v_9=0$ and $v_4=v_5$; row $1$ then forces $v_3=v_4=v_5=0$; row $8$ forces $v_0=v_1=v_2=0$.

By conciseness, rank zero is also impossible for nonzero $v$. For $v=0$, a nonzero $w$ gives zero expectation in (25). We therefore obtain the uniform bound

$$
\boxed{|\langle F|P|F\rangle|\le p^{-1}
\quad\text{for every nonscalar Pauli }P.}
\tag{26}
$$

In contrast, for every $c\ne0$ the single-qudit state

$$
|M_c\rangle=p^{-1/2}\sum_x\omega^{cx^3}|x\rangle
$$

has Pauli expectations of magnitude $p^{-1/2}$: take any nonzero X displacement and evaluate its nondegenerate one-variable quadratic Gauss sum. A tensor product containing such a factor has the same expectation magnitude, using identity on all other factors.

A Clifford unitary permutes Pauli operators up to phases and therefore preserves their expectation magnitudes. Consequently:

> **Neither $|F_7\rangle$ nor $|F_{11}\rangle$ is Clifford-equivalent to a tensor product containing a nontrivial single-qudit cubic-phase state.**

In particular, they are not disguised batches of six or ten independent $|M\rangle$ states. They also have no nontrivial Pauli stabilizers, by (26). Here Paulis are considered modulo scalar phases; the identity displacement is excluded from the bound.

This statement does **not** classify their equivalence to products of arbitrary multiqudit non-Clifford resources. Nor does it rule out conversion using Pauli measurements, postselection, or additional non-Clifford resources.

### 5.3 Measurement can still extract a single cubic-phase state

In the raw coordinates, the coefficients of $u_3^3$ in $F_7$ and $u_5^3$ in $F_{11}$ are $1$ and $5$. Measure all the other logical coordinates in the Z basis. The remaining one-variable phase is respectively

$$
x^3+\text{quadratic and lower terms},\qquad
5x^3+\text{quadratic and lower terms}.
$$

The lower-degree terms are known from the outcomes and can be removed by a Clifford. Thus a single cubic-phase resource can be extracted deterministically from each ideal block.

This is deliberately weaker than a good multi-output conversion theorem. The other measured registers are consumed, and this extraction does not establish an attractive distillation rate.

---

## 6. Rigidity of the transversal operation

### Proposition 3 — Only one cubic coefficient direction

Consider an arbitrary physical diagonal cubic

$$
\bigotimes_i M_{w_i}.
$$

It preserves the code with X-check $\mathbf1$ exactly when

$$
w\in(L^{\circ2})^\perp=\langle\epsilon\rangle.
\tag{27}
$$

**Proof.** For a computational representative $z\in L$, the phase must be constant along $z+a\mathbf1$. The coefficient of $a$ in its cubic expansion is $3\sum_iw_i z_i^2$. Vanishing for every $z\in L$ implies, by polarization, that $w$ annihilates $L^{\circ2}$. Conversely that condition also kills the coefficients of $a^2$ and $a^3$, since $\mathbf1\in L$. ∎

This is a classification of position-dependent diagonal cubic phases for the stated CSS code, not a classification of every possible transversal unitary.

### Proposition 4 — No additional X-checks inside the unchanged $L$

Keep $L$, $S_Z=L^\perp$, and the signed cubic physical phase fixed. Suppose a CSS subcode uses an enlarged X space $S\subseteq L$. Preservation requires

$$
T(S,L,L)=0.
$$

Equation (8) therefore forces

$$
\boxed{S\subseteq\langle\mathbf1\rangle.}
\tag{28}
$$

**Proof of necessity.** Expanding $F_{\rm phys}(z+s)-F_{\rm phys}(z)$ gives a quadratic part $3T(s,z,z)$. It must vanish on $L$. Polarization gives $T(s,L,L)=0$. Lower-degree physical diagonal corrections cannot cancel this quadratic dependence on $z$: their differences have degree at most one. ∎

The obstruction is specific. It does not prohibit changing $L$, concatenation, gauge fixing, switching between codes, or a different non-Clifford operation.

### 6.1 All local phases of degree at most three

For a local diagonal phase exponent

$$
P(z)=\sum_i\left(w_i z_i^3+b_i z_i^2+c_i z_i\right),
$$

code preservation is equivalent to

$$
w\in\langle\epsilon\rangle,\qquad
b\in L^\perp,\qquad c\in\mathbf1^\perp.
\tag{29}
$$

Separate the homogeneous degrees in $P(z+a\mathbf1)-P(z)$ to obtain necessity; the same expansion proves sufficiency.

The logical quadratic phases have dimension $k$. Indeed, $b\in L^\perp=DL$, and the kernel of $b\mapsto\sum_i b_i z_i^2|_L$ is $(L^{\circ2})^\perp=\langle\epsilon\rangle$. They are exactly the directional derivatives of the logical cubic, up to the factor three:

$$
b=Dv\quad\Longrightarrow\quad
\sum_i b_i z_i^2=T(v,z,z)=\tfrac13\partial_vF(z).
\tag{30}
$$

The logical linear phases likewise have dimension $k$, because their physical parameter space is $\mathbf1^\perp/L^\perp$.

### 6.2 Why the paper’s fixed line does not produce a quantum family

For the fixed-line deformation described in [R1], the top harmonic evaluations stay fixed while the nonzero separation of the two radial sheet constants changes. Away from coalescence, this simply rescales one affine coordinate. It therefore leaves the span of affine evaluation functions $L$ unchanged, after the natural orbit indexing.

Consequently it leaves $S_X$, $S_Z$, and the physical signed operation unchanged. Only the choice of logical coordinates changes. The $p-1$ noncoalescent points do not give $p-1$ distinct quantum codes by this construction. The coalescence point is different because that separating coordinate is lost; it requires a separate analysis.

---

## 7. A fully specified native-resource factory

The appropriate established comparison is **synthillation**: prepare a non-Clifford multiqudit gate resource while suppressing errors, rather than first distilling independent magic states and then synthesizing the gate. Campbell–Howard develop that general strategy for qubits [R4]. Prime-qudit distillation and compilation have their own substantial prior literature [R2, R3, R5, R6]. The specific finite construction below is not a claim to have invented that strategy.

### 7.1 Noise assumptions

Each input resource of sign $s\in\{1,-1\}$ is

$$
\rho_s=(1-\delta)|M_s\rangle\langle M_s|
 +\frac{\delta}{p-1}\sum_{e\ne0}
 Z(e)|M_s\rangle\langle M_s|Z(-e).
\tag{31}
$$

Inputs are independent. State preparation, Clifford gates, feed-forward, and Pauli measurements used by the factory are ideal. The output calculations do not include circuit-level Clifford faults, leakage, correlated input faults, or coherent errors.

A Clifford twirl can diagonalize in the basis $\{Z(e)|M_s\rangle\}$: use powers of the Clifford $M_sXM_s^\dagger$. It does **not**, in general, make all nonzero error labels equiprobable. Uniformity in (31) is an additional noise assumption, not a free consequence of twirling.

The two signs require only one ideal resource type, since coordinate negation maps $|M\rangle$ to $|M^{-1}\rangle$. Its effect on the error label is known.

### 7.2 Deterministic injection, with all measurement outcomes retained

To inject $M_s$ on a data register, prepare an ancilla $|M_s\rangle$, apply controlled subtraction

$$
|x,y\rangle\longmapsto|x,y-x\rangle,
$$

and measure the ancilla with outcome $m$. The resulting data phase is

$$
s(m+x)^3=sx^3+3smx^2+3sm^2x+sm^3.
$$

Apply the Clifford correction with exponent $-3smx^2-3sm^2x$. Up to a global phase, the result is $M_s$. An ancilla error $Z(e)$ contributes $e(m+x)$, hence becomes precisely a data error $Z(e)$, up to a global phase.

Thus all injection outcomes can be accepted, and the input noise model transfers directly to independent physical Z errors after the intended transversal gate.

### 7.3 The protocol

Prepare the stabilizer state

$$
|+_L\rangle=p^{-p/2}\sum_{z\in L}|z\rangle,
$$

which is $|+\rangle^{\otimes k}$ in the logical code. Its preparation is a Clifford operation because $L$ is a linear space; X generators are the rows of $G$, and Z generators are the rows of $GD$.

Inject $M_{\epsilon_i}$ at each of the $n$ physical positions, consuming $n$ noisy single-qudit resources. Measure the code stabilizers and accept exactly when all have their prescribed eigenvalues. Under the stated Z-only model, the Z checks always pass, and the only nontrivial acceptance test is $X(\mathbf1)$.

Finally, decode the CSS code. In the absence of errors, the output is $|F\rangle$ and acceptance is certain.

An error vector $e\in\mathbb F_p^n$ is accepted exactly when

$$
\mathbf1^Te=0.
\tag{32}
$$

For an accepted error, its decoded logical label is

$$
\eta=E^Te,
\tag{33}
$$

because

$$
e^T(a\mathbf1+Eu)=\eta^Tu.
$$

Therefore the output is $Z(\eta)|F\rangle$. It is error-free exactly when $e\in\ker G=L^\perp$.

**Why a naive projection is not the protocol.** Directly projecting a product of ideal magic states onto the zero Z-syndrome sector can have a very small ideal acceptance probability. The protocol above instead prepares the encoded stabilizer input first and injects gates deterministically. It has no such hidden factor: ideal acceptance is one.

### 7.4 Exact acceptance and exact output infidelity

Let

$$
W_C(a,b)=\sum_{w=0}^{n}A_w a^{n-w}b^w,
\qquad C=L^\perp,
$$

be the ordinary Hamming weight enumerator. Section 8 gives every coefficient.

The Fourier formula for a sum of independent errors yields

$$
\boxed{
P_{\rm acc}(\delta)=\frac{1+(p-1)
             \left(1-\frac{p\delta}{p-1}\right)^n}{p}.}
\tag{34}
$$

The unnormalized probability of an accepted, logically trivial error is

$$
P_{\rm good}(\delta)=W_C\left(1-\delta,\frac{\delta}{p-1}\right).
\tag{35}
$$

The states $Z(\eta)|F\rangle$ are mutually orthogonal: their inner products are Fourier sums over the uniformly supported computational amplitudes in (22). Hence the conditional **block infidelity**, not merely a union bound, is

$$
\boxed{
\delta_{\rm block}(\delta)=
1-\frac{W_C(1-\delta,\delta/(p-1))}{P_{\rm acc}(\delta)}.}
\tag{36}
$$

Every accepted weight-two error is $(a,-a)$ on a pair of positions, with $a\ne0$, and every such error is logically nontrivial. Thus

$$
\delta_{\rm block}(\delta)
=\frac{\binom n2}{p-1}\delta^2+O(\delta^3).
\tag{37}
$$

More explicitly,

$$
\begin{aligned}
p=7:\quad&\delta_{\rm block}
 =\frac{91}{6}\delta^2+\frac{728}{9}\delta^3+O(\delta^4),\\
p=11:\quad&\delta_{\rm block}
 =\frac{231}{10}\delta^2+\frac{924}{5}\delta^3+O(\delta^4).
\end{aligned}
\tag{38}
$$

There are $546$ and $2310$ accepted nontrivial weight-two error vectors, respectively. They also produce distinct logical labels: a collision between two would give a nonzero element of $L^\perp$ of weight at most four, contradicting its distance six or eight.

### 7.5 Numerical examples

These values use the full enumerators, not just the leading term.

| Field | Input error $\delta$ | Acceptance | Conditional block infidelity |
|---|---:|---:|---:|
| $7$ | $0.001$ | $0.986105673$ | $0.0000152476651$ |
| $7$ | $0.01$ | $0.870136753$ | $0.001598530883$ |
| $11$ | $0.001$ | $0.978252246$ | $0.0000232854145$ |
| $11$ | $0.01$ | $0.803640224$ | $0.002500664718$ |

The block output is a different resource from each input. It would therefore be misleading to insert $k/n$ into a conventional independent-magic-state yield formula or to call a crossing of $\delta_{\rm block}(\delta)=\delta$ a recursive distillation threshold. A recursive resource-conversion architecture has not been supplied.

### 7.6 Nonuniform independent errors

For arbitrary independent distributions $P_i(e)$, put

$$
\phi_i(t)=\sum_{e\in\mathbb F_p}P_i(e)\omega^{te}.
$$

Then

$$
P_{\rm acc}=\frac1p\sum_t\prod_i\phi_i(t),
$$

and the exact unnormalized logical error distribution is

$$
\Pr(\eta,\mathrm{acc})=
\sum_{\substack{\mathbf1^Te=0\\ E^Te=\eta}}\prod_iP_i(e_i).
\tag{39}
$$

No single-site nonzero error passes. Consequently independent errors of total probability $O(\delta)$ per site still give conditional block error $O(\delta^2)$ near zero, although the coefficient and possibly the leading order change. Correlations can invalidate that conclusion: a correlated opposite-error pair can pass with probability of first order in its own fault rate.

### 7.7 Consuming the coupled output to implement the coupled gate

The same injection construction works on $k$ data registers with ancilla $|F\rangle$. Controlled subtraction and computational measurement with outcome $m$ produce exponent $F(x+m)$. Subtract

$$
F(x+m)-F(x)-F(m)
$$

with a Clifford correction; it is quadratic in $x$. The implemented gate is $V_F$, and a resource error $Z(\eta)$ transfers to the same data error. Thus the output is an operational native-gate resource, not merely a formal nonstabilizer state.

---

## 8. Exact classical weight enumerators and distance certificates

Because $L^\perp=DL$ and multiplication by $D$ preserves Hamming weight, the two classical spaces have the same ordinary weight enumerator. They are formally self-dual in this sense; one need not replace the signed form by the ordinary dot product or call $L$ Euclidean self-dual.

The nonzero coefficients $A_w$ are:

| Weight $w$ | $A_w$ for $[14,7,6]_7$ | $A_w$ for $[22,11,8]_{11}$ |
|---:|---:|---:|
| 0 | 1 | 1 |
| 6 | 378 | 0 |
| 7 | 516 | 0 |
| 8 | 6,468 | 1,100 |
| 9 | 25,284 | 0 |
| 10 | 74,382 | 41,800 |
| 11 | 154,644 | 157,320 |
| 12 | 247,842 | 2,436,940 |
| 13 | 218,064 | 17,133,600 |
| 14 | 95,964 | 112,941,400 |
| 15 | — | 595,194,160 |
| 16 | — | 2,622,117,190 |
| 17 | — | 9,214,830,020 |
| 18 | — | 25,660,748,300 |
| 19 | — | 53,955,314,600 |
| 20 | — | 80,976,004,780 |
| 21 | — | 77,104,831,760 |
| 22 | — | 35,049,917,640 |

All omitted coefficients between zero and the corresponding length vanish. The totals are $7^7=823543$ and $11^{11}=285311670611$.

### 8.1 How the enumerators were obtained

For a coordinate subset $S$, let $r(S)$ be the column rank of $G_S$. The number of words of $C=\ker G$ supported inside $S$ is

$$
p^{|S|-r(S)}.
$$

Set

$$
B_w=\sum_{|S|=w}p^{w-r(S)}.
$$

Double-counting words and containing supports gives

$$
B_w=\sum_{j=0}^{w}\binom{n-j}{w-j}A_j,
\qquad
A_w=B_w-\sum_{j<w}\binom{n-j}{w-j}A_j.
\tag{40}
$$

Signed self-duality makes the column matroid self-dual, so

$$
r(S)=|S|-p+r(S^c).
\tag{41}
$$

The C++ verifier exhaustively enumerates one representative of each complementary subset pair, computes its modular rank, and uses (41) for the other. This is an exact exhaustive subset computation, not sampling or enumeration of all $11^{11}$ words. The resulting enumerators are also checked against the MacWilliams identity.

For $p=7$, a separate direct enumeration of all $823543$ words of $L$ agreed coefficient by coefficient. The supplied verifier reproduces that independent check with its optional NumPy flag.

### 8.2 Small explicit witnesses

Using zero-based row indices from Appendix A, the following words lie in $\ker G$:

- Over $\mathbb F_7$: support $(0,1,2,4,7,13)$, with values $(2,2,5,5,6,1)$.
- Over $\mathbb F_{11}$: support $(0,1,2,3,4,9,17,20)$, with values $(2,2,9,9,2,9,10,1)$.

Multiplying by $D$ gives words of $L$ with the same weights, hence X-logical witnesses. The exhaustive rank computation proves that no smaller support occurs.

---

## 9. Synthesis costs, limitations, and the next research programme

### 9.1 The phase-synthesis problem is precise, but not yet solved optimally

A weighted-cube decomposition

$$
F(u)=\sum_{j=1}^{r}c_j\ell_j(u)^3
\tag{42}
$$

gives a synthesis: compute a linear form by Clifford operations, apply $M_{c_j}$, and uncompute. The associated optimization is a finite-field symmetric-tensor or Waring problem. Phase-polynomial compilation for prime qudits is already an established approach [R5]; applying it to these particular invariant resources is the target here.

The coordinate origin is one configuration point, so one row of $E$ is zero. Equation (6) therefore immediately supplies

$$
r(F_7)\le13,\qquad r(F_{11})\le21.
\tag{43}
$$

All coefficients in these upper bounds are $\pm1$, so the bounds use the available $M$ and $M^{-1}$ resource class directly.

Conciseness gives $r\ge k$. Equality would make the $k$ linear forms independent and put a rank-one quadratic in the span of the first derivatives of $F$, contradicting Section 5. Therefore

$$
\boxed{7\le r(F_7)\le13,\qquad 11\le r(F_{11})\le21.}
\tag{44}
$$

These are bounds, not optimal synthesis results. Also distinguish a weighted-cube count, in which every $M_c$ is charged one unit, from a library containing only a fixed $M$. Over $\mathbb F_{11}$ every nonzero scalar is a cube, so single-qudit coordinate scaling relates all $M_c$. Over $\mathbb F_7$ it does not: the nonzero cube subgroup is $\{1,-1\}$. A synthesis optimizer must respect the chosen resource library.

The factory uses $14$ or $22$ raw resources for a filtered gate having an unfiltered decomposition with at most $13$ or $21$ such resources. That is a promising near-direct-cost starting point. It is not “one extra resource beyond optimum,” because the upper bounds in (43) have not been proved optimal.

### 9.2 A concrete search problem for higher distance

To evade Proposition 4, choose a smaller evaluation space $L'\subset L$ and an X space $S\subset L'$ satisfying

$$
T(S,L',L')=0.
\tag{45}
$$

The resulting CSS code would have

$$
k'=\dim L'-\dim S,
$$

$$
d_X'=\min\operatorname{wt}(L'\setminus S),\qquad
 d_Z'=\min\operatorname{wt}(S^\perp\setminus L'^\perp).
\tag{46}
$$

This makes an exact, constrained finite-field design problem: maximize useful logical resource content while certifying distance and the transversal identity. It fits the programme’s certifying-search orientation better than searching arbitrary code matrices without retaining the logical cubic.

A caveat to a tempting column-count argument is important. Pairwise nonproportional columns of an X-check matrix guarantee detection of all weight-two Z operators, but this is stronger than distance at least three when weight-two Z stabilizers are allowed. With $\mathbf1\in S$, two X-checks provide only $p$ distinct affine column labels for $2p$ positions; collisions are unavoidable. A distance-three construction must either use more X-check information or make every resulting undetected pair a Z stabilizer through its choice of $L'$. The latter degeneracy possibility must not be silently discarded.

### 9.3 Generalization: higher moments give higher-level gates

For $p>r$, let $L\subseteq\mathbb F_p^n$ contain $\mathbf1$, and let

$$
w\in(L^{\circ(r-1)})^\perp.
$$

The same CSS construction with X space $\langle\mathbf1\rangle$ admits the diagonal physical phase $\sum_iw_i z_i^r$, because its change under a constant translation is a combination of lower-degree moments. The logical degree-$r$ phase is nonzero when $w$ does not annihilate $L^{\circ r}$.

Thus the manuscript’s “first surviving moment” has a systematic quantum meaning. The exceptional matching classification supplies two distinguished cubic examples; it is not a classification of all quantum codes with cubic transversal gates.

### 9.4 What to pursue, and what not to claim

**First priority: determine the resource content and optimal synthesis of these two gates.** Close (44), search measurement-assisted conversion into standard multiqudit resources, and compute useful Clifford-invariant spectra beyond the rank-one exclusion. Benchmarks should compare complete error-suppressed implementations of the same target gate, not raw qudit counts.

**Second priority: search restricted evaluation spaces using (45).** Retain a nonzero, useful logical cubic while increasing the relevant distance. Record code degeneracy, logical error correlations, and check costs in the certificates. Simply adding checks to $L$ cannot work.

**Third priority: turn the construction into a benchmark for a certifying compiler.** The finite-field geometry provides exact gate identities, non-equivalence certificates, and exact noise formulas in one small example. A tool that jointly outputs a synthesis circuit, an error-detection construction, and independently checkable certificates would connect this branch to the programme’s recovery/optimization software.

The commercial proposition remains a hypothesis. No device-level implementation, workload advantage, customer demand, or competitive factory cost has been established. The natural test is a head-to-head comparison against distill-then-synthesize and other synthillation constructions in the same prime-dimensional architecture, including Clifford operations and failure handling. Existing qudit protocols and later punctured Reed–Muller developments are relevant benchmarks, not evidence that these particular blocks outperform them [R2, R3, R6].

### 9.5 A defensible research claim

A plausible paper would be framed as:

> **Quadratic trades as certificates for coupled cubic-phase quantum resources.**

Its defensible contents would be the exact trade-to-code dictionary, the two explicit invariant-defined resources, the rigidity of their local cubic gate direction, the Pauli-spectrum non-equivalence proof, and their native-resource factory with exact error enumerators.

The general CSS/cubic-moment mechanism, weighted orthogonality, qudit magic-state distillation, phase-polynomial synthesis, and synthillation are not new in themselves. Whether these particular codes, invariant normal forms, and resource certificates already occur elsewhere requires a more focused equivalence and priority search. The work in this memo establishes their mathematics, not literature priority.

---

## 10. Reproducibility and trust boundary

The companion archive contains:

- `clebsch_quantum_verify.py`: reconstructs the matching orbits and matrices; verifies ranks, signed self-duality, the Schur-square hyperplane, the cubic radical, centroid dimension, canonical phase identities, and rank-one exclusion.
- `weight_enumerator.cpp`: exact subset-rank enumeration used to recover the complete ordinary weight enumerators.
- `clebsch_quantum_data.json`: all matrices, ordered matchings, coefficient dictionaries, exact enumerators, witnesses, and decimal noise examples.
- This memo, a README, and a checksum manifest.

Run the algebraic checks using Python 3.10 or later:

```sh
python clebsch_quantum_verify.py --output recomputed.json
```

Recompute the full enumerators with a C++17 compiler available:

```sh
python clebsch_quantum_verify.py --enumerators --output recomputed.json
```

Also repeat the independent direct enumeration over $\mathbb F_7$, with NumPy installed:

```sh
python clebsch_quantum_verify.py --enumerators --bruteforce-seven --output recomputed.json
```

The last command was run successfully in preparing this memo. All finite-field calculations use exact integer arithmetic. Decimal evaluations use 45-digit arithmetic. No full quantum statevector of size $11^{22}$ was constructed or required.

**Not established here:** optimal Waring ranks; a full classification under arbitrary resource conversions; circuit-level fault-tolerance thresholds; performance under correlated or coherent noise; a competitive recursive distillation architecture; hardware advantage; novelty priority; or the correctness of every proof in the source research programme.

---

## Appendix A. Complete matrices

The first $p$ rows have sign $+1$, the last $p$ rows sign $-1$. For either matrix, use $G=(\mathbf1^T;E^T)$ and $H_Z=GD$. The raw logical coordinates are $u_0,\ldots,u_{k-1}$.

### A1. $E_7$

The selected quotient coefficient order is

$$
X^2,\ XY,\ XZ,\ Y^2,\ YZ,\ Z^2.
$$

```text
 3  5  0  0  3  2
 0  0  0  0  0  0
 6  4  6  5  3  6
 2  4  0  0  2  3
 1  0  6  5  2  5
 5  5  6  5  0  1
 4  3  3  6  4  4
 3  5  0  5  0  0
 0  0  0  5  2  3
 6  4  6  3  2  5
 2  4  0  5  3  2
 1  0  6  3  0  1
 5  5  6  3  3  6
 4  3  3  4  4  4
```

### A2. $E_{11}$

The selected quotient coefficient order is

$$
X^4,\ X^3Y,\ X^3Z,\ X^2YZ,\ X^2Z^2,\ XY^2Z,
\ XYZ^2,\ XZ^3,\ YZ^3,\ Z^4.
$$

```text
 0  0  0  0  0  0  0  0  0  0
 6  8  3  4  9  6 10  6  6  5
 8  5  4  1  0  0  4  2  1  9
 9 10  2  7  0  0 10  4  6  8
 3  1  1  2  0  0  7  7  3  7
10  1  9  2  9  6  0 10  0  2
 4 10  8  7  9  6  4  8  1  4
 5  5  6  1  9  6  7  3  3  6
 7  8  7  4  0  0  9  1 10  3
 2  0 10  0  9  6  9  9 10 10
 1  7  5  5 10  3  6  5  4  1
 0  0  0  0  0  1  9  1 10  3
 6  8  3  4  9  7  9  9 10 10
 8  5  4  1  0  1  7  7  3  7
 9 10  2  7  0  1  4  2  1  9
 3  1  1  2  0  1  0  0  0  0
10  1  9  2  9  7  7  3  3  6
 4 10  8  7  9  7 10  6  6  5
 5  5  6  1  9  7  4  8  1  4
 7  8  7  4  0  1 10  4  6  8
 2  0 10  0  9  7  0 10  0  2
 1  7  5  5 10  4  6  5  4  1
```

---

## Appendix B. Raw phase polynomials

These expressions use exactly the matrix columns in Appendix A, before the changes (11) and (14).

### B1. Over $\mathbb F_7$

$$
\begin{aligned}
F_7(u)={}&6u_0u_2u_5+4u_0u_3u_5+4u_0u_4^2+4u_1^2u_5\\
 &+3u_1u_2u_4+3u_1u_3u_4+2u_2^2u_3+u_2u_3^2+u_3^3.
\end{aligned}
\tag{B1}
$$

### B2. Over $\mathbb F_{11}$

$$
\begin{aligned}
F_{11}(u)={}&4u_0u_4u_9+7u_0u_5u_9+3u_0u_6u_8+5u_0u_7^2\\
 &+3u_1u_3u_9+9u_1u_4u_8+8u_1u_5u_8+4u_1u_6u_7\\
 &+5u_2^2u_9+4u_2u_3u_8+3u_2u_4u_7+5u_2u_5u_7
       +9u_2u_6^2\\
 &+9u_3^2u_7+5u_3u_4u_6+8u_3u_5u_6
       +3u_4^2u_5+4u_4u_5^2+5u_5^3.
\end{aligned}
\tag{B2}
$$

The cubic coefficient dictionary in the JSON uses a key such as `"0,4,9"` for the monomial $u_0u_4u_9$. Its values are polynomial coefficients, not entries of the polarized tensor; the factors $1,3,6$ for repeated or distinct indices have already been applied.

---

## References

The source manuscript and research literature were consulted through their text/HTML versions. References support the stated background and input definitions; the new finite derivations and computational outputs are documented within this memo and its companion files.

**[R1]** Tavis Rudd. *Quadratic Trade Rigidity and Cubic Orientation in Conic Matching Quotients*. Manuscript dated July 2026; repository `main` consulted 4 September 2026. In particular, the base matchings in §3 and the affine evaluation/trade results in §4.  
[Repository](https://github.com/tavisrudd/clebsch-factorization) · [Manuscript source](https://raw.githubusercontent.com/tavisrudd/clebsch-factorization/main/clebsch_factorization.tex)

**[R2]** Earl T. Campbell, Hussain Anwar, and Dan E. Browne. *Magic-State Distillation in All Prime Dimensions Using Quantum Reed–Muller Codes*. Physical Review X **2**, 041021 (2012).  
[arXiv:1205.3104](https://arxiv.org/abs/1205.3104) · [Full text](https://arxiv.org/html/1205.3104v2)

**[R3]** Anirudh Krishna and Jean-Pierre Tillich. *Towards Low Overhead Magic State Distillation*. Physical Review Letters **123**, 070507 (2019).  
[arXiv:1811.08461](https://arxiv.org/abs/1811.08461) · [Full text](https://arxiv.org/html/1811.08461v2)

**[R4]** Earl T. Campbell and Mark Howard. *A Unified Framework for Magic State Distillation and Multiqubit Gate-Synthesis with Reduced Resource Cost*. Physical Review A **95**, 022316 (2017).  
[arXiv:1606.01904](https://arxiv.org/abs/1606.01904) · [Full text](https://arxiv.org/html/1606.01904v5)

**[R5]** Luke E. Heyfron and Earl Campbell. *A Quantum Compiler for Qudits of Prime Dimension Greater Than 3*. arXiv:1902.05634 (2019).  
[Abstract](https://arxiv.org/abs/1902.05634) · [Full text](https://arxiv.org/html/1902.05634v1)

**[R6]** Tanay Saha and Shiroman Prakash. *Sublogarithmic Distillation in All Prime Dimensions Using Punctured Reed–Muller Codes*. arXiv:2510.10852 (2025); publication in Physical Review A (2026), DOI 10.1103/tzkz-9p2f.  
[arXiv](https://arxiv.org/abs/2510.10852) · [Publisher](https://doi.org/10.1103/tzkz-9p2f)

**[R7]** Manjul Bhargava and Arul Shankar. *Binary Quartic Forms Having Bounded Invariants, and the Boundedness of the Average Rank of Elliptic Curves*. Annals of Mathematics **181** (2015). Invariant conventions differ from the binomial normalization used in §4.1.  
[arXiv:1006.1002](https://arxiv.org/abs/1006.1002) · [Full text](https://arxiv.org/html/1006.1002v3)
