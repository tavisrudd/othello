# C956 — sharpness upgrade: hostile review and literature audit

Date: 2026-09-11. Lane: `cubic-threefolds`. Scope: audit, not integration.

## Verdict and evidence boundary

**External sources read cover to cover in this audit: zero.** The complete supplied packet, including its checker, was read; the load-bearing primary sources were read at the specific passages recorded below and in the two independent referee reports. This is a targeted mathematical/source audit plus a bounded topical literature search, not a completed priority or forward-citation-closure audit.

No fatal defect was demonstrated in the surface upper bound, three-parameter family, Prym calculation, or arithmetic separation argument. Both cold reviewers support these deductions after limited repairs. The packet checker passes all twelve jobs, including tangent reconstruction; the existing authority's `make check` also passes. These facts do not constitute independent verification of the companion's geometric theorems or an end-to-end formal proof.

Decision: retain the packet as a promising, reviewable upgrade, with the repairs and source boundaries below. Do not replace the public manuscript with the whole packet. No manuscript, bibliography, public certificate registry, mirror, or disclosure was changed in this audit. C956 remains active by author instruction.

## Findings to address before integration

1. **Nonsplit evaluation wording, §18.3.** The four coordinate factors exist after extending to a splitting field. They are not individually ground-field spaces in general. Define the descended kernel of evaluation first, and describe its coordinate-sum equation only after base change. This repairs wording, not the quotient construction.
2. **Add the geometric bridge for the new family.** For the point `P=[0:0:0:0:1]` on the two quadrics, a line through P must have direction `w=z=0`. Its equations give `u²+3v²=0` and `−au²+6uv+3av²=0`, hence `u=−av` and `a²+3=0`, impossible in `k(a)`. Thus P lies on no exceptional line. Its blowup has the smooth cubic/conic-bundle geometry required for the components-to-Picard identification in TZ §4. The signed subgroup is exactly the one identified in TZ v2 Proposition 5.3, not merely an abstract group of order 24.
3. **Field quantifiers.** State the countability/no-isotriviality argument in §25 over C. Exact surface level is over `k(a)` and constant extensions `K(a)`, not every extension of `k(a)`; the surface becomes rational over an algebraic closure. Keep the cubic's stronger characteristic-zero extension statement, justified by finite descent. In §26 replace “exactly two ... as an upper bound” by “two”; higher-dimensional examples have only the claimed upper bound.
4. **Optional S-unit domain.** Exclude `x=y` explicitly from (B1), and call S a finite set of rational primes. The pair `(1/2,1/2)` otherwise satisfies its listed equations but corresponds to an infinite, rather than finite nonzero, parameter. An arbitrary infinite S would invalidate the finiteness claim. The arithmetic headline and the integer density are unaffected.
5. **Pin the current Hodge-conservation import.** The current local companion states the required all-smooth-cubic result in Theorem 1.3; its Theorem 1.1 supplies the separate lower bound. Cite that actual revision. Do not use an older version citation as evidence for a theorem added later. This audit checked the theorem interfaces, not a fresh proof of the quantum comparison lemmas. The sharpness upper bound is independent of both imports; exactness needs the lower bound; nonbirational separation after one stabilization needs Hodge conservation.
6. **Do not overstate the literature contribution.** Two-variable rationalization is already known for the old type I0 examples; the sharpened general surface bound and its application to the displayed family are the relevant comparison. Rational torus actions built from stably rational invariant fields are established machinery. Fully elliptic intermediate-Jacobian decompositions also have precedents. The explicit formulas, local rank separation and exact thresholds must carry the proposed application, not a claim of first existence of any such decomposition or action.

7. **Replace the reduction placeholder.** The arithmetic referee checked the torus-rank invariance argument using an isogeny and quasi-inverse on semistable models, and directly checked the elliptic integral-j criterion in the source recorded there. The final reference apparatus still needs a precise primary citation for semistable reduction/base-change assertions in place of `[Reduction]`. This source-pinning gap remains open; it is not concealed by the checker. Define `f₂:W→E_t` before its first pullback as well.

The first, third and fourth points are literal corrections; the second is a short missing explanation that can be supplied without a new assumption. None changes the displayed families or numerical bounds. The two referee reports contain the detailed proof checks and editorial recommendations, without grades.

## What survived the hostile tests

| Argument | Result of this pass | Remaining boundary |
|---|---|---|
| Rank-three torus quotient | Integral weight differences give a unique orbit correction; actual tangent-projection isomorphism open supplies rational inverse | Keep saturation and Galois-stable sums explicit |
| Uniform smooth-parameter cover | Packet and existing Cox checks pass | Eight selected rows alone are not the full Cox ideal; retain the baseline twenty-quadric verifier |
| Generic torsor splitting | Stable permutation gives `H¹(F,T)=0` for every F and an equivariant generic product | Not a global trivialization of the family |
| All smooth members of the three-parameter cubic family | Root and component formulas survive specialization of splitting groups; signed action remains contained in type I3 | Smooth cubic hypothesis and no-line bridge remain explicit |
| Prym decomposition | Non-Eckardt involution, transverse cubic/conic discriminant and S3 cover match the cited CMZ theorem | Geometric isogeny; do not claim a product principal polarization |
| Local arithmetic separation | Five elliptic factors give potential toric ranks 1 at numerator primes, 3 at D primes and 0 otherwise for p≥5 | Use potential rank after finite extension; retain arithmetic twists for finite-field claims |
| Positive-density integer family | Pairwise separation and elementary squarefree density survive | Conversion to one-stable nonbirationality imports current Hodge conservation |
| Height sector | Binary form has largest irreducible degree two; Xiao's unconditional theorem applies | State a sector/congruence transfer argument, as below; coefficient height is not moduli height |
| Finite-index extension | Selected component degree divides the index; no equality is forced | Keep geometric integrality and constant-kernel argument; no rationality from CH0 alone |

## Small proof improvement: sector and congruence transfer

This closes an exposition/source interface in the optional height result without importing a stronger theorem. Let `C_R` be the finite Euler product for squarefreeness at primes at most R, and C its limit. For fixed R, elementary lattice counting in `[1,H]²` gives `C_R H²+O_R(H)` points surviving these primes. Xiao's Theorem 1.1 gives `C H²+o(H²)` squarefree points in that same square. The number surviving the finite sieve but failing squarefreeness is therefore `(C_R−C)H²+o_R(H²)`.

This nonnegative error bounds the corresponding error in any subset of the square. Apply fixed-modulus lattice counting in the polygonal sector with the stated congruences, then let H tend to infinity and R tend to infinity. Convergence of the Euler product removes the error. In this packet the sector area is `1/8`, the congruence density is `1/12`, and their product is `1/96`. Thus no unquoted sector version of Xiao or a separate large-prime theorem is needed. This is an inference from the square asymptotic, not a statement quoted from Xiao.

## Literature positioning and read-depth register

Cached PDFs are byte-pinned in the shared cache; possession is not counted as reading. Full metadata and primary passages for the arithmetic sources are in the arithmetic referee's register. The surface referee's register records the older standard inputs not newly checked here. Those secondary-only imports are not upgraded to primary-source certification by this report.

| Source | Depth, version, passages and access | Conclusion justified here |
|---|---|---|
| Tschinkel–Zhang, *Universal torsors over quartic del Pezzo surfaces and stable rationality* | **partial**, arXiv:2608.20029v2; primary HTML introduction, cached text §§2–5 passages as enumerated in surface report, plus parent lines 683–712; key `arXiv:2608.20029v2`, PDF SHA `4856b5b45325b56917df9c6d8c4a9341f13d7b9bf2628562c9fda0784ca07453` | Supports the imported Cox geometry, H1 splitting, four types and exact signed group. Explicit general bound eleven and old type-I0 bound two give the relevant comparison. Do not confuse v1 numbering with v2. |
| Casalaina-Martin–Marquand–Zheng Zhang, non-Eckardt involutions | **partial**, arXiv:2210.14397v2, §2, especially Theorem 2.9 and surrounding comparison, cached text; key `arXiv:2210.14397`, PDF SHA `6a8ce41af47def059a90f987f65cdda22c9540357d23ba80bdccc2dc8b351874` | The stated quotient-Jacobian times conic-cover-Jacobian isogeny is present. The packet still supplies its special S3 identification. Author Zheng Zhang is not TZ's Zhijia Zhang. |
| Xiao, *Power-free values of binary forms and the global determinant method* | **partial**, arXiv:1505.05587v2, introduction/Theorem 1.1 and §7 opening; key `arXiv:1505.05587v2`, PDF SHA `5fc1b0b9cc2f13a336e9f36064c803d12be9ae7f24df6639364295517e14ce63` | Largest irreducible degree, not total degree, controls applicability; square asymptotic suffices by the transfer lemma above. |
| Greaves, *Power-free values of binary forms* | **secondary only** for theorem content via Xiao's partially read introduction and §7; **abstract/metadata only** at OUP DOI `10.1093/qmath/43.1.45` | Original full text not read. Do not report a direct check of Greaves. The accessible Xiao statement is sufficient here. |
| Popov, *Some subgroups of the Cremona groups* | **partial**, arXiv:1110.2410v4, Theorems 1–2 and 4–5, Corollaries 3–6, cached text lines 338–361, 385–481, 545–630; key `arXiv:1110.2410`, PDF SHA `0d08a8504457aa1c9292b6174639d6b1516cb3351f75ae5c0b372226ef223ff1` | Linearizability versus pure invariant field, stable linearizability, and action construction from two-variable rationalization are prior machinery. |
| Shepherd-Barron, *Stably rational irrational varieties* | **secondary only** via TZ's level discussion and Popov Theorem 5 proof, both partially read | Prior two-variable examples, not a newly verified original theorem. No inaccessible source purchase is required for the specific Xiao or CMZ checks performed here. |
| Roulleau, *Fano surfaces with 12 or 30 elliptic curves* | **partial**, cached arXiv:1001.4855v2, opening and Proposition 16 proof; key `arXiv:1001.4855`, PDF SHA `6cfe901586441afa6d875d17bd4c33c6675705d6658848e9b82b5bd5fbd77bec`; published PDF opening also viewed through web | Reports Albanese isogeny `E0³×Eλ²`, citing its earlier source. This is a precedent for full elliptic decomposition, not an identification of the packet's pencil with that family. Original construction behind its citation not rechecked. |
| van Geemen–Yamauchi, order-five cubic automorphisms | **partial**, arXiv:1506.05346v3 abstract/introduction only, primary arXiv and cached text lines 1–55; key `arXiv:1506.05346`, PDF SHA `f263d78728391fc9c1ff836293a484e5caec66b3178ecab3aa1d54b14855baed` | Explicit `E×B²` decompositions are adjacent prior work. No claim about whether their family meets this pencil. |
| Current Rudd companion | **partial**, local September 2026 introduction, Theorems 1.1 and 1.3; `papers/cubic-stabilization-m1/sections/01-introduction.tex`, SHA `9e200b5f425159d34ebf74ed053147c7dc7715995161aebd8de8591a321bd3c2` | Exact interface includes every smooth cubic, not only very general cubics. This pass does not re-audit its proof or Lean. |
| Supplied upgrade packet / current sharpness manuscript | Packet **full text**, supplied Markdown including all checker code; baseline **partial** as enumerated in surface report | Verbatim packet copy and hashes committed with this audit; baseline unchanged. |

Bounded search record: `2026-09-11-c956-sharpness-search-log.json` preserves eleven queries in three batches and all 54 result appearances, including duplicates and irrelevant hits. Screening used displayed titles and snippets, promoting primary results on del Pezzo stabilization, cubic Jacobian decomposition, or rational torus actions. An earlier three-query exploratory batch located TZ/CMZ/Xiao context but was not preserved as a complete screen set; no negative relies on it. The bounded screen supports the comparisons above, **not** an assertion that no predecessor exists. No OpenAlex/Crossref/Semantic Scholar citing-set closure was attempted and no zero-citation or exhaustive novelty claim is made. Exact identification of this pencil within previously studied automorphism loci remains outside this audit's established conclusions.

## Reproducibility and trust

Working directory for packet replay: `/home/tavis/src/othello/rust`.

```sh
uv run --with sympy==1.14.0 python ../notes/2026-09-11-c956-sharpness-upgrade-checks.py --output ../notes/2026-09-11-c956-sharpness-upgrade-checks.json
```

The script is extracted verbatim from the supplied packet. Python 3.14.3, SymPy 1.14.0; default bound 240, recursive length 20, tangent reconstruction enabled, no random seed or sampling. All twelve named jobs passed. The finite domain includes 74 squarefree integer parameters and 466 rational reconstruction certificates in the stated wedge; local densities are checked at 5,7,11,13,17,19. These are finite consistency certificates, not proofs of density or all-prime geometric reduction theory.

The pre-existing full authority gate was also replayed from `papers/cubic-stabilization-irrationality` with `make check` (exit 0). This includes the slice derivation and independent checker, rank-four reconstruction and independent checker, metadata, TeX and warning gate. The PDF was already up to date; this audit does not claim a forced clean typeset. The baseline gate produced no tracked changes.

Independent cross-check boundary: the baseline has a distinct certificate verifier and rank-four implementation; both cold reviewers independently checked the written geometry/arithmetic. The new packet's entire symbolic calculation has not been reproduced in a second CAS or implemented independently. In particular a group-order assertion does not certify a Picard representation, and finite-field point counts do not prove the geometric Prym isogeny. Those are written/source obligations addressed separately above.

The adjacent SHA256 manifest records input, script, output, search log, reports and pinned local baseline inputs, with byte counts. The packet result's `baseline=f46624d` field is a supplied provenance label, not a check performed by the script; the actual local TeX hash is separately recorded. No Lean build was run, and no formalization claim follows from this audit.

## Acceptance gate, extra-juice/Tao pass, and mystery ledger

The audit acceptance gate is satisfied: complete packet/code read, twelve-job replay, existing full gate, two independent focused referee reports, load-bearing source interfaces checked to stated depths, and unresolved boundaries recorded. That is an audit gate, not a declaration that every external theorem has been independently reproved.

The explicit `ej` + `tt` closeout asked whether the strongest conclusions can use fewer imports. The integer family already avoids the binary-form sieve; keep it as the main arithmetic result. The height statement can remain optional, with the elementary transfer lemma above. The S-unit exclusion is a cheap repair, not a reason to burden the main theorem. Credit established torus machinery rather than enlarging that appendix's claimed novelty.

| Feature | State after closeout | Exact remaining gate |
|---|---|---|
| Visible determinant two versus genuine quotient degree one | Settled by saturated cocharacters and integral weight differences | None beyond preserving this distinction in exposition |
| Local rank values 1 and 3 | Explained by valuations of the five elliptic j-invariants and the two-root Newton polygon | Retain potential reduction and isogeny source boundary |
| Sector density from a square-only theorem | Settled by nonnegative finite-sieve error transfer | Insert the short lemma if height result is retained |
| Small arithmetic formula versus rich moduli | No unexplained implication asserted | Identification with all prior special loci not settled; no priority claim |
| Companion theorem strength | Interface is adequate; proof is an external manuscript dependency | Do not present this review as independent validation of its quantum comparison lemmas |

No further genuine mathematical mystery was found in the reviewed deductions. The next task-owned step is to integrate the core in a restrained theorem hierarchy, apply the listed repairs, pin imports, and run a full cold read of the resulting paper. Keep height, S-units and extended actions optional.

Process record: oversized aggregate packet/search output and initial delegate handoff reads were command-shaping failures; missing packet text was recovered in bounded reads, and saved search data was recovered without repeating the broad output. A guessed companion filename and an unsupported cache-list argument failed harmlessly and were replaced with scoped discovery/help. No failed check was silently reported as passing.

Whitespace check: the verbatim input has three intentional Markdown hard-break lines, and its verbatim Python extraction ends with a blank line. The aggregate `git diff --check` reports those four inherited formatting findings. They are preserved to maintain byte identity; the authored reports and live-map edits pass their scoped whitespace check. This is an archival fidelity exception, not a passing aggregate whitespace claim.
