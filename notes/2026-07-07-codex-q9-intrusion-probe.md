# Codex C13 report: q=9 intrusion-structure probe

**Date:** 2026-07-07.

**Scope.** Exhaustive check for one normalized conic
`C_aff = {(t, 1/t) : t in F_9^*}` through the pre-played directions
`A = (1:0:0)`, `B = (0:1:0)`, over `F_9 = F_3[i]/(i^2+1)`. This is one conic
representative; the arc game is projectively invariant. The script also groups the
resulting six-point conic subsets by the full `PGL(2,9)` orbit on `P^1(F_9)`.

Checker: [`2026-07-07-q9-intrusion-probe.py`](2026-07-07-q9-intrusion-probe.py).

## Result

The q=9 intrusion prediction is exactly right.

- Raw normalized on-conic `S4` configurations: `C(8,4) = 70`.
- Full `PGL(2,9)` classes of the six played conic points `{A,B} ∪ S4`: `2`.
- Legal first-move histogram `(conic moves, off-conic intruders)`:
  - `(4, 0)`: `10` configurations.
  - `(4, 4)`: `60` configurations.
- Legal intrusions: `240` total.
- Intrusion type census: only `(tau_x, tau_played) = (2, 2)`, count `240`.

So Lemma III(4)'s q=9 bound

```text
tau_x <= 2 * tau_played - 2
```

is sharp in the only possible way: no internal intruders and no external intruders with
zero or one played tangency.

For every legal intruder `x`, the exact kill set check passed:

```text
sigma_x({A,B} union S4) intersect (C_aff \ S4) = C_aff \ S4.
```

Equivalently, the four remaining affine conic cells are all killed; after the intrusion,
the conic is dead.

## Residual Game

Every intruded child is an `N`-position for the next player, but the residual is even
smaller than a continuing mirror game:

- Intruded children checked: `240`.
- Legal replies from each intruded child: exactly `1`.
- The unique reply is terminal: after P2's reply, there are no legal moves.
- Max residual game-tree depth from an intruded child: `1`.
- Max residual branching from an intruded child: `1`.
- Max states per intruded-child residual tree: `2`.

Thus the mechanism is: P1's off-conic intrusion kills the conic, but it leaves a unique
second off-conic intrusion for P2, and that move ends the game. The intruder zone dies
immediately after P2's reply; there is no longer residual pairing game to analyze at q=9.

## Class Table

Representatives below are canonical full-`PGL(2,9)` representatives for the six played
conic parameters, not necessarily representatives containing the fixed displayed
`A,B = {inf,0}` pair.

| class | representative | raw configs | first moves | intruders | intrusion types | residual |
|---:|---|---:|---|---|---|---|
| 1 | `{0,1,2,i,1+i,2+i}` | 10 | `(4 conic, 0 intruder)` | none | none | conic-only, four moves left |
| 2 | `{0,1,2,i,1+i,2i}` | 60 | `(4 conic, 4 intruder)` | 4 per config | `(2,2)` only | each intrusion has one terminal reply |

Conic first moves are harmless in both classes: after a conic first move, the exact
checker finds exactly the three remaining conic cells as replies. P2 can answer on the
conic, leaving a two-move conic counter to P1, hence a P-child.

Therefore every legal first move from every on-conic `S4` has a P2 answer:

- Class 1: pure even conic counter (`4` conic moves left).
- Class 2, conic first move: conic-counter answer.
- Class 2, intruder first move: unique terminal second-intrusion answer.

So every on-conic `S4` at q=9 is a P-position.

## Command Output

Command:

```bash
python3 ../notes/2026-07-07-q9-intrusion-probe.py
```

Output:

```text
q=9 GF(9) intrusion probe
field=F3[i]/(i^2+1), PGL2 permutations=720
raw normalized on-conic S4 configs=70
full PGL(2,9) S4 classes=2
global legal first moves (conic,intruder) histogram={(4, 0): 10, (4, 4): 60}
global legal intruders per S4 histogram={0: 10, 4: 60}
global intrusion types (tau_x,tau_played)={(2, 2): 240}
all S4 P=True
all intruded children N=True
all intruded children have a terminal P2 reply=True
failures=0

classes:
CLASS 1 rep={0,1,2,i,1+i,2+i} raw=10
  first_moves={(4, 0): 10}
  intruder_counts={0: 10}
  intrusion_hist={}
  child_outcomes={}
  child_reply_counts={}
  winning_reply_counts={}
  terminal_win_reply_counts={}
  conic_first_reply_counts={3: 40}
  off_first_reply_counts={}
  residual max_depth=0 max_branch=0 max_states_per_child=0
CLASS 2 rep={0,1,2,i,1+i,2i} raw=60
  first_moves={(4, 4): 60}
  intruder_counts={4: 60}
  intrusion_hist={(2, 2): 240}
  child_outcomes={'N': 240}
  child_reply_counts={1: 240}
  winning_reply_counts={1: 240}
  terminal_win_reply_counts={1: 240}
  conic_first_reply_counts={3: 240}
  off_first_reply_counts={1: 240}
  residual max_depth=1 max_branch=1 max_states_per_child=2
```

## Adversarial Review

**Skeptical algebra reviewer.** The field model is explicit (`F_3[i]/(i^2+1)`) and matches
the q=9 model used by the grid-cap solver. Projective collinearity is determinant-based, not
coordinate-pattern based.

**Symmetry reviewer.** The exhaustive part is over one normalized conic through `A,B`, and the
report states that choice. The script independently computes the full `PGL(2,9)` action on
the conic parameter line and reports the two orbit classes among the 70 raw configurations.

**Game-semantics reviewer.** The exact solver uses normal play from the grid-cap legal-move
mask with `A,B` pre-played. It checks the value of each `S4`, not only the intrusion layer.

**Failure-mode reviewer.** The checker explicitly fails if an intruder has any type other than
`(2,2)`, if the conic survives after an intrusion, if the computed `sigma_x` kill set is not
the whole unplayed affine conic, if an intruded child is P, or if any `S4` is N. The run had
`failures=0`.
