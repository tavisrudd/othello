# Twisted-cubic cross-lane: external-point transversal spectrum + D-PC9 disposition

**Lane**: `cubic` — see CLAUDE.md § Lane routing.

**Date**: 2026-07-13
**Status**: C115 DONE (reduction + axis cap-set law, Lean-certified strict-trust); TO/RC/IC exact
forms are the remaining open piece → C116. Live map for the cross-lane program that grew out of the
Discovery-Track triage.
**Next session**: **C116 (opt-a)** — ILP q=81/243 for TO/RC/IC (and guard the axis prediction
τ(81)=61, τ(243)=198). Optional: axis Lean cert + §6.5 promotion.
**C115 report**: [twisted-cubic τ reduction](../2026-07-13-c115-twisted-cubic-tau-reduction.md).
**Companion finding**: [discovery-track review](../2026-07-13-discovery-track-review-by-fable.md)
(Fable triage + Opus verification addenda).
**Related lanes**: coding [`projective-completion`](2026-07-13-projective-completion-repaircodes.md)
(D-PC9/10/11 live here); completion §6.5 twisted-cubic transversal spectrum
(`../../papers/completion-core-rigidity/2026-07-10-completion-core-rigidity-upgrades.md`).

## The object (one curve, three lanes)

The twisted cubic `C ⊂ PG(3,q)` (degree-3 RNC = the `d=3` rung of the conic's `d=2`), with its
`3`-secant-plane ("determinant") hypergraph, under the stabilizer `PGL(2,q)` (order `q³−q`). Three
otherwise-separate lanes are invariants of this one object:
- **coding (D-PC9):** on-curve — the `[2q+2,4,q]_q` code from `C ∪ axis`; its weight distribution is
  the plane-section spectrum.
- **completion §6.5:** off-curve — `ρ(x)=τ{B∈C(C,3): x∈⟨B⟩}`, the external-point transversal
  spectrum. **This is the prize** (a stated open problem).
- **arcs:** the `d=2` conic analogue — secant-defect identity + evaluation dichotomy.

## Verified this session

1. **Equivariance backbone (was Fable #3) — DONE.** `⟨T_a, inversion, scaling⟩` generates the full
   stabilizer: order `q³−q` at q=3 (24) and q=9 (720), and every element preserves both the cubic
   and the axis as sets (0 failures). `T_a(x₀,x₁,x₂,x₃)=(a³x₀+x₃, a²x₀−ax₁+x₂, ax₀+x₁, x₀)` realizes
   the char-3 translation `t↦t+a` on the cubic. Consequence: **every PGL(2,q)-invariant (weight
   distribution, ν, τ, the external τ-spectrum) is orbit-constant** — the observed τ-unanimity is
   forced, not luck; and D-PC9's proof collapses to orbit counting.
2. **D-PC9 five-weight distribution — reproduced exactly** (independent GF(3)/GF(9) enumeration).
   Weight `2q+2 − |plane∩(C∪axis)|`; each weight pins to a plane orbit: `2q+1`↔external (0 cubic
   pts), `2q`↔1, `2q−1`↔2, `2q−2`↔3-secant, `q`↔axis-contained (= char-3 osculating). It is a clean
   **split of the classical NRC distribution**: the char-3 coincidence *osculating plane = axis plane*
   drops the `q+1` osculating codewords from weight `2q` to the new minimum `q`. **Register nit to
   fix:** D-PC9's "hence exactly `q²−1` minimum-weight words" is wrong — min weight `q` has `q+1`
   words (10 at q=9, 4 at q=3).
3. **External-point τ-spectrum — opening confirmed at q=9 and q=27.** τ is exactly orbit-constant
   and **strictly finer than the incidence counts** (two orbits with equal count split in τ). Data:

   | orbit (char 3) | size | #3-secant planes through x | τ(q=9) | τ(q=27) |
   |----------------|------|----------------------------|--------|---------|
   | TO             | q²−1 | `q(q−3)/6`                  | 3      | 15      |
   | RC             | —    | `q(q−1)/6`                  | 4      | 14      |
   | IC             | —    | `q(q+1)/6`                  | 4      | 14      |
   | axis ((q+1)Γ)  | q+1  | `q(q−1)/6`                  | 5      | 18      |

   The **counts fit clean forms** (above). **Update (C115):** the axis τ IS closed —
   `τ_axis = q − r₃(h)` (cap-set law, verified q=9/27/81: 5, 18, 61). TO/RC/IC τ do not fit clean
   forms from two orders (`(q+1)/2` guess dead) — they are caps in `E(𝔽_q)` / `𝔽_q^×`, the open
   piece → C116.

## Prior-art disposition (D-PC9)

Deep read of the BDMP twisted-cubic corpus (1909.00207, 2604.14628, 2112.14803) + Günay–Lavrauw
2103.16904: they study the **`[q+1,q−3,5]_q` GDRS code** (dimension q−3) as a multiple-covering /
saturating set, its coset-leader enumerator, and the point/plane/line orbits — the char-3 "axis of
the osculating developable" is a *named classical object* — but **none construct the dim-4
`(C∪axis)` code or a minimum-transversal spectrum**. D-PC9 is therefore apparently unrecorded but
**modest/absorbable** (weight distribution derivable from BDMP incidence tables; lands inside an
active program). Bounded web search, not a certificate → C118 for the definitive zbMATH/MathSciNet
sweep. **Bank D-PC9 as a certified five-weight family; do not market as a discovery.**

## The prize and the route (opt-b first)

`ρ(x)=τ` is genuinely distinct from BDMP's `(R,µ)` covering **µ-density** (a multiplicity, not a
transversal) — §6.5's own caveat "counts do not determine τ" is now demonstrated (equal-count
orbits, different τ). So the external transversal spectrum is a real, orbit-structured, unrecorded
invariant.

**Route (C115, opt-b) — DONE.** Project from `x`: `π_x` sends `C` to a plane cubic (via the quotient
`PG(3,q)/⟨x⟩`); `{P,Q,R}` coplanar-with-`x` ⟺ `det[P,Q,R,x]=0` ⟺ their `π_x`-images collinear. Hence
`τ(x) = (q+1) − (max no-3-collinear subset of π_x(C))`, and 3 collinear ⟺ they sum to a fixed class
`c₀` under the chord-tangent group law (singular point always addable). Orbit → cubic type dictionary
(measured q=9,27): **axis → cuspidal `v²=u³`** (smooth locus `(𝔽_q,+)`, coord `φ(t)=1/t`, cusp `t=0`);
**IC → nodal** (`𝔽_q^×`); **TO, RC → smooth elliptic** (`#E=q+1`, split by `c₀`/flex). **Axis closed
form:** `τ_axis = q − r₃(h)` (cap-set law, verified q=9/27/81 = 5/18/61) — collapses §6.5's axis orbit
onto the cap-set / nofil sum-free problem and reuses the formalized `zeroSumCapNumber`. TO/RC/IC exact
forms (caps in `E(𝔽_q)` / `𝔽_q^×`) are not closed from two orders → C116. Full writeup:
[C115 report](../2026-07-13-c115-twisted-cubic-tau-reduction.md).

**Confirmation (C116, opt-a — after).** q=81 (`3⁴`, even exponent) + q=243 (`3⁵`, odd) via an **ILP
solver (HiGHS/CBC)** on 4 orbit reps each — NOT raw branch-and-bound (τ grows ~linearly in q, so
depth-τ search blows up). Instances are tiny in memory; the LP relaxation is likely tight on these
symmetric instances. Pins/guards the C115 forms against exponent-parity effects.

## Task map (C115–C120)

- **C115 [opt-b] — REPORTED 2026-07-13.** Projection→plane-cubic reduction proved; orbit→type
  dictionary measured; **axis closed form `τ_axis = q − r₃(h)`** (cap-set law, verified q=9/27/81).
  §6.5 axis orbit reduced to the cap-set problem; reuses `zeroSumCapNumber`. TO/RC/IC forms → C116.
  **Lean cert DONE** (strict-trust `RepairCodes.ProjectiveTwistedCubicTransversalSpectrum`,
  `projectiveTwistedCubicSecantTransversal_infinity`, standard axioms); §6.5 paper promotion pending
  review. [report](../2026-07-13-c115-twisted-cubic-tau-reduction.md),
  [discovery log](../2026-07-13-c115-discovery-track.md).
- **C116 [opt-a, STARTED 2026-07-13, DEFERRED — next session]** compute q=81 + q=243 τ-spectrum via
  ILP (TO/RC/IC only; axis is closed). Script: [`2026-07-13-c116-tau-spectrum-ilp.py`](../2026-07-13-c116-tau-spectrum-ilp.py).
  - **Axis already confirmed at q=81** (no ILP): `c115_axis81.py` gives edge set =
    `zeroSumTripleHypergraph(𝔽₈₁)` + isolated cusp (1080 edges), so `τ_axis(81)=81−cap₃(4)=61` from
    the known `cap₃(4)=20`. Likewise `τ_axis(243)=198` from `cap₃(5)=45`. Only TO/RC/IC remain.
  - **Perf lesson:** CBC times out (>500 s) on the smooth/nodal cap ILPs — these ARE hard cap
    problems (caps in `E(𝔽_q)`/`𝔽_q^×`). Next session: **use HiGHS** (`--with highspy`, or
    `pulp.HiGHS_CMD`), and/or a dedicated cap search; precompute the 4 reps once (don't recompute
    edges per candidate). q=81 first, then q=243 (chunk the det; ~2.4M triples).
  - **Structural lead (discovery I5):** TO/RC are smooth elliptic `#E=q+1` split by the collinear
    sum-constant `c₀` (rational-flex presence); IC nodal `𝔽_q^×`. Fit `M` as max-no-3-sum-`c₀` subset
    per group. Data so far (M=(q+1)−τ): TO q9/27 = 7/13; RC 6/14; IC 6/14 (RC=IC in τ at both — check
    whether they split at q=81). See [discovery log](../2026-07-13-c115-discovery-track.md).
- **C117** prove the D-PC9 five-weight distribution via PGL(2,q) orbit counting (uses the verified
  equivariance + classical plane orbits + char-3 osculating=axis); Lean-certify; fix the `q²−1`
  minimum-weight mislabel (→ `q+1`).
- **C118** definitive D-PC9 prior-art: zbMATH/MathSciNet cited-by sweep of the BDMP corpus +
  Günay–Lavrauw for a `(C∪axis)`/axis-augmented `[2q+2,4]` predecessor; settle before any promotion.
- **C119** record the "circuit/determinant hypergraphs of small linear dependencies" program
  identity in `papers-planning.md` (twisted cubic as the d=3 rung tying coding ↔ completion §6.5 ↔
  arcs; double-claim coordination, like √(2q)).
- **C120 [separate nofil thread]** scope+attempt the fixed-locus reduction law + quadric-Witt
  dichotomy (Fable Leap 1→2): outcome computed on `Fix(ι)`; provable core `P/N` via
  move-to-fixed-point recursion (impartial, not strategy-stealing); target the elliptic `Q⁻`
  boundary as a Witt/type invariant. B+→A on the nofil flagship.

**Continuation-paper recognition follow-up:** C204 computes automorphism groups, spectra,
orbitals, and coherent-configuration data for bounded N1 continuation graphs, then tests whether
they are known cross-ratio/finite-geometry families or support a general new automorphism theorem.
It is pegged `cubic` but does not displace C116 as this handoff's next step. See the
[expert-question portfolio](../2026-07-15-expert-questions-upgrade-portfolio.md).

## Reproduction notes (scratchpad scripts are ephemeral)

Constructions used (regenerate in `rust/` or `uv run --with galois`): cubic
`{(1:t:t²:t³)}∪{(0:0:0:1)}`; char-3 axis `{x₀=x₃=0}` = `{(0:1:s:0)}∪{(0:0:1:0)}`; `T_a`, scaling
`diag(1,g,g²,g³)`, inversion = coordinate reversal. τ(x) = min hitting set of `{triples of cubic
points coplanar with x}` (branch-and-bound at small q; ILP at q≥81). Equivariance = BFS closure of
the projective matrix group, check order `q³−q` + set-preservation.
