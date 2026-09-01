# C1030 — ergodis-private certificate, evidence, and I/O audit

**Task**: C1030 · **Lane**: `complete-ports` · **Scope**: ergodis-private certificate/evidence/CLI plane

## Verdict

The certificate plane is better built than most research code in this repository: `hall_certify`
uses `deny_unknown_fields` and `create_new(true)`, `verify_hall_certificate.py` is a genuinely
independent replay, `c1029_check.py` re-derives its polynomial identities symbolically and hashes
the witness file it consumes, and `certiis`'s Hall verifier recomputes demand, capacity,
neighbourhood, and irreducibility from the eligibility relation alone. That good work makes the
remaining gaps sharper rather than softer: the two largest certificate tools each contain one path
where a wrong result is accepted and printed as verified, and both paths are the *default* way an
operator would invoke them.

The five findings below are ordered by severity. Two are SEV1 (a wrong result passes verification),
two are SEV2, one is SEV3.

**Read deeply**: `src/proof_synthesis.rs`, `src/hall_core.rs`, `src/reduction_proof.rs` (verify and
replay paths), `src/bin/hall_certify.rs`, `src/bin/certiis.rs`, `src/bin/certdist.rs` (certificate,
bracket, and verify sections), `python/verify_hall_certificate.py`, `python/c1029_check.py`,
`Cargo.toml`, `notes/research-reproducibility-conventions.md`,
`notes/2026-08-30-c80-ancestral-secant-hall-probe.md`, `ergodis-private/evidence/SHA256SUMS`.

**Sampled only**: the other ~92 files under `src/bin/` (filename inventory, clap-argument grep, and
`BufWriter`/`flush` grep across all of them), `src/quotient_paf_proof.rs`,
`src/g133_exact_q2_proof.rs`, `src/g53_reduction_proof.rs`, `src/g53_defect_profile_proof.rs`,
`src/g41_quotient_filter_proof.rs`, `src/alignment_control.rs`, `src/semantic_plan.rs`, the
`tests/*.rs` allocation harnesses, and the remaining `python/` checkers.

---

## SEV1 — `certdist verify` reports "certificate verified" with every witness unchecked

**Location**: `ergodis-private/src/bin/certdist.rs:1470-1474`, `:2013-2032`, `:2100-2140`

```rust
    Verify {
        #[arg(long)]
        certificate: PathBuf,
        #[arg(long)]
        input: Option<PathBuf>,
```

```rust
    let problem = match &input {
        Some(path) => { /* ... re-derives CodeIdentity ... */ Some(problem) }
        None => {
            println!("[--] no --input given; code identity and witnesses are NOT re-derived");
            None
        }
    };
```

```rust
    // 3. Every witness is re-verified from the input over GF(2).
    if let Some(problem) = &problem {
```

**Mechanism**: `--input` is optional. When it is omitted, section 1 (code identity, rank, kernel
dimension, parity gate, and `input_sha256` re-derivation) and the whole of section 3 (re-verifying
every enumeration witness and every upper-bound witness as an actual logical operator over GF(2))
are skipped without pushing anything into `failures`. Sections 2 and 4 only check the certificate's
internal bookkeeping. At `:2260` the run then prints `VERDICT: certificate verified` and exits 0.
Nothing in the output distinguishes a fully verified certificate from one where only arithmetic
consistency of self-reported counters was checked — the `[--]` line scrolls past among a dozen
`[ok]` lines and the final verdict string is identical.

Section 4 compounds this: the "recomputed" bracket at `:2144` is produced by calling
`build_bracket(&parsed.code, &parsed.levels, &parsed.upper_bounds)` — the *same function*
`assemble_certificate` used to produce the bracket in the first place. Any error in
`build_bracket`'s reasoning passes both sides identically. In particular `build_bracket:1170-1178`
promotes a level to an exact distance whenever `minimum_witness_weight` is `Some(w)` on a
complete shard cover, without ever checking `w <= level.searched_maximum_weight`; the provenance
string it then writes ("complete shard cover through weight {searched} found its lightest logical
operator at weight {weight}, so every lighter connected anchored support was ruled out") asserts
exhaustion over a range the search never covered when `weight > searched`.

Third layer, same section: the toolchain guard at `:2176` is only a `println!`, not a
`failures.push`, and it is inside `if let (Some(recorded), Some(current))`. `Certificate.toolchain`
is `#[serde(default)]` over a `Toolchain` whose fields are `Option<String>` (`:1059-1060`,
`:820-830`), so a certificate with no `toolchain` block skips the check silently — the doc comment
on that very struct says a job mixed across enumerator revisions "would silently mix two searches".

**Concrete trigger**: `certdist verify --certificate jobs/<code>/certificate.json` (no `--input`).
Hand-edit any witness vector, any `minimum_witness_weight`, or the `code` block in that JSON first;
the run still prints `VERDICT: certificate verified` and exits 0. Reproducible with zero setup on
any of the twelve committed certificates under `ergodis-private/evidence/certdist/certificates/`.

**Impact**: undermines the distance brackets in `notes/2026-08-31-certified-distance-prototype.md`
and the twelve `evidence/certdist/certificates/*.json` bundles. The documented replay commands in
that note (lines 714-718) do pass `--input`, so the recorded results are not themselves suspect;
the exposure is that the check that makes those certificates meaningful is opt-in and its absence
is not reflected in the verdict.

**Described fix** (not applied): make `--input` required for `Verify`, or keep it optional but
change the final verdict string and exit code when `problem.is_none()` (e.g. `VERDICT: structural
checks only — witnesses NOT verified`, exit 2). Separately, `build_bracket`'s exact branch should
reject `weight > level.searched_maximum_weight`, and the verify path should assert that bracket
predicate directly against the records rather than by calling the prover's constructor. Promote the
`[!!]` toolchain mismatch and the absent-`native_sha256` case to `failures`.

---

## SEV1 — `certiis` instance fields default to 1 with no `deny_unknown_fields`, and the verifier shares the deserializer

**Location**: `ergodis-private/src/bin/certiis.rs:33-54`, `:100-111`, `:856-868`

```rust
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Task {
    pub id: String,
    #[serde(default = "one")]
    pub demand: u32,
    #[serde(default, skip_serializing_if = "is_false")]
    pub distinct: bool,
}
```

```rust
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Resource {
    pub id: String,
    #[serde(default = "one")]
    pub capacity: u32,
}
```

```rust
    let actual = digest(raw);
    ensure!(
        report.instance_digest == actual,
        "certificate was produced for a different instance (digest {} vs {actual})",
```

**Mechanism**: neither `Task`, `Resource`, `Coupling`, nor `Instance` carries
`#[serde(deny_unknown_fields)]` — contrast `GraphInput` in `src/bin/hall_certify.rs:18-19`, which
does. A misspelled or renamed key (`"demands": 3`, `"cap": 40`, `"couplings"` written as
`"coupling"`) is silently discarded, and `demand`/`capacity` then fall back to the `default = "one"`
value of 1. The instance that `certiis` solves is not the instance the file describes.

The verifier does not catch this, because `Command::Verify` at `:1801-1807` re-reads the same file
through the same `Instance` deserializer and then does its independent recomputation against those
same defaulted values. `verify` reaches for `instance.tasks[t].demand` and
`instance.resources[r].capacity` directly (`:1011-1020`, `:936-940`, `:963-971`), so prover and
verifier agree on the wrong numbers. The `instance_digest` guard cannot help: it hashes the raw
bytes, and the raw bytes *are* the file with the typo, so the digest matches exactly.

A dropped `Coupling` is worse than a dropped demand, because it changes the regime. If the
`couplings` array fails to deserialize into the field (misspelled container key), `classify` sees no
couplings, the instance is classified `bipartite_matching` or `capacitated_matching` instead of
`degree_constrained_completion` or `quadratically_coupled`, and `certiis` issues a Hall certificate
for a problem where the module's own documentation (`:194-207`, `:227-240`) says Hall is necessary
but not sufficient — i.e. a decorative certificate presented as load-bearing. `verify` reclassifies
using `classify(instance)` on the same mis-deserialized struct and agrees.

**Concrete trigger**: take any generated instance, rename `"capacity"` to `"capacityy"` on one
resource that carries capacity 40. `certiis solve` reads that resource as capacity 1, finds a Hall
violation, and emits an infeasibility certificate; `certiis verify` prints every `ok:` line and
`VERIFIED`. The instance is in fact feasible.

**Impact**: undermines every `certiis` certificate cited by
`notes/2026-08-31-infeasibility-certificate-prototype.md` and the certiis rows in
`notes/2026-08-31-ergodis-correctness-assurance-adr.md`. Since instances are currently produced by
`certiis generate`/`suite`, which serialize the same structs, no committed instance is presently
affected — this is a live trap for the first hand-written or externally generated instance, which is
exactly the intended direction of the tool.

**Described fix** (not applied): add `#[serde(deny_unknown_fields)]` to `Task`, `Resource`,
`Coupling`, `GroundTruth`, and `Instance`. Drop `default = "one"` on `demand` and `capacity` and
make both required, or keep the default and have `verify` re-parse the raw bytes as
`serde_json::Value` and fail when a task/resource object omits the key that the report's numbers
depend on.

---

## SEV2 — `certiis` writes wall-clock timings into the certificate and overwrites evidence in place

**Location**: `ergodis-private/src/bin/certiis.rs:495-511`, `:834-848`, `:1699-1706`

```rust
pub struct Report {
    ...
    pub matching_micros: u128,
    pub minimization_micros: u128,
    pub total_micros: u128,
}
```

```rust
fn write_json<T: Serialize>(path: &Path, value: &T) -> anyhow::Result<()> {
    if let Some(parent) = path.parent() {
        fs::create_dir_all(parent).ok();
    }
    let mut bytes = serde_json::to_vec_pretty(value)?;
    bytes.push(b'\n');
    fs::write(path, bytes).with_context(|| format!("writing {}", path.display()))
}
```

**Mechanism**: three `Instant::elapsed().as_micros()` values are serialized into the certificate
body. `notes/research-reproducibility-conventions.md` requires that "outputs must be canonical and
stable: sort unordered objects, fix serialization, avoid timestamps and host-specific paths" and
that every load-bearing output carry a SHA-256. A `certiis` certificate cannot satisfy both: its
bytes differ on every run, so any recorded hash is a hash of one particular execution's scheduling
noise and a `--check`-style regeneration can never match. The conventions file explicitly prefers a
`--check` mode that "regenerates in a temporary location, verifies hashes/content against the
tracked artifact"; that mode is unimplementable against this schema as written.

`write_json` compounds it: `fs::write` truncates and overwrites unconditionally, and
`fs::create_dir_all(parent).ok()` swallows the directory error so a later failure surfaces as a
confusing write error. `certiis solve --input i.json --out evidence/foo.json` silently replaces a
tracked certificate. `hall_certify` (`src/bin/hall_certify.rs:79-83`) gets this right with
`File::options().write(true).create_new(true)`, so the safer convention already exists in the same
directory.

**Concrete trigger**: run `certiis solve --input <any> --out /tmp/c.json` twice and diff — the
`*_micros` fields differ. Then run it once more against a path that already holds a committed
certificate; the old bytes are gone with no warning and no non-zero exit.

**Impact**: blocks `certiis` certificates from ever entering `evidence/SHA256SUMS` or a paper
evidence registry under the repository's own reproducibility gate. Directly relevant now, because
`notes/2026-08-31-ergodis-correctness-assurance-adr.md` and
`notes/2026-08-31-ergodis-target-portfolio.md` both route certiis toward paper-facing use.

**Described fix** (not applied): move the three `*_micros` fields out of `Report` into either stdout
or a sibling `*.timing.json` that is not part of the certificate; keep the certificate byte-stable.
Switch `write_json` to `create_new(true)` with an explicit `--force` opt-in, and add a `--check`
mode that regenerates to a temporary path and compares.

---

## SEV2 — `solve_sorted_square_sum` sums squares in unchecked `u32`, and its sibling does not

**Location**: `ergodis-private/src/proof_synthesis.rs:487-493`, `:516-522`, contrasted with
`:571-578`

```rust
        let sum = candidate
            .iter()
            .map(|&value| u32::from(value).pow(2))
            .sum::<u32>();
        if sum == target {
            solutions.push(candidate.clone().into_boxed_slice());
        }
```

```rust
fn integer_square_root(value: u32) -> u16 {
    let mut root = 0_u32;
    while (root + 1).saturating_mul(root + 1) <= value {
        root += 1;
    }
    root as u16
}
```

The sibling endpoint solver twenty lines later does the same accumulation correctly:

```rust
                .try_fold(0_u32, |sum, (&weight, value)| {
                    sum.checked_add(u32::from(weight) * u32::from(value))
                        .ok_or(SynthesisError::ArithmeticOverflow)
                })?;
```

**Mechanism**: candidate entries range up to `integer_square_root(target)`, so the true sum of
squares reaches roughly `variables * target`. With up to `MAX_SQUARE_VARIABLES = 8` variables, any
`target > 2^32 / 8 ≈ 5.4e8` admits candidates whose true sum exceeds `u32::MAX`. In a release build
(`overflow-checks` off, which is how every bin in this crate is run) `.pow(2)` and `sum::<u32>()`
wrap silently; a candidate whose true sum is congruent to `target` modulo `2^32` is pushed into
`solutions` as if it satisfied the equation. In a debug build the same input panics. The function's
own contract — "Enumerate nondecreasing nonnegative solutions of a small square-sum endpoint" — is
violated in the direction that produces a false positive, not a false negative.

`integer_square_root` has a second, narrower defect: at `value == u32::MAX` the `saturating_mul`
pins at `u32::MAX`, the `<= value` test stays true forever, and the loop runs until `root` itself
overflows (panic in debug, non-terminating in release).

**Concrete trigger for the overflow**: `solve_sorted_square_sum(8, 600_000_000, budget)` in a
release build enumerates candidates up to 24494 each; sums above `2^32` wrap. Constructing an
*exact* false positive requires solving a congruence, so I did not build one — treat the trigger as
"reachable class of input" rather than "here is the witness", which is why this is SEV2 and not
SEV1.

**Impact**: this is the endpoint enumerator behind `reduction_proof.rs`. Both
`synthesize_generator_91_order_29_proof:342` and its verifier `replay_q29_structural_arithmetic:511`
call `generic_three_square_solutions`, which bottoms out here — so prover and verifier share the
defect and a shared wrong answer would pass `verify_structural_proof`. The currently registered
adapters pin `target = 18`, far below the overflow threshold, so no committed proof artifact is
affected today. The exposure is the next adapter registered with a larger endpoint.

**Described fix** (not applied): mirror the sibling — replace the `.map(...).sum::<u32>()` with a
`try_fold` using `checked_mul`/`checked_add` returning `SynthesisError::ArithmeticOverflow`, and
reject `target == u32::MAX` (or rewrite `integer_square_root` with a `u64` accumulator) in
`solve_sorted_square_sum`'s entry validation alongside the existing variable/budget checks.

---

## SEV3 — the q23 Hall evidence has no recorded hashes, no replay command, and no graph-to-certificate binding

**Location**: `ergodis-private/evidence/SHA256SUMS` (13 entries, 43 evidence files),
`notes/2026-08-30-c80-ancestral-secant-hall-probe.md:56-78`,
`ergodis-private/python/verify_hall_certificate.py:53-61`

```python
    parser.add_argument("--graph", type=Path, required=True)
    parser.add_argument("--certificate", type=Path, required=True)
    arguments = parser.parse_args()
    graph = json.loads(arguments.graph.read_text(encoding="utf-8"))
    certificate = json.loads(arguments.certificate.read_text(encoding="utf-8"))
    verify(graph, certificate)
    print("VERIFIED")
```

**Mechanism**: three problems stack.

First, coverage. The note records SHA-256 values for exactly three files — the q11 graph, manifest,
and certificate (I recomputed all three and they match the committed bytes). The seven q23 files
(`c80-q23-ancestral-secant-manifest.json` and
`c80-q23-ancestral-secant-type_{i,ii,iii}-{graph,certificate}.json`) carry no hash anywhere in the
repository, and `evidence/SHA256SUMS` does not list them either — it covers 13 of the 43 files in
that directory and none of the Hall graph/certificate pairs. The note's table rows at `:27-29`
("q23 type I / II / III … saturated") are paper-facing claims resting on unhashed bytes.

Second, replay. The note's replay block (`:64-70`) invokes the verifier on the q11 pair only. There
is no recorded command for the three q23 pairs, so the convention's "exact command to regenerate or
check the artifact" is unmet for them.

Third, binding. Neither `hall_certify` nor the certificate schema records a digest of the graph the
certificate was computed from, and the Python verifier accepts any `(graph, certificate)` pair on
the command line. A certificate proves a property of whatever graph file it is pointed at, so
swapping in a different graph or a stale graph is not detectable by the checker — only by the
operator typing the right two paths. The same verifier accepts a degenerate instance: a graph with
`left_count: 0`, `offsets: [0]`, `neighbors: []` and a certificate `{"outcome": "saturated",
"matching": []}` passes every check in `verify` (`:34-40`, all comparisons over empty sequences) and
prints `VERIFIED`.

**Concrete trigger**: edit any byte of
`ergodis-private/evidence/c80-q23-ancestral-secant-type_i-graph.json`; nothing in the repository
detects it, and re-running the verifier against the edited graph plus its unchanged certificate
either still passes or fails for an unrelated reason. For the binding gap: run the q11 certificate
against the q23 type-I graph — the verifier gives a Hall-graph or matching error rather than a
"these do not belong together" error, so the failure mode is legible but the *success* mode of a
subtly wrong pairing is not.

**Impact**: the q23 saturation rows in `notes/2026-08-30-c80-ancestral-secant-hall-probe.md` and the
downstream summary in `notes/2026-08-30-ergodis-certificate-to-theorem-portfolio.md`.

**Described fix** (not applied): add the seven q23 files (and the three q11 files) to
`evidence/SHA256SUMS`, and add the three q23 replay commands to the note beside the q11 one. Have
`hall_certify` write the SHA-256 of the graph bytes it read into a `graph_sha256` field of the
certificate, and have `verify_hall_certificate.py` recompute that digest from the `--graph` file and
refuse to proceed on a mismatch. Reject `left_count == 0` in `neighborhoods()`.

---

## Not found / checked clean

- **`ergodis-private/src/bin/hall_certify.rs`** — `#[serde(deny_unknown_fields)]` on the input, and
  `File::options().write(true).create_new(true)` on the output, so it refuses to overwrite prior
  evidence. This is the pattern the rest of the directory should follow. Its only nit is that
  `serde_json::to_writer_pretty(BufWriter::new(output), …)` never explicitly flushes; a drop-time
  flush error is discarded, so a full disk yields a truncated certificate with exit code 0. That
  fails loudly at the next `json.loads`, so I did not raise it as a finding.
- **`ergodis-private/src/hall_core.rs`** — the matching kernel itself. Kuhn augmentation, one
  attempt per left root, is correct; `validate` checks CSR shape and endpoint range; the epoch
  counter handles `u32` wraparound by clearing both `seen` arrays; the exhaustive 4x4 test at
  `:311-374` compares all 65,536 bipartite graphs against brute force and additionally checks that
  the extracted deficient set's exact neighbourhood is smaller than the set. The release-mode
  `debug_assert!` at `:84` is not load-bearing because `verify_hall_certificate.py:47` re-checks
  `len(claimed) >= len(left)` independently.
- **`ergodis-private/python/verify_hall_certificate.py`** — the mathematics is sound in both
  branches. The saturated branch checks length, injectivity, and edge membership; the deficient
  branch recomputes the exact union neighbourhood and rejects unless it is strictly smaller. It
  shares no code with the Rust prover. The gaps I raised are about binding and empty input, not
  about the checks it does perform.
- **`ergodis-private/python/c1029_check.py`** — checks the polynomial identity symbolically in
  `Z[t]` via sympy rather than by sampling, proves positivity from non-negative coefficients plus
  monotonicity rather than testing points, hashes the witness file against a declared
  `witness_sha256` before reading it, re-derives `(x, y, z)` from `(p, s, d)` and then verifies
  `4xyz == p(yz + xz + xy)` independently of that derivation, sieves primes itself, and states the
  one step it does not re-derive (the scaling lemma). Malformed input becomes a rejection rather
  than a crash (`:222-229`, `:327-328`), and `REASONS`-driven verdicts cannot reach "ACCEPTED" with
  an unfilled check. The `--expect` flag correctly makes an unexpected verdict exit non-zero.
- **`certiis`'s Hall verifier (`src/bin/certiis.rs:856-1115`)** — modulo the deserialization issue
  above, the recomputation is genuinely independent of `hall_core`: it rebuilds the eligibility set
  from `instance.eligible`, recomputes neighbourhood/demand/capacity with closures that read the
  `Instance` and never the prover's `Compiled`, re-derives every single-task removal test rather
  than trusting the recorded ones, and enforces pairwise disjointness of the certificates in both
  tasks and resources. The `selftest` subcommand cross-checks 4,000 random instances against
  exhaustive defect-Hall over all task subsets and then runs `verify` on each.
- **`ergodis-private/evidence/certdist/`** — this bundle is tracked properly: separate
  `SHA256SUMS.binaries`, `SHA256SUMS.certificates`, and `SHA256SUMS.scripts` manifests alongside the
  twelve certificates, and the committed certificates do carry `toolchain.native_sha256`. The
  documented replay commands in `notes/2026-08-31-certified-distance-prototype.md:696-718` do pass
  `--input`, so the recorded brackets were verified with witnesses re-derived.
- **`certdist`'s job I/O** — `write_atomic` (`:845-855`) writes to a `.tmp` sibling, `sync_all`s, and
  renames, so an interrupted run cannot leave a half-written shard record or certificate.
- **`certdist`'s clap surface** — the documented replay commands in the prototype note match the
  current `Job::Certify`/`Job::Verify` derive structs; no drifted flag found.
- **`src/proof_synthesis.rs` Horn layer** — `replay_horn_derivation` checks rule identity, premise
  mask, conclusion, the `reserved` padding byte, and premise satisfaction against the sealed
  registry, so a forged transcript is rejected; `validate_rule_registry` rejects duplicate rule
  identities and self-concluding rules. `IntegerLinearSystem::solve_unique_integer` is fraction-free
  with `checked_mul`/`checked_sub` throughout and an exact divisibility test, and it returns
  `Underdetermined` rather than a partial answer. The overflow finding above is confined to the
  square-sum endpoint.
- **Serde defaults across the crate** — only `certdist.rs` and `certiis.rs` use `#[serde(default)]`
  at all; every other module in scope requires its fields. `certdist`'s `incumbent_support`
  (`:157-158`) and `Toolchain` defaults are the only other instances, and the `Toolchain` one is
  covered in the SEV1 finding.
- **`BufWriter` flush discipline** — grepped every file under `src/`; only three bins
  (`q25_pair_repair`, `q16_quadratic`, `c80_hall_rematch`) call `flush()`, but no other bin
  constructs a `BufWriter` over a certificate output, so `hall_certify` is the only exposure and it
  fails loudly.

## Adjacent observation, outside this audit's scope

`Cargo.toml` explicitly wires 12 `[[bin]]` targets with hyphenated names (`hall-certify`,
`q25-pair-repair`, `g53-search`, …) while the other ~85 files in `src/bin/` are auto-discovered
under their underscored filenames (`certiis`, `certdist`, `c1029_parametric_cert`, …). Two naming
conventions in one directory means `cargo run --bin hall_certify` and `cargo run --bin certiis-`
both fail, and a replay command copied from the wrong note fails in a way that looks like a missing
binary. Not a correctness defect, so not counted among the five, but worth a note when the bin list
next gets touched.

`notes/2026-08-31-certified-distance-prototype.md` records that the `ergodis-private` library target
was uncompilable at the time of writing (three `missing field best_quotient_residuals` errors in
`src/g53_search.rs`) and that `certdist` was therefore built through a shim crate. That file belongs
to another lane; I did not attempt a build and raise it only so the state is visible.
