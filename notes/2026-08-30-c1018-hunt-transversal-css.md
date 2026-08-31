# C1018 — Exact diagonal transversal groups of small CSS codes

**Lane:** `gem-mining`
**Date:** 2026-08-30
**Status:** in progress

## 1. The finite-size question the dossier poses

`notes/open-problems/plausible-bridges/transversal-codes.md` (external ID `BIG-709`)
records that the *asymptotic* headline — asymptotically good quantum codes with
transversal non-Clifford gates — was settled by Golowich–Guruswami (arXiv
`2408.09254`, 2024) and by He–Vaikuntanathan–Wills–Zhang (arXiv `2507.05392`,
2025), and that the remaining asymptotic target is *good qLDPC* (bounded check
weight, constant rate, **linear** distance) with a transversal non-Clifford
gate; Li–Li–Liu (arXiv `2604.01874`) reach `tildeTheta(N)` distance but not
linear.

The dossier then lists three independent attack routes, and this task owns the
third one verbatim:

> **Finite-size exact search.** Use symplectic normal forms, logical-action
> constraints, holonomy centralizers and SAT to find short qLDPC codes with a
> precisely certified transversal group and decoder. This is tractable and
> useful, though not a solution of the asymptotic problem.

together with the transfer item

> holonomy-centralizer calculations can certify the exact transversal group of
> a proposed finite code.

**Fixed question for this task.** For a named list of small qubit CSS codes:

1. certify the **exact** minimum distance `d` (no upper-bound heuristics), and
2. compute the **exact** group of transversal diagonal gates
   `U = ⊗_j diag(1, e^{i θ_j})` that preserve the code space, as an abstract
   compact abelian group, and
3. classify the **induced logical gate** of every generator, including its
   exact Clifford-hierarchy level.

Two of the three parts of the dossier's route-3 sentence are in scope
(symplectic/normal-form structure and logical-action constraints); the SAT and
decoder parts are not, and no claim below depends on them.

## 2. Exact framework (what is actually computed)

Fix a qubit CSS code by two binary matrices over `F_2`:

- `A ⊆ F_2^n`: the `X`-type stabilizer code (the superposition support), so the
  logical basis states are `|ψ_v⟩ = |A|^{-1/2} Σ_{a∈A} |a ⊕ v⟩`;
- `B ⊆ F_2^n`: the `Z`-type stabilizer code, with `A ⊥ B`;
- code space spanned by `|ψ_v⟩` for `v` running over `B^⊥ / A`, so
  `k = n − dim A − dim B`.

A transversal diagonal unitary `U = ⊗_j diag(1, e^{iθ_j})` acts by
`U|x⟩ = e^{i θ·x}|x⟩` with `θ·x` the **integer** inner product. It preserves the
code space **iff** `x ↦ θ·x` is constant modulo `2π` on every coset `v ⊕ A`
inside `B^⊥`. (Necessity and sufficiency both follow because distinct cosets
have disjoint computational-basis supports, so `U|ψ_v⟩` must be a scalar
multiple of `|ψ_v⟩`.)

Because `⊕` is not integer addition, the constraint is **not** `θ·a ≡ 0` — the
carry terms are exactly what makes transversal `T` on `[[15,1,3]]` possible and
transversal `T` on `[[7,1,3]]` impossible. Writing the constraint out, the
condition is the integer-linear system

    M θ ≡ 0  (mod 2π),      rows of M = (v ⊕ a) − v  ∈ {−1,0,1}^n,

with `v` ranging over one representative of each of the `2^k` cosets of `A` in
`B^⊥` and `a` over all of `A`. Constancy on a coset is representative-independent,
so this row set is complete.

Setting `x = θ/2π`, the transversal diagonal group is
`G = { x ∈ R^n : M x ∈ Z^R } / Z^n`. With the Smith normal form `U M V = D`,
`D = diag(d_1,…,d_r)`, this is **exactly**

    G  ≅  Z_{d_1} ⊕ … ⊕ Z_{d_r}  ⊕  T^{n−r},

with torsion generators `x^{(i)} = V e_i / d_i`. This is the sharp,
representation-independent answer; no search or heuristic enters.

The induced logical gate of `x ∈ G` is diagonal in the logical computational
basis,
`|x_L⟩ ↦ e^{2πi p(x_L)} |x_L⟩` with `p(x_L) = x · v(x_L)` reduced mod 1, where
`v(·)` is the chosen coset transversal. Expanding `p` in the multilinear basis
over `Z_N` (`N = lcm d_i`), `p = Σ_S α_S ∏_{i∈S} x_i`, the Clifford-hierarchy
level of the induced diagonal logical gate is

    level = max_{α_S ≠ 0} ( |S| + e_S − 1 ),    2^{e_S} = order of α_S in Z_N,

calibrated on `Z` (level 1), `S` (2), `T` (3), `CZ` (2), `CCZ` (3), `C^{D−1}Z`
(`D`). Level ≥ 3 is non-Clifford.

Distance is certified separately and independently by the Ergodis
`css_distance_native` binary (Section 4).

## 3. Candidate list

Assembled from the codes the dossier and the quantum-information source file
name (the transversal-`CCZ` and transversal-non-Clifford literature turns on the
hypercube colour codes and the quantum Reed–Muller family), plus the standard
small CSS codes used as method calibration. No web search was used; the
constructions are built from `RM(r,m)` and simplex generator matrices inside the
driver.

| label | construction | `A` (X-type) | `B` (Z-type) |
|---|---|---|---|
| `[[4,2,2]]`  | detection code, `D=2` hypercube  | `{0,1111}`      | `{0,1111}`      |
| `[[8,3,2]]`  | cubic colour code, `D=3`         | `RM(0,3)`       | `RM(1,3)`       |
| `[[16,4,2]]` | hypercube colour code, `D=4`     | `RM(0,4)`       | `RM(2,4)`       |
| `[[32,5,2]]` | hypercube colour code, `D=5`     | `RM(0,5)`       | `RM(3,5)`       |
| `[[7,1,3]]`  | Steane, CSS of `[7,4]` Hamming   | `[7,3]` simplex | `[7,3]` simplex |
| `[[15,7,3]]` | CSS of `[15,11]` Hamming         | `[15,4]` simplex| `[15,4]` simplex|
| `[[15,1,3]]` | quantum Reed–Muller, `m=4`       | `[15,4]` simplex| `(simplex+1)^⊥` |
| `[[31,1,3]]` | quantum Reed–Muller, `m=5`       | `[31,5]` simplex| `(simplex+1)^⊥` |
| `[[9,1,3]]`  | Shor                             | two weight-6    | six weight-2    |

`[[5,1,3]]` is excluded: it is not CSS, so it is outside the framework of
Section 2. The Golowich–Guruswami and He–Vaikuntanathan–Wills–Zhang codes are
excluded for a stated reason, not silently: their smallest instances are not
determined by the dossier or the sources file, and the papers are cached only at
`partial` / `abstract-only` read depth, so no concrete generator matrix for them
exists in this repository. That is an evidence gap, recorded in Section 9.

## 4. Exact distances (Ergodis `css_distance_native`)

Every distance below is an **exhaustive** exact value, not a heuristic upper
bound: `css_distance_native` replays and closes every strictly smaller connected
support, with `anchors` set to every coordinate (the library documents that
passing every coordinate is always sound) and `maximum_weight = n`.

`d_Z` is the minimum weight of a `Z`-type logical (`physical_checks = A`,
`logical_observations` = a completion of `A` to `B^⊥`); `d_X` is the mirror run.
`d = min(d_X, d_Z)`.

| code | `d_X` | `d_Z` | `d` | search seconds | candidates enumerated |
|---|---|---|---|---|---|
| `[[4,2,2]]`  |  2 | 2 | 2 | < 0.0001 |          24 |
| `[[8,3,2]]`  |  4 | 2 | 2 | < 0.0001 |         224 |
| `[[16,4,2]]` |  8 | 2 | 2 |   0.0001 |       3,779 |
| `[[32,5,2]]` | 16 | 2 | 2 |   5.7371 | 791,172,396 |
| `[[7,1,3]]`  |  3 | 3 | 3 | < 0.0001 |          37 |
| `[[15,7,3]]` |  3 | 3 | 3 | < 0.0001 |         179 |
| `[[15,1,3]]` |  7 | 3 | 3 |   0.0001 |       2,887 |
| `[[31,1,3]]` | 15 | 3 | 3 |   1.7945 | 237,713,568 |
| `[[9,1,3]]`  |  3 | 3 | 3 | < 0.0001 |         156 |

Every value matches the code's advertised parameters, including the asymmetric
pairs `(d_X,d_Z) = (7,3)` for `[[15,1,3]]`, `(15,3)` for `[[31,1,3]]` and
`(2^{D-1},2)` for the hypercube family. The two large runs (`[[32,5,2]]` X-side,
`[[31,1,3]]` X-side) are genuine exhaustions of hundreds of millions of
connected supports on a single core.

Evidence: `~/.cache/ergodis/c1018/evidence/*.jsonl` (one create-only JSONL
record per run, each carrying the problem hash, kernel, timings and witness);
inputs at `~/.cache/ergodis/c1018/inputs/*.json`.

## 5. Exact diagonal transversal groups and induced logical gates

`G` is the complete group of transversal diagonal gates
`⊗_j diag(1, e^{iθ_j})` preserving the code space, computed by Smith normal
form as in Section 2 — it is *the whole group*, not a sampled subgroup, and no
phase choice is presupposed. "Logical group" is its image modulo global phase.
"Level" is the maximal Clifford-hierarchy level of an induced logical gate.

| code | `n` | `k` | `d` | `G` (exact) | `\|G\|` | induced logical group | level |
|---|---|---|---|---|---|---|---|
| `[[4,2,2]]`  |  4 | 2 | 2 | `Z_2^2 x Z_4`                        | `2^4`  | `Z_2^3`         | 2 |
| `[[8,3,2]]`  |  8 | 3 | 2 | `Z_2^3 x Z_4^3 x Z_8`                | `2^12` | `Z_2^7`         | 3 |
| `[[16,4,2]]` | 16 | 4 | 2 | `Z_2^4 x Z_4^6 x Z_8^4 x Z_16`       | `2^32` | `Z_2^15`        | 4 |
| `[[32,5,2]]` | 32 | 5 | 2 | `Z_2^5 x Z_4^10 x Z_8^10 x Z_16^5 x Z_32` | `2^80` | `Z_2^31`   | 5 |
| `[[7,1,3]]`  |  7 | 1 | 3 | `Z_2^3 x Z_4`                        | `2^5`  | `Z_4`           | 2 |
| `[[15,7,3]]` | 15 | 7 | 3 | `Z_2^10 x Z_4`                       | `2^12` | `Z_4 x Z_2^6`   | 2 |
| `[[15,1,3]]` | 15 | 1 | 3 | `Z_2^6 x Z_4^4 x Z_8`                | `2^17` | `Z_8`           | 3 |
| `[[31,1,3]]` | 31 | 1 | 3 | `Z_2^10 x Z_4^10 x Z_8^5 x Z_16`     | `2^49` | `Z_16`          | 4 |
| `[[9,1,3]]`  |  9 | 1 | 3 | `Z_2 x T^6`                          | `2` (torsion) | `Z_2`    | 1 |

Every entry was checked for the Eastin–Knill consistency condition: in each
case, every direction of the continuous part of `G` acts trivially on the
logicals, so the induced logical group is finite even for the Shor code, whose
`G` is not.

The Shor row is the only one with a positive-dimensional `G`: its transversal
diagonal group contains a six-torus, because each of the three blocks of three
qubits admits arbitrary phases subject only to three constraints, and all of
that continuous freedom is logically trivial.

## 6. Named-gate probes (method validation against known exact facts)

The driver independently tests specific named physical gates for membership and
reads off the induced logical gate. These are the calibration points; each row
is a statement already known in the qubit transversal-gate literature, and each
is reproduced exactly.

| code | physical gate | verdict | induced logical gate |
|---|---|---|---|
| `[[7,1,3]]`  | `T^{⊗7}`                        | **not** code-preserving | — |
| `[[7,1,3]]`  | `S^{⊗7}`                        | code-preserving | `S^{-1}` (level 2) |
| `[[7,1,3]]`  | `Z^{⊗7}`                        | code-preserving | `Z` (level 1) |
| `[[15,1,3]]` | `T^{⊗15}`                       | code-preserving | `T^{-1}` (level 3) |
| `[[15,1,3]]` | `P_16^{⊗15}` (`π/8` rotation)   | **not** code-preserving | — |
| `[[8,3,2]]`  | `T` on even / `T^{-1}` on odd vertices | code-preserving | exactly `CCZ`: `p = 4·y0y1y2` mod 8 (level 3) |
| `[[4,2,2]]`  | `S^{⊗4}`                        | code-preserving | `Z_0 Z_1 CZ` (level 2) |
| `[[4,2,2]]`  | `T^{⊗4}`                        | **not** code-preserving | — |
| `[[15,7,3]]` | `T^{⊗15}`                       | **not** code-preserving | — |

The `[[8,3,2]]` row is the sharpest calibration: the multilinear expansion of
the induced logical phase is the single monomial `4·y0y1y2` modulo 8, which is
`CCZ` on the nose, with no Pauli or Clifford dressing.

### Pushes beyond the calibration set

Three instances were then computed that no repository document classifies:

- **`[[16,4,2]]`.** The parity-alternating `π/8` rotation (`P_16` on
  even-parity vertices, `P_16^{-1}` on odd) is code-preserving and induces
  exactly `CCCZ`: `p = 8·y0y1y2y3` mod 16, hierarchy level 4. The plain
  parity-alternating `T` pattern is code-preserving but **logically trivial**
  here — the gate that works at `D=3` degenerates at `D=4`, and the rotation
  angle must halve with each increment of `D`.
- **`[[32,5,2]]`.** The parity-alternating `π/16` rotation induces exactly
  `C^4Z`: `p = 16·y0y1y2y3y4` mod 32, hierarchy level 5; the `π/8` pattern is
  logically trivial. Complete group `2^80`, logical group `Z_2^31`.
- **`[[31,1,3]]`.** The complete induced logical group is **exactly `Z_16`**,
  generated by the `π/8` rotation's logical inverse `P_16^{-1}`
  (`p = 15·y0` mod 16, hierarchy level 4). `T^{⊗31}` induces `T^{-1}`, and
  `P_32^{⊗31}` is not code-preserving. So this code's diagonal transversal
  logical group is not merely "at least level 4" — it is level 4 and nothing
  more.

## 7. Repository prior art consulted

Read in full from `notes/2026-07-31-results-summary-snapshot.md`:

- **"Symmetry reduction in exact quantum-code distance computation"** (the gross
  code `[[144,12,12]]` and passant `[78,36,12]_2` symmetry study). Prior art for
  *exact* CSS distance certification in this repository. Nothing in Section 4
  above competes with it: this task's instances are small enough that
  `css_distance_native` closes them directly, with no symmetry compilation.
- **"*Local-Unitary Rigidity and Quantitative Rounding for Stabilizer AME
  States*"**, its "Consequences", "Quantitative rigidity", "The Clebsch syndrome
  bridge" and "Corrections and boundaries" subsections. This is the repository's
  exact transversal-group result and it is **prior art, not a hunt result**: for
  odd prime `q`, generalized and extended generalized Reed–Solomon codes of even
  length `2m ≤ q+1` attain exactly the projective one-qudit Clifford group
  `F_q^2 ⋊ SL_2(q)`, the first case beyond six parties being
  `AME(8,7) ↔ [[7,1,4]]_7` with projective transversal group of order 16464;
  the generic off-conic locus has only the split torus `T`. That subsection also
  records the literature already credited at point of use, including
  **Anderson–Jochym-O'Connor for qubit diagonal and inter-code transversal
  restrictions** — which is exactly the theory Section 2 instantiates, so no
  novelty attaches to the *method* here, only to the specific exact groups in
  Section 5 that no repository document had computed.
- **"Quantum consequences beyond AME"** (the jet code `[[12,2,(6,4)]]_11` and
  the `q=13` resonance codes `[[14,4,4]]_13`, `[[14,2,(8,4)]]_13`). This section
  states an *open* repository question: whether the exact square/cube Schur
  algebra produces a transversal non-Clifford phase on the two jet qudits. That
  question is over `F_11`, so the qubit framework of Section 2 cannot address
  it; see Section 9.

Also consulted: `notes/open-problems/local-results-index.md` items 10–12 (the
quantum-information family), which route to the same AME/MDS–CSS result.

## 8. Crosswalk to the dossier's live targets

The dossier's live asymptotic target is good qLDPC — bounded check weight,
constant rate, **linear** distance — with a transversal non-Clifford gate.
Nothing computed here bears on it, and no claim below is asymptotic. What the
finite-size leg does supply is an exact, mechanism-level statement of *why* the
two classical qubit families that do carry high-level transversal gates are the
wrong starting point: the driver also computes the exact minimum possible
`X`-check weight (the minimum nonzero weight of `A`, which lower-bounds every
`X`-type stabilizer generator no matter how the generating set is chosen). In
the hypercube colour family `[[2^D,D,2]]` that minimum is `2^D = n` exactly, and
in the quantum Reed–Muller family `[[2^m-1,1,3]]` it is `2^{m-1} = (n+1)/2`
exactly. In both families the transversal hierarchy level rises with the
parameter (3, 4, 5 for `D = 3,4,5`; 3, 4 for `m = 4,5`), and in both the
minimum check weight rises **linearly in `n`** at the same time. So within this
catalogue the transversal level and the LDPC condition are exactly, not
heuristically, in tension. This is an observation about nine specific codes; it
is not a theorem about all families, and it does not weigh on whether the live
target is achievable.

## 9. Exact negatives, with domains

Each negative below is exhaustive over an explicitly stated domain.

1. **Steane `[[7,1,3]]` has no non-Clifford diagonal transversal gate at any
   phase.** Domain: all `θ ∈ (R/2πZ)^7`, i.e. every transversal product of
   single-qubit diagonal unitaries whatsoever, not just `T` or roots of unity.
   The complete group is `Z_2^3 x Z_4` of order 32 and its logical image is
   `Z_4 = ⟨S^{-1}⟩`. Level 2 is attained; level 3 is impossible.
2. **`[[15,7,3]]` likewise.** Same domain over `(R/2πZ)^15`; complete group
   `Z_2^10 x Z_4`, logical image `Z_4 x Z_2^6` of order 256, maximum level 2.
3. **Shor `[[9,1,3]]` has no non-Pauli diagonal transversal logical gate.**
   Domain: all of `(R/2πZ)^9`. The group is `Z_2 x T^6`; the six-torus is
   logically trivial and the induced logical group is `Z_2 = ⟨Z⟩`, level 1.
4. **`[[15,1,3]]` and `[[31,1,3]]` are level-exact, not merely level-bounded.**
   Their induced logical groups are exactly `Z_8` and exactly `Z_16`; no
   transversal diagonal gate on either code induces a logical gate of level 4
   (respectively 5) or higher.
5. **No result here bears on the Golowich–Guruswami or
   He–Vaikuntanathan–Wills–Zhang constructions.** Domain and stop condition:
   the dossier and `notes/open-problems/sources-quantum-information.md` were
   read in full; they record read depths `partial` (introduction, parameters,
   open problems) and `abstract/metadata only` respectively, and neither
   supplies a generator matrix or a smallest concrete instance. No web search
   was permitted for this task, and the repository contains no such matrices.
   Search stopped there.
6. **The repository's own open jet-code question is out of framework.** The
   snapshot's "Quantum consequences beyond AME" asks whether a transversal
   non-Clifford phase exists on the two logical qudits of `[[12,2,(6,4)]]_11`.
   The Section 2 framework is qubit-specific: the coset-constancy condition
   uses `F_2` addition and its carry structure, and the hierarchy-level formula
   uses 2-adic valuations. Extending it to `F_p` requires replacing the
   per-qubit two-parameter phase family by a `p`-parameter one and redoing the
   level calculus; that was not attempted and is not claimed. Recorded as the
   natural successor, not as a negative about the jet code.

## 10. Ergodis interface notes

- `css_distance_native` is a **good fit** for this problem class and needed no
  modification. The sparse `SparseProblem` schema (`label`,
  `coordinate_count`, `physical_checks`, `logical_observations`, `anchors`,
  `maximum_weight`, optional `incumbent_support`) maps onto a CSS code with no
  impedance: `physical_checks` takes the `X`-type stabilizer supports and
  `logical_observations` a completion of `A` to `B^⊥`, which is exactly the
  well-defined non-degenerate pairing that decides logical non-triviality.
- Passing every coordinate as an anchor is documented as always sound and is
  what the driver emits; no orbit analysis was needed at these sizes.
- Evidence output is create-only, so re-running a label requires a fresh
  `--evidence` path. This is the right default and cost nothing here.
- No core modification was required, and none is requested. One convenience
  gap, recorded but not acted on: there is no first-class "minimum nonzero
  weight of a linear code" mode, so the exact check-weight numbers in Section 8
  were computed in the driver by enumeration (sound because `dim A ≤ 5`
  throughout). A code with a large `A` would need either a
  `css_distance_native` encoding trick or a new entry point.
- The `css_distance_random` companion was **not** used: it is a witness finder,
  and every instance here was closed exactly by exhaustion, so an upper-bound
  pass would have added nothing.

## 11. Replay

Driver (new file, uncommitted per the campaign's ergodis-private rule):
`ergodis-private/src/bin/c1018_transversal_css.rs`.

```
cd ~/src/othello/ergodis-private
cargo build --release --bin c1018_transversal_css
./target/release/c1018_transversal_css \
    --distance-inputs ~/.cache/ergodis/c1018/inputs \
    > ~/.cache/ergodis/c1018/transversal-groups.txt

BIN=~/src/othello/papers/complete-repair-ports/ergodis/target/release/css_distance_native
for f in ~/.cache/ergodis/c1018/inputs/*.json; do
  b=$(basename $f .json)
  $BIN --input $f --evidence ~/.cache/ergodis/c1018/evidence/$b.jsonl
done
```

Single code, with the full logical phase tables:
`./target/release/c1018_transversal_css --only '[[31,1,3]]' --verbose-logical`.

Outputs: `~/.cache/ergodis/c1018/transversal-groups.txt` (group structures,
generators, probes), `~/.cache/ergodis/c1018/distance-summary.txt`,
`~/.cache/ergodis/c1018/evidence/*.jsonl`,
`~/.cache/ergodis/c1018/inputs/*.json`.

Independent replay of the transversal computation: the `[[4,2,2]]` case was
worked by hand before the driver was run. Its constraint matrix is the order-4
Hadamard matrix, whose Smith normal form has elementary divisors `1,2,2,4`,
giving `|G| = 16` and an order-4 generator `S^{⊗4}` — which is what the driver
prints. The nine distance values are independently checked against each code's
advertised parameters, including the asymmetric `(d_X,d_Z)` pairs.

## 12. Mystery ledger

| Feature | Status after the `ej`+`tt` pass | Evidence gap / owner |
|---|---|---|
| Why the hypercube family's working rotation angle halves at each `D` (`T^{±}` gives `CCZ` at `D=3` but is logically trivial at `D=4`) | **Settled**, and the mechanism is not what one would guess: the coarser rotation is still perfectly code-preserving at `D=4` and `D=5`, so it is not excluded by the constraint system at all — its induced logical phase function is simply identically zero. Only the finest rotation `2π/2^D` produces the single top monomial `2^{D-1}·y_0…y_{D-1}`. The probe lines in `transversal-groups.txt` record both halves. | closed |
| `[[15,7,3]]` shares its `A` with `[[15,1,3]]` yet is capped at level 2 while the latter reaches level 3 | **Settled**: the cap comes from `B`, not `A`. Enlarging `B^⊥` from dimension 5 to 11 adds coset-constancy rows, and those extra rows kill the `Z_8` factor. Same `X` stabilizers, strictly more constraints. | closed |
| Shor's code is the only member with a continuous transversal diagonal group (`T^6`) | **Settled and consistent**: all six torus directions act trivially on the logicals, so Eastin–Knill is not violated. The torus is the block-phase freedom of the three three-qubit blocks. | closed |
| Whether the exact tension between rising transversal level and rising minimum check weight is a theorem or an artifact of these two families | **Open.** Nine codes are not a family theorem, and the observation is stated in Section 8 only as a property of this catalogue. | Needs either a proof over a stated family class or a counterexample family; owner would be a successor task, not this one. |
| Whether the qudit `[[12,2,(6,4)]]_11` jet code carries a transversal non-Clifford phase | **Open, and out of this task's framework** (Section 9, item 6). | Requires an `F_p` generalization of the coset-constancy condition and the hierarchy-level calculus. |

No mystery is manufactured here: the first three rows were genuine surprises
during the run and all three closed against the computed generator data.

## 13. Vibe check

Good, and cleaner than expected. The framework turned out to be exactly
computable rather than search-based, so every number in Sections 4 and 5 is an
exhaustive exact value, every literature calibration point reproduced on the
nose, and three instances were classified that no repository document had. The
disappointment is structural and was foreseeable: the finite-size leg cannot
touch the dossier's live asymptotic target, and the check-weight tension in
Section 8 says the classical high-level families are the wrong seed for it.

**Status: complete**

