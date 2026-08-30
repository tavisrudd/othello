# C1000 — feasibility spike: equiangular lines in R^18 vs. the length-333 Legendre-pair census

**Lane:** `gem-mining`
**Date:** 2026-08-29
**Status:** COMPLETE. **Recommendation: candidate (a), the equiangular-line
maximum in `R^18`; absorb C737. Candidate (b) is closed, not deferred.**

This is a decision document, not a result. It states, for each of the two
candidate targets, the exact residual case list, the proposed method, a compute
bound with its reasoning, the certificate that would be emitted, the
pre-emption risk at the read depth actually reached, and what a negative
outcome would be worth. It closes with one recommendation and the exact compute
request that recommendation implies.

Compute discipline: no census, solver, or search run was started. One bounded
sizing pre-screen was run after the machine was reported clear (§2.4a), and
Stage 0 then promoted it to a committed evidence bundle under
`notes/2026-08-29-c1000-seidel-spectrum-sizing/` — generation 28 s, independent
replay 40 s, one core, 19 MB, exact integer arithmetic throughout (§5).
**Stage 1 is not approved and was not started.**

Late finding, recorded in §3.1a and §2.7: Greaves published *both* remaining
ingredients of the `n = 59` pipeline during 2025, including the odd-order
congruence-class theorem that case specifically needs. Assume the enumeration
is pre-empted and scope Stage 1 accordingly.

---

## 1. Candidate (b): completing the length-333 Legendre-pair multiplier census

### 1.1 Problem statement

A *Legendre pair* of odd length `L` is a pair `(a,b)` of `{-1,+1}` sequences in
`Z/LZ`, each of row sum `1`, with

```text
PAF_a(s) + PAF_b(s) = -2   for every nonzero shift s,
```

equivalently joint Hamming distance `L+1` at every nonzero shift. Such a pair
yields a Hadamard matrix of order `2L+2`. For `L = 333 = 9*37` this is order
`668`.

The in-repo program (C736, C738, C740, C741) does not attack unrestricted
`LP(333)`. It attacks the *fixed common-multiplier* restriction: pairs both of
whose sequences are invariant under a fixed subgroup `H <= (Z/333Z)^*`, using
the 30 mod-3-compatible stable subgroups enumerated as Table A1 of
Ramos--Hulak--de Queiroz, arXiv:2607.20765v1.

### 1.2 Exact residual case list (in-repo state, read at full text)

| origin | outcome |
|---|---|
| arXiv:2607.20765v1 baseline, replayed at upstream commit `43ddd910…` | 21/30 excluded |
| C736 (`notes/2026-07-31-c736-hadamard-668.md`) | IDs 9, 10 excluded by an exact mod-8 argument on the 9-compression → 23/30 |
| C738 (`notes/2026-07-31-c738-hadamard-668-id7.md`) | ID 7 `<73,112>` excluded by a shift-111 orbit lock; all order-6 subgroups closed → 24/30 |
| C740 (`notes/2026-07-31-c740-hadamard-668-residual-orbit-locks.md`) | ID 2 `<112>` excluded by the same lock, promoted to an exact threshold criterion `L_H(s) >= 167`; screen exhausted for the rest → 25/30 |
| C741 (`notes/2026-07-31-c741-hadamard-668-ids4-5.md`) | IDs 4, 5 reduced but **not** decided |

The five survivors, with their exact orbit structure on `Z/333Z`:

| ID | subgroup | order | orbit sizes | orbit variables per sequence | max one-shift lock `L_H(s)` |
|---:|---|---:|---|---:|---:|
| 0 | `{1}` | 1 | `1^333` | 333 | 0 |
| 1 | `{1,73}` | 2 | `1^9 2^162` | 171 | 9 |
| 3 | `{1,10,100}` | 3 | `1^9 3^108` | 117 | 18 |
| 4 | `{1,121,322}` | 3 | `1^3 3^110` | 113 | 6 |
| 5 | `{1,211,232}` | 3 | `1^3 3^110` | 113 | 6 |

**ID 0 is the trivial subgroup.** "Invariant under `{1}`" is no restriction at
all, so ID 0 *is* the unrestricted `LP(333)` problem, with a `2^333`-per-
sequence space. It cannot be closed by any method short of settling `LP(333)`
outright. Consequently the phrase in the C1000 queue row — "proves no
multiplier-invariant Legendre pair of length 333 exists" — is unreachable as
literally written. The most that candidate (b) can deliver is:

> no `LP(333)` is invariant under a **nontrivial** common multiplier subgroup,

i.e. deciding IDs 1, 3, 4, 5 only. Even that is a restricted nonexistence
statement, and it is a direct continuation of another group's preprint.

### 1.3 What the 108 representatives are

For IDs 4 and 5 only, C741 reduced the frontier exactly:

- The multiplier image is `{1,4,7}` mod 9 and `{1,10,26}` mod 37 for both IDs;
  their separate 9- and 37-compressions therefore coincide, and only the
  diagonal CRT coupling differs.
- The exhaustive 9-compression enumeration accepts 4,089 compressed sequences
  in 328 distinct `(norm, PAF-profile)` classes; 16 profiles participate in a
  complementary pair, giving 8 unordered profile pairs and **648 normalized
  compressed sequence pairs**.
- Quotienting by simultaneous decimation by units mod 9, translation by the
  multiplier-fixed positions `{0,111,222}`, and sequence exchange leaves
  **108 representatives**. This is an exhaustion boundary, not a sample.
- Each representative carries a forced fixed-point geometry: a row of sum `1`
  has a minus-set of size 166, and `166 = 1 (mod 3)`, so exactly one of
  `{0,111,222}` is negative; the compression recovers which one via
  `compressed_value[r] = singleton_sign[37r] (mod 6)`. This splits the 108 as
  **36 same-point** and **72 different-point** representatives, with
  fixed-pattern stabilizer quotients of size 324 and 648.
- The strongest test applied so far — an orbit-exact marginal dynamic program
  for the attainable mixed-triple counts at shift `111` — excludes **none** of
  the 108: every one admits row counts summing to the required `167`.

So a "representative" is a canonical form of a *fully specified pair of
9-compressions*: five compressed values per sequence `(c0, x, y, c3, c6)`
together with the marked singleton position. It is a constraint bundle, not a
partial solution.

### 1.4 What remains per representative

Fixing a representative fixes the compressed fibre sums but leaves, per
sequence, the 110 size-3 orbits free subject to those five linear sums. The
remaining space is therefore on the order of `2^110` per sequence and `2^220`
per pair, per representative, subject to the 332 quadratic autocorrelation
equations. The upstream orbit-level CNF for either ID has 226 primary orbit
variables, 158,107 total variables, and 1,067,981 clauses before compression
selectors. C741 records that trial SAT, CP-SAT, SCIP, and local search did not
decide the unrestricted lift, and that with a 9-compression fixed "many
branches are easy to refute, but several of the exact 108 symmetry
representatives remain solver-hard". Those solver statuses were deliberately
not recorded as evidence.

IDs 1 and 3 have had no comparable reduction at all: ID 3 has 117 orbit
variables per sequence, ID 1 has 171, and C736's quotient enumerations for IDs
0, 1, and 3 exceeded their declared 12,000,000-prefix budget without producing
even a feasibility witness.

### 1.5 Proposed method

1. Emit a committed **selector-aware exact CNF** per representative: orbit
   variables, the fixed 9-compression as unit clauses, the fixed-singleton
   lemma, the 332 joint-PAF constraints in carry-save form, and the symmetry
   breaking that the 108-representative quotient already justifies.
2. Run a proof-logging SAT solver (CaDiCaL/Kissat with DRAT, or a
   CP-SAT/PB backend with a checkable refutation) on `108 x 2` instances for
   IDs 4 and 5.
3. Repeat the whole compression-and-quotient pipeline from scratch for ID 3
   (117 orbits, mod-9 image of order 3, different CRT coupling) and ID 1
   (171 orbits, order 2), neither of which has a frontier yet.
4. Leave ID 0 explicitly open and say so in the title of any claim.

### 1.6 Compute bound

There is no defensible bound. The reasoning:

- Per-instance cost is unknown and known-bad in part: several of the 108 were
  already solver-hard in trials, and the residual per-branch space is `2^220`.
  UNSAT proof search on autocorrelation constraint systems of this width has no
  published cost model that would let a bound be stated in advance.
- The only defensible framing is a **staged budget with a stop condition**: e.g.
  108 instances x 2 IDs x 1 CPU-hour cap = 216 CPU-hours for a first pass,
  after which whatever survives is reported as an explicit uncovered residue.
  That is a partial-coverage report, not a completed census.
- IDs 1 and 3 would each need their own compression census before any solver
  budget could even be proposed; ID 1's 171-orbit model is larger than the
  226-variable model that already stalled.
- Memory is not the binding constraint (a ~1M-clause CNF is small); wall-clock
  on an unbounded UNSAT search is.

Stating a bound of the form "N CPU-hours completes the census" would be an
invention. The correct statement is: **candidate (b) cannot be given a compute
bound before the fact, which by the terms of this spike disqualifies it.**

### 1.7 Certificate it would emit

Per representative: the CNF file, its SHA-256, a DRAT/LRAT refutation, and the
checker's verdict; plus a generator/replay pair in the style already used by
C736--C741 (independent reconstruction of the subgroup, orbit partition,
compression domain, and quotient, sharing no code with the generator). An
independent replay verifies by (i) re-deriving the 108 representatives from the
subgroup alone, (ii) re-emitting each CNF and matching hashes, (iii) running
`drat-trim`/`cake_lpr` on each refutation, and (iv) checking positive controls
(the known feasible 9- and 37-compression witnesses) still pass. A single
positive lift would instead be certified as a direct `LP(333)` witness:
two length-333 sign vectors, row sums, and all 332 joint PAF values, checkable
in milliseconds by anyone.

### 1.8 Value and pre-emption risk

Value has fallen sharply. Order 668 was settled externally on 2026-08-12
(recorded in the C999 queue row), reportedly along with every admissible order
up to 2000, leaving 2004 as the smallest order with no known Hadamard matrix.
So the positive branch of (b) is no longer an existence result — at best it is a *second, structured* construction, and only
if one of IDs 1/3/4/5 actually lifts, which four independent obstructions have
so far failed to rule out but nothing suggests. The negative branch is
"no nontrivially-multiplier-invariant `LP(333)`", a footnote extending
Ramos--Hulak--de Queiroz's own program, with the trivial case ID 0 left open in
the same sentence.

Pre-emption risk is severe, from two directions at once. Ramos, Hulak, and de
Queiroz published this exact census in July 2026 and are the natural people to
finish it. Independently, `333 = 37 * 3^2` has the form `p q^2`, and Kotsireas,
Gallardo-Cava, Gomez, and Gomez-Perez published "On the search of binary
Legendre pairs of length `p q^2`" in the Journal of Symbolic Computation in
July 2026, searching multiplier-invariant sequences at exactly those lengths.
That paper's text could not be retrieved from this host (ScienceDirect returns
HTTP 403, Crossref and OpenAlex return a null abstract, Unpaywall lists no
PDF), so **the exposure is unresolved and would have to be closed before
spending anything here**. See §3.2 for the full record.

---

## 2. Candidate (a): the exact equiangular-line maximum in R^18

### 2.1 Problem statement and current status

`N(d)` is the maximum number of lines through the origin in `R^d` that are
pairwise at the same angle. `N(18)` is one of only three unknown values for
`d <= 41` (the others are `N(19)` and `N(20)`).

**Current bracket: `57 <= N(18) <= 59`, still open on 2026-08-29.**

- Lower bound `57`: Greaves, Syatriadi, Yatsyna, "Equiangular lines in
  Euclidean spaces: dimensions 17 and 18", arXiv:2104.04330v2 (31 Jan 2023),
  Theorem 1.1. Four explicit `57 x 18` integer matrices with entries in
  `{0,+-1,+-2}`, rows of squared length 10, found by a lattice search over
  `L0 = {v in Z^18 : v'v = 10}`, `|L0| = 36,808,740`. This disproved Lin--Yu's
  conjecture that `N(18) = 56`.
- Upper bound `59`: Greaves, Syatriadi, "Real equiangular lines in dimension 18
  and the Jacobi identity for complementary subgraphs", arXiv:2206.04267v2,
  J. Combin. Theory Ser. A (2024), doi:10.1016/j.jcta.2023.101769,
  Theorem 1.1. It rules out 60 lines only.

### 2.2 Exact residual case list

Two, and only two:

1. **Does a system of 58 equiangular lines exist in `R^18`?**
2. **Does a system of 59 equiangular lines exist in `R^18`?**

Both are forced to common angle `arccos(1/5)`, i.e. a Seidel matrix `S`
(symmetric, zero diagonal, `+-1` off-diagonal) of order `n in {58,59}` with
`lambda_min(S) = -5` of multiplicity at least `n - 18`:

```text
n = 59:  Char_S(x) = (x+5)^41 * phi(x),  deg phi = 18
n = 58:  Char_S(x) = (x+5)^40 * phi(x),  deg phi = 18
```

with `phi` monic in `Z[x]`, totally real, all zeros greater than `-5`.
Compare the settled case `n = 60`, where a Lemmens--Seidel refinement forces an
extra factor and leaves `Char_S(x) = (x+5)^42 (x-11)^6 phi(x)` with
**`deg phi = 12`**. The whole difficulty of the residual cases is that the free
degree rises from 12 to 18.

### 2.3 Proposed method (the published pipeline, re-implemented and extended)

The method is not speculative; it is exactly the pipeline Greaves and
co-authors used at `n = 60`, pushed to the two degrees they said were out of
reach on a personal computer.

1. **Polynomial enumeration.** Enumerate every totally real monic
   `phi in Z[x]` of degree 18 with all zeros `> -5` and eigenvalues bounded by
   `n-1`, subject to: `b1` fixed by `tr S = 0`; `b2` fixed by
   `tr S^2 = n(n-1)`; and the 2-adic *type-2* condition (`Char_S(x-1)` has
   `2^i | a_i`, weakly for odd order). This is the algorithm of
   arXiv:2002.08085 §2.3.
2. **Interlacing / Farkas certificates.** For each surviving candidate `p`,
   build `Deck(p)`, the set of admissible interlacing characteristic
   polynomials of order `n-1` (Cauchy interlacing, `b0 = 1`, `b1 = 0`,
   `b2 = -C(n-1,2)`, type-2 condition, and — for odd order — membership in a
   class of `P_{n-1,7}`, the mod-`2^7` image of order-`(n-1)` Seidel
   characteristic polynomials, which is explicitly known and of size at most
   2048). If `p = Char_S` then `sum_{f in Deck(p)} n_f f(x) = p'(x)` with
   `n_f >= 0` integers. A rational vector `c` with
   `Coeff(Deck(p)) c >= 0` and `Coeff(p') c < 0` is a **Farkas certificate of
   infeasibility**. At `n = 60` this killed 39 of 44 candidates outright and,
   with eigenspace-angle arguments, 43 of 44.
3. **Bespoke arguments for survivors.** At `n = 60` exactly one candidate
   survived, `(x+5)^42 (x-11)^15 (x-15)^3`, and needed the Jacobi identity for
   complementary subgraphs applied to a putative regular graph with spectrum
   `(x-22)(x-2)^42 (x+6)^15 (x+8)^2`. Historically such survivors have each
   cost a paper (the `N(17) <= 48` bound needed the nonexistence of a specific
   strongly regular graph of order 49).
4. **Constructive side, run first and cheaply.** Extend the norm-10 lattice
   clique search that produced the 57-line systems: the objects are vectors
   `u in Z^18` with `u.u = 10` and pairwise `|u.v| = 2`, so a line system is a
   clique in a graph on 18.4 million vertices (36,808,740 vectors modulo sign).
   The signed-permutation group of `Z^18` has only four orbits on norm-10
   vectors — represented by `(3,1,0^16)`, `(2,2,1,1,0^14)`, `(2,1^6,0^11)`,
   `(1^10,0^8)` — so the search may be seeded on four vertices and pushed with
   an exact maximum-clique solver.

### 2.4 Compute bound

Unlike candidate (b), this one has an anchor: the published `n = 60` run.

- **Anchor.** arXiv:2206.04267 reports that *all* of its computations, in Magma
  and Mathematica, took **under 40 minutes on a modern PC**, and produced the
  complete list of 44 candidate polynomials of free degree 12 plus their
  elimination certificates.
- **The authors' own statement of the barrier** (arXiv:2104.04330 §9):
  enumerating all candidate characteristic polynomials for a putative
  59-line system in `R^18` "may be possible on a super computer, but it appears
  to be out of reach of our current methods using a personal computer". That
  sentence is from 2021, about interpreted Magma on a single core.
- **Scaling.** The enumeration is a depth-first search over coefficient vectors
  with root-location pruning; free degree rises 12 -> 18, i.e. six more
  coefficient levels, and the number of admissible totally real polynomials in
  the relevant box grows roughly geometrically per level. A compiled,
  embarrassingly parallel Rust implementation buys roughly two orders of
  magnitude over single-core Magma before any algorithmic improvement, and the
  search parallelises perfectly by fixing the top coefficients.
- **The 2021 barrier has since been dismantled in print.** Greaves and
  Syatriadi, "Real-rooted integer polynomial enumeration algorithms and
  interlacing polynomials via linear programming", arXiv:2504.09241v1
  (12 Apr 2025), extend Robinson/Smyth/McKee--Smyth enumeration to reducible
  and multiple-rooted real-rooted integer polynomials with the leading
  coefficients specified, add the 2-adic filter as an explicit `ModCheck`, and
  replace the interlacing enumeration by linear programming. Their reported
  benchmark: the degree-10 computation of arXiv:2104.04330 Figure 5 fell from
  about 3 hours to under 5 minutes — an **85--90x speedup** — with a basic
  direct implementation. No new `N(d)` bound is claimed there. With those
  algorithms the enumeration step looks like a **PC-days to cluster-days** job,
  not a supercomputer job.
- **Brute force is not an option, which is why the spectral route is the whole
  method.** Szollosi and Ostergard, "Enumeration of Seidel matrices"
  (arXiv:1703.02943), classified Seidel matrices up to equivalence only for
  order `n <= 13` (12,886,193,064 inequivalent matrices at order 13, about one
  day on 16 machines x 12 logical processors, 120 GB of graph6 output), and
  state that even order 15 under eigenvalue constraints "seems currently out of
  reach". An exhaustive order-58 or order-59 census is astronomically
  infeasible. *(This source was reached through a page summary, not the PDF;
  see §3.)*
- **Measured, not assumed — see §2.4a.** The spike ran the measurement rather
  than guessing at it. The result is that the candidate space at `n = 59` and
  `n = 58` is roughly **five times** the settled `n = 60` case, not the many
  orders of magnitude the "supercomputer" phrasing suggests.
- **Stage-1 (constructive) bound.** The clique search is bounded by
  construction: 18.4M vertices, four seed orbits, and a hard wall-clock cap.
  A first pass of 200--500 CPU-hours is a defensible ask, and a negative costs
  nothing but the time because it proves nothing (see 2.6).

### 2.4a Measured pre-screen (run during this spike; 62 s, 12 MB, one core)

The spike implemented the exact necessary conditions and counted the candidate
space directly, in exact integer arithmetic. This is the single most decision-
relevant thing in this document, so the derivation is spelled out.

Removing the forced factor `(x+5)^{n-18}` leaves 18 free eigenvalues. Two trace
identities pin their first two power sums exactly:

```text
tr S   = 0            ->  sum of free eigenvalues      = 5(n-18)
tr S^2 = n(n-1)       ->  sum of their squares         = n(n-1) - 25(n-18)
```

The consequence is that the free spectrum is confined to a **sphere**: the sum
of squared deviations from its own mean is a fixed, small number.

| `n` | free deg | mean | sum of squared deviations | radius | integer window |
|---:|---:|---:|---:|---:|---|
| 60 (settled) | 18 | 11.667 | 40.00 | 6.32 | `[5,18]` |
| 59 (open) | 18 | 11.389 | 62.28 | 7.89 | `[3,20]` |
| 58 (open) | 18 | 11.111 | 83.78 | 9.15 | `[1,21]` |

Counting every **integer** spectrum in that window with the exact sum and sum
of squares, then applying the exact 2-adic *type-2* filter of
Greaves--Syatriadi--Yatsyna (`Char_S(x-1) = sum a_i x^{n-i}` must satisfy
`2^i | a_i`, weakly `2^{i-1} | a_i` for odd `n`):

| `n` | integer spectra | after the type-2 filter |
|---:|---:|---:|
| 60 | 177 | **6** |
| 59 | 722 | **28** |
| 58 | 2,066 | **28** |

**Calibration.** Re-running `n = 60` with the published Lemmens--Seidel forcing
`(x-11)^6` (free degree 12) gives 68 integer spectra and again **6** type-2
survivors. The published complete candidate list for `n = 60` — which also
admits irrational totally real factors — has **44** entries, of which the five
named explicitly in the paper are integer-rooted. So the integer proxy
reproduces the integer sub-population of the true answer to within one, and the
ratio of all candidates to integer candidates at `n = 60` is about **7**.

**What this implies.** The type-2 filter is the workhorse: it cuts 177 to 6, a
30x reduction. The growth from the settled case to each open case is only about
**4.7x** in type-2 survivors. If the all-candidates-to-integer-candidates ratio
of roughly 7 is even ten times worse at free degree 18, the complete candidate
lists for `n = 59` and `n = 58` are in the **hundreds to low thousands**, not
the millions. Each candidate then costs one `Deck(p)` enumeration plus one
linear program.

**What this does not establish.** The proxy counts *leaves*, and the cost of
the McKee--Smyth-style real-rooted enumeration is *nodes*. It also ignores
interlacing and the `P_{n-1,7}` congruence filter, and it does not cover
spectra where `-5` has multiplicity strictly greater than `n-18` (a smaller,
easier family that must be handled separately). It is a sizing measurement, not
a result. But it moves the compute estimate for the enumeration from "unknown,
possibly a supercomputer" to **single-digit CPU-days on one machine, plausibly
CPU-hours with the arXiv:2504.09241 algorithms** — and that estimate now rests
on a number this spike computed rather than on a 2021 sentence.

**These numbers are now a committed evidence bundle** —
`notes/2026-08-29-c1000-seidel-spectrum-sizing/`, with a generator, a
code-disjoint independent replay, a canonical JSON certificate, and a checksum
manifest. See §5 for the replay command, hashes, and scope limits. The original
throwaway sizing scripts and the two full delegated literature-audit reports are
kept under `/tmp/persistent/tavis/c1000-spike/` (ZFS, survives the session; the
session scratchpad does not) and are superseded by the bundle.

### 2.5 Certificate it would emit

This is the strongest argument for (a). Every stage emits something small and
independently checkable in exact arithmetic:

- **A 58-line system, if found:** a `58 x 18` integer matrix. Verification is
  one integer matrix product and a rank check — milliseconds, by anyone, in any
  language. No trust in the search is required at all.
- **The candidate-polynomial list:** the enumerator plus a separate verifier
  that (i) checks each emitted polynomial satisfies every constraint and
  (ii) re-runs the exhaustion with a different coefficient ordering and matches
  the set. Positive control: reproducing the published 44 candidates at
  `n = 60` and, separately, the published spectra of the four known 57-line
  systems.
- **Each eliminated candidate:** a rational Farkas vector `c`. Verification is
  one exact rational matrix-vector product per candidate. This is a
  *human-inspectable* certificate, orders of magnitude cheaper to check than a
  gigabyte-scale DRAT trace, and it does not require trusting a SAT solver.
- **Anything left:** reported as an explicit residual list of spectra, which is
  itself a publishable object and a well-posed successor problem.

### 2.6 Value, and what a negative is worth

- A **58-line system** would raise `N(18) >= 58` and reduce the open question
  to a single value. Small, clean, verifiable in milliseconds, and immediately
  citable.
- The **complete candidate list for `n = 59`** is publishable on its own even
  if not every candidate can be eliminated, because it converts an unbounded
  problem into a finite, named residual list — the same object that made the
  `n = 60` case tractable.
- **Settling `N(18)`** outright would close one of three remaining unknown
  values below dimension 42.
- A negative on the clique search proves nothing: the search is complete only
  within line systems whose lattice embeds in `Z^18` at norm 10. This must be
  stated in any write-up; it is a hunt, not a proof.

### 2.7 Novelty and pre-emption risk: HIGH on the census, moderate on elimination

No 2024--2026 paper narrows `57 <= N(18) <= 59`. The most recent primary source
in the line, Munemasa--Szollosi--Yoshino arXiv:2606.10421v1 (9 Jun 2026), still
prints `N(18) = 57-59`, `N(19) = 72-74`, `N(20) = 90-94` in its Table 1. No
machine-assisted or AI-assisted settlement was found. What 2025--2026 work did
instead was enrich the 57-line landscape:

- Lin, Munemasa, Taniguchi, Yoshino, arXiv:2503.06377v3 (27 Jun 2025): at least
  **246,896** inequivalent 57-line systems in `R^18`, arising as an overlattice
  of `A_9 + A_9 + A_1`, all **strongly maximal** — not extendable even in
  higher dimension.
- Munemasa, Szollosi, Yoshino, arXiv:2606.10421v1 (9 Jun 2026): further 57-line
  systems from Latin squares of order 6 and Pasch configurations, inside an
  integral overlattice of `A_5^3 + A_1^4`. These are **not strongly maximal**,
  and some have only **five** distinct Seidel eigenvalues, fewer than any
  previously known.

**Pre-emption risk on the census is very high, and the author sweep in §3.1a
raised it further.** The `n = 59` pipeline needs three ingredients beyond the
`n = 60` work: a real-rooted enumeration that scales to the larger free degree,
the `P_{n,e}` congruence table for **odd** order, and the `Deck(p)` interlacing
step. Greaves published two of those three in 2025:

- April 2025, with Syatriadi (arXiv:2504.09241): the enumeration algorithms and
  the linear-programming interlacing step, benchmarked at 85--90x faster.
- November 2025, with Phan (arXiv:2511.08333): the exact count of congruence
  classes of Seidel characteristic polynomials modulo `2^e`, **including the
  odd-order case that `n = 59` requires**, settling a conjecture he and Yatsyna
  had posed in 2019.

Greaves and Syatriadi wrote in 2021 that the `n = 59` enumeration was out of
reach on a personal computer, and then in one year published both tools that
stood in the way. That is not a coincidence; it is a group clearing its own
stated blocker. Their Magma implementations are public, so the entry cost is
low for everyone else too.

The counterweights are real but thin. Nine months have passed since
arXiv:2511.08333 with no announcement. The odd-`n` theorem is stated "for `n`
large enough", and whether `n = 59` qualifies is not established here. And the
historical pattern is that the last surviving candidate needs a bespoke
nonexistence proof — an order-49 strongly regular graph for `N(17)`, the Jacobi
identity for `N(18) <= 59`. **Plan on the enumeration being privately in hand
at NTU. The elimination side is where an independent contribution can still
land, and Stage 1 should be scoped as the entry ticket to that, not as the
prize.**

### 2.8 Probability of a clean win

Revised after the §2.4a measurement:

- Complete `n = 59` and `n = 58` candidate enumeration delivered with Farkas
  certificates: **high, 75--85%**. The gate was the growth measurement, and it
  came back at about 4.7x rather than orders of magnitude.
- 58-line construction found: low, 10--15%. The 2021 lattice search already
  looked in this space, though not exhaustively and not with a modern exact
  clique solver, and the 2026 non-strongly-maximal 57-line systems are a new
  and untried starting point.
- `N(18)` fully settled: **20--30%**. The enumeration is now the easy half. At
  least one survivor will likely need a bespoke graph-nonexistence argument,
  and history says each such survivor has cost a paper by itself.
- Pre-empted before delivery: material, because of arXiv:2504.09241 (see §2.7).

---

## 3. Literature audit

Conducted under `notes/literature-audit-conventions.md`. Two delegated audits
ran against the shared disk cache at `/tmp/persistent/tavis/lit-search` before
any fetch. **Four research sources were read at full text — all four on the
Legendre-pair side (arXiv:2607.20765, arXiv:2101.03116, arXiv:2101.10918, and
the RICAM-2022-05 preprint), plus a one-page conference abstract. Not one
equiangular-lines source was read at full text; the four primary papers there
are all `partial` at named sections, and the remaining sources are
`secondary only` or `abstract/metadata only` as marked.** This is
a spike-grade audit adequate for a go/no-go decision. It is *not* adequate for
a manuscript-bound novelty sentence, and both delegated reports record specific
coverage gaps (below) that must be closed before any priority claim.

### 3.1 Equiangular lines

| Source | Version | Access | Depth |
|---|---|---|---|
| Greaves & Syatriadi, "Real equiangular lines in dimension 18 and the Jacobi identity for complementary subgraphs" | preprint arXiv:2206.04267v2 (8 Sep 2023); published JCTA 201 (Jan 2024), doi:10.1016/j.jcta.2023.101769 | arXiv PDF fetched, sha256 prefix `52b5974b3f8eefae`, pdftotext | `partial` — abstract, §1, §2.1 candidate enumeration, §2.2 certificates of infeasibility, Table 1. §3 (Jacobi identity) and Table 2 not read line by line. **Published JCTA version not read** (ScienceDirect record seen as metadata only) |
| Greaves, Syatriadi, Yatsyna, "Equiangular lines in Euclidean spaces: dimensions 17 and 18" | preprint arXiv:2104.04330v2 (31 Jan 2023) | arXiv PDF fetched, sha256 prefix `795ed3e3176a601f` | `partial` — abstract, §1, §2 (the 57-line constructions and their spectra), §3 opening, §9 concluding remarks. §§4--8 not read |
| Greaves, Syatriadi, Yatsyna, "Equiangular lines in low dimensional Euclidean spaces" | preprint arXiv:2002.08085v1; published Combinatorica (2021), doi:10.1007/s00493-020-4523-0 | arXiv PDF fetched, sha256 prefix `450056e5b541a4c9` | `partial` — abstract, §1, §2.1 (the `-5` forcing, interlacing setup). **Published Combinatorica version not read** |
| Greaves & Syatriadi, "Real-rooted integer polynomial enumeration algorithms and interlacing polynomials via linear programming" | preprint arXiv:2504.09241v1 (12 Apr 2025) | arXiv PDF fetched | `partial` — abstract, §§1.1--1.2 including the 85--90x speedup benchmark, §2.1 opening; algorithm listings in §§3--4 not read |
| Lin, Munemasa, Taniguchi, Yoshino, "Sets of equiangular lines in dimension 18 constructed from `A_9+A_9+A_1`" | preprint arXiv:2503.06377v3 (27 Jun 2025) | arXiv PDF fetched, sha256 prefix `af1dd5498d4031e2` | `partial` — title, abstract, §1 opening including Table 1 |
| Munemasa, Szollosi, Yoshino, "Sets of equiangular lines in dimension 18 constructed from `A_5^3+A_1^4`" | preprint arXiv:2606.10421v1 (9 Jun 2026) | arXiv PDF fetched, sha256 prefix `dea43dd895b30a7a` | `partial` — title, abstract, §1 opening including Table 1 with the angle row |
| Szollosi & Ostergard, "Enumeration of Seidel matrices" | arXiv:1703.02943, ar5iv HTML rendering | model-generated answer over the ar5iv page | `secondary only` — the `n <= 13` census figures, the nauty method, and the one-day/16-machine/120 GB cost come from that summary and must be re-verified against the PDF before citing |
| Greaves & Yatsyna, "On equiangular lines in 17 dimensions and the characteristic polynomial of a Seidel matrix" (Math. Comp. 2019), arXiv:1806.08323 | — | author listing row only | `abstract/metadata only` — reaches this report only through citations in the two papers above |
| Lin & Yu (the conjecture `N(17)=48`, `N(18)=56`) | — | not fetched | `secondary only` — via citing text of arXiv:2104.04330 and arXiv:2002.08085 |
| Jiang, Tidor, Yao, Zhang, Zhao, asymptotic `N_alpha(d)` (Annals 2021) | — | not fetched | `secondary only` — context only, no bearing on `d = 18` |
| Azarija & Marc, "There is no (75,32,10,16) strongly regular graph" | — | not fetched | `secondary only` — named for methodology comparison |
| OEIS A002853 (the `N(d)` sequence) | live page | HTTP 403 to the fetcher; search-engine snippet only | `secondary only` — **its edit date was not established; do not cite it as dated provenance.** Use arXiv:2606.10421 Table 1 instead |

#### 3.1a Audit gaps closed (2026-08-29, after the delegated audit)

Both gaps flagged below were retried and closed. The first attempt at
`export.arxiv.org` had used plain HTTP, which returns an empty body from this
host; **HTTPS works**. Record this — it is a recurring trap.

- **arXiv listing sweep.** `https://export.arxiv.org/api/query` with
  `search_query=abs:"equiangular lines"`, 100 most recent by submission date.
  93 entries returned, of which **26 were submitted on or after 2024-01**.
  Screened over title plus, for three ambiguous rows, the abstract, with the
  discriminator "claims a new or narrowed value of `N(d)` for a specific small
  `d`". **Zero matched.** The only `d = 18` entries are the two 57-line
  construction papers already recorded. The three ambiguous rows were checked
  at `abstract/metadata only` and dismissed: arXiv:2606.29392 proves cases of
  Balla's conjecture, an asymptotic bound in terms of spectral radius order;
  arXiv:2603.09128 is about number-field coefficients for SIC-POVMs;
  arXiv:2410.20738 is an expository article. **The `57 <= N(18) <= 59` bracket
  stands.**
- **Author sweep for Greaves.** OpenAlex
  `filter=from_publication_date:2024-01-01,raw_author_name.search:Gary Greaves`,
  48 results, all 48 screened over title and author list, discriminator "by the
  NTU Gary R. W. Greaves AND about equiangular lines, Seidel matrices, or the
  characteristic-polynomial machinery behind `N(d)`". The set is heavily
  polluted by name collisions (a chemistry Greaves, an astronomy co-author
  list). Two rows matched, and **one of them is new and important**:

  > **Greaves & Phan, "Characteristic polynomials of `{+-1}`-matrices modulo a
  > power of 2", arXiv:2511.08333v1 (11 Nov 2025)** — `abstract/metadata only`,
  > retrieved from the arXiv API. It determines the number of congruence
  > classes modulo `2^e` of characteristic polynomials of `n x n` symmetric
  > `{+-1}`-matrices with constant diagonal — that is, of Seidel matrices —
  > as `2^{C(e-2,2)}` for even `n` and `2^{C(e-2,2)+1}` for odd `n`, for `n`
  > large enough, **resolving a 2019 conjecture of Greaves and Yatsyna**.

  That object is exactly `P_{n,e}`, the table the `Deck(p)` interlacing filter
  needs, and the odd-`n` case is exactly the `n = 59` case. See §2.7 for what
  this does to the pre-emption verdict.

Screening records for the equiangular audit: the cache manifest listing was
filtered case-insensitively on `equiangular|seidel|two-graph|lines` over key
and title fields (16 hits, none a primary low-dimension source). The
2024--2026 negative rests on four keyword search listings of about nine rows
each (~36 rows), screened over title, URL, and engine summary, with the
verbatim discriminator "names dimension 18/19/20 equiangular lines AND claims a
new value or narrowed bound"; zero rows matched. **Two coverage failures are on
record:** `export.arxiv.org/api/query` returned an empty body from this host,
so no systematic arXiv listing sweep of 2025--2026 preprints was performed; and
an arXiv author-listing screen for Greaves reported "no 2025--2026 papers on
these topics", which is false (arXiv:2504.09241 was found by another route), so
that screen is unreliable.

### 3.2 Legendre pairs

| Source | Version | Access | Depth |
|---|---|---|---|
| Ramos, Hulak, de Queiroz, "Multiplier obstructions for Legendre pairs of length 333" | preprint arXiv:2607.20765v1 (22 Jul 2026); no published version | cache key `arXiv:2607.20765`, sha256 `de396e62dc6d1cf43b9fea51d753318464bc8ed773c6b3f6cf6cb5fa681a1c70` | **`full text`** — all sections and Table A1, read during C736 and re-read here |
| Kotsireas, Gallardo-Cava, Gomez, Gomez-Perez, "On the search of binary Legendre pairs of length `pq^2`" | J. Symbolic Computation, July 2026, doi prefix S0747717126000544 | ScienceDirect landing page via search-result summary; PDF not retrieved (paywall not tested) | `abstract/metadata only` — title, venue, authors, and the presence of a "`q^2`-uncompression Legendre pairs conjecture" plus algorithmic and experimental sections |
| Kotsireas, Koutschan, Bulutoglu, Turner, "Legendre pairs of lengths `l = 0 (mod 5)` and `l = 85`, `l = 87` cases" | RICAM-Report 2022-05 (17 May 2022) preprint; published as *Special Matrices* 11 (2023) 20230105 | RICAM PDF, cached under key `10.1515/spma-2023-0105`, sha256 `767d1f023702b3222a6746c1f2cbaf50521579d5885874c6e86e33d116f02e69` | **`full text`** (the RICAM preprint; the published version was read at `abstract/metadata only` and its abstract differs) |
| Kotsireas & Koutschan, "Legendre pairs of lengths `l = 0 (mod 3)`" | arXiv:2101.03116v3 preprint; published J. Combin. Designs 29 (2021) 870--887 | cached key `arXiv:2101.03116`, sha256 `4e9cc7adcddb9f57cdf16b53a511ebafac63f780bacbe05b5ea9cf73a52648f5` | **`full text`** (preprint; published version not read) |
| Turner, Kotsireas, Bulutoglu, Geyer, "A Legendre pair of length 77 using complementary binary matrices with fixed marginals" | arXiv:2101.10918 preprint; published Des. Codes Cryptogr. 89 (2021) 1321--1333 | cached key `arXiv:2101.10918`, sha256 `5da8045a9860c52fc56679313c2eb1876297a50657eb861c2d45be37754c3ad8` | **`full text`** (preprint; published version not read) |
| Cati & Pasechnik, "A database of constructions of Hadamard matrices" | arXiv:2411.18897 preprint | cached key `arXiv:2411.18897`, sha256 `12b04b17459e088618af96b624bff0d83eb072626f7de706a94a4b10746c34d6` | `partial` — the sentence listing unknown orders 668, 716, 892, 1132 and the surrounding lines only |
| Kotsireas, Gallardo-Cava, Gomez, Gomez-Perez, "On the search of binary Legendre pairs of length `pq^2`" | J. Symbolic Computation 138 (2026) art. 102606, doi:10.1016/j.jsc.2026.102606, online 2026-07-10, CC-BY | Crossref and OpenAlex return a **null abstract**; ScienceDirect returns HTTP 403 to both the fetcher and curl; Unpaywall lists no PDF | `abstract/metadata only`, and in truth less — title, authors, venue, date, and licence only. Any description of its contents is `secondary only` from a search synthesis |
| Kotsireas, "20+ years of Legendre pairs", ICECA 2022 conference abstract | one page, the entire document | fetched and extracted locally with `pdftotext` | `full text` of the abstract — source for "a Legendre pair of every odd prime length exists via the Legendre symbol" |
| Kotsireas, Gomez, Gomez-Perez, "On properties of Legendre pairs under compression", ISSAC 2025, doi:10.1145/3747199.3747549 | — | search result and the reference list of arXiv:2607.20765 | `abstract/metadata only` |
| Kotsireas et al., "Quaternary Legendre pairs II", arXiv:2408.16318 | preprint | search-result summary | `secondary only` — the *quaternary* smallest open case moved to `l = 42`; not the binary question |
| Kotsireas, Koutschan, Bulutoglu, Arquette, Turner, Ryan, "Legendre pairs of lengths `l = 0 (mod 5)`", arXiv:2111.02105 | preprint, v1--v3 | abstract page fetched | `abstract/metadata only` |

Findings, at the depths above:

- **The smallest open binary Legendre-pair length is `L = 115` (`= 5 * 23`).**
  The authoritative statement is verbatim in RICAM-2022-05 §6, read at full
  text: the existence problem below 200 remains open exactly for the **ten**
  lengths **115, 145, 159, 161, 169, 175, 177, 185, 187, 195**. Lengths 77,
  117, 129, 133, 147 were all *decided* in 2021 and 85, 87 in the mod-5 paper,
  so most of the candidate list in the C1000 brief was already closed. Above
  200 there is no published census: the odd primes 191, 193, 227, 233, 239 are
  decided by the Legendre-symbol construction, but the composite values in the
  200s have unknown status from the sources reached, and none should be
  asserted either way.
- **`L = 333` is open** — no pair known, no nonexistence proof
  (arXiv:2607.20765 §8, full text) — but it is not the natural target. It sits
  far above 115, and it is covered by a July 2026 paper from the world experts
  on exactly its length family: `333 = 37 * 3^2` has the form `p q^2`, and the
  Kotsireas--Gallardo-Cava--Gomez--Gomez-Perez paper in the Journal of Symbolic
  Computation searches multiplier-invariant (coset-constant) sequences at those
  lengths. Its text could not be obtained from this host, so **this exposure is
  unresolved** and would have to be closed before spending anything on 333.
- **Complete enumeration is brutally expensive.** The largest *complete
  unrestricted* Legendre-pair enumeration is `L = 55`, at **101,542 CPU
  hours**; the partial search that produced the `L = 77` pair cost about
  **182,280 CPU hours**. Everything larger in the literature is exhaustive only
  within a prescribed multiplier subgroup — for instance the `L = 129` search
  inside the subgroup `{1,49,79}` at 431 CPU hours. An unrestricted attack on
  `L = 115` therefore starts from a six-figure CPU-hour baseline at a length
  more than twice `L = 55`.
- **Order 668 no longer motivates any of this.** Existence was settled
  2026-08-12 by Alpoge and colleagues with Claude, reportedly covering every
  admissible order up to 2000, leaving **2004** as the smallest order with no
  known Hadamard matrix. The method is undisclosed and there is **no evidence
  the matrix is of Legendre-pair/two-circulant shape**; Epoch AI still marks it
  provisional. C999 owns decoding and classifying it.
- **arXiv:2607.20765 covers `L = 333` only** and makes no claim at any other
  length. Its Theorem 1 is that a multiplier subgroup `H` fixing a Legendre
  pair of length 333 lies in the kernel of `(Z/333Z)^* -> (Z/3Z)^*` and has
  order at most 6; the engine of both spectral obstructions is that
  `668 = 4 * 167` with `167 = 3 (mod 4)`, so 668 is not a sum of two squares.
  It proves 21 of the 30 kernel subgroups impossible, including all 19 of order
  at least 9, and explicitly says "open" means undecided by its methods. Its
  acknowledgments state that generative AI tools assisted with code generation
  and literature discovery, and the author group has no prior publication
  record in this literature; the short analytic obstructions are checkable by
  hand from the text, but the solver-backed rows would need the Zenodo archive
  (doi:10.5281/zenodo.21498698) to be weighed independently. C736 did replay
  that archive and reproduced the 21/30 baseline.
- **Not established here:** whether a Legendre pair of length 333 is now known
  to exist; whether the externally announced order-668 Hadamard matrix
  (2026-08-12) is of two-circulant/Legendre-pair shape; and the current
  smallest open Hadamard order after 668. The delegated audit did not return
  these. C999 owns the order-668 decoding and classification and should be
  allowed to answer them rather than duplicating the work here.

---

## 4. Recommendation

### 4.1 Choose candidate (a): the equiangular-line maximum in R^18. Absorb C737.

Candidate (b) should not be started, and this is not a close call. Three
independent facts kill it. First, its own frontier cannot be completed as
stated: the trivial subgroup ID 0 is one of the five survivors, so "no
multiplier-invariant Legendre pair of length 333" would require settling the
unrestricted problem, and the best reachable statement excludes only nontrivial
multipliers. Second, its motivation is gone: Hadamard order 668 was settled
externally on 2026-08-12, reportedly along with every admissible order up to
2000, so the positive branch is at best a second construction and only if one
of four residual subgroups lifts. Third, it is squeezed between two live groups
— it is a direct continuation of Ramos--Hulak--de Queiroz's July 2026 preprint,
and `333 = 37 * 3^2` is exactly the length family of Kotsireas and coauthors'
July 2026 Journal of Symbolic Computation paper, whose text could not even be
retrieved from this host. Retargeting to the smallest genuinely open
Legendre-pair length, `L = 115`, does not rescue it either: complete
enumeration at `L = 55` cost 101,542 CPU hours and the partial search that
found the `L = 77` pair cost about 182,280, so `L = 115` starts from a
six-figure CPU-hour baseline with no bounded stop condition, against a field
that has been attacking it with purpose-built algorithms since 2025.

Candidate (a) is the opposite on every axis that matters. The problem is a
named open value that every paper in the area cites as the smallest unknown
`N(d)`. The residual case list is exactly two, both forced to one angle. The
method is published and its cost is now measured rather than assumed: the
spike's own pre-screen (§2.4a) shows the candidate space at `n = 59` and
`n = 58` is about five times the settled `n = 60` case, because the two trace
identities confine the free spectrum to a sphere of radius under ten and the
2-adic type-2 filter then removes about 97% of what remains. And the
certificates are the best of any option on the table: a construction is an
integer matrix anyone can check in milliseconds, and every eliminated candidate
is a rational Farkas vector verified by one exact matrix-vector product — no
solver trust, no gigabyte proof traces.

The real risk is pre-emption, and it is concentrated in one place. Greaves and
Syatriadi published the enumeration speed-up in April 2025 after naming
`n = 59` as their blocker in 2021, which is what a group does before attacking
its own stated barrier. The mitigation is to treat the enumeration as the entry
ticket rather than the prize, and to aim at the elimination side, where the
historical pattern is that each resilient candidate has consumed a dedicated
paper. Even a fully pre-empted enumeration leaves an independent contribution
available there — and the enumeration is cheap enough now that losing that race
costs days, not months.

### 4.2 The exact compute run to approve

Staged, with a decision gate between stages. Nothing beyond Stage 0 should
start without the gate passing.

**Stage 0 — reproduce and certify the sizing. DONE; see §5.**
Delivered as a committed generator, a code-disjoint independent replay, a
canonical JSON certificate, and a checksum manifest. Actual cost 28 s to
generate and 40 s to replay, one core, 19 MB. The positive control reproduced
exactly.

**Stage 1 — the full real-rooted enumeration (approve now; this is the ask).**
Implement the McKee--Smyth-style real-rooted integer polynomial enumeration
with the leading coefficients fixed, the type-2 `ModCheck` filter, and the
interlacing `Deck(p)` construction with linear-programming certificates,
following arXiv:2504.09241. Validate by reproducing the published 44-candidate
list for `n = 60` exactly, then run `n = 59` and `n = 58`.
*Requested budget:* **200 CPU-hours wall-capped at 24 hours on up to 16 cores,
32 GB.** *Stop condition:* if the `n = 59` enumeration has not completed within
that cap, stop and report the partial coverage with the exact frontier reached
— do not extend without a fresh decision.
*Certificate:* the candidate list, its generator and code-disjoint replay, and
one rational Farkas vector per eliminated candidate, each verifiable by an
exact rational matrix-vector product.

**Stage 2 — the constructive hunt (approve now; it is small and independent).**
Test extendability to 58 lines of the 2026 Munemasa--Szollosi--Yoshino 57-line
systems, which are explicitly **not strongly maximal**, and of the
Lin--Munemasa--Taniguchi--Yoshino families for contrast (those are strongly
maximal, so they must fail — a free correctness control). Then, if budget
remains, an exact maximum-clique pass over the norm-10 lattice graph in `Z^18`
seeded on its four signed-permutation orbits.
*Requested budget:* **50 CPU-hours, 16 cores, 32 GB.** *Certificate:* a
`58 x 18` integer matrix if one exists — otherwise nothing is claimed, because
the search is complete only within line systems whose lattice embeds in `Z^18`
at norm 10.

**Not requested, and explicitly gated behind Stage 1's outcome:** any bespoke
nonexistence argument for a resilient candidate. That is mathematics, not
compute, and it should be scoped only once the residual list exists.

**Before any novelty sentence is written**, close the two audit gaps recorded
in §3.1: the arXiv listing API returned an empty body from this host, and the
author-listing screen for Greaves was demonstrably wrong. Re-run that sweep by
another route.

### 4.2a What the §3.1a finding changes

Stage 1's *value* drops; its *cost* does not change. The enumeration is now
very likely to be pre-empted, so it should be scoped explicitly as a means of
producing the residual candidate list we need in order to work on elimination,
not as a result to be claimed. Two consequences for how Stage 1 is written up
if it is later approved: no priority claim on the candidate list, and a
literature recheck against arXiv:2504.09241 and arXiv:2511.08333 at full text
before anything is drafted. If the coordinator's appetite is for a clean
independent win rather than a contribution, this is the moment to say so —
the real picture is that the win now sits behind a bespoke nonexistence proof,
which is mathematics that cannot be budgeted in CPU-hours.

### 4.3 Mystery ledger

| mystery | status | exact evidence gap / owner |
|---|---|---|
| Why did the 2021 authors call the `n = 59` enumeration a supercomputer job? | **settled by measurement** | the two trace identities confine the free spectrum to a sphere of radius 7.89 and the type-2 filter removes ~97% of integer candidates; growth from the settled `n = 60` case is about 4.7x, not orders of magnitude. Their remark predates their own 2025 papers, which supply an 85--90x speedup and the odd-order congruence-class theorem. Certified in §5. |
| Does the leaf-count proxy predict the enumeration's node count? | **open** | §2.4a counts leaves; the search tree is what costs. Stage 1's `n = 60` reproduction settles it in the same run that validates the implementation. |
| Why does this bundle find 6 type-2 survivors at `n = 60` where the published integer-rooted count is 4? | **settled** | the two extra spectra are removed by interlacing, `Deck(p)`, or an eigenspace-angle argument — filters this bundle deliberately omits. The relation is the expected superset, and it is checked explicitly as the positive control (§5.3). |
| Has the `n = 59` pipeline already been assembled elsewhere? | **open, and the odds worsened** | Greaves published the enumeration speed-up (April 2025) and the odd-order `P_{n,e}` congruence-class theorem (November 2025, with Phan, arXiv:2511.08333), which are two of the three ingredients. No announcement in the nine months since. Read both at full text before any Stage 1 write-up. |
| What is the ratio of all candidates to integer-rooted candidates at free degree 18? | **open** | measured as about 7 at `n = 60`, free degree 12. Unmeasured at degree 18; it is the one number that could still make Stage 1 expensive. |
| Can the length-333 census ever be completed? | **settled-negative** | no: subgroup ID 0 is the trivial group, so the census contains the unrestricted `LP(333)` problem. Only the nontrivial-multiplier statement is reachable. |
| Is `L = 333` the right Legendre-pair target? | **settled-negative** | the smallest open length is 115; 333 sits inside the `p q^2` family covered by a July 2026 Journal of Symbolic Computation paper. |
| Is the externally constructed order-668 matrix a Legendre pair? | **open** | no evidence either way; the method is undisclosed. C999 owns the decoding and classification. |
| Does a 58-line system exist in `R^18`? | **open** | the actual open problem. Stage 2 hunts it; Stage 1 would rule it out only if the `n = 58` candidate list is fully eliminated. |

### 4.4 Vibe check

Good, and better than expected on the compute, worse on the race. The spike
went in assuming both candidates were unbounded-compute gambles and came out
with one of them measured, small, and gated: the equiangular-lines enumeration
that the incumbents called a supercomputer job in 2021 now looks like a CPU-day
on one machine. But the incumbents know that too — they published *both*
missing tools during 2025, including the odd-order congruence theorem that the
`n = 59` case specifically needs — so the enumeration is a race we should
assume is lost, and the durable value sits one step later, in eliminating
whatever survives. Candidate (b) is dead on three independent counts and should
go back to the queue closed, not merely deprioritised.

---

## 5. Stage 0 evidence bundle (delivered)

### 5.1 Artifacts

Directory `notes/2026-08-29-c1000-seidel-spectrum-sizing/`:

| artifact | bytes | SHA-256 |
|---|---:|---|
| `generate.py` | 13,351 | `a91f07c600ea6b77dcdbff75caf9ff124033e9f80824697f0478827087ad978f` |
| `replay.py` | 7,262 | `dcca2ece7cc83db645c8391146b84cf517ec40103888ca6f8400f7344d0e619c` |
| `certificate.json` | 22,731 | `2f234a2a456a42f7672bf39dbf8f900716627fb426f4cbf9e6ed4328bf26c9ba` |

`SHA256SUMS` in the same directory freezes these hashes.

### 5.2 Replay

From the repository root:

```bash
python3 notes/2026-08-29-c1000-seidel-spectrum-sizing/generate.py --check
python3 notes/2026-08-29-c1000-seidel-spectrum-sizing/replay.py
sha256sum -c notes/2026-08-29-c1000-seidel-spectrum-sizing/SHA256SUMS
```

`--check` regenerates the whole certificate in memory and compares it
byte-for-byte against the tracked file, leaving the worktree unchanged; it
prints `PASS` and the hash. Measured: generation 28 s, replay 40 s, one core,
19 MB peak, Python 3 standard library only, no randomness, no floating point,
no network, no host-specific paths or timestamps in the output.

### 5.3 What the certificate records

Cases, all with `-5` of multiplicity exactly `n-18` and 18 free eigenvalues
strictly greater than `-5`:

| case | free deg | window | integer spectra | after 2-adic type-2 |
|---|---:|---|---:|---:|
| `n60-free18` | 18 | `[6,17]` | 177 | 6 |
| `n59-free18` | 18 | `[4,19]` | 722 | 28 |
| `n58-free18` | 18 | `[2,20]` | 2,066 | 28 |
| `n60-forced-11pow6` | 12 | `[6,18]` | 68 | 6 |

The certificate lists all 68 surviving spectra explicitly, not just the counts.
The eigenvalue window is derived without floating point, from the exact integer
inequality `(d*x - s)^2 <= d*(d*q - s*s)` where `d`, `s`, `q` are the free
degree, the required free sum, and the required free sum of squares.

**Positive control — reproduced exactly.** The four integer-rooted members of
the published complete 44-candidate list for `n = 60` (Greaves & Syatriadi,
arXiv:2206.04267v2) are

```text
(x+5)^42 (x-9)^3  (x-11)^6  (x-13)^9
(x+5)^42 (x-11)^14 (x-13)^3 (x-17)
(x+5)^42 (x-9)^2  (x-11)^9  (x-13)^6 (x-15)
(x+5)^42 (x-11)^15 (x-15)^3
```

All four survive both `n = 60` cases of this generator, as they must: these
necessary conditions are strictly weaker than the published pipeline's. Six
integer spectra survive here against those four, and the published list's fifth
named entry, `(x+5)^42 (x-11)^10 (x-13)^6 (x^2-22x+109)`, is not integer-rooted
and is correctly absent. So the extra two are candidates that interlacing, the
`Deck(p)` construction, or an eigenspace-angle argument removes — exactly the
filters this bundle deliberately omits.

### 5.4 Independence of the replay

`replay.py` shares no code with `generate.py`, and the differences are
structural rather than cosmetic:

1. It **ignores the derived window entirely**, sweeping the fixed range
   `[-4, 40]`, and then checks that no solution lies outside the window the
   certificate claims. A window that had lost a candidate would appear here as
   an extra solution. All four windows came back confirmed.
2. It **never performs a polynomial shift**. Where the generator builds
   `Char_S(x)` and shifts it, the replay uses
   `prod_i (x - r_i)` at `x-1` equals `prod_i (x - (r_i+1))` and builds
   `Char_S(x-1)` directly from the shifted roots.
3. It tests the 2-adic condition by **comparing valuations** computed from the
   integer bit pattern, not by the modulus operator.
4. It enumerates multisets **from the largest value downwards**, the opposite
   order.

It re-derives the trace targets independently and fails loudly on any
disagreement. It reproduced every count, every survivor list, every window, and
the positive control.

### 5.5 Scope limits, restated

The certificate proves a bounded, finite statement and nothing more. It does
not enumerate candidates carrying irreducible totally real factors of degree
greater than one; it applies no interlacing, no `Deck(p)`, no `P_{n,e}` filter,
and no eigenspace-angle argument; it does not cover spectra where `-5` has
multiplicity strictly greater than `n-18`; and surviving the filter is not
existence. **Nothing here bears on whether `N(18)` is 57, 58, or 59.** The
counts are an upper bound on the integral sub-population of the true candidate
lists, produced to size the Stage 1 search.
