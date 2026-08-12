# C909 — Prym-to-norm-axis two-torsion closure

Date: 2026-08-12

Status: theorem-grade closure of the remaining modular-label gate; no
manuscript, PDF, mirror, or Lean edit

## The odd Prym pullback lemma

Consider a Cartesian diagram of smooth proper curves over a connected
characteristic-zero base

```text
        C  ----pi---->  C_0
        |               |
        | 2             | 2
        v               v
        D  ----pi_0-->  D_0
```

in which the vertical maps are etale double covers, the horizontal maps have
odd degree `m`, and the horizontal maps commute with the covering
involutions.  Pullback and norm restrict to Pryms:

```text
 phi=pi^*: Prym(C_0/D_0) --> Prym(C/D),
 psi=Nm_pi: Prym(C/D) --> Prym(C_0/D_0).
```

The Jacobian identity `Nm_pi pi^*=[m]` restricts to

```text
                         psi phi=[m].
```

Consequently `ker(phi)` is contained in the `m`-torsion.  If the source
Prym is elliptic and the image is one-dimensional, `phi` is an odd-degree
isogeny onto its image and therefore induces an isomorphism

```text
 Prym(C_0/D_0)[2]  ~=  Im(phi)[2].
```

The isomorphism preserves the mod-two alternating pairing: pullback of the
target polarization has odd multiplier, hence the Weil pairing multiplier is
one modulo two.  Quadratic twisting does not alter this conclusion because
the twisting involution `[-1]` is trivial on two-torsion.

This lemma is relative.  It commutes with every base change on which the
four curves and quotient maps remain defined; no choice of a global
Weierstrass coordinate is involved.

## Application to the cubic Prym diagram

Van Geemen--Yamauchi, arXiv:1506.05346v3, Section 3.2 and Proposition 3.1,
construct the degree-five quotient diagram

```text
 Htilde_{a,b}  --5-->  Htildebar_{a,b}
       | 2                     | 2
       v                       v
 H_{a,b}       --5-->  Hbar_{a,b}.
```

The vertical maps are etale and the right-hand Prym is their explicit
elliptic curve `E''_{a,b}`.  Their Proposition 2.1 identifies the left-hand
Prym with the intermediate Jacobian, and the order-five quotient commutes
with the double-cover involution.  Hence the preceding lemma gives a
particular map

```text
        phi:E''_{a,b} --> J(X_{a,b}),     ker(phi) subset E''[5].
```

Its image is fixed by the order-five automorphism.  The relation
`Nm phi=[5]` makes it nonzero, while Van Geemen--Yamauchi Proposition 1.5
says that the connected fixed part is one-dimensional.  Thus

```text
                       Im(phi)=E_{C_5}.
```

Roulleau's `D_5` representation is `V_5^1 + V_5^2 + 1`; neither
two-dimensional summand has `C_5`-invariants.  Therefore the `C_5`-fixed
line is also the `D_5`-fixed line, and `E_{C_5}` is precisely the primitive
norm axis constructed by the relative subgroup-norm theorem.  We obtain an
isomorphism of symplectic finite-etale local systems

```text
                       E''[2] ~= E_axis[2].                 (1)
```

There is in fact a stronger conclusion once the primitive norm-axis
calculation is included.  Let `i:E_axis-->J` be the primitive inclusion and
write `phi=i phibar`.  For an etale double cover, the ambient Jacobian theta
restricts to twice the principal Prym polarization.  Therefore the factors
of two cancel in the adjoint calculation and the norm--pullback identity is

```text
                         phi^dagger phi=[5].
```

The independent Roulleau/Rosati calculation gives

```text
                           i^dagger i=[5].
```

Consequently

```text
 [5]=phibar^dagger i^dagger i phibar
    =[5] phibar^dagger phibar.
```

For an elliptic isogeny, `phibar^dagger phibar=[deg phibar]`; hence
`deg phibar=1`.  Thus the explicit elliptic Prym is not merely odd-isogenous
to the norm axis: the displayed pullback identifies it with the primitive
norm axis as an elliptic scheme.  Van Geemen--Yamauchi state only
*isogenous* because they do not make the independent primitive
Roulleau-polarization comparison.  The weaker 5-primary argument remains a
useful robust route to (1), and the degree-one refinement should be stated
only together with both polarization normalizations.

## The actual exotic kernel cover

The relative norm-axis construction gives the actual five-axis isogeny

```text
                 f:E_axis^5 --> J,       f^*Theta=6I-J,
```

and hence its actual maximal-isotropic kernel in `E_axis[6]^5`.  The earlier
Torelli/monodromy argument places its two-primary part in the exotic pair of
the five self-dual graph gluings.  Isomorphism (1) transports this actual
pair to the explicit Prym/Tate two-torsion packet.  The latter has
discriminant sign cover

```text
                              r^2=T.                       (2)
```

On the signed cubic parameter line `T=81t^2`, so (2) splits as
`r=+/-9t`.  Thus the exotic modular double cover is not merely an auxiliary
elliptic resolvent: it is the marking cover of the actual two-primary kernel
of the intermediate-Jacobian isogeny.

There remains one unavoidable orientation convention.  Equality of the two
quadratic covers is canonical, but naming the two sheets requires one fibre.
Choose an explicitly normalized primitive symplectic vanishing-cycle pair in
the rational Tate/Prym basis.  Its intersection fixes the scalar, and the
resulting mod-two graph identifies the two labels; equivalently, the
mod-three reduction distinguishes the two coordinated lifts.  Reversing that
one-fibre orientation exchanges `r` and `-r` and exchanges the two exotic
graphs.  No further ambiguity survives.

## Structural consequence

Combining the norm-axis theorem, the odd Prym pullback lemma, and the modular
resolvent gives a genuine morphism from the signed smooth `A_5` cubic line to
the marked finite-etale elliptic-Hecke presentation stack.  Its underlying
period curve is the open `X_0(3)` curve, and its two-primary marking cover is
the congruence sign cover `Gamma_ex` with function field `r^2=T`.

This closes the last conditional arrow in the cycle-side unity diagram:

```text
 signed A5 cubic
      --> actual relative norm-axis kernel
      --> explicit finite-etale exotic graph marking
      --> all-degree integral divisor-product saturation
      --> algebraic minimal class
      --> universal CH_0-triviality.
```

The final arrow remains Voisin's theorem, and the irrationality of
`X times P^1` remains the independent quantum theorem.  Nothing here proves
a relative Chow diagonal, stable irrationality, or a comparison between the
cycle and quantum marking torsors.

## Source boundary

The Van Geemen--Yamauchi PDF was read from the persistent cache at
`arXiv:1506.05346v3`, SHA-256
`f263d78728391fc9c1ff836293a484e5caec66b3178ecab3aa1d54b14855baed`.
The load-bearing source loci are Propositions 1.5, 2.1, 3.1, and 3.2.  The
odd-kernel statement is a formal consequence of their displayed quotient
diagram and the standard norm--pullback identity; it is not stated as such
in their proposition.
