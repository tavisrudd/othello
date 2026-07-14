# C99 — collision correction and completion-spectrum plan

**Date:** 2026-07-13

## Objective

Find one concrete theorem that materially upgrades the equivariant-extension/robust-completion
paper. Run novelty gates before proof construction. The primary lane is a collision-corrected
Frobenius-orbit extension theorem; the fallback is a nontrivial exact completion spectrum.

This work must not contend with the long-running q=16 certificate build. Until that build finishes:

- allowed: source reading, theorem design, literature review, and edits to this standalone note;
- deferred: Lean builds, enumeration, generated data, and edits to shared q=16 or live routing files.

## Novelty gate: preliminary verdict

### Primary candidate — collision-corrected orbit extension

**Verdict: pursue, but call it a candidate contribution until a deeper audit.**

The general ingredients are established under several neighboring names:

- `(1,μ)`-saturating sets count secants through every external point, and connect directly to
  multiple coverings and covering codes;
- MDS coset weight distributions encode the same low-weight multiplicities for arcs;
- hyperfocused and generalized hyperfocused arcs study collisions of many secants on a small
  external blocking set;
- probabilistic saturating-set work already uses hypergraph covers and transversal numbers.

The shallow search did **not** find the specific combination needed here: quadratic Frobenius,
empty fixed/Baer lines, secant orbits rather than raw secants, an exact charge-fiber identity, and a
second-moment correction to conjugate-pair extension. That combination is plausibly distinct, but
absence from this search is not evidence of novelty.

Closest sources:

- Giulietti–Montanucci, *On Hyperfocused Arcs in PG(2,q)*:
  https://arxiv.org/abs/math/0601488
- Davydov–Marcugini–Pambianco, *On the weight distribution of the cosets of MDS codes*:
  https://arxiv.org/abs/2101.12722
- Nagy, *Saturating sets in projective planes and hypergraph covers*:
  https://arxiv.org/abs/1701.01379
- Bartoli–Micheli, *Algebraic constructions of complete m-arcs*:
  https://arxiv.org/abs/2007.00911
- Bartoli et al., *Algebraic approach to the completeness problem for (k,n)-arcs in planes over
  finite fields*: https://arxiv.org/abs/2302.10162

**Claim boundary:** do not claim invention of secant multiplicity, multiple saturation,
inclusion–exclusion, second moments, or collision counting. A possible contribution is the exact
equivariant restriction and the improved extension consequence.

### Fallback candidate — exact completion spectrum

**Verdict: ordinary conics and hyperovals are not novel enough.**

Their internal/external point classes and numbers of bisecants through each class are classical;
the MDS-coset literature explicitly translates these distributions into code language. A spectrum
for those families is useful exposition and a Lean-backed worked example, not a headline theorem.

A Baer subconic viewed in the ambient `PG(2,s²)` is a better supporting target. Its ambient strata
appear to be easy to compute, while the sources found concentrate on Bruck–Bose representations,
conic/Baer-subplane intersections, or externality rather than completion distance:

- Barwick–Jackson–Wild, *Conics in Baer subplanes*:
  https://arxiv.org/abs/1906.03296
- Pallozzi Lavorante, *External points to a conic from a Baer subplane*:
  https://arxiv.org/abs/2104.12434
- Giulietti, *Line partitions of internal points to a conic in PG(2,q)*:
  https://arxiv.org/abs/math/0607118

The resulting spectrum is still likely a new packaging of classical incidence, not new finite
geometry. Promote it only if the deeper audit finds either an unrecorded ambient distribution or a
non-obvious coding/completion consequence.

## Primary theorem design

Fix an invariant arc `C` and an empty fixed line `m`. For a conjugate candidate `q={p,σp}` on `m`,
define its charge multiplicity

```text
μ_m(q) = number of nonfixed secant orbits cutting out q on m.
```

The intended exact spine is:

1. **Fiber identity:** `μ_m({p,σp}) = pointIndex C p = pointIndex C (σp)`.
2. **Visible-mass identity:** the number of visible secant-orbit charges is `Σ_q μ_m(q)`.
3. **Forbidden-support identity:** `|Forbidden_m| = |{q : μ_m(q)>0}|`.
4. **Exact collision surplus:** visible mass minus forbidden support is
   `Σ_q (μ_m(q)-1)_+`.
5. **Second collision moment:** `Σ_q choose(μ_m(q),2)` is the restriction of the existing secant
   second moment to nonfixed points whose mate line is `m`.
6. **Quantitative correction:** using `μ_m(q)≤⌊k/2⌋`, convert a lower bound on the restricted
   second moment into an upper bound on `|Forbidden_m|`, hence a stronger legal-pair count.

The crucial mathematical gate is not identities 1–5; it is obtaining a useful lower bound on the
restricted second moment after excluding occupied mate lines and fixed intersection points.

## Decision gates

### Gate G1 — exact fibers

Budget: one focused day after the q=16 job releases resources.

Deliverable: prose proof and Lean statement for the fiber identity. If the fiber is not exactly the
point index, replace it with the correct incidence statistic before proceeding.

### Gate G2 — restricted moment

Budget: two additional focused days.

Deliverable: an exact decomposition of the global identity
`Σ_x choose(pointIndex C x,2)=3 choose(k,4)` into fixed points, occupied mate lines, and empty mate
lines. Continue only if this yields a nonzero correction in an infinite or structurally meaningful
parameter range.

### Gate G3 — paper value

Budget: two additional focused days.

At least one must hold:

- the extension threshold improves for an infinite family;
- equality in the original charge bound is excluded in a meaningful range;
- a genuine near-saturation stability statement follows;
- a named invariant family has a sharply better exact count.

The first concrete numerical target is the invariant eight-arc theorem at `s=5`. The present
uniform argument starts at `s≥7`. At `s=5`, the profiles `f=6` and `f=8` already pair-extend by the
existing count; only `f=0,2,4` can exhaust the ten candidates on an empty fixed line under the raw
`M` bound. A collision theorem that handles those profiles would lower the uniform threshold from
`s≥7` to `s≥5`, which clears this gate. Before claiming such a result, search explicitly for
classification or counterexample results on Frobenius-invariant eight-arcs in `PG(2,25)`.

Otherwise, demote collision identities to an appendix and execute the spectrum fallback.

## Spectrum fallback

First target: a conic `C` in the fixed Baer subplane `PG(2,s)`, viewed as an arc of
`PG(2,s²)`.

Expected odd-`s` strata:

- points of `C`;
- fixed external points, with `(s-1)/2` secants;
- fixed internal points, with `(s+1)/2` secants;
- nonfixed points whose unique Baer line is a secant, with index `1`;
- remaining nonfixed points, with index `0`.

The nonfixed index-one count should be
`choose(s+1,2) * (s²-s) = s²(s²-1)/2`; the other nonfixed points have index zero. Even `s` needs a
separate nucleus stratum. These formulas require a primary-source check before being presented as
anything beyond derivations from classical conic incidence.

Fallback gate: if this is entirely explicit in prior literature, retain it as a worked example and
move to a less classical invariant family rather than claiming discovery.

## Execution order

1. Finish the deeper bibliography pass around multiple saturating sets, MDS coset multiplicities,
   hyperfocused arcs, Baer subconics, and Galois-equivariant extension.
2. Write the exact fiber lemma and restricted-moment decomposition on paper.
3. After the q=16 build finishes, add a small generic multiplicity layer to
   `RelativeConicArcs/QuadraticForbidden.lean`; do not start with coordinates or enumeration.
4. Run G2 and G3 before investing in a full Lean API.
5. If the correction clears G3, formalize and integrate it into the main theorem spine.
6. Otherwise land only the reusable exact identities and execute the spectrum fallback.

## Current status

The preliminary novelty and general-literature gate is complete. The exact support/invisible/
collision identities are now Lean-proved, including their quadratic coordinate instantiation and
semantic aggregate extension consequence. The geometric correction closes `f=0,4` on paper, and
the certificate-free `Q25ProfileFour.profile_four_pair_extension` now kernel-checks `f=4`; the
proof ledger and remaining `f=0` formalization boundary are in
[`2026-07-13-c99-baer-collision-strengthening.md`](2026-07-13-c99-baer-collision-strengthening.md).

Gate G3 is partially cleared. The exact accounting and the entire exceptional `(f,e)=(2,3)`
existence theorem are Lean-proved; the external census/minimum remain data only. The uniform
order-five application is still open because `f=0` relies on unformalized moment geometry. The next
action is that profile's charge-multiplicity bridge and moment formalization. The spectrum fallback
remains deferred.
