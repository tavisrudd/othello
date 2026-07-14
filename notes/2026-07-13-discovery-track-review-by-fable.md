# Discovery-Track incidental findings — Fable triage (2026-07-13)

Fable's filter/rank of the three active lanes' Discovery-Track registers (arcs, coding, Baer ⊕
completion) — the *incidental findings noticed while executing the planned paper/formalization work*,
not the headline claims. Source inventory:
`scratchpad/discovery-track-inventory.md` (collected 2026-07-13, HEAD `a8b24ff`). Ranking framing:
EV = (payoff if pursued) × (plausibility it leads somewhere real).

Fable's triage is reproduced verbatim below; an **Opus verification addendum** (independent D-PC9
enumeration + prior-art check) follows at the end.

---

## Fable triage (verbatim)

Read the inventory. I also did one free arithmetic check on D-PC9 that materially changes its rank
(below). Triage follows.

### Best single bet: D-PC9

It's the freshest work, the most concrete (exact closed forms, replay-verified at three orders), the
lane's own posture already flags it `LIT-OPEN` "potentially stronger," and — the thing that moved it
to #1 — **I verified the five closed forms sum exactly to a partition**:

N1+N2+N3+N4+N(q+2) = q(q²−1)[⅓+½+⅙] + q(q+1) + (q+1) = (q³−q) + (q²+q) + (q+1) = **q³+q²+q+1 = (q⁴−1)/(q−1)**.

So they partition the projective (scalar-class) codewords exactly, for all q — not a numerical fit
that happens to hold at q=3,9,27. That is a strong, near-free confirmation the distribution is a real
exact identity, not a coincidence, and it sharply raises the plausibility that a general proof exists.

### CHASE (ranked by EV)

**1. D-PC9 — exact five-weight distribution of the [2q+2,4,q]_q projective twisted-cubic+axis code.**
- *Why it leads somewhere.* A kernel-checked five-weight infinite family is a self-contained,
  specialist-publishable object (few-weight codes ↔ SRGs, association schemes, secret sharing).
  Weights are 2q+2 minus hyperplane incidence, i.e. **plane sections of the twisted cubic in PG(3,q)**
  (0/1/2/3-point secant/tangent/osculating/external planes) plus the axis correction — a completely
  classical orbit structure under PGL(2,q).
- *Cheapest test.* Map the five closed forms onto the classical twisted-cubic plane-orbit counts
  (Hirschfeld, *Finite Projective Spaces of Three Dimensions*) and do a one-shot literature check for
  "twisted cubic / NRC code weight distribution." Two outcomes, both cheap to reach: (i) they match a
  tabulated distribution → demote to a formalization+exposition win (still real, weaker); (ii) the axis
  augmentation genuinely shifts the counts off the tabulated NRC distribution → chase the moment proof.
- *Proof route if it survives.* Pless power-moments (you already have the partition identity as the
  0th moment, verified above) OR directly from the plane-orbit counts; **D-PC10/D-PC11 collapse this to
  a handful of PGL(2,q) orbit representatives** — that's their real value (see #3).
- *Biggest risk it's nothing.* The NRC/twisted-cubic evaluation-code weight distribution is very
  classical; there's a real chance this is known, making it formalization rather than discovery. The
  `LIT-OPEN` flag is exactly this, and the plane-section match settles it in one pass.

**2. The twisted cubic in PG(3,q) is a THIRD shared deep object — unify three lanes on it.**
- *Finding.* arcs' explicitly-parked "degree-d Veronese MDS hierarchy" (Register B) has its **d=3 rung
  sitting in the coding lane as D-PC9's code** (conic = degree-2 RNC in PG(2); twisted cubic = degree-3
  RNC in PG(3)). And completion §6.5's flagship-open "twisted-cubic transversal spectrum" τ at
  off-cubic points lives on the *same* curve. So coding (D-PC9 + published affine seed), completion
  (§6.5 open), and arcs (parked d=3) are independently touching one object, none citing the others.
- *Why it leads somewhere.* The moment/equivariance machinery transfers: coding's PGL(2,q)-equivariance
  (D-PC10/11) is the natural attack on completion §6.5's external-orbit hypergraph, and arcs'
  defect-identity/moment method is the d=3 analogue of D-PC9's weight moments. A single "twisted-cubic
  determinant-hypergraph" section could state what all three lanes are circling.
- *Cheapest test.* Check whether §6.5's external-point coplanar-triple hypergraph and D-PC9's
  plane-section counts are both computed from the **same PGL(2,q) plane orbits**
  (Bartoli–Davydov–Marcugini–Pambianco 1909.00207, which §6.5 already cites). If yes, the transfer is
  immediate.
- *Biggest risk.* It's connective tissue — high plausibility as framing, but may not yield a claim
  neither paper makes unless the equivariance actually closes part of §6.5.

**3. (Instrumental, fold under #1–#2) D-PC10 `T_a` + D-PC11 monomial-automorphism relabeling =
PGL(2,q)-equivariance of the whole repair-hypergraph functor.**
- `T_a(x₀,x₁,x₂,x₃)=(a³x₀+x₃, a²x₀−ax₁+x₂, ax₀+x₁, x₀)` is one Borel generator of the twisted cubic's
  ambient PGL(2,q) image; combined with inversion + scaling it plausibly generates the full
  order-(q³−q) stabilizer. That collapses D-PC9's proof and the uniform (ν,τ) rows to orbit counting.
  Chase = confirm the group closure; then D-PC9 falls out.
- **Correction to the coordinator's "one principle" framing:** D-PC11 (config automorphism ⇒ hypergraph
  relabeling) and Baer's Frobenius-orbit relabeling genuinely unify — both are *equivariance of a
  functor* from point-configurations to derived combinatorial objects. But the **arcs transitive-action
  lemma `|A||B|<|X| ⇒ disjoint translate` does NOT belong in that principle** — it's an
  averaging/pigeonhole *existence* tool, not equivariance. Don't merge them; that's two tools, not one.

### BANK (resolved/promoted, no residual chase)
- arcs Register B **defect = weight-two-leader collision identity** → codim-3 MDS: promoted,
  `SyndromeGeometry.lean`.
- arcs **q=11 exterior-secant design / comp-q11-exterior**: promoted, fed T3/C109; icosahedral
  P-position already a paper remark.
- coding Register A strengthenings — **transfer needs only r+1<2d(I⊥)**, **locality preserved for every
  s≤r**, **self-dual TVZ one-citation simplification**, **char-3-incl-q=3**: all already in the paper's
  contributions list (verified L141–163). Banked.
- Baer **collision-accounting B_ℓ correction** (C99, `CollisionProfile.lean`), **f=2 pair extension**
  (`Q25PairResult.f2_pair_extension`), and all four adversarial-review repairs (hypergraph
  disambiguation, heterogeneous-restating, natural-subtraction side condition, semantic bridge):
  closed/Lean-proved.
- arcs certificate-minimality / raw-vector certificate / covering-radius-from-two-certs, q11
  extension-complex classification, one-factorization corollary: elementary, proved, banked.

### PARK (real, low-odds or blocked)
- **Baer f=0,4** at PG(2,25): the paper's own headline open problem, needs center-incidence +
  moment-partition lemmas — not a quick chase.
- **arcs size-3→size-4 escape / drain lemma** for the odd-q game bridge: genuinely open, no cheap test.
- **field-generic dependence criterion** `e₁(st+su+tu)=e₂(s+t+u)`: cheap-if-idle probe — solve for
  projective uniqueness in char p≠3 to test for a non-char-3 second seed. Almost certainly dies (the
  "(s+t+u, st+su+tu) can't both vanish" miracle is char-3-specific), so PARK not CHASE.

### Verdicts on the two parked-but-tempting the coordinator named
- **arcs degree-d Veronese MDS hierarchy — NOT a mirage, but don't chase it abstractly.** The
  evaluation-avoidance dichotomy is already degree-agnostic, so the objects exist; and its d=3 rung
  *already exists* as D-PC9. Chase it *through* D-PC9/#2, not as a standalone "hierarchy." The mirage
  part is expecting the conic's clean two-moment exact-remainder split to survive to degree d — degree d
  has d moments and the exact q=11-style design is a two-moment (conic) accident.
- **Baer higher-degree Galois-orbit composition under products/field-reduction/concatenation —
  half-mirage.** The **field-reduction half is real** and is exactly the Galois-descent →
  linear-sets/rank-metric bridge (also flagged in completion §7.1); moderate odds, real payoff. The
  **products/concatenation half is speculative** and needs a new theorem before any claim, as the
  register says. Split them: pursue field-reduction, shelve concatenation.

**Bottom line:** one dedicated pass on D-PC9 — literature/plane-section match first (kill-or-confirm),
then the moment proof leveraged by D-PC10/11 equivariance — is the highest-EV move in the whole
inventory, and it drags the #2 twisted-cubic unification along for free.

---

## Opus verification addendum (2026-07-13)

I ran Fable's #1 cheapest test directly: an independent enumeration of the `[2q+2,4,q]_q` code and a
targeted prior-art search. Method: build the point set (projective twisted cubic
`{(1:t:t²:t³)} ∪ {(0:0:0:1)}` together with the characteristic-three axis line `{x₀=x₃=0}`), enumerate
all `(q⁴−1)/(q−1)` planes over the field (`galois`, proper GF(9) arithmetic), and tally weight =
`(2q+2) − |P∩H|` with each plane classified by its cubic-section size and whether it contains the axis.

**D-PC9 is confirmed exactly**, and each weight pins to a classical plane orbit:

| weight | q=9 count | q=3 count | orbit (cubic section, axis) | D-PC9 form   |
|--------|-----------|-----------|-----------------------------|--------------|
| 2q+1   | 240       | 8         | 0 cubic pts, non-axis (external plane) | N1 = q(q²−1)/3 |
| 2q     | 360       | 12        | 1 cubic pt, non-axis        | N2 = q(q²−1)/2 |
| 2q−1   | 90        | 12        | 2 cubic pts                 | N3 = q(q+1)    |
| 2q−2   | 120       | 4         | 3 cubic pts (3-secant)      | N4 = q(q²−1)/6 |
| q      | 10        | 4         | axis-contained (= char-3 osculating) | N(q+2) = q+1 |

All five counts match at q=3 and q=9; sum = `(q⁴−1)/(q−1)` (40, 820). The enumeration is a genuine
independent reproduction — different code path from the lane's replay.

**The informative part — the distribution is a clean split of the classical NRC distribution.** The
plain projective twisted-cubic-only `[q+1,4]` code (no axis) has four weights, from cubic-section
0/1/2/3; at q=9 its distribution is `{wt10:240, wt9:370, wt8:90, wt7:120}`. Augmenting with the axis:
the section-0/2/3 classes shift rigidly (→ N1/N3/N4), and the **section-1 class (370) splits**: the
`q+1` osculating planes — which *in characteristic three coincide with the axis-containing planes*
(the osculating plane at `s` is `x₃ = s³x₀`, which vanishes on the whole axis) — drop from weight `2q`
to the new minimum weight `q` (→ N(q+2) = 10), while the remaining `370−10 = 360` stay at weight `2q`
(→ N2). So **the only genuinely characteristic-three phenomenon is osculating-plane = axis-containing**;
everything else is the classical twisted-cubic plane orbits.

**Consequence for the proof route.** D-PC9's "general moment proof" reduces to the classical
twisted-cubic plane-orbit counts (external/tangent/secant/3-secant) plus the char-3 osculating=axis
coincidence — exactly what D-PC10/D-PC11 equivariance packages (Fable #3). It will land; the moment
proof is cheap, not a hard new argument.

**Register nit.** The D-PC9 row's "hence exactly `q²−1` minimum-weight words" is a mislabel: the
minimum weight `q` has `q+1` words (10 at q=9, 4 at q=3), not `q²−1`. `q²−1` is the count of the
*external* / maximum-weight class N1 at q=3 only (8); the phrasing conflates the two ends. The five
counts themselves are correct.

**Prior-art check — done (bounded search).** I read the candidate sources; the ingredients are
classical and published, but the *specific code* was not located.
- The DCC "extended coset leader weight enumerator of a twisted cubic code" (2103.16904) studies the
  **[q+1, q−3, 5]_q GRS code — the twisted cubic ALONE, no axis** (its answer depends on q mod 6). Not
  this code, though it uses the same plane classification.
- The Davydov–Marcugini–Pambianco orbit series (2103.12655, 2112.14803, 2604.14628; and 1909.00207)
  supplies exactly the plane/point/line orbit counts and the char-3 **"axis of the osculating
  developable"** as a *named* object, but stops at orbit/incidence classification — **no code
  construction**.
- Targeted searches for the `(cubic ∪ axis)` code / a `[2q+2,4]` five-weight code returned no
  construction. (The affirmative-sounding search-engine *summary* text is a confabulation — the actual
  returned links are only the orbit/coset-leader papers above, none of which build this code.)

Firm verdict: the `[2q+2,4,q]_q` five-weight code appears **not previously written down** — a
bounded-search "not located," not a priority certificate (a MathSciNet/zbMATH sweep + full text of the
DMP papers would be needed to be definitive). But it is a **short, natural step** from published
machinery: its weight distribution is derivable from the *same* twisted-cubic plane classification the
DCC coset-leader paper already uses, so a specialist in that exact line
(Bartoli/Davydov/Marcugini/Pambianco and the twisted-cubic-code authors) would likely see it as a
routine variant rather than a surprise. Net: this refines my first-pass call — D-PC9 is **real,
provable, cheap, and plausibly an unrecorded few-weight family, but modest-novelty and adjacent to an
active specialist program that could absorb it.** The durable prize remains (b) below.

The value that survives regardless of the novelty verdict is (a) the kernel-certified five-weight
family with an equivariant proof, and (b) Fable's #2 — it is the concrete `d=3` rung tying the coding,
completion §6.5, and arcs-Veronese lanes to one twisted-cubic object.

Enumeration script: `scratchpad/dpc9_check.py`. Prior-art sources:
- Davydov–Marcugini–Pambianco, twisted-cubic orbits/incidence in PG(3,q): arxiv 2103.12655,
  2112.14803, 2604.14628; *Mediterranean J. Math.* "Orbits of Lines for a Twisted Cubic."
- "The extended coset leader weight enumerator of a twisted cubic code," *Designs, Codes and
  Cryptography* (arxiv 2103.16904).
- Bartoli–Davydov–Marcugini–Pambianco, planes through points off the twisted cubic (arxiv 1909.00207,
  already cited by completion §6.5).

---

## Deep prior-art pass + second-order search + #2 scoping (Opus, 2026-07-13)

Full text of the twisted-cubic corpus read via `pdftotext` (`t_*.txt` in scratchpad): BDMP
1909.00207, 2604.14628, 2112.14803; Günay–Lavrauw 2103.16904.

### What the twisted-cubic program actually contains
- The code studied throughout is the **`[q+1, q−3, 5]_q` GDRS code** (codimension 4 = dimension q−3)
  associated with the twisted cubic — viewed as a **(3,µ) multiple covering of the farthest-off points
  (MCF)** and a minimal **(2,µ)-saturating (q+1)-set** of covering radius 3 (BDMP 1909.00207).
  Günay–Lavrauw (2103.16904) compute its **extended coset-leader weight enumerator**; a 2026 paper
  (2605.10594) does the **weight-2 coset distributions** of the GDRS code.
- The **external-point orbits under PGL(2,q) are fully classified, including char 3** (2604.14628;
  1909.00207 Thm 2.2). For q ≡ 0 (mod 3), points off C partition into M2 = **(q+1)Γ-points**
  (#=q+1) = **the axis points**, M3 = TO-points (q²−1), M4 = RC-points, M5 = IC-points; the point–plane
  incidence (number of 3-secant "dC-planes" through each orbit) is tabulated.
- The **char-3 axis is classical and named**: "the axis of the osculating developable Γ" — the common
  line of the osculating-plane pencil for q ≡ 0 (mod 3). D-PC9's "axis" is exactly BDMP's M2
  (q+1)Γ-point orbit.

### D-PC9 prior-art — firm verdict
The `[2q+2,4,q]_q` dimension-4 evaluation code from (C ∪ axis) is **not in this corpus** — every paper
studies the dimension-(q−3) GDRS code and its covering/coset structure, never the dim-4 axis-augmented
evaluation code. So D-PC9 is apparently unrecorded, but its novelty is **modest and fragile**: its
weight distribution is derivable directly from BDMP's published incidence tables (on-curve weights from
the C-orbit incidence; axis-coordinate contribution from the M2 (q+1)Γ-point incidence), and it lands
inside an active, dense specialist program (DMP + Günay–Lavrauw + Bartoli) that would treat it as a
natural variant. Bounded search, not a priority certificate — the only stronger step is a
zbMATH/MathSciNet cited-by sweep, beyond web tooling here.

### Second-order landscape (citing / related)
The twisted-cubic-in-PG(3,q) program is large and current: point/plane/line orbits and incidence
matrices (2103.11248, 2104.12254, 2103.12655, 2112.14803, 2604.14628), the O₆ external-line class
(2209.04910, 2210.12821, 2401.00333), planes-through-external-points + multiple covering codes
(1909.00207), coset-leader weight enumerator (2103.16904), weight-2 GDRS coset distributions
(2605.10594). **None construct the axis-augmented code or a minimum-transversal spectrum.** The closest
object to completion §6.5 is 1909.00207's (R,µ)-MCF **µ-density** — a covering *multiplicity*, not a
*transversal* — so §6.5's τ-spectrum is genuinely distinct from published work.

### #2 — the cross-lane theorem, scoped
**Object.** The twisted cubic C (degree-3 RNC, the d=3 rung of the conic's d=2) with its
3-secant-plane ("determinant") hypergraph, under PGL(2,q).

**The three lanes are invariants of this one hypergraph:**
- coding (D-PC9 + repair rows): on-curve weight distribution and (ν,τ) of the radius-r repair
  sub-hypergraph — provable now (classical orbit counts + char-3 osculating=axis; equivariance
  Lean-proved, D-PC10/11).
- completion §6.5: the **off-curve external-point transversal spectrum** ρ(x)=τ{3-secant planes
  through x} — **OPEN**, and now confirmed genuinely distinct from the published µ-density.
- arcs: the d=2 conic analogue — secant-defect identity + evaluation dichotomy.

**Target theorem (the prize).** *The external-point transversal spectrum ρ(x) of the twisted cubic is a
PGL(2,q)-orbit invariant; since the external points form finitely many orbits (in char 3: M2 axis / M3
TO / M4 RC / M5 IC, published) with known 3-secant incidence, ρ(x) is given by a per-orbit closed
form* — closing completion §6.5.

**Bridge (now verified viable).** Equivariance of the transversal functor (coding's D-PC10/11,
Lean-proved on-curve) makes ρ orbit-constant; BDMP supply the finite external-orbit list and the
3-secant incidence per orbit. So §6.5 reduces from "all x" to "≤4 orbit representatives." The **new**
work is converting each orbit's incidence into a minimum transversal τ — and §6.5's own caveat ("counts
do not determine the transversal numbers") says this last step is the content, not a triviality.

**Provable now vs open.** On-curve weights and the equivariance: now. Per-orbit external τ: open — the
genuine theorem.

**Risk (sharpened).** (a) Per-orbit τ might resist a closed form, or reduce to a covering quantity BDMP
effectively have; (b) reception — the whole object lives in the DMP/Günay–Lavrauw program, so even the
new τ-spectrum could read as an addendum. Mitigants: it closes a *stated* open problem (§6.5), the
Lean-certified equivariant reduction is the differentiator, and framing it as the d=2 ↔ d=3 bridge to
the arcs paper (one determinant-hypergraph, two curves) is a coherence story neither community states.

**Cheapest decisive next step.** Compute τ for the axis orbit (M2) and the TO orbit (M3) at q=9,27
directly (a finite transversal on the published incidence). If clean closed forms pop out, §6.5 is
crackable and #2 is a real theorem; if they resist, it is a harder problem than the framing suggests —
a scriptable half-day, exactly parallel to the D-PC9 enumeration.

**Second-order sources:** BDMP twisted-cubic corpus — 2103.11248, 2104.12254, 2103.12655, 2112.14803,
2604.14628 (orbits/incidence); 2209.04910, 2210.12821, 2401.00333 (O₆ external lines); 1909.00207
(planes off C + multiple covering codes); 2605.10594 (weight-2 GDRS coset distributions);
Günay–Lavrauw 2103.16904 (coset-leader weight enumerator).

---

## Computational verdicts + disposition (Opus, 2026-07-13)

Ran the deciders directly (scripts in scratchpad; ephemeral — constructions captured in the
[twisted-cubic transversal-spectrum handoff](handoffs/2026-07-13-twisted-cubic-transversal-spectrum.md)).

- **Equivariance backbone (Fable #3) — verified.** `⟨T_a, inversion, scaling⟩` generates the full
  stabilizer PGL(2,q): order `q³−q` at q=3 (24) and q=9 (720), every element preserving the cubic
  and the axis (0 failures). So τ (and the weight distribution, ν) are **orbit-constant by theorem**,
  and D-PC9 collapses to orbit counting.
- **D-PC9 — reproduced exactly** at q=3,9; five weights pin to plane orbits; the distribution is the
  classical NRC distribution split by the char-3 osculating=axis coincidence. **Bank as a certified
  five-weight family; do not market as a discovery.** Register nit: "`q²−1` minimum-weight words" is
  wrong — min weight `q` has `q+1` words.
- **External τ-spectrum (Fable #2 prize) — opening confirmed at q=9 and q=27.** τ is orbit-constant
  and **strictly finer than the published incidence counts** (equal-count orbits split in τ) —
  §6.5's own "counts don't determine τ" made concrete. Counts fit clean forms (`q(q−3)/6`,
  `q(q−1)/6`, `q(q+1)/6`); **the τ closed forms are the one open piece** (need q=81/243, or the
  projection reduction).
- **Route.** Project from x → τ(x) = `(q+1) − max-no-3-collinear-subset` of the projected plane
  cubic (three collinear ⟺ sum to O under the group law); the axis case reduces to a max
  no-3-sum-zero set in `(𝔽_q,+)` — the nofil sum-free object. Likely the closed-form route.

**Disposition — queued as C115–C120** (see the handoff): C115 opt-b (projection reduction, do
first) · C116 opt-a (q=81/243 τ via ILP) · C117 (prove D-PC9 weights by orbit counting + Lean +
mislabel fix) · C118 (definitive D-PC9 prior-art sweep) · C119 (determinant-hypergraph program
identity) · C120 (nofil fixed-locus/Witt leap).
