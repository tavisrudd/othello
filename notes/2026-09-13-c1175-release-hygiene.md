# C1175 — Ergodis release hygiene: manifest walk, exported manifest, guard tightening, toolchain pin

**Lane**: `ergodis`
**Date**: 2026-09-13
**Status**: complete. Core commit `b63c6dc`.
**Predecessor**: the C1171 review (`2026-09-12-c1171-rule-programme-review.md`, rows R6–R9)
and the C1173/C1174 "not done" items (WASM ABI gate rerun, formatter pin).

## What was done

All work is in the private core checkout `~/src/ergodis`. No `src/` file changed; no solver
path or hot loop was touched.

1. **WASM ABI gate rerun (C1173/C1174 debt).** `docs/rule-contract.md`'s replay sequence run
   verbatim under the Nix shell: `cargo test -p ergodis-rules -p ergodis-verify`, native
   C ABI replay, `wasm32-unknown-unknown` release build, `node crates/rules/tests/wasm_abi.mjs`.
   Result: native ABI 129 min-plus programs plus one Boolean closure with independent oracle
   and lifecycle gates passed; WASM module host 129 programs, native certificate and Python
   oracle parity, lifecycle gates passed. The C1173 selectors and the C1174 Boolean carrier
   are therefore live through the WASM ABI, not only the native one.
2. **R6 — manifest walks the code.** `python/generate_evidence.py` no longer keeps a
   hand-maintained source list. `HASHED_TREES` now walks `benches`, `crates`, `docs`,
   `evidence`, `examples`, `proptest-regressions`, `python`, `scripts`, `src`, `tests` and
   `wasm/src` in full; `HASHED_PATHS` keeps only the top-level files. Bytecode caches, `target`
   and `node_modules` directories are excluded. No previously hashed row was dropped; the
   manifest grew from 209 to 602 rows and `--check` passes.
3. **R7 — the exported manifest describes the exported tree.** `scripts/export-public.sh`
   now runs the tree's own generator inside the filtered, rewritten tree before the lint, with
   bytecode writing disabled. The generator's `--write`/`--check` skip the `results.json` half
   when `evidence/` is absent, so the same script serves both trees.
   `tests/evidence_manifest.rs` no longer skips in a published checkout: the manifest check
   runs everywhere. Verified by a dry-run export in a throwaway clone: 472-row manifest, no
   `evidence/` row, `--check` passes in the exported tree, lint clean, and the two hygiene
   test binaries pass there under a separate target directory.
4. **R9 — evidence lint inside `cargo test`.** `tests/evidence_manifest.rs` gained a second
   test that runs `scripts/public-lint.sh` on `evidence/` and `proptest-regressions/` with the
   crate allowlist; it skips only when the (never exported) lint script is absent.
5. **R8 — guard tightening.**
   - `hooks/pre-push` refuses `refs/heads/main` to every remote, publication or not. Other
     refs to a non-publication local remote remain allowed.
   - The recorded-tag check in both `hooks/pre-push` and `scripts/publish-to-staging.sh`
     matches the whole fourth `EXPORTS.md` column, so `v0.2` no longer passes on the strength
     of a recorded `v0.2.0`.
   - `scripts/public-lint.sh` scans files grep classifies as binary for the same task-id and
     private-path byte strings, reported at line 0, allowlist honoured.
   - The stale per-session tmpfs scratch path in `scripts/export-public.sh` and
     `tests/publication-guards.sh` is replaced by `${ERGODIS_SCRATCH:-~/.cache/ergodis/scratch}`.
6. **Formatter pin (C1174 debt).** `rust-toolchain.toml` pins `1.95.0` with `rustfmt`,
   `clippy` and the `wasm32-unknown-unknown` target; this matches the current Nix toolchain
   and is what rustup will now select. `tests/toolchain_pin.rs` fails when the compiler
   running the tests is a different release than the pin, which is the drift signal for the
   Nix side. The rustup `stable` on `PATH` is 1.93.1 with rustfmt 1.8.0, which is the
   formatter that produced the C1173 discrepancy.
7. **Docs.** `AGENTS.md` validation gate, public `README.md` validate section,
   `docs-private/README.md` guard table and `docs-private/RELEASE-CHECKLIST.md` updated.

## Validation

| Gate | Result |
|---|---|
| `cargo fmt --check` (Nix rustc 1.95.0, rustfmt 1.9.0) | clean |
| `cargo clippy --all-targets --all-features -- -D warnings` | clean |
| `cargo test --all-features` (includes the new manifest, evidence-lint and toolchain-pin tests) | pass |
| `tests/publication-guards.sh` | 82 passed, 0 failed (new: 4 binary-scan cases, tag-prefix refusal in script and hook, main-to-unnamed-remote refusal, manifest regeneration and `--check` in the exported fixture tree) |
| `shellcheck -S warning` on the five edited shell files | clean |
| Dry-run export of the working tree in a throwaway clone | exported manifest 472 rows, no evidence rows, `--check` and lint pass, `evidence_manifest`/`toolchain_pin` tests pass in the exported tree |
| WASM ABI gate (`wasm_abi.mjs`) | pass, 129 programs + Boolean closure |

## Found on the way

- The first dry-run export was refused by the new binary scan: running the generator in the
  exported tree had written `__pycache__/*.pyc` files carrying `/home/tavis/...` into the
  tree, and `git add -A` would have shipped them. Fixed with `PYTHONDONTWRITEBYTECODE=1`; the
  binary scan is what caught it, which is the R8 argument made concrete.

## Not done, and why

- NIT-9 of the C1171 review (the process-document list in `public-lint.sh` and
  `.publicignore` are kept in sync by hand) is unchanged; it was not in the C1175 row. The
  lint runs on filtered trees where `.publicignore` is already gone, so deriving one from
  the other needs the lint to read the private repository's copy, a small design choice
  rather than a line.
- `rust-toolchain.toml` pins the release that `nixpkgs-unstable` currently ships. When
  `nixpkgs` moves, `tests/toolchain_pin.rs` fails and the pin is bumped with a reformat in
  one commit; no automation watches for that.
- rustup users offline on first use will see the pin try to install 1.95.0 and fail. That
  is the pin working.

## Commits

- Core (`~/src/ergodis`): `b63c6dc`.
