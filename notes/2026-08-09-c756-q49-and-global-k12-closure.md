# C756 \(q=49\) and global \(k=12\) closure

**Date:** 2026-08-09

**Scope:** every point type over \(\mathbf F_{49}\), followed by the fixed-size
global consequence

**Status:** \(q=49,k=12\) and hence the entire \(k=12\) layer are closed
negative

## Verdict

\[
 \boxed{\text{No conic-filling }12\text{-arc exists over any finite field}.}
                                                                    \tag{1}
\]

The new field-level result is

\[
 \boxed{\text{No conic-filling }12\text{-arc exists in }
 \mathrm{PG}(2,49).}                                                \tag{2}
\]

Its point-type branches close before an abstract characteristic-seven
moment contraction is needed:

- external deletion leaves exactly 22 normalized mixed-type stars, and every
  one violates the first forced divided elementary form \(E_7=0\);
- if every arc point is internal, the all-passant geometric search has no
  eleven-line star.

Combining (2) with the prior \(q=47,53\) closures, the exact \(q\le43\)
classification, the even-characteristic nucleus obstruction, and the
necessary bound

\[
 \binom{11}{2}=55\ge q+2
\]

proves (1).

## 1. Native \(\mathbf F_{49}\) model

The exact engine uses

\[
 \mathbf F_{49}=\mathbf F_7[w]/(w^2-3),
\]

encoding \(a+bw\) by the integer \(a+7b\).  It constructs complete addition,
multiplication, inverse, and quadratic-character tables and verifies every
nonzero inverse.  The first encoded nonsquare is

\[
 \nu=8=1+w.
\]

Since \(49\equiv1\pmod4\),

\[
 \chi(-1)=+1.
\]

In both coordinate models below, an off-conic node is internal exactly when
its displayed conic value has character \(+1\).  This sign is checked
directly rather than inherited from either prime-field engine.

## 2. External deleted point

If a hypothetical arc contains an external point \(P_0\), put its secant
polar at infinity and normalize

\[
 C:UV=\nu W^2,\qquad r_0:W=0.
\]

The 24 internal direction classes have representatives
\([u^{-1}:-u:0]\), and the other polar lines are

\[
 r_i:u_iU+u_i^{-1}V+s_iW=0,\qquad u_i\sim-u_i.             \tag{3}
\]

Because \(4\nu\) is nonsquare, every one of the 49 offsets is nontangent.
Thus the graph has \(24\cdot49=1176\) states.  Its edges impose

\[
 \chi(U_{ij}V_{ij}-\nu)=+1,                               \tag{4}
\]

and its forbidden masks exclude triple concurrency.  Split-torus
transitivity fixes one direction, while sign identifies the 25 seed-offset
classes.  Exact enumeration gives:

| item | value |
|---|---:|
| states | 1,176 |
| normalized seed offsets | 25 |
| search nodes | 16,571,670 |
| normalized geometric stars | 22 |
| line-type profile | 5 secants and 6 passants on every star |

### The divided \(E_7\) gate

For external deletion there are thirteen required internal centers.  With
the 55-node centroid translated to zero, simultaneous interpolation forces

\[
 E_7=E_8=\cdots=E_{12}=0.                                \tag{5}
\]

The first identity is genuinely characteristic-seven divided-power data.
Indeed the seventh power sum carries no mixed information:

\[
 P_7(z)=P_1(z)^7=0,
\]

whereas

\[
 E_7(S,T)=\sum_{a=0}^7 e_{a,7-a}S^aT^{7-a}               \tag{6}
\]

retains its eight elementary multisymmetric coefficients without dividing
by the vanished mixed binomial coefficients.

Every one of the 22 leaves has \(E_7\ne0\).  The checker constructs (6)
coefficient-by-coefficient and independently evaluates it at all 50
projective dual directions, comparing against a direct scalar elementary
recursion.

Direct covering supplies a second rejection: no leaf has even one complete
center.  Every leaf has minimum projection span 35 and maximum span 40.
Therefore no \(q=49,k=12\) example contains an external point.

## 3. All-internal branch

If no arc point is external, all twelve polar lines are passants.  Normalize
the distinguished passant to infinity in the anisotropic model

\[
 C:X^2-\nu Y^2=W^2.                                      \tag{7}
\]

The line \(W=0\) has 25 internal direction points.  For each one, choose a
normalized annihilating pair \((a,b)\); an affine line

\[
 aX+bY+sW=0
\]

is passant exactly when

\[
 \chi(a^2-\nu^{-1}b^2-s^2)=+1.                           \tag{8}
\]

There are 600 such states.  The anisotropic orthogonal torus is transitive
on the 25 internal directions, so one direction may be fixed; all 24
passant offsets above it are retained.  Internal nodes again have conic
character \(+1\).  Exact enumeration gives:

| item | value |
|---|---:|
| internal directions | 25 |
| passant states | 600 |
| search nodes | 636,224 |
| normalized eleven-line stars | 0 |

As a formula-level check independent of (8), the engine enumerates all 50
affine points of (7) and verifies that every retained state has zero conic
intersections.

Thus the all-internal branch fails at the geometric gate.

## 4. Global fixed-size consequence

For \(k=12\), the nonsaturated direction quotient requires

\[
 55=\binom{k-1}{2}\ge q+2,
\]

so odd \(q>53\) are impossible.  Even \(q\) are impossible because the conic
nucleus is never covered.  The saturated alternatives at this size would
force \(q=23\) or \(q=21\), so every \(q>53\) case is indeed nonsaturated.
The existing exact classification handles every odd prime power \(q\le43\).
Between 43 and 53 the only odd prime powers are

\[
 47,\quad49,\quad53,
\]

and all three \(k=12\) layers are now closed negative.  These cases exhaust
the field parameter, proving (1).

This fixed-size theorem does not propagate to \(k\ge13\), where both the
defect and field window change.

## 5. Exact bundles

External-deletion bundle:

- notes/2026-08-09-c756-q49-external-deletion-search.py
- notes/2026-08-09-c756-q49-external-deletion-search.json

All-passant bundle:

- notes/2026-08-09-c756-q49-all-passant-search.py
- notes/2026-08-09-c756-q49-all-passant-search.json

Replay:

    PYTHONDONTWRITEBYTECODE=1 python3 \
      notes/2026-08-09-c756-q49-external-deletion-search.py \
      --check notes/2026-08-09-c756-q49-external-deletion-search.json \
      --workers 8

    PYTHONDONTWRITEBYTECODE=1 python3 \
      notes/2026-08-09-c756-q49-all-passant-search.py \
      --check notes/2026-08-09-c756-q49-all-passant-search.json

The all-passant checker pins the field engine by SHA-256.  Both searches
reconstruct every intersection directly, enforce no triple concurrency, and
use native \(\mathbf F_{49}\) arithmetic throughout.

## EJ2 + TT closeout

**EJ2.**  The important choice was not to reconstruct degree-seven moments
from \(P_7\).  Testing the forced elementary binary form \(E_7\) directly
preserves exactly the information Frobenius erases.  It rejects all 22
external leaves before the larger Hasse moment carrier is needed.

**TT.**  The field-size synthesis is stronger than the isolated \(q=49\)
calculation.  Once \(47,49,53\) are placed beside the direction bound, the
entire \(k=12\) row disappears globally.  The next honest size layer is
\(k=13\), not another refinement of defect six.

## Mystery ledger

| feature | status | exact gap / next gate |
|---|---|---|
| Characteristic-seven first carrier | settled | the divided elementary form \(E_7\), not \(P_7\) |
| External-deletion geometry at \(q=49\) | settled | 22 normalized mixed-type stars |
| External-deletion window | settled negative | every leaf has \(E_7\ne0\) |
| All-internal geometry at \(q=49\) | settled negative | no all-passant star |
| Full \(q=49,k=12\) layer | settled negative | point types exhausted |
| Global \(k=12\) layer | settled negative | field bound plus \(q\le43,47,49,53\) |
| \(k=13\) and higher | open | new defects, field windows, and point-type systems |
