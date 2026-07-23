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

## (a) Abundance profile — RAW `Y_0` EXTENSION CLOSED NEGATIVE

Per (root R, opponent move x) at nondepleted q (13/19): winning-reply fraction, and whether
the winning set contains an entire bounded-condition packet (all D-generic on-conic replies
minus an explicit bad-fiber list). Target theorem shape: at nondepleted q **every** packet
member wins — existence by counting, no selector.  The terminal q17 fibre `Y_0` defined below
does not extend unchanged to earlier q13/q17 transitions; see the full bounded census below.
Thus C82 remains gated on a refined packet rather than counting raw `Y_0`.

## (b) Descent / class preservation — OPEN; RAW `Y_0` IS INSUFFICIENT

Which lexicographic residual measure some winning reply always strictly decreases
(candidates: conic defect type, `|live conic|`, edge-density budget `Σ_x max(0,(q+1−f_x)/2−d)`,
zone complexity); and whether some winning reply re-enters the balanced/normal-form class. The
exact drain makes `|live conic|` a validated component of any such measure; the missing step
is upgrading a greedy drain move to a minimax potential.  The full `Y_0` census also shows that
strict live-conic descent is not automatic even when that fibre contains a P reply.

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

**Orbit-representative response lemma.**  Let a finite group `H` act by automorphisms of a finite
normal-play game and fix a position `S`.  Choose one representative `x_i` of every `H`-orbit of
legal moves from `S`.  If for every `i` there is a legal reply `y_i` from `S+x_i` such that
`S+x_i+y_i` is P, then `S` is P.  Indeed, write an arbitrary legal move as `x=h x_i`.  Game
automorphism gives the legal reply `h y_i`, and transports the P grandchild
`S+x_i+y_i` to `S+x+h y_i`.  Hence every child of `S` has a P child and is N, so `S` is P.  No
choice of transporter has to be independent of `h`, because the assertion is existential.

The induction/descent form replaces the premise “the grandchild is P” by membership in an
`H`-stable response class of strictly smaller well-founded measure, whose P-value is supplied by
the induction hypothesis.  This isolates C80(b)'s remaining obligation exactly: the drain lemma
proves strict decrease when the accepted move is conic, while an accepted off-conic response such
as `Y_0` still needs a separate proof that it enters the smaller class.  Fibre nonemptiness alone
does not discharge that step.

At this q=11 gate the 22 opponent moves form six `C5` orbits.  Their quotient winning graph has a
unique minimum three-relation cover

```text
0[1]--infinity[1],  1[5]--9[5],  8[5]--infinity[5].
```

The last relation has two edge-orbital lifts, producing the two perfect matchings.  Therefore the
two-match calibration torsor is extra certificate structure: the P proof itself consists of only
three undirected orbit-relation checks (equivalently six directed opponent-orbit checks, paired by
the symmetry of the two-move response relation).  This is an exact instance of the lemma above,
not yet a uniform source of the required stabilizer or response class.

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

### Full q13/q17 `Y_0` response-fibre census

The score-9 result above suggested the strongest cheap generalization: keep exactly the same
primitive opponent/reply orbital and require all four intruder triple products to be fixed-point
free, but apply it to every three-intruder opponent transition from the recorded C20 P reply
states.  `scripts/c80_response_fibre_census.py` performs that exact census.  It deduplicates the
recorded states through the existing C31 loader, then checks every legal off-conic opponent move
whose child has exactly three intruders.  For each legal off-conic reply it tests product order
`q-1` or `q+1`, evaluates the four quadratic discriminants (7), and independently checks every
surviving discriminant tuple by direct composition of the four conic permutations.

The bounded result is negative for the unchanged generic packet:

| q | unique P reply states | three-intruder transitions | prior triple nonsplit | `Y_0` nonempty | `Y_0` has P | value-impure |
|---:|---:|---:|---:|---:|---:|---:|
| 13 | 485 | 2,225 | 1,543 | 533 | 533 | 0 |
| 17 | 2,662 | 59,153 | 31,890 | 13,451 | 5,475 | 1,515 |

At q13 all 620 surviving packet members are P and satisfy `clean_empty`, but the fibre is empty on
1,010 of the 1,543 nonsplit-prior transitions.  At q17 the failure is stronger.  Among the 13,451
nonempty fibres, 7,976 are all N, 1,515 are value-impure, 1,973 are all P but not all
`clean_empty`, and 1,987 are all `clean_empty` P.  In member counts, only 6,408 of 17,954 q17
survivors are P.  Hence the score-9 `24+4` theorem is a terminal-context purity statement, not the
restriction of a global primitive-plus-three-quadratics response theorem.

Nor does raw live-conic descent repair the relation.  A P member strictly decreases live-conic
size from the opponent child on only 74 of the 533 q13 P-covered transitions and 3,173 of the
5,475 q17 P-covered transitions (from the pre-opponent parent: 161 and 5,010 respectively).
These counts do not say that descent is impossible under a refined measure; they say precisely
that `Y_0` plus `|L|` cannot be the missing uniform induction rule.

The `ej` closeout stratified the same exact profiles by parent live-conic size.  This does not
recover a hidden threshold.  At q17, nonempty all-N or impure fibres occur throughout the observed
range `|L|=0,...,7`; even `|L|=0` has 486 nonempty fibres, only 306 with a P member, including 76
impure fibres.  At q13 the fibre remains pure where present for `|L|=0,1,2` and is absent on all 48
transitions with `|L|=3`.  Thus the first drain coordinate cannot itself be the missing
state-class guard: q17 impurity persists after the conic reservoir is already empty.

Trust boundary: the P/N labels use the committed `PrimeGridGame` recursion and the same recorded
C20 state source as the preceding repair work.  There is no second full P/N engine for this new
census.  The algebraic membership test does have an independent internal replay on every survivor:
18,574 direct triple-permutation checks agree with the closed discriminant formula.  The earlier
score-9 `24+4` slice is also independently covered by the committed pointed-cubic replay.  For the
new graph-exact guard, the separate line-coordinate replay reconstructs the geometry and conflict
Grundy values independently and checks their agreement with the full recursion on every guarded
member.  The claim here is only the stated finite census, with the exact three-intruder and field
restrictions; it is not a theorem for q19, extension fields, or arbitrary game states.

Evidence sizes are 12,433 bytes for the census script, 6,754 bytes for the independent guard
replay, 227,240 bytes for the canonical JSON, and 654,965 bytes for the load-bearing C20 gzip input.
The adjacent checksum manifest records the bundle hashes; the JSON also embeds the input hash and
byte count.

The proof-search consequence is sharp.  Do not ask C82 to count raw `Y_0`.  A viable successor
packet must add a state-class/descent guard that excludes the q17 all-N and impure fibres, while
also adding coverage for the q13 nonsplit-prior empty fibres.  Alternatively, retain `Y_0` only as
the terminal base relation and prove a different bulk descent into its score-9 domain.

### Exact residual-capacity guard: a P-pure but sparse refinement

The residual-capacity decomposition supplies a proof-bearing state guard that the earlier
`clean_empty` feature lacked.  For a position `S`, call the residual **graph-exact** when every
projective line containing no selected point has at most two currently legal points.  Lines of
load at least two contribute no legal point, load-one lines give the pair-conflict graph, and a
load-zero line can never create a future triple because it has at most two legal points and the
legal locus only shrinks.  Therefore, when the conic is empty, every continuation of `S` is exactly
Node--Kayles on the load-one conflict graph.  In particular, conflict-graph Grundy value zero is a
genuine P certificate, not a value-correlated feature.

Define `Y_NK0` to be the members of `Y_0` whose grandchildren have empty conic, are graph-exact,
and have conflict-graph Grundy value zero.  The extended exact census gives:

| q | `Y_0` members | graph-exact empty members | `Y_NK0` members | transitions covered by `Y_NK0` |
|---:|---:|---:|---:|---:|
| 13 | 620 | 620 | 620 | 533 |
| 17 | 17,954 | 8,770 | 3,048 | 2,822 |

All 8,770 q17 graph-exact empty members agree with the graph theorem and the full game recursion:
3,048 have Grundy zero and are P, while 5,722 have nonzero Grundy and are N.  Thus `Y_NK0` removes
every observed all-N and impure member by a structural certificate.  It explains all q13 survivor
purity and certifies 2,822 of the 5,475 q17 transitions on which raw `Y_0` has some P member.

This does **not** close C80(a): `Y_NK0` still covers only 2,822 of 59,153 q17 three-intruder
transitions, and raw `Y_0` is absent on most branches.  It is a valid P-preserving terminal packet,
not yet a bulk response cover; C82 remains gated until a descent theorem reaches it or a companion
packet covers the missing branches.

The guard also diagnoses the former `clean_empty` false positives exactly.  At q17, 108 clean
members fail graph-exactness because a residual capacity-two line still contains at least three
legal points: 104 are P and four are N.  Their maximum such line sizes are `3` for all four N and
72 P members, and `4` for the remaining 32 P members.  Hence the line-size threshold itself does
not classify the unresolved slack-two residue; it marks precisely where genuine triple-avoidance
semantics resumes.

`scripts/c80_node_kayles_guard_replay.py` independently reconstructs all projective lines from
normalized line coordinates, recomputes residual loads, the conflict graph, and its Grundy value,
and checks the exact counts above.  It also compares the graph result with the full recursive game
value on every graph-exact empty member.  This is an independent geometry/graph replay, not a
second implementation of the raw `Y_0` orbital membership or the full earlier census.

## Mystery ledger

- **Settled by the pointed cubic audit:** the shared word “cubic” does not mean that `tr(B^3)` and
  `Q3` are the same Terwilliger coordinate.  They live on different sorts and neither determines
  the other on the exact q=17 score-9 corpus.
- **Settled by the `ej` trace expansion:** the q17 moment-pair purity is not an opaque numerical
  coincidence.  Equation (6) reduces its cubic part to four triple-product fixed-point counts, and
  equation (7) makes the three reply-dependent conditions explicit quadratic discriminants.  Their
  intersection with the primitive orbital is the P-pure singleton fibre `Y_0` on 24/28 transitions;
  the other four are exactly the split prior-triple context, not an unlabelled exception set.
- **Settled negative — raw generic purity:** the unchanged `Y_0` relation is all-N on 7,976 and
  value-impure on 1,515 of the exact q17 three-intruder transitions.  At q13 its survivors are
  clean/P, but the fibre is absent on 1,010 nonsplit-prior transitions.  The score-9 purity cannot
  be promoted without an additional state-class/descent guard.
- **Settled by `ej` — no live-size guard:** q17 all-N/impure fibres occur at every observed parent
  live-conic size from 0 through 7, including 76 impure fibres already at `|L|=0`.  The drain
  coordinate orders conic play but does not classify the off-conic response fibre.
- **Settled — exact P-preserving guard:** empty conic plus graph-exact residual capacity and
  conflict-graph Grundy zero gives the refined packet `Y_NK0`.  It certifies all 620 q13 survivors
  and 3,048 q17 members with no P/N impurity, covering 533 and 2,822 transitions respectively.
- **Settled by `ej` — why `clean_empty` was unsafe:** all 108 q17 clean members rejected by the
  exact guard retain a load-zero line with three or four legal points.  The four N cases have
  maximum three, but so do 72 P cases; capacity-two survival is the semantic gap, not a scalar
  classifier.
- **Still open — sparse guarded coverage:** `Y_NK0` is proof-bearing but covers only 2,822 of
  59,153 q17 transitions.  A bulk descent into this class or a companion guarded packet is still
  required before C82 can count a uniform response relation.
- **Still open — two-sorted coupling:** no canonical incidence bimodule has yet been shown to carry
  both conic-word traces and reply-pencil energy while preserving P/N recursion.  This is owned by
  C80's response-packet/descent theorem, not by an abstract SDP construction.
- **Still open — abundance, re-gated:** C82 must not count raw `Y_0`: even over nonsplit prior
  triples it is frequently empty, and at q17 nonemptiness does not imply P-purity.  C80 must first
  supply either a refined P-preserving packet or a bulk descent theorem whose terminal target is
  the already certified score-9 `Y_0` relation.  Characteristic-5/7 degeneracies remain C81's
  branch only after that game-semantic guard exists.

## 2026-07-22 — C434 cross-lane transfer probes allocated (C495–C497)

The crowns C434 double-coset information-lattice theorem
(`notes/2026-07-22-c434-double-coset-information-lattice.md`) supplies three candidate routes
into this report's still-open ledger items; assessment and provenance in
`notes/2026-07-22-c434-c80-cross-lane-transfers.md`.

- **C495** (→ still-open coverage, q=11 side): falsifier-first identification of the C447/C460
  cloud packet's `C5`-orbit structure `1,1,5,5,5,5` with C434's `D10`-class `K`-orbit strata on
  its 22-point two-sheet space, `u = XZ/Y²` square class matching the sheet sign.
- **C496** (→ still-open two-sorted coupling): the bi-Hecke bimodule `e_K F[G] e_H ≅ F[K\G/H]`
  as the canonical incidence-bimodule candidate, expected set-faithful with a rank-dropping
  linear shadow rather than linearly faithful.
- **C497** (→ still-open sparse guarded coverage): stratum-constancy test of
  `Y_NK0`-membership/P-purity over double-coset labels of (prior-triple stabilizer, reply) on
  the frozen q17 census; constancy yields per-representative bulk descent.

Caveats recorded in the transfer note: the C434 Borel/Bruhat structure exists only at
q ∈ {7,11} (no subgroup of order `(q²−1)/2` at q=13/17/19), and C434 contributes nothing to the
(b) descent-measure gap.

**Fixed run order: C495 → C497 → C496.** C495 is the gate (cheapest; both objects frozen at 22
points) — it decides whether C434's double-coset language matches C80's frozen packet before the
larger q17 stratification. C497 (bulk-descent crown) runs only after C495's verdict; C496 is last.

**C495 [REPORTED 2026-07-22 — FALSIFIER NO]** (`notes/2026-07-22-c495-cloud-packet-d10-identification.md`).
The q=11 cloud packet is *not* `G`-equivariantly the C434 `D10` two-sheet coset space. Three layers:
(1) the single-state 22-move packet has full setwise stabilizer exactly `C5` in `PGL_2(11)` — no
internal `D10` anywhere in the conic group — while C434's `Ω` is a genuine internal-`D10` orbit;
(2) C80's nonsquare cap-frame coset is the inter-state endpoint swap (state0≠state1, overlap 16), so
C80 carries two 22-objects paired externally, vs C434's one 22-object internally 11+11-sheeted;
(3) `u`'s square class splits the four 5-orbits 2–1–1, not the sheet's 2–2, and is not the `D′`
analogue (four distinct values vs three). Partial match: isomorphic as `C5`-sets only. **Bearing on
the ledger:** this does *not* close the q=11 coverage side — it removes the double-coset transport as
the mechanism and hands C497 an independent (lower-prior) stratification test; the still-open
sparse-coverage and two-sorted-coupling items are unchanged, with C496 now supported (value-carrying
packet vs value-blind `D′`) in seeking a set-faithful/rank-dropping coupling.

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
python3 rust/scripts/c80_response_fibre_census.py --check
python3 rust/scripts/c80_node_kayles_guard_replay.py
sha256sum -c notes/2026-07-22-c80-response-fibre-census.sha256
```
