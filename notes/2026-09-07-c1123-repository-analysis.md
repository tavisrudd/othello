# C1123 — Coherent repository analytical projection

Date: 2026-09-07. Lane: `ergodis`. Status: complete. Private commits `c835284`, `2820c67`; core dependency `67d929b`.

## Scope and acceptance

User approved allocation and implementation of read-only repository snapshot tables
for run heads, lineage, attempts and accounting, with consistency and exact counter
gates. Private tooling owns the bridge; existing portable/native APIs own admission.
Allowed implementation paths: `ergodis-private/tasks/tools/{Cargo.toml,src/main.rs,src/repository_projection.rs}`,
`ergodis-private/Cargo.lock`, `ergodis-private/python/ergodis_notebook/repository.py`,
`ergodis-private/analysis/check_repository_projection.py`, and
`ergodis-private/analysis/repository-projection.md`. Task routing/report paths here
are also owned. No solver or mathematical verification changes.

Acceptance: actual native repository export into DuckDB and notebook-callable Python;
coherent source revision; current-head ancestry distinguished from staged records;
exact unsigned 64-bit accounting; interruptions retain charges; malformed/unsupported
projection rejection; detached queries unaffected by subsequent repository changes.

## Result

Private `ergodis-tools repository-projection --repository PATH` emits a bounded
inspection-only JSON projection. `ergodis_notebook.repository.load_projection`
opens that file as a fresh detached DuckDB catalog with heads, record ancestry,
update/fork edges, attempts and logical/physical accounting. Every table carries
the source repository identity and committed revision. Imported bytes receive a
SHA-256 identifier; it is not authentication. Schema v1 withholds sidecars.

No core edits were needed. Capture brackets the existing native immutable bundle
export with two exact-equal repository snapshots, retrying at most three times.
The native handle checks repository identity; committed revisions cannot ABA.
Staged immutable additions can leave revision unchanged but cannot change existing
head ancestry. Traversal includes only published-head ancestry, checking supplied
parent links and excluding staged-only branches. Sustained concurrent commits,
missing ancestry, corrupt bundles and existing aggregate-export limits fail closed.
A derived catalog grants no publication, writer, execution or mathematical authority.

All source u64 values are canonical decimal strings. The loader validates them
and inserts Python integers into explicit DuckDB UBIGINT columns, including
`18446744073709551615` and `9007199254740993`. No float conversion or automatic
JSON type inference occurs. Charges remain conservative after interruption;
physical observations remain lower bounds. Tables retain their types when empty.

## Validation

- Native real-filesystem fixture test passes: staged-only empty projection,
  u64-max reservation, published update, owner interruption, staged then published
  fork, detached capture, deterministic interleaved capture retry and exhaustion,
  corrupt bundle and missing ancestry rejection.
- Actual operator CLI output matches native fixture output after reopening the
  stored repository. The notebook-callable loader passes exact accounting,
  update/fork lineage joins, source-revision coherence, detached historical queries,
  empty tables and 14 malformed/unsupported/oversize rejection cases.
- Final `cargo fmt --check`, scoped Rust tests, CLI build and `git diff --check`
  pass. DuckDB Python version: 1.5.5, pinned in the documented replay.
- Whole-tool `cargo clippy -p ergodis-tools --all-targets --all-features -- -D warnings`
  remains blocked by the single pre-existing `needless_range_loop` diagnostic in
  `tasks/tools/src/leakage_dual_tower.rs:116`, already recorded by C1098. No
  suppression or foreign edit. This is not a clean whole-tool Clippy claim.
- No core, WASM, solver or hot-layout changes; no performance claim or broader
  core parity/build rerun. This checks the notebook-callable API, not Jupyter UI.
- Cache GC dry run passes; nothing removed. All implementation paths are committed.

Exact commands are in private `analysis/repository-projection.md`. Final fixture
output: `/home/tavis/.cache/ergodis/c1123-projection-final`; regeneration uses a
fresh directory (native creation deliberately refuses an existing repository).
The committed Rust test is the fixture generator; Python assertion script invokes
the real CLI and independently checks SQL values against explicit expected values.
The cache is disposable and is not sole evidence or a paper-facing artifact.

Final run-quiet captures under `/tmp/claude-run-quiet/`:
`20260907-154110-nix-shell-nixpkgs...` (fmt/test/build),
`20260907-154139-uv-run-with-duckdb1.5.5...` (SQL/CLI),
`20260907-153826-nix-shell-nixpkgs...` (initial gates/inherited Clippy failure),
and `20260907-154133-cache-gc.sh` (dry run).

## Closeout and retained boundary

Cheap closeout review added ordinary update ancestry and a nonzero observed-work
counter above JavaScript's exact range to the already passing fork/u64-max corpus.
Those additions were revalidated and forward committed as `2820c67`.
Discovery-track review: no incidental mathematical finding to log.

Mystery ledger: no mathematical mystery arose. The apparent unchanged-revision
staging issue is settled by immutable content plus published-head reachability.
Unsettled engineering scope is explicit: aggregate export can reject a larger
valid repository; pagination requires separate admission. Browser repository
extraction is not implemented. Those are product limits, not unexplained results.

C1033 is the existing downstream owner for saved-run notebook presentation and
lineage exploration. This bridge does not close its broader notebook/Sage work,
migrate legacy control clients, implement execution recovery or allocate a new
backend. Recommended next move: consume these tables in C1033's notebook lineage
view, with the current read-only authority boundary preserved.
