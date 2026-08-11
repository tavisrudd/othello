# C904: exact descent obstruction to halving the relative Shen cycle

**Date:** 2026-08-10

**Status:** theorem-grade descent certificate; quarantined Annals research;
no manuscript or Lean changes

**Scope:** halving
\(z=(\phi_+)_*\widetilde\theta\) on the generic relative divisor \(D_+\),
restriction--corestriction, Galois descent, and the precise reach of
`C_1`-field theorems

## Executive verdict

Let \(B\) be a smooth integral complex curve, \(K=\mathbf C(B)\), and let
\(D=D_{+,K}\) be the generic Fano-sum divisor. Assume that the relative
construction gives

\[
                    z\in CH_1(D)
\]

and that Shen's geometric argument gives a half after algebraic closure:

\[
             z_{\overline K}=2\eta_{\overline K}
                    \quad\text{in }CH_1(D_{\overline K}).
\]

The exact descent obstruction is simply

\[
 o_K(z):=[z]\in
 \ker\!\left(
 CH_1(D)/2\longrightarrow CH_1(D_{\overline K})/2
 \right).                                                    \tag{E.1}
\]

It vanishes if and only if \(z\) has an integral half over \(K\).
There is no justified replacement of (E.1) by a torsor under \(J[2]\).

Over \(\overline K\), the set of halves is a torsor under the actual group

\[
                         T=CH_1(D_{\overline K})[2],           \tag{E.2}
\]

not under \(J[2]\). A chosen geometric half gives a genuine Galois class

\[
             \alpha_z\in H^1(K,T),\qquad
             \alpha_z(\sigma)=\sigma\eta_{\overline K}
                                  -\eta_{\overline K}.         \tag{E.3}
\]

This class measures only whether there is a **Galois-invariant geometric
half**. Even \(\alpha_z=0\) does not by itself give a cycle over \(K\):
ordinary Chow groups do not satisfy automatic Galois descent in higher
codimension.

There is, however, one clean and useful descent theorem.

> **Odd-degree halving theorem.** If \(L/K\) is finite of odd degree and
> \(z_L\) is divisible by two in \(CH_1(D_L)\), then \(z\) is divisible by
> two in \(CH_1(D)\).

Indeed, if \(2\eta_L=\operatorname {res}_{L/K}z\) and
\([L:K]=2q+1\), then

\[
       \eta_K:=\operatorname {cor}_{L/K}\eta_L-qz
       \quad\text{satisfies}\quad 2\eta_K=z.                  \tag{E.4}
\]

Thus a nonzero obstruction survives every odd-degree extension. The exact
minimal-base-change invariant is the gcd of degrees of fields over which a
half exists; it is odd exactly when a \(K\)-half already exists.

The field \(K=\mathbf C(B)\) is \(C_1\) and has cohomological dimension one,
but this does not close (E.1). Graber--Harris--Starr kills a point
obstruction only when the choices are represented by a proper rationally
connected \(K\)-variety. Steinberg kills torsors under connected linear
groups. The half-torsor (E.2) is discrete and potentially Chow-theoretic.
Already

\[
                 H^1(K,\mathbf Z/2)=K^\times/K^{\times2}
\]

is large. Hence neither theorem kills (E.3), the Chow restriction kernel,
or the Chow descent cokernel.

## 1. The intrinsic obstruction and its parity index

Put

\[
 A=CH_1(D),\qquad
 M=CH_1(D_{\overline K}),\qquad
 G=G_K.
\]

The \(G\)-action on \(M\) is continuous for the discrete topology: every
cycle and every rational equivalence is defined over a finite extension.
The relation \(z_{\overline K}\in2M\) says precisely that the class of \(z\)
in \(A/2A\) is geometrically zero. Therefore (E.1) is canonical and
contains the complete answer:

\[
                         o_K(z)=0
             \quad\Longleftrightarrow\quad z\in2CH_1(D).       \tag{1.1}
\]

No smoothness of \(D\) is needed for this definition.

Let

\[
 {\cal H}(z)=\left\{
 L/K\text{ finite}:\ z_L\in2CH_1(D_L)
 \right\}.
\]

This set is nonempty if a geometric half exists. A representative of the
half and a finite chain of rational equivalences proving
\(2\eta=z_{\overline K}\) involve finitely many equations and therefore
descend to some finite extension.

Define the **halving index**

\[
            \operatorname {hind}(z)
                =\gcd\{[L:K]:L\in{\cal H}(z)\}.               \tag{1.2}
\]

### Proposition 1.1: exact parity criterion

\[
          z\in2CH_1(D)
       \quad\Longleftrightarrow\quad
          \operatorname {hind}(z)\text{ is odd}.              \tag{1.3}
\]

**Proof.** One implication is immediate from \(K\in{\cal H}(z)\). For the
other, choose finitely many \(L_i\) and integers \(a_i\) for which
\(\sum_i a_i[L_i:K]=d\) is odd. If \(2\eta_i=z_{L_i}\), then proper
pushforward and flat pullback give

\[
        2\sum_i a_i\operatorname {cor}_{L_i/K}\eta_i=dz.
\]

Writing \(d=2q+1\), subtract \(qz\) from the left-hand half. This gives an
integral \(K\)-cycle whose double is \(z\). \(\square\)

Equivalently, for every odd-degree extension \(L/K\),

\[
 CH_1(D)/2\longrightarrow CH_1(D_L)/2
\]

is injective: corestriction composed with restriction is multiplication by
\([L:K]\), hence the identity modulo two.

This is the sharp restriction--corestriction statement. If \(o_K(z)\ne0\),
every halving field has even degree. No general theorem bounds the least
even degree: geometric definability supplies some finite extension, but not
necessarily a quadratic or a power-of-two extension.

## 2. The genuine Galois torsor

The geometric half-set

\[
 {\cal P}_{\overline K}(z)
       =\{\eta\in M:2\eta=z_{\overline K}\}
\]

is either empty or a principal homogeneous set under

\[
                           T=M[2].
\]

For a chosen half \(\eta\), the formula

\[
 c_\sigma=\sigma\eta-\eta
\]

defines a continuous one-cocycle with values in \(T\). Changing the half
changes it by a coboundary, so

\[
                    \alpha_z=[c]\in H^1(K,T)
\]

is canonical. The connecting sequence for

\[
             0\longrightarrow T\longrightarrow M
               \xrightarrow{\,2\,}2M\longrightarrow0
\]

shows

\[
 \alpha_z=0
 \quad\Longleftrightarrow\quad
 z_{\overline K}\text{ has a half in }M^G.                   \tag{2.1}
\]

Although \(T\) can be very large, the obstruction for this one half is
controlled by a finite two-module. The cocycle is continuous, hence factors
through a finite quotient of \(G\), and the finite orbit of its values
generates a finite \(G\)-stable

\[
                         V_z\subset T.
\]

Thus \(\alpha_z\) comes from \(H^1(K,V_z)\). This is the strongest honest
finiteness statement. The module \(V_z\) is constructed from the Chow orbit
of the chosen half; there is no reason for it to be \(J[2]\), to have rank
ten, or to be constant.

## 3. Why \(J[2]\) is not the coefficient module

The claim that the choices of \(\eta\) form a \(J[2]\)-torsor fails at the
first group-theoretic step:

\[
 \eta,\eta'\text{ are halves}
     \quad\Longrightarrow\quad
 \eta'-\eta\in CH_1(D_{\overline K})[2].
\]

That difference is a one-cycle class on the fourfold \(D_{\overline K}\).
It is not a point of the ambient intermediate Jacobian.

Several additional theorems would be required to replace \(T\) by \(J[2]\):

1. prove that every element of \(T\) is homologically trivial;
2. identify the relevant algebraic/intermediate-Jacobian representative of
   one-cycles on a resolution of \(D\);
3. prove that its two-torsion is the ambient \(J[2]\);
4. prove that the Abel--Jacobi kernel and the two-primary Griffiths layers
   contain no relevant torsion;
5. prove compatibility with Galois descent.

None is contained in Shen's construction. The issue is sharper because
\(D_+=F+F\) is generally singular. Even after resolution, the natural
filtration is

\[
 CH_1(D)_{\rm alg}\subset CH_1(D)_{\rm hom}\subset CH_1(D),
\]

and a two-torsion difference can have contributions not detected by the
ambient \(J\). Mapping a homologically trivial difference to an
intermediate Jacobian only produces a quotient of \(T\); its Abel--Jacobi
kernel remains part of the descent problem unless separately eliminated.

There is also no geometric translation action of all \(J[2]\) on the fixed
divisor \(D_+\). Since \([D_+]=3\Theta\), the polarization kernel of
\(\mathcal O_J(D_+)\) is \(J[3]\). If translation by
\(t\in J[2]\) fixed \(D_+\), it would preserve its line bundle, hence
\(t\in J[2]\cap J[3]=0\). Thus no nonzero two-torsion translation
stabilizes the fixed divisor, and \(J[2]\) does not even supply a
tautological action on its half-set.

## 4. Invariant Chow classes are not descended Chow classes

Let

\[
 r:A=CH_1(D)\longrightarrow M^G
\]

be restriction, and put

\[
 N=\ker r,\qquad C=\operatorname {coker}r.
\]

If \(\alpha_z\ne0\), there is no invariant geometric half and descent has
already failed. Suppose \(\alpha_z=0\). Then the class of \(z\) lies in

\[
 \ker\!\left(A/2A\longrightarrow M^G/2M^G\right).
\]

Choose an invariant half \(h\in M^G\). There are two remaining, logically
separate tests.

1. **Class descent:** the affine set of invariant halves
   \({\cal P}_{\overline K}(z)^G\) must meet \(r(A)\). Equivalently, for at
   least one invariant half \(h\), its class
   \([h]\in C=M^G/r(A)\) must vanish. Changing \(h\) by
   \(t\in T^G\) changes this cokernel class by \([t]\), so the invariant
   datum is the affine subset
   \[
       \{[h+t]:t\in T^G\}\subset C,
   \]
   not a preferred element of \(C[2]\).
2. **Relation descent:** suppose \(h=r(a)\) for \(a\in A\). Then
   \[
                     \delta(a):=2a-z\in N.
   \]
   Replacing \(a\) by \(a+n\), \(n\in N\), changes \(\delta(a)\) by
   \(2n\). Thus, for this descended half class, the final obstruction is
   \[
                         [\delta(a)]\in N/2N.                 \tag{4.1}
   \]
   It vanishes exactly when \(a\) can be corrected by an element of \(N\)
   to satisfy \(2a=z\) over \(K\).

These tests are exact but depend on the chosen invariant half. Their
choice-free compression is the single canonical class \(o_K(z)\) in
(E.1). One should not replace them by the tempting short exact sequence
with \(C[2]\): multiplication by two need not be injective on either Chow
group, so that naïve snake-lemma truncation loses torsion correction terms.

This distinction is essential. For divisors, the Picard--Brauer exact
sequence often converts invariant descent to a Brauer obstruction. There is
no analogous unconditional two-line sequence for ordinary
\(CH_1(D)=CH^3(D)\). Colliot-Thélène emphasizes that already

\[
 CH^2(Y)\longrightarrow CH^2(Y_{\overline K})^G
\]

can be neither injective nor surjective for smooth projective \(Y\) with a
rational point. His precise descent sequences require \(K_2\) and
unramified-cohomology hypotheses. They do not specialize to an automatic
descent theorem for \(CH^3\) of the singular fourfold \(D_+\).

Therefore a Hochschild--Serre calculation on singular or étale cohomology
can control the cohomology class of a half without descending the Chow
class. Substituting cohomological descent for Chow descent is not legitimate
at this gate.

## 5. What the \(C_1\) theorems kill

For \(K=\mathbf C(B)\):

- Tsen gives that \(K\) is \(C_1\), hence \(\operatorname {Br}K=0\);
- \(K\) has cohomological dimension one;
- Steinberg's Theorem 1.9 gives \(H^1(K,G)=1\) for every connected linear
  algebraic group \(G\), and rational points on its homogeneous spaces;
- Graber--Harris--Starr gives a \(K\)-point on every proper geometrically
  rationally connected \(K\)-variety.

These results genuinely close:

1. Severi--Brauer and conic obstructions represented by classes in
   \(\operatorname {Br}K\);
2. torsors under connected linear groups;
3. a cycle-choice problem already represented by a proper rationally
   connected parameter variety over \(K\).

They do **not** close:

1. a finite disconnected torsor such as \({\cal P}_{\overline K}(z)\);
2. \(H^1(K,V_z)\) for a finite two-module;
3. torsors under abelian varieties;
4. the Chow kernel \(N\) or descent cokernel \(C\) in Section 4;
5. the existence of a rationally connected parameter space representing
   integral Chow halves and the rational equivalences proving the half
   relation.

The simplest countercheck is

\[
 H^1(K,\mathbf Z/2)
    =H^1(K,\mu_2)=K^\times/K^{\times2}\ne0.
\]

A rational function with an odd valuation gives a nontrivial class.
If \(J[2]\) were constant, then after choosing a basis one would have

\[
 H^1(K,J[2])\simeq
       (K^\times/K^{\times2})^{10},
\]

so even the hoped-for smaller coefficient module would not be killed by the
`C_1` property.

Cohomological dimension one does give
\(H^i(K,V)=0\) for \(i\ge2\) and finite torsion \(V\). That is irrelevant
to the primary class \(\alpha_z\in H^1(K,V_z)\), and it says nothing by
itself about the two Chow-descent tests in Section 4.

Finally, the Colliot-Thélène--Pirutka descent theorem for codimension-two
cycles on a cubic threefold over \(\mathbf C(B)\) does not apply here. The
object is \(CH^3(D_+)\) on a Fano-sum fourfold. In the cubic-threefold
setting, the strongest surjectivity result itself uses a universal
codimension-two cycle, which is one of the structures C904 is trying to
construct; importing it here would be both out of range and circular.

## 6. Exact ways to close the gate

Any one of the following would suffice.

1. **Direct relative half.** Construct
   \(\eta_K\in CH_1(D)\) and an explicit rational equivalence
   \(2\eta_K=z\).
2. **Odd multisection.** Produce a finite odd-degree extension \(L/K\)
   carrying a half. Formula (E.4) descends it immediately.
3. **Representable rationally connected half-space.** Construct a proper
   geometrically rationally connected \(K\)-variety \(P\), a universal
   one-cycle on \(P\times D\), and a universal proof that its double is
   \(z\). GHS then gives a \(K\)-point. Merely knowing that some auxiliary
   moduli fibre is rationally connected is insufficient.
4. **Full two-primary descent calculation.** Compute the finite cocycle
   module \(V_z\) and kill \(\alpha_z\), find an invariant half whose class
   vanishes in \(C\), and then kill its relation class in \(N/2N\).

If \(V_z\) is proved constant, its Galois class can be killed by a finite
two-power extension. This closes only the invariant-half stage. Without
control of \(N\) and \(C\), it still does not prove the half relation over
that field or over \(K\).

The cheapest decisive certificate is therefore an **odd-degree field of
definition for a complete half relation**, not a Galois-invariant
cohomology class and not an odd point on an unrelated rationally connected
fibre.

## 7. Primary-source and convention ledger

1. **Mingmin Shen, _Rationality, universal generation and the integral
   Hodge conjecture_, arXiv:1602.07331.** Read depth:
   **claim-specific partial**, Theorem 5.1, Lemma 5.6, and Proposition 5.7
   with proofs. Proposition 5.7 is the source of
   \((\phi_+)_*\widetilde\theta=2\eta\) over an algebraically closed field;
   it contains no relative Galois descent. Cached PDF SHA-256
   `2e0f3a438379830b85e0e63fce9b6d85e621c3e3d1fbbe84a4a6117773c1007c`.
2. **William Fulton, _Intersection Theory_, 2nd ed.** Read depth:
   **claim-specific standard reference**, Chapter 1 on proper pushforward
   and flat pullback. These operations give
   \(\operatorname {cor}\operatorname {res}=[L:K]\) on Chow groups for a
   finite field extension.
3. **Tom Graber, Joe Harris, and Jason Starr, _Families of rationally
   connected varieties_, JAMS 16 (2003), 57--67,
   arXiv:math/0109220.** Read depth: **claim-specific partial**, statement
   of the main theorem and its hypotheses. ArXiv source archive SHA-256
   `0c855a8538e5ac27f12bebea6b9e00de73067aa5c8a0c65ff2c32bc4d245a93a`.
4. **Robert Steinberg, _Regular elements of semi-simple algebraic groups_,
   Publ. Math. IHÉS 25 (1965), 49--80.** Read depth:
   **claim-specific partial**, Theorem 1.9 and its proof in Section 10:
   over a perfect field of cohomological dimension at most one,
   \(H^1(k,G)=1\) for connected linear \(G\), and its homogeneous spaces
   have rational points. Cached PDF SHA-256
   `bda20c4a4b3cf4a7e9e5b17a4eacd0147d0c9370063ab3a3778114a53c8349b9`.
5. **Jean-Louis Colliot-Thélène, _Descente galoisienne sur le second groupe
   de Chow : mise au point et applications_, arXiv:1302.3215.** Read depth:
   **claim-specific partial**, introduction, the kernel/cokernel descent
   sequences, and the cubic-hypersurface application. The introduction
   explicitly warns that \(CH^2(Y)\to CH^2(Y_{\overline K})^G\) is in
   general neither injective nor surjective, even for smooth projective
   \(Y\) with a rational point. ArXiv source archive SHA-256
   `a82d70eadf0f1b04607b954d73c02a4acdcd59a60aa4542c2b31a185e8696144`.
6. **Jean-Louis Colliot-Thélène and Alena Pirutka, _Troisième groupe de
   cohomologie non ramifiée d'un solide cubique sur un corps de fonctions
   d'une variable_, EpiGA 2 (2018), arXiv:1709.00597.** Read depth:
   **scope check only**, abstract and theorem scope: codimension-two descent
   on a cubic threefold over a complex curve function field. It is recorded
   here to prevent an invalid transfer to \(CH^3(D_+)\).

## 8. Mystery ledger

- **Settled:** the canonical obstruction is \([z]\) in the geometric kernel
  of \(CH_1(D)/2\), equation (E.1).
- **Settled:** geometric halves form a torsor under
  \(CH_1(D_{\overline K})[2]\), not under \(J[2]\).
- **Settled:** the Galois cocycle is finite-module-valued for this specific
  half, but its finite module is an a priori Chow-theoretic \(V_z\).
- **Settled:** any odd-degree half descends by an explicit norm formula.
- **Settled:** the halving index is odd exactly when the half exists over
  \(K\).
- **Settled:** GHS, Steinberg, Tsen, and cohomological dimension one do not
  kill the finite \(H^1\) obstruction or higher-Chow descent defects.
- **Open:** compute \(\alpha_z\) or construct an odd-degree complete half
  relation.
- **Open:** if \(\alpha_z=0\), find an invariant half whose class vanishes
  in \(C\), then compute its relation-descent class in \(N/2N\).
- **Open:** represent the half choices by a proper rationally connected
  parameter space with a universal integral cycle and universal rational
  equivalence.

**Vibe:** the relative factor two is a genuine \(CH_1/2\) descent class.
The function field is hospitable to rationally connected choices and hostile
to Brauer obstructions, but it does not make discrete two-torsors or
higher-codimension Chow descent disappear.
