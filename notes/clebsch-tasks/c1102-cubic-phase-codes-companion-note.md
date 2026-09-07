# C1102 — Companion note: strength-two trades, transversal cubic gates, and the magic of the Clebsch codes

**Lane:** clebsch (research-only spinoff track; successor of C1090 and C1099)

**Date:** 2026-09-07

**Status:** first 11-page draft exists at `papers/clebsch-cubic-phase/companion.pdf`;
local source, finite and PDF checks pass. Gate 1 passed with the explicitly
approved Crossref coverage exception. Active for manuscript review and packaging.
Draft report: `notes/2026-09-07-c1102-companion-draft.md`.
Citation dispositions are banked in
`notes/2026-09-07-c1102-forward-citations/ADJUDICATION.md`: all 336 promotions have
explicit dispositions, with 20 additional partial primary readings. This is not
336 full-text exclusions. The canonical pre-draft verdicts are rows N1–N9 of
`notes/2026-09-07-c1102-forward-citations/CLAIM-PROOF-NOVELTY.md`; they supersede
the historical C1090/C1099 positioning. Alltop/Wang–Li/Dai–Fu–Luo access is resolved.
Feng–Luo `10.1088/1402-4896/ad80e7` is now read at full text from user scans
of all nine published pages; all promoted primary-access gaps are resolved.
The user confirmed that the added Hessian source is preprint-only and approved
recording Crossref as not covered, retaining the OpenAlex/Semantic Scholar zeros
without a three-source absence verdict. Scope and restrictions are recorded in
`notes/2026-09-07-c1102-forward-citations/gate-approval.json` and `GATE-DECISION.md`.
Next: critical manuscript review, then standalone artifact packaging and author
metadata decisions. No publication or mirror synchronization has occurred.

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

## Gate 1 — forward-citation closure (passed with approved exception)

Per `notes/literature-audit-conventions.md`, with OpenAlex, Crossref, and Semantic Scholar
(three sources for every negative): Haah 2018 (PRA 97, 042327), Campbell–Howard 2017 (PRA 95,
022316), Krishna–Tillich 2019, Prakash–Saha 2025, Campbell–Anwar–Browne 2012, and the
stabilizer Rényi entropy line (Leone–Oliviero–Hamma 2022; qudit definition Wang–Li, QIP 22,
444 (2023)). Resume from the C1102 audit report above; the earlier
`notes/2026-09-07-c1099-lit-check-magic-of-phase-states.md`
found: Kagamihara–Tsuchiya (arXiv:2602.23687) for the `p = 2` Hessian-rank formula, Alltop
1980 / Klappenecker–Rötteler 2004 for the trace-cubic state as a MUB fiducial, and Knipfer
et al. (arXiv:2607.07197) for the conjectured maximum `log(D^2/(2D-1))` that the trace cubic
attains for two qudits. Its broader attribution for arbitrary numbers of qudits is not
supported by that source. The C1102 report owns the updated access/read-depth gaps. Record every
consulted source; produce verdict lines for: the general signed-moment CSS mechanism, the
`[[2p, p-1, 2]]_p` translation-trade family, the conic trades at p = 7, 11, 13, the
invariant-theoretic phase, the Hessian-rank formula for stabilizer Rényi entropies of diagonal
cubic phase states, and the bipartition product-exclusion argument.

## Approved crisp structure and bounded benchmark

The user's upgrade instruction admits the bounded p=7 same-target factory comparison.
`notes/2026-09-07-c1102-factory-benchmark/REPORT.md` and its replay bundle establish
native expected consumption below 16.116 for 0 < delta <= 0.01, against lower bounds
54 for the specified sign-only separate-distiller menu and 36 in its weighted
relaxation. The rank bracket suffices; no exact-rank search is a prerequisite.
These are menu-specific comparisons, not unrestricted protocol lower bounds.

Use four main steps after Gate 1: signed-trade construction and logical cubic;
Hessian spectrum and geometric product exclusions (credit the prior ceiling method);
one bounded factory theorem/table; one compact Paper V shadow/torsor proposition.
Move detailed classifications, enumerators and exhaustion to appendices/artifacts.

## Supporting contents once the gate passes (from C1099 section 4)

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
   apolarity is the compilation problem; state it explicitly and tie it to Paper II's Macaulay
   inverse-system cubic. Cite the direct qudit predecessor Heyfron–Campbell
   arXiv:1902.05634, IV, Eqs. (8)–(9), Lemma 2 and Problem 3 (ledger N7).
   The optional deep-hole/ Reed–Solomon-lane apolarity citation remains unverified and unused;
   it is not needed to establish this already-published synthesis bridge.

Title and alias proposals (2026-09-07; author's call, not yet decided):

- **Recommended:** *Strength-two trades and transversal cubic gates: the Clebsch cubic-phase
  codes and their magic*. Directory `papers/clebsch-cubic-phase/`; spoken alias `cubic-phase`.
  Reasons: "strength-two trade" is Paper II's and the literature's term; "transversal cubic
  gates" and "cubic-phase" are the standard quantum names; "magic" is safe in a title (lit
  check, stabilizer Rényi entropy in the abstract); it does not say "coupled" (only true for
  p = 11 and two non-Clebsch trades at p = 7), "exceptional codes" (the family exists for every
  prime), or "invariant gate" (one section). The `clebsch-` prefix matches `clebsch-rigidity`,
  `clebsch-factorization`, `clebsch-passages` and carries no Roman numeral (C919: only the five
  numbered papers do). The directory name still fits if C1102 is later re-pegged to
  `quantum-codes`.
- Alternative 1: *Quadratic trades as certificates for coupled cubic-phase quantum resources*
  (Astra's working title). Cons: "coupled" is weakened by C1099; "certificates" undersells the
  family and magic results.
- Alternative 2: *Transversal cubic gates from conic matchings*. Cons: hides the all-primes
  translation family and the magic theorem.

## Framing notes from Sol's 2026-09-07 assessment (adopted where C1099 confirms them)

- Separate three claims in the note: mathematical significance (invariant-theoretic logical
  gate; genuinely multipartite Clifford resource class), code significance (a new
  exceptional-geometric *source* of structured transversal gates, not a new mechanism; the
  mechanism is generalized triorthogonality, Campbell–Anwar–Browne / Bravyi–Haah), and
  practical usefulness (unproven). Describe the codes as high-rate error-detecting resource
  factories, never as good error-correcting codes.
- The practical criterion is the ratio "noisy cubic resources consumed per accepted block"
  over "optimal elementary cubic cost of `U_F`". C1090's bracket `9 ≤ r(F_7) ≤ 13` puts the
  denominator between 9 and 13 against 14 consumed, but equal-error comparison must also price primitive purification. The approved
  C1102 bounded benchmark above resolves that menu-specific comparison without exact rank.
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
  `[[13,4,3]]_13`) is exactly its `a = 2` row. Cite Campbell 2014 (arXiv:1406.3055) as
  related punctured polynomial-code precedent: its physical length is `p-1` and its
  maximum distance is `floor((p+1)/3)`, not the formerly attributed length-p formula.
  The C1099 length-p table retains its own proof. Present the design space as Sol's four axes
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
  weighted Waring ranks of `F_7`, `F_11` and unrestricted synthillation benchmarks beyond the approved bounded menu; the invariant-gate cubature
  search (signed configurations whose first surviving moment is `det_3`, the `6×6` Pfaffian,
  the `E_6` Cartan cubic, or the trace cubic of ledger item 1).

## Placement against the portfolio's other transversal-gate results (checked 2026-09-07)

- *Diagonal Isoduality and Transversal Clifford Groups of MDS–CSS Codes*
  (`papers/mds_css_transversal_groups/`, `ame-lu` lane): its abstract already states that the
  codimension of the Schur square determines all transversal logical unitaries and that AME
  rigidity excludes non-Clifford product implementations. The note must place the trade codes
  against it with the correct parameter: both regimes have Schur-square codimension one; what
  differs is the X-stabilizer (`<1>` against `C^⊥`) tested against the Schur cube
  `S_X ∘ L ∘ L`. Cite it as the Clifford end of one parameter, `dim S_X`; do not claim a new
  algebra.
- The `ame-lu` handoff's dual-distance dictionary (finite diagonal symmetry groups of CSS coset
  states carrying a non-Clifford order-eight element; projective triply-even codes) is the
  qubit analogue of memo Proposition 3 / section 6.1 (all position-dependent diagonal cubic
  phases preserving the code are `w ∈ (L^{∘2})^⊥`). Cite it; the qudit cubic statement is the
  same dictionary one degree up.
- The `quantum-codes` lane (`notes/handoffs/2026-08-25-quantum-codes.md`) is the portfolio's
  designated home for cross-lane code and gate work consuming geometric results; C1102 is
  pegged `clebsch` because the note is a Clebsch companion. Re-pegging is the user's call, not
  this card's.

## Paper V identification (settled 2026-09-07, for the note and for Paper V's hand-back)

`notes/2026-09-07-c1099-logical-cubic-vs-paper-v-cubics.md`: the p = 11 logical cubic
restricted to the unique five-dimensional `A_5`-summand of the logical space is a chordal
member of Paper V's pencil (`8·det Hankel`, singular along the twelve-point rational normal
quartic), never the conference member; at p = 7 the `s = 0` restriction is `3·det Hankel`.
Global negation is `U_F ↔ U_F^{-1}`; the residual chordal-line torsor swaps the two chordal
members, which are Clifford-equivalent via `q`, so it is a Clifford frame change on the five
shadow directions. Only the identity-on-complement extension and geometric lifts have
been ruled out; arbitrary full-gate lifts remain open. The note states the established part as a proposition
with the Hessian-census separation `(1,120,27720,133210)` vs `(1,300,22260,138490)`.
Hand-back candidate for Paper V (its owner's call, needs a forward release): one sentence
giving the two torsors their operational reading (gate inversion; logical frame change),
scoped to the verified finite-field shadow. Do not claim general non-liftability or identify
the twelve rational singular points with the entire singular scheme. No Paper V manuscript
or forward release occurs before the companion exists and its gates pass.

## Hand-back once the note exists

- Series coda (programme map, shared apparatus per C919): one sentence adding the
  companion note as a further shadow of the exceptional carrier, phrased as "the
  `PGL_2`-symmetric, near-Pauli-flat member of the transversal-cubic family with an
  invariant-theoretic logical phase" (not "a transversal cubic", which every prime has). Ride
  the next forward release of the series; no Paper I edit for this alone. The p = 11
  statement is the stronger one (`|F_11>` clears every bipartition product bound).

## Boundaries

- No Paper II manuscript or Lean edit; the note is unnumbered and outside the series standard.
- No hardware or commercial claim.
- Computational claims cite the committed C1090/C1099 bundles with their replay commands.
