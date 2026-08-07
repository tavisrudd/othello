# C864 — complete repair ports: editorial determination on its internal working documents

**Lane:** `build-sys`

**Date:** 2026-08-06

The export-completion execution plan's second pass asks for the editorial decision on the working
documents that carry this paper's 128 export findings, then its release chain and its mirror
synchronization. This document takes that decision, records the one repair that was in reach, and
records why the release chain and the mirror synchronization did not run.

The plan speaks of eleven documents. The scanner reports ten: `README.md`, `sections/README.md`,
`proof_ledger.md`, `adversarial_novelty_review.md`, `theorem-map.md`, `formalization-ledger.md`,
`formal-statement-adequacy.md`, `verification-map.md`, `claim-proof-novelty-ledger.md`, and
`second-draft-fix-plan.md`. The eleventh appears to have been the `internal-process-file`
classification counted as a document of its own; it is a second finding kind on six of the ten, not
a further file. The determination below covers all ten.

## The discriminator

A document belongs in the public repository when it tells a reader **what the paper claims and on
what evidence**. It stays private when it tells the project **how to decide what to write**:
adoption authority, work order, task ownership, promotion rules, and reviewer session plans. The
question is not whether the identifiers can be scrubbed. Several of these documents would survive
a scrub and still be the wrong thing to publish, because their subject is the editorial process
rather than the mathematics.

Applying that test splits the ten evenly.

## Public evidence surface — five documents ship

| Document | Why it ships | What must change first |
|---|---|---|
| `claim-proof-novelty-ledger.md` | Per claim family it separates human proof, Lean status, computation, and the literature/novelty boundary. This is precisely what a referee needs to see and what keeps the paper's cautious novelty language checkable. | Drop the `Manuscript action` column and the promotion rule. Both are editorial control, and once the manuscript is frozen every row is simply in or out. |
| `formalization-ledger.md` | Maps each stable paper label to its exact Lean declarations and states the present boundary. It is the paper's formal-coverage claim in checkable form. | Drop the `Owner` column and the `Aggregate gate` section, which instruct a task rather than inform a reader. |
| `formal-statement-adequacy.md` | Compares the printed theorem with its Lean terminal field by field — domain, hypotheses, conclusion, trust boundary. This is the single strongest trust artifact the paper has. | The `Status` column must be `PASS` throughout. A published adequacy table with `PENDING` rows would advertise that the paper's own gate does not clear. |
| `verification-map.md` | Separates human proof, Lean route, classical import, and finite computation, and states the permitted role of computation for each claim group. It is what stops a reader mistaking a certificate for a proof. | Replace the finite-bundle task names with descriptive artifact names, and drop the `Release boundary` section. |
| `README.md` | The repository front door. | Remove the `Publication boundary` section entirely — it is private-monorepo policy, not reader-facing — drop the correction-pass and omitted-strengthening references that name tasks, and make the `Files` list name what actually ships. |

## Internal editorial control — five documents stay private

**`theorem-map.md`.** This is an adoption-control surface. It decides which results *may* appear in
the main spine, carries an `Owning task` column, and grades each slot `ADOPTED`, `RECONCILE`, `TO
FORMALIZE`, `APPENDIX COMPUTATION`, or `CUT/DERIVE`. Its function ends the moment the manuscript is
frozen, and what survives it — the adopted hierarchy — is already the paper's own structure.
Publishing it would tell a reader which theorems were considered and set aside, which is editorial
deliberation rather than evidence.

**`second-draft-fix-plan.md`.** Project management throughout: a numbered work order by task,
correctness and proof-architecture and exposition gates, a cold-read session table with acceptance
criteria, and a release rule. Nothing in it is an assertion about the mathematics.

**`sections/README.md`.** A plan for a modular rewrite that has not begun, naming eight section
files that do not exist and conditioning their creation on other tasks passing their gates. It
documents an intended file layout, not the paper.

**`proof_ledger.md`.** Explicitly superseded — the paper's own README says it "remains the detailed
source inventory until the new ledgers have absorbed and validated every retained row" and "is not
the admission authority for the revised body." It also cites private `notes/2026-07-*` script and
certificate paths as evidence locations, which have no public existence. Publishing a superseded
ledger beside the four current ones invites a reader to cite the wrong boundary. Its still-live rows
must be absorbed into the current ledgers before it is retired, which is already the stated
condition for retiring it.

**`adversarial_novelty_review.md`.** The paper's own README already records this decision:
"internal novelty and overclaim audit; excluded from export." The determination here confirms it
rather than reopening it. The document's conclusions already reach the public surface through the
novelty ledger's literature and novelty column and through the manuscript's own cautious wording;
what would be added by publishing it is the wording directive itself — the instruction to say "we
did not locate" and never "first" — which is editorial instruction, not result.

## Mechanism: move them, do not exclude them

The five private documents move out of `papers/complete-repair-ports/` to a location the
`complete-ports` lane owns, so the exporter never sees them and the lane keeps them live for the
open work that still references them.

They must not be handled with a `papers/repositories.toml` exclusion. The export-and-mirror
conventions forbid masking the scan, and an exclusion would leave the documents inside the export
root where the next scan raises them again. Moving them is also the only handling that is honest
about what they are: they are lane working state that was placed in a paper directory, not paper
material that happens to be unfit for release.

The move is not yet executed. It rewrites the live control surface of an active foreign lane —
the `complete-ports` handoff links six of these documents by name as "paper control for the revised
draft," and its open items still work from them — and the export it would unblock is itself blocked
for the reasons below. Executing it now would disturb a running lane and unblock nothing.

The five documents that ship still carry task identifiers in their own text, in owner columns and
finite-bundle names. Those are ordinary content edits in the authority, and they are the smaller
half of the work.

## What ran: the bibliography and the rebuilt PDF

Commit `f415dfb6`. The paper cited Clebsch rigidity by a superseded title under an `@unpublished`
entry. It now carries the registered current title, *Reconstructing the Clebsch Code and Its Golden
Orientation from Its Deep-Hole Syndrome Locus*, in the same `@misc` preprint form the other papers
use. That clears the `stale-bbl` error; `paper-facts.py check` now reports nothing for this paper
beyond the pre-existing untracked-bibliography warning.

Rebuilding through the README's documented `tectonic` command exposed a second defect the task did
not go looking for. The tracked PDF predated commit `ffeca335` of 2026-07-26, which added the
AI-assistance disclosure to the tracked source. The PDF had therefore been stale against its own
`.tex` for eleven days, and the refreshed artifact is a page longer. Nothing detected this, because
this paper has no manuscript checker — the byte-reproducible rebuild-and-compare that every paper
with a release chain uses is exactly the gate that catches it.

## Why the release chain did not run

**There is no release chain.** `papers/complete-repair-ports/` has no `verification/` directory.
Every paper in the repository that has a release chain has one, including the gated golden operator
programme. The plan's step — run the chain "per its `verification/README.md`" — has nothing to run.

Building one is real work rather than an oversight to correct in passing: a pin block, a statement
identity and trust manifest generator, a manuscript checker pinning `SOURCE_DATE_EPOCH`, and an
aggregate release verifier. The pin surface is constructible, because the paper's Lean terminals
live in `RepairCodes` and `RepairPorts` and that area is registered and adopted. It does not exist
yet. The stale PDF above is the direct cost of its absence.

## Why the mirror was not created

`~/src/math-papers/complete-repair-ports` does not exist, so this would be a `materialize` — a new
public-intent repository — rather than the refresh of an existing one. Three independent records say
the paper is not ready for that.

Its lane handoff carries the status `PUBLIC RELEASE GATED`, with the pointed-Tutte and harmonic
proof gates open, the modular rewrite not begun, and the aggregate formal and prose audits not run.
`papers/papers-index.md` records that "external specialist citation-chain review, immutable
checker/archive identity, shared-Lean public closure, adequacy/provenance integration, and
public-export gates remain before submission." And the paper's own control documents disagree with
its own manuscript: four of the twelve adopted theorem slots — the pointed-Tutte specialization, the
filtration boundary, the cubic application, and the harmonic application — stand at `PENDING`,
`SOURCE GREEN`, or `BLOCKED-BODY`, and the manuscript on disk is the monolithic twelve-page draft
those documents describe as superseded.

Two further mismatches sit underneath this. `papers/repositories.toml` marks the paper
`disposition = "active"`, and that is the only reason materialization would be permitted at all; the
registry already carries a `gated` disposition used for exactly this situation by the dihedral
Schreier node Kayles and golden operator entries. And the destination on record in both the paper's
README and its lane handoff is `tavisrudd/complete-ports` at `~/src/papers/complete-ports` under the
MIT license, not `~/src/math-papers/complete-repair-ports`.

## Recommended order

1. Re-mark the registry entry `gated`, so the disposition matches the paper's actual state and no
   later pass can materialize it by accident. This is the one item worth doing immediately and
   independently of everything else.
2. Settle the destination — the `math-papers` repository name against the `complete-ports` name and
   staging path both the README and the handoff record — before any tree is created.
3. Let the `complete-ports` lane close its open proof gates and its modular rewrite. The five
   private documents stay where they are until then, because that lane is still working from them.
4. Build the paper a release chain, at the point where a frozen manuscript makes a pin block
   meaningful.
5. Then execute the move, clean the task identifiers out of the five documents that ship, rewrite
   the README, and materialize.

Steps 3 through 5 belong to the `complete-ports` lane's own sequence, not to C864. What C864 owns
here is the determination itself, the bibliography repair, and the registry disposition.
