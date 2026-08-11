# C904 exceptional degree five and matching-equivalence audit

**Date:** 2026-08-10
**Scope:** targeted primary-source audit; no manuscript, Lean, or commit change

## Executive verdict

### 1. Exceptional plane quintic

There is a useful intermediate answer, but not the strongest proposed one.

- **Yes, fixed-fibre and center-relative:** Beauville--Druel's geometry
  yields a uniform degree-five correspondence over the exceptional Fano
  center \(F_2\).  If \(A\) is the exceptional \(\mathbf P^2\)-bundle and
  \(B=\operatorname{Sym}^2F\) is the split boundary, then
  \(Z=A\cap B\) has generic fibre the plane-quintic discriminant.  With
  \(\xi=c_1(\mathcal O_A(1))\),
  \[
     \Gamma_5:=\xi\cdot[Z]
     \quad\text{satisfies}\quad
     p_*\Gamma_5=5[F_2].
  \]
  Thus this cycle exists before choosing Shen's \(\eta\) and uniformly gives
  a degree-five lift of cycles on the exceptional center.
- **No, in the strong sense needed for closure:** it is not a
  multiplication-by-five correspondence on all of \(D_+\), on \(J\), or on
  the generic \(M_9\) fibre.  Its pushforward is five times the **inclusion of
  the center**.  It cannot construct a horizontal minimal cycle, move one
  onto \(D_+\), or replace Shen's independent degree-two lift.  Operationally
  it kills the exceptional cokernel only after a class on \(D_+\) is present.

The cited sources prove the ingredients for a fixed cubic.  They do not state
the relative-family correspondence or a relative blow-up theorem.  That
relative statement is very plausible and noncircular via the universal conic
bundle, but it is a new lemma requiring flatness/Cartier and base-change
checks.

### 2. Two Fano-pair matchings

> **Superseded mathematical status.**  This section records the literature
> boundary only.  The subsequent theorem-grade calculation in
> `notes/2026-08-10-c904-matching-mumford-obstruction.md` proves that the two
> very general matchings are distinct in
> `CH_0(Sym^2 Theta)_Q`; vertical `D_{3,3}` fibres cannot join distinct
> `chi`-base points.  Thus the matching-halving route is now closed
> mathematically, not merely absent from the checked literature.

**No source-backed joining rational equivalence was found.**  Voisin proves
that a fibre of
\(D_{3,3}\to\operatorname{Sym}^2\Theta\) is birational to
\(\operatorname{Sym}^2E_3\).  She neither puts the two Fano-pair matchings in
one such fibre nor compares their Albanese coordinates.

Even if two points lie in the same \(\operatorname{Sym}^2E_3\), equality of
their image in \(J\) is insufficient: the entire fibre maps to one theta pair,
whereas rational equivalence of points on \(\operatorname{Sym}^2E_3\)
requires equality under the Abel map to \(\operatorname{Pic}^2(E_3)\simeq
E_3\).  Voisin supplies no such equality.  Hence the two-matching factor
cannot presently be divided in Chow by using the \(D_{3,3}\) fibre.

## 1. What Beauville and Druel print

For a fixed general line \(r\subset X\), Beauville Section 3.2,
extracted-text lines **293--305**, projects the blow-up \(X_r\) to the plane
of planes through \(r\).  He states:

- the residual fibres are conics;
- the discriminant \(\Delta_r\subset\mathbf P^2\) is a plane quintic;
- for general \(r\), its fibres are rank-two conics
  \(\ell+\ell'\), and the two components form an etale double cover of
  \(\Delta_r\).

Beauville Section 6, extracted lines **577--631**, states:

- the stable non-locally-free boundary \(A\) is parametrized by conics;
- the strictly semistable boundary
  \(B\) is parametrized by \(\operatorname{Sym}^2F\);
- the compactified charge-two moduli space is
  \(\operatorname{Bl}_{F_2}J_2(X)\);
- the restriction \(B\to F+F\) is the sum map and is generically
  one-to-one.

Druel Theorem 4.8 proves the blow-up result.  More relevantly for uniformity
over the center, Lemma 4.7 constructs over the whole Fano surface a rank-three
bundle \(Q\) whose projective bundle \(\mathbf P_F(Q)\) parametrizes planes
through the varying residual line, and a universal family of residual conics.
This is extracted-text lines **697--720**.

Neither paper states in one theorem that \(A\cap B\to F_2\) is the relative
plane-quintic discriminant.  That identification is the natural combination
of the two printed descriptions.  It is a project-specific deduction and
must be labelled as such.

## 2. The exact universal correspondence that follows

Let

\[
 c_2:M=\operatorname{Bl}_{F_2}J_2(X)\longrightarrow J_2(X)
\]

and let \(p:A=\mathbf P(N_{F_2/J_2})\to F_2\) be the exceptional divisor.
Because \(B\) is a divisor not containing \(A\),

\[
 Z=A\cap B
\]

is a Cartier divisor on \(A\).  Its generic fibre over \(F_2\) is the plane
quintic \(\Delta_r\), so its relative fibre degree is five.  Therefore, in
Chow,

\[
 p_*\bigl(\xi\cdot[Z]\bigr)=5[F_2],
 \qquad \xi=c_1(\mathcal O_A(1)).
\]

Viewing \(\xi[Z]\) inside \(F_2\times B\) gives a correspondence
\(\Gamma_5:F_2\rightsquigarrow B\) with

\[
 b_*\Gamma_5=5\Gamma_i,
\]

where \(i:F_2\hookrightarrow D_+=F+F\) and \(b:B\to D_+\).

This is genuinely universal **over the center**.  For a properly intersected
cycle \(C\) on \(F_2\), it gives a cycle upstairs pushing to \(5i_*C\).  It
does not depend on Shen's \(\eta\).

But the target identity is \(5\Gamma_i\), not
\(5\Delta_{D_+}\) and not \([5]\) on the Jacobian.  Consequently:

- it supplies no cycle on \(D_+\) in the first place;
- it cannot move an existing minimal cycle from \(J\) onto \(D_+\);
- it only acts on the part of a lift obstruction supported on \(F_2\);
- the Bezout argument still requires an independently available two-lift of
  the actual cycle.

Thus “merely killing the lift cokernel” understates its uniformity but states
its exact logical role correctly.

## 3. Relative-family status

For a smooth family of cubics with a relative line, the following construction
is available in principle without Shen:

1. blow up the universal line;
2. project to the relative \(\mathbf P^2\)-bundle of planes through it;
3. take the determinant discriminant of the relative conic bundle;
4. map each rank-two residual conic to its unordered pair of component lines;
5. intersect the relative quintic with the relative hyperplane class.

This would define a horizontal cycle \(\Gamma_{5,B}\) over the relative Fano
center with pushforward degree five.  The construction is algebraic and its
degree is stable under base change.

The exact source boundary is nevertheless:

- Beauville treats one fixed cubic and a general fixed line in the
  discriminant discussion;
- Druel treats one fixed cubic, though his \(\mathbf P_F(Q)\) varies the line;
- neither proves the relative blow-up identification over a family of
  cubics, identifies \(A\cap B\) scheme-theoretically after all base changes,
  or states flatness of the discriminant over the marked base.

Therefore a paper-facing relative correspondence needs a short proof of
those facts.  Once proved, it remains a center correspondence; it still does
not remove the need for a relative \(\eta\) or another horizontal minimal
cycle.

## 4. What Voisin's \(D_{3,3}\) fibre does and does not identify

Voisin extracted-text lines **497--513** constructs

\[
 \chi:D_{3,3}\longrightarrow\operatorname{Sym}^2\Theta.
\]

For a fixed unordered theta pair, the two rational cubics vary in two
\(\mathbf P^2\) linear systems and must meet in two points of an elliptic
curve \(E_3\).  She concludes that the fibre is birational to
\(\operatorname{Sym}^2E_3\).

Her Lemma 2.4 and proof, extracted lines **515--540**, use this geometry to
prove dominance over \(M_9\).  The proof explicitly exploits that these
second symmetric products of elliptic curves are not rational surfaces.  It
does not construct rational curves between arbitrary points in them.

For an elliptic curve, the Abel map

\[
 \operatorname{Sym}^2E_3\longrightarrow\operatorname{Pic}^2(E_3)simeq E_3
\]

has \(\mathbf P^1\) fibres.  Hence two points are rationally equivalent if
their degree-two divisors have the same Abel sum; their common image in the
ambient intermediate Jacobian does not imply this.  Indeed the whole
\(\chi\)-fibre already has constant theta-pair image while retaining its
nonconstant elliptic Albanese coordinate.

The two Fano-pair matchings

\[
 \{a-c,b-d\},\qquad \{a-d,b-c\}
\]

are two distinct points of a fibre of the **addition map**
\(\operatorname{Sym}^2\Theta\to J\).  They are generally two different base
points for \(\chi\), not two points already identified inside one printed
\(\operatorname{Sym}^2E_3\) fibre.  Voisin gives neither:

- a common \(E_3\) containing both lifts;
- equality of their Abel sums in that \(E_3\);
- a rational curve or rational equivalence joining them in the total
  \(D_{3,3}\to J\) fibre;
- a Chow relation dividing the canonical two-matching correspondence by two.

The nontrivial matching torsor rules out a rational selection of one matching,
but by itself does not rule out an accidental rational equivalence of the two
matching cycles.  Such an equivalence remains logically possible; it is a new
theorem, not an input available from Voisin.

## 5. Exact answers

1. **Universal relative odd five?**  Yes only over the exceptional Fano
   center, after proving the modest relative discriminant lemma.  No as a
   universal \([5]\)-identity on \(D_+\), \(J\), or \(M_9\).  Its exact role is
   to kill the center-supported lift cokernel uniformly.
2. **Rational equivalence of the two matchings?**  No theorem in Beauville,
   Druel, Voisin, or Voisin's cited rational-cubic input establishes one.
   The \(\operatorname{Sym}^2E_3\) description does not imply it.

## 6. Source ledger

1. **Arnaud Beauville, _Vector bundles on the cubic threefold_,
   arXiv:math/0005017.**  Read depth: **claim-specific partial**, Section 3.2
   and Section 6, especially Theorem 6.3, Corollary 6.4, and Remark 6.5.
   Cache SHA-256
   `18ff765599773594bd83494c44b15e1fdfa9bf40b56274675fde4d8cc655d57f`.
2. **Stephane Druel, _Espace des modules..._, arXiv:math/0002058.**  Read
   depth: **claim-specific partial**, Section 1.1, Lemma 4.7, and Theorem 4.8.
   Cache SHA-256
   `f9ce101a4ebdc9cdb139b37db7af36849c18505abc852aac078d72e32cbee654`.
3. **Claire Voisin, _Abel--Jacobi map, integral Hodge classes and
   decomposition of the diagonal_, arXiv:1005.5621.**  Read depth:
   **claim-specific partial**, the \(D_{3,3}\) construction and Lemma 2.4 with
   proof.  Cache SHA-256
   `ca7103f6529128a24425dbfc1c87589402b17b12719329239fccdb590f74b547`.
4. **Joe Harris, Mike Roth and Jason Starr, _Curves of small degree on cubic
   threefolds_, Rocky Mountain J. Math. 35 (2005), 761--817.**  Read depth:
   **indirect only in this pass**: Voisin cites it for the rational-cubic
   \(\mathbf P^2\)-fibration.  No claim from it is load-bearing beyond the
   statement Voisin reproduces.  It was not counted as read.

## 7. Mystery ledger

- **Settled:** the plane quintic gives a uniform fixed-fibre correspondence
  of degree five over \(F_2\), independent of \(\eta\).
- **Settled:** this correspondence represents \(5\) times the center
  inclusion, not \(5\) times the identity of \(D_+\).
- **Open but cheap:** prove the relative conic-discriminant/Cartier lemma and
  record \(p_*(\xi[Z])=5[F_{2,B}]\) under base change.
- **Open:** a horizontal relative minimal cycle on \(D_+\); the exceptional
  correspondence does not construct it.
- **Settled negatively as a literature input:** no rational equivalence
  joining the two Fano matchings is supplied by \(D_{3,3}\).
- **Settled negatively after this audit:** the later Mumford two-form
  calculation proves generic non-equivalence and closes the matching-halving
  route; see `notes/2026-08-10-c904-matching-mumford-obstruction.md`.

**Vibe:** the odd five is genuinely universal where it lives, but it lives on
the exceptional center.  It strengthens the cokernel-killing step without
turning it into a relative identity theorem.  The tempting matching
equivalence is now closed negatively by the subsequent calculation.
