# Node Kayles on Fixed-Point-Deleted Schreier Graphs from Conic Involutions: The Dihedral Case

## Abstract

Let \(C\) be a nonsingular conic in \(PG(2,q)\), where \(q\) is odd. An off-conic point
\(x\) induces an involution \(\sigma_x\) of \(C\cong\mathbf P^1(q)\) by exchanging the two
points in which each secant through \(x\) meets \(C\). We consider a normal-play
capacity-two avoidance game in which selected off-conic points forbid the conic points
lying on their pairwise joining lines. If subsequent play is restricted to the conic, the
legal continuations form a Node-Kayles position.

We prove that if three legal selected points induce a tame dihedral subgroup, including
the Klein-four boundary case, then the residual graph is a disjoint union of
fixed-point-deleted Schreier templates. Every transitive template is an empty graph, a
complete graph \(K_4\), an ordinary ladder, a prism, or a Möbius ladder. This yields a
complete Grundy-value classification, explicit split- and nonsplit-torus formulas,
periodicity in \(q\), an exact one-half P-position density among admissible prime fields,
and a converse realization theorem.

As a structural corollary, the construction defines an additive invariant of finite
\(G\)-sets that factors through the mod-two Burnside group.

## 1. Introduction

Node Kayles is the impartial game in which a move at a graph vertex deletes its closed
neighbourhood. The present paper studies a structured family of Node-Kayles positions
arising from a finite-geometric capacity-two game on a conic.

The general reduction of late-stage Nofil positions to Node Kayles is known. The
correspondence between off-conic points and involutions in \(PGL_2(q)\), and the geometry
of triples of such involutions, are also classical; Tranchida recently developed that
correspondence in detail for incidence geometries and hypertopes. Our contribution starts
after that correspondence: saturation is detected by fixed points of pair products, so
the conic-only residual is a fixed-point-deleted Schreier graph, and in the tame dihedral
case its orbit templates and Grundy values can be classified completely. Tranchida does
not consider this residual graph or its Node-Kayles value.

We solve this construction completely when the generated subgroup is tame dihedral. The
analysis is uniform in the field and has three components:

1. a classification of legal dihedral involution triples;
2. a classification of every transitive projective-line orbit template;
3. an evaluation of those templates using Brown et al.'s exact Node-Kayles values for
   ladders, prisms, and the required opposite-end-pendant ladder family.

All game values below refer to the continuation in which only conic points may be played.
They need not equal the value of a larger position in which further off-conic moves remain
available.

Throughout, \(q\) is odd and
\[
p=\operatorname{char}\mathbf F_q
\]
does not divide the order of the subgroup under consideration. We call this the tame
case.

We use
\[
D_{2m}=\langle r,s:r^m=s^2=1,\ srs=r^{-1}\rangle,
\]
so \(D_{2m}\) has order \(2m\).

## 2. From conic saturation to Node Kayles

Choose coordinates in which
\[
C:\ XZ=Y^2,
\]
and parameterize
\[
c(t)=[1:t:t^2],\qquad t\in\mathbf F_q,
\]
with \(c(\infty)=[0:0:1]\).

For an off-conic point \(x\), projection from \(x\) exchanges the two conic points on
each secant through \(x\). Denote the resulting involution of \(C\) by \(\sigma_x\).

For \(x=[a:b:c]\), one may represent this involution by the traceless matrix
\[
M_x=
\begin{pmatrix}
b&-a\\
c&-b
\end{pmatrix},
\]
which acts on \(\mathbf P^1(q)\) as
\[
\sigma_x(t)=\frac{bt-a}{ct-b}.
\tag{2.1}
\]

Let \(S\) be a legal set of selected off-conic points. A conic point is dead when it lies
on a line through two points of \(S\).

### Lemma 2.1: pair-product fixed points are exactly the dead conic points

For distinct selected points \(x,y\) and \(u\in C\),
\[
u\in xy
\quad\Longleftrightarrow\quad
(\sigma_x\sigma_y)(u)=u.
\tag{2.2}
\]

### Proof

Let \(v=\sigma_y(u)\). The points \(u,v,y\) are collinear. If
\(\sigma_x(v)=u\), then \(u,v,x\) are also collinear. When \(u\ne v\), the line through
\(u,v\) is unique, so it contains \(x\) and \(y\), and hence \(u\in xy\). When \(u=v\),
both \(x\) and \(y\) lie on the unique tangent to \(C\) at \(u\), so again \(u\in xy\).

Conversely, suppose \(u\in xy\). Let \(v\) be the other point of \(C\cap xy\), counted
with multiplicity. Projection from \(y\) exchanges \(u\) and \(v\), and projection from
\(x\) exchanges \(v\) and \(u\). Thus
\[
\sigma_x\sigma_y(u)=u.
\]
∎

Define
\[
D_S=
\bigcup_{\{x,y\}\subset S}
\operatorname{Fix}(\sigma_x\sigma_y).
\tag{2.3}
\]

On the live vertex set \(C\setminus D_S\), join \(u\) to \(\sigma_x(u)\) for every
\(x\in S\), suppressing loops and repeated edges. Call the resulting graph \(R_S\).

### Theorem 2.2: exact residual reduction

A legal conic move at \(u\in C\setminus D_S\) deletes exactly the closed neighbourhood
\(N_{R_S}[u]\). Hence play restricted to the conic is Node Kayles on \(R_S\).

### Proof

After selecting \(u\), a live conic point \(v\ne u\) becomes dead exactly when
\(u,v,x\) are collinear for some \(x\in S\). By definition of the projection involution,
this is equivalent to
\[
v=\sigma_x(u).
\]
Thus the newly unavailable conic points are precisely \(u\) and its graph neighbours. ∎

## 3. Fixed-point-deleted Schreier graphs

Let a finite group \(G\) act on a finite set \(\Omega\), and let \(T\) be a finite set of
involutions generating \(G\). Define
\[
D_T(\Omega)=
\bigcup_{\{\sigma,\tau\}\in\binom{T}{2}}
\operatorname{Fix}_\Omega(\sigma\tau)
\tag{3.1}
\]
and
\[
R_T(\Omega)=
\operatorname{Sch}(G,\Omega,T)
[\Omega\setminus D_T(\Omega)],
\tag{3.2}
\]
with loops and repeated edges suppressed.

For a subgroup \(K\le G\), write
\[
R(G,K,T)=R_T(G/K).
\tag{3.3}
\]

If
\[
\Omega\cong\bigsqcup_{[K]}m_K(G/K),
\]
then Sprague-Grundy additivity gives
\[
\mathcal G(R_T(\Omega))
=
\bigoplus_{[K]}
(m_K\bmod2)\,
\mathcal G(R(G,K,T)).
\tag{3.4}
\]

This is the orbit-template formula.

## 4. Legal dihedral triples

The smallest dihedral boundary is
\(D_4\cong V_4\). A generating involution triple is necessarily the set of all three
nonidentity elements.

### Theorem 4.1: the Klein-four boundary

Let a legal tame conic-involution triple generate \(G\cong V_4\), and let \(s\) be the
number of its three involutions having rational fixed points on \(C\). Then the dead set
has size \(2s\), and the residual graph is
\[
\frac{q+1-2s}{4}K_4.
\tag{4.1}
\]
Consequently
\[
\mathcal G(R_T)=\frac{q+1-2s}{4}\pmod2.
\tag{4.2}
\]

### Proof

The product of any two nonidentity elements of \(V_4\) is the third. Thus (3.1) deletes
exactly the union of the fixed-point sets of the three involutions. A tame point
stabilizer in \(PGL_2(q)\) is cyclic, so two distinct nonidentity elements of \(V_4\)
cannot fix the same conic point. Each split involution has two rational fixed points and
each nonsplit involution has none, giving \(|D_T|=2s\).

The \(V_4\)-action on the live points is free: a nontrivial stabilizer would again contain
one of the involutions whose fixed points were deleted. Every live orbit therefore has
four points. On such an orbit the three involutions give the three perfect matchings of
\(K_4\). Since one Node-Kayles move deletes a whole \(K_4\), each orbit has Grundy value
one, and disjoint-union additivity gives (4.2). ∎

No dihedral group whose rotation subgroup has odd order can arise from a legal generating
involution triple: all of its involutions are reflections, and their centres are collinear
by the argument below. For the remainder of the classification, fix \(n\ge2\) and suppose
\[
G\cong D_{4n}
=
\langle r,s:r^{2n}=s^2=1,\ srs=r^{-1}\rangle.
\]
Put
\[
z=r^n.
\]

The noncentral involutions are the reflections \(sr^e\). In the conic model their centres
lie on one projective line: in a dihedral normal form over the splitting field, reflection
matrices are proportional to
\[
\begin{pmatrix}
0&\lambda\\
1&0
\end{pmatrix},
\]
so their centre coordinates satisfy \(b=0\). This line is invariant under Galois and
therefore descends to \(\mathbf F_q\). Hence three reflection centres are collinear and
cannot be a legal selected triple.

A legal generating involution triple must therefore contain \(z\) and two reflections.
After rechoosing the reflection generator and interchanging the reflections, it has the form
\[
T_d=\{z,s,sr^d\}.
\tag{4.3}
\]

### Proposition 4.2

The triple \(T_d\) generates \(D_{4n}\) exactly when
\[
\gcd(d,n)=1.
\tag{4.4}
\]

### Proof

The subgroup contains
\[
s(sr^d)=r^d
\]
and \(r^n\). Its rotation subgroup is therefore
\[
\langle r^d,r^n\rangle
=
\langle r^{\gcd(d,n)}\rangle.
\]
This equals \(\langle r\rangle\) precisely when \(\gcd(d,n)=1\). ∎

Under an automorphism
\[
r\mapsto r^u,\qquad s\mapsto r^v s,
\qquad u\in(\mathbf Z/2n)^\times,
\]
the parameter \(d\) changes to \(\pm ud\). Therefore:

- if \(n\) is even, every admissible \(d\) is odd and there is one automorphism class;
- if \(n\) is odd, there are two classes, represented by odd and even \(d\).

The central centre is not on the reflection-centre line, so every generating triple
described above is geometrically legal.

## 5. Free-orbit templates

Let \(M_{4n}\) denote the graph obtained from \(C_{4n}\) by joining antipodal vertices,
and let
\[
L_k=P_k\square K_2
\]
denote the ladder with \(k\) rungs.

### Theorem 5.1

For the regular action,
\[
R(D_{4n},1,T_d)\cong
\begin{cases}
M_{4n},&d\text{ odd},\\
C_{2n}\square K_2,&d\text{ even}.
\end{cases}
\tag{5.1}
\]
The even case occurs only when \(n\) is odd.

### Proof

No nonidentity element fixes a point in the regular action, so no vertices are deleted.

The two reflection generators alternate along the cosets of
\(\langle r^d\rangle\). If \(d\) is odd, then
\[
\gcd(d,2n)=1,
\]
so their edges form one \(4n\)-cycle. Multiplication by \(z=r^n\) joins opposite
vertices, giving \(M_{4n}\).

If \(d\) is even, then \(n\) is odd and
\[
\gcd(d,2n)=2.
\]
The reflection edges form two \(2n\)-cycles, and \(z\) joins corresponding vertices of
the two cycles. This is \(C_{2n}\square K_2\). ∎

### Theorem 5.2

For every \(n\ge2\),
\[
\mathcal G(M_{4n})=1.
\tag{5.2}
\]

### Proof

The graph is vertex-transitive. After a move at \(v\), the graph
\[
M_{4n}-N[v]
\]
is the opposite-end-pendant ladder on \(2n-3\) rungs: a ladder with one pendant vertex
attached to one rail at the left end and one pendant vertex attached to the opposite rail
at the right end. This is Brown et al.'s third ladder variation
\({}_{-}L^-_{(2n-3)\times2}\), which their ladder theorem proves has Grundy value zero.
Hence every
option of \(M_{4n}\) has value zero, and
\[
\mathcal G(M_{4n})=\operatorname{mex}\{0\}=1.
\]
The boundary case \(n=2\) gives the same graph identification directly. ∎

### Theorem 5.3

For every \(m\ge3\),
\[
\mathcal G(C_m\square K_2)=0.
\tag{5.3}
\]

This is Brown et al.'s prism corollary.

## 6. Point stabilizers in the tame projective action

Let
\[
A=\langle r\rangle\cong C_{2n},
\qquad
K_e=\langle sr^e\rangle.
\]

### Proposition 6.1

Every point stabilizer of \(D_{4n}\) on \(\mathbf P^1(q)\) is conjugate to
\[
1,\qquad A,\qquad K_0,\qquad K_1.
\tag{6.1}
\]

### Proof

A point stabilizer in \(PGL_2(q)\) is contained in a Borel subgroup. Its normal unipotent
subgroup has order a power of \(p\); since \(p\nmid |G|\), the intersection of \(G\) with
that subgroup is trivial. Projection to the cyclic quotient of the Borel by its unipotent
subgroup is therefore injective on the point stabilizer, so the stabilizer is cyclic.

If the stabilizer contains a nonidentity rotation, the point is one of the two fixed
points of the rotation torus over the splitting field and is therefore fixed by all of
\(A\). Otherwise the stabilizer is generated by a reflection. Because the rotation order
is even, the reflections form two conjugacy classes, represented by \(K_0\) and \(K_1\).
∎

### Proposition 6.2

The rotation-stabilized template is empty:
\[
R(D_{4n},A,T_d)=\varnothing.
\tag{6.2}
\]

### Proof

The two cosets of \(A\) are fixed by
\[
s(sr^d)=r^d\in A,
\]
so both are deleted by (3.1). ∎

## 7. Reflection-stabilized templates

Label the cosets \(D_{4n}/K_e\) by
\[
j\in\mathbf Z/(2n),
\qquad
j\leftrightarrow r^jK_e.
\]
The generators act as
\[
z:j\mapsto j+n,\qquad
s:j\mapsto e-j,\qquad
sr^d:j\mapsto e-d-j.
\tag{7.1}
\]

The two reflection maps have product \(j\mapsto j+d\). The deleted vertices are the
solutions of
\[
2j=e+n
\quad\text{or}\quad
2j=e-d+n
\pmod{2n}.
\tag{7.2}
\]

### Theorem 7.1

For odd \(d\),
\[
R(D_{4n},K_e,T_d)\cong L_{n-1},
\tag{7.3}
\]
independently of \(e\).

For even \(d\), necessarily \(n\) odd,
\[
R(D_{4n},K_e,T_d)\cong
\begin{cases}
L_n,&e\text{ even},\\
L_{n-2},&e\text{ odd}.
\end{cases}
\tag{7.4}
\]

### Proof

Because \(\gcd(d,n)=1\), reduction modulo \(n\) makes translation by \(d\) transitive on
\(\mathbf Z/n\), regardless of the parity of \(d\). Quotient the coset set by the
fixed-point-free central involution \(z:j\mapsto j+n\). On the quotient, the two
reflection maps are involutions whose product is this transitive translation. Their
simple edge union is connected and has maximum degree two. The two quotient reflections
have two fixed points in total: each has one when \(n\) is odd, while for even \(n\) one
has two and the other has none. Suppressing the corresponding loops leaves \(n-1\) edges,
so the quotient reflection graph is the path \(P_n\), with those fixed points as its
endpoints.

Each solvable congruence in (7.2) has two solutions differing by \(n\), hence deletes one
\(z\)-orbit. After reduction modulo \(n\), the two congruences are exactly the fixed-point
equations for the two quotient reflections, so every deleted \(z\)-orbit is an endpoint
of \(P_n\). If \(d\) is odd, the right-hand sides in (7.2) have opposite parity, so
exactly one endpoint orbit is deleted and the live quotient is \(P_{n-1}\). If \(d\) is
even, then \(n\) is odd. For even \(e\), neither congruence is solvable and the live
quotient is \(P_n\); for odd \(e\), both are solvable and the live quotient is
\(P_{n-2}\).

Finally, the lift over any of these paths is untwisted: choose either lift of one endpoint
and propagate it along the unique path. Edges above quotient path edges form two rails,
exchanged by \(z\), and the \(z\)-edges form the rungs. A reflection above a suppressed
endpoint loop either gives loops upstairs or duplicates its rung, neither of which changes
the underlying simple graph. The three cases therefore give \(L_{n-1}\), \(L_n\), and
\(L_{n-2}\), respectively. ∎

Brown et al. prove
\[
\mathcal G(L_k)=
\begin{cases}
1,&k\text{ odd},\\
0,&k\text{ even}.
\end{cases}
\tag{7.5}
\]
Therefore
\[
\mathcal G(R(D_{4n},K_e,T_d))=
\begin{cases}
1_{2\mid n},&d\text{ odd},\\
1,&d\text{ even}.
\end{cases}
\tag{7.6}
\]

## 8. Complete orbit formulas

Let \(\Omega\) be a finite \(D_{4n}\)-set all of whose point stabilizers are conjugate to
one of \(1,A,K_0,K_1\). In particular, Proposition 6.1 shows that the natural tame action
on \(\mathbf P^1(q)\) has this property. Write
\[
\Omega\cong
f(D_{4n}/1)
\sqcup
b_A(D_{4n}/A)
\sqcup
b_0(D_{4n}/K_0)
\sqcup
b_1(D_{4n}/K_1),
\tag{8.1}
\]
with nonnegative integer multiplicities.

### Theorem 8.1

For odd \(d\),
\[
\mathcal G(R_{T_d}(\Omega))
=
(f\bmod2)
\oplus
\left(1_{2\mid n}\bigl((b_0+b_1)\bmod2\bigr)\right).
\tag{8.2}
\]

For even \(d\), necessarily \(n\) odd,
\[
\mathcal G(R_{T_d}(\Omega))
=
(b_0+b_1)\bmod2.
\tag{8.3}
\]

The multiplicity \(b_A\) does not occur because its template is empty.

For the natural action on \(\mathbf P^1(q)\), each exceptional class occurs at most once.
Write its indicators as
\[
\varepsilon,a_0,a_1\in\{0,1\}.
\]
Then
\[
q+1=4nf+2\varepsilon+2n(a_0+a_1).
\tag{8.4}
\]

## 9. Closed finite-field formulas

Assume \(p\nmid4n\).

### 9.1 Split torus

Suppose \(2n\mid q-1\). Choose
\[
r:t\mapsto\omega t,\qquad s:t\mapsto t^{-1},
\]
where \(\omega\) has order \(2n\).

The rotation torus fixes \(0,\infty\), so \(\varepsilon=1\). The two reflection classes
are represented by
\[
t\mapsto t^{-1},
\qquad
t\mapsto\omega t^{-1}.
\]
The first is split. The second is split exactly when \(\omega\) is a square, equivalently
when
\[
4n\mid q-1.
\]

Put
\[
h_-=\frac{q-1}{2n},
\qquad
\delta_-=1_{4n\mid q-1}.
\]
Then
\[
a_0=1,\qquad a_1=\delta_-,
\qquad
f=\frac{h_--1-\delta_-}{2}.
\tag{9.1}
\]

For odd \(d\),
\[
\boxed{
\mathcal G(R_{T_d})
=
\left(\frac{h_--1-\delta_-}{2}\bmod2\right)
\oplus
\left(1_{2\mid n}(1-\delta_-)\right).
}
\tag{9.2}
\]

For even \(d\),
\[
\boxed{
\mathcal G(R_{T_d})=1-\delta_-.
}
\tag{9.3}
\]

### 9.2 Nonsplit torus

Suppose \(2n\mid q+1\). Model the projective line by the norm-one group
\[
U=\{x\in\mathbf F_{q^2}^{\times}:x^{q+1}=1\},
\]
and choose
\[
r:x\mapsto\omega x,\qquad s:x\mapsto x^{-1},
\]
with \(\omega\in U\) of order \(2n\).

The rotation torus has no rational fixed points, so \(\varepsilon=0\). The two reflection
classes have fixed-point equations
\[
x^2=1,\qquad x^2=\omega.
\]
Thus the first is split and the second is split exactly when
\[
4n\mid q+1.
\]

Put
\[
h_+=\frac{q+1}{2n},
\qquad
\delta_+=1_{4n\mid q+1}.
\]
Then
\[
a_0=1,\qquad a_1=\delta_+,
\qquad
f=\frac{h_+-1-\delta_+}{2}.
\tag{9.4}
\]

For odd \(d\),
\[
\boxed{
\mathcal G(R_{T_d})
=
\left(\frac{h_+-1-\delta_+}{2}\bmod2\right)
\oplus
\left(1_{2\mid n}(1-\delta_+)\right).
}
\tag{9.5}
\]

For even \(d\),
\[
\boxed{
\mathcal G(R_{T_d})=1-\delta_+.
}
\tag{9.6}
\]

For fixed \(n\), these formulas are periodic in \(q\) with period dividing \(8n\) within
each torus family.

## 10. A worked example: \(D_{12}\)

Take \(n=3\), so
\[
G=D_{12}
\]
has rotation order six. There are two legal triple types.

For odd \(d\), each free orbit contributes
\[
\mathcal G(M_{12})=1,
\]
while every reflection orbit contributes
\[
\mathcal G(L_2)=0.
\]
Hence the value is simply \(f\bmod2\).

For even \(d\), each free orbit is the prism
\[
C_6\square K_2
\]
and contributes zero. Each split reflection class contributes a ladder \(L_3\) or \(L_1\),
both of value one. Thus the total value is
\[
a_0\oplus a_1.
\]

In the split-torus family \(6\mid q-1\), the second reflection class is split exactly when
\(12\mid q-1\). Therefore the even-\(d\) position is P exactly when
\[
12\mid q-1.
\]

## 11. Additive mod-two Burnside invariant

Fix a finite group \(G\) and a finite involution set \(T\), as in Section 3. Define
\[
\Phi_T(\Omega)=\mathcal G(R_T(\Omega))
\]
for every finite \(G\)-set \(\Omega\).

We are not aware of a previous use of a Grundy value as an additive Burnside-group
invariant. The statement is not dihedral and does not assert compatibility with the
multiplication in the Burnside ring.

### Theorem 11.1

The map \(\Phi_T\) is additive under disjoint union and extends uniquely to a homomorphism
from the additive group underlying the Burnside ring:
\[
\Phi_T:A(G)\longrightarrow(\mathbb N_0,\oplus).
\tag{11.1}
\]
It vanishes on \(2A(G)\), and therefore factors through the mod-two Burnside group
\[
A(G)\otimes_{\mathbf Z}\mathbf F_2.
\tag{11.2}
\]

### Proof

The construction \(R_T\) respects disjoint unions, and Grundy values xor over graph
components. Thus
\[
\Phi_T(\Omega\sqcup\Omega')
=
\Phi_T(\Omega)\oplus\Phi_T(\Omega').
\]
The Grothendieck-group universal property gives the extension. Finally,
\[
\Phi_T(\Omega\sqcup\Omega)=0,
\]
so doubled classes lie in the kernel. ∎

### Corollary 11.2: bulk cancellation

If a finite \(G\)-set has \(f\) free orbits and exceptional part
\(\Omega_{\mathrm{exc}}\), then
\[
\Phi_T(\Omega)
=
(f\bmod2)\Phi_T(G/1)
\oplus
\Phi_T(\Omega_{\mathrm{exc}}).
\tag{11.3}
\]

Thus arbitrarily many generic free orbits contribute either nothing or a single parity
bit.

## 12. Periodicity and prime density

For fixed \((G,T)\), the projective-line value is determined by:

- \(q\bmod2|G|\);
- the bounded list of exceptional orbit indicators.

This follows from the orbit equation
\[
q+1
=
|G|f+
\sum_K a_K[G:K],
\tag{12.1}
\]
which determines \(f\bmod2\).

For the dihedral family, the exceptional indicators are controlled by
\(4n\mid q\mp1\), so period \(8n\) suffices.

### Theorem 12.1

Fix \(n\ge2\), a legal triple type, and either the split or nonsplit torus family. Among
admissible prime fields, the relative Dirichlet density of P positions is
\[
\frac12,
\]
and the relative density of N positions is also \(\frac12\).

### Proof

Let
\[
h=\frac{q-1}{2n}
\]
in the split case and
\[
h=\frac{q+1}{2n}
\]
in the nonsplit case. The four possibilities \(h\bmod4\) give four admissible reduced
residue classes modulo \(8n\).

For odd \(d\), the values for \(h\bmod4=0,1,2,3\) are
\[
\begin{array}{c|cccc}
&0&1&2&3\\
\hline
n\text{ odd}&1&0&0&1\\
n\text{ even}&1&1&0&0.
\end{array}
\tag{12.2}
\]
For even \(d\), necessarily \(n\) odd, they are
\[
0,1,0,1.
\tag{12.3}
\]
Thus exactly two of the four classes are P. The prime number theorem for arithmetic
progressions, equivalently its standard Dirichlet-density consequence, gives the same
Dirichlet density to each reduced residue class. Relative to primes in the chosen torus
family, the four classes therefore each have density \(1/4\), proving the claim. ∎

## 13. Converse realization

### Theorem 13.1

For the Klein-four boundary, \(K_4\) occurs over infinitely many prime fields as a
transitive residual template of a legal tame conic-involution triple.

For every \(n\ge2\), the graphs
\[
M_{4n},\qquad
L_{n-1}
\tag{13.1}
\]
and the completely deleted rotation-torus template occur over infinitely many prime
fields as transitive residual templates of legal tame dihedral conic-involution triples.
If \(n\ge3\) is odd, the same is true of
\[
C_{2n}\square K_2,\qquad L_n,\qquad L_{n-2}.
\tag{13.2}
\]

### Proof

The abstract coset calculations in Sections 5--7 produce the listed graph whenever the
corresponding orbit type occurs.

For the Klein-four assertion, take primes \(q\equiv3\pmod4\) and the standard commuting
triple
\[
t\mapsto-t,\qquad t\mapsto a/t,\qquad t\mapsto-a/t
\]
with \(a\) a square. Its centres form a legal self-polar triangle. Exactly two of the
three involutions are split, so Theorem 4.1 gives \((q-3)/4\) free \(K_4\)-orbits; this is
positive for \(q\ge7\). Dirichlet's theorem supplies infinitely many such primes.

Choose primes
\[
q\equiv1\pmod{2n}
\]
for split-torus realizations or
\[
q\equiv-1\pmod{2n}
\]
for nonsplit-torus realizations. Stronger congruences modulo \(4n\) realize both
reflection classes. Dirichlet's theorem supplies infinitely many such primes.

The triples \(T_d\) are legal by Section 4. For sufficiently large primes in any chosen
class, equation (8.4) gives \(f>0\), so the free template occurs. Reflection and
rotation-torus templates occur under the splitting conditions described in Section 9. ∎

## 14. Discussion

The classification has a simple conceptual form:

> A legal tame dihedral conic triple produces only \(K_4\)'s, Möbius ladders, prisms,
> ordinary ladders, and completely deleted exceptional orbits. Its conic-only Node-Kayles
> value is an explicit congruence function of the field and embedded triple type.

The fixed-point-deleted Schreier construction separates geometry from game theory. The
abstract pair \((G,T)\) determines a finite table of transitive template nimbers; the
ambient geometry determines only the parity vector of orbit multiplicities.

The unresolved problem beyond the dihedral case is to evaluate the corresponding regular
templates for the polyhedral groups. That extension is not needed for the present
classification.

Even a complete polyhedral table would only round out the proper-small-subgroup boundary.
Generic fourth moves in the motivating projective-cap game typically generate full
\(PSL_2(q)\) or \(PGL_2(q)\); evaluating or controlling those growing residual templates is
a separate problem, and no claim about that odd-plane kernel is made here.

## References

1. S. Brown, S. Daugherty, E. Fiorini, B. Maldonado, D. Manzano-Ruiz, S. Rainville,
   R. Waechter, and T. W. H. Wong, “Nimber Sequences of Node-Kayles Games,”
   *Journal of Integer Sequences* **23** (2020), Article 20.3.5.
2. A. Beauville, “Finite Subgroups of \(PGL_2(K)\),” in *Vector Bundles and Complex
   Geometry*, Contemporary Mathematics **522** (2010), 23–29.
3. M. A. Huggan, S. Huntemann, and B. Stevens, “The Combinatorial Game Nofil Played on
   Steiner Triple Systems,” 2021, arXiv:2103.13501.
4. P. Tranchida, “Triples of Involutions in \(PGL(2,q)\) and Their Incidence
   Geometries,” *Innovations in Incidence Geometry* **22** (2025).
5. Y. Kobayashi, “On Structural Parameterizations of Node Kayles,” 2020,
   arXiv:2003.11775.
6. L. E. Dickson, *Linear Groups with an Exposition of the Galois Field Theory*,
   Teubner, 1901.
7. H. Davenport, *Multiplicative Number Theory*, 3rd ed., revised by H. L. Montgomery,
   Graduate Texts in Mathematics **74**, Springer, 2000.
