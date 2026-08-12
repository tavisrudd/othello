# C909 — hostile audit of the proposed full Dyck-height defect theorem

Date: 2026-08-11  
Status: hostile audit; no manuscript, PDF, mirror, Lean, or commit change

## Verdict: MAJOR (the formula is plausible, but not proved)

The numerical formula in `notes/2026-08-11-c909-full-graded-etale-hodge-defect.md`
matches the independently computed squarefree Smith data for `k<=6`, including
the Dyck exact-height multiplicities.  The earliest blocking defect is the
**Filtered matching lemma**, especially (13)--(14).  Its paragraph is a
heuristic web/elimination sketch, not a proof of a unitriangular basis over an
arbitrary unramified DVR.  Since (17) and hence the full formula (4) depend
entirely on that lemma, the current status cannot be GO.

The right grade is **MAJOR**, with a clean conditional theorem available:
retain (4) as conditional on the filtered matching lemma and a repeated-slot
factorization lemma; retain the explicit `k<=6` Smith rows as proved finite
computations.  No numerical counterexample was found, including in small
characteristic two tests.

## 1. Exact indexing check: the Dyck data are correct

For exact maximum height, the Dyck distributions are

\[
\begin{array}{c|l}
\ell& H(\ell,h)_{h=1}^\ell\\ \hline
1&(1)\\
2&(1,1)\\
3&(1,3,1)\\
4&(1,7,5,1)\\
5&(1,15,18,7,1)\\
6&(1,31,57,33,9,1).
\end{array}
\]

The target note's displayed rows through `ell=5` are correct.  The `ell=6`
row is not displayed there, but the audited Smith calculation gives

\[
 0,1^9,2^{33},3^{57},4^{31},5,
\]

which is exactly `H(6,h)` with quotient exponent `ell-h`:

\[
 H(6,1)=1\mapsto5,\quad H(6,2)=9\mapsto4,\quad
 H(6,3)=33\mapsto3,\quad H(6,4)=57\mapsto2,\quad
 H(6,5)=31\mapsto1,\quad H(6,6)=1\mapsto0.
\]

Thus the target formula (5) is indexed correctly.  The phrase in the proof
that the elimination “retains exactly the webs whose path never rises above
`ell-r`” needs repair: that describes a spanning set for `F^r` (cumulative
height `<=ell-r`), whereas (14) is the quotient `F^r/F^{r+1}` and requires
**exact** height `ell-r`.  The equations are consistent; the prose is not.

## 2. Independent Smith audit

On `2ell` distinct slots, after multiplying each off-diagonal divisor by
`p^{2a}`, the matching columns have the block form

\[
 [F_{ell,0};\ p^aF_{ell,1};\ \ldots;\ p^{aell}F_{ell,ell}],
\]

where the row block `r` has exactly `2r` letters `Y`.  Row reduction for
`t_i=i`, `p=101`, and noncrossing matching columns gives cumulative ranks

\[
\begin{array}{c|l}
ell&(rho_{ell,0},\ldots,rho_{ell,ell})\\ \hline
1&(1,1)\\
2&(1,2,2)\\
3&(1,4,5,5)\\
4&(1,6,13,14,14)\\
5&(1,8,26,41,42,42)\\
6&(1,10,43,100,131,132,132).
\end{array}
\]

Consecutive differences reproduce the target Dyck rows.  Repeating the rank
calculation with random distinct `t_i` in `F_101` gives the same profiles for
`ell=3,4,5`; random distinct elements of `F_16` give the same profiles for
`ell=2,3,4` in characteristic two.  These are audits, not an all-`ell`
proof, but they remove the obvious small-parameter and dyadic counterexamples.

The target note should state this as “verified for `ell<=6`” until the
all-`ell` rank/straightening argument is supplied.

## 3. Earliest exact failure: the filtered matching lemma

The target calls (13)--(14) an “integral standard-monomial fact,” but no
source cited there proves it.  DCEP's *Hodge algebras*, §11, Theorem 11.1,
supports the unweighted Grassmannian minor algebra over `R=Z`: standard
monomials form a free basis and the Plücker straightening has integral
coefficients.  It does **not** state the following additional assertions:

1. the exterior squarefree contraction module is equipped with the specific
   `Y`-degree filtration induced by the graph shear;
2. the filtration's graded ranks are exact Dyck maximum-height counts;
3. the straightening transition has unit pivots for every collection of
   pairwise-distinct etale parameters in every residue characteristic; or
4. the resulting basis gives the Smith factors `p^{a(ell-h)}`.

The formal substitution `u_i=t_i-p^az_i` explains why the three-term
relation remains valid, but it does not prove the claimed pivot pattern.  In
particular, “reading the web from left to right” and “open-arc count is the
height” do not specify an ordered basis, an elimination matrix, or an
induction showing that each pivot is a unit.  A proof must provide one of:

* an explicit induction on `ell` and the first return decomposition of Dyck
  paths, with the filtration maps and their unit minors written down; or
* a fully stated integral Schur/standard-monomial filtration theorem whose
  hypotheses include the graph shear and whose conclusion is (13)--(14).

Until then (17) is conditional, not an established all-codimension theorem.

## 4. Correct filtration statement and repair

The definition “no monomial with fewer than `r` letters `Y`” gives a decreasing
filtration

\[
 F^0M\supseteq F^1M\supseteq\cdots\supseteq F^ellM.
\]

If `e_gamma` has leading `Y`-degree `d=ell-ht(gamma)`, then

\[
 e_gamma\in F^d\setminus F^{d+1},\qquad
 \operatorname{rank}(F^r/F^{r+1})=H(ell,ell-r).
\]

The cumulative rank is instead

\[
 \operatorname{rank}(F^r)=B(ell,ell-r)
 =\sum_{h\le ell-r}H(ell,h).
\]

The target's formula (16) is correct, but its proof paragraph should replace
“retains exactly the webs whose path never rises above `ell-r`” by the
cumulative statement above, then identify the new quotient layer by exact
height.

## 5. Dyadic and general unit-form audit

There is no forced factor of two in the contraction identity.  With the
displayed `Omega_ij`, the four-slot relation has coefficients `+1` (up to
orientation signs); in characteristic two signs coalesce but remain units.
The small `F_16` computations reproduce the odd-prime ranks.

One sentence in the target is too strong, however: “rescaling [the
one-dimensional restrictions of a source unit form] reduces to (7)--(10)”
need not hold at `p=2`, because a unit need not have a square root in an
unramified dyadic extension.  The repair is harmless but necessary: retain
the unit coefficients `b_i` of the orthogonal root lines throughout (1), and
show that every web pivot is a unit times a product of differences and
`b_i`.  Do not claim diagonal rescaling to the identity unless the required
square roots are actually present.

The etale self-adjoint decomposition itself is adequate: distinct roots make
the eigenspaces orthogonal, and unimodularity makes each one-dimensional
restriction a unit.  What needs proof is only the weighted-unit version of
the filtered lemma.

## 6. Repeated-support factorization audit

The multidegree count

\[
 N(g,k,ell)=\binom g{k+ell}\binom{k+ell}{k-ell}
\]

is correct for support type `(2^{k-ell},1^{2ell})`.  The claimed reduction to
volume factors is also algebraically plausible, but it is not justified by
DCEP alone.  The needed integral identity is the exterior contraction
straightening, for distinct `i,j,k`,

\[
 \Omega_{ij}\Omega_{ik}=\pm\Omega_{ii}\Omega_{jk},
\tag{R1}
\]

with coefficient exactly a unit (no `2`).  Iterating (R1), with careful signs,
must show that every matching in a repeated-support multidegree is an
integral unit combination of products of the doubled-slot volumes and a
squarefree noncrossing matching.  It must also show that this identity is
compatible with the **weighted** graph generators `D_i=p^aOmega_ii` and
`C_ij=p^{2a}Omega_ij`; otherwise mixed matchings could alter the claimed
component scale.

The target's formula (12) is only a support count, not this factorization
proof.  Add R1 and an induction on the number of doubled slots, then state
that the split product lattice is block diagonal by slot multidegree.  Until
that is written, (4) is at most a conditional sum of squarefree blocks.

## 7. Descent and away-from-`p` statements

Faithfully flat unramified descent of invariant factors is sound once the
split quotient is known: finite modules over a DVR are classified by the
dimensions of `p^{r-1}Q/p^rQ`, and flat base change preserves these ranks.
The note should say “the invariant-factor multiset descends”; the individual
Dyck/multidegree labels generally do not descend canonically.

The away-from-`p` vanishing requires one explicit integral contraction-basis
lemma for the literal elliptic power.  It is standard and compatible with
DCEP's `R=Z` Plücker straightening, but the target currently states it without
proof or a source pinpoint.  This is a minor repair compared with the
filtered-web gap.

## Final grade and exact repair list

**MAJOR.** Keep the numerical rows and (4) as a clearly labelled conditional
theorem/prediction.  To upgrade to GO:

1. prove the all-`ell` filtered matching lemma with an explicit unitriangular
   basis or a precise integral Schur-filtration theorem;
2. correct cumulative-versus-exact-height wording;
3. carry unit root-form coefficients instead of dyadically rescaling them
   away;
4. prove repeated-support factorization via (R1), with weighted scales; and
5. supply the integral contraction-basis argument away from the graph prime.

No counterexample to the proposed Dyck profile was found for `ell<=6`; the
obstruction is proof completeness, not presently a numerical contradiction.
