# C1018 — Ergodis open-problem hunting campaign log

**Lane:** gem-mining
**Window:** 2026-08-30 ~23:15 → ~07:15 (eight hours, user-directed).
**Rules:** Ergodis core read-only; drivers as new bins in
`ergodis-private/src/bin/` (foreign dirty files `alignment_control.rs`,
`semantic_rank_census.rs` untouched); any core mod via one worktree under
`~/.cache/ergodis/`; bulk output to `~/.cache/ergodis/` or `/tmp/persistent`,
never tmpfs; crosswalk conventions — computational results only, no bridge
inflation, negatives with exact searched domain and stop condition. Every
wave MUST check `notes/2026-07-31-results-summary-snapshot.md` (the
authoritative self-contained portfolio summary, 2026-08-29 revision) for
repository prior art via targeted section reads, cite it by section, and
mark anything it already settles as prior art rather than a hunt result —
the portfolio is large and hunts must build on it, not rediscover it.

**Targets** (from `notes/open-problems/plausible-bridges/README.md` bounded
projects, ranked by Ergodis fit):

1. Sharper PRS deep-hole conjecture — formulate and test (MDS dossier).
2. Transversal non-Clifford finite-size exact classification / candidate
   distance certification via `css_distance_native`.
3. Order-12 projective-plane restricted symmetry/oval eliminations
   (Hall matcher / orbit search).
4. Structured Legendre pairs toward order 668 (if time).
5. Exact certified equiangular bounds M(18)–M(20) (if time).

## Wave log

- Wave 1 (launched ~23:15): sub A on target 1
  (report `2026-08-30-c1018-hunt-prs-deepholes.md`), sub B on target 2
  (report `2026-08-30-c1018-hunt-transversal-css.md`).

## Overnight pipeline (post-scout, ~00:15)

Scout report `2026-08-30-c1018-target-scout.md` ranked the remaining
targets (Hadamard excluded — other agent). Launched per ranking: wave 3A =
close/narrow the exact distance of the bivariate-bicycle `[[756,16,d]]`
(the snapshot's one explicitly unfinished exact computation); wave 3B =
sweep published qLDPC tables for distances stated only as upper bounds.
Queued next: transversal level-vs-check-weight no-go census (resumes the
wave-1B sub), PRS redundancy-10, coordinated M(18) only if the user
approves executing queued C1000(a)/C737. Rejected list in the scout
report.

## Results

- **Wave 1A, PRS deep holes (landed ~00:45)** —
  `2026-08-30-c1018-hunt-prs-deepholes.md`; driver
  `ergodis-private/src/bin/c1018_prs_deephole.rs`, helper
  `2026-08-30-c1018-prs-helper.py`. Three sharpened conjectures all
  survive 41 exhaustive census cells (r=3..9). **New:** redundancy 8 is
  persistent-only already at q=13 (exhaustive q=13,16,17,19; 1.73e9
  projective directions) — answers C513's open "is q=43 sharp?" with no;
  exact X(8)∩[8,19]={8,9,11}. **New:** X(4)=∅ for 4≤q≤64 (twelve fields,
  exhaustive). Sixteen cells reproduce committed R5/R6/R7 certificates
  exactly. No counterexamples; one GF(16) field-labelling artifact logged
  as a standing certificate-recheck hazard. Ergodis fit: prime-field rank
  oracle exact (116 cross-checks); biggest gap is no general GF(p^h).
  Follow-up (r=9,q=13) queued to decide Conjecture B.
- **Wave 1A follow-up (landed ~01:30): Conjecture B falsified at
  redundancy nine.** Exhaustive census of all 883,708,281 points of
  PG(8,13): covering radius 8 as predicted, but deep = 1638 vs the
  persistent locus's 1274 — one new exceptional PGL₂(13) orbit
  (stabilizer order 6, catalecticant rank 3, two-dimensional non-split
  apolar pencil), witness independently certified in Python. Also kills
  the monotonicity half of Conjecture C (13 ∈ X(9) but 13 ∉ X(8)).
  Replacement Conjecture B′ (q₀(r) ≤ 23 for every redundancy) survives
  every cell; the r=8 result stands.
- **Wave 2A, order-12 planes (landed ~01:10)** —
  `2026-08-30-c1018-hunt-plane12.md`; driver
  `ergodis-private/src/bin/c1018_plane12.rs`, helper
  `2026-08-30-c1018-plane12-helper.py`. Eliminations with certificates:
  no point-regular collineation group on a plane of order 12 (multiplier
  orbit certificate + 1.18e11-node exact exhaustion), hence every
  prime-order collineation fixes a point and line; order-6/order-7
  control eliminated. Both classical — correctly not claimed as novel.
  Proved reduction: the order-13 tactical decomposition is solvable
  (Paley-biplane doubling + a mixed-type witness), so that case cannot
  die at decomposition level. **New bridge:** hyperoval external lines ↔
  one-factorizations of K₁₄ ↔ starters in Z₁₃; all 133 starters
  enumerated with Hall-deficient witnesses. hall_core load-bearing;
  independent Python verification passes all five checks.
- **Wave 3C, PRS orbit structure + recurrence (landed ~00:40)** — report
  §5.3d/e. The (9,13) exceptional orbit is the PGL₂(13)-orbit of
  XY(X⁶+X³Y³+8Y⁶), stabilizer S₃; membership cut exactly by two closed
  invariant conditions on the S₃-fixed stratum; the sextic factor is the
  cyclic-cubic pullback of z²+z+8 — the same mechanism C491 names at
  redundancy five. Recurrence law (exhaustive stratum sweeps): exactly one
  exceptional field per redundancy, the least prime power q≡1 mod 3 with
  q≥r−1 — confirmed q=7@r=6, q=13@r=9, q=13@r=12 (beyond the proved
  range); q≡1 mod 12 guess refuted at q=25. New Conjecture D recorded.
  Full-space B′ cells at q=16,17,19 out of budget (RAM/time, stated
  exactly); stratum sweeps at eight fields all clean — supports B′,
  does not establish it.
- **Wave 1B, transversal/CSS (landed ~23:45)** —
  `2026-08-30-c1018-hunt-transversal-css.md`; driver
  `ergodis-private/src/bin/c1018_transversal_css.rs`. Nine small CSS codes
  distance-certified exactly by `css_distance_native` (two runs are genuine
  exhaustions of 238M and 791M connected supports in seconds); complete
  diagonal transversal group per code via Smith normal form over all real
  phases; method validated on the known Steane/`[[15,1,3]]`/`[[8,3,2]]`
  facts. **New exact classifications:** `[[16,4,2]]` → exactly CCCZ,
  `[[32,5,2]]` → exactly C⁴Z, `[[31,1,3]]` → logical group exactly
  \(\mathbf Z_{16}\) (level 4). Exact negatives: Steane and `[[15,7,3]]`
  admit no non-Clifford diagonal transversal at any phase; Shor no
  non-Pauli. No claim on the good-qLDPC target. Repository prior art
  marked per the snapshot rule. Ergodis fit: clean; one convenience gap
  recorded (no minimum-nonzero-weight mode).
