# 2026-08-07 — C880: the seven-point hypothesis is sharp, and thirty alignment tests are optimal there

**Task:** C880 (lane `clebsch`), work items 1 and 2 of
`notes/clebsch-tasks/c880-aligned-query-complexity.md`, together with the part
of item 3 that the small cases decide. Research and computation only; no
manuscript file is touched.

## What is settled

1. **Six points is not enough, and not only for the degenerate reason.** The
   full family of alignment tests fails to determine a two-graph up to
   complement on four, five and six points, and determines it on seven. At six
   points the failure survives well away from the empty-family case: of the 512
   complement pairs, 96 share their aligned family with another pair, and only 6
   of those have no aligned four-set at all. So the manuscript's hypothesis
   \(|V|\ge7\) in `thm:aligned-faithfulness` is sharp, and there is a witness
   pair to cite that has aligned four-sets.
2. **At seven points the minimum is thirty of the thirty-five tests.** No family
   of twenty-nine alignment tests determines a two-graph on seven points up to
   complement, and several families of thirty do. This is exact, and it was
   computed twice by different methods, plus a third time in an independent
   replay.
3. **The manuscript's selected family is one test above that optimum at seven
   points, and the redundant member is the anchor's own test.** The family of
   four-sets meeting the anchor in at least two points has \(3n^2-23n+45=31\)
   members at \(n=7\); dropping the test on the anchor itself leaves 30, which
   is optimal. The same drop is valid at eight points.
4. **At eight points the manuscript's family is far from optimal, and the
   bracket is wide.** Greedy stripping reduces the 53 selected tests to 45 while
   still separating every two-graph, so the minimum at eight points is at most
   45 against a counting lower bound of 20. The small-difference method that
   settles seven points exactly is vacuous at eight (see below), so the exact
   value there is open.
5. **The alignment code's minimum distance jumps from two to four.** At seven
   points there are pairs of two-graphs whose aligned families differ in exactly
   two four-sets — 315 difference patterns, which is what makes the exact bound
   at seven points possible — and at eight points there are none of weight two,
   none of weight three, and 315 of weight four. Odd weights are absent at both,
   consistent with C810's even distance spectrum.

The reading to carry forward: the seven-point near-optimality of the exhibited
family is a small-case fact, not evidence about the constant 3. At seven points
the whole test set has only 35 members and any separating family needs 30 of
them, so a construction of size 31 could hardly be far off. At eight points the
same construction is already eight tests above what a greedy strip achieves, and
the ratio between the counting bound \(n(n-3)/2\) and the exhibited \(3n^2-23n+45\)
still tends to six. Work item 3 therefore stands untouched by these two cases,
and needs either a structural lower bound or a better construction.

## Conventions

Points are \(0,\dots,n-1\). A two-graph is a map \(\tau\) from 3-subsets to
\(\mathbf F_2\) whose sum over the four triples of any 4-subset is even;
equivalently the switching class of a graph \(G\), with \(\tau(abc)\) the parity
of the number of edges of \(G\) inside \(\{a,b,c\}\). Every switching class has
exactly one representative graph in which the point 0 is isolated, so switching
classes are indexed by the \(2^{\binom{n-1}2}\) graphs on \(1,\dots,n-1\), and
the complementary two-graph \(\tau+1\) is the complement of that graph.

A 4-subset is **aligned** when its four triples carry equal \(\tau\) values; the
**alignment test** on that 4-subset returns that one bit. Alignment is invariant
under the global complement, so the object being reconstructed is a complement
pair, and the **alignment vector** of a two-graph is the \(\binom n4\)-bit word
of all its tests. A set of tests **separates** when distinct complement pairs
keep distinct projections onto it; the minimum size of a separating set is the
nonadaptive query complexity, and the counting lower bound is
\(\lceil\log_2(\text{number of complement pairs})\rceil = \binom n2-n\).

## 1. The point threshold

| \(n\) | switching classes | complement pairs | tests | distinct alignment vectors | colliding groups | pairs in a collision | pairs with empty aligned family |
|-------|-------------------|------------------|-------|----------------------------|------------------|----------------------|---------------------------------|
| 4     | 8                 | 4                | 1     | 2                          | 1                | 3                    | 3                               |
| 5     | 64                | 32               | 5     | 17                         | 6                | 21                   | 6                               |
| 6     | 1024              | 512              | 15    | 462                        | 46               | 96                   | 6                               |
| 7     | 32768             | 16384            | 35    | 16384                      | 0                | 0                    | 0                               |

At seven points every complement pair has its own alignment vector, which is the
manuscript's theorem, and no two-graph has an empty aligned family, which is the
computational form of `exists_distinct_alignedAnchor`. At six points 46 groups
of pairs collide; exactly one of those groups is the six pairs with no aligned
four-set at all, so 45 groups are collisions between two-graphs that do have
aligned four-sets.

**Witness for the manuscript.** Two two-graphs on \(\{0,\dots,5\}\), neither the
complement of the other, both with aligned family exactly
\(\{\{0,1,2,5\},\{0,1,3,4\}\}\): take the graphs on \(\{1,\dots,5\}\) with the
point 0 isolated and edge sets
\[
  \{12,\,15,\,24,\,25,\,35\}
  \qquad\text{and}\qquad
  \{13,\,14,\,24,\,34,\,35\},
\]
whose two-graphs are distinct and non-complementary. Both are verified against
the four-set parity law directly.

## 2. The exact minimum at seven points

Removability is downward closed: if a set of tests can be deleted and the rest
still separates, so can any subset of it. Level-wise enumeration therefore sees
every removable set.

| tests removed | families that still separate |
|---------------|------------------------------|
| 1             | 35                           |
| 2             | 280                          |
| 3             | 560                          |
| 4             | 280                          |
| 5             | 56                           |
| 6             | 0                            |

So the minimum is \(35-5=30\), and there are exactly 56 optimal families. They
fall into two orbits under the symmetric group on the seven points, and both are
local:

- **21 families** — delete the five 4-subsets of a fixed five-point subset.
  Equivalently, keep exactly the tests meeting a fixed pair of points.
- **35 families** — delete the four 4-subsets containing a fixed triple \(T\)
  together with the 4-subset \(V\setminus T\) complementary to it.

Each of the 280 removable 4-sets lies in exactly one removable 5-set
(\(56\times5=280\)), so any separating family of 31 tests has exactly one further
redundant member.

## 3. The manuscript's selected family

For the anchor \(Q=\{0,1,2,3\}\), the selected family — every 4-subset meeting
\(Q\) in at least two points — has \(3n^2-23n+45\) members, and it separates
unconditionally, with no promise that \(Q\) is aligned. At seven points its
complement is \(\{(V\setminus Q)\cup\{a\} : a\in Q\}\), which is the star of the
triple \(V\setminus Q\); the unique way to extend that to a removable 5-set is by
the complementary 4-subset of that triple, which is \(Q\) itself. Hence:

> At seven points, the manuscript's selected family minus the test on the anchor
> is an optimal separating family, and the anchor's own test is the only
> redundant member of it.

That drop is not a seven-point accident: at eight points the family of 53 also
still separates after the anchor test is removed. It is also the expected drop,
since the decoder is *given* that the anchor is aligned and so learns nothing by
testing it.

At eight points, greedy stripping removes eight of the 53 tests — the anchor
\(\{0,1,2,3\}\) and seven others — and the remaining 45 still separate all
\(2^{20}\) complement pairs.

## 4. Bounds at eight points

At eight points there are 1,048,576 complement pairs and 70 tests. The
manuscript's family has 53 members, greedy stripping under twenty-three
different orders reaches 45 and no further, and the counting bound is 20. So

\[
  20 \;\le\; \mathrm{minimum}(8) \;\le\; 45 \;<\; 53 = 3n^2-23n+45.
\]

The exact value is open, and the method that closes seven points cannot close
this one. At seven points the bound comes from pairs of two-graphs whose
alignment vectors differ in exactly two coordinates: those 315 patterns force
one of their two tests into every separating family, and the largest set of
tests containing no such pair has size 5, which gives \(35-5=30\) — tight. At
eight points a pigeonhole neighbour search over all pairs finds no difference of
weight two or three at all and exactly 315 of weight four, and 315 four-element
constraints on 70 tests leave a mask-free set of at least 40, so that route
yields nothing above the counting bound. Its search was capped and did not
complete, and an incomplete search would only overstate the bound, so it is
discarded rather than reported.

The greedy 45 is an upper bound with a witness family recorded in the
certificate; it is not claimed optimal.


## What this certifies, and what it does not

- The threshold and the seven-point minimum are exhaustive statements over all
  two-graphs on the stated point sets. They say nothing about \(n\ge9\).
- The minimum is the **nonadaptive** query complexity, over families fixed in
  advance. Item 4 of the task card — whether adaptivity helps — is untouched.
- Separation is unconditional: no promise that any particular four-set is
  aligned. The promised-anchor variant of item 5 is a different, smaller problem
  and is not measured here.
- The trusted boundary is the alignment predicate and the switching-class
  indexing, both of which are stated above and re-derived independently in the
  replay.
- No literature audit has been run, so nothing here is claimed to be new. The
  audit is item 6 of the card, and manuscript wording (item 7) is deliberately
  not drafted before it.

## Reproduction

From `notes/`, with a scratch directory `$S`:

```sh
rustc -O -o $S/c880 2026-08-07-c880-alignment-separation.rs
$S/c880 threshold --nmax 7 --out $S/threshold.json      # section 1
$S/c880 census    --n 7      --out $S/census7.json      # section 2, level-wise
$S/c880 minimize  --n 7 --seed-weight 3 --out $S/min7.json  # section 2, hitting set
$S/c880 paper     --n 7      --out $S/paper7.json       # section 3
$S/c880 paper     --n 8      --out $S/paper8.json       # section 3
$S/c880 bounds    --n 7 --weight 4 --out $S/bounds7.json    # section 4 control
$S/c880 bounds    --n 8 --weight 4 --out $S/bounds8.json    # section 4
uv run --with numpy python3 2026-08-07-c880-alignment-separation-replay.py \
    --census 2026-08-07-c880-alignment-separation-census7.json --out $S/replay.json
```

Everything is deterministic: the enumerations are canonical, and the only
randomized part — the restart orders of the greedy strip at eight points — uses a
fixed seed recorded in the source.

**Three independent routes to the same minimum at seven points.** The `minimize`
mode solves a minimum hitting set over pair-difference masks with lazy
constraint generation, accepting a family only after a direct separation check.
The `census` mode ignores that machinery and enumerates removable sets level by
level. The `bounds` mode derives the bound from the weight-two difference
patterns alone, as a vertex cover. All three return 30. The numpy replay
recomputes the alignment data from a different representation — full graph
enumeration with no switching representative chosen — and re-verifies both the
six-point collision counts and, at seven points, that all 56 reported families
are removable and that none extends.

### Artifacts

| file | bytes | sha256 |
|------|-------|--------|
| `2026-08-07-c880-alignment-separation.rs` | 40793 | 77790a677bf36de7478a7ab315e02205a656bdd9cfe13eed5c10bc4d6d33f635 |
| `2026-08-07-c880-alignment-separation-replay.py` | 8373 | 95cc38756438c7a9d5e7b893b6bdbf917aa7425e9518290022b42982c5ba7fd4 |
| `2026-08-07-c880-alignment-separation-threshold.json` | 2810 | efe57db769fb9b33500cf31b13fac7e10ee103f5f653fefdb6a90c2fedbe9423 |
| `2026-08-07-c880-alignment-separation-census7.json` | 677 | cea77f21fef491a53a1d2cff21ad482a5208f121f0d8bc8ba634ef16d78b3a8b |
| `2026-08-07-c880-alignment-separation-min7.json` | 769 | c8121ae8374507fc9e5ff0625adedd0a7a3e5caf167819ac4058b857fa74ea6b |
| `2026-08-07-c880-alignment-separation-paper7.json` | 256 | 6cf7ce5bd451eeec4b489d6767720c872e53e792cda3fa1946a9518e7cfb22fc |
| `2026-08-07-c880-alignment-separation-paper8.json` | 328 | c15873562c3e0860fc610012bd505ad435e28a10c1bebd5e7e5b9aa88da44fa5 |
| `2026-08-07-c880-alignment-separation-bounds7.json` | 520 | d1dae32cacae8a42fda37710706389bf9585d0484ed2d768d68ab002af6ee3af |
| `2026-08-07-c880-alignment-separation-bounds8.json` | 572 | 2b42d2b48ef9c922fe256b9c5c736105a0ab6f9c36a5e3c16ec2dd29d8972058 |
| `2026-08-07-c880-alignment-separation-replay.json` | 1638 | a306367330ba08a393df7dc83faf1c8b9226cf420c7fd8ebfe7a1c3a09138394 |

## Next in this task

- Item 3 is the live question: a lower bound that beats counting for general
  \(n\), or a construction below \(3n^2-23n+45\). The eight-point gap between 45
  and 53 says the exhibited constant is loose before any asymptotic argument.
- The weight-two difference patterns at seven points are the mechanism behind
  the exact bound; identifying them structurally for general \(n\) is the most
  direct route to a proved lower bound, and it is a finite question at each \(n\).
- Items 4 (adaptivity), 5 (regular two-graphs and the promised anchor), 6 (the
  literature audit) and 8 (a setting that pays per query) are untouched.
