# C1110 — second referee revision

**Lane**: `continuation`
**Date**: 2026-09-08

## Result and scope

Addressed the author's follow-up review of the q>=9 draft. The review reports
no theorem-level error and accepts the five-clique cases, algebraic lemmas,
faithfulness, direct product, Hamming restriction injectivity and recognition
soundness. This revision completes the precise artifact citation and local
exposition corrections, simplifies centre recovery to edge seeds, and proves
the O(n^(7/2)) recognition bound. It also displays the Hamming generators and
makes the frame proof continuous. No new release, push, broad priority audit,
Lean formalization or computation-free boundary classification is claimed.

## Response by item

| Feedback | Disposition |
|---|---|
| 2.1 No main error | Retained the accepted rigidity and coding proofs; substantive new proof work concerns only centre seeds and operation counts. |
| 2.2 Artifact locator | Added `CensusArtifact` bibliography entry, version DOI 10.5281/zenodo.22651106, repository URL and full immutable Git revision inside the manuscript. The census proof cites it directly. Appendix explicitly distinguishes original census evidence from later manuscript/recognizer changes. |
| 2.3 Uniform minimality | Added the rook automorphism and ambient stabilizer orders, the matrix count and strict ratio for every q>=4. Inversion is proved nonambient for every q>=5 via 1<=p^r<=q/2<q-2; small q=3,4 exceptions are stated. |
| 2.4 Assignment convention | Defined dir(Q-r)=dir(P-pi_Q(r)); made direction distinctness explicit and identified the displayed equations with pi_R=(u v w). |
| 2.5 Bibliography/disclosure | Added FHMW's published EJC 61 (2017), 91–105 reference and DOI while explicitly retaining arXiv-v3 lemma numbering. Disclosure and README now call this a revised draft. |
| Suggestion 1 | Added `lem:centre-seeds`, used edge closures in the recognizer, and replaced the coarse O(n^6) theorem with O(n^(7/2)). |
| Suggestion 2 | Displayed all three position-and-symbol generators, their point maps and frame transpositions, and componentwise Frobenius. Verified the formulas and finite generated groups. |
| Suggestion 3 | Main path is now normal form, five-clique bound, frame centre recovery, algebraic rigidity/coding. General-k bounds and uniform minimality follow. Keywords foreground code extension; MSC 94B27 replaces 14H10. |
| Suggestion 4 | Kept structural q=7,8 explanations as the stated research priority. No new boundary project or extra routine replay framework allocated. |

## Mathematical checks

An outside trace is disjoint from at most one member of a centre class: its
intersection with the secant between the two remaining frame points determines
the only possible disjoint trace. Hence a same-class edge has exactly the rest
of its class as common neighbours. A mixed-class clique has at most four
members, so retaining clique closures of size q-2>4 introduces no false class
on a true frame graph. Arbitrary-input soundness still comes from the final
coordinate and adjacency check.

After checking n=(q-2)(q-3) and degree d=4(q-4), four-clique candidates number
O(nd^3)=O(n^(5/2)). Each closure costs O(n); the size filter precedes the
O(q^2)=O(n) clique check. Sorting retained ordered vertex lists for deduplication
fits within O(n^(7/2)). On O(sqrt(n)) trace vertices, edge closures and clique
checks cost O(n^2). The remaining table and image searches cost O(n^(5/2)).
All bounds apply to unpromised inputs that pass the preliminary checks.
The recursive fixed-size clique enumerator already explores a vertex and later
neighbours, so it fits this candidate bound; only the centre seed size changes
in the implementation. This is an operation bound, not a timing claim.

The word formulas come from (x,y)->(y,x), (x/y,1/y), and (1-x,1-y).
These realize the three adjacent transpositions of the normalized ordered
frame. All symbol maps are defined over the prime field and commute with
Frobenius. The tests give S4 of order 24 and full orders 48,96,48 at q=9,16,25.

## Artifact identity and provenance check

Fetched Zenodo record 22651106 through its public API. Metadata identifies
version 0.1.0, release date 2026-09-08 and the GitHub v0.1.0 archive. Downloaded
the actual ZIP and checked its MD5 against the API, inspected its Git archive
comment, and compared its boundary.json with the current file byte-for-byte.

| Object | Identity |
|---|---|
| Version DOI | 10.5281/zenodo.22651106 |
| Immutable public Git revision | 31eff40f6cfd61dd1996e4199da2e22f3522c21c |
| ZIP bytes / MD5 | 388943 / 7c78d030d6e7e759b395e26a951a48b7 |
| ZIP SHA-256 | 5a341b4174531b2c00b6b4c3ffbc4941bab1b9d0727a01b76c007a2c621025f0 |
| boundary.json SHA-256 | e92bb7833f86d269831f8fd9e2ae719d7e662a67fbd699e8a3e92d0f15cb9858 |

The public `verification/evidence.json` now records these locator/hash facts.
The existing witness checker checks that the current census still has this
identity. Existing checksum and byte-count manifests cover that record and
the updated checker. The archive is retained locally at
`/tmp/persistent/tavis/c1110-final/census-v0.1.0.zip`; it is not the sole evidence,
since the version DOI, exact download URL and content identity are committed.

Exact download and comparison, from the authority root:

```sh
curl -fsSL https://zenodo.org/api/records/22651106/files/tavisrudd/continuation-graph-rigidity-v0.1.0.zip/content -o /tmp/persistent/tavis/c1110-final/census-v0.1.0.zip
python3 - <<'PY'
import hashlib, json, zipfile
from pathlib import Path
root = Path('papers/continuation-graph-rigidity')
entry = json.loads((root/'verification/evidence.json').read_text())['entries']['boundary']['archived_artifact']
data = Path('/tmp/persistent/tavis/c1110-final/census-v0.1.0.zip').read_bytes()
assert len(data) == entry['archive_bytes']
assert hashlib.sha256(data).hexdigest() == entry['archive_sha256']
with zipfile.ZipFile('/tmp/persistent/tavis/c1110-final/census-v0.1.0.zip') as z:
    assert z.comment.decode() == entry['git_commit']
    name = 'tavisrudd-continuation-graph-rigidity-31eff40/verification/boundary.json'
    assert z.read(name) == (root/'verification/boundary.json').read_bytes()
PY
```

## Sources and read depth

Zero new research papers were read in full in this pass. FHMW's proof passages
were already checked in C1132; this pass only verified publication metadata.
No inference about absence of prior work was made.

- Zenodo record https://zenodo.org/api/records/22651106: metadata plus direct
  artifact inspection as described above; the ZIP was inspected selectively,
  not treated as a newly reviewed manuscript or executed as a release tree.
- FHMW published reference: abstract/metadata only, authors' institution record
  at https://research.monash.edu/en/publications/on-rysers-conjecture-for-linear-intersecting-multipartite-hypergr/.
  Search: `"On Ryser" "61" "91" "105" Francetic`. The earlier cached arXiv
  v3, its SHA-256 and partial proof read remain in the C1132 report. No claim
  was made to have reread the published proof.
- MSC classification: metadata only, official AMS MSC2020 entry at
  https://mathscinet.ams.org/mathscinet/msc/msc2020.html?s=94B05.
  It identifies 94B27 as geometric methods applied to coding theory; 94B05
  is linear codes and was therefore not retained for this nonlinear code.

Direct web opens of Zenodo and the FHMW DOI failed in the browser tool; direct
Zenodo API/download access and the authors' institutional metadata succeeded.
The failed general search for `"22651106" continuation` established no absence
claim and was not used as evidence.

## Validation

Working directory: `papers/continuation-graph-rigidity` (same commands in its
standalone repository). Dependencies are pinned by the existing Nix lock.

```sh
nix develop --command make check
nix develop --command python3 verification/check_manuscript_build.py
```

Authority checks passed: 24 claim/evidence records, integrity mutation tests,
unchanged census replay, all seven recognition orders, alternate F16, input
and coordinate corruptions, geometric witnesses and new Hamming generators.
The edge-seed recognizer reproduces recognition.json byte-for-byte; neither
the census nor coordinate certificates needed regeneration. The new finite
generator checks are in the existing `check_geometric_witnesses.py` and use
q=9,16,25, checking closure in the word set, Frobenius commutation and exact
generated-group orders. These are bounded sanity checks; the displayed point
maps give the mathematical proof. Arithmetic retains C1132's independent Sage
replay. No new benchmark was run or performance advantage claimed.

The manuscript checker rebuilt twice at its fixed epoch and rejected the
first layout because the long artifact locator overfilled two lines. Moving
the repository URL and revision to a short separate block fixed it; no warning
gate changed. One attempted correction used the wrong working-directory prefix
and failed before editing; its shell continued into a redundant failed build.
The corrected invocation used the paper-relative filename and fail-fast shell
execution. The final deterministic PDF build passed. Centre recovery, Hamming formulas
and the artifact locator were visually inspected. References use a conventional
smaller font to avoid an isolated final bibliography entry.

## ej + tt closeout and Mystery ledger

After the authority acceptance checks, the explicit closeout examined whether
the stronger outside-neighbour bound had any missing algorithmic consequence.
The edge-seed lemma already captures the cheap gain. Deduplication and arbitrary
input costs were checked, and the prior timing claims were kept historical.
No further verification infrastructure or speculative theorem was added.

| Feature | Status / remaining gap |
|---|---|
| Which archive supports the revised census proposition | Settled by downloaded byte equality, version DOI and immutable revision. |
| Why five centre seeds were unnecessary | Settled by the at-most-one outside-neighbour bound and edge closure. |
| What the abstract Hamming group actually does | Settled by explicit adjacent-transposition formulas and their point maps. |
| Why uniform minimality holds for unbounded orders | Settled explicitly for two points at every q>=4 and triangles at every q>=5. |
| Structural q=7,8 resolution behavior | Still an open research target. Existing exact census supplies completeness; the manuscript's boundary open problem owns the gap. |
| Qualified external subject review / broader priority diligence | Remain distinct from this supplied AI feedback; C1110/C271 retain their roles. C273 retains formalization. |

All observations were sought for this revision; no incidental discovery-track
entry was needed. Standalone synchronization and final identity are recorded
below after export.
