# C1030 round 2 — binaries, test suite, python checkers, replay commands

**Task**: C1030 round 2 · **Lane**: `complete-ports` · **Scope**: binaries, test suite, python checkers, replay commands

Seven findings at the SEV1/SEV2 bar. One equivalence gate licenses a committed measured-negative
while exercising none of the code it claims to compare. One committed, hashed evidence file is a
truncated list with no record of the truncation. One verifier never checks the headline number of
the certificate it verifies. Three binaries emit a fixed provenance string, an unmarked partial
enumeration, or a ratio computed from the wrong operands. One replay script's byte-identity step
cannot fail it. Every quotation below was re-read from the working tree in this session
immediately before being written up, including the ones that reached me through a parallel probe;
two leads were dropped after re-reading refuted them, and those are recorded under
"Not found / checked clean" so the same ground is not re-walked.

Coverage. Read completely and traced: all three files under `ergodis-private/tests/`; the
`#[cfg(test)]` modules in `certiis.rs`, `c985_extension_field_elimination_bench.rs`,
`c985_binary_projective_bench.rs`, `hall_certify.rs`, `lp333_orbit_lock.rs` and `g53_search.rs`
(these six are the complete set under `src/bin/`); the python checkers `verify_hall_certificate.py`,
`c1029_check.py`, `c1029_break.py`, `check_c1028_chain_ring.py`, `check_hadamard_reduction_scout.py`,
`check_c997_native.py`, `check_c997_gurobi.py`, `check_c997_parity_ab.py`, `certiis_core_audit.py`,
`semantic_core.py`, `c880_alignment_provenance.py`, the witness-emission path of
`run_c997_gurobi.py`, `scripts/projective_hall_replay.py`, `scripts/projective_hall_scout.py`, and
the small `test_*.py` suite. Thirty-six binaries were opened and read, including every evidence
emitter: the `c1018_*`, `c1020_*`, `c1025_*`, `c1028_*`, `c1029_*`, `c80_*`, `c985_*`, `g53_q4_*`,
`g53_q7_*`, `hadamard_*`, `hall_certify`, `lp333_*`, `projective_grid_scout`, `q16_*`, `q25_*`,
`semantic_*` and `z2k_*` families. The remaining sixty-five are thin `g41_*`, `g53_sparse_*` and
`g133_sparse_*` wrappers that pass one or two flags into a single library call and print the
library's report; every clap field in all fifty-three `Parser` structs was machine-checked for a
consumer outside its struct definition, and none is dead, but the JSON those wrappers emit is built
inside library code that was not audited field-by-field, so parameter-versus-record mismatches
originating in the library remain unchecked for that group. All thirteen rows of
`evidence/SHA256SUMS` were verified by recomputation. `certdist.rs` and `certiis.rs` were audited in
round 1 and revisited only where a new question arose.

## SEV1 — the extension-field elimination equivalence gate never runs an elimination

**Location**: `/home/tavis/src/othello/ergodis-private/src/bin/c985_extension_field_elimination_bench.rs`
— fixture at `:122-140`, `rref_table` at `:46-80`, `rref_binary` at `:83-120`, helper `agrees` at
`:201-216`, test `binary_specialization_matches_table_reduction` at `:218-226`, benchmark `run` at
`:148-171`. Committed at `9305f95e6` and unmodified in the working tree.

**Verified quote** — the fixture, `:122-140`:

```rust
fn fixture(order: usize, rows: usize, cols: usize, mut seed: u64) -> [u8; MAX_CELLS] {
    assert!(rows <= MAX_ROWS && cols <= MAX_COLS && rows <= cols);
    let mut data = [0_u8; MAX_CELLS];
    for row in 0..rows {
        for col in 0..cols {
            seed = seed
                .wrapping_mul(6_364_136_223_846_793_005)
                .wrapping_add(1_442_695_040_888_963_407);
            data[row * cols + col] = if col == row {
                1
            } else if col < rows {
                0
            } else {
                ((seed >> 32) as usize % order) as u8
            };
        }
    }
    data
}
```

and the two assertions it feeds, `:209-213`:

```rust
                assert_eq!(
                    rref_table(&field, rows, cols, &mut table),
                    rref_binary::<H>(&tables, rows, cols, &mut binary)
                );
                assert_eq!(table, binary);
```

**Mechanism.** With `rows <= cols` and the `else if col < rows { 0 }` branch, every fixture matrix
is exactly `[I_rows | R]`, a full identity block plus a single random block in columns `rows..cols`.
The two reducers are structurally identical loops. Trace either against `[I_rows | R]`:

- at each `col`, the pivot search `(pivot..rows).find(|&row| data[row * cols + col] != 0)` returns
  `pivot` itself, so the swap at `:53` / `:95` is a no-op and the search never advances past the
  diagonal;
- the pivot value is `1`, so `field.inverse(1)` / `tables.inverse[1]` is `1` and the scaling loop
  only ever computes `mul(x, 1)`;
- in the elimination loop, `factor = data[row * cols + col]` is `0` for every non-pivot row, so
  `if factor == 0 { continue; }` at `:66` / `:106` fires on every iteration;
- after `col == rows - 1`, `pivot == rows` triggers the `break` at `:75` / `:115`, so the random
  columns are never processed as pivot columns.

Both functions therefore return `rows` and leave `data` byte-identical to the input. The first
assertion compares the constant `rows` against the constant `rows`; the second compares two
untouched copies of `original`. The test passes if `rref_binary` is replaced by a function that
returns `rows` and touches nothing.

**Concrete trigger**: `cargo test --bin c985_extension_field_elimination_bench` on the committed
source. There is no input that reaches the divergent code, because the fixture is the only
generator — `agrees` at `:206` and `run` at `:150` both call `fixture(1_usize << H, rows, cols,
seed)` with `(rows, cols)` drawn from `[(4, 5), (8, 9)]`.

**What is untested.** That the characteristic-two backend computes the same row reduction as the
table backend. The one line where the two genuinely differ in semantics —
`data[row * cols + slot] = field.sub(data[row * cols + slot], product)` at `:71` versus
`data[row * cols + slot] ^= product` at `:111` — never executes. Neither does the pivot search past
the diagonal, the row swap, nor `BinaryTables::inverse` at any index other than `1`.
`BinaryTables::mul` is exercised only as `mul(x, 1)`, which is correct even for a transposed
multiply table because multiplication commutes, so a `multiply` table wrong for every pair with both
operands nonunit, a wrong `inverse` table, or a wrong `<< H` index packing for general operands all
survive the gate.

**Impact.** `notes/2026-08-27-c985-ergodis-optimization-paper.md:592-594` records: "Commit
`9305f95e6` adds a private exact elimination control rather than changing core: 256 deterministic
matrices at each degree 3--8 agree byte-for-byte between the table backend and a monomorphized
characteristic-two backend." The byte-for-byte agreement is real and empty — neither backend
modifies any of those matrices. The same fixture backs the timing half of the gate. The elimination
inner loop, the `O(rows^2 * cols)` term, never runs, so `table/binary = 0.933595x, t=-30.48` on the
"actual `4 x 5` Hankel shape" and `0.962630x, t=-3.43` on the "`8 x 9` stress shape" (`:596-599`)
time a reducer performing only the `O(rows * cols)` scaling pass. The closure of step (6) as a
measured negative, and the sentence "Bit-sliced/specialized elimination is therefore rejected for
this application", rest on that measurement. HEAD is `6fec8e9fa`, "docs: close extension-field
elimination gate", so this is a live gate rather than an old one.

**Aggravating detail in the same file.** The benchmark's `seed`, read at `:179` and passed to
`fixture` at `:150`, is not in the emitted record, `:168-170`:

```rust
    println!(
        "{{\"backend\":\"{backend}\",\"degree\":{H},\"rows\":{rows},\"cols\":{cols},\"repetitions\":{repetitions},\"elapsed_ns\":{elapsed_ns},\"rank_sum\":{ranks},\"checksum\":{digest}}}"
    );
```

`rank_sum` and `checksum` are functions of the seed, so two runs at different seeds produce
records that are indistinguishable in their metadata. The note cites "seven rotated `GF(64)` counter
pairs"; which seeds those were is recoverable only from the shell history. No JSON from this bench
is committed under `evidence/`.

**Described fix (not applied).** Drop the `else if col < rows { 0 }` branch so the whole matrix is
random over the field, restoring pivot search, row swaps, nontrivial inverses and the `sub` / `^=`
divergence; add `seed` to the emitted record; then re-run both the equivalence test and the timing
pairs and revise the note's numbers. Stated uncertainty: I did not run the bench, so I cannot say
what the corrected ratios are — only that the published ones do not measure elimination.

## SEV2 — the committed q=11 exhaustive Hall-rematch certificate is a truncated list with no record of the cap

**Location**: `/home/tavis/src/othello/ergodis-private/src/bin/c80_hall_rematch.rs:816-817` (flag),
`:509-540` (collector), `:831-845` (emitted `Summary`), `:972-976` (emission). Artifact:
`ergodis-private/evidence/c80-hall-rematch-q11-exhaustive.json`, row 3 of `evidence/SHA256SUMS`.

**Verified quotes.** The flag, `:816-817`:

```rust
    #[arg(long, default_value_t = 512)]
    candidate_cap: usize,
```

The collector that applies it, `:530-540`:

```rust
    fn offer(&mut self, key: ExchangeKey, record: FailureRecord) {
        if self.candidate_cap == 0 {
            return;
        }
        let position = self.candidates.partition_point(|entry| entry.0 < key);
        if position >= self.candidate_cap {
            return;
        }
        self.candidates.insert(position, (key, record));
        self.candidates.truncate(self.candidate_cap);
    }
```

The emitted `Summary` fields, `:832-845`, are `schema`, `q`, `mode`, `states_requested`, `seed`,
`threads`, `grundy_cap`, `full_admission`, `elapsed_seconds`, `metrics`, `first_failure`,
`admission_candidates`. There is no `candidate_cap` field.

**Mechanism.** `admission_candidates` in the committed artifact holds 8 records while
`metrics.failures_admission_candidates` in the same file is 1,984,400. The cap that produced the 8
survives only in the prose of `notes/2026-08-30-c80-hall-rematching-attack.md:304-305`:

```sh
$B --q 11 --exhaustive --full-admission --deterministic --threads 16 \
   --candidate-cap 8 --summary $E/c80-hall-rematch-q11-exhaustive.json
```

The neighbouring `--grundy-cap` on the same command *is* recorded in the summary, so this is one
missed field rather than a policy. `--candidate-cap 0` yields `admission_candidates: []`,
identical in that field to a genuine no-candidate run such as `c80-hall-rematch-q13-300.json`.

**Concrete trigger**: the command above, verbatim from the note.

**Impact.** The search itself is not truncated — only the collector is, and `offer` selects the
globally smallest candidates in `ExchangeKey` order (documented at `:512-515`) so the retained set is
thread-order independent and reproducible. That, plus the presence of
`metrics.failures_admission_candidates` in the same JSON, is what holds this at SEV2 rather than
SEV1: a careful reader can see 8 against 1,984,400 and infer a cap, but cannot recover its value or
distinguish "capped at 8" from "capped at 512 and only 8 were found" without the note.

**Described fix (not applied).** Add `candidate_cap` and a `candidates_truncated: bool` to
`Summary`, and regenerate the three `c80-hall-rematch-*.json` files with their `SHA256SUMS` rows.

**Related, same file.** The exhaustive branch records `seed: arguments.seed` at `:958` although
`arguments.seed` is consumed only by `sampled_roots` in the sampling branch at `:911`. The committed
q=11 exhaustive certificate therefore logs `seed: 98508030`, a value never applied.
`states_requested` is correctly zeroed for that mode at `:953-957`; `seed` was not given the same
treatment. Below threshold on its own, since `mode: exhaustive-size-four` discloses it.

## SEV2 — `certiis verify` never checks the certificate's stated Hall deficit

**Location**: `/home/tavis/src/othello/ergodis-private/src/bin/certiis.rs` — `deficit` occurs at
`:459` (struct field), `:814` (solver), `:1051` (a recomputed value inside a message string), and
`:2137` / `:2233` (tests only). Verify path at `:1033-1091`; tamper test
`verification_rejects_a_tampered_certificate` at `:2220-2242`.

**Verified quotes.** The solver sets the field once, `:812-814`:

```rust
                    demand,
                    neighborhood_capacity: capacity,
                    deficit: demand - capacity,
```

The verifier recomputes demand and capacity but not the deficit, `:1037-1055`:

```rust
                let d = demand(&distinct);
                let c = capacity(&hood);
                ensure!(
                    d == certificate.demand && c == certificate.neighborhood_capacity,
                    "stated demand/capacity ({}, {}) disagree with recomputation ({d}, {c})",
                    certificate.demand,
                    certificate.neighborhood_capacity
                );
                ensure!(
                    d > c,
                    "certificate does not violate Hall: demand {d} <= capacity {c}"
                );
                checks.push(format!(
                    "Hall violation recomputed independently: {} tasks demand {d} units, their {} \
                 eligible resources supply {c} (deficit {})",
                    distinct.len(),
                    hood.len(),
                    d - c
                ));
```

The `deficit {}` in the emitted check string is filled from `d - c`, the freshly recomputed value —
never from `certificate.deficit`.

The only test named for tampering, `:2229-2241`:

```rust
        if let Verdict::Infeasible { certificates, .. } = &mut report.verdict {
            let certificate = &mut certificates[0];
            certificate.tasks.push("c".into());
            certificate.demand += 1;
            certificate.deficit += 1;
            certificate.removal_tests.push(RemovalTest {
                removed_task: "c".into(),
                demand_after: 2,
                capacity_after: 1,
                still_violated: false,
            });
        }
        assert!(verify(&instance, &raw, &report).is_err());
```

**Mechanism.** The test instance is three unit-demand tasks against one capacity-1 resource
(`:2222-2226`), so the emitted minimal certificate is a 2-set. After the tamper the recomputation
agrees on neighbourhood, on demand (both 3) and on capacity (1), and `d > c` holds. The rejection
comes solely from the irreducibility check at `:1067-1071`, `rd <= rc` failing with `rd = 2`,
`rc = 1`. Incidentally the tampered `deficit` becomes *correct* (`3 - 1 = 2`).
`assert!(… .is_err())` cannot distinguish which `ensure!` fired, so the test's name is satisfied by a
check unrelated to the field it mutates.

**Concrete trigger**: `certiis solve --input inst.json --out report.json`, then edit `deficit` in
`report.json` to any value, then `certiis verify --input inst.json --certificate report.json`
(the subcommand at `:1667-1672` reads both files from disk). Verification succeeds and prints the
recomputed deficit rather than the stated one.

**Impact.** The stated deficiency is the headline number of an infeasibility certificate. Today no
emitted certificate carries a wrong one, because `:814` computes it correctly, which is why this is
SEV2 rather than SEV1 — the defect is silent but currently unreached by anything the tool itself
produces. The surviving-defect test is concrete: replace `demand - capacity` at `:814` with any
formula still yielding `1` on the one pinned case (`capacities_are_respected_in_both_directions` at
`:2117`, asserting `certificates[0].deficit == 1` at `:2137`) — for instance
`(demand - capacity).min(1)`. Every test in the module stays green and `certiis verify` accepts the
result.

**Described fix (not applied).** Add `ensure!(certificate.deficit == d - c, …)` beside the existing
demand/capacity check, and split the tamper test into one mutation per field so each assertion names
the check it exercises.

## SEV2 — `g53_q7_repair` stamps a fixed "q0–q6 repaired" provenance on a run whose prefix bounds came from flags

**Location**: `/home/tavis/src/othello/ergodis-private/src/bin/g53_q7_repair.rs:10-13` (flags),
`:16-28` (`Report`), `:33-37` (threading), `:40-41` and `:52-53` (provenance strings). Library guard
at `/home/tavis/src/othello/ergodis-private/src/g53_search.rs:1524-1526`.

**Verified quotes.** The flags, `:10-13`:

```rust
    #[arg(long, default_value_t = 4)]
    exact_input_prefix: u8,
    #[arg(long, default_value_t = 7)]
    target_prefix: u8,
```

The provenance, `:40-41` on the success branch and `:52-53` on the miss branch:

```rust
            schema: "ergodis-private-c1016-g53-q7-four-move-v1",
            provenance: "exact-local-replay; q0-q6 repaired and independently replayed",
```

```rust
            schema: "ergodis-private-c1016-g53-q7-four-move-v1",
            provenance: "bounded four-move miss; no negative coverage authority",
```

The library accepts any prefix pair in range, `src/g53_search.rs:1524-1526`:

```rust
    if exact_input_prefix == 0 || exact_input_prefix >= target_prefix || target_prefix > 7 {
        return Err(Hadamard2092Error::FixedField);
    }
```

**Mechanism.** Both flags are threaded into the computation at `:33-37`, and any
`1 <= exact_input_prefix < target_prefix <= 7` is accepted. Neither flag is a field of `Report`
(`:16-28`), and both provenance strings are `&'static str` literals. A run that repaired only up to
`q2` therefore emits a record whose schema name says `q7-four-move` and whose provenance sentence
says "q0-q6 repaired and independently replayed". The `deltas: Option<[[i32; 7]; 4]>` field at `:26`
emits seven residual slots regardless of `target_prefix`.

**Concrete trigger**:
`cargo run --release --bin g53_q7_repair -- --seed <hex-shell> --exact-input-prefix 1 --target-prefix 2`

**Impact.** No `ergodis-private-c1016-g53-q7-four-move-v1` record is committed under
`ergodis-private/evidence/`, so the exposure is future runs rather than a landed certificate — which
is why I rate this SEV2, one notch below the probe that raised it. What makes it worth reporting at
all is that the false statement lives in the `provenance` field, the one a reader of a stored record
has no way to cross-check.

**Described fix (not applied).** Make `exact_input_prefix` and `target_prefix` fields of `Report`,
and build the provenance string with `format!` from the values actually used.

## SEV2 — `c1018_plane12 orbit13 --cap` truncates the enumeration and the certificate says nothing

**Location**: `/home/tavis/src/othello/ergodis-private/src/bin/c1018_plane12.rs:54-59` (flag),
`:626-628` (prune), `:405-421` (`OrbitCertificate`), `:570-579` (verdict).

**Verified quotes.** The flag, `:56-59`:

```rust
        /// Stop after this many solutions (0 = exhaustive).
        #[arg(long, default_value_t = 0)]
        cap: usize,
```

The prune inside the backtracking search, `:626-628`:

```rust
        if cap > 0 && *found >= cap as u64 {
            return;
        }
```

The verdict built from the possibly-truncated count, `:572-579`:

```rust
        verdict: if count == 0 {
            format!(
                "eliminated: no orbit matrix for an order-{} collineation",
                n + 1
            )
        } else {
            format!("{count} normalized orbit matrices survive")
        },
```

`OrbitCertificate` at `:405-421` has fields `schema`, `n`, `p`, `dimension`, `row_sum`,
`row_square_sum`, `pairwise_dot`, `column_sum`, `row_types`, `candidate_rows`, `nodes`, `solutions`,
`type_profiles`, `examples`, `verdict` — no `cap`.

**Mechanism.** A capped run writes `solutions: N` and the sentence "N normalized orbit matrices
survive" with nothing marking N as a stopping point rather than a total; `type_profiles` and
`examples` are partial for the same reason.

**Concrete trigger**:
`cargo run --release --bin c1018_plane12 -- --out /tmp/orbit.json orbit13 --n 12 --cap 10`

**Impact.** The cap cannot manufacture the "eliminated" verdict, since it only fires after
solutions have been found, so no negative result can be forged this way — that bounds it at SEV2.
The default is exhaustive, so reaching the bad state needs an explicit flag. No capped
`orbit13` certificate is committed under `evidence/`.

**Described fix (not applied).** Add `cap` to `OrbitCertificate` and make the verdict read
"at least N …" whenever the cap was reached.

## SEV2 — `semantic_rank_census` emits `workspace_payload_reduction` computed from the wrong operands

**Location**: `/home/tavis/src/othello/ergodis-private/src/bin/semantic_rank_census.rs:204-207`.
Definition of the quantity at `/home/tavis/src/othello/ergodis-private/src/semantic_rank.rs:216-222`.

**Verified quote**, `semantic_rank_census.rs:204-207`:

```rust
        raw_workspace_payload_bytes,
        core_workspace_payload_bytes,
        workspace_payload_reduction: (system.row_count() * system.columns()) as f64
            / raw_workspace_payload_bytes as f64,
```

and the meaning of the denominator, `semantic_rank.rs:216-222`:

```rust
    /// Heap payload reserved by the reusable rank state, excluding allocators' metadata.
    #[must_use]
    pub fn payload_bytes(&self) -> usize {
        self.matrix.len()
            + self.basis.len()
            + self.scratch.len()
            + self.pivots.len() * std::mem::size_of::<usize>()
    }
```

**Mechanism.** `core_workspace_payload_bytes` is serialized into the envelope but never enters the
ratio. The number published under the name `workspace_payload_reduction` is raw matrix cells divided
by the raw workspace's own total heap allocation — a bytes-per-cell packing figure for one
workspace, not a raw-versus-core comparison. The two sibling ratios in the same struct literal both
follow raw-over-core: `equation_compression_ratio` at `:187` and `rank_replay_speedup` at `:203`.

**Concrete trigger**: every run, e.g.
`cargo run --release --bin semantic_rank_census -- --output /tmp/rank.json`.

**Impact.** Any `ergodis.semantic-rank-census.v1` envelope carries the wrong number under that key.
A fixed-string search across `ergodis-private`, `notes` and `papers` found the key only in this
source file, so nothing downstream consumes it yet, which is what holds it at SEV2. Stated
uncertainty: I am confident the operand is wrong, because the field name says "reduction" and the
expression is not a reduction of anything; I am inferring rather than certain that the intended
expression is `raw_workspace_payload_bytes as f64 / core_workspace_payload_bytes as f64`.

## SEV2 — the C1029 replay script's byte-identity step cannot fail the script

**Location**: `/home/tavis/src/othello/ergodis-private/python/c1029_replay.sh:10`, `:41-46`.

**Verified quote**, `:41-46`:

```sh
echo "--- byte-identity against the committed evidence ---"
diff <(sed 's/witness_file .*/witness_file X/' "${WORK}/c1029-cert-replay.txt") \
     <(sed 's/witness_file .*/witness_file X/' "${EV}/c1029-cert-n1e8.txt") \
  && echo "certificate identical"
diff "${WORK}/c1029-witnesses-replay.txt" "${EV}/c1029-witnesses-n1e8.txt" \
  && echo "witness file identical"
```

with `set -euo pipefail` at `:10`.

**Mechanism.** Under `set -e`, a command that is not the last in an `&&` list is exempt from
errexit, and bash does not exit on the list as a whole either. Both comparisons are therefore
advisory. The script's own header at `:6-9` states that it "regenerates the certificate, compares it
byte-for-byte against the committed evidence, runs the independent checker, and runs the
deliberate-corruption suite" — the second of those four cannot fail it.

**Concrete trigger**, reproduced in this session with the same construction including the process
substitution:

```
$ cat t.sh
set -euo pipefail
echo "--- byte-identity ---"
diff <(sed 's/foo .*/foo X/' x) <(sed 's/foo .*/foo X/' y) && echo "certificate identical"
diff x y && echo "witness file identical"
echo "REACHED END"
$ bash t.sh; echo "EXIT=$?"
--- byte-identity ---
1c1
< a
---
> b
1c1
< a
---
> b
REACHED END
EXIT=0
```

**Impact.** `evidence/c1029-cert-n1e8.txt` and `evidence/c1029-witnesses-n1e8.txt` are the committed
artifacts for the claim that every integer `n` with `2 <= n <= 10^8` admits
`4/n = 1/x + 1/y + 1/z`. Reproducibility of those exact bytes is the property this step asserts, and
its failure leaves exit status 0 — only the absence of the "certificate identical" line signals it.
The substantive check that follows, `c1029_check.py` on the committed certificate, is not in an
`&&` list and does abort the script, so a corruption the checker catches still fails the run. What
escapes is generator drift and any corruption of the committed bytes that remains internally
consistent.

The failure mode is reachable by ordinary operator error, because the generator silently ignores
unknown flags. `src/bin/c1029_parametric_cert.rs:646-653`:

```rust
fn arg_val(args: &[String], key: &str, default: &str) -> String {
    for w in args.windows(2) {
        if w[0] == key {
            return w[1].clone();
        }
    }
    default.to_string()
}
```

A typo in any of the six flags the replay passes at `:38-39`, or the `--flag=value` form, silently
substitutes the default — `--ladder-top` defaults to `0` against the replay's `3000` (`:663`) —
producing a different certificate, whereupon the non-fatal diff reports the difference and the
script still exits 0. Its sibling `src/bin/c1028_chain_ring.rs:1043` does the opposite,
`other => anyhow::bail!("unknown argument {other}")`.

**Described fix (not applied).** Replace `diff A B && echo "…"` with
`diff A B || { echo "…"; exit 1; }`, or wrap both in an explicit `if`. Separately, have
`c1029_parametric_cert` reject unknown arguments the way `c1028_chain_ring` does.

## Test-coverage gaps

Properties the suite names but does not check. None met the SEV bar on its own; each names a
specific defect it would not catch.

- **Three of the four search allocation gates assert an unfalsifiable bound.**
  `tests/proof_synthesis_allocations.rs:251`, `:278` and `:304` each end
  `assert!(outcome.iterations <= 10_000); assert_eq!(allocations, 0);` while the sibling at `:223`
  uses `assert_eq!(outcome.iterations, 10_000)`. `outcome.iterations` is `completed`, bounded by
  `while completed < config.iterations` at `src/g53_search.rs:2525` and returned as
  `iterations: completed` at `:2536`, `:2577` and `:2831`, so the assertion holds for every value
  from 0 upward. The property left unpinned is that the measured closure ran the mutation kernel at
  all: a regression making `run` return early — for instance at the `stop_at_quotient_shell` exit,
  `src/g53_search.rs:2529-2556` — leaves `allocations == 0` trivially true and all three tests green
  while they claim the shell miner allocates nothing. I could not substantiate that the current
  configs exit early (`QUOTIENT_SHIFTS` is 10 at `:30` and the tests set
  `initial_quotient_shifts: 1`, so the shell is not complete at iteration zero), which is why this
  is a gap and not a finding. Distinct from the round-1 allocator-copy finding, which is about which
  allocator is measured rather than whether the kernel ran.
- **`hall_certify` never tests the saturated branch.** `src/bin/hall_certify.rs:94-110` pins the
  deficient set and neighbourhood only;
  `Certificate::Saturated { matching: workspace.matching(input.left_count).to_vec() }` at `:59-61`
  is never constructed in a test, so a `matching()` returning the right-side rather than the
  left-side array would not be caught here. It would be caught downstream by
  `verify_hall_certificate.py`.
- **`check_c1028_chain_ring.py` never opens the artifact it is cited as replaying.** It recomputes
  everything from scratch, but its `PUBLISHED` dict at `:299-304` contains only `m_2`, `m_3` and the
  two Gray images. `maximum_2_arcs` and `maximum_3_arcs` are computed at `:330-331` and printed but
  compared against nothing, and `evidence/c1028-chain-ring-instrument-test.json` is never read.
  `notes/2026-08-31-c1028-chain-ring-instrument-test.md:449-456` states that the script "agrees with
  the driver … on `m_2 = 7` for `Z4` with 256 maximum arcs and `m_2 = 6` for `S2` with 2016, on
  `m_3 = 10` with 34272 maximum arcs for both rings" — that agreement was established by a person
  reading two outputs, not by the script, whose exit status is 0 for any arc counts.
- **`check_hadamard_reduction_scout.py` is vacuous on empty arrays.** The loops at `:433`, `:448`
  and `:451` iterate `actual["rational"]`, `actual["translations"]` and `actual["unit_dilations"]`
  with no length or non-emptiness check, so an emitter producing empty lists passes those three
  layers silently; the `generator_133` and `generator_91_*` blocks that follow would still fail by
  `KeyError`. Additionally `:433-438` skips verification entirely for any entry whose `error` field
  the prover set. Weak trigger: the checker invokes the binary itself with no arguments
  (`subprocess.run([args.binary], …)` at `:431`), so reaching an empty array needs a source change,
  not a flag.
- **`g41_pair_workspace_allocations.rs:65`** asserts `checksum == 0` on a value the test's own loop
  folds (`checksum ^= state` over `0..100_000` in `src/g41_defect_scout.rs:215`), which is 0
  regardless of what `PairWorkspace::insert` does. The allocation property itself is genuinely
  exercised; the checksum constrains nothing.
- **`semantic_core.py` does not check that the provenance groups partition the CNF.** `used` at
  `:92` counts core indices in `[clause_begin, clause_end)` per group; nothing verifies the ranges
  are disjoint or cover `0..len(original)`, so a gap in the provenance silently drops core clauses
  from every per-kind total. The CNF-to-provenance binding is present at `:77` and
  `c880_alignment_provenance.py:230-235` does bind the ledger totals to the DIMACS header, so only a
  compensating pair of per-group errors survives.

## Below threshold

- `check_c997_parity_ab.py:55-56` raises "witness replay mismatch" on `solve["witness"]["weight"] != 12`, a field read from the JSON — no replay happens in the checker, though `run_c997_gurobi.py:266-297` does a genuine GF(2) replay when writing that field.
- `certiis_core_audit.py` judges every residual instance by re-running `certiis` itself (`:26-36`), and `without()` at `:39-45` prunes `tasks` and `eligible` but not `couplings`, so a coupled instance's residual references dropped task ids.
- `c1018_prs_deephole.rs:656` initializes `crosscheck_ok = true`, so a run with no crosschecks emits `"ergodis_rank_agree":true` alongside `"ergodis_rank_crosschecks":0` (`:795-796`), which discloses it; separately `--max-reps` (`:60`, applied at `:771`) does not reach the stratum sweep, whose `exceptional_examples` list is hardcoded to `.take(256)` at `:598` against a disclosed `exceptional.len()`.
- `c1018_prs_census.rs`: `rank_mode` is recorded only in the full-census JSON header (`:1375`, filled from the match at `:1389`) and is absent from the `--fix-sweep` (`:1185-1187`) and `--stratum-mod` (`:857-862`) outputs; all three modes are exact enumerations differing only in cost.
- `g53_search.rs:229-238` publishes only `threads` and `iterations_per_thread` in its `SearchRecord`, omitting `seed` and about fifteen tuning flags; the record self-labels "heuristic-search; negative output has no coverage authority" and positives ship a self-verifying `witness_minus_sets`. Same for `g53_q4_repair.rs`, `g53_q4_two_block.rs` and `g53_q4_homometric.rs`, which take `--seed <hex quotient shell>` as their only input and do not echo it.
- `c1029_parametric_cert.rs:849` and `:814` overwrite the certificate and witness files unconditionally (`fs::write`), and `q25_pair_repair.rs:43` uses truncating `File::create` for `--certificate` while `--stabilizer-log` at `:112` uses `create_new(true)`; `hall_certify.rs:79-83` and `projective_grid_scout.rs` use `create_new(true)` correctly.
- `notes/2026-08-30-c985-c80-projective-hall-deficit.sha256` names `papers/complete-repair-ports/ergodis/scripts/c80_projective_hall_{scout,replay}.py`, which exist at neither path (the live scripts are `ergodis-private/scripts/projective_hall_{scout,replay}.py`); the JSON row itself verifies.
- `c1028_chain_ring.rs:1066-1070` skips orbit classification above 4,000,000 maximum arcs and emits zero orbits with an empty spectrum, flagged by `core_orbit_certificate_verified: false` at `:1078`; `c1018_transversal_css.rs:856-870` falls back to `min_x = 0` for `code.a.len() > 20` while the printed label still says "(exact, min nonzero weight of A)", unreachable with the shipped catalogue.
- `hall_certify.rs` writes no hash or copy of the input graph into the certificate, so the pair is bound only by filename convention.
- `alignment_controlled.rs:53-57` applies the `--symmetry` point-stabilizer reduction in `--baseline` mode too, but reports the group order only on the non-baseline branch (`:82`); the baseline JSON records no parameters at all.
- `evidence/SHA256SUMS` covers thirteen files; the seven q23 and four q11 C80 ancestral-secant artifacts are outside it — round-1 finding 11 territory.

## Not found / checked clean

**Two leads dropped after re-reading refuted them.** Recorded so the ground is not re-walked.
First, `scripts/projective_hall_replay.py`'s docstring claim "Code-disjoint replay" looked false
because the script imports the prover's own module — but the scout builds `first_issue` with
`DirectSmallBoundaryGame` (`scripts/projective_hall_scout.py:205`) while the replay recomputes with
`SmallBoundaryGame` (`scripts/projective_hall_replay.py:36`), and these are separate classes at
`rust/scripts/c80_causal_nonpacking.py:200` and `:323`. The replay also binds the source by sha256
at `:30-32` and pins the expected neighbourhood structure to a literal at `:102`. Second, the C80
q11 and q23 ancestral-secant Hall artifacts are single- or two-left-vertex graphs whose Hall
condition is trivially satisfied, but every manifest states the boundary explicitly ("diagnostic
projective motif; charge-transport soundness unproved"), so nothing overclaims.

**Checkers that genuinely recompute from the primary input** rather than trusting the artifact's
self-report, confirming and extending the round-1 note on `check_hadamard_quotient_pilot.py`:

- **`verify_hall_certificate.py`** — sound. `neighborhoods` at `:11-25` validates the CSR structure
  before use; the saturated branch checks injectivity and edge membership against the rebuilt
  adjacency (`:35-40`); the deficient branch recomputes the exact neighbourhood union and requires
  `|N(S)| < |S|` (`:41-49`); a bad certificate raises and exits nonzero.
  `test_verify_hall_certificate.py`'s rejection test reaches the intended "matching uses a missing
  edge" branch rather than being rejected earlier for an unrelated reason.
- **`c1029_check.py`** — sound, and the strongest artifact in the set. It verifies the identity
  `n(BC+AC+AB) - 4ABC` symbolically in `Z[t]` rather than by sampling (`:132-138`), proves positivity
  from non-negative coefficients plus one evaluation at `tmin` (`:140-147`), enforces conservatively
  that the least `n >= 2` in each class is within reach of `tmin` (`:148-151`), recomputes the
  covering of `Z/cover_modulus` (`:154-169`), rebuilds `(x, y, z)` from each witness and checks
  `4xyz = p(yz + xz + xy)` in exact integers (`:187-209`), and re-sieves the residual primes itself
  (`:294-320`). Its bare `except Exception` at `:327` converts crashes into rejections, the safe
  direction, and the exit code tracks the verdict (`:339-342`). `c1029_break.py` supplies ten
  mutants covering each layer including the witness-hash binding. The defect in this bundle is in
  the shell wrapper, not the checker.
- **`check_c1028_chain_ring.py`** — the computation is sound and independent in construction as well
  as implementation: it builds the lines of `PHG(2,R)` as spans and separately as kernels and
  requires the two sets to agree (`:97-108`, `:316`), and `divides_x7_minus_1`, `octacode` and
  `gray_parameters` are all correct on re-derivation. Its gap is coverage, listed above.
- **`check_hadamard_reduction_scout.py`** — recomputes every census from the carrier structure and
  compares against the binary's fresh output; the cyclotomic, translation, unit-dilation and
  quadratic layers are independent reimplementations.
- **`check_c997_native.py`** — independently rebuilds the gross code from source and replays the
  weight-12 witness in GF(2) at `:70-80`. The `uint8` matmul at `:79` is parity-correct despite
  wraparound, since 256 is even. It does not independently establish the distance lower bound, which
  is inherent — that is the expensive half — and it does not claim to.
- **`c880_alignment_provenance.py`** — refuses to emit on layout drift by comparing the
  reconstructed ledger totals against the DIMACS header at `:230-235`.

**Binaries and tests judged clean on the questions asked:**

- `src/bin/hall_certify.rs` — `deny_unknown_fields` on the input (`:19`), schema checked (`:47-50`),
  output opened with `create_new(true)` (`:79-83`). The only gap is the untested saturated branch.
- `src/bin/c1028_chain_ring.rs:1034-1045` — rejects unknown arguments outright, the correct
  counterexample to the `c1029_parametric_cert` shape.
- `src/bin/c985_binary_projective_bench.rs:178` — unlike its extension-field sibling, the generators
  at `:17-28` are nontrivial (upper bidiagonal, a `1..dimension` diagonal, the reversal permutation),
  so `field.mul` is exercised on genuine operand pairs and the table-versus-binary comparison has
  content.
- `src/bin/lp333_orbit_lock.rs:141`, `:172` — pin all six spectra and cross-check against a
  committed independent certificate.
- `src/bin/certiis.rs` tests other than the tamper one (`:2087`, `:2117`, `:2145`, `:2196`, `:2205`)
  pin exact task and resource sets or exact verdict shapes.
- `tests/hadamard_2092_allocations.rs` — outputs pinned to constants, compile step correctly outside
  the tracked region.
- `tests/proof_synthesis_allocations.rs:79-203` (the transcript tests) and `:206` —
  `used == workspace.len()` pins transcript length, and the goal-reached property is enforced inside
  `derive_horn_closure_into` / `replay_horn_derivation` under `.unwrap()`.
- No clap field in any binary is parsed and never read; the dead-flag class comes up empty across
  all fifty-three `Parser` structs.
- `python/run_c997_gurobi.py:113-118` (`add_mod2` slack width) and `:266-297` (`replay_witness`) are
  both correct; `bits = ceil(log2(n))` suffices because `2^bits - 1 >= n - 1 >= floor(n/2)`.
- `evidence/SHA256SUMS` — all thirteen rows recompute correctly.
- `python/test_semantic_rank_core.py`, `test_semantic_subspace_core.py`, `test_semantic_core.py`,
  `test_c896_q9_semantic_rank.py`, `test_c80_hall_motif_probe.py` and
  `test_c80_hall_motif_q23_probe.py` use small hand-checkable fixtures with exact pinned values; I
  re-derived the `semantic_rank_core` expectations by hand and they are right.
