# C904 Annals gate II: the quartic--cubic two-primary Hecke correspondence

Date: 2026-08-10
Status: quarantined Paper V research; no manuscript or Lean edits
Scope: exact integral ppav theorem, relative-motive reduction, boundary and priority gates

**Later checkpoint.**  The odd-minimal-class gate left open below is closed
in `2026-08-10-c904-six-axis-minimal-class-saturation.md`: fourfold divisor
products are saturated for all twenty principal gluings of $(E^5,6I-J)$, and
coprime Smith projection indices $7,17$ prove $\Theta^4/4!$ algebraic on the
exotic cubic quotient.  The historical analysis below is preserved because
it records how the obstruction was localized.

## Executive verdict

The Petersen/cubic equality `6I-J` is not only a boundary coincidence.  After
pulling the resolved $S_6$ quartic family back along the corrected map

\[
 T(t)=-4\frac{(4t-1)^2(10t-7)}{(2t-1)^2(6t-1)}
\]

and making the two quadratic base changes that (i) choose one of the cubic's
two exotic $A_5$ gluings and (ii) split its elliptic twist, the quartic and
cubic intermediate Jacobians become two principal quotients of the same
six-axis elliptic-power source.  Their two-primary maximal-isotropic kernels
are transverse.

This proves an exact new abelian-scheme theorem on the common smooth base:

> **Quartic--cubic Hecke-neighbor theorem.**  There is, up to sign, a unique
> primitive $A_5$-equivariant isogeny
> \[
>       \Phi:\mathcal J_Q\longrightarrow\mathcal J_X
> \]
> between the pulled-back quartic and cubic intermediate-Jacobian families.
> It satisfies
> \[
>   \Phi^\dagger\Phi=[4],\qquad
>   \deg\Phi=2^{10},\qquad
>   \ker\Phi(\mathbf C)\cong
>       (\mathbf Z/2)^2\oplus(\mathbf Z/4)^4.
> \]
> On homology its Smith type is
> \[
>      (1,1,1,1,2,2,4,4,4,4).
> \]
> If $F$ is the geometrically defined sum of the six matched elliptic-axis
> correspondences, then
> \[
>       F=6\,\mathrm{id}=3\Phi.
> \]

The theorem is bidirectional: the Rosati adjoint $\Phi^\dagger$ has the same
Smith type and both compositions are multiplication by four.

The result closes the integral-Hodge/abelian-scheme part of the Annals gate.
Beauville's integral conic-cylinder construction also explains the feared
denominator on the quartic side.  If $\alpha$ denotes the scalar-one
quasi-isogeny from the quartic Prym to the cubic Jacobian, then $\Phi=2\alpha$
is integral and

\[
       h=\alpha(1-\sigma):J(\widetilde\Delta_Q)\longrightarrow J(X)
\]

is an honest homomorphism: $1-\sigma$ is zero on the invariant part and is two
on the Prym part.  This is the correct candidate for an integral cycle and
avoids dividing the six-axis cycle by three.

There remains one precise generic Chow gate.  A homomorphism
$J(D)\to\operatorname{Alb}(F_X)$ and its Poincare divisor do **not**
automatically give the codimension-two family of zero-cycles on $F_X$ needed
to compose with the cubic line incidence.  That representability must be
proved for this special $A_5$ family.  After it, the remaining crown is
global rigidification/descent, finite-flat extension over the four cusps,
deck behavior, and full priority closure.

The last red-team pass localizes this obstruction further.  Voisin's
criterion makes a universal cubic cycle equivalent here to algebraicity of
the single integral class $\Theta^4/4!$.  The Hecke isogeny, the six elliptic
axes, and the classical Prym construction produce respectively $4$, $6$, and
$2$ times this class, but none changes its parity.  Thus the generic Chow
gate is one genuine two-primary bit, not an unexamined denominator.

## 1. The exact common base

The cubic has two independent quadratic characters:

- the exotic-gluing character, of square class $T$;
- the elliptic multiplicity twist
  $D(T)=(T+27)(T-729/5)$.

After substitution of $T(t)$, their square classes over $\mathbf Q(t)$ are

\[
 R(t)=-(6t-1)(10t-7),
\]

and

\[
 S(t)=-5(2t+1)(26t-11)(796t^2-596t+79).
\]

Indeed, the exact square quotients are

\[
 \frac{T(t)}{R(t)}=
 \left(\frac{2(4t-1)}{(2t-1)(6t-1)}\right)^2,
\]

and

\[
 \frac{D(T(t))}{S(t)}=
 \left(\frac{2t+1}{5(2t-1)^2(6t-1)}\right)^2.
\]

The branch sets of $R$ and $S$ are disjoint.  The three quadratic subcovers
defined by $R,S,RS$ have genera $0,1,2$, so the full biquadratic marking cover

\[
 \mathcal B:\quad u^2=R(t),\qquad v^2=S(t)
\]

has genus $3$.

There is a useful explicit hyperelliptic model.  Parametrizing the $R$-conic
through $(t,u)=(1/4,3/2)$ gives

\[
 t=\frac{x^2-12x+148}{4(x^2+60)}.
\]

After rescaling $v$, the full cover is

\[
\begin{split}
Y^2={}&-5(3x^2-12x+268)(9x^2-228x+164)\\
 &\cdot(9x^2-36x-1244)(9x^2+156x-604).
\end{split}
\]

The degree-eight polynomial is squarefree.  Thus the finite base change needed
for the correspondence is itself a concrete genus-three curve rather than an
unspecified splitting field.

## 2. The common rational variation

Let $W_5$ be the rational five-dimensional irreducible $A_5$ module.  The
previous C904 passes establish the following ingredients.

1. The resolved $S_6$ quartic has integral symplectic lattice of root--weight
   type and period curve $X_0(6)$.  On restriction to the exceptional $A_5$,
   its rational variation is $W_5\otimes H^1(E)$.
2. The $A_5$ cubic intermediate Jacobian has the same rational coefficient
   module $W_5$.  Its elliptic multiplicity factor is the pullback of the
   universal $X_0(3)$ factor, twisted by $D(T)$.
3. The forgetful modular map is the displayed $T(t)$.  Hence the $S$-cover
   identifies the two elliptic multiplicity motives.
4. Both sides possess six $D_5$ axes.  Their oriented coefficient Gram matrix
   is
   \[
        G_5=6I_5-J_5,
        \qquad \operatorname{SNF}(G_5)=(1,6,6,6,6).
   \]
   The sum of their norm endomorphisms is $6I$.

Consequently the two rational polarized variations agree over
$\mathcal B^\circ$, the complement of the singular fibres.  The remaining
difference is entirely integral and is supported at the primes $2$ and $3$.
The three-primary gluing is the same unique $\Gamma_0(3)$ line.  At two, the
quartic uses one of the three $\mathbf P^1(\mathbf F_2)$ lines while the cubic
uses one of the two exotic points
$\mathbf P^1(\mathbf F_4)\setminus\mathbf P^1(\mathbf F_2)$.  The $R$-cover
chooses the latter.

## 3. The transverse-gluing lemma

The integral theorem is a special case of the following elementary polarized
lattice statement.

> **Lemma.**  Let $L_0$ be a symplectic lattice consisting of $h$ planes of
> scale two and $m$ unimodular planes.  Let $L_r,L_e$ be self-dual
> overlattices obtained by choosing transverse maximal isotropics on every
> scale-two discriminant plane and the same lattice on the unimodular planes.
> Then scalar multiplication by two is the primitive integral comparison
> $L_r\to L_e$.  It is a polarized similitude of multiplier four and has Smith
> type
> \[
>       (1^h,2^{2m},4^h).
> \]

For one defective symplectic plane, choose an ambient basis $e,f$ with
$\langle e,f\rangle=2$.  The two transverse self-dual lattices have bases

\[
      (e/2,f),\qquad(e,f/2).
\]

In these bases scalar two is $\operatorname{diag}(1,4)$.  On a common
unimodular plane it is $\operatorname{diag}(2,2)$.  Taking orthogonal sums
proves the lemma and also

\[
      M^{\mathsf T}J M=4J.
\]

Here $h=4$ and $m=1$.  The five possible $A_5$ halves are the graphs indexed
by $\mathbf P^1(\mathbf F_4)$.  Any two distinct graphs intersect only in zero,
so every rational quartic gluing is transverse to either exotic cubic gluing.
The lemma gives the asserted Smith invariants and degree.

Primitivity is important.  Scalar one is not integral between the two
lattices, while scalar two is; hence no smaller rational similitude gives an
integral family map.  Generic non-CM multiplicity and
$\operatorname{End}_{A_5}(W_5)=\mathbf Q$ then give uniqueness up to sign.

Finally, the six-axis tight-frame identity gives $F=6I$.  Since the primitive
comparison is $\Phi=2I$, one obtains $F=3\Phi$.  This explains simultaneously
the unexpected divisibility by three and why dividing all the way by six is
impossible.

## 4. From lattices to abelian schemes

Over $\mathcal B^\circ$, the scalar-two map is:

- integral on the two local systems by the lemma;
- a morphism of polarized weight-one variations of Hodge structure;
- monodromy-equivariant after the $R$ and $S$ markings.

It therefore defines a homomorphism of the corresponding abelian schemes.
The polarization identity on homology gives
$\Phi^\dagger\Phi=[4]$, so it is an isogeny with the stated finite kernel.
This is stronger than a fibrewise statement: the marking cover makes the map
horizontal and hence relative.

The two deck characters are essential.  Before the $R$-cover, monodromy
exchanges the two exotic integral gluings.  Before the $S$-cover, the two
elliptic factors differ by the nontrivial quadratic twist.  Thus an ordinary
untwisted relative isogeny over the $t$-line is not presently licensed.  The
adjoint composition $[4]$ does descend, but that alone is not a correspondence
between the two unmarked families.

## 5. The exact integral-cycle gate

Nagel--Saito prove, with rational coefficients, that the middle motive of a
conic bundle over a rational surface is the Prym motive of its admissible
discriminant double cover, Tate twisted.  Their correspondence is explicit:
the anti-projector is $(1-\sigma)/2$, and the inverse cylinder normalization
also contains a factor $1/2$.

On the cubic side, the Fano incidence correspondence identifies the middle
motive with $h^1$ of the Albanese of the Fano surface, again with rational
coefficients.  Roulleau's six $D_5$ fibrations supply the six elliptic axis
maps geometrically.  Thus $\Phi$ and $\Phi^\dagger$ first give rational Chow
correspondences

\[
 h^3(Q_t)\rightleftarrows h^3(X_{T(t)})
\]

whose compositions act as $[4]$ on the middle motives.  The integral lift can
now be reduced to one representability question, without dividing a Chow
cycle.

Let $D=\widetilde\Delta_Q$ and let $\sigma$ be its covering involution.
Beauville's conic-component family gives an integral cylinder correspondence

\[
      \gamma_Q:H^3(Q,\mathbf Z)\longrightarrow H^1(D,\mathbf Z)^-(-1).
\]

Its rational inverse contains the familiar factor $1/2$; this reflects that
the Jacobian polarization restricts to twice the principal Prym polarization,
not a failure of the integral cylinder in the displayed direction.

Let

\[
  \alpha:P_Q\dashrightarrow J_X
\]

be the scalar-one rational Hodge quasi-isogeny fixed by the six oriented axes.
It is not integral because the quartic and cubic two-primary gluings are
transverse.  But $\Phi=2\alpha$ is integral by Section 3.  Hence

\[
 h:=\alpha(1-\sigma):J(D)\longrightarrow J_X
\]

is integral: it vanishes on $H^1(D)^+$ and restricts to $2\alpha=\Phi$ on
$H^1(D)^-$.  For complex abelian varieties, a rational homomorphism whose
linear map preserves the integral lattices is an honest algebraic
homomorphism.

Identify $J_X$ with $\operatorname{Alb}(F_X)$ through the cubic Fano surface
and its principal polarization.  The dual of $h$ is represented by a
Poincare line bundle.  This is not yet the required threefold correspondence:
a divisor correspondence on $D\times F_X$ controls Picard/Albanese maps, but
the cubic line incidence needs a family of zero-cycles on $F_X$ (equivalently
a codimension-two correspondence) to produce a codimension-three cycle on
$Q\times X$.  Passing from the Albanese homomorphism to that family is a
universal-cycle/representability assertion and is not formal.

The exact remaining generic gate is therefore:

> Prove that the special homomorphism
> $h=\alpha(1-\sigma):J(D)\to\operatorname{Alb}(F_X)$ is represented by an
> integral relative family of zero-cycles on the $A_5$ Fano surfaces.

If $Z_h\in\operatorname{CH}^2(D\times F_X)$ represents it, then composing
$Z_h$ with the integral conic cylinder and cubic line incidence gives

\[
       Z_{QX}\in \operatorname{CH}^3(Q\times X)
\]

acting as $\Phi$; its transpose acts as $\Phi^\dagger$.  The construction is
then automatically relative after standard rigidification.

There are two plausible ways to prove representability.

1. Use Roulleau's explicit $D_5$ elliptic fibrations and genus-two curves to
   realize the six axis homomorphisms by actual curve correspondences, then
   prove that the primitive combination is saturated.
2. Prove that this special $A_5$ cubic family admits the relevant universal
   codimension-two cycle, which is much weaker than assuming such a cycle for
   a very general cubic.

Beauville settles the quartic half integrally and shows that twice the reverse
Prym map is algebraic.  Thus scalar two remains geometrically optimal and the
gate is now entirely on the cubic/Fano representability side.  The alternative
six-axis formula $F=3\Phi$ is conceptually valuable, but dividing it in Chow
is not yet justified.

### 5.1 The exact parity ceiling

Voisin proves that for a smooth cubic threefold algebraicity of the integral
minimal curve class

\[
             c_X=\frac{\Theta_X^4}{4!}
\]

is equivalent to universal triviality of $\operatorname{CH}_0$ and supplies
the universal codimension-two cycle needed above.  This turns the
representability question into an exact parity test.

The present isogeny does not settle that test.  Since
$\Phi^*\Theta_X=4\Theta_Q$ and $\deg\Phi=4^5$,

\[
       \Phi^*c_X=4^4c_Q,
       \qquad
       \Phi_*c_Q=4c_X.
\]

The adjoint gives the same statement in the other direction.  Hence even if
one side's minimal class is algebraic, the Hecke neighbor supplies only four
times the other side's class.  The standard Prym construction already gives
$2c_X$, so this is no parity improvement.

The six axes make the same ceiling visible without a cycle construction.  In
the five-axis basis let

\[
        G=6I-J,
        \qquad v_6=-\sum_{i=1}^5v_i.
\]

Then

\[
  \sum_{i=1}^6v_iv_i^{\mathsf T}=I+J=6G^{-1}.
\]

Under the standard identification of $H_2$ of a ppav with alternating
bivectors, $G^{-1}$ represents its minimal curve class.  Therefore the sum
of the six geometric elliptic-axis classes is exactly $6c_X$.  Again the gcd
with the known Prym multiple is two.

Nor can one invoke Voisin's odd-polarized-isogeny shortcut using the obvious
product $E^5$.  Rational LDL diagonalization makes $G$ square-equivalent to

\[
             \langle5,30,2,1,3\rangle.
\]

This form has Hasse invariant $-1$ at $2$ and $3$, whereas the product
principal form $\langle1,1,1,1,1\rangle$ has invariant $+1$ everywhere.
Moreover $\det G=6^4$ forces the multiplier of any hypothetical rational
similarity to the product form to be a square.  Thus no such polarized
similarity exists.  This does **not** exclude an odd isogeny to some other
genus-five Jacobian; it rules out only the tempting automatic route through
the decomposed principal product.

The Annals gate is consequently sharp:

> Construct the missing odd minimal class (equivalently the special
> universal cycle), or prove a special two-primary obstruction and state the
> Hecke correspondence as the geometry that isolates it.

## 6. Boundary gate

The corrected cusp calculation gives quartic widths

\[
  t=7/10,1/4,1/6,1/2\quad\longmapsto\quad1,2,3,6.
\]

These are precisely the pullback widths under $T(t)$.  Since $\Phi$ is scalar
two on the common rational variation, it intertwines every nilpotent
monodromy operator.  At the exotic Petersen boundary its toric character
lattice is literally the cubic lattice $6I-J$.

This is enough for extension of the Hodge homomorphism after semistable base
change and is strong evidence for extension to semiabelian/Neron models.  It
does **not** yet record the finite-flat kernel scheme at each cusp or prove
compatibility with the chosen toroidal cones.  The exact boundary checklist is:

1. compute the kernel on the toric and abelian parts at widths $1,2,3,6$;
2. show its generic Smith type specializes as a finite flat group scheme;
3. verify that the two deck involutions act with the predicted signs;
4. compare the closure of the Prym/Poincare cycle with the Petersen
   specialization, including vertical components.

## 7. Literature audit

### Claim-specific source ledger

This ledger names eleven sources.  Two were read in full text and nine at the
specified partial depth; the full-text items are included because a published
correction and a recent contrary preprint make the universal-cycle boundary
unusually easy to misstate.

- **Partial:** **Cheltsov--Kuznetsov--Shramov**, *Coble fourfold,
  $S_6$-invariant quartic threefolds, and Wiman--Edge sextics*.
  Read the introduction, Theorem 1.15, Sections 3.1 and 4.2, Theorem 4.4,
  Corollary 4.9, and Remark 4.5.  These supply the resolved quartic conic
  bundle, admissible discriminant cover, Prym intermediate Jacobian, rational
  standard-$S_6$ type, and varying $E^5$ statement.  They do not identify
  $X_0(6)$ or a cubic isogeny.  Cache key `arXiv:1712.08906`, SHA-256
  `14c94b0b671cf5e172893086fed33f6600a593d74a5a83efda5384978022c598`.
- **Partial:** **Carocca--Gonzalez-Aguilera--Rodriguez**, *Weyl Groups and Abelian
  Varieties*.  Read the construction, Remark 3.9, Proposition 4.1,
  Proposition 5.2, Theorem 5.4, and Remark 5.5.  This supplies the classical
  root/weight ppav family and its $\Gamma_0(6)$ modular description, not the
  quartic identification or exotic cubic gluing.  Cache key
  `arXiv:math/0503340`, SHA-256
  `c8e4287a8173c8b5f9ed80187f3463dedcd8a23edeb9d74964357b7eb117cf11`.
- **Partial:** **Beauville**, *Varietes de Prym et jacobiennes intermediaires*.  Read the
  introduction, Proposition 2.8, and all of Theorem 3.6 with its proof.  The
  theorem gives the canonical integral Chow-group/Prym identification for
  special quadric bundles and constructs the conic-component correspondence;
  its proof also shows explicitly that the universal cycle in the reverse
  direction naturally realizes twice the Prym map.  This is the denominator
  canceled by $\Phi=2\alpha$.  Cache key `10.24033/asens.1329`, SHA-256
  `4cf7ebf67a7d0d58c643efdb2d090b3b5fb61b8b7a4dd8e8a743079e9600e1c0`.
- **Partial:** **Nagel--Saito**, *Relative Chow--Kunneth decompositions for conic bundles
  and Prym varieties*.  Read the introduction, Theorems 1 and 2, Sections
  1.5--1.7 and 1.11, and the full construction in Section 2.4.  This supplies
  the rational Prym middle motive and exposes the exact $1/2$ projectors; it
  explicitly works up to isogeny and does not prove the integral saturation
  sought here.  Cache key `arXiv:0806.1507`, SHA-256
  `fa369aa3512bcc82ef34b342ca2dd4ccc2150d28e23ddc42a32b8598ea3cd79f`.
- **Partial:** **Roulleau**, *Genus 2 curve configurations on Fano surfaces*.  Read
  Theorem 11, Lemmas 14--18, the $A_5$ pencil discussion, and the Albanese
  paragraph.  It supplies each $D_5$ elliptic fibration and already states
  $\operatorname{Alb}(S)\sim E^5$; it does not compute the six-axis
  polarization or the quartic bridge.  Cache key `arXiv:1002.4467`, SHA-256
  `c66706bfa8977656043a8c068d9f2cabc7e72dc0f53eac3fab680ac82172c7bd`.
- **Partial:** **van Geemen--Yamauchi**, *On intermediate Jacobians of cubic threefolds
  admitting an automorphism of order five*.  Read Sections 1.4--1.5,
  Propositions 1.5--1.7, and Sections 2.1--2.5.  This supplies the algebraic
  Fano/Prym model and the $D_5$ elliptic factor, but not the six-axis exact
  kernel.  Cache key `arXiv:1506.05346`, SHA-256
  `f263d78728391fc9c1ff836293a484e5caec66b3178ecab3aa1d54b14855baed`.
- **Partial:** **Casalaina-Martin--Grushevsky--Hulek--Laza**, *Extending the Prym map to
  toroidal compactifications*.  The previous pass read Sections 3.3 and 4,
  especially Proposition 4.3 and Remark 4.4, for the signed graph lattice and
  monodromy form.  It supports the boundary calculation, not the relative
  isogeny.  Cache key `arXiv:1403.1938`, SHA-256
  `6b5cda29ef536166280c508db27838844914ce2d652abfe0cbf3d808a9236ecd`.
- **Full text:** **Ze Xu**, *A remark on the Abel--Jacobi morphism for the
  cubic threefold*, arXiv v1 and the four-page note in full.  The paper claims
  a universal codimension-two cycle for every smooth cubic threefold.  It is
  not usable here: Voisin identifies an incorrect Chern-character formula in
  its Theorem 2.3.  Cache key `arXiv:1212.6790`, SHA-256
  `932444f65a035d16ebba10388239a06eaaa650350c9c9b7f3999bd58d8cfa235`.
- **Partial:** **Voisin**, *Unirational threefolds with no universal
  codimension 2 cycle*, arXiv v6.  Read the introduction through Theorem 0.10,
  the proof of Theorem 1.10, and the bibliography.  Theorem 0.7 separates the
  universal-cycle and minimal-class conditions, and the introduction gives
  the exact correction to Xu: a missing term in
  $\operatorname{ch}(\mathcal O_X(1))$.  Cache key `arXiv:1312.2122`,
  SHA-256
  `f203f393c6da6c5705392b0123687c33f7c42edf8c7e48768b4bcf790d3481f0`.
- **Partial:** **Voisin**, *On the universal $\operatorname{CH}_0$ group of
  cubic hypersurfaces*, arXiv v2.  Read the introduction, Theorems 1.6--1.7,
  Corollary 4.4, and Theorem 4.5 with its proof.  Corollary 4.4 proves the
  exact cubic equivalence used above; Theorem 4.5 gives an odd-polarized-
  isogeny route to algebraicity of the minimal class.  Cache key
  `arXiv:1407.7261`, SHA-256
  `514e5634d920f4b8e9c6797f3de5ad34afea65624ba23cc764d329ebcdd2c4e4`.
- **Full text:** **Banerjee**, *Universal codimension two cycle on a very
  general cubic threefold*, arXiv v1.  Read all twelve extracted pages.  This
  2025 preprint claims nonexistence for a very general cubic, but neither its
  generality statement nor its proof settles the special one-dimensional
  $A_5$ locus.  It is recorded as a live, unrefereed warning, not treated as
  established input.  Cache key `arXiv:2509.06013`, SHA-256
  `24d992d6eb0d8b0e0a6bbb6a531a87a7c24e866e2eb55cf0238173b8d7d753ca`.

### Bounded priority search

On 2026-08-10 the following exact web queries were run in addition to the
earlier C904 searches:

```text
"S6-invariant quartic" cubic threefold intermediate Jacobian isogeny
"Coble fourfold" cubic threefold intermediate Jacobian correspondence
"Petersen" "cubic threefold" Prym intermediate Jacobian A5
"A5" quartic threefold cubic threefold intermediate Jacobian isogeny
"6I-J" Petersen Prym cubic threefold
"intermediate Jacobian" "X_0(6)" quartic cubic
"S_6" quartic "A_5" cubic isogeny
"Coble" quartic "A5 cubic" correspondence
site:arxiv.org principally polarized abelian varieties transverse maximal
  isotropic subgroups isogeny Hecke correspondence kernel
site:arxiv.org Prym intermediate Jacobian cubic threefold algebraic
  correspondence conic bundle cycle
```

The searches recovered the source papers, general Hecke/isogeny literature,
and Nagel--Saito's motivic theorem.  No direct quartic--cubic isogeny,
transverse-gluing kernel, genus-three marking cover, or Petersen/cubic
correspondence was located.  This licenses only:

> No direct predecessor was located in the bounded primary-source and web
> search.

It does not license a manuscript-bound global novelty claim.  MathSciNet,
zbMATH, Google Scholar cited-by closure, and systematic forward citations of
CKS, Roulleau, Carocca et al., and Nagel--Saito remain required.

## 8. TT / red-team pass

1. **Could the isogeny have degree $2^5$?**  No.  The two principal lattices
   are transverse quotients, not source/quotient by one Lagrangian.  The
   primitive comparison has multiplier four and determinant $4^5=2^{10}$.
2. **Could scalar one work after changing markings?**  No.  Any rational
   quartic point and any exotic cubic point of $\mathbf P^1(\mathbf F_4)$ are
   distinct and hence transverse.  Scalar one has half-integral entries.
3. **Could the correspondence descend without the two covers?**  Not as an
   ordinary marked isogeny by the present construction.  One deck involution
   exchanges exotic gluings and the other changes the elliptic factor by its
   nontrivial quadratic twist.
4. **Does an isogeny of intermediate Jacobians imply the threefolds are
   birational?**  No.  Torelli uses a polarization-preserving isomorphism, not
   this multiplier-four isogeny.  CKS already rule out birationality to a
   smooth cubic for their general quartics.
5. **Is the integral Chow cycle automatic?**  No; its exact candidate is now clear.
   Nagel--Saito use rational projectors and Beauville's reverse universal
   family naturally gives twice the Prym map.  The honest homomorphism
   $h=\alpha(1-\sigma)$ clears the quartic denominator, but it still must be
   represented by a family of zero-cycles on the cubic Fano surface.  A
   Poincare divisor alone has the wrong codimension.
6. **Could special CM fibres add smaller maps?**  Individual fibres may gain
   endomorphisms.  The relative generic map remains unique up to sign because
   the generic multiplicity factor is non-CM and the horizontal commutant is
   scalar.
7. **Does the Hecke isogeny force the cubic universal cycle?**  No.  It
   transports four times the minimal class; the six axes give six times it;
   the classical Prym construction already gives twice it.  All three stop at
   the same parity wall.  Voisin's stronger conclusion requires the odd
   class itself.
8. **Can the evident isogeny $E^5\to J(X)$ bypass that wall?**  Not with the
   product principal polarization.  The Hasse invariants of $6I-J$ differ
   from the product form at $2$ and $3$.  An unrelated odd polarized isogeny
   from another genus-five Jacobian is not excluded.

## 9. EJ / extra-juice pass

The cheap upgrades exposed by the proof have been taken.

1. The abstract splitting field was replaced by the explicit square classes
   $R,S$ and a genus-three hyperelliptic model.
2. The fivefold computation was promoted to the general transverse-gluing
   Smith theorem $(1^h,2^{2m},4^h)$.
3. The isogeny was made bidirectional through its Rosati adjoint.
4. The six-axis operator was identified exactly as $3\Phi$, explaining a
   divisibility that was previously only suggestive.
5. The attempted Poincare shortcut was red-teamed and stopped: it yields the
   right Albanese homomorphism but not automatically the required family of
   zero-cycles.  The generic cycle gate is now the exact representability of
   $h=\alpha(1-\sigma)$ on the special $A_5$ Fano family.
6. The universal-cycle question was reduced to one two-primary minimal-class
   bit.  Exact axis and Hasse calculations explain why neither the six
   Roulleau quotients nor the obvious product $E^5$ isogeny resolves it.

## 10. Mystery ledger

- **Why does the exotic Petersen lattice equal the cubic axis lattice?**
  Settled: both are the exotic $A_5$ two-primary gluing of the same six-axis
  simplex; the graph calculation gives $6A_5^\vee=6I-J$.
- **Why is the primitive scalar exactly two?**  Settled: rational and exotic
  points of $\mathbf P^1(\mathbf F_4)$ are transverse; one elementary plane is
  $\operatorname{diag}(1,4)$ under scalar two.
- **Why is the six-axis sum divisible by three?**  Settled in the homomorphism
  lattice: the tight frame is $6I$ and the primitive comparison is $2I$.
  Divisibility of a chosen integral Chow cycle remains open.
- **Why does the required marking cover have genus three?**  Settled by the
  disjoint degree-two and degree-four branch characters; its three quadratic
  quotients have genera $0,1,2$.
- **Does the primitive homomorphism admit an integral relative
  threefold-cycle representative?**  Open but sharply reduced.  Beauville
  closes the quartic cylinder and $h=\alpha(1-\sigma)$ is an honest integral
  homomorphism.  Exact evidence gap: represent $h$ by an integral relative
  family of zero-cycles on the special $A_5$ Fano surfaces; a Poincare divisor
  by itself is not enough.  Owner: next C904 cycle pass.
- **Is the missing universal cycle only a normalization issue?**  Settled
  negatively.  Voisin's criterion identifies one integral parity bit:
  algebraicity of $\Theta^4/4!$.  The Hecke map, six axes, and Prym geometry
  give multiples $4,6,2$, and the product-$E^5$ polarization has Hasse
  obstructions at $2,3$.  A special odd class or a special obstruction is the
  exact remaining mathematical target.
- **Does the kernel extend finite-flatly over all four cusps?**  Open.  Exact
  evidence gap: toric/abelian kernel calculation and compatibility with
  toroidal cones.  Owner: next C904 boundary pass.
- **Can the correspondence descend from the marking cover?**  Ordinary
  descent is obstructed by the exotic-gluing and twist characters.  A twisted
  correspondence or a descended higher-power construction remains a genuine
  discovery-track question.
- **Priority.**  Open at manuscript standard.  The bounded search found no
  predecessor, but citation-graph closure is incomplete.

## 11. Reproducibility

Working directory:

```text
/home/tavis/src/othello
```

Primary replay:

```bash
nix-shell -p 'python3.withPackages (ps: [ps.sympy])' --run \
  'python3 notes/2026-08-10-c904-quartic-cubic-hecke-neighbor.py --check'
```

Independent standard-library replay:

```bash
python3 notes/2026-08-10-c904-quartic-cubic-hecke-neighbor-replay.py --check
```

Both print `CHECK PASS`.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-10-c904-quartic-cubic-hecke-neighbor.py` | 12,289 | `a96da9c56a4764d41db9855f5bfc38b83d95f522a838b9f086386460970d51d5` |
| `notes/2026-08-10-c904-quartic-cubic-hecke-neighbor.out` | 1,150 | `a88523b8dc34f1406a21c9cbe6ea8af830202238ccbfda9eb7b312b299694600` |
| `notes/2026-08-10-c904-quartic-cubic-hecke-neighbor-replay.py` | 12,268 | `02af6b12e62087ef1d412d4accc058e7de856772b00ad1f4b440b6e677a411a6` |
| `notes/2026-08-10-c904-quartic-cubic-hecke-neighbor-replay.out` | 458 | `106762501ffea35fc3261f678d626a8d6a4f6825b85e6e059f60c2db3f9917cf` |

The report itself is anchored by the task-owned git commit rather than a
self-referential embedded hash.
