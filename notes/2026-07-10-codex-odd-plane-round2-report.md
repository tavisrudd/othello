# Odd-plane cap game — Codex round-two report

**Date:** 2026-07-10

**Brief:** `2026-07-10-fable-round2-brief-for-codex.md`

**Detailed C74 report:** `2026-07-10-codex-c74-capacity-family.md`

## Outcome

No uniform game-value proof closed, but the round produced four route-deciding results:

1. **[PROVED]** C73's max-incidence selector has an exact uniform algebraic form. In coordinates
   sending its conic endpoints `(F,w)` to `(0,infinity)`, let U be the other four frame points and
   `d=|{uv:u,v in U,u!=v}|`. Then the selected secant has exactly `q-d` legal children, with
   `d in {4,5,6}`; L minimizes d.
2. **[PROVED]** The C73 collision ledger is exactly the round-1 fifteen-involution ledger:
   `h(4)=3,h(5)=1,h(6)=0` and `sum h(d)=15`. The tie count is governed by the involutions of the
   five-set stabilizer and is exactly `1,3,5`, or `15`.
3. **[REFUTED]** The predeclared kill-set-sorted top-k rule, k<=4, is exact at the q=19 root but
   has eleven exact all-N top-four failures in the q=23 maintenance corpus. `D=empty` is a
   component-safety gate, not a value selector; some winning replies require larger zone kills or
   deletion of the entire live conic.
4. **[COMPUTED-EXACT, LABEL-BLIND]** q=25 has eight full-PGL five-frame orbits. Given only the
   brief's already disclosed P buckets 0--6, `min-witness(25)` is forced to be either zero or at
   least three. The sole unresolved row is `6f10+3f14+6f16+6f17`.

The strongest new positive out-of-sample prediction is also fixed: the three maximum lines of the
threatened q=25 row concur at the legal off-conic point `(1:15:9)` in the Veronese model, and that
point is predicted P. The same concurrency selector is P in all 10 labeled tied-line classes at
q=11,13,19, but that supporting correlation is post-hoc and is not promoted to a theorem.

## 1. Route (L): exact pencil reduction

The coordinate-free uniform statement should use the full argmax set, not an arbitrary
tie-breaker:

```text
(L_forall)  for every maximum-incidence candidate secant ell,
            ell contains at least one P-valued legal child.
```

This is the strong form already tested by C73 (`hasP_all`, 68/68). It implies the main theorem.
It is logically independent of (ON): ON need not place its witness on a maximum line, while
L_forall permits an off-conic witness even when every on-conic child is N. In view of the q=25
0-or-3+ dichotomy, L_forall is the more robust localized anchor; ON remains the simpler theorem
when it holds.

For a five-frame `A`, `F in A`, and on-conic candidate `w`, normalize the conic parameter line so
`F=0`, `w=infinity`. Let `U={u1,u2,u3,u4}` be the other frame parameters. The q-1 off-conic
points on the chord Fw are the centers of

```text
tau_a(t)=a/t, a in F_q^*.
```

The center is illegal exactly when `a=ui*uj` for a distinct pair in U. Therefore

```text
P2(U)={ui*uj:i<j}, d=|P2(U)|,
Leg_A(Fw)={w} union {z_a:a notin P2(U)},
|Leg_A(Fw)|=q-d.
```

Equal products can only come from disjoint pairs. Three simultaneous opposite-pair equalities are
impossible for four distinct elements in odd characteristic, so `d>=4`. More precisely:

- `d=4` iff `U={+/-r,+/-s}`;
- `d=5` iff exactly one opposite-edge equality holds;
- `d=6` iff all six products are distinct.

Thus every maximum line has q-4 or q-5 legal children over every odd prime power. This is a proof,
not an extrapolation from q<=19.

The remaining game lemma can now be stated without geometry hidden in prose:

> For every `(F,w)` minimizing d, prove that `A union {w}` is P, or that
> `A union {z_a}` is P for some `a in F_q^* \ P2(U)`.

Each off-conic alternative is an explicit one-intruder state with matching `tau_a` and exact
initial conic deletion. Its conic-only skeleton is classified, but the q=11 line contains internal
children with identical one-matching skeleton and opposite exact P/N values. The coupled
second-intruder zone remains load-bearing.

This is a genuinely narrower gap than the original escape statement: a q^2-sized legal-child set
has become one explicit q-O(1) pencil, with the forbidden parameters and initial matching known.

## 2. Tie theorem and q=11 closure at the selector layer

For each `(F,w)`, the local pointed-pairing supply is

```text
r_F(w)=3 for d=4, 1 for d=5, 0 for d=6,
sum_(F,w) r_F(w)=15.
```

At d=4, two fixed-point-free involutions arise from the two product collisions, while the third
involution fixes F,w and supplies the proof-critical second-fixed-point fallback. At d=5 there is
one fixed-point-free involution.

Let `H=Stab_PGL(2,q)(A)`. Its involutions are in bijection with d=4 lines. An involution of H fixes
exactly one of the five points of A; no two can fix the same point in odd characteristic, because
their product would be a nontrivial translation preserving a four-set. Hence there are at most
five, and inverse-pairing shows the nonzero count is odd. Therefore:

- if H is even, L has q-4 legal children and 1, 3, or 5 ties;
- if H is odd, L has q-5 legal children and exactly 15 ties.

This exactly reproduces every observed tie count.

At the two q=11 knife-edge classes, `H=D10`: its five reflections give five tied d=4 lines, and all
fifteen pairing constructions concentrate on their five N on-conic endpoints. However, the five
lines concur at one value-blind legal off-conic point; these common points are `(4,5)` and `(9,3)`
in the residual representatives, and both are exact P. This closes the *selector existence layer*
at the q=11 exception without repairing the false symmetry-implies-P bridge.

The concurrence pattern continues on every labeled d=4 tie family:

```text
q=11: 2/2 common children P
q=13: 3/3 common children P
q=19: 5/5 common children P
```

It remains a post-hoc value correlation. The q=25 row-7 common point prediction is the first
frozen out-of-sample test.

## 3. C74: what grows, and what cannot

The line pencil supplies the requested growing family:

```text
W_q(A;F,w)=q-1-d = Omega(q)
```

legal off-conic centers. But this does not extend the stabilizer-capacity proof. If a center on Fw
stabilizes `A union {w}`, its involution must pair U internally, so its parameter occurs as a pair
product. It is therefore one of the forbidden, illegal centers. Legal L centers never stabilize
the six-set.

An absolute counting lemma closes the wider automorphism variant. For fixed A, the number of pairs
`(x,g)` with nonidentity `g` stabilizing `A union {x}` is at most 838, independently of q:

- at most `2(5!-1)=238` when `g(A)=A`, since x must be one of at most two fixed points;
- at most `5*5*4!=600` when `g(A)` replaces one point of A by x.

Therefore every completion-automorphism family is O(1). The Omega(q) program survives only as a
non-stabilizing legal-center pencil, and its missing N-absorption bound must be game-theoretic.

## 4. R2-2 kill-set replay

The predeclared candidate gate was: legal replies restoring conic xor zero. Candidates were sorted
value-blind by

```text
([D nonempty], |D|, |K|, sorted kill-ray profile, geometry, row, column)
```

ascending, and budgets k=1,...,4 were scored only after the order was frozen.

**[COMPUTED-EXACT] q=19 complete Grundy root:**

```text
obligations=148
k=1 hit=116 fail=32
k=2 hit=136 fail=12
k=3 hit=144 fail=4
k=4 hit=148 fail=0
```

**[COMPUTED-PARTIAL but exact where resolved] q=23 maintenance followers:**

```text
obligations=1091, candidate_count_mismatches=0
k=1 hit=34  fail=129 unknown=928
k=2 hit=66  fail=43  unknown=982
k=3 hit=104 fail=24  unknown=963
k=4 hit=129 fail=11  unknown=951
```

Unknown means absent from the early-break record and was never assigned a value. The eleven
failures have four exact N top candidates and a later exact P reply at ranks

```text
6:6 cases, 10:2, 13:1, 27:2.
```

They form seven incidence classes. The decisive obstruction has three isolated live conic
vertices: both D-empty candidates are N, while the first known P reply is rank 27 and deletes all
three. Other failures keep D fixed but require a larger K than the top-four candidates. Therefore
neither “D-empty first” nor minimum kill-set size is a uniform bounded selector.

This refutes the requested k<=4 rule without claiming anything about missing early-break states.
The residual is nevertheless rigid: 8/11 failures lie under one accepted follower, and the eleven
rows collapse to seven exact `(before skeleton,D,K,geometry)` classes. That corpus is suitable for
a future discharging exception lemma, but not for another deterministic argmin search.

## 5. Blind q=25 matrix

Before enumeration, the predicted full-PGL five-frame orbit count was eight. Exact GF(25)
enumeration returned:

```text
|PGL(2,25)|=15600
five-set orbits=8
five-orbit sizes: 780:1, 2600:1, 7800:4, 15600:2
six-set orbits=28
```

The six-set stabilizers reproduce the committed bucket-fiber histogram through
`fiber=720/|Stab|`, and q=11/q=17 regressions reproduce the earlier matrices and indices.

The complete eighth row is

```text
R7={10:6,14:3,16:6,17:6}.
```

With disclosed P buckets 0--6, the eight row lower bounds are

```text
(21,9,5,9,4,4,4,0).
```

Thus only R7 can presently be fully N, and

```text
min-witness(25)=0 or min-witness(25)>=3.
```

No continuation `2 -> 1 -> 1` or `2 -> 1 -> 2` is possible. If the four R7 buckets are all N,
ON fails. If any is P, the q=25 margin rebounds to at least three.

R7 has three max-incidence lines, all with on-conic endpoint in bucket 14. Their common point is
the legal off-conic Veronese point `(1:15:9)`, frozen as predicted P before its label is available.

The q=25 interpretation matrix is now:

| depletion | L result | consequence |
|---|---|---|
| none | pass automatically | every on-conic endpoint is P; ON and L both hold |
| none | fail | logically impossible |
| depleted, min>0 | pass | ON and L both remain; L is more robust |
| depleted, min>0 | fail | retain ON; max-incidence localization is wounded |
| depleted, min=0 | pass | ON is refuted; L becomes the localized anchor |
| depleted, min=0 | fail | both localized routes fail; return to unrestricted total escape |

For the threatened R7 specifically, bucket 14 P gives L-ON; bucket 14 N but 10/16/17 P gives ON
without L-ON; all four N refutes ON and makes the common off-conic point the decisive L-ESC test.

## 6. Route registry

| Route | Round-two status | Exact blocker/next test |
|---|---|---|
| L recursion | advanced to exact one-parameter pencil | prove one pencil child P with coupled zone; conic-only parity is insufficient |
| C74 stabilizer capacity | closed as an Omega(q) source | all completion-automorphism incidence is O(1) |
| C74 legal-center capacity | alive | W=Omega(q), but needs independent game-value N-absorption bound |
| kill-set top-k <=4 | refuted at q=23 | 11 exact failures; do not tune another argmin |
| tied-line concurrence | exact geometry, value conjectural | test q=25 row-7 point `(1:15:9)` before broader mining |
| ON/A5 | sharply branched at q=25 | only buckets 10,14,16,17 decide the unresolved row |
| R2-4 arithmetic hard surfaces | not funded this round | lower priority after R2-1/2/3 produced route decisions |

## 7. Recommended next round

1. **High proof effort: the legal involution-pencil lemma.** Work directly with
   `a in F_q^*\P2(U)` and labelled second-intruder kill maps. Success is a value-blind Good class
   and a proof that some a enters it; failure is an exact q=11/17 pencil on which every proposed
   Good class misses all P children. Do not return to stabilizers or tangency parity.
2. **Medium exact audit: q=25 targeted unblind.** As soon as the relevant labels exist, inspect
   buckets 10/14/16/17 and the single common off-conic point `(1:15:9)` before any broader q=25
   feature work. This resolves ON and the strongest L prediction with minimal extra computation.
3. **Conditional exception analysis:** use the seven q=23 top-k failure classes to formulate a
   generic-discharge plus explicit-exception statement. Stop if the exceptions do not collapse
   under a proof-admissible incidence coordinate; no new deterministic selector sweep.

## 8. Reproduction and audit

```bash
cd rust
python3 scripts/c74_line_pencil.py 11 13 17 19
python3 scripts/c74_fan_orbits.py 25 --known-p 0,1,2,3,4,5,6
python3 scripts/c74_concurrence.py
python3 scripts/r2_killset_topk.py --fail-json /tmp/r2-killset.json
```

New durable scripts:

- `rust/scripts/c74_line_pencil.py`
- `rust/scripts/c74_fan_orbits.py`
- `rust/scripts/c74_concurrence.py`
- `rust/scripts/r2_killset_topk.py`

Audit:

- No q>=23 solve was run; q=23 work was read-only mmap/log replay.
- q=23 candidate counts matched all 1,091 maintenance records exactly.
- q=19 used a complete exact Grundy dump.
- Missing early-break children remained unknown.
- The q=25 matrix and concurrence point were computed without game labels.
- The disclosed q=25 bucket labels were applied only after the matrix was fixed.
- Legality is never promoted to P-value; the pencil game lemma remains explicitly open.
- No exact Z, remoteness, or future-strategy coordinate enters a selector.
- All field proofs are for arbitrary odd prime powers; GF(25) uses `F_5[u]/(u^2+3)`.
