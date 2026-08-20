# Module 30. Mobile hyperplane systems as the line-bundle state

**Packet part:** Module 30.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

**Status:** strict-transform state repackaged and source top proved; raw
exceptional-twist nullity is false; cyclotomic transport remains open

## 30.1 The path environment is supplied by a hypothetical birational map

Let

\[
\phi:Y\dashrightarrow \mathbf P^n
\tag{30.1}
\]

be a birational map between smooth projective varieties.  Pull back the
hyperplane linear system as a movable rational linear system
\(V_0\subset H^0(Y,L_0)\).  On every smooth model \(Y_i\) birational to
\(Y\), let \(V_i\subset H^0(Y_i,L_i)\) be its strict transform.

The pair \((L_i,V_i)\), rather than a freely chosen line bundle, is the
correct indexed-State object along a weak factorization of \(\phi\).
The moving-frame relation itself was already isolated in
notes/2026-08-13-c907-base-ideal-framing-obstruction.md; the new point here
is its typed path packaging and the source nonvanishing theorem below.

### Proposition 30.1 -- local state transition

Suppose \(Z\) is connected and

\[
\pi:\widetilde Y=\operatorname{Bl}_Z Y\longrightarrow Y
\tag{30.2}
\]

is one blowup occurrence, with exceptional divisor \(E\).  Let

\[
a=\operatorname{ord}_Z\mathfrak b(V)
\tag{30.3}
\]

be the order of the base ideal of the current linear system along \(Z\).
Then its strict transform satisfies

\[
\widetilde L
\cong
\pi^*L\otimes\mathcal O_{\widetilde Y}(-aE).
\tag{30.4}
\]

The same equation types the occurrence when the zigzag traverses it as a
blowdown.

#### Proof

Locally every section in \(V\) vanishes to order at least \(a\) along the
center.  Its total transform is therefore divisible by the exceptional
equation to order \(a\), and division by that common exceptional factor
gives the strict transform.  This is exactly (30.4).  \(\square\)

For a disconnected smooth center
\(Z=\coprod_\alpha Z_\alpha\), one must retain the componentwise vector
\(a_\alpha=\operatorname{ord}_{Z_\alpha}\mathfrak b(V)\) and replace
\(-aE\) by \(-\sum_\alpha a_\alpha E_\alpha\).  Taking a minimum order over
the union would leave unrecorded fixed exceptional components.

### Corollary 30.1A -- indexed Writer law on a blowup tower

Along a monotone composite of blowups, total pullback gives

\[
L_r
\cong
\pi^*L_0\otimes
\mathcal O\!\left(-\sum_i a_iE_i^{\mathrm{tot}}\right).
\tag{30.5}
\]

Thus, after choosing such a principalizing/dominating model, the correction
is the trace of a Cartier \(b\)-divisor whose coefficients are the orders of
the fixed mobile system.  Composition adds coefficients after the required
pullback of earlier exceptional divisors.

This is an indexed Writer law, not an ordinary unindexed sum:
the mapping function on correction divisors is part of composition.
The strict-transform construction supplies it canonically, so no
independent per-edge line-bundle choice is needed.

On a general zigzag, (30.5) is not an unsigned accumulation law.  The state
is the objectwise trace of the fixed mobile system; a reverse edge uses the
inverse signed Cartier transition and cancels the forward one.  Its Writer
target is therefore a Picard groupoid (or signed divisor group with
pull--push maps), not a commutative monoid of effective divisors.  Reverse
ExactTop transport likewise uses the inverse of the typed forward
isomorphism.

## 30.2 The operation defect is now one exceptional twist

Tensoring by (30.4) factors as

\[
\tau_{\widetilde L}
=
\tau_{\pi^*L}\,\tau_{\mathcal O(-aE)}.
\tag{30.6}
\]

Projection formula makes \(\tau_{\pi^*L}\) block diagonal on the Orlov
ambient and center components.  Therefore every failure of the descending
line-bundle law is concentrated in

\[
C_{\pi,a}:=\tau_{\mathcal O(-aE)}.
\tag{30.7}
\]

If \(a=0\), Module 29 applies directly to this occurrence.  If \(a>0\),
discarding \(a\) is hypothesis smuggling: \(C_{\pi,a}\) can mutate or mix
the ambient and exceptional components.

For the rank/Boolean ExactTop consumer, the exact local question is not
whether \(C_{\pi,a}=1\).  After the actual comparison
\(\Psi\), put

\[
S_m
:=
\operatorname{im}
\left(\Psi(1-\tau_{\widetilde L})^m\Psi^{-1}\right)
\subset V_L\oplus E_\pi.
\tag{30.8}
\]

The typed question is whether

\[
p_L(S_m)=\operatorname{im}(1-\tau_L)^m,
\qquad
S_m\cap(0\oplus E_\pi)=0.
\tag{30.8a}
\]

These are exactly the projection/graph conditions of Module 28; no map into
the desired top is named before landing is proved.  If one also has an actual oriented \(K[N]\)-exact
sequence and the exceptional exponent \(N_E^m=0\), this question can instead
be computed by the associated Module 25 boundary.  Without those fields the
boundary is not typed.

This localizes the global path problem to a contextual family indexed by

\[
(Z,\sigma,L,V,N,\Psi,o,a,\chi,m),
\tag{30.9}
\]

where \(o\) is the edge orientation and \(\sigma\) includes the actual
specialization/comparison frame.  ExactTop-nullity is not a property of the
abstract correction \(C_{\pi,a}\) alone; it depends on the ambient operator
and its comparison frame.

### Proposition 30.1B -- raw ExactTop-nullity is false

The correction \(C_{\pi,a}\) is not universally ExactTop-null on raw
\(K_0\).  For linear projection
\(\mathbf P^5\dashrightarrow\mathbf P^2\) from a plane, let

\[
\mu:R=\operatorname{Bl}_{\mathbf P^2}\mathbf P^5\to\mathbf P^5,
\qquad
f:R\to\mathbf P^2.
\]

The resolved moving frame is

\[
L=f^*\mathcal O(1)
=\mu^*\mathcal O(1)\otimes\mathcal O_R(-E),
\]

and

\[
(1-\tau_L)^2=[\mathcal O_{\mathbf P^3\text{-fibre}}]\ne0,
\qquad
(1-\tau_L)^3=0.
\tag{30.9a}
\]

Thus \(\mathcal O(-E)\) creates a raw \(J_3\) although both the projective
ambient model and the surface center have empty primitive cubic packet.
This is the exact counterexample proved in the C907 base-ideal report.

The remaining possibility is character-projected: an independently
constructed common \(\chi\)-receiver may kill the raw trivial-sector
string.  It must do so after the actual exceptional twist; center
packet-emptiness before twisting is insufficient.

## 30.3 A hypothetical rationality map still gives the required source top

Now take

\[
Y=X\times\mathbf P^m,
\qquad
\phi:Y\dashrightarrow\mathbf P^{m+3},
\qquad m\ge1,
\tag{30.10}
\]

where \(X\) is a smooth cubic threefold.  Write the moving hyperplane class
of \(\phi\) as

\[
L_0\cong p_X^*D\otimes p_{\mathbf P}^*\mathcal O(a)
\tag{30.11}
\]

using
\(\operatorname{Pic}(X\times\mathbf P^m)
\cong\operatorname{Pic}(X)\oplus\mathbf Z\).

### Proposition 30.2 -- positive projective coefficient

The integer \(a\) in (30.11) is positive.

#### Proof

The moving linear system defining \(\phi\) has nonzero sections, so
\(a\ge0\).  If \(a=0\), every section of \(L_0\) is pulled back from \(X\);
the rational map factors through the three-dimensional projection to \(X\).
It cannot be birational from the \((m+3)\)-fold \(Y\) when \(m\ge1\).
Therefore \(a>0\).  \(\square\)

### Proposition 30.3 -- the mobile source has nonzero threshold top

Let \(V_X\ne0\) be the retained cubic \(\chi\)-sector.  Assume it is
preserved by tensor-by-\(D\), that this action is invertible, and that the
line-bundle action is product-monoidal.  On

\[
V_X\otimes K_0(\mathbf P^m)_{\mathbf C},
\tag{30.12}
\]

put

\[
A=\tau_D,\qquad
B=\tau_{\mathcal O(a)},\qquad
N=1-A\otimes B.
\tag{30.13}
\]

Then

\[
N^m\ne0.
\tag{30.14}
\]

#### Proof

Write \(B=1+U\).  Since \(a>0\) and the ground field has characteristic
zero, multiplication by
\([\mathcal O(a)]-1\) is a uniformizer of
\(K_0(\mathbf P^m)_{\mathbf C}\).  Hence

\[
U^{m+1}=0,\qquad U^m\ne0
\tag{30.15}
\]

on \(K_0(\mathbf P^m)_{\mathbf C}\), and
\(1,U,\ldots,U^m\) is a basis of its cyclic module generated by \(1\).  In

\[
N=(1-A)\otimes1-A\otimes U,
\tag{30.16}
\]

apply \(N^m\) to \(v\otimes1\), where \(0\ne v\in V_X\).  Its coefficient
of the basis vector \(U^m\) is

\[
(-1)^mA^m\otimes U^m.
\tag{30.17}
\]

The tensor action \(A\) is invertible, so
\((-1)^mA^mv\ne0\).  Linear independence of
\(1,U,\ldots,U^m\) prevents cancellation with the lower \(U\)-coefficients.
Hence \(N^m(v\otimes1)\ne0\).  \(\square\)

This proof does not require \(A=1\), a chosen point row, or the original
product projection line bundle.  It does require the lawful
\(\chi\)-sector preservation just stated; that compatibility cannot be
inferred merely from the unmarked direct-sum shape.  Subject to it, the line
bundle supplied by the hypothetical rationality map itself carries the
source obstruction.

On a fixed non-turning formal locus, the intrinsic source-side preservation
is already supplied by
notes/2026-08-13-c907-formal-primary-galois-stability.md: parameter
line-bundle monodromy preserves the whole generalized \(\chi\)-primary
sector, and Iritani's Gamma framing is product-natural.  What remains open
here is not that intrinsic source law, but its occurrence-wise realization
in the same comparison receiver used for the exceptional twist.

## 30.4 Endpoint and telescope

Take as an independent common-receiver endpoint input that the retained
cubic \(\chi\)-sector of the projective endpoint is empty.  Then the
corresponding top image is zero for \(\mathcal O(1)\).  This emptiness is
not a consequence of Proposition 30.3.

Under the \(\chi\)-sector preservation and product-operation hypotheses of
Proposition 30.3, the source/endpoints therefore contrast for the mobile
line-bundle state:

\[
\operatorname{Top}_m
\bigl(X\times\mathbf P^m,L_0;\chi\bigr)\ne0,
\qquad
\operatorname{Top}_m
\bigl(\mathbf P^{m+3},\mathcal O(1);\chi\bigr)=0.
\tag{30.18}
\]

After supplying the common \(\chi\)/product receiver and Module 29's local
cocharacter/Levelt certificates, the remaining moving-state telescope issue
is whether every **projected** exceptional-twist occurrence (30.9) preserves
that Boolean/rank top.  A theorem of the form

\[
\boxed{
\begin{gathered}
\text{for every actual contextual occurrence}\\
\omega=(Z,\sigma,L,V,N,\Psi,o,\mathbf a,\chi,m),\\
C_{\pi,\mathbf a}\text{ is ExactTop-null relative to }\omega
\end{gathered}
}
\tag{30.19}
\]

together with those common-provider certificates and the independent center
exponent bound would prove the contradiction.  Proposition 30.1B shows that
(30.19) is false if “ExactTop-null” is interpreted on unprojected raw
\(K_0\).

This is stronger information than the earlier statement “find a coherent
line bundle along the path”: the coherent mobile state exists canonically.
What remains is its exceptional correction law.

## 30.5 Relation to base ideals and sparse shadows

The coefficient \(a\) is the sparse shadow of the base ideal seen by the
divisorial valuation \(E\).  The full ideal need not be reconstructed.
For composition one retains:

1. the current line-bundle class;
2. the exceptional valuation \(a\);
3. the pullback map on earlier exceptional divisors; and
4. the threshold image or boundary consumed later.

This is exactly a Reader/indexed-State/Writer interface:

\[
\text{Reader: current model and center},\qquad
\text{State: }(L,V),\qquad
\text{Writer: }aE,\qquad
\text{consumer: ExactTop}.
\tag{30.20}
\]

The lens back to the richer mobile system is needed only when computing the
next valuation.  Once the local correction \(C_{\pi,a}\) has been evaluated,
the consumer may forget the full base ideal again.

## 30.6 \(m=2\) and all-\(m\)

At \(m=2\), Proposition 30.3 supplies a nonzero source
\(\operatorname{Top}_2\) for every hypothetical birational map for which
the stated common \(\chi\)-sector and product-operation provider exists,
even when its pulled-back hyperplane is not the original
\(\mathcal O_{\mathbf P^2}(1)\).  The local target is, for every actual
projected occurrence,

\[
\text{compute }\tau_{\mathcal O(-aE)}
\text{ on its Iritani packet and its }N^2\text{-image}.
\tag{30.21}
\]

The linear-projection example shows that this computation cannot be
replaced by a dimension-only raw \(K_0\) argument.  It must use the lawful
primitive-character receiver or another support-sensitive quotient.
Codimension two is only the newly difficult threefold-carrier case after
the lower-dimensional occurrence adapters have been proved in that same
receiver; Proposition 30.1B itself is a codimension-three warning.

For all \(m\), the same mobile-system construction and Proposition 30.3 are
uniform.  Therefore no new source calculation is required at larger
stabilization index.  The uniform missing theorem is (30.19), combined with
the occurrence-indexed carrier bound of Module 24.

The valuation \(a\) may offer extra arithmetic structure.  For example, if
the retained leakage is polynomial in \(a\), vanishing at enough lawful
specializations or a divisibility law could kill it without proving
componentwise strictness.  No such law is currently established.

## 30.7 EJ/TT audit

**EJ.** The hypothetical counterexample provides its own operation state.
This removes the apparent need to choose one global descending projective
factor line bundle before seeing the birational map.  The observation
refines, rather than supersedes, the earlier C907 moving-frame obstruction.

**TT.** The gain must not be overstated:

1. strict transforms solve path coherence, not transport;
2. the exceptional twist is precisely where component mixing can occur;
3. Proposition 30.3 proves only source nonvanishing, not the sharp center
   bound; and
4. the primitive character sector and every occurrence specialization still
   need one lawful receiver.

## 30.8 Mystery ledger

| question | status | exact evidence or gate |
|---|---|---|
| Is there a coherent line-bundle state attached to a hypothetical birational map? | **settled: yes** | strict transforms of its hyperplane system, Proposition 30.1 |
| What is the composition law? | **settled** | monotone tower law (30.5); signed Picard-groupoid transitions on a zigzag |
| Does the mobile source retain a top above threshold? | **settled: yes** | Propositions 30.2--30.3 |
| Does pure pullback transport strictly? | **conditional locally** | projection formula plus Module 29's cocharacter/Levelt certificate |
| Is the retained \(\chi\)-sector preserved intrinsically by a mobile \(D\)-action? | **settled on a fixed non-turning locus** | C907 formal-primary Galois stability |
| Is that sector realized in the same occurrence-wise comparison receiver? | **open provider typing** | Module 29 cocharacter/Levelt and comparison gate |
| Is the exceptional twist harmless on raw \(K_0\)? | **settled: no** | Proposition 30.1B / C907 linear-projection counterexample |
| Is its projected \(\chi\)-part harmless? | **open central gate** | compute (30.8)/(30.21) in the common receiver |
| Is leakage polynomial or divisible in \(a\)? | **open** | no operation-framed calculation yet |
| Does the center satisfy the sharp indexed exponent bound? | **open independent gate** | Module 24.C |

## Boundary

Propositions 30.1--30.3 are proved at the stated algebraic level.  They
replace an untyped global line-bundle choice by the canonical mobile
hyperplane state of a hypothetical birational map.  They do not prove that
exceptional twists preserve ExactTop, so no unconditional \(m=2\) or
all-\(m\) theorem follows.
