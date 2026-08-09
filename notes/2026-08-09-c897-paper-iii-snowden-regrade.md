# C897 Paper III — Snowden focused regrade

**Date:** 2026-08-09

**Verdict:** `PASS`

## Artifact and isolation

The clean standalone mirror was at
`9fe1f912d0fb48d61a1b2587387d1a2516c3afb8`, with no tracked or untracked
changes.  The reviewed PDF `clebsch_passages.pdf` has SHA-256
`a9e270277638e0a345d5385d73f6186df47dd68074a70675af3e31deca83090d`,
matching the sealed manifest.  The assigned dossier has SHA-256
`12fd05f3ace288282075432a303214ea37d606b658e9967540e4b316efe7f8f8`.

I read the assigned dossier extracts and PDF pages 21--23, froze the PDF
judgment, and only then inspected the permitted standalone supplement.  I did
not inspect another review, synthesis, remediation or regrade note, task or
handoff state, authority source, Git history, or Lean material.

## Frozen PDF judgment

`PASS`.

1. **Complementary minor to triangle product.**  With
   (K_T=*\bigwedge^3 C_T), the coefficient on (e_S) is correctly

   \[
   (K_T)_{SS}=\operatorname{sgn}(S^c,S)\det C_T[S^c,S].
   \]

   For (S=012), the displayed complementary block has determinant (4),
   while (operatorname{sgn}(345,012)=-1); hence the coefficient is (-4),
   equal to four times the displayed internal triangle product (-1).  For
   (S=014), the determinant is (-4) and
   (operatorname{sgn}(235,014)=-1); hence the coefficient is (4), equal
   to four times the displayed internal triangle product (1).  The formula
   (operatorname{sgn}(S,S^c)=(-1)^{\sigma(S)-3}) and the check
   (*^2=-1) in middle degree are also correct.  The text explicitly warns
   that the ordered-basis Hodge orientation must travel under switching or an
   odd relabelling, so it does not silently compare matrices in incompatible
   conventions.

2. **Cross-golden determinant sign.**  Relative to
   (V_{T,+}\oplus V_{T,-}), the displayed commutator block matrix has
   determinant (8000\det(B_T)^2).  Comparing this with
   (16Z_T^2) gives (Z_T^2=500\det(B_T)^2), hence the sole remaining
   ambiguity is the sign in (Z_T=\pm10\sqrt5\det B_T).  The manuscript now
   removes that ambiguity by choosing the relative determinant-line
   orientation at (T_0) and transporting it through the coherent outer
   marking.  Since the eigenspaces inherit the ambient Euclidean metric,
   oriented orthonormal changes of frame leave this determinant unchanged.
   The resulting equality is therefore an exact marked normalization, not an
   unaccounted sign choice.

3. **Exact versus projective normalization.**  The paper keeps the two levels
   separate.  The triangle, exterior-power, Pfaffian, and oriented
   cross-golden formulas are exact polynomial equalities after the marked
   convention is fixed.  The six (Z_T) are then used as homogeneous
   coordinates for the Segre cubic, the centered squares for the
   Segre--Igusa polar map, and a coordinate hyperplane for the diagonal
   Clebsch section.  No projective rescaling is used to conceal a missing
   scalar in the four-shadow identity.

## Permitted supplement

I inspected only `sections/05-golden-operator.tex` and the paper-local
`orientation_source` certificate, checker, checksum, and independent replay.
All three recorded checksums validate; the generator's `--check` mode and the
independent replay pass.  The recorded conference matrix satisfies
(C^2=5I), gives the stated triangle products for both representatives, and
an independent direct check of all twenty triples verifies

\[
\operatorname{sgn}(S^c,S)\det C[S^c,S]
=4C_{ij}C_{jk}C_{ki}.
\]

The supplement corroborated the frozen PDF judgment and did not alter it.

## Mystery ledger and unresolved findings

No genuine mystery remains on the assigned surface.  The determinant-line equality is a declared
marked normalization whose magnitude follows from the block determinant; it
is not being presented as a canonical unmarked sign.
