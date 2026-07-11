# Baer / Galois-equivariant arc extension — citation-audit scope

**Date:** 2026-07-11
**Lane:** the `[PROVED]` theorems of
[`2026-07-10-baer-equivariant-extension-upgrades.md`](2026-07-10-baer-equivariant-extension-upgrades.md)
(Frobenius/Baer-invariant arc extension, orbit saturation, Galois rank), plus the §5
Frobenius-marked arrangement result also written up in
[`2026-07-11-codex-coding-mds-cross-field-sweep.md`](2026-07-11-codex-coding-mds-cross-field-sweep.md) §5.
**Why this note exists:** the upgrade note's §10 "Publication plan and risk audit" already names the
internal gate — a MathSciNet/Zbl search for Galois-invariant/Baer-invariant arc extension +
saturation, flagged as *not yet done*. This note is the EXTERNAL full-text pass that closes that gate:
per atomic novelty claim, risk tier, named candidate-collision papers, searches run, full-text
verdict, kill condition. House style + verdict grammar match
[`2026-07-11-twisted-cubic-axis-lrc-audit-scope.md`](2026-07-11-twisted-cubic-axis-lrc-audit-scope.md):
every citation reached via a hit this session; unopened full texts tagged `[VERIFY]`; each none-found
verdict logs its queries.

**Headline going in.** The upgrade note bets the paper on two things (its §10 "Recommended theorem
package" items 3–4): **Theorem 3.1** (orbit-valued conjugate-pair extension criterion) as the
principal theorem, and **Corollary 3.4** (the explicit `√2·s` "orbit-saturation" lower bound) as the
strongest corollary. The adversarial thesis of this audit, borne out below, is that **Cor 3.4's `√2·s`
bound is numerically and mechanically the classical Lunelli–Sce trivial complete-arc lower bound
`√(2q)` evaluated at `q = s²`** — the single most dangerous collision in the lane, and the one the note
half-anticipates by making sharpness (not the bound itself) the open gate.

---

## The novelty claims, decomposed

Five atomic claims, ordered by prior-art risk. A collision on N1 resizes (does not kill) the headline;
N2 survives as a clean criterion even if N1 softens; N3–N5 are supporting, and N5 is already ceded by
the note itself.

### N1 — Cor 3.4 `√2·s` orbit-saturation lower bound *(HIGHEST risk; the crux)*

**Claim.** For any prime power `s`, a Frobenius-invariant arc `K` in `PG(2,s²)` with `k < s²+1` and no
legal conjugate-pair extension satisfies `k ≥ 1 + ⌈√(2s(s-1))⌉`; hence an equivariantly-complete
invariant arc has size asymptotically `≥ √2·s`, in every characteristic. Mechanism: `M = e(k-e-1) ≥
s(s-1)/2` (Cor 3.3) combined with `M ≤ ⌊(k-1)²/4⌋`.

**Prior-art risk: HIGH — CONFIRMED PARTIAL COLLISION.** Write `q = s²`. Then `2s(s-1) = 2s² - 2s =
2q - 2√q`, so `1 + ⌈√(2s(s-1))⌉ = 1 + √(2q - 2√q) = (1 + o(1))√(2q)`. This is, to leading order and
constant, the **Lunelli–Sce trivial lower bound for a complete arc in `PG(2,q)`**: `t(2,q) > √(2q) +
1` — the oldest and most elementary bound in the subject, proved by exactly the mechanism Cor 3.4
uses (an arc is complete iff its secants cover the plane; `C(k,2)` secants cover `≲ C(k,2)(q-1)`
off-arc points, so covering `~q²` points forces `k² ≳ 2q`). Cor 3.4 runs the *same* secant-covering
count in the Frobenius-equivariant quotient (candidate pairs per empty `𝔽_s`-line vs. `M` blocking
conjugate-secant orbits) and lands on the *same constant* `√2`.

**Located collision / must-cite prior art (CHECKED via search, classical):**
- **Lunelli–Sce**, *Considerazioni aritmetiche e risultati sperimentali sui `{K;n}_q`-archi* (Ist.
  Lombardo Accad. Sci. Lett. Rend. A, 1964) — the origin of the `√(2q)` complete-arc bound.
  **[CHECKED — collision on the bound VALUE + mechanism.]** Confirmed via two independent search hits:
  "Lunelli and Sce showed the smallest complete arc `n(P)` is at least `√2q`… an arc is complete iff
  its secants cover the whole plane" and "a general lower bound … is `t(2,q) > √(2q)+1`." Referenced
  as classical in the Ball–Lavrauw arcs survey ([arXiv:1908.10772](https://arxiv.org/abs/1908.10772),
  ref [41]) which the upgrade note §7 already cites for background.
- **Stronger classical bounds also in range.** For `q = p^h`, `h ≤ 3`, the sharper Segre/
  Voloch/Hirschfeld bound `t(2,q) > √(3q) + 1/2` beats `√2·s` outright; at `q = s²` the Hasse–Weil /
  Segre bound gives complete arcs `> q - √q + 1`-type results for large arcs. Any referee in this area
  reads `√2·s` as "the weakest of the standard complete-arc lower bounds." (Search-confirmed:
  Kim–Vu, Giulietti–Pambianco–Torres–Ughi *On large complete arcs: odd case*
  [arXiv:math/9905037](https://arxiv.org/abs/math/9905037), Voloch *Complete arcs in Galois planes of
  non-square order*.)

**Searches run:** `complete arc PG(2,q) lower bound size sqrt(2q) trivial bound finite geometry`;
`Lunelli Sce Segre complete arc bound number of secants cover plane k greater sqrt 2q derivation`;
`saturating set PG(2,q) minimum size lower bound sqrt(2q) Davydov Storme`;
`"invariant arc" OR "equivariant" complete arc saturation lower bound finite field MDS code extension
Galois descent`.

**Full-text verdict: PARTIAL COLLISION — the bound value is NOT new; only the hypothesis is.** What
survives external scrutiny is narrow and must be stated defensively:
- The `√2·s` *number* is the Lunelli–Sce bound at `q = s²`. It cannot be presented as a new extremal
  constant. The upgrade note's own §2 gate 3 and the closing "the constant `√2` is now an explicit
  extremal target" already treat sharpness — not the bound — as the deliverable; this audit confirms
  that is the *only* defensible framing.
- The **genuinely new content is the weaker hypothesis**: Cor 3.4 holds for arcs that are *not*
  complete but merely admit no legal *conjugate-pair* (free two-point orbit) extension — "fixed-point
  maximality is not assumed" (note §3.4). Since a complete invariant arc trivially fails pair
  extension, `{equivariantly-complete}` ⊇ `{complete & invariant}`, so Cor 3.4 bounds a *strictly
  larger* class by the same number. **But this is only a contribution if some invariant arc is
  pair-extension-complete yet not complete AND lands near `√2·s`** — otherwise the "strengthening" is
  vacuous exactly where it would matter. No located work fills that gap either way; the note supplies
  no such construction.
- No located paper packages this as an *equivariant/orbit-valued* saturation bound. The
  group-invariant-arc literature (Korchmáros–Indaco *42-arcs invariant by `PSL(2,7)`*,
  [DOI:10.1007/s10623-011-9532-y](https://doi.org/10.1007/s10623-011-9532-y); Giulietti–Korchmáros
  *Transitive `A₆`-invariant `k`-arcs* [arXiv:1108.0358](https://arxiv.org/abs/1108.0358)) *constructs*
  invariant arcs and studies their completeness case-by-case; it does not state a general
  orbit-saturation lower bound. So the *framing* is unlocated, but the *bound* it produces is the
  classical one.

**Kill condition.** (i) Any statement that an equivariantly-complete (no-orbit-extension) invariant
arc — or any invariant complete arc — in `PG(2,s²)` has size `≥ c·s` with `c ≥ √2` collapses the
"strengthening" to a restatement. (ii) Conversely, the *only* thing that lifts N1 from "trivial bound,
weaker hypothesis" to a headline is a construction of orbit-saturated invariant arcs at
`(√2 + o(1))·s`, OR a strict improvement of the constant using that `M` comes from one arc — both
explicitly OPEN in the note (§2 gate 3, §3.4). **Verdict: SOFTEN. The `√2·s` bound is the Lunelli–Sce
bound in equivariant clothing; do not headline it as a new constant.**

### N2 — Theorem 3.1 orbit-valued conjugate-pair extension criterion *(medium risk; the principal theorem)*

**Claim.** Exact count `E = s²+s+1 - (f(s+1) - C(f,2) + e)` of empty `𝔽_s`-lines; lower bound
`N_pair(K) ≥ E·((s²-s)/2 - M)_+` on legal conjugate point-pairs; hence a legal invariant two-point
extension whenever `E > 0` and `s(s-1)/2 > M` (Cor 3.2: every invariant 8-arc pair-extends for every
prime power `s ≥ 7`). The novelty asserted is the **orbit-valued continuation unit**: over a quadratic
extension the equivariant extension adds either a fixed point or a conjugate pair, and the criterion
counts the pair option.

**Prior-art risk: MEDIUM.** The proof is elementary incidence counting (empty `𝔽_s`-lines carry
`(s²-s)/2` conjugate pairs; each noninvariant old-secant *orbit* kills `≤ 1`). The risk is not that the
inequality is in print verbatim, but that "count extension points by counting uncovered
lines/positions" is the standard completeness toolkit, and the *fixed-point* half is precisely the
classical secant-cover count (N1). What is candidate-new is only the **conjugate-pair (degree-two
closed-point) bookkeeping** and the clean `E > 0 ∧ s(s-1)/2 > M` trigger.

**Located adjacent art (candidate collisions):**
- Group-invariant-arc completeness analyses — Korchmáros–Indaco, Giulietti–Korchmáros (above), and the
  envelope/algebraic-curve approach (Giulietti *Envelopes of `k`-arcs*; Cossidente–Korchmáros *algebraic
  envelope of a complete arc*). **Check:** do any count *conjugate-pair* / Galois-orbit extensions as
  opposed to single-point extensions? `[VERIFY — not opened in full this session]`
- Abatangelo–Korchmáros-style conic-in-Baer arc work (*Conics in Baer subplanes*
  [arXiv:1906.03296](https://arxiv.org/abs/1906.03296)) — `𝔽_s`-conics inside `PG(2,s²)` and their
  intersection pattern with the Baer subplane, the exact geometric setting of the fixed locus here.
  **Check:** whether the fixed-vs-conjugate secant dictionary (Prop 1.1) is already drawn there.
  `[VERIFY]`

**Searches run:** `arc conic subfield PG(2,q^2) Frobenius fixed points extension complete arc Baer
conic`; `group invariant complete arc PG(2,q) collineation transitive Korchmaros Giulietti lower
bound`; `Galois invariant arc extension Frobenius finite projective plane Baer subplane complete arc`.

**Full-text verdict: none-found for the orbit-valued criterion; the counting is standard, the
orbit-unit framing is not located.** The search surfaced no paper stating an exact empty-line count `E`
or a conjugate-pair extension lower bound for Frobenius-invariant arcs. The **legitimately new object**
is the orbit-valued continuation (add a whole degree-two closed point), which §7.3 correctly identifies
as the arithmetic split/nonsplit-secant distinction — genuinely a cleaner *packaging* than the
single-point completeness literature. But Theorem 3.1 itself is an elementary union/pigeonhole count;
its citability rests on the *framing* ("orbit-valued extension criterion"), not on a hard inequality.
This matches the note's own §10 table ("elegant but elementary counting"). **Verdict: SURVIVES as a
clean criterion; frame as a packaging/definition contribution, not a hard theorem.** Two `[VERIFY]`
items (group-invariant completeness papers, Conics-in-Baer) remain the residual diligence.

### N3 — §5 Frobenius-marking-essential (`(ε,h)` marked-Baer statistic) *(medium-LOW risk; sharp negative)*

**Claim.** For three conjugate pairs, the fixed legal-extension count is `N_legal = s² - 2s + ε - h`
via the arrangement characteristic polynomial `χ(t) = (t-1)(t² - 2t + ε - h)`. **[COMPUTED-EXACT]** at
`s=7`, a single unmarked `PGL(2,s²)`-orbit six-set bucket contains marked Frobenius configurations with
legal-counts **30 and 32** coexisting (explicit `w²=3` over `𝔽_7` example). Hence the full unmarked
orbit does *not* determine the count; the marked-Baer statistic `(ε,h)` (equivalently the six-set +
its Frobenius pairing) is essential.

**Prior-art risk: MEDIUM-LOW for a collision, but LOW novelty by construction.** The counting engine —
`N_F(A) = (1/(s-1)) Σ_X μ(V,X) s^{dim_F X}` — is the **Athanasiadis/Crapo–Rota finite-field method**
for the characteristic polynomial of a subspace arrangement, and `P_𝒜(q) = |𝔽_q^n \ ∪ subspaces|` is
textbook. **CHECKED:** Athanasiadis *Characteristic polynomials of subspace arrangements and finite
fields* (Adv. Math. 1996, [ScienceDirect](https://www.sciencedirect.com/science/article/pii/S0001870896900596));
Björner–Ekedahl *Subspace arrangements over finite fields*
([arXiv:math/9612217](https://arxiv.org/abs/math/9612217)). The note itself concedes this
("the characteristic-polynomial method itself is standard subspace-arrangement theory").

**Full-text verdict: NON-COLLIDING but conceptually expected; thin novelty.** The characteristic
polynomial of an arrangement is a **matroid / intersection-lattice invariant** — determined by the
combinatorics `(ε, h)` (concurrent-vs-triangle mate lines; number of off-line cross-pair points), NOT
by the `PGL`-orbit label. So "the count is determined by `(ε,h)` and *not* by the unmarked orbit" is
almost a restatement of "the count is a matroid invariant, not a group-orbit invariant." The
`COMPUTED-EXACT` `s=7` value — two arcs in one unmarked `PGL(2,s²)`-orbit realizing different `(ε,h)`
hence different counts (30 vs 32) — is a **crisp, checkable sharpness witness** that no located paper
states, so there is no literal collision; but it certifies the *essentialness of marking*, not a new
theorem. The note grades this correctly `[OPEN]`: "novelty requires such a structured classification
[of attainable `(ε,h)` by trace/norm/cross-ratio] or a coding consequence." **Verdict: SURVIVES as a
rigidity/sharpness observation (no collision), but it is method-illustration, not headline; the
`(ε,h)`-classification is the only route to a real result here.**

**Kill condition.** Any prior enumeration of the fixed legal-extension count for a Frobenius-marked
conjugate-pair arrangement as a function of `(ε,h)` (or any statement that a subspace-arrangement
point count is a `PGL`/Frobenius-orbit invariant would be *false*, so its absence is not evidence — the
kill is specifically a prior `(ε,h)`-indexed count or classification).

### N4 — Theorem 6.1 higher-dimensional fixed-subgeometry cap extension *(medium risk; same pattern as N1)*

**Claim.** For a Frobenius-invariant cap in `PG(n,s²)`, `|Blk_{PG(n,s)}(K)| ≤ I(s+1) + M`, so a fixed
extension exists when `(s^{n+1}-1)/(s-1) > I(s+1)+M`; in particular every such cap with `k =
o(s^{(n-1)/2})` fixed-extends.

**Prior-art risk: MEDIUM — same structural collision as N1, one dimension up.** The threshold
`k = o(s^{(n-1)/2})` at `q = s²` is `o(q^{(n-1)/4})`… but more to the point, the trivial
complete-cap lower bound in `PG(n,q)` is of order `q^{(n-1)/2}` (secants of a complete cap must cover
`~q^n` points with `~k²` secants each covering `~q^{n-1}` new points → `k ≳ √2·q^{(n-1)/2}`). Theorem
6.1's guarantee region is the equivariant image of that same trivial cap-completeness count. **CHECKED
context:** the arcs/caps survey corpus (Ball–Lavrauw [arXiv:1908.10772]; *Arcs, Caps and
Generalisations* [arXiv:2503.06243]) treats these trivial cap bounds as classical.

**Full-text verdict: PARTIAL COLLISION (bound order is the trivial complete-cap bound); framing new.**
Same call as N1: the union bound `I(s+1)+M` and its `o(s^{(n-1)/2})` corollary are the equivariant
face of the classical complete-cap covering bound, transported to the Baer subgeometry. Novelty is the
*fixed-subgeometry* localization (blocked set lives in `PG(n,s)`), not the order of the threshold.
Lower stakes than N1 because the note (§10) never nominates N4 for the headline. **Verdict: SOFTEN —
present as the higher-dimensional analogue, not an independent result; do not claim the threshold order
as new.**

### N5 — Theorem 7.1 Galois-rank section formula *(NOT a novelty claim — already ceded)*

**Claim.** `H_S ∩ PG(r-1,F) ≅ PG(r - ρ(S) - 1, F)` where `ρ(S) = dim_F span_F{h_i}`, and the fixed
legal-lengthening count `≥ θ_{r-1}(s) - f - Σ_{[S]} θ_{r-ρ(S)-1}(s)`.

**Prior-art risk: N/A — self-conceded translation lemma.** The note's own §7.2 states it: `ρ(S)` "is
exactly the **rank weight** over `L/F` of the normal vector `h_S`," (7.1) "is the projectivized
rank-nullity identity," and "Theorem 7.1 is therefore a translation lemma, not a standalone novelty
claim," citing Jurrius–Pellikaan *On defining generalized rank weights*
([arXiv:1506.02865](https://arxiv.org/abs/1506.02865)). **CHECKED (concession stands):** rank weight /
rank-support over finite Galois extensions is classical (Gabidulin; Jurrius–Pellikaan). The candidate
novelty the note flags — the *forbidden-normal rank enumerator* `W_A(j)` for a recognized MDS/GRS
family plus its kernel-overlap data (7.3) — is explicitly `[OPEN]` and unbuilt. **Verdict: NOT A
CLAIM. No audit action beyond confirming the cession is correct (it is). If `W_A` is ever computed for
a real GRS family, re-audit against the rank-metric-code and GRS-lengthening literature
(Lavrauw–Van de Voorde field-reduction survey [arXiv:1310.8522]).**

### Supporting: Prop 1.1 + Theorem 2.1 (mixed-cover dictionary and `B_{k,f}(s)` bound)

Not headline (note §10 grades them "reusable setup" / "low–moderate"). Prop 1.1 (invariant secants =
fixed-fixed chords + mate lines; noninvariant secants meet the Baer subplane in `≤1` fixed point) is a
clean but elementary orbit-stabilizer dictionary; Theorem 2.1's `B_{k,f}(s)` is a refined union bound.
Collision surface is the **partial-cover literature the note already cites** — Dodunekov–Storme–
Van de Voorde *Partial covers of `PG(n,q)`* ([DOI:10.1016/j.ejc.2009.07.008](https://doi.org/10.1016/j.ejc.2009.07.008))
— which controls the *line part* of the cover but not the isolated conjugate-secant intersections, as
the note correctly observes (§4). **Verdict: SURVIVES as infrastructure (low novelty, no headline
collision); the mixed line-and-point cover is the one genuinely non-standard structural wrinkle, and
it is exactly where the note says a new argument is still required.**

---

## Priority + decisive gate

**Audit order = risk order: N1, N2, N4, N3, N5.** N1 is the crux; if the `√2·s` bound is the Lunelli–
Sce bound (it is), the headline drops from "new extremal constant" to "classical bound under a weaker
hypothesis, sharpness open."

**N1 gate — RESULT: PARTIAL COLLISION, confirmed.** `k ≥ 1 + ⌈√(2s(s-1))⌉` at `q = s²` is
`(1+o(1))√(2q)` = the Lunelli–Sce trivial complete-arc bound, produced by the same secant-covering
mechanism in the Frobenius quotient. The bound VALUE is not new. Two things are new and both are thin:
(a) the weaker "no pair-extension" hypothesis (vacuous unless a construction populates it near the
extremal size — none located, none in the note), and (b) the equivariant/orbit-saturation *framing*
(unlocated, but framing is not a theorem). **The single decisive remaining gate is unchanged from the
note's §2 gate 3: exhibit orbit-saturated invariant arcs at `(√2+o(1))·s`, OR strictly improve the
constant using that `M` arises from one arc.** Until then, N1 must be written as "the classical trivial
bound extends to equivariant completeness," not as a headline constant.

**N2 gate — RESULT: none-found; survives as packaging.** No prior conjugate-pair / orbit-valued
extension criterion located. Elementary counting, so citability is in the orbit-unit framing. Residual
`[VERIFY]`: full-text of the Korchmáros–Indaco / Giulietti–Korchmáros invariant-arc-completeness papers
and *Conics in Baer subplanes* (1906.03296) — to confirm none already counts Galois-orbit (not
single-point) extensions.

**N3 gate — RESULT: non-colliding but expected.** Char poly is a matroid invariant (Athanasiadis /
Björner–Ekedahl finite-field method), so "marking essential, orbit does not determine count" is nearly
tautological; the `s=7` 30-vs-32 witness is a crisp sharpness fact with no literal collision, but it is
method-illustration. Novelty only via the `[OPEN]` `(ε,h)`-classification.

**N4 gate — RESULT: PARTIAL COLLISION (trivial complete-cap bound, one dimension up); soften.**

**N5 — not a claim** (self-conceded rank-weight translation lemma; Jurrius–Pellikaan).

**Residual (auth-gated, non-blocking):** a definitive MathSciNet/zbMATH forward-citation run from
Lunelli–Sce and from the Korchmáros invariant-arc papers (public web + arXiv approximated it here), and
opening the two N2 `[VERIFY]` full texts. The first external prior-art pass is otherwise complete.

---

## Overall verdict

**Does the lane's headline novelty survive external scrutiny? SOFTEN — it survives as a paper, but not
with its two headline items intact as stated.**

- **Cor 3.4 (`√2·s` orbit-saturation bound) — SOFTEN, do not headline as a new constant.** It is the
  **Lunelli–Sce classical complete-arc bound `√(2q)` at `q = s²`**, same value and same
  secant-covering mechanism. The only new content is the weaker "no conjugate-pair extension"
  hypothesis, and that is a genuine contribution *only if* an invariant arc realizes it near `√2·s`
  while failing to be complete — unproven and unconstructed in the note. The real deliverable is
  sharpness or a strict improvement of the constant; the note already knows this, and this audit
  removes any doubt that the bound-as-stated is prior art.
- **Theorem 3.1 (orbit-valued pair-extension criterion) — SURVIVES as the defensible headline**, but as
  a *packaging/definition* contribution (clean orbit-valued continuation over quadratic extensions),
  not as a hard theorem: the counting is elementary and no located work states it. This is the lane's
  most citable piece, matching the note's §10 self-assessment.
- **§5 Frobenius-marking-essential — SURVIVES (no collision), thin.** The `(ε,h)` statistic determining
  the count while the unmarked orbit does not is the (expected) statement that an arrangement point
  count is a matroid, not an orbit, invariant. The `s=7` 30-vs-32 witness is a real sharpness fact but
  method-illustration; the `(ε,h)`-classification (OPEN) is the only path to a result.
- **Theorem 6.1 — SOFTEN** (equivariant face of the trivial complete-cap bound).
- **Theorem 7.1 — already ceded** by the note (rank-weight translation lemma).

**The single decisive remaining gate:** prove sharpness of the `√2` constant — construct
Frobenius-invariant arcs with no free-orbit extension at size `(√2 + o(1))·s`, or strictly beat the
constant by exploiting that the `M` forbidden candidates come from one arc rather than arbitrary
conjugate line pairs. **Nothing short of that lifts the lane above "classical arc/cap bounds
transported to the equivariant setting, plus a clean orbit-valued extension criterion."** That is a
plausible specialist short note (as the upgrade note §10 already judges) — but the `√2·s` bound must be
demoted from "headline constant" to "the Lunelli–Sce bound under a weaker maximality hypothesis," and
Theorem 3.1 (the orbit-valued criterion) carried as the actual headline.

**Default-to-collision items I could NOT fully rule out (flag for the specialist):** (i) that some
group-invariant-arc paper (Korchmáros school) already records a conjugate-pair / Galois-orbit extension
count — `[VERIFY]`, two papers unopened; (ii) that *Conics in Baer subplanes* already draws the
fixed-vs-conjugate secant dictionary of Prop 1.1 — `[VERIFY]`. Both are N2-adjacent; neither threatens
the (already-softened) N1 crux.

### Searches run (this session, logged for auditability)
1. `complete arc PG(2,q) lower bound size sqrt(2q) trivial bound finite geometry`
2. `Galois invariant arc extension Frobenius finite projective plane Baer subplane complete arc`
3. `saturating set PG(2,q) minimum size lower bound sqrt(2q) Davydov Storme`
4. `group invariant complete arc PG(2,q) collineation transitive Korchmaros Giulietti lower bound`
5. `arc conic subfield PG(2,q^2) Frobenius fixed points extension complete arc Baer conic`
6. `characteristic polynomial subspace arrangement finite field not determined by orbit Frobenius Mobius counting`
7. `"invariant arc" OR "equivariant" complete arc saturation lower bound finite field MDS code extension Galois descent`
8. `Lunelli Sce Segre complete arc bound number of secants cover plane k greater sqrt 2q derivation`

Full text opened: Ball–Lavrauw arcs survey ([arXiv:1908.10772](https://arxiv.org/abs/1908.10772))
via pdftotext (confirmed Lunelli–Sce as classical ref [41], complete-arc extendability thresholds
§Thms 50–51). `[VERIFY]` (not opened this session): Korchmáros–Indaco `PSL(2,7)` 42-arcs;
Giulietti–Korchmáros `A₆`-invariant arcs (1108.0358); *Conics in Baer subplanes* (1906.03296);
Athanasiadis (1996) and Björner–Ekedahl (math/9612217) full texts (method confirmed via search
abstracts, standardness not in dispute).
