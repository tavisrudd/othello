# C894 — EJ2 maximal golden order and series impact

**Lane:** `clebsch` · **Date:** 2026-08-08 · **Scope:** second-order
extraction from the C894 literature correction; no manuscript or Lean edits

## Verdict

The literature-driven identification of the local augmentation lattice with
the cyclotomic \(A_4\) module exposes one more integral halving.  The earlier
claim that the local tournament intrinsically reaches exactly the conductor-two
order \(\mathbb Z[\sqrt5]\) is too weak:

> The \(q=11\) local-Paley augmentation lattice naturally carries the **maximal
> golden order**
> \[
> \mathcal O_5=\mathbb Z\!\left[\frac{1+\sqrt5}{2}\right].
> \]

Moreover the lattice is free of rank two over \(\mathcal O_5\).  This creates
a precise comparison with the order-six conference carrier: its even lattice
\(D_6\) carries the same maximal order and has rank three over it.  Thus the
series bridge is not merely “the same quadratic field” or “the same
conductor-two suborder”; it is the rank pattern
\[
 A_4\cong\mathcal O_5^2,
 \qquad
 D_6\cong\mathcal O_5^3,
\]
with no canonical map between the two modules yet proved.

> **Open-problem update (2026-08-08).**  The subsequent report
> `notes/2026-08-08-c894-rooted-conference-completion-and-exact-sequence.md`
> constructs the missing map canonically once the matching edge is retained as
> a root.  It gives
> \(0\to A_4\to D_6\to\mathcal O_5\to0\), with orthogonal gluing index five.
> Every “no canonical map yet” statement below is superseded at the rooted
> level; only the unrooted/projective marking identification remains open.

This strengthens exposition but is still classical fifth-cyclotomic lattice
arithmetic, not a new headline for C894.

## 1. The missing integral halving

Let \(R\) be the cyclic shift in a directed-pentagon ordering.  On
\[
 L=A_4=\{x\in\mathbb Z^5:\textstyle\sum_i x_i=0\}
\]
we have
\[
 I+R+R^2+R^3+R^4=0,
 \qquad
 B=R+R^2-R^3-R^4.
\]
The first-order endpoint operator is
\[
 \mathcal J=\frac{B^2+5I}{2}
            =-R+R^2+R^3-R^4,
 \qquad \mathcal J^2=5I.                              \tag{1}
\]
Using the augmentation relation once more gives
\[
 \mathcal J-I=2R^2+2R^3.                              \tag{2}
\]
Hence \(\mathcal J\equiv I\pmod2\) on \(L\), and therefore
\[
 \Phi=\frac{I+\mathcal J}{2}
      =\frac{B^2+7I}{4}
      =-(R+R^4)                                        \tag{3}
\]
is an integral endomorphism of \(L\).  Since
\(R+R^{-1}\) satisfies \(X^2+X-1\) on the nontrivial fifth-root
constituent, equation (3) gives
\[
 \Phi^2-\Phi-I=0.                                     \tag{4}
\]
Thus \(T\mapsto\Phi\) defines an action of
\[
 \mathbb Z[T]/(T^2-T-1)
 \cong\mathcal O_{\mathbb Q(\sqrt5)},
\]
the maximal order.  The operator is a unimodular lattice endomorphism, with
inverse \(\Phi-I\); it is not asserted to be an isometry.

The earlier parity proof of integrality for \(\mathcal J\) remains correct.
Its interpretation as the *final* integral order was the defect: equation (2)
permits one further halving.

## 2. Free rank two over the maximal order

Map a sum-zero vector \((a_0,\ldots,a_4)\) to
\(\sum_i a_i\zeta_5^i\).  This identifies
\[
 L\cong(1-\zeta_5)\mathbb Z[\zeta_5].                 \tag{5}
\]
Indeed the sum-zero condition makes the representing polynomial divisible by
\(X-1\), and the only rational relation among
\(1,\zeta_5,\ldots,\zeta_5^4\) is their total sum.

Now
\(\mathbb Z[\zeta_5]\) is free of rank two over its maximal real subring
\(\mathcal O_5\), and multiplication by \(1-\zeta_5\) is an
\(\mathcal O_5\)-linear isomorphism onto the ideal in (5).  Consequently
\[
 L\cong\mathcal O_5^2.                                \tag{6}
\]
A direct integral check is also short: for the usual basis
\(a_i=e_i-e_4\), the four vectors
\[
 a_0,\ \Phi a_0,\ a_1,\ \Phi a_1
\]
have determinant \(-1\), so \(a_0,a_1\) are an
\(\mathcal O_5\)-basis.

## 3. The complete conductor ladder

For one primitive eigenvalue square \(\theta=\beta^2=-5\pm2\sqrt5\), the
three normalizations now form an exact ladder:
\[
\begin{array}{ccl}
\mathbb Z[\theta]=\mathbb Z[2\sqrt5]
  &:& \text{conductor }4,\\
\mathbb Z[(\theta+5)/2]=\mathbb Z[\sqrt5]
  &:& \text{conductor }2,\\
\mathbb Z[(\theta+7)/4]
  =\mathbb Z[(1\pm\sqrt5)/2]
  &:& \text{conductor }1.
\end{array}                                             \tag{7}
\]
The first halving is the tournament parity observed in TT2.  The second is
the augmentation/cyclotomic relation.  Equation (7) is the clean endpoint
story; none of its three rows should carry a novelty adjective.

## 4. Uniform bridge to the order-six conference carrier

Let \(C\) be any symmetric order-six conference sign matrix with
\(C^2=5I\), and put
\[
 D_6=\{x\in\mathbb Z^6:\textstyle\sum_i x_i\equiv0\pmod2\}.
\]
Modulo two, \(C\equiv E-I\), where \(E\) is the all-ones matrix.  Therefore
\[
 (I+C)x\equiv Ex=0\pmod2 \qquad(x\in D_6),
\]
and \(C\) preserves \(D_6\).  Hence
\[
 \Phi_C=\frac{I+C}{2}\in\operatorname{End}_{\mathbb Z}(D_6),
 \qquad
 \Phi_C^2-\Phi_C-I=0.                                 \tag{8}
\]
Thus \(D_6\) is a rank-three \(\mathcal O_5\)-module.  Since
\(\mathcal O_5\) has class number one, it is free.  This needs no substantial
number-theory input: the real-quadratic Minkowski bound is
\(\sqrt5/2<2\), so every ideal class contains an integral ideal of norm one.
Consequently
\[
 D_6\cong\mathcal O_5^3.                              \tag{9}
\]

Equations (6) and (9) are the exact cross-series connection.  They do not
construct an \(\mathcal O_5\)-linear embedding, quotient, or orthogonal
decomposition relating the marked local pentagon to the marked conference
hexagon.  Such a map would be genuinely additional content.

## 5. Updated impacts and connections

| paper / stream | updated connection | impact decision |
|---|---|---|
| Clebsch Paper I, `clebsch-rigidity` | Fixing a matching edge leaves the local directed pentagon; its augmentation lattice is canonically the cyclotomic \(A_4\) module \(\mathcal O_5^2\).  This is a sharper arithmetic shadow of the hexagon's golden orientation. | No proof or correction is needed.  A future forward version may cite C894 for the local \(\mathcal O_5^2\) carrier, but it must not say this recovers the full \(A_5\)-action. |
| Clebsch Paper II, `clebsch-factorization` | The unbordered local Paley carrier underlying the matching picture has a maximal-order integral structure, not merely a golden field or conductor-two action. | The Gorenstein, trade, matching, and factorization arguments are unchanged.  A future remark can identify the local augmentation piece as \(\mathcal O_5^2\). |
| Clebsch Paper III, `clebsch-passages` | Its order-six conference operator gives \(D_6\cong\mathcal O_5^3\) by the same parity mechanism.  The exact common object with C894 is now the maximal golden order, with ranks \(2\) and \(3\). | Strongest new connection.  Existing proofs are unaffected.  Any prose saying the local object carries *exactly* only the conductor-two order would be wrong; no such C894 prose exists.  A direct \(A_4\leftrightarrow D_6\) map remains unproved. |
| Golden source-development stream / future Paper III version | The local endpoint supplies a second intrinsic maximal-order module and a clean comparison target \(\mathcal O_5^2\) versus \(\mathcal O_5^3\). | High-value future check: determine whether the marked conference lattice used there is exactly the even lattice \(D_6\), and whether its marking selects a canonical rank-two submodule or quotient.  Do not infer one from ranks alone. |
| Clebsch Paper IV, `q13-passant-code` | No direct specialization: \(13\equiv1\pmod4\), so the local tournament and fifth-cyclotomic module do not occur. | No impact beyond a broad analogy between small integral carriers and reconstruction. |
| C894 companion itself | The endpoint becomes shorter and stronger: \(\Phi=(B^2+7I)/4\) is the canonical maximal-order operator, while \(\mathcal J\) is only the intermediate conductor-two stage. | Use at most one proposition/remark after the main local theorem.  The result remains explanatory and attributed, not a third headline. |

## 6. EJ2 decision

The free upgrade is to replace the endpoint's “conductor-two” wording by the
maximal-order statement and show the three-step conductor ladder.  The
cross-series \(\mathcal O_5^2\)/\(\mathcal O_5^3\) comparison is worth
recording now, but a canonical map is not cheap and must not widen C894.

## Propagation checklist

- **Owning C894 card:** corrected from conductor two to the maximal order.
- **Live queue and Clebsch handoff:** corrected and given the rank-two/rank-three
  comparison.
- **TT2 extraction report:** carries an explicit strength correction; its
  original parity proof remains valid for the intermediate operator.
- **Cyclotomic/golden literature report:** endpoint verdict and mystery row
  strengthened.
- **Manuscripts and public summaries:** C894 has none, and none of Papers
  I--IV states the superseded C894 conductor-two endpoint, so no paper edit is
  owed.
- **Golden source-development stream:** read-only impact recorded here; no
  foreign-lane file was changed.  Its actual marked conference lattice must be
  inspected before promoting a canonical module comparison.

## Mystery ledger

| feature | status | exact remaining gate |
|---|---|---|
| Does the local carrier stop at \(\mathbb Z[\sqrt5]\)? | settled negative | equation (3) gives the maximal order |
| What is the local module over the maximal order? | settled | \(A_4\cong\mathcal O_5^2\) |
| Why were there two successive halvings? | settled | tournament parity, then the augmentation cyclotomic relation |
| Does the order-six conference carrier support the same maximal order? | settled on its even lattice | equation (8), giving \(D_6\cong\mathcal O_5^3\) |
| Is there a canonical marked map \(A_4\to D_6\)? | settled positive after retaining the matching edge as root | coordinate inclusion in the rooted exact sequence; only the unrooted projective marking remains open |
| Does this restore a novelty claim for the endpoint? | settled negative | it is standard fifth-cyclotomic lattice arithmetic |

## Next action

Use the maximal-order version in the C894 claim--proof--citation matrix.  Keep
the possible marked \(\mathcal O_5^2\)-to-\(\mathcal O_5^3\) comparison outside
C894 unless separately allocated after inspection of the golden stream's
actual integral lattice.
