# C80 canonical status ledger

**Lane:** `cap`. **Task:** C80. **As of:** 2026-07-26.

This is the single current truth ledger for C80. The projective-cap handoff
remains the program-level routing map; individual reports remain the evidence
and reproduction record. When prose elsewhere is shorter or older, use this
ledger's status labels and then consult the linked report.

The labels are strict:

- **PROVED:** field-uniform mathematical argument, with Lean status stated
  separately where applicable.
- **FINITE-CERTIFIED:** exhaustive on the named frozen domains only.
- **SETTLED NEGATIVE:** a proposed statement has a proof or an explicit
  certified counterexample.
- **OPEN:** not proved and not disproved.
- **SUPERSEDED:** useful historical route whose proposed conclusion is no
  longer live.

The cross-project
[`2026-07-25 results summary snapshot`](2026-07-25-results-summary-snapshot.md)
is an input bank, not C80 status authority.

## What works

| result | status | exact scope |
| --- | --- | --- |
| `Y_NK` boundary law | **PROVED** | Under `capOK`, the residual game is Node--Kayles on the full legal conflict graph, so P is equivalent to Grundy zero. The mathematical proof is reviewed; no claim here of a completed Lean formalization. [Proof](2026-07-23-c523-ynk-guard-proof.md) |
| Secant size barrier | **PROVED** | An `s`-cap with `capOK` forces `q <= binom(s,2)`; hence no fixed-size route to `capOK` can be uniform. [Report](2026-07-24-c80-capok-depth-obstruction.md) |
| Absorption clock | **PROVED** | Total capacity-two overload `Omega` is the exact well-founded absorption coordinate; the simpler secant-barrier split is not sufficient. [Report](2026-07-24-c80-secbarrier-survival-absorption.md) |
| Strict-overload kernel `K_Omega` | **PROVED definition/induction; FINITE-CERTIFIED entry gates** | The maximal value-independent survivor defined from `Y_NK` is P by well-founded induction. Exact q5/q7/q13/q17 gates pass. [Report](2026-07-24-c80-strict-overload-kernel.md) |
| Exact residual exchange transform | **PROVED** | The depth-free transform absorbs historical pencils into pair-conflict and active capacity-two blocks and is an exact game-tree morphism. It is not yet a useful finite-dimensional quotient. [Report](2026-07-25-c80-residual-exchange-morphism.md) |
| Adaptive copycat boundary `B_cc` | **PROVED as a structural sufficient boundary; FINITE-CERTIFIED reach** | Replaces the finite Grundy oracle on the visited q13/q17 leaves; the first q19 boundary probe is positive. This does not prove uniform reach from escape roots. [Report](2026-07-25-c80-adaptive-copycat-survivor.md) |
| q17 frozen descent | **FINITE-CERTIFIED** | The q17 three-intruder domain closes by depth-two routing into `Y_NK`; q13/q17/q19 data do not prove uniform bounded depth. [Report](2026-07-23-c524-capover-core-depth2.md) |
| Marked q17 defect thread | **FINITE-CERTIFIED** | Four bad fibres form one Klein-four orbit with common Gallai--Edmonds type and an adaptive `4 -> 2 -> 0` repair thread. [Report](2026-07-25-c80-tutte-defect-contraction.md) |
| Tangent-plus-triple coverage identity | **PROVED; FINITE-CERTIFIED value census** | `kappa_T(x,y)=|Legal(T+x+y)|` has an exact pair-conflict plus collinear-triple formula. Minimum-`kappa` replies are value-unsound at q17/q19. [Report](2026-07-25-c80-tangent-triple-coverage-datum.md) |
| Uncovered-locus boundary rewrite | **FINITE-CERTIFIED; SUPERSEDED packaging** | The q17 small loci are classified exactly. Rank-zero `B_cc`, plus one direct exchange for four q19 fibres, gives an opponent-complete value-pure correspondence: `49/49 P` at q17 and `67/67 P` at q19. Its explicit witnesses are superseded by `R_small` below. [Report](2026-07-25-c80-uncovered-locus-boundary-rewrite.md) |
| Bounded small-shell correspondence `R_small` | **PROVED soundness; SETTLED NEGATIVE uniformly** | The fixed incidence formula eliminates explicit `B_cc` pairings and gives `49/49 P` q17 and `69/69 P` q19 selected edges. The first q23 P control has `0/118` coverage, and all 181 replies to root opponent `(0,0)` miss the survivor. [Positive finite gate](2026-07-25-c80-q19-rank-one-incidence-shell.md), [q23 falsifier](2026-07-25-c80-q23-small-shell-falsifier.md) |
| q23 defect-three update | **PROVED sound for one target; FINITE-CERTIFIED** | The unique minimum-defect follower has a three-point noncollinear mutually legal defect locus. Every defect move has two replies sending rank `3 -> 0`; with direct boundary replies elsewhere this gives `24/24` coverage and 50 sound edges. [Report](2026-07-25-c80-q23-defect-three-update.md) |
| q23 recursive defect-rank survivor | **PROVED soundness; FINITE-CERTIFIED reach** | The well-founded `F_d` survivor uses `d=|Def|`, the `B_small` boundary, and strict defect-rank replies. All 118 outer fibres of the normalized q23 control enter `F_d`; 24,568 ranked states and 25,479 defect obligations are checked without minimax or the C54 value label. [Report](2026-07-25-c80-q23-defect-rank-descent.md) |
| q23 rank-zero correspondence `R0` | **PROVED soundness; FINITE-CERTIFIED exact compression on ten controls; FIRST FAILURE FOUND** | `R0(T;o,p)` requires every defect of `T+o+p` to have a reply to defect rank zero. It equals `F_d` exactly on the first ten canonical controls: 1,163/1,163 fibres, 12,496 common edges, and 77,632 candidates. The eleventh control `(6,5)` has the first `F_d\R0` edge, `(12,20)->(16,15)`, at rank 30 and `Omega=72`. Its sole direct failure is defect move `(14,3)`; recursive reply `(18,21)` drops to a rank-one, `Omega=1` `R0` state. Thus `R0` remains the base packet but is not the full recursive survivor even at q23. [First four controls](2026-07-25-c80-q23-fourth-control-rank-zero.md), [canonical sweep and first failure](2026-07-25-c80-q23-canonical-rank-zero-sweep.md) |
| Obligation-deletion survivor `F_del` | **PROVED soundness; SETTLED NEGATIVE as an exact `F_d` compression** | Require `Def(S+x+y)⊊Def(S)` at every defect response. Finite-set induction proves the hereditary survivor P. It equals `F_d` on the first rank-30 target and every outer target of the next nine canonical controls, but fails first at control index 20: the unique `F_d` response to one obligation sends rank `27→2`, removes 26 old defects, retains one, and creates one replacement. The successor is already in `F_del`, so literal inclusion—not descendant complexity—is exactly the obstruction. [Positive target](2026-07-26-c80-q23-obligation-deletion-rewrite.md), [first failure](2026-07-26-c80-q23-obligation-deletion-sweep.md) |
| Replacement lineage and ancestral charge | **PROVED sound for one marked projective type; FINITE-CERTIFIED** | The replacement is created by the opponent half-move alone. Its unique former `B_small` certificate loses one endpoint on a newly saturated selected secant; the boundary pair transports `{w,q}->{w,z}`, with `z=line(q,p)∩line(r,h)`. Transporting the played obligation's ancestral label to `z` makes label support drop `27→2`. Together with 26 ordinary deletion fibres, this covers all 27 fibres of the marked root, whose successor is in `F_del`. The next exact replacement edge has the same injective update and bounded flag, but a unique `PGL_2(23)` transporter carries its complete marked data to the first edge: it confirms equivariance without adding a second type. Direct determinant replay independently agrees. Uniform injective ancestry beyond this orbit and a bounded-format update remain open. [First edge](2026-07-26-c80-q23-replacement-lineage.md), [next edge and orbit check](2026-07-26-c80-q23-next-replacement-ancestry.md) |

These results provide a sound boundary, a well-founded rank, and an exact
continuation object. They do **not** yet provide the uniform
`for every opponent, choose a sound lower-rank reply` theorem needed by C80.

## What has been proved to fail

| route or claim | status | decisive obstruction |
| --- | --- | --- |
| Uniform fixed-depth routing into `capOK`/`Y_NK` | **SETTLED NEGATIVE** | The secant size barrier forces growing selected-set size. |
| Secant barrier alone implies survival/P | **SETTLED NEGATIVE** | It is necessary, not sufficient; post-barrier `capOK` need not be P. |
| `Y_NK0` as complete descent boundary | **SETTLED NEGATIVE** | It misses the full-graph guard and leaves certified N gaps. [C522](2026-07-23-c522-ynk0-descent-completeness.md) |
| Bounded gadget or conic-type Grundy law | **SETTLED NEGATIVE** | Gadget count/size grow and the conic-type census is value-mixed. [C528](2026-07-23-c528-overload-profile.md) |
| Fixed finite exact residual signature | **SETTLED NEGATIVE** | Sealed conic subsets already give an unbounded number of P-valued `Y_NK` heights. [Report](2026-07-25-c80-finite-signature-no-go.md) |
| Arbitrary fixed-dimensional unbounded-range coding as a crown | **SETTLED VACUOUS** | A natural number can encode the whole residual, so existence without an information/update restriction proves nothing. [Report](2026-07-25-c80-unbounded-coordinate-congruence.md) |
| Pure-extension/even-faceted ranked survivor | **SETTLED NEGATIVE** | False at every q13/q17 escape root. [Report](2026-07-25-c80-pure-extension-survivor.md) |
| Persistent normalized marked-secant class | **SETTLED NEGATIVE** | Fails at the first q17 persistence gate. [Report](2026-07-25-c80-marked-secant-profile-persistence.md) |
| Forgetful cross-depth retraction | **SETTLED NEGATIVE** | Every tested positive lower-kernel reply creates new marked-pencil data that cannot be forgotten. [Report](2026-07-25-c80-exchange-retraction-falsifier.md) |
| Clean positive matching lift at every rank | **SETTLED NEGATIVE** | Four q17 fibres have Tutte deficiency two; adaptive exchange repairs only the finite thread. [Report](2026-07-25-c80-positive-pairing-shell.md) |
| Coupled overload-retention/Tutte-excess scalar bank | **SETTLED NEGATIVE** | Raw strict-reply graphs have zero excess and q17 decoys retain more overload than repairs. [Report](2026-07-25-c80-coupled-overload-tutte-bank.md) |
| Feature thresholds / marked-secant profile selector | **SETTLED NEGATIVE as tested class** | Repairs separate diagnostically from spoilers, but low-dimensional thresholds are impure or interpolate the finite sample. [Report](2026-07-25-c80-marked-secant-spoiler-repair-compare.md) |
| Sparse-complement minimum-degree closure | **SETTLED REDUNDANT** | The proposed survivor equals `F_cc`; its positivity condition already implies the measured lower bound. [Report](2026-07-25-c80-sparse-complement-node-kayles-lemma.md) |
| Live-secant equivariant correspondence | **SETTLED NEGATIVE** | q17 fibres are `1 P + 22 N`; q19 is `39 P + 8 N`. Equivariance does not give soundness. [Report](2026-07-25-c80-equivariant-live-secant-correspondence.md) |
| Central-involution and history-torus rewrites | **SETTLED NEGATIVE** | q17 has no usable central replies; the enlarged torus relation is incomplete and value-impure. [Central](2026-07-25-c80-central-involution-rank-datum.md), [history](2026-07-25-c80-history-torus-obligation-rewrite.md) |
| Clebsch conic-matching quotient bridge | **SETTLED NEGATIVE** | Legal moves induce no matching on selected marks; live marks have negligible coverage; the full-conic degree grows with q. [Report](2026-07-25-c80-continuation-conic-matching-bridge.md) |
| Greedy minimum continuation deficiency | **SETTLED NEGATIVE** | Exact `kappa` minimizers are mostly N on the q17 isolates and q19 control. [Report](2026-07-25-c80-tangent-triple-coverage-datum.md) |
| Uniform bounded small-shell coverage | **SETTLED NEGATIVE** | On the q23 P target `S4(1,2,3,4)+(0,0)+(5,2)`, no opponent has an `R_small` reply (`0/118`); no alternative root reply after `(0,0)` enters the survivor (`0/181`). [Report](2026-07-25-c80-q23-small-shell-falsifier.md) |
| Greedy recursive minimum-defect choice | **SETTLED NEGATIVE on the q23 control** | Only 27/118 outer fibres have a recursively sound minimum-rank reply. The first greedy branch reaches a rank-one state whose unique defect opponent has three replies and minimum successor rank one; a nonminimum outer reply restores descent. [Report](2026-07-25-c80-q23-defect-rank-descent.md) |
| Defect-rank/degree extremal selectors | **SETTLED NEGATIVE on the q23 control** | Maximizing rank, descent degree, total descent edges, rank-drop margin, or defect-deletion updates covers only 31--62 of 118 fibres. The full bounded incidence relation `R0`, not a scalar extremum, is required. [Report](2026-07-25-c80-q23-rank-zero-correspondence.md) |
| Strict obligation deletion as the full defect-rank proof object | **SETTLED NEGATIVE on the canonical q23 sweep** | After nine complete later controls and 11,075 common `F_d/F_del` edges, control index 20 contains the first `F_d\F_del` target. Its blocking obligation has a unique `F_d` reply, and that reply necessarily creates one new defect while dropping rank `27→2`. [Report](2026-07-26-c80-q23-obligation-deletion-sweep.md) |

These negatives rule out the named statements and natural domains. They do
not prove that every bounded-formula proof object or every value-only factor
is impossible.

## Tried, informative, but still unresolved

| object/question | current evidence | missing theorem |
| --- | --- | --- |
| Scale-aware survivor `F_alpha` | **FINITE-CERTIFIED:** `F_1/4` contains tested q11/q13/q17 roots; q19 passes through `alpha=3/4` and fails at `9/10`. | A q-independent positive retention bound, or a proof that none exists. [Reports](2026-07-24-c80-scale-survivor-falsifiers.md), [marked retention](2026-07-25-c80-marked-secant-retention.md) |
| `B_cc` reach from escape roots | Boundary itself is sound and finite probes pass. | Uniform growing-depth routing into `B_cc`. |
| Ranked survivor `F_q` | Required interface is clear: direct, nonrecursive, strict-`Omega`, and P-sound. | An opponent-complete reply theorem independent of lower-survivor/minimax queries. |
| Equivariant bounded-formula reply correspondence | `R_small` is projective, fixed-arity, and sound, but q23 disproves coverage. | A growing-rank update, not another fixed shell. |
| q23 ancestral-label survivor | The first two exact replacement edges have direct incidence lineages and injective label updates: the played old obligation labels the unique new defect, label support drops `27→2`, and all 27 marked-root fibres close. The second complete marked flag is the unique projective transport of the first, so only one marked projective type has been tested. | Canonicalize later replacement flags and find the first new marked projective orbit; test it for branching, ancestry collisions, and the bounded endpoint-transport construction. Then state a bounded-format uniform update without an explicit growing label table. |
| C82 abundance | No counting problem is released yet. | First obtain C80's sound opponent-complete geometric fibres; only then count projected replies. |

## Current frontier

The live C80 statement is:

```text
Find the first q23 replacement edge outside the known marked projective
orbit and test injective ancestral-label transport there.
```

The immediate compression test is narrower:

```text
The first two exact replacements are explained by the same bounded projective
flag and strict ancestral-label charge, and the second complete marked flag
is the unique projective transport of the first. The next compression test
must quotient later replacement edges by marked projective transport, stop
at the first new orbit, and ask whether every new defect injects into a
consumed old label by the same incidence-defined transport. Branching,
ancestry collision, or the absence of a bounded projective flag is the
decisive falsifier.
```

Do not promote a finite q17 selector, a value/minimax lookup, an explicit
`Theta(q)` exception list, an arbitrary encoding of the whole residual, or
another scalar threshold fit. None meets the proof-object interface.

## Maintenance rule

Update this file whenever a C80 experiment changes a label, closes an open
row, or introduces a genuinely new live route. Detailed reports should link
back here; the program handoff should carry only a concise delta and a link.

go C80 cap find the first projectively new q23 replacement edge and test ancestral charge
