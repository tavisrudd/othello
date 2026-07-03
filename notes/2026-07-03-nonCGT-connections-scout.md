# Non-CGT connections scout — Non-Attacking Queens game

**Date:** 2026-07-03
**Purpose:** a wide scan for *structural* bridges (concrete object-to-object maps, not surface
analogies) between this project's objects and **live** open problems in other fields — going
**beyond** the connections an earlier review already banked.

**Our assets (referenced throughout):**
- **Exact solves to n=18** (n=18 = first-player win, witness opening I9 + 15-move PV; extends
  Jenrich, arXiv:1312.5135, n≤16), with a **symmetry-quotiented transposition DAG** as the
  search object.
- **Sprague-Grundy nimbers** G(n) = OEIS **A344227** (published to n=13), **extended G(14)=0,
  G(15)=1, G(16)=0** (G(17) computing). Even-n first-player win contradicts A344227's conjectured
  even→0 pattern.
- **Mirror-obstruction theory:** second-player reflection/pairing strategies are obstructed exactly
  on a thin set — the two long diagonals for even boards.
- **Border-defect / scar framing:** difficulty lives at the board border; the **toroidal** queen
  graph collapses to a trivial/periodic pattern.
- **State-of-the-art solver + measured "laws":** dense boolean/Grundy endgame tables, alpha-beta,
  dynamic move ordering worth ~2× node reduction, plus per-n node-count / cyc-node scaling data.
- **A planned certificate program** (machine-checkable proof of the verdicts).

**Banked already (NOT re-collected here):** 4-uniform hypergraph matching / set packing; independent
domination; well-covered graphs; independence complexes; QBF/strategy certificates (as a bare
concept — the *specific* open problems below are new); symmetry reduction in model checking;
quantified CSP / exact cover; random sequential adsorption / jamming; Cayley graphs / boundary
effects; BDD/ZDD + tablebase circuit complexity; defective graph involutions.

**Method / caveat:** light web research, July 2026. Each connection was checked for a live worker and
a recent result. arXiv IDs are as surfaced by search — spot-check before formal citation. No solver
was run (a 17 GB computation owns the box).

---

## Top 5 (ranked by interest × feasibility)

| # | Connection                                                   | Field                          | Feasibility          | What only we can bring                                                              |
|---|--------------------------------------------------------------|--------------------------------|----------------------|-------------------------------------------------------------------------------------|
| 1 | A344227 as the Node-Kayles nimber sequence of {Q_n}; the octal-periodicity question | CGT / algebraic combinatorics  | transfer-ready       | New certified OEIS terms G(14..17) for a named hard family — the exact data the periodicity conjectures lack |
| 2 | Reflecting/symmetric n-queens = a rigorous form of our mirror-obstruction theory | extremal combinatorics         | needs-theory (feasible) | Exact even-n refuted-symmetric-opening data; can close the small-n existence gap + give first counts |
| 3 | Toroidal queens = strong complete mappings of Z_n; border-defect = a Hall-Paige statement | algebraic combinatorics        | transfer-ready (enum) | An enumerator for strong complete mappings at n≈23–31 (where 2025 circular-sorting work is compute-bound) + the *game* on the torus |
| 4 | Machine-checkable certificate for a Sprague-Grundy value (CQD / QBF-QRAT / DRAT) | proof complexity / verified computation | needs-theory (high value) | A ready candidate certificate (nimber DAG + endgame tables) for the first verified impartial-game nimber table |
| 5 | Non-attacking queens as a long-range hard-core lattice gas; tensor-network free energy | statistical physics            | transfer-ready       | The game/nimber/border layer that the May-2026 lattice-gas paper omits; an exact enumeration oracle for the near-close-packed regime |

**Names that recur as contacts:** Michael Simkin / Lei Wang (counting + physics of the same object);
Tom Kelly (reflecting queens); Anurag Bishnoi & Dion Gijswijt (complete mappings, covering codes);
Burke / Ferland / Teng (nimber-computation hardness); Marijn Heule (verified-certificate pipeline).

---

## 1. A344227 = Node-Kayles nimbers of the queen family {Q_n}; the octal-periodicity question — transfer-ready

**Bridge.** Our game *is* Node-Kayles on the queen graph Q_n, so G(n) is exactly the Sprague-Grundy
sequence of the family {Q_n} indexed by board size. "Is the Node-Kayles Grundy sequence of a graph
family eventually periodic / regular?" is the graph analogue of **Guy's octal-game periodicity
conjecture** (all finite octal games eventually periodic — open even for 3-digit games; some solved
games have astronomically large periods, e.g. ·106 period 3.28×10¹¹; ·007 shows no periodicity in
50M values). Songsuwan et al. just proved eventual periodicity for **n-regular trees / tree-path-tree
families** ("Node-Kayles on Trees", arXiv:2512.24221, Dec 2025) with explicit preperiod/period. The
queen family is the natural *hard, unstudied* test — a dense, module-free family (see #7) where any
regularity would be genuinely surprising.

**Open problem / who / recent.** Guy's conjecture (open). Nimber sequences of Node-Kayles graph
families are actively populated: Wong et al., "Nimber Sequences of Node-Kayles Games" (JIS 23, 2020,
lattice/prism/hypercube); Songsuwan 2025 (trees). Eppstein's octal census; Flammenkamp's octal
database. Crucially, **Burke, Ferland & Teng** ("Nimber-Preserving Reductions...", arXiv:2109.05622;
FUN 2022; TCS 2024) prove computing nimbers is PSPACE-hard and define **Sprague-Grundy-completeness**
— telling us *not* to expect a cheap closed form for G(n), which reframes the goal from "find the
pattern" to "extend the certified sequence."

**Our assets.** *Contribute:* G(14..16) (and soon G(17)) are directly publishable new terms of A344227
for a named hard family — the exact object these conjectures are about; A344227 currently stops at
n=13. The even→0 contradiction is a live data point in the regularity question. *Import:* the
tree/path nimber-preserving reduction tricks (arXiv:2109.05622) may accelerate the engine on
structured sub-boards; misère quotients (see #9) are an unexplored companion.

**First experiment / contact.** Submit G(14..16) to OEIS A344227 with the engine as certificate;
also emit G on the **toroidal** Q_n (vertex-transitive — where periodicity is most likely and would
isolate the border as the periodicity-breaker). Contact: Nuttanon Songsuwan; Aaron Siegel / Richard
Nowakowski (CGT); N. J. A. Sloane (OEIS).

---

## 2. Reflecting/symmetric n-queens = a rigorous form of our mirror-obstruction theory — needs-theory (feasible)

**Bridge.** Slater's 1963 problem (pair 1..n with n+1..2n as (i, aᵢ) so all sums aᵢ+i and differences
aᵢ−i are distinct — a distinct-difference/graceful labelling) is, by Klarner (1967), **equivalent to
a reflecting n-queens configuration** (queens on a board with a reflecting strip, attacks bounce off
the edge). The published lemma "no n-queens solution is fixed by any reflection for n≥2" is exactly
our **mirror-obstruction** claim made rigorous — reflection strategies die on the diagonal axes; our
even-board two-long-diagonal obstruction is the concrete mechanism. Static symmetry (theirs) vs.
strategy symmetry (ours), same diagonal-defect phenomenon.

**Open problem / who / recent.** **Tantan Dai & Tom Kelly (Georgia Tech), "On the existence of
reflecting n-queens configurations," arXiv:2407.12742 (2024, rev. Aug 2025)** — existence for all
sufficiently large n via a probabilistic rainbow-matching / absorber argument; **small-n existence
(verified only to n≈27) and all counting are open.** Reduction to distinct-sums-and-differences
pairings ties this to Sidon/Costas objects (#14).

**Our assets.** *Contribute:* for each even n≤18 our solver yields *exactly which* reflection-symmetric
openings are refuted and the refuting square — a direct empirical test of whether the strategic
obstruction set coincides with Dai-Kelly's static diagonal locus; and we can **close the finite
small-n gap** + give the first counts (a clean citable micro-contribution). *Import:* their
rainbow-matching "complete a partial non-attacking set" lemma could power an endgame-completion
heuristic and might **prove** why our mirror must fail precisely on the long diagonals (currently
empirical), possibly explaining the even-n first-player win.

**First experiment / contact.** Enumerate reflecting configs / Slater pairings for n=25–32 (tiny
search), publish counts, confirm/deny the small-n gap; tabulate even-n refuted symmetric openings and
check refutation squares lie on {main, anti} diagonals. Contact: **Tom Kelly** — the single closest
external match to our theory; Michael Simkin.

---

## 3. Toroidal queens = strong complete mappings of Z_n; border-defect = a Hall-Paige statement — transfer-ready (enumeration)

**Bridge.** A toroidal n-queens solution is exactly a permutation ψ of Z_n for which both i↦ψ(i)+i and
i↦ψ(i)−i are bijections — a **strong complete mapping** (a complete mapping that is also an
orthomorphism). Existence iff gcd(n,6)=1 (Pólya 1918) *is* the toroidal-collapse condition we observe.
Our "torus trivial / all hardness at the border" is the game-theoretic shadow: on Z_n the constraint
linearises into the orthomorphism algebra; the border breaks the group structure. The even/odd board
asymmetry matches the parity split (complete mappings of Z_n exist iff n odd; orthomorphisms iff n
even).

**Open problem / who / recent.** Counting strong complete mappings = counting toroidal n-queens T(n):
Bowtell-Keevash gave T(n) ≥ ((1−o(1))n e⁻³)ⁿ for n≡1,5 (mod 6) (arXiv:2109.08083). **Bastide, Bishnoi,
Groenland, Gijswijt, Joshi, "Circular sorting, strong complete mappings and wreath products,"
arXiv:2510.18529 (Oct 2025)** — needs exactly the hand-enumeration of non-affine examples at n≈23–31
that we could automate. The **Hall-Paige** frontier is hot: Eberhard-Manners-Mrazović "A random
Hall-Paige conjecture" (arXiv:2204.09666, Inventiones 2025); Müyesser (arXiv:2303.16157). Transversal
side: Montgomery, "Ryser-Brualdi-Stein for large even n" (arXiv:2310.19779, 2023).

**Our assets.** *Contribute:* our solver + canonicalisation + flat TT is a ready enumerator of strong
complete mappings for the compute-bound regime; a genuinely novel item — **Node-Kayles ON the toroidal
queen graph** (nimbers no one has computed; a strategy-stealing/pairing argument may provably apply on
the vertex-transitive torus but fail on the board). *Import:* wreath-product constructions to seed
better toroidal-queens generators.

**First experiment / contact.** Count strong complete mappings for n=25,29,31, diff against
arXiv:2510.18529's n=25 exhaustive value as a correctness oracle; then compute toroidal Node-Kayles
nimbers for gcd(n,6)=1 vs. gcd≠1. Contact: **Anurag Bishnoi / Dion Gijswijt (TU Delft)**; Ian Wanless
(orthomorphisms); Richard Montgomery (transversals).

---

## 4. A machine-checkable certificate for a Sprague-Grundy value — needs-theory (highest value for the certificate program)

**Bridge.** Our solver already builds the object the verified-tablebase world checks: a
symmetry-quotiented DAG whose nodes carry a value. The verification frontier is *retrograde / local
consistency* — reduce "the whole table is correct" to independent per-node checks. **Pavlov's
Capture-Quiet Decomposition (CQD)** (arXiv:2604.07907, Apr 2026) does this for chess WDL tablebases:
every position is terminal / capture (anchored to a separately-verified sub-table) / quiet (local
retrograde check). Map: our **terminal** = empty available-move set; **capture anchor** = the dense
W0..W8 / getK endgame tables (each a separately-checkable base case); **quiet check** = the mex law
one ply deep (P-position ⇒ all children nonzero; N-position ⇒ some child zero). The certificate = the
DAG; the checker = a single linear pass re-deriving canonical children and verifying mex.

**Open problem / who / recent.** *Produce a compact, machine-checked certificate for a Sprague-Grundy
value / a PSPACE game verdict.* State of the art is fragmentary: Hurd's HOL4-verified chess endgames
(tiny); Pavlov CQD 2026 (theorem reducing to local checks, **not yet mechanised** — "future work:
Lean 4/Coq"); the verified-SAT crowd (**Heule**, Kullmann, Wetzler; Lammich's GRAT; ACL2/Coq LRAT
checkers) has verified UNSAT proofs at petabyte scale (Pythagorean triples 200 TB, Schur-5 2 PB,
Keller-7) but **no verified impartial-game nimber table exists** — only partial Coq/Lean
formalisations of SG *theory*, not of a computed table. Companion: our n=18 verdict is a true-QBF
statement, exactly the shape of **Shaik, Heisinger, Seidl & Biere, "Validation of QBF Encodings with
Winning Strategies" (SAT 2023)** and "Concise QBF Encodings for Games on a Grid" (arXiv:2303.16949) —
their validator plays interactively against a QBF certificate. Dead-end (loss) branches are
n-Queens-Completion UNSAT instances (#8) that DRAT-trim could certify.

**Our assets.** *Contribute:* the nimber DAG to n=16, plus the n=18 I9 witness + PV, are ready
candidate certificates; the two independent getK-configs "agreeing at different node counts" is
already a poor-man's cross-check that CQD tells us how to make a single-pass local proof. *Import:*
the CQD decomposition + LRAT/QRAT discipline give the missing correctness architecture.

**First experiment / contact.** Emit a certificate file (canonical-key → nimber map for n=10–12 +
endgame tables) and write a standalone checker that verifies the mex law at every node with
independently re-derived children; then mechanise in Lean 4. Separately, encode Non-Attacking-Queens-n
as QBF, run a certifying solver (DepQBF/CAQE) for n=8–12, validate with Shaik's tool. Contact:
**Alexander Pavlov** (CQD); **Marijn Heule** (verified-checker pipeline); **Irfansha Shaik / Martina
Seidl** (QBF strategy validation).

---

## 5. Non-attacking queens as a long-range hard-core lattice gas; tensor-network free energy — transfer-ready

**Bridge.** A partial independent set of Q_n = a configuration of a **hard-core lattice gas** whose
exclusion is infinite-range along four line pencils (row, column, two diagonals) — the exotic end of
the hard-particle family (Baxter's hard hexagons/squares exclude only nearest neighbours). Max-density
(a full n-queens layer) has packing entropy given by **Simkin's constant** α≈1.944 (Q(n) ∼ (n e⁻ᵅ)ⁿ);
his "queenon" limit object is literally the continuum free-energy/density profile of this gas.

**Open problem / who / recent.** **Liu, Liao & Lei Wang, "Statistical mechanics of the N-queens
problem," arXiv:2605.10326 (May 2026)** — treat queen placements as this lattice gas, Monte-Carlo to
N=1024, build a rank-9 transfer-matrix tensor network, recover α=1.946±0.003, and find **no
thermodynamic phase transition** (non-divergent Cᵥ). This is the exact same object minus any game /
nimber / torus-decomposition layer — a clean unclaimed surface. Long-range hard-core lattice gases are
an active MC program (Rajesh/Nath et al., PRE 2020–2022) but all *finite*-range; infinite-line
exclusion is a genuine gap. Tooling: **GenericTensorNetworks.jl** (Liu, Wang, Zhang, arXiv:2205.03718,
SIAM J. Sci. Comput. 2023) already counts independent sets, maximal sets, and Grundy — pointable at
Q_n. Structural aside: non-attacking **rooks** = dimers on K_{n,n} = free-fermion (Kasteleyn); adding
diagonals destroys the Pfaffian structure — **queens are the first interacting (non-Gaussian) vertex
layer above free-fermion rooks**, a crisp citable dividing line.

**Our assets.** *Contribute:* the exact solver is a ready enumerator/transfer engine for the
near-close-packed regime MC struggles with; our nimber/decomposition tables give exact finite-N
structure; the game layer + border decomposition is the novel physics the 2026 paper omits. *Import:*
thermodynamic-integration + tensor-network machinery to independently sanity-check our node/leaf
enumeration.

**First experiment / contact.** Run GenericTensorNetworks.jl on Q_n's independence polynomial + Grundy
count and cross-check against our exact counts (immediate); add a directed-placement (game) transfer
operator to the paper's rank-9 tensor and contract on torus vs. open board to measure whether the
free-energy difference is an O(n) boundary term. Contact: **Lei Wang / Jin-Guo Liu** (they hold the
tensor + code); Michael Simkin (queenon variational).

---

## 6. Grundy/nimber as an ML target; our labeled DAG as a neural-algorithmic-reasoning benchmark — needs-theory, experiment-ready

**Bridge.** Our transposition DAG carries exact Grundy labels G(position). Grundy = mex of children's
XOR — a **parity/modular, maximally input-sensitive, non-local** function, precisely the target class
the grokking / length-generalisation / parity-learning community flags as hardest for nets.

**Open problem / who / recent.** **"Impartial Games: A Challenge for Reinforcement Learning" (Machine
Learning journal, 2026; arXiv:2205.12787)** — the direct hit: AlphaZero-style self-play *fails* on
impartial games (Nim) because the nim-sum target is "statistically neutral" (zero correlation between
a partial position and its value). "Why are Sensitive Functions Hard for Transformers?" (Hahn & Rofin,
arXiv:2402.09963); RASP-L length-generalisation conjecture (Zhou et al., arXiv:2310.16028) — parity has
no short RASP-L program ⇒ 0% length generalisation. Grokking on modular/parity targets is live
(arXiv:2406.03495 and others). **CLRS-30** neural-algorithmic-reasoning benchmark (Veličković et al.,
ICML 2022) has **no game-tree/Grundy DP task** — a gap our data fills.

**Our assets.** *Contribute:* an exactly-labeled Grundy dataset on a real combinatorial family with a
natural size axis (n=4…16, G(17) computing) — a **new NAR task** ("learn the Grundy DP on the
transposition DAG"), provably harder (non-local XOR) than anything in CLRS-30, and a mechanistic-interp
testbed for whether a GNN forms a nim-sum circuit. *Import:* grokking/RASP-L results predict a net will
fail to length-generalise the nimber small-n→large-n — a cheap falsifiable test.

**First experiment / contact.** Train a GNN to regress G on high-pc positions at n≤12, test
extrapolation to the n=14/16 leaf-Grundy labels we already hold; the ML-interesting result is the
failure curve vs. board size. Contact: Petar Veličković (CLRS/NAR); the Machine-Learning-2026
impartial-games authors.

---

## 7. The queen graph defeats every known Node-Kayles FPT parameter — a sharp explanatory negative — transfer-ready (as explanation)

**Bridge.** Node-Kayles is FPT by **vertex cover** and **modular-width**, with a poly kernel by
**neighbourhood diversity** (Kobayashi, "On Structural Parameterizations of Node Kayles," IWOCA 2021,
arXiv:2003.11775). None help Q_n, provably: **treewidth** ≥ ω−1 ≥ n−1 (a full row is an n-clique;
Cardoso et al. spectral clique-structure, arXiv:2012.01992); **vertex cover** = n²−α = n²−n (maximal,
since α(Q_n)=n); **modular-width / neighbourhood diversity** ≈ trivial — which our own `module_profile`
probe already measured (twin pairs 3.8% at pc 13 → ~0% by pc 18; "reduces% = 0 across pc 13–20"). This
is a clean theory-matches-experiment story: the queen graph lands in the *worst corner* of the
Node-Kayles parameter map — dense, cover-heavy, module-free — explaining why our engine leans on
transposition/ordering, not structural decomposition.

**Open problem / who / recent.** *Is there ANY structural parameter under which Node-Kayles on Q_n is
tractable?* Hanaka, Ono, Yoshiwatari, "Colored Node Kayles" (PRIMA 2025) — PSPACE-complete on planar
max-deg-3, **W[1]-hard parameterised by number of turns**, plus hardness of computing game values.
Clique-width of Q_n (which can stay small on dense graphs where treewidth blows up) is an open,
cheap-to-probe question.

**Our assets.** *Contribute:* Q_n as a concrete, important instance that simultaneously defeats tw,
VC, and modular-width, backed by our measured module statistics — a natural stress test for
"beyond-these-parameters" FPT theory, and the largest-ever concretely-solved Node-Kayles instances.
*Import:* W[1]-hardness-by-turns is the theoretical reason our search cannot be made FPT in depth.

**First experiment / contact.** Compute (or SAT-bound) clique-width of Q_n for small n — if bounded,
Courcelle-style algorithms might apply where treewidth fails. Contact: **Tesshu Hanaka / Yasuaki
Kobayashi**.

---

## 8. Random-greedy queens process, completion threshold, and a structured-CSP backbone/frozen map — transfer-ready (measurement)

**Bridge.** Play our game with *random* moves = the random-greedy independent-set process on Q_n; its
typical terminal fraction is a **jamming constant**, its smallest terminal set a **saturating/blocking**
config. A partial placement hit deep in the tree is an **n-Queens-Completion** instance; near-maximal
placements have a **backbone** (forced squares) and **frozen variables** — the structured-CSP
analogues of the random-CSP freezing picture. Our "border-defect" tail (pc 13–21, transposition-
saturated) *is* a structured hardness peak in CSP language.

**Open problem / who / recent.** The completion threshold q_c(n) (largest k s.t. every partial
placement of size ≤ k is completable — an adversarial-flavoured, exactly-our-regime quantity): Glock,
Munhá Correia & Sudakov, "The n-queens completion problem" (arXiv:2111.11402, 2021) gave n/60 ≤ q_c ≤
0.241n; **Nielsen just improved the upper bound to q_c(n) ≤ 0.216n (arXiv:2606.24400, June 2026)**;
the constant is wide open. The random-greedy jamming constant of Q_n is uncomputed — the general
local-limit machinery (Krivelevich et al., arXiv:1907.07216, RSA 2024; Wormald's DE method) covers
paths/cycles/planar but not the queen structure. n-Queens Completion is **NP- and #P-complete**
(Gent, Jefferson, Nightingale, JAIR 2017). Note: a natural completion generator was flagged as *not*
yielding consistently hard random instances — a structured-hardness open question.

**Our assets.** *Contribute:* our move generator + DAG already distinguish completable vs. stuck
partials, so we can give exact small-n q_c(n), the full jamming-size distribution, and a deterministic
backbone / frozen-fraction hardness map across n and pc — exactly the structured (non-random)
phase-transition data the field lacks a good generator for. *Import:* DE-method / local-limit
predictions for Q_n.

**First experiment / contact.** Add a gated const-generic probe recording |backbone| vs. pc along
root-to-leaf paths; plot node-count vs. backbone-fraction to locate the structured hardness peak;
Monte-Carlo the random-greedy playout for n≤18 for the jamming distribution. Contact: Hugo Møller
Nielsen; Benny Sudakov / David Munhá Correia (ETH); Peter Nightingale / Ian Gent (St Andrews).

---

## 9. Computing the nimber is provably harder than the verdict (SG-completeness); misère quotients untouched — needs-theory / transfer-ready (data)

**Bridge.** Our project sits exactly on the gap this line formalises: we have the win/loss *outcome*
to n=18 but the *nimber* only to n=16. **Burke, Ferland & Teng** prove the nimber of Undirected
Geography is PSPACE-complete to compute even though its win/loss is poly-time; they define
**Sprague-Grundy-completeness** and show Generalized Geography / Node-Kayles are SG-hard, with a
homomorphic theorem (build a game whose nimber XORs two given nimbers). So computing G(n) is the
SG-complete task; solving I9's verdict is strictly easier-in-kind — a first-principles reason n=18's
verdict fell while A344227 lags.

**Open problem / who / recent.** Is Node-Kayles SG-complete under nimber-preserving reductions? (open,
their framework). Misère play of Node-Kayles on Q_n is untouched: **Plambeck-Siegel misère quotients**
(JCTA 2008, arXiv:math/0609825; miseregames.org) localise the SG function to a commutative monoid — no
one has the queen-graph misère quotient. Burke/Ferland/Teng: arXiv:2109.05622 (FUN 2022; TCS 2024).

**Our assets.** *Contribute:* our exact normal-play nimbers are the hardest available data for a
natural family; the solver can be repointed to compute **misère** outcomes/quotients for small Q_n —
new data in a field starved of computed quotients beyond octal games. *Import:* the SG-completeness
framing (don't expect a closed form; extend the certified sequence instead).

**First experiment / contact.** Run the engine in misère mode for n≤9–11 and feed the position monoid
to Siegel's MisereSolver. Contact: **Matthew Ferland / Shang-Hua Teng** (nimber hardness); Aaron Siegel
(misère).

---

## 10. Independence polynomial of Q_n = Lee-Yang zeros of the queen lattice gas — transfer-ready (compute the polynomial)

**Bridge.** I(Q_n; x) = Σ i_k xᵏ with i_k = number of k-non-attacking-queen placements. In physics
its roots are **Lee-Yang zeros** governing the hard-core-gas phase behaviour (absence of roots near the
positive real axis ⇒ analytic free energy). **Chudnovsky-Seymour (2007)** give real-rootedness for
claw-free graphs — but **Q_n is riddled with claws K_{1,3}** (a center square with three mutually
non-attacking attackers), so the theorem does *not* apply and the root location is genuinely open.

**Open problem / who / recent.** Roots of independence polynomials of non-claw-free families is an
active micro-topic (e.g. parity-dependent real-rootedness of generalized Petersen graphs,
arXiv:2601.03293, 2026); Sokal-type zero-free regions; log-concavity of the coefficient sequence.
Ties to the counting asymptotics (Simkin; Luria-Simkin arXiv:2105.11431) and to permanent
approximation / Barvinok zero-free interpolation.

**Our assets.** *Contribute:* our machinery enumerates non-attacking placements, so we can emit the
exact coefficient vector i_k(Q_n) for n up to reach and numerically locate the complex roots
(real-rooted? clustered near 0? on a curve?) — a previously-uncomputed dataset for the
"roots-beyond-claw-free" question and a bridge object to #5. *Import:* Lee-Yang / Sokal zero-free
region theory to characterise the queen gas.

**First experiment / contact.** Compute i_k(Q_n) for n≤~15, find roots, test real-rootedness and
log-concavity/unimodality of (i_k). Contact: the independence-polynomial-roots groups (rooted-products
/ GP(n,k) real-rootedness).

---

## 11. Surface/corner criticality; the two long diagonals as a defect line — needs-theory (highest-value framing import)

**Bridge.** "All difficulty at the border; torus trivial" is a **surface-vs-bulk** statement in the
precise stat-mech sense: torus = homogeneous bulk with a simple ordered ground state (complete layers
exist iff gcd(n,6)=1); open board = same bulk + a boundary carrying all the frustration; the four
corners (row+col+diagonal pencils colliding) are the natural home of a **corner free-energy** term.
Separately, our mirror-obstruction's two long diagonals are a **pair of crossing line defects** — a
seam through an otherwise translation-invariant lattice, the exactly-solvable **defect-line** setting.

**Open problem / who / recent.** Corner free energy: Cardy-Peschel (1988) log correction; exact modern
corner free energies (Vernier-Jacobsen, arXiv:1110.2158). Surface universality: **Metlitski**, the
"extraordinary-log" class (arXiv:2009.05119, 2020; XY confirmation PRL 2021) — very active 2020-2026.
Line defects: Bariev / McCoy-Perk continuously-varying local exponents; conformal defect lines
(Oshikawa-Affleck). Given #5's "no bulk transition," our border is most plausibly a **non-critical
O(n) defect term**, not a named surface universality class — worth stating precisely rather than
over-claiming.

**Our assets.** *Contribute:* an exactly-solvable combinatorial system where "bulk trivial, boundary
hard" is provable and quantifiable (excess node count / excess entropy per n) — a novel defect that is
*game-theoretically* rather than energetically defined. *Import:* the surface-critical vocabulary
(ordinary/special/extraordinary, corner exponents, Bariev non-universality) to classify *what kind* of
boundary ours is.

**First experiment / contact.** Fit (board count − torus count) and (board nimber-structure − torus)
across n to a·n + b·(corner term); a Cardy-Peschel log(n) residual would be a real corner-exponent
signal. On even n, measure density of undecided positions vs. distance from the main diagonal — a
non-universal power would echo Bariev. Contact: Jesper Jacobsen (corner free energies); Max Metlitski
(surface universality).

---

## 12. Move-ordering laws ↔ proof/disproof number and QBF proof-size lower bounds — needs-theory

**Bridge.** Our "move ordering is worth ~2× node reduction" and the node-count scaling laws are
statements about **certificate size**. The minimal number of nodes to prove a game value is the
**proof/disproof number** (Allis's conspiracy/proof numbers, 7×6 Connect-Four 1988) — an and/or-tree
lower bound. Our `tt.nodes()` vs. the ~5.6× larger "explored" α-β count are two size measures of the
same certificate. On the lower-bound side, QBF proof complexity converts circuit lower bounds into
proof-size bounds via strategy extraction, using **prover-delayer games on partial assignments** —
structurally our partial-independent-set states.

**Open problem / who / recent.** Are there proof-size lower bounds for Node-Kayles / independent-set
game verdicts in resolution or QBF calculi, and do they explain the node-count scaling? Beyersdorff,
Chew, Clymo, Mahajan (QBF proof complexity, prover-delayer lower bounds; STACS 2018; ACM ToCT 2019).
Proof-number-search community: Müller, Kishimoto, Pawlewicz.

**Our assets.** *Contribute:* a rare *empirical* proof-size dataset — near-minimal certificate sizes
for a natural PSPACE game family across n, with a measured ordering law. *Import:* the prover-delayer
framework gives a principled lower bound on "how small can the certificate get" — a first-principles
way to reason toward whether the ordering wins are approaching an information-theoretic floor (rather
than declaring one by fiat).

**First experiment / contact.** For small n compute the true proof/disproof number (minimal and/or
tree) and compare to our ordered node count; the gap quantifies "how much ordering is left." Contact:
**Olaf Beyersdorff (Jena)**.

---

## 13. RL curricula across board sizes with an exact oracle — transfer-ready (infra) / needs-theory (outcome)

**Bridge.** Our solved sizes n=4,6,…,18 form a canonical **size curriculum with an exact oracle**
(winner + full Grundy + measured scaling at every n).

**Open problem / who / recent.** **ScalableAlphaZero (Ben-Assayag & El-Yaniv, arXiv:2107.08387)** —
GNN-in-AlphaZero trained on **small Othello boards (5–16) beats full AlphaZero on large boards, 10×
faster** — the direct "curriculum across board sizes" artifact, and it uses *this project's other
game*; its weakness is **no exact oracle** (self-play labels). Neural-CO size-generalisation (models
degrade beyond trained size) is a named open problem (RL4CO, KDD 2025).

**Our assets.** *Contribute:* exact n≤18 verdicts + Grundy values = a perfect curriculum oracle
ScalableAlphaZero lacks — turns self-play-noisy into supervised curriculum with ground truth, and
directly tests the #6 prediction (does size-transfer break on the XOR target even *with* perfect
labels?). *Import:* GNN-AlphaZero scaling as a ready vehicle for a size-transfer study on Q_n.

**First experiment / contact.** Train a GNN winner-predictor on exact labels for n≤12, measure
transfer accuracy at n=14/16; contrast with self-play. Contact: Nadav Ben-Assayag / Ran El-Yaniv.

---

## 14. Costas arrays / distinct-difference codes / permutation-rank-modulation codes — needs-theory

**Bridge.** The diagonal constraint is a **distinct-difference** constraint. A **Costas array** =
permutation with all n(n−1)/2 difference vectors distinct ⊂ non-attacking-queens solutions (strictly
stronger). **Distinct-difference configurations (DDCs)** generalise Costas + Sidon and are genuine
coding-theory objects (2D anticodes; key-predistribution codes for grid sensor networks — Blackburn,
Etzion, Martin, Paterson, arXiv:0811.3896). Reflecting-queens' reduction (#2) to distinct-sums-and-
differences pairings is a Sidon/B₂-flavoured cousin.

**Open problem / who / recent.** **Costas array existence at orders 32 and 33 is a flagship open
problem** (exhaustive search complete only to n=29); "Universal Costas Matrices" (arXiv:2602.03407,
Feb 2026); Drakakis, "Open problems in Costas arrays." Sidon-set diameter bounds improved by O'Bryant
(2024) on Balogh-Füredi-Roy (2023). Rank-modulation permutation codes (flash memory): ℓ∞ anticode =
permanent of a band matrix (Schwartz-Tamo); non-existence of perfect Kendall-τ permutation codes
(arXiv:2011.01600).

**Our assets.** *Contribute:* the realer transfer is **maximal-partial Costas arrays** (Frank-Dinitz),
a set-packing problem structurally identical to our independence search — recast as independence search
on the Costas conflict graph. A **Maker-Breaker/achievement game building a Costas array appears
unstudied** — an unclaimed direction, not an existing bridge. *Import:* DDC anticode bounds could bound
our maximal-independent-set statistics.

**First experiment / contact.** Recast maximal-partial-Costas enumeration as independence search in our
solver and benchmark vs. Frank-Dinitz. Contact: Konstantinos Drakakis; Jeff Dinitz; Tuvi Etzion /
Maura Paterson (DDC codes).

---

## 15. Spectral & chromatic invariants of Q_n — transfer-ready (torus spectrum) / speculative (proofs)

**Bridge.** Q_n is our exact search object; its spectral and chromatic invariants are independently
open. The **toroidal** Q_n is a **Cayley graph on Z_n×Z_n** (circulant-on-torus) whose spectrum is a
character sum — directly computable in closed form.

**Open problem / who / recent.** Spectral: Cardoso, Costa & Duarte prove least eigenvalue −4 with
multiplicity (n−3)² and **conjecture the complete integer spectrum** (open; arXiv:2012.01992); follow-on
"Spectral Theory of the Toroidal 3D Queen Graph" (arXiv:2604.03842, 2026). Chromatic: **Chvátal's
"colouring the queen graphs"** open problem — χ(Q_n)=n for 11≤n≤25, **first open case n=26 ∈
{26,27,28}** (some sources put the smallest open at n=27); each colour class is a set of mutually
non-attacking queens, so this is a partition-into-independent-sets problem our max-stable-set machinery
touches.

**Our assets.** *Import mostly:* the least-eigenvalue / clique-partition machinery bounds α(Q_n)
(Hoffman/ratio bound) which we know exactly. *Contribute:* the closed-form torus (Cayley) spectrum vs.
our exact α is a clean paper-sized result; our stable-set enumerator can attack small open chromatic
cases.

**First experiment / contact.** Compute the circulant spectrum of the toroidal queen graph (character
sums over Z_n), compare the Hoffman bound to our exact α. Contact: Domingos Cardoso (Aveiro); Vašek
Chvátal (queen colouring).

---

## 16. Queens domination = covering codes (SAT/SDP certificates); the domination game — speculative (our packing solver) / fresh (certificate + game)

**Bridge.** Our game is the **packing** (independent-set) side of Q_n; **queens domination** (min
queens covering the board) is the **covering-code / covering-radius** dual of the *same* graph. (Note:
*independent* domination is banked — the fresh angles here are the certificate approach, the open
complexity class, and the domination *game*.)

**Open problem / who / recent.** Whether γ(Q_n)=⌈n/2⌉ for infinitely many n; the smallest open case is
n=143; **the complexity class of queens domination is still unknown (open whether NP-hard)**. Hot in
2025: semidefinite covering-code lower bounds (Gijswijt lineage, arXiv:2504.01932); "Thresholds of
Queen covers" (arXiv:2508.02545); **"Queen Domination by SAT Solving" (Rostami, arXiv:2508.11945)** —
a certificate-producing SAT attack; Karandikar-Dutta exactly-solvable relaxation (arXiv:2304.06620,
EJC 2024). **Dion Gijswijt appears in both** the covering-SDP line and the strong-complete-mappings
paper (#3) — a person-level bridge across clusters.

**Our assets.** *Contribute:* the D4-symmetry-quotient + TT substrate could power an exact
queens-*domination* verifier, and our certificate program (#4) transfers to the covering side (DRAT/
LRAT for domination-lower-bound UNSAT cores). The genuinely fresh CGT object is the **domination game
on Q_n** — the covering analogue of our Node-Kayles game, small-n nimbers uncomputed. *Import:* the
LP/SDP relaxation as a bounding idea.

**First experiment / contact.** A short note posing the queens **domination game** on Q_n + small-n
nimbers via a lightly modified solver; reproduce known γ(Q_n) as a sanity harness. Contact: **Dion
Gijswijt (TU Delft)** (bridges to #3); Taha Rostami (SAT); Karandikar/Dutta.

---

## 17. Distributed LOCAL MIS: border-vs-bulk round complexity (opposite sign) — speculative / needs-theory

**Bridge.** In LOCAL-model language, our border-defect and mirror-obstruction are statements about
*when local symmetry can be broken*. On a vertex-transitive torus, MIS reduces to periodic colouring;
a boundary injects the asymmetry that forces genuine rounds (Linial Ω(log* n)). **Productive tension:**
for *game value* the border is the hard part; for *distributed symmetry-breaking* the border is the
*helpful* part — a reference to break symmetry against. "Optimal MIS by robots in unoriented grid and
torus" (ICDCN 2026) finds the **torus harder than the grid** precisely because it lacks boundary/corner
reference nodes.

**Open problem / who / recent.** What is the LOCAL round complexity of MIS on Q_n, and does it separate
the toroidal from the bounded board? Recent LOCAL: Ghaffari-Grunau near-optimal network decomposition
(FOCS 2024); "Invitation to Local Algorithms" (Ghaffari, arXiv:2406.19430); round-elimination MIS
lower bounds (Balliu/Brandt/Olivetti, arXiv:2106.02440). (Caveat: MIS *construction* complexity ≠ game
*value* complexity — the bridge is conceptual, about local symmetry breaking, not a reduction.)

**Our assets.** *Contribute:* Q_n as a concrete highly-structured graph where the bulk/border split is
exactly characterised — a candidate for locality lower bounds. *Import:* round-elimination /
torus-periodicity vocabulary for *why* the border is the residual difficulty.

**First experiment / contact.** Pose the MIS-round-complexity-on-Q_n (torus vs. board) question to a
LOCAL theorist — a clean, likely-novel structured instance. Contact: Mohsen Ghaffari; Ronitt Rubinfeld;
Leonid Barenboim.

---

## 18. Online/competitive analysis: adversarial IS building and the independent kissing number ζ(Q_n) — speculative → needs-theory

**Bridge.** Each ply irrevocably extends a partial IS of Q_n to a maximal one; "last to place wins" =
parity of the maximal IS reached under adversarial co-construction. Two framings map in: online-IS
(builder vs. adversarial arrival) and Maker-Breaker/positional (two agents co-building the same set —
the closer analog).

**Open problem / who / recent.** For online IS on geometric/intersection graphs the tight deterministic
competitive ratio is the **independent kissing number ζ** (De, Singh et al., "Online Dominating Set and
Independent Set," arXiv:2111.07812; "Online Algorithms for Geometric Independent Set," arXiv:2604.14677,
2026). **Q_n is a line/geometric intersection graph, so ζ(Q_n) is a well-defined, computable, apparently
unstudied parameter** giving its online-IS ratio. Learning-augmented IS (arXiv:2407.11364, 2024) links
back to #6/#13. (Caveat: max-cardinality objective ≠ win-parity objective.)

**Our assets.** *Contribute:* exact game values give the true optimal-adversary parity on Q_n — ground
truth for greedy/FirstFit competitive ratios; ζ(Q_n) is a concrete new geometric parameter. *Import:*
competitive-ratio machinery could bound how far a greedy (degree-ordered) player is from optimal —
quantifying the "2× move-ordering" law in competitive-analysis terms.

**First experiment / contact.** Compute ζ(Q_n) for n≤10 (max pairwise-non-attacking queens all
attacking a common square) and check whether it correlates with where the solver's tail cost
concentrates (pc 13–21). Contact: Minati De (geometric online IS).

---

## 19. Burnside/Pólya D4 counting and divisibility of Q(n) — low priority

**Bridge.** Our D4-quotient solver implicitly runs Burnside's lemma over the dihedral group of the
square — the same orbit-counting that governs solution enumeration modulo symmetry.

**Open problem / who / recent.** Fresh and small: Nielsen, "The n-queens solution count Q(n) is
divisible by 4" for n≥6 (arXiv:2601.05856, Jan 2026) — a D4-orbit/Burnside argument;
divisibility-by-8 and finer orbit refinements are natural follow-ups. This is about *full-board
solution counts*, not game values, so the overlap with our Grundy assets is thin.

**Our assets.** *Contribute (minor):* our per-D4-class fixed-point counts are exactly the Burnside
orbit data underlying such divisibility results. *Import:* minimal.

**First experiment / contact.** Report per-D4-class fixed-point counts; check the mod-8 refinement of
Nielsen's mod-4 result. Low priority relative to 1–4.

---

## Checked but rejected (surface analogies discarded — so the next pass need not redo them)

- **Tiling / Wang-tile torus-vs-plane hardness** (Berger undecidability; SoCG 2025 "Tiling with three
  polygons undecidable") — the torus-vs-plane sensitivity is real but the *mechanism* is aperiodic
  forcing, not boundary frustration of a pairing strategy; no local-matching object maps to the
  queen constraint.
- **Baxter integrability / Yang-Baxter for the queen vertex model** — infinite-range diagonal coupling
  breaks the local vertex-weight structure integrability needs; kept only as "queens = the interacting
  layer above free-fermion rooks."
- **A bulk thermodynamic phase transition in the queen gas** — the May-2026 paper explicitly finds none
  (non-divergent Cᵥ); don't frame border difficulty as bulk criticality.
- **Extraordinary-log surface universality as our border's class** — a d=3 O(N) critical-boundary
  phenomenon; with no bulk criticality the border is most plausibly a non-critical O(n) defect term.
- **CGT temperature theory = physical temperature** — real machinery (Berlekamp; Siegel et al.) but
  partizan; Non-Attacking Queens is impartial, so it's analogy, not identity.
- **Direct Sprague-Grundy ↔ partition-function equality** — holds for chip-firing/sandpiles (recurrent
  states = spanning trees = q→0 Potts) but is NOT demonstrated for Node-Kayles nimbers; an open crack,
  not an existing result.
- **Chudnovsky-Seymour claw-free real-rootedness applied to Q_n directly** — Q_n contains claws, so the
  theorem does not apply (kept only as the "roots are open" motivation in #10).
- **Cap sets / affine blocking sets** — person overlap (Bishnoi, Gijswijt) but no object map: queens
  forbid 4 line-classes on Z², caps forbid all lines in F₃ⁿ.
- **No-three-in-line checkerboard** (arXiv:2605.09215, 2026) — queens forbid only 4 line classes, not
  all slopes; the general-position *game* (via misère Node-Kayles, Ullas Chandran et al.,
  arXiv:2205.03526) is the tighter bridge and subsumes it.
- **Golomb-ruler / OGR optimality** — distinct-difference but 1-D, not a game; specialised search beats
  our engine, no edge.
- **Gonality / chip-firing invariants of the queen's graph** (arXiv:2312.04686) — a genuine new Q_n
  invariant but orthogonal to game values / our assets.
- **3D / higher-dimensional queens** (arXiv:2406.06260) — live but a different object; our 2D
  game/nimber/border assets don't transfer.
- **Multipermutation / Ulam-metric flash codes; online bipartite matching; PI-GNN graph colouring;
  coevolutionary-EA runtime bounds; quantum combinatorial games; parity-games ETH; poset games** —
  each examined; either a metric/model mismatch or generic PSPACE membership with no object-to-object
  queen bridge.
- **Random-CSP condensation thresholds (Coja-Oghlan) as a quantitative predictor** — our instances are
  structured/deterministic, not random-ensemble; only the frozen-variable/backbone *vocabulary*
  transfers (kept in #8).
- **Maker-Breaker independence game on Q_n** — a natural sibling but *unstudied* (no literature); a
  possible novel proposal, not a live external bridge.

---

## One-paragraph orientation for the next pass

The **highest-leverage, most-defensible new artifacts** are the ones where we hold data a named active
community provably lacks: (1) **G(14..17) as certified A344227 terms** feeding the octal-periodicity /
SG-completeness question (#1, #9); (2) the **"learn the Grundy DP" NAR benchmark** on a natural
non-local XOR target with a size axis (#6); (3) an **exact backbone/frozen hardness map** of queen
completion (#8). The most **conceptually novel** bridges are the ones that formalise our own theories:
**reflecting-queens = mirror-obstruction** (#2, contact Tom Kelly) and **toroidal queens = strong
complete mappings** (#3, contacts Bishnoi/Gijswijt). The most **strategically valuable** is turning the
solver into a **verified certificate** (#4) — it de-risks every claim above and has a ready template
(CQD, QBF strategy validation, DRAT). Two 2026 papers (Liu-Liao-Wang lattice gas; Pavlov CQD) touch our
exact objects minus our layer — those are the least-friction first contacts.
