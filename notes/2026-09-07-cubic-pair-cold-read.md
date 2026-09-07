# Independent cold reads of the upgraded cubic pair

**Lane:** `cubic-threefolds`
**Owners:** C978/C956 remain open by author instruction.

## Reviewed drafts and independence

Two fresh-context sub-referees read authority `d590dbec0`, exported as
m=1 `cf96368` and sharpness `7f62464`. They received no previous reviews,
private task notes, or conversation history and were told not to consult
the public reviewer guides before assessing the manuscripts. Each read
all main manuscript sources, every proof and extension, and the full PDF
by layout-preserving text extraction. Sharpness also read both generated
mathematical display files. Parent visual checks are recorded separately.

- m=1: 18 pages; PDF SHA-256
  `a4d957b8acd89b49bf73e46ddd4b625b2356123f81e900a4ce74763ab6e4b395`.
- Sharpness: 17 pages; PDF SHA-256
  `c097d691430810c1c0bafc7b31e1754fc429f3f6c3e8fbd8dca87e6c393532b7`.

This is an independent full-paper review, not a claim of completion of the
author's custom protocol: its governing location is still pending. Neither
reviewer found a verified fatal mathematical error. Neither report is an
expert certification or a probability of correctness.

## m=1 findings and disposition

1. Explain the Euler field and grading/sign convention once. Added, with an explicit match to the existing cubic connection.
2. Expose the first Sylvester equation and second-order diagonal coefficient
   used in the cubic residue. Added a compact derivation with the zero-block
   product, without an unnecessary full gauge matrix. Reviewer independently derived the displayed
   A1 using exact symbolic arithmetic during bounded repair support.
3. State that q is inverted before the small formal bulk germ. Added.
4. Repair “a invariant invariant” and “centerd”; remove the overlapping
   introduction roadmap. Done.
5. Give the exact Fermat input location, CT Theorem 2.8. Added.

The reader checked spectral splitting, rank-two pairing and cyclic
persistence, the residue arithmetic, low-dimensional vanishing, and the
additive/spectral extensions. Cached originals inspected included Iritani
Remarks 2.3 and 5.6, Theorem 5.18 and (5.47)–(5.48), Iritani–Koto Theorem
5.1 and Remark 5.3, the smooth associated cubic in Kuznetsov, Voisin
Theorem 4.5, CT's separated-variable theorem, and YYZ Theorem 3.3 and
Corollary 3.5. No defect was found in the reduced-source injectivity proof.

Limits: no reproof of imported decomposition theorems, full independent
parity audit, Beauville product-constant reconstruction, or Lean audit.
AKMW, Bittner, regular-singular classification and surface classification
were treated as standard imports. Not every background/priority citation
or the companion upper bound was reviewed by this reader.

## Sharpness findings and disposition

1. Define the rank-five character basis and its dual cocharacter basis.
   The old reference in the rank-four proof pointed literally to a
   rank-three basis. Added the basis used by the retained reconstruction
   input and corrected the reference.
2. Appendix A must give p(z), x(e,z'), the Jacobian rows and columns, and
   the restriction kernel defining H_p. Added these existing reconstruction
   conventions beside the table; no certificate inputs or outputs changed.
3. The generated table's strings of factors could be mistaken for a single
   product equation. Added an explicit interpretation before the table.

The reader checked orbit correction and descent, the common-open/density
argument, equivariant generic trivialization, field descent, generic-surface
and partner scopes, fibration levels, finite-index dominance and degree
divisibility, zero-cycle push-pull, and the restricted rank-four conclusion.
Cached TZ inputs checked: tangent projection, torsor density/existence,
Galois classification and subgroup containment, and both cubic constructions.
The reader also inspected EGFS Corollary 1.4.

Limits: the companion lower bound was imported; certificates were not rerun
by this reader; Cox quadrics were not all independently compared with source
page images; Manin, Voskresenskii, high-degree del Pezzo, Kuznetsov and the
zero-cycle originals were not independently reopened. The reader did not
independently establish the cache's version labels. Existing source audits
and computational gates remain separate evidence, not substitutes for those
checks.

## Validation and remaining review

Both readers rechecked their respective repairs against the sources and
confirmed that the findings are addressed. The m=1 reader caught one small
definition-order issue in the repair; U is now defined before centering.
The sharpness reader verified every reconstruction coordinate, Jacobian
row/column and the integral character basis against the retained generator.
Final repair hashes and synchronized commits are recorded below. No email, push or deposit is
part of this review pass.

## Mystery ledger — ej + tt

The independent reads support the intended hierarchy: the main proofs are
complete before the extensions begin. The useful additional lesson is that
coordinate conventions and a short coefficient derivation are accessibility
requirements, even when the code exposes them. The remaining evidence gaps
are the explicitly bounded imported-interface checks above and the custom
protocol's still-unlocated requirements. No new research mystery was created
by this editorial review.

## Repair validation

Both authority `make check` gates pass, including the existing source and
certificate checks. No gate or certificate input changed. The initial
sharpness metadata gate correctly required its generated witness-table
anchor to remain adjacent; the explanatory reconstruction was moved after
the table and the unchanged gate then passed.

- m=1 gate: `/tmp/claude-run-quiet/20260907-165137-make-C-cubic-stabilization-m1-check/`.
- Sharpness gate: `/tmp/claude-run-quiet/20260907-165022-make-C-cubic-stabilization-irrationality-check/`.
- m=1 repaired PDF: 18 pages; SHA-256
  `b4580e09aec3e91d6492217353ac6cf1d03af0177ac35caa09320c1f2721a57e`.
- Sharpness repaired PDF: 17 pages; SHA-256
  `50308591f366ddd21891a9bcd453eca2e2de277d8de680b07e7a9465f09c3bc2`.

Rendered-page inspection checked the connection conventions, cubic
coefficient derivation and residue continuation, and the expanded appendix
with its formulas and factor-case interpretation. No clipping was found.
The new formulas expose existing definitions and the derivation of the
already stated coefficient; no new computational theorem is asserted.

Final authority repair commit: `bdbb2b751`. Both guarded exports pass plan,
audit (zero findings), sync and verify. Standalone gates pass with the exact
repaired PDF hashes above; forward commits are m=1 `60a5236` and sharpness
`b9876e6`. No manuscript or certificate claim was weakened by the repairs.
C978/C956 remain open; the custom protocol's governing instructions are
still the next missing input. The independent review and bounded repair
rechecks are complete, with the limits stated above.
