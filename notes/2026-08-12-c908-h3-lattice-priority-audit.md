# C908 pass-9 priority audit: cohomology of the cubic-threefold theta divisor and its blow-up

Date: 2026-08-12

Verbatim report of the bounded literature/priority audit run for
`notes/2026-08-12-c908-h3-lattice-adjudication.md` (sub-agent output, unedited).

# Literature audit: integral cohomology of Bl_0(Theta) for cubic threefold intermediate Jacobian

Task: C908 (per instructions). Question: has H^3(M,Z), H^5(M,Z) for M = Bl_0(Theta) been
computed in prior literature, or the extension statement H^3(M,Z) ext of H^3(X,Z) by
wedge^3 H^1(J,Z) (rank 130), or index-2^10 saturation of pushforward image?

## Cache check

README read. `litcache.py list` searched for clemens/griffiths/cubic/theta/casalaina/laza/
grushevsky/hulek/kramer/weissauer/beauville/intermediate jacobian: NO MATCHES in cache.
Clemens-Griffiths 1972 is NOT cached. Proceeding to web search.

## Web searches (log)


## Cache sources read (before web search)

### 10.2307/1970801 — Clemens & Griffiths, "The intermediate Jacobian of the cubic threefold", Annals of Math 95(2), 1972. Cached, full text (22836 words, 77pp), sha256 6cfe96e...
- Read depth: full text search + targeted section reading (ToC, section 12 "Gauss map and tangent bundle theorem", section 13 "double-six, Torelli, irrationality", Appendix C on the Prym/Torelli argument).
- No section is titled "the theta divisor" specifically; the singularity-of-Theta result is embedded in section 12/Appendix C.
- Exact statement found (near end, Appendix C, p.355 area): "by §13, the singular point of Theta_s = Theta subset J(V) must just be the image of the diagonal of S x S under the difference map (S x S) -> J(V)" — i.e. CG72 prove Theta has a UNIQUE singular point (identified via the difference map of the Fano surface S of lines), consistent with the later "ordinary triple point, tangent cone = X" statement (that sharper local-analytic description is due to Beauville 1982, not found in this cache).
- Searched explicitly for "cohomology of", "Betti number", "H_1(", "H_3(", homology-of-Theta phrasing: NO MATCHES. CG72 (1972) predates any computation of H^*(Theta) or H^*(Bl_0 Theta); the paper is entirely about the intermediate Jacobian's polarization, Abel-Jacobi map, Fano surface, and Torelli/irrationality — not about singular/intersection cohomology of Theta itself.
- Verdict for this source: NOT FOUND (no cohomology-of-Theta or -blowup statement of any kind).

### arXiv:2011.12240 — Bayer, Beentjes, Feyzbakhsh, Hein, Martinelli, Rezaee, Schmidt, "The desingularization of the theta divisor of a cubic threefold as a moduli space" (2020/2022 v2). Cached, full text (26pp).
- Read depth: full text (abstract, intro, Theorem 7.1, searched for cohomology/Betti/Picard/wedge/extension keywords).
- Exact statement: Theorem 7.1 — "The moduli space M_X(v) is smooth and irreducible of dimension 4. More precisely, it is the blow up of Theta in its unique singular point. The exceptional divisor is isomorphic to the cubic threefold X itself, and parametrizes non-locally free sheaves in M_X(v)." This IS exactly M = Bl_0(Theta) from the task.
- The paper's payoff is a new proof of the categorical and classical Torelli theorems via this identification (moduli of Gieseker-stable sheaves / Serre-invariant stability on the Kuznetsov component). It does NOT compute H^*(M,Z), Betti numbers, Picard group rank/structure of M itself, or any wedge^3 H^1(J) extension statement. Grep for "Betti", "wedge", "extension of", "130", "second cohomology", "Néron-Severi" found only unrelated hits (a wedge-product formula for Omega^3_{P^4}, Picard group of X itself = Z, "extension" only in bibliographic/algebra-object senses).
- Verdict for this source: geometric identification of M = Bl_0(Theta) as a moduli space (this is the sharpest match to the task's object), but NO integral or rational cohomology computation of M. NOT FOUND (cohomology-wise).

### arXiv:1510.08891 — Casalaina-Martin, Grushevsky, Hulek, Laza, "Complete moduli of cubic threefolds and their intermediate Jacobians" (2015). Cached, full text (56pp).
- Read depth: full text grep sweep (blow-up/desingularization/cohomology/wedge/Betti/extension keywords), no line-by-line read of proofs.
- This paper is about extending the intermediate-Jacobian period map to a compactified moduli space of cubic threefolds (degenerations, Prym map extension, GIT/Kirwan blow-ups of the moduli space M of cubics, torus-rank-1/2 degenerations). "Extension" throughout refers to period-map extension, not a group-cohomology extension. No mention of Bl_0(Theta) desingularization or cohomology of Theta/its blow-up.
- Verdict: NOT FOUND / not relevant to the specific cohomology question (different "extension" concept; addresses moduli compactification, not H^*(Theta) or H^*(Bl_0 Theta)).

### arXiv:1311.6212 — Izadi, Tamas, Wang, "The primitive cohomology of the theta divisor of an abelian fivefold" (2017). Cached, full text (59pp).
- Read depth: grep sweep for "cubic threefold" — ZERO matches. This paper assumes Theta is SMOOTH (generic ppav of dim 5, e.g. Prym varieties), which is exactly the case that EXCLUDES the cubic-threefold theta divisor (whose Theta is singular at one point). Not applicable to the cubic-threefold case.
- Verdict: NOT RELEVANT (wrong regime — smooth Theta only).

### BEAUVILLE:LNM1194-monodromie — Beauville, "Le groupe de monodromie des familles universelles de hypersurfaces...", LNM 1194. Cached, full text.
- Read depth: grep sweep for cohomologie/monodromie/blow/éclat keywords.
- This is a general Lefschetz-monodromy paper (monodromy group of the universal family of smooth degree-d hypersurfaces of dimension n, acting on H^n(X,Z)/primitive cohomology), not specific to the theta divisor of the cubic threefold or its blow-up. No relevance to H^*(Theta) or H^*(Bl_0 Theta).
- Verdict: NOT RELEVANT.

### Beauville, "Les singularités du diviseur de la jacobienne intermédiaire de l'hypersurface cubique dans P^4" (1982) — the paper that proves the SHARP local statement (ordinary triple point, tangent cone = X) referenced in the task.
- NOT in cache (checked `litcache list | grep -i beauville|singularit`: only the monodromie LNM1194 paper present). Will attempt web fetch below; note as an access gap if unavailable.


## Web search log (all queries, with result counts and disposition)

1. `Beauville singularités diviseur jacobienne intermédiaire hypersurface cubique tangent cone triple point` — 10 links. Identified full citation: Beauville, "Les singularités du diviseur Theta de la jacobienne intermediaire de l'hypersurface cubique dans P^4", LNM 947 (Springer, 1982), pp.190-208. NOT independently fetched (paywalled/no open PDF found in the 10 links); its content is summarized secondhand via the Casalaina-Martin survey below (Theorem 3.2 attribution). ACCESS GAP: could not read Beauville 1982 directly.
2. `Krämer Weissauer Gauss map cubic threefold theta divisor monodromy vanishing cycles` — 10 links, led to arXiv:1501.00226 and arXiv:1807.01929.
3. `"cohomology of the theta divisor" cubic threefold blow-up integral` — 9 links, led to arXiv:2011.12240 (already cached) and Casalaina-Martin survey.
4. `"intermediate Jacobian" cubic threefold "H^3" blowup theta divisor cohomology moduli sheaves` — 10 links, same cluster.
5. `"wedge^3" OR "Λ^3 H^1" intermediate Jacobian cubic threefold theta divisor blow-up integral cohomology extension index` — 10 links, no new relevant hits; no source surfaced discussing wedge^3 H^1(J,Z) or a 2^10-index saturation statement.
6. `Casalaina-Martin Grushevsky Hulek Laza degenerations theta divisor cubic threefold "H^3" saturation index` — 10 links, surfaced arXiv:1904.08728 (Memoirs AMS 282(1395)) and 0710.5329 — both about the MODULI SPACE of cubic threefolds (GIT/toroidal/Baily-Borel compactifications), not about H^3 of Bl_0(Theta) for a fixed cubic threefold. No saturation/index-2^10 statement found.

**Caveat on WebSearch tool's own synthesized prose:** the raw WebSearch summaries (queries 3-4) asserted claims not actually present in the cited papers — e.g. "the stalk cohomology of the pushforward of the structure sheaf... isomorphic to H^{i+4}(V,C)" and "χ(δ_Θ) = 78" attributed to arXiv:2011.12240. These strings were checked directly against the FULL cached text of arXiv:2011.12240 (`grep -iE '78|stalk|Du Bois|pushforward'`) with ZERO matches. This appears to be a hallucinated/confabulated synthesis by the search-summarization layer, not a real statement in the source. Flagging so it is not mistaken for a finding.

### arXiv:2308.15751 — Yilong Zhang, "Extension of the Topological Abel-Jacobi Map for Cubic Threefolds" (2023, v2 2024). Fetched via WebFetch (abstract + full-text pass by the fetch tool).
- About the vanishing-cycle covering space T_v of skew-line pairs and extending the *topological* Abel-Jacobi map over a compactification (Stein's finite-cover compactification lemma) — a different "extension" (of a map, not a cohomology group).
- Explicitly: does NOT discuss Bl_0(Theta), and does NOT compute H^3/H^5 or state any wedge^3-H^1(J,Z) extension/index-2^10 result.
- Verdict: NOT RELEVANT to the cohomology question.

### arXiv:1207.1042 — Sebastian Casalaina-Martin, "Singularities of theta divisors in algebraic geometry" (survey, Contemp. Math. 465, AMS 2008). Fetched as PDF, extracted with pdftotext (poppler), full text read (1123 lines) and grepped.
- Section 3 ("Cubic threefolds") gives the precise, sourced statement the task asks about: **Theorem 3.2 (Mumford [55])**: "The intermediate Jacobian (JX, ΘX) of a cubic threefold X is the Prym variety associated to the double cover of a smooth plane quintic. Moreover, Sing ΘX = {x}, and Cx ΘX ≅ X." — i.e. Theta has a UNIQUE singular point whose (projectivized) tangent cone is isomorphic to X itself. Attributed to Mumford (Prym varieties I, 1974/[55]), with "detailed proofs... given by Beauville [11], and Clemens [23]." This is the exact classical statement underlying "ordinary triple point, tangent cone = X" — its origin is Mumford, elaborated by Beauville (LNM 947, 1982) and Clemens.
- Also states Theorem 3.3 (Casalaina-Martin & Friedman) and Theorem 3.4 (Casalaina-Martin), a converse/Schottky-type characterization of which 5-dim ppavs with a triple-point theta divisor arise this way, and Prop 3.5 on tangent-cone irreducibility.
- Full-text grep for "Betti", "H^3", "H^5", "intersection cohomology", "blow-up cohomology": ZERO matches anywhere in the survey. No cohomological (singular, integral, or intersection) computation of Theta or its blow-up appears anywhere in this survey.
- Verdict: authoritative source for the SINGULARITY STRUCTURE half of the task's question (triple point / tangent cone = X, sourced to Mumford/Beauville/Clemens), but confirms NOT FOUND for any cohomology-of-Theta-or-its-blow-up statement.

### arXiv:math/0403245 — Artebani, Kloosterman, Pacini, "A new model for the theta divisor of the cubic threefold" (2004). Checked via WebFetch abstract only (NOT the Iliev–Manivel paper I initially guessed from the title alone).
- Constructs a birational model of Theta via conic-bundle structure + totally-tangent plane quartics with an even theta characteristic. Abstract gives no cohomology statement.
- Verdict: NOT FOUND (abstract-only read; did not pursue full text — geometric model, not cohomology, is the stated content, low probability of a hidden integral-cohomology theorem; noting as a partial-depth read, not a full-text guarantee).

### arXiv:1904.08728 / AMS Memoirs 282(1395) — Casalaina-Martin, Grushevsky, Hulek, Laza, "Cohomology of the moduli space of cubic threefolds and its smooth models" (2019/2023). Checked via WebFetch abstract.
- This computes (intersection) cohomology of compactifications of the MODULI SPACE of cubic threefolds (GIT, Kirwan blow-up, Baily-Borel, toroidal models of the 10-dimensional parameter space) — a different object entirely from Theta or Bl_0(Theta) of a single fixed cubic threefold.
- Verdict: NOT RELEVANT (different object — moduli of cubics, not the theta divisor of one cubic's intermediate Jacobian).

### arXiv:1501.00226 — Thomas Krämer, "Cubic threefolds, Fano surfaces and the monodromy of the Gauss map" (2015/2016, manuscripta math.). Checked via WebFetch abstract.
- Shows the Tannaka group of Theta (cubic-threefold case) is the exceptional group E_6 — first known exceptional case, tied to Gauss-map monodromy. Sole author Krämer (not jointly with Weissauer, per this paper; Weissauer's contributions to this circle are in adjacent papers, e.g. arXiv:1807.01929 "Characteristic cycles and microlocal geometry of the Gauss map, II", not separately fetched here — access-gap/budget-limited).
- No cohomology (Betti/integral) statement in the abstract; not fetched at full-text depth (budget).
- Verdict: NOT FOUND at the depth read (abstract only) — flagged as a partial-depth read, not a definitive full-text negative.

## FINAL VERDICT: NOT FOUND

No source located (cached or web, ~9 documents examined at full-text or abstract depth) computes the singular/integral cohomology H^*(Theta,Z) or H^*(Bl_0(Theta),Z) for the cubic-threefold theta divisor, in any degree, integrally or rationally. In particular:
- No statement of H^3(M,Z) (or H^5) as an extension of H^3(X,Z) by wedge^3 H^1(J,Z) (rank 130) was found anywhere.
- No statement that the pushforward-to-J image of H^3(M,Z) is the saturation of Theta ∧ wedge^3 H^1 with index 2^10 was found anywhere.
- The identification M = Bl_0(Theta) itself (task's object) IS established in prior literature: Bayer–Beentjes–Feyzbakhsh–Hein–Martinelli–Rezaee–Schmidt, arXiv:2011.12240 / Geometry & Topology 28(1) 2024, Theorem 7.1, proves M_X(v) (moduli of Gieseker-stable sheaves) is smooth, dimension 4, IS the blow-up of Theta at its unique singular point, with exceptional divisor ≅ X. This is a geometric/moduli-theoretic result, not a cohomological one — it supplies the OBJECT but not any Betti-number or integral-lattice computation of it.
- The singularity data feeding the task's "ordinary triple point, tangent cone = X" premise is classical: Mumford (Prym Varieties I, 1974), with detailed proofs by Beauville (LNM 947, 1982, not independently fetched — access gap) and Clemens; recorded via Casalaina-Martin's 2008 survey (arXiv:1207.1042), Theorem 3.2.
- PARTIAL OVERLAP note: no rational-cohomology or intersection-cohomology computation of Theta/Bl_0(Theta) itself was found either (the nearest topically-similar computation, Izadi–Tamas–Wang arXiv:1311.6212 on "primitive cohomology of the theta divisor of an abelian fivefold," explicitly assumes Theta SMOOTH and never mentions cubic threefolds — the smooth-Theta hypothesis excludes this case). So this is not even a PARTIAL OVERLAP in the rational/IH sense; it is a clean NOT FOUND across integral, rational, and intersection-cohomology variants, for both Theta and its blow-up.

## Access gaps
- Beauville, LNM 947 (1982), "Les singularités du diviseur Theta...": not independently fetched (no open PDF surfaced in search; likely paywalled/Springer). Content only known secondhand via Casalaina-Martin's survey citation.
- arXiv:1807.01929 (Krämer-related, "Characteristic cycles and microlocal geometry of the Gauss map, II"): found in search but not fetched (budget) — low prior probability of containing an integral-cohomology-of-Bl_0(Theta) statement given its topic (characteristic cycles / microlocal geometry), but not verified directly.
- arXiv:math/0403245 (Artebani-Kloosterman-Pacini): abstract-only read, full text not checked.
