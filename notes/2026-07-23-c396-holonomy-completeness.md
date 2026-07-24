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

## Second-order Tao pass: one cover explains both exceptional primes

The degree-eight map is not a featureless quotient. It factors as

```text
t -> y=t+t^-1-2 -> z=(y-y^-1)^2/16
```

with degrees two and four. The second map is branched over `z=0,-1/4,infinity`.
The first map is branched at `t=1,-1`; `t=1` maps to the already-degenerate point
`y=0`, while `t=-1` is C395's nondegenerate tetrahedral specialization and supplies
the fourth branch value

```text
y(-1)=-4,             z_* = z(-1)=225/256.
```

This exposes exact mechanisms behind both arithmetic symmetry jumps found independently in
C395. First,

```text
z_* - (-1/4) = 289/256 = 17^2/2^8.
```

Thus in characteristic `17` the tetrahedral branch collides with the GRS reconstruction
boundary. This is exactly the characteristic where C395 found the simultaneous tetrahedral
`S_4` and GRS jump.

Second, let

```text
Q_z(X)=X^2-8X+(8-16z-1/z)
```

be the polynomial for the two weight-96 holonomy bins. At the tetrahedral branch,

```text
Q_z*(-1/z_*) = 2589151/810000 = 17^4*31/30^4.
```

After the inadmissible denominator characteristics `3,5` and the characteristic-17 GRS
collision are removed, characteristic `31` is therefore exactly where the weight-144 recovery
bin meets one weight-96 bin, producing multiplicity `240`. The direct certificate confirms
that the `F_31` class `{12,13,18,19,30}` has `z=1` and recovery bin
`(-1,240)`. This matches C395's non-GRS tetrahedral `A_5` stabilizer enhancement.

The bin collision does not by itself prove a general theorem that every such collision forces
`A_5`; C395 independently proves that stabilizer. What it does prove is that the same scalar
cover and the same holonomy spectrum locate both exceptional characteristics exactly, rather
than merely reproducing them by census.

There is also a latent two-sheeted refinement before the final square:

```text
w(t)=B(t)/A(t)=-(y-y^-1)/4,             z=w^2.
```

Of the four exact `y`-symmetries, `y -> y,-y^-1` preserve `w`, while
`y -> -y,y^-1` reverse it. Thus `w` is an exact signed bracket coordinate on an index-two
refinement of the projective quotient, although it is not needed for the all-party-permutation LC
classification. At the tetrahedral point `w_*=15/16`; it reduces to `-2` in characteristic `17`
and `-1` in characteristic `31`. This is the same algebraic *shape* as the determinant-sign and
Gale-sheet torsors elsewhere in the programme. Identifying these covers is a concrete open theorem,
not assumed here.

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
| checker `.py` | 41,305 | `b536913531c7393e92633b2c6521df50aa32a823a95cc4e92285a0955cc8fa49` |
| certificate `.json` | 749,580 | `04b791acae107d24c81c589059c8a310c01e6feaac9c4713bdb1e9d323e29031` |

The standard-library checker imports the hash-pinned C395 finite-field implementation. It
verifies:

- the ten symbolic bracket-product identities;
- all 450 rational-function holonomy ratios and the exact `90/144/24/96/96` split;
- the GRS boundary identity;
- the four branch values of the degree-eight cover, the characteristic-17 branch collision,
  and the characteristic-31 recovery-bin collision;
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
| Why characteristic `17` has the tetrahedral `S_4`/GRS jump | **Settled:** the nondegenerate branch value `z_*=225/256` collides with `-1/4` precisely because their gap is `17^2/2^8`. |
| Why characteristic `31` has the non-GRS tetrahedral `A_5` jump | **Settled at the invariant mechanism level:** `Q_z*(-1/z_*)=17^4*31/30^4`, so the recovery and weight-96 bins fuse to multiplicity `240` exactly there; C395 independently supplies the `A_5` stabilizer theorem. |
| Whether holonomy classifies arbitrary LC or LU orbits | **Outside C396 and not implied:** C397 owns the operational Clifford classification; arbitrary LU completeness is not claimed. |

No genuine C396 mystery remains.

## Boundary map: what is known and where to push

The theorem closes its stated LC problem, but it exposes several larger frontiers. They are not
equally speculative:

| frontier | known boundary | C396 contribution | next push and plausible proof route |
|:---|:---|:---|:---|
| **The q=13 LU collision** | Equal marginal moments need not imply LU equivalence; general LU and LC equivalence differ for stabilizer states. | The two classes have the same tested LU moment but different `z`, hence are not LC-equivalent. | **Decide actual LU equivalence.** Put both states into a common Schmidt/minimal-support normal form and solve the residual six one-site unitary equations exactly. A proof that every solution normalizes the local Pauli frames would upgrade the collision to LU-inequivalence; an exceptional solution would be a six-party non-Clifford LU identification. |
| **LU=LC on the whole pencil** | Complete LC invariants exist abstractly, while general LU=LC is false. Existing sufficient criteria are largely qubit/graph-state results and do not automatically settle this odd-prime family. | Holonomy gives a complete and explicit LC coordinate `z`. | **Prove or refute LU=LC for admitted `H_t`.** Generalize the minimal-support rigidity argument to odd prime powers: show that the overlapping weight-four reduced stabilizer frames force each local unitary to permute Weyl axes. This would turn C396 into an arbitrary-LU classification theorem. |
| **All six-arcs, not one pencil** | The ambient quotient of six ordered points in `P^2` is four-dimensional and classically understood through brackets, the Igusa quartic, and Gale duality. | On a one-dimensional locus, the 450 holonomies reduce to one quotient coordinate and are complete. | **Recover the full moduli point from holonomy.** Express the holonomy trace ring in the five classical mystic-pentagon coordinates, then test generic birationality and identify the exceptional divisor. This is the natural general completeness theorem; a finite census cannot substitute for the function-field calculation. |
| **Why symmetry jumps occur** | Automorphism strata of the associated cubic surfaces are classified in all characteristics, but tame primes `17,31` are not generic anomalies of that classification. | Two exact reductions of the pencil's cover/spectrum locate the independent `S_4`/GRS and `A_5` jumps. | **Make the mechanism scheme-theoretic.** Embed the `z`-line in the six-point/cubic-surface moduli space, intersect it with stabilizer strata, and compute the integral discriminant. This should decide whether `17` and `31` are the complete set of good-characteristic enhancement primes and explain the group enlargement, not just its spectral shadow. |
| **Non-GRS MDS/AME families** | Constructing and classifying non-GRS MDS codes remains active; broad MDS classification is open. | One non-GRS `[6,3,4]_q` family now has an all-odd-field equivalence quotient and LC classifier. | **Move beyond length six or this normal form.** Start with a structured twisted/non-GRS MDS family, construct its AME state, and ask whether minimal-support holonomies generate its projective invariant field. The proof target is a family theorem, not more isolated field enumerations. |
| **Smaller operational witnesses** | Abstract complete LC invariant sets can be very large; marginal moments can collide. | A 450-entry signature contains a canonically multiplicity-marked `-1/z` bin. | **Compress the witness.** Find the smallest party-symmetric subset or low-degree polynomial in marginal transition data that still recovers `z`, and prove minimality. This would turn the classification into a practical measurement/certification protocol. |
| **Exceptional-bin arithmetic** | Specialization can merge invariant values; no searched source gives this histogram's collision discriminant. | The recovery-bin proof handles every modular collision, with the tetrahedral `31` fusion now explicit. | **Classify the entire collision divisor.** Take resultants among all five bin values, factor them over `Z[z]`, and match every component with geometric degeneracy or stabilizer enhancement. This is a bounded algebraic project and a good first attack on the scheme-theoretic goal. |

The recommended order is: (1) solve the q=13 LU pair; (2) prove the odd-prime minimal-support
rigidity needed for LU=LC on the pencil; (3) compute the full bin-collision discriminant and map the
`z`-line into the classical six-point quotient; then (4) attempt generic holonomy completeness on
the four-dimensional six-arc moduli space. The first two decide the quantum meaning of the result;
the latter two decide its invariant-theoretic reach.

## Literature boundary and novelty calibration

A focused audit changes the framing, not the theorem. Storme--Van Maldeghem's 1995 paper
(read depth: partial full text, §4.2.4, Propositions 10--13 and Remark 2) constructs and proves
uniqueness of the `A5` six-arc and explicitly records its ten Brianchon points and five triangles.
Thus C396's `F_31` member is the classical Clebsch hexagon; neither that configuration nor its
`10+5` incidence is new.

Howard--Millson--Snowden--Vakil (read depth: full text, §§1--2) own the ambient bracket,
outer-`S6`, Igusa-quartic, and Gale-sheet invariant theory of six points in `P^2`
([arXiv:0710.5916](https://arxiv.org/abs/0710.5916)). Van den Nest--Dehaene--De Moor
(read depth: full text) own abstract complete LC invariant families for stabilizer states
([arXiv:quant-ph/0410165](https://arxiv.org/abs/quant-ph/0410165)). These sources do not contain
C396's transition holonomy or its pencil quotient.

The complete audit, including source-by-source depths, cache hashes, the 154-record OpenAlex screen,
the partially screened Crossref set, explicit coverage gaps, and the PRS/Clebsch/crowns overlap map,
is `2026-07-23-c396-tt2-literature-frontier-audit.md`. Within that bounded coverage, no exact
predecessor was located for `z(t)`, its holonomy recovery, or the common `17/31` arithmetic
mechanism. This is not a priority proof. The defensible wording is a **new-looking restricted
synthesis**: classical six-point invariant geometry becomes an explicit LC classifier for this
AME/MDS pencil, and one scalar cover explains two independently proved exceptional
specializations. No claim is made to new Clebsch geometry, ambient six-point invariant theory,
general MDS classification, or arbitrary-LU classification.

C395 retains the all-odd-field arc/GRS arithmetic. C374 retains the invariant definitions and
covariance proofs. C396 owns only the exact parameter quotient, the q=13 moment failure, and the
holonomy-completeness and exceptional-prime mechanism for this displayed non-GRS pencil.
