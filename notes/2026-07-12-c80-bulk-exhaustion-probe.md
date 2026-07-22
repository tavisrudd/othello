# C80 — game-side bulk-mechanism probe (exhaustion / abundance / descent)

**Date:** 2026-07-12. Lane: game-side attack on the C79 bulk-quotient spec ("compress
many genuinely active, edge-disjoint intruder matchings behind a bounded interface").
Companion measurement: [C83 bisimulation quotient](2026-07-12-c83-bisimulation-quotient.md);
the residual-graph structure: [conic-involution residual graphs](2026-07-12-conic-involution-residual-graphs.md).

Design rule (from the queue): tune the generic mechanism on **nondepleted** orders
(q=13/19) and treat depleted q=11/17 as certificate territory.

## (c) Drain resource — the conic move as closed-neighborhood removal

Conic-only play is Node-Kayles on the live-conic graph `G_live` (join `u,v` when a selected
center lies on chord `P_u P_v`), so selecting a live point `t` removes exactly its closed
neighborhood. Stated in game coordinates for use as a descent resource:

Let `S` be a legal residual position, `I(S)` its off-conic centers, `L(S)` the live conic
parameters. Center `x` induces the involution `σ_x` on the conic (`σ_x(s)=t` iff `x ∈ P_s P_t`;
tangent points fixed).

**Exact drain.** Selecting a live point `t` deletes exactly `1 + k_t(S)` live conic points,
where `k_t(S) = #{x ∈ I(S) : σ_x(t) ≠ t, σ_x(t) ∈ L(S)}` is the number of centers active at
`t`. *Proof.* `t` leaves `L`; a live `u ≠ t` leaves iff the chord `P_t P_u` gains a second
selected point besides the new `P_t` — necessarily an off-conic center `x` with `σ_x(t)=u`.
The dying points are `{σ_x(t) : x active at t}`, and these are distinct: a coincidence
`σ_x(t)=σ_y(t)` (`x≠y`) would put two centers on chord `P_t P_{σ_x(t)}`, saturating it (cap
capacity 2) and making `t` illegal, contradicting `t` live. So the count is `1 + k_t`. ∎

This is the capacity-2 Node-Kayles move specialized to the conic; the residual→Node-Kayles
transition itself is Huggan–Huntemann–Stevens. What it gives the program:

- **`|L(S)|` is a computable well-founded measure**, dropping by `1 + k_t` per conic move
  (`|L| ≤ q+1` at the root). It supplies an induction order and proves termination — but not
  value: absent a value invariant/parity/uniform bound it discharges nothing about who wins.
  It is scaffolding for (b), not a theorem.
- **The drop grows with the number of active centers at `t`**, feeding the global edge-density
  bound `|E(G_live)| ≥ Σ_x max(0, (q+1−f_x)/2 − d)` (`d` = dead conic points) — the raw
  material for a minimax exhaustion potential.
- Matches the observed play: C79's score-9 states are the `|L| = 1` regime, where one conic
  move drives `|L| → 0` (all four score-9 base candidates kill the conic).

### Verification

`rust/scripts/c80_drain_rate.py` BFS-enumerates all legal residual positions up to a size cap
and checks, exhaustively over every (position, live conic point): the exact drain
`|L(S)| − |L(S∪{P_t})| = 1 + k_t`, the distinctness of live partners, and the ≤1-shared-edge
bound between two centers. **q=11, all positions up to size 6** (4,799,063 positions with a
center and a live conic point; 7,024,950 checks): all three hold with zero exceptions.
Active-center degree per live point `{0:4204720, 1:2160160, 2:597060, 3:62030, 4:980}` (max 4);
per-move drain is this distribution shifted by 1.

## (a) Abundance profile — PLANNED

Per (root R, opponent move x) at nondepleted q (13/19): winning-reply fraction, and whether
the winning set contains an entire bounded-condition packet (all D-generic on-conic replies
minus an explicit bad-fiber list). Target theorem shape: at nondepleted q **every** packet
member wins — existence by counting, no selector.

## (b) Descent / class preservation — PLANNED

Which lexicographic residual measure some winning reply always strictly decreases
(candidates: conic defect type, `|live conic|`, edge-density budget `Σ_x max(0,(q+1−f_x)/2−d)`,
zone complexity); and whether some winning reply re-enters the balanced/normal-form class. The
exact drain makes `|live conic|` a validated component of any such measure; the missing step
is upgrading a greedy drain move to a minimax potential.

## 2026-07-22 — C447/C460 cloud packet: exact partial `12+5+5` law

C447's two matchings are nonconcurrent, so they are not themselves cap moves or global reply maps.
C460 supplies the type-correct point object: each matching has a 15-point Frégier cloud of interior
points, and the clouds of C447's shared-edge cross-sheet pair meet in exactly five points.
Transporting that intersection through C447's certified projectivity gives a canonical five-cell
off-conic packet at each q=11 knife edge:

```text
class 4: {(4,10),(5,6),(6,2),(7,9),(8,5)},
class 7: {(2,10),(5,2),(6,3),(9,6),(10,7)}.
```

The exact game test covers both endpoints of both P edges, hence all four pointed representatives.
Every representative has 22 legal opponent moves and the identical packet-reply distribution:

| opponent branches | legal packet replies | P-valued packet replies |
|---:|---:|---:|
| 12 | 0 | 0 |
| 5 | 2 | 0 |
| 5 | 2 | 2 |

The square `C5` kernel of the cap-frame `D10` partitions the 22 opponent moves into orbit sizes
`1,1,5,5,5,5`.  The five good branches and five live-but-bad branches are whole `C5` orbits; the
twelve packet-killing branches are two further five-orbits plus the two fixed moves.  Thus the
cloud packet is not a winning strategy and does not complete C80(a), but its failure is highly
structured: whenever the packet is live, its two surviving replies have the same value, and the
good/bad distinction is exactly orbit-valued rather than a hidden orientation choice.

There is an exact quotient explanation.  Send the unordered P-edge endpoints `a,b` to
`0,infinity` by `t=(w-a)/(w-b)`, and write an opponent point in the induced conic coordinates as
`[X:Y:Z]`.  The quantity

```text
u = XZ/Y^2
```

is independent of rescaling `t` and of exchanging `a,b`, hence is intrinsic to the unordered edge.
On all four pointed states the branch law is

```text
u = 8 (nonsquare): two packet replies, both P,
u = 9 (square):    two packet replies, both N,
u in {0,1,∞}:      no packet reply remains legal.
```

Thus C449's split-torus Legendre blocks become literal game information: the two live `C5` orbits
are separated by square class on the one-dimensional edge quotient.  This is stronger and simpler
than the provisional cubic separator suggested by the raw `5+5` split.

The `ej` closeout then evaluates the complete first-response relation, not just the five-point
packet.  On the 22 legal opponent moves, join `x,y` when the pair is legal over the chosen P child
and the resulting size-six grandchild is P.  In every one of the four pointed states this graph is
connected with 22 vertices, 41 edges, degree histogram

```text
1^1 2^10 4^5 6^1 7^5,
```

and exactly **two** perfect matchings.  The quotient edge counts are

```text
0--infinity: 1,   1--1: 10,   1--8: 5,   1--9: 5,
1--infinity: 5,   8--9: 5,    8--infinity: 10.
```

The two perfect matchings share six forced edges: the unique `0--infinity` edge and the five
`1--9` edges.  Their symmetric difference is the 10-cycle between the cloud packet at infinity
and the good `u=8` orbit; its two alternating matchings are the only remaining choice.  Equivalently,
the formerly killed conic boundary `u=1` is exceptionally generous: after any of its five moves,
all four other `u=1` moves are legal P replies.

The symmetry action identifies exactly what the residual binary choice means.  The square `C5`
kernel fixes each perfect matching separately, while every nonsquare element of the cap-frame
`D10` swaps the two P-edge endpoints and swaps the two matchings.  Hence the response rules form a
two-point calibration torsor: choosing one costs the same orientation bit obstructed in C448, but
the unordered response correspondence—and therefore P-existence—needs no such choice.

### Orbital proof compression

The `C5` action gives a shorter proof of the matching statement.  The 22 vertices are two fixed
points and four free five-orbits, labelled by the edge quotient as

```text
0[1], infinity[1], 1[5], 8[5], 9[5], infinity[5].
```

The 41 winning edges split into one fixed edge and eight five-edge `C5` orbitals.  Every perfect
matching contains the fixed `0[1]--infinity[1]` edge and the unique `1[5]--9[5]` orbital.  The
remaining ten vertices support exactly two `8[5]--infinity[5]` orbitals.  Their union is the
10-cycle, and each orbital separately is a perfect matching.  Thus matching existence follows
from the group action without enumerating all matchings; enumeration is retained as an independent
check.

This exposes a reusable C80 lemma.  If a finite group acts transitively on equal-size opponent and
reply orbits and the value-correct response relation is invariant and nonempty, its bipartite
orbital graph is regular on both sides and has a perfect matching by Hall.  For free equal torsors,
a single edge orbital is already an equivariant bijection.  Consequently the generic task is not
to select a reply: it is to prove that one equal-orbit response relation is nonempty and P-pure.
C449 supplies the torus orbits, C452 supplies difference-set/intersection-number technology for
their edge counts, and C82 can own the eventual character-sum abundance bound.

For the P-value theorem even that is stronger than necessary.  If `H` stabilizes a parent state,
take one representative `x` from each `H`-orbit of opponent moves and exhibit one legal descending
P reply `y` after `x`.  For `x'=h x`, the transported move `h y` is a reply with the same value;
neither a well-defined transporter nor injectivity among replies is required.  Thus P-purity of an
edge orbital follows from one representative by value invariance, and equal orbit sizes/Hall are
needed only when one wants a fixed pairing certificate.

At this q=11 gate the 22 opponent moves form six `C5` orbits.  Their quotient winning graph has a
unique minimum three-relation cover

```text
0[1]--infinity[1],  1[5]--9[5],  8[5]--infinity[5].
```

The last relation has two edge-orbital lifts, producing the two perfect matchings.  Therefore the
two-match calibration torsor is extra certificate structure: the P proof itself consists of only
three orbit-representative response checks.

The uniform caveat is decisive.  Here `C5` genuinely stabilizes the pointed parent.  A generic C80
state may have trivial stabilizer, so its opponent branches do not collapse this way.  The
generalization must either produce a genuine symmetry of the bounded interface or work covariantly
over a family of normalized states and prove the response fibre nonempty for every parameter.
Merely observing torus coordinates or an association scheme does not create a game symmetry.

Nor can an aggregate parity or Fourier sum replace the representative P checks.  Such a count may
prove that a candidate orbital fibre is nonempty; normal-play recursion still requires an actual
P-valued reply after every opponent orbit.  Character sums address abundance, while C80(b)'s
descent induction supplies value.

### C474 restriction test for marked response torsors

C474 supplies a precise version of the principle that play can trivialize a choice obstruction:
represent the choice fibre by a cocycle and restrict its class from the unmarked stabilizer to the
stabilizer after a mark.  A zero restriction permits a marked equivariant section; a nonzero class
means the proof must retain the whole response fibre.  C474 also shows why checking only
involutions can be unsafe: its binary class vanishes on every `C2` and first appears on `C4`.

For the present q=11 response pair this calculation is elementary and exact.  The two calibrations
form the nonzero affine `F_2` class of

```text
D10 -> D10/C5 = C2,
```

detected by any nonsquare reflection.  Marking one P-edge endpoint reduces the stabilizer to `C5`,
where the class restricts to zero; this is why each response matching is separately `C5`-fixed.
Thus the cap torsor is detected at involution depth one and is trivial after the endpoint mark.

This is not C474's q=11 Ext class.  That class has coefficients in characteristic three, is
detected on a Sylow `C3`, and restricts trivially to `D10` because `3` does not divide `|D10|=10`.
Likewise C474's q=7 binary class is a depth-two `C4/C2` character, whereas the cap calibration is
already visible on `C2`.  The useful transfer is the restriction/local-detection method, not an
identification of carriers.

For a generic C80 packet, the resulting diagnostic is: define the response-choice torsor, compute
or recognize its local class, and restrict it to each opponent-mark stabilizer.  C474's one-scalar
functional and one-element Jordan-rank jump show two ways such a test can compress once a genuine
module extension exists.  No uniform cap response module or cocycle has yet been constructed.

### Available downstream bridges and tools

The C77/C79/C447/C474 evidence now exposes a useful division of labour.  These are theory routes,
not claims that their hypotheses or game consequences have already been proved.

| bridge | concrete C80 use | evidence gate / limitation |
| --- | --- | --- |
| Terwilliger algebra and triple-distribution SDP | Replace the failed pair statistic `tr(B^2)` by pointed triple-word data controlling C79's `tr(B^3)`; treat C77's contextual `Q3` in a separate quotient-energy flag lift. | The audit below rules out one ordinary pointed algebra containing both as linear coordinates.  A useful PSD inequality must force a nonempty P-preserving response fibre, not merely reproduce their classifier values.  Gijswijt, arXiv:1007.0906. |
| algebraic response variety plus character/Weil bounds | Encode legal descending replies as an incidence fibre `R_s`; prove generic fibres nonempty by character sums, Weil/Lang--Weil estimates, or, when applicable, Chevalley--Warning/Ax--Katz divisibility. | The estimate must be uniform enough to beat the error term, and every point counted must be a legal P-valued reply, not merely a legal move.  Degenerate/discriminant fibres route to C81.  Heath-Brown, arXiv:1009.3764, is a useful finite-field divisibility entry point. |
| orbit category, Mackey restriction, and fusion | For a parent stabilizer `H` and opponent orbit `H/K`, treat the response fibre as a `K`-set/torsor.  Existence of a `K`-fixed response is the exact equivariant-section test; restriction models adding a mark, and double-coset bookkeeping organizes transfers between stabilizers. | First construct the actual response torsor/module.  Local classes must also satisfy fusion-stability before they define a global obstruction.  Grodal, arXiv:1608.00499; Benson--Grodal--Henke, arXiv:1210.1564. |
| stable modules and endotrivial recognition | If a natural response module appears, test on relevant p-subgroups whether its stable endomorphism algebra is one-dimensional: `End(M) = k + projective`.  This could formalize "projective bulk cancels and a bounded defect survives." | Requires a canonical module attached to game states and a theorem translating its stable defect into P/N recursion.  Carlson--Thevenaz, arXiv:0706.4081. |
| equivariant discrete Morse theory | View legal continuations as a simplicial complex and pair bulk faces equivariantly, leaving a bounded set of critical defects on which exact recursion can run. | Ordinary homotopy equivalence does not preserve Grundy value or even P/N status.  C80 needs a new game-compatible acyclic-matching/strategy lemma.  Yerolemou--Nanda, arXiv:2203.00539. |
| sheaf/contextuality language | Separate local branch replies from a coherent global selector and record the obstruction to gluing local response rules.  This precisely explains why a selector can fail although every opponent move has some winning reply. | Cohomological contextuality obstructions are not complete and do not themselves prove P-value.  Abramsky--Brandenburger, arXiv:1102.0264; Caru, arXiv:1701.00656. |
| dimers, height/flux, and critical groups | Regard the two q=11 perfect matchings as dimers whose difference is the unique binary cycle; Pfaffian/Fourier methods and Smith normal form may give compact existence and calibration certificates for larger structured response graphs. | A perfect matching is stronger than the response existence C80(b) needs, and planarity/circulant structure will not persist automatically.  Kenyon, arXiv:0910.3129. |
| deformation and obstruction theory | Read an `Ext^1` class as a first-order response deformation and `Ext^2` as its lifting obstruction; this is a plausible bridge to C466's Hensel-style exceptional-prime analysis. | This is downstream until an actual cap response module and deformation parameter are identified. |

The resulting proof architecture should split rather than force one mechanism everywhere:

```text
generic low-stabilizer states
    -> no equivariant-selector obstruction
    -> algebraic/character/Weil fibre counts + finite choice

symmetric exceptional states
    -> few opponent orbits, possible response torsor
    -> restriction/local detection + fusion; send degeneracies to C81

recursive bulk
    -> seek a game-compatible Morse cancellation
    -> exact recursion on the surviving bounded defects
```

The immediate priority was to audit the Terwilliger/triple-distribution route: tabulate the pointed
orbitals for the existing q=11 and q=17 records, determine whether `tr(B^3)` and `Q3` live in one
pointed algebra, and ask whether positivity can force a descending P-response in every opponent
fibre.  The audit below shows that a one-sorted identification is false.  In parallel, the
large-q route should formulate the same fibre as an algebraic incidence problem and isolate its
discriminant locus.  Orbit-category restriction and fusion then belong on that exceptional locus,
where symmetry makes them informative rather than generic overhead.  Equivariant Morse theory is
the most promising true bulk-cancellation bridge, but only after its matching is strengthened to a
normal-play strategy lemma.  Endotrivial, sheaf, and dimer tools are presently recognition and
certificate layers, not substitutes for the descent proof.

### Pointed cubic audit: two different algebras

The q=11 response graph is an honest small orbital object.  On each of the four pointed states the
square `C5` has vertex-orbit sizes `1,1,5,5,5,5`; the 41 winning edges are one fixed orbital and
eight five-edge orbitals.  Its six-cell quotient and the three-orbital response cover are therefore
the right finite model for a coherent-configuration or Terwilliger treatment.

The two q=17 cubic signals do **not** unify in that one-sorted algebra.  If
`B=sum_i P_{sigma_i}` acts on conic parameters, then exactly

```text
tr(B^3) = sum_(i,j,k) #Fix(sigma_i sigma_j sigma_k).
```

It is a third word trace in the conic permutation algebra.  By contrast, let `c_g(y)` count ordered
pairs of the five nonzero finite reply-ray directions whose quotient is `g`.  Then C77's Boolean
triple-quotient statistic has the exact lifted form

```text
Q3(y) = [ E3(y) > 0 ],       E3(y) = sum_g binom(c_g(y),3).
```

Thus `Q3` is the support of a third factorial multiplicative-energy moment on the reply-pencil
direction sort.  It is cubic in pair multiplicities but is not a triple word trace on the conic
sort.  Putting both into one algebra requires at least a two-sorted incidence/coherent
configuration, or a flag/tensor lift carrying triples of quotient pairs; an ordinary pointed
Terwilliger table on conic parameters cannot contain both as linear coordinates.

The distinction is computationally strict on all 112 primitive candidates in the 28 q=17 score-9
transitions.  Direct permutation composition verifies the word-trace identity 112/112, and direct
quotient enumeration verifies `Q3 iff E3>0` 112/112.  There are candidates with equal `tr(B^3)` and
different `Q3`, and candidates with equal `Q3` and different `tr(B^3)`.  The `Q3/clean`
contingency is

```text
                 Q3 false   Q3 true
clean                 18         10
not clean             57         27
```

so `Q3` is not a score-9 clean-reply selector.  Conversely the pair `(tr(B^2),tr(B^3))` is
value-pure on this finite corpus: the clean/P candidates have exactly `(74,60)` or `(80,50)`, and
all other observed pairs are nonclean/N.  This is a useful base-certificate compression, not a
uniform moment rule: it is a two-value lookup on one q=17 stratum and supplies neither abundance
nor descent.

The corrected tool split is therefore:

1. use the conic permutation/Terwilliger algebra to control word traces and, if possible, certify
   the structural clean packet;
2. use quotient energy, polynomial incidence, or a lifted flag algebra when `Q3`-type collisions
   are the needed exceptional separator;
3. couple the two sorts only through an explicit reply-incidence bimodule, then prove separately
   that its nonempty fibre descends in game value.

This also gives a sharper SDP gate.  Positivity in either algebra is useful only if it excludes all
nonclean response fibres or forces a survivor in a separately proved P-preserving class.  Merely
placing both cubic quantities in a larger moment matrix would reproduce the classifier without
providing C80(b).

### A bounded generic response fibre inside the third word trace

Expanding the third trace separates repeated and distinct involution indices.  For `k` intruders,
write `f_i=#Fix(sigma_i)`.  Cyclic rotation and inversion preserve the fixed-point count of a
triple product, so

```text
tr(B^3)
  = (3k-2) sum_i f_i
    + 6 sum_(i<j<l) #Fix(sigma_i sigma_j sigma_l).             (6)
```

The score-9 states have three old intruders and a candidate reply, hence `k=4`.  Formula (6) is
verified by direct permutation composition on all 112 primitive candidates.  More importantly, it
extracts a bounded reply condition: require all four unordered triple products to be fixed-point
free.  One of these conditions concerns only the three old intruders; the other three constrain
the reply.

This condition is algebraic of bounded degree.  For intruders `x=(r,c)`, `y=(u,v)`, and candidate
`z=(a,b)`, the fixed-point discriminant of `M_x M_y M_z` is

```text
T_xy(z)
 = (cu-rv+(r-u)b-(c-v)a)^2
   - 4(rc-1)(uv-1)(ab-1).                                    (7)
```

Over an odd field the triple product has `0,1,2` conic fixed points according as `T` is nonsquare,
zero, or nonzero square.  Direct comparison of (7) with the permutation fixed sets succeeds for
every unordered triple in all 112 candidates.

Intersecting the three reply-dependent nonsquare conditions with C79's primitive opponent/reply
orbital gives the first bounded response fibre with a structural game effect:

```text
Y_0(S,x) = { z legal off-conic :
             ord(sigma_x sigma_z) in {q-1,q+1},
             chi(T_ab(z))=chi(T_ac(z))=chi(T_bc(z))=-1 }.
```

Here `a,b,c` are the three old intruders and the context gate is
`chi(T_ab(c))=-1`.  On the exact q=17 score-9 corpus, `Y_0` is a singleton clean/P reply in 24 of
28 transitions, empty in the four known exceptional transitions, and never impure.  This is the
generic `24+4` split in an explicit three-quadratic form suitable for a character/primitive-element
sieve.  The split is exactly the context gate: the prior triple product has zero conic fixed points
on all 24 generic transitions and two on all four exceptional transitions.  It is stronger than the
moment lookup because it gives both the actual relational fibre to count and the intrinsic split
of its exceptional base.

Both ingredients are load-bearing.  Dropping the primitive orbital condition leaves five
zero-triple replies in each of the 24 generic transitions, only one of them primitive, and the
five-point fibre is neither clean-pure nor P-pure.  The triple nonsquare conditions alone therefore
do not define a strategy.  Conversely the four primitive candidates without the triple conditions
contain three decoys.  C82's count must address their intersection, not either marginal packet.

This advances C80(a) only on the terminal score-9 stratum.  Clean means the reply empties the conic,
has defect xor zero, and leaves the certified Grundy-zero zone, so descent is immediate there.  No
claim is made that `Y_0` stays P-pure at earlier scores or for arbitrary q.  The next uniform gate
is now precise: count `Y_0` when the prior-triple context is nonsplit, classify the square-product
degeneracies of the three quadratics, and isolate the four exceptional relation fibres for C81 or a
separate bounded base lemma.

There is no intrinsic QR label on the two q=11 connection orbitals.  Writing their offsets requires
a generator of `C5`; inversion preserves the square class of their separation, but the roof Galois
change `g -> g^2` swaps square and nonsquare.  Thus QR coordinates are useful after a frozen
Coxeter calibration, while the cap theorem should retain only the generator-free facts: two
distinct nonempty orbitals and one connected 10-cycle.

The two calibrations also have an exact homological reading.  Once the forced edges are removed,
their symmetric difference is the generator of `H_1(C10,F_2)`.  The C448 advice bit is therefore
the orientation of a one-dimensional cycle-space class at this q=11 gate.  This realizes the
C465/C471 kernel/image analogy locally, but does not yet prove that the much larger C80 residual
has bounded homology or that its cycle quotient carries game value.

Thus either perfect matching is a fixed first-ply response rule landing in certified P
grandchildren.  This corrects the interpretation of the earlier certificate audit: the emitted
reply book was not a node-zero matching, but that was never a proof that no such matching exists.
The new pairing is only a first-response compression; it does not claim that the same involution or
matching controls deeper nodes.

This is the first causal game information extracted from the C447/C460 bridge.  It refutes the
strong cloud-packet cover but replaces it with a complete q=11 first-response correspondence.
The sharper gate is now to generalize the edge-quotient/Legendre response graph beyond this H3
knife edge.  Cubic information may still be required once several noncommuting matching packets interact: C79's `tr(B^3)` separates
the generic score-9 tie after `tr(B^2)` fails, and C77's contextual `Q3` separates the last q17
feature twin.  But the single-packet q=11 gate is already quadratic.  A q-independent nonempty-
fibre count would feed C82; structured failures remain C81's characteristic-5/7 branch.

The primary checker uses the committed `PrimeGridGame` legality/value recursion.  The independent
replay rebuilds the residual grid rule directly from row, column, and affine-collinearity tests and
uses a separate normal-play recursion.  Both reconstruct the two 15-point clouds, their five-point
intersection, all four pointed states, every opponent branch, and the `C5` orbit partition.

## Mystery ledger

- **Settled by the pointed cubic audit:** the shared word “cubic” does not mean that `tr(B^3)` and
  `Q3` are the same Terwilliger coordinate.  They live on different sorts and neither determines
  the other on the exact q=17 score-9 corpus.
- **Settled by the `ej` trace expansion:** the q17 moment-pair purity is not an opaque numerical
  coincidence.  Equation (6) reduces its cubic part to four triple-product fixed-point counts, and
  equation (7) makes the three reply-dependent conditions explicit quadratic discriminants.  Their
  intersection with the primitive orbital is the P-pure singleton fibre `Y_0` on 24/28 transitions;
  the other four are exactly the split prior-triple context, not an unlabelled exception set.
- **Still open — generic purity:** no q-independent theorem says that every survivor of `Y_0` is
  clean/P before the terminal score-9 layer.  The evidence gate is an exact structural implication
  from the three nonsquare triple products plus primitive order to a decreasing game class.
- **Still open — two-sorted coupling:** no canonical incidence bimodule has yet been shown to carry
  both conic-word traces and reply-pencil energy while preserving P/N recursion.  This is owned by
  C80's response-packet/descent theorem, not by an abstract SDP construction.
- **Still open — abundance, now precisely posed:** C82 can count the explicitly specified
  primitive-plus-three-nonsquare fibre `Y_0`; it must classify square-product degeneracies and beat
  the legal-point exclusions.  The four empty q17 relation fibres and characteristic-5/7
  degeneracies remain the exceptional branch rather than evidence for generic nonemptiness.

## Reproduction

```bash
python3 -m py_compile scripts/c80_drain_rate.py
python3 scripts/c80_drain_rate.py 11 13 --maxsize 6
python3 rust/scripts/c80_c447_cloud_packet.py --check
python3 rust/scripts/c80_c447_cloud_packet_replay.py
sha256sum -c notes/2026-07-22-c80-c447-cloud-packet.sha256
python3 rust/scripts/c80_pointed_cubic_bridge.py --check
python3 rust/scripts/c80_pointed_cubic_bridge_replay.py
sha256sum -c notes/2026-07-22-c80-pointed-cubic-bridge.sha256
```
