# C902 cold trust/exposition review

**Verdict: BLOCK.**  The new theorem itself has a sound short proof at the stated one-way generality, and ORIENT-1's added algebra sentence is an exact consequence of the displayed deck action.  OPER-1, however, contains one exact sign contradiction and one formal-coverage overstatement.

## Defects

1. **Blocking mathematical/trust-map defect: the displayed Galois-norm sign is wrong (or an essential nonstandard sign convention is missing).**  In `sections/05-golden-operator.tex`, the theorem gives
   \[
   Z_T=10\sqrt5\det B_T,
   \qquad \det[D_x,C_T]=16Z_T^2.
   \]
   With the ordinary field norm from \(E=\mathbf Q(\sqrt5)\), this forces
   \[
   N_{E/\mathbf Q}(\det B_T)
   =N\!\left(\frac{Z_T}{10\sqrt5}\right)
   =-\frac{Z_T^2}{500},
   \]
   hence \(\det[D_x,C_T]=-8000N_{E/\mathbf Q}(\det B_T)\), not the new `+8000` formula in the “Why the determinant” paragraph.  The same contradictory `+8000` identity is promoted into OPER-1's `statement` in `verification/trust_manifest.json`.  A determinant-line norm with an inserted odd-rank/Koszul sign could instead be defined, but it cannot be denoted without explanation as the ordinary \(N_{E/\mathbf Q}\).  Fix the manuscript and OPER-1 together, then regenerate statement identity.

2. **Formal-versus-human scope overstatement in OPER-1.**  The new `proof_role` says “The converse recognition is formalized at the sign-matrix range.”  But `verification/golden_return_formal.json` describes OPER-1 as `partial mechanism; no full row claim`, and its audited declarations establish the fixed conference/outer-family identities (including the fixed conference Pfaffian--triangle equality), not the classification/converse under arbitrary sign switching and relabelling stated in `thm:triangle-pfaffian-recognition`.  Attribute the recognition proof to the manuscript; describe the formal coverage narrowly as the displayed conference representative/family identity unless a declaration actually formalizing the converse is added and mapped.

3. **Minor scope/exposition ambiguity.**  Immediately before the theorem, “gives the converse on the nondegenerate real locus” reads like an exact classification, while the theorem proves only that proportionality forces \(n=6\) and \(A^2=\lambda I\) on the general weighted locus; the text explicitly says it does not classify the remaining weighted solutions.  Say that it gives a necessary scalar-square rigidity statement on the nondegenerate real locus and exact recognition only on the equal-absolute-value/sign locus.

## Checks and passes

- `python3 papers/clebsch-passages/verification/extract_statement_identity.py --check`: OK.  The new stable label is present and the generated statement/trust snapshot is current.
- TeX spacing/source-hygiene lint: OK (11 files).  Both edited JSON files parse.
- ORIENT-1 mapping: PASS.  `\mathbf Q[C]=\mathbf Q[-C]` is precisely unmarked generated-algebra invariance, while the surrounding text retains the marked-generator/orientation reversal and does not claim a global marking.
- Recognition theorem proof: PASS at its literal scope.  Homogeneous degree forces \(n=6\); translation invariance kills the off-diagonal entries of \(A^2\); commutation plus nonzero off-diagonal entries makes its diagonal scalar; the equal-modulus gauge yields a 2-regular graph on five vertices.
- Notation and source syntax: no new identifier collision, unstable theorem-number mapping, or evident LaTeX syntax defect found.  No full TeX/PDF rebuild was run; this review was restricted to lightweight non-Lean checks.

## Repair regrade

**Final verdict: PASS.**  All three defects above are repaired in the current diff.

- The manuscript and OPER-1 now use the ordinary-field-norm identity
  \(\det[D_x,C_T]=-8000N_{E/\mathbf Q}(\det B_T)\), consistent with
  \(Z_T=10\sqrt5\det B_T\) and \(\det[D_x,C_T]=16Z_T^2\).  The proof-role wording also identifies the minus sign as the odd-rank determinant-line contraction, so no nonstandard unsigned norm is implied.
- The pre-theorem sentence now distinguishes scalar-square rigidity on the nondegenerate real locus from exact recognition on the sign locus.  This matches both the theorem and its explicit weighted-solution caveat.
- OPER-1 now cites `verification/four_shadow_formal.json` and `verification/four_shadow_axioms.txt`.  The artifact's `weighted_converse`, `sign_classification`, `switching_class`, `switching_reduction`, and `orientation_scalar` mappings support the claimed formal scalar-square implication and sign-matrix converse.  Its trust boundary excludes global weighted classification, while OPER-1 correctly leaves real positivity to the manuscript argument.
- Recheck: statement identity current; four-shadow axiom-report hash matches; both JSON files parse; TeX source-hygiene lint passes on 11 files.  No Lean or full PDF build was run.

**Final compression regrade: PASS — the compressed source retains the corrected ordinary-norm minus sign, weighted/sign-locus scope boundary, and accurate OPER-1/ORIENT-1 evidence mapping; statement identity remains current.**
