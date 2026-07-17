# C226 exact repair-port transforms and radius-truncated EXIT

**Lane:** `rp-next`
**Status:** COMPLETE. The radius-three cubic and axis failure laws are exact additive-combinatorial
partition functions, and every bounded repair port is an exact radius-truncated BEC EXIT object
with a cost-distribution and target-specific stopping-certificate interpretation.

## Result at a glance

C226 closes four convention gaps left open by C219:

1. the target is conditioned unavailable, while helper erasure probabilities are the variables;
2. `h_x^(<=r)` is an extrinsic failure probability, not the actual post-channel symbol-erasure
   probability;
3. the full circuit port gives symbol-MAP erasure decoding, while a radius cutoff is a generally
   suboptimal bounded-query decoder;
4. repair blockers are exact target-specific failure certificates, but are not automatically the
   global Tanner stopping sets of an iterative decoder.

With those conventions fixed, the two q-ary geometric ports have exact transforms:

```text
Q_cubic(p_C,p_A)
  = sum_(S subset F_3^h)
      p_C^(q-|S|) (1-p_C)^|S| p_A^|S restricted-plus S|,

Q_axis(p_A,p_C)
  = [p_A^q + q(1-p_A)p_A^(q-1)]
    * sum_(S zero-sum-free) (1-p_C)^|S| p_C^(q-|S|).
```

The first is the partition function of restricted-sumset defect. The second factors into the
failure law for the complete graph on the other axis helpers and the independence polynomial of
the zero-sum-triple hypergraph on finite cubic helpers.

## Probability and EXIT conventions

Let `x` be a coordinate of a linear code and `V` the other coordinates. For an integer `r`, let

```text
H_x^(<=r) = min {C-{x} : C is a circuit containing x, |C|-1<=r},
```

where `min` removes nonminimal helper sets. If `A subset V` is the surviving-helper set, define

```text
f_x^(<=r)(A)=1  iff  some H in H_x^(<=r) satisfies H subset A.
```

Helpers are independently erased with probabilities `p_v`; the target `x` is conditioned
unavailable. Define

```text
h_x^(<=r)(p) = Pr(f_x^(<=r)(A)=0),
R_x^(<=r)(p) = 1-h_x^(<=r)(p).
```

For a binary linear code, `h_x^(<=r)` is the conditional entropy of `X_x` under the decoder that
may use only dependencies of radius at most `r`. For a q-ary linear code, the same statement holds
after normalizing entropy by `log q`: conditional on a BEC observation, a linear coordinate is
either determined or uniform over the alphabet.

Three different quantities must not be conflated:

- `h_x^(<=r)(p)` is the **extrinsic** failure probability given that `x` is unavailable;
- if `x` itself is erased independently with probability `p_x`, its residual erasure probability
  after this decoder is `p_x h_x^(<=r)(p)`;
- with every circuit available, `h_x^(<=|V|)` is the symbol-MAP EXIT function, because
  `x` is recoverable exactly when `x` lies in the span/closure of the surviving columns.

Thus homogeneous transmission over `BEC(p)` gives residual symbol erasure `p h_x^(<=r)(p)`, not
merely `h_x^(<=r)(p)`. No EXIT area or capacity claim is made for the truncated curve.

## Exact bounded-EXIT calculus

For a helper `v`, use C219's clutter deletion and contraction:

```text
H-v = min {E in H : v notin E},
H/v = min {E-{v} : E in H}.
```

Conditioning on whether `v` is erased gives the failure-form deletion--contraction identity

```text
h_H(p) = p_v h_(H-v)(p) + (1-p_v) h_(H/v)(p).            (4)
```

Consequently

```text
partial h_H / partial p_v
  = h_(H-v)-h_(H/v)
  = Pr(v is pivotal for recoverability).                  (5)
```

The sign is positive: raising an erasure probability raises failure probability. Under homogeneous
helper erasure `p`, Russo--Margulis becomes

```text
d h_H(p)/dp = sum_v Pr_p(v is pivotal).                   (6)
```

Equations (4)--(6) are exactly C219's survival-variable formulas after substituting `s_v=1-p_v`;
they are recorded here to prevent a silent sign flip when the result is stated as EXIT.

### Cheapest available repair radius

For a realized survivor set `A`, define

```text
L_x(A)=min {|H| : H repairs x and H subset A},
```

with `L_x(A)=infinity` if no repair is available. The entire distribution of the cheapest usable
repair follows from the truncated EXIT hierarchy:

```text
Pr(L_x<=r) = R_x^(<=r) = 1-h_x^(<=r),
Pr(L_x=r)  = R_x^(<=r)-R_x^(<=r-1)
           = h_x^(<=r-1)-h_x^(<=r),
Pr(L_x=infinity) = h_x^(<=|V|).                           (7)
```

This is the strict operational consequence required by the C226 gate: the curves do not merely
score reliability; successive differences price the marginal benefit of increasing the locality
budget. The same statement holds for any C215 weight/cost cutoff in place of cardinality.

## Cubic target: restricted-sumset transform

Let `G=F_3^h`, `q=|G|`, and consider the cubic-infinity target. The radius-three repairs are

```text
{C(s),C(t),A(s+t)},  s != t.
```

Let finite cubic helpers fail with probability `p_C` and finite axis helpers with probability
`p_A`. Condition on the surviving cubic-parameter set `S subset G`. Every possible repair is
destroyed exactly when every axis helper indexed by

```text
R(S)=S restricted-plus S={s+t:s,t in S, s!=t}
```

is erased. Axis coordinates outside `R(S)` are unrestricted and sum out. Therefore

```text
Q_cubic(p_C,p_A)
  = sum_(S subset G)
      p_C^(q-|S|)(1-p_C)^|S| p_A^|R(S)|.                 (1)
```

Under homogeneous erasure `p_C=p_A=p`, define C220's defect

```text
delta(S)=|R(S)|-(|S|-1),
```

including `delta(empty)=1`. Then

```text
Q_cubic(p)
  = sum_(S subset G) (1-p)^|S| p^(q-1+delta(S)).          (2)
```

This is an exact partition function, not only a leading-order analogy. C220's equality and first
stability theorem split its first two defect sectors exactly:

```text
Q_cubic(p)
 = p^(q-1)[q(1-p)+binom(q,2)(1-p)^2]
 + p^q[1+binom(q,3)(1-p)^3
       + sum_(k=2)^h 3^(h-k) [h choose k]_3 (1-p)^(3^k)]
 + sum_(S:delta(S)>=2) (1-p)^|S| p^(q-1+delta(S)).        (8)
```

The `delta=0` sector gives

```text
Q_cubic(p)=q(q+1)/2 * p^(q-1)+O(p^q).
```

At q=9 this recovers C202/C219's `45 p^8+O(p^9)` without a new orbit census.

## Axis target: zero-sum-free factorization

At the axis-infinity target, the radius-three repair clutter is a disjoint union on helper types:

- every pair among the `q` other finite axis helpers;
- every distinct zero-sum triple among the `q` finite cubic helpers.

The cubic-infinity helper is isolated and sums out. Axis repair fails exactly when at most one axis
helper survives. Cubic repair fails exactly when the surviving cubic set is zero-sum-free. The two
events use disjoint helper types, hence

```text
Q_axis(p_A,p_C)
  = [p_A^q+q(1-p_A)p_A^(q-1)]
    * sum_(S zero-sum-free)(1-p_C)^|S|p_C^(q-|S|).        (3)
```

If

```text
I_h(z)=sum_(S zero-sum-free) z^|S|,
```

the second factor is `p_C^q I_h((1-p_C)/p_C)`, interpreted by continuity at `p_C=0`. Thus axis
reliability is exactly controlled by the independence polynomial of the zero-sum-triple
hypergraph.

Let `alpha_h` be the maximum zero-sum-free size and `N_h` the number of such maximum sets. Under
homogeneous erasure,

```text
Q_axis(p)=q N_h p^(2q-1-alpha_h)+O(p^(2q-alpha_h)).       (9)
```

For q=9, C202's maximum size `alpha_2=4` and 486 minimum blockers imply `N_2=54`, giving
`486 p^13+O(p^14)`, exactly as in C219.

## Target-specific stopping certificates

Let `B_x^(<=r)` be the clutter of minimal transversals of `H_x^(<=r)` and let `F` be the failed
helper set. Then

```text
h_x^(<=r)=Pr(F contains some B in B_x^(<=r)).             (10)
```

So `B union {x}` is a minimal **target-specific, one-shot bounded-repair failure certificate**.
Calling it a stopping set is useful only with that qualifier.

The classical Tanner-graph notion is representation- and decoder-dependent: a stopping set is an
erased variable set whose neighboring checks all meet it at least twice, and it characterizes the
terminal state of iterative BEC decoding. Equation (10) instead fixes one target and asks whether
any permitted repair is wholly live. For a global peeling decoder the two notions can be related,
but they are not identical by definition; C226 makes no joint or iterative-repair claim.

## Verification

[`2026-07-16-c226-repair-port-exit-transforms.py`](2026-07-16-c226-repair-port-exit-transforms.py)
constructs the abstract cubic and axis radius-three repair hypergraphs over `F_3` and `F_3^2`.
Independently of formulas (1) and (3), it performs an upward Boolean zeta transform over all
`2^(2q)` typed helper states and records the bivariate Bernstein failure coefficients. It then
constructs the restricted-sumset and zero-sum-free transforms by conditioning and requires exact
coefficient-matrix equality.

The deterministic certificate
[`2026-07-16-c226-repair-port-exit-transforms.json`](2026-07-16-c226-repair-port-exit-transforms.json)
records hashes of the equal matrices rather than adding a new q=9 coefficient census. It verifies:

- q=3/q=9 edge counts `3/36` for cubic and `4/48` for axis;
- all-survive failure `0` and all-fail failure `1`;
- cubic leading layers `6p^2` and `45p^8`;
- axis leading layers `9p^3` and `486p^13`;
- q=9 defect-zero/one subset counts `45/86` and maximum zero-sum-free count `54`.

## Focused prior-art boundary

The surrounding machinery is classical and must be cited as such.

- Ashikhmin--Kramer--ten Brink develop BEC EXIT functions, area properties, split information
  functions, split support weights, and duality in
  [*Extrinsic Information Transfer Functions: Model and Erasure Channel Properties*](https://doi.org/10.1109/TIT.2004.836693).
- Kudekar--Mondelli--Sasoglu--Urbanke define the bit-MAP EXIT function as
  `H(X_i|Y_~i)`, encode it by a monotone erasure event, and combine sharp thresholds with the area
  theorem in [their Reed--Muller BEC paper](https://arxiv.org/abs/1505.05831).
- Di--Proietti--Telatar--Richardson--Urbanke give the Tanner stopping-set characterization of
  iterative BEC failure in
  [their finite-length LDPC analysis](https://doi.org/10.1109/TIT.2002.1003839).
- Mazumdar studies stochastic-channel capacity of LRCs, including BEC formulas involving the rank
  polynomial of local codes, in
  [*Capacity of Locally Recoverable Codes*](https://arxiv.org/abs/1808.10262).
- The especially close 2026 comparison is Ly--Soljanin--Whiting's
  [probabilistic analysis of majority-logic LRC decoding](https://arxiv.org/abs/2601.08765): its BEC
  formula uses `t` pairwise-disjoint recovery sets, so the failure probability factors into `t`
  independent set-failure events.

C226 differs in a narrow, defensible way. It keeps the complete, generally overlapping repair
clutter; permits typed helper erasure probabilities; identifies the entire radius hierarchy rather
than one availability parameter; and evaluates two geometric ports as restricted-sumset and
zero-sum-free partition functions. The focused search found no source stating formulas (1)--(3),
the exact cheapest-radius identity (7) for complete ports, or the C220 defect-sector expansion (8)
in repair-port language. These are none-found contribution candidates, not priority claims.

## Disposition

C226 passes its gate with three exact general identities, a strict operational cost-distribution
consequence, a verified two-family application, and a precise boundary against full MAP EXIT and
global stopping sets. The strongest paper-ready package is equations (1)--(8) plus the convention
box; the detailed q=9 coefficient arrays remain in C219 rather than being duplicated.

C227 is next. The prior-art audit also exposed a concrete lead: Mazumdar's general-local-code BEC
capacity formulas already use a rank/Tutte polynomial. C227 must distinguish that unpointed local
rank polynomial from the distinguished-coordinate rank-jump polynomial needed for a complete port.
