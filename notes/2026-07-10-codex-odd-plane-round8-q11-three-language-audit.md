# Odd-plane cap game — round 8 q=11 three-language audit

**Date:** 2026-07-10

## Outcome

This round compared the same frozen q=11 d=4 P/N collision in three languages:

1. Boolean recursion / LP-SOS proof complexity;
2. flagged MDS codes and punctured Schur squares;
3. the affine blocker cocycle and its live-boundary deletion graph.

The useful conclusion is negative but sharp. Ordinary linear constraints already encode the exact game recursion; higher SOS degree is not the missing ingredient. The coding and cocycle coordinates that separate the collision do so by restoring marked projective-orbit information, and their updates are non-autonomous. Thus all three views identify the same missing object: a value-blind, attachment-aware compression of the *transition relation*, not another static classifier of S4 positions.

No claim about (ON), total escape, or the uniform theorem follows from this audit.

## 1. Frozen comparison contract

The mandatory collision is

\[
 U=\{1,4,7,10\}=\{\pm1,\pm4\}\subset\mathbb F_{11},
 \qquad a=9\;(P),\quad a=5\;(N).
\]

The two positions have isomorphic live signed boundary covers, including equal deleted-neighbor profiles, but their compatible contractions differ; see rounds 5–7. Before calculation, a new coordinate was required to:

- be defined without consulting P/N;
- survive the natural marked-coordinate gauge;
- separate this collision;
- remain coarser than the full colored-trace partition and genuinely merge
  unmarked PGL six-cap orbits; and
- update from the present compressed state plus a move, rather than requiring reconstruction of the full cap.

Failure of either of the last two tests is the previously identified type-refinement or non-autonomy trap.

## 2. Recursion and SOS

### Theorem 2.1 — exact level-zero recursion [PROVED]

For a finite normal-play game DAG, attach a variable \(x_v\in[0,1]\) to every position. Impose

\[
x_v=1\quad(v\text{ terminal}),
\]

\[
x_v+x_w\leq1\quad(w\text{ a child of }v),
\]

and, at every nonterminal vertex,

\[
1-x_v\leq\sum_{w\in C(v)}x_w.
\]

This system has the unique solution

\[
x_v=1\iff v\text{ is P}.
\]

**Proof.** Backward induction on remaining depth. A terminal variable is 1. If every child is N, the induction hypothesis gives \(x_w=0\) for every child and the final inequality forces \(x_v=1\). If some child is P, its variable is 1 and the corresponding edge inequality forces \(x_v=0\). This is exactly the P/N recursion. ∎

Consequently, Sherali–Adams or SOS degree is not the obstacle on an explicitly expanded DAG: ordinary LP is already integral and exact. The obstacle is representing the descendant closure uniformly and compactly.

### Theorem 2.2 — quotient criterion [PROVED]

A partition of a game DAG supports the preceding recursion with one variable per block if terminal status and the set of child blocks are constant on each block. Under these conditions backward induction gives one P/N value per block. Conversely, any block containing both a P and an N position cannot support an exact one-variable recursion quotient.

The q=11 live-cover block containing \(a=9\) and \(a=5\) therefore fails before any hierarchy is applied. Raising the SOS degree cannot restore information discarded before variables are introduced. Round 7's unequal contraction outputs are a direct transition-level witness of this failure.

### Existing fixed-q certificate [COMPUTED-EXACT]

Run from `rust/`:

```sh
rustc -O -C target-cpu=native \
  ../notes/2026-07-06-grid-cap-solver.rs -o /tmp/gridcap-r7audit
/tmp/gridcap-r7audit s4pncheck 11 1,2,3,4 \
  --raw s4-dumps/2026-07-08/q11-root-1234-1-2-3-4.raw
```

The source is blob `db4e70b49ca02192e3f08e3a7b6d2223fb364314`, last
committed as `7401111515cb109f0bbd63246392cb34bcdc51e3` (2026-07-10).
The replay used `rustc 1.93.1 (01f6ddf75 2026-02-11)` and exactly the
`-O -C target-cpu=native` flags shown above. The binary itself is disposable;
the source, flags, raw dump, and rebuild command are durable.

Output:

```text
S4PNCHECK q=11 t4=[1, 2, 3, 4] cells=[(1, 1), (2, 6), (3, 4), (4, 3)]
root=N records=42 seen=42 unseen=0 p-nodes=18 n-nodes=24 terminal=13
terminal-profile=8o:4,9o:8,12c:1 edges=117 present-edges=76 omitted-n-edges=41
missing-p-edges=0 terminal-n=0 p-has-p-child=0 n-without-p-child=0
max-ply=10 failures=0 verdict=PASS
```

This is an exact 42-node AND/OR certificate. P nodes retain all children; N nodes may retain one P witness. The choice of universal versus existential expansion already encodes the values, so this is a fixed-q tablebase certificate, not a label-free uniform LP proof. Existing artifacts do not contain the complete descendant DAGs of both explicit collision states, so no stronger quotient census was attempted.

## 3. Flagged MDS-code translation

Put

\[
H_a=[C(0),C(1),C(-1),C(4),C(-4),z_a],\qquad K_a=\ker H_a.
\]

Then \(K_a\) is a projective \([6,3,4]_{11}\) MDS code. The original pencil key \((F,w)=(9,5)\) sends the burned points \(0,\infty\) to \(C(4),C(1)\), so the relevant object is not an unmarked MDS code but the flagged pair

\[
B=\{C(4),C(1)\}\subset
A=\{C(0),C(1),C(4),C(7),C(10)\}.
\]

A compatible boundary pair appends

\[
x_p=(0:1:p),\qquad y_q=(-aq:1:q),
\]

and gives a flagged \([8,5,4]_{11}\) code.

### Lemma 3.1 — Schur/conic dictionary [PROVED]

Let \(D\) be the row span of a 3-by-n projective generator matrix and let \(J\) be six arc columns. Then

\[
\dim (D|_J)^{\star2}=5
\]

if and only if the six projective columns lie on a conic.

**Proof.** The six coordinatewise products of the three generator rows are evaluations of the six ternary quadratic monomials. Their evaluation matrix loses rank precisely when a nonzero ternary quadratic vanishes on the six columns. A reducible conic is the union of two lines and contains at most four points of an arc, so the quadratic is an irreducible conic. ∎

### Collision results [COMPUTED-EXACT]

The label-free replay is:

```sh
python3 scripts/r8_q11_flagged_mds_gate.py
```

It checks the arc conditions, all Schur ranks, the finite and infinite conic
extensions, all 28 six-punctures after each compatible pair, and ends with
`SUMMARY all_assertions=PASS`.

The unflagged six-column Schur data agree:

```text
                         a=9                    a=5
dim D^*2                 6                      6
one-puncture profile     (5,5,5,5,5,5)          (5,5,5,5,5,5)
```

The one-column extension spectrum on the unique conic through the five-frame does separate:

```text
a=9: legal conic parameters {3,8}       count 2
a=5: legal conic parameters {2,3,8,9}   count 4
```

After the compatible boundary pairs, the numbers of six-subsets with Schur-square dimension 5 are

```text
a=9, pairs (3,8),(8,3):   7 of 28
a=5, pairs (3,10),(8,1):  3 of 28
```

For \(a=9\), the seven subsets are the six-subsets of a seven-point conic. For \(a=5\), they are three isolated six-point conics. This is exactly the earlier `REBASE7` statistic in coding language, not a new invariant. Its q=11/q=13 cohort tables already refute seven-conic rebase existence as a P criterion or a restoring law, and its update needs the marked appended columns.

The four eight-column configurations all have one cap-stabilizing projective involution. Reproduction from `rust/`:

```sh
python3 scripts/r6_rebase_audit.py
```

ending with

```text
SUMMARY cases=4 unique_rebases=4 free_on_T_rebases=0 all_assertions=PASS
```

Thus the code language supplies elegant exact separators, but the separators are marked extension/incidence data already known to be non-autonomous.

## 4. Affine cocycle gate

For \(U=\{\pm r,\pm s\}\), the four blocker maps between the two defect pencils have form

\[
f_u(b)=\alpha_u b+\delta_u,
\qquad
\alpha_u=1+\frac{a}{u^2},
\qquad
\delta_u=\frac{a}{u}.
\]

Changing affine gauges changes the translations by a coboundary. Exchanging \(r\) and \(s\) inverts

\[
m=\frac{\alpha_r}{\alpha_s},
\]

so the multiplicative order \(o(m)\) is gauge invariant. Here \(f_u\) maps the
\(D_0\) coordinate to the \(D_a\) coordinate, and composition is read
right-to-left. With that convention, opposite maps give the pure translation

\[
f_{-u}^{-1}\circ f_u:h\longmapsto h+\frac{2au}{a+u^2}.
\]

Reversing the two maps changes the sign. None of the subsequent argument uses
the sign, only that the translation is nonzero.

For external \(z_a\), this translation is nonzero. Over the prime field \(\mathbb F_{11}\), one nonzero translation generates the whole additive group, so the translation module itself cannot distinguish the collision.

For \(r=1,s=4\), with \(4^2=5\), the multiplier calculation is

```text
a=9: alpha_1=10, alpha_4=5, m=2, order(m)=10   (P)
a=5: alpha_1= 6, alpha_4=2, m=3, order(m)= 5   (N)
```

Thus multiplier order passes the single collision test. The predeclared all-cohort kill test rejects it.

### All q=11 d=4 frames [COMPUTED-EXACT]

Run from `rust/`:

```sh
python3 scripts/r8_q11_cocycle_gate.py --geometry
python3 scripts/r8_q11_cocycle_gate.py --unblind
```

The diagnostic imports `scripts/r5_q11_voltage_signature.py`, uses all d=4 maximum pencils, forms \(o(m)\) before reading labels, and only then joins exact P/N and PGL-cap-orbit keys. Output:

```text
COHORT q=11 incidences=64 unique_children=56 live_blocks=6
full_trace_blocks=8 unmarked_pgl_cap_orbits=6
PARTITION name=ord classes=3 mixed=2 cap_orbits=6 max_caps_per_class=3
  multiplier_order=10 labels={'P': 32, 'N': 10} caps=3 incidences=42
  multiplier_order=2 labels={'P': 10} caps=1 incidences=10
  multiplier_order=5 labels={'N': 6, 'P': 6} caps=2 incidences=12
PARTITION name=live+ord classes=7 mixed=0 cap_orbits=6 max_caps_per_class=1
  live_gid=0 multiplier_order=10 labels={'P': 6} caps=1 incidences=6
  live_gid=1 multiplier_order=10 labels={'P': 16} caps=1 incidences=16
  live_gid=1 multiplier_order=5 labels={'N': 6} caps=1 incidences=6
  live_gid=2 multiplier_order=5 labels={'P': 6} caps=1 incidences=6
  live_gid=3 multiplier_order=10 labels={'P': 10} caps=1 incidences=10
  live_gid=4 multiplier_order=2 labels={'P': 10} caps=1 incidences=10
  live_gid=5 multiplier_order=10 labels={'N': 10} caps=1 incidences=10
PGL-SPLIT cap_orbits=[1]
COLLISION-ORBITS a5=[2] a9=[4]
```

The old tuple display `(0,10)` meant `(live_gid=0,
multiplier_order=10)`: there was no order-zero sentinel. Externality implies
\(a+u^2\ne0\), so every \(\alpha_u\) in this cohort is nonzero. The durable
script now prints named fields.

The sole unmarked PGL cap orbit split by `live+ord` is canonical orbit 1,
between `(live_gid,multiplier_order)=(0,10)` and `(3,10)`. It is unrelated to
the advertised collision: the \(a=5\) collision cap is orbit 2 and the
\(a=9\) cap is orbit 4.

Multiplier order alone is mixed in two of its three classes. Joining it to the live cover gives seven pure classes, but each lies within a single full PGL six-cap orbit, and one PGL orbit is split between two joined classes. It therefore refines rather than compresses projective type. This is an exact instance of the type-refinement trap: the coordinate recovers the marked information the live quotient intentionally forgot.

## 5. Cross-language conclusion

The three translations agree on a useful structural diagnosis:

| Language | What works exactly | Why it does not advance the uniform proof |
|---|---|---|
| LP/SOS | degree-1 Bellman inequalities are already exact | the descendant DAG or an exact quotient is still needed |
| flagged MDS | extension and Schur spectra separate the collision | they re-express seven-conic/rebase data and do not update autonomously |
| affine cocycle | multiplier order separates the collision | alone it is mixed; with the live cover it refines full PGL type |

The common missing datum is not a scalar invariant. It is a transition-compatible attachment object: enough information to determine the child-block relation after a move, yet genuinely compressing the full colored trace and the unmarked PGL cap partition.

This is narrower than “find a winning reply” as a research target, but it is not itself a theorem sufficient for the cap game. A successful next object must pass both gates:

1. **congruence gate:** equal compressed states have equal terminal status and equal child-type sets, or a rigorously proved weaker simulation adequate for the P/N recursion;
2. **compression gate:** on the frozen q=11 cohort it must project to at most
   seven blocks, and some block must meet at least two of the six unmarked PGL
   six-cap orbits, while no block mixes P and N.

The exact baselines are 64 marked incidences representing 56 distinct S4
children, six live-cover blocks, six unmarked PGL six-cap orbits, and eight full
colored-trace isomorphism blocks. A separate “marked PGL orbit” partition was
not defined in rounds 5–8; that phrase was ambiguous and is retired here. The
numeric gate instead requires strict compression of the eight-block marked
trace baseline plus a mechanically checkable cross-orbit merge.

The live cover passes the compression gate but fails congruence. Cocycle order repairs the collision but fails compression. Flagged Schur data repair it by the already-refuted rebase refinement and fail autonomy.

## 6. Recommended next work

### Route A — local transition congruence, high effort

Work on the q=11 d=4 cohort only. There is no selected contraction. For each
state, take **all ordered compatible live-boundary pairs** \((x,y)\). For each
pair retain the unordered set of every legal rebase output, with an explicit
failure symbol when no rebase exists. Refine by the entire two-stage signature

\[
 \left\{\!\left\{
   \bigl(\operatorname{side}(x),
     \{\!\{(\operatorname{side}(y),Q(R_{x,y}))\}\!\}\bigr)
 \right\}\!\right\}_{x},
\]

where \(R_{x,y}\) ranges over all rebases, not a chosen one. This construction
is canonical and value-blind; opponent and reply order is retained. Start the
coarsest-stable-partition calculation from intrinsic move/terminal roles,
**not** from the live-cover partition, because the q=11 augmentation theorem
already rules out every value-pure refinement of that partition that keeps its
sole cross-PGL merge. Freeze the resulting transition partition before labels
are joined.

**Success gate:** on the initial 64 incidences, at most seven blocks; at least
one block meeting two of the six unmarked PGL cap orbits; no P/N-mixed block;
and identical complete ordered-pair/rebase child-block signatures inside every
block.

**Failure gate:** eight or more projected blocks, no cross-PGL block, any P/N
mixture, or the round-7 autonomy collision remains merged with unequal complete
transition signatures.

This should be a bounded medium/high computation, not a new solve.

### Route B — algebraic elimination of descendants, high effort only if Route A fails narrowly

Use Theorem 2.1 as the target system and seek a value-blind projection/elimination certificate for an entire S3 fan, rather than an SOS lift of individual state variables. Candidate inequalities must be derived from a uniform algebraic family of legal replies and must end in the total-escape or ON fan inequality, not in “choose a P child.”

**Success gate:** a symbolic inequality whose premises are geometric incidence facts and whose conclusion is \(\sum_x p(A+x)\ge1\) for the declared child family.

**Failure gate:** the certificate requires selecting universal/existential expansions using known P/N labels, as the 42-node fixed-q certificate does.

## 7. Scope and circularity audit

- No legal extension was mistaken for a P-valued extension.
- The fixed q=11 certificate proves one S4 value, not (ON) or total escape.
- No exact value, remoteness, or strategy depth enters the definitions of the code or cocycle coordinates.
- The pure q=11 `live+ord` table is not promoted to a theorem: it refines full PGL type and has no cross-q mechanism.
- The flagged-code separator is not promoted: it is the already-tested REBASE7 statistic in different language.
- The LP theorem does not solve the game; it proves that hierarchy degree is irrelevant unless the state space is compressed or eliminated.
- Nothing here assumes the conic/zone disjunctive-sum law, a bounded-Z strategy, or (ON).
