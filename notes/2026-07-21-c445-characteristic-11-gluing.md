# C445 / M5 — exact characteristic-11 gluing boundary

**Lane:** `crowns` (read-only `clebsch` inputs)

**Date:** 2026-07-21

**Verdict:** `GREEN — THE MATCHING-LEVEL GLUING THEOREM IS PROVABLE NOW; THE QUATERNION
INTERPRETATION IS RESERVED FOR PAPER 2; THE FAILED INTEGRAL TENSOR CLAUSE IS CUT`

## Exact gluing theorem

Let `K=Q(sqrt5)`, let `S` be C458's frozen golden six-arc over `K`, and let `M` be its unique
`A5`-invariant polar-pair matching.  Write `pi` and `pibar` for the primes above 11 with
`phi -> 8` and `phi -> 4`.  Then:

1. `S` and `sigma(S)` are disjoint in characteristic zero, while `M_pi` and `M_pibar` are the two
   singleton matchings on the same `P^1(F_11)`:

   ```text
   M_pi    = {0,1}{2,5}{3,7}{4,9}{6,8}{10,inf},
   M_pibar = {0,10}{1,inf}{2,7}{3,5}{4,8}{6,9}.
   ```

2. Their full `PGL_2(11)` stabilizers are the distinct subgroups `a5(8)` and `a5(4)`, each of order
   60 and contained in `PSL_2(11)`.  They meet in their common `A4` of order 12 and satisfy

   ```text
   <a5(8), a5(4)> = PSL_2(11),       |PSL_2(11)| = 660.
   ```

3. The `PGL_2(11)` orbit of either matching has size 22.  Its restriction to `PSL_2(11)` is the
   disjoint union of the two size-11 orbits containing `M_pi` and `M_pibar`.  Thus the exact gluing
   is: **the two Galois-conjugate fibres are the two `PSL_2(11)` halves of one
   `PGL_2(11)` orbit.**

4. The exchange is not born in characteristic 11.  The rational rotation

   ```text
   Rz = [[0,-1,0],[1,0,0],[0,0,1]]
   ```

   maps `S` to `sigma(S)` and has spinor norm 2.  Indeed, for the quadratic form
   `x^2+y^2+z^2`, it is the product of the reflections in `u=(1,0,0)` and `v=(1,-1,0)`, so its
   spinor norm is `q(u)q(v)=2`.  Its reduction is the Möbius map `(x+10)/(x+1)`, with determinant
   `2 mod 11`; because `(2/11)=-1`, it is the outer `PGL_2(11)` element carrying `M_pi` to
   `M_pibar`.

The characteristic-11 content is therefore precisely the collision of the two disjoint
characteristic-zero vertex systems on one `P^1(F_11)` and the finite closure of their stabilizers.
The theorem does **not** assert a characteristic-zero 22-point `PGL_2` orbit or a split
`P^1` model over `Q(sqrt5)`.  That failure to lift is part of the boundary, not a defect in the
finite theorem.

## C460 perpendicularity germ — exact usable strength

C460's comparison is positive.  The six `sigma`-stable perpendicular pairs between golden and
conjugate axes reduce two-by-two to exactly

```text
{[1:0:0], [0:1:0], [0:0:1]},
```

the common triangle of the base and J-mate Frégier clouds.  This is a canonical finite shadow of
the characteristic-zero pairing.  It is supporting geometry for the gluing statement; by itself
it proves neither the `PSL_2(11)` closure nor the quaternion mechanism.

### Post-close upgrade — the exact `S4/A4` gluing hinge

The common triangle does more than accompany the gluing.  Its setwise stabilizer is C460's rational
octahedral `S4` of order 24, while the common stabilizer of the two golden matchings is their `A4`
intersection of order 12.  The reduction of `Rz` swaps the matchings, so Frégier-cloud equivariance
forces it to swap their clouds and preserve the common triangle.  Hence it lies in `S4` but, having
nonsquare determinant, not in `PSL_2(11)`.  Therefore the determinant character gives the exact
diagram

```text
A4 = a5(8) intersection a5(4) = S4 intersection PSL_2(11),
S4 / A4 = C2,
Rz mod 11 lies in S4 \ A4.
```

Thus the common `S4` is the local gluing hinge: its `A4` kernel fixes both sheets, and its outer
coset exchanges them.  This promotes the perpendicularity triangle from supporting geometry to the
precise seam through which the rational transporter acts; it still does not supply the quaternion
interpretation.

## Paper-1 closing theorem

The strongest closing theorem currently justified at the frozen boundary is:

> In the frozen `A3`, `B3`, and `H3` vertex systems, the invariant antipodal datum is controlled at
> matching level.  The `A3` Frobenius-conjugate spin lifts fuse to one projective marker fibre over
> `F_5`.  The two `B3` reductions at `sqrt2=3,4` occupy opposite `PSL_2(7)` fibres and carry
> opposite cubic orientations.  The one golden `H3` polar matching reduces at the two primes above
> 11 to the two singleton fibres; these form one `PGL_2(11)` orbit, their `A5` stabilizers generate
> `PSL_2(11)`, and their exchange is the mod-11 shadow of the rational spinor-norm-2 rotation `Rz`.

The clause ends there.  C443 found four companion sheets rather than the required unique one, and
C461 proved that the full descended linear-weight lower-moment map has zero kernel modulo 11.
Consequently paper 1 must not assert an integral secant-product tensor, a commuting-with-reduction
theorem for `mu_1,mu_2,mu_3`, or a characteristic-zero tensor with `+/-6` shadows.

## Provable now versus paper-2 mechanism

The two-frame sheet/matching theorem, the common `P^1(F_11)` collision, the `11+11` orbit split,
the `PSL_2(11)` closure, the rational transporter and its outer reduction, and the C460 triangle
comparison are all certified now.

The stronger explanation — that reduction at 11 splits the Schur-index-2 icosahedral quaternion
obstruction and thereby produces the finite gluing — remains a **paper-2 mechanism**, not a clause
of this machine-certified theorem.  C458 records it as structural/classical and explicitly outside
its machine-verified boundary.  The finite theorem neither needs nor upgrades that interpretation.

## Reproducibility and trusted boundary

From `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-21-c445-characteristic-11-gluing.py --check
python3 notes/2026-07-21-c445-characteristic-11-gluing-replay.py
(cd notes && sha256sum -c 2026-07-21-c445-characteristic-11-gluing.sha256)
```

The primary checker hash-pins the reports and certificates for C442, C458, C443, C461, C460, and
C444.  It independently enumerates `PGL_2(11)` and `PSL_2(11)`, reconstructs both matching
stabilizers, their intersection and closure, the `11+11` orbit split, the outer transporter, and an
exact reflection factorization of `Rz`.  The replay imports no primary code and independently
repeats the finite-group calculation from normalized Möbius matrices.

The characteristic-zero six-arc, Galois, and perpendicularity facts are consumed from hash-pinned
frozen certificates.  C460 already supplies a separate independent replay of the common-triangle
comparison, so this bundle does not duplicate that projective-plane enumeration.  No randomness,
floating point, manuscript edit, novelty claim, or tensor construction is involved.
