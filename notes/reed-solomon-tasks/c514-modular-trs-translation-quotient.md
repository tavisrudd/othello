# C514 — modular one-twist translation-quotient theorem

**Lane:** `reed-solomon` · **Date queued:** 2026-07-23 · **Gate:** after C510

## Objective

For the full-length last-hook code
\[
 \operatorname{ev}_{\mathbb F_q}
 \langle1,x,\ldots,x^{k-2},x^{k-1}+\theta x^k\rangle,
 \qquad p=\operatorname{char}\mathbb F_q\mid k,
\]
turn C510's additive translation action on the tangent-projected NRC into a reusable deep-hole
syndrome reduction.

1. Normalize \(\theta=1\) and express every support determinant in translation-invariant
   coordinates.
2. Determine the full common fixed space after projection.  Start from the Lucas-maximal exponent
   flag in the degree-\(s\) NRC module, \(s=q-k\), and compute the possible connecting correction
   caused by nonexact invariants in characteristic \(p\).
3. Quotient the deep-hole avoidance condition by translations without losing stabilizers,
   Frobenius, or the standard fixed syndrome direction.
4. Test whether the quotient determinant is a pointed polar contraction covered by C512.  If not,
   prove the precise obstruction.
5. Refresh C510's incomplete Semantic Scholar forward graph before any novelty wording.

## Entry evidence

`notes/2026-07-23-c510-trs-deep-hole-pilot.md` proves the tangent-projection model, affine
stabilizer law `a+s*b*theta=1`, the modular translation action, and the Lucas-maximal fixed-space
lemma before projection.  Its exact `q=9,k=3` certificate and independent replay find only the
standard projective deep-hole direction and show that it is the entire common fixed space there.

## Exit gate

Produce an explicit translation-invariant determinant normal form and one of:

- a proved pointed polar recursion with all modular fixed-flag exceptions stated; or
- a proved obstruction showing why no C512 contraction survives.

No ambient field census, arbitrary-hook extension, punctured-family classification, or multi-twist
claim is in scope before that gate.

## Deliverable

Task report: `notes/2026-07-23-c514-modular-trs-translation-quotient.md`.
