# C275 M1 clean-room publication boundary

**Lane:** `complete-ports` (re-pegged from `repaircodes` by the explicit C277 lane split)

**Status:** COMPLETE — a deny-by-default M1 source/evidence allowlist and fail-closed export design
are frozen. No repository was initialized, no file was copied, and no Lean/build artifact was
touched. Publication remains blocked on the paper repository identity/remote, a user-selected
license, the final C220 inclusion decision, public rewrites of README/proof/evidence ledgers, and the
separately owned all-papers shared-Lean source/artifact export.

## Nonpublication invariant

The private monorepo and its Git history are never publication inputs. Do not publish the current
remote, add a public remote, run a broad tree copy, use a subtree/history-filter operation, or copy
`.git` into any destination. Each paper repository begins from an empty disk-backed directory and
fresh Git history, populated only from its reviewed manifest. Anything not listed is forbidden.

This rule is motivated by content scope, not merely credentials: the monorepo contains research,
handoffs, archives, unrelated papers, generated evidence, and work that the user does not want
published. A secret scan cannot convert an unallowlisted file into a publication candidate.

## Machine-readable M1 boundary

[`2026-07-17-c275-m1-publication-allowlist.tsv`](2026-07-17-c275-m1-publication-allowlist.tsv) is
the complete v1 map. Its actions have exact meanings:

- `copy`: byte-exact candidate input permitted after the final source hash is frozen;
- `rewrite`: the private file is reference material only; author a public replacement without
  private paths, internal status, lane history, or unpublished claims;
- `conditional`: forbidden unless the named manuscript decision is explicitly promoted;
- `generate`: create in the new repository from reviewed public metadata or a validated build; and
- `exclude`: never export.

The current direct-copy surface consists of the TeX source, bibliography, and the closed dependency
set of the selected computational evidence. The exact script closure matters: C218 imports the
projective-completion verifier; C219 imports C202 and C218; C227 imports C219; C243 imports C218;
and C244 imports C218, C226, and C227. Preserving the original evidence basenames under one
`evidence/` directory keeps those explicit relative imports checkable.

Internal C-report Markdown files are not public evidence merely because they describe a public
theorem. The public repository instead gets a purpose-written `evidence/README.md` containing the
claim, replay command, conventions, dependency versions, byte counts, SHA-256 hashes, independent
cross-check boundary, and what each finite computation does not prove.

## Explicit exclusions

The following remain forbidden unless a later manifest names an exact replacement or promotion:

- every monorepo path absent from the TSV, including all other `notes/`, `papers/`, handoffs,
  archives, Rust/Python research trees, and Git metadata;
- `adversarial_novelty_review.md`, internal task reports, transcripts, lane status, and private
  planning documents;
- the current README and proof ledger as byte copies—their public replacements must omit private
  paths and internal workflow state;
- the tracked PDF as a source input; build a release PDF from the public source;
- every Lean source/build file in the paper repository; it receives only a shared-repository commit
  pin, target list, public proof ledger, and artifact provenance;
- `.lake/`, raw `.olean`/`.ilean`/`.trace` files, local caches, Nix stores, editor state, logs,
  credentials, absolute host paths, and `/tmp` artifacts; and
- C220's script/certificate unless the optional stability theorem survives manuscript assembly.

## Fail-closed export procedure

1. Choose the paper repository name, disk-backed staging path, public host/remote, visibility, and
   license. The destination must be new and empty; never place staging under `/tmp`.
2. Freeze the M1 manuscript/evidence selection. Resolve every `conditional` row and update the TSV
   in the private source repository before copying anything.
3. Record SHA-256 and byte count for every `copy` source. An exporter must parse the TSV and accept
   only exact `copy` rows; missing sources, duplicate destinations, path traversal, symlinks,
   undeclared outputs, or hash drift are fatal.
4. Copy into the empty staging directory using the declared destination names. Author `rewrite` and
   `generate` files there. Do not initialize Git yet.
5. Compare the staged regular-file set against the resolved destination allowlist. Any extra file
   fails the export. Scan the staged bytes for credentials, private keys, absolute/private paths,
   internal hostnames, unpublished-personal data, and accidental monorepo references; scanning is a
   second gate, never a substitute for the allowlist.
6. Replay every exported evidence script against its committed JSON certificate in the staged
   layout. Build the PDF from staged sources and audit citations/claims against the public proof
   ledger and pinned Lean targets.
7. Verify the shared Lean commit and artifact provenance described below. Generate
   `formal/PROVENANCE.sha256` over all public inputs and record toolchain versions.
8. Only after all gates pass, initialize fresh Git history in the staged directory, stage the exact
   allowlisted file set, review the first commit, and then attach the approved remote. Publishing or
   pushing remains a separate explicit user action.

The initial candidate scan over the six current paper-package files and selected script/JSON closure
found no filenames containing obvious absolute `/home`/`/tmp` paths or common credential/private-key
markers. This bounded scan is not a publication clearance. No repository license file exists, so
license selection is a hard blocker.

## Shared Lean monorepo contract

The shared Lean repository backs **every** exported paper under `papers/`. It is one separately
maintained, fresh-history Lean monorepo, not one Lean copy per paper and not a publication of the
private monorepo. Its source manifest must be computed from the union of all paper-facing target
closures and explicitly reviewed additions such as shared build wrappers, toolchain files,
licenses, and public documentation. The closure, not the private `lean/` directory, is the export
unit.

M1 initially requests paper-facing targets `RepairCodes` and `RepairPorts.FunctionalCost`; the
shared-export owner must replace these logical targets with the exact public module closure and
public aggregate gates. C216's manuscript-only asymptotic steps remain identified as such rather
than being implied by a Lean pin.

Source export and compiled-artifact transfer are distinct atomic bundles:

1. freeze the exported source closure, toolchain, Lake configuration, and target list;
2. while holding the shared build-owner lock, create the artifact only through
   `lean/scripts/lean-build-queue.py pack` to a disk-backed, nonexisting destination;
3. record the pack's SHA-256, byte count, source/toolchain/config hashes, exact producing command,
   and paper-facing target gates outside Git or as a release artifact—never commit a raw build tree;
4. in a separate disk-backed test checkout of the exported Lean source, verify the pack/restore
   semantics before relying on it, then require content traces and exact-target `lake build
   --no-build` confirmation; and
5. if restore semantics or source identity fails, discard cache reuse and schedule a guarded rebuild
   rather than selecting or copying individual `.olean` files.

The build-system owner must run this work. C275 neither claims that the current Lake pack is
portable to the future repository layout nor authorizes a build, pack, restore, cache copy, or
shared Lean edit.

## Next gates

M1 can proceed after the user supplies or approves its repository identity/remote and license, then
decides whether C220 remains. In parallel, the global all-papers Lean export needs a separately
lane-pegged task coordinating build-system ownership and existing public-`FiniteGeom` extraction
work. Every other paper gets its own deny-by-default manifest before export.
