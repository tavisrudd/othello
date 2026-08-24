# C952 recovery manuscript rebuild

**Date:** 2026-08-24

**Lane:** `complete-ports`
**Status:** in progress

## Scope

Rebuild the authoritative private manuscript around the C950 architecture and
the C951 formal boundary.  The paper uses established coding-theory terms,
contains complete human proofs for the body theorem chain, and treats the
paper-local Lean development as verification only of the associated-pair exact
sequence.  This task does not export, push, or update a public mirror.

## Theorem order

1. exact helper supports, recovery sets, normalized recovery equations, and
   bounded repair reliability;
2. the associated nested code pair and its exact sequence;
3. the identity between relative generalized Hamming weights and minimum
   helper-union costs;
4. fixed-subspace and dimension-by-dimension confinement under concatenation;
5. best-target generalized-weight, MDS, positive-density, and service-rate
   consequences;
6. separations beyond relative-weight data;
7. the projective-simplex application; and
8. the formal and computational trust boundary.

This ordering ranks results by logical dependence and use in the paper.  It
does not assign a quality score or venue prediction.

## Completed manuscript changes

- Replaced the title and abstract with the relative-weight and exact-transfer
  formulation.
- Rewrote the introduction to state the principal theorem before the detailed
  literature comparison and to distinguish the result from parameter-oriented
  concatenated LRC constructions.
- Replaced the first section with standard recovery-set and normalized-equation
  terminology and retained MDS reconstruction as a compact preliminary result.
- Added the associated nested pair, its exact sequence, the RGHW recovery-cost
  theorem, and the relative dimension/length profile interpretation.
- Added a direct block-functional proof of the fixed-subspace threshold and the
  uniform dimension-$t$ threshold, including the singleton off-by-one.
- Added the best-target generalized-weight identity, cooperative-locality
  bound, MDS thresholds and rigidity, positive-density realization, concatenated
  parameter bounds, and bounded service-rate-region transfer.
- Added `REVIEWER_GUIDE.md`, which routes a referee through the proof and
  records eight checks for hidden hypotheses, quantifier changes, convention
  shifts, computational dependence, and overstatement of formal coverage.
  The publication allowlist now includes this guide as a public review aid.
- Replaced the obsolete internal theorem map, proof ledger, and referee dossier
  with factual controls for the rebuilt manuscript. The new files contain no
  scores or venue assessments and separate human proofs from the one
  paper-local Lean-complete row.
- Adopted the nonprinting formal-annotation macros used by the
  cubic-stabilization-m1 paper. All 17 theorem-like environments now carry an
  explicit `coverage` record. The associated-pair exact sequence is the only
  `complete` row and names its four reviewer terminals; the remaining 16 rows
  are `absent`. Logical manuscript dependencies are recorded with `uses`
  annotations, and no statement carries computational `evidence`.

## Proof-integrity audit

The audit checks each displayed theorem against the following possible failure
modes: changing recovered-message rank into coefficient-space dimension;
replacing the standard RGHW minimum by a smaller complement-only minimum;
dropping the nonzero outer-functional branch at finite length; shifting the
singleton radius by one; importing the MDS formula instead of deriving it;
treating upward-closed cross-block supersets as new minimal recovery sets;
assuming reliability factors under an arbitrary direct sum; and promoting the
paper-local exact-sequence formalization to the central theorem.

Repairs made during the audit:

- stated `0 < dim I < |E|` before using `d(I^perp)`;
- made the `r+1` block-support bound explicit in the outer-dual-distance step;
- added the random-linear-code first-moment argument establishing simultaneous
  primal and dual distance for the positive-density application;
- expanded the generic-lift proof for the represented `[10,4,6]` seeds and the
  quotient-map realization of arbitrary nested pairs;
- proved explicitly that the projective dual presentation has associated pair
  `0 <= S_m`; and
- repaired source-level spacing commands that compiled as ordinary letters.
- corrected the Abdel-Ghaffar--Weber ISIT page range against the cached
  accepted manuscript's publication citation (`699--703`).

No confinement or separation theorem was strengthened as part of these
repairs. The standard random-code existence input was made explicit in the
positive-density corollary. The fixed-length outer functional term remains
outside the eventual threshold theorem, the rank parameter remains
recovered-message dimension, and central results remain classified as
human-only.

## Open manuscript work

- Obtain post-repair independent referee reads.

## Validation state

- The post-referee manuscript builds to a 17-page PDF.
- The annotation census finds 17 theorem-like environments, 17 coverage
  annotations, one Lean-complete statement, and no Lean terminal attached to
  an absent statement.
- The paper-local source-only formal-artifact checker now reads the TeX
  annotations, requires a one-to-one partition with the 17-row claim map,
  compares each coverage status and Lean-terminal list, and resolves every
  `uses` label. It passes with 17 claims, four reviewer terminals, 16 absent
  statements, and one complete statement. This check does not invoke Lean.
- The current TeX log has no undefined citation or reference and no overfull,
  underfull, LaTeX, or package warning.
- Extracted PDF text contains no leaked TeX spacing command, undefined marker,
  or visible use of `port` as terminology.
- The PDF title and author metadata match the manuscript.
- `.zenodo.json` parses successfully, and scoped `git diff --check` passes.
- The tracked release PDF is the deterministic 17-page rebuild. Extracted
  first-page text has the current title and abstract and contains none of the
  former shared-library boundary language.
- The release verifier now checks the paper-local 17-claim/four-terminal Lean
  package and no longer imports the former 36-module/61-terminal boundary.
- `make check` passes on the tracked deterministic PDF: 17 pages, warning-free,
  17 annotated claims, and four reviewer terminals.
- Four obsolete field-seven/matched-seed replay files were removed from the
  paper directory because no theorem in the rewritten manuscript depends on
  them; their history remains recoverable from Git.
- The local `lean/AGENTS.md` symlink points to the monorepo Lean norms and is
  explicitly excluded from publication; neither that file nor the norms are
  copied by the publication allowlist.
- No mirror or external deposit was changed.

## Trust boundary

The paper-local Lean companion proves the exactness of
`0 -> K_P -> D_P -> W_P -> 0`.  The RGHW identity, confinement theorem,
applications, and separations currently have human proofs only.  The
manuscript will state this boundary literally.

## EJ and TT closeout

The closeout pass retested the theorem chain from two directions: whether a
stronger conclusion was being inferred than the displayed hypotheses support,
and whether a standard object had been replaced by a narrower private variant.
It confirmed the following points.

- The complement step gives the standard RGHW, not a restricted
  complement-only weight.
- The outer-functional mechanism is removed only eventually and only by the
  stated dual-distance hypothesis.
- The singleton formula uses helper radius on one side and total dual weight on
  the other, with the target-coordinate shift displayed.
- The direct-sum reliability separation uses forced padding; no general
  reliability-factorization claim remains.
- The projective Möbius formula includes the full Bernoulli weight before
  inversion.
- The formal companion is not cited as evidence for an absent central theorem.

### Mystery ledger

The first independent referee read found one proof gap in the best-target
escape consequence: the proof applied a recovered-message theorem directly to
the full coordinate identity when the target columns could be dependent. The
repair now factors the identity through `im G_P`, proves that target-kernel
directions use no helpers, and then repeats the block-functional lower and
attainment argument. The same read found and closed the abstract's
upward-closure overstatement and the stale release package.

The original independent referee re-read the repaired tree and returned PASS:
all eight prior mathematical, terminology, citation, metadata, and release
findings are closed. A fresh independent referee then found a finite-length
quantifier error in the service-rate corollary. The corollary now assumes the
exact outer gate `d(O^perp)>r+1` and states the growing-dual-distance family
consequence only eventually. The same qualifier is explicit in the
positive-density statement and conclusion.

The fresh read also prompted four non-theorem repairs: the concatenated
normalization for a fixed inner target space and the outer-coordinate
surjectivity criterion are explicit; full-quotient reliability is defined
before use; every detached proof carries a checked `proves` label; and the
release gate consumes an exact 37-file distribution manifest and rejects
unexpected tracked files in a standalone checkout, except for the exporter's
three standard metadata files, which are scanned when present.

A subsequent qualification-removal pass strengthened the confinement
statements from an eventual-family formulation to the exact finite form.  For
one `L`-linear outer code, `N>=2` and `d(O^perp)>r+1` remove every nonzero
outer-functional tuple, after which the inner inequality
`r<M_t(D_P,K_P)+d(I^perp)` is necessary and sufficient.  Outer families of
growing dual distance now appear as a corollary.  The abstract, main theorem,
two confinement theorems, claim manifest, theorem map, proof ledger, README,
and reviewer guide state the same quantifiers.

The same pass added two scope clarifications.  Recovery rank `t` is the
dimension of a subspace of `W_P`, not the cardinality of the erased target
set; full target recovery is the case `U_P` lies in the helper-column span and
`t=dim U_P`.  A single block-local transfer paragraph explains that normalized
systems transfer coefficient-dependent statistics and their inclusion-minimal
supports transfer reliability and service-rate data, while explicitly
excluding equality of the global upward-closed set families.

The MDS calculation now has no target-size or helper-span restriction.  With
`u=min(k,|P|)` and `b=min(k,|J|)`, it gives `ell=u+b-k` and
`M_t=k-u+t` for every recoverable rank `1<=t<=ell`.  The helper-span
hypothesis `|J|>=k` is used only for `ell=u` and equality in the global
ceiling.  This follows directly from the uniform-matroid intersection formula;
no relative-MDS property is assumed.

The exact 37-file distribution was also copied into a temporary standalone
Git repository and checked there.  The manifest equality gate, deterministic
TeX rebuild, source-level formal checker, 17-claim partition, four Lean
terminals, and byte comparison all passed; the result was 17 warning-free
pages.  No Lean or Lake command was run.

A final fresh read identified four unused private control files that still
described the superseded monolithic manuscript and shared formal boundary:
`formalization-ledger.md`, `formal-statement-adequacy.md`,
`verification-map.md`, and `claim-proof-novelty-ledger.md`.  They were not in
the public distribution manifest and no current file referred to them.  They
were removed; the current control surfaces are `theorem-map.md`,
`proof_ledger.md`, `referee-dossier.md`, the claim manifest, and the reviewer
guide.

The same read found one strict annotation-boundary mismatch.  The four named
Lean terminals prove the inclusion, image, surjectivity, and kernel statements
making up the displayed exact sequence, but no named terminal states the
quotient isomorphism.  The quotient sentence was moved outside the
Lean-complete proposition and is now explicitly obtained by the first
isomorphism theorem.  Thus `complete` scopes exactly to what the four reviewer
terminals state; the quotient consequence remains a human derivation.

The projective and coefficient-presentation examples were also synchronized
with the finite outer gate.  They now compute the literal sum
`M_t(D_P,K_P)+d(I^perp)` and identify it as the first nonconfinement cost only
in outer families with growing dual distance.  They no longer imply that a
short fixed outer code cannot have a cheaper nonzero-functional escape.

Two edge conventions are now explicit in the paper setup: the inner
encoder is an `F_q`-linear isomorphism from the outer alphabet onto `I`, which
justifies `ker Phi_I=I^perp`, and the minimum distance of the zero code is
`infinity`, so the finite gate includes the full-space outer code without an
undefined expression.

The read-only trust audit found that the monorepo files
`lean/trust/paper-facts/complete_repair_ports.json` and
`lean/trust/areas/complete_ports.toml` still describe the superseded shared
61-terminal boundary.  The current manuscript, checker, reviewer guide, and
37-file distribution do not consume or cite them.  They remain explicitly
outside the paper-local four-terminal boundary and outside this task's edit
scope; no claim in the rebuilt paper derives authority from them.

The final `ej` and `tt` closeout settled the remaining task-owned questions:

- **Finite versus eventual confinement — settled.**  The finite outer gate is
  now the theorem statement; the eventual form is a corollary.
- **MDS hypothesis slack — settled.**  The target/helper-symmetric formula
  removes both size restrictions and isolates helper-span only as the equality
  condition for the global ceiling.
- **Formal overcoverage — settled.**  The four Lean terminals cover exactly the
  displayed exact sequence; the quotient isomorphism is separately
  human-derived.
- **Block-local versus global recovery sets — settled.**  Transfer is stated
  for normalized systems and inclusion-minimal supports, with global
  upward-closed supersets explicitly excluded.
- **Legacy shared trust records — outside C952.**  They are excluded from and
  unused by the paper-local release.  Updating or retiring them belongs to the
  separately owned shared-Lean/export work, not this manuscript rebuild.

No other genuine C952 mathematical mystery remains.  Relative Wei duality may
give a useful ambiguity/failure interpretation, but adding that branch would
expand rather than simplify this manuscript and is left to a successor.

The final independent referee verdict is READY with no open mathematical,
formal-boundary, terminology, or packaging finding.  The final paper-local
gate and an exact-manifest standalone rehearsal both pass: 17 warning-free
pages, 17 claim rows, four Lean reviewer terminals, and deterministic PDF byte
identity.  The accepted PDF SHA-256 is
`4310ef67c29c5f5bbd87239c594cde1af7cd805375e836553bd95e62ce3b849a`;
the distribution-manifest SHA-256 is
`7ecdba5e8a871567ae5c101a58ee146e3701d3a20b7900749f5073ec34d02f6d`.

## Post-close local export

On 2026-08-24 the committed authority was exported through
`papers/scripts/export-paper-repos.py` to the existing standalone repository
`/home/tavis/src/math-papers/complete-repair-ports`.  The exporter plan and
audit reported 37 distributed files and zero findings.  Five superseded
finite-evidence/figure files were removed in the separate recoverable mirror
commit `c934fc1`; the synchronized paper is mirror commit `2d90a8b`, derived
from authority commit `ae05e168e`.

The standalone release gate passes with 17 warning-free pages, 17 claims, and
four Lean terminals.  The exporter verification reports 40 tracked files: the
37-file scholarly distribution plus `.gitignore`, `PROVENANCE.md`, and
`export-manifest.json`.  The PDF and distribution-manifest hashes match the
authority byte for byte.  No push or Zenodo deposit was made.

Formalization of the RGHW and confinement theorems is absent by explicit
choice, not silently assumed. A future formalization would require new claim
rows and reviewer terminals before the paper could change that statement.

## Post-referee literature positioning audit

This focused attribution audit names three sources: one was read at full text
and two at abstract/metadata depth.

- **Full text:** Yuan Luo, Chaichana Mitrpant, A. J. Han Vinck, and Kefei Chen,
  *Some New Characters on the Wire-Tap Channel of Type II*, IEEE Transactions
  on Information Theory 51 (2005), 1222--1229, DOI
  `10.1109/TIT.2004.842763`. The published PDF was read in full, with Sections
  III--IV used for the original RDLP/RGHW definitions, their inverse relation,
  strict growth, access interpretation, and generalized Singleton bound.
  Shared-cache key `10.1109/TIT.2004.842763`, SHA-256
  `eecbc9e01441c1a6955eeb60d17536856957c9d8b3b5ce110dbd1226d9276fd1`.
- **Abstract/metadata only:** Arrigo Bonisoli, *Every Equidistant Linear Code Is
  a Sequence of Dual Hamming Codes*, Ars Combinatoria 18 (1984), 181--186.
  The University of Modena and Reggio Emilia institutional record and the
  journal's volume contents were consulted on 2026-08-24. They state the
  classification and bibliographic data; full text was not located. The
  manuscript uses this only for historical positioning, while retaining its
  complete fixed-length proof.
- **Abstract/metadata only:** Ankit Singh Rawat, Arya Mazumdar, and Sriram
  Vishwanath, *Cooperative Local Repair in Distributed Storage*, EURASIP
  Journal on Advances in Signal Processing 2015, article 107, DOI
  `10.1186/s13634-015-0292-0`. The open-access publisher page and article
  metadata were consulted on 2026-08-24 for the originating cooperative-local
  repair terminology and bibliographic data; no theorem in this manuscript
  imports a result from that paper.

Load-bearing web queries were `"Relative generalized Hamming weight" first
introduced Luo Mitrpant Vinck Chen DOI`, `10.1109/TIT.2004.842763 pdf`, and
`Bonisoli Every equidistant linear code is a sequence of dual Hamming codes
1984 DOI`. No negative novelty claim rests on this focused audit. MathSciNet
and Google Scholar were not covered; zbMATH Open supplied corroborating
metadata for the Bonisoli record.
