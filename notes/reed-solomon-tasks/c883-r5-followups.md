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

## 1. Lean sync (do first; small and mechanical)

The manuscript now carries two arithmetic corollaries with no formal counterpart, both of
the exact shape already formalized by
`PRSRedundancyFive.fieldOrder_le_nineteen_of_splitFree`:

- `cor:r5-equidistribution` — from `countRelation` and `branchBudget` plus a two-sided
  point bound, derive
  \((q+1-2\sqrt q-12)/6\le N_f\le(q+1+2\sqrt q)/6\).
- `cor:r5-forced` — for odd \(17\le q\le19\), the same inputs force
  \(\#Y_f=12\), \(d_2=4\), \(d_3=0\).

Both are pure integer arithmetic over the existing structure.  Leaving them as "no direct
declaration" while their siblings are kernel-checked is an inconsistency in the statement
map, not a mathematical gap.  Gate: two new theorems in the redundancy-five module, the
statement-map rows updated, and the redundancy-five and aggregate gates green.

## 2. Characteristic-two split-witness count

The exact count fails in characteristic two for one reason: it reads the splitting of the
residual quadratic off a discriminant square class.  In characteristic two that is governed
by an Artin--Schreier trace instead.  Find the companion identity.

Why it matters beyond uniformity: \(q=8\) and \(q=16\) are exactly the sporadic fields whose
entries item 4 cannot otherwise annotate, and \(q=16\) is the field where the sporadic
locus is empty while its neighbours are not.  A characteristic-two identity would make the
redundancy-five count uniform in every characteristic.

Gate: a stated identity, a proof of the same member-by-member shape, and an exhaustive check
over \(q=2,4,8,16,32\) added to the existing replay.

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
reconciliation rather than dropping those rows.  Characteristic two additionally needs
item 2.

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

Item 1 first, since it is mechanical and closes a visible inconsistency.  Items 2 and 5 are
the two with real mathematical upside and are independent of each other; item 4 depends on
item 2 for the binary fields and on the encoding fix for the rest.  Item 3 is a
short write-up once item 2 settles how far the count extends.  Item 6 is open-ended.
