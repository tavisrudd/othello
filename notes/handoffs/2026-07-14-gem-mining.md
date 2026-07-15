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
- **The object is classical.** It is the exterior-set geometry of a conic: Edge 1956 and
  Blokhuis–Seress–Wilbrink 1991/1992, the latter with a conjecture open since 1991 that our census
  supports past their computational range. The manuscript's citation debt is `clebsch`'s problem
  (C146); the conjecture is this lane's opportunity.

## Open frontiers

- **C147 — the hexad characterization.** *A 6-subset of the conic in PG(2,11) is a hexad of
  S(5,6,12) iff no three of its chords are concurrent off it.* Computed, with a gap in its spectrum
  (61 never occurs), the t=60 stratum being exactly the two Steiner systems. Gated on the literature
  sweep; the natural extension is octads of S(5,8,24) on the conic of PG(2,23).
- **ω_arc growth as a BSW strengthening** — the all-external restriction *is* their conjecture; the
  mixed-type curve is new. The extremal witnesses at q = 23–37 are uninspected: compute their
  stabilizers.
- **k=4 / twisted cubic** — the one direction where a hit is a new *kind* rather than a sibling
  (the parent analysis says the family runs through k, not p). Plausibly pegs `cubic` when opened.
- **The U-atlas** — all n-arcs of PG(2,q) up to PGL₃(q) for small q, invariant = curve-fit of the
  deep-hole locus. Drops C132's genus-0 prescription, which was a restriction by fiat: elliptic-curve
  targets are the cheapest route to a new kind of gem.

## Trust boundary

The census scripts (`gem_sweep.py`, `mathieu_poles.py`) were written in a session scratchpad and are
**not in git**; their SHA-256 prefixes are recorded in the strategy note's header. Nothing here is
durable until they are promoted to repo verifiers under C147. The pencil bounds, the
degenerate-conic impossibility, and the torus-clique collinearity are reasoned, not machine-checked.

**Companion log**: append dated riffs to `done/2026-07-14-gem-mining-archive.md` (create on first
archive).
