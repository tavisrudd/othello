# C1016 — order-2092 reduction synthesis: append-only archive

**Lane**: `ergodis` · **Task**: C1016 · archive opened 2026-09-05.

This is the append-only history companion of
`2026-08-30-c1016-ergodis-hadamard-quotient-synthesis.md`. That file is now the
live card: frontier, essential background, and routing to the dated reports.
Everything below is the record it was trimmed from — the fourteen exact
reductions in the form they were derived, the multiplier-shard transfer
censuses, the evolve-to-proof and endgame passes, the launch-envelope
estimates, and the performance and validation notes taken at the time.

Read it for provenance, for the derivation of a reduction the card only names,
or before repeating an experiment. Do not edit what is already here: correct a
superseded statement in the card and append the correction, dated, at the end.
The `SYN:<line>` citations in `2026-09-03-c1016-fable-reduction-review.md`
refer to the pre-split file and resolve against this archive, offset by the
lines of this header.

Section text below is preserved as written on 2026-08-30 and after, including
statements the card has since superseded — most importantly the launch-envelope
estimates, which the `q174` energy theorem retired, and the lane peg, which was
`complete-ports` before the `ergodis` split of 2026-09-05.

---

# C1016 — private Ergodis reduction synthesis for Hadamard order 2092

Date: 2026-08-30. Lane: `complete-ports`. Status: in progress; the
multiplier-assumed g41, g53, g91, and g133 branches now have private exact
structural exclusions. No unrestricted order-2092 coverage claim has been
made.

Resume gate: read `papers/complete-repair-ports/ergodis/PERFORMANCE.md` and
`notes/queens-othello-perf-playbook.md` completely before compute. Use CHOOM,
hardware counters rather than busy-host wall time, zero allocation in every
solve loop, presized iterative search only, and retained single/parallel A/B
before admitting any solve-kernel change. C999 remains read-only evidence.

## Corrected trust and repository boundary

The first overlay incorrectly treated a presentation hash plus a named feature
column as proof authority. That authenticated bytes, not the semantics of the
feature extractor: a correctly named column containing false values could have
authorized a `Necessary` plan. The overlay was not approved or committed.

The unsound surface is removed. Public Ergodis again advertises
`proof_authority: false`; `PlanRole::Necessary`, proof-shaped metadata, and
authorized compilation are absent. Public core contains no Hadamard or
Goethals--Seidel module, types, schemas, fixtures, tests, or exports. A future
necessary-predicate mechanism requires a sealed registered extractor binding
extractor identity, version, parameters, source commitment, and canonical
field semantics, preferably with independent recomputation. Until then,
campaign output has diagnostic or ordering authority only.

All C1016 cyclic/GS code, fixtures, oracles, campaigns, and evidence now live
in top-level `ergodis-private/`. The private carrier is explicitly capped at
522; subset compilers have hard state budgets and fail closed. No arbitrary
compression-energy API remains.

## First four exact reductions

1. **Order-three orbit energies.** Exact Eisenstein-energy subset sums close
   all order-42 shards (`g=5,13,23`), the order-21 shard `g=7`, and the
   order-14 shard `g=35`. The surviving high-order roots `g=41,133,53,91`
   retain `1,14,7,40` canonical order-three profiles.
2. **Joint `d=9/d=6` local fibres.** A residue modulo 29 is a `2 x 3` table of
   three-sign cell sums. Exactly 1,666 of 34,300 independently legal marginal
   pairs lift. Coupling this with order two and three on `g=53` reduced the
   exact four-block assignment exponent from `159.86824` to `148.68299`.
3. **Galois fixed fields.** At character order nine the four surviving roots
   have fixed-field degrees `1,2,3,6`; `g=41` is rational and has seven
   canonical order-nine profiles.
4. **Orbit-quotiented PAF residual.** PAF is constant on multiplier shift
   orbits, so `(A,B)` signatures match exact residuals from `(C,D)`. This is a
   theorem-level decomposition only; no packed solve kernel is admitted yet.

## Four further root-scoped reductions

1. **`g=53`: joint rational orders 2, 3, and 6.** A same-subset DP takes the
   already reduced exact count
   `572849117221667545326815648911695209150545920 = 2^148.682991...`
   to
   `485809675336267569788580842066841352273920 = 2^138.479443...`.
   This is another `1179.164x = 2^10.204` reduction and leaves only four
   canonical joint energy profiles.
2. **`g=41`: joint rational orders 9 and 18.** Exact four-block assignments
   fall from `2^269.490398...` to `2^260.961257...`, a `369.426x = 2^8.529`
   reduction. The 387 joint profiles refine rather than replace the seven
   order-nine profiles; the gain is in assignment multiplicity.
3. **Translation-normalizer quotient.** If `(g-1)t=0 mod 522`, translation by
   `t` commutes with the multiplier. Each block can therefore be canonicalized
   independently without changing row sums or PAF. Exact Burnside counts give
   four-block factors essentially `2^4`, `6^4`, `2^4`, and `18^4` for
   `g=41,133,53,91`. The strongest `g=91` factor is `104975.998... =
   2^16.679700...`; nonidentity fixed subsets explain the tiny difference from
   exactly `18^4`.
4. **`g=91`: quadratic order-29 sector.** The order-14 multiplier image is the
   quadratic-residue subgroup modulo 29, so the character lies in
   `Q(sqrt(29))`. Writing each block energy as `c+d sqrt(29)`, feasibility
   requires `sum c=2092` and `sum d=0`. Only 9 special-block and 5 zero-block
   signatures occur, yielding exactly two canonical profiles. Assignments
   fall from `2^194.442134...` to `2^186.252599...`, a `291.941x = 2^8.190`
   reduction.

## Structural mechanism and five additional reductions

The common mechanism is a CRT orbit algebra. For a character order `q`, a
multiplier-invariant sequence has residue sums constant on multiplier orbits
in `Z/qZ`. Its Fourier value is therefore a small fixed-field transform of
divisor or residue-class sums. Galois conjugacy turns the PSD equation into a
norm equation, and irrational coefficients must cancel across the four
blocks. Ergodis is useful for proposing which sectors to join and for
falsifying the resulting predicates; the authority comes from these explicit
transforms and independent arithmetic replay, not from a learned formula or a
large certificate.

1. **Common unit-dilation normalizer.** Every unit modulo 522 commutes with a
   linear multiplier. Applying the same dilation to all four blocks preserves
   row sums and merely permutes the PAF equations. After dividing by the
   multiplier subgroup, the effective groups have orders `14,14,12,12` for
   `g=41,133,53,91`. Exact Burnside block censuses agree with factors
   `13.99999996, 13.999999998, 11.9999665, 11.9999345`; fixed candidates
   explain the tiny deficits from the group orders. This is a common
   four-block quotient, whereas commuting translations act independently on
   each block.
2. **`g=41`: add order three to joint orders 9 and 18.** Exact labelled
   assignments fall from `2^260.961257...` to `2^255.052059...`, a
   `60.0960x = 2^5.90920` reduction, with 303 canonical profiles. Attempts to
   add order two or six hit the explicit compiler state budget and failed
   closed; the budget was not raised.
3. **`g=133`: structural order-nine norm.** Modulo nine, each of residues
   `0,3,6` contains two singleton multiplier orbits and fourteen size-four
   orbits. The other orbits--four of size three and 28 of size twelve--have
   zero primitive order-nine character sum. If `n0,n3,n6` are selected counts
   in the three visible classes, then

       E9 = 4 ((n0-n6)^2 - (n0-n6)(n3-n6) + (n3-n6)^2).

   A bounded binomial generating-function replay gives 96 special and 59 zero
   signatures, 5,240 canonical profiles, and exponent `286.432588`, down from
   raw invariant exponent `294.495364`: `2^8.06278`.
4. **`g=133`: joint order-three/order-nine norm.** The order-nine-visible
   classes all lie over residue zero modulo three. The invisible orbits split
   into two identical families, each with two size-three and fourteen
   size-twelve orbits. Joining their Eisenstein norms gives 963 special and
   289 zero signatures and 36,497 canonical profiles. Exact assignments have
   exponent `273.449265`, another `8097.85x = 2^12.9833` below order nine
   alone, or `2^21.0461` below the raw invariant space.
5. **`g=91`: joint order-three/order-29 CRT norm.** Modulo `87=3*29`, each
   residue modulo three contains six fixed points, six size-14 quadratic
   residue orbits, and six size-14 nonresidue orbits. Thus order three is an
   Eisenstein norm of three selected-count totals while order 29 is the
   quadratic norm of the corresponding residue/nonresidue balances. The joint
   theorem leaves 180 special and 70 zero signatures and 210 canonical
   profiles. Exact assignments fall from the order-29 exponent `186.252599`
   to `170.568435`, a further `52650.6x = 2^15.6842` reduction.

The order-29 theorem itself no longer uses subset DP. There are 18 fixed
points and 18 orbits of each Legendre class. Row sums force fixed-point counts
8 and 9 in the special and zero blocks. Radical cancellation forces the
special block to choose nine orbits of each Legendre class. Writing the three
zero-block balances as `B_i=2b_i`, the entire remaining equation is
`b_1^2+b_2^2+b_3^2=18`, whose only unordered absolute solutions are
`(4,1,1)` and `(3,3,0)`. These give the two energy profiles
`(4;116,116,1856)` and `(4;0,1044,1044)` and reproduce the prior exact
assignment count by a closed binomial formula.

These are per-root theorems. They are not generalized to other roots or
construction families.

## Fourteenth reduction: g53 joint q29 CRT norm

For `g=53`, reduction modulo 29 has order seven while reduction modulo 18 is
negation. CRT therefore decomposes the 50 multiplier orbits into five copies
of the ten negation-orbit types on `Z/18Z`: over residue zero modulo 29 there
are two singletons and eight pairs; over each of the four cosets of `<24>` in
`(Z/29Z)^x` there are two size-seven and eight size-fourteen orbits. A base
choice contributes its selected count and rational order-2/3/6 character
values; nonzero families scale those values by seven. This 1,024-row table was
checked independently against direct permutation closure for all five
families.

If `a,n0,n1,n2,n3` are the five selected-count coefficients, direct cyclic
autocorrelation on `Z/29Z` gives the exact order-29 energy
`C + D sqrt(29)`, where `C=2(2c0-cq-cn)` and `D=2(cq-cn)`. Joining this norm
with the four exact rational q2/q3/q6 profiles reduces labelled assignments
from

`485809675336267569788580842066841352273920 = 2^138.479443...`

to

`64949798014649517492352112253500547072 = 2^125.610665...`.

The incremental factor is `7479.772x = 2^12.868779`. Exact compatible pair
frontiers are
`1802404311189514243200 = 2^70.610413` on `(special,zero)` and
`1247353074143183827840 = 2^70.079360` on `(zero,zero)`. Exact per-block
survivors are 47,614,876,488 special and 150,385,827,216 zero blocks. The
release compiler used 28,451,000,083 instructions and 19,873,367,141 cycles in
one nonmultiplexed run under CHOOM. The locked exact-count test and independent
direct-orbit oracle pass.

The primitive q58 identity
`zeta_58^x=(-1)^x zeta_29^(15x)` supplies a second quadratic norm whose
coefficients are the parity sums of the same five families. Its bounded
per-block census is exact but weak by itself: 45,014,800,248 special and
141,776,042,952 zero blocks survive. The first exact four-block hash join was
rejected after 5,542,698,164,850 instructions and 5,882,334,004,341 cycles;
peak RSS was 465,660 KiB. This is retained as rejected-performance evidence,
not as a completed reduction. A packed structural join is still required.

## Private evolve-to-proof and discovery search

The private general proof layer now contains sealed extractor descriptors,
typed observations, five fail-closed provenance classes, bounded exact integer
linear closure, iterative bounded square-sum and nonnegative-linear endpoints,
deterministic Horn-rule synthesis, and independent registry replay. The q29
and g53 adapters reject false values under correct field names, forged
extractor versions, unknown semantic fields, provenance escalation, and
mutated transcripts. The g53 exact census is correctly labelled
`exact-computational`, while universal quotient identities are
`proved-structural`. Rule derivation and replay use caller-owned storage and
have zero-allocation integration tests. The rule record is a 16-byte Tiger
layout. Public Ergodis still grants no proof authority.

The evolve backfill now covers both levels of the banked work. Exhaustive
rule-ablation corpora cover all ten sealed proof systems (subgroup energy,
quotient PAF and character coverage, the three g53 systems, g41 filtering,
the two g133 exact-shift systems, and the g133 cycle-mod-11 proof). Independently, fourteen
theorem-specific semantic-coordinate corpora cover every reduction listed in
the first, second, structural, and q29 passes above. Each corpus varies every
necessary residual and at least one irrelevant diagnostic coordinate over
`{-1,0,1}`. A generic decision-tree proposer finds the exact conjunction and
evolve retains a perfect candidate; diagnostic coordinates are not selected.
The semantic label loop and Horn-ablation closure loop both allocate zero
times.

The decisive control is `blind_evolve_harness`. It discovers opaque JSONL
files and imports no C1016 registry, theorem name, field list, rule graph,
predicate, expected mask, or theorem-specific seed. On all fourteen corpora it
found an exact candidate and evolve retained at least one perfect descendant:
1,134 exhaustive rows, 13,539 evolved candidates, and 425 perfect candidates
in aggregate, with maximum tree depth eight. The CHOOM-protected,
nonmultiplexed audit used 3,080,103,731 instructions, 867,245,642 cycles,
606,843,981 branches, and 3,164,156 branch misses. This establishes blind
recovery from registered theorem-derived residual coordinates. It does **not**
yet establish rediscovery from raw orbit masks or counts: the residual
extractors still encode the candidate coordinate system. That stricter test
requires a private, domain-neutral bounded feature expander (raw unary,
pairwise, and low-degree norm/CRT expressions) plus held-out direct-orbit
replay. The current result is discovery infrastructure, not proof authority
and not a claim that evolve independently invented the mathematics.

The next private adapter removes the residual columns themselves. For each
coordinate it presents two independently varied opaque scalar observations;
one theorem-agnostic bounded expander emits all raw scalars and all pairwise
differences. It has no reduction dispatch, semantic field names, selected
pairs, or rule mask. The expanded kernel uses caller-owned fixed storage,
dispatches capacity validation outside its repeated loop, is iterative, and
allocates zero times. Train and holdout corpora use disjoint deterministic
seeds and contain 1,024 rows per reduction per split.

This exposed a real proposer defect: the generic greedy decision tree failed
on the noisy expanded presentation for all fourteen reductions. The private
evolve adapter now has a generic zero-conjunction proposer. It retains every
field that vanishes on all positives, then greedily covers the negative rows;
it knows neither field provenance nor theorem identity. The proposer selected
two, three, or four pairwise-difference fields as appropriate, evolve retained
an exact training candidate for all fourteen reductions, and the unchanged
plans classified all 14,336 disjoint holdout rows exactly. Across training it
tested 13,491 evolved candidates and retained 17 perfect candidates; each
holdout admitted exactly the one supplied plan. The CHOOM-protected,
nonmultiplexed run used 7,998,858,478 instructions, 1,903,109,261 cycles,
1,292,596,708 branches, and 10,063,017 branch misses. Thus every reduction the
human loop banked has now caused a missing generic proposer capability to be
added and replayed.

This is a stricter no-baked-predicate control, but still not the final raw
orbit gate. The paired scalar observations are pre-residual theorem
coordinates; their construction still knows which orbit/norm quantities to
present. Discovery directly from canonical orbit masks/counts needs bounded
generic sum, product, CRT-residue, and quadratic/Eisenstein-norm expansion,
with the direct orbit evaluator supplying labels. No pruning authority follows
from either blind campaign.

The v2 black-box control also removes accidental presentation hints. The
theorem-aware generator writes only opaque corpus identifiers and `fNNN`
field identifiers, and applies a deterministic hidden permutation to the raw
and pair-difference fields shared by a train/holdout pair. The harness still
imports only Ergodis control types and discovers the fourteen anonymous corpus
pairs from the directory. It recovered all fourteen reductions and classified
all 14,336 disjoint holdout rows exactly. The CHOOM-protected,
nonmultiplexed rerun used 7,743,068,062 instructions, 1,904,203,917 cycles,
1,274,537,241 branches, and 10,754,080 branch misses. Evidence is under
`/home/tavis/.local/state/ergodis-private/c1016/blind-opaque-v2/`; it remains discovery-only local
evidence, not a paper-facing certificate.

For discovery only, fixed minus counts turn the bordered PAF equation into

`sum_b |X_b intersect (X_b+s)| = 520`.

There are 49 nonzero shift orbits under g53. The private local-search kernel
now stages quotient PAF, subgroup-energy, and fine-shift constraints, with
exact incremental updates under equal-size swaps and composition-changing
`2 x size -> 1 x double-size` moves. It is iterative and its mutation loop
allocates zero times. Intermediate graduation is heuristic; success at all
constraints is accepted only at exact objective zero and then checked directly
at all 521 nonzero shifts and against all four row counts. Negative output has
no coverage authority.

The original 100-billion-mutation PTY run disappeared without a retained
terminal record or witness and therefore has no evidentiary status. Its
replacement uses a persistent systemd user unit and disk-backed log. A loaded
16-thread full-stage control retired 49,452 instructions and 15,789 cycles per
mutation; a separate cycles/reference-cycles control observed 20,330/12,102
per mutation under heavier contention. At a conservative 2 GHz per active
core, the latter models 50 billion total mutations to about 8.8 hours. The
first service attempt was CHOOM-killed during the deliberately heavy broad
test at only 6.8 MiB peak RSS. Its restarted replacement completed 50 billion
mutations without a witness. The persistent log
`/home/tavis/.local/state/ergodis-private/c1016/g53-search-20260831T0025.log` records every worker
at the full 10-quotient/2-subgroup/49-shift stage, 2,976,205,325,587,505 retired
instructions, and 893,934,554,951,320 cycles: 59,524 instructions and 17,879
cycles per mutation. This is a heuristic miss only. The next campaign uses an
exact quotient shell before introducing fine PAF constraints.

That separation is now a private `g53-search` v2 protocol. Phase one can emit
a fixed 32-byte orbit seed only after a separate direct replay of the four row
weights and all ten quotient equations; phase two accepts such a seed only
after repeating that replay and restores it on every restart. The seed is
explicitly heuristic discovery input, with no negative-coverage or certificate
meaning. A one-million-mutation phase-one counter control (one worker, seed
2092) found no shell and reached quotient residual 3,437; it used 27,539
instructions and 5,828 cycles per mutation. This is retained as a failed
heuristic probe, not mathematical evidence.

## Quotient-PAF synthesis and sparse-defect theorem

The evolve-to-proof conversion now recognizes complete cyclic character
coverage. For a typed sorted set of character orders dividing `d`, it checks
`sum phi(order) = d-1`; `{2,3,6,9,18}` therefore compiles to one shorter
`Z/18` quotient-PAF theorem. Independent replay enumerates quotient fibres and
never trusts feature names or cyclotomic output.

For g53, let `B_i(x)` be the selected-minus count in residue `x mod 18`.
Direct ordered-pair double counting proves

`sum_i,x B_i(x) B_i(x+s) = 15603` for `s=0`, and `15080` for `s=1,...,9`.

These ten small-integer equations are exactly the row-sum plus
orders-2/3/6/9/18 character system. The same generic theorem supplies four
additional subgroup shells at orders 9, 18, 58, and 87; the search retains
only the two not implied by the full `Z/18` quotient.

The five g53 orbit families contribute `B=e+7k`. Converting the zero-shift
identity to signed marginals gives total square energy 1,976 and the bounded
Diophantine endpoint

`15 n29 + 13 n27 + 4 n15 + 3 n13 = 34`.

Independent iterative replay finds exactly ten magnitude profiles. At most 11
of the 72 expanded entries are defects, hence at most nine of the 40 reciprocal
coordinates are defects and at least 31 have `k=2`. A separate exact oracle
finds that zero shift removes 29.326894 bits after row sums and still removes
20.430689 bits beyond the locked q2/q3/q6 census. The other nine quotient
shifts and q29 are additional constraints; their joint reduction has not yet
been counted, so no unsupported bit factors are multiplied.

## Ergodis evolution control

The independent oracle generated all 315 canonical `g=91` order-29 energy
quartets, with two positives. `ergodisctl evolve` tested 2,368 scoped plans in
84 observational classes and found 17 that classify this corpus perfectly.
Its first best plan was

`constant_sum == 2092 && radical_abs <= 2`.

That predicate is observationally equivalent on this corpus but weaker than
the theorem's exact `radical_sum == 0`. This is the intended negative control:
Ergodis can generate and rank a useful reduction shape, but corpus perfection
does not grant pruning authority. The exact quadratic-field derivation and
independent replay own the theorem.

## Quaternionic/Williamson paper

Bennett--Bright--Colinot--Nayak, *Quaternionic Perfect Sequences and Hadamard
Matrices*, arXiv:2601.22337v1, was read from cached PDF sha256
`3ea5156a3d13e8383f1361be468a92222e0423bf45f198a0ca9d975fceb5e94b`.
Its Theorem 9 proves equivalence between quaternion-type and Williamson-type
quadruples and hence pairwise amicability. Their length-20 enumeration reports
that the pairwise filter reduces over 16 billion pairs to 625,896, about
26,000x. This theorem does **not** apply to the bordered GS roots: C999's
decoded blocks are non-amicable. It is retained only as a separately scoped
`construction_family=williamson_qt` reduction and CPSD feature family.

## Validation and performance

- Public `cargo test --all-targets --all-features`: pass after removing the
  unsound/public GS overlay.
- Public strict all-target/all-feature clippy: pass with only recorded
  pre-existing lint allowances.
- The last complete private-library snapshot passed all 398 release tests
  under CHOOM.  Nineteen subsequently added focused margin, order-six,
  q18-evolve, and local-repair tests bring the current library census to 417;
  each targeted group passed when its dependency snapshot compiled. A fresh
  aggregate build is presently blocked by incomplete concurrent public-core
  `ProposalTicketStatus` edits, which C1016 does not modify. The new q174
  theorem and evolve delta additionally pass six focused
  compression-identity, orbit-shape, brute-force DP, direct-selection,
  differential, and allocation tests.  The earlier serial
  `cargo test --all-targets --all-features` gate passed every binary and all
  three integration targets, including all 13 allocation tests in the largest
  integration group. A fresh all-target gate is deferred while concurrent
  public-core API edits are in flight; C1016 does not modify or absorb that
  work. A first parallel attempt was CHOOM-killed when several
  exact census tests overlapped; the g53 canonical replay now uses one
  thread-safe cache, its parallel proof group passes, and the serial broad gate
  is the bounded-memory authority.
- Package-scoped `cargo fmt --package ergodis-private -- --check` passes. The
  workspace-wide format check is currently blocked only by concurrent foreign
  public-core edits in `ergodis/src/span.rs`; C1016 does not format or modify
  that file.
- Independent Python replay agrees exactly on all eight reductions.
- Small carriers through 48 exhaustively match direct multiplier-permutation
  closure; invalid carriers 0 and 523 fail closed.
- Existing private marginal/residual hot queries remain allocation-free and
  iterative. New quotient, subgroup, defect-proof, and composition-move
  kernels have explicit zero-allocation and differential gates; all traversal
  is iterative.

The new generic proof adapters were separately profiled under
`choom -n 1000` with nonmultiplexed `instructions,cycles` groups, using 20
million derive/replay operations each. Quotient-PAF derivation/replay cost
342/314 retired instructions and 45.6/45.9 cycles per operation; sparse-defect
derivation/replay cost 504/464 instructions and 66.2/73.8 cycles. These are
compact rule and bounded-Diophantine transcripts, not solve-loop work; the
allocation gates cover each adapter independently.

Five nonmultiplexed repetitions of the complete second-pass cold compiler,
protected by `choom -n 1000`, average 18,971,526,462 instructions,
13,229,724,210 cycles, 2,261,140,844 branches, 13,825,772 branch misses,
279,956,710 cache references, and 52,620,990 cache misses. Busy-host wall time
is not used. Raw counters and the evolve transcript remain on persistent ZFS;
hashes and exact results are in the private JSON evidence.

After the structural pass, the expanded cold scout was rebuilt at sha256
`8d4a2c765ea41cab9dce53f85655156db8daba190f8931b24175e142c85b64f3`.
Five repetitions in separate nonmultiplexed counter groups (100% enabled)
average 87,269,781,124 instructions, 84,185,754,155 cycles,
10,663,861,095 branches, 53,330,724 branch misses, 1,425,149,554 cache
references, and 333,846,835 cache misses. The independent direct-orbit Python
oracle passes and deliberately costs 1,786,046,501,457 instructions; it is
validation, not a search component. The scoped current gate passes 184 private
library tests plus all C1016-owned binaries and allocation tests. Strict
clippy passes with the recorded repository-wide allowances for pre-existing
range-loop and `is_multiple_of` lints; C1016's own reported range loops were
cleaned. No wall time is used.

## Exact-prefix evolution loop and structural boundary census

The next private loop made the quotient curriculum itself replayable. Search
outcomes now retain the deepest exact quotient prefix, its modular root, and
its fixed-width selection independently of the best nearby objective. A typed
prefix input is accepted only after direct row and prefix-PAF replay; a
one-bit-corrupted checkpoint is rejected. It can therefore concentrate a new
campaign on the next equation without pretending that a partial checkpoint is
a quotient shell. The checkpoint remains discovery input and has no negative
or certificate authority.

Several initially plausible controls were falsified under CHOOM with
nonmultiplexed `instructions,cycles`:

- A deterministic 64-lift-per-root exact-q0 bank contains 159,744 directly
  replayed seeds and samples eight witnesses in each block-energy fibre. Its
  matched 160-million-mutation run still reached the same q4/q7 attractors and
  no shell. Thus the earlier stall is not an artifact of the one-witness DP.
- Exact q0 intersected with q1--q6 modulo 49 in 118 sampled seeds across 67
  roots. The best modular seed has residuals
  `[0,0,49,0,98,0,49]`; a q7-started search again collapsed to the same local
  minima. The older arbitrary mod-49 bank was much worse: its best squared
  q0--q6 residual was 49,839,958 with q0 off by 6,174.
- Root-preserving coordinate swaps and root-preserving cross-block transfers
  pass direct row/modular/incremental and zero-allocation tests, but matched
  160-million-mutation controls did not improve shell reach and cost more.
  They remain opt-in rejected controls.
- Restart intervals of 100,000 and 500,000 mutations traded away exact-prefix
  graduation; 2.5 million remains the retained control.

Eight 16-thread shards then retired 6,524,070,144,453 instructions and
1,567,306,490,251 cycles over 1.28 billion mutations. They retained 76
distinct exact q0--q3 checkpoints on 75 modular roots, but no q0--q6
checkpoint or shell. Independent full quotient replay collapses those 76
states to only eight q4--q9 residual templates. The two dominant templates
occur 31 and 25 times, and the special-block modular mask strongly predicts
the basin. This is an evolved structural observation, not a theorem or a
root-elimination rule.

The boundary is unusually rigid. Complete per-block q0--q3 profile joins find
only six single-block homometric representatives among the 76 checkpoints.
Complete two-block cancelling-delta joins find alternatives for the same six
and none for the other 70; every positive is directly replayed. The switches
lead only to already observed residual templates. Exact local closures using
ordinary swaps, row-preserving 1-by-14/2-by-7 compositions, and scoped
coordinate permutations find no repair through four compatible moves on all
14 states in the first corpus. A later audit invalidated the same-block part
of this negative: individually measured PAF deltas have a quadratic cross term
when two moves touch one block, even if their orbit edits are disjoint. The
MITM join now rejects every same-block pair, making additive keys exact only
for distinct-block compositions. Directly replayed positives remain valid;
the prior three-/four-move misses and their coverage counts do not.

The repair implementation produced a useful representation experiment, but
its old counter comparison used the now-invalid same-block workload and is not
an accepted semantic A/B until rerun with the corrected distinct-block scope.
Separating replay-only workspace construction from seed-census compilation and
replacing a quadratic delta scan by a sorted 16-byte packed index reduced one
two-move scout from 44,015,486,115 to 7,791,502 instructions, about 5,650x.
The full 14-state two-move corpus then cost 141,998,350 instructions; the
four-move composition/coordinate closure stays around 32 MiB peak RSS. This
is cold proof/search infrastructure, not solve-loop work. The mutation loops
remain iterative and allocation-free.

The next structural target is now sharper: explain or compile the apparent
four-block rigidity of exact q0--q3 decompositions, then construct q4 exactly
before adding q5 and q6. A one-equation-at-a-time stochastic control from an
exact q0--q3 checkpoint still failed to reach exact q4 in 160 million
mutations, so a wider four-block profile switch or a proof-level obstruction
is preferable to deeper local annealing.

## Sparse-defect exact q4 exclusion

The apparent q0--q3 rigidity is now explained by the proved zero-shift defect
equation rather than by deeper annealing.  Writing every scale-seven digit as
`k=2+d`, the total nonnegative defect energy is exactly 34.  An iterative
bounded compiler enumerates only row-compatible displacements whose partial
energy can still fit 34.  Across all 26 block-mask kinds this reduces roughly
443,000--481,000 raw base-five lifts per mask to 711--1,613 distinct exact
`(energy,q1,q2,q3,q4)` profiles, 36,890 profiles total.  The records are 16-byte
Tiger layouts.  The complete compiler costs 153,964,657 instructions and
40,130,227 cycles at 13.6 MiB RSS under CHOOM.

The optimized exact four-block join then checks all 2,496 proved mod-seven
roots.  It finds zero q0--q4 hits after 5,615,839,104 left-pair probes.  A
16-worker Ergodis root execution retires 169,584,086,558 instructions and
48,028,410,263 cycles at 13.4 MiB RSS.  Its presized root callback has a direct
zero-allocation regression.  A deliberately different oracle enumerates all
`5^10` block words, canonicalizes them with ordered sets, and uses a hash join;
it independently obtains the same 2,496 misses and probe count in
219,305,454,639 instructions, 56,328,427,859 cycles, and 46.9 MiB RSS.

The exact q4 fibre above q0--q3 is much smaller than the join transcript.  It
has four classes determined solely by the scale-one special mask:

- masks `1,326,394,512`: no exact q0--q3 lift (864 roots);
- masks `58,368`: q4 is in `{15101,15150}` (768 roots);
- masks `172,212`: q4 is in `{14926,15290}` (768 roots); and
- masks `170,340`: q4 is in `{14919,15094,15108,15178,15206}` (96 roots).

The required q4 value is 15,080, absent from every class.  Thus the entire
`g=53` multiplier shard is excluded already by q0--q4.  This remains a
multiplier-assumed result and says nothing about unrestricted order 2092.

A sealed private proof stores only those ten special-mask rows and a six-step
Horn transcript.  Verification reconstructs the structural defect theorem,
the four exact fibres, and the independent oracle; no large pair certificate
is trusted or retained.  Its provenance is `exact-computational`, bound to the
registered carrier-522/generator-53/Z18 extractor.  Forged bindings and
evolved provenance fail before replay.  Full generation plus verification
costs 748,094,578,504 instructions, 149,109,091,710 cycles, and 48.5 MiB RSS.

Three broader conjecture families were fast-falsified and retained as rejected
controls.  All 2,496 roots lift q0--q4 modulo 343, so a higher 7-adic scalar
obstruction is absent at that level.  No primitive real separating inequality
in `[-5,5]^5` excludes even one root; likewise 25,938 scalar congruence
projections through modulus 64 and all 100 two-/three-coordinate projections
of size at most 64 exclude none.  The obstruction is an exact five-dimensional
lattice fibre, not a scalar interval or low-dimensional congruence.

## Transfer theorem: g91 dies at q0

The sparse-background mechanism transfers more strongly to `g=91`.
Multiplication by 91 is the identity modulo 18, and direct orbit closure proves
that every residue fibre contains one singleton multiplier orbit and two
size-14 orbits.  Every quotient count therefore has the form

`B = e + 14 k`, with `e in {0,1}` and `k in {0,1,2}`.

The quotient zero-shift theorem again gives signed energy 1,976.  The 72
coordinates on the `k=1` background contribute 72, leaving excess 1,904 or 34
units after division by 56.  A nonbackground coordinate has signed magnitude
27 or 29 and hence costs 13 or 15 units.  Feasibility would require

`13 n27 + 15 n29 = 34`.

Energy bounds give `0 <= n27,n29 <= 2`; the nine-case endpoint and an
independent double loop find no solution.  Equivalently, testing
`n29=0,1,2` leaves `34,19,4`, none divisible by 13.  Thus the entire `g=91`
multiplier shard is structurally impossible already at q0.  This supersedes
its earlier order-3/order-29 counting reductions as a decision result, while
those remain valid demonstrations of the general character compiler.

The private sealed proof binds carrier 522, generator 91, the Z18 projection,
and source semantics; evolved observations cannot self-promote.  Direct orbit
reconstruction, the generic quotient-PAF proof, the bounded endpoint, an
independent oracle, adversarial binding/provenance tests, and a six-step Horn
replay all pass.  The rule kernel is allocation-free and iterative.  Over 20
million operations, derive/replay use 513.024/459.024 instructions and
86.644/62.722 cycles per operation under CHOOM with a nonmultiplexed group.

## Transfer census: g133 q0 is useful, q1--q4 scalar shapes are not

For `g=133`, the Z18 action has ten quotient slots, each with one scale-one
and seven scale-four orbit families. Thus every coordinate is `B=e+4k`, and
the signed q0 identity has defect budget 83 above the magnitude-three
background. A bounded iterative compiler streams all 26,763,264 mod-four
roots without materializing them. Exact q0 retains 15,724,800 and excludes
11,038,464 (41.25%); every retained root has a directly reconstructed row/q0
witness. The run used 236,520,091,736 instructions and 55,906,375,433 cycles.

Exact q1 adds no reduction: all 15,724,800 q0 roots reconstruct a q1 witness.
The compiler collapses 528 block domains to 24 special and 14 ordinary
semantic classes and retains 1,564,133 pair profiles. The exact q1 run used
334,467,859,281 instructions and 122,465,959,332 cycles. Exact
`(energy,q1,q2)` block growth is only 3,079,923 profiles, but q2 and q4 modulo
64 plus exact pair minima/maxima still retain precisely the same q0 roots;
q3 modulo 64 is likewise redundant. These are retained as fast-falsified
theorem shapes, not promoted reductions. The remaining possible gain is in
interior exact higher-shift gaps or a different structural projection.

A new same-witness lift compiler tests that remaining non-scalar direction.
Writing each quotient coefficient as `e+4k`, the generic one-bit
autocorrelation theorem derives the eight q2--q9 lift bits modulo 8 from the
canonical binary word and the parity of `k`.  Exact `(energy,q1)` pair images
carry all eight bits jointly in fixed 256-bit XOR sumsets.  The compiler has
31 special and 19 zero semantic classes, 3,087,669 block profiles, and
2,811,235 pair profiles; only 26,639 of 212,629 class quadruples have any
exact q0/q1 lift.  Nevertheless every one of the 15,724,800 exact-q0/q1 roots
has a same-witness full mod-eight lift.  Thus joint mod 8 is another exact
zero-reduction shape, not merely a failed scalar marginal.  The discovery
run used 1,024,821,200,482 instructions and 266,459,278,371 cycles under
CHOOM.  Its fixed bitset kernel is iterative and allocation-free, with a
direct pair-loop oracle.

The reconstructed-witness signal strengthens sharply at the next lift: only
1,851,024 retained q1 witnesses satisfy all q2--q9 modulo 8, and only 123,024
satisfy them modulo 16.  Those are discovery counts, not root exclusions,
because alternate witnesses rescue every root at mod 8 and have not yet been
compiled at mod 16.  The next exact target is therefore the root-scoped
mod-eight-to-mod-sixteen fibre, not another scalar shift.

The mod-sixteen block compiler is already bounded enough for that next join.
Two theorem lifts (`e -> e+4(k mod 2) -> e+4(k mod 4)`) produce the exact
two-bit normalized q2--q9 signature and match a direct PAF oracle.  Across all
528 block domains it retains 7,898,051 exact profiles (126,368,816 payload
bytes), refining the mod-eight classes only from `31/19` to `31/24`.  The
complete class census uses 813,386,479,728 instructions and 165,266,767,319
cycles at 136,468 KiB peak RSS.  The 26,763,264 mod-four roots occupy only
1,566 refined class cells, and each cell requests one unique mod-sixteen
target signature.  This justifies a cell-scoped fibre join instead of a global
65,536-state pair table.

That scoped exact join is now complete.  Only 187 special-zero and 303
zero-zero pair classes are needed.  Their 1,479,261 exact `(energy,q1)` keys
contain 59,053,245 mod-sixteen signatures, with a proved runtime cap and an
observed maximum of only 64 signatures per key.  Of the 1,566 requested cells,
865 have exact q0/q1 lifts, and all 865 contain their required joint q2--q9
mod-sixteen signature.  Consequently all 15,724,800 exact-q0/q1 roots survive:
joint mod 16 gives zero reduction, despite the 123,024-witness discovery
signal.  The run uses 5,550,176,177,805 instructions, 1,110,110,621,324 cycles,
and 1,022,944 KiB peak RSS under CHOOM.  Dense pair workspaces are temporary;
retained products use 8-byte Tiger keys and one contiguous `u16` signature
arena.  This closes low 2-adic joint lifting as a high-EV reduction family;
the next g133 attack must use exact interior gaps or a non-2-adic character
projection.

The exact-interior pivot succeeds at q2.  The old mod-64-plus-range pair
summary has genuine holes: in the first canonical special-zero and zero-zero
pairs it admits 50,937 nonexistent q2 values, with as many as 62 false values
in one `(energy,q1)` fibre.  The complete exact q2 compiler uses 24 special
and 14 zero semantic classes, 1,564,133 Tiger pair keys, and 19,487,229 exact
pair values.  It reduces the 15,724,800 q0/q1 roots to 15,372,288, excluding
352,512 roots (2.2418%).  All 15,372,288 retained roots reconstruct class
witnesses into their own block domains and directly replay the four row sums
plus q0, q1, and q2.  The replayed run uses 1,286,226,276,223 instructions,
296,703,676,400 cycles, and 247,832 KiB peak RSS under CHOOM.  Exclusions
were then independently rebuilt by a shifted-bitset convolution oracle, which
agrees exactly with the primary pairwise-value compiler on all 532 pair
classes.  A sealed registered extractor binds carrier 522, generator 133, the
canonical Z18 semantics, parameters, source commitment, counts, and the
canonical survivor digest
`632b6956a3ace976be4a22b85712954ed262b8924a9dc3cd33505103462d2078`.
Its five-rule proof transcript stores no pair table or root certificate.
Synthesis plus independent verification uses 4,690,984,127,887 instructions,
1,096,816,829,332 cycles, and 263,988 KiB peak RSS.  The allocation-free rule
derive/replay kernels use 429.0/384.0 instructions and 67.45/55.57 cycles per
operation over 20 million operations.  The 352,512 exclusions now have
private exact-computational authority; they remain multiplier-assumed and do
not imply unrestricted order-2092 nonexistence.

The shift census then exposes the multiplier structure that an unscoped
search would miss.  Because `133 == 7 (mod 18)` and every quotient word is
constant on multiplication-by-seven orbits, shifts collapse to
`{1,5,7}`, `{2,4,8}`, `{3}`, `{6}`, and `{9}`.  An exhaustive 1,024-mask
oracle verifies closure and the induced PAF equality.  Exact q6 is much
stronger than q2: it retains 6,739,200 of the 15,724,800 q0/q1 roots and
excludes 8,985,600 (57.14%).  Its 1,564,133 pair keys represent 37,470,257
logical exact values, with at most 101 values per key.  Primary and shifted
bitset pair compilers agree, and every positive reconstructs and replays the
original equations.  The run uses 2,530,338,954,725 instructions and
650,714,419,417 cycles.  A canonical root-bitset intersection proves
computationally that every q6 candidate is already a q2 candidate, so q2 is
redundant once q6 is installed; the intersection run uses
4,888,863,416,315 instructions and 1,146,209,987,372 cycles.
A sealed registered q6 extractor v2 now synthesizes and independently verifies the
same 6,739,200 survivors, 8,985,600 exclusions, 883 survivor cells, and
canonical survivor digest. It also binds the 225-row gap-mechanism commitment
and a six-step transcript. The two-pass proof run uses 5,057,092,616,304
instructions and 1,143,431,945,571 cycles and stores no root or pair-table
certificate.

The complete q6 cell corpus has only 225 weighted semantic rows representing
all 15,724,800 q0/q1 roots.  The private Ergodis-evolve adapter binds the
shift, label semantics, source digest, weights, and feature names.  Evolution
found the zero-false-positive survivor predicate
`b0_q1_profiles >= 2120`, covering 5,971,968 of the 6,739,200 q6 survivors,
and a zero-false-positive two-clause exclusion predicate covering 1,368,576
of the 8,985,600 exclusions.  These are complete-corpus discovery leads, not
proof authority.  Adapter v3 exposes only semantic pair-image
shape data--interval counts, residue support, stored holes, and maximum hole
counts--so counterexample-guided evolution can propose compression and
sumset theorems without learning opaque class identifiers.  A bounded
10,000-candidate v3 run did not beat the q1-profile rule overall.  Its new
shape-only lead `left_interval_keys == 232` has zero corpus false positives
and covers 497,664 q6 survivors; this is discovery-only.  The result also
locates the next tooling gap: the current mutation grammar compares fields to
constants but cannot synthesize the interval/residue/hole sumset identity.
Adapter v4 closes that private gap by exporting two independently recomputed
set quantities: the number of residue/range-compatible pair keys and the
number completely covered by exact holes.  The relation
`base_sumset_pairs != hole_covered_pairs` agrees with survival on all 225
weighted cells.  Seeded with field-to-field comparison shape, evolve finds
this three-operation predicate at generation zero with perfect weighted
accuracy.  Extractor v2 binds a canonical mechanism-corpus digest and rejects
any row where that relation disagrees with direct exact survival; the proof
transcript adds the gap identity as an explicit structural step.

The q3 and q9 explicit-value compilers were rejected at the declared
100-million-value boundary rather than allowed to exhaust memory.  Their
mod-64-plus-range relaxations add no reduction beyond q0/q1.  The exact
replacement represents each dense scalar image by the proved identity
`S = ([min,max] intersect R) minus H`, where `R` is its modulo-64 residue
support and `H` its sorted holes.  The primary dense compiler and an
independent shifted-bitset compiler still agree before compression; the
sum-witness query is allocation-free, nonrecursive, and differentially tested
against direct finite sumsets.  Resource accounting now caps stored holes,
not the much larger logical value count.  With that representation, q3
completes with 172,480,220 logical pair values and q9 with 106,138,732; both
retain all 15,724,800 q0/q1 roots, with the same canonical all-root digest.
Their runs use respectively 2,345,434,106,623 and 2,176,666,401,177 cycles.
Thus q3 and q9 are exact negative reduction results, while q6 is the unique
new constraint among the multiplier-orbit representatives.

The first retained-root multiplicity audit corrects the runtime model. Only
42 of the 225 aggregated semantic rows survive q6, with weights in
`{6912,13824,62208,124416,248832,497664}` summing to 6,739,200. Their naive
per-block digit Cartesian products, weighted by root multiplicity, total
approximately `1.6411550857083569e27 = 2^90.4068`. This is an upper work
envelope, not an exact common-witness count: q1/q6 compatibility already
removes many products, but the current existence proof retains only one
witness and does not count them. Even dividing optimistically by the proved
independent-translation and common-unit normalizers (`6^4 * 14 = 18,144`)
leaves a `2^76.2596` envelope. Consequently the earlier ideal
615-million-cycles-per-root calculation was not a solve estimate; root count
alone omits the dominant digit multiplicity.

The next exact compiler now carries a 16-byte Tiger profile containing energy
and all four nontrivial quotient-shift representatives `q1,q3,q6,q9`, plus
its digit witness. It is iterative, uses one fixed 2 MiB workspace, performs
capacity validation outside the repeated kernel, and allocates zero times in
the real profile loop. Across all 528 special/zero block domains it directly
enumerates 66,601,558 digit configurations and compresses them to 20,956,714
distinct common-shift states (3.178x, 1.668 bits). Per-domain configurations
range from 121,736 to 129,668; distinct states range from 2,741 to 88,247, and
maximum state multiplicity is 552. Every profile recomputes the four PAFs from
its decoded digit word, while an independent row/energy enumerator agrees on
every domain count. The CHOOM-protected census uses 485,026,095,595
instructions, 115,288,813,324 cycles, 85,437,935,084 branches, and 377,483,818
branch misses. This block compression alone is insufficient; the decisive
next measurement is the same-witness four-block join on q1/q3/q6/q9, where
two additional exact scalar equations are heuristically expected to supply
the missing 24+ bits but have not yet been counted.

The same-witness join closes that gap.  The 24/14 q6 block classes refine to
only 31/19 full `(energy,q1,q3,q6,q9)` state-set classes: just twelve q6
classes split, every split is binary, and the fifty retained class state sets
occupy 10,674,528 bytes.  Consequently the 42 positive q6 cells refine to
only 90 full-state cells, representing all 6,739,200 roots (6,912 to 165,888
roots per cell).  A bounded hash join and a structurally different sorted-
vector oracle agree on every refined representative: all 90 cells are empty,
so all 6,739,200 q6 survivors are excluded computationally.  The complete
two-oracle run uses 1,643,846,718,990 instructions, 394,599,673,789 cycles,
245,695,412,769 branches, and 794,666,946 branch misses.  Transfer from each
representative to its roots uses equality of the complete typed block-state
sets, not an assumption that the older q6 class was sufficient.  This remains
private discovery evidence until the class partition and transfer lemma are
sealed and independently replayed.

Generic scoped feature synthesis then searched anonymous two-dimensional
pair-key observations, learning each feature's maximal valid cell mask rather
than receiving a scope.  One evolved feature covers all 90 refined cells:

`-2 q3 - q9 (mod 11)`.

It appeared after 413 bounded affine-modular candidates.  Its residue sets
form only ten cell patterns, each disjoint, although their global unions do
overlap; thus the current statement is uniform in expression but conditional
on the earlier full-state cell.  The mechanism is theorem-driven rather than
an accidental modulus.  For every length-18 quotient word, with
`C_r = sum_{j == r (mod 3)} x_j`, direct cycle decomposition gives

`sum_r C_r^2 = P0 + 2 P3 + 2 P6 + P9`,

and hence `-2 P3 - P9 = P0 + 2 P6 - sum_r C_r^2`.  The identity has a
zero-allocation test over 10,000 arbitrary quotient words.  This promotes the
evolved affine feature into an exact algebraic macro: q0/q6 plus the three
cycle sums suffice for the modulus-11 obstruction.  The remaining proof-
synthesis task is to replace the ten learned cell masks by predicates over
those earlier cycle-sum/q6 features and seal the resulting small structural
case split, rather than preserving the 90-cell join table.

Scope learning is now explicit rather than hand-authored.  A generic
multi-class equality tree takes only the four earlier joint-class coordinates
and the ten evolved residue-pattern labels.  It classifies all 90 cells
exactly with 63 iterative nodes; reverse hash-consing merges equivalent
continuations to a 38-state contextual tablebase (28 tests and ten terminal
patterns).  Nodes are explicit 8-byte `repr(C)` Tiger records.  Both synthesis
and evaluation accept preallocated storage, use no recursion, and allocate
zero times on repeated calls.  The successful affine
feature can be reloaded from its serialized report without re-evolution, with
its `Evolved` origin and blindness level preserved.  This is the first private
implementation of feature-plus-scope promotion and CGT/Myhill--Nerode-style
continuation-state reuse; global minimality of the 38-state DAG is not claimed.

The theorem-native replay makes that learned case split unnecessary for the
actual exclusion. A sealed block extractor retains only
`(energy,q1,q6,F mod 11)`, where `F=P0+2P6-sum_r C_r^2`; it independently
projects every block image back to the exact q6 compiler. Across all 528 typed
masks, the structural interface does not split a single q6 class: the 24/14
class counts remain 24/14, and the 42 q6 cells remain 42 cells while covering
all 6,739,200 roots. Thus the earlier 90-cell q3/q9 partition is valid
discovery evidence but is not needed for authority.

Two distinct exact joins exclude all 42 structural cells. The primary fixed
open-address implementation uses 69,273,218,752 instructions, 18,224,702,942
cycles, and an 18,022,832-byte workspace. The independent ordered-vector
implementation shares only the sealed block extractor; its coarse arithmetic,
direct residue convolution, sorting, and binary lookup do not share the
primary hash path. It uses 169,824,937,376 instructions, 45,781,935,477
cycles, and at most 462,545,914 workspace bytes. Both produce the same
89,694-key maximum and agree cell-for-cell.

The promoted private proof accepts only the evolved candidate
`(-2,-1,11,3)` and then re-extracts everything internally: the sealed q6
prerequisite, the 42 positive semantic-cell IDs and their total weight, the
cycle interfaces, all canonical root transfers, and both joins. Supplied JSON
and field names carry no authority. Its six-step transcript labels the cycle
identity `ProvedStructural`, but labels the exhaustive 6,739,200-root coverage
`ExactComputational`; only the latter authorizes the negative. Returning the
proof and its already-verified corpus together removes duplicate q6 extraction
inside each authority pass while preserving independent synthesis and
verification: counters fall 52.178% in instructions and 51.912% in cycles to
5,366,123,363,295 instructions and 1,297,926,920,812 cycles, with 462.6 MiB
maximum join workspace. Forged bindings, evolved coefficients, provenance,
and replay metadata fail closed. An exhaustive six-rule ablation corpus is
also wired back into evolve: its 64 rows have one positive, a 13-node exact
tree, and 22 perfect evolved plans among 981 tested. Those plans remain
diagnostic proof skeletons only.

## Transfer reduction: g41 quotient roots fall to 768

The `g=41` Z18 projection has six slots of multiplicities `1,1,2,2,6,6`.
The first two have `B=e+4k`; the other four have `B=e+2k`. Relative to signed
square baselines 9 and 1, q0 has exact defect budget

`(1976 - 4(2*9 + 16))/8 = 230`.

The six-digit bounded compiler reduces 262,144 mod-two roots to 9,216 q0
roots, then to 4,608 exact q1 roots. Its domains contain only 234,033 row/q0
configurations and 66,233 `(energy,q1)` profiles. A deliberately different
flat mixed-radix oracle enumerates all 207,360,000 raw assignments and exactly
reproduces every domain, 437,740 pair profiles, and both root counts. The q1
census uses 118,041,701,089 instructions and 18,777,675,608 cycles; the flat
oracle uses 31,114,353,400 instructions and 6,007,035,456 cycles.

Multiplier invariance gives a further structural theorem. Since
`41 == 5 (mod 18)`, quotient PAF shifts lie in the five nonzero orbits

- `{1,5,7,11,13,17}`;
- `{2,4,8,10,14,16}`;
- `{3,15}`;
- `{6,12}`; and
- `{9}`.

Together with q0, only q1, q2, q3, q6, and q9 need compilation. Exact
per-shift filters retain respectively 1,536, 2,304, 2,304, and 4,608 roots for
q2, q3, q6, and q9. Their canonical necessary-set intersection contains 768
roots, a 341.333x reduction from the mod-two shell. This composition does
**not** assert a common quotient witness: each per-shift filter is exact, but
the 768 roots are only necessary-filter survivors. Every per-shift positive
is directly replayed against row, q0, q1, and its selected shift.

Independent flat oracles each enumerate 207,360,000 assignments and reproduce
the q2/q3/q6/q9 domain counts `93303/157699/107715/146739`. The exact pair
kernel uses a fixed 16 MiB open-addressed workspace, iterative touched-slot
reset, an explicit 75% load cap, 16-byte records, and zero allocations in its
hot insertion loop. The composed filter uses 386,487,762,653 instructions,
137,615,669,947 cycles, and 138 MiB peak RSS.
On the exact-q2 retained workload, separate 100%-enabled groups record
3,482,296,382 branches / 7,590,908 misses and 236,243,728 cache references /
17,975,996 misses. The fixed-workspace q2 compiler improves the earlier
sort-all-products control from 36.37B instructions / 9.65B cycles to 26.14B /
7.46B while also removing product-loop allocation and its 20M raw-state cap.

A sealed private proof binds the carrier, generator, Z18 projection, shift
orbits, quotient theorem, canonical source semantics, and the digest of the
768 sorted root IDs. Its authority is `exact-computational`, never
`proved-structural`; it authorizes exclusions outside the set but grants no
joint-witness or certificate authority inside it. Verification recomputes
the filter and all independent domain oracles rather than trusting a large
certificate. Generation plus verification uses 978,896,150,468 instructions,
323,268,152,250 cycles, and 139 MiB peak RSS. Its six-rule Horn derive/replay
kernels use 513.024/459.024 instructions and 86.842/60.168 cycles per operation
over 20 million operations and have zero-allocation tests.

The common-witness question is now settled constructively.  A grouped exact
meet-in-the-middle compiler reuses only 40 left pair fibres across the 768
roots, packs all six coordinates into a 16-byte record, and uses the exact
`(q2,q3,q6)` image as a prefilter.  It examines 1,493,362,944 left candidates
but only 2,980,608 right candidates before finding one common quotient witness
for every root.  All 768 retained witnesses are independently decoded and
replayed against the four row sums and all ten quotient equations.  The run
uses 611,840,641,105 instructions, 183,853,612,811 cycles, and 145 MiB peak
RSS.  Thus no quotient-only theorem can further reduce the 768-root shell;
the retained witnesses are deterministic seeds for fine PAF work.

Fast-falsification records the rejected theorem shapes explicitly.  Joint
congruences modulo 8, 16, 32, 64, 3, 5, and 7 preserve all 768 roots.  Every
one of the fifteen exact two-coordinate projections also preserves all roots,
as does the exact three-coordinate `(q2,q3,q6)` projection.  The latter needs
a root-scoped fixed-workspace compiler: global materialization fails closed at
134,217,728 states and 1.14 GiB RSS, whereas eight independent workers finish
all 1,536 pair compilations with 989 MiB RSS.  These are exact negative
controls about reduction shapes, not evidence for or against a Hadamard
object.

The first fine-PAF transfer uses the order-29 character quotient.  Direct
fixed-cardinality evolution over the 24 orbit masks preserves the retained
quotient witness and checks every character hit against the original four row
sums and all 521 nonzero PAF equations.  After correcting a packed-radix mask
bug (all earlier runs are void controls), 491,520,000 mutations reached exact
character residual 8 but no hit.  An exact radius-two scout found no improving
swap.  These misses are discovery-only.

A generic raw-vector miner now discovers the symmetry and scope that were
first noticed manually. Given only the best 29-coordinate correlation vector,
it searches unit actions and recovers multipliers 12 and 17 with the
eight-orbit quotient (zero plus seven order-four cosets); no coset table is
supplied to the miner. It compresses the residual to a signed support motif,
recovering the residual-eight pattern as exactly one `-1` orbit and one `+1`
orbit. The evolve kernel now retains its best sixteen motifs and a 768-bit
root scope for nonzero residual sums, with explicit discovery-only provenance.

The hottest scoring loop used to sum all 28 nonzero coordinates even though
the sealed multiplier action makes each order-four coset constant. A private
`ResidualTuple<i32,7>` scorer reduces this to seven representatives. On an
identical one-thread 15.36-million-mutation A/B it preserves the exact best
correlation and orbit selection while removing 6.916% instructions, 4.145%
cycles, and 9.903% branch misses. An eight-thread 768,000-mutation A/B also
preserves the exact search result and removes 3.455% instructions, 5.589%
cycles, and 3.541% branch misses, including unchanged quotient-census
overhead. The hot scorer and differential oracle allocate zero times.

The mined residuals also expose an exact earlier-feature relation. For row
sums `260,261,261,261`, zero-shift correlation `A0`, and seven coset
residuals `d_i`, the global autocorrelation identity gives

`4 sum_i d_i = 260^2 + 3*261^2 - 29 A0 + 28*523`.

Consequently `A0=9883` forces balance. In that scope, residual eight is the
smallest possible nonzero score and necessarily has the observed `+1/-1`
two-orbit form. A low-budget all-root run finds 166/768 best candidates with
nonzero residual sum and records their exact ordinal mask, so balance is not
silently promoted to a global root theorem. Deriving the seventh coordinate
from the affine sum was also A/B tested: it preserved results but regressed
cycles by 1.20% and branch misses by 3.75%, so the seven-load kernel remains
the admitted implementation. The affine identity is retained as a search
feature, lower bound, and scope-learning input.

The affine sum is now also available as a const-specialized evolution pressure
with weights `0,1,2,4`, dispatched outside the mutation loop.  On the same
768-interface, 768,000-mutation counter workload, weights `0/1/2/4` leave
instructions essentially fixed at `603.397/603.405/603.406/603.406` billion.
Weights two and four reduce best-candidate nonzero-sum scopes from 166 roots
to 7 and 4, but worsen the best exact residual from 48 to 56; they remain
optional discovery features rather than the default objective.

The former one-witness-per-root model is now removed.  An exact weighted join
counts 1,024,896 common quotient-profile quadruples and 1,984,512 raw packed
digit quadruples over the 768 roots, with 1,800--3,662 raw interfaces per
root.  There are exactly four multiplicity classes, each on 192 roots:
`(1006,1800)`, `(982,2140)`, `(1756,2734)`, and `(1594,3662)`, where each pair
is `(profile quadruples, raw digit quadruples)`.  A structurally independent
sorted-range enumerator materializes all 1,984,512 raw interfaces and directly
replays all ten quotient equations, agreeing exactly with the weighted count.
The weighted census uses 1.690 trillion instructions, 732.2 billion cycles,
and 159 MiB RSS; the deliberately slower direct oracle uses 4.354 trillion
instructions, 2.220 trillion cycles, and 268 MiB RSS.

A sealed 47,631,472-byte binary cache now binds the canonical extractor
semantics, carrier/quotient/multiplier parameters, root masks, exact digit
payload, and payload SHA-256
`073389e9cc725e44eb3674a4f5f241710a06324b99f3c395ada3ccebcd8dca98`.
Both writing and loading replay every witness; malformed payloads, forged
semantics, trailing bytes, and budget overflow fail closed.  Verified cached
load plus one initialization on every interface costs 117.8 billion
instructions, 46.2 billion cycles, and 56 MiB RSS, versus 2.117 trillion cycles
to regenerate the cache.  A 16-thread, 1,984,512,000-mutation pass over every
raw interface then completes in 8.179 trillion aggregate cycles and reaches
residual 16 with no q29 hit.  Its misses are discovery-only; its exact digit
binding repairs the earlier arbitrary-preimage provenance defect.

The exact q29 lift is now expressed in theorem-native nonnegative coordinates.
For every cyclic coefficient vector `x`,

`2 D_s = 2(A_0-A_s) = sum_r (x_r-x_{r+s})^2`.

Thus `D_s >= 0`, while the four-block character equations are exactly
`sum_blocks D_s = 523` on each of the seven multiplier cosets. Any one-block
defect above 523 is therefore impossible before a pair join. Complementation
`x -> 18-x` preserves all `D_s`; on each row-261 block it canonically pairs
`(mask,digits)` with its bit/count complement, explaining and halving the five
observed mask pairs. A private generic cyclic-Dirichlet feature primitive now
generates these coordinates from anonymous raw vectors with zero allocations;
its differential oracle recovers both autocorrelation defects and complement
invariance without q29-labelled fields. The exact fixed-workspace block
tablebase and four-block complement join are in progress.

The mod-8/mod-16 seed-power scouts have a narrower contract than their first
field name suggested. Their modular state images and infeasibility verdicts
are exact for the selected quotient witness, and any zero representative is
directly replayed. For a feasible modular state, however, the join retains one
arbitrary preimage and rescored only that representative; its exact residual
is not a minimum over the modular fibre. The private report field and
provenance now say `representative_exact_residual`, and no best-residual or
negative claim may use it.

A blind mod-16 coefficient-image lift is rejected as a scaling design.  It
fails closed in block 0 at the sixth slot after 12,582,912 states, using
694,746,113,496 instructions, 307,908,402,245 cycles, and 495 MiB RSS.  The
replacement is the structural identity

`A_s(a + 2^k x) = A_s(a) + 2^k B_s(a,x) (mod 2^(k+1))`,

whose quadratic lift term vanishes for `k >= 1`.  A reusable private theorem
kernel proves/replays this one-bit lift without allocation or recursion and
matches a direct autocorrelation oracle exhaustively on small carriers.  Its
q29 specialization stores each mod-eight coefficient state with a 256-bit
fibre of reachable lift vectors.  On the retained root `3759256`, block 0
compresses 14,850,319 full mod-16 states to 262,144 fibres (56.65x), finishes
in 823,804,020,759 instructions and 234,059,873,050 cycles, and peaks at 150
MiB RSS.  The four exact block images contain
`262144/262144/129088/262144` correlation profiles.

Observed power-of-two image sizes suggested affine closure, but exact closure
testing falsified that stronger conjecture.  The weaker additive-hull theorem
is useful: a bounded allocation-free Smith-style reducer over `Z/2^k`, checked
exhaustively against brute force on all small two-generator systems, proves
that all four images lie in cosets of the same order-`2^27` subgroup of
`(Z/16)^8`.  Its pivots are `[1,1,1,1,1,1,2]`, so the quotient has order 32
(one mod-16 and one mod-two invariant).  This is a compact 32x structural
profile reduction, not a large certificate.  The current witness satisfies
both invariants.  Eight further roots checked concurrently have the identical
four hull sizes and all retain the target; their exact image sizes fall into
the small family `262144`, `262143`, `129088`, and `258112`.  This supports a
universal representation theorem but supplies no observed root pruning.

The subgroup reducer's real loop uses a fixed `8 x 64` stack matrix, no
recursion, and zero allocations.  Three separate nonmultiplexed 20-million-op
counter runs record 14,863.210 instructions, 2,333.133 cycles, 2,166.067
branches, 0.0858 branch misses, 0.0513 cache references, and 0.00152 cache
misses per membership decision.  The malformed-input and exhaustive small
brute-force oracles pass.

The order-32 quotient is now explained rather than merely observed.  A new
domain-neutral private kernel reconstructs any weighted binary orbit
autocorrelation as a quadratic form by checking its values on basis vectors
and basis pairs.  This is a bounded structural transcript (at most 64
variables), not a truth-table certificate.  On the canonical order-29
quartic classes it proves

`sum_{C != 0} A_C(c) == sum_{C != 0} c_C (mod 2)`.

The synthesized form has diagonal mask `0xfe` and no mixed terms.  The other
quotient coordinate is the reindexed-double-sum identity

`A_0 + 4 sum_{C != 0} A_C == (sum_i c_i)^2 (mod 16)`.

Together they define a surjective map to `Z/16 x Z/2`, whose kernel has order
`2^27`; the independently compiled subgroup has that same order and lies in
the kernel, so equality follows.  For each fixed quotient witness, the six
large-orbit families have nonzero-class parity one and the six singleton
families parity zero, making the binary coordinate directly computable from
the packed quotient digits.  An independent replay of the saved 768 common
witnesses finds parity zero for all 768.  Thus the index-32 law is a genuine
theorem and a reusable compression, but it cannot exclude any stored witness.
It remains witness-local for authority because only one common quotient
witness per root has been retained.

Quadratic synthesis and replay are iterative and allocation-free.  Under
CHOOM, separate 100%-enabled counter groups give 358,688 instructions / 66,053
cycles / 14,552 branches / 72.3 branch misses / 1.08 cache references / 0.12
cache misses per canonical q29 synthesis over 100,000 operations.  Replay uses
94.0 instructions and 52.2 cycles per evaluation over 20 million operations.
The cold synthesis is performed once per registered orbit semantics.

A deterministic `2^20`-sample MITM then found an exact mod-16 four-block
profile match among 1,016,529 distinct left sums.  Iterative backwards replay
reconstructed all 24 orbit masks from the compressed fibres and rescored the
result directly; its exact q29 residual is 44,544, so it is not a positive.
A seeded 20,000,000-mutation descent reaches residual 24, worse than the
existing residual-8 basin.  Sampled misses and hull membership carry no
authority.  In particular, all of these measurements condition on one
retained common quotient witness per root; no root exclusion follows until
all quotient witnesses are covered or a witness-independent theorem is
proved.

## Scoped q29 profile endgames

The sealed all-interface cache was recast as a reusable endgame DAG rather
than a per-interface search tree.  Its 1,984,512 raw interfaces contain 1,498
complement-canonical block domains, 39,522 canonical pair domains, and 248,064
canonical four-block domains.  The still coarser slot-aggregate presentation
has only 70 block signatures, 775 pair signatures, and 4,224 witnessed
signature quadruples (132--176 per root).  The cold exact census costs
12,153,380,115 instructions and 3,865,792,330 cycles at 100% counter coverage,
with 357,820 KiB peak RSS.

Compiling all 70 exact aggregate profile tables exposes a stronger structural
normalization: their profile SHA-256 values fall into exactly four classes.
The 4,224 ordered signature quadruples consequently become six ordered class
quadruples and only two commutative four-sum problems, `A+C+2*B1` and
`A+C+2*B5`.  This is currently exact-computational evidence over every
witnessed aggregate signature, not yet a promoted structural theorem about
the underlying bounded composition map.  The 70-table run uses
8,100,137,466,341 instructions, 4,916,259,385,943 cycles, and 656,248 KiB peak
RSS under CHOOM.  Its exact energy-class join eliminates none of the 4,224
signature quadruples; all survive with 112,535,808 energy-class quadruples.
Energy-only signature scoping is therefore a closed negative control.

The original `B1` archetype retains the authenticated residual-eight basin.
For the new `B5` archetype, private parallel profile evolution scores
18,747,565,738 candidates and reaches the minimum nonzero L1 residual two,
with sums `[524,522,523,523,523,523,523]`.  Its exact two-block repair misses,
and its full difference lattice again has index 58.  The run uses
1,861,476,196,981 instructions, 525,251,762,097 cycles, and 631,780 KiB peak
RSS.  These are discovery results; neither a miss nor lattice membership has
exclusion authority.

A bounded exact local endgame now implements the zero-cost witness handoff:
the hot table stores only 16-byte pair sums, and recovers pair indices by
replay only after a hit.  It is iterative and allocation-free after workspace
construction.  Around the residual-two state, the 8,192-per-block run checks
67,108,864 left and 67,108,864 right pairs, thereby closing the exact finite
`8192^4` neighbourhood, with no hit.  It uses 425,327,823,415 instructions,
317,063,310,374 cycles, and 1,161,544 KiB peak RSS under CHOOM.  Almost every
left sum is distinct (67,106,148), so pair-sum deduplication is not a useful
compression.

The remaining exact problem is consequently sharp but not yet launchable.
The smaller full pair side has about 1.61 trillion pairs and would require
roughly 25.8 TB at 16 bytes per sum; the middle/middle side can reach about
2.44 trillion pairs.  Counter extrapolation suggests that raw pair generation
is compute-plausible on sixteen cores, but the current in-memory sort is not,
and no bounded low-memory exhaustive join has been established.  There is
still no defensible under-one-day solve estimate or solve launch.

Separately, the profile-difference index-58 observation now has a sealed
private proof object.  It binds extractor identity/version, canonical field
semantics, source table signatures/digests/counts, the authenticated seed,
concrete basis origins, and the canonical correction.  Independent replay
checks all 4,664,438 source differences, determinant/Cramer arithmetic, and
the mod-2/mod-29 null functionals; forged source, basis, and correction values
are rejected.  The issue-plus-verify adversarial harness uses
2,193,661,575,959 instructions, 803,844,671,362 cycles, and 622,012 KiB peak
RSS.  This theorem explains why linear congruences do not prune; it is not
itself a solve reduction.

## Mixed-CRT divisor-lattice refinement

The exact two-coordinate q29 shard found a genuine aggregate-profile hit in
the `A+C+2*B5` class, with profile indices
`[79074,20395,329,567565]` and seven sums all equal to 523.  A sealed cached
interface with root `3494740`, masks `[20,13,21,13]`, and digits
`[2215340,1953396,1957340,1958308]` contains all four profiles.  Exact lifts
and direct word replay give row sums `[260,261,261,261]` and q29 residual zero,
but all 521 original PAF shifts fail, with L1 residual 13,888 and maximum
absolute residual 388.  Thus q29-layer emptiness is false; this positive is not
a Hadamard positive.

The four profile targets have respectively `1,1,2,1` q29 coefficient-vector
preimages.  More importantly, their first coefficient lifts have
`2,325,681`, `1,110,122`, `55,573,110`, and `9,540,026` distinct allocation
fibres before binary orbit orientation.  This closes the misleading idea that
one q29 profile hit represents only its observed `2^38` orientation fibre.
The bounded iterative decomposition DP now counts all allocation paths while
retaining one independently replayed witness; it does not recurse.

Inside the observed orientation fibre, a full-PAF meet-in-the-middle exactly
excluded all `2^38` choices by factoring them into block tables of sizes
`1024,256,1024,1024`.  Its first end-to-end measurement was dominated by two
repeated quotient censuses.  A reusable authenticated context removes that
error: one solve uses 614,420,431,704 instructions including cold setup, while
four solves use 617,781,361,875, so each additional exact fibre costs about
1.12031 billion instructions.  Cold setup is paid once per campaign.  The hot
pair handoff is now one additive 64-bit fingerprint plus a packed state ID in
16 bytes; hash collisions can add exact replay work but cannot remove a hit.
Packed cyclic PAF agrees with a direct 522-position oracle and allocates zero.

The mechanism behind the next reduction is the divisor lattice of 522.  For
any divisor `d`, quotienting a binary word modulo `d` partitions the original
PAF shifts.  Therefore a supplementary family with total row weight 1043 and
nonzero PAF target 520 must have quotient defect
`sum_b(A_b(0)-A_b(t)) = 523` at every nonzero `t in Z/d`.  A domain-neutral
private extractor proves this by direct quotient compilation; an independent
shift-partition oracle, the cyclic `(7,3,1)` difference set, malformed words,
and allocation tests are green.

A blind bounded divisor-lattice miner, given only the four authenticated
522-bit words and the SDS parameters, tests divisors in increasing order.  It
rediscovers 18 and 29 as exact controls and selects 58 as the first
obstruction after seven candidates, with 57 mismatches and L1 residual 65,888.
This is `FeatureOrigin::Evolved`; the modulus was not seeded.  Direct scouts
also reject the observed selection at moduli 87, 174, and 261.  The typed q87
cell extractor records the important negative control that q87 is not a
function of the 42 q29 allocation counts alone: paired q29 orbits retain
distinct mixed-CRT variants.

An exact q58 endgame then enumerated all 3,328 binary orientations of the
observed q29 fibre.  Every block table became empty before a four-block join:
each orientation has some nonnegative block q58 defect above the entire budget
523.  The run, including cold authentication, used 613,399,387,962
instructions and 183,864,487,603 cycles.  This excludes that one allocation
fibre structurally at q58.

The complete split box above each q29 coefficient vector is now finite and
measured.  The first four vectors have respectively
`74,131,200`, `61,158,240`, `96,800,000`, and `48,648,600` splits; q58's
nonnegative per-block budget retains `6,360,102`, `5,117,764`, `7,424,384`,
and `4,158,676`.  This is a combined `21,244.27x = 2^14.375...` reduction
before any four-block matching.  Canonical exact q58 profile counts are
`3,159,035`, `2,510,099`, `3,643,376`, and `2,041,635`.  The second legitimate
block-two preimage has `97,200,000` splits, `7,501,504` budget survivors, and
`3,680,680` profiles.  These are coefficient-tuple-scoped counts, not a global
q29-hit multiplicity bound.

The q58 presentation admits a smaller structural form.  In CRT coordinates
write the two lifts over each residue modulo 29 as their sum `c` and the
even-minus-odd difference `y`; the latter includes the necessary `(-1)^r`
twist when expressed by the representatives `r,r+29`.  If `Q_s` is the fixed
q29 defect, `E=sum y_r^2`, and `Y_s=sum y_r y_{r+s}`, then the paired q58
defects are

    2 D_t     = Q_s + E - (-1)^t Y_s,
    2 D_{t+29}= Q_s + E + (-1)^t Y_s.

Consequently the four-block q58 equations are exactly one energy target
`sum E=523` and seven signed autocorrelation targets `sum Y_s=0`.  A private
`ResidualTuple<i16,7>` carrier therefore replaces fifteen unsigned defects;
the canonical profile shrinks from 24 to 16 bytes.  Direct 58-cell replay and
an exhaustive 256-state small split box independently verify the identity,
including the CRT twist, and the hot extractor allocates zero.  The new census
reproduces every survivor and deduplicated-profile count above while using
451,160,170,990 instructions and 86,291,183,865 cycles, about 3.1x fewer than
the former 15-defect compiler.  Two source-shape experiments were rejected:
a runtime quadratic-form family used 564,293,750,462 instructions and
77,029,181,503 branches, while an explicitly fused seven-update loop used
600,461,317,478 instructions.  The compiler's fixed nested correlations remain
the admitted hot kernel.

The evolved feature DAG now accepts an earlier nonnegative terminal and
blindly exact-checks every later anonymous coordinate or coordinate-pair sum
from one preallocated workspace.  On both block-two preimages, energy alone,
energy plus each of the seven signed residuals, and energy plus every one of
the 21 signed residual-pair sums all reach their targets.  The earlier
15-defect controls likewise found no exact energy/coordinate or
energy/two-coordinate-sum obstruction, and sampled-propose/exact-verify affine
modular evolution through modulus 32 found none in the canonical eight-field
presentation.  These are explicit closed negative grammars, not exclusion
claims.  Full-coordinate affine-hull evolution over small prime moduli is the
next cheap terminal before any high-dimensional exact join.  There remains no
defensible under-one-day global solve estimate or solve launch.

### Reachable q58 profiles and Fourier-to-Gram promotion

The first high-dimensional follow-up replaced the fifteen-defect carrier by
the exact 16-byte anti-profile `(E,Y_1,...,Y_7)`.  A fixed-cap hash table now
collects only profiles reached by the actual six-slot fine-orbit allocation
DP, retaining the numerically least packed source state for every profile.
The profile digest binds both the exact anti-profile and that canonical source
state.  Duplicate insertion, extraction, and the repeated hot loop allocate
zero times.  The four-coordinate shard loop is explicit and iterative; there
is no search-tree recursion.

A bounded exact complementary-energy join stores seven residual coordinates
and two 20-bit profile identifiers in one 16-byte `u128` record.  The former
16-bit source-ID contract was too small for the producer's explicit 786,432
profile cap and is retired without increasing the hot record.  Four reachable
block images are compiled in parallel.  A join hit is replayed first through
the fine-orbit allocation DP and then by reconstructing all four binary rows
on `Z/522Z` and directly checking the row weights and all 521 nonzero cyclic
defects.  Quotient or evolved predicates cannot authorize a positive.

The evolve bridge now exposes rounded q29 Fourier directions as
**discovery-only** integer witness sources.  A sealed compiler independently
derives each source's exact cyclic Gram-square coefficients; only that integer
identity is used for pruning.  The 126 distinct compiled predicates reduce
the four split-box profile sets from `[14936,33909,11264,31962]` after sparse
Gram masks to `[4865,14646,3455,14268]`.  A direct real spectral-limit control
retains `[4864,14642,3454,14264]`, only ten fewer profiles in total, so this
finite integer family is already a near-complete description of the PSD cone
on the measured presentation.  The control is discovery evidence, not proof
authority.

The cross-level q29/q58 energy adapter stores one 24-byte hot q29 profile plus
a cold union of exact energy fibres.  Across the four concrete interfaces it
reduces 400 energy classes to 199 and the raw profile-quartet mass from
`3940644537105098645821635` to `1970787002602119036757093`, essentially twofold.
An anonymous 336-feature modular grammar is completely saturated.  Adding 42
integer interval features finds one exact `x0+x1` interval and removes seven
tiny classes, but changes mass by only about `5.2e-9`; exact support promotion
finds no further holes.  These controls teach the generic class--feature--cover--
promotion loop how to rediscover the banked reduction while also showing that
low-arity q29 arithmetic is not the missing large reduction.

The literature suggestion from Perera--Kotsireas is retained only in this
safe form.  Residue-class compression has the exact identity
`DFT_m(comp(X))(j)=DFT_l(X)(dj)` for `l=md`; it does not justify the quoted
generic `d^2(2l+2)` ceiling.  Under the Legendre PAF normalization stated in
the supplied summary, summing all shifts gives squared zero-frequency sums
totalling 2, not 4.  The accessible primary abstract supports a low-complexity
odd-length DFT matrix evaluator, but not those two quoted formulas; the
article's own introduction says Djokovic--Kotsireas compression still has to
be integrated as future work before tackling the smallest open Legendre
length.  The supplied “PSD compression upper bound theorem” is therefore not
attributable to this paper.  C1016 uses Fourier directions only to propose
exact integer Gram witnesses and keeps the already stronger exact
quotient-defect theorem for compression.

The original four-coordinate census confirms `94763,71771,503474,106098`
exact q29-projection state visits and `40164,28143,83888,63188` q58-budget
survivor visits.  It uses 121,602,565,379,154 instructions and
25,549,977,170,316 cycles.  The dominant defect was structural: every one of
roughly 112 million block-zero penultimate states scanned all 357 final-slot
contributions even though q29 additivity determines the required final
projection exactly.  Presorted projected contributions plus a fixed 512-slot
complement-support hash reduce that penultimate image to 114,421 completable
states and reproduce the 94,763/40,164 terminals exactly.  The optimized
block-zero counter run uses 498,087,803,930 instructions and 119,019,364,138
cycles.  The full four-worker compiler and exact join use
2,613,369,529,680 instructions and 674,475,467,660 cycles; maximum join storage
is 1,215,216 bytes.  The reachable anti-profile counts are
`24275,20230,39977,36859`.

The original pre-projection compiler subsequently completed independently in
121,733,738,267,020 instructions and 25,583,330,077,471 cycles.  For all four
blocks it reproduces those exact profile counts and all four 256-bit reachable
profile digests.  Thus the projection-complement optimization changes the
penultimate visits and peak state counts, but not the reachable tablebase.

That join finds a q58 collision after 318,299 right-pair and 1,167 left-pair
checks.  All four canonical fine allocations replay and have row weights
`[260,261,261,261]`, but direct all-521-shift replay rejects the candidate with
L1 residual 12,976 and maximum residual 384.  Divisor replay is exact through
2, 3, 6, 9, 18, 29, and 58.  The first missing mixed sector is q87: all 86
nonzero q87 shifts fail, with quotient L1 residual 58,464 and maximum residual
1,062.  The q58 collision is discovery input, never positive authority.

### q87 Eisenstein four-token endgame

For each residue modulo 29, let `(a,b,c)` be its three lift counts modulo 87.
The mixed order-three character has exact squared norm

    e(a,b,c)=a^2+b^2+c^2-ab-bc-ca.

The private q87 adapter computes each coordinate's exact triple sumset from
the concrete six-slot fine-orbit interface and then deliberately forgets
cross-coordinate correlations.  The zero coordinate has a singleton energy;
at every nonzero coordinate all supported energies have one residue modulo
nine.  Since nonzero q29 multiplier orbits have size four, every block energy
therefore lies in one residue modulo 36.  Exact bounded convolution gives the
four complete progressions

    E=(101,93,24,161)+36(n0,n1,n2,n3).

The mixed-character Parseval equation is `sum E=523`, hence exactly
`n0+n1+n2+n3=4`.  The entire marginal q87 layer is the 35 weak compositions
of four into four parts, down from 22,176 raw energy quartets: a `633.6x`
reduction and a literal four-token endgame state.

A sealed private proof object binds the extractor identity/version, concrete
interfaces, q29 coefficients, exact local supports, source digest, progression
bases, step 36, and total defect four.  Verification independently recompiles
the fine-orbit sumsets; forged source digests and counts are rejected.  A
direct fine-orbit word supplies an independent positive support oracle.  No
large certificate or feature name is trusted.

An exact correlation-preserving lift compiler now tests those five marginal
energies per block against the same concrete six-slot source interface.  It
uses a bounded, iterative, three-plus-three MITM over a collision-free 72-bit
coefficient state and an exact 40-bit q29 projection key.  The partition is
chosen canonically to balance the six measured slot cardinalities; all kernel
vectors are presized and the pair loop allocates nothing.  Exhaustive replay
proves that block zero cannot attain its base energy, so `n0>=1`, and that
block two can attain only defects `n2 in {0,3,4}`.  Blocks one and three attain
all five requested defects.  Together with `sum n_i=4`, these facts leave
exactly 11 energy quartets, not 35.  The block-two exhaustive join, the largest
one, checks 228,899,520 exact projection-compatible pairs in 19,337,656,833
cycles with 222,060,800 bytes of bounded workspace.

The sealed exact-lift proof recompiles all four joins and records allowed masks
`[30,31,25,31]`; it binds the extractor semantics and concrete source digest
and derives the count 11 internally.  Its profiled issuance uses
86,976,847,316 instructions and 25,353,753,804 cycles at 100% counter
coverage.  This is a small recomputable proof object, not a retained state
certificate.  The remaining proof-synthesis task is to mine the tiny set of
reachable local-energy vectors for a simpler structural identity explaining
the exclusions, then replace the exhaustive compiler when that identity has
an independent source-space derivation.

The generic evolve bridge was extended in response to a real failure.  Its
first 33-node training tree was exact but failed independent holdout.  A new
theorem-agnostic constant-on-positive conjunction proposer now precedes a
complex tree.  Given all 15 anonymously permuted nonempty subset sums, it
selects only `f014==523`; Ergodis retains one perfect evolved candidate on
11,176 training rows and the unchanged plan is perfect on 11,000 disjoint
holdout rows.  The run uses 922,903,278 instructions and 198,460,273 cycles at
100% counter coverage.  The field remains diagnostic; authority comes only
from the sealed Eisenstein compiler and independent replay.

The next progressive-blindness round expands the complete block-two marginal
local-energy domain (432 vectors) and labels it by exact q174-source
reachability: 409 vectors occur and 23 do not.  A generic sparse-exception DNF
fits the training exceptions but fails the disjoint holdout, so that trace is
retained as rejected rather than promoted.  A new theorem-agnostic existential
feature projector then evaluates all 510 anonymously permuted nonempty subset
sums of raw coordinate energies and within-coordinate ranks.  It discovers a
scoped support gap `f110 != 38`, and Ergodis evolves the one-literal predicate
with perfect deterministic projected replay in 10,620,918 cycles.  Decoding
after discovery identifies `f110` as q29 coordinates 1--6: the forbidden value
would require energy-zero triples `(3,3,3)` at coordinates 1,2,3,5 and
energy-19 permutations of `(1,3,6)` at both coordinates 4 and 6.  This is a
valid additional per-root reduction, but it is not the earlier defect-1/2
exclusion.  The full-energy feature is `f248`; its exact attainable support
omits 15 and 24, precisely those two defects.  The tie demonstrates that local
pruning score alone is the wrong scope objective: candidate projections must
be retained as a Pareto set and scored through their known downstream theorem
consumers.

Complete exact local-vector censuses for the four blocks retain respectively
304, 630, 409, and 262 vectors.  Their joins visit 27,354,320; 19,940,464;
228,899,520; and 26,208,768 q29-compatible pairs.  These compact domains are
the first reusable endgame tables for automatically composing earlier
features into later necessary supports.

All results in these subsections remain uncommitted private working evidence.

## Public-core enhancement ledger (do not implement in C1016)

These are reusable Ergodis capabilities encountered here that would belong in
public core. C1016 records them only and uses private adapters; it must not
modify core.

- **Relational evolution grammar.** Mutation can substitute fields and
  constants in an existing program, but it does not introduce field-to-field
  comparisons or arithmetic/set combinators. The private workaround seeds
  `base_sumset_pairs != hole_covered_pairs` explicitly and exports derived
  semantic fields. The fourteen-corpus blind harness confirms the same
  boundary: its generic decision-tree proposer can discover which supplied
  coordinates matter, but current evolution cannot grow the arithmetic that
  derives those coordinates from raw orbit observations. The private
  pairwise-difference, bounded subset-sum, zero-conjunction, and
  constant-on-positive conjunction proposers close the first relational layer
  without touching core; the q87 holdout failure demonstrates why invariant
  preference must precede a complex exact training tree.  General bounded
  typed arithmetic-expression growth remains ledgered here.
- **Counterexample-guided campaign refinement.** A campaign presentation is
  frozen, so an evolve--exact-oracle loop must start a new private campaign to
  append the smallest obstruction. A reusable core design would need a new
  provenance-bound presentation/version transition, never in-place mutation.
- **Typed set-theorem templates.** Interval/residue/hole identities and their
  zero-allocation sum-witness kernels are presently private. A future generic
  registry would need sealed extractor identity, canonical set semantics,
  independent reconstruction, and fail-closed resource bounds before it could
  issue necessary authority.
- **Persistent typed feature DAG and contextual scopes.** Successful evolved
  expressions should become hashed, costed terminals for later campaigns,
  paired with a learned scope predicate and explicit `evolved`, `human-fed`,
  or `theorem-derived` provenance.  The private C1016 layer now learns maximal
  128-bit scope masks, reuses serialized features, and evaluates candidates
  without hot-loop allocation.  A public design would additionally need
  canonical typed expression semantics, presentation-version transitions,
  held-out/direct-oracle replay, and sealed promotion rules.  Keep this private
  until those authority boundaries exist.
- **Existential feature projection and downstream-aware scope learning.** A
  complete reachable domain can be projected through every earlier feature to
  synthesize its exact attainable-value support without a theorem-specific
  adapter.  The private projector and sparse-exception proposer now exercise
  that loop.  The q87 `f110`/`f248` tie shows that maximizing local pruning is
  insufficient: a reusable implementation should preserve a Pareto frontier
  of support size, evaluation cost, scope size, and compatibility with known
  downstream constraints, then let later joins select the useful mask.

## Exact q174 sufficient-state hierarchy and evolved q87 endgame

The first concrete g41 root now has an exact common-refinement tablebase at
`lcm(58,87)=174`. Forty-six multiplier-orbit coefficient lanes fit in a
92-bit packed state. A balanced iterative three-plus-three MITM enforces the
q29 coefficients, memoizes each q58 anti-profile once, and extracts scoped q87
features without allocation in either hot hash loop. Independent oracles
compare the packed state with direct q29, q58, and q87 projections and recover
source orbit masks before any original-space claim.

A flat scoped-profile join was the wrong abstraction. The same exact data are
now represented hierarchically as a canonical q58 group followed by its q87
fibre. For the four concrete blocks, 19,335,289 scoped profiles collapse to
only 24,275; 20,230; 39,977; and 36,859 q58 groups. The grouped join visits
318,299 right group pairs, 6,666 left group pairs, three complementary group
quartets before its first collision, and only 487,098 q87 fibre pairs. A
complete scan finds exactly four broad profile quartets. The compile, join,
q174 allocation recovery, and independent all-521 replay retire
813,523,947,740 cycles and 3,190,249,043,907 instructions at 100% counter
coverage; observed RSS is 1.52 GiB. All four stored representatives fail
direct replay, but representative failure is explicitly non-authoritative.

The exact second-stage lift rescans each source block once and enumerates every
q174 state behind those four target profiles. It finds only 192, 224, 256, and
56 unique states in total; individual fibres contain 8--128 states. A
collision-free 43-coordinate q87 pair key then exhausts all four target
quartets with 4,096 right entries and 28,672 left-pair checks. No full-q87
lift exists. The endgame itself costs 18,301,122 cycles. Negative authority
comes from the exhaustive source rescan plus this exact lift, never from a
retained representative or the JSON discovery presentation.

Progressive scope evolution over the fifteen multiplier/conjugacy shift
classes exposed a structural defect in the original scope: shifts 4 and 10
belong to the same class, so the fourth coordinate was identically redundant.
An adversarial scoped-complement regression caught and rejected an initial
false result that complemented unselected coordinates to 523. After the fix,
ten single new classes independently empty all four exact target fibres;
classes 14 and 29 do not. Deterministic lowest-class selection chooses shift
1 as the later feature. Keeping `[4,6,33]` in the broad table and shift 1 in
the exact endgame is materially better than flattening `[1,4,6,33]`: block 2
exceeds the 12,582,912-profile budget in the flat representation, whereas the
hierarchy stays bounded.

Removing redundant shift 10 preserves every profile count, group count,
fibre maximum, and all four broad matches exactly, an independent differential
oracle. It reduces the complete broad compile/join from 810,726,987,040 to
707,670,323,573 cycles (12.7%) and shrinks profile records from 26 to 24 bytes
and q87 pair records from 20 to 16 bytes. Rebound exact target-fibre issuance
reproduces the same state counts and drops from 1,420,128,558,877 to
1,155,355,040,441 cycles. The one-coordinate scope evolution itself costs
197,488,267 cycles. Hardware counters are nonmultiplexed and all runs are
CHOOM-protected.

The scope evaluator is now connected back to Ergodis rather than remaining a
hand-written ranking endpoint. A compiled context reuses all 43 exact defect
vectors across candidate masks, reducing the twelve-scope evaluation from
197,488,267 to 69,414,617 cycles. A generic adapter presents the twelve
candidate classes as a source-bound opaque one-hot corpus: ten exact positive
scopes and two negatives, with no shift number, theorem name, mask, or target
semantics visible to the campaign. The existing blind Ergodis harness builds a
five-node depth-two tree, evolves 974 candidates, and retains 19 perfect plans
in 63,865,983 cycles. Its best plan tests opaque fields `f001` and `f010` for
zero. Only after evolution does the decoder identify those fields as classes
14 and 29, exactly the two insufficient singleton scopes. This is
discovery-only plan evidence; exact target-fibre replay remains the authority.

This is the desired reusable mechanism: an earlier exact feature becomes an
outer sufficient-state table; later features are evolved against only the
small lifted fibres; successful scopes are replayed by typed source
extractors; and expensive high-entropy coordinates stay out of the broad key.
The first proposed scale-up bound through all 1,498 canonical block
specifications was rejected during semantic replay: `(mask,digits)` does not
uniquely determine the q29 coefficient target. The q174 mechanism is sound
for a bound target fibre, but it cannot be charged once per coarse block
specification. Global scale-up must first enumerate the exact q29 profile
hits and retain their source-target provenance.

An exact two-prime 2D NTT/CRT census now closes the memory question for that
q29 layer without generating any pair keys. The two global aggregate joins
share the `A+C` side. Across projection coordinates 0 and 1, `A+C` has
259,134,857,721 relevant raw pairs in 175,834 nonempty shards; its maximum
raw shard is 12,790,280 pairs. `B1+B1` has 84,715,482,675 raw pairs and a
6,154,373 maximum, while `B5+B5` has 346,688,396,767 and an 18,340,973
maximum. Only `A+C` is materialized, so the existing fixed 16,777,216-entry
u64 workspace (128 MiB) is sufficient for every shard; both B sides stream.
The census fails closed if the two CRT primes cannot represent every possible
pair count, uses 52,528,256 bytes of temporary workspace, and has independent
small cyclic-convolution and NTT round-trip oracles. The three-convolution run
retires 330,030,461,003 cycles and 505,872,623,574 instructions at 100%
counter coverage under CHOOM.

Maximum-shard kernel probes also show that the remaining five coordinate
bounds are strong: the 12,790,280-pair maximum `A+C` shard emits 902,984
stored keys, and the 18,340,973-pair maximum `B5+B5` shard emits 1,202,692
streamed probes. Repeated in-process calibration, excluding the shared cold
tablebase cost by counter subtraction, places the current hot work at roughly
80--92 instructions per raw pair plus left-key sorting. The complete two-join
raw envelope is 690,538,737,163 pair visits, with the left sort paid once if
both right archetypes share a campaign adapter. This makes the exact q29
profile layer plausibly sub-hour on sixteen workers, but is not yet an
end-to-end solve bound: the number and source multiplicity of exact profile
hits passed into the q174 lift is still unmeasured.

The dual-archetype campaign now measures that layer exactly. It sorts each
`A+C` shard once, streams both `B1+B1` and `B5+B5`, retains duplicate left
keys so quartet multiplicity is exact, and directly replays one source-index
tuple for every nonempty archetype. The complete 274,576-shard run emits
118,045,633,868 bounded `A+C` keys, probes 23,820,889,456 `B1` and
143,053,650,607 `B5` pairs after all seven coordinate bounds, and finds
149,884 plus 2,205,896 exact aggregate-profile quartets across 29,416 and
62,778 hit shards. It retires 86,994,802,819,984 cycles and
146,612,417,354,627 instructions at 100% counter coverage on sixteen
CHOOM-protected workers. This is an exact aggregate-superset count, not source
exclusion authority.

Quartets factor through a smaller sufficient interface: their exact
seven-coordinate `A+C` pair sum. A fixed-cap second pass tags whether each
pair target is complemented by `B1`, `B5`, or both, then sorts and deduplicates
within its projection shard. A representative 4,096-shard band reduces 37,186
quartets to 18,176 pair targets (2.0469x); the known B5-hit shard reduces 66 to
32. Thus pair targeting mostly removes ordered-pair multiplicity, not the
missing massive theorem, but it is the right provenance boundary for the 119
aggregate-signature A/C and 656 aggregate-signature B/D pair domains. The
exact sealed source graph is larger: 18,608 commutative A/C nodes, 20,914 B/D
nodes, and 124,140 witnessed edges after canonical complementation and pair
symmetry. Every edge retains an original witness index/root for replay. The
cache format stores one
canonical 16-byte target, archetype bits, extractor/version semantics, all
four aggregate signatures/counts/digests, and a payload digest. Independent
readback recomputes all four aggregate tables and rejects source or payload
forgery. Aggregate relaxation remains explicitly discovery-only; q174 source
membership and replay are still required.

Exact mask evolution over the complete 1,152,732-target cache identifies a
near-sufficient state. No one-, two-, or three-coordinate presentation
separates the B1 and B5 target classes. Four coordinates leave at least 138
shared projected states. Exactly seven five-coordinate masks have disjoint
class supports; each is injective on all 74,781 B1 targets and collapses the
1,077,951 B5 targets to 1,077,941 states, only ten collisions. The seven
omitted pairs are the cycle `0-2-5-1-4-6-3-0`. A generic opaque
mask-membership corpus exposes only seven permuted membership bits and 21
exact labels; the existing Ergodis harness builds a 21-node depth-five tree
and evolution tests 831 candidates, retaining 21 perfect plans.

A domain-neutral complement-cycle synthesizer converts the seven successful
masks into a compact graph proof and rejects missing/forged edges. An
independent q29 verifier then explains the graph structurally: it validates
that the seven four-element cosets partition all 28 nonzero residues and
synthesizes the least unit whose class action matches the cycle. The unit is
3, with action `[2,4,5,0,6,1,3]`. This proves the cycle mechanism rather than
storing seven unrelated masks. It does not yet prove B1/B5 support
disjointness without the exact cache.

The mechanism feeds back into the kernel. Sharding on evolved cycle edge
coordinates `(0,2)` leaves the five-coordinate near-sufficient state in the
hot key. Relative to the old `(0,1)` control, exact NTT census raw pair counts
fall from 259,134,857,721 to 255,341,524,444 for A+C, from 84,715,482,675 to
81,573,412,435 for B1, and from 346,688,396,767 to 340,313,944,053 for B5.
The maximum materialized A+C shard falls from 12,790,280 to 11,933,166, so
the fixed 128 MiB per-worker bound remains sufficient. The campaign adapter
now supports the evolved cycle edges generically and defaults to `(0,2)`.

A second, independently sampled `B1` aggregate quartet now exercises the same
q174 hierarchy. Its source interface is root 348244 with masks
`[20,1,21,1]`, digits `[2215340,2203361,1957347,2218467]`, and q29 fibre
dimensions `[2,4,10,8]`. The old cardinality-only three-plus-three partition
failed closed on block zero at 16,777,217 retained states. A bounded
deterministic search over all ten partitions finds `[0,2,5] | [1,3,4]` and
compiles 4,281,174 exact joint profiles in 84,022,034,559 cycles and
237,010,454,775 instructions with a 1.268 GB reported workspace. A synthetic
independent regression reproduces the mechanism: equal raw products can have
different retained sizes because the bound q29 target prunes partial sums.

The complete four-block target-fibre run finds 23 broad scoped profile
quartets. Their 59 distinct per-block fibres contain only 8--192 packed q174
states apiece. Direct 43-class q87 replay excludes all 23 quartets, so this
particular B1 q29 quartet is exactly empty. The first run retired
743,645,378,397 cycles and 2,846,592,381,146 instructions. Prebinding the
small target-q87 key before q58 extraction preserves an identical digest of
all target states and reduces the run to 732,057,152,815 cycles and
2,814,834,899,951 instructions; only 27,424,392 of 471,402,623 q29-compatible
pairs reach q58 extraction. Side compilation and q87 extraction, rather than
q58 cache lookup, now dominate.

Scope evolution is genuinely root-local. For the earlier B5 fibre any one of
the independent q87 classes was sufficient. For this B1 fibre no singleton
works, but 28 of the 66 two-class masks exclude every lift. The generic
corpus adapter was extended from singleton one-hot candidates to opaque
fixed-width masks. On 66 source-permuted rows, the blind Ergodis harness
builds an exact 29-node depth-six tree; evolution tests 874 candidates and
retains 21 perfect plans. The exact full-state evaluator remains the
authority. This is a concrete test of learned per-root feature scope rather
than a globally hard-coded shift.

The current B1-only extrapolation is not yet a launch bound. Charging the
measured target-fibre compiler independently to all 149,884 aggregate B1
quartets gives roughly 27 idealized days on sixteen 3 GHz workers, before the
larger B5 class. The next required sufficient-state reduction is therefore
cross-hit reuse: measure the distinct participating block/profile fibres and
compile pair-level q174 transposition tables rather than paying once per
aggregate quartet. No final solve has been launched.

That extrapolation covers only the tested aggregate-signature edge, not the
entire g41 shard. Recompiling the sealed 1,984,512-interface cache gives 70
aggregate signatures, 119 commutative A/C pair nodes, 656 commutative B/D pair
nodes, and 2,136 incident pair edges. The older count of 4,224 aggregate
four-block domains retained ordering within the two interchangeable block
pairs. A new exact aggregate-pair graph removes that ordering, binds every edge
to a representative source witness/root, and retires 2,994,719,953 cycles and
10,491,924,951 instructions. This is the appropriate CGT-like transposition
table at the signature-labelled level: q29 pair support can be compiled once
per node and propagated only across its incident edges. The profile-class and
multiset theorems below collapse this layer further, but q174 source states
remain node/root specific. A global runtime estimate therefore still requires
q174 pair-state reuse; until then the honest estimate remains above one day
and no solve launch is justified.

The exact all-signature census reveals a much smaller profile quotient than
the node labels suggest. Although the 70 signatures generate 89,681,668
labelled profiles in total, there are only four distinct immutable profile
tables: 1,788,865 profiles for the three `s0=8` signatures, 901,419 for the
three `s0=9` signatures, 987,077 for all 32 `s0 in {1,17}` signatures, and
1,563,261 for all 32 `s0 in {5,13}` signatures. Retaining all four packed
16-byte tables costs only 83,849,952 bytes. The coefficient-state counts do
vary within these classes, so this is not the false claim that the raw
Minkowski images are equal; equality appears only after the exact defect
profile map and the `<=523` filter. An opaque four-field, 70-row corpus labels
only by exact table digest. The generic blind harness independently recovers
all four one-versus-rest classes and evolution retains 36--119 perfect plans
after 760--995 candidates per class. These are discovery facts pending a
short transport/flow proof; digest equality alone is not being promoted as
proof authority.

The census also exposes why digest equality is plausible structurally. After
the `<=523` filter, every A, B1, and B5 signature has exactly one coefficient
state per profile: respectively 1,788,865, 987,077, and 1,563,261 admissible
states, despite widely varying pre-filter state counts. Every C signature has
1,802,837 admissible states for 901,419 profiles, exactly
`2*901,419-1`: the fibres are the coefficient-complement pairs
`c <-> 18-c`, with the all-nine vector as their single fixed point. This
suggests a two-part compact proof target: fixed-zero defect profiles recover
the bounded coefficient vector up to explicit complement, and the aggregate
group-decomposition image saturates that admissible fixed-zero domain. A
fixed-zero phase-fibre checker is now the independent oracle; exhaustive
digest equality remains diagnostic until those two structural statements are
sealed.

The fixed-zero oracle confirms both statements more strongly. For `(row,
c0)=(260,8)`, all 24,072,133 row-compatible coefficient vectors reduce to
1,788,865 admissible singleton fibres. `(261,1)` reduces 23,863,182 vectors to
987,077 singleton fibres, and `(261,5)` reduces 24,019,737 to 1,563,261
singleton fibres. `(261,9)` reduces 24,072,133 vectors to 1,802,837 admissible
states: one singleton and 901,418 exact complement pairs. The four unique
profile counts and digests exactly equal the aggregate class tables. More
decisively, every aggregate signature's admissible-state count from the
all-signature census equals the corresponding entire fixed-zero admissible
domain. The aggregate image is structurally a subset of that domain; equal
finite cardinality therefore proves saturation. After the exact defect bound,
the other three aggregate-signature coordinates impose no restriction. The
four independent fixed-zero audits retire 78,564,717,823 cycles and
391,313,223,525 instructions at 100% coverage with 100,690,732 bytes of fixed
workspace apiece. The remaining authority task is packaging the all-signature
count comparison behind the sealed typed source extractor, not discovering
another reduction.

That packaging is now complete for the first extractor version. It rereads
and semantically replays the sealed 1,984,512-interface cache, derives all 70
signatures, independently recompiles every aggregate coefficient image,
recomputes all four fixed-zero fibre domains, and checks cardinality plus
profile digest under canonical row/zero/complement semantics. It verifies
class multiplicities `3,32,32,3` and issues only
`exact-profile-table-substitution-only` authority; it explicitly cannot
exclude a root or issue a final certificate. The proof compilation retires
5,808,895,345,892 cycles and 8,489,348,915,892 instructions at 100% counter
coverage. A negative semantic-binding test rejects correct class names with a
wrong admissible count, digest, or zero coefficient. Extractor v2 makes the
class summary fields self-describing and adds a checked group-sum inclusion
invariant without scanning every final state.

Classifying every edge of the sealed graph by those four exact tables first
appears to leave four pairings: `A+C <-> B1+B1` (364 edges), `A+C <-> B5+B5`
(364), `A+B1 <-> B1+C` (704), and `A+B5 <-> B5+C` (704). Pairing is not part
of the theorem, however: the target is the coordinatewise commutative sum of
all four profiles. Canonicalizing each edge as a sorted four-class multiset
collapses the first and third pairings to `{A,C,B1,B1}` and the second and
fourth to `{A,C,B5,B5}`. A compact typed proof rebuilds the graph from the
sealed witness cache and obtains exactly 1,068 edges of each multiset, with
364 homogeneous and 704 crossed presentations apiece. It retires
3,148,945,735 cycles and 10,828,676,658 instructions at 100% counter coverage.
Thus the two homogeneous campaigns do cover the global profile-class layer;
the heterogeneous adapter is retained only as an alternative MITM partition.

This reduction was also fed back through the blind discovery path. Digest
identity, rather than A/B/C names, assigns four opaque class integers. Each of
the 2,136 graph edges is replicated with four independent permutations of its
four class fields, and the exact sorted multiset supplies the binary label.
On all 8,544 rows the generic harness builds a 13-node depth-four tree;
evolution tests 955 candidates and retains 94 perfect plans. Positional pair
information therefore cannot explain the learned rule.

The first generic grammar improvement makes this lesson reusable without a
q29 adapter. An allocation-free private expander accepts an anonymous scalar
tuple and appends only its checked sum, sum of squares, minimum, and maximum;
it knows no class labels, target, mask, or theorem. The same 8,544 rows are
regenerated with independently permuted raw positions and one source-bound
opaque permutation of all eight fields. The blind proposer then collapses
from 13 nodes/depth four to three nodes/depth one. Evolution tests 951 plans,
retains 88 exact plans, and independently finds an exact predicate equivalent
to the four-class sum split (`4` versus `8`). This retires one bespoke adapter
class: later unordered scalar interfaces can expose the same symmetric basis
automatically. The v2 blind run retires 854,999,283 cycles and 2,459,131,884
instructions at 100% counter coverage; the expander's hot API has a zero-
allocation oracle and fails closed on width or arithmetic overflow.

The Queens TT lessons determine the storage policy rather than a uniform RAM
cap. Aggregate A/C node degrees are 8 (64 nodes), 16 (32), 24 (16), 72 (3),
or 128 (4); B/D degrees are 1 (328), 2 (200), 8 (80), or 16 (48). Expensive
complete tables with high reuse should be retained; degree-one B/D nodes can
stream once; and an exact edge search should materialize each A/C shard once
then probe every incident B/D neighbor. This preserves cross-edge
transpositions, unlike worker-local sharding. Tables are immutable and
source-bound, counters stay thread-local, and no lossy fingerprint hit may
authorize exclusion. The RAM budget may therefore rise above the ordinary
1--2 GB worker envelope when measured table residency avoids repeated q29 or
q174 compilation. The controlling comparison is instructions avoided per
resident byte, not nominal table size: hot multiply reused sufficient states
may consume several GiB, while cold degree-one records still stream even when
RAM is available. Every layout retains an explicit hard cap with no swap
fallback.

An exact seven-convolution NTT/CRT census chooses the physical pair partition
without changing that theorem. On evolved coordinates `(0,2)`, the shared
homogeneous envelope is 255,341,524,444 `A+C`, 81,573,412,435 `B1+B1`, and
340,313,944,053 `B5+B5` raw two-coordinate pairs, or 677,228,880,932 pair
visits with `A+C` paid once. The crossed B1 partition is slightly cheaper in
isolation, but forfeits that shared pass; the combined crossed strategy is
worse. The census retires 432,022,302,869 cycles and 560,362,064,111
instructions at 100% counter coverage. Its maximum raw B5 cell exceeds 16M,
but the retained-pair workspace is populated only after all five remaining
coordinate bounds, so raw NTT cardinality is not the workspace requirement.

The next direct application is in the participation census. A two-sided
control retains two fixed-cap 16-byte pair tables, sorts both, and merges
equal-key runs once, doubling the nominal workspace from 256 to 512 MiB per
worker. A reuse-only napkin initially favored retaining `A+C` and streaming
the cold B+B records, but that omitted the latency of two binary searches per
right record. Both paths are iterative and allocation-free in the hot loop,
and exact ordered-product, heterogeneous-role, endpoint-bitset, and allocation
oracles agree. The global coverage proof justifies the two shared homogeneous
joins; the cross adapter remains available for counterfactual partition
profiling.

The retained-both-sides control has now closed with exact quartet counts
`[149884,2205896]` and participating-profile counts
`[6462,38892,135471,90503]`. It retires 85,496,664,336,246 cycles and
182,643,178,172,958 instructions at 100% coverage with a reported
537,526,008-byte per-worker cap. This is the independent endpoint-bitset
oracle for later accelerators. Its legacy static provenance sentence says the
right sides stream even though the workspace size and invoked kernel identify
the retained control; that metadata error prevents promoting the artifact as
proof authority, but does not affect its role as a counter-measured exact
control. The separately bound streaming run remains in progress.

The streaming run has now closed with byte-identical participation digests and
the same quartet totals. It retires 128,070,942,400,682 cycles and
168,033,352,053,288 instructions with a 269,090,552-byte per-worker cap.
Streaming saves 8.0% instructions but costs 49.8% more cycles: random
partition-point probes are latency-bound, while sorting the cold table enables
a sequential equal-run merge. A later exact target-cache accelerator improves
on both. Its shared two-hash Bloom filter rejects only absent targets, and
every positive probe compares the full seven-coordinate key in an exact
open-addressed index. It reproduces the control's quartet counts, four
participation counts, and four participation digests. The four-worker run
retires 75,461,918,643,675 cycles and 66,741,790,140,083 instructions: 11.7%
fewer cycles and 63.5% fewer instructions than the retained merge, with a
10,485,760-byte shared index instead of a 537,526,008-byte per-worker cap.
The Bloom target cache is therefore production for this phase. Its 16-thread
resident footprint is small; thread count still passes through the live
explicit RAM gate, and no swap fallback is allowed.

The hash-only control was stopped as dominated after it had already consumed
94,583,166,261,611 cycles and 40,892,146,402,442 instructions without
finishing the same fixed workload. This is a partial rejected-design counter,
not a throughput result; it establishes only that omitting the Bloom front end
cannot beat the completed Bloom run on cycles.

The first full participation attempt was deliberately stopped after an audit
found a scheduler boundary race: with several workers, testing `shard == end`
allows a lagging worker to fetch `end+1` after a peer has fetched and exited on
`end`. Such a run cannot close with exclusion authority. Both private
participation schedulers now reject every `shard >= end`; the invalid partial
artifact is not a result. The corrected two-sided run is source-bound
separately.

Saturation enables the zero-cost witness handoff described in the C985 memo.
A fixed-zero inverse table maps each participating profile to one coefficient
vector, or to the explicit two-element C complement fibre. A new direct source
lift accepts that coefficient vector and runs only the bounded six-slot count
reconstruction; it does not compile or scan the 20--24 million-state aggregate
image. The workspace is compiled once per block specification, owns the orbit
inventory and all DP buffers, and the tested hot API allocates zero bytes.

On the authenticated B1 quartet in `g41-q174-b1-v2`, all four coefficient
vectors reconstruct exact source orbit masks. The complete four-block handoff
retires 10,072,151 cycles and 25,072,174 instructions at 100% coverage. Each
block examines exactly one coefficient state; fixed workspace sizes are only
2,419,200, 2,419,200, 3,276,800, and 3,225,600 bytes. Direct orbit and defect
replay is internal to the typed extractor. This retires full q29 coefficient-
image compilation from the per-profile lift cost; q58/q87 source refinement
can now receive a coefficient witness directly. The returned orbit masks are
one deterministic member of a fibre that can contain millions of
decompositions; they are valid positive witnesses but must never stand in for
the whole fibre when q58/q87 is used to exclude a source state. The next
quotient must propagate a sufficient statistic of every decomposition, not
rescore this arbitrary representative.

That next quotient is now structural rather than representative-based. A
fixed q29 coefficient vector is a capacitated six-by-seven degree matrix:
rows 0--3 have unit weight and per-column capacities `1,1,2,2`, while rows
4--5 have weight three and capacity two. A half-filled capacity-two cell has
two q174 orientations. A sealed iterative DP counts all degree matrices and
the safe orientation upper bound without constructing a source preimage. On
the authenticated B1 quartet the four blocks have 5,859,855; 995,621;
55,573,110; and 14,410,430 degree matrices, with oriented-source upper bounds
37,475,767,440; 7,157,451,416; 909,587,175,168; and 125,655,185,312. Despite
those enormous source fibres, the degree DP frontier never exceeds 2,393
states and the complete four-block census costs 26,978,702 cycles and
39,482,073 instructions at 100% counter coverage under CHOOM.

More importantly, source membership of a *packed q174 state* is another
bounded degree problem. Each of the 46 canonical q174 lanes supplies a small
set of selectable source-row incidences. A presized six-row iterative DP
checks all lane demands and row totals simultaneously, with no recursion and
zero allocations after construction. It independently accepts all 3,808
states in the B1 target-fibre artifact in 101,823,827 cycles and 216,831,072
instructions; per-block workspaces are only 604,800--819,200 bytes. An
exhaustive small-domain oracle compares it with direct orbit closure, and an
adversarial same-q29 candidate set exercises genuine infeasible states. The
checker is bound to canonical orbit extraction, mask, digits, coefficients,
packed-state semantics, version, and a semantic commitment. Thus future
inverse profile search can generate q174 candidates independently and issue
negative source-membership authority without retaining any arbitrary
preimage.

A plausible q87 energy bound was also tested and rejected. For fixed q29
sums, q87 energy is a sum of eight independent three-lift energies, with the
seven nonzero coordinates divisible by four. Exact interval and mod-four
bounds were probed before pair traversal over the same B1 target. Neither the
union of target energies nor any individual target-energy scope rejects one
of the 471,402,623 q29-complement pairs. The scoped control costs
45,453,512,117 cycles and 148,086,246,310 instructions. It is not installed
in the production target-fibre kernel; the result is retained as a negative
feature/scoping example rather than silently paying for a sound but useless
theorem.

The exact target fibres then exposed a genuine profile symmetry. Fifty of the
59 B1 per-block fibres are affine XOR cosets. Seven dominant generators have
disjoint four-lane supports, one for each nonzero q29 multiplier coset; their
union is exactly the 28 q174 lanes nonzero modulo three. Each generator is
lane-wise XOR by three, hence coefficient complementation `x -> 3-x`. The
observed 3,808 states collapse to 154 connected components (24.727x), with a
largest component of 128 states.

This observation has been promoted to a compact structural theorem rather
than a fibre certificate. For each coset the proof synthesizer considers all
six two-zero/two-three patterns without consulting the observed fibres. Exact
quadratic interpolation over every outside lane and outside-lane pair proves
one complementary pattern pair preserves all twelve broad-profile
coordinates: q58 energy, seven q58 correlations, q87 energy, and the three
scoped q87 defects. Independently extracted source incidences prove the two
selected lanes and their complements have identical orbit multiplicity in
each of the six source rows. Complementing all orbit items is therefore a
source-level row-count-preserving bijection, not merely a numerical profile
coincidence. Symbolic proof synthesis retires 530,339,532 cycles and
2,811,649,079 instructions at 100% counter coverage. A zero-allocation action
canonicalizes a state and expands its complete at-most-128-state orbit in
caller-owned storage.

The reduction has also been taught back to evolution. A source- and
proof-commitment-bound adapter exposes only seven permuted opaque bits saying
whether a proved flip lowers a candidate. It contains no lane numbers,
cosets, generator masks, or canonical state. On 2,999 training and 809
disjoint holdout rows, the generic blind harness builds a 15-node depth-seven
tree, selects all seven opaque fields, evolves 984 candidates with 16 perfect
training plans, and replays exactly on holdout. The evolve run costs
647,212,562 cycles and 3,158,530,889 instructions. Authority remains with the
symbolic/source-balance proof; the evolved plan is discovery and scoping
evidence only.

A source-bound reuse census identifies the next possible handoff TT without
assuming it is profitable. The 1,498 canonical block specifications contain
only 958 distinct digit vectors, with at most four source masks sharing one
vector. The expensive iterative decomposition is keyed by the digit vector and
the seven nonzero coefficients; the six-bit mask enters only the small-orbit
replay. A compact decomposition TT can therefore avoid at most the repeated
portion across those 1.563 specifications per digit vector on average, while
every hit still receives mask-specific replay. The census costs
5,504,432,399 cycles and 16,173,230,077 instructions at 100% coverage. This is
not enough reuse to allocate the TT blindly: participation cardinalities will
determine its resident-byte cost and the retained-versus-recompute counter
model.

The refined census partitions those specifications exactly as 248 A, 648 B1,
528 B5, and 74 C specifications (38 canonical aggregate signatures total).
Together with the independent participation counts, a blind Cartesian direct
lift has an exact class-Cartesian envelope of 111,727,724 `(spec,
coefficient)` replays. All 90,503 participating C profiles have both members of
their complement fibre, giving 181,006 C coefficient states. Scheduling by
digit vector is preferable to a giant hash table at this layer: reconstruct
once for `(digits, seven nonzero coefficients)`, then replay the at-most-four
source masks. The sealed 48-byte decomposition type now implements that split;
both construction and replay are zero-allocation, a full nonzero-coefficient
identity check prevents misuse, and a test rebinds one decomposition to two
different zero/mask choices with exact orbit replay.

The rebound work model gives 112, 440, 332, and 74 distinct digit vectors in
A, B1, B5, and C. Grouped scheduling therefore needs exactly 76,207,040 DP
decompositions before any source-edge/root scoping, a 31.79% reduction from
the 111,727,724 raw replays, while retaining only one 48-byte result at a time.
The cold model recompiles all profile/fibre authorities and replays the sealed
witness cache, costing 493,063,340,472 cycles and 867,602,891,042 instructions
at 100% coverage; those counters are proof/model compilation, not projected
solve work. The latest lightweight signature census itself retires
5,260,369,803 cycles and 16,173,772,066 instructions. A resident exact TT
remains available if q174/root ordering prevents grouping, and must be sized
from distinct joint keys rather than the 111.7-million raw-call envelope.

The first real handoff-kernel RAM trade is positive. The original iterative DP
zeroed its full predecessor and two count arrays on every coefficient query,
although the B1 fixture reaches only 3,829 states. A bounded touched-index list
now sparsely resets predecessors and the two existing frontier vectors reset
only their own count cells. The hot structs remain contiguous and fixed-cap;
the loop allocates zero bytes. Workspace for the measured block rises from
about 2.42 MiB to 4.35 MiB. Four interleaved 10,000-query A/B rounds reproduce
all 10,000 exact hits in each mode. Sparse reset retires a stable 48.853 billion
instructions versus 49.688 billion for full reset (1.68% less); it wins cycles
in three of four rounds, reducing median cycles by 12.3% and aggregate cycles
by 12.4%. The one cold four-block call regresses because the larger allocation
must first fault pages, but the production schedule performs thousands of
queries per workspace, so the repeated-query control is the relevant gate.
Across all four authenticated B1 blocks, repeated sparse decompositions retire
1.30--2.60 million cycles and 3.71--7.41 million instructions per query. If the
entire 76,207,040 grouped envelope had the worst measured fixture cost, it
would be about 198 trillion aggregate cycles; the block-zero median implies
about 130 trillion. At an explicitly idealized sixteen-core 3 GHz rate this is
roughly 45--69 minutes for the q29 decomposition layer alone. It is not yet an
order-2092 solve estimate: source-edge scoping can lower it, while q174 lift
and its joint sufficient-state multiplicity remain unmeasured.

That 45--69 minute construction projection is now avoidable for the q29
decision itself. Split the six slot rows into four unit-weight rows with
per-column caps `[1,1,2,2]` and two weight-three rows with caps `[2,2]`. After
choosing the seven aggregate weight-three column counts, each side is a
capacitated complete-bipartite degree-sequence problem. Max-flow/min-cut gives
the exact criterion: after sorting column demands, every prefix of size `k`
must be at most `sum_i min(row_i, cap_i*k)`. Only at most `3^7=2187`
weight-three choices exist, so the predicate is iterative, fixed-width, and
allocation-free. An exhaustive independent small-matrix oracle agrees with
the prefix criterion, and exhaustive small mixed unit/weight-three systems
agree with the existing constructive DP.

On the complete grouped participation domain the structural predicate accepts
76,207,038 of 76,207,040 keys. B1, B5, and C are universal; A has exactly two
exceptions. Both have nonzero coefficients `[9,9,9,9,9,9,9]` and digit counts
`[2,7,5,4,8,7]` or its within-pair swap `[7,2,4,5,7,8]`. Their obstruction is
one line: the cap-one row of degree seven occupies every column, hence every
weight-three column count is at most two, whose total is at most fourteen,
contradicting the required high-row total fifteen. The structural predicate
costs only 1.1--2.8 thousand cycles on the four authenticated blocks, versus
1.3--2.6 million for witness construction. Thus q29 source splitting should
be represented by this degree-sequence theorem plus two exceptional keys; the
decomposition fibre, not an arbitrary orbit-mask member, must be carried into
q174. The full rebound census costs 641,043,515,277 cycles and
1,103,129,353,629 instructions at 100% coverage, dominated by cold authority
recompilation rather than the predicate pass. Authority remains diagnostic
until the general max-flow proof and broader differential gate are sealed.

The generic evolve loop can now rediscover the visible boundary of those two
exceptions without a theorem-specific adapter. A source-bound corpus scans
all 723,744 grouped A keys and trains on one exception plus the 4,096 closest
feasible rows selected only by symmetric-feature distance. After an opaque
permutation of twenty generic symmetric scalar features, the first blind
hypothesis was `f004 == 9`. A 4,224-row sampled holdout accepted it, but the
strengthened exhaustive 723,743-key holdout correctly found 110 false
positives. The generic CEGAR loop fed those counterexamples back without
semantic names and evolved `f004 == 9 && f000 == 53`, which is exact on the
entire holdout. It needed one refinement round, two fields, 944 candidates,
47 perfect training candidates, and one perfect exhaustive-holdout candidate.
The two opaque fields recover the all-nine coefficient fibre and the symmetric
`{2,7}` degree-pair signature (square sum 53). Exhaustive corpus construction
cost 95,529,611,641 cycles and 231,834,729,500 instructions; CEGAR evolution
and exhaustive replay cost 8,915,955,690 cycles and 32,780,528,073
instructions. This is discovery provenance only: the conjunction is a lead,
while the capacitated Gale--Ryser argument and independent exhaustive oracles
provide the structural justification.

The q87 interaction spike has now produced a compact structural reduction
rather than another large target certificate.  The three-lift map
`Z/87 -> Z/29` gives, for every nonzero q29 shift class, three phase
correlations at `s,s+29,s+58`.  Their sum is the q29 correlation.  Multiplier
and conjugacy invariance identify two of the corresponding q87 defect classes,
so the exact identity is

```
2 D_repeated + D_singleton = 2 D_29 + D_q29.
```

The seven class pairs are `(1,12)`, `(2,24)`, `(7,3)`, `(4,33)`, `(14,6)`,
`(8,9)`, and `(11,18)`, with the first entry repeated.  A sealed private
extractor checks the identity on the complete 1,128-element quadratic basis of
the 46 canonical q174 coefficient lanes; a deliberately forged class binding
fails.  This is a structural polynomial proof, not a presentation digest or a
large search certificate.  It proves in particular that broad shift 33 is
determined by shift 4, q87 energy, and the already-bound q29 shift-4 defect.

The discovery path was generalized as well.  A domain-neutral private
bounded-homogeneous-relation evolver sees only four anonymous integer columns,
enumerates primitive coefficients iteratively with caller-owned storage, and
allocates zero bytes in its candidate loop.  On each of the seven independently
permuted phase-class observations it rediscovers the unique coefficient vector
`[2,1,-2,-1]`; 1,904 primitive candidates are tested in total.  Semantic
authority still comes from the sealed quadratic replay, never from the evolved
relation.  Sharing each expensive full defect extraction across all seven
relations reduces the combined graph/evolution/proof pass from 1,036,297,303
to 182,252,613 instructions (5.69x); the final run retires 64,873,470 cycles at
100% counter coverage.

The corresponding anonymous q87 factor graphs have twelve edges apiece.
Exact enumeration of all `8!` orders proves treewidth and linear-frontier width
three for either singleton predicate and four for their union.  The generated
orders are iterative and source-committed, giving the next inverse-DP kernel a
measured four-coordinate frontier rather than a guessed search ordering.

Shift 33 has been removed from the broad hot key.  All 3,808 states in the 59
retained B1 target fibres replay byte-for-byte under the reduced semantics;
the four-block target compiler falls from 269,912,206,041 to 266,814,897,963
instructions.  B0 retains exactly 4,281,174 broad profiles, while reported
workspace falls from 1,268,170,720 to 1,248,074,036 bytes.  Its counter control
falls from 55,389,145,616 to 53,680,566,396 cycles and from 90,601,767,196 to
90,291,864,172 instructions.  A first 6-byte hot-key layout was rejected after
counter evidence showed an instruction regression; the retained carrier uses
an explicit aligned 8-byte record while its semantics remain only energy,
shift 4, and shift 6.

The same theorem is now upstream of scope evolution rather than merely a
post-hoc explanation.  With broad classes 4 and 6 bound, their partners 33
and 14 are derived, and only the five independent candidate classes
`[1,2,7,8,11]` reach the evaluator.  The B1 exact-fibre domain falls from
twelve candidates and 78 tested masks to five candidates and 15 masks.  It
retains minimum sufficient width two and seven sufficient pairs.  Evaluation
falls from 13,985,127,399 to 2,786,862,712 instructions (5.02x).  A complete
ten-row opaque mask corpus then passes through the generic Ergodis harness:
an 11-node depth-three tree seeds evolution, 974 candidates are tested, 53
are exact on the complete training domain, and the selected plan replays
exactly on a separately instantiated complete-domain audit.  The harness sees
only five source-permuted membership bits and imports no shift, character,
phase, target, or relation name.

More generally, full q87 checking needs only seven non-energy classes rather
than fourteen once q29 defects and q87 energy are fixed.  This halves the
independent character coordinates available to root-local scope evolution and
is the first theorem-derived reduction from the interaction-graph spike.  It
does not by itself justify a sub-day unrestricted solve estimate.

Independent translation by 261 supplies the first large cross-root quotient
at q174.  It commutes with multiplier 41, swaps source slots
`[0,1]`, `[2,3]`, and `[4,5]`, is zero modulo 29, fixes every q87 coefficient,
and negates only the q58 anti-character.  A sealed lane transport proves an
involutive permutation of all 46 q174 lanes and an exact bijection of every
small and large source orbit.  The complete 1,128-state quadratic basis
preserves all eleven retained profile coordinates.  A real translated B1
block-zero compile maps back to exactly the same 1,472 target states and is
bound to proof commitment
`5c9bccc78080fe985f4471b4e5cffa704e103690e160a4f4c44fd2697ec62332`.

On the sealed 1,984,512-interface census, adjoining this action to the existing
coefficient-complement canonicalization reduces canonical block
specifications from 1,498 to 762 (1.966x), digit vectors from 958 to 717, and
four-block domains from 248,064 to 22,776 (10.892x).  This quotient is
block-local, so the four translations act independently.  The prior crude
26.2-quadrillion-cycle domain extrapolation correspondingly falls to about
2.41 quadrillion cycles before the side-orientation optimization, or about
13.9 ideal hours at sixteen 3 GHz cores.  Busy-host margin is not yet strong
enough to launch.

The translated control also exposed an implementation reduction independent
of the theorem: the chosen three-plus-three partition had 5,167,190 states on
the historical outer side and 2,533,872 on the indexed side; translation
reversed them while preserving all 65,094,816 candidate pairs.  The target
kernel paid two partition searches per outer state, so the presentation with
the smaller outer side retired 77,595,354,822 instructions versus
97,264,346,223.  The private compiler now orients every exact selected
partition by measured retained cardinality, irrespective of which side
contains slot zero.  This change awaits a fresh build/performance replay while
unrelated concurrent public-core edits are temporarily uncompilable.

## Runtime implication

The estimates in this section record the successive launch gates and are
retained as counterfactual evidence.  The later q174 energy theorem supersedes
every g41 fine-lift estimate below: that branch is now structurally empty and
has no residual solve run to launch.

The former 7.8-hour-per-50-billion-mutation estimate is obsolete for `g=53`:
the theorem-driven exact solve has already completed on 16 workers and proves
that shard empty before q5, q6, q29, or any fine PAF equation is needed.  The
measured exact solve and independent replay retire 48.0 and 56.3 billion cycles
respectively, far below the requested one-day boundary.  This is not an
unrestricted order-2092 estimate.  C999's warning still applies: a negative
assumed-multiplier shard does not decide existence. The first transfer closed
`g=91` structurally at q0. The `g=41` quotient root shell is now reduced
341.333x to 768 necessary roots. Exact multiplicity and an independent direct
enumerator agree on 1,984,512 common raw digit interfaces, retiring the former
arbitrary one-witness model. A sealed 47.6 MB cache loads, replays, and
initializes all interfaces in 46.2 billion aggregate cycles and 56 MiB RSS. A
full 1.984-billion-mutation discovery pass takes 8.179 trillion cycles on 16
workers and reaches residual 16; the earlier selected-witness campaign still
supplies the best known residual 8. The reusable 2-adic hull removes 32x at the
mod-16 profile layer, but the target survives. Neither discovery miss has
exclusion authority: the remaining unknown is an exact q29/fine-lift tablebase
and four-block complement join. The `g=133` shard no longer
contributes a residual solve envelope: exact full-state refinement plus the
two independent joins excludes all 6,739,200 q6 survivors.  Its measured
90-cell decision cost is 394.60 billion cycles, about 8.2 seconds at the
idealized aggregate rate of sixteen 3 GHz workers, although the serial proof
compiler and loaded host are not a solve benchmark.  The evolved modulus-11
cycle identity now supplies a sealed 42-cell structural replacement with two
independent joins, so the old `2^76.2596` g133 envelope is retired without
retaining the q3/q9 state tables. The remaining runtime uncertainty is
concentrated in the exact g41 fine-lift tablebase. Quotient-witness multiplicity
and discovery throughput are now bounded, but there is still no defensible
under-one-day exhaustive estimate and no solve has been launched. The measured
discovery envelope is minutes for one thousand mutations per every raw
interface and about 4.2 hours for one hundred thousand; that is not an
exhaustive upper bound. At this intermediate gate the exact
block-profile/tablebase spike still had to bound the lift state count and join
cost. On the first concrete q58 collision, exact
q87 liftability further reduces the 35-state mixed-character endgame to 11
states in 25.354 billion proof-compilation cycles. This is a strong per-root
reduction and a useful tablebase archetype, but it has not yet been lifted to
all 1,984,512 interfaces.  The existing all-interface census supplies the
critical reuse bound: there are only 1,498 canonical block specifications and
248,064 canonical four-block domains.  At the measured optimized q58 cost,
compiling one table per block specification is roughly 252 trillion aggregate
cycles, about 5.8 ideal hours on four memory-bounded 3 GHz workers.  This makes
a sub-day run plausible, but not yet launchable: q58-only profile
deduplication retains an arbitrary preimage, so the table key must be refined
through the common q174 quotient to preserve joint q58/q87 lift classes before
the global join can authorize exclusions.  Cross-interface sufficient-state
reuse plus that joint-key multiplicity are therefore the runtime-critical
measurements.

The q174 quadratic-profile compiler now has an exact bounded transposition
table keyed by the complete 72-bit q87 coefficient state.  It uses separate
low/tag/value arrays plus a presized touched list, compares the full state (no
probabilistic fingerprint), allocates nothing in the pair loop, and fails
closed at three-quarter load.  The B1 target-fibre replay saw 471,274,492 hits
and only 128,131 misses across 471,402,623 pairs (99.972819%).  Exact regenerated
state sets agree with all four retained presentation fibres.  At a conservative
`2^20` capacity the workspace contribution is about 21 MiB; peak measured
per-block workspace remains 722 MiB.  Separate nonmultiplexed runs totalled
105,679,349,685 cycles and 269,912,206,041 instructions, versus the sealed
pre-TT run's 732,057,152,815 cycles and 2,814,834,899,951 instructions: 6.93x
fewer cycles and 10.43x fewer instructions.  The same cache in the broad B0
table compiler preserves the exact profile digest while reducing its measured
84.02 billion cycles / 237.01 billion instructions to 55.39 billion / 90.60
billion.  This is a reusable private kernel reduction, not a B1-specific
theorem and not a public Ergodis-core change.

An attempted stronger side quotient was falsified and removed: grouping each
MITM side by `(q29 projection, q87 state)` leaves all 65,094,816 B0 products,
because every side state has a distinct key.  The reuse occurs only after
forming pair sums.  The grouped control preserves the exact fibres but costs
111,529,196,174 instructions versus 79,742,388,813 for the retained TT path,
so it is not left in the kernel.

Projecting each source slot to q87 before a six-stage sumset was also
fast-falsified and removed.  Even with slots ordered by projected cardinality,
q29 upper bounds alone leave more than 12,582,912 distinct intermediate q87
states on B0, exceeding a 600+ MiB fixed workspace before the final equality
or target quadratic profile is available.  This confirms that the useful
small q87 image is created by the complementary MITM equality, not by a
one-sided homomorphic frontier; an inverse solver must exploit the target
quadratic interaction structure during elimination.

A theorem-driven parity-key spike was also closed as a negative control rather
than added to the production join.  The twelve broad q58/q87 coordinates are
integral quadratic forms, hence their values modulo two compose by XOR across
the MITM split.  An independently checked zero-allocation extractor appended
this exact 12-bit signature to the q29 projection.  On the retained B1 fibres,
however, each block admitted the two signatures already forced by its fixed
source data, and the union rejected exactly 0 of 471,402,623 projection-matched
pairs.  The four-block probe cost 86,704,555,585 cycles and 348,714,309,437
instructions.  This is useful evidence that quadratic parity is already
implicit in the current root/interface state, not a new reduction; the spike
is not integrated into the solver.

### Complete q29 multiplicity and the rejected launch envelope

The launch gate now uses the complete q29 multiplicity rather than sampled
profile preimages.  A sealed 18-worker cache contains 3,507,700 exact pair
records and independently replays to 149,884 B1 and 2,205,896 B5 profile
quartets.  The payload is 56,123,577 bytes.  Its complete scan retired
64,110,816,652,008 instructions and 63,183,947,433,583 cycles on the loaded
host; the hot shard collectors are presized and allocate nothing.

Translation-canonical source pairs have 4,904 A/C nodes, 6,309 B/D nodes, and
11,406 edges.  The 762 source block specifications induce only eleven exact
q87 energy-support behaviours and the source graph only 28 behaviour-edge
types.  A complete role-aware cross product proves that sixteen edge types
are empty: only twelve remain, containing 3,814 source edges.  This is an exact
structural role reduction, including both commutative A/C and B/D assignments,
not a presentation-label inference.  Evolve's generic sparse-exception
learner initially missed two holdout cases; counterexample refinement now
rediscovers every non-singleton behaviour class with a perfect held-out replay.

The same census also falsifies the hoped-for marginal thinning.  For every
role-compatible edge type, every exact q29 quartet passes the full-support
minimum/maximum/gcd necessary condition.  The surviving execution envelope is
therefore 3,552,874,976 source-edge/quartet combinations.  The coefficient-at-a-
time q174 solver is not a credible two-day run and was deliberately not
launched.

A reusable-source-index spike then relaxed the q29 projection target and
compiled each three-slot side once.  On `(mask,digits)=(20,2215340)` it has
6,390,384 and 2,690,688 states but only 441,336 and 241,780 projection keys,
with 9,572 and 8,219 four-coordinate prefixes.  Construction retired
16,806,392,500 cycles and 67,222,275,936 instructions using 218,998,400 bytes.
This confirms real TT reuse, but an exact batched join against all 6,462
participating A projections still contains 410,025,875 projection triples and
147,417,714,108 source-state pairs.  The batch run retired 443,122,434,526
cycles and 1,117,935,706,073 instructions, including sealed cache setup.  Thus
projection-only handoff is also insufficient: the next launch adapter must
carry q58/q87 sufficient state into the grouped prefix join, not expand q29
projection fibres and filter afterward.

No public Ergodis core file was changed.  These private probes carry no proof
authority; a future positive still requires allocation reconstruction and all
521 original PAF equations.

A final behaviour-class control compiled exact q58 energy supports for the
eleven q87 source classes and tested every role-compatible source edge against
every exact q29 quartet.  It leaves 3,552,873,744 jobs, only 1,232 fewer than
the 3,552,874,976 q87-role envelope, after 835,419,987,063 cycles and
1,777,389,755,567 instructions.  Because a representative q87 behaviour does
not semantically determine an exact q58 profile, this result has discovery
provenance only; it rejects the proposed launch reduction and authorizes no
negative coverage.

### Evolve-to-proof closure of the g41 branch

An adapterless evolve probe next scored the full length-174 compressed defect
vector directly from exact source-orbit selections.  The runner consumes the
sealed 47.6 MB interface cache rather than regenerating all 1,984,512 q18
interfaces serially.  A sparse exact swap delta, checked differentially against
full recomputation and under the allocation counter, reduced a 180,000-move
probe from 43,601,375,227 to 10,580,478,532 instructions and from
11,633,915,983 to 3,591,295,362 cycles.  The hot mutation loop allocates
nothing and uses no recursion.  A 1,800,000-move control nevertheless
plateaued at squared residual 30,764,892 rather than approaching zero.

The plateau exposed a stronger invariant: its best state had q174 zero energy
2675, whereas a genuine GS difference family requires 2083.  This observation
was promoted to a compact structural proof, not used directly as authority.
Modulo 174 there are 46 multiplier-41 classes.  Forty-two nontrivial classes
split into two seven-class coupled families and two fourteen-class tripled
families.  In each coupled family, the exact minimum is

    4 sum_{j=0}^{6} (a_j + b_j)^2,

with `a_j in {0,1}`, `b_j in {0,1,2}`, and prescribed source-orbit counts.
The complete minimization is therefore a fixed 8-by-15 iterative min-cost DP.
Each length-12 orbit in the other two families projects with coefficient three
and contributes energy 36; the six small-orbit energies are
`[1,1,4,4,18,18]`.  Direct orbit classification independently checks this
decomposition.

Scanning every sealed q18 interface with that constant-workspace theorem gives
the same minimum combined energy 2675 for all 1,984,512 interfaces.  More
strongly, the lane inequality `4*x^2 >= 12*x-8` for `x in [0,3]`, exact
tripled-lane energy, and direct replay of the 64 small-orbit masks prove the
cache-independent block bound `E174 >= 3*w-116`.  Summing the four row weights
gives `E174 >= 2665`, already 582 above the target; the sealed interface scan
is now only an independent sharper oracle.  The required 2083 follows
independently from the indicator weights
`260+261+261+261=1043` and the required combined overlaps 520 at shifts 174
and 348: `E174 = 1043 + 520 + 520`.  Thus the gap is exactly 592 and the whole
multiplier-41 branch is impossible before any q29 quartet or fine PAF search.
The final generic-engine replay retired 2,761,987,120 cycles and
9,384,291,253 instructions at 100% counter coverage, with about 32 MiB RSS.
This is 9.35% more cycles than the specialized v2 scan in exchange for
data-driven collision-scope compilation and precompiled allocation-free quota
tables; the temporary v3 lookup regression was removed.  The cache digest
binds the sharper census, while proof authority needs only the tiny orbit
classification, target-energy identity, and lane inequality; there is no large
negative certificate.

This is the desired evolve-to-proof loop in miniature: a general full-vector
feature exposed an unexplained optimization floor; a structural classifier
localized it to projection multiplicities; a bounded exact synthesizer proved
the corresponding convex lower bound; and independent direct oracles replaced
the heuristic observation as authority.  No public Ergodis core file was
changed.

The projection minimizer is now domain-neutral private infrastructure.  From
anonymous `(lane,family,amplitude)` orbit contributions it discovers connected
collision scopes, compiles a bounded iterative mixed-radix DP, and can freeze
the result into allocation-free quota tables.  A non-g41 connected holdout
matches full subset enumeration; solver/table differential, allocation, and
fail-closed budget tests pass.  The g41 theorem is a thin typed adapter over
this engine rather than a baked-in seven-bin kernel.

The same cleanup produced a domain-neutral private sparse-defect synthesizer.
Given only an anonymous finite coefficient alphabet, fibre size, coordinate
multiplicities, block count, and total square norm, it discovers the minimum
square, primitive gcd normalization, positive defect weights, exact target,
bounds, and complete bounded magnitude profiles.  No g53/g133 labels enter the
search.  A fixed-odometer independent replay rejects forged schemas or omitted
profiles; observed/evolved inputs remain discovery-only, while the constructor
that can retain pruning provenance is crate-sealed.  The generated hot weight
classifier is iterative and allocation-free.  Blind fixtures rediscover the
g53 tuple `(baseline,normalizer,target,weights,profiles) =
(1,56,34,[3,4,13,15],10)` and, as a holdout, the g133 tuple
`(9,16,83,[1,7,10,22,27,45,52])`.  The larger g133 synthesis/replay retires
192,377,718 instructions and 47,419,354 cycles.  This is the reusable mechanism
for feeding an earlier evolved alphabet into later theorem discovery without a
problem-specific adapter.

### Unassumed q18 launch model and exact pair split

Closing every nontrivial multiplier branch changes the launch target: an
unrestricted search cannot inherit multiplier-41's orbit state.  An exact
coefficient DP gives the row-sum-plus-zero-shift shell

    4,428,661,015,522,807,614,393,743,964,270,141,789,544,005,951,136,428,196,083,092,269,440

ordered q18 quadruples (`4.428661e66`).  The individual admissible vector sets
are still about `2^72` for the special row and `2^71` for a zero row, so a raw
block-pair complement table is about `2^143` entries before profile merging.
Even an ideal 2 GiB 16-byte TT has only about `1.34e8` slots.  The full
independent `D18^4 x S3` symmetry is at most `10,077,696`, with a smaller
actual Burnside factor.  Neither reduction closes the many-orders-of-magnitude
gap to an optimistic two-day transition budget.  These are exact counts, not
busy-host timings; the short counting oracle was not used as performance
evidence.

There is nevertheless a reusable structural split.  For a signed q18 word
`y`, put

    u_j = (y_j + y_{j+9})/2,   v_j = (y_j - y_{j+9})/2.

The complete q18 equations are equivalent to four cyclic length-nine `u`
words with row sums `(1,0,0,0)`, combined energy 465, and combined off-zero
PAF `-58`, together with four negacyclic length-nine `v` words of combined
energy 523 and off-zero negacyclic PAF zero.  Only four plus four off-zero
equations are independent.  The two halves couple pointwise only through
opposite parity and `|u_j +/- v_j| <= 29`.  This follows directly from
`C_y(s) +/- C_y(s+9) = 4(C_u(s),N_v(s))`; it does not assume complement or
negation symmetry.  The uncoupled norm relaxation still has
`7.125992e74` assignments, so the theorem supplies a better sufficient state
and CGT-like boundary table, not yet a solve bound.

A sealed private `Q18PairSplit` adapter now derives and independently replays
this theorem.  Its registered outputs are cyclic/negacyclic energies 465/523,
off-zero targets -58/0, and divisor-cycle energies
`[4,1048,1396,1744,1860,1976]` for divisors `[1,2,3,6,9,18]`.  The typed
extractor binds identity, version, canonical parameters, and theorem-source
commitment; presentation kernels reconstruct the coefficients rather than
trust named columns.  Fixed 128-byte coefficient/split records and a 32-byte
projection record allocate nothing.  Exhaustive half-orders one through four,
2,048 deterministic q18 differential cases, malformed binding/field/
provenance controls, and direct reconstruction all pass.

Exact divisor-cycle endgames are tiny at the coarsest boundary--the order-two
alternating-sum equation has only 18 sorted absolute patterns / 4,192 labelled
signed tuples--but fixed-order DFS otherwise has no genuine transposition:
the midpoint must retain half coefficients and their cross-convolution
boundary.  A positive-only q18 stochastic probe could be profiled cheaply,
but a compressed witness neither certifies absence nor lifts by itself to the
four 522-bit rows.  It is therefore not being misrepresented or launched as a
full solve.  The current unrestricted exact estimate remains far above two
days; the next required reduction is an algebraic sufficient-state theorem
linking the cyclic/negacyclic boundary tables to the 18-by-29 binary lifts.

### Transverse binary margins and the order-six residual

The first exact bridge to the 18-by-29 lift is Gale--Ryser rather than a
search certificate.  If `r_a=(y_a+29)/2` are the eighteen q18 positive
degrees and `c_b=(C_b+18)/2` are the twenty-nine q29 positive degrees, a
common binary block exists exactly when the totals agree and

    sum_{i < k} r_i^down <= sum_b min(k,c_b),  k=1,...,18.

A private 64-byte margin record and 64-byte workspace recompute these
semantics and decide all eighteen inequalities without allocation or
recursion.  Exhaustive direct matrix enumeration through `4 x 4` agrees, and
malformed signed presentations fail closed.  This strictly subsumes the
earlier opposite-pair disagreement prefix inequalities.

The q174 bridge is even smaller.  For each block and residue `g mod 6`, let
`d1 >= d2 >= d3` be the three q18 positive row degrees and let
`k_b in {0,1,2,3}` be the q174 triple count at column `b`.  The `3 x 29`
Gale--Ryser conditions reduce exactly to

    sum_b k_b = d1+d2+d3,  #{b:k_b=0} <= 29-d1,
    #{b:k_b=3} <= d3.

Thus `(sum,n0,n3)` is a complete q18 lift interface per class.  Across four
blocks the q174 zero energy is `696+8 sum(n0+n3)`, so the required energy
2080 is exactly `sum(n0+n3)=173`.  A fixed 192-byte q18/q174 record and
32-byte summary implement the direct extractor; exhaustive three-row tables
through five columns, constructed full CRT tables, malformed inputs, and the
zero-allocation gate pass.

The missing q174 character between q58 and q87 has also been isolated exactly.
At each q29 column, q174 is a `2 x 3` table `z_pq` of signed triple sums. q58
fixes its two row margins, q87 its three column margins, and the Eisenstein
residual

    s = 1/2 sum_{p,q} (-1)^p omega^q z_pq

supplies the remaining two degrees of freedom.  Fixed margins plus `s`
reconstruct all six cells uniquely.  Complete enumeration of the 4,096 local
tables gives 2,470 sum-compatible formal margin types, 1,666 feasible types,
726 singleton types, maximum alphabet 12, and mean feasible alphabet 2.459.
The compiled exact directory is about 153 KiB.  An initial zero-energy gate
used a 523-bit fixed-workspace DP. Against an independent scalar DP, 500
complete gates cost 30,749,753 versus 1,063,897,513 instructions and 6,404,508
versus 177,668,829 cycles: 34.60x and 27.74x reductions.  The bitset gate uses
about 61,500 instructions and 12,800 cycles per fixed margin quartet and
allocates nothing.  A later structural identity makes even that gate
redundant once all four quotient zero shells are present.  Local character
orthogonality gives

    8 E_s = 6 E174 - 2 E58 - 3 E87 + E29.

Substitution of `2080,2056,2068,2020` gives `E_s=523` automatically.  Direct
enumeration checks the identity on all 4,096 local tables.  The residual
search therefore carries only the fourteen off-zero Eisenstein correlations,
not a fifteenth energy coordinate.

This fifth reduction is also backfilled into the private evolve-to-proof
loop.  The generic bounded homogeneous-relation miner receives only the 4,096
anonymous five-coordinate energy rows and coefficient bound eight.  With no
theorem coefficients, field names, or selected examples, it uniquely returns
`[6,-2,-3,1,-8]`; direct local Parseval then supplies proof authority.  Thus a
future projection family exposing the same dependency can delete the
redundant state automatically rather than waiting for a hand-written adapter.

Modulo the Eisenstein prime `(1-omega)`, the residual satisfies
`s == (A0-A1)/2 (mod 3)`, where `A0,A1` are the q58 row margins.  The q58
state therefore determines one ternary digit of every residual coordinate;
the eventual fourteen-coordinate pair key stores only quotient residuals,
saving about 22 raw key bits.  The private extractor recomputes this residue;
an exhaustive all-4,096-lifts oracle passes in the isolated private harness.

This representation is the CGT-like endgame state: q58 and q87 are the two
coarser games, while `s` is precisely their interaction boundary.  It is not
yet a launch bound.  Across a uniform feasible-margin model, the fused q174
extreme-count shell `sum(n0+n3)=173` is exceptionally strong: an independent
exact binomial oracle leaves only `6,981.735... = 2^12.769...` expected
quartets before off-zero correlations, versus the raw `2^150.548...` mean.
But that average cannot authorize a run.  An adversarial repeated margin type
still has `2^361.071...` extreme-compatible quartets, while the
coefficientwise envelope is looser still.  The q58/q87 zero shells rule out
that constant low-energy type, but their **actual** character-constrained
margin census is now the missing measurement.  A pair side below roughly
`10^8` states would fit the 2 GiB/two-day envelope.

An unrestricted q18 discovery adapter now evolves the original compressed
coefficients with row sums fixed and directly replays any exact hit.  Its
mutation loop is iterative and allocation-free.  Tightening an initially hot
annealing schedule improved the best squared residual from 2,560 to 64 in a
1.8-billion-mutation control and then 32 in a 9-billion-mutation, 18-worker
control.  The near miss has only two PAF coordinates at target plus or minus
four and is `ObservedEvolved` only; it is not evidence of nonexistence or
negative coverage.  Resetting every annealing epoch regressed the best to 64
in another 9-billion-mutation control and was removed.
An exhaustive 262,144-word parity oracle then falsified the tempting mod-eight
explanation: both row-parity classes realize all 256 independent correlation
profiles, and their required four-block XOR target is reachable.  The near
miss is therefore an optimization basin, not a mod-eight theorem.  Exact
distinct-block radius four and directly recomputed same-block-double radius
three neighbourhoods contain no repair; the latter deliberately does not use
the known-unsound additive same-block delta.

Two bounded Z3 discovery encodings were retained as backend negatives.  The
symmetry-broken exact `QF_NIA` model timed out after 60 seconds and
914,467,621,492 instructions.  An exact finite-bit-vector model restricted to
the radius-two coefficient box around the residual-32 witness also timed out,
after 440,643,560,248 instructions.  Neither timeout has negative meaning.
The bit-vector encoding more than halves instruction demand, but Z3 still does
not reach the useful boundary; further q18 work should use the native
character/tablebase decomposition rather than a longer generic-SMT run.

The first unrestricted q29/q58/q87 shell adapter is now staged rather than
asking one annealer to discover the quotient hierarchy implicitly.  Phase one
works directly in the four length-29 aggregate rows (448 bytes), fixes the row
sums `(2,0,0,0)`, and begins on the exact q29 zero-energy shell.  Only an exact
q29 hit is lifted deterministically to the 696 triple-count cells; phase two
then mutates inside q29 columns, preserving that quotient while targeting the
q58, q87, and q174 zero shells.  Incremental/direct differential checks,
bounded-value lift checks, and the zero-allocation gate pass.  The preceding
696-cell phase-one control reached q29 residual 1,040 in 69,503,170,083 cycles
and 204,948,280,059 instructions for two million mutations on each of eighteen
workers.  Removing that neutral fibre, the direct aggregate kernel and its
broader row-sum-preserving neighbourhood reached residuals 576--784 in short
controls, but no q29 shell has yet been replayed.  These are discovery misses
and have no negative authority.

The retained q29 kernel is the simpler exact-energy winner.  It uses only
within-block swaps, then applies a bounded iterative two-move repair to the
best residual.  The repair compiles 3,248 fixed 32-byte deltas (about 104 KiB
per worker), joins only moves from distinct blocks where additive deltas are
sound, and directly recomputes the complete score for any candidate hit.  Its
CHOOM-protected, nonmultiplexed 18-by-10-million control retires
208,291,377,355 cycles, 811,075,445,833 instructions, 95,238,968,889 branches,
and 517,698,969 branch misses; residual 576 has no radius-two repair.  The
broader energy-cancelling transfer control is rejected: at the same scale it
costs 624,028,330,912 cycles and 2,218,802,126,644 instructions yet only reaches
residual 832.

There is now a structural explanation for one layer of the q29 basin.  Divide
the even q29 coefficients by two and mark their odd positions by binary words
`D_i`.  Reducing the target `(505,-18,...,-18)` PAF system modulo two gives

    sum_i D_i D_i^* = 1  in F_2[C_29].

The direct extractor validates coefficient bounds, evenness, row sums, and
zero energy before recomputing all twenty-nine cyclic intersections; no named
feature column is trusted.  Since two has order 28 modulo 29, the nontrivial
component can equivalently be viewed as one Hermitian norm equation over
`F_(2^28)/F_(2^14)`, although proof replay deliberately remains in the simple
group-ring representation.  On the retained fixed-magnitude inventory, whose
odd-support sizes are `(3,4,4,2)`, the exact `(3,4)|(4,2)` census reduces
836,870,725,123,524 support quartets to 217,396,960,970: a 3,849.51x or
11.9105-bit reduction.  The roughly 310 KiB fixed-workspace census retires
152,987,296 cycles and 965,821,426 instructions with no hot allocation.  This
count is explicitly scoped to that inventory stratum, not advertised as an
unrestricted q29 count.  Freezing a random parity-compatible support fibre
made annealing worse (best residual 4,736 versus 576), so evolve retains the
theorem as a filter/feature rather than confusing a quotient with a good move
geometry.

The retained residual-576 q29 state is exactly empty in its complete
three-transfer neighbourhood when the transfers lie in three distinct blocks.
That offline MITM uses a fixed 21,099,008-byte workspace, allocates nothing in
the kernel, and directly replays all fifteen q29 equations.  It retires
860,373,034 cycles and 1,824,213,988 instructions.  The result scopes only
that radius-three neighbourhood and has no global negative authority.

More importantly, the current magnitude inventory was proved to be far too
narrow for an unrestricted claim.  An iterative nine-frame odometer now
enumerates every unsigned magnitude inventory for 29 values in `[-9,9]`; an
exact `u128` subset-sum replay admits an inventory only when signs realize row
sum zero or one.  There are 9,267,965 sum-zero and 9,347,927 sum-one row
inventories, with 1,786 and 1,789 reachable `(energy,odd-support)` cells and
25,312 feasible ordered four-row odd-support scopes at combined energy 505.
The `(3,4,4,2)` support scope contains 79,533,805,645,248 of
1,306,548,399,670,892,351 feasible magnitude-inventory quartets, only
`2^-14.004` of them.  Fixing its row energies to `(123,128,128,126)` leaves
1,821,919,960 inventory quartets (`2^30.763`), so the single hand-selected
inventory silently fixes a further 30.763 bits and is about `2^-60.18` of all
profiles.  This is an exact diagnosis of the basin problem.  The census costs
3,521,369,365 cycles and 12,053,748,365 instructions.  The next evolve layer
must sample this outer inventory/scope state before coefficient permutations.

That outer layer now exists, and it closes a search-design gap without
pretending to close the q29 shell.  Each selected `(sum,energy,odd-support)`
cell is followed by exact iterative unranking of a magnitude inventory, exact
subset-sum sign reconstruction, randomized placement, and canonical replay.
The novelty weights are frozen across each four-row conditional draw and
updated only afterward.  The cold workspace is exactly 520,000 bytes; the
existing 448-byte mutation state and zero-allocation hot loop are unchanged.
A CHOOM-protected three-policy control of 100,000 mutations per policy retires
25,154,000,000 instructions and 7,771,000,000 cycles.  Its best q29 residual
is 768, so it neither finds a shell nor beats the narrow-inventory residual
576.  At the measured inclusive 25,900 cycles per mutation, even the
deliberately overoptimistic model in which every mutation visits a new one of
the `1.3065e18` magnitude quartets is about thirty thousand years on eighteen
2 GHz workers.  This is not a solve estimate; it is a decisive rejection of
flat inventory enumeration and leaves no evidence for a two-day launch.
An exact cold reseed every million mutations then turns the same adapter into
a genuine multi-scope campaign: eighteen workers visit ten independently
unranked scopes each while the 448-byte hot kernel remains unchanged.  The
180-million-mutation control improves the best q29 residual threefold, from
576 to 192, but still finds no shell.  It retires 1.960 trillion instructions
and 585.05 billion cycles, a 2.42x/2.81x regression against the fixed-inventory
control caused by cold unranking and reseeding.  This establishes that scope
diversity helps the basin but is not by itself a launchable exhaustive method.
A larger eighteen-worker campaign then visits 18,000 fresh outer profiles and
performs eighteen billion mutations.  It finishes in 942.119 seconds with
175.843 trillion instructions and 50.719 trillion cycles, improves the q29
residual again from 192 to 96, and finds no shell.  The miss remains purely
discovery evidence; the retained worker merge is keyed first by q29 residual,
repairing an earlier cold-output defect that could have discarded the best
q29 state in favour of an irrelevant random fine-lift score.

The residual-32 q18 basin has also survived two substantially broader bounded
attacks.  A fixed 8,192-entry late-acceptance ring, 32-entry tabu table, and
deterministic eight-transfer kicks make no improvement in an eighteen-worker,
100-million-proposal control (2.041 trillion instructions and 557.916 billion
cycles).  The exact tested radius-four partitions, now including a
double-plus-single-plus-single case whose same-block effect is recomputed
directly rather than using the unsound additive delta, are empty as well
(10.925 billion instructions and 3.077 billion cycles).  Both misses are
strictly local/discovery evidence and grant no negative authority.  A later
exact full-delta tablebase closes the missing minimal `3+2` partition and
repairs this same basin.  The q18 witness is now exact: the table key contains
energy and all nine off-zero correlations, full-key collision comparison
makes one retained preimage sound, and the positive independently replays the
complete q18 reduction.  The run uses 11,255,647,890 instructions and
3,815,609,603 cycles at 100% counter coverage; its 8,129,088-byte workspace
and solve loop allocate zero times.  The source-bound witness is locked by a
normal test rather than retained only as a local log.

The exact q18 witness and the observed q29 residual-six root have labelled
Gale--Ryser-compatible margins in all four blocks.  A new constructive
Havel--Hakimi boundary returns one 18-by-29 binary matrix per block and
independently replays both labelled margins with zero allocation.  Recombining
those matrices by CRT gives row sums `(2,0,0,0)`, but direct replay of all 521
original PAF equations has score 1,204,320 and is not exact.  This establishes
the missing witness-handoff shape while demonstrating that margin feasibility
alone is not a search-space reduction.  The q29 input remains explicitly
`ObservedEvolved`, and neither the constructor nor this candidate grants
negative or certificate authority.

The next
structural target is the q29 group-ring identity modulo 9: together with the
proved parity identity it is the exact reduction
`sum_i Y_i Y_i^* = 1` in `(Z/18)[C_29]`.  Since `ord_29(3)=28`, its nontrivial
mod-three component is one Hermitian equation over
`F_(3^28)/F_(3^14)`; a constructive norm/Hensel parametrization, rather than
rejection sampling, is the candidate route around the failed flat census.
Writing `q=3^14`, the residue Hermitian sphere has exactly `q^7-q^3`
points.  Every residue point has exactly `q^7` lifts to characteristic nine:
at least one residue coordinate is nonzero, and the first-order correction is
one surjective trace equation in eight `F_q` coordinates.  Thus the mod-nine
solutions number `q^14-q^10` out of `q^16`, an exact 44.37895-bit reduction
(22.1895 bits beyond the mod-three sphere).  A nonzero residue pivot and seven
free correction coordinates give a compact generator.  This theorem does not
yet count which generated residues lift to bounded integer rows with the
required exact energy, so it is a launch-enabling representation rather than
a completed solve estimate.
The typed direct extractor computes modulo nine once and derives modulo three
from the same pass; ten million replays fall from 223.710 to 122.210 billion
instructions (45.37% fewer), with zero allocation.  An independent exhaustive
`GR(9,2)/Z_9` oracle checks the sphere count and the uniform lift multiplicity.
The public private-module CRT inverse now rejects noncanonical residues rather
than silently reducing them, and its source-binding test makes a guaranteed
semantic change instead of conditionally skipping an equal-entry swap.

A separate bounded integer-lift endpoint now accepts four canonical mod-nine
rows and decides whether their residues lift to values in `[-9,9]` with row
sums `(1,0,0,0)` and combined energy 505.  Its iterative predecessor DP,
128-byte witness, congruence/sum/energy replay, exhaustive small mixed-radix
oracle, and repeated zero-allocation gate pass.  The initial workspace is
7,946,224 bytes.  Retaining all four row predecessor tables instead of
recompiling them grows the exact payload to 31,763,644 bytes but cuts a
1,000-solve control from 353.958 to 177.012 billion instructions and from
153.593 to 79.711 billion cycles (50.01%/51.90%); this RAM-for-compute form is
superseded by a stronger affine coordinate.  Writing a lift as
`y=b(r)+9t`, with `t in {0,1}` for nonzero residues and
`t in {0,1,2}` at residue zero, makes the exact row sum fix
`T=sum t=(target-sum b)/9`.  The row DP therefore needs only `(T,energy)`, not
the full 523-value sum axis.  Retaining four predecessor tables now costs
3,589,564 bytes for one-witness solving, and a 1,000-solve control takes 20.436 billion instructions
and 3.868 billion cycles: 8.662x fewer instructions and 20.608x fewer cycles
than the retained-table v2, with all witnesses directly replayed.  This
closes the endpoint needed by a residue-first modular
generator; it does not generate the Hermitian sphere itself, which remains the
current launch blocker.
The later counted-fibre sampler retains `u64` path counts as well as
predecessors, raising its exact workspace to 32,290,005 bytes per worker
(30.79 MiB).  It compiles a residue fibre once, samples distinct bounded lifts
into caller-fixed storage without allocation, and directly replays every
positive.  Saturated outer counts, if encountered, make only the sampling
distribution nonuniform; they never authorize a negative claim.
A constructive generator now removes that blocker at the modular level.  It
builds the mod-three Hermitian sphere in `F_3[T]/Phi_29`, performs a fixed
`19 x 116` linear Hensel solve, maps back to four canonical mod-nine rows, and
directly replays all correlations and augmentations.  Its 2,432-byte workspace
is iterative and allocation-free; independent cyclic-convolution and
100-seed replay tests pass.  Ten thousand generations cost 17.941 billion
instructions and 6.915 billion cycles.  In the first 100,000-shell downstream
control, 18,979 pass the minimum-energy bound, 1,674 admit exact bounded
integer lifts, and one independently satisfies the mod-two group-ring
identity.  This is the first unrestricted generated mod-eighteen quotient
shell; it has not yet satisfied the exact q29 equations.  Its deterministic
recapture and exact-q29 continuation are the immediate launch gate.
Randomizing the norm fibre while retaining the low-lift Hensel section gives
the first retained shell at seed 16,114.  Its bounded rows directly replay
modulo 2 and 9 and have exact q29 `y`-coordinate residual
`53,784 = 166 * 18^2`.  Fully randomizing the Hensel fibre is a useful
negative control: only one of 100,000 rows even passes the minimum-energy
bound, and none lifts.  An eighteen-worker, ten-million-mutation exact anneal
from the retained mod-eighteen shell reaches `y`-residual 206.  The outer
search reports in `x=2y` coordinates, so its residual 96 is the much smaller
`y`-residual 6; the two raw numbers must not be compared without this factor
of sixteen.  Reseeding that anneal from the level-37 shell later reaches
`y`-residual 116, still far above the unrestricted near miss.  The first
parallel wrapper now retains a fixed top 64 unique rows per worker and after
merge, keyed by structural mod-eighteen level and then a stable row hash and
seed; this is deduplication and ordering, not a distance-based diversity
claim. Every retained row is directly replayed.  The initial anneal costs
543.734 billion instructions and
157.785 billion cycles.  The next control parallelizes disjoint low-lift seed
ranges, banks many independently replayed mod-eighteen shells, and anneals
their best exact-score tail instead of overcommitting to one modular point.
There is an exact lattice endgame behind that score.  For a mod-eighteen shell
write its paired off-zero correlations as `C_s=-18+18 k_s`.  The global
identity `sum_s C_s=sum_i (sum_j y_ij)^2=1`, together with `C_0=505` and
correlation symmetry, gives `sum_{s=1}^{14} k_s=0`.  Therefore the independent
`y`-score is `324 sum_s k_s^2`, and the zero-sum integer norm is even.  Every
shell score is a multiple of 648; a nonexact shell has score at least 648.
The retained shells are consequently at exact lattice levels 83 and 37, while
level zero is the q29 solution.  This supplies a typed structural endgame and
a natural top-table key without a large certificate.

The current counted-fibre 18-thread control generated 180,000 modular seeds,
of which 28,819 pass the minimum-energy bound and 1,828 have nonempty bounded
lift fibres.  It sampled 115,189 distinct lifts and obtained thirteen directly
replayed mod-eighteen shells; the best is level 18.  The four nonmultiplexed
counters report 2,057,879,426,721 cycles, 1,278,991,914,348 instructions,
277,676,102,030 branches, and 995,958,090 branch misses.  No exact q29 hit was
seen.  The generator policy is now a typed field distinct from its structural
proof provenance, so deterministic-section, random-norm/random-Hensel, and
random-norm/low-lift streams cannot be conflated.

A tenfold counted-fibre scale control generated 1,800,000 disjoint modular
seeds.  Of these, 287,978 pass the minimum-energy bound, 18,007 have nonempty
bounded integer fibres, and 1,136,134 distinct sampled lifts contain 132
directly replayed mod-eighteen shells.  The best generated shell remains level
18.  Sixty-four ten-million-mutation follow-on anneals reach exact q29
`y`-score 156, with no exact hit.  The complete run costs
14,785,845,489,985 instructions and 21,671,396,501,441 cycles at full counter
coverage, peaks near 571 MiB RSS, and finishes in 351.9 seconds on eighteen
workers.  Thus scaling is healthy, but blind fibre sampling still spends about
8,607 bounded samples per useful parity shell.  A new fixed-workspace adapter
now targets that parity condition inside each fibre.  It samples exact row
lifts and joins `(row0,row1)` against `(row2,row3)` in a generation-stamped
direct-address table keyed by remaining energy and fourteen nonconstant binary
autocorrelation bits; the constant bit follows from odd total energy.  With a
512-row pool it obtains 84 directly replayed parity shells from 108 liftable
fibres among the same first 10,000 generator seeds.  The 49,881,090-byte
workspace is iterative and the repeated join allocates zero.  A properly
protected CHOOM repeat costs 338,952,216,281 instructions and
103,558,174,752 cycles.  Relative to the scaled blind control this is about
123x more parity hits per CPU cycle.  Pool misses remain sampled discovery
misses and grant no negative coverage.

The first parallel parity-target campaign assigns disjoint seed intervals to
eighteen worker-owned tables.  On 180,000 seeds with pool 512 it finds 1,828
liftable fibres and 1,336 directly replayed parity shells, improving the best
lattice level from 18 to 8 with no exact hit.  It retires
6,102,139,096,898 instructions and 12,774,168,730,868 aggregate cycles, about
91x the parity-hit efficiency of the comparable scaled blind campaign.
Complete-moment reconstruction of row zero is bounded in none of the 1,336
shells.  The next scoped hypothesis is therefore to search the fourteen
antisymmetric row-zero lift choices and derive its symmetric half, rather than
only enlarging the random row pool.  This pilot used neutral `choom -n 0`, so
its counters are not protected-run evidence.  A tenfold follow-up was
terminated during wrap-up after 20,032,815,753,860 cycles and
9,873,595,469,771 instructions, before it emitted a semantic report, and
consequently proves nothing.

The proposed follow-on is an exact **per sampled fibre** finite search, not a
new global theorem.  For each pair `(j,29-j)`, its two mod-nine residues admit
only the bounded lifts congruent to them, hence at most six distinct integer
antisymmetric differences.  An iterative fourteen-digit odometer supplies a
chosen difference vector; rows one--three plus the complete-moment recurrence
then derive row zero modulo 29, after which the carrier bound gives its unique
integer lift.  The only retained candidates must independently satisfy the
complete mod-nine row, row sum one, and the remaining row-energy budget before
the existing parity and full q29 replay.  This is a compact witness-constructor
boundary with zero implied negative authority: exhausting a sampled fibre
cannot exclude another fibre, and even a q29 hit still needs the q58/q87 and
length-522 replay path.

The next exact q29 theorem family is complete rather than merely a two-moment
gate.  For every even `k=2,4,...,26`, binomial expansion gives
`sum_s s^k C_s=0 (mod 29)` at the exact target; at `k=28` the right side is
18.  Since only block zero has nonzero augmentation, the degree-`2r` equation
contains `2 M_(2r)(0)` and otherwise only lower-degree moments.  It therefore
derives block zero's next even moment triangularly.  Degree 28 also fixes its
zero coordinate, and the Vandermonde matrix on the fourteen distinct quadratic
residues `1^2,...,14^2` then reconstructs the complete symmetric half of block
zero from blocks one--three plus only block zero's antisymmetric half.  This is
a compact structural endgame: fourteen row coordinates become derived state,
not a searched certificate.  On a directly replayed mod-eighteen shell, the
degree-zero identity plus degrees 2--26 force every symmetric residual to zero
modulo 29; the energy bound and zero residual sum then promote the congruence
to exact q29 equality.  The private typed implementation now independently
replays that implication without a direct-equality shortcut, rejects forged
source/semantic bindings, and passes randomized direct-PAF, extreme-value,
malformed-hypothesis, and allocation oracles.  Blind mining over all anonymous
degrees selects 2 then 4 and, after degree 2, learns survivor block mask
`0b0011` on deterministic train/holdout folds; promotion is exclusively
through the structural theorem.  Precomputed powers cut 100,000 complete
extractions from 148,450 to 56,764 instructions and from 41,198 to 11,769
cycles per extraction.  Row-zero reconstruction costs about 179,997
instructions/70,055 cycles and complete structural CRT replay about
120,949/59,329 per instance, both with zero hot allocation.

The unrestricted outer
near miss remains much closer: its six unit residuals occur at shifts
`1,3,5,11,12,13`, with signs `- + + + - -`; an exact three-distinct-block
radius search around that root misses after direct replay.

An unrestricted private transfer anneal now accepts that arbitrary q29 root
directly, rather than requiring its original six-class preimage.  Each move is
a bounded within-row unit transfer, so row sums are invariant while magnitude
inventories may change; exact energy and all fourteen independent PAFs are
rescored and positives are replayed independently.  The 64-byte hot summary
and 448-byte fixed workspace are iterative and allocate zero in the mutation
loop.  An eighteen-worker, ten-million-mutation control starts at `y`-score 6
and does not improve it or find an exact hit.  It costs 942,610,002,635
instructions and 306,668,950,751 cycles for 180 million requested mutations,
or about 5,237 instructions and 1,704 cycles per request.  This removes an
adapter gap but rejects broader unguided transfer annealing as the immediate
route; its miss has no negative authority.

A stronger exact local kernel now exhausts total transfer radius at most four subject to at
most two transfers per row.  It covers `2+2`, `2+1+1`, four distinct singles,
and all smaller patterns; same-row pairs are applied sequentially and only
distinct-row deltas are added.  The 105,495,040-byte iterative workspace has
zero hot allocations.  The retained root still misses, with scope-only
authority, after 13,398,226,056 cycles and 32,463,099,182 instructions.
The next exact slice quotients path permutations and cancellations into 4,495
canonical donor/recipient multisets and additionally exhausts every minimal
same-row three-transfer state and every `3+1` state.  The shared typed q29
moment extractor rejects by the proved degree-two/four identities before full
PAF replay.  This slice also misses.  The retained v2 kernel uses 35,960 extra
workspace bytes and costs 346,829,164,000 instructions and 91,105,850,000
cycles, versus 572,023,916,000 and 213,545,906,000 without the moment delta
gate: 2.344x fewer cycles.  Two support-mask variants were measured and
rejected.  Traversal is iterative, the hot loop allocates zero times, and the
negative remains scoped to the enumerated repair families around this root.
An exact radius-five `3+2` continuation uses the Queens-style RAM-for-compute
trade: it compiles every legal sequential same-row double into a 50,622,584
byte open-addressed tablebase, then scans the canonical minimal same-row
triples in each distinct block.  The key contains energy and all fourteen
independent q29 PAF coordinates; collisions receive full-key comparison, so
one retained preimage is sufficient and the earlier arbitrary-modular-
preimage defect cannot occur.  Every apparent hit is still replayed from the
root.  The retained `y=6` root misses this exact scoped family after
1,322,849,319,066 instructions and 336,384,144,140 cycles at 100% counter
coverage.  Table compilation/search allocates zero times after workspace
construction.  The same full-key representation closes two further
cross-block radius-five partitions.  `3+1+1` misses; subtracting the retained
prefix counters from the combined run gives 1.110T instructions and 317.874B
cycles for that incremental slice.  For `2+2+1`, twelve independent labelled
scopes run in parallel with worker-owned tables.  They exhaust 6,226,662,848
probes in 937,687,898,949 instructions and 608,599,797,064 aggregate cycles,
with 1,172,832 KiB peak RSS, no swap, and no hit.  An allocation-counted
499,737,280-probe representative scope performs zero allocations.  The full
cross-block `2+1+1+1` join adds 2,086,164,416 probes and also misses.  The
combined 12-worker run costs 1,199,907,798,666 instructions and
1,048,714,333,016 aggregate cycles.  The radius-five boundary now lacks only
the same-row partitions `5` and `4+1`; the length-522 lift also remains
uncovered.

An initial full `4+1` census was interrupted after
5,264,330,550,547 cycles and 23,912,229,628,053 instructions without a
progress checkpoint or semantic output.  It has no negative authority.  The
revised kernel now keys the compiled target table by exact changed-row energy
before the moment coordinates; this necessary shift-zero test is much cheaper
than complete moment extraction and passes a 100,000-state zero-allocation
test.  It was not restarted during wrap-up, so its full pruning rate remains
unmeasured.

Those last partitions admit a structural rather than enumerative filter.  A
candidate replacement-row autocorrelation must generate a positive-
semidefinite 29-by-29 circulant Gram matrix.  Exact negative principal minors
of orders two through four exclude 2,190 of the 9,660 labelled `row+single`
targets.  Machine-proposed cosine vectors are promoted only after exact
integer quadratic replay; they exclude another 3,316 targets and one of the
four same-row targets.  Thus compact PSD witnesses remove 5,505/9,660
`4+1` scopes and 1/4 same-row scopes without enumerating any radius-four or
radius-five row changes.  Ergodis-evolve, given all 56 anonymous
frequency/scale templates, independently ranks frequency 10 at scale 32 as a
zero-false-negative diagnostic excluding 2,100 of 9,664 targets.  The evolved
template remains `ObservedEvolved`; authority comes from the stored integer
vector and exact negative quadratic form.  A sealed private proof binds
extractor identity/version, parameters, canonical semantics, and the retained
root commitment, recomputes the census, and rejects forged counts or source
commitments.  One complete census plus evolve pass uses 77,859,635,828
instructions and 19,485,696,192 cycles; the proof/census loop allocates zero
times.  Raising the cosine scales from 32 to 64/96 excludes only one extra
target while increasing instructions to 79.020B and cycles to 20.653B; that
variant is rejected and the scale-32 cap is retained.
The private wrapper now hands that bank directly to optional strided anneal
tasks without serialization or theorem-specific external glue.  A current
machine-protected (`choom -n 1000`) repeat plus eighteen 100,000-mutation
tasks reports 1,914,971,598,999 cycles and 1,284,664,183,923 instructions at
100% counter coverage.  The best annealed residual is `y=2,956`, with no exact
hit; the handoff works, but it does not approach the outer `y=6` root.

The level relation has also been fed back into the private evolution layer.
Starting only from one directly extracted residual vector and the anonymous
coordinate permutations induced by the unit action, the miner recovers
`[1,1,...,1]` as the unique small homogeneous relation.  Promotion then
independently re-extracts canonical PAFs and derives the same relation from
the global PAF-sum identity; the compact proof is bound to its complete source
rows and rejects forged coefficients or rows.  A generic modular-nullspace
proposal followed by exact integer replay replaces the initial `3^14`
enumeration.  On 100,000 complete mine/promote/replay iterations it uses
2,457,049,434 cycles and 8,363,118,059 instructions at 100% counter coverage,
versus 58,014,873,446 cycles and 117,865,102,533 instructions for only 100
iterations of the exhaustive version: about 23,611x fewer cycles per
iteration.  An exhaustive differential oracle still recovers the same q29
relation, and the new modular kernel also agrees on independent nonuniform
small relations with zero hot allocations.

The outer `y=6` residual is not random noise.  Over `F_29`, write
`M_j(i)=sum_a a^j y_i(a)`.  Binomial expansion of the cyclic correlation gives
the necessary exact-target moments
`T2=2M2(0)-2 sum_i M1(i)^2=0` and
`T4=2M4(0)-8 sum_i M1(i)M3(i)+6 sum_i M2(i)^2=0` modulo 29.
The retained root has `(T2,T4)=(1,16)`.  Among all 1,154 legal single swaps,
only thirty attain the required T2 delta and none attain both deltas; the T2
survivors occur only in blocks zero and one.  Thus two scalar structural
features prove the radius-one miss and learn a useful per-root block scope.
The typed extractor independently agrees with a full group-ring moment oracle,
binds source/parameters/semantics, and allocates nothing.  One million
extractions cost 4,111,859,119 cycles and 15,026,489,490 instructions versus
5,900,761,068 cycles and 28,811,490,627 instructions for the direct full-PAF
control, with all counters nonmultiplexed.

A private generic blind-moment kernel now enumerates every exponent through a
caller-supplied bound on anonymous target-relative cyclic signals, greedily
selects zero-moment predicates, and learns categorical input/survivor scopes
on deterministic train/holdout folds.  Its 64-byte Tiger records, caller-owned
workspaces, iterative traversal, malformed-input gate, and zero-allocation
test pass.  It is still discovery-only: the q29 adapter has not yet shown that
this blind presentation recovers degrees two/four and scope `{0,1}`, and no
structural promotion follows from the generic miner alone.

There is also a compact exact trade identity for the full residual:
`AA* - BB* = E`, where `A={0,1,2,7,18,21}` and
`B={0,1,2,8,17,18}`.  An independent ordered-pair oracle replays it.  All 232
translated/oriented one-row applications reduce to fourteen bounded,
energy-preserving candidates and zero exact repairs.  This is a proved motif
and an exact scoped negative census, not a global impossibility claim; it is
now a candidate move template for the next evolve iteration.  Sequential
same-row replay extends the exact census to all 26,106 pairs and 2,001,460
triples with replacement among the 228 individually bounded applications.
The pair family has 1,428 energy-preserving candidates and no repair.  The
triple family has 2,001,440 bounded candidates, 73,419 energy-preserving
candidates, only 51 survivors of the proved degree-two/degree-four moment
gate, and no repair after direct q29 replay.  Ten complete triple censuses use
76,028,665,780 instructions and 17,461,380,275 cycles at 100% counter coverage
under CHOOM.  The allocation-counted hot census performs zero allocations;
its negative authority is restricted to this translated/oriented trade
family around the observed root.  Extending the same exact family through four
applications exhausts 115,584,315 multisets: 115,579,786 are bounded,
3,424,084 preserve energy, 4,604 also pass both moment identities, and none is
exact.  One nonmultiplexed CHOOM census uses 503,042,829,127 instructions and
112,749,455,048 cycles.  This closes the cheap radius-four trade-template
attack but still says nothing about arbitrary repairs or the q29-to-522 lift.
A RAM-for-compute compositional tablebase strengthens the same motif far more
cheaply.  It compiles every net state of at most two translated/oriented trade
applications per row, rescoring same-row combinations directly, then joins
blocks `0+1` against `2+3`.  Its 32-byte keys contain energy and all fourteen
independent correlations; witness indices live in a cold sibling array and
full-key collision comparison makes one preimage sound.  The four row domains
have `1770/1770/1556/1770` states, the left side has 3,031,081 distinct keys,
and 2,754,120 right-side probes cover up to eight applications with at most two
per row.  The exact scoped family misses, using 180,133,984 bytes,
798,593,002 instructions, and 1,578,757,050 cycles with zero hot allocations.
This is roughly two orders of magnitude less compute than brute-force four-
application enumeration while covering a strictly larger compositional
family.
Allowing exactly three applications in any one row while the other rows retain
at most two extends the same tablebase through as many as nine applications.
The triple-row domains have `34220/34220/28540/34220` states; four exact
pair-table builds retain 11,379,176 distinct keys and answer 224,900,920
probes.  This larger scoped family also misses.  It uses 181,393,984 bytes,
28,138,466,842 instructions, and 63,062,025,758 cycles with zero hot
allocations.  The high cycles/instruction ratio identifies the expected TT
latency boundary; further expansion should reduce keys or learn a tighter
scope rather than merely enlarge the table.

As a deliberately untrusted discovery control, bounded nonlinear SMT encoded
all q29 equations and an L1 radius-six neighborhood.  The first form and a
second form with explicit delta/cardinality bounds both timed out after 300
seconds.  They consumed 5.585T/5.992T instructions and 1.447T/1.414T cycles.
The second form is an instruction regression and the adapter is rejected and
removed; neither timeout has negative authority.  Compact counter logs remain
only as rejected-backend evidence.

An additional exact cross-level gate projects each q174 class summary
`(total,n0,n3)` to the complete set of compatible q18 row-degree energies via
the three-row Gale--Ryser conditions.  A fixed 1,152-byte bitset workspace
combines all twenty-four classes and tests whether q18 zero energy 1,976 is
reachable before any off-zero or binary lift.  It is iterative,
allocation-free, checks block weights `(262,261,261,261)`, and fails closed on
malformed summaries.  An independent exhaustive oracle agrees on all 4,960
realizable class summaries.  This is a proved necessary gate, but its strict
pruning rate awaits the first retained unrestricted exact margin-shell corpus.

The observed q18 mechanism is simpler than the full DP.  For class total `t`,
convexity makes the balanced triple `(ceil(t/3), nearest, floor(t/3))` attain
the minimum row energy; q174 realizability guarantees this triple also
satisfies both Gale--Ryser inequalities.  Summing these twenty-four attained
minima gives a standalone proved lower-bound gate.  A natural fixed-weight
sample rejected none of 100,000 q174-energy-shell states, while a deliberately
broad exact-shell tail sample rejected 126 of 1,000,000.  Every rejection was
explained by the convex lower bound; there were no upper-bound or internal-DP
gap rejections.  On an identical 100,000-state stream, lower-only evaluation
costs 2,214,526,013 cycles and 3,968,544,181 instructions versus
23,117,046,510 and 109,754,803,539 for the full DP: 10.44x fewer cycles and
27.66x fewer instructions with the same thirteen rejections.  Full DP remains
an exact deferred verifier; search uses the structural lower bound first.

There is therefore no honest sub-two-day full-solve estimate yet.  Even an
exact hit in this shell adapter would still be only a quotient seed: the
actual character-constrained q58/q87 census, fourteen off-zero Eisenstein
correlations, q18-compatible join, binary reconstruction, and direct replay of
all 521 original PAF equations remain.  The launch gate is a measured pair
side near `10^8` states or less (for roughly 2 GiB of TT), together with a
checkpointed positive reconstruction path.  Until both exist, a long run
would be an exploratory heuristic campaign rather than a likely two-day solve.
At the current counted-fibre cost, a generous two-day 18-thread counter model
is only on the order of `10^9` nonuniform generator seeds.  That can yield many
mod-eighteen discovery roots, but it samples a negligible fraction of the
roughly `2^310.65` exact mod-nine shell, has no negative coverage, and still
has no q29-to-length-522 completion stage.  It is therefore not a full-solve
launch merely because it fits in about 0.6--0.8 GiB.  Heavy pilots and any
eventual campaign must use the project convention `choom -n 1000`, making the
worker sacrificial under memory pressure to protect the machine.

## Quaternionic-perfect-sequence mechanism audit

Theorem 9 of arXiv:2601.22337 is not an unrestricted bordered-GS reduction.
Its pairwise-amicability conclusion assumes all three quaternion-type signed
cross-correlation identities; the C1016 SDS problem assumes only the combined
autocorrelation identity.  Importing its CPSD-zero/amicability filter would
therefore be unsound unless a sealed construction-family tag explicitly
restricts the search to `williamson_qt` or a bordered-amicable subfamily.
Likewise, the paper's alternating-negation equivalence changes the bordered
target at odd shifts and is not available here.
The separation already has a four-point exact oracle: rows
`(-1,1,1,1)`, `(-1,-1,1,1)`, `(-1,-1,1,1)`, and `(-1,1,-1,1)` have sums
`(2,0,0,0)` and combined off-zero PAF `-4`, while the first row is not
amicable with the second or third.  Any future CPSD adapter should retain this
as a negative test against accidental QT-only promotion.

The reusable mechanism is its exact `2+2` pair join.  Pair PAF signatures are
additive, so one side is keyed by `PAF_A+PAF_B` and the other by its exact
target complement; q29 needs only fourteen independent integer coordinates and
q18 only nine after exact pair energy is carried as the zero-shift coordinate
(fifteen and ten total respectively).  Evolve may learn anonymous coordinate masks and key ordering,
but learned masks are coarse buckets only: a hit receives complete exact-key
comparison and direct replay.  PSD bounds and principal-minor flags are sound
prefilters; rounded FFT/CPSD tolerances remain discovery accelerators rather
than proof authority.  Independent sign, cyclic shift, and reversal of each
row, common unit decimation, and permutation of the three zero-sum rows are
safe bordered equivalences.  This audit keeps the paper's useful search
mechanism without importing its QT-only theorem assumptions.

## Mystery ledger

- **Settled:** public proof-shaped metadata was unsound and is fully removed.
- **Settled:** order 6 compounds strongly with the existing `g=53` sectors.
- **Settled:** the order-29 `g=91` sector is a two-coordinate quadratic-field
  cancellation problem with exactly two profiles.
- **Settled:** quaternionic amicability belongs to a separate Williamson/QT
  construction root, not bordered GS.
- **Settled structurally:** complete character-sector coverage synthesizes the
  `Z/18` quotient-PAF theorem, whose zero shell removes 20.430689 bits beyond
  q2/q3/q6 and forces a sparse ten-profile defect family.
- **Settled for g53:** the sparse exact q0--q4 fibre is empty; q29 overlap is
  irrelevant for this multiplier shard.
- **Settled privately:** sealed typed extractors, source/parameter commitments,
  provenance roles, and independent semantic replay now gate proof authority.
  Public Ergodis remains deliberately non-authoritative.
- **Settled:** common unit dilations give exact four-block quotients of order
  14 or 12 beyond the multiplier subgroup.
- **Open:** affine multiplier classes beyond commuting translations and common
  unit dilations remain uncompiled.
- **Settled:** the ten defect profiles reduce q0--q3 to four special-mask fibre
  classes, none containing the required q4 value.
- **Settled:** transfer to g91 strengthens to the impossible Diophantine
  equation `13 n27 + 15 n29 = 34`, closing that shard at q0.
- **Settled for g41 quotient filtering:** the shift-orbit theorem reduces ten
  quotient equations to q0/q1/q2/q3/q6/q9, and independently exact filters
  reduce 262,144 roots to 768 necessary survivors. Weighted and direct joins
  agree on all 1,984,512 raw common quotient interfaces; sealed cached replay
  removes the arbitrary-preimage defect, so quotient-only filtering is
  exhausted.
- **Settled for the complete g41 branch:** q174 projection energy has the exact
  structural lower bound 2675 on every one of the 1,984,512 sealed q18 source
  interfaces, while a solution requires 2083.  The 592 gap closes the branch
  without a fine-lift search or large certificate.
- **Settled structurally for g41 fine fibres:** 2-adic autocorrelation
  lifting compresses mod-16 coefficient images by 56.65x, and all four block
  images have the same order-`2^27` additive hull.  The induced order-32
  quotient is exactly the weighted autocorrelation-sum law plus the synthesized
  binary quadratic identity.  All 768 retained witnesses satisfy both, so it
  is a representation reduction rather than a root filter.
- **Settled for the first g41 q58 collision:** exact mixed-q87 liftability
  strengthens the four-token endgame from 35 to 11 states via `n0>=1` and
  `n2 in {0,3,4}`.  The sealed proof recompiles bounded source-state joins;
  the simpler structural explanation and cross-interface scope remain open.
- **Settled for the first g41 q174 root:** the exact q58-group/q87-fibre
  hierarchy leaves four broad profile quartets. Exhaustive source lifts turn
  them into at most 128 q174 states per block fibre, and any of ten evolved
  independent q87 shift classes excludes every lift. Shift 10 is in the class
  of shift 4, and the three-phase theorem derives shift 33 from shift 4,
  q87 energy, and q29; `[4,6]` broad plus an evolved independent pair in the
  endgame is the bounded compositional form. Translation by 261 reduces the
  global block/domain schedule to 762/22,776, but full q174 table reuse and
  the final solve bound remain open.
- **Settled for g133 q0:** exact defect energy excludes 11,038,464 of
  26,763,264 mod-four roots; q1 and tested q2--q4 scalar modular/range shapes
  add no reduction.  Exact same-witness joint q2--q9 lifts modulo 8 and 16
  also retain every q0/q1 root, closing that low 2-adic theorem family.
- **Settled privately for g133 q2:** exact q2 interior gaps remove 352,512
  q0/q1 roots; an independent shifted-bitset compiler agrees, every survivor
  directly replays, and a sealed digest-bound proof adapter authorizes the
  exclusions as exact-computational.
- **Settled for the g133 shard:** the evolved mod-11 feature is the exact
  three-cycle identity; its sealed typed extractor, canonical 42-cell transfer,
  fixed-hash join, and independent ordered-vector replay exclude all 6,739,200
  q6 survivors without a large certificate.
- **Open:** unrestricted order 2092 remains outside these multiplier-assumed
  results.  With g41, g53, g91, and g133 now structurally closed, the next
  runtime model must address the unassumed compressed search rather than quote
  the retired g41 fine-lift envelope.

C1016 changes are committed only in the private monorepo; no public Ergodis
core change, publication, export, or external synchronization is approved.
