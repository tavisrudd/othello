# C907 threefold grading boundary

**Lane:** `clebsch`

**Verdict:** the direct dimension-three grading route does not prove the
carrier bound `ell_(1/6)<=1`.

## Exact countermodel to the proposed formal inputs

Let

\[
 H^{2i}=\mathbf C e_i\quad(0\le i\le3),
 \qquad Le_i=e_{i+1},
\]

with the usual convention at the top.  Give it the Poincare pairing

\[
 Q(e_0,e_3)=Q(e_1,e_2)=1
\]

and formal monodromy

\[
 M_{\rm f}=\operatorname{diag}
 (\zeta_6,\zeta_6,\zeta_6^{-1},\zeta_6^{-1}).
\]

Define

\[
 Ne_0=e_1,qquad Ne_2=-e_3,qquad N^2=0.
\]

Then `L` satisfies hard Lefschetz, `M_f` preserves `Q`, and `N` commutes with
`M_f` and is `Q`-skew.  The primitive-sixth part nevertheless contains two
length-two `N`-chains.  Thus cohomological amplitude three, hard Lefschetz,
Poincare duality, self-duality, and the formal HLT exponent set are compatible
with

\[
 \ell_{1/6}=2.
\]

Making `L` control `N` would add precisely the compatibility that is absent:
Cai's zero-exponential piece is a local Stokes grade, not a global
`L`-stable submodule.

## The missing geometric class

The minimal possible obstruction is a self-dual sectorial Rees extension

\[
 0\longrightarrow
 (V_{1/6}\oplus V_{-1/6})(1)
 \longrightarrow\mathcal R_e\longrightarrow
 V_{1/6}\oplus V_{-1/6}\longrightarrow0,
 \tag{1}
\]

with `e != 0` and the two dual extension classes paired with opposite signs.
Formal HLT records only the two graded factors and cannot detect `e`.  The
nonzero locus of (1) is the exact candidate length-two locus among smooth
threefolds.

No smooth geometric realization of (1) is currently known.  The first
uncontrolled class is a non-nef threefold not obtained by lower-dimensional
projective bundles and blowups.

## Calibrations

Conditional on a strict operation-framed enhancement:

- a `P^1`-bundle over a surface and a `P^2`-bundle over a curve have empty
  primitive-sixth support;
- blowing up a threefold in a curve adds only a shifted curve packet;
- blowing up a point adds only shifted point packets; and
- hence these operations cannot create (1).

These facts preserve the cubic threefold's length-one packet but do not control
general non-nef threefolds.  Naive degree monotonicity also fails even for
`P^3`, since quantum multiplication wraps the top class back to degree zero.

## Minimum sufficient theorem

Absolute one-grade carrier purity would suffice: construct a
presentation-independent Rees grading for which `N` raises grade and prove
that primitive-sixth support of every smooth projective threefold is
concentrated in one grade.  Then `N=0` on that support.  This is a clean
reformulation of the carrier theorem, not a consequence of the ordinary
threefold cohomological grading.

## Next test

Compute the class `e` in (1) for explicit non-nef threefolds whose quantum
connections are accessible by mirrors:

1. conic bundles over rational surfaces with nontrivial discriminant;
2. del Pezzo fibrations over a curve; and
3. blowups of simple Fano threefolds along positive-genus curves, used only as
   a strictness regression because the predicted added packet is zero.

The first example with `e != 0` kills the universal carrier bound.  Uniform
vanishing across a structural family is useful only if the mechanism extends
beyond the table.

## Mystery ledger

- **Settled negatively:** dimension-three grading and duality alone do not
  bound enriched length.
- **Isolated:** the sole missing datum is the self-dual sectorial Rees
  extension class (1).
- **Open:** whether any smooth projective non-nef threefold realizes `e != 0`.

