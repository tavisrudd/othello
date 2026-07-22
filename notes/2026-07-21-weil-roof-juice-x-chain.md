# Weil-roof juice-mining pass — latent structure in the X-chain (C446/C460/C447/C448)

**Lane:** `crowns` (exploratory memo, not an evidence bundle; no queue/handoff edits)

**Date:** 2026-07-21

**Executor:** exploratory sub-agent, Opus

**Motivation:** C443's "four-companion blocker" turned out to be an unrecognized `Z/4` Galois
torsor (`notes/2026-07-21-c443-torsor-hunch-check.md`). This memo hunts the selector/repair
X-chain for the same kind of latent structure — failures that are really equivariance, and positive
repairs that carry unstated Galois/functorial content.

All numbers below are one of three registers, kept sharp:

- **[computed]** — exact/combinatorial arithmetic, from a frozen committed certificate or the
  scratch script below; no floating point.
- **[prose]** — a claim quoted from a landed report.
- **[spec]** — my speculation / a proposed statement to be proved elsewhere.

Reproduce the [computed] rows with, from `/home/tavis/src/othello`:

```bash
python3 <scratch>/juice_tests.py
```

(`<scratch>` = `/tmp/claude-1000/-home-tavis-src-othello-rust/146b5f8f-d308-4e66-aaf6-b97f7b3d7b12/scratchpad/`).
It reads only the committed `c443-commuting-with-reduction.json`,
`c460-golden-fregier-cloud-bridge.json`, and `c447-cap-knife-edge.json`.

---

## Ranked candidates

| # | candidate | leverage × cheapness | verdict |
|:--|:--|:--|:--|
| A | **C443's M3a blocker *is* C448's selector lemma with `G = Gal(Q(ζ₅)/Q) = Z/4`; the "one bit" is a prime of `Z[φ]` above 11** | high × free (assembled from frozen certs) | **CONFIRMED** from certificates |
| D1 | **C460's cloud-overlap-5 graph = "matchings share exactly one conic edge" = C447's 66 shared-edge pairs — one relation, not three** | high × cheap | **CONFIRMED** by fresh exact compute |
| B | **The prime bit (A), the base/outer sheet bit, and C447's `det`-character bit are the *same* `C2`; on the char-11 side it is the `PGL₂/PSL₂` outer swap** | high × medium | **PARTIAL** — identification computed; the σ→outer-swap reduction is UNTESTABLE-WITHOUT-CONVENTION |
| E | **The 12 conic points are `P¹(F₁₁)` = the 12 Weierstrass points of `y²=x¹¹−x`; the recurring 66 is `C(12,2)` = Weierstrass pairs** | medium × free | **CONFIRMED** (structural), feeds C451 |
| C | **Fixed-vs-free split: the Galois-invariant objects (degree-1 discrepancy `{4,7,9}`, C460 perpendicularity triangle) are the fixed part; companions/sheets/primes are the free `Z/2` part** | medium × free | framing, grounded in [computed]+[prose] |

---

## A — C443's blocker is literally C448's selector lemma (Galois `G`)

**Hypothesis.** C448's selector lemma (a `G`-fibre `p^{-1}(x)={y₊,y₋}` on which the stabilizer `Gₓ`
acts through a surjective character `χₓ:Gₓ→C2` has no equivariant section) applies verbatim with

- `G = Gal(Q(ζ₅)/Q) = Z/4 = ⟨σ⟩`, `σ:ζ→ζ²`, `σ²=κ` (complex conjugation);
- `Y =` the four companion `A5`-orbits; `X =` the two primes `{π, π̄}` of `Z[φ]` above 11;
- `p:` companion ↦ the `Z[φ]`-prime at which it hits a frozen C406 sheet.

Then C443's "selecting a different companion in each special fibre would be the post-hoc prime
selection M3a forbids" [prose] is exactly "`p` has no `G`-equivariant section."

**Frozen data that tests it** [computed, from `c443-...json/finite_reductions/records` and
`blocker/kappa_candidate_permutation`]:

| prime | companions in fibre | sheet | `κ` on the fibre |
|:--|:--|:--|:--|
| `π` (φ≡8) | `{c0, c3}` (ζ=4,3) | base | `κ=(0 3)(1 2)` **swaps** `c0↔c3` |
| `π̄` (φ≡4) | `{c1, c2}` (ζ=5,9) | outer | `κ` **swaps** `c1↔c2` |

- `p` is `G`-equivariant: from the torsor memo (H2/H3), `σ` is the 4-cycle `(0 2 3 1)` on companions
  and `z→z²` on residues `3→9→4→5`, i.e. `π→π̄→π→π̄` — `σ` **swaps the two primes** [prose,
  torsor memo]. `σ²=κ` fixes each prime.
- The stabilizer of `π` in `G` is `⟨κ⟩` (order 2). It acts on the fibre `{c0,c3}` by the swap
  `(0 3)` [computed above]. So `χ_π:⟨κ⟩→C2` is **surjective** — the selector-lemma hypothesis holds
  on the nose.

**Verdict: CONFIRMED.** C443's four-companion obstruction is the `G=Z/4` Galois instance of C448's
`C2`-chirality lemma, and C448's "one advice bit" is literally "choose a prime `π` vs `π̄` of `Z[φ]`
above 11" — a `Gal(Q(φ)/Q)=Z/2`-torsor (the quotient `⟨σ⟩/⟨κ⟩`). No new computation was needed
beyond re-reading two certificates against the lemma's hypotheses.

**What it buys.** This is the exact wording C462 asks for — "state the `Z[ζ₅,1/N']` object with its
`κ`-descent obstruction." The descent obstruction is not a defect of labeling; it is the surjective
character `χ_π` on the decomposition group `⟨κ⟩`. A base-changed replacement tensor for paper-1's cut
clause must be a genuine Galois-descent datum for `p`, and A says precisely which cocycle it must
kill. **Feeds C462 directly; no new allocation.**

---

## D1 — three "66"s are one relation

**Hypothesis.** C460's H3 cloud-overlap graph (join two clouds when they meet in **5** points, 66
edges [prose]) and C447's 66 shared-edge cross-sheet matching pairs [prose] are the *same* relation
on the 22 H3 matchings, namely "share exactly one conic edge."

**Test** [computed, within C460's own frozen `canonical_row_order` ledger — label-independent, so it
needs no alignment between the two certs]:

- Among all `C(22,2)=231` pairs of H3 matchings, the shared-edge histogram is `{0: 165, 1: 66}` —
  every pair shares 0 or 1 edges; exactly **66** share one.
- All 66 share-one-edge pairs are automatically **cross-sheet** (`share-1 all cross-sheet: True`);
  same-sheet matchings never share an edge.
- **`overlap-5 graph == share-exactly-one-edge graph : True`** — identical 66-edge sets.
- C447's 66 records form a 22-vertex, 66-edge, 6-regular, bipartite-`11+11` graph [computed] — the
  same invariants; it is the same relation carried by C447's independent labeling.

**Verdict: CONFIRMED**, and stronger than posed: "two H3 clouds meet in 5 points," "the two matchings
share one conic edge," and "the pair is cross-sheet" are three names for one 66-edge object. C447's
"cross-sheet" qualifier is redundant — sharing an edge forces it.

**What it buys.** C460 (X1+, sheet recovery) and C447 (X2, cap-facing bridge) are certified against
*the same* graph. So the cap's smallest-orbit edge selector (C447) and the intrinsic sheet-pair
recovery (C460) are one functor, and C447's `PGL₂(11)`-equivariance transports to C460's cloud graph
for free. **Feeds C445/M5 gluing** (a single equivariant 66-object to glue, not two) **and C450**
(the module of the `22×… ` cross-sheet incidence is the module of this one graph). Also the concrete
edge-rule "`|C(M)∩C(M')|=5 ⇔ |M∩M'|=1`" is a clean lemma C445 can cite without re-deriving clouds.

---

## B — the prime bit, the sheet bit, and the `det` bit are one `C2`

**Hypothesis.** The `Z/2` advice bit appears three times and is always the same:

1. Galois / prime: `σ mod κ` swaps `π ↔ π̄` (candidate A).
2. Sheet: `π↔base`, `π̄↔outer` [computed, C443 records: `π`'s two companions both hit `base`,
   `π̄`'s both hit `outer`], so the prime bit *is* the base/outer sheet bit.
3. `det`: C447's `D10` frame acts on its size-2 P orbit through the `PGL₂(11)` determinant
   character; the `det`-nonsquare part swaps the two matchings of a cross-sheet pair — one base, one
   outer [prose]. So C447's advice bit is the sheet swap, realized by an outer (`PGL₂/PSL₂`) element.

Chaining: **choose a member of a `κ`-fibre (C448) ⇔ choose `π`/`π̄` (A) ⇔ choose base/outer sheet
(the frozen reduction) ⇔ apply a `det`-nonsquare `PGL₂(11)` element (C447)**. The `Z/2`-torsor is
uniform across the char-0 Galois side and the char-11 group-theoretic side.

**Tested pieces** [computed]: the prime↔sheet identification is exact and frozen (A's table). C447's
`det`-swap = sheet-swap is [prose] from a green certificate.

**Untested link — UNTESTABLE-WITHOUT-CONVENTION.** The load-bearing claim "the Galois prime-swap `σ`
*reduces to* the `PGL₂(11)` outer automorphism" compares a field automorphism (which moves `φ`) with
a fixed-field group element. Verifying it needs a stated char-0→char-11 comparison map and a choice
of `PGL₂(11)` coset representative for the outer swap — exactly the datum C445 must fix. Missing
convention: the reduction-compatible identification of the two `σ`-conjugate fibres inside one
`PGL₂(11)` (M5's "glue the two Galois-conjugate fibers into one orbit"). I did not invent one.

**What it buys.** This is the spine of **C445** (char-0 lift boundary of the gluing) and the
"outer-swap exchange" clause of **C450**. B says the exchange C450 must verify is forced: it is the
same `C2` already visible three ways. A bounded next step (candidate for C445 or a C450 sub-check,
*not run here*): exhibit one `det`-nonsquare `g∈PGL₂(11)` whose action on the 22 clouds swaps
C460's two sheets and matches the shared-edge bijection's endpoint swap — if it exists and is unique
up to `PSL₂(11)`, B upgrades to CONFIRMED.

---

## E — the 12 points are the Weierstrass points of `y²=x¹¹−x`

**Hypothesis.** The recurring 12 and 66 are not coincidences: the 12 conic points are `P¹(F₁₁)`,
which is the branch/Weierstrass locus of the genus-5 hyperelliptic curve `y²=x¹¹−x` (its roots
`x¹¹−x=0` are all of `F₁₁`, plus `∞` — 12 points), and `66=C(12,2)` is the set of Weierstrass pairs.

**Test** [computed]: the H3 matchings use exactly the 12 labels `{0,…,11}`; `C(12,2)=66` = #conic
edges = #overlap-5 cloud pairs = #C447 shared-edge pairs. So the 66-object of D1 is a matching/subset
structure on Weierstrass pairs.

**Verdict: CONFIRMED (structural coincidence is exact).** This is not proof of a moduli
interpretation, but it pins the arithmetic object: matchings ↦ subsets of the 12 Weierstrass points,
sheets ↦ two families, edges ↦ the 66 pairs. **Feeds C451 directly** — its "matchings↦Lagrangians in
`J[2]`, sheets↦Lagrangian packings of the 66 Weierstrass classes, Cartier–Manin of `y²=xᵠ−x` (here q=11)" is
about precisely this curve; D1's 66-edge graph is a ready-made incidence structure on its Weierstrass
pairs for the Arf/theta-parity sheet-separation test. No new allocation.

---

## C — fixed part vs free part (organizing framing)

Across the chain the objects split cleanly by the `Z/4`/`Z/2` action:

- **Free part** (carries the torsor / the one bit): the four companions, the two `Z[φ]`-primes, the
  two `PSL₂(11)` sheets, C447's two-set P orbit. All are permuted freely by `σ`/`det`.
- **Fixed part** (Galois-/prime-invariant): the degree-1 discrepancy vector `{4,7,9}`, **identical on
  both `κ`-pairs** [computed, torsor memo H4 / C443 `kappa_pair_moment_review`]; and C460's
  perpendicularity triangle `{[1:0:0],[0:1:0],[0:0:1]}`, which C460 proves is **prime-independent**
  [prose] — i.e. Galois-invariant, the common reduction of the six golden axes at both `φ→8` and the
  conjugate.

**Reading.** The perpendicularity germ (C460, M5's finite shadow) and the degree-1 kernel obstruction
(C443) are the *same kind of object* — the `Gal`-fixed subspace — while every "which one?" failure in
the chain lives in the free `Z/2` quotient. A future paper-1 replacement tensor may exist only in the
fixed part; the C461 negative (zero lower-moment kernel) says the fixed part is too small to carry the
cubic by linear weighting, consistent with this split. This reframes, it does not add a result; it
tells C445/C462 to look for the tensor among invariants and to treat the sheet/prime choice as
genuinely external data.

---

## What was ruled *not* juice

- **C446's order obstruction `2(q+1)=12,16,24` vs stabilizer `24,24,60`** — the "failure locus" is
  already fully extracted as C460's Frégier cloud (A5-stable, recovers sheets). The numeric clash of
  `24` (dihedral `D₂₄`, pencil stabilizer) with `24` (`S4`, golden-pair setwise stabilizer, C460) is
  a same-order/different-group collision, not a shared structure. No further gem here.
- **C448's `q=5` copycat / `K6`-minus-a-matching antipodal involution** — this is the *split*
  one-sheet control with no chirality bit [prose]; it is the degenerate `q≡?` end of the family, not a
  hidden torsor. Correctly outside the `Z/2` story.

---

## Provenance and boundary

[computed] rows come from `<scratch>/juice_tests.py` reading the three committed JSONs named at top;
trusted boundary is exact Python integer arithmetic, the frozen C406/C443/C447/C460 conventions, and
the hash-pinned ledgers inside those certificates. This memo proves no new theorem: A and D1 and E
re-assemble frozen certified facts into sharper statements; B's core link and the C445 next step are
explicitly deferred as UNTESTABLE-WITHOUT-CONVENTION. Nothing here edits a cap-lane artifact, claims
novelty, or allocates a task. The candidates feed C462 (A, C), C445/C450 (D1, B), and C451 (E, D1).
