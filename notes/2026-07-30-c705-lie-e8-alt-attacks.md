# C705 — alternative attacks on a genuine Lie-\(E_8\) parent

**Date:** 2026-07-30  
**Status:** positive feasibility at the ambient Coble level; strict
\(q,W,A\) operator lift open

## Verdict

A genuine Lie-\(E_8\) route is possible and substantially less speculative
than the earlier bounded search suggested.

The strongest route is not a generic inclusion \(E_6\subset E_8\).  It is
the order-three Vinberg grading
\[
 \mathfrak e_8
 =
 \mathfrak{sl}(V_9)
 \oplus\bigwedge\nolimits^3V_9
 \oplus\bigwedge\nolimits^6V_9.
                                                        \tag{1}
\]
A stable trivector
\(\gamma\in\bigwedge^3V_9\) constructs the genus-two Coble sextic and its
dual Coble cubic.  C705 has already proved that the \(\tau^+\)-fixed
\(\mathbf P^4\) section of that dual pair is literally the Segre cubic and
its Igusa polar map.  Therefore the chain
\[
 \text{Lie }E_8\text{ Vinberg trivector}
 \longrightarrow
 \text{Coble cubic/sextic}
 \longrightarrow
 \text{Segre/Igusa fixed section}                       \tag{2}
\]
is literature-backed.

What is not yet proved is the last, stricter operator statement: that the
same trivector, with the ordered Weierstrass marking, produces the Joubert
parametrization \(Z\) and hence its mixed differential
\(A=dZ\) without importing that parametrization as separate outer-\(S_6\)
data.  Thus Lie-\(E_8\) is already a real ambient parent, while the exact
C705 naming gate remains one explicit commuting diagram short of closure.

## Attack A — \(A_8\) Vinberg grading and Coble trivectors

**EV: highest.**

Rains--Sam state the split Lie-\(E_8\) grading (1) explicitly and construct
from a stable \(\gamma\in\bigwedge^3V_9\):

1. the genus-two curve and its level/marking data;
2. the Coble sextic as the degree-six discriminant \(D_\gamma\);
3. the projectively dual Coble cubic; and
4. the double cover ramified over \(D_\gamma\).

Nguyen's fixed-space theorem then supplies the right-hand arrow in (2).
This is already enough to replace “no Lie-\(E_8\) realization” by “ambient
Lie-\(E_8\) realization proved in the literature.”

The exact remaining computation is bounded:

1. reconstruct the stable trivector \(\gamma_\alpha\) for C705's frozen
   Burkhardt parameter \(\alpha=(6,17,1,-7,-19)\);
2. identify the hyperelliptic involution \(\tau\) on \(V_9\) and its
   five-dimensional fixed section;
3. compute the Coble cubic from \(\gamma_\alpha\) by the trivector
   degeneracy construction;
4. match its \(\tau^+\) restriction with the frozen Segre equation;
5. reconstruct the ordered six branch points from \(\gamma_\alpha\) and
   compare their Joubert tensor with C704's six
   \(\frac14\operatorname{diag}(*\bigwedge^3C_T)\);
6. differentiate that equality.  Then \(A=dZ\), its residual
   \(\operatorname{PGL}_2\) kernel is \(q\), and its Coble/Segre conormal is
   \(W\).

Steps 1--4 certify a Lie-\(E_8\) parent of the varieties and polar map.
Steps 5--6 are the load-bearing operator gate.

The main risk is normalization and marking, not representation
nonexistence.  A stable trivector determines a genus-two curve with
additional arithmetic data, while C705 uses an ordered six-point chart.
The proof must identify those markings rather than invoke moduli
equivalence abstractly.

## Attack B — \(E_6\times A_2\) grading and the Cartan cubic

**EV: medium; cleaner tensor algebra, longer boundary comparison.**

The order-three \(E_6\times A_2\) presentation of \(\mathfrak e_8\) contains
\[
 (27\otimes3)\oplus(27^\vee\otimes3^\vee)
\]
beside \(\mathfrak e_6\oplus\mathfrak{sl}_3\).  The Lie bracket uses the
cross product polarizing the Cartan cubic on \(27\), together with the
\(\bigwedge^2 3\simeq3^\vee\) volume form.

C704 already proves that its operator Clebsch cubic is a literal Pfaffian
linear section of the Cartan cubic.  C705's Yoshida calculation then places
the Segre and Igusa systems in the value and first-normal-jet halves of one
\(E_6\) Coble system.  The proposed lift is therefore:
\[
 \mathfrak e_8\text{ bracket}
 \rightsquigarrow
 E_6\text{ Cartan cubic}
 \rightsquigarrow
 \text{Yoshida boundary value/jet}
 \rightsquigarrow(q,W,A).
\]

The first falsifier is whether the ten-dimensional Yoshida system embeds
canonically into the chosen \(27\otimes3\) slice with the correct
determinant-line normalization.  A mere branching multiplicity is
insufficient.  Even if positive, this route is less direct than Attack A
because the fixed \(B_3\) boundary factor must be transported through two
gradings.

## Attack C — \(E_7\times A_1\) and the Freudenthal quartic

**EV: low.**

The \(E_7\) Freudenthal quartic on \(56\) is naturally controlled by a
five-grading of \(\mathfrak e_8\), so it is tempting to seek the Igusa
quartic as a five-dimensional linear section and obtain Segre by polarity.
The bounded primary-source search found no explicit Igusa section, no
outer-\(S_6\) carrier, and no map to the Joubert parametrization.

This route should stop at a branching/Hom-space gate before coordinates:
locate an outer \(S_6\) with the required ordinary and signed
five-dimensional restrictions inside \(56\).  Without multiplicity one
and a quartic restriction, it is only exceptional-name matching.

## Attack D — degree-one del Pezzo/\(W(E_8)\) moduli

**EV: low as an operator proof, useful as geometry.**

Marked cubic-surface \(W(E_6)\) geometry embeds into larger del Pezzo root
systems.  This may globalize Naruki's two contractions, but a Weyl-group
inclusion does not produce the mixed potential or adjugate.  It is best
treated as a possible moduli interpretation after Attack A succeeds, not
as the construction itself.

## Choice

Attack A dominates.  It already has the exact Lie-\(E_8\) representation,
the Coble dual pair, and C705's literal Segre--Igusa section.  The missing
work is a finite marked-coordinate comparison, not a search for a new
exceptional variety.

The recommended acceptance ladder is:

1. **Ambient Lie-\(E_8\): passed** by the trivector--Coble construction.
2. **Fixed-section polar pair: passed** by Nguyen plus C705.
3. **Marked Joubert tensor from the same trivector: open.**
4. **Mixed differential \(A\) and null lines \(q,W\): formal once 3 passes.**

## Sources checked

- Eric M. Rains and Steven V. Sam, *Vector bundles on genus 2 curves and
  trivectors*, arXiv:1605.04459 — introduction, Theorem 5.4, Remarks
  5.5--5.8, and the explicit
  \(\mathfrak e_8=\mathfrak{sl}_9\oplus\bigwedge^3 9\oplus\bigwedge^6 9\)
  grading read at theorem/formula level.
- Eric M. Rains and Steven V. Sam, *Invariant theory of
  \(\bigwedge^3(9)\) and genus 2 curves*, arXiv:1702.04840 — abstract and
  source map checked for the arithmetic reconstruction of the trivector.
- Laurent Gruson, Steven V. Sam, and Jerzy Weyman, *Moduli of Abelian
  varieties, Vinberg theta-groups, and free resolutions*,
  arXiv:1203.2575 — abstract/source map checked for the Vinberg
  \(\theta\)-representation origin.
- Vladimiro Benedetti, Laurent Manivel, and Fabio Tanturri,
  *The geometry of the Coble cubic and orbital degeneracy loci*,
  arXiv:1904.10848 — introduction and Lie-theoretic placement checked.
- Quang Minh Nguyen, *Vector bundles, dualities, and classical geometry on
  a curve of genus two*, arXiv:math/0702724 — previously read §§2.1,
  2.2, 3.3, and 4.1--4.4 for the fixed Segre--Igusa restriction.

This is a feasibility and proof-design pass, not a novelty audit.  No
absence claim is made for Attacks B--D.
