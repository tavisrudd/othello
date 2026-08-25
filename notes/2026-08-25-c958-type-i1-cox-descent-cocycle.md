# C958 type-I1 Cox descent cocycle

**Lane:** `cubic-threefolds`

## Result

The scalar normalization of the type-`I_1` projective Cox quotient is now
explicit.  The certificate gives:

- the semilinear `C2 x S3` action on the marked blowdown plane;
- all scalar factors accompanying the permutation of the sixteen Cox
  generators;
- the two residual quotient characters in the original type-`I_1` marking;
- a normalization fixed by a ground-field point; and
- the resulting rank-two torus cocycle.

After this normalization, every defining relation of `C2 x S3` has trivial
defect on `T0/T3`.  Thus the formulas define a strict descent datum on the
quotient by `T3`, rather than a collection of unrelated split charts.

The remaining type-`I_1` step is now sharply isolated: find a generic
coboundary for the displayed rank-two cocycle and compose it with the
explicit norm-one-torus chart.

## Marked-plane action

Put

```text
A=(z-1)(z+3)(z^2-3)/(2z(z^2-6z-3)),
B=-(z-3)(z+1)(z^2-3)/(2z(z^2+6z-3)).
```

The five marked blowup points are

```text
[1:0:0], [0:1:0], [0:0:1], [1:1:1], [1:A^2:B^2].
```

For `[U:V:W]` on the marked plane, the three Galois generators act as

```text
sigma: [U:V:W] |-> [V:W:U],

iota: [U:V:W] |-> [VW:A^2 UW:B^2 UV].
```

For `tau`, set

```text
m1=(B^2V-A^2W)(U-V)(U-W),
m2=(A^2U-V)(V-W)(U-W),
m3=(B^2U-W)(V-W)(U-V).
```

If `A_tau=A(3/z)` and `B_tau=B(3/z)`, then

```text
tau: [U:V:W] |-> [m1:A_tau^2 m2:B_tau^2 m3].
```

These are not inferred only from the exceptional-curve permutation.  The
generator substitutes each proposed action into the independently certified
split inverse and then into the conjugate split blowdown.  The two resulting
projective cross-products vanish identically for every generator.

## Cox normalization

On the split plane, take the standard rational Cox section

```text
e_i=1,
l_ij=f_Lij(U,V,W),
q=f_Q(U,V,W),
```

where the eleven line and conic forms are those used by
Tschinkel--Zhang.  Relabeling the sixteen coordinates by a Galois generator
does not by itself give the conjugate standard section: each coordinate must
be multiplied by a coefficient depending on `z`.  The certificate derives
all forty-eight coefficients by requiring that, after the five exceptional
coordinates are normalized to one, the other eleven coordinates equal the
standard forms on the conjugate marked plane.  Every derived factor is
independent of `U,V,W`.

The C956 marking is important here.  Pulling its first two quotient
characters back to the original type-`I_1` marking gives

```text
E1-E3,     E2-E3,
```

not `E1-E5,E2-E5`.  Using the latter pair produces point-dependent failures
of the group relations; the correct pair reduces every unnormalized failure
to a coefficient-only torus element.

## Normalization at a ground-field point

The generic cubic surface has the ground-field point

```text
[Y1:Y2:Y3:Y4]=[1:0:0:1].
```

Its marked-plane image is

```text
[1:C:D],
C=-(z-1)^2(z^2-3)/(2(z^2-6z-3)),
D=-(z+1)^2(z^2-3)/(2(z^2+6z-3)).
```

The replay derives this point from the certified quadratic blowdown.  It
then rescales each generator so that the quotient Cox lift above this point
is fixed.  This is the concrete version of choosing the universal-torsor
twist with a ground-field point.

After the rescaling, the residual defects of

```text
sigma^3, tau^2, iota^2,
tau sigma tau=sigma^2,
iota sigma=sigma iota,
iota tau=tau iota
```

are all `(1,1)`.  Any remaining relation defect lies in `T3` (and the common
projective scalar), so it disappears on `Z/T3`.

## The residual cocycle

The JSON prints the two coordinates of the resulting cocycle for all three
generators.  It is trivial for `sigma`.  For `tau` and `iota`, its total
printed size is 259 characters.  Each value is one at the displayed
ground-field point, and the group-relation check is performed at the level of
all sixteen Cox coordinates before taking the residual quotient.

This is the exact input for the remaining Hilbert--90 calculation.  The
residual cocharacter action is the augmentation action of `S3`, so the same
cocycle may be written in the cubic norm-one torus already parametrized in
`notes/2026-08-25-c958-type-i1-norm-torus-parametrization.md`.

## Replay and trust boundary

From the repository root:

```text
uv run --with sympy==1.14.0 python3 \
  notes/2026-08-25-c958-type-i1-cox-descent-cocycle.py \
  --check notes/2026-08-25-c958-type-i1-cox-descent-cocycle.json
sha256sum -c notes/2026-08-25-c958-type-i1-cox-descent-cocycle.sha256
```

The generator pins the exceptional-section, split-blowdown, split-inverse,
and residual-torus certificates.  It reconstructs the marked-plane action,
binds it to both split maps, derives the Cox scalars, computes the ground
point, and checks all six group relations after normalization.

The computation uses one SymPy implementation.  It does not yet produce the
generic coboundary, the product map from the surface and norm-one torus, or
the final maps for the stabilized cubic threefold.

## Mystery ledger

| feature | status | evidence gap or owner |
|---|---|---|
| What is the Galois action on the marked plane? | settled | checked against the certified split forward and inverse maps |
| Which quotient characters occur in the source marking? | settled | `E1-E3,E2-E3` after the explicit C956 conjugation |
| Can the Cox scalar ambiguity be normalized over the ground field? | settled modulo `T3` | the lift above a ground-field point fixes all residual relation defects |
| What is the residual torsor cocycle? | settled | two compact functions for each generator |
| Is the generic residual cocycle a displayed coboundary? | open, next | perform the explicit Hilbert--90 calculation |
| Are the final maps for `X_1 x P2` available? | open | compose after the coboundary is certified |
