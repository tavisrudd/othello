# C958 type-I1 full Picard-torus coboundary

## Result

The generic universal-torsor splitting required for the type-`I1` explicit
level-two parametrization is now constructive.  It is retained as a finite
straight-line program rather than as expanded numerator and denominator
polynomials.

There are three ingredients.

1. Normalize the three Cox coordinate maps at the explicit ground lift above
   `[Y1:Y2:Y3:Y4]=[1:0:0:1]`.  The exact replay checks every defining relation
   of `C2 x S3`; the resulting Cox descent datum is strict, not merely strict
   modulo `T3`.
2. Compare this descent datum with the affine generic Cox section obtained by
   setting the five exceptional coordinates to one.  The resulting scalars
   are checked on all sixteen Cox generators to be evaluations of a
   six-coordinate Picard-torus cocycle.  They specialize to one at the ground
   lift.
3. Transport that cocycle through the unimodular basis in Tschinkel--Zhang
   Lemma 4.2.  The rank-eleven permutation basis has type-`I1` orbits of sizes
   `6,4,1`.  On each orbit, multiplicative Hilbert 90 gives

   ```text
   h_i = sum_{s in Stab(i)} u_s,i,
   h_{g(i)} = g(h_i) u_g,i.
   ```

   The exact specialization `(z,u,v)=(2,5,7)` makes all three seed sums
   nonzero, proving that they are nonzero rational functions.  Pulling the
   eleven functions back through the integral inverse basis gives the desired
   six Picard-torus coordinates.

This also explains the preceding negative result.  A single Laurent monomial
in the sixteen standard Cox forms cannot be the coboundary because of its
half-integral divisor defect.  The permutation-basis Hilbert--90 sums are
genuinely additive rational functions and bypass that obstruction.

## Why an SLP is the canonical formula

Expanding the twelve Cremona conjugates produces large polynomials and hides
the group structure.  The retained certificate instead gives:

- the three base-field actions on `(z,u,v)`;
- the three Picard- and permutation-coordinate cocycles;
- one canonical word for each of the twelve group elements;
- the cocycle recursion along each word;
- the three stabilizers and chosen transporters;
- the unimodular basis and its inverse.

These data evaluate the coboundary using a fixed finite sequence of rational
operations.  They are both shorter and more independently auditable than a
fully expanded expression.

The retained syntactic profile makes the algorithmic content concrete.  The
twelve canonical words use 24 generator steps in total.  The three
Hilbert--90 seeds contain 17 terms and require 14 additions, with eight
nontrivial orbit transports.  Pullback to the six Picard coordinates uses 41
nonzero integral exponents, has total absolute exponent 44, and maximum
absolute exponent three.  These are operation counts for this certificate,
not an asymptotic complexity theorem.

## Replay

```bash
uv run --with sympy==1.14.0 python3 \
  notes/2026-08-25-c958-type-i1-full-coboundary.py \
  --check notes/2026-08-25-c958-type-i1-full-coboundary.json
```

The adjacent `.sha256` file binds the implementation and certificate.  The
replay takes about thirty seconds on the current host.

## Trust boundary and next step

Certified here are the strict Cox descent, the rank-six generator cocycle,
its evaluation on every Cox divisor class, the rank-eleven permutation
conversion, nonvanishing of the three Hilbert--90 seeds, and the unimodular
pullback recipe.  The certificate does not expand the final six rational
functions.

The type-`I1` descent-existence gate is closed.  What remains is to feed the
six-coordinate SLP into the already certified residual norm-torus chart and
the `Z/T3 -> P4` tangent quotient, then check the two composites and eliminate
the fibration coordinate to obtain maps for the cubic product.  Type `I3`
remains separate.
