# Odd-plane cap game — round-one theorem-frontier report

**Date:** 2026-07-10

No uniform proof emerged, but the round produced two rigorous structural lemmas, reconstructed the
exact fan-to-bucket incidence matrices, refuted the most natural special-completion bridge, and
found a sharp off-conic signal at the q=17 frontier. No census was launched. At the time of the
round, q=25 remained at 3/28 known P buckets, with no active solver process observed.

## 1. Best new lemma chain

### A. Uniform involutive-completion lemma

**[PROVED]** Let `A ⊂ P¹(F_q)` be a five-set, with q odd. For every distinguished `e ∈ A`, at
least two of the three pairings

```text
A \ {e} = {a,b} ⊔ {c,d}
```

give a point `x ∉ A` such that `A ∪ {x}` is stabilized by a fixed-point-free involution.

After sending `e` to infinity, the involution swapping `a ↔ b` and `c ↔ d` sends

```text
infinity ↦ x = (ab - cd)/(a + b - c - d).
```

The pairing fails to give a new finite point precisely when `a+b=c+d`. Two of the three pairings
cannot both fail: subtracting two such equalities gives `2(b-c)=0`, impossible in odd
characteristic for distinct points.

For the normalized frame `A={infinity,0,t1,t2,t3}`, the candidates are

```text
-t2*t3/(t1-t2-t3),
-t1*t3/(t2-t1-t3),
-t1*t2/(t3-t1-t2),
```

with at least two defined. This proof is field-theoretic, not prime-field-specific.

A broader construction uses all five choices of `e` and all three pairings. If the corresponding
involution fixes `e`, use its second rational fixed point as `x`. This yields fifteen distinct
involutions distributed among the `q-4` extensions.

### B. Fiber–stabilizer identity

**[PROVED]** For every full-`PGL(2,q)` six-set bucket `B`,

```text
fiber(B) = 30(q-1) / |Stab_PGL(2,q)(B)|.
```

Proof: an orbit contains `|PGL(2,q)|/|Stab(B)|` six-sets. Double-count incidences between these
sets and unordered point-pairs. Each six-set contains 15 pairs, while there are `C(q+1,2)` pairs
and `PGL(2,q)` is transitive on them.

Thus “small fiber” is exactly “large setwise stabilizer,” uniformly in q. It is not merely a
correlation.

### C. Capacity lemma

**[PROVED]** For a five-frame `A`, let `r_A(x)` count the fifteen pointed-pairing involutions
whose associated completion is `x`. Then

```text
sum_{x notin A} r_A(x) = 15,
r_A(x) <= number of involutions in Stab(A union {x}).
```

Consequently, if every N-valued extension has at most `k` relevant stabilizing involutions and
`k(q-4)<15`, then `A` has a P-valued on-conic extension.

**[COMPUTED-EXACT]** At q=17, every N bucket has stabilizer order 1 or 2, hence at most one
involution. Since `q-4=13<15`, this proves the q=17 (ON) statement from bucket stabilizers:

```text
all extensions N
=> 15 = sum_x r_A(x) <= 13,
```

a contradiction.

This is a genuine structural explanation of the q=17 knife edge, though not yet uniform because
the constant 15 cannot dominate `q-4` for large q.

### D. The natural game-value bridge fails

**[REFUTED]** None of these implications is valid:

- nontrivial stabilizer implies P;
- fixed-point-free involution implies P;
- stabilizer `V4` implies P;
- stabilizer order at least four implies P.

The q=11 N bucket

```text
{infinity,0,1,2,3,4}
```

has stabilizer `V4`, including two `2^3` involutions. One is represented by

```text
[[1,8],[6,10]] mod 11,
```

acting as `(infinity 2)(0 3)(1 4)`.

More strongly, for the q=11 extremal five-set `A={0,1,2,3,4}`, all fifteen involutive
constructions land among the five N extensions:

```text
XHIST {5:3, 7:3, 8:3, 10:3, infinity:3}
```

while its two P extensions are the non-involutive bucket of stabilizer `C5`. Thus the explicit
value-blind selector family misses every P child in that row.

This decisively blocks the factorization

```text
involutive completion exists
+ involutive completion is P.
```

## 2. Exact remaining gap

The original theorem asks for a P child among `q^2-9q+21` legal extensions. The refined gap is:

> Find a projectively defined family of completions that includes the q=11 extremal C5
> completions and the q=17 extremal order-24 completion, and prove a game-value theorem for that
> family.

This is narrower because the covering and automorphism geometry are now explicit, and several
tempting definitions of “special” are rigorously excluded. Merely taking “all exceptional
stabilizer types that happen to be P” would again define special through its P label and would be
circular.

A quantitative alternative is to replace the constant fifteen involution incidences by an
`Omega(q)` or `Omega(q^2)` algebraic incidence family and prove an N-capacity bound. Without
growth in the number of constructions, the present 15-incidence lemma cannot be uniform.

## 3. Literature import

**[LITERATURE-IMPORTED]** Gutierrez–Shaska identify extra automorphisms of a hyperelliptic curve
with projective stabilizers of its branch set. In characteristic not two, their involutive locus
has an even-polynomial normal form; for genus two this is precisely a six-point branch set
stabilized by a `2^3` involution:

- J. Gutierrez and T. Shaska, *Hyperelliptic Curves with Extra Involutions*,
  LMS J. Comput. Math. 8 (2005), 102–115.
- <https://arxiv.org/abs/math/0601456>

Translation:

- genus-two branch locus = unordered six-set on `P¹`;
- reduced automorphism group = its `PGL2` setwise stabilizer;
- extra involution = the special-completion class constructed above.

Their normal-form discussion is over an algebraically closed field of characteristic not two. The
elementary completion lemma above supplies the required `F_q`-rational construction. The paper
supplies a coordinate/moduli classification, not a game-value result.

**[LITERATURE-IMPORTED]** Tranchida treats `q=p^n`, p odd, identifies `PGL(2,q)` with the conic
stabilizer, and identifies its involutions with off-conic centers:

- P. Tranchida, *Triples of involutions in PGL(2,q) and their incidence geometries*.
- <https://arxiv.org/abs/2411.10299>

This supplies the group/geometry dictionary needed for the third-intruder route: products and
generated subgroups of three matching involutions can be studied as incidence properties of their
three centers. It does not itself control live defect components or game values.

## 4. Exact incidence and missed-data signals

### Fan-to-bucket matrices

**[COMPUTED-EXACT]** Full-`PGL` row reduction gives two five-set orbits at q=11 and four at q=17.

For q=11, with P columns `{1,2,3}`,

```text
M_11 =
  [5 2 0 0]
  [2 2 2 1],
M_11 f = (2,5).
```

The unique smallest P-bucket cover is `{1}`. Its stabilizer is `C5`, with cycle inventory
`1,(5,1)^4`.

For q=17, with P columns `{4,6,7,8,9}`, the nonzero rows are:

```text
R0 {0:2,1:2,2:2,3:2,4:2,5:2,6:1}  onP=3
R1 {0:2,1:4,3:2,4:1,5:2,7:2}      onP=3
R2 {1:4,2:4,3:4,8:1}                onP=1
R3 {0:2,1:4,2:2,5:2,6:2,9:1}      onP=3
```

Thus `M_17 f=(3,3,1,3)`. Every minimum P-bucket cover has size three:

```text
{4,6,8}, {4,8,9}, or {6,7,8}.
```

Bucket 8 is forced because it alone covers the extremal row. It has stabilizer order 24, while the
q=11 forced bucket has stabilizer order 5. There is therefore no common fixed stabilizer type
behind the two depleted orders.

Reproduction:

```bash
PYTHONPATH=/tmp python3 /tmp/a5_incidence.py 11 17
python3 /tmp/a5_stab.py 11 13 17 19
```

The temporary scripts enumerate normalized `PGL2(q)` matrices and all five-/six-set orbits; their
outputs were cross-checked against the committed bucket fibers and P/N labels.

### Off-conic secant packet

**[COMPUTED-EXACT, POST-HOC]** In each of the three q=17 extremal classes, all five P children—one
on-conic and four off-conic—are collinear:

```text
cls 2:  (5,2),(5,3),(5,8),(5,11),(5,14)       line r=5
cls 17: (3,4),(5,6),(10,11),(11,12),(13,14)   line c=r+1
cls 19: (5,14),(8,2),(12,3),(13,16),(16,4)    line c=13r
```

In each case this line is the secant joining the unique on-conic P extension to one of the five
existing conic-frame points. Its four other legal points are exactly the four off-conic P escapes.

Immediate adversarial check:

- exactly the three q=17 `onP=1, escape=5` classes have all P children collinear;
- none of the other eighteen q=17 classes do;
- none of the eight q=11 classes do.

Reproduction:

```bash
python3 /tmp/escape_lines.py \
  ../notes/data/codex-feat11* \
  ../notes/data/codex-feat17*
```

This is not yet a theorem because the secant was recognized after inspecting P labels. The next
falsification test is value-blind: enumerate the five frame-point/on-conic-candidate secants before
reading child values and test whether a projective formula selects the observed line. A broader
claim that all P escapes are always collinear is already refuted by the controls above.

## 5. Approach registry

| Route | Strongest result | Blocker | Next kill-test |
|---|---|---|---|
| Fan/stabilizer covering | Uniform explicit involutive completions; fiber identity; exact M11/M17; minimum covers | Involutive/V4 completions can be N; q=11 extremal selector misses all P children | Seek a growing algebraic incidence family; reject it if q=11 forced C5 and q=17 forced order-24 buckets are not both covered |
| Stabilizer capacity | Exact q=17 (ON) proof from 15>13 and N stabilizers at most C2 | Constant 15 gives no large-q leverage; q=11 N V4 absorbs all constructions | Derive an Omega(q) family or terminate this as fixed-small-q structure |
| Off-conic fallback | Five P escapes in every q=17 extremal fan form one secant packet | Line currently discovered through P labels; no value-blind selector or propagation theorem | Predeclare candidate secants and test q=11, all q=17 classes, then the first q=25 depleted fan |
| Third-intruder literature | Exact involution-center/group dictionary available | No theorem connects generated subgroup type to defect/Psi transition | Express delta defect-components for one added center in trace/product coordinates |
| Psi/dynamic selector | Existing exact existential descent retained | Still oracle-selected; fixed selector has known q=19 failures | Resume only with a value-blind Good class |
| q=25 | Latest committed state checked: 3/28 buckets P, no N known | Full status unavailable | No run this round |

## 6. Recommended post-reset round

### Route 1: off-conic secant-packet theorem

- High-effort proof agent, 35–45 minutes.
- Task: derive all frame-point/on-conic secants algebraically and seek a value-blind
  characterization of the q=17 extremal packet.
- Success gate: a formula `L(A)`, defined without P/N data, plus a local recursion lemma implying
  that some legal point on `L(A)` is P.
- Failure gate: one exact q=11/q=17 fan where the formula selects no P child, or proof that
  selecting the observed secant requires the unique P on-conic child.
- Medium data agent, 20–25 minutes: build the complete candidate-secant incidence table for q=11
  and q=17 and test chord-value propagation, with q=13/19 controls.
- Estimated cost: 60–70 agent-minutes, under 1 GB RSS.

This is the best main-theorem route because it remains meaningful if q=25 refutes (ON).

### Route 2: growing fan-incidence/capacity theorem

- High-effort algebra/group agent, 35–45 minutes.
- Task: replace the fifteen pairing involutions by a q-growing algebraic family and derive a
  tactical-decomposition identity for its incidence with six-set stabilizer strata.
- Success gate: a uniform lower bound `W_q(A)=Omega(q)` and an independently stated upper bound
  for the weight an N fan can absorb.
- Failure gate: the q=11 N V4 or q=17 N C2 buckets saturate the proposed weight, or the construction
  remains `O(1)`.
- Medium literature/data agent, 20 minutes: use genus-two automorphism classifications and exact
  q=11/q=17 orbit matrices to adversarially test every proposed “special” class.
- Estimated cost: 55–65 agent-minutes, negligible solver memory.

The launcher exposed no product-level model/effort selector. “High” and “medium” were enforced only
as depth, scope, deadline, and output constraints; no model-setting change is claimed.

## 7. Circularity and scope audit

- P/N recursion was kept in the correct direction.
- The uniform lemma proves special-completion existence only; its P-value implication was
  explicitly refuted.
- No claim that (ON) equals the main theorem was made.
- The secant packet is reported as post-hoc computed structure, not a selector theorem.
- No exact Z, Grundy value, remoteness, or strategy depth appears in a proposed selector.
- No two-intruder result was extrapolated to three intruders.
- No conic/zone disjunctive-sum law was used.
- All algebra works over arbitrary odd finite fields; no prime-field ordering or missing Frobenius
  assumption appears.
- The literature scout's initial sharp-3-transitivity proof contained a faulty intermediate
  inference: `tau^2` was not shown to fix the third point. The final lemma above uses the correct
  explicit involution swapping both prescribed pairs.
- q=25 unknown buckets remain unknown; no inference was drawn from the three known P buckets.
