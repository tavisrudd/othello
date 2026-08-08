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
2. **The bootstrap is a constant, and no strategy beats it.** Five helper
   points, the twenty tests through \(v\) inside \(\{0,v\}\cup H\), and exact
   minimax play pin all five edges from \(v\) to \(H\) in **7** tests for 1022
   of the 1024 helper configurations, and in 9 for the two monochromatic ones.
   The 7 is optimal for those configurations — that is what the minimax
   computation establishes — and it is a computed optimum, not an entropy
   floor: the \(H(1/4)\)-per-test cap is a nonadaptive argument and gives only
   6 here, because a query can split a conditioned posterior evenly.
3. **The decoder.** Read the seven-point core with a greedy decision tree of
   depth at most 22, then attach the remaining points one at a time, each with
   one bootstrap and one test per remaining edge. The helper five is chosen to
   carry both a known edge and a known non-edge whenever the known graph
   carries both, which is what keeps every bootstrap at 7 except for at most
   one stage per instance. Total, proved for **every** instance:
   \[
     \binom n2+n-4\quad\text{tests},
   \]
   which is \(n^2/2+O(n)\).
4. **That is optimal to leading order.** Every decoder, adaptive or not, needs
   at least \(\binom n2-n\) tests by a leaf count, so the adaptive query
   complexity lies in a window of width \(2n-4\) and its leading coefficient is
   exactly \(1/2\).
5. **Adaptivity strictly helps, for every large \(n\) and not only at seven
   points.** No family fixed in advance can use fewer than
   \(1.2326(\binom{n-1}2-1)\approx0.616\,n^2\) tests. The decoder's proved
   bound is below that floor for every \(n\ge19\); for \(8\le n\le18\) the
   separation is open, since the proved bound is above the floor there and the
   decoder's true worst case is not computed. Before this, the separation was
   known only at \(n=7\), where 22 beats the exact nonadaptive minimum 30.
6. **A factor of six against the manuscript.** The exhibited family costs
   \(3n^2-23n+45\); the ratio to the decoder tends to 6. At \(n=40\) the
   sampled worst case is 782 against 3,925.
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

Seven is not an entropy floor. The \(H(1/4)\)-per-test cap holds for a test
whose answer marginal is \(1/4\), which is the unconditional marginal; after
one answer a later test can split the surviving assignments evenly, and the
chain rule then licenses only \(5\le H(1/4)+(d-1)\) — the \(H(1/4)\) is the
first query's marginal, which is unconditional, and every later query is
charged a full bit — that is, \(d\ge6\). The
value 7 is the exact minimax optimum, and it rests on the computation above.
What is structural is which configurations are hard: the two costing 9 are the
monochromatic ones, in which every helper triple is coherent — the mirror image
of the obstruction the task card names, where a two-graph with empty aligned
family answers no to everything. Both extremes are the low-information ones,
and the alignment oracle is least useful where the local structure is constant.

**The decoder never meets a monochromatic helper five unless the whole known
graph is monochromatic.** It picks its five to contain one known edge and one
known non-edge whenever the known graph contains both, which is possible on any
\(K\) with at least six points: take a pair of each kind, at most four points
in all, and pad. So a bootstrap costs 7 unless \(G|_K\) is complete or empty.

That case can be expensive only once per instance. If the new point's edges
into \(H\) all take the known edge value, the bootstrap costs 4 — the two
matching rows of the degenerate certificate, code 0 with pattern 0 and code
1023 with pattern 31. Otherwise it costs at most 9, and those helper edges
already leave \(G|_{K\cup\{v\}}\) non-monochromatic, so no later stage meets a
monochromatic configuration and every one of them costs 7. Since the known set
only grows, at most one stage of an instance pays that 9. The monochromatic
state can also end at a cost-4 stage, through the edges from \(v\) to
\(K\setminus H\) that the lemma phase learns; that only removes expensive
stages, so the accounting is unaffected.

Greedy play, kept in the program as a comparison and certified separately, has
the same worst case of 9 and a better mean of 5.32, since minimax optimizes the
worst case only.

## 4. The decoder and its bound

1. **Core.** Decode the two-graph on \(\{0,\dots,6\}\) with a greedy adaptive
   decision tree over the 35 tests. Exhaustively, the tree has depth 22 and mean
   depth 15.61 over the 16,384 complement pairs. This fixes the global
   complement gauge; everything after it is determined absolutely.
2. **Attach.** For \(v=7,\dots,n-1\): choose the helper five, run its optimal
   bootstrap tree, then apply the attachment lemma once per remaining edge.

Cost of attaching \(v\), whose unknown edges number \(v-1\): the bootstrap
pins five, so the stage costs \(7+(v-6)\), with at most one stage per instance
costing \(9+(v-6)\) and the monochromatic-prefix stages costing \(4+(v-6)\).
Summing from \(v=7\) to \(n-1\), adding the core, and charging the single
expensive stage its extra two:

\[
 22+\sum_{v=7}^{n-1}\bigl(v+1\bigr)+2=\binom n2+n-4 .
\]

This holds for every instance. Measured against the counting lower bound
\(\binom n2-n\) the overhead is \(2n-4\), and measured against the
nonadaptive floor \(1.2326(\binom{n-1}2-1)\) the bound is smaller for every
\(n\ge19\).

| \(n\) | decoder, worst case observed | decoder, proved bound | counting bound | nonadaptive entropy floor | manuscript family |
|---|---|---|---|---|---|
| 7  | 22 (exhaustive)  | 24   | 14  | 17.3   | 31    |
| 8  | 30 (exhaustive)  | 32   | 20  | 24.7   | 53    |
| 12 | 69 (sampled)     | 74   | 54  | 66.6   | 201   |
| 20 | 195 (sampled)    | 206  | 170 | 209.5  | 785   |
| 40 | 782 (sampled)    | 816  | 740 | 912.1  | 3,925 |

The sampled rows are maxima over 5,000 random instances and are lower bounds on
the true worst case, not worst cases; only the \(n=7\) and \(n=8\) rows are
exhaustive. The proved column is the display above, and it is an upper bound for
every \(n\), including the two exhaustive rows where it is not tight.

The trivial two-graph — every triple equal, the one class whose every stage
meets a monochromatic helper five — is cheap rather than expensive in practice:
45 tests at \(n=12\) against a counting bound of 54, because its stages are
the 4-test ones and its answers collapse the posterior quickly.

## 5. What this settles, and what it does not

**Item 4 is settled asymptotically.** Adaptivity strictly helps at every
\(n\ge19\), by a proved construction against a proved nonadaptive floor:
asymptotically the adaptive complexity is \(0.5\,n^2\) and no nonadaptive
family beats \(0.616\,n^2\). For \(8\le n\le18\) the question stays open,
because the proved bound sits above the floor there; closing that range needs
the decoder's exact worst case at those \(n\), which is a finite computation
this task did not run.

**Item 3 is settled on the adaptive side and open on the nonadaptive one.** The
adaptive constant is \(1/2\), matching the counting bound. The nonadaptive
constant is still bracketed between \(0.616\) and \(3\); nothing here improves
either end, because the decoder's tests are chosen in the light of earlier
answers and the family it uses on one instance separates nothing on another.

**The exact second-order term is open.** The adaptive complexity lies between
\(\binom n2-n\) and \(\binom n2+n-4\), a window of width \(2n-4\). Closing it
needs either a cheaper attachment — the minimax computation forbids beating 7 on
five pinned bits, but a different split between bootstrap and lemma is not
excluded — or an adaptive lower bound above the leaf count.

**The price of coherence is now measured in the worst case, not only on
average.** The earlier greedy measurement put the mean price at about four
percent and the worst-case price at 1.47 and 1.43 for \(n=7,8\). The structural
decoder replaces those two small-case numbers with an asymptotic statement: the
worst-case price tends to 1.

## 6. Reproduction

Generator: `notes/2026-08-07-c880-adaptive-decoder.rs`, SHA-256
`035e880b0eb6c97456ec74b3955c7a3b0e9e17fb0b48bf1da352ad58ff69077f`.
Toolchain: `rustc 1.93.1 (01f6ddf75 2026-02-11)`, no dependencies, deterministic
except for the sampled instances, whose generator is the seeded xorshift in the
program and whose seed is recorded in each certificate.

From `notes/`, with a scratch directory `$S`:

```sh
rustc -O -o $S/c880ad 2026-08-07-c880-adaptive-decoder.rs
$S/c880ad core        --out 2026-08-07-c880-adaptive-core.json          # §4 step 1
$S/c880ad bootopt --want 5 --out 2026-08-07-c880-adaptive-bootopt.json  # §3 table
$S/c880ad degenerate --out 2026-08-07-c880-adaptive-degenerate.json     # §3 the 4s and 9s
$S/c880ad bootstrap --want 5 --out 2026-08-07-c880-adaptive-bootstrap-greedy.json
$S/c880ad verify --n 7 --out 2026-08-07-c880-adaptive-verify7.json      # exhaustive
$S/c880ad verify --n 8 --out 2026-08-07-c880-adaptive-verify8.json      # exhaustive
$S/c880ad trivial --nmax 12 --out 2026-08-07-c880-adaptive-trivial.json # §4 last para
$S/c880ad predict --nmax 60 --boot-max 7 --pinned 5 --switch 2 \
                            --out 2026-08-07-c880-adaptive-predict.json
$S/c880ad sample --n 12 --count 5000 --seed 11 --out 2026-08-07-c880-adaptive-sample12.json
$S/c880ad sample --n 20 --count 5000 --seed 11 --out 2026-08-07-c880-adaptive-sample20.json
$S/c880ad sample --n 40 --count 5000 --seed 11 --out 2026-08-07-c880-adaptive-sample40.json
```

`verify` and `sample` decode each instance through an oracle that counts its
calls and is not otherwise consulted, then check the output against the hidden
two-graph up to complement and abort on any mismatch; the `all_recovered` field
is that check. `bootopt`, `degenerate` and `bootstrap` are exhaustive over their whole
configuration space, and say so in their own output.

### Artifacts

| file | bytes | SHA-256 |
|---|---|---|
| `2026-08-07-c880-adaptive-decoder.rs` | — | `035e880b0eb6c97456ec74b3955c7a3b0e9e17fb0b48bf1da352ad58ff69077f` |
| `2026-08-07-c880-adaptive-core.json` | 145 | `9c2be48a2bc3b278d03a98e1ac395751571a3a91a2dc4cd925dac66bddbb6a28` |
| `2026-08-07-c880-adaptive-bootopt.json` | 200 | `b49079257ca0814b1039321d8a4538a26a6c4579ffe8f9efc5e979ed0402fb71` |
| `2026-08-07-c880-adaptive-degenerate.json` | 355 | `d0480631e70368091a3512d4e3965e2a7c7f14e928b15a170ec4316a4a952bba` |
| `2026-08-07-c880-adaptive-bootstrap-greedy.json` | 339 | `5e0853f4bf8e03dc443bbe8da3aa05f8b8ad493d77db864acccd4d9a7c0d8c22` |
| `2026-08-07-c880-adaptive-verify7.json` | 346 | `0dd4b76acc3b779b2528bfc0fa0f55e90b986668e93b22932c97441a84f32f46` |
| `2026-08-07-c880-adaptive-verify8.json` | 348 | `33e37dca6f1b889816dc6fc6b0c9b9a354b768bc49180d1a6618c23a3a57e5bb` |
| `2026-08-07-c880-adaptive-trivial.json` | 1335 | `6529fbf7ee221796da8c05ef826bb0e3dd3268b9a0a61d7c111743e371fde53e` |
| `2026-08-07-c880-adaptive-predict.json` | 5896 | `949aac1ba853462c28e12ea499fad15ba8bedbbf67bb8ece6e11a8c30ddcdc2b` |
| `2026-08-07-c880-adaptive-sample12.json` | 351 | `0e0e96bec2a7fb6831f9c327569933974712233927e4bf6a468643e346d96f3d` |
| `2026-08-07-c880-adaptive-sample20.json` | 356 | `fe865f7208a97d18339a846dd36f11ec7973cbd19e326e33980bae9a781ceccb` |
| `2026-08-07-c880-adaptive-sample40.json` | 359 | `3abc5deccd4450107f918e2bb7adba387bc45213f04dca83534409b6eea40517` |

Every certificate in this table is an output of the generator whose hash heads
it; a 2026-08-07 referee pass caught an earlier `verify8.json` that was not, and
it has been regenerated.

### Independent replay, and what stands without any computation

The attachment lemma, the two test identities of §1, the bootstrap's
completeness argument and the summation of §4 are proofs. The computation pins
three constants: the core depth 22, the bootstrap's optimal depths 7 and 9, and
the helper-choice guarantee.

One of those has independent confirmation. The core's depth 22 and its mean
15.61 are reproduced exactly by the earlier and separately written greedy
adaptive mode of `notes/2026-08-07-c880-alignment-separation.rs`
(`2026-08-07-c880-alignment-separation-adaptive7.json`), which shares no code
with this program.

The bootstrap constants do not. The values 7, 9 and 4 rest on this program's
minimax search alone; there is no program-free argument for the 7, and the
entropy heuristic that looks like one is nonadaptive and gives only 6. A second
implementation of the bootstrap search, or a structural proof engaging the
query geometry rather than the answer marginal, is what would close that gap.
Both are outside this task as scoped, and the asymptotic result survives a
weaker constant: any bootstrap bounded by a constant \(c\) gives
\(\binom n2+(c-6)n+O(1)\).

The exhaustive verifications at \(n=7\) and \(n=8\) are self-checking in a
different sense: they decode every instance and compare against the hidden
two-graph, so a wrong constant would show up as a failed decode rather than as a
wrong count.

## Mystery ledger

- **Settled by this work.** Whether adaptivity beats every fixed family beyond
  the single case \(n=7\): it does, from \(n=19\) on, with an explicit decoder;
  the range \(8\le n\le18\) stays open.
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
  complexity, between \(-n\) and \(+n-4\) against \(\binom n2\). A sharper
  adaptive lower bound would have to beat the leaf count, and no technique for
  that is in hand; the audit records that Boolean sensitivity and certificate
  complexity was never searched, and that is where such a technique would live.
- **Open, unchanged.** The nonadaptive constant, still between \(0.616\,n^2\)
  and \(3n^2\). This decoder says nothing about it, and the difference-mask
  route is exhausted.
- **Open, and newly visible.** The bootstrap constants 7, 9 and 4 rest on one
  program. The referee pass showed the entropy argument that appeared to confirm
  the 7 is nonadaptive and licenses only 6, so a second implementation or a
  structural proof is what would retire that dependence. Nothing asymptotic
  turns on it.
- **Not a mystery.** The decoder being cheap on the trivial two-graph while the
  expensive stage is defined by it: the monochromatic stages that keep the graph
  monochromatic cost 4, and only the single stage that ends that state can cost
  9, which the trivial instance never reaches.

A referee pass on 2026-08-07 found four repairable defects in the first version
of this report — an unproved separation threshold, an invalid entropy-floor
justification, an unconditional count that held only outside a degenerate class,
and a stale certificate. All four are repaired above: the decoder now chooses
its helper five to avoid the degenerate configurations, which turned the two
class-dependent bounds into the single bound \(\binom n2+n-4\); the entropy
claim is withdrawn; and every certificate is regenerated from the committed
generator. Review:
`notes/2026-08-07-c880-adaptive-and-wording-referee-review.md`.

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
