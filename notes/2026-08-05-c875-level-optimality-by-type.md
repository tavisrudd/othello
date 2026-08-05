# C875 — optimality across the quadric family is a type phenomenon, not an E-series one

**Date:** 2026-08-05
**Task:** C875
**Lane:** `clebsch`
**Status:** parameter comparison only; no new mathematics, no manuscript or Lean file changed

## Why this was run

C874 queued one cheap question.  The exceptional ladder was presented from C682
onward as remarkable partly because every level attained the exact unrestricted
optimum.  Once C872 showed the fold is type-general and C874 showed the
code-level descent is a formal property of any matched Taylor double, the
obvious test is whether that optimality also belongs to the whole quadric
family rather than to the E-series levels.  It mostly does, and the exception
is informative.

## Result

All bounds read from codetables.de on 2026-08-05.

| Type       | Rank | Our code         | Best known \(d\)  | Verdict     |
|------------|------|------------------|-------------------|-------------|
| minus      | 4    | \([10,5,4]\)     | 4, exact          | optimal     |
| plus       | 6    | \([28,7,12]\)    | 12, exact         | optimal     |
| minus      | 6    | \([36,7,16]\)    | 16, exact         | optimal     |
| plus       | 8    | \([120,9,56]\)   | 56, exact         | optimal     |
| minus      | 8    | \([136,9,64]\)   | 64, exact         | optimal     |
| parabolic  | 5    | \([16,6,6]\)     | 6, exact          | optimal     |
| parabolic  | 7    | \([64,8,28]\)    | 29, exact         | one below   |
| parabolic  | 9    | \([256,10,120]\) | 124, exact        | four below  |
| plus       | 10   | \([496,11,240]\) | not tabulated     | uncomparable|

Two conclusions.

**Optimality is not an E-series phenomenon.**  Every tabulated plus-type and
minus-type level attains the exact unrestricted optimum, including the
minus-type levels which have no exceptional label at all.  The framing that
made the ladder look remarkable — optimal at every level — is a property of the
even-rank quadric codes generally.  Anything a manuscript said about the
E-series preserving optimality should be said about the family instead, or not
said.

**The parabolic levels are the ones that fall short, and the deficit grows.**
Rank 5 is optimal, rank 7 misses by one, rank 9 misses by four.  This is the
only place in the family where a systematic gap appears, and it is a cleaner
statement of the same phenomenon C867 recorded as a one-off observation about
the 256-point carrier.  Whether the deficit continues to grow with rank is
untested; the next parabolic level is beyond the length codetables serves over
GF(2).

## Relation to earlier records

C867 reported the \([256,10,120]\) shortfall as a property of the E10 root
hyperplane.  It is better described as the rank-9 member of the parabolic
series, and it is not isolated: the rank-7 member misses too.  Nothing in
C867's arithmetic changes; the interpretation does.

C865's remark that the ladder's optimality "stops at the affine level" is
superseded twice over — once by C872, since the level in question is the link
rather than a level code, and once here, since optimality was never an
E-series property to lose.

## Evidence and replay

This report is a parameter comparison against a public table, not a
computation.  The eight code parameters are produced by
`2026-08-05-c872-fold-type-generality.py`, whose replay command and hashes are
in that bundle.  The bounds were read from codetables.de on 2026-08-05 at
`BKLC/BKLC.php?q=2&n=<n>&k=<k>` for each pair in the table above.  No claim here
rests on anything else.

## Mystery ledger

- **Settled — optimality is family-wide across even rank**, both types, not an
  exceptional-series phenomenon.
- **Open — why parabolic type falls short, and why the deficit grows** from zero
  at rank 5 to one at rank 7 to four at rank 9.  No mechanism is offered.  This
  is now the only genuinely unexplained numerical pattern left on the ladder
  side, and it is the same object as the four-unit gap C874 named as the one
  live mathematical target.
- **Open — the rank-10 plus level** is beyond the public table, so the
  even-rank pattern is confirmed only up to rank 8.
