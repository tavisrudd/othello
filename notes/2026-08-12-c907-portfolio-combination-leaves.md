# C907 portfolio combination leaves

**Lane:** `clebsch`

**Question:** which landed results genuinely shorten the route to the full
stable-irrationality programme, and which nearby theorems are worth taking
before the platinum endpoint?

## Decision

There are two newly unlocked consequences and three near leaves worth active
work. The rest of the portfolio supplies rejection tests or later
calibrations, not missing theorems.

## Already unlocked

### A. Low-dimensional stable-birational compression

The v1 blow-up formula implies that `nu_6` is birationally invariant for
smooth projective varieties of dimension at most four. Therefore it is also
invariant under one `P^1` stabilization of smooth projective threefolds.

Consequences:

1. every rational smooth threefold has `nu_6=0`;
2. the landed `V_22 dashrightarrow V_5` and `V_22 dashrightarrow Q^3`
   Sarkisov links give `nu_6(V_22)=0`;
3. Kuznetsov's rank-two-projectivization flop between an arbitrary smooth
   `V_14` and a cubic gives the same `nu_6` multiplicity on `V_14`; and
4. every smooth `V_14 x P^1` is irrational.

The proof is in `2026-08-12-c907-low-dimensional-stable-birational-compression.md`.

This changes the prime-Fano scan. Genus twelve is closed at zero and genus
eight is closed with `nu_6=2`, like the cubic. The direct
operator list is now: certify genus six `V_10`, then genera seven, nine, and
ten. Scan stable-birational classes before scalar differential operators.

### B. A sharp carrier regression

`V_14` shows that the universal threefold theorem cannot be strengthened to
formal support absence: a noncubic threefold can carry the same primitive-
sixth multiplicity as the cubic. The correct target remains enriched length
at most one. Conversely, `V_22` has a width-three algebraic pagoda but no
primitive-sixth formal support. Thus
ordinary Rees width of a Sarkisov chart is not cubic-isotypic Stokes/Rees
length.

## Gold leaves that are close

### G1. The toric residual-center Stokes theorem

This is the nearest high-value theorem. For `Bl_(P^3)P^5`, prove that the
four value-localized residual thimbles transport to the `P^3` Stokes system.
The finite algebra is mostly closed: ten boundary-star types and the bounded
`1/1` Rees chart pass exact tangent-Fitting tests.

Exact remaining work:

1. joint `y`/Rees-infinity and translated/infinity faces;
2. one common normalized saturated fan with overlap Fitting checks;
3. a product-pair collar cover and parametric Morse transport; and
4. directed hyperplane-orbit compatibility.

Split the theorem in two. The unmarked Stokes/Gram theorem does **not** need
the final point-class integer. The fully Gamma/Orlov-labelled theorem adds
one central-connection seed. This prevents a one-integer marking problem
from blocking the analytic theorem itself.

### G2. Prime-Fano primitive-sixth classification

Combine the weighted-CI theorem, cyclic-cover theorem, `V_5`, the new
stable-birational compression, and the remaining direct prime-Fano operators
to prove:

\[
 \nu_6(F)\le2
\]

for every smooth prime Fano threefold, with an exact list of the positive
single-pair families. After the present compression only four direct rows
remain, one of which (`V_10`) is already provisionally zero.

This is independently publishable quantum-monodromy structure and removes
all prime Fanos from the length-two admission search. It is not the universal
carrier theorem: weak factorization permits non-Fano and non-nef centers.

### G3. Birational/MMP reduction of the enriched carrier theorem

Once the codimension-two analytic theorem is available, point and curve
packets vanish, so the entire enriched packet becomes birationally invariant
for smooth threefolds. The universal carrier problem then compresses to
birational types:

- nef-canonical minimal models: empty packet;
- Fano Mori fibre spaces: prime/Fano classification plus relative structure;
- del Pezzo fibrations; and
- conic bundles.

The useful leaf is not an MMP census. It is a precise reduction theorem
stating the minimum singular-model or relative-QDM input needed in each of
these four cases. This is the strongest route from the finite Fano work to
the arbitrary-center gate.

## Silver leaves that are nearly free

1. **Unmarked toric Gram equivalence.** Finish the common fan/collar and prove
   the residual Beilinson Gram matrix before fixing the individual Orlov
   labels.
2. **`V_10` certification.** Add the tracked recurrence certificate and a
   direct full-QDM scalarization to promote the provisional `nu_6=0` result.
3. **Enriched birational-invariance lemma.** State the formal consequence of
   strict blow-up biproducts and empty point/curve packets independently of
   the MMP.
4. **First ambient--residual extension class.** After the order-zero theorem,
   compute the off-diagonal first jet; the internal `-H^2` jet is already
   gauge-trivial and should not be recomputed.
5. **Genus-eight operation-frame calibration.** Test whether the cubic--`V_14`
   Kuznetsov equivalence carries the same Gamma-marked primitive-sixth packet.
   This is a non-toric definition test for Wave 0, not a substitute for the
   blow-up theorem.

## What combines, and what does not

| landed programme | real C907 use | exact boundary |
| --- | --- | --- |
| C682 Schur--Sarkisov | removes `V_22`; supplies a width-three composition stress test | there is no code-port/Rees-to-Stokes functor, and the pagoda has zero primitive-sixth support |
| C909 atomic support | supplies the strict-position combinatorial shell for the final telescope | its conformal-block and divisor-product filtrations are not quantum Stokes/Rees objects |
| Paper V / C904 golden marking | later marked path for the `A_5` non-toric `Bl_XP^5` pilot | it cannot fix the toric `P^3` Gamma seed or bound arbitrary centers |
| C908 integral Chow/gluing | warns how deep corrections can disappear in a coarse readout | no map from the lambda bit or `p`-typical gluing to the cubic quantum packet is proved |
| repair ports / PRS flags | design principle: retain coefficients and one coherent global flag | analogy only; no theorem transfers to the common Stokes collar |

The strongest negative synthesis is useful: do not identify algebraic Rees
width, Hodge divided-power depth, or coefficient-port depth with cubic
Stokes/Rees length without a functor. `V_22` is the concrete counterwarning.

## Attack order after compression

1. Finish the unmarked toric residual Stokes theorem.
2. Fix the one Gamma/Orlov seed and only then compute positive order.
3. Certify `V_10`, close genera seven, nine, and ten, and state the prime-Fano
   classification.
4. Prove enriched birational invariance and write the exact MMP/Mori-fibre
   reduction.
5. Use the cubic--`V_14` correspondence and the `A_5` chordal pencil as
   non-toric marking calibrations.
6. Attempt the universal conic-bundle/del-Pezzo-fibration carrier bound.

This order produces publishable leaves while every step remains on the
platinum dependency graph.

## Platinum implication

The portfolio does not secretly solve `m=2`: the universal non-nef
threefold-carrier bound is still missing. It does, however, reduce the search
space and sharpen the architecture:

- analytic work separates into unmarked transport, one marking integer, and
  positive-order extension;
- the formal carrier scan is by stable-birational class, not presentation;
- `V_14` makes the formal-support bound sharp and is a compulsory regression
  for `ell_(1/6)<=1`; it does not yet prove its own enriched length; and
- the prime-Fano leaf is now finite and close, leaving conic bundles and del
  Pezzo fibrations as the likely geometric obstruction locus.
