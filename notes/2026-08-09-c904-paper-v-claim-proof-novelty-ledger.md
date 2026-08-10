# C904 — Paper V claim–proof–novelty ledger

**Date:** 2026-08-09  
**Owner:** Clebsch Paper V  
**Audit:** `notes/2026-08-09-c904-paper-v-literature-audit-opening.md`

This is the sole home for Paper V's novelty verdicts.  Other surfaces may
paraphrase a row only with an explicit pointer here.  Until a row is marked
`CLOSED`, the manuscript must state the mathematical and attribution boundary
without a “first,” “new,” or “to our knowledge” sentence.

| id | claim | proof/evidence | novelty/priority verdict |
|---|---|---|---|
| `C904-V1` | The five-isotypic projection of the Paper-II signed third moment is the marked chordal member `H_M`, not the conference member, of the two-dimensional `A_5`-invariant cubic pencil over `F_11`. | Human representation reduction and exact coefficient transport in *The five-dimensional residue*; `paper_ii_chordal_axis.py/json`, schema v2. | **ATTRIBUTION CLOSED; PRIORITY UNASSERTED.** Pinardin--Zhang is cited for the pencil and chordal members; HMSV is cited for the exceptional-six-point dictionary. The manuscript claims the exact Paper-II placement as its contribution but makes no “first” or negative-priority assertion. Seven full-text, eight partial, and the recorded forward searches found no pre-emption; inaccessible-index gaps therefore constrain priority language, not publication of the proved comparison. |
| `C904-V2` | The exact-`C_5` stabilizer fibres on the Paper-II chordal singular quartic identify equivariantly with the original six matching axes. | Scheme-theoretic Hankel singular-locus proof; tame `A_5/C_5 -> A_5/D_5` stabilizer argument; independent exact replay. | **ATTRIBUTION CLOSED; PRIORITY UNASSERTED.** Cheltsov--Marquand--Tschinkel--Zhang is cited for the unmarked chordal cubic and its larger automorphism group; the abstract `A_5/D_5` six-set is treated as classical. The manuscript owns only compatibility with the frozen Paper-II matching axes and makes no negative-priority claim. |
| `C904-V3` | For a selected chordal line, the exactly normalized outer difference `q-1` identifies Paper-II sheet negation with conference negation and gives inverse marked transports. | Pencil matrix `q=[[-1,8],[0,1]]`; exact formulas `h -> 8^-1(q-1)h` and inverse; objectwise source return restricted to decorated packages in the image; exact tensor inverse including pivot, polynomialization, self-duality, and bridge. | **ATTRIBUTION CLOSED; PRIORITY UNASSERTED.** Pinardin--Zhang §8.2 is cited for the outer involution and exchange of quartics. The manuscript claims only its normalized mod-eleven action and source-orientation compatibility, with no “first” sentence. |
| `C904-V4` | The marked package and exact-`C_5` divisor commute functorially with every scalar extension `K/F_11`, giving a tower over `F_{11^m}`. | Reynolds idempotent; flat base change of the Jacobian scheme; constant finite étale `G/C_5 -> G/D_5`; scalar extension of the exact matrix and tensor identities. | **NOT A SEPARATE NOVELTY CLAIM.** This is a base-change corollary clarifying the intrinsic twelve-point selector, not a new matching construction on `P^1(F_{11^m})`. |
| `C904-V5` | A relative companion theorem holds over an explicit localization of `Z[sqrt(5)]`, with good reduction and a functorial exact-`C_5` divisor. | Not proved; prospectus only. | **BLOCKED FROM MANUSCRIPT.** Requires an explicit integral model, bad-prime computation, scheme proof, and separate audit against Pinardin--Zhang/HMSV/classical sources. |

## Repeated-surface checklist

- Manuscript: mathematical and attribution boundaries are explicit; no
  “first,” “new,” or “to our knowledge” claim.
- Paper V evidence/trust text: no independent novelty sentence.
- Series summary README and all five live diagrams: updated to the proved
  companion statement; no literal one-cubic or future-Paper-V language.
- Planning/index surfaces: Paper V title, status, scope, and boundary updated.
- Public results snapshot: not yet created; any future snapshot must preserve
  the priority-unasserted boundary above.
