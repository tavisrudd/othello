# 2026-08-07 — C880 items 3 and 4: an adaptive decoder that reads the two-graph in n²/2 + O(n) alignment tests

**Task:** C880 (lane `clebsch`), work items 3 and 4 of
`notes/clebsch-tasks/c880-aligned-query-complexity.md`. Research and computation
only; no manuscript file is touched. The wording this result changes is drafted
in `notes/2026-08-07-c880-manuscript-wording.md` (item 7), whose addendum is
written from this report.

**Status:** complete. The constant is settled on the adaptive side: the adaptive
query complexity is \(\binom n2+O(n)\), and the leading coefficient \(1/2\) is
exactly the counting bound's. The nonadaptive constant remains open between
\(0.616\,n^2\) and \(3n^2\).

---

## What is settled

1. **One test per unknown edge, once two are known.** The attachment lemma below
   is a proof, not a computation: if the two-graph is known on a point set \(K\)
   and two of the edges from a new point \(v\) into \(K\) are known, then every
   further edge from \(v\) costs exactly one alignment test.
2. **The bootstrap is a constant, and it is optimal.** Five helper points, the
   fifteen tests through \(v\) inside \(\{0,v\}\cup H\), and exact minimax play
   pin all five edges from \(v\) to \(H\) in **7** tests for 1022 of the 1024
   helper configurations — which is the information-theoretic floor
   \(\lceil 5/H(1/4)\rceil=7\) — and in 9 tests for the two exceptional ones,
   the monochromatic \(K_5\) configurations.
3. **The decoder.** Read the seven-point core with a greedy decision tree of
   depth at most 22, then attach the remaining points one at a time, each with
   one bootstrap and one test per remaining edge. Total, proved:
   \[
     \binom n2+n-6
     \qquad\text{tests, and}\qquad
     \binom n2+3n-20
   \]
   on the single complement class where the first six points carry a
   monochromatic graph. Both are \(n^2/2+O(n)\).
4. **That is optimal to leading order.** Every decoder, adaptive or not, needs
   at least \(\binom n2-n\) tests by a leaf count, so the adaptive query
   complexity lies in a window of width \(2n-6\) and its leading coefficient is
   exactly \(1/2\).
5. **Adaptivity strictly helps, for every large \(n\) and not only at seven
   points.** No family fixed in advance can use fewer than
   \(1.2326(\binom{n-1}2-1)\approx0.616\,n^2\) tests. The decoder's proved
   bound falls below that floor from \(n=18\) on, and from \(n=33\) on for the
   exceptional class. Before this, the separation was known only at \(n=7\),
   where 22 beats the exact nonadaptive minimum 30.
6. **A factor of six against the manuscript.** The exhibited family costs
   \(3n^2-23n+45\); the ratio to the decoder tends to 6. At \(n=40\) the
   sampled worst case is 789 against 3,925.
7. **Validated exhaustively where that is possible.** All 32,768 two-graphs at
   \(n=7\) and all 2,097,152 at \(n=8\) are decoded correctly up to the global
   complement, with worst cases 22 and 30; 5,000 random instances each at
   \(n=12,20,40\) likewise.

The reading to carry forward: **the coherence restriction is free to leading
order for an adaptive decoder, and its whole cost is a cost of nonadaptivity.**
Against the value oracle's optimum \(\binom{n-1}2\) — order-three minors, one
bit each, no waste — the coarse four-set indicator pays only \(O(n)\) extra when
the decoder may choose its tests in the light of earlier answers, and at least a
factor 1.2326 when it may not.

## Conventions

Points are \(0,\dots,n-1\) with \(0\) as root. A two-graph is the switching
class of a graph \(G\) on \(1,\dots,n-1\), the representative in which \(0\) is
isolated, with \(\tau(0ij)=e_{ij}\) and \(\tau(ijk)=e_{ij}+e_{ik}+e_{jk}\).
Write \(u_a=e_{va}\) for the unknown edges from a new point \(v\). The object to
be reconstructed is the complement pair, and every statement below is up to that
one bit.

## 1. The two shapes of test, and why each is a conjunction of two conditions

For a new point \(v\) and known points \(a,b,c\):

\[
 \{0,v,a,b\}\ \text{aligned}
 \iff u_a=e_{ab}\ \text{ and }\ u_b=e_{ab},
\]
\[
 \{v,a,b,c\}\ \text{aligned}
 \iff u_a+u_b=e_{ac}+e_{bc}\ \text{ and }\ u_a+u_c=e_{ab}+e_{bc}.
\]

The first is immediate from \(\tau(0va)=u_a\), \(\tau(0vb)=u_b\),
\(\tau(0ab)=e_{ab}\) and \(\tau(vab)=u_a+u_b+e_{ab}\). For the second, the four
triple values of \(\{v,a,b,c\}\) sum to zero by the two-graph law, so requiring
them all equal to \(\tau(abc)=e_{ab}+e_{ac}+e_{bc}\) is exactly two independent
conditions, and they simplify to the displayed pair. Both tests are unchanged
when \(u\) and the known edges are complemented together, which is why the
decoder may work in whichever gauge the core fixed.

This is the exact sense in which an alignment test is not a linear functional:
each test is the conjunction of two \(\mathbf F_2\)-affine conditions, so it
answers yes with probability \(1/4\) and carries \(H(1/4)=0.8113\) bits under
the uniform prior. Adaptivity is what escapes that: a decoder that already knows
one of the two conditions to hold turns the test into a single balanced bit.

## 2. The attachment lemma

> **Lemma.** Let the two-graph be known on \(K\), let \(v\notin K\), and suppose
> \(e_{vb}\) is known for at least two \(b\in K\). Then for every \(a\in K\)
> with \(e_{va}\) unknown, one alignment test determines \(e_{va}\).

*Proof.* Put \(\beta_b=u_b+e_{ab}\) for the known \(b\); this is computable from
what the decoder holds. If \(\beta_b=0\) for some known \(b\), the second
condition of \(\{0,v,a,b\}\) reads \(u_b=e_{ab}\) and is already true, so that
test reads exactly \([u_a=e_{ab}]\) and its answer gives \(u_a\).

Otherwise \(\beta_b=1\) for every known \(b\). Take two of them, \(b\) and
\(c\). The two conditions of \(\{v,a,b,c\}\) become \(u_a=u_b+e_{ac}+e_{bc}\)
and \(u_a=u_c+e_{ab}+e_{bc}\), which agree if and only if
\(u_b+e_{ac}=u_c+e_{ab}\), that is if and only if \(\beta_b=\beta_c\) — which
holds. So that test reads exactly \([u_a=u_b+e_{ac}+e_{bc}]\) and its answer
gives \(u_a\). ∎

Two known edges are therefore worth an unlimited supply of one-bit queries, and
the whole cost of an attachment is the cost of the first two. Read backwards,
the lemma explains what the manuscript's construction spends its tests on: six
private tests per outside pair, where one test per edge suffices once the
decoder is allowed to use what it has already learned.

## 3. The bootstrap, and its exact cost

The bootstrap fixes five helper points \(H\subset K\) and uses only the tests
through \(v\) inside the seven points \(\{0,v\}\cup H\): ten of the first shape
and ten of the second. It always succeeds, and for a reason internal to the
paper: two candidate assignments \(u\ne u'\) with the same known \(G|_H\) give
two-graphs on those seven points that are distinct and not complementary — a
complement would change \(G|_H\) as well — so by
`thm:aligned-faithfulness` they differ on some test of the seven-point set, and
every test avoiding \(v\) is already known. Hence they differ on one of the
twenty.

Its cost depends only on the ten known helper edges and the five unknowns, which
makes exhaustive verification complete. Solving the subproblem exactly — 32
candidate assignments, 20 tests, minimax over the posterior — gives:

| helper configuration | count | optimal worst-case tests to pin all five |
|---|---|---|
| every non-monochromatic \(K_5\) | 1022 | **7** |
| monochromatic \(K_5\) (empty or complete) | 2 | 9 |

Seven is the floor: five bits at \(H(1/4)\) bits per test needs
\(\lceil5/0.8113\rceil=7\). So the bootstrap is optimal except on the two
degenerate configurations, and those are exactly the configurations in which
every helper triple is coherent — the mirror image of the obstruction the task
card names, where a two-graph with empty aligned family answers no to
everything. Both extremes are the low-information ones; the alignment oracle is
least useful where the local structure is constant.

The decoder chooses its helper five among the six five-subsets of the first six
known points. Exhaustively over all 32,768 graphs on those six points, a
five-subset of cost 7 exists in 32,766 cases; the two exceptions are the empty
and complete graphs, which are one complement class — the two-graph all of whose
triples agree.

Greedy play, kept in the program as a comparison, has the same worst case of 9
and a better mean of 5.32, since minimax optimizes the worst case only.

## 4. The decoder and its bound

1. **Core.** Decode the two-graph on \(\{0,\dots,6\}\) with a greedy adaptive
   decision tree over the 35 tests. Exhaustively, the tree has depth 22 and mean
   depth 15.61 over the 16,384 complement pairs. This fixes the global
   complement gauge; everything after it is determined absolutely.
2. **Attach.** For \(v=7,\dots,n-1\): choose the helper five, run its optimal
   bootstrap tree, then apply the attachment lemma once per remaining edge.

Cost of attaching \(v\), whose unknown edges number \(v-1\): the bootstrap pins
five, so the total is \(7+(v-6)\), or \(9+(v-6)\) in the exceptional class.
Summing from \(v=7\) to \(n-1\) and adding the core:

\[
 22+\sum_{v=7}^{n-1}\bigl(v+1\bigr)=\binom n2+n-6,
 \qquad
 22+\sum_{v=7}^{n-1}\bigl(v+3\bigr)=\binom n2+3n-20 .
\]

Measured against the counting lower bound \(\binom n2-n\), the overhead is
\(2n-6\). Measured against the nonadaptive floor
\(1.2326(\binom{n-1}2-1)\), the first bound is smaller from \(n=18\) on and the
second from \(n=33\) on.

| \(n\) | decoder, sampled worst | decoder, proved bound | counting bound | nonadaptive entropy floor | manuscript family |
|---|---|---|---|---|---|
| 7  | 22 (exhaustive)  | 22   | 14  | 17.3   | 31    |
| 8  | 30 (exhaustive)  | 30   | 20  | 24.7   | 53    |
| 12 | 69               | 72   | 54  | 66.6   | 201   |
| 20 | 194              | 204  | 170 | 209.5  | 785   |
| 40 | 789              | 814  | 740 | 912.1  | 3,925 |

The sampled columns are maxima over 5,000 random instances and are lower bounds
on the true worst case; the proved column is the bound of the display above, for
the non-exceptional class. The \(n=7\) and \(n=8\) rows are exhaustive, and
there the sampled and proved numbers agree.

The trivial two-graph — every triple equal, the class the exceptional bound is
stated for — turns out to be cheap in practice rather than expensive: 45 tests
at \(n=12\) against a counting bound of 54, because its answers collapse the
posterior quickly. The exceptional bound is a worst case over the instances
whose first six points are monochromatic, not a statement about that instance.

## 5. What this settles, and what it does not

**Item 4 is settled.** Adaptivity strictly helps at every \(n\ge18\), by a
proved construction against a proved nonadaptive floor, and the separation is
not a small-case artifact: asymptotically the adaptive complexity is
\(0.5\,n^2\) and no nonadaptive family beats \(0.616\,n^2\).

**Item 3 is settled on the adaptive side and open on the nonadaptive one.** The
adaptive constant is \(1/2\), matching the counting bound. The nonadaptive
constant is still bracketed between \(0.616\) and \(3\); nothing here improves
either end, because the decoder's tests are chosen in the light of earlier
answers and the family it uses on one instance separates nothing on another.

**The exact second-order term is open.** The adaptive complexity lies between
\(\binom n2-n\) and \(\binom n2+n-6\), a window of width \(2n-6\). Closing it
needs either a bootstrap cheaper than 7 per attachment — impossible for five
pinned bits, but a different split between bootstrap and lemma might do better —
or an adaptive lower bound above the leaf count.

**The price of coherence is now measured in the worst case, not only on
average.** The earlier greedy measurement put the mean price at about four
percent and the worst-case price at 1.47 and 1.43 for \(n=7,8\). The structural
decoder replaces those two small-case numbers with an asymptotic statement: the
worst-case price tends to 1.

## 6. Reproduction

Generator: `notes/2026-08-07-c880-adaptive-decoder.rs`, SHA-256
`d98cccc77bf90e49cb434c06b4a1a287eed63ca3a266553ed84e420d8fadf1a9`.
Toolchain: `rustc 1.93.1 (01f6ddf75 2026-02-11)`, no dependencies, deterministic
except for the sampled instances, whose generator is the seeded xorshift in the
program and whose seed is recorded in each certificate.

From `notes/`, with a scratch directory `$S`:

```sh
rustc -O -o $S/c880ad 2026-08-07-c880-adaptive-decoder.rs
$S/c880ad core        --out 2026-08-07-c880-adaptive-core.json          # §4 step 1
$S/c880ad bootopt --want 5 --out 2026-08-07-c880-adaptive-bootopt.json  # §3 table
$S/c880ad helperchoice --want 5 --out 2026-08-07-c880-adaptive-helperchoice.json
$S/c880ad verify --n 7 --out 2026-08-07-c880-adaptive-verify7.json      # exhaustive
$S/c880ad verify --n 8 --out 2026-08-07-c880-adaptive-verify8.json      # exhaustive
$S/c880ad trivial --nmax 12 --out 2026-08-07-c880-adaptive-trivial.json # §4 last para
$S/c880ad predict --nmax 60 --boot-max 9 --pinned 5 \
                            --out 2026-08-07-c880-adaptive-predict.json
$S/c880ad sample --n 12 --count 5000 --seed 11 --out 2026-08-07-c880-adaptive-sample12.json
$S/c880ad sample --n 20 --count 5000 --seed 11 --out 2026-08-07-c880-adaptive-sample20.json
$S/c880ad sample --n 40 --count 5000 --seed 11 --out 2026-08-07-c880-adaptive-sample40.json
```

`verify` and `sample` decode each instance through an oracle that counts its
calls and cannot be read otherwise, then check the output against the hidden
two-graph up to complement and abort on any mismatch; the `all_recovered` field
is that check. `bootopt` and `helperchoice` are exhaustive over their whole
configuration space, and say so in their own output.

### Artifacts

| file | bytes | SHA-256 |
|---|---|---|
| `2026-08-07-c880-adaptive-decoder.rs` | — | `d98cccc77bf90e49cb434c06b4a1a287eed63ca3a266553ed84e420d8fadf1a9` |
| `2026-08-07-c880-adaptive-core.json` | 145 | `9c2be48a2bc3b278d03a98e1ac395751571a3a91a2dc4cd925dac66bddbb6a28` |
| `2026-08-07-c880-adaptive-bootopt.json` | 222 | `75656ccdb184811745457273940a9b2b7b6cada4e715ab67e27ed3f0fa671045` |
| `2026-08-07-c880-adaptive-helperchoice.json` | 181 | `be0cd17d7f0b2321278a1d2128691dd77492520a740fb01f2c2e5d509d94306b` |
| `2026-08-07-c880-adaptive-verify7.json` | 346 | `0dd4b76acc3b779b2528bfc0fa0f55e90b986668e93b22932c97441a84f32f46` |
| `2026-08-07-c880-adaptive-verify8.json` | 348 | `f47323f62ff58f8d3538ca8277dc1926876a7c77b1ce1109ebd5e77f6d6e7227` |
| `2026-08-07-c880-adaptive-trivial.json` | 1335 | `6529fbf7ee221796da8c05ef826bb0e3dd3268b9a0a61d7c111743e371fde53e` |
| `2026-08-07-c880-adaptive-predict.json` | 5873 | `8efee578a0306b34454928244d48355b2d6be55cb7652466165f92aa0564d23b` |
| `2026-08-07-c880-adaptive-sample12.json` | 351 | `c42bb2a4cdcd7414c580f41c0c278a18502717ac40207ddd86a34d7d7db90f82` |
| `2026-08-07-c880-adaptive-sample20.json` | 356 | `d7c2a27460e1cd89ee6268a24e2fe9cd66412fe33d9fc363724351340610950a` |
| `2026-08-07-c880-adaptive-sample40.json` | 359 | `3c28047b0b566dc12ff53a6fa6eaccd58be30b19d23028b6f5e54e1e5709db20` |

### Independent replay, and what stands without any computation

The attachment lemma, the two test identities of §1, the bootstrap's
completeness argument and the summation of §4 are proofs. The computation pins
three constants: the core depth 22, the bootstrap's optimal depths 7 and 9, and
the helper-choice guarantee.

Two of those have independent confirmation. The core's depth 22 and its mean
15.61 are reproduced exactly by the earlier and separately written greedy
adaptive mode of `notes/2026-08-07-c880-alignment-separation.rs`
(`2026-08-07-c880-alignment-separation-adaptive7.json`), which shares no code
with this program. The bootstrap's floor of 7 is confirmed by the entropy
count \(\lceil5/H(1/4)\rceil=7\), which needs no program. The only constant
resting on this program alone is the value 9 for the two monochromatic
configurations, and it enters the weaker of the two bounds.

## Mystery ledger

- **Settled by this work.** Whether adaptivity beats every fixed family beyond
  the single case \(n=7\): it does, from \(n=18\) on, with an explicit decoder.
  Whether the four-set coherence restriction has an asymptotic worst-case price
  against the value oracle: it does not — both are \(n^2/2(1+o(1))\).
- **Settled by the `ej`/`tt` pass, and worth recording.** The two hard bootstrap
  configurations are the monochromatic ones. That is the same degeneracy as the
  task card's structural obstacle seen from the other side: there a two-graph
  with empty aligned family answers no to every test and is invisible; here a
  configuration all of whose four-sets are aligned answers yes to almost
  everything and is nearly invisible. The alignment oracle loses information
  exactly where the local structure is constant, in either direction.
- **Open, with the exact gap.** The second-order term of the adaptive
  complexity, between \(-n\) and \(+n-6\) against \(\binom n2\). A sharper
  adaptive lower bound would have to beat the leaf count, and no technique for
  that is in hand; the audit records that Boolean sensitivity and certificate
  complexity was never searched, and that is where such a technique would live.
- **Open, unchanged.** The nonadaptive constant, still between \(0.616\,n^2\)
  and \(3n^2\). This decoder says nothing about it, and the difference-mask
  route is exhausted.
- **Not a mystery.** The decoder being cheap on the trivial two-graph while the
  exceptional bound is stated for it: the bound is a worst case over instances
  sharing a monochromatic prefix, and the trivial instance is not that worst
  case.

## Next in this task

- Item 7's addendum is written into
  `notes/2026-08-07-c880-manuscript-wording.md`: the "better decoder" outcome
  now has drafted text, and Draft 2's closing sentence changes from "this bound
  says nothing about adaptive decoders" to the statement that an adaptive
  decoder achieves the counting bound to leading order.
- Item 5 (regular two-graphs, and the promised anchor) and item 8 (a setting
  whose primitive observation is a four-set alignment test) remain untouched.
  Item 8 now has a named genre match in Kummerfeld and Ramsey but no
  matched-units baseline.
- The nonadaptive constant is the one open quantity of the task. The routes left
  are a construction sharing tests between outside pairs, and a lower bound from
  the structure of the weight-four difference masks at general \(n\).
