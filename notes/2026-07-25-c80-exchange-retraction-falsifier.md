# C80 — cross-depth exchange retraction falsifier

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.

## Verdict

The canonical cross-depth renormalization that **forgets the completed
opponent/reply exchange** is false, already at the first positive-overload
step of the q=17 strict-kernel certificate.

Let `S` be the parent cap, let `T=S∪{o,p}` be a certified positive-overload
reply target, and let `Δ(S)` denote the cap-continuation complex. The natural
forgetful proposal is

```text
Δ(S) restricted to the moves still legal at T  →  Δ(T),
U                                               ↦  U.
```

This is a valid face map exactly when the exchange creates no new pair
conflict among the surviving moves. At q=17:

- all 3,798 positive lower-`K_Ω` replies from residual size four create a
  new pair conflict;
- every one also has two vertices in the same new marked-pencil clique with
  different external conflict neighbourhoods, so collapsing the clique to
  one move is not even a rank-two game quotient;
- consequently the proposed renormalization cannot make the first
  size-four-to-size-six step, with or without the `α=1/4` retention gate.

Across all 610 forced-positive q=17 fibres, the unrestricted positive-kernel
packet has 3,960 replies. Exactly 65 replies, all from residual size six,
have no new pair conflicts and therefore admit the exact forgetful
contraction. They cover 51 fibres. The remaining 559 fibres have no such
reply. The same counts hold after imposing `α≥1/4` except that 43 obstructed
replies are removed.

Thus exact deletion of the exchange is falsified as the cross-depth
morphism. Any surviving renormalization must retain the two marked-pencil
conflict relations and enough external incidence to distinguish their
non-twin vertices. This does not rule out such a labelled, non-forgetful
morphism or a non-simplicial value argument.

## 1. Exact criterion

For a cap `A`, write

```text
Δ(A) = {U : A∪U is a cap}.
```

Put `T=S∪{o,p}` and let `V` be the points individually legal over `T`.

### Proposition — exchange restriction criterion

For `U⊆V`, the only cap obstructions that can occur in `T∪U` but not in
`S∪U` are triples `{o,x,y}` or `{p,x,y}` with `x,y∈U`. Hence

```text
Δ(T) = Δ(S)|V
```

if and only if no pair face `{x,y}` of `Δ(S)|V` is collinear with `o` or
`p`.

**Proof.** Since `S⊂T`, every `T`-continuation is an `S`-continuation. For
the converse, take a collinear triple in `T∪U` absent from `S∪U`. It contains
at least one of `o,p`. It cannot contain both, because every point of `U` is
individually legal over `T`. It therefore contains exactly one marked point
and two points of `U`, as claimed. ∎

A violating pair proves more than failure of the displayed identity: the
two complexes on the common vertex set have different numbers of pair
faces, so no arbitrary relabelling or projective normalization can make
them simplicially isomorphic.

There is a second exact obstruction to the obvious repair. The new conflicts
through each marked centre form cliques on the surviving points of its
lines. Collapsing such a clique is a faithful rank-two quotient only if its
vertices have identical compatibility with every vertex outside that
clique. The audit checks this necessary twin condition directly.

## 2. Explicit q=17 counterexample

Take

```text
S = {(3,6),(4,13),(5,7),(8,15)},
o = (0,0),
p = (1,10).
```

This is a certified lower-`K_Ω` reply with target overload `26` and retention
`13/24`. Both

```text
x=(2,2),  y=(13,16)
```

are individually legal over `T=S∪{o,p}`, and `{x,y}` is a legal continuation
over `S`. But `p,x,y` are collinear:

```text
det((1,10,1),(2,2,1),(13,16,1)) = 0 mod 17.
```

Therefore `{x,y}` is not a face of `Δ(T)`. In fact this exchange adds 54
pair conflicts on the common surviving vertex set.

The certificate includes an independent determinant replay in the explicit
coordinate model with fixed residual points `(1,0,0),(0,1,0)`. It verifies
that `S∪{x,y}`, `T∪{x}`, and `T∪{y}` are caps, while `T∪{x,y}` is not.

## 3. Complete bounded audit

The searched domain is every forced-positive fibre in the chosen
q=13/q=17 strict-kernel response DAG and every positive-overload
lower-`K_Ω` reply in those fibres.

| q | forced-positive fibres | positive replies | replies with new conflicts | exact contractions | fibres covered exactly |
|---:|---:|---:|---:|---:|---:|
| 13 | 0 | 0 | 0 | 0 | 0 |
| 17 | 610 | 3,960 | 3,895 | 65 | 51 |

At `α≥1/4`, q=17 has 3,917 eligible replies, of which 3,852 are obstructed;
the same 65 exact contractions cover the same 51 fibres. Every conflicted
reply in both packets fails the marked-clique twin condition. All 65 exact
contractions occur at residual size six (`64` intruder/intruder and one
conic/intruder exchange); none occurs at residual size four.

The stop condition is the complete chosen response DAG, not all projective
caps at q=17 and not any order above 17. The mathematical proposition is
general; the exhaustive counts and the universal first-step failure are
only for this frozen domain.

## 4. Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello/rust
```

Generate and check:

```text
python3 scripts/c80_exchange_retraction_falsifier.py
python3 scripts/c80_exchange_retraction_falsifier.py --check
```

Evidence:

- `rust/scripts/c80_exchange_retraction_falsifier.py`, 14,477 bytes,
  SHA-256
  `ceea2c77282d91a85bded968bbf84c33846c5b7783e57c1b03136c859ba97f36`;
- `notes/2026-07-25-c80-exchange-retraction-falsifier.json`, 8,812
  bytes, SHA-256
  `b0626504c1b45011ff880c64a10019ac65cecbea690ac7637a7cb546a17bbd41`.

The enumeration imports the committed marked-secant profile audit and its
strict-kernel implementation, so the selected states and lower-kernel labels
inherit that trust boundary. Pair conflicts, external neighbourhoods, and
the explicit witness are recomputed from exact projective incidence. The
hard-coded determinant replay is independent of the imported game engine.
There is no second implementation of the complete 3,960-reply enumeration.

## `ej` + `tt` closeout

The cheap extra result is positive but sharply located: exact forgetful
contractions do exist—65 times—but only at the later size-six layer. Their
absence at all 3,798 first-step replies shows that the problem is not merely
low density; the proposed recursion cannot initialize.

The Tao-style reformulation is that an exchange does not disappear. It
changes the residual continuation complex by adding two labelled pencils of
rank-two conflicts. Those pencils are the exact cross-depth state carried by
the move operator. Since every nontrivial audited pencil has externally
non-twin vertices, replacing a pencil by its size, clique, or one
supervertex loses game data. A viable renormalization must act on a
**boundary-labelled residual hypergraph** and prove that the growing list of
marked pencils has a bounded algebraic quotient. That is materially
different from deleting the exchange or enriching a static load profile.

## Mystery ledger

- **[SETTLED negative] Is forgetting the completed exchange an exact
  cross-depth continuation-complex morphism?** No. The explicit q=17 pair
  face disproves it, and every first-step positive-kernel reply in the frozen
  domain has such an obstruction.
- **[SETTLED negative] Can one repair it by collapsing each new
  marked-pencil clique to one move?** Not on any conflicted audited reply:
  every such reply has externally non-twin clique vertices already at rank
  two.
- **[SETTLED finite] Do exact forgetful contractions ever occur?** Yes:
  65 size-six replies covering 51 fibres.
- **[OPEN — C80] Is there a boundary-labelled quotient that retains the
  marked pencils but contracts their accumulated incidence algebra?** No
  candidate or bounded signature theorem is known.
- **[OPEN — C80 crown] Is `inf_q ρ(S_q)>0`?** This falsifier does not answer
  it.

## Vibe

This is a decisive negative for the morphism the previous closeout naturally
asked for. It also isolates the non-negotiable state a successor must carry:
two new, externally nonuniform marked pencils per exchange.

go C80 cap prove or falsify a bounded algebraic quotient of the accumulated
marked-pencil boundary
