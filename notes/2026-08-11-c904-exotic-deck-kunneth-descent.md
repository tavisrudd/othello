# C904: exotic-deck descent on the mixed Kunneth residuals

Date: 2026-08-11

Status: theorem-grade mod-two monodromy calculation and exact Chow-descent
boundary; Paper V research only; no manuscript or Lean change

## Verdict

The exotic deck involution has genuinely different effects on the two live
mixed Kunneth channels.

Let \(g\) be the residual order-three monodromy and \(s\) the exotic deck.
On \(H^1(-,\mathbf F_2)\),

\[
 g^3=s^2=1,\qquad sgs=g^{-1},
\]

so together they generate \(S_3\).  Inducing this exact action through the
two Lefschetz cokernels and testing the actual top-wedge degree pairings
gives

\[
\begin{array}{c|c|c|c}
\text{channel}&\dim(-)^{C_3}&\dim(-)^{S_3}
 &\text{odd degree in }(-)^{S_3}\?\\ \hline
p_{15}&50&25&\textbf{no}\\
p_{24}&776&396&\textbf{yes}.
\end{array}                                                \tag{0.1}
\]

Consequently:

1. a horizontal class descending through the unmarked exotic deck cannot
   have odd degree coming solely from the \((1,5)\) residual;
2. the deck does **not** prove relative index two, because invariant odd
   \((2,4)\) residual cohomology survives;
3. invariant cohomology is only a necessary condition for algebraic or Chow
   descent, so the surviving \((2,4)\) classes are not constructed cycles;
   and
4. the exotic quadratic cover is parity-minimal only conditionally: one
   still needs an actual odd cycle upstairs and an even-index theorem
   downstairs.

This supersedes the provisional statement that the exotic deck can only be
located abstractly in a Chow Tate quotient.  It gives a real cohomological
obstruction in \(p_{15}\), but no obstruction in \(p_{24}\).

## 1. The exact deck module

Write

\[
 \Lambda_2=H^1(J,\mathbf F_2).
\]

The marked residual \(C_3\) acts as five copies of

\[
 g_0=\begin{pmatrix}1&1\\1&0\end{pmatrix}.
\]

The exotic outer element conjugates \(\omega\) to \(\omega^2\).  On one
two-dimensional block it may therefore be represented by

\[
 s_0=\begin{pmatrix}0&1\\1&0\end{pmatrix},
 \qquad s_0g_0s_0=g_0^2.                                  \tag{1.1}
\]

The literal five-axis deck also has a multiplicity-space factor.  This does
not change the calculation.  Identifying a \(C_3\)-block with
\(\mathbf F_4\), an arbitrary deck is semilinear,

\[
                  x\longmapsto A\bar x,
 \qquad A\bar A=1.
\]

Finite-field Hilbert 90 conjugates it by an
\(\mathbf F_4\)-linear basis change to coordinatewise Frobenius.  All
Lefschetz maps, quotient lattices and top-wedge pairings are functorial
under that basis change.  Hence the block model (1.1) computes the actual
fixed dimensions and parity, independently of the chosen marked principal
basis.

The theta bivector is fixed by both \(g\) and \(s\), so the actions descend
to

\[
\begin{split}
 Q_{15}&=\operatorname {coker}
 (L:\bigwedge^5\Lambda_2\to\bigwedge^7\Lambda_2),\\
 U_{24}&=L\bigwedge^2\Lambda_2\subset\bigwedge^4\Lambda_2,\\
 Q_{24}&=\operatorname {coker}
 (L:\bigwedge^4\Lambda_2\to\bigwedge^6\Lambda_2).
\end{split}                                                \tag{1.2}
\]

The exact degree pairings are

\[
\begin{split}
 P_{15}:\Lambda_2\times Q_{15}&\longrightarrow\mathbf F_2,
 &P_{15}(a,[b])&=\int_J\Theta\,a\,b,\\
 P_{24}:U_{24}\times Q_{24}&\longrightarrow\mathbf F_2,
 &P_{24}(u,[v])&=\int_Ju\,v.
\end{split}                                                \tag{1.3}
\]

They are well-defined because \(L^2=0\) modulo two, have ranks ten and
forty-four, and are invariant under both generators.

## 2. The p15 obstruction

For \(C_3\) alone, the two factors are each five copies of the irreducible
two-dimensional module.  Their invariant tensor space has dimension fifty,
and \(P_{15}\) is nonzero there.  This recovers the earlier result that the
residual cubic monodromy alone does not force evenness.

Adding the exotic deck cuts the invariant tensor space to dimension
twenty-five.  More importantly,

\[
 P_{15}\bigm|
 (\Lambda_2\otimes Q_{15})^{S_3}=0.                       \tag{2.1}
\]

There is a conceptual explanation.  Over \(\mathbf F_4\), the
\(C_3\)-invariant tensor space is an \(\mathbf F_2\)-form of
\(M_5(\mathbf F_4)\), and the deck is the Frobenius real structure, up to
the possibly different semilinear changes of basis on the two paired
factors.  Its fixed form has dimension twenty-five over \(\mathbf F_2\).
The degree functional is the Frobenius-invariant absolute-trace functional.
It vanishes on that fixed form.  Equivalently, every odd sheetwise class is
exchanged with a second odd class and their invariant sum has even degree.

This also resolves a terminology trap in the earlier \(C_3\) note.  The
sheetwise odd witness was called the coefficient identity after choosing
one exotic \(\mathbf F_4\) orientation.  That label is not compatible with
the integral identification of the conjugate sheet.  The rational
inverse-Lefschetz operator is canonical, but its unresolved integral
dyadic lift is exactly what changes under the deck.  There is therefore no
contradiction between rational deck invariance and (2.1).

### Relative consequence

A cycle defined over the unmarked base gives a flat integral class fixed by
both the residual monodromy and the deck.  Its \(p_{15}\) residue belongs to
the left side of (2.1), hence has even addition degree.  This is an actual
cohomological no-go for a horizontal odd \(p_{15}\) escape.

It does not forbid a fixed-fibre algebraic \(p_{15}\) class on one marked
sheet.  Such a class, if it exists, cannot descend with odd \(p_{15}\)
degree through the exotic deck.

## 3. The p24 survivor

The same exact calculation gives

\[
 \dim(U_{24}\otimes Q_{24})^{C_3}=776,
 \qquad
 \dim(U_{24}\otimes Q_{24})^{S_3}=396.                    \tag{3.1}
\]

Unlike (2.1),

\[
 P_{24}\bigm|
 (U_{24}\otimes Q_{24})^{S_3}\ne0.                       \tag{3.2}
\]

Thus the full exotic monodromy still admits odd integral cohomology
residues in the \((2,4)\) channel.  Equation (3.2) is only a lattice-level
statement.  It does not show that any such class is Hodge, algebraic, or the
Kunneth component of a horizontal integral Chow cycle.  It proves exactly
that the deck action cannot be the missing parity argument.

The surviving gate is consequently narrower than before:

> intersect the 396-dimensional invariant cohomology space with the image
> of horizontal integral algebraic correspondences, or prove that every
> odd member fails integral-at-two Chow--Kunneth extraction.

No ambient, residual-\(C_3\), or Brauer argument is revived here.

## 4. Restriction, corestriction and actual Chow descent

Let \(L/K\) be the exotic quadratic extension, let \(G=\langle s\rangle\),
and let \(Y/K\) be the proper generic variety in the cycle problem.  Put

\[
 A=CH^3(Y_L),\qquad
 R=\operatorname {im}\bigl(CH^3(Y)\xrightarrow{\mathrm {res}}A\bigr).
\]

Then

\[
 \mathrm {cor}\,\mathrm {res}=2,
 \qquad
 \mathrm {res}\,\mathrm {cor}=1+s.                       \tag{4.1}
\]

In particular

\[
 (1+s)A\subset R\subset A^G.                              \tag{4.2}
\]

There are two different quotients:

\[
 \widehat H^0(G,A)=A^G/(1+s)A
 \twoheadrightarrow A^G/R.                               \tag{4.3}
\]

The left group measures failure to be a **norm**.  The right group measures
failure of a Chow class to be a **restriction**.  They are not equal in
general.  A class can descend and still have nonzero Tate class because it
need not itself be a norm.  Both quotients are killed by two, since for
\(z\in A^G\),

\[
                   2z=(1+s)z=\mathrm {res}\,\mathrm {cor}(z).
\]

Thus the Tate quotient is an upper bound on the class-descent obstruction,
not an exact replacement for it.  This corrects the loose phrase “the Tate
class is the Chow descent obstruction.”

Cycle-class realization gives only necessary tests:

- a descended Chow class has invariant cohomology;
- a non-invariant cohomology class cannot be repaired by a homologically
  trivial Chow correction;
- an invariant algebraic cohomology class need not have an invariant Chow
  representative; and
- even an invariant Chow class need not lie in \(R\).

Therefore (2.1) is decisive for the \(p_{15}\) contribution, while (3.2)
leaves both algebraization and class descent open.

## 5. What “minimal quadratic base change” honestly means

For every proper \(Y/K\),

\[
 \operatorname {ind}(Y_L)\mid\operatorname {ind}(Y),
 \qquad
 \operatorname {ind}(Y)\mid2\operatorname {ind}(Y_L).     \tag{5.1}
\]

Across an odd-degree extension the two-adic valuations of the two indices
are equal, by restriction--corestriction.  Hence an extension that changes
a genuine parity obstruction must have even degree, and a quadratic
extension is the first possible degree.

But “parity-minimal candidate” is not “proved minimal splitting field.”  To
prove that the exotic cover is exactly minimal one needs both:

1. an actual odd-degree zero-cycle or complete half relation over \(L\);
   and
2. a proof that no odd-degree zero-cycle exists over \(K\).

The present deck theorem supplies neither globally.  It supplies item 2
only for the isolated \(p_{15}\) contribution.  The invariant odd
\(p_{24}\) classes in (3.2), as well as the axis/Chow channels, prevent an
index conclusion.

## 6. Exact certificate

The deterministic Sage script
`notes/2026-08-11-c904-exotic-deck-kunneth-residuals.sage` constructs:

1. \(g\) and \(s\) on the rank-ten symplectic space;
2. every required exterior-power action;
3. the quotient actions on \(Q_{15}\) and \(Q_{24}\);
4. the subspace action on \(U_{24}\);
5. both perfect top-wedge pairings; and
6. the simultaneous fixed spaces and restrictions of the degree
   functionals.

Replay from the repository root without preparsed debris:

```sh
nix shell nixpkgs#sage -c sh -lc \
  'sage --nodotsage -c \
   "exec(preparse(open(\"notes/2026-08-11-c904-exotic-deck-kunneth-residuals.sage\").read()))" \
   > /tmp/c904-exotic-deck-kunneth-residuals.replay && \
   cmp /tmp/c904-exotic-deck-kunneth-residuals.replay \
       notes/2026-08-11-c904-exotic-deck-kunneth-residuals.out'
```

The script checks equivariance and perfection before computing invariants.
It uses no random choices.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-08-11-c904-exotic-deck-kunneth-residuals.sage` | 6685 | `6962cb3c1c75494a380b7b61372429dcfa05e836047862c56a4ea13a05984f73` |
| `2026-08-11-c904-exotic-deck-kunneth-residuals.out` | 281 | `d0953067a91ab7f425c0e44feb4e1d5fd9f4bd9e0b4b01c161f09e0100456c9f` |

The sizes were measured before this report was written.  The source hashes
are the load-bearing identifiers.

## 7. Source boundary

The integral symmetric-square transfer lattice and the two residual
Lefschetz quotients are the already audited inputs from A. Gugnin, *On
integral cohomology ring of symmetric products*, arXiv:1502.01862, Theorem
1 (Nakaoka's theorem), together with the committed full-Kunneth C904
certificate.  The literal exotic deck and its conjugation
\(\omega\leftrightarrow\omega^2\) are proved by the committed principal
lattice certificate
`notes/2026-08-10-c904-relative-divisor-generation.sage`.

No new literature or priority claim is made.  This note derives the
combined deck action and descent consequences from those exact inputs.

## Mystery ledger

- **Settled:** full exotic monodromy kills odd \(p_{15}\) residual degree.
- **Settled:** full exotic monodromy does not kill odd \(p_{24}\) residual
  degree.
- **Settled:** norm Tate cohomology surjects onto, but need not equal, the
  actual Chow class-descent cokernel.
- **Settled:** a quadratic cover is only parity-minimal conditionally, not a
  proved minimal splitting field.
- **Open:** algebraic/Hodge realization of an odd full-monodromy
  \(p_{24}\) class.
- **Open:** whether any such algebraic class lies in the restriction image
  from the unmarked base.
- **Open:** an actual odd cycle upstairs; the deck calculation alone
  constructs none.
