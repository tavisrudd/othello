# C892 — Paper II Lean and trust-boundary review

**Lane:** `clebsch` · **Date:** 2026-08-08

## Verdict

**MAJOR / NO-GO for a theorem-complete or referee-ready Lean release.**

The paper is substantially more honest than the lane's theorem-complete
standard: its local trust manifest distinguishes conceptual, classical,
certificate and Lean support, and the current sources carry no admitted or
compiled-evaluation escape.  That is not enough for the declared series
standard.  Nineteen of the twenty-nine ledgered theorem-like statements have
no Lean mode at all.  The ten rows with Lean mode map to ingredients or
conditional abstractions rather than to declarations of the manuscript
statements.  The headline six-clause theorem has no Lean mode.

The release boundary also has three independent mechanical holes.  Its import
walker omits six actual local dependencies; its fingerprint omits the
manuscript checker and both paper flake files while claiming to pin the build;
and its axiom parser counts output rows without checking terminal identity.
All three failures were exercised by negative tests.  In addition, the digest
printed in the manuscript is stale, the current formal companion exposes only
the arithmetic-gluing boundary, and an unused cap-game import has re-entered
the closure after C860.

The review is read-only.  No Lean, manuscript, verification, export, mirror or
release file was changed.

## Review surface reconstructed from source

The manuscript extractor records twenty-nine labelled theorem, proposition,
lemma and corollary environments.  The trust manifest assigns ten of them Lean
mode and nineteen no Lean mode.  The four local gates contain fifty-five axiom
print rows but only fifty-four distinct terminals:

| gate | rows | distinct contribution |
|---|---:|---:|
| `RelativeConicArcs.Gates.ClebschArithmeticGluing` | 23 | 23 |
| `RelativeConicArcs.Gates.ClebschHilbertSymmetry` | 2 | 2 |
| `RelativeConicArcs.Gates.ClebschHyperplaneSquare` | 1 | 1 |
| `RelativeConicArcs.Gates.ClebschPaperIIStructural` | 29 | 28 new |

The duplicated terminal is
`RelativeConicArcs.ClebschArithmeticGluing.rankThree_split_fused_trichotomy`.

Following every repository-local import, with no namespace restriction, gives
sixty-two files.  The fifty-six files recorded by the evidence fingerprint
omit:

- `lean/CapGame/BuildGame.lean`;
- `lean/ProjectiveCap/Grid.lean`;
- `lean/ProjectiveCap/PlaneAffineChart.lean`;
- `lean/ProjectiveCap/PlaneTransitivity.lean`;
- `lean/ProjectiveCap/Projective.lean`; and
- `lean/ProjectiveCap/Sym2ConicBridge.lean`.

The last file directly imports `CapGame.BuildGame` but uses no declaration
from `FiniteBuildGame`; its module header still says that nothing in the module
refers to a game.  The import was reintroduced on 2026-08-04, after the C860
game/geometry split.  `CapGame.BuildGame` has at least five scholarly-public
theorems without docstrings: `mem_legalExtensions`, `win_iff_exists_move`,
`move_map`, `isP_map`, and `isP_equiv`.

## Claim-to-Lean coverage

### Nineteen statements with no Lean mode

These are classified by the manifest as conceptual, classical-input and/or
certificate-supported, but have no paper-facing Lean terminal:

- `thm:factorization-recovery`;
- `prop:matching-secant-quotient`;
- `lem:shared-radial-cycle`;
- `thm:rank-three-quotients`;
- `cor:h3-affine-origin`;
- `cor:h3-middle-layer`;
- `prop:radical-hadamard`;
- `prop:modular-sheet-mechanism`;
- `cor:self-associated-gorenstein`;
- `cor:secant-product-syzygies`;
- `thm:six-profile-reconstruction`;
- `cor:decorated-sheet-classifier`;
- `cor:profile-ray-weights`;
- `prop:modular-depth-quotient`;
- `cor:h3-nine-space-bridge`;
- `cor:h3-homogeneous-projective-cover`;
- `lem:three-ray-cubic`;
- `cor:mass-zero-cubic`; and
- `prop:relative-cubic-tate-plane`.

This list includes the headline theorem and its exact matching-orbit
classification, rank, sheet, cubic, Gorenstein and fixed-line clauses.

### Ten statements with partial Lean mode

| manuscript row | Lean evidence actually present | gap to the printed statement |
|---|---|---|
| `lem:projective-trade-reduction` | `ClebschProjectiveTradeReduction.kernel_or_split_pullback` | assumes the zero-or-injective dichotomy and proves a generic pullback split; it does not state the module hypotheses, derive the dichotomy, or prove the printed Ext-class identity |
| `lem:lucas-socle-square-parity` | the Lucas coefficient, finite-root, parity, defect, detector and contraction terminals of the structural gate | the finite-group Hom interpretation, extension parity, tilting/socle identifications and nonsplitting conclusion remain classical or human |
| `lem:uniform-sheet-exclusion` | regular-matching, dihedral-parity, exceptional-domain and endpoint terminals | proves implications in an abstract endpoint interface, not the all-odd-prime-power matching-orbit statement |
| `thm:balanced-orbit-completeness` | the same endgame plus `certifiedBalancedSheets_endpoint_and_uniquePartner` | `HasCertifiedBalancedSheets` is defined only on five displayed finite models; no declaration states the manuscript classification from its intrinsic trade hypotheses |
| `thm:fixed-line-chow-rigidity` | seven `ClebschFixedLineRadialTranslation` terminals | the radial family is an abstract presented evaluation space; no geometric instance is constructed, and the fixed locus, subgroup, block-system and unique Chow intersection remain human/classical |
| `lem:hyperplane-square` | `HyperplaneSquare.cubicAnnihilator_eq_zero` | checks the dual core from a nonconstant witness and an annihilator hypothesis; the exact paper formulation through `dim L > 1` and equality of Schur-power subspaces is not a paper-statement declaration |
| `thm:balanced-cubic` | the hyperplane-square terminal plus finite bundles | only the cubic-fullness implication is kernel-checked; intrinsic sheet recovery, vanishing moments and nonzero oriented cubic are not one Lean theorem |
| `cor:graded-evaluation` | the hyperplane-square terminal plus finite bundles | the complete graded evaluation-algebra conclusion is not stated as a Lean declaration |
| `lem:split-inert-frames` | the arithmetic root and factorization terminals | no formal statement gives the `F_25` Frobenius orbit clause; the printed lemma is not a Lean declaration |
| `thm:rank-three-arithmetic-gluing` | the twenty-three arithmetic-gluing rows | the `H_3` coset/word completeness remains generator/replay trust, and the group identifications and determinant/profile transport remain classical or conceptual |

Thus even the ten Lean-labelled rows have ingredient coverage, not exact
statement coverage.  The trust manifest has no field for clause-level or
partial coverage and names evidence bundles rather than fully qualified
declarations.

The twenty-nine-row identity is itself narrower than the lane standard.  It
extracts only four environment types and omits the seven remark environments
and exact narrative claims.  One concrete unledgered assertion is the
post-proof census near manuscript lines 3137--3140: among the 133 projective
lines of the relative-cubic plane, one specified line is uniquely rank nine,
one is rank one, and 131 are rank ten.

## Major trust-boundary findings

### M1. The numbered-series formal standard is unmet

The Clebsch handoff requires every mathematical assertion to map to a
kernel-checked declaration, with no permanent partial-coverage row.  Paper II
has nineteen non-Lean statement rows, ten partially covered Lean rows, no
formal declaration of the headline theorem, and unledgered mathematical prose.
The local manuscript describes much of this honestly; the failure is the
conflict between that honest mixed boundary and the stronger series-wide
release standard.

### M2. Six imported sources are outside the fingerprint

`verify_release.py:469` follows only lines beginning
`import RelativeConicArcs.`.  The actual local closure also crosses into
`ProjectiveCap` and `CapGame`.  In a scratch reconstruction of the runner's own
`build_fingerprint` function:

```text
CapGame mutation rejected: False
ProjectiveCap mutation rejected: False
RelativeConicArcs mutation rejected: True
```

The manuscript and verification README therefore overstate the fingerprint
when they say that it fixes the project-owned Lean import closure.  A source
policy violation in any of the six omitted modules is likewise invisible to
metadata verification.  There is no independent source-policy scan in the
release runner.

This is not merely hypothetical drift.  C860 removed the game dependency and
documented a sixty-one-file closure on 2026-08-03.  The unused direct import of
`CapGame.BuildGame` was restored the next day, making the present closure
sixty-two files and invalidating the live handoff's claim that game modules are
out of the paper closure.

### M3. The claimed manuscript-build source is not pinned

The fingerprint's `review_sources_sha256` omits all of:

- `papers/clebsch-factorization/verification/check_manuscript_build.py`;
- `papers/clebsch-factorization/flake.nix`; and
- `papers/clebsch-factorization/flake.lock`.

Scratch mutations of each left `build_fingerprint` byte-identical:

```text
verification/check_manuscript_build.py mutation rejected: False
flake.nix mutation rejected: False
flake.lock mutation rejected: False
```

The manuscript and verification README also say that the build goes through a
paper Makefile, but this paper root contains no Makefile; the runner invokes
`check_manuscript_build.py` directly under the paper flake.  The fingerprint
does hash `lean/flake.lock`, which is not the TeX environment used by that
command.

### M4. The printed fingerprint digest is stale and unchecked

The manuscript prints
`b6c8f171d9da8849fd1628371a23c2604a15fd104ed555e0e7fd4508bee79998`.
The actual SHA-256 of `verification/evidence_fingerprint.json` is
`c03bd890c8a84c552c2329e69932a980a900960a46d4531f60837b3ca345ad83`.
Both authority and standalone `--metadata-only` checks pass.  The immediate
cause is the 2026-08-08 README fingerprint refresh: it changed the fingerprint
JSON, while `normalized_manuscript_sha256` intentionally erases the displayed
digest and no later check compares that display with the actual file hash.

The normalization already removes the circularity.  Comparing the displayed
digest after constructing the fingerprint is therefore a cheap complete fix.

### M5. Axiom rows are counted, not identified

`check_lean_axiom_audit` checks only that it parses fifty-five reports and that
their union of axioms is allowed.  It neither records nor compares declaration
names and it does not reject duplicates.  The current four gates already
contain fifty-five rows but fifty-four unique names.  A synthetic audit in
which one terminal was replaced by a duplicate passed:

```text
one terminal replaced by a duplicate: ACCEPTED
```

The arithmetic gate alone has a generated trust-registry fact and exported
twenty-three-name terminal list.  The other three gates have no Paper-II
aggregate registry entry or tracked exact axiom transcript.

### M6. The public formal boundary is incomplete

The clean local `~/src/lean/finitegeom` companion at `3ecb12727ac2` registers
only `RelativeConicArcs.Gates.ClebschArithmeticGluing` for the
`clebsch_factorization` area.  Its trust statement lists twenty-three
terminals and a thirty-one-module closure, now including `CapGame.BuildGame`.
`ClebschPaperIIStructural` is absent from that repository.  Hilbert symmetry
and hyperplane square happen to exist there, but are not assembled with the
structural and arithmetic gates into a Paper-II boundary.

The paper manuscript explicitly says its fingerprint is not an immutable
public locator.  The paper README links only the version-independent concept
DOI for the formal companion.  Consequently an external reader cannot replay
the current four-gate, fifty-four-unique-terminal local claim from one pinned
public artifact.

## Minor and editorial findings

1. Table `tab:verification` gives the fixed-line result exact evidence
   `none`, while the trust manifest assigns it Lean mode and the following
   prose names seven structural-gate terminals.  The later prose is the more
   accurate account.
2. The paper README's aggregate summary names only the arithmetic-gluing and
   hyperplane-square Lean gates, omitting the structural and Hilbert-symmetry
   gates that the runner invokes.
3. A fresh structural-gate dependency rebuild emitted six
   `linter.unusedSectionVars` warnings from
   `RelativeConicArcs/ClebschGateway.lean`.  They do not change theorem types
   or axioms, but the release runner checks TeX warnings only and does not
   enforce warning-clean Lean elaboration.

## What passed

- The authority metadata check passes with twenty-nine statements and fourteen
  evidence bundles.
- Scratch mutations of the statement count, claim modes and a checksummed
  evidence source were rejected.
- Synthetic omission of an axiom row and insertion of an unexpected axiom were
  rejected; the defect is exact terminal identity, not the axiom allowlist.
- The sixty-two-file current local source closure has no `sorry`, declared
  project axiom, `native_decide`, unsafe declaration, `implemented_by`,
  `run_tac`, `ofReduceBool`, `debug.skipKernelTC`, or similar kernel bypass.
- The clean paper standalone at `83f449558248` passes metadata verification.
- Its full non-Lean aggregate passes every primary certificate and independent
  replay, and rebuilds the tracked forty-three-page PDF byte-for-byte with no
  TeX warning.
- Through the guarded build queue, the arithmetic-gluing, Hilbert-symmetry and
  hyperplane-square gates were trace-current; the stale Paper-II structural
  gate was rebuilt successfully at 1.81 GB peak RSS and then passed an exact
  trace-current aggregate confirmation.
- The authoritative full aggregate then passed in 2 minutes 27 seconds: every
  primary and independent replay, all four guarded gate elaborations, the
  runner's fifty-five-row foundational-axiom allowlist, and the deterministic
  warning-free forty-three-page manuscript build ended in
  `clebsch factorization release: CHECK OK`.

The aggregate's success does not weaken the MAJOR verdict.  It confirms that
the present mixed-boundary artifact is internally green under its current
checks; M1--M6 identify claims and inputs those checks do not cover or identify
exactly.

## EJ + Tao closeout

The cheap repairs are unusually concentrated:

1. remove the unused `CapGame.BuildGame` import;
2. make the closure walker follow every repository-local import and pin all
   sixty-one intended files;
3. hash `check_manuscript_build.py`, `flake.nix`, and `flake.lock`;
4. compare the displayed fingerprint digest with the actual JSON hash;
5. derive one exact, duplicate-free terminal manifest from the trust registry;
6. reconcile the fixed-line table and README gate list; and
7. export one aggregate Paper-II formal boundary at an immutable locator.

Those repairs harden the existing mixed trust boundary.  They do not meet the
series theorem-complete standard.  That requires a separate proof program:
formal manuscript-level definitions and correspondence lemmas, one declaration
per printed assertion or clause, proofs of the currently classical and human
inputs in the form actually used, and a claim registry that covers remarks and
load-bearing narrative assertions rather than only four environment types.

The Tao-level diagnostic is simple: the current artifact answers “which
ingredients have Lean proofs?” but never states in Lean the theorem a referee
is being asked to accept.  The next formal program should begin by freezing
that theorem and its exact object correspondence, not by adding more internal
bridge lemmas.

## Mystery ledger

| feature | status | evidence gap or owner |
|---|---|---|
| Why did the cap-game dependency return after C860? | open | the 2026-08-04 import is unused and contradicts the module header; owning shared-library repair must establish whether it was accidental before removal |
| Why are there fifty-five audit rows but fifty-four terminals? | settled | the arithmetic trichotomy is printed in both the arithmetic and structural gates |
| Why does the printed fingerprint hash differ? | settled | the 2026-08-08 README refresh changed the JSON and the normalization erases, but never verifies, the displayed hash |
| Is the current public companion the four-gate artifact? | settled negatively from the local release authority | only the arithmetic gate is registered for this area and the structural gate is absent; exact bytes behind the concept DOI remain a public-release check for C577 |
| Do current sources contain a hidden Lean escape? | settled negatively | complete sixty-two-file source-policy scan plus guarded gate builds found none; the terminal axiom envelope remains the foundational allowlist |

## Required ownership before release

- C577 must not publish or call the present artifact theorem-complete.
- A bounded release-hardening repair can own M2--M6 and the minor findings.
- A distinct substantial Lean task must own M1; folding it into a fingerprint
  repair would hide the real proof scope.
- C892 remains review-only and makes no repair or publication decision.
