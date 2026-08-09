# C756 — local Paley rigidity focused literature audit

**Lane:** `clebsch` · **Date:** 2026-08-08 · **Scope:** exact-statement
predecessor audit for the Paley first subconstituent; no manuscript edits

**Read depth:** two newly fetched papers read in full (Goldberg 1970;
Javier--Llano--Zuazua 2026), four newly fetched surveys/neighboring papers
read at targeted depth with full-text keyword screens (Morris 2004;
Lim--Praeger 2009; Meslem--Sopena 2018; Jones 2020), and the previously
full-read Magsino--Mixon--Parshall local-Paley paper re-used only as a method
neighbor.  Muzychuk 2020 and Xu 1998 were available at metadata/abstract
depth only.

## Verdict

The exact theorem survives the covered-source novelty gate, with a newly
identified and important attribution boundary:

> For (q=p^n\equiv3\pmod4), if (S=(\mathbb F_q^*)^2), then
> \[
>  \operatorname{Aut}(P(q)[S])
>  =\{s\mapsto cs^{p^j}:c\in S,\ 0\le j<n\}
>  \cong S\rtimes\operatorname{Gal}(\mathbb F_q/\mathbb F_p).
> \]
> Equivalently, every automorphism of a Paley out-neighbourhood extends
> uniquely to an automorphism of the full Paley tournament fixing the base
> vertex.

No source inspected states this automorphism group or the equivalent unique
local-to-global extension theorem.  Goldberg determines the automorphism group
of the *full* Paley tournament.  The closest local predecessor is the very
recent paper of Javier--Llano--Zuazua: its Proposition 4.4 proves, for prime
(p\equiv3\pmod4), that the tournament induced on the quadratic residues is a
multiplicative circulant tournament with connection set
(Q_p\cap(1+Q_p)).  It does not determine the automorphism group, prove
normality, or discuss extension of local automorphisms.

The publication boundary is therefore:

| claim | audit decision |
|---|---|
| the Paley out-neighbourhood is a multiplicative circulant/Cayley tournament | **not new** in the prime case; cite Javier--Llano--Zuazua, Proposition 4.4; in general prime-power form it is also immediate from the ratio description |
| its exact automorphism group is (S\rtimes\operatorname{Gal}) | no predecessor located; qualified candidate novelty |
| every local automorphism extends uniquely to the full Paley tournament fixing the base vertex | no predecessor located; best conceptual statement of the candidate novelty |
| the Cayley tournament is normal and has group order (n(q-1)/2) | immediate corollary of the exact group; novelty travels with the theorem, not as an independent claim |
| for prime (q), the local tournament is a cyclic directed regular representation | immediate corollary in standard DRR terminology; not an independent priority claim |
| flat-Sidon one-block rigidity | elementary and likely folklore; use as the proof device and make no novelty claim |

This is a covered-source negative, not an unconditional priority assertion.
MathSciNet and a complete zbMATH citation-index check were not available, and
Semantic Scholar rate-limited two pinned records.  A paper should say “to our
knowledge” unless a human institutional-index check closes those gaps.

## Exact discriminator

The distinction from the closest sources is not merely “local versus global.”
It is the conjunction of four features:

1. the induced tournament is on the half-sized set (S), rather than the
   full additive field;
2. *every* permutation automorphism of that induced tournament is classified;
3. the only possibilities are multiplication followed by field Frobenius;
4. restriction from the full Paley stabilizer is an isomorphism, hence every
   local automorphism extends uniquely.

Goldberg supplies the target full stabilizer but not surjectivity of its
restriction to (S).  Javier--Llano--Zuazua supplies the multiplicative
circulant model for prime fields but not its full automorphism group.  General
normal-Cayley and cyclic-tournament references supply terminology and broad
structure, not this connection set or this extension theorem.

## Source findings

| source and read depth | exact finding |
|---|---|
| M. Goldberg, *The Group of the Quadratic Residue Tournament* (1970), DOI `10.4153/CMB-1970-010-8`; **full, 4 pages/1464 words**, SHA-256 `4f616e090df015ae1e148187684eefcd3b4e80feff2cf74524e0218685608aad` | Theorem 2 gives the full Paley tournament group (A\Delta L_1(q)); Theorem 3 is a full-field square-difference permutation criterion.  Neither treats the induced tournament on (S). |
| N. Y. Javier, B. Llano, R. Zuazua, *2- and 3-existentially closed tournaments* (2026), DOI `10.55016/0sre1423`; **full, 18 pages/8815 words**, SHA-256 `5299c1b61795b6400f632a280919ff92eefaf06ee12c94f605a639e98a88b488` | Proposition 4.4 is the closest predecessor: for prime (p=4n+3), (QR_p[N^+(0)]\cong\operatorname{Cay}(Q_p,J)), (J=Q_p\cap(1+Q_p)).  Sections 4--5 contain no computation of this local automorphism group, no normality/DRR result, and no local-to-global theorem. |
| G. A. Jones, *Paley and the Paley Graphs* (2020), arXiv `1702.00285`; targeted read plus full keyword screen, SHA-256 `2a812c0aa79cc5d47c9342d3d7af1cb9a5a09accd3bb98794b727ac565eae516` | Section 9.7 recounts the full Paley tournament automorphism theorem and attributes Goldberg/Kantor/Berggren.  No local-neighbourhood theorem occurs. |
| J. Morris, *Automorphism groups of circulant graphs — a survey* (2004), arXiv `math/0411302`; targeted read plus full keyword screen, SHA-256 `4262545be23e1ab590778c66bd285be162f689e4cb6e39f9cd1b00d5bfdf3ee6` | Supplies circulant and normal-Cayley language.  It contains no Paley-tournament neighborhood result and no tournament hit in the extracted text. |
| T. K. Lim, C. E. Praeger, *On generalised Paley graphs and their automorphism groups* (2009), arXiv `math/0605252`; targeted read plus full keyword screen, SHA-256 `d8d37b2061770c023bdc10e04c38c6b5fd60507849f252b85399b712a9fca5d7` | Classifies or bounds automorphisms for generalized Paley graphs/cyclotomic structures on the whole field.  No first-subconstituent tournament theorem. |
| F. Meslem, E. Sopena, *On the distinguishing number of cyclic tournaments* (2018), arXiv `1608.04866`; Paley section plus full keyword screen, SHA-256 `2d0e18b083b3b663a7cc29ddf6fd95db57293e787acd121b1066fa08ca9f88f8` | Uses the full prime Paley automorphism group for distinguishing labelings.  Its induced half-interval subtournaments are not the quadratic-residue neighborhood. |
| M. Muzychuk, *Automorphism Groups of Paley Graphs and Cyclotomic Schemes* (2020), DOI `10.1007/978-3-030-32808-5_6`; metadata/abstract | A new proof of McConnel's theorem for full cyclotomic schemes; no accessible statement involving the half-sized induced tournament. |
| M. Xu, *Automorphism groups and isomorphisms of Cayley digraphs* (1998), DOI `10.1016/S0012-365X(97)00152-0`; metadata/abstract | Standard definition and survey context for normal Cayley digraphs; not an exact-family predecessor. |
| D. G. Magsino, D. G. Mixon, H. Parshall, *Linear programming bounds for cliques in Paley graphs* (2020), arXiv `1907.05971`; previously full-read | Their “local Paley graph” is an undirected circulant used for theta/Fourier bounds.  It is a method neighbor, not the directed local automorphism theorem. |

## Search and citation-graph audit

Web/title searches covered the exact combinations “Paley tournament” with
`first subconstituent`, `out-neighborhood`, `induced on quadratic residues`,
`automorphism`, `normal Cayley`, and `directed regular representation`; cyclic
and circulant tournament automorphism literature; and Fourier/constant-modulus
Sidon formulations.  The searches found the 2026 Javier--Llano--Zuazua paper
only when the neighborhood phrase was broadened beyond automorphisms.  Searches
also found Ponomarenko's cyclic-tournament isomorphism work and Xu's
vertex-transitive (pq)-tournament classification, but neither title/abstract
targets the Paley quadratic-residue neighborhood or local extension.

Pinned citation checks on 2026-08-08 were:

- OpenAlex DOI resolutions: Javier--Llano--Zuazua `W7132843934` (0 citing),
  Goldberg `W2327985301` (6 citing), Jones `W2583798106` (record count 8;
  `cites:` result count 9), and Muzychuk `W2998904355` (1 citing).
  All six Goldberg titles, all nine returned Jones titles, and Muzychuk's sole
  citing paper (Yip 2024) were screened.  None states the local automorphism or
  extension theorem.
- Crossref pinned DOI `is-referenced-by-count` values were respectively
  0, 4, 9, and 1.  Exact bibliographic queries
  `Paley tournament out-neighborhood automorphism`,
  `Paley tournament first subconstituent automorphism`, and
  `constant modulus Fourier support Sidon` returned no title matching the
  theorem or the flat-Sidon lemma.
- Semantic Scholar pinned DOI lookups returned 6 citations for Goldberg and
  44 for Jones.  The Javier--Llano--Zuazua and Muzychuk DOI calls returned
  HTTP 429, so no repeated retries were made.
- Exact web-domain queries against zbMATH, MathSciNet, and Semantic Scholar
  produced no indexed result for the local statement.  This is not an
  exhaustive institutional database search; Google Scholar was not used.

The largest general-background graph, Xu 1998 (OpenAlex 287), was not treated
as an exact negative seed: its abstract is a survey of Cayley-digraph
normality/isomorphism, and its forward set is too broad to discriminate this
Paley connection set.  The enumerated negative-seed graphs above are the
statement-nearest sources and were screened in full at the title level.

## Publication use

The theorem can lead the hard algebraic portion of the Clebsch companion, but
the introduction must credit Javier--Llano--Zuazua for the prime-field
circulant-neighborhood observation and Goldberg for the full-tournament group.
The clean novelty sentence belongs in one place only:

> To our knowledge, this is the first determination of the full automorphism
> group of a Paley tournament's first subconstituent; equivalently, it shows
> that every automorphism of an out-neighbourhood extends uniquely to the
> stabilizer of its base vertex in the full Paley tournament.

Do not advertise “the local Paley tournament is circulant” as new.  State
normality, group order, prime-field DRR, and primitive-eigenblock coordinate
recovery together as corollaries of the exact group theorem.  Present the flat
Sidon lemma as an elementary lemma, with no originality adjective.

The best working title remains *Local-to-global rigidity in Paley tournaments
and exterior arcs of conics*.  The exact theorem has passed this focused
covered-source audit, but manuscript allocation still waits on the independent
primitive-Jacobi proof audit, proof consolidation, and primary citations for
the standard finite-field inputs.

## Connections to the existing paper series

The connection map is useful precisely because it prevents the new theorem
from being retrofitted into papers that do not need it.

| paper | connection | dependency decision |
|---|---|---|
| Clebsch Paper I, `clebsch-rigidity` | Direct problem-level continuation.  Paper I proves the (q=11) six-arc rigidity and a general conic-filling window; C756's saturated-exterior classification answers a uniform boundary case of the all-(k) question.  The local Paley theorem is the hard rigidity engine in that new classification. | The existing Paper I proof does **not** depend on it.  Cite Paper I for the motivating conic-filling problem; do not revise Paper I to import the new machinery. |
| Clebsch Paper II, `clebsch-factorization` | Direct structural echo.  Its “Paley carrier” remark identifies the matching configuration's cross-sheet incidence with the support of ({0}\cup(\mathbb F_q^*)^2) and the bordered Paley Hadamard matrix.  C756 now classifies the automorphisms of the unbordered directed first-subconstituent carrier in the (q\equiv3\pmod4) branch. | A short cross-reference is appropriate in the future companion.  The factorization paper's Gorenstein and rank arguments do not need the local automorphism theorem. |
| Clebsch Paper III, `clebsch-passages`, and the golden conference programme | Methodological only.  Both use conference-sign orientation and small spectral blocks, but Paper III's golden symmetric order-six operator is not the (q\equiv3\pmod4) local Paley tournament. | Do not claim a theorem transfer.  At most mention the shared “one signed operator exposes rigidity” motif in exposition outside either proof. |
| Clebsch Paper IV, `q13-passant-code` | Strong geometric interface but no direct specialization: both study conic polarity, passant joins, local signed/association structures, and reconstruction from a small spectral object.  However (13\equiv1\pmod4), so there is no Paley tournament (P(13)) to which the C756 theorem applies. | Paper IV remains the home of the (q=13) internal/passant-code reconstruction.  The future companion may cite it as the saturated-internal interface, not as evidence for local Paley rigidity. |
| Frobenius-pair/MDS--CSS spin-offs | Only a vocabulary-level overlap through semilinear Frobenius actions.  Their quadratic-extension carriers have different objects and hypotheses. | No dependency or citation is needed merely because Frobenius occurs in both. |

At the (q=11) endpoint, the theorem specializes to
(operatorname{Aut}(P(11)[S])\cong C_5).  This is the cyclic rigidity left
after fixing the normalized matching edge in the exterior-arc proof.  It is
compatible with the Clebsch hexagon's (A_5) symmetry, whose Sylow-(5)
subgroups are cyclic.  The later rooted-bordering construction in
`notes/2026-08-08-c894-rooted-conference-completion-and-exact-sequence.md`
shows that the tournament does recover the abstract conference switching
completion and its full \(A_5\).  It still does not recover the identification
with the original projective Clebsch configuration.  This is a useful
forgetting/reconstruction bridge, not another headline theorem claim.

## EJ + TT closeout

**EJ.**  The recent closest predecessor improves the exposition: begin from
the already published prime-field multiplicative circulant model, then explain
that the new content is rigidity of *all* its permutations and unique
extension.  This makes the theorem boundary sharper and avoids spending
novelty capital on a one-line Cayley observation.

**TT.**  The local theorem should be packaged as restriction-is-an-isomorphism:
the stabilizer of (0) in the full Paley group restricts isomorphically onto
the automorphism group of (P(q)[S]).  The exact group formula, normality,
DRR, and coordinate reconstruction then become four views of one result rather
than four claims requiring separate promotion.

## Mystery ledger

| mystery | status | exact boundary / next owner |
|---|---|---|
| Is the local tournament known to be circulant? | settled positive in prime fields | cite Javier--Llano--Zuazua, Proposition 4.4; do not claim novelty |
| Is its full automorphism group already determined? | no predecessor located in covered sources | qualified candidate novelty; human MathSciNet/Scopus check remains |
| Is unique local-to-global extension already stated? | no predecessor located in covered sources | use as the conceptual theorem statement with “to our knowledge” |
| Is normality a separate theorem? | no | immediate from (S\triangleleft S\rtimes\operatorname{Gal}) |
| Is prime-field DRR a separate novelty claim? | no | standard terminology for the (n=1) corollary |
| Is the flat Sidon lemma new? | deliberately not claimed | elementary proof device; no exact source found, but folklore risk dominates |
| Does this audit release a manuscript task? | not by itself | first consolidate the proof and independently audit the primitive-Jacobi collision lemma |
