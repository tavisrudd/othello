# Reed–Solomon lane — literature-priority audit of the 2026-07-22 landed and ej results

**Lane:** `reed-solomon`

**Date:** 2026-07-22

**Deliverable:** a novelty/priority verdict on the machinery that landed today (C474→C490) and on the
session's ej/discovery-track leads, plus the claim-specific pre-allocation audit the handoff requires
before C491. Follows `literature-audit-conventions.md`; every named source carries a read-depth field
and every load-bearing seed carries three independent forward-citation counts.

**One-line verdict.** Every *tool* the programme uses is classical and pre-empted (deep-hole↔MDS-extension
dictionary, apolarity of binary forms for RS decoding, Gale self-association of six points, the
conic/self-associated characterization, M₀,₆, Kummer/Artin–Schreier descent, line-arrangement counting,
NRC nuclei). The programme's *inverse/reconstruction reading* of that material — recover the GRS parent
up to PΓL from the configuration of its deepest syndromes — has **no predecessor located** in the
covered indices. The redundancy-three results are adjacent to, and not a claimed solution of, either
the Cheng–Murray RS deep-hole conjecture or the PRS covering-radius conjecture.

**Read-depth summary.** Of the load-bearing seeds, one was read at full text (Kaipa, arXiv:1612.05447);
Zhang–Wan–Kaipa (arXiv:1901.05445) and Gmainer–Havlicek (arXiv:1304.0088) at partial (abstract +
targeted sections of cached full text); the remaining load-bearing predecessor (Dür 1991) and every
classical-tool attribution at abstract-metadata, secondary, or review depth only. No verdict here rests
on a source read at less than the depth stated against it. MathSciNet and Google Scholar are NOT
COVERED (unreachable); the negatives below are bounded by OpenAlex + Crossref + Semantic Scholar +
WebSearch coverage, so "to our knowledge" must be retained on every clause an absence gates.

---

## What landed today, grouped by novelty-load-bearing claim

The four frozen C398 control fibres already carry their own claim-specific full-text-and-citation audit
(`2026-07-20-c398-conic-deep-hole-classification.md`, three sources at full text); C474 recorded that
the *new* machinery "requires its own forward audit." This is that forward audit. The C398 control
domain is not re-searched here.

| Claim | Where it landed | Verdict |
|---|---|---|
| **G. Dictionary** — deep hole ⇔ off-secant syndrome ⇔ one-column MDS extension; redundancy-3 conic form | C474/C475 setup | **PRE-EMPTED / KNOWN** — cite, do not claim |
| **A2. Reconstruction** — PΓL-invariant determinant/coefficient atlas; four-view recovery of the parent up to a two-sheet ambiguity | C475/C481/C482/C485 | **NO PREDECESSOR LOCATED** |
| **A3. All-field orbit** — every-characteristic redundancy-3 deep-hole orbit with explicit exceptional fibres | C478/C485 | **PARTIALLY ANTICIPATED** (Kaipa Thm 5 + Lemma 3); only the reconstruction reading is new |
| **B. Gale / M₀,₆** — deck swap = classical self-association; branch divisor = conic locus (incl. char 2); M₀,₆ data model | C481/C483 | tool **PRE-EMPTED**; deep-hole application **NO PREDECESSOR LOCATED** |
| **C. Invariant theory** — Sym²P¹ syndrome plane; deep hole = point-pair harmonic to no support pair; (sextic,quadratic) joint covariants | discovery-track item 3; C475/C481 | tool **PARTIALLY ANTICIPATED** (Dür 1991 apolarity); the joint-covariant/harmonic framing **NO PREDECESSOR LOCATED** |
| **D1. Descent** — C₂ Kummer/Artin–Schreier sheet class; diagonal-stabilizer effectivity; q=8 "3+3" colour quotient | C484 | tool classical; application **NOT PRE-EMPTED** |
| **D2. Small-field** — transversal-3 collision hypergraph; fifteen-line child-complement decomposition; \|U(A)\| = q²−14q+55−τ(A); q≥16 base-size-0 rigidity | C485/C490 | tool classical; application **NOT PRE-EMPTED** |
| **E1. Conjecture boundary** — redundancy-3 reconstruction vs. Cheng–Murray / PRS covering-radius | whole programme | **ADJACENT, not a claimed solution** |

---

## Verdicts and supporting sources

### G — Dictionary: PRE-EMPTED (cite these; make no novelty claim)

Canonical attributions:
- **Kaipa, "Deep holes and MDS extensions of Reed–Solomon codes"** (arXiv:1612.05447; journal DOI
  10.1109/TIT.2017.2706677) — *full text*. Prop. 1: deep hole ⇔ one-digit MDS extension of the dual GRS
  code, via the bijection S_D. §V Thm 5 + the bilinear-form map Φ: the redundancy-3 syndrome point in
  PG(2,q) is a deep hole iff it lies on no secant of the conic/arc.
- **Dür, "On the covering radius of Reed–Solomon codes," Discrete Math. 126 (1994) 99–105** — *secondary
  only* (via Kaipa §IV): covering radius = n−k iff the RNC/arc is complete.
- **Seroussi & Roth, "On MDS extensions of GRS codes," IEEE Trans. IT 32(3) (1986) 349–354** — *secondary
  only* (cache entry is not-a-pdf; read via Kaipa's verbatim restatement). MDS-extension theory of GRS.
- **Segre (1955)**, oval = conic (q odd), the k=2 endpoint — *secondary only* via Kaipa.
- **Wu, Ding & Chen, "Extended codes and deep holes of MDS codes"** (arXiv:2312.05534) — *partial*
  (abstract + §I): the same iff in extended-code language.

### A2 — Reconstruction of the parent from deep-hole data: NO PREDECESSOR LOCATED

No consulted source runs the map in the reconstruction direction. The entire deep-hole corpus is
code → deep-holes (classification / covering radius / coset weights); none poses "recover or identify
the parent GRS code up to PΓL from its deep-hole configuration," none states a PΓL-invariant
determinant/coefficient atlas, and none has a multi-view or two-sheet-ambiguity statement.

- **Kaipa 2016** (*full text*) goes the other way and stops short: Thm 5 classifies deep holes given the
  code; Thm 6 gives canonical forms M1,M2,M3 for a non-GRS one-digit MDS extension up to diagonal
  equivalence. The Φ map (eqn 11) is the nearest primitive to a determinant invariant but is used to
  orbit-classify syndromes, not to reconstruct the parent.
- **Adjacent line to distinguish against — Schur/square-code GRS recovery and code equivalence**
  (Wieschebrink; Couvreur–Gaborit–Otmani–Márquez-Corbella–Tillich; 2024–2025 twisted-GRS Schur-square
  and "Schur product / code-equivalence" work) — *abstract-metadata only*. This body *does* recover GRS
  structure and solve code equivalence, but from the **code's own generator / Schur square**, a
  cryptanalytic setting — not from covering-radius / deep-hole data. It is the closest "recover the GRS
  parent" prior art and must be cited and distinguished; no consulted square-code source uses deep-hole
  data as input. **This line was read only at abstract depth — an open gap; a full-text pass over at
  least Couvreur et al. and the 2025 Schur-product code-equivalence eprint is required before any
  manuscript-bound A2 novelty sentence.**
- Screen of the largest citing set of Kaipa (Semantic Scholar, 28 titles; discriminator = "recover /
  identify the parent from deep-hole configuration, code equivalence from deep holes, or invariants of
  the deep-hole set"): two hits on inspection, neither a predecessor ("framework for constructing
  non-GRS MDS-NMDS codes from deep holes," 2026 — forward/constructive; "deep hole trees of GRS codes,"
  2017 — classification). The other 26 are classification / covering radius / coset weights.

### A3 — All-field redundancy-3 orbit with exceptional fibres: PARTIALLY ANTICIPATED

The all-characteristic orbit structure *with* explicit exceptional fibres is substantially present in
**Kaipa 2016** (*full text*): Lemma 3 gives the three PGL(2,q) orbits in both parities, and Thm 5
partitions deep-hole syndromes into O1..O4 across all k, with the exceptional fibres one would call for
(q-even nucleus (0:1:0); k = q−2 endpoints; the k=2, q-even hyperoval obstruction). So the orbit content
is pre-empted as a *classification*. What is not anticipated is the *reconstruction* reading of that
orbit data — but that novelty is exactly A2, so A3 is a corollary framing rather than independent ground.

### B — Gale association / M₀,₆: tool PRE-EMPTED, deep-hole application NO PREDECESSOR LOCATED

The tools are textbook-classical, not folklore-vague:
- **Eisenbud–Popescu, "The projective geometry of the Gale transform," J. Algebra 230 (2000) 127–173**
  (DOI 10.1006/jabr.1999.7940) — *partial* (publisher/eprint abstract + intro via search summaries;
  full author PDF not fetched). The Gale transform is an involution squaring to identity; self-associated
  sets are its fixed configurations; **"in coding theory the Gale transform is the passage from a code to
  its dual"** is stated verbatim. A conic∩cubic complete intersection is its own Gale transform — the
  six-points-on-a-conic = self-associated characterization.
- **Coble self-association; Dolgachev–Ortland, "Point sets in projective spaces and theta functions"**
  — *review only* (canonical reference, not fetched). Association / self-association of point sets.
- **Cossidente–Sonnino, "Finite geometry and the Gale transform," Discrete Math. 310 (2010)** —
  *abstract-metadata only*. The finite-field / PG(2,q) instantiation — the closest coding-adjacent prior
  art; carries no deep-hole framing.

Not located anywhere: identifying the deep-hole four-view reconstruction two-sheet ambiguity with this
involution (B1); casting the conic locus as the **reduced branch divisor of that deck cover, in every
characteristic including 2** (B2); labelling the GRS deep-hole coherent data model **M₀,₆** (B3).
A striking mathematical parallel — deck ambiguity ↔ moduli of six/seven points — appears in
**Ottaviani–Thomas, "When is one pinhole camera image equal to some other pinhole camera image?"**
(arXiv:2603.14172, 2026; *partial*, abstract), but that is computer-vision multiview geometry and names
neither Reed–Solomon, deep holes, Gale, nor coding.

### C — Invariant-theory framing (highest flagged risk): tool PARTIALLY ANTICIPATED, joint framing NO PREDECESSOR LOCATED

The lane's discovery-track item 3 flagged this. The load-bearing predecessor is:
- **Dür, "The decoding of extended Reed–Solomon codes," Discrete Math. 90 (1991)** (DOI
  10.1016/0012-365X(91)90093-H) — *abstract-metadata only* (full text could-not-access: ScienceDirect /
  CORE / zbMATH all HTTP 403; not cached). Abstract, verbatim: Cauchy codes (incl. RS and singly/doubly
  extended RS) are decoded **"by using an analogue of the classical theory of apolarity of binary
  forms."** This pre-empts the *general* claim that apolarity / binary-form invariant theory is the right
  language for (extended) GRS/Cauchy codes. Its 15-item OpenAlex citing set was screened (discriminator:
  any binary-form / apolarity / joint-covariant / harmonic framing carried into deep holes): **none**
  carried the invariant-theory language forward — modern descendants (Kaipa, Zhang–Wan–Kaipa, Xu) use
  arc / coding language only.

Not located: the *joint* covariant theory of the (support **sextic**, syndrome **quadratic**) pair with
a transvectant/catalecticant tower driving all-field deep-hole **orbit reconstruction** (C2); the
explicit Sym²P¹ identification u ↦ Q_u(t)=u₀t²−2u₁t+u₂ and "deep syndrome = point-pair harmonic to no
support pair," with the secant determinant = (t−s)·(joint harmonic invariant ac′+a′c−2bb′) (C1); the
char-2 nucleus phrased as a universal deep hole with a symplectic-bracket β-form (C3). The classical
(binary sextic, binary quadratic) joint-covariant theory is well developed but only in char-0 /
Siegel-modular contexts (Cléry–Faber–van der Geer, Math. Ann. 2017, arXiv:1606.07014 — *abstract only*),
never over 𝔽_q or connected to codes; modular invariant theory of binary forms (Broer–Chuai
arXiv:0709.0703, *partial*, cached — zero code hits) is likewise not code-connected. **Net: this is a
genuine reframing/bridge, not a clean untouched gap.** A "to our knowledge" sentence must cite Dür 1991
as the closest prior use of binary-form invariant theory for RS and distinguish the new joint-covariant
framing from it. **Dür 1991/1994 full texts were not reached (403); the C2/C3 sub-verdicts rest on the
verbatim abstract and would be sharpened by a body read.**

### D1 — Kummer/Artin–Schreier descent of the reconstruction ambiguity: application NOT PRE-EMPTED

Kummer theory (odd char) and Artin–Schreier theory (char p) are textbook Galois theory and must be cited
as such. The one coding-adjacent hit, "Generalized Gabidulin codes over fields of any characteristic"
(arXiv:1703.09125, *abstract-metadata only*), uses such extensions to *design* rank-metric codes — not a
C₂ descent class governing a reconstruction deck cover. No located source attaches Kummer/Artin–Schreier
descent to code reconstruction, deep holes, or a deck cover of a point configuration; the deep-hole
corpus is uniformly MDS-extension / character-sum framed. The C₂-sheet-class phrasing, the
diagonal-stabilizer effectivity bit, the m-multiplication rule over 𝔽_{qᵐ}, and the q=8 "3+3" colour
quotient as a non-Hilbert-90 obstruction have no external statement found.

### D2 — Small-field transversal / fifteen-line / q²−14q+55−τ(A): application NOT PRE-EMPTED

Screening the full 28-title citing set of the Kaipa anchor returned **no** paper using transversal
number, covering number, hypergraph, line arrangement, fifteen lines, conic reconstruction, or perfect
matchings. The fifteen-line / K₆-syntheme structure is classical but lives in a different subject
(**Cremona–Richmond configuration**; cubic surfaces and 15 tritangent planes; Wiman–Edge,
arXiv:1712.08906 — *abstract/review only*) and is never attached to an MDS code, to deep-hole
reconstruction, or to counting alternative parents of a child configuration. The literal formula
q²−14q+55−τ(A) has no external occurrence (arrangement-complement counting via the characteristic/Tutte
polynomial is standard Orlik–Terao-type, but not this specific quadratic). The secant-union rigidity
lemma (base size 0 for q≥16) and the small-q base-size table have no arc-extension predecessor located
(nearest: unique-extendability work, arXiv:2511.06193, arXiv:2105.10994 — *abstract only*).

### E1 — Conjecture boundary: ADJACENT, not a claimed solution

Two conjectures travel under "RS deep-hole conjecture," and both must be stated:
- **Cheng–Murray (2007), standard/affine RS "only trivial deep holes."** The naive universal form is
  **false** — explicit non-trivial deep holes (degree-(q−2) monomial plus low-degree part) are known
  (Zhang–Fu–Liao and successors; corroborated by arXiv:1612.05447, arXiv:1711.02292 — *secondary/search
  summaries*). What survives is partial/conditional: trivial-only for high rate k ≥ ⌊(q−1)/2⌋ and for
  p>2 under stated degree bounds; the degree-(k+1) sub-case is subset-sum and NP-complete for p>2
  (Cheng–Wan).
- **PRS covering-radius conjecture (Conj. I.2 of arXiv:1901.05445):** covering radius of length-(q+1)
  PRS(k) is q−k, except q even and k∈{2,q−2}; stated equivalent to a finite-geometry MDS/arc conjecture;
  proved for k ≥ ⌊(q−1)/2⌋; **open in general**. *Partial* (cached full text, §§I–II).

The lane fixes the deep-hole = MDS-extension = off-secant dictionary as its *setup* and asks the
**inverse/rigidity** question — reconstruct the parent up to PΓL from the deep-hole configuration, and
find the first fibres where a coarser invariant fails. No consulted source poses or answers this. The
programme's own ceiling statement ("Neither is the general Reed–Solomon deep-hole conjecture") is
confirmed correct.

---

## C491 pre-allocation scope (adjacent; the handoff's required audit)

- **Redundancy-4 PRS deep holes are PRE-EMPTED:** **Zhang–Wan–Kaipa** (arXiv:1901.05445, *partial*,
  cached full text) completely classifies PRS(k) deep holes at redundancy four (k=q−3, Thm I.7), with
  the even-characteristic gap filled by a 2023 Wuhan Univ. J. Nat. Sci. paper (*abstract only*). Both are
  classification, which the lane does not re-claim.
- **Redundancy-5 PRS(q−4) / quartic-NRC / apolar-binary-quartic: NO PREDECESSOR LOCATED.** The published
  classification ladder is explicitly stated to stop at redundancy four. Screening the 1901.05445 citing
  set (24 S2 titles; discriminator = redundancy-5 / codim-5 / PRS(q−4) / quartic NRC / apolar /
  binary-quartic / reconstruction) returned zero matches; WebSearch likewise. Stated over the covered
  domain, not as proven absence.
- **Reusable tool, not a pre-emption:** **Gmainer–Havlicek, "Nuclei of normal rational curves"**
  (arXiv:1304.0088, *partial*, cached) gives the even-characteristic k-nuclei dimension formula in PG(n)
  — for n=4 (5 = 101₂) two distinct nuclei — directly extending the conic char-2 nucleus.

C491 is therefore a genuine first higher-NRC calibration, not a re-derivation, once the standard
pre-allocation gate (a proved higher-symmetric-power analogue) is met per the handoff's Unallocated
level-ups.

---

## Source table (read depth + independent forward-citation counts)

Counts recorded separately per service, never averaged; each resolved by a pinned identifier; disagreement
is itself reported. For each service an empty result was distinguished from an error by requiring a
populated 200-response for the pinned id before recording a count.

| Source | Pinned id (+ sha256 if cached full text) | Read depth | Fwd cites OA / CR / S2 |
|---|---|---|---|
| Kaipa, *Deep holes & MDS ext. of RS* | arXiv:1612.05447 · sha256 1fe8de83…78a4 · DOI 10.1109/TIT.2017.2706677 · OA W2563545890 | **full text** | **20 / 16 / 28** |
| Zhang–Wan–Kaipa, *Deep holes of PRS* | arXiv:1901.05445 · sha256 5c2b9e25…af24 · DOI 10.1109/TIT.2019.2940962 · OA W2973880421 | partial | **21 / 19 / 24** |
| Dür, *Decoding of extended RS codes* (1991) | DOI 10.1016/0012-365X(91)90093-H · OA W2048282328 | abstract-metadata only (full text 403) | **15 / 11 / 17** |
| Eisenbud–Popescu, *Proj. geom. of Gale transform* (2000) | DOI 10.1006/jabr.1999.7940 · OA W2133314801 | partial | **80 / 43 / 110** |
| Gmainer–Havlicek, *Nuclei of NRCs* (2013) | arXiv:1304.0088 · sha256 da688c01…26d0 | partial | (tool; not pinned for cites) |
| Wu–Ding–Chen, *Extended codes & deep holes of MDS* | arXiv:2312.05534 · sha256 9fe68786…6000 | partial | in 1901.05445 citing set |
| Gu–Wang–Zhang, *Deep holes of twisted RS* | arXiv:2509.08526 · sha256 d139d4a7…4279 | abstract-metadata only | in 1901.05445 citing set |
| Seroussi–Roth, *MDS extensions of GRS* (1986) | DOI 10.1109/TIT.1986.1057188 | secondary only (cache not-a-pdf) | — |
| Dür, *Covering radius of RS codes* (1994) | Discrete Math. 126, 99–105 | secondary only (via Kaipa §IV) | — |
| Cossidente–Sonnino, *Finite geometry & Gale transform* (2010) | Discrete Math. 310 | abstract-metadata only | — |
| Dolgachev–Ortland, *Point sets in proj. spaces & theta fns* | Astérisque 165 | review only | — |
| Ottaviani–Thomas, *pinhole camera images* (2026) | arXiv:2603.14172 | partial (abstract) | — |
| Cléry–Faber–van der Geer, *Covariants of binary sextics* (2017) | arXiv:1606.07014 · Math. Ann. | abstract-metadata only | — |
| Broer–Chuai, *Modules of covariants, modular inv. theory* | arXiv:0709.0703 · sha256 e8b7e450…ac7e | partial (cached; zero code hits) | — |
| Schur/square-code GRS recovery & code equivalence | Wieschebrink; Couvreur et al.; eprint 2025/1017; arXiv:2412.15160 | abstract-metadata only | — |
| Gen. Gabidulin codes any char | arXiv:1703.09125 | abstract-metadata only | — |
| Cremona–Richmond / cubic-surface 15-line configuration | arXiv:math/0408283; arXiv:1712.08906 | abstract/review only | — |
| Cheng–Murray standard-RS conjecture line | arXiv:1108.3524; arXiv:1711.02292 | secondary only | — |

Forward-count disagreement is normal cross-index coverage divergence (Semantic Scholar indexes the arXiv
preprint's citers most broadly, including 2025–2026 items; Crossref counts only DOI-registered citing
works; OpenAlex sits between). No count is authoritative; in each cluster the *largest* set was the one
screened. Note: the DOI 10.1109/TIT.2017.2698023 initially guessed for Kaipa is wrong (404 at OpenAlex
and Crossref); the correct DOI is 10.1109/TIT.2017.2706677.

---

## Coverage statement

**Searched and found nothing (licenses the negatives above):** across OpenAlex + Crossref + Semantic
Scholar (citing sets of the load-bearing seeds) and WebSearch, no source connects — to Reed–Solomon /
GRS deep-hole data — reconstruction/identifiability of the parent, the determinant/coefficient atlas, the
four-view two-sheet ambiguity, Gale self-association / M₀,₆ as the deep-hole data model, the conic locus
as a deck branch divisor (incl. char 2), the Sym²P¹ / joint-harmonic-invariant framing, the
(sextic,quadratic) joint-covariant tower, the Kummer/Artin–Schreier reconstruction sheet class, the
transversal-3 / fifteen-line small-field reformulation, the formula q²−14q+55−τ(A), or a redundancy-5
PRS(q−4) / apolar-quartic classification.

**Could not access (licenses nothing; open gaps carried forward):**
- **MathSciNet and Google Scholar — NOT COVERED** (unreachable). Retain "to our knowledge" on every
  clause an absence gates.
- **Dür 1991 and Dür 1994 full texts** — HTTP 403 everywhere, not cached; the C-cluster sub-verdicts rest
  on the verbatim abstract of Dür 1991 plus web summaries. A body read would sharpen C2/C3.
- **Seroussi–Roth 1986 primary text** — cache is not-a-pdf (paywall); read via Kaipa's restatement.
- **Eisenbud–Popescu full PDF; Cossidente–Sonnino; Dolgachev–Ortland** — read at partial/abstract/review
  depth; the 110 Semantic-Scholar citers of Eisenbud–Popescu were sampled, not screened title-by-title.
- **Schur/square-code GRS-recovery & code-equivalence line** — read at abstract-metadata depth only; this
  is the strongest adjacent "recover the GRS parent" body of work and needs a full-text pass (at least
  Couvreur et al. and the 2025 Schur-product code-equivalence eprint) before any manuscript-bound A2
  novelty sentence, in case any of them phrase recovery via covering-radius/deep-hole invariants.
- **zbMATH Open** (freely reachable) was not queried this pass; recommended before a manuscript novelty
  sentence for the Dür line and the redundancy-5 negative.

**Before external novelty wording**, discharge the three open gaps above (Schur/code-equivalence
full-text; Dür 1991 body; a zbMATH pass) and re-run the MathSciNet-gated clauses if institutional access
becomes available.

## Relationship to lane records

- Discharges the discovery-track item-3 novelty flag (`2026-07-22-reed-solomon-discovery-track.md`,
  2026-07-22 ej entry, item 3): the (sextic,quadratic) joint-invariant framing is a reframing bridging
  Dür 1991 apolarity and the Kaipa/Zhang–Wan–Kaipa arc geometry, not a clean gap; internal use as
  vocabulary is unaffected.
- Serves as the claim-specific pre-allocation literature audit the handoff requires before **C491**
  (redundancy-5 PRS): the redundancy-5 / apolar-quartic target is unclaimed in the covered literature and
  the NRC-nuclei tool is available.
- Does not itself allocate any task or re-open the C398 control-domain audit.
