# C834 independent referee review of the association-transport round (2026-08-04)

**Lane:** `clebsch` (Paper IV). Read-only review; no Lean build, `lake`, or elaboration was run
(the shared build-owner lock is held by another lane's q16 certificate gate). Everything below is
either (a) verified by independent computation, (b) verified by reading source, or (c) reasoned
about and explicitly marked as such.

Scratch scripts used for the independent checks live outside the repository at
`/tmp/claude-1000/-home-tavis-src-othello-rust/5f30a8cf-2885-4666-aab2-20d603ba84f4/scratchpad/`
(`indep_check.py`, `orbits.py`). They are reproduced in outline in sections D and "Structural
reductions" below and can be rewritten from those descriptions.

## Verdict

**Is today's round sound?** Yes, as far as reading and independent computation can establish. The
consumed statements are unchanged, the mask/semantic bridge is genuine and non-circular, and every
one of the nine mathematical identities plus the four committed relation tables and four committed
orbit column tables reproduce exactly from the Lean definitions when recomputed from scratch
without the tracked generator. I found no soundness hole in `PackedRows`; the one place where a
missing length hypothesis *would* be unsound (`maskMatrix_maskXor`) has the hypothesis, and the one
place where a length hypothesis is *absent* (`maskMatrix_maskProduct` on the left factor) is
genuinely not needed because both sides degrade to zero rows together.

**Will it elaborate?** Probably, with one substantial reservation and several small ones. Every
Mathlib and core lemma name used is real in Lean v4.32.0-rc1 and its Mathlib, and I checked the
statements of the load-bearing ones. The reservation is not about names: it is that the four
relation-mask identifications are the first place in this package where `rhoAt` — and therefore a
`ZMod 13` inverse computed through `Nat.gcdA`/`Nat.xgcdAux`/`Nat.strongRec` — is evaluated by the
kernel thousands of times. I established that the kernel *can* reduce a `ZMod 13` inverse (the
already-elaborated `RelativeConicArcs.PassantCodeQ13.WeightEight.vertexTriple_internal` reduces
`normalizeTriple`, which inverts), so this is a cost question rather than a feasibility question,
but it is a large cost question.

**Is the memory estimate right?** No. Today's report names the orbit-column comparison as "the
largest single check in the packet and the one most likely to need a further split". By my
independent estimate that is the *second cheapest* of the eight new leaves — about 610,000 kernel
steps, all on numerals. The four relation-mask identifications, each evaluating `rhoAt` 6084 times
with two coordinate-list scans and a well-founded modular inverse per evaluation, are the ones at
risk, by roughly an order of magnitude. See section C.

**Is the remaining plan credible?** Mostly, but it is missing a large adjacent win and it
understates one risk. The missing win: three of the "remaining" native decisions — the whole
association-algebra group — are now nearly free, because `PassantCodeQ13.AssociationAlgebra` proves
*the same three identities* by `native_decide` in a mask representation that today's round has
already reduced. The understated risk: `WeightTen/Aggregate.lean` kernel-reduces `List.mergeSort`
over 595 encoded pairs, and `MinimumWords/Exhaustion.lean` uses `eraseDups`/`toFinset`; those are
well-founded or quadratic core operations and are a second cliff candidate alongside the fixed-point
exhaustion.

**Blocking defect, unrelated to the mathematics:** commit `919f5b7a` leaves the paper's own evidence
verifier failing. I ran it. See section G.

---

## Findings by severity

### 1. (High, confirmed by running it) The paper's evidence verifier fails on the committed tree

`papers/q13-passant-code/verification/verify_evidence.py` aborts:

```
AssertionError: .../lean-certificates/PassantCodeQ13/StructuralUpgrade.lean
```

`verification/evidence_manifest.json` pins `StructuralUpgrade.lean` at 5211 bytes and
`Gates/AxiomAudit.lean` at 6456 bytes; the committed files are 5430 and 7484 bytes. The verifier
asserts on size before it ever reaches the digest, so a full checkout of this paper currently has a
red evidence gate. This is not a "manifest debt to refresh later" — it is a regression introduced
by the same commit, and by the repository's own reproducibility conventions the manifest refresh
belonged in that commit. Recommended action: refresh both records and re-run the verifier before
any further Lean work; details of the other manifest gaps are in section G.

### 2. (High) Three native decisions in the association algebra are now redundant and were not taken

`PassantCodeQ13/AssociationAlgebra.lean` lines 53–72 prove, by `native_decide`:

- `relation_matrix_ranks` — `binaryRank (relationMatrix v)` equals 42, 36, 36, 36;
- `rhoZero_square` — `matrixProduct (relationMatrix 0) (relationMatrix 0) = xorFour identityMatrix (relationMatrix 9) (relationMatrix 10) (relationMatrix 12)`;
- `rankThirtySix_squaring_cycle` — the three squaring identities.

`relationMatrix value` (line 31) is *exactly* the row-mask presentation today's round introduced:
`(List.range 78).map (relationRow value)`, where `relationRow` folds `|||` over set bits. So these
three theorems are the same mathematics as `rhoZero_square_parity_certificate`,
`rhoNine/Ten/Twelve_square_parity_certificate` in a parallel representation, and today's round left
them native. The route to remove all three:

1. Four leaves `relationMatrix v = relationRowsRho<V>` (`List Nat` equality; cost is the same 6084
   `rhoAt` evaluations already paid by the identification modules, so this is not a new cost class —
   and if the mask identifications are re-routed through `relationMatrix` it is not even a new
   check).
2. One symbolic bridge `matrixProduct left right = maskProduct left right` for lists of length 78,
   provable with the same `testBit`-of-fold induction already written in `PackedRows`
   (`testBit_selectedRowXor` is 80% of it), and `xorFour a b c d = maskXor a (maskXor b (maskXor c d))`,
   which is `rfl`-adjacent.
3. `binaryRank` on displayed masks is already kernel-reduced elsewhere in the package
   (`PassantCodeQ13.MinimumWords.orbitS4_rank` at `MinimumWords/OrbitS4.lean:29–31` uses
   `decide +kernel` on `binaryRank` of a 91-mask list), so `relation_matrix_ranks` follows from step 1
   with a `decide +kernel` of the same shape.

This is the cheapest three-native-decision removal available anywhere in the remaining plan and it
should be done in the same build window as the elaboration, not scheduled as a separate packet.

### 3. (High) `AssociationTransport.lean`'s header makes a false claim about its import closure

`papers/q13-passant-code/lean-certificates/PassantCodeQ13/AssociationTransport.lean:15`:

> Neither this aggregator nor any module it imports uses native evaluation.

That is false. `AssociationTransport.lean` imports `RelationSquares` → `RelationMasks` →
`PackedRows` → `AssociationTransport/Base.lean`, whose first line is
`import PassantCodeQ13.AssociationAlgebra` — the module in finding 2, which contains three
`native_decide` proofs. Under `lean/CLAUDE.md`'s rule that a module header must "disclose any
`sorry`, axiom, opaque oracle, or non-kernel execution in the dependency closure", and that comments
must agree with the elaborated statement, this is a review-gate violation in a module changed today.
It becomes true once finding 2 is executed; until then the sentence must be narrowed to the modules
it actually covers (for example, "no module under `AssociationTransport/` uses native evaluation").

### 4. (Medium-high, reasoned) The four relation-mask identifications are the memory risk, not the orbit columns

See section C for the arithmetic. Summary: each of
`AssociationTransport/RelationMasks/{RhoZero,Nine,Ten,Twelve}.lean` evaluates
`relationBooleanMatrix v` at all 6084 ordered pairs; each evaluation calls `rhoAt`, which performs
two `internalCoordinateList.getD` scans (the list is itself a `filter` over the 183-element
`projectiveTripleList`) and one `ZMod 13` inversion through `Nat.gcdA`. My estimate is 1.6M kernel
steps in the most favourable caching assumption and 5–15M in the unfavourable one, against a measured
per-module ceiling of roughly one million. The orbit-column identifications, by contrast, are pure
numeral work: 7098 entries, two positional list reads each, about 610K steps, comfortably inside the
guard.

**Recommended action, in preference order.** (a) Remove the inversion from the checked predicate.
`rho u v = value` is equivalent to `polarValue u v ^ 2 = value * pointDiscriminant u * pointDiscriminant v`
whenever both discriminants are nonzero, which holds for every internal coordinate by the definition
of `internalCoordinateList`. A short symbolic lemma turns the 6084 modular inversions into 6084
multiplications and should bring a relation module to roughly 700K steps with no split at all.
(b) Additionally replace the `internalCoordinateList.getD` scans with a displayed 78-triple table
identified once by kernel reduction — this is precisely lever one from the task card
("`internalIndex`, `incidentAt`, `rhoAt` … the scan itself is what exhausts the guard"), and today's
round is the first packet to leave `rhoAt` unpacked. (c) Failing both, plan a four-way row split of
each relation module (rows 0–19, 20–39, 40–59, 60–77) up front, giving sixteen leaf modules plus four
concatenation lemmas, rather than discovering the need after four failed builds.

### 5. (Medium) `PackedRows`'s header misdescribes its own hypotheses

`AssociationTransport/PackedRows.lean:16`:

> The hypotheses are exactly the length conditions making the mask lists describe matrices on the
> stated index types: a mask list shorter than its row count would silently read the zero row.

`maskMatrix_maskProduct` (line 174) constrains only `right.length = middleCard`. There is no
hypothesis on `left`, and none is needed: a short `left` makes both `maskMatrix left` and
`maskMatrix (maskProduct left right)` read zero rows at the same indices, so the identity survives.
The docstring as written suggests a stronger hypothesis set than the theorem has and would mislead a
referee auditing the trust boundary. It should say that the right-hand length is the one that
matters, and why (the mask evaluation iterates the list while `booleanParityProduct` iterates
`Fin middleCard`, so a short right list silently drops middle indices — that *is* the unsound case,
and it is guarded).

### 6. (Medium) Strength overclaim: "irreducible cubic" and "on its image"

`AssociationTransport/RelationCubic.lean:5` (module header, "The cubic satisfied by the rho-nine
relation operator on its image") and line 40 (docstring of `rhoNine_quartic_vanishes`: "satisfies the
hidden irreducible cubic on its image"). The elaborated statement is
`relationLinearMatrix 9 ^ 4 + relationLinearMatrix 9 ^ 3 + relationLinearMatrix 9 = 0` — a quartic
identity on the whole ambient 78-dimensional space. Nothing in the module proves irreducibility of
`t³ + t² + 1` over the binary field, and nothing restricts to an image. `lean/CLAUDE.md` permits a
strength-bearing word only when the declaration's type proves the property or its docstring points to
an exact Lean theorem that does. Recommended action: state the quartic identity plainly and, if the
cubic-on-the-image reading is wanted, cite the exact downstream declaration that establishes it.
The same overclaim is baked into the pre-existing name
`PassantCodeQ13.StructuralUpgrade.hiddenField_cubic_on_image`; since `StructuralUpgrade.lean` was
touched today the no-grandfathering clause of the review gate puts it in scope, though renaming a
gate-consumed theorem is a larger change and may be better scheduled explicitly.

### 7. (Medium) `StructuralUpgrade.lean`'s header does not disclose native evaluation

`StructuralUpgrade.lean:8–14` says the module "checks the bounded q=13 inputs that are small enough
to evaluate directly in Lean" and lists them. Eight of those checks are `native_decide`. The review
gate requires each computationally discharged claim to state whether checking is by kernel
reduction, a proved checker, native evaluation, an imported certificate, or an axiom. "Evaluate
directly in Lean" does not distinguish the two, and the module now contains one inherited
kernel-reduced result alongside eight native ones, which makes the ambiguity worse rather than
better. Recommended action: name the native leaves explicitly in the header, as
`AssociationTransport/*` modules do for their kernel leaves.

### 8. (Low-medium) The three dihedral orbits are distinguished only by an arbitrary letter

`AssociationTransport/OrbitMasks/{DihedralA,DihedralB,DihedralC}.lean`, the matching `OrbitDihedral*`
modules, and the generated docstrings in `RelationData.lean` ("the first / second / third orbit with
a dihedral stabilizer of order 24") identify their subject by an index with no mathematical content.
A referee cannot tell which orbit is which. There is a ready invariant that separates them, and I
verified it: the Gram matrix of the symmetric-stabilizer orbit and of dihedral orbit A is the
relation of polar invariant 9, of dihedral orbit B is the relation of polar invariant 12, and of
dihedral orbit C is the relation of polar invariant 10. Recommended action: state that invariant in
each module header and in the generator's docstring table, so the letters become labels attached to
a stated distinguishing property rather than the only description. (The letters themselves predate
this round and renaming is optional; the docstrings are the fixable part.)

### 9. (Low) Nothing else found

Specifically, and briefly, because these are the things a referee is obliged to check and they are
fine: no `sorry`, no new `axiom`, no `native_decide` anywhere under `AssociationTransport/`, no
task ID, lane name, agent, session, date, or internal-note reference in any new or modified Lean
source; the generated `RelationData.lean` identifies itself as generated, names its generator, and
describes the semantic data it encodes; every new leaf's docstring states that the check is
exhaustive, names its finite domain, and says it is discharged by kernel reduction; the pre-existing
`check_association_transport_statements.py` still passes on the new sources (I ran it: 0 failures),
and `generate_association_transport_data.py --check` passes (I ran it).

---

## A. Soundness of today's rewrite

**Statements consumed downstream are unchanged.** I diffed the commit. `AssociationTransport.lean`
changed only in its module header; `every_minimum_orbit_spans_rhoZero_kernel` (lines 73–85) has the
same four-conjunct statement, `Gates/Main.lean:108–127` consumes it verbatim, and
`StructuralUpgrade.hiddenField_cubic_on_image` (line 77) has the identical
`let B := relationLinearMatrix 9; B ^ 4 + B ^ 3 + B = 0` statement with only the proof body replaced
by `intro B; exact rhoNine_quartic_vanishes`. No hypothesis was added to any consumed theorem.
`Gates/AxiomAudit.lean` gained ten `#print axioms` lines and removed none; I checked that every name
it prints still exists after the removal of `orbitS4_boolean_certificate` and its siblings, so the
audit module will not fail on a dangling name.

**The mask/semantic bridge is real and the length side conditions are the right ones.**
`maskMatrix_maskProduct` (PackedRows:174) states
`maskMatrix (maskProduct left right) = booleanParityProduct (maskMatrix left) (maskMatrix right)`
on `Fin rowCard × Fin columnCard` with middle `Fin middleCard`, under `right.length = middleCard`.
That hypothesis is exactly the dangerous one: `selectedRowXor` iterates the right list, while
`booleanParityProduct` iterates `Fin middleCard`, so a right list shorter than `middleCard` would
make the mask side drop middle indices and could prove a false product identity. It is present, and
in every use site it is discharged by a `rfl` length lemma on the actual displayed list
(`relationRowsRho*_length = 78`, `orbitSymmetricSupports_length = 91`,
`orbitSymmetricColumns_length = 78`). The absence of a hypothesis on `left.length` is safe, as
argued in finding 5. `maskMatrix_maskXor` (line 189) *does* carry `left.length = right.length`, and
must: `List.zipWith` truncates, so without it a long left list would disagree with `maskMatrix left`
beyond the truncation point. Every call site supplies it, chaining `rfl` length lemmas
(`RelationSquares/RhoZero.lean:39–51` builds the nested lengths explicitly).

**The displayed masks are checked against the semantic objects, with no gap and no circularity.**
Traced for one relation and one orbit:

*Relation, polar invariant zero.* `RelationMasks/RhoZero.lean:16` checks
`booleanMatrixEqualityCheck (maskMatrix relationRowsRhoZero) (relationBooleanMatrix 0) = true` by
`decide +kernel`, over the full `Fin 78 × Fin 78`. `booleanMatrixEqualityCheck_sound`
(`AssociationTransport/Base.lean:105`) converts a successful check into extensional matrix equality —
its proof is `ext` plus `List.forall_mem_ofFn_iff` plus `eq_of_beq`, which is sound and complete over
the full index product, not a sampled one. `relationBooleanMatrix` (Base:74) is
`row != column && rhoAt row.1 column.1 == value`, and `rhoAt`
(`PassantCodeQ13/AssociationAlgebra.lean:20`) is `polarValue u v ^ 2 * (Q u * Q v)⁻¹` at
`u = internalAt row`, `v = internalAt column`, with `internalAt` (`WeightTen/Base.lean:21`) the
positional read of `internalCoordinateList` from the shared library. So the chain from the displayed
literal to the shared library's `polarValue` and `pointDiscriminant` is complete, with no trusted
step.

*Orbit, symmetric stabilizer.* `OrbitMasks/Symmetric.lean:19` checks the displayed column masks
against `(maskMatrix orbitSymmetricSupports).transpose`. That looks circular at first reading —
generated data compared with generated data — but it is not: `orbitSymmetricSupports` is not new. It
lives in `MinimumWords/OrbitData.lean:16` and is tied to the semantic orbit by the pre-existing
kernel-reduced `MinimumWords.supportOrbit_representativeS4_eq`
(`MinimumWords/OrbitS4.lean:16–19`), which `OrbitS4.lean:32` invokes, followed by
`orbitSupportBooleanMatrix_eq_maskMatrix` (`PackedRows.lean:29`, `rfl` — the semantic support matrix
is definitionally the mask matrix of the displayed orbit). So the new column masks are anchored to an
object that was already anchored. No leaf is checked against itself.

**The cubic derivation is valid.** `RelationCubic.lean:42–58`. `square : A9 ^ 2 = A10` via `pow_two`
and `rhoNine_square_parity_certificate` (whose statement is literally
`relationLinearMatrix 9 * relationLinearMatrix 9 = relationLinearMatrix 10`, so the `exact` matches).
`cube : A9 ^ 3 = A12 + A9` by rewriting `3 = 2 + 1`, `pow_add`, `pow_one`, then `square`, reducing to
`rhoTen_rhoNine_product_parity_certificate`. `quartic : A9 ^ 4 = A12` by `4 = 2 + 2`, `pow_add`,
`square`, reducing to `rhoTen_square_parity_certificate`, whose statement is
`relationLinearMatrix 10 * relationLinearMatrix 10 = relationLinearMatrix 12` — correct. The closing
step is `A12 + (A12 + A9) + A9 = (A12 + A12) + (A9 + A9) = 0` by `abel` then `addSelf_eq_zero` twice.
`addSelf_eq_zero` (line 34) is `ext row column; simpa using doubling (matrix row column)` with
`doubling : ∀ v : ZMod 2, v + v = 0 := by decide` — that is a two-element `decide`, entirely
legitimate, and `Matrix.add_apply` is what `simpa` needs. I recomputed `B⁴ + B³ + B = 0` directly
on the recomputed relation matrices (section D) and it holds.

**No new axiom or opaque assumption.** All eight leaves are `decide +kernel`; the two symbolic
modules (`PackedRows`, `RelationCubic`) contain no `decide` except the two-element `doubling` and
`booleanMatrix_xor`'s `one_add_one`. Nothing imports a certificate file.

## B. Elaboration risk, ranked

I could not build. This section is reasoning plus name-checking against the on-disk Lean v4.32.0-rc1
core (`~/.elan/toolchains/leanprover--lean4---v4.32.0-rc1/src/lean`) and the pinned Mathlib
(`lean/.lake/packages/mathlib`).

**Names: all real, statements checked where load-bearing.** `Nat.testBit_xor`
(`Init/Data/Nat/Bitwise/Lemmas.lean:635`, `@[simp]`, `(x ^^^ y).testBit i = (x.testBit i ^^ y.testBit i)`);
`Nat.zero_testBit` (same file line 89, `@[simp]`); `List.ofFn_succ` (`Init/Data/List/OfFn.lean:81`,
`@[simp]`, `ofFn f = f 0 :: ofFn fun i => f i.succ`); `List.getD_cons_zero` and
`List.getD_cons_succ` (`Init/Data/List/Lemmas.lean:347–348`); `List.eq_nil_of_length_eq_zero`
(same file line 104); `Fin.val_succ` (`Init/Data/Fin/Lemmas.lean:403`, `@[simp]`);
`List.length_zipWith` (`Init/Data/List/Nat/TakeDrop.lean:588`, `@[simp]`, RHS `min (length l₁) (length l₂)`,
which is exactly what `maskXor_length` claims); `List.forall_mem_ofFn_iff`
(`Mathlib/Data/List/OfFn.lean:104`); `pow_two`, `pow_add`, `abel` all standard. I found no
non-existent name.

Ranked residual risks:

1. **Kernel cost of `rhoAt`, and of the `ZMod 13` inverse in particular** (highest). `ZMod.inv`
   (`Mathlib/Data/ZMod/Basic.lean:711–716`) is `Nat.gcdA i.val 13`, and `Nat.gcdA` goes through
   `Nat.xgcdAux` (`Mathlib/Data/Int/GCD.lean:43–48`), defined by `Nat.strongRec` — well-founded
   recursion, the classic case of "does not reduce by `rfl`". I resolved the feasibility question in
   the affirmative by finding an already-elaborated kernel leaf that inverts:
   `RelativeConicArcs.PassantCodeQ13.WeightEight.vertexTriple_internal`
   (`lean/RelativeConicArcs/PassantCodeQ13/WeightEight.lean:66–68`, `decide +kernel`) evaluates
   `cyclicAction` iterates, and `cyclicAction` calls `normalizeTriple`, which uses `point.x⁻¹` in
   `ZMod 13`. So the kernel reduces these. What is unknown is the per-call cost, and today's round
   asks for 24,336 of them (6084 in each of four modules). That is the elaboration risk that matters.
2. **`simp only` firing order in `parity_ofFn_eq_selectedBitParity`** (PackedRows:145–163). The
   proof rewrites `List.length_cons` to expose `Fin (rest.length + 1)`, then `List.ofFn_succ`, then
   uses a local `shift : ∀ index, start + (index + 1) = start + 1 + index` as a simp lemma to
   renormalize the index arithmetic so the induction hypothesis at `start + 1` applies syntactically.
   I walked the rewrite by hand and it lines up: `f 0` becomes `selector.testBit start && row.testBit column`
   via `Fin.val_zero`, `Nat.add_zero`, `List.getD_cons_zero`, and the tail becomes the IH instance via
   `Fin.val_succ`, `List.getD_cons_succ`, and `shift`. The risk is that a `simp only` step normalizes
   `start + (i + 1)` to something other than the `shift` left-hand side before `shift` fires, in which
   case the subsequent `rw [inductionHypothesis (start + 1)]` will not match. This is the single
   most likely place for a first-build failure, and it is a five-minute fix (`omega`-closed `conv`
   or an explicit `congr` on the `ofFn` body) rather than a design problem.
3. **`show` steps.** Two of them (`maskMatrix_maskProduct:181`, `maskMatrix_maskXor:194`,
   `maskMatrix_replicate_zero:211`). I checked each is definitionally correct by unfolding
   `maskMatrix`, `booleanParityProduct`, and `Matrix` application: `maskMatrix` and
   `booleanParityProduct` are plain `fun row column => …` definitions with no `Matrix.of` wrapper, so
   `ext` leaves goals in exactly the shown form. Low risk.
4. **`intro B; exact rhoNine_quartic_vanishes` on a `let`-goal** (`StructuralUpgrade.lean:80–81`).
   `intro` on `let B := e; body` introduces a let-bound local, and `exact` must zeta-unfold it during
   the definitional check. This normally works; if it does not, `show relationLinearMatrix 9 ^ 4 + … = 0`
   fixes it. Low risk, trivial fix.
5. **`simp only [orbitSupportMatrix, relationLinearMatrix, supports]` under a `let` binder**
   (`OrbitS4.lean:34`, and identically in the three dihedral modules). The goal is
   `let N := …; P ∧ Q`; `simp only` zeta-reduces by default, and `AssociationTransport.lean:99`
   defensively `dsimp only at` the four hypotheses afterwards, so the two sides should agree. Low
   risk.
6. **`rw [show (3 : Nat) = 2 + 1 from rfl]`** (`RelationCubic.lean:48`, and `4 = 2 + 2` at line 51).
   These rewrite a numeral occurring in the goal. There is no other `3` or `4` in the respective
   goals, so no accidental capture. Low risk.
7. **`getD_maskXor`'s nil case** (PackedRows:102): `List.eq_nil_of_length_eq_zero lengths.symm`
   supplies `right.length = List.length []` where `right.length = 0` is expected. The unifier must
   reduce `List.length []` to `0`, which it will. Very low risk.

Nothing in `PackedRows` needs an induction motive that will not generalize: every induction is
`intro rows; induction rows` with the remaining universally quantified variable (`start` or `index`)
still in the goal, so the induction hypotheses come out at the needed generality. `maskMatrix`'s
implicit `rowCard`/`columnCard` are always fixed by a type ascription at the use site
(`: Matrix Coordinate Coordinate Bool`, `: Matrix Coordinate OrbitCoordinate Bool`), so inference is
not left to guess.

## C. Memory guard: independent cost estimate

Per-module estimates, counting kernel head-reduction steps, against the task card's measured ceiling
of roughly one million on the `single` profile. `Nat` bit operations on numerals are GMP-accelerated
in the kernel and counted as ~1; list traversals are counted per cons cell.

| leaf | domain | dominant per-item cost | estimate | verdict |
|---|---|---|---|---|
| `relationRowsRho*_entry_certificate` (×4)  | 6084 entries | `getD` 78-list (~39) + two `internalAt` scans + `polarValue` + one `ZMod 13` inverse | 1.6M optimistic, 5–15M pessimistic | **over the guard; act before building** |
| `identityMasks_entry_certificate`          | 6084 entries | `getD` over `(range 78).map` (~39) + shift + `Fin` decEq | ~275K | fits |
| `orbit*Columns_entry_certificate` (×4)     | 7098 entries | `getD` 78-list (~39) + `getD` 91-list (~45) + 2 `testBit` | ~610K | fits |
| `rhoZero_square_entry_certificate`         | 6084 XOR steps + 3×78 `maskXor` | numerals only | <20K | fits easily |
| `rho{Nine,Ten,Twelve}_square_entry_certificate` | 6084 XOR steps | numerals only | <10K | fits easily |
| `rhoTen_rhoNine_product_entry_certificate` | 6084 XOR steps + 78 `maskXor` | numerals only | <10K | fits easily |
| `orbit*_entry_certificate` (×4)            | 7098 + 6084 XOR steps | numerals only | <20K | fits easily |

Two conclusions that differ from today's report.

**The orbit-column comparison does not need a split.** At about 610K numeral steps it is inside the
guard with margin, and it is roughly a twentieth of the cost of a relation identification. Today's
report singles it out as "the largest single check in the packet and the one most likely to need a
further split into index blocks". That is the wrong target.

**The relation identifications need attention before, not after, the first build.** The cheapest fix
is to eliminate the modular inverse from the checked predicate (finding 4a): `rho u v = value` is
equivalent to `polarValue u v ^ 2 = value * Q u * Q v` for internal points, whose discriminants are
nonzero by construction. That is one short symbolic lemma and it removes 6084 well-founded-recursion
unfoldings per module. Combined with a displayed 78-triple table replacing the
`internalCoordinateList` scans, a relation module should land near 200–400K steps and need no split.
If neither is done, plan on four blocks of about twenty rows each per relation — sixteen leaf
modules — and expect the block boundaries to be re-tuned after the first measurement.

I want to be clear that these are estimates from reading, not measurements. The one number I would
most want from the next build window is the measured peak of a single relation-mask module, because
it calibrates every remaining `rhoAt`-touching leaf in the package.

## D. Independent check of the mathematics — everything reproduces

I wrote a script that does not import `generate_association_transport_data.py` or
`generate_minimum_word_orbits.py`, and rebuilds the objects from the Lean definitions:
`projectiveTripleList` as the 169 affine triples `(1,y,z)` in `y`-outer order, then the thirteen
`(0,1,z)`, then `(0,0,1)`; `pointDiscriminant p = y² − xz`; internal points as those with nonzero
non-square discriminant (squares mod 13 being `{1,3,4,9,10,12}`); `polarValue u v = 2u_yv_y − u_xv_z − u_zv_x`;
`rho u v = polarValue² · (Q u · Q v)⁻¹`. It then parses the committed literals out of
`AssociationTransport/RelationData.lean` and `MinimumWords/OrbitData.lean` with a regular expression
and compares.

Every check passes. Specifically:

- the internal-point enumeration has exactly 78 members;
- each of `relationRowsRhoZero`, `relationRowsRhoNine`, `relationRowsRhoTen`,
  `relationRowsRhoTwelve` equals the independently recomputed adjacency matrix of its relation,
  entry for entry, has length 78, and has no bit set at or above position 78;
- the three squaring identities `A9² = A10`, `A10² = A12`, `A12² = A9` hold;
- `A0² = I + A9 + A10 + A12` holds;
- `A10 · A9 = A12 + A9` holds;
- each of the four `orbit*Columns` literals is exactly the transpose of the corresponding committed
  `orbit*Supports` list (91 supports, each of Hamming weight 12), so the Lean transpose orientation
  in `OrbitMasks/*.lean` is the correct one and not accidentally swapped;
- each orbit's Gram product `columnsᵀ · supports` equals the stated relation — polar invariant 9 for
  the symmetric-stabilizer orbit and for dihedral orbit A, 12 for dihedral orbit B, 10 for dihedral
  orbit C, matching the `orbit*_Gram_and_kernel` statements and the `relationLinearMatrix` arguments
  threaded through `every_minimum_orbit_spans_rhoZero_kernel`;
- `A0 · columns = 0` for all four orbits, so every orbit row lies in the rho-zero kernel;
- `B⁴ + B³ + B = 0` for `B = A9`, computed directly rather than inferred from the squaring
  identities.

I also verified independently that the argument permutation in
`AssociationTransport.lean:101–112` is right: the module feeds `orbitSpansKernel` the triple
`(B, B², B⁴)` as `(A9, A10, A12)` for the symmetric and first dihedral orbits, `(A12, A9, A10)` for
the second, and `(A10, A12, A9)` for the third, which is exactly the cyclic order forced by each
orbit's Gram relation as I computed it. The `secondSquare`/`thirdSquare` re-associations of
`A0² = 1 + B + B² + B⁴` are then correct because binary matrix addition is commutative.

The one thing this does not and cannot check is that Lean will agree; that requires the build.

## E. Scholarly-artifact compliance

Violations are findings 3, 5, 6, 7, and 8 above, with file and line. Everything else in the new and
modified modules passes the `lean/CLAUDE.md` review gate as far as I can assess it by reading: no
workflow vocabulary, no task or lane references, no status prose or forecasts, no novelty claims,
generated source self-identifying and naming its generator, exhaustiveness and finite domain stated
for every computational claim, no repository-local reference to an internal note.

Two smaller observations, below the threshold I would call violations:

- `RelationData.lean`'s header says "Lean checks every list against the semantic Boolean matrix it
  encodes". For the four relation lists that is exact. For the four column lists it is one step
  removed: they are checked against the transposed *displayed* support matrix, which is separately
  identified with the semantic orbit in `MinimumWords/OrbitS4.lean`. The sentence is defensible but
  a referee tracing the trust boundary would be better served by naming that second step.
- The generator's `--check` mode compares the whole rendered file byte-for-byte, which is the right
  discipline, but the generated file's header does not state the byte-level canonicalization
  (three masks per line) that makes byte comparison meaningful. Minor.

## F. Red team of the remaining plan

**The cross-product route for the two ambient-plane axioms.** The proposal is sound in outline and
harder than the round report implies, and I checked that the obvious alternative — normalizing the
pair by a projective transformation — is *not* available here. The package's group is PGL(2,13)
acting through the symmetric square (`MinimumWords.projectiveMatrices`, 2184 elements), which
preserves the conic; it is not PGL(3,13) and is not transitive on ordered pairs of arbitrary plane
points. So the normalization trick that works for the conic-adapted statements does not reach
`uniqueLine_through_two_points`.

What actually has to be proved for the cross-product route, over
`PlaneCoordinate = {coordinate : Triple // coordinate ∈ projectiveTriples}`:

1. *Distinct normalized points are non-proportional.* Needed to get `p × q ≠ 0`. This is the content
   of normalization and comes out of a case split on which of the three shapes `(1,y,z)`, `(0,1,z)`,
   `(0,0,1)` each representative has — nine cases, each a two-line linear argument. Cheap.
2. *The cross product, renormalized, is again a member of `projectiveTriples`.* `normalizeTriple`
   already exists (`RelativeConicArcs/PassantCodeQ13/WeightEight.lean:40`) and the needed lemma is
   "a nonzero triple normalizes into `projectiveTripleList`" — the same three-case split. Cheap, and
   reusable.
3. *Incidence.* `⟨p × q, p⟩ = 0` and `⟨p × q, q⟩ = 0` are polynomial identities in six variables over
   any commutative ring: `ring` closes them. Free.
4. *Uniqueness.* This is the hard step and the report does not name it. "The rank of the two-by-three
   coefficient matrix is 2" is not directly usable; what you want is: if `l · p = l · q = 0` and
   `p × q ≠ 0`, then `l` is proportional to `p × q`. The clean route is the identity
   `(p × q) × l = (p · l) q − (q · l) p = 0` (again `ring`), followed by a lemma
   `x × y = 0 → x ≠ 0 → ∃ c, y = c • x`. Mathlib's `Mathlib/LinearAlgebra/CrossProduct.lean` gives you
   `cross_anticomm`, `dot_self_cross`, `triple_product_eq_det` and the Jacobi identity, but I did not
   find that particular collinearity lemma; expect to prove it by a three-case split on which
   coordinate of `x` is nonzero, each case two linear equations. Estimate 60–120 lines of Lean, most
   of it reusable elsewhere in the package.

Compared with the tabulation alternative — a 183×183 incidence bit table (one 33,489-entry
identification) plus, for each of 183² line pairs, a scan over 183 candidate points, i.e. 6.1M bit
reads needing roughly twelve blocked modules — the symbolic route is better if step 4 lands, and it
is genuinely a proof rather than twelve near-identical certificates. I would take it, with the
tabulation route as the fallback if step 4 stalls, and I would not describe it as "a symbolic proof
with no finite domain at all" until step 4 is written.

**Is a pair-concurrence table enough for `fusedColorSix_splits`?** Not as stated, and the report's
framing ("ordered triples of internal points, so it needs the concurrence values packed into a table
and then a split over blocks of first points") describes the expensive version. The statement
(`StructuralUpgrade.lean:37–45`) quantifies over an ordered *pair* of distinct internal points and
takes two `Finset.univ.filter` over a third; the naive cost is 78×78×78 = 474,552 filter-body
evaluations over the subtype universe, which is worse than it looks because each `Finset.univ` over
`InternalPoint` re-derives the subtype universe. With the concurrence packed as one 78-bit mask per
ordered pair — 6084 masks, the same shape as today's relation tables — each pair's two filters
become mask operations and the whole leaf costs on the order of 50K kernel steps in a single module,
with no block split at all. That is the version to build: a mask table, not a scalar table. If a
scalar table is used instead, budget six blocks.

**Are the sixteen weight-ten, eleven row-uniqueness, six automorphism, and three association-algebra
decisions genuinely reachable?** I looked at the modules.

- *Association algebra (three).* Reachable and nearly free — see finding 2. These should be
  reclassified from "remaining" to "already done, needs wiring".
- *Row uniqueness (eleven).* `MinimumWords/RowUniqueness/Residue*.lean` shard
  `rowExtensionCheckAt firstIndex` by `firstIndex % 7`, plus four transport modules. The check
  (`RowUniqueness/Base.lean:207–217`) is a double `List.finRange 78` loop with an ordering guard, over
  `minimumSupportCodes`. That is ordinary tabulation over about 76,000 ordered triples with a
  364-support inner check; the established levers do reach it, and the existing seven-way residue
  shard is the block split. No hidden cliff, but it is the largest brute-force surface left after
  weight ten.
- *Automorphism anchors (six).* `Automorphisms/TripleOrbit.lean` and `Automorphisms/FourthAnchor.lean`.
  Two of these are small (`anchorTriplePattern` is three `rhoAt` evaluations;
  `projectiveMatrices_length = 2184` is a list length). Two are not: `matrixAction_bijective` and
  `matrixAction_preservesRho` are `native_decide +revert` over all 2184 group elements, the latter
  checking 2184 × 6084 ≈ 13.3M pairs. Tabulation will not reach `matrixAction_preservesRho`. It
  should be proved *symbolically* instead: `rho` is a ratio of a squared polar form to a product of
  discriminants, both transforming by the same determinant factor under the symmetric-square action,
  and `rho` is invariant under rescaling either representative, so its invariance is a polynomial
  identity in the four matrix entries and six point coordinates that `ring` should close. That
  converts the single largest native enumeration in the automorphism packet into a symbolic lemma —
  and, as the next section argues, that same lemma unlocks the biggest structural reductions
  available anywhere in the remaining plan.
- *Weight ten (sixteen).* The seven isolated-profile fibres and seven cycle-profile residues run on
  the established reachability kernel and are shard-sized by construction. The two in
  `WeightTen/Aggregate.lean` are the risk: `cycle_pair_partition` (line 61) compares
  `List.mergeSort` of 595 encoded pairs against `mergeSort` of `(secantNeighbors.sublistsLen 2).map`.
  `List.mergeSort` in Lean core is well-founded, and `sublistsLen` builds a 595-element list of
  two-element lists. Kernel-reducing a 595-element merge sort is a genuine unknown and I would not
  assume it reduces at reasonable cost. If it does not, the fix is to replace the sort with a
  sorted-insertion certificate or to state the partition as a mask/multiset identity that reduces
  without sorting. **This is my nomination for the second hidden cliff, alongside the fixed-point
  exhaustion, and it deserves a cheap probe early in the next build window** — it is one small
  module, so probing it costs almost nothing and de-risks the whole weight-ten packet.
- *Fixed-point exhaustion (two).* `MinimumWords/Exhaustion.lean:125` and `:135`. The second one is
  much easier than the task card implies: `fixedPoint_slices_are_stabilizer_orbits` is 28 stabilizer
  matrices × 4 supports × 78 points of `internalIndex (act …)`, about 8700 action evaluations, plus
  `eraseDups`/`toFinset` on 28-element lists. With a packed 28×78 action-index table identified once,
  that is a small leaf. The genuinely hard one is `fixedPoint_weightTwelveExhaustion`, which meets
  two large candidate families through `matchingBaseSupports`; the proved-checker route in the task
  card is right, and the honest shape of it is "these 56 are solutions" (cheap) plus "no other
  candidate is" (the expensive half, which no table removes). Note that `eraseDups` and `toFinset`
  over the solution lists are `DecidableEq`-quadratic and will need attention independently of the
  search.

**Anything in the acceptance criteria untouched by the whole plan?** Yes, several things, and they
are all release-surface rather than mathematics:

- The clean-checkout build under the pinned toolchain has never been exercised for this package with
  the companion present, because the companion is currently excluded from the export.
- Of the seven required release surfaces — statement identity, trust manifest, formal map, axiom
  transcript, provenance, allowlist, release verifier — the plan as written addresses only the axiom
  transcript (via `Gates/AxiomAudit.lean`) and, partially, provenance (via the evidence manifest,
  which is currently broken; see G). There is no visible work item for the theorem-to-source formal
  map, the claim-by-claim trust manifest, the public release allowlist, or making the release gate
  actively reject a native or trusted placeholder. Those are required by the task card's "Engineering
  constraints" and "Acceptance", and none of the round reports mentions them.
- All five standalone pre-release accommodations listed in the task card remain in place and none is
  scheduled: the `papers/repositories.toml` exclusion and `Makefile` rewrite, the companion-absent
  skip in `verify_evidence.py`, the two README sentences, the repository-relative
  `lean-certificates/` paths in the manuscript and `verification/README.md`, and the `git rm` in the
  standalone mirror.
- The manifest debt in section G is itself an acceptance-criterion gap: "generated-artifact
  provenance" is not satisfied while two tracked generators and their generated modules have no
  records.

**Is there a cheaper global strategy the round-by-round approach has missed?** Partly yes. See the
next section, which the coordinator asked for specifically.

## Structural reductions

The question is whether the large remaining enumerations can be *shrunk or removed* by a structural
argument rather than made cheaper by tabulation and blocking. I did the group-theoretic computation
rather than speculating about it. What follows separates what I verified from what I am estimating.

**The verified fact that everything else here rests on.** I built PGL(2,13) explicitly — the 2184
normalized invertible 2×2 matrices over `ZMod 13` up to scalars — implemented its symmetric-square
action on coordinate triples (`X ↦ a²X + 2acY + c²Z`, `Y ↦ abX + (ad+bc)Y + cdZ`,
`Z ↦ b²X + 2bdY + d²Z`, then renormalize), and confirmed by direct computation:

- the action preserves the set of 78 internal points;
- it is **transitive on the 78 internal points**, with point stabilizer of order 28 — which matches
  the package's own already-computed `fixedPointStabilizer.length = 28`;
- it is **transitive on each of the six relation classes of ordered pairs**: the 546 ordered pairs at
  polar invariant 0 form a single orbit, and so do each of the five 1092-pair classes at polar
  invariants 1, 3, 9, 10, 12. (Valencies: 7 for the rho-zero relation, 14 for each of the other
  five.)

That is a strong structural fact and the package does not currently exploit it. Three real
reductions follow, and I will be explicit about where the trade stops being favourable.

**Reduction 1 — prove rho-invariance symbolically, deleting the largest automorphism enumeration.**
Current: `Automorphisms/TripleOrbit.lean:33–37` proves `matrixAction_preservesRho` by
`native_decide +revert` over 2184 group elements, each checking 6084 pairs — 13.3M evaluations.
Reduced: zero enumeration. `rho(u,v) = B(u,v)² / (Q(u)Q(v))` where `B` is the polarization of `Q`;
under the symmetric square of `M`, both `B` and `Q` acquire the same `det M` factor, and `rho` is
invariant under independent rescaling of `u` and `v` (degree (0,0) bi-homogeneous), so normalization
is irrelevant. What must be proved: one polynomial identity in ten variables, which `ring` should
close, plus the observation that `det M ≠ 0` is invertible. **The proof obligation is far cheaper
than the enumeration it removes**, and this lemma is the engine for reductions 2 and 3. I regard this
as the single highest-value item in the remaining plan.

**Reduction 2 — one point transporter kills every per-point enumeration.** Current:
`unaryDegree_fiftySix` (`StructuralUpgrade.lean:26–28`) is `native_decide +revert` over all 78
internal points; on displayed masks it would be 28,392 bit reads. Reduced: one point plus
transitivity — 364 bit reads. What must be proved: a displayed list of 78 group elements with
`internalIndex (act (transporter i) (internalAt 0)) = i`, one cheap kernel leaf (78 actions and 78
index scans, a few thousand steps), plus invariance of the 364-word set under the action, which is
nearly free because `supportOrbit` *is* the orbit. **Cheaper than the enumeration, and the
transporter is reusable.** The task card already anticipates this ("unary constancy will use the
manuscript's orbit-transitivity and double-count mechanism"); today's round report proposes plain
tabulation instead. Both work here — 28,392 bit reads is not expensive — but the transporter should
be built anyway for reduction 3, at which point tabulating this leaf is the wrong choice.

**Reduction 3 — one pair transporter collapses the pair statements from 6084 cases to 6.** Current:
`fusedColorSix_splits` and `pairColorEight_recovers_polarRows` quantify over ordered pairs of
distinct internal points; the former ranges over 6084 pairs with an inner 78-fold filter, 474,552
evaluations. Reduced: six representative pairs, one per relation class, by the transitivity I
verified. What must be proved: reduction 1 (equivariance of everything the predicate depends on —
rho, concurrence, and the minimum-word set) plus a transporter table mapping each of the 6084 ordered
distinct pairs to a base pair, kernel-checked at roughly 160 steps per pair, about 1M steps, one or
two modules.

Here is the honest accounting, because it is not the thousand-fold win it first appears. You pay
about 160 kernel steps *per pair* to check the transporter, so a predicate whose per-pair cost is
itself only a few hundred steps gains little from transport. The transporter table pays for itself
only because it is built **once** and reused: it serves `fusedColorSix_splits`,
`pairColorEight_recovers_polarRows`, and any future pair-indexed statement, and it also gives the
relation-class structure needed for reduction 2's double count. My recommendation is to build it as
shared infrastructure exactly once, not to justify it by any single consumer.

**Where the structural route does *not* win, stated plainly.**

- *Row uniqueness.* The natural reduction is to orbits of unordered triples of internal points —
  76,076 triples falling into a few dozen orbits, a nominal 1900-fold cut. But the transporter
  certificate is itself indexed by triples, so checking it costs on the order of 76,076 × 250 steps,
  which is the same order as the enumeration it would replace. Tabulation and the existing seven-way
  residue shard are the right tools here. There is a second obstacle: `rowExtensionCheckAt`'s index
  ordering guard (`secondIndex.1 < firstIndex.1`, `thirdIndex.1 < secondIndex.1`) is not
  group-equivariant, so the statement would first have to be restated over sets rather than sorted
  index triples.
- *Fixed-point exhaustion.* The order-28 stabilizer does act on the search domain and would nominally
  cut it 28-fold, but formalizing the action on the fibre-choice domain is more work than the search.
  The proved-checker route in the task card is correct. What *is* worth doing is the cheap half:
  `fixedPoint_slices_are_stabilizer_orbits` reduces to a packed 28×78 action table, as noted above.
- *Automorphism anchors.* The anchor triple is fixed, so the statements are not equivariant and no
  orbit reduction applies to `firstThreeSignature_eq_iff`. Tabulation is correct there.
- *Weight ten.* The base-point normalization is already the structural reduction, and the earlier
  cycle-profile analysis established that projection does not shorten the transition list. I found no
  further reduction; the remaining question there is the `mergeSort` cliff, which is an
  implementation matter rather than a size matter.

**The bigger question — is the round-by-round strategy leaving a smaller total surface on the
table?** Partly, and it is worth saying which part. The closed packets — incidence and dimension,
weight eight, the weight-ten profiles, the minimum-word layer — are genuine classifications whose
content is the enumeration; no reorganization would have avoided them, and I would not revisit them.
What the round-by-round strategy *has* cost is a missing shared layer: an equivariance lemma plus
two transporter tables, built once, would have removed `matrixAction_preservesRho` outright and
collapsed the per-point and per-pair statements in the structural upgrade to a handful of
representative cases. That layer is still worth building now, because three of the remaining packets
consume it. It is not rework of what has landed; it is a piece of infrastructure that each round so
far has been individually rational to skip and that is collectively overdue.

The second, smaller missed consolidation is finding 2: today's round built a mask calculus for the
relation matrices without noticing that the package already had a mask calculus for the same
matrices under a different name, with three native decisions attached to it.

## G. Evidence manifest and reproducibility debt

I read `verification/evidence_manifest.json` (schema `q13-passant-code-structural-evidence-v2`, 23
file records and 10 command records) and `verification/verify_evidence.py`, verified every file
digest myself, and ran the verifier.

**Current state: failing.** Two records are stale, both modified by commit `919f5b7a`:

| record | manifest bytes | actual bytes |
|---|---|---|
| `lean-certificates/PassantCodeQ13/StructuralUpgrade.lean` | 5211 | 5430 |
| `lean-certificates/PassantCodeQ13/Gates/AxiomAudit.lean`  | 6456 | 7484 |

The verifier asserts on size before digest, so it aborts on the first of these. A full checkout of
this paper does not pass its own evidence gate today.

**Records that must be added.** The manifest carries exactly six `lean-certificates/` file records
(`generate_rank_transport.py`, `RankTransportData.lean`, `SemanticTransports.lean`,
`StructuralUpgrade.lean`, `Gates/Main.lean`, `Gates/AxiomAudit.lean`) and one `lean-certificates`
command (`python3 generate_rank_transport.py --check`). Missing:

- `lean-certificates/generate_association_transport_data.py` (new today) and
  `lean-certificates/PassantCodeQ13/AssociationTransport/RelationData.lean` (new today), plus the
  command `python3 generate_association_transport_data.py --check` with `cwd: lean-certificates`.
  I ran that command: it passes.
- `lean-certificates/generate_minimum_word_orbits.py` and
  `lean-certificates/PassantCodeQ13/MinimumWords/OrbitData.lean` — pre-existing debt, and now
  load-bearing for today's round, because `generate_association_transport_data.py` *imports*
  `generate_minimum_word_orbits` for `internal_points`, `support_orbit`, and `REPRESENTATIVES`. The
  new replay command therefore depends on a file with no pinned digest, which weakens the new record
  as well as the old gap.
- Two further tracked scripts have no records at all:
  `lean-certificates/check_association_transport_statements.py` (which I ran; it passes, 0 failures,
  and it is a genuinely useful statement-shape check worth pinning) and
  `lean-certificates/generate_weight_ten_reachability.py`.

**Schema note.** The `lean-certificates/` records use the short shape (`paper_iv_path`, `bytes`,
`sha256`, `role`) without the `antecedent`/`source_sha256` fields that the copied-program records
carry, so new records follow the existing short form and no schema change is needed.

**Recommended action.** Refresh the two stale digests and add the four missing generator/data pairs
plus the association-transport `--check` command in one commit, then re-run
`python3 verification/verify_evidence.py` and confirm it prints the pass line. This should happen
before any further Lean work, because the failing verifier will otherwise be attributed to whatever
lands next.

## What I could not settle without a build

1. **The measured peak of a relation-mask module.** Everything in section C is an estimate. The
   single most informative measurement available in the next build window is the peak of
   `AssociationTransport/RelationMasks/RhoZero.lean` on the `single` profile, because it calibrates
   the cost of one kernel `rhoAt` evaluation and therefore every remaining leaf that touches the
   polar invariant.
2. **Whether the kernel caches the reduction of `internalCoordinateList`.** The gap between my
   optimistic (1.6M) and pessimistic (15M) estimates is almost entirely this question. It is answered
   by the same measurement.
3. **The cost of one `ZMod 13` inversion in the kernel.** I established that it reduces; I do not
   know what it costs. If it is expensive, the inverse-free reformulation in finding 4a moves from
   "recommended" to "required".
4. **Whether `simp only` in `parity_ofFn_eq_selectedBitParity` fires as intended** (risk 2 in
   section B).
5. **Whether `List.mergeSort` on 595 elements kernel-reduces at acceptable cost**
   (`WeightTen/Aggregate.lean:61`). One cheap probe module settles it and de-risks the weight-ten
   packet; I would run it early.
6. **Whether the axiom audit's twenty-three-plus terminals all report only `propext`,
   `Classical.choice`, `Quot.sound` after this round.** Reading says they should — no new axiom
   entered — but the audit is the gate and only the gate can say so.
