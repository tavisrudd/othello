# A cyclic family of blocks on a connected threefold cannot carry the cubic's grading pair

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-23

The geometric route to the \(m=2\) gate left one obstacle
(`2026-08-23-c925-fable-quantum-newton-slope-theorem.md`, §5): for a centre of
Picard rank at least two, nothing bounded \(c_1\cdot\gamma\) on the Newton edge
carrying the marked blocks.  This note closes that obstacle from a different
direction, using no curve classes at all.  The input is the grading operator
and the connectedness of the centre; the output is that the cyclic triple
required at \(m=2\) cannot have the same grading type as the blocks it would
have to cancel.

## 1. The grading pair of a block

For \(Z\) smooth projective of dimension \(n\), the grading operator on
\(H^{\rm ev}(Z)\) is \(\mu=(\deg-n)/2\).  Its spectrum is the multiset

\[
  \Bigl\{\tfrac{2k-n}{2}\ \text{with multiplicity}\ h^{2k}(Z)\Bigr\}_{k}.
\]

Under the formal decomposition of the quantum connection at \(z=0\), each
block carries a residue whose diagonal part in a block-adapted gauge is a
sub-multiset of that spectrum, and the blocks partition it.  Call the
sub-multiset attached to a block its **grading pair** when the block has
rank two, and its **grading difference** the difference of the two values.

**Verification on the cubic threefold.**  This is not an assumption bolted on:
it is visible in the existing audit.  For \(n=3\) the spectrum is
\(\{-3/2,-1/2,1/2,3/2\}\), each with multiplicity one.  The audit script
`notes/cubic-threefolds-tasks/c924-finite-cubic-check.py` records the marked
block's modified residue as

\[
  \begin{pmatrix}-19/18 & 2\\ -8/81 & 1/18\end{pmatrix},
\]

whose diagonal is \((-3/2+4/9,\ 1/2-4/9)\).  The modification is the traceless
shift \(\pm4/9\); the underlying grading pair is exactly \((-3/2,\,1/2)\), of
**grading difference two**, and its discriminant is
\(2^2=4\).  The marker \(\delta^\sharp=4/9\) is the discriminant after the
traceless shift: \(1-4\cdot\tfrac5{36}=\tfrac49\).  This is the same
dichotomy the packet records natively, where the two normalized native orders
give discriminant \(0\) or \(4\) — that is, grading difference zero or two.

## 2. The exclusion

**Theorem C.**  Let \(Z\) be a connected smooth projective threefold and let a
boundary monodromy permute \(\ell\ge2\) rank-two blocks of its quantum
spectral decomposition cyclically.  Then their common grading pair is drawn
from \(\{-1/2,\,1/2\}\).  In particular the grading difference is zero or one,
never two or three.  Moreover

* if the difference is zero, \(b_2(Z)\ge2\ell\);
* if the difference is one, \(b_2(Z)\ge\ell\).

*Proof.*  The monodromy conjugates the connection, so it carries the residue
of one block to the residue of the next; the grading values are rational
numbers and are fixed by the semilinear field automorphism, so all \(\ell\)
blocks have the *same* grading pair \(\{x,y\}\) as a multiset.  Because the
blocks are distinct summands, their grading pairs are disjoint sub-multisets
of the \(\mu\)-spectrum.  Hence the spectrum contains \(\ell\) copies of \(x\)
and \(\ell\) copies of \(y\) when \(x\ne y\), and \(2\ell\) copies of \(x\)
when \(x=y\).

For a connected smooth projective threefold the spectrum is
\(-3/2\) with multiplicity \(h^0=1\), \(-1/2\) and \(1/2\) each with
multiplicity \(b_2\), and \(3/2\) with multiplicity \(h^6=1\).  Since
\(\ell\ge2\), neither \(-3/2\) nor \(3/2\) can be used, so
\(x,y\in\{-1/2,1/2\}\), and the multiplicity counts give the two stated
bounds. ∎

Connectedness is exactly what makes \(h^0=h^6=1\), and it is exactly the
hypothesis under which the \(m=2\) obligation is stated: the remaining
correction theorem concerns each *connected* codimension-two threefold-centre
occurrence.

## 3. Consequence for the \(m=2\) gate

The blocks that a correction must cancel are the source's.  For
\(B\times\mathbf P^m\), the marked blocks are the cubic's marked block at
eigenvalue zero tensored with the \(m+1\) eigenlines of \(\mathbf P^m\);
tensoring with a rank-one block shifts both grading values by the same amount,
so the grading difference is unchanged.  The source's marked blocks therefore
have **grading difference two**, the cubic's own value.

Theorem C says a cyclic triple on a connected threefold centre has grading
difference zero or one.  So:

> A connected threefold centre cannot carry a cyclic triple of rank-two blocks
> with the source's grading type.

This is a topological statement about the centre.  It needs no calibration, no
native order, no curve-class bound, and no Newton polygon; it uses only that
the centre is a connected threefold and that a cyclic family of length at
least two cannot occupy a grading value of multiplicity one.

**What it does and does not settle.**  It settles the case in which grading
difference is part of the data a correction must match — that is, whenever the
correction block is required to agree with the source block in its underlying
grading, not merely in the shifted invariant \(\delta^\sharp\).  It does not
settle the case where a correction carries \(\delta^\sharp=4/9\) with an
underlying grading difference of zero or one, produced by a traceless
modification larger than the cubic's.  That is precisely the configuration the
parabolic-shear countermodel realizes at the level of linear algebra, and it
is what the native-calibration route is designed to exclude.  The two routes
are therefore complementary and now cover disjoint halves of the same gate:

| grading difference of the correction triple | excluded by |
|---|---|
| two (the source's own value) | Theorem C, topologically, unconditionally |
| zero or one | the native-order charts, once an occurrence calibration exists |

**Scope: this is a threefold statement, not an all-\(m\) one.**  Theorem C
excludes the difference-two pair on a threefold only because every
difference-two pair available in dimension three uses an extreme value:
the spectrum is \(\{-3/2,-1/2,1/2,3/2\}\) and the difference-two pairs are
\((-3/2,1/2)\) and \((-1/2,3/2)\).  In dimension \(d\ge4\) the interior of the
spectrum spans at least three consecutive values, so a difference-two pair
avoiding both extremes exists — already at \(d=4\) the pair \((-1,1)\) has
multiplicities \(h^2\) and \(h^6\), which are equal by duality and may be
arbitrarily large.  There the argument degrades from an exclusion to the
bound \(b_2(Z)\ge\ell\).  Since a blow-up centre in the \(m=2\) ambient
fivefold has dimension at most three, Theorem C covers every admissible centre
at \(m=2\) and nothing beyond it; for \(m\ge3\), centres of dimension four and
above need the rotation-order route or another argument.

**Numerical residue.**  For the surviving cases Theorem C also forces the
centre to be large: grading difference one needs \(b_2\ge3\), and grading
difference zero needs \(b_2\ge6\).  Combined with the Newton-slope theorem's
edge bound, a difference-zero triple needs a Newton edge of length at least
six inside an even cohomology of rank \(2+2b_2\ge14\).

## 3b. Why the marker cannot be read off the grading, and what that costs

The natural way to finish would be to show that \(\delta^\sharp=4/9\) itself
forces grading difference two, since Theorem C then closes \(m=2\) outright.
That attempt fails, and the reason is worth recording because it explains the
shape of the whole programme.

The marker is the discriminant of the modified residue, so
\(\delta^\sharp=4/9\) says exactly that the two exponents differ by
\(2/3\).  But grading values on a variety of dimension \(n\) are
\((2k-n)/2\), so **any two of them differ by an integer**.  A difference of
\(2/3\) is therefore never a grading difference, on any variety, in any
dimension.  For the cubic threefold the grading difference is two and the
modification carries it to \(2/3\); the modification is not a perturbation of
the grading data but the entire content of the marker.

Two consequences.

* It is structural, not accidental, that a native calibration excludes
  \(4/9\).  Any calibration under which the exponent difference remains a
  grading difference excludes \(4/9\) automatically, because \(2/3\) is not an
  integer.  This is the content of the two normalized native-order charts
  reaching discriminant \(0\) or \(4\) — those are the squares of grading
  differences \(0\) and \(2\).
* The implication "\(\delta^\sharp=4/9\) hence grading difference two" cannot
  be proved from the marker alone, because the marker is precisely the datum
  that has forgotten the grading.  Recovering it is the occurrence calibration,
  which is the external gate both routes already depend on.

So this route does not give an independent way past the calibration.  What
Theorem C contributes stands on its own — it excludes the difference-two
configuration with no calibration at all — but the complementary half is not
reachable by strengthening the marker's bookkeeping.

## 4. Formal check

`Comparison/GradingMultiplicityExclusion.lean` records the combinatorial core:
the multiplicity ledger of a connected threefold, the fact that a cyclic
family of length at least two cannot use a grading value of multiplicity one,
the resulting restriction of the pair to the middle values, and the two second
Betti number bounds.  The geometry — that block residues partition the
\(\mu\)-spectrum, and that conjugate blocks share a grading pair — is stated
as hypotheses and is external.

## 5. Replay

- Lean: `lean/scripts/guarded-lean --root papers/cubic-stabilization-irrationality/lean papers/cubic-stabilization-irrationality/lean/TavisRuddFiniteGeom/Papers/CubicStabilizationIrrationality/Comparison/GradingMultiplicityExclusion.lean`
- The cubic's grading pair is read off the residue matrix asserted in
  `notes/cubic-threefolds-tasks/c924-finite-cubic-check.py`; the arithmetic
  \((-3/2+4/9,\ 1/2-4/9)=(-19/18,\ 1/18)\) is exact.
