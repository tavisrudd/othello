# C904 sparse divisor cycle for the primitive class

Date: 2026-08-10
Status: exact relative signed cycle on the smooth exotic marked base
Scope: deterministic integral expression in the 3,060 divisor monomials

## Result

For the exotic principal gluing and the deterministic LLL divisor basis
`D_0,...,D_14` fixed in
`notes/2026-08-10-c904-six-axis-minimal-class-saturation.md`, exact lattice
reduction gives

```text
Theta^4/4! =
  -787 D0 D1^3
 +3253 D0 D1^2 D2
 +2167 D0 D1^2 D4
  -219 D0 D1^2 D6
 +3095 D0 D1^2 D7
 +1043 D0 D1^2 D12
  +861 D0 D1 D2 D3
 -2285 D0 D1 D2 D6
  -749 D0 D1 D12 D13
 +1245 D0 D2 D12 D13
  -428 D1^3 D2
  +114 D1^3 D3
  -599 D1^2 D2 D3
  -599 D1^2 D2 D5
 -1027 D1 D2 D3 D5
  -171 D1 D2 D12 D13.
```

The identity holds integrally in all 45 coordinates of
`Lambda^8 H^1(J,Z)`.  Its support is 16 and coefficient `L1` norm is 18,642.
This is a large improvement over the first tracked HNF identity, whose
support was 52 and whose coefficients had `L1` norm about `3.35e24`.

The support lower bound from rational rank is 15.  A deterministic search of
5,000 random 15-monomial rational bases found no basis in which the target
coordinates were all integral.  This is a bounded negative search, not a
proof that support 16 is globally minimal.

Among all 3,060 unordered monomials, there are 2,660 distinct product rows
and 226 zero rows.

## Geometry and symmetry of the factors

The ten divisor types used by the identity are:

| class | rank | signature | determinant | `A5` orbit |
|---|---:|---:|---:|---:|
| `D0` | 1 | `(1,0,4)` | 0 | 6 |
| `D1` | 5 | `(3,2,0)` | 1296 | 15 |
| `D2` | 5 | `(3,2,0)` | 1296 | 15 |
| `D3` | 2 | `(1,1,3)` | 0 | 30 |
| `D4` | 5 | `(2,3,0)` | -1296 | 30 |
| `D5` | 3 | `(1,2,2)` | 0 | 30 |
| `D6` | 5 | `(2,3,0)` | -2592 | 60 |
| `D7` | 4 | `(2,2,1)` | 0 | 60 |
| `D12` | 5 | `(2,3,0)` | -2592 | 60 |
| `D13` | 2 | `(1,1,3)` | 0 | 15 |

`D0` is the unique positive-semidefinite rank-one type in the support.  Its
orbit of size six is the six-axis orbit: after choosing the corresponding
`D5` marking, it is represented by the pullback of a point under the
elliptic quotient `q_H:J->E_H`.  Hence the first ten monomials, which all
contain `D0`, can be represented on the special Abel--Jacobi locus
`ker(q_H)` before intersecting with the other three divisor classes.

The remaining six monomials do not contain an axis divisor.  Moreover every
other divisor basis element used above is indefinite.  These classes are
perfectly valid algebraic line-bundle classes, but they do not carry a
canonical effective abelian-subvariety representative.  Turning them into
geometric cycles requires signed differences of effective divisors.  The
present expression is therefore an explicit **signed marked-fibre cycle**,
not yet a small effective configuration.

The orbit sizes 15, 30, and 60 record nontrivial stabilizers, but an orbit
size alone does not identify `D1`, `D2`, or `D13` with the involution-indexed
genus-two loci.  That geometric identification remains unproved and should
not be inferred merely from the shared number 15.

## Relative-use assessment

Gate V already closes relative Picard rigidification.  On the exotic marked
base, residual mod-two monodromy is the fixed-point-free group `C3`; the
torsor of symmetric representatives of every horizontal Neron--Severi class
has a unique fixed point.  The smooth affine base has trivial Brauer group.
Consequently **all fifteen** basis classes, including the indefinite ones,
are represented by relative symmetric line bundles, and the displayed
16-term formula is already a relative signed Chow cycle `Z_min`.  No `A5`
averaging and no additional two-primary cover is required.

What is not automatic is a geometrically small effective decomposition of
the indefinite relative line bundles.  They may be represented as signed
differences after twisting by a relatively ample bundle, but those choices
change the visible component geometry.  This affects attempts to analyze
the ordered-pair cover component by component; it is not a descent
obstruction to `Z_min` itself.

Thus the remaining relative gate is the Abel--Jacobi lifting/index problem
over the finitely many component surfaces, not line-bundle rigidification or
integral existence of the relative minimal cycle.

## Replay

Primary Sage extraction:

```sh
nix shell nixpkgs#sage -c sage -c \
  'exec(preparse(open("notes/2026-08-10-c904-minimal-class-sparse-identity.sage").read()))'
```

Independent Python/SymPy replay:

```sh
nix shell nixpkgs#sage -c sage -python \
  notes/2026-08-10-c904-minimal-class-sparse-identity-replay.py
```

The independent replay imports only the earlier pure-Python divisor
construction, hard-codes the displayed 16 coefficients, reconstructs all
3,060 products, and checks the identity in every one of the 45 exterior
coordinates.

| file | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-10-c904-minimal-class-sparse-identity.sage` | 6,199 | `e1e3d23c45ea92870f9bedbec0491b57d7f79df7acd52fb82fbd1b9c4d6f0e9f` |
| `notes/2026-08-10-c904-minimal-class-sparse-identity.out` | 1,061 | `1068eb84d5e1f068dca0f68e3a7038b1943c9d351b5540c95e3c7965fe30f587` |
| `notes/2026-08-10-c904-minimal-class-sparse-identity-replay.py` | 1,587 | `0a647e2b70241473fc31ff89ca35aaef6875ab92e2a4a1311c088204bceffb50` |
| `notes/2026-08-10-c904-minimal-class-sparse-identity-replay.out` | 146 | `bad1853ea8d79c81300ec5b69ece4e07ba973f275b74f72c8a8701a377d65b65` |

## Mystery ledger

- **Settled:** a compact explicit integral expression exists; support 16 is
  within one of the rational rank lower bound.
- **Settled:** ten terms have a genuine six-axis support, while six terms are
  intrinsically virtual in the chosen basis.
- **Open:** whether a support-15 identity exists.  The exact current negative
  evidence is 0 integral solutions among 5,000 deterministic random rational
  bases.
- **Open:** whether another integral basis yields substantially smaller
  coefficients or puts every term on geometrically special Abel--Jacobi
  loci.
- **Settled by Gate V:** all fifteen divisor classes rigidify uniquely on the
  smooth exotic marked base, so the 16-term expression is already relative.
- **Open:** whether its effective signed representatives can be chosen so
  that every component lies on an Abel--Jacobi locus where the ordered-pair
  cover can be computed geometrically.
