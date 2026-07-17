# C220 cubic-blocker equality and first stability layer

**Lane:** `repairports`
**Status:** COMPLETE. Minimum and one-above-minimum cubic radius-three blockers are classified over
every `F_3^h` by a restricted-sumset defect theorem.

## Entry conjecture and result

C220's stop rule required a sharp additive conjecture before any broad search. The selected entry
conjecture was:

> If `S` is a nonempty subset of an elementary abelian 3-group and
> `|S restricted-plus S|=|S|-1`, then `|S|<=2`; at defect one, the only larger structured examples
> are triples and affine-subspace cosets.

The conjecture is true, with the empty-set boundary included as follows.

Let `G=F_3^h`, and define

```text
R(S) = {s+t : s,t in S, s != t},
delta(S) = |R(S)|-(|S|-1).
```

Then:

1. `delta(S)>=0` for every nonempty `S`;
2. `delta(S)=0` exactly when `|S|` is one or two;
3. `delta(S)=1` exactly in the following cases:
   - `S` is empty;
   - `|S|=3`;
   - `|S|>=4` and `S` is a coset of an additive subgroup of `G`.

The empty set has `delta(empty)=1` under the displayed definition. In the last case the subgroup
has order at least nine.

## Proof

For nonempty `S`, fix `a in S`. The `|S|-1` sums

```text
a+s,  s in S-{a},
```

are distinct, proving `delta(S)>=0`. Translation preserves both the defect and the asserted
structure, so assume `0 in S`.

If `delta(S)=0`, the sums `0+s` already exhaust `R(S)`, hence

```text
R(S)=S-{0}.
```

If `S` contained distinct nonzero `x,y`, then `z=x+y` would lie in `S-{0}`. The distinct pairs
`(x,z)` and `(y,z)` would put

```text
y-x  and  x-y
```

in `S-{0}`. They are distinct negatives, so their restricted sum is zero, contradicting
`0 notin R(S)`. Thus `|S|<=2`, and the converse is immediate.

Now suppose `delta(S)=1` and `|S|>=4`. Since `S-{0}` is contained in `R(S)`, write

```text
R(S)=(S-{0}) union {r}.
```

If `r=0`, then `R(S)=S`. For any nonzero `x in S`, either `-x in S` already or choose
`y in S-{0,x}`. Put `z=x+y`. Restricted closure gives `z` and `x-y` in `S`; these are distinct,
and their sum is `-x`. Hence `S` is closed under negatives and all sums, so it is a subgroup.

It remains to rule out `r != 0`. Choose distinct nonzero `x,y`. If `z=x+y` belongs to `S-{0}`,
then `y-x` and `x-y` both lie in `R(S)`. They cannot both lie in `S-{0}`, since their sum is zero;
after exchanging their names, say

```text
y-x in S,   r=x-y.
```

But `z+(y-x)=-y` lies in `R(S)`. It cannot lie in `S-{0}`, again because `y+(-y)=0`; hence it
equals `r=x-y`, forcing `x=0`, a contradiction. Therefore every pair of distinct nonzero elements
has sum `r`. Three nonzero elements now give `x+y=r=x+z`, forcing `y=z`. This contradiction proves
`r=0`, so `S` is a subgroup after translation.

Every three-set has three distinct pair sums and therefore defect one. Conversely, if `S=a+H` is
an affine-subspace coset of size at least four, every element of `2a+H` is the sum of two distinct
elements of `a+H`, so `R(S)=2a+H` and `delta(S)=1`. This completes the classification.

## Exact blocker stability

At a cubic target, the radius-three repair edges are

```text
{C(s), C(t), A(s+t)},  s != t in G.
```

Write a blocker as cubic coordinates `X` and axis coordinates `Y`, and let `S=G-X` be the omitted
cubic parameters. The blocker condition is exactly

```text
R(S) subset Y.
```

Define the redundant-color count `e=|Y-R(S)|`. The blocker cardinality has the exact defect
decomposition

```text
|X|+|Y| = q-1 + delta(S) + e.                 (*)
```

This identity is the stability statement: additive defect and deliberately redundant axis choices
are the only two ways to move away from the optimum.

### Equality

Minimum blockers have size `q-1`, hence `delta=e=0`. They are exactly:

- `S={a}`, `Y=empty`: all finite cubic coordinates except `C(a)`;
- `S={a,b}`, `Y={a+b}`: all finite cubics except `C(a),C(b)`, plus `A(a+b)`.

There are therefore

```text
q + binom(q,2) = q(q+1)/2
```

minimum blockers over every `q=3^h`. This proves that C202's two q=9 forms are uniformly
exhaustive, not merely persistent constructions.

### One above equality

Every blocker of size `q` has `delta+e=1` and belongs to exactly one of these mechanisms:

- `|S|=1` or `2`, with one additional redundant axis coordinate;
- `S=empty` and `Y=empty`;
- `|S|=3` and `Y=R(S)`;
- `S` is a coset of a subgroup of dimension at least two and `Y=R(S)`.

Thus the number of cardinality-`q` blockers is

```text
q^2 + binom(q,2)(q-1) + 1 + binom(q,3)
    + sum_(k=2)^h 3^(h-k) [h choose k]_3,
```

where the last factor is the Gaussian binomial coefficient. This counts all blockers at that
cardinality, including those with a removable redundant axis coordinate; it is not a claim that
they are all inclusion-minimal transversals.

For q=9 the two layers contain 45 and 455 blockers respectively. For q=3 they contain 6 and 17.

## Verification

[`2026-07-16-c220-restricted-sumset-stability.py`](2026-07-16-c220-restricted-sumset-stability.py)
exhausts every subset of `F_3` and `F_3^2`, verifies both defect classifications, and independently
counts blockers from the condition `R(S) subset Y`. It recovers C202's 45 q=9 minimum blockers and
the 455-member next layer. Over `F_3^3` it exhausts all 101,584 subsets of size at most five and
checks all 39 affine-plane cosets and the whole space. Its deterministic output is
[`2026-07-16-c220-restricted-sumset-stability.json`](2026-07-16-c220-restricted-sumset-stability.json).

## Prior-art and novelty boundary

Restricted sumsets and inverse restricted-addition theorems are classical additive combinatorics.
The bounded search included [Lev's work on restricted addition in general
groups](https://www.combinatorics.org/ojs/index.php/eljc/article/view/v7i1r4),
[Károlyi's inverse theorem](https://www.sciencedirect.com/science/article/pii/S0021869305002656),
[Bajnok's survey of minimum-size and critical-number
problems](https://arxiv.org/abs/1512.03038), and [recent general lower
bounds](https://arxiv.org/abs/2403.03549). Those results address much broader regimes; several
standard lower bounds collapse to the least prime divisor, three, in the present elementary
abelian groups. The defect-zero and defect-one arguments above are elementary and self-contained,
and no claim is made that they are new as pure additive theorems.

No source was found that translates these two defect layers into the complete cubic repair-port
blocker classification or the exact stability identity `(*)`. That operational application is a
none-found candidate contribution, not a priority claim.

## Disposition

C220 meets its promotion gate: a uniform inverse theorem classifies every equality case, and the
first stability layer classifies every blocker one above optimum. It upgrades C202's q=9 cubic
classification to all `q=3^h` and supplies a compact defect invariant for further reliability or
robustness calculations.

The axis problems—classification of maximum zero-sum-free sets and nonparallel line partitions in
higher-dimensional `F_3^h`—remain genuinely broader additive-geometry questions. They are not
needed for C220's gate and should not be opened without a separate task.
