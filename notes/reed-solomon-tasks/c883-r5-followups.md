# C883 — redundancy-five follow-ups from the Kaipa and Tao passes

**Lane:** `reed-solomon`

**Status:** queued; allocated 2026-08-07.

**Origin:** the closeout passes on C881.  The Krishna Kaipa persona review supplied the
literature and incidence direction; a Terence Tao pass on the finished section supplied the
framing and generalization items.  The two cheap Tao items were applied inside C881: the
two-sided split-member count `cor:r5-equidistribution`, and the removal of the claim that
the elliptic route was a second argument rather than the same one in other coordinates.

**Promotion rule for this task.**  Each item below is developed as its own result with its
own gate.  When an item is proved and passes an independent review, it may be promoted into
the Version 2 manuscript under this same C-ID rather than being re-allocated.  Items that
fail or stall are recorded here and, if they leave a usable observation behind, logged to
the discovery track.

## Standing gates: every item carries a math check and a literature check

Both gates bind each item separately.  An item is not finished, and is not eligible for
promotion into the manuscript, until both are recorded in its dated report.  They are
written from the failure modes this lane actually hit on 2026-08-07 rather than as a
generic checklist.

### Math check

1. **Re-derive, do not transcribe.**  Take every imported formula from the source's proof,
   not from its displayed statement.  Kaipa--Pradhan's Theorem 1.3(3) prints denominator
   three; their Proposition 4.5(3) and Theorem 5.1 compose to six, and six is what makes
   their five incidence counts sum to `q+1`.  A displayed formula that has not been
   re-derived is not yet a citation.
2. **Run a closure identity.**  Where a set is partitioned, check the parts sum to the
   whole before using any single part.  That identity is what caught the denominator, and
   it would have caught it with no access to the source at all.
3. **Count the objects, not the words.**  The MDS-extension defect was an off-by-one
   between "outside the span of `r-2` columns" and "outside the span of `r-1`".  For any
   claim that one property implies another, write both as explicit conditions on the same
   objects and compare them symbol by symbol.
4. **Check the direction of every biconditional.**  Dur's equivalence was already cited in
   the paper, for the direction that supports the radius gate, while its other direction
   forbade the conclusion drawn three pages later.  When a cited theorem is an "if and only
   if", state both directions and check the paper against each.
5. **Fix the convention before comparing.**  Chords and axes exchange under the symplectic
   polarity, and two of the four sources in this area use each convention.  Any comparison
   with the literature names its convention first.
6. **State the characteristic and field scope explicitly**, and test the boundary case.
   The exact count holds in odd characteristic including three, and fails in characteristic
   two for a stateable reason.  "Characteristic-uniform" was wrong until it was qualified.
7. **Verify exhaustively where the domain is finite.**  Follow
   `notes/research-reproducibility-conventions.md`: committed report, exact generator,
   compact certificate, replay command, SHA-256 hashes, in one atomic commit.  Where the
   claim is asymptotic, still verify the range that a certificate covers.

### Literature check

Follow `notes/literature-audit-conventions.md` in full; these are the additions this lane
learned the hard way.

1. **Screen on the object in the proof, not the wrapper of the theorem.**  Three prior
   audits screened for "projective Reed--Solomon deep holes" and could not reach a
   literature that decides the same criterion under the name "which lines of `PG(3,q)` lie
   in a plane meeting the twisted cubic in three rational points".  Every item states its
   proof-object query alongside its coding query, and runs both.
2. **Two seeds minimum, from different fields.**  Seed the forward-citation screen from a
   coding paper *and* from a finite-geometry paper.  The geometry school does not cite the
   coding school, so a single-field seed cannot reach it.
3. **Three graphs, counted separately.**  OpenAlex, Crossref, and Semantic Scholar, with
   the largest set screened and the disagreement reported, per the conventions.
4. **Check the shared cache before declaring a gap, and do not trust its silence.**
   Blokhuis--Pellikaan--Sz\H onyi had been cached for weeks and characterised in four other
   lanes' notes without ever reaching this paper's bibliography.  Cross-lane presence is not
   a substitute for this lane's own screen, and cache presence is never evidence of reading.
5. **Record a read depth for every named source, including dismissals**, with cache key and
   SHA-256, and state the opening full-text count.  A source named only in order to be
   dismissed is exactly where the marker gets dropped.
6. **Try the free route before declaring an access block.**  Three sources sat at
   abstract-only in this paper's audit purely because nobody fetched the preprints.  Only
   Dur 1994 had no free route.

### Per-item application

- Item 1 needs no literature check; its math check is that each Lean statement matches the
  manuscript statement it maps to, hypothesis by hypothesis.
- Item 2 is closed; its literature check is inherited by item 3, and the characteristic-two
  twisted-cubic line work, Ceria--Pavese in particular, remains cached and unread.
- Item 3 needs a full literature check against the coset-leader weight-enumerator line;
  Blokhuis--Pellikaan--Sz\H onyi is the direct predecessor and the MDS coset weight
  distribution papers surfaced in the C881 screen are the nearest coding-side neighbours.
- Item 4 needs a math check on the encoding reconciliation: the two encodings must be
  proved to agree on a shared test set before any invariant is attributed to a
  representative.
- Item 5 needs both.  Its literature check covers classical apolarity and covariant theory
  of binary quartics, where a named covariant may already exist under a classical name.
- Item 6 needs a literature check before any claim of a new mechanism, since higher-genus
  double point schemes are classical.

## 1. Lean sync — CLOSED 2026-08-07

Report: `notes/2026-08-07-c883-r5-lean-sync.md`.

All three corollaries are kernel-checked, the statement map's four
no-direct-declaration cells are replaced, and both manuscript builds, the paper verifier,
and the redundancy-five and beyond-four gates are green.  The single shared field list is
split into `PRSRedundancyFive.requiredBridgeFieldOrders = [7, 8, 9, 11, 13, 17, 19]` and
`PRSRedundancyFiveCertificate.certifiedBridgeFieldOrders`, which keeps `q = 16`; the
synthesis input's classification range now carries the characteristic-two branch as well,
so removing that field from the required bridge does not make the theorem vacuous there.
One manuscript defect surfaced and was repaired: the field-range closure ledger still
listed `q = 16` under R5 direct census.

Deferred: the generated trust fact for the beyond-four gate still records the old
declaration names.  The extractor refuses on a worktree carrying two untracked `relconic`
files, so regeneration waits on their owner.

The original item, for reference:

The manuscript now carries two arithmetic corollaries with no formal counterpart, both of
the exact shape already formalized by
`PRSRedundancyFive.fieldOrder_le_nineteen_of_splitFree`:

- `cor:r5-equidistribution` — from `countRelation` and `branchBudget` plus a two-sided
  point bound, derive
  \((q+1-2\sqrt q-12)/6\le N_f\le(q+1+2\sqrt q)/6\).
- `cor:r5-forced` — for odd \(17\le q\le19\), the same inputs force
  \(\#Y_f=12\), \(d_2=4\), \(d_3=0\).
- `cor:r5-binary-shallow` — with the sharper characteristic-two budget \(d_2+d_3\le2\), a
  split-free fibre square has at most six points, so no binary field with \(q\ge16\) admits
  a split-free \(S_3\) pencil.  The Lean `finiteBridgeFieldOrders` list should then record
  that \(q=16\) is a regression check rather than a logical dependency.

Both are pure integer arithmetic over the existing structure.  Leaving them as "no direct
declaration" while their siblings are kernel-checked is an inconsistency in the statement
map, not a mathematical gap.  Gate: two new theorems in the redundancy-five module, the
statement-map rows updated, and the redundancy-five and aggregate gates green.

## 2. Characteristic-two split-witness count — CLOSED 2026-08-07 inside C881

Dissolved rather than solved.  The item assumed the exact count needed a discriminant
square class and therefore failed in characteristic two.  It does not: the count is a
statement about numbers of rational roots in fibres, and its proof uses neither a
discriminant nor a division by two.  Only the *comparison* with the Kaipa--Pradhan elliptic
model is confined to characteristic other than two and three, because their model is built
from a discriminant.

Proposition `prop:r5-count` and Lemma `lem:r5-branch` now carry no characteristic
hypothesis, and characteristic two turns out to satisfy the sharper branch bound
\(d_2+d_3\le2\), since simple ramification is wild there.  The replay computes root counts
by evaluation rather than through a discriminant and now verifies every prime power
\(4\le q\le32\) in every characteristic.

The consequence for item 4 is that its binary-field blocker is gone; only the encoding
reconciliation remains.

## 3. Error distribution and coset multiplicity

\(N_f\) is the number of minimum-weight representations of the syndrome, that is the
multiplicity of the coset leader.  The exact count therefore computes a coset statistic in
closed form for every redundancy-five syndrome in odd characteristic, and
`cor:r5-equidistribution` already bounds it two-sidedly on the \(S_3\) stratum.

Decide whether this becomes a statement in this paper or a companion.  It is the natural
continuation of the coset-leader weight-enumerator line that Blokhuis--Pellikaan--Sz\H onyi
opened at redundancy four, and Kaipa's recent talks list the error distribution of
projective Reed--Solomon codes as a current interest, so it is the item most likely to be
read.

Gate: a precise statement of which coset statistic is determined, its proof from the exact
count, and a decision on venue.

## 4. Sporadic inventory by fibre-square invariants

Add \((\#Y_f,d_2,d_3)\) and the Frobenius trace \(q+1-\#Y_f\) to the sporadic table.  The
values are already computed for the prime fields: at \(q=13,17,19\) every representative is
\((12,4,0)\) with traces \(2,6,8\); \(q=7\) and \(q=11\) are mixed.

Blocker to clear first: the extension fields \(q=8,9,16\) are recorded in the certificate's
own field encoding, which does not match the encoding used by the incidence replay, so the
representatives cannot be compared until the two encodings are reconciled.  Fix the
reconciliation rather than dropping those rows.  This is now the only blocker, since the
count itself covers every characteristic.

Gate: a complete column, cross-checked against the certificate's own pencil-member
histograms.

## 5. The Hankel--Pl\"ucker map as a classical covariant

Kaipa and Pradhan parametrize generic lines by \((z_0,\dots,z_5)\) on the Klein quadric with
\(z_5^2=I(\varphi)\): a binary quartic together with a square root of its first invariant.
Section~\ref{sec:recursive-carriers} independently builds \(c\mapsto z(c)\) from a syndrome
quartic to Pl\"ucker coordinates.  C881 proved the two genus-one curves coincide; what is
not proved is that the two parametrizations coincide.

A cheap test was run on 2026-08-07 and came back **negative**: the syndrome quartic is not
the discriminant quartic up to square class, matching on only a small fraction of the
stratum.  That is the encouraging outcome, since it means the relation is a genuine
covariant rather than an identity.

If it closes, the picture closes with it: a redundancy-five syndrome is a binary quartic,
its Hankel kernel is a line of \(PG(3,q)\), that line's Klein coordinates are classical
covariants of the same quartic, and the curve controlling its split-witness count is the
Jacobian of that quartic's own double cover.  One object, four classical descriptions, with
the deep-hole condition the vanishing of one invariant count.

Method: compute both sides exhaustively over small odd fields using the existing incidence
replay machinery, identify the covariant by matching against the classical apolarity
covariants of a binary quartic, then prove it by apolarity.  This also answers the standing
question of why the residual projected Veronese component appears in the recursive-carrier
elimination.

Gate: an explicit equivariant identity with a proof, or a recorded obstruction.

## 6. Higher genus: what the argument is really about

Nothing in the fibre-square argument uses degree three except the number four, which is the
degree of the different.  At degree \(d\) the double point scheme has genus \((d-2)^2\) and
the Riemann--Hurwitz budget is \(2d-2\), so the same accounting runs; what fails is the
inversion, because only genus one has a closed-form point count.

Two questions, in order: what does the redundancy-six statement look like written this way,
and is the coherent polar induction already in the paper the degeneration of this identity
to higher genus?  A positive answer to the second would reorganize the paper's spine around
one mechanism instead of two.

Research direction, not a repair.  Do not hold any other item behind it.

## Ordering

Items 1 and 2 are closed.  Item 5 carries the remaining real mathematical upside and
depends on nothing else.  Item 4 is unblocked on the binary fields by item 2 and now waits
only on the encoding reconciliation.  Item 3 is a short write-up, since item 2 settled that
the count extends to every characteristic.  Item 6 is open-ended.
