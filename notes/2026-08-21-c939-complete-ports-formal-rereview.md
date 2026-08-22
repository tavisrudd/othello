# C939 complete-ports formal and release re-review

**Date:** 2026-08-21
**Reviewed commit:** `467cec4dd66bf325d3c75e063249145600eecf85`
**Reviewed PDF SHA-256:** `1e39fe1f38b1084a27930674d48a63ae7b4c4a41b2eabe14af4630dd60b2b033`
**Manuscript verdict:** **GO**
**Public-release verdict:** **BLOCK**

## Executive finding

The revision resolves the previous formal-correspondence objection by narrowing the claim to the
evidence actually present rather than pretending that one Lean declaration packages the entire
matched asymptotic theorem.  The PDF, repository README, and verification README now agree on a
field-by-field division of labor:

- Lean checks the general exact transfer, eventual prescribed-port transfer, parameter, density,
  reliability, and bounded-EXIT components;
- `RepairPorts.eventually_radiusThree_prescribedPortPair` checks only simultaneous eventual
  radius-three support/coefficient transfer for two inner codes through one common outer family;
- the two displayed field-seven matrices and their finite invariants are human-proved from the
  determinant ledger and independently replayed by `f7-seed.py`; and
- asymptotically good outer-family existence is an explicit classical input, while Theorem 6.5 is
  the written synthesis of those components.

This is honest statement correspondence.  The manuscript no longer implies that
`eventually_radiusThree_prescribedPortPair` itself proves the concrete field, seed, global-parameter,
density, or reliability fields of Theorem 6.5.  A reader can identify exactly which part is
kernel-checked and which parts are classical, human, or independently computed.

The public release is not ready.  The guarded area exporter refuses the canonical finitegeom tree
because that tree contains unrelated uncommitted work.  Consequently no complete-ports export has
been adopted into a clean public finitegeom commit, `formal-boundary.json` intentionally has no
`finitegeom_release_commit`, and the full release verifier correctly refuses to pass.  This is an
external release-state block, not a defect in the frozen manuscript.

## Frozen-artifact identity

The checkout `HEAD` is exactly `467cec4dd66bf325d3c75e063249145600eecf85`, and the tracked PDF
has exactly the supplied SHA-256
`1e39fe1f38b1084a27930674d48a63ae7b4c4a41b2eabe14af4630dd60b2b033`.
The PDF is 22 pages.

The revised formal source pin
`e45c925e1004c9316a2240a5fb36f7f2775a49b0` exists in the local Git object database.  There is no
diff under the relevant Lean source/trust paths between that pin and the reviewed paper commit.
The finitegeom checkout is at the advertised base commit
`b871c10b4a91200a0913644d39b9f0ce44f655ca`, but it is dirty with separately owned work.

## Formal correspondence, field by field

### Exact and eventual transfer

The PDF attributes the exact functional-strata and pointed-confinement results to
`RepairPorts.exactFunctionalStrata` and
`RepairPorts.exactPointedConfinementAndTransfer`.  It attributes trace duality, concatenated
parameters, designated-class density, eventual necessity/sufficiency, and prescribed ports to
separate declarations.  This is accurate modular correspondence.

For the matched pair, the paper now says expressly that
`RepairPorts.eventually_radiusThree_prescribedPortPair` covers only:

- one common outer family;
- one eventual cutoff uniform in every later block;
- exact radius-three support-port copies for both inner codes; and
- exact radius-three normalized coefficient-port copies for both inner codes.

Those are exactly the fields in the declaration's type.

### Fields not claimed for the paired Lean declaration

The revision correctly places the following outside that declaration:

- `F_7` and the concrete two `[7,4,3]_7` matrices;
- rank four, absence of dependent triples, and the two circuit-hyperplane lists;
- equality of the pointed rank-triple multiplicity enumerators;
- the two minimal-repair pairs and availabilities two versus one;
- the reliability laws `2s^3-s^6` and `2s^3-s^5` as facts about those concrete matrices;
- random-linear asymptotically good outer-family existence; and
- the final assembly of matched length, dimension, distance bound, density `1/7`, and asymptotic
  goodness.

Theorem 6.5 supplies a complete human synthesis: both inner codes have the same `[7,4,3]_7`
parameters; one outer family gives `n_N=7N`, `k_N=4K_N`, and `d_N>=3D_N`; the `N` distinguished
targets among `7N` coordinates give density `1/7`; and literal port equality transports the finite
reliability laws.  Appendix A and the public README label the formal, finite, classical, and human
roles consistently.  The prior statement-adequacy defect is therefore resolved by accurate
coverage language.

### Pointed-profile wording

The revision replaces the potentially overstrong “same full pointed subset profile” wording by
“same pointed rank-triple multiplicity enumerator (equivalently, the same full
pointed-perspective polynomial).”  Lemma 6.3 now explicitly warns that these data do not determine
the labeled subset-rank function.  This correction is mathematically and terminologically sound.

## Immutable evidence checks

The reviewed surface retains the verified immutable values:

- gate-fact SHA-256
  `fbb29ef0bc559b9ac2ce3308a7b3c0572753ffd7163d6c15cd18e57464fc0a4d`;
- field-seven certificate SHA-256
  `8096230e66f634c820ae7ec4bacd9b2493006782ff02b8be3a8c7e1caf80de07`;
- 36 gate-closure modules;
- 61 paper-facing terminals and 61 `#print axioms` commands; and
- axiom union exactly `Classical.choice`, `Quot.sound`, and `propext`, with an empty
  project-axiom list.

`python3 lean/scripts/lean-trust-spine.py audit --area complete_ports` again completed with
`0 error, 0 warn, 0 info`.

## Release-verifier design and observed behavior

`verification/verify_release.py` has a coherent two-level design.

The paper-surface level checks the public-file allowlist, rejects private workflow/path leakage,
checks DOI and release metadata, requires the AI disclosure and section structure, validates the
formal-boundary schema and local gate fact when present, replays and hashes the field-seven
certificate, and rebuilds the PDF in a temporary directory with a fixed epoch.  It rejects TeX
warnings, page-count drift, and any byte difference from the tracked PDF.

The command

```text
nix develop .#manuscript --command python3 verification/verify_release.py
```

passed as

```text
complete-repair-ports release: PASS [paper surface, 22 pages, warning-free]
```

Nix printed a dirty-monorepo warning, but the deterministic checker itself passed.  The warning
does not weaken the byte-for-byte PDF comparison.

The full-release level additionally requires an explicit finitegeom root and an adopted
`finitegeom_release_commit`.  It checks exact clean `HEAD`, the public GitHub origin, the exported
gate, closure ordering, every source byte count and SHA-256, equality of candidate and source
manifests, the trust statement, terminal inventory cardinality, and presence of the permitted axiom
set.

Its intentional refusals were observed:

```text
verify_release.py --require-public-formal
complete-repair-ports release: FAIL [full release requires --lean-root /path/to/finitegeom]
```

and, with the current canonical finitegeom checkout supplied,

```text
verify_release.py --require-public-formal --lean-root /home/tavis/src/lean/finitegeom
complete-repair-ports release: FAIL [formal metadata lacks the adopted finitegeom release commit]
```

This is the correct fail-closed behavior.  Supplying `--lean-root` without the
`--require-public-formal` flag also enters the full-root checks, so the stronger verification is not
silently skipped once a root is supplied.

As non-blocking future hardening, the full checker could compare the exact terminal-name set and
parse an exact axiom set from the public trust statement rather than checking terminal cardinality
and axiom-name presence.  The guarded exporter, clean release commit, and source hashes already
provide the primary binding, so this does not change the present manuscript verdict or the current
release block.

## Why the public release is BLOCK

The exact guarded planner command at the new source pin refused with:

```text
refused: the canonical base repository /home/tavis/src/lean/finitegeom has uncommitted changes
```

The canonical tree is at the correct finitegeom base commit but contains unrelated modified and
untracked work.  Repository rules prohibit cleaning, moving, committing, or otherwise disturbing
that work during this review.  Therefore the complete-ports formal area cannot yet be exported and
adopted, and there is correctly no release commit for the paper to pin.

The dependency chain is:

```text
dirty canonical finitegeom tree
  -> guarded area-export refusal
  -> no adopted public complete-ports formal commit
  -> no finitegeom_release_commit in formal-boundary.json
  -> full release verifier refuses
```

This chain cleanly separates a green manuscript from a blocked publication operation.

## Exact release-unblock sequence

1. The owner of the current finitegeom changes must finish, preserve, or relocate that work so the
   canonical checkout is clean.  This review gives no authority to alter it.
2. Rerun the guarded complete-ports area-export plan at source pin
   `e45c925e1004c9316a2240a5fb36f7f2775a49b0` and finitegeom base pin
   `b871c10b4a91200a0913644d39b9f0ce44f655ca`.
3. Run the reproducible export, review the forward delta, and adopt it as an ordinary public
   finitegeom commit through the approved workflow.
4. Record that clean adopted revision as `finitegeom_release_commit` in
   `verification/formal-boundary.json` and rebuild the deterministic PDF if the rendered pin changes.
5. Run the paper-surface verifier and the full verifier against a clean checkout of that exact
   public commit.  Public release is GO only after both pass.

## Verdict

- **Manuscript: GO.**  The formal correspondence is now accurate field by field, the human/finite/
  classical boundaries are explicit, the paper-only deterministic gate passes, and the earlier
  pointed-profile overstatement is corrected.
- **Public release: BLOCK.**  No clean adopted finitegeom release commit exists because the guarded
  exporter correctly refuses the dirty canonical finitegeom tree.  The full verifier correctly
  refuses in that state.

**Vibe check:** the paper is now candid and referee-ready; publication is safely stopped at the
external formal-export boundary.

## Mystery ledger

The `ej`+`tt` closeout found no remaining mathematical or correspondence mystery.  The one open
state question is operational and precisely owned: when the foreign finitegeom work will yield a
clean export window.  The full verifier's exact-terminal/exact-axiom comparison is a cheap future
hardening opportunity, not an unexplained evidence gap in the manuscript.
