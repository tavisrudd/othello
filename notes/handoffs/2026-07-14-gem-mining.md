# Gem mining — the second-gem hunt

**Lane**: `gem-mining` — see CLAUDE.md § Lane routing.
**Date**: 2026-07-14

**Entry doc for the lane.** The strategy and all computed results live in
[gem mining next steps](../2026-07-14-gem-mining-next-steps-fable.md) (numbered §1–§12); read it
first. This handoff is the map: what the lane owns, what is settled, what is open.

## What this lane is

The Clebsch hexagon is one hit. This lane exists to produce a second one on purpose. Its scope is
the *generator* — the machinery that converts compute into candidate structure — plus the hunts that
machinery opens. Findings that land in the Clebsch manuscript belong to `clebsch` and are pegged
there; the boundary is deliverable, not subject matter.

## The method (§9 of the strategy note)

Four rules, each load-bearing in the session that produced them:

1. **Generator = a complete census, never a curated list.** The domain needs an exhaustion guarantee
   — machine-enumerable at each parameter, or classified in the literature. The test to apply before
   building any detector: *what does a miss buy?* Over a census, a miss is a theorem; over a list, a
   miss is worthless. This is what killed the fill-signature detector.
2. **Invariant = valued in another classified category**, so a hit lands on a name: deep-hole locus →
   curve type, residual graph → named graph, stabilizer → named group, concurrence defect → design
   membership. Same-category size-equalities are numerology by construction.
3. **Declare the null before looking.** A hypothesized gap is "the bulk sits at ≥ X for forced
   reasons; anything at X is caused." This converts noticing into predicting.
4. **Upgrade protocol on any hit, immediately**: stabilizer, distance to second-best, perturbation
   instability, the same invariant at the neighbouring parameter.

**The fill-signature detector (`notes/2026-07-13-gem-candidates.md`) is retired**, not re-keyed: it
fails all four rules, and C132's re-key prescription fixed only the invariant's side. Keep the table
as the record of a closed spike.

## Settled

- **The E_q reduction.** Fix the conic `C` in PG(2,q), q odd. `E_q` = graph on off-conic points,
  adjacent iff their join is external to `C`. An *arc-clique* is a clique with no 3 points collinear;
  a *healthy* arc is an arc-clique whose secants cover every off-conic point outside it — equivalently
  an arc whose deep-hole locus is exactly the full point set of a conic. This is group-free,
  complete, and cheap, and it retires C132's "does not exhaust every P¹ route" caveat.
- **The healthy census, exhaustive for primes q ≤ 37**: healthy arcs exist exactly at q ∈ {3, 5, 11}.
  q=11 is the Clebsch hexagon (all-external, stabilizer A₅); q=5 is the projective frame
  (all-internal, stabilizer S₄, a k=1 sibling the C126 family tree missed by testing the wrong
  orbit); q=3 is degenerate. Prime powers q = 9, 25, 27, 49 are unswept — q=9 matters.
- **ω_arc census** (largest arc-clique): 3,4,4,6,6,6,6,8,10,10,10 for primes 3…37. Bounded by the
  pencil bound (q+3)/2, which is linear while the data look sublinear — that gap is unexplained.
- **Nonexistence for q ≥ 13 has no structural cause.** The crossing story (ω_arc falling below the
  covering threshold) is refuted: ω_arc ≥ n_min at q = 13, 23, 29, 31, 37, and the covering simply
  fails for finer reasons each time. Spectral routes are dead a priori — every external line is a
  (q+1)-clique, and E_q is not strongly regular (computed).
- **The object is classical.** It is the exterior-set geometry of a conic, with a lineage running
  Clebsch 1871 → Edge 1956 → Blokhuis–Seress–Wilbrink 1991/1992. The manuscript's citation debt is
  `clebsch`'s problem (C146); the conjecture is this lane's opportunity.

## Literature (swept 2026-07-14; notes `2026-07-14-gem-lit-{hexad,exterior-sets,omega-arc}.md`)

The pattern across three independent sweeps: **our geometric objects are all classical and we cited
the wrong ancestors; our coding reading of them is unclaimed.**

- **The paper's arc is Edge's.** Edge 1956 §§29–32 (read in full) constructs the q=11 object — six
  external points, fifteen joins skew to the conic — names them "Clebsch hexagons", and credits
  Clebsch 1871 for the real-plane antecedent. There are 22 of them over a fixed conic, each external
  point on exactly 2, organizing into two systems of 11 that each partition the 66 external points —
  the PGL∖PSL chirality motif again. BSW's "complete exterior set" of size (q+1)/2 is the same object
  renamed.
- **The covering fact is ours.** It appears in neither Edge nor Van de Voorde (both read in full).
  Conditioned on the two BSW originals, which are ILL-only and unread.
- **The hexad characterization is ABSENT from the literature**, and Edge is a false friend rather
  than a near-miss: his hexagons are 6 points chosen from the 66 *off* the conic; ours are 6 chosen
  from the 12 *on* it. His only on-conic Brianchon statement is at q=5, where the conic has exactly
  six points and no subset is chosen. He never mentions Mathieu, Steiner, or hexads.
- **Finiteness creates the phenomenon.** Halbeisen–Hungerbühler (J. Geometry 2024) study the same
  15-chord construction over ℝ/ℚ and find that no-accidental-concurrency is *generic* there, extra
  concurrence being measure-zero. Over F₁₁ it inverts: accidental concurrences are the norm, and the
  subsets avoiding them are exactly the Mathieu hexads. The question is not well-posed over an
  infinite field, so this cannot be a specialization of a classical fact.
- **Only one geometric hexad characterization exists** (Havlicek/Coxeter/Pellegrino's 12-cap in
  PG(5,3), hexads = hyperplane sections): different ambient space, incidence not concurrency. Curtis's
  kitten, Conway–Sloane, and Bailey use the same P¹(F₁₁) point set but never embed it as a conic.
- **ω_arc splits.** The all-external case *is* the BSW conjecture — their q=7 and q=11 examples match
  our ω_arc(7)=4 and ω_arc(11)=6, the first external validation of the census against independently
  computed ground truth. The **mixed internal/external case appears nowhere**: the literature is keyed
  to external points throughout and structurally cannot see the q=3, q=5, and q=19 configurations,
  which are all-internal.
- **Machinery aimed elsewhere.** Meagher–Spiga have character-theoretic spectra of the PGL₂(q)
  derangement graph, but for the whole group, not the involution class. Tranchida (2024) uses the
  identical involution↔point↔polar correspondence for a different question (product *order*, not
  elliptic-type). The commuting-involution-graph school never uses fixed-point-free adjacency. No
  source beats the pencil bound; ω_arc is not in OEIS.
- **The one existing coding link**: Van de Voorde connects sets-without-tangents to LDPC stopping
  sets. Nobody connects this object to MDS codes, covering radius, or deep holes.

**The census contributes nothing to the BSW conjecture — decided, not open.** Van de Voorde reports
the conjecture machine-checked for **q < 131**. Her two range statements are different claims, not a
contradiction: p.1 concerns the existence of non-linear (q+1)/2-exterior sets, checked to q < 131;
§3 states that within 11 < q ≤ 31 every such set contains three collinear points. A sweep to q=37
therefore recomputes inside an already-checked range. What remains of this lane's contribution is
the **mixed-type invariant** (absent from the literature, which is keyed to external points
throughout), the possibility of exact maxima, and the uninspected extremal-witness stabilizers. Do
not pitch the census as extending their range, and do not spend Rust effort on the sweep for that
reason. The correct citation for Van de Voorde is **Discrete Math. 311(20) (2011) 2253–2258** —
the arXiv journal-ref field for 1201.0484 is itself wrong, and the conjecture is **Combinatorica
1992**, not Giessen 1991.

**The deep-hole "first" is audited and survives.** No prior instance of a code's complete deep-hole
set being identified with the full rational-point set of a named positive-dimensional variety
(`2026-07-14-gem-lit-deep-holes.md`). ZWK's redundancy-4 result is a disjoint union of three
combinatorial families, not a variety-equality; in DMP's own examples the uncovered locus tied to a
named object is a single point or empty. Residual: Reed–Muller deep holes marked NOT SEARCHED, and
the two BSW originals remain unread.

## Open frontiers

- **C147 — the hexad characterization: verified, explained, and singular.** *A 6-subset of the conic
  in PG(2,11) is a hexad of one of the two S(5,6,12) systems iff no three of its chords are concurrent
  off it.* Machine-checked end to end; literature verdict ABSENT at full-text level.
  **Proof structure found** (`notes/2026-07-14-c147-proof-structure.py`): a concurrent triple of
  chords is a perfect matching of H, hence an involution stabilising H with no fixed point in it, so
  `t(H) = 60 + #{such involutions}` — verified for all 924. PGL₂(11) has exactly four orbits on
  6-subsets, stabilisers C₅/V₄/S₃/D₁₂ contributing 0/2/3/4, and **the hexads are the orbit whose
  stabiliser has odd order**. This explains the gap at 61 (no stabiliser has exactly one such
  involution) and re-derives the classical `{0} ∪ QR` seed as `{fixed point} ∪ {5-orbit}`,
  66×2×2 = 264. **The four-orbit classification is published** — Cameron–Omidi–Tayfeh-Rezaie,
  "3-Designs from PGL(2,q)", *Electron. J. Combin.* 13 (2006) #R50, Thm 4, whose `g_k(H)` is our
  invariant and whose hypothesis covers q=11, k=6; the substitution reproduces our table exactly
  (`notes/2026-07-14-gem-lit-orbit-classification.md`). So the converse closes by citation plus a
  short involution-content argument, and no 924-case enumeration survives in the proof. Cautions:
  the S₃ oddity was a `D_n` notation clash and our table matches the classical list; **do not cite the
  genus-2 literature for the table** (it classifies geometric automorphisms, ours are F₁₁-rational —
  the 110-orbit is μ₆ geometrically and μ₆ ⊄ F₁₁); and CO-TR §8 needs p > 23, so it cannot support
  the 132+132 PSL/PGL split.
  **The octad analogue at q=23 is DEAD** and the reduction explains why: the mechanism needs
  `|H| = 2×3`, so that a concurrent *triple* is a *perfect* matching. At `|H| = 8` a triple covers
  only 6 of 8 points, determines no involution, and there are 420 triples to avoid instead of 15
  (minimum t = 295 against a null of 280). Not a Mathieu tower — a coincidence of small numbers.
- **ω_arc growth** — DOWNGRADED. The all-external half is a recomputation inside BSW's checked range
  (above); the residue is the mixed-type invariant and the uninspected extremal-witness stabilizers
  at q = 23–37. Lowest-ranked item in this lane, not the second-place bet an earlier pass called it.
- **k=4 / twisted cubic** — the one direction where a hit is a new *kind* rather than a sibling
  (the parent analysis says the family runs through k, not p). Plausibly pegs `cubic` when opened.
- **The U-atlas** — all n-arcs of PG(2,q) up to PGL₃(q) for small q, invariant = curve-fit of the
  deep-hole locus. Drops C132's genus-0 prescription, which was a restriction by fiat: elliptic-curve
  targets are the cheapest route to a new kind of gem.

## Trust boundary

The census scripts are promoted and re-run: `notes/2026-07-14-c147-gem-sweep.py` and
`notes/2026-07-14-c147-mathieu-poles.py`, byte-identical to the artifacts that produced the reported
numbers (hashes in `2026-07-14-c147-hexad-polarity-characterization.md`). The census corroborates at
three independent points: the repo's own `check_q19_nonexample.py` (|U|=140), BSW's published q=7 and
q=11 extremal sizes, and Edge's 22 = 1320/60 hexagon count against the stabilizer-60 claim.

**The hexad claim is fully machine-checked** by `notes/2026-07-14-c147-hexad-characterization.py`:
both S(5,6,12) systems built and Steiner-verified, disjoint, swapped by every one of the 660 outer
maps, and the t=60 stratum equals their union exactly (264 = 132+132) with the gap at 61 confirmed.
The two-system form is forced — a polarity-defined invariant cannot separate systems that PGL₂(11)
exchanges — so it is a coherence check, not a weakness. The pencil bounds, the degenerate-conic
impossibility, and the torus-clique collinearity remain reasoned, not machine-checked.

**Companion log**: append dated riffs to `done/2026-07-14-gem-mining-archive.md` (create on first
archive).
