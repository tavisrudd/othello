# C665 — Balanced matching completeness and C661 consequences

**Lane**: `clebsch`

**Date**: 2026-07-26

**Status**: limited Gold complete and integrated — a one-dimensional
strength-two trade space whose two fibers are one-factorizations forces the
balanced setup, and the only resulting orbits are \(B_3/\mathbb F_7\) and
\(H_3/\mathbb F_{11}\).  The one-factorization condition uses endpoint
incidence rather than the abstract quotient alone.  The stronger
trade-only “Platinum” continuation is active under C665 but is not yet a
manuscript claim.  Its exceptional \(A_4,S_4,A_5\) head table is complete
and its \(q=19,A_5\) quadratic pullback is nonsplit; uniform C1,
characteristic-three tori, and the \(q=5\) dihedral endpoint remain.

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

### `tt` nonacceptance gate for the stronger statement

Dropping the one-factorization clause is not a cosmetic reformulation.  If
the two intrinsic levels have size \(n\), transitivity of \(G^+\) on
matchings and on endpoint edges gives a constant edge multiplicity
\[
\lambda=\frac{n}{q};
\]
thus the group action alone derives only two \(\lambda\)-fold
one-factorizations.  It gives no argument that \(\lambda=1\).

The first representation-theoretic obstruction is consistent with, but does
not prove, the desired strengthening.  Let \(U\) be a Sylow-\(p\) subgroup.
A matching stabilizer contains no nontrivial unipotent: such an element has
one fixed endpoint, while the partner of that endpoint would have a
nontrivial \(p\)-orbit.  Hence a sheet permutation module restricts to
\(\lambda\) copies of the regular \(U\)-module.  If its quadratic evaluation
vectors were independent, the two sheets would require \(2\lambda\) regular
summands in the ambient quadratic module.  This supplies useful bounded
obstructions, but the ambient regular-summand capacity grows with \(q\), so
it does not furnish a uniform proof that \(\lambda=1\).

Accordingly, the Gold theorem uses “factorization bipartition” in its
standard incidence sense: each fiber partitions the edge set exactly once.
Any statement replacing that hypothesis by “the unique quadratic trade has
two values” needs a new uniform module or matching-scheme argument.

### Platinum plan and bounded falsification

Write a recovered sheet as \(H/K\), where
\(H=\operatorname{PSL}_2(q)\), and write its size as \(q\lambda\).
The exact plan is:

1. **Falsify first.**  Search extension-field and larger-prime split
   matching orbits before investing in a uniform module theorem.
2. **Sheet-module reduction.**  Since \(K\) contains no nontrivial
   unipotent, \(P=k[H/K]\) is projective and
   \(P\mathord\downarrow_U\cong(kU)^\lambda\) for a Sylow-\(p\) subgroup
   \(U\).
3. **Common-quotient reduction.**  For the two surjective sheet evaluations
   \(e_+,e_-:R\to P\), identify the trade dimension with
   \[
   \dim R/(\ker e_++\ker e_-).
   \]
   A unique trade says exactly that this common quotient is the trivial
   line.
4. **Nonprincipal survival target.**  Prove that if \(P\) has a
   nonprincipal projective summand, the common quotient has a nontrivial
   composition factor.  This directly contradicts a unique trade.
5. **Finish from the sheet module.**  Prove in the present matching action
   that \(k[H/K]=P(\mathbf1)\) occurs only for
   \((q,K)=(7,S_4)\) and \((11,A_5)\).  Then
   \(\dim P=q\), hence \(\lambda=1\), and the Gold classification applies.

Step 3 is now a formal identity.  Steps 4 and 5 are the remaining
representation- and subgroup-theoretic inputs.  The earlier proposal to
exclude two projective copies in the ambient quadratic module remains a
valid sufficient condition, but it is not the intrinsic seam: already for
the \(q=19\) competitor the relevant simple socle occurs ten times in the
quadratic module and its dual.  The single-Sylow norm count likewise supplies
useful small-field obstructions but has no uniform capacity bound.

The new exact bounded gate found no counterexample:

| field/scope | split competitors | affine rank(s) | quadratic trade dimension(s) |
|---|---:|---:|---:|
| \(q=9\), all 945 matchings | none | -- | -- |
| \(q=13\), all 135135 matchings | minimum orbit size \(364\) | ambient at most \(22\) | at least \(364-\binom{23}{2}=111\) |
| \(q=17\), explicit orbits \(204,408,612\) | \(102+102,\ 204+204,\ 306+306\) | \(16,23,27\) | \(84,193,288\) |
| \(q=19\), exceptional \(A_5\) competitor | \(57+57\) | \(32\) | \(14\) |

The \(q=9\) and \(q=13\) rows are exhaustive.  The later rows are explicit
falsifiers, not subgroup-list exhaustion claims.  Exploratory
\(A_5\)-competitor checks at \(q=29,31\) also had trade dimensions
\(113,91\), but those uncatalogued checks are not part of the evidence
bundle or any claim.

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

The separate Platinum falsifier is:

```bash
python3 notes/2026-07-26-c665-platinum-falsifier.py
python3 notes/2026-07-26-c665-platinum-falsifier-replay.py
sha256sum -c notes/2026-07-26-c665-platinum-falsifier.sha256
```

Its primary checker constructs full projective groups from normalized
matrices.  Its replay uses translation, extension-field translation,
inversion, and nonsquare dilation generators; for \(q=9\) it also changes
from \(\mathbb F_3[a]/(a^2+1)\) to the independent model
\(\mathbb F_3[b]/(b^2-b-1)\).  The trusted scope is recorded in the JSON:
the \(q=9,13\) censuses are exhaustive, whereas \(q=17,19\) evaluate only
the displayed representatives.

Two exact Sage checks expose the \(q=19\) module structure:

```bash
nix shell nixpkgs#sage -c sage \
  notes/2026-07-26-c665-q19-module-test.sage
nix shell nixpkgs#sage -c sage \
  notes/2026-07-26-c665-q19-trade-module.sage
```

The exceptional-head and quadratic-pullback continuation is replayed from
`/home/tavis/src/othello` by

```bash
nix shell nixpkgs#sage -c sage \
  notes/2026-07-26-c665-exceptional-head-pullback.sage --check
nix shell nixpkgs#sage -c sage \
  notes/2026-07-26-c665-q19-module-test.sage --pullback-check
sha256sum -c notes/2026-07-26-c665-exceptional-head-pullback.sha256
```

The head checker has two routes.  It extracts PIM-head multiplicities from
the defining-characteristic decomposition matrix of the coset permutation
character, and independently averages the Steinberg-digit character over
the binary-polyhedral lift classes.  The direct candidate occurs in every
finite PIM table row where it is predicted.  The uniform conclusion uses
the displayed class average, not extrapolation from those rows.

The pullback checker constructs the point-vector affine module, its
symmetric square, the contraction, and all relevant intertwiner spaces over
\(\mathbb F_{19}\).  It verifies contraction equivariance directly and
computes both the zero matrix of \(\partial_*\) and the independent outer
eigenspace mismatch \(10+0\to0+1\).  There is no second implementation of
the full 1081-dimensional module; the cross-check is the incompatible outer
parity, using the pre-existing independently normalized projective action.
The certificate proves the \(q=19\) pullback only, not C1-uniform.
The hashed bundle contains the exceptional checker (9,454 bytes), its JSON
certificate (15,813 bytes), the extended q=19 checker (21,425 bytes), and
its pullback certificate (268 bytes).  Their SHA-256 values are pinned in
`2026-07-26-c665-exceptional-head-pullback.sha256`.

The sheet permutation character is
\[
P(\mathbf1)+P(S_{13}),
\qquad \dim P(\mathbf1)=19,\quad \dim P(S_{13})=38.
\]
The 1081-dimensional universal quadratic module and its dual both have
\(\dim\operatorname{Hom}_H(S_{13},-)=10\), so a simple-socle
multiplicity-one surrogate is false.  This does not by itself decide whether
two full copies of \(P(S_{13})\) embed.  More decisively for the actual
evaluation, the fourteen-dimensional quadratic-trade module has composition
factors
\[
\mathbf1,\ S_{13}.
\]
Thus the q=19 competitor exhibits exactly the nonprincipal-survival pattern
required by Step 4.

### Head-survival attack

The same pattern persists in all three certified \(q=17\) competitors.
Their sheet projectives and quadratic trade modules have the following
simple dimensions:

| \(\lambda\) | heads of indecomposable sheet summands | trade composition factors |
|---:|---|---|
| \(6\) | \(1,9,13,17\) | \(1,1,3,7,9,9,9,13,15,17\) |
| \(12\) | \(1,7,9,13,13,15,17\) | every displayed head, with additional factors |
| \(18\) | \(1,5,9,9,11,13,13,15,17,17,17\) | every displayed head, with additional factors |

Thus every simple head of the sheet module occurs in the trade module, with
at least its sheet multiplicity.  The exact check is

```bash
nix shell nixpkgs#sage -c sage \
  notes/2026-07-26-c665-q17-trade-modules.sage
```

Translation norms give a second, more elementary view.  The
translation-invariant trade dimensions are

| field | \(\lambda\) | invariant trade dimension |
|---|---:|---:|
| \(13\) | \(14,42,84\) | \(15,69,153\) |
| \(17\) | \(6,12,18\) | \(5,12,18\) |
| \(19\) | \(3\) | \(2\) |

The \(q=13\) representatives are checked by
`notes/2026-07-26-c665-q13-norm-images.sage`.  In every tested
\(\lambda>1\) case, translation invariants alone already rule out a unique
trade.

This does not follow from the universal conic module: at \(q=19\) its
translation norm has rank \(40\), and a nonsquare dilation has rank \(39\)
on the norm-image difference.  The low-rank intersection is therefore a
property of the actual matching-orbit evaluation, not a formal property of
the ambient polynomial representation.  The universal calculation is
replayed by adding `--norm-only` to the q=19 module-test command.

The sharpened target is now:

> For every simple \(S\) in the head of a sheet projective \(P\), the two
> sheet copies have a nonzero scalar combination whose quadratic moments
> vanish.

Such a combination embeds \(S\) in the trade module.  If the trade module
is one-dimensional, the head of \(P\) is therefore one-dimensional; since
\(P\) is projective and has the invariant trivial quotient, this forces
\(P=P(\mathbf1)\).  What remains is to prove the displayed moment dependence
uniformly from the matching-product cocycle.

### Platinum `tt` checkpoint

The first uniform-projective attack is too coarse.  Because group algebras
are self-injective, two embedded copies of a projective sheet summand would
split off the universal quadratic conic module.  It is therefore tempting to
exclude them by decomposing that universal module.  The \(q=19\) calculation
already shows why simple-socle multiplicity cannot do this: the relevant
thirteen-dimensional simple maps into the module and its dual with
multiplicity ten.  A full MeatAxe indecomposition was started only as a
diagnostic and was stopped before producing a result; no conclusion from it
is used here.

The sharper route is the Sylow-translation norm on the *actual orbit
evaluation*.  Let \(U\) be the translation subgroup and let a sheet contain
\(\lambda\) regular \(U\)-orbits.  Pair the two sheets by a nonsquare
dilation \(d\), and write \(N_i\) for the quadratic moment sum over the
\(i\)-th \(U\)-orbit in one sheet.  The tested ranks point to the exact
statement
\[
 \dim\bigl(\langle N_1,\ldots,N_\lambda\rangle+
 d\langle N_1,\ldots,N_\lambda\rangle\bigr)\leq\lambda+1.   \tag{*}
\]
Equivalently, the nonsquare dilation adds at most one direction to the norm
image of one sheet.  If \((*)\) holds, the \(2\lambda\)-dimensional
translation-fixed subspace of the two sheet permutation modules contains at
least \(\lambda-1\) independent trades.  Thus a unique trade forces
\(\lambda\leq2\); Dickson's \(p'\)-subgroup list and the small matching
realizations can then dispose of the residual \(\lambda=2\) cases.

This is more precise than either earlier projective-capacity target.  The
universal conic module does not satisfy the corresponding rank-one outer
difference: at \(q=19\) that difference has rank \(39\).  Hence the proof of
\((*)\), if true, must use the matching-product cocycle, namely that every
secant product has the same restriction to the conic.  The next acceptance
test is to compute the one-sheet norm ranks and the rank of the dilation
difference on their images in the certified \(q=13,17,19\) cases.  Only if
those ranks support \((*)\) should the cocycle coefficient identity be
developed.

That acceptance test is positive:

| \(q\) | \(\lambda\) | one-sheet norm ranks | joint norm rank |
|---:|---:|---:|---:|
| \(13\) | \(14,42,84\) | \(13,15,15\) on both sheets | \(13,15,15\) |
| \(17\) | \(6,12,18\) | \(6,11,17\) on both sheets | \(7,12,18\) |
| \(19\) | \(3\) | \(3\) on both sheets | \(4\) |

Thus every certified joint rank is at most \(\lambda+1\).  In the cases
where a sheet norm map is injective, the nonsquare sheet adds exactly one
direction; otherwise one sheet already has a translation-invariant kernel.
The remaining proof obligation is the uniform rank bound \((*)\), not a
further finite test.

A second falsification pass targets the first large regular exceptional
action.  Over \(\mathbb F_{59}\), an \(A_5\) acts regularly on the sixty
endpoints; right multiplication by an involution gives an
\(A_5\)-invariant perfect matching.  Its full orbit has size \(3422\), its
two sheets have size \(1711=59\cdot29\), and its affine rank is \(376\).
Two independent samples of \(3485\) quadratic rows both have rank \(2381\),
far below the \(3421\) required for a unique trade.  This is a one-sided
exact falsifier, not yet a full square-rank certificate: it proves that
neither displayed sample certifies uniqueness, while their identical rank
is evidence for structural saturation at \(2381\).

The affine ranks also expose the governing module shape.  At \(q=19\) the
full affine conic module decomposes into indecomposables of dimensions
\[
 1,\ 5,\ 9,\ 13,\ 18,
\]
with the eighteen-dimensional summand having trivial head and
seventeen-dimensional socle.  The \(A_5\) orbit span is exactly the
\(1+13+18=32\) selection.  At \(q=17\), the three certified orbit spans
have dimensions \(16\), \(16+7\), and \(16+11\).  Thus the orbit spans are
multiplicity-free selections of Fischer layers.  This makes a
projective-summand proof more plausible, but it is not itself the missing
uniform theorem.

## Lean reduction of the Platinum seam

Three certificate-free modules formalize the incidence, conditional
projective, and unconditional common-quotient reductions.

`RelativeConicArcs.MatchingFactorizationBalance` proves:

- `stableLine_fullSupport`: a nonzero group-stable function line on a
  transitive orbit has full support;
- `card_mul_edgesPerMatching_eq_card_mul_edgeMultiplicity`: the incidence
  double count
  \[
  |S|m=|E|\lambda;
  \]
- `sheet_card_eq_q_mul_index`: for perfect-matching parameters this gives
  \(|S|=q\lambda\);
- `edgeMultiplicity_eq_one_of_sheet_card_eq_q`: conversely, a positive
  \(q\)-sheet has \(\lambda=1\), so excluding \(\lambda>1\) is exactly the
  missing incidence conclusion;
- `oneFactorization_card_eq_q` and
  `twoOneFactorizationSheets_card_eq_two_mul_q`: index one gives the derived
  \(q+q\) balance.

`RelativeConicArcs.ProjectiveMultiplicityObstruction` proves:

- `projectiveMonomorphism_lifts` and `twoProjectiveCopies_lift`: if an
  epimorphic quadratic evaluation target contains \(Q\oplus Q\), projectivity
  embeds \(Q\oplus Q\) back into the quadratic source;
- `twoNonprincipalCopies_embed_kernel`: if
  \(\operatorname{Hom}(Q,\mathbf1)=0\), the kernel of the two-sheet trade
  functional contains the two nonprincipal sheet copies;
- `no_epimorphism_to_twoSheetKernel` and its representation-category
  specialization: a source satisfying `ExcludesTwoCopies Q R` cannot
  surject onto that kernel;
- `representation_twoCopies_finrank_le_source`: an epimorphic evaluation
  onto a target containing \(Q\oplus Q\) forces
  \(\dim(Q\oplus Q)\leq\dim R\), giving a direct numerical test for a
  concrete conic module;
- `representation_excludesTwoCopies_of_finrank_lt`: the required exclusion
  follows from the sufficient finite-dimensional inequality
  \(\dim R<2\dim Q\).

This remains a correct conditional obstruction, but it is no longer the
selected uniform route.

`RelativeConicArcs.TwoSheetCommonQuotient` proves:

- `combinedRange_fst_surjective` and
  `combinedRange_snd_surjective`: surjective sheet evaluations give a
  subdirect product;
- `combinedRange_goursat`: the simultaneous image is the graph of an
  isomorphism between quotient sheets;
- `finrank_combinedRange_quotient_eq_finrank_kernelSup_quotient`: exactly
  \[
  \dim (P\oplus P)/\operatorname{im}(e_+,e_-)
  =
  \dim R/(\ker e_++\ker e_-).
  \];
- `uniqueTrade_iff_commonQuotient_finrank_eq_one` and
  `two_le_tradeDimension_of_two_le_commonQuotient`: dimension one is
  equivalent on the two sides, while a common quotient of dimension at
  least two rules out uniqueness;
- `pairedCopy_injective`, `pairedCopy_range_le_tradeKernel`, and
  `finrank_le_tradeKernel_of_pairedCopy`: a nonzero scalar combination of
  two sheet copies with zero quadratic moments embeds that simple module in
  the trade kernel and supplies its dimension as a lower bound.

All three substantive modules elaborate cleanly with the guarded
single-file checker and introduce no axiom or `sorry`.  The import-only source
`RelativeConicArcs.Gates.MatchingFactorizationBalance` is present, but its
aggregate build was not run because a foreign Lean build owns the shared
build lock.

Lean therefore moves the open statement to a sharper exact input: when
\(\lambda>1\), prove that the common quotient
\[
R/(\ker e_++\ker e_-)
\]
has dimension at least two, preferably by showing that a nonprincipal simple
head of the sheet module survives in it.  The q=19 trade calculation gives
the model case \(\mathbf1\oplus S_{13}\), and all three q=17 competitors
contain every sheet head in their trade modules.  No uniform survival
theorem is claimed yet.

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
| Does a unique two-valued quadratic trade alone force the one-factorization property? | open C665 Platinum continuation; not a manuscript claim | The action yields only a \(\lambda\)-fold one-factorization on each level.  The exceptional \(A_4,S_4,A_5\) head table now supplies a nonnegligible head in every non-endpoint case, and the \(q=19,A_5\) quadratic pullback is exactly nonsplit.  The remaining uniform gates are C1 for the other selected heads, characteristic-three tori, and the isolated \(q=5\) dihedral endpoint. |
| Are there balanced \(2q\)-matching orbits beyond \(B_3,H_3\)? | settled | Dickson reduction plus the three exact matching realizations proves there are none. |
| Does the \(q=5\) ten-matching orbit split \(5+5\)? | settled negatively | It is one \(G^+\)-orbit and its Schur square has rank ten. |
| Why must quadratic recovery have a nonzero cubic? | settled | The hyperplane-square lemma gives \(L^{\circ3}=k^\Omega\) directly. |
| Is there a genuinely reusable cocycle-span theorem beyond C661? | settled negatively for this task | Without extra containment or cohomology hypotheses, the proposed statement is only irreducibility in new notation. |
| Is one geometric radial nonvanishing mechanism shared by \(B_3,H_3\)? | open | Iterated trace extracts both radial pieces, but no common matching-geometric reason for nonvanishing is proved.  A future Paper II v2 task must supply that mechanism rather than another scalar check. |

The open trade-only strengthening does not affect the stated
one-factorization theorem, balanced-orbit completeness, or cubic
inevitability.

## Platinum hypothesis and degrees-of-freedom ledger

This ledger separates the information available before the missing leap
from the statements that still need proof.

### Fixed objects

- \(k=\mathbb F_q\), with \(q\) an odd prime power;
  \(G=\operatorname{PGL}_2(q)\), \(H=\operatorname{PSL}_2(q)\), and
  \(\chi:G/H\to\{\pm1\}\) the determinant-square character.
- \(X=\mathbb P^1(k)\), \(M\) is a perfect matching of \(X\), and
  \(\Omega=G\cdot M\).
- The matching product \(P_M\) is the product of the \((q+1)/2\) secant
  equations belonging to \(M\).  All matching products restrict to the
  same binary form \(s^qt-st^q\) on the conic \(XZ-Y^2=0\).
- Hence \(P_M-P_{M_0}=(XZ-Y^2)Q_M\), where
  \(\deg Q_M=(q-3)/2\).  The homogenized vectors
  \(\widehat Q_M=(1,Q_M)\) form a \(G\)-stable affine orbit span \(E_\Omega\)
  inside the universal conic-fibre module.
- \(L\subseteq k^\Omega\) is the unital affine evaluation space.  The
  quadratic moment map is
  \[
    \mu:k^\Omega\longrightarrow \operatorname{Sym}^2(E_\Omega),
    \qquad \delta_M\longmapsto \widehat Q_M^{\odot2},
  \]
  up to the harmless choice of dual convention.  Its kernel is exactly the
  strength-two trade space \((L^{\circ2})^\perp\).

### Platinum hypothesis and consequences already proved

Assume \(\ker\mu=k\tau\), where \(\tau\) has two values.

1. Transitivity gives full support.  The two level sets are a nontrivial
   \(G\)-block system, so \(H\) fixes each level and an outer element
   exchanges them.  After scaling, \(\tau\) is the \(+1/-1\) sheet sign and
   affords \(\chi\).
2. Writing \(K=\operatorname{Stab}_G(M)\), splitness gives \(K\le H\) and
   \[
     \Omega=\Omega_+\sqcup\Omega_-,
     \qquad \Omega_+\simeq H/K,
     \qquad |\Omega_+|=q\lambda,
     \qquad |K|=\frac{q^2-1}{2\lambda}.
   \]
3. No nontrivial unipotent stabilizes a perfect matching.  Thus \(K\) is a
   \(p'\)-group, the sheet module \(P=k[H/K]\) is projective, and for the
   translation Sylow subgroup \(U\),
   \(P\mathord\downarrow_U\simeq(kU)^\lambda\).
4. The restriction of \(\mu\) to either sheet is injective: a vector
   supported on one sheet cannot lie in the full-support sign line.  Hence
   \((P\oplus P)/k\tau\) embeds in the quadratic moment module.
5. The invariant quotient occurs once in \(P\).  If \(\lambda>1\), the
   sheet module has a nonzero nonprincipal projective summand.  Therefore a
   proof that the quadratic moment module cannot contain both outer
   extensions of such a summand would force \(\lambda=1\).

Items 1--4 use no one-factorization hypothesis.  Item 5 is the exact point
at which modular representation theory must replace endpoint incidence.

### Geometric and module constraints on the quadratic target

- The universal conic-fibre module is an extension of its constant quotient
  by the degree-\((q-3)/2\) conic-quotient module.
- Its Fischer layers are multiplicity-free and their binary highest weights
  differ by four.  With the normalization that fixes the constant quotient,
  every nonconstant layer carries the same determinant-square twist.
- Consequently the quadratic module has only two kinds of channels:
  constant--Fischer cross terms with that twist, and Fischer--Fischer
  products with the square of the twist.  The cross terms contain only one
  copy of each selected linear Fischer layer; all additional copies must
  come from tensor-product channels.
- In every computed orbit, \(E_\Omega\) is a multiplicity-free selection of
  these layers.  The \(q=19\) \(A_5\) competitor selects dimensions
  \(1+13+18\); the three \(q=17\) competitors select
  \(16\), \(16+7\), and \(16+11\).
- The tested nonprincipal simple heads always survive in the trade module.
  At \(q=19\) the trade factors are \(\mathbf1\oplus S_{13}\); at \(q=17\)
  every simple head of every tested sheet projective occurs in the trade
  with at least the sheet multiplicity.

The multiplicity-free Fischer selection is exact computationally in the
displayed cases, but it is not yet a proved theorem for every matching
orbit or every prime power.

### Degrees of freedom still present

After the preceding reductions, the only uncontrolled data are:

1. the Dickson \(p'\)-subgroup type of \(K\): cyclic, dihedral,
   \(A_4,S_4\), or \(A_5\);
2. the \(K\)-invariant perfect matching inside the endpoint action;
3. which Fischer-layer projections of its matching product are nonzero;
4. the multiplicities and outer parities with which projective covers occur
   in the quadratic tensor channels; and
5. for \(q=p^e\), the Frobenius-digit structure of those channels.

The orbit size and \(\lambda\) are not independent degrees of freedom: they
are fixed by \(|K|\).  Nor is the outer sheet action free: it is fixed by
\(\chi\).  The unresolved freedom is entirely the interaction of the
\(K\)-fixed matching-product vector with the modular Fischer tensor
channels.

### Solved-problem analogues

No located result states the Platinum theorem, but several solved problems
have almost exactly the local proof shapes needed here.

| Solved analogue | What was proved there | C665 lesson |
|---|---|---|
| Doty--Henke, tensor products of modular \(\mathrm{SL}_2\)-irreducibles | Tilting summands and Frobenius digits replace the characteristic-zero Clebsch--Gordan rule. | Decompose the Fischer quadratic channels digitwise; do not infer them from weights alone. |
| Parker, higher extensions for \(\mathrm{SL}_2\) | \(\operatorname{Ext}\)-groups between simple and Weyl modules are calculated recursively. | C1 should be an explicit pullback class in \(\operatorname{Ext}^1\), not a composition-factor assertion. |
| Srinivasan--Humphreys--Jeyakumar, projective modules for \(\mathrm{SL}_2(q)\) | Defining-characteristic projective indecomposables and their characters are determined. | Replace the provisional head-existence heuristic by the actual PIM attached to each \(S^K\). |
| Malle--Robinson, projective indecomposable permutation modules | Coset modules induced from \(p'\)-subgroups are classified or strongly restricted using PIM dimensions and subgroup orders. | The desired \(\lambda=1\) conclusion is naturally a “permutation module is only the principal projective” statement. |
| Zavarnitsine, subextensions for a permutation \(\mathrm{PSL}_2(q)\)-module | Existence of a nonsplit cover inside a permutation-module extension is decided cohomologically. | Test whether the quadratic pullback extension splits by its cohomology class. |
| Long--Plaza--Sin--Xiang, maximum intersecting families in \(\mathrm{PSL}_2(q)\) | A high-multiplicity \(\mathrm{PSL}_2\) module problem is solved by retaining the almost multiplicity-free \(\mathrm{PGL}_2\) action and proving constituent survival by finite-field sums. | Outer parity is structure, not bookkeeping; if multiplicities remain large, seek an explicit finite-field sum or Hecke eigenvalue. |
| Segre--Ball--Lavrauw tangent/tensor polynomial method | Secant data of a finite arc is converted into a low-degree polynomial or tensor identity, leaving controlled exceptional cases. | T3 should come from the closed torus matching product and translation norm, not an unbounded field census. |
| Dickson--Faber subgroup classification | A projective-action problem is divided into cyclic, dihedral, exceptional, and subfield cases. | H1/T3 should become a finite mechanism table with rational-conjugacy conditions. |

The closest methodological analogue is Long--Plaza--Sin--Xiang: their
\(\mathrm{PSL}_2(q)\) permutation module has obstructive multiplicities, but
the ambient \(\mathrm{PGL}_2(q)\) action restores an almost
multiplicity-free decomposition.  Their remaining constituent-survival
question becomes an explicit finite-field character sum.  Here the
corresponding move is to retain the two outer parities and express
\(\partial_*\), or the translation norm in T3, as an explicit torus/Hecke
operator.

### Exact missing lemmas

The shortest proof would consist of the following three lemmas.

**L1. Fischer selection.**  For every full-projective matching orbit, its
homogenized affine span is a multiplicity-free filtered selection of the
universal Fischer layers, compatibly with the diagonal outer action.  The
statement must include the Frobenius-twisted layers when \(q\) is not prime.

**L2. Outer projective exclusion.**  If a nonprincipal projective
indecomposable \(Q\) occurs in \(k[H/K]\), the quadratic module
\(\operatorname{Sym}^2(E_\Omega)\) does not contain both \(G\)-extensions
of \(Q\).  A sufficient sharpened version is that, for at least one simple
head \(S\) of the nonprincipal part, only one outer parity of the projective
cover of \(S\) occurs in the quadratic Fischer channels.

**L3. Projective--trade bridge.**  Under the unique-trade hypothesis,
projectivity, self-injectivity of \(kH\), and index-two Clifford theory embed
both outer extensions of every nonprincipal sheet summand into the
quadratic target.  Combining this with L2 forces the sheet module to be the
principal projective alone; its dimension is \(q\), hence \(\lambda=1\).

L3 is close to the already formalized lifting and common-quotient lemmas.
L1 and especially L2 are the real gap.

The linear-algebra core of L3 is now kernel-checked in
`RelativeConicArcs.QuadraticTradeProjectiveBridge`.  Its theorem
`moments_comp_nonprincipalSheets_injective` proves that a moment kernel
supported in the principal coordinates makes the two nonprincipal sheet
copies inject into the quadratic target.
`two_mul_finrank_nonprincipal_le_target` gives the consequent bound
\[
  2\dim Q\le\dim R.
\]
This removes the projective-to-linear embedding ambiguity.  The remaining
part of L3 is the representation-category identification of the two copies
with the two outer extensions; L2 remains the substantive obstruction.

The first attempted closed formula for the outer parity omitted the
projective scaling cocycle of the matching product.  It has therefore been
discarded rather than promoted to a formal lemma.  The exact \(q=19\)
calculation, with the scalar normalization corrected so that
\(\operatorname{Sym}^{12}\otimes\det^{-6}\) descends to
\(\operatorname{PGL}_2(19)\), gives
\[
 \dim\operatorname{Hom}_G(S_{13}^{+},\operatorname{Sym}^2E)=10,
 \qquad
 \dim\operatorname{Hom}_G(S_{13}^{-},\operatorname{Sym}^2E)=0.
\]
Thus all ten \(H\)-maps have one outer parity in the model case, exactly as
L2 predicts.  A uniform proof must derive this parity from the complete
matching-product cocycle, not only from the untwisted Fischer weights.

There is nevertheless a cocycle-free explanation of the part of L2 that
the calculation suggests.  On the point-vector convention, write the
affine conic-fibre module as an extension
\[
  0\longrightarrow F\longrightarrow E
   \mathrel{\mathop{\longrightarrow}^{\epsilon}} \mathbf1
  \longrightarrow0,
\]
where \(F=\ker\epsilon\) is the nonconstant fibre.  Polarization gives the
canonical contraction
\[
 \partial:\operatorname{Sym}^2E\longrightarrow E,\qquad
 \partial(xy)=\epsilon(x)y+\epsilon(y)x,
\]
whose kernel is \(\operatorname{Sym}^2F\).  Thus a simple factor with the
linear outer parity can enter the socle of \(\operatorname{Sym}^2E\) only
through the constant--\(F\) cross channel.

The missing categorical bridge is to prove, with the point-vector and
dual-evaluation conventions fixed, that such a cross-channel socle lift
would split the relevant affine extension after tensoring with that simple
module.  Once that bridge is available, a standard categorical-trace
argument excludes the lift whenever the simple module \(S\) has nonzero
categorical dimension \(\dim_kS\in k^\times\): compose the tensor splitting
with coevaluation and evaluation for \(S\), then divide by \(\dim_kS\), to
split the original extension, contradicting its nonsplitness.  This trace
implication is sound once nonsplitness in the selected convention is
verified; the
identification of the observed quadratic socle lift with that tensor
splitting is not yet proved.  In particular, the decomposition used in the
\(q=19\) calculation must first be transported explicitly between the two
dual module conventions.  The report therefore does not promote this
argument to L2.

The convention audit now fixes this more precisely in the \(q=19\) model.
The matrices in `2026-07-26-c665-q19-module-test.sage` act on the
point-vector module
\[
  0\longrightarrow F\longrightarrow E
  \mathrel{\mathop{\longrightarrow}^{\epsilon}}\mathbf1
  \longrightarrow0.
\]
An exact fixed-space calculation gives
\[
 \dim E^H=1,\qquad \epsilon(E^H)=0,
 \qquad d|_{E^H}=-1
\]
for a nonsquare dilation \(d\).  Hence the \(H\)-fixed line lies inside
\(F\), carries the outer character \(\chi\), and does not split the trivial
quotient.  The affine \(S_{13}\) also has outer parity \(\chi\), so their
symmetric product has parity \(\chi^2=1\).  This explains, rather than
contradicts, the exact quadratic result \(10+0\): the visible
constant-like line is not a \(G\)-trivial splitting line.

The correct C1 object is therefore the pullback of
\[
 0\longrightarrow\operatorname{Sym}^2F
 \longrightarrow\operatorname{Sym}^2E
 \mathrel{\mathop{\longrightarrow}^{\partial}}E
 \longrightarrow0
\]
along a chosen simple embedding \(S^\chi\hookrightarrow E\).
Equivalently, one must determine the outer-eigenspace map
\[
 \partial_*:
 \operatorname{Hom}_H(S,\operatorname{Sym}^2E)
 \longrightarrow \operatorname{Hom}_H(S,E).
\]
At \(q=19\), its target has outer dimensions \(0+1\), while its source has
\(10+0\); the \(\chi\)-eigenspace map is therefore zero and the pullback is
nonsplit.  A uniform proof should compute this pullback class directly.
The earlier tensor-trace proposal is at best one possible way to prove that
nonsplitting after the pullback has been identified; it is not itself C1.

This leaves one sharply delimited representation-theoretic escape:
all nonprincipal heads of \(k[H/K]\) might have dimension divisible by
\(p\).  In defining characteristic these are exactly the heads carrying a
Steinberg Frobenius digit.  The missing subgroup lemma is therefore:
\[
 \tag{H1}
 \lambda>1\quad\Longrightarrow\quad
 k[H/K]\text{ has a nontrivial simple head }S
 \text{ with }p\nmid\dim S,
\]
or, if H1 is false in small-characteristic torus cases, a geometric
argument excluding precisely those cases.  For cyclic and dihedral
stabilizers the candidate must also respect the Weyl involution: the
three-dimensional adjoint simple has a torus-fixed line but the involution
negates it.  Thus it handles a cyclic torus when \(p\ne3\), while for a
full dihedral normalizer the first expected invariant is in the
five-dimensional fourth symmetric layer, valid without further work only
when \(p\ne5\).  Characteristics \(3\) and \(5\) therefore require
digitwise treatment rather than the blanket assertion previously
suggested.  In characteristic \(3\), the trace argument gives no conclusion
even for the cyclic torus.  In fact H1 is false for a full torus in
characteristic \(3\): Steinberg's tensor-product description shows that a
simple of \(3'\)-dimension has only binary Frobenius digits, and its torus
weights are signed sums of distinct powers of \(3\), never zero.

The first Dickson/head pass gives the following exact torus table.  Here a
displayed invariant is fixed by the full torus; in the dihedral rows its
zero-weight vector is also fixed by the Weyl involution.

| stabilizer type | simple candidate | dimension | valid range | residual |
|---|---:|---:|---|---|
| cyclic torus or subgroup | \(L(2)\) | \(3\) | \(p\ne3\) | characteristic \(3\) full-torus cases |
| full dihedral normalizer | \(L(4)\) | \(5\) | \(p\ge7\) | characteristics \(3,5\) |
| full dihedral normalizer | \(L(2)\otimes L(2)^{(1)}\) | \(9\) | \(p=5,\ e\ge2\) | \(q=5\) and characteristic \(3\) |

The signs in this table are elementary: the zero-weight vector of \(L(2)\)
has Weyl sign \(-1\), the one in \(L(4)\) has sign \(+1\), and the tensor of
two \(L(2)\) zero-weight vectors again has sign \(+1\).  Frobenius
reciprocity then places each displayed simple in the head of \(k[H/K]\).
Thus H1 is already reduced, for torus subgroups, to characteristic \(3\)
and the isolated \(q=5\) dihedral endpoint.

The exceptional \(A_4,S_4,A_5\) head calculation is now complete.  For
Steinberg digits \(a=(a_0,\ldots,a_{e-1})\), the direct binary-polyhedral
character average is
\[
 \dim L(a)^K=\frac1{|K|}\sum_C |C|
 \prod_i\left(\sum_{j=0}^{a_i}
 \zeta_C^{\,p^i(a_i-2j)}\right).
\]
The lift orders \((|C|,\operatorname{ord}\zeta_C)\) are
\[
\begin{array}{c|l}
A_4&(1,1),(3,4),(8,6)\\
S_4&(1,1),(9,4),(8,6),(6,8)\\
A_5&(1,1),(15,4),(20,6),(12,10),(12,5).
\end{array}
\]
This computes the invariant in the simple module itself, not merely in a
Weyl module.  Frobenius reciprocity therefore gives the following
nonnegligible heads; omitted trailing digits are zero.

| \(K\) | characteristic/range | simple head | dimension | fixed-space dimension |
|---|---|---|---:|---:|
| \(A_4\) | \(p\ge11\) | \(L(6)\) | \(7\) | \(1\) |
| \(A_4\) | \(p=5,7,\ e\ge2\) | \(L(1)\otimes L(1)^{(1)}\) | \(4\) | \(1\) |
| \(S_4\) | \(p\ge11\) | \(L(8)\) | \(9\) | \(1\) |
| \(S_4\) | \(p=5,\ e\ge2\) | \(L(2)\otimes L(2)^{(1)}\) | \(9\) | \(1\) |
| \(S_4\) | \(p=7,\ e\ge2\) | \(L(1)\otimes L(1)^{(1)}\) | \(4\) | \(1\) |
| \(A_5\) | \(p\ge17\) | \(L(12)\) | \(13\) | \(1\) |
| \(A_5\) | \(p=7,\ e\ge2\) | \(L(3)\otimes L(3)^{(1)}\) | \(16\) | \(1\) |
| \(A_5\) | \(p=11,\ e\ge2\) | \(L(1)\otimes L(1)^{(1)}\) | \(4\) | \(1\) |
| \(A_5\) | \(p=13,\ e\ge2\) | \(L(1)\otimes L(7)^{(1)}\) | \(16\) | \(1\) |

The only prime-field failures allowed by the exceptional-subgroup
congruences are exactly the Platonic endpoints and one enlargement row:
\[
\begin{array}{c|c|c}
(q,K)&\text{head dimensions of }k[H/K]&\text{disposition}\\ \hline
(5,A_4)&1&\lambda=1;\ \text{the matching stabilizer enlarges to }S_4\\
(7,A_4)&1,7&\text{only the Steinberg head is nonprincipal}\\
(7,S_4)&1&\lambda=1\\
(11,A_5)&1&\lambda=1.
\end{array}
\]
The complete \(q=7\) matching census has no matching with full stabilizer
\(A_4\): its \(A_4\)-fixed candidate enlarges to the \(S_4\) stabilizer of
the \(B_3\) sheet.  Thus the Steinberg-only \((7,A_4)\) module is not an
additional matching-stabilizer case.  As exact cross-checks, the
decomposition-matrix calculation gives heads
\[
\begin{array}{c|l}
(11,A_4)&1,7,9\\
(17,S_4)&1,9,13,17\\
(19,A_5)&1,13,
\end{array}
\]
and the direct candidates above occur in the checked \(q=25,49\) extension
fields.  This settles H1 for every exceptional Dickson type.

### Exact quadratic pullback at the \(q=19\) model

The point-vector convention makes the contraction completely explicit:
\[
 \partial(e_0^2)=2e_0,\qquad
 \partial(e_0f)=f,\qquad
 \partial(\operatorname{Sym}^2F)=0.
\]
For \(S=L(12)\), of dimension thirteen, exact intertwiner calculations give
\[
\begin{array}{c|c|c}
&\dim\operatorname{Hom}_H&(+,-)\text{ outer dimensions}\\ \hline
\operatorname{Hom}_H(S,\operatorname{Sym}^2E)&10&(10,0)\\
\operatorname{Hom}_H(S,E)&1&(0,1).
\end{array}
\]
The displayed contraction is checked equivariant for the two \(H\)
generators and a nonsquare dilation.  Its induced map \(\partial_*\) has
rank zero.  Consequently the unique \(\chi\)-parity embedding
\(S^\chi\hookrightarrow E\) has no quadratic preimage, so the pullback
\[
0\longrightarrow\operatorname{Sym}^2F\longrightarrow
S^\chi\times_E\operatorname{Sym}^2E\longrightarrow S^\chi
\longrightarrow0
\]
is nonsplit.  This closes C1 in the \(q=19,A_5\) model and fixes the exact
extension convention; a uniform C1 calculation for every candidate head
is still required.

This is the first genuine residual family, not a cosmetic defect of the
method.  Its first field can nevertheless be excluded exactly.  Over
\(\mathbb F_{27}\), all thirteen matchings invariant under the split torus
pair \(0\) with \(\infty\) and pair the two regular torus orbits by a
torus-equivariant bijection.  They form seven \(G\)-orbits.  Six are split
orbits of size \(756\), with sheets
\[
  378=27\cdot14,
\]
affine rank \(80\), quadratic rank \(609\), and therefore trade dimension
\(756-609=147\).  The seventh orbit has size \(378\), is already one
\(H\)-orbit, and hence cannot support the required sheet sign; its
quadratic trade dimension is \(27\).  The replay is
`2026-07-26-c665-q27-torus-test.sage`.  This exhausts the torus-invariant
matchings at \(q=27\), but it is evidence for, not a proof of, the uniform
characteristic-three torus exclusion.

Accordingly the proposed proof of L2 now has two uniform inputs and one
isolated endpoint:

**C1-uniform. Quadratic pullback nonsplitting.**  In the point-vector
convention, compute the pullback of
\(\operatorname{Sym}^2E\mathrel{\mathop{\to}^{\partial}}E\) along the
relevant \(S^\chi\hookrightarrow E\), and prove it is nonsplit for the
candidate supplied by H1.  The \(q=19,A_5,S=L(12)\) row now passes exactly;
the other subgroup and Fischer selections remain.

**H1-torus. Nonnegligible torus head.**  The exceptional \(A_4,S_4,A_5\)
rows are settled by the table above.  The only remaining H1 rows are the
characteristic-three torus family and the isolated \(q=5\) dihedral
endpoint already identified in the torus table.

**T3. Characteristic-three torus exclusion.**  If
\(q=3^e\) and a split or nonsplit torus normalizer stabilizes a matching
whose \(G\)-orbit splits into two \(H\)-sheets with \(\lambda>1\), then its
quadratic trade space has dimension at least two.

No prime-power-wide proof of C1-uniform, H1-torus, or T3 is claimed here.

There is a second route if L2 fails:

**N1. Translation-norm bound.**  For one sheet's \(U\)-orbit quadratic
moments \(V\) and a nonsquare dilation \(d\),
\[
  \dim(V+dV)\le\lambda+1.
\]
Then the translation-fixed trade space has dimension at least
\(\lambda-1\), so uniqueness gives \(\lambda\le2\).

**N2. Residual subgroup realization.**  Dickson's list and the matching
normalizers exclude the residual \(\lambda=2\) actions, leaving precisely
the \(q=7,S_4\) and \(q=11,A_5\) principal-projective sheets at
\(\lambda=1\).

N1 passes every certified \(q=13,17,19\) test.  It is not yet proved and
does not follow from the universal conic module, whose outer norm
difference is large.

### Platinum-continuation `ej` + `tt` closeout

The cheap upgrade is stronger than the requested finite head table.  The
binary-polyhedral class average is a uniform simple-module calculation, so
the exceptional Dickson types no longer belong to the Platinum mystery:
every non-endpoint family has an explicit nonnegligible head, and the sole
Steinberg-only row is removed by full-stabilizer enlargement.

The q=19 pullback also changes the shape of C1.  Its zero contraction map
does not require a separate recursive \(\operatorname{Ext}^1\) calculation:
equivariance plus the outer decomposition \(10+0\to0+1\) already forces
zero.  The highest-EV uniform continuation is therefore an outer-parity
table for
\[
\operatorname{Hom}_H(S,\operatorname{Sym}^2E)
\quad\text{and}\quad
\operatorname{Hom}_H(S,E)
\]
for the H1 candidates, with an explicit contraction check only when both
parities occur.  What remains genuinely unexplained is whether every
matching-selected Fischer span has the same parity separation; the present
calculation proves it only for the \(q=19,A_5\) model.  Characteristic-three
tori and the \(q=5\) dihedral endpoint remain separate geometric gates.

### Facts that must not be assumed

- A two-valued trade does not by itself say that either sheet is a
  one-factorization; it yields only a \(\lambda\)-fold factorization.
- The observed Fischer selections do not yet constitute a uniform
  decomposition theorem.
- Ten copies of a simple socle in the \(q=19\) universal quadratic module
  do not determine how many full projective covers or which outer parities
  occur.
- The \(q=59\) quadratic samples do not determine the full square rank.
- The exceptional-head theorem comes from the uniform binary-polyhedral
  character average; the finite decomposition-matrix table is a
  cross-check, not a census of subgroup realizations over all fields.
