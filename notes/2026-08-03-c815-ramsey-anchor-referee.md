# Referee report: six-point Ramsey step and unconditional aligned-anchor existence

**Lane:** `clebsch`
**Date:** 2026-08-03
**Task:** C815

Scope: commit `c8b0610a`, whole-module audit of `lean/RelativeConicArcs/AlignedTwoGraph.lean`
(current file, 487 lines). No build was run; all conclusions are from the source text.

## Verdict

**ACCEPT WITH REPAIRS.** The three new declarations are mathematically correct and the
pigeonhole case analysis is exhaustive. The defects are in what the docstrings and module
header assert relative to what the types prove, in one cheap conclusion strengthening that
the proof already has in hand and discards, and in stale/inconsistent downstream ledgers.

## Findings, by severity

### 1. (Major, prose) "Ramsey's equality `R(3,3) = 6`" is proved nowhere; only `R(3,3) ≤ 6` is

`exists_monochromatic_triple` (line 131) proves: every `f : Fin 6 → Fin 6 → Bool` has
`i < j < k` with `f i j = f i k = f j k`. That is exactly the upper bound `R(3,3) ≤ 6`.
The equality additionally needs `R(3,3) > 5`, i.e. an exhibited triangle-free two-colouring
of the five-point complete graph (the pentagon/pentagram colouring). Nothing in the module
constructs it, and no such statement exists anywhere in the file.

The word "equality" appears in three places and must be repaired in all three:

- line 25 (module header): "Ramsey's equality `R(3,3) = 6` is derived from a pigeonhole step".
- line 122 (docstring of `exists_monochromatic_triple`): "Ramsey's equality `R(3,3) = 6`, in
  the form the anchor search uses".
- line 158 (docstring of `exists_alignedAnchor`): "the triple is produced by `R(3,3) = 6`".

Also the commit subject line. Correct wording: "the six-point half of Ramsey's theorem for
triangles, `R(3,3) ≤ 6`". Both manuscript uses need only this half — `sections/05-golden-operator.tex`
line 172 ("that two-colouring has no monochromatic triangle; ... gives `2d-1 ≤ 5`") is the
contrapositive of the upper bound, and lines 248 and 330 are direct applications of it — so
the repair costs the paper nothing.

Per `lean/AGENTS.md` "Comments and docstrings", a comment may not imply a stronger theorem
than Lean checks; this is the one hard violation in the change.

### 2. (Major, statement) The conclusions do not carry distinctness, so "four-set" is unearned

`exists_alignedAnchor` (line 160) concludes `∃ i j k : Fin 6, Aligned tau r (v i) (v j) (v k)`
with no ordering or distinctness on `i, j, k`, and no injectivity on `v` or condition
`r ∉ range v`. Its docstring (line 156) nevertheless says "an aligned four-set consisting of
the root and three of those points", and `alignedAnchor_of_ramseyTriple`'s docstring (line 99)
says "one of the twenty tested aligned four-sets". Neither statement mentions four points, a
set, or twenty of anything. As written, `v` constant satisfies the conclusion trivially.

The proof already produces the missing data and throws it away: line 164 destructures
`exists_monochromatic_triple`'s `i < j` and `j < k` into `_ _`. Repair (free): strengthen the
conclusion of `exists_alignedAnchor` to

```
∃ i j k : Fin 6, i < j ∧ j < k ∧ Aligned tau r (v i) (v j) (v k)
```

and pass `hij hjk` through instead of discarding them. That makes the "twenty unordered
triples" language in findings 3 and 5 truthful and gives the caller the distinctness the
manuscript's anchor four-set needs. Separation of `r` from the six points remains a caller
obligation and should be said so plainly in the docstring rather than asserted as "four-set".

The same "six points" phrasing in the header (lines 26-28) should say "six labelled points,
not assumed distinct" unless the conclusion is strengthened as above.

### 3. (Moderate, prose) "Deterministic anchor discovery" and the twenty-test bound are not witnessed

- Line 156, `exists_alignedAnchor` docstring, "Deterministic anchor discovery": the type is a
  bare existential. No function is defined, no uniqueness or canonical choice is proved, and no
  cost bound is stated. `lean/AGENTS.md` "Names" restricts strength-bearing descriptions to
  properties the type proves or an exact named theorem establishes. Say "Existence of an
  aligned four-set through the root on six labelled points"; the proof being choice-free is a
  separate fact to state only if the axiom audit shows it.
- Lines 479-482, `sixPointAnchor_testCount` docstring: "the anchor search of
  `exists_alignedAnchor` is bounded by twenty tests" attributes a search and a cost bound to a
  theorem that has neither, and `Nat.choose 6 3 = 20` counts unordered triples while the
  existential ranges over all 216 ordered triples (finding 2). The prior wording carried an
  explicit disclaimer ("it does not prove the Ramsey existence statement"); its replacement
  drops the limitation without adding a formal statement to justify the drop. Restate as: the
  identity counts the unordered triples of a six-element set, and no Lean declaration in this
  module formalizes a search procedure or its cost.

### 4. (Moderate, prose) Computationally discharged claims do not state their checking method

`lean/AGENTS.md` requires each computationally discharged claim to say whether checking is by
kernel reduction, a proved checker, or native evaluation, and what remains trusted. The new
header paragraph (lines 24-28) says only "derived from a pigeonhole step over the thirty-two
Boolean words". Both new `decide`s (lines 120, and the existing 484) are kernel reductions;
the two terminals at lines 212 and 242 are `native_decide` and therefore rest on the compiled
evaluator and its reduction axiom. This asymmetry is now load-bearing: the anchor route is
kernel-only and does not touch the native trust base, which is a real strengthening and should
be stated. The pre-existing header sentence "No generated data, external program, or unproved
mathematical axiom is used" (line 22) sits awkwardly next to two `native_decide` calls and,
under the no-grandfathering rule for a touched module, should be rewritten in the same change
to name the native evaluator explicitly as what is trusted for lines 212 and 242.

### 5. (Minor, prose) Artifact-history phrasing in the header

Line 24, "Anchor existence is proved here rather than imported", and line 101, "The triple is
produced without hypotheses in `exists_alignedAnchor`", describe a change of state of the
artifact rather than mathematics. The cross-declaration reference on line 101 is legitimate (a
formal dependency); the "rather than imported" contrast on line 24 is status prose and should
read "Anchor existence is proved in this module." No task IDs, lanes, sessions, paths, novelty,
or priority language appears anywhere in the change — those rules are met.

### 6. Mathematical verification (no defect found)

- `three_equal_of_five` (line 117): five Booleans, two values, so some value occurs at least
  three times and can be indexed increasingly. True; the docstring's "thirty-two Boolean words"
  (2^5) versus "colourings of the fifteen pairs" (2^15) is accurate.
- `exists_monochromatic_triple` (line 131): applies the pigeonhole to `g t = f 0 t.succ`, giving
  `a < b < c` in `Fin 5` with a common value `X` at `0`. Case `h1` returns `(0, A, B)`, case `h2`
  returns `(0, A, C)`, case `h3` returns `(0, B, C)`, and the final branch returns `(A, B, C)`.
  Each equality chain checks out, including `e3`, where `hga` is used to convert `!(f 0 B)` to
  `!(f 0 A)`. The four branches exhaust the truth values of the three decidable `by_cases`
  conditions; ordering obligations are discharged by `Fin.succ_pos` and `Fin.succ_lt_succ_iff`.
- Not vacuous, not weaker than it looks. Reading `f` only on increasing pairs is a genuine
  strengthening, not a loophole: the theorem quantifies over all `f`, so instantiating at a
  symmetric colouring recovers the classical statement verbatim, and conversely any `f`
  restricted to increasing pairs induces a symmetric colouring. The two forms are equivalent.
- `exists_alignedAnchor` (line 160) discharges `alignedAnchor_of_ramseyTriple`'s `hramsey`
  with no hidden assumption: instantiating at `fun s t => rootedEdge tau r (v s) (v t)` yields
  precisely the two required equalities in the same argument order the downstream lemma
  consumes. `FourSetParity` is the only hypothesis and is genuinely used.

### 7. Where the Lean proves more than the paper claims (wanted, not defects)

- No symmetry hypothesis on `tau`. The manuscript proof (`sections/05-golden-operator.tex`
  lines ~242-249) forms a graph `G_r` and implicitly uses a symmetric edge relation. The module
  never assumes permutation invariance of `tau` (line 36-37 records this explicitly), and the
  asymmetric-`f` form of the Ramsey step is exactly what lets the anchor argument go through
  without it. This should be stated in the docstring, since it is the substantive reason the
  increasing-pair reading was chosen.
- `α` is an arbitrary type and `v : Fin 6 → α` is unconstrained: no finiteness, no decidable
  equality, no injectivity. Wider than the paper's finite vertex set.
- The route is kernel-checked, so the anchor step does not enter the module's native-evaluation
  trust base (finding 4).
- Nothing in the change weakens or contradicts a manuscript claim. `alignedAnchor_of_ramseyTriple`
  is retained with an unchanged statement, so existing consumers and the pinned declaration list
  are not broken.

### 8. Cost and fragility of the `decide` at line 120

`revert g; decide` decides `∀ g : Fin 5 → Bool, ∃ a b c : Fin 5, ...` through the local
`Fintype.decidableForallFintype` instance (line 34), which forces the kernel to build and
traverse `Pi.fintype` for `Fin 5 → Bool` — a `Multiset.pi` construction over quotients — and
then, for each of 32 functions, to reduce a triple `Fintype.decidableExistsFintype` over 125
index triples. The search itself is small, but pi-type `Fintype` enumeration is the known
expensive part of kernel `decide`, and it is the part that is most sensitive to instance and
`Finset.pi` changes across toolchain bumps (pinned here at `leanprover/lean4:v4.32.0-rc1`).
Recommended structural replacement, cheap and strictly more robust: state the helper on five
explicit Booleans, e.g.

```
private theorem three_equal_of_five' (b₀ b₁ b₂ b₃ b₄ : Bool) : ...
```

proved by `decide` (32 flat cases, no pi-type `Fintype` reduction at all, no reliance on the
local instance), with a thin wrapper packaging it as the `Fin 5 → Bool` form. Alternatively use
`Finset.exists_lt_card_fiber_of_mul_lt_card_of_maps_to`-style pigeonhole for a fully structural
proof. Either way the kernel never materializes a function-space `Fintype`. The `decide` at
line 484 (`Nat.choose 6 3 = 20`) is trivial and fine.

Two lower-grade fragilities worth noting while the file is open: the four `simp_all` calls at
lines 146, 148, 151 run against the full local context (including `hab`, `hbc`, `hga`, `hgb`),
so they are simp-set-sensitive across Mathlib bumps; `omega`-free explicit `Bool` case reasoning
(`cases … <;> rfl` after `simp only [Bool.not_eq]`-style normalization) or `Bool.eq_not_of_ne`
would pin them. And the `obtain` at line 133 relies on the beta-reduced form of
`(fun t => f 0 t.succ) a` for the later `rw [e3', hga]` to match syntactically; this holds under
current elaboration but is worth a `simp only []`/`show` if the proof ever breaks after an update.

## Required follow-on ledger edits

The Lean-side facts to record: `RelativeConicArcs.AlignedTwoGraph.exists_monochromatic_triple`
and `RelativeConicArcs.AlignedTwoGraph.exists_alignedAnchor` now discharge, by kernel reduction,
the six-point half `R(3,3) ≤ 6` and the existence of an aligned four-set through a root on six
labelled points. Not the equality, and not the search cost.

1. `lean/RelativeConicArcs/Gates/ClebschPassages.lean`: add
   `#print axioms RelativeConicArcs.AlignedTwoGraph.exists_monochromatic_triple` and
   `#print axioms RelativeConicArcs.AlignedTwoGraph.exists_alignedAnchor` alongside the existing
   block at lines 59-71. Without this the two theorems are outside the lane's axiom audit and
   cannot back a paper claim. This regenerates `axiom_report_sha256`.
2. `papers/clebsch-passages/verification/passages_formal.json`:
   - line 20, `source_sha256["RelativeConicArcs/AlignedTwoGraph.lean"]`: currently
     `85eb4505…`, which is the content at commit `cfcf454a`. The file has drifted twice since —
     at `7c9ad84c` (prose edits) and again here — and the working-tree content now hashes to
     `38463e93172aeb53239aac39a40b39eaea67b7e4eb035337f00fd1989d0d8996`. Re-pin after the
     repairs above, not before.
   - `source_sha256["RelativeConicArcs/Gates/ClebschPassages.lean"]` (recorded `1978f4e8…`) is
     likewise stale; the current file hashes to
     `8d6431283299dbb56021e506feb487844f516c97090d749ada279fc3d305547c` and will change again
     with edit 1. Every other entry still matches, so this staleness is confined to the two files.
   - lines 5 and 7, `axiom_report_sha256` and `source_closure_sha256`: regenerate.
   - `audited_declarations` (lines 53-65 region): add both new fully qualified names.
   - `claim_map/OPER-4/declarations` (lines 139-151): add both names.
   - `claim_map/OPER-4/excluded` (line 160): currently "the classical Ramsey theorem,
     finite-set extension to a common seven-set, normalization from arbitrary labelled
     two-graphs to the cut API, and identification of the determinant-minus-three family with
     the aligned family remain human arguments". Delete "the classical Ramsey theorem," from
     the exclusion list; keep every other item. Do not replace it with a claim covering the
     equality.
   - `claim_map/OPER-3/excluded` (line 134): "higher-order Ramsey exclusion" stays excluded —
     that is the `2d-1 ≤ 5` inclusion-rank argument, of which only the `R(3,3) ≤ 6` input is now
     formal. No change, or at most a clause noting the six-point input is Lean-checked while the
     surrounding exclusion argument is not.
   - `trust_boundary/excluded` (line 185): drop "classical Ramsey" from "the classical Ramsey
     and finite-set normalization inputs"; leave the finite-set normalization exclusion.
3. `papers/clebsch-passages/verification/trust_manifest.json`:
   - line 14, `formal_coverage/boundary`: add the six-point anchor-existence mechanism to the
     list of what Lean proves.
   - line 187, `claims[6].proof_role`: "while the classical Ramsey theorem, finite-set
     extension, and arbitrary-label normalization remain human inputs" — remove "the classical
     Ramsey theorem," and add anchor existence to the Lean-checked list. The finite-set
     extension and arbitrary-label normalization remain human.
   - line 162, `claims[5].proof_role`: it credits "the Ramsey equality R(3,3)=6" as part of the
     human proof for the order-six converse. Change only to say the six-point input is now
     Lean-checked; the surrounding inclusion-rank argument stays human.
   - line 177, `claims[6].clauses[2]`, "quadratic selected-determinant decoder and deterministic
     anchor search": unchanged in substance, but nothing formal backs "deterministic … search";
     if it is edited, keep the determinism attributed to the human proof (finding 3).
4. `papers/clebsch-passages/sections/08-verification.tex`, the sentence beginning "The classical
   Ramsey input \(R(3,3)=6\), finite-set extension to seven vertices, and the passage from
   arbitrary labels to the normalized cut coordinates remain human combinatorial steps" (around
   line 40): the Ramsey clause is now false and must move into the Lean-checked list two
   sentences earlier, phrased as the six-point half. The other two steps stay human.
5. `papers/clebsch-passages/literature-boundaries.md`, row `OPER-4`: the attribution of
   `R(3,3)=6` as a classical result **must not change**. Formalizing a classical theorem confers
   no priority, and `lean/AGENTS.md` forbids turning a formal implication into a historical
   claim. The only admissible edit is in the row's "Mathematical and evidence status" column,
   where "`R(3,3)=6` … remain classical inputs" may be refined to note that the six-point half
   is now kernel-checked in Lean while remaining classical in attribution. The "Established
   literature boundary" and "Paper-owned content" columns stay exactly as they are, and the
   `OPER-3` row needs no edit.
6. Ordering: land the finding 1-5 source repairs first, then edit 1, then rebuild the gate and
   regenerate all three hashes in one window. Re-pinning the hashes before the prose repairs
   would pin content that this report rejects.
