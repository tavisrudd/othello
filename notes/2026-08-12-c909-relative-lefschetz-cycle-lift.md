# C909 — relative Lefschetz-cycle lift on a fixed marked component

Date: 2026-08-12

Status: conditional structural lemma after hostile audit; intentionally stops
before relative diagonal or Chow-descent questions owned by C908

## Statement

Let `S` be a smooth complex curve with a full level structure, let `E/S` be
an elliptic scheme, and let

```text
       f : E^g --> A
```

be a fixed-data polarized quotient by a finite flat marked self-adjoint graph
kernel.  Assume its local positive-depth spectral packets are finite etale.
Assume that, after a further finite etale cover `S'-->S`, there are
kernel-linearized rigidified relative line bundles
`L_1,...,L_N` on `A_{S'}` and integers `n_I` such that the relative cycle

```text
 Z_k = sum_I n_I product_{i in I} c_1(L_i)
        in CH^k(A_{S'})
```

has, on every geometric fibre,

```text
             cl(Z_k|A_s) = Theta_s^k/k!.
```

More generally the construction works for every relative Neron--Severi
section in the finite-etale divided-power envelope.  In particular, for
`g=5,k=4` it gives one horizontal algebraic representative of the primitive
minimal cohomology class on the marked component.

## Proof mechanism

The finite graph datum is constant after the chosen level cover.  Every
coefficient divisor used in the integral rank-one proof is therefore a
constant section of the Neron--Severi local system of `A/S`.  The relative
Picard scheme fits into

```text
 Pic^0(A/S) --> Pic(A/S) --> NS(A/S).
```

For a finite list of constant Neron--Severi sections, the inverse images are
torsors under the dual abelian scheme.  Such torsors need not become trivial
after finite etale base change.  Finite theta-group ambiguity controls a
linearization only after the line bundle exists.  Thus existence of the
`L_i` is a genuine hypothesis until an explicit relative
correspondence/theta-group descent calculation is printed.

The local saturation proof is an identity in the fixed integral coefficient
lattice.  It is independent of the elliptic modulus, so the same finite
integer coefficients `n_I` work over the entire connected base.  Taking
relative first Chern classes and intersections gives `Z_k`.  Fibrewise cycle
class commutes with specialization, and the lattice identity identifies it
with `Theta_s^[k]`.

No rational equivalence between `Z_k` and a formal divided power of the theta
divisor is asserted.  The conclusion is the existence of a relative Chow
cycle with the required fibrewise cohomology class.

## Exact gain and boundary

This converts the fixed-data theorem from pointwise algebraicity to a single
horizontal cycle on a finite marked modular cover.  It makes the marking
geometrically useful: the marked cover is where the coefficient divisor
classes and their descent linearizations become simultaneous relative line
bundles.

It does **not** prove:

1. descent of the cycle to the unmarked Hecke image;
2. descent from the exotic quadratic sheet to the original `A_5` pencil;
3. a relative decomposition of the diagonal;
4. universal `CH_0`-triviality of the generic fibre over the base function
   field; or
5. equality in the Chow ring with `Theta^k/k!` as a divided operation.

Those are genuinely stronger Chow/descent questions and remain outside
C909.

## Audit gate

Before manuscript use, print one of the following equivalent constructions
for the relative line bundles:

* an explicit theta-group linearization of the coefficient line bundles on
  `E^g` trivial on the marked kernel; or
* explicit relative divisor correspondences whose associated line bundles
  represent the required Neron--Severi sections.

Without that lemma, the relative statement is structurally compelling but
not yet publication-grade.  The fibrewise saturation theorem does not need
it.
