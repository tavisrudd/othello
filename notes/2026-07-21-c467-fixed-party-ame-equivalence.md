# C467 — fixed-party equivalence of the C456 `AME(6,11)` pair

**Lane:** `crowns`

**Date:** 2026-07-21

**Verdict:** `EXACT FIXED-PARTY LC/LU EQUIVALENCE; ALL LABELED LU INVARIANTS COLLAPSE`

## The theorem

Retain C456's equal-phase states

```text
|Psi_t> = 11^(-3/2) sum_(c in C_t) |c>,   C_t=ker(H_t),   t=8,4,
```

with the six party positions fixed. Put `omega=exp(2*pi*i/11)` and define the signed one-qudit
Fourier transform

```text
F_s |x> = 11^(-1/2) sum_(y in F_11) omega^(s*x*y) |y>.
```

Then the exact state-vector identity is

```text
(F_-1 tensor F_-1 tensor F_-1 tensor F_-1 tensor F_+1 tensor F_+1) |Psi_8>
    = |Psi_4>.
```

There is no party permutation and the global phase is `+1`. Hence the two chiralities are
fixed-party local-Clifford equivalent and therefore fixed-party local-unitary equivalent.

More generally, for every `a in F_11^*`, with `s=a^-1`,

```text
(F_-s)^tensor4 tensor (F_s)^tensor2
```

gives the same exact map. These ten maps are exactly the fixed-party symplectic solutions found by
the complete LC search.

## Direct Fourier proof

For an output word `y`, character orthogonality makes its transformed amplitude vanish unless

```text
diag(-1,-1,-1,-1,+1,+1) y in C_8^perp.
```

The checker proves the exact code identity

```text
diag(-1,-1,-1,-1,+1,+1) C_8^perp = C_4
```

by enumerating all 1,331 words on each side. On this support the character sum is `11^3`, leaving
the normalized amplitude `11^(-3/2)` with phase `+1`. Multiplying all six signs by the common
nonzero scalar `a^-1` does not change the linear support, which proves all ten maps; the checker also
replays all ten support equalities separately.

In Pauli-label coordinates, `F_s` induces

```text
(x,z) -> (-s^-1 z, s x).
```

For the representative `a=1`, the first four symplectic blocks are

```text
[[0,1],[-1,0]],
```

and the last two are their inverses `[[0,-1],[1,0]]`, all entries read modulo 11.

## Complete fixed-party LC search

Independently of the Fourier character-sum proof, the checker reconstructs every four-party
minimal-support stabilizer shortening. With the identity party map fixed, one anchor block in
`SL_2(11)` forces the other five local blocks through the support transition maps.

It exhausts all `|SL_2(11)|=1320` anchors:

```text
determinant failures:          0
support-relation failures: 1310
fully consistent solutions:  10
```

Every consistent candidate is checked against the complete six-dimensional stabilizer rowspace,
and the resulting ten blocks are exactly the signed Fourier family above. Thus the finite search is
complete, while the direct Fourier proof upgrades stabilizer-space equivalence to exact normalized
state-vector equality.

## Degree-eight and all-degree invariant verdict

A bidegree `(4,4)` six-party contraction is indexed by six permutations in `S_4`, giving

```text
24^6 = 191,102,976
```

raw indexed contractions, or `24^5 = 7,962,624` after fixing one copy-permutation gauge. The
explicit fixed-party local unitary proves that every one agrees individually between `|Psi_8>` and
`|Psi_4>`; enumeration is unnecessary because local-unitary invariance applies to each indexed
contraction, not merely to their multiset.

The stronger conclusion is that **every fixed-party LU invariant at every degree agrees**. There is
no lowest labeled separating degree. C456's surprising equality of all 455 indexed degree-six
marginal moments was the first shadow of the Fourier equivalence, not an accidental low-degree
collision.

## Consequence for chirality and the torsor

Even fixed party labels do not turn the two chiralities into distinct quantum states up to local
unitaries. The ordered projective six-arc chirality remains meaningful only when the geometric
presentation is retained as external advice; it is not encoded by the AME state alone.

C456's `A5`--`A5` bitorsor still correctly describes the noncanonical **monomial/projective**
identifications. C467 shows that leaving that subgroup and using local Fourier duality supplies a
canonical-looking fixed-party representative. No automorphism-rigidity obstruction is needed; the
proposed order-four obstruction fails because the relevant state automorphism group is strictly
larger than its projective/monomial shadow.

## Post-close upgrade: uniform golden Fourier duality

The q=11 map is the reduction of a polynomial identity, not a finite-field coincidence. Over the
integer polynomial ring, direct expansion gives

```text
H_(1-t) diag(-1,-1,-1,-1,+1,+1) H_t^T
    = diag(0, 2(t^2-t-1), 0).
```

Therefore, over any odd field containing a root of `t^2-t-1`, the two golden-conjugate pencil
members satisfy

```text
diag(-1,-1,-1,-1,+1,+1) C_t^perp = C_(1-t),
```

The four C395 arc factors reduce to `t`, `t-1`, `2`, and `2(1-t)`, all nonzero for a golden root in
odd characteristic, so both sides are rank-three six-arcs. The same signed fixed-party Fourier
transform therefore exchanges their equal-phase CSS states. At q=11
the roots are `8` and `4`, recovering the certified C467 map. In characteristic 5 the roots
coalesce, and the statement becomes signed Fourier self-duality. Thus golden Galois conjugation in
this pencil is implemented quantum-mechanically by local Fourier duality uniformly across odd
finite-field realizations.

### Universal inversion symmetry

A second identity holds away from `t=0`, without imposing the golden equation:

```text
H_(1/t) diag(1,1,-t,-t,-t,-t) = diag(-t,1,-t^-1) H_t.
```

Consequently computational-basis scaling by `(1,1,-t,-t,-t,-t)` maps `C_t` exactly onto
`C_(1/t)` and gives a fixed-party local-Clifford equivalence

```text
|Psi_t>  ~  |Psi_(1/t)>.
```

At q=11 this gives the pairs `{2,6}`, `{3,4}`, `{7,8}`, and the fixed point `{10}`. Golden Fourier
duality `4<->8` then joins the middle two inversion pairs, producing the complete four-element class
`{3,4,7,8}`. Thus the q=11 quotient is generated by two transparent mechanisms—universal
parameter inversion and golden-locus Fourier duality—rather than by 49 unrelated LC searches.

## Second-order upgrade: complete fixed-party q=11 pencil quotient

The same transition-forcing and indexed-moment machinery classifies all seven admitted C384
parameters with party labels fixed. Exhausting all 49 ordered parameter pairs gives exactly three
LC classes:

```text
{2,6},   {3,4,7,8},   {10}.
```

Every ordered pair within a block has exactly ten fixed-party Clifford maps; every pair across
blocks has none. Independently, the complete 455-entry indexed degree-six marginal-moment vectors
have exactly the same three collision blocks. Representative separating entries are:

| parameters | omitted party pairs | moments |
|:---|:---|:---|
| `2 / 3` | `{0,2}, {1,4}, {3,5}` | `11^-6 / 11^-4` |
| `2 / 10` | `{0,2}, {1,5}, {3,4}` | `11^-4 / 11^-6` |
| `3 / 10` | `{0,2}, {1,4}, {3,5}` | `11^-4 / 11^-6` |

Thus the displayed finite pencil has exactly three fixed-party LU classes: Clifford witnesses prove
equivalence within each block, and a labeled LU invariant separates different blocks. The ambient
twelve-coordinate replay independently reproduces every moment vector.

Degree six is the lowest possible separating total degree. Degree two is only normalization, and
every degree-four pure-state contraction is a marginal purity; for an `AME(6,11)` state these are
fixed by maximal mixing for subsets of size at most three and by pure-state complementarity beyond
three. C384's two classes after allowing party permutations are recovered by fusing the first two
fixed-label blocks, while `{10}` remains separate.

## Reproduction and trusted boundary

Run from the repository root:

```bash
cd /home/tavis/src/othello
python3 notes/2026-07-21-c467-fixed-party-ame-equivalence.py --check
sha256sum -c notes/2026-07-21-c467-fixed-party-ame-equivalence.sha256
```

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| checker `.py` | 16,048 | `bf1d0673cec1e98032b2593e441bc84fb3bf6ceb5f1224eef947655d3dc36031` |
| certificate `.json` | 32,273 | `dda6a1be0ab667f1312f943a0cf8679b1ae68c1d41981fb0d737e8894015cec5` |

The deterministic checker hash-pins the C374, C384, and C456 scripts/certificates. Its trusted
boundary is Python 3 arithmetic modulo 11, exact row reduction, prime-field character
orthogonality, and the standard prime-qudit Clifford action. The support-enumeration/Fourier proof
and the transition-forced stabilizer search are independent representations of the equivalence.

The result does not identify the ordered projective arcs, erase their external golden labeling, or
classify phase-deformed and non-stabilizer AME states. It makes no novelty or priority claim and
adds no literature-absence statement.
