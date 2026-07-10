# C63: amortized-potential LP fit and dual instrument

Date: 2026-07-10.

## Result

C63 produced a compact candidate, not an infeasibility dual.  On the exact C31-selected
P-to-P reply transitions at `q=13,17`, define

```text
R(S) = off-conic reservoir slack
     = zone_v(S) - (q-k) * max(0, q-k-binomial(k,2)-1),  k=|S|,
C(S) = number of connected components in the live-conic matching-union graph,
I(S) = number of selected off-conic intruders,
X0(S) = 1 if the live-conic Node-Kayles xor is zero, else 0.

Psi(S) = R(S) + 6*C(S) - 4*I(S) - 2*X0(S).
```

The integer replay result is

```text
q=13: 3,144/3,144 selected reply transitions strictly decrease Psi;
      Delta Psi is in [-70,-9].
q=17: 1,052,204/1,052,204 selected reply transitions strictly decrease Psi;
      Delta Psi is in [-92,-4].
```

This includes every legal opponent option from every reachable exact P state in all five q=13
and all ten q=17 full-PGL S4 bucket dumps.  The reply for each obligation was fixed before fitting:
among exact P replies, minimize C31's `max(child zone, child Z)`, tie-breaking by reply cell.
All `1,055,348` rows therefore certify the requested controllable-predecessor statement for this
verified strategy, rather than letting the LP choose a favorable reply after seeing the weights.

The candidate also charges the post-C65 extremal line exactly in the intended direction:

```text
q=23 Z=40 witness, P states along the reported worst line:
zone / child-Z context       Psi
119 / 40                     110
 40 / 7                       30
  7 / 0                      -19
  0 / 0                      -34
```

Thus the transient repair cost 40 is paid by an 80-unit first-pair potential drop, then the
potential continues down through the `7 -> 0` terminal layer.  This q=23 row is a targeted replay
of C65's extremal trajectory, not a full q=23 corpus validation.

The important caveat is that this is a **candidate Lyapunov function for the exact C31 selector**,
not yet a uniform proof invariant.  Its four features are geometric and q-uniform, but the current
reply selector consults exact game values and exact recursive Z.  The next proof obligation is to
replace that oracle selector by a geometric selector (C62/C61 territory) and prove `Delta Psi < 0`
for its replies.  C63 has found the ledger to target; it has not proved reply existence.

## Why the LP was normalized

The queue's literal condition, `Phi(child) <= Phi(parent)`, is homogeneous and always admits
`w=0`.  Calling that feasibility a result would be vacuous.  The fitted model therefore used the
standard strict normalization

```text
minimize ||w||_1
subject to (f(child)-f(parent)) dot w <= -1
```

with free-sign weights represented as `w+ - w-`.  Feasibility is invariant under the arbitrary
unit margin; it asks whether all transition deltas lie in one open half-space.  On infeasibility,
the implemented dual is the Farkas system

```text
y >= 0, sum(y)=1, D^T y=0,
```

whose basic feasible solution has small support and names the defeating transitions.  Neither
reported round was infeasible, so there is no dual certificate to claim.  The dual implementation
remains in `rust/scripts/c63-potential-lp.py` and is exercised whenever a future feature span fails.
A synthetic zero-delta infeasibility smoke test returned verbatim
`FARKAS-SMOKE status=PASS support= [(0, 1.0)]`.

## Declared v1 feature span and exact extraction

The v1 span was fixed before solving and contains 17 integer coordinates:

```text
conic_xor, [conic_xor=0], live_on,
zone_v, zone parity,
reservoir slack total, reservoir minimum-row/column slack,
defect component count, path/isolate count, odd-component count,
maximum path length, sum of squared path lengths,
selected off-conic intruders, path endpoints, isolates,
exact C31 Z ceiling, selected-strategy descent depth.
```

The reservoir floor is the already proved row/column count used by C33, evaluated at the current
ply.  `interface_intruders` counts the intruder-generated matchings; endpoints and isolates count
the surviving path-side interface/cut scars.  Defect summaries come from the exact live-conic
Node-Kayles graph, not from a coordinate classifier.

Extraction traverses every canonical record in an exact `GCAPGRD1` dump, checks its stored Grundy
value, computes P-state Z bottom-up, and emits one row for every `(P state, legal opponent move)`.
For each such N child it enumerates all legal replies and accepts only stored Grundy-zero children.
Terminal Good states are therefore not inferred: the five q=13 dumps contain 998 exact terminal P
states, and the ten q=17 dumps contain 264,239; every one has `g=0` and zero legal moves.

Verbatim extraction summaries:

```text
S4POTENTIAL-DONE q=13 t4=[1, 2, 3, 7] cells=[(1, 1), (2, 7), (3, 9), (7, 2)] records=1164 p_nodes=434 terminals=295 obligations=706 missing=0 root_Z=5 root_depth=4
S4POTENTIAL-DONE q=13 t4=[1, 2, 3, 4] cells=[(1, 1), (2, 7), (3, 9), (4, 10)] records=1117 p_nodes=398 terminals=263 obligations=700 missing=0 root_Z=4 root_depth=4
S4POTENTIAL-DONE q=13 t4=[1, 2, 3, 5] cells=[(1, 1), (2, 7), (3, 9), (5, 8)] records=668 p_nodes=255 terminals=163 obligations=456 missing=0 root_Z=4 root_depth=4
S4POTENTIAL-DONE q=13 t4=[1, 2, 3, 8] cells=[(1, 1), (2, 7), (3, 9), (8, 5)] records=648 p_nodes=272 terminals=131 obligations=668 missing=0 root_Z=4 root_depth=4
S4POTENTIAL-DONE q=13 t4=[1, 2, 6, 9] cells=[(1, 1), (2, 7), (6, 11), (9, 3)] records=661 p_nodes=291 terminals=146 obligations=614 missing=0 root_Z=4 root_depth=4

q=17 aggregate: records=1,537,648 p_nodes=462,775 terminals=264,239
                obligations=1,052,204 missing=0 across 10/10 buckets.
```

The q=17 aggregate record/P/terminal counts reproduce C38 exactly.

## Round 1: requested v1

q=13 was fitted first using a deterministic whole-parent split: four fifths of parent keys fit,
one fifth held out.  HiGHS returned the one-term solution

```text
Phi_v1(S) = descent_depth(S).
```

Verbatim validation:

```text
q13 fit:      rows=2440  max_change=-1  failures=0
q13 heldout:  rows=704   max_change=-1  failures=0
q17 frozen:   rows=1052204 max_change=-1 failures=0
```

This is correct but proof-circular: descent depth was defined bottom-up from the exact selected
strategy.  It confirms the extractor and implements the post-C65 depth request, but it is not
called a candidate invariant.

## Round 2: proof-admissible geometry

Round 2 removed `Z`, descent depth, and the two raw residual cardinalities `live_on, zone_v`.
The first q=13-only fit was

```text
Phi_13 = (7/24)*defect_odd_components
       + (1/24)*defect_path_sum_sq
       - (1/2)*interface_intruders
       + (1/6)*interface_endpoints.
```

It passed all 704 q=13 held-out obligations but failed frozen q=17 transfer on 71/1,052,204 rows.
One machine-readable counterexample, with deltas in the round-2 feature order, is:

```text
q=17 t4=1,2,3,9 parent_key=02656a87c3e5ae17695c86d294a75e6a
parent_ply=8 opponent=11,3 reply=4,13
child_key=007c0b71433de857ca82d57754622c93 child_ply=10
delta=[-1,1,0,-6,-1,1,2,2,1,2,1,2,2]
Delta Phi_13=+1/2
```

Reading the transfer failures led to the q=13+q=17 refit within the same declared geometric span.
The sparse optimum was

```text
Phi = -(1/3)*[conic_xor=0]
      +(1/6)*reservoir_slack_total
      +1*defect_components
      -(2/3)*interface_intruders.
```

Multiplying by six gives the primitive integer candidate `Psi` in the Result.  The q=13/q=17
whole-parent fit/holdout replay was:

```text
fit rows:       q13=2,440       q17=843,680
held-out rows:  q13=704         q17=208,524
held-out nonincrease failures:  0              0
integer full replay: q13 3,144/3,144, q17 1,052,204/1,052,204 strict decreases
```

The floating L1 optimum's worst held-out change is `-2/3`; the integer scaling has worst changes
`-9` at q=13 and `-4` at q=17.  Exact integer replay, not floating tolerance, produced the final
counts.

## C65 extremal replay

Command:

```bash
rustc -O -C target-cpu=native notes/2026-07-06-grid-cap-solver.rs \
  -o rust/target/gridcap-c63
rust/target/gridcap-c63 s4potentialprobe 23 1,2,3,8 13,4 9,19
rust/target/gridcap-c63 s4potentialprobe 23 1,2,3,8 13,4 9,19 10,15 0,7
rust/target/gridcap-c63 s4potentialprobe 23 1,2,3,8 13,4 9,19 10,15 0,7 6,20 4,10
rust/target/gridcap-c63 s4potentialprobe 23 1,2,3,8 13,4 9,19 10,15 0,7 6,20 4,10 7,5 11,9
```

Verbatim relevant output:

```text
ply=6  conic_xor=0 zone_v=119 reservoir_slack_total=102 defect_components=3 interface_intruders=2 c63_candidate=110
ply=8  conic_xor=1 zone_v=40  reservoir_slack_total=40  defect_components=1 interface_intruders=4 c63_candidate=30
ply=10 conic_xor=0 zone_v=7   reservoir_slack_total=7   defect_components=0 interface_intruders=6 c63_candidate=-19
ply=12 conic_xor=0 zone_v=0   reservoir_slack_total=0   defect_components=0 interface_intruders=8 c63_candidate=-34
```

## Reproduction and artifacts

LP solver: SciPy 1.17.1 `linprog`, HiGHS backend.  No dependency download was needed; the existing
cached environment was used.

```bash
.uv-cache/environments-v2/s4-ml-mine-c62c2f326ce38a36/bin/python \
  scripts/c63-potential-lp.py --data s4-dumps/2026-07-10/c63 \
  --out s4-dumps/2026-07-10/c63/lp-results.json
```

Durable source artifacts:

- `notes/2026-07-06-grid-cap-solver.rs`: `s4potential` exact extractor and
  `s4potentialprobe` feature replay.
- `rust/scripts/c63-potential-lp.py`: LP, held-out replay, exact integer replay, and sparse Farkas
  dual implementation.
- `rust/s4-dumps/2026-07-10/c63/lp-results.json`: machine-readable weights, validations, and the
  first 12 q=17 transfer counterexamples (ignored bulk-data directory; regenerate with the command
  above if it is not retained).

The full transition TSVs are deliberately not proposed for Git: about 250 MB logical text, fully
reconstructible from the exact Grundy dumps.  The report records every aggregate validation gate
and the script records the machine-readable result.

## Route verdict

Positive, with a sharp scope boundary.  C63 found the first coupled, integer, alternation-anchored
ledger that survives exact q=13 and q=17 full-corpus replay and the C65 q=23 extremal descent.
It uses exactly the objects the negative results left alive: reservoir slack, the conic defect
skeleton, the conic/zone interface (intruder matchings), and xor only through the zero predicate.

Promote

```text
Psi = reservoir slack + 6*(defect components)
      - 4*(selected intruders) - 2*[conic xor = 0]
```

as the scoring/closure target for C62 and the state charge for C61.  Do not yet state it as a
uniform invariant: its present strategy witnesses are tablebase/Z-defined, and only one targeted
q=23 line has been replayed.  The immediate falsification test is to score C62's geometric selector
families by `Delta Psi < 0`; a selector that covers every obligation would turn this empirical
Lyapunov function into the missing proof-shaped Good-closure lemma.
