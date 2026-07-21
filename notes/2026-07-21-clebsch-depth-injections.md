# Depth injections — candidate A-grade theorems on the Clebsch spine

**Lane:** `crowns` (read-only `clebsch` inputs)

**Date:** 2026-07-21

**Status:** design note, advisory. No allocation, no manuscript change. Companion to
[`2026-07-21-clebsch-weil-roof-conversation-report.md`](2026-07-21-clebsch-weil-roof-conversation-report.md)
and the execution program. Addresses one question: the paper's technical-depth grade is capped at
B+ because every spine theorem is proved by exact computation at q = 5, 7, 11 plus textbook
theory; what theorems, native to the spine, would move depth to A?

**Design principle.** Depth moves only when the proof is forced to be the hard part. In this
material that means quantifying over an infinite family — all q, all degrees, all subgroups, or a
whole linear group — so that certificate exhaustion is impossible and genuine machinery (Weil
bounds, defining-characteristic module theory, Adler-style rigidity arguments) carries the load.
Each candidate below has that shape and sits on the existing narrative rather than beside it.

## D1 — the converse classification (flagship)

**Theorem shape.** Classify all triples (q, H, Ω) — q an odd prime power, H an exceptional
subgroup of `PGL_2(q)`, Ω an H-orbit of perfect matchings of the full conic — satisfying the
spine's two defining properties: conic-equality of secant products (the C403 property) and
balanced `PSL`-fission of strength exactly two with cubic separation. Target answer: exactly the
three Coxeter cases q = 5, 7, 11.

**Why it is A-depth.** The exceptional parents A4/S4/A5 exist in `PSL_2(q)` for infinitely many q
(congruence classes mod 8 and 5), so the classification cannot be finished by finite checks: the
infinite tail must be killed by counting arguments — uncovered-point positivity via Weil-type
estimates, in the style already begun by the all-q formula `q^2 − 14q + 45` for the icosahedral
case — plus Dickson's subgroup classification to structure the case analysis and all-q moment
constraints for the strength conditions. Two of the three exceptional-family formulas (octahedral,
tetrahedral analogues of the icosahedral uncovered count) do not yet exist and are real work.

**Narrative fit.** This is the best-fitting depth item available: the paper currently *inherits*
completeness from the Coxeter classification; D1 *derives* it — the theorem discovers A3/B3/H3
instead of assuming them. The "singular exception" rebuttal becomes self-contained: the
construction, classified from within, has exactly three instances.

**Risk/cost.** Months. The large-q kill is standard-but-serious; the main risk is case bloat in
the strength analysis. Partial landing (conic-equality classified, strength conditions checked
per-case) still upgrades the completeness claim materially.

## D2 — the memory filtration as a modular-representation theorem (engine room)

**Theorem shape.** For the full conic over any `F_q` (q odd prime), describe the factorization-
difference span and the entire signed/unsigned moment filtration in *all* degrees as explicit
`SL_2(F_q)`-modules in defining characteristic: the harmonic-plus-radial image theorem proved
uniformly (currently three row-reductions), base-point independence structurally, and the image
and kernel of every `mu_k` identified via symmetric powers `Sym^d` in the restricted range,
Clebsch–Gordan in characteristic p, and (where degrees exceed the restricted range) tilting/
Frobenius-twist structure.

**Why it is A-depth.** The conic Laplacian and harmonic decomposition degenerate in
characteristic p; making the decomposition theorem uniform in q is genuine modular invariant
theory, not a computation. Upgrading "cubic-first" (degrees 1–3) to a complete structural
description of the filtration in every degree is the kind of theorem defining-characteristic
specialists recognize as real.

**Narrative fit.** Dead-center: this *is* the memory mechanism. C406's section stops being "three
matrices verified" and becomes a theorem about `SL_2(F_q)`; the paper's central object acquires a
proof whose difficulty matches its billing. Shares machinery with D1 (the strength conditions in
D1 are corollaries of the filtration description).

**Risk/cost.** Months; moderate risk that the general-degree description is messy rather than
clean — but a clean theorem for degrees up to the restricted bound with a stated boundary already
suffices for the grade.

## D3 — an Adler-style rigidity theorem for the cubic (the gem)

**Theorem shape.** Determine the full stabilizer of the line `F_q mu_3` in `PGL(W)` — target: the
image of `PGL_2(11)` exactly (dim W = 10; B3 analogue in dimension 6 with `PGL_2(7)`). C406
explicitly disclaims any claim about the full linear stabilizer; this fills that disclaimer with a
theorem.

**Why it is A-depth.** The precedent is Adler's theorem that the automorphism group of the Klein
cubic threefold is `PSL_2(11)` — a genuinely hard classical result. The proof shape is known but
serious: geometric invariants of the hypersurface (singular scheme, Hessian behavior) to bound the
stabilizer, finite-subgroup and representation theory of the ambient projective group to pin it.
An overgroup surprise (stabilizer strictly larger) would itself be a finding.

**Narrative fit.** Elevates the one-more-thing object into a named exceptional hypersurface with
its own rigidity theorem — rigidity of the arc, rigidity of its cubic shadow — and hands paper 2
the strongest possible interface to the Klein-cubic/Weil-component question without assuming any
of it.

**Risk/cost.** The hardest and least certain of the five; unbounded tail risk. Treat as a
stretch goal; even a partial result (stabilizer inside the normalizer of a torus-free list) is
publishable inside the paper.

## D4 — all-q deep-hole classification by curve counting (the analytic arm)

**Theorem shape.** For the all-odd-q pencil (C368/C395 setting), classify deep holes and the
conic-filling phase for *all* q: encode deep-hole membership as rational-point conditions on
auxiliary curves, apply Weil–Serre bounds to settle every q beyond an explicit q0, and close
q ≤ q0 by certificate. "Why 11" acquires an analytic proof: the exceptional fields are exactly
where the point counts permit.

**Why it is A-depth.** This is the methodology of the Reed–Solomon deep-holes literature
(character-sum and curve-counting arguments), applied end-to-end. The bounds are the proof; the
certificates become a finite closing move instead of the whole argument.

**Narrative fit.** Step 2 of the architecture (the non-GRS parent and its GRS child) becomes an
all-q theorem, and the paper's isolation claims get proofs that quantify over every field at once
— the exact upgrade a referee reading "computed at q = 11 and 19" would ask for.

**Risk/cost.** Weeks to months; low conceptual risk (the method is reliable), moderate labor in
setting up the auxiliary curves cleanly.

## D5 — the theta-parity theorem, proved conceptually (conditional on battery T4)

**Theorem shape.** If T4 finds that theta/Arf parity separates the sheets: prove it — uniformly
for q = 5, 7, 11 and ideally for any hyperelliptic curve with G-symmetric branch set — that
one-factorization Lagrangian packings in `J[2]` have constant parity on `PSL`-orbits, and the
fused pair has opposite parity exactly under the splitting criterion. Machinery: Weil pairing,
Arf-invariant theory, equivariant group cohomology (the parity as a class), no exhaustion.

**Why it is A-depth.** It is an arithmetic-geometry theorem with a structural proof living inside
paper 1, converting the strongest Rosetta row from "checked" to "proved" and giving the bit its
arithmetic identity without waiting for paper 2.

**Narrative fit.** Directly strengthens the six-shadow ending; the cliffhanger then hangs from
canonicity alone, which is the cleanest possible cliff.

**Risk/cost.** Gated on T4 landing true; if it lands, the proof looks like days-to-weeks, the
best depth-per-effort ratio on this list.

## D6 — split-torus mechanism as a general lemma (supporting)

For irreducible rank-3 W with q = h + 1 a prime power, prove the reflection representation admits
an `F_q`-form in which the Coxeter element's rotation generates the split torus, via Springer's
regular-element theory reduced mod q (not by three conjugacy checks). Small on its own; listed
because it converts the opening law's mechanism (battery T2) from verified to derived and feeds
D1's setup.

## Selection and grade calculus

The paper cannot absorb all six without becoming an anthology. Recommended package:

- **D1 + D2** (they share machinery and together re-found the spine): depth B+ → A−.
- **plus any one of D3 / D4 / D5**: depth → A. D5 is the best ratio if T4 lands; D4 is the
  safest unconditional choice; D3 is the gem with tail risk.

Interaction with other grades: D1 also moves novelty (a classification is "the only ones," not
"here is one") and significance (exported method: moment-classification over Dickson families).
None of the six depends on the Weil-roof conjecture, so paper 1 remains referee-independent of
paper 2. Cost realism: this package converts the manuscript timeline from "freeze after the
battery" to a genuine second research phase; the alternative remains shipping the current A-grade
specialist paper and placing D1/D2 in paper 2. That trade — ship now versus deepen first — is an
architecture decision owned by the paper lane, and both branches are defensible.
