# Queens public artifact export + OEIS clearance recheck

Date: 2026-08-11

Two things were done at the user's request: the queens solver and its verification resources were
extracted into a fresh-history repository outside this monorepo, and both queued OEIS submissions
were rechecked for pre-emption.

## The exported repository

`~/src/queens-nimbers`, fresh history, published by the user at
`github.com/tavisrudd/queens-nimbers` (first commit `d611e4b`). Crate name `queens-nimbers`,
library `queens_nimbers`, binary `queens`, MIT license. A second commit (`874c2a0`) adds
`.zenodo.json` for release DOI minting, an OEIS package README, descriptive filenames for the two
OEIS documents, and a cold-reader pass over all prose: internal work-breakdown labels, session and
handoff references, agent-guide citations, and a private path were removed from source comments,
the OEIS documents no longer address a submitter, and the program link is recorded now that the
code is public.

| Exported path         | Source in this repo                                                        |
|-----------------------|-----------------------------------------------------------------------------|
| `src/queens/**`       | `rust/src/queens/**`                                                        |
| `src/bin/queens.rs`   | `rust/src/bin/queens.rs`, with `othello::` rewritten to `queens_nimbers::`   |
| `src/burr.rs`, `src/affinity.rs`, `src/table.rs` | the only non-queens modules the solver and CLI use |
| `src/lib.rs`          | new: declares the four modules                                              |
| `Cargo.toml`          | new: only the dependencies queens actually uses (clap, libc, rayon, serde, serde_json, signal-hook, terminal_size, zstd) |
| `verification/lean/**`| `lean/NodeKayles/{Basic,Grundy,Certificate,GrundyCertificate}.lean`, `lean/Queens/*.lean`, plus a new root `NodeKayles.lean`, a two-library `lakefile.toml`, and the copied `lean-toolchain` / `lake-manifest.json` |
| `oeis/A344227/**`     | `papers/oeis-submissions/A344227-queens-nimbers/` minus the internal handoff |
| `docs/**`             | `notes/queens-n18-paper.md`, `queens-report.html`, `queens-explorable.html`  |
| `README.md`, `verification/README.md`, `verification/RESULTS.md`, `LICENSE`, `.gitignore` | new |

**Deliberately excluded.** `lean/NodeKayles/ConflictGameEquiv.lean` (it imports
`CapGame.GraphMirror`, which drags in the cap-game library and is not in the `Queens` closure);
`notes/handoffs/2026-07-01-queens-nimber-a344227.md` (lane peg, session UUIDs, private worktree
path — its results table and validation chain were rewritten into `verification/RESULTS.md`); the
whole Othello engine; the performance-history notes and negative-optimization record.

**Private-coupling screen.** The exported tree was searched for `/home/tavis`, `src/othello`,
`notes/handoffs`, lane pegs, and session UUIDs: clean. The OEIS submission package's internal links
were repointed at the new layout.

## Validation of the extraction

- `cargo build --release`: clean, no warnings.
- `cargo test --release`: 43 passed, 0 failed, 2 ignored (timing microbenches). This includes the
  scalar differential gates `graph_wins8_matches_scalar` and `direct_w9..w20_matches_scalar_recurrence`,
  the layers the n = 18 verdict bottoms out on.
- Replay of the nimber results from the fresh checkout: `a(13)=1` (0.46 s), `a(14)=0` (1.05 s),
  `a(15)=1` (17.5 s), `a(16)=0` (130.2 s) — the catalogued term plus three of the four new terms,
  all matching. `a(17)` (about 59 h) and the n = 18 outcome (about 8 h per run) were not replayed.
- Lean import closure checked to be self-contained (only the copied `NodeKayles.*`/`Queens.*`
  modules plus Mathlib). **The Lean package was not built** in the new tree: that needs the guarded
  entry point and the owning build window per `lean/AGENTS.md`. Open gate.

## OEIS clearance recheck (2026-08-11)

**A344227 (queens nimbers) — still clear.** Query:
`curl "https://oeis.org/search?q=id:A344227&fmt=json"` (the plain entry page 403s a fetch; the
search endpoint returns the record). The entry is at revision #54 dated 2025-05-27, with
`data = 0,1,1,2,1,3,1,2,3,1,0,1,0,1` — 14 terms, `a(0)..a(13)`, offset `0,4`, keyword `more,nonn`,
no `%E` extension lines and no b-file. Nobody has added `a(14)..a(17)`, and the 1,0-oscillation
comment that `G(17)=2` refutes is still on the entry.

**Sum-free ℤₙ Grundy values — still no entry.** Queries against the same endpoint: the data prefix
`0,1,1,2,0,0,0,2,1,1,0,0,0,2,2,3,0,0,0,2,1,3` returned nothing, the shorter prefixes returned
nothing, and the keyword searches `sum-free achievement game`, `sum-free set game Z_n`, `Nofil`,
and `sum-free game Grundy` returned nothing. Control: searching A344227's own data string returns
exactly A344227, so the method finds a sequence when one exists.

**Literature side, both sequences.** arXiv API, sorted by submission date: `all:"node kayles"`
returns nine papers, most recent *Node-Kayles on Trees* (2025-12-30) — structural complexity, no
queens nimber computation; `all:"non-attacking queens"` returns ten, most recent
*Improved asymptotic upper bound on the n-queens completion threshold* (2026-06-23) — the placement
problem, not the game; nothing on a sum-free achievement game. The Huggan–Huntemann–Stevens *nofil*
paper (2021) remains the closest genus and is already cited in the sum-free draft.

Nothing pre-empts either submission. Both remain the user's to submit.

## Open gates

1. The Zenodo integration must be switched on for the repository before a release mints a DOI;
   `.zenodo.json` supplies the metadata but not the hook.
2. MIT was chosen as the license; no license file existed in this monorepo to inherit from.
3. The Lean package has not been built from the exported tree.
4. Once published, the public URL unblocks the A344227 `%H` program link, the n = 18 comment, and
   the sum-free entry's program link.
