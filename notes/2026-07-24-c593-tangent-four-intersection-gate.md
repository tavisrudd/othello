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

## Transversal-design sharpening

Put \(h=q+2-k\).  The tangent set splits into \(k\) groups
\[
 \mathcal T_a=\mathcal T_A\cap a^*,\qquad |\mathcal T_a|=h
 \quad(a\in A).
\]
A dual line not among the \(a^*\) contains at most one point of each group.
At zero defect, every line through points of two different groups is therefore
either a full \(k\)-transversal or a \((k-2)\)-transversal missing exactly the
two contacts joined by its unique primal secant.  For each missing pair there
are
\[
 d=\begin{cases}h,&k\text{ even},\\h-1,&k\text{ odd}\end{cases}
\]
such partial transversals.  Counting pairs between any two fixed groups gives
the number \(F\) of full transversals:
\[
 F=h^2-\binom{k-2}{2}d.
\]
All full transversals are dual to index-zero points of the prescribed conic,
so they belong to its distinguished dual-conic line family.  This is more
structured than an abstract four-character set: it is an embedded
group-divisible transversal design with prescribed missing pairs.

The closest classical bridge would be a resolution of the C554 maximum-
matching focus family.  Such a resolution selects \(k-1\) pairwise
edge-disjoint matching blocks covering \(K_k\), hence makes \(A\) a
generalized hyperfocused arc in the standard sense.  Regularity alone does not
prove that a resolution exists.

As a bounded falsifier, both certified abstract \(\operatorname{MATCH}(10,5,1)\)
classes from C574 do contain a resolution.  The deterministic certificate
selects and directly verifies nine disjoint blocks in each of the two
63-block designs.  Thus the resolution gate survives the two known ten-point
classes; it does not distinguish the rank-three-realizable classical class
from the field-uniformly impossible Mathon class.

Replay from the repository root:

```bash
python3 notes/2026-07-24-c593-tangent-four-intersection-gate.py --check
sha256sum -c notes/2026-07-24-c593-tangent-four-intersection-gate.sha256
```

The load-bearing input is the committed C574 JSON certificate (77,761 bytes,
SHA-256
`ce83bb36f5dcaf8161a8e28a26878e009e74e24c6393576b5b1bb3c0c938ec95`).
The C593 generator is 3,811 bytes with SHA-256
`346c2cf13e79c825764d00d414655f910cc4e7174a2bc4b666368b5653d554ee`;
its canonical JSON output is 6,067 bytes with SHA-256
`0b7809574ce719061d4d9753dda2c2b8beff9716532be1f2b9c2f46eeda9c407`.
The checker trusts Python's JSON parser and integer/set operations.  Direct
union of the nine selected matchings independently verifies that every one of
the 45 edges occurs exactly once.  This finite existence result proves neither
that every matching design is resolvable nor that a resolution is
geometrically embedded.

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
| Must the regular focus family contain a generalized-hyperfocused resolution? | Open in general; both certified \(k=10\) classes pass the bounded existence test, so resolution alone does not detect rank-three realizability. |
