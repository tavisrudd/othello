# C665 — Balanced matching completeness and C661 consequences

**Lane**: `clebsch`

**Date**: 2026-07-26

**Status**: limited Gold complete and integrated — intrinsic quadratic
recovery whose two levels are one-factorizations forces the balanced setup,
and the only resulting orbits are \(B_3/\mathbb F_7\) and
\(H_3/\mathbb F_{11}\).  The Platinum continuation is in progress and is
not claimed here.

## Result

Let \(q\) be an odd prime power, let
\[
G=\operatorname{PGL}_2(q),\qquad G^+=\operatorname{PSL}_2(q),
\]
and let \(\Omega\) be any full \(G\)-orbit of perfect matchings of
\(\mathbb P^1(\mathbb F_q)\).  Represent its matching products in the
conic-ideal quotient, and let \(L\subseteq\mathbb F_q^\Omega\) be the
unital affine evaluation space.

Suppose quadratic products intrinsically recover a nontrivial
factorization bipartition, in the following exact sense:

1. \((L^{\circ2})^\perp\) is a line whose nonzero vectors have exactly two
   level sets on \(\Omega\); and
2. each recovered level set is a one-factorization of the complete graph on
   \(\mathbb P^1(\mathbb F_q)\).

Then
\[
(q,\Omega)=(7,\Omega_{B_3})\quad\text{or}\quad
(11,\Omega_{H_3}).
\]
Conversely, both displayed orbits satisfy the intrinsic hypothesis.  Their
evaluation spaces satisfy
\[
\dim L=q,\qquad
L^{\circ2}=\ker\epsilon,\qquad
L^{\circ3}=\mathbb F_q^\Omega,
\]
where \(\epsilon\) is the full-support \(+1/-1\) sheet sign.  Hence the
unordered sheet pair is the unique quadratic recovery and the first signed
power moment is cubic.

Thus the balanced \(2q=q+q\) setup is a conclusion of intrinsic recovery,
not a hypothesis.

The queued \(q=5\) premise was false.  The complementary ten-matching orbit is
one \(\operatorname{PSL}_2(5)\)-orbit, not a \(5+5\) split, and its Schur
square already equals all ten functions.  The five-matching orbit has an
\(A_4\) special stabilizer, but its full stabilizer enlarges to \(S_4\), so it
has size \(5\), not \(10\).

## Intrinsic recovery forces balance

The affine quotient transformation law makes \(L\), hence
\(L^{\circ2}\), stable under \(G\).  Therefore the unique quadratic-trade
line
\[
R=(L^{\circ2})^\perp
\]
is also \(G\)-stable.  Choose \(0\ne\tau\in R\).  Transitivity shows first
that \(\tau\) has full support: its zero set is \(G\)-invariant.  The two
level sets of \(\tau\) are intrinsic to the projective line \(R\), so \(G\)
permutes them.  Since \(G\) is transitive on \(\Omega\), its induced action
on the two levels is nontrivial.

For \(q>3\), the commutator subgroup of
\(\operatorname{PGL}_2(q)\) is \(\operatorname{PSL}_2(q)\): the latter is
nonabelian simple and the quotient has order two.  Hence the kernel of the
level-set action is exactly \(G^+\).  Normality and transitivity of \(G\)
then show that \(G^+\) is transitive on each level set.  If an outer element
sends \(\tau\) to \(c\tau\), it exchanges the two nonzero values \(a,b\);
thus \(ca=b,cb=a\), so \(c=-1\) and \(b=-a\).

It remains to derive the size rather than assume it.  A one-factorization of
\(K_{q+1}\) contains exactly
\[
\frac{\binom{q+1}{2}}{(q+1)/2}=q
\]
perfect matchings.  Consequently the recovered levels have size \(q\), the
full orbit has size \(2q\), and its restriction to \(G^+\) is the required
\(q+q\) split.  For \(q=3\), the whole matching set has only three elements,
so two disjoint one-factorizations cannot lie in one orbit.  This proves the
reduction to the balanced theorem in every odd prime-power characteristic.

The word “factorization” is essential and checkable: a merely two-valued
quadratic-trade line would force two equal \(G^+\)-orbits, but without the
edge-partition condition each orbit would only be a
\(\lambda\)-fold one-factorization of size \(q\lambda\).  The theorem does
not silently identify that weaker condition with balance.

## Balanced-orbit classification

Fix \(M\in\Omega\) and put \(K=\operatorname{Stab}_G(M)\).  Orbit--stabilizer
gives
\[
|K|=\frac{|G|}{2q}=\frac{q^2-1}{2}.
\]
Restriction of a transitive \(G/K\)-action to the index-two normal subgroup
\(G^+\) splits precisely when \(K\leq G^+\).  Thus the two-sheet hypothesis is
equivalent to
\[
[G^+:K]=q,\qquad |K|=(q^2-1)/2.
\]

For \(q=3\), there are only three perfect matchings of four points, so an orbit
of size \(2q=6\) is impossible.  Assume \(q\geq5\).  Dickson's subgroup list
for \(\operatorname{PSL}_2(q)\) leaves only:

- dihedral subgroups of order at most \(q+1\), too small because
  \((q^2-1)/2>q+1\);
- Borel subgroups of order at most \(q(q-1)/2\), again too small;
- subfield groups \(\operatorname{PSL}_2(r)\) or
  \(\operatorname{PGL}_2(r)\), whose orders are strictly smaller than
  \((q^2-1)/2\) when they are proper and strictly larger when
  \(r=q\); and
- \(A_4,S_4,A_5\), of orders \(12,24,60\).

The exceptional bound leaves \(q=5,7,9,11\).  At \(q=9\), the required
stabilizer order is \(40\), which divides none of \(12,24,60\).  In the
remaining cases, order and divisibility force
\[
\frac{q^2-1}{2}=12,24,60,
\]
and hence \(q=5,7,11\), respectively.  Dickson's congruence conditions admit
all three.  This proves the field-and-stabilizer reduction without a field
census.

The matching realization is also structural.  For \(q=5\), the
\(A_4\)-action on six endpoints has point stabilizer \(C_2\); its normal
Klein four subgroup gives the unique two-point block system.  The outer
normalizer \(N_{\operatorname{PGL}_2(5)}(A_4)=S_4\) must preserve that
unique matching, so its full orbit has size five rather than ten.

For \(q=7\), the \(S_4\)-action on eight endpoints has point stabilizer
\(C_3\).  A two-point block stabilizer has order six and is forced to be
the unique normalizer \(N_{S_4}(C_3)=S_3\).  For \(q=11\), the analogous
\(A_5\)-action has point stabilizer \(C_5\), and the unique block
stabilizer is \(N_{A_5}(C_5)=D_{10}\).  In the latter two cases the
exceptional subgroup has no outer normalizer, so the full stabilizer is
exactly \(S_4\) or \(A_5\).  The resulting orbits are the displayed
\(B_3\) and \(H_3\) orbits and split \(7+7\) and \(11+11\).

The primary certificate and independently generated replay provide the
following cross-check, but are not premises of the classification:

| \(q\) | relevant full orbit | \(G^+\)-orbit sizes | full stabilizer | conclusion |
|---:|---:|---:|---|---|
| \(5\) | \(5\) | \(5\) | \(S_4\) | the \(A_4\)-fixed matching enlarges |
| \(5\) | \(10\) | \(10\) | dihedral of order \(12\) | not balanced; \(L^{\circ2}=k^{10}\) |
| \(7\) | \(14\) | \(7+7\) | \(S_4\leq G^+\) | unique balanced orbit |
| \(11\) | \(22\) | \(11+11\) | \(A_5\leq G^+\) | unique balanced orbit |

The element-order fingerprints distinguish the named stabilizers.  The
enumeration covers all \(15,105,10395\) perfect matchings for
\(q=5,7,11\), respectively, partitions them into all full-projective orbits,
and stops there.  It does not extrapolate from those fields; the preceding
Dickson reduction proves that no other field needs a matching check.

## Cubic inevitability

The C661 implication has a shorter abstract proof that needs neither a
Gorenstein theorem nor a cubic tensor calculation.

**Hyperplane-square lemma.**  Let \(k\) be any field, let \(\Omega\) be
finite, and let \(L\subseteq k^\Omega\) be a unital linear space with
\(\dim L>1\).  Suppose
\[
L^{\circ2}=\ker\epsilon
\]
for a linear functional represented by a vector
\(\epsilon\in(k^\times)^\Omega\) of full support.  Then
\[
L^{\circ3}=k^\Omega.
\]
In particular, the signed cubic tensor defined by \(\epsilon\) is nonzero,
and every higher Schur power is also full.

Indeed, if a nonzero \(\eta\) annihilated \(L^{\circ3}\), then
\(1\in L\) would make it annihilate \(L^{\circ2}\), so
\(\eta\in k\epsilon\).  For every \(f\in L\), the vector
\(\eta\circ f\) also annihilates \(L^{\circ2}\), hence lies in
\(k\epsilon=k\eta\).  Full support of \(\eta\) forces every \(f\in L\) to be
constant, contradicting \(\dim L>1\).

Over odd characteristic, when \(\epsilon\) has the two values \(+1,-1\),
the one-dimensional annihilator recovers its two level sets as an unordered
pair.  The lemma then proves cubic-first orientation directly:
\(\epsilon\) kills every quadratic product but cannot kill every cubic
product.

## EV-ordered route disposition

1. **Intrinsic nonlinear completeness: pass.**  The unique quadratic-trade
   line makes its two factorization levels a \(G\)-equivariant block system;
   the determinant-square kernel is \(G^+\), and edge counting derives the
   \(q+q\) split.  The subgroup reduction then leaves \(q=5,7,11\); complete
   two-point block-system and normalizer arguments kill \(q=5\) and prove
   the unique \(B_3,H_3\) cases.  Both recovering cases have Schur-square
   ranks \(13,21\),
   respectively, and full Schur cubes.
2. **Reusable cocycle-span criterion: fail its non-tautology gate.**  The
   stable-span identity \(g\,c(h)=c(gh)-c(g)\), irreducible projection, and
   radial trace already give C661's exact interface.  Abstracting them without
   the case-specific containment or cohomology hypotheses merely restates
   irreducibility, so no new theorem or manuscript layer is added.
3. **Cubic inevitability: pass, strengthened.**  The hyperplane-square lemma
   derives the full cubic algebra and nonzero signed cubic by elementary
   duality.  Signed Gale self-duality and Gorenstein symmetry remain valuable
   geometric consequences, but are no longer logically needed to force the
   cubic.
4. **Uniform radial-trace lemma: fail its geometric-nonvanishing gate.**
   Iterated apolar trace uniformly extracts the deepest radial Fischer
   summand, but no type-free matching argument was found that makes the
   \(B_3\) common-secant square and \(H_3\) second-trace witness nonzero.
   Stating the extraction formula alone would only rename the two existing
   calculations.

## Literature boundary

This report makes no novelty or absence claim.  Its modern load-bearing
subgroup source was read at **full-text** depth, with two primary/secondary
cross-checks at partial depth:

- M. Giudici, *Maximal subgroups of almost simple groups with socle
  \(\operatorname{PSL}(2,q)\)*, **full text**, all 11 pages; cache key
  `arXiv:math/0703685`, SHA-256
  `2c829b573dadf9ee2c71a9f85f92e1fb2d7443f64242dbe4a829c6246d9ae8e9`.
  The maximal-subgroup lists and exceptional class-fusion/normalizer facts
  are the cited classical input.

- L. E. Dickson, *Linear Groups with an Exposition of the Galois Field
  Theory* (1901), **partial**, original edition, §§260--262 and printed
  pp.285--287 read from the Internet Archive/Wikimedia scan; cache key
  `IA:lineargroupswith00dickrich`, SHA-256
  `c03060b341dcf69ba0376f6fe4d23010460185892f806a28f4178444fd6ee00a`.
  Section 260 is the primary subgroup list and §262 records the exceptional
  low-index cases.
- R. M. Guralnick and M. E. Zieve, *Polynomials with
  \(\operatorname{PSL}(2)\) monodromy*, published version,
  **partial**, Appendix A through Theorem A.1 and its surrounding order
  conventions; DOI `10.4007/annals.2010.172.1315`, cache SHA-256
  `470b15d0a217c7acdd1378f1066f7249ba7272057c9c4a60bec60942bbdc3d35`.
  This supplies a modern transcription of Dickson's seven subgroup types.

## Reproducibility

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-26-c665-balanced-matching-completeness.py --check
python3 notes/2026-07-26-c665-balanced-matching-completeness-replay.py
sha256sum -c notes/2026-07-26-c665-balanced-matching-completeness.sha256
```

Intentional regeneration is:

```bash
python3 notes/2026-07-26-c665-balanced-matching-completeness.py --write
```

The primary checker constructs \(\operatorname{PGL}_2(q)\) from normalized
matrices and identifies \(\operatorname{PSL}_2(q)\) by determinant square
class.  The replay instead generates the two groups from translation,
inversion, and a nonsquare dilation.  They independently enumerate all
matchings and reconstruct the conic-ideal quotient.  The primary divides by
\(XZ-Y^2\) using exact row reduction; the replay uses a triangular coefficient
recurrence.  Both compute the affine, Schur-square, and Schur-cube ranks.

The trusted boundary is exact Python prime-field arithmetic, the standard
Möbius action, and exact polynomial arithmetic.  The certificate proves only
the matching realization and evaluation-algebra claims in the three fields
left by the human subgroup theorem.  It does not itself prove Dickson's
classification.

## Paper and formal disposition

The intrinsic-completeness theorem and hyperplane-square lemma are Paper II
v2 upgrades.  They do not hold v1.  A separate manuscript owner integrated
the theorem package into the working manuscript.  The certificate-free dual
mechanism is formalized as
`RelativeConicArcs.HyperplaneSquare.cubicAnnihilator_eq_zero`; its dedicated
import gate exposes that terminal.  Lean takes the unital nonconstant
function space, full-support quadratic relation, and one-dimensional
quadratic annihilator as hypotheses and proves that every cubic annihilator
is zero.

## `ej` + `tt` closeout

The cheap extra value is the hyperplane-square lemma.  The earlier argument
passed through signed Gale duality, Cayley--Bacharach, self-association, and
Gorenstein Hilbert symmetry before returning to the cubic.  Dualizing the
single full-support quadratic relation shows directly that a second relation
in degree three would collapse all of \(L\) to constants.  Thus quadratic
recovery itself forces cubic fullness, over any field, and the entire higher
Schur filtration stabilizes immediately.

The expert-level structural picture is now sharp.  The intrinsic trade line
first forces the determinant-square block system, the recovered
one-factorizations force its size, group theory explains why only the
Platonic indices \(5,7,11\) can occur, and projective matching realization
explains why the \(q=5\) candidate enlarges instead of splitting.  Elementary
commutative-algebra duality then explains why every recovering case must be
cubic.  The remaining radial question is genuinely separate from nonlinear
completeness.

## Mystery ledger

| Feature | Status | Exact remaining gap |
|---|---|---|
| Does intrinsic quadratic recovery force the balanced setup? | settled | Stability of the unique trade line gives the \(G^+\) block system; the recovered one-factorization property gives \(q\) matchings per block. |
| Are there balanced \(2q\)-matching orbits beyond \(B_3,H_3\)? | settled | Dickson reduction plus the three exact matching realizations proves there are none. |
| Does the \(q=5\) ten-matching orbit split \(5+5\)? | settled negatively | It is one \(G^+\)-orbit and its Schur square has rank ten. |
| Why must quadratic recovery have a nonzero cubic? | settled | The hyperplane-square lemma gives \(L^{\circ3}=k^\Omega\) directly. |
| Is there a genuinely reusable cocycle-span theorem beyond C661? | settled negatively for this task | Without extra containment or cohomology hypotheses, the proposed statement is only irreducibility in new notation. |
| Is one geometric radial nonvanishing mechanism shared by \(B_3,H_3\)? | open | Iterated trace extracts both radial pieces, but no common matching-geometric reason for nonvanishing is proved.  A future Paper II v2 task must supply that mechanism rather than another scalar check. |

No open mystery affects balanced-orbit completeness, quadratic recovery, or
cubic inevitability.
