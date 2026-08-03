# C842 — establish the MDS--CSS transversal-groups paper

**Lane:** `ame-lu`
**Status:** complete

## Result

Phases A and B of the frozen two-paper split are complete. The combined
58-page manuscript remains recoverable and Paper I has not been trimmed.
Paper II now has the independent authoritative root
`papers/mds_css_transversal_groups` and the title *Diagonal Isoduality and
Transversal Clifford Groups of MDS--CSS Codes*.

The Paper II abstract and first theorem lead with the all-length nullity test:
for an odd-prime linear `[2m,m,m+1]_q` MDS code, the diagonal code-to-dual
multiplier space has dimension zero or one, and this selects the exact
fixed-party projective transversal logical group
`F_q^2 semidirect SL_2(q)` or `F_q^2 semidirect T`. The manuscript cites Paper
I's rigidity, transversal no-go, and stabilizer-character correction as inputs
and does not claim to prove them independently. The six-arc phase, pencil,
Clebsch, scalar-blindness, finite-separator, transport, and party-extension
material now appears as Paper II applications or appendices.

## Frozen baseline and ownership

Both successor roots carry provenance records linking them to:

- combined monorepo checkpoint
  `3400ff6ed6056b0a5ef52512619b30dae3adafa4`;
- public paper tree
  `2ada0216f5176543f8e7612f38e0cba62e4406bf81a36a6593a55288ea3d98cd`;
- formal-companion tree
  `b030f559acc08ef110f5a1bbbe29f1b84c19541fab44b191703dcc827d5b4bc9`;
- standalone `ame-lu` checkpoint
  `a52d7ea7b0da815ae5211614c82a19fc2eed9d14`; and
- public `finitegeom` checkpoint
  `570086982b26075a71a331a81bb1b519e9a27e7f`.

`papers/ame_lu/cross-paper-theorem-ownership.md` assigns all 63 theorem-like
labels in the frozen combined source to exactly one successor. A mechanical
coverage check reports `63/63`, with zero missing labels. Each row records the
source report, proof location, computation boundary, literature posture, Lean
surface, other-paper treatment, and frozen label.

Paper II has separate theorem, claim/novelty, verification, formalization,
adversarial-review, and revision ledgers. The paper and standalone registries
now contain `mds_css_transversal_groups` and
`mds-css-transversal-groups`, with all six internal records excluded from the
future public export. No standalone repository was materialized and no remote
action occurred.

## Evidence and validation

The complete 17-artifact computational package moved byte-for-byte into Paper
II. Its manifest schema and trust prose now name Paper II, while the eight
canonical generator/certificate bundles retain their semantic filenames.

- `make check`: PASS, warning-free 22-page PDF;
- PDF: 197,560 bytes, SHA-256
  `7889a48d5ab19f389283f8ed3a0e319b3a4feeab826abf668c15899976337c11`;
- `python3 supplement/verify.py`: PASS, 17 artifacts;
- `python3 supplement/verify.py --replay`: PASS, all eight bundles, exit 0,
  7m19s, empty stderr;
- frozen-label ownership audit: PASS, 63/63 labels, zero missing;
- exporter `plan` at commit
  `1ce760c11c7d11953f478c67b95cba9856c5686a`: 42 public files,
  2,230,485 bytes, six explicit internal exclusions, no symlinks or reference
  findings;
- exporter `audit` at the same commit: PASS, zero findings.

The authoritative implementation checkpoint is commit `1ce760c1`. The task-ID
reservation is separately preserved by commit `2cdebfb2`.

## Boundaries

- Paper I remains the combined source and still owns the inherited evidence
  package until its Phase C trim; no theorem or artifact was removed from it.
- No Lean source, semantic gate, release manifest, formal-root contract,
  `finitegeom` checkout, standalone repository, remote, DOI, or submission
  surface was changed.
- Paper II's formalization prose names the future semantic gate but explicitly
  says it has not yet been created or validated. The former broad `AMELU`
  filename closure is not presented as Paper II evidence.
- The frozen Paper I source-tree hash supplies the stable local record for the
  imported theorem. A publication-grade cross-paper locator remains a later
  release task and must not misuse the `finitegeom` concept DOI as a paper DOI.

## Extra-juice and Tao closeout

The cheap closeout upgrades were all adopted: both provenance records, the
63-label mechanical ownership audit, the Paper II-specific evidence schema,
the rewritten group figure, and an immutable exporter audit. The strongest
structural check is that the exact group theorem remains independent of the
finite six-point census: the lower bound is constructed from the unique
multiplier line, and Paper I supplies only the general Clifford exclusion.
Thus the split does not turn a computational application into a hidden premise.

## Mystery ledger

| Feature | Closeout status | Exact remaining evidence gap or owner |
|---|---|---|
| Paper II is 22 pages, below the plan's 25--30-page expectation but at the top of its 18--22-page body target | open, not padded | a later theorem-only cold read must decide whether any proof bridge is too compressed; page count alone is not a defect |
| The rewritten exact-group figure was not part of C805's original blind comparison | open | Paper II cold/visual review must test whether the new branch diagram improves comprehension and remains legible |
| `EncoderTransversal` mixes Paper I Choi material with Paper II exact-carrier material | unchanged and explicit | the future build-system formal-split task owns the semantic module/gate boundary after Phase C stabilizes Paper I |
| Paper I has no final public paper identifier for the cross-paper citation | locally settled, publicly open | the frozen content hash is the present stable record; release synchronization owns the eventual immutable public citation |
| Any hidden dependence of the all-length theorem on the finite census | settled | theorem/proof/evidence audit confirms none; no genuine mystery remains here |

The discovery-track discriminator found no incidental observation from this
planned extraction work, so the append-only companion received no manufactured
entry.
