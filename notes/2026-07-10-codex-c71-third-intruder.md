# C71 report: history-aware three-involution transition — the third intruder is not a function of center geometry

Date: 2026-07-10.

## Result

The three-intruder layer was mined exactly from the q=13/17/19 S4 Grundy dumps.  The
statement-target map

```text
(two-intruder before-skeleton, geometry of the three centers)  -->  three-intruder after-skeleton
```

**is not a function of the tested geometric coordinates.**  Even at the finest key tried
(before-shape + collinear/triangle + the sorted pairwise PGL(2,q) product-order triple
{d_xy,d_xz,d_yz} + the sorted line-type triple), a single geometric key routes to many
distinct after-skeletons: up to 12 at q=17, and 94.4% of all q=19 2->3 transitions live in
a violating key class.  The residual coordinate the map is missing is **the labelled
embedding of the live conic cells** — which specific live cells the new center's involution
`sigma_z` pairs and which its kill-lines delete — not any PGL-invariant of the center
triangle.  This confirms the C45 §4 / residual-note §5 prediction ("no Dawson path-cycle
invariant survives once three matchings are present; the game-specific object is the ordered
sequence of legal intruders and live-set deletions") and turns it from a warning into a
measured obstruction with named witnesses.

The coefficient check is positive and exact.  For every 2->3-intruder move the potential
change decomposes definitionally as

```text
dPsi = dReservoir + 6*dC - 4*dI - 2*dXor0,   dI = +1 always,
```

so the transition reproduces `Psi`'s `6*components - 4*intruders` weighting by construction:
the structural part of the move's `Psi`-effect is exactly `6*dC - 4`, and the remainder
`dReservoir - 2*dXor0` is the C70 reservoir/collision charge.  Single-move `Psi`-nonincrease
holds on 100% of q=13 and q=17 transitions and 99.9976% of q=19 (26 exceptions, all one PGL
orbit — see §5).  So `Psi`-descent on 3+-intruder states reduces to **a `dC` rule + the C70
charge**, and the C71 deliverable is that the `dC` rule *cannot* be geometric alone.

Prior art (both cited per the mid-run import): the group/geometry dictionary for the center
triangle is P. Tranchida, *Triples of involutions in PGL(2,q) and their incidence
geometries*, Innov. Incidence Geom. 22 (2025), 25-46, arXiv:2411.10299 — off-conic points are
identified with the trace-zero involutions of the conic stabiliser, and triples are
classified by the incidence geometry of their three centers (collinear vs triangle; polar
relation).  That supplies exactly the C71 step-1 case-split coordinate and nothing game-valued;
the mined transition table below is the load-bearing content.  The S4 bucket sizes obey the
exact fiber-stabiliser identity `fiber(B) = 30(q-1)/|Stab_PGL(2,q)(B)|`
(codex odd-plane round-1 report, §3), which is why the per-root reachable sets differ in size.

## 1. The mining tool: `s4triple`

Added to the shared solver as a new mode (built to a distinct binary; the running
`gridcap-arena` q=25 census was never touched):

```bash
rustc -O -C target-cpu=native notes/2026-07-06-grid-cap-solver.rs -o rust/target/gridcap-c71
gridcap-c71 s4triple <q> t1,t2,t3,t4 --grundy <grundy-raw> [--rows <tsv>] [--cap N]
```

It rebuilds every reachable state of an exact Grundy dump (the C63 memory-compact
parent-pointer traversal), and for every parent that holds exactly two off-conic intruders
`{x,y}` and every legal off-conic move `z` (which makes a third intruder) it emits the exact
before-skeleton, after-skeleton, the three-center geometry, and the `Psi` feature deltas.
Skeletons are the exact live-conic Node-Kayles graph (`s4_conic_graph_feature_string`, the
same object C45/C63 use); nothing is inferred from a coordinate classifier.

## 2. Geometry dictionary and its exact validation

An off-conic point `(r,c)` induces the trace-zero Möbius involution `sigma` on the root conic
`xy=1` with PGL(2,q) matrix `[[-1, r],[-c, 1]]` (derivation in the source comment: the chord
through conic params `t,t'` is `x + t t' y = t + t'`, and `(r,c)` lies on it iff
`t' = (r-t)/(1-c t)`).  The pairwise datum is `d_xy = ord(sigma_x sigma_y)` in PGL(2,q),
computed by matrix powering; line type is the affine conic-point count on the center line
(0 external, 1 tangent-direction, 2 secant); collinearity and conjugacy (`d==2`) give the
triangle's polar relation.

**Independent check of the product order (the Lemma-VI cycle law).** Lemma VI says every free
`<sigma_x,sigma_y>`-orbit that survives intact is a cycle of length exactly `2*d_xy`.  The
miner cross-checks every live cycle length against `2*d_xy` computed from the matrices:

```text
q=17 root: cyc_law_ok=67  cyc_law_bad=0
q=19 root: cyc_law_ok=527 cyc_law_bad=0
```

594 live cycles, zero mismatches — the PGL product-order computation agrees with the exact
`line_mask`-built graph.  (q=13 states carry no surviving cycles, so its check is vacuous.)
The observed `d` values land only on `{divisors of q-1} ∪ {divisors of q+1} ∪ {p}` as Lemma
VI requires (e.g. q=19: `d ∈ {2,5,9,10,19,20,...}`, `5|20=q+1`, `9|q-1=18`, `19=p`).

## 3. The function test — NOT a function of center geometry

Three key resolutions were tabulated, coarse to fine:

```text
K1 = before-shape + (collinear vs triangle) + #conjugate-pairs (d==2 count)
K2 = K1 + sorted pairwise order-triple {d_xy,d_xz,d_yz}
K3 = K2 + sorted line-type triple {lt_xy,lt_xz,lt_yz}
```

A key that maps to more than one after-skeleton is a residual-dependence violation.  Verbatim
`S4TRIPLE-KEYS` lines (`viol_trans` = transitions living in a violating key class):

```text
q=13 root:  K1 keys=11  viol=4  viol_trans=436  | K2 keys=51  viol=9  vt=331  | K3 keys=51  viol=9  vt=331     (28.4% of 1167)
q=13 b1237: K1 keys=11  viol=5  viol_trans=629  | K2 keys=54  viol=12 vt=533  | K3 keys=54  viol=12 vt=533     (43.6% of 1223)
q=13 b1235: K1 keys=13  viol=5  viol_trans=235  | K2 keys=60  viol=10 vt=189  | K3 keys=60  viol=10 vt=189     (28.3% of 668)
q=13 b1238: K1 keys=8   viol=3  viol_trans=177  | K2 keys=25  viol=2  vt=72   | K3 keys=25  viol=2  vt=72      (11.9% of 604)
q=13 b1269: K1 keys=6   viol=2  viol_trans=280  | K2 keys=17  viol=0  vt=0    | K3 keys=17  viol=0  vt=0       (0% — this root IS a function at K2)
q=17 root:  K1 keys=59  viol=52 viol_trans=138578| K2 keys=1170 viol=808 vt=136054| K3 keys=1175 viol=809 vt=136033 (88.8% of 153266)
q=19 root:  K1 keys=118 viol=112 viol_trans=1008322|K2 keys=3281 viol=2609 vt=1003715|K3 keys=3310 viol=2611 vt=1003410 (94.4% of 1063392)
```

**Verdict: the map is not a function, and the violation fraction grows with q**
(≈28% at q=13 → 89% at q=17 → 94% at q=19).  Refining the geometric key from K1 to K3 barely
helps (K2→K3 removes essentially nothing — line type is already implied by the product order),
so no amount of *center* geometry closes it.  The one clean case (q=13 root 1269 is a function
at K2) is a small-reachable-set accident, not a structural sub-law: at q=17/19 even the
before-shapes with the richest geometry fan out maximally.  This is the C64/C69 flip-control
discipline satisfied in the other direction — the negative is present at the "full" orders
{13,19} and at the depleted order {17}, and strengthens monotonically, so it is not a
small-field artifact.

## 4. Violation witnesses (identical geometric key, many after-skeletons)

The sharpest single witness (q=17 root, K3 fan-out 12), verbatim from the analyzer:

```text
worst K3 key fan-out=12: P[3,1]C[-]O[-]comp2live4xor3k1|col0|conj0|d[9, 9, 9]|lt[0, 0, 0]
    after=P[1,1] count=140   after=P[1] count=139   after=P[2] count=91
    after=P[3] count=64      after=P[2,1] count=49  after=P[1,1,1] count=11
    after=O[4] (deg-3) count=8   after=P[-] (empty) count=8   after=C[3] count=8
    after=P[4] count=4       after=P[1]C[3] count=4  after=P[3,1] count=4
```

One before-state (a live 3-path plus an isolate) with an all-external equal-order center
triangle (`d_xy=d_xz=d_yz=9`, all lines external) produces twelve different live-conic graphs,
including surviving cycles `C[3]` and degree-3 "other" components `O[...]` — exactly the
max-degree-3 regime where the C45 path/cycle XOR theorem breaks.  A q=19 witness at the
single-cell resolution (`s4triple` `S4TRIPLE-VIOL` output) makes the mechanism explicit:

```text
key=P[2,1]C[-]O[-]comp2live3xor0k1|col0|conj0|d[5, 5, 19]|lt[0, 0, 1]
  after=P[3]   count=12  ...  x=0,16 y=11,9  z=17,11   (z fuses the path+isolate into one 3-path)
  after=P[1]   count=366 ...  x=13,4 y=16,8  z=5,14     (z kills two live cells, one isolate left)
  after=P[2,1] count=12  ...  x=5,7  y=8,16  z=10,0     (z misses; skeleton unchanged)
  after=P[-]   count=259 ...  x=8,16 y=10,0  z=5,7      (z kills all three live cells)
```

Same before-shape, same collinear flag, same pairwise orders `{5,5,19}`, same line types —
four outcomes decided solely by *where* `z`'s matching and kill-lines fall on the specific
live cells.  **The missing history coordinate is therefore the labelled position of the live
conic cells on the dihedral orbit relative to `sigma_z` and to the lines through `z` and each
previously-played point** — a per-cell incidence record, not a PGL invariant of the triangle.

## 5. Coefficient check — `Psi`'s 6/-4 weighting is reproduced exactly

`dPsi` for a 2->3 move decomposes definitionally as
`dPsi = dReservoir + 6*dC - 4*dI - 2*dXor0` with `dI=+1`; the analyzer confirms the identity
on 100% of every corpus.  The `dC` histograms (`dC = child_components - parent_components`):

```text
q=13 root:  -2:44   -1:350   0:773
q=17 root:  -4:16   -3:2870  -2:26356  -1:69466  0:52495  1:2033  2:30
q=19 root:  -5:4    -4:1765  -3:33652  -2:211940 -1:472432 0:322055 1:20965 2:567 3:12
```

Reading:

- A third intruder **almost always merges or preserves** defect components (`dC ≤ 0`); at q=13
  it never creates one.  Component *creation* (`dC > 0`) is rare and bounded — ≈1.3% at q=17,
  ≈2.0% at q=19, max `+3` — and is exactly the case where a new external matching, together
  with vertex kills, shatters a live path into isolated vertices.
- The `S4TRIPLE-DC-MEANS` confirm the decomposition numerically, e.g. q=17 `dC=+2`:
  `6*2 - 4 = +8`, `meanDreservoir = -15.8`, so `meanDpsi = -7.8 ≈ -8.067`.  The `-4` intruder
  credit plus reservoir drop cover the `+6*dC` component penalty in every mean.

Verbatim coefficient gate:

```text
q=13 root:  skel(6dC-4)<=0 = 1167/1167     dPsi<=0 = 1167/1167
q=17 root:  skel(6dC-4)<=0 = 151203/153266 dPsi<=0 = 153266/153266
q=19 root:  skel(6dC-4)<=0 = 1041848/1063392 dPsi<=0 = 1063366/1063392
```

**The 26 q=19 single-move `Psi`-increases are one PGL orbit.** Every one is the same
transition:

```text
before P[5]  (one live 5-path, comp1 live5 xor3)   -->   after P[1,1,1] (three isolated, comp3 live3 xor1)
geometry: col0, d[5,5,5], all external, lt[0,0,0]   (an "equilateral" external center triangle, 5|q+1=20)
dC=+2  =>  6*2 - 4 = +8;  dReservoir ∈ {-2,-5,-6,-7};  dPsi ∈ {+1,+2,+3,+6}
```

An all-external, all-`d=5` third involution shatters the maximal live 5-path into three
isolated cells, and the `+8` skeleton penalty out-runs the small reservoir drop.  These are
*opponent* moves (a single 2->3 step, not the P->reply pair that C63 proves descends), so
they are not a `Psi` failure — they are the precise configuration where P2's reply must then
do the reservoir work.  They are the C71 analogue of C63's 12 q=19 tie rows: a single
symmetric geometric orbit carrying the entire residual.

## 6. What a transition theorem must carry, and the `Psi`-descent reduction

Because `dC` is *not* a function of the center geometry, a closed three-involution transition
theorem must be stated over the labelled data.  The exact form the mining supports:

```text
Let L be the live conic cells of a two-intruder state with centers x,y, and let z be a third
off-conic center.  Playing z (i) deletes D(z) = { s in L : s collinear with z and a played
point } and (ii) overlays the matching sigma_z on the survivors L\D(z).  The after-skeleton is
the union graph (sigma_x ∪ sigma_y ∪ sigma_z) induced on L\D(z).  Its component count changes
by dC, and 6*dC - 4 is the structural part of dPsi; but dC is determined by the incidence
pattern of z against the *individual* cells of L (which cells sigma_z pairs, which D(z) cuts),
which the PGL type of the triangle {x,y,z} does not fix.
```

So `Psi`-descent on a 2->3 state is exactly

```text
dPsi  =  [ 6*dC - 4 ]              (transition theorem: structural, needs the labelled coordinate)
       + [ dReservoir - 2*dXor0 ]  (the C70 exact reservoir/collision charge).
```

The C71 contribution is to pin down which half is geometric: the reservoir half is (C70's
target); the structural half needs the per-cell incidence record.  A useful, provable
finite-case fact that *does* survive: adding one matching to a graph can only merge components,
so any `dC > 0` is caused entirely by the vertex deletions `D(z)`, bounding
`dC ≤ |D(z)| - (edges sigma_z adds among survivors)`; component creation is therefore gated by
the kill-set, and vanishes whenever `z` kills no live cell (`D(z) = ∅ ⇒ dC ≤ 0`).  This is the
right lever for C70/C61 to hold `Psi` down: keep the reply's kill-set off the live path
interior.

## 7. Reproduction and artifacts

Durable source (git-tracked):

- `notes/2026-07-06-grid-cap-solver.rs`: `s4triple` mode (`solve_s4_triple`, the PGL
  product-order/line-type helpers, and the K1/K2/K3 function test + coefficient gate).
- `rust/scripts/c71_transition_analysis.py`: stdlib-only independent re-derivation of the
  function test and coefficient decomposition from a rows TSV; reproduces the Rust aggregates
  exactly (verified on the q=13 and q=17 full corpora).

Commands (dump paths are the exact C35/C63 Grundy dumps; ignored bulk under
`rust/s4-dumps/2026-07-10/c71/`, regenerate with the C35 dumps if absent):

```bash
gridcap-c71 s4triple 13 1,2,3,4 --grundy s4-dumps/2026-07-09/c35/q13-root-1234.grundy.raw
gridcap-c71 s4triple 17 1,2,3,4 --grundy s4-dumps/2026-07-09/c35/q17-root-1234.grundy.raw --rows s4-dumps/2026-07-10/c71/q17-1234.rows.tsv --cap 200000
gridcap-c71 s4triple 19 1,2,3,4 --grundy s4-dumps/2026-07-09/c35/q19-root-1234.grundy.raw --rows s4-dumps/2026-07-10/c71/q19-1234.rows.tsv --cap 20000
python3 scripts/c71_transition_analysis.py s4-dumps/2026-07-10/c71/q17-1234.rows.tsv
```

Verbatim run summaries retained: `rust/s4-dumps/2026-07-10/c71/q13-all.summary.txt`,
`q17-1234.out`, `q19-1234.out` (the latter two include the `S4TRIPLE-VIOL` witnesses and the
26 `S4TRIPLE-PSIUP` rows).  The full transition TSVs are deliberately not proposed for Git and
are fully reconstructible from the Grundy dumps.  Single-core; peak RSS well under the 3 GB
budget (compact parent-pointer traversal, ~0.25 GB at q=19); the q=25 arena census was not
touched.

## Route verdict

**Deliverable of type (3b): exact residual dependence, with the missing coordinate named.**
The three-involution transition is not a function of the center-triangle geometry (collinear,
pairwise PGL orders, line/polar types); it requires the labelled embedding of the live conic
cells relative to the new center's involution and kill-lines.  The negative is robust across
q=13/17/19 and strengthens with q, and is exhibited with reproducible single-key witnesses of
fan-out up to 12.  The coefficient check is positive: the transition reproduces `Psi`'s
`6*components - 4*intruders` weighting exactly, single-move `Psi`-nonincrease holds to
99.998% with the entire q=19 residual concentrated in one symmetric orbit (`P[5] -> P[1,1,1]`,
equilateral external `d=5` triangle), and `Psi`-descent on 3+-intruder states reduces to a
`dC` rule (which needs the labelled coordinate) plus the C70 reservoir charge.  Next lever for
the closure program: state the `dC` rule over the kill-set incidence (C70/C61), using the
proved gate `D(z)=∅ ⇒ dC ≤ 0`, rather than searching for a further center-triangle invariant —
that search is now measured to be futile.
