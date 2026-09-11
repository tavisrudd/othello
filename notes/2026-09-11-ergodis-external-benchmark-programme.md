# Ergodis external benchmark programme

**PRIVATE — not to ship.** Lane: `ergodis`. User-authorized 2026-09-11.

## Decision and order

Tackle the following in order, preserving the preceding benchmark review as context.
A completed measurement or a documented capability gate is progress; no result is
preordained. General improvements must not encode instance answers, seeds or supplied
reduction banks. The decoder name is **TigerBlossom**, not Tiger.

| Task | Scope | Acceptance / comparator |
|---|---|---|
| C1143 | Bivariate-bicycle syndrome-extraction circuit distance | Pin published circuits; preserve full fault hyperedges and logical labels; validate lowering independently; ordinary/Evolve/learned-only runs against Gurobi, SCIP, m4riCC and SAT where available; distinguish witness upper bounds from certified lower bounds. |
| C1144 | Held-out BB, lifted-product and Quantum Tanner code distance | Freeze QDistSAT family holdouts before tuning; both logical directions, exact distance versus bounded-radius exclusion; compare SAT/MaxSAT and code-distance backends; learn structure from inputs. |
| C1145 | Exact hypergraph fault decoding | Color/BB circuit fault models; compare Tesseract and MaxSAT/ILP, plus practical BP-based decoders at matched logical error rate. Most-likely individual fault is not maximum-probability logical coset. TigerBlossom/PyMatching remain graphlike controls where applicable. |
| C1146 | Multidimensional knapsack and generalized assignment | OR-Library first, then a declared bounded-integer MIPLIB subset; ordinary/Evolve/reuse against Gurobi, SCIP and CP-SAT; held-out dimensions, weights and tightness; representation selection and exact decline/fallback. |
| C1147 | Resource-constrained project scheduling | PSPLIB; genuine durations, precedence and resource conflicts, not static simultaneous allocation relabelled as scheduling; CP-SAT/CP Optimizer/Gurobi comparisons; model and capability gaps explicit. |

## Common experimental contract

- Freeze external input revisions, hashes and development/holdout split before tuning.
- Preserve original coordinate/witness interpretation. No graph decomposition that
  changes a hypergraph objective. No supplied solutions or theorem answers.
- Ordinary execution receives every generally applicable compiler improvement;
  never weaken it to manufacture an Evolve win. Label restricted ablations.
- Compare fresh Evolve, ordinary, learned-only reuse (discovery off), and strong
  external solvers. Competitors receive equivalent reuse/warm-start opportunities.
- Report parsing/problem setup, compilation, discovery, search, verification and
  end-to-end time distinctly. Match CPU/core budgets; collect instructions,
  cycles, branches/misses, cache effects and peak RSS. Busy-host wall samples alone
  do not establish speedup. Cold and warm results stay separate.
- Preserve the native performance contract, zero-allocation bounded iterative
  search and single/parallel retained A/B gates. Shared native/WASM machinery;
  private adapters and analysis stay private. Do not duplicate core for demos.
- Independently check source lowering and witnesses. Search completion, a valid
  witness and independently certified optimality are different claims. Include
  generated small-instance oracles, permutations, malformed inputs and mutations.
- Timeouts are censored observations, never completed speed ratios. Record losses,
  clean-miss overhead and capability cliffs. Published timings are context until
  input/objective/hardware/boundary differences have been reconciled.

## Historical context recovered by Luna

These are historical notes, not new measurements or unconditional claims.

- C985 corrected eight-workload suite covers Ceph XOR, GF(4) towers, Azure LRC,
  repair DAGs, QC-LDPC exclusion, vector span, Hamming outer LRC and GPU MDS.
  Corrected protocol: `2026-08-28-c985-application-benchmarks-corrected-ab.md`.
  Timeout lower bounds and superseded headlines must remain labelled.
- C985 Gurobi comparison includes improved formulations, not just its weakest
  encoding: `2026-08-29-c985-ergodis-theorem-import-roadmap.md`.
  Prior BB360/BB784 exact-distance work: `2026-08-29-c985-qdist-bb360-exact-distance.md`
  and `2026-08-29-c985-bb784-exact-distance.md`. Static code distance does not
  establish syndrome-extraction circuit distance.
- TigerBlossom's later weighted Stim endpoint supersedes the early sparse-tree
  loss: 27/33 instruction and 30/33 cycle wins, zero weight/prediction disagreements.
  PyMatching working-set asymmetry remains unresolved; pre-2026-09-04 surface
  results are invalid. Legacy certificate checks cannot be used as independent
  authority. Source: `2026-09-03-c1061-exploration-log.md`; current caveats in lane map.
- C1061 incremental LRC top-k, routing and queue/layout probes include harness
  corrections and declared-width assumptions; preserve them, do not recycle old
  headline ratios. `2026-09-03-c1061-probe15-incremental-topk-and-tie-closed-state.md`.
- C1038 negative controls include a severe CP-SAT win and a width-cap decline:
  `2026-09-02-c1038-negative-control-benchmark-tier.md`. These are mandatory context
  for allocation representation selection, not embarrassing rows to omit.
- C1017 core A/Bs are kernel remediation evidence, not external solver rankings:
  `2026-08-30-c1017-ergodis-core-performance-contract-remediation.md`.
- C1062 causal comparisons were revised down and include fixture-dial effects:
  `2026-09-05-c1062-closeout-synthesis.md`. C1070 leakage primarily establishes
  correctness/representation results: `2026-09-06-c1070-closeout-synthesis.md`.
- Hadamard uses supplied structured models and general join compilation; browser
  smoke timings are not statistical benchmarks. Current sources are routed by
  C1130 in the Ergodis handoff. No claim of discovering supplied Williamson/GS
  structure or solving unrestricted matrices follows.

## Primary external sources

- Webster, Jacob, Higgott, *Distance-Finding Algorithms for Quantum Codes and
  Circuits*: https://arxiv.org/abs/2603.22532 and code/data
  https://github.com/m-webster/codeDistancePYPI . BB circuits are the hardest
  circuit family in their study; Gurobi completed only the smallest within eight
  hours. This motivates C1143; it does not predict our result.
- QDistSAT artifact: https://github.com/guluchen/QDistSAT . BB/LP/QT matrices,
  SAT/MaxSAT and Gurobi/SCIP/m4ri/Magma adapters.
- Tesseract: https://arxiv.org/abs/2503.10988 and
  https://github.com/quantumlib/tesseract-decoder . Strong general fault-search
  comparator; matching's limitations do not imply a vacant benchmark niche.
- PyMatching: https://github.com/oscarhiggott/PyMatching . Correlated matching is
  supported; correlated noise alone is not a differentiator.
- OR-Library: https://people.brunel.ac.uk/~mastjjb/jeb/orlib/mknapinfo.html .
- MIPLIB: https://miplib.zib.de/ . Declare the supported subset explicitly.
- PSPLIB: https://www.om-db.wi.tum.de/psplib/ .

## Initial gate

C1143 is active. First deliverable: pinned circuit corpus manifest, semantic
lowering audit and bounded independently checked smoke run. Remaining tasks are
queued behind it. No new performance result is claimed by this plan.
