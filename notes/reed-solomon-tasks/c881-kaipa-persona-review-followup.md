# C881 — Kaipa persona review: follow-up investigation and fixes

**Lane:** `reed-solomon`

**Status:** active; allocated 2026-08-07.  Work items 1--3 are complete and
committed; items 4--9 remain.

**Completed 2026-08-07.**  The full literature read is
`notes/2026-08-07-c881-r5-cubic-pencil-literature-audit.md`.  Its verdict is
harder than the first-pass triage: the redundancy-five split-free criterion is
prior art at the level of pencils of binary cubics, in every characteristic,
with Blokhuis--Pellikaan--Szőnyi reaching the same \(q\ge23\) threshold by the
same genus-one double-point-scheme route, and exact split-witness counts
published for every line class.  What survives is the syndrome layer.  Applied
to the Version 2 draft: nine bibliography entries; the finite-geometric
criterion \(W_f\cap\mathcal O_3=\varnothing\) and a class-by-class attribution
remark in Section~\ref{sec:r5}; a rewritten related-work paragraph; a
`PRIOR-ART` row and a narrowed novelty row in the claim--proof--novelty ledger;
the sources, screened citing set, and coverage gaps in the paper's literature
audit; and pinpoint citations replacing the previously unattributed
cubic-cover hypothesis in the Lean module and gate headers.  Both manuscript
builds (59-page canonical, 42/50 TIT), the paper verifier, single-file
elaboration of both touched Lean modules, and the redundancy-five Lean gate
are green.  Version 1 is untouched.

**Target artifact:** `papers/beyond4_prs` (beyond-redundancy-four PRS paper,
TIT submission `main-tit.tex` plus the Version 2 working draft).

**Origin:** first-round Krishna Kaipa persona review of the TIT submission,
supplied by the user 2026-08-07.  The review's praise is recorded below only
as far as it constrains the repairs; its seven numbered additions plus the
invariant-formulation suggestions are the work list.

**Routing, settled 2026-08-07:** the repairs apply to the Version 2 working
draft.  Version 1 is published and immutable; whether it needs an erratum
naming the pencil-level prior art is an open user decision.

## Verified external record (checked 2026-08-07, bounded web search)

All four items are real and none is currently in `papers/beyond4_prs/refs.bib`
or `papers/beyond4_prs/literature-audit.md`.

| Work | Identifier | Content that bears on this paper |
|---|---|---|
| Blokhuis, Pellikaan, Szőnyi | `arXiv:2103.16904`; Des. Codes Cryptogr. 90(9):2223–2247 (2022) | Extended coset leader weight enumerator of the GRS \([q+1,q-3,5]_q\) code. Line in \(PG(3,q)\) ↔ rational function of degree \(\le 3\); **double point scheme** of that function; passant pencil gives a **genus-one** curve; **Hasse–Weil** bound closes it. |
| Günay, Lavrauw | `arXiv:2104.04756`; Finite Fields Appl. 78 (2022), `10.1016/j.ffa.2021.101960` | Pencils of cubics on \(PG(1,q)\) as \(PGL_2(q)\)-orbits of lines of \(PG(3,q)\), char \(>3\); **point-orbit and plane-orbit distributions** for lines in an osculating plane, lines meeting \(\mathcal C\), imaginary chords, imaginary axes. |
| Kaipa, Pradhan | `arXiv:2509.15332` | Point-line and line-plane incidence structure of the \(PGL_2(q)\)-orbits in \(PG(3,q)\) w.r.t. the twisted cubic; generic lines carry an associated binary quartic and an **elliptic curve**. |
| Kaipa, Pradhan | `arXiv:2508.11229`; Finite Fields Appl. (`S1071579725001935`) | The same line/quartic orbit classification in **characteristic three**. |

Already cited: `Kaipa2017`, `ZWK2020`, `KPP2025` (= `arXiv:2312.07118`, binary
quartics / lines relative to the twisted cubic).  The introduction currently
dismisses `KPP2025` as "adjacent normal-form geometry for the redundancy-six
problem"; that characterization is what the new sources put in question.

Ceria–Pavese, *On the geometry of a \((q+1)\)-arc of \(PG(3,q)\), \(q\) even*,
Discrete Math. 346 (2023), Paper No. 113594, does solve the characteristic-two
case; confirmed at secondary depth through Kaipa–Pradhan §1, not against the
paper itself.

## Overlap that drives the repair

Proposition `prop:r5-incidence` (`sections/04-redundancy-five.tex:98`) builds
\(\phi_f:\PP^1\to\PP^1\) of degree three from a trivial-gcd pencil and divides
the fiber-square bracket by the diagonal to get the bidegree \((2,2)\),
arithmetic-genus-one residual \(Y_f\).  That is the double point scheme of a
degree-\(\le 3\) rational function attached to a line of \(PG(3,q)\), and
`lem:s3` then applies an Aubry–Perret/Hasse–Weil count to it.  Blokhuis–
Pellikaan–Szőnyi run construction, curve, and bound in the same order for the
redundancy-four coset leader problem.  The full read settled this harder than
the first pass expected: their Proposition 7.4 decides, for \(q\ge23\) and
every characteristic, exactly which line classes contain a totally split
squarefree member, so every stratum of the manuscript's Section IV is
pre-empted at pencil level.  Only the syndrome layer survives.  See the audit's
per-stratum table.

The reviewer's reformulation of the R5 criterion is
\[
 f\ \text{split-free}\iff W_f\cap\mathcal O_3=\varnothing ,
\]
with \(W_f\) a line of \(PG(3,q)=\PP(\mathrm{Sym}^3E^\vee)\) and
\(\mathcal O_3=PGL_2(q)\cdot XY(X-Y)\) the point orbit of cubics with three
distinct rational roots.  Under that dictionary, R5 is a **point-orbit
distribution question for line orbits** — precisely what Günay–Lavrauw
(non-generic classes) and Kaipa–Pradhan (generic lines; char 3) compute.

## Work items

1. **Literature repair (mandatory).** *Done.* Add the four verified works, record them
   in `literature-audit.md` under `notes/literature-audit-conventions.md`, and
   rewrite the related-work paragraph
   (`sections/01-introduction.tex:166–194`) to state exactly what R5 adds over
   the double-point-scheme/genus-one/Hasse–Weil route and over the published
   orbit-distribution tables.  Re-check every novelty-ledger row that asserts
   an absence.  Gate: an audit entry per source with search domain and stop
   condition, plus a defensible delta sentence for R5.
2. **Pre-emption assessment (mandatory, gates item 1's wording).** *Done —
   pre-empted at pencil level in every stratum; see the audit's per-stratum
   table.* Determine
   how much of the R5 classification follows from the published line-orbit
   point-distribution tables (Günay–Lavrauw char \(>3\) non-generic classes;
   Kaipa–Pradhan generic lines and char 3; whatever covers char 2).  Three
   outcomes: no overlap of results, partial derivation, or full derivation of
   some strata.  If a stratum is fully derivable, the manuscript must cite
   rather than reprove it.  Gate: per-stratum verdict against the manuscript's
   own case split (gcd 2, gcd 1, inseparable char 3, \(C_3\), \(S_3\)).
3. **Add the finite-geometric formulation of R5.** *Done.* State
   \(f\ \text{split-free}\iff W_f\cap\mathcal O_3=\varnothing\) early in
   Section~\ref{sec:r5}, with the orbit identification cited.  Cheap, and it
   makes the section legible to a finite geometer.
4. **Identify \(Y_f\) with the Kaipa–Pradhan elliptic curve.** Their
   construction fixes a root \(t_1\), splits the cubic as
   \(\ell_{t_1}h_{t_1}\), and takes \(w^2=D_L(t_1)\) for the residual
   discriminant; choosing \(w\) is choosing the second root, so
   \((t_1,t_2)\leftrightarrow(t_1,\sqrt{D_L(t_1)})\) should identify the
   normalization of \(Y_f\) with \(E_{W_f}\) up to coordinates.  Prove or
   refute.  Gate: an explicit birational map, or a stated obstruction, plus a
   small-\(q\) numerical check.
5. **Import the exact incidence count.** *Partly done.*  Kaipa–Pradhan
   Theorem 1.3 states
   \(|L\cap\mathcal O_3|=(\#E_L(\F_q)-3\eta_L)/3\) — denominator three, not
   the reviewer's six — for generic lines in characteristic other than two and
   three.  The consequence split-free \(\iff \#E_{W_f}(\F_q)=3\eta_{W_f}\le12\),
   and the \(q\le19\) bound it forces through Hasse, are now printed in the
   manuscript.  What remains is whether it can replace the proof rather than
   accompany it.
   Consequences to test: (a) an exact replacement for the crude deletion count
   in `lem:s3` (currently costs diagonal 4 + branch 8 + one singular point,
   forcing \(q\ge 23\)); (b) a Hasse-bound argument showing generic exceptions
   are confined to small \(q\) because \(3\eta_L\le 12\); (c) how much of
   Certificate R5's domain \(\{7,8,9,11,13,16,17,19\}\) survives.  Gate: either
   a lowered unconditional threshold or a stated reason the exact formula does
   not improve it.
6. **Recast the sporadic inventory by \((j(E_L),a_q(E_L),\eta_L)\).**
   Table `tab:r5sporadic` currently lists syndrome-coordinate representatives
   and Frobenius fusion only.  Adding the elliptic invariants converts
   "sporadic census" into "these are the fields where an admissible line orbit
   admits a curve with too few rational points".  Representatives stay as
   certification data.  Gate: invariants computed and cross-checked against the
   existing certificate histograms.
7. **Promote the split-witness count to a statement.** The certificates already
   record complete cubic-pencil member histograms; \(N_f=|W_f\cap\mathcal O_3|\)
   is currently discarded after the zero test.  Decide whether it becomes a
   theorem here or a companion error-distribution result (note Kaipa's stated
   interest in PRS error distribution).  Gate: a decision plus, if kept, the
   statement and its proof.
8. **Name the Hankel–Plücker map intrinsically.**
   `sections/07-recursive-carriers.tex:44–66` uses \(c\mapsto z(c)\) into
   \(\mathrm{Gr}(2,\Gamma^3E)\) computationally.  Kaipa's line geometry lives on
   the Klein quadric with a \(PGL_2\)-equivariant identification to binary
   quartic data.  Determine the classical covariant/apolar identity of
   \(c\mapsto z(c)\), and whether the residual projected Veronese component has
   an intrinsic explanation instead of appearing by elimination.  Optional;
   proceed only if a clean identification exists.
9. **Invariant formulation of the maximal Lucas carrier.** Ask which canonical
   modular \(GL_2\)-submodule \(M^{\max}_{r,p}\) is (socle/radical layer,
   Frobenius-twist constituent, kernel of an equivariant map) rather than
   defining it by the Pascal congruences.  Research direction, not a repair;
   the reviewer does not claim such an identification exists.  Log to the
   discovery track if it stalls.

## Ordering

Item 2 gates item 1's wording; items 1–2 are the only mandatory ones.  Item 3
is cheap and independent.  Items 4–5 are the mathematical core and should be
attempted together, since item 5 depends on item 4's identification holding.
Items 6–7 depend on item 5.  Items 8–9 are optional and may be split out or
discovery-tracked.

## Acceptance

- Literature audit and refs updated with the exact identifiers above, and the
  Ceria–Pavese characteristic-two claim either verified or dropped.
- A written per-stratum pre-emption verdict for R5.
- Either a proved \(Y_f\cong E_{W_f}\) proposition or a recorded refutation.
- Any manuscript change revalidated through the existing build and artifact
  verifier before commit, with the Version 1 / Version 2 routing honoring the
  user's answer to the question at the top of this card.
