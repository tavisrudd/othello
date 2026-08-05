# C872 — the fold is a plus-type phenomenon, so the code statement is not a graph corollary

**Date:** 2026-08-05
**Task:** C872
**Lane:** `clebsch`
**Status:** exact research bundle; no manuscript or Lean file changed

## Why this was run

C871 found the fold pre-empted: Brouwer and Shult state at general rank that
the distance-two vertices of the nonsingular-points graph of an \(\mathbf F_2\)
quadratic form form the Taylor extension of the graph two ranks down, an
antipodal double cover whose classes are our fold.  On that basis C871 judged
the surviving code-level statement too thin to carry anything, and that
judgement was accepted without testing whether the code statement follows from
the graph statement.  It does not.

## The result

Run the fold at plus, minus and parabolic type.  The **point count** descends
correctly every time — which is exactly what a graph-level antipodal quotient
predicts.  The **code** descends in full only at plus type.

| Type       | Rank | Code             | Link | Folds to        | Next level's code | Full descent |
|------------|------|------------------|------|-----------------|-------------------|--------------|
| plus       | 6    | \([28,7,12]\)    | 12   | \([6,5,2]\)     | \([6,5,2]\)       | yes          |
| plus       | 8    | \([120,9,56]\)   | 56   | \([28,7,12]\)   | \([28,7,12]\)     | yes          |
| plus       | 10   | \([496,11,240]\) | 240  | \([120,9,56]\)  | \([120,9,56]\)    | yes          |
| minus      | 6    | \([36,7,16]\)    | 20   | \([10,3,2]\)    | \([10,5,4]\)      | no           |
| minus      | 8    | \([136,9,64]\)   | 72   | \([36,4,4]\)    | \([36,7,16]\)     | no           |
| parabolic  | 7    | \([64,8,28]\)    | 32   | \([16,4,2]\)    | \([16,6,6]\)      | no           |
| parabolic  | 9    | \([256,10,120]\) | 128  | \([64,5,4]\)    | \([64,8,28]\)     | no           |

At plus type the dimension drops by exactly two and lands on the next code.
Away from plus type the constant-on-pairs condition destroys far more: rank-8
minus loses five dimensions instead of two, rank-9 parabolic loses five instead
of two, and the folded minimum distances collapse with them.

**Consequence.**  If the graph-level statement is type-general — its hypothesis
is a quadratic form over \(\mathbf F_2\), with no type restriction visible in
the quotation available to us — then the code-level fold cannot be a formal
consequence of it, because it would then have to hold wherever the graph
statement holds, and it does not.  The code descent sees the Arf invariant; the
antipodal-cover structure does not.

This is a conditional claim in one place only: we hold Brouwer and Shult (1990)
as quoted by Brouwer and Van Maldeghem, not at full text, so the exact scope of
their hypothesis is not verified here.  Obtaining it is now the single
highest-value read in the lane, because it decides whether the residue is thin
or is the actual theorem.

## Second result: the tetrad count in closed form, hence CSS distance at every rank

The nonsingular set of any \(\mathbf F_2\) quadratic form is a **perfect
difference set**: every nonzero vector occurs as a difference the same number of
times,

\[
 \lambda=\frac{N(N-1)}{2(2^n-1)}.
\]

Verified at every type and rank enumerated.  Since a dual word of weight two is
impossible (the points are distinct) and one of weight three is impossible (the
constant row forces even weight), the dual distance is four exactly when the
tetrad count is nonzero, and that count is

\[
 T=\frac{(2^n-1)\,\lambda(\lambda-1)}{6}.
\]

| Type  | Rank | \(N\) | \(\lambda\) | \(T\)     |
|-------|------|-------|-------------|-----------|
| plus  | 6    | 28    | 6           | 315       |
| plus  | 8    | 120   | 28          | 32,130    |
| plus  | 10   | 496   | 120         | 2,434,740 |
| minus | 6    | 36    | 10          | 945       |
| minus | 8    | 136   | 36          | 53,550    |

So **every level of every family has CSS distance exactly four**, at every rank
and type, by formula rather than by search.  This replaces the four separately
observed coincidences of C682, C865, C867 and C868 with one statement, and it
removes the computational cap that made the earlier claim rank-limited.

## Third result: the odd-form coincidence is a translation

The fold target was described by an odd form \(\bar Q\) while the next level is
described by the nonsingular set of a plus-type form.  The two agreed and we
never said why.  The reason is one line: for nonsingular \(t\),

\[
 Q(x+t)=Q(x)+Q(t)+B(t,x)=Q'(x)+1,
 \qquad Q'(x):=Q(x)+B(t,x),
\]

so \(Q'\) is a quadratic form of the opposite type and its zero set, translated
by \(t\), is the nonsingular set of \(Q\).  Affine codes are translation
invariant, so the two descriptions give the same code.  Verified at rank eight.

## Evidence and replay

From `/home/tavis/src/othello`, run

```sh
python3 notes/2026-08-05-c872-fold-is-plus-type-only.py --check
sha256sum -c notes/2026-08-05-c872-fold-is-plus-type-only.sha256
```

The checker constructs plus, minus and parabolic forms, verifies each
nonsingular count against its closed form, performs the fold at each, and
asserts that full code descent happens exactly at plus type — the assertion is
two-sided, so it fails if any non-plus case descends or any plus case does not.
It verifies the perfect-difference-set property by requiring a single
repetition number across all nonzero differences, checks the closed-form tetrad
count against a direct pair-sum count, and verifies the translation identity as
a set equality.

## EJ + TT closeout and mystery ledger

- **Settled — the code fold is plus-type only.**  Two-sided assertion at seven
  cases across three types.
- **Settled — CSS distance four at every rank and type.**  Closed form, no cap.
- **Settled — the odd-form coincidence.**  A translation by a nonsingular
  vector, which flips the type.
- **Open, and now the lane's highest-value read — Brouwer and Shult (1990) at
  full text.**  If their hypothesis is type-general, the code-level fold is
  strictly stronger than their statement and the residue is a real theorem. If
  their statement is itself plus-type only, the two claims are much closer and
  the residue stays thin.
- **Open — why plus type.**  The computation shows the Arf invariant controls
  the descent; no structural reason is offered here.  That question is the
  natural core of any write-up.
- **Open — Hyun and Hu (2026)**, still at review only, still the other live
  risk to the residue.

## Vibe check

The concession was premature and this pass overturns it. An hour of cheap
computation moved the surviving statement from "too thin to write up" to
"conditional on one unread paper, and if that paper is type-general then we have
a theorem the graph literature does not." It also produced the general-rank CSS
result for free and closed the one unexplained coincidence in the construction.
The lane is not out of the woods — one unread source decides it — but the shape
is much better than it was this morning.
