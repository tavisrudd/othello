# C1034 — gem-hunt task crate and the C1018 helper lift

**Date**: 2026-09-02
**Lane**: `gem-mining`
**Scope**: `ergodis-private/` and `notes/`. The public core under
`papers/complete-repair-ports/ergodis` was not modified.

## Goal

Step 1 of `notes/2026-09-02-ergodis-private-crate-consolidation-proposal.md`: turn
`ergodis-private/` into a Cargo workspace, absorb the ten gem-mining exploration binaries into
one tier-2 task crate with a single `gem-hunt` binary, and lift the helper functions those
binaries duplicated into tier-1 `ergodis-private` library modules. Flag names, defaults, and
output stay byte-identical so every committed replay command and certificate digest survives.

## Layout

```
ergodis-private/
  Cargo.toml                  [workspace] members = [".", "tasks/gem-hunt"]
  src/arith.rs                gcd, lcm, prime divisors, binomials, prime-power split, Smith normal form
  src/gf2_linalg.rs           Word, rref, span, dual_basis, popcount_and, all_ones
  src/css_codes.rs            reed_muller, multilinear_level
  src/prs.rs                  Field over GF(p^h), sym_power, quadratic_type, rank_of
  tasks/gem-hunt/
    Cargo.toml                depends on ergodis-private (path "../..") and ergodis (path "../../../papers/complete-repair-ports/ergodis", features control-plane + parallel)
    src/main.rs               clap dispatch only
    src/{prs_deephole,prs_census,prs_stratum}.rs
    src/{transversal_css,level_census}.rs
    src/{plane12,plane12_hyperoval}.rs
    src/{exterior_sets,chain_ring,parametric_cert}.rs
```

Each module exposes `pub fn run(<Args>) -> ...` and a `#[derive(clap::Args)]` struct;
`main.rs` contains nothing but the command tree and the dispatch `match`.

No `.cargo/config.toml` was added: the workspace builds into `ergodis-private/target`, which
already exists and is already ignored.

### Subcommand tree

```
gem-hunt prs deephole | census | stratum
gem-hunt css transversal | levels
gem-hunt plane12 --out FILE multiplier | sidon | orbit13 | starter | hyperoval
gem-hunt exterior-sets
gem-hunt parametric-cert
gem-hunt chain-ring                      (behind the off-by-default `chain-ring` feature; see below)
```

Three deviations from the tree suggested in the proposal, each so that no existing flag name
changes:

| Suggested                        | Built                    | Reason                                                                                                          |
|----------------------------------|--------------------------|-----------------------------------------------------------------------------------------------------------------|
| `prs census {auto,kernel,subset}`| `prs census --rank-mode` | The three rank strategies were already values of the driver's `--rank-mode` flag, not separate modes of operation. |
| `css transversal {probe,analysis}`| `css transversal`       | The transversal driver has no probe/analysis split; it always analyses the catalogue and always reports its probes. |
| `plane12 orbit`                  | `plane12 orbit13`        | `orbit13` is the existing subcommand name in the committed replay commands.                                     |

`plane12 hyperoval` takes its output path from the shared `plane12 --out`, so `--out` now precedes
the subcommand for that search. Every other flag of the completion search is unchanged, and it
still writes its own certificate and prints its own compact stdout summary rather than the shared
pretty-printed document the other four `plane12` subcommands emit.

## Old command → new command

The last commit containing each old file is `9cd2ecdd` (`c1018: add plane12 hyperoval completion
search`); each file is unchanged in that commit from its previous state, except
`c1018_plane12_hyperoval.rs`, which that commit adds. Replay any historic bundle at `9cd2ecdd` or
earlier.

| Old file (under `ergodis-private/src/bin/`) | Old command                                     | New command                                     |
|---------------------------------------------|-------------------------------------------------|-------------------------------------------------|
| `c1018_prs_deephole.rs`                     | `c1018_prs_deephole --q Q --r R …`               | `gem-hunt prs deephole --q Q --r R …`            |
| `c1018_prs_census.rs`                       | `c1018_prs_census --r R --q Q …`                 | `gem-hunt prs census --r R --q Q …`              |
| `c1025_prs_stratum.rs`                      | `c1025_prs_stratum --r R --q Q --stratum-mod M …`| `gem-hunt prs stratum --r R --q Q --stratum-mod M …` |
| `c1018_transversal_css.rs`                  | `c1018_transversal_css --distance-inputs DIR`    | `gem-hunt css transversal --distance-inputs DIR` |
| `c1018_level_census.rs`                     | `c1018_level_census --census N --threads T`      | `gem-hunt css levels --census N --threads T`     |
| `c1018_plane12.rs`                          | `c1018_plane12 --out F SUB …`                    | `gem-hunt plane12 --out F SUB …`                 |
| `c1018_plane12_hyperoval.rs`                | `c1018_plane12_hyperoval --out F --n N …`        | `gem-hunt plane12 --out F hyperoval --n N …`     |
| `c1020_exterior_sets.rs`                    | `c1020_exterior_sets --q LIST …`                 | `gem-hunt exterior-sets --q LIST …`              |
| `c1028_chain_ring.rs`                       | `c1028_chain_ring --out DIR --cert F`            | `gem-hunt chain-ring --out DIR --cert F`         |
| `c1029_parametric_cert.rs`                  | `c1029_parametric_cert --n-max N --out-dir D …`  | `gem-hunt parametric-cert --n-max N --out-dir D …`|

`chain_ring` and `parametric_cert` parsed their arguments by hand from `std::env::args`. They now
use `clap::Args` structs whose long-flag spellings and defaults reproduce the hand-rolled parsers
exactly (`--out`, `--cert`; `--n-max`, `--out-dir`, `--ladder-top`, `--ladder-s-max`,
`--ladder-c-max`, `--witness-s-max`, `--ladder-fit-max`, `--tag`). Unlike the originals, an
unknown flag now fails through clap rather than through a hand-written `bail!`/silent default.

## Parity

Baseline: the ten binaries built at commit `9cd2ecdd` from a read-only `git archive` extraction in
`~/.cache/ergodis/c1034-parity`, release profile, with the working-tree public core reached through
a `papers` symlink. New side: `ergodis-private/target/release/gem-hunt`, release profile.

| Case                    | Old command                                                                        | New command                                                                     | Digest                                                     | Verdict |
|-------------------------|------------------------------------------------------------------------------------|----------------------------------------------------------------------------------|------------------------------------------------------------|---------|
| deep-hole cross-check   | `c1018_prs_deephole --q 11 --r 5 --ergodis-crosscheck`                              | `gem-hunt prs deephole --q 11 --r 5 --ergodis-crosscheck`                          | `a8724a88c88aafb519540b1c7a1328d002e7a8ecbea45cbffd457f14449adc63` (stdout) | equal   |
| deep-hole census cell   | `c1018_prs_deephole --q 13 --r 8 --out F`                                           | `gem-hunt prs deephole --q 13 --r 8 --out F`                                       | `e3e9cb6ca08233b93a640df1c45f8b163cb56a967b0e2e48df179d2955adebc4` (JSON and stdout) | equal   |
| census, rank-mode auto  | `c1018_prs_census --r 5 --q 11 --max-reps 16 --rank-mode auto --out F`              | `gem-hunt prs census --r 5 --q 11 --max-reps 16 --rank-mode auto --out F`          | `14b15db6213278d47eae7359615b7eb1d53e44e567842db0d6dbde7173038926` | equal   |
| census, rank-mode kernel| `… --rank-mode kernel …`                                                            | `… --rank-mode kernel …`                                                          | `8e0f2ab8341de9fc33542708187d34628c1493b3db1811f2fce5518c016eea07` | equal   |
| census, rank-mode subset| `… --rank-mode subset …`                                                            | `… --rank-mode subset …`                                                          | `f1435751cfc2949dbf412a24d54059af8c5bd053e48ace818c6e658194acae00` | equal   |
| stratum decision        | `c1025_prs_stratum --r 5 --q 11 --stratum-mod 2 --stratum-class 1 --threads 4 --out F` | `gem-hunt prs stratum --r 5 --q 11 --stratum-mod 2 --stratum-class 1 --threads 4 --out F` | `c64ccd273ba46c2f76c6a954248891f418174feb0a46fb81e516a9994d287daa` (JSON, `seconds` dropped) | equal   |
| transversal groups      | `c1018_transversal_css --distance-inputs DIR`                                       | `gem-hunt css transversal --distance-inputs DIR`                                   | `bd116225567c5876b7567acf7773c7f7db1c3e4aa5b08342a748b50a8ee10fc1` (stdout); `04999305055e567a23fc4df9490eee575782ee06df7c923ac537c87895e9d3ac` (distance-input directory) | equal   |
| level ladder            | `c1018_level_census --ladder`                                                       | `gem-hunt css levels --ladder`                                                     | `01ca519c80cfa8c7fc0b98f52db6ca454e26732e9122b1e30d9fe4395955598d` | equal   |
| level census, 1 thread  | `c1018_level_census --census 6 --threads 1`                                         | `gem-hunt css levels --census 6 --threads 1`                                       | `eac62088c1abc2130d53b36dc6165c30d3fc8077af78ab251cec0903ba27d276` | equal   |
| plane12 multiplier      | `c1018_plane12 --out F multiplier --v 157 --k 13`                                   | `gem-hunt plane12 --out F multiplier --v 157 --k 13`                               | `13fd8783ae8412e3e1e1d689c71835d0988877d3c346c1f511e7afecc66942dd` | equal   |
| plane12 starter         | `c1018_plane12 --out F starter --m 13`                                              | `gem-hunt plane12 --out F starter --m 13`                                          | `a5a157eef9118904ec21715cc332b6242666e9522a279b200310f9ad4943c1df` | equal   |
| plane12 orbit13         | `c1018_plane12 --out F orbit13 --n 12 --cap 10`                                     | `gem-hunt plane12 --out F orbit13 --n 12 --cap 10`                                 | `2af142439345f31d717f55c3974443573858269177b183f6f0f514b30e2957b5` | equal   |
| plane12 sidon           | `c1018_plane12 --out F sidon --v 21 --k 5`                                          | `gem-hunt plane12 --out F sidon --v 21 --k 5`                                      | `cb35b23825b533a16b88c2bba61c0d55d592ca3b5b576eec0c8213d04df0351a` | equal   |
| hyperoval completion    | `c1018_plane12_hyperoval --out F --n 12 --hyperoval --threads 4 --depth 2`          | `gem-hunt plane12 --out F hyperoval --n 12 --hyperoval --threads 4 --depth 2`      | `e7de096cec0f03fa658bb5180d0b6d36f68aab962133eaa3937521ccf96d3689` (JSON, `seconds` dropped) | equal   |
| exterior sets, one set  | `c1020_exterior_sets --q 11 --points 2,37,57,66,78,125`                             | `gem-hunt exterior-sets --q 11 --points 2,37,57,66,78,125`                          | `28971d21c668eb2eccbf39a7c5aba1f3a6c77c07c8fcbf5bd7934cdbdde3ffac` (stdout) | equal   |
| exterior sets, census   | `c1020_exterior_sets --q 5,7,9 --json-out F`                                        | `gem-hunt exterior-sets --q 5,7,9 --json-out F`                                     | `f6e9165780713dc0bc3d7ad20767f5805cf4ff83a7de4855be93ba62b74236b8` (certificate JSON, `elapsed_s` dropped) | equal   |
| parametric certificate  | `c1029_parametric_cert --n-max 200000 --out-dir D --tag parity`                     | `gem-hunt parametric-cert --n-max 200000 --out-dir D --tag parity`                  | `0483e0392525112f51784b199afaa70b8282df8f0b6402ec725760c9117b3050` (certificate file) | equal   |

Notes on the three cases whose raw bytes need a caveat:

- The stratum, hyperoval, and exterior-set outputs embed wall-clock fields (`seconds`,
  `elapsed_s`). Those fields are dropped before hashing; everything else matches byte for byte.
  The exterior-set census additionally prints its own `json_out=PATH sha256=…` line, and the
  reported certificate hash is identical on both sides.
- `css levels --census` is nondeterministic across runs of the **old** binary at `--threads 8`:
  three consecutive baseline runs of `c1018_level_census --census 6 --threads 8` produced two
  distinct digests, differing only in which example witness each row reports. This is a
  pre-existing property of the driver's multi-worker merge, not an effect of the move. At
  `--threads 1` the old and new binaries agree byte for byte, and the deterministic `--ladder`
  sweep agrees at any thread count.
- No parity run for `chain-ring`; see below.

Larger committed replay cells (`prs census --r 9 --q 19`, `plane12 sidon --v 157 --k 13`,
`prs stratum --r 17 --q 29`) were not run: each exceeds the ten-minute ceiling for this task. The
cheapest committed or constructed case with the same flags was used instead, as recorded above.

## Helper lift

Every function below had two or more copies. Where copies differed, the difference and its
resolution is stated; no copy's behaviour was changed.

| Lifted to                       | Was duplicated in                                                        | Difference between the copies                                                                                                                     |
|---------------------------------|--------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------|
| `prs::Field` (+ `a m n i pow from_int primitive`) | prs deep-hole, prs census, prs stratum                     | Doc comments; the census spelled the exponentiation method `powi`; the stratum copy defined only `new/a/m/n/i`. The lifted type is the superset with the `pow` spelling, and the census call site was renamed. |
| `prs::sym_power`                | prs deep-hole, prs census                                                | Doc comments and the `pow`/`powi` spelling only.                                                                                                   |
| `prs::quadratic_type`           | prs deep-hole, prs census                                                | The deep-hole copy maintained an unused `distinct` counter it then discarded with `let _ = distinct;`. Dropped; it never affected the result.       |
| `prs::rank_of`                  | prs deep-hole, prs stratum                                               | Doc comment only.                                                                                                                                  |
| `arith::factor_prime_power`     | prs deep-hole, prs census, prs stratum                                   | A local variable name (`m` versus `mm`).                                                                                                           |
| `arith::factor_prime_power_u16` | exterior sets (only copy of this shape)                                  | Genuinely different: `u16 -> Result<(u8, u8)>`, trial division from below, error instead of `None`. Kept under its own name rather than unified.    |
| `arith::binom`                  | prs deep-hole, prs census                                                | Identical.                                                                                                                                         |
| `arith::gcd_i128`               | transversal CSS, level census, parametric certificate                    | Identical.                                                                                                                                         |
| `arith::gcd_u64`                | plane12                                                                  | Same algorithm at `u64`; the signed version returns `a.abs()`, this one `a`. Kept separate.                                                        |
| `arith::lcm_i128`               | transversal CSS, level census                                            | Identical.                                                                                                                                         |
| `arith::lcm_i128_nonzero`       | parametric certificate                                                   | Genuinely different: no zero guard, so `lcm(0, 0)` divides by zero where `lcm_i128` returns `0`. Kept separate.                                     |
| `arith::prime_divisors_usize`   | prs census                                                               | Same algorithm at `usize`.                                                                                                                         |
| `arith::prime_divisors_u64`     | plane12                                                                  | Same algorithm at `u64`. Both kept, since neither caller's integer width is the other's.                                                           |
| `arith::smith_normal_form`      | transversal CSS, level census                                            | Comments only.                                                                                                                                     |
| `gf2_linalg::{Word, rref, span}`| transversal CSS, level census                                            | Identical.                                                                                                                                         |
| `gf2_linalg::dual_basis`        | transversal CSS, level census                                            | The pivot list built by a loop in one copy and by `map().collect()` in the other. Same result.                                                     |
| `gf2_linalg::popcount_and`, `all_ones` | transversal CSS (single copies, moved for cohesion with the rest of the module) | —                                                                                                        |
| `css_codes::reed_muller`        | transversal CSS, level census                                            | One copy reduced a moved-out local, the other reduced in place. Same result.                                                                       |
| `css_codes::multilinear_level`  | transversal CSS, level census                                            | Comments and one inlined temporary (`deg`).                                                                                                        |

Deliberately **not** lifted: the census's `rref` over `F_q` (a field-valued reducer returning
pivot columns) shares only a name with `gf2_linalg::rref` over `F_2`, and has a single caller.

Each new module carries unit tests of the lifted behaviour: `arith` covers gcd/lcm including the
zero cases that separate the two `lcm` spellings, prime divisors, binomials, prime-power splitting
in both widths, and a Smith normal form; `gf2_linalg` covers reduction, duals, spans, and the
64-bit `all_ones` edge; `css_codes` covers Reed–Muller dimensions and the T, S, and odd-order
Clifford-hierarchy levels; `prs` covers field construction and rejection, a primitive element, a
symmetric power of the identity, the three quadratic types over GF(5), and rank.

## The two C1018 Cargo features

`c1018-sparse-action` and `c1018-lane-action` gated exactly one thing, in
`c1018_prs_census.rs`: which of three `ergodis::projective` binary action-pack types the
`BinaryActionPack` alias resolves to, and hence which monomorphization the dense binary orbit
worker is compiled against.

They are **not** converted to runtime flags. They now live on the `gem-hunt` crate, where the code
they gate lives, and select the same three types.

The reason is the performance contract. `worker_binary_dense` carries
`#[unsafe(export_name = "ergodis_private_binary_dense_orbit_worker")]`, which forbids making it
generic, and the retained note directly above it records that a trait-shared worker erased the
isolated radix win and perturbed the generic control under fat link-time optimization. A runtime
flag therefore means either dynamic dispatch inside the orbit loop or three duplicated
`export_name`d workers. The core `PERFORMANCE.md` treats either as a hot-loop change requiring a
before/after profile and an interleaved hardware-counter A/B in both single-thread and parallel
modes; this consolidation makes no such measurement and so makes no such change.

The identically named features remain declared on `ergodis-private` itself, where they now gate
nothing. Removing them belongs to the tier-1 library-only split (proposal step 2), not here.

## Performance rules that applied, and how they were checked

The moved code contains no Ergodis solve kernel. It is exploration and certificate-construction
code: orbit sweeps over small projective spaces, catalogue analysis, Smith normal form, and
backtracking searches, all built on the read-only public core. The rules that did bind, and the
check for each:

- **A move must not add allocation, dynamic dispatch, or indirection in a hot path.** The lifted
  functions were moved verbatim (see the difference column above) and their signatures are
  unchanged, so allocation behaviour and monomorphization are unchanged. The one place where a
  runtime abstraction would have been introduced is the action-pack selection, and it was
  rejected for exactly this reason.
- **No run-constant branch inside a loop; dispatch once, preferably to a const-generic
  monomorphization.** Preserved by keeping the action-pack choice a compile-time type alias.
- **Worker ownership and contention-free parallelism.** The three parallel drivers (prs census,
  prs stratum, level census, hyperoval completion) keep their existing per-worker scratch, atomic
  cursors, and post-join reduction; no field, lock, or shared buffer was added or moved between
  workers.
- **Exact result and certificate parity.** Established by the parity table above, which is the
  evidence that the move preserved semantics.
- **Counter A/B evidence.** Not collected, and not required: no hot-loop instruction, branch, or
  layout change was made. The one candidate change was declined rather than made without it.

The private kernel registry (`ergodis-private/performance/`) names no kernel in the moved files,
so no registry entry changed.

## Test results

`cargo fmt --all -- --check`: clean.

`cargo clippy -p gem-hunt --all-targets -- -D warnings`: clean. The `gem-hunt` crate carries a
crate-level `#![allow(...)]` list mirroring `ergodis-private`'s own: every lint on it fires on code
carried over unchanged, and silencing rather than rewriting is what keeps the move a move.
`cargo clippy --workspace --all-targets -- -D warnings` still fails, entirely on `ergodis-private`
code this task did not touch — `g41_q174_flip_corpus`, `g41_q29_block_spec_census`,
`alignment_control`, `proof_synthesis`, and `q29_exact_anneal`. That is pre-existing foreign work.

`cargo check --workspace`: clean, with two pre-existing dead-field warnings carried over from the
absorbed binaries (`exterior_sets::Plane::external_slot`, `level_census::Record::n`).

`cargo test --workspace`: exit code 0, 12 min 50 s. Across all test binaries in the workspace,
621 passed, 0 failed, 0 ignored, 0 filtered out. The `ergodis-private` library suite alone reports

```
test result: ok. 561 passed; 0 failed; 0 ignored; 0 measured; 0 filtered out; finished in 662.99s
```

which is the previous 544 plus the 17 tests added with the four new modules (5 in `arith`, 4 in
`gf2_linalg`, 3 in `css_codes`, 5 in `prs`). The `gem-hunt` crate has no tests of its own; its
behaviour is covered by the parity table above.

A first run of the same command reported two failures, both in tests written for this task rather
than in lifted code: `gf2_linalg::tests::all_ones_edges` asserted the wrong popcount for
`0b1011 & 0b0111`, and `prs::tests::rank_of_identity_and_dependent_rows` called a pair of rows
independent that is in fact proportional over GF(5) (`(2, 4, 1) = 2 * (1, 2, 3)`, since `6 = 1`).
Both assertions were corrected; no lifted function changed.

## Skipped, and why

1. **`chain-ring` has no parity run and is behind an off-by-default feature.** The binary it
   replaces does not build at commit `9cd2ecdd`, in either the debug or the release profile:

   ```
   papers/complete-repair-ports/ergodis/src/field.rs:178:31: error[E0080]: evaluation panicked:
   assertion failed: P >= 2 && is_prime(P): evaluation of `ergodis::Prime::<4>::VALID_MODULUS`
   failed here
   … while instantiating `fn ergodis::Matrix::new_field::<Prime<4>, Vec<u8>>::{closure#2}`
   ```

   The driver's `probe_no_entry_point` deliberately calls `Matrix::new::<4>` to record that
   `Prime<4>` has no applicable entry point; the public core has since made that const assertion a
   hard codegen error, so the probe can no longer be compiled at all. The same error appears
   identically on both sides, which is itself evidence that the move changed nothing.

   This break predates the consolidation and lives in the public core, which this task must not
   edit. Under one binary per lane it would block the whole `gem-hunt` binary rather than one of
   119 files, so the subcommand sits behind the off-by-default `chain-ring` Cargo feature and
   everything else builds. **This needs a decision**: either the public core regains a way to
   express "this modulus is invalid" without a codegen-time panic, or the C1028 probe is rewritten
   to record the rejection some other way. Until then the C1028 certificate is not replayable at
   `HEAD` by any route.

2. **Long committed replay cells were not reproduced.** `prs census --r 9 --q 19`,
   `plane12 sidon --v 157 --k 13`, and `prs stratum --r 17 --q 29 --stratum-mod 7` all exceed the
   ten-minute ceiling. Smaller cells exercising the same code paths and flags were run instead.

3. **The two C1018 features were not converted to runtime flags**, for the measured-performance
   reason given above.

## Foreign issues raised

- `ergodis-private` does not pass `cargo clippy --workspace --all-targets -- -D warnings`; five
  files outside this task's scope fail it.
- `c1028_chain_ring` has been unbuildable since a public-core change to `Prime<P>`'s const
  assertion; see item 1.
