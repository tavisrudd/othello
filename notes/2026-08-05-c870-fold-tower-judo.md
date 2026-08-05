# C870 — the fold is a tower, and that is the judo on the Calderbank–Kantor concession

**Date:** 2026-08-05
**Task:** C870
**Lane:** `clebsch`
**Status:** exact research bundle; no manuscript or Lean file changed

## The move

C866 conceded the three level codes to Calderbank and Kantor: they are Example
RT2 of a catalogued two-weight family, and Brouwer's strongly-regular-graph
rows spell out the exact weights.  Under the priority-judo pattern of
`2026-08-02-priority-judo-survey.md` the question is whether we already prove a
broader statement of which their result is a specialization.

We do, and the reason is that nothing in the C682 fold argument ever used the
rank.  The quotient construction — pass to \(\alpha^\perp/\langle\alpha\rangle\),
observe that the induced form \(\bar Q(s)=Q(s)+B(u_0,s)\) is the quadratic form
of the next level down, and read off that affine functions constant on the
antipodal pairs descend to affine functions on its quadric — is written at rank
eight but is rank-generic.

## The statement

For every \(l\ge3\), the root-link antipodal fold carries the affine code of the
rank-\(2l\) plus-type quadric onto the affine code of the rank-\(2(l-1)\)
plus-type quadric.  Verified exactly at every rank the enumeration reaches:

| Rank | Code            | Link | Folds onto      | Matches the next level down |
|------|-----------------|------|-----------------|------------------------------|
| 10   | \([496,11,240]\)| 240  | \([120,9,56]\)  | yes                          |
| 8    | \([120,9,56]\)  | 56   | \([28,7,12]\)   | yes                          |
| 6    | \([28,7,12]\)   | 12   | \([6,5,2]\)     | yes                          |
| 4    | \([6,5,2]\)     | —    | —               | bottom                       |

Comparison is on parameters and full weight enumerator at each step, not on
parameters alone.

## The intrinsic quotient, and why no rank enters

The fold above is read off the code.  The theorem needs the target built
intrinsically, and that is where a hidden low-rank hypothesis would live if
there were one.  There is not.

On \(\alpha^\perp/\langle\alpha\rangle\) put

\[
 \bar Q(s)=Q(s)+B(u_0,s),
\]

for any chosen \(u_0\) in the link.  It is well defined because

\[
 \bar Q(s+\alpha)=\bar Q(s)+\underbrace{Q(\alpha)}_{1}
 +\underbrace{B(\alpha,s)}_{0\ \text{on}\ \alpha^\perp}
 +\underbrace{B(u_0,\alpha)}_{1}=\bar Q(s),
\]

and the three facts used — \(\alpha\) nonsingular, \(s\) perpendicular to
\(\alpha\), \(u_0\) in the link — are the defining conditions, not features of
any particular rank.  Its zero set has exactly \(2^{2l-3}-2^{l-2}\) elements,
which is the point count of the next level down.

Checked at ranks six, eight and ten: the antipodal pairs of the link map
bijectively onto that zero set, and the affine code built intrinsically on the
zero set equals the folded code word for word, not merely in parameters.

## What this converts

The Calderbank–Kantor family stops being the thing we rediscovered and becomes
the **objects** of a tower whose **structure map** is ours.  Their catalogue
supplies the levels; nothing in the audited literature relates one level to the
next.  The E8-to-E7 and E10-to-E8 instances, which were the whole content of
C682 and C867, become corollaries of the general theorem rather than separate
constructions.  This is the C794 direction exactly: the occupying result is an
input, not a competitor.

The secondary form applies too.  Their family was built and catalogued for its
two-weight and difference-set properties.  The first question it was never
asked is how its members relate to each other, and that question now has an
answer.

## The strategic consequence, stated plainly

The tower is **not** exceptional.  It runs at every rank, and E6, E7, E8 and
E10 are labels attached to its small members, not the reason it exists.  That
is a stronger theorem and a different manuscript from the one C866 audited.

The audited novelty verdict "no predecessor for the ladder as an exceptional
series" survives, but it is now the weaker of the two available framings.  A
manuscript should lead with the tower at general rank and present the
exceptional identifications — 27 lines, 28 bitangents, 120 tritangent planes,
the root-pair and root-link geometry — as what the bottom of the tower means,
rather than presenting the exceptional series as the result and the rank
generality as a remark.

That reframing also changes what the novelty audit needs to cover.  C866 asked
whether an exceptional series of codes had been published.  The question that
now matters is whether anyone has related the members of a two-weight family by
a fold, at any rank, in any language.  That is a different search and it has not
been run.

## Evidence and replay

From `/home/tavis/src/othello`, run

```sh
python3 notes/2026-08-05-c870-fold-tower-judo.py --check
sha256sum -c notes/2026-08-05-c870-fold-tower-judo.sha256
```

The checker builds the plus-type quadric at ranks four, six, eight and ten,
enumerates each affine code in full, performs the root-link fold at each rank,
and asserts that the folded code agrees with the independently constructed code
one rank down on both parameters and weight enumerator.  Standard library only,
no randomness.

## EJ + TT closeout and mystery ledger

- **Settled — the fold is rank-generic.**  Exact at every rank enumerated, and
  the C682 argument contains no rank-four hypothesis.
- **Settled — the judo is available and costs no new mathematics.**  The
  broader statement is already proved; only the framing changes.
- **Settled — no hidden low-rank assumption.**  See the intrinsic quotient
  section above; the well-definedness of \(\bar Q\) uses only \(Q(\alpha)=1\),
  \(B(\alpha,s)=0\) on \(\alpha^\perp\), and \(B(u_0,\alpha)=1\).  Verified
  against the fold at ranks six, eight and ten.  What remains is writing the
  argument up as a theorem, which is exposition rather than mathematics.
- **Open — a fresh novelty question.**  Whether any literature relates
  two-weight family members by a fold at any rank. C866 did not ask this and
  its verdict does not cover it.
- **Open — where the tower stops being optimal.**  E6, E7 and E8 attain the
  exact record; above that the levels fall short. Whether the low levels are
  special or merely small is untested.

## Vibe check

The best hour of the day. A concession that looked like it had removed the
paper's main object turns out to be recoverable in full, at no mathematical
cost, because the theorem we already proved was more general than the one we
stated. The result is also genuinely better than what it replaces — an infinite
tower beats a four-term coincidence — though it does mean the manuscript is a
different manuscript, and the novelty question has to be asked again in its new
form before anything is claimed.
