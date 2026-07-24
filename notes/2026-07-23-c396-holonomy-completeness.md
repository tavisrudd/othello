# C396 — holonomy completeness and the q=13 LU-moment collision

**Lane:** `crowns`

**Date:** 2026-07-23

**Verdict:** `THEOREM; HOLONOMY IS COMPLETE ON THE NON-GRS PENCIL AND FACTORS THROUGH ONE CLASSICAL SCALAR`

## The theorem

Let `F_q` be any finite field of odd order. For the ordered six-point pencil

```text
H_t =
(0,1,1-t), (0,1,t-1),
(1,1-t,0), (1,t-1,0),
(1,0,-t),  (1,0,t),
```

assume C395's admitted non-GRS condition

```text
t(t-1)(t^2-t+1)(t^2-3t+1)
 (t^4-4t^3+7t^2-4t+1) != 0.
```

Put

```text
A(t) = -4t(t-1)^2,
B(t) = (t^2-t+1)(t^2-3t+1),
z(t) = (B(t)/A(t))^2.
```

Then, for any two admitted non-GRS parameters `t,u`, the following are equivalent:

1. the six-arcs `H_t,H_u` are projectively equivalent, allowing party permutation;
2. their `[6,3,4]_q` kernels are monomially equivalent;
3. `z(t)=z(u)`; and
4. C374's 450-entry minimal-support holonomy signatures are equal; and
5. the associated equal-phase CSS states are local-Clifford equivalent, allowing party
   permutation.

Thus C374's holonomy signature exactly classifies the local-Clifford classes **inside this
pencil**, over every odd finite field. Indeed, projective equivalence supplies a monomial local
Clifford, while any local Clifford preserves the signature. This does not say that holonomy
classifies LC or LU orbits outside the pencil, or that different holonomy signatures imply
arbitrary-LU inequivalence.

The large quantum signature is highly redundant here: it recovers exactly one classical
six-point bracket scalar.

## Exact projective parameter quotient

Define

```text
y(t) = (t-1)^2/t.
```

The identities

```text
A(t) = -4t^2 y(t),
B(t) = t^2(y(t)^2-1)
```

give

```text
z(t) = (y(t)-y(t)^-1)^2/16.
```

Therefore `z(t)=z(u)` factors exactly as

```text
y(u) in {y(t), -y(t), y(t)^-1, -y(t)^-1}.
```

Every branch has an explicit projectivity. With zero-based party numbering, a matrix in the
second column sends the source column `j` of `H_t` to a nonzero scalar multiple of target column
`p(j)` of `H_u`.

| relation | projectivity | party permutation `p` |
|:---|:---|:---|
| `y(u)=y(t)` | `diag(1,(1-u)/(1-t),u/t)` | identity |
| `y(u)=-y(t)` | `diag(1,(1-u)/(1-t),-u/t)` | `(4 5)` |
| `y(u)=y(t)^-1` | `[[1,0,0],[0,0,(u-1)/t],[0,-u/(1-t),0]]` | `(2 4)(3 5)` |
| `y(u)=-y(t)^-1` | `[[1,0,0],[0,0,(1-u)/t],[0,-u/(1-t),0]]` | `(2 4 3 5)` |

All displayed denominators and determinants are nonzero under the admitted condition. Direct
column substitution proves the four identities. Conversely, the ten signed complementary-triple
bracket products of `H_t` are

```text
{+A,+A,+A,-A,-A,-A,+B,+B,-B,-B}.
```

A projectivity and six independent column rescalings multiply all ten products by one common
nonzero scalar, while a party permutation permutes them up to one common sign. The multiplicities
`3` and `2` therefore recover `(B/A)^2=z`. This proves the projective equivalence.

As a map of projective parameter lines, `z(t)` has degree eight. Hence every geometric
projective/monomial/LC class meets this pencil in at most eight parameters, counted with
multiplicity over the algebraic closure. The four `y` relations and the quadratic
`t+t^-1=y+2` explain those eight sheets.

## Why the holonomy signature recovers `z`

For every holonomy matrix `M`, form the conjugacy-and-inversion invariant

```text
r(M) = Tr(M)^2 / det(M).
```

It is derived from C374's recorded `(trace,determinant)` pair. Exact rational-function expansion
of all 450 entries gives the following multiset:

| value | multiplicity |
|:---|---:|
| `4` | 90 |
| `-1/z` | 144 |
| `(2z+1)^2/z^2` | 24 |
| each root of `X^2-8X+(8-16z-1/z)` | 96 |

Specialization can merge bins, so the proof must not assume five distinct values. The identity

```text
4B(t)^2 + A(t)^2
  = 4(t^4-4t^3+7t^2-4t+1)^2
```

shows that the excluded GRS locus is exactly `z=-1/4`. Away from it, the constant `4` bin is
isolated and the two quadratic roots are distinct. The bin containing `-1/z` can merge with
neither, one, or both of the weight-24 and one weight-96 contributions. Its total multiplicity is
therefore exactly one of

```text
144, 168, 240, 264.
```

No other bin has one of those multiplicities. Hence the holonomy multiset canonically identifies
the value `-1/z`, even in every modular collision pattern. Equality of signatures forces equality
of `z`, and the explicit projectivities above finish the converse.

At the GRS value `z=-1/4`, all five displayed derived-ratio values become `4`; the entire derived
ratio multiset collapses to `4^450`. This is why the non-GRS hypothesis is a sharp reconstruction
boundary, not merely a convenience inherited from C395.

The `90` constant entries also have a clean combinatorial source: for each of the fifteen party
pairs, the six four-party supports correspond to the six edges on the other four parties. The
three disjoint edge-pairs give `15*3*2=90` oriented holonomies with `r=4`.

## Mandatory q=13 failure

Over `F_13`, the admitted non-GRS parameters form exactly two projective/monomial classes:

| class parameters | `z` | moment distribution | holonomy recovery bin |
|:---|---:|:---|:---|
| `{3,9,12}` | `12` | `((4,66),(6,389))` | value `1`, multiplicity `168` |
| `{2,5,6,7,8,11}` | `4` | `((4,66),(6,389))` | value `3`, multiplicity `144` |

Thus C374's arbitrary-LU triple-marginal moment does **not** classify even this one-parameter
pencil: it has one bucket containing two projectively inequivalent classes. C402 explains the
collision geometrically—both classes have six matchings concurrent in the arc and its Gale
dual—but the bracket scalar `z` distinguishes them.

This remains an invariant collision, not evidence that the two states are LU-equivalent.
Holonomy proves that they are not local-Clifford equivalent; a non-Clifford LU equivalence is
neither proved nor excluded.

## Exact evidence and replay

Run from the repository root:

```bash
cd /home/tavis/src/othello
python3 notes/2026-07-23-c396-holonomy-completeness.py --check
sha256sum -c notes/2026-07-23-c396-holonomy-completeness.sha256
```

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| checker `.py` | 39,319 | `42c1074798e3c0a052a9280361fc565e50228be08909da952933b380db4e0680` |
| certificate `.json` | 748,820 | `9158a9b37fb6232f110a1f011eba49a80dff0e1dcce3f377c7cb7fe8feb84ec9` |

The standard-library checker imports the hash-pinned C395 finite-field implementation. It
verifies:

- the ten symbolic bracket-product identities;
- all 450 rational-function holonomy ratios and the exact `90/144/24/96/96` split;
- the GRS boundary identity;
- canonical projective classes, independent pairwise projectivity tests, and explicit formula
  projectivities for every same-`z` parameter in each replay field;
- independent direct-Lagrangian holonomy and moment calculations in the marked fields; and
- the q=13 two-class, one-moment-bucket failure.

The replay fields are the prime fields

```text
F_7,F_11,F_13,F_17,F_19,F_23,F_29,F_31
```

and genuine extension fields

```text
F_9,F_25,F_27,F_49.
```

Their non-GRS projective/z/holonomy class counts are respectively

```text
1,2,2,3,4,5,6,7,1,4,6,11.
```

The all-field theorem rests on the symbolic identities and four explicit projectivities, not on
extrapolation from this list. The trusted boundary is exact polynomial/rational-function
arithmetic, deterministic arithmetic in the displayed finite-field quotients, Gaussian
elimination, and the standard arc--MDS and projective--monomial dictionaries. The direct
Lagrangian replay is independent of the CSS shortening formula but shares the finite-field
kernel.

## `ej`/Tao closeout and mystery ledger

The closeout changes the interpretation of the result. Holonomy is complete for LC equivalence on
the pencil, but
not because 450 quantum entries retain 450 independent pieces of information: their
inversion-conjugacy ratios collapse to the single GIT-style bracket coordinate `z`. The sharp
non-GRS boundary is essential—at `z=-1/4`, precisely the GRS quartic, the recovery bins coalesce.

| feature | disposition |
|:---|:---|
| Why the q=13 moment invariant collides | **Settled geometrically by C402:** both classes have six common arc/Gale concurrence matchings. |
| What separates the two q=13 projective classes | **Settled:** their bracket coordinates are `z=12` and `z=4`; holonomy canonically recovers these values. |
| Whether holonomy collisions appear over prime-power fields | **Settled by theorem, not census:** equality of signatures recovers `z`, and equality of `z` supplies one of four explicit projectivities. |
| Why a 450-entry signature can be complete on a one-parameter pencil | **Settled:** its derived ratio histogram contains the unique `-1/z` recovery bin. |
| How large a pencil class can be | **Settled by the Tao pass:** `deg z=8`, so a geometric projective/monomial/LC fibre has at most eight parameters counted with multiplicity. |
| Why the proof excludes GRS members | **Settled sharply:** `z=-1/4` is exactly the GRS quartic, where the full derived-ratio histogram collapses to `4^450`. |
| Whether holonomy classifies arbitrary LC or LU orbits | **Outside C396 and not implied:** C397 owns the operational Clifford classification; arbitrary LU completeness is not claimed. |

No genuine C396 mystery remains.

## Literature and ownership boundary

No external paper was newly read for C396, and no novelty or priority claim is made. C374's source
audit remains authoritative for the Pauli/Lagrangian holonomy construction and its LC covariance;
C384's audit remains authoritative for polynomial LU invariants and the finite q=11 pencil.
Classical bracket invariants of six points are used here through a direct determinant calculation,
not claimed as new invariant theory.

C395 retains the all-odd-field arc/GRS arithmetic. C374 retains the invariant definitions and
covariance proofs. C396 owns only the exact parameter quotient, the q=13 moment failure, and the
holonomy-completeness theorem for this displayed non-GRS pencil.
