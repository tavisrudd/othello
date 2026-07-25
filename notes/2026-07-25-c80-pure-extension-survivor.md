# C80 — the pure-extension ranked survivor is false

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.

## Verdict

A natural algebraic ranked survivor can be stated and proved sound, with a
structural P boundary that invokes neither minimax nor Node--Kayles Grundy:

```text
all maximal continuations have even length
+ every completed opponent/reply prefix admits a strict-Ω reply.
```

The first clause makes the overload-zero boundary P by fixed play parity.
The second is hereditary and gives the required strict-`Ω` lifting.

The candidate is nevertheless **false at the escape roots**. Each of the five
certified q=13 strict-kernel/P roots has two explicitly certified maximal
continuations of opposite parity. Hence none belongs even to the candidate's
parity packet. This falsifies the broader parity-uniform formulation, not
merely the stronger requirement that the continuation complex be pure or
matroidal.

C82 remains gated. A viable boundary packet must determine P by an adaptive
strategy or decomposition; it cannot require all maximal plays to have the
same parity.

## 1. Candidate

For a residual state `R`, let `Δ(R)` be its continuation complex:

```text
vertices = legal moves from R;
T ∈ Δ(R)  iff  adjoining every point of T to R is cap-legal.
```

This is an algebraic incidence object. In the normalized residual grid its
faces are exactly the cell sets with distinct rows and columns and with every
affine determinant of three selected cells nonzero.

Call `Δ(R)` **even-faceted** when every facet (maximal legal continuation) has
even cardinality. Define the structural boundary packet

```text
B_even = {R : Ω(R)=0 and Δ(R) is even-faceted}.
```

For an even face `T∈Δ(R)`, write `R+T` for the corresponding follower. Say
that `R` has the **hereditary strict drain** property if

```text
for every even face T with Ω(R+T)>0,
for every x legal from R+T,
there exists y legal from R+T+x such that
Ω(R+T+x+y) < Ω(R+T).
```

The proposed positive-overload survivor is

```text
F_even = {R : Δ(R) is even-faceted
               and R has hereditary strict drain}.
```

Both clauses are finite incidence statements. They contain no P/N value,
Grundy number, strict-kernel membership, or recursively named survivor.
They allow unbounded continuation length and therefore evade the earlier
fixed-depth and twelve-cap obstruction.

### Proposition — sound ranked survivor

`B_even` is P. Moreover, if `R∈F_even`, then after every opponent move there
is a legal reply into `F_even∪B_even` with strictly smaller `Ω`. Consequently
`F_even⊆P`.

**Proof.** From a state in `B_even`, every complete play selects a facet of
`Δ(R)`, hence has even length. The second player therefore makes the last
move, so the state is P.

Now let `R∈F_even` have positive overload and let the opponent choose `x`.
Apply hereditary strict drain at the empty even face to obtain `y` with
strictly smaller overload. Facets of the follower complex
`Δ(R+x+y)` are precisely the sets `U` for which `U∪{x,y}` is a facet of
`Δ(R)`. Their sizes remain even. The hereditary drain condition also
restricts to the follower: every even face there corresponds after adjoining
`{x,y}` to an even face of `Δ(R)`. Thus the follower remains in `F_even`
when its overload is positive and lies in `B_even` when its overload is zero.
Induction on the nonnegative integer `Ω` proves `R` P. ∎

The stronger “pure even rank” version is a special case: a pure
continuation complex of even rank is even-faceted. A matroid continuation
complex of even rank is stronger still.

## 2. Exact falsifier

The committed C80 strict-kernel certificate identifies five q=13
size-four escape roots in `K_Ω`, all exact P. For every one, deterministic
greedy extension found and the checker certified one even and one odd
maximal continuation:

| q=13 root `t4` | even maximal length (seed) | odd maximal length (seed) |
| --- | ---: | ---: |
| `{1,9,10,11}` | 6 (2) | 3 (0) |
| `{3,9,10,11}` | 4 (1) | 3 (0) |
| `{4,5,6,10}` | 6 (0) | 3 (7) |
| `{7,9,10,11}` | 4 (0) | 3 (3) |
| `{9,10,11,12}` | 4 (0) | 3 (1) |

One compact witness is the first root, whose selected affine cells are

```text
(1,1), (9,3), (10,4), (11,6).
```

It has the terminal continuations

```text
even:
(0,12), (3,0), (8,5), (7,8), (2,2), (4,10);

odd:
(0,0), (3,11), (4,7).
```

Both sequences are legal, and after either sequence no cell in
`F_13²` can be added. Thus they are facets of different sizes and opposite
parity. The root is not even-faceted, so it is outside `F_even` before the
drain clause is queried.

This is a bounded falsification of this survivor family. It does not say
that no other algebraic ranked survivor or structural P boundary exists.

## 3. Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_pure_extension_survivor.py
python3 rust/scripts/c80_pure_extension_survivor.py --check
```

Load-bearing input:

- `notes/2026-07-24-c80-strict-overload-kernel.json`, which fixes the five
  q=13 strict-kernel/P roots;
- `rust/scripts/c80_strict_overload_kernel.py` and its existing normalized
  prime-grid engine.

The generator searches seeds `0..511`, using Python's
`random.Random(seed).shuffle`, and stops at the first even and first odd
maximal continuation for each root. The search is only a witness finder.
The certificate's claim rests on replay of the displayed continuations.

Two checks are performed:

1. the existing exact grid engine replays every prefix and verifies that the
   final legal mask is empty;
2. an independent coordinate reference checks distinct rows, distinct
   columns, every affine `3×3` collinearity determinant modulo 13, and all
   169 possible one-cell extensions.

The two checks agree on all ten maximal-continuation witnesses.

Artifacts:

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_pure_extension_survivor.py` | 7,597 | `69ba28445732fb2280f1724a78a6456d0411b17be537d057736a0d6f62cd72d3` |
| `notes/2026-07-25-c80-pure-extension-survivor.json` | 7,926 | `19da4d9f045a1e6c6256e407f298cc2e100cd5ea211d51d8c22678b5b8050763` |

The JSON is canonical (`sort_keys=True`) and `--check` regenerates it in a
temporary directory before byte comparison. It certifies only the five
listed q=13 roots and the stated maximal continuations.

## `ej` + `tt` closeout

The cheap strengthening is that the witnesses kill more than purity. Since
the two facets have opposite parity, they also kill every boundary theorem
whose P-proof is “all complete plays have even length,” even if facet sizes
are allowed to vary.

The Tao-style lesson is the quantifier mismatch:

```text
fixed-parity boundary:  every maximal continuation has even size;
actual P strategy:      after every opponent move, choose one good reply.
```

The q=13 roots already require the second, adaptive shape. The next boundary
packet should therefore expose a response involution, a decomposable XOR
law, or another explicit strategy certificate on a selected subfamily of
continuations. Global purity spends structure on losing branches that a
P-strategy never needs to visit.

## Mystery ledger

- **[SETTLED positive] Is even-facetedness plus hereditary strict drain a
  valid nonrecursive ranked-survivor theorem?** Yes; the proposition proves
  the boundary and lifting clauses directly.
- **[SETTLED negative] Does it contain the certified escape roots?** No. All
  five q=13 P roots have maximal continuations of opposite parity.
- **[SETTLED stronger negative] Could pure even rank or an even-rank matroid
  continuation complex repair it?** No; both imply even-facetedness and are
  excluded by the same witnesses.
- **[OPEN — C80] What adaptive structural packet replaces fixed play
  parity?** The exact gap is a uniform copycat/decomposition-style P proof
  that can ignore losing maximal branches.
- **[OPEN — C80] Can the positive-overload survivor be defined using only
  the strategy-supported subcomplex?** This is the highest-EV refinement,
  but defining that subcomplex without hiding `K_Ω` or P/N recursion is the
  remaining gate.
- **[SETTLED] Does this release C82?** No.

## Vibe

This is a clean, useful negative. The candidate had exactly the requested
ranked-survivor and structural-boundary shape, but the smallest serious
prime-field gate rejects not only purity but the whole fixed-play-parity
idea. The search should now target adaptive strategy structure rather than
another global continuation-complex invariant.

go C80 cap construct an adaptive algebraic survivor with a copycat or
decomposition P boundary
