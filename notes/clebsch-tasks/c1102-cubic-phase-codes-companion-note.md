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

## Framing notes from Sol's 2026-09-07 assessment (adopted where C1099 confirms them)

- Separate three claims in the note: mathematical significance (invariant-theoretic logical
  gate; genuinely multipartite Clifford resource class), code significance (a new
  exceptional-geometric *source* of structured transversal gates, not a new mechanism; the
  mechanism is generalized triorthogonality, Campbell–Anwar–Browne / Bravyi–Haah), and
  practical usefulness (unproven). Describe the codes as high-rate error-detecting resource
  factories, never as good error-correcting codes.
- The practical criterion is the ratio "noisy cubic resources consumed per accepted block"
  over "optimal elementary cubic cost of `U_F`". C1090's bracket `9 ≤ r(F_7) ≤ 13` puts the
  denominator between 9 and 13 against 14 consumed, so no advantage is demonstrable until the
  exact weighted Waring rank is known; state this plainly as the open practical question.
- C1099 corrects two of Sol's expectations: rigidity `rad T|_L = <1>` is generic (every trade
  found has it, including the trivial translation trade), so the programme question is "which
  `L`", not "larger radical"; and the controlled-quadratic lead `sQ(z)` is realized trivially by
  the translation trade's logical cubic `-3 (t·u) q(u)`, the least magic member, so it is not a
  Clebsch feature.
- The general principle should be stated with the sign character, not invariants: for a
  signed `G`-orbit with sheet character `χ`, the moment `μ_j` lies in the `χ`-isotypic part of
  `Sym^j`, so `(Sym^j V)_χ = 0` for `j < t` forces a level-`t` gate; `(Sym^j V^*)^G = 0` is the
  wrong condition (the translation trade has no group forcing at all). C1099's data for this
  programme: `PGL_2(p)`-orbit pairs never give `t = 3`, translation-class pairs do at
  `p = 7, 11, 13` only, and strength-three orbit pairs at `p = 11, 13` are `t = 4` candidates.
- Citations to verify at the gate (from Sol, unverified): Bravyi–Haah PRA 86, 052329;
  Campbell–Anwar–Browne PRX 2, 041021; arXiv:2512.21874 (asymptotically good qudit
  distillation codes, `[[42,14,6]]_64`); the 2026 punctured Reed–Muller sublogarithmic-overhead
  work.

## Sol's second and third assessments (2026-09-07), checked against C1099

- Sol's weighted-evaluation theorem (Lagrange weights `w_i = 1/P'(α_i)`, `S = RS_{s_0+1}`,
  `L = RS_{r+1}`, `s_0 + 2r ≤ n - 2`, giving `[[n, 3r-n+2, min(n-r, n-2r)]]_q`) is the
  mechanism of C1099 Test 3(c); the C1099 table (`[[7,1,3]]_7`, `[[11,3,3]]_11`,
  `[[13,4,3]]_13`) is exactly its `a = 2` row. Cite Campbell 2014 (arXiv:1406.3055) for the
  `[[p,1,(p+2)/3]]_p` case. Present the design space as Sol's four axes
  `(dim S, d_X, d_Z, complexity of F̄)`: Reed–Solomon wins the first three with a trivial cubic,
  the conic trades win the fourth with `d_Z = 2`.
- The "missing middle ground" (`d ≥ 3`, `k > 1`, non-factorizable invariant cubic) is open on
  both sides: inside the Clebsch `L` at p = 7 it does not exist (Test 2), and the
  distance-three Reed–Solomon cubics have `r_min = 1` and `M_2` below the bipartition product
  bound (`test3c_rs_magic.py`: `5.878 < 5.903` at p = 11, `8.714 < 8.948` at p = 13), so they are
  not certified multipartite. State this as the open problem, not as a result.
- Paper II's abstract: Sol's proposed upgrade "exactly two orbits produce the canonical
  transversal cubic-phase construction" is **false as stated** after C1099. Paper II's
  exactness is about full `PGL_2(q)` matching orbits split by `PSL_2(q)`; the transversal
  cubic itself is produced by other translation-class pairs at p = 7, 11, 13 and by a trivial
  configuration at every prime. Any quantum sentence added to Paper II must say "the two
  exceptional orbits are the `PGL_2`-symmetric members of the family", and the decision
  stands: companion note, not a Paper II section (Sol also leans companion).
- Kalra–Prakash, *Invariant Theory, Magic State Distillation, and Bounds on Classical Codes*
  (INSPIRE 2870314): invariant theory of weight enumerators; the note must distinguish
  "invariant as the logical phase" from that explicitly. Add to the gate list, with
  Nguyen (arXiv:2408.10140), He–Vaikuntanathan–Wills–Zhang (arXiv:2502.01864),
  arXiv:2507.05392, and the constant-overhead distillation paper (Nature Physics 2025) as
  the state of the distance side, so the note does not claim the distance direction.
- Not for this note (candidate successor tasks, unallocated): exact and Clifford-aware
  weighted Waring ranks of `F_7`, `F_11` and a fair synthillation benchmark (one block versus
  distill-primitives-then-synthesize at equal target error); the invariant-gate cubature
  search (signed configurations whose first surviving moment is `det_3`, the `6×6` Pfaffian,
  the `E_6` Cartan cubic, or the trace cubic of ledger item 1).

## Boundaries

- No Paper II manuscript or Lean edit; the note is unnumbered and outside the series standard.
- No hardware or commercial claim.
- Computational claims cite the committed C1090/C1099 bundles with their replay commands.
