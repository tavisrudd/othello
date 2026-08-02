# C776 — Adoption of the 2-uniform rigidity results into `papers/ame_lu`

**Lane**: `ame-lu`. **Date**: 2026-08-01. **Status**: COMPLETE (draft integration; the cold read owns the final scope decision).

Scope: draft integration only. The cold read owns the final scope decision. Allowed paths:
`papers/ame_lu/**` and this report stem.

Inputs read in full: `2026-08-01-c776-scope-fable-review.md`,
`2026-08-01-c774-two-uniform-rigidity-red-team.md`,
`2026-08-01-c775-two-uniform-rigidity-literature-audit.md`,
`2026-08-01-external-session-notes/approximate_rigidity_of_2uniform_states.md` and that
directory's `README.md`, `2026-07-24-c581-phase-space-robust-rigidity.md`,
`2026-08-01-external-source-numerics.md`, `papers/style-guide.md`,
`notes/research-reproducibility-conventions.md`, and the manuscript
(`main.tex`, all section files, `theorem-map.md`, `claim-proof-novelty-ledger.md`,
`formalization-ledger.md`, `verification-map.md`).

## 1. What was adopted

Everything lands in one new subsection of Section 3,
`\subsection{Discreteness and quantitative stability}` (label `sec:two-uniform`), placed after the
encoder subsection and containing the existing `cor:discrete-lu-symmetry`, which now reads as the
stabilizer specialization of the new discreteness theorem.

| Manuscript item | Label | Source | Notes |
|---|---|---|---|
| Second-moment identity, polarized isometry form | `lem:local-generator-isometry`, eq. `(3.12)` | source note (★), strengthened by C774 §1 | stated as an isometry, per C774 |
| Summed local form of a one-parameter generator | `lem:product-lie`, eq. `(3.13)` | C774 §2 repair (Lemma A0) | Cartan closed-subgroup argument written out |
| Discreteness from 2-uniformity | `thm:two-uniform-discrete` | Theorem A | any integer `q ≥ 2`, `n ≥ 4` |
| Which torus is divided out | `rem:local-phase-torus` | C774 §2 bookkeeping point | `PU(q)^n`, not one global phase |
| Prior-art concession and the 1-uniform contrast | `rem:discreteness-prior-art` | C775 | Wirthmüller, Tan, Słowik--Sawicki--Maciążek, GIT framing |
| RM(1,4) boundary: finite but not Clifford | `rem:two-uniform-not-clifford` | scope review `ej` item 1 | self-contained proof, no certificate needed |
| Two-sided local stability | `thm:two-uniform-stability`, eq. `(3.14)` | Theorem B, two-sided form from C774 §3.1 | "sharp to within about ten percent" |
| Fisher isotropy | `rem:fisher-isotropy` | Proposition C | remark with citations, no firstness |
| Region shrinkage | `prop:stability-region` | C774 §3.2 | closed-form Reed--Muller family, proved not computed |
| Decomposition below threshold | `cor:approximate-decomposition` | Corollary B′, repaired per C774 §3.3 | minimal-lift hypothesis in the statement, split proof |
| Quantitative diagonal axes | `lem:quantitative-axes` | C581 §1 | |
| Two-state intertwiner bound | `prop:quantitative-intertwiner`, eq. `(3.16)` | C581 §2--3 | explicit threshold `τ_p` |
| 2-unitary gauge groups | `cor:two-unitary-gauge` | Corollary D, repaired per C774 §4.2 | isometric isomorphism stated; "modulo the local phases"; inherited hypotheses |

Held, as instructed: the metrology exposition, the complementarity narrative, the certification
protocol, and every self-testing framing.

### C774 repairs, each applied

1. **Lie-homomorphism lemma.** `lem:product-lie` proves the image of the product map is a closed
   subgroup with the summed-local Lie algebra, so the discreteness proof no longer assumes the
   generator's form.
2. **Minimal-lift hypothesis.** `cor:approximate-decomposition` carries
   `Σ_j ‖h_j‖_op ≤ 1/2` into its conclusion, and the manuscript exhibits the `q = 2`,
   `h_j = π·diag(1,−1)` counterexample that makes the hypothesis necessary.
3. **Split proof.** Quadratic growth (Theorem B plus right invariance) and isolation-plus-compactness
   are separate paragraphs, and the Hessian language is dropped in favour of the convention-free
   inequality. The text states that the existence half needs no stabilizer hypothesis and that
   finiteness of the zero set follows from `(3.12)` rather than being an extra input.
4. **Gauge corollary.** Stated as an isometric group isomorphism with the transposition and complex
   conjugation written out, "modulo the local phases", inherited hypothesis
   `Σ_j ‖h_j‖_op ≤ 1/2`, and an explicitly non-explicit `ε₀(W)`; vacuous at `q = 2`.
5. **Isometry form of `(3.12)`.** Adopted, with the imaginary part shown to vanish.
6. **Sharpness wording.** "sharp to within about ten percent", supported by the two-sided estimate
   `(3.14)` rather than by a numerical table.

### The party-count constraint

The manuscript never claims party-count-independent certification. The two facts appear in the same
breath in the abstract, in the introduction, and in the paragraph after `prop:stability-region`:
the ratio constant `√(6q/5)` is independent of the party count, and the certified neighbourhood
shrinks like the inverse square root of it, at a rate an explicit family attains. The word
"self-testing" does not appear in the manuscript, and the source note's unsupported sentence about
self-testing bounds degrading with system size is not reproduced. The one sentence about trust says
plainly that both statements concern a known state acted on by product unitaries of bounded
generator norm and certify no unknown device.

### Judgment calls, flagged rather than taken silently

1. **C774's cross-programme theorem (`rank_Q Λ_C = n` iff `d(C^⊥) ≥ 3`) was not adopted.** It is a
   sharp and attractive statement, but its payoff is a criterion for the *diagonal* symmetry group of
   a binary CSS coset state, and that reading requires Theorem 1 of the diagonal-rigidity note --- a
   Smith-normal-form classification that this manuscript does not contain and that the C778--C785
   programme owns. Importing the corollary would mean importing that theorem, a qubit-only excursion
   inside a prime-power stabilizer-AME paper. Recommend it be pegged to the diagonal programme
   instead.
2. **C581's negative half is stated in conditional form.** The scope review asked for the sentence
   "no bound tending to zero with `ε` can target the semilinear subgroup or split torus, by C623's
   exact witnesses". The `q = 9` nonsemilinear intertwiners and the `q = 25` `Sp_4(5)` kernel are
   nowhere in the manuscript, and introducing them here would be a new import with its own evidence
   burden. The text instead states the implication that needs no witness: an exact intertwiner
   outside a proposed smaller subgroup has positive distance from that finite closed subgroup, so at
   `ε = 0` every uniform estimate toward it fails. The cold read may prefer the concrete form; that
   is a one-sentence change plus the C623 import.
3. **The sharp-constant statement is folded into the stability theorem** rather than displayed as a
   separate corollary as C774 suggested. Proving the two-sided estimate `(3.14)` makes the limit
   `ε²/D² → 1/q` immediate, and a corollary restating it would be ceremony.
4. **Everything sits in one subsection**, as instructed, including the intertwiner and gauge
   material. It runs about five pages. If the cold read finds that unwieldy, the natural break is
   before `lem:quantitative-axes`.
5. **Two sentences were added to the conclusion.** The brief did not list Section 7, but a conclusion
   that ignores the new subsection would misdescribe the paper.
6. **`prop:stability-region` is a manuscript proposition with a proof**, not a citation of C774's
   certificate. The Reed--Muller weight distribution, the defect, the generator norms, and the ratio
   function are all closed form, and `θ*` is characterized as the unique root of an explicit scalar
   equation on `(0,2π)`. Nothing in the new subsection depends on a computation, so no evidence
   bundle enters the supplement and the reproducibility contract is not engaged.

## 2. Bibliographic verification

C775 flags several bibliographic details as unverified and forbids citing them unverified. Each
citation newly added to `refs.bib` was resolved against a consulted source before it was written.

| Entry | Resolved from | Result |
|---|---|---|
| Braunstein--Caves | Crossref `10.1103/PhysRevLett.72.3439` | Phys. Rev. Lett. **72**, 3439--3443 (1994) |
| Hyllus et al. | Crossref `10.1103/PhysRevA.85.022321` | Phys. Rev. A **85**, 022321 (2012), eight authors |
| Tóth | Crossref `10.1103/PhysRevA.85.022322` | Phys. Rev. A **85**, 022322 (2012) |
| Słowik--Sawicki--Maciążek | Crossref `10.22331/q-2021-05-01-450` | Quantum **5**, 450 (2021) |
| Bryan--Leutheusser--Reichstein--Van Raamsdonk | Crossref `10.22331/q-2019-01-06-115` | Quantum **3**, 115 (2019) |
| Bryan--Reichstein--Van Raamsdonk | Crossref `10.1007/s00023-018-0682-6` | Ann. Henri Poincaré **19**, 2491--2511 (2018) |
| Lyons--Walck--Blanda | Crossref `10.1103/PhysRevA.77.022309` | Phys. Rev. A **77**, 022309 (2008); **three** authors, not two as C775 records |
| Gour--Kraus--Wallach | Crossref `10.1063/1.5003015` | J. Math. Phys. **58**, 092204 (2017) |
| Rather--Aravinda--Lakshminarayan | arXiv API `2205.08842` | PRX Quantum **3**, 040331 (2022), DOI `10.1103/PRXQuantum.3.040331` |
| Pahari | arXiv API `2607.00210` | arXiv:2607.00210 (2026), no journal reference |
| Auddy--Yuan | arXiv API `2007.09024` | arXiv:2007.09024 (2020), no journal reference |

Bertini--Kos--Prosen is **not** cited: C775 asserted no bibliographic detail for it and no paper was
opened, so under the attribution rule it is dropped rather than guessed.

### C775's open gate on Słowik--Sawicki--Maciążek, closed here

C775 required confirmation from the full text that the designed local symmetry groups are
positive-dimensional before the contrast sentence could be written. The paper was fetched and
ingested into the shared cache (key `arXiv:2011.04078`, SHA-256
`a46df6bb44fbee18051bc6fa9c89828ccad65396e74bc48b203910d5116c8b19`, 42 pages, from
`https://quantum-journal.org/papers/q-2021-05-01-450/pdf/`). Its Lemma 2 and proof state, for
`H_N = (C^d)^{⊗N}` with `N ≥ 4`, the existence of a locally maximally entangled state
`|Φ⟩` whose local-unitary stabiliser `K_{|Φ⟩}` contains the closure of a nontrivial
continuous image `π(SU(N))`, with `dim π(H) ≥ 1` proved explicitly. So the designed
symmetry groups are positive-dimensional, and the contrast sentence is licensed. Read depth:
partial (abstract, Section 2.4 including Lemma 2 and its proof).

## 3. Structural updates

| File | Change |
|---|---|
| `main.tex` | one abstract paragraph stating discreteness and the two-sided constant/neighbourhood facts together; title unchanged |
| `sections/01-introduction.tex` | the Wirthmüller/Ramadas--Lakshminarayan limitation paragraph rewritten (nonstabilizer AME states remain unclassified, but each has a finite product-symmetry group modulo phase, so the stabilizer hypothesis only names the group); a clause on the Bell pair's pure pair marginal added to the sharpness sentence; a new first row in `tab:result-scopes` whose domain is strictly larger than every other row's |
| `sections/03-lu-rigidity.tex` | the new subsection |
| `sections/07-conclusion.tex` | two sentences on the entanglement/algebraic split |
| `sections/08-verification-boundary.tex` | new claim-to-trust paragraph recording that the subsection is proof-only, that `τ_p` is explicit and `ε₀` is not, and that no threshold can be uniform in the party count; the closing exclusions paragraph now says that the new theorems apply to nonstabilizer AME tensors without classifying them |
| `refs.bib` | eleven new entries, all bibliographically verified (§2) |
| `theorem-map.md` | source rows for C581 and for the external-note package; new stable labels; new hierarchy entry 2b; four new frozen-boundary rows; three new deliberate exclusions |
| `claim-proof-novelty-ledger.md` | one row carrying the full C775 attribution posture |
| `verification-map.md` | one row: manuscript proof, no computation, no replay needed, source note's numerics deliberately not imported |
| `formalization-ledger.md` | one row: no Lean coverage; names the reasonable targets and the two hard ones (operator Taylor remainder, the compactness extraction behind `ε₀`) |

## 4. Gate

`make check` in `papers/ame_lu` exits 0: `supplement/verify.py` verifies all evidence artifacts, the
TeX spacing lint passes on all section files, the XeLaTeX build completes, and the log contains no
overfull box, underfull box, LaTeX warning, package warning, undefined reference, or undefined
citation. The paper is 39 pages, up from 34.

## 5. Standalone mirror

`~/src/math-papers/ame-lu` was **not touched**, as instructed. When the forward-commit happens it
will need: the new Section 3 subsection, the abstract paragraph, the three introduction edits
including the new `tab:result-scopes` row, the conclusion sentences, the Section 8 claim-to-trust
paragraph and revised exclusions, and the eleven `refs.bib` entries. The four ledgers are
repository-internal and do not appear in the mirror. No supplement or release artifact changes, so
`release/RELEASE-MANIFEST.json` needs regeneration only for the manuscript bytes.

## 6. Open items for the cold read and successors

- The two judgment calls in §1 that a reviewer may want reversed: the cross-programme coding theorem
  and the conditional form of C581's negative half.
- The explicit `ε₀` question remains open and gates any certification statement. C774 and the scope
  review name three attack routes: the higher-moment expansion available because an `AME(2m,q)`
  state is `m`-uniform, the Weyl expansion of the defect function, and a Łojasiewicz-type fallback.
- The `q²` constant of `prop:quantitative-intertwiner` against the `√q` of
  `thm:two-uniform-stability` is a genuine structural gap, owned by the relativized-Hessian
  successor.
- C775's uncovered gates stand: zbMATH Open was never queried, MathSciNet is unreachable, and the
  Ulam/Gowers--Hatami approximate-representation literature was not searched. Every firstness
  sentence in the manuscript retains "to our knowledge", and there is exactly one such sentence.
- Formalization scope for the subsection is C777's decision; nothing here is claimed as kernel
  checked.

## 7. Vibe check

Good. The material fits the paper better than expected: the discreteness theorem turns the existing
discreteness corollary into a specialization rather than sitting beside it, and the RM(1,4) witness
makes the entanglement/algebraic split visible in one object. The real soft spot is the
non-explicit threshold, which C774 showed cannot be made uniform in the party count — the paper now
says so in three places rather than selling the constant's independence as certification.

---

**Superseded in part, 2026-08-02.** The region proposition adopted here, and the abstract and
introduction sentences describing it, generalize a 2-uniform-class fact to the class the
decomposition corollary is stated for. C786 proved the certified radius grows with the uniformity
order, hence linearly in the party count for absolutely maximally entangled states, and replaced the
compactness threshold with a closed form. C795 carries the correction. Everything else adopted here
stands. See `2026-08-01-c786-explicit-stability-threshold.md`.
