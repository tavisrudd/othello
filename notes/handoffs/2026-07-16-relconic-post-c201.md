# Relative-conic lane after C201

**Lane**: `relconic`

**Date:** 2026-07-16
**Status:** C210 ACTIVE — coverage candidate-hypergraph gate

## Current state

C201 is reported as a negative bounded mechanism gate.  Its archived handoff
is [`done/2026-07-16-c201-even-field-quadratic-rank.md`](done/2026-07-16-c201-even-field-quadratic-rank.md),
and the final synthesis is
[`2026-07-16-c201-bounded-mechanism-closure.md`](../2026-07-16-c201-bounded-mechanism-closure.md).
The tested q=64 families fail at coverage before quadratic rank becomes
informative.  C209 therefore remains dormant.  C210 inherits only the bounded
“coverage first, rank second” design lesson.

The current manuscript was not edited by C201.

C154 is now reported in
[`2026-07-16-c154-reed-muller-deep-holes.md`](../2026-07-16-c154-reed-muller-deep-holes.md).
The dedicated Reed--Muller pass found exact descriptions by bent functions, Hamming association
subschemes, explicit maximizers, and affine/coset types, but no complete deep-hole locus equal to
the full rational-point set of a named positive-dimensional variety.  The precise bounded-audit
novelty posture survives.  The paper needed no claim-boundary change; its conclusion received one
independent proof-stage copyedit requested by the user.

C144 is reported in
[`2026-07-14-c144-shared-library-gate-architecture.md`](../2026-07-14-c144-shared-library-gate-architecture.md).
Import-only validation targets now separate the relconic, Baer, and alternate-orbit closures; the
alternate-orbit lane uses three compatible modules because its independently compiled terminals
cannot all share one Lean environment. Build orchestration and notification mechanics remain owned
by the `build-sys` lane.

## Recommended order

1. **C210 — square-root construction program.**  The initial mechanism audit proves an
   infinite-family obstruction for arcs contained in one Baer subplane and selects the genuinely
   Baer-transversal route. The first two-layer parabola family is a uniform conic-disjoint `2s`-arc
   and an ordinary complete 6-arc at `s=3`, but direct relative coverage fails for `s=4,5,7,8`.
   Greedy completion remains near `3s` in the larger tested fields. A full parabola repair layer on
   a nontrivial additive coset succeeds sporadically at `s=5`, nearly succeeds at `s=4`, but has no
   arc-legal instance at `s=7`; that uniform mechanism is closed. Next derive the collision and
   coverage equations for a graph or partial-coset repair of at most `s` points. Those equations
   now reduce internal arc legality to the second-divided-difference condition
   `1+g[r,s,u] != 0`; full affine-height graphs add nothing beyond the constant layers throughout
   the five tested orders. For quadratic heights, each
   two-repair/one-seed collision is equivalent to one subfield quadratic splitting distinctly.
   Twelve genuinely nonlinear `3s=24` repair arcs survive at `s=8`, all with nineteen uncovered
   points; two points at infinity complete the best to an ordinary 26-arc. No nonlinear layer
   survives at `s=3,4,5,7`. Exact conic-stabilizer recognition gives three orbits of four, generated
   internally by subfield translations. All nineteen uncovered points lie at infinity, so these
   are complete affine 24-arcs and any two missing directions give ordinary complete 26-arcs. A
   uniform characteristic-two version would yield the target `3s+2` construction. Next derive its
   affine-coverage and arc conditions as trace identities in `lambda=a/b`. Same-layer chord values
   now have the exact split-polynomial trace description `S_U={Up+q:p!=0, tr(q/p^2)=0}`. The unique
   minimal q=64 coverage route is `AA,AB,AR,BB,BR`, so repair--repair secants can be omitted from the
   coverage proof. Next show that the complement of `AB,AR,BR` lies in the two seed translates of
   `S_y`. The first orbit admits a complete trace parametrization, but its natural `GF(8)` scalar
   extension is obstructed for every `s>=16`: a one-repair collision is forced by a nonzero
   `z` with `tr(z)=tr(z^(-1))=0`, and the Kloosterman/Weil count guarantees such `z`. The other two
   q=64 orbits now have explicit `GF(8)+GF(8)*omega` normal forms. After sending the roots of each
   forced pair-sum polynomial to `0,1`, all six orbit/seed collision gates reduce to the same
   `tr(1/(x^2+x))=0` condition. Hence all three direct full-domain scalar extensions have the same
   Kloosterman obstruction. The mandatory same-seed deletions for a partial domain are now exact:
   the two bad sets are translates of
   `B_s={x!=0,1:tr(1/(x^2+x))=0}` by `delta=tau,tau^6,tau^5` in the three orbits. Their union has
   size `3s/4+O(sqrt(s))`, leaving at most `s/4+O(sqrt(s))` repair parameters before the other arc
   gates. The mixed-seed variables now eliminate to one explicit quintic `M(r,d)` for each repair
   parameter. As a curve in `(r,d)`, it is geometrically irreducible: in the `r` coordinate it is a
   separable additive quartic, and the rational right side has an odd order-three pole. This rules
   out component-level forced collisions but does not yet prove that rootless quintic fibers meet
   the two same-seed trace complements in positive density. The monodromy calculation now closes
   that gap: eight simple branch values give transposition inertia and force full `S5`, while the
   two same-seed Artin--Schreier characters are ramification-independent from its sign cover. The
   joint group is `S5 x C2 x C2`, so Chebotarev gives a domain of
   `11s/120+O(sqrt(s))` parameters surviving every one-repair collision gate along
   `F=GF(8^m)`, odd `m`. The two seed-colored two-repair/one-seed collision graphs each have maximum
   degree three: their equations are linear in the second repair parameter and eliminate to a
   cubic in the seed parameter with nonzero leading coefficient. Their union therefore has maximum
   degree six, and a greedy independent set leaves at least
   `11s/840-O(sqrt(s))` repair points. Together with the quadratic divided-difference condition,
   this closes every arc-legality gate for the partial-domain mechanism. Next analyze affine
   coverage after this thinning; in particular, determine whether seed--repair secants from such a
   sparse domain can cover the residue left by the two full seed layers. The exact q=64 audit shows
   that naive thinning fails maximally: among 288 seed-uncovered affine targets, 80 have singleton
   repair candidates, every repair parameter is forced by at least eight targets, and only the full
   repair layer covers. The general seed--repair collinearity condition splits into two cubic
   coordinate equations in `(r,t)`. Their common components are now completely classified: the
   only positive-dimensional cases are targets on the repair graph or on a seed layer, and a short
   coefficient comparison rules out every quadratic component uniformly. Generic targets have at
   most nine candidates per seed color. A repair target has candidate hyperedge exactly
   `{r} union N_A(r) union N_B(r)`; after restricting to the one-repair survivor set, every maximal
   independent set in the induced degree-six collision graph covers all required repair targets
   automatically. The q=64 non-repair singleton targets now give a much stronger extension
   obstruction. Their two seed-color elimination schemes have extra odd closed-point degrees only
   `3`, `5`, and `7`; for every repair parameter there is a forcing target of each pure type.
   Hence affine coverage forces the full repair layer whenever `105` does not divide the odd
   extension degree `m`, while that full layer is collision-obstructed for `m>1`. The only surviving
   scalar-extension frontier is the infinite sub-tower `105 | m`. Next compute the candidate
   hyperedges over the degree-`3`, `5`, and `7` residue fields and test their compatibility with
   the collision graph symbolically. Do not run a `GF(8^105)` plane census. See
   [`2026-07-16-c210-square-root-mechanism-audit.md`](../2026-07-16-c210-square-root-mechanism-audit.md).

## Entry action

If the user selects `relconic`, C188 and C223 need no residual work. Read the nested Lean guide
before any new Lean edit, generator run, build, or staleness probe.

## Durable companions

- lane discovery track (incidental observations only):
  [`2026-07-16-relconic-discovery-track.md`](../2026-07-16-relconic-discovery-track.md)
- C210 mechanism notebook (legacy filename; task history, not a discovery track):
  [`2026-07-16-c210-discovery-track.md`](../2026-07-16-c210-discovery-track.md)
- C201 mechanism-audit notebook (legacy filename; task history, not a discovery track):
  [`2026-07-16-c201-discovery-track.md`](../2026-07-16-c201-discovery-track.md)
- live global queue:
  [`2026-07-07-codex-task-queue.md`](../2026-07-07-codex-task-queue.md)
- prior aggregate relconic map:
  [`2026-07-13-relative-conic-arcs-strengthening.md`](2026-07-13-relative-conic-arcs-strengthening.md)
