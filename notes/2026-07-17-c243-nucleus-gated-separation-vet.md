# C243 nucleus-gated harmonic separation: theorem, boundary, and threshold decision

**Lane:** `rp-next`
**Status:** COMPLETE. The q=9 switch is source-replayed and strengthened to an all-field strict
separation for every `q=3^h>=9`; the one-round five-seed completion is genuinely q=9-specific.
The design-cascade threshold problem survives the literature gate, but only in an explicitly
two-parameter, SQS-specific formulation.

## Exact theorem

Let `q=3^h`, let `X=Gamma_4=P^1(GF(q))` be the `q+1` points of the normal rational quartic,
and adjoin its point nucleus `N`. C218 proves that the radius-four repair circuits are exactly

```text
{N} union B,        B in H_q,
```

where `H_q` is the harmonic Steiner quadruple system `S(3,4,q+1)`. For `S subseteq X`, write
`D(S)` for closure under the design rule “three points of `B` add its fourth point.” Then the
radius-four circuit-Horn closure has the exact gate law

```text
L_4(S) = S                                      if S contains no block,
L_4(S) = {N} union D(S)                         if S contains a block,
L_4(S union {N}) = {N} union D(S)               always.
```

The proof is immediate from the complete small-circuit inventory: without `N`, a curve point
cannot be added; the only possible first addition is `N`, requiring all four points of a block.
Once `N` is present, the circuit rules restricted to curve points are exactly the three-to-one
design rules.

For q=9, take C236's seed

```text
S_9 = {V(infinity), V(0), V(1), V(x), V(2+x)}.
```

It is block-free, has rank five, and hence spans all eleven represented points, but the gate law
gives `L_4(S_9)=S_9`. After adjoining `N`, every one of the five missing curve points is exposed
in the first parallel round. More precisely, the ten triples of `S_9` complete two-to-one onto
the five missing points. Thus

```text
|L_4(S_9)| = 5,               cl_M(S_9) = X union {N},
P_4(S_9 union {N}) = X union {N}.
```

This is a strict three-way statement: without the nucleus the spanning seed is sequentially
inert; with the nucleus it is one-round complete; full linear recovery ignores the gate.

## What this means for the programme

The durable result is **not** merely a curious q=9 switch. It is the all-field contrast between
the two flagship geometric families:

```text
completed cubic--axis family:    bounded sequential closure = full linear span,
quartic--nucleus family:         bounded sequential closure < full linear span.
```

The second line now holds for every `q=3^h>=9`, with only five surviving curve coordinates.
This cubic-versus-harmonic contrast is the safest paper headline supplied by C243. The q=9
one-round switch is the sharp illustrative example inside that theorem, not the scalable headline.

### Paper disposition

1. **First use: strengthen the main repair-port/Horn-closure paper.** Pair C236's uniform cubic
   equality theorem with C243's uniform harmonic separation. This gives the general framework a
   memorable positive/negative flagship comparison without requiring any new probability theorem.
2. **Possible second use: a short deterministic design/Horn note.** This becomes worthwhile only
   if C244 or another already-bounded task supplies enough exact consequences to make a compact
   theorem package: the gate law, inert spanning seeds, the exceptional q=9 saturation switch,
   and the literature boundary. C243 alone is probably better used inside the main paper.
3. **Conditional future paper: random gated cascades.** This has the highest speculative ceiling,
   but it is not yet a paper result. It becomes a paper only after obtaining genuine asymptotic
   control of SQS spreading or a threshold law. Finite q=9 tables, first moments, and generic
   sharp-threshold citations do not cross that gate.
4. **Not currently supported: a propagation-completeness paper.** C243 compares two inequivalent
   Horn theories. A SAT/knowledge-compilation paper would need a separate representation or
   equivalence theorem, not merely the inert spanning witness.

### Follow-up order

Keep the live queue order. Run C244 next because its low-cost exact propositions can strengthen
the main manuscript and determine whether the deterministic note has enough mass. Do not open a
large threshold programme during C244. After the consequence pack is assembled, a future random-
cascade item should begin with one bounded scout:

- characterize or bound deterministic spreading/subsystems in the harmonic SQS family;
- compute enough q=9/q=27 random-closure data to identify a plausible scaling variable, without
  treating it as asymptotic evidence;
- search once more for SQS-specific random-seed work; and
- continue only if a proof route gives more than a first-moment heuristic.

Thus the operational decision is: **bank the deterministic theorem now; consolidate through C244;
test probability later behind a new task gate.**

## What scales

The strict inert-versus-span separation is not confined to q=9. In any `S(3,4,v)`, two distinct
blocks meet in at most two points, so a five-set contains at most one block. Since the number of
blocks is `v(v-1)(v-2)/24`, the fraction of five-sets containing a block is

```text
[v(v-1)(v-2)/24 * (v-4)] / binom(v,5) = 5/(v-3).
```

Putting `v=q+1`, the block-free fraction is `(q-7)/(q-2)`, positive for every `q>=9`.
Every five curve points of a normal rational quartic are independent, so every such block-free
five-set is an inert rank-five spanning seed. Therefore, for every `q=3^h>=9`, there exists
`S_q subseteq X` with

```text
|S_q|=5,          L_4(S_q)=S_q,          cl_M(S_q)=X union {N}.
```

This is an existence proof by exact counting, not a uniform closed formula for the five
parameters. The certificate replays the counts `72/252` at q=9 and `78624/98280` at q=27.

The stronger one-round switch does **not** scale with five seeds. A five-set has only ten triples,
and hence can expose at most ten distinct missing curve points in its first design round. It would
need to expose `q-4` points. Thus one-round completion from five curve seeds is impossible for
`q>14`, in particular for every next field in the family beginning at q=27. The q=9 switch is
therefore exact and exceptional; the all-field theorem is the inert-versus-span separation.

## Horn and propagation-completeness boundary

The rule set is the definite Horn CNF

```text
Sigma_4 = {(C minus {e}) -> e : C={N} union B, e in C, B in H_q}.
```

Forward chaining computes `L_4` exactly. Bérczi--Boros--Makino prove that when **all** matroid
circuits are used, the associated matroid Horn closure equals matroid closure; they also study
which circuit subfamilies still represent that same Horn function
([arXiv:2301.06642](https://arxiv.org/abs/2301.06642)). C243 is deliberately on the other side:
`Sigma_4` omits longer circuits and does not represent the full matroid Horn function, as the
spanning inert seed proves.

This is not itself a counterexample to propagation completeness. Propagation completeness asks
whether unit propagation derives every literal semantically entailed by an **equivalent** CNF
after every partial assignment; the standard definition and complexity results are in
Babka--Balyo--Čepek--Gurský--Kučera--Vlček
([DOI 10.1016/j.artint.2013.07.006](https://doi.org/10.1016/j.artint.2013.07.006)), building on
Bordeaux--Marques-Silva's empowerment formulation
([DOI 10.1007/978-3-642-27660-6_50](https://doi.org/10.1007/978-3-642-27660-6_50)). Here the
bounded and full theories are inequivalent before that question is asked. The owned statement is
bounded positive forward-chaining incompleteness relative to linear span, not SAT propagation
incompleteness.

## Spreading-set and bootstrap boundary

Nagy--Szemerédi define spreading closure in a Steiner triple system by the two-to-one rule, call
a seed spreading when its closure is the whole point set, and call one-round spreading seeds
saturating. Their results are deterministic and extremal, and are specific to triple systems
([arXiv:2103.00922](https://arxiv.org/abs/2103.00922)). The correct translation here is:

- with `N` live, `D` is the three-to-one analogue on a Steiner quadruple system;
- `S_9` is both spreading and one-round saturating for that SQS rule;
- with `N` absent, the same seed is frozen because the external gate prevents even the first
  SQS step.

General hypergraph bootstrap percolation already uses exactly the rule “infect the unique
uninfected vertex of a hyperedge,” so the ungated SQS process belongs to that established model
([Balogh--Bollobás--Morris--Riordan, arXiv:1107.1410](https://arxiv.org/abs/1107.1410)). The
bounded source and citer searches found no paper treating random initial seeds on Steiner
quadruple systems with an external common gate. That is a defensible search result, not a
novelty theorem; “spreading sets,” “bootstrap percolation,” and “propagation completeness” must
all be cited rather than claimed as new language.

The full-text reads used cached copies with SHA-256
`d08f901383a76f250f42e0a1eb5586c9b88beee6922cb227fb288bff237a8d8d`
(Nagy--Szemerédi) and
`a7150e01acd2f4bf86454bdc11bad436f29832d38ea749e95b072b02e7cae0d5`
(Bérczi--Boros--Makino).

## Threshold decision

Let curve points survive independently with probability `p`, and let the nucleus survive
independently with probability `theta`. For the random curve seed `S_p`, the gate law gives the
exact decomposition

```text
Pr(full cascade)
  = theta * Pr(D(S_p)=X)
    + (1-theta) * Pr(D(S_p)=X and S_p contains a block).
```

This is the right random nucleus-gated problem. A homogeneous model silently sets `theta=p` and
can hide the bottleneck; the two-parameter model preserves it. Exact q=9 reliability or the
one-round switch supplies no asymptotic threshold evidence, and the fixed five-seed mechanism is
provably unavailable from q=27 onward.

**Decision: GO, but only as a separate bounded probability task.** The infinite harmonic SQS
family and exact gate decomposition make the question coherent, while the literature read leaves
the SQS random-seed/gated case visibly open. Any future task must first determine or bound the
ungated spreading probability `Pr(D(S_p)=X)` and the conditional block-gate term; it must stop if
an SQS-specific threshold source is found or if no asymptotic control beyond first moments is
obtained. C243 itself claims no threshold location, limit law, or sharpness theorem.

## Verification

[`2026-07-17-c243-nucleus-gated-separation-vet.py`](2026-07-17-c243-nucleus-gated-separation-vet.py)
imports the committed C218 field/design implementation and checks:

- the q=9 block-free rank-five seed and inert closure;
- exact one-round completion after adjoining `N`, including the two-to-one triple completion map;
- the block-free five-set formula at q=9 and q=27;
- rank-five spanning for the selected block-free witnesses; and
- the ten-target counting obstruction at q=27.

The machine-readable output is
[`2026-07-17-c243-nucleus-gated-separation-vet.json`](2026-07-17-c243-nucleus-gated-separation-vet.json).
The original C218 and C236 verifiers were also replayed byte-for-byte against their committed JSON
certificates.
