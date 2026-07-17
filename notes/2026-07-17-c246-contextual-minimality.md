# C246 — realizable separator profiles and contextual minimality

**Lane:** `rp-next`

**Date:** 2026-07-17

**Status:** COMPLETE — realizable profiles have an exact intrinsic characterization. C241's raw
response table is sound but not fully abstract or minimal. Convolution with the incoming profile,
restricted to realizable inputs, is the fully abstract minimal structural semantics.

## Result at a glance

Let `B` be a finite-dimensional separator over `GF(q)`, fix repair radius `r`, and write

```text
Q_r = {0,1,...,r,infinity},
a (+)_r b = a+b if a,b are finite and a+b <= r, and infinity otherwise.
```

A profile `d : B -> Q_r` is the truncated minimum support cost of some active represented context
if and only if

```text
(R0) d(0)=0;
(R1) d(b)>0 for b!=0;
(R2) d(lambda b)=d(b) for every lambda!=0;
(R3) d(b+c) <= d(b) (+)_r d(c).                         (1)
```

Thus the arbitrary normalized carrier `P(B)` from C241 is a convenient finite overapproximation.
Its realizable subcarrier consists exactly of positive projectively invariant truncated
subadditive profiles.

For a seeded component `X`, let `chi_X(d)` be C241's local outgoing profile and let `star` denote
separator min-sum convolution. Define the **effective response**

```text
Phi_X(d) = d star chi_X(d),                              (2)
```

only for realizable `d`. Then two components with the same labeled boundary are structurally
interchangeable in every represented context if and only if their `Phi` maps agree. Equality of
the full raw `chi` tables remains sufficient, as proved in C241, but it is strictly stronger than
contextual equivalence.

## Theorem 1 — exact realizability

### Necessity

Suppose active columns `A` realize `d`. The empty combination gives (R0), while no empty
combination gives a nonzero vector, proving (R1). Rescaling coefficients proves (R2). Concatenating
supports for `b` and `c` proves (R3); overlapping or cancellation can only reduce the union support.
Truncation removes the constraint when the two known costs sum beyond `r`.

### Sufficiency

Choose one representative `p` of each projective point with finite cost `d(p)=k`. Give it a fresh
private space of dimension `k-1`.

- If `k=1`, use the single active column `p`.
- If `k>=2`, use the `k` active columns

  ```text
  e_1, ..., e_(k-1), p-e_1-...-e_(k-1).                 (3)
  ```

The private spaces for distinct projective points are direct summands. A linear combination of a
gadget (3) lands back in `B` only when all `k` coefficients are equal; it then gives a scalar
multiple of `p` with support exactly `k`. Therefore every support representation assembled from
the gadgets is a projective decomposition

```text
b = lambda_1 p_1 + ... + lambda_t p_t
```

of cost `sum_i d(p_i)`. Repeated use of (R2)--(R3) makes that cost at least `d(b)`, while `b`'s own
gadget attains `d(b)`. The constructed active columns therefore realize `d` exactly through radius
`r`.

If a context side must span all of `B`, add an unseeded `(r+1)`-column version of (3) for each
basis vector of `B`. These dormant gadgets put `B` in the full represented span but cannot fire at
radius `r`; their fresh private coordinates keep them from changing the active profile. Hence the
characterization applies to genuine separator contexts, not only isolated active column lists.

This description is equivalently a truncated quotient-Hamming metric: coefficients whose private
sum vanishes form a linear code, the boundary sum is its quotient map, and `d(b)` is the minimum
Hamming weight in the fiber over `b`. That terminology is descriptive here; no external novelty
claim is attached to it.

## Theorem 2 — full abstraction and minimality

For a context active set `A` with profile `d`, saturate `X` under `d` and call its active local set
`K_X(d)`. The support-splitting lemma from C241 gives

```text
profile(A union K_X(d)) = d star chi_X(d) = Phi_X(d).    (4)
```

### Sufficiency

Assume `Phi_X=Phi_Y` on every realizable input. During terminal Horn chaining, the currently active
context columns always give a realizable `d`. Equation (4) says that the total boundary capability
after batching either component is identical.

More explicitly, take any repair witness using local columns of `X`; their sum lies in `B`.
Equality in (4) supplies a support-no-larger representation of that boundary sum using the same
active context plus `Y`. Replacing the local columns preserves the target sum. If some context
columns occur in both pieces, coefficient addition or cancellation only decreases support. Thus
every next context activation possible with `X` is possible with `Y`, and conversely. Induction on
parallel Horn rounds, or equivalently equality of the least fixed points, gives identical
context-private terminal active/core decisions.

### Necessity and distinguishing observer

Suppose a realizable input `d` and boundary vector `b` satisfy

```text
Phi_X(d)(b)=c < c'=Phi_Y(d)(b).
```

Realize `d` by Theorem 1. Add `r-c` seeded helpers in fresh private coordinate directions and one
unseeded observer target

```text
t = b + e_1 + ... + e_(r-c).                            (5)
```

The fresh coordinates force every repair of `t` to use all padding helpers; what remains must
synthesize `b`. Hence `t` has cost exactly `r` with `X` and cost greater than `r` with `Y`.
It activates only in the former context. Swapping `X,Y` handles the opposite inequality. Every
unequal effective map therefore has a finite represented distinguishing context, proving both
full abstraction and minimality.

## Why the raw response is not minimal

There are two independent redundancies in C241's table:

1. entries at inputs violating (R0)--(R3) can never be supplied by a represented context;
2. even at a realizable input, a local output can be masked by a cheaper capability already in the
   input.

The second has a uniform example for every field and radius. On a one-dimensional boundary with
vector `b`, seed private helpers `e_1,...,e_(r-1)`. Component `X` additionally contains the
unseeded column

```text
t = b + e_1 + ... + e_(r-1),
```

while `Y` contains only the seeded private helpers. When the input supplies `b` at cost one, `X`
activates `t` and locally emits `b` at cost `r`; `Y` emits nothing. Their raw `chi` values differ,
but the input's cost-one copy masks the difference, so `Phi_X=Phi_Y`. At every other realizable
one-dimensional input, `t` does not activate and the raw outputs already agree. Thus `X,Y` are
structurally contextually equivalent despite unequal raw response maps.

This example also marks the observation boundary. `X` has one extra local activation at the masked
input. If exact total active/core counts are observable, the minimal state must retain C241's
corresponding weight table:

```text
(Phi_X, omega_X) restricted to realizable inputs.        (6)
```

Unequal weights are distinguished simply by a context realizing that input; equal effective
responses make the context evolution identical, and the weights then add exactly as in C241.

## Exhaustive replay

The certificate enumerates every scalar-invariant positive profile on a two-dimensional boundary,
filters (R3), constructs the direct-sum gadgets, and recomputes their support profiles independently.

| Field | Radius | scalar-invariant candidates | realizable profiles |
|---|---:|---:|---:|
| `GF(2)` | 1 | 8 | 8 |
| `GF(2)` | 2 | 27 | 24 |
| `GF(2)` | 3 | 64 | 52 |
| `GF(3)` | 1 | 16 | 16 |
| `GF(3)` | 2 | 81 | 59 |
| `GF(3)` | 3 | 256 | 152 |

Across these 311 profiles it checks 1,457 finite-coordinate padding observers. It also replays the
raw-response counterexample over `GF(2)` and `GF(3)` at radii one, two, and three: all 18 realizable
one-dimensional inputs have equal effective responses, while exactly the cost-one input gives
unequal raw responses and an extra local activation.

[`2026-07-17-c246-contextual-minimality.py`](2026-07-17-c246-contextual-minimality.py) writes the
exact certificate
[`2026-07-17-c246-contextual-minimality.json`](2026-07-17-c246-contextual-minimality.json).

Run from `rust/`:

```bash
python3 ../notes/2026-07-17-c246-contextual-minimality.py
```

## Disposition

C246 passes its strongest success gate: the realizable carrier is characterized, the sound C241
semantics is strictly quotiented, and every remaining structural inequality has an explicit
represented distinguishing context. The correct claim is:

- raw `chi` on all normalized profiles: **sound, not fully abstract, not minimal**;
- effective `Phi` on realizable profiles: **sound, fully abstract, and minimal** for structural
  context-private terminal observations;
- `(Phi,omega)` on realizable profiles: the corresponding fully abstract state when exact terminal
  active/core totals are also observed.

The adjacent-opening audit keeps the theorem fixed and instead asks for the minimum column count
and auxiliary dimension realizing one exact profile; see
[`2026-07-17-c245-c249-adjacent-novel-openings.md`](2026-07-17-c245-c249-adjacent-novel-openings.md).
