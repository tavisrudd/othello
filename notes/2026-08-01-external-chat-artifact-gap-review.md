# Gap review: external chat artifacts vs. local corpus (2026-08-01)

Cross-lane read-only review. Sources reviewed:

- `~/tmp/claude-fable-physics-files.zip` — three markdown research notes (Claude Fable session,
  dated 2026-07-29).
- `~/tmp/chat-session-files/` — one ChatGPT-style research report plus benchmark scripts and CSV
  outputs (dated 2026-07-29).

Compared against `notes/`, `papers/`, `lean/` in this repository and the standalone mirrors under
`~/src/math-papers/`, plus `notes/2026-07-31-results-summary-snapshot.md`.

## Headline

The zip is **entirely absent** from the local corpus. All three notes extend the AME local-unitary
rigidity programme (`ame-lu` lane, paper *Local-Unitary Rigidity of Stabilizer AME States and
Transversal Clifford Groups of MDS--CSS Codes*). None of it appears in any local note, manuscript,
Lean file, or mirror.

The zip has **no overlap with `papers/golden-quantum-statistics`**. That manuscript is
*Orientation and exchange statistics in a Golden six-mode transfer*: Joubert/Segre determinant
signs, symmetric-cube traces, photonic compilation. It contains no AME state, no uniformity
parameter, no stabilizer rigidity, and no Fisher-information statement. The only conceptual
adjacency is that both talk about certification thresholds for a quantum experiment, and that is
not a shared theorem.

## What is in the zip and missing locally

### 1. `approximate_rigidity_of_2uniform_states.md`

- **Theorem A.** Any 2-uniform pure state of n qudits has finite product-symmetry group modulo
  global phase — no stabilizer hypothesis. Proof is a two-line second-moment identity against
  maximally mixed pair marginals. Locally we have the finiteness statement only for equal-phase
  MDS--CSS states, derived through the Weyl-axis machinery (snapshot §"Consequences"). The
  entanglement-only version, which also covers non-stabilizer AME states, is new.
- **Theorem B.** Explicit local stability: defect eps bounds generator size by sqrt(6q/5)·eps,
  with the constant **independent of the number of parties**. Locally, C581 gives a quantitative
  bound 2sqrt(2)q^2·eps but only for `[6,3,4]_q` MDS--CSS pairs, and it was closed without
  manuscript adoption. The n-independent 2-uniform constant is new and is a different mechanism.
- **Proposition C.** Quantum Fisher information of local generators is exactly isotropic on
  2-uniform states, giving a rigidity/metrology complementarity with Bell and GHZ as the two
  degenerate extremes. No local counterpart anywhere.
- **Corollary D.** Local gauge group of any 2-unitary (dual-unitary) gate is finite mod phase and
  inherits Theorem B. No local counterpart.
- Numerics on AME(4,3) at machine precision, plus a GHZ control.

Relation to what we already knew: `notes/2026-07-25-ame-lu-two-cold-read-frontier.md` item 6 lists
"approximate rigidity and self-testing" as an unexecuted frontier idea. The zip executes it.

### 2. `diagonal_rigidity_phase_boundary.md`

Nothing in this file has a local counterpart. Grep for "triply-even", "Schur cube", "lift lattice"
across `notes/`, `papers/`, `lean/` returns nothing in this sense.

- **Theorem 1.** Complete classification of diagonal product symmetries of a CSS coset state by the
  Smith normal form of the lift lattice; polynomial-time decidable "all diagonal symmetries are
  Clifford" test.
- **Theorem 2.** One-hypothesis rigidity criterion: if the third Schur power of the code is
  everything, every diagonal symmetry is Clifford of level at most 2. Kills continuous, odd-torsion,
  and high 2-power symmetries at once.
- **Theorem 3.** Exact order-8 existence criterion; triply-even codes carry transversal T.
- **Theorem 4.** Explicit non-rigid family with an exact non-Clifford transversal-T symmetry,
  verified at n = 16. **The family as stated in the zip is wrong.** It gives RM(r,4r) and uniformity
  growing like 2n^{1/4}; the correct threshold is m at least 3r+1, so the family is RM(r,3r+1),
  uniformity grows like 2^{2/3}n^{1/3}, and the first staircase point past 16 is length 128 rather
  than 256. Corrected later in the same external programme and verified locally; see
  `2026-08-01-c778-strip-certificates/PROVENANCE.md`.
- **Corollary.** For MDS input at rate at least 1/3 the Schur cube saturates, so the diagonal
  sector of AME rigidity follows from Schur-power growth — a mechanism explanation for the theorem
  we already have by Weyl-axis argument. Qudit case stated conditionally.

Caveats the file states itself: the reduction from general product symmetries to the diagonal
sector is imported, not proved; the odd-torsion step of Theorem 2 is written twice, and only the
localization version is sound (the determinant detour is explicitly retained as a wrong-turn
record); a novelty audit against Cui--Gottesman--Krishna 2017 and the CSS-T literature is mandatory
before any firstness claim.

### 3. `rigidity_boundary_three_promotions.md`

Also absent locally in full.

- **Theorem 1.5.** Exact-rational Delsarte certificates prove no triply-even binary code with dual
  distance at least 5 exists for lengths 9--69 and 75--80, so the transversal-T rigidity boundary is
  flat at uniformity 3 there. Certified with exact simplex and, independently for n at most 56,
  Fourier--Motzkin; a floating-point LP failed its sanity battery and was discarded. The simplex
  script was recovered and this boundary reproduced locally on 2026-08-01. With the corrected
  staircase family the open strip is lengths 70--74 **and** 81--124; the zip's single-window
  statement assumed the wrong family. The LP loses its killing power by length 88, so 81--124 cannot
  be closed by this method.
- **Propositions 1.1--1.4.** Triply-even implies self-orthogonal; a basis criterion (singles mod 8,
  pairs mod 4, triples mod 2); a finite-geometry reformulation as a cap/Sidon problem with a
  Walsh-mod-16 constraint; a repaired Sidon dimension bound.
- **Lemma 2.0 and Theorems 2.1--2.2.** Qudit sectors for odd p at least 5: full Schur powers force
  diagonal phases to be quadratic (excluding Howard--Vala cubic T), and lift-linear level-p^ell
  symmetries collapse to Z-Paulis. Corollary 2.3 rederives the diagonal part of qudit AME rigidity
  at mechanism level. p = 3 is open; the general p-power sector is open with an augmentation-filtration
  roadmap (Lemma 2.4).
- **Theorem 3.2.** Semi-Clifford torsor reduction: since every single-qudit hierarchy gate is
  semi-Clifford (de Silva--Lautsch 2025), the whole sector of product symmetries with hierarchy
  local factors reduces to the diagonal classification across the finite local-Clifford orbit. This
  converts the "diagonal-only" caveat into "hierarchy-factor sector".
- Correction log for the session: float-LP discard, Sidon-bound repair, two Phase-I implementation
  bugs, and vacuity of an earlier randomized search.

The verification scripts named in that file (`strip_search.py`, `strip_exact2.py`,
`strip_simplex.py`, `strip_sub.py`, `scan_range.py`, and others under `/home/claude/`) are **not in
the zip and not in this repository**. Under
`notes/research-reproducibility-conventions.md`, Theorem 1.5 currently has no admissible evidence
bundle here: the certificates cannot be replayed and the Farkas duals were listed as a to-do, not
produced.

## `~/tmp/chat-session-files/`

A different programme, also absent locally. `unified_research_report_revision3.md` is a corrected
apolarity/Gorenstein note — residual comultiplication adjoint to mu_{i,j}, a stabilization
equivalence between the residual class, the quotient dimension jump, and the ideal degree piece,
plus an information-geometry layer (affine moment fibres, maximum-entropy projections, KL
decomposition, Fisher realization of residual classes) with two earlier efficiency claims
explicitly withdrawn.

The accompanying `relationtracker3.py`, `rt3_ablation.py`, `tree_longrange_benchmark*.py`,
`noisy_structure_benchmark.py` and the AUROC CSVs are a machine-learning benchmark suite testing
whether Schur-growth and continuation-Hankel signatures detect composition structure in tree and
point-cloud streams, with an ablation separating the multiplication law from graded dimension and
layer spectra.

Locally, Gorenstein and apolarity machinery exists in the `clebsch` lane, and
`notes/2026-07-12-riffing-on-applications.md` brainstorms representation-learning benchmarks, but
neither the corrected algebra of this report nor any of the benchmark code or results exists here.
Note that the `continuation` lane in this repository is about projective four-point-frame
continuation graphs, unrelated to the continuation-Hankel stream algebra of these scripts.

## Related

Cross-lane fusion proposals from the same external correspondence, with their premises checked
locally, are in `2026-08-01-cross-lane-fusion-candidates.md`. Recovered
verification scripts, their replays, and the defects found in the source session's own correction log
are in `2026-08-01-c778-strip-certificates/PROVENANCE.md`.

## Disposition

1. The three zip notes belong to `ame-lu`, not `golden`. Importing them needs allocated `ame-lu`
   task IDs; they are outside the current `golden` allowed paths.
2. Theorem A and Proposition C are cheap and self-contained; they are the strongest immediate
   upgrade to the AME manuscript (classification plus stability).
3. Theorem 1.5 cannot be cited until the strip scripts are recovered or rewritten here and a
   certificate bundle with Farkas duals is committed.
4. Three novelty audits are prerequisites, per the files themselves: Cui--Gottesman--Krishna 2017,
   the CSS-T / generalized-triorthogonality line (Rengaswamy--Calderbank--Pfister), and
   Gross--Van den Nest (QIC 2008) for the diagonal reduction of LU-LC.
5. The apolarity/information-geometry report and its benchmark suite have no owning lane here.
