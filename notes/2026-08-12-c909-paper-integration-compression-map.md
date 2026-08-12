# C909 — epilogue integration and proof-compression map

Date: 2026-08-12

Status: paper architecture only; no manuscript, PDF, mirror, or Lean edit

## Recommendation

Promote a compact structural core, not the whole C909 research package.  The
epilogue should remain a cubic paper whose cycle proof reveals a reusable
theorem; it should not become a treatise on every integral defect of
elliptic-power quotients.

## Proposed cycle-side section spine

### 1. Orbit axes and the actual relative isogeny

State one general subgroup-norm lemma for abelian schemes, then specialize:

```text
 six D5 norms -> six primitive elliptic axes
              -> Gram (5,-1)
              -> E^5 --> J, polarization 6I-J.
```

The proof needs only connected fibres, the `D_5` character average, and the
Roulleau intersection identity.  Print `n_H=2i_Hq_H` so the raw norm and
primitive Rosati endomorphism are never conflated.

### 2. Prym-axis recognition

State the general index formula in its scalar form:

```text
 quotient degree m + primitive axis exponent e
        -> e|m and isogeny degree (m/e)^r.
```

Give its four-line norm--pullback proof.  Apply `m=e=5` to identify the VGY
elliptic Prym with the norm axis.  Then print the basis-free packet lemma

```text
 P_ex(V) natural in the symplectic rank-two F2 local system V
```

and conclude that the actual kernel-marking cover is `r^2=T`, with
`r=+/-9t` on the signed line.  This replaces all source-to-auxiliary-Prym
ambiguity by one clean diagram.

### 3. Finite-etale divided-power saturation

State the fixed-data marked theorem for the prescribed graph divisor lattice.
At non-CM points this is full `NS`; at CM points it still contains the
polarization and suffices for the cubic theorem.  The human proof is:

```text
 unramified spectral splitting
 -> orthogonal blocks
 -> rank-one square-zero divisor generators
 -> squarefree expansion of divided powers
 -> faithful-flat descent and localization.
```

The local cofactor theorem becomes an immediate top-degree corollary and may
be deleted or retained only as a short normalization lemma.  No Sage/SNF
certificate is needed.

### 4. Cubic separation corollary

Define the fixed-data presentation stack and pull it back along the cubic
period map.  State:

```text
 marked finite-etale lift
   -> algebraic Theta^4/4!
   -> Voisin universal CH0;
 independently every smooth cubic has X times P1 irrational.
```

Then identify the signed `A_5` pencil with the minimal sign-marked
presentation curve over the smooth open.  Use *presentation curve*, not
*component of the full Hecke stack*.  Say that full level introduces finite
covers.

## Page cost

With disciplined reuse, the upgrade costs approximately:

```text
 orbit-axis construction                  2.5 pages
 Prym-axis formula + packet naturality    1.5 pages
 all-degree saturation theorem/proof      2.5 pages
 modular presentation corollary           1.5 pages
 net replacement of old cofactor proof   -2.0 pages
 --------------------------------------------------
 net addition                              6 pages
```

The epilogue would move from roughly 13 pages to about 18--20 pages.  That is
still unusually compact for the theorem reach.  If page pressure is severe,
put the fully general nonscalar Prym formula and arbitrary-depth ideal
calculation in an appendix, leaving a 16--18 page body.

## Keep out

Do not import:

* exact ambient Hodge-defect formulas in codimensions two and three;
* unbounded indecomposable Hecke towers;
* the conditional Dyck-height Smith formula;
* odd-prime Cartan packets beyond a one-sentence prediction;
* the Eisenstein cycle--quantum analogy as a theorem;
* relative line-bundle/Chow descent or cusp extension.

These are excellent successor material but dilute the two cubic headlines.

## Referee proof surface

The new load-bearing seams are exactly four and should be named in the
introduction or proof map:

1. primitive norm-axis/Roulleau comparison;
2. Prym-axis index formula and `m=e=5`;
3. packet naturality plus Torelli exotic-orbit selection;
4. unramified rank-one descent for the graph divisor lattice.

Every one now has a human structural proof.  The remaining computations are
small normalization checks: the `(5,-1)` Gram, `T=81t^2`, and one graph
slope polynomial at two/three.

## Editorial gain

The cycle result is no longer “we found enough divisors on one exceptional
ppav.”  It reads as:

> odd quotient-Prym geometry recognizes a primitive modular axis, and
> finite-etale spectral separation forces its full integral Lefschetz
> algebra to be generated without factorials.

The cubic pencil is then the first explicit shared period/presentation curve
on which this general mechanism yields universal `CH_0` while the independent
quantum detector yields irrationality after one stabilization.

That is a genuine mathematical narrative upgrade.  It raises top-tier
defensibility, though classification of all shared cubic curves or a second
moving family would still raise the ceiling further.

