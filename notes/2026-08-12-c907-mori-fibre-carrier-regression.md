# C907: Mori-fibre carrier regression and the ramified residual target

**Lane:** `clebsch`
**Task:** C907 quantum-monodromy stabilization
**Status:** exact regression plus conditional target; it does **not** prove the
threefold enriched-length bound.

## Verdict

Neither terminal Mori-fibre branch can be closed by saying that its base and
smooth geometric generic fibre have no primitive-sixth formal support.  There
are smooth-total-space, relative-Picard-rank-one conic-bundle and degree-three
del Pezzo-fibration models birational to a cubic threefold.  Each has

\[
\nu _6=2,
\]

although its base, smooth blow-up centre, and smooth generic fibre are of
dimension at most two and hence have `nu_6=0` in the already proved C907
sense.  This is an exact regression against a fibrewise or
base-plus-discriminant *formal-support* argument.

It is not a counterexample to the desired enriched statement
\(\ell_{1/6}\leq1\): one primitive self-dual pair is compatible with length
one.  It identifies the missing datum instead.  A conic bundle retains a
ramified quaternion-order component, and a del Pezzo fibration retains a
relative descent/monodromy extension.  A carrier proof must control the
sectorial Rees extension in those components, rather than replace them by
their lower-dimensional geometric shadows.

## 1. Two exact Mori-fibre regressions

Let \(X\subset \mathbf P^4\) be a smooth cubic threefold with
\(\rho(X)=1\), and write \(H\) for its hyperplane class.  The C907 cubic
calculation has its rank-two primitive-sixth formal block, so
\(\nu_6(X)=2\).  The v1 blow-up theorem gives, for a smooth codimension-two
centre \(A\),

\[
 \nu_6(\operatorname{Bl}_A Y)
   =\nu_6(Y)+\nu_6(A;\chi),
 \qquad \nu_6(A;\chi)=0\quad(\dim A\leq2),                 \tag{1}
\]

for every strictly admissible centre specialization \(\chi\).  See
`2026-08-11-c907-v1-framed-fractional-support.md`, §3--4.  Thus both
blow-ups below still have \(\nu_6=2\).

### 1.1 Conic bundle from a line

Choose a line \(\Lambda\subset X\).  Projection from \(\Lambda\) resolves
after its blow-up:

\[
 q:\widetilde X_\Lambda=\operatorname{Bl}_{\Lambda}X\longrightarrow
 \mathbf P^2 .                                                     \tag{2}
\]

Indeed, a point of \(\mathbf P^2\) determines the plane through
\(\Lambda\) on which the cubic cuts as \(\Lambda+Q\), with \(Q\) a residual
plane conic.  Hence (2) is a conic fibration (with the usual possibly singular
discriminant fibres).  Since

\[
 q^*\mathcal O_{\mathbf P^2}(1)=\pi^*H-E,
 \qquad
 -K_{\widetilde X_\Lambda}=2\pi^*H-E
                         =\pi^*H+q^*\mathcal O_{\mathbf P^2}(1),
\]

it is \(q\)-ample; \(\rho(\widetilde X_\Lambda/\mathbf P^2)=1\); and the
total space is smooth, hence terminal.  Formula (1) gives

\[
 \nu_6(\widetilde X_\Lambda)=2,                                  \tag{3}
\]

while \(\nu_6(\mathbf P^2)=\nu_6(\Lambda)=0\).  For a general pair the
discriminant is a plane quintic, but smoothness of that discriminant is not
needed for (3).

### 1.2 Degree-three del Pezzo fibration from a hyperplane pencil

Choose a general pencil \(\langle H_0,H_1\rangle\subset |H|\).  Its base
curve

\[
 \Gamma=X\cap H_0\cap H_1
\]

is a smooth plane cubic.  Blowing it up resolves the pencil to

\[
 f:\widetilde X_\Gamma=\operatorname{Bl}_{\Gamma}X
       \longrightarrow \mathbf P^1 .                              \tag{4}
\]

The fibre over \([a:b]\) is the cubic surface
\(X\cap(aH_0+bH_1)\); blowing up the Cartier base curve in that surface
does not change the fibre.  Moreover

\[
 f^*\mathcal O_{\mathbf P^1}(1)=\pi^*H-E,
 \qquad
 -K_{\widetilde X_\Gamma}=\pi^*H+f^*\mathcal O_{\mathbf P^1}(1).
\]

Thus (4) is a terminal Mori del Pezzo fibration of degree three with smooth
total space and relative Picard rank one.  Again (1) gives

\[
 \nu_6(\widetilde X_\Gamma)=2.                                   \tag{5}
\]

The base \(\mathbf P^1\), the centre \(\Gamma\), and every smooth fibre on
the geometric smooth locus lie in the v1 zero-support range.  Consequently
even a perfectly fibrewise calculation of their ordinary formal multiplicities
cannot establish the threefold carrier bound.

## 2. What the available categorical decompositions actually say

Kuznetsov's quadric-fibration theorem specializes for a flat conic fibration
\(q:V\to S\) to

\[
 D^b(V)=\left\langle D^b(S,\mathcal B_0),
 q^*D^b(S)\otimes\mathcal O_{V/S}(1)\right\rangle,               \tag{6}
\]

where \(\mathcal B_0\) is the even Clifford algebra.  The first term is not
the derived category of the base or of the discriminant curve.  For a conic
bundle over a smooth surface it is a rank-four quaternion order, generically
a central simple algebra and ramified on the discriminant.  This is the exact
noncommutative-surface datum lost by a ``base plus curve'' reduction.

If a future strict Gamma/Rees realization carries (6) to a primitive-sector
decomposition, (3) forces the primitive pair of the cubic conic model to occur
in the ramified Clifford term: the base term itself has zero primitive-sixth
support.  This is a conditional localization statement, not a currently proved
quantum/categorical comparison.

The favourable del Pezzo cases make a different obstruction visible.  For
quintic del Pezzo fibrations, Xie proves

\[
 D^b(V)=\left\langle D^b(C),D^b(C),D^b(Z_5)\right\rangle,         \tag{7}
\]

with \(Z_5\to C\) finite flat of degree five and base change compatibility.
For sextic del Pezzo fibrations, Kuznetsov proves

\[
 D^b(V)=\left\langle D^b(C),D^b(Z_2,\beta_2),
 D^b(Z_3,\beta_3)\right\rangle,                                 \tag{8}
\]

where the finite flat covers have degrees three and two and the indicated
Brauer classes have orders two and three.  These are ordered
semiorthogonal filtrations, not strict direct sums of Stokes/Rees objects.
They therefore permit two successive extension layers in the abstract
self-dual length-two model already recorded in
`2026-08-11-c907-threefold-grading-boundary.md`.

Equations (7)--(8) do not produce such a two-step Stokes extension, and they
also do not rule one out.  The finite covers can be ramified or nonreduced in a
degeneration, so the v1 theorem for a *smooth geometric centre* cannot simply
be applied to their twisted categories.  Degrees one through four (including
the cubic-surface fibration (4)) are not covered by these two decomposition
theorems.  Thus a count of semiorthogonal blocks is not a carrier proof.

## 3. Exact conditional target left by the regression

The conic and del Pezzo branches would close if one proved the following
strictly stronger relative statement.

> **Ramified Mori-fibre Rees target.**  There is a functorial sectorial
> \(1/6\)-Rees realization for terminal Mori fibrations, compatible with the
> relevant relative semiorthogonal/Clifford descriptions, such that:
>
> 1. for a conic fibration it identifies the primitive sector with the
>    ramified even-Clifford sector after deleting the zero primitive sector of
>    the base; and every terminal quaternion-order sector has Rees length at
>    most one;
> 2. for every del Pezzo fibration over a curve it identifies all relative
>    descent couplings in the primitive sector with an extension ideal \(I\)
>    satisfying \(I^2=0\), rather than merely an ordered semiorthogonal
>    filtration; and
> 3. the statements survive terminal relative MMP and a resolution comparison.
>
> Then every terminal conic-bundle or del Pezzo-fibration threefold has
> \(\ell_{1/6}\leq1\).

The word *strict* is load-bearing.  Additivity in \(K_0\), Hochschild
homology, or a semiorthogonal decomposition only controls associated graded
pieces.  The required inequality is precisely the assertion that their
sectorial Rees gluing cannot form a two-step primitive chain.

The cubic models calibrate the target sharply: the resulting ramified/descent
class must be allowed to be nonzero, but must square to zero.  Proving it zero
would contradict (3) and (5) already at the formal-support level.

## 4. Source audit

The four external sources below were fetched as primary PDFs, read at the
displayed theorem level, and cached with their exact bytes.

1. A. Kuznetsov, *Derived Categories of Quadric Fibrations and Intersections
   of Quadrics*, arXiv:math/0510670, Theorem 4.2: the flat quadric-fibration
   semiorthogonal decomposition used in (6).  SHA-256
   `75f1a74dc20a7af179a493565794b4a050243337e55d5a13a37d7b0eb131a9c1`.
2. D. Chan and C. Ingalls, *Conic bundles and Clifford algebras*,
   arXiv:1101.1705, pp. 1--2: a conic bundle over a smooth surface gives the
   rank-four even-Clifford/quaternion order used to interpret the first block
   of (6).  SHA-256
   `25d4ba34eff384c87a9c3331d275d00fcad764e10966f63e2822ff59a964dd4e`.
3. A. Kuznetsov, *Derived categories of families of sextic del Pezzo
   surfaces*, arXiv:1708.00522, Theorem 5.2 (announced on p. 2): (8).
   SHA-256 `5af701447ef01b415ea2bdfb458c32827a857170874b803eaeaa890d5af4c6f2`.
4. F. Xie, *Derived Categories of Quintic Del Pezzo Fibrations*,
   arXiv:1910.09238, Theorem 1.1: (7) and base-change compatibility.
   SHA-256 `980c5f3b8308ddf41f5fe87f17504df75c6eb4840fd518400baebda906ac3d74`.

No source among these asserts a quantum-D-module, irregular-Hodge, Stokes, or
Gamma realization of its semiorthogonal decomposition.  The report uses them
only for their categorical statements.

## 5. EJ/TT closeout and mystery ledger

**EJ.**  The free extraction is a concrete calibration problem: compute the
ramified even-Clifford Rees packet of the cubic-line conic bundle.  It must
recover one nonzero primitive pair and is the smallest test capable of
distinguishing a valid square-zero theorem from a false vanishing theorem.

**TT.**  The decisive question is not how many categorical blocks a Mori fibre
space has, but whether the *sectorial extension ideal* of its primitive
realization has square zero.  The three blocks in (7)--(8) are exactly why a
block-count argument cannot answer that question.

| mystery | status | exact remaining gate |
| --- | --- | --- |
| Why lower-dimensional fibration data can retain a cubic packet | settled formally by (3) and (5) | none |
| Which conic datum carries that packet | localized conditionally to the ramified Clifford sector | construct the strict Gamma/Rees realization of (6) |
| Can terminal ramification make a two-step primitive chain | open | prove the quaternion-order/descent \(I^2=0\) theorem or exhibit \(I^2\ne0\) |
| Del Pezzo degrees 1--4 and terminal-resolution comparison | open | a relative strict realization beyond the degree-5/6 categorical models |
