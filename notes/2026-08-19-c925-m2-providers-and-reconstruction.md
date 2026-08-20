# Module 21B. Providers and reconstruction

**Packet part:** Module 21.12--21.16.  Stable index:
notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md

## 21.12 Provider morphisms and non-implications

The competing routes fit into the implication diagram

\[
\begin{CD}
\mathsf{GammaOrlovSquare}
 @>>> \mathsf{DirectAugBlowup}\\
 @. @VVV\\
\mathsf{TwoWallRankQuotient}
 @>>> \mathsf{RowStabilizerPath}
 @>>> \mathsf{BooleanInvariant}.
\end{CD}
\tag{21.23}
\]

The top arrow is Theorem 21.2, the right vertical arrow is Theorem 21.1,
and the bottom-left arrow is the common-open/rank-zero-target Stokes lemma.
The bottom route needs only the aggregate transition at each incompatible
pair of incident receivers; it need not lift every arrow to an integral
Gamma square.

None of the displayed arrows may be reversed formally.  For example, with
\(r=(1,0)\), every matrix

\[
T_{a,b}=\begin{pmatrix}1&0\\a&b\end{pmatrix},\qquad b\ne0,
\]

preserves \(r\), while the action on \(\ker r\) is invisible to the row and
cannot reconstruct a Gamma--Orlov lift.  Conversely, an aggregate path can
preserve \(r\) by cancellation even when its individual factors do not:

\[
U=\begin{pmatrix}1&1\\0&1\end{pmatrix},\qquad
U^{-1}=\begin{pmatrix}1&-1\\0&1\end{pmatrix},\qquad
rU\ne r,\quad rUU^{-1}=r.
\tag{21.24}
\]

Thus a theorem only at the final Boolean level cannot be silently promoted
to edgewise marked compatibility.  Diagram (21.23) is also the modular
choice point: the caller may provide rich integral lifts, direct augmented
arrows, or only the smallest common-open row quotient, and the downstream
Boolean consumer is unchanged.

## 21.13 Multi-sector reconstruction from sparse Stokes shadows

There is one precise way in which parallel projections can recover a block
that no single sector sees conservatively.

### Theorem 21.3 -- jointly separating half-space shadows recover the zero block

Let \(\Phi\) be a finite subset of a real vector space containing \(0\), and
let

\[
W=\bigoplus_{\phi\in\Phi}W_\phi.
\]

For a real linear functional \(\lambda\), put

\[
F_\lambda^{\le0}W
=\bigoplus_{\lambda(\phi)\le0}W_\phi.
\tag{21.25}
\]

If a finite family \(\Lambda\) satisfies

\[
\forall\phi\ne0\quad\exists\lambda\in\Lambda
\quad\lambda(\phi)>0,
\tag{21.26}
\]

then

\[
\bigcap_{\lambda\in\Lambda}F_\lambda^{\le0}W=W_0.
\tag{21.27}
\]

Indeed, the \(W_0\)-summand belongs to every half-space shadow.  Condition
(21.26) excludes every other summand from at least one of them. ∎

This is a finite-limit reconstruction theorem: the inclusions
\(F_\lambda^{\le0}W\hookrightarrow W\) form a jointly monic family whose
pullback is exactly \(W_0\).  A single shadow is normally insufficient,
because it retains every strictly decaying exponential on that ray.

For a Stokes-filtered local system, apply the theorem on the **dual** formal
solution space, where the Gamma point row is a section.  The normalized
ambient exponent is \(0\), and the exceptional blowup exponents are the
nonzero elements of \(\Phi\).  If one can

1. map a finite set of sectorial paths to one common dual fiber coherently;
2. supply a simultaneous splitting, or an equivalent Beck--Chevalley
   comparison, identifying the transported Stokes subspaces with the formal
   half-space subspaces (21.25);
3. prove that the continued Gamma point section lies in
   \(F_\lambda^{\le0}\) for every chosen direction; and
4. choose directions satisfying (21.26),

then (21.27) forces point-row purity without computing any Stokes
multiplier.  The path maps in item 1 are the requested functor between path
types; the transported section is indexed State, and the intersection is
the lens getter from the family of Reader-supplied sectorial orders.

Coherent path transport alone does not supply item 2.  For instance, with
\(W=Ke_0\oplus Ke_1\), the formal shadows
\(Ke_0\subset W\) have intersection \(Ke_0\), but a Stokes shear can replace
the first inclusion by \(K(e_0+e_1)\subset W\).  Their transported
intersection is then \(K(e_0+e_1)\), which retains a nonzero exceptional
component.  The shear is exactly the optic residual that the bare path map
forgot.

Only the finite reconstruction theorem is unconditional.  For an arbitrary
smooth blowup, items 2--3 are genuine analytic assertions.  The split-nef
Kummer calculation proves it in its pilot cases because the normalized
point solution is polynomial.  For a split negative normal degree, the raw
slice \((e^R-1)/R\) leaves a nonzero \(e^{-R}/R\) branch after normalization,
so one cannot assert the required multi-sector moderation.  In the nonsplit
case the relative-cap point-purity lemma would supply items 2--3, but that
lemma is currently open.  Thus Theorem 21.3 is a new alternative interface
for the same missing analytic content, not an \(m=2\) proof.

## 21.14 A holonomic/Fourier specialization of the same reconstruction law

The multi-sector criterion has a useful exact analytic avatar.

### Theorem 21.4 -- global polynomial growth forces punctual exponential support

Let \(E\) be a finite-dimensional complex vector space and let

\[
f(z)=\sum_{\phi\in\Phi}p_\phi(z)e^{\phi z},
\tag{21.28}
\]

where \(\Phi\subset\mathbf C\) is finite and every \(p_\phi\) is an
\(E\)-valued polynomial.  Suppose that on every ray
\(z=re^{i\theta}\), the function \(f\) has polynomial growth as
\(r\to+\infty\).  Then \(p_\phi=0\) for every \(\phi\ne0\); equivalently,
\(f\) is a polynomial.

### Proof

Assume some nonzero exponential remains.  The finite polytope
\(\operatorname{conv}(\{0\}\cup\{\phi:p_\phi\ne0\})\) has a nonzero exposed
vertex \(\phi_0\).  Choose \(\theta\) so that
\(\operatorname{Re}(e^{i\theta}\phi)\) has a unique positive maximum at
\(\phi_0\).  After applying a linear functional on \(E\) which does not kill
the leading coefficient of \(p_{\phi_0}\), the \(\phi_0\)-term dominates
all other terms by an exponential factor on that ray.  It cannot have
polynomial growth, a contradiction. ∎

### Corollary 21.4A -- rational coefficients and finitely many test rays

The same conclusion holds when the nonzero \(p_\phi\) are \(E\)-valued
rational functions: choose the exposing ray away from their finitely many
poles.  After a scalar functional has selected a nonzero coordinate, a
rational coefficient has a nonzero Laurent leading term at infinity, hence
only polynomial growth or decay; it cannot cancel exponential domination.
This includes coefficients such as \(1/R\) in the negative-degree pilot.

Moreover, for a fixed finite candidate set \(\Phi\), polynomial growth need
only be tested on finitely many rays.  For every nonempty subset
\(S\subseteq\Phi\setminus\{0\}\), choose one direction which has a unique
positive maximum at a nonzero exposed vertex of
\(\operatorname{conv}(\{0\}\cup S)\).  The resulting finite family contains
an exposing ray for the actual nonzero support, whatever subset it is.

This is a finite analytic certificate only after one global function with
candidate support contained in \(\Phi\) has been constructed.  Unrelated
sectorial germs do not meet the premise, and the corollary supplies neither
their gluing nor their growth estimates.

Under Fourier--Laplace transform, (21.28) is the solution generated by a
finite-length holonomic object supported on \(\Phi\); Theorem 21.4 says that
global polynomial growth forces that support to be punctual at the ambient
exponent \(0\).  Thus another lawful specialization of the modular packet is

\[
\mathsf{ExpHol}
\xrightarrow{\ \operatorname{FL}^{-1}\ }
\mathsf{Hol}_{\mathrm{fin}}(\mathbf A^1)
\xrightarrow{\ \Gamma_{\{0\}}\ }
\mathsf{Vect},
\tag{21.29}
\]

where the middle functor takes the punctual subobject supported at zero.
Finite support itself is only lax under addition or convolution because top
coefficients can cancel.  Its convex-hull/Newton polytope is monoidal under
convolution over a domain, while the associated-graded face retained in
Theorem 21.5 records the coefficients needed to detect cancellation.

For the blowup problem this is again a conditional interface.  One would
need the normalized Gamma point channel, coefficientwise in the retained
Novikov variables, to have the finite exponential-polynomial form (21.28)
and polynomial growth on a separating set of rays.  The split-nef Kummer
pilot has exactly this form.  The negative-degree tail \(e^{-R}/R\) violates
the growth premise, and no audited source proves the required punctual
Fourier support for arbitrary relative caps.  The theorem therefore gives a
sharp falsifier and a possible holonomic specialization, not the missing
provider.

### Theorem 21.5 -- exposed exponential faces form a filtered-monoidal shadow

Let \(k\) be an integral domain, let \(\Gamma\) be a torsion-free abelian
group, and consider its finite-support group algebra \(k[\Gamma]\).  For an
additive weight (group homomorphism) \(w:\Gamma\to\mathbf R\) and nonzero
\(f=\sum_\gamma a_\gamma[\gamma]\), define

\[
\nu_w(f)=\max_{a_\gamma\ne0}w(\gamma),\qquad
\operatorname{in}_w(f)
=\sum_{w(\gamma)=\nu_w(f)}a_\gamma[\gamma].
\tag{21.30}
\]

Put \(\nu_w(0)=-\infty\), with the usual extended-addition convention, and
\(\operatorname{in}_w(0)=0\).  For nonzero \(f,g\),

Then

\[
\nu_w(fg)=\nu_w(f)+\nu_w(g),\qquad
\operatorname{in}_w(fg)
=\operatorname{in}_w(f)\operatorname{in}_w(g).
\tag{21.31}
\]

For sums,

\[
\nu_w(f+g)\le\max\{\nu_w(f),\nu_w(g)\},
\tag{21.32}
\]

If \(\nu_w(f)=\nu_w(g)\), the inequality is strict exactly when
\(\operatorname{in}_w(f)+\operatorname{in}_w(g)=0\).  If their top weights
are unequal, the inequality is an equality.  These are the standard
associated-graded laws for the weight filtration.  Indeed, the supports of
\(f\) and \(g\) generate a finitely generated torsion-free subgroup of
\(\Gamma\), hence a free abelian group; its group algebra over \(k\) is a
domain, so the product of two nonzero initial forms is nonzero.  Additivity of
\(w\) then gives (21.31).

Thus the exposed-face assignment is a multiplicative filtered shadow on
group-algebra elements.  It becomes a filtered-monoidal specialization only
after a category and its action on morphisms have separately been specified;
no such categorical upgrade is used here.  Reader supplies \(w\), indexed
State stores the current support face, and Writer records the exact
initial-form identities discharged under addition.  Applied to a relative
degeneration, no lower-weight gluing channel can cancel a forbidden exposed
exponential.  One must group precisely the channels on the same top face and
prove their initial forms sum to zero.

The domain hypothesis is load-bearing.  A cohomology-valued degeneration
may have zero divisors, so (21.31) should be applied only after the scalar
point-row pairing, or after passage to a coefficient domain on which the
relevant initial forms remain nonzero.

For the normalized negative-degree pilot

\[
\frac{1-e^{-R}}{R},
\]

the forbidden \(-1\) exponential has nonzero exposed coefficient
\(-1/R\) in the ray where it grows.  Consequently any relative-cap proof
must exhibit another top-face channel with the opposite coefficient; a
formal support or lower-order argument cannot suffice.  This turns the open
relative-cap lemma into a finite associated-graded cancellation target at
each retained Novikov coefficient, while making no claim that the
cancellation holds.

## 21.15 The comma-bridge theorem for parallel retained paths

The higher-support path and the QDM path can be combined without pretending
that either determines the other.

Let \(\mathcal A\) be a category of retained objects (for example numerical
\(K\)-theory with a support recollement), let \(\mathcal Q\) be a category of
operator objects, and let

\[
R:\mathcal A\to\mathsf{Vect}_K,
\qquad
S:\mathcal Q\to\mathsf{Vect}_K
\]

be realization functors.  A **bridge object** is

\[
(a,q,\gamma_a:R(a)\twoheadrightarrow S(q),
  \epsilon_a:R(a)\to L_a)
\tag{21.33}
\]

with \(\ker\gamma_a\subseteq\ker\epsilon_a\).  Thus \(\epsilon_a\) descends
uniquely to a row \(r_a:S(q)\to L_a\).  A bridge morphism
\((u,f,\ell):(a,q,\gamma_a,\epsilon_a)\to
(b,q',\gamma_b,\epsilon_b)\) satisfies

\[
S(f)\gamma_a=\gamma_bR(u),
\qquad
\epsilon_bR(u)=\ell\epsilon_a.
\tag{21.34}
\]

### Theorem 21.6 -- bridge naturality forces the augmented row law

Every bridge morphism satisfies

\[
r_bS(f)=\ell r_a.
\tag{21.35}
\]

If \(f\) also intertwines the retained operators, it is therefore a morphism
of \(\mathsf{AugOp}_K\).  Bridge morphisms compose, and the induced
augmented-row construction is functorial.

### Proof

Precompose the desired identity with the epimorphism \(\gamma_a\):

\[
r_bS(f)\gamma_a
=r_b\gamma_bR(u)
=\epsilon_bR(u)
=\ell\epsilon_a
=\ell r_a\gamma_a.
\]

Epimorphy gives (21.35), and composition is the ordinary comma-category
calculation. ∎

This is the exact categorical version of reading forgotten information from
a higher parallel projection.  Useful choices of \(\mathcal A\) include:

| retained path \(\mathcal A\) | output \(\epsilon\) | data still required in \(\gamma\) |
|---|---|---|
| Orlov numerical \(K_0\) | generic rank | Gamma/integral compatibility with the QDM comparison |
| recollement \(\operatorname{Perf}_D(Y)\to\operatorname{Perf}(Y)\to\operatorname{Perf}(U)\) | common-open rank | a QDM realization of the localization square |
| finite-support holonomic/Fourier object | punctual zero-exponent component | identification of the normalized Gamma channel with the Fourier realization |
| strict nearby/vanishing-cycle object | dual row on the quotient | strict boundary maps and row-nullity of vanishing cycles |

Reader carries \((R,S,\epsilon)\) and the bridge laws; indexed State carries
the current pair \((a,q)\); the optic residual is \(\gamma\); Writer records
support-null and strictness certificates.  Forgetting \(\gamma\) leaves two
parallel paths but destroys (21.35), exactly as the Stokes graph countermodel
shows.

The theorem does not build a bridge.  For \(m=2\), a pseudonatural family of
the first or second row of the table along arbitrary weak factorization would
prove the required augmented-row path theorem.  Constructing that family is
the same one-row Gamma/common-open provider already isolated above, now
expressed without any ideal or zero-mode ambiguity.

## 21.16 What scales to \(m>2\)

The comma-bridge theorem separates a dimension-free implication from the
dimension-sensitive provider search.

### Corollary 21.7 -- a rank bridge for all blowups proves all stabilizations

Assume that for every smooth blowup in every relevant dimension there is a
pseudonatural bridge of Theorem 21.6 whose high retained path is Orlov
numerical \(K_0\), whose output is generic rank, and whose QDM side
intertwines the normalized formal monodromy.  Then the pointed
primitive-sixth row Boolean is a birational invariant in every dimension.
Combined with
the audited endpoint calculation, this proves the irrationality of
\(X\times\mathbf P^m\) for every \(m\ge1\).

The proof is dimension-free: every exceptional Orlov functor has image
supported on a proper exceptional divisor and hence generic rank zero,
regardless of the center dimension or codimension.  Theorem 21.6 supplies
the augmented-row blowup arrows, and weak factorization composes them.

This corollary is a conditional implication, not a theorem that the bridge
exists.  Its premise is stronger than the one-row provider targeted for
\(m=2\).  The latter benefits from the fivefold center bound: only rank-two
normal bundles of threefold centers are genuine primitive carriers.  For
\(m>2\), centers of dimension at least four can carry additional
primitive-sixth data, and higher-codimension blowups have longer exceptional
strings.  The relative-cap/exposed-face approach then becomes multivariate,
with \(\Gamma\cong\mathbf Z^{c-1}\); Theorem 21.5 still applies to each
weight, but it supplies no uniform cancellation theorem.

The independent \(\mathbf G_a\)/Jordan route scales differently.  The
projective factor asks for \(J_{m+1}\), and tensor-product coherence is
controlled by the Clebsch--Gordan law already tested in Module 19.4.  What
does not scale for free is the geometric carrier exclusion: higher
dimensional centers can themselves carry the required long nilpotent string.
Thus category theory organizes the higher-\(m\) obstruction and its
compositions, but neither the rank bridge nor the carrier theorem is
currently available.
