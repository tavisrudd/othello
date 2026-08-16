# C908 — Annals-upgrade mathematics after the cubic epilogue

**Lane:** `cubic-threefolds`

**Status:** queued for Fable.  This task is mathematics only.  It does not
edit Papers I--V, the computational companion, the cubic-stabilization
epilogue, their PDFs, mirrors, Lean sources, or reviewer dossiers.

## Objective

Continue the highest-ceiling mathematics left by C904 after the fibrewise
minimal-class theorem and the one-stabilization epilogue.  Seek one structural
theorem that is independently publishable at an Annals-adjacent level.  A
negative theorem is acceptable only when it identifies the exact intrinsic
obstruction and its minimal splitting datum; another parity census is not.

## Priority order

### A. Intrinsic relative Chow descent

Determine the arithmetic index of the generic unordered-theta fibre

\[
  Y=(\operatorname{Sym}^2\Theta\longrightarrow J)_{\mathbf C(J)}
\]

on the exotic marked family, equivalently the remaining two-primary index in
the charge-three Abel--Jacobi channel.  The known degree-two carrier makes the
dichotomy exactly `ind(Y)=1` or `2`; the degree-fifteen `D_{3,3}` packet only
proves two-equivalence with the generic `M_9` fibre and does not decide it.

The live mathematical targets are:

1. construct an actual horizontal odd multisection / integral relative
   minimal cycle; or
2. identify a canonical two-primary obstruction class, prove a local--global
   or residue theorem for it, compute it on the exotic marked base, and
   determine the minimal splitting cover.

The exact descent obstruction for a doubled Chow class is

\[
 \ker\!\left(CH_1(D_{+,K})/2\longrightarrow
                  CH_1(D_{+,\bar K})/2\right).
\]

Do not replace this group by `J[2]`, ordinary monodromy invariants, or a base
Brauer class without proving the comparison.

Highest-EV structural approaches:

- a field-general, choice-by-choice reconstruction of Shen's half that
  isolates its finite/abelian Chow torsor;
- an integral or `Z_(2)` Chow--Kunneth / inverse-Lefschetz projector on the
  theta resolution `Bl_0 Theta`, sufficient to algebraize the live `(1,5)` or
  nonsplit `(2,4)` Kunneth class;
- a regular proper stable-semiabelic model of the theta addition graph with
  flat quotient, component multiplicities, and a specialization theorem
  strong enough to compute the generic index;
- a named proper compactification of the classical charge-three Abel--Jacobi
  fibre together with an intrinsic odd determinant intersection or a genuine
  surface-field section theorem.

### B. Intrinsic `p`-typical divisor-product classification

Classify the integral minimal-class divisor-product index for arbitrary
self-dual elliptic-power gluings, without choosing a graph chart in the final
statement.  The expected regular-primary exponent is

\[
 v_p(d)=\min\!\left(v_p((g-1)!),\lfloor\log_p h\rfloor\right)
\]

for cyclic Jordan height `h`, but this remains conjectural.  Prove or refute it
structurally, then extend to mixed primary blocks and state the elementary
divisors of the full graded defect.

The current exact reduction is to the mixed-cofactor lattice of the congruence
centralizer.  Its cyclic shadow is the Connes/de Rham map
`d(u^n)=n u^(n-1)du`; the missing theorem is a global
complete-antisymmetrizer / marked-open-chain comparison that respects carry,
Frobenius units, bilinear type, and unramified descent.  A termwise square or
Pluecker switch is false.  The complete quotient is not cyclic homology.

Acceptance-grade outcomes:

- a chart-independent classification theorem with exact elementary divisors;
- unbounded exact `p^r` defect on polarized-indecomposable ppavs, with a human
  construction; or
- a sharp counterexample forcing a corrected invariant, followed by the
  corrected theorem.

### C. Other non-diluting crowns

Pursue only if A and B are genuinely blocked:

- a general semisimple-versus-nilpotent gluing theorem making the
  semisimple-slope primitivity result an iff classification;
- a reusable integral inverse-Lefschetz theorem for resolved theta divisors,
  explicitly beyond the rational results of Diaz/Kunnemann and the etale or
  factorial-inverted results of Kahn/Rosas-Soto/Hasan et al.;
- a structural classification of which polarization gluings admit primitive
  ordinary divisor-product minimal classes, with the exotic `F_4` cubic
  gluing as a positive exceptional example and explicit negative boundaries.

## Current status (2026-08-15)

**Positive result, independent of A/B/C.** The blown-up theta divisor
`M = Bl_0 Theta` has an integral lattice theorem: `H^3(M,Z)` is torsion-free of
rank 130, a nonsplit extension of `H^3(X,Z)` by `∧³Λ` glued by an explicit
isomorphism `ρ: H^3(X,Z)⊗F_2 → Sat/L_3∧³Λ`; `b_*H^3(M,Z)` is exactly the
saturation `Sat` of `Θ∧∧³Λ` in `∧⁵Λ`, of index `2^10`; the transfer `q_*μ*`
from `H^3(F×F,Z)` is integrally surjective, so the whole lattice comes from
the Fano surface through the degree-six model; and the escape group
`E = H^5(M,Z)/(b^*H^5(J,Z)+tors)` is **free** of rank ten — correcting pass-2's
`(Z/2)^10` misidentification — with `E/2E ≅ (Z/2)^10` explaining all four prior
`(Z/2)^10` coincidences as shadows of `H^3(X,Z)⊗F_2`. A hostile proof audit and
a bounded priority audit (no prior source computes the cohomology of `Θ` or
`Bl_0Θ` for a cubic threefold) both passed. **This theorem is a candidate for
its own paper; that scoping decision is pending with the user.**

**Priority-A `(1,5)` channel-population question is closed negative.** Every
named source — pullbacks from `J×J`, exceptional-divisor cycles, the
span/incidence dictionary, `c_4` of either the span model or the `ℰ`-model —
is excluded: `λ_𝒢 = λ_ℰ = 0`. Byproduct: codimension-four sheaf defects can
never affect a mod-two `c_4` readout. The `(2,4)` channel is untouched.

**Two live debts on prior C908 work.** (1) The pass-5 twist lemma's rank-three
branch is false on the corrected lattice (an explicit witness refutes it); the
item-F argument doesn't need that branch, but the lemma's other use — the
relative Ext object `E` on `M×M`, at ranks other than three — is not repaired
and still rests on the refuted step, weakening (not voiding — Theorem C covers
pencil-defined classes) the `{0,I}` pinning there. (2) The λ-reduction note's
claim that the span-model sheaf doesn't descend along the degree-six map `q`
is false; correcting it strengthens the verdict chain, but the wrong statement
still stands in the report text.

**Against this card's acceptance criteria:** priority A remains undecided (no
odd horizontal multisection constructed; the accumulated negatives exclude
named sources without yet defining and computing a canonical two-primary
obstruction class on the exotic marked base). Priority B is untouched. The
lattice theorem is the strongest result in hand but lands in the non-diluting
band C, not A or B — the genuine-block clause has not triggered.

Reports: `notes/2026-08-12-c908-h3-lattice-adjudication.md`,
`notes/2026-08-12-c908-h3-compression.md`,
`notes/2026-08-12-c908-z2-naturality-checks.md`,
`notes/2026-08-12-c908-lambda-reduction-and-verdict.md`,
`notes/2026-08-12-c908-e-model-mutation-comparison.md`; audits
`notes/2026-08-12-c908-h3-lattice-proof-audit.md` and
`notes/2026-08-12-c908-h3-lattice-priority-audit.md`; the pass-8 correction of
record is `notes/2026-08-11-c908-h3-resolution-lattice-correction.md`; earlier
passes `notes/2026-08-11-c908-universal-family-even-rigidity.md`,
`notes/2026-08-11-c908-transfer-liveness-and-span-incidence.md`,
`notes/2026-08-11-c908-span-incidence-parity-no-go.md`,
`notes/2026-08-11-c908-fano-schubert-restriction-extraction.md`,
`notes/2026-08-11-c908-unordered-degree-normalization.md`, and
`notes/2026-08-11-c908-unmarked-closure-and-w-twist.md`.

## Closed or quarantined routes

Do not spend a pass rediscovering any of the following.

- More divisor saturation, six-axis averaging, elliptic-curve support, or
  Pontryagin/Fano numerical tests: the full relevant ideals are even.
- Canonical BdGF `P^3/3!`, graph-dressed divisor cubes, or BdGF divided
  squares: the complete `(1,5)` image is `2 End(J)`.
- One-step universal-family Chern / cubic-projector constructions: their odd
  leg retains the independent `Theta^2=2 Theta^[2]` factor.
- Exotic `C3`, `C2`, or full `S3` monodromy as a parity obstruction: odd
  invariant cohomology survives in both live mixed channels.
- Ordered-pair intersection numbers, degree-fifteen numerology, or matching
  rational equivalence: these do not decide the Chow index.
- Charge-two Hecke/fixed-line/type-`(5,1)` conics: their residue has exact
  index two on general ample support surfaces.
- Direct GHS/Steinberg/RSC slogans: the required field has too large a
  transcendence degree or the published freeness/very-twisting hypotheses are
  absent.  Voisin's visible residual curves are nonfree on the smooth open.
- Importing the Bridgeland theta-resolution fourfold or LLPZ primitive moduli
  as the classical charge-three `M_9` fibre: numerical classes and dimensions
  rule out that identification.
- Termwise Hochschild/cyclic or local switch reductions for the gluing defect:
  the determinant contributions do not vanish termwise.
- Further bounded SNF searches unless they test a precise structural lemma or
  seek a counterexample to a stated conjecture.  Certificates may validate a
  theorem after the human mechanism is found; they are not the theorem.

## Required method

1. Read `../AGENTS.md`, the current C904 handoff, and the named authority notes
   below before acting.
2. Freeze one exact theorem or obstruction target at the start of each pass.
3. Use primary sources under `notes/literature-audit-conventions.md`; record
   theorem loci, read depths, versions, cache identities, and access gaps.
4. Prefer coordinate-free reductions and human proofs.  Use Nix, `uv`, Sage,
   or SymPy only for bounded falsification and independent normalization.
5. After each result, run a hostile proof audit and a bounded priority audit.
6. Write durable notes and replay artifacts, but make no manuscript, PDF,
   mirror, Lean, or reviewer-dossier edits.
7. Do not claim Annals novelty from a finite computation.  Calibrate venue only
   after the structural theorem and predecessor boundary are both closed.

## Acceptance criteria

The task remains live until one of these occurs:

- **Positive Chow crown:** an odd generic multisection or relative minimal
  cycle is constructed and descended, closing the relative universal-cycle
  theorem.
- **Negative Chow crown:** a canonical nonzero two-primary obstruction is
  defined and computed, with a proof of its exact relation to the generic
  index and minimal splitting extension.
- **Integral classification crown:** the full intrinsic `p`-typical gluing
  classification is proved, including unbounded indecomposable examples or a
  comparably sharp corrected theorem.
- **Genuine block:** three consecutive bounded passes reach the same precise
  external or mathematical obstruction with no meaningful theorem-level
  progress; report it under the goal-blocking rules rather than filling space
  with another census.

## Starting authority notes

- `notes/clebsch-tasks/c904-paper-v-publishable-round-trip.md` (current long
  ledger and supersession map);
- `notes/2026-08-10-c904-common-line-unordered-shen-route.md`;
- `notes/2026-08-10-c904-shen-voisin-function-field-descent-audit.md`;
- `notes/2026-08-11-c904-symmetric-theta-full-kunneth-parity.md`;
- `notes/2026-08-11-c904-relative-invariant-cycle-franchetta-audit.md`;
- `notes/2026-08-11-c904-exotic-deck-kunneth-descent.md`;
- `notes/2026-08-11-c904-ample-cut-charge-two-index.md`;
- `notes/2026-08-11-c904-bdgf-theta-and-full-ns-p15-audit.md`;
- `notes/2026-08-11-c904-universal-pi3-gamma-parity.md`;
- `notes/2026-08-11-c904-regular-primary-ghost-bridge-reduction.md`;
- `notes/2026-08-11-c904-open-chain-cyclic-complex-audit.md`;
- `notes/2026-08-11-c904-local-switch-cyclic-readout-counterexample.md`;
- `notes/2026-08-11-c904-adjacent-annals-crown-audit.md`.

## Suggested invocation

`go C908 — Annals-upgrade mathematics: attack the intrinsic relative Chow
index first; if it does not admit a structural entry, pivot to the intrinsic
p-typical gluing classification.  Math only: no paper, PDF, mirror, Lean, or
review-dossier edits.`
