# C682 global kernel--incidence morphism and the tangent factor \(5\)

## Outcome

The Bockstein \(22\)-section has a coordinate-free morphism to Hitchin's
incidence scheme on the whole constant-rank Zariski family, not only on the
marked characteristic-\(11\) fibre.  On the golden pair this morphism
identifies the quadratic cover defined by the two kernel branches with the
pullback of Hitchin's incidence cover.

The morphism also identifies the quadratic sheet algebra of the four-orbit
quotient with the pulled-back incidence algebra.  Relative trace then sends
the centered Bockstein separator to \(5\) times the deck-odd orientation
line.  This forces the two splitting speeds \(5\) and \(1\): after the
negative-sheet speed is normalized to \(1\), orbit-weighted trace and deck
oddness force the positive-sheet speed to be \(5\).  Thus
\[
 \frac{5}{1}=5.
\]
Thus \(5\) is not a coincidence between two calculations.  It is the
discriminant character of the quadratic incidence algebra, read through
the relative trace of the kernel refinement.

## The global morphism

Let \(B\) be the smooth marked-presentation Zariski neighborhood over
\(\mathbf Z_{(11)}\) constructed in the Bockstein-globalization report.
Write
\[
 E=\operatorname{Sym}^6\mathcal V
\]
for its relative harmonic bundle, and let
\[
 X_B\subset\operatorname{Gr}_B(3,E)
\]
be the relative fifth-transvectant-isotropic Grassmannian.  On \(X_B\)
write \(\mathcal K\subset E\) for the universal rank-three bundle.  The
relative apolar form is perfect after the already imposed localization.

The divided order-\(11\) contraction cuts out the finite-etale
degree-\(22\) section
\[
 j:\mathscr Z\longrightarrow X_B.
\]
Pull back the universal kernel and form its apolar annihilator
\[
 \mathcal V_{\mathscr Z}
 =\ker\!\left(
 E_{\mathscr Z}\longrightarrow(j^*\mathcal K)^\vee
 \right).
\]
It has rank four.  Projectivization gives
\[
 \mathscr I_{\ker}
 =\mathbf P_{\mathscr Z}(\mathcal V_{\mathscr Z}).
\]
There is a canonical morphism
\[
 \boxed{\quad
 \Phi:\mathscr I_{\ker}\longrightarrow\mathcal I_B,\qquad
 ([f],z)\longmapsto([f],j(z)),
 \quad}
\]
where
\[
 \mathcal I_B
 =\{([f],U)\in\mathbf P_B(E)\times_BX_B:f\perp U\}.
\]
No basis, normal-form coordinate, or choice of a lift of the special
\(V_3\)-projector enters this definition.  In fact
\[
 \mathscr I_{\ker}
 \simeq\mathcal I_B\times_{X_B}\mathscr Z,
\]
so \(\Phi\) is the base change of Hitchin's incidence projective bundle
along the global kernel section.  This also proves base-change
compatibility.

The same description applies if one starts on the operator side.  On the
rank-four locus the universal operator has a locally free rank-three
kernel, hence a regular Grassmannian map.  The earlier target-side theorem
identifies its image with \(\mathscr Z\).  Composing that kernel map with
\(\Phi\) recovers the characteristic-\(11\) formula
\[
 ([a,L],[f])\longmapsto
 \bigl([f],\ker\widehat\Theta(a,[L])\bigr)
\]
as the special fibre of the global construction.

## The golden quadratic cover

Pass temporarily to the finite-etale marking cover on which the radial
kernel and the selected \(A_4\)-kernel are sections
\[
 U_+,\ U_-:B'\longrightarrow X_B.
\]
Their apolar annihilators have rank four.  The certified special fibre has
\[
 \dim(U_+^\perp\cap U_-^\perp)=1,
\]
so after shrinking \(B\) their intersection is a line subbundle
\[
 \mathcal L=U_+^\perp\cap U_-^\perp\subset E_{B'}.
\]
The construction is symmetric in \(U_+\) and \(U_-\).  The projective line
\(\mathbf P(\mathcal L)\) therefore descends and defines the common cubic
\[
 g:B'\longrightarrow\mathbf P_B(E).
\]

The two maps
\[
 b\longmapsto(g(b),U_+(b)),\qquad
 b\longmapsto(g(b),U_-(b))
\]
land in \(\mathcal I_B\).  Near the golden fibre the incidence projection
is finite etale of degree two.  These are two distinct points in every
nearby geometric fibre, so properness and degree give an isomorphism
\[
 \{U_+,U_-\}
 \ \xrightarrow{\;\sim\;}\
 B'\times_{\mathbf P(E)}\mathcal N,
\]
where \(\mathcal N\) is the Stein double cover of the incidence scheme.
Because the construction uses the unordered pair and its common
annihilator line, it descends from the splitting cover.  This is the
required kernel--incidence comparison: the kernel-side deck exchange is
the incidence deck exchange, rather than merely an involution with the
same two special-fibre values.

At the marked special point the line \(\mathcal L\) is
\[
 \left\langle
 X^6+6X^4Y^2+6X^2Y^4+Y^6
 \right\rangle,
\]
the binary representative of \(xyz\).  Thus this global construction
specializes to the two previously certified golden parents.

## Relative trace to the orientation line

Let \(\mathscr S\to B\) be the quadratic sheet cover obtained from the
canonical \(11+11\) partition of \(\mathscr Z\).  On the split completion
its idempotents are
\[
 e_+=e_1+e_{10},\qquad e_-=e_5+e_6,
\]
and its deck coordinate is \(s=e_+-e_-\).  Finite-etale idempotents lift
uniquely, so this partition and its involution algebraize after the same
Zariski shrinking used for \(\mathscr Z\).  The golden construction above
identifies \(\mathscr S\) with the pullback of the incidence Stein cover.
Consequently its trace-zero line is the incidence orientation line, whose
multiplication is
\[
 w^2=5J_0.
\]

Let \(\mathscr A\) be the rank-\(22\) finite-etale algebra of
\(\mathscr Z\).  It is rank \(11\) over the sheet algebra
\(\mathcal O_{\mathscr S}\).  In the split first-order normal form, remove
the common pencil drift and write
\[
 b=5e_1+e_6.
\]
This is the centered tangent separator: it is \(5\) on the radial orbit,
\(1\) on the \(D_5\)-orbit, and zero on the \(A_4\)- and \(S_3\)-orbits.
Its relative trace to the two sheet points is
\[
\begin{aligned}
 \operatorname{Tr}_{\mathscr A/\mathcal O_{\mathscr S}}(b)\big|_{s=1}
   &=1\cdot5+10\cdot0=5,\\
 \operatorname{Tr}_{\mathscr A/\mathcal O_{\mathscr S}}(b)\big|_{s=-1}
   &=5\cdot0+6\cdot1=6=-5\pmod {11}.
\end{aligned}
\]
Hence
\[
 \boxed{\quad
 \operatorname{Tr}_{\mathscr A/\mathcal O_{\mathscr S}}(b)=5s.
 \quad}
\]
This is the missing geometric comparison.  The Bockstein separator maps
to the deck-odd, trace-zero line of the actual incidence cover.  The
coefficient is forced by the stabilizer geometry: the two relevant orbit
degrees are \(1\) and \(6\), and trace zero gives
\[
 1\cdot\delta_+ +6\cdot\delta_-=0
 \quad\Longrightarrow\quad
 \frac{\delta_+}{\delta_-}=-6=5
 \quad\text{in }\mathbf F_{11}.
\]
Thus the literal ratio \(5\) is already forced before evaluating any
Pluecker coordinate.  The global identification of the trace-zero line
then explains why this same scalar is the reduction of the rational
discriminant character in \(w^2=5J_0\).  On the Clebsch chart
\[
 5J_0=5(4\sigma_3)^2,
\]
so the only rational square-class factor is \(5\).

For the four-orbit quotient the complete first-order normal form was
\[
 s^2=1,\qquad b\bigl(b-(3+2s)\bigr)=0.
\]
The branch-difference separator is therefore the single section
\[
 \delta=3+2s
\]
on the quadratic sheet algebra.  Its two values are
\[
 \delta_+=5,\qquad\delta_-=1,
\]
and, more intrinsically,
\[
 \operatorname{Nm}(\delta)
 =(3+2s)(3-2s)=5.
\]
The formula \(3+2s\) is the split-coordinate version of the same
trace/norm statement.  The values \(5\) and \(1\) are not two unrelated
orbit constants.

A pencil change congruent to the identity translates the common first
digit but multiplies both separations by the same unit.  It cannot change
their ratio.  The frozen normalization makes the negative-sheet
separation \(1\), so the discriminant square class is represented by the
literal scalar \(5\).

## Scope and trust boundary

The scheme-theoretic construction uses:

- the algebraic finite-etale \(22\)-section and four-orbit quotient from
  `notes/2026-07-28-c682-zariski-bockstein-orbits.md`;
- the special-fibre kernel, apolar intersection, and inverse construction
  from `notes/2026-07-28-c682-transvectant-deformation-map.md`;
- the global divided contraction and invariant pencil from
  `notes/2026-07-28-c682-u22-bockstein-pencil.md`; and
- Hitchin's universal-bundle incidence model and the already-proved
  rational Stein algebra \(w^2=5J_0\).

No new finite calculation is asserted here.  The proof is a
universal-bundle and relative-trace argument that recombines the three
committed exact bundles.  Their primary certificates and independent
replays remain the numerical trust surface.  In particular, this report
does not enlarge the claimed integral good-reduction set, extend the
operator pencil through loci where its kernel is not locally free, make a
novelty claim, or reopen Paper III.

## `ej` + `tt` closeout and mystery ledger

- **Closed:** the target-side \(22\)-section carries a global
  kernel--incidence morphism on the actual Zariski family.  It is the
  projectivized apolar annihilator of the universal kernel.
- **Closed:** on the golden pair the morphism is an isomorphism to the
  pulled-back incidence double cover; the two deck involutions are the
  same object-level involution.
- **Explained:** relative trace sends the centered tangent separator to
  \(5s\), where \(s\) spans the deck-odd line of the incidence algebra.
  Orbit degrees \(1\) and \(6\) force \(1\cdot5+6\cdot1=0\) modulo \(11\).
- **Closed by `ej`:** the compact normal form already contains the
  geometric answer:
  \(\delta=3+2s\) and
  \(\operatorname{Nm}(\delta)=5\).  The displayed speeds \(5,1\) are its
  two split values.
- **Settled by `tt`:** geometry canonically forces the discriminant class
  \(5\); the exact representative \(5/1\) additionally uses the frozen
  invariant-pencil normalization.  These are distinct assertions and no
  coordinate-free argument should conflate them.
- **Still open:** extend the operator-side kernel map across
  non-constant-rank degenerations by a canonical flattening or graph
  compactification.  The incidence morphism on the finite-etale
  \(22\)-section needs no such extension.
- **Still open:** give the \(D_5\)- and \(S_3\)-branches a classical
  moduli interpretation.  Their role in the four-orbit quotient is
  structural, but no additional incidence theorem for those branches is
  claimed here.

C682 remains open; completion is the user's decision.
