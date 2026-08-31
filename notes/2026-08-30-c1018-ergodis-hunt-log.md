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
