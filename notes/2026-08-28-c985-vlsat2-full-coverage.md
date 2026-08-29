# C985 full VLSAT-2 theorem-coverage control

**Lane**: `complete-ports`

## Result

Ergodis was run over all 100 rows of the official VLSAT-2 table.  This is a
logical theorem-coverage control, not performance evidence.

| Official table label | Exact theorem hit | Clean miss | Error/timeout |
|---|---:|---:|---:|
| UNSAT | 50 | 0 | 0 |
| SAT | 1 label conflict | 49 | 0 |

All fifty officially UNSAT formulas receive independently replayed
coloring-clique certificates.  The widened recognizer also produces an exact
certificate for `vlsat2_67996_13708722.cnf`, which the official table labels
SAT.  The downloaded current official bytes have SHA-256
`4b8c93ad8ac62716970a4bf2ff385399c264e203d32575b671424c871311877c`.
They parse as 764 direct-coloring vertices over 89 colors and contain a
90-vertex clique.  The checker streams all 13,708,722 clauses, validates the
67,996-variable header and every domain and same-color conflict used by the
clique, and therefore establishes UNSAT by pigeonhole.  This is recorded as an
`official_label_conflict`, not silently counted against either side.  External
maintainer confirmation remains appropriate before describing the website as
erroneous rather than the current downloadable bytes and table as inconsistent.

The official index identifies the suite as 100 Petri-net-derived formulas,
states 50 SAT and 50 UNSAT, and defines column four as the satisfiability label.
The committed manifest pins its current HTML as
`e725973c163d318322873fb2f37a77b08e9c5f61b1e3e98736be4087d1d66614`
and pins every download by name, byte count, and decompressed SHA-256.

## Scaling change

The first full pass exposed seventeen formulas whose positive coloring clauses
exceeded 64 literals.  The recognizer now uses a fixed 1,024-literal parser
buffer and pre-sized multiword domain/edge bitmaps.  The edge-color table keeps
the existing 64 MiB fail-closed cap, the clique search remains iterative, and
neither clause loop allocates or grows storage.  A one-word branch retains the
former scalar adjacency loop for the common at-most-64-color case.  After this
change, sixteen former width exits become clean SAT-side misses and the
remaining case becomes the exact label conflict above.

## Evidence and replay

The runner writes one JSON object per instance directly to line-buffered JSONL;
it does not retain CNFs or clause sets.  The independent checker streams each
CNF again and retains only compact domain bitsets and conflicts relevant to the
reported clique.

```sh
cd papers/complete-repair-ports/ergodis
ERGODIS_BENCH_CPU=3 scripts/vlsat2-full-coverage.sh
```

Committed evidence:

- manifest SHA-256: `f96a5efefb01e5c3dd777040e7cb8dabc2b4fc86305cd6a991b1112b67655abf`;
- raw JSONL SHA-256: `734e5a45a58e030584765704aaf8554055c5eb81b8b81c34bf726b343af23295`;
- coverage JSON SHA-256: `7c52ec5bd41393366c58f6fc6ac0829847bc8e2352f0bbb26c1538f8c6948287`;
- checked Ergodis binary SHA-256:
  `e3fd9d83f84ecc5eef92cf915d607e8ae0069e4e27e75abccb1baa1beb4d6d1f`.

The coverage JSON additionally pins the runner, checker, streaming clique
replayer, shared process runner, and manifest.  Full `cargo test
--all-features`, fresh-target all-target/all-feature Clippy with warnings denied,
Rust formatting, Python byte compilation, Ruff, the one-command full replay,
and its independent checker pass.

## Performance boundary

No elapsed value from this logical-coverage run is a benchmark claim.  The
shared timing harness requires a performance governor and disabled boost/turbo,
and records the CPU topology and isolation state.  By explicit user direction,
isolation is not a refusal condition on this quiet host; timing reports must
state that the pinned physical core was not kernel-isolated.
