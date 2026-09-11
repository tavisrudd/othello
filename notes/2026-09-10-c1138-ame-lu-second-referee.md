# C1138 — second AME referee revision

**Lane:** `ame-lu`
**Status:** COMPLETE (2026-09-10).

Review the supplied mathematical corrections and suggestions against exported `ae3e7ba`, excluding all gradings from the record. Verify fixed-dimension length restrictions, Appendix B boundary, four-party algebra identification, spectral-spread obstruction, universal verification exposition and sampling prescription. Check stale numbering, bibliography and README claims against exact local/exported bytes before changing them. Preserve the two-headline organization; evaluate the optional growing-field algorithm separately. No publication-priority claim or formal-coverage extension is authorized by the referee's assessment alone.

## Disposition of the mathematical feedback

1. **Fixed-dimension asymptotics: accepted.** The supported-label count on an `(m+2)`-set is `(q²−1)(q²−m−1)`. Its nonnegativity gives `m≤q²−1`, so no unbounded fixed-q family exists. Added the derivation as `eq:ame-length-bound`; replaced conditional fixed-q asymptotics in the theorem discussion and conclusion. Recognition now leads with arithmetic complexity and the four-variable prime-field reduction. The known QMDS bound is credited to Huber–Grassl, Theorem 10.
2. **Numbering/references: already repaired in the exported `ae3e7ba`.** Its fidelity reference points to unique equation (4.5), and both introductory stochastic-conversion links target subsection 4.4. New length-bound numbering shifts the fidelity equation to (4.6). PDF named destinations and actual source-link destinations were checked in both versions, not just source labels or printed numbers.
3. **Two-uniform boundary: accepted.** The definition now requires `n≥2`; the text explicitly excludes both `n=2` and `n=3` by purity/rank. Standalone two-uniform statements inherit the corrected definition.
4. **Bibliography/README drift: distinguish versions.** All eight new bibliography entries already displayed arXiv version identifiers in the exported PDF. Added verified PRR publication metadata to Dangniam–Han–Zhu while retaining the cited `arXiv:2007.09713v1`. The local/exported README already had the improved radii; the public repository had not been pushed. The user's subsequent request separately authorizes a full README improvement using `high_weight_grs_cosets/README.md` as its structural model.
5. **Four-party algebra: accepted.** Normalize the invertible blocks to `[[I,I],[I,A]]`. Transported alternating forms have nonzero scalar weights; the off-diagonal block forces `A=−r0/r1 I`. The fundamental holonomy is scalar and its centralizer is full `M_2(F_q)`. The intrinsic-algebra theorem gives compatible `SL_2(q)`. This is prime-dimensional, including characteristic two when an instance exists, with no assertion of four-qubit AME existence. The six-party conclusion and its noncentral-group qualification are unchanged.
6. **Spectral-chart obstruction: accepted with explicit threshold.** For `q>6(pi+1)²/(2−sqrt2)`, the cube-root diagonal perturbation has defect `sqrt(6/q)`. Its spectrum lies in no rotated closed semicircle. Any proposed collective bound forces every exact-symmetry factor within `(pi+1)sqrt(6/q)` of identity; Clifford Choi overlap separation then makes all factors scalar, contradicting the spectral-spread requirement. This restricts the joint theorem formulation, not local rounding alone, and gives no sharp party-count exponent.
7. **Universal verification exposition: accepted compactly.** A main-text remark states the arbitrary-AME uniform gap and determination claim. The appendix explicitly inserts the two separately truncated operators and names the selected-family inequality. No cross-family commutation or exact universal weighted-attainment claim is introduced.
8. **Sampling rule: accepted.** For independent copies of one fixed preparation, an all-pass record has probability `(1−r)^N`. The one-sided bound `gamma_N=1−alpha^(1/N)` and strict entry condition yield the sufficient count `O(max{q,n} log(1/alpha))`, up to integer rounding. This is an analytical deduction, not a sample simulation or guarantee under adaptive/nonstationary noise.
9. **Growing-q algorithm: partially adopted, optional strengthening deferred.** The paper now spells out determinant-one candidate generation (`a≠0`: choose a,b,c and set d; `a=0`: choose b≠0,d and set c), its `q(q²−1)` count, arithmetic-vs-bit boundary, and fixed four-dimensional linear search space. An improved determinant-normalization algorithm using the five algebras would be a separate algorithmic result requiring its own proof and complexity analysis; it is not needed for the current decision procedure. No polynomial-in-log-q claim is made.
10. **Consolidation: accepted.** Added a compact map-notation table and shortened the disclosure after the trust table. The two rigidity theorems remain the introduction's principal results. The additional universal statement is a body remark, not a third introductory headline.

## README revision

The GRS README was read as a presentation model only; its mathematical content and DOI were not copied. AME's README now gives the object and two principal theorems, explicit norms/radius, proof mechanism, worked example, finite recognition input/output and arithmetic costs, verification and conversion consequences, reading guide, limits, formal boundary, reproducible build/hash-check commands, file map, and its own citation/license. It describes manuscript results rather than making new priority claims. Its fixed-q discussion, four-party algebra, appendix references and spectral-chart boundary match the revised manuscript.

## Source checks and limits

- Huber–Grassl, *Quantum Codes of Maximal Distance and Highly Entangled Subspaces*, arXiv:1907.07733, cached PDF SHA-256 `c4e5dfba9f8ccbb3f496c956c96cc83cc9bb2c117f23e0a05be639153d444e94`: read the Theorem 10 statement and immediate context (printed p. 7), including `n+k≤2(D²−1)`. This is a partial primary-source read, not a full-paper audit. Metadata also checked at https://arxiv.org/abs/1907.07733.
- Dangniam–Han–Zhu publication metadata verified on the APS page, https://journals.aps.org/prresearch/abstract/10.1103/PhysRevResearch.2.043323: PRR 2, 043323 (2020). Metadata/abstract only, not a new proof audit.
- The supplied public-repository URL was inspected alongside the actual local README. Local export is a separate version from remote publication; no push authorization is inferred.
- C1136's prior literature-coverage gaps remain. No novelty absence claim, citation-graph closure or new formalization is claimed in this task. The stronger low-party ledger row now states theorem content without extending the old priority wording.

## Validation and post-gate ej + tt

The revised paper built warning-free at 45 pages, versus the 43-page export. Root inspected rendered pages containing the universal body statement, strengthened algebra proof, spectral obstruction and appendix truncation argument. The public release gate matched 20 artifact hashes and 83 unchanged formal artifacts. No Lean build or replay was run. PDF destination inspection confirms unique Section 4 equation anchors and correct fidelity/stochastic targets in both the earlier export and this revision. Final semantic-label rebuild and downstream export checks are recorded below.

**ej:** the dimension obstruction and sampling prescription turn two vague qualifications into usable boundaries: what forces the small chart radius, and how an actual all-pass experiment can enter it. Both fit existing subsections without new narrative machinery.

**tt:** distinguish three scales: the constant gap of the marginal tests, the shrinking radius imposed by the spectral chart, and unresolved collective party-count dependence. A constant verification gap does not imply a constant entry radius. The separate truncation proof likewise uses operator order and orthogonality, not common diagonalization.

### Mystery ledger

| Question | Disposition / remaining gate |
|---|---|
| Can fixed local dimension support unbounded party-count asymptotics here? | Settled negatively by the exact support count and known QMDS bound. |
| Is full four-party compatible symmetry an artifact of the example? | Settled in prime dimension by the weighted off-diagonal identity. No extension-field extrapolation. |
| Is the q exponent an artifact of cleaning? | For the joint spectral-spread/collective formulation, no: the explicit perturbation forces order at most q^(-1/2). Weaker charts/local rounding remain outside this obstruction. |
| Optimal party-count dependence and nearby character repair | Remain open; no new family saturating the collective estimate is proved. |
| Faster growing-field determinant decision | Optional successor gate: prove a full determinant-normalization algorithm with arithmetic and bit bounds before claiming improved complexity. No successor allocated. |
| Universal exact weighted attainment | Still unproved; the appendix continues to claim only a lower bound outside stabilizer targets. |

These were requested investigations, so no incidental discovery-track entry is warranted.

## Final release and closeout

Authority manuscript commit: `63d3e194c`. The final semantic-label rebuild passed warning-free at 45 pages (`/tmp/claude-run-quiet/20260910-221114-make-C-ame_lu-check/`). Exporter plan and audit found zero coupling issues. Only the registered public paths were synchronized; private task reports and ledgers are excluded.

Standalone commit: `9d9306fc1f7283c958d0a76955db27a7ab67c4d0`. Its own warning-free rebuild passed (`/tmp/claude-run-quiet/20260910-221212-make-C-ame-lu-check/`), and its PDF, README and release manifest are byte-identical to the authority. The canonical public release hash is `2d1ce5138ae8bad0bea90beb2be3ce741044f6db27a49d8cdb03c3ed65086f56`; the exporter content hash is `00309d42e22592e5e96ea848832789fbb9dc276dfc8960acc729dadab62ae5e0`. The paper-only checkout correctly reports that it cannot inspect the formal companion. No new formal work or push occurred.

Downloads:

- `/home/tavis/Downloads/ame-lu-9d9306f.pdf`, SHA-256 `b39e9c39cdf62381fcf58ba562a37a87e5eb661f703b2b7ca53602c5f59d737b`.
- `/home/tavis/Downloads/ame-lu-9d9306f-source.zip`, SHA-256 `7f45005176b58f4e77ca3d420e1e1b1ef9c173983a303d002f126b2a015d45f4`.

The source ZIP is a Git archive of the standalone commit; ZIP CRC, embedded PDF and embedded README checks pass. README relative links resolve. Gradings from the supplied feedback were not copied into any task artifact.

Vibe: the two new short arguments sharpen the scope, and the README now explains the paper rather than merely listing it. The optional determinant-normalization algorithm is the next distinct mathematical refinement; it has no allocated successor. Existing party-count/character and literature-coverage boundaries remain explicit.
