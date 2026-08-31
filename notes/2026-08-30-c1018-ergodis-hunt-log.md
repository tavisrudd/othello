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
- **User-directed C80 attack (cap lane; landed ~01:00)** —
  `2026-08-30-c80-hall-rematching-attack.md`; driver
  `ergodis-private/src/bin/c80_hall_rematch.rs`. Formulation settled with
  a label-defined edge relation (no matching table). **q=11 closed
  exhaustively** (10.89M complete exchanges): zero Hall failures, but
  363,000 flat-support exchanges — strict support descent is FALSE at
  q=11; no support-deficit set exists there; all 1,266 raw failures
  certified away as N-positions (whole census: every defect-creating
  q=11 exchange is an N-position — q=11 is game-dead and cannot decide
  the crown). **q=13 (50k states): strict surplus every time on a
  game-live domain.** Independent Python replay exact. Proposed cap-lane
  next step recorded in the report (prove |consumed| ≥ |created| at
  q≥13 from projective incidence, q=11 as equality base). Evidence landed after a
  hash-projection defect was found and fixed (outputs now
  byte-reproducible; SHA256SUMS append audited); bundle committed.
  Foreign issues raised: ergodis-private lib currently fails clippy from
  another session's in-flight g53_search.rs/lib.rs edits; Cargo.toml
  dirty (earlier flag).
- **Wave 4A, transversal level-vs-weight no-go census (landed ~01:45)** —
  report §§14–19; driver `ergodis-private/src/bin/c1018_level_census.rs`.
  **Certified finite no-go:** over every CSS code with n ≤ 8 (8,044,851
  flags at n=8 — exhaustive, the flag IS the code), X-check weight ≤ 7
  admits no diagonal transversal gate at hierarchy level ≥ 3. Corollaries:
  n ≤ 7 caps at level 2 at every weight (eight qubits is the minimum
  length for a diagonal transversal non-Clifford gate); at n=8, level 3
  occurs only at wX=8, uniquely [[8,3,2]]. Threshold wX ≥ 2^{ℓ−1}
  attained at every ℓ ≤ 6 on the RM ladder to n=64. Finite shadow of the
  qLDPC question stated as census, not theorem; proof gap named exactly
  ([[8,3,2]]'s ±1-phase gate evades the textbook uniform-phase
  divisibility argument yet lands on the threshold). The n=9, wX ≤ 6
  pass is excluded from the claim with a resume command.
- **Wave 3B, qLDPC exact-distance sweep (landed ~02:15)** —
  `2026-08-31-c1018-hunt-qldpc-sweep.md`, helper
  `2026-08-31-c1018-qldpc-helper.py`. **All six open lifted-product
  candidates from Liu–Marquardt arXiv:2606.24808 §S7 closed exactly**,
  every one replacing a published randomized upper bound (all tight):
  [[1428,186,18]], [[1496,198,16]], [[1496,192,16]], [[1496,198,14]],
  [[1500,81,18]], [[1500,76,20]]. **New exact k·d²/n frontier record:
  [[1428,186,18]] at 42.20** (previous exact record 33.88; bivariate
  frontier 19.2), found in ~51 s via a verified right-translation anchor
  reduction (42–60x anchor cut). Generic layer validated bit-identically
  against the certified R2Elite02 matrices; independent witness
  re-verification throughout. Evidence + SHA256SUMS under
  ~/.cache/ergodis/c1018/qldpc/ pending compact-certificate landing.
- **Wave 5A, PRS Conjecture D rungs (landed ~02:50)** — report §5.3f.
  **Conjecture D refuted at r=10** (no carrier exists: the stratum shape
  is s=XY·G(X^m,Y^m) with m | r−3, and r−3=7 prime gives zero across
  q=11..43), while **r=11 fires at q=13 through a different, quartic
  mechanism** (strata {1,5,9} and {1,3,5,7,9}); the (9,13) two-condition
  invariant cut is specific to the cubic carrier. Replaced by D′ (+ new
  E) in the conjecture table; stratum-sweep scope limit stated (regular
  orbits invisible). **Correction (landed ~03:10):** the invariant
  conditions DO generalize — the completed independent sweep shows the
  12 points at (11,13,4) are exactly two PGL₂(13)-orbits of size 546
  with C₄ stabilizers, separated perfectly by u=s₅²/(s₁s₉) (values 10
  and 5), each a union of fourth-power classes — the (9,13) cut in
  refined form (Conjecture E′; E retained as falsified verbatim).
  Stabilizer pattern (S₃ at m=3, C₄ at m=4) predicts m=5 at r=13 as the
  odd/cubic discriminating test. **Foreign issue for the morning: the Ergodis core
  no longer compiles** — css_distance.rs mid-edit from a concurrent
  session (three undefined BOUND_PULSE_* constants); campaign results
  all come from pre-breakage binaries, core untouched by us.
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
