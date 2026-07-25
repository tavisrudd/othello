# C80 — exact marked-secant retention exchange

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.

## Verdict

The opponent-marked secant algebra gives an exact exchange identity, but it
does **not** currently prove or falsify a q-uniform positive retention
strength.

For a marked child `C=S+o` and legal reply `p`, let `D_C(p)` be the overload
destroyed by playing `p`.  If `K_p` is the set of legal points killed by the
new secants from `p` to the selected cap, then

```text
D_C(p)
 = sum_{active ell through p} (|L(C)∩ell|-2)_+
 + sum_{active ell not through p}
       min(|K_p∩ell|, (|L(C)∩ell|-2)_+).                 (1)
```

Consequently

```text
Ω(C+p)=Ω(C)-D_C(p).                                     (2)
```

Let `d_0` be the minimum `D_C(r)` among replies with
`Ω(C+r)<Ω(S)`. Then

```text
M(S,o)=Ω(C)-d_0,
Ω(C+p)/M(S,o) >= α
iff
D_C(p) <= (1-α)Ω(C)+α d_0.                              (3)
```

Thus the retention crown is exactly a marked-secant **upper bound on the
destruction of one lower-kernel reply**, not a lower bound on raw overload
and not an extremal load-profile theorem.

The strongest value-free shortcut is false already at q=17. Across the
certified q=17 kernel DAG, the minimum ratio of the smallest positive strict
target to the largest strict target is `1/7`. Hence no argument saying
“every positive strict reply automatically retains 1/4” can prove
`F_{1/4}`. The existential lower-kernel ratio on the same domain remains
`20/51`, exactly as in the preceding Bellman audit. The gap

```text
all positive strict replies:       1/7
best positive lower-K reply:      20/51
```

is the game-semantic content that secant accounting alone has not removed.

This is a bounded negative against the blanket marked-load route, not a
counterexample to `inf_q ρ(S_q)>0`. C80 remains open and C82 remains gated.

## 1. Proof of the drop identity

Before `p` is played, partition the active capacity-two lines into those
through `p` and those not through `p`.

Every active line through `p` becomes inactive, so it loses its full
overload `(n_ell-2)_+`. An active line not through `p` remains active. Its
legal load falls from `n_ell` to `n_ell-|K_p∩ell|`, and therefore its
overload loss is

```text
(n_ell-2)_+ - (n_ell-|K_p∩ell|-2)_+
= min(|K_p∩ell|, (n_ell-2)_+).
```

The new secants through `p` are distinct away from `p`, because the selected
position is a cap and `p` is legal. They account for exactly the newly
illegal points other than `p`. Summing the two line classes proves (1) and
(2). Substituting (2) into the definition of `M` proves (3).

This identity is intrinsic: it uses the marked child, active-line loads, and
the opponent/reply secants only. It uses no P/N label, Grundy value, or
kernel recursion.

## 2. Exact finite audit

The checker independently evaluates the right side of (1) and compares it
with direct recomputation of `Ω(C)-Ω(C+p)` on every strict reply row in the
chosen q=11/q=13/q=17 kernel certificates.

| q | marked-drop checks | positive lower-kernel fibres | blanket minimum | best lower-kernel minimum |
| ---: | ---: | ---: | ---: | ---: |
| 11 | 17,370 | 0 | — | — |
| 13 | 3,792 | 99 | `1/2` | `1` |
| 17 | 198,286 | 3,046 | `1/7` | `20/51` |

All 219,448 identity checks agree exactly.

The q=17 blanket counterexample has residual selected cells

```text
(4,13), (5,7), (7,5), (15,8),
```

marked opponent `(1,12)`, and child overload `231`. Reply `(16,16)` destroys
`223` overload, leaving `8`, while the maximum strict target overload is
`56`; the ratio is `1/7`. The marked decomposition is

```text
deactivated-line overload = 10,
thinned-line overload     = 213.
```

This target is itself in `K_Ω`, but the fibre has better lower-kernel
choices. It therefore falsifies blanket retention, not existential
retention.

The actual q=17 Bellman bottleneck is the on-conic root
`{6,7,8,14}`. At opponent `(4,2)`, the child has overload `252`.
The unique lower-kernel reply `(13,7)` destroys `232`, leaving `20`; the
maximum strict target is `51`, so equality holds in (3) at `α=20/51`.
The target has retention strength `1`, making this one marked exchange—not
deeper recursion—the exact root bottleneck.

This sharpens the next proof obligation:

> At every nonboundary marked fibre in the proposed odd-q survivor family,
> exhibit a lower-`K_Ω` reply whose secant-destruction value satisfies (3)
> for one fixed `α>0`.

Counting replies satisfying (3) is still useless until lower-kernel
membership is certified structurally; that is why C82 is not released.

## 3. Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello/rust
```

Generate and check:

```text
python3 scripts/c80_marked_secant_retention.py
python3 scripts/c80_marked_secant_retention.py --check
```

Evidence:

- `rust/scripts/c80_marked_secant_retention.py`, 8,620 bytes,
  SHA-256
  `ce3e4d8e12830e5265288365d6b47986e5946049fbf49245bd100ab1a45ed7c4`;
- `notes/2026-07-25-c80-marked-secant-retention.json`, 29,288 bytes,
  SHA-256
  `60948241b751eef78d9fec4b9bc1d2714bab6d8c40e77a40596976fe9315bddf`.

The script imports the committed strict-kernel and retention
implementations. Kernel labels and Bellman strengths therefore inherit
their trust boundary; there is no second kernel implementation. The
marked-drop formula is a separate computation from `StrictKernel.omega` and
is checked reply-by-reply. The finite negative is restricted to the stated
certificate DAGs and does not extrapolate to untested q.

## `ej` + `tt` closeout

The cheap extra value is equation (3): it converts the ratio definition
into the exact opponent-marked secant inequality a proof must establish.
It also separates two quantifiers that the earlier percentage packet hid:

```text
geometry counts replies obeying the destruction inequality;
game structure must put at least one such reply in the lower kernel.
```

The Tao-style lesson is that bounding the whole reply fibre is unnecessarily
strong and already false. The q=17 bottleneck needs one nonextremal reply,
and its `20/51` is an equality case of the marked destruction inequality.
A viable uniform attack should characterize that existential exchange
class under conic/frame normalization, not optimize a scalar over every
reply.

No further finite percentage sweep is justified. The next decisive move is
an algebraic exchange lemma for the normalized size-four marked fibre,
followed by a persistence lemma showing that the same class recurs through
the required `sqrt(q)` positive-overload depth. Without persistence, another
head calculation has no uniform force.

## Mystery ledger

- **[SETTLED] What is the exact marked-secant quantity controlling
  retention?** The destruction value `D_C(p)` in (1); retention is exactly
  inequality (3).
- **[SETTLED negative] Does a positive bound follow because all positive
  strict replies retain a fixed fraction?** Not at `α=1/4`: the certified
  q=17 DAG contains an exact `1/7` reply.
- **[SETTLED finite] Where is the q=17 root bottleneck?** One size-four
  marked fibre at root `{6,7,8,14}`; its unique lower-kernel reply realizes
  `20/51` and lands in a strength-one target.
- **[OPEN — C80] Is there a q-independent `α>0` for the odd-q escape
  family?** Neither the exact identity nor the finite audit controls the
  lower-kernel existential quantifier at arbitrary q.
- **[OPEN — C80] What structural predicate certifies the good reply?** The
  marked secant destruction number is necessary quantitative data but does
  not certify kernel membership.
- **[OPEN — C80] Does the exchange class persist for
  `Ω`-positive depth `Θ(sqrt(q))`?** Existing q=17/q=19 certificates do not
  reach that regime.

## Vibe

The route is sharper but still genuinely hard: the algebra now says exactly
what must be bounded, and it kills the tempting blanket shortcut, while the
only remaining gap is the value-carrying existential exchange itself.

go C80 cap prove or falsify a persistent normalized marked-secant exchange
class satisfying the retention inequality at positive-overload depth
