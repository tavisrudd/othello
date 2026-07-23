# C530 — degree-nine Lucas \(e_7\) quotient ordered-root cover

**Lane:** `reed-solomon` · **Status:** complete at the prescribed nonconstant
Artin--Schreier/extra-monodromy stop

## Objective

Resolve the first arithmetic gap left by C529 on the characteristic-two degree-nine Lucas
carrier
\[
\mathbf P\langle e_2,e_3,e_4,e_5,e_6,e_7\rangle .
\]
At the distinguished Borel endpoint \(e_7\),
\[
W_{e_7}=\langle1,t,t^2,t^3,t^4,t^5,t^8\rangle,\qquad
\mathcal U_3=\langle1,t,t^8\rangle .
\]
Normalize the ordered-root cover contributed by the four-dimensional quotient
\[
W_{e_7}/\mathcal U_3=\langle t^2,t^3,t^4,t^5\rangle,
\]
compute its geometric components, monodromy, and coefficientwise Frobenius, and decide exactly
when the \(PGL_2\)-orbit of \(e_7\) is deep over \(\mathbf F_{2^m}\) for \(3\nmid m\).

Eventual report:
`notes/2026-07-23-c530-degree-nine-lucas-e7-quotient-cover.md`.

## Entry from C529

C529 proves:

- the degree-nine carrier is the first fresh nonzero coherent Lucas overlap;
- the linearized subcover \(\mathcal U_3\) has minimal constant field \(\mathbf F_8\), based deck
  group \(C_7\), and component Frobenius of order three;
- \(e_7\) and its \(PGL_2\)-orbit are shallow whenever \(3\mid m\); and
- the parity law already fails, but no converse is justified when \(3\nmid m\) because the
  displayed quotient has dimension four.

Use the frozen C529 report and evidence bundle.  Do not broaden to the full carrier before the
\(e_7\) quotient cover is normalized.

## First falsifiable gate

Construct the quotient-root incidence intrinsically after removing the known linearized
\(\operatorname{AGL}_1(\mathbf F_8)\) subcover.  Determine whether its generic normalization is:

1. geometrically integral with computable Frobenius twists;
2. a constant-field component cover;
3. a nonconstant Artin--Schreier cover; or
4. a cover with additional geometric monodromy.

If cases 2--4 prevent a uniform deepness law, prove the first obstruction and stop.

## Execution order

1. Compute the exact stabilizer and orbit transport of \(e_7\), retaining divided-power and
   infinity conventions.
2. Write the ordered-root incidence for the full seven-dimensional kernel and quotient out the
   known \(\mathcal U_3\) component without deleting intersections or repeated-root boundaries.
3. Normalize the surviving function-field components and compute their geometric monodromy.
4. Compute coefficientwise Frobenius, constant fields, and every rational-lifting class.
5. Translate rational split squarefree members into the exact PRS deepness criterion for
   \(3\nmid m\).
6. Only after geometric integrality is proved, use a curve bound with explicit branch,
   diagonal, infinity, and collision deletions if one is needed.

## Acceptance gates

- Exact intrinsic \(e_7\) stabilizer/orbit and quotient-kernel model.
- Normalized ordered-root quotient cover with geometric component and monodromy calculation.
- Exact Frobenius and rational-lifting law for \(3\nmid m\), or a proved first obstruction.
- Exact repeated-root, infinity, and support-collision semantics.
- No ambient syndrome census or extrapolation to the whole degree-nine carrier.
- Atomic generator/certificate/replay/checksum bundle for every paper-facing computation.

## Stop rules

- Stop at the first nonconstant Artin--Schreier or extra-monodromy obstruction after proving it.
- Do not infer deepness from Lucas containment.
- Do not classify other \(PGL_2\)-strata of the carrier until the \(e_7\) orbit is closed.
- Do not open C500 or manuscript work; it remains release-gated.

## Owned paths

- `notes/2026-07-23-c530-degree-nine-lucas-e7-quotient-cover*`
- `notes/reed-solomon-tasks/c530-degree-nine-lucas-e7-quotient-cover.md`
- the `reed-solomon` live handoff, archive, discovery track, and task lifecycle rows
