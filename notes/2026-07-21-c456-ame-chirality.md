# C456 — chirality-conjugate `AME(6,11)` states

**Lane:** `crowns`

**Date:** 2026-07-21

**Verdict:** `EXACT LU/LC EQUIVALENCE AFTER PARTY PERMUTATION; CHIRALITY IS LABELED ADVICE`

## The theorem

Over `F_11`, use the C384 pencil

```text
H_t = [(0,1,1-t), (0,1,t-1), (1,1-t,0),
       (1,t-1,0), (1,0,-t),  (1,0,t)]
```

in the displayed party order, and define

```text
|Psi_t> = 11^(-3/2) sum_(c in ker(H_t)) |c>.
```

The two golden/chirality-conjugate specializations are `t=8` and `t=4`. Their reduced kernel
generators are

```text
G_8 = [1 0 0 | 3  7  1]      G_4 = [1 0 0 | 7  3  1]
      [0 1 0 | 3  1  7]            [0 1 0 | 7  1  3]
      [0 0 1 | 1 10 10]            [0 0 1 | 1 10 10].
```

Put

```text
pi = [0,1,4,5,3,2] = (2 4 3 5),
lambda = [4,7,1,1,1,1],
S_a |x> = |a*x mod 11>,
P_pi |x_0,...,x_5> = |y_0,...,y_5>,  y_(pi(j))=x_j.
```

Then the exact equality of normalized states is

```text
P_pi (S_4 tensor S_7 tensor I tensor I tensor I tensor I) |Psi_8> = |Psi_4>.
```

Each `S_a` is a one-qudit Clifford because it sends `X(u)` to `X(au)` and `Z(v)` to
`Z(a^-1 v)`. Therefore the chirality pair is local-Clifford, hence local-unitary, equivalent once
party permutation is allowed. No LU invariant of any degree can separate the resulting unlabeled
states; the task's conditional request for a lowest separating degree is therefore vacuous.

## Exact certificate

The direct parity-check intertwiner is

```text
B = [1  0 0]
    [0  0 1]
    [0 10 0],
```

and for every source party `j` the checker verifies

```text
B H_8[:,j] = lambda_j H_4[:,pi(j)].
```

It then independently enumerates all `11^3=1331` words of both kernels and checks that

```text
d_(pi(j)) = lambda_j c_j
```

maps `ker(H_8)` bijectively onto `ker(H_4)`. Since every support amplitude is the same positive
number, this is direct state-vector equality, not merely equality of stabilizer label spaces or an
orbit-size inference.

As a completeness check on the party-permutation trap, the certificate exhausts all `6!=720`
party maps. Exactly 60 extend to projective/monomial equivalences between the two ordered six-arcs;
the displayed `pi` is one of them, while the identity party map is not.

### Post-close upgrade: the 60 maps form an `A5` bitorsor

The number 60 is structural, not an accidental multiplicity. The checker independently computes
the projective party-automorphism groups of the `t=8` and `t=4` configurations. Both have order 60
and exact element-order profile

```text
1^1, 2^15, 3^20, 5^24,
```

hence are `A5`. Postcomposition by the target `A5` and precomposition by the source `A5` each act
freely and transitively on the 60 cross-chirality equivalences. Thus the equivalence set is an
exact `A5`--`A5` bitorsor: an equivalence exists, but none is canonical without an additional
marking. This upgrades “labeled advice” from loose wording to a precise torsor obstruction.

## What survives with labels

The chirality is not an invariant of the unlabeled quantum state. What survives is the ordered
projective six-arc datum: with the six party labels fixed, no projectivity plus coordinate scaling
carries `H_8` to `H_4`. Thus the honest remnant is external labeling/advice about which geometric
column occupies which party, not a second quantum LU orbit.

This boundary should not be overstated. C374's degree-six marginal invariant

```text
mu(E_1,E_2,E_3) = Tr(A_(E_1) A_(E_2) A_(E_3)) = 11^(-rank)
```

is blind even before relabeling: all 455 indexed values for `t=8` and `t=4` agree at identical
party labels. The checker recomputes those ranks both in shortening-coefficient coordinates and in
the ambient twelve-coordinate stabilizer space. Consequently this certificate does **not** prove
or disprove equivalence under arbitrary fixed-party local unitaries; it proves the exact positive
equivalence requested with party permutation and sharply locates the remaining geometric datum.

## Rosetta recommendation

Do not present the two chiralities as distinct entries in a quantum Rosetta row classified up to
local unitaries and party permutation. Either record the positive collapse as one checked quantum
row, or move the chirality distinction to labeled/advice framing. Any paper-facing use must state
the party-label convention explicitly.

## Reproduction and trusted boundary

Run from the repository root:

```bash
cd /home/tavis/src/othello
python3 notes/2026-07-21-c456-ame-chirality.py --check
sha256sum -c notes/2026-07-21-c456-ame-chirality.sha256
```

| artifact | bytes | SHA-256 |
|:---|---:|:---|
| checker `.py` | 15,136 | `34b7ba678e576dea10f790a2fb7c62920a22c5ab16b05cc1040575592578f260` |
| certificate `.json` | 8,881 | `74fdbce454d4090cf6e6af46a50d107c55d1bfe34dbc5647d6b06164d7f93de3` |

The deterministic standard-library checker pins the SHA-256 hashes of the C374, C384, and C395
JSON inputs. Its trusted boundary is Python 3 integer arithmetic modulo 11, exact row reduction,
the standard parity-check/code dictionary, and the displayed action of computational-basis scaling
on prime-qudit Paulis. The codeword-support replay and the parity-check intertwiner are independent
representations of the equivalence. The two marginal-moment calculations share the stabilizer
construction but use coefficient-space and ambient-space ranks.

The certificate does not classify arbitrary phase deformations, AME states outside the frozen
pencil, or fixed-party LU equivalence. It makes no novelty or priority claim and therefore adds no
new literature-absence statement beyond the frozen input bundles.
