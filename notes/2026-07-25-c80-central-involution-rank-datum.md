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
| `rust/scripts/c80_central_involution_rank_datum.py` | 13,027 | `c73980795654404a8eac1fcf30c977d2d438fdd1483e13811ec7e1438eb63e0f` |
| `notes/2026-07-25-c80-central-involution-rank-datum.json` | 43,098 | `ff7f7a320b57e90d34bc0541503153dbf6c309ad330f7791fb4e37d3d86f4aa8` |

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
absorption is the losing choice. The datum captures a real symmetry but not
the resource distinguishing premature N absorption from a safe positive
target.

The Tao-style correction is that a canonical involution derived solely from
the marked edge is too rigid. The selected state is not invariant under it:
obligation ranks are already four and six, and the resulting selected-secant
obstructions kill essentially the whole copycat domain. A viable proof datum
must be state-dependent enough to rewrite those obligations before applying
an involution; it cannot be the central element of the opponent-reply torus
alone.

No incidental discovery-track item arose. The canonical-datum falsifier and
the q19 P/N split are direct C80 deliverables.

## Mystery ledger

- **[SETTLED] Is the central involution canonical and transport-natural?**
  Yes. All conjugacy and transported-usability checks pass.
- **[SETTLED negative] Does it initialize a copycat response on the q17
  repair orbit?** No: `0/32` usable replies on every target.
- **[SETTLED negative] Does q19 rescue the datum?** No: only `4/51` replies
  are usable, and they split `2 P + 2 N`.
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

go C80 cap test one state-dependent algebraic obligation rewrite before copycat
