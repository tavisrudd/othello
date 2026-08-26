# C958 type-I3 normalized split inverse

**Lane:** `cubic-threefolds`

## Result

The type-`I3` quadratic blowdown now has an explicit inverse over its exact
degree-24 splitting field.  The calculation is performed after the weight
normalization

```text
s=beta/a^3,
(R,D,g,Delta)=(r/a,d/a,g,delta/a^2),
(X1,X2,X3,X4)=(Y1/a,Y2/a,Y3,Y4/a),
```

on the dense open `a != 0`.  It converts the original two-parameter surface
exactly to

```text
X3*(X1^2 + 2*X1*X2 + (1+s)*X3^2)
 + X4*(X1^2 + X1*X2 + X2^2 - X3^2 + X4^2) = 0
```

over the tower

```text
g^2=3,
R^3-R+1+s=0,
D^2+3*R^2-4=0,
Delta^2=(-32*g-52)-(24*g+36)*s.
```

The cubics through the six marked plane points form a four-dimensional
anticanonical system.  Fifteen selected exceptional-line incidence rows have
rank fifteen and align that system uniquely with the four surface coordinates;
all remaining incidence rows annihilate the resulting kernel vector.

Exact substitution proves all three required split identities:

1. the four inverse cubics land on the normalized cubic surface;
2. quadratic blowdown after the inverse is projectively the plane identity;
3. inverse after blowdown is projectively the surface identity after reduction
   by the monic surface equation in `X4`.

Thus the type-`I3` **split** birationality gate is closed.  This is not yet a
ground-field parametrization.

## Formula size and paper use

The forty inverse coefficients contain 41,812 characters in total; the longest
coefficient has 2,794 characters.  Their natural home is the machine-readable
artifact, not inline manuscript display.  The paper upgrade should state the
weight normalization, the rank-fifteen alignment construction, and the three
exact identity checks, then cite the ancillary bundle.  This strengthens the
paper by turning split birationality from an existence step into a reproducible
construction without burying the proof in expanded coefficients.

The normalization is reusable: every nonzero `a` fibre is obtained from one
one-parameter formula family.  The Rust checker is also reusable as a compact
degree-24 quotient-algebra identity engine, although its three finite-field
specializations remain diagnostics rather than a generic proof.

## Replay and trust boundary

From the repository root:

```text
nix shell nixpkgs#sage -c sage -python \
  notes/2026-08-25-c958-type-i3-split-inverse.py \
  --check notes/2026-08-25-c958-type-i3-normalized-split-inverse-formulas.json

nix shell nixpkgs#sage -c sage -python \
  notes/2026-08-25-c958-type-i3-split-inverse-verify.py \
  notes/2026-08-25-c958-type-i3-normalized-split-inverse-formulas.json \
  --check notes/2026-08-25-c958-type-i3-normalized-split-inverse.json

cd rust
cargo clippy --example c958_type_i3_split_inverse_check -- -D warnings
cargo run --release --example c958_type_i3_split_inverse_check -- \
  ../notes/2026-08-25-c958-type-i3-split-blowdown.json \
  ../notes/2026-08-25-c958-type-i3-normalized-split-inverse-formulas.json
```

The two Sage commands replay the characteristic-zero certificate.  The Rust
program independently reconstructs quotient arithmetic and checks the complete
polynomial identities at `(a,beta)=(1,1),(1,7),(1,13)` modulo three different
primes.  Those modular checks guard implementation errors but do not replace
the generic Sage proof.

## Remaining boundary

No claim is made here about strict Cox descent, the rank-eleven Hilbert--90
coboundary, ground tangent coordinates, or the final maps
`X_3 x P2 <-> P5`.  Their exact continuation state is recorded in
`notes/2026-08-25-c958-safe-checkpoint.md`.
