# C593: tangent-derived four-intersection obstruction gate

**Lane:** `relconic`

**Date:** 2026-07-24

**Status:** ACTIVE

## Objective

At zero relative-conic defect, determine whether the global arrangement of
tangents to the arc supplies the rank-three compatibility invariant missing
from C554--C555 and C592.  Audit prior tangent-envelope, few-intersection-set,
and few-weight-code results; then test the strongest applicable incidence,
polynomial, and code-weight constraints.  C556 opens only if this gate yields
a field-uniform carrier or positive-defect mechanism.

## Exact input

Let \(A\) be a \(k\)-arc in \(\PG(2,q)\), let \(r(x)\) count its secants
through \(x\notin A\), and let \(\tau_A(x)\) count its tangents through \(x\).
Then
\[
 k=2r(x)+\tau_A(x).
\]
If \(\mathcal T_A\subset\PG(2,q)^*\) is the set of dual points representing
all tangents, then
\[
 |\mathcal T_A|=k(q+2-k).
\]
Zero defect gives \(r(x)\in\{0,1,\lfloor k/2\rfloor\}\), so the line
intersection spectrum of \(\mathcal T_A\) is contained in
\[
 \{q+2-k,0,k-2,k\}\quad(k\ \mathrm{even})
\]
or
\[
 \{q+2-k,1,k-2,k\}\quad(k\ \mathrm{odd}).
\]
Moreover the number of zero-secants in even size is \((k-1)(k-3)\), and the
number of one-secants in odd size is \(k(k-2)\).

## Stable reformulation

The tangent set retains the full defect, not only its zero locus.  For a dual
line \(\ell=x^*\), put \(j(\ell)=|\ell\cap\mathcal T_A|=\tau_A(x)\), so
\[
 r(x)=\frac{k-j(\ell)}2.
\]
The exact defect identity becomes
\[
 m\Delta_{\mathcal C}(A)=
 \sum_{x\in\mathcal X_{\mathcal C}(A)}
 \left(\frac{k-j(x^*)}{2}-1\right)
 \left(m-\frac{k-j(x^*)}{2}\right)
 \sum_{y\in\mathcal C}
 \frac{k-j(y^*)}{2}
 \left(m-\frac{k-j(y^*)}{2}\right).
\]
Thus \(\Delta_{\mathcal C}(A)\) is a weighted distance from a
four-intersection spectrum, with a distinguished \(q+1\)-line family
\(\{y^*:y\in\mathcal C\}\) carrying the shifted weight.  A useful theorem must
exploit either this tangent-derived contact structure or stability of this
almost-few-intersection set.  An exact zero-defect classification alone cannot
improve the asymptotic bound unless it supplies a quantitative stability gap.

## Characteristic-two code bridge

There is an elementary identity stronger than the generic few-weight-code
translation.  Work over \(\mathbb F_2\), and write
\(\mathbf 1_{a^*}\) for the incidence vector of the dual line corresponding
to \(a\in A\).  At a dual point representing a primal line \(\ell\),
\[
 \sum_{a\in A}\mathbf 1_{a^*}(\ell)
 =|A\cap\ell|\pmod2.
\]
An arc line contains zero, one, or two points of \(A\), so its odd
intersection lines are exactly its tangents.  Therefore
\[
 \boxed{\quad
 \mathbf 1_{\mathcal T_A}=\sum_{a\in A}\mathbf 1_{a^*}
 \quad\text{in }\mathbb F_2^{q^2+q+1}. \quad}
\]
In particular \(\mathbf 1_{\mathcal T_A}\) belongs to the binary line code
\(C_2(\PG(2,q)^*)\).  Its scalar product with a dual line \(x^*\) is
\(\tau_A(x)\bmod2=k\bmod2\), both for \(x\notin A\) by
\(k=2r(x)+\tau_A(x)\) and for \(x\in A\) because
\(\tau_A(x)=q+2-k\).  Hence, for even \(q\),
\[
 \begin{cases}
 \mathbf 1_{\mathcal T_A}\in C_2\cap C_2^\perp,&k\text{ even},\\
 \mathbf 1_{\PG(2,q)^*\setminus\mathcal T_A}\in
 C_2\cap C_2^\perp,&k\text{ odd},
 \end{cases}
\]
using that the all-one vector belongs to \(C_2\).  The even-\(k\) hull word
has exact weight \(k(q+2-k)\).  This supplies a precise code-classification
target; it is not yet an obstruction, since existing hull weight ranges must
be checked at the target scale \(k\asymp\sqrt{2q}\).

## Acceptance gate

1. Identify the closest primary-source classification theorems and verify
   their exact hypotheses; separate false friends such as maximal arcs or
   generic few-intersection sets that do not encode tangent contact.
2. Derive the full line-intersection distribution and associated projective
   code weight enumerator, marking every consequence already equivalent to
   C554--C558.
3. Test the first genuinely new feasibility constraints: the binary
   projective-plane code hull identity above, dual-code coefficients,
   polynomial/tangent-envelope identities, and any applicable
   characteristic-two classification.
4. **GO:** expose a carrier, forbidden spectrum, or quantitative positive
   defect on an infinite target family.  **NO-GO:** prove that the standard
   few-intersection and code-moment machinery is subordinate to the existing
   matching design, and name the exact missing geometric input.

## Evidence boundary

The four-intersection spectrum is an exact reformulation of the zero-defect
matching theorem, not itself a new obstruction.  No literature theorem or
code classification is load-bearing until its statement and parameter
hypotheses have been checked against this tangent-derived set.

## Mystery ledger

| Feature | Disposition |
|---|---|
| Does the four-intersection spectrum have a known classification at \(k\asymp\sqrt{2q}\)? | Open; primary-source audit in progress. |
| Do ordinary incidence or Pless moments improve C558's arithmetic alternatives? | Likely no: the first two moments are the existing clique decomposition; higher code coefficients must be separated from automatic collinearity counts. |
| Does tangent contact impose more than the abstract spectrum? | Open; this is the likely source of any genuine carrier obstruction. |
| Can exact rigidity improve the asymptotic lower bound by itself? | No: a quantitative stability gap for the displayed weighted distance is required. |
| Does the binary hull identity hit a classified weight range? | Open: the relevant word has weight \(k(q+2-k)\asymp q^{3/2}\), so small-weight results may not reach it. |
