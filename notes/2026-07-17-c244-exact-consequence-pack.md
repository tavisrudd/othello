# C244 exact consequence pack: pointed distance, joint laws, EXIT, and Poisson rates

**Lane:** `rp-next`
**Status:** COMPLETE. Four exact paper-ready consequences survive independent replay; the split
enumerator is downgraded to a standard coordinate-partition/Greene corollary, and the proposed EXIT
ledger is corrected from redundancy to code dimension. No new harmonic census or asymptotic arc
programme was opened.

## Result at a glance

The promoted pack is:

1. minimum complete-port blockers are the pointed minimum-weight primal code supports, giving
   uniform cubic--axis formulas at q=9 and q=27;
2. one corrected additive enumerator simultaneously yields both C226 transforms and a new exact
   two-target failure law;
3. the q=9 harmonic locality deficits are `2/77` and `23/154`, with the corrected EXIT ledger
   `truncated area = code dimension + total deficit`; and
4. the first two harmonic Bernstein layers and explicit Stein--Chen error rates follow from the
   already-counted design overlaps.

The coordinate-split weight enumerator is useful exposition, but not a new theorem: ordinary
Greene applied to a code and its coordinate-zero contraction already gives it, and coordinate-
partition MacWilliams identities are standard.

## 1. Pointed primal distance and the cubic--axis table

Let `C` be the row code of a generator matrix with column matroid `M`, and let `x` be a nonzero
coordinate. C227 identifies minimal blockers of the complete port `(M,x)` with cocircuits of `M`
through `x`, with `x` deleted. Cocircuits of a represented matroid are exactly inclusion-minimal
supports of nonzero row-code words. Therefore, with

```text
d_x(C) = min {wt(c) : c in C, c_x != 0},
```

the minimum blocker size is

```text
tau_full(x) = d_x(C)-1.
```

More precisely, all inclusion-minimal blockers correspond to inclusion-minimal codeword supports
through `x`; the minimum blockers are those of weight `d_x(C)`, with `x` removed. Counts below are
support counts, not counts of nonzero scalar multiples.

For the completed cubic--axis configuration over `GF(q)`, `q=3^h`, hyperplane sections have sizes

```text
{1,2,3,4} union {q+2},
```

and the nonzero row-code weights are

```text
{q, 2q-2, 2q-1, 2q, 2q+1}.
```

Planes containing the axis give the weight-q supports `curve minus one point`. Four-point sections
are three curve points together with their completion-axis point. Hence

| target class | `d_x(C)` | `tau_full(x)` | minimum blocker supports |
|---|---:|---:|---:|
| curve | `q` | `q-1` | `q` |
| axis | `2q-2` | `2q-3` | `q^2(q-1)/6` |

The independent hyperplane replay gives `(9,8,9)` and `(16,15,108)` at q=9, and
`(27,26,27)` and `(52,51,3159)` at q=27. The q=9 rows recover C219's leading full-port failure
terms `9p^8` and `108p^15`; q=27 is the required out-of-sample check.

This is the clean coding interpretation of C227 blocker duality. The general cocircuit/minimal-
support dictionary is classical; the paper contribution is its use as a coordinatewise complete-
repair consequence and the closed cubic--axis table.

## 2. Master additive enumerator and exact two-target law

Let `G=F_3^h`, `q=|G|`, and for `S subseteq G` define the restricted sumset

```text
P(S) = {s+t : s,t in S, s != t}.
```

The notation matters: `P(S)` is not `S union P(S)`. Define

```text
A_h(u,y,w)
  = sum_(S subseteq G) u^|S| y^|P(S)| w^|P(S) intersect (-S)|.
```

In characteristic three,

```text
P(S) intersect (-S) is empty
    iff S contains no distinct zero-sum triple.
```

Indeed `s+t=-u` is exactly `s+t+u=0`; if `u` equalled `s` or `t`, characteristic three would
force the other summand to coincide too, contrary to the restricted pair.

With finite-cubic and finite-axis helper erasure probabilities `p_C,p_A` and
`u=(1-p_C)/p_C`, C226's two factors become

```text
Q_cubic(p_C,p_A) = p_C^q A_h(u,p_A,1),

zero-sum-free cubic factor in Q_axis = p_C^q A_h(u,1,0).
```

When both the cubic-infinity and axis-infinity targets are unavailable, their joint radius-three
failure probability is exactly

```text
p_C^q [
  (p_A^q + q(1-p_A)p_A^(q-1)) A_h(u,1,0)
  - (1-p_A)p_A^(q-1) (dA_h/dy)(u,1,0)
].
```

Conditioning on a zero-sum-free `S` proves the formula: every axis in `P(S)` must be erased, and
among the other `q-|P(S)|` axes at most one may survive. The derivative subtracts the forbidden
choices inside `P(S)`.

Direct enumeration at q=3 and q=9 agrees with the master formula coefficient-for-coefficient.
Both failures are decreasing events in the survival indicators, so Harris--FKG gives the useful
check

```text
Pr(both fail) >= Q_cubic Q_axis;
```

the master enumerator gives the correlation gap exactly rather than only its sign.

## 3. Locality deficits and the corrected EXIT ledger

Let a length-`N` code have `N-1` helpers at each target. With homogeneous helper erasure `p`, set

```text
L_r(x) = integral_0^1 [h_x^(<=r)(p)-h_x^MAP(p)] dp.
```

If `Delta a_k` is the number of size-`k` survivor sets that full MAP repairs but radius `r` does
not, beta integration gives

```text
L_r(x)
  = sum_(k=0)^(N-1) Delta a_k / [N binom(N-1,k)].
```

For the harmonic `[11,5,6]_9` code, C227's independently computed full/truncated profiles give

```text
L_4(nucleus) = 2/77,
L_4(curve)   = 23/154.
```

The earlier brainstorm ledger used the wrong side of the EXIT area theorem. Under C226's
extrinsic **failure** convention, the symbol-MAP areas sum to the code dimension `K`, not the
redundancy `N-K` (a repetition code is the immediate convention check). The correct identity is

```text
sum_x integral h_x^(<=r)(p) dp = K + sum_x L_r(x).
```

Thus the q=9 harmonic totals are

```text
full symbol-MAP area       = 5,
total radius-four deficit  = 2/77 + 10(23/154) = 117/77,
radius-four area           = 5 + 117/77 = 502/77.
```

This is an exact accounting identity, not a capacity or rate-versus-locality inequality. The
proposed inequality remains open and is not promoted by C244. Ashikhmin--Kramer--ten Brink are the
primary adjacent source for BEC EXIT area, split information functions, and support weights
([DOI 10.1109/TIT.2004.836693](https://doi.org/10.1109/TIT.2004.836693)).

## 4. Design-exact early layers and quantitative Poisson bounds

For a nucleus target carried by any `S(3,4,n)`, let `a_k` count successful `k`-survivor sets.
There are

```text
a_4 = b = n(n-1)(n-2)/24,
a_5 = b(n-4).
```

The second identity holds because two blocks meet in at most two points, so a five-set contains at
most one block. The verifier obtains `(a_4,a_5)=(30,180)` at q=9 (`n=10`) and
`(819,19656)` at q=27 (`n=28`). Higher layers are exactly the complement of the block-free-set
enumerator, but C244 does not open that harmonic-arc problem.

The existing overlap census also makes C219's Poisson convergence quantitative with no new
classification. Let `X` count retained SQS blocks when each point survives with probability `s`,
let `b` be the block count, and let `P_1,P_2` be the unordered numbers of block pairs meeting in
one and two points. The dependency-graph Chen--Stein bound gives

```text
d_TV(Law(X), Poisson(b s^4))
 <= 2 [b s^8 + 2(P_1+P_2)s^8 + 2P_1 s^7 + 2P_2 s^6].
```

Using C219's exact formulas for `P_1,P_2`, this is `O(n^(-1/4))` at
`s=c n^(-3/4)` for fixed `c`. For the derived `S(2,3,m)` at a curve target, conditional on the
nucleus surviving, the analogous explicit bound is

```text
d_TV <= 2 [t s^6 + 2P_1 s^6 + 2P_1 s^5]
        = O(m^(-1/3))
```

at `s=c m^(-2/3)`, where `t=m(m-1)/6` and `P_1=m(m-1)(m-3)/8`. These are direct applications of
the Arratia--Goldstein--Gordon dependency bound
([DOI 10.1214/aop/1176991491](https://doi.org/10.1214/aop/1176991491)).

The brainstorm's additional phrase “sharp lower-tail exponent from Janson” is not promoted: no
precise regime or bound was stated, and recovering one would exceed the no-new-classification
gate. The explicit total-variation rates are the free quantitative consequence.

## 5. Split enumerator: useful, but standard

For a q-ary `[N,K]` row code `C` and distinguished nonloop coordinate `x`, define

```text
W_0(A,B) = sum_(c in C, c_x=0) A^(N-1-wt(c_-x)) B^wt(c_-x),
W_1(A,B) = sum_(c in C, c_x!=0) A^(N-1-wt(c_-x)) B^wt(c_-x).
```

Then tautologically

```text
W_C(A,B) = A W_0(A,B) + B W_1(A,B).
```

After puncturing `x`, the coordinate-zero subcode has column matroid `M/x`. Therefore ordinary
Greene gives `W_0` from `T_(M/x)`, while Greene gives `W_C` from `T_M`, and

```text
W_1 = [W_C-AW_0]/B.
```

So the `1+(N-1)` coordinate-split enumerator is determined by the deletion/contraction data that
underlies C227's one-element pointed perspective. The q=3 completed-cubic replay checks the split
identity and the contraction subcode directly.

This is not a new Greene theorem. Greene established ordinary weight enumeration from the Tutte
polynomial ([DOI 10.1002/sapm1976552119](https://doi.org/10.1002/sapm1976552119)), and
coordinate partitions already have generalized MacWilliams identities
([DOI 10.1016/0024-3795(93)00106-A](https://doi.org/10.1016/0024-3795(93)00106-A)). C226's
Ashikhmin--Kramer--ten Brink source already uses split information/support data on the BEC. The
repair-port value is therefore a short specialization and computational bridge, not a novelty
claim or standalone proposition.

## Paper disposition

The strongest additions to the main repair-port manuscript are the pointed-distance table, the
master enumerator with its exact two-target law, the corrected EXIT-deficit box, and the explicit
Poisson error rates. The early harmonic layers are concise corollaries. The split enumerator
belongs in positioning or a remark with standard citations.

Together with C243, this pack gives enough deterministic and probabilistic exact content for a
compact flagship section. It does not yet justify opening a separate harmonic-arc census, a
rate-deficit programme, or a threshold paper.

## Verification

[`2026-07-17-c244-exact-consequence-pack.py`](2026-07-17-c244-exact-consequence-pack.py) checks:

- all projective hyperplanes of the completed cubic--axis family at q=9 and q=27;
- the pointed distances and minimum-support counts for curve and axis targets;
- the master enumerator and direct joint-failure matrices at q=3 and q=9;
- Harris--FKG at an exact rational sample point;
- the full and radius-four harmonic EXIT profiles and corrected `[11,5]` area ledger;
- the `a_4,a_5` design layers and overlap counts at q=9 and q=27; and
- a direct q=3 coordinate-split/contraction-code example.

The deterministic output is
[`2026-07-17-c244-exact-consequence-pack.json`](2026-07-17-c244-exact-consequence-pack.json).
