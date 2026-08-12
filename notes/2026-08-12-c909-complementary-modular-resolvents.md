# C909 — complementary modular resolvents over `X_0(3)`

Date: 2026-08-12

Status: structural theorem; no manuscript, PDF, mirror, or Lean edit

## The congruence subgroups

Reduction modulo two gives a surjection

```text
 rho_2 : Gamma_0(3) --> SL_2(F_2) = S_3.
```

Surjectivity follows directly from the Chinese remainder theorem modulo
`6`: the condition `c=0 mod 3` imposes no condition modulo `2`.  Put

```text
 Gamma_split = Gamma_0(3) intersect Gamma(2),
 Gamma_ex    = rho_2^(-1)(A_3),
 Gamma_root  = rho_2^(-1)(Stab(nonzero point of F_2^2)).
```

Then

```text
 [Gamma_0(3):Gamma_ex]   = 2,
 [Gamma_0(3):Gamma_root] = 3,
 [Gamma_0(3):Gamma_split]= 6.
```

After a conjugate choice of the nonzero two-torsion point,
`Gamma_root=Gamma_0(6)`.  Since `A_3` intersects a point stabilizer trivially,

```text
 Gamma_ex intersect Gamma_0(6) = Gamma_split.
```

Thus the three curves over `X_0(3)` are precisely the quadratic sign
resolvent, the cubic root resolvent, and the full splitting cover of the
universal two-division local system.

## Function fields

Use the Tate model over `Q(T)`

```text
 E_T : y^2+(T+27)xy+(T+27)^2y=x^3,
```

whose point `(0,0)` has order three.  The discriminant of its two-division
cubic has square class

```text
                  16 T (T+27)^8 ~ T.
```

The alternating subgroup `A_3` is the kernel of the sign of the permutation
action on the three nonzero two-torsion points.  Hence the fixed field of
`A_3` is obtained by adjoining the square root of the cubic discriminant:

```text
 Q(X(Gamma_ex)) = Q(T,r),        r^2=T.
```

Choosing one root of the two-division cubic gives the point-stabilizer field.
With the rational root parameter `y`,

```text
 T = -(4y+3)(y+3)^2/(y+1)^2,
```

which is the degree-three map `X_0(6)->X_0(3)`.  Their compositum is the
full splitting field; setting `4y+3=-u^2` gives

```text
 y=-(u^2+3)/4,
 T=u^2(9-u^2)^2/(1-u^2)^2,
 r=u(9-u^2)/(1-u^2).
```

This is the rational degree-six curve `X(Gamma_split)`.

## Compactified geometry

The compact `X_0(3)` has two cusps of widths `1` and `3`.  The sign cover
`r^2=T` ramifies exactly over `T=0` and `T=infinity`, so its compactification
is rational and has two cusps of widths `2` and `6`.  The order-three
elliptic monodromy maps to a three-cycle in `A_3`, hence does not branch in
the sign quotient.  The root quotient has the standard `X_0(6)` cusp widths
`1,2,3,6`.  On the full splitting curve, each base cusp has three points of
ramification index two, giving widths `2,2,2` and `6,6,6` respectively.

These ramification statements also follow directly from the displayed
rational maps and do not require a boundary statement for the intermediate
Jacobian family.

## The nonstandard cubic parameter

For the signed nonstandard `A_5` pencil parameter `t`, the exact elliptic
quotient formula is

```text
                         T=81t^2.
```

Therefore its outer involution `t |-> -t` is exactly the deck involution of
the pulled-back sign resolvent, and `r=9t` selects the exotic graph sheet.
After quotient by the outer involution, the coarse parameter `s=t^2`
identifies with the `X_0(3)` Hauptmodul line via `T=81s`.

This is an exact modular explanation of the `3+2` gluing packet:

```text
                    full S_3 two-division packet
                    /                         \
        point stabilizer C_2             sign kernel A_3
              degree 3                         degree 2
                X_0(6)                       X(Gamma_ex)
```

The equality of the signed cubic parameter and the exotic modular cover is
at the level of the elliptic multiplicity system and graph marking.  To call
the entire principally polarized cubic intermediate-Jacobian family the
same modular graph curve, one must additionally globalize the relative
six-axis isogeny and its integral kernel.  Strong Torelli then identifies
the normalization of the resulting period image, but does not supply that
integral globalization by itself.

## Mathematical role

This theorem turns the five-point `P^1(F_4)` packet from a fibrewise finite
calculation into a congruence-modular resolvent diagram.  The exotic cubic
marking and the classical `X_0(6)` marking are complementary quotients of
one level-six modular cover.  It strengthens the unity of the cycle branch
without identifying the conjectural quartic intermediate-Jacobian lattice
or coupling the cycle packet to quantum monodromy.
