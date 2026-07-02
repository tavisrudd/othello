# Open problems in state-space search & finite-domain solver theory — targets for this team

**Date:** 2026-07-02
**Scope:** survey of genuinely open theory problems in search/solver theory this team could tackle —
deliberately NOT limited to the queens/CGT work. Compiled from a fanned-out web survey (four parallel
research passes over the nine directions in the brief) plus direct verification of the load-bearing
papers. Every claim is tagged: `[web-verified: URL]`, `[recalled-unverified]`, or `[computed-here]`
(inference from the team's own measured data or from cited facts). "Found no paper" = weak evidence
of openness (absence after multiple search angles); "explicitly stated open" = strong.

**Calibration assets assumed:** the instrumented DRAM-bound exhaustive solver (measured TT
oversubscription/re-expansion behavior from ~1x to ~200x load, incl. a thrash-to-converge transition
flipped by band-skipping; the measured five-way negative on parallel DFS; dynamic-ordering ≈2x node
value; cross-root killer dynamics; dense endgame-table ceiling sweep), the Lean 4 + mathlib pipeline,
the interleaved-A/B empirical methodology, one 26 GB Zen 5 box, weeks-scale compute.

---

## 0. The two anchor facts that shape everything below

1. **A Dafny-verified minimax/alpha-beta-with-TT paper exists and is under review at CAV 2026.**
   Wesselink, Huizing, van de Wetering, "Formal Verification of Minimax Algorithms"
   (arXiv 2509.20138, v2 Apr 2026): witness-based correctness criterion for depth-limited negamax +
   alpha-beta + transposition tables; one practical TT variant fully mechanized, and Marsland's
   textbook variant (NegamaxTTM) *disproved* by concrete counterexample (a lower bound computed
   under a narrow window unsoundly reused under a wider one). Explicit open items in their
   conclusion: extend the witness framework to SSS*/MTD(f), and find a relaxed correctness notion
   under which NegamaxTTM is sound [web-verified: https://arxiv.org/abs/2509.20138]. Their model
   does NOT cover bounded tables/eviction/replacement, repetition rules (GHI), lossy fingerprint
   keys, or df-pn — all unclaimed [web-verified: full-text extraction, same URL]. Nipkow's Isabelle
   AFP entry `Alpha_Beta_Pruning` (ITP 2024 invited) covers fail-hard/fail-soft over general value
   domains but is depth-unlimited and purely functional [web-verified:
   https://www.isa-afp.org/entries/Alpha_Beta_Pruning.html]. **The Lean lane is empty** — neither
   paper cites any Lean/Coq alpha-beta mechanization [web-verified: related-work of 2509.20138].

2. **No quantitative theory of transposition tables exists at all.** The canonical replacement-scheme
   work (Breuker/Uiterwijk/van den Herik, ICCA J. 1994; Breuker's 1998 thesis "Memory versus Search
   in Games") is empirical [web-verified: https://journals.sagepub.com/doi/10.3233/ICG-1994-17402].
   The single-agent analog (Akagi/Kishimoto/Fukunaga, SoCS 2010) is empirical [web-verified:
   https://metahack.org/akagi_kishimoto_fukunaga_socs2010.pdf]. Searches across replacement-theory,
   competitive-analysis-of-TT, load-factor/re-expansion, thrashing/phase-transition, and
   working-set-applied-to-memoization angles found no predictive model anywhere — the practitioner
   corpus is folklore ("bigger tables are better") [web-verified absence; e.g.
   https://www.chessprogramming.org/Transposition_Table,
   https://en.wikipedia.org/wiki/Transposition_table].

---

## 1. Transposition-table theory (survey direction 1)

### T1 ★ An empirical law + analytic model of re-expansion vs TT load factor

- **(a) Problem + provenance.** Predict the re-expansion factor of DFS-with-memoization on a game
  DAG as a function of oversubscription ratio and replacement policy; characterize the observed
  thrash-to-converge transition as a phase change (working-set / hash-load-threshold style model).
  No such model exists (anchor fact 2). The nearest tools are OS working-set theory (Denning)
  [web-verified: https://www.denninginstitute.com/pjd/PUBS/Workingsets.html] and Young's "loose
  competitiveness" (performance as a function of cache size) [web-verified:
  https://www.cs.ucr.edu/~neal/publication/Young16Paging.pdf] — neither applied to search. The
  formal-models-of-heavy-tails literature (Gomes et al., CP 1997/2001) shows the community accepts
  "abstract model + measured curves" papers for search phenomenology [web-verified:
  https://www.cs.cornell.edu/gomes/pdf/1997_gomes_cp_distributions.pdf].
- **(b) Why this team.** The team already owns the dataset nobody else has: runs from ~1x to ~200x
  oversubscribed, a measured thrash→converge transition flipped by band-skipping (skip[18,25]),
  re-expansion ratios tracked as a validation gate, and byte-identical A/B instrumentation
  [computed-here]. The paper is: model + fitted law + the band-skip intervention as the model's
  predicted control knob.
- **(c) Effort.** 1–2 sessions of gated instrumentation sweeps (small-n proxies fit in spare RAM)
  + modeling/writing; no new large solves strictly required. Low compute.
- **(d) Venue.** SoCS or ICGA Journal for model+measurements; JAIR if the model generalizes; a
  clean competitive-ratio corollary could reach ESA/SODA (see T2).
- **(e) Risk.** Low scoop risk (multi-angle absence). Main risk: "fits one domain" reviews —
  mitigate by replaying the model on the Othello solver and a public domain (e.g. Connect-4).

### T2 A competitive analysis of TT replacement (caching with recomputation costs)

- **(a)** Model eviction cost as re-search cost of the lost subtree; prove competitive ratios or
  impossibility for always-replace / depth-preferred / two-level schemes. Machinery exists
  (Sleator–Tarjan paging, Landlord file-caching [web-verified:
  https://tcsmath.github.io/assets/papers/pot.pdf]); no application to memoized search found
  [web-verified absence].
- **(b)** The team's depth-preferred-measured-3x-worse branch and oversubscription data supply the
  reality check no pure-theory group has [computed-here].
- **(c)** Theory-heavy; the adversarial model may be vacuous (one eviction can cost exponential
  re-search ⇒ unbounded ratio), so expect to need stochastic/locality assumptions. Multi-month.
- **(d)** SODA/ESA if clean; otherwise fold into T1 as a section.
- **(e)** Medium-high risk of a vacuity outcome; low scoop risk.

### T3 Expansion-vs-memory interpolation between IDA* and A*

- **(a)** With memory for M entries (M < n distinct states), what is the optimal worst-case
  expansion count for optimal graph search, and which policy achieves it? Endpoints are famous:
  IDA* on DAGs can blow up doubly-exponentially from transpositions; IBEX
  (Helmert/Lattimore/Lelis/Orseau/Sturtevant, IJCAI 2019) achieves O(n log C*) but assumes full
  open/closed lists [web-verified: https://www.ijcai.org/proceedings/2019/174]. No paper
  interpolating M found [web-verified absence].
- **(b)** Adjacent to T1; the same instrumentation answers the empirical side.
- **(c)** Medium; connects to pebbling (below) which may show worst-case intractability.
- **(d)** IJCAI/AAAI/SoCS (the Sturtevant/Helmert/Lelis re-expansion community is active — e.g.
  SoCS 2024 "Avoiding Node Re-Expansions Can Break Symmetry Breaking" [web-verified:
  https://people.eng.unimelb.edu.au/pstuckey/papers/socs24b.pdf]).
- **(e)** Medium — check the IBEX authors' recent output first.

### T4 Pebbling with cutoffs (background/high-prestige variant)

Bounded-memory recomputation on DAGs *is* the black pebble game (PSPACE-complete to optimize;
red-blue variants UGC-hard to approximate — Papp & Wattenhofer 2020 [web-verified:
https://arxiv.org/abs/2005.08609]). A pebbling variant where pebbling one child obviates siblings
(alpha-beta cutoffs) appears absent from the literature [web-verified absence]. STOC/FOCS-grade,
high difficulty; keep as the "theory ceiling" framing for T1–T3 rather than a first target.

---

## 2. Graph History Interaction (survey direction 2)

### G1 ★ First machine-checked treatment of the GHI problem

- **(a)** Kishimoto & Müller's general GHI solution (AAAI 2004; Kishimoto's 2005 thesis) is
  considered practically complete for exact solving [web-verified:
  https://cdn.aaai.org/AAAI/2004/AAAI04-102.pdf, http://webdocs.cs.ualberta.ca/~mmueller/ghi.html]
  — but its correctness argument is a paper proof; no mechanized treatment of GHI or of
  repetition-rule semantics exists anywhere [web-verified absence across GHI+verification angles].
  The formalization content is real: game values on cyclic graphs under history-dependent legality
  are a least-fixpoint construction with path-dependent state — none of the existing verification
  papers (anchor fact 1) touch cycles or repetition at all.
- **(b)** The Lean pipeline is the asset; this composes with V1/V2 below into a coherent program.
- **(c)** Multi-month formalization; no solver compute needed.
- **(d)** ITP/CPP or JAR; ICGA Journal for the games audience.
- **(e)** Low scoop risk (empty space, verified); the risk is difficulty — the semantics is the
  hard part, which is also the publishable part.
- **Related genuinely-open theory:** the complexity of Go under superko is explicitly open
  (PSPACE-hard, in EXPSPACE; both directions of Robson's EXPTIME-completeness break under superko)
  [web-verified: https://en.wikipedia.org/wiki/Go_and_mathematics] — decades-hard, cite as context,
  don't target. GHI handling in MCTS/graph search is explicitly unsolved in practitioner docs
  (KataGo: "there may need to be significant additional work to handle them correctly")
  [web-verified: https://github.com/lightvector/KataGo/blob/master/docs/GraphSearch.md].

---

## 3. Parallel game-tree search theory (survey direction 3)

### P1 ★ Formal characterization of transposition-saturated workloads (when parallel DFS cannot help)

- **(a)** No formal characterization exists of when parallel DFS over a *search-discovered* DAG
  with shared memoization cannot speed up (effective critical path ≈ total work). Classical anchors
  are too coarse: lexicographically-first DFS is P-complete (Reif) [web-verified via citation:
  https://arxiv.org/pdf/2304.09774]; game evaluation is P-complete (Greenlaw–Hoover–Ruzzo compendium)
  [recalled-unverified: the specific catalog entry]; "top-down memoization is inherently sequential"
  exists only as a course-notes remark, not a theorem [web-verified:
  https://www.cs.cmu.edu/afs/cs/academic/class/15210-f14/www/lectures/dp.pdf]. Existing parallel
  alpha-beta theory (Fishburn–Finkel p^0.5/p^0.8; Kuszmaul's Jamboree work/span; Karp–Zhang optimal
  randomized speedup; Althöfer's 1993 linear-speedup answer to his own 1988 question) all model
  TREES without shared memoization [web-verified: https://www.chessprogramming.org/Parallel_Search,
  https://www.sciencedirect.com/science/article/abs/pii/S0196677483710370]. ABDADA/YBWC/Lazy-SMP
  have no formal bounds at all [web-verified: same chessprogramming index].
  Sharpest hook: **Althöfer & Balkenhol (AIJ 1991) constructed trees easy for sequential alpha-beta
  regardless of ordering and explicitly conjectured they are hard for parallel algorithms — no
  resolution found** [web-verified: https://www.sciencedirect.com/science/article/abs/pii/000437029190042I].
- **(b)** The team owns the measured counterexample set: five distinct DFS-parallelization
  approaches (work-stealing, ABDADA, finer root splits, adaptive tail, warm restart) all
  net-negative on the same workload, with the residual work identified as shared transpositions —
  scheduler-independence is exactly what a span argument predicts [computed-here]. The paper:
  define a "transposition-saturation" parameter, prove parallel-DFS speedup upper bounds
  parameterized by it, connect to the 1991 conjecture (which lives in a tree model that cannot even
  express the mechanism), validate on the measured data.
- **(c)** The modeling is the hard part; measurements largely exist. Multi-month, low compute.
- **(d)** SPAA/PPoPP for model+bounds; JAIR/AIJ for the hybrid; ICGA Journal fallback.
- **(e)** Medium: a referee may say "span=work by construction" — the defense is the five-way
  measured negative. Scoop risk low (vacuum verified across the parallel-search literature).
  Adjacent: TDS (Romein et al., AAAI-99/TPDS 2002) was invented to dodge exactly this regime and
  has no formal conditions for when owner-computes routing beats shared tables [web-verified:
  https://cdn.aaai.org/AAAI/1999/AAAI99-103.pdf] — a two-sided "impossibility + routing conditions"
  paper is a natural extension.

---

## 4. Alpha-beta / minimax foundations (survey direction 4)

### M1 ★ Move-ordering → node-count law for alpha-beta on DAGs with TTs

- **(a)** Between Knuth–Moore's perfect-ordering bound, random-ordering results, and Baudet/Pearl
  i.i.d.-leaf asymptotics, there is NO published model expressing expected node count as a function
  of a measured cutoff-rank distribution — and none at all in the DAG+TT setting, where ordering
  additionally determines *which* nodes get memoized [web-verified absence; classical results:
  https://en.wikipedia.org/wiki/Alpha%E2%80%93beta_pruning,
  https://ftp.cs.ucla.edu/pub/stat_ser/solution-branching-factor.pdf]. Marsland & Campbell's
  "strongly ordered trees" is a qualitative regime label, not a function [web-verified:
  https://webdocs.cs.ualberta.ca/~tony/OldPapers/strong.pdf]. Plaat's thesis states the meta-gap:
  analyses of alpha-beta variants that omit the TT are "a serious omission" [web-verified:
  https://arxiv.org/pdf/2403.13705]. The killer/history heuristics have essentially no theory of
  why cutoff moves transfer between subtrees (only Akl & Newborn 1977) [web-verified:
  https://www.chessprogramming.org/Killer_Heuristic].
- **(b)** The team has: measured ~2x node value of dynamic ordering, the +94% cost of forfeiting it
  (M_WAVE_B), cutoff-rank distributions from the rank-report instrumentation, and cross-root killer
  hit/decay data (depth-1 killers −37.6% nodes, per-ply-band dynamics) — in an EXACT-solving DAG
  with no evaluation noise [computed-here]. An empirical-law paper with a fitted parametric model
  (P(cutoff by move k) → node count), plus the killer-transfer measurements as a section, fills a
  gap where no model exists.
- **(c)** Mostly analysis of existing instrumentation + small-n sweeps; 1–2 sessions of runs +
  modeling. Lowest effort of the starred items.
- **(d)** ICGA Journal or IEEE Transactions on Games; AAAI/IJCAI search track if the model is strong.
- **(e)** Moderate-low: a theory group could derive the tree case; the DAG/TT coupling is where it
  is defensibly open. Partial precedents to cite and distinguish: Newborn 1977, arXiv 1804.06601.

### M2 Minimal proof graph / alpha-beta optimality on DAGs (open since 1996)

- **(a)** For game DAGs, the "minimal tree" benchmark is ill-defined: Plaat/Schaeffer/Pijls/de Bruin
  (AAAI-96) distinguish the Left-First Minimal Graph from the Real Minimal Graph, call computing the
  RMG "computationally infeasible," and estimate it 1.25x (chess) to 2x (checkers) smaller
  [web-verified: https://arxiv.org/html/2403.13705v1 recap]. Open in three layers: a clean
  definition; the complexity of computing it (no hardness proof specific to game DAGs found —
  CAUTION: min-cost solution graphs in general AND/OR DAGs are classically NP-hard, which may
  subsume it [recalled-unverified — check Sahni 1974 / AO* literature first]); and a DAG analog of
  the Pijls–de Bruin critical-tree lower bound ("every algorithm must build a critical tree" —
  trees only) [web-verified: https://repub.eur.nl/pub/468/468.pdf].
- **(b)** The team can *measure* achieved-graph vs LFMG gaps at scale (the ETC/skip-band/dedup
  census instrumentation is RMG-approximation machinery; the 1996 estimates are from tiny searches)
  [computed-here].
- **(c)** Medium-hard theory + measurement companion; multi-month.
- **(d)** JAIR/AIJ; complexity part ISAAC/STACS.
- **(e)** Medium: layer (ii) may collapse into known AND/OR hardness; layer (iii) is genuinely hard
  (that is why it has sat since 1996).
- **Settled — do not pitch:** MTD(f)=SSS* equivalence (Plaat et al., AIJ 1996) [web-verified:
  https://arxiv.org/abs/1702.03401]; tree-model parallel linear speedup (Althöfer 1993); minimax
  pathology is mature but NOT settled — the live corner is granularity-two (win/loss) games and
  "pathology factors vs solving effort," and a quoted gap exists ("not known whether their
  conclusion applies to cases other than the endgame they studied") [web-verified:
  https://www.researchgate.net/publication/257144682_Independent-valued_minimax_Pathological_or_beneficial]
  — viable but tangential for an exact-solving team.

---

## 5. Proof-number search theory (survey direction 5)

- **Closed:** true proof/disproof numbers in DAGs are NP-hard to compute (Gao, arXiv 2102.04907,
  2021) [web-verified: https://arxiv.org/abs/2102.04907]. The 2012 survey's massively-parallel-PNS
  problem was substantially answered in engineering terms in Nov 2025 (Čížek/Balko/Schmid,
  arXiv 2511.10339: large speedups at 1,024 cores, new Sprouts results) [web-verified:
  https://arxiv.org/abs/2511.10339].
- **Open, verbatim:** the Kishimoto/Winands/Müller/Saito survey (ICGA J. 2012, §11) still has item
  (4) unresolved: "Better understand the foundations of search using PNS variants on DCG… Either
  show that current algorithms are complete, or develop new ones that have this property"
  [web-verified: https://webdocs.cs.ualberta.ca/~mmueller/ps/ICGA2012PNS.pdf]. df-pn on cyclic
  graphs remains heuristic patches (df-pn(r), TCA/SNDA) with no completeness theorem [web-verified:
  https://ojs.aaai.org/index.php/AAAI/article/view/7534].
- **Open by absence:** (i) df-pn correctness/termination under a BOUNDED TT — the practice is 1+ε
  thrash-avoidance and SmallTreeGC with no formal guarantee [web-verified:
  https://link.springer.com/chapter/10.1007/978-3-319-09165-5_12 + absence]; (ii) approximation /
  parameterized complexity of true proof numbers in DAGs (nothing found post-Gao); (iii) a formal
  model of the seesaw effect (named pathology, empirical mitigations only — DeepPN) [web-verified:
  https://liacs.leidenuniv.nl/~plaata1/papers/deeppn-camera-29-april.pdf].
- **Fit:** (i) merges naturally into V2 below (the bounded-TT witness extension); (ii)/(iii) are
  respectable standalone theory targets with moderate fit. The team's acyclic domain weakens the
  DCG item's anchor.

---

## 6. Retrograde analysis / endgame tables / succinct structures (survey direction 6)

### S1 ★ Compressed & learned static functions for game tablebases

- **(a)** No theory of optimal space for queryable exact-game-value functions exists (the only
  statement found is an informal entropy conjecture in a 2011 non-venue preprint [web-verified:
  https://arxiv.org/pdf/1112.2144]); Syzygy compression is engineering [web-verified:
  https://deepwiki.com/official-stockfish/Stockfish/7.3-syzygy-tablebases]. Meanwhile "Learned
  Static Function Data Structures" (Hermann/Lehmann/Vinciguerra/Walzer, PVLDB 19(5), 2026) just
  showed learned key-specific codes break the zero-order entropy barrier with large space gains
  [web-verified: https://arxiv.org/pdf/2510.27588] — with NO application to game tables anywhere
  [web-verified absence]. The shaped question: optimal space for a value table whose key set is
  implicit (legal/reachable positions), whose values obey minimax local-consistency constraints,
  and where unreachable entries are don't-cares.
- **(b)** Direct hit on the team's BuRR experience + the measured W_K ceiling sweep (a real
  memory/compute tradeoff curve for dense tables as leaf evaluators) [computed-here].
- **(c)** Weeks; mostly engineering + a modest theory section. Needs some solver runs (box-gated).
- **(d)** SEA/ALENEX or PVLDB; ICGA Journal for the games half.
- **(e)** Low scoop risk on the application; the constraint-aware space-theory half may resist
  clean results. WARNING — avoid the core static-retrieval lower-bound lane: it was just closed
  (Hu/Kuszmaul/Liang/Yu/Zhang/Zhou, arXiv Oct 2025, resolving the O(1)-query nv+o(n) question
  negatively at v=Θ(log n)) [web-verified: https://arxiv.org/abs/2510.18237].
- **Adjacent open:** I/O / time-space complexity of retrograde analysis on implicit graphs has no
  formal treatment (the algorithmic papers — 1-bit RAM, external-memory RA — state no bounds as
  theorems) [web-verified absence; https://content.iospress.com/articles/icga-journal/icg24303].

### S2 Node Kayles on trees (bonus CGT item — literally the team's game family)

Explicitly open for ~three decades: "The computational complexity of Node Kayles is still open even
when the input graph is restricted to trees" [web-verified: https://arxiv.org/pdf/2003.11775];
still unresolved as of the newest work (regular-tree Grundy sequences only, arXiv Dec 2025
[web-verified: https://arxiv.org/abs/2512.24221]); best exact tree algorithm remains exponential
(Bodlaender et al. [web-verified:
https://www.sciencedirect.com/science/article/pii/S0304397514007324]). The team's nimber engines
are an unusual conjecture-generation asset; partial results (degree-bounded trees, new subclasses)
are publishable in TCS/Integers/Games-of-No-Chance. Risk: the full problem has resisted since
Schaefer's era.

---

## 7. Formal verification & certificates (survey directions 7 + crossover from 8)

### V1 ★★ A certificate format + Lean-verified checker for exhaustive game solving ("DRAT for game solving")

- **(a)** No compact, independently checkable certificate format exists for alpha-beta/df-pn
  win-loss DAG solving [web-verified absence]. The field is moving exactly this way: DRAT is
  mandatory in SAT; certificates were recently made mandatory at the Hardware Model Checking
  Competition [web-verified: https://link.springer.com/chapter/10.1007/978-3-031-98668-0_14]; QBF
  has winning-strategy validation for positional games only [web-verified:
  https://drops.dagstuhl.de/entities/document/10.4230/LIPIcs.SAT.2023.24]. The trust gap is
  documented at the source: Schaeffer's "Checkers Is Solved" states the solver "has not been
  independently verified" [web-verified:
  https://webdocs.cs.ualberta.ca/~jonathan/publications/ai_publications/checksolved.pdf], and
  Takizawa's "Othello is solved" remains unrefereed/unverified [web-verified:
  https://blog.computationalcomplexity.org/2023/11/othello-solved.html]. Takizawa's follow-up
  (arXiv 2411.01029, revised Mar 2026) exports "a proof certificate for third-party verification"
  for semi-strong solutions on small boards — adjacent, not the general format+verified-checker
  [web-verified: https://arxiv.org/abs/2411.01029]. No end-to-end machine-checked solved-game
  result exists for any nontrivial game [web-verified absence; Hurd's HOL4 tablebase check (2005)
  and a Coq tablebase generator are the closest [web-verified: https://www.gilith.com/papers/chess.pdf]].
- **(b)** This is the unique triple-asset target: (i) the solver can emit certificates (the
  skip-band/getK structure suggests a natural certificate = the alpha-beta witness DAG restricted
  to cut-justifying children, with dense-table leaves discharged by a verified W_K recomputation);
  (ii) the Lean pipeline builds the verified checker (mathlib already has Sprague-Grundy/nimber
  infrastructure for the compositional pieces [web-verified:
  https://leanprover-community.github.io/mathlib4_docs/Mathlib/SetTheory/Game/Nim.html]); (iii) the
  team owns a NEW unpublished result (queens n=18 first-player win, plus the nimber extensions)
  whose scientific acceptance a certificate would materially strengthen [computed-here]. The
  research content is certificate size vs re-search cost at 10^11–10^14-node scale — a question
  nobody has data for.
- **(c)** The largest item: certificate design + emitter + Lean checker + a certified small-game
  end-to-end demo (Connect-4-scale) before the n=18-scale question. Multi-month, staged; each stage
  (format; verified checker; certified new result) is independently publishable.
- **(d)** CAV/TACAS (format+checker), ITP (verification), ICGA Journal/IEEE ToG (application);
  high-visibility potential for the end-to-end certified new result.
- **(e)** Medium: Takizawa is active in the adjacent lane; certificate size at full scale may force
  a "certified spot-check + verified-recompute hybrid" design (that tradeoff is itself the paper).
  Low risk of the *general verified-checker* lane being taken (verified absence).

### V2 ★ Lean-verified alpha-beta with TT under eviction, bounds, and GHI — the explicitly-open extensions

- **(a)** Grab the CAV 2026 paper's stated open items (SSS*/MTD(f) in the witness framework;
  relaxed NegamaxTTM notion) and the unclaimed extensions their model excludes: bounded tables with
  replacement/eviction (correctness must survive lost entries — the team's re-expansion regime),
  lossy fingerprint keys (soundness as a probabilistic statement with collision accounting — the
  team's 46-bit-floor analysis is a ready-made case study), fail-soft bound-storage across windows,
  and repetition rules (= G1) [web-verified: anchor fact 1; computed-here for the team hooks].
- **(b)** Lean pipeline + a production solver whose exact correctness conditions were engineered
  and audited in anger (int-sizing audit, independent-oracle differential) [computed-here].
- **(c)** Multi-month formalization; zero solver compute.
- **(d)** ITP/CPP; CAV if paired with an executable extraction; JAR for the journal version.
- **(e)** The Eindhoven group is active — differentiate on Lean + eviction/lossy-key/GHI content
  they explicitly do not cover. Nipkow's line is functional/depth-unlimited by design.

### V3 Lean-certified nimber computations extending A344227

Certify solver-computed Grundy values (G(14)–G(16), then G(17)/G(18)) against mathlib's
Sprague-Grundy infrastructure via engine-emitted certificates; heap-sum decomposition verifies
compositionally (sum-of-games = nimber XOR is already in mathlib) [web-verified:
https://leanprover-community.github.io/mathlib4_docs/Mathlib/SetTheory/Game/Nim.html]. No verified
solver-scale game-value computation exists anywhere [web-verified absence]. Uniquely this team's:
nobody else has the data. Venue ITP/CPP/CICM + OEIS/ICGA announcement value. This is V1's natural
pilot stage. Adjacent explicit invitation: the Capture-Quiet Decomposition tablebase-verification
paper (arXiv 2604.07907, Apr 2026) lists "Encode CQD as a lemma in a proof assistant (Lean 4 or
Coq)" as future work [web-verified: https://arxiv.org/html/2604.07907v1] — a collaboration/beat
risk and an on-ramp.

---

## 8. Symbolic/explicit crossover (survey direction 8) — context, weaker fits

- **BDD compressibility:** per-domain bounds exist (Edelkamp & Kissmann AAAI-08: poly for Gripper,
  exponential for permutation games under any variable order [web-verified:
  https://cdn.aaai.org/AAAI/2008/AAAI08-233.pdf]); a *predictive* structural characterization does
  not [web-verified absence]. Moderate fit — the team's canonical-key census data could ground a
  "when would symbolic have won" retrospective; scoop risk from the mature OBDD-lower-bound school.
- **POR for adversarial search:** transferred to two-player *reachability* and parity games
  (Bønneland et al. LMCS 2021 [web-verified: https://arxiv.org/abs/1912.09875]; Neele et al.
  TACAS 2020) but NOT to minimax value search with alpha-beta windows [web-verified absence].
  Caution: the team's own component census (tail graphs 97–100% single-component) is measured
  evidence that independence-based reduction rarely fires in this domain — publishable as a limits
  study, weak as a method paper [computed-here].
- **Parity games in P:** still open (quasi-polynomial since STOC 2017 [web-verified:
  https://dl.acm.org/doi/10.1145/3055399.3055409]); an unreviewed Nov 2025 arXiv P-claim exists,
  treat as unvalidated [web-verified: https://arxiv.org/abs/2511.03752]. Wrong-sized — context only.

## 9. Empirical-law candidates (survey direction 9) — where the team's curves become papers

The heavy-tail literature (Gomes et al.) is the template: measured curves + abstract model = a
durable, well-cited empirical law. The team's candidate curves, in order of "no model exists"
confidence [computed-here, gaps web-verified above]:
1. Re-expansion vs oversubscription + the thrash→converge transition (→ T1).
2. Node count vs cutoff-rank distribution, and killer-transfer decay vs ply distance (→ M1).
3. Endgame-table ceiling K vs node cut vs cyc/node (the memory/compute tradeoff curve for dense
   leaf evaluators — no published analog found; natural section of S1 or a standalone ICGA note).
4. Parallel-DFS speedup vs transposition-saturation parameter (→ P1).

---

## TOP-5 (ranked)

| #  | Target                                                                | Openness evidence                                    | Team edge                                             | Effort                  | Venue                  |
|----|-----------------------------------------------------------------------|------------------------------------------------------|-------------------------------------------------------|-------------------------|------------------------|
| 1  | V1 certificate format + Lean-verified checker for game solving        | Verified absence + explicit field momentum (HWMCC)   | Solver + Lean + own unpublished n=18 result to certify | Multi-month, staged     | CAV/TACAS + ITP + ICGA |
| 2  | T1 re-expansion vs TT load-factor law (+ thrash phase transition)     | Verified absence across many angles                  | The 1x–200x dataset nobody else has                    | 1–2 sessions + writing  | SoCS / ICGA / JAIR     |
| 3  | M1 move-ordering → node-count law on DAG+TT (+ killer transfer)       | Verified absence; Plaat names the meta-gap           | Cutoff-rank + killer instrumentation, exact DAG        | 1–2 sessions + modeling | ICGA / IEEE ToG / AAAI |
| 4  | P1 transposition-saturation bounds for parallel DFS (+ 1991 conj.)    | Theory vacuum + explicit unresolved 1991 conjecture  | The five-way measured negative                         | Multi-month             | SPAA / JAIR / AIJ      |
| 5  | V2 Lean alpha-beta+TT under eviction/lossy keys/GHI                   | Explicitly stated open (CAV 2026 paper) + absence    | Lean pipeline + audited production correctness story   | Multi-month, no compute | ITP/CPP / JAR          |

Near-misses: V3 (certified nimbers — do it as V1's pilot), S1 (learned static functions for
tablebases — freshest low-risk engineering paper), S2 (Node Kayles on trees — verbatim-open,
prestige CGT, hardest), M2 (minimal proof graph on DAGs — open since 1996, check AND/OR hardness
first), G1 (machine-checked GHI — fold into V2).

## Recommendation

**Take V1, with V3 as its pilot and T1 as the concurrent low-cost data paper.** V1 is the only
target that uses all three of the team's differentiating assets at once — a production exhaustive
solver, a working Lean 4 + mathlib pipeline, and possession of a genuinely new scientific claim
(queens n=18 first-player win) that currently rests on informal cross-validation, exactly the trust
gap the literature documents for checkers and Othello. The field's direction of travel is verified:
certificates just became mandatory in hardware model checking, SAT has lived on DRAT for a decade,
and the closest games-side work (Takizawa 2026) stops short of a general format with a verified
checker — so the lane is open but will not stay open indefinitely. It decomposes into
independently publishable stages (format design + size/re-search tradeoff; Lean-verified checker;
certified nimber extensions via mathlib's Sprague-Grundy machinery; the certified n=18 headline),
each stage de-risks the next, and the compute-heavy parts can wait for box availability while the
Lean work proceeds now. T1 runs alongside as the fast, near-free paper: the oversubscription/
re-expansion law is a verified theory vacuum where the team already holds the only dataset.

---
*Method note: compiled 2026-07-02 from four parallel web-research passes (TT/tables, GHI/verification,
parallel/PNS, minimax/symbolic) plus direct verification of anchor papers; sub-agent transcripts are
recoverable via the session's agent traces. Before committing to any target, re-check arXiv for
late-breaking resolutions — the static-retrieval example (closed Oct 2025) shows how fast these lanes
close.*
