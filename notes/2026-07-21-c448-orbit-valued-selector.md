# C448 — orbit-valued selectors and the chirality obstruction

**Lane:** `crowns` (read-only `cap` inputs)

**Date:** 2026-07-21

**Verdict:** `THEOREM — A NONTRIVIAL STABILIZER C2-ACTION FORBIDS AN EQUIVARIANT POINT SELECTOR; C460 CLOUDS AND C447 SHARED-EDGE PAIRS ARE EXACT ORBIT-VALUED REPAIRS; THE Q=5 COPYCAT IS THE NONSPLIT MARKED-RESPONSE CONTROL`

## Selector lemma

Let `G` act on sets `Y` and `X`, and let `p : Y -> X` be equivariant.  Suppose that for some
`x in X` the fibre `p^{-1}(x)={y_+,y_-}` is a two-set on which the stabilizer `G_x` acts through a
surjective character

```text
chi_x : G_x -> C2.
```

Then `p` has no `G`-equivariant section over the orbit `G.x`.  Indeed, if `s : G.x -> Y` were a
section, equivariance at
`x` would force `s(x)` to be fixed by every element of `G_x`; an element with
`chi_x(g)=-1` swaps `y_+` and `y_-`, so neither point is fixed.

The obstruction disappears after replacing a point by its stabilizer orbit.  On `G.x`, the
assignment

```text
x |-> p^{-1}(x)={y_+,y_-}
```

is a canonical equivariant map into unordered two-sets.  More generally, a distinguished
`G_x`-orbit in a fibre is an equivariant orbit-valued output even when it has no equivariantly
distinguished member.  If a downstream operation genuinely requires one member of a two-set, this
gives an exact local advice lower bound of one bit; one supplied orientation bit also suffices.
This is a statement about equivariance, not about the game value of either member.

## Exact H3 realizations

### C460: clouds recover precisely the unordered sheets

For each of the 22 frozen H3 matchings `M`, C460 constructs its 15-point Frégier cloud `C(M)`.
The cloud stabilizer is exactly the matching's `A5` stabilizer, so `M |-> C(M)` is a faithful
orbit-valued replacement for the false concurrent-point selector.  Joining two clouds when they
meet in five points gives a connected 6-regular bipartite graph.  Its unique unordered `11+11`
bipartition is exactly the two `PSL_2(11)` sheets.

Thus the geometry canonically recovers the sheet *pair* and the cloud attached to every matching,
but it does not name a sheet.  This is the global positive realization of the lemma: retain the
whole orbit, and the chirality swap becomes an automorphism rather than an obstruction.

### C447: a cap P edge selects a cross-sheet matching pair

At each q=11 knife-edge cap class, the frame stabilizer `D10` acts on the size-two P orbit through
its determinant character.  C447 proves the equivariant bijection

```text
{66 conic edges}  <->  {66 cross-sheet matching pairs sharing one edge}.
```

The stabilizer of either object is the same `D20`.  Inside it, the cap frame's determinant-square
`C5` fixes both edge endpoints and both matchings, while every determinant-nonsquare element swaps
the endpoints and simultaneously swaps the matchings.  Therefore the cap's smallest P orbit
canonically selects one unordered cross-sheet matching pair.  By the selector lemma it selects
neither an endpoint nor a matching equivariantly.  Choosing either requires the same one local
advice bit.

This is the exact cap-facing bridge.  It does **not** revive the rejected comparison with C406's
base/J-mate singleton matchings: C447 proves that comparison has zero symmetry-compatible maps,
and unframed coordinates can force either answer.

## What this does and does not explain on the cap side

- **C75.** C75 proves only that the emitted feature map collapses some winning and losing replies;
  no function of that particular feature vector can be a winning pointwise selector.  The present
  lemma is a different, representation-theoretic obstruction: even complete invariant data cannot
  orient a two-fibre when its stabilizer swaps the members.  Orbit-valued outputs offer a legal way
  to retain candidates, but they do not separate C75's P/N feature twins and do not prove a reply
  winning.
- **L1 at q=11.** In knife-edge classes 4 and 7, L1's chosen on-conic point lies in the size-five N
  orbit.  The smallest-orbit anchor instead returns the size-two P orbit.  C447 upgrades that
  correct unordered P edge to a canonical unordered cross-sheet pair.  The theorem explains why
  no invariant refinement can canonically orient this pair; it does not turn L1's N choice into a
  P choice or derive P-ness from symmetry.
- **q=5 copycat.** For the standard frame in `PG(2,5)`, C187 certifies that the entire uncovered
  locus is the six-point conic
  `X^2+Y^2+Z^2+XY+XZ+YZ=0`.  The adjacent C448 certificate checks all fifteen pairs: the conflict
  graph is `K6` minus a perfect matching.  Its three nonedges define the canonical fixed-point-free
  antipodal involution.  Once the opponent marks `v`, its antipode is the unique legal reply and
  the pair is terminal, proving the seeded position P by copycat.  There is no contradiction with
  the selector lemma: the input move marks one endpoint, so `v |-> antipode(v)` is an equivariant
  response map, not an invariant choice from an unmarked pair.  This is the nonsplit one-sheet
  control, with no chirality bit to orient.

## 2026-07-22 `ej` addendum — exact substitutes for a forbidden selector

The selector obstruction forbids only an unmarked deterministic point section.  It leaves four
precise ways to meet the operational objective without reviving the false claim.

1. **Descend a symmetric consumer.**  If a downstream map has the same value on `y_+` and `y_-`,
   it factors uniquely through the unordered fibre.  No member need be chosen.  For C447 this is
   the correct route to any future game-value explanation, but no such value factorization is
   currently proved.
2. **Lift to the oriented cover.**  Supplying which member is positive makes the chosen-member map
   tautological.  A nontrivial two-fibre needs one bit and one bit suffices.  Over C447's cap-frame
   `D10` family, the endpoint and matching fibres have the same swap character, so one calibration
   bit selects one of their two equivariant identifications across the family.
3. **Use an equivariant random selector.**  Assign probability `1/2` to each fibre member.  This is
   an equivariant Markov kernel.  It is also the unique stabilizer-invariant probability measure on
   a transitively swapped two-fibre, since invariance forces the two weights equal.  It gives a
   point in distribution with zero advice, not a deterministic section.
4. **Use marked response rather than unmarked choice.**  Once an input marks one endpoint, an
   equivariant partner map may exist.  The certified q=5 antipode is exactly this pattern: the
   opponent marks `v`, and `antipode(v)` is the unique legal terminal reply.

For the two certified q=11 knife-edge classes there is an additional operational shortcut: both
members of the selected P edge are P.  Any deterministic coordinate tie-break therefore returns a
winning move.  This meets the bounded play objective while intentionally giving up coordinate-free
naturality.

The one-bit cap calibration must not be overstated.  It works on the cap-frame `D10` orbit because
the endpoint and matching swap characters agree there.  They differ on the full shared-edge
`D20`: a nonsquare pointwise-torus element fixes the edge endpoints but exchanges the two
`PSL_2(11)` sheets and hence the matchings.  Therefore there is no global
`PGL_2(11)`-equivariant ordered-edge/ordered-matching-pair identification across all 66 edges.  A
sheet mark is the type-correct extra datum.

C449 supplies the adjacent split-torus control but not the missing sheet mark: its q=11 Coxeter
square generates the square `C5`, while the full `C10` centralizer still contains the nonsquare
sheet exchange.  C436 cannot repair the obstruction in either outcome of its queued group-order
test; a larger ambient symmetry cannot create a section forbidden for its `PGL_2(11)` subgroup.

## Mystery ledger

- **Settled by this `ej` pass:** symmetric consumers, an oriented lift, uniform randomized choice,
  and marked response are the four exact substitutes; only the oriented lift produces a
  deterministic named member, and it exposes the required extra bit rather than hiding it.
- **Settled scope correction:** one calibration bit coherently aligns the two `D10` cap torsors,
  but no such alignment exists over the full 66-edge `D20` family without a sheet mark.
- **Open — game-value descent:** no theorem currently shows that the unordered C447 H3 pair alone
  determines cap P/N value.  This is the C296 reconstruction-to-value gate, not a missing selector
  calculation.
- **Open — C75 feature twins:** orbit-valued retention does not separate the recorded P/N twins.
  The evidence gap remains a stronger value-relevant invariant or a proof that no such invariant
  exists on the chosen object class.
- **No genuine q=5 mystery remains:** the exhaustive `K6`-minus-matching certificate gives the
  unique marked response and terminality directly.

## Scope and boundary

The selector lemma is elementary and no novelty claim is made.  The two positive H3 geometries are
exactly the certified C460 cloud construction and C447 shared-edge bijection; no broader cap-game
strategy, value theorem, singleton identification, manuscript statement, or all-field selector is
claimed.  The q=5 check closes only the finite premise needed for this comparison; it does not edit
or disposition the cap lane's C189 task.

The general lemma is proved above without computation.  The q=5 support check is computational only
in the transparent finite sense: it enumerates the 31 projective points and all 15 pairs, with every
point, conflict edge, nonedge, and antipode exposed in canonical JSON.  No separate replay is
provided because there is no compressed or probabilistic step to cross-check; the displayed
two-line section proof independently establishes the game conclusion once the exhaustive pair
ledger is read.

## Reproducibility

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-21-c448-orbit-valued-selector.py --check
sha256sum -c notes/2026-07-21-c448-orbit-valued-selector.sha256
```

Intentional regeneration is the same script with `--write`.  The manifest records SHA-256 hashes
for this report, the checker, and the canonical JSON.  The trusted boundary is exact arithmetic in
`F_5`, canonical projective normalization, determinant collinearity, and C187's independently
certified equality between the frame's uncovered locus and the displayed nonsingular conic.
