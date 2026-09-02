# C985 context: where to take evolve, synthesis of the 2026-09-01 SOTA research

**Lane:** `complete-ports` (context for C985; no C985 work performed)

**Date:** 2026-09-01

Synthesis of two Opus research reports written today, which extend the
2026-08-30 evolve SOTA audit (that audit covered AlphaEvolve-style LLM
evolutionary coders and neural provers; these cover the lineages whose problem
shape actually matches evolve, and the target-domain incumbents):

- `2026-09-01-c985-evolve-sota-synthesis-lineages.md`: inductive logic
  programming, syntax-guided synthesis and CEGIS, invariant inference,
  symbolic regression, conjecture generation, quality-diversity.
- `2026-09-01-c985-evolve-sota-design-search.md`: SAT+CAS design search,
  Hadamard and Legendre-pair status, qLDPC exact distance, code tables,
  learned pruning in exact search, GitHub and Rust-crate landscape.

Architecture and capability suggestions from the same day are in
`2026-09-01-c985-fables-review.md`.

## 1. Facts that change the plan

1. **Hadamard existence below 2000 is closed.** On 2026-08-12 Alpöge,
   Reynolds-Haertle and Voinov announced Claude-assisted constructions for all
   twelve previously open orders below 2000 (668, 716, 892, 1132, 1244, 1388,
   1436, 1676, 1772, 1916, 1948, 1964). Independently confirmed today via
   MathWorld, Epoch AI's FrontierMath page, and John D. Cook's 2026-08-13
   post. The construction method is not documented in any page fetched; the
   announcement was a sign string plus decoder on X. Order 2092 is still open,
   but "smallest open order" framing is gone, and whether their method extends
   upward is unknown.
2. **QDistSAT (arXiv:2606.12445, 2026-05-29) publishes a list of instances its
   full SAT/MaxSAT/MILP/Brouwer–Zimmermann comparison cannot finish in two
   hours**, explicitly including bivariate bicycle codes at n=288 k=12 and
   n=360 k=12 and GB_144_12_12. Ergodis already holds a certified exact
   [[360,12,24]] and a BB288 [[288,12,18]] path. Its own findings support the
   Ergodis story: branch-and-bound beats CDCL refutation, native XOR reasoning
   barely helps, and Brouwer–Zimmermann underperforms, so the leverage is
   structure exploited outside a solver.
3. **IBM's LLM-guided evolutionary BB-code discovery (arXiv:2606.02418,
   2026-06-01)** is the nearest precedent to an Ergodis "parameter evolve":
   MAP-Elites over generator programs with exact MILP verification as a late
   stage, and it documents BP+OSD overestimating distance by up to 12x. It
   evolves objects, not conditions, and cannot prove non-existence.
4. **Automatic dominance breaking (Lee and Zhong, IJCAI 2020; AIJ 2023; CP
   2022/JAIR)** is the one system that produces the same product as evolve,
   sound automatically generated pruning nogoods for exact search, by solving
   an auxiliary CSP over a restricted problem class. Soundness is by
   construction rather than by corpus. Cite and compare against it in any
   write-up. Certified dominance/symmetry breaking with VeriPB proof logging
   (Bogaerts, Gocht, McCreesh, Nordström; arXiv:2203.12275) is the natural
   externally checkable output format for an evolve theorem.
5. **Constraint acquisition (Conacq, ModelSeeker, 2026 LLM-driven active
   acquisition)** already learns constraints from labelled examples over a
   bias language. Evolve's distinguishing claim must be soundness with a proof
   obligation and reuse as a search-deleting theorem, measured as reduction in
   certified search volume, not predicate accuracy.
6. **No system found combines a typed evolving predicate language, exact
   replay, and sound pruning-theorem synthesis from labelled corpora.** This
   is a searched-channel statement, not a novelty negative: MathSciNet,
   zbMATH, and forward-citation closure were not consulted.

## 2. Evolve engine imports, ranked (first batch fits one day)

All four first-batch items are independent of each other and leave the exact
evaluation semantics untouched.

1. **Failure-derived generalisation/specialisation constraints** (Popper,
   learning from failures). Store each failure as a core in the plan
   normal-form hash and refuse any proposal comparable to it under the
   weakening order. Turns the beam from memoryless re-proposal into monotone
   space contraction; supplies the anti-cycling the 08-30 audit listed as P0.
   Half a day.
2. **Subexpression value bank with observational equivalence** (bottom-up
   SyGuS, TRANSIT, Probe). Build each behaviourally distinct subexpression
   once, keyed by value vector, sample-hash then full-corpus verify. This is
   the concrete form of the raw-orbit term DAG proposed in the review note.
   Half a day for a size-bounded version.
3. **Dalmatian acceptance filter** (Graffiti, TxGraffiti). Bank a theorem only
   if it covers a positive no banked theorem covers and is tight somewhere.
   Stops the theorem DAG filling with near-duplicates. About an hour. The
   sharpness half of the criterion is flagged unverified in the lineages
   report; check the Fajtlowicz source before citing.
4. **Pareto front over coverage and evaluation cost at zero false positives**
   (symbolic regression, NSGA-II crowding). Replaces the lexicographic single
   winner with a menu of pruning theorems at different price points. About
   two hours.
5. **Conflict-driven feature synthesis** (PIE, LoopInvGen). Fire the
   pairwise-difference expander only on an actual positive/false-positive
   conflict and aim it at separating that pair. Half a day.
6. **Persistent minimal separating core** (ICE). Promote the hardest replayed
   counterexamples into a small row set every proposal is scored on first.
   Half a day.
7. **Class-restricted implications** (TxGraffiti): antecedent-gated theorems
   where no sound global condition exists. A few hours.
8. **Probe-style just-in-time production re-weighting with a PatternBoost
   exploit/re-seed alternation**, kept deterministic. About two hours.
9. **MAP-Elites descriptor axes** for the existing semantic niches (fields
   referenced, VM cost, activity fraction). A few hours.
10. **Structural separability probe** (AI Feynman): test whether positives
    factor over disjoint field groups (per-orbit aggregates in the CRT case)
    and search groups independently. A few hours.
11. **Proof-log output for banked theorems** (VeriPB). A design task, not a
    session, but the single item that makes an evolve theorem citable outside
    this repository.

## 3. Targets, ranked

1. **Close the open QDistSAT instances (session).** Read their instance files,
   match their timing protocol, emit their result format plus a replayable
   certificate. An incumbent has just declared these intractable and Ergodis
   has already finished one. Highest expected value in the survey.
2. **Certify the estimated BB / multivariate-bicycle table entries
   (session to days).** Published distances are largely QDistRnd upper
   bounds. A batch driver over the error-correction-zoo and Bravyi-table
   parameter lists plus a compact certificate is a citable service result
   with almost no new mathematics.
3. **Exact distance inside the generator loop (days).** Same design as IBM's
   pipeline with the exact kernel as the fitness function instead of a biased
   BP+OSD score; needs an outer loop over generator ansätze and Tanner-graph
   canonical dedup. Cite arXiv:2606.02418 as the precedent.
4. **Reframe order 2092 as class exclusion (framing plus the soundness gate).**
   The publishable object is a certified "no bordered Goethals–Seidel array
   with four circulant blocks of carrier 522 under multiplier subgroup g", a
   structural result no construction search yields. The blocker is the sealed
   registered extractor and `Necessary` soundness path the C1016 report
   already names; that gate is shared with every item below. Also check the
   Cati–Pasechnik database (arXiv:2411.18897) for which orders above 2000
   lack constructions before choosing the next order.
5. **Legendre pairs: rediscover the Kotsireas–Koutschan cyclotomic-Galois
   condition automatically on a solved length (85 or 87), then attack the ten
   open lengths at most 200 (days).** Cleanest falsifiable demonstration that
   evolve finds real theorems; needs only a Legendre-pair corpus and a PSD
   feature extractor.
6. **Circulant weighing matrices CW(n,k) open cells (days).** Proof technique
   is multiplier and character-sum arguments over cyclotomic fields, the same
   fixed-field norm/Diophantine machinery the campaign already produces.
7. **D-optimal designs and periodic Golay pairs above settled orders (days).**
   Identical PAF-modulo-small-order structure; encodings only.
8. **A Rust crate for certified minimum distance (session to days).** No Rust
   Brouwer–Zimmermann exists; Magma is commercial, GUAVA is GAP. Packaging the
   existing kernel is the cheapest route to external users, and external
   users are what make a necessary-condition engine credible.
9. **Position evolve against constraint acquisition before any write-up.**
10. **Couple evolved conditions to canonical-augmentation generation
    (campaign).** Orderly generation prunes by isomorphism, evolved conditions
    prune by arithmetic, and the two are independent; the 2026 SAT+nauty
    Kochen–Specker work (arXiv:2604.19947, BrianLi009/MathCheck) is the
    template. Needs an isomorphism layer Ergodis lacks.

## 4. Caveats recorded by the sub-agents

- Read depth is mostly abstract/README level; the shared literature cache had
  no hits for these lineages.
- The Lee and Zhong speedup figures disagree between the fetch summary and the
  publisher abstract; verify before quoting numbers.
- The Koutschan Legendre-pair PDF failed to fetch (TLS); the open-length list
  comes from secondary sources.
- The Alpöge et al. construction method is undocumented in every source
  fetched; the existence claim itself is triply confirmed.

## 5. Vibe

The Hadamard existence race below 2000 ended three weeks ago, so the 2092
campaign's headline must become class exclusion. The compensating find is
better than the loss: the 2026 qLDPC-distance literature just published a list
of instances it cannot finish, and Ergodis has already finished one of them.
On the engine side, four half-day imports from ILP, SyGuS, Graffiti, and
symbolic regression turn the beam into a space-contracting archive search
without touching exact semantics.
