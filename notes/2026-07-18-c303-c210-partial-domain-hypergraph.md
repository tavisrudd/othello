# C303: the terminal partial-domain route fails before collision optimization

**Lane**: `relconic`

Date: 2026-07-18.

## Result

C302's support-graph gate has a decisive answer on all four exact `GF(8)` terminal geometries from
C298: **no collision-free restriction is `C`-complete**.  In fact, failure occurs before the
collision transversal is chosen.

For each terminal branch and each anchoring seed color, the nominal two-seed/two-repair
presentation has 32 layer vertices but only 30 geometric points.  There are two exact seed/repair
coincidences and one further selected repair point on the prescribed conic.  Since a relative arc
must be disjoint from the conic, that point must be deleted.  Direct projective incidence then
shows that exactly one affine point outside the conic becomes uncovered.  Coverage is monotone
under deletion, so no further restriction can restore it.

The four cases are:

| case | coincident layer labels | mandatory conic deletion | newly uncovered required point |
|---|---|---|---|
| `e=0`, alpha anchor | `A0=L0`, `B2=L2` | `R1` | `(x,h)=(50,46)` |
| `e=0`, beta anchor | `B0=L0`, `A2=L2` | `R3` | `(x,h)=(60,46)` |
| `e=1`, alpha anchor | `A1=R1`, `B3=R3` | `L0` | `(x,h)=(51,46)` |
| `e=1`, beta anchor | `B1=R1`, `A3=R3` | `L2` | `(x,h)=(61,46)` |

The integer coordinates are the frozen `GF(64)` representation used by the committed C210
checkers; they are certificate labels, not invariant field notation.

This also corrects the naive terminal-star picture.  The C298 star centre is itself one of the
seed/repair coincidence points.  Deleting its geometric point, together with the mandatory conic
point, removes the seven star edges but still leaves 23 collinear triples.  The full geometric
collision hypergraph has 32 bad lines, each containing exactly three selected points.  Subject to
the mandatory conic deletion, its minimum collision transversal has size 11, so the largest
admissible arc restriction has 19 points.  A certified optimum misses 122 affine required points
and five required points at infinity.

Thus neither of the two possible hopes survives at `q=8`:

1. deleting only the terminal star centre does not make the full configuration an arc; and
2. optimizing over all collision transversals cannot preserve relative completeness, because the
   mandatory conic deletion has already destroyed it.

This is an exact bounded negative for the four terminal geometries, not an infinite-tower theorem
for fresh coefficients.  Outside the terminal strata, C298 still proves a linear collision
deletion cost, but C302 shows that collision matching alone does not determine coverage loss.  No
carrierwise support certificate for those nonterminal specializations is currently available, so
C303 does not promote the bounded computation into a general partial-domain obstruction.

## Geometric quotient before optimization

C298's collision correspondence uses three colored parameter classes.  That is the correct ground
set for projection and matching bounds, but a partial arc is a set of geometric projective points.
At the terminal branch intersections two pairs of colored vertices have the same image.  C302
already required these coincidences to be quotiented before applying its coverage-support graphs.

The certificate therefore performs the following order of operations:

1. construct the 16 seed and 16 repair layer vertices;
2. quotient equal projective points while retaining joined layer labels;
3. identify every selected point of height zero, hence on `XZ=Y^2`;
4. delete that conic point as a mandatory admissibility condition;
5. build collinear-triple constraints and projective coverage on the remaining geometric points.

Every case has exactly two doubleton coincidence classes, no higher coincidence, and exactly one
selected conic point.  This boundary was invisible in a layer-vertex-only star count but is
load-bearing for the partial-domain question.

## Monotone coverage obstruction

Let `V` be one of the 30-point geometric quotients, let `c in V intersection C` be its unique
selected conic point, and let

    R = PG(2,64) \ (V union C)

be the old required locus.  The certificate forms the C302 support graph `G_x(V)` for every
`x in R`.  After deleting `c`, it finds one `x_0 in R` with

    E(G_{x_0}(V)[V\{c}]) = emptyset.

Equivalently, every pair witness covering `x_0` uses `c`.  Hence `{c}` is a vertex cover of
`G_{x_0}(V)`.  For every larger deletion set `D` containing `c`,

    G_{x_0}(V)[V\D]

is still edgeless.  Therefore no admissible subset of `V` is complete outside `C`.  This is an
exact monotonicity proof; exhaustive enumeration of all subsets is neither needed nor performed.

The primary pair masks include all 4096 affine points and the 64 nonvertical points at infinity.
The vertical point at infinity is the conic point `[0:0:1]` and is correctly excluded from the
required locus.  Deleted off-conic selected points are added back to the required set, implementing
the correction isolated during C302.  The mandatory deleted point `c` lies on the prescribed conic
and therefore is not itself required.

## Collision audit and maximum arc restriction

For completeness, the certificate also builds the full collinear-triple hypergraph after the
geometric quotient.  In every case:

    geometric vertices       = 30,
    bad lines                = 32,
    bad-line size histogram = {3:32},
    collision triples        = 32.

The mandatory conic deletion is imposed before optimization.  An exact iterative-deepening
transversal search branches on one uncovered triple, deletes one of its three vertices, and uses a
greedy disjoint-edge packing as a valid lower bound.  It exhausts every smaller budget and finds

    minimum total deletions = 11,
    maximum arc size        = 19.

The frozen optimum witnesses differ only by the expected terminal symmetries.  Each misses exactly
122 affine required points and five required directions at infinity; every deleted off-conic
vertex is itself covered by the surviving set.  These witness counts illustrate the scale of the
coverage loss, but the one-point mandatory-deletion obstruction already proves nonexistence for
all collision-free restrictions.

## Independent incidence replay

Two implementations construct the load-bearing incidence data.

- The primary implementation groups pairs by normalized projective line keys and builds each line
  mask from its slope/intercept formula.
- The independent replay tests every selected triple by the affine projective determinant and
  scans all 4096 affine targets directly for every selected pair.  It then adds the independently
  identified point at infinity of each nonvertical line.

The two implementations agree exactly on all 32 collision triples and all pair-coverage masks in
all four cases.  Their canonical incidence SHA-256 values are:

| case | SHA-256 |
|---|---|
| `e0_alpha` | `92ee6b305ce09f09fb82e577023b22edbf4e299de2366519e6395c28ed500b98` |
| `e0_beta` | `883277fb65e9f403822b397f42b9e2fb77132fd815aa13407ff605f83ee457b0` |
| `e1_alpha` | `f5271647034501f9e15f51ee897d71ce3f8e609a48ffa259234663e32a9fa6bd` |
| `e1_beta` | `46602b7bf5d47d1572e7cbed6d3f7ae2d5008efbe050d2bf8efc206bcbab9a5e` |

The coverage-constrained collision search is also replayed with the direct masks and reversed
branch ordering.  Both versions stop at the root in every case: mandatory conic deletion already
exhibits the uncovered required point.

## Artifact and replay

The atomic evidence bundle is:

- `papers/arcs_complete_outside_conic/analyze_c303_partial_domain_hypergraph.py`;
- `papers/arcs_complete_outside_conic/analyze_c303_partial_domain_hypergraph_output.json`;
- `papers/arcs_complete_outside_conic/analyze_c303_SHA256SUMS`.

Replay from `papers/arcs_complete_outside_conic/` with:

```bash
python3 analyze_c303_partial_domain_hypergraph.py --check
```

The check regenerates the canonical JSON in memory, compares it byte-for-byte with the tracked
output, and verifies the checksum manifest without changing the worktree.  The recorded runtime
environment is Python `3.13.12`; the script uses only the standard library and the committed C210
finite-field implementation.

| artifact/input | bytes | SHA-256 |
|---|---:|---|
| `analyze_c303_partial_domain_hypergraph.py` | 20,223 | `adda30229e95d1725f0eded3520069b5934d3805b67f0c6337b64ef4e7051f5b` |
| `analyze_c303_partial_domain_hypergraph_output.json` | 8,034 | `30318a27db2b801420c9620443bd18a3bc993033fd942e6299e5af7c0f3975e1` |
| `analyze_c303_SHA256SUMS` | 437 | `0d679e6a745c7e59121918a55d5bb4152b1d841e09778e2259480aee7c73529a` |
| `probe_c210_two_layer_parabolas.py` | 10,231 | `f0bf41b76de2a7f5db495880c5c00288e2c7c27ea6927ff9a0c7433fb5ee861d` |
| `probe_c210_quadratic_coset_repairs_output.txt` | 2,656 | `02ec5f85c1658a4d21724fc58872b2d94e3d8140a5b423c6b57f2d725b3ea4ce` |

The manifest is authoritative for the generator, output, and two load-bearing inputs; its own hash
and byte count are frozen in the report.

## Evidence boundary

The trusted boundary is exact integer-coded arithmetic in the committed `GF(64)` implementation,
the frozen C210 seed/repair input row, standard-library exhaustive branching, and the direct
projective incidence replay described above.  There are no random choices or seeds.

The certificate proves a finite statement for the four exact `GF(8)` terminal geometries.  It does
not prove:

- that every nonterminal C210 specialization lacks a complete partial domain;
- that fresh coefficients over larger fields inherit the selected conic point;
- that C298's linear deletion bound implies linear coverage loss; or
- a global obstruction to `C`-complete `O(sqrt(q))` arcs.

No broad coefficient or subset census was run.  The mandatory-deletion witness is stronger and
smaller than such a census for the terminal cases.

## Vibe check

This is a clean negative and a useful correction.  The terminal stars looked like the place where
a one-vertex collision repair might survive, but the geometric quotient shows that admissibility
already forces a coverage-killing deletion.  The terminal loophole is closed at `q=8`; the
nonterminal partial-domain question remains genuinely separate rather than being hidden behind the
star count.
