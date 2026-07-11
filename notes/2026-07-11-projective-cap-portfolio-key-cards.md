# Projective-cap portfolio: neutral key cards for cross-domain scouting

**Date:** 2026-07-11  
**Purpose:** common input deck for independent, non-anchored application sweeps  
**Rule:** a card records what is proved or computed, not where it ought to be applied.

## K1. Exact game reduction

The odd-plane cap game has a Lean-proved bidirectional reduction to a residual
grid game.  A counterexample is exactly a legal residual size-three state all
of whose legal size-four children are N.  Legality alone never proves game
value.  The uniform odd-order theorem remains open.

## K2. Fan-to-bucket incidence

On-conic completions form an exact incidence matrix `M_q` between five-point
frames and six-point PGL buckets.  `(ON)` is positivity of `M_q f_q`.  At
depleted orders, rare P buckets cover every row despite low raw density; at
q=25 the first 13 buckets were all P and the proved partial incidence gives
`min-witness(25)>=4`.  P labels are game values and cannot be used as geometric
definitions.

## K3. Involution, defect and voltage structure

Each off-conic intruder induces an involution matching on the conic parameter
line.  One or two intruders give paths plus even cycles and Dawson-path
defects.  Static coordinates fail unless they retain a Z2 cycle-voltage datum.
Three or more matchings are dynamically coupled; no disjunctive-sum theorem is
available.

## K4. Charge and potential evidence

The charge

`Psi = reservoir_slack + 6 defect_components - 4 intruders - 2[conic_xor=0]`

decreases along all tested oracle-selected obligations through q=19 and a q=23
trajectory.  It is not a proved value-blind invariant.  Potential-based RL
use is logically separate from proof use.

## K5. Direction reservoir and additive support

After a homology is sent to infinity it becomes point reflection; undetermined
directions form the reservoir.  On a parabola, a chord through parameters
`t,u` has direction `t+u`, so conic support growth is sumset growth.  Small
reservoir support corresponds to small doubling/Freiman structure.  In the
d=4 defect phase the axis reservoir is empty.

## K6. Completion core and deletion distance

For a cap/configuration `K`, the completion core is the intersection of all
complete extensions.  Completion distance is the minimum deletion needed to
admit a different completion.  For an external point, insertion distance is a
transversal number of its minimal representation supports.  This is a robust
refinement of classical unique completion, not a new closure operator by
itself.

## K7. Relative multiple saturation

For any complete cap `C` in a finite partial linear space and `S subset C`,
deletion of fewer than `h` points preserves unique completion to `C` iff every
point outside `C` lies on at least `h` secants of `S`.  This is relative
multiple saturation with the holes `C\S` exempt.  The definition is close to
multiple-covering syndrome theory; novelty requires bounds or equality cases.

## K8. NRC/GRS robust insertion

For a degree-d normal rational curve and `x=e_(d-1)`, the deletion cost is

`delta_x = q - Z_d(F_q)`,

where `Z_d` is the largest set with no d distinct zero-sum elements.  The
underlying RS deep-hole/MDS-extension and zero-sum criterion are prior art;
the robust transversal spectrum is the possible new layer.

## K9. Baer/Galois orbit extension

For Frobenius-invariant arcs over `F_(s^2)`, fixed secants form a mixed cover
of the Baer subplane and free extensions occur in conjugate pairs.  Every
invariant eight-arc pair-extends for every prime power `s>=7`.  If no free pair
extends and `k<s^2+1`, then

`k >= 1 + ceil(sqrt(2s(s-1)))`

in every characteristic.  The prime-degree “quadratic anomaly” is elementary
orbit-stabilizer infrastructure.

## K10. Frobenius-marked subspace arrangements

Fixed-field legal extensions are complements of subspace arrangements whose
characteristic polynomial gives exact counts.  For three conjugate pairs the
count collapses to a marked-Baer statistic `(epsilon,h)`.  Unmarked full-PGL
type fails at s=7; the Frobenius pairing is essential.  A forbidden-normal
rank enumerator alone is only a rank-weight histogram until an explicit family
and intersection data are computed.

## K11. Continuation graph and M_(0,5) reduct

For a four-point projective frame, legal continuations are

`Omega={(x,y):x,y notin {0,1}, x!=y}`

with four coordinates `x,y,x/y,(x-1)/(y-1)`.  This is `M_(0,5)(F_q)` with one
of five forgetful maps omitted.  For q>=13 every arbitrary automorphism of the
uncoloured four-map fibre-coincidence graph is S4 plus Frobenius.  This is
finite reduct rigidity, not implied by the algebraic S5 theorem for full
`M_(0,5)`.

## K12. Continuation-complex faithfulness

The full continuation complex has minimal nonfaces consisting exactly of
forbidden pairs and external collinear triples.  Under an explicit
profile-sensitive threshold using the actual secant-arrangement parameter
`a_K`, it reconstructs the ambient plane, secant arrangement and selected
arc functorially.  Classical long-line embedding supplies part of the
completion step; intrinsic extraction and faithful reconstruction carry the
novelty.

## K13. Field reduction and rank-metric dictionary

For the graph `X_f` of an F_q-linear map in a Desarguesian spread, insertion
cost equals the direction-set/linear-set size

`|{f(x)/x:x!=0}| = #{a:rank(f-aI)<=n-1}`.

The dictionary is classical-facing.  Possible new objects are the full
insertion/list distribution, equality/switching classes, or replacement of
the scalar spread set by a nontrivial MRD spread set.

## K14. Complete repair-hypergraph profile

For a linear code coordinate, minimum repair supports form a hypergraph.
Disjoint availability is its matching number `nu`; exact arbitrary helper
failure tolerance is `tau-1`; fractional matching gives service capacity.
These notions are established separately in storage literature, but their
exact joint profile can differ sharply.  Counts of repair alternatives do not
determine `tau`, and `nu` need not determine it.

## K15. Characteristic-matched Roth--Lempel family

For odd prime p and q=p^h, h>=2, finite degree-p NRC columns plus `e_(p-1)`
give an optimal `[q+1,p+1,q-p]_q` NMDS LRC.  Its minimum circuits are zero-sum
p-subsets plus the special coordinate.  The code/circuits are prior art.  New-
looking calculations include exact integral/fractional availability at repair
radius p+1 and the distinguished coordinate's asymptotically maximal
`tau/nu -> p`.

## K16. Twisted-cubic--axis repair family

For q=3^h>=9, the q finite twisted-cubic points together with the q+1-point
characteristic-three axis generate a `[2q+1,4,q-1]_q` code.  Every coordinate
has locality at most three and satisfies `tau>nu`.  At q=9 the exact minimum
ratio is `tau/nu=7/4`.  Axis geometry and ordinary parameters are classical-
facing; the complete all-symbol repair separation appears new but still needs
a specialist citation-chain audit.

## K17. Bounded-repair transfer under concatenation

If an inner code has dual distance r+1 and an outer code has dual distance at
least r+2, every concatenated dual word of weight at most r+1 is confined to
one inner block.  Hence the complete repair hypergraph of radius r is preserved
exactly.  With asymptotically good outer codes this lifts any finite seed to
fixed-alphabet positive-rate, positive-distance families.  Concatenation and
dual decomposition are classical; the repair-hypergraph preservation
corollary is the candidate contribution.

## K18. Proof-carrying finite computation

The project combines Lean-proved reductions, generated certificates,
independent rules-only validators, orbit transport, exact tablebases and
predeclared falsification gates.  It distinguishes complete Grundy data,
early-break P/N data and unknown states.  This is a reusable methodology and
software architecture, not a mathematical theorem.

## K19. Symmetry, canonicalization and orbit compression

Projective, semilinear and Frobenius actions reduce large configuration spaces
to orbit representatives, but fixed-q transport never implies cross-q
transport.  Several rounds found that unmarked orbit types can lose essential
pairing/voltage data.  A correct canonical representation must retain the
minimal marked structure proved necessary.

## K20. Negative results as design constraints

Static mirrors, q-blind finite automata, clean conic/zone sums, bounded steering,
simple feature dictionaries, unmarked PGL buckets and several deterministic
selectors are exactly refuted.  Any cross-domain use must not silently revive
the missing state variables exposed by those counterexamples.
