# C988 — R11 evidence registration in the electronic supplement (2026-08-28)

**Lane**: `reed-solomon`

Registering three redundancy-eleven (R11) companion evidence bundles in
`papers/high_weight_grs_cosets/supplement/evidence/`. These are supplement-only
companion records; the submission's main theorem claims nothing at R11, exactly
as for the existing Certificate R8/R9/R10/Lucas M9 companion bundles.

- `Certificate R11 binary quotients` — slug `r11-binary-quotients`
- `Certificate R11 GF(27) sweep` — slug `r11-gf27-switch-sweep`
- `Certificate R11 characteristic seven` — slug `r11-char7-pointed-orbits`

## 1. Shared Hankel convention across the three bundles

All three bundles verify the same criterion, stated independently in each
replay. For a redundancy-`r` syndrome `z` (a divided-power form of degree
`n = r - 1`) and an ascending locator coefficient list `g` of formal degree `d`,
the `r - d` consecutive-window contractions

```
sum_{k=0}^{d} z_{i+k} g_k = 0,   i = 0, ..., r-d-1
```

must vanish. At `d = r - 2` these are the two consecutive Hankel equations of
the pointed statement. The three source conventions were checked to be the same
system re-indexed:

| source | written form | relation |
|---|---|---|
| GF(16)/GF(32) replay `is_locator` | `sum_j z_j g_{j-level}`, `level = 0..n-d` | `j = i + k` |
| GF(27) `verify_witnesses.py` | `sum_{i=2}^{8} z_i g_{i-1} = sum_{i=2}^{8} z_i g_i = 0` | `level = 1, 0` |
| toolkit `locator_kernel` in `software/projective-reed-solomon/src/lib.rs` | rows `i` of `syndrome[i+j]`, `j = 0..=degree` | identical |

Element encoding `polynomial-basis-base-p-integer-v1`, read off the toolkit's
`Field::new`/`mul`/`eval`: an element is the base-`p` radix encoding of its
polynomial-basis coordinates with the least significant digit first; the
modulus list is ascending and monic. Locator coefficient lists are ascending
and are normalized projectively by scaling the *lowest* nonzero coefficient to
one (`normalize_projective` picks the first nonzero entry), so a stored locator
is a scalar multiple of the monic root polynomial rather than literally monic;
a root at infinity appears as a zero top coefficient, i.e. a degree drop.

## 2. Bundle 1 — `Certificate R11 binary quotients`

Directory `supplement/evidence/r11-binary-quotients/`, six files:

| public file | role | replay class |
|---|---|---|
| `2026-08-28-r11-gf16-pointed-quotient.py` | GF(16) generator | rederive |
| `2026-08-28-r11-gf16-pointed-quotient.json` | GF(16) certificate | compare |
| `2026-08-28-r11-gf16-pointed-quotient-replay.py` | independent GF(16) replay | reconstruct |
| `2026-08-28-r11-gf32-pointed-quotient.py` | GF(32) generator | rederive |
| `2026-08-28-r11-gf32-pointed-quotient.json` | GF(32) certificate | compare |
| `2026-08-28-r11-gf32-pointed-quotient-replay.py` | independent GF(32) replay | reconstruct |

What it records: 317 (GF(16)) and 1,129 (GF(32)) upper-Borel orbits of the R11
maximal Lucas carrier `P<e_3,...,e_7>` under the **degree-ten divided-power
upper-Borel action** (translation `e_j -> sum_{i>=j} binom(i,j) a^(i-j) e_i`,
scaling `e_j -> s^j e_j`), every orbit carrying a verified finite locator.
Generator and replay each run a fail-closed seeded 1,000-pair equivariance gate
(`splitmix64`, seed `0xC973_2026_0828`).

The 2026-08-27 versions of these artifacts used C531's degree-**nine** (R10)
`PGL_2` action truncated to the non-invariant slice `e_3..e_7`; they must not be
cited. The wrong group has the **same** orbit counts (317 and 1,129), so the
counts are not a valid check — the group must be named explicitly and validated
by equivariance. Both the schema docs and the bundled docstrings say so.

### 2.1 Path patches and the one deviation from the instructions

`--check` **does** need the toolkit binary: both generators call
`simultaneous-locator`/`classify`/`verify` through `subprocess` inside
`generate()` and hash the binary into `binary_sha256` in the certificate, so
`--check` reruns the whole generation. The release binary was already built and
its SHA-256 `30cbb0568fde95efaff29a7c362c72fd145896b4106012d8d0384dadf26e2607`
matches the value pinned in both certificates, so no rebuild was needed.

The instruction was to repoint the generators' `ROOT` constant from
`parents[2]` to `parents[3] / "software" / ...`. That works for the GF(32)
generator but **not** for the GF(16) one, for a reason the instruction could not
have anticipated: the GF(32) generator imports the GF(16) generator by sibling
path and records `base_source_sha256 = sha256(GF(16) generator source)` inside
the frozen GF(32) certificate. Patching the GF(16) generator changes that hash,
and `2026-08-28-r11-gf32-pointed-quotient.py --check` then fails with
`tracked output differs from deterministic regeneration`. Measured directly:
after patching, regeneration differed from the frozen JSON in exactly one key,

```
base_source_sha256  new 4d8b28c2cda49f...  old 81d2faa0679077fb...
```

Since hand-editing the certificate is forbidden and regenerating it would break
the byte-for-byte copy, the GF(16) generator is bundled **byte-identical** to
the development-tree source (SHA-256 `81d2faa0679077fb007353dce5803768d9ee2a5e4bdc9b1d2edbfff6fe85498f`)
and is invoked with explicit `--binary` and `--output` arguments instead. Every
other script in the three bundles has its path constants repointed as
instructed. This keeps all five certificates byte-identical to the authority
artifacts and keeps all three generator `--check` routes green.

Patched constants:

- `2026-08-28-r11-gf32-pointed-quotient.py`: `PAPER = parents[3]`, `DEFAULT_BINARY`,
  `BASE_PATH`, `DEFAULT_OUTPUT`;
- `2026-08-28-r11-gf16-pointed-quotient-replay.py`: `CERTIFICATE`;
- `2026-08-28-r11-gf32-pointed-quotient-replay.py`: `BASE_PATH`, `BASE.CERTIFICATE`.

The frozen schema identifiers inside the certificates
(`c973-r11-gf16-pointed-quotient-v2`, `c973-r11-gf32-pointed-quotient-v2`,
`c973-char7-pointed-orbits-v1`) are immutable certificate content and keep their
internal stem, which `CERTIFICATE-SCHEMA.md` already covers: "Internal dated
filenames remain immutable provenance, but are not mathematical identifiers."
No public *filename* carries a task identifier.

### 2.2 Measured from the bundle directory

```
2026-08-28-r11-gf16-pointed-quotient-replay.py            PASS,  1.1 s
   317 pointed orbits, 317 finite witnesses, degrees {8: 2, 9: 315}, 1000 equivariance pairs
2026-08-28-r11-gf32-pointed-quotient-replay.py            PASS, 20.4 s
   1129 pointed orbits, 1129 finite witnesses, degrees {9: 1129}, 1000 equivariance pairs
2026-08-28-r11-gf16-pointed-quotient.py --check ...       PASS, 17.3 s   (needs the toolkit)
2026-08-28-r11-gf32-pointed-quotient.py --check           PASS, 94   s   (needs the toolkit)
```

Both replays run with no toolkit and no network. Only the two replays go into
`verify.py --replay`.

## 3. Bundle 2 — `Certificate R11 GF(27) sweep`

Directory `supplement/evidence/r11-gf27-switch-sweep/`.

Layout decision: `package_evidence_bundle.py` builds each path as
`Path("evidence") / slug / public_name` and serializes with `.as_posix()`, so a
`public_name` containing `/` works with no change to its logic. That matters
because `cargo` refuses a `--manifest-path` that does not end in `Cargo.toml`,
so a fully flat layout would make the Rust generator unbuildable. The bundle is
therefore flat for the evidence files and keeps one dated subtree for the cargo
crate, which is copied with **no edits at all**:

| public file | role | replay class |
|---|---|---|
| `2026-08-28-r11-gf27-switch-sweep/src/main.rs` | Rust generator (`full`/`dump`/`e3`/`certify`) | rederive |
| `2026-08-28-r11-gf27-switch-sweep/Cargo.toml` | crate manifest | compare |
| `2026-08-28-r11-gf27-switch-sweep/Cargo.lock` | dependency lock (no dependencies) | compare |
| `2026-08-28-r11-gf27-witness-replay.py` | independent Python witness replay | reconstruct |
| `2026-08-28-r11-gf27-certify-summary.txt` | sweep summary | compare |
| `2026-08-28-r11-gf27-certify-histogram.tsv` | `n_good` histogram | compare |
| `2026-08-28-r11-gf27-certify-unsaturated.tsv` | unsaturated classes (header only) | compare |
| `2026-08-28-r11-gf27-certify-witness-sample.tsv` | seeded 200-class witness sample | compare |
| `2026-08-28-r11-gf27-certify-quotient-rows.tsv` | per-quotient-point fibre minima | compare |
| `2026-08-28-r11-gf27-certify-progress.txt` | auditable progress trace | compare |

What it certifies (§8 of `notes/reed-solomon-tasks/c973-2026-08-28-gf27-switch-probe.md`):
for `K = GF(27) = F_3[x]/(x^3 - x - 1)`, every one of the **402,321,277**
projective classes of `PG(6,27)` — that is `(27^7 - 1)/26`, the whole R11
carrier `P<e_2,...,e_8>` over GF(27), with no carrier-membership condition
imposed — admits a monic degree-nine locator with nine distinct roots in `K`
satisfying both Hankel equations. Every witness is a two-point affine-plane
switch and every class admits at least **78** of them (global minimum, attained
at `z = (0,1,0,0,0,0,0)`; mean 339.3223). The `C(27,9)` exhaustive fallback was
wired in and invoked zero times. Because all nine roots are finite, the sweep is
pointed for free: the carrier is `PGL_2(27)`-stable and the Hankel system is
`PGL_2`-equivariant, so any prescribed root can be moved to infinity.

Boundary to state in public: this is a user-authorized certificate closure of
the carrier `PG(6,27)`, **not** of the ambient `PG(10,27)`, and the
certificate-free switch lemma remains open.

Only path patch: the witness replay's default input, from
`os.path.join(here, "out", "certify-witness-sample.tsv")` to the flat dated
`2026-08-28-r11-gf27-certify-witness-sample.tsv` (its docstring updated to
match). It still accepts an explicit path argument.

The Rust rerun is 26.5 minutes on 8 threads, so it is `rederive` and is **not**
in `verify.py --replay`; the Python witness replay is instantaneous and is.

Measured:

```
cargo build --release --locked --manifest-path <bundle>/2026-08-28-r11-gf27-switch-sweep/Cargo.toml
   exit 0, 7.0 s, no warnings          (CARGO_TARGET_DIR redirected out of the paper tree)
PROBE_THREADS=4 PROBE_QLIMIT=3 probe certify    smoke run, 1.18 s, reproduced the
   rank0-kernel minimum 222 and rank1-graph minimum 78 of the full sweep
2026-08-28-r11-gf27-witness-replay.py           PASS: 200 witness rows, 0 failing
```

The smoke run writes to `<crate>/out/` (the crate uses `CARGO_MANIFEST_DIR`), so
it cannot overwrite the frozen dated copies; the scratch `out/` directory was
removed afterwards.

## 4. Bundle 3 — `Certificate R11 characteristic seven`

Directory `supplement/evidence/r11-char7-pointed-orbits/`.

| public file | role | replay class |
|---|---|---|
| `2026-08-28-r11-char7-pointed-orbits.py` | generator (calls the toolkit's `simultaneous-locator`) | rederive |
| `2026-08-28-r11-char7-pointed-orbits.json` | certificate, seven records | compare |
| `2026-08-28-r11-char7-pointed-orbits-replay.py` | **new** implementation-independent replay | reconstruct |

Path patch to the generator: its `ROOT` pointed at the paper's **former** name
`papers/beyond4_prs/software/...`, which no longer exists; it is now
`PAPER = parents[3]` with `DEFAULT_BINARY = PAPER / "software/..."`, and
`DEFAULT_OUTPUT` is the dated filename. Nothing hashes this generator's source,
so patching it is free. `--check` PASSes from the bundle in 33.6 s.

Content of the certificate, per
`notes/reed-solomon-tasks/c973-2026-08-26-characteristic-seven-closure.md`: over
`F_49 = F_7[x]/(x^2+1)` the R11 characteristic-seven maximal Lucas carrier
`M_11,7 = P<e_4,e_5,e_6>` is `PGL_2`-equivariantly the divided quadratic module,
so a carrier point together with a marked projective root has exactly **five**
orbits (double root distinguished/complement, split distinguished/complement,
nonsplit); the R12 carrier `P<e_5,e_6>` has **two** (equal, distinct). The seven
records are exact pointed locator certificates for those seven representatives —
five at R11 and two at R12 — not seven R11 orbits.

### 4.1 The new independent replay

`2026-08-28-r11-char7-pointed-orbits-replay.py` shares no code with the toolkit
and none with the generator. It rebuilds GF(49) from the certificate's own
`field` block (`p=7`, `degree=2`, `modulus=[1,0,1]`,
`polynomial-basis-base-p-integer-v1`) with its own digit arithmetic, and proves
the field property by exhaustive inverse search rather than by trusting the
modulus. Per record it checks:

1. the nested certificate schema and field block agree with the envelope;
2. the syndrome is supported **exactly** on the recorded carrier coordinates
   with the recorded coefficients;
3. the carrier is stable under the degree-`(r-1)` divided-power translation
   action, by the Lucas vanishing `binom(i,j) = 0 mod 7` for every `j` in the
   carrier and every `i` above it;
4. the support consists of distinct projective roots, at most one at infinity,
   with `distance = |support|`;
5. the stored locator has length `|support| + 1` and is exactly the projectively
   normalized monic root polynomial rebuilt from the support (scalar-multiple
   test plus the "lowest nonzero coefficient is one" normalization);
6. the locator's zero set, recomputed by exhaustive evaluation over all 49
   elements, equals the recorded finite support, its formal degree equals the
   finite root count, and `infinity in support` iff the degree drops;
7. the recorded forbidden projective root is absent from the support and is not
   a zero of the locator;
8. the two Hankel-kernel contractions vanish, in the shared convention of §1;
9. the recorded magnitudes reconstruct the syndrome on the support
   (`sum_j m_j x_j^i = z_i`, with the infinity column `[i+1 == r]`), all nonzero;
10. the recorded `locator_sha256` digest is current.

Envelope level: orbit count, `all_verified`, the declared maximum candidate
count, and that no recorded search exceeded the declared candidate limit.

Not certified: the `distance` field is the toolkit's exact minimum-distance
claim and rests on its increasing-degree search order. The replay re-establishes
the displayed witness, i.e. the upper bound only. This is stated in the file's
docstring.

Result: `PASS (7 orbits over GF(49), redundancy histogram {11: 5, 12: 2}, two
Hankel windows each, every locator rebuilt from its root set)`, 0.05 s.

### 4.2 Mutation validation

Nine mutations applied to a scratch copy of the certificate (the bundled JSON
was never modified — its SHA-256 is unchanged at
`fa9c02f5662785f15acfea3500a84548b36efb189ab8957e887a1dd8699a6c0d`). All nine
were detected, and the unmutated certificate still passes:

| mutation | caught by |
|---|---|
| flip one locator coefficient | scalar-multiple test |
| flip one locator coefficient **and** repair its digest | scalar-multiple test |
| replace one support point | scalar-multiple test |
| perturb one syndrome coordinate | carrier-support test |
| perturb the syndrome inside its own carrier | **Hankel equation 0 = 46** |
| declare a forbidden root that lies in the support | pointed test |
| corrupt one magnitude | magnitude reconstruction |
| swap in the reducible modulus `x^2+6` | exhaustive inverse search |
| move a carrier index off the Lucas carrier | carrier-support test |

The fifth mutation is the one that isolates the Hankel system: it keeps the
syndrome inside its declared carrier so only the contraction equations can
object.

## 5. Registration

### 5.1 `supplement/package_evidence_bundle.py`

Three entries appended to `BUNDLES`, inserted before `Certificate SC` so the
companion bundles stay grouped. Nested `public_name` values are used for the
GF(27) crate; `expected_entries` builds `Path("evidence") / slug / public_name`
and serializes with `.as_posix()`, so this needs no change to the packager's
logic. Verified:

```
python3 supplement/package_evidence_bundle.py --write
python3 supplement/package_evidence_bundle.py --check   ->  verified 93 bundled evidence artifacts
```

### 5.2 `supplement/verify.py`

Four jobs appended to `replay()`'s `python_jobs`:

```
r11-binary-quotients      2026-08-28-r11-gf16-pointed-quotient-replay.py
r11-binary-quotients      2026-08-28-r11-gf32-pointed-quotient-replay.py
r11-gf27-switch-sweep     2026-08-28-r11-gf27-witness-replay.py
r11-char7-pointed-orbits  2026-08-28-r11-char7-pointed-orbits-replay.py
```

Nothing else in `verify.py` was touched. The concurrent manuscript agent's
change to the manuscript-label count (50 -> 52) was already on disk and is
preserved.

### 5.3 Documentation

- `supplement/CERTIFICATE-SCHEMA.md`: three label-table rows, all with paper
  claim "none; companion record", plus a new **Redundancy-eleven companion
  records** section carrying the shared Hankel/encoding convention, the
  equivariance gate, the explicit naming of the degree-ten divided-power upper
  Borel action, the wrong-group warning (the superseded group gives the same
  counts, so a count can never validate the action), the GF(27) carrier-versus-
  ambient boundary, and the characteristic-seven replay's exact-distance
  exclusion.
- `supplement/REPRODUCING.md`: three replay-map rows, four replay commands in
  the exact-command block, and a new **Redundancy-eleven companion bundles**
  section giving the generator commands, their runtimes, their toolkit and
  compiler requirements, the GF(27) rerun's separate output directory, and the
  `PROBE_QLIMIT` smoke-test switch. The stale phrase "the two Rust generators"
  was generalized.
- `verification-map.md`: three companion rows in the main table, each with the
  "not a claim of the current submission" non-claim column. Also removed the
  now-stale artifact count from the release-boundary paragraph (the evidence map
  grew from 74 to 93 rows because of this registration).
- `supplement/RELEASE-MANIFEST.md`: refreshed the four artifact rows whose files
  this task changed (`EVIDENCE-MANIFEST.json`, `EVIDENCE-ROWS.md`,
  `package_evidence_bundle.py`, `verify.py`). The PDF fields were left alone;
  they belong to the concurrent manuscript rebuild.

## 6. Validation

`python3 supplement/verify.py --replay` exits **1**, at
`release manifest has stale local PDF SHA-256`. That is the expected concurrent
manuscript rebuild and is outside this task's ownership. Because
`check_release_manifest()` runs inside `check_bundle()` and therefore *before*
`replay()`, that failure also prevents the replay list from running at all under
the top-level entry point.

Everything bundle-related that ran before that point passed:

```
verified Version 2 manuscript labels and exact Lean target sets
verified 24 companion-software artifacts
verified 93 bundled evidence artifacts
classification records: PASS
R6 manuscript table: PASS
verified classification-record hashes
```

All four newly registered replays were driven through `verify.py`'s own `run()`
helper with the exact working directory and argument vector registered in
`python_jobs`, after asserting that each `(directory, script)` pair really is
present in `replay()`'s source. All four pass:

```
2026-08-28-r11-gf16-pointed-quotient-replay.py    317 orbits, 317 finite witnesses,
                                                  degrees {8: 2, 9: 315}, 1000 equivariance pairs
2026-08-28-r11-gf32-pointed-quotient-replay.py    1129 orbits, 1129 finite witnesses,
                                                  degrees {9: 1129}, 1000 equivariance pairs
2026-08-28-r11-gf27-witness-replay.py             200 witness rows, 0 failing
2026-08-28-r11-char7-pointed-orbits-replay.py     7 orbits over GF(49), {11: 5, 12: 2},
                                                  two Hankel windows each
```

### 6.1 Pre-existing failure in a foreign bundle: `r7-direct-locus-v2`

Driving the complete `replay()` list directly (bypassing the stale release
manifest) aborts before reaching the redundancy-eleven jobs, at

```
2026-08-02-r7-direct-locus-generator.py --check   ->  AssertionError, exit 1
```

This is **not** caused by this task. `Certificate R7 direct locus` is clean
against `HEAD` and was not touched here. Diffing the regenerated document
against the frozen certificate structurally shows exactly one differing key:

```
/engine_sha256   regenerated 619ea2591ece8871e445dbe910a7913ee9be7a6aa144812f1f8d031fb1705d2a
                 frozen      658126d67e53707f29a2482d6cba8ef7cef28fe20f9298af585ebba6af180586
```

`engine_sha256` is the hash of the shared direct-locus engine
`supplement/evidence/r7/2026-07-26-r7-direct-locus-replay.py`, which the
generator imports via `ENGINE_PATH`. That file currently hashes to
`619ea25...`. Both it and the certificate were last written by commit
`4008f090f`, "Strengthen and rename high-weight GRS cosets paper", so the engine
source was edited during the paper rename without regenerating the direct-locus
certificate that pins it. Every mathematical field agrees; only the provenance
pin is stale.

This is the same failure mode as the GF(32) `base_source_sha256` pin discussed
in §2.1, which is why the GF(16) generator here is bundled byte-for-byte. Raised
for the owning lane; not repaired here, and not staged.

### 6.2 The work was committed by the concurrent agent, not by this task

Nothing here was staged or committed by this task. While the validation runs
were in flight, the concurrent manuscript agent committed the working tree as
`8ac89f324`, "paper(high-weight-grs-cosets): C988 all-characteristic
classification, R11 companion evidence", which swept in all nineteen bundle
files and all eight supplement/verification-map edits listed in §7, together
with their own manuscript work. The committed bundle content is byte-identical
to what is described here, `package_evidence_bundle.py --check` still reports
`verified 93 bundled evidence artifacts` against it, and
`git status` is clean for every path in §7.

Two things still need a follow-up commit: this report, which was committed at an
earlier draft state and has been extended since, and any release-manifest
refresh once the manuscript PDF settles.

## 7. Files

New, all untracked under `papers/high_weight_grs_cosets/supplement/evidence/`:

| path (relative to the paper root) | role | SHA-256 |
|---|---|---|
| `supplement/evidence/r11-binary-quotients/2026-08-28-r11-gf16-pointed-quotient.py` | GF(16) generator, rederive | `81d2faa0679077fb007353dce5803768d9ee2a5e4bdc9b1d2edbfff6fe85498f` |
| `supplement/evidence/r11-binary-quotients/2026-08-28-r11-gf16-pointed-quotient.json` | GF(16) certificate, compare | `fa7a8c21511bb923ba52ef983d5626851de78943409d684476a23072dd08268f` |
| `supplement/evidence/r11-binary-quotients/2026-08-28-r11-gf16-pointed-quotient-replay.py` | independent GF(16) replay, reconstruct | `afb00c1d5ef6f455a41aeea4c6e0465c2850bf0a7016a29aa9a2c4e4e3bd3d02` |
| `supplement/evidence/r11-binary-quotients/2026-08-28-r11-gf32-pointed-quotient.py` | GF(32) generator, rederive | `1a83fdcd592298cb0b2e1eb5e7cdc9148cb9a8142a881de7ec42d8cf6f70dae1` |
| `supplement/evidence/r11-binary-quotients/2026-08-28-r11-gf32-pointed-quotient.json` | GF(32) certificate, compare | `4b7ff0d8eddcd71819657b7cd3cd724ecd6ceedd83c6a36acb67601633c7979f` |
| `supplement/evidence/r11-binary-quotients/2026-08-28-r11-gf32-pointed-quotient-replay.py` | independent GF(32) replay, reconstruct | `8761a37b31ccab8faf921cae51f68a6e36c3d12d9f2cbb5f87bc3cd0fff938ce` |
| `supplement/evidence/r11-gf27-switch-sweep/2026-08-28-r11-gf27-switch-sweep/src/main.rs` | Rust sweep generator, rederive | `b7c7fdfae6440c59c93940653606fda82f899f2df7898cbd1a19ff4fe8d8c829` |
| `supplement/evidence/r11-gf27-switch-sweep/2026-08-28-r11-gf27-switch-sweep/Cargo.toml` | crate manifest, compare | `5c1d8c53c3bb7413355bc5be2d6d83cc8d02cd0088eb9b1f0ee18451b7f9b893` |
| `supplement/evidence/r11-gf27-switch-sweep/2026-08-28-r11-gf27-switch-sweep/Cargo.lock` | dependency lock, compare | `45cc5f2d41b4377bdbeb2f3d63cc99af584bb06fc4f6775d6216d575d94f68f2` |
| `supplement/evidence/r11-gf27-switch-sweep/2026-08-28-r11-gf27-witness-replay.py` | independent witness replay, reconstruct | `05d68f7374751f178bbfb6daf67e1a2ae4b3df4aca47488c57cff87bd84c08fc` |
| `supplement/evidence/r11-gf27-switch-sweep/2026-08-28-r11-gf27-certify-summary.txt` | sweep summary, compare | `f7d3ade14aca0e6112b146c13e3d67a663b37fcdf716e234aa7083c4b5ac7c0a` |
| `supplement/evidence/r11-gf27-switch-sweep/2026-08-28-r11-gf27-certify-histogram.tsv` | `n_good` histogram, compare | `aa456c3d2d310064a781e83acccb648c631901948a4bd30d626f331510f37c56` |
| `supplement/evidence/r11-gf27-switch-sweep/2026-08-28-r11-gf27-certify-unsaturated.tsv` | unsaturated classes, header only, compare | `6d70875f05005089e5258180f7e635e53a62a04c23eb1243e261ad5e0dd6354f` |
| `supplement/evidence/r11-gf27-switch-sweep/2026-08-28-r11-gf27-certify-witness-sample.tsv` | seeded witness sample, compare | `5dc58017fd6e0fe48140f515caa742a8491d8999272b5836c2304a9f46cdfa6a` |
| `supplement/evidence/r11-gf27-switch-sweep/2026-08-28-r11-gf27-certify-quotient-rows.tsv` | per-fibre minima, compare | `63bd14bcf01db2f17ff63293fd8fcecb48ac7df10f64bfeee18ae6e8c7f376d4` |
| `supplement/evidence/r11-gf27-switch-sweep/2026-08-28-r11-gf27-certify-progress.txt` | progress trace, compare | `c138052a9e654f7a0689c60027549c2789e282da2c883af6eb8f3ba82db1066b` |
| `supplement/evidence/r11-char7-pointed-orbits/2026-08-28-r11-char7-pointed-orbits.py` | generator, rederive | `534d773f0ba0806611300b886648039f5e02b515f71afc911f410eee2bf32c5c` |
| `supplement/evidence/r11-char7-pointed-orbits/2026-08-28-r11-char7-pointed-orbits.json` | certificate, compare | `fa9c02f5662785f15acfea3500a84548b36efb189ab8957e887a1dd8699a6c0d` |
| `supplement/evidence/r11-char7-pointed-orbits/2026-08-28-r11-char7-pointed-orbits-replay.py` | **new** independent replay, reconstruct | `db55825d5b6724a356d46262a74e388246124e03c513b4bc67054ac4d5de03f3` |

`__pycache__/` directories appear inside `r11-binary-quotients/` because the
GF(32) scripts load their siblings through `importlib`. They are covered by the
repository's top-level `__pycache__/` ignore rule and are not part of the bundle.

Modified:

| path (relative to the paper root) | role | SHA-256 |
|---|---|---|
| `supplement/package_evidence_bundle.py` | three `BUNDLES` entries added | `a63ec1899ee81dd2b0ab5bad1e1ff82a29231032178f1f66bbdc8158e5c710c2` |
| `supplement/verify.py` | four `python_jobs` replay entries added | `90d77a001600fb06899243345f2ad25973d01859c1382e316dae4ce5f7444c09` |
| `supplement/CERTIFICATE-SCHEMA.md` | label rows plus the companion-records section | `172a42ec4e530bc4e8f63bc7eb447017e2c55d7c64742c01238005823885cb81` |
| `supplement/REPRODUCING.md` | replay-map rows, replay commands, generator section | `1d89e2ade056a74cdc587c80c30c0bfb605c276faf653c4e90d9640fa64b0d0e` |
| `supplement/EVIDENCE-MANIFEST.json` | regenerated by `--write` | `c3b93bd5ed6997c628ce31ef5ad719056a41a28621e2dbbca7b26b8d10ac1520` |
| `supplement/EVIDENCE-ROWS.md` | regenerated by `--write` | `01ae87a5c700d249e1f69c840ddbebab781c025643b6eda52c57b799dfaf9a91` |
| `supplement/RELEASE-MANIFEST.md` | four artifact rows refreshed (PDF fields untouched) | `aef3e1a5ba2182b6a5c5e597d6fb736f03dabb6d20f8fa8bde498e66ccd6a0f3` |
| `verification-map.md` | three companion rows; stale artifact count removed | `b7dd942c50db31f7d116103d764d4960edd118ad45e2f66e343e2c3c3884bec9` |

`supplement/LEAN-STATEMENTS.md` also shows as modified in the same paths, but
that is the concurrent manuscript agent's work, not this task's.

The `RELEASE-MANIFEST.md` and `verify.py` hashes above are as of this run; both
files are shared with the concurrent manuscript agent, so whoever finishes the
manuscript rebuild should run `python3 supplement/verify.py --write-local-manifest`
last, which refreshes the PDF fields and all seven artifact rows together.

## 8. Open items for the caller

1. This task staged and committed nothing. The concurrent manuscript agent
   committed the tree as `8ac89f324` mid-run, so the three bundle directories
   are now tracked anyway (§6.2). This report itself is the one path still
   dirty, having been extended after that commit.
2. `verify.py --replay` currently cannot reach the redundancy-eleven jobs for
   two reasons, both foreign to this task: the stale local PDF hash aborts
   `check_bundle()` before `replay()` starts, and the stale `engine_sha256` in
   the `Certificate R7 direct locus` bundle (§6.1) aborts `replay()` partway
   through. Both need their owning agent. The four new jobs were verified
   directly through `verify.py`'s own runner.
3. The `Certificate R7 direct locus` defect is a committed reproducibility
   regression from commit `4008f090f` and should get its own task: regenerate
   `2026-08-02-r7-direct-locus-certificate.json` and its public comparison so
   the `engine_sha256` pin matches the current engine source.
4. The GF(16) quotient generator is the one script bundled with unpatched path
   defaults, for the `base_source_sha256` reason in §2.1. Its documented command
   in `REPRODUCING.md` passes `--binary` and `--output` explicitly. If a future
   change makes patching it acceptable, the GF(32) certificate must be
   regenerated in the same commit.
