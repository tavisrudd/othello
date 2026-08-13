# C907 local boundary-orbit atlas closeout

**Lane:** `clebsch`

**Status:** corrected support-orbit closeout.  All ten unordered $(B,C)$ types
have exact support and strict-orbit certificates for arbitrary toric $y$
weights.  This is not a genuine-stratum tangent atlas: at $(1,1)$, declaring
translated residue coordinates to be boundary faces creates artificial
critical families.  One regular refinement and its stratum ledger remain
open.

## Exhaustive orbit table

Let $g$ mean a finite value away from $0,1,\infty$.  Every ramified analytic
arc in the fixed $\mathbf P^1_B\times\mathbf P^1_C$ compactification has one
and only one limiting type in

\[
\{0,1,\infty,g\}^2.
\]

The potential is symmetric in $B,C$, leaving ten unordered types.  The table
assigns every one to its exact certificate.

| unordered type | certificate | local outcome |
| --- | --- | --- |
| $(g,g)$ | `2026-08-12-c907-bunit-cunit-generic-star.md` | empty/free |
| $(0,0)$ | `2026-08-12-c907-bc00-star-fan.md` | empty/free |
| $(0,g)$ | `2026-08-12-c907-b0-cunit-star-fan.md` | empty/free |
| $(0,1)$ | `2026-08-12-c907-b1-c0-seam-star-fan.md` | empty/free; marked compact attachment |
| $(0,\infty)$ | `2026-08-12-c907-b0-cinf-seam-star-fan.md` | empty/free |
| $(g,1)$ | `2026-08-12-c907-b1-cunit-star-fan.md` | empty/free, including order zero |
| $(g,\infty)$ | `2026-08-12-c907-binf-cunit-star-fan.md` | empty/free |
| $(1,1)$ | `2026-08-12-c907-joint-y-rees-infinity-fan.md` | support complete; bounded core has four points; imbalanced charts free |
| $(1,\infty)$ | `2026-08-12-c907-b1-cinf-seam-star-fan.md` | empty/free over $0\notin\Omega$ |
| $(\infty,\infty)$ | `2026-08-12-c907-binf-cinf-star-fan.md` | empty/free |

Each strict-orbit certificate starts from the pulled-back dense torus graph, saturates by
the exact pulled-back torus product, and proves smoothness/normality before
using the reduced-stratum tangent-Fitting shortcut.  Every report allows
arbitrary rational $y$ weights after finite ramification.  The symmetric
ordered type is obtained by the literal involution $B\leftrightarrow C$.

Thus curve selection proves that no further support orbit type exists.  It
does not determine which residue-coordinate zeros are genuine log strata.
The corrected $(1,1)$ replay shows the danger: its product-vanishing
restriction is four copies of $(\mathbf G_m)^2$, while the full imbalanced
chart is free by $\partial_vF=1$.  Those families disappear when $v$ remains
interior, and the four-point $f_Q+ZU$ scheme belongs to the bounded core.  The
sole constant boundary scheme is $L=0$ on the translated/infinity chart, and
the fixed residual path disk is chosen in $\mathbf C^*$, so that face does not
meet the value window.

## What completeness still means

This table closes a necessary but weaker notion than the common-fan acceptance
gate.  Each orbit chart still carries a finite hyperplane subdivision by the
orders of its Laurent terms.  The remaining algebraic proof object must:

1. choose those subdivisions simultaneously;
2. list primitive rays after clearing denominators;
3. prove the chart maps cover every face, including specialization from $g$
   to $0,1,\infty$;
4. distinguish genuine boundary divisors from interior residue coordinates,
   keeping $v$ interior in both imbalanced charts;
5. verify equality of the saturated graph and genuine-stratum tangent ideals
   on every nonempty overlap; and
6. certify that the resulting finite cone complex is complete.

Only after that object is green can the product-pair collar cover be built.
The orbit table does not by itself identify directed thimbles or the
Gamma/Orlov seed.

## EJ/TT closeout and mystery ledger

- **EJ settled:** the support problem has only ten unordered coordinate types;
  the two Laurent lemmas, the translated order-zero split, and the
  $p=\sum p_i$ feasibility relation close all of them.
- **TT settled:** two types had been implicit rather than named:
  $(0,\infty)$ and $(g,g)$.  Both are now explicit theorem-grade entries, so
  the phrase “support-complete atlas” has a literal exhaustive table behind
  it.
- **Open mystery:** whether one economical common cone complex realizes all
  local normalizations without extra exceptional overlaps.  The evidence gap
  is the missing primitive-ray/transition and genuine-stratum certificate.
- **Open topology:** even a passing common fan does not supply the proper
  product-pair collars or Mayer--Vietoris triviality.
- **Open marking:** directed hyperplane-monodromy compatibility and the
  central-connection seed remain separate after topology.
