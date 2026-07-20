# Independent review of C222 — compact `A3/H3` Lean closure

**Lane:** `clebsch`

**Review authority:** user-launched Codex review

**Disposition:** **READY FOR FIXES**. This is not `GO`, and C222 must remain active.

## Scope and method

This review read the actual types, definitions, comments, and names in
`lean/RelativeConicArcs/ReflectionArrangements.lean` and
`lean/RelativeConicArcs/ReflectionArrangementDecoding.lean`, together with their current
project-owned import closure, the C222 report, the Clebsch formalization plan and handoff, the paper
trust policy, `lean/TRUST.md`, and the Lean referee-facing standards. It did not edit or elaborate
Lean, create a gate, run Lake, regenerate data, or touch certificates or Q25 paths. C222 is an active
implementation, so missing build/gate evidence is classified as provisional work unless the report
already claims it is complete; a theorem or docstring stronger than its type is classified as an
error.

The two reviewed source hashes still agree with the C222 report:

- `ReflectionArrangements.lean`: sha256
  `9154964eb896470a61d222798cff654ad41343f3248b256939a08566d2d2ef82`, 11202 bytes.
- `ReflectionArrangementDecoding.lean`: sha256
  `11c6bf272e233fd137bcbeb2ae4d62231983ab91c791fe0bba886026624a519b`, 1463 bytes.

A source scan of the 33-file project-owned import closure found no `sorry`, `native_decide`, local
`axiom`, or `opaque` declaration. That is useful source evidence, not a substitute for the required
live `#print axioms` audit or a gate build. No current module under
`lean/RelativeConicArcs/Gates/` imports either C222 module.

## Prioritized findings

### 1. Blocking — the decoder terminal does not prove stratum agreement

**Location:** `lean/RelativeConicArcs/ReflectionArrangementDecoding.lean:16-31`; C222 report
`notes/2026-07-16-c222-lean-a3-h3-closure.md:136-144,197`.

The docstring says the reduced `H3` multiplicity strata and Clebsch decoder strata “agree,” and the
report says the geometric identification is carried by the projectivity and pointwise-index bridge.
The theorem type is only a conjunction of eight independent cardinality equalities. Its proof simply
pairs `h3_intersection_spectrum` with `ambiguity_strata_counts`. It contains no map between an `H3`
projective point and an affine syndrome, no scalar-ray factor of ten, no membership equivalence, and
no statement relating multiplicity `0/1/2/3/5` to nearest-leader multiplicity `20/1/2/3/1`.

The existing `h3_multiplicity_eq_rawPointIndex` is a valuable pointwise bridge, but it stops at
`rawPointIndex (h3Projectivity (projectiveVec p))`. The decoder terminal does not compose it with
the affine-ray equivalence, the decoder soundness theorems, or bijectivity of the projectivity on
projective points. In particular, the `960` one-leader count combines 90 ordinary projective points
and six fivefold points, while the present theorem omits that decomposition entirely.

**Impact:** C222 objective 4's decoder-stratum consequence is not Lean-formalized. The current
docstring is stronger than the elaborated statement.

**Required fix:** either add an actual bridge theorem with an explicit point/ray map and membership
or leader-count equivalences (including the multiplicity-5 contribution and factor ten), or narrow
the declaration name, docstring, task ledger, and manuscript route to “joint numerical censuses.” A
mere conjunction must never be described as agreement or identification.

### 2. Blocking — the `A3` mirror theorem is one-sided

**Location:** `lean/RelativeConicArcs/ReflectionArrangements.lean:235-244`; C222 report
`notes/2026-07-16-c222-lean-a3-h3-closure.md:127-134`.

`a3_frame_joins_are_braid_mirrors` proves only that every one of the six indexed joins is parallel to
*some* indexed braid mirror. It proves neither the reverse inclusion nor distinctness/cardinality of
the two projective sets. Its type is compatible with all six joins mapping to one mirror. The report
instead claims equality with all six essentialized braid mirrors.

**Impact:** the formal statement does not establish that the computed join arrangement is the `A3`
arrangement whose spectrum is later advertised.

**Required fix:** strengthen the type with reverse coverage and projective cardinality six, following
the two-sided shape already used by `h3_joins_are_root_directions`, or narrow every claim to the
one-sided statement actually proved.

### 3. Blocking — full-trust and complete-report labels are premature

**Location:** C222 report
`notes/2026-07-16-c222-lean-a3-h3-closure.md:3-10,82-96,186-216,243-266`.

The report calls the source-level report complete and assigns every subclaim “full-trust Lean,” but
it also correctly records that no import-only gate, current elaboration, pinned validated commit, or
live axiom transcript exists. `lean/TRUST.md` additionally says Clebsch has no per-paper manifest.
Those are release-policy blockers, not cosmetic omissions.

The claim at report lines 207-208 that the sources already contain probes “for every terminal” is
false. `ReflectionArrangements.lean:275-285` omits probes for at least `tau5_relation`,
`h3_projectivity_det`, `h3_fivefold_index_vec`, `a3_frame_joins_are_braid_mirrors`, and all five S7
terminals. The downstream module probes `h3_decoder_strata`, but that does not cover the omitted
terminals individually as the checklist requires.

**Impact:** the ledger cannot yet confer a Lean-formalized label, and a closing agent following the
current prose could mistake expected evidence for established evidence.

**Required fix:** call these routes “candidate full-trust Lean” until the adequacy fixes, exact gate,
guarded/gate validation, pinned commit, and complete terminal-by-terminal axiom audit land. Add all
missing probes or provide a deterministic audit module/command that prints every claimed terminal.
Record the actual output, not the expected standard axiom set.

### 4. Blocking — `H3`, `A3`, characteristic-polynomial, and conic-code semantics exceed the types

**Location:** `lean/RelativeConicArcs/ReflectionArrangements.lean:3-9,52-83,172-180,193-221,259-273`;
C222 report `notes/2026-07-16-c222-lean-a3-h3-closure.md:92-104,127-152`.

Lean checks explicit coordinate tables and arithmetic. It does not currently prove or cite, in this
module, that the fifteen displayed directions are the projectivized `H3` root arrangement, that the
four-point construction is the essentialized `A3` reflection arrangement, or that the displayed
polynomials are the characteristic polynomials of those arrangements. The S7 theorems are bare
integer polynomial identities; no arrangement characteristic polynomial, intersection lattice,
Möbius function, complement, code, or conic object occurs in their types.

The docstring “Characteristic five is lattice-faithful” at lines 216-217 is especially too strong:
the theorem proves a multiplicity spectrum only, not an intersection-lattice isomorphism. Likewise
the S1 report's “There is tau in F_q” is not quantified over a general field: Lean proves only the
chosen values in `ZMod 11` and `ZMod 5`, plus the `ZMod 2` boundary.

**Impact:** the report blurs full-trust coordinate/arithmetic facts with conceptual identifications
and classical arrangement consequences. Referees could reasonably read the names and prose as
formalizing more than Lean says.

**Required fix:** split the ledger routes. Keep the explicit coordinate and integer identities as
Lean facts; either formalize the semantic bridges, or state the exact named classical input with a
proper public citation and classify the result as a combination. Rename/re-docstring S7 declarations
as ledger-polynomial or arithmetic factorizations unless their connection to arrangement
characteristic polynomials is itself formalized. Replace “lattice-faithful” by the exact spectrum
claim. Restrict S1 to the three fields actually present.

### 5. Major — the projectivity API leaves crucial semantics implicit

**Location:** `lean/RelativeConicArcs/ReflectionArrangements.lean:114-150`; C222 report
`notes/2026-07-16-c222-lean-a3-h3-closure.md:106-125,248-251`.

`h3_projectivity_det` proves only `det T = 3`; no terminal states `3 != 0`, packages `T` as a linear
equivalence/projective bijection, or proves that `h3DualProjectivity` is the inverse-transpose action.
The coordinate mapping and multiplicity equalities happen to check the required rows directly, but
the prose calls both functions projectivities and uses bijective transport in the informal trust
argument. The checklist even paraphrases the type as “det = 3 != 0.”

**Impact:** the finite row equalities are safe, but global transport of strata through a projective
bijection is not presently an exposed Lean theorem. This contributes directly to finding 1.

**Required fix:** expose compact theorems for nonzero determinant, inverse/dual compatibility, and
the induced bijection on normalized projective representatives, or avoid using global projectivity
transport as a Lean-backed step. State explicitly whether line normals are transformed by
`(T^{-1})^T` and account for projective rescaling.

### 6. Major — referee-facing documentation is incomplete and contains strength/status prose

**Location:** throughout both modules, especially
`ReflectionArrangements.lean:3-9,43-50,70-83,114-134,152-170,188-221,239-273` and
`ReflectionArrangementDecoding.lean:4-18`.

Most intended public definitions and many claimed public theorems have no self-contained docstring.
Examples include `dot`, `tau11_relation`, both finite point-set constructors, the determinant and
point-map theorems, multiplicity loci, the exact fivefold theorem, `tau5_relation`, the `A3` spectrum,
and every S7 theorem. The module header relies on “the Clebsch paper,” “existing” theorems, and
implementation chronology rather than stating the exact mathematical scope and trust boundary.
The decoder source uses the vague phrase “paper-facing level.” The `projectiveVec5` and fivefold-index
docstrings call chosen enumerations “canonical” without stating the normalization/uniqueness
property. The tau judgment log also asserts, without a theorem or cited route, that the conjugate root
gives a projectively equivalent arrangement.

**Impact:** even corrected theorem types would not meet the repository's referee-facing artifact
standard on a cold read.

**Required fix:** give every ledger terminal and non-obvious public definition a precise docstring;
replace workflow/paper-status phrasing by ordinary mathematics; describe the first-nonzero-coordinate
normalization; and either prove/cite or remove every equivalence/strength statement. The module header
should enumerate the finite fields, coordinate conventions, terminal results, computation method,
and residual conceptual inputs.

### 7. Major — the task checklist records checks that have not been met

**Location:** C222 report
`notes/2026-07-16-c222-lean-a3-h3-closure.md:243-281`.

The checked statement-adequacy item misses findings 1, 2, 4, and 5. The checked prose/name item misses
finding 6. The checked finite-computation evidence item names only an internal task-level
“computer-assisted arrangement enumeration,” not the exact durable replay artifact, command,
version/hash, coverage, or result. The checked adequacy-appendix item supplies summaries and
abbreviated terminal names, not verbatim theorem statements and load-bearing definitions or a
deterministic extraction. The proposed ledger uses ellipses rather than fully qualified declaration
names, despite the local requirement.

**Impact:** reviewer agents cannot safely treat the checklist as evidence, and the report is not yet
sufficient for archival or C320 reconciliation.

**Required fix:** reopen the affected boxes, record this review and each remediation, use fully
qualified names, identify the exact independent replay or explicitly say none exists, and include a
deterministic adequacy extraction plan/output. After all source and report changes, the implementer
must stop and ask the user to launch a post-fix review.

## Exact claim inventory

### Safe to claim from the current source, conditional on later elaboration and axiom audit

- The chosen elements `8 : ZMod 11` and `3 : ZMod 5` satisfy `tau^2 = tau + 1`; in `ZMod 2`,
  `-1 = 1` and no element satisfies that equation.
- The six explicitly listed `ZMod 11` vectors have every pairwise-distinct triple determinant
  nonzero.
- The fifteen explicitly indexed joins and fifteen explicitly indexed root-direction vectors give
  two projective sets of cardinality fifteen with two-sided `SameDirection` coverage.
- The displayed matrix has determinant `3 : ZMod 11`; the six point rows and fifteen dual-line rows
  satisfy the stated `SameDirection` checks.
- For every one of the 133 fixed normalized representatives, the explicit mirror-incidence count
  equals `rawPointIndex` of its displayed linear image.
- The explicit `H3`-labelled and `A3`-labelled coordinate tables have the stated finite multiplicity
  spectra, and the six listed fivefold indices give exactly the multiplicity-five locus.
- The five S7 integer equalities and polynomial factorizations hold as arithmetic identities.
- The current decoder terminal proves the conjunction of its eight cardinality equalities.

These are source-level claims only until the current build and axiom evidence is recorded.

### Blocked from a Lean-formalized label

- A general-field golden-ratio parameter theorem.
- Identification of the coordinate tables with the `H3` and `A3` reflection arrangements without a
  formal semantic bridge or an explicit conceptual/citation route.
- Equality of the `A3` join and braid-mirror projective sets from the current one-sided theorem.
- Lattice faithfulness in characteristic five.
- Arrangement characteristic-polynomial, complement-code, or conic conclusions from the current
  bare arithmetic identities alone.
- A projective bijection/transport theorem for `h3Projectivity` and its dual action.
- Any geometric equivalence between `H3` multiplicity strata and decoder ambiguity strata, including
  the factor-ten affine-ray correspondence and the one-leader `90+6` decomposition.
- Every full-trust release label before the C222 gate, current elaboration, exhaustive axiom audit,
  pinned commit, Clebsch trust-manifest row, and post-fix independent `GO` exist.

## Checklist disposition and policy guards

- **Statement adequacy:** fail; findings 1, 2, 4, and 5.
- **Quantifiers, hypotheses, and vacuity:** fail for the one-sided `A3` coverage and overgeneralized
  S1 prose; no empty-domain or baked-conclusion defect was found in the principal finite checks.
- **Comments, names, and self-containment:** fail; finding 6. No internal task ID or novelty claim was
  found in the two C222 Lean sources.
- **Trust route:** provisional; direct source uses kernel tactics and the project-owned closure scan
  is clean, but the gate and live axiom evidence are absent.
- **Gate coverage:** fail; no C222 gate exists.
- **Compactness:** pass at source shape. The two modules are small and contain no generated
  certificate tree. Runtime/profile feasibility remains unmeasured in this review because no build
  was authorized.
- **Report and judgment log:** fail; finding 7. The representation, kernel-`decide`, sharding, and
  pointwise-bridge choices are useful, but their claim impact is overstated and the conjugate-root
  assertion lacks a route.
- **Archival readiness:** fail. C222 remains active.

Add these guards to the C222 repair checklist and copy the applicable ones into later Clebsch task
documents:

1. A theorem advertised as identifying two structures must contain a map and a relation or
   equivalence in its type; conjunctions of census numbers are labelled only as joint censuses.
2. Every finite-set equality claim must audit both directions and cardinality/distinctness; an
   existential image statement alone is not equality.
3. Every semantic noun in a declaration or docstring (`H3`, `A3`, characteristic polynomial,
   projectivity, decoder stratum, lattice-faithful) must be present in the formal type or assigned an
   explicit conceptual/citation route in the ledger.
4. Every claimed terminal receives an explicit fully qualified name, gate import, and individual
   axiom-audit entry; never infer coverage from a neighboring terminal.
5. Strength/status words in source (`agree`, `complete`, `canonical`, `paper-facing`) require a
   matching theorem or are replaced by exact neutral language.
6. A checked report box must point to durable evidence. Expected output, internal-task provenance,
   or an abbreviated theorem summary does not satisfy it.

## Final disposition

**READY FOR FIXES.** The compact coordinate work appears promising and several finite statements are
substantive, but C222 does not yet prove the advertised decoder connection or full `A3` identification,
and its prose/trust report currently overstates the types. After the implementing agent fixes or
narrows every finding, completes the gate and evidence, and updates the judgment log and C320 delta,
it must stop and ask the user to launch Codex for post-fix review. This review does not authorize
archival.
