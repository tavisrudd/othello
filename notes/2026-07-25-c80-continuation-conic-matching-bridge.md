# C80 — continuation-complex to conic-matching bridge

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.

## Verdict

The direct bridge from q17 continuation-complex obligations to the Clebsch
secant-product matching quotient is impossible in all three natural domains.

1. **Selected conic marks:** every legal intruder induces the empty matching
   on them.
2. **Live conic points:** only `3/32` q17 legal moves induce even one live
   matching edge.
3. **The full rational conic:** only external intruders induce perfect
   matchings, covering `9/32` q17 legal moves, and the associated quotient
   degree is `(q-3)/2`, unbounded in `q`.

The obstruction on selected marks is general. If a legal intruder `x`
paired two distinct selected conic points `a,b`, then `x` would lie on the
selected secant `ab`, contradicting legality. Hence the most attractive
bounded marked-set input to

```text
(P_M-P_M0)/Q
```

is identically empty before any game-value question arises.

The q17 terminal core is also mixed across full-conic involution types:
only two of its ten vertices are external/perfect-matching intruders; eight
are split intruders with two conic fixed points. The 22 isolates contain
seven external intruders, twelve split intruders, and three conic moves.
One perfect-matching carrier cannot represent either side.

The Clebsch quotient remains a useful design pattern for anti-packing, but
it does not accept the C80 obligations directly. The live successor is the
full continuation-complex coverage law itself, not another attempt to force
all legal moves into conic matchings.

## General selected-mark obstruction

Let `A` be the selected conic subset of a cap, and let `x` be an off-conic
legal move. Projection from `x` induces an involution `σ_x` on the conic.
Suppose distinct `a,b∈A` satisfy

```text
σ_x(a)=b.
```

By definition of the projection involution, `a,x,b` are collinear. Since
`a,b` are already selected, `x` lies on their secant and is illegal. Thus:

```text
x legal  =>  σ_x has no two-cycle contained in A.
```

This proof is field-uniform and independent of q17. The certificate checks
all 128 q17 and 51 q19 legal moves in scope and finds zero selected-mark
matching edges.

Fixed selected points do not rescue the Clebsch construction. A fixed point
of `σ_x` is a tangent contact, not one endpoint of a perfect-matching edge.
The Paper-II quotient compares products of secants for perfect matchings of
an even marked set; an empty edge set plus tangent fixed points is a
different object.

## Finite bridge census

At each q17 repair target:

| move type | terminal core | terminal isolates |
| --- | ---: | ---: |
| conic move | 0 | 3 |
| external intruder, 0 conic fixed points | 2 | 7 |
| split intruder, 2 conic fixed points | 8 | 12 |
| total | 10 | 22 |

Therefore the full-conic perfect-matching domain contains only `2/10` core
vertices and `7/22` isolates. It neither describes the ramified core nor the
obligation locus.

The three live conic points give an even smaller carrier:

```text
3/32 moves induce a live two-cycle
= 1 core + 2 isolates.
```

The other 29 moves have no matching edge on the live conic. Enriching the
live restriction with fixed-point counts is still value/status mixed, as
recorded by the complete move-signature table in the certificate.

For the q19 repair control:

```text
selected-mark matching nonempty: 0/51;
full-conic perfect matching:     20/51;
live-conic matching nonempty:    16/51.
```

All 51 vertices are isolates of the terminal-reply graph at that stage, so
none of these domains supplies the later good q19 terminal shell either.

## Anti-packing failure on the full conic

An external intruder induces a fixed-point-free involution, hence a perfect
matching of the `q+1` rational conic points. Applying the Paper-II
construction to that full matching uses

```text
2m=q+1,
degree((P_M-P_M0)/Q)=m-2=(q-3)/2.
```

The degree is seven at q17 and eight at q19, but grows linearly with q.
Consequently the full-conic quotient violates C80's bounded-format gate even
on the external-intruder subdomain. It encodes `Θ(q)` pairing information in
an unbounded-degree form, exactly the packing behavior the proof-object rules
forbid.

Split intruders are outside even that domain: their conic involutions have
two fixed points and only a matching on the remaining `q-1` points. Conic
moves have no projection involution. A stratified full-conic construction
could represent these cases only by adding further unbounded-degree carrier
types; it would not repair the uniform gate.

## What survives from the snapshot review

The full continuation-complex description remains exact and useful. Its
maximal two-element faces are precisely the terminal reply pairs. In tangent
tuple language, a legal pair `x,y` is terminal exactly when every other
legal `z` is killed by:

1. a tangent-coordinate agreement with `x` or `y`; or
2. the collinear-triple obstruction on the line `xy`.

This is a bounded-arity incidence statement even though the legal locus
grows. It applies uniformly to conic moves, external intruders, and split
intruders, unlike the matching quotient.

The highest-EV next target is therefore a direct algebraic **coverage
certificate** for maximal two-faces:

```text
pair/tangent coverage
+ triple-line coverage
-> a rank-carrying obligation locus.
```

The Clebsch Plücker quotient may re-enter only for a bounded auxiliary conic
mark set on which nontrivial matching edges actually occur. The selected
marks and the live conic both fail that entry gate, while the full conic
fails bounded degree.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_continuation_conic_matching_bridge.py
python3 rust/scripts/c80_continuation_conic_matching_bridge.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_continuation_conic_matching_bridge.py` | 11,151 | `1a0990da6359597994874b1f72d2432b53bf6c2030f5e116632790d297ad727f` |
| `notes/2026-07-25-c80-continuation-conic-matching-bridge.json` | 74,275 | `c390f2169e334468a4cf6f4f59085ff1ff68a94db790fdec328d454b5741252c` |

The generator reconstructs every legal move at the four q17 repair targets
and q19 control, classifies its conic-involution type, counts matching edges
on the selected and live conic subsets, and records terminal-core/isolate
status. Complete per-move signatures are transported and recomputed under
the order-four stabilizers:

```text
q17: 128/128,
q19: 204/204.
```

The selected-mark obstruction also has the direct proof above; computation
is not its sole evidence. Finite terminal status and conic involutions retain
the normalized prime-grid trust boundary. No game-value result is asserted
by this bundle.

The JSON is canonical sorted data. `--check` regenerates it in a temporary
directory and requires byte equality.

## `ej` + `tt` closeout

The cheap `ej` upgrade tested all three plausible quotient domains rather
than stopping after the selected-mark zero: selected marks, live points, and
the full conic. This turns a failed transfer into a complete trichotomy.

```text
bounded selected set: empty matching by legality;
bounded live set:     almost no domain coverage;
full conic:           partial move coverage + unbounded degree.
```

The general selected-mark proof is the strongest free result. It explains
why earlier selected-conic involution features were identically zero and
prevents the same dead bridge from being rediscovered with a more elaborate
matching quotient.

The Tao-style correction is that the Paper-II carrier solves the
**representation** problem only after the game obligations have already
become a bounded conic matching. C80 is blocked one layer earlier: its legal
move locus contains conic points and both involution types, and legality
erases every matching among the natural selected marks. The continuation
complex, not a perfect-matching quotient, is the correct common domain.

No incidental discovery-track item arose. The snapshot transfer and its
domain obstruction are direct C80 deliverables.

## Mystery ledger

- **[SETTLED negative] Do legal moves induce a matching on the selected conic
  marks?** No. Legality forces zero matching edges, uniformly.
- **[SETTLED negative] Does the live conic provide a bounded replacement?**
  No at q17: only `3/32` moves have a live matching edge.
- **[SETTLED negative] Does the full conic provide a complete carrier?** No.
  Only external intruders give perfect matchings (`9/32` at q17), and the
  quotient degree `(q-3)/2` is unbounded.
- **[SETTLED] Why do split intruders and conic moves remain outside?** Split
  involutions have two fixed conic points; conic moves induce no projection
  matching.
- **[SETTLED] Is the bridge failure coordinate-dependent?** No. All move
  signatures commute with projective transport.
- **[OPEN — C80] Can maximal two-face coverage in the full continuation
  complex be encoded by bounded tangent/triple incidence data with a direct
  update law?**
- **[OPEN — C80] Is there any bounded auxiliary conic mark set, derived from
  history rather than selected/live points, on which the obligations induce
  a nontrivial matching?** No evidence yet; this is lower EV than the direct
  continuation-complex route.
- **[OPEN — C80/C82 gate] Can a coverage datum become opponent-complete while
  strictly lowering `Ω`?** Unknown; C82 remains gated.

## Vibe

This is a valuable negative transfer: the attractive Plücker carrier is now
ruled out at the exact domain boundary, while the continuation complex
survives as a uniform object covering every move type.

go C80 cap construct a bounded tangent-plus-triple coverage datum for maximal two-faces
