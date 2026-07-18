# Dihedral paper lane — companion archive (append-only)

Companion to `../2026-07-17-dihedral-paper.md`. Dated session notes and superseded material only;
the live handoff keeps the current-state map.

## 2026-07-17 — Lane creation and five-task session (Claude Fable 5 session)

Session scope: the lane was created from the untouched-papers publication review (dihedral judged
closest to the arcs/clebsch bar), then five of its gap tasks were executed and closed the same day
by managed Opus sub-agents with parent review of every deliverable.

Completed (all with archive rows, commits, and reports):

- **C260** — A₅ template-nimber independent cross-check: all five values reproduced by a fresh
  left-mult-only Rust solver; group-free BLISS solver validated the method on V₄/S₄ and showed the
  reference canonicalization group equals each graph's full automorphism group. Parent replayed
  S₄ + both girth-4 A₅ classes with identical values and memo-state counts. Commit `fcb9f4e5`.
- **C261** — dedicated novelty/priority audit: Brown et al. attribution verified exact against the
  JIS full text; Tranchida delineation confirmed; no colliding prior art; package verdict
  "apparently unrecorded"; recommendations R1–R5 deferred to C264. Commit `03be4aea`.
- **C262** — Φ_T (Prop 11.1 + Cor 11.2) fully formalized (`Burnside.lean`); Thm 12.1 finite core
  formalized (`Density.lean`: coprimality, period 8n, exact 2-of-4 selection, P/N infinitude);
  density-value gap surfaced as a user gate. Commit `98556d35`.
- **C263** — generalized-D₂ₘ additions: the whole legal-pair family was missing, now classified for
  every `m ≥ 3` of either parity (new §14: cycle/path/∅ templates, odd dihedral always P, even case
  `(1−δ)·𝒢(Pₘ)` with Dawson values, densities 1 or ½, converse); verified over all 241,344 tame
  legal pairs, `q ∈ {5..23}`, zero mismatches; retitle to "Dihedral Subgroups of PGL₂(q)";
  Discussion → §15. Parent spot-replayed q=5,7,11. Commit `15716b93`.
- **C278** — density-½ closed conditionally per the user's `yc` ruling: one quarantined axiom
  `primes_equidistribute` (PNT-in-AP, natural-density form, Davenport Chs. 20–22); ½ kernel-derived
  for all triple types and both torus signs; audits exactly
  `[propext, Classical.choice, Quot.sound, primes_equidistribute]`. Commit `b0b028b5`.

Also this session: lane created with routing row (commit `a1ed55c9`); C281–C284 allocated per the
user's upgrade ruling (commit `5d684a47`); C270 re-pegged `[build-sys]`→`[nofil]` on approval
(commit `091ecd28`).

Deviations and lessons:

- The C278 agent assumed `lean-build-queue.py --detach` queues behind a held build lock; it fails
  fast instead (foreign `RelativeConicArcs` Q25 build held it). Resolved by resubmitting after the
  holder finished. Recorded in the live handoff's Cautions.
- Two `DensityConditional.lean` iteration errors (misapplied `ZMod.val_injective`; a
  beta-unreduced `Int.castRingHom` coercion blocking a rewrite) were fixed via the guarded-lean
  fast loop.
- Grade trajectory vs the 2026-07-13 portfolio review: estimated B− → B+ overall; the remaining
  ceiling is significance (tame case only), addressed by the queued C284 polyhedral lever and C283
  wild spike.

Next session entry: `go dihedral`, then take the C284 pre-submission-vs-post-release sequencing
decision before starting C264.
