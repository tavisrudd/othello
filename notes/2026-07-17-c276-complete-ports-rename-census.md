# C276 complete-ports and restoration-semantics rename census

**Lane:** `repaircodes` (unchanged; approved paper shorthand: `complete-ports`)

**Status:** COMPLETE — the physical paper paths, public-export names, prose references, and
validation gates for the two approved paper identities are inventoried. No path, alias, title, or
file was renamed in C276. The `repaircodes` lane identity is explicitly out of rename scope.

## Approved canonical identities

| Paper | Title | Paper shorthand | Repository / staging directory | Main source / PDF stem |
|---|---|---|---|---|
| complete-ports paper | *Complete Bounded Repair Ports: Transfer, Reliability, and Geometric Structure* | `complete-ports` | `complete-repair-ports` | `complete_repair_ports.tex` / `.pdf` |
| restoration-semantics paper | *Compositional Restoration Semantics: Finite Interfaces and Infinite Timing* | `restoration-semantics` | `compositional-restoration-semantics` | `compositional_restoration_semantics.tex` / `.pdf` |

The old names `M1` and `M2` cease to be canonical. `repaircodes` remains the current lane alias,
handoff identity, queue peg, historical provenance, and Lean-family name; it is not renamed by this
paper census. `RepairCodes` Lean declarations/modules likewise remain unchanged.

## Physical rename map: complete-ports

The current private paper package contains exactly six files. The atomic in-monorepo staging rename
is:

| Current path | Canonical path | Action |
|---|---|---|
| `papers/coding-repair-hypergraphs/` | `papers/complete-repair-ports/` | directory rename |
| `complete_repair_hypergraphs.tex` | `complete_repair_ports.tex` | rename and update title/build references |
| `complete_repair_hypergraphs.pdf` | `complete_repair_ports.pdf` | rebuild from renamed TeX; do not byte-edit |
| `README.md` | `README.md` | retain filename; rewrite title/status/build command |
| `refs.bib` | `refs.bib` | retain filename; citation audit only |
| `proof_ledger.md` | `proof_ledger.md` | retain filename; update paper identity and new section ledger |
| `adversarial_novelty_review.md` | `adversarial_novelty_review.md` | retain private filename; update paper identity only, still excluded from public export |

Related private artifact renames:

| Current path | Canonical path |
|---|---|
| `papers/expert-profiles/05-coding-repair-hypergraphs.md` | `papers/expert-profiles/05-complete-repair-ports.md` |
| `notes/2026-07-17-c274-complete-port-manuscript-crosswalk.md` | `notes/2026-07-17-c274-complete-ports-manuscript-crosswalk.md` |
| `notes/2026-07-17-c275-m1-publication-boundary-manifest.md` | `notes/2026-07-17-c275-complete-ports-publication-boundary.md` |
| `notes/2026-07-17-c275-m1-publication-allowlist.tsv` | `notes/2026-07-17-c275-complete-ports-publication-allowlist.tsv` |

The C275 allowlist must also map the private source to
`complete_repair_ports.tex`, not `paper/main.tex`, matching the approved public filename. The clean
public repository remains a fresh-history allowlisted export; the private directory rename does not
authorize publishing monorepo history.

## Lane boundary: preserve `repaircodes`

The paper rename must not become a lane rename. Preserve all of the following exactly:

1. root `AGENTS.md` alias `repaircodes` and its current handoff target;
2. `notes/handoffs/2026-07-13-projective-completion-repaircodes.md`, including its H1 lineage and
   required `**Lane**: repaircodes` field;
3. the live queue section `repaircodes`, all `[repaircodes]` task pegs, and all archived pegs;
4. `repaircodes` owner/lane references in C259 and other planning records; and
5. `RepairCodes`, `RepairPorts`, and every Lean declaration/module namespace.

Only replace `M1` wording inside the live handoff with “complete-ports paper”; do not change the
handoff path or lane field. Current C274/C275 reports retain their historical
`**Lane:** repaircodes` fields while their paper shorthand and filenames change.

## Reference census: old complete-ports identity

The exact path/stem pattern `coding-repair-hypergraphs|complete_repair_hypergraphs` occurs 36 times
across 17 tracked Markdown/TeX/Bib/Lean/Python/shell files outside build trees. Excluding filenames
containing `archive` leaves 14 files, although several remaining `handoffs/done/` files are still
historical records.

The affected non-archive-name set is:

- `papers/coding-repair-hypergraphs/{README.md,complete_repair_hypergraphs.tex}`;
- `papers/{papers-index.md,papers-planning.md,expert-profiles/README.md}`;
- `notes/2026-07-13-papers-review-by-opus+fable.md`;
- `notes/2026-07-15-dye-bsw-primary-source-audit.md`;
- `notes/2026-07-16-repaircodes-a-plus-roadmap.md`;
- `notes/2026-07-17-c238-repairports-commercial-algorithms.md`;
- `notes/2026-07-17-c259-rp-next-execution-packets.md`;
- `notes/handoffs/2026-07-11-lean-formalization-plan.md`;
- the current complete-ports handoff; and
- historical `handoffs/done/2026-07-13-repaircodes-strengthening-plan.md`,
  `handoffs/done/2026-07-16-repairports.md`, and `handoffs/done/2026-07-16-rp-next.md`.

Three additional filename-marked archives contain the old path/stem: the global task-queue archive,
the old Lean-plan archive, and the projective-completion handoff archive. Mechanical link repair is
required if the private directory/handoff/report files move; historical prose and lane pegs should
otherwise remain intact.

The old handoff filename has six known references, but none belongs to the paper rename. Leave all
six and the handoff path unchanged.

The title-family search (`Complete repair hypergraphs`, lower-case variants, and the new bounded-port
phrase) reaches 23 non-archive-name files. This is a semantic review set, **not** a global replace
set. In theorem statements, `repair hypergraph` can remain the correct support-layer object inside a
broader repair port. Rename paper identity, headings, contribution framing, and registry entries;
retain mathematical uses that specifically mean the hypergraph layer.

Registry/profile changes include:

- `papers/papers-index.md`: directory key, title, status narrative, and short alias line
  (`coding = coding-repair-hypergraphs` becomes `complete-ports = complete-repair-ports`);
- `papers/papers-planning.md`: Paper 5 title/directory and the description of the broadened spine;
- `papers/expert-profiles/README.md`: row 5 title and profile filename; and
- `papers/expert-profiles/05-coding-repair-hypergraphs.md`: filename, H1, and paper framing.

## M1/M2 token census

Only contextual packet documents should be changed; repository-wide bare `M1`/`M2` replacement is
forbidden because those tokens are also mathematical/model identifiers in unrelated work.

The six known packet/live documents contain 38 relevant tokens:

- 32 `M1` tokens: C259 (13), C274 (8), C275 manifest (6), current handoff (4), and C275 allowlist
  (1);
- 6 `M2` tokens: C259 (5) and C274 (1).

Replace those with grammatical forms of `complete-ports paper` and `restoration-semantics paper`.
The C274/C275 filenames change as listed above. C258 already uses descriptive reward headings and
needs only title normalization, not an `M1`/`M2` token replacement.

## Restoration-semantics census

No restoration-semantics paper directory, main source, PDF, handoff, routing alias, or live task
exists yet. This is a creation map, not a physical rename.

Current planning references are small:

- C259 contains the five `M2` tokens, three `repair-semantics` alias references, and the proposed
  `papers/bounded-restoration-semantics/` destination;
- C274 contains one `M2` comparison; and
- `notes/2026-07-16-repairports-applications-brainstorm-response.md` contains one descriptive
  `repair-semantics` packaging reference.

The implementation should normalize the **paper shorthand** to `restoration-semantics`, directory
`papers/compositional-restoration-semantics/`, and title/file stem from the canonical table. C259's
proposed `repair-semantics` owner lane is a separate routing decision and is not renamed by this
census. The paper index/planning registry should add the paper at creation time, not during the
complete-ports physical rename.

## Generated and external references

- Rebuild `complete_repair_ports.pdf`; do not rename the old PDF and treat it as validated output.
- Update the README build command from `tectonic complete_repair_hypergraphs.tex` to the new stem.
- Search PDF metadata and TeX auxiliary outputs only in the fresh paper build; do not commit or scan
  private build debris.
- No Lean namespace/module rename is part of this operation. Public paper ledgers may cite
  `RepairCodes` and `RepairPorts.FunctionalCost` while the paper/lane alias is `complete-ports`.
- Remote repository names, URLs, badges, DOI/archive metadata, `CITATION.cff`, and shared-Lean commit
  pins do not exist yet; create them from the approved public identities rather than renaming a
  private remote.

## Recommended atomic implementation order

1. Allocate one `[repaircodes]` paper-identity task; do not change routing.
2. Rename the paper directory, TeX source, C274/C275 paper artifacts, and expert profile with
   explicit paths. Leave the repaircodes handoff path unchanged.
3. In the same coherent edit, update M1/M2 paper shorthand in C259/current C274/C275/handoff prose,
   registry/profile references, C275 allowlist destinations, build command, and every link to moved
   paper/report files. Preserve every `repaircodes` lane reference.
4. Repair paper/report links in historical records without rewriting lane pegs, lane ownership, or
   mathematical conclusions.
5. Run bounded stale-name scans for the old directory, old TeX stem, contextual `M1`/`M2`, old live
   alias, old handoff/report filenames, and old expert-profile filename. Manually adjudicate generic
   `repair hypergraph` wording.
6. Build the renamed PDF through the paper's documented command only after source edits begin; the
   census itself does not authorize a build.
7. Commit the complete-ports paper-identity migration atomically. Create restoration-semantics paper
   files in a separate task; any lane-routing decision is separate from both paper renames.

## Completion gate for the rename task

The migration is complete only when `go repaircodes` still resolves the unchanged repaircodes
handoff, the live queue and all lane pegs remain `repaircodes`, all moved paper/report links resolve,
the paper registry and expert profile use the canonical complete-ports identity, the new TeX/PDF
stem is consistent, contextual M1/M2 paper labels are gone, the public allowlist names the new
source/destination, and no paper-only replacement has altered a Lean or lane identifier.
