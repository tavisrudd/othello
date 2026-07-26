# C80 — central-involution rank datum

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.

## Verdict

The canonical rank-carrying involution attached to a live-secant repair is
transport-natural but fails before it can initialize a response strategy.

For an off-conic marked opponent `o` and reply `p`, let `ι_o` and `ι_p` be
their projection involutions on the distinguished conic. When
`h=ι_oι_p` has even order `m`, define its unique central involution

```text
J(o,p) = h^(m/2).
```

Extend `J` to the plane by the symmetric-square projectivity. This is the
smallest canonical, formula-defined partial-pairing datum supplied by the
edge itself: it uses no matching representative, exception list, or
coordinate selector. The proposed response to a later opponent `x` is
`J(x)`, with overload as the decreasing rank and the selected-set mismatch
under `J` as the carried obligation rank.

The datum fails decisively:

| target | legal opponents | usable strict `x -> J(x)` replies |
| --- | ---: | ---: |
| each of four q17 repair targets | 32 | 0 |
| q19 control repair target | 51 | 4 |

At q17 all 128 tested images are illegal replies: 118 are ordinary
pair-extension failures and 10 land on the normalized opening line. At q19,
44 are illegal, three land on the opening line, and only four are jointly
legal strict replies. Those four split `2 P + 2 N`, so even the tiny usable
part is not edgewise sound.

The central datum commutes exactly with the full order-four stabilizer at
both orders. This is therefore another semantic failure, not a transport or
gauge failure. The most obvious rank-carrying subcorrespondence of the
live-secant carrier is closed-negative.

## Candidate datum

For an affine intruder point `[x:y:z]`, projection from that point induces
the Möbius involution

```text
t |-> (z t - x) / (y t - z),
```

represented by

```text
I_[x:y:z] = [[z,-x],[y,-z]].
```

The certificate constructs

```text
h = I_o I_p,
J = h^(ord(h)/2),
```

and verifies directly that `J` is nonidentity and squares projectively to
the identity. The five known repairs all have even product order:

```text
q17: ord(h)=18,
q19: ord(h)=10.
```

The full selected repair target has eight points. At q17, `J` overlaps its
image in four points, giving half-symmetric-difference obligation rank four.
At q19 the overlap is two and the obligation rank is six. In every case
exactly two selected points are fixed individually.

The intended lexicographic update was:

```text
future opponent x
-> reply J(x)
-> strictly smaller Ω, with the same formula-defined J
-> retain or contract the finite selected-set obligation.
```

This would have been a genuine nonrecursive proof datum: `J` is computed
directly from `(o,p)`, its update needs no minimax or `F_cc`, and alternating
matching gauge never enters. But almost every `J(x)` is illegal against the
unpaired selected target. The obligation does not merely fail to contract;
it prevents the first copycat exchange.

## Exact finite result

The four q17 repair targets have the following response histograms:

```text
(4,0)->(7,1):   30 illegal + 2 opening-line + 0 usable
(5,0)->(4,10):  28 illegal + 4 opening-line + 0 usable
(8,14)->(4,10): 30 illegal + 2 opening-line + 0 usable
(11,9)->(7,1):  30 illegal + 2 opening-line + 0 usable
```

The different opening-line counts are normalization labels, not intrinsic
differences: under projective transport an opening-line failure can become
an ordinary selected-secant failure. The intrinsic usable/nonusable
classification transports exactly.

For the q19 repair `(4,0)->(0,2)`, the four usable exchanges are

```text
(3,3)   -> (14,12): Ω=0, N
(5,12)  -> (7,13):  Ω=1, P
(7,13)  -> (5,12):  Ω=1, P
(14,12) -> (3,3):   Ω=0, N
```

Thus `J` exposes two symmetric pairs, but only one pair is value-preserving.
Retaining all equivariant choices again admits losing edges; choosing the P
pair would require an additional sound datum not supplied by the central
involution.

The `ej` orbit compression sharpens this comparison:

| unoriented exchange | value | `Ω` | product order | legal points | live conic | minimum mate degree |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| `{(3,3),(14,12)}` | N | 0 | 2 | 4 | 0 | 0 |
| `{(5,12),(7,13)}` | P | 1 | 10 | 7 | 3 | 1 |

Both joining lines are external. The losing orbit is premature complete
absorption, while the P orbit retains exactly the positive-overload/live-conic
resource seen throughout the earlier repair/spoiler comparison. Replacing
the datum by the P exchange's own central involution does not start a
recursion: it gives `0/7` usable replies on that target. The central-datum
family is therefore not closed even after selecting the good q19 orbit.

The searched domain is exactly the five certified repair targets and their
full legal-opponent sets, together with stabilizer transports of the q17
representative and q19 control. It is not a q19 root census and says nothing
about other live-secant edges or larger odd orders.

## Transport and independent checks

At each order the generator enumerates the full selected-six-set stabilizer.
For every transporter `g`, it verifies the matrix identity

```text
J(g o, g p) = g J(o,p) g^-1.
```

All eight conjugacy checks pass. It then transports every legal opponent and
compares usable versus nonusable response status after recomputation:

```text
q17: 128/128
q19: 204/204.
```

The coordinate-specific failure labels are deliberately not required to
match, because the transporter can move the distinguished opening line.

Reply legality has an independent replay. For every tested `x`, the script
constructs the projective point `J(x)` and checks cap validity by direct
determinants over the complete selected point set. This agrees with the grid
engine on every image. Exact P/N values for the four usable q19 targets use
the established normalized grid recursion; there is no second full game
solver in this bundle.

## Reproduction

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_central_involution_rank_datum.py
python3 rust/scripts/c80_central_involution_rank_datum.py --check
```

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_central_involution_rank_datum.py` | 25,076 | `7888a330452f7fe4c7cc8d1905aba23d4d2d3d0b8cdaca66eae5c9e0146230f1` |
| `notes/2026-07-25-c80-central-involution-rank-datum.json` | 51,692 | `286e6c1c601f743c76187276a7149b9a30e872947a04df8229acfe0b123271c7` |

The JSON is canonical sorted data. `--check` regenerates it in a temporary
directory and requires byte equality. Load-bearing source hashes are embedded
in the certificate.

## `ej` + `tt` closeout

The cheap `ej` upgrades were to evaluate the four q19 usable targets rather
than stop at the `4/51` coverage failure, replay all legality decisions by
direct determinants, and check matrix conjugacy plus response usability over
the full stabilizers. The q19 value split is the useful extra negative:
central-involution legality is not even a sound local edge predicate where it
exists.

The exact q19 pattern is revealing. `J` pairs the four usable moves into two
orbits, one P-pair at `Ω=1` and one N-pair at `Ω=0`. Once again faster
absorption is the losing choice. The P orbit retains seven legal points,
three live conic points, and positive mate degree; the N orbit retains
`4,0,0`. The datum captures a real symmetry but not the resource
distinguishing premature N absorption from a safe positive target. Updating
to the P orbit's own central involution yields `0/7`, so the distinction is
not recursively carried by the same construction.

The Tao-style correction is that a canonical involution derived solely from
the marked edge is too rigid. The selected state is not invariant under it:
obligation ranks are already four and six, and the resulting selected-secant
obstructions kill essentially the whole copycat domain. A viable proof datum
must be state-dependent enough to rewrite those obligations before applying
an involution; it cannot be the central element of the opponent-reply torus
alone.

No incidental discovery-track item arose. The canonical-datum falsifier and
the q19 P/N split are direct C80 deliverables.

## `ej2` — direct terminal shell behind the good q19 orbit

The second-order pass removes the remaining game-value oracle from the good
q19 exchange target. Its seven legal moves have no terminal move, but the
complete graph of pairs whose exchange is terminal has six edges and covers
all seven vertices. Therefore:

```text
for every opponent move x
there is a reply y
such that the continuation is terminal.
```

This is a direct two-ply normal-play proof that the target is P. The terminal
reply graph has

```text
degree sequence 1,1,1,2,2,2,3
component orders 2,5
component edge counts 1,5.
```

Intrinsically it is `K2` disjoint from a triangle with a length-two tail.
The degree-three articulation is the one ramified opponent fibre; the other
six vertices can be paired. This is exactly the correspondence language the
previous `ej4` specification anticipated—degree-one bulk plus one bounded
exceptional obligation—but only at this finite q19 target.

The bad q19 orbit gives the opposite one-ply certificate: its four legal
moves include two terminal moves, proving it N directly. Hence the `P/N`
split between the two central-involution orbits is now rules-certified
without recursive value evaluation:

```text
bad orbit:  exists a terminal move                         => N;
good orbit: no terminal move and every move has a terminal reply => P.
```

The q17 control blocks a uniform promotion. Every q17 repair target has no
terminal move and eight terminal-reply edges, but those edges cover only
`10/32` legal moves. The q19 shell is therefore a genuine direct base-case
upgrade, not the missing q17 or odd-q obligation rewrite.

The extra opening is narrow but real: search for an algebraic presentation
of the q19 six-edge terminal correspondence as `K2 ⊔` lollipop, then ask
whether the q17 `4→2→0` thread replaces terminality by the same
pairing-plus-one-obligation schema at the next structural boundary. Do not
promote terminal distance two itself as uniform.

## `ej3` — accidental graph symmetry and the q17 obligation tree

The q19 terminal shell has abstract graph automorphism group of order four:
one involution swaps the `K2`, and one swaps the two symmetric triangle
vertices in the lollipop component. But exhaustive conic-`PGL₂(19)`
stabilizer enumeration gives order one for the selected ten-point target.
None of the nontrivial reply-graph automorphisms comes from a projective
symmetry of the state.

This kills the cheapest algebraization of the shell. The six terminal edges
cannot be presented as one or two stabilizer orbitals of the current state;
their abstract `C2×C2` symmetry is a combinatorial coincidence. Any
coordinate-free formula must either:

1. retain marked construction history—the original repair edge and the good
   central-involution exchange—as proof datum; or
2. find a new incidence characterization of terminal coverage not explained
   by automorphisms.

The q17 terminal graph identifies what the history-marked datum would have to
carry. In every one of the four projectively equivalent repair targets its
nonisolated part is

```text
K2
⊔ an eight-vertex, seven-edge tree
  with degree sequence 1,1,1,1,1,2,3,4,
```

plus `22 K1` isolated obligation vertices. The `K2` seed persists from q19,
but the ramified component grows from a five-vertex unicyclic lollipop to an
eight-vertex tree and loses opponent completeness because of the 22
isolates. Thus “pairing plus one ramified component” is the common finite
shape; bounded terminal-shell size is not.

This is the third-order proof-design correction. The next datum should not
try to algebraize the q19 graph as a state orbital. It should mark the
exchange history and attach a rule that absorbs isolated obligation vertices
into a growing ramified component while lowering `Ω`. The q17
`4→2→0` thread is then the first contraction test. Anti-packing still
forbids listing the 22 isolates; they need an algebraic locus.

## Mystery ledger

- **[SETTLED] Is the central involution canonical and transport-natural?**
  Yes. All conjugacy and transported-usability checks pass.
- **[SETTLED negative] Does it initialize a copycat response on the q17
  repair orbit?** No: `0/32` usable replies on every target.
- **[SETTLED negative] Does q19 rescue the datum?** No: only `4/51` replies
  are usable, and they split `2 P + 2 N`.
- **[SETTLED `ej`] What are those four q19 replies intrinsically?** Two
  unoriented external exchanges: an order-two `Ω=0` N absorber and an
  order-ten `Ω=1` P exchange retaining three live conic points.
- **[SETTLED `ej`] Can the P exchange rewrite the datum to its own central
  involution?** Not as a copycat recursion: the rewritten datum has `0/7`
  usable replies.
- **[SETTLED `ej2`] Can the good q19 target be proved P without minimax or
  `F_cc`?** Yes. It has no terminal move and every move has a terminal reply;
  the reply graph is `K2` disjoint from a triangle with a length-two tail.
- **[SETTLED `ej2`] Can the bad q19 target be proved N equally directly?**
  Yes. Two of its four legal moves are terminal.
- **[SETTLED negative `ej2`] Does the same terminal shell cover q17?** No.
  Each repair target has eight terminal edges covering only `10/32` moves.
- **[SETTLED negative `ej3`] Is the q19 `K2`-plus-lollipop symmetry induced
  projectively?** No. The graph automorphism group has order four, while the
  selected target's conic-projective stabilizer is trivial.
- **[SETTLED `ej3`] What is the exact q17 terminal obligation shape?** The
  nonisolated graph is `K2` plus an eight-vertex tree of degree sequence
  `1,1,1,1,1,2,3,4`, accompanied by 22 isolates.
- **[OPEN — C80 `ej3`] Can a history-marked algebraic datum absorb the q17
  isolate locus into the ramified component without listing it?** This is
  the sharpened obligation-rewrite target.
- **[SETTLED `ej`] Is the failure caused by the normalized grid legality
  implementation?** No. Direct projective determinant replay agrees on every
  response.
- **[SETTLED `tt`] Can a central-torus involution serve as the bounded
  rank-carrying subcorrespondence by itself?** No. The selected-set mismatch
  creates the very mirror-chord obstructions the datum was meant to repair.
- **[OPEN — C80] What state-dependent algebraic rewrite makes a partial
  involution compatible with the selected secants?** It must alter or carry
  the obligation locus before copycat, while retaining direct rank soundness.
- **[OPEN — C80/C82 gate] Can such rewritten proof data give an
  opponent-complete sound correspondence?** Unknown; C82 remains gated.

## Vibe

This is another sharp, useful negative. The most canonical anti-gauge
involution is mathematically clean and computationally natural, but it
collides head-on with the selected-state geometry. The next attempt must
rewrite obligations, not merely choose a better torus element.

go C80 cap test a history-marked algebraic rewrite of the q17 isolate locus
