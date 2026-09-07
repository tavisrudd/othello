# C1123 — Coherent repository analytical projection

Date: 2026-09-07. Lane: `ergodis`. Status: in progress.

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
