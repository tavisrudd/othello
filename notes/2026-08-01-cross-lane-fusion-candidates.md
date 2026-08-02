# Cross-lane fusion candidates (2026-08-01)

Five fusion proposals from an external Claude session, with local verification of their premises and
a ranking that differs from the source's. Nothing here is allocated; this note exists so the
assessment is not lost, and so the two verified gaps are not rediscovered later.

Companion: `2026-08-01-external-chat-artifact-gap-review.md`.

## Verified premises

- **The repair-ports manuscript uses a single matroid perspective.**
  `papers/complete-repair-ports/complete_repair_ports.tex` has a full pointed-Tutte section
  (`\section{Pointed Tutte structure}`, theorem at `thm:tutte`) built on the Las Vergnas polynomial
  of the elementary perspective from deletion to contraction at one element. The flag generalization
  to a nested chain is genuinely not written here.
- **The two repair papers do not cite each other.** The only occurrence of "Frobenius" in
  `complete_repair_ports.tex` is an unrelated injectivity argument about cubic points. The
  Frobenius-equivariant eight-arc paper and the repair-ports paper are both about repair diversity of
  MDS codes with no link in either direction.
- **The Schur--Sarkisov spine is unassigned to a manuscript.** Recorded as such in
  `2026-07-31-results-summary-snapshot.md`; it proves the Schur-product flag identity and the
  self-dual middle slice at q=11 but uses only two slices.

## Ranking

**1. Arc pair-repair fused with coefficient ports.** Recommended first if anything is allocated.
Needs no novelty audit to begin, because the deliverable is a theorem about two objects we already
own rather than a new invariant. Arcs are MDS column sets, so alternate-legal-pair counts should
lower-bound port matching or transversal invariants of the extended code, and the orbit-replacement
graph — currently parked as future work in the arcs handoff — becomes a repair graph whose
connectivity is a distributed-storage statement. This supplies the missing reason to care about that
graph.

**2. The Tutte polynomial of a Schur filtration.** The strongest idea and the one with the weakest
supporting claim. The source asserts no incumbent. That is not safe: Las Vergnas wrote a series on
the Tutte polynomial of a morphism of matroids, and flag matroids and their invariants are an
established line going back to Borovik--Gelfand--White. Iterated perspectives are exactly what those
literatures study. The local premise checks out and the payoff structure is attractive — degreewise
erasure reliability, a Wei-duality mirror of the graded pieces, a functional equation from the
palindromic Gorenstein Hilbert function — but a bounded audit of morphism-of-matroids and
flag-matroid invariants must run before any writing effort. If it clears, this is the best item: it
is provable from what exists, touches three lanes, and a failed functional equation is itself
informative.

**3. The orientation torsor gets an estimation theory.** Cheapest item on the list and independent
of the others. One row in the survival/loss table and a short section turning the torsor inventory
into an operational statement with a sample cost. Take it regardless of what else is chosen.

**4. Rigidity theorems as certified canonicalization for the game censuses.** Real value, but the
source omits a threshold problem. The continuation-graph rigidity result requires q at least 13,
while much of the cap lane's live work — the C80 spine, the causal-label counterexample, the
certificate-exchange analysis — sits at q equal to 11. Redeploying it as a soundness certificate for
iso-key state merging therefore covers the q equal to 13, 17, 19, 23, and 29 censuses but not the
one where the current crown lives. First question is whether q equal to 11 is genuinely false or
merely outside the proof's reach; answer that before building solver infrastructure on it.

**5. The self-dual Schur flag as a code-switching ladder.** Highest ceiling, highest audit burden,
deferred. The nested-CSS picture where one level's logical operators are the next level's checks is
textbook in the code-switching literature, so the novelty rests entirely on the specific self-dual
flag at q=11 together with the rigidity constraint on transversal groups. The source concedes the
distances are MDS-trivial, which is what a fault-tolerance audience would object to. Should follow
the item-2 audit rather than precede it.

## Lane note

Items 1 and 4 cross lanes that own their pieces (`paper-frob-eq` and `complete-ports`; `continuation`
and `cap`). Under the lane rules each needs pegging to the lane that owns the deliverable, or
splitting. None of that is decided here.
