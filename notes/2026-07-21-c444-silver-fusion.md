# C444 / M4 — B3 silver split and A3 inert fusion

**Lane:** `crowns` (read-only `clebsch` inputs)

**Date:** 2026-07-21

**Verdict:** `GREEN — THE B3 ANTIPODAL DATUM REDUCES TO OPPOSITE C406 PSL_2(7) FIBRES WITH THE
FROZEN CUBIC ORIENTATION; THE A3 SPIN ORIENTATIONS ARE FROBENIUS-CONJUGATE OVER F_25 BUT HAVE ONE
PROJECTIVE F_5 MARKER FIBRE AND NO SHEET SIGN`

M4 of the Weil-roof battery.  This certifies the silver split and inert-fusion reduction theory in
the frozen M0/M1 labels and directly reproduces C406's subgroup criterion and moment certificate.
It does not copy H3's mechanism: the B3 projective `S4` skeleton is sheet-blind, while its
`Z[sqrt2]` vertex labeling and binary-octahedral lift carry the bit.

## Prime ideals and frozen label tables

In `O=Z[sqrt2]`,

```text
7 = (3-sqrt2)(3+sqrt2),
rho_- : a+b sqrt2 |-> a+3b mod 7,       ker rho_-=(3-sqrt2),
rho_+ : a+b sqrt2 |-> a+4b mod 7,       ker rho_+=(3+sqrt2).
```

Both ideals have norm 7.  With the M1 choice `omega -> 2`, the frozen cube roots reduce as follows.
The displayed pairing is the char-0 stereographic antipode: it pairs equal `omega` exponents.

| vertex | char-0 affine root | `sqrt2 -> 3` | `sqrt2 -> 4` | antipode |
|:--|:--|--:|--:|:--|
| `v0` | `0` | 0 | 0 | `vinf` |
| `vinf` | `inf` | `inf` | `inf` | `v0` |
| `upper_0` | `sqrt2/2` | 5 | 2 | `lower_0` |
| `upper_1` | `(sqrt2/2) omega` | 3 | 4 | `lower_1` |
| `upper_2` | `(sqrt2/2) omega^2` | 6 | 1 | `lower_2` |
| `lower_0` | `-sqrt2` | 4 | 3 | `upper_0` |
| `lower_1` | `-sqrt2 omega` | 1 | 6 | `upper_1` |
| `lower_2` | `-sqrt2 omega^2` | 2 | 5 | `upper_2` |

Thus the one char-0 cube antipodal datum has the two reductions

```text
sqrt2=3:  {0,inf}{1,3}{2,6}{4,5},
sqrt2=4:  {0,inf}{1,5}{2,3}{4,6}.
```

For A3, `(5)` is inert in `O`, with

```text
O/(5) = F_25 = F_5[u]/(u^2-2),       Frobenius(a+b u)=a-b u,       u^5=-u.
```

The octahedron itself uses the frozen `Q(i)` labels; its two primes above 5 give the table

| vertex | root | `i -> 2` | `i -> 3` | antipode |
|:--|:--|--:|--:|:--|
| `v0` | `0` | 0 | 0 | `vinf` |
| `vinf` | `inf` | `inf` | `inf` | `v0` |
| `+1` | `1` | 1 | 1 | `-1` |
| `-1` | `-1` | 4 | 4 | `+1` |
| `+i` | `i` | 2 | 3 | `-i` |
| `-i` | `-i` | 3 | 2 | `+i` |

Both columns therefore give the same marker `{0,inf}{1,4}{2,3}`.

## B3: the spin lift carries the split bit

For each residue `s in {3,4}` with `s^2=2`, the checker constructs a split quaternion basis in
`M_2(F_7)`:

```text
I = [[0,1],[-1,0]],       J_s = [[2,s],[s,-2]],       K_s=I J_s,
Q_s=(1+I+J_s+K_s)/2,     R_s=(1+I)/s.
```

These matrices generate a group of order 48 in `SL_2(F_7)`, the binary octahedral `2.S4`.  After
conjugation by the single silver projectivity

```text
C_s = [[1,s],[0,1]],
```

its projective image has order 24 and its unique invariant perfect matching is exactly the
corresponding reduced antipodal matching in the table above.  Silver conjugation `s -> -s` swaps
the two reductions.  This exhibits the bit in the spin/labeling data even though the abstract
projective `S4` skeleton is rational and sheet-blind.

The two order-24 parents lie in `PSL_2(7)`.  Direct enumeration gives a `PGL_2(7)` marker orbit of
size 14, whose restriction to `PSL_2(7)` is `7+7`; the `sqrt2=3` and `sqrt2=4` matchings lie in
opposite fibres.  This is C406's criterion itself, not a cardinality inference:

```text
PGL_2(q)/H restricts to two PSL_2(q) orbits  <=>  H <= PSL_2(q).
```

In C406's frozen sheet convention, `sqrt2=4` is the positive fibre and `sqrt2=3` the negative
fibre.  Recomputing the secant-product quotient in C406's six coordinates gives:

| signed moment | dimension | support | SHA-256 |
|:--|--:|--:|:--|
| `mu_1` | 6 | 0 | `b0f66adc83641586656866813fd9dd0b8ebb63796075661ba45d1aa8089e1d44` |
| `mu_2` | 21 | 0 | `c90232586b801f9558a76f2f963eccd831d9fe6775e4c8f1446b2331aa2132f2` |
| `mu_3` | 56 | 9 | `28e104605093c1145468df8f3c65d86cfc51b55e2c48d54592b5e2f3b75590bf` |

All fields, supports, and hashes equal the frozen C406 certificate.  The canonical positive cubic
vector is stored explicitly in the C444 JSON; the `sqrt2=3` vector is its entrywise negative in
`F_7`.  Hence the lower signed moments vanish and the first surviving orientation is cubic with
the asserted square-root sign.

## A3: Frobenius swaps lifts and forgets the sign

Over `F_25`, use the standard split binary-octahedral matrices with a fixed `i=2 in F_5`, quaternion
generators `I,J`, `Q=(1+I+J+IJ)/2`, and

```text
R_+ = (1+I)/u,             R_- = Frobenius(R_+) = -R_+.
```

The generated spin group has order 48.  Frobenius preserves it and exchanges the two displayed
spin orientations.  After projectivization, the scalar `u` disappears: every normalized matrix
has entries in `F_5`, and the projective image is one `S4` of order 24.  Its unique invariant
matching is `{0,inf}{1,4}{2,3}`.

This parent is not contained in `PSL_2(5)` (the checker also exhibits nonsquare determinant
classes).  Its five-element `PGL_2(5)` marker orbit remains the same five-element orbit under
`PSL_2(5)`.  Therefore the two Frobenius-conjugate spin orientations descend to one projective
marker fibre: there is no second sheet and no sign character.  This directly reproduces the A3
half of C406's split criterion rather than arguing only from the six vertex labels.

## Post-close free upgrades

Three exact strengthenings fall out without changing the theorem boundary.

**The silver swap is one explicit outer projectivity.** Row by row in the frozen cube table,
changing `sqrt2=3` to `sqrt2=4=-3` is exactly

```text
J_silver : x |-> -x,            J_silver = [[-1,0],[0,1]].
```

It fixes `0,inf`, exchanges the other labels in opposite pairs, maps the `sqrt2=3` antipodal
matching to the `sqrt2=4` matching, and conjugates the corresponding full matching stabilizers:

```text
J_silver H_3 J_silver^-1 = H_4,        H_3,H_4 ~= S4.
```

Its determinant class is `-1`, a nonsquare in `F_7`, so it is an outer `PGL_2(7)` element.  This
gives a direct transporter proof that the two matchings occupy opposite `PSL_2(7)` fibres.  The two
`S4` parents intersect in order six with element orders `1,2,2,2,3,3`, hence in an `S3` seam.  This
is the same subgroup type as C414's B3 `S3` seams; no identification with a particular C414 seam is
needed or claimed here.

**The cubic sign is literally the silver Kummer coordinate.** With C406's positive vector
normalized at `sqrt2=4`, the two vectors obey the single formula

```text
mu_3(s) = 2 s mu_3(4) in F_7,          s^2=2.
```

Indeed `2*4=1` and `2*3=6=-1`.  Thus the first surviving moment does not merely covary with the
prime choice: its scalar is the normalized residue of `sqrt2` itself.

**Both spin/projective boundaries are exact central extensions.** In each B3 reduction the map
`2.S4 -> S4` has kernel exactly `{+I,-I}`, and the order-24 image equals the full `PGL_2(7)`
stabilizer of its antipodal matching.  In A3 the order-48 spin group again has kernel exactly
`{+I,-I}`; Frobenius sends the chosen lift `R_+` to `-R_+`, so it changes only that central lift.
The descended order-24 projective group is the full matching stabilizer, and its intersection with
`PSL_2(5)` has order 12, the `A4` kernel of the determinant character.  This pins the fusion as

```text
2.S4 --/{+-I}--> S4,       S4 intersect PSL_2(5)=A4,
```

rather than only the earlier five-orbit cardinality statement.

## Reproducibility

Run from `/home/tavis/src/othello`:

```bash
uv run python3 notes/2026-07-21-c444-silver-fusion.py --check
uv run python3 notes/2026-07-21-c444-silver-fusion-replay.py
(cd notes && sha256sum -c 2026-07-21-c444-silver-fusion.sha256)
```

Intentional regeneration is `uv run python3 notes/2026-07-21-c444-silver-fusion.py`.  The primary
checker hash-verifies the named M0/M1/C406 inputs, reconstructs the two binary-octahedral models,
enumerates the relevant `PGL/PSL` actions and perfect matchings, and recomputes the degree-1/2/3
secant-quotient moments.  The independent replay does not import the C444 generator: it uses the
frozen C406 checker as a separate quotient/moment implementation and independently rebuilds the
spin reductions.

| load-bearing artifact | bytes | SHA-256 |
|:--|--:|:--|
| primary checker | 28,982 | `b38569788639b10af53e97324efb3a38f9bd3a80c474bb75fa63dd5f537e2f6d` |
| independent replay | 6,815 | `109798c98fc4e62828a9eee8e3d274a90bc9be6c05c3f8aa93a5e302c8f7392a` |
| canonical JSON | 14,331 | `311dd3eba6ad7b2926cb4aa38dc240093f9611ffbcd0640d69becc7112dfa465` |

Trusted boundary: exact arithmetic and exhaustive finite closure/enumeration in `F_5`, `F_7`, and
`F_25`; the frozen M0/M1 labeling and C406 scout/moment certificates; and the displayed quaternion
formulas, whose claimed group orders and invariant matchings are checked rather than recalled.

## Boundary

C444 certifies the full M4 split/fusion reduction theory in the frozen labeling.  It does not prove
quaternion maximal-order reduction (C457/T10), M5 gluing, or an integral tensor lift; M3's sharp
blocker remains untouched.  No novelty or priority claim is made: this is an exact verification
and mechanism comparison against C406.
