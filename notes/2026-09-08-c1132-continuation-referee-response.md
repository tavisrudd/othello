# C1132 — referee response and revision record

**Lane**: `continuation`
**Date**: 2026-09-08

## Result

The proposed five-clique proof is valid. The manuscript now proves uniform
rigidity, unique map extension and supplied-field recognition for q>=9, with
Aut(G_K) isomorphic to S4 x C_e. The q=8 exception makes this uniform cutoff
optimal. Only q=7 positivity still uses the finite census. The revision adds
an explicit Hamming extension corollary and addresses all required corrections.
No Lean theorem or new comprehensive priority verdict is claimed.

The specification and detailed supplied argument are preserved in
`notes/2026-09-08-c1132-continuation-referee-revisions.md`.

## Itemized response

| Referee item | Disposition and location |
|---|---|
| 2.1 Latin-square precedent | Accepted. Introduction cites BCPS Propositions 2.4 and 2.6 and distinguishes puncturing, fourth quotient and individual-map extension. |
| 2.1 Multipartite precedent | Accepted. Introduction and discussion after `lem:clique` credit intermediate steps in FHMW Lemma 2.2's proof, not its stronger stated lemma. |
| 2.2 Deza hypothesis | Corrected: constant pairwise intersection size is explicit; the application has intersection size one. |
| 2.3 Minimality and q=2 | Corrected. Intro/heading say uniform; q=3 triangle K4 example is explicit; `thm:triangle` disposes of q=2 before its pencil argument. |
| 2.4 Faithfulness | Corrected in `thm:main`'s proof before the order claim; the reconstruction corollary invokes that faithful action. |
| 2.5 Generator stopping | Corrected: stop at the first successful abstract cyclic-table witness, then try its primitive field images. |
| 2.6 Dyshko | Corrected to S. Dyshko after checking the primary source. |
| Suggestion 1 | Implemented as `lem:frame-clique` and `cor:frame-traces`; all uniform claims and recognizer cutoff now use q>=9. |
| Suggestion 2 | Implemented: generic multipartite recovery is credited; punctured four-partition compatibility and map extension carry the contribution. No unsupported priority claim added. |
| Suggestion 3 | Implemented as `cor:code-extension`, with parameters, non-MDS qualification, ambient restriction isomorphism and S4 x C_e. |
| Suggestion 4 | Adapted: normal form moved before recovery; five-clique argument precedes general-k bounds. Kept the general estimates alongside their recovery stages, and retained both algebraic lemmas. Added an F5 worked punctured-table completion, explicitly separate from recognition's q>=9 domain. |
| Suggestion 5 | Implemented supplied-field interface, q=9,11,13,16,17,19,25 tests, nonidentity Frobenius transports, and alternate supplied F16 arithmetic. |
| Suggestion 6 | Implemented explicit q=5 and q=8 involutions, with their failure to preserve the geometric resolution and q=8 exchange of the two resolutions. |

## Mathematical review

The new proof uses only Desarguesian coordinates. After placing a three-point
clique tangent at infinity, legality makes the three directions distinct and
ensures abc!=0. Each S3 assignment has at most one candidate, including
degenerate assignments with no legal candidate. The identity is the fixed
outside point. Two transpositions disagree everywhere and join in a forbidden
side direction; the two cycles give determinant one; the mixed case forces
a=b and a forbidden side direction. Thus no three outside points coexist.
The proof never divides by 2 or 3. The F7 five-word example proves sharpness
directly, with all words displayed and independently checked by the witness
script. The four-vertex seed proof still works because traces have at least
six vertices, exceeding the new bound of five.

The Hamming restriction map is injective because the four restricted
coordinate partitions are distinct and every symbol occurs in every position.
Partition recovery supplies surjectivity. Prime-field frame projectivities
commute with Frobenius, giving the direct product rather than just its order.

## Literature access and attribution

Zero sources were read in their entirety in this task. Two sources were read
partially at the exact reconstruction passages, and one at title/abstract depth.
This is a correction of specific comparisons, not a renewed absence-of-prior-work
audit. C271's broader named-source/authentication requirements remain open.

| Source | Read depth, version and passages | Cache key and SHA-256 |
|---|---|---|
| Bailey–Cameron–Praeger–Schneider, *The geometry of diagonal groups* | partial; arXiv v2, 6 May 2021; title, Propositions 2.4/2.6 and their proofs; HTML cross-check and cached PDF text | arXiv:2007.10726; `2356b96552b7265d8fcc47ef0d67241300c9cc0160c7619fbbddc97a90b129a3` |
| Francetić–Herke–McKay–Wanless, *On Ryser's Conjecture for Linear Intersecting Multipartite Hypergraphs* | partial; arXiv v3, 29 September 2015; title and Lemma 2.2 with full proof | arXiv:1508.00951; `abfd75f1197b8d4a6a85b7be185a72c308a30a85bb5a76f9f5bf05b5ef40f0fd` |
| Serhii Dyshko, *MacWilliams Extension Theorem for MDS additive codes* | abstract/metadata only; arXiv v1 identifier on cached PDF, title/author and abstract; metadata cross-check | arXiv:1504.01355; `a08757c9ac086f886e2658b017a8db1f5f1e26b2bb0eeaccc87487f42696433f` |

Primary URLs: https://arxiv.org/html/2007.10726,
https://arxiv.org/pdf/2007.10726, https://arxiv.org/pdf/1508.00951,
https://arxiv.org/abs/1504.01355. Discovery query:
`"On Ryser’s conjecture for linear intersecting multipartite hypergraphs" arxiv`.
The inference that FHMW's two intermediate bounds need only the non-star
condition was checked separately from the source's covering-number hypothesis.
Other existing citations were retained, not newly audited or recharacterized.

## Reproducibility and validation

Working directory for all commands below:
`papers/continuation-graph-rigidity` in the authority or standalone repository.
The committed `flake.lock` pins dependencies. No finite-census values changed.

```sh
nix develop --command make check
nix develop --command python3 verification/check_manuscript_build.py
nix shell --inputs-from path:. nixpkgs#sage --command sage -python verification/check_geometric_witnesses.py --sage
```

Intentional generation commands used:

```sh
nix develop --command python3 verification/check_recognition.py --update-certificate
nix develop --command python3 verification/check_manuscript_build.py --update
python3 verification/refresh_hashes.py
```

`verification/recognition.json` is the compact deterministic coordinate
certificate bundle (seven shuffled standard models plus the alternate F16).
Seeds are 20260907+q. Normal tests regenerate and compare its exact bytes.
`verification/SHA256SUMS` and `verification/file-sizes.json` pin the scripts,
certificate, field models, manuscript source, registries and dependency graph.
The existing `boundary.json` supplies the exceptional permutations and both
resolutions; `check_geometric_witnesses.py` verifies the displayed cycles
against that certificate and checks them on every edge.

The new arithmetic is checked independently against Sage for all element
pairs in F9, F16, F25 and alternate F16, including addition, subtraction,
multiplication, division and Frobenius. Both F16 moduli and the other
extension moduli are checked irreducible. Reconstruction's certificate checker
is independent of its search but shares the supplied arithmetic. The mathematical
interface assumes a finite field; it does not certify arbitrary supplied methods.

Authority `make check` passed all 23 claim/evidence records, integrity mutations,
the unchanged boundary replay, all recognition controls and the displayed
witnesses. The deterministic PDF check passed with no undefined references,
multiply defined labels or overfull boxes. The revision is 15 pages; the new
bound/proof, group and coding statements, table example and exceptional
witness pages were visually inspected. Before/after artifacts for local layout
comparison are under `/tmp/persistent/tavis/c1132/`; committed source/PDF and
Git history, not these temporary renderings, are the durable record.

One preliminary aggregate invocation failed on stale file sizes because the
hash refresher was called with a repository-relative path from the paper root.
The command path was corrected, reviewed manifests refreshed, and the aggregate
passed. No gate was weakened. Mirror replay is recorded below after export.

## ej + tt closeout and Mystery ledger

The explicit closeout ran after the main authority acceptance check passed.
Two cheap consequences were added to the manuscript: the Desarguesian
restriction of m(4) is exactly five, and the q=9,11 block/parallel-class/resolution
columns follow geometrically, not merely the automorphism orders. Both follow
from existing revised lemmas; they introduce no computation premise.

| Feature | Status and exact remaining gap |
|---|---|
| Why the previous uniform threshold stopped at 13 | Settled: the abstract multipartite estimate discarded direction compatibility; the five-clique proof uses it. |
| Whether the new constant is sharp | Settled over Desarguesian planes by the explicit F7 witness. Arbitrary-plane m(4) remains the stated extremal open problem. |
| Why q=9,11 have only the geometric resolution | Settled by trace size >5 and disjointness threshold >4; explicit deduction added. |
| Why q=7 has many partitions but one resolution | Still open conceptually; exact census remains the evidence. Existing boundary open problem owns this gap, not a new allocation. |
| Why q=8 has precisely two resolutions | The displayed involution explains their exchange but not a computation-free classification; the census still supplies completeness. Existing boundary open problem owns this gap. |
| Broad priority and external subject validation | Not discharged by local source comparisons or this revision. C271 and C1110 retain those roles; C273 retains Lean formalization. |

All observations above were sought as task deliverables. No incidental lead
requires a discovery-track entry. No new mystery is manufactured.

## Standalone validation and release identity

Authority source commit: `0b7917ef217d78df7c42f246b004d8486c41791f`.
A concurrent session committed the shared index before the task's own commit
ran, so the validated files occur under an unrelated cubic-lane commit message.
Scoped checks confirmed the committed continuation tree matched the validated
work. No foreign files or history were rewritten.

The scoped exporter plan/audit reported zero findings and synchronized 16 paths
to `~/src/math-papers/continuation-graph-rigidity`. Only scholarly source,
verification and public provenance material were exported; this response stayed
in private notes. Export verification initially required staging the two new
verification files, then passed with 36 tracked files and content hash
`aa45c0860ee5b4bfa53606631dbe087a90d0d5d8ef81dd1eb1893cc36823cc03`.
The standalone `make check` and deterministic PDF check both passed.

Byte-identical authority/standalone release surfaces:

| Artifact | Bytes | SHA-256 |
|---|---:|---|
| PDF | 367918 | `aa488f9f51d3755d5ed42f9734830d6ecff4e0b36217b021ef4bd6fd957c52ed` |
| SHA256SUMS | 2376 | `cc64b01650649c348edd919e194815c0c6d0079963509377d27df32186e6246f` |
| recognition.json | 11562 | `8757ccbb0fe975f8df14035721b0702e1151a493f37bc949d1cffece88ff5798` |

The final standalone forward commit is currently waiting for the GPG key
configured by `/home/tavis/.config/git/signing.gitconfig`. Existing standalone
commits are signed. Signing has not been disabled; the exact validated export
is staged. The author was asked to unlock/approve the key or authorize an
unsigned local commit. C1132 stays open until that final step completes.
