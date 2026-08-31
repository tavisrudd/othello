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

## Results

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
