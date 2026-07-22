# The master stroke — one icosahedron, two elevens (integral golden model)

**Lane:** `crowns` (read-only `clebsch` inputs)

**Date:** 2026-07-21

**Status:** design note, SPECULATIVE with a REASONED core; no allocation, no manuscript change.
Companions: the conversation dossier, the execution program (battery T1 is this theorem's first
test), and the depth-injection note.

**Status update 2026-07-22:** claims 1--4 are certified; claim 5's role is superseded by the
certified torsor close (`2026-07-20-clebsch-paper-planning.md`, Close revision) — the bit is
carried arithmetically by the prime fiber, and the characteristic-zero Galois realization is C487's
`Spec Q(sqrt5)` row, not an integral Galois-odd cubic. C479 remains paused as an optional upgrade.

## The statement

**Conjectured theorem (integral golden model).** The H3 spine is defined over `Z[φ]`, and the
entire q = 11 configuration is its reduction at the split prime `11 = π π̄`:

1. The icosahedron's 12 vertices, as points of `P^1` over `Q(sqrt 5)`, reduce **bijectively onto
   `P^1(F_11)`** at either prime above 11. This is the conic phase itself: the classical vertex
   count of the rank-3 polytopes is `h + 2`, and `|P^1(F_q)| = q + 1 = h + 2` exactly at
   q = h + 1 (octahedron 6 at q=5, cube 8 at q=7, icosahedron 12 at q=11).
2. The icosahedron has a **unique** `A5`-invariant perfect matching of its 12 vertices — the
   antipodal matching. (Proof sketch: the 66 vertex-pairs fall into `A5`-orbits of sizes 6
   (antipodal), 30 (edges), 30 (short diagonals); an invariant matching is an invariant 6-set of
   pairs, hence a union of orbits, and only the antipodal orbit has size 6.)
3. The two mod-11 sheets are the **two reductions of the one golden object**: reducing via π gives
   one `A5 ⊂ PSL_2(11)` and its fixed matching; reducing via π̄ gives the other. The two
   singleton depth fibres (C406: "the base matching and its J-mate") are the two reductions of
   the single antipodal matching. The golden involution J **is** the nontrivial element of
   `Gal(Q(sqrt 5)/Q)`.
4. The exceptional `PGL_2(11)` symmetry is a **purely characteristic-11 gluing** of the two
   Galois-conjugate fibers into one orbit — extra symmetry appearing at the split prime, the same
   genre as extra endomorphisms at supersingular reduction (Deuring), and the same genre as the
   Roquette automorphism jump.
5. `mu_3` is the reduction of an integral golden tensor on which J acts by −1; its ±6 readout is
   the mod-π shadow of a Galois-odd integral invariant.

Uniformly: B3 is the silver case (`Z[sqrt 2]`, cube, `7 = (3−√2)(3+√2)`); A3 is the fused case
(5 inert in `Q(sqrt 2)`: the two would-be fibers are Frobenius-conjugate and fuse, so there is
one sheet and no bit) — reproducing C406's splitting criterion as a **reduction-theoretic
mechanism**, not a group-theoretic accident.

## Why this is the master stroke

It is the single move after which the other moves are corollaries:

- **The six shadows collapse into one theorem.** Every incarnation of the bit — Frobenius choice
  (definitionally), theta parity, design polarity, cubic sign, Weil-component exchange, advice
  bit — becomes a functorial image of `Gal(Q(sqrt 5)/Q)` acting on one integral object. The
  Rosetta table stops being six verified coincidences needing a conjectural roof and becomes one
  specialization theorem with six corollaries. The sheet reciprocity law is **functoriality of
  reduction**, not a law to be checked pairwise.
- **C417 is explained, not just proved.** The cocycle is nontrivial because the global torsor is
  nontrivial: `Q(sqrt 5) ≠ Q`. No canonical sheet exists because no canonical prime above 11
  exists. The paper's central impossibility becomes a one-line consequence of Galois theory.
- **The paper's one-liner writes itself.** The Clebsch hexagon is not an exceptional object at
  q = 11; it is the ordinary golden icosahedron, observed at the prime where its two Galois
  conjugates coexist in one world and can be confused. **The decoder's missing bit is
  `Gal(Q(sqrt 5)/Q)`, made finite.**
- **The cliffhanger prophecy becomes the same theorem's next instance.** `31 ≡ 1 mod 5` splits in
  `Z[φ]`: the H4/600-cell phase is the golden model's rank-4 reduction statement, waiting on
  machinery — the prophecy now has a mechanism, not just a law.
- **It is cheap relative to its yield.** C377 already built the integral golden map and the
  split/inert/ramified descent; battery T1 is precisely this theorem's first falsifier; the
  antipodal-matching uniqueness is elementary; what remains is showing the conic-quotient and
  moment machinery commutes with reduction (finite linear algebra over `Z[φ, 1/N]`).

## Boundary and risks

- The full 22-point `PGL_2(11)` orbit does **not** lift: over `Q(sqrt 5)` the group is only the
  geometric `A5`, and each sheet is `A5`-visible only as fixed-matching + 10-orbit (the
  2-transitive 1 + 10 split). The integral model carries the `A5`-visible part; the gluing into
  one `PGL_2(11)` orbit is stated and proved in characteristic 11. The theorem must be phrased so
  this is a feature (the char-11 gluing IS claim 4), not a gap.
- Claim 1 (bijective reduction of vertices onto the full projective line) is checkable
  immediately and is the load-bearing miracle; if it fails in the frozen normalization, the model
  needs a twist, not abandonment — record exactly which quadratic twist repairs it.
- Commuting-with-reduction for the harmonic quotient needs denominators controlled (invert only
  finitely many primes; 11 must not be inverted). This is bookkeeping but it is the step where a
  subtle failure would hide.
- None of this claims novelty for golden reductions per se (reduction of icosahedral structures
  mod split primes is classical territory — Kostant, Serre, and the C377 audit's boundary);
  the candidate-new content is the identification of the **factorization-memory spine** (sheets,
  singleton fibres, `mu_3`, the bit) with the reduction data.

## Strategic consequence

If T1 lands, do not book it as Rosetta row 5. Book it as the first certificate of this theorem,
and promote the integral golden model to paper 1's closing theorem — the Rosetta table then hangs
from a proved spine, the conjecture that survives for paper 2 is only the Weil-roof *mechanism*
of the char-11 gluing, and the cliffhanger sharpens to its best form: one golden object, two
elevens, and a rank-4 door that the same Galois group already has a key to.
