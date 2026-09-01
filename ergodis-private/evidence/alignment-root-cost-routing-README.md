# Alignment root-cost routing audit

This bundle measures target-strategy ordering on an application-derived
Ergodis corpus rather than on the shaped two-row mechanism controls.

`alignment_root_corpus` fixes each triple of the alignment-attachment problem
in turn and exhausts the remaining search.  Its search-path control is
preallocated and only copies the first active-root snapshot; serialization and
classification occur after all searches.  Every controlled result is rerun
through the ordinary uncontrolled solver and must match its answer and exact
state, duplicate, and infeasible counters before any corpus is written.

The label is whether a forced root's exact state count is at least the corpus
median.  The plan interface contains six coarse root features.  Rows with
identical feature vectors are observationally indistinguishable, so summing
the majority label in each feature class gives an exact upper bound for every
possible plan over this interface.

| Corpus | Rows | Observable classes | Exact interface ceiling |
|---|---:|---:|---:|
| Development: points 8, budget 8 | 56 | 5 | 39/56 |
| Held out: points 7, budget 7 | 35 | 4 | 20/35 |

Both corpora use the same frozen seed, `root_orbit > 3`, target class
`root_sized = 0`, four generations, beam 8, and a 128-candidate cap.  The
held-out configuration and all evolution settings were fixed before its
corpus was generated.

| Corpus / strategy | First ceiling trial | Semantic-op rows to ceiling | Total tested |
|---|---:|---:|---:|
| Development / balanced | 49 | 8,232 | 124 |
| Development / numeric | **32** | **5,376** | **106** |
| Development / structural | 49 | 8,232 | 124 |
| Held out / balanced | **2** | **210** | 124 |
| Held out / numeric | **2** | **210** | **118** |
| Held out / structural | **2** | **210** | 124 |

Numeric ordering therefore reaches the exact observable ceiling 1.53x sooner
on the development application corpus.  It is neutral on held-out discovery:
the theorem-derived `counterexample-threshold` repair reaches the ceiling at
trial 2 before generic family ordering can matter.  Numeric routing does not
delay that repair and exhausts the bounded search with 4.8% fewer candidates.
This is evidence for conditional routing, not a claim that numeric ordering
universally improves alignment search.

Machine-readable corpus reports, evolution reports, and all referenced
streamed JSONL evidence are retained in this directory.  Each report carries
the SHA-256 hashes of its inputs and evidence.  Ephemeral manifests, ledgers,
socket paths, and controller credentials are intentionally excluded.

Replay from `ergodis-private/` with fresh create-only paths:

```sh
CARGO_TARGET_DIR=../rust/target-c985-private-profile \
  cargo run --release --bin alignment_root_corpus -- \
  --points 8 --budget 8 \
  --output examples/data/replay-alignment-root-cost-p8-b8.jsonl \
  --report evidence/replay-alignment-root-cost-p8-b8-report.json

CARGO_TARGET_DIR=../rust/target-c985-private-profile \
  cargo run --release --bin target_strategy_audit -- \
  --data examples/data/alignment-root-cost-p8-b8.jsonl \
  --seeds examples/data/alignment-root-cost-seeds.jsonl \
  --run-root evidence/replay-alignment-root-cost-routing-runs \
  --output evidence/replay-alignment-root-cost-routing-report.json \
  --target-field root_sized --target-value 0 \
  --generations 4 --beam 8 --max-candidates 128
```

Replace `8` by `7` in the corpus paths and use `--points 7 --budget 7` to
replay the held-out corpus with otherwise identical evolution settings.
