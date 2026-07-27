# C287 token-efficient extraction execution

**Lane:** `build-sys`

**Status:** authoritative resumable execution route; paper boundaries are synchronized; extraction
waits for a commit-clean immutable input checkpoint

## Objective

Complete the remaining formal work and fresh-history extraction with the fewest context reloads
and repeated reviews compatible with the existing correctness gates. Token efficiency does not
weaken source ownership, whole-closure prose review, exact gate validation, axiom auditing, or
clean-checkout replay.

## Fresh-session route

The two source-owner preparation sessions and the extraction session remain distinct. Do not
reload or rerun a completed source-owner task.

### Session 1 — AME--LU

C612, C613, and C602 are complete. C602 freezes the final length-generic aggregate and axiom-audit
roots, a 67-file project-owned Lean closure, and five separate build-identity files. Consume that
report and the intake record; do not reload the AME--LU lane or rerun its builds. C581 remains
outside the adopted boundary.

### Session 2 — first-tag target rewrite

Start with:

```text
go C553
```

Read the root guide, exact queue row, `cap` handoff, C553 rewrite packet, and nested Lean guide.
Do not edit or delete private-monorepo Lean source. During construction of the fresh-history target
candidate, delete the two approved wrapper modules, migrate consumers, and complete the
seventeen-module semantic documentation pass. Record the transformation as a deterministic delta
whose input hashes are checked against the immutable private-source commit.

Review each unique module once. Use a compact triage index of module headers, imports, comments,
docstrings, public declaration names, and declaration signatures to prevent repeated full-proof
reads. The index is a navigation aid, not acceptance evidence: inspect source wherever scope,
strength, public/private status, or prose/type agreement is not mechanically decidable. Run only
the scoped consumer and four-root validation required by the packet.

### Session 3 — coordinated extraction

After the immutable source checkpoint is clean, start with:

```text
go build-sys
```

Read the root guide, the `build-sys` handoff, this execution card, and
`notes/2026-07-26-c287-paper-intake-refresh.md`. Do not preload the arcs, PRS, Clebsch, AME--LU,
complete-ports, or cap handoffs. Their adopted roots and exclusions are already frozen in the
intake record; open a source-owner report only to resolve an explicit mismatch.

## Immutable input boundary

Before computing any closure, write a checkpoint that fixes:

- the exact private source commit and requires every exported input path to match that commit;
- the hashes of every adopted root/terminal contract, the toolchain and lockfiles, and the
  closure/import tool;
- the private source commit and the target-only C553 transformation digest; and
- the destination module-name policy, including canonical path spelling and case sensitivity.

Any later mismatch invalidates the checkpoint and stops the wave before another candidate commit
is constructed. A frozen root name is not a frozen source snapshot.

## One-pass review, incremental public states

1. From the immutable snapshot, compute the exact transitive project-owned closure for the first
   tag and the adopted Lean contracts: Relconic; PRS R5--R7 geometric; Clebsch Rigidity; Clebsch
   Factorization; the current AME--LU release aggregate; complete ports; and the PRS
   balanced-quantum cross-paper gate. Record Clebsch Passages as a no-Lean paper contract and do
   not add it to the source union. Split the arcs Q16 and Clebsch Rigidity Q11 generated families
   into their declared opt-in certificate packages.
2. Form one content-addressed union. Each row records source path, destination path, canonical Lean
   module name, regular-file type and mode, byte count, and SHA-256. Reject symlinks, non-regular
   files, path traversal, duplicate destinations, module aliases, Unicode-normalization or
   case-folding collisions, and any destination path with multiple hashes.
3. Generate one compact semantic review index for the union. Public-prose review may be reused only
   when destination path and source hash are identical. Record every consuming paper contract.
   Elaboration, axiom, and trust results are never reused by file hash: they belong to the complete
   candidate commit, dependency graph, toolchain, and locked environment.
4. Freeze a tracked public-state ledger before writing sources. Its first state is exactly the
   reviewed 26-file first-tag manifest. Later states apply only manifest-declared deltas in an
   order derived from the computed import DAG and frozen before construction. In particular, the
   PRS balanced-quantum state must follow its AME--LU dependency and must remain distinct from the
   17-file geometric PRS ledger. Each state has its own complete file manifest, paper gate map,
   terminal list, axiom expectations, certificate inputs, and expected parent state.
5. Construct each state as a candidate commit from the last validated public state, never by
   staging the full union before the first commit. Confirm that the candidate's complete tracked
   file set and parent match its ledger row.
6. Validate that exact candidate commit under the build-owner lock: run its aggregate gates and
   terminal axiom extraction, then replay from a separate clean checkout of the candidate commit
   with only its declared locked inputs. A successful working-tree build is not acceptance
   evidence.
7. Only after all gates pass, fast-forward `main` to that candidate and mint its tag. On failure,
   leave `main` and all prior tags unchanged, record the failed candidate hash and first diagnostic,
   and construct any corrected candidate again from the last validated state. Do not make a failed
   candidate an ancestor of a public state.
8. Write an atomic, disk-backed checkpoint after input freeze, union construction, review, each
   candidate construction, each validation component, and each tag. The checkpoint records input,
   manifest, candidate, log, and result hashes so a new session can resume at the first unproved
   transition rather than repeat successful work.
9. Prefer one quiet build-owner window, but treat it only as a scheduling optimization. Releasing
   the lock or losing the session must not invalidate a completed checkpoint; reacquisition must
   revalidate the immutable-input and candidate hashes before continuing.
10. Record only bounded summaries and first diagnostics. Preserve full logs on disk; do not render
    them into the session unless a specific failure requires a narrow excerpt.

## Work deliberately deferred

- Do not compute export manifests from a dirty private-source tree. The
   adopted root ledger is sufficient and avoids a second manifest pass.
- Do not ingest C581, PRS companion levels, future Clebsch revisions, or Relconic quantitative
  successors. Clebsch Passages remains in the paper ledger but outside the source union unless a
  later manifest names an exact Lean root.
- Do not copy Q11, Q13, Q16, or Q25 certificate families into the main source union. Handle a
  certificate package only when an adopted paper manifest explicitly requires it, through its
  existing one-way package boundary.
- Do not rerun source-owner literature audits, computational searches, cold reads, or publication
  checks. C287 consumes their frozen trust boundaries and independently verifies only the public
  source/export contract it owns.

## Token and output discipline

- One lane load per session; finish adjacent queued tasks before switching lanes.
- One union review, keyed by source hash; no per-paper reread of identical files.
- One compact semantic index; targeted source expansion only for unresolved judgments.
- One resumable sequence of candidate-state gates, preferably within one coherent build window; no
  repeated unchanged elaborations or clean replays.
- One concise task report per C-item and one final extraction report; do not create intermediate
  status reports that merely restate queue or handoff state.
- Use exact roots and pathspecs. Never load portfolio umbrellas, broad logs, archives, or complete
  source trees into model context.

## Acceptance boundary

This protocol saves tokens by eliminating duplicate context and review, not by sampling. Every
unique exported source file still receives the required referee-facing review; every adopted
terminal still has an exact observed axiom record tied to its complete candidate environment; every
paper still retains its own immutable claim/gate manifest; and every exported tag is the exact
candidate commit that passed its clean public replay.
