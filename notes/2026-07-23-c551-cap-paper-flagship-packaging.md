# C551 — flagship packaging for the cap-game program

**Lane:** `cap`. **Status:** complete. **Mode:** packaging in parallel with active research.

## Mandate

Package the cap-game results for a very strong paper target without freezing
the odd-q research program or prematurely converting the live proof frontier
into submission prose.

This task owns architecture, theorem/claim inventory, trust normalization, and
headline gates. It does not own C528's defect-skeleton theorem, C80's uniform
descent, a q29 computation, or the odd-q crown itself.

## Flagship thesis

The paper should not read as a catalogue of solved boards. Its organizing
claim is that impartial cap building in finite incidence geometries has two
structural regimes:

```text
global symmetry:
fixed-point-free incidence-preserving involutions
→ uniform second-player strategies and infinite P-families

residual capacity degradation:
frame reduction
→ mixed pair/triple constraints
→ conic localization and structured Node--Kayles/defect games
```

The closed affine, binary-projective, odd-dimensional odd-field, even-plane,
and classical-variety families establish the reach of the first regime. Odd
projective planes expose its exact boundary and motivate the second.

The active odd-q crown can strengthen this thesis but is not allowed to hold
the packaging work hostage.

## Expository frame — Milner / Serre

The exposition should combine two disciplines.

### Milner: interfaces before implementations

- Define the game semantics once: positions, legal extension, normal-play
  value, Grundy value, and value transport.
- Present every geometric mechanism through an explicit contract:
  hypotheses, induced move correspondence, and outcome conclusion.
- Keep mathematical semantics separate from representations: coordinates,
  canonicalization, solvers, certificates, and Lean encodings implement or
  verify an interface but do not define the result.
- Make composition visible. The reader should be able to see exactly how
  incidence symmetry gives a game bisimulation, and how frame reduction,
  capacity degradation, conic localization, and residual play compose.
- Use dependency diagrams and small commuting squares where they replace
  repeated prose; do not expose internal proof-engineering chronology.

### Serre: economy, decisive examples, and a single main line

- Introduce each abstraction only after the smallest example that forces it:
  one successful fixed-point-free mirror, one failed mirror chord, and one
  residual conic/defect position.
- Use the minimum notation needed to state the theorem cleanly. Coordinate
  formulas appear only when they perform work.
- Put the strongest theorem first, then the mechanism, then the necessary
  lemmas. Do not make the reader reconstruct the result from a development
  diary.
- Separate the conceptual proof from finite verification. Main text states
  what the certificate establishes and why it is sufficient; schemas,
  hashes, checker mechanics, and large tables live in dedicated verification
  material.
- Prefer one sharp counterexample to a taxonomy of failed attacks. Negative
  results enter only when they reveal the exact boundary of a positive
  theorem.

### Combined page-level rule

Every main section should answer, in this order:

```text
What is the mathematical phenomenon?
What is the exact interface theorem?
Why do its hypotheses hold here?
What new family or reduction follows?
What remains outside the theorem?
```

This keeps the formal precision compositional without making the paper read
like software documentation, and keeps the geometry elegant without hiding
the game-semantic or computational trust boundary.

## Provisional architecture

1. **Cap achievement games and finite-incidence semantics**
   - normal-play convention and cap legality;
   - relation to known hypergraph building-avoidance and Nofil;
   - conservative line-capacity vocabulary, with no new-game-class claim.
2. **General second-player mechanisms**
   - the exact pair-extension mirror condition;
   - fixed-point-free incidence-preserving involutions;
   - capacity-mirror obstruction explaining failed naive mirrors.
3. **Uniform outcome families**
   - all finite affine spaces;
   - binary projective spaces;
   - odd projective dimension over odd fields;
   - even-order projective planes.
4. **Classical varieties and the mirror boundary**
   - include only if the quadric/Hermitian/Baer results reinforce the central
     mechanism without turning the paper into a classification catalogue;
   - otherwise split them into a companion paper with a clean forward pointer.
5. **Odd projective planes**
   - frame and residual-grid reduction;
   - size-three escape equivalence and conic localization;
   - exact rank-three residual hypergraph and Node--Kayles guard;
   - proved bounds, local reductions, and sharp failed mechanisms.
6. **Exact finite evidence**
   - normalized trust table for q=3 through q=25;
   - separate root outcomes, escape-layer results, rules certificates, and
     Lean-unconditional theorems;
   - `PG(4,3)` as higher-dimensional evidence.
7. **The active crown**
   - state the uniform odd-q theorem only if proved;
   - otherwise end with the exact coupled-defect/mex theorem gap rather than a
     loose list of computational observations.

## Packaging deliverables

### A. Theorem and trust ledger

For every proposed headline or supporting result record:

- exact mathematical statement and quantifier domain;
- exact Lean module and fully qualified terminal theorem, when formalized;
- axiom profile and validation gate;
- computational report/script/certificate bundle, if finite;
- trust tier: theorem, Lean certificate, independently rules-certified,
  exhaustive computation, or exploratory evidence;
- manuscript role and whether the result survives removal of the odd-q crown.

### B. Claim and novelty matrix

Separate:

- known game-theoretic infrastructure: normal-play hypergraph avoidance,
  Nofil, Node--Kayles, pairing, and generic involution strategies;
- standard finite geometry: caps/arcs, conics, projective frames, classical
  varieties, and established extremal bounds;
- candidate paper contributions: projective/affine outcome families, the
  exact mirror obstruction and method boundary, residual capacity degradation,
  and the proved odd-plane reductions.

Any priority or absence-of-prior-work sentence must pass the repository's
literature-audit convention before entering manuscript prose.

### C. Inclusion/split decision

Score each classical-variety result against three tests:

1. Does it strengthen the same central mechanism?
2. Does it have a paper-readable theorem statement without a long
   classification detour?
3. Would removing it make the flagship argument materially weaker?

Results failing two tests move to a companion-paper outline rather than an
appendix dump.

### D. Manuscript assets

- one theorem table organized by mechanism, not chronology;
- one trust table for fixed-q claims;
- one diagram of the frame/grid/conic/residual reduction;
- one diagram contrasting global mirror and local capacity degradation;
- a terminology/notation sheet shared with the Lean theorem names;
- a Milner/Serre exposition audit for every main section;
- an explicit exclusion ledger preventing internal task history, solver
  transcripts, and superseded attacks from leaking into the paper.

## Headline gates

### Crown lands

If C528/C80 closes the odd-q theorem, promote it to the main projective-plane
headline and use the residual theory as the proof engine. The universal
families become the breadth theorem surrounding the crown.

### Crown remains open

The paper remains flagship-viable only if its main theorem package reads as a
unified structural result:

```text
multiple infinite affine/projective/classical P-families
+ exact mirror criterion and obstruction
+ rigorous reduction of the first open family to a structured residual game.
```

Fixed-q computations then support and delimit the conjecture; they do not
substitute for a uniform headline.

## Immediate work

1. Extract the exact theorem ledger from the current Lean terminals.
2. Normalize the q-specific trust table, especially q17/q19/q23/q25.
3. Draft a one-page claim hierarchy: headline, main theorems, structural
   propositions, computational evidence, and open crown.
4. Apply the inclusion/split test to the classical-variety harvest.
5. Produce a manuscript skeleton containing theorem slots and dependencies,
   not polished exposition.

## Acceptance

C551 succeeds when the repository contains:

- a complete theorem/trust ledger with exact formal and computational
  provenance;
- a claim/novelty matrix and audit queue;
- an inclusion/split verdict for the classical-variety material;
- a flagship manuscript architecture with crown/no-crown variants;
- a section-level Milner/Serre exposition map;
- a short list of genuinely load-bearing missing results.

It does not require a frozen abstract, journal selection, submission schedule,
or completed odd-q proof.

## Packaging result

The paper package is viable without the odd-order-plane crown, provided the
main result is stated as a structural theorem package rather than as a
classification of all projective spaces.  The stable headline is:

> Fixed-point-free incidence symmetry gives uniform second-player wins on
> several infinite affine, projective, and quadric families; the first family
> outside that mechanism, odd-order projective planes, reduces exactly to a
> rank-three residual game whose pair-only region is Node--Kayles.

The crown version replaces the final reduction clause by the uniform odd-plane
outcome theorem.  No fixed-\(q\) computation is needed to state the stable
headline.

The section-level manuscript skeleton and its two headline variants are in
`notes/2026-07-23-c551-cap-paper-manuscript-skeleton.md`.

### Three-interface compression

The theorem package compresses further than the family list suggests.  The
paper has only three genuinely different interfaces:

1. **Symmetry interface:** an involutive incidence automorphism satisfying the
   pair-extension contract gives a P-position.  Whole spaces and invariant
   subboards are instances.
2. **Transport interface:** an equivalence preserving legal positions and
   moves preserves P/N value.  Binary representatives, coordinate changes,
   frame normalization, and projective-linear transport are instances.
3. **Residual-rank interface:** after fixing an old cap state, minimal new
   obstructions have size two or three; eliminating the triples leaves the
   conflict-graph game.

The affine/projective/quadric theorem table should be presented as the
corollary surface of these interfaces.  This avoids making the main result
look like four unrelated tricks and gives the odd-plane reduction a natural
place in the same theorem package.

### Formal-core submission cut

The main mathematical paper can be made independent of every native solver,
raw table, and generated fixed-q certificate:

```text
formal core
  F1--F4
  + M1--M3
  + Q+/Q−
  + R1--R7

optional evidence annex
  q-specific rows
  + PG(4,3)
  + checker and certificate architecture
```

Deleting the optional annex changes motivation and conjectural evidence but
does not remove a premise from any main theorem or proof.  Q11/Q13 may remain
as formal illustrations, but they are not needed for the headline.  This is
the safest first release shape if evidence normalization or generated-source
review becomes the schedule bottleneck.

## Trust vocabulary

The manuscript must keep two independent axes.

| Mathematical status | Meaning |
|---|---|
| `LEAN-THEOREM` | the quantified statement is checked by Lean |
| `LEAN-CERTIFICATE` | Lean checks finite data and the theorem transporting it |
| `RULES-CERTIFIED` | an independent native checker validates the game equations and coverage |
| `EXHAUSTIVE-COMPUTATION` | an exact solver exhausts the stated finite domain |
| `EXPLORATORY` | a partial, sampled, or sizing computation |
| `OPEN` | conjecture or missing uniform implication |

| Publication-evidence readiness | Meaning |
|---|---|
| `READY-FORMAL` | exact terminal, module, and axiom audit are repository-visible |
| `READY-BUNDLE` | report, generator/checker, compact certificate or approved manifest, replay command, hashes, and independent check are committed |
| `NORMALIZATION-DEBT` | the mathematical result may be sound, but the current record predates or misses one of those bundle requirements |

`LEAN-THEOREM` and `READY-FORMAL` are deliberately not synonyms: a paper-facing
formal claim still needs a referee-facing dependency-closure prose audit.
Likewise `RULES-CERTIFIED` does not imply `READY-BUNDLE` when the checked raw
tables are machine-local and lack a committed hash manifest.

## A. Theorem and trust ledger

All Lean declarations below have the ordinary specification-match boundary:
Lean proves the formal game stated in `FiniteBuildGame`, `CapGame`, and
`ProjectiveCap`; the independent grid engines and certificate checkers are the
external adequacy checks for the intended rules.  Unless a row says otherwise,
the repository's terminal audits report the standard non-project-specific
profile `[propext, Classical.choice, Quot.sound]`; no row relies on
`native_decide`.

### Headline family theorems

| ID | Exact mathematical statement | Formal terminal | Trust / gate | Manuscript role | Crown-independent? |
|---|---|---|---|---|:---:|
| F1 | Every positive-dimensional finite affine space `AG(n,K)` is P | `CapGame/Affine.lean`, `CapGame.Affine.initialP_fin`; representation-independent form `CapGame.Affine.initialP_of_nontrivial` | `LEAN-THEOREM`; theorem is symbolic, with characteristic-two translation and odd-characteristic point-reflection branches | first infinite family; introduces adaptive blocking of a fixed mirror centre | yes |
| F2 | `PG(n,2)` is P for every `n≥1` | `ProjectiveCap/Binary.lean`, `ProjectiveCap.Projective.initialPStatement_binary_of_projectiveDim_ge_one`; rank form `initialPStatement_binary_of_finrank_ge_two` | `LEAN-THEOREM`; transported through `binaryPointEquivNonzero` and `binary_nonzeroValid_iff_cap` | binary projective family and exact Nofil/STS specialization | yes |
| F3 | `PG(2m−1,q)` is P for every `m≥1` and odd finite-field order `q` | `ProjectiveCap/EllipticMirror.lean`, `ProjectiveCap.Projective.initialPStatement_of_odd_card_finrank_eq_two_mul` | `LEAN-THEOREM`; symbolic nonsquare elliptic-block mirror | strongest whole-board projective family | yes |
| F4 | `PG(2,q)` is P for every even finite-field order `q` | `ProjectiveCap/PlaneOutcome.lean`, `ProjectiveCap.initialPStatement_of_even_card_finrank` | `LEAN-THEOREM`; characteristic-two residual-grid mirror | closes the even-plane half and marks the odd-plane boundary | yes |

### Mechanism and subboard theorems

| ID | Exact statement | Formal terminal | Trust / gate | Manuscript role |
|---|---|---|---|---|
| M1 | A fixed-point-free collinearity-preserving involution of projective points makes the empty cap game P | `ProjectiveCap/Mirror.lean`, `ProjectiveCap.Projective.initialPStatement_of_fixedPointFree_collinearity_preserving_involution` | `LEAN-THEOREM` | central whole-board interface theorem |
| M2 | The same conclusion holds on any invariant projective subboard `Q` | `ProjectiveCap/HyperbolicQuadricMirror.lean`, `ProjectiveCap.Projective.initialSubCapP_of_fpf_collinearity_preserving` | `LEAN-THEOREM`; audited profile `[propext, Classical.choice, Quot.sound]` | one theorem from which the included quadric corollaries follow |
| M3 | If a linear equivalence squares to a nonsquare scalar and preserves `Q`, the subboard cap game is P | same module, `initialSubCapP_of_linearEquiv_sq_scalar_nonsquare` | `LEAN-THEOREM` | coordinate-friendly corollary interface |
| Q+ | The hyperbolic quadric subboard `Q⁺(2m−1,q)` is P for odd `q` in the displayed block model | same module, `initialSubCapP_blockQuadric_of_odd_card` | `LEAN-THEOREM`; terminal audit `[propext, Classical.choice, Quot.sound]` | included one-page classical-variety corollary |
| Q− | The displayed standard/norm-block elliptic quadric subboards admit the same P mirror over odd finite fields, and the value transports to every presentation equipped with a projective linear equivalence to that model | `ProjectiveCap/EllipticQuadricMirror.lean`, `initialSubCapP_standardEllipticQuadric_of_nonsquare`, `exists_standardEllipticQuadric_initialSubCapP`, `initialSubCapP_normBlockQuadric_of_odd_card`, and `isP_subCap_mapLinearEquiv` | `LEAN-THEOREM`; coordinate-exact construction plus an exact supplied-equivalence transport, not an unqualified classification of all presentations | included as a second corollary with the equivalence hypothesis visible |

### Odd-plane reductions and residual structure

| ID | Exact statement | Formal terminal | Trust / gate | Manuscript role | Crown-independent? |
|---|---|---|---|---|:---:|
| R1 | In vector rank three, the initial projective position is P iff the residual odd-escape statement holds | `ProjectiveCap/TrapConverse.lean`, `ProjectiveCap.GridGame.TrapConverse.initialPStatement_iff_oddEscapeStatement_finrank` | `LEAN-THEOREM` | exact falsification equivalence; backbone of the odd-plane section | yes |
| R2 | Every legal residual size-three state has exactly `q²−9q+21` legal extensions | `ProjectiveCap/ExtensionCount.lean`, `ProjectiveCap.sizeThreeExtensionCount`, proving `ProjectiveCap.Stable.SizeThreeExtensionCountStatement` | `LEAN-THEOREM` | shows that escape is a value problem, not move availability | yes |
| R3 | Full `PGL(2,q)` transport preserves the game value of an on-conic parameter set | `ProjectiveCap/Sym2ConicBridge.lean`, `ProjectiveCap.Sym2Bridge.onconic_value_bridge` | `LEAN-THEOREM` | makes one representative per full-PGL bucket sufficient once bucket values are certified | yes |
| R4 | Grid-cap validity is rank at most three; every minimal bad extension on legal vertices has size two or three | `ProjectiveCap/ResidualHypergraph.lean`, `gridCap_iff_allSmallSubsetsCap`, `minimal_bad_extension_card` | `LEAN-THEOREM`; audited profile `[propext, Classical.choice, Quot.sound]` | exact residual hypergraph theorem |
| R5 | If no active minimal triples remain, continuation validity is determined by its two-point restrictions | same module, `ProjectiveCap.ResidualHypergraph.gridCap_union_iff_all_pairs` under `NoActiveResidualTriples` | `LEAN-THEOREM`; audited profile `[propext, Classical.choice, Quot.sound]` | static `Y_NK`/conflict-graph interface; persistence is stated separately |
| R6 | The isolated capacity-two gadget has Grundy value zero; follower signatures bound Grundy value | same module, `FiniteBuildGame.grundy_atMostTwo_empty_eq_zero`, `FiniteBuildGame.grundy_le_card_of_follower_signature` | `LEAN-THEOREM`; audited profile `[propext, Classical.choice, Quot.sound]` | neutral-bulk lemma and exact location of the missing bounded-signature theorem |
| R7 | Pair budgets bound gadget count, large-gadget count, and total overload | `ProjectiveCap/ResidualPairBudget.lean`, `pairBudget`, `card_le_pairBudget_div_three`, `largeMembers_card_le_pairBudget_div_choose`, `totalOverload_le_pairBudget_div_three` | `LEAN-THEOREM`; audited profile `[propext, Classical.choice, Quot.sound]` | supporting bounds; not an explanation of the observed small SG |

### Fixed small-field theorems

| q | Exact terminal | Mathematical trust | Publication readiness | Role |
|---:|---|---|---|---|
| 5 | `ProjectiveCap.initialPStatement_of_card_eq_five_finrank` in `ProjectiveCap/PlaneOutcome.lean` | `LEAN-THEOREM`, symbolic mechanism | `READY-FORMAL` after dependency-closure prose audit | finite base theorem |
| 7 | `ProjectiveCap.initialPStatement_of_card_eq_seven_finrank` in the same module | `LEAN-THEOREM`, symbolic mechanism | `READY-FORMAL` after dependency-closure prose audit | finite base theorem |
| 11 | `ProjectiveCap.Certificate.CertData.Q11.initialPStatement_finrank` in `ProjectiveCap/CertData/Q11Assembly.lean` | `LEAN-CERTIFICATE`; terminal `#print axioms` is present | `READY-FORMAL` only after the generated closure receives the referee-facing artifact audit required by `lean/AGENTS.md` | flagship finite formal certificate |
| 13 | `ProjectiveCap.Certificate.CertData.Q13.initialPStatement_finrank` in `ProjectiveCap/CertData/Q13Assembly.lean` | `LEAN-CERTIFICATE`; terminal `#print axioms` is present | same generated-closure audit required | flagship finite formal certificate |

## B. Normalized fixed-q trust table

The `claim` column states only what the listed evidence supports.  In
particular, an all-P on-conic bucket census is not silently promoted to a
fully formal plane theorem.

| q | Claim permitted now | Mathematical status | Exact provenance | Publication readiness / missing gate |
|---:|---|---|---|---|
| 3 | `PG(2,3)` computed P | `EXHAUSTIVE-COMPUTATION` | `notes/2026-07-06-grid-cap-solver.rs` and the tracked early solver record summarized in the cap handoff | `NORMALIZATION-DEBT`: isolate the exact run, domain, output, hashes, and an independent replay |
| 5 | `PG(2,5)` is P | `LEAN-THEOREM` | F5 terminal above | formal dependency-closure prose audit |
| 7 | `PG(2,7)` is P | `LEAN-THEOREM` | F7 terminal above | formal dependency-closure prose audit |
| 9 | `PG(2,9)` computed P | `EXHAUSTIVE-COMPUTATION`; the terminal-reply kernel is not assembled into a plane theorem | solver plus `notes/2026-07-07-codex-q9-intrusion-probe.md` | `NORMALIZATION-DEBT`: commit a compact replay/certificate bundle or close C13 in Lean |
| 11 | `PG(2,11)` is P | `LEAN-CERTIFICATE` | Q11 assembly terminal above | generated dependency-closure prose audit |
| 13 | `PG(2,13)` is P | `LEAN-CERTIFICATE` | Q13 assembly terminal above | generated dependency-closure prose audit |
| 17 | `PG(2,17)` computed P; anchored books passed the independent rules checker (`210/210`), and a canonical book passed `21/21` with `100,526` nodes | `RULES-CERTIFIED`, not Lean-unconditional | `notes/2026-07-08-codex-route-c-phase5.md`; exact solver/checker source `notes/2026-07-06-grid-cap-solver.rs` | `NORMALIZATION-DEBT`: the cited cert books were left under `/tmp`; produce an approved compact certificate or durable hash/storage manifest before manuscript use |
| 19 | `PG(2,19)` computed P; anchored books passed the independent rules checker (`272/272`) | `RULES-CERTIFIED`, not Lean-unconditional | same C30 report and solver/checker | `NORMALIZATION-DEBT`: same missing durable certificate/manifest; no Lean assembly |
| 23 | every one of the 22 full-PGL on-conic S4 buckets is P and its early-break proof DAG is rules-certified (`241,627,613` records, zero failures); the full-PGL transport theorem is Lean-checked | `RULES-CERTIFIED` at the S4 bucket layer; not a Lean initial-position theorem | `notes/2026-07-09-codex-q23-bucket-certification.md`, `rust/scripts/s4-c54-check-suite.sh`, R3 | `NORMALIZATION-DEBT`: add approved durable raw-table manifest with hashes/byte counts/storage and a fixed-q Lean consumer or carefully state the native trust boundary |
| 25 | all 28 full-PGL on-conic S4 bucket representatives were exhaustively labeled P; this is evidence for `(ON)`, not a claimed full-plane theorem | `EXHAUSTIVE-COMPUTATION` at the on-conic bucket layer | `notes/2026-07-09-codex-q25-baer-census.md`, `notes/data/c68b-onconic-buckets-q25.txt`, solver | `NORMALIZATION-DEBT`: no C54-style independent rules check, no durable proof-DAG bundle, and no fixed-q assembly |
| all odd q | conjectural P | `OPEN` | R1--R7 delimit the exact structural gap | prove uniform descent/bounded residual signature; fixed-q data cannot replace it |

`PG(4,3)=P` belongs in the evidence section, not the plane table:
`EXHAUSTIVE-COMPUTATION`, 25,258 orbit-canonical memo states, with forward and
reverse move order and an independent canonicalization agreeing, as recorded
in `notes/2026-07-09-codex-pg43-sizing.md`.  It has
`NORMALIZATION-DEBT` under the current paper-facing reproducibility convention.

## C. Claim and novelty matrix

This task issues no new absence-of-prior-work verdict.  Zero external sources
were newly characterized at full-text depth.  The 2026-07-08 projective-Nofil
audit predates the mandatory read-depth, cache-hash, three-graph
forward-citation, and unreachable-source fields in
`notes/literature-audit-conventions.md`; its proposed “to our knowledge”
sentence is therefore not manuscript-licensed.

| Object | Classification for packaging | Permitted manuscript treatment | Audit action |
|---|---|---|---|
| normal-play impartial hypergraph building avoidance / Nofil | known infrastructure | define and attribute; do not rename as a new game class | refresh primary-source full-text record and exact ruleset pin |
| Node--Kayles and graph-independence play | known infrastructure | cite for the pair-only residual; do not claim the bare collapse | full-text theorem/page pin |
| generic pairing and involution strategies | known method | present as mechanism, not novelty | identify the closest general theorem or label as standard folklore with sources |
| caps, arcs, frames, conics, quadrics, Hermitian varieties | standard finite geometry | use standard definitions and separately identify project-owned game conclusions | source each imported classification/bound |
| finite-field fixed-point-free elliptic projective involutions | classical geometric ingredient | state that the game application is the contribution candidate, not the involution | pin a standard source for the construction/classification |
| affine and projective infinite P-family outcomes F1--F4 | candidate contribution | exact theorem statements are safe; historical novelty sentence remains gated | new full novelty audit, including identifier-pinned citation graphs |
| exact pair-extension mirror obligation / capacity-mirror obstruction | candidate structural contribution, wording-sensitive | claim the exact formal criterion; describe the obstruction as the reason naive copycat fails | search general impartial building games and pairing-strategy literature |
| residual capacity degradation and rank-three decomposition R4--R5 | candidate structural contribution | claim exact projective residual theorems; do not claim generic Nofil-to-graph collapse | audit structured finite-incidence antecedents |
| conic localization and involution residual | mixed: standard conic geometry plus candidate game reduction | separate the classical five-arc/conic facts from the game-semantic reduction | audit finite-geometry games and conic graph constructions |
| fixed-q solver/certificate methodology | software/verification contribution, not a new mathematical game | describe trust interfaces and replay material in verification appendix | compare proof-carrying game solvers only if headlined |
| odd-q all-P theorem | open crown | conjecture only until terminal theorem exists | novelty audit only after proof shape stabilizes |

### Literature audit queue

1. Rebuild the Nofil/ruleset audit with full-text markers, cache keys and
   SHA-256 values for every named source.
2. Pin the closest general pairing/involution theorem and determine whether
   the pair-extension obstruction is already explicit.
3. Audit the four infinite outcome families by identifiers, including
   OpenAlex, Crossref, and Semantic Scholar forward graphs for every seed used
   in a negative.
4. Audit structured residual-capacity/Node--Kayles antecedents; keep the bare
   hypergraph-to-graph collapse out of the contribution column.
5. Retrieve the inaccessible colored finite-geometry avoidance source before
   drawing any ruleset comparison.
6. Do not add “first,” “new,” “apparently,” or “to our knowledge” to the
   manuscript until the resulting report satisfies the current convention.

## D. Classical-variety inclusion/split verdict

| Result group | Same mechanism? | Paper-readable without classification detour? | Material if removed? | Verdict |
|---|:---:|:---:|:---:|---|
| invariant-subboard mirror theorem M2/M3 | yes | yes | yes | include in the mechanism section |
| hyperbolic quadric `Q⁺(2m−1,q)` P corollary | yes | yes | yes: demonstrates that the mechanism is not confined to full spaces | include, one theorem plus one proof paragraph |
| coordinate-exact elliptic quadric P corollaries | yes | yes if qualifications remain explicit | moderately: overturns the false impression that elliptic type is excluded | include one representative corollary; move coordinate variants to appendix/formal companion |
| parabolic linear and scalar-square exclusions | boundary of the mechanism | no: requires eigenspace/isotropy case analysis | no for the flagship theorem package | split to a mirror-boundary companion |
| Hermitian linear exclusions | boundary only | no | no | split |
| Baer-semilinear parabolic/Hermitian stabilizer routes | boundary only | no: substantial Frobenius descent and null-cone rigidity | no | split |
| finite modeled checks `H(2,9)`, `H(3,4)`, and trivial ovoid rows | illustrative catalogue | yes individually, but not load-bearing | no | omit from flagship; retain in companion/table |

The flagship therefore includes the general subboard theorem and two positive
quadric corollaries.  `MirrorBoundary.lean`, `BaerSemilinear.lean`,
`BaerQuadraticUntwist.lean`, `QuadraticNullCone.lean`, and
`BaerQuadraticStabilizer.lean` support a coherent companion paper about the
classification boundary of the mirror method.  They should receive one
forward pointer, not an appendix dump.

The conceptual statement in the flagship is the **invariant zero-locus
schema**, not a list of named varieties: whenever a fixed-point-free
projective involution preserves the zero locus (or any other point predicate),
M2 makes its ambient-collinearity cap game P.  The quadric rows are decisive
examples discharging that predicate-preservation obligation.  This schema is
already exactly formalized by arbitrary `Q`; it requires no new abstraction
or Lean theorem.

## E. Manuscript assets and terminology

### Mechanism theorem table

| Mechanism | Hypothesis contract | Consequence | Families |
|---|---|---|---|
| translation copycat | fixed-point-free affine involution with pair-extension validity | initial P | characteristic-two affine spaces |
| blocked-centre reflection | fixed centre is made illegal by the opening exchange; later pair extensions stay valid | initial P | odd-characteristic affine spaces |
| whole-board elliptic mirror | fpf collinearity-preserving projective involution | initial P | odd-dimensional projective spaces over odd fields |
| residual translation | frame/grid transport plus characteristic-two translation | initial P | even-order projective planes |
| invariant-subboard mirror | whole-board contract plus `Q(x)⇒Q(σx)` | empty subboard P | included quadric families |
| capacity degradation | fixed old state; minimal residual obstructions have rank two or three | mixed conflict graph/triple game; Node--Kayles when active triples vanish | odd-plane residual |

### Notation sheet

| Paper notation | Meaning | Lean name |
|---|---|---|
| `P`, `N` | previous-player / next-player win under normal play | `FiniteBuildGame.IsP`, `FiniteBuildGame.Win` |
| `G(S)` | Grundy value of position `S` | `FiniteBuildGame.Grundy Valid S` |
| `Cap_K(V)` | projective cap-validity predicate | `ProjectiveCap.Projective.Cap K V` |
| `GridCap_K` | residual row/column-sparse affine cap | `ProjectiveCap.GridCap` |
| `L(S)` | legal residual extensions | `ProjectiveCap.GridGame.LegalExtensions S` |
| `NoTriples(S)` | no inclusion-minimal bad legal extension of size three | `ResidualHypergraph.NoActiveResidualTriples S` |
| `(ON)` | every residual size-three state has a P-valued on-conic child | `OnConicEscapeStatement` |
| `Q|_B` | cap game restricted to a point predicate `B` | `Projective.SubCap B` |

Use “P-position” only for normal-play outcome, “computed P” for an exact native
result, and “Lean theorem/certificate” only when the terminal implication is
kernel-checked.  Use “on-conic bucket layer” rather than “plane outcome” for
q=25.

### Working title fork

No title is frozen, but the architecture supports two honest forms:

- no crown: *Symmetry and residual capacity in cap-building games on finite
  geometries*;
- crown: *Cap-building games on finite geometries: symmetry, residual
  capacity, and odd projective planes*.

Both titles lead with the structural contribution rather than a catalogue of
boards.  The first remains correct if every optional computational row is
removed.

### Diagram specifications

```text
global symmetry
incidence-preserving involution
        │
        ├─ fixed-point-free ───────────────┐
        │                                  ▼
        └─ fixed locus blocked + pair-extension valid
                                           │
                                           ▼
                                  second-player copycat
                                           │
                         ┌─────────────────┼──────────────┐
                         ▼                 ▼              ▼
                    affine P       projective P      subboard P
```

```text
PG(2,q) initial game
        ⇕  frame transitivity
residual q×q grid
        ⇕  size-three escape equivalence
five-arc + two burned directions
        ↓  unique conic / q−4 on-conic candidates
rank-three residual hypergraph
        ├─ pair obstructions ── conflict graph
        └─ triple obstructions ─ capacity-two gadgets
                     │
        NoActiveResidualTriples
                     ▼
               static Node--Kayles
                     │
         uniform routing theorem OPEN
```

### Exclusion ledger

Do not put any of the following in the manuscript:

- task IDs, lane names, agent/model names, dates as theorem labels, handoff
  chronology, failed build transcripts, or superseded plans;
- internal names such as `Y_NK`, `capOK`, “C80(b),” “Route C,” “A5 anchor,” or
  “score-9” without replacing them by mathematical definitions;
- memo-table sizes in a theorem statement;
- claims that q=25 proves `PG(2,25)=P`;
- claims that q=23 is Lean-unconditional;
- claims that a native solver log is a durable certificate;
- claims that line-capacity avoidance is a new ambient game class;
- claims that fixed-point-free involutions, pairing, Nofil, Node--Kayles, or
  the bare hypergraph-to-graph collapse are new;
- negative-route catalogues.  Retain only the mirror-chord counterexample
  because it explains the exact positive hypothesis.

## F. Load-bearing missing results

1. **Uniform odd-plane routing.**  Prove that every residual state arising in
   the escape kernel reaches a pair-only P guard, or prove an equivalent
   bounded corrected-signature/mex theorem.  Current q=13,17,19 depth-two
   coverage is computation, not a uniform theorem.
2. **Dynamic Node--Kayles bridge.**  Package persistence and
   edge-preservation with R5 into one paper-facing game isomorphism theorem;
   R5 currently supplies the exact static half.
3. **Conic localization API.**  Select and cite the exact formal terminals
   for five-arc uniqueness and the `q−4` on-conic legal-extension statement,
   rather than relying on prose aggregation.
4. **Evidence normalization.**  Produce modern durable bundles for q=3,9,
   17,19,23,25 and `PG(4,3)`, or omit the affected numerical claims.
5. **Referee-facing Lean audit.**  Audit the transitive closures of every
   paper-cited terminal, especially generated Q11/Q13 data.
6. **Literature audit.**  Complete the six-item queue above before any
   historical novelty or priority sentence.

### Evidence-normalization return on effort

If a verification supplement is pursued, the highest-return order is:

1. **q=23:** preserve the already rules-checked 22-root chain with an approved
   durable raw-table manifest, hashes, byte counts, and storage location.  This
   is closest to `READY-BUNDLE`; no new solving is needed.
2. **`PG(4,3)`:** rerun or package the small 25,258-state computation with its
   independent canonicalization and move-order checks.  It is the cheapest
   evidence for the higher-even-dimensional open family.
3. **q=17:** regenerate the 21-class canonical book and retain a compact
   independently checkable certificate or manifest.  Prefer this over the
   much larger 210-class anchored book.
4. **q=3 and q=9:** normalize only if retained as historical base rows; the
   formal q=5,7,11,13 rows already carry the small-field story.
5. **q=19 and q=25:** defer until the supplement needs them.  q=19 duplicates
   the qualitative q=17 message at a larger certificate cost; q=25 lacks a
   C54-style independent checker and is only an on-conic-layer claim.

This ordering allocates no successor work.  It prevents the paper from
spending its first verification effort on the largest or least
decision-informative artifact.

## Mystery ledger

The closeout `ej`+`tt` pass settled three packaging ambiguities:

- **Could fixed-q evidence carry a no-crown paper?** No.  It belongs in a
  delimited evidence section; the stable headline must be F1--F4 + M1--M3 +
  R1--R7.
- **Do all classical-variety results belong?** No.  The positive invariant
  subboard corollaries reinforce the central mechanism; the parabolic,
  Hermitian, and Baer exclusion classification is a companion paper.
- **Can the old novelty sentence be reused?** No.  The old audit lacks the
  current mandatory read-depth and citation-graph record.

Open genuine mysteries:

| Mystery | Exact evidence gap / gate | Owner |
|---|---|---|
| Why does the coupled residual have very small observed Grundy values despite growing gadget complexity? | no uniform bound on corrected rooted boundary signatures or mex image | C528 |
| Is depth-two descent uniform in odd `q`? | checked only at q=13,17,19; no proof or q≥23 falsifier | C80/C528 |
| Are the four infinite outcome families absent from prior literature? | current-compliant novelty audit missing | successor literature audit under `cap` |
| Which computational rows can be made referee-ready without importing huge raw tables? | approved compact certificates/manifests missing | fixed-q evidence-normalization successors |

No other packaging mystery remains: the stable theorem package, split line,
trust vocabulary, and crown/no-crown architecture are fixed.
