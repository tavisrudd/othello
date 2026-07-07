# Part III top-items research pass (2026-07-07)

Scope: quick prior-art and first-deliverable pass for the highest-leverage Part III items in
`2026-07-07-post-fable-agenda.md`. This is not a final bibliography; it is a go/no-go scoping
note for what can be advanced after the Part I/II gates.

## Executive read

1. **Item 1, torus/modular no-three-in-line, is still the best beyond-CGT starter**, but the
   first deliverable must be a specification note, not code. Literature uses closely related but
   not identical "line" definitions on `Z_n^2`; for composite prime powers, the determinant-zero
   test is explicitly not sufficient for collinearity. Freeze the convention, implement both
   checks for small `n`, and only then port the grid-cap solver.
2. **Item 12, solved-game certificates, remains the best area-opener on ceiling, but is blocked
   by C11 maturity.** The current overlay says C11 is not yet a working reply-book checker; do not
   sell "DRAT for games" until there is a native checker, a Lean checker or Lean-skeleton checker,
   and a measured certificate-size table. Qubic is the right first public instance once the
   certificate datatype handles N-positions.
3. **Item 13, verified small-geometry database, should be seeded as a static snapshot plus
   validator, not as infrastructure.** LMFDB is the right model for "mathematical objects plus
   links and completeness regimes", but v0 should just accept certified rows from our own censuses.
4. **Item 2, verified finite-geometry classifications, is viable only with a small first target.**
   Complete-arc classifications in `PG(2,23)`/`PG(2,25)` or one saturating-set classification are
   better first targets than hyperovals in `PG(2,32)`. The hyperoval result is famous, but its
   original proof relied on specialized group/search arguments; use it as a stretch target.
5. **Item 3, Segre in Lean, has no obvious public Lean formalization from web search.** mathlib
   has projectivization/cardinality foundations, but the missing layer is finite projective-plane
   vocabulary: arcs, secants/tangents, conics, and ovals. First milestone: a design doc and
   statement layer, not the theorem.
6. **Item 16, SAT/QBF benchmark plus certified isomorph rejection, splits cleanly.** The benchmark
   half is a real near-term deliverable because positional-game-to-QBF encodings and QBF strategy
   validation already exist. The isomorph-rejection proof-logging half is the research wedge;
   state it as "gap + prototype", not as a solved proof-format claim.
7. **Item 4, maximal sum-free-set census, is cheap but should be framed as exact small data.**
   Current literature is asymptotic and structural; our niche is exact orbit tables and maximality
   certificates for small finite abelian groups, not a new Green-Ruzsa-scale theorem.

## Item 1: torus/modular no-three-in-line

Prior art found:

- Misiak, Stepien, Szymaszkiewicz, Szymaszkiewicz, Zwierzchowski, "A note on the
  no-three-in-line problem on a torus", Discrete Math. 339 (2016), states the discrete torus
  problem and proves an upper bound of `2n` for an `n x n` torus, with the prime case solved.
  Source: https://www.sciencedirect.com/science/article/pii/S0012365X15002915
- Skotnica, "No-three-in-line problem on a torus: periodicity", proves periodicity of
  `(tau_{z,n})_n` for fixed `z`, records that `tau_{m,n}` is known when `gcd(m,n)` is prime,
  and uses the bound `tau_{m,n} <= 2 gcd(m,n)`.
  Source: https://arxiv.org/abs/1901.09012
- Ku and Wong, "On No-Three-In-Line Problem on m-Dimensional Torus", define a line in
  `Z_{l_1} x ... x Z_{l_m}` as `{a + t b : t in Z}` and prove higher-dimensional bounds/equality
  criteria.
  Source: https://link.springer.com/article/10.1007/s00373-018-1878-8
- Stepien and Szymaszkiewicz, "Arcs in Z^2_{2p}", is the useful warning source: it discusses
  projected integer lines versus cyclic-subgroup cosets, notes that prime `n` recovers `AG(2,p)`,
  and gives a concrete prime-power obstruction where determinant zero is not sufficient.
  Source: https://arxiv.org/abs/1512.02175

Concrete first deliverable:

- `torus-no3-spec.md`: define points, line convention, collinearity checker, automorphism/canon
  group, and validation gates.
- Implement a pure enumerator for `n <= 10` under both candidate line conventions and compare
  against published `tau` values where available.
- Then port grid-cap search to the chosen convention for `n = 6,8,9,10,12,14,15,16,18,20,21,22,24`.

Kill risks and gates:

- Prior-art surprise is real for exact values up to the low 20s. Do not claim novelty before a
  value-by-value table is reconciled with Kurz, Misiak-Stepien, Skotnica, and related arXiv notes.
- The code port is not "unchanged": the line generator and canon group are the mathematical core.
  The solver skeleton ports; the correctness proof needs a new line-convention lemma.

## Item 12: universal certificate standard for solved games

Evidence for the gap:

- Checkers was weakly solved with a strategy from the starting position and an online computer
  proof; the Science paper explicitly discusses weak/strong solving and independent verification,
  but not a standard third-party proof format.
  Source: https://www.cs.mcgill.ca/~dprecup/courses/AI/Materials/checkers_is_solved.pdf
- Takizawa's Othello paper announces a weak solution and publishes code/raw outputs, but again the
  verification story is artifact trust, not a small independent proof checker.
  Source: https://arxiv.org/html/2310.19387v3
- SAT is the contrast case: DRAT-style proof logging has become a community standard with
  independent checkers and mechanically verified checkers.
  Source: https://arxiv.org/html/2401.10703v1

Concrete first deliverable:

- v0 format spec for finite two-player perfect-information outcome certificates:
  `P(node) = one legal reply for every opponent move`, `N(node) = one winning move plus P-child`,
  terminal claims, hash/versioning, and subcertificate composition.
- Native checker first. Lean checker second. Position paper only after both check at least Qubic.
- Measurement table: Qubic certificate size, queens n=18 sample/candidate certificate size, checker
  wall time, mutation tests caught.

Disagreement with the agenda text:

- The phrase "near-zero marginal tooling" is too optimistic as of the current overlay. C11 P0a did
  not become a working checker path. Keep item 12 ranked high on ceiling, but do not let it block P2.

## Item 13: verified small-geometry database

Prior-art model:

- LMFDB's stated mission is to organize mathematical objects, expose interrelations, and combine
  computation/classification with searchable concrete data.
  Source: https://arxiv.org/abs/1511.04289
- Finite-geometry arcs/caps remain an active survey/open-problem domain.
  Source: https://www.mdpi.com/2227-7390/13/9/1489

Concrete first deliverable:

- v0 static snapshot, not a service: JSON/SQLite rows for our own affine cap spectra,
  permutation-arc census, arc cross-check rows, and later torus no-three rows.
- Every row must include canonical form, automorphism size when available, generation trace hash,
  checker version, source note, and completeness regime.
- Validator before UI. The database should be "a checker that stores accepted rows".

Kill risk:

- Maintenance gravity. Avoid accounts, uploads, and live infrastructure until an external group asks
  for write access. Papers cite frozen snapshots.

## Item 2: verified finite-geometry classification certificates

Prior art found:

- Bartoli, Faina, Marcugini, and Pambianco determine minimum complete-arc sizes in `PG(2,31)` and
  `PG(2,32)`, classify several minimal saturating sets, and state that the results come from a
  computer-based exhaustive search exploiting projective equivalence.
  Source: https://link.springer.com/article/10.1007/s00022-013-0178-y
- Coolsaet and Sticker classified complete `k`-arcs in `PG(2,23)` and `PG(2,25)`, with follow-up
  classifications for `PG(2,27)` and `PG(2,29)` cited in the Bartoli et al. reference list.
  Source: https://doi.org/10.1002/jcd.20211
- Penttila and Royle classified hyperovals in `PG(2,32)` by exhaustive computer search, proving six
  isomorphism classes and eliminating final small-stabilizer cases.
  Source: https://link.springer.com/article/10.1007/BF01222672

Concrete first deliverable:

- Pick a published classification with small enough re-search:
  `PG(2,23)` complete arcs is the leading candidate; a minimal saturating-set classification in
  `PG(2,9)` or `PG(2,11)` is the conservative fallback.
- Emit an audit trail for every canonical rejection: selected anchor/image, group action claim,
  child-extension coverage, and final orbit representative.
- Independent checker validates the trace without trusting the search code's canonicalizer.

Kill risks:

- Re-deriving old pruning may be harder than raw hardware suggests. Do a one-day sizing run before
  choosing the target.
- Scope boundary: the checker validates the search/canon trace, not all finite-geometry background.
  State that trust boundary.

## Item 3: Segre's theorem in Lean

Prior art found:

- Muller's proof note restates the classical theorem: over a finite field of odd order, every oval
  in the projective plane is a conic, and gives a polynomial-parametrization proof.
  Source: https://arxiv.org/html/1311.3082
- Recent arcs/caps survey literature still treats Segre's theorem as a central finite-geometry
  result and records the standard conic characterization for odd `q`.
  Source: https://www.mdpi.com/2227-7390/13/9/1489
- mathlib has `Projectivization` and cardinality of projective spaces over finite fields, but the
  public docs search did not reveal finite-plane arc/conic/oval vocabulary.
  Source: https://leanprover-community.github.io/mathlib4_docs/Mathlib/LinearAlgebra/Projectivization/Cardinality.html

Concrete first deliverable:

- `segre-lean-prior-art.md`: record search terms, Lean Zulip question, mathlib modules, and chosen
  statement conventions.
- `FinitePlaneFoundations.lean` milestone: `PG(2,k)` points/lines, incidence, `Arc`, `Oval`,
  `Conic`, tangent/secant predicates, and basic cardinality statements.
- Only after that: choose between classical lemma-of-tangents route and Muller's polynomial graph
  route. Muller's proof may be more Lean-friendly because it reduces the hard middle to a function
  `F -> F` whose graph has no three collinear points.

Kill risks:

- Someone may already be working on this; search is not enough. Ask Lean Zulip before claiming
  novelty.
- Convention drift is the real proof risk. Freeze homogeneous-coordinate and quotient conventions
  before formalizing tangents.

## Item 4: maximal sum-free sets in finite abelian groups

Prior art found:

- Hassler and Treglown give sharp/asymptotic results for maximal sum-free sets in binary and
  ternary spaces and note that the finite abelian-group version is less developed than the integer
  interval case.
  Source: https://arxiv.org/abs/2108.04615
- Green-Ruzsa/Diananda-Yap-style extremal-density structure is already deep; our plausible niche is
  exact small-group orbit/certificate data, not a broad new extremal theorem.

Concrete first deliverable:

- Census maximal-by-inclusion sum-free subsets for all abelian groups up to a chosen order cap,
  quotient by automorphisms/multipliers, and emit maximality certificates.
- Compare against known maximum-density formulas separately from inclusion-maximal counts.
- OEIS candidates: number of maximal sum-free subsets up to automorphism for `Z_n`, `Z_2^d`,
  `Z_3^d`, and small mixed groups.

Kill risk:

- Definitions: "maximum size" and "maximal by inclusion" are easy to conflate. The table schema must
  name both.

## Item 7: Lean-verified Qubic

Prior art found:

- Patashnik's 1980 Mathematics Magazine paper is exactly the right historical anchor: it gives a
  computer-aided proof that the first player can always win 4x4x4 tic-tac-toe, using about 1500
  hours of computer time.
  Source: https://ranger.uta.edu/~weems/NOTES6319/PAPERSONE/patashnik.pdf

Concrete first deliverable:

- Implement/re-solve Qubic only after item 12's checker can express N-certificates.
- Emit one certificate for the standard first move or symmetry-normalized opening class.
- Paper section: compare machine certificate statistics to Patashnik's hand/strategic move book if
  the 2929-move dictionary can be recovered; otherwise compare only to the published method.

Kill risk:

- If the N-certificate shape is bolted on later, Qubic will distort the checker API. Add N-node
  support to v0 now.

## Item 16: SAT/QBF benchmarks and certified isomorph rejection

Prior art found:

- Mayer-Eichberger and Saffidine give a compact QBF encoding for positional games, explicitly
  including tic-tac-toe/generalized positional games and milestone game instances for the QBF
  community.
  Source: https://arxiv.org/abs/2005.05098
- SAT 2023 work on QBF strategy validation highlights the validation problem for QBF encodings and
  supports validation using winning strategies and interactive play.
  Source: https://doi.org/10.4230/LIPIcs.SAT.2023.24
- Certified symmetry breaking with VeriPB remains active, including a 2026 AAAI paper on faster
  certified symmetry breaking via auxiliary-variable orders.
  Source: https://ojs.aaai.org/index.php/AAAI/article/view/38426

Concrete first deliverable:

- Benchmark package first: queens Node-Kayles, cap escape, and sum-free/nofil instances with
  scaling knobs and ground-truth outcomes. Use published positional-game encodings as the baseline.
- Keep certified isomorph rejection as a position/prototype paper: define what a canonicalizer must
  log for a proof checker to validate a pruned branch, then implement it on one small census.

Kill risk:

- SAT proof formats certify propositional reasoning and now symmetry-breaking constraints; they do
  not automatically certify nauty-style search-tree pruning. That is the research gap, not solved
  infrastructure.

## Recommended next actions

1. Write `torus-no3-spec.md` first. It is the only Part III item that is both high-value and
   unblocked by C11/Lean foundations.
2. Add N-node support to the certificate datatype before any Qubic work.
3. Pick the finite-geometry classification target by a one-day sizing run: `PG(2,23)` complete arcs
   first, minimal saturating sets fallback, hyperovals stretch.
4. Create a `part-iii-sources.bib` only after the spec pass; this note intentionally keeps source
   links inline for fast triage.
