# C904: exotic-deck descent on the mixed Kunneth residuals

Date: 2026-08-11

Status: theorem-grade mod-two monodromy calculation and exact Chow-descent
boundary; Paper V research only; no manuscript or Lean change

## Verdict

The exotic deck involution does **not** supply the hoped-for parity
obstruction in either live mixed Kunneth channel.

Let \(g\) be the residual order-three monodromy and \(s\) the exotic deck.
On \(H^1(-,\mathbf F_2)\),

\[
 g^3=s^2=1,\qquad sgs=g^{-1},
\]

so together they generate \(S_3\).  Inducing this exact action through the
two Lefschetz cokernels gives

\[
\begin{array}{c|c|c|c}
\text{channel}&\dim(-)^{C_3}&\dim(-)^{S_3}
 &\text{odd degree in }(-)^{S_3}\?\\ \hline
p_{15}&50&25&\textbf{yes}\\
p_{24}&776&396&\textbf{yes}.
\end{array}                                                \tag{0.1}
\]

Consequently:

1. the polarization-canonical coefficient identity is fixed by the full
   deck group and has odd unordered \((1,5)\) degree;
2. invariant odd \((2,4)\) residual cohomology also survives;
3. invariant cohomology is only a necessary condition for algebraic or Chow
   descent, so neither survivor is a constructed integral algebraic cycle;
   and
4. the exotic quadratic cover is parity-minimal only conditionally: one
   still needs an actual odd cycle upstairs and an even-index theorem
   downstairs.

The raw mod-two top-wedge contraction vanishes on the full-deck
\(p_{15}\) fixed space, but that is the **ordered** trace.  Symmetric-square
descent divides the integral ordered trace by two, and its parity is the
five-dimensional coefficient trace.  Confusing these functionals produces
a false \(p_{15}\) no-go.

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

## 2. The p15 survivor and the divided-trace correction

For \(C_3\) alone, the two factors are each five copies of the irreducible
two-dimensional module.  Their invariant tensor space has dimension fifty,
and \(P_{15}\) is nonzero there.  This recovers the earlier result that the
residual cubic monodromy alone does not force evenness.

Adding the exotic deck cuts the invariant tensor space to dimension
twenty-five.  The raw mod-two top-wedge contraction does vanish there:

\[
 \overline P_{15}^{\rm ord}\bigm|
 (\Lambda_2\otimes Q_{15})^{S_3}=0.                       \tag{2.1}
\]

Equation (2.1) is not the unordered degree.  Via the perfect pairing, a
full-deck invariant tensor is an endomorphism of
\(V^5\), where \(V\) is the natural two-dimensional \(S_3\)-module.  Hence

\[
 (\Lambda_2\otimes Q_{15})^{S_3}
       \simeq \operatorname {End}_{S_3}(V^5)
       \simeq M_5(\mathbf F_2).                           \tag{2.2}
\]

The ordered trace on the rank-ten lattice is twice the coefficient trace.
After passage to the symmetric quotient the actual degree is therefore

\[
 \delta_{15}^{\rm sym}(A)=\operatorname {tr}_{5}(A)\pmod2. \tag{2.3}
\]

In particular the identity is fixed by every semilinear deck
normalization and

\[
                 \delta_{15}^{\rm sym}(I_5)=5=1\pmod2.    \tag{2.4}
\]

This is also the basis-free check on the computation: the rational
inverse-Lefschetz identity is polarization-canonical, so a purported deck
calculation that removes it has reduced the ordered trace before dividing
by two.

### Relative consequence

A cycle defined over the unmarked base gives a flat integral class fixed by
both the residual monodromy and the deck, but the full fixed space already
contains the odd identity (2.4).  Deck invariance therefore gives no
cohomological parity obstruction in \(p_{15}\).  The unresolved question is
whether this residual coset has a deck-compatible integral algebraic lift;
the calculation neither constructs nor obstructs one.

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

Thus both (2.4) and (3.2) are necessary-condition survivors only.  They
leave algebraization and class descent open.

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

The present deck theorem supplies neither.  The invariant odd \(p_{15}\)
identity, the odd \(p_{24}\) classes in (3.2), and the axis/Chow channels
all prevent an index conclusion.

## 6. Exact certificate

The deterministic Sage script
`notes/2026-08-11-c904-exotic-deck-kunneth-residuals.sage` constructs:

1. \(g\) and \(s\) on the rank-ten symplectic space;
2. every required exterior-power action;
3. the quotient actions on \(Q_{15}\) and \(Q_{24}\);
4. the subspace action on \(U_{24}\);
5. both perfect top-wedge pairings; and
6. the simultaneous fixed spaces, the raw ordered contractions, and the
   divided \(p_{15}\) coefficient-trace functional.

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
It uses no random choices.  The independent conceptual check is the
polarization-canonical identity: it is fixed by semilinear conjugation (or
conjugate transpose), while its divided coefficient trace is
\(\operatorname {tr}(I_5)=5\).  This check is recorded separately in
`notes/2026-08-11-c904-exotic-deck-final-move-red-team.md` and detects the
ordered-before-dividing normalization error.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `2026-08-11-c904-exotic-deck-kunneth-residuals.sage` | 10945 | `c609897ccd3ee693f4096f6286d3c11a3f3e22fe315dd223891c136541c1a8ea` |
| `2026-08-11-c904-exotic-deck-kunneth-residuals.out` | 502 | `ebba140ff87d9340024c08c66b4fbdb4e719882f5a9ad0ba660a51e386bc3580` |

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

- **Settled:** full exotic monodromy preserves the odd divided-degree
  \(p_{15}\) identity; the vanishing raw contraction is the wrong
  ordered-trace functional.
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

## Correction (2026-08-11, C908 normalization adjudication)

The body above is left as written as a dated record.  Its divided-degree
normalization is **superseded**, and the reversal upgrades this note's own
computation into an obstruction.

- **§2, equations (2.3)--(2.4)**, "The ordered trace on the rank-ten lattice is
  twice the coefficient trace.  After passage to the symmetric quotient the
  actual degree is therefore \(\delta_{15}^{\rm
  sym}(A)=\operatorname {tr}_5(A)\pmod 2\)", and hence
  \(\delta_{15}^{\rm sym}(I_5)=5=1\).  The divided interpretation is the
  defect.  The \(\tfrac12\) of \(\lambda(Z)=\tfrac12(1,\iota)^*\Gamma\) is
  consumed exactly once, cancelling the transfer generator's factor two, and
  the anti-graph factor is \(\pm2\) in every channel; no second halving exists.
  The **raw \(\mathbf F_2\)-linear contraction is the unordered degree**, so
  \(\delta_{15}^{\rm sym}=\operatorname {tr}_{\mathbf F_2}
  =\operatorname {Tr}_{\mathbf F_4/\mathbf F_2}\circ\operatorname {tr}_{\mathbf F_4}\),
  which vanishes identically on \(\operatorname {End}_{S_3}(V^5)\cong
  M_5(\mathbf F_2)\).  The identity is **even**.
- **Mystery ledger**, "full exotic monodromy preserves the odd divided-degree
  \(p_{15}\) identity; the vanishing raw contraction is the wrong ordered-trace
  functional".  Reversed.  The vanishing raw contraction is the **right**
  functional, and the full-\(S_3\)-fixed \(p_{15}\) space of dimension 25
  contains **no** odd contraction.
- **§2 "Relative consequence"** is therefore the load-bearing sentence, with its
  conclusion flipped.  Its hypothesis stands verbatim — "a cycle defined over
  the unmarked base gives a flat integral class fixed by both the residual
  monodromy and the deck" — but the fixed space does **not** contain an odd
  class, so deck invariance **does** give a cohomological parity obstruction in
  \(p_{15}\): no class defined over the unmarked base can carry odd \((1,5)\)
  degree.  The basis-free check quoted after (2.4) fails with it: the rational
  inverse-Lefschetz identity is polarization-canonical but its unordered degree
  is even, so its presence in the fixed space is not evidence of odd degree.
- **Scope.**  \(p_{24}\) is unchanged (odd \(S_3\)-fixed contractions exist, by
  this note's own (3.2)), and the residual \(C_3\)-only \((1,5)\) conclusions
  are unchanged.  The obstruction binds only over the unmarked base; the marked
  exotic base forces \(C_3\) alone, where odd residues survive as the
  \(w\)-twisted cosets with \(\mathbf F_4\)-coefficient trace outside
  \(\mathbf F_2\).

Adjudicating bundle:
`notes/2026-08-11-c908-unordered-degree-normalization.md` (§2 invariants equal
transfers with index one in bidegree \((1,5)\); §3 the uniform \(\pm2\)
anti-graph factor; §4 the independent \((0,6)\) calibration
\(\int_J\Theta\cdot\Theta^4/4!=5\); §§5--7 the ruling, its per-channel
consequences, and the flag list this correction discharges).
