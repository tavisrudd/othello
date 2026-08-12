# C909 — actual-kernel resolvent diagram

Date: 2026-08-12

Status: reconciliation of the competing hostile audits; no manuscript, PDF,
mirror, or Lean edit

## Issue

One hostile reading correctly warned that an abstract isomorphism of elliptic
two-torsion local systems does not, by itself, identify a chosen maximal
isotropic subgroup of a fivefold polarization kernel.  The closed argument
uses two additional inputs which must be displayed: the actual relative
six-axis kernel and the classification/Torelli selection of its graph orbit.

## Exact diagram

Over the labelled smooth `A_5` base, fix five of the six canonically
transported norm axes.  The norm/Roulleau theorem gives an actual relative
isogeny

```text
 f:E_axis^5 --> J,       f^*Theta=6I-J,       K=ker(f).       (1)
```

Thus `K_2=K[2-primary]` is not inferred from the Prym model; it already
exists as a finite flat maximal-isotropic subgroup of the source
polarization kernel.  In a local graph chart, the complete classification of
`A_5`-stable principal subgroups is

```text
 P^1(F4)=P^1(F2) disjoint_union {omega,omega^2}.              (2)
```

The three rational points would make the full `S_6` source symmetry descend
to the ppav.  Strong Torelli and generic `Aut(X)=A_5` exclude them.  Since
`K_2` is a finite local system, it cannot jump between the two monodromy
orbits on the connected smooth base.  Therefore the graph coordinate of the
*actual* kernel (1) lies in the exotic two-set of (2).

The degree-five Prym comparison supplies a polarized isomorphism

```text
                       E_Prym ~= E_axis.                     (3)
```

Its construction is relative and respects the Weil pairing.  The explicit
VGY-to-Tate comparison is a quadratic twist, hence also gives

```text
                       E_axis[2] ~= E_T[2].                  (4)
```

The automorphism group of the symplectic rank-two `F_2` local system in (4)
is `GL_2(F_2)=S_3`.  Its induced action on the two roots of
`x^2+x+1` is the sign quotient.  But these roots are precisely the two
exotic graph coordinates in (2).  Therefore the finite cover on which the
actual `K_2` graph coordinate is labelled is the discriminant/sign cover of
the Tate two-division system:

```text
                              r^2=T.                         (5)
```

Here is the basis-free bridge implicit in that sentence.  Let

```text
 H_2=Aug(F_2^6)/<1>,       End_A5(H_2)=F_4,
 M_2(V)=H_2 tensor_F2 V
```

for a rank-two symplectic `F_2` local system `V`.  The `A_5`-stable
maximal-isotropic subgroups of `M_2(V)` form the functorial packet

```text
 P(V)=P^1(F_4)=P^1(F_2) disjoint_union P_ex(V).
```

A symplectic isomorphism `eta:V-->V'` induces `1 tensor eta` on the
discriminant module and hence an isomorphism
`P_ex(V)-->P_ex(V')`.  This construction is independent of a basis: changing
a coefficient basis acts through `GL_2(F_2)` by its usual fractional-linear
action on the packet.  Applying it to (4) identifies the Tate discriminant
two-set with the exotic two-set which contains the actual `K_2`.  Thus (4)
does not directly identify one subgroup; it naturally identifies the exact
two-object packet, and the signed cover selects an object.

The three ingredients have distinct roles:

```text
 (1) constructs the actual kernel;
 (2) + Torelli places that kernel in the exotic orbit;
 (3) + (4) compute the orbit's monodromy character;
 (5) names its marking torsor.
```

Removing any one of them breaks the conclusion.  In particular, (3) alone
does not determine `K_2`, which is the valid core of the hostile objection;
with (1) and (2) already proved, however, no further graph-coordinate descent
lemma is missing.

## Relative algebraicity

The subgroup `K` in (1) is the kernel of a homomorphism of abelian schemes,
so it is a finite flat group scheme.  On the characteristic-zero smooth
base its two-primary part is finite etale.  The graph condition and orbit
membership may be checked on one geometric fibre and extend because the
finite Hom/subgroup scheme is locally constant.  Passing to the degree-two
cover (5) selects one of the two exotic coordinates algebraically.  A
further finite level cover may label all axes and the three-primary scalar
coordinate, yielding the promised morphism to one fixed-data presentation
stack.

This is a presentation curve, not a claim that the curve is a connected
component of the full Hecke stack.

## Verdict

The actual-kernel marking is **GO** once the three-stage diagram is printed.
The source-backed statements alone do not contain this theorem; it is a new
deduction from the internally proved norm-axis kernel, graph classification,
Torelli exclusion, and Prym-axis comparison.  Safe attribution must preserve
that distinction.
