# Information-theory connections to the Node-Kayles / additive-combinatorics program — scout memo

**Date:** 2026-07-04
**Task:** long-shot fishing — do any OPEN PROBLEMS in information theory connect to, or could be
advanced by, our impartial-game program (Node-Kayles / hypergraph-Node-Kayles on arithmetic /
algebraic structures)? Triaged rigorously; classifications A (substantive) / B (structural bridge,
needs work) / C (superficial/thematic).

## The one decisive negative that frames everything

Our program computes **game values** — Sprague–Grundy nimbers and win/loss outcomes — via symmetry
(pairing/mirror certificates P0/L1/L2) and disjunctive-sum decomposition. Every open IT problem on the
*same substrate* (independent sets in graphs and their powers) is about the **extremal size** or the
**asymptotic rate** of independent sets: Shannon capacity, Körner/complementary graph entropy,
Witsenhausen rate, the matrix-multiplication exponent ω. The independence number α(G) and the Grundy
value G(G) are essentially **independent invariants** — knowing one tells you nothing about the other.
That orthogonality is why most hits are C.

It is not just informal. Strassen's / Zuiddam's **asymptotic spectrum of graphs** is the marquee
framework that literally unifies Shannon capacity with the matrix-mult exponent ω: Θ(G) = min over the
spectrum X of F(G), where X is exactly the family of graph functionals that are (i) monotone under
graph homomorphism, (ii) multiplicative under the strong product, (iii) additive under disjoint union,
(iv) normalized (arXiv:1807.00169). **The Sprague–Grundy value satisfies none of (i)–(iii)** as a
real-valued functional: it is not monotone under homomorphisms, not multiplicative under the strong
product, and its "additivity under disjoint union" is nim-XOR, not real addition. So the Grundy value
is provably *not* a spectral point and cannot bound Shannon capacity through the one theory built to do
exactly that kind of bounding. This is the crisp reason the strongest-looking bridge (independent sets
in powers) does not transfer.

## Ranked shortlist (A/B candidates)

### B1 — Shannon-capacity lower bounds via our independent-set / symmetry-quotient *tooling* (not our theorems)

- **Open IT problem (real, active, competitive).** Determine the Shannon zero-error capacity Θ(C₇) of
  the 7-cycle (and other odd cycles / odd graphs). Θ(C₅)=√5 (Lovász 1979); **Θ(C₇) is open.** State of
  the art is *explicit large independent sets in strong powers*: α(C₇^⊠5) ≥ 350 ⇒ Θ(C₇) ≥ 350^{1/5} >
  3.2271, later nudged via circular-graph constructions. The whole game is: find the biggest
  independent set in a huge, highly symmetric (Cayley/circulant) graph — the strong power of a
  circulant. (arXiv:2509.24600 survey; arXiv:1808.07438 circular-graph C₇ bound; en.wikipedia Shannon
  capacity — computational complexity of Θ itself is *unknown*.)
- **Bridge.** This connects to our **infrastructure**, not our results: we have battle-tested exact
  independent-set search on Cayley/circulant/algebraic graphs with **canonical-form symmetry quotients**
  (AGL(4,3) and multiplier quotients for the cap game, D4/selective-iso for queens), a fast bitmask
  independent-set kernel, and huge flat transposition tables. A strong power C₇^⊠k is a circulant on 7^k
  vertices; symmetry reduction is *the* lever in the SOTA searches, and we own serious symmetry-quotient
  code.
- **Classification: B.** The link is tooling-only; our nimber theory is irrelevant. Two caveats
  that keep it out of A: (a) the SOTA C₇ hunt is an active ILP/SAT/heuristic arena where we have no
  special edge — our TT/canonicalization is tuned for *game-tree recursion*, a different computational
  problem than max-independent-set on a *single fixed* graph; (b) beating 350 is uncertain and would be
  "our compute muscle," not our research program advancing IT.
- **First step (concrete).** Point our circulant/Cayley independent-set machinery + symmetry quotient at
  C₇^⊠5 (16 807 vertices) and try to reproduce α ≥ 350, then C₇^⊠6; if we match cheaply, push for 351+.
  Success metric is unambiguous (the current record). Low-to-moderate expected yield; decide only if the
  user wants a compute-forward side quest.

### B2 — Zero-error / Körner-graph-entropy additivity ↔ our disjunctive-sum decomposition (structural resonance; illuminates a *contrast*)

- **Open IT problem (real).** Single-letter characterization / additivity of **complementary graph
  entropy** (Körner) and zero-error source/channel rates for the **AND (strong) product** of graphs is
  open — single-letter forms are known only for perfect graphs and C₅. The recent arXiv:2407.02281 (Charpenay–Le Treust–Roumy)
  gives new single-letter results for products of perfect graphs and with C₅, and exhibits
  **non-additivity** (Schläfli graph × complement). Zero-error source coding = coloring the confusability
  (characteristic) graph; the object is a channel *hypergraph* (IEEE Witsenhausen rate).
- **Bridge.** Our sum-free / cap games **are** hypergraph Node-Kayles on confusability-like hypergraphs
  (Schur 3-uniform hypergraph of Z_n; AG(n,3) line hypergraph), and we *proved* a disjunctive-sum
  DECOMPOSITION: G(position) = XOR over connected components of the "armed" hypergraph (verified 0
  mismatches, ~70k positions). Both sides ask "how does a value combine over a product/sum of the game
  structure," and both are *easy over the disjoint-union / OR product* while the strong/AND product is
  the hard case.
- **Classification: B (weakest; borderline C).** Same substrate, but the transfer is essentially nil:
  nimbers are *exactly* XOR-additive over components, whereas the entire IT difficulty is that
  entropy/rate is *not* additive over the strong product. The bridge highlights a **contrast** (perfect
  additivity vs. the superadditivity that makes zero-error coding hard), not a tool we can hand over.
- **First step.** Cheap sanity probe: identify whether any confusability graph in the Körner/Witsenhausen
  worked examples (C₅, perfect graphs, Schläfli) coincides with a circulant we've solved, and check
  whether our *maximal*-independent-set (game-terminal) spectra say anything about the fractional /
  Witsenhausen quantities. Expected yield low; mainly a framing note.

## The C list (one-line dismissals)

- **Shannon capacity of powers-of-cycles ↔ our octal games on C_n^k.** *Thematically the closest, still
  C.* Two disqualifiers: our C_n^k is the **distance-≤k power** (a single graph on n vertices,
  Cay(Z_n,{±1..±k})), NOT the **strong-product power** C_n^⊠k on n^|V| vertices that Shannon capacity
  uses; and game nimber ≠ independence rate. Different operation, different functional.
- **Cap sets ↔ slice rank ↔ ω ↔ quantum-entanglement asymptotic spectrum.** Deep IT/complexity structure
  (Croot–Lev–Pach/Ellenberg–Gijswijt; Tao's slice rank feeds ω bounds; Zuiddam's spectrum unifies ω and
  Θ). But it is all downstream of the **extremal cap** (max size); our cap **game** (Grundy value) is
  orthogonal. Beautiful irony, no transfer. (arXiv:2210.01183; cap-set literature.)
- **Nimber aperiodicity / octal Grundy-sequence complexity ↔ automatic sequences / algorithmic
  randomness.** Our unbounded aperiodic 0.11337… Grundy sequences are a fresh instance of **Guy's octal
  periodicity conjecture** — a CGT open problem. "Information content / factor complexity" is
  symbolic-dynamics framing, not a named open IT problem our data advances.
- **Sidon / B_h sets ↔ coding theory.** Real IT area, but the marquee open problem (Erdős's $1000
  Sidon-extension conjecture) was just **disproven** ({1,2,4,8,13}, arXiv:2604.25214), and our Cayley
  constructions don't specifically yield Sidon sets.
- **Sum-free counting / maximal-sum-free structure ↔ entropy & hypergraph-container method; log-rank
  conjecture ↔ additive combinatorics.** Genuine IT-adjacent open problems (log-rank in communication
  complexity, arXiv:1111.5884; entropic Ruzsa distance / PFR, Gowers–Green–Manners–Tao). Our **game**
  doesn't touch the counting/structure that feeds them. The game's *terminals* are maximal sum-free
  sets (Cameron–Erdős territory), but we compute who-wins, not counts.
- **Computability of zero-error capacity ↔ Node-Kayles PSPACE-completeness.** Both "hard on graphs,"
  different objects; game PSPACE-completeness says nothing about Θ's computability (arXiv:2001.11442).
- **XOR / nonlocal games ↔ Shannon capacity.** A two-party XOR game's game-graph can have Θ =
  independence number (arXiv:1704.04922) — but that's classical-vs-quantum *value* of a nonlocal game,
  a different "game" (strategic, not impartial-combinatorial); no bridge to our Sprague–Grundy world.
- **Paley-graph Shannon capacity.** Already *known* (attained at Lovász θ for self-complementary Cayley
  graphs) — no open problem for our Paley thread to touch.

## Verdict

**Mostly C, with two genuine B's and no clean A.** This is the expected outcome for a wide-net fishing
trip. The fundamental obstruction is real and worth banking: our program produces **game values**
(nimbers, outcomes), while every open IT problem on the shared substrate is about **extremal size or
asymptotic rate** of independent sets — orthogonal invariants, and the Grundy value provably sits
outside the Strassen/Zuiddam asymptotic spectrum that governs Shannon capacity and ω.

- The only route by which our **work** could touch an open IT problem is **B1** (aim our
  independent-set/symmetry-quotient *compute stack* at the Θ(C₇) lower-bound record) — concrete,
  measurable, but uses infrastructure not theorems and lands in a competitive arena where we have no
  clear edge.
- **B2** is a nice framing note (nimber XOR-additivity vs. zero-error superadditivity) but hands over
  no tool.

**Recommendation:** not worth a dedicated research session *as a mathematics bridge* — there is no
theorem of ours that advances an open IT problem, and the negative (game value ∉ asymptotic spectrum)
is a clean, publishable-flavored reason why. If the user specifically wants a **compute-forward** side
quest, B1 (Θ(C₇) lower bound) is the single actionable item, judged on its own merits, not as a claim
that the game program advances information theory.

## Sources

- Shannon capacity of graphs / odd cycles (survey): https://arxiv.org/html/2509.24600v1
- New lower bound on Θ(C₇) from circular graphs: https://arxiv.org/pdf/1808.07438
- Shannon capacity of a graph (defn, complexity open): https://en.wikipedia.org/wiki/Shannon_capacity_of_a_graph
- Zuiddam, asymptotic spectrum of graphs = Shannon capacity: https://arxiv.org/abs/1807.00169
- Asymptotic spectrum distance / graph limits / Θ: https://arxiv.org/html/2404.16763
- Additivity of zero-error rates (Körner complementary entropy, AND vs OR product): https://arxiv.org/abs/2407.02281
- Witsenhausen zero-error rate (source coding = graph coloring): https://ieeexplore.ieee.org/document/1255550/
- Computability of zero-error capacity: https://arxiv.org/pdf/2001.11442
- Cap set / slice rank / notions of tensor rank / ω: https://arxiv.org/pdf/2210.01183
- Linear Shannon capacity of Cayley graphs: https://arxiv.org/pdf/2009.05685
- Ben Green, 100 open problems (sum-free / product-free sets §1): https://people.maths.ox.ac.uk/greenbj/papers/open-problems.pdf
- Entropy lower bounds & sum-product: https://arxiv.org/pdf/2604.20233
- PFR settled (Gowers–Green–Manners–Tao): https://terrytao.wordpress.com/tag/polynomial-freiman-ruzsa-conjecture/
- Log-rank conjecture via additive combinatorics: https://arxiv.org/pdf/1111.5884
- Sidon-extension conjecture disproven: https://arxiv.org/pdf/2604.25214
- Node-Kayles PSPACE-complete / algorithmic CGT survey: https://arxiv.org/pdf/cs/0106019
- Node-Kayles on trees (our program's neighbor): https://arxiv.org/html/2512.24221
- XOR-game graph / Shannon capacity: https://arxiv.org/pdf/1704.04922
