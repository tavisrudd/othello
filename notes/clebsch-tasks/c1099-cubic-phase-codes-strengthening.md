# C1099 — Cubic-phase codes: three strengthening tests, then the companion-note decision

**Lane:** clebsch (research-only spinoff track; successor of C1090)

**Date:** 2026-09-07

**Status:** queued; self-contained for a fresh session

## Read first (in this order, nothing else)

1. `notes/clebsch-tasks/c1090-cubic-phase-codes.md` — the results table, the novelty verdicts,
   and the recommendation the user accepted on 2026-09-07: option (b), a standalone unnumbered
   companion note, working title *Quadratic trades as certificates for coupled cubic-phase
   quantum resources*.
2. `notes/2026-09-07-c1090-resource-classification/REPORT.md` — exact Pauli-spectrum
   censuses for `p = 7` (all of `F_7^6`) and `p = 11` (all projective points, Rust + rayon),
   the rational-normal-curve extremal locus, and the Waring bracket `9 ≤ r(F_7) ≤ 13`,
   `15 ≤ r(F_11) ≤ 21`.  Scripts `check1.py`–`check6.py` and the Rust census `rank11/` are
   beside it; `common.py` in `notes/2026-09-06-clebsch-quantum-replay/` holds the transcribed
   matrices `E_7`, `E_11`, sign vector, and cubics.
3. `notes/2026-09-06-clebsch-quantum-replay/astra-bundle/clebsch_quantum_research_memo.md`
   §9.2 (restricted evaluation spaces) and §9.3 (higher moments), the only parts of the memo
   this task extends.
4. Paper II source `papers/clebsch-factorization/clebsch_factorization.tex` §3 (base matchings,
   equation (3.1)) and §4 (moment identities, Gorenstein section) — read only those sections.

Do not reread the literature note or the Astra review unless a test needs a citation.

## Why this task exists

The user's question was whether the companion note would be strong.  Assessment recorded in
C1090: as it stands it is a correct short certificate note; distance two is not an advance.
Three cheap tests decide whether it becomes a strong paper.  Run all three, then decide the
note's title and category from the outcome.

## Test 1 — magic content (free from existing data)

From the exact Pauli-spectrum histograms already computed, calculate the stabilizer Rényi
entropies `M_α` (α = 2 and the linear/`α → ∞` versions) of `|F_7>` and `|F_11>`, and the same
for the two comparison resources at equal qudit count: `p − 1` independent cubic-phase qudits
`|M>^{⊗(p−1)}`, and disjoint three-qudit CCZ-type phases where `3 | (p − 1)` (`p = 7` only;
for `p = 11` use three CCZ blocks plus one cubic-phase qudit, and say so).  Use
`M_α = (1 − α)^{−1} log( p^{−k} Σ_P |<P>|^{2α} )` with the sum over all `p^{2k}` Paulis
(check the normalization by reproducing the known single-qudit cubic-phase value).  Report
per-qudit magic.  Verdict: does the coupled resource carry strictly more stabilizer Rényi
magic per qudit than the product resources?  If yes, that is the headline theorem; state it
with the exact rational values.  If no, record the numbers and drop the "coupled resource"
framing from the note.

## Test 2 — a distance-three member at p = 7

Implement the memo's §9.2 search exactly: evaluation subspaces `L' ⊆ L` with `1 ∈ L'` and
`dim L' ≥ 3`, X-spaces `S ⊆ L'` with `1 ∈ S` and `T(S, L', L') = 0` for the trilinear form
`T(v,w,z) = Σ ε_i v_i w_i z_i`, CSS code with X-space `S` and Z-space `L'^⊥`, logical count
`k' = dim L' − dim S`, distances `d_X' = min wt(L' \ S)`, `d_Z' = min wt(S^⊥ \ L'^⊥)`, and a
nonzero logical cubic.  At `p = 7`, `L` has dimension 7 over `F_7`, so the subspace lattice
is small enough to enumerate `L'` up to the `PGL_2(7)` symmetry (use the orbit machinery from
`check5.py`); for each `L'` the admissible `S` form a linear condition, so the search is
exact.  Report every `(n, k', d')` with `d' ≥ 3` and a nonzero logical cubic, with the
subspaces as certificates; if none exists, state the exhaustive negative with the exact
searched domain.  Do not treat "pairwise nonproportional columns" as distance three (memo
§9.2 caveat); check degeneracy exactly.  Rust if the enumeration exceeds a few minutes in
Python; target dir under `~/.cache/ergodis/`, never inside `notes/`.

## Test 3 — is there a family beyond p = 7, 11?

The construction needs a `2p`-point configuration with sheet signs such that the signed
moments of orders 0, 1, 2 vanish and order 3 does not, equivalently an affine evaluation
space `L ∋ 1` that is Lagrangian for the signed form with `L^{∘2} = ε^⊥`.  Paper II proves
that the *conic-matching* source of such configurations is exceptional (`p = 7, 11`).  Test
whether the *code-theoretic* condition has other solutions:

(a) for `p ∈ {5, 7, 11, 13, 17, 19, 23}`, search pairs of `PGL_2(p)`-orbits of perfect
matchings of the conic (or of any two orbits of size `p` under a fixed subgroup) for vanishing
signed moments of orders 1 and 2 with nonzero order 3, using the memo's reconstruction
recipe; report every hit;
(b) independently of conics, search small `n = 2p` signed configurations in `F_p^{p−1}` with
a transitive symmetry (e.g., `AGL(1,p)` or dihedral orbits) satisfying the same moment
conditions;
(c) the general mechanism (memo §9.3): any `L ∋ 1` with `w ⊥ L^{∘(r−1)}`, `w ⊥̸ L^{∘r}`
gives a degree-`r` transversal phase; check whether Reed–Solomon/GRS evaluation spaces with
signed weights already realize `r = 3` with `k > 1` at these lengths (this is the
weighted-triorthogonal comparison Haah 2018 flags open for qudits).

Verdict: family / isolated pair / the code condition is strictly weaker than the geometric
one (and by how much).  If the pair is isolated, say precisely which of the three conditions
fails for every other prime tested.

## Decision and hand-back

Record in this card: for each test, the exact result and its certificate location; then the
note's category — strong construction paper (any hit in Test 2 or 3, or a magic theorem from
Test 1), or short certificate note — and the resulting title.  Then allocate the writing
task separately, with forward-citation closure on Haah 2018, Campbell–Howard 2017,
Krishna–Tillich 2019, and Prakash–Saha 2025 as its first gate.  No Paper II manuscript or Lean
edit in this task.

## Boundaries

- Research and computation only; committed certificates under a dated
  `notes/2026-MM-DD-c1099-…/` directory with replay commands.
- No hardware or commercial claim; no manuscript text.
- Report on disk at every stop; commit validated work before any long build.
