# C58 — Cap game on the four projective planes of order 9 (order vs Desarguesian structure)

Date: 2026-07-10.  Executed by Claude (independent compute lane, alongside Codex on C61).

Full spec: item F of
[`handoffs/2026-07-09-spinoff-bridges-duals-isomorphisms.md`](handoffs/2026-07-09-spinoff-bridges-duals-isomorphisms.md);
queue entry `C58` in [`2026-07-07-codex-task-queue.md`](2026-07-07-codex-task-queue.md).

## Question

Order 9 is the smallest non-Desarguesian order, and there are exactly four projective planes
of order 9 (Lam–Kolesova–Thiel): the Desarguesian `PG(2,9)`, the Hall plane, its dual, and the
Hughes plane.  Non-Desarguesian planes are not self-dual in general (Hall vs dual Hall are
non-isomorphic), so the cap game and its dual genuinely differ there and the outcome becomes a
candidate invariant of the *plane*, not of the order.  This isolates the odd-plane conjecture's
dependence: is `PG(2,q) = P` an *order* phenomenon or a *Desarguesian-structure* phenomenon?

Payoff either way (per the falsification map / genericity test):
- **Any N verdict** would prove the conjecture is about Desarguesian structure rather than order
  — a falsification-map constraint and the program's first N geometry (stop-and-report, C43
  protocol).
- **All-P** pressures the eventual uniform proof to use *less* algebraic structure than conic
  localization currently does (conic localization is Desargues-specific machinery).

## Result (outcome table)

| plane      | structure                                | Desarguesian | self-dual | value | first player |
|------------|------------------------------------------|:------------:|:---------:|:-----:|:------------:|
| `PG(2,9)`  | Desarguesian (field GF(9))               | yes          | yes       | **P** | loss         |
| Hall       | translation plane (reversed regulus)     | no           | no        | **P** | loss         |
| dual Hall  | dual translation plane (literal dual)    | no           | no        | **P** | loss         |
| Hughes     | near-field plane (Hughes 1957)           | no           | yes       | **P** | loss         |

**All four order-9 planes are P** (first-player loss), matching the odd-plane conjecture — no
falsification.  The four planes are pairwise non-isomorphic (distinct complete-arc spectra below),
so this is genuinely *four different geometries of order 9, all P*.  Two consequences worth stating:

- **The game value is blind to Desarguesian structure at order 9.**  Non-Desarguesian planes have
  no conic/oval structure of the Desarguesian kind, yet they are P just like `PG(2,9)`.  This is
  the "all-P" branch of the C58 dichotomy: it pressures the eventual uniform odd-plane proof to use
  *less* algebraic structure than conic localization — that machinery is Desargues-specific
  scaffolding, not the load-bearing mechanism, since the property survives its removal.
- **The value does not separate a plane from its dual.**  Hall and dual Hall are non-isomorphic
  (confirmed below) but both P; the duality comparison the task was built to run yields *equal*
  outcomes.  The value is an isomorphism invariant, so equal outcomes on a non-isomorphic pair is
  a real (if negative) datum: outcome is a coarse invariant here.

## Method

Two independent artifacts (neither reuses the coordinatized grid/frame solver, which cannot
represent non-Desarguesian planes):

- `rust/scripts/c58_order9_planes.py` — constructs each plane as pure incidence data and
  machine-verifies it (the C48 honest-construction discipline):
  - **Axioms + parameters** (all four): exactly 91 points, 91 lines, 10 points/line, 10
    lines/point, every point-pair on exactly one line, every line-pair meeting in exactly one
    point.
  - **Desargues counterexample search**: certifies non-Desarguesian-ness by exhibiting perspective
    triangles whose three cross-line intersections are non-collinear.  PG(2,9) passes Desargues on
    all tested configs; Hall / dual Hall fail (5 witnesses each).
  - **Cross-check**: the *un-reversed* regular spread reproduces a Desarguesian plane — validates
    the spread machinery independently of the field construction.
  - Constructions:
    - `PG(2,9)`: points = normalized nonzero triples over GF(9) = GF(3)[i], i²=−1; lines = covector
      kernels.
    - Hall: spread of GF(3)⁴ with the standard regulus `{aI : a∈GF(3)} ∪ {∞}` reversed to its
      opposite regulus (computed directly as the 2-subspaces meeting each regulus component in a
      point — no reliance on a remembered quasifield formula), then the translation plane of that
      spread.
    - dual Hall: literal incidence dual of the Hall plane.
    - Hughes: Dembowski's homogeneous construction (Canad. J. Math. 23 (1971) 481–494, = Hughes
      1957) over the order-9 Dickson near-field `N` (`a∘b = a·b` if `b` is a nonzero square,
      `a³·b` if `b` is a nonsquare; kernel/center GF(3)).  Points = nonzero GF(9)-triples mod
      **right** near-field scaling `x ~ x∘f`; the 91 lines are the 13 Singer-cycle images (matrix
      `α = [[0,0,2],[1,0,0],[0,1,1]]`, order 13 mod scalars) of 7 base lines
      (`{x₂=0}` and `{x₁ + f∘x₂ + x₃ = 0}` for the six `f ∈ GF(9)∖GF(3)`).
      **Independent cross-check:** this construction's complete-arc spectrum is byte-identical to
      the published Hughes-plane incidence table (GEM database, arXiv:1602.00588 Table A.1), and
      both solve to the same value — so the constructed plane is the Hughes plane (spectrum is an
      isomorphism invariant).  The ground-truth table is kept as `scripts/c58-data/hughes_gt.inc`.
- `rust/scripts/c58_cap_solve.rs` — exact cap-game solver over an arbitrary plane given as
  incidence data (`.inc` file).  Memoized negamax with short-circuit, keyed by the 128-bit cap
  bitmask (raw transposition memo, no symmetry reduction needed).  Same game semantics as the
  reference grid solver's `g`: a move adds a point avoiding every secant; normal play; a position
  is N iff some child is P; `PG(2,q) = P ⇔ empty position solves to P`.

### Identification cross-check — complete-arc spectrum (isomorphism invariant)

The number of *complete* (maximal) arcs of each size is an isomorphism invariant and the classical
distinguisher of the order-9 planes (`c58cap … --census`, DFS over all ≈1.3×10⁸ arcs, ≈1.2 s each):

| plane     | complete-arc spectrum (size: count)                              | total arcs   |
|-----------|-----------------------------------------------------------------|-------------:|
| PG(2,9)   | 6:707616, 7:2021760, 8:5307120, 9:0, **10:58968**               | 128,917,712  |
| Hall      | 6:38880, 7:5598720, 8:8184240, 9:77760, 10:9720                 | 129,762,704  |
| dual Hall | 6:38880, 7:4976640, 8:8184240, 9:77760, 10:9720                 | 129,762,704  |
| Hughes    | 6:11232, 7:6273072, 8:8381880, 9:50544, 10:2808                 | 130,158,896  |

Consequences (all machine-checked):
- **All four spectra are pairwise distinct ⇒ the four planes are pairwise non-isomorphic**, as
  required (there are exactly four planes of order 9, so these are all of them).
- **Hall ≇ dual Hall** (spectra differ only at size 7) — so Hall is genuinely not self-dual and the
  duality comparison is nontrivial, as the task premise requires.
- PG(2,9) has **no complete 9-arc**; the three non-Desarguesian planes do — a known order-9
  distinguisher.
- PG(2,9)'s complete 10-arcs number **58,968 = 9⁵ − 9²**, the exact count of conics in `PG(2,q)`
  (all ovals are conics for odd `q`, Segre).  This closed form independently validates the GF(9)
  construction, the incidence build, and the solver's legality logic.
- The Hughes spectrum matches the published GEM-database table exactly (independent construction),
  confirming the near-field build.

### Calibration gate — PASSED

The solver reproduces every established value from pure incidence input, no coordinates:

| plane     | value | nodes   | max arc | note                              |
|-----------|:-----:|--------:|:-------:|-----------------------------------|
| PG(2,2)   | P     | 30      | 4       | `PG(n,2)` closed family; hyperoval q+2 |
| PG(2,3)   | P     | 120     | 4       | exhaustive-solve value            |
| PG(2,5)   | P     | 2,098   | 6       | Lean theorem value                |
| **PG(2,9)** | **P** | **493,556** | **10** | **the required C58 calibration** |

Max arc sizes are geometrically correct (hyperoval `q+2` at even `q=2`; ovals `q+1` at odd `q`).
The raw whole-plane solve is trivially feasible at order 9 (≈0.1 s, <1M nodes) — short-circuit +
transposition memo keep the explored set ~500K, far below the ~10⁸ total-arc count, so no
collineation-orbit canonicalization was needed.

Per-plane solve stats (order 9, raw whole-plane solve from empty):

| plane     | value | nodes   | memo    | max arc | wall  |
|-----------|:-----:|--------:|--------:|:-------:|------:|
| PG(2,9)   | **P** | 493,556 | 493,556 | 10      | 0.09s |
| Hall      | **P** | 745,860 | 745,860 | 10      | 0.12s |
| dual Hall | **P** | 644,805 | 644,805 | 10      | 0.10s |
| Hughes    | **P** | 565,420 | 565,420 | 10      | 0.09s |

(node/memo counts are label-dependent, not isomorphism invariants; they only witness feasibility.
The verdict P and max-arc 10 are the invariant facts.)

## Interpretation

All four projective planes of order 9 are **P** (first-player loss).  The odd-plane P-property
holds across the entire order-9 family — Desarguesian and all three non-Desarguesian planes alike.

- **This is the "all-P" branch of the C58 dichotomy.**  No N geometry appeared, so C58 does *not*
  supply a counterexample or prove the conjecture is "about Desarguesian structure."  Instead it
  removes Desargues as a *possible* explanation: the property is invariant across the four
  non-isomorphic order-9 planes, so whatever forces P at order 9 does not need the field/conic
  structure that conic localization leans on.  Concretely for the proof program: a uniform odd-plane
  argument that routes through conic localization is using Desargues-specific *scaffolding*; the
  underlying mechanism must survive its removal (the non-Desarguesian planes have no conics-through-
  five-points in the Desarguesian sense, yet are P).  This sharpens the genericity-test note's read
  that "conic localization is not disposable scaffolding" — it is not disposable *as a computed
  route at Desarguesian q*, but the order-9 evidence says the *outcome* it computes is not
  Desargues-dependent.
- **The value is a coarse invariant.**  Four pairwise-non-isomorphic planes share the value; the
  Hall/dual-Hall duality (a genuinely non-self-dual pair) yields equal outcomes.  So the game value
  alone will not distinguish planes — the finer invariants (complete-arc spectra) do.
- **Evidential weight (per the genericity test).**  Order-9 all-P is *weak* positive evidence for
  the conjecture (the genericity test already showed P-frequency oscillates in density bands, so a
  fixed small order agreeing is partly band coincidence); the value of C58 was the *asymmetry* — an
  N would have been doubly informative.  That asymmetry resolved on the all-P side, so the payoff is
  the structural constraint above, not a frontier advance.

### What would change this

The only C58 follow-up with new information content is a larger non-Desarguesian order: the next is
order 16 (there are 22+ planes of order 16, many non-Desarguesian) or order 25/27.  Order 16 is
even (`PG(2,16)` is P by the char-2 mirror; the non-Desarguesian order-16 planes are the live
question) and solver-feasible (273 points) but a bigger raw solve; order 25/27 are odd and larger.
None is queued here — flagged as a possible C58-successor if the all-P-vs-structure question is
worth re-pressuring at a second order.

## Artifacts / reproduction

- `rust/scripts/c58_order9_planes.py` — build + verify all four planes; writes
  `rust/scripts/c58-data/{pg29,hall,dualhall,hughes}.inc`.  Run: `python3 scripts/c58_order9_planes.py build`.
- `rust/scripts/c58_cap_solve.rs` — incidence-input cap solver.
  Build: `rustc -O -C target-cpu=native scripts/c58_cap_solve.rs -o target/c58cap`.
  Solve: `target/c58cap scripts/c58-data/<plane>.inc`.
  Complete-arc spectrum: `target/c58cap scripts/c58-data/<plane>.inc --census`.
- `rust/scripts/c58-data/*.inc` — the four order-9 planes + small-order calibration planes
  (`pg22`, `pg23`, `pg25`) + `hughes_gt.inc` (published GEM-database Hughes table, arXiv:1602.00588,
  for the independent cross-check).
- Calibration (all reproduce established values from pure incidence input): PG(2,2)=P, PG(2,3)=P,
  PG(2,5)=P, PG(2,9)=P.
