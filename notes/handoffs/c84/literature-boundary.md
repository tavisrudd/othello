# C84 facet: essential literature and tool boundary

**Lane**: `cap`

**Status:** bounded review through 2026-07-17. This is a toolbox map independent of attack
priority, not a claim that the search is exhaustive.

## Tool map

| Tool family | Literature anchors | Legitimate C84 use | Non-transfer to guard |
|---|---|---|---|
| Impartial-game semantics and certificates | Schaefer; Siegel; Huggan--Huntemann--Stevens (HHS); Bodlaender--Kratsch--Timmer; Kobayashi | Node--Kayles semantics, xor decomposition, hardness calibration, and compression under proved graph structure | General hardness is not a family lower bound; a structural parameter must actually be bounded on `R_y` |
| `PGL_2` subgroup and trace machinery | Dickson/Faber; Macbeath; Fricke--Horowitz trace theory | Classify generated subgroups, exceptional cases, split types, word traces, and conjugacy/character coordinates | A complete orbit coordinate can be near-injective and therefore give no compression or P-certificate |
| `PGL_2/B` permutation representation | finite-field `GL_2` representation theory; Steinberg constituent | Analyze the coloured pre-deletion Schreier operator exactly on functions on `P^1(q)` and control bounded vertex/loop corrections | Spectral information still needs a game-semantic bridge and does not survive simplification by assertion |
| Finite-field point counting | Lang--Weil; Chatzidakis--van den Dries--Macintyre (CvdDM); theorem-specific character sums | Count a separately proved constructible/definable certificate locus with uniform complexity | Dimension, mixing, or a trace statistic does not imply Grundy zero; witness counts need projection/fiber control |
| Product growth and expansion in `SL_2/PGL_2` | Helfgott; Bourgain--Gamburd; later uniform-expansion variants | Control word growth or mixing after their generator, field, action, and deletion hypotheses are verified | Cayley expansion does not automatically pass to this varying Schreier action or its dead-vertex induced graph, and never implies P by itself |
| Random regular/permutation graph models | Friedman and the random-lift/permutation-model literature | Supply a null heuristic or a comparison target for spectra and local statistics | C84's projective involutions, fixed points, rooted-S4 conditioning, and deleted vertices are correlated rather than independent random matchings |
| Random game DAGs/trees | Eric Friedman; James B. Martin | Adjacent probabilistic Sprague--Grundy ideas | These randomize the option graph of positions, not the Node--Kayles board graph, so their value laws do not transfer directly |
| Ledger/potential accounting | Sprague--Grundy disjoint sums plus project-specific C63/C77 invariants | Prove a checked descent or amortized contract in a state space that retains the required reservoir/frame | Hall, potential, or xor language alone is not a P-certificate; C84's conic-only state lacks the native grid ledger |

## 1. Game-semantic and certificate sources

HHS place the cap rules in the Nofil/impartial-hypergraph-avoidance genus, identify the residual
graph game with Node--Kayles, and supply the general hardness warning. Use the existing
[Nofil relationship note](../../2026-07-07-nofil-connection.md) and
[novelty audit](../../2026-07-08-codex-projective-nofil-novelty-audit.md).

Schaefer's PSPACE-completeness result says generic Node--Kayles has no reason to admit a compact
strategy description. Bodlaender--Kratsch--Timmer and Kobayashi show that exact solution becomes
tractable under particular graph structure or bounded structural parameters. Brown et al. show how
proved recurrences and decompositions yield nimber sequences for specific graph families. These
are the right precedents for certificate compression, but none says that the C84 Schreier family
has the required parameter or recurrence.

- [Node--Kayles certificate dossier](../../expert-personas/schaefer-siegel-nodekayles-certificates.md)
- [Schaefer, *On the Complexity of Some Two-Person Perfect-Information Games*](https://doi.org/10.1016/0022-0000(78)90045-4)
- [Siegel, *Combinatorial Game Theory*](https://bookstore.ams.org/gsm-146)
- [Bodlaender--Kratsch--Timmer, *Kayles and Nimbers*](https://doi.org/10.1006/jagm.2002.1215)
- [Kobayashi, *On Structural Parameterizations of Node Kayles*](https://arxiv.org/abs/2003.11775)
- [Brown et al., *Nimber Sequences of Node-Kayles Games*](https://cs.uwaterloo.ca/journals/JIS/VOL23/Wong/wong24.html)

## 2. Group, trace, and character-variety sources

Dickson's finite-subgroup classification is the background for the dihedral/polyhedral/large
`PSL/PGL` catalogue; Faber is a modern reference for the p-irregular part in positive
characteristic.
Macbeath's generator/trace methods and Fricke--Horowitz trace-polynomial theory are the natural
references for recognizing subgroups and expressing word/conjugacy data in rank two.

- [Faber, *Finite p-Irregular Subgroups of PGL(2,k)*](https://arxiv.org/abs/1112.1999)
- [Macbeath, *Generators of the linear fractional groups*](https://bookstore.ams.org/pspum-12)
- [Horowitz, *Characters of Free Groups Represented in the Two-Dimensional Special Linear Group*](https://doi.org/10.1002/cpa.3160250602)

These tools justify and organize the Schreier catalogue. They do not turn Fricke coordinates into
a bounded quotient: the exact C84 coordinates measured so far are near-injective on generic
fibers. Split type, subgroup type, orbit structure, and trace words remain useful theorem inputs,
but a value theorem must be supplied separately.

There is also a sharper spectral starting point than treating `R_y` as an arbitrary regular graph.
The coloured pre-deletion adjacency operator is a sum of the four involution permutation operators
on `C[P^1(q)]`. For the 2-transitive `PGL_2` action, this permutation module is the constants plus
the Steinberg constituent. Finite-field `GL_2` representation theory can therefore replace a
generic adjacency-matrix calculation. Passing to the actual residual still requires explicit
control of loop removal, coincident colours, and deletion of the bounded dead set; interlacing or
finite-rank perturbation is a tool for that passage, not permission to ignore it.

- [Piatetski-Shapiro, *Complex Representations of GL(2,K) for Finite Fields K*](https://bookstore.ams.org/conm-16/)

## 3. Finite-field counting sources

For a constructible geometrically irreducible component over the base field, Lang--Weil gives the
leading rational-point count. CvdDM gives uniform asymptotic alternatives for fibers of a fixed
first-order formula over finite fields. Thus CvdDM is the right umbrella when a bounded certificate
event contains quantified witnesses; Lang--Weil is often the sharper direct route after explicit
elimination and component analysis.

- [Lang--Weil, *Number of Points of Varieties in Finite Fields*](https://doi.org/10.2307/2372655)
- [Chatzidakis--van den Dries--Macintyre, *Definable Sets over Finite Fields*](https://doi.org/10.1515/crll.1992.427.107)

For either route, the C84 proof must retain uniform formula/degree complexity, a base-field
top-dimensional component, exceptional-characteristic control, and a bound on witness fibers when
projecting to raw centres. Weil/Deligne-type character-sum estimates are potentially important
only after an explicit sum or trace function is written down; cite the theorem matching that sum,
not a generic appeal to cancellation.

## 4. Expansion and probabilistic graph sources

Helfgott's product-growth theorem and Bourgain--Gamburd's expansion theorem are the central
`SL_2(F_p)` tools if a candidate needs word growth or mixing. Their hypotheses matter: fixed
integral generators or specified random-generator models, generation/Zariski density, prime versus
prime-power fields, Cayley versus Schreier action, and the effect of deleting `D(S)` all require
separate verification for C84.

- [Helfgott, *Growth and generation in SL2(Z/pZ)*](https://arxiv.org/abs/math/0509024)
- [Bourgain--Gamburd, *Uniform expansion bounds for Cayley graphs of SL2(Fp)*](https://annals.math.princeton.edu/2008/167-2/p07)
- [Friedman, *A Proof of Alon's Second Eigenvalue Conjecture and Related Problems*](https://arxiv.org/abs/cs/0405020)

Friedman's random-regular theorem is a benchmark for an independent permutation/matching model,
not a theorem about the algebraic fourth-centre family. Any comparison would itself need a
contiguity, moment, or equidistribution theorem strong enough for the statistic being transferred.

## 5. Probabilistic Sprague--Grundy model separation

Eric Friedman's generic impartial games randomize the **option DAG of game positions**. Martin's
random game-trees use Galton--Watson option trees. C84 instead varies a **board graph** `R_y` and
then takes the recursively defined Node--Kayles game DAG of that board. Stationary value laws in
the first two models do not transfer to P-density in C84 without a new comparison theorem.

- [Friedman, *Values of generic impartial combinatorial games*](https://library.slmath.org/books/Book71/files/GONC6-12.pdf)
- [Martin, *Extended Sprague--Grundy theory ... and applications to random game-trees*](https://arxiv.org/abs/2107.08428)

The bounded search found no direct theorem on Node--Kayles P-density for random board graphs,
algebraic graph families, or Schreier graphs. Record that as **no direct source located**, not as a
nonexistence claim.

## 6. Ledger and odd-q boundary

The literature-level import behind a ledger is the Sprague--Grundy xor rule for genuine disjoint
components. The reservoir, defect, intruder, and frame measures are project-specific invariants,
not consequences of general CGT or positional-game potential methods. In particular, Maker--Breaker
potential arguments, Hall matchings, and random-graph expansion do not transport a ledger unless
they prove the exact descent/response contract in the same state space. See the
[ledger boundary](ledger-boundary.md).

C84 supplies a possible abundance input to the odd-q program. Exchange to `(ON)`, bad-set bounds,
and complete-arc/sealing tools belong to the parent odd-q proof, not to the C84 abundance theorem;
their logical interface is recorded in [odd-q position](odd-q-position.md). Their literature should
remain in the parent handoff rather than being silently treated as C84 machinery.

## 7. Novelty and use guard

The defensible C84 structural contribution is the conic-to-Schreier correspondence together with
the subgroup-type value catalogue. Small-subgroup classification, path/cycle Grundy calculations,
and congruence periodicity are classical ingredients or known-plus-known bookkeeping. Do not sell
the abundance conjecture as a consequence of random-game or expansion literature, and do not sell
the catalogue as a P-density theorem.

When a candidate invokes a tool above, record four items: the exact theorem, which model it is
about, how its hypotheses are verified for the raw fourth-centre family, and what independent
game-semantic implication converts the counted event into `G(R_y)=0`.
