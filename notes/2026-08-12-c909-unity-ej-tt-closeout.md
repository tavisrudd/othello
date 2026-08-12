# C909 — two-hour unity pass: EJ + TT closeout

Date: 2026-08-12

Status: accepted structural package with exact remaining gates; no manuscript,
PDF, mirror, or Lean edit

## Accepted theorem spine

The epilogue's cycle mechanism is now the dimension-five specialization of
a general finite-etale saturation theorem:

```text
 marked self-adjoint finite-etale elliptic-power presentation
      => full integral Lefschetz divided-power saturation in every degree
      => Theta^[4] is an ordinary divisor product
      => Voisin universal CH0 for a cubic intermediate Jacobian.
```

Fixed integral data vary over finite-level modular presentation curves.  The
pullback along the cubic period map is the precise separation locus.  For
each fixed datum, the intersection is finite unless the whole modular graph
curve is a shared cubic component; in that case Torelli rigidifies its
normalized period curve.  The independent all-cubic quantum theorem makes
`X x P^1` irrational at every point of this locus.

For the six-axis packet, the modular mechanism is exact.  Reduction modulo
two gives the Borel/nonsplit-Cartan decomposition

```text
 P^1(F4)=P^1(F2) disjoint_union {omega,omega^2}.
```

Over `X_0(3)`, these are respectively the degree-three `X_0(6)` root cover
and the degree-two congruence sign cover `r^2=T`; their fibre product is the
full projective level-two splitting cover.  The signed cubic coordinate has
`T=81t^2`, hence `r=9t`: it trivializes the elliptic exotic marking torsor.

The negative cubic formal monodromy and the exotic slope are the complex and
mod-two fibres of the Eisenstein order `Z[zeta_3]`.  This is a genuine common
coefficient packet, but no common family torsor or comparison functor exists
yet.

## EJ pass

The cheap extra value was the modular Cartan interpretation.  It compresses
four facts formerly proved separately—five kernels, `3+2` monodromy, the
quadratic marking, and squarefree exotic slope—into one standard orbit
mechanism.  The general `PGL_2(F_p)` Borel/nonsplit-Cartan orbit theorem
predicts analogous marked Hecke packets at every prime.  Its integral
saturation consequence is conditional on an actual self-adjoint unramified
lift and all blockwise divisor-lattice hypotheses; the group orbit alone is
not enough.

A second cheap gain is the finite-or-shared-component dichotomy.  It explains
why another cubic family cannot be expected by generic intersection: a fixed
modular curve meets cubic periods only finitely unless a whole modular
coincidence is present.

## TT pass

The hostile correction is decisive.  The exact `j`-map and Torelli identify
the normalization of the reduced cubic period-image curve, and `r=9t`
identifies the elliptic marking cover.  They do **not** construct a relative
integral polarized isogeny `E^5-->J` or its graph kernel.  Full level can
trivialize an existing subgroup, not create the integral lattice.  Likewise,
relative Neron--Severi sections need not lift to line bundles after finite
etale base change; a Picard torsor can remain nontrivial.

Therefore the shared fixed-stack component and horizontal minimal-cycle
statements remain conditional.  The precise integral gate is much smaller
than a global census: `Gamma_0(3)` rigidity leaves only two 3-adic endpoints,
so one rational VHS/motive comparison, one primitive fibre test, and one
polarization scalar decide the relative lattice.

## Mystery ledger

### Settled

1. The natural general cycle domain is a countable union of fixed-data
   modular presentation curves, not an ad hoc family or one finite-type
   universal locus.
2. Finite etaleness saturates the whole Lefschetz divided-power algebra while
   leaving explicit lower-degree ambient Hodge defects.
3. The six-axis `3+2` packet is the Borel/nonsplit-Cartan resolvent diagram.
4. The signed cubic parameter exactly trivializes the elliptic exotic cover.
5. A fixed modular datum meets cubic periods finitely or supports an entire
   shared curve.
6. The common Eisenstein order is real coefficient arithmetic, but not a
   common geometric invariant.

### Open with exact gate

1. **Relative integral graph lift:** prove the rational `A_5` multiplicity
   comparison, choose one of the two `Gamma_0(3)` integral endpoints at one
   fibre, and fix the polarization scalar.  A new orbit-axis route may close
   this without periods: integral subgroup norms construct the relative
   elliptic image schemes and canonical conjugacy transports; the remaining
   check is that Roulleau's primitive Albanese-dual inclusions globalize on
   those images with Gram `(5,-1)`.  Owner: C909 if pursued as proof
   compression; it does not require C908 Chow descent.
2. **Horizontal minimal cycle:** after the integral lift, construct the
   finite list of kernel-linearized relative coefficient line bundles.
   Unmarked descent and relative diagonal remain C908 territory.
3. **Shared Cartan/quantum torsor:** construct a nontrivial quantum
   `Z[zeta_3]` orientation torsor and compare its `H^1(C_2)` class with the
   exotic selector.  No current evidence makes this likely.
4. **Second cubic component:** bounded source audit found none.  The cyclic
   and `A_4` loci are candidates only; Klein is a point on the known curve.
5. **All-degree ambient Hodge defect:** dimension eight middle degree remains
   behind the nested unit-minor theorem.  This is a successor-paper crown,
   not epilogue unity.

## Promotion verdict

Promote to the epilogue, after theorem-local reproof and priority audit:

* the full finite-etale Lefschetz saturation theorem;
* the fixed-data separation-locus corollary;
* the `p=2` complementary modular resolvent diagram and `r=9t` identity;
* the finite-or-shared-component proposition, if the moduli language is used.

Keep out of the epilogue body:

* the unproved relative integral graph lift and horizontal cycle;
* the odd-prime conditional Cartan generalization beyond one brief remark;
* the full Hodge-defect formulas and Dyck conjecture;
* any claim of a common cycle--quantum torsor.

**Vibe:** the unity upgrade is real and strong on the cycle side: an
exceptional lattice calculation has become a general modular saturation
mechanism.  The paper's two branches still meet by intersection rather than
by one invariant, but the meeting is now geometrically organized and no
longer accidental.
