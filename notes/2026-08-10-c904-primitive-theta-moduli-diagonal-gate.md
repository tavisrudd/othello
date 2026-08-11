# C904 primitive-theta moduli/diagonal gate

> **Later status (2026-08-10).**  The fine-moduli and integral diagonal
> results below remain valid.  The proposed formal universal-sheaf
> `c_3`/lambda escape is now closed negatively by
> `2026-08-10-c904-universal-sheaf-tautological-parity-wall.md`: every
> formally twist-invariant codimension-three expression has even theta
> degree.  Only genuinely non-tautological primitive classes remain live.

Date: 2026-08-10
Status: quarantined Annals research; no manuscript or Lean edits
Scope: the fine-moduli status of `M=Bl_0 Theta`, uniform Ext vanishing,
diagonal formulas, and whether they prove the two-local integral Hodge
statement needed for a primitive theta cycle

## Executive verdict

The moduli idea improves substantially at its first two steps, but the last
two-local Chow step is not supplied by the literature.

For

\[
 v=\left(3,-H,-\frac12H^2,\frac16H^3\right)
\]

on a smooth cubic threefold `X`, Bayer et al. identify the smooth projective
fourfold of stable sheaves `M_X(v)` with `Bl_0 Theta`.  Two exact corrections
are important.

1. The Hilbert-polynomial value ideal `3Z` is **not** the full determinant
   weight ideal.  One has
   \[
       \chi(v\otimes O_p)=3,\qquad
       \chi(v\otimes O_l)=2
   \]
   for a point and a line.  Thus `O_p-O_l` has Euler weight one.  The stable
   sheaf gerbe is neutral and `M` admits a universal sheaf.  There is no
   residual order-three obstruction to invert.

2. Bayer et al.'s tilt-stability proof gives uniform pairwise vanishings,
   not merely unobstructedness on the diagonal:
   \[
       \operatorname {Ext}^i(E,F)=0\quad(i\ge2)
   \]
   for all `E,F` in `M`.  Consequently the diagonal is the expected
   rank-drop locus of the universal relative Hom complex, and the standard
   Thom--Porteous argument gives
   \[
      [\Delta_M]=c_4\!\left(-R\pi_{13*}
        R\mathcal Hom(\mathcal E_1,\mathcal E_2)\right)
      \quad\text{in }CH^4(M\times M).
   \]

This integral diagonal formula is promising and apparently not stated for
this cubic-threefold moduli space.  It does **not**, by itself, prove that
the primitive topological curve class on `M` is algebraic at two.

The closest motivic theorem is Bülles's rational result for moduli of
sheaves on K3/abelian surfaces.  Its factorization of the diagonal through
powers of the source surface uses Grothendieck--Riemann--Roch and the
identity

\[
 \operatorname {ch}_n
  =\frac{(-1)^{n-1}}{(n-1)!}c_n+\text{lower Chern terms}.
\]

For the codimension-four diagonal the denominator is `3!=6`; after
localizing at two, the factor two remains noninvertible.  Integrally the
same gamma-filtration phenomenon gives a factor `(p-1)!=2` in codimension
three, exactly the degree relevant to one-cycles on a fourfold.  The
published argument therefore yields at best an even algebraic multiple of
the primitive curve class, which is already known.

No primary theorem was found that turns the universal Ext complex of stable
sheaves on an arbitrary threefold into a `Z_(2)` Chow-motive decomposition,
or that proves the integral Hodge conjecture for one-cycles on this `M` from
the `A_5/E^5` motive of `X`.

The honest theorem target is therefore narrower:

> Prove an integral-at-two factorization of the specific codimension-three
> primitive curve projector on `M_X(v)` through algebraic correspondences
> from the marked cubic (or its elliptic motive), avoiding the factorial two
> in Chern character/gamma filtration.

Until that refinement is proved, the moduli diagonal route stops at the
same factor two as Fano incidence and Shen's theta-supported cycle.

## 1. The moduli space is fine

The Hilbert polynomial computed from `v` is

\[
                         P_v(n)=\frac32n(n+1)^2.
\]

Its values have gcd three.  This is only the ideal obtained from the test
classes `O_X(n)`.  The obstruction gerbe is controlled by the full Euler
pairing with algebraic `K(X)`.

For a closed point `p`, the weight is the rank:

\[
                         \chi(E\otimes O_p)=3.
\]

For a line `l=P^1` in `X`, Grothendieck--Riemann--Roch on the closed
immersion, or restriction when `E` is locally free along the line, gives

\[
 \chi(E\otimes^L O_l)
   =\chi(P^1,E|_l)
   =\operatorname {rk}E+\deg(E|_l)
   =3+c_1(E)\cdot l=2.
\]

Therefore

\[
              \chi\bigl(v\otimes(O_p-O_l)\bigr)=1.
\]

The standard determinant-line criterion for stable-sheaf moduli now gives
a universal family on `M x X`: a determinant line bundle of scalar weight
one neutralizes the `G_m`-gerbe.  Markman states the same criterion in the
surface setting as the existence of `x in K_alg(X)` with `chi(x cup v)=1`;
the determinant-line construction itself is not dimension-specific.

Thus the provisional order-three/quasi-universal description was too weak.
The class `O_p-O_l` is the missing test object.

## 2. Uniform Ext vanishing

Let `E,F` be any two sheaves represented by `M`.  They are slope stable of
the same primitive numerical type.  Hence

\[
 \operatorname {Hom}(E,F)=
 \begin{cases}
  \mathbf C,&E\cong F,\\
  0,&E\not\cong F.
 \end{cases}
\]

Serre duality and slope stability give

\[
 \operatorname {Ext}^3(E,F)
   =\operatorname {Hom}(F,E(-2H))^*=0.
\]

For `Ext^2`, Bayer et al., Lemmas 6.5 and 6.8 and the proof of Corollary 6.9,
show that every `F` of class `v` is `nu_{alpha,-1}`-stable and every
`E(-2H)[1]` is stable in the same tilt heart.  Near `alpha=0` their slopes
satisfy

\[
       \nu_{0,-1}(F)=0>
       -\frac12=\nu_{0,-1}(E(-2H)[1]).
\]

Stability therefore gives

\[
 \operatorname {Ext}^2(E,F)
   =\operatorname {Hom}(F,E(-2H)[1])^*=0.
\]

This is uniform in the ordered pair.  Since `chi(v,v)=-3`, it follows that

\[
 \dim\operatorname {Ext}^1(E,F)=
 \begin{cases}
  4,&E\cong F,\\
  3,&E\not\cong F.
 \end{cases}
\]

The diagonal is exactly the locus where `Ext^0` and `Ext^1` jump by one.

## 3. The diagonal formula that does apply

Let `E` be a universal sheaf on `M x X` and set

\[
 \mathsf W=R\pi_{13*}R\mathcal Hom(
       \pi_{12}^*\mathcal E,\pi_{23}^*\mathcal E)
       \in D^b(M\times M).
\]

The uniform Ext vanishing makes `W` a perfect complex of amplitude `[0,1]`.
Locally represent it by a map of vector bundles

\[
                             A\longrightarrow B.
\]

Off the diagonal the map is injective.  Along the diagonal its kernel is a
line, generated by the identity endomorphism.  Since

\[
                         \operatorname {rk}B-\operatorname {rk}A=3,
\]

the first rank-drop locus has expected codimension

\[
                         (1)(3+1)=4=\operatorname {codim}\Delta_M.
\]

The tangent identification
`T_[E]M=Ext^1(E,E)` makes the degeneracy scheme the diagonal with
multiplicity one.  Thom--Porteous gives

\[
                         [\Delta_M]=c_4(B-A)=c_4(-\mathsf W).
\]

This is the same mechanism as Ellingsrud--Stromme and Beauville in the
uniform-`Ext^2=0` surface case.  King--Walter's Theorem 1 packages it for a
fine module moduli space under:

- stable Hom and tangent conditions;
- vanishing of every higher Ext for every ordered pair;
- a universal projective resolution whose terms decompose into fixed
  projectives tensored with vector bundles on the moduli space.

The first two hypotheses hold here.  Their third hypothesis should **not**
be asserted: it is adapted to module/quiver moduli and to `P^2`, where a
full exceptional/Beilinson resolution exists.  A cubic threefold has a
nontrivial Kuznetsov component and odd middle cohomology.  Indeed,
`H^1(M,Z)=H^1(Theta,Z)=H^1(J,Z)` has rank ten, whereas King--Walter's full
conclusion would force all odd cohomology of `M` to vanish.  This is a quick
proof that their decomposable-resolution theorem cannot be imported
verbatim.

The top-Chern identity itself needs only the perfect relative Ext complex
and the verified degeneracy calculation.  It is a defensible new lemma,
but should be proved in the paper rather than cited as an arbitrary-variety
form of Markman's theorem.

## 4. Why the diagonal does not yet prove the primitive lift

An algebraic diagonal acts as the identity on every cohomology class, but
that tautology does not make an integral Hodge class algebraic.  One needs
the diagonal to decompose into correspondences factoring through varieties
whose relevant integral Hodge classes are known algebraic.

Bülles obtains such a factorization for K3/abelian-surface moduli with
**rational coefficients**.  He defines the ideal of correspondences on
`M x M` factoring through powers of the source surface.  Grothendieck--
Riemann--Roch puts every Chern character component of `-W` in that ideal.
He then inducts from Chern characters to Chern classes using

\[
 \operatorname {ch}_n
 =\frac{(-1)^{n-1}}{(n-1)!}c_n+\text{a polynomial in lower }c_i.
\]

For `n=4`, this requires division by six.  Thus the proof shows
`Delta_M` factors through source powers over `Q`, but not over `Z_(2)`.

The same obstruction can be stated without GRR.  For a smooth variety, the
comparison between codimension-`p` Chow groups and the `p`-th associated
graded of the gamma/topological filtration on `K_0` carries the factor
`(p-1)!`.  For one-cycles on the fourfold `M`, `p=3` and the factor is two.
Universal `K`-theory can therefore certify `2 alpha` while failing to
certify the primitive class `alpha`.

This is not merely a technical denominator that the now-trivial gerbe
removes.  The gerbe and the gamma-filtration factor are independent:

- the gerbe weight ideal is one;
- the codimension-three Chow extraction still has its intrinsic factor two.

Accordingly, the published Markman/Bülles technology reproduces the even
theta lift but does not supply an odd one.

## 5. Interaction with the `A_5/E^5` motive

The rational consequence remains useful.  The same diagonal-ideal argument
should put the rational Chow motive of `M` in the tensor category generated
by the cubic `X`, with powers up to four, once the dimension-three Ext
formula is written carefully.  On the marked cubic, the `A_5/E^5` structure
then gives strong rational algebraicity and finite-dimensionality
expectations.

None of the audited sources upgrades this to an integral-at-two motivic
splitting.  In particular, the following implication is not licensed:

\[
 X\text{ has an }E^5\text{-controlled motive}
 \quad\Longrightarrow\quad
 H^6(M,\mathbf Z_{(2)})_{\rm Hdg}
 \text{ is generated by algebraic curves}.
\]

To prove the primitive theta class it would suffice to algebraize an odd
multiple of the one specific lift `alpha`, not the whole integral Hodge
lattice.  This leaves room for a more targeted correspondence computation.
But it must avoid the codimension-three factorial two, for example by:

1. identifying `alpha` as an integral Chern class/product of universal
   classes rather than a Chern-character component;
2. constructing a two-local projector onto `alpha` directly from the
   `A_5` action;
3. finding an odd-degree geometric correspondence from an elliptic-power
   carrier to `M`;
4. computing the integral Chow image of the exceptional/theta contraction
   directly.

These are new proof obligations, not consequences of the standard diagonal
formula.

## 6. Priority and red-team ledger

### Source-backed / classical

- The stable-sheaf moduli is `Bl_0 Theta`, smooth of dimension four: Bayer
  et al.
- A weight-one Euler class gives a universal family: standard
  determinant-line criterion; Markman states the criterion explicitly in
  the surface setting.
- Uniform higher-Ext vanishing plus stable Hom conditions makes the
  diagonal an expected Porteous locus: Ellingsrud--Stromme/Beauville/
  King--Walter mechanism.
- Markman's exact diagonal formula and Bülles's motivic factorization are
  established for surface moduli, with Bülles working over `Q`.

### New derivations for this cubic moduli

- The full weight ideal is one, witnessed by point and line weights `3`
  and `2`.
- Bayer et al.'s tilt argument implies uniform `Ext^2(E,F)=0` for ordered
  pairs, not only `Ext^2(E,E)=0`.
- The corresponding integral top-Chern formula for `Delta_M`.

### Not found / open

- A published arbitrary-threefold version giving a decomposed Chow
  diagonal from the universal sheaf.
- A `Z_(2)` Chow-motive factorization of `M` through powers of `X`.
- Integral-at-two Hodge surjectivity for one-cycles on `M`.
- A computation showing that the particular primitive theta lift is an
  integral universal Chern class rather than only half of one.

### TT checks

1. **Use only the Hilbert polynomial.**  Misses `O_l` and falsely leaves an
   order-three gerbe.
2. **Quote King--Walter verbatim.**  Their decomposable universal resolution
   would force odd cohomology to vanish, contradicting `b_1(M)=10`.
3. **Quote Markman for a threefold.**  His theorem is for K3/abelian or
   Poisson surfaces and exploits their precise Ext stratification.
4. **Treat the top-Chern diagonal as a decomposition of the diagonal.**
   The former is one algebraic class built from a relative Ext complex; the
   latter requires factorization through known motives.
5. **Apply Bülles at two.**  His paper explicitly uses rational Chow motives
   and GRR; `3!=6` contains the forbidden factor two.
6. **Conflate the gerbe denominator with the Chow denominator.**  The gerbe
   vanishes, while the codimension-three gamma-filtration factor remains
   two.

## 7. Primary sources and read depth

All sources were read partially at the stated load-bearing passages.

- A. Bayer, S. Beentjes, S. Feyzbakhsh, G. Hein, D. Martinelli, F. Rezaee,
  and B. Schmidt, *The desingularization of the theta divisor of a cubic
  threefold as a moduli space*, Geometry & Topology 28 (2024), Lemmas
  6.5--6.8, Corollary 6.9, Theorem 7.1, Lemma 7.5. arXiv:`2011.12240`;
  cached PDF SHA-256
  `ce005e812a7223208938c266281b88c2dbcfc3e125079eb98fcba76b8d365c8a`.

- A. D. King and C. H. Walter, *On Chow Rings of Fine Moduli Spaces of
  Modules*, J. reine angew. Math. 461 (1995), 179--188, Theorems 1 and 4
  and the diagonal proof. arXiv:`alg-geom/9403014`; temporary audited PDF.
  Their Theorem 1 requires pairwise higher-Ext vanishing **and** a universal
  projective resolution with decomposable terms.

- E. Markman, *Generators of the cohomology ring of moduli spaces of sheaves
  on symplectic surfaces*, J. reine angew. Math. 544 (2002), 61--82,
  Theorem 1, Lemma 4, and Section 3 on semi-universal families.
  arXiv:`math/0009109`; temporary audited PDF.  The theorem is
  surface/symplectic-specific.

- E. Markman, *Integral generators for the cohomology ring of moduli spaces
  of sheaves over Poisson surfaces*, Adv. Math. 208 (2007), 622--646,
  introduction, Theorems 1--2, and the universal-family criterion near the
  start of Section 2. arXiv:`math/0406016`; temporary audited PDF.

- T.-H. Bülles, *Motives of moduli spaces on K3 surfaces and of special
  cubic fourfolds*, Manuscripta Math. 161 (2020), 109--124, Theorem 0.1 and
  proof in Section 2.1. arXiv:`1806.08284`; temporary audited PDF.  The
  paper explicitly works with rational Chow motives; equations (1)--(3)
  show where GRR and `(n-1)!` enter.

- G. Ellingsrud and S. A. Stromme, *Towards the Chow ring of the Hilbert
  scheme of `P^2`*, J. reine angew. Math. 441 (1993), 33--44, as cited and
  restated precisely by King--Walter and Markman.  The original paper was
  not separately read in this pass.

Bounded searches combined `diagonal`, `universal Ext complex`, `stable
sheaves`, `arbitrary variety`, `Fano threefold`, `Chow motive`, and
`integral Hodge`.  They returned the surface theorems above, later K3/
hyperkahler refinements, and cubic-threefold moduli descriptions.  No
primary arbitrary-threefold or two-local theorem matching the needed claim
was found.
