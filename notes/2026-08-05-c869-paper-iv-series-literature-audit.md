# C869 — literature / novelty / priority audit of the Paper IV series bundles

**Date:** 2026-08-05
**Task:** C869
**Lane:** `clebsch`
**Status:** complete, with two findings retracted — see below before using anything here

> **Retraction, 2026-08-05, by C871
> (`2026-08-05-c871-fold-tower-literature-audit.md`).**
> Two of this report's findings are withdrawn.
>
> 1. The graph is **semisymmetric**, not symmetric. It is `X.182.1` in Conder
>    and Potocnik's semisymmetric census, not `C182.4` in the symmetric one;
>    two distinct cubic bipartite girth-twelve graphs exist at order 182, and
>    this report matched on girth, which the symmetric census already fixes,
>    rather than on transitivity, which was free and discriminating.
> 2. The **counterexample claim is withdrawn entirely.** Crnkovic, Rukavina and
>    Simac make no error: their symmetric-graph paper uses the equivalence
>    correctly, since arc-transitive does imply vertex-transitive, and their
>    2022 follow-up on semisymmetric graphs states explicitly that the transpose
>    gives another code and tabulates both sides with differing distances. The
>    `182D` row matched here belongs to a different graph and the parameter
>    agreement was coincidence.
>
> Our own certified numbers already implied item 1 and should have caught it:
> the two biadjacency kernels are \([91,14,28]\) and \([91,14,26]\), and a
> part-swapping automorphism would force them to be equivalent and so to share
> a minimum distance. The asymmetry between the two sides is real; only the
> claim that it contradicts published work is withdrawn.
>
> Everything else in this report stands, including the no-predecessor verdicts
> on the parity-complement lift, the cross-orbital exhaustion, the higher shell,
> the support-XOR identities, and the colour-lift theorem.

Audited bundles (all dated 2026-08-04, all in `notes/`):

- `2026-08-04-c682-paper-iv-orbit-correspondence.md` (the large one; audited as separate items)
- `2026-08-04-c682-paper-iv-clebsch-connection.md`
- `2026-08-04-paper-iv-column-extension-obstruction.md`
- `2026-08-04-paper-iv-higher-shell.md`
- `2026-08-04-paper-iv-project-up-optimality.md`
- `2026-08-04-c682-e6-e8-code-ladder.md` and `2026-08-04-c682-e7-bitangent-extension.md`
  (predecessors of the ladder already audited under C866; only their uncovered residue is audited)

Out of scope by instruction: the C855 orientation-name and order-eleven-witness work; the
discovery-track golden-root entry.

Governing conventions: `notes/literature-audit-conventions.md`, binding in full, as in C866.

## Opening summary

**Five of this report's sources were read at full text.** They are: Marston Conder's census of
trivalent symmetric graphs up to 10,000 vertices; the row for parameters (64,27,10,12) in Brouwer's
strongly-regular-graph tables; the row for parameters (64,28,12,12) in the same tables; Calderbank
and Kantor's 1986 survey *The Geometry of Two-Weight Codes* (carried over from the C866 audit, same
cached bytes); and the arXiv preprint of Crnković, Rukavina and Šimac, *LDPC codes constructed from
cubic symmetric graphs* — that last one at preprint depth only, with the published journal version
not read. Everything else is `secondary only` or `abstract/metadata only`. The read-depth field is
carried by every source this report names, including the two named only in order to be dismissed;
the per-source table in the Search record is the authoritative list, and its `full text` rows number
five.

**Two findings dominate this audit, and both concern the same graph.**

First, the 182-vertex cubic correspondence graph is a catalogued object. It is entry `C182.4` in
Conder's census — the unique cubic symmetric graph of that order that is bipartite with girth
twelve, with automorphism group of order 2184. This settles, in the affirmative, the question the
orbit-correspondence bundle itself listed as open ("Determine whether the 182-vertex cubic coset
graph is classical"), and it means no manuscript may present the graph as new. What survives as
possibly new is the identification of this known graph's two sides with Paper IV's two minimum-word
orbits, together with the support-XOR identities.

Second, and more valuable: a 2020 preprint by Crnković, Rukavina and Šimac constructs low-density
parity-check codes from exactly these graphs, tabulates every bipartite one below 200 vertices, and
records for our graph a code of length 91 and dimension 14 with minimum distance 26. Our bundle
computes *both* biadjacency kernels and gets distance 28 on one side and 26 on the other — so the
26 is published and should be cited, while the 28 is not in that table. The reason it is not is that
the paper argues the two sides always give equivalent codes, on the grounds that an arc-transitive
graph is vertex-transitive. That argument does not survive a bipartite graph whose automorphism
group preserves the two parts, which is exactly our case. **The lane is holding a counterexample to
a published claim in a peer-reviewed journal.** Two things must be checked before asserting it: that
our transition matrix really is that graph's biadjacency, and that the sentence and the table row
read the same way in the published version, which I could not obtain.

Everything else audited here comes back folklore or unpre-empted-but-unremarkable. The channel
formulation, the dual-number algebra, the endomorphism-ring exclusion, the Tanner framing, the
algorithmic bounds, the compact-representation analysis, the Farkas certificate, and the CSS
obstruction are all standard machinery correctly applied, and the bundles mostly say so themselves.
The E6 code, audited here by its own derivation rather than as a shortening, turns out to be the
same Calderbank–Kantor two-weight family as the E7 and E8 levels — taken directly rather than by
complementation — which closes the coordinator's carry-over and lets the whole ladder be described
as one classical family read at three ranks.

Audited specifically against the second carry-over: the code-CFT root-lattice literature is **not**
a predecessor for the quantum formulations of the frames, and should not be cited as one. Those
constructions are Pauli frames on a fixed qubit set indexed by a finite geometry, with no lattice,
no self-duality condition, and no conformal field theory. That line remains relevant only to the
E8/E9 ladder items, where C866 already recorded it.

**Blocking gaps:** the published version of the LDPC paper; a second, DOI-less 2019 item by the
same group that may carry the same table earlier; and the Chakravarti chapter carried over from
C866, which I attempted and which remains paywalled.

## Verdict table

| # | Item | Verdict |
|---|---|---|
| OC-1 | The 182-vertex cubic coset graph | **PRE-EMPTED** — Conder census entry `C182.4`; inside the Foster census range since 1988 |
| OC-2 / PO-1 | The one-frame kernels and the parity-complement lift | **PRE-EMPTED in part** — the distance-26 kernel is published; the distance-28 kernel is not, and its existence refutes the source's equivalence claim. Parity-complement lift and cross-orbital exhaustion: **NO PREDECESSOR LOCATED** |
| OC-3 | Orbit correspondence and the support-XOR identities | **FOLKLORE** for the Radon/double-coset machinery; **NO PREDECESSOR LOCATED** for the identities |
| OC-4 | Dual-number frame modules | **FOLKLORE** at textbook level; the freeness computation needs no predecessor |
| OC-5 | The golden dual-number exchange | **FOLKLORE** — ramification of two in the golden order |
| OC-6 | Exclusion of an equivariant F_64 repair | **FOLKLORE** method (Schur lemma, modular representation theory); computation is its own warrant |
| OC-7 | The frame channel | **FOLKLORE** — weakly symmetric channel capacity is textbook |
| OC-8 | Tanner view and the frame metacode | **FOLKLORE** framing (Tanner 1981); **NO PREDECESSOR LOCATED** for the code, but it sits adjacent to the OC-2 predecessor and must cite it |
| OC-9 | Quantum formulations of the frames | **FOLKLORE** in every component; code-CFT literature explicitly **not** a predecessor |
| OC-10 | Algorithmic bounds | **FOLKLORE** — standard sparse linear algebra; no absence claim at stake |
| OC-11 | Compact representations | **FOLKLORE** — published data structures; the bundle already declines the claim |
| OC-12 / HS-1 | Higher shell and the parity-complement two-cycle | **NO PREDECESSOR LOCATED**, and none expected — these are computations |
| CE-1 | Column-extension obstruction and Farkas certificate | **FOLKLORE** method (geometric method plus linear-programming bound); present as a certificate, not a method |
| CC-1 | The Clebsch-connection proposal | **FOLKLORE** — Dickson's subgroup classification; the document says so itself |
| L6-1 | E6 code from the Cartan-cubic tritangent support | **FOLKLORE / KNOWN-IN-SUBSTANCE** — Calderbank–Kantor Example RT2 taken directly; Brouwer row (64,27,10,12) |
| L6-2 | The A_2-transversal colour-lift theorem | **NO PREDECESSOR LOCATED**; likely folklore in equivalent form — state with proof, claim nothing |
| L7-1 | E7 design, dual tetrads, CSS obstruction | **FOLKLORE / KNOWN-IN-SUBSTANCE** — classical bitangent theory plus a pigeonhole |

## Per-item findings

Items are numbered by bundle: **OC** = orbit-correspondence bundle, **CC** = Clebsch-connection
proposal, **CE** = column-extension obstruction, **HS** = higher-shell, **PO** = project-up
optimality, **L6/L7** = the two ladder predecessors.

### OC-1 — the 182-vertex cubic coset graph

**Verdict: PRE-EMPTED.** The graph is a catalogued object, and this settles the bundle's own
open question 4 ("Determine whether the 182-vertex cubic coset graph is classical") in the
affirmative.

Marston Conder's census of trivalent (cubic) symmetric graphs on up to 10,000 vertices lists
exactly four graphs of that order, and exactly one of them matches the bundle's invariants:

```
C182.1 : |Aut(X)| = 546  : Type 1   : Girth 6  : Diameter 13 : Bipartite
C182.2 : |Aut(X)| = 546  : Type 1   : Girth 6  : Diameter 11 : Bipartite
C182.3 : |Aut(X)| = 1092 : Type 2^1 : Girth 7  : Diameter 8  : Non-bipartite
C182.4 : |Aut(X)| = 2184 : Type 3   : Girth 12 : Diameter 9  : Bipartite
```

`C182.4` has automorphism group of order 2184, girth twelve, and is bipartite — matching the
bundle's cubic, bipartite, girth-twelve graph with the full group acting. Conder's key defines
"Type 3" as a 3-arc-regular automorphism group; MY inference, marked as mine: since the order
2184 equals the order of the acting group in the bundle and the census entry is unique with these
invariants, the bundle's graph is `C182.4`, and its full automorphism group is therefore no larger
than the group already acting — the bundle has not found a graph with unexpected extra symmetry.
`C182.3`, at order 1092, is the corresponding index-two object.

Read depth: `full text` of the census listing — the complete file was downloaded by `curl` from
`https://www.math.auckland.ac.nz/~conder/symmcubic10000list.txt`, SHA-256
`a925691358b84bac0bd7dc175d619846f10c11fd2c20d0db20ca7a13b303bb96`, 286,397 bytes; I read the
header, the type key, and the relevant order block, and matched entirely locally. Version: the 2011
listing, described in the file's own header as produced "with the help of the
'LowIndexNormalSubgroups' routine in Magma, in 2011". Not added to the shared literature cache —
it is a plain-text dataset, not a DOI/arXiv-keyed PDF, and `litcache` refuses non-PDF bytes; the
SHA-256 above is the record.

The file names its own background reference: Marston Conder and P. Dobcsányi, "Trivalent symmetric
graphs on up to 768 vertices", *J. Combinatorial Mathematics & Combinatorial Computing* 40 (2002),
41–63. Read depth: `secondary only` — bibliographic detail taken verbatim from the census file's
header, whose own depth is `full text`; the paper itself was not obtained.

The Foster census, the older enumeration this continues, is described (read depth:
`abstract/metadata only`, via a WebFetch summary of the Wikipedia article "Foster census", not the
census itself) as having been published in book form in 1988 listing all cubic symmetric graphs up
to 512 vertices. MY inference, marked as mine: 182 is well inside that range, so this graph has
been in the published literature since at least 1988 and probably far earlier. I did NOT obtain the
Foster census itself and so cannot state its label for this graph; that is recorded as an open gap.

**Consequence for the manuscript.** Any sentence presenting the correspondence graph as a new
object must be rewritten. What survives as potentially new is the *identification* — that this
known graph carries Paper IV's two minimum-word orbits as its two sides, with the support-XOR
identities — not the graph.

### L6-1 — the E6 code [27,6,12] as the kernel of the Cartan-cubic tritangent support

**Verdict: FOLKLORE / KNOWN-IN-SUBSTANCE, and by a second, more direct route than the one C866
found.** C866 audited this code only as the one-coordinate shortening of the E7 bitangent code.
The earlier bundle derives it independently, as the binary kernel of the 45-by-27 exponent matrix
of the Cartan cubic's square-free monomials. That derivation is new as a derivation; the code is
not.

Its weight enumerator `1 + 36z^12 + 27z^16` has no all-ones word, so unlike the E7 and E8 codes
this one is the *pure* two-weight code, with weights 12 and 16 on 27 coordinates. A projective
binary two-weight `[27,6]` code corresponds to a strongly regular graph on `2^6 = 64` vertices of
valency 27. Brouwer's tables have exactly one such row, and it names the construction:

> `Mesner; from a unital: projective 4-ary [9,3] code with weights 6, 8; VO–(6,2) affine polar
> graph; RSHCD–; 2-graph`

Read depth: `full text` of the row, extracted locally from
`https://aeb.win.tue.nl/graphs/srg/srgtab51-100.html` fetched by `curl` and parsed on this host.

The clause `VO–(6,2) affine polar graph` is the identification. MY inference, marked as mine and
kept separate from the table's own framing: the minus-type affine polar graph on `F_2^6` has as its
neighbours-of-zero the nonzero singular vectors of an elliptic quadratic form, of which there are
`(2^3+1)(2^2−1) = 27`; so the corresponding binary two-weight `[27,6]` code is the code of the 27
points of the elliptic quadric in `PG(5,2)`. That is precisely Calderbank–Kantor Example RT2 at
`q = 2, l = 3, ε = −1` — the same family C866 identified for the E7 and E8 levels, but taken
*directly* (the singular set) rather than by complementation. This closes the coordinator's
carry-over cleanly: all three level codes, E6 included, are Calderbank–Kantor two-weight codes,
and E6 is the most direct instance of the three.

Calderbank & Kantor, *The Geometry of Two-Weight Codes*, Bull. London Math. Soc., 1986. Read depth:
`full text` — carried over from the C866 audit, same bytes: shared literature cache key
`10.1112/blms/18.2.97`, SHA-256
`986eeff4e7b4d259876242ee3659a627c28057abe5a087dcdd9e9bdb7181b05d`; Example RT2 and §12 are the
sections relied on. Under the conventions' Boundary clause, reuse of a source already recorded at
full text by an earlier audit carries no fresh obligation, but the marker is repeated here because
the field is unconditional.

**The reconstruction chain is also classical.** The bundle's chain — minimum shell → 36
double-sixes → 27-line intersection graph → 45 tritangents — rests on the identification of the 27
lines with the points of a generalized quadrangle of order (2,4), equivalently the elliptic quadric
`Q^-(5,2)`, with the 45 tritangent planes as its lines. That identification is nineteenth- and
early-twentieth-century geometry and is not credibly new; I did not chase a specific citation for
it, and it is asserted here as standard rather than as a sourced claim. Its consequence for the
audit is that the "shell reconstructs the carrier" loop at E6 is a re-derivation of a known
incidence geometry from a known code, not a new reconstruction theorem.

### OC-2 / PO-1 — the one-frame kernels [91,14,28], [91,14,26] and the parity-complement lift [91,15,28]

**Verdict: PRE-EMPTED in part — one of the two one-frame kernels is published, in a table whose
accompanying equivalence claim the bundle's own computation refutes. The refutation is the most
valuable thing this audit found, and it is a positive result, not a loss.**

The predecessor is Dean Crnković, Sanja Rukavina and Marina Šimac, "LDPC codes constructed from
cubic symmetric graphs", *Applicable Algebra in Engineering, Communication and Computing*, DOI
`10.1007/s00200-020-00468-2`, preprint arXiv:2002.06690. Read depth: `full text` of the
**preprint** (arXiv v1, dated 16 February 2020, 6 pages as fetched / 17 pages as extracted),
downloaded from `https://arxiv.org/pdf/2002.06690`, added to the shared literature cache under key
`arXiv:2002.06690`, SHA-256 `10ee616dd9b16d2129a8b26e4da293cb7c53394debe7bd6783672fedd66b4914`;
extraction by poppler `pdftotext`. Sections relied on: the abstract, the construction paragraph
defining `C(G)`, the discussion of `H` versus `H^T`, and Table 1 with its following commentary.
Version caveat, recorded as required: I read the arXiv preprint, **not** the published AAECC
version; zbMATH dates the publication 2022 and OpenAlex dates it 2020, so at least one field
differs between services and the published version may differ from what I read. Any claim about
the *published* paper is therefore marked as characterised from its preprint.

**What the paper does.** It takes a connected bipartite cubic symmetric graph on `2n` vertices,
uses the `n`-by-`n` biadjacency block `H` as a parity-check matrix, and calls the resulting
`(3,3)`-regular LDPC code `C(G)`, of length `n` and dimension `n − rank_2(H)`. Table 1 reports
parameters for every bipartite cubic symmetric graph of order under 200 — a range that contains the
bundle's graph.

**The match.** Table 1's row for the graph labelled `182D` reads `[91, 14, 26]` with an asterisk,
and girth 12. Three independent things line up, and I checked all three locally against the bundle:

1. Girth twelve is a unique discriminator at this order — Conder's census (OC-1 above) has exactly
   one cubic symmetric graph of that order with girth twelve.
2. The paper's labels at this order are `182A`, `182B`, `182D`, skipping `182C`; the census has
   three bipartite graphs and one non-bipartite one at this order, and the paper considers only
   bipartite graphs. The skipped letter is exactly the non-bipartite census entry.
3. Dimension 14 forces `rank_2(H) = 77`, which equals the rank the bundle computes for its
   transition matrix.

MY inference, marked as mine: the paper's `182D` is the bundle's correspondence graph, and its
`C(G)` is one of the bundle's two one-frame kernels. So the `[91,14,26]` code is published, and
the bundle should cite this paper rather than present that code as new.

**The refutation.** The paper argues, immediately before Table 1, that only one of the two sides
need be computed:

> "Every arc-transitive graph without isolated vertices is vertex-transitive, so it is possible to
> obtain `H` from `H^T` by permuting the rows and columns. Hence, the LDPC codes obtained from `H`
> and `H^T` are equivalent."

The bundle computes both sides and finds `ker C = [91,14,28]` against `ker C^T = [91,14,26]` —
same length, same dimension, different minimum distance, hence **inequivalent**. It further finds
that one side is doubly even and self-orthogonal while the paper marks `182D` as an LCD code
(`C ∩ C^⊥ = {0}`), which is the opposite property; a `[91,14,26]` code has a weight-26 word and so
cannot be doubly even. Both discrepancies point the same way.

MY inference, marked as mine and kept distinct from both the paper's framing and the bundle's:
the quoted argument does not go through for a bipartite graph whose automorphism group preserves
the two parts. Arc-transitivity gives transitivity on arcs and hence on vertices *within* the
action, but for a bipartite graph the two parts may be distinct orbits, in which case no
automorphism carries `H` to `H^T` and the two kernels need not be equivalent. At this order the
census records `|Aut| = 2184`, which is exactly the order of the group the bundle uses and which
acts with the two parts as separate orbits — so this graph is precisely a case where the paper's
inference fails.

**What the lane should do with this, stated plainly.** This is a publishable correction to a
peer-reviewed paper, and it comes with an explicit counterexample the lane has already computed.
Before asserting it, two things must be verified, and neither needs new literature: first, confirm
computationally that the bundle's transition matrix really is the biadjacency of the census graph
`C182.4` (checking girth and automorphism group order suffices); second, obtain the **published**
AAECC version and confirm the equivalence sentence and the Table 1 row survive there in the form
the preprint has them. Until the published version is read, the correction is characterised from
the preprint only.

**What remains unpre-empted here.** The parity-complement lift `ker(C+J) = [91,15,28]` does not
appear in that paper, which considers only `ker H` for the bare biadjacency. The general
parity-complement lemma (`ker(C+J) = ker C ⊕ ⟨1⟩` for odd `n` with all row and column degrees odd,
with distance `min{d(ker C), n − maxwt(ker C)}`) is a short linear-algebra argument that I would
expect to be folklore, but no source stating it was located; see the coverage statement, since the
searches for it were necessarily generic. **PO-1's cross-orbital exhaustion** — that among all 127
nonzero binary sums of the seven orbitals, none beats distance 28 and none at distance 28 beats
dimension 15 — is a bounded computation over a specific commutant and has no located predecessor;
the *framework* (orbitals of a permutation group, the associated commutant algebra) is standard
association-scheme theory and is not claimed as new by the bundle either.

### OC-3 — the octahedral–toric correspondence and its neighbour-sum (Radon) identities

**Verdict: FOLKLORE / KNOWN-IN-SUBSTANCE for the machinery; NO PREDECESSOR LOCATED for the two
support-XOR identities at this group.**

Building a sparse incidence between two homogeneous spaces of a finite group from a double coset,
and reading `C` and `C^T` as a transform pair, is the standard Radon-transform-on-a-finite-set
setting. Anchor located: Joseph P. S. Kung, "Radon transforms in combinatorics and lattice theory",
1986, zbMATH record `https://zbmath.org/3957114`. Read depth: `abstract/metadata only` — zbMATH
Open API record giving title, author and year; no series, volume or pages were returned by the API
and none are asserted here, and the text was not obtained. The bundle already calls its own
construction a "double-coset Radon transform", so it is not claiming this framing as new.

What has no located predecessor is the specific pair of identities — that each vertex's support is
the symmetric difference of its three neighbours' supports, in both directions, at this group and
these two orbits. The bundle itself flags that only the `q = 13` case is proved and that a
coordinate-free double-coset proof is missing (its open question 1). I searched only with generic
vocabulary; see the coverage statement.

### OC-4 — dual-number frame modules, and OC-5 — the golden dual-number exchange

**Verdict for both: FOLKLORE, at textbook level.**

An involution `J` with `J² = I` in characteristic two makes `ε = J + I` square to zero, and the
algebra it generates is the dual numbers; equivalently the group algebra of a group of order two
over a field of characteristic two is local and isomorphic to `F[ε]/(ε²)`. This is the first
example in any modular representation theory course, and the bundle's `F_8[ε]/(ε²)` is its scalar
extension. Likewise `Z[√5] ⊗ F_2 ≅ F_2[t]/(t²−1) ≅ F_2[ε]/(ε²)` is the statement that two ramifies
in that order — elementary algebraic number theory. I did not seek citations for either and none is
needed; both are asserted here as standard rather than as sourced claims, and OpenAlex
`("dual numbers" AND "modular representation")` returns 0, which reflects that nobody writes papers
about facts this basic rather than that the facts are unknown.

What is *not* folklore is the specific claim that the paired frame module is **free** of rank
twelve over that algebra, with `ker ε = im ε` — that is a computation about a particular module,
and no predecessor was sought for it because it is not the kind of statement that has one.

MY inference, marked as mine: the three-way "seam" across Papers I, III and IV is an internal
cross-reference within this project, not a claim about the literature, and carries no novelty
burden. It should be presented as an observation about the series' own objects, and a referee will
read it that way only if the underlying algebra identification is stated as elementary — which the
bundle does do.

### OC-6 — exclusion of a group-equivariant F_64 repair

**Verdict: FOLKLORE / KNOWN-IN-SUBSTANCE for the method; NO PREDECESSOR LOCATED for the specific
endomorphism-ring computation, which is also the kind of claim that does not need one.**

"The endomorphism ring of the module is exactly the scalar field, hence no larger field acts
equivariantly" is the standard Schur-lemma / field-of-definition argument, and the two-modular
representation theory of the relevant group is classical, catalogued material (Brauer characters
and decomposition matrices for the simple groups of this size are in the modular Atlas tradition).
zbMATH returned an empty set (HTTP 404) for a query naming the group and the characteristic, which
I read as the absence of a paper *about* this particular module rather than as absence of the
theory. The bundle's rank-143 linear system is a computation, not a claim against the literature.

### OC-7 — the frame channel

**Verdict: FOLKLORE.** A discrete memoryless channel whose transition matrix has each row a
permutation of every other and each column a permutation of every other is *weakly symmetric*, and
its capacity is `log|output alphabet| − H(row)`. This is a standard textbook exercise, and the
bundle's `log₂(91/3)` is its immediate evaluation. The Fisher-metric remark (singular values of the
transition matrix as local information-retention factors at the uniform input) is likewise standard
information geometry. OpenAlex `("weakly symmetric channel" AND capacity)` returns 4 records, all
about wiretap codes or capacity asymptotics rather than about the definition; screened over title
only, discriminator *does this claim the capacity formula as a result?* — none does, consistent
with the formula being textbook. Those four are named nowhere else in this report and carry read
depth `abstract/metadata only` (OpenAlex work records).

The comparison with the Paper II channel (that its erased contrast is exactly one-dimensional,
against a fourteen-dimensional kernel here) is internal to the project.

### OC-8 — the Tanner view and the frame metacode [182,37,28]

**Verdict: FOLKLORE for the framing; NO PREDECESSOR LOCATED for the code itself, but see OC-2 —
the immediate neighbourhood of this construction is occupied.**

Presenting a sparse parity-check system as a bipartite graph code is Tanner's construction:
R. Michael Tanner, "A recursive approach to low complexity codes", *IEEE Transactions on
Information Theory* 27, 1981. Read depth: `abstract/metadata only` — zbMATH Open API record
`https://zbmath.org/3745089` giving title, author, year and journal with volume 27; no page range
was returned and none is asserted; the paper was not obtained.

The bundle's metacode uses the block matrix with identity diagonal, so its rows have weight four
rather than three, which is what distinguishes it from the `(3,3)`-regular codes of the
Crnković–Rukavina–Šimac paper audited at OC-2. That paper is nevertheless the closest published
work: same graph, same length on each side, adjacent construction. **Any manuscript presenting the
metacode must cite it and state the difference explicitly**, because a referee who knows that paper
will otherwise assume the constructions coincide.

The exhaustive distance computation itself (Gray-code enumeration of the full code) is standard
method, not a claim.

### OC-9 — quantum formulations of the frames

**Verdict: FOLKLORE for every component; NO PREDECESSOR LOCATED for the assembled instance. Audited
specifically against the code-CFT root-lattice line, per instruction: that line is NOT relevant
here, and this is worth stating because it is the one place a reader might expect it to be.**

Component by component:

- **Redundant Pauli measurement frames with metachecks.** Redundant syndrome measurement plus
  consistency checks on the syndrome bits ("metachecks") is an established construction in the
  single-shot error-correction literature. Anchor located: "A theory of single-shot error
  correction for adversarial noise", DOI `10.1088/2058-9565/aafc8f`, 2019. Read depth:
  `abstract/metadata only` — OpenAlex work record giving title, DOI and year; the paper was not
  obtained. OpenAlex `("single-shot" AND "metacheck")` returns 18 records; screened over title,
  discriminator *is this a general theory of metachecks rather than an application?* — that record
  is the one general-theory hit, and the remainder are applications or 2026 Zenodo depositions.
- **CSS construction from a self-orthogonal code.** Textbook.
- **Hypergraph product.** The construction of a quantum LDPC code as a product of two classical
  parity-check matrices is Tillich–Zémor's; OpenAlex `("hypergraph product" AND "quantum code")`
  returns 56 records, all downstream work (decoders, erasure decoding, belief propagation), which
  is itself evidence that the construction is settled background. Those 56 were screened over title
  only with discriminator *does this introduce the product rather than use it?* — none does, and
  the originating paper did not surface in that particular conjunction. Read depth for the set:
  covered by the set record; no member is named individually here.
- **Chiral hopping / Szegedy quantisation.** Standard.

**On the code-CFT carry-over.** C866 established that a real literature connects quantum stabilizer
codes to root lattices through even self-dual Lorentzian lattices (the code-CFT line). Audited
against this item specifically: that connection is about codes whose *alphabet* is a lattice
discriminant group and whose content is modular invariance of a conformal field theory. Nothing in
OC-9 is of that kind — the frames here are Pauli operators on a fixed number of qubits indexed by a
finite geometry, with no lattice, no self-duality requirement, and no CFT. **My conclusion: the
code-CFT literature is not a predecessor for this item and should not be cited as one.** It remains
a predecessor concern only for the E8/E9 ladder items, where C866 already recorded it. Stating this
explicitly is the point, so that a later reader does not re-open the question.

### OC-10 — algorithmic bounds, and OC-11 — compact representations

**Verdict for both: FOLKLORE. Neither is a novelty claim and neither should be presented as one.**

The algorithmic content is: sparse matrix-vector products cost the number of nonzeros; reconstruct
one side from the other in output-optimal packed-word time; black-box randomised linear algebra
recovers a kernel in the stated arithmetic bound; enumerating a marked correspondence costs its
output size rather than the full cross-product. All of this is standard sparse linear algebra and
standard orbit enumeration. The bundle is careful about this already — it says the deterministic
improvement is "not claimed" and that the uniform asymptotic calculation "must not be advertised as
a uniform code-reconstruction theorem".

The representation analysis compares fixed-width machine words against Elias–Fano and
Roaring-style compressed sets, and concludes fixed width wins at this scale. Those data structures
are published, named, and not in question; the bundle's own application assessment already scores
"general-purpose bitmap compression" lowest and says explicitly that the example does not improve
either. No audit exposure. I ran no database query for this item, since there is no absence claim
to discharge — recorded here so the omission is visible rather than silent.

### OC-12 / HS-1 — the higher shell [1092,37,204] and the parity-complement two-cycle

**Verdict: NO PREDECESSOR LOCATED, and none expected.** These are computations about specific
orbits of a specific group: the weight-38 shell splits into two orbits, each gives an incidence
code with the stated parameters, and the minimum shell of that code recovers one of the earlier
frames. The distance certificate is a disjoint-information-set enumeration, which is standard
method. The `C ↦ C + J` two-cycle is elementary. Nothing here makes a claim against the
literature, and the bundle says so ("it does not claim a uniform higher-shell theorem").

### CE-1 — the column-extension obstruction and its Farkas certificate

**Verdict: FOLKLORE / KNOWN-IN-SUBSTANCE for the entire method; the certificate is a new instance.**

Regarding a linear code as a multiset of points in projective space, so that codeword weights are
complements of hyperplane sections and lengthening means adjoining columns, is the standard
geometric method for optimal linear codes. Extension theorems in exactly this language are an
active, named literature; zbMATH `extension theorem linear codes arcs projective geometry` returns
6 records, of which "A generalized extension theorem for linear codes" (2012, zbMATH
`https://zbmath.org/6006620`) is the on-point title. Read depth: `abstract/metadata only` — zbMATH
API record, title and year only; not obtained. The set of 6 was screened over title, discriminator
*does the title concern extending or lengthening linear codes in geometric language?* — two passed
(that one and "On the nonexistence of ternary linear codes attaining the Griesmer bound", zbMATH
`https://zbmath.org/7500613`, read depth `abstract/metadata only`, same route), the rest are
unrelated volumes.

Likewise, proving nonexistence by exhibiting a nonnegative combination of valid inequalities that
contradicts the length equation is Farkas' lemma applied to the linear-programming bound — the
oldest tool in the nonexistence literature. The bundle's contribution is an *exact integer*
certificate for one specific target, independently replayable without trusting the LP solver. That
is good practice, and good practice is not novelty. **Recommendation: present this as a certificate,
not as a method.**

### CC-1 — the Clebsch-connection proposal document

**Verdict: FOLKLORE, and the document already says so.** Its mathematical content is that the
relevant projective group contains no icosahedral subgroup because sixty does not divide its order,
with Dickson's classification of subgroups as the standard reference. The document itself names
Dickson and observes that the order argument needs no citation at all. There is no absence claim
here to discharge. The rest of the document is series-positioning and restates the ladder audited
under C866 and at L6/L7 below.

One thing worth flagging as an audit matter rather than a mathematical one: this document's
"Prior proposals" section asserts that three earlier internal reviews do not propose a mathematical
bridge, and therefore "This is not a duplicate." That is an internal-novelty claim about this
project's own records, not about the literature, and it is outside this audit's scope. It is
correctly scoped in the document.

### L7-1 — the E7 minimum shell as a 2-design, the dual tetrads, and the CSS obstruction

**Verdict: FOLKLORE / KNOWN-IN-SUBSTANCE.** C866 audited the E7 code itself; this is the residue it
did not cover.

- The **Steiner complexes** of the 28 bitangents, indexed by the nonzero vectors of the symplectic
  space, and the **syzygetic tetrads** with their classical count, are nineteenth-century
  bitangent theory. I did not obtain a primary source and none of the verdicts here rests on one;
  this is asserted as standard, in the same way the bundle asserts it.
- The **2-design** carried by the minimum shell follows from the transitive action, by the standard
  argument that a transitive group with the right rank makes an orbit of blocks a 2-design.
- The **dual code and its weight-four words** are a computation.
- The **CSS obstruction** — a seven-dimensional space contains at most 127 nonzero words and so
  cannot contain 315 tetrads — is a pigeonhole argument that fits on one line. It is correct and it
  is not a theorem anyone would claim.

Nothing here changes the C866 verdict on the E7 code. Recorded rather than repeated, per
instruction.

### L6-2 — the A_2-transversal lift theorem and the [81,8,36] bracket-support code

**Verdict: NO PREDECESSOR LOCATED for the lift theorem as stated; the code is a computation.**

The theorem says: given a connected three-uniform hypergraph with connected two-section and its
binary edge-incidence kernel `D`, imposing one check per hyperedge per bijection of its vertices to
three colours gives a lifted kernel isomorphic to `D ⊕ F_2²`, with an explicit enumerator and
`d = min{3d(D), 2n − maxwt(D)}`. The proof in the bundle is a gauge argument: colour differences
are vertex-independent along each hyperedge, and connectedness propagates it.

Searches found nothing: OpenAlex `("three-uniform hypergraph" AND code)` returns 1 record, on
mitochondrial genomes (read depth `abstract/metadata only`, OpenAlex record; dismissed on title —
it is computational biology, not coding theory). MY inference, marked as mine: this is very likely
folklore in some equivalent form — it is essentially the statement that the colour-permutation
checks force a coboundary, and that pattern recurs across combinatorics — but I could not locate it,
and a generic search cannot easily reach a lemma with no standard name. **Recommendation: state it
as a lemma with proof and do not claim novelty for it**; the proof is short enough that claiming
priority would cost more than it gains. The `[81,8,36]` code and its two-unit shortfall against the
best known distance are computations plus a public-table comparison the bundle already made.

## Search record

### Services used, and why Crossref was replaced

As established in the C866 audit and carried over on instruction: **Crossref cannot enumerate a
conjunctive set.** Its `query.bibliographic` parameter is relevance ranking over an implicit OR, so
its `total-results` is not a set size and licenses no negative. The three-service requirement is
therefore discharged here with **OpenAlex, Semantic Scholar, and zbMATH Open**, and Crossref was
used in this audit only once, to resolve a DOI's metadata. Where a verdict rests on an enumerated
set, all three counts are recorded separately below.

### How "empty" was distinguished from "error", per service

- **OpenAlex** (`api.openalex.org/works`, `mailto` identified): empty is HTTP 200 with
  `meta.count = 0`; errors raise and print a traceback. Every count below came off a 200 response.
- **Semantic Scholar** (`/graph/v1/paper/search/bulk`): empty is HTTP 200 with `"total": 0`; rate
  limiting is HTTP 429, retried with backoff, and a failure prints `S2_ERROR` rather than a count.
  The `+` operator is conjunctive.
- **zbMATH Open** (`api.zbmath.org/v1/document/_search`): **empty is HTTP 404, not a zero count.**
  This is the calibration established in C866 and re-confirmed here: in this session,
  `LDPC codes constructed from cubic symmetric graphs` → 200 with 1 result, while
  `quantum LDPC codes from product of two codes Tillich Zemor` and
  `modular representations PSL(2,13) characteristic two` → 404. Near-identical query shapes
  returning both outcomes is why 404 is read as "no documents matched" rather than "malformed".
- **arXiv API**: not used as an enumerating service in this audit; the one arXiv fetch was by
  `id_list` for a known preprint.
- **Direct dataset fetches** (Conder census, Brouwer tables, the arXiv preprint): retrieved by
  `curl` on generic URLs and matched **entirely locally**. No parameter of ours left this host in
  any of these requests.

### Verbatim load-bearing queries

OpenAlex (`filter=`):
```
title_and_abstract.search:("cubic symmetric graphs" AND codes)          -> 2
title_and_abstract.search:("Radon transform" AND "finite set")          -> 16
title_and_abstract.search:("Tanner code")                               -> 127
title_and_abstract.search:("hypergraph product" AND "quantum code")     -> 56
title_and_abstract.search:("single-shot" AND "metacheck")               -> 18
title_and_abstract.search:("Griesmer" AND "extension" AND "linear code")-> 12
title_and_abstract.search:("dual numbers" AND "modular representation") -> 0
title_and_abstract.search:("three-uniform hypergraph" AND code)         -> 1
title_and_abstract.search:("weakly symmetric channel" AND capacity)     -> 4
```

Semantic Scholar (bulk endpoint, `query=`):
```
"cubic symmetric graphs" + codes                                        -> 1
```

zbMATH Open (`search_string=`):
```
LDPC codes constructed from cubic symmetric graphs                      -> 1
Tanner code bipartite graph                                             -> 11
hypergraph product quantum LDPC codes                                   -> 10
geometric method optimal linear codes extension of codes                -> 19
extension theorem linear codes arcs projective geometry                 -> 6
Radon transform finite sets combinatorics                               -> 6
recursive approach low complexity codes Tanner                          -> 3
theory of single-shot error correction adversarial noise                -> 1
A recursive approach to low complexity codes                            -> 1
Radon transforms in combinatorics and lattice theory                    -> 1
Radon transform finite groups Hecke                                     -> 404 / empty
single-shot error correction metachecks                                 -> 404 / empty
quantum LDPC codes from product of two codes Tillich Zemor              -> 404 / empty
modular representations PSL(2,13) characteristic two                    -> 404 / empty
```

**Three-service agreement on the one load-bearing enumerated set.** For the predecessor found at
OC-2, the counts were: OpenAlex 2, Semantic Scholar 1, zbMATH 1. Each is recorded separately as
required. The disagreement is a reportable finding: OpenAlex's extra record is a 2019 item with no
DOI, "On some results about LDPC codes based on cubic symmetric graphs and µ-geodetic graphs" (read
depth: `abstract/metadata only`, OpenAlex work record, title and year only). MY inference, marked
as mine: this looks like a conference abstract or thesis-adjacent item by the same group, which
Semantic Scholar and zbMATH do not index. It is a second potential predecessor and **was not
obtained** — carried forward as an open gap, because if it contains the same table it would be the
earlier publication.

### Screened sets

1. **OpenAlex `("cubic symmetric graphs" AND codes)`** — 2 records, screened over title and DOI
   presence. Discriminator: *does the title indicate codes constructed from cubic symmetric
   graphs?* Both passed; one was promoted to full text (OC-2), one could not be obtained.
2. **OpenAlex `("hypergraph product" AND "quantum code")`** — 56 records, screened over title.
   Discriminator: *does this introduce the hypergraph product rather than use or decode it?* Zero
   passed; the set is uniformly downstream decoder work.
3. **OpenAlex `("single-shot" AND "metacheck")`** — 18 records, screened over title and host.
   Discriminator: *is this a general theory of metachecks?* One passed and is named at OC-9; the
   rest are applications or 2026 Zenodo depositions.
4. **OpenAlex `("weakly symmetric channel" AND capacity)`** — 4 records, screened over title.
   Discriminator: *does this claim the weakly-symmetric capacity formula as a result?* Zero passed.
5. **zbMATH `extension theorem linear codes arcs projective geometry`** — 6 records, screened over
   title. Discriminator: *does the title concern extending or lengthening linear codes in geometric
   language?* Two passed and are named at CE-1.
6. **zbMATH `Tanner code bipartite graph`** — 11 records, screened over title and year.
   Discriminator: *is this the originating construction or a code built from a symmetric graph?*
   Two passed: Tanner 1981 (named at OC-8) and the 2022 record that led to OC-2.
7. **Conder's census, order block** — 4 entries, screened over the census's own recorded invariants
   (automorphism group order, type, girth, bipartiteness). Discriminator applied verbatim as the
   conjunction *girth twelve and bipartite*. Exactly one passed.

### Sources named in this report, with read depth

| Source | Read depth |
|---|---|
| Conder, census of trivalent symmetric graphs up to 10,000 vertices (2011 listing) | `full text` |
| Brouwer SRG table row (64,27,10,12), `aeb.win.tue.nl/graphs/srg/srgtab51-100.html` | `full text` (of the row) |
| Brouwer SRG table row (64,28,12,12), same page | `full text` (of the row) |
| Calderbank & Kantor, *The Geometry of Two-Weight Codes*, Bull. London Math. Soc., 1986 | `full text` (carried over from C866, same bytes) |
| Crnković, Rukavina & Šimac, *LDPC codes constructed from cubic symmetric graphs*, arXiv:2002.06690 | `full text` (**preprint only**; published AAECC version not read) |
| Conder & Dobcsányi, *Trivalent symmetric graphs on up to 768 vertices*, J. Combin. Math. Combin. Comput. 40 (2002), 41–63 | `secondary only` (via the census file's header) |
| Foster census (1988 book form, cubic symmetric graphs to 512 vertices) | `abstract/metadata only` (WebFetch summary of the Wikipedia article, not the census) |
| Kung, *Radon transforms in combinatorics and lattice theory*, 1986, zbMATH 3957114 | `abstract/metadata only` |
| Tanner, *A recursive approach to low complexity codes*, IEEE Trans. Inform. Theory 27, 1981, zbMATH 3745089 | `abstract/metadata only` |
| *A theory of single-shot error correction for adversarial noise*, DOI 10.1088/2058-9565/aafc8f, 2019 | `abstract/metadata only` |
| *A generalized extension theorem for linear codes*, 2012, zbMATH 6006620 | `abstract/metadata only` |
| *On the nonexistence of ternary linear codes attaining the Griesmer bound*, 2022, zbMATH 7500613 | `abstract/metadata only` |
| *On some results about LDPC codes based on cubic symmetric graphs and µ-geodetic graphs*, 2019, no DOI | `abstract/metadata only` |
| *Higher-order co-mutation interactions in mitochondrial genomes*, DOI 10.1088/1367-2630/acf51a | `abstract/metadata only` (named only to be dismissed at L6-2) |
| Four OpenAlex records from the weakly-symmetric-channel query | `abstract/metadata only` (set record only; none named individually) |
| Chakravarti, IMA Volumes chapter, DOI 10.1007/978-1-4613-8994-1_4 | `abstract/metadata only` (carried over from C866; still not obtained — see coverage) |

**Access details for cached / hashed items.**

- Crnković–Rukavina–Šimac: fetched by `curl` from `https://arxiv.org/pdf/2002.06690`, added to the
  shared literature cache under key `arXiv:2002.06690`, SHA-256
  `10ee616dd9b16d2129a8b26e4da293cb7c53394debe7bd6783672fedd66b4914`, extracted by poppler
  `pdftotext`.
- Conder census: fetched by `curl`, SHA-256
  `a925691358b84bac0bd7dc175d619846f10c11fd2c20d0db20ca7a13b303bb96`, 286,397 bytes. Not cached —
  plain text, not a PDF, and `litcache` refuses non-PDF bytes.
- Calderbank–Kantor: cache key `10.1112/blms/18.2.97`, SHA-256
  `986eeff4e7b4d259876242ee3659a627c28057abe5a087dcdd9e9bdb7181b05d`.

## Query hygiene

The constraint was in force from the first action of this task and **there was no slip**. Every
outbound request in this audit was one of:

1. a generic keyword query in pre-existing published vocabulary ("cubic symmetric graphs", "Tanner
   code", "hypergraph product", "Radon transform", "extension theorem linear codes"), carrying no
   parameter, no construction, and no indication of the project's shape;
2. a fetch of a complete public dataset or table page by its plain URL (Conder's census, Brouwer's
   strongly-regular-graph tables, one arXiv preprint), with **all matching performed locally on
   this host**.

No length, dimension, distance, weight enumerator, vertex count, girth, group order, design
parameter, or tetrad count of ours appeared in any outbound string. In particular, the graph
identification at OC-1 and the code identification at OC-2 — the two strongest findings — were made
by downloading a whole census and a whole table and grepping them here, precisely to avoid a
disclosing query.

**Verdicts weakened by the constraint.** No catalogue was asked whether any of our exact parameter
tuples is already a named object, so this report nowhere claims "not catalogued". The parity-
complement lemma (OC-2) and the colour-lift theorem (L6-2) are the two items whose negatives are
weakest, because the discriminating query for an unnamed lemma is close to a statement of the
lemma; both are recorded as "state with proof, claim no novelty" rather than as clean negatives.

## Coverage statement

### Searched and found nothing (licenses a negative)

- No work stating the two support-XOR neighbour-sum identities for this correspondence (OC-3),
  subject to the generic-vocabulary caveat above.
- No work stating the A_2-transversal colour-lift theorem in the form the bundle proves it (L6-2),
  same caveat.
- No work reporting the parity-complement lift or the cross-orbital exhaustion (OC-2, PO-1).
- No predecessor for the higher-shell codes (OC-12 / HS-1).

### Could not access (licenses nothing; carried forward as open gaps)

- **MathSciNet — NOT COVERED.** Institutional authentication required; not attempted. Every
  negative above retains "to our knowledge".
- **Google Scholar — NOT COVERED.** Blocks automated access.
- **The published AAECC version of Crnković–Rukavina–Šimac.** Read at preprint only. **This is a
  blocking gap for the OC-2 correction**: the equivalence sentence and the Table 1 row must be
  confirmed in the published version before the correction is asserted anywhere public.
- **"On some results about LDPC codes based on cubic symmetric graphs and µ-geodetic graphs"
  (2019, no DOI).** Surfaced by OpenAlex only, not obtained. Potentially an *earlier* publication of
  the same table. Open gap.
- **The Foster census itself.** Only its Wikipedia description was read, so I cannot give the
  Foster label for the graph at OC-1, only Conder's. The claim that the graph has been published
  since 1988 rests on the census's stated vertex range, not on my having seen the entry.
- **Chakravarti, IMA Volumes chapter (DOI 10.1007/978-1-4613-8994-1_4).** Carried over from C866 as
  instructed. I attempted it: the DOI resolves (HTTP 200) but Springer redirects to an
  authentication endpoint, so the chapter body is paywalled and no abstract was retrievable.
  **Gap not closed.** It remains blocking for the design claim in the C866 audit, and is recorded
  here so the two reports agree.
- **Conder & Dobcsányi (2002).** Bibliographic detail taken from the census header; paper not
  obtained.
- **Primary sources for the classical bitangent and 27-line geometry** (L7-1, L6-1). Not sought.
  Nothing in this audit rests on them beyond the assertion that they are standard.

## Incidental observations (candidate discovery-track entries)

Recorded here only; not written to the discovery track by this task.

1. **A published equivalence claim about codes from bipartite arc-transitive graphs appears to be
   false, and this lane already holds the counterexample.** Provenance: Crnković, Rukavina & Šimac,
   arXiv:2002.06690, the paragraph preceding Table 1, against the computed values in
   `notes/2026-08-04-c682-paper-iv-orbit-correspondence.md`. The general point — that
   arc-transitivity does not give a part-swapping automorphism of a bipartite graph, so the two
   biadjacency kernels can be inequivalent — is worth more than the single instance, since it
   affects any table built the same way. This is the highest-value item in this audit and is
   arguably a small paper on its own.
2. **The census answers an open question that was sitting in the bundle.** Provenance: the bundle's
   open question 4 asks whether the 182-vertex cubic coset graph is classical; Conder's census
   settles it. Worth noting that a five-minute dataset download closed a question listed as open —
   a cheap habit to institutionalise before opening structural questions about named combinatorial
   objects.
3. **All three exceptional level codes are one two-weight family, and E6 is the cleanest instance.**
   Provenance: this audit's L6-1, via Brouwer's `(64,27,10,12)` row and Calderbank–Kantor Example
   RT2. C866 established this for the two upper levels by complementation; the E6 level is the
   family taken directly. The ladder is therefore, in the classical language, one family read at
   three ranks — which is a cleaner sentence for a manuscript than three separate identifications,
   and also a sharper statement of what is left to claim.
4. **zbMATH returns HTTP 404 for an empty search.** Re-confirmed in this session with fresh
   controls. Already logged as an incidental observation in the C866 report; repeated here only
   because the calibration is load-bearing for this report's negatives too, and a future tooling
   change should fix it once.
