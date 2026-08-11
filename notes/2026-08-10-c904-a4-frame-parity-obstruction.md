# C904: the A4 frame and its exact two-primary obstruction

Date: 2026-08-10

Status: exact quarantined research theorem.  No manuscript or Lean source was
edited.

## Executive verdict

The most promising cross-family odd-frame construction fails for a structural
reason.

For an `A4` subgroup of `A5`,

```text
V4|A4 = 1 + 3,
W5|A4 = 1' + 1'' + 3.
```

Hence `Hom_A4(V4,W5)` is one-dimensional and its nonzero map has rank three.
The five conjugate maps form a tight rational frame.  With the actual Winger
and cubic axis polarizations their frame scalar is

```text
12/5.
```

Its square class is `15`: scaling the primitive map `B` by `5/2` would make
the frame sum `15 I`.  That is exactly the odd multiplier that would combine
with the known cubic `[2]` cycle by Bezout.

It is not integral.  The primitive map has mod-two rank three.  A half-scaled
map tensored with the rank-two elliptic lattice therefore has six-dimensional
mod-two image, whereas any principal cubic gluing is a four-dimensional
maximal isotropic in the eight-dimensional two-primary discriminant space.
The cubic discriminant has exponent two, so no deeper denominator is
available.  Thus the exotic `F4` gluing cannot absorb the half.

> Every integral frame obtained from the five conjugates of the unique
> `A4` map has even multiplier on the cubic intermediate Jacobian.

This kills the `A4` odd-frame route.  It does not weaken the rational
cubic--Winger Morita correspondence, whose optimal twenty-dimensional
carrier remains valid.  It says that this carrier cannot solve the relative
universal-cycle gate by its most symmetric rank-three contraction.

## 1. The unique rank-three map

Use the deleted permutation models

```text
V0 = Z^5/Z1,
W0 = Z^6/Z1.
```

The character restrictions above give a single common irreducible `3`, hence

```text
dim_Q Hom_A4(V4,W5)=1.
```

Solving the integral invariance equations in the ambient zero-row/zero-column
matrix model gives, up to sign,

```text
 0  1  1 -1 -1
 0 -1 -1  1  1
 0  1 -1  1 -1
 0 -1  1 -1  1
 0 -1  1  1 -1
 0  1 -1 -1  1.
```

Each column has constant parity.  Dividing by two after passing to the
quotient lattices therefore gives a primitive integral map

```text
B: V0 -> W0
```

of rational and mod-two rank three.  Its five conjugates are indexed by the
five `A4` subgroups.

## 2. The polarized frame scalar

The exact twin-simplex polarizations are

```text
Q_W = 3(5 I_4-J_4),
Q_X = 6 I_5-J_5.
```

For the five conjugates `B_K`, exact rational matrix arithmetic gives

```text
sum_K B_K Q_W^{-1} B_K^t = (12/5) Q_X^{-1}.
```

Equivalently, after identifying the common non-CM elliptic multiplicity
factor, the induced rational Rosati frame on the cubic `W5` factor is
`(12/5) I`.  Since the `A4`-fixed line is unique, any conjugacy-compatible
rescaling changes this scalar by a rational square.

The smallest odd integral representative of its square class is

```text
(12/5)(5/2)^2 = 15.
```

The primes have a transparent meaning: five clears the Winger-only residue,
while the denominator two attempts to use the cubic-only exotic gluing.

## 3. Why the half cannot be integral

The cubic axis polarization has

```text
SNF(Q_X)=(1,6,6,6,6).
```

Thus its two-primary discriminant has dimension eight and exponent two.  A
principal intermediate-Jacobian lattice is obtained by adjoining a maximal
isotropic of dimension four.  This includes all five `A5`-stable gluings,
classical and exotic.

Suppose a rational scaling of the `A4` frame had odd integral multiplier.
The scalar formula forces its two-adic valuation to be `-1`: the map must be
half-integral.  The generic common elliptic factor is non-CM, so an odd-degree
multiplicity map is invertible modulo two.  The denominator class of the
candidate map consequently has dimension

```text
rank_F2(B) * rank_F2(H_1(E)) = 3*2 = 6.
```

No six-dimensional subspace can lie in a four-dimensional gluing isotropic.
Therefore the half-scaled map does not land in the principal cubic lattice.
If the elliptic multiplier is even, or if the representation map is scaled
integrally, the resulting frame multiplier is even.  These exhaust the
possibilities because the two-primary discriminant has exponent two.

This obstruction is stronger than checking the two exotic slopes one by
one: it rules out every principal gluing simultaneously by dimension.

## 4. Consequences and surviving gate

This branch is now closed, not merely deferred.

- The rational twenty-dimensional cubic--Winger carrier and its twisted
  power isogeny remain valuable Paper-V upgrades.
- No five-member `A4` frame extracted from that carrier supplies the missing
  odd relative Abel--Jacobi multiplier.
- Together with the Pascal-parity wall, the result excludes both the natural
  within-cubic intermediate carriers and the cleanest cross-family carrier.
- The live gate returns to an intrinsic primitive class on Voisin's generic
  charge-three fibre, equivalently the unresolved
  `D3,3/Sym^2(Theta)` index-one-versus-two problem.

## 5. Reproducibility

Primary replay:

```text
cd /home/tavis/src/othello/rust
uv run --with sympy python \
  ../notes/2026-08-10-c904-a4-frame-parity.py
```

Independent Sage replay (the `preparse` invocation avoids generated
`.sage.py` debris):

```text
cd /home/tavis/src/othello/rust
nix shell nixpkgs#sage --command sage -c \
  'exec(preparse(open("../notes/2026-08-10-c904-a4-frame-parity-replay.sage").read()))'
```

Both replays independently construct `A5`, its five `A4` and six `D5`
subgroup actions, the unique fixed map, its five-member orbit, the exact
polarized frame, and the mod-two rank obstruction.  The primary uses SymPy;
the replay uses Sage/GAP group objects and Sage exact matrices.

| artifact | SHA-256 |
|---|---|
| `2026-08-10-c904-a4-frame-parity.py` | `c2813c3befcc2809eab6d1b40570c043891de3745a91068414162aa1c52738b9` |
| `2026-08-10-c904-a4-frame-parity.out` | `74232f9ae814254727f608d9b8304d2e97461bb1ff3827ff2b6e67663c098eeb` |
| `2026-08-10-c904-a4-frame-parity-replay.sage` | `7f9d95b2641a9af6b1265e6009ad9bc01cf2ff11f82729988ad360a71e3f7260` |
| `2026-08-10-c904-a4-frame-parity-replay.out` | `800ff0204161a942ed426d4e7e55727d155ddbc0016ae65e4a481e0a7dbc34ec` |

## 6. Mystery ledger

| feature | status | exact residue |
|---|---|---|
| rational frame square class `15` | settled | forced by the two consecutive-simplex polarizations |
| odd normalization `5/2` | settled negatively | mod-two image dimension six exceeds gluing dimension four |
| could an exotic `F4` slope save one conjugate? | settled negatively | dimension argument covers every slope and all five gluings |
| can another contraction of the full 20-dimensional carrier be odd? | open but no longer cheap | requires a non-frame contraction with new primitive cycle geometry; not licensed by representation theory alone |
| intrinsic `D3,3` index | open | compute the primitive non-Lefschetz Chow/Picard obstruction on the generic symmetric-theta fibre |

Vibe: a beautiful near miss.  The odd number `15` is real, but the same
two-primary orientation that distinguishes the exotic cubic forbids making
the required half-map integral.
