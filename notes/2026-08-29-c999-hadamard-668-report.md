# C999 — explaining the order-668 Hadamard matrix

**Lane**: `gem-mining`. **Date**: 2026-08-29 (fetches and literature checks 2026-08-30 UTC).
**Status**: Part 1 complete. Part 2 (theorem-guided search above order 2000) was declined by the
user and is not started; its preparation survey stands as prep only.

Deliverable directory: `notes/2026-08-29-c999-hadamard-668/`, with the technical account in that
directory's `README.md`, the verification crate in `verify/`, and the per-order records in
`certificate/`. This file is the explanatory note the task asked for, and the place where the
lifecycle obligations (certificate table, replay, literature record, mystery ledger) are
discharged.

## 1. Goal

Existence of a Hadamard matrix of order 668 was settled externally on 2026-08-12 by Levent Alpöge
with collaborators, announced on X as an encoded `+`/`-` payload plus an obfuscated shell decoder,
with the search method undisclosed and no preprint or repository. The task was to obtain and decode
the payload, verify orthogonality with a replayable certificate and a Lean-checked proof, compute
the automorphism group, classify the construction against the standard families, and cross-check it
against this lane's Legendre-pair multiplier census (C736–C741). No priority claim on existence is
made or intended.

Named in the announcement thread as collaborators: Alpöge, Voinov (`@tehwalris`),
Reynolds-Haertle, and Claude. The construction method itself was not disclosed.

## 2. What was obtained

The payload was retrieved from the fxtwitter and vxtwitter mirrors of the announcement post. The
two mirrors returned **byte-identical** payloads (sha256
`5b5fe8fa42f0d6a8b4e4c9926726d82a6aab8e1070c1ae4d1b430c1277e58db4`, 23,828 characters over
`{+,-}`), which is the cross-check that neither mirror truncated or re-encoded it. Fetch
provenance and hashes for every retrieved artifact are in
`notes/2026-08-29-c999-hadamard-668/evidence/provenance.md`.

**The poster's decoder was never executed.** Its `sed`/`sh` one-liner was undone statically by
applying its three substitutions in Python, the resulting script was read, and the decoding was
then re-implemented from scratch as `decode.py`, which shares no code, no shell, and no `sed` with
the original and writes only inside the deliverable directory. The de-obfuscated script is kept as
reference material marked DO NOT RUN.

The payload carries **twelve orders**: 668, 716, 892, 1132, 1244, 1388, 1436, 1676, 1772, 1916,
1948, 1964. Its record header is a 192-bit table of twelve 16-bit records (a 3-bit family tag and a
13-bit data length), and the twelve records consume exactly 23,828 characters with nothing left
over — the accounting that confirms the header was read correctly. All twelve decoded matrices
satisfy `H·Hᵀ = nI` **exactly**: checked in `i64` in the Rust crate `verify/` (`max |(H Hᵀ)_ij| = 0`
off the diagonal) and independently replayed with a numpy `int32` matrix product from the decoding
side. Two implementations, two arithmetic paths, two parsers, same bytes pinned by
`certificate/SHA256SUMS`.

**There is no seed and no generator in the payload.** Every character is a literal matrix entry of
a first row or a border; the compression is purely structural, 23,828 characters expanding to about
21.4 million matrix entries because the array is applied to first rows only. For order 668 the
information content is exactly **664 bits**. Whatever search produced the sequences left no trace
in what was posted.

## 3. The structure of order 668

Order 668 is a **bordered Goethals–Seidel array with a border of width 4** over four ±1 circulants
of length 166, with one deviation from the textbook array: the six blocks of the lower-right 3×3
corner carry an extra cyclic shift by `e = 2`, so block `(k,l)` there is back-circulant with
entries `x(i+j+2)` rather than `x(i+j)`. The four sequences `A,B,C,D` have row sums `(2,0,0,0)` and
satisfy `Σᵢ PAF_i(s) = −4` at every nonzero shift `s` (and `Σᵢ (row sum_i)² = 4`), which is exactly
the hypothesis the bordered array needs. The extracted corner is `-++-`, `+-+-`, `++--`, `----`;
the border-row block signs are `---+`, `--+-`, `-+--`, `+---`; the slab column prefixes are `+++-`,
`--+-`, `-+--`, `+---`. All of this was recovered from the matrix entries by the `classify`
subcommand, independently of the decoder's account of the script, and the two agree.

The same bordered shape with circulant blocks appears at orders 716 (length 178), 1676 (418) and
1772 (442). Orders 892, 1132, 1244, 1948 and 1964 are the **plain Goethals–Seidel array** over four
circulants of prime length 223, 283, 311, 487, 491 with `Σᵢ PAF_i(s) = 0` and
`Σᵢ (row sum_i)² = n`. Orders 1388, 1436 and 1916 are bordered Goethals–Seidel over
**block-circulant super-blocks** (24 blocks of length 57 with border 20; 128 of length 11 with
border 28; 16 of length 119 with border 12), where the array's transposition is a generalized
operation — per-group block reversal — rather than the matrix transpose.

None of the four order-668 sequences is multiplier-invariant or symmetric: every unit of `Z_166`
was tested, in both the sign and the shift sense, and nothing fixes any of them. The construction
therefore carries no visible symmetry reduction, which is the substance of the observation in the
mystery ledger below.

## 4. The orthogonality lemma

The general statement, formalized as `HadamardMatrices.borderedArray_mul_transpose`, is this: given
four sequences `A, B, C, D : ZMod m → ℤ` with every value `±1`, an inner shift parameter `e`, and
the two arithmetic hypotheses that the sum of the four periodic autocorrelations equals `−4` at
every nonzero shift and that the sum of the squared row sums equals 4, the bordered Goethals–Seidel
array built from them — the four constant border rows with their fixed 4×4 corner, and the four
slabs `[A, BR, CR, DR]`, `[−BR, A, D^op R, −C^op R]`, `[−CR, −D^op R, A, B^op R]`,
`[−DR, C^op R, −B^op R, A]` with the back-diagonal `R` and the inner shift `e` in the lower-right
corner — satisfies `M Mᵀ = (4m+4)·I`. The proof is ordinary algebra: sums over `ZMod m` reindexed by
translations and reflections, plus `decide` over the 4×4 sign tables. The shift `e` cancels
identically in every cross term, so the classical array is the case `e = 0` and order 668 is the
case `e = 2`; carrying `e` as a free parameter costs nothing and is what makes the posted matrix an
instance of a stated theorem rather than a one-off.

## 5. Automorphism group

`|Aut(H668)| = 4`: the central sign involution `(−I,−I)` times the half-shift by 83, and nothing
else. Modulo the centre the Hadamard automorphism group has order 2. The lower bound is proved
without any solver, by the dephasing test — dephasing is a complete invariant for the row/column
sign group, so a listed shift is a proved automorphism and an omitted one is proved not to be. The
matching upper bound came from nauty and, independently, from bliss 0.73 on the same graph and
colouring (0.30 s, same two generators).

Reaching that upper bound at all required a real vertex invariant, and which invariant can work is
forced by orthogonality: on a Hadamard matrix every pair statistic is constant (`n/2` agreements)
and every triple statistic is constant (`n/4`), and odd-order products are not monomial invariants
at all, because three entries pick up `ε_c³ = ε_c` under a column sign flip. **Quadruples are the
first level that is both invariant and non-constant**, via
`J(i,j,k,l) = Σ_c H_ic H_jc H_kc H_lc = n − 2·popcount(b_i ⊕ b_j ⊕ b_k ⊕ b_l)`. Colouring each row
by the multiset `{ |J(i,j,k,l)| : j<k<l }` splits the 668 rows into 336 classes — four singletons
(the border rows) and 332 pairs (the half-shift orbits) — and dense nauty then finishes in about
four seconds, against no progress at all in twenty minutes without it and a Traces run that burned
a 900-second budget without clearing its first level.

Order 716 also has `|Aut| = 4`. **Order 892 has `|Aut| = 6`**, from an element of order 3 fixing one
position in each of the four circulant blocks; it is neither a common block shift nor a common
block multiplier, so it must permute the four blocks as well. Orders at and above 1132 were not
computed: the quadruple invariant costs `C(n,4)`, which is 28 seconds at `n = 668` but roughly 35
minutes at `n = 1964`, and nothing is claimed about them.

## 6. Cross-check against the C736–C741 census

**Order 668 is outside the Legendre-pair route this lane has been studying.** C736–C741 concern
Legendre pairs of length 333, which would produce order 668 as a bordered *two-circulant* matrix
with a 2-row border and two circulants of order 333. The decoded matrix is a bordered
*Goethals–Seidel* array with a 4-row border and four circulants of order 166. The Legendre-pair
test was run explicitly, as given and after dephasing, and does not fire. Consequently: **no census
exclusion is contradicted, no residual survivor (IDs 0, 1, 3, 4, 5) is realised, and the existence
question for a Legendre pair of length 333 remains open.** Order 668 was settled by a construction
that never passes through that route, so C741's remaining 108 orbit representatives are neither
helped nor harmed by it.

Separately, C1000's feasibility spike (`notes/2026-08-29-c1000-feasibility-spike.md`) records that
`333 = 37 · 3²` has the form `p q²` and therefore falls inside the length family of Kotsireas,
Gallardo-Cava, Gomez and Gomez-Perez, "On the search of binary Legendre pairs of length `pq²`",
Journal of Symbolic Computation, July 2026 — cited here exactly as that spike records it, at the
read depth it records (`abstract/metadata only`; the full text could not be retrieved from this
host). That is a live pre-emption exposure for any future length-333 census work, not a finding of
this task.

## 7. Lean coverage

Order 668 is proved orthogonal in Lean, from the 664 sequence characters rather than from the
446,224 matrix entries; Lean builds the matrix itself, so coverage is complete. The library is
`lean/HadamardMatrices/`, committed in `3ca9d0ad9`.

Terminal declaration:

```
HadamardMatrices.Order668.matrixOrder668_mul_transpose :
  matrixOrder668 * matrixOrder668ᵀ = (668 : ℤ) • (1 : Matrix (ArrayIndex 166) (ArrayIndex 166) ℤ)
```

together with `matrixOrder668_entry_sq` (every entry is ±1), `card_arrayIndex_order668` (the index
set has 668 elements) and `reindex_mul_transpose` (the same identity over `Fin 668` along any
bijection). Those four statements together say `matrixOrder668` is a Hadamard matrix of order 668.
The general lemma is `HadamardMatrices.borderedArray_mul_transpose`, stated in §4 above.

Every one of these depends on axioms `[propext, Classical.choice, Quot.sound]` and nothing else:
no `sorryAx`, and no `Lean.ofReduceBool`, which is what a `native_decide` step would have
introduced. The two finite inputs at `m = 166` — the ±1 values with the row sums, and the 165
nonzero-shift autocorrelation identities — are discharged by **kernel reduction**, not native
evaluation. To keep the autocorrelation check inside the kernel's budget the sequences are also
presented as the binary digits of a single natural number, and `sequenceA_eq_packed` with its three
siblings checks entry by entry that the packed and list presentations agree, so the packed form
carries no independent data.

## 8. External order 2060, and the smallest open order

A gist posted 2026-08-23 by GitHub user `schneiderlo` claims a Hadamard matrix of order 2060 —
which was the smallest order left open after the August 2026 sweep. It was fetched and checked
here (commit `e4d2be925`). **The claim holds**: `max |(H Hᵀ)_ij| = 0` off the diagonal in exact
`i64`, all entries ±1, order 2060.

Its structure is a plain Goethals–Seidel array over four blocks of order `515 = 5 · 103`, disguised
by a CRT-interleaved index order: writing `Z_515 ≅ Z_5 × Z_103`, the file index is
`f = 5·(t mod 103) + (t mod 5)`. After relabelling by the ring index `t`, block `A` is a genuine
circulant of order 515 and `B, C, D` are back-circulant after the column multiplier `104 ≡ (−1, 1)`
in CRT coordinates — the array's reversal acts in one CRT factor only, which is why the plain
back-diagonal test misses it. Row sums are `(−17, 5, 39, 15)` with `Σ (row sum)² = 2060`, and
`Σᵢ PAF_i(s) = 0` at every nonzero shift, exactly. The automorphism group contains the four `Z_5`
translations and the multiplier 104 that inverts them, a dihedral group of order 10 on rows, so
`|Aut(graph)| ≥ 20` — a proved lower bound; the exact group was not computed, because the
quadruple invariant costs `C(2060,4) ≈ 7.5 × 10¹¹` XOR-popcounts, about 2.1 hours at the measured
rate of the `n = 668` run.

**With 2060 closed, the smallest open admissible order is 2092 = 4 · 523.** The preparation survey
`notes/2026-08-29-c999-open-orders-above-2000.md` has been updated at §2 to say so.

## 9. Certificate bundle

All paths are relative to `notes/2026-08-29-c999-hadamard-668/`. The authoritative hash list is
`certificate/SHA256SUMS`, which pins every `certificate/H<n>.json` and every source matrix file;
check it with `sha256sum -c certificate/SHA256SUMS` run from that directory.

| path | what it pins |
|---|---|
| `evidence/provenance.md`            | fetch URLs, times, and sha256 of every retrieved artifact; the two-mirror byte-identity cross-check |
| `evidence/payload.txt`              | the verbatim payload, sha256 `5b5fe8fa42f0d6a8b4e4c9926726d82a6aab8e1070c1ae4d1b430c1277e58db4` |
| `evidence/decoder-raw.txt`          | the verbatim obfuscated decoder as posted |
| `evidence/decoder-deobfuscated.sh`  | the decoder after the three static substitutions; reference only, marked DO NOT RUN |
| `decode.py`                         | the independent re-implementation, sha256 `78ae0eb9cd43cdda8e68befef49e2ca383635f5eafe108aca08478a8cdca359b` |
| `evidence/H<order>.txt`             | the twelve decoded matrices; `H668.txt` is sha256 `bdeb5059d77e2703211082627b60441b8c888c928a55cc6f295e011941a387b0` |
| `external/H2060.txt`                | the fetched external matrix, sha256 `c7a145d86210740dd3f8ea21ca896a54d6916007a042638f17c8c47f097200f7` |
| `external/provenance.md`            | gist id, revision, fetch time and hash for that file |
| `certificate/H<n>.json`             | per-order record: order, source and both canonical hashes, exact `max |(H Hᵀ)_ij|`, row-sum multiset, full classification ledger, automorphism result |
| `certificate/SHA256SUMS`            | hashes of all of the above matrices and records |
| `verify/`                           | the `had668` crate: `verify`, `normalize`, `classify`, `autgroup`, `profile`, `certify`, `selftest` |
| `extract_gs_sequences.py`           | extracts the four length-166 sequences and rebuilds the whole matrix from them, asserting entry-for-entry equality |

The per-order structural summary (family, block order, sub-block length, PAF sum, block row sums,
shift automorphism) is the table in `certificate/README.md`; the sha256 of each decoded matrix file
is the table in `README.md` under "Orders decoded".

## 10. Replay

Decode and independently check the twelve matrices:

```bash
cd notes/2026-08-29-c999-hadamard-668
uv run --no-project python3 decode.py
uv run --no-project --with numpy python3 -c '
import sys, numpy as np
for p in sys.argv[1:]:
    r = open(p).read().split(); n = len(r)
    M = np.array([[1 if c=="+" else -1 for c in x] for x in r], dtype=np.int32)
    print(p, n, int(np.abs(M@M.T - n*np.eye(n, dtype=np.int32)).max()))
' evidence/H*.txt
```

Rebuild the certificate bundle:

```bash
cd notes/2026-08-29-c999-hadamard-668
CARGO_TARGET_DIR=~/.cache/c999-target cargo build --release --manifest-path verify/Cargo.toml
~/.cache/c999-target/release/had668 certify evidence/H*.txt \
    --outdir certificate --workdir /tmp/persistent/tavis/c999-work
sha256sum certificate/H*.json evidence/H*.txt > certificate/SHA256SUMS
```

Extract the sequences, and check the automorphism group of order 668:

```bash
cd notes/2026-08-29-c999-hadamard-668
uv run --no-project python3 extract_gs_sequences.py
export DREADNAUT=$(nix build nixpkgs#nauty --no-link --print-out-paths)/bin/dreadnaut
~/.cache/c999-target/release/had668 autgroup evidence/H668.txt --profile-colour
```

Lean:

```bash
cd /home/tavis/src/othello
lean/scripts/lean-build-queue.py build HadamardMatrices --cores 20-23
lean/scripts/guarded-lean HadamardMatrices/AxiomAudit.lean
```

The `verify/README.md` carries the environment details: `/tmp/persistent` is mounted `noexec` so
the cargo target directory lives under `$HOME`, nauty is resolved through `$DREADNAUT` or a
`nix shell` fallback, and rayon is pinned with `RAYON_NUM_THREADS` when the host is busy.

## 11. Literature-audit record

**No novelty or priority claim is made here.** Existence at order 668 is the announcers'; this task
claims only the decoding, the verification, the structural identification, the automorphism
computation, and the Lean proof. What follows records the search behind one weaker statement: that
the structural and automorphism facts in §3 and §5 were **not found stated anywhere in the searched
domain**, which is a coverage statement and not a novelty verdict.

Sources consulted, each with its read depth:

| source | read depth | record |
|---|---|---|
| Alpöge announcement post, `x.com/__alpoge__/status/2087504785952182273` | `full text` (payload and post text) | retrieved via the fxtwitter and vxtwitter API mirrors, byte-identical; hashes in `evidence/provenance.md` |
| the two announcement replies (decoder, and a short follow-up) | `full text` | same mirrors, hashes in `evidence/provenance.md` |
| the thread as rendered by threadreaderapp | `partial` — used only to discover the two reply IDs | `tr.html`, sha256 `5166dfd3ae4d4604d8e48f961dac164912c7daf9a393777c18968acc43a2a0a4` |
| `schneiderlo` gist for order 2060 | `full text` (the matrix file and the gist metadata) | raw URL and API metadata, hashes in `external/provenance.md` |
| Epoch AI's Hadamard-problem status page | `full text` | consulted for the provisional marking of the 668 claim |
| Kotsireas, Gallardo-Cava, Gomez, Gomez-Perez, "On the search of binary Legendre pairs of length `pq²`", J. Symbolic Computation, July 2026 | `abstract/metadata only` | as recorded in `notes/2026-08-29-c1000-feasibility-spike.md`; ScienceDirect returned HTTP 403 from this host, Crossref and OpenAlex return a null abstract, Unpaywall lists no PDF |

**Coverage.** Searched and found nothing: arXiv, GitHub (code and gists), Hacker News, the Epoch AI
page, and the threadreader rendering of the announcement thread carry no preprint, repository,
method description, structural analysis, or automorphism statement for the order-668 matrix, as of
2026-08-30. **Could not access**, and therefore licensing nothing: the replies on X beyond the two
retrieved by ID could not be enumerated (the mirrors expose a post by ID, not a reply tree), and
the Kotsireas et al. full text. MathSciNet is NOT COVERED — it requires institutional
authentication, unreachable from this session. The announcers state the method is undisclosed, so
the absence of a method description is asserted by them rather than inferred by us.

**Attribution.** The identification of the four-slab pattern as the Goethals–Seidel array, of
"reverse then rotate left" with the back-diagonal `R`, of the per-block reversal with the circulant
transpose, and of the super-block families as Goethals–Seidel over T-matrices, are all **our
inferences** — the poster's script contains no such names. The T-matrix reading in particular was
not verified against the T-matrix disjointness conditions and is marked as unverified in
`README.md`.

## 12. Mystery ledger

Three genuine unexplained features remain. None is allocated work; each is recorded with what would
settle it. The `ej`+`tt` closeout pass settled the fourth candidate — whether the decoded matrices
might secretly realise a length-333 Legendre pair — negatively and completely (§6), so it is not
listed here.

**(a) The order-3 automorphism of order 892.** Orders 668 and 716 have automorphism group of order
4, exactly the centre times the half-shift, which is what parity forces for a bordered array with
even block length: diagonal blocks are circulant so row shift equals column shift, off-diagonal
blocks are back-circulant so row shift equals minus column shift, and a common shift then needs
`2s ≡ 0 (mod m)`. Order 892 instead has group of order 6, with an element of order 3 that fixes one
position in each of the four circulant blocks. It is neither a common block shift nor a common
block multiplier, so it must permute the four blocks themselves — and the search implemented here
covers only maps acting identically on all four blocks, so the tool proves the element exists
without describing it. **What would settle it**: extract the order-3 generator from the nauty
output at `certificate/H892.json`, read its action on the four blocks directly, and check whether
it is a block permutation composed with a multiplier of `Z_223`. That is a small computation with
the existing crate, not a research programme. Whether it means the 892 sequences were found by a
symmetry-reduced search — while the 668 sequences demonstrably were not — is the question worth the
answer.

**(b) The inner shift `e = 2`.** The lower-right 3×3 corner of the 668 array carries an extra
cyclic shift by 2. It cancels identically in every cross term, so it is not needed for
orthogonality: the classical array at `e = 0` over the same four sequences would work equally well.
Two readings are open. It may be an artifact of how the poster's `sed` program advances its
rotation state, in which case it says nothing about the mathematics; or the search may have been
run in a parameterization where `e` was free, in which case the whole family `e ∈ Z_m` was being
searched at once and `e = 2` is where the solution happened to sit. **What would settle it**: check
whether the same `e = 2` appears at 716, 1676 and 1772 — if the shift is constant across all four
bordered instances it is almost certainly the generator's fixed convention, and if it varies it was
a searched parameter. The crate detects the operation but does not currently report its shift
value, so this needs one small addition to `classify`. The Lean development already carries `e` as
a free parameter, so either answer leaves the formalization untouched.

**(c) Order 2060's CRT structure against order 668's rigidity.** The externally posted order-2060
matrix has four blocks of order `515 = 5 · 103` in a CRT-interleaved index order with a genuine
multiplier `104 ≡ (−1,1)` acting in one factor, giving a proved dihedral automorphism group of
order 10 on rows. The order-668 sequences, by contrast, are invariant under no unit of `Z_166` at
all, in either the sign or the shift sense — the search that found them exploited no symmetry
whatever. These are two different search philosophies reaching two different orders in the same
fortnight: one riding a multiplier group to cut the search space, one apparently brute-forcing a
664-bit space with no reduction. **What would settle it**: nothing available from the artifacts
alone, because neither party disclosed a method. The observable proxy is the remaining ten decoded
orders — computing whether the 1132, 1244, 1948 and 1964 sequences carry multiplier invariance
(cheap; the multiplier scan already exists and those are prime block lengths) would say whether the
Alpöge search is symmetry-free across the board or only at 668. That is the single cheapest
discriminator between "they found a new search method" and "they had enough compute".

## 13. Vibe

Fully closed and well-evidenced: two independent orthogonality checks, an exact automorphism group
with two independent solvers, a Lean proof on the standard three axioms, and a clean negative on
the census route. The mild disappointment is that the payload carries no method — the twelve
matrices are literal data, so nothing about *how* they were found transfers, which is exactly why
Part 2 had no theorem to be guided by.
