# 2026-08-07 — C880 work item 6: literature audit of the aligned-design query-complexity claims

**Task:** C880 (lane `clebsch`), work item 6 of
`notes/clebsch-tasks/c880-aligned-query-complexity.md`. Audits the results in
`notes/2026-08-07-c880-alignment-separation.md`. Research and reading only; no
manuscript, Lean, or build tooling touched.

**Governing conventions:** `notes/literature-audit-conventions.md`.

**Status:** complete for the bodies of work named in work item 6, with the access
gaps below carried forward.

---

## Opening summary

**Two literature sources in this report were read at full text**: Holtz and
Sturmfels' preprint on hyperdeterminantal relations among symmetric principal
minors, read this round, and Pouzet, Si Kaddour and Trotignon's reconstruction
note, whose full-text record is **inherited** from C876 and was not re-read here.
Eight further sources were read by me at `partial` — Rising, Kulesza and Taskar;
Brunel and Urschel; Brunel (2018); Urschel and coauthors (2017); Aravind and
coauthors (2026); Angluin and Chen's hypergraph paper; Greaves and Suda's
\(t\)-design paper; and Duncan and Kileel — with Brouwer and Van Maldeghem
inherited at `partial` from C876. Four sources are at `secondary only` — Griffin
and Tsatsomeros; Grebinski and Kucherov; the Alon–Beigel–Kasif–Rudich–Sudakov
line; and the second Greaves–Suda paper — and the rest are at
`abstract/metadata only`. The per-source records are authoritative and the
coverage statement separates what I searched from what I inherited.

**Nothing pre-empts the complexity results, but two of the six claims must change
how they are stated, and one should become a citation.**

The serious finding is in the principal-minor assignment literature. That
literature solves the *same* reconstruction problem up to the *same* gauge:
principal minors are invariant under diagonal \(\pm1\) similarity, which for a
Seidel matrix is exactly Seidel switching, and Oeding's theorem — as reported by
Rising, Kulesza and Taskar — says two such matrices have the same principal
minors precisely when their \(3\times3\) minors agree, i.e. precisely when they
have the same two-graph. Against a *value* oracle the reconstruction is already
solved in \(O(n^2)\) queries by two published algorithms (Rising–Kulesza–Taskar
2015; Brunel–Urschel 2024), and Rising, Kulesza and Taskar already call their
count asymptotically optimal. For a Seidel matrix specifically, the textbook
cycle-basis route needs only \(\binom n2-n+1\) principal minors of order three —
the counting lower bound, achieved, and a factor of six below the exhibited
\(3n^2-23n+45\).

None of this pre-empts anything, because the alignment decoder is given neither
minor values nor order-three data: it receives one bit per four-set, the
indicator that a \(4\times4\) minor equals \(-3\). No source in any of the five
bodies reconstructs from an indicator family of fixed-order minors. But the
consequence for the manuscript is concrete: a sentence claiming \(O(n^2)\)
selected determinants as an achievement, without naming the restriction to
order-four indicators, would read as pre-empted by this literature.

The second wording change is the entropy bound. Subadditivity of entropy over
biased binary tests is the standard information-theoretic bound of combinatorial
search theory; the content here is the measured marginal, that every alignment
test answers yes with probability exactly one quarter, and the constant 1.2326
that follows. It should be presented as an application, not a method.

The third is claim F, the identification of the determinant-\((-3)\) family. That
the \(4\times4\) principal minors of a symmetric Seidel matrix take exactly the
two values \(\{-3,5\}\), and that the \(-3\) fibre is the \(3\)-design, is
explicit in Greaves and Suda's Table 1 and Example 2.3. Only the last step — that
this fibre is the aligned family of the two-graph — is unlocated, and it is
elementary. Make it a citation.

The sharp point threshold (claim B), the sensitivity/non-bipartite-link rule
(claim D(iii)) and the exact small-case values (claim E) have no located
predecessor. B's negative is inherited from the earlier audits rather than
freshly earned; D(iii)'s is bounded by a body I did not search at all, Boolean
sensitivity and certificate complexity.

## The setting being audited

A two-graph on \(n\) points is a map \(\tau\) from 3-subsets to \(\mathbf F_2\)
whose sum over the four triples of any 4-subset is even; equivalently a
switching class of graphs. A 4-subset is **aligned** when its four triples carry
equal \(\tau\); the **alignment test** on a 4-subset returns that one bit. For a
Seidel matrix (symmetric, zero diagonal, entries \(\pm1\)) a 4-subset is aligned
exactly when its \(4\times4\) principal minor equals \(-3\).

**The reconstruction problem.** Determine the two-graph, up to one global
complement bit, from the answers to a chosen family of alignment tests. The
decoder receives *only the indicator* of which \(4\times4\) principal minors
equal \(-3\) — not the value of any minor, not the pairwise Seidel signs.

## Claims needing a verdict

| Tag | Claim |
|-----|-------|
| A | Faithfulness: for \(\lvert V\rvert\ge7\) the aligned family determines the two-graph up to complement. |
| B | Sharp point threshold: seven is sharp; six points collide (46 groups, 96 of 512 complement pairs, only 6 with empty aligned family). |
| C | Query upper bound: the at-least-two-points-of-a-fixed-anchor family has \(3n^2-23n+45\) members and suffices; separates unconditionally; its one redundant member at \(n=7\) is the anchor's own test; six-per-outside-pair is forced within the single-anchor shape at \(n=7,8\). |
| D | Query lower bounds: (i) counting \(n(n-3)/2\); (ii) NEW entropy/subadditivity \(\ge(\binom{n-1}2-1)/H(1/4)\approx0.616n^2\); (iii) NEW sensitivity rule / non-bipartite link graphs. |
| E | Exact small cases: minimum is 30 of 35 at \(n=7\), 56 optimal families in two orbits; \(25\le\min(8)\le44\) against exhibited 53. |
| F | Determinant-family identification: the \(\det=-3\) family of a Seidel matrix is exactly the aligned family of its two-graph. |

## Verdicts

| Tag | Verdict | Deciding sources and read depth |
|-----|---------|---------------------------------|
| A | **SETTLED BY INHERITANCE — not re-litigated.** NOT PRE-EMPTED as a two-graph statement; mechanism textbook and uncited; independent of the graph theorem. | `notes/2026-08-05-c876-two-graph-literature-audit.md` §§A.1–A.4 and `notes/2026-08-05-c878-aligned-faithfulness-independence.md`, both read at `full text` (project documents, not literature). Bounded by the two Seidel surveys, `could not access`. |
| B | **NO PREDECESSOR LOCATED for the coarser observable, and the neighbouring sharpness is about a different parameter.** Dammak–Lopez–Pouzet–Si Kaddour's \(v\ge7\) is the endpoint of the range \(4\le k\le v-3\), and their own sharpness remark is about \(k\), not \(v\); they exhibit no six-point failure. Our six-point collision is a proved failure for a strictly coarser observable, so it is a genuinely different statement — but it must be positioned against theirs explicitly, not presented as an empty neighbourhood. | Pouzet–Si Kaddour–Trotignon §1, `full text` **inherited** from C876 (SHA-256 `a0d71732a15b440d4658dd08eddce29cc544ccde32a5b753911ef9635cf8a39b`); Dammak–Lopez–Pouzet–Si Kaddour at `secondary only` through it. Five new empty queries this round (§5). |
| C | **NOT PRE-EMPTED, but the positioning must change.** No source reconstructs from an indicator family of fixed-order minors. However, quadratic query complexity for principal-minor reconstruction up to the *same* gauge is already published and already called asymptotically optimal — Rising–Kulesza–Taskar and Brunel–Urschel — at \(O(n^2)\) queries against a *value* oracle, and for a Seidel matrix the standard cycle-basis route costs only \(\binom n2-n+1\) order-three minors. Any sentence claiming \(O(n^2)\) selected determinants as a contribution must name the order-four indicator restriction, or it reads as pre-empted. | Rising–Kulesza–Taskar `partial`; Brunel–Urschel `partial` (upgraded from abstract-only); Brunel 2018 `partial`; Holtz–Sturmfels `full text`. |
| D(i) | **KNOWN TECHNIQUE, correctly attributed already.** The counting bound is the ordinary leaf-count/decision-tree bound; no citation problem. | Standard; Angluin–Chen use the same argument (`partial`). |
| D(ii) | **TECHNIQUE PRE-EMPTED, APPLICATION NOT LOCATED.** Entropy subadditivity over binary tests with a biased answer marginal is the textbook information-theoretic bound of combinatorial search theory. What was not located is the marginal computation — that every alignment test answers yes with probability exactly \(1/4\) — or the resulting constant \(1.2326\). Present it as an application of the standard bound whose content is the marginal, not as a new method. **This is the one wording in the cluster that would be exposed if stated as a new technique.** | Body 4 search record; the canonical search-theory sources (Rényi, Katona, Aigner) are `could not access`, so this verdict rests on database screening plus the technique being elementary. |
| D(iii) | **NO PREDECESSOR LOCATED.** The sensitivity rule — the test on \(\{p,q,x,y\}\) detects the flip of \(\{x,y\}\) exactly when \(\tau(pxy)=\tau(qxy)\), hence every link graph \(H_{xy}\) must be non-bipartite — has no located counterpart. No query model with a conjunctive-\(\mathbf F_2\) query was located at all, which is the same reason. **Weakest-supported of the positive verdicts:** the natural adjacent literature is Boolean sensitivity/certificate complexity, which is recorded NOT COVERED. | Body 2 and body 4 search records; Angluin–Chen `partial`. |
| E | **NO PREDECESSOR LOCATED, and no literature was found that would bear on it.** Exact minimum separating-family sizes for this test system at \(n=7,8\) are an exhaustive computation over an object nobody else has defined; the pre-emption risk here is close to zero once C and D are settled. | Follows from B, C and D; no source in any body computes with the aligned family. |
| F | **PARTLY PRE-EMPTED — make it a citation, not a theorem.** That the \(4\times4\) principal minors of a symmetric Seidel matrix take exactly two values \(\{-3,5\}\), and that the \(-3\) fibre is the design, is explicit in Greaves and Suda: Table 1 and Example 2.3, which names \(H_S(4n+2,4,-3)\) as a \(3\text-(4n+2,4,n-1)\) design and opens by observing \(\lvert D_S(k)\rvert=2\) for \(k\in\{3,4\}\). The residual, unlocated step is the identification of that fibre with the *aligned family of the two-graph* (all four triples equal), which is elementary. Separately, that the \(3\times3\) minors are two-valued \(\{-2,2\}\) and determine the whole principal-minor vector up to the switching gauge is Oeding's theorem as reported by Rising–Kulesza–Taskar. | Greaves–Suda arXiv `2402.17528` `partial` (cached, SHA-256 `230c4c…`); Rising–Kulesza–Taskar `partial`; Holtz–Sturmfels `full text`. |

## Bodies of work

### 1. The principal-minor assignment problem

This is the closest literature and the one that changes what Paper III should
say. The headline is that the principal-minor assignment problem (PMA) is the
*same reconstruction problem up to the same gauge*, and its standard solution
already achieves a query count equal to the dimension of the two-graph space —
but consuming **order-three minor values**, which the alignment decoder is not
given.

#### 1.1 Holtz and Sturmfels, *Hyperdeterminantal relations among symmetric principal minors*

- Identifier: arXiv `math/0604374` v2, 16 January 2007; published *Journal of
  Algebra* 316 (2007) 634–648 (published version NOT read; verdicts below are
  about the preprint).
- **Read depth: `full text`** of the preprint — the whole 15-page note:
  Introduction and Remark 1, §2 (Matrix Theory and Probability), Theorem 2 and
  Lemma 5, Theorem 6 (the first converse), §4 (the prime ideal for
  \(4\times4\) matrices, Theorem 8 and the twenty quartics), §5 (condensation)
  and §6 (the quartic-generation conjecture).
- Access: fetched from `https://arxiv.org/pdf/math/0604374`; SHA-256
  `5b427b01748a535ee68db137899862cda75a4d491b765b4cac45355abee6780a`, 178,183
  bytes, extracted with poppler `pdftotext`.
- **What data it consumes.** All \(2^n\) principal minors, **as values**: "The
  principal minors of a real symmetric \(n\times n\)-matrix form a vector of
  length \(2^n\)… our aim is to determine the image of the principal minor map".
  The paper is about the *image* of that map, i.e. which vectors of values are
  realizable, not about reconstructing from a sparse subfamily.
- **The gauge is the same as ours.** In the proof of Theorem 6: "the principal
  minors of \(A\) do not change under diagonal similarity \(A\mapsto DAD^{-1}\)
  where each diagonal entry of the matrix \(D\) is \(\pm1\)". For a Seidel
  matrix that is exactly Seidel switching, so the PMA identifiability class is
  the switching class. **This is MY identification, marked as mine** — the paper
  does not mention Seidel matrices, two-graphs, or switching anywhere in the
  text I read.
- **Which orders of minor do the reconstruction.** Introduction: "the entries of
  the symmetric matrix \(A=(a_{ij})\) are determined up to sign by their
  principal minors of size \(1\times1\) and \(2\times2\), in view of the relation
  \(a_{ij}^2=A_iA_j-A_{ij}A_\emptyset\)". Theorem 6 then fixes the signs from
  minors of order \(\le3\): "we can fix all first row entries \(a_{1j}\) with
  \(j>1\) to be positive. Then the sign of each entry \(a_{2j}\) with \(j>2\) is
  determined unambiguously by the values \(A_{12j}\), the sign of each entry
  \(a_{3j}\) with \(j>3\) is determined by the values \(A_{13j}\), and so on."
  So **orders one, two and three suffice**, under the strict non-degeneracy
  hypothesis (12), \(A_{I\cap J}A_{I\cup J}<A_IA_J\) whenever
  \(\#I\cap J=\#I-1=\#J-1\).
- **Order four enters only as relations, never as the decoder's input.** §4
  computes the prime ideal \(P_4\) — twenty quartics — characterising which
  \(16\)-vectors are the principal-minor vector of a symmetric \(4\times4\)
  matrix. That is a *consistency* statement about values, not a reconstruction
  from indicators.
- **Verdict contribution.** Holtz–Sturmfels does not pre-empt C, D or E. It
  consumes exponentially more data (all \(2^n\) values) than the alignment
  decoder and asks a different question (realizability). It *is* the right
  citation for the observation that the identifiability class of principal
  minors is diagonal \(\pm1\) similarity, i.e. the switching class — which is
  the conceptual content behind claim F's "up to complement".

#### 1.2 Rising, Kulesza and Taskar, *An efficient algorithm for the symmetric principal minor assignment problem*

- Identifier: *Linear Algebra and its Applications* 473 (2015) 126–144, DOI
  `10.1016/j.laa.2014.04.019`. The copy read is the authors' preprint version
  dated 6 November 2014 ("Preprint submitted to Elsevier"); the published
  version was NOT read and the verdicts here are about the preprint.
- **Read depth: `partial`** — read the Abstract, §1 (Introduction, including the
  complexity claims), the worked \(3\times3\) example, §3.3's closing
  discussion of Oeding's theorem and Corollary 3.15, and §3.4 (canonicalization)
  plus the running-time analysis at the end of §5. The detailed proofs of §§3–5
  and Appendix A were not read.
- Access: fetched from `https://www.alexkulesza.com/pubs/spmap_laa14.pdf`;
  SHA-256 `a53c0ba140ab0ddeac8395679ffcb28f4bdd6e10ad343872bde26a95ed051b37`,
  360,155 bytes, poppler extraction.
- **The oracle model is explicit and it is a value oracle.** "we are given an
  oracle that produces any requested principal minor of a symmetric matrix
  \(H\) in constant time, and we are asked to compute \(H\)."
- **There is already a Θ(n²) query-complexity statement in this literature.**
  Verbatim: "It requires \(O(n^2)\) queries to the principal minor oracle; since
  \(\Omega(n^2)\) oracle queries are required to determine the magnitudes of the
  off-diagonal elements, this is asymptotically optimal." Their \(\Omega(n^2)\)
  is the trivial degrees-of-freedom bound (one query per unknown magnitude), not
  an entropy argument, and it does not apply to the Seidel case where the
  magnitudes are known a priori to be one.
- **They also record the cost of the Oeding route:** "Oeding (2011) also
  observed that this characterization can in principle be used to solve the
  assignment problem by considering all principal minors of order at most three…
  It also requires \(O(n^3)\) queries to the principal minor oracle."
- **The identifiability statement is the switching class.** §3.3: "for any
  determinantally compatible \(H\) and \(K\) with no zeros off the diagonal, we
  have that \(H\equiv K\) [determinantally] if and only if all the corresponding
  \(3\times3\) principal minors are equal", attributed in the same paragraph to
  Oeding (2011) in the general form; and Corollary 3.15: "For any fixed \(H\),
  \(\lvert\{K:H\equiv K\}\rvert=2^{n-\mathrm{comp}(H)}\)". **MY specialization,
  marked as mine:** a Seidel matrix has no zeros off the diagonal and its
  sparsity graph \(K_n\) is connected, so its determinantal-equivalence class has
  size \(2^{n-1}\) and is determined by the \(3\times3\) minors — i.e. it is
  exactly the Seidel switching class, and the complete invariant is the
  two-graph. Neither Oeding nor Rising–Kulesza–Taskar says "two-graph",
  "switching" or "Seidel" anywhere in the text I read.
- **Verdict contribution.** Pre-empts nothing in C, D or E, because the oracle
  differs. It is, however, the correct citation for "the principal-minor data of
  a Seidel matrix is equivalent to its two-graph" (claim F's underlying fact,
  reached from the other side), and it is the baseline any complexity sentence
  in Paper III must be positioned against.

#### 1.3 Griffin and Tsatsomeros, *Principal minors, Part II: the principal minor assignment problem*

- Identifier: *Linear Algebra and its Applications* 419 (2006), DOI
  `10.1016/j.laa.2006.04.009` (bibliographic detail from the OpenAlex and
  Crossref records retrieved 2026-08-07; volume/pages not independently
  verified).
- **Read depth: `secondary only`** — characterised through
  Rising–Kulesza–Taskar §1 (read at `partial`, above) and Holtz–Sturmfels §2
  (read at `full text`). **COULD NOT ACCESS the paper itself**: three retrieval
  attempts — the author's Washington State University file area
  (`math.wsu.edu/faculty/tsat/files/…`, HTTP 403), ScienceDirect
  (`S0024379506002230`, HTTP 403), and CORE search (HTTP 403 Cloudflare).
- What the secondaries say: Rising–Kulesza–Taskar, "Griffin and Tsatsomeros
  (2006b) proposed an algorithm which is guaranteed to work if the matrix to be
  reconstructed is off-diagonal full. Among other conditions, this requires that
  no off-diagonal entry be equal to zero. Furthermore, their algorithm has a
  running time of \(O(n^5)\) and involves multiple matrix inversions". They add
  that verifying oracle consistency "requires generating every principal minor
  of the matrix, which inherently requires exponential time (but no more; see
  Griffin and Tsatsomeros (2006a))". Holtz–Sturmfels: "Very recently, Griffin
  and Tsatsomeros gave an algorithmic solution to this problem… under a certain
  'genericity' condition, either outputs a solution matrix or determines that
  none exists."
- **Neither secondary reports a query count for it**, only a running time, so
  this audit carries no statement about how many minors it consumes. That is a
  gap, and it is an access gap rather than a search gap.

#### 1.4 Brunel and Urschel, *Recovering a Magnitude-Symmetric Matrix from its Principal Minors* — upgraded from abstract-only

The prior record in `notes/2026-08-02-paper-iii-deep-priority-search.md` had this
at `abstract/metadata only`. It is upgraded here.

- Identifier: arXiv `2404.06302` v2, 6 September 2024. No published version was
  located; OpenAlex work `W4394709574`.
- **Read depth: `partial`, substantially upgraded** — read the Abstract, §1
  (Introduction) in full including §1.1 "Our contributions" and §1.2 notation,
  the opening of §2 (what orders one and two give), the statement and first
  paragraph of the proof of Theorem 1, and the full statement and proof opening
  of Theorem 2, plus the statement of Theorem 3. The combinatorial body (§3),
  the algorithm's internals (§5.1–5.2) and Appendix A were not read.
- Access: fetched from `https://arxiv.org/pdf/2404.06302`; SHA-256
  `29ca1ae69a3a9ea956093c1d37d2b9898c8a011322c9ba00f0efce766e6a6f1a`, 384,738
  bytes, poppler extraction.
- **Query count as a function of \(n\).** Theorem 2: the algorithm "runs in time
  polynomial in \(N\) and queries at most \(O(N^2)\) principal minors, all of
  order at most \(3\varphi_G\), where \(G\) is the sparsity graph of \(K\)". So
  \(\Theta(n^2)\) queries, matching Rising–Kulesza–Taskar.
- **What each query returns: a numerical minor value**, not an indicator. The
  algorithm's first move is \(K_{i,i}=\Delta_i\),
  \(\lvert K_{i,j}\rvert=\sqrt{\lvert\Delta_i\Delta_j-\Delta_{i,j}\rvert}\) and
  \(\epsilon_{i,j}=\mathrm{sgn}(\Delta_i\Delta_j-\Delta_{i,j})\) — arithmetic on
  values. Theorem 3 relaxes this to *approximate* values (as estimated from DPP
  samples), which is still numerical data, not a level-set indicator.
- **Which orders of minor are consumed.** Bounded by the graph invariant they
  call *simple cycle sparsity* \(\ell^+\), the least edge-length such that
  positive simple cycles of that length span the positive cycle space. Theorem 1:
  minors of order \(\le\ell^+\) determine minors of all orders, and this is
  tight. **MY specialization, marked as mine:** a Seidel matrix is symmetric, so
  every charge \(\epsilon_{i,j}=\mathrm{sgn}(K_{i,j}K_{j,i})=+1\) and every cycle
  is positive; its sparsity graph is \(K_n\), whose cycle space is spanned by
  triangles; hence \(\ell^+=3\) and their theorem specialises to "principal
  minors of order at most three determine all principal minors of a Seidel
  matrix" — the same conclusion as Oeding's, reached by the cycle route.
- **Is any level-set or indicator-only variant treated? NO.** Searched the full
  extraction for `indicator`, `level set`, `sign pattern only`, `two-valued`,
  `Seidel`, `switching`, `two-graph`: no occurrence. The only relaxation of
  exact values they consider is additive numerical error (Theorem 3).
- **Is a lower bound proved? Yes, but on the ORDER of minors, not their number.**
  Theorem 2, second bullet: "there exists a matrix \(\tilde K\in\mathcal K\)…
  such that any algorithm that computes a matrix with principal minors
  \((\Delta_S(\tilde K))\) must query a principal minor of order at least
  \(\varphi_G\)." There is no lower bound on the query *count* beyond the
  degrees-of-freedom one, and no entropy argument anywhere in the sections read.
- **Verdict contribution.** This is the closest state-of-the-art baseline for
  claims C and D and it does **not** pre-empt either. It shares the quadratic
  query count and the identifiability gauge, and differs on the two axes that
  matter: values versus one indicator bit, and unbounded order versus order
  exactly four. Its lower bound is about minor order, so claim D(ii) has no
  counterpart here.

#### 1.5 Brunel, *Learning Signed Determinantal Point Processes through the Principal Minor Assignment Problem*

- Identifier: arXiv `1811.00465` v1, 1 November 2018.
- **Read depth: `partial`** — read §1 (Introduction), §2.5–2.6 (identifiability
  and the statement of PMA), §3.1 (PMA for symmetric matrices: Facts 1–3 and
  the cycle-basis algorithm) and §3.2 with Definitions 3–5; skimmed the
  algorithm statements at the end (the steps quoted below) and the
  sample-complexity discussion. Sections 4–5 and the supplement were not read.
- Access: fetched from `https://arxiv.org/pdf/1811.00465`; SHA-256
  `669aeed48765d64ffa94548a373cfbb46c91d29446f32472c598b191a5482321`, 548,807
  bytes, poppler extraction.
- **This is the source that states the query-count question in our own terms.**
  Verbatim: "the goal is no longer to estimate \(K\) exactly, but one possible
  kernel that would give rise to the same DPP… The idea is based on the fact
  that only few principal minors of \(K\) are necessary in order to completely
  recover \(K\) up to identifiability… **Given an available list of prescribed
  principal minors, how to recover a matrix \(K\in\mathcal T\) whose principal
  minors are given by that list, using as few queries from that list as
  possible?**" So "query count for principal-minor reconstruction" is an
  explicitly posed question in this literature, and the answer given there is
  the cycle-basis one.
- **The standard symmetric algorithm and its count.** Fact 1: orders one and two
  give the diagonal and the magnitudes. Fact 2: they give the adjacency graph.
  Fact 3 plus the cycle-basis argument: "every undirected graph has a cycle
  basis made of induced cycles… for each cycle \(C\) in that basis, query the
  corresponding principal minor of \(K\) in order to learn \(\pi_K(C)\).
  Finally, in order to determine the signs of the off diagonal entries of \(K\),
  find a sign assignment that matches with the signs of the \(\pi_K(C)\)…
  Finding such a sign assignment consists of solving a linear system in GF2."
- **MY computation, marked as mine, and this is the load-bearing one.** A Seidel
  matrix has all off-diagonal entries \(\pm1\), so its adjacency graph is
  \(K_n\); a cycle basis of induced cycles of \(K_n\) consists of triangles and
  has size \(\binom n2-n+1\); the order-three principal minor of a Seidel matrix
  on \(\{i,j,k\}\) equals \(2s_{ij}s_{ik}s_{jk}\), i.e. it *is* the two-graph
  value \(\tau(ijk)\) up to the encoding \(+2\mapsto0,\,-2\mapsto1\). Therefore
  the textbook symmetric-PMA algorithm reconstructs the Seidel matrix up to
  switching from exactly \(\binom n2-n+1\) principal minors of order three, and
  the GF(2) linear system it solves is the descendant correspondence. That is
  the counting lower bound \(\binom n2-n\) up to one, achieved.
- **Why this does not pre-empt claim C.** The alignment decoder is given neither
  the order-three minors nor any minor *value*: it receives one bit per
  four-set, the indicator \([\det=-3]\), which is the conjunction
  \(\tau(abc)=\tau(abd)=\tau(acd)\). A single order-three query would reveal
  \(\tau\) on a triple outright; the alignment test never does. The two settings
  are genuinely far apart in input, and the reading above establishes that by
  reading rather than by assertion.
- **But it does change the paper's positioning, and this is a finding the lane
  must act on.** Any complexity sentence in Paper III must say which oracle it
  is counting against, because with order-three minors the same reconstruction
  costs \(\binom n2-n+1\) queries by a published algorithm, a factor of six
  below the exhibited \(3n^2-23n+45\). Claiming \(O(n^2)\) selected determinants
  as an achievement without naming the restriction to order-four indicators
  would be read as pre-empted by this literature.

### 1.6 The rest of body 1, screened

Screened set: the OpenAlex citing-works list of Rising–Kulesza–Taskar
(`W2142623632`), size 16, retrieved 2026-08-07, screened over title.
Discriminator, applied mechanically: *does the title indicate reconstruction
from a restricted or non-numerical class of principal-minor data (an indicator,
a level set, a fixed order), rather than from numerical minors of unrestricted
order?* **Zero passed.** The set is: determinantal representations and the image
of the principal minor map (2024); characterizing principal minors via
determinantal multiaffine polynomials (2023); statistical applications of DPPs
(2017); DPPs for image processing (2021); skew-symmetric matrices and their
principal minors (2015); symmetrization of principal minors and cycle-sums
(2016); recovering a magnitude-symmetric matrix from its principal minors
(2024, promoted at §1.4); characterizing and testing principal minor equivalence
of matrices (2025); adaptive estimating function inference for nonstationary
DPPs (2019); principal minor assignment, isometries of Hilbert spaces… (2019);
learning DPPs with moments and cycles (2017, promoted below); Markov DPP for
dynamic random sets (2025); on matrices in finite free position (2025); partial
observability of implied volatility matrices (2025); on the fibers of the
principal minor map and an application to stable polynomials (2025); learning
read-once determinants and the PMA problem (2026). All at `abstract/metadata
only` (OpenAlex title records) except the three promoted.

Three members were promoted and read further:

- **Urschel et al., *Learning Determinantal Point Processes with Moments and
  Cycles* (2017).** **Read depth: `partial`** — read the abstract, §1 and the
  definition of cycle sparsity. Access: fetched from
  `https://math.mit.edu/~urschel/publications/p2017c.pdf`; SHA-256
  `8a193cf1e97831f440a32c1e002326d4e8e8a8c5d738e4f154b60f9564d23f05`. It
  introduces cycle sparsity \(\ell\) — "the minimal \(\ell\) for which \(G\)
  admits a cycle basis of induced cycles of length at most \(\ell\)" — and shows
  it "governs the number of moments that need to be considered and, thus, the
  sample complexity", with a matching lower bound (their Theorem 2). This is the
  sample-complexity reading of the same quantity. For a Seidel matrix \(\ell=3\).
  Again: values (estimated moments), not indicators.
- **Al Ahmadieh, *The Fiber of the Principal Minor Map* (arXiv `2309.00806` v2,
  8 September 2023).** **Read depth: `abstract/metadata only` plus the opening
  of §1** — access: fetched from `https://arxiv.org/pdf/2309.00806`, SHA-256
  `2b3f517b0f9a67b499a9cb3c757f5c4016a551fca9a8b22fbd02e6eb7b365501`. Gives a
  necessary and sufficient condition for the fibre of the principal minor map to
  be a single diagonal-equivalence class, and "fully characterize[s] the fiber of
  symmetric and Hermitian matrices". Confirms the gauge; carries no query count.
- **Aravind, Chatterjee, Ghosh, Gurjar, Raj and Saha, *Learning Read-Once
  Determinants and the Principal Minor Assignment Problem* (arXiv `2603.04255`
  v1, 4 March 2026; also STOC 2026, DOI `10.1145/3798129.3800875`).** **Read
  depth: `partial`** — read the abstract and the contribution list, and searched
  the extraction for the query-model language. Access: fetched from
  `https://arxiv.org/pdf/2603.04255`; SHA-256
  `6d6dbc08bc283f7469e622f347c4f2e9c7d41312a9d171822a793934756a4ab6`. Their
  Theorem 1.3 is "Sufficiency of PME up to order 4": principal-minor equality up
  to order four suffices to certify determinantal equivalence for matrices with
  their property R. **This is the only place in body 1 where order four is the
  distinguished order**, and it is still about *equality of values*, and it is a
  certification statement rather than a reconstruction from a sparse indicator
  family. It does not pre-empt C, D or E. It is worth citing as the point where
  order four becomes the natural cut-off in the PMA literature too, which makes
  Paper III's order-four restriction look less arbitrary than it otherwise
  would.

### 2. Learning a hidden graph from queries

**Nothing in this body pre-empts claim D, and the reason is that no model in it
has a query that is a conjunction of linear conditions over \(\mathbf F_2\), and
none has a gauge-invariant target.** The negative below is stated with its
searched domain.

#### 2.1 Angluin and Chen, *Learning a Hidden Hypergraph*

- Identifier: *Journal of Machine Learning Research* 7 (2006) 2215–2236,
  submitted 12/05, revised 8/06.
- **Read depth: `partial`** — read the Abstract, §1 (Introduction and related
  work) in full, Definition 1, and the statements framing §6 (Lower Bounds For
  Almost Uniform Hypergraphs). The algorithms of §§3–5 and the proofs were not
  read.
- Access: fetched from `https://www.jmlr.org/papers/volume7/angluin06a/angluin06a.pdf`;
  SHA-256 `59a79b8171d3f7490a5f4ce1b4ac02f9250beb84bce401dc3d5f058cb1160bca`,
  poppler extraction.
- **The query model.** "the learner may query whether a set of vertices induces
  an edge of the hidden hypergraph or not". §1 states the equivalence that
  settles the comparison: "[the] problem may also be viewed as the problem of
  learning a monotone disjunctive normal form (DNF)… An \(r\)-uniform hypergraph
  corresponds to a monotone \(r\)-DNF." So an **edge-detecting query is a
  monotone DISJUNCTION** of edge indicators. **An alignment test is a
  CONJUNCTION of two \(\mathbf F_2\)-linear conditions and is not monotone in any
  ordering of the two-graph**; the two models are not special cases of one
  another. That is MY comparison, marked as mine.
- **Their lower bounds are of a different shape.** The information-theoretic
  bound they use is the ordinary counting bound ("This is nearly optimal as we
  can easily show using an information-theoretic argument"), and their
  interesting bound, \(\Omega((2m/r)^{r/2})\) from Angluin and Chen (2004), comes
  from hiding a large edge behind small ones — a phenomenon with no counterpart
  when the target is a linear space. **No entropy-subadditivity bound with a
  biased answer distribution appears in the text I read**, and no
  sensitivity/link-graph criterion.
- Their targets are sparse hypergraphs parameterised by the number of edges
  \(m\); our target is the whole \(\mathbf F_2\)-space of two-graphs, of which
  the "sparse" regime is not the interesting one.

#### 2.2 Grebinski and Kucherov, the additive model

- Identifier: "Optimal Reconstruction of Graphs under the Additive Model",
  *Algorithmica* 28 (2000), DOI `10.1007/s004530010033`; conference version
  ESA '97, DOI `10.1007/3-540-63397-9_19`. Bibliographic detail from OpenAlex
  and Crossref records retrieved 2026-08-07.
- **Read depth: `secondary only`** — characterised through Angluin and Chen's
  JMLR §1, read at `partial` above: "Grebinski and Kucherov (2000) also study a
  somewhat different and interesting query model, which they call the additive
  model, where instead of giving a 1 or 0 answer, a query tells you the total
  number of edges contained in a certain vertex set." **The paper itself was NOT
  obtained** (ResearchGate HTTP 403; no open copy located).
- **Why it brackets us from the wrong side, and this is the useful positioning
  point.** An additive query returns a count, i.e. \(\Theta(\log n)\) bits, which
  is exactly why that literature reaches \(\Theta(n^2/\log n)\). An alignment
  test returns one bit, so no \(n^2/\log n\) phenomenon is available here and the
  counting bound is genuinely \(\Omega(n^2)\). Paper III should say this
  explicitly rather than leave a reader to wonder whether the log-factor saving
  applies. MY inference, marked as mine.
- The Alon–Beigel–Kasif–Rudich–Sudakov line ("Learning a hidden matching") is
  cited in the same paragraph and in Angluin–Chen's bibliography; **read depth
  `secondary only`, via Angluin–Chen's reference list and related-work
  paragraph**. Its target class is matchings, a sparse structure, and its query
  is again edge-detecting.

#### 2.3 The searched domain for this body's negative

OpenAlex `title_and_abstract.search`, run 2026-08-07, with counts:

```
"hidden graph" AND "edge-detecting queries"                     -> 4
"learning a hidden graph"                                       -> 8
"additive model" AND "reconstruction of graphs" AND queries     -> 2
"switching class" AND queries AND learning                      -> 0
"conjunction of linear" AND queries AND "lower bound" AND reconstruction -> 0
```

The first three sets were screened over title, discriminator *does the title
indicate a query returning a conjunction of algebraic conditions, or a target
defined only up to a group action?* Zero passed. The fourth and fifth returned
empty (OpenAlex empty is HTTP 200 with `meta.count = 0`; errors raise in the
client, so empty and error are distinguishable in this client's own output).

**Negative, with domain and stop condition:** across those five OpenAlex query
sets and the two full/partial reads above, **no query-learning model was located
whose query is a conjunction of \(\mathbf F_2\)-linear conditions, and none whose
target is a switching class or other gauge-equivalence class.** Stop condition:
the union of the five result sets was exhausted at title depth and the two
canonical sources were read. This is a discovery-strength negative, not a
database closure — no MSC or venue-complete screen was attempted.

### 3. Quartet-based reconstruction

**Verdict: the analogy is formal only, and the report should say so in one
sentence rather than lean on it.**

- The phylogenetic quartet oracle returns one of three resolved topologies (or
  an unresolved answer), so it delivers \(\log_2 3\) bits, not one; and its
  target — a binary tree on \(n\) taxa — has \(\Theta(n\log n)\) bits of entropy,
  not \(\Theta(n^2)\). The classical fact in that field is that a binary tree is
  *defined* by \(n-3\) quartets, a linear count. A field whose optimum is linear
  in \(n\) cannot bracket a problem whose optimum is quadratic. MY comparison,
  marked as mine, drawn from the general shape of the field rather than from a
  single read source — and marked as such, because I did not obtain a source
  stating the \(n-3\) fact at full text this round.
- **The "uninformative quartet" notion does have a real counterpart** in the
  alignment setting: our "no" answer distinguishes three cases without saying
  which, and a two-graph pair with empty aligned family is invisible to every
  test. But that counterpart is an analogy, not a transferable lemma, because
  the quartet uninformativeness comes from an unresolved tree node while ours
  comes from a proper two-colouring of a link graph.
- **Searched domain.** OpenAlex, 2026-08-07:
  `"quartet queries" OR "quartet oracle"` → 2 (both the same 2026 preprint,
  *Testing Full Quartet Consistency: Adaptive Reconstruction, Random
  Verification, and Constant-Query…*, `abstract/metadata only`, OpenAlex record,
  screened out because its object is a tree and its oracle is a topology);
  `"quartet" AND "phylogenetic tree" AND "query complexity"` → 0;
  `"quartet" AND "minimum number" AND "phylogenetic"` → 6, screened over title,
  zero passed the discriminator *does this concern query complexity for a
  non-tree target?*. zbMATH `quartet method phylogenetic reconstruction number
  of quartets needed` → HTTP 404 / empty. **Negative:** no quartet-query lower
  bound was located that applies to a target which is not a tree. Stop
  condition: the four query sets above were exhausted at title depth.

### 4. Separating systems and combinatorial search

**Verdict on the specific question asked — "is there a sharper counting bound in
the literature for tests that are conjunctions of linear conditions?" — NO
SHARPER BOUND LOCATED, and separately, the technique behind claim D(ii) is
textbook rather than new.**

- The bound in claim D(ii) is subadditivity of Shannon entropy applied to a
  family of binary tests with a known answer marginal:
  \(H(\tau)\le\sum_i H(A_i)=k\,H(1/4)\). That is the standard
  information-theoretic bound of combinatorial search theory, refined only by
  the observation that the answer bit is biased. **I state plainly that the
  technique is not new; what is new here is the computation that every alignment
  test has answer marginal exactly \(1/4\) under the uniform distribution on
  two-graphs, and hence the constant 1.2326.** Paper III should present it that
  way — as an application of the standard bound, with the marginal as the
  content — rather than as a new bounding method. Presenting it as a new
  technique is the one wording in this cluster that would be exposed.
- **Searched domain.** OpenAlex 2026-08-07:
  `"combinatorial search" AND entropy AND "lower bound" AND "biased"` → 0;
  `"separating system" AND entropy AND "lower bound"` → 3, screened over title,
  zero relevant (two copies of a 2026 learned-index preprint and a 2019 quantum
  thesis); `"separating system" AND "minimum size" AND family AND set` → 1
  (*Extremal problems and designs on finite sets*, 1999, `abstract/metadata
  only`, OpenAlex record, screened out as a general extremal-set-theory work);
  `"combinatorial search" AND "Renyi" AND "Katona"` → 0;
  `"non-bipartite" AND "separating family" AND queries` → 0. zbMATH:
  `Renyi separating systems combinatorial search minimum number of tests` →
  HTTP 404 / empty; `Katona combinatorial search problems survey separating
  families` → HTTP 404 / empty.
- **COULD NOT ACCESS:** Rényi's and Katona's original search-theory papers and
  Katona's survey were not obtained; Aigner's *Combinatorial Search* was not
  obtained. The negative above therefore rests on database screening, not on
  having read the canonical sources, and it must be carried forward as such.
  This is the weakest negative in this report.
- **The non-bipartite-link criterion of claim D(iii)** has no located counterpart
  under the terms searched. It is a *sensitivity* condition — every elementary
  perturbation must be detected at every point of the space — and its content is
  that the detecting set for a pair must contain an odd cycle. The natural
  literature for that shape would be sensitivity/certificate complexity of
  Boolean functions, which was not searched this round and is recorded as NOT
  COVERED.

### 5. Two-graphs and switching classes

Most of this body is inherited and is not re-litigated here.

- **Inherited, full strength.** `notes/2026-08-05-c876-two-graph-literature-audit.md`
  §§A.1–A.4 already returns the verdict on claim A: NOT PRE-EMPTED as a
  statement about two-graphs, with the mechanism (the two-graph definition and
  the descendant correspondence) textbook and uncited, from Brouwer and Van
  Maldeghem, *Strongly Regular Graphs*, §1.1.12, read there at `partial`
  (author-hosted preprint, SHA-256
  `fa73d72e86bbd8dc3fbfcbca45679cb8f2671d777e91c009eeff0a563fd9289d`). That
  audit's negative is explicitly bounded by two sources it could not obtain —
  Seidel's 1976 survey and the 1981 Seidel–Taylor second survey — and **that
  bound is inherited by every negative in the present report too**, because
  those two surveys are exactly where a competing statement about the aligned
  family would sit. I made no new attempt on them this round.
- **Inherited.** `notes/2026-08-05-c878-aligned-faithfulness-independence.md`
  settles that the aligned-faithfulness theorem is independent of the
  Dammak–Lopez–Pouzet–Si Kaddour graph result, with an explicit separating
  witness. Not re-derived.
- **Greaves and Suda decide claim F**, and they decide more of it than the prior
  audits recorded. Two different Greaves–Suda papers are in play and the earlier
  records name different ones; both are listed here so the confusion does not
  propagate.
  - *Constructions of \(t\)-designs from weighing matrices and association
    schemes*, arXiv `2402.17528` (v2, 13 April 2026). **Read depth: `partial`**
    — this round I read §2.3's Seidel-matrix subsection, Tables 1 and 2, and
    Example 2.3 with Table 3, in the cached text extraction. Access: shared cache
    key `arXiv:2402.17528`, SHA-256
    `230c4cb862cd51f0d51f20af91c56f2e7453f2e2472114bda6c42b3a5af99e32`.
    **Load-bearing quotation.** Table 1 gives, for a symmetric Seidel matrix,
    \(D_S(3)=\{-2,2\}\) and \(D_S(4)=\{-3,5\}\); Example 2.3 opens "From Table 1,
    we have \(\lvert D_S(k)\rvert=2\) for \(k\in\{3,4\}\)" and concludes that
    \(H_S(4n+2,4,5)\) is a \(3\text-(4n+2,4,3n)\) design and
    \(H_S(4n+2,4,-3)\) is a \(3\text-(4n+2,4,n-1)\) design.
  - *Symmetric and skew-symmetric \(\{0,\pm1\}\)-matrices with large
    determinants*, arXiv `1601.02769`, DOI `10.1002/JCD.21567`. **Read depth:
    `secondary only`, inherited** from `notes/2026-08-02-paper-iii-deep-priority-search.md`
    (itself inheriting the C729 audit, which read arXiv v3 §4, Theorems 4.3 and
    4.5 at `partial`; shared cache key `arXiv:1601.02769`, SHA-256
    `40cde5eff1bbd514c2952cb6ab36ad130116f7432ce6fb250cadb9c1eec093cf`). I did
    not open it this round. Per the inherited record it characterises conference
    matrices from prescribed spectra of *large* principal submatrices and does
    not treat the four-set determinant pattern.
- **What is left for claim B's positioning, which the coordinator asked for
  explicitly.** Dammak, Lopez, Pouzet and Si Kaddour's sharpness remark, as
  quoted in Pouzet–Si Kaddour–Trotignon §1 (read at `full text` by C876, SHA-256
  `a0d71732a15b440d4658dd08eddce29cc544ccde32a5b753911ef9635cf8a39b`), is: "It
  is immediate to see that if the conclusion of the problem above is positive
  for some \(k,v\), then \(v\) is distinct from 3 and 4 and, with a little bit
  of thought, that if \(v\ge5\) then \(k\ge4\)." **Their sharpness is about
  \(k\), the local size; ours is about \(v\), the number of points.** Their
  positive range \(4\le k\le v-3\) makes \(v\ge7\) the *first* \(v\) at which
  \(k=4\) is admissible, so their \(v\ge7\) is a range endpoint, not a proved
  failure at \(v=6\); they exhibit no six-point counterexample for the
  four-local graph observable. **Their sharpness argument therefore does not
  transfer to the coarser observable**, in either direction: a failure for the
  richer graph observable would imply failure for ours, but they prove no such
  failure, and a failure for ours implies nothing about theirs. MY analysis,
  marked as mine, resting on the quoted sentence and on the inherited C878
  independence verdict.
- **Has anyone stated the coarser version?** Not located. Searched domain this
  round, OpenAlex 2026-08-07:
  `"switching class" AND queries AND learning` → 0;
  `"principal minors" AND "indicator" AND reconstruction AND sign` → 0;
  `"principal minors" AND "level set" AND matrix AND recover` → 0. zbMATH:
  `reconstruct two-graph switching class coherent four-subsets query complexity`
  → HTTP 404 / empty; `principal minors indicator which minors equal recover
  matrix sign pattern` → HTTP 404 / empty; `switching class of graphs
  reconstruction number of queries` → 1 record, a STOC 2012 proceedings volume,
  screened out at title. **This adds five new empty queries to the twenty-four
  inherited from C876 and the fifteen from the deep priority search; it does not
  independently establish the negative, which remains an inherited one.**

### Adjacent check: Z₂ synchronization and higher-order measurements

**One-paragraph verdict.** Group synchronization is the same gauge problem — for
\(\mathbf Z/2\) the unknown is a vertex signing and the classical observable is
the pairwise ratio, which is exactly the switching gauge of a Seidel matrix —
but the deployed methods all consume pairwise measurements, and the one paper
located that goes beyond pairwise consumes higher-order *group ratios*, not a
coherence indicator. That paper is Duncan and Kileel, *Higher-Order Group
Synchronization*, arXiv `2505.21932` v2, 4 June 2025, published in *Research in
the Mathematical Sciences* (2026), DOI `10.1007/s40687-026-00627-w`. **Read
depth: `partial`** — read the abstract, §1 (Introduction) and the problem
definition around the vertex-potential map \(\rho:V\to G\) and hyperedge
measurements; the message-passing algorithm, the convergence analysis and the
experiments were not read. Access: fetched from
`https://arxiv.org/pdf/2505.21932`; SHA-256
`c4430c80e7732aa934a568f7fadda92d901c1e5aafa62b717a4bbd6041993503`. They "seek
to recover group elements \(\{g_i\}\) from triples or \(n\)-wise collections of
relative local information", motivated by multi-focal tensors between camera
quadruples, and their synchronizability conditions are cycle-consistency
conditions. **A hyperedge measurement there is a tuple of group elements; ours is
one bit saying that a 4-set is coherent.** So the adjacent field has arrived at
higher-order observations but not at indicator-only ones, and no query count in
our sense is proved there. Searched domain, OpenAlex 2026-08-07:
`"synchronization" AND "Z2" AND "higher-order"` → 0;
`"group synchronization" AND "higher order" AND measurements` → 1, the paper
above. **Negative:** no \(\mathbf Z_2\)-synchronization deployment observing only
higher-order coherence indicators was located; stop condition, those two query
sets exhausted.

### Adjacent check: signed networks and structural balance

**One-paragraph verdict.** Balance theory does read the coherence of small vertex
sets — a triangle is balanced when the product of its three edge signs is
positive, which is exactly \(\tau(ijk)=0\) — so the *triangle* level of our
object is standard vocabulary there. What is not standard is inference driven by
four-set coherence counts: the two works located under the higher-order and
four-cycle terms both count balanced cycles as a *statistic of an observed signed
graph*, not as an oracle replacing the edge signs. They are: *Proper network
randomization is key to assessing social balance*, *Science Advances* (2024), DOI
`10.1126/sciadv.adj0104`; and *Inference for Balance in Dynamic Signed Networks*,
arXiv `2606.08786` (2026). **Read depth for both: `abstract/metadata only`**,
OpenAlex records retrieved 2026-08-07; neither obtained. In every signed-network
setting located the edge signs are the data, which is precisely the case work
item 8 of the task card identifies as making the query count a curiosity.
Searched domain, OpenAlex 2026-08-07:
`"signed network" AND "balance" AND "four" AND cycles` → 1;
`"structural balance" AND "higher-order" AND inference` → 2. **Negative:** no
signed-network inference procedure was located whose primitive observation is a
four-set coherence bit rather than an edge sign; stop condition, those two query
sets exhausted at abstract depth.

## Forward-citation counts

All counts retrieved **2026-08-07**, each service queried independently, recorded
separately rather than aggregated. Seeds are pinned by DOI or arXiv identifier,
never resolved by title at query time.

| Seed (pinned identifier) | OpenAlex | Crossref | Semantic Scholar |
|---|---|---|---|
| Holtz & Sturmfels, `10.1016/j.jalgebra.2007.01.039` (OpenAlex `W2043984109`) | 69 | 51 | 84 |
| Griffin & Tsatsomeros, `10.1016/j.laa.2006.04.009` (OpenAlex `W2141982996`) | 48 | 32 | 58 |
| Rising, Kulesza & Taskar, `10.1016/j.laa.2014.04.019` (OpenAlex `W2142623632`) | 16 | 14 | 23 |
| Brunel & Urschel, arXiv `2404.06302` (OpenAlex `W4394709574`, DOI `10.48550/arXiv.2404.06302`) | 0 | HTTP 404 (unresolved seed) | 4 |
| Greaves & Suda, arXiv `2402.17528` (OpenAlex `W4392271278`, DOI `10.48550/arXiv.2402.17528`) | 0 | HTTP 404 (unresolved seed) | 1 |
| Grebinski & Kucherov, `10.1007/s004530010033` | 87 | 52 | 104 |
| Angluin & Chen, `10.1016/j.jcss.2007.06.006` | 49 | 35 | 61 |

**How empty was distinguished from error, per service.** OpenAlex: empty is HTTP
200 with `meta.count = 0` and errors raise in the client, which prints
`OPENALEX ERROR` with the status. Crossref: a resolvable DOI returns HTTP 200
with `is-referenced-by-count`; the two arXiv DataCite DOIs returned HTTP 404,
which is an **unresolved seed, not a zero**, and is recorded as such. Semantic
Scholar: HTTP 200 with `citationCount`; HTTP 429 was returned repeatedly for the
Brunel–Urschel seed and the count of 4 was only obtained on the third attempt
after a delay — an early give-up here would have produced a spurious gap.
zbMATH: empty is HTTP 404, and the client prints the status explicitly rather
than relying on shell control flow (this is the failure mode logged as an
incidental observation in C876).

**Service disagreement is itself a finding.** Semantic Scholar exceeds OpenAlex
on every resolvable seed, and Crossref is lowest on every one. The
three-graph gate is **closed** for the five DOI-resolvable seeds and **not
closed** for the two arXiv-only seeds, where Crossref supplies no valid count.
The largest citing set among the seeds central to this audit is
Rising–Kulesza–Taskar's; that is the set screened below.

## Screened set

1. **OpenAlex citing-works of Rising–Kulesza–Taskar (`W2142623632`), size 16,
   retrieved 2026-08-07.** Fields screened: title. Discriminator, verbatim:
   *does the title indicate reconstruction from a restricted or non-numerical
   class of principal-minor data — an indicator, a level set, or a fixed order —
   rather than from numerical minors of unrestricted order?* **Zero passed.** The
   full list is given at §1.6; three members were promoted for individual
   discussion on other grounds and carry their own read depths there. The
   remaining thirteen are covered by this set record at `abstract/metadata only`.
2. **OpenAlex `title_and_abstract.search:"principal minor assignment"`, count 15,
   retrieved 2026-08-07.** Fields screened: title, year, DOI. Discriminator:
   *is this a PMA reconstruction result, as opposed to an application or an
   unrelated use of the phrase?* Six passed and are discussed at §§1.1–1.6; the
   remainder — the skew-symmetric PMA paper (2020, DOI
   `10.1007/978-3-030-53929-0_19`), the isometries/parallelepipeds paper (2019,
   DOI `10.1016/j.laa.2019.06.010`), a 2006 thesis-style item with no DOI, and
   the principal rank characteristic sequence line (2011, DOI
   `10.1016/j.laa.2011.11.013`) — are at `abstract/metadata only`, OpenAlex
   records. **The principal rank characteristic sequence deserves a named
   dismissal** because it is the one item in the set that is genuinely
   indicator-shaped: it records, for each order, whether *some* or *no* principal
   minor of that order is nonzero. That is a per-order aggregate over the whole
   matrix, not a per-4-set bit, and it is a zero/nonzero indicator rather than a
   level-set indicator, so it does not reach our setting. Dismissed on those
   grounds, at `abstract/metadata only`.
3. **zbMATH `principal minor assignment problem`, 8 records returned,
   retrieved 2026-08-07.** Fields screened: title, year. Discriminator as in set
   2. It surfaced one item absent from the OpenAlex sets — *Recovering a
   magnitude-symmetric matrix from its principal minors* (2024) — which is
   promoted to `partial` at §1.4. Also present and dismissed at
   `abstract/metadata only`: *Partial observability of implied volatility
   matrices* (2026), a finance application; and one record whose title zbMATH
   suppresses for licensing reasons (2017), which could not be screened at all
   and is recorded as an unscreened member.
4. **The four small OpenAlex sets of body 2** (`"hidden graph" AND
   "edge-detecting queries"` → 4; `"learning a hidden graph"` → 8;
   `"additive model" AND "reconstruction of graphs" AND queries` → 2;
   `"quartet" AND "minimum number" AND "phylogenetic"` → 6). Fields screened:
   title. Discriminators as stated in §§2.3 and 3. Zero passed in each. All
   members at `abstract/metadata only`, OpenAlex records, except Angluin–Chen's
   hypergraph paper, promoted to `partial`.

## Coverage statement

### Read at full text

**Two literature sources were read at full text this round:**
Holtz and Sturmfels, *Hyperdeterminantal relations among symmetric principal
minors* (arXiv preprint), and — **inherited, not re-read** — Pouzet, Si Kaddour
and Trotignon, *Claw-freeness, 3-homogeneous subsets of a graph and a
reconstruction problem* (arXiv v2), whose full-text record belongs to C876. Every
other literature source is at `partial`, `secondary only`, or
`abstract/metadata only`; the per-source records above are authoritative.

Project documents read at full text, listed separately because they are not
literature: `notes/literature-audit-conventions.md`,
`notes/clebsch-tasks/c880-aligned-query-complexity.md`,
`notes/2026-08-07-c880-alignment-separation.md`,
`notes/2026-08-05-c876-two-graph-literature-audit.md`,
`notes/2026-08-05-c878-aligned-faithfulness-independence.md`,
`notes/2026-08-02-c794-aligned-design-faithfulness-literature-audit.md`,
`notes/2026-08-02-paper-iii-deep-priority-search.md`.

### Newly searched this round, versus inherited

**Newly searched by me (these negatives are mine):** the principal-minor
assignment literature in its entirety — OpenAlex, zbMATH, and the
Rising–Kulesza–Taskar citing set; the hidden-graph and edge-detecting-query
literature; the quartet-query terms; the separating-system and
combinatorial-search terms; the two adjacent checks (\(\mathbf Z_2\)
synchronization, signed-network balance); and the seven-seed three-graph
forward-citation table.

**Inherited, not re-run (these negatives are not mine):** everything about the
two-graph, switching-class, hypomorphy-up-to-complementation and
coloring-from-homogeneous-sets literature. C876 ran twenty-four verbatim queries
across OpenAlex, zbMATH and Semantic Scholar; the deep priority search ran
fifteen web-discovery queries plus three OpenAlex/Crossref top-25 screens; C794
ran nine web queries. **Claim A rests entirely on those inherited searches.**
Claim B rests on them plus five new empty queries of mine, which is not enough to
convert an inherited negative into a fresh one — B's negative is inherited.

### Searched and found nothing (licenses a negative)

- No reconstruction result consuming only *indicators* of principal minors of a
  fixed order was located, across the two OpenAlex PMA sets, the zbMATH PMA set,
  and the Rising–Kulesza–Taskar citing set (§§1.6, screened sets 1–3). Stop
  condition: those four sets exhausted at title depth, with six members promoted
  to partial or full reads.
- No query-learning model whose query is a conjunction of \(\mathbf F_2\)-linear
  conditions, and none whose target is a gauge-equivalence class, across the five
  OpenAlex query sets of §2.3.
- No quartet-query lower bound applying to a non-tree target (§3).
- No sharper counting bound for conjunctive-linear tests in the
  separating-systems terms searched (§4) — **but see the access gap below, which
  materially weakens this one.**
- No \(\mathbf Z_2\)-synchronization deployment observing higher-order coherence
  indicators rather than group ratios, and no signed-network inference driven by
  four-set coherence counts rather than edge signs (adjacent checks).

### Could not access (licenses nothing; carried forward as open gaps)

- **Griffin and Tsatsomeros (2006), the paper itself.** Three attempts, all HTTP
  403. Held at `secondary only`. Consequence: this audit states no query count
  for their algorithm.
- **Rényi, Katona, and Körner–Simonyi on separating systems, and Aigner's
  *Combinatorial Search*.** Not obtained; not even located as retrievable
  records this round. **This is the principal limitation on the body-4 negative
  and hence on the D(ii) verdict**, and it is the gap most worth closing before
  any manuscript sentence claims novelty for the entropy bound.
- **Boolean sensitivity and certificate complexity.** NOT COVERED — not searched
  this round. It is the natural home for a predecessor of D(iii), so D(iii)'s
  negative is bounded by an unsearched body, not merely an unread one.
- **Seidel, *A survey of two-graphs* (1976), and Seidel and Taylor, *Two-graphs,
  a second survey* (1981).** Inherited as could-not-access from C876; no new
  attempt made. Every negative in this report about the two-graph side is
  bounded by them.
- **Grebinski and Kucherov (2000), the paper itself.** ResearchGate HTTP 403; no
  open copy located. Held at `secondary only` via Angluin–Chen.
- **MathSciNet review layer.** NOT COVERED (tested and confirmed unreachable by
  C876; not retested). MR Lookup's bibliographic layer was not needed this round
  because every bibliographic detail asserted here came from a consulted record.
- **Google Scholar.** Blocks automated access; not attempted.
- **zbMATH:** reachable and used, but no exhaustive MSC screen was attempted, so
  it supplies discovery-strength negatives only. One record in the PMA set has
  its title suppressed for licensing reasons and could not be screened.
- **Published versions** of Holtz–Sturmfels (*J. Algebra* 316), of
  Rising–Kulesza–Taskar (*LAA* 473), of Brunel–Urschel (none located), and of
  Duncan–Kileel (*Res. Math. Sci.*): preprints were read in every case, and every
  verdict above is about the preprint.
- **Subject-expert check.** NOT COVERED.

### Consequence for manuscript wording

Every claim in this report keeps "to our knowledge". None supports "first".
Claim F should become a citation to Greaves and Suda rather than a stated
observation. Claim C's wording must name the order-four indicator restriction.
Claim D(ii) must be presented as an application of the standard
information-theoretic bound. Any wording that emerges goes first into the row of
Paper III's claim–proof–novelty ledger that owns it, per
`notes/literature-audit-conventions.md` § "Novelty text has one home"; drafting
that text is work item 7 of C880 and is not done here.
