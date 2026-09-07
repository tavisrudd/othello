# C1102 — Companion note: strength-two trades, transversal cubic gates, and the magic of the Clebsch codes

**Lane:** clebsch (research-only spinoff track; successor of C1090 and C1099)

**Date:** 2026-09-07

**Status:** queued; writing task; the first gate is forward-citation closure, and no manuscript
text is written before it passes

## Read first (in this order, nothing else)

1. `notes/clebsch-tasks/c1090-cubic-phase-codes.md` — the results table, novelty verdicts, and
   the user's decision (b): a standalone unnumbered companion note.
2. `notes/2026-09-07-c1099-cubic-phase-strengthening/REPORT.md` — the three strengthening
   tests, the category decision, the recommended contents (section 4), and the mystery ledger.
3. `notes/2026-09-07-c1090-resource-classification/REPORT.md` — Pauli spectra, extremal locus,
   Waring bracket.
4. `notes/2026-09-07-c1090-literature-cubic-phase-codes.md` — the priority search and the
   verdict lines it must extend.
5. `notes/literature-audit-conventions.md` and, before any manuscript text,
   `papers/style-guide.md` — both routed reads.

## Gate 1 — forward-citation closure (must pass before any draft)

Per `notes/literature-audit-conventions.md`, with OpenAlex, Crossref, and Semantic Scholar
(three sources for every negative): Haah 2018 (PRA 97, 042327), Campbell–Howard 2017 (PRA 95,
022316), Krishna–Tillich 2019, Prakash–Saha 2025, Campbell–Anwar–Browne 2012, and the
stabilizer Rényi entropy line (Leone–Oliviero–Hamma 2022; qudit definition Wang–Li, QIP 22,
444 (2023)). Start from `notes/2026-09-07-c1099-lit-check-magic-of-phase-states.md`, which
found: Kagamihara–Tsuchiya (arXiv:2602.23687) for the `p = 2` Hessian-rank formula, Alltop
1980 / Klappenecker–Rötteler 2004 for the trace-cubic state as a MUB fiducial, and Knipfer
et al. (arXiv:2607.07197) for the conjectured maximum `log(D^2/(2D-1))` that the trace cubic
attains; its gaps (nothing read at full text, primaries not obtained, no forward-citation run)
are this gate's first work items. Record every
consulted source; produce verdict lines for: the general signed-moment CSS mechanism, the
`[[2p, p-1, 2]]_p` translation-trade family, the conic trades at p = 7, 11, 13, the
invariant-theoretic phase, the Hessian-rank formula for stabilizer Rényi entropies of diagonal
cubic phase states, and the bipartition product-exclusion argument.

## Contents once the gate passes (from C1099 section 4)

1. trade-to-code dictionary; general existence (translation trade, every prime p ≥ 5);
   rigidity `dim L^{∘2} = 2p - 1` for every member found;
2. the magic theorem (`M_α` from the Hessian-rank distribution), exact values, product and CCZ
   comparison, bipartition exclusion for `|F_11>` and the two non-Clebsch p = 7 conic trades,
   the trace-cubic caveat;
3. classification of the conic-matching source up to p = 17 (translation-class pairs and
   orbit pairs), the new `[[26, 12, 2]]_13`, stabilizers and censuses;
4. exhaustive distance-three negative at p = 7 and the Reed–Solomon benchmark;
5. Waring bracket and the factory with exact enumerators (C1090).
6. the synthesis bridge (memo section 9.1, currently only implicit in C1090): a Waring
   decomposition `F = Σ c_j ℓ_j^3` is a circuit (Clifford computes `ℓ_j`, weighted cubic
   phase, uncompute), so the Waring rank is a non-Clifford gate count in that model and
   apolarity is the compilation problem; state it explicitly, tie it to Paper II's Macaulay
   inverse-system cubic, and cite the apolarity/decomposition machinery of the deep-hole
   (Reed–Solomon lane) work only after checking that it actually uses apolarity (the lane
   handoff does not mention it; unverified as of 2026-09-07).

Title candidates (author's call): *Strength-two trades, transversal cubic gates, and the magic
of the Clebsch codes*; *Quadratic trades as certificates for coupled cubic-phase quantum
resources*.

## Boundaries

- No Paper II manuscript or Lean edit; the note is unnumbered and outside the series standard.
- No hardware or commercial claim.
- Computational claims cite the committed C1090/C1099 bundles with their replay commands.
