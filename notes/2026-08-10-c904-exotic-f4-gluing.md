# C904: the exotic $\mathbf F_4$ gluing and the relative thirty-cycle carrier

## Executive verdict

This pass closes the previously open two-primary selection problem.  The
six-axis isogeny has five possible $A_5$-stable maximal-isotropic kernels at
two.  They are naturally

\[
\mathbf P^1(\mathbf F_4)
   =\mathbf P^1(\mathbf F_2)\sqcup
     \{\omega,\omega^2\}.
\]

The three rational points preserve the full simplex Weyl group $S_6$.  Each
of the two non-rational points has stabilizer exactly the exceptional
$A_5< S_6$; the order-$120$ normalizer exchanges them.  A generic member of
Hartlieb's irreducible-$A_5$ cubic component has automorphism group $A_5$, and
strong Torelli for cubic threefolds excludes an $S_6$ action on its polarized
intermediate Jacobian.  Its kernel is therefore forced to be one of the two
exotic gluings.

Consequently the quadratic cover selecting the gluing is not a speculative
sign cover: it is the sign quotient of the generic mod-two monodromy.  For the
Tate model used in the cubic--Winger comparison its square class is $T$.
Together with the independent multiplicity-motive twist
$D(T)=(T+27)(T-729/5)$, this makes the previously computed rank-zero
genus-one composite cover an actual arithmetic obstruction.

There is also a rational-Chow upgrade.  Over the cover splitting $T$ and
$D(T)$, the five $A_4$ elliptic quotients of the Winger curve and the six
$D_5$ elliptic quotients of the Fano surface compose with the Fano incidence
correspondence to give thirty relative codimension-two cycles.  Their
$A_5/C_2$ orbit spans the optimal twenty-dimensional carrier
$W_5\otimes V_4^*$.  This closes existence of the **relative rational**
carrier, but not its integral saturation or boundary extension.

A second theorem supplies the missing prime-by-prime explanation.  The five
Winger $A_4$ quotient axes have Gram matrix $3(5I-J)$, while the six cubic
$D_5$ axes have Gram matrix $6I-J$.  Their discriminants meet exactly in the
same simple $(\mathbf Z/3)^4$ heart.  The Winger-only residue is $5$-primary;
the cubic-only residue is the $2$-primary $\mathbf F_4$ symmetry selector.

The conceptual punchline is sharp:

> The three-primary kernel carries the common modular shadow, but the entire
> reduction of symmetry from the classical Weyl group $S_6$ to the cubic's
> exceptional $A_5$ is stored in one two-primary $\mathbf F_4$ orientation.

Equivalently, the common polarized source carries a **five-member gluing
packet** over $X_0(3)$.  Its three classical members form the cubic resolvent
and its two exceptional members form the quadratic discriminant resolvent.
This packages symmetry enhancement, symmetry breaking, and the two covers in
one geometric object rather than as three separate calculations.

This is genuinely new and beautiful mathematics in the present dossier.  A
bounded search located the classical field-reduction subgroup and the
classical $A_5$ Weyl-family component, but no source combining them into this
polarized-gluing selection theorem or applying it to the $A_5$ cubic
intermediate Jacobians.  That absence remains a **strong lead**, not a final
priority claim: MathSciNet, Google Scholar, and full forward-citation closure
remain open.

## 1. The local kernel

Let $v_1,\ldots,v_6$ be the six oriented elliptic axes in the five-dimensional
irreducible rational $A_5$ representation, normalized by

\[
 (v_i,v_i)=5,\qquad (v_i,v_j)=-1\ (i\ne j),\qquad
 \sum_i v_i=0.
\]

For five axes the pulled-back principal polarization has Gram matrix

\[
 G_5=6I_5-J_5,
 \qquad \operatorname{SNF}(G_5)=(1,6,6,6,6).
\]

Thus the natural isogeny $E^5\to J(X)$ has degree $6^4$.  At each
$p\mid6$, the kernel of the pulled-back polarization is

\[
 H_p\otimes_{\mathbf F_p}E[p]\cong H_p\oplus H_p,
\]

where

\[
 H_p=\operatorname{Aug}(\mathbf F_p^6)/\langle\mathbf 1\rangle
\]

is the four-dimensional six-point heart.  The kernel of the isogeny itself
is an $A_5$-stable maximal isotropic of dimension four.

At $p=3$, $H_3$ is simple and
$\operatorname{End}_{A_5}(H_3)=\mathbf F_3$.  Its stable halves are the four
graphs in $\mathbf P^1(\mathbf F_3)$.  The $\Gamma_0(3)$ monodromy fixes one
and only one of them.  This is the already established unique level-three
gluing and is the part identified with the Winger defect.

At $p=2$, $H=H_2$ is simple but

\[
 D=\operatorname{End}_{A_5}(H)=\mathbf F_4.
\]

Semisimplicity of $H\oplus H$ therefore identifies its simple
four-dimensional submodules with

\[
 \mathbf P^1(D)=\mathbf P^1(\mathbf F_4).
\]

This is a classification, not merely a count: after choosing the two
multiplicity coordinates, the five submodules are the vertical graph and the
graphs of the four elements of $D$.

## 2. Why all five candidates are polarized gluings

The relevant alternating coefficient form can be seen directly from

\[
G_5^{-1}=(I_5+J_5)/6.
\]

On the two-primary discriminant it induces the standard nondegenerate
alternating form on the six-point heart.  Equivalently, write

\[
H\cong \mathbf F_4^2,
\qquad
b(x,y)=\operatorname{Tr}_{\mathbf F_4/\mathbf F_2}\det(x,y).
\]

Every scalar $a\in\mathbf F_4$ is self-adjoint:

\[
b(ax,y)=\operatorname{Tr}(a\det(x,y))=b(x,ay).
\]

On $H\oplus H$ use the hyperbolic form

\[
\Omega((x,y),(x',y'))=b(x,y')+b(y,x').
\]

The graph of $a$ is isotropic precisely when $a$ is self-adjoint.  Hence all
five points of $\mathbf P^1(\mathbf F_4)$ are maximal isotropics.  There is no
hidden polarization condition that discards the exotic pair.

In the exact matrix model, restriction from $S_6$ to the exceptional $A_5$
produces three nonzero $A_5$-invariant alternating forms on $H$, all
nondegenerate; the $S_6$-invariant one is unique.  Every element of the
$\mathbf F_4$ commutant is self-adjoint for it.

## 3. The twin-simplex polarization theorem

The cubic's six-axis matrix has a previously unnoticed exact counterpart on
the Winger side.

For each of the five $A_4$ subgroups $K$, let

\[
\pi_K:C\longrightarrow C/K,
\qquad E_K=\operatorname{Jac}(C/K).
\]

The quotient has genus one.  Pullback gives an elliptic embedding
$\iota_K:E_K\to J(C)$, and norm--pullback gives

\[
\iota_K^*\Theta_C\,\iota_K=[12]
\]

because $|A_4|=12$.  The $A_5$ action on its five $A_4$ subgroups is
two-transitive, so after the canonical simplex orientations every cross map
$E_{K'}\to E_K$ is the same integer $m$.  The five fixed axes realize the
deleted permutation representation $V_4$, hence their sum is zero.  Composing
that relation with one quotient gives

\[
12+4m=0,
\qquad m=-3.
\]

Thus four Winger quotient axes have Gram matrix

\[
G_W=\begin{pmatrix}
12&-3&-3&-3\\
-3&12&-3&-3\\
-3&-3&12&-3\\
-3&-3&-3&12
\end{pmatrix}
=3(5I_4-J_4),
\]

with

\[
\operatorname{SNF}(G_W)=(3,15,15,15).
\]

Compare this with the cubic matrix

\[
G_X=6I_5-J_5,
\qquad \operatorname{SNF}(G_X)=(1,6,6,6,6).
\]

Their discriminants have exactly one common primary layer:

\[
(\operatorname{disc}G_W)_3\cong(\mathbf Z/3)^4
\cong(\operatorname{disc}G_X)_3.
\]

Under $A_5$, both are the same simple four-dimensional heart, with a
one-dimensional intertwiner space.  The $\Gamma_0(3)$ multiplicity monodromy
has a unique fixed line.  Therefore the two integral three-primary gluings
are forced to match, up to the only unit ambiguity, once the elliptic
multiplicity motives are identified.  Looijenga--Zi's theorem that
$u_{\rm edge}/3$ is primitive is the geometric realization of the leading
factor $3$ in $G_W$, not an unrelated divisibility accident.

This closes the generic characteristic-zero **three-primary kernel
identification**.  It does not yet prove finite-flat extension in residue
characteristic three or saturation of every irreducible summand of the
twenty-dimensional Chow carrier.

The prime asymmetry is now completely transparent:

```text
Winger five-axis shadow:  3-primary common bridge + 5-primary residue
cubic six-axis shadow:    3-primary common bridge + 2-primary A5 selector
```

This too has a general form.  An honest $n$-axis simplex of scale $s$ has
minor Smith type

\[
(s,sn,\ldots,sn).
\]

Hence, if $p\mid s$, $p\nmid n$, and $p\mid(n+1)$, its $p$-discriminant and
that of an unscaled $(n+1)$-axis simplex both have rank $n-1$.  A local bridge
exists precisely when the acting group's two modular hearts are isomorphic;
when they are simple, one nonzero intertwiner forces uniqueness.  The Winger
and cubic pair is the case $(n,s,p)=(5,3,3)$.  Thus the shared prime is not a
numerical accident but the first instance of a consecutive-simplex local
bridge criterion.

The Winger-only $5$-primary residue has its own exact meaning.  It is the
simple three-dimensional five-point heart over $\mathbf F_5$, with scalar
endomorphism ring.  The mod-$5$ Brauer table of $A_5$ has simple degrees
$1,3,5$, and both conjugate golden ordinary characters $3,3'$ reduce to the
same three-dimensional Brauer character.  Thus prime five is exactly where
the two golden orientations fuse.  This makes the otherwise surprising

\[
E_6=3\oplus3'
\]

summand in $W_5\otimes V_4=E_6\oplus V_4\oplus2W_5$ structurally natural: it
is the rational carrier containing both lifts of the Winger five-primary
heart.  This does **not** yet construct an $E_6$-motive correspondence; it is
an exact modular explanation for why that summand, and not an arbitrary
six-dimensional representation, appears.

## 4. The field-reduction symmetry theorem

### Theorem

Let $H$ be the four-dimensional symplectic space over $\mathbf F_2$ obtained
by field restriction from $\mathbf F_4^2$.  Under

\[
\operatorname{Sp}(H)\cong\operatorname{Sp}_4(2)\cong S_6,
\]

the stabilizers of the five isotropic graphs in
$\mathbf P^1(\mathbf F_4)$ are

\[
\begin{array}{c|c}
\text{slope}&\text{stabilizer}\cr\hline
0,1,\infty&S_6,\cr
\omega,\omega^2&\operatorname{SL}_2(4)\cong A_5.
\end{array}
\]

Moreover

\[
N_{S_6}(A_5)\cong\Sigma\operatorname{L}_2(4)\cong S_5
\]

has order $120$, and its outer coset exchanges the two exotic graphs.

### Human proof

The three $\mathbf F_2$ slopes are graphs of scalar maps defined over the
ground field, so every element of $\operatorname{Sp}_4(2)$ preserves them.
For an exotic slope, preserving its graph is the same as commuting with the
corresponding scalar $\omega$.  Such a map is $\mathbf F_4$-linear.  If its
$\mathbf F_4$ determinant is $d$, preservation of
$\operatorname{Tr}\det$ says

\[
\operatorname{Tr}(dz)=\operatorname{Tr}(z)
\quad\text{for every }z\in\mathbf F_4,
\]

so nondegeneracy of the trace pairing gives $d=1$.  The stabilizer is
$\operatorname{SL}_2(4)$, of order $60$, hence $A_5$.  Allowing the Frobenius
automorphism of $\mathbf F_4/\mathbf F_2$ doubles the group and exchanges
$\omega$ with $\omega^2$.

This is the rank-two instance of the classical extension-field subgroup

\[
\operatorname{SL}_2(p^m)<\operatorname{Sp}_{2m}(p).
\]

The general field-reduction proof is identical with
$b=\operatorname{Tr}_{\mathbf F_{p^m}/\mathbf F_p}\det$.  What is special
here is the exceptional identifications
$\operatorname{Sp}_4(2)=S_6$ and $\operatorname{SL}_2(4)=A_5$, and their
role as the **integral polarization selector** for a cubic intermediate
Jacobian.

### General local-to-global gluing law

The same argument gives an infinite-family descent theorem.  Let $H$ be an
absolutely simple $\mathbf F_pG$ module with

\[
D=\operatorname{End}_G(H)=\mathbf F_{p^m},
\]

and suppose its polarization form makes every element of $D$ self-adjoint.
Then the $G$-stable simple maximal isotropics in the hyperbolic module
$H\oplus H$ are exactly $\mathbf P^1(D)$.  If the rank-two multiplicity
local system has monodromy $M\leq\operatorname{PGL}_2(\mathbf F_p)$, then:

1. a gluing descends over the original base exactly when its point of
   $\mathbf P^1(D)$ is fixed by $M$;
2. the minimal marking cover has degree equal to its $M$-orbit size; and
3. failure of a fixed point is a genuine integral-descent obstruction even
   when the rational variation is a trivial tensor product.

For $m=2$ and full $\operatorname{PGL}_2(\mathbf F_p)$ monodromy, the
projective line splits into two orbits:

\[
\mathbf P^1(\mathbf F_p)
\quad\text{of size }p+1,
\qquad
\mathbf P^1(\mathbf F_{p^2})\setminus\mathbf P^1(\mathbf F_p)
\quad\text{of size }p(p-1).
\]

The second stabilizer is a nonsplit torus of order $p+1$.  At $p=2$ this is
exactly the $3+2$ resolvent split above.  This theorem turns an endomorphism
field into a computable lower bound on the base change needed to globalize a
polarized isogeny.  It also gives an algorithm: compute the modular
commutant, enumerate its projective line, and take monodromy orbits.

## 4. The five-packet and its resolvent descent

Apply the preceding theorem over the smooth part of the cubic modular base
$X_0(3)$.  Keep the unique three-primary gluing fixed and split the
two-torsion of the elliptic multiplicity factor.  The five marked principal
quotients of the common polarized source are indexed by

\[
\mathbf P^1(\mathbf F_4).
\]

The generic two-torsion monodromy is
$\operatorname{GL}_2(2)=S_3$.  Field restriction makes its action on the
five kernels split as

\[
\mathbf P^1(\mathbf F_2)\ \sqcup\
\bigl(\mathbf P^1(\mathbf F_4)\setminus\mathbf P^1(\mathbf F_2)\bigr),
\qquad 3+2.
\]

This gives a disconnected finite cover of degrees three and two:

1. the degree-three component marks a rational slope, equivalently a
   nonzero point of the elliptic two-torsion; together with the cyclic
   three-subgroup it is $X_0(6)$, and every quotient on it has full $S_6$
   symmetry;
2. the degree-two component marks one exotic $\mathbf F_4$ orientation and
   its stabilizer inside the simplex $S_6$ is precisely the exceptional
   $A_5$.

Their fibre product is the $S_3$ splitting cover.  Thus the two geometric
symmetry types are the two resolvents of one five-packet, not unrelated
families that happen to share an elliptic factor.  The statement remains
valid over any characteristic-zero base after deleting the loci where the
two-division polynomial or the common polarized source degenerates.

There is an especially promising threefold realization of the classical
side.  Cheltsov--Kuznetsov--Shramov construct the one-parameter family of
$S_6$-invariant quartic threefolds, prove that the intermediate Jacobian of
an equivariant resolution is a principally polarized fivefold with faithful
$S_6$, and record

\[
H^3(\widetilde X_\tau,\mathbf Q)
 \cong Q(S_6)\oplus\lambda Q(S_6),
\qquad J(\widetilde X_\tau)\sim E(\lambda)^5.
\]

These are exactly the rational representation and symmetry predicted for the
three classical members.  If their integral symplectic lattice is the
$A_5$-root $\rho$-decomposable lattice, the Carocca--González-Aguilera--
Rodríguez classification identifies their period curve with $X_0(6)$ and
realizes the degree-three side of the packet by intermediate Jacobians of
quartic threefolds.  This last integral identification is **not yet proved**:
the cited quartic paper states the rational root-lattice decomposition and
the $E^5$ isogeny, not the required integral Lagrangian splitting.  Closing
it would give a striking shadow-sister theorem:

> the $S_6$ quartic and the $A_5$ cubic intermediate Jacobians are the
> classical and exotic two-primary neighbors of one universal polarized
> elliptic-power source.

This is now the highest-value geometric gate.  It is stronger and more
specific than merely observing that both fivefolds are isogenous to fifth
powers of elliptic curves.

## 5. The cubic selects the exotic pair

Suppose the two-primary kernel were one of
$\mathbf P^1(\mathbf F_2)$.  The three-primary kernel is also a scalar graph,
now over $\mathbf F_3$.  Hence the full $6$-primary kernel would be stable
under the simplex action of $S_6$.  The quotient principal polarization would
inherit a faithful $S_6$ action: faithfulness is visible already on the
five-dimensional tangent representation.

Hartlieb's irreducible-character component is the one-dimensional special
family of cubics with generic projective automorphism group $A_5$.
Casalaina-Martin--Grushevsky--Hulek--Laza record the strong Torelli input in
exactly the needed form: cubic threefolds and their polarized intermediate
Jacobians have coincident automorphism groups (with the usual central
inversion convention on the abelian side).  A generic member can therefore
not acquire the faithful $S_6$ action forced by a rational slope.

It follows that the two-primary kernel is one of

\[
\{\omega,\omega^2\}.
\]

This also separates the cubic component from the classical Weyl-family
component.  González-Aguilera--Rodríguez and Carocca--González-Aguilera--
Rodríguez construct the $A_5$ root-system family with full Weyl symmetry
$S_6$ and modular parameter $X_0(6)$.  Its order-two datum is one of the
three rational slopes.  The cubic component has only $A_5$ symmetry and is
the exceptional field-reduction branch.  The two components agree at three
and diverge only at two.

## 6. The sign cover and the arithmetic obstruction

The generic elliptic mod-two monodromy is
$\operatorname{GL}_2(2)\cong S_3$.  Its action on
$\mathbf P^1(\mathbf F_4)$ has orbits

\[
3+2:
\quad \mathbf P^1(\mathbf F_2)
\quad\text{and}\quad
\{\omega,\omega^2\}.
\]

The action on the exotic pair is the sign quotient.  Thus the minimal cover
which **marks one of the two cubic gluings** is the discriminant cover of the
two-division polynomial.  For the exact Tate model in the bridge dossier,

\[
\operatorname{disc}(f_2)=16T(T+27)^8,
\]

so the cover is

\[
r^2=T.
\]

There is a sharper resolvent interpretation.  Put $x=(T+27)y$ in the
two-division polynomial.  Its root equation becomes

\[
4y^3+(T+27)(y+1)^2=0,
\]

so the degree-three root cover is rational with

\[
T=-\frac{4y^3}{(y+1)^2}-27
 =-\frac{(4y+3)(y+3)^2}{(y+1)^2}.
\]

This is the $X_0(6)$ cover which chooses one of the three classical
$\mathbf F_2$ slopes.  The degree-two discriminant cover chooses one of the
two exceptional slopes.  They are therefore the cubic and quadratic
resolvents of the **same** generic $S_3$ two-division extension.  Their fibre
product is the full splitting cover and is again rational: with
$4y+3=-u^2$,

\[
y=-\frac{u^2+3}{4},\qquad
T=\frac{u^2(9-u^2)^2}{(1-u^2)^2},\qquad
r=\frac{u(9-u^2)}{1-u^2}.
\]

Thus the classical $S_6$ Weyl family and the exceptional $A_5$ cubic family
are not merely two nearby modular curves.  Their missing two-primary markings
are complementary resolvent shadows of one universal two-torsion cover.

The multiplicity-motive comparison with Winger independently requires

\[
\eta^2=D(T)=(T+27)(T-729/5).
\]

The normalization of their fibre product is the genus-one curve

\[
v^2=(u^2+27)(u^2-729/5),
\]

whose Jacobian has minimal model

\[
y^2+xy=x^3-x^2+333x-7259.
\]

It has conductor $450$, Mordell--Weil rank zero and torsion $\mathbf Z/2$;
the quartic has no affine rational point.  Therefore no rational smooth
parameter simultaneously marks the exotic cubic gluing and untwists the
Winger multiplicity motive.  The earlier arithmetic calculation is now tied
to the actual kernel rather than to an unselected candidate orbit.

## 7. Relative rational Chow cycles

Work over the smooth open of the common modular base after adjoining
$\sqrt T$ and $\sqrt D$.  For an $A_4$ subgroup $K$ and a $D_5$ subgroup
$H$, use:

- the quotient $\pi_K:C\to C/K$ and its Jacobian correspondence;
- Roulleau's elliptic fibration $f_H:S\to E_H$ on the Fano surface;
- the elliptic isomorphism/isogeny
  $\psi_{HK}:\operatorname{Jac}(C/K)\to E_H$ supplied by the split common
  multiplicity motive; and
- the universal Fano incidence correspondence $S\dashrightarrow X$.

Their composition is a relative cycle

\[
Z_{HK}\in \operatorname{CH}^2(C\times X)_{\mathbf Q}.
\]

There are $5\cdot6=30$ pairs.  The diagonal $A_5$ action is transitive and
the pair stabilizer is $A_4\cap D_5=C_2$, so these are one $A_5/C_2$ orbit.
Deleting row and column constants imposes
$6+5-1=10$ relations and leaves dimension $20$.  On realizations the cycles
are the rank-one maps spanning

\[
W_5\otimes V_4^*.
\]

Since the relevant maps are homomorphisms of elliptic/abelian motives and
homomorphisms of abelian varieties inject into their rational $H^1$
realizations in characteristic zero, this is an actual relative rational
Chow carrier, not merely a list of cohomology classes.  It is optimal because
any full coefficient carrier must surject onto
$\operatorname{Hom}(V_4,W_5)$, of dimension twenty.

What remains open is integral: prove the primitive saturation of these cycles,
identify their exact finite flat kernels at $2$ and $3$, and extend them over
the singular fibres with controlled limiting polarization.

## 8. Priority boundary

This report uses nine named sources.  Three were read at full text in the
earlier C904 audit, four partially, and two at abstract/metadata depth.

1. Xavier Roulleau, *Genus 2 curve configurations on Fano surfaces*,
   arXiv:1002.4467.  **Read depth: full text**, arXiv v1; the $A_5$ pencil,
   $D_5$ elliptic fibrations, and $\operatorname{Alb}(S)\sim E^5$ are used.
   Cache key `arXiv:1002.4467`, SHA-256
   `c66706bfa8977656043a8c068d9f2cabc7e72dc0f53eac3fab680ac82172c7bd`.
2. Bert van Geemen and Takuya Yamauchi, *On intermediate Jacobians of cubic
   threefolds admitting an automorphism of order five*, arXiv:1506.05346v3.
   **Read depth: full text** in the earlier C904 audit; the algebraic
   Fano/Prym construction and explicit elliptic factor are used.  Cache key
   `arXiv:1506.05346`, SHA-256
   `f263d78728391fc9c1ff836293a484e5caec66b3178ecab3aa1d54b14855baed`.
3. Eduard Looijenga and Yunpeng Zi, *Monodromy and period map of the Winger
   pencil*, arXiv:2109.01810.  **Read depth: full text** in the earlier C904
   audit; the $X_1(3)$ period map, integral defect, and thirty edge cycles are
   used.  Cache key `arXiv:2109.01810`, SHA-256
   `d49c591df00b53d11cf9f763007fa800935503d732ee745e5509bbd909adf5f1`.
4. Moritz Hartlieb, *Special subvarieties in the locus of intermediate
   Jacobians of cubic threefolds*, arXiv:2304.03214.  **Read depth: partial**,
   arXiv preprint, Sections 5.3--5.8 and especially Lemma 5.5, Proposition
   5.7 and Remark 5.8.  It owns the irreducible-$A_5$ cubic component, its
   special-curve property, and $J\sim E^5$.  Cache key
   `arXiv:2304.03214`, SHA-256
   `3e6e55c0277b44fadbcbea8cd9f1d4501d307caaab6d6fd5314af36c0b49ab01`.
5. Angel Carocca, Víctor González-Aguilera and Rubí E. Rodríguez, *Weyl
   Groups and Abelian Varieties*, arXiv:math/0503340.  **Read depth: partial**,
   arXiv v1, Section 2 through Corollary 2.8, Remark 3.9, Section 4 through
   Proposition 4.4, and Section 5 through Theorem 5.4.  It owns the general
   $\rho$-decomposable construction and the root-$A_5$ modular curve
   $X_0(6)$.  Cache key `arXiv:math/0503340`, SHA-256
   `c8e4287a8173c8b5f9ed80187f3463dedcd8a23edeb9d74964357b7eb117cf11`.
6. Víctor González-Aguilera and Rubí E. Rodríguez, *Families of irreducible
   principally polarized abelian varieties isomorphic to a product of
   elliptic curves*, DOI `10.1090/S0002-9939-99-05415-5`.
   **Read depth: abstract/metadata only**, AMS/search metadata; the full text
   was not reachable in this pass.  The abstract assigns the general
   dimension-$n$ family to $X_0(n+1)$.  No theorem beyond what is verified in
   the later Carocca--González-Aguilera--Rodríguez preprint is attributed to
   it here.
7. Nick Gill, *Polar spaces and embeddings of classical groups*,
   arXiv:math/0603364.  **Read depth: abstract/metadata only**, arXiv search
   metadata.  It confirms that trace-form field-reduction embeddings are the
   classical extension-field subgroups of Aschbacher class $\mathcal C_3$.
   The exact rank-four stabilizer calculation above is proved here and is not
   attributed to an unread theorem of that paper.
8. Sebastian Casalaina-Martin, Samuel Grushevsky, Klaus Hulek and Radu Laza,
   *Complete moduli of cubic threefolds and their intermediate Jacobians*,
   arXiv:1510.08891.  **Read depth: partial**, arXiv preprint, introduction
   around (0.1) only.  It states that the local/global Torelli theorems hold
   and that the cubic and polarized-intermediate-Jacobian automorphism groups
   coincide, with primary references.  Cache key `arXiv:1510.08891`, SHA-256
   `d5b3c69094eee70d5486542952f394308e3aa4bdbc5762a85588ebae4b2d7753`.
9. Ivan Cheltsov, Alexander Kuznetsov and Constantin Shramov, *Coble
   fourfold, $S_6$-invariant quartic threefolds, and Wiman--Edge sextics*,
   arXiv:1712.08906.  **Read depth: partial**, introduction around Theorem
   1.15 and Section 4.2 through Remark 4.5.  It owns the quartic family, its
   faithful $S_6$ action, its Prym intermediate Jacobian, and the rational
   root-lattice decomposition implying $J\sim E^5$.  It does not state the
   integral $\rho$-decomposition needed for the packet identification.
   Cache key `arXiv:1712.08906`, SHA-256
   `14c94b0b671cf5e172893086fed33f6600a593d74a5a83efda5384978022c598`.

The bounded searches were:

```text
site:arxiv.org symplectic "extension field subgroup" SL(2,q) field reduction
site:arxiv.org "maximal isotropic" "P^1" endomorphism field gluing abelian varieties
site:arxiv.org abelian varieties gluing "extension field" symplectic
"A5" "principally polarized abelian" fivefold modular curve
"A5" "intermediate Jacobian" cubic threefold pencil modular curve
"Gamma_0(6)" "abelian fivefold" A5
```

They located the classical ingredients but no polarized-gluing selection
theorem, cubic application, or link between the Weyl modular curve and the
$S_6$-quartic intermediate Jacobians.  Google Scholar automation was blocked,
MathSciNet was not accessible, zbMATH and forward citations were not closed,
and the 2000 González-Aguilera--Rodríguez full text was not obtained.  Hence
no unconditional firstness sentence is licensed.

## 9. Reproducibility

Working directory:

```text
/home/tavis/src/othello
```

Primary exact certificate:

```text
python3 notes/2026-08-10-c904-kernel-v4.py --check
```

It independently constructs $A_5$, its six Sylow-five axes, both modular
hearts, their Hom and endomorphism algebras, all invariant alternating forms,
all five isotropic graphs, their stabilizers in all $720$ elements of $S_6$,
and the order-$120$ normalizer action.

Independent Sage replay:

```text
nix shell nixpkgs#sage -c sage \
  notes/2026-08-10-c904-kernel-v4-replay.py --check
```

It rebuilds the modular matrices from fixed permutations, independently
solves the intertwining and form equations, re-enumerates all $S_6$
stabilizers, and rechecks the two quadratic covers and rank-zero composite
base.

Independent GAP character replay:

```text
diff -u notes/2026-08-10-c904-cubic-winger-correspondence-replay.out \
  <(nix shell nixpkgs#gap -c gap -q \
    notes/2026-08-10-c904-cubic-winger-correspondence-replay.g \
    2>/dev/null | sed '/^#I/d')
```

It checks the carrier decomposition and the mod-$5$ decomposition matrix:
both golden ordinary $3$-dimensional characters reduce to the unique
$3$-dimensional Brauer simple.

Artifact hashes and byte counts:

```text
7b918efe56e42e3eda3e393c60a708375f5293d1487c346ccf4831dfe3297f1d  14835  2026-08-10-c904-kernel-v4.py
af7d89c5b0927ba5f49c0ae4ed91106947da8f3d6e840e8ad8d684a9d226590a   1539  2026-08-10-c904-kernel-v4.out
fac0378251c689f648a731958232876ffff667870d8c1677561b4e15843a8bf0   9260  2026-08-10-c904-kernel-v4-replay.py
54be3bfa2ab54e1947dfc1bce5655464c099519e43613710680ca0f6e5e630be    646  2026-08-10-c904-kernel-v4-replay.out
01d713c316461c27ec6340227fbb25c5e8f44d010f3eb7d8946c9c6e616b3d1d   2853  2026-08-10-c904-cubic-winger-correspondence-replay.g
58bbdbef64dbfc9c1a9e46dfaaa8244e467dae0e96e15a8bcb69e078cb5fb404    299  2026-08-10-c904-cubic-winger-correspondence-replay.out
```

The computation verifies the chosen integral conventions.  The field-trace
and strong-Torelli arguments above are the human proof; the certificate does
not establish the relative Chow construction or literature absence.

## 10. Remaining gates and venue effect

Closed in this pass:

1. the actual two-primary kernel orbit;
2. the geometric meaning and minimality of the $r^2=T$ cover;
3. the $S_6$ Weyl branch versus exceptional $A_5$ branch;
4. existence and optimality of the relative rational thirty-cycle carrier;
5. the twin-simplex Gram matrices and generic three-primary kernel match;
6. the relevance of the rank-zero composite cover.

Still open:

1. integral saturation of the thirty cycles and equality with the
   Looijenga--Zi edge-incidence map;
2. finite-flat kernel control in residue characteristics two and three;
3. extension over every boundary fibre and limiting polarization;
4. geometric realization of Fricke/Hecke on the carrier; and
5. integral identification of the $S_6$-quartic intermediate-Jacobian
   lattice with the rational-slope $X_0(6)$ branch; and
6. publication-grade citation closure.

The result clears the “genuinely new and beautiful theorem” alternative of
the one-hour goal.  It does not by itself make an Annals/IHÉS outcome more
likely than not.  It moves the current package into a credible
JEMS/GAFA-level shape; closing integral saturation and the boundary theorem
would make that tier better than even and would create a serious
Inventiones/JAMS long shot.

## 11. Mystery ledger

- **Settled:** why the mod-two heart has $\mathbf F_4$ endomorphisms.  It is
  the field-restriction structure whose symplectic centralizer is
  $\operatorname{SL}_2(4)=A_5$.
- **Settled:** which of the five kernels the cubic uses.  Strong Torelli and
  generic $A_5$ symmetry exclude the three $S_6$-stable kernels.
- **Settled:** why the exotic kernels come in a quadratic pair.  Frobenius is
  the outer coset of the semilinear normalizer.
- **Settled:** why $T$ is the second character.  It is the square class of
  the two-division discriminant acting on that pair.
- **Settled and generalized:** why the Winger and cubic integral lattices
  meet only at three.  Their twin simplex matrices are respectively
  $3(5I-J)$ and $6I-J$; the consecutive-simplex Smith criterion isolates the
  common rank-four heart.
- **Settled as modular representation theory:** the Winger-only prime-five
  heart is the unique three-dimensional Brauer simple, and both golden
  $3,3'$ reduce to it.  This explains the $E_6=3+3'$ carrier summand but does
  not construct an $E_6$ geometric correspondence.
- **Settled:** why the old Weyl-family construction did not reveal the cubic
  component.  It is exactly the rational-slope, full-$S_6$ branch.
- **Settled:** why the Weyl and cubic marking covers have degrees three and
  two.  They are the two resolvents of one $S_3$ two-division cover; their
  full splitting cover is rational with the explicit $u$-parameter above.
- **Settled at the ppav-gluing level:** the five kernels form one packet over
  $X_0(3)$, split by monodromy into a classical $S_6$ triple and an exotic
  $A_5$ pair.
- **Open, potentially decisive:** whether the classical triple is the
  integral intermediate-Jacobian family of the $S_6$-invariant quartics.
  Rational representation type and $E^5$ isogeny agree; the integral
  symplectic lattice has not yet been identified.
- **Open, central:** what geometric degeneration makes the thirty rational
  cycles primitive at three.  Owner: the edge-incidence saturation attack.
- **Open, high value:** whether the field-reduction gluing theorem has other
  geometric realizations for $\operatorname{SL}_2(p^m)$ families.  This is an
  infinite-family application frontier, not needed for Paper V's proof.
