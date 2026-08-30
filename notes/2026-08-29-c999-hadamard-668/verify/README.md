# `had668` — Hadamard matrix verification and structural classification

Built for C999 (lane `gem-mining`) to check and classify the order-668 Hadamard matrix
announced by Alpöge et al. in August 2026. Every subcommand works at any order; `selftest`
exercises the whole pipeline against constructions whose properties are known independently.

Nothing here reads or writes `../evidence/`. Point the tool at those files; do not move them.

## Build and run

`/tmp/persistent` is mounted `noexec`, so cargo cannot run build scripts there. The target
directory lives on the same ZFS pool under `$HOME` instead, which is exec-capable and is not the
RAM-backed `/tmp` tmpfs.

```bash
cd notes/2026-08-29-c999-hadamard-668/verify
CARGO_TARGET_DIR=~/.cache/c999-target cargo build --release -j 1
B=~/.cache/c999-target/release/had668
```

nauty is not on `PATH`. Either export a store path once, or let the tool fall back to
`nix shell nixpkgs#nauty --command dreadnaut` (slower, re-evaluated per call):

```bash
export DREADNAUT=$(nix build nixpkgs#nauty --no-link --print-out-paths)/bin/dreadnaut
```

Resolution order for the solver is `$DREADNAUT`, then `dreadnaut` on `PATH`, then `nix shell`.

`verify` uses rayon. Pin it when the host is busy:

```bash
export RAYON_NUM_THREADS=1
```

Scratch `.dre` graph files go to `--workdir`, default `/tmp/persistent/tavis/c999-work`
(override with `$HAD668_WORKDIR`). They are ordinary data, so `noexec` does not matter there;
at n = 668 the file is about 9 MB, which is why it does not belong on the tmpfs.

## Subcommands

### `verify <file>`

Reads a ±1 matrix, checks that it is square with entries ±1, and that `H·Hᵀ = n·I` exactly in
`i64`. Emits JSON with `n`, `pass`, the SHA-256 of both the as-given and the dephased canonical
text forms, the row-sum multiset, and — on failure — `max_abs_offdiag` plus the worst row pair.
Exit status is 1 when the check fails.

Input formats are auto-detected: whitespace-separated `1`/`-1`/`+1`, rows of `+`/`-`, rows of
`0`/`1`, or bit-packed hex/base64. Override with `--format pm|zo|num|hex|b64`. Bit-packed input
needs `--n <N>`; `--bit-zero-is plus|minus` picks the sign convention and
`--bit-layout contiguous|row-aligned` picks whether rows start on byte boundaries.

```bash
$B verify ../evidence/H668.txt
$B verify ../evidence/H668.b64 --format b64 --n 668 --bit-zero-is minus
```

### `normalize <file>`

Dephases (negate rows so column 0 is all `+`, then negate columns so row 0 is all `+`) and
prints the canonical `+`/`-` text. `--out <path>` writes to a file, `--hash` prints the SHA-256
on stderr. The canonical hash reported by `verify` is the hash of exactly this output.

### `autgroup <file>`

Builds the 4n-vertex graph — row vertices `r±`, column vertices `c±`, with `r^s ~ c^t` iff
`H[r][c]·s·t = +1` — and hands it to `dreadnaut`.

Row and column vertex classes are coloured separately by default, so transpose-type
automorphisms are excluded and the group computed is exactly the set of signed monomial pairs
`(P, Q)` with `P H Qᵀ = H`. `--no-color` drops the colouring and admits transposes.

The pair `(−I, −I)` — swap every `r+ ↔ r−` and every `c+ ↔ c−` — is a central involution that
acts trivially on `H`. The report gives both `aut_graph_order` and
`hadamard_aut_order_mod_center = |Aut(graph)|/2`. Paley I at order 660 confirms the convention:
the tool returns 286190520 and 143095260, and 143095260 is exactly `|PSL(2,659)|`.

Also reported: orbit sizes (computed by union-find over the generators), generator cycle types,
and the cyclic-element scan described under `classify`. `--emit-only` writes the `.dre` file and
prints its path without running nauty.

`--traces` selects nauty's Traces engine (`At+`), `--invariant <code>` and `--invar-levels lo hi`
select a vertex invariant (`1` = twopaths, `2` = adjtriang, `6` = cellquads). **At the orders in
`../evidence/` none of these is enough** — see "Automorphism groups are the hard part" below.

Note on parsing: `dreadnaut` wraps long permutations over several lines and splits individual
cycles mid-way, and the `o` command's orbit line is indistinguishable from a continuation line.
The tool therefore does not issue `o`, and reassembles each generator from its column-0 opening
line plus all following indented lines.

### `classify <file>`

Runs every structural test on both the matrix as given and its dephasing, and reports exactly
what was tested. `--with-aut` additionally runs `autgroup` and enables the cyclic screen.

Direct block tests (authoritative — they check the actual block structure):

- **`two_circulant`** — splits into four blocks of order `n/2` (334 at n = 668) and accepts
  `[A B; −Bᵀ Aᵀ]` or `[A B; Bᵀ −Aᵀ]` with `A`, `B` circulant.
- **`bordered_two_circulant`** — the Legendre-pair shape. Core length `(n−2)/2`, which is 333 at
  n = 668. Tries the border as the first two and as the last two rows/columns. On a hit it
  extracts the two ±1 sequences, verifies the Legendre condition
  `PAF_a(s) + PAF_b(s) = −2` for every `s ≠ 0`, and reports the multiplier groups (below).
- **`williamson`** — four symmetric circulant blocks of order `n/4` (167 at n = 668) in
  `[A B C D; −B A D −C; −C −D A B; −D C −B A]`, rebuilt from the first block row and compared.
- **`goethals_seidel`** — four circulant blocks of order `n/4` in the Goethals–Seidel array with
  the back-diagonal `R`, rebuilt from the first block row and compared.
- **`gs_array`** — the general Goethals–Seidel test, and the one that recognises the decoded
  matrices. It reads the array as a *pattern* over four arbitrary blocks, inside an optional
  border of width 0, 4, 12, 20 or 28:

  ```text
  [  A      BR      CR      DR
    -BR     A       D^op R -C^op R
    -CR    -D^op R  A       B^op R
    -DR     C^op R -B^op R  A     ]
  ```

  The six relations with no transpose fix the outer skeleton. The operation `X^op` is then *read
  off* the array rather than assumed to be the matrix transpose, and the remaining three
  relations check that one operation works consistently. `transpose_operation_is_matrix_transpose`
  says which case it is. Blocks are then described: circulant, or block-circulant with a reported
  sub-block length. When the blocks are circulant the four first rows are extracted and the
  `Σᵢ PAF_i(s)` and `Σᵢ (row sum_i)²` identities are evaluated. Bordered arrays additionally get
  the border described — the corner, the per-block border-row signs, and the per-slab column
  prefixes.
- **`multipliers`** (inside the `gs_array` detail, when the blocks are circulant) — the fixed
  multiplier group of the four sequences: units `t` of `Z_m` with `X_k[t·i] = X_k[i]` for every
  block and every `i`. Each non-identity element is re-verified against the full matrix as a
  monomial automorphism, using the shared offset `r` with `2r ≡ t − 1 (mod m)`.

  That offset is the whole subtlety, and getting it wrong is why an earlier version reported
  every multiplier group as trivial. Mapping `i → t·i` on rows and columns uniformly preserves a
  circulant diagonal block (entry `a[j − i]`) but not a back-circulant off-diagonal block (entry
  `c[i + j]`), which becomes `c[t(i+j) + 2r]`. The diagonal blocks force the row and column
  offsets to agree, and the off-diagonal ones then force `2r = t − 1`, shared across all blocks
  rather than per block-column. The group is computed on the *sequences*, which has no such blind
  spot; the matrix check is confirmation. `selftest`'s `multiplier_detection_892` case pins it.
- **`shift_automorphisms`** (inside the `gs_array` detail) — an exact, solver-free automorphism
  search. For each shift `s` it permutes rows and columns by "fix the border, rotate each block
  by `s`" and tests whether that pair is realised by a monomial automorphism `P H Q = H`.
  Dephasing is a *complete* invariant for the row/column sign group: the dephased form is
  `Y_ij = X_00 X_i0 X_0j X_ij`, independent of any sign choice, so equality of dephasings is
  necessary and sufficient. A listed shift is a proved automorphism and an omitted one is proved
  not to be. When the blocks are block-circulant the search is repeated at sub-block granularity.

  The outcome is forced by parity. Diagonal blocks are circulant, forcing row shift = column
  shift; off-diagonal blocks are back-circulant, forcing row shift = −column shift. A common
  shift needs `2s ≡ 0 (mod m)`, so even `m` admits exactly the half-shift `m/2` and odd `m`
  admits nothing.

Recording tests:

- **`paley_applicability`** — reports whether `n−1` and `n/2−1` are prime powers in the right
  residue class. At n = 668 both are negative and recorded as such: 667 = 23·29 and
  333 = 3²·37 are not prime powers, so no Paley construction reaches 668. When a Paley I matrix
  does exist at the order and `q` is prime, the matrix is also compared against it literally
  (after dephasing); `found` means that literal match, not mere existence.
- **`cyclic_block_structure_from_aut`** — a **screen only**, for Turyn-type block-circulant
  structure. It samples a deterministic random walk over nauty's generators (2000 words, set
  `$HAD668_RANDOM_WORDS`) and keeps every cyclic power whose cycles all have length 1 or the
  element's order and which fixes at most `$HAD668_FIXED_CAP` points (default 16; a
  border of b rows and b columns fixes 2b + 2b). Zero fixed points is the unbordered
  block-circulant signature; equal, even counts of fixed row and column vertices give an implied
  border width, which the report names. A hit does **not** establish the form: Sylvester at order 16 produces a spurious order-7
  hit with the bordered shape. Absence is evidence, not proof — nauty's own generators sit near
  the identity, which is why the random walk exists at all.

### Legendre-pair multipliers and the C736–C741 census

When `bordered_two_circulant` fires, the report gives, for the extracted pair `(a, b)`:

- `fixed_common_multipliers` — units `m mod ℓ` with `a[m·i] = a[i]` and `b[m·i] = b[i]` for all
  `i` (untranslated).
- `translated_common_multipliers` — units `m` for which some shift `t` gives `a[m·i + t] = a[i]`,
  and likewise for `b`. This is the equivalence-invariant version; a found pair may be a
  translate of a census representative.

At ℓ = 333 the fixed group is matched against the nine residual fixed common-multiplier
subgroups of `(Z/333)*` from the in-repo reports, in the numbering of arXiv:2607.20765v1,
Table A1. `selftest` reconstructs each from its generators and checks the element lists against
the reports.

| ID | generators | elements | status | provenance |
|---:|---|---|---|---|
| 0  | —          | {1}           | residual survivor | C736 census, not excluded by C738/C740 |
| 1  | 73         | {1, 73}       | residual survivor | C736 census, not excluded by C738/C740 |
| 2  | 112        | {1, 112, 223} | excluded          | C740: orbit lock, 222 ≥ 167 at shifts 111 and 222 |
| 3  | 10         | {1, 10, 100}  | residual survivor | C736 census, not excluded by C738/C740 |
| 4  | 121        | {1, 121, 322} | residual survivor | C741: 108 orbit representatives still open |
| 5  | 211        | {1, 211, 232} | residual survivor | C741: 108 orbit representatives still open |
| 7  | 73, 112    | order 6       | excluded          | C738 |
| 9  | 73, 85     | order 6       | excluded          | C736: mod-8 obstruction in the exact 9-compression |
| 10 | 73, 121    | order 6       | excluded          | C736: mod-8 obstruction in the exact 9-compression |

The five residual survivors are IDs 0, 1, 3, 4, 5.

If the 668 matrix turns out to be a bordered two-circulant from a Legendre pair of length 333,
a fixed multiplier group matching an **excluded** ID would contradict those proofs and must be
investigated before anything else. A group matching no listed subgroup is also reported: the
census covers only the fixed, untranslated cases, so check `translated_common_multipliers` too.

### `certify <files...> --outdir <dir>`

Runs verify + classify (+ optionally the automorphism group) on each file and writes one
`H<n>.json` per order: the order, the SHA-256 of the source file and of both canonical text
forms, the exact `max |(H Hᵀ)_ij|` over `i ≠ j`, the row-sum multiset, the full classification
test ledger, and the automorphism result. `--with-aut` adds the group, `--traces` picks the
Traces engine, and `--aut-timeout <secs>` bounds each attempt so a slow solver cannot stall the
run. Exit status 1 if any input fails to be Hadamard.

### `selftest`

Builds each known matrix, verifies it, classifies it, and computes its automorphism group.
`--outdir <dir>` writes each as a `.pm` fixture, `--aut-max-n` (default 700) caps the
automorphism computation, `--json` prints the full report. Exit status 1 on any failure.

### `decode`

**Not implemented.** The poster's encoding is not known here. The subcommand prints what the
generic readers already handle and exits 2. If the published decoder is a script, run it and
feed its output to `verify`; if the payload is bit-packed hex or base64, `verify --format` and
`--bit-layout` already cover both bit conventions and both row layouts without new code.

## Selftest output

`RAYON_NUM_THREADS=1 taskset -c 0 $B selftest` — 1.21 s wall, 6 MB peak RSS, all cases pass.

| case | n | verify | form | \|Aut(graph)\| | mod center | expected |
|---|---:|---|---|---:|---:|---|
| `sylvester_4`            | 4   | ok | ok | 192          | 96         | checked |
| `sylvester_16`           | 16  | ok | ok | 10321920     | 5160960    | checked |
| `sylvester_32`           | 32  | ok | ok | 2.047868928e10 | ~1.023934e10 | checked |
| `paley1_12`              | 12  | ok | ok | 190080       | 95040      | checked |
| `paley1_660`             | 660 | ok | ok | 286190520    | 143095260  | checked |
| `williamson`             | 28  | ok | ok | 336          | 168        | recorded |
| `goethals_seidel`        | 28  | ok | ok | 48           | 24         | recorded |
| `two_circulant`          | 20  | ok | ok | 3840         | 1920       | recorded |
| `legendre_pair_bordered` | 28  | ok | ok | 58968        | 29484      | recorded |

Auxiliary checks: `census_subgroups_mod_333`, `parser_roundtrip_sylvester_16`,
`order_668_dry_run` — all pass.

Forms recovered: `williamson[as_given]`, `goethals_seidel[as_given]`,
`two_circulant[as_given]`, `bordered_two_circulant[as_given]` and `[dephased]`, each on its own
construction and on no other.

### Where the checked automorphism orders come from

For Sylvester `H_{2^k}`, the rows and their negatives are the `2^{k+1}` ±1 vectors of the
first-order Reed–Muller code `RM(1,k)`, an elementary abelian group under pointwise product. A
monomial column transformation preserves that set iff its sign vector lies in the code and its
permutation lies in `AGL(k,2)`, and the column part determines the row part, so

```
|Aut(H_{2^k})| = 2^{k+1} · 2^k · |GL(k,2)|
```

giving 192, 10321920 and 20478689280 at k = 2, 4, 5. The k = 2 value is cross-checked against
`(2^4 · 4!)² / 768 = 192`, the stabilizer order implied by the 768 Hadamard matrices of order 4.
The brief's suggested `2 · 16 · 20160 = 645120` for order 16 is **not** the right value; the sign
group has order `2^{k+1}`, not 2.

Order 12: the Hadamard matrix is unique up to equivalence with automorphism group `2.M12` of
order 190080, so the quotient is `|M12| = 95040`.

Order 660: `2 · |PSL(2,659)| = 2 · 659 · (659² − 1)/2 = 286190520`, quotient 143095260. This is
the strongest independent confirmation of the whole graph-plus-quotient convention, and it runs
at the target's scale (2640 vertices, 0.2 s).

### `order_668_dry_run`

Exercises every order-668 code path before the real matrix arrives. It builds sequences of
length 333 invariant under the ID-4 subgroup `⟨121⟩`, lays them out in the bordered form to get
a 668×668 matrix, and checks that the bordered test fires, that the census lookup names ID 4 as
a residual survivor, and that Paley is correctly recorded as inapplicable at 668. The matrix is
deliberately **not** Hadamard — no Legendre pair of length 333 is known — so `verify` fails on
it with `max_abs_offdiag = 108`, which is itself part of the assertion. `classify` at n = 668
takes 0.1 s.

## Results on the decoded matrices

The twelve matrices in `../evidence/` were decoded from the Alpöge payload by separate work in
`../decode.py`; that directory is not written by this crate. Exact replay:

```bash
cd notes/2026-08-29-c999-hadamard-668
CARGO_TARGET_DIR=~/.cache/c999-target cargo build --release --manifest-path verify/Cargo.toml
~/.cache/c999-target/release/had668 certify evidence/H*.txt \
    --outdir certificate --workdir /tmp/persistent/tavis/c999-work
sha256sum certificate/H*.json evidence/H*.txt > certificate/SHA256SUMS
```

All twelve are genuine Hadamard matrices: `max |(H Hᵀ)_ij| = 0` off the diagonal, in exact `i64`
arithmetic. Every source-file SHA-256 matches the table in `../README.md`. Full results and the
per-order records are in `../certificate/`.

| order | structure recovered by `classify` | block order | shift automorphism |
|---:|---|---:|---:|
| 668  | bordered Goethals–Seidel, border 4  | 166 circulant | 83 (order 2) |
| 716  | bordered Goethals–Seidel, border 4  | 178 circulant | 89 (order 2) |
| 892  | Goethals–Seidel                     | 223 circulant | none |
| 1132 | Goethals–Seidel                     | 283 circulant | none |
| 1244 | Goethals–Seidel                     | 311 circulant | none |
| 1388 | bordered Goethals–Seidel, border 20 | 342 = 6 × 57  | none |
| 1436 | bordered Goethals–Seidel, border 28 | 352 = 32 × 11 | none |
| 1676 | bordered Goethals–Seidel, border 4  | 418 circulant | 209 (order 2) |
| 1772 | bordered Goethals–Seidel, border 4  | 442 circulant | 221 (order 2) |
| 1916 | bordered Goethals–Seidel, border 12 | 476 = 4 × 119 | none |
| 1948 | Goethals–Seidel                     | 487 circulant | none |
| 1964 | Goethals–Seidel                     | 491 circulant | none |

The structure was recovered from the matrix entries alone and agrees with the decoder's account
of the poster's script in all twelve cases. The sequence conditions hold exactly: `Σᵢ PAF_i(s) = 0`
with `Σᵢ (row sum_i)² = n` for the unbordered orders, and `Σᵢ PAF_i(s) = −4` with
`Σᵢ (row sum_i)² = 4` for the bordered ones with circulant blocks.

**Order 668 is outside the C736–C741 Legendre-pair route.** Those tasks study Legendre pairs of
length 333, which would give order 668 as a bordered *two-circulant* with a 2-row border and two
circulants of order 333. The decoded H668 is a bordered *Goethals–Seidel* array with a 4-row
border and four circulants of order 166. The Legendre-pair test is run explicitly and does not
fire, as given or dephased. So no census exclusion is contradicted, no survivor is realised, and
the existence question for a Legendre pair of length 333 remains open — order 668 was settled by
a construction that never passes through it.

## Independent replay, and what is trusted

The orthogonality of all twelve decoded files was also checked by the decoding work with numpy,
using the snippet recorded under "Replay" in `../README.md`; it reported `max |H Hᵀ − nI| = 0`
for all twelve on 2026-08-29. The check here is a separate implementation — exact `i64`
accumulation in Rust over every row pair, reached through a different parser and a different
arithmetic path — and it agrees. Two independent implementations therefore certify the same
bytes, and `../certificate/SHA256SUMS` pins which bytes those are.

There is no Lean formalization of any of this and none is claimed. The trusted boundary is `i64`
integer arithmetic in Rust, numpy's `int32` matrix product in the cross-check, nauty for any
automorphism order (none is reported here), and — for the shift-automorphism statements — the
elementary dephasing argument above, which uses no solver at all.

## Automorphism groups, and the 4-profile invariant

`|Aut(H668)| = 4`; modulo the central swap the Hadamard automorphism group has order 2.

Reaching that needed a real vertex invariant. The 4n graph is regular, so refinement never
splits a cell unaided: dense nauty made no progress in 20 minutes with or without the twopaths,
adjtriang and cellquads invariants, and Traces burned its full 900 s budget without clearing its
first level. Which invariant *can* work is forced by orthogonality — see `src/invariant4.rs`:

- pairs are constant (`n/2` agreements for every pair);
- triples are constant too (`n/4` for every triple);
- odd-order products are not invariants at all — three entries pick up `eps_c³ = eps_c` under a
  column sign flip;
- quadruples are the first level that is both invariant and non-constant, via
  `J(i,j,k,l) = Σ_c H_ic H_jc H_kc H_lc = n − 2·popcount(b_i ^ b_j ^ b_k ^ b_l)`.

`had668 profile` colours each row by the multiset `{ |J(i,j,k,l)| : j<k<l }` and each column the
same way on the transpose. At n = 668 that splits the rows into **336 classes — 4 singletons and
332 pairs** — and the columns identically: the singletons are the border rows, the pairs are the
half-shift orbits. `C(668,4) = 8.2e9` XOR-popcounts, 28 s on 16 cores, 100 MB. Pass
`--profile-colour` to `autgroup` or `certify` and dense nauty then finishes in about 4 s.

The invariant correctly returns a single class on highly symmetric matrices (Paley 12,
Sylvester 16, the bordered Legendre-pair fixture at 28), which is what a transitive group
should give.

| order | \|Aut(graph)\| | mod centre | generators |
|---:|---:|---:|---|
| 668 | 4 | 2 | central swap; shift by 83 |
| 716 | 4 | 2 | central swap; shift by 89 |
| 892 | 6 | 3 | central swap; an order-3 element outside the shift and multiplier families |

For 668 the group is exactly the sign centre times the half-shift and nothing more, so the two
elements already proved by `shift_automorphisms` generate everything; the solver contributes
only the upper bound. bliss 0.73, given the same graph and colouring via `--emit-bliss`, returns
`|Aut| = 4` in 0.30 s with the same two generators — an independent second solver.

Order 892 is the surprise: order 6, from an element of order 3 fixing one position in each of
the four circulant blocks. It is neither a common block shift nor a common block multiplier, so
it must permute the four blocks as well.

For contrast, the selftest cases have large groups and nauty finishes instantly without any of
this: Paley I at order 660 has 2640 vertices — nearly H668's size — and returns
`2 · |PSL(2,659)|` in 0.2 s. Small groups, not large graphs, are the expensive case.

## Inspecting one matrix by hand

```bash
B=~/.cache/c999-target/release/had668
$B verify    ../evidence/H668.txt
$B normalize ../evidence/H668.txt --hash --out H668-canonical.pm
$B classify  ../evidence/H668.txt | tee classify-668.json
```

Read `pass` and `sha256_canonical_normalized` from the first, then `forms_found` and the
`gs_array` detail from the third. Adding `--with-aut --traces` attempts the automorphism group;
expect it not to finish at these orders.

## Gaps

- Classification is by direct block test in the given row/column order and after dephasing only.
  A matrix presented in a permuted order will not be recognised even if it has the form; the
  `cyclic_block_structure_from_aut` screen is the partial mitigation, and it is a screen. Full
  detection needs a search over the row/column permutations the automorphism group allows, which
  is not implemented.
- No equivalence testing between two Hadamard matrices. `dreadnaut` is already asked for a
  canonical labelling (`c`), so canonical-form comparison is a small addition if it is needed.
- The Paley I generator handles prime `q` only, not proper prime powers. Irrelevant at 668, where
  no Paley construction applies at all.
- Williamson and Goethals–Seidel tests read the first block row and rebuild; they do not search
  over which block row to start from.
- The bordered test tries the border at the front and at the back only, not at arbitrary
  positions.
- `decode` is a stub pending the poster's encoding. It was never needed: the payload was decoded
  by `../decode.py`, written separately, and this crate reads its `+`/`-` output directly.
- `|Aut|` is computed only for orders 668, 716 and 892. The 4-profile invariant costs `C(n,4)`,
  which is 28 s at n = 668 but roughly 35 minutes at n = 1964; the nine remaining orders were
  left unrun rather than spend hours. Nothing about them is claimed.
- `shift_automorphisms` and the multiplier search cover only maps that act the same way on all
  four blocks. Order 892 has an automorphism outside both, so these are a proved lower bound,
  not the whole group.
- The `gs_array` border widths tried are 0, 4, 12, 20 and 28 — the ones these matrices use. A
  different border width needs that list extended.
- For the three block-circulant super-block orders the generalized transpose is detected and
  reported but not identified: the crate confirms one consistent operation exists without naming
  it as the per-group block reversal the decoder describes.
