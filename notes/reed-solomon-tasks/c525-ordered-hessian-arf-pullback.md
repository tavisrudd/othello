# C525 — characteristic-two ordered-Hessian root-line classification

**Lane:** `reed-solomon` · **Status:** queued next; C519 closed

## Objective

Classify the characteristic-two root-compatible ordered-Hessian incidence curves
\[
\mathcal C_{f,R}:
\operatorname{Hess}^{\mathrm{div}}(L_f(R\lambda))(r,s)=0
\subset\mathbf P^1_\lambda\times\mathbf P^1_{r:s},
\]
which have bidegree `(2,2)` and arithmetic genus one. Determine exactly when they are
geometrically reducible, nonreduced, or inseparable; pull that locus back to syndromes; and prove
that it is precisely the persistent/Lucas carrier or exhibit the first additional component.

Eventual report: `notes/2026-07-23-c525-ordered-hessian-arf-pullback.md`.

## Entry from C519

C519 proves:

- the residual quadratic is the divided Hessian
  `N_u X^2 + N_s X Y + D Y^2`;
- in characteristic two its rational splitting class is the Arf invariant
  `D N_u/N_s^2`;
- the generic class is nontrivial by the specialization `1/A`;
- the ambient ordered-root cover is the rational ordered-secant projective bundle of the twisted
  cubic; and
- every root-compatible factor pencil maps to a line
  `ell_(f,R)=L_f(P(R E^vee))`, whose ordered-Hessian incidence is `(2,2)`.

Use the frozen C519 report, generator, JSON, replay, and checksum. Do not regenerate earlier
PRS censuses.

## First falsifiable gate

Compute the reducible/nonreduced/inseparable ideal of the universal `(2,2)` Hessian incidence in
Pluecker coordinates on `G(1,3)`. Test the exact claim:

> every degenerate ordered-Hessian curve is explained by a constant secant pair or the
> tangent/Frobenius ruling.

If false, prove the first additional component's equations, dimension, generic factorization
type, and distinction from those classical families, then stop.

## Execution order

1. Write a line in binary-cubic space as `U lambda_0+V lambda_1`; derive its divided-Hessian
   `(2,2)` equation and exact `GL2 x GL2` transport.
2. Classify its `(1,0)+(1,2)`, `(0,1)+(2,1)`, `(1,1)+(1,1)`, vertical/horizontal, nonreduced,
   and inseparable factorizations scheme-theoretically in every characteristic-two extension.
3. Express those loci in line Pluecker coordinates and separate constant-secant, tangent-ruling,
   complementary-ruling, and genuinely new components.
4. Pull the equations back along the constrained map
   `(f,R) -> L_f(P(R E^vee))`; arbitrary lines alone do not pass.
5. Compare the saturated syndrome loci with the persistent catalecticant and Lucas-nucleus
   ideals, using the frozen `n=5,6,7,8` boundaries as calibrations rather than evidence for the
   general theorem.
6. Outside the classified carrier, retain the ordered-root torsor and all determinant, branch,
   repeated-root, and fixed/residual collision divisors; apply the genus-one rational-point bound
   only after geometric integrality is proved.

## Acceptance gates

- Complete universal degeneracy ideal for the ordered-Hessian `(2,2)` curve.
- Exact pullback to root-compatible Hankel lines.
- Equality with persistent/Lucas carriers, or a proved first additional component.
- Characteristic-two rational lifting stated through the Arf/Artin--Schreier class.
- Explicit deletion degrees and field threshold if the carrier equality passes.
- Atomic generator/certificate/replay/checksum bundle for every paper-facing computation.

## Stop rules

- Stop at the first additional irreducible carrier component after proving its intrinsic geometry.
- If a universal line component disappears on all root-compatible Hankel lines, prove the empty
  pullback rather than retaining it as an exception.
- If a geometrically integral `(2,2)` curve can still have no rational ordered-root lift because
  of a constant-field twist, state the exact twist and stop before Hasse--Weil.
- Do not substitute redundancy ten, an ambient syndrome census, or arbitrary projective lines for
  the constrained pullback theorem.

## Owned paths

- `notes/2026-07-23-c525-ordered-hessian-arf-pullback*`
- `notes/reed-solomon-tasks/c525-ordered-hessian-arf-pullback.md`
- the `reed-solomon` live handoff, archive, discovery track, and task lifecycle rows
