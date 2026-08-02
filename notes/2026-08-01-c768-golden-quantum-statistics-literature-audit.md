# C768 — Golden quantum-statistics literature and attribution audit

**Lane:** golden

**Date:** 2026-08-01

**Audited object:** papers/golden-quantum-statistics/golden_quantum_statistics.tex

**Deliverable:** attribution and experimental-absence closure under
notes/literature-audit-conventions.md.

## Opening summary

Eighteen individually discussed sources were checked. Two were read at
**full text** in the immediately preceding C755 audit and reused here with
their cached bytes reverified; sixteen were read at **partial** depth from
cached full texts, with the exact sections below. No verdict rests on an
abstract alone.

The mathematical and physical headline survives. The determinant/permanent
and partial-distinguishability background, conference-matrix/real-ETF
dictionary, real six-line measurement, Joubert/Segre invariant theory, and
anomaly parametrizations are prior art and now receive explicit attribution.
Jabbour--Cerf's probability complementarity and Robbio--Jabbour--Cerf's
partially distinguishable extension are characterized accurately.

One material omission was found. In addition to Goyal et al.'s 2014
linear-optical proposal, Piccolini--Karczewski--Winter--Lo Franco give a
second interferometric proposal for preparing the \(N\)-particle,
\(N\)-level singlet, including \(N=3\). Neither paper reports the required
three-photon qutrit experiment. Independent citation-graph counts and the
largest forward sets likewise located no experimental preparation and
characterization. The manuscript now cites both proposals and says only:
“To our knowledge, no experiment has prepared and characterized this
three-photon qutrit singlet.”

The experimental negative remains bounded. MathSciNet and Google Scholar
were **NOT COVERED**. Semantic Scholar's free search endpoint rate-limited
the phrase searches, although its pinned-identifier records and citation
sets were available. The result licenses “to our knowledge,” not “first,”
“no such experiment exists,” or an unqualified hardware impossibility.

## Verdicts and manuscript action

| Area | Verdict | Attribution boundary and action |
|---|---|---|
| Determinant, permanent, and immanant scattering | Classical background | Scheel gives the permanent formulation for photonic network matrix elements. Tichy organizes bosonic, fermionic, and intermediate-symmetry interference, including immanants. Added both citations; the paper claims only its Golden specialization and port-gauge theorem. |
| Partial distinguishability and complementarity | Attribution sound after expansion | Shchesnovich supplies the general partial-indistinguishability framework. Jabbour--Cerf prove the exact boson--fermion probability identity; Robbio--Jabbour--Cerf extend it to partial distinguishability. Added the missing framework citation and retained the narrower complementarity credits. |
| Conference matrices and real ETFs | Classical background | Goethals--Seidel own the symmetric conference-matrix setting. Fickus--Mixon state that symmetric conference matrices give the sign Gram matrices of redundancy-two real ETFs. Added the \(\operatorname{ETF}(3,6)\) attribution. |
| Six-line qutrit measurement | Classical, with a terminology boundary | Bengtsson--Życzkowski identify the six icosahedral lines as the real three-level SIC. It is informationally complete for the real theory, not the nine-line SIC of a complex qutrit. The manuscript now states this distinction explicitly. |
| Segre/Joubert and outer \(S_6\) invariant theory | Classical background already repaired by C755 | HMSV supply the Joubert coordinates and outer action. C768 reuses C755's full-text record and does not reopen its novelty verdict. The Golden amplitude realization remains the paper's use of that background. |
| One \(U(1)\) anomaly parametrization | Classical background | Costa--Dobrescu--Fox give the general one-\(U(1)\) anomaly-cubic parametrization; their few-fermion paper treats minimal chiral families and higher Abelian rank. The manuscript limits its contribution to the operator filter and exact postselection cost. |
| Two \(U(1)\) anomaly geometry | Classical background | Gripaios--Nguyen identify rank-two anomaly cancellation with lines on the Segre cubic and analyze its Fano components. The manuscript cites this geometry and keeps it outside scope. |
| Photonic fermion emulation | Correct, but the experiment/proposal split is essential | Matthews et al. prove the \(N\)-copy, \(N\)-level entangled-resource emulator and experimentally demonstrate the two-particle case only. The paper does not present that experiment as a three-particle realization. |
| Antisymmetric three-qutrit preparation | Two proposals; no located experiment | Goyal et al. give a recursive Bell-filter proposal. Piccolini et al. give a Fourier-multiport proposal and an \(N=3\) postselected implementation. The second proposal was missing and is now cited. The audit located no preparation-and-characterization experiment; the qualified negative is licensed by the search record below. |
| Transfer tomography and programmable hardware | Source characterizations sound | Rahimi-Keshari et al. demonstrate coherent characterization of a \(6\times6\) network using single-input intensities and phase-referenced two-input scans. Somhorst et al. demonstrate a programmable twelve-mode processor with three photons. Hu et al. demonstrate a three-qutrit GHZ state, not the antisymmetric singlet. |

No theorem is pre-empted. The Piccolini source is adjacent prior art for the
missing resource, not for the orientation theorem, Golden balanced benchmark,
exact arithmetic filter, decoder, or quantitative design limit.

## Experimental-absence audit

### Pinned seeds and independent citation counts

Counts were queried on 2026-08-01 by DOI, never by title.

| Seed | OpenAlex | Crossref | Semantic Scholar |
|---|---:|---:|---:|
| Goyal et al., DOI 10.1038/srep04543 | W2160665326: 53 | 49 | a2c69cb28e4cfbb5f9d497f8760213c9eb49af0e: 53 |
| Piccolini et al., DOI 10.1088/2058-9565/ad8214 | W4403017388: 5 | 5 | dfbaa1f720b2b5b262024f7b159590dbad53b9f7: 6 |

The OpenAlex cites:W2160665326 endpoint returned 55 records even though the
resolved seed reported 53. This live-index disagreement is retained rather
than normalized away. All 55 returned records were screened over title,
publication year, DOI, and reconstructed abstract vocabulary with the
mechanical discriminator

    antisymmetr | three-qutrit | three qutrit | three-photon qutrit |
    three photon qutrit | totally antisymmetric | fermion

Four records promoted. They concern two-photon high-dimensional-state
engineering, two-photon exchange statistics, biphoton spectral symmetry, and
an unrelated polaritonic-computing paper. None reports a three-photon qutrit
singlet experiment.

Semantic Scholar supplied the largest Piccolini citing set, six records. All
six titles, years, external identifiers, and abstracts were screened. They
concern dephasing theory, self-testing, many-electron entanglement, Fourier
analysis, graph-based heralding, and multipartite entanglement from particle
indistinguishability. None reports the required photonic source.

For each service an empty response was distinguished from an error by a
successful HTTP response and a parsed result/count field. The Semantic
Scholar phrase-search calls instead returned HTTP errors and therefore
license no negative; its pinned paper and citation endpoints succeeded.

### Phrase searches and screened sets

The following OpenAlex searches were run verbatim on 2026-08-01 and screened
over title, DOI, year, and available abstract:

| Query | Returned | Outcome |
|---|---:|---|
| "totally antisymmetric" "three qutrit" photon | 1 | Piccolini et al.; proposal, not experiment |
| "antisymmetric" "three-photon" qutrit experiment | 13 | no preparation-and-characterization experiment |
| "photonic fermion" emulator qutrit | 0 | successful empty result |
| "three-qutrit" antisymmetric state preparation | 15 | Piccolini et al. plus unrelated theory; no experiment |

Crossref bibliographic searches with the same strings returned very large
token-OR sets (135,885 to 3,561,002 records). They were not treated as
screenable exact-query sets and support no negative. General web searches
were also run for:

    "Robust generation of N-partite N-level singlet states" experiment
    "totally antisymmetric state" "three photonic qutrits" experiment
    "three-qutrit singlet" photons experiment antisymmetric
    "generalized singlet" three photons qutrit experiment

They returned the two proposals, atomic/cavity proposals, GHZ experiments,
and theory papers, but no matching photonic experiment.

zbMATH Open title/phrase searches for the two proposal titles and the
three-qutrit phrase returned zero web-indexed hits. This is unsurprising for
experimental quantum optics and is not used as the main negative.

### Coverage gaps and licensed wording

- **MathSciNet: NOT COVERED.** Institutional authentication was unavailable.
- **Google Scholar: NOT COVERED.** Automated access was unavailable.
- **Semantic Scholar phrase search: NOT COVERED.** The public endpoint
  returned HTTP errors; pinned citation records were covered.
- **Subject-expert check: NOT COVERED.**
- **Citation-graph closure:** covered independently for both preparation
  seeds by OpenAlex, Crossref, and Semantic Scholar counts; the largest
  returned set for each seed was screened.

Therefore the strongest licensed sentence is the manuscript's qualified
negative. Any submission update after 2026-08-01 must rerun the two pinned
citation graphs and the four phrase searches.

## Sources and read depths

All bytes below are in /tmp/persistent/tavis/lit-search. “Partial” means the
cited sections were read from cached full text, not from a search snippet.

| Source | Read depth, version, sections relied on | Cache key and SHA-256 |
|---|---|---|
| Goethals--Seidel, *Orthogonal matrices with zero diagonal* | **full text**, published version; reused from C755, §§1--3 | 10.4153/CJM-1967-091-8; 68c0ef0b8fda6d44325382a047a873d2075ed2ad3cf9d0e6ec27ba7ace60b734 |
| Howard--Millson--Snowden--Vakil, *A description of the outer automorphism of \(S_6\)...* | **full text**, published version; reused from C755, §§1.1--1.6 and 2.1--2.4 | 10.1016/j.jcta.2008.01.004; a875f0bccccc42db97703e9cadf52648a3f4e41b429abd0b05ef84bf6725043c |
| Scheel, *Permanents in linear optical networks* | **partial**, arXiv preprint; abstract, §§1--3, transition-amplitude formulas | arXiv:quant-ph/0406127; 992b62a7676a5c95d13c000afbf3325e4bdfe6b86d6d38b7c580d2bfdf95b565 |
| Tichy, *Interference of identical particles from entanglement to boson-sampling* | **partial**, arXiv v2; §§2.3, 3.3--3.5 and immanant discussion | arXiv:1312.4266; 9b437bdfb36aa1f899562a9f81c68c6597eee8f07ef164b46a80bfa36146de8a |
| Shchesnovich, *Partial indistinguishability theory...* | **partial**, arXiv preprint; introduction, output-probability formula, partial-indistinguishability matrix, immanants | arXiv:1410.1506; e92c3a43b688a66bfa6abea9d9316847ba2bf2b5ae5694a20400768700789e7a |
| Jabbour--Cerf, *Boson--fermion complementarity...* | **partial**, arXiv v2 dated 2026-05-19; introduction, Theorems 1--2, collision-free specialization, hypotheses | arXiv:2312.17709; 57e299c41729d839449d74522d73251702314e928b883645cdf50fe79c64fa45 |
| Robbio--Jabbour--Cerf, *Complementarity ... with partially distinguishable particles* | **partial**, arXiv 2026 preprint; introduction, model, Theorem 1, metrology boundary | arXiv:2604.23316; d8ce6c8a32d3c4eef3bd6f98431acf33dda8c87b9ab35dd7e5e19bb4e6d3fafc |
| Fickus--Mixon, *Tables of the existence of equiangular tight frames* | **partial**, arXiv preprint; §5 symmetric-conference/real-ETF dictionary | arXiv:1504.00253; b9ea8a8669cacd224f736d3af2e3038f314068b91397866327a2feebb5b1896c |
| Bengtsson--Życzkowski, *On discrete structures in finite Hilbert spaces* | **partial**, arXiv v1; §IX on complex SICs and the real \(N=3\) six-line case | arXiv:1701.07902; b6c5037d014edec81b69e874d1a43d360d906fa181a70858555e65bfc0cd7c23 |
| Costa--Dobrescu--Fox, *General solution to the \(U(1)\) anomaly equations* | **partial**, arXiv preprint; abstract and §§1--3 | arXiv:1905.13729; 90140fc4392c6ad0c64e17c91f1a20c7797208065e55e8f70fcb0c5b8901037f |
| Costa--Dobrescu--Fox, *Chiral Abelian gauge theories with few fermions* | **partial**, arXiv preprint; introduction and one-/two-\(U(1)\) sections | arXiv:2001.11991; c0a90e66e133fd11cc87c4857f9e542ffadc60764d726c39b2ecf41d7f61b89c |
| Gripaios--Nguyen, *Anomaly cancellation for two \(U(1)\) factors* | **partial**, arXiv 2026 preprint; abstract, §§2.2 and 4 | arXiv:2607.09879; d9e4e7905e270e31a01c6c3a05e11388650cfd40579b2bf98d2bd9820d2493b3 |
| Matthews et al., *Observing fermionic statistics with photons in arbitrary processes* | **partial**, published PDF including corrigendum; introduction, experiment, arbitrary-\(N\) Eqs. (7)--(9), conclusion | 10.1038/srep01539; cd5c414171e960b4030d8647ac5225c7ed975e5835aab7d160886d11ddaf0e9f |
| Goyal et al., *Qudit-teleportation for photons with linear optics* | **partial**, published PDF; discussion and Methods “State preparation” | 10.1038/srep04543; f5aa2c143c2eff47a63a291c2ce274dbcfec82100960d0920dd5c971634fd6cd |
| Piccolini et al., *Robust generation of \(N\)-partite \(N\)-level singlet states...* | **partial**, arXiv v2; abstract, introduction, construction, \(N=3\) implementation. Published DOI used for citation graphs; published text not separately read. | arXiv:2312.17184; 0cd9a4bd5746b4e57220bbf9a12cc91005624dc8e1494900e05ef3bff2a9f327 |
| Hu et al., *Observation of genuine high-dimensional multipartite nonlocality...* | **partial**, published PDF; three-qutrit preparation, witness, fidelity and fourfold-rate results | 10.1038/s41467-025-59717-y; 851e3b890c00eb2267d3ba2ed5a474faef0df4c3747a67ea5016f52f30025071 |
| Rahimi-Keshari et al., *Direct characterization of linear-optical networks* | **partial**, published PDF; §§1--4 and \(6\times6\) experiment | 10.1364/OE.21.013450; 9bf1021bd57bbcfb5728eb1c363df4dbc6c8f5177aef37b7551f44869bc623fb |
| Somhorst et al., *Quantum simulation of thermodynamics...* | **partial**, published PDF; platform and Methods for mesh, three-photon input, transmission, detection | 10.1038/s41467-023-38413-9; 9c5517762b416869b01256dcc0661611a739f720c37b73a6f7d12b9c0b5d7870 |

## Acceptance and wording gate

- Every individually named source has a read-depth, access/version, cache key,
  and SHA-256 record.
- Every load-bearing characterization was checked in cached full-text bytes.
- The experimental negative records exact queries, screened-set sizes,
  forward counts, disagreements, and uncovered services.
- The manuscript contains no priority use of “first” or “new.”
- Its sole literature-dependent absence sentence uses audit-licensed
  “to our knowledge.”

## ej + tt closeout and mystery ledger

The closeout pass tested the cheapest ways the audit could improve the paper
rather than merely defend it. It added the missing real-SIC terminology
boundary, promoted Piccolini et al. from a search result to a manuscript
citation, and checked both preparation proposals through independent forward
graphs. No further attribution repair was exposed.

| Feature | Status | Evidence gap, gate, or owner |
|---|---|---|
| OpenAlex reports 53 citations on the Goyal seed but returns 55 citing records | **Settled for C768** | Recorded as live-index disagreement; all 55 returned records were screened, so it does not weaken this audit's stop condition. |
| The six icosahedral lines can be called a qutrit SIC although a complex qutrit SIC has nine lines | **Settled** | Manuscript now says “real three-level SIC” and explicitly distinguishes the complex measurement. |
| Two explicit three-qutrit-singlet proposals have produced no located characterized photonic source | **Open mystery** | Google Scholar, MathSciNet, and subject-expert coverage remain absent. C769 owns the physical source-dependency presentation and must keep it external; C770 must rerun the pinned graphs at submission. |

No other genuine mystery remains within C768's attribution and absence scope.

**Vibe check:** the note's theory spine is clean. The audit found one real
bibliographic miss and repaired it without weakening the design-limit result;
the remaining risk is the explicit Google Scholar/MathSciNet/subject-expert
coverage gap, not a located competing experiment.
