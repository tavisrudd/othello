# C1062 probe 5: Evolve proposes the abstraction, and the separating intervention is not the better counterexample

**Lane**: `complete-ports`
**Task**: C1062, probe 5
**Plan**: `2026-09-04-c1062-exploration-log.md`
**Inputs**: probe 1 for the lowering, the compiled quotient on exogenous contexts, and its
direct-enumeration oracle; the plan review's three corrections to this probe (kernel-equality
fitness, recovery up to reparameterization, and the requirement for a random-counterexample arm);
C1016's blinding discipline for the planted control.
**Code**: `ergodis-private` `632c7b4` (`src/causal_abstraction.rs`, fixtures in
`src/causal_fixtures.rs`, `tasks/tools/src/causal_abstraction_report.rs`)
**Replay**: `cargo run --release --package ergodis-tools -- causal-abstraction-report --seeds 12
--rounds 30 --patience 25 --generations 300 --max-candidates 200000`
**Evidence**: `ergodis-private` `evidence/2026-09-04-causal-abstraction-arms.txt` (the measurement)
and `evidence/2026-09-04-causal-abstraction-full-sample-reach.txt` (the reach diagnostic). The run
is deterministic: a second run reproduced every figure below exactly.
**Predeclared threshold**: seals to the exact kernel, and beats the random-counterexample arm on
generations.
**Verdict**: **first half met, second half refuted.** The loop seals — it recovers the planted
abstraction exactly, up to reparameterization, on the families inside its reach. The separating
intervention is *not* a better counterexample than a uniformly sampled violated pair: on the
largest family that seals reliably it is **worse**, at `0.770x` (the random arm needs 0.770 times
the rounds, i.e. the separator arm takes about 30% more). The diagnosis is that a separating
intervention is a one-sided oracle, and the diagnostic arm that repairs the one-sidedness lands
back on the random arm at `0.967x`.

## 1. What the loop is

A planted family is a finite causal model whose exact quotient on exogenous contexts is a known
arithmetic function of the exogenous coordinates. The search never sees that function. It sees a
blinded corpus: every context's exogenous digits, permuted by a seed-dependent permutation, named
`f0 … f{k-1}`, padded with decoy coordinates that no mechanism reads, with no class label and no
hint about which coordinates matter.

Each round, a bounded evolution run over straight-line arithmetic terms (`Input`, `Constant`, `Add`,
`Sub`, `Mul`, `Mod`, from the core's `feature_dag` node set) proposes a term `phi`. The exact engine
then compares `ker phi` against the compiled quotient over **every** context. On disagreement it
returns one counterexample, which is added to the corpus, and the next round begins. Sealing means
exact kernel equality.

Two things follow the plan review's corrections and are worth stating because they are what make
the measurement mean anything. Fitness is a **partition distance**, not a label regression: a term
is scored by how many sampled context pairs it merges or separates against the quotient, so the
search is never chasing a label permutation. And success is judged **up to reparameterization**,
since kernels are compared and not values.

Four arms differ in the counterexample and in nothing else — same blinding, same seeds, same
mutation stream, same starting sample of six contexts:

1. **random pair** — a uniformly sampled violated pair, taken by reservoir in one pass.
2. **separator pair** — among the *over-merged* pairs, the one whose minimal separating intervention
   is shortest. This is the arm the brief's claim is about.
3. **separator partition** — that same pair, plus the whole observation partition the separating
   intervention induces over all contexts, which the term must refine. This is the sound constraint
   one certificate actually carries, rather than the single pair.
4. **separator within kind** — a diagnostic arm added *after* the first three were measured, to
   explain what they measured. It samples the *kind* of violation uniformly, exactly as the random
   arm does, and only then applies the separator rule among the over-merged pairs.

Arms one to three were predeclared. Arm four was not, and is labelled diagnostic everywhere it
appears; it is not judged against the thresholds.

## 2. The families, the ground truth, and the predeclarations

Each family has two groups of binary sources reduced by a weighted sum, feeding one observed
variable `Y = (A + B) mod domain`. Only `A` and `B` are intervenable, at arity one. Pinning `A`
exposes `B` and pinning `B` exposes `A`, so the exact quotient is the joint kernel of the two group
reductions — strictly finer than the observation partition `ker((A + B) mod domain)`. That is what
makes the intervention do work rather than decorate the setup.

| family         | contexts | classes | decoys | states | predicted | planted coordinates              |
|----------------|----------|---------|--------|--------|-----------|----------------------------------|
| pair counts    | 32       | 9       | 1      | 224    | separator | the two pair sums, `3A + B`      |
| pair parities  | 32       | 4       | 1      | 160    | wash      | the two pair parities, `2A + B`  |
| group counts   | 256      | 16      | 2      | 2,304  | separator | the two group sums, `4A + B`     |
| group parities | 256      | 4       | 2      | 1,280  | wash      | the two group parities, `2A + B` |
| group residues | 1,024    | 25      | 4      | 11,264 | separator | the two weighted residues mod 5, `5A + B` |

The predeclarations, entered in the fixture source before the run: the separator arms seal in at
most `0.8x` the random arm's rounds on the three count and residue families, and the two parity
families are a wash within `1.1x` because four classes leave too few violated pairs for the choice
to matter. Every threshold is judged as a ratio of medians over the seeds where **both** arms
sealed; a capped unsealed run has no round count to compare, and averaging the cap in would flatter
whichever arm failed more often.

The ground truth passes three independent routes on every family: the signature table built by
direct enumeration of pinned assignments, the compiler's own `root_classes` under the
`SplitTranscript` policy, and the planted term's kernel all agree, and the class count matches the
predeclared one.

## 3. The measurement, twelve seeds per family and arm

| family         | arm                   | sealed | mean rounds | median | mean gens | sample | unfit | merge | split | fallback | vs random |
|----------------|-----------------------|--------|-------------|--------|-----------|--------|-------|-------|-------|----------|-----------|
| pair counts    | random pair           | 12/12  | 5.0         | 5.0    | 153       | 12.3   | 0.0   | 44    | 4     | 0        | —         |
| pair counts    | separator pair        | 12/12  | 5.4         | 5.5    | 171       | 10.4   | 0.0   | 53    | 0     | 0        | 1.000x    |
| pair counts    | separator partition   | 12/12  | 3.3         | 3.0    | 111       | 8.4    | 0.0   | 25    | 3     | 3        | **1.667x**|
| pair counts    | separator within kind | 12/12  | 5.1         | 5.0    | 160       | 10.4   | 0.0   | 43    | 6     | 6        | 1.000x    |
| pair parities  | random pair           | 12/12  | 7.0         | 8.0    | 279       | 14.9   | 0.0   | 34    | 38    | 0        | —         |
| pair parities  | separator pair        | 12/12  | 7.9         | 8.5    | 307       | 13.1   | 0.0   | 71    | 12    | 12       | 0.889x    |
| pair parities  | separator partition   | 12/12  | 6.3         | 6.0    | 237       | 12.0   | 0.0   | 32    | 32    | 32       | 1.000x    |
| pair parities  | separator within kind | 11/12  | 7.2         | 7.5    | 255       | 13.2   | 0.7   | 42    | 34    | 34       | 1.000x    |
| group counts   | random pair           | 11/12  | 14.7        | 14.0   | 586       | 31.8   | 13.4  | 64    | 101   | 0        | —         |
| group counts   | separator pair        | 10/12  | 19.4        | 18.5   | 738       | 27.5   | 11.5  | 196   | 27    | 27       | **0.770x**|
| group counts   | separator partition   | 1/12   | 27.9        | 30.0   | 856       | 9.2    | 103.2 | 334   | 0     | 0        | n/a       |
| group counts   | separator within kind | 11/12  | 15.3        | 15.0   | 603       | 24.2   | 3.2   | 115   | 58    | 58       | 0.967x    |
| group parities | random pair           | 5/12   | 25.8        | 30.0   | 1,218     | 50.9   | 178.4 | 146   | 159   | 0        | —         |
| group parities | separator pair        | 4/12   | 20.1        | 19.0   | 840       | 23.8   | 33.9  | 221   | 16    | 16       | n/a       |
| group parities | separator partition   | 0/12   | 30.0        | 30.0   | 966       | 10.9   | 68.3  | 356   | 4     | 4        | n/a       |
| group parities | separator within kind | 5/12   | 21.2        | 19.5   | 928       | 33.2   | 64.2  | 120   | 130   | 130      | n/a       |
| group residues | random pair           | 0/12   | 30.0        | 30.0   | 1,247     | 63.8   | 139.9 | 109   | 251   | 0        | —         |
| group residues | separator pair        | 0/12   | 29.9        | 30.0   | 1,229     | 37.7   | 38.8  | 353   | 6     | 6        | n/a       |
| group residues | separator partition   | 0/12   | 30.0        | 30.0   | 903       | 8.0    | 129.0 | 360   | 0     | 0        | n/a       |
| group residues | separator within kind | 0/12   | 30.0        | 30.0   | 1,259     | 53.3   | 77.8  | 143   | 217   | 217      | n/a       |

`sample` is the mean number of contexts in the corpus when the run ended, `unfit` the mean corpus
violations of the term the last round proposed (clamped at 9,999 for display), `merge` and `split`
the total rounds refuted by an over-merge and by an over-split, and `fallback` the rounds in which a
separator arm found no over-merge and fell back to the random rule. A ratio above one means the
separator arm sealed in fewer rounds.

Against the predeclarations: **every family missed.** `pair counts` and `group counts` predicted a
separator win and got `1.000x` and `0.770x` from the separator-pair arm; `pair parities` predicted a
wash and got `0.889x`, just outside the `0.909–1.1` band; `group parities` and `group residues`
predicted a win but seal too rarely for a ratio to mean anything.

## 4. Why the separating intervention loses: it is a one-sided oracle

The merge and split columns say it plainly. On `group counts` the random arm's refutations are 64
over-merges and 101 over-splits; the separator arm's are 196 over-merges and 27 over-splits. The
separator rule prefers an over-merged pair whenever one exists, and one almost always exists, so the
learner is told over and over that its term is too coarse and almost never told that it has become
too fine. It walks past the target from the coarse side and then keeps refining.

This is not a tuning artifact of the selection rule; it is structural. A separating intervention is
a witness that the quotient **separates** two contexts. There is no corresponding compact witness
that the quotient **merges** two contexts — that fact is the absence of any separating intervention,
which is an exhaustive check over the whole intervention vocabulary. So the certificate-bearing
counterexample is available for exactly one of the two error directions, and preferring it biases
the teaching signal in that direction.

The diagnostic fourth arm isolates this. It samples the *kind* of violation uniformly, so its merge
and split counts return to the random arm's balance (115 and 58 on `group counts`, against the
separator arm's 196 and 27), and only then uses the separating intervention to pick which over-merge
to return. Its ratio is `0.967x` on `group counts` and `1.000x` on both pair families — that is, it
is the random arm. **Once the one-sidedness is removed, the separator's choice among counterexamples
carries no measurable teaching signal at all.**

That answers the plan's question in the form it was asked. The plan review already noted that C1039
admission returns *some* counterexample on rejection, so soundness is not what is in question; what
was claimed is that separating interventions are *unusually good* counterexamples. Measured against
the arm the review demanded, they are not.

## 5. The certificate arm splits: best on the smallest family, collapses on the next

The separator-partition arm is the only arm that ever beats random, and it does so decisively on
`pair counts`: median 3 rounds against 5, a `1.667x` gain, sealing 12/12 with the smallest final
sample of any arm (8.4 contexts). One separating intervention there hands over a whole sound
refinement constraint over all 32 contexts, which is worth far more than the pair it came with.

On `group counts` the same arm seals 1/12. The reason is in its own columns: its sample stays at 9.2
contexts while its unfit measure sits at 103.2. The refinement constraints are sound — the planted
term satisfies every one of them, by construction — but no term the search can reach satisfies them,
so the round never fits its corpus, the counterexample it yields adds nothing new, and the run
stalls. **A stronger sound constraint is a better teacher only while the learner can still satisfy
it.** Past that point it converts a solvable synthesis problem into an unsolvable one, and the loop
has no way to notice, because unsatisfiability-in-budget and a genuinely wrong term look the same
from outside.

One qualification belongs with that result and is not settled here. The fitness sums sampled-pair
violations and refinement violations with equal weight, and a refinement's violation count grows
with the class count while the sample's grows with the sample size, so on the larger families the
refinement term dominates the score. Whether the collapse is intrinsic to the constraint or an
artifact of that weighting is a re-test, not a conclusion, and it is carried in the ledger below.

## 6. Recovery is exact and it is a reparameterization

On `pair counts` the sealed term and the planted term are both nine nodes and are not the same
program:

```
sealed:  n0=f3; n1=f1; n2=n0+n1; n3=n2+n2; n4=n2+n3; n5=f4; n6=n4+n5; n7=f2; n8=n6+n7
planted: n0=f4; n1=f2; n2=n0+n1; n3=f1; n4=f3; n5=n3+n4; n6=3; n7=n2*n6; n8=n5+n7
```

The sealed term builds `3A` as `A + (A + A)` where the planted term multiplies by a constant, and it
takes the groups in the other order. The kernels are identical, which is the whole point of judging
recovery up to reparameterization: an equality test on programs, or a regression on class labels,
would have scored this a failure.

Blinding held throughout: the search receives permuted opaque coordinates and no labels, and the
decoy coordinates are correctly ignored by every sealed term, since a term that read one could not
have kernel equal to a quotient that is constant along the decoy fibres.

Certificates replay: all 2,849 separating interventions consumed across the 240 runs were re-solved
against the causal model itself — not read back from the signature table — and every one separates
the pair it was returned for.

## 7. The reach envelope, and an unexpected result inside it

The reach diagnostic hands the search the *entire* quotient as its sample and asks it to fit in one
round. `pair counts` and `pair parities` seal immediately, in 44 and 101 generations. `group counts`
does not: the search plateaus at 1,840 pair disagreements out of the 32,640 pairs, about 5.6%, and
`group residues` plateaus above the display clamp.

That is a stronger statement than a reach limit, because the incremental loop **does** seal
`group counts`, 11 times in 12. Being handed the whole quotient at once is harder than being handed
six contexts and growing. The small sample admits simple terms the search can actually find, and
each added context perturbs a term that is already most of the way there; the full quotient admits
only the target, and the search cannot reach it cold. So the counterexample loop earns its keep
after all — just not through the separating intervention. Its value is the **staging**, not the
witness.

The families that never seal, `group parities` at 256 contexts and `group residues` at 1,024, mark
the synthesizer's ceiling rather than the loop's: their planted terms need two independent modular
reductions and around 13 and 21 nodes respectively, and no arm finds either.

## 8. What this decides for the brief

The brief rested weight on separating interventions being informative counterexamples, and probes 1
through 4 all used them without testing that. This probe tests it and the answer is no: with the
violation kind held fixed, a separator-chosen counterexample is indistinguishable from a random one,
and preferring separators without holding the kind fixed is actively worse. What survives is
narrower and still real. A separating intervention is a *replayable* witness, checked here 2,849
times against the model rather than the compiler, and the global partition one induces is a genuine
sound constraint that is worth `1.667x` while the learner can satisfy it. Neither of those is a
claim about search guidance, and no later probe should make one.

## 9. Mystery ledger

- **Why does the incremental sample beat the full quotient?** Measured, not explained. `group counts`
  seals 11/12 through the loop and 0/2 when handed all 256 contexts at once. The plausible mechanism
  is that a small sample has many simple consistent terms and the search climbs through them, but
  nothing here measures the density of consistent terms as a function of sample size. Open; the
  cheap test is to plot seal rate against a fixed random sample of increasing size, with no loop.
- **Is the separator-partition collapse intrinsic or a weighting artifact?** Open, stated in
  section 5. The re-test is one line: normalize each refinement's violation count against the
  sampled-pair term, rerun the same arms and seeds, and see whether `group counts` recovers. Until
  that runs, the `1/12` figure indicts the fitness weighting at least as much as the constraint.
- **Why is `pair parities` outside its own wash band at `0.889x`?** Settled as noise rather than
  effect: the separator arm's medians there are 8.5 against 8.0 rounds, a half-round difference on
  twelve seeds, and the two other separator arms sit at exactly `1.000x`. The predeclared band was
  too tight for a measure this granular, which is a lesson about the threshold, not about the arm.
- **The over-split direction has no compact witness.** This is the finding of section 4 rather than
  an open question, but it is worth flagging as a limit of the compiled object: the quotient can
  certify every separation it makes and can certify no merge it makes except by exhaustion. Anything
  downstream that wants a two-sided oracle needs something the compiler does not currently produce.
- **No genuine mystery in the sealing machinery itself.** The three ground-truth routes agree on
  every family, the run is bit-for-bit reproducible across two executions, and every certificate
  replays. The failures are all located in the synthesizer's reach and in the arm comparison, both
  of which are measured rather than inferred.

## 10. Next

Probes 6 and 9 remain. Probe 6 is `k`-ary experiment design and decision equivalence; probe 9 is the
end-to-end demonstration, gated on probes 2 and 3 and never to be counted as evidence. Probe 5 does
not block either.

Two items this probe hands forward. Probe 6's counterexample machinery should not assume separators
are the informative choice — that assumption is now refuted, and a uniformly sampled violated pair
is the baseline to beat. And any later use of the induced-partition constraint should carry the
weighting question from section 5 with it.
