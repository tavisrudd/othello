# C909 — fixed-graph modular normalization theorem

Date: 2026-08-12

Status: structural consequence of the closed norm/Prym/kernel bridge; no
manuscript, PDF, mirror, or Lean edit

## Fixed datum

Fix first the minimal sign-marked presentation datum `tau_0`:

* the elliptic `X_0(3)` source with its cyclic subgroup of order three;
* the coefficient polarization `6I_5-J_5` on its fifth power;
* one of the two exotic self-dual two-primary graph coordinates; and
* the unordered six-axis augmentation frame with its monodromy-selected
  scalar three-primary orbit.

Let `M_tau0` be the resulting sign-marked fixed-data modular presentation curve.  An
object over a scheme is the elliptic source with this level structure and
the quotient ppav determined by the fixed finite graph kernel.  After
rigidifying the central `+/-1` inertia, `M_tau0` is the index-two
`Gamma_ex` cover of the appropriate open of `X_0(3)`.  Its
function field

```text
                         C(T,r),       r^2=T.                (1)
```

## Theorem

Let `U_A5^sign` be the signed smooth nonstandard `A_5` cubic line.  After the
same finite level refinement as above, the relative norm-axis construction
defines a morphism

```text
                         U_A5^sign --> M_tau0.               (2)
```

The morphism is an open immersion onto the complement of the cubic boundary
inside the normalization of `M_tau0`'s image.  On coarse normal curves its
function-field map is the identity

```text
 C(M_tau0)=C(T,r)=C(t),       T=81t^2,       r=9t.           (3)
```

After forgetting the sign, the normalized reduced period image is

```text
 X_0(3) - {0,infinity,-27,729/5}.                            (4)
```

Thus the `A_5` family is a shared cubic/modular presentation curve for one
fixed graph datum.  This is stronger and more precise than saying that its
fibres happen to admit finite-etale presentations.  It is not a claim that
the curve is a connected component of the full Hecke stack or of the
countable union over all data.

## Proof

The norm-axis theorem constructs the source elliptic scheme and actual
relative quotient kernel.  The Prym-axis theorem identifies that source with
the explicit Van Geemen--Yamauchi elliptic Prym.  The actual-kernel
resolvent diagram places its two-primary graph in the exotic orbit and
identifies the labelling cover with (1); the scalar three-primary coordinate
becomes constant after the fixed finite level refinement.  These data give
(2) algebraically.

The explicit modular calculation has `T=81t^2`, while the selected sheet has
`r=9t`; hence (3) is an equality of function fields, not merely a dominant
map of degree greater than one.  Both source and target are normal curves on
the selected smooth finite-level open.  A birational quasi-finite morphism
between normal curves is an open immersion after deleting the finitely many
points where the chosen universal models or cubic family degenerate.  The
four cubic boundary values are exactly those in (4).  Strong Torelli rules
out any additional generic identification on the cubic side; the generic
projective normalizer quotient is already the sign involution `t |-> -t`.

Full `E[2]` level is the degree-six
`Gamma_0(3) intersect Gamma(2)` cover, hence adds a degree-three extension
over `M_tau0`.  If one orders the axes, chooses a full symplectic basis of two-torsion, or
adds full level at three, the resulting fine presentation curve is a finite
cover of `M_tau0`; its function field need not equal `C(t)`.  The cubic
family lifts only after the corresponding finite base change.  Stack
inertia does not alter the coarse conclusion.  Before rigidification the
central elliptic `[-1]` acts trivially on two-torsion and gives the standard
generic automorphism gerbe; the equality of coarse function fields and the
fixed level-labelled statement hold after the common finite cover.

## Consequences

1. The all-degree graph saturation theorem holds identically along this
   modular curve, so the algebraic minimal class is a modular-family
   consequence rather than a fibrewise recomputation.
2. Fixed graph data determine the generic ppav quotient from the elliptic
   source.  Strong Torelli then reconstructs the cubic along the shared open.
3. The two sheets of `r^2=T` are exactly the two coordinated exotic graph
   presentations; their deck involution is both modular sign and cubic outer
   marking.
4. The boundary problem is cleanly separated: extending (2) across cusps or
   the chordal/`A_2` cubic fibres requires semiabelian/logarithmic geometry,
   but contributes nothing to the smooth separation theorem.

## Scope warning

The function-field equality concerns the minimal sign-marked datum `tau_0`, not
arbitrary full level.  Fine labels introduce finite covers rather than new
geometric content.  The theorem does not assert that every point of the compactified
modular curve comes from a smooth cubic, and it does not classify other
fixed graph data whose modular curves meet the cubic period locus.
