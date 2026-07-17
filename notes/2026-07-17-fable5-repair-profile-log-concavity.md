# Direction: log-concavity of the pointed repair profile

**Lane**: `rp-next`

**Date:** 2026-07-17
**Status:** DIRECTION DOC. Advisory; allocates no task, changes no gate. Built on the
[independent gap review](2026-07-17-fable5-rp-next-independent-gap-review.md) (item 3) and the
[theory-gap mining ledger](2026-07-17-fable5-theory-gap-mining.md) (survivor R5), both PROVISIONAL
pending a user-launched vet. Statements of lane results below are as relayed by those documents;
each must be re-verified against the primary C-reports (especially C227) at promotion. Promotion
requires normal C-ID allocation and dedupe against the unread C239 material and the prior Fable
review notes.

## The conjecture

For a matroid `M` on ground set `E` and a nonloop `x ∈ E`, let

> `a_k(M, x)` = the number of `k`-subsets `A ⊆ E − x` (the helpers) with `x ∈ cl(A)`,

and `S_x(u) = Σ_k a_k u^k` the pointed repair profile (C227 identifies `S_x` with a Las Vergnas
perspective specialization, and expresses it as a `y`-derivative difference of the ordinary rank
polynomials of `M\x` and `M/x` — both statements to be re-verified at the source).

> **Conjecture (LC).** For every matroid `M` and nonloop `x`, the sequence `(a_k(M,x))_k` is
> log-concave: `a_k² ≥ a_{k−1} a_{k+1}`.
>
> **Conjecture (ULC), stronger.** The sequence is ultra-log-concave:
> `(a_k / C(n−1, k))²  ≥  (a_{k−1} / C(n−1, k−1)) · (a_{k+1} / C(n−1, k+1))`, where `n = |E|`.

## Context

The log-concave matroid invariants form a short and celebrated list: coefficients of the
characteristic polynomial and the broken-circuit/`h`-vector results (Adiprasito–Huh–Katz and
successors), ultra-log-concavity of independent-set counts (Anari–Liu–Oveis Gharan–Vinzant;
Brändén–Huh, via Lorentzian polynomials), and the morphism-of-matroids extensions (Eur–Huh).
`a_k(M,x)` is a natural pointed invariant with a direct operational meaning — the coefficients
count usable repair sets of each size for the coordinate `x` — and, per the mining pass, the
log-concavity question for it is **unfound in the literature** [L1/L2; the decisive check below is
unpaid]. The gap review's assessment stands: since `S_x` is built from rank polynomials of `M\x`
and `M/x`, existing Lorentzian results "may nearly close it."

Two structural remarks that shape the attack:

- **Complement form.** `a_k = C(n−1, k) − b_k`, where `b_k` counts `k`-subsets of helpers with
  `x ∉ cl(A)`. The sets with `x ∉ cl(A)` are exactly those for which `A ∪ {x}` has rank
  `rk(A) + 1`; in the free-est case (`x` a coloop) `b_k = C(n−1,k)` and `a_k ≡ 0`. Log-concavity
  of `a_k` neither follows from nor implies log-concavity of `b_k`; the complement form matters
  because `b_k` is the sequence more likely to have an existing Lorentzian handle.
- **Sanity anchor (uniform matroids).** For `M = U_{r,n}` and any `x`: `cl(A) = A` when
  `|A| < r`, and `cl(A) = E` when `|A| ≥ r`. So `a_k = 0` for `k < r` and `a_k = C(n−1, k)` for
  `k ≥ r` — a truncated binomial row, log-concave, and ULC on its support. The conjecture's
  content therefore lives strictly in non-uniform matroids; every committed cubic/harmonic profile
  in the certificate stock is genuine test data.

## Motivation

1. **Prestige mathematics:** a new member of the log-concave family, with — uniquely among its
   siblings — an engineering-legible meaning. The one-sentence version, "the Lorentzian machinery
   governs erasure repair," travels further outside mathematics than anything else the program
   holds.
2. **Every outcome is a win, tiered below.** Even a counterexample is a publishable structural
   fact about repair profiles (the family would then join the short list of natural matroid
   sequences that *fail* log-concavity, which is itself informative).
3. **In-program:** proved or data-verified, it materially strengthens the pointed-Tutte paper
   (`ports-foundation`); a Lorentzian proof would headline it.

## Desired outcomes, tiered

- **A+:** ULC proved for all matroids (Lorentzian or inductive proof).
- **A:** LC proved; or LC shown to be a corollary of Eur–Huh morphism log-concavity — this still
  closes the question, credits correctly by citation, and leaves the operational reading plus the
  pointed-Tutte identities as the paper's own contribution ("repair profiles are Lorentzian").
- **B+:** LC verified over the full certificate stock and all matroids on small ground sets, as a
  supported conjecture published inside `ports-foundation` with the reduction framework.
- **Decisive negative:** a certified counterexample, with the minimal one located and the failing
  ratio exhibited. Publishable as a sharp structural fact.

## Research plan

**Phase 0 — vet and source-verify (gate).** Vet of the underlying reviews; re-verify C227's
perspective-specialization and rank-polynomial-difference identities at the source; dedupe.

**Phase 1 — data first (near-zero cost, immediate).**
1. ULC/LC sweep over every committed uniform, cubic, and harmonic profile in the certificates.
2. Exhaustive sweep over all matroids on small ground sets (the standard catalogs up to 9
   elements), all choices of `x`. A counterexample here ends the proof program and starts the
   negative paper; support here fixes the strength (LC vs ULC) to aim at.
3. Record where equality holds — equality cases guide the proof shape (in the Lorentzian world,
   equality loci are structured and informative).

**Phase 2 — the literature leg (bounded, priced).** One targeted read: Eur–Huh morphism
log-concavity and the Brändén–Huh Lorentzian toolkit, specifically whether the pair
`(M\x, M/x)` with its perspective/quotient structure is an instance of a morphism to which their
theorems apply. This is the mining ledger's stated condition on the cell and the single check that
decides between outcome tiers A+ and A. [Currently unpaid; sources open-access.]

**Phase 3 — proof attempts, in cost order.**
1. **Reduction route:** express the generating function of `(a_k)` (or `(b_k)`) as a specialization
   of a polynomial already known to be Lorentzian (independence polynomial of a minor, a
   Las Vergnas/quotient mixed form, a multiaffine rank generating function). If the Phase-2 read
   succeeds, this is bookkeeping; write it and stop.
2. **Inductive route:** deletion–contraction on a helper `e ≠ x`:
   `a_k(M,x) = a_k(M\e, x) + [terms from A ∋ e via M/e]` — establish the exact recursion (it
   follows from splitting subsets by membership of `e`, with a correction where `cl` jumps), then
   attempt the standard log-concavity induction with a base at uniform/rank-1 minors. The known
   hazard: LC is not generally preserved under the naive sum of two LC sequences, so the recursion
   needs an interlacing or Lorentzian certificate at each step, not termwise LC.
3. **Injection route (combinatorial fallback):** a direct injection
   `A_{k−1}-sets × A_{k+1}-sets → A_k-sets × A_k-sets` in the style of classical LC proofs;
   plausible on the structured families first (cubic, then harmonic), giving family-level theorems
   even if the general case resists.

**Phase 4 — write-up and formalization.** Finite instances are already certificate checks. An
inductive proof formalizes naturally; a Lorentzian proof would need the Lorentzian basics in Lean
(substantial, but log-concavity is a marquee formalization target and even the ULC *statement*
plus certified instance checks is a respectable formal artifact to ship with the paper).

## Starting theorems and proof spines

**Theorem 0 (base cases; provable today).** For uniform matroids the profile is a truncated
binomial row, hence ULC on its support (computation above). For rank-1 and corank-0 matroids the
profile is degenerate and LC trivially. Spine: direct closure computation; no machinery.

**Candidate Lemma 1 (deletion–contraction recursion).** An exact recursion for `a_k(M,x)` in terms
of `a_k(M\e, x)` and `a_{k−1}(M/e, x)` with an explicit correction term supported on subsets where
`e ∈ cl(A − e) ∪ cl`-jump configurations. Spine: split `A` by `e ∈ A`; the only subtlety is
`x ∈ cl(A)` versus `x ∈ cl_{M/e}(A − e)`, which differ exactly when `e` closes a circuit with `A`.
Establishing this recursion exactly is Phase 3.2's first step and is pure bookkeeping.

**Candidate Lemma 2 (complement/Lorentzian handle).** The generating polynomial of `(b_k)` (helpers
avoiding `x` in closure) is a specialization of the independence-adjacent multiaffine polynomial of
a matroid built from `M` and `x` (candidate: the principal truncation or the free coextension at
`x`). Spine: `x ∉ cl(A)` iff `A ∪ x` is "independent over `x`" in the appropriate quotient — the
right single construction is exactly what the Phase-2 read should reveal or refute.

**Candidate Theorem 3 (families).** LC (and ULC) for the cubic–axis and harmonic families by
explicit injection or by the recursion with certified interlacing. Spine: both families have
transitive-enough symmetry that `a_k` admits orbit-counting formulas; injections can be built
orbitwise. This is the fallback paper's core and the natural warm-up even for the general attack.

## Risks and unknowns

- The Eur–Huh check may reveal the whole conjecture is a two-line corollary — tier A, not a loss,
  but it changes the paper from theorem to synthesis; know this *before* investing in Phase 3.
- Pointed invariants can hide representation dependence; `a_k` as defined is matroid-invariant,
  but the C227 identities must be confirmed to be stated at matroid (not coordinate) level.
- If ULC fails while LC holds, the Lorentzian route is likely closed (Lorentzian ⇒ ULC-type
  bounds); the inductive/injection routes remain. The Phase-1 sweep decides this early.
