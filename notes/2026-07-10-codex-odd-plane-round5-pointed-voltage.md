# Odd projective cap game — Codex round 5: pointed voltage and the trace-information sandwich

**Date:** 2026-07-10
**Scope:** read-only use of committed q<=19 S4 summaries; three independent delegates; no q=25
solve or census work; no claim of a uniform proof.  All reproduction commands below are run from
`rust/`.

## Executive result

This round does not prove the odd-plane theorem.  It does replace the informal phrase
“voltage-aware state” by an exact object, proves what information that object must contain, and
closes two tempting but opposite false endpoints.

1. **[PROVED]** At a symmetric `d=4` checkpoint, the cap continuation game is exactly the
   independence game of a rank-at-most-three `C_2`-gain clutter.  The nonfixed part is classified
   by a cohomology class in the incidence graph; fixed hyperedges are precisely marked fiber
   pairs.
2. **[LITERATURE-IMPORTED / PROVED]** Zaslavsky's switching theorem makes cycle voltage the
   complete invariant of the unbranched cross-defect double cover.  Once a move distinguishes
   actual sheets, the complete switching invariants are those cycle voltages plus relative phases
   of the marked lifts.
3. **[PROVED]** This exact quotient is not a dynamic compression: it has four occupancy states per
   two-point fiber, hence `4^n=2^(2n)` states, and legal words of length at most three recover the
   entire continuation clutter.
4. **[REFUTED]** The exact *live* signed boundary cover, including its complete voltage class, does
   not determine game value.  At q=11 there is an explicit P/N pair with isomorphic live covers
   and identical static boundary games.
5. **[REFUTED AS NEW SIGNAL]** Adding the entire old deletion trace separates every tested value
   at q=11,13,17, but an exact PGL audit shows why: each such colored signature is contained in a
   single full `PGL(3,q)` orbit of the selected six-cap.  Its purity is therefore ordinary fixed-q
   transport in disguise, not a new locality theorem.
6. **[COMPUTED-EXACT]** The static-boundary game has SG 2 on some q=11 centers, but every tested
   q=13 center has SG 0, including 69 P and 15 N full children.  Static SG is not the missing
   coordinate.

The resulting **information sandwich** is the strongest progress of the round:

```text
live voltage cover                         complete trace-colored cover
too coarse: exact q=11 P/N collision       too fine: refines full PGL six-cap orbit
                  \                         /
                   missing: a strict trace-attachment quotient
                   with a constructive closed reply theorem
```

This narrows the `d=4` defect-switch problem to one precise question: which relative attachment
phases of the old secant trace must be retained to prove reply closure, without reconstructing the
whole projective position?  It does not settle the separate `d=5` lane and does not assume `(ON)`.

The input q=25 checkpoint was 13/28 buckets, all P, with `min-witness(25)>=4`; this round used that
fact nowhere and launched no q=25 process.

## 1. The exact continuation clutter

Let `T` be a selected cap and let `V_T` be the projective points legal over `T`.  Define the
**continuation clutter** `H_T=(V_T,E_T)` by taking the inclusion-minimal future obstructions:

- `{x,y}` is an edge when `x,y` are individually legal but their joining line contains a point of
  `T`;
- `{x,y,z}` is an edge when the three points are collinear and none of their pairs is already an
  edge.

### Lemma 1 — rank-three continuation equivalence

**[PROVED]** A set `A subset V_T` can be selected after `T`, in any order, exactly when `A` is
independent in `H_T`.  Moreover `H_T` has rank at most three.

**Proof.** A future violation of cap legality contains a collinear triple.  If at least one member
is already in `T`, the two future members contain a two-edge; otherwise the three future members
contain a three-edge.  Conversely, each declared edge produces such a collinear triple.  Cap
legality is hereditary, so an independent set can be played in any order.  No minimal obstruction
has more than three members. `square`

At the round-3 `d=4` checkpoint, the normalized selected set is

```text
S_a={C(0), C(+r), C(-r), C(+s), C(-s), z_a},
sigma(X:Y:Z)=(X:-Y:Z).
```

The fixed axis contains `C(0),z_a`, and the center is already on a selected antipodal chord.
Thus every fixed point is unavailable and `sigma` acts freely on `V_T`.

## 2. Exact `C_2`-gain-hypergraph reconstruction

Let `n=|V_T/sigma|`.  For every nonfixed hyperedge orbit `{e,sigma(e)}`, choose a lift `e_0`; for
every point orbit choose a `+` lift.  Form the bipartite incidence multigraph `B` whose nodes are
point orbits and nonfixed hyperedge orbits.  Label an incidence `(v,e)` by

```text
gamma(v,e)=0 if e_0 contains v_+,
gamma(v,e)=1 if e_0 contains v_-.
```

Changing a point representative toggles all incidences at its point node.  Changing the chosen
hyperedge lift toggles all incidences at its edge node.  These are exactly vertex switchings of
`B`.

### Theorem 2 — reconstruction and voltage rank

**[PROVED]** The quotient incidence multigraph, the switching class

```text
[gamma] in H^1(B;F_2),
```

and the marked fixed-fiber edges reconstruct `H_T` up to equivariant isomorphism.  If `m_2,m_3`
are the numbers of nonfixed edge orbits of sizes two and three and `c` is the number of incidence
components, then

```text
dim H^1(B;F_2)=m_2+2m_3-n+c.
```

**Proof.** The incidence graph has `n+m_2+m_3` nodes and `2m_2+3m_3` incidence edges, so its cycle
rank is the displayed number.  Given `gamma`, the two lifts of an edge node are

```text
e_t={v_(t+gamma(v,e)) : (v,e) is an incidence},  t in F_2.
```

Switching changes only the chosen representatives.  Conversely, every nonfixed lifted edge is
recovered by this formula.  With a free vertex involution, an invariant edge of size at most three
can only be a two-point fiber `{v_+,v_-}`; an invariant three-set would require a fixed vertex.
Recording those fiber edges completes the reconstruction. `square`

### Important two-line correction

The deck orbits lie **within** each defect line, not one point on each line.  Since `D_0` already
contains selected `C(0)`, every two distinct live points of `D_0` are incompatible; the same holds
on `D_a` through selected `z_a`.  Consequently every live fiber on either line is itself a fixed
two-edge, and two distinct same-line fibers carry both the parallel and crossed edge orbits.

An initially proposed specialization that replaced these cliques by one unbranched `K_n` lift was
therefore rejected in root audit.  Zaslavsky's ordinary-cover theorem applies directly to the
nonfixed **cross-defect** part; the same-line cliques and fiber edges must remain marked structure.

## 3. Exactness is not compression

### Theorem 3 — strong game-tree isomorphism

**[PROVED]** Give each quotient fiber an occupancy

```text
eta(vbar) in {empty,{+},{-},{+,-}}.
```

Using Theorem 2 to test lifted hyperedges gives a move-labeled game tree isomorphic to the original
continuation game, hence the same SG value.

This uses `4^n=2^(2n)` states, exactly the occupancy count of the `2n` lifted points.  At a symmetric
checkpoint only `empty` and `{+,-}` occur, but one opponent move immediately creates a singleton
sheet and restores the missing bit.

There is also an information lower bound.  The labeled legal words of length at most three recover
every edge of `H_T`: a set of size at most three is a minimal edge exactly when all proper prefixes
are playable and the whole set is not.  Therefore any exact move-labeled bisimulation determines
the full continuation clutter.  Another exact isomorphism can change coordinates; it cannot by
itself supply the strategy compression still needed.

## 4. Literature import and pointed-cover normal form

### 4.1 Zaslavsky's double-cover theorem

**[LITERATURE-IMPORTED]** Thomas Zaslavsky, “Signed graphs,” *Discrete Applied Mathematics* 4
(1982), 47–74, Theorem 6.3,
[DOI](https://doi.org/10.1016/0166-218X(82)90033-6).

For a fixed unsigned graph `Gamma`, fibered-isomorphism classes of unbranched double covers
`p:Gamma_tilde -> Gamma` are in bijection with switching classes of signatures on `Gamma`.
The hypotheses are that `p` is onto, two-to-one, and a local graph isomorphism; cover
isomorphisms commute with projection.  The published erratum does not alter Theorem 6.3.

**Translation.** On the live cross-defect incompatibility graph, `sigma` is free on vertices and
nonfixed edges.  Hence the quotient graph plus one `F_2` voltage per fundamental cycle is the
complete static invariant over that quotient.  This resolves the “what datum does an ordinary
orbit quotient forget?” obligation exactly.

**Applicability gap.** The full boundary graph has fixed fiber edges, and a real move marks a
specific lift.  It is therefore a branched/pointed object, not an unbranched static cover.  The
theorem classifies it only after those extra marks are retained separately; it supplies no P-value
or reply.

### 4.2 Pointed-cover normal form

Let a connected signed base graph be `(Gamma,epsilon)`, with derived vertices `(v,s)`, and mark
actual lifts `(v_i,s_i)`, `i=1,...,k`.  Switching by `theta:V->F_2` acts by

```text
epsilon(uv) -> epsilon(uv)+theta(u)+theta(v),
s_i         -> s_i+theta(v_i).
```

Fix a spanning tree `K` and let `P^K_xy` be its path from `x` to `y`.

### Theorem 4 — complete pointed switching invariants

**[PROVED]** A complete set of invariants is:

1. the `beta_1(Gamma)` fundamental-cycle voltages;
2. the `k-1` relative phases

   ```text
   r_i=s_1+s_i+epsilon(P^K_(v_1,v_i)),  i=2,...,k.
   ```

**Proof.** Each expression is unchanged by switching.  Switch uniquely along the tree to make all
tree signs zero, up to one constant switch.  The cycle voltages then determine every chord sign.
Use the remaining constant switch to set `s_1=0`; each other sheet bit is now exactly `r_i`.
Thus equal listed invariants give the same normalized pointed cover. `square`

The statement applies componentwise, with one independent global sheet flip in each component.
Even a tree has no cycle voltage but can have inequivalent pointed states.  Thus “retain voltage”
was still incomplete: dynamic play also needs relative phases of the selected or punctured fibers.

### 4.3 The precise dynamic fork

**[PROVED]** A boundary move cannot be answered by its deck mate.  If `x` lies on `D_0`, then
`C(0),x,sigma(x)` are collinear; on `D_a`, use `z_a`.  All fixed points are already unavailable.
Therefore the selected cap cannot be restored to invariance under the same `sigma` by an immediate
boundary pair.

A residual continuation clutter could nevertheless become unpointed again if a non-mate reply
cancels every relative phase after contraction.  Hence a valid DSC has exactly two structural
options:

- prove a phase-canceling reply theorem that returns the residual clutter to an unpointed Good
  class; or
- keep the pointed phases and prove a well-founded Good-restoring strategy on them.

A third geometric option is to rebase to a new involution after the pair.  These are now explicit
alternatives rather than an unspecified “voltage-aware” closure lemma.

## 5. Balance is a real certificate but not the defect certificate

**[PROVED, INAPPLICABLE TO THE RAW TWO-LINE PHASE]** If there are no fixed fiber edges and
`[gamma]=0`, switch all incidence gains to zero.  The lift splits as two disjoint isomorphic
continuation clutters `H_+ disjoint-union H_-`, so

```text
G(H_T)=G(H_+) xor G(H_-)=0.
```

An incidence forest is a sufficient special case.  The actual two defect lines violate the
no-fixed-edge hypothesis at every live fiber, so this does not evade the recorded C28
MirrorStepGood obstruction.

Even adding “the quotient base is connected and the nonfixed gain class is balanced” is
insufficient in the presence of fiber marks.  Take the balanced double cover of the base path
`1--0--2` and add fixed fiber edges at
base vertices 0 and 1.  The six-vertex Node-Kayles graph has SG 1; every option has SG 0.
This is an abstract gain-graph obstruction; it is not claimed to be a projective-cap
realization, so a genuinely geometric premise could still escape it.

```sh
python3 scripts/r5_balanced_fiber_counterexample.py
```

```text
edges ((0, 1), (2, 3), (0, 4), (2, 5), (0, 2), (1, 3))
option_sg (0, 0, 0, 0, 0, 0)
root_sg 1
```

Thus balance, cycle-rank, defect count, and connectivity are all too coarse; the placement of the
voltage/phase class relative to fixed fiber edges matters.

## 6. Frozen q=11 gate and q=13/q=17 controls

Before reading labels, the data delegate froze this relational signature on all points of
`D_0 union D_a`:

- vertex color = defect side (`D_0`, `D_a`, or their intersection) times
  selected/deleted/live;
- relation `I` joins two unselected points when their joining line contains one of the selected
  six points;
- relation `S` is the involution `sigma`, including fixed loops.

Exact color-and-relation isomorphism is tested by backtracking after joint color refinement.  The
definition retains the full signed quotient and the old deletion trace but consults no value.

### 6.1 Extremal q=11 entry gate

On the ten knife lines, 40 center-line incidences (32 distinct children) fall into four exact
classes, one of each class per line:

| class | incidences | distinct children | live on `(D_0,D_a)` | label after unblind |
|---|---:|---:|---:|---:|
| G0 | 10 | 10 | `(4,2)` | 10 P |
| G1 | 10 | 2 | `(2,2)` | 10 P |
| G2 | 10 | 10 | `(2,2)` | 10 P |
| G3 | 10 | 10 | `(4,4)` | 10 N |

Every line is exactly `G0:P G1:P G2:P G3:N`.  This passes the requested q=11 `3P/1N` entry test,
but Sections 7–8 show why it is not yet progress toward a value rule.

```sh
python3 scripts/r5_q11_voltage_signature.py --geometry
python3 scripts/r5_q11_voltage_signature.py --unblind
```

### 6.2 All d=4 maximum-line character-half controls

The root then kept the same frozen signature and expanded the cohort geometrically to every frame
whose per-frame maximum pencil has a `d=4` stratum:

```sh
for q in 11 13 17 19; do
  python3 scripts/r5_q11_voltage_signature.py --q "$q" --all-frames --unblind --summary
done
```

```text
q=11 incidences=64  children=56  classes=8   totals N=16 P=48  mixed_classes=0
q=13 incidences=84  children=84  classes=12  totals N=15 P=69  mixed_classes=0
q=17 incidences=144 children=144 classes=24  totals N=84 P=60  mixed_classes=0
q=19 incidences=248 children=242 classes=32  totals P=248       mixed_classes=0
```

The P/N totals in this display count center-line incidences; `children` is the deduplicated count.
Class-purity is unchanged by the duplicate incidences.

At q=17 this includes the stressed mixed-value defect phase.  q=19 has no N label in this cohort,
so it is a control but not a separation test.  These are exact fixed-prime computations, not a
cross-q theorem.

## 7. [REFUTED] Live voltage without the old trace

The theorem-driven ablation discards every already-deleted and selected boundary vertex but keeps
the exact live incompatibility graph and `sigma`.  Thus it retains the whole switching/voltage
class of the live cover, not merely SG or a degree vector.

On all q=11 `d=4` maximum-line centers, this gives six live-cover classes.  One class contains both
P and N positions.  An explicit collision occurs on the same normalized pencil

```text
U={1,4,7,10}, line key=(9,5):
P: a=9, cell=(8,9)
N: a=5, cell=(4,5).
```

Both have two live points on each defect line; their four-vertex signed live graphs are exactly
isomorphic, with the certified mapping `0->0,1->1,2->2,3->3`.  Even every live vertex's number of
deleted neighbors by side/status agrees.  What differs is the global attachment pattern of those
deleted traces.

```sh
python3 scripts/r5_q11_voltage_signature.py \
  --q 11 --all-frames --live-only --audit-pgl --unblind --summary
```

```text
GEOMETRY incidences=64 unique_children=56 exact_classes=6
PGL-AUDIT signatures=6 cap_orbits=6 max_cap_orbits_per_signature=2
UNBLIND
LABEL-SUMMARY totals={'N': 16, 'P': 48} pure_classes=5 mixed_classes=1
KILL exact_PN_collision=YES
  P cls=0 key=(9, 5) cell=(8, 9) a=9 U=(1, 4, 7, 10)
  N cls=0 key=(9, 5) cell=(4, 5) a=5 U=(1, 4, 7, 10)
  certified_mapping=0->0,1->1,2->2,3->3
  deleted_neighbor_profiles_equal=YES
```

**Exact conclusion.** The live voltage cover cannot determine P/N.  This does not refute every
partial Good predicate based on live voltage—a predicate may exclude the mixed class—but it does
refute the proposed complete static coordinate and proves that some old-trace attachment datum is
necessary.

The collision lies outside the ten q=11 knife lines, on which the live-only signature still has
four pure classes.  It is therefore a global `d=4` closure obstruction, not a claim that the
extremal entry gate itself failed.

## 8. [REFUTED AS NOVEL] The full trace signature is PGL-complete enough

The perfect separation in Section 6 looked like a missed locality signal.  The predeclared
adversarial check was: compare it to an exact canonical orbit key for the full selected six-cap.

For each ordered four-frame `(p_0,p_1,p_2,p_3)` of the cap, put `P=[p_0 p_1 p_2]` and
`c=P^(-1)p_3`.  All coordinates of `c` are nonzero.  The projectivity

```text
diag(c_1^(-1),c_2^(-1),c_3^(-1)) P^(-1)
```

sends the frame to the three coordinate points plus `(1:1:1)`.  Taking the lexicographically
least image over all `6P4=360` ordered frames is therefore an exact `PGL(3,q)` canonical key.

```sh
for q in 11 13 17 19; do
  python3 scripts/r5_q11_voltage_signature.py \
    --q "$q" --all-frames --audit-pgl --summary
done
```

```text
q=11 signatures=8  cap_orbits=6  max_cap_orbits_per_signature=1 max_signatures_per_cap_orbit=2
q=13 signatures=12 cap_orbits=10 max_cap_orbits_per_signature=1 max_signatures_per_cap_orbit=2
q=17 signatures=24 cap_orbits=20 max_cap_orbits_per_signature=1 max_signatures_per_cap_orbit=2
q=19 signatures=32 cap_orbits=24 max_cap_orbits_per_signature=1 max_signatures_per_cap_orbit=2
```

Every full trace signature is contained in one projective six-cap orbit; some projective orbit is
split into two signatures.  Since P/N is already invariant under fixed-q projective transport,
the zero-collision result follows without a new game theorem.  The signature is a disguised exact
type refinement, precisely the kind of route the existing negative record forbids promoting.

Combining Sections 7 and 8 isolates the useful frontier: retain enough trace attachment phase to
separate the q=11 collision, but require the proposed quotient to merge at least two full PGL cap
orbits.  Otherwise it has not compressed the projective state.

## 9. Static boundary SG at q=11 and q=13

The static boundary game allows only points initially legal on `D_0 union D_a`, with ordinary cap
legality among those moves.  Its graph is solved exactly by a small Node-Kayles recursion before
joining the committed full-child label.

```sh
python3 scripts/r5_static_boundary_sg.py
```

Relevant output:

```text
q=11 d4_centers=64 size_sg={(4,0):32,(6,2):16,(8,0):10,(8,2):6}
q=11 label_joint={(0,N):16,(0,P):26,(2,P):22}
q=11 knife_n=40 knife_joint={(0,N):10,(0,P):20,(2,P):10}

q=13 d4_centers=84 size_sg={(8,0):15,(10,0):63,(12,0):6}
q=13 label_joint={(0,N):15,(0,P):69}
```

Thus q=11 SG 2 is P-sufficient in this finite dataset and occurs once per knife line, but q=13
sets every static boundary value to zero.  The apparent q=11 certificate has no uniform content.
At q=13, `chi(-a)=-1` classifies the defect **line** `D_a` as external; the selected center point
may carry the stored `int` label when `q=1 mod 4`.  The script makes no incorrect center-type
identification.

## 10. Exact remaining gap

### 10.1 The narrowed `d=4` statement

Let `H_T` be the rank-three gain clutter at a symmetric defect checkpoint, and let `Delta_T` be
the old secant-deletion trace marked on its fibers.  Find a value-blind quotient

```text
Q(T) = (selected cycle voltages, selected relative trace phases, selected overlap data)
```

strictly coarser than the full PGL six-cap orbit, together with a Good subset, such that:

1. for every legal opponent lift `x` from a Good state, an algebraically specified legal reply
   `y` exists;
2. contraction by `{x,y}` returns to Good, possibly after a specified rebase of the involution;
3. terminal/base Good positions have SG 0 by an explicit mirror, split, or direct argument;
4. every `d=4` frame has at least one child entering Good.

This is not a renaming of “choose a P reply”: `Q`, Good, and `y` must be defined without values.
It is narrower than the previous DSC gap because Theorems 2–4 prove the complete ambient state and
the q=11 collision identifies exactly where live voltage loses information.  It remains only a
`d=4` route; a complete odd-plane proof must also connect the already-separated `d=5` lane or show
that the root selector can always avoid it.

### 10.2 Why neither endpoint closes it

- Choosing by the exact full trace can reconstruct a PGL type and is circular if its type is then
  labeled by value.
- Choosing from the live voltage cover alone cannot distinguish the explicit q=11 P/N collision.
- Choosing by static SG fails at q=11 and q=13.
- Choosing a balanced cover ignores unavoidable fixed fiber edges; the six-vertex example is N.
- Answering by the deck mate is illegal.

The remaining unknown is therefore a *constructive trace-attachment theorem*, or a projectively
defined involution rebase that makes those attachments cancel.

## 11. Approach registry

| family | exact target | strongest result | blocker | blocker weaker than theorem? | next kill test |
|---|---|---|---|---|---|
| `C_2` gain clutter | Exact quotient of the defect continuation game | Reconstruction by incidence `H^1` plus fiber marks | Exact quotient has full `4^n` dynamic state | Yes: asks for a proper strategy quotient, not P itself | Any proposed quotient must merge full PGL cap orbits |
| Zaslavsky signed cover | Identify the missing static datum | Switching/cycle voltage is complete on the unbranched cross graph | Fixed fibers and pointed moves lie outside the hypotheses | Yes | Carry the q=11 collision through the marked-cover formalism |
| Pointed/XOR gauge | Classify asymmetric sheet data | Cycle bits plus `k-1` relative phases are complete | No phase-canceling reply or decreasing Good class | Yes, within `d=4` | Freeze the phase subset before labels; separate `a=9` P from `a=5` N |
| Live boundary cover | Determine value from exact live voltage | Passes the extremal knife gate | Exact all-frame q=11 P/N collision | Route refuted as complete coordinate | Closed; only partial Good predicates remain possible |
| Full trace signature | Add old deletions | Pure at q=11,13,17 | Refines full PGL cap orbit; no genuine compression | Route refuted as new value law | Require any replacement to merge at least two cap orbits |
| Static boundary SG | Use two-line subgame value | q=11 has SG-2 P signal | q=13 is identically SG 0 across P/N | Refuted | Closed as uniform coordinate |
| Balanced cover | Split into identical games | Valid SG-0 theorem without fixed fibers | Actual defects have fiber edges; connected balanced counterexample has SG 1 | Yes but stronger than wounded mirror condition | Do not fund without a new premise eliminating/absorbing fiber marks |
| Involution rebase | Replace the broken deck map after a pair | Single affine inversion cannot simply move centers (round 4) | No general projective rebase formula | Yes | On q=11, a proposed rebase must exist for a P center and fail or remain harmless on the N center |

## 12. Recommended post-reset round

### Route A — first funding: trace-attachment cohomology

**High/Ultra proof delegate.** Starting from Theorem 4, derive the contraction update for marked
fiber phases under an arbitrary legal boundary pair.  For the explicit q=11 collision
`U={1,4,7,10}, a in {9,5}`, identify the first switching-invariant attachment bit on which the
full traces differ.  Then express that bit algebraically in `(U,a,x,y)` using the affine/polarity
formulas from round 4.

**Medium exact delegate.** Implement only that frozen bit/vector and replay all q=11,13,17 `d=4`
maximum-line centers.  Report whether it merges distinct PGL cap orbits.  Do not search feature
dictionaries or optimize accuracy.

**Success gate:** a strict quotient that (i) separates the explicit live-cover collision, (ii)
merges at least two PGL cap orbits, and (iii) supports a proved contraction/response identity.
**Failure gate:** it either reconstructs the PGL key, merges the explicit P/N collision, or has
unstructured rank growing linearly with all deleted points.

**Estimated cost:** 30–40 high-reasoning minutes plus 10–15 medium replay minutes; existing files,
well below 1 GB; no solve.

### Route B — second funding: projective rebase after a boundary pair

**High proof delegate.** For a legal pair `x in D_0`, `y in D_a`, solve symbolically for all
projective involutions preserving the contracted continuation clutter rather than the selected cap
pointwise.  Seek a value-blind formula for a new center/axis and prove that its fixed points are
unavailable and its fiber obstructions pair.

**Medium adversary.** Apply the formula first to the q=11 `a=9` P / `a=5` N live-cover collision,
then to q=17's mixed defect line.  The test is existence of the declared automorphism and reply,
not the value label itself.

**Success gate:** an explicit reply `y=f(T,x)` and a residual free involution giving a genuine
mirror/split theorem.  **Failure gate:** the same certificate closes a known N center, or a named
legal opponent move in a required P center has no certified reply.

**Estimated cost:** 25–35 high-reasoning minutes plus 10 medium audit minutes.  Do not escalate to
a census.

For both routes, use one literature scout only if it targets a precise theorem on pointed/branched
double covers, switching with marked vertices, or gain-clutter contraction.  A bibliography of
signed graphs without an exact contraction theorem is not progress.

The sub-agent launcher in this round exposed no product-level model/effort selector.  “Proof,”
“literature,” and “data” were enforced as task-depth scopes; no claim is made that a model effort
setting was changed.

## 13. Circularity and scope audit

- The gain-clutter, reconstruction, pointed-normal-form, and balance proofs use no P/N label.
- Every computational predicate was printed/frozen before the unblind phase.
- The q=11 live-cover collision refutes complete value determinacy; it is not overstated as a
  refutation of every partial Good predicate.
- The full colored signature's apparent success is explicitly rejected after the PGL audit.
- Fixed-q projective transport is not used as cross-q transport.
- The PGL canonicalizer was run only over prime controls q=11,13,17,19; it is an audit, not an
  all-prime-power proof.
- `D_a` being an external line is not confused with the selected center being an external point.
- Static boundary SG is not treated as a disjunctive component of the full game.
- Balance is not claimed in the presence of fixed fiber edges.
- The incorrect “one lift on each defect line” specialization was removed; `sigma` fibers lie
  within each line.
- A legal reply is never called winning without an SG-0/strategy certificate.
- Exact voltage, exact PGL type, exact SG, tablebase membership, and future values are not proposed
  as selector coordinates.
- q=25 `(ON)` and `min-witness(25)>=4` are inputs nowhere in the proofs.
- No missing early-break state is assigned a value, and no q=25 census work was duplicated.
- The result is a rigorous `d=4` state/obstruction theorem, not a proof of `(ON)` or of the main
  odd-plane theorem.

## 14. Files produced

- `notes/2026-07-10-codex-odd-plane-round5-pointed-voltage.md` — this report.
- `rust/scripts/r5_q11_voltage_signature.py` — frozen signature, live-only ablation, exact
  isomorphism, unblind, and PGL audit.
- `rust/scripts/r5_static_boundary_sg.py` — q=11/q=13 static boundary SG replay.
- `rust/scripts/r5_balanced_fiber_counterexample.py` — six-vertex balance/fiber SG counterexample.

All three scripts are diagnostic and perform no new game solve.

## 15. Independent round-5 verification (Claude, 2026-07-10)

**[INDEPENDENTLY VERIFIED]** Claude replayed every declared script and obtained the reported
outputs exactly.  The six-vertex SG calculation was also recomputed by hand; the q=11 collision
centers were independently checked to be legal character-half centers; and Lemma 1, Theorems 2
and 4, and the no-deck-mate fact were hand-checked.

Claude's partition audit sharpened Sections 7–8: at q=11 the live signature has exactly one block
that merges two PGL cap orbits, and that same block is the unique mixed P/N block.  Thus any
*refinement* of the live signature that splits the mixed block also destroys its only cross-orbit
merge.  Round 6 treats this as a formal augmentation obstruction rather than trying to append
features until the labels separate.

The remaining bibliographic trust-tier item is the numbering of Zaslavsky's imported result as
Theorem 6.3 in the published paper; no computational or internal proof discrepancy was found.
