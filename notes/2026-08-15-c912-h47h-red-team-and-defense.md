# Hypothesis 4.7H — red team and defense

**Date:** 2026-08-15 · **Lane:** `cubic-threefolds` · **Task:** C912

**Purpose.** Adversarial assessment of Hypothesis 4.7H of
`papers/cubic-stabilization-epilogue/`, together with the strongest defense the
evidence actually supports. Every evidence item carries its provenance and the
precise reason it is valid. Nothing here is asserted from the lane's own summary
sentences: each mechanism below was re-derived and checked against the stated
source line.

Companion audits, written for this pass:

- Evidence ledger: `2026-08-15-c912-h47h-evidence-ledger.md`
- Source-exactness audit of imported claims:
  `2026-08-15-c912-h47h-source-exactness-audit.md`

---

## 1. The hypothesis, and what it is really quantified over

**Statement.** `papers/cubic-stabilization-epilogue/sections/04-one-step.tex`,
lines 409–425, environment `hypothesisH`, "Reconstruction-displacement
invariance". After the coefficient specialization displayed in the relevant
construction, replacing zero bulk by one of the positive-filtration bulk
displacements occurring in (1) the blowup and projective-bundle decompositions
of `prop:framed-operations`, or (2) the divisor-tagging family of
`lem:divisor-tagging`, does not change the algebraic multiplicities of
`e^{iπ/3}` and `e^{-iπ/3}` in framed formal monodromy on the original `z`-disc.
Invariance under an arbitrary bulk displacement is explicitly not asserted.

**What it actually quantifies over.** The hypothesis reads as a short, closed
list of displacements. It is not. `thm:nu6-birational-invariance`
(`sections/04-one-step.tex`, lines 1011–1046) proves birational invariance by
running weak factorization through blowups and blowdowns with smooth centers,
and applies the operation formulas of `prop:framed-operations` at **every
intermediate smooth fourfold** of that factorization. So clause (1) is a
universally quantified statement over every smooth projective fourfold arising
in every weak factorization in dimension four, and therefore over arbitrary
block structure of the small even quantum connection. The memo says this in as
many words: "the draft's own presentation needs the same statement at every
intermediate fourfold of a weak factorization, and that is a statement about
arbitrary blocks" (`2026-08-15-c912-frame-transport-memo.tex`, lines 1881–1883).

This is the single most important fact for a referee. The hypothesis is
presented with the scope of a technical normalization and has the scope of a
general theorem about quantum connections.

---

## 2. Evidence for the hypothesis

Each item: provenance, mechanism, validity class, and the gap between what it
proves and what the hypothesis needs.

### E1 — Bulk local constancy, with the bulk kept formal

- **Provenance.** `2026-08-15-c912-frame-transport-memo.tex`,
  `thm:bulk-constancy`, lines 1911–1948. Generalizes the argument in Cai's own
  proof of his Proposition 6 (arXiv:2608.01577v1).
- **Mechanism, and why it is valid.** Solve `∂_{t_i} M = -z^{-1} P_i M` with
  `M|_{t=0} = I` recursively; `M = I + O(t)` is invertible for free. By
  construction `M^{-1}∇_{t_i}M = ∂_{t_i}`, and because the bulk connections
  commute with `∇_z`, the conjugated `z`-connection `M^{-1}∇_z M = ∂_z + L`
  has `∂_{t_i}L = 0`, so `L` is the connection at the base point. Every entry
  of `M` is a Laurent series in **integral** powers of `z`, so the turn `σ`
  fixes `M`; hence `σ(MY) = (MY)M_f` with the *same* framed matrix. The framed
  monodromy is therefore literally the same matrix in the deformed solution
  frame.
- **Validity class.** PROVED — for every smooth projective target, every block
  type, no (H1), no rank restriction.
- **Scope delta — and this is the whole point.** It is a statement over
  `Λ[z,z^{-1}][[t]]` with `t` a **formal variable**. The hypothesis needs the
  conclusion after `t` is **specialized** to a specific element of the
  coefficient ring carrying Novikov coefficients. E1 does not license that
  substitution, because the gauge `M` has `z`-order unbounded below as bulk
  degree grows.

**Consequence for the defense.** The invariance is a theorem in full generality
in the formal direction. Everything at issue is the legitimacy of one
substitution. That is a genuinely narrow residue, and it is fair to say so.

### E2 — The framed count is carried only by coalesced blocks

- **Provenance.** Memo Section 7, `thm:simple-blocks` region, lines 1004–1050.
- **Mechanism.** Self-adjointness of `E⋆` and anti-self-adjointness of `μ` for
  the Poincaré pairing force every block residue to be traceless with spectrum
  symmetric about zero, and to vanish outright on every multiplicity-one block.
  A vanishing residue gives monodromy eigenvalue `1`, never a primitive sixth
  root.
- **Validity class.** PROVED-UNCONDITIONAL.
- **Scope delta, and a warning.** This makes the hypothesis *automatic*
  wherever the small even quantum connection is semisimple at the relevant
  point — but only because `ν_6 = 0` there. Along the weak factorization the
  transported value is `4`, not `0`, so **every intermediate fourfold the
  hypothesis is applied to necessarily has a coalesced block carrying the
  count**. The class where the hypothesis is free is exactly the class the
  application never meets. This item is therefore a reduction, not a defense.

### E3 — Within a rank-two coalesced block the eigenvalue never splits

- **Provenance.** Memo `thm:no-splitting`, lines 1248–1265.
- **Mechanism, checked here.** `[U, C_a] = 0` forces the leading bulk
  coefficient into the commutant of a regular `2×2` matrix, which is free on
  `I` and `N`; so `C_{a,0} = p_a I + q_a N` (`lem:commutant`, lines 1231–1244).
  Block evolution then gives `D_a N = q_a N + q_a[N, μ_0]`. For `d = det N`,
  differentiating and using `adj(N) = -N` for traceless `2×2` kills the
  commutator term — `tr(-N[N,μ_0]) = -tr(N²μ_0) + tr(N²μ_0) = 0` — leaving
  `∂_a d = 2 q_a d` with `d(0) = 0`. On `B = Λ[[τ]]` that forces `d ≡ 0` by
  induction on Taylor order. **Verified independently in this pass.**
- **Validity class.** PROVED under (H1).
- **Why it matters.** Block splitting is the one mechanism that would drop
  `ν_6` by two. In rank two it is excluded outright, not assumed away.

### E4 — Regular singularity after shearing is automatic, for every target

- **Provenance.** Memo `thm:h2-automatic`, lines 1404–1423, resting on
  `lem:duality-gauge`, lines 1358–1388.
- **Mechanism, checked here.** The Frobenius property gives
  `A(-z)^T G + G A(z) = 0`. The decoupling gauge `g = I + O(z)` is unique;
  its pairing-adjoint `h = G^{-1}g(-z)^{-T}G` is again `I + O(z)` and again
  block-diagonalizes, so uniqueness forces `h = g`, which unwinds exactly to
  `g(-z)^T G g(z) = G` — the gauge is an isometry. The parity rule follows
  coefficientwise: `N` and odd coefficients `G_0`-self-adjoint, even
  coefficients `G_0`-anti-self-adjoint. Then `N² = 0` (from E3) makes `im N`
  isotropic, so `(e_1,e_1) = 0` and nondegeneracy gives `(e_1,e_2) ≠ 0`; and
  anti-self-adjointness of `A_0'` against a *symmetric* form gives
  `(A_0'x, x) = 0`, which at `x = e_1` reads `f·(e_2,e_1) = 0`, hence `f = 0`.
  **Verified independently in this pass, including the isometry unwinding.**
- **Validity class.** PROVED-UNCONDITIONAL for every rank-two coalesced block of
  every smooth projective target, pointwise on the germ.
- **Why it matters for the referee.** This was previously a standing hypothesis
  (H2) verified for the cubic by inspecting a diagonal `D_0`. It is now a
  theorem, and general. The single strongest answer to "you only checked your
  own example" is that the step which looked like an accident of the cubic was
  proved to be forced.

### E5 — The exponents are constant, and the cubic case of the hypothesis is a theorem

- **Provenance.** Memo `thm:rigidity` (lines 1470–1487) and
  `cor:cubic-closed` (lines 1489–1505).
- **Mechanism.** With `A_{-1} = 0` and `K_a = 0` (E4 and
  `thm:no-irregularity`, lines 1427–1456), the `z^0` coefficient of the
  flatness identity collapses to `∂_a R = [R, G_a]`. A matrix moving by
  infinitesimal conjugation has constant characteristic polynomial. So the
  coefficients of that polynomial lie in `Λ` and do not depend on `τ` at all —
  **and therefore specialization is substitution into constants**, with no
  gauge, no receiver, and no convergence question.
- **Validity class.** PROVED under (H1); for the cubic, (H1) holds with
  `u_0 = 0` and the other eigenvalues `±6r`, `r = (3q)^{1/2}`.
- **Arithmetic checked here.** `ρ² + ρ + 5/36` has roots `(-1 ± 2/3)/2 =
  -1/6, -5/6`; `exp(2πi·(-1/6)) = e^{-iπ/3}` and `exp(2πi·(-5/6)) = e^{iπ/3}`,
  both primitive sixth roots, so the block contributes exactly `2`. The
  documented failure mode `±1/18` gives `e^{±iπ/9}`, of order 18, contributing
  nothing — confirming that the `z²` coefficient folded in by the shearing is
  genuinely load-bearing and is exactly what `thm:rigidity` freezes.
- **Frame check.** The shear `diag(1, z)` moves exponents by integers only;
  `{-1/6, -5/6} ≡ {-1/6, +1/6} mod ℤ`, which reconciles exactly with Cai's
  `±1/6` for the big quantum connection. No frame jump at this junction.
- **Scope delta.** Rank-two nonderogatory coalesced blocks satisfying (H1), on
  the formal even bulk germ. Explicitly **not** covered, per the memo's own
  lines 1872–1876: derogatory blocks (commutant larger than `B[N]`, the
  commutant step fails at once), semisimple blocks with a resonance
  `ρ_i - ρ_j = -1`, and Jordan blocks of size `≥ 3`.

### E6 — Independent-direction numerical support

- **Provenance.** `2026-08-15-c912-gm-genus-six-serre-test.md` with committed
  script and output; `2026-08-15-c912-det-r-pairing-and-serre-lattice.md`.
- **Content.** The count is identified with the number of primitive-sixth
  eigenvalues of the Serre operator on the numerical K-group of the Kuznetsov
  component. That quantity is a discrete lattice invariant with **no bulk
  parameter at all**, so if the identification holds, invariance is automatic
  for structural reasons. The sharpest available falsification test passed:
  for the genus-six Gushel–Mukai threefold `N(Ku) = ⟨-1⟩ ⊕ ⟨-1⟩` with symmetric
  Euler form, Serre operator the identity, count zero — matching the lane's
  provisional zero. The same computation, run from Riemann–Roch with no
  external Euler matrix, reproduces the whole prime-Fano census.
- **Validity class.** VERIFIED-COMPUTATIONALLY for the census;
  the identification itself is CONSISTENCY-CHECK-ONLY — recorded as expected
  rather than proved (mystery ledger C912-M25).
- **Frame caution.** The identification carries a sign convention `λ → -λ`
  (the shift `[1]`) between the census's reduced factorial cyclotomic
  polynomial and the Serre side, and an offset between the Hodge-atom Serre
  automorphism in the cohomological grading and the categorical Serre functor
  on a K-group (C912-M26, C912-M27). Support of this kind is only as good as
  the convention bookkeeping; see the source-exactness audit.

### E7 — Any `H⁰` component of a displacement is exactly invariant

- **Provenance.** `2026-08-15-c912-section10-hostile-referee.md`, second pass,
  "The string equation is exact here, and needs no smallness"; used by the
  manuscript for the unit term at `sections/04-one-step.tex`, lines 307–311.
- **Mechanism.** The string equation kills all but the exceptional term, so
  `⋆_{τ+c1} = ⋆_τ` identically for any `c` in the coefficient ring. The Euler
  field gains exactly `c·1`, so `E⋆` gains the scalar `c·id`; adding a scalar to
  `U` translates every exponential factor by the same `c/z` and leaves every
  spectral projector, block and residue untouched.
- **Validity class.** PROVED-UNCONDITIONAL. `c` may be a **unit** of the
  Novikov ring — no nilpotence is required. This is the one place where "exact,
  no smallness" is literally true.
- **Scope delta.** Disposes of the `H⁰` component in all three reconstruction
  use sites. Leaves the `H²` component (E8's companion, the divisor
  substitution) and the `H^{≥4}` tail plus `s_j`, which is the live obligation.

### E8 — For `X × P¹` the entire reconstruction displacement is an `H⁰` shift

- **Provenance.** Same report, "CLAIM A: SURVIVES", with Iritani–Koto
  arXiv:2307.03696 §5.3 stationary phase, the quantum Riemann–Roch asymptotic,
  and (5.11) as locators.
- **Mechanism, two independent routes.** (i) For a trivial bundle every Chern
  root vanishes, so the modified quantum Riemann–Roch operator is a scalar in
  `(λ, z)` with strictly non-negative `z`-powers; the stationary-phase
  `z`-count then forces `[z^{-1}]log(...) = 0`, and Iritani–Koto (5.11) gives
  `ς_j° = rλ_j` exactly — no `H²` term, no `H^{≥4}` tail. (ii) Independently,
  `P(O_X^{⊕2}) = X × P¹` and small quantum cohomology of a product is the
  tensor product, so the generalized eigenspace at `rλ_j` is `H^*(X) ⊗ v_j`;
  the compressed grading numbers `tr(P_jμ)` are degree zero, permuted by the
  deck action, hence all equal, and sum to `tr μ = 0`, hence each is zero. The
  `j`-th summand is therefore the quantum D-module of `X` at a bulk parameter
  lying in `H⁰`.
- **Validity class.** PROVED-UNCONDITIONAL for the trivial rank-two bundle, by
  two independent routes, at the canonical base point inside the germ where
  Iritani–Koto Theorem 5.1 lives. Combined with E7 this gives
  `ν_6(X × P¹) = 4` **with no use of Hypothesis 4.7H**.
- **Scope delta.** Covers the projective-bundle site only for `c_1(V) = 0` and
  `V` trivial. For `c_1(V) ≠ 0` the exponential factor is present and the
  quantum Riemann–Roch operator is cohomology-valued, so neither route runs.
  Covers nothing of the blowup centre or ambient sites.
- **It also strikes an earlier pessimistic claim** in the memo (lines 771–774)
  that even `X × P¹` carries an `O(q^{-1/r})` tail. That was an inference from
  the `O(·)` symbol, which carries no information about `[z^{-1}]log`, and
  should be struck from the memo.

### E9 — The divisor-tagging clause sits in the ring where E1 already applies

- **Provenance.** Evidence ledger `2026-08-15-c912-h47h-evidence-ledger.md`,
  sections A.5 and A.6, against `sections/04-one-step.tex`.
- **Content.** The divisor-tagging family deforms over `k_χ[[t]]` — formal
  parameters over an algebraically closed field — which is exactly the setting
  of `thm:bulk-constancy` (E1). The three reconstruction sites instead deform
  over a non-field Novikov monoid completion with an `O(q^{-1/(c-1)})` tail.
  Nothing transfers between the two classes.
- **Why this matters.** Clause (2) of the hypothesis is not in the same
  difficulty class as clause (1). It looks close to provable with the argument
  the lane already has, unimported. That is the cheapest available reduction of
  the hypothesis's surface area.

### E10 — The `H²` component is disposed of by a coefficient automorphism

- **Provenance.** `sections/04-one-step.tex`, lines 629–632 and 769–770, with
  (4.1) at 293–297; confirmed at source level in
  `2026-08-15-c912-framing-compatibility-checks.md` §3, ledger row C912-M17.
- **Mechanism.** `Q^d ↦ e^{⟨a_2°,d⟩}Q^d` is a `z`-constant coefficient
  automorphism fixing `ℂ`, so it cannot move the roots-of-unity multiplicities
  of a characteristic polynomial.
- **Validity class.** PROVED-UNCONDITIONAL.
- **Owed.** One manuscript sentence citing Iritani–Koto (5.11)–(5.12),
  respectively Iritani §5.8.1, as the normalization fixing the logarithmic
  constant. Cheap, and unwritten.

---

## 3. Red team

### R1 — The proved case is the easiest one, and not the one the application needs

The only unconditional closure of the hypothesis's content at a *specialized*
parameter is E5, for rank-two nonderogatory blocks. The application needs it at
every intermediate fourfold of a weak factorization, where the block structure
is arbitrary (Section 1 above). Worse, by E2 those intermediate fourfolds
*must* carry coalesced blocks, since the transported value is `4`. So the
manuscript proves an instance and hypothesizes the class, and the class is
precisely where the proof method is known to stop.

### R2 — The gauge-transport route does not merely stall; under the draft's own normalization it fails

This is the sharpest finding of this pass, and it comes from the memo's own
analysis rather than from any outside objection.

- **Provenance.** Memo Section 6, "The two rates" (lines 463–495), "The
  criterion is not an artifact of choosing an order" (lines 497–505), and "The
  criterion depends on a normalization the draft may choose" (lines 507–542).
- **Mechanism.** Two gauges are involved. The pro-Laurent bulk gauge *gains*
  one filtration unit per unit of `z`-pole. The Levelt–Turrittin splitting
  gauge *loses* `w(Δλ)` per unit of `z`-power, one division by an eigenvalue
  difference per order. Transport requires forming the product `G·P`, whose
  `z^n` coefficient is `Σ_m g_m p_{n+m}` with terms of weight at least
  `m(1 - C) - nC`, where `C = e·w(Δλ)/ε`. For `C ≥ 1` infinitely many terms
  have bounded weight, so **that coefficient is an infinite sum in no
  completion, ordered or not**. This is not a well-ordering technicality; it is
  a genuine non-existence.
- **The damaging part.** With the draft's normalization (`ε = 1` always, Novikov
  generator weights growing linearly in the separating parameter `L`), the memo
  records: "Under the draft's instruction to choose `L` 'so large that'
  separation holds, the criterion fails at essentially every comparison with two
  distinct exponential factors — **including the cubic endpoint**." And
  independently of `L`, `c_1·d_0 ≥ 2` is necessary, so **Fano index one fails
  outright**.
- **What it kills.** Any defense of the hypothesis of the form "the transporting
  gauge exists". It does not, under the stated normalization. The hypothesis
  must be defended by the gauge-free route (E5) or not at all — and that route
  is rank-two only. A referee who reads Section 6 of the memo will reach exactly
  this conclusion.
- **Available repair, not yet taken.** Choose the separating weight minimally
  rather than large and check `e·w(Δλ) < ε` case by case; for a projective
  bundle with `c_1(V)·ℓ = 0` one may take `L = 1`, giving `ε = 1` and
  `w(Δλ) = 1/2`. This is a concrete, checkable program, not a hope.

### R3 — Control on the eigenvalue gap is lost exactly where it is needed

Memo lines 487–489: `w(Δλ)` "is not controlled by `w(λ)` when the Picard rank
exceeds one, since `w` and the quantum grading are different functionals and
leading terms can cancel." Every ambient in the relevant weak factorization has
Picard rank at least two — `X × P¹` already does, and each blowup raises it
again. So the one case where the convergence criterion of R2 is uncontrolled is
the only case the application ever meets. A referee should press hard here.

### R4 — The hypothesis was carved to fit the hole

Hypothesis 4.7H was introduced on 2026-08-15, immediately after an attempted
unconditional proof of the endpoint was refuted. Its statement quantifies over
"the positive-filtration bulk displacements that occur in the arguments below" —
it is defined by reference to what the proof consumes, not by an independently
meaningful condition on quantum connections. That is legitimate and precise, and
it is also exactly the shape a referee is trained to distrust. The paper should
expect to be asked what independent reason there is to believe it, and the
answer must be E1, E3, E4, E5, not the fact that the theorem needs it.

### R5 — The refuted proof attempt, and what it does and does not imply

- **Provenance.** `2026-08-15-c912-section10-hostile-referee.md`, verdict FATAL.
- **What was wrong.** The claimed unconditional route demanded
  `s_j = -ς_j^0`, setting a formal variable of a completed ring equal to a
  unit-order element `∓2q^{1/2} + O(q^{-1/2})`. Iritani–Koto's invertibility
  statement is for the displaced coordinates treated as independent formal
  variables; Iritani's Lemma 5.15 is a formal inverse function theorem at
  `Q = θ = 0`, licensing nothing at a non-nilpotent displacement.
- **Fair reading.** This refutes a proof, not the hypothesis. It is also
  *evidence of process*: the error was found by an internal adversarial pass, and
  the response was to name the assumption rather than to keep asserting it.
- **But.** It shows the lane has already once mistaken a formal-germ identity
  for a pointwise one in exactly this corner of the argument. That is a reason
  for a referee to demand that the germ/pointwise boundary be stated explicitly
  at every use of Hypothesis 4.7H, not merely at its statement.

### R6 — Two use sites bundled as one hypothesis

Clause (1) (reconstruction-coordinate displacement in the blowup and
projective-bundle decompositions) and clause (2) (the divisor-tagging
exponential family) are different mathematical objects. Bundling them under one
label makes the hypothesis look smaller than it is, and evidence for one is not
evidence for the other. Note also mystery-ledger item C912-M18: the sources'
centre F-bundle is itself built on a collapsed Novikov variable, "so the framing
theory can never certify an intrinsic centre invariant" — a structural caution
sitting directly beside the divisor-tagging use. Recommend splitting into 4.7H(a)
and 4.7H(b) with separate evidence.

### R7 — A recorded case where the count does move

Mystery-ledger C912-M21, open: at `q_2 = 27q_1` two simple sheets coalesce at
value zero, "so the count can rise there." The lane argues this is harmless for
the lower bound the one-stabilization theorem needs, but records it as "a real
gap in any equality form of birational invariance of the count." Hypothesis
4.7H is stated as an equality of algebraic multiplicities, and
`thm:nu6-birational-invariance` is an equality. A referee is entitled to ask
whether the displacement families of 4.7H can meet that locus. The lane's
answer — that the formal germ is caustic-free by a filtration argument, meeting
another sheet only at `4q_2 = 27q_1` (C912-M20) — is what verifies (H1), so the
two questions are the same question. It should be stated that way in the paper.

### R8 — Two different topologies on overlapping objects, reconciled nowhere

**This is the highest-value open item in the file, and it may mean the
hypothesis is not yet well-posed rather than merely unproved.**

- **Provenance.** Evidence ledger, junction C-J1, combining
  `2026-08-15-c912-section10-hostile-referee.md` finding R4 and finding F1 with
  the manuscript's own weight definition at `sections/04-one-step.tex`, lines
  499–514.
- **The break.** `cor:cubic-closed` extends Section 8's germ statement to "any
  bulk parameter in the positive filtration" on the ground that evaluation at a
  topologically nilpotent parameter is legitimate. The hostile referee's R4
  answers that `τ`-constancy removes the need to *transport* the polynomial but
  does not put the displacement point *inside the germ*, so Section 8 gains a
  gauge-free proof and no enlargement of the domain of validity. F1 then
  supplies the reason: under Iritani's graded completion and Iritani–Koto
  Remark 5.3, `q^{±1/s}` is a **unit**, so the `H⁰` part, the `H²` constant and
  the `H^{≥4}` tail all fail topological nilpotence in the sources' topology.
- **And the counter-observation, which is what makes this decisive rather than
  simply fatal.** The manuscript does not use Iritani's graded completion for
  its filtration. It defines its own additive weight with `w(u) = 1`,
  `w(s_{j,ℓ}) = 1`, under which `u = q^{-1/(c-1)}` **is** topologically
  nilpotent by construction. So the manuscript and the refutation are working
  in two different topologies on overlapping objects, and the sources'
  invertibility and pullback statements are proved in the topology where the
  roots of `q` are units. Nothing in the audited set reconciles them.
- **What it kills, and what it does not.** It kills the claim that Section 8
  discharges the reconstruction use sites. It does not establish that the
  hypothesis is false. Until the manuscript's weight topology is shown
  compatible with the sources' graded completion, the hypothesis's own phrase
  "positive-filtration bulk displacement" does not have a single agreed meaning
  across the paper and its imports — which is a well-posedness defect, not a
  gap in a proof. **This is the one statement the paper most owes a referee.**

### R9 — Even the cubic's own carrier stops being rank two on a nearby locus

- **Provenance.** Evidence ledger section D, from
  `2026-08-15-c912-m1-ambiguity-computation.md`.
- **Content.** At `q_2 = 27q_1` two simple sheets coalesce at value zero,
  creating a coalesced block out of blocks that carried nothing — so the count
  can *rise* (ledger row C912-M21, open). At `4q_2 = 27q_1` the carrier becomes
  **rank three**, and the hypotheses of the rigidity theorem lapse entirely;
  settling that needs exactly the size-`≥ 3` machinery the memo says does not
  exist. Both loci are argued absent from the Novikov germ by a filtration
  argument — which means they matter precisely insofar as R8 does. The same
  filtration claim is doing double duty, and it is the claim under dispute.
- **Also unexcluded anywhere:** the resonance `ρ_i - ρ_j = -1` for semisimple
  coalesced blocks.

### R10 — A supporting lemma of the memo's own transport framework is false in range

- **Provenance.** Evidence ledger findings D2 and D3.
- **Content.** The transport theorem of the memo's Section 2 has **no verified
  instances in the application**, and the Constants Lemma it rests on is false
  once Novikov-coefficient exponentials are admitted, with an explicit
  counterexample on record. Separately, the earlier claim that the convergence
  criterion of R2 is scale invariant is refuted, and the criterion is
  `L`-dependent in the direction that hurts the manuscript's own instruction to
  choose `L` large.
- **What it kills.** Any residual hope of defending the hypothesis through the
  memo's general transport machinery. Only E1 (formal direction), E7/E8/E10
  (exact, componentwise) and E5 (gauge-free, rank two) survive as load-bearing.

---

## 4. The defense, as a referee should hear it

Stated at the strength the evidence supports, and no higher.

1. **The invariance is a theorem in the formal direction, in full generality.**
   For every smooth projective target and every block type, framed monodromy is
   constant on the formal germ of the bulk base (E1). Nothing about the
   hypothesis is in doubt as a statement about formal deformation.

2. **The entire residue is the legitimacy of one substitution** of a specific
   positive-filtration element into a formal identity. *This point must be made
   carefully, and the first version of this report overstated it.* It is
   tempting to say the substituted element is topologically nilpotent and so the
   substitution is the mildest possible. That is true in the manuscript's own
   weight `w`, and false in the sources' topology — see R8, which is now the
   highest-value open item in the whole file.

2b. **Two of the three use sites are already discharged, or nearly so.** The
   projective-bundle displacement for `X × P¹` itself is an `H⁰` shift and is
   exactly invariant by the string equation, with no smallness hypothesis and no
   use of 4.7H at all (E7, E8). The divisor-tagging clause deforms over a formal
   power series ring on an algebraically closed field, which is precisely the
   hypothesis of the general formal-constancy theorem E1 — so it is close to
   provable today, and the manuscript simply never imports the argument (E9).

3. **The one mechanism that could falsify it is identified and excluded in the
   proved case.** Only coalesced blocks can carry the count (E2), and within a
   rank-two coalesced block the double eigenvalue provably never splits on the
   germ (E3). The failure mode is not unexamined; it is named and killed where
   the proof reaches.

4. **The step that looked like a lucky feature of the cubic was proved to be
   forced.** Regular singularity after shearing holds for every rank-two
   coalesced block of every smooth projective target, from the Frobenius
   property alone, pointwise on the germ (E4). This is the direct answer to
   "you verified your own example."

5. **In the proved case the hypothesis is not merely plausible but true, by a
   route that never forms the divergent object.** The characteristic polynomial
   of the residue has coefficients in `Λ`, constant in the bulk, so
   specialization is substitution into constants — no gauge, no receiver, no
   convergence (E5). The cubic's own count of `2` is obtained this way at every
   bulk parameter including a specialized one.

6. **An independent, parameter-free reformulation predicts the same values and
   survived its sharpest test** (E6), with the caveat that the identification is
   expected rather than proved.

**What the defense cannot claim.** That the hypothesis holds at arbitrary
intermediate fourfolds; that the transporting gauge exists (R2 says it does not,
under the draft's normalization); or that the rank-two mechanism extends as it
stands (memo lines 1839–1844 explicitly retract that expectation — duality
removes only the deepest pole coefficient, so for `m ≥ 3` it is one condition out
of a growing family).

---

## 5. What would close it

In priority order, with the memo's own program (lines 1846–1876, and Section 6's
repair) as the base.

0. **The normalization statement of R8, before any of the rest.** Show that the
   manuscript's additive weight `w` (with `w(u) = 1`, under which `u` is
   topologically nilpotent by construction) is compatible with the graded
   completion in which Iritani's and Iritani–Koto's invertibility and pullback
   statements are proved, and in which `q^{±1/s}` is a unit. Every other item
   below is conditional on this one having an answer, and the answer determines
   whether the residual obligation is true, false, or ill-posed. Cheap items
   that should ship regardless: import the formal-constancy argument to
   discharge the divisor-tagging clause (E9); write the owed sentence fixing the
   logarithmic constant (E10); strike the memo's unsupported `O(q^{-1/r})`-tail
   claim at lines 771–774 (E8); state `ν_6(X × P¹) = 4` as unconditional (E7 +
   E8).

1. ~~**The `μ`-grading route for arbitrary Jordan size at `u_0 = 0`.**~~
   **STRUCK — the route rests on a false identity.** It proposed to use
   `[μ, U] = U` to make `H_0` for eigenvalue zero `μ`-invariant, so that
   "`A_p'` has `μ`-weight `p`" would *be* the regular-singularity condition. The
   source-exactness audit refutes the identity: `μ` implements only the
   cohomological half of the grading, while the homogeneity making `E⋆` raise
   degree by two is with respect to the total grading including
   `deg Q^d = 2c_1(X)·d`. The rule is `[μ,U]_{ij} = (1 - c_1·d)U_{ij}` on the
   `Q^d`-part, so the identity holds only in Novikov degree zero. Refuted on the
   cubic's own matrices — `[μ,U]_{12} = -12q ≠ U_{12} = 12q` — and the drawn
   consequence fails there too, since `H_0 = span_Λ{P³ - 6qP, P² - 21q·1}` is not
   `μ`-invariant. Section 8 Steps 1–7 never use the identity, so
   `cor:cubic-closed` is untouched and no proved statement depends on it; but the
   memo passage must be corrected and this route removed from the successor list.
   A replacement input at the base point for blocks of size `≥ 3` is now
   genuinely unidentified.

2. **Derogatory and resonant-semisimple blocks.** Derogatory: the commutant is
   larger than `B[N]` and the very first step fails. Semisimple: the `z^{-1}`
   equation reads `(I + ad_R)(C_{a,0} - p_a I) = 0` and the resonance
   `ρ_i - ρ_j = -1` must be excluded before the same conclusion follows. Both
   are open.

3. **Take the minimal-weight repair of R2 and check `e·w(Δλ) < ε` case by
   case**, rather than choosing the separating weight large. This is the
   cheapest concrete route and would restore the gauge argument on a stated
   domain.

4. **From the refuted attempt, the three things a repair must supply**
   (`2026-08-15-c912-section10-hostile-referee.md`): which elements may be
   substituted into the change of variables, proved from the graded completion
   rather than from the word "invertible"; invariance of the count under
   degree-zero and degree-two shifts, as a theorem about framed monodromy rather
   than a normalization; and solvability in the negative-degree coordinates with
   convergence proved degree by degree.

5. **Presentation, independent of the mathematics.** Split 4.7H into its two
   clauses; state at its statement that clause (1) is quantified over every
   intermediate fourfold of a weak factorization; and state the germ/pointwise
   boundary at each use site.

---

## 6. Verdict

Hypothesis 4.7H is substantially better supported than "we found a hole of this
shape". It has a proved general formal core valid for every smooth projective
target and every block type (E1); two of its three instances are already
discharged or nearly so, one of them unconditionally and by two independent
routes (E7, E8, E9); the `H⁰` and `H²` components of every displacement are
exactly invariant by identities rather than estimates (E7, E10); and the one
mechanism that could falsify it — block splitting — is provably excluded
wherever the argument reaches (E3), by steps that were re-derived independently
in this pass rather than taken on the memo's word (E3, E4, E5).

Three things a referee will nevertheless find, and the paper should say them
first rather than be caught with them.

1. **The scope is larger than the statement implies.** Clause (1) is quantified
   over every intermediate smooth fourfold of a weak factorization, hence over
   arbitrary block structure; and by E2 every one of those fourfolds must carry
   a coalesced block, so the easy case is exactly the case the application never
   meets.
2. **The obvious proof route provably does not converge under the paper's own
   normalization** (R2), with the loss of control landing precisely at Picard
   rank above one, which every relevant ambient has (R3).
3. ~~**"Positive-filtration bulk displacement" does not currently have one agreed
   meaning."**~~ **RESOLVED after this report's first version.** See
   `2026-08-15-c912-normalization-statement.md`. The manuscript's `J_j`-adic
   inverse limit and Iritani's graded direct-sum completion are two different
   completions of a shared subring, not contradictory ones, and the manuscript's
   three-way split of the displacement is engineered so that nilpotence is
   asserted only for the piece that can carry it. The linchpin membership claim
   at `sections/04-one-step.tex:523-527` is **verified at the source and the
   source is stronger** — Iritani (5.30) makes the residual a *polynomial* in
   `q^{-1/(r-1)}` with a forced factor, hence negative powers only. What remains
   is one base-change lemma, already on the C912 card unticked.

4. **A source-exactness gap that is nobody's fault but is still owed.** van der
   Put–Singer Chapter 3, which the manuscript cites for the algebraic
   Levelt–Turrittin classification and which closed referee A's severity-2 item,
   was NOT ACCESSIBLE in full text; it is supported at second hand only, and the
   *functoriality and uniqueness* clauses the manuscript actually invokes remain
   uncovered. Sabbah was read at arXiv v5 rather than the published Lecture Notes
   volume the bibliography names.

Net: a conjecture with real structural evidence and two independently proved
instances — not a routine technical assumption, and not an artifact of a
failed proof. The single most valuable next action is not more mathematics on
the coalesced case; it is writing the normalization statement that reconciles
the manuscript's weight topology with the sources' graded completion, because
that one statement decides whether the remaining obligation is true, false, or
ill-posed.
