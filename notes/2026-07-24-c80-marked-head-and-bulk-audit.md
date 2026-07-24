# C80 — marked-head canonicalization and bulk-exchange audit

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-24.

## Verdict

The two proposed next compressions do not yet yield a uniform proof.

1. The twelve q=17 transitions missed by all elementary incidence maxima
   reduce under the full conic `PGL(2,17)` action to **five** marked
   state/opponent/reply orbits, not one or two.
2. The q=17 maximal-overload-drop bulk closes exactly under arbitrary
   lower-kernel branching, but every resulting lower-kernel target is
   already at `Ω=0`.  The same hidden shallowness occurs from selected size
   six onward in the tested q=19 root.

Thus the finite `Rmax` success is direct `Y_NK` absorption, not evidence for
a recursive positive-overload exchange theorem.  Since these boundary
targets are twelve-caps after restoring the two fixed points, the proved
bound

```text
capOK for an s-cap  =>  q <= binom(s,2)
```

makes the same fixed-size absorption impossible for `q>=67`.

This falsifies the proposed *fixed-head + one-exchange bulk absorption*
extrapolation.  It does not falsify a growing-depth theorem in which
`Rmax` repeatedly returns to a positive-overload survivor family.  No such
family or exchange proof is currently known.

## 1. Full conic-projective canonicalization

The conic is `XY=Z²`, parametrized by the Veronese map

```text
[u:v] |-> [u²:v²:uv].
```

For `g=[[a,b],[c,d]]`, the induced symmetric-square projectivity is

```text
X' = a²X + b²Y + 2abZ
Y' = c²X + d²Y + 2cdZ
Z' = acX + bdY + (ad+bc)Z.
```

The checker enumerates all `|PGL(2,17)|=4896` projectivities and
canonicalizes the complete conic-marked object

```text
(selected projective set, marked opponent, unique lower-kernel reply).
```

The twelve records split as

```text
3 + 2 + 1 + 4 + 2
```

across five orbits.  There are also five selected-state orbits, with the
same record partition.  One orbit is intruder-opponent/conic-reply; three
are intruder-opponent/intruder-reply; the singleton is
conic-opponent/intruder-reply.

The rigidity is the important negative.  Eight records have trivial
selected-state stabilizer.  The other four belong to one state type with
stabilizer order four and form one opponent orbit.  Every marked-opponent
stabilizer is trivial, as is every complete marked-object stabilizer.
Consequently symmetry transport explains the four-record orbit but supplies
no internal reply choice for the other eight transitions.  The head is
smaller after quotienting, but it is not one homogeneous torsor packet.

Trust boundary: this is canonicalization under the conic-preserving
`PGL₂` action.  It does not claim equivalence under an unmarked ambient
projectivity that sends the distinguished six-point conic subset to some
different six-subset of a later selected state.

## 2. Exact q=17 branching beyond the chosen DAG

The earlier packet audit followed one response selected by the recursive
kernel implementation.  The new search starts from **every**
selected-size-eight state on that chosen head DAG and then branches through
**every** strict lower-`K_Ω` reply.

Exact closure:

| quantity | count |
| --- | ---: |
| selected-size-eight frontier states | 10,212 |
| positive-overload size-eight states | 618 |
| overload-zero size-eight states | 9,594 |
| overload-zero size-ten targets | 3,057 |
| positive marked edges checked | 3,413 |
| lower-kernel targets seen | 7,090 |
| counterexamples to `Rmax` coverage | 0 |

The queue exhausts after 13,269 states.  Every one of the 7,090
lower-kernel targets has `Ω=0`; no positive-overload size-ten state occurs.
So the stronger all-response closure is real, but it proves only:

> From this finite q=17 size-eight frontier, every marked opponent has a
> maximal-drop response directly into the `Y_NK` boundary.

It does not exercise a recursive maximal-drop exchange at positive
overload.

As an independent domain extension, exhaustive reachable-state checks at
q=5 and q=7 find no maximal-drop counterexample:

| q | reachable states | kernel states | positive kernel states | marked edges |
| ---: | ---: | ---: | ---: | ---: |
| 5 | 726 | 301 | 1 | 25 |
| 7 | 19,160 | 11,467 | 883 | 17,689 |

These are exact small-order checks, not a uniform theorem.

## 3. q=19 explains the apparent threshold

For the previously stated q=19 root `{15,16,17,18}`, the maximal-drop
packet has a lower-kernel member on:

```text
size 4:   116 / 148 marked edges,
size 6: 7,140 / 7,423,
size 8: 21,743 / 21,743.
```

The target audit now shows:

- all 116 covered size-four edges have only positive-overload maximal-drop
  kernel targets;
- all 7,140 covered size-six edges have a boundary target and no positive
  target;
- all 21,743 size-eight edges have a boundary target and no positive
  target.

Thus q=19 contains a genuine single positive-overload `Rmax` exchange at
the root, followed immediately by boundary absorption.  It still supplies
no repeated positive-overload exchange layer.

## 4. Uniform obstruction

A residual mask of size ten corresponds to a twelve-cap after restoring
the two fixed opening points.  Since `Ω=0` is exactly `capOK`, the earlier
incidence theorem gives

```text
q <= binom(12,2) = 66.
```

Therefore no q=17/q=19 theorem whose conclusion is “the marked response
reaches this twelve-cap `Y_NK` boundary” can extend to every odd q.  A
uniform strict-overload proof must have growing exchange depth and must
certify positive-overload targets along the way.

This also corrects the interpretation of “selected size eight.”  It is not
evidence for a rank-three game threshold.  On the tested domains it is the
last pre-boundary layer of a small-field twelve-cap certificate.

There is a parity-refined uniform clock.  Let

```text
s_even(q) = the least even s with q <= binom(s,2).
```

Every play from the six-point escape root reaches only even cap sizes after
complete opponent/reply exchanges.  Consequently any strategy whose first
`Y_NK` state is obtained after `e` exchanges satisfies

```text
e >= (s_even(q)-6)/2.
```

Before the final absorbing exchange it must therefore certify at least

```text
max(0, (s_even(q)-8)/2)
```

positive-overload response targets.  This is asymptotic to
`sqrt(q/2)-4`.  At `q=67`, `s_even=14`: four exchanges are necessary and
the first three response targets must retain positive overload.  The current
q=17/q=19 maximal-drop data contain at most one consecutive positive-target
exchange, so the evidence gap is quantitative rather than merely verbal.

## 5. Reproduction

Working directory:

```text
/home/tavis/src/othello
```

Commands:

```text
python3 rust/scripts/c80_marked_head_orbits.py
python3 rust/scripts/c80_marked_head_orbits.py --check
python3 rust/scripts/c80_bulk_exchange_search.py --max-states 20000
python3 rust/scripts/c80_bulk_exchange_search.py --max-states 20000 --check
python3 rust/scripts/c80_incidence_packet_mine.py --check
```

Evidence:

- `rust/scripts/c80_marked_head_orbits.py`, 8,844 bytes,
  SHA-256
  `69c3459ef293486e8ce0bca7f42680ee3ad627ce2a7e85edc2ac8957e82b05d2`;
- `notes/2026-07-24-c80-marked-head-orbits.json`, 14,615 bytes,
  SHA-256
  `9ccb5a48c230169f5e7c71880f4cd4f8657870254870eb9b5f649bc268608002`;
- `rust/scripts/c80_bulk_exchange_search.py`, 9,989 bytes,
  SHA-256
  `7043bf7f6537a841252bb937ef2da186e876754c676ab9d9327546fdff7711d8`;
- `notes/2026-07-24-c80-bulk-exchange-search.json`, 1,291 bytes,
  SHA-256
  `915bfb3a5cbd1055af5f0f20f8c5aac55181bc8eda7bfe47d6baf5627697f0de`.

Both outputs are deterministic and their `--check` modes require
byte-for-byte equality.  The orbit checker independently implements the
symmetric-square action and verifies group size plus orbit--stabilizer for
every record; it has no second canonicalization implementation.  The bulk
checker reuses the previously checked `K_Ω` implementation, so kernel
membership itself is not independently reimplemented here.

## `ej` + `tt` closeout

The free upgrade is the exact explanation of the former size-eight signal:
it is the pre-boundary layer of a twelve-cap certificate.  That settles the
most tempting mystery and prevents a finite ceiling from being promoted
into a uniform bulk law.

The second free upgrade is the parity-refined absorption clock above.  It
turns “growing depth” into an exact minimum number of positive-target
obligations at each q.  Future probes should be judged against that clock;
another one-layer certificate has zero asymptotic decision value.

The Tao-style reformulation is now scale-sensitive.  A viable theorem
cannot be

```text
fixed head -> fixed-size Y_NK leaf.
```

It must instead produce a family `F_s` indexed by growing selected size,
with

```text
∀o, ∃p in R(S,o):
  Ω(S+o+p) < Ω(S) and S+o+p in F_{s+2},
```

and only invoke `Y_NK` once `s` crosses the square-root barrier.  The packet
may still be `Rmax`, but q=17/q=19 provide only one positive-target exchange
between them, not evidence for the required iteration.

The cheap symmetry hope is also settled.  Five marked orbits remain, and
most are rigid.  Further q=17 stabilizer mining will not manufacture a
uniform head law; any next attack must introduce algebra beyond transport.

## Mystery ledger

- **[SETTLED] How many intrinsic q=17 marked-head types remain?** Five under
  the full conic `PGL(2,17)` action.
- **[SETTLED negative] Does state symmetry determine the exceptional
  reply?** Only the four-record orbit has nontrivial state symmetry; eight
  records are rigid, and every marked-opponent stabilizer is trivial.
- **[SETTLED] Why did maximal drop become exact from selected size eight?**
  Every lower-kernel target in the exact q=17 closure is already at
  `Ω=0`; q=19 has the same boundary collapse from size six onward.
- **[SETTLED negative] Can that absorption be uniform in q?** No.  The
  target is a twelve-cap, so `capOK` forces `q<=66`.
- **[SETTLED] How much positive-overload survival is unavoidably needed?**
  At least `max(0,(s_even(q)-8)/2)` response targets before the absorbing
  exchange; this grows as `sqrt(q/2)`.
- **[OPEN — C80] Does a growing-depth positive-target maximal-drop exchange
  theorem hold?** Only the 116 covered q=19 root edges test one such
  exchange; no repeated layer is present.
- **[OPEN — C80] What algebraic invariant defines the growing survivor
  family `F_s`?** Neither overload scores nor conic stabilizers supply it.
- **[OPEN — C80/C82] What replaces the rigid five-type head at general q?**
  Counting remains gated until a q-uniform algebraic packet and a
  positive-target survival theorem are stated.

## Vibe

The finite picture is now cleaner but less optimistic: both apparent
compressions were small-field terminal phenomena.  The strict-overload
route remains logically viable only in a genuinely growing-depth form,
which is the hard theorem rather than a remaining cleanup.

go C80 cap formulate and falsify scale-aware positive-overload survivor
families beyond the twelve-cap absorption ceiling
