# 2026-08-07 — C880: adversarial review and extra-juice pass on the alignment-separation report

**Task:** C880 (lane `clebsch`), review of
`notes/2026-08-07-c880-alignment-separation.md` against
`notes/2026-08-07-c880-literature-audit.md` and the task card
`notes/clebsch-tasks/c880-aligned-query-complexity.md`. Read-only on everything
except this file. No sub-agents. The report, the manuscript, Lean, and the card
are untouched.

**What this review recomputed independently** (fresh Python, different
representation from both the Rust generator and the numpy replay): the six-point
witness pair and its aligned family; the full six-point collision census
(462 distinct vectors, 46 groups, 96 pairs, 6 empty-family pairs); seven-point
faithfulness over all 16384 pairs; the exact quarter marginal of every test; the
aligned-count distribution at seven and eight points to all digits of both
`stats` certificates; separation of both optimal 30-test orbits, of the paper
family (31), of the paper family minus its anchor (30); failure of the
triangle-anchor family (22); the 315 weight-two difference patterns and — by an
exact branch-and-bound — that the largest mask-free set at seven points is 5,
so the weight-two route alone gives exactly 30; and, closing the one headline
number no replay covered, that the search certificate's 44-test family at eight
points separates all 2^20 complement pairs. Every number checked in the prose
agrees with its certificate; no discrepancy was found anywhere.

**Verdict in one paragraph.** The computational core is solid and better than
the report knows: two of its claims can be upgraded to proofs (pairwise
independence of the tests, and per-pair forcing of the K4 link, both below).
The serious defects are concentrated where measurement ends and inference
begins: the entropy bound is applied to adaptive decoders, where it is invalid
— the report's own greedy mean already sits below it — and section 8.3's
estimation claim transfers relative error through an affine map at exactly the
point where the map cancels, so the fourth-moment estimator and the
"detects conference-like structure" reading both fail for typical and for large
inputs respectively. The framing of sections 7 and 8 is right and should stay;
the applications hunt below replaces the lane's bare prior with three named
negatives and finds one genuinely new adjacent literature (vanishing tetrads)
that the audit did not cover.

---

## 1. Adversarial findings, ranked

### 1.1 INVALID AS STATED: the entropy bound does not apply to adaptive decoders

The subadditivity chain in section 5 uses the *unconditional* marginal of a
*fixed* test: each answer is Bernoulli(1/4), so each contributes at most
H(1/4) bits. For an adaptively chosen test that premise fails: the answer's
distribution conditioned on the transcript so far is whatever the posterior
makes it, and the greedy decoder *by construction* drives it toward 1/2 —
that is what "splitting the surviving candidates most evenly" means. Each
adaptive answer can carry up to a full bit, so the only floor that survives
adaptivity is the counting bound: worst case and mean at least 14 at seven
points and 20 at eight, not 18 and 25.

Three places in the cluster assert the false transfer:

- section 5, closing sentence: "the entropy bound, which applies to both
  models";
- section 6: "the entropy bound of section 5 lower-bounds it by 18 and 25
  respectively, and both bounds apply to adaptive and nonadaptive decoders
  alike", plus the table column placing 18 and 25 as floors under the adaptive
  numbers;
- both `adaptive` certificates embed `entropy_lower_bound` in the adaptive
  artifact.

The report refutes itself twice without noticing. First, the greedy adaptive
mean is 15.61 at seven points — below the claimed adaptive floor of 18. (No
contradiction is visible in the worst case, 22 and 30, but the floor is
unproven there too.) Second, section 5's own next paragraph sketches an
adaptive decoder needing about \(\binom{n-1}2\approx0.5n^2\) tests, which is
*below* its claimed adaptive bound \(0.616n^2\); the sketch is plausible
precisely because the bound does not apply. The "within a factor 1.6 of the
entropy bound" in that sentence is also arithmetically wrong in any reading I
can construct (\(0.616/0.5=1.23\), and the sketch sits under, not over).

The task card has this right: "The counting bound applies to both." Fix: the
entropy bound is a *nonadaptive* lower bound; adaptive floors are 14 and 20;
the open question of whether an adaptive decoder can beat \(0.616n^2\) is
genuinely open and the sketch is aimed at exactly that.

### 1.2 WRONG FOR TYPICAL INPUTS: section 8.3's relative-error claim for the fourth moment

The affine law is (constant re-derived here, and checked against the order-10
conference matrix, where it gives 30 aligned four-sets in agreement with the
3-design formula):

\[
\operatorname{tr}(A^4)\;=\;n(n-1)(2n-3)\;+\;32\Bigl(a-\tfrac14\binom n4\Bigr),
\]

with \(a\) the aligned count. At the exact quarter mean the four-set term
*cancels*, so the typical fourth moment is \(n(n-1)(2n-3)\approx2n^3\), while
the lever arm of the density is \(32\binom n4\approx\tfrac43 n^4\). Estimating
the density to additive \(\varepsilon\) — which is what \(O(\varepsilon^{-2})\)
samples buy — gives \(\operatorname{tr}(A^4)\) to additive
\(\Theta(\varepsilon n^4)\). That is a *relative* error only when
\(\operatorname{tr}(A^4)=\Theta(n^4)\), i.e. when the Seidel spectrum has an
eigenvalue of order \(n\). For typical two-graphs
(\(\operatorname{tr}(A^4)=2n^3\pm\Theta(n^2)\), by the exact variance in §3.1
below) relative-\(\varepsilon\) estimation needs \(\Theta(n^2\varepsilon^{-2})\)
samples. The sentence "\(O(\varepsilon^{-2})\) draws give the density, hence
the fourth moment, to relative error \(\varepsilon\)" is false as written; the
correct statement is: constant samples estimate the density additively, hence
the *centered* fourth moment at scale \(n^4\), hence detect an eigenvalue of
linear order — and nothing finer.

### 1.3 FAILS ASYMPTOTICALLY: the "detects regularity-like structure" reading, provable from the card's own design fact

The card states that a symmetric conference matrix's aligned four-sets form a
\(3\text-(2d,4,(d-3)/2)\) design. Then the aligned count is
\((d-3)\binom{2d}3/8\), and its ratio to the quarter mean is
\(2(d-3)/(2d-3)\to1\) with gap \(\Theta(1/n)\). So conference two-graphs do
**not** stay "at the bottom of the range": their aligned density tends to the
universal quarter, and a sampling tester needs \(\Theta(n^2)\) four-set draws
to resolve a \(\Theta(1/n)\) density gap — at which cost one could read all
\(\binom n2\) signs. The order-six emptiness and the small-\(n\) extremes in
the `stats` tables are small-case artifacts of exactly the kind the report's
own "small-case fact, not evidence" paragraph warns about, applied one section
later to itself. What a constant-sample tester genuinely detects is a density
gap of order one, i.e. \(\operatorname{tr}(A^4)=\Theta(n^4)\), i.e. a
\(\Theta(n)\) Seidel eigenvalue — the complete two-graph qualifies, conference
matrices do not. (Population-statistically the conference *is* extreme — about
\(\Theta(n)\) standard deviations below the mean by §3.1 — but sampling noise,
not population spread, sets the tester's resolution.)

### 1.4 OVERSTATED: the four-percent price has an unproved sign

Two sides of the ratio need care.

- The value-oracle baseline of 15 and 21 is *right*, and stronger than the
  report claims: it holds even adaptively and even for the pair target. Proof
  sketch, worth recording: the all-ones two-graph vanishes on no triple, so the
  kernel of restriction-to-queried-triples never contains it; after any
  \(\binom{n-1}2-1\) value queries of independent triples the two surviving
  candidates differ by a non-complement element, hence lie in *distinct*
  complement pairs, and a further query is forced. Value queries cannot exploit
  the complement quotient. So 15 and 21 are exact adaptive optima, worst case
  and mean.
- But the greedy mean is only an *upper bound* on the optimal adaptive
  alignment mean, whose floor is the counting bound 14 and 20. So the mean
  price of the coherence restriction is bracketed in \([14/15,\,15.61/15]\) at
  seven points — between roughly \(-7\%\) and \(+4\%\) — and its *sign is not
  established*. Because the alignment bit is complement-invariant and the value
  bit wastes one bit on the gauge, it is conceivable that the coherence oracle
  is *cheaper on average* than the value oracle for the pair target. "Costs
  about four percent" should read "costs at most about four percent, and
  conceivably less than nothing".

The same gauge observation gives the one theoretical sense in which the
four-set oracle can beat the triple oracle: any complement-invariant one-bit
oracle has floor \(\binom{n-1}2-1\), one below the triple oracle's proved
\(\binom{n-1}2\). A saving of exactly one query, settled by the definition —
this is the sharp version of section 8.1's invariance point, and the honest cap
on section 7's "solved at the optimum immediately" (right up to one query).

### 1.5 WRONG EXPLANATION: the anchor-drop rationale contradicts the model measured

Section 3: the anchor test's redundancy "is also the expected drop, since the
decoder is *given* that the anchor is aligned and so learns nothing by testing
it." But the certification section states separation is *unconditional* — no
promise that any four-set is aligned — and the promised-anchor variant is
explicitly "a different, smaller problem and is not measured here." In the
unconditional problem the anchor's answer is an ordinary informative bit. The
redundancy is a measured fact; the offered reason belongs to the unmeasured
variant. Cut or rewrite the sentence.

### 1.6 OVERCLAIMED RELATIVE TO THE AUDIT: one first-ness sentence

Section 6: "it is not a statement anyone has been in a position to make,
because the model had not been defined." That is a priority claim without the
audit-mandated "to our knowledge", and the audit's negative for exactly this
cluster is bounded by unread canonical sources (Rényi, Katona, Aigner), an
unsearched body (Boolean sensitivity/certificate complexity, the natural home
of the D(iii)-adjacent material), and the two inaccessible Seidel surveys.
Hedge it.

### 1.7 Minor

- **8.1** "precisely the invariant of the group generated by switching and
  complementation" needs \(|V|\ge7\); at six points section 1's own collisions
  show the aligned family is not a complete invariant.
- **8.2** "recover the two-graph in \(O(n^2)\) work" is uncited and
  uncertified; the certificates measure separation, never decode time.
- **Section 4** "Its search was capped and did not complete" has an ambiguous
  antecedent. The certificate resolves it: the weight scan is recorded complete
  to weight 4 (`masks_by_weight [0,0,0,0,315]`), while
  `mask_free_search_complete: false` with `largest_mask_free_set: 40` is the
  capped search. The prose should name which; as written a reader can doubt
  the flat "none of weight two or three" claim, which the certificate does
  support.
- **Bracket provenance**: `bounds8.json` records `lower_bound: 20` (counting);
  the 25 in the prose bracket is the analytic entropy bound and is certified
  nowhere mechanically. Fine, but worth a sentence in the report's
  certification list.
- **Missing mystery ledger.** The card's acceptance list requires one; the
  report has none. Candidate rows are in §3.4 below.

---

## 2. Attacked and held

Things this review tried to break that did not break, beyond the recomputations
listed in the header:

1. **The complement quotient in the entropy bound.** The answer vector is a
   function of the pair, determines the pair, and the target entropy used is
   \(\binom{n-1}2-1\), the pair entropy — correct on all three counts. The
   constants 1.2326, 18, 25, and \(0.616n^2\) all check, as does every entry of
   the 8.2 table including the entropy floors at 9, 16, 32, 64.
2. **The quarter marginal.** Exact, for every test, at every \(n\ge4\), by the
   report's own restriction argument (restriction to four points is a
   surjective linear map, so uniform); family-independence is automatic because
   the marginal is per-test. Verified exactly at \(n=7\) here.
3. **The seven-point exactness.** Three routes in the report plus the numpy
   replay plus this review's independent census-consistency checks; and the
   weight-two route is now confirmed *exactly* tight — branch-and-bound gives
   max mask-free set 5, bound 30, matching the census.
4. **"Exactly one removable 5-set per removable 4-set."** The parenthetical
   \(56\times5=280\) does not prove it alone (double-covering plus
   non-covering could balance), but the orbit descriptions close the gap in two
   lines: no two of the 56 removable five-test-sets share four tests
   (orbit-1/orbit-1 intersect in at most one test since two five-point sets
   share at most one four-subset; orbit-2/orbit-2 in at most two; mixed in at
   most three). So the 280 four-test subsets are distinct, cover all 280
   removable four-test-sets, and the "every separating 31-family has exactly
   one further redundant member" corollary is airtight.
5. **The sensitivity rule.** Re-derived from scratch: \(\delta_{xy}\) is a
   valid two-graph perturbation; the test on \(\{p,q,x,y\}\) flips exactly when
   \(\tau(pxy)=\tau(qxy)\) (parity law forces the other two triples equal, so
   alignment toggles); every two-colouring \(\chi\) is realizable by some
   two-graph; hence bipartite link \(\Rightarrow\) an undetected perturbation,
   and non-bipartite link \(\Rightarrow\) detection at every two-graph. The
   necessity claim and its logic are correct, and the not-sufficient side is
   properly carried by the measured triangle-anchor failure (re-verified).
6. **Greedy as an upper bound.** The report says plainly that the greedy tree
   upper-bounds the adaptive optimum and is not the optimum; the seven-point
   separation (22 adaptive vs 30 exact nonadaptive) is sound, and the
   eight-point "consistent with but not establishing" hedge is right.
7. **Section 7's triple identity and foreclosure.** The identity is the
   four-set parity law read at \(\{r,i,j,k\}\); the triples through a point
   number \(\binom{n-1}2\); the foreclosure of a query saving is via the
   counting bound, which is oracle-independent for one-bit queries — valid,
   with the one-query gauge caveat of §1.4.
8. **K4 forcing, upgraded.** The report's sweep fixes one link subgraph \(R\)
   uniformly across outside pairs, so "the six tests per outside pair are
   forced within the single-anchor shape" outran its evidence — mixed per-pair
   assignments were untested. This review ran the mixed sweep at seven points:
   all \(23^3-1\) assignments of non-bipartite link subgraphs to the three
   outside pairs, other than all-\(K_4\), fail to separate (bipartite choices
   are excluded by the proved necessary condition). So the claim is *true at
   seven points in the stronger per-pair sense*, and the minimum total link
   weight over the shape is exactly \(6\cdot\binom{n-4}2\) there. The
   eight-point analogue (\(23^6\) assignments over six outside pairs, feasible
   via the same base-projection/difference-mask reduction used here) remains
   untested and is the cheap way to finish the claim as stated.

---

## 3. Free upgrades found during review (provable now)

### 3.1 The alignment tests are pairwise independent, and the count variance is exactly \(3\binom n4/16\)

Any two distinct alignment tests are independent under the uniform two-graph,
for every \(n\) large enough to contain their union. Sharing at most two
points: the joint restriction is uniform on the product (realize the two
four-point classes on disjoint edge supports). Sharing a triple: the four
linear forms — \(\tau(abc)+\tau(abd)\), \(\tau(abc)+\tau(acd)\),
\(\tau(abc)+\tau(abe)\), \(\tau(abc)+\tau(ace)\) — involve five triples with
independent evaluations (no subset of them assembles a four-set parity law, as
each law needs all four triples of one four-set), so the forms are linearly
independent and both-aligned has probability exactly \(1/16\). Verified
empirically here at \(n=7\) for both overlap types.

Consequences, all matching the certificates to every digit:
\(\operatorname{Var}(\#\text{aligned})=3\binom n4/16\) exactly
(\(6.5625=3\cdot35/16\), \(13.125=3\cdot70/16\)); relative spread
\(\sqrt{3/\binom n4}=\Theta(n^{-2})\) — which turns 8.3's "0.29 and 0.21 and
falling" from a two-point extrapolation into a closed form (0.2928 and 0.2070
predicted); and the mean fourth moment is exactly \(n(n-1)(2n-3)\). It also
says the entropy bound's per-test information accounting cannot be improved by
any pair-correlation correction — the tests are as independent as they could
be, which is worth one sentence next to the bound.

### 3.2 The weight-four route at eight points can be finished exactly, and might lift the bracket

`bounds8.json` records a mask-free set of 40, search incomplete. The exact
maximum is a 70-variable ILP with 315 constraints of the form "at most three of
these four removed" — trivially exact for any MILP or SAT solver. The bound
\(70-\max\) is valid regardless of higher-weight masks. If the maximum is 40,
the nonadaptive bracket improves from \(25\le\min(8)\le44\) to
\(30\le\min(8)\le44\); if it is 45 or more the route dies cleanly. Either
outcome is worth having and costs minutes. (The seven-point analogue computed
exactly here gives 5, reproducing the tight 30.)

### 3.3 Conference asymptotics as a stated sentence

§1.3's computation — conference aligned density
\(\tfrac14\bigl(1-\Theta(1/n)\bigr)\), sitting \(\Theta(n)\) population
standard deviations below the mean yet needing \(\Theta(n^2)\) samples to
detect — is provable now from the design parameters the card already states,
and is the correct replacement for 8.3's conference sentence.

### 3.4 Mystery-ledger rows the report should carry

- **The 315/315 coincidence.** Weight-two difference patterns at seven points:
  315. Weight-four difference patterns at eight points: 315. Same count at
  consecutive sizes for different weights, unremarked. A lifting mechanism
  (each seven-point weight-two pair extending to an eight-point weight-four
  pair through the added point) is checkable finitely and would be the seed of
  the structural lower bound the report's "Next in this task" asks for.
- **Parity of the aligned count.** At seven points the count is always odd
  (histogram supported on 5,7,9,11,13,17,19,25,35); at eight points both
  parities occur. A mod-2 invariant at \(n\equiv3\pmod4\), or an accident?
- **Near-palindromic removability levels.** 35, 280, 560, 280, 56 — the level
  sequence almost mirrors and does not; and 280 appears at levels two and four.
- **Gaps in the seven-point histogram** (no 15, 21, 23; top values
  \(21\cdot k\)-shaped: 210, 105, 21, 1) — the upper tail begs for an
  orbit-counting explanation.

---

## 4. Extra juice, part one: the applications hunt (work item 8, pushed harder)

Standard applied per the card: name the oracle, name what the field actually
consumes, verdict real or vacuous. The summary first: **the lane's prior
survives — no located setting has the four-set alignment bit as its primitive —
but it is upgraded from a prior to a grounded negative by three named
near-misses, and one genuinely new adjacent literature turns up that the audit
did not search.**

### 4.1 Z2 lattice gauge theory and stabilizer measurement — real baseline, negative, and it strengthens section 7

The switching gauge of a Seidel matrix *is* the gauge group of a Z2 lattice
gauge theory with spins on edges of \(K_n\): vertex flips are gauge
transformations, and the gauge-invariant observables are Wilson loops. The
one-bit gauge-invariant coherence measurement that exists as laboratory
practice is the plaquette (stabilizer) readout — in the toric code, measuring
\(B_p\) returns exactly the one-bit frustration of a face. On a complete graph
the minimal loop is the triangle, so the physically realized primitive is
*precisely the triple observable* \(\tau(ijk)\) of section 7. The alignment
bit, in this language, is "both quadrilateral Wilson loops of the four-set are
trivial" — a conjunction of two loop observables that no apparatus reports
without being able to report the loops separately. Verdict: real comparison,
negative, and valuable: section 7's "the lane knows no reason why anything
would" respond to four-point but not three-point coherence can cite the fact
that the standard physical realization of one-bit gauge-invariant coherence is
per-face, i.e. per-triangle. The 8.4 tetrahedral-plaquette paragraph should
absorb this: when face frustration *is* the observable (gauge theories,
stabilizer codes), it arrives per-face, not per-tetrahedron.

### 4.2 Vanishing tetrads and algebraic statistics — the new adjacency, and an audit gap

For a sign matrix the three pairing products \(P_1=s_{ij}s_{kl}\),
\(P_2=s_{ik}s_{jl}\), \(P_3=s_{il}s_{jk}\) multiply to \(+1\), and the four-set
is aligned exactly when \(P_1=P_2=P_3\) — that is, exactly when all three
*tetrad differences* \(P_a-P_b\) vanish. So the alignment test is the "does
this four-set pass every tetrad test" bit, the \(\mathbf F_2\)/gauge
idealization of Spearman's vanishing tetrads. And in that field the per-4-set
bit *is* what algorithms consume: confirmatory tetrad analysis (Bollen–Ting)
tests selected tetrad constraints and explicitly wrestles with *redundant
tetrads and non-redundant subsets*; FindOneFactorClusters-style causal
discovery consumes tetrad pass/fail verdicts; and Drton–Sturmfels–Sullivant's
algebraic factor analysis studies the tetrad ideal and its generating sets —
the value-analogue of "which alignment tests suffice". Caveats stated plainly:
there the covariances are observable, so the bit is derived rather than
primitive; the setting is Gaussian, not \(\mathbf F_2\); and nobody minimizes
an adversarial query count. Verdict: not an application of the oracle, but the
strongest external framing hook this review found — "minimal non-redundant
families of tetrad constraints" is a studied question with named references,
and Paper III's separating-family results are its exact analogue for the
sign/two-graph case. **Audit consequence:** no tetrad, factor-analysis, or
algebraic-statistics body was searched by the C880 audit; its "no located
predecessor" verdicts for the four-set-indicator idea are additionally bounded
by that unsearched body. A bounded OpenAlex screen on "vanishing tetrad" /
"tetrad constraint" terms should run before item 7 wording lands.

### 4.3 DPPs with a Seidel-affine kernel — the engineered oracle exists, and triples still win

If a determinantal point process kernel has the form \(\alpha I+\beta S\) with
\(S\) Seidel, its four-point marginals take exactly two values (gap
\(8\beta^3(\alpha-\beta)\)), so a coarse sample-based estimate of a four-set
co-occurrence marginal *is* the alignment bit — the one constructed setting
where the oracle arises from measurements. But the same samples yield the
three-point marginals, which are also two-valued (gap \(4\beta^3\)) and are
the triple oracle outright, while the pairwise marginals are constant
(\(\alpha^2-\beta^2\)) and carry nothing. So even in the best-engineered DPP
the finer observable rides along free and section 7's argument closes the
door; and, as the audit already noted, query count dissolves into sample
complexity there. Named baseline: the moments-and-cycles learners
(Urschel–Brunel–Mariet–Moitra 2017; Brunel 2018). Verdict: real, negative,
worth one sentence in 8.4.

### 4.4 Synchronization and structure-from-motion consistency filtering — the deployed indicator is the triangle

Where deployed pipelines do consume one-bit coherence indicators — loop-closure
consistency checks filtering outliers in rotation averaging /
structure-from-motion — the loop tested is the triangle, and the bit is
\(\tau(ijk)\) again. Higher-order sync (Duncan–Kileel, in the audit) consumes
group-ratio tuples, not indicators. Verdict: real practice, negative for the
four-set oracle, third confirmation of triple primacy.

### 4.5 Streaming and sketching the fourth spectral moment — the survivor of 8.3, after correction

The four-set sampler is implementable against a stream of edge signs (fix the
sampled four-sets up front, collect their six signs each,
\(O(\varepsilon^{-2}\log n)\) space) and stands against a real baseline:
Schatten-norm streaming estimation is provably hard for general matrices, and
it is the two-valued-minor structure that makes naive sub-sampling unbiased
with bounded variance here. But the claim must carry §1.2's correction:
additive at scale \(n^4\), equivalently a detector of \(\Theta(n)\)
eigenvalues, not a relative-error fourth-moment estimator for typical inputs.
Verdict: real but modest; keep, corrected.

### 4.6 Vacuous or speculative, stated plainly

- **Locally testable/decodable codes:** the alignment code has vanishing rate
  (\(\Theta(n^2)\) bits in \(\binom n4\) coordinates) and minimum distance 4;
  no single \(\tau\)-bit is a function of few alignment bits (the sensitivity
  rule says recovering a pair flip needs an odd link cycle). No baseline, no
  comparison; vacuous.
- **Privacy-limited release:** a curator releasing four-set coherence bits
  while withholding triad-level data would be releasing strictly less than the
  standard released aggregate (the triad census of Holland–Leinhardt), and
  complement-invariance additionally hides the global sign — the one direction
  in which "coarser than triples" is a feature rather than a handicap. But no
  named deployment does this; speculative, at most a motivating phrase, never
  a claim.
- **Quartet methods:** agree with the audit — formal only.
- **Golden operator:** unjudged here; remains item 8's one live candidate and
  needs its own costing.

---

## 5. Extra juice, part two: the framing

**Have sections 7 and 8 found the right framing? Yes — with sharpening, and
with the wounds of §§1.1–1.4 dressed.** Rigidity and redundancy of the aligned
design is the correct sale; the audit forecloses the algorithmic one and the
applications hunt above confirms no oracle-bearing setting. The strongest
defensible two-sentence framing of the whole body of work:

> The aligned four-sets are the complete invariant of a two-graph under
> switching and complementation as soon as there are seven points — six fails,
> with a witness that has aligned four-sets — and this work measures the
> invariant's redundancy exactly where it can be measured: no 29 of its 35
> bits determine it at seven points and exactly 56 families of 30 do, while in
> general a designated \(3n^2-23n+45\) of its \(\binom n4\) bits suffice
> against a proved nonadaptive floor of \(0.616n^2\). What coarsening from
> triangle data to four-set coherence costs a decoder is measured rather than
> assumed: at most about four percent on average, under a half in the worst
> case.

Adjustments to what sections 7 and 8 say now:

1. Lead with 8.1's group-invariance point — it is the one *definitional*
   superiority of the four-set observable and deserves to be the conceptual
   opener, with the one-query floor gap of §1.4 as its quantitative shadow.
2. The robustness remark survives only as "at most about four percent"
   (§1.4); as a bonus it gains the open question with the arresting form —
   whether the coherence restriction is free, or even negative, on average.
3. The estimation payoff survives only in the corrected form of §4.5, and the
   conference sentence is replaced by §3.3's.
4. The "no setting has this oracle" sentence the audit requires can now cite
   three named near-misses (stabilizer measurement lands on triangles; DPP
   marginals hand over triples for free; deployed consistency filtering tests
   triangles) instead of standing as a bare prior — a much stronger negative.
5. If the tetrad screen of §4.2 comes back clean, one positioning sentence —
   the separating-family results as the exact \(\mathbf F_2\) analogue of
   non-redundant tetrad-constraint selection — is the best external anchor the
   material has; it should live in the paper's discussion, not its claims.

---

## 6. Ranked actions

**Provable now, no computation:** fix the adaptive-entropy transfer (§1.1,
three locations plus both adaptive certificates' framing); restate the mean
price as an upper bound with unknown sign (§1.4); cut the anchor-drop
rationale (§1.5); hedge the first-ness sentence (§1.6); add
\(|V|\ge7\) to 8.1 and drop or source the \(O(n^2)\)-decode aside (§1.7);
state pairwise independence and the exact variance \(3\binom n4/16\) (§3.1);
replace 8.3's relative-error and conference sentences (§§1.2–1.3, 3.3); add
the mystery ledger (§3.4).

**Cheap computation, settles something:** exact mask-free maximum at eight
points by ILP — outcome: bracket lifts to \(30\le\min(8)\le44\) or the
weight-four route is dead (§3.2); mixed per-pair link sweep at eight points via
the difference-mask reduction — outcome: "six per outside pair forced" becomes
fully per-pair at both measured sizes (§2.8); the 315-to-315 lifting check and
the parity check at nine points (§3.4); optionally re-verify the greedy
adaptive trees the way this review re-verified the 44-family, since the
eight-point adaptive numbers currently rest on the single Rust binary with no
independent replay and the report's replay section states no reason for the
gap — a reproducibility-conventions point, not a doubt.

**Speculative:** the tetrad-literature screen (§4.2) before item 7 drafting;
the golden-operator costing (item 8 proper); the exact optimal adaptive mean at
seven points — hard as a full DP, but even a lookahead-two greedy beating mean
15 would show the coherence restriction is free on average, which would be the
most striking single sentence this material could add.

---

## Appendix: review computations

Scratch scripts (session scratchpad, not committed): `verify.py` (independent
re-derivation of both point counts' censuses, marginals, families, weight-two
patterns), `mixed.py` (per-pair link sweep at seven points), `mis7.py` (exact
max mask-free set at seven points), `check8.py` (numpy replay of the 44-family
separation and the eight-point count distribution). All results quoted above;
all agree with the report's certificates.
