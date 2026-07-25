# C80 — exact residual exchange morphism

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.

## Verdict

An exact cross-depth renormalization morphism **does exist**, provided the
completed exchange is contracted into its residual pair/triple effects
rather than simply erased.

For a cap state `S`, retain only:

```text
V(S)  = the live legal vertices;
E(S)  = live supports of load-one lines, giving pair-conflict blocks;
A(S)  = live supports of load-zero lines of size at least three,
        giving active capacity-two blocks.
```

Call this depth-free residual object `R(S)=(V,E,A)`. If `x∈V`, define
`D_x R` by:

1. delete `x` and every vertex sharing an `E`-block with `x`;
2. restrict every old block to the surviving vertices;
3. turn each active block in `A` containing `x` into an `E`-block;
4. retain each active block not containing `x` in `A`.

Then

```text
R(S+x) = D_x R(S).
```

Consequently an opponent/reply exchange satisfies

```text
R(S+o+p) = D_p(D_o(R(S))).
```

This is the requested cross-depth contraction at the exact game-domain
level. The selected history, depth, and individual marked-pencil labels
disappear; their surviving effect is the union of pair-conflict blocks.

The result is a dynamic corollary of C547's Lean-checked static rank-three
residual theorem and is the same mathematical move operator as the existing
`deepTransform` representation. It is not a new ambient hypergraph-game
construction.

The crucial limitation is dimensional: `R(S)` has fixed relation arity, but
its vertex and block counts grow with `q`. It therefore does **not** yet give
the bounded algebraic/follower-signature quotient needed to prove uniform
escape-root membership in `K_Ω`. C82 remains gated.

## 1. Exact theorem

Let the underlying line capacity be two. For a selected cap `S`, each line
has one of three relevant residual states:

```text
selected load 2  → all unselected points on the line are illegal;
selected load 1  → at most one further point may be selected: a pair block;
selected load 0  → at most two further points may be selected: an active block.
```

Lines with fewer than two live points in the second case, or fewer than
three in the third, impose no future constraint and may be omitted.

### Theorem 1 — residual sufficiency

A set `U⊆V(S)` is a legal continuation of `S` if and only if

```text
|U∩B| ≤ 1  for every B∈E(S),
|U∩A| ≤ 2  for every A∈A(S).
```

**Proof.** On a line of selected load `d`, validity is exactly
`|U∩ℓ|≤2-d`. Load-two lines contribute no live vertices. The remaining two
cases are precisely the displayed pair and active blocks. ∎

### Theorem 2 — transform commutation

For every legal `x`,

```text
R(S+x)=D_x R(S).
```

**Proof.**

- A live vertex becomes illegal after selecting `x` exactly when it shares a
  load-one line with `x`; this is deletion of the `E`-neighbourhood.
- A load-one line through `x` becomes saturated, and all of its other live
  vertices have already been deleted.
- A load-zero line through `x` becomes load one, so its surviving support
  changes from an active block to a pair block.
- Every line not through `x` retains its selected load; only its support is
  restricted by vertices killed elsewhere.

These are all projective lines, so the transformed and directly reconstructed
objects agree block by block. ∎

### Corollary 3 — game-tree morphism

`S↦R(S)` is a rooted game-tree bisimulation: legal moves are the vertices,
and the follower after a move is computed by `D`. Hence cap P/N value and
Grundy value factor through `R`.

This is stronger than a value-preserving map on the selected certificates:
it preserves the entire continuation game.

## 2. The overload kernel also factors

The C80 absorption coordinate is intrinsic to the active blocks:

```text
Ω(S) = Σ_{A∈A(S)} (|A|-2).
```

Thus `Ω=0` exactly when `A(S)` is empty. At that boundary, Theorem 1 leaves
only the pair-conflict graph formed by the blocks in `E`, which is precisely
the `Y_NK` Node--Kayles guard.

The recursive definition of `K_Ω` uses only:

- legal moves;
- the transform to each follower;
- `Ω`;
- the `Y_NK` boundary Grundy value.

All four are determined by `R`. Therefore `K_Ω` membership, the
boundary-or-retention families `F_α`, and the marked destruction/retention
optimization factor through this residual object. This is the correct
semantic controlled family for cross-depth work.

It does not provide a nonrecursive membership test: defining the image of
`K_Ω` inside residual objects merely transports the same well-founded
kernel.

## 3. Exact q=17 replay

The implementation constructs `R(S)` in two independent ways:

1. direct reconstruction from every projective line and its selected load;
2. the depth-free `D_x` transform from the parent residual.

It checks every positive-overload lower-`K_Ω` reply in every forced-positive
fibre of the frozen q=17 strict-kernel DAG.

| check | count | mismatch |
|---|---:|---:|
| distinct parent residuals | 58 | — |
| opponent transforms / direct children | 610 | 0 |
| reply transforms / direct targets | 3,960 | 0 |
| direct target overloads | 3,960 | 0 |

The 3,960 rows produce 2,022 distinct exact target residuals. Their ranges
show why “bounded arity” must not be promoted to “bounded complexity”:

| datum | range |
|---|---:|
| live vertices | 3–38 |
| pair blocks | 0–88 |
| active blocks | 1–53 |
| positive overload | 1–68 |

The selected target sizes are six (3,798 rows) and eight (162 rows).

The stop condition is the complete stated frozen domain. The transform
theorem itself is general for capacity-two line residuals; the counts are
only a regression/certificate check at q=17.

## 4. Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello/rust
```

Generate and check:

```text
python3 scripts/c80_residual_exchange_morphism.py
python3 scripts/c80_residual_exchange_morphism.py --check
```

Evidence:

- `rust/scripts/c80_residual_exchange_morphism.py`, 9,701 bytes, SHA-256
  `fb570524b45a3111497b60596c66ed48d672d0d32ddd8c16358906dfe544e485`;
- `notes/2026-07-25-c80-residual-exchange-morphism.json`, 1,508 bytes,
  SHA-256
  `eb7845787a2686e0a728e5ac424c2ce2d938796abe688f827d6414e7840c2689`.

The selected states and lower-kernel labels inherit the committed strict
kernel/profile trust boundary. The transform implementation never calls cap
minimax or direct target legality. Its comparison target is reconstructed
separately from the projective-line list and selected loads. There is no
second implementation of the upstream response-domain enumeration.

## `ej` + `tt` closeout

The free upgrade is a correction to the preceding falsifier's handoff
language. A successor need not retain two separately labelled pencils for
every historical exchange. It must retain their **surviving pair-conflict
effect**, and the union of pair blocks does exactly that. The externally
non-twin vertices killed the one-supervertex quotient, not the exact
mixed-capacity quotient.

The Tao-style separation is now:

```text
exact renormalization: solved by the depth-free residual transform R,D;
finite compression:    open for a bounded congruence on residual objects;
value theorem:          open for a nonrecursive description of R(K_Ω).
```

The correct next object is a congruence or follower-signature map `π` such
that

```text
π(D_x R)
```

is determined by `π(R)` and the move type, while `Ω`, the `Y_NK` boundary,
and `K_Ω` membership remain visible. Scalar load profiles and bounded
conic-orbital profiles have already failed this requirement. Another
selected-state classifier is not the target.

## Mystery ledger

- **[SETTLED positive] Does an exact cross-depth contraction exist after the
  forgetful map fails?** Yes: the mixed-capacity residual transform.
- **[SETTLED] Must historical marked pencils remain separately labelled?**
  No. Their surviving union of pair-conflict blocks is sufficient when the
  active blocks are retained.
- **[SETTLED] Do `Ω`, `Y_NK`, and `K_Ω` factor through the residual?** Yes,
  directly from their definitions and the transform theorem.
- **[OPEN — C80] Is there a q-independent finite-dimensional congruence of
  these residual objects that preserves the required kernel response
  structure?** No such quotient is proved; prior static signatures are
  falsified.
- **[OPEN — C80 crown] Can the chosen escape child be placed in `K_Ω`
  uniformly without evaluating the recursive residual kernel?** Still open.

## Vibe

This is a real structural positive and a useful correction: cross-depth
renormalization itself is not the obstruction. The remaining difficulty is
finite compression of the exact residual game, not carrying selected
history.

go C80 cap prove or falsify a finite-dimensional congruence of the exact
mixed-capacity residual transform
