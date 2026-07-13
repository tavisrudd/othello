# Projectively completed cubic–axis RepairCodes — companion log

Append-only session history for
[`2026-07-13-projective-completion-repaircodes.md`](../2026-07-13-projective-completion-repaircodes.md).
The live handoff contains only the current claim and gate map.

## 2026-07-13 — lane opened

Allocated C111–C114 after a diagnostic q9 enumeration suggested that adding the omitted projective
twisted-cubic point gives a `[20,4,9]_9` seed with two repair types. The q9 numbers and proposed
general formulas remain evidence-only. The strict route is independent refutation, written proof,
Lean proof and axiom audit, bounded-support transfer, exact-claim literature review, then paper
promotion. The supplied 2015 *Open Problems in Coding Theory* survey was checked: it supplies broad
code/design, projective/MDS, and TVZ context but does not discuss locality, repair hypergraphs,
matroid ports, or the twisted-cubic-axis union; its silence is not novelty evidence.

## 2026-07-13 — C111 parameter slice

Added `FiniteGeom/ProjectiveAxisTwistedCubic.lean`. The proof explicitly separates finite cubic
parameters from cubic infinity. If infinity lies in the plane, the finite section reduces to a
degree-two moment-curve section; if the plane contains the axis, Frobenius injectivity and the
finite/infinity cross-case give at most one projective cubic point. The maximum section remains
`q+2`, the length is `2q+2`, and the module derives dimension four and distance `q`.

Focused validation:

```text
choom -n 1000 -- nix develop --command lake env lean \
  FiniteGeom/ProjectiveAxisTwistedCubic.lean
```

passes. `#print axioms` for the full-cubic section bound, completed-system section bound, and
bundled code parameters reports only `propext`, `Classical.choice`, and `Quot.sound`. C111 remains
open: projective distinctness, dual distance, independent small-field replay/mutations, aggregate
wiring/build, scans, and xhigh review are not yet done.

## 2026-07-13 — Discovery Track register established

The live register is reserved for incidental mathematical findings encountered during execution,
not planned deliverables or progress records. Its first entry is D-PC9, the exact five-section/
five-weight distribution suggested by the independent C111 replay.

## 2026-07-13 — D-PC9 exact section-distribution candidate

The independent q=3,9,27 replay returned projective plane-section distributions

```text
q=3:  {1:8,    2:12,   3:12,  4:4,    5:4}
q=9:  {1:240,  2:360,  3:90,  4:120, 11:10}
q=27: {1:6552, 2:9828, 3:756, 4:3276, 29:28}
```

These agree exactly with
`N1=q(q²-1)/3`, `N2=q(q²-1)/2`, `N3=q(q+1)`, `N4=q(q²-1)/6`, and
`N(q+2)=q+1`. The verifier now asserts those formulas. Since nonzero scalar multiples of a plane
form give distinct codewords and the message map is injective, the conjectural ordinary weight
enumerator has five nonzero weights and exactly `(q-1)(q+1)=q²-1` minimum-weight words. A general
proof should follow from the zero-through-third plane-section moments: all triples except the
all-axis triples span a unique plane, while an axis triple lies in `q+1` planes. This is CHECKED
finite evidence only until XH7, Lean, and literature gates pass.

## 2026-07-13 — C111 closed after XH1

Completed the strict-trust seed layer in `FiniteGeom.ProjectiveAxisTwistedCubic` and
`RepairCodes.ProjectiveAxisTwistedCubic`. In addition to the parameter theorem, the final geometry
module proves that every nonzero plane containing the axis meets the projective cubic in exactly
one point. The code layer proves nonzero columns, pairwise projective distinctness via linear
independence, an explicit axis-triple dual word, and exact global dual distance three.

The XH1 audit reviewed the finite/infinity section split, all cubic/cubic, cubic/axis, and axis/axis
pair cases, the explicit word support, and the q=3 boundary. No repair-port classification or
D-PC9 weight distribution was used to close C111.

Validation passed:

```text
choom -n 1000 -- nix develop --command lake build \
  FiniteGeom.ProjectiveAxisTwistedCubic RepairCodes.ProjectiveAxisTwistedCubic RepairCodes

python3 notes/2026-07-13-projective-completion-verifier.py
q=3:  n=8  rank=4 max_section=5  d=3  forms=40    distribution={1:8, 2:12, 3:12, 4:4, 5:4}
q=9:  n=20 rank=4 max_section=11 d=9  forms=820   distribution={1:240, 2:360, 3:90, 4:120, 11:10}
q=27: n=56 rank=4 max_section=29 d=27 forms=20440 distribution={1:6552, 2:9828, 3:756, 4:3276, 29:28}
```

The verifier also passed coordinate conjugation, deletion back to the affine seed, duplicate
mutation rejection, and a nonduplicate spectrum-changing mutation. The relevant forbidden-token
scan (`sorry`, `admit`, `native_decide`, `unsafe`) and `git diff --check` were empty. Printed axiom
reports contain only `propext`, `Classical.choice`, and `Quot.sound`.

## 2026-07-13 — C112 projective-boundary circuit slice

Added `FiniteGeom.ProjectiveAxisTwistedCubicCircuits`. For distinct finite parameters `s,t`, it
proves directly that the family consisting of cubic `s`, cubic `t`, cubic infinity, and the finite
axis point `s+t` is dependent, that deleting any member leaves an independent triple, and that no
other normalized axis point makes the four-family dependent. This closes the circuit case absent
from the affine module; it does not yet assert completeness of either radius-three repair clutter.

Focused validation passes, and both printed headlines use only `propext`, `Classical.choice`, and
`Quot.sound`:

```text
choom -n 1000 -- nix develop --command lake env lean \
  FiniteGeom/ProjectiveAxisTwistedCubicCircuits.lean
```
