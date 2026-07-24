# C507 / F14 — Lean mixed passage interfaces

**Lane:** `clebsch`

**Status:** queued task brief

This file is both the cold-read task specification and the durable result report. Complete it in
place with exact theorem names, artifacts, validation, axiom evidence, trust boundaries, judgment
calls, review dispositions, and the proposed C320 ledger delta.

## Required outcome and trust route

Give Paper 1's interface-heavy survival/forgetting rows an honest mixed-verification boundary:

- C451: formalize the finite matching/Lagrangian incidence and Arf computations used to show that
  the tested parity data does not detect the sheet;
- C455: formalize the explicit matrix restrictions and their adjoint, square, and trace
  identities.  Following independent review, eigenspace multiplicities and the claim that the
  two restrictions come from one ambient Fourier operator remain external: the finite tables do
  not by themselves supply those semantic interfaces, and no tautological direct-sum carrier may
  substitute for them;
- C456/C467: formalize the explicit state/code maps, finite bitorsor actions, and sheet-erasing
  equivalence witness, without claiming a classification of arbitrary LU invariants;
- C471, only if its compact Paper-1 shadow sentence remains adopted: formalize the exact mod-three
  kernel/image identities and puncture/shorten maps, leaving Golay/Lagrangian names at their
  separately justified boundary.

## Owned surface and dependencies

- Own only `lean/RelativeConicArcs/ClebschPassageInterfacesData.lean`,
  `lean/RelativeConicArcs/ClebschPassageInterfaces.lean`,
  `lean/RelativeConicArcs/Gates/ClebschPassageInterfaces.lean`, and this report.
- Consume only the adopted finite witnesses from C451/C455/C456/C467 and, conditionally, C471.
- Exit through `RelativeConicArcs.Gates.ClebschPassageInterfaces`.

## Required theorem and exclusion boundary

The gate exports direct finite kernels, matrices, actions, incidence counts, and equivalence
witnesses. Superspeciality, standard Schrödinger/Weil normalization, full quantum-LU
classification, uniqueness of Golay/Hadamard objects, and geometric parent canonicity remain named
external inputs unless their exact interfaces are independently formalized. If a semantic claim
cannot be cleanly decomposed, leave it certificate-plus-citation backed in C320 rather than adding
a project-local axiom.

## Validation and closing review

Before proof work read `lean/AGENTS.md` and the routed named-expert dossier. Use definitions-only
data, theorem-bearing checkers, exact provenance, independent replay, terminal axiom audits, and
guarded/unattended exact-target builds.

Completion requires artifact/report/checklist/C320 delta, user-launched independent review,
resolution or narrowing of every finding, user-launched post-fix review after changes, and recorded
final `GO`. The implementer may not select or simulate the reviewer.

## Result, judgment calls, validation, review, and C320 delta

### Result

The bounded mixed-verification package is implemented as:

- `RelativeConicArcs.ClebschPassageInterfacesData`, a definitions-only literal-data leaf;
- `RelativeConicArcs.ClebschPassageInterfaces`, the theorem-bearing checker and interface; and
- `RelativeConicArcs.Gates.ClebschPassageInterfaces`, the import-only gate and
  twenty-two-terminal axiom audit.

The exact formal exits are:

1. `genusThree_theta_value_counts` and `genusFive_theta_value_counts` kernel-check the
   `Q(S)=|S|/2 mod 2` value counts `36+28` and `496+528` on the complete canonical
   even-subset/complement representative spaces of sizes `64` and `1024`.
2. `seven_matching_lagrangian_signature`, `eleven_matching_lagrangian_signature`, and
   `theta_signature_erases_sheet` expose the frozen same-sheet intersection dimensions and
   weights: every off-diagonal intersection is a line, represented at q=7 by weight four with
   quadratic value zero and at q=11 by weight six with quadratic value one; both sheet labels
   give identical tables.
3. `rankEightFourier_square`, `rankSixteenFourier_square`, `signedFourier_square`,
   `rankEightFourier_weighted_adjoint`, `rankSixteenFourier_weighted_adjoint`,
   `signedFourier_weighted_adjoint`, and `Fourier_restriction_traces_zero` check the raw
   `8 x 8`, `16 x 16`, and signed `4 x 4` restrictions.  Their squares are `1331I`; all three
   are adjoint for their displayed orbit-indicator norm forms; and all three traces vanish.
4. `monomialTransport_bijective`, `monomial_column_intertwiner`, and
   `monomialTransport_kernel_equivalence` check the displayed permutation/scaling map between
   the parameter-eight and parameter-four parity checks.  The proof uses checked transport,
   inverse, row-intertwiner, and inverse-row-intertwiner matrix identities.
5. `fourierSupport_signed_transpose` and
   `signedSourceDualParam_eq_fourierSupportParam` identify the support matrix entrywise with
   `diag(-1,-1,-1,-1,+1,+1) H_8^T`.  Then `fourierSupportParam_injective` and
   `fixedParty_fourier_support_equivalence` prove that this signed source dual is exactly the
   target code kernel.  A checked left inverse and the exact decomposition
   `S R + K H_4 = I_6` replace word sampling and establish the complete kernel--image equality.
6. `markedSymmetry_card`, `marked_actions_commute`, and
   `marked_actions_free_transitive` formalize the regular left/right actions of
   `alternatingGroup (Fin 5)`: the abstract equivalence-index carrier has cardinality 60 and is
   a genuine bitorsor.

### Trust and exclusion boundary

Lean recomputes the two quadratic-value histograms and checks the displayed incidence summaries,
integer Fourier tables, all transport/inverse/decomposition matrices, and the abstract
sixty-element bitorsor laws.  It does not reconstruct the matching packings from projective
orbits, identify the bitorsor carrier with the enumerated 60 projective maps, or prove the
hyperelliptic divisor-theoretic interpretation of the binary subset model.  Those are
hash-pinned certificate or cited-input boundaries.

The formal Fourier statements are integer matrix statements.  The reported `4+4`, `8+8`, and
`2+2` eigenspace splits require scalar extension and the standard distinct-root/trace argument;
that eigenspace theorem remains external.  The package does not construct the ambient
`1331`-dimensional Schrodinger space, prove that the rank-eight and rank-sixteen tables are
restrictions of one ambient operator, fix a Gauss phase, or assert Weil naming.  The initial
tautological direct-sum carrier was removed after review because it supplied no evidence for the
common-ambient claim.

Character orthogonality converts `fixedParty_fourier_support_equivalence` into the exact
equal-amplitude state-vector equality in the source certificate.  Lean does not formalize complex
normalization, arbitrary phase deformations, arbitrary local-unitary invariants, or a
classification of AME states.  The geometric ordered-arc labels remain external advice.

Superspeciality, the positive-characteristic transfer of Mumford's theta-characteristic formula,
standard Schrodinger/Weil normalization, uniqueness or classification of Hadamard, Golay, or
Lagrangian objects, and geometric parent canonicity are not exported.  No project-local axiom was
introduced.

The conditional C471 leaf was not adopted: the current Paper-1 shipping plan retains C471 as a
Paper-2 proof with at most a pointer, and neither the copy-ready outline nor the guided
tour/conclusion draft contains the proposed compact mod-three kernel/image sentence.  Therefore
this task adds no Golay/Hadamard degeneration theorem by implication; C471 remains
certificate-backed outside this gate unless the manuscript owner later adopts that sentence.

### Judgment calls

- Canonical even-subset representatives use the last branch bit zero and the preceding parity bit
  forced by the free bits.  This gives exactly one representative of every even subset modulo
  complement and makes the finite Arf counts small enough for ordinary kernel reduction.
- The matching tables retain only the load-bearing intersection dimension and representative
  weight.  Reconstructing all frozen matchings in Lean would enlarge the artifact without
  strengthening the Paper-1 conclusion that the tested parity erases the sheet.
- The Fourier layer reuses the independently reviewed rank-eight checker and copies only the
  adopted rank-sixteen and signed matrices.  It now checks all three weighted adjoints and traces.
  Eigenspace multiplicities and the semantic common-ambient Weil identification remain external
  rather than being encoded as assertions.
- The code layer was strengthened during closeout from coordinate algebra to explicit inverse and
  decomposition matrices.  In particular, `S R + K H_4=I` makes the fixed-party support equality
  a complete linear theorem, not a `1331`-word sample.
- One initial source-inspection projection emitted more than the repository output budget.  It was
  discarded as evidence and replaced by field-specific bounded queries before any formal data was
  written.

### Artifacts and replay

| artifact | SHA-256 |
|:--|:--|
| `lean/RelativeConicArcs/ClebschPassageInterfacesData.lean` | `54d3236c3b4bf8a360c1b3468b484bbcffcd148a5b2707a55ebdbc556c4cdfd6` |
| `lean/RelativeConicArcs/ClebschPassageInterfaces.lean` | `43bf231eca84f30473af7af58cce044f8c5534a6f59db85cbf760a2383c2fb64` |
| `lean/RelativeConicArcs/Gates/ClebschPassageInterfaces.lean` | `0297f429b1488dbcd2d1516569052443a23d5ca48c2fe24e8963f265be62778d` |

The four adopted source manifests passed, and their deterministic checkers replayed successfully:

```bash
python3 notes/2026-07-21-c451-roquette-theta.py --check
sha256sum -c notes/2026-07-21-c451-roquette-theta.sha256
python3 notes/2026-07-21-c455-fourier-weil.py --check
sha256sum -c notes/2026-07-21-c455-fourier-weil.sha256
python3 notes/2026-07-21-c456-ame-chirality.py --check
sha256sum -c notes/2026-07-21-c456-ame-chirality.sha256
python3 notes/2026-07-21-c467-fixed-party-ame-equivalence.py --check
sha256sum -c notes/2026-07-21-c467-fixed-party-ame-equivalence.sha256
```

C451 independently compares quotient-space ranks with alternating-cycle components.  C455
reconstructs the rank-eight and rank-sixteen matrices from its independently frozen C372/C378
inputs.  C456 compares the parity-check intertwiner with complete codeword support transport.
C467 compares the character-sum support proof with the complete transition-forced local-Clifford
search.

### Validation and axiom audit

The guarded definitions-only leaf and repaired theorem checker passed.  Exact-target queue
`run-20260724-014627-5b069c89` built
`RelativeConicArcs.ClebschPassageInterfaces` and
`RelativeConicArcs.Gates.ClebschPassageInterfaces`, then passed the trace-only aggregate gate.
Peak recorded RSS was 2,397,336 KiB for the checker and 1,796,400 KiB for the gate.

All twenty-two `#print axioms` probes report only `propext`, `Classical.choice`, and `Quot.sound`,
or a subset; the two matching-signature terminals use no axioms.  No `sorry`, custom axiom,
native-decision axiom, or opaque oracle occurs.

The full three-module prose/name audit found no task IDs, lane/agent/session vocabulary, internal
note references, status placeholders, or unresolved repository-local references.  Every public
non-obvious definition and theorem has a mathematical docstring, and the headers state the finite
domain, checking method, and semantic boundary.  The imported rank-eight generated/checker closure
was already audited and accepted through `RelativeConicArcs.Gates.ClebschSchemeFourier`.

### `ej` + `tt` closeout and mystery ledger

The closeout pass replaced coordinate-only support proofs by explicit matrix inverse and
decomposition certificates and added the injectivity terminal.  Independent review then exposed
three overclaims.  The repair added the missing entrywise signed-transpose identity, all missing
weighted-adjoint and rank-eight trace checks, removed the vacuous direct-sum carrier, and narrowed
eigenspace/common-ambient semantics to the external boundary.  These upgrades sharpen both the
positive map and the nonclaim boundary.

Mystery ledger:

- **Why do the two matching sheets have identical theta signatures while q=7 and q=11 have
  opposite constant intersection parity?**  The complete finite values are settled here.  An
  intrinsic explanation tying weight `g+1` to the matching-packing geometry remains external; it
  is not needed for the erasure theorem and has no allocated successor.
- **Why does the golden-conjugate parity-check pencil admit both a monomial transport after party
  permutation and a fixed-party signed dual transport?**  The two exact mechanisms and their
  matrices are settled.  A conceptual unification inside the ambient oscillator representation
  remains outside the gate because the full restricted Weil action is not constructed.
- **Does the abstract `A5` bitorsor select a canonical geometric equivalence?**  No.  The
  free-transitive laws settle the obstruction: an unmarked bitorsor has no preferred element.
  Identifying its elements with the enumerated projective maps remains the exact external
  certificate boundary.
- **Is a C471 mod-three degeneration needed for Paper 1?**  No under the frozen shipping plan.
  The closeout settles this as an editorial exclusion, not a missing formal theorem.

### Proposed C320 trust-ledger delta

> **Finite theta/Fourier/quantum passage interfaces.** Import
> `RelativeConicArcs.Gates.ClebschPassageInterfaces`.  The gate kernel-checks the genus-three and
> genus-five theta-quadratic value counts, the complete frozen same-sheet Lagrangian-intersection
> signatures and their sheet erasure, the rank-eight/rank-sixteen/signed Fourier square and
> trace identities with all three weighted adjoints, the exact monomial parity-check transport,
> the entrywise signed-transpose identity and complete fixed-party signed-dual kernel--image
> equivalence, and the regular `alternatingGroup (Fin 5)` bitorsor laws.  Its twenty-two terminals
> use only `propext`,
> `Classical.choice`, and `Quot.sound`, or a subset.  Projective reconstruction of the matching
> tables and 60 maps, theta-divisor semantics and superspeciality, ambient Schrodinger/Weil
> normalization, common-ambient restriction and eigenspace-multiplicity theorems, complex state
> normalization, arbitrary LU classification, and all
> Golay/Hadamard uniqueness or degeneration names remain external certificate or cited-input
> boundaries.  The conditional C471 mod-three sentence is not adopted in Paper 1 and is not
> exported by this gate.

### Review checklist and disposition

- [x] Owned modules and report only.
- [x] Adopted source bundles unchanged and hash-verified.
- [x] Deterministic replays and independent internal cross-check routes recorded.
- [x] Exact finite domains and semantic boundaries visible in theorem types and docstrings.
- [x] Definitions-only data leaf and theorem-bearing checker separated.
- [x] Exact-target gate and aggregate trace passed.
- [x] Twenty-two-terminal standard-axiom audit.
- [x] Referee-facing prose/name/closure audit passed.
- [x] `ej` + `tt` closeout and mystery ledger completed.
- [x] User-launched independent review.
- [x] Resolution or narrowing of every review finding.
- [ ] User-launched post-fix review after any implementation change.
- [ ] Recorded final `GO`.

The initial independent review returned `NO GO` with three high findings.  Finding 1 is resolved
by the gated `fourierSupport_signed_transpose` and linked kernel--image theorem.  Finding 2 is
resolved by adding rank-eight/rank-sixteen weighted adjoints and the missing rank-eight trace,
while explicitly narrowing scalar-extended eigenspace multiplicities to the external boundary.
Finding 3 is resolved by deleting the tautological direct-sum theorem and leaving the true
common-ambient restriction claim external.  A user-launched post-fix review is required before
final `GO`.
