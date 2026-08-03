# C756 — the coupled pair invariant (twenty-seventh pass)

**Lane**: `clebsch` · **Date**: 2026-08-02 · **Task**: C756, saturated-internal branch,
acting on the twenty-sixth pass's "couple both halves of the crown" lever

## Verdict

A reduction and a canonical coordinate, **not** a closure, and the most useful thing this
pass produces is a sharp reason why the obvious way to finish does not work.

The twenty-sixth pass observed that gate 1 used only the independence half of the crown
and gate 2 only the bipartite half, and that the two \(q=5\) frames are extremal for both
at once.  Acting on that: there is a single quantity carrying both halves, namely the
cross-ratio of the two conjugate point-pairs,
\[
  g_{ij}=\frac{(z_i-z_i^q)(z_j-z_j^q)}{N(z_i-z_j)}\in\mathbb F_q^\times ,
\]
which is the unique \(\mathrm{PGL}(2,q)\)-invariant of an unordered pair of irrational
conjugate pairs.  Condition (A) reads \(\chi_q(\alpha_{ij})=\delta\) with
\(\alpha_{ij}=N(z_i-z_j)\), and — given (A) — condition (B) reads exactly
\(\chi_q(1-g_{ij})=-1\).

That places the \((q+1)/2\) entries of every row of \(g\) inside a set of size exactly
\((q-1)/2\).  The counts are one apart, which is the same knife-edge that Theorems 2 and 6
end on — but here it cuts the wrong way.  It forces collisions rather than forbidding
them, so the branch does **not** close by this route.  What it gives instead is an exact
statement of what a successor must prove, and the observation that the \(q=5\) frames
again sit exactly on the boundary: their rows realize the forced minimum of one collision,
no more.

## 1. The invariant

Write \(z=a+sc\) with \(a,c\in\mathbb F_q\), \(s^2=\varepsilon\); irrationality is
\(c\ne0\).  Set \(\alpha_{ij}=N(z_i-z_j)\), \(\beta_{ij}=N(z_i-z_j^q)\), and
\(\eta_i=\chi_q(c_i)\).

> **Theorem 9.**  For \(z_i\ne z_j,z_j^q\):
>
> 1. \(g_{ij}\in\mathbb F_q^\times\), \(g_{ij}=g_{ji}\), and \(g_{ij}\) is the cross-ratio
>    of \((z_i,z_i^q;z_j,z_j^q)\); it is invariant under \(z\mapsto az+b\) with
>    \(a\in\mathbb F_q^\times\), \(b\in\mathbb F_q\).
> 2. \(\beta_{ij}=\alpha_{ij}-4\varepsilon c_ic_j=\alpha_{ij}\,(1-g_{ij})\).
> 3. Condition (A) is \(\chi_q(\alpha_{ij})=\delta\).  Given (A), condition (B) is
>    equivalent to \(\chi_q(1-g_{ij})=-1\), and moreover
>    \(\chi_q(g_{ij})=-\delta\,\eta_i\eta_j\).

*Proof.*  Expanding norms, \(\alpha_{ij}=N_i+N_j-\operatorname{Tr}(z_iz_j^q)\) and
\(\beta_{ij}=N_i+N_j-\operatorname{Tr}(z_iz_j)\), whose difference is
\(\operatorname{Tr}(z_iz_j)-\operatorname{Tr}(z_iz_j^q)=(z_i-z_i^q)(z_j-z_j^q)=4\varepsilon c_ic_j\),
giving (2).  Then \(\chi_q(\beta)=\chi_q(\alpha)\chi_q(1-g)\), so under (A) the
condition \(\chi_q(\beta)=-\delta\) is \(\chi_q(1-g)=-1\).  Finally
\(\chi_q(g)=\chi_q(4\varepsilon)\eta_i\eta_j\chi_q(\alpha)=-\delta\eta_i\eta_j\) using
\(\chi_q(\varepsilon)=-1\) and (A).  The cross-ratio and invariance claims are the
displayed formula. \(\square\)

Three remarks on what is and is not new here.

*The character condition itself is a repackaging.*  \(\chi_q(1-g_{ij})=-1\) is
\(\chi_q(\alpha_{ij})\chi_q(\beta_{ij})=-1\), which is the chord-externality condition
known since the earliest passes and already identified there as the one
\(\mathrm{PGL}(2,q)\)-invariant part of coherence.  This pass does not add a condition.

*What is new is the coordinate.*  Identifying that invariant as \(1-g\) for the canonical
cross-ratio \(g\) makes both halves functions of one \(\mathrm{PGL}(2,q)\)-invariant
matrix, which is what the lever asked for and what no earlier pass had.  The
scope caveat of the twenty-fifth pass — coherence is not \(\mathrm{PGL}(2,q)\)-invariant,
only the triple products are — is now precisely located: the non-invariant content is
entirely in (A), i.e. in \(\chi_q(\alpha)=\delta\), while (B) relative to (A) is
invariant.

*A third coboundary.*  \(\chi_q(g_{ij})=-\delta\eta_i\eta_j\) is a coboundary in the signs
\(\eta_i=\chi_q(c_i)\), following from (A) alone.  This is the third coboundary in the
branch, after the circle identity of gate 1 and the Möbius twist of the twenty-fifth pass.
It carries no information beyond (A), but it splits each row of \(g\) into two blocks by
\(\eta_j\), which is what makes the count of §2 exact rather than approximate.

## 2. The count, and why it cuts the wrong way

> **Lemma 9.1.**  \(\#\{x\in\mathbb F_q:\chi_q(x)=u,\ \chi_q(1-x)=v\}
> =\tfrac14\bigl(q-2-u-v+uv\,\delta\bigr)\), and
> \(\#\{x:\chi_q(1-x)=-1\}=(q-1)/2\), a set not containing \(0\).

This is the standard Jacobi-sum count with \(\chi_q(-1)=-\delta\).

Fix \(i\).  The row \((g_{ij})_{j\ne i}\) has \(n-1=(q+1)/2\) entries, all lying in the
set of Lemma 9.1, of size \((q-1)/2\).  Splitting by \(\eta_j\), the entries with
\(\eta_j=+1\) lie in a subset of size \(\tfrac14(q-1-(1+\delta)(-\delta\eta_i))\) and
those with \(\eta_j=-1\) in the complementary subset.

> **Corollary 9.2.**  For every \(i\), at least one collision \(g_{ij}=g_{ik}\) with
> \(j\ne k\) is forced.

Had the inequality gone the other way — had a row been forced to have more distinct
values than the target set holds — the branch would close immediately by the integer
inequality \((q+1)/2\le(q-1)/2\), in exactly the style of Theorem 2's \(q-2\le(q+1)/2\)
and Theorem 6's coset bound.  It does not.  The pigeonhole is off by one in the direction
that forces structure rather than contradiction, so **this route cannot close the branch
as it stands**, and saying so is the point of recording it.

The successor statement is therefore a distinctness lower bound, not an injectivity claim:
the branch closes if one proves that for \(q>5\) a coherent row must take more than
\((q-1)/2\) distinct values.  Unwinding, \(g_{ij}=g_{ik}\) is
\(c_j\,N(z_i-z_k)=c_k\,N(z_i-z_j)\), a conic condition on \(z_j,z_k\) relative to \(z_i\),
whose fibres have about \(q\) points — so the collisions are not rare and any such bound
must come from the interaction of many rows, not from one.

## 3. Verification

`2026-08-02-c756-coupled-pair-invariant.py` checks, over \(q=5,7,11,13\) and over **all**
irrational pairs, that \(g\) is rational-valued, symmetric, equal to the stated
cross-ratio, and invariant under the rational affine group; the identity
\(\beta=\alpha-4\varepsilon c_ic_j=\alpha(1-g)\); the equivalence of (B) with
\(\chi_q(1-g)=-1\) under (A) and the coboundary formula for \(\chi_q(g)\); and Lemma 9.1's
four class counts against the closed form.  None of these assume coherence, so the algebra
is tested where the hypothesis is unavailable.

At \(q=5\) it brute-forces the coherent systems and confirms every \(g\)-value lies in the
target set, reporting the row profile.

```sh
cd notes
python3 2026-08-02-c756-coupled-pair-invariant.py
```

| \(q\) | \(\delta\) | row length \((q+1)/2\) | target size \((q-1)/2\) | Thm 9 | Lemma 9.1 | \(q=5\) rows |
|---:|---:|---:|---:|---|---|---|
| 5  | \(-1\) | 3 | 2 | ok | ok | 10 systems; every row \((3\text{ entries},2\text{ distinct})\) |
| 7  | \(+1\) | 4 | 3 | ok | ok | — |
| 11 | \(+1\) | 6 | 5 | ok | ok | — |
| 13 | \(-1\) | 7 | 6 | ok | ok | — |

Artifacts:

- `2026-08-02-c756-coupled-pair-invariant.py`
  `ec11f11132129f0b5818252eb50312c479076bffb3147a1cd1f3f4ed4ef83372`
- `2026-08-02-c756-coupled-pair-invariant.json`
  `51cef91b368d5f08c3ee5f0b1acee2eab5e05a4aaa852f5a6e2bf7d6f909e609`

## 4. EJ + TT closeout

**EJ.**  One upgrade taken, one declined.

*Taken: the frames are extremal a third time.*  Every row of both \(q=5\) frames has
exactly \(2\) distinct values among \(3\) entries — precisely the one collision Corollary
9.2 forces, and not one more.  This joins Theorem 2's tight inequality \(q-2\le(q+1)/2\)
and Theorem 6's saturated \(\lambda\)-coset.  Three independent boundary conditions, all
tight at \(q=5\) and all slack elsewhere, is now a pattern rather than a coincidence, and
it says the frames are best understood as the simultaneous equality case of a family of
counting bounds rather than as a sporadic configuration.

*Declined: chasing the row-distinctness bound computationally.*  There are no coherent
systems above \(q=5\) to measure, so any empirical distinctness profile would be collected
on non-coherent configurations and would not bear on the question.  Recorded as
unmeasurable by this method rather than untried.

**TT.**  The Tao-style question this pass answers is *where exactly does the non-invariance
live?*  The branch has carried a scope caveat since the twenty-fifth pass — coherence is
not preserved by \(\mathrm{PGL}(2,q)\), only its triple products are — and that caveat has
been a standing obstacle to importing projective tools.  Theorem 9 localizes it completely:
relative to (A), condition (B) is invariant, and all the non-invariance is in (A) alone.
So projective methods are available for the bipartite half and forbidden for the
independence half, which is a usable division of labour rather than a blanket restriction.

The skeptical check that matters here is whether Theorem 9 smuggles in new content.  It
does not: §1 states explicitly that \(\chi_q(1-g)=-1\) is the known chord-externality
condition rewritten.  The pass's contribution is a coordinate and an exact count, and its
main finding is negative — the count is off by one in the unhelpful direction.

## 5. Mystery ledger

| mystery | status | exact gap / owner |
|---|---|---|
| Is there one object carrying both halves of the crown? | **settled** | Theorem 9: the cross-ratio \(g_{ij}\) of the two conjugate pairs |
| Where does the failure of \(\mathrm{PGL}(2,q)\)-invariance live? | **settled** | entirely in condition (A); (B) relative to (A) is invariant |
| Does the coupled invariant close the branch by pigeonhole? | **settled negatively** | Corollary 9.2: the count forces collisions instead of forbidding them, off by one in the wrong direction |
| Why are the \(q=5\) frames extremal so often? | partially settled; newly sharpened | three independent tight counting bounds now; no single mechanism yet explains all three |
| Row-distinctness lower bound for \(q>5\) | **open — the successor target** | collisions are conic conditions with \(\approx q\)-point fibres, so a bound must couple many rows; unmeasurable below the theorem since no systems exist above \(q=5\) |
| Saturated-internal branch as a whole | open | unchanged: gate 1's Baer-subline stability statement remains the one sufficient target |
