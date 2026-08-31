# C1024 — Multiplicative-subgroup incidence as a route to the carrier threshold

**Lane:** `gem-mining`
**Date:** 2026-08-31
**Status:** complete as an early negative.  Both decision questions answer
**no**, and the second answers no by a one-line structural argument that did not
need the machinery at all.

Predecessors: `notes/2026-08-31-c1023-lang-weil-carrier-threshold.md` (whose
`tt` pass proposed this route), and
`notes/2026-08-31-c1018-prs-deephole-conjecture.md` §5d (fixed-locus lemma) and
§8 item 11 (the regular-orbit residual).  Notation is theirs.

Persona routing: `notes/2026-07-07-named-expert-personas-context.md` routes PRS
deep-hole proof work to `papers/expert-profiles/08-beyond-four-prs.md`, which was
read in full earlier today for C1023 and is unchanged.  No new dossier was
loaded; nothing in the persona map covers analytic number theory over finite
fields, which is itself a small signal that this route is off the repository's
established ground.

## 0. Verdict, stated first

**Question 2 — does the bound see the regular, trivial-stabilizer orbits?  No,
and not for a fixable reason.**  A carrier stratum is by definition the fixed
locus of a nontrivial torus element, so every point on it has nontrivial
stabilizer.  A regular orbit has trivial stabilizer and therefore meets no
stratum at all.  Any statement proved about incidences on a stratum is
vacuous for regular orbits — not weak, vacuous.  This is the same structural
boundary the fixed-locus lemma has, and no incidence bound changes it.

**Question 1 — is the constant absolute in the redundancy?  No.**  And the
sharper finding is that the tool does not apply in the first place: our
subgroups are of *bounded index*, hence of size `≍ q`, while the
Heath-Brown–Konyagin / Bourgain–Glibichuk–Konyagin machinery is for *small*
subgroups, `|H| ≪ q^{2/3}` at best and `≪ q^{1/2}` for the sharp forms.  In the
asymptotic regime the threshold question actually lives in, `H` is as large as a
subgroup can be, the subgroup structure carries no extra information, and the
count degenerates to a complete character sum bounded by Weil — which is exactly
where C1023 died.

So by the task's own gate — both must answer yes for the tool to be worth
anything — **this route is worth no more than the count C1023 refuted, and I am
stopping rather than building a partial version.**

There is one genuinely informative by-product, in §3: the two ways of pushing a
carrier to infinity give *opposite* subgroup regimes, and neither admits an
absolute constant, for reasons that are not about proof technique.

## 1. Prior art, bounded pass — done before deriving anything

Read depths recorded honestly; this is a bounded pass, not an audit under
`notes/literature-audit-conventions.md`.

* **Heath-Brown–Konyagin and successors.**  The core results bound additive
  structure of multiplicative subgroups by Stepanov's method: `|R ± R| ≫
  |R|^{3/2}` for subgroups with `|R| ≪ p^{2/3}`, improved by Vyugin and
  Shkredov to `|G ± G| ≫ |G|^{5/3}/log^{1/2}|G|` for `|G| ≪ p^{1/2}`.  The
  original Heath-Brown–Konyagin work simplifies and improves a 1988 result of
  Garcia and Voloch on intersections of subgroups with their additive shifts.
  *Read depth: search snippets and abstracts only; no primary source obtained.*
  **The size condition is the load-bearing fact for this report and it is
  stated consistently across every snippet: these are small-subgroup theorems.**
* **Subgroups meeting affine subspaces.**  There is recent work adapting
  Bourgain–Konyagin–Shparlinski methods to the intersection of multiplicative
  subgroups with *low-dimensional affine subspaces*, but in **high-degree
  extensions** `F_{q^n}` with `n` large.  That is the nearest thing to the
  statement this task wanted.  *Read depth: search snippet only.*  It is a
  near-miss rather than a hit: our fields are prime or of very small extension
  degree (`q = 16, 25, 27, 32` at worst), and the mechanism in that line of work
  is the extension structure, which we do not have.
* **Stepanov's method** remains the fundamental technique in this area for
  intersections of subgroups with shifts and with each other.  *Read depth:
  snippet.*
* **No source found stating the bound this task needs** — an incidence bound for
  a bounded-index subgroup power set against a hyperplane in the coefficient
  space of a binary form.  That is a bounded negative from three searches, not a
  cleared novelty claim, and §3 argues the reason no such statement was found is
  that the natural bound in that regime is Weil's and is already known.

The C1023 ordering error is not repeated: this pass ran before any derivation,
and it is what identified the regime mismatch that decides the task.

## 2. Question 2, answered and closed

Let `σ ∈ PGL_2(q)` be a nontrivial element of prime order and let
`Σ ⊆ Fix(S_σ)` be one of its eigenspaces — for a split `σ` of order `m`, exactly
the arithmetic-progression stratum `{ i ≡ a (mod m) }` (C1018 §5d).

> **Observation.**  Every `s ∈ Σ` satisfies `σ ∈ Stab(s)`, so `Stab(s) ≠ 1`.
> Hence no orbit with trivial stabilizer meets `Σ`.

Therefore any theorem whose hypothesis is "`s` lies on a carrier stratum" —
which is what every incidence statement in this regime would be — is *vacuously
true* on the regular orbits and gives no information about them.  This is not a
weakness of a particular bound; it is a property of the quantifier.

Since C1018 §8 item 11 records the regular class as the **entire** residual at
redundancies eight and nine, an incidence bound would leave that residual
untouched even if question 1 had answered yes.  The prize the task described —
one tool closing both residuals — is not available from any stratum-local
argument, incidence-theoretic or otherwise.

That alone settles the task under its stated gate.  §3 answers question 1
anyway, because the answer is informative about *why* the observed threshold
looks constant.

## 3. Question 1: the two regimes, and why neither is absolute

Fix an `a = b = 1` carrier: `m | q-1`, `M` support indices,
`r = 3 + m(M-1)`, and `H = (F_q^*)^m` with `|H| = (q-1)/m`.  By C1023
Theorem A, certification needs `M-1` distinct elements of `H` whose associated
form lies in a hyperplane `Λ_s ⊆ P^{M-1}`.  There are two ways to let the
problem grow, and they pull `H` in opposite directions.

**Regime A — fix the carrier `(r,m)`, let `q → ∞`.**  This is the regime the
threshold question lives in: a threshold `C(r,m)` is a statement about all large
`q` at fixed `r`.  Here `|H| = (q-1)/m ≍ q`, so `H` has *bounded index*.

* HBK and BGK are inapplicable: they require `|H| ≪ q^{2/3}` (and `≪ q^{1/2}`
  for the sharp forms).  A bounded-index subgroup violates this by a power of
  `q`, not by a constant.
* More importantly, in this regime the subgroup carries no extra information to
  exploit.  The indicator of `H` is
  `1_H(x) = (1/m) Σ_{χ^m = 1} χ(x)`, a sum of `m` multiplicative characters, so
  counting `H`-points on `Λ_s` is a sum of `m^{M-1}` *complete* character sums
  over a variety of dimension `M-2`.  Each is bounded by Weil, with a constant
  governed by the degree of the defining polynomial.
* That degree is tied to `M-1 = (r-3)/m`, which **grows with `r`** at fixed `m`.
  So the constant grows with the redundancy, which is precisely the failure mode
  question 1 was asked to exclude.
* And this is the same estimate C1023 §4 already applied and rejected.  Nothing
  is gained.

**Regime B — fix `M`, let `m` grow with `r`.**  For the `M = 3` family,
`m = (r-3)/2`, so at the least admissible field `q ≈ r-1`,

```text
|H| = (q-1)/m ≈ (r-2) / ((r-3)/2) → 2 .
```

Here `H` really is small and the HBK regime is formally the right one.  But the
object has collapsed: we need `M-1 = 2` distinct elements of a set of size about
2, so the number of candidate `Φ` is `C(|H|, 2) = O(1)`.  A lower bound on an
incidence count cannot deliver positivity when the total count is bounded — the
truth is that these carriers genuinely *do not fire*, and the census agrees:
`(13,5)` is clean at `q = 16` and `31`, `(15,6)` clean at `q = 19`,
`(10,7)` clean at eight fields.  There is nothing for a bound to prove.

Between the two regimes the mean-count threshold behaves as

```text
((q-1)/m)^{M-1} > (M-1)! · q ,
```

which for `M = 3` (`m = (r-3)/2`) requires roughly `q > (r-3)^2/2` — **quadratic
in the redundancy**.  So even the heuristic threshold is not absolute along that
family, and the appearance of a constant threshold in the data comes from the
fact that every *observed* carrier has small `m` and small `M`, not from any
uniformity.

**Answer to question 1: no.**  There is no absolute constant, in either regime,
and in the regime that matters the proposed tool does not apply.

## 4. Sanity against the census

The instruction was that a threshold must be consistent with exceptional fields
at 11 and 13 and none at 16 or above.  No threshold is produced, so there is
nothing to contradict — but the subgroup data are worth recording, because they
show that `|H|` by itself has **no predictive power**:

| carrier | `q` | `m` | `\|H\| = (q-1)/m` | good `Φ` count `C(\|H\|, M-1)` | mean in `Λ_s` | census |
|---|---:|---:|---:|---:|---:|---|
| `(9, m=3)`  | 13 | 3 | 4  | 6  | 0.46 | **fires** |
| `(9, m=3)`  | 16 | 3 | 5  | 10 | 0.62 | clean |
| `(9, m=3)`  | 19 | 3 | 6  | 15 | 0.79 | clean |
| `(9, m=3)`  | 31 | 3 | 10 | 45 | 1.45 | clean |
| `(11, m=4)` | 13 | 4 | 3  | 3  | 0.23 | **fires** |
| `(13, m=5)` | 16 | 5 | 3  | 3  | 0.19 | clean |
| `(13, m=5)` | 31 | 5 | 6  | 15 | 0.48 | clean |

`(11,13)` fires with `|H| = 3` and `(13,16)` is clean with the same `|H| = 3`
and the same mean 0.2, so the subgroup size does not separate the two.  The mean
count is below one in six of the seven rows including five clean ones, so it has
no predictive power in the direction that matters either.  Both observations are
consistent with C1023 §3: what makes the clean cells clean is the abundance of
**non-equivariant** annihilators, which no subgroup-incidence statement about
`Λ_s` can see.

## 5. What a corrected formulation would need

For completeness, and so this is not re-attempted from the same angle:

1. **Drop the stratum.**  Any argument that quantifies over "points of a carrier
   stratum" is structurally blind to the regular class (§2).  A statement about
   the regular residual has to quantify over orbits of size exactly `q^3 - q`,
   and the natural handle there is the Borel normal form already recorded in
   C1018 §8 item 11, not incidence geometry.
2. **If the strata are still wanted**, the honest tool in the bounded-index
   regime is a Weil bound on the complete character sum of §3, with the constant
   controlled by the degree of the multilinear defining equations — i.e. exactly
   C1023 §4's `(1,…,1)` complete intersection, whose Betti numbers are the thing
   to bound.  That is a real project and it is the only one of these routes that
   has not been refuted.
3. **The small-subgroup regime would become relevant** only for carriers with
   `m ≍ q`, and there the counts are `O(1)` and the question is not asymptotic
   at all — it is a finite check, which the C1018 sweeps already perform.

## 6. `ej` + `tt` closeout

**`tt` — the mistake in C1023's `tt` was mine, and it is worth naming.**  The
proposal to move to HBK/BGK was made on the shape of the *conclusion* — those
bounds give constant thresholds, and a constant threshold is what the data show
— without checking the *hypothesis*, which is a size condition our subgroups
violate by a power of `q`.  Reasoning from the shape of the answer to the choice
of tool is exactly the failure mode that produced the original §7 heuristic.
The correct question to have asked first was "how big is `H`", and it takes one
line.

A second `tt` point that survives: the observed constancy of the threshold is
probably not a theorem waiting to be proved but a **sampling artifact of the
carrier zoo**.  Every carrier the campaign has found has `m ≤ 8` and `M ≤ 4`,
because those are the ones cheap enough to sweep.  §3 shows the mean-count
threshold grows quadratically in `r` along the `M = 3` family, so the "constant
13" is a statement about the sampled corner, not about carriers in general.
That reframes C1018's Conjecture PRS-1 as possibly an artifact of range, which
is a live risk worth recording rather than a settled worry.

**`ej` — what is cheap and in reach.**

1. The `M = 2` locus remains the best available target (C1023 §5 item 3):
   one parameter after normalisation, three of six known carrier orbits, and now
   additionally motivated because §3 shows `M = 2` is where Regime B collapses.
2. A cheap falsification test for the artifact worry above: sweep an `M = 3`
   carrier with larger `m` — `(17, m=7)`, `q_min = 29` — and see whether it
   fires anywhere below the quadratic heuristic `(r-3)^2/2 = 98`.  The stratum is
   a `PG(2,q)`, so this is minutes of compute, and a firing at `q > 13` would
   falsify Conjecture PRS-1 outright.  **This is the single highest-value cheap
   experiment this task exposes.**
3. Nothing else here is worth queueing; the route is closed.

## 7. Mystery ledger

1. **Does subgroup-incidence give a constant threshold?**  *Settled: no.*  The
   subgroups have bounded index, `|H| ≍ q`, and the HBK/BGK regime requires
   `|H| ≪ q^{2/3}`.  In the applicable regime the count is a complete character
   sum and the bound is Weil's, with a constant growing like the degree, i.e.
   like `(r-3)/m`.  Nothing open.
2. **Does it reach the regular orbits?**  *Settled: no*, by the one-line
   observation of §2.  Nothing open; this also retro-limits any future
   stratum-local tool.
3. **Is the observed constant threshold real, or an artifact of which carriers
   were cheap to sweep?**  *Open, and newly raised.*  §3's mean-count grows like
   `(r-3)^2/2` along the `M = 3` family, yet every sampled carrier has small `m`.
   Evidence gap: one sweep of a large-`m`, `M = 3` carrier such as `(17,7)`.
   This bears directly on C1018 Conjecture PRS-1 and is cheap.  Owner: a
   successor, or the `ej` item above if someone runs it.
4. **Why are the clean cells clean, given the mean count is below one at most of
   them?**  *Open, inherited from C1023 §3.*  The answer is presumably the
   non-equivariant annihilators, but nothing here quantifies them.
5. **No mystery in the prior-art layer.**  Three searches, consistent size
   conditions across every snippet, one near-miss identified and correctly
   classified as a near-miss.  Read depths are snippet-level throughout and no
   claim in this report depends on a primary source.

## 8. Evidence bundle

This report is argument, not computation: the two verdicts are a structural
observation (§2) and a regime comparison against published size conditions (§3).
No new artifact is generated and none is needed.

The one table with numbers, §4, is arithmetic on quantities already committed:
`|H| = (q-1)/m` and `C(|H|, M-1)` are elementary, the "good `Φ` count" column
agrees with the `good_phi_counts` field emitted by
`notes/2026-08-31-c1023-carrier-threshold-check.py`, and the census column is
read from the committed C1018 evidence
(`notes/2026-08-31-c1018-prs-certificate.json`).  Replay of that column:

```bash
cd ~/src/othello/notes
python3 2026-08-31-c1023-carrier-threshold-check.py bound 9 3 1 13   # good_phi_counts
python3 2026-08-31-c1023-carrier-threshold-check.py bound 9 3 1 31
```

**What this report certifies:** nothing computational.  **What it establishes:**
that the proposed route cannot answer either decision question, for reasons
located in the hypothesis of the imported bounds (§3) and in the quantifier
structure of stratum-local statements (§2).
