# C665 — uniform extension-field C1

**Lane:** `clebsch`

**Opened:** 2026-07-26

**Status:** active Paper II v2 research; T3 is closed and the \(q=121\)
embedded-nonretract C1 gate is open.

## Objective

Prove or sharply delimit uniform C1 for the remaining exceptional
\(A_4,S_4,A_5\) heads over extension fields.  This work must not hold or
enter Paper II v1 before the uniform theorem exists.

## Established state

- The balanced \(q+q\) theorem and hyperplane-square lemma are proved.
- The characteristic-three torus gate T3, including split, nonsplit, and
  antipodal cases, is closed.
- Prime fields are closed.
- The \(q=25\) and \(q=49\) heads have zero affine Hom.
- At \(q=121\), \(L(6)\subset\operatorname{Sym}^{59}L(2)\) is the first
  certified embedded nonretract; \(L(8)\) and \(L(12)\) are eliminated.
- The former high-order Hasse-pairing detector was non-equivariant and is
  retired.  C1 at \(q=121\) is genuinely undecided.

## Fixed convention

\[
0\to F\to E\xrightarrow{\epsilon}k\to0,\qquad
F=\operatorname{Sym}^{(q-3)/2}L(2),
\]
\[
\partial:\operatorname{Sym}^2E\to E,\qquad
\partial(xy)=\epsilon(x)y+\epsilon(y)x.
\]

For each outer-parity head \(i:S^\chi\hookrightarrow E\):

1. close it if \(\operatorname{Hom}_H(S,E)=0\);
2. if it embeds, decide whether that occurrence retracts;
3. use the retracted-socle trace lemma only for a proved retraction with
   \(p\nmid\dim S\); and
4. only for an embedded nonretract compute the pullback class or give an
   injective Borel obstruction.

## Immediate gate

For \(L(6)\subset\operatorname{Sym}^{59}L(2)\) at \(q=121\), all genuine
ordinary contractions of orders \(1,\ldots,10\) are now certified
Borel-blind.  The affine class also dies in the \(L(6)\) head, with exact
torus-fixed correction scalar \(4\), while both \(L(8)\) digit placements
are absent from the head.  Modular Hermite reciprocity forces the affine
class into the middle
\[
T_+\oplus T_-=
\bigl(L(9)\otimes L(1)^{(1)}\bigr)\oplus
\bigl(L(1)\otimes L(9)^{(1)}\bigr)
\]
channel.  Exact nonsquare dilation gives outer signs \(+1,-1\) on
\(H^1(B,T_+),H^1(B,T_-)\), respectively.  PGL-equivariance therefore
forces the affine class into \(T_+\); both unique \(L(6)\) Hom directions
are also outer-even.  Outer parity isolates but does not exclude the
channel.  Prove that multiplication by the bottom \(L(6)\), followed by
graded trace \(7\ne0\), survives the filtered connecting map.  The full
direct Borel pullback is the fallback.

## Guardrails

Do not infer occurrences from composition factors, extrapolate from
\(q=25,49\), reuse the retired Hasse pairing, resume T3, or construct a
field-sized symmetric square before the affine Hom gate.

## Acceptance and records

Acceptance is a uniform theorem or a sharp obstruction covering every
remaining family, with exact replay and Paper II v2 disposition.

Baseline:
`notes/2026-07-26-c665-balanced-matching-completeness.md`.
Current correction:
`notes/2026-07-29-c665-uniform-c1-correction.md`.
