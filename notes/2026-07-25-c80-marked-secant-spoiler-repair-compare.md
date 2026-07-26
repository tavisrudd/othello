# C80 — marked secant comparison of canonical spoilers and repairs

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-25.

## Verdict

The three canonical spoiling types have a sharper common explanation than
failure of the current survivor certificate: all 106 strict-reply targets are
exact N positions.

The marked incidence comparison separates them cleanly from the five certified
repairs:

| quantity | certified repairs | spoiling candidates |
| --- | ---: | ---: |
| legal points on the marked opponent--reply chord before the opponent | 5--8 | 2--4 |
| legal points after the exchange | 32--51 | 2--7 |
| live conic parameters after the exchange | 3--5 | 0--1 |
| target overload | 40 or 169 | 105 at 0, one at 1 |

Thus every spoiler is a premature near-boundary collapse, while the repairs
retain a broad conic and active-line reservoir. The full marked
destruction/orbital profile identifies the q17 repair profile four times and
the q19 repair profile once, with no N collision in the complete five marked
root fibres.

This does **not** produce the required uniform admissible-edge predicate. On
the 322 strict edges of those root fibres, no conjunction of at most three
predeclared monotone thresholds in thirteen natural scalar summaries is
P-pure. The first pure conjunctions use four thresholds fitted to the finite
controls. The exact destruction histograms are likewise two isolated
profiles, not a recurring algebraic class. The finite comparison therefore
diagnoses what the repairs preserve, but it does not justify another
feature-selector theorem.

## Exact comparison

The certified controls are the four q17 `Ω=40` repairs

```text
(4,0)  -> (7,1)
(5,0)  -> (4,10)
(8,14) -> (4,10)
(11,9) -> (7,1)
```

from root `{13,14,15,16}`, and the q19 `Ω=169` repair

```text
(4,0) -> (0,2)
```

from root `{15,16,17,18}`.

The spoiler side has exactly the three previously canonicalized types:

| type | coordinate fibres | candidates | target overload | exact value |
| --- | ---: | ---: | --- | --- |
| q17, 12 strict candidates | 4 | 48 | `0^48` | `N^48` |
| q17, 11 strict candidates | 4 | 44 | `0^44` | `N^44` |
| q19, 14 strict candidates | 1 | 14 | `0^13 1^1` | `N^14` |

The complete invariant feature multiset is identical across all four
coordinate copies of each q17 type. The q17 split is therefore genuinely two
marked projective types, not coordinate noise.

The exact-N strengthening is independently checked on every spoiler target by
a second small-tree normal-play recursion using only `legal_mask`. These
targets have at most seven legal moves, so the independent replay is complete,
not heuristic. The established grid engine agrees on all 106. The five
repairs are exact P in the grid engine and all lie in the structurally proved
copycat survivor `F_cc`.

The 105 overload-zero targets have static Node--Kayles Grundy values 1 or 2.
The unique q19 `Ω=1` target has four legal followers, three N and exactly one
P, at move `(14,8)`. Thus even the lone nonboundary exception is a one-move
winning shell over the same nonzero-boundary phenomenon.

## Incidence anatomy

All five repairs are external intruder--intruder exchanges. The q17 repair
profile has product order `18=q+1`, and the q19 repair has product order 10.
Those orbital labels do not explain the split: the spoilers include external
exchanges of both orders, along with many other product orders.

The stable distinction is reservoir-shaped.

- Before each repair, its marked chord contains 5 legal points at q17 or 8 at
  q19. Every spoiler chord contains only 2--4.
- A repair leaves 32 or 51 legal points and 3 or 5 live conic parameters.
  Spoilers leave only 2--7 legal points and at most one live conic parameter.
- Every q17 spoiler crosses directly to `Ω=0`. Thirteen q19 spoilers do the
  same; the last reaches only `Ω=1`.

This explains why maximum drain was the wrong direction at the preceding
fork. The bad edge spends almost the whole incidence reservoir and arrives at
an N boundary or one unit above it. The repair deliberately retains overload
and live conic structure.

The implication is diagnostic rather than sufficient: “retain a large
reservoir” does not itself supply the future `∀o∃p` strategy. In particular,
the absolute gaps also reflect that the spoiler fibres occur one exchange
deeper than the repair fibres. Promoting `marked-chord ≥ 5`, `live-conic ≥ 3`,
or another fitted threshold would repeat the already closed feature-only
route.

## Purity audit

The natural comparison domain is the complete set of strict replies in the
five marked root fibres:

```text
322 edges = 76 P + 246 N.
```

The complete normalized marked-secant destruction profile plus bounded
conic-orbital profile is locally exact:

```text
q17 repair profile: 4 occurrences, all P;
q19 repair profile: 1 occurrence, P.
```

That is a useful certificate identity but not an induction class. To test
whether its signal reduces to a small monotone incidence rule, the certificate
predeclares thirteen scalar coordinates: overloaded-line count and mass
through the reply, maximum through-load, thinned-line count and loss, legal
kills, marked-chord legal counts, target live-conic count, target overload,
target legal count, product order, and the reply's selected-conic fixed-point
count. For each coordinate it uses the weakest lower and upper threshold
accepting all five repairs.

No conjunction of one, two, or three such atoms is P-pure. Four atoms are
first sufficient, and several unrelated fitted quadruples work. This is the
signature of finite interpolation, not a canonical geometric law. It agrees
with the prior persistence result: the full q17 profile refinement covered
the finite fibres but had zero recurrence between positive depths.

## Consequence for C80

The comparison closes the immediate hope that one elementary marked
secant statistic will label admissible edges. Its positive residue is more
structural:

```text
certified repair = strict descent while preserving a large active reservoir;
spoiling edge    = premature absorption into an exact N near-boundary.
```

A viable successor must turn reservoir preservation into a proof-producing
continuation operation, not merely threshold its size. The most concrete
remaining shape is an exchange lemma that carries a structured response
certificate forward while retaining enough marked-chord/conic incidence to
avoid premature N absorption. C82 remains gated.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_marked_secant_spoiler_repair_compare.py
python3 rust/scripts/c80_marked_secant_spoiler_repair_compare.py --check
```

The generator reconstructs the repairs and all canonical spoiler fibres from
the committed C80 engines, emits every edge and its full marked incidence
profile, checks invariant-multiset equality across the q17 coordinate copies,
and writes canonical sorted JSON. `--check` regenerates in a temporary
directory and requires byte equality.

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_marked_secant_spoiler_repair_compare.py` | 22,790 | `b6ea0e9d0ca22eec80247972675293a35dc86db2888c48e4f9d1120b37c4e9d1` |
| `notes/2026-07-25-c80-marked-secant-spoiler-repair-compare.json` | 246,032 | `209ab8b6aace677c272e09c16b99cb583f3c00c0ee8b8e35b855d7880d0418cd` |

The exact small-tree replay is independent of the imported `game.value`
recursion but shares the normalized grid legality engine. Geometry, `Ω`,
`F_cc`, and `M_Ω` retain their prior frozen trust boundary; there is no second
projective-plane implementation. The q19 scope is still one marked root
opponent, not a full q19 root census.

## `ej` + `tt` closeout

The free strengthening is the exact-value audit: all 106 spoiling candidates
are N in both the grid engine and the independent small-tree recursion. The
earlier statement only knew that they missed `F_cc` and `M_Ω`. The additional
cheap boundary audit shows that all 105 `Ω=0` targets have Grundy value 1 or
2, while the unique `Ω=1` target has exactly one P follower. No further
uniform base law appears: both nonzero Grundy values occur in every canonical
type.

The Tao-style correction is to distinguish diagnosis from induction. The
large finite gaps tempt a threshold rule, but the scalar audit shows that
even the root fibres require a four-coordinate fitted conjunction, while the
full profile has no positive-depth recurrence. The theorem-shaped content is
therefore not “large reservoir implies P.” It must be an explicit operation
that transports a response certificate while preventing premature
absorption.

No incidental discovery-track item arose. The exact-N upgrade and the
reservoir diagnosis are direct C80 deliverables.

## Mystery ledger

- **[SETTLED] Are the 106 candidates merely outside the chosen survivor?**
  No. Every one is exact N, independently replayed on its complete small
  residual game tree.
- **[SETTLED] Do the spoilers share one terminal graph value?** No. The 105
  overload-zero targets have Grundy values 1 and 2 in every canonical type;
  the unique overload-one target has a single P follower.
- **[SETTLED] Are the q17 incidence tables coordinate-dependent?** No. Each
  canonical type has the same complete feature multiset in all four copies.
- **[SETTLED] What finite incidence gap separates repairs from spoilers?**
  Repairs retain 5--8 marked-chord legal points, 32--51 total legal points,
  and 3--5 live conic parameters; spoilers retain only 2--4, 2--7, and 0--1.
- **[SETTLED negative] Does one low-dimensional monotone scalar rule certify
  the repairs in the natural marked fibres?** No conjunction through three
  atoms in the stated library is P-pure; the first four-atom rules are fitted
  finite interpolants.
- **[OPEN — C80] What structural operation turns retained incidence into a
  future response certificate?** The exact evidence gap is a nonrecursive
  exchange/transport lemma, not another static edge profile.
- **[OPEN — C80/C82 gate] Can such operations be made opponent-complete and
  counted uniformly in odd q?** Unknown; C82 remains gated.

## Vibe

This is a useful hardening rather than the hoped-for separator theorem. The
spoilers are now certified as genuine losing edges and their failure has a
clear geometric shape—premature reservoir collapse—but the data also reject
the temptation to turn that shape into another fitted selector.

go C80 cap construct a proof-producing reservoir-preserving exchange operation
