# C260 — Independent cross-check of A₅ regular-template Node-Kayles nimbers

**Date:** 2026-07-17. Lane: `dihedral`. Task: C260.

**Status:** COMPLETE — all five A₅ rows independently reproduced and in agreement.
`(2,3,5)=1, (2,5,5)=1, (3,3,5)=0, (3,5,5)=0, (5,5,5)=0`. No disagreement anywhere.

Independent recomputation of the five A₅ free-orbit (regular template) Node-Kayles Grundy
values that currently rest on a single solver (`rust/scripts/nodekayles_cayley.rs`). Baseline
expectation (from `notes/2026-07-12-polyhedral-nk-templates.md` and manuscript Appendix A):

| G | class (pairwise product orders) | girth | expected 𝒢 |
|---|---|---|---:|
| A₅ | (2,3,5) | 4 | 1 |
| A₅ | (2,5,5) | 4 | 1 |
| A₅ | (3,3,5) | 6 | 0 |
| A₅ | (3,5,5) | 6 | 0 |
| A₅ | (5,5,5) | 9 | 0 |

S₄ classes (all four 𝒢=0) and V₄=(2,2,2)→K₄ 𝒢=1 used to validate the independent implementation.

## Method

**What is cross-checked.** The five A₅ free-orbit templates are the cubic Cayley graphs
`Cay(A₅, T)` for one generating involution triple `T` per pairwise-product-order signature.
Their Node-Kayles Grundy values previously rested on a single solver,
`rust/scripts/nodekayles_cayley.rs` (memoized Sprague–Grundy with connected-component xor and
canonical masks minimised over the `left-mult(G) × color-perm` automorphism group). This report
recomputes them with an independent solver and compares.

**Independence.**

- *Necessarily shared — the graph definition.* The template is `Cay(G,T)`: one vertex per group
  element, an edge `{g, g·t}` for each of the three involutions `t ∈ T`; the regular action is
  fixed-point-free so there are no deletions. This script rebuilds the graph in its own code
  (identical composition convention `(p·q)[i]=p[q[i]]`, identical element ordering and
  first-triple-per-signature selection, so the constructed graphs are the *same* graphs, not
  merely isomorphic ones), but the mathematical object being evaluated is shared by construction.
- *Independent — the solvers.* Two independent programs were written fresh for C260 (author: this
  task), neither derived from `rust/scripts/nodekayles_cayley.rs`:
  - **Independent Rust solver** (`.rs`) — memoized Sprague–Grundy with connected-component xor, but
    canonicalized by the orbit minimum under the **left-regular representation of G only** (|G|
    permutations), deliberately *omitting* the reference solver's color-permuting stabiliser of `T`.
    For every class whose signature has a repeated order (all A₅ except `(2,3,5)`) this is a
    strictly smaller canonicalization group, hence a genuinely different computation reaching more
    memo states. This solver covers all five A₅ classes (and the four S₄ classes).
  - **Genuinely-different-algorithm Python solver** (`.py`) — the memo is keyed on a
    **graph-isomorphism canonical certificate of each connected induced subposition**, computed by
    the BLISS engine inside `python-igraph`, using no ambient group structure at all. Node-Kayles
    Grundy value is a graph-isomorphism invariant, so this per-subgraph canonicalization is sound;
    it is the strongest independence but too slow at 60 vertices, so it validates the method on V₄
    and all four S₄ classes.

Each solver is an independent replay of the reference solver's finite computation; agreement of the
values is the cross-check. The A₅ cross-check is carried by the Rust solver (all five classes); the
Python BLISS solver independently corroborates the memoized-canonicalization method on the smaller
V₄/S₄ graphs.

**Conventions.** `sig` = sorted triple of the three pairwise product orders. Move at `v` deletes
the closed neighbourhood `N[v]`. Grundy of a disconnected position = XOR of component Grundies
(Sprague–Grundy sum). `V₄`=`(2,2,2)` is the size-4 template `Cay(V₄,·)=K₄`, used with its closed
form `𝒢(K₄)=1` as a solver sanity check; the four S₄ classes (`|G|=24`, all `𝒢=0`) validate the
solver on nontrivial graphs before the A₅ rows are trusted.

**Determinism.** Fixed enumeration, no randomness or seeds; `igraph.canonical_permutation()` is
deterministic; JSON output is sorted, timestamp-free, and host-path-free.

**Trusted boundary.** The check certifies exact Node-Kayles Grundy values of the constructed cubic
Cayley graphs, assuming (i) `python-igraph`'s BLISS canonical labelling is correct and (ii) the
graph construction reproduces the intended templates (independently corroborated by matching the
published girths 4/4/6/6/9 and the 60-vertex cubic shape). It does **not** re-derive the
orbit-template formula, the escape/residual analysis, or any claim beyond the free-orbit `t_K`
values.

## Results

**Cross-check verdict: all five A₅ rows agree with the reference solver.** The two value-one
classes are exactly the two girth-4 (order-2 pair) classes `(2,3,5)` and `(2,5,5)`; the three
girth-6/9 classes are all zero.

Independent Rust solver (`.rs`, left-multiplication-only canonicalization). Every graph is
60-vertex cubic (A₅) / 24-vertex cubic (S₄), independently recomputed as 90/36 edges and girth as
shown. `𝒢(ref)` is the value in `notes/2026-07-12-polyhedral-nk-templates.md` / manuscript
Appendix A.

| G | sig | girth | 𝒢 (this replay) | 𝒢 (ref) | agree | memo states (this) | memo states (reference solver) |
|---|---|---:|---:|---:|:--:|---:|---:|
| S₄ | (2,3,3) | 4 | 0 | 0 | ✓ | 158 | 101 |
| S₄ | (2,3,4) | 4 | 0 | 0 | ✓ | 159 | 159 |
| S₄ | (3,3,3) | 6 | 0 | 0 | ✓ | 330 | 79 |
| S₄ | (3,4,4) | 6 | 0 | 0 | ✓ | 299 | 169 |
| A₅ | (2,3,5) | 4 | **1** | 1 | ✓ | 1,522,422 | 1,522,422 |
| A₅ | (2,5,5) | 4 | **1** | 1 | ✓ | 1,811,335 | 907,518 |
| A₅ | (3,3,5) | 6 | **0** | 0 | ✓ | 27,009,202 | — |
| A₅ | (3,5,5) | 6 | **0** | 0 | ✓ | 37,188,935 | — |
| A₅ | (5,5,5) | 9 | **0** | 0 | ✓ | 56,486,704 | — |

The memo-state counts confirm the canonicalization really is different: for every class whose
signature has a repeated order (all A₅ except `(2,3,5)`, and the S₄ `(3,3,3)`/`(3,4,4)` etc.) this
replay reaches more states than the reference solver, because it minimises over `left-mult` only
(|G| perms) while the reference also quotients by the color-permuting stabiliser of `T`. For
`(2,3,5)` that stabiliser is already trivial, so the two runs use the identical group of order 60
and report the identical `1,522,422` states (for `(2,3,5)` the genuine-difference lever is code and
authorship, not the group). `(2,5,5)`: `1,811,335 ≈ 2 × 907,518`, matching the
factor-2 color stabiliser. The 27M/37M/56M girth-6/9 state counts are why those classes are the
slow ones; they were run per class, largest last.

Independent full graph-automorphism check (BLISS/igraph, computed from the graph, not the
group construction): for the five A₅ classes `|Aut(Cay(A₅,T))| = 60, 120, 120, 120, 360`
respectively — exactly the `left-mult × color-perm` orders the reference solver constructs by hand.
So the reference canonicalization group was already the full automorphism group (maximal), an extra
corroboration that it introduced no error.

Genuinely-different-algorithm validation — Python graph-isomorphism (BLISS per induced subposition)
solver (`.py`). This uses no ambient group at all; the memo key is a BLISS canonical certificate of
each connected induced subgraph, a provably sound canonicalization independent of any group
construction. It reproduces every value it completed:

| G | sig | 𝒢 (BLISS solver) | 𝒢 (ref) | agree |
|---|---|---:|---:|:--:|
| V₄ | (2,2,2)=K₄ | 1 | 1 (closed form `#K₄ mod 2`) | ✓ |
| S₄ | (2,3,3) | 0 | 0 | ✓ |
| S₄ | (2,3,4) | 0 | 0 | ✓ |
| S₄ | (3,3,3) | 0 | 0 | ✓ |
| S₄ | (3,4,4) | 0 | 0 | ✓ |

Coverage boundary: this pure-Python solver is orders of magnitude slower and far more
memory-hungry at 60 vertices than the Rust solver. It completes V₄ and all four S₄ classes
(24-vertex cubic graphs) with certainty — establishing the graph-isomorphism method is correct — but
it did **not** finish any 60-vertex A₅ class within the compute/memory budget (a `(2,5,5)` attempt
was stopped after exceeding ~10 GB without terminating). The A₅ rows are therefore cross-checked by
the independent Rust solver (all five), not by this BLISS solver; the BLISS solver's role is to
validate the memoized-canonicalization approach on the smaller graphs by a provably-sound,
group-free method.

**What is certified:** the exact Node-Kayles Grundy value of each constructed cubic Cayley graph.
The five A₅ rows are reproduced by the independent Rust solver (fresh code; a different
canonicalization group from the reference on four of five classes), all agreeing with the reference
solver. The V₄ and S₄ rows are additionally reproduced by the genuinely-different-algorithm Python
BLISS solver, and the BLISS full-automorphism-group sizes match the reference's hand-built
canonicalization group in every A₅ class. **What is not certified:** anything beyond the free-orbit
`t_K` values — not the orbit-template formula, the escape/residual analysis, or any `PSL/PGL` claim;
and no 60-vertex A₅ class was completed by the BLISS solver (see coverage boundary above).

## Reproduction

Working directory: `rust/` (repository `rust` subdirectory). No randomness, no seeds.

Independent Rust solver — build and run (compile artifact in `/tmp` is fine; the source is the
tracked `.rs`):

```bash
rustc -O ../notes/2026-07-17-c260-a5-template-nimber-crosscheck.rs -o /tmp/c260nk
/tmp/c260nk S4                 # 4 classes -> 0   (seconds)
/tmp/c260nk A5 2,3,5           # -> 1  (~1 min)
/tmp/c260nk A5 2,5,5           # -> 1  (~1 min)
/tmp/c260nk A5 3,3,5           # -> 0  (~10 min, 27M states)
/tmp/c260nk A5 3,5,5           # -> 0  (~13 min, 37M states)
/tmp/c260nk A5 5,5,5           # -> 0  (~18 min, 56M states; girth-9, slowest)
/tmp/c260nk json               # canonical JSON of all S4+A5 rows -> the .json (recomputes all; ~45 min)
```

The tracked machine-readable output `2026-07-17-c260-a5-template-nimber-crosscheck.json` is exactly
the stdout of `/tmp/c260nk json` (sorted by group then signature; no timestamps or host paths).

Genuinely-independent Python BLISS solver (validation and cross-check):

```bash
uv run --with igraph python3 ../notes/2026-07-17-c260-a5-template-nimber-crosscheck.py V4     # -> 1  (K4 closed form)
uv run --with igraph python3 ../notes/2026-07-17-c260-a5-template-nimber-crosscheck.py S4     # -> all 0  (~1 s)
# NOTE: this pure-Python solver does not terminate within the compute/memory budget at
# 60 vertices (an A5 attempt exceeded ~10 GB with no result); the A5 cross-check is the Rust
# solver above. Use V4/S4 only to validate the graph-isomorphism method here.
```

Reference solver being cross-checked (for comparison): `rustc -O scripts/nodekayles_cayley.rs -o
/tmp/nkcay && /tmp/nkcay A5 <sig>`.

## Artifact hashes

Recorded in the companion manifest
`2026-07-17-c260-a5-template-nimber-crosscheck.SHA256SUMS`. SHA-256 and byte counts:

| file | bytes | sha256 |
|---|---:|---|
| `…-crosscheck.py` | 11591 | `d6db50431339988e8309c8e243f5701f13bb840a05650466aa2926569a965c6a` |
| `…-crosscheck.rs` | 10481 | `686226c6b43a2a077ce65c8cb20210a8f0e1aea8076c2097dbdd4d1ffbca0948` |
| `…-crosscheck.json` | 790 | `801e9d8d8e98e94a40ae5d43c73ad0a55e5c752cf54fbb2e7fe624731c23f199` |

Verify from `notes/`: `sha256sum -c 2026-07-17-c260-a5-template-nimber-crosscheck.SHA256SUMS`.
The `.json` is the exact stdout of `/tmp/c260nk json`; regenerating it (~45 min) and re-hashing
reproduces the listed digest.

