# C532 — PRS redundancy-ten synthesis

**Lane:** `reed-solomon` · **Status:** complete 2026-07-24

## Objective

Combine C512's coherent polar induction, C525's characteristic-two carrier containment, and the
C530/C531 degree-nine Lucas-carrier arithmetic into a fixed redundancy-ten theorem for
projective Reed--Solomon deep syndromes.

Derive the exact high-field deep set, effective threshold, cardinality, and
\(PGL_2/P\Gamma L_2\) orbit transport.  If a bounded residue remains, state its intrinsic quotient
domain and stop condition; do not substitute an ambient syndrome census.

Eventual report:
`notes/2026-07-23-c532-prs-redundancy-ten-synthesis.md`.

Outcome: exact persistent-only classification for odd `q>=59`; in
characteristic two, exact persistent/Lucas containment from `q>=64`, with
the rank-two nonconstant Artin--Schreier cover and two-dimensional carrier
quotient retained as the honest residue.

## Entry gate

C531 must provide a closed arithmetic classification of every relevant contained carrier stratum,
or an exact theorem boundary identifying the first unresolved component.

## Execution order

1. Freeze the degree-nine carrier theorem imported from C530/C531.
2. Apply C512's contained-or-transverse theorem and C525's ordered-Hessian threshold.
3. Compute level-specific transverse, collision, branch, and deletion degrees.
4. Derive the first valid prime-power threshold rather than quoting a real-number asymptotic.
5. Count and classify the surviving persistent/modular orbits with coefficientwise Frobenius.
6. Isolate any bounded residue by intrinsic normal forms only.

## Acceptance gates

- Exact redundancy-ten coding statement and parameter range.
- Effective high-field threshold with every geometric input named.
- Exact deep-set cardinality and semilinear orbit law on the proved range.
- Honest unresolved-residue boundary if C531 stops early.
- No ambient `PG(9,q)` census.
- Atomic evidence bundle for every computational claim.

## Stop rules

- Do not infer arithmetic deepness from carrier containment.
- Do not hide an unproved component/monodromy hypothesis in the synthesis statement.
- Do not open C500.

## Owned paths

- `notes/2026-07-23-c532-prs-redundancy-ten-synthesis*`
- `notes/reed-solomon-tasks/c532-prs-redundancy-ten-synthesis.md`
- the `reed-solomon` handoff, archive, discovery track, and task lifecycle rows
