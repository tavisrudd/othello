# C670 Paper III independent release review

**Date:** 2026-07-26  
**Lane:** `clebsch`  
**Paper:** `papers/clebsch-passages/`  
**Verdict:** `GO` on the reduced two-theorem note

## Result

Paper III is now the seven-page note *Arithmetic and harmonic realizations
of the Clebsch cubic*.  It proves two independent results on the same Clebsch
four-space:

1. Hitchin's degree-two incidence extension has rational square class
   \(5J_0\), restricts to the constant golden torsor on
   \(D(\sigma_3)\), and has an explicit golden fibre whose exchanger has
   nontrivial spinor class modulo \(11\).
2. The degree-six zonal harmonics on the ten icosahedral face axes contain
   the Clebsch four-space as the Petersen \((-2)\)-eigenspace, and the
   normalized spherical cubic restricts to
   \[
   -\frac{784000}{1247103}\sigma_3.
   \]

The paper no longer claims a canonical, arithmetic, or integral
specialization to the finite matching tensor.  Sharing the four-space and
the polynomial \(\sigma_3\) is stated as a common base object, not as a map
between the two constructions.

## Exact cut disposition

The revision:

- deletes the finite tensor section and its externally supported trust row;
- deletes the repetitive common-cubic-line section;
- removes the matching-specialization claims from the title-page theorem,
  abstract, introduction, and conclusion;
- removes every manuscript-facing internal claim identifier;
- replaces the combined headline theorem by separate arithmetic and
  harmonic theorems;
- compresses the localized odd-generator and invariant-ring discussion;
- removes the raw \(M_4,M_8\) substitution matrices from the mathematical
  narrative while retaining them as artifact cross-checks;
- reduces verification prose to reproducibility and data availability;
- contracts the statement identity from seven statements to four and the
  trust manifest from nine rows to four; and
- removes the C651 finite-tensor hash and replay routes from the aggregate
  release gate.

Git commit `e3ded08d` records the validated primary cut.

## Harmonic repair

The previous display
\[
K_{ef}=P_6(u_e\cdot u_f)
\]
was the reproducing-kernel matrix, not the Gram matrix for
\(\langle f,g\rangle=(4\pi)^{-1}\int_{S^2}fg\).  The paper now states
\[
K=\frac1{243}(196I+47J-112A),\qquad G=\frac1{13}K,
\]
with normalized Gram eigenvalues
\[
\frac{110}{1053},\qquad\frac{140}{1053},\qquad\frac{28}{1053}.
\]
It displays all ten vectors \(v_{ij}\), defines \(u_{ij}=v_{ij}/\sqrt3\),
and proves that disjoint pair labels are exactly the geometric Petersen
adjacencies.  The primary certificate now records separate kernel and
spherical-Gram matrices, both spectra, the exact pair labels, and the
adjacency check.  The independent replay reconstructs the same labeling
and verifies the normalized spectrum.

## Context-free release review

A fresh ephemeral reviewer received only seven rendered page images of the
complete PDF.  It had a read-only empty working directory, no repository
instructions or source access, and no earlier review or implementation
context.  It was asked to test theorem focus, global-to-fibre logic,
mod-\(11\) scope, harmonic normalization, axis recoverability, audience,
literature positioning, dependency boundaries, and title-page readiness.

The reviewer returned:

- **Verdict:** `GO`;
- **Blocking findings:** none;
- **Arithmetic:** the branch-divisor, Picard-group, golden-fibre, and
  constant-\(5\) argument is coherent;
- **Harmonic:** the factor \(1/13\), positive Gram spectrum, witness moment,
  and coefficient \(-784000/1247103\) check out;
- **Scope:** the mod-\(11\) result is correctly restricted to the displayed
  fibre and exchanger;
- **Recoverability:** the ten axes and Petersen labeling are reconstructible
  from the paper; and
- **Contribution:** the strongest result is the exact rational square class
  and constant golden torsor, with the harmonic theorem a worthwhile
  independent companion.

The review's cheap material-minor requests were applied after the verdict:
the paper now defines \(H\) and the incidence cover operationally, defines
\(D(\sigma_3)\), places the mod-\(11\) boundary immediately after the
theorem, attributes each imported Hitchin step at section level, separates
the paper-owned arithmetic and harmonic results from their classical
inputs, and explains conjugation of the displayed golden-ratio axis
coordinates.

Two submission-format items require external information rather than a
mathematical repair.  The artifact bundle still needs an immutable public
locator, and affiliation/contact metadata require the author's chosen
submission identity.  The manuscript states the locator gate and does not
invent either item.

## Bibliography and dependency audit

The focused paper retains the eight sources already checked by C669:
Hitchin's two primary papers, Dye, Mukai--Umemura, the binary-form reference,
the two Steinhardt--Nelson--Ronchetti papers, and DLMF.  The deleted finite
and marked-Mathieu branches take their literature with them.  No retained
claim depends on Paper II, C651, the optional Lean terminal, or a file outside
the paper release package.

## Validation

The exact replay command is:

```text
python3 papers/clebsch-passages/verification/verify_release.py
```

The final run passes:

- four-statement identity;
- four-row trust manifest;
- arithmetic certificate checksum, primary check, and independent replay;
- harmonic certificate checksum, primary check, and independent replay;
- manuscript rebuild; and
- warning-free LaTeX log.

The rendered output is seven A4 pages, includes the author name
`Tavis Rudd`, and has no citation, reference, overfull-box, or underfull-box
warning.

## `ej` + `tt` closeout

The closeout pass asked whether the subtraction exposed a stronger result,
a cheaper intrinsic comparison, or a hidden dependency.

- The arithmetic theorem is stronger when left independent: its rational
  square-class argument no longer inherits an unproved finite normalization.
- The harmonic theorem now carries its own exact geometry.  Displaying the
  axes and separating \(K\) from \(G\) makes the factor-\(13\) correction a
  conceptual addition-theorem statement rather than a patched scalar.
- There is no cheap canonical comparison to recover.  The former
  intertwiner has independent irreducible scalings, and the paper defines no
  common primitive lattice.  Restoring a bridge would require new
  mathematics, not another editorial pass.
- The remaining free upgrades were the operational definition of the
  incidence cover, exact source attribution, the principal-open convention,
  the conjugate-axis observation, and the immediate mod-\(11\) boundary.
  All were incorporated and the aggregate replay was rerun.

## Mystery ledger

| feature | closeout disposition | exact remaining gate |
|---|---|---|
| factor-\(13\) discrepancy | **settled**: \(K\) is the reproducing kernel and \(G=K/13\) is the normalized Gram matrix | none |
| three-way arithmetic--finite--harmonic bridge | **settled for this release by subtraction**: the available finite intertwiner is noncanonical and supplies no integral comparison | any successor must construct a geometric correspondence, canonical normalization, and primitive common lattice before receiving a new C-ID |
| pullback across \(\sigma_3=0\) | open beyond the retained theorem; the paper proves only the constant torsor on \(D(\sigma_3)\) | normalization, conductor, and branch-multiplicity theorem; currently unallocated |
| all-degree face-axis channels | open beyond degree six | uniform decomposition and Gaunt-scalar theorem; currently unallocated |
| public artifact locator | external packaging item, not a mathematical mystery | immutable deposit and author-supplied identifier before submission |

No genuine mystery remains inside the retained two-theorem claim surface.
The open mathematical questions change the paper's scope and are not
promoted by C670.

## Vibe check

The subtraction worked.  Paper III is shorter, mathematically cleaner, and
now has an independently confirmed publishable center; the only remaining
release friction is external packaging and ordinary submission metadata.
