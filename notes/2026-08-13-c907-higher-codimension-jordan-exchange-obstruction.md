# C907 higher-codimension Jordan exchange obstruction

**Lane:** `clebsch`

**Status:** exact conditional incompatibility theorem separating Silver from
Gold.  If the endpoint projective rule and the relative-projective
Kronecker-sum rule are imposed, the ungraded nilpotent Jordan packet is
compatible with the codimension-two exchange used by `m=2`, but cannot also
satisfy the naive strict blowup biproduct in codimension at least three.  A
Gold theory retaining those projective rules must preserve additional graded
extension data among the exceptional Tate shifts.

## The geometric double presentation

Let `X` be a smooth cubic threefold, let `m>=2`, and let `p in P^m`.  Put

\[
 Y_m=\operatorname{Bl}_{X\times\{p\}}(X\times\mathbf P^m)
 \cong X\times\operatorname{Bl}_p\mathbf P^m.
 \tag{1}
\]

The center has codimension `m`.  The point blowup has the standard
projective-bundle presentation

\[
 \operatorname{Bl}_p\mathbf P^m
 \cong
 \mathbf P_{\mathbf P^{m-1}}
   (\mathcal O\oplus\mathcal O(1)),
 \tag{2}
\]

using the quotient convention; the line convention changes the sign of the
twist but not the projective bundle.  Thus `Y_m` has both a codimension-`m`
blowup ledger and a `P^1`-bundle ledger over `X x P^(m-1)`.

## The incompatible Jordan signatures

Normalize the chosen generalized \(\zeta _6\)-sector of the cubic packet as
\(J_1\) (with the conjugate sector treated separately and Tate shifts
preserving the chosen sector), and impose the projective endpoint rule

\[
 \mathscr J_6(X\times\mathbf P^d)=J_{d+1}.
 \tag{3}
\]

If the blowup formula is a direct sum of the individually shifted center
operators after forgetting Tate degrees, (1) gives

\[
 \mathscr J_6(Y_m)
 \cong J_{m+1}\oplus J_1^{\oplus(m-1)}.
 \tag{4}
\]

On the other hand, impose the additional, twist-insensitive
relative-projective Kronecker-sum operator on (2), with nonzero relative
\(J_2\) arrow.  Require also that the geometric isomorphism (1)--(2) induce an
\(N\)-linear comparison.  The projective-bundle ledger then gives

\[
 \mathscr J_6(Y_m)
 \cong J_m\otimes J_2.
 \tag{5}
\]

The characteristic-zero Jordan tensor rule yields

\[
 J_m\otimes J_2\cong J_{m+1}\oplus J_{m-1}.
 \tag{6}
\]

For `m=2`, equations (4) and (6) agree:

\[
 J_3\oplus J_1=J_2\otimes J_2.
 \tag{7}
\]

For every `m>=3`, they do not.  Krull--Schmidt uniqueness distinguishes

\[
 J_1^{\oplus(m-1)}\not\cong J_{m-1}.
 \tag{8}
\]

Both sides have dimension `2m`.  After placing the \(J_{m-1}\) string in the
interior Tate degrees, both have graded Hilbert function
\((1,2,\ldots,2,1)\); the disagreement is purely the nilpotent extension among
the exceptional copies.  This is therefore an operator-level obstruction
invisible to the Tate polynomial.

## Consequence for `m=2`

This conditional incompatibility does not damage Silver.  In a weak
factorization of the fivefold `X x P^2`, every center has dimension at most
three.  A center with
nonzero primitive-sixth packet must be a threefold and hence has codimension
two.  Higher-codimension centers have dimension at most two and zero packet.
Thus the only nonzero center contribution consumed by Silver is exactly the
lucky case `m=2` in (7).  The strict formula is still required on blowups with
zero center packet; there it asks for \(N\)-linear invariance of the ambient
packet.

Accordingly the minimal ungraded `K[N]` category remains a consistent
conditional target for `m=2`: its only nonzero center biproduct is in
codimension two, while its zero-center formulas are invariance statements.
Requiring a universal all-codimension direct-sum formula in that category
together with the projective rules above would be inconsistent.

## Consequence for Gold

For stabilization by `P^m` with `m>=3`, this family supplies nonzero cubic
centers in higher codimension; it does not classify all possible Gold
centers.  If Gold retains the endpoint and relative-projective rules above,
the exceptional shifts in this family must join into the `J_(m-1)` block seen
in (6).  It therefore cannot use the naive ungraded
formula

\[
 \mathscr J(\operatorname{Bl}_Z Y)
 \stackrel{?}{\cong}
 \mathscr J(Y)\oplus\bigoplus_jT^j\mathscr J(Z)
 \tag{9}
\]

after forgetting all extension data among the `T^j` terms.  It needs a richer
operation object in which:

1. the shifted center copies retain their absolute Tate grading;
2. a relative Lefschetz/Serre operator joins consecutive exceptional levels,
   replacing rather than merely decorating the naive strict biproduct;
3. the resulting center contribution has the correct projective tensor
   signature; and
4. exchange diagrams identify these joined blocks across presentations.

Equivalently, under those projective rules the Gold blowup term cannot remain
a direct sum of `J_1` copies in any category already remembering this \(N\):
an additive forgetful functor still sends the shifted direct sum to
\(J_1^{m-1}\), never to \(J_{m-1}\).  The natural repair is a non-split graded
exceptional-string functor whose relative \(N\)-arrows join consecutive Tate
levels and whose forgotten operator can be \(J_{r-1}\).  The other logical
option is to abandon or alter the proposed relative-projective operator; the
present data do not independently construct it.

This is a correction to the earlier all-codimension architecture, not merely
a warning.  Under the same candidate projective rule, the `F_1` computation
shows that codimension two admits the required biproduct, while (8) proves
that the same collapse is impossible in higher codimension.

## EJ/TT and mystery ledger

- **EJ:** under one uniform projective rule the first exchange calibration
  extends to a sharp dichotomy: codimension two gives the Silver identity;
  higher codimension forces an exceptional Jordan string or abandonment of
  that rule.
- **TT:** equal dimension, Tate polynomial, and formal direct sum conceal the
  difference between `J_1^(m-1)` and `J_(m-1)`.
- **Settled:** the candidate projective operator is algebraically compatible
  with Silver's only nonzero center codimension, but incompatible with the
  naive Gold all-codimension biproduct.
- **Open:** construct the graded exceptional-string operation and its strict
  all-codimension exchange law for Gold.
