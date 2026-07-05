# n=20 lucky-first-win plan

**Date:** 2026-07-04
**Scope:** synthesis from the discussion beginning with: how might flat non-attacking queens
`n=20` become feasible if we are lucky and the first player wins? This is a plan for proving one
root win, not for solving the full board. No runs/builds in this note.

## Premise

The lucky premise is:

```text
B_20 is an N-position, and the central diagonal root J10 = (9,9) wins.
```

If that premise is false, the plan is not a proof of anything. If it is true, the right task is
not "solve n=20"; it is:

```text
prove that R_20 = B_20 after (9,9) is a P-position.
```

That is still large, but it has far more structure than an arbitrary root child.

## Structural decomposition

After the central diagonal strike `c* = (9,9)`, write:

```text
S = [0..18]^2
tau(x) = (18,18) - x
L = row 19 union column 19
```

Then:

```text
R_20 = odd-board center residual inside S
       + live L-border
       + cross-attack entanglement between them.
```

The `S` component alone is exactly the odd `19 x 19` center residual, hence P by the center-steal
mirror theorem. (The one-line reason the mirror is non-self-attacking there: `x` attacks `tau(x)`
iff `x` lies on row 9, column 9, or one of the two center diagonals — exactly `N[c*] ∩ S`, all
dead after the strike.) The live border has:

```text
2(n-2) = 36 live border cells.
```

The border is two clique arms, so at most two border moves can occur. This bounded-event fact is
the main reason a certificate may be much smaller than a generic game tree.

Compare the central-child geometry:

```text
n=18: paired core live = 224, border live = 32, border/core ratio = 0.143
n=20: paired core live = 288, border live = 36, border/core ratio = 0.125
```

Closed forms: paired core live = `(n-1)^2 - 4(n-1) + 3 = (n-2)(n-4)`, border live = `2(n-2)`,
so border/core = `2/(n-4)`. The defect fraction shrinks like `1/n` — the quantitative version of
the claim below.

If the n=18 mechanism is real, n=20 may be strategically easier for the central striker even
though the raw search tree is much larger: the number of border events remains bounded while the
paired reservoir grows quadratically.

One caution on what "bounded" buys: border **events** are bounded by two, but border **states**
are not — every core exchange `(x, tau(x))` deletes a different border subset, so the mirrored
children proliferate by border-attack pattern. The certificate compresses only if the border
state matters through a small signature (arm occupancy, incidence counts, line overlaps). That
is a hypothesis, not a theorem, and it is the load-bearing unknown this plan's Phase 0 exists to
measure.

## What to build

Build a focused proof/certificate mode for the central child, not a faster general solver.

### 1. Fixed-root mode

Start directly from:

```text
B_20 after J10
```

No root fanout. No attempt to refute all 55 D4 root classes. Theorem 3 does not license that for a
P-proof, but it is irrelevant for an N-proof if this root wins.

### 2. Automatic tau rule

While the opponent plays a core square `x in S` whose `tau(x)` is live, reply `tau(x)` immediately.

Scope of soundness: this is **reply selection, not verification**. The Copying Lemma certifies P
only when the pairing covers every live vertex; in `R_20` the border is unpaired from move one
(`tau` maps row/column 19 off the board), so the paired invariant never holds while any border
cell is live. The class "paired core + live unpaired border" contains N-positions outright: a
nonadjacent pair `{p, tau(p)}` plus one isolated border cell is three isolated vertices with
`G = 1`, lost for the defender under any strategy. Two consequences:

- Playing `tau(x)` is legitimate as the *only* reply explored (a P-proof needs one certified
  reply per opponent move, not all replies), but the child after `(x, tau(x))` must still
  re-enter certification. Unconditional Copying-Lemma logic applies only once the border is
  fully dead.
- The collapse this rule buys is an induction over the invariant class "paired core + border
  state," memoized on a border-state signature — not a free pass on core branches.

With that framing it should still collapse the ordinary paired-core branch, provided the border
state matters only through a small signature (the Phase 0 question).

### 3. Exception states only

The search/certificate should branch only on:

- border moves;
- scar moves where `tau(x)` is dead;
- finite repair-vocabulary moves produced by previous exceptions.

Everything else is automatic mirror play.

One endgame case the automatic rule must not skip: the opponent can decline to touch the border
until the paired core is exhausted and then take the last border move(s) for parity. Exhaustive
per-node certification covers this automatically; any fast path that certifies "mirror to the
end" must explicitly include the core-thin positions where live border cells decide who moves
last.

### 4. Border repair candidates

For a row-arm border intrusion, try col-arm replies; for a col-arm intrusion, try row-arm replies.
Rank candidates by:

- exact active/mate incidence asymmetry;
- row/column quotient score from the B6/O6 border-overlap model;
- low asymmetry rank;
- line-load balance after the reply;
- high deletion count as a tiebreaker;
- known n=18 killer/repair replies if extracted.

Important: asymmetry rank and B6-style minimizers are **not sound pruning rules**. They only
generate and order candidate replies. Soundness must come from the final certificate.

### 5. Scar repair certificate

After a border exchange, the border game is nearly exhausted. What remains is a scarred paired
core. Try to prove it by an S2-style bounded certificate:

```text
mirror ordinary tau-paired moves;
table scar exceptions by incidence/line-overlap signature;
after each repair, reach:
  - an S1 closed-pairing certificate, or
  - a tau-symmetric diagonal-free leaf, or
  - a dense exact leaf, or
  - another bounded-depth repair state.
```

The torus `n=10` probe from the analytic-targets note is encouraging here: static S1 failed, but
depth-two adaptive repair succeeded. That is exactly the style of certificate we should try for
flat `n=20`.

## Sampling strategy

A single PV is not enough to prove a P-child. The object to sample is a reply book.

Partition opponent moves at any certificate node (classes 1-3 are the possible first replies in
`R_20`; class 4 arises only after a border exchange has already happened):

```text
class 1: core move with tau live
class 2: row-arm border move
class 3: col-arm border move
class 4: scar move after a border exchange
```

Expected handling:

```text
class 1: forced tau reply
class 2/3: choose ranked cross-arm border repair
class 4: choose scar-repair table entry
```

For each border move, try the top `k` asymmetry-minimizing replies and run the bounded certifier
below that reply. If one certifies, record it. If none certifies, emit an unresolved leaf with:

- border state;
- scar incidence signature;
- asymmetry rank of tried replies;
- best child live count;
- shallow PV/refutation attempt if available.

Those unresolved leaves, not the full tree, are what should be fed to heavier search.

## Proof pipeline

### Phase 0: n=18 calibration

Before spending serious time on n=20, attempt to prove the known winning child:

```text
B_18 after I9
```

with the same certificate mode.

Success criterion:

- a compact rule-plus-exceptions certificate for the I9 child;
- most branches handled by tau mirror;
- border/scar exceptions compress by the incidence vocabulary;
- the border-state signature stays small: distinct signatures actually reached grow far slower
  than distinct border subsets (this is the direct test of the compression hypothesis from the
  structural-decomposition section);
- unresolved leaves are few and individually small.

Failure warning:

If `n=18` I9 cannot be certified compactly, then `n=20` probably needs ordinary alpha-beta over a
huge P-child. In that case this lucky-first-win plan is not likely to fit this box.

### Phase 1: n=20 central-child sampling

Run the certificate extractor on:

```text
B_20 after J10
```

Do not attempt a full board solve. The extractor should either:

- certify the child; or
- produce a small unresolved-leaf set.

### Phase 2: solve only unresolved leaves

For unresolved leaves, use the production solver or a focused leaf solver with move ordering:

1. tau reply if live;
2. border/scar repair candidates;
3. exact asymmetry minimizers;
4. cross-root killers from n=18/n=20 sampling;
5. max-deletion fallback.

Every solved unresolved leaf should be folded back into the certificate book.

### Phase 3: checker-friendly artifact

The final artifact should be:

```text
root J10;
automatic tau rule;
border/scar exception table;
S1/tau/dense/solved-leaf terminal claims;
coverage proof that every opponent move is handled.
```

This is much more checkable than a transposition-table trace.

## Soundness boundaries

Sound:

- tau mirror replies when the live set is tau-closed (border fully dead) and the
  non-self-attacking condition holds; while border cells are live, a tau reply is candidate
  generation and its child must be certified (see the automatic-tau-rule scope note);
- S1 closed-pairing certificates;
- S2 repair tables when coverage is explicit;
- orbit-isomorphism move reduction under a verified stabilizer;
- dense exact leaves;
- true-twin deletion;
- future false-twin compression only after it is proved.

Not sound by itself:

- low asymmetry score;
- B6 minimizer membership;
- border-tempo heuristics;
- high deletion count;
- n=18 PV resemblance;
- "central roots tend to win."

The unsound items are ordering and candidate-generation features only.

## Runtime estimate if lucky

The relevant luck is not merely "J10 wins"; it is "J10 wins with a shallow, compressible
border/scar certificate."

Estimated wall-clock ranges on the current box:

```text
best case:        2-12 hours
plausible lucky:  1-4 days
still lucky:      1-2 weeks
bad luck:         degenerates toward full n=20 scale, likely impractical here
```

Rough breakdown:

```text
n=18 certificate-mode calibration:  hours to 1 day
n=20 J10 child sampling:            hours
exception-book growth/debugging:    1-3 days
unresolved leaf solving:            hours to 1+ week
certificate/check pass:             hours
```

The optimistic path requires most first replies in `R_20` to fall into:

```text
tau-live core move -> instant tau reply
border move -> one of a small ranked repair set works
scar move -> depth <= 2 or 3 repair reaches S1/dense/tau leaf
```

The main warning sign is failure to certify `n=18` I9 compactly. If that fails, the expected
runtime is no longer "days"; it is probably outside the practical range of this box.

## Prior art anchors

Web-verified 2026-07-04. Each phase of this plan has a published ancestor to lean on:

- **Reply book + coverage proof (the Phase 3 artifact):** Patashnik, "Qubic: 4×4×4 Tic-Tac-Toe",
  Math. Mag. 53 (1980) — 2,929 hand-supplied strategic moves plus machine-verified coverage of
  every defense; Allis, *A Knowledge-Based Approach of Connect-Four* (MSc thesis, VU Amsterdam,
  1988) — VICTOR's sound-rule composition. Both are weak solutions (one root proven), exactly
  this plan's shape.
- **Unresolved-leaf solving (Phase 2):** proof-number search (Allis, van der Meulen, van den
  Herik, Artif. Intell. 66, 1994) and df-pn are the standard non-alpha-beta tools for proving a
  single root's outcome when the winning strategy is narrow — consider a PN-mode leaf solver
  before defaulting to the production alpha-beta path. Scale hybrid: Schaeffer et al., "Checkers
  Is Solved", Science 317 (2007) — forward proof tree meeting endgame databases.
- **Knowledge collapses branches, search handles exceptions:** the Hex solving line —
  Henderson–Arneson–Hayward, "Solving 8×8 Hex" (IJCAI 2009), Henderson's thesis (the
  inferior-cell/dead-cell canon), Pawlewicz & Hayward's scalable parallel DFPN (CG 2013; all
  9×9 openings solved, 10×10 open). Hex's **mustplay region** — intersect the opponent's threats
  to soundly shrink the reply set — is worth adapting for border intrusions: a sound shrink of
  class 2/3 candidate replies would compound with the (unsound, ordering-only) asymmetry ranking.
- **Machine-checkable certificate formats:** the DRAT / cube-and-conquer paradigm
  (Heule–Kullmann–Marek, SAT 2016) and QBF encodings of positional games (Mayer-Eichberger &
  Saffidine, SAT 2020; Shaik & van de Pol, ACG 2023) are the reference points for what
  "checker-friendly artifact" should mean — an independent verifier, not a replay of our own
  code.

## Immediate next tasks

1. Build a lightweight certificate extractor around `tau` mirror, S1 checks, orbit quotienting,
   and bounded exception depth. Keep it separate from production search at first.
2. Run Phase 0 on `n=18` I9 under conservative memory limits. Where the certificate's reply book
   overlaps lines from the production n=18 solve (the 15-move PV, extracted killer replies),
   cross-check them — cheap corroboration, not a soundness requirement.
3. Add border-repair candidate generation using the existing incidence/asymmetry formulas.
4. If Phase 0 compresses, run Phase 1 on `n=20` J10.
5. If Phase 0 does not compress, do not start a broad n=20 campaign; switch to improving the
   certificate vocabulary on n=18.
