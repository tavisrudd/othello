# C1110: cold referee report on the continuation-graph first draft

**Date:** 2026-09-07. **Lane:** continuation.

**Reviewed artifact:** `~/src/math-papers/continuation-graph-rigidity/continuation_graph_rigidity.tex`, all 837 source lines, and the public verification code. Parent identifies the reviewed export as commit `da8db37068c8cb7797fc9ff4134c1ebf64316099`; export provenance was checked by the parent, not independently established in this report. Source-line references below refer to that snapshot; semantic theorem labels are the stable references.

**Recommendation:** revise before submission, with a favorable mathematical assessment. I found no defect in the stable-range semilinear-rigidity proof, extension corollary, recognition theorem, or finite census after checking their arguments and replaying the public checks. Two definite local errors require correction: the unqualified general intersection representation at one selected point, and the attribution of an open-moduli-space automorphism theorem to a source on the compactification. Neither invalidates the main theorem. The paper is a credible specialist research note, subject to those repairs and a separately completed novelty/priority assessment. This review does not certify novelty or identify actual preemption.

**Literature depth:** zero external sources read in full; two primary sources read partially, with access/version/hash records below. No predecessor search or forward-citation census was performed. This is a mathematical referee report with two targeted citation checks, not a new priority audit.

## Severity-ranked findings

### R1 — Required mathematical correction: the intersection/code representation needs a cardinality hypothesis

**Location:** `prop:intersection`, lines 204–220, and the injective-code claim at lines 223–230; general setup begins at line 179 without excluding one-point arcs.

For a one-point arc K={t}, all q legal points on a given tangent have the same set S_x={ell}. Thus x↦S_x and the displayed code map are not injective. With the usual simple-hypergraph convention, retaining the distinct singleton hyperedges gives q+1 isolated vertices in its line graph, whereas G_K is (q+1)K_q. For example, the Fano plane gives three singleton hyperedges versus the graph 3K_2. Allowing repeated hyperedges would fix that particular line-graph interpretation but still would not make the code map injective, and the manuscript does not specify such a convention. If empty arcs are admitted, those also need exclusion.

**Repair:** impose k≥2 on the intersection representation and its code paragraph, and state that x,y are distinct in the intersection formula. Explain injectivity by intersecting the two distinct lines through x and two chosen centres. The existing one-point proposition can remain separately stated. This change does not affect any frame result.

### R2 — Required citation correction: open versus compactified moduli space

**Location:** introduction, lines 139–144; bibliography item `BrunoMella`, lines 806–811.

The manuscript attributes Aut(M_{0,n})=S_n to Bruno–Mella. The cited preprint explicitly treats the **compactification** over the complex numbers: its Theorem 3 states Aut(overline M_{0,n})=S_n for n≥5. The overbar and domain restriction matter; the unqualified equation also fails at n=4, where M_{0,4} is the thrice-punctured projective line and its automorphism group is S_3. The finite graph is built from the open rational-point locus. A compactification theorem does not, without an extension argument, identify the automorphisms of that open locus.

**Repair:** state the actual compactified theorem, with n≥5 and its ground-field context, as a comparison; or supply a primary source proving the intended open-space statement with the needed hypotheses. The point that an algebraic automorphism theorem does not automatically constrain arbitrary graph-preserving permutations of finite rational points remains sound. This is an attribution defect, not evidence that the main theorem is preempted.

### R3 — Recommended trust-boundary clarification: shared exact-cover code

**Location:** computational proof, lines 657–672, and appendix lines 748–750; `verification/README.md` states the boundary more precisely.

The two replay routes use different graph and clique constructions and different full-group algorithms, but **share** `frame_model.census` and `exact_covers`. The README acknowledges this. The manuscript's phrase “two complete enumerations” can suggest independence of the whole census algorithm. I inspected the shared recursion and found its completeness argument correct: a deterministic uncovered element must belong to exactly one block in any prescribed completion, branching covers all available such blocks, and nonempty blocks strictly reduce the uncovered set. There is no observed census failure.

**Repair:** add one short manuscript sentence that exact-cover recursion is shared, while field/graph construction, clique enumeration, and full automorphism-order calculations differ. Preserve the present distinction between checked permutation witnesses and the trusted nauty upper bound. A third implementation is not required to repair the wording.

### R4 — Recommended conceptual precision: what the improved clique bound actually uses

**Location:** introduction lines 126–129, comparison lines 152–159, and `lem:clique`, lines 240–265.

The k(k−2)+1 bound uses the k-partite structure of a linear k-uniform hypergraph: an edge has one symbol in each centre class. Its proof does not need the ambient plane once that structure is supplied. The exclusion of two centre labels is exactly the exclusion of two coordinate classes in a linear transversal code. Thus “continuation-specific” is too restrictive as an explanation of the mechanism, although the bound as proved is correct. The later disjointness argument genuinely uses projective-plane incidence.

**Repair:** describe the first improvement as exploiting the centre partition/partite hypergraph structure; optionally state this generality in a short remark. Do not convert this observation into a priority assertion without a separate literature check. The BGMS numerical comparison itself checks out: their Lemma 2.3 has threshold pk²+(p−2)k+2, giving 14 at p=1,k=4, versus 10 here.

### R5 — Minor exposition and quantifier repairs

- `thm:traces`, lines 272–284: the final isomorphism sentence introduces J without explicitly saying its arc size and whether the same recovery hypotheses apply. State that both graphs belong to the indicated range (or fix a common k). The proof establishes the claimed intrinsic construction in that range.
- Introduction, lines 122–128: consecutive paragraphs repeat that no colouring/coordinates/ambient labels are supplied. Merge them so the mechanism arrives faster.
- `lem:isotopy`, lines 450–458: specify that the auxiliary y is chosen in F_q^*. The group domain is inferable, but the proof depends on avoiding zero as well as the listed three elements. No mathematical change is needed.
- Definition of m(k), lines 715–727: use k≥3, or declare a convention for an empty extremal class. For k=2 every clique lies in a tangent trace, so the maximum as worded is over an empty collection.
- The moduli-language paragraph gives no marking convention for the four forgetful maps. A brief choice of markings (0,1,infinity,x,y), with the fibre maps understood up to reparametrization, would make the useful identification independently readable.
- The six-point Clebsch sentence at lines 685–686 reads as context from another project. Unless a cited mathematical comparison makes it relevant, remove it from this standalone draft.

## Mathematical review of the proof chain

I read every proof in the manuscript and checked the following substantive steps.

1. **General representation and geometric recovery.** For k≥2 the intersection representation is correct. In `lem:clique`, for a part C_t and an outside z, distinct neighbours force distinct edge centres, and the centres t and u are indeed excluded. The trace lower bound q−binom(k−1,2) is valid: secants involving the tangent's centre meet it only at that centre; each other secant removes at most one point. In `thm:traces`, a large trace is maximal because a putative enlargement lies in a tangent and two points already determine that tangent. In `thm:centres`, an intersection of tangent lines from distinct centres cannot be on a secant involving either centre; at most binom(k−2,2) remaining secants produce disjoint traces in the other pencil. The mixed-clique bound kc and the tabulated sufficient thresholds are consistent. For k=4 the first inequality gives q≥13 and the second is weaker.
2. **One-, two-, and three-point obstructions.** The one-point clique decomposition and two-point rook graph are correct. The triangle coordinates and multiplicative-group actions are correct. The ambientness proof is sound when pencil traces have at least two points; q=2 is a trivial exception to that particular line-recovery justification (the only multiplicative automorphism is the identity), so the stated triangle conclusion remains correct. Inversion at q=5 is a valid nonambient example.
3. **Frame normal form and extension.** The six excluded secants give exactly Omega={(x,y):x,y∉{0,1},x≠y}. The four fibre parameters and fibre sizes are correct. Recovered classes can be permuted by the unique associated frame projectivity. The isotopy lemma first recovers alpha=beta from the missing diagonal, then multiplicativity of gamma, including its inverse case; the forbidden-set sizes suffice already at q=5. The constant multiplier is forced to one by the missing identity element. Applying the same lemma after x↦1−x gives the shifted multiplicative automorphism. The polynomial argument has degree below q and forces its exponent to a p-power. This supplies existence and uniqueness of the semilinear extension. The action is faithful because every nonzero/nonunit field element appears as a coordinate. Group order 24e follows. No finite computation or external reconstruction theorem is needed for this chain.
4. **Recognition and representation size.** An outside vertex has at most three neighbours in a tangent trace, so four seeds recover it exactly. A mixed disjointness clique has at most four members, so five seeds recover centre classes. The rejection tests may admit intermediate false structures, but the final coordinate isomorphism test ensures soundness. Arbitrary pencil orderings are allowed by the frame's S_4 projectivities. Missing row/column symbols correctly complete the multiplicative division table, including the added identity row and column. Checking the table against exponent subtraction avoids an unproved associativity assumption. One successful abstract generator suffices; trying all primitive field images includes a valid coordinate transport. The claimed O(n^6) operation bound is conservative and valid; it is an arithmetic-operation bound, not a bit-complexity claim for arbitrary field encodings. The degree, edge count, coordinate storage count, and O(n²) certificate check are consistent.
5. **Finite boundary.** For each vertex-cover partition, its blocks contribute disjoint edge sets, so the integer mask sums are legitimate. A vertex belongs to q−4 edges in each partition, while its total degree is 4(q−4); consequently any edge exact cover by these partitions contains exactly four partitions. This bridges the exact-cover implementation to the definition of a four-pencil resolution. The group-witness closure and edge-set tests prove the lower bound; nauty supplies the trusted full-group order. The isotopy lemmas prove that the geometric-resolution stabilizer is exactly ambient, and the computed orbit of size two yields the exceptional coset statement. At q=7,9,11 the unique resolution forces ambientness. The stable and computational ranges are clearly separated.
6. **Residual complex and scope.** The stated minimal nonfaces of Delta_K are correct: any forbidden collinear triple either contains a selected centre, producing an incompatible pair, or lies on a line disjoint from K. The discussion appropriately declines to claim a stronger general reconstruction theorem or a game-value consequence. The vague complement-embedding sentence is not a premise of any theorem reviewed here.

## Public verification actually run

Read the verification README, Makefile, field/graph model, exact-cover implementation, Sage generator, independent replay, recognizer, and recognition controls. Executed from the standalone root:

```sh
PYTHONDONTWRITEBYTECODE=1 /home/tavis/.claude/bin/run-quiet 'nix develop --command make check'
```

Exit status 0. Source/evidence/hash checks and mutation controls passed. Independent replay reported:

| q | full automorphism order | resolutions |
|---|---:|---:|
| 5 | 48 | 2 |
| 7 | 24 | 1 |
| 8 | 144 | 2 |
| 9 | 48 | 1 |
| 11 | 24 | 1 |
| 13 | 24 | 1 |

Recognition and certificate mutation, relabelling, edge deletion, and degree-preserving switch controls passed at q=13,17,19. Saved runner log: `/tmp/claude-run-quiet/20260907-145402-nix-develop-command-make-check/stdout.log`. The durable evidence is the existing public source/certificate package; this log is only the record of this referee's replay. I did not regenerate with Sage, rerun benchmarks, build the PDF, run Lean, or inspect visual PDF layout. The parent owns separate export/publication checks. In particular, this report does not independently re-establish the claimed historical Sage 10.7/10.9 replays.

The finite-field reference code supports the primes and orders 8,9; the manuscript correctly distinguishes that implementation limit from the mathematical theorem over any supplied finite field. Returning no implemented result for other extension fields is not a negative mathematical recognition result.

## Literature checks and novelty scope

Targeted source queries were exactly `https://arxiv.org/abs/1006.0987` and `https://arxiv.org/abs/2104.14863`, followed by their corresponding PDF endpoints after cache misses. No search result set was screened and no absence claim is made.

- **Bruno–Mella, arXiv:1006.0987v1. Read depth: partial.** Read the introduction through Theorem 3 and the opening ground-field convention of Section 1, from the cached PDF text; checked the arXiv abstract for the compactification and n≥5 hypotheses. This is the 2010 preprint, not an independent reading of the published version. Cache key `arXiv:1006.0987`; SHA-256 `69efe587cf9f65d153b93cd8e85e1a48fd9c172028a2b69ed580f1ec1970d2a0`. Primary link: https://arxiv.org/abs/1006.0987. R2 concerns the mismatch with the source actually checked.
- **Bhattacharya–Godinho–Majumder–Singhi, arXiv:2104.14863v1. Read depth: partial.** Read Lemmas 2.3–2.4 and their proofs, PDF page 3, from the cached extraction. Cache key `arXiv:2104.14863`; SHA-256 `192b23ba8ab7153a70a241cd3b7bd4145db7ee60e05df817779611291e5ac75b`. Primary link: https://arxiv.org/abs/2104.14863. The threshold comparison is supported; I did not audit the whole reconstruction theorem or its priority.

Other bibliography entries were not independently read for this report. The differences of vertex count or algebraic category described in an introduction do not alone prove that no existing reconstruction theorem implies the result. A qualified novelty account still requires the owning literature audit. No result found in this review preempts the paper, but that sentence records the limited scope of this review, not a searched-and-cleared priority verdict.

## Strengths, publishability, and closeout

The strongest feature is the short, self-contained bridge from an uncoloured finite graph to a semilinear action: large cliques recover the combinatorial data, and the compatibility of multiplication and translation forces the field. The punctured isotopy lemmas are especially effective. The recognizer converts the proof into a concrete coordinate witness without factorial alphabet search. The finite boundary is small, exact, replayable, and honestly separated from the uniform proof. The paper avoids unsupported performance claims.

For a specialist reader, the result and its proof mechanism are easy to find. The finite census earns its place by showing that the uniform q≥13 bound is a proof threshold and locating the two genuine exceptional orders. After R1–R2 and the short trust clarification, I would regard the mathematics as ready for a qualified external subject referee. I would not recommend unconditional acceptance or a priority claim from this review alone.

**Explicit ej+tt closeout / Mystery ledger:** the post-review pass asked which proof input is genuinely geometric and which computed phenomenon still lacks explanation. It settled that the first clique bound is a partite-linear-hypergraph argument (R4); the centre recovery uses the plane. The q=7 coexistence of 1352 candidate partitions with a unique resolution and the q=8 pair of disjoint-block resolutions remain conceptually unexplained by the uniform proof. Their truth is checked by the census; their missing computation-free explanations are exactly `prob:boundary-proof`, not correctness gaps. No additional mystery was manufactured, and no manuscript or public-package edit was made.

**Integration:** this report is intentionally uncommitted; the parent owns its review/integration commit. No prior task reports or author proof explanations were read. The lane handoff was read only for routing, and the parent supplied provenance and later corroboration of R1 after the independent first pass.

Vibe check: the main mathematics holds up; the required repairs are local, with novelty clearance still separate.

`go continuation`
