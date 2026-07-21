# C424 / F5 — Lean balanced sheets and cubic orientation

**Lane:** `clebsch`

**Status:** review repairs implemented; post-fix independent review required before closure

**Date:** 2026-07-21

**Implementation commit:** `29f81b4219c635824f1fb28d4b55092998271fa3`

## Result

The C430 radical--Hadamard route is formalized without balanced-half enumeration.
`RelativeConicArcs.ClebschBalancedSheets` proves an abstract theorem for two equal sheets:
if an affine evaluation space

1. contains the two sheet indicators (recovered from one separating two-level function),
2. restricts onto the zero-sum hyperplane on each sheet,
3. has equal sheet sums on every coordinatewise product, and
4. has one product with nonzero common sheet sum,

then its Hadamard square is the full equal-sheet-sum hyperplane.  The standard pairing annihilator
of that hyperplane is exactly the one-dimensional sheet-sign line.  The B3 and H3 leaves discharge
these hypotheses for the frozen configurations over `ZMod 7` and `ZMod 11`.

The finite boundary is small and kernel checked:

| case | sheet size | affine restriction image | second-moment kernel | separating radical levels | named nonzero sheet pairing |
|:--|--:|:--|:--|:--|:--|
| B3 | 7 | both zero-sum hyperplanes (dimension 6) | exactly `span [0,1,1,0,1,0]` (rank/radical `5/1`) | `0 / 1` | `sum x₀² = 1` |
| H3 | 11 | both zero-sum hyperplanes (dimension 10) | exactly `span [1,1,0,0,1,0,1,1,0,1]` (rank/radical `9/1`) | `0 / 1` | `sum x₀² = 2` |

Thus every field-valued strength-two trade is a scalar sheet sign in both cases.  This is stronger
than classifying balanced `±1` halves and uses no `binom(14,7)`, `binom(22,11)`, meet-in-the-middle,
or monolithic subset checker.

The same abstract module proves:

- a signed-orbit-sum relative-invariant theorem;
- the index-two stabilizer theorem: a nonzero vector transforming by a two-valued character has
  stabilizer equal to the character kernel when `2 != 0`;
- the three plane identities obtained by expanding `Pᵢ = P₀ + Q Φᵢ` through degree three.

The concrete B3/H3 leaves kernel-check four action generators each: all are bijections, the first
three preserve the sheet sign, the outer generator negates it, and every generator acts affinely
on every frozen quotient vector with the displayed matrix and translation.  They also define the
actual ordered-coordinate signed cubic tensors, prove them nonzero from C423's named cubic
coordinates, and instantiate relative invariance and exact character-kernel stabilizers for every
supplied certified cubic action.  The supplied-action structure makes the classical
`PGL_2/PSL_2` boundary explicit in the theorem type.

## Ordinary mathematical statements and exact Lean terminals

### Abstract radical--Hadamard and trade line

For a field `K` and a pair of `q`-point sheets, let `L` be a submodule of sheet-pair functions and
let `L²` be the span of coordinatewise products of two members of `L`.

- `RelativeConicArcs.ClebschBalancedSheets.hadamardSquare_eq_equalSheetSum` proves
  `L² = {x | sum x.left = sum x.right}` from indicator membership, the two zero-sum restriction
  surjections, equality of product sums, and one nonzero product sum.
- `RelativeConicArcs.ClebschBalancedSheets.annihilates_equalSheetSum_iff_eq_sheetSignLine`
  proves that a functional represented by a sheet pair annihilates the equal-sum hyperplane iff it
  has the form `(c,c,...; -c,-c,...)`.
- `RelativeConicArcs.ClebschBalancedSheets.matrix_kernel_eq_line_of_recovery` proves the generic
  checked-recovery lemma used to turn each finite second-moment factorization into an exact kernel
  line.

### Concrete balanced sheets

The B3 terminals are:

- `b3_restrictsOntoZeroSum`;
- `b3_secondMoment_kernel_eq_radicalLine`;
- `b3_radical_separates_sheets`;
- `b3_productsHaveEqualSheetSums`;
- `b3_hasNonzeroSheetProduct`;
- `b3_hadamardSquare_eq_equalSheetSum`; and
- `b3_trade_eq_sheetSignLine`; and
- `b3_balancedHalf_unique`, which converts a pointwise `±1` annihilating weight into the displayed
  sheet partition or its complement.

The H3 terminals have the same suffixes with prefix `h3_`.  They live in namespace
`RelativeConicArcs.ClebschBalancedSheets`.  The exact public headers of all paper-facing terminals
are mechanically extracted into the JSON certificate under `statement_adequacy`; the extractor
fails if a declaration disappears or its body delimiter cannot be found.

### Action, cubic orientation, and stabilizer

- `signedOrbitSum_isRelativeInvariant` proves that a linear action which permutes finite features,
  while the weights transform by a scalar `chi`, sends their signed sum to `chi` times itself.
- `stabilizer_eq_ker_of_relative_invariant` proves the exact stabilizer-kernel conclusion for a
  nonzero relative invariant and a two-valued character in characteristic other than two.
- `b3_actionPermutation_bijective`, `b3_specialGenerators_preserve_sheetSign`,
  `b3_outerGenerator_negates_sheetSign`, and `b3_actionGenerators_areAffine` check the complete
  B3 generator facts; the H3 declarations have the corresponding `h3_` prefixes.
- C423 supplies the nonzero witnesses
  `RelativeConicArcs.ClebschFactorization.b3_signedCubicCoordinate_ne_zero` and
  `RelativeConicArcs.ClebschFactorization.h3_signedCubicCoordinate_ne_zero`.
- `b3_signedCubicTensor_ne_zero`, `b3_signedCubic_isRelativeInvariant`, and
  `b3_signedCubic_stabilizer_eq_characterKernel` are the concrete B3 composition terminals; the H3
  declarations have the corresponding prefix.

The formal stabilizer theorem is instantiated on each concrete signed cubic inside a
`CertifiedCubicAction`.  The identification of the
displayed generated permutation groups with the classical `PSL_2(q)` subgroup and its outer
`PGL_2(q)` coset remains the named classical/group-construction input; Lean checks the finite
generator actions, sign parity, and affine covariance, not an independent classification of those
abstract groups.

### Plane syzygies

The terminals

- `signed_sum_affine_expansion_one`,
- `signed_sum_affine_expansion_two`, and
- `signed_sum_affine_expansion_three`

prove in every commutative ring that, after the corresponding signed moments of `Φᵢ` vanish,
expanding `Pᵢ=P₀+QΦᵢ` gives the degree-one and degree-two zero identities and the degree-three
identity `sum εᵢ Pᵢ³ = Q³ sum εᵢ Φᵢ³`.  They derive the identities symbolically; no
polynomial-output table is frozen.

## Owned artifacts

- `lean/RelativeConicArcs/ClebschBalancedSheets.lean` — abstract sheet algebra, affine evaluation,
  moment/recovery lemma, relative-invariant stabilizer, and syzygies;
- `lean/RelativeConicArcs/ClebschBalancedSheetsB3.lean` — B3 decoders, radical recovery,
  balanced-sheet theorem, and action leaves;
- `lean/RelativeConicArcs/ClebschBalancedSheetsH3.lean` — H3 counterparts;
- `lean/RelativeConicArcs/Gates/ClebschBalancedSheets.lean` — import-only exit gate;
- `notes/2026-07-20-c424-clebsch-balanced-sheets-lean.py` — deterministic generator and
  independent replay;
- same-stem `.json` — canonical certificate, Lean-literal binding, and theorem-header extraction;
- same-stem `.sha256` — checksums for the script, JSON, three modules, and gate; and
- this report.

Current byte counts are `25,737 / 12,126 / 14,362 / 461` for the abstract/B3/H3/gate Lean files
and `16,635 / 46,072 / 716` for the Python/JSON/checksum evidence files.  Regeneration after a
source change recomputes these figures and hashes; the checksum manifest is authoritative.

## Reproducibility and trusted boundary

Run from the repository root with Python 3.13.12:

```bash
python3 notes/2026-07-20-c424-clebsch-balanced-sheets-lean.py --check
sha256sum -c notes/2026-07-20-c424-clebsch-balanced-sheets-lean.sha256
```

The generator reconstructs the B3/H3 matching orbits from the committed C406/C423 geometry,
computes the affine sheet decoders, second-moment matrices and nullspaces, recovery inverses,
three special generators plus one outer generator, affine matrices/translations, and pointwise
sheet parity.  It independently replays every restriction and second-moment rank with a separate
modular row reducer and checks
every affine action and parity on every point.  It then parses the Lean source and requires exact
agreement for sheet indices, radicals, recovery matrices, complements, permutations, affine
matrices, and translations.  `half_subset_enumeration_used` is `false` in both cases.

The trusted computational boundary is exact prime-field arithmetic in the Python implementation
and the committed C406/C423 geometric constructors.  Lean does not trust the JSON: its finite
matrix identities, basis evaluations, generator bijectivity, sign parity, affine covariance, and
named nonzero pairings are checked by kernel reduction in the leaves.  The JSON supplies provenance,
independent replay, and literal-identity evidence.  The classical identification of the generated
actions with `PGL_2(q)/PSL_2(q)` is not reclassified here.

## Validation and axiom audit

Final exact-target command:

```bash
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.ClebschBalancedSheets \
  RelativeConicArcs.ClebschBalancedSheetsB3 \
  RelativeConicArcs.ClebschBalancedSheetsH3 \
  RelativeConicArcs.Gates.ClebschBalancedSheets \
  --profile single --threads 1 --cores 20-23 \
  --aggregate RelativeConicArcs.Gates.ClebschBalancedSheets
```

Final trace-current run directory:
`/home/tavis/.cache/othello-lean-build/run-20260721-214335-395461b7`.

An ephemeral import of the gate issued `#print axioms` for 45 terminals: the eleven abstract exits,
the fifteen selected B3 exits, the seventeen H3 exits, and the two C423 nonzero cubic witnesses.  Every
terminal reported exactly `[propext, Classical.choice, Quot.sound]`; none reported `sorryAx`,
`native_decide`, `Lean.ofReduceBool`, a project axiom, or non-kernel execution.  The audit source was
ephemeral because this task's allowlist requires the permanent gate to remain import-only; the
exact terminal list is the union of `statement_adequacy` and the two C423 names above.
The successful audit output is
`/home/tavis/.cache/othello-lean-build/guarded-lean/20260721-144442-cd-lean-exec-taskset-c-20-23-env-LEAN_NUM_THREADS1-choom-n-1000-nix-develop-comma/stdout.log`.

## Claim routes and exclusions

| claim | route | residual boundary |
|:--|:--|:--|
| abstract Hadamard-square equality | full-trust Lean | stated hypotheses only |
| B3/H3 restriction surjectivity | full-trust Lean checked bases | frozen quotient coordinates |
| B3/H3 radical line and `5/1`, `9/1` split | full-trust Lean checked recovery | frozen second-moment matrices |
| balanced-sheet/trade-line and complementary-half uniqueness | full-trust Lean composition | field-valued trades and pointwise `±1` halves on the frozen configurations |
| generator bijectivity, sign parity, affine action | full-trust Lean finite checks | displayed generators |
| cubic nonvanishing | imported full-trust C423 Lean terminals | named coordinate witnesses `2`, `3` |
| concrete cubic relative-invariance and stabilizer | full-trust Lean concrete composition | supplied certified representation, permutation action, and character |
| H3 affine-pairing radical/socle bridge | full-trust Lean exact radical image | C412 identification of each sheet-constant line with `soc(P(1))` |
| identification with classical `PSL_2/PGL_2` | conceptual/classical plus exact reconstructed action | no Lean group-classification theorem |
| plane syzygies | full-trust Lean symbolic expansion | ordinary commutative-ring products |

The gate does **not** prove cubic uniqueness, uniqueness of an invariant cubic line, Hessian or
contraction recovery, singular-locus recovery, a cubic-to-Fourier intertwiner, the C412 relative
Tate-plane/depth-plane identification, or a full linear stabilizer in `GL(W)`.  It does not classify
unrelated two-sheet configurations.  It proves no result by half-subset enumeration and contains no
fallback or conditional H3 certificate tier.

## Judgment-call record

### Replace the queued half-search brief with C430

- **Question:** retain the original B3 enumeration/H3 meet-in-the-middle design or use C430's
  later radical--Hadamard theorem?
- **Options:** subset checkers; conditional H3 certificate fallback; symbolic C430 route.
- **Choice:** symbolic C430 route only.
- **Evidence:** C430 proves the stronger field-valued trade-line result from restriction
  surjectivity, a one-dimensional separating radical, equal second moments, and one nonzero pairing.
  The reconstructed ranks are `6/6`, `10/10`, `5/1`, and `9/1`.
- **Trust effect:** both B3 and H3 balanced uniqueness are unconditional full-trust Lean; no
  external half census is load-bearing.
- **Rejected alternatives:** both enumeration routes, because they are weaker and explicitly
  superseded by the live queue and formalization plan.
- **Reopen only if:** the C430 hypotheses cease to match the frozen C423 coordinates.

### Represent sheets as a pair of function spaces

- **Question:** use `Fin (2*q)`, subtypes of sign fibres, or an explicit pair `(Fin q -> K)^2`?
- **Choice:** an explicit pair of sheets in the abstract theorem, with checked index maps in each
  concrete leaf.
- **Evidence:** this makes restriction surjectivity, sheet indicators, common sums, and the
  annihilator proof transparent while the finite leaves prove the exact reindexing.
- **Trust/import effect:** no projective-coordinate quotient or half-subset API enters the abstract
  closure; the gate remains light.
- **Rejected alternatives:** subtype-heavy fibres and a monolithic `Fin (2*q)` theorem, which hide
  the two independent zero-sum maps without strengthening the result.
- **Reopen only if:** a later reusable API needs arbitrary unequal or non-enumerated sheet types.

### Check decoders on a zero-sum basis

- **Question:** quantify over every finite-field function by reduction or prove a symbolic basis
  decoder?
- **Choice:** kernel-check six/ten concrete basis coefficients, then extend symbolically to every
  zero-sum function.
- **Evidence:** this avoids `7^7`/`11^11` enumeration and gives the exact restriction theorem.
- **Trust effect:** only small closed equalities reduce; the universal conclusion is proved in Lean.
- **Rejected alternative:** exhaustive function enumeration, which is unnecessary and would hide
  the linear mechanism.
- **Reopen only if:** the frozen coordinate basis changes.

### Separate action checking from classical group identification

- **Question:** formalize a full construction/classification of `PGL_2(q)` and `PSL_2(q)` here, or
  check the supplied generator actions and state the stabilizer theorem abstractly?
- **Choice:** check all supplied permutations, affine matrices, translations, and sheet parities in
  Lean; retain the classical group identification as the explicit outside input.
- **Evidence:** these are exactly the action facts used by the cubic relative-invariant mechanism;
  a group-classification development would be a new dependency spine.
- **Claim effect:** the formal stabilizer conclusion is inside the supplied action, exactly as the
  task brief requires; no claim about a full `GL(W)` stabilizer is made.
- **Rejected alternative:** importing or building a broad finite-group classification layer.
- **Reopen only if:** the paper labels the abstract `PGL_2/PSL_2` identification itself as
  Lean-formalized.

### Keep the axiom audit ephemeral

- **Question:** add a permanent audit module outside the four allowed Lean paths?
- **Choice:** no; run an ephemeral gate import with the exact `#print axioms` list and record the
  stable terminal set and log result here.
- **Evidence:** the task allowlist names exactly three modules and one import-only gate.
- **Trust effect:** theorem axioms are checked without widening scope or making the gate non-import-only.
- **Reopen only if:** the owner expands the allowlist to a committed audit harness.

The H3 leaf now proves that the affine-pairing radical image is exactly the sum of the two
sheet-constant socle lines and that their outer-odd line is the sheet-sign trade.  The remaining
C412 input is the representation-theoretic naming of each checked sheet-constant line as
`soc(P(1))`; no projective-cover classification is rebuilt here.

## C320 ledger delta

1. Add an abstract full-trust row for `hadamardSquare_eq_equalSheetSum` plus
   `annihilates_equalSheetSum_iff_eq_sheetSignLine`, gate
   `RelativeConicArcs.Gates.ClebschBalancedSheets`.
2. Add separate B3 and H3 full-trust rows naming their restriction, exact radical-line,
   Hadamard-square, and trade-line terminals.  Record ranks `6/6`, `10/10`, `5/1`, `9/1` and the
   absence of subset enumeration.
3. Add separate concrete-action rows naming bijectivity, sign-preservation/negation, and affine
   generator terminals; identify classical `PGL_2/PSL_2` naming as the external boundary.
4. Add a cubic-orientation composition row combining the concrete action leaves, imported C423
   nonzero cubic witnesses, `signedOrbitSum_isRelativeInvariant`, and
   `stabilizer_eq_ker_of_relative_invariant`.
5. Add three plane-syzygy rows, or one row listing all three expansion terminals, as full-trust Lean.
6. Add `RelativeConicArcs.Gates.ClebschBalancedSheets` to the eventual replacement-spine verify-all
   entry point.  Do not call the entire replacement spine Lean-formalized before C320 reconciliation.

## Review checklist

- [x] Ordinary mathematical exits, domains, hypotheses, and conclusions stated.
- [x] Each claim assigned one trust route with residual boundary.
- [x] Exact public theorem headers mechanically extracted into committed JSON.
- [x] No vacuous predicate, conclusion-bearing data definition, hidden empty domain, or weakened
  quantifier found in the touched modules.
- [x] Import-only gate imports every claimed concrete terminal.
- [x] Finite checks record source data, coverage, independent replay, and Lean-literal identity.
- [x] No `sorryAx`, `native_decide`, project axiom, or opaque oracle in the audited terminals.
- [x] Hashes and byte counts regenerated after the final source/evidence edit.
- [x] Referee-facing names, headers, docstrings, and exclusions reviewed; no workflow references,
  task IDs, internal-note links, novelty claims, or status prose occur in Lean artifacts.
- [x] Judgment calls and reopening conditions recorded.
- [x] C320 claim-by-claim delta supplied.
- [x] Record the independent reviewer's identity, date, verdict, findings, and dispositions.

## Independent review

`/root/c424_review` returned `NO-GO` on 2026-07-21.  Its five findings and dispositions are:

1. **Concrete cubic orientation/stabilizer missing:** fixed by `CubicTensor`,
   `CertifiedCubicAction`, the concrete B3/H3 signed tensors and nonzero witnesses, and the concrete
   relative-invariance/stabilizer terminals.
2. **Balanced-half uniqueness not stated:** fixed by `balancedHalf_unique_of_annihilates` and the
   B3/H3 `balancedHalf_unique` terminals.
3. **H3 socle/radical bridge omitted:** fixed by
   `h3_affinePairingRadical_eq_sheetSocleSum` and `h3_outerOddSocleLine_eq_sheetSign`, with only the
   C412 projective-cover naming retained as an explicit representation-theoretic boundary.
4. **Statement/audit omissions:** fixed by adding the four product terminals and every new endpoint
   to `statement_adequacy` and the ephemeral axiom list.
5. **Replay/provenance overstatement:** fixed by independently replaying restriction ranks and by
   hashing the direct C399/C378 transitive inputs.

The same reviewer must return `GO` on the repair diff before closure.
