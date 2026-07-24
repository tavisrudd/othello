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

## Acceptance gate

1. Identify the closest primary-source classification theorems and verify
   their exact hypotheses; separate false friends such as maximal arcs or
   generic few-intersection sets that do not encode tangent contact.
2. Derive the full line-intersection distribution and associated projective
   code weight enumerator, marking every consequence already equivalent to
   C554--C558.
3. Test the first genuinely new feasibility constraints: dual-code
   coefficients, polynomial/tangent-envelope identities, and any applicable
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
| Do ordinary incidence or Pless moments improve C558's arithmetic alternatives? | Open; derive before attempting stronger tools. |
| Does tangent contact impose more than the abstract spectrum? | Open; this is the likely source of any genuine carrier obstruction. |
