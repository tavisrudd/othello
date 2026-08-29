# ergodis → qLDPC / LDPC tooling angle (2026-08-28)

**Status**: complete. Section 2 is grounded in code I read directly; section 3 in a delegated
read of the four paper directories, spot-checked by me; section 4 in a delegated web survey of
2024–2026 literature and tooling.

Read-only investigation. Nothing was built or run. Every code claim below carries a
`file:line` pointer into `papers/complete-repair-ports/ergodis`.

**Epistemic key.** Claims with a `file:line` pointer were read directly in this session unless
marked otherwise. Claims about the four papers came from a delegated read and are marked where
I re-verified them myself. Claims about how a computation *would* map onto a coding problem —
principally section 2.0 — are my inference and are labelled as such; no quantum or CSS
vocabulary appears anywhere in the ergodis sources. External-literature claims live only in
sections 4 and 7.2, came from a delegated web survey rather than my own reading, and carry
URLs; the survey's own list of what it could not verify is reproduced at the end of 7.2.

## 1. Verdict

ergodis as it stands is not a quantum LDPC tool and is not close to one: its quasi-cyclic LDPC
front end is a single struct with an unpruned fixed-size depth-first search over a four-node
example (`applications.rs:1123`), its best-engineered search kernel is specialized to
arithmetic mod 3 rather than GF(2) (`orbit.rs`, `packed_ternary.rs`), its matrix type stores one
byte per bit (`matrix.rs:20`), and the manuscript behind the crate never mentions LDPC. But
there is a real and non-forced connection underneath: the X-distance of a CSS code is
`min wt(C_X \ C_Z^perp)`, a minimum weight over a difference of nested linear codes, and that
coset/relative-weight object is exactly what the compositional-recovery paper proves theorems
about and what `confinement.rs` computes. The genuinely valuable and unadvertised asset is
`group_action.rs` — a verified orbit compiler over an abstract finite permutation action with a
GF(2) general-linear canonical-form fast path — which is the symmetry-reduction machinery the
LDPC front end conspicuously lacks. Of this repository's papers, three of the four are dense
algebraic codes with nothing LDPC about them; the exception is the `[78,36,12]_2` passant code,
a (7,7)-regular binary code in a published classical LDPC family with a `PGL(2,13)` automorphism
group of order 2184 and committed certificates in both exhaustive-search and structural styles,
which makes it the only credible launch demonstration in the building. The literature survey then found the one thing that makes this worth pursuing: **every exact
qLDPC distance tool in 2026 — IBM's own integer program for the gross code, the Gurobi and
MaxSAT benchmarks, QDistRnd, Magma — throws away the code's automorphism group entirely**,
and the MIT group closest to the idea states in print that the automorphism-to-distance bridge
has not been built (arXiv:2606.05044, quoted in section 4.1). So the right product is not a new
search engine and not "faster search" — our existing speed claims rest on an asymmetric
benchmark protocol that would not survive scrutiny — but a **symmetry-reduction compiler that
sits in front of the mixed-integer and maximum-satisfiability solvers this field already uses**,
emitting orbit-quotiented models plus a certificate of why the reduction is sound. That is
precisely the architecture ergodis's own documentation argues for, it is 2–3 months rather than
5, there is a published 27-instance benchmark to score against with one instance nobody has
solved, and the whole thesis can be tested in one to two weeks by adding symmetry-breaking
constraints to Bravyi et al.'s own public `distance_test.py` and counting branch-and-bound nodes.
If that experiment buys less than roughly 5x, drop the idea.

## 2. Kernel map: ergodis → qLDPC/LDPC problems

### 2.0 The one structural fact that makes the angle real

For a CSS code built from a pair of classical codes `C_Z^perp ⊆ C_X`, the X-distance is

```
d_X = min { wt(v) : v ∈ C_X \ C_Z^perp }
```

which is not a minimum-distance problem — it is a **minimum weight over a difference of two
nested linear codes**, i.e. a coset-leader / *relative* weight problem. That is precisely the
object ergodis's companion paper is about: `OPTIMIZATION.md:98-101` states that the canonical
puncture/shorten pair has "relative generalized Hamming weights equal to the minimum numbers of
helpers required to recover target subspaces of dimensions 1, 2, ...", and `OPTIMIZATION.md:60`
names "prescribed-coset support cost" as the crate's central conditional value function. The
locally-repairable-code framing and the CSS-distance framing are the same computation with
different words on it. This is an inference (mine), not a claim made anywhere in the repo: I
found no occurrence of CSS, stabilizer, or quantum vocabulary anywhere in the ergodis sources.

The rank-one reduction (`OPTIMIZATION.md:196-202`, implemented as
`confinement.rs:295 certify_rank_one_transfer_by_generators`) says every recoverable target
dimension is confined through a cost limit iff every rank-one target is. In CSS language that
is the statement that the full logical-operator weight spectrum is controlled by single logical
qubits' minimum weights — useful, and already implemented, but it certifies a *bound*, not the
exact minimum, unless the full `confinement_by_generators` path is used.

### 2.1 QC-LDPC trapping/stopping-set kernel — real, but currently a toy

`applications.rs:1061 QcLdpcCode` holds exactly the standard protograph description: a
`check_groups × variable_groups` matrix of circulant shifts over a lift `L`
(`applications.rs:1062-1065`). That is the same object as a 5G NR base graph with its lifting
set, and the same object as a bivariate bicycle code's two circulant blocks.

Three code paths:

- `applications.rs:1184 degree_two_codeword_search` — when every check has at most two
  incident variable nodes, low-weight codewords are exactly unions of connected components;
  the kernel does union-find (`applications.rs:1205`) plus a subset-sum over component
  weights (`applications.rs:1224-1243`). This is the path behind the `lift 50,000, weight 4`
  benchmark row (`BENCHMARKS.md:82`, 1,517 us vs 509,306 us for CryptoMiniSat native XOR,
  336x). Verified in code; genuinely fast, but the reduction is textbook and the control is a
  general SAT solver, not a coding tool.
- `applications.rs:1123 search_trapping_set` — plain depth-first enumeration of variable
  subsets of a **fixed** size (`applications.rs:1313 search_trapping_sets`). The only symmetry
  exploited is that the anchor ranges over one representative per variable group
  (`applications.rs:1143-1145`), i.e. an `L`-fold reduction from the cyclic group. Check
  degrees are maintained incrementally (`applications.rs:1358/1372`) but the odd-check test
  fires **only at a full-size leaf** (`applications.rs:1330-1343`). There is no partial-degree
  pruning, no lexicographic isomorph rejection beyond the anchor, no branch-and-bound.
- `applications.rs:1267 find_stopping_set` — the same DFS with the degree-one test, wrapped in
  a size-increasing loop.

`QcTrappingSetAnswer.cyclic_normalization_factor` (`applications.rs:1073`) is just `L`
copied out (`applications.rs:1172`); it is a bookkeeping field, not a computed orbit count.

**A representational limit that matters specifically for qLDPC.** `shifts` is
`Box<[Option<u16>]>` with one entry per `(check_group, variable_group)` cell
(`applications.rs:1065`, validated at `:1092-1096`), so each block is a *single* circulant
permutation matrix or zero. A 5G New Radio base graph has exactly that form and is
representable. A bivariate bicycle code is not: its blocks are `A = A1 + A2 + A3` and
`B = B1 + B2 + B3`, sums of three circulants over `Z_l x Z_m`, so each block has row weight
three. `QcLdpcCode` cannot express the IBM gross code or any of its family without a data-model
change. It is also unsigned/binary only, so no CSS pair is representable at all — there is no
way to say "these are the X checks and those are the Z checks."

**Gap to close.** This is 10–15% of a competitive trapping-set enumerator. The literature-grade
version needs: prefix pruning on partial odd-check counts, minimum-size search rather than
fixed-size, the full circulant automorphism group (not just the `L` translations of one
coordinate) for isomorph rejection, and multiplicity/orbit counting so the answer is "there are
`m` distinct (a,b) trapping sets, here is one representative per orbit" rather than "here is
one set". Also, the shipped example is `check_groups=2, variable_groups=2, lift=2`
(`examples/data/qc-ldpc-search.json`) — four variable nodes. Nothing at production scale has
been demonstrated for the DFS path; only the union-find special case has.

### 2.2 Orbit / packed-ternary syndrome search — the best-engineered kernel, wrong field

`orbit.rs:1005 ternary_orbit_syndrome_search` and `orbit.rs:1175
ternary_orbit_syndrome_meet_in_middle` solve: choose one option per orbit family so the sum of
residues hits a target syndrome and the sum of integer totals hits a target. It has bound
prunes, residue prunes, a dead-state memo, an iterative and a recursive driver, a
correlated-suffix bound, and a cost-model-chosen meet-in-the-middle split
(`orbit.rs:18-25` result counters; `orbit.rs:1160-1173` split selection). The pruning is real,
not decorative: both the iterative driver (`orbit.rs:612, 626, 636, 643`) and the recursive one
(`orbit.rs:716, 730, 740, 747`) prune on partial-cost bounds, residue infeasibility, and a
dead-state memo — the three things the trapping-set DFS in 2.1 has none of.

The arithmetic is `packed_ternary.rs` — 21 mod-3 lanes per `u64` with branchless carry
correction (`packed_ternary.rs:40-45`). Correct and fast; **and mod 3, not mod 2**.

**Gap to close.** Every LDPC and every CSS-code syndrome is over GF(2) (or, for the symplectic
form, a pair of GF(2) vectors). A `TritBlock` analogue for GF(2) is a plain `u64` XOR — much
faster, and it makes the whole orbit search directly reusable as "find a minimum-weight vector
in a given coset of a GF(2) code, searching over orbit representatives of the automorphism
group." That is a syndrome-decoding/coset-leader kernel, i.e. exactly the CSS-distance
problem in 2.0. The porting work is the *smallest* high-value change in this whole analysis:
the search skeleton, memo, bound pruning, and meet-in-the-middle are field-agnostic; only
`packed_ternary` is not. (Meet-in-the-middle over a GF(2) syndrome is also the standard
Stern/Dumer information-set-decoding structure, so the prior art here is deep — see risks.)

### 2.3 Generated-span closure — minimal-support recovery over prime fields

`span.rs:60 GeneratedSpanTable::build` enumerates every distinct subspace generated by
subsets of the projectively-distinct generator columns (`span.rs:198 projective_columns`
dedupes proportional columns), storing each as a canonical row basis in a flat arena with a
16-byte state record (`span.rs:20-29`). `span.rs:162 query_canonical_target_image` then walks
states in increasing rank and returns the first that contains the target, with a coordinate
support reconstructed from the witness arena (`span.rs:190`).

This is a minimum-number-of-columns-spanning-a-target computation, i.e. a minimum-support
recovery. For codes it gives *generalized* Hamming-weight-type data. It is **exponential in
the number of distinct projective columns** by construction (`span.rs:88-119` doubles the
state set per column), so it is a small-`n` tool. The perf review flags that
`span.rs:182` runs a full RREF where a rank test suffices, and `span.rs:75` allocates per
state (`notes/2026-08-28-ergodis-perf-expert-review.md:32-33,42-44`).

**Gap to close.** For LDPC-scale `n` (hundreds to thousands) this kernel does not apply at all.
It is useful for small algebraic codes — which is where our own papers live (section 3) — not
for qLDPC.

### 2.4 Signed incidence profile — the shape of a trapping-set test, and dead code

`incidence.rs:17 signed_profile` computes, for a set of rows and a signed (positive/negative)
column set, each row's degree and signed sum, flagging degree-1 rows as `tangent_rows` and
degree-2 same-sign rows as `same_sign_secants` (`incidence.rs:36-39`). Structurally this is
one step from the trapping-set predicate: degree-1 checks are exactly the stopping-set
obstruction (`applications.rs:1340`) and odd-degree checks are the trapping-set count
(`applications.rs:1335-1338`). The signed version is the natural GF(3) / arc-geometry variant.

Critically, the perf review establishes by grep that `bitset::BitSet` and
`incidence::signed_profile` **have no callers anywhere in `src/` outside their own test
modules** (`notes/2026-08-28-ergodis-perf-expert-review.md:72-75`). So this kernel is exported
but unwired. It is a starting point, not an asset in use.

### 2.5 Structured-SAT certificates — the right idea, the wrong problem class

`sat.rs:58 certify_multipartite_coloring_unsat` and `sat.rs:120
certify_coloring_clique_unsat` recognize direct graph-coloring CNF encodings and emit a
replayable pigeonhole/clique UNSAT certificate without any CDCL search. The recognizer is
narrow: it hard-fails on any clause that is not all-positive or a binary all-negative
(`sat.rs:174-177`), and caps at 64 vertices for the multipartite path (`sat.rs:70-72`).

The *pattern* is exactly what a distance-certification product needs: "prove UNSAT of
`exists a codeword of weight < d` without producing a DRAT proof the size of the search."
The *instance class* is graph coloring, which has nothing to do with codes.

**Gap to close.** A "no codeword of weight < w" certificate for a QC code would have to come
from a different structure — e.g. a circulant/orbit argument, a lifted-product bound, or a
linear-programming/Delsarte dual witness. Recognizing coloring CNFs contributes none of that
machinery. Treat `sat.rs` as evidence of taste for certificates, not as reusable code.

### 2.6 Orbit compilation for permutation actions — the strongest unadvertised asset

Not on the reading list I was given, and the most valuable thing I found.
`group_action.rs:1` is headed "Exact orbit compilation for finite permutation actions" and
provides:

- a `FinitePermutationAction` trait (`group_action.rs:7-13`) — a finite point set plus
  explicitly supplied permutation generators, with `apply(generator, point)`;
- `compile_permutation_orbits` (`group_action.rs:757`), a deferred-verification variant
  (`:767`), and an independent `verify_permutation_orbits` replay (`:841`), returning an
  `OrbitPartition` / `OrbitStorage` (`:529`, `:538`);
- `quotient_presentation_by_orbits` (`:620`), which reduces a finite presentation modulo the
  orbit partition;
- a theorem-specialized fast path for the left action of `GL_r(F_2)` on packed binary probes:
  `BinaryGlProbeAction` (`:95`), `compile_binary_gl_rref` (`:350`), `verify_binary_gl_rref`
  (`:419`). Because a row space has a unique RREF basis, the canonical representative is
  recomputed arithmetically instead of stored, so the certificate is one bit per point
  (`group_action.rs:108-118` doc comment).

This is already binary, already about canonical forms under a linear group, and already
carries verification. The automorphism group of a quasi-cyclic LDPC code contains the circulant
shift group (for a bivariate bicycle code, `Z_l × Z_m` acting on the `2lm` coordinates); for
our own algebraic codes it is a monomial or projective-semilinear group. Feeding that group in
as a `FinitePermutationAction` and compiling coordinate-subset orbits is the standard
symmetry-reduction step that the trapping-set DFS in 2.1 conspicuously lacks — and the code to
do it is already in the crate, just never wired to `QcLdpcCode`.

**Gap to close.** `BinaryGlProbeAction` is capped at fewer than 32 bits
(`group_action.rs:60-64` shape check: `columns >= 32` rejected) and the generic orbit compiler
enumerates points explicitly, so it computes orbits of *points*, not orbits of *subsets*. For
distance search you need orbits of low-weight supports, which is a different (and much larger)
point set — handled in practice by canonical-augmentation / orderly generation rather than by
explicit orbit enumeration. So this is the right abstraction with the wrong scaling regime;
the reusable parts are the trait, the verification discipline, and the RREF-canonical-form
idea.

### 2.7 A crate-wide representation gap that gates everything above

`Matrix` stores one **byte per field element** (`matrix.rs:20-26`, `data: Box<[u8]>`) with
dimensions capped at `u16` (`matrix.rs:9-10`). For GF(2) that is 8x the memory and roughly
64x the elimination throughput of a bitsliced representation (M4RI-style, the standard for
binary linear algebra). Every distance/coset computation for a real qLDPC code bottoms out in
GF(2) Gaussian elimination on matrices of size a few hundred to a few thousand. The perf
review already identifies `matrix.rs:180-204` as "the hot loop of this crate" and notes
bounds checks plus an aliasing barrier blocking vectorization
(`notes/2026-08-28-ergodis-perf-expert-review.md:30-31, 67-69, 84`) — but the deeper problem
is representational, not codegen. A GF(2)-specialized bit-packed matrix type is a prerequisite
for any credible LDPC-scale claim, and it does not exist.

### 2.8 Two false friends

`balanced.rs` is **not** about balanced product codes (the Breuckmann–Eberhardt qLDPC family).
Its header reads "Normalized exact front end for the Gf27 balanced `q=27` branch"
(`balanced.rs:1-6`) — projective shear/homothety normalization of cubic ratio fibers for the
complete-arc search. Likewise `defect.rs:1-6` is "Exact arithmetic pruning for the open q=27,
|D|=54 defect-19 branch", a projective-plane point-set search. Both belong to the
cap/arc research lane, not to coding.

The accurate description of the crate is: a linear-recovery and composition engine plus a
finite-projective-geometry search engine, with thin application front ends bolted on. The
LDPC surface is one struct and three functions.

### 2.9 Summary table

| ergodis kernel | file:line | qLDPC/LDPC problem it maps to | fit | gap |
| :--- | :--- | :--- | :--- | :--- |
| QC trapping/stopping DFS | `applications.rs:1123`, `:1267` | classical QC-LDPC error-floor certification; qLDPC harmful-set search | data model fits 5G NR base graphs, not bivariate bicycle | no prefix pruning, no full automorphism group, no orbit counting, fixed-size only, one circulant per cell, no CSS pair |
| degree-2 codeword union-find | `applications.rs:1184` | low-weight codewords of variable-degree-2 protographs | direct, correct, fast at lift 50,000 | textbook reduction; narrow applicability |
| orbit syndrome + meet-in-middle | `orbit.rs:1005`, `:1175` | coset-leader / CSS logical-operator minimum weight | strong skeleton | mod 3 only; needs a GF(2) block type |
| packed ternary SWAR | `packed_ternary.rs:40` | — | none | GF(2) analogue is `u64` XOR |
| generated-span closure | `span.rs:60` | generalized Hamming weights of small algebraic codes | good at small `n` | exponential in distinct columns; not LDPC-scale |
| relative/coset confinement | `confinement.rs:54`, `:295` | `d_X = min wt(C_X \ C_Z^perp)` | conceptually exact match | never framed or tested as a quantum-code computation |
| permutation-orbit compiler | `group_action.rs:757`, `:841` | symmetry reduction by the code's automorphism group | right abstraction, verified | orbits of points, not of subsets; GL path capped under 32 bits |
| binary GL RREF quotient | `group_action.rs:350` | canonical form of a binary subspace under a linear group | already GF(2), 1 bit/point certificate | small-dimension only |
| signed incidence profile | `incidence.rs:17` | trapping/stopping predicate over signed supports | shape matches | dead code, no callers |
| structured SAT certificates | `sat.rs:58`, `:120` | "no codeword below weight w" certificates | idea only | recognizes graph coloring, not code CNFs |
| dense `Matrix` type | `matrix.rs:20` | GF(2) elimination underlying every distance computation | works | byte-per-element, u16 dims, not bitsliced |

## 3. What this repository's papers contribute

Summarized from a dedicated read of each paper directory. The headline is uncomfortable and
worth stating first: **three of the four quantum/coding papers are about dense algebraic codes
and contribute no LDPC content at all.** Exactly one object in the repository is sparse, and it
is classical, not quantum.

### 3.1 The one LDPC-adjacent object: the q=13 passant code

`papers/q13-passant-code` studies `K = ker_{F_2} M` where `M` is the 78x78 binary incidence
matrix between the internal points and the passant lines of a nonsingular conic in `PG(2,13)`,
identified by the polarity (`passant_code_q13.tex:88-94`). The theorem
(`passant_code_q13.tex:106`) is that `K` is `[78,36,12]_2` with exactly 364 minimum-weight
words falling into four `PGL(2,13)`-orbits of size 91.

Why this is the launch demonstration and nothing else in the set is:

- **It is genuinely sparse and genuinely LDPC.** Each passant carries 7 internal points, so `M`
  is (7,7)-regular — density about 9%. The paper itself places the code in "the fixed-conic
  LDPC family introduced by Droms–Mellinger–Meyer" (`passant_code_q13.tex:197-201`, DCC 40
  (2006) 343–356).
- **There is a published bound interval, but the distance value itself is not new.** I checked
  the manuscript directly: Droms–Mellinger–Meyer's *general* bounds specialize to `8 <= d <= 12`
  (their Theorem 4.9), "and they report the `q=13` parameter `[78,36,12]_2` in their Table 8"
  (`passant_code_q13.tex:197-201`). So `d = 12` is already in the 2006 literature. Our paper's
  contribution is the *classification* of the 364 minimum words into four `PGL(2,13)` orbits and
  the reconstruction theorem, not the distance number. A demo that merely recomputes `d = 12`
  reproduces a twenty-year-old table entry; a demo that enumerates and classifies the minimum-weight
  orbits does something the literature does not. Pitch it that way or not at all.
- **It has a large, explicit automorphism group.** `PGL(2,13)`, order 2184, acting on the 78
  coordinates. That is precisely the input a symmetry-reduced distance search needs, and it is
  the same shape as a quasi-cyclic code's circulant group, only richer.
- **Both certificate styles are already committed.** `verification/verify_weight_eight_theta.py`
  with `weight_eight_theta.json` (a rank-28 positive-semidefinite clique obstruction) and
  `verification/verify_weight_ten_moment.py` with `weight_ten_moment.json` (line-moment
  profiles plus bounded stabilizer exhaustion) *replaced* an earlier weight-eight subset search
  and weight-ten syndrome search, which are retained as regression replays. So a new tool can
  be validated against a brute-force answer and against a structural certificate for the same
  instance.
- **Some finite leaves are kernel-checked in Lean** (`lean-certificates/PassantCodeQ13`),
  including the four disjoint 91-element orbits each of span rank 36, and an exhaustion over
  every four-subset of a pool of 4,186 admissible three-point seeds. Nobody else's LDPC tool
  emits machine-checked leaves.

Limits to be clear about: `n = 78` is small by LDPC standards (5G NR lifts reach `Z = 384` on a
46x68 base graph, so thousands of coordinates), and the code is classical. It proves the
method, not the scale.

### 3.2 The product shape already exists — in the wrong paper

`papers/high_weight_grs_cosets/software/projective-reed-solomon/` is an MIT-licensed
self-contained Rust CLI of roughly 4,200 lines with commands `canonicalize`, **`distance`**
(exact distance from the code within a candidate budget), **`decode`** (nearest error pattern
plus locator witness), `simultaneous-locator`, `classify` (a fail-closed, theorem-registry-gated
verdict), and **`verify`** (replay any emitted certificate), with a versioned JSON certificate
schema `projective-reed-solomon-deep-certificate-v1`, a frozen theorem-domain file, property
tests, and complexity/benchmark docs.

This matters more than any individual kernel in ergodis. The hard, unglamorous part of a
certification product — versioned certificates, a replay contract, a registry that refuses to
answer outside the proved domain, a corrupted-certificate rejection path — has already been
built once in this repository, in Rust, for a coding problem. The template is proven; only the
mathematics underneath it would change. Note also that its subject, coset weights of
generalized Reed–Solomon codes, *is* a relative-distance problem, same as section 2.0.

### 3.3 The AME papers: a certified-transversal-group capability, not a distance capability

`papers/mds_css_transversal_groups` (AME paper II) proves that for a classical `[2m,m,m+1]_q`
MDS code the conductor `Cond(C,C^perp) = (C^{*2})^perp` has dimension 0 or 1, and the
projective fixed-coordinate transversal logical group is `F_q^2 ⋊ T` (split torus) or
`F_q^2 ⋊ SL_2(q)` accordingly — equivalently, the coordinatewise CSS endomorphism algebra is
`F_q x F_q` or `M_2(F_q)`. `papers/ame_lu` (AME paper I) proves that every product unitary
between stabilizer `AME(2m,q)` states is factorwise Clifford, with a quantitative `8ε`
stability radius.

These are CSS codes, and they carry a precisely named group. But the concrete instances are
`[[2m-1,1,m]]_q` — **one logical qubit, dense, MDS**. There is no distance search anywhere:
distances are structural consequences of the MDS property. The exhaustive computations that do
exist are equivalence and orbit enumerations (all 924 GRS evaluation sets, a 950,400-candidate
anchored local-Clifford test, all 720 party permutations), replayed by
`papers/mds_css_transversal_groups/supplement/verify.py --replay` over eight
generator-plus-certificate bundles with byte-for-byte canonical JSON.

The repository has already assessed this adjacency and reached the same conclusion.
`notes/open-problems/plausible-bridges/transversal-codes.md:32-34` records the verdict: the AME
rigidity theorem "acts as a no-go boundary, not a construction toward the live famous target,"
because the family encodes one logical qudit and is not asymptotically good qLDPC. What that
note says *does* transfer (`:36-42`) is the useful part for a tool:

> holonomy-centralizer calculations can certify the exact transversal group of a proposed
> finite code

and its attack route 3 (`:57-60`): "Finite-size exact search. Use symplectic normal forms,
logical-action constraints, holonomy centralizers and SAT to find short qLDPC codes with a
precisely certified transversal group and decoder. This is tractable and useful."

That is a differentiated capability — *certify the exact transversal logical gate group of a
given finite code* — and it is a different product from distance computation. Section 5
treats it as its own product.

### 3.4 C967: the lane already wants this tool, for a dense family

The quantum-codes lane's only queued task, C967
(`notes/quantum-codes-tasks/c967-jet-quotient-quantum-code-compiler.md`), specifies an exact
compiler for the asymmetric CSS family `[[q+1, 2, (q-5, 4)]]_q`, `q >= 7`, with a frozen `q=11`
packet giving `[[12,2,(6,4)]]_11` and **relative generalized weight hierarchies `(6,7)` and
`(4,5)`**. Its deliverables are, almost verbatim, the specification of a distance/weight
certification tool: exact X/Z check matrices with verified CSS commutation, logical quotient
bases with full Pauli pairing, independently replayable certificates for asymmetric distances
and relative generalized weights, and **a checker that rejects deliberately corrupted
certificates**. The acceptance gate demands two independent computations agreeing plus exact
replay, and forbids finite sampling as a general proof. The implementation language is
explicitly still open.

Two consequences. First, the relative-generalized-weight vocabulary of C967 is the same
vocabulary as ergodis's `confinement.rs` — the crate already computes the object C967 needs
certificates for, over prime fields. Second, the quantum-codes handoff
(`notes/handoffs/2026-08-25-quantum-codes.md`) treats `complete-ports` — and therefore ergodis
— as a **read-only foreign lane**, while sanctioning "a new repository-local
compiler/certificate directory chosen by C967." So reusing ergodis code inside the quantum
lane needs explicit authorization; it is not a free move.

The family is still dense (Reed–Solomon-type check spaces `R_d` with a jet condition, MDS
parent). C967 is not an LDPC task.

### 3.5 What the papers do not contribute

Searched across all four paper directories and the quantum-codes lane notes: no occurrence of
quantum LDPC, bivariate bicycle, lifted product, balanced product, BP-OSD, or belief
propagation. Every decoder in the repository is exact and algebraic. There is no iterative
decoding, no error-floor work, no threshold simulation, and no syndrome-decoding benchmark.
Any qLDPC product would be entering a field where this repository currently has published
nothing.

## 4. Competitor / tool landscape

From a delegated web survey (67 tool calls, sources listed in 7.2). Where the survey read a
source directly and quoted it, I mark it *quoted*; where it relied on a search summary, I mark
it *unverified*. The survey caught and corrected one summarizer hallucination itself, which is
a good sign about the rest.

### 4.1 The finding that decides everything: nobody uses symmetry inside the distance search

This was the key question and it came back clean. Four independent pieces of evidence:

1. The two 2026 benchmark papers that enumerate the entire method landscape —
   Webster, Jacob (University College London) and Higgott (Google Quantum AI),
   *Distance-Finding Algorithms for Quantum Codes and Circuits*, arXiv:2603.22532; and
   *SAT, MaxSAT, and SMT for QLDPC Distance Computation: A Large-Scale Empirical Study*,
   arXiv:2606.12445 — **contain no symmetry-reduced method at all**.
2. IBM's own 2026 code-discovery pipeline (Cruz-Benito, Cross, Kremer, Faro,
   *Evolutionary Discovery of Bivariate Bicycle Codes with LLM-Guided Search*, arXiv:2606.02418)
   uses graph-automorphism canonical labeling (the BLISS tool) **only to deduplicate candidate
   codes** — it reduced 225 CSS representations to 97 — and never inside a mixed-integer program.
3. Bravyi et al.'s own published script, `distance_test.py` in
   `github.com/sbravyi/BivariateBicycleCodes`, solves `k` unreduced integer linear programs with
   **no symmetry breaking**, even though a bivariate bicycle code is manifestly `Z_l x Z_m`
   symmetric. *Quoted from the source file.*
4. Most decisively, the group closest to the idea says so in print. Davenport, Blue and Chuang
   (MIT), *Generalized Bicycle Codes as Cyclic Submodules and their Automorphism Structure*,
   arXiv:2606.05044, write in their outlook, *quoted from the PDF*:

   > The analysis of this work strictly pertains to how to assess and design the automorphism
   > structure of GB codes, and pays no attention to the resulting distance or stabilizer weight
   > of a given code. It would be fascinating to see if viewing the structure of GB codes as
   > cyclic submodules yields any insight into the distance or stabilizer weight of a given code.

   Their own Table 4 distances were computed with Gurobi plus the Wang–Pryadko reduction
   (arXiv:2203.17216), not with their automorphism machinery.

So the automorphism-to-distance bridge is an explicitly stated open problem, named by the people
best placed to close it. Note the contrast with the **classical** side, where symmetry *is*
already used: Usatyuk, Kuznetsov and Egorov, *Cyclic Group Projection for Enumerating
Quasi-Cyclic Codes Trapping Sets*, arXiv:2401.14810, does projection and lifting on
pseudo-codewords for quasi-cyclic codes with non-prime circulant sizes (abstract only, so
speedups unverified).

### 4.2 How the gross code's distance was actually certified

Answered, and it is more mundane than I expected. Bravyi, Cross, Gambetta, Maslov, Rall and
Yoder, *High-threshold and low-overhead fault-tolerant quantum memory*, Nature 627, 778–782
(2024), state in their Table 3 caption that "Code distance was computed by the mixed integer
programming approach of Ref. [55]." The screening was two-stage: belief-propagation with
ordered-statistics decoding (BP-OSD) gives a stochastic upper bound that narrows the candidate
field, then integer linear programming settles the survivors exactly. The published script uses
the Python-MIP library, minimizes the codeword weight subject to `stab @ x = 0 (mod 2)` and
`logicOp @ x = 1 (mod 2)` with the mod-2 conditions linearized by powers-of-two slack variables,
and runs **one ILP per logical operator**, so `k` solves for `[[144,12,12]]`. No runtime is
recorded and no solver is pinned in the script.

IBM's 2026 follow-up gives the most detailed public pipeline: `2k` mixed-integer programs per
code (`k` X-type and `k` Z-type logicals), solved with the HiGHS solver through SciPy, with a
distance reported as exact **only when every relevant instance closes with mixed-integer-program
gap zero**. Of 368 distinct non-CSS codes they got 251 exact and 117 upper bounds only. A
dedicated audit confirmed `d = 12` exactly for `[[288,24,12]]` (48 logicals, 29 minutes) and
`[[288,16,12]]` (32 logicals, 80 minutes). They also report that **BP-OSD systematically
overestimates distance, by up to a factor of 12, for high-rate codes** — which is the strongest
single argument that heuristic upper bounds are not good enough for this community.

### 4.3 Tool table

| Tool | Language / license | Exact distance? | Scale reached | Symmetry inside the search? | What it cannot do |
| :--- | :--- | :--- | :--- | :--- | :--- |
| QDistRnd (Pryadko, Shabashov, Kozin) | GAP, `QEC-pages/QDistRnd` | **No** — random-information-set upper bound with an *empirical* convergence estimate | manual says `n <= 10^3` | No | Cannot certify non-existence. The manual itself says "there is no guarantee of the performance of the algorithm (the existing bounds in the case of quantum LDPC codes are weak)" |
| `codeDistance` (Webster, Jacob, Higgott, 2026) | Python, open source | **Yes** — wraps Gurobi, SCIP, CLISAT, connected cluster, Magma; native Brouwer–Zimmermann | exact to about `n = 168` for some families; days of runtime | **No** | No symmetry; the newest and most direct competitor |
| SAT/MaxSAT study toolchain (arXiv:2606.12445) | various | **Yes** — branch-and-bound MaxSAT dominates the hard region | 20–30 of 27 benchmark instances at 2h timeout; `LP_1768_224` unsolved | **No** | No symmetry breaking anywhere in the study |
| `ldpc` (Roffe) + `bposd` | Python/C, MIT | **No** — `compute_distance=True` is brute force and the docs advise against it | small `n` only | No | It is a decoder library |
| `qLDPC` (Perlin, Infleqtion) | Python, Apache-2.0 | **Yes** — `QuditCode.get_distance` via integer linear program | undocumented | Has automorphism machinery, but **for constructing transversal logical gates** (arXiv:2409.18175), not for distance | The one tool that has both ingredients and has not combined them |
| Stim (Gidney, Google) | C++/Python, Apache-2.0 | Circuit distance, **upper bound**: `shortest_graphlike_error` skips ungraphlike errors | — | No | Not a code-property tool |
| PyMatching | C++/Python | Decoder only, graphlike error models | — | No | Cannot decode general qLDPC |
| `dist_m4ri` / connected cluster (Dumer, Kovalev, Pryadko) | C | **Yes** for LDPC — irreducible-cluster method | best-in-class on circuits per arXiv:2603.22532 | Exploits **sparsity**, not automorphisms | No group structure used |
| MQT QECC (Munich) | Python/C++, MIT | **No distance routine at all** — SAT/MaxSAT *decoding*, fault-tolerant state-prep synthesis | — | No | Not in this market |
| Magma | proprietary | **Yes** — Brouwer–Zimmermann; Leon/Unger automorphism algorithms exist but are **separate** from `MinimumWeight` | superseded on qLDPC per arXiv:2606.12445 | Automorphism tools present, not wired in | Commercial license; not embeddable |
| Hernando, Quintana-Ortí, Grassl (arXiv:2408.10743) | — | **Yes** — three new Brouwer–Zimmermann variants for the **symplectic** distance of stabilizer codes, over an order of magnitude faster than Magma | not stated | Not stated | Multicore shared memory; no group reduction claimed |
| sQetch (Caltech + Oratomic, arXiv:2607.28795) | unknown, possibly closed | **No** — GPU *estimator* | powers a pipeline that published `[[975,195,<=24]]` | No | The "`<=`" is the whole story: they could not certify their own headline code |
| PanQEC, qecsim | Python | Not established either way (survey could not verify) | — | — | — |

### 4.4 The classical side

Two facts reframe product three. First, **the minimum distances of the deployed 5G New Radio LDPC
base graphs are still not known**: Danilko, Mogilnykh and Tikhomolov, *Minimum distances of LDPC
codes in 5G standard*, arXiv:2607.04716 (2026), can only bracket the `[9984, 8448]` base-graph-1
code at `d` between 8 and 14, and the `[25344, 8448]` code at `d` between 22 and 57. Butler's
2016 study of the IEEE 802.11n and 802.16e codes (arXiv:1602.02831) likewise gives bounds from
weight-matrix arguments plus a **non-exhaustive** search, and says outright he could not tighten
them. Second, **nobody certifies error floors for shipped silicon.** The practice is
design-to-avoid (construct the code so harmful absorbing sets are absent) plus field-programmable
gate array emulation with importance sampling — Lee and Zhang et al., ISIT 2008, verify no error
floor above bit-error-rate `10^-15` by emulation and extrapolate to `10^-30`. The visible
commercial artifacts are marketing pages (Marvell NANDEdge in the Bravera controllers) and
patents (US 9,160,369, "Method for iterative error correction with designed error floor
performance"), never certificates.

### 4.5 Who pays

Strong evidence, quantum:

- **IBM Quantum** is the clearest case. The gross code underpins their published fault-tolerance
  roadmap and its `d = 12` rests on an integer program; and IBM Research then spent roughly 140
  hours of compute and about US$400 of language-model inference building and open-sourcing a
  mixed-integer-program certification pipeline (`qcode-discovery`, under the `qiskit-community`
  organization), framing the problem explicitly as "reliably certifying the parameters and
  equivalence classes of any candidates found." Andrew Cross is on both bylines.
- **Google Quantum AI** is funding distance-finding *tooling*: Oscar Higgott co-authored
  arXiv:2603.22532 and the `codeDistance` release.
- **Caltech and Oratomic** demonstrated the gap in their own headline result by publishing
  `[[975,195,<=24]]` with an inequality where the distance should be.
- **Infleqtion** owns the `qLDPC` package, but the repository carries no funding statement, so
  this rests on organization ownership alone.
- **Riverlane** is a decoder company with a fast qLDPC decoder (Ambiguity Clustering). The survey
  found **no** Riverlane statement about needing certified distances. Their public surface is
  decoding. Marked as weak inference.
- **Quantinuum, PsiQuantum, QuEra, AWS, Alice&Bob, Xanadu**: no direct evidence found. Do not
  represent them as demand-side.

Classical demand is real but latent and I would not build for it. Marvell, SK hynix, Samsung,
Micron and Kioxia all ship LDPC and none publishes distances, error-floor certificates, or
trapping-set inventories — those are trade secrets satisfied in-house by hiring, not by tool
purchase. The survey did not search job boards, which is an acknowledged gap.

## 5. Candidate first products

Ranked by expected value. All three assume the pre-emption checks in 6.2 come back clean; the
ranking changes if check 1 or check 4 fails.

A framing point that applies to all three: **do not sell "faster search."** Faster search is a
commodity, the benchmark protocol behind our existing speed claims is not defensible as it
stands (risk 2), and the buyers with money already run big clusters. Sell **short, replayable
certificates that a third party can check without rerunning the search** — the thing our
repository has actually built four separate times
(`papers/q13-passant-code/verification/`, `papers/high_weight_grs_cosets/supplement/`,
`papers/mds_css_transversal_groups/supplement/verify.py`, and the C967 acceptance gate that
explicitly demands a checker which rejects corrupted certificates). That is the durable asset.

### Product 1 (highest EV): a symmetry-reduction front end for exact qLDPC distance solvers

**The shape changed once the survey landed.** My first draft proposed writing a new search
engine. That is now clearly wrong. The exact-distance competition in 2026 is *not* hand-written
enumeration — it is Gurobi, HiGHS, SCIP and branch-and-bound MaxSAT solving mixed-integer or
maximum-satisfiability formulations, and arXiv:2606.12445 found that classical
Brouwer–Zimmermann search "no longer maintains its traditional scalability advantage in the
QLDPC setting." Competing with a modern MaxSAT solver on raw search is a losing proposition.

**What it is instead.** A compiler that sits *in front of* those solvers. Input: a quasi-cyclic
or group-algebra presentation of a CSS code plus generators of its automorphism group. Output:
(a) symmetry-breaking constraints and orbit-quotiented variables added to the mixed-integer or
maximum-satisfiability model, so the solver explores one representative per orbit instead of the
whole group orbit; and (b) a certificate recording which group was used, which orbit
representatives were kept, and why the reduction is sound — checkable independently of the
solver run. For the gross code that is a group of order `lm = 72` acting freely on qubits;
the reduction is potentially an order of magnitude or more off the search tree, and it applies
to every one of the `2k` solves in IBM's pipeline.

**Why this is the right first product.** It is exactly the thesis ergodis's own documentation already
argues: "the compiled state can instead define a smaller external model after equivalences and
impossible states have been removed" (`OPTIMIZATION.md:325-329`). The crate's whole design
philosophy — compile the algebra, then hand a smaller problem to CP-SAT or a specialized kernel —
is precisely the right architecture for this market, and it is the one thing every competitor
listed in 4.3 does not do. It also sidesteps the two hardest engineering gaps: we do not need
bitsliced GF(2) linear algebra at scale, and we do not need to out-engineer Gurobi.

**Why us specifically.** The orbit-compilation-with-independent-verification discipline exists in
code (`group_action.rs:757`, `:841`). The certificate-plus-replay product shape exists in Rust
(`projective-reed-solomon`, section 3.2). And the open problem has been stated in print by MIT
(section 4.1), which makes this publishable as well as sellable — a paper and a tool from the
same work.

**Effort.** Medium, and much smaller than my first estimate: 2–3 months to a credible prototype.
The work is group-orbit computation on coordinate supports, sound symmetry-breaking constraint
generation (the standard techniques are lexicographic-leader and orbitopal fixing from the
integer-programming literature — check what transfers), model emission to the solvers people
already use, and a certificate format. No new solver.

**Benchmarks required, and they are already assembled for us.** arXiv:2606.12445 published a
27-instance benchmark — bivariate and generalized bicycle codes at `n = 72` to `360`, lifted
product at `n = 34` to `1768`, quantum Tanner at `n = 36` to `360` — with a two-hour timeout and
per-solver results. That is a ready-made scoreboard. The specific targets: beat the published
time on `BB_144_12_12`, `LP_544_80_12` and `TN_250_10_15` (the three hard-transition instances),
and solve `LP_1768_224`, which **nobody solved**. Solving that one instance would be an
unambiguous, citable result.

**First experiment (one to two weeks).** Take Bravyi et al.'s own `distance_test.py` from
`github.com/sbravyi/BivariateBicycleCodes`, which is public and short, and add orbit-based
symmetry-breaking constraints for the `Z_l x Z_m` group to its integer program for the
`[[144,12,12]]` gross code. Measure branch-and-bound node count and wall time against the
unmodified script, same solver, same machine. This is cheap, uses a published reference
implementation with a known answer, and answers the only question that matters: does the
symmetry reduction actually shrink the tree, or does the solver's own presolve already find it?
If the reduction buys less than about 5x, stop — the whole proposal rests on this number.

A second, complementary check at the same cost: run the same experiment on the passant code
(78 coordinates, `PGL(2,13)` of order 2184, known `d = 12` with 364 minimum words in four orbits
of 91), where the group is far larger relative to the code and our own committed certificates
give an independent answer to check against.

### Product 2: exact transversal logical gate group of a given finite CSS code

**What it is.** Input a stabilizer or CSS code; output the exact group of transversal logical
operations it admits, with a proof object, rather than a yes/no test for one nominated gate.

**Why us.** This is the one capability where the repository owns novel published mathematics
rather than a reimplementation. AME paper II computes exactly this for MDS–CSS codes via the
conductor `Cond(C,C^perp) = (C^{*2})^perp`, giving `F_q^2 ⋊ T` or `F_q^2 ⋊ SL_2(q)`
(section 3.3). The repository's own bridge note already flagged holonomy-centralizer
certification of a proposed finite code's transversal group as the transferable piece
(`notes/open-problems/plausible-bridges/transversal-codes.md:36-42`), and C967's deliverable 6
is a research gate on exactly this question for the jet-quotient family.

**Effort.** Medium: 6–10 weeks, because the mathematics is done and the computation is
centralizer algebra over small fields, which our existing pure-Python evidence bundles already
do at the sizes involved. The extension from MDS–CSS to arbitrary CSS is the research risk, and
it is a real one — the conductor argument leans on the MDS property.

**Benchmarks required.** Reproduce known transversal gate groups for the Steane code, the
`[[15,1,3]]` Reed–Muller code (transversal T), and 2D color codes; then report the group for a
bivariate bicycle code, where the answer is not standard textbook material.

**First experiment.** Recompute the transversal group of `[[5,1,3]]_11` from AME paper II's
`supplement/evidence/` bundles through a general code-agnostic path rather than the
family-specific one, and check it lands on the published answer. If a general implementation
cannot reproduce the paper's own worked case, the generalization is not close.

**Pre-emption warning — this is contested ground and the evidence got worse during the
investigation.** The local literature cache already holds `arXiv:2303.15615` (*Transversal
Diagonal Logical Operators for Stabilizer Codes*), `arXiv:1409.8320`, `arXiv:2507.10519`, and
`arXiv:2409.18175` (*Fault-Tolerant Logical Clifford Gates from Code Automorphisms*). The
survey independently established that Infleqtion's `qLDPC` package **already ships automorphism
machinery for constructing transversal logical gates**, citing arXiv:2409.18175 — that is a
working implementation of a large part of this product, in Python, under Apache-2.0. Read
arXiv:2409.18175 and arXiv:2303.15615 before spending anything here.

**Ranked second, not first,** for three reasons now. The addressable market is a few dozen
research groups. It is a capability people want occasionally, not on every design iteration —
product one sits in a design loop, product two in a paper-writing loop. And a permissively licensed
implementation of the adjacent capability already exists.

### Product 3 (lowest EV): classical QC-LDPC error-floor and trapping-set certification

**What it is.** Exhaustive certified enumeration of `(a,b)` trapping sets and stopping sets for
5G NR, Wi-Fi, and NAND-flash QC-LDPC base graphs, with orbit counts under the circulant group.

**Why it is ranked last despite the largest market.** Three reasons, all structural. The
existing kernel is a toy (section 2.1) with no demonstrated scale. Symmetry is *already* used
here — Usatyuk, Kuznetsov and Egorov, arXiv:2401.14810, do cyclic group projection for exactly
this problem — so the differentiator that makes product one attractive is absent. And the actual
deliverable those buyers want is an **error-floor curve**, which requires importance sampling
and decoder simulation (belief propagation, min-sum, layered scheduling), none of which exists
anywhere in this repository and all of which sits outside the exact-algebraic competence the
rest of the work is built on. Section 4.4 establishes that no vendor certifies error floors at
all: they design-to-avoid and measure by field-programmable-gate-array emulation. We would be
selling a certificate to people who have never bought one.

**The one genuinely tempting fact.** The minimum distance of the deployed 5G New Radio
base-graph-1 `[25344, 8448]` code is *unknown*, bracketed only at `d` between 22 and 57 by a
2026 paper (arXiv:2607.04716). Nailing that number exactly would be a striking result. But note
what it is: an academic paper, not a product — and the same paper's authors already have the
early-termination machinery and did not close it, which tells you it is hard.

**If pursued anyway:** effort 4–6 months, benchmark is 5G base graph 1 at lift `Z = 384` against
arXiv:2607.04716's bounds, first experiment is reproducing their `d ∈ {8..14}` bracket for the
`[9984, 8448]` code. I would not start here. If the 5G distance question appeals, treat it as a
paper in the classical-coding lane, not as a product.

## 6. Risks and pre-emption checks

### 6.1 Risks visible from the code and benchmarks alone

1. **The QC-LDPC benchmark control is not a coding tool.** `BENCHMARKS.md` says outright:
   "Commercial solvers and domain-specific LDPC enumerators are not included, so these
   measurements support only the declared instance comparisons"
   (`BENCHMARKS.md:107-109`). The 336x row is against CryptoMiniSat.
   No comparison against a trapping-set enumerator, against QDistRnd, or against `ldpc`
   exists (`BENCHMARKS.md:107`). Every performance claim in this direction is unestablished.
2. **The benchmark protocol is asymmetric.** The perf review's finding 1
   (`notes/2026-08-28-ergodis-perf-expert-review.md:14-18`) records that ergodis is timed as a
   warm in-process mean over 100k repetitions while controls are run once, cold, median of 11
   processes, and that this is undisclosed. Any headline number reused in a product pitch would
   have to be re-measured symmetrically first. This is the single largest credibility risk.
3. **Build configuration is not reproducible** (perf review finding 2;
   `BENCHMARKS.md:668` cites a `target-cpu=x86-64-v3` pin absent from the tree).
4. **AGPL-3.0** (`README.md:334-336`). That is a deliberate dual-license posture ("Contact the
   author for commercial licensing") and is the right choice for a certification tool, but it
   rules out drop-in adoption by the exact industrial users who would otherwise trial it.
   Every competitor named in section 4 is MIT/Apache/BSD. Note the repository is not
   internally consistent here: the `projective-reed-solomon` toolkit in section 3.2 is MIT
   (`papers/high_weight_grs_cosets/software/projective-reed-solomon/Cargo.toml:6`, verified).
   A licensing decision has to be made deliberately, not inherited from whichever crate the
   code is grafted onto.
5. **The trapping-set DFS has never been demonstrated at scale.** The bundled example is a
   4-variable-node code. Between that and a 5G NR base graph (BG1: 46x68 protograph, lifts to
   Z=384) there is no evidence at all.
6. **The data model cannot express the target objects.** `QcLdpcCode` holds one circulant
   shift per protograph cell, so bivariate bicycle codes (weight-three blocks) are
   unrepresentable, and there is no notion of an X/Z check pair anywhere in the crate — no CSS
   code can be entered at all. Anyone evaluating "can ergodis do qLDPC today" gets a no at the
   input stage, before any algorithm question arises.
7. **No paper backs the LDPC angle.** `papers/complete-repair-ports/compositional_recovery.tex`
   contains no occurrence of "LDPC" or "trapping set" (checked). The QC-LDPC front end is a
   software feature with no theorem behind it, unlike the composition/transfer results. A
   product built on it starts with zero published mathematical backing, which removes the
   repository's main structural advantage.

### 6.2 Pre-emption checks still needed

Check 1 is now **answered negatively** (i.e. in our favour) by the survey; the rest remain open.
Each open item needs the three-source discipline
(`notes/literature-audit-conventions.md`): OpenAlex, Crossref, and Semantic Scholar, because a
zero-citation result from one graph is usually an indexing gap.

1. ~~**Symmetry-reduced distance search for quasi-cyclic quantum codes.**~~ **Answered: not
   done.** Section 4.1 gives four independent lines of evidence, including an author-stated open
   problem from MIT (arXiv:2606.05044). Two adjacent uses of automorphisms exist and must not be
   confused with it: automorphism-ensemble *decoding* of quasi-cyclic LDPC codes (arXiv:2202.00287)
   and automorphism-based *dimension* calculation for bivariate bicycle codes (Postema and
   Kokkelmans, arXiv:2502.17052, whose distances are Monte-Carlo estimates with a stated `±2`
   accuracy). Neither touches the distance search. Before publishing, redo this as a formal
   audit — the survey was a web sweep, not a citation-closure audit.
2. **Information-set-decoding overlap.** Meet-in-the-middle over a GF(2) syndrome (section 2.2)
   is the Stern/Dumer/MMT/BJMM structure, and forty years of cryptanalysis literature sits on
   it. Any claim of a novel search algorithm here is very likely pre-empted. Note this now
   matters less: product one no longer proposes a new search engine. Still check
   `information set decoding` + `quantum code distance` before writing any algorithm section.
3. **Symmetry breaking in integer programming.** New, and now the most important open check.
   Symmetry breaking for mixed-integer programs is a mature subfield — orbital branching,
   orbitopal fixing, isomorphism pruning, lexicographic-leader constraints. Establish what
   transfers to a `Z_l x Z_m`-symmetric weight-minimization program before claiming novelty,
   and check whether Gurobi's and HiGHS's own presolve already detect and exploit this symmetry
   automatically. **If the solvers already do it, the proposal is dead**, and the first experiment
   in product one is designed to reveal exactly that.
4. **Certificates of non-existence for low-weight codewords.** Our strongest differentiator is
   the *short checkable certificate* (the 3.7 KB positive-semidefinite obstruction in
   `papers/q13-passant-code/verification/weight_eight_theta.json`, verified size on disk).
   Check whether Delsarte linear-programming, semidefinite, or Lasserre-hierarchy bounds have
   already been packaged as replayable per-code non-existence certificates — the theory
   certainly exists (Schrijver's SDP bounds for binary codes, 2005); the question is whether
   anyone ships them as an artifact. This is a "packaged, not proved" novelty, which is fine
   for a product and fatal for a paper.
5. **Exact transversal-gate-group computation.** For product two, and now urgent: the survey
   established that Infleqtion's `qLDPC` package already uses automorphisms to construct
   transversal logical gates, citing arXiv:2409.18175. Determine exactly what it computes —
   a group, or membership for nominated gates — before assuming a gap exists.
6. ~~**Trapping-set enumeration completeness.**~~ **Partly answered.** Karimi and Banihashemi's
   layered-superset characterization of leafless elementary trapping sets gives an exhaustive
   expansion search (arXiv:1510.04954, arXiv:1801.02028), the problem is known hard
   (arXiv:1711.10543), and symmetry is already exploited for quasi-cyclic codes
   (arXiv:2401.14810). Still open: what sizes these reach in practice and whether any is open
   source. This mainly confirms product three is crowded.
7. **Already-cached prior art that raises the bar on product two, found locally.** The shared
   literature cache at `/tmp/persistent/tavis/lit-search/` already holds, verified by me with
   `litcache.py list`:
   - `arXiv:2409.18175`, *Fault-Tolerant Logical Clifford Gates from Code Automorphisms* —
     automorphism-group methods applied to logical gates in this exact setting;
   - `arXiv:2303.15615`, *Transversal Diagonal Logical Operators for Stabilizer Codes* — a
     computational method for finding transversal diagonal logical operators, which is close
     to product two's core deliverable;
   - `arXiv:1409.8320`, *Classification of Transversal Gates in Qubit Stabilizer Codes*;
   - `arXiv:2507.10519`, *A Classification of Transversal Clifford Gates*;
   - `arXiv:1910.09333`, *On Optimality of CSS Codes for Transversal T*;
   - `arXiv:1102.5715`, *Automorphisms of Stabilizer Codes*;
   - `10.1007/s10623-006-0022-6`, Droms–Mellinger–Meyer, *LDPC codes generated by conics in
     the classical projective plane* — the passant code's own prior art, already cached.

   None of these were read in this session; only their titles were confirmed present. But the
   titles alone mean product two is entering a **crowded** area, and that automorphism-based
   reasoning about qLDPC logical operators is live current work rather than an opening. Read
   `arXiv:2303.15615` and `arXiv:2409.18175` before committing anything to product two, and read
   `arXiv:1102.5715` before claiming novelty for the symmetry-reduction idea in product one.
8. ~~**The gross-code question.**~~ **Answered** in section 4.2: a mixed-integer program,
   one solve per logical operator, with no symmetry used. Two loose ends the survey could not
   close and which should be closed before citing this anywhere: the bibliographic identity of
   Bravyi et al.'s reference [55] (the ar5iv render truncates the entry), and which solver
   backend Python-MIP actually used. Also note there is **no published independent
   re-certification** of `d = 12` for the gross code by a second group using a different method
   — the SAT/MaxSAT benchmark treats `BB_144_12_12` as solvable, which is corroboration but not
   an independent claim. That absence is itself a small opportunity.
9. **Ordinary product diligence, not yet done at all.** Whether anyone would pay, what they pay
   today, and whether an AGPL or dual-licensed tool can enter a workflow built on Apache-2.0
   Python packages. Section 4.5 establishes that IBM and Google *fund* this work; it does not
   establish that either would *buy* it rather than continue building in-house, and in-house is
   my default prior for both.

## 7. Sources

### 7.1 Repository artifacts read directly (by me, in this session)

All paths relative to `/home/tavis/src/othello`.

- `papers/complete-repair-ports/ergodis/README.md` — full.
- `papers/complete-repair-ports/ergodis/OPTIMIZATION.md` — full.
- `papers/complete-repair-ports/ergodis/src/sat.rs` — full.
- `papers/complete-repair-ports/ergodis/src/span.rs` — full.
- `papers/complete-repair-ports/ergodis/src/incidence.rs` — full.
- `papers/complete-repair-ports/ergodis/src/packed_ternary.rs` — full.
- `papers/complete-repair-ports/ergodis/src/applications.rs:1050-1379` — the QC-LDPC front end.
- `papers/complete-repair-ports/ergodis/src/orbit.rs` — header, public API, meet-in-the-middle
  driver; not the full DFS body.
- `papers/complete-repair-ports/ergodis/src/group_action.rs` — header, trait, binary GL types,
  public function list.
- `papers/complete-repair-ports/ergodis/src/matrix.rs:1-40`; `src/lib.rs:1-40`;
  `src/balanced.rs:1-25`; `src/defect.rs:1-15`; `src/bitset.rs` API list;
  `src/confinement.rs` public function list.
- `papers/complete-repair-ports/ergodis/BENCHMARKS.md:70-125, 665-675`.
- `papers/complete-repair-ports/ergodis/examples/data/qc-ldpc-search.json`.
- `notes/2026-08-28-ergodis-perf-expert-review.md:1-100` (the ranked summary, items 1–12).
- `notes/open-problems/plausible-bridges/transversal-codes.md` — full.
- `notes/open-problems/sources-quantum-information.md:78-100`.
- `notes/2026-07-07-codex-task-queue.md:254` (the C967 row, anchored exact-row query).
- `papers/q13-passant-code/passant_code_q13.tex:106-108, 197-201`;
  `verification/weight_ten_moment.json` and `weight_eight_theta.json` (headers and sizes).
- `papers/high_weight_grs_cosets/software/projective-reed-solomon/` — directory listing,
  `Cargo.toml:6` (MIT), `src/lib.rs` line count.
- `papers/mds_css_transversal_groups/supplement/` — listing of `verify.py`,
  `EVIDENCE-MANIFEST.json`, `evidence/`.

Read by a delegated agent and relied on in section 3 without my independent re-reading, except
where I re-checked and said so: the four papers' abstracts and theorem statements, the C967
task card, and the quantum-codes handoff.

### 7.2 External literature

Fetched by a delegated survey agent (67 tool calls), not by me. Nothing was added to the shared
cache. The agent read two PDFs directly and quotes from them — arXiv:2606.05044 and
arXiv:1602.02831 — and one source file directly, Bravyi et al.'s `distance_test.py`; everything
else came from abstract pages, HTML renders, documentation, or repository READMEs. The agent
caught and corrected one summarizer hallucination during the run (a claim that arXiv:2606.05044
used orbit-based distance reduction, which the PDF text refutes), which is a point in favour of
the rest but not a guarantee.

**Quantum code distance: methods and benchmarks**

1. Bravyi, Cross, Gambetta, Maslov, Rall, Yoder, *High-threshold and low-overhead fault-tolerant
   quantum memory*, Nature 627:778–782 (2024). DOI `10.1038/s41586-024-07107-7` ·
   https://arxiv.org/abs/2308.07915
2. `distance_test.py` and repository — https://github.com/sbravyi/BivariateBicycleCodes
3. Cruz-Benito, Cross, Kremer, Faro (IBM Research), *Evolutionary Discovery of Bivariate Bicycle
   Codes with LLM-Guided Search* — https://arxiv.org/abs/2606.02418 ; IBM blog
   https://research.ibm.com/blog/ai-for-qec ; framework `qcode-discovery` under `qiskit-community`
4. Webster, Jacob, Higgott, *Distance-Finding Algorithms for Quantum Codes and Circuits* —
   https://arxiv.org/abs/2603.22532 ; package https://pypi.org/project/codedistance/
5. *SAT, MaxSAT, and SMT for QLDPC Distance Computation: A Large-Scale Empirical Study* —
   https://arxiv.org/html/2606.12445
6. Pryadko, Shabashov, Kozin, QDistRnd, JOSS 7(76):4120 (2022). DOI `10.21105/joss.04120` ·
   https://arxiv.org/abs/2308.15140 · https://github.com/QEC-pages/QDistRnd ·
   manual https://docs.gap-system.org/pkg/qdistrnd/doc/chap1_mj.html
7. Dumer, Kovalev, Pryadko, *Distance Verification for Classical and Quantum LDPC Codes*, IEEE
   Trans. Inf. Theory (2016) — https://escholarship.org/uc/item/43n2z2ct ; earlier
   https://arxiv.org/pdf/1405.0348
8. Hernando, Quintana-Ortí, Grassl, ACM Trans. Quantum Comput. 7(2) art. 12 (2026).
   DOI `10.1145/3795877` · https://arxiv.org/abs/2408.10743
9. Kapshikar and Kundu, *On the hardness of the minimum distance problem of quantum codes* —
   https://arxiv.org/abs/2203.04262
10. Grigorescu et al., FSTTCS 2025. DOI `10.4230/LIPIcs.FSTTCS.2025.34` ·
    https://arxiv.org/abs/2509.21469
11. Bhardwaj, Ma, Meister, King, Bluvstein, Preskill, Cain, Xu, Huang, *High-rate qLDPC
    processors* (mitten codes, sQetch) — https://arxiv.org/abs/2607.28795 ; secondary coverage
    (the 800,000x figure, unverified) https://postquantum.com/quantum-research/mitten-codes-qldpc-processor/

**Automorphisms and code structure**

12. Davenport, Blue, Chuang (MIT), *Generalized Bicycle Codes as Cyclic Submodules and their
    Automorphism Structure* — https://arxiv.org/pdf/2606.05044 (PDF read and quoted)
13. Wang and Pryadko, *Distance bounds for generalized bicycle codes* —
    https://arxiv.org/abs/2203.17216
14. Postema and Kokkelmans, *Existence and Characterisation of Bivariate Bicycle Codes* —
    https://arxiv.org/html/2502.17052v3
15. Sayginel et al., *Fault-Tolerant Logical Clifford Gates from Code Automorphisms* —
    https://arxiv.org/pdf/2409.18175
16. *Automorphism Ensemble Decoding of Quasi-Cyclic LDPC Codes by Breaking Graph Symmetries* —
    https://arxiv.org/abs/2202.00287
17. Grassl, *Searching for linear codes with large minimum distance*, in Discovering Mathematics
    with Magma. DOI `10.1007/978-3-540-37634-7_13`

**qLDPC families**

18. Panteleev and Kalachev, *Degenerate quantum LDPC codes with good finite length performance*,
    Quantum 5:585 (2021). DOI `10.22331/q-2021-11-22-585` · https://arxiv.org/abs/1904.02703
19. Panteleev and Kalachev, *Quantum LDPC Codes with Almost Linear Minimum Distance* —
    https://arxiv.org/abs/2012.04068 ; STOC 2022 DOI `10.1145/3519935.3520017`
20. Breuckmann and Eberhardt, *Balanced Product Quantum Codes* — https://arxiv.org/pdf/2012.09271
21. *On the Minimum Distances of Finite-Length Lifted Product Quantum LDPC Codes* —
    https://arxiv.org/abs/2503.07567
22. Error Correction Zoo — https://errorcorrectionzoo.org/c/gross ,
    https://errorcorrectionzoo.org/c/qcga

**Classical LDPC: distances, trapping sets, error floors**

23. Danilko, Mogilnykh, Tikhomolov, *Minimum distances of LDPC codes in 5G standard* (2026) —
    https://arxiv.org/abs/2607.04716
24. Butler, *Minimum Distances of the QC-LDPC Codes in IEEE 802 Communication Standards* —
    https://arxiv.org/abs/1602.02831 (PDF read)
25. Usatyuk, Kuznetsov, Egorov, *Cyclic Group Projection for Enumerating Quasi-Cyclic Codes
    Trapping Sets* — https://arxiv.org/abs/2401.14810 (abstract only)
26. Karimi and Banihashemi, layered-superset trapping-set characterization. DOI
    `10.1109/TIT.2016.2613113` · https://arxiv.org/pdf/1510.04954 · https://arxiv.org/pdf/1308.1259 ;
    non-elementary extension https://arxiv.org/pdf/1801.02028
27. *Hardness Results on Finding Leafless Elementary Trapping Sets and Elementary Absorbing Sets*
    — https://arxiv.org/pdf/1711.10543
28. Dolecek et al., absorbing-set spectrum https://arxiv.org/pdf/1106.0057 ; cycle-consistency
    matrix https://arxiv.org/pdf/1208.6094
29. Lee, Zhang et al., *Error Floors in LDPC Codes: Fast Simulation, Bounds and Hardware
    Emulation*, ISIT 2008 — https://web.eecs.umich.edu/~zhengya/papers/lee_isit08.pdf ; also
    https://arxiv.org/pdf/1202.2826
30. *An efficient exhaustive low-weight codeword search for structured LDPC codes* —
    https://ieeexplore.ieee.org/document/6502981/

**Tools**

31. `qLDPC` (Perlin), Apache-2.0 — https://github.com/Infleqtion/qLDPC
32. `ldpc` / `bposd` (Roffe) — https://github.com/quantumgizmos/ldpc ,
    https://github.com/quantumgizmos/bp_osd
33. Stim graphlike-error limitation — https://github.com/quantumlib/Stim/issues/391
34. MQT QECC — https://github.com/munich-quantum-toolkit/qecc
35. Magma coding theory — https://magma.maths.usyd.edu.au/magma/handbook/text/1984

**Industry**

36. Riverlane, Ambiguity Clustering decoder —
    https://www.riverlane.com/news/introducing-ambiguity-clustering-the-qldpc-decoder-up-to-27x-faster-than-bp-osd
37. Marvell NANDEdge LDPC — https://www.marvell.com/products/ssd-controllers.html
38. IEEE International Roadmap for Devices and Systems 2023, NAND error-correction strength —
    https://irds.ieee.org/images/files/pdf/2023/2023IRDS_MDS.pdf
39. US Patent 9,160,369, *Method for iterative error correction with designed error floor
    performance*

**Explicitly unverified, per the survey's own accounting:** the identity of Bravyi et al.'s
reference [55]; which solver backend Python-MIP used; whether arXiv:2408.10743 uses
automorphisms; sQetch's algorithm, its 800,000x speedup claim, and whether it is open source;
`codeDistance`'s license; PanQEC and qecsim distance capability; `aff3ct` and LDPC-toolbox
entirely; and the industrial-funding picture for every company other than IBM and Google.

### 7.3 Local literature cache

Confirmed by me with `python3 /tmp/persistent/tavis/lit-search/bin/litcache.py list`. The cache
holds **nothing** on qLDPC distance computation, trapping sets, or error floors — everything in
7.2 was fetched fresh. It does hold these adjacent entries (titles as listed; contents not
read):

| Key | Title |
| :--- | :--- |
| `10.1007/s10623-006-0022-6` | LDPC codes generated by conics in the classical projective plane (Droms–Mellinger–Meyer) |
| `10.26493/1855-3974.2501.4c4` | LDPC codes from cubic semisymmetric graphs |
| `arXiv:1102.5715` | Automorphisms of Stabilizer Codes |
| `arXiv:2409.18175` | Fault-Tolerant Logical Clifford Gates from Code Automorphisms |
| `arXiv:2303.15615` | Transversal Diagonal Logical Operators for Stabilizer Codes |
| `arXiv:1409.8320` | Classification of Transversal Gates in Qubit Stabilizer Codes |
| `arXiv:2507.10519` | A Classification of Transversal Clifford Gates |
| `arXiv:1910.09333` | On Optimality of CSS Codes for Transversal T |
| `arXiv:2001.04887` | Classical Coding Problem from Transversal T Gates |
| `arXiv:1408.1720` | Fault-tolerant logical gates in quantum error-correcting codes |
| `10.1103/PhysRevA.95.012329` | Diagonal gates in the Clifford hierarchy |
| `10.1109/TIT.2005.851760` | Quantum Codes from Concatenated Algebraic-Geometric Codes |

Also cited in-line from repository notes, with their own audit trails:

- Golowich and Guruswami, *Asymptotically Good Quantum Codes with Transversal Non-Clifford
  Gates*, arXiv `2408.09254` (cached in the repository's audit trail with SHA-256, per
  `notes/open-problems/plausible-bridges/transversal-codes.md:70-74`).
- He, Vaikuntanathan, Wills, Zhang, *Asymptotically Good Quantum Codes with Addressable and
  Transversal Non-Clifford Gates*, https://arxiv.org/abs/2507.05392 (abstract/metadata only).
- Li, Li, Liu, *Transversal non-Clifford gates on almost-good quantum LDPC and quantum locally
  testable codes*, https://arxiv.org/abs/2604.01874 (abstract/metadata only).
- Droms, Mellinger, Meyer, *LDPC codes generated by conics in the classical projective plane*,
  Designs, Codes and Cryptography 40 (2006) 343–356, DOI `10.1007/s10623-006-0022-6` — cited by
  `papers/q13-passant-code/passant_code_q13.tex:197-201` for the `8 <= d <= 12` general bound
  and the Table 8 entry `[78,36,12]_2`.
