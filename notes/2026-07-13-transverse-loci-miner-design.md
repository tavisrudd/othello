# Transverse-loci miner — design sketch (for C84 odd-q cap abundance)

Goal it serves: prove `#{y : 𝒢(y)=0} ≥ c·q²` (positive-density P-positions) in the odd-q conic
game. The wall (per the abundance-first frontier): every known forced-value certificate is a
**dim-1** locus (homography fixed loci, Θ(q) points); density needs a **dim-2** family. This miner
hunts dim-2 abundance by finding *pairs/pencils of dim-1 forced-P loci that are transverse and
jointly sweep Θ(q²) points* — the automated form of what C84 attempts by hand. NOT the fill-signature
miner (that finds singular dim-0 gems; wrong quantifier — see C130).

## Data model
- **Local type** `T` = a symmetry class of the residual configuration (subgroup type of
  H_S=⟨σ_x⟩: V₄ / D₈ / S₄ / A₄ / generic), each with a **forced Grundy value** `𝒢(T)` when it is
  forced, and the **residue conditions** on q (mod lcm of the periods) under which it occurs
  (congruence-periodicity — already established for the catalogue).
- **P-locus** `L(T,r)` = { centres y giving local type T with 𝒢=0, at q ≡ r } — a **dim-1**
  variety (parametrized by ~1 free coordinate, Θ(q) points), described by its defining
  homography/fixed-locus + the trace-classifier (elliptic/split) conditions.

## The search (coincidence over locus *intersections*, not size-equalities)
For each residue class r and each unordered pair (or short pencil) of P-loci
`{L(T_i,r)}`:
1. **Transversality test:** are the loci in general position — is
   `dim(∪ L_i)` = 2, i.e. do they sweep a 2-parameter region rather than piling onto the same
   Θ(q) curve? (Compute the span of their tangent/parameter directions; reject if collinear /
   nested — that's the degeneracy that keeps everything dim-1.)
2. **Joint P-persistence:** on the swept region, does 𝒢=0 *stay* forced (not just at the two seed
   loci but on their union / the pencil interpolating them)? Check via the residual/Node-Kayles
   evaluator on sampled points of the region; a pencil survives only if P persists across it.
3. **Density estimate:** `|swept ∩ {𝒢=0}| / q²` → keep pencils with estimate ≥ c₀ (target the
   ≈0.13 conic-only-P density as the bar).

## Scoring (rank candidates)
`score = density_estimate  ×  transversality_margin  ×  1[P persists on ≥90% sampled]  ÷  (# residue
conditions)`  — reward genuinely 2-parameter, robustly-P, low-congruence-obstruction families.
Penalize pencils that collapse to dim-1 under any q (the trap).

## Output
Ranked list of candidate dim-2 abundance families: (residue r, local types, swept region, density
estimate, the persistence witness). A surviving high-score candidate = a **construction to prove**
(the miner finds it; the proof that P persists uniformly in q is then the C84 lemma).

## Honest caveats
- This is a **discovery** tool, not a proof: a surviving pencil is a conjecture (`≥c·q²` on that
  family) still needing a uniform-in-q Grundy-arithmetic proof — abundance is off-conic, so the
  exchange/transfer lemma the queue already flags remains required.
- Sampling density on a dim-2 region at fixed q is exact-computable for small q (q=11–29); the
  miner's job is to spot the family, then push it to a residue-class theorem.
- If **no** transverse P-pencil survives across residues, that too is information: it would say the
  dim-1 wall is real and abundance must come from a genuinely different (arithmetic, not geometric)
  mechanism — matching the queue's note that the bound "must be Grundy-arithmetic."

## Why this is the right shape (vs the fill-miner)
Fill-miner: size(config)=size(space) → singular object, dim 0, one q. Transverse-loci miner:
intersection of forced-value loci → parametrized family, dim 2, all q by residue. The abundance
target is dim-2-uniform-in-q, so only the second shape can reach it. Same *coincidence-detector*
idea, retargeted from size-equalities to locus-transversality.

## POC result (2026-07-13)
Mechanism validated: a QR-gated pencil of dim-1 loci over PG(2,q) sweeps density ~0.42→0.47 (→1/2), bounded below uniform in q (q=11..31), vs 1/q→0 for a single locus. Gate = QR proxy for the elliptic/split trace condition; real next step = swap in the repo Grundy oracle for `t in S`. Script: scratchpad/miner_poc.py.
