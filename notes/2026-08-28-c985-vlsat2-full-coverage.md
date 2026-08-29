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
- raw JSONL SHA-256: `ad7406f008ee369f0d310f3e87e7d34ee10080acf4f014a290d0ce03d08cd24f`;
- coverage JSON SHA-256: `e2edc33afaaef3f51e6c20b97f712443e18c96e140c6b15ea48e7053d79e1160`;
- checked Ergodis binary SHA-256:
  `53efb2980b204a0d22b1de1ffeb4559acab45702d82f901e2647573cce028911`.

The coverage JSON additionally pins the runner, checker, streaming clique
replayer, shared process runner, and manifest.  Full `cargo test
--all-features`, fresh-target all-target/all-feature Clippy with warnings denied,
Rust formatting, Python byte compilation, Ruff, the one-command full replay,
and its independent checker pass.

## Performance boundary

No elapsed value from this run is a benchmark claim.  The shared canonical
timing harness now requires a performance governor, disabled boost/turbo, and
kernel isolation of every online SMT sibling of the pinned physical core.  The
current host fails all three conditions.  Canonical A/B evidence therefore
remains blocked until a controlled host is configured; diagnostic-host output
is not committed as timing evidence.

