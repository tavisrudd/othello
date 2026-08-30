# C999 — de-obfuscating and re-implementing the Alpöge Hadamard payload

Date: 2026-08-29. Scope: the `+`/`-` payload posted with the order-668 Hadamard
announcement, and the obfuscated shell decoder posted as its reply.

**The poster's script was never executed here.** Its `sed`/`sh` one-liner was
undone statically in Python, read, and then re-implemented from scratch in
`decode.py`. The two are independent: `decode.py` shares no code, no shell, and
no `sed` with the original, and it never writes outside this directory.

## Replay

```
cd notes/2026-08-29-c999-hadamard-668
uv run --no-project python3 decode.py
```

Standard library only, deterministic, no network. Runtime is a few minutes,
dominated by string building for the four largest orders. It reads
`evidence/payload.txt` and writes `evidence/H<order>.txt` (one row of `+`/`-`
per line) for each of the twelve orders, printing the table reproduced below.

Independent orthogonality check of the written files (not part of `decode.py`):

```
uv run --no-project --with numpy python3 -c '
import sys, numpy as np
for p in sys.argv[1:]:
    r = open(p).read().split(); n = len(r)
    M = np.array([[1 if c=="+" else -1 for c in x] for x in r], dtype=np.int32)
    print(p, n, int(np.abs(M@M.T - n*np.eye(n, dtype=np.int32)).max()))
' evidence/H*.txt
```

Result on 2026-08-29: `max |H Hᵀ − nI| = 0` for all twelve files. Every decoded
matrix is a genuine Hadamard matrix. For order 668 specifically, `decode.py`'s
own cheap sampled check reports 400/400 sampled row pairs orthogonal, and the
full check above gives `max |H Hᵀ − 668·I| = 0` on `evidence/H668.txt`.

## Files

| file | what it is |
|---|---|
| `evidence/payload.txt`          | verbatim payload, 23,828 characters over `{+,-}`, no newline |
| `evidence/decoder-raw.txt`      | verbatim reply containing the obfuscated decoder |
| `evidence/decoder-deobfuscated.sh` | the decoder after the three static substitutions; marked DO NOT RUN, reference only |
| `evidence/provenance.md`        | fetch provenance and SHA-256 of every file here |
| `decode.py`                     | the independent re-implementation |
| `evidence/H<order>.txt`         | decoded matrices, one row of `+`/`-` per line |

## What the poster's decoder does, step by step

Everything in this section is **read off the script**, not inferred.

1. **Outer wrapper.** The reply is one `sed` command whose here-document holds an
   enciphered shell script. The cipher is three substitutions in order:
   `M` → backslash, `I` → forward slash, then an 81-character `y///`
   transliteration. Applying them yields `evidence/decoder-deobfuscated.sh`,
   which the poster then runs with `sh /tmp/r $*`, passing the payload file as
   the argument.

2. **Payload intake.** `W=$(sed 'H;$!d;x;s/[^-+]//g' $*)` slurps the argument
   files and deletes every character that is not `+` or `-`. A helper `c n`
   bites the next `n` characters off `W` into `x`.

3. **Record header.** The script carries the literal string
   `bnghbndhdmiddljddlcdhkkhjkhpbjhhbjbhfiipdigddifd`. A `sed` table maps each
   letter to four sign characters (`a` → `++++`, …, `p` → `----`), giving 192
   bits. These are consumed as twelve 16-bit records: a 3-bit family tag
   followed by a 13-bit big-endian length `n`. The tags select shell functions
   `h` (`+++`), `g` (`++-`), `w` (`+-+`), `v` (`+--`), `u` (`-++`).

4. **Per record.** `c n` takes `n` payload characters as the record's *data*.
   Families `w`, `v`, `u` then take a further fixed *border* allowance
   (336 + 4·48, 880 + 4·120, 1680 + 4·896 characters respectively). The twelve
   records consume 16,676 + 528 + 1,360 + 5,264 = 23,828 characters — exactly
   the payload length, with nothing left over. That accounting is the first
   confirmation that the record header was read correctly.

5. **Matrix emission.** Each family writes a small `sed` program to `/tmp/p` and
   runs it on the record's data. The programs are self-modifying in the sense
   that the widths of their fixed-length patterns are pasted in from `$n` by the
   shell; single letters (`A`, `K`, `Z`, `Q`, `W`, `~`, `M`, `r`, `l`, …) are
   macros expanded by a final chain of `s///g` commands. The program builds one
   row in the pattern space, prints it with `P`, applies a cyclic rotation to
   each block, and loops until the row returns to its starting value — so one
   pass emits exactly `m` rows, where `m` is the block length. Negated and
   block-reversed copies of the data are parked in the hold space and pulled
   back with `g`/`G` to start each new block of rows.

## The construction

Also read off the script, expressed in ordinary notation. For a length-`m` row
`X` write `neg X` for entrywise negation, `rev X` for reversal, `rot_r X` /
`rot_l X` for the cyclic shifts, and `X'` for the *circulant transpose*
`X'[i] = X[(−i) mod m]` (which the script computes with the comma/semicolon
reversal loop `:8`).

### Families `g` and `h` — the Goethals–Seidel array, order 4m and 4m+4

The `n` data characters are four blocks `A B C D`, each the first row of a
circulant of order `m = n/4`. Nine of the twelve matrices come from here.

`g` emits `4m` rows in four slabs of `m`. Slab `k` starts from a seed row of
four blocks and rotates each block once per row, in direction `r` (right) or
`l` (left):

| slab | seed blocks | rotation directions |
|---|---|---|
| 0 | `A`,  `rev B`,  `rev C`,  `rev D`               | `r l l l` |
| 1 | `neg rev B`,  `A`,  `rot_l D`,  `rot_l neg C`   | `l r l l` |
| 2 | `neg rev C`,  `rot_l neg D`,  `A`,  `rot_l B`   | `l l r l` |
| 3 | `neg rev D`,  `rot_l C`,  `rot_l neg B`,  `A`   | `l l l r` |

A block that is reversed and then rotated left `i` times is the same as the
block rotated right `i` times and then reversed, so slab 0 is
`[A, BR, CR, DR]` with `R` the back-diagonal permutation, and the other slabs
are the remaining three rows of the Goethals–Seidel array. The `rot_l` inside
seeds 1–3 only shifts which row of a slab comes first.

`h` is the same array with a border: four extra rows of constant blocks
(`e` all-plus, `f` all-minus, `m` wide) prepended, and a fixed 4-character
prefix on every body row.

```
row  1     -++-  f f f e
row  2     +-+-  f f e f
row  3     ++--  f e f f
row  4     ----  e f f f
slab 0     +++-  <four rotating blocks>
slab 1     --+-  ...
slab 2     -+--  ...
slab 3     +---  ...
```

Order is `4m + 4`. The four border rows are pairwise orthogonal on their own,
and the border prefixes `+++-`, `--+-`, `-+--`, `+---` are what make the body
rows orthogonal to them.

### Families `w`, `v`, `u` — the same array over block-circulant super-blocks

These three use many short circulants instead of four long ones. Let `nb` be the
block count, `m = n/nb` the block length, `bw` the border width, and
`nit` the number of outer passes per super-block row:

| family | order | `nb` | `m` | `bw` | `nit` | check |
|---|---|---|---|---|---|---|
| `w` | 1916 | 16  | 119 | 12 | 4  | 16·119 + 12 = 1916 |
| `v` | 1388 | 24  | 57  | 20 | 6  | 24·57 + 20 = 1388 |
| `u` | 1436 | 128 | 11  | 28 | 32 | 128·11 + 28 = 1436 |

The `nb` blocks are grouped into four super-blocks of `nb/4` blocks each. The
four slabs use exactly the same Goethals–Seidel recipe as above, at super-block
granularity, with `X'` now meaning "circulant-transpose every block, then, inside
each group of `grp` consecutive blocks, keep the first and reverse the rest"
(`grp` = 1, 3, 8 for `w`, `v`, `u`).

Within a slab the script runs `nit` outer passes. Each pass prepends a fresh
`bw`-character border prefix, emits `m` rows by rotating every block once per
row (all blocks of a super-block share one direction, taken from the same
`rlll` / `lrll` / `llrl` / `lllr` table), and then applies a fixed permutation of
the `nb` blocks before the next pass:

- `w`: after passes 1 and 3, swap adjacent blocks pairwise; after pass 2, reverse
  each group of four.
- `v`: after every pass, cyclically shift each group of three blocks left, twice
  for the current slab's own super-block and once everywhere; after pass 3, swap
  the two triples inside each super-block.
- `u`: after every pass, cyclically shift the current super-block's octets right
  by two and every octet left by one; after passes 8, 16, 24 swap adjacent
  octets, and after pass 16 additionally swap adjacent 16-block groups.

Rows per slab are `nit·m`, and `4·nit·m + bw` is the order in every case.

The border is `bw` rows, each stored as `bw` literal characters plus one sign per
block; each sign expands to a constant block of length `m`. For `u` the stored
signs are only 32, and the `sed` generator quadruples each adjacent pair
(`s/\\.\\./&&&&/g` acting on the `\1`/`\2` backreference tokens) to reach 128.

### What is inferred rather than read off

- Naming the four-slab pattern the **Goethals–Seidel array**, and identifying
  "reverse then rotate left" with the back-diagonal `R` and the per-block
  reversal with the circulant transpose. The script contains no such names;
  the identification is mine, and it is what makes the row recipes intelligible.
- For `g`/`h`, the data `A B C D` must be four ±1 sequences of length `m` whose
  periodic autocorrelations sum to a constant (equivalently, four supplementary
  difference sets on `Z_m`); that is the standard hypothesis the Goethals–Seidel
  array needs, and the bordered variant needs the extra row-sum condition. The
  script neither states nor checks this.
- For `w`/`v`/`u`, `N/4` is 479, 347 and 359, and in each case
  `N/4 = (nb/4)·m + bw/4` with `bw/4` = 3, 5, 7. The natural reading is a
  Goethals–Seidel array over four **T-matrices of order `N/4`**, each T-matrix
  being block-circulant from `nb/4` short circulants plus a small border. I have
  not verified the T-matrix disjointness conditions, and the script gives no
  hint of provenance for the sequences.
- **There is no seed and no generator in the payload.** Every `+`/`-` character
  is a literal matrix entry of a first row or a border. The compression is
  purely structural: 23,828 characters expand to about 21.4 million matrix
  entries because the array construction is applied to first rows only. Whatever
  search produced the sequences left no trace in what was posted.

## Orders decoded

SHA-256 is of the written `evidence/H<order>.txt` (rows of `+`/`-`, one per
line, trailing newline).

| order | family | structure | fixed multiplier group | sha256 of `H<order>.txt` |
|---|---|---|---|---|
| 668 | `h` | 4 circulants of length 166, 4-row border   | trivial | `bdeb5059d77e2703211082627b60441b8c888c928a55cc6f295e011941a387b0` |
| 716 | `h` | 4 circulants of length 178, 4-row border   | trivial | `3adcb1bb2884467d9e34069a3b32950728adabcdb8b35a4503d20c3312664ee6` |
| 892 | `g` | 4 circulants of length 223                 | order 3, `<39>` | `e77fc79ab287f5f5ba5bbdc10191bdc7593839052fe1015c1fb6a2e974ab54de` |
| 1132 | `g` | 4 circulants of length 283                 | order 3, `<44>` | `7d1c1e892149e90330d58bb0cf9ef2c888078df1b35fb55f8724d580ebf7b743` |
| 1244 | `g` | 4 circulants of length 311                 | order 5, `<6>` | `4cb747cf511eba1f203582b5121bdf6ab02671133e45579c1d023add8b2da143` |
| 1388 | `v` | 24 circulants of length 57, 20-col border  | n/a (blocks not circulant) | `a6b92584eb803b87026709d64fe892dec8f7182a120e13de9edd3065cf05bf0b` |
| 1436 | `u` | 128 circulants of length 11, 28-col border | n/a (blocks not circulant) | `e4d745a4d44f39a5671f9cd86f5c1d0aef93504dcfb2e253451cadc9e4086728` |
| 1676 | `h` | 4 circulants of length 418, 4-row border   | order 15, `<49>` | `8e919c2bdb4d30c34817eb5650d2dd3d82d7c6504feccd96c5ca22a2191cdb99` |
| 1772 | `h` | 4 circulants of length 442, 4-row border   | order 12, `<55>` | `1852e951db69c44eb95b37ed741c3ff2e29691267eaf872d6a9da3a977236ba2` |
| 1916 | `w` | 16 circulants of length 119, 12-col border | n/a (blocks not circulant) | `be2073eeaa5399cfe104023829d2c6770b49dd2f07bf6347203f1cbd75577ae9` |
| 1948 | `g` | 4 circulants of length 487                 | order 9, `<41>` | `fddc841ebf951f6e17e939551d058ea5df046251ea065b5f6e7ee2fd8d0f62ce` |
| 1964 | `g` | 4 circulants of length 491                 | order 7, `<138>` | `740b907cd442f1b7fd40dcc31f2b3aae9794842da6dc579f98dac1d0d9e1493d` |

These are the twelve orders the poster claimed: 668, 716, 892, 1132, 1244, 1388,
1436, 1676, 1772, 1916, 1948, 1964. The record lengths in the header are the
*data* lengths, not the orders — 664 for order 668, 1904 for order 1916, and so
on — which is why a naive reading of the header appears to disagree with the
announcement by 4 to 28.

## Lean check

Order 668 is now proved orthogonal in Lean, from the 664 sequence characters
rather than from the 446,224 matrix entries. Lean builds the matrix itself, so
coverage is complete.

### Extracting the sequences

`extract_gs_sequences.py` reads `evidence/H668.txt`, reads off the 4×4 corner,
the border-row block signs, the four slab column prefixes, and the four
length-166 sequences `A`, `B`, `C`, `D`, then rebuilds the whole 668×668 matrix
from that data alone and asserts it equals the file entry for entry.

```bash
cd notes/2026-08-29-c999-hadamard-668
uv run --no-project python3 extract_gs_sequences.py
```

Result on 2026-08-29: exact match. The extracted data is

| item                           | value                                 |
|--------------------------------|---------------------------------------|
| corner (rows 0–3, columns 0–3) | `-++-`, `+-+-`, `++--`, `----`        |
| border-row block signs         | `---+`, `--+-`, `-+--`, `+---`        |
| slab column prefixes           | `+++-`, `--+-`, `-+--`, `+---`        |
| row sums of `A,B,C,D`          | 2, 0, 0, 0                            |
| `Σᵢ PAF_i(s)`                  | 664 at `s = 0`, `-4` at every `s ≠ 0` |

| sequence | sha256 of its `+`/`-` string                                       |
|----------|--------------------------------------------------------------------|
| `A`      | `ab43e555e591a019a21a6752c4683f9f1c99b9b8e58a27d00a8ae22559d419b5` |
| `B`      | `6dbc97cc55305d0f7cc155f64ff47655f6f806420cfe622dd949396e00e33e0c` |
| `C`      | `0d6b42c59bb5f4c39e1433ab5590c6c46549544bee2eb35103d45fe232420f4d` |
| `D`      | `b0b88655279088ddd1d8a3d539d9945d32073873bb07ba82a4463e5a67453b5f` |

The concatenation `A‖B‖C‖D` has sha256
`ffa2bf2b506ad9c51d3d1e26299c1932cfe961ef7e8f93b77385421684494611`.

The block structure differs in one respect from the textbook Goethals–Seidel
array: the six blocks of the lower-right 3×3 corner carry an extra cyclic shift
by 2, so block `(k,l)` there is back-circulant with entries `x(i+j+2)` instead of
`x(i+j)`. That is the operation the `had668` crate detects but does not name.
The shift is harmless — it cancels identically in every cross term — and the
Lean development carries it as a free parameter `e`, recovering the classical
array at `e = 0`.

### Lean modules

Under `lean/`, in the new library `HadamardMatrices`:

| module                                         | contents                                                                                                  |
|------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| `HadamardMatrices/BorderedGoethalsSeidel.lean` | the general array over four sequences of length `m` with inner shift `e`, and the orthogonality criterion |
| `HadamardMatrices/Order668/Sequences.lean`     | the four sequences as literals, their `±1` values and row sums                                            |
| `HadamardMatrices/Order668/Correlations.lean`  | the autocorrelation identity `Σᵢ PAF_i(s) = -4` for `s ≠ 0`                                               |
| `HadamardMatrices/Order668/Orthogonality.lean` | the terminal statements                                                                                   |
| `HadamardMatrices/AxiomAudit.lean`             | the `#print axioms` audit                                                                                 |

The Lean list literals in `Sequences.lean` were checked entry by entry against
the sequences printed by `extract_gs_sequences.py`; all four match.

The terminal declaration is

```
HadamardMatrices.Order668.matrixOrder668_mul_transpose :
  matrixOrder668 * matrixOrder668ᵀ = (668 : ℤ) • (1 : Matrix (ArrayIndex 166) (ArrayIndex 166) ℤ)
```

with `HadamardMatrices.Order668.matrixOrder668_entry_sq` (every entry is ±1),
`HadamardMatrices.Order668.card_arrayIndex_order668` (the index set has 668
elements), and `HadamardMatrices.Order668.reindex_mul_transpose` (the same
identity over `Fin 668`, along any bijection of the index set). Together these
say `matrixOrder668` is a Hadamard matrix of order 668.

### What is checked how

The orthogonality criterion `HadamardMatrices.borderedArray_mul_transpose` is ordinary
algebra: sums over `ZMod m` reindexed by translations and reflections, plus
`decide` over the 4×4 sign tables. The two finite inputs at `m = 166` — the ±1
values and row sums, and the 165 nonzero-shift autocorrelation identities, a sum
of 664 products each — are exhaustive checks discharged by **kernel reduction**,
not native evaluation. To keep the autocorrelation check inside the kernel's
budget the sequences are also presented as the binary digits of a single natural
number, so a lookup is one arithmetic operation instead of a list traversal;
`sequenceA_eq_packed` and its three siblings check entry by entry that the two
presentations agree, so the packed form carries no independent data.

Axiom output, verbatim:

```
'HadamardMatrices.Order668.matrixOrder668_mul_transpose' depends on axioms: [propext, Classical.choice, Quot.sound]
'HadamardMatrices.Order668.matrixOrder668_entry_sq' depends on axioms: [propext, Classical.choice, Quot.sound]
'HadamardMatrices.Order668.card_arrayIndex_order668' depends on axioms: [propext, Classical.choice, Quot.sound]
'HadamardMatrices.Order668.reindex_mul_transpose' depends on axioms: [propext, Classical.choice, Quot.sound]
'HadamardMatrices.borderedArray_mul_transpose' depends on axioms: [propext, Classical.choice, Quot.sound]
'HadamardMatrices.Order668.pafSum_eq_neg_four' depends on axioms: [propext, Classical.choice, Quot.sound]
```

Only Lean's three standard axioms: no `sorryAx`, and no `Lean.ofReduceBool`,
which is what a `native_decide` step would have introduced.

### Replay

```bash
cd /home/tavis/src/othello
lean/scripts/lean-build-queue.py build HadamardMatrices --cores 20-23
lean/scripts/guarded-lean HadamardMatrices/AxiomAudit.lean
```

The first command builds the library (about a minute, dominated by the
autocorrelation check; peak resident set about 5 GB on that module). The second
prints the axiom block above.

## Security note

The poster's script writes to `/tmp/r`, `/tmp/p` and `/tmp/q` and runs
`sh /tmp/r`. Nothing in it was executed, and no derived shell was executed. The
de-obfuscation was done by applying the three substitutions in Python; the
decoding was done by `decode.py`, which uses no subprocesses.
