# C907 local boundary-orbit atlas closeout

**Lane:** `clebsch`

**Status:** all ten unordered $(B,C)$ boundary-orbit types have exact local
normalized tangent-Fitting theorems for arbitrary toric $y$ valuations.  This
is orbit-type completeness, not yet one finite fan or a collar theorem.

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
| $(1,1)$ | `2026-08-12-c907-joint-y-rees-infinity-fan.md` | empty/free or four marked residual points |
| $(1,\infty)$ | `2026-08-12-c907-b1-cinf-seam-star-fan.md` | empty/free over $0\notin\Omega$ |
| $(\infty,\infty)$ | `2026-08-12-c907-binf-cinf-star-fan.md` | empty/free |

Each certificate starts from the pulled-back dense torus graph, saturates by
the exact pulled-back torus product, and proves smoothness/normality before
using the reduced-stratum tangent-Fitting shortcut.  Every report allows
arbitrary rational $y$ weights after finite ramification.  The symmetric
ordered type is obtained by the literal involution $B\leftrightarrow C$.

Thus curve selection proves that no further local orbit type exists.  The
only critical local scheme is the four-point $f_Q+ZU$ residual core.  The
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
4. verify equality of the saturated graph and tangent ideals on every
   nonempty overlap; and
5. certify that the resulting finite cone complex is complete.

Only after that object is green can the product-pair collar cover be built.
The orbit table does not by itself identify directed thimbles or the
Gamma/Orlov seed.

## EJ/TT closeout and mystery ledger

- **EJ settled:** the local problem has only ten unordered coordinate types;
  the two Laurent lemmas, the translated order-zero split, and the
  $p=\sum p_i$ feasibility relation close all of them.
- **TT settled:** two types had been implicit rather than named:
  $(0,\infty)$ and $(g,g)$.  Both are now explicit theorem-grade entries, so
  the phrase “locally complete atlas” has a literal exhaustive table behind
  it.
- **Open mystery:** whether one economical common cone complex realizes all
  local normalizations without extra exceptional overlaps.  The evidence gap
  is the missing primitive-ray/transition certificate, not another local
  tangent circuit.
- **Open topology:** even a passing common fan does not supply the proper
  product-pair collars or Mayer--Vietoris triviality.
- **Open marking:** directed hyperplane-monodromy compatibility and the
  central-connection seed remain separate after topology.
