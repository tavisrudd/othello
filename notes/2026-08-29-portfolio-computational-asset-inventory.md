# Portfolio computational asset inventory

**Lane**: `complete-ports`

**Date**: 2026-08-29
**Status**: read-only inventory for commercialization synthesis. Facts only — no
recommendations, no ranking. Scope: computational assets in `/home/tavis/src/othello`
*outside* the `ergodis` crate (`papers/complete-repair-ports/ergodis`), assessed for
whether they could feed that exact-optimization compiler or stand alone.

Reference point (not inventoried, target of the synthesis): **ergodis** —
"compiler and exact solver for finite algebraic optimization problems whose raw
combinatorial state admits a much smaller mathematically derived quotient"; Rust
library with kernels for linear-code recovery, hierarchical composition,
capacitated scheduling, and finite algebraic search; compiles functional labels,
conserved gradings, generated spans, symmetries, and reconstructible coefficient
blocks before optimizing, and returns replayable witnesses/obstructions rather
than a bare optimum (`papers/complete-repair-ports/ergodis/README.md`,
`OPTIMIZATION.md`).

---

## 1. Rust crate `rust/` — game solvers and table infrastructure

### 1.1 Othello engine (`rust/src/`)

- **Computes:** exact and heuristic play for 8x8 Othello; exact endgame solve at
  `--depth full`. Engine ladder `minimax` / `alphabeta` / `ordered` / `strong` returns
  *identical* black-centred values (pruning and parallelism change node count only);
  `strong+` / `strong++` deliberately change the value.
- **Algorithms/data structures:** Kogge-Stone bitboard move generation and flips
  (`core.rs`, AVX2/AVX-512 vectorized in `simd.rs`, bit-identical to scalar);
  fail-soft alpha-beta and iterative-deepening principal-variation search over packed
  bitboards with no `Board` objects (`search.rs`); flat-arena open-addressing
  transposition table keyed on `(black, white, to_move, depth)` storing the full key so
  a collision misses rather than corrupts (`tt.rs`); Multi-ProbCut calibrated forward
  pruning (`mpc.rs`); rayon root-parallel exact scores.
- **Scale/timing:** depth-8/9 search benchmarks in the Makefile; `strong+` scores 77.5%
  vs `strong` over 60 colour-balanced games; `strong++` is strength-neutral per depth
  (48% at depth 8, n=200) but 1.3-2.7x faster, giving 66% at one extra ply.
- **Certificate/verification:** cross-engine value agreement in the test suite, an
  independent grid-arithmetic reference implementation for move-gen/flips, and pinned
  exact endgame values (6 / -40 / 4). SIMD path asserted bit-identical.
- **Language/path:** Rust. `/home/tavis/src/othello/rust/src/{core,eval,game,tt,search,engines,mpc,simd}.rs`,
  README `/home/tavis/src/othello/rust/README.md`.

### 1.2 Non-Attacking Queens / Node-Kayles solver (`rust/src/queens/`)

- **Computes:** win/loss outcome (and full Sprague-Grundy nimber, via `nimber.rs`) of the
  adversarial Non-Attacking Queens game (Noon & Van Brummelen 2006) on n x n boards, plus
  the winning first move and principal variation.
- **Algorithms/data structures:** depth-first negamax with an *incremental canonical key* —
  the 8 dihedral orientations of the `available` bitmask carried live down the DFS stack,
  each updated by one `and-not` per placement, canonical key = `lex_min8`
  (`solver/incremental.rs`; replaces a ~250x-slower per-node re-canonicalization).
  Selective **graph-isomorphism key** on the available-graph (tiny lookup table for small
  fragmented graphs, Weisfeiler-Leman / individualisation-refinement above it) chosen by a
  pure function of the position so transpositions stay intra-ply (`graph.rs`,
  `solver/{fused,iso_flat}.rs`). Parity-aware rayon root parallelism; explicit-stack
  frontier; df-pn proof-number search kept as an instructive negative (`solver/pn.rs`).
- **Storage tier:** `BuRR` — Bumped Ribbon Retrieval (Dillinger–Hübschle-Schneider–Sanders–Walzer
  2022, arXiv:2109.01892) implemented from scratch as a static retrieval structure at
  ~1.0-1.1x r bits/key, on-the-fly incremental Gaussian elimination over GF(2) with a 64-bit
  band, multi-layer bumping, plus an `Archive` wrapper adding key fingerprints so it can serve
  as a *membership*-safe transposition tier (`src/burr.rs`). `BurrStore` (`queens/store.rs`)
  makes this log-structured: mutable memtable freezes into immutable eviction-free BuRR
  segments; a branch adds disk-backed segments on ZFS with resident Blooms, snapshot/resume,
  pread + prefetch + io_uring batch reads.
- **Scale/timing:** n=16 solved (second-player win) in ~23.4 s on the iso-dense default; the
  n=16 distinct set is ~7.9 B positions, of which a flat TT holds ~27%. **n=18 solved as a
  first-player win** — two runs with different evaluator code agreeing on verdict, first move
  `I9`, and a byte-identical 15-move PV: 258 B nodes / 8h16m and 114 B nodes / 7h08m, on a
  26 GB box with a 17 GB flat TT; sustained throughput ~10-30 M nodes/s.
- **Certificate/verification:** cross-configuration agreement between independently coded
  evaluators, an independent oracle differential at n=18, kernel validated exhaustively for
  n<=16, integer-sizing audit, legality/consistency check of the PV, and an independent
  Python certificate checker `rust/scripts/check_cert.py`. A Lean verification of the `getK`
  evaluator exists (`notes/handoffs/done/2026-06-26-lean-getk-verification.md`).
- **Language/path:** Rust. `/home/tavis/src/othello/rust/src/queens/`,
  `/home/tavis/src/othello/rust/src/burr.rs`, CLI `rust/src/bin/queens.rs`. Status blocks:
  `/home/tavis/src/othello/notes/handoffs/done/2026-06-23-queens-n18-umbrella-archive.md`,
  `.../2026-06-16-iso-key-optimization.md`, `.../2026-06-18-iso-window.md`,
  `.../2026-06-19-explicit-stack-frontier.md`, `.../2026-06-24-rocksdb-store-evaluation.md`.
  Lane is dormant/archived.

### 1.3 Supporting Rust infrastructure

- CPU-affinity self-pinning that detects performance cores by peak cpufreq and pins the rayon
  pool perf-first, 1:1 deterministic (`rust/src/affinity.rs`); HyperLogLog + optional exact-set
  distinct-position instrumentation (`queens/count.rs`); TT dump/reload
  (`notes/handoffs/done/2026-06-15-tt-dump-load.md`); width-aware CLI table renderer
  (`src/table.rs`).

---

## 2. Projective cap game / Nofil lane — finite-geometry game solvers

### 2.1 Projective cap-game exact solver

- **Computes:** the normal-play outcome (P = second-player win, N = first-player win) of the
  *cap achievement game* on `PG(m,q)` — players alternately add a point keeping the selected
  set a cap (no three collinear). Also the affine `AG(n,q)` and sum-free `Z_n` variants.
- **Algorithms/data structures:** memoized exhaustive negamax on Python-int bitmasks with an
  **incrementally carried forbidden mask** (adding a point forbids each line through it and an
  already-chosen point, instead of an O(|A|^2) recomputation), memo keyed on the chosen-set
  bitmask since forbidden is a function of it. Axioms are validated before solving (every line
  has q+1 points; every point pair lies on exactly one line), and `q=2` cross-checks against the
  `F_2^k` sum-free game.
- **Scale:** `PG(4,3)` computed P; odd planes computed P for `q=3,9,17,19`; `q=5,7,11,13` are
  Lean-proved; the `q=23` on-conic layer is rules-certified across all 22 full-`PGL(2,23)`
  buckets; `q=25` has an all-P on-conic census.
- **Certificate/verification:** structural theorems are Lean-proved sorry-free in
  `lean/ProjectiveCap/` and `lean/CapGame/`; computations cross-check against those and against
  the sum-free game at `q=2`. No `TRUST.md`-standard ledger exists for these Lean libraries yet.
- **Language/path:** Python. `/home/tavis/src/othello/notes/2026-07-05-proj-cap-fast.py`
  (fast solver), `.../2026-07-04-proj-cap.py` (raw probe),
  `.../2026-07-04-cap-agnq.py`, `.../2026-07-04-cap-gf.py`.

### 2.2 Canonical grid cap-game solver (the group-quotient engine)

- **Computes:** the residual `PG(2,q)` game after the opening pair, modelled as a grid game on
  `F_q x F_q` cells with legality = partial-permutation matrix (at most one per row/column) plus
  affine cap; `PG(2,q)` is P iff this grid game is a first-player loss. Modes: root outcome,
  full-expansion parity-defect diagnostics, per-size-3-class escape margin, and a private-memo
  per-class mode.
- **Algorithms/data structures:** **anchor min-image canonicalization** under the full grid
  automorphism group `G = {(r,c) -> (a r + s, b c + t)}` extended by axis swap — translate an
  occupied cell to (0,0), optionally swap axes, scale a second cell to (1,1), then minimize the
  sorted cell list over all anchor choices. `G` preserves row/column classes and affine
  collinearity, so the game value is a `G`-invariant and memoizing on the canonical form is exact.
  This is the "raw state admits a much smaller derived quotient" pattern, hand-built for one group.
- **Scale:** ran to a `q=19` memory wall on the global-arena mode; the private-per-class mode with
  a `--cap` slot abort and a class-index resume filter was built to push a `q=23` campaign
  class-by-class at small RSS, single-threaded.
- **Certificate/verification:** primary bitmask search and an independent affine-determinant
  replay agree on the C80 falsifying witness over `F_11`; escape-margin runs are logged
  (`notes/2026-07-06-escape-q17.log`, `-q19.log`) alongside the ladder shell drivers.
- **Language/path:** Rust (compiled port of the Python `2026-07-06-grid-canon2.py`).
  `/home/tavis/src/othello/notes/2026-07-06-grid-cap-solver.rs`, ladder/frontier drivers
  `notes/2026-07-06-gridcap-*.sh`, companions
  `notes/2026-07-06-{escape-margin,escape-parity,grid-maximal-parity,exception-structure}.py`.

### 2.3 Nofil mirror-harvest sweep over classical varieties

- **Computes:** cap/Nofil outcomes on classical finite-geometry boards — quadrics, polar spaces
  (symplectic `W(2n-1,q)`), and Segre products `PG(a,q) x PG(b,q)` — plus a search for the
  fixed-point-free collinearity-preserving involutions that make the generic mirror lemma apply.
- **Algorithms/data structures:** each board is constructed from its defining form over a small
  finite field so the >=3-point-line incidence pattern is *verified rather than assumed*; then
  exhaustive normal-play game solve, then candidate-involution testing against the Lean mirror
  lemma `Projective.initialPStatement_of_fixedPointFree_collinearity_preserving_involution`.
  The Segre case reduces to a capacity-2 "rook lines on a subspace grid" game solved directly on
  the grid, avoiding the tensor embedding.
- **Scale:** small fields per board family; the sweep's value is breadth of families, not depth.
- **Certificate/verification:** incidence axioms machine-checked per board; outcomes feed the
  Lean-proved mirror theorems rather than standing alone.
- **Language/path:** Python.
  `/home/tavis/src/othello/rust/scripts/{projcap_mirror_harvest,polar_space_nofil,segre_product_nofil}.py`.

### 2.4 Node-Kayles copycat / structural-boundary checker

- **Computes:** whether a residual graph is P *without* a Grundy-value oracle, by certifying an
  explicit persistent nonedge pairing (copycat strategy) — plus a one-exchange adaptive shell
  where every first move has a reply leaving a persistently paired graph.
- **Algorithms/data structures:** pairing/matching certification over the nonedge relation;
  component swaps and internal fixed-point-free nonedge automorphisms fall out as special cases.
  The open C80 frontier seeks a Hall-type rematching between consumed ancestral labels and new
  defect fibres with strict total-support descent.
- **Scale:** used on `q=11` and `q=23` residual instances from the cap reduction.
- **Certificate/verification:** the accepted object *is* the certificate (an explicit strategy),
  which is why it needs no game-value search; independent affine-determinant replay for the
  falsifying witness.
- **Language/path:** Python. `/home/tavis/src/othello/rust/scripts/c80_adaptive_copycat_survivor.py`,
  `.../c80_c447_cloud_packet.py`, `.../c549_private_boundary_signatures.py`. Lane handoffs:
  `notes/handoffs/2026-07-06-projective-cap-game-handoff.md`,
  `notes/handoffs/2026-07-17-nofil-paper.md`.

---

## 3. Reed–Solomon deep holes — the most productized asset

Lane handoff: `notes/handoffs/2026-07-22-reed-solomon-deep-holes.md`. Paper
`papers/high_weight_grs_cosets` is released with a concept DOI
(10.5281/zenodo.21682069), an archival PDF and an IEEE Transactions on Information
Theory variant.

### 3.1 Projective Reed–Solomon Toolkit (shippable Rust crate)

- **Computes:** four operations on a syndrome over an explicitly represented finite field —
  `canonicalize` (which semilinear orbit contains it), `distance` (exact distance from the
  code), `decode` (a nearest error pattern realizing it), `simultaneous-locator` (can one
  degree-`r-5` marker contraction exhibit a degree-`r-2` locator avoiding prescribed
  projective roots), `classify` (theorem-gated deep/not-deep verdict), and `verify`
  (replay any emitted certificate).
- **Algorithms/data structures:** structural canonicalization of the syndrome as a
  divided-power binary form of degree `r-1` via **exact lexicographic charts** stratifying
  forms into rootless / simple-root / multiple-root / pure-power, retaining `O(m r q^2)`
  semilinear transports instead of the full `m(q^3-q)` group enumeration (which is kept only
  as a defensive correctness oracle); symmetric-power action per transport in `O(r^2 + r log q)`
  field ops; locator route enumerating squarefree marker supports of size `r-5` and, per
  support, one contracted redundancy-five pencil with at most `q+1` projective members.
  Also a terminal-hyperplane solver (`docs/terminal-hyperplane-solver.md`).
- **Scale/timing:** implemented domain `r >= 5`, `q >= r`, with candidate budgets; a versioned
  benchmark harness emits `projective-reed-solomon-benchmark-report-v1` JSON timing the terminal
  selector, exact projective-locator oracle, canonicalization, classification, and certificate
  replay — reference data recorded on Rust 1.93.1 / AMD Ryzen AI 9 HX 370, ten single-threaded
  iterations, with candidate and transport counts reported next to timings.
- **Certificate/verification:** every positive deep-hole verdict requires a matching frozen
  theorem-domain registry entry and emits an independently replayable certificate; `classify`
  is explicitly **fail-closed** (computational reach is never promoted to a covering-radius
  theorem) and `canonicalize` attaches no coding verdict. Certificate schemas are documented
  (`docs/certificate-schemas.md`, `docs/theorem-boundary.md`).
- **Language/path:** Rust, self-contained with its own `Cargo.lock`, `rust-toolchain.toml`,
  `CITATION.cff`, `CHANGELOG.md`, and `LICENSE` so it can be extracted as a standalone
  repository without path repair.
  `/home/tavis/src/othello/papers/high_weight_grs_cosets/software/projective-reed-solomon/`.

### 3.2 Coset-classification census and certificate bundles

- **Computes:** the complete classification of every coset of weight at least `r-1` of a
  redundancy-`r` generalized Reed–Solomon code with evaluation set `P^1(F_q) \ A`, `|A| = s`,
  and arbitrary nonzero multipliers, under the explicit bound
  `q >= 6(r+s) - 16 + floor(2 sqrt(6(r+s) - 18))`; redundancies R5–R11 plus stable components,
  small exceptional normal forms, and higher-Lucas carrier arithmetic.
- **Algorithms/data structures:** exhaustive **orbit enumeration under `PGL(2,q)` and
  `PΓL(2,q)`** on coefficient vectors, with per-orbit representative, orbit size, stabilizer
  order, a structured invariant record (factor type, family label, member statistics,
  oscnode rational points, pencil gcd degree, Frobenius index), and a **completeness identity**
  (orbit sizes summing to the exact total, e.g. `889 = 889`). Exact sparse polynomial arithmetic
  over small prime fields (an in-script `Poly` over `F_7` for the R9 residual-quadratic bridge).
  Not Gröbner, not information-set decoding — direct exact orbit census plus algebraic locus
  reconstruction.
- **Scale:** R5–R7 records span `q = 7 … 32`; R9 includes a `q = 49` record; R11 companion
  sweeps cover GF(16), GF(27) (a full carrier sweep with a dedicated Rust generator), and
  GF(32) pointed Borel quotients, plus characteristic-seven pointed orbits.
- **Certificate/verification:** each of the 14 evidence bundles pairs a generator with an
  **independently written replay script** (e.g.
  `r9/2026-07-23-prs-redundancy-nine.py` + `…-replay.py` + a `q=49` Rust generator);
  `supplement/CERTIFICATE-SCHEMA.md` maps stable public labels to immutable dated provenance;
  `build_classification_records.py` deterministically extracts the public JSON recording hash
  and byte count of every input generator, certificate, and replay;
  `CLASSIFICATION-RECORDS.sha256` freezes the result. The R7 finite completeness has a
  *second* direct-locus replay independent of the original quotient partition.
- **Language/path:** Python generators/replays plus Rust sweep generators.
  `/home/tavis/src/othello/papers/high_weight_grs_cosets/supplement/evidence/{r5,r5-elliptic-incidence,r6,r6-normal-forms,r7,r7-direct-locus-v2,r8,r9,r10,lucas-m9,stable-components,r11-binary-quotients,r11-char7-pointed-orbits,r11-gf27-switch-sweep}/`.

### 3.3 Release/verification harness (reusable independent of the mathematics)

- **Computes:** a single-entry-point verification of a paper's whole evidence supplement —
  a scope-sensitive verifier covering 45+ artifacts, gating 37 rendered claim labels.
- **Pieces:** `supplement/verify.py` (one entry point, hash + subprocess replay driver),
  `verification/check_annotations.py` and `check_abstract.py` with `claim-map.json`,
  `evidence.json`, `imported-sources.json`; `package_evidence_bundle.py`,
  `package_software.py`, `prepare_release_export.py`, `lint_tex_spacing.py`,
  `build_r6_paper_table.py`; manifests `EVIDENCE-MANIFEST.json`, `SOFTWARE-MANIFEST.json`,
  `RELEASE-MANIFEST.md`, `REPRODUCING.md`, `LEAN-STATEMENTS.md`, plus `theorem-map.md`,
  `verification-map.md`, `formalization-ledger.md`, `claim-proof-novelty-ledger.md`,
  `literature-audit.md`, `adversarial-proof-evidence-audit.md`.
- **Certificate/verification:** the canonical 30-page PDF is pinned by SHA-256
  (`cb59721088deedabb140e16c101d3b84856ad757872f8be1a3921fba8603881d`).
- **Language/path:** Python + Nix flake + Makefile.
  `/home/tavis/src/othello/papers/high_weight_grs_cosets/{supplement,verification}/`.

---

## 4. AME / quantum-code lanes

### 4.1 AME local-unitary rigidity evidence engine

- **Computes:** exact certificates for local-unitary / local-Clifford equivalence questions on
  stabilizer absolutely-maximally-entangled (AME) states: the Clebsch `AME(6,11)` state versus
  every six-point generalized-Reed–Solomon-derived state; holonomy completeness of an admitted
  non-GRS pencil; logical-phase and transversal Clifford groups; four-copy contraction rank-drop
  divisors; H3 uniform-LU separation and pentad-orientation boundaries; party-extension examples.
- **Algorithms/data structures:** enumeration over symplectic groups and Lagrangian row spaces
  (candidate symplectic maps checked against full CSS Lagrangian row spaces); exhaustive party
  permutation sweeps (all 720 `S_6` assignments; a 950,400-candidate anchored local-Clifford
  test; all 924 GRS evaluation sets); exact arithmetic in `Q(tau)` with exact `S_6` closure;
  fraction-free determinants and signed cycle-cover ledgers; quotient-field row reduction with
  integral maximal-minor witnesses; double-coset orbit-sum arithmetic; finite-Fourier code
  duality. Explicitly **no randomness, no floating point, no network, and no external
  computer-algebra package** — not GAP, not Sage; everything is hand-rolled exact Python.
- **Scale:** prime fields `q = 7,11,13,17,19,23,29,31,41,101` and four extension fields; twelve
  prime-field rows for party extension; a `24 x 21` section and `9 x 9` transport kernel compared
  across all 720 party assignments at six exact `(q,t)` pairs.
- **Certificate/verification:** each generator reconstructs its canonical JSON certificate in
  memory and requires **byte-for-byte equality** with the tracked certificate; `verify.py --replay`
  is the single entry point, first checking byte count and SHA-256 of every load-bearing file,
  then running each generator with `--check`. Integrity run reports "verified 17 evidence
  artifact(s)", full run adds "replayed 8 evidence bundle(s)". Every bundle also has a
  *mathematically independent* second check (a different determinant route, a direct rank
  computation, a separate census) recorded per row in `EVIDENCE.md`.
- **Language/path:** Python. `/home/tavis/src/othello/papers/mds_css_transversal_groups/supplement/evidence/`,
  driver `.../supplement/verify.py`, row-by-row scope statements `.../supplement/EVIDENCE.md`.
  Paper I is `papers/ame_lu` (DOI 10.5281/zenodo.21681856, 37 A4 pages, PDF SHA-256 pinned),
  Paper II is `papers/mds_css_transversal_groups`. Release gate:
  `papers/ame_lu/release/{verify_release.py,RELEASE-MANIFEST.json,PUBLIC-EXPORT.md}`.
  Handoff `notes/handoffs/2026-07-24-ame-lu-paper.md`.

### 4.2 Lean formalization ledger for the AME results

- **Computes/records:** a per-theorem map from manuscript results to kernel-checked Lean
  statements and, explicitly, the *unformalized boundary* of each — what Lean checks versus what
  remains a manuscript composition. Namespace `RelativeConicArcs.AMELU`; modules include
  `StabilizerAMESupport`, `AMESupportedSubspaceProfile`, `HolonomyCentralizer`,
  `StabilizerDictionary`, `EncoderTransversal`, `Multipartite`,
  `RelativeIntertwinerDecomposition`, `AMELUTwoUniformRigidity`.
- **Path:** `/home/tavis/src/othello/papers/ame_lu/formalization-ledger.md` (and the Paper II
  counterpart), backed by `lean/`.

### 4.3 Quantum-codes lane (early, mostly queued)

- **Scope:** standalone quantum-code constructions, exact compilers, certificate tooling, and
  gate-structure investigations that consume geometric/coding results from other lanes.
  First task C967 compiles the jet-quotient CSS family exposed by the Clebsch Schur–Sarkisov
  calculations (at `q=11` its established property is 3-uniformity, not AME), keeping the
  transversal non-Clifford phase test as a separate research gate.
- **Existing artifact:** `notes/2026-08-28-ergodis-ldpc-quantum-angle.md` — a completed read-only
  investigation with `file:line` provenance into the ergodis sources. Its verdict: ergodis is
  not a quantum-LDPC tool today (its quasi-cyclic LDPC front end is one struct with an unpruned
  fixed-size depth-first search over a four-node example; its best kernel is specialized to
  arithmetic mod 3 rather than GF(2); its matrix type stores one byte per bit), but the CSS
  X-distance `min wt(C_X \ C_Z^perp)` is exactly the nested-code coset/relative-weight object
  the compositional-recovery paper proves theorems about and `confinement.rs` computes, and
  `group_action.rs` — a verified orbit compiler over an abstract finite permutation action with
  a GF(2) general-linear canonical-form fast path — is the unadvertised symmetry-reduction asset.
- **Path:** `notes/handoffs/2026-08-25-quantum-codes.md`; allowed paths include
  `notes/quantum-codes-{tasks,reports}/`.

---

## 5. Algebraic-geometry lanes — orbit, Gröbner, lattice, and graph computations

### 5.1 Twisted-cubic transversal spectrum (`cubic`)

- **Computes:** the external-point transversal spectrum `rho(x) = #{B in C(C,3) : x in <B>}` for the
  twisted cubic `C` in `PG(3,q)`, plus the weight distribution of the `[2q+2,4,q]_q` code from
  `C union axis`. The completion-paper's `rho` is a stated open problem.
- **Algorithms/tools:** explicit generation of the stabilizer `PGL(2,q)` (order `q^3-q`) from
  `<T_a, inversion, scaling>`, verified to preserve cubic and axis setwise (order 24 at `q=3`,
  720 at `q=9`, zero failures) — which forces every invariant to be orbit-constant and collapses
  the proof to **orbit counting**; independent GF(3)/GF(9) enumeration of the five-weight
  distribution. Next step is an **integer linear program** at `q=81` and `q=243` for the
  transversal/rational-curve/incidence exact forms, guarding the axis prediction
  `tau(81)=61`, `tau(243)=198`.
- **Certificate:** the reduction and axis cap-set law are Lean-certified at strict trust.
- **Path:** `notes/handoffs/2026-07-13-twisted-cubic-transversal-spectrum.md`, report
  `notes/2026-07-13-c115-twisted-cubic-tau-reduction.md`.

### 5.2 Cubic stabilization and cubic threefolds (`cubic-threefolds`)

- **Computes:** the Eckardt locus and singular locus of the nonstandard `A_5`-cubic pencil in
  `P^4`; the Euler/Gromov–Witten spectrum of specialized Hirzebruch surfaces; signed-permutation
  bases of rank-seven type-I1 lattices; finite cubic and categorical-law checks.
- **Algorithms/tools:** **Gröbner elimination over `Q`** for the locus
  (`a5_pencil_eckardt_locus.py`) — explicitly labelled a *trusted execution* — cross-checked by a
  method-disjoint script that enumerates every point of `P^4(F_q)` over five finite fields and
  applies the rank-at-most-two Hessian criterion directly, with the Fermat cubic threefold as a
  control (thirty Eckardt points each when the cube roots of unity are rational, none otherwise).
  Lattice work uses **SymPy** exact matrix algebra with root-basis left inverses over
  signed-permutation groups. Deformation-invariance arguments for genus-zero Gromov–Witten
  invariants of `F_a`.
- **Certificate/verification:** `verification/README.md` states the trust boundary explicitly —
  the proof spines are structural, `evidence.json` entries are trusted executions rather than
  certificate-checked, and exactly one statement (`lem:hirzebruch-euler-spectrum`) now invokes one
  as a premise. The unconditional irrationality theorem rests on no evidence bundle. Lean standard
  for anything promoted: no `sorry`, no `native_decide` or compiled-evaluation axiom, no project
  axiom.
- **Language/path:** Python (+SymPy), one Haskell toy.
  `/home/tavis/src/othello/papers/cubic-stabilization-m1/verification/`,
  `papers/cubic-stabilization-irrationality/verification/`,
  `notes/cubic-threefolds-tasks/c925-*.py`. Handoff `notes/handoffs/2026-08-15-cubic-threefolds.md`.

### 5.3 Clebsch series — chordal conference reconstruction and factorization

- **Computes:** node-count completeness for two cubics over `F_11` in augmentation coordinates
  (Jacobian ideals, dimension/degree, radical, and reducedness); the five-isotypic projection of
  the Paper-II tensor, the outer-twisted projectivity and chordal Hankel equation, the invariant
  cubic pencil and normalized outer action; Gorenstein checks in the factorization paper.
- **Algorithms/tools:** a **hand-written Buchberger implementation** inside the certificate
  program, independently replayed by **Singular**'s own Gröbner engine and primary-decomposition
  library on the same ideals in the same coordinates
  (`conference_node_completeness.sing`, expected `dim/deg 0/6` for the conference cubic, `1/4` —
  the rational normal quartic — for the chordal one). Exact arithmetic over `F_11` using only the
  Python standard library for the linear-algebra checker.
- **Certificate/verification:** the manuscript proof is structural; the checkers are *replay
  evidence, not premises* (terminal line `CHECK OK`). Trust manifests and statement-identity
  extractors gate the release (`build_trust_manifest.py`, `extract_statement_identity.py`,
  `verify_release.py`, per-artifact `.sha256` files).
- **Language/path:** Python + Singular.
  `/home/tavis/src/othello/papers/chordal-conference-reconstruction/verification/`,
  `papers/clebsch-{rigidity,factorization,passages}/verification/`. Handoff
  `notes/handoffs/2026-07-13-clebsch-lane.md`.

### 5.4 Dihedral Schreier Node-Kayles (`dihedral`)

- **Computes:** exact Sprague–Grundy (nimber) values of Node-Kayles on Cayley/Schreier templates
  `Cay(G,T)` built from conic involutions — `S_4`, `A_5`, and polyhedral coset templates.
- **Algorithms/data structures:** memoized Sprague–Grundy with **connected-component
  decomposition** (Grundy of a disconnected available set = XOR of component Grundy values),
  components memoized on their raw bitmask (up to 60 vertices packed into a `u64`, with an
  identity hasher).
- **Scale:** `|G| <= 60` (A_5); the C284 polyhedral bundle covers 2,160 triples and 38 templates
  with zero mismatches.
- **Certificate/verification:** `S_4` nimbers cross-checked by three independent solvers; all five
  `A_5` rows independently reproduced by a separate cross-check solver; `(sigma,rho)` proved a
  complete `Aut(G)`-orbit invariant. Lean covers the reduction plumbing, the `V_4 -> K_4` core,
  the Burnside `Phi_T` proposition, and a finite half-density core, with exactly one quarantined
  Davenport axiom, no `sorry`, no `native_decide`.
- **Language/path:** Rust solver `/home/tavis/src/othello/rust/scripts/nodekayles_cayley.rs`;
  Lean `lean/DihedralSchreier/`; handoff `notes/handoffs/2026-07-17-dihedral-paper.md`.

### 5.5 Relative conic arcs (`relconic`) and continuation graphs (`continuation`)

- **relconic** — exact finite values, equality/stability results, and conic specializations for
  arcs complete outside a conic; the live C949 frontier proves exact endpoint exclusion, nine
  inverse signatures, quadratic Mason-relative separation, a bounded balanced Rédei state, a
  two-monomer marked-selector reduction, and a cyclic `q=27` post-terminal Chow filter. Lean/trust
  export exists (C843). Path `papers/arcs_complete_outside_conic/`, handoff
  `notes/handoffs/2026-07-17-c210.md`.
- **continuation** — semilinear automorphisms of the continuation graph of a four-point
  projective frame; headline N1 (the graph has exactly its ambient semilinear automorphisms,
  `q >= 13`) is proved in prose with the extremal quantities `m(k), r(k)` open. This is a
  **graph-automorphism / reconstruction** result with no Lean library yet built. Path
  `papers/continuation-graph-rigidity/`, handoff `notes/handoffs/2026-07-17-continuation-paper.md`.

### 5.6 Golden operator (`golden`)

- **Computes:** the conference-operator "shadow sisters" — the claim that a family of matrices
  arises from one operator through exterior power, golden compression, commutator,
  determinant/Pfaffian, adjugation, and centered squaring, rather than coincidental formula
  matches. Source-development lane for a future forward version of Clebsch Paper III.
- **Path:** `papers/golden-operator/` (manuscript + `verification/`), handoff
  `notes/handoffs/2026-07-31-golden-operator-paper.md`. The mathematics is frozen in the
  C704–C710 reports.

---

## 6. Lean infrastructure

### 6.1 Guarded build orchestration

- **Computes/does:** runs an explicit queue of Lean targets unattended, so a caller launches one
  sequence and later reads an **atomic status file** instead of polling Lake. A single build-owner
  lock is acquired before the quiet-state check and held for the whole run, so two runners cannot
  both observe a quiet tree and launch. `build` queues behind the current owner rather than
  refusing and hands back one `await` command if the build outlasts the caller's window; `await`
  and `lock` are read-only. It terminates only the child it started — never another lane's work.
- **Pieces:** `lean/scripts/guarded-lean` (the guarded entry point; direct `lake` is forbidden),
  `lean-build-queue.py`, `lean-build-systemd{,-worker,-probe}.py`, `lean-build-profiles.json`,
  `lean-restart-guard.py`, `lean-blast-radius.py` (ranks modules by how much a change to them
  forces to rebuild, using the queue's recorded GNU-time elapsed fields).
- **Path:** `/home/tavis/src/othello/lean/scripts/`, rules in `lean/AGENTS.md` (= `lean/CLAUDE.md`).

### 6.2 Trust extraction and certificate firewall

- **Computes:** a machine-checked separation between what Lean actually proves and what a
  manuscript claims. `lean-trust-spine.py` compares declarations against exported facts and never
  builds; `lean-trust-extract.py` is the only component that puts Lean in the loop, running the
  fact exporter per declared extraction unit — deliberately split so `audit` and `check` stay
  read-only and cannot be tempted into starting a build.
  `lean-certificate-dependency-firewall.py` rejects project-owned dependencies from self-contained
  certificate packages. `lean-certificate-{boundary,portfolio-audit}.py`,
  `lean-package-source-audit.py`, `lean-paper-bridge-{audit,export}.py`, `lean-external-fact.py`,
  `external-trust-exports.py` (with its own unit test) round out the layer.
- **Generators emitting Lean from certificates:** `lean/scripts/generate_golden_cubic_elimination.py`
  ("kernel-checkable elimination identities for the Golden cubic", exact `Fraction` arithmetic),
  `generate-six-vertex-one-factorization.py`.
- **Export:** `lean-companion-export.py` materializes one immutable Lean *area* — the module
  closure of one declared gate, named by a tracked configuration under `lean/trust/export/` — onto
  an immutable `finitegeom` revision, pinning exact source commits on both sides.
- **Path:** `/home/tavis/src/othello/lean/scripts/`.

### 6.3 The formal-annotation layer (claim-map checker)

- **Computes:** whether a manuscript's stated formal coverage still matches its Lean terminals and
  its evidence. Six typographically-empty LaTeX macros carry the record inside the environment
  they describe: `\coverage` (`absent` / `fragment` / `conditional_deduction` / `complete`),
  `\lean` (reviewer terminals), `\uses`, `\proves`, `\imports`, `\evidence`. `\lean`/`\uses`/`\proves`
  follow Massot's Lean blueprint macros so blueprint tooling can read the same source; the reading
  of `\uses` in a statement as conceptual and in a proof as logical follows KnowTeX
  (arXiv:2601.15294); `\coverage`, `\imports`, `\evidence` are local.
- **The gate:** every claim-map row is **pinned by digest** to both the statement text and the
  terminals it describes, so a rewrite fails the check until the row is re-examined. This closes a
  real observed failure: an atomic restructure replaced a headline theorem's proof while its
  claim-map row stayed byte-identical.
- **Registries** (under each paper's `verification/`, so a standalone export carries them):
  `imported-sources.json` (per entry: `citation`, `pinpoint`, `used`, and a non-empty `conventions`
  list of `aspect`/`requirement`/`matched` triples — the point being that misuse of an imported
  theorem is usually an unmatched convention, not a wrong citation) and the evidence registry.
- **Checker:** `verification/check_annotations.py` (regex-parses claim-map rows keyed by
  `lem:`/`prop:`/`thm:`/`cor:` labels against `supplement/LEAN-STATEMENTS.md` and
  `verification/claim-map.json`), plus `check_abstract.py`.
- **Path:** convention `notes/formal-annotation-conventions.md`; reference implementation
  `papers/cubic-stabilization-m1/`; also adopted in `papers/high_weight_grs_cosets/verification/`.

---

## 7. Cross-cutting scripts and conventions

### 7.1 The evidence-bundle / replay convention

- **What it requires:** every paper-facing computational claim is an atomic, git-visible bundle —
  dated report, exact script/generator, and compact machine-readable certificate committed
  together under the owning lane's allowed paths with a common stem
  (`<date>-c<id>-<slug>.{md,py,json,sha256}`). Each report must record the exact command and
  working directory, all load-bearing inputs/parameters/conventions/seeds (with deterministic
  canonical enumeration preferred over randomness), what the output certifies **and does not**
  certify plus the checker's trusted boundary, SHA-256 hashes and byte counts for the generator and
  every load-bearing output, and an independent replay / reference implementation / invariant check
  — or an explicit statement of why none exists. An untracked `/tmp` file or a claimed run is never
  sole evidence.
- **Path:** `notes/research-reproducibility-conventions.md`; companion conventions
  `notes/literature-audit-conventions.md`, `notes/novelty-extraction-conventions.md`,
  `notes/task-lifecycle-conventions.md`, `notes/export-and-mirror-conventions.md`,
  `notes/discovery-track-conventions.md`.

### 7.2 Per-paper verification and release harnesses

- Nearly every released paper carries a `verification/` (and often `supplement/`) directory with the
  same shape: `check_manuscript_build.py`, `verify_release.py`, `trust_manifest.json` +
  `build_trust_manifest.py`, `extract_statement_identity.py` / `statement_identity.json`,
  `generate_sparse_shadow_export.py` with a `.sha256`, `evidence/` bundles, `lint_tex_spacing.py`,
  and `formalization-ledger.md` / `claim-proof-novelty-ledger.md` /
  `adversarial-proof-evidence-audit.md`. `papers/clebsch-passages/verification/` additionally has
  per-companion Lean verifiers (`verify_{four_shadow,golden_return,passages}_lean.py`),
  `extract_axiom_report.py`, `extract_source_closure.py`, and `verify_scaffold.py`.
- **Paths:** `papers/{arcs_complete_outside_conic,chordal-conference-reconstruction,clebsch-factorization,clebsch-passages,clebsch-rigidity,cubic-stabilization-m1,cubic-stabilization-irrationality,high_weight_grs_cosets,ame_lu,mds_css_transversal_groups,golden-operator}/verification/`.

### 7.3 Task-ID allocator and misc repository scripts

- `notes/scripts/allocate_codex_task_ids.py` (the only sanctioned way to reserve a C-ID) and
  `next_codex_task_id.py`; per-task computation scripts `c879_module_closure.py`,
  `c912_fmanifold_discriminant_identity.py`, `c912_kkpy_cubic_charpoly.py`,
  `c912_kkpy_erratum_scalar_ode.py`, `c946_multitarget_check.py`,
  `extract_c222_adequacy.py`; sweep directories `2026-07-03-almost-mirror/`,
  `2026-07-03-geometry/`, `2026-07-11-coding-mds-sweep/`.
- `rust/scripts/` holds ~194 one-off exact-computation scripts (mostly Python, some `.rs`)
  spanning the cap, Nofil, Node-Kayles, arcs, and double-coset investigations, many in
  generator + `_replay.py` pairs (e.g. `c495_cloud_packet_d10_identification{,_replay}.py`,
  `c496_bihecke_two_sort_coupling{,_replay}.py`,
  `c497_double_coset_stratum_constancy{,_replay}.py`).
- `rust/scripts/asg_session_waste_audit.py` audits agent-session transcripts for wasted work.

### 7.4 Literature cache

- **What it is:** a disk-backed, manifest-indexed cache of fetched papers and their `pdftotext`
  extractions, shared across sessions and lanes, keyed by normalized DOI / arXiv id, with
  `ingest` / `lookup` / `verify` operations and a content sniff on ingest (added after a file named
  like a PDF turned out to be a Cloudflare interstitial). Deliberately on a ZFS mount rather than
  the RAM-backed `/tmp` because Lean builds on this host OOM at 26 GiB.
- **Path:** `/tmp/persistent/tavis/lit-search/{README.md,manifest.json,pdf/,text/,bin/litcache.py}`
  (outside the repository, so not git-visible — it records fetched bytes, not that a paper was read).

---

## 8. Summary table

| Asset | Kind | Reusable core | Current consumers |
|---|---|---|---|
| Othello engine (`rust/src/`) | search engine | bitboard move-gen + PVS + flat-arena TT + Multi-ProbCut, value-preserving engine ladder | Python `othello` package parity tests; dormant |
| Queens/Node-Kayles solver (`rust/src/queens/`) | search engine | incremental dihedral canonical key carried down the DFS; selective graph-iso key; parity-aware rayon root parallelism | Queens n=16/n=18 solve; archived lane |
| BuRR retrieval + `BurrStore` (`rust/src/burr.rs`, `queens/store.rs`) | canonical form / storage | GF(2)-ribbon static retrieval at ~1.05-1.1x r bits/key with fingerprint membership; log-structured eviction-free memtable→segment store with disk segments and resume | Queens solver only — otherwise unconsumed |
| Graph-iso keys (`rust/src/queens/graph.rs`) | canonical form | Weisfeiler-Leman / individualisation-refinement canonical key over an available-graph, with a tiny-table fast path | Queens solvers |
| Projective cap-game solver (`notes/2026-07-0[45]-*cap*.py`) | search engine | incremental forbidden-mask memoized negamax over line-incidence bitmasks | cap lane, Nofil manuscript |
| Canonical grid cap-game solver (`notes/2026-07-06-grid-cap-solver.rs`) | canonical form + search engine | anchor min-image canonicalization under an affine automorphism group, with private-memo per-class campaign mode | cap lane q<=23 campaigns |
| Nofil mirror harvest (`rust/scripts/*_nofil.py`, `projcap_mirror_harvest.py`) | generator | verified construction of classical-variety boards + fixed-point-free involution search | Nofil paper, Lean mirror theorems |
| Copycat/pairing boundary checker (`rust/scripts/c80_*.py`) | certificate checker | explicit-strategy certification replacing a Grundy-value oracle | cap lane C80 frontier |
| Projective Reed–Solomon Toolkit (`papers/high_weight_grs_cosets/software/`) | search engine + certificate checker | semilinear canonicalization by exact lexicographic charts; exact projective locator; fail-closed theorem-gated classifier with replayable certificates | released paper + DOI; extraction-ready standalone crate |
| GRS coset census (`.../supplement/evidence/`) | generator + certificate checker | exhaustive `PGL(2,q)`/`PΓL(2,q)` orbit census with completeness identity and structured invariants | R5–R11 paper claims |
| GRS release harness (`.../supplement/verify.py`, `verification/`) | infra | one-entry-point hash + replay verifier over a manifest of artifacts | that paper; template for others |
| AME evidence engine (`papers/mds_css_transversal_groups/supplement/evidence/`) | generator + certificate checker | exact symplectic/Lagrangian enumeration with byte-identical certificate reconstruction, no external CAS | AME Papers I and II |
| Dihedral Node-Kayles solver (`rust/scripts/nodekayles_cayley.rs`) | search engine | component-decomposed memoized Sprague–Grundy over `u64` bitmasks | dihedral paper; three-way cross-checked |
| Twisted-cubic orbit machinery | generator | explicit `PGL(2,q)` stabilizer generation reducing invariants to orbit counting; ILP for `q=81,243` | cubic lane; completion paper §6.5 |
| Gröbner/Singular bundles (chordal, cubic-m1, GRS stable components) | certificate checker | own Buchberger implementation cross-replayed by Singular primary decomposition, plus method-disjoint finite-field point enumeration | Clebsch and cubic-stabilization papers |
| Lattice/SymPy probes (`notes/cubic-threefolds-tasks/c925-*.py`) | generator | signed-permutation basis search for rank-seven type-I1 lattices | cubic-threefolds lane |
| Guarded Lean build queue (`lean/scripts/`) | infra | single-owner lock + atomic status file + unattended queue + rebuild blast-radius ranking | all Lean work, host-wide |
| Lean trust extract / firewall / companion export | infra + certificate checker | read-only declaration-vs-facts audit split from the only build-invoking component; project-dependency firewall for self-contained certificate packages; commit-pinned area export | every Lean-facing paper; `finitegeom` exports |
| Lean-from-certificate generators (`generate_golden_cubic_elimination.py`, `generate-six-vertex-one-factorization.py`) | generator | exact-rational elimination identities emitted as kernel-checkable Lean | golden / Clebsch companions |
| Claim-map annotation checker (`verification/check_annotations.py` + `claim-map.json`) | certificate checker | digest-pinned rows tying manuscript statements to Lean terminals, imported sources with matched-convention triples, and evidence bundles | cubic-stabilization-m1 (reference), high_weight_grs_cosets |
| Evidence-bundle convention (`notes/research-reproducibility-conventions.md`) | infra | atomic git-visible report+generator+certificate with hashes and a mandatory independent replay | every lane |
| Per-paper release harnesses (`papers/*/verification/`) | infra | trust manifest, statement identity extraction, sparse-shadow export, TeX linting, build check | all released papers |
| Literature cache (`/tmp/persistent/tavis/lit-search/`) | infra | DOI/arXiv-keyed blob + text cache with manifest hash verification and ingest sniff | literature audits across lanes |
| Task-ID allocator (`notes/scripts/allocate_codex_task_ids.py`) | infra | the single sanctioned C-ID reservation path | queue and every lane |
