# C649 — Literature and novelty audit for general stabilizer-AME rigidity

**Lane:** `ame-lu`

**Date:** 2026-07-25

**Status:** complete; qualified promotion posture authorized

## Summary verdict

The enlarged theorem survives the audit, but two parts of its surrounding
story already have close or exact precedents.

For qubits, the conclusion is already a consequence of the
Rains--Van den Nest minimal-support argument.  More recently, Tan computed
the complete local symmetry group of the canonical four-qutrit AME state.
His displayed generators have local qutrit-Clifford factors, so his result
contains the \(q=3,m=2\) **automorphism** subcase of C649, although it is not
formulated as an LU-to-LC theorem and does not classify intertwiners between
arbitrary stabilizer AME representatives.

No source located in the recorded search states the uniform result for every
prime power \(q\), every \(m\geq2\), and arbitrary additive stabilizer
\(\operatorname{AME}(2m,q)\) states:

> every product-unitary intertwiner has every one-site factor in the
> corresponding Clifford normalizer.

The defensible contribution is therefore the all-prime-power, all-length,
arbitrary-additive theorem and its short full-Weyl proof.  It is not the first
qubit result, not the first qudit AME symmetry calculation, and not a new
quantum-MDS weight enumerator.

The support cardinalities also recover a standard formula.  Specializing
Huber--Grassl's Shor--Laflamme weight distribution for general quantum MDS
codes gives the entire projective stabilizer weight enumerator of a
stabilizer AME state, including
\[
 A_{m+1}=\binom{2m}{m+1}(q^2-1).
\]
This is a consistency check, not an additional novelty claim.  What the
enumerator does not by itself express is the coordinatewise projection
bijection that exposes all local Weyl axes and drives LU rigidity.

The same support profile cheaply implies that the \((m+1)\)-supported
subgroups generate the full projective stabilizer label group.  This is best
treated as the additive-QMDS version of the standard minimum-weight
generation phenomenon, not as another novelty claim.  Its real expository
value is that the overlapping projection bijections form a Pauli-label
transition atlas: operator pushing becomes a compatible family of local
coordinate changes, and the finite holonomies computed in the prime-field
\(m=3\) specialization are its concrete conjugacy data.

The AME/QMDS Choi correspondence and perfect-tensor operator pushing are also
established ideas.  C649's encoder statement should be presented as an
operational corollary: no exact predecessor was located for factorwise
Cliffordness of every product-unitary conversion between arbitrary
stabilizer \([[2m-1,1,m]]_q\) quantum-MDS encoders.

Fourteen individually discussed sources were consulted: **three at
`full text` and eleven at `partial`**.  The negative remains qualified by the
coverage gaps below.

## Exact claim decomposition

| Claim | Precedence verdict | Recommended posture |
|---|---|---|
| Every LU intertwiner between arbitrary stabilizer \(\operatorname{AME}(2m,q)\) states, \(m\geq2\), is factorwise Clifford, for every prime power \(q\) | No exact theorem located.  The qubit case is inherited from Van den Nest et al.; Tan contains the canonical four-qutrit automorphism subcase. | State the theorem directly.  If priority language is desired, use only “to our knowledge” and the exact all-prime-power, all-\(m\), arbitrary-additive scope. |
| For \(|A|=m+1\), the supported projective stabilizer has \(q^2\) labels and projects bijectively to every local \(q^2\)-element Pauli-label group | The cardinality and exact-support counts are consequences of the standard QMDS weight distribution.  No located source isolates the local projection bijection as an LU-rigidity lemma. | Present as the structural lemma that makes the Rains--Van den Nest axis method work for qudits, not as a separately advertised priority claim. |
| For every \(A\), \(|L(A)|=q^{2\max(0,|A|-m)}\), hence the full stabilizer weight enumerator is fixed | Huber--Grassl Theorems 8--9 give the general QMDS unitary and Shor--Laflamme weights; the stabilizer-state formula is their specialization. | Explicitly identify this as the standard QMDS enumerator or a recovery of it. |
| \(L(A)=L(A\setminus\{i\})+L(A\setminus\{j\})\) for distinct \(i,j\in A\), \(|A|\ge m+2\), so the \((m+1)\)-supported subgroups generate the full label group | This is an immediate dimension consequence of the support profile and is closely analogous to standard generation of MDS codes by minimum-weight words.  Van den Nest et al.'s minimal-support subgroup is the closest LU--LC antecedent found; no exact arbitrary-additive AME statement was located. | Include as a cheap structural corollary if it clarifies the proof or the transition-atlas picture, but do not advertise it as a separate novelty theorem. |
| Every product-unitary conversion between stabilizer \([[2m-1,1,m]]_q\) QMDS encoders is factorwise Clifford, including the logical factor | No exact predecessor located.  Tan proves the general even-party AME/QMDS LU-orbit correspondence and symmetry/transversal relation, but not the stabilizer factorwise-Clifford conclusion. | State as a corollary of C649 under the standard Choi/perfect-tensor correspondence, not as a second independent headline. |
| Every local Pauli has a unique product-Pauli push onto any chosen \(m\) of the other parties | Perfect-tensor operator pushing is standard, and Pastawski et al. explicitly describe Pauli pushing for perfect stabilizer tensors.  C649 supplies the support-minimal, every-chosen-\(m\)-set uniqueness statement. | Use “operator pushing” as conceptual framing and credit Pastawski et al.; make no novelty claim for the general idea. |

## Closest prior art

### Qubit minimal-support rigidity

Rains's Theorem 13 recovers the three Pauli axes from a diagonal correlation
tensor and concludes that the relevant qubit code automorphisms are Clifford.
Van den Nest, Dehaene, and De Moor turn this into an LU-to-LC criterion for
qubit stabilizer states: if all three nonidentity Pauli labels occur at every
site in the subgroup generated by minimum-support stabilizers, every local
factor of an LU equivalence is Clifford.

For a qubit stabilizer \(\operatorname{AME}(2m,2)\), the C649 support lemma
supplies exactly those three labels on every \((m+1)\)-party minimum support.
Thus the \(q=2\) case of C649 is an application of their theorem, not a new
result.

### The four-qutrit local symmetry calculation

Tan proves a general bijection between LU orbits of even-party AME tensors and
LU orbits of the associated QMDS codes (Theorem 3.5), relates local tensor
symmetries to transversal code gates (Theorem 3.6), and computes the complete
local symmetry group of the canonical \(\operatorname{AME}(4,3)\) state
(Theorem 5.3).

Tan does not label the generators as Clifford.  The following is the auditor's
inference from his displayed matrices.  The monomial factors are standard
qutrit Clifford matrices.  For the only nonmonomial one,
\[
 H_\triangle=\frac{e^{\pi i/6}}{\sqrt3}
 \begin{pmatrix}
 \omega&1&1\\1&\omega&1\\1&1&\omega
 \end{pmatrix},
 \]
direct conjugation gives
\(H_\triangle XH_\triangle^\dagger=X\) and
\(H_\triangle ZH_\triangle^\dagger\doteq XZ\).
Hence all five tensor generators in Tan's Figure 2 have local Clifford
factors.  This proves factorwise Cliffordness for automorphisms of that
canonical state.

This is a genuine direct qudit subcase of C649 and should be cited.  It does
not give the arbitrary-prime-power theorem, the arbitrary-\(m\) theorem, or
by itself the LC equivalence of all stabilizer representatives in the unique
four-qutrit LU orbit.

### Qudit stabilizer and graph-state equivalence

Bahramgiri--Beigi show that prime-dimensional qudit stabilizer states admit
graph-state representatives under local Clifford operations and classify
local-*Clifford* graph equivalence by graph moves.  Helwig applies this
formalism to AME graph states and gives an efficient AME criterion.  Ketkar
et al. provide the arbitrary-additive, prime-power stabilizer-code
correspondence used by C649.  None of these sources addresses arbitrary
one-site unitaries or proves that an LU intertwiner must be Clifford.

Englbrecht--Kraft--Kraus extend party-local stabilizer transformations and
decomposition theory to prime-dimensional qudits.  Their local parties may
contain multiple qudits; their qudit result concerns uniqueness of an
entanglement-generating-set decomposition, not C649's single-qudit
LU-to-LC statement.

### General AME equivalence

Burchardt--Raissi and Ramadas--Lakshminarayan study LU/SLOCC equivalence of
general or minimal-support AME states.  Their results allow non-Clifford
monomial/Butson factors or infinitely many LU classes in the applicable
families.  They do not conflict with C649 because C649 assumes a stabilizer
state.  Rather et al. prove uniqueness of the four-qutrit AME LU orbit and
infinitely many four-party AME LU classes for larger local dimensions; they
do not prove stabilizer LU-to-LC rigidity.

### The weight enumerator is standard

For a stabilizer AME state let \(L(A)\) be the projective stabilizer labels
supported inside \(A\).  Stabilizer entropy and maximal mixedness give
\[
 |L(A)|=q^{2\max(0,|A|-m)}.
\]
Möbius inversion therefore gives the number of labels of exact support \(S\),
where \(r=|S|\), as
\[
 N_S=\sum_{j=0}^{r}(-1)^{r-j}\binom rj
       q^{2\max(0,j-m)},
\]
and the total weight coefficient is
\[
 A_r=\binom{2m}{r}N_S.
\]
At \(r=m+1\), this reduces to
\[
 A_{m+1}=\binom{2m}{m+1}(q^2-1).
\]

Huber--Grassl Theorem 9 gives
\[
 A_r(\Pi_Q)=\binom nr\sum_{j=0}^{r}(-1)^{r-j}\binom rj
 D^{\,2k+j-\min(2\alpha-j,j)}
\]
for a general QMDS code \(((n,D^k,d))_D\), with
\(\alpha=(n+k)/2\).  Setting \(n=2m\), \(k=0\), and \(D=q\)
gives exactly the formula above.  For a stabilizer pure state these
Shor--Laflamme weights count projective stabilizer labels because the
stabilizer Weyl coefficients have unit modulus.

Thus the whole enumerator, not only its first free coefficient, is known.
C649's useful extra structure is that on each \((m+1)\)-set the \(q^2\)
labels project *bijectively* to every retained local Pauli group.  This
turns an aggregate weight statement into a complete set of intrinsic local
axes.

### Minimum-support generation and a transition atlas

The full profile has a further nearly free consequence.  Write
\(q=p^e\), so dimensions below are over \(\mathbb F_p\).  If
\(|A|=r\ge m+2\) and \(i\ne j\) lie in \(A\), then
\[
\begin{aligned}
\dim L(A\setminus\{i\})&=\dim L(A\setminus\{j\})
   =2e(r-m-1),\\
\dim\!\left(L(A\setminus\{i\})\cap L(A\setminus\{j\})\right)
   &=\dim L(A\setminus\{i,j\})
   =2e\max(0,r-m-2).
\end{aligned}
\]
The dimension formula for a sum therefore gives
\[
 L(A)=L(A\setminus\{i\})+L(A\setminus\{j\}).
\]
Descending induction shows that all \((m+1)\)-supported subgroups together
span the full projective stabilizer label group.

This resembles the standard minimum-weight generation property of MDS
codes.  The closest LU--LC source found is Van den Nest et al.'s use of the
subgroup generated by minimal-support stabilizers, but the bounded search
did not locate an exact statement of the displayed equality for arbitrary
additive stabilizer AME states.  The safe posture is consequently “cheap
consequence of the support profile,” not “new generation theorem.”

Conceptually, every \((m+1)\)-support supplies bijective Pauli-label
coordinates at each of its sites.  Overlapping supports therefore supply
transition maps between local Pauli-label groups.  Their compositions around
overlap cycles are a natural operator-pushing holonomy.  This gives a clean
atlas interpretation of the finite holonomies in the prime-field \(m=3\)
specialization: the reported 450 classes are concrete conjugacy data for
that atlas, rather than an unrelated computation.  This is an expository
connection, not a separately audited priority claim.

### Choi encoders and operator pushing

Pastawski et al. define a perfect tensor as an isometry across every balanced
cut, introduce operator pushing through an isometric tensor in their
Eq. (2.3), and explain that a \(2m\)-leg perfect tensor is a
\([[2m-1,1,m]]\) encoding map.  In their stabilizer construction, Clifford
isometries push Pauli operators to product Paulis.  Tan later makes the
even-party AME/QMDS LU-orbit and symmetry/transversal correspondences
explicit.

C649 sharpens this familiar picture for a stabilizer perfect tensor: after
choosing one input party and any \(m\) of the other parties, each input Pauli
label has a unique supported stabilizer and hence a unique product-Pauli push
onto that chosen \(m\)-set.  This is excellent conceptual framing, but the
paper should credit operator pushing rather than present the idea as new.

For two stabilizer encoding isometries \(V_\psi,V_\phi\), a product conversion
\[
 (U_1\otimes\cdots\otimes U_{2m-1})V_\psi=V_\phi L
\]
becomes a product-unitary equivalence of their AME Choi states, with the
usual inverse-transpose/conjugate convention on the logical leg.  C649 then
forces \(L\) and every \(U_i\) to be Clifford.  The searches below located
general code-conversion schemes and transversal-gate restrictions, but no
source stating this exact all-prime-power stabilizer-QMDS conversion theorem.

## Recommended manuscript positioning

Recommended compact paragraph:

> Rains recovered the three Pauli axes from a diagonal correlation tensor,
> and Van den Nest, Dehaene, and De Moor used this mechanism to obtain a
> minimal-support LU-to-LC criterion for qubit stabilizer states.  Tan
> recently related the LU orbits and local symmetries of even-party AME
> tensors to quantum-MDS codes and computed the local symmetry group of the
> four-qutrit AME tensor.  We show that the AME condition itself supplies
> the full-Weyl marginal required by the same axis-recovery mechanism for
> every prime-power stabilizer state: on each \(m+1\) party support, the
> supported stabilizer projects bijectively onto every local Weyl basis.
> Hence every LU intertwiner between stabilizer
> \(\operatorname{AME}(2m,q)\) states, \(m\ge2\), is factorwise Clifford.

Recommended operational corollary:

> Under the perfect-tensor/quantum-MDS Choi correspondence, every
> product-unitary conversion between stabilizer
> \([[2m-1,1,m]]_q\) encoders has a Clifford logical factor and Clifford
> physical factors.

Recommended operator-pushing bridge:

> Equivalently, the supported-stabilizer bijection gives a
> support-minimal Pauli form of perfect-tensor operator pushing: every input
> Weyl operator has a unique product-Weyl representative on any chosen
> \(m\) output parties.

Recommended enumerator sentence, if the count is retained:

> Möbius inversion recovers the standard quantum-MDS Shor--Laflamme weight
> distribution; in particular
> \(A_{m+1}=\binom{2m}{m+1}(q^2-1)\).

Forbidden or unsupported wording:

- “the first stabilizer-AME LU-to-LC theorem” without an exact scope
  qualifier;
- “the first qudit AME state with only Clifford local symmetries”;
- “a new quantum-MDS weight enumerator”;
- “the first AME/QMDS Choi or operator-pushing correspondence”;
- “all AME states satisfy LU=LC”;
- “all stabilizer states satisfy LU=LC”;
- arbitrary local dimension rather than prime-power \(q\) with the stated
  Pauli/Weyl convention;
- inclusion of \(m=1\); or
- an unqualified “first” claim while the database gaps below remain open.

The safest and strongest posture is to avoid priority language entirely:
state the exact theorem, credit its qubit and four-qutrit predecessors, and
let the removed hypotheses carry the significance.

## Search record

All new searches were run on 2026-07-25.  Search-result screening used
titles, abstracts when present, and full metadata.  The mechanical
discriminator for the main OpenAlex set was:

> Retain a candidate when its title or abstract contains at least one of
> `stabilizer`, `absolutely maximally entangled`, `perfect tensor`, or
> `quantum MDS`, and at least one of `local unitary`, `local Clifford`,
> `local symmetr`, or `transversal`; inspect the retained abstract for a
> theorem about arbitrary single-site LU factors.

### Inherited C562 closure

C562 exhaustively screened the OpenAlex keyword set
`"local unitary" "local Clifford" qudit stabilizer` (84 records), the
sets `"minimal support" qudit stabilizer Clifford` (10) and
`AME MDS CSS "local unitary" Clifford` (2), and the three-service forward
graphs of the Rains, Van den Nest et al., and Burchardt--Raissi seeds.
The recorded citing counts were respectively:

| Seed | OpenAlex | Crossref | Semantic Scholar | Largest screened set |
|---|---:|---:|---:|---|
| Rains, DOI `10.1109/18.746807` | 82 | 48 | 80 | all 82 OpenAlex records |
| Van den Nest et al., DOI `10.1103/PhysRevA.71.062323` | 61 | 37 | 67 | all 67 Semantic Scholar records |
| Burchardt--Raissi, DOI `10.1103/PhysRevA.102.022413` | 23 | 20 | 19 | all 23 OpenAlex records |

Those sets were screened over title, abstract, and the metadata fields
specified in C562.  They remain useful coverage of the qubit and AME
lineages, but they do not substitute for the new search: notably, Tan's
2026 paper was not present in the new OpenAlex keyword returns and was found
through the web/arXiv search.

### New OpenAlex searches

Endpoint: `https://api.openalex.org/works`, relevance order, fields
`id,doi,title,publication_year,abstract_inverted_index`.

| Verbatim `search` value | Raw count | Screened | Outcome |
|---|---:|---:|---|
| `"local unitary" "local Clifford" qudit stabilizer AME` | 16 | 16 | No exact theorem. |
| `"stabilizer AME" "local unitary"` | 10 | 10 | No exact theorem. |
| `"minimal support" qudit stabilizer Clifford` | 10 | 10 | Recovered adjacent graph/stabilizer literature, not arbitrary qudit LU rigidity. |
| `"perfect tensor" stabilizer local symmetry Clifford` | 28 | 28 | Operator-pushing, tensor-network, and symmetry applications; no exact theorem. |
| `additive quantum MDS stabilizer local unitary equivalence` | 14 | 14 | Coding and AME constructions; no exact theorem. |

The five responses contained 68 unique records after OpenAlex-ID
deduplication.  The mechanical discriminator retained seven abstract-level
candidates.  Their abstracts concerned symplectic/LC code isometries,
tensor-network constructions, an AME review, graph-state constructions, or
holographic-code constraints; none stated arbitrary single-site LU
factorwise Cliffordness.  Every nonempty set was screened to exhaustion.

The encoder-conversion check used:

| Verbatim `search` value | Raw count | Screened | Outcome |
|---|---:|---:|---|
| `"quantum MDS" encoder conversion "local Clifford"` | 1 | 1 | No exact product-unitary conversion theorem. |
| `"perfect tensor" transversal "local Clifford" stabilizer` | 5 | 5 | Perfect-tensor and tensor-network constructions, not the claimed factorwise restriction. |
| `stabilizer quantum MDS Choi local unitary Clifford transversal` | 4 | 4 | No exact theorem. |
| `"[[2m-1,1,m]]" stabilizer` | 1 | 1 | No exact theorem. |

These four responses contained ten unique records after OpenAlex-ID
deduplication.

Every successful OpenAlex response was valid JSON whose returned array
length agreed with `meta.count` because each count was below the requested
page size.  Zero and error responses were therefore distinguishable; none
of the recorded OpenAlex queries errored.

### Broad web/arXiv discovery

The web index was searched with the following exact queries and the returned
titles/snippets were screened:

```text
site:arxiv.org qudit stabilizer "minimal support condition" local unitary local Clifford
site:arxiv.org qudit stabilizer state "local unitary" "local Clifford" prime dimension
site:arxiv.org nonbinary stabilizer "LU-LC" equivalence
site:arxiv.org stabilizer AME "local unitary" Clifford equivalence
"minimal support" stabilizer qudit local Clifford unitary
"minimal support condition" stabilizer states qudit
"full Pauli" stabilizer AME local unitary
"absolutely maximally entangled" stabilizer "local Clifford"
"Transversal gates of the ((3,3,2)) qutrit code"
"local symmetry group" stabilizer AME qudit Clifford
"local symmetries" stabilizer "perfect tensor" Clifford
"quantum MDS" encoder conversion "local Clifford"
stabilizer quantum MDS Choi state local unitary Clifford transversal conversion
site:arxiv.org stabilizer perfect tensor operator pushing Pauli unique
site:arxiv.org perfect tensor "operator pushing" stabilizer
"MDS code generated by minimum weight codewords theorem"
"additive MDS code generated by minimum weight codewords"
"quantum MDS stabilizer generated by minimum weight stabilizers"
"stabilizer AME generated by minimal support stabilizers"
```

These searches located Tan's direct four-qutrit result, the
Bahramgiri--Beigi and Helwig qudit graph-state literature, the general
nonbinary stabilizer formalism, Huber--Grassl's QMDS enumerator, and
Pastawski et al.'s operator-pushing formulation.  The four final
minimum-weight-generation queries did not locate an exact arbitrary-additive
stabilizer-AME statement.

### zbMATH Open

The attempted endpoint
`https://api.zbmath.org/v1/document/_search` returned HTTP 404 for each of:

```text
stabilizer AME local unitary Clifford
qudit stabilizer local unitary equivalence
quantum MDS transversal Clifford
```

These query families are **NOT COVERED**, not empty results.

No new forward-citation enumeration was used as the basis of a negative, so
the three-service citation-graph rule was not triggered beyond the inherited
C562 closure.

## Individually discussed sources and read depth

1. **Eric M. Rains, *Quantum Codes of Minimum Distance Two*.**
   **Read depth: `partial`.** Inherited from C562: cached arXiv v1,
   abstract and complete “Automorphisms and equivalences” section,
   especially Theorem 13, Corollary 14, and proofs.  Cache
   `arXiv:quant-ph/9704043v1`, SHA-256
   `ad906a12c2a5ac65e6efa575d72b94b7dd65bcb7d435145284ea8eb26dad3a4c`.
   The cached bytes are the preprint, not the published DOI version.

2. **M. Van den Nest, J. Dehaene, and B. De Moor, *Local Unitary versus
   Local Clifford Equivalence of Stabilizer States*.**
   **Read depth: `full text`.** Inherited from C562: all eight pages of
   arXiv v2, including Theorem 1, Lemma 2, Corollary 1, appendices, and
   references.  Cache `arXiv:quant-ph/0411115v2`, SHA-256
   `c0f8e192552369d5af9304ebf08995f59b6917e243a570f37ff1b29f3b4cb735`.

3. **M. Englbrecht and B. Kraus, *Symmetries and Entanglement of
   Stabilizer States*.**
   **Read depth: `partial`.** Inherited from C562: arXiv v1 introduction,
   Theorem 2 and its surrounding discussion, and the scope of discrete and
   continuous qubit local symmetries.  Cache `arXiv:2001.07106v1`,
   SHA-256
   `fecef9717dbf5807c3d6d7890c16c7bc2c89ac60c85003c14355929b1ffc1cac`.

4. **A. Burchardt and Z. Raissi, *Stochastic Local Operations with
   Classical Communication of Absolutely Maximally Entangled States*.**
   **Read depth: `partial`.** Inherited from C562: arXiv v2 Sections
   III--IV, Propositions 2 and 5--7, Remark 1, the dimension table, and the
   relevant Appendix-C reductions.  Cache `arXiv:2003.13639v2`, SHA-256
   `7b38bd6a5bd8fb8299863e5ca3c7f64dfadd51a12f1b865edbbcbc3d4847a9e3`.

5. **N. Ramadas and A. Lakshminarayan, *Local Unitary Equivalence of
   Absolutely Maximally Entangled States Constructed from Orthogonal
   Arrays*.**
   **Read depth: `partial`.** Inherited from C562: arXiv v1 introduction,
   Sections 5--6, Theorems 1--3, the \(\operatorname{AME}(6,d)\)
   application, conclusion, and relevant references.  Cache
   `arXiv:2411.04096v1`, SHA-256
   `a73e8c2c48c2d55f07b1e34bc75ba0d18c7115ec4e65d412605f52bf7430c647`.

6. **M. Englbrecht, T. Kraft, and B. Kraus, *Transformations of
   Stabilizer States in Quantum Networks*.**
   **Read depth: `partial`.** Inherited from C562: arXiv v2 abstract,
   introduction, roadmap, and the prime-dimensional qudit scope in
   Section 4.  Cache `arXiv:2203.04202v2`, SHA-256
   `5847bfeb98ff67d4e87802598c2efda39e66c9b2336f59b1bcf614167071025c`.

7. **Mohsen Bahramgiri and Salman Beigi, *Graph States Under the Action
   of Local Clifford Group in Non-Binary Case*.**
   **Read depth: `partial`.** Cached arXiv v2; read the abstract,
   introduction, Theorem 5 and its setup, and conclusion.  Cache
   `arXiv:quant-ph/0610267`, SHA-256
   `c3f8ae13be712936fd823c96d070d0afddf48b1f18ddf879441a8c4512f0b4db`.

8. **Wolfram Helwig, *Absolutely Maximally Entangled Qudit Graph
   States*.**
   **Read depth: `partial`.** Cached arXiv v1; read the abstract,
   introduction, stabilizer/LC setup in Section 2, the bipartite criterion
   including Theorem 7, and Section 6.  Cache `arXiv:1306.2879`,
   SHA-256
   `56b80b1e7d007388219d2c44d1b0921f3d4e0cf50fe360759ed22641c9655a3f`.

9. **Suhail Ahmad Rather, N. Ramadas, Vijay Kodiyalam, and Arul
   Lakshminarayan, *Absolutely Maximally Entangled State Equivalence and
   the Construction of Infinite Quantum Solutions to the Problem of 36
   Officers of Euler*.**
   **Read depth: `partial`.** Cached arXiv v2; read the abstract,
   introduction, Section III and Theorem 1 on the four-qutrit LU orbit,
   and the statement and setup of Section V's Theorem 2.  Cache
   `arXiv:2212.06737`, SHA-256
   `740ee6e03fcd77f320ff03233f6b9ab0a7fba32781aa0cac40b5e88ed0465655`.

10. **Ian Tan, *Transversal Gates of the \(((3,3,2))\) Qutrit Code and
    Local Symmetries of the Absolutely Maximally Entangled State of Four
    Qutrits*.**
    **Read depth: `full text`.** Cached arXiv v2; all 19 pages were read,
    including Theorems 3.5--3.6, 5.1, and 5.3, the displayed generators,
    conclusion, and references.  Cache `arXiv:2601.19677`, SHA-256
    `460f398f1fe63aa347f2457e44c0fe12d1164bdc33a25ee3f44ce3805d4f48e6`.
    Publisher metadata gives DOI `10.1007/s44464-026-00021-z`; the
    published text was not read.

11. **Eric M. Rains, *Nonbinary Quantum Codes*.**
    **Read depth: `full text`.** Cached arXiv v1; all eleven pages were
    read, including the prime-field symplectic construction, quantum-MDS
    sections, shortening, and universal fault-tolerant operations.  Cache
    `arXiv:quant-ph/9703048v1`, SHA-256
    `d97559db6fd164b7aeab176987c32c286eb429bd18fd82be0a44bc5c31f1c7fd`.

12. **A. Ketkar, A. Klappenecker, S. Kumar, and P. K. Sarvepalli,
    *Nonbinary Stabilizer Codes over Finite Fields*.**
    **Read depth: `partial`.** Cached arXiv v2; read the abstract,
    introduction, and Section 4 through Theorems 13 and 15, including the
    trace-symplectic and trace-alternating additive-code correspondences.
    Cache `arXiv:quant-ph/0508070`, SHA-256
    `138154de23946d0d6344ba19e1f42b9313b14b02b4ff348ccbe0d7781ca34a4c`.

13. **Felix Huber and Markus Grassl, *Quantum Codes of Maximal Distance
    and Highly Entangled Subspaces*.**
    **Read depth: `partial`.** Cached arXiv v2; read the abstract,
    introduction, Section 8, Theorems 8--9, their Möbius-inversion
    derivation, and the AME-parent discussion.  Cache
    `arXiv:1907.07733v2`, SHA-256
    `c4e5dfba9f8ccbb3f496c956c96cc83cc9bb2c117f23e0a05be639153d444e94`.
    The cached bytes are the preprint corresponding to the Quantum
    publication, not a separately downloaded publisher PDF.

14. **Fernando Pastawski, Beni Yoshida, Daniel Harlow, and John
    Preskill, *Holographic Quantum Error-Correcting Codes: Toy Models for
    the Bulk/Boundary Correspondence*.**
    **Read depth: `partial`.** Cached arXiv v2; read the introduction,
    Section 2's definition of perfect tensors and Eq. (2.3) operator
    pushing, Section 5.7 on perfect stabilizer tensors and Clifford
    isometries, and the relevant five-qubit/six-qubit discussion in
    Appendix A.1.  Cache `arXiv:1503.06237v2`, SHA-256
    `55572e7133514f4adc54f5bfb025111fc3fcb911c87ca22bae0a9e30955d1e05`.

## Coverage gaps and strength of the negative

- **MathSciNet: NOT COVERED.** Institutional authentication was not
  available.
- **Google Scholar: NOT COVERED.** Automated access was unavailable.
- **zbMATH Open: NOT COVERED for the three new query families.** The
  attempted API endpoint returned HTTP 404; this licenses no zero.
- **Publisher versions:** Tan and several older sources were read from
  arXiv versions.  No claim is made that the published versions are
  textually identical.
- **Index lag:** the most important newly located source, Tan (May 2026
  arXiv v2), was not returned by the recorded OpenAlex keyword searches.
  This demonstrates that the database negative cannot stand without the
  web/arXiv discovery layer.
- **Language and venue coverage:** the search covered English-language
  indexed records and the recorded web results, not every conference
  proceeding, thesis bibliography, or non-English database.
- **No new citation-graph closure:** the C562 graph closure was reused;
  no complete forward graph was enumerated for the 2026 Tan paper.

Within these limits, the strongest defensible negative is:

> No exact predecessor was located in the recorded search for the uniform
> all-prime-power, all-\(m\ge2\), arbitrary-additive stabilizer-AME
> factorwise LU-to-LC theorem or its stabilizer-QMDS encoder-conversion
> corollary.

This does not support an absolute “first” claim.

## Significance consequence

The audit narrows, but does not materially deflate, the C649 upgrade.

- The qubit slice was already known.
- The canonical four-qutrit automorphism slice is already implicit in a
  2026 exact symmetry computation.
- The whole weight enumerator is standard QMDS structure.
- Minimum-support generation is a cheap consequence of that profile and
  should not be counted as a separate novelty increment.
- The AME/QMDS Choi bridge and operator-pushing language are established.

What remains is the high-value point: a single elementary support argument
removes CSS form, equal phases, classical linearity, MDS presentation, and
\(\mathbb F_q\)-linearity simultaneously, and it works uniformly over every
prime-power alphabet and every \(m\ge2\).  The local projection bijection
turns standard perfect-tensor pushing into a complete full-Weyl axis
certificate.  Its overlapping charts also organize the specialized
holonomy computations into a single Pauli-transition atlas.  That structural
package is precisely what the earlier general qudit literature does not
state.

The right significance claim is therefore **structural universality inside
the stabilizer-AME class**, not invention of LU-to-LC, operator pushing, or
QMDS enumerators.

## Audit closeout and mystery ledger

The `ej` and Tao-style pass exposed four cheap positioning improvements:

1. cite Tan so that the qutrit special case is not accidentally claimed;
2. identify the whole support enumerator with Huber--Grassl Theorem 9;
3. frame the support bijection as support-minimal stabilizer operator
   pushing, with Pastawski et al. as the conceptual source;
4. use minimum-support generation to connect those pushes into a transition
   atlas, while avoiding a separate novelty claim for the generation fact.

| Mystery | Status | Evidence / remaining gate |
|---|---|---|
| Is the all-prime-power additive theorem already stated? | no exact statement located | recorded OpenAlex, web/arXiv, inherited C562 closure; MathSciNet/Scholar/zbMATH gaps remain |
| Is there a direct nonbinary subcase? | resolved positively | Tan Theorem 5.3 plus direct Clifford check of displayed generators gives the canonical \(q=3,m=2\) automorphism case |
| Is \(A_{m+1}\) new? | resolved negatively | Huber--Grassl Theorem 9 specialization |
| Is the complete weight enumerator new? | resolved negatively | same theorem plus Möbius inversion |
| Is generation by \((m+1)\)-supported subgroups new? | no exact stabilizer-AME statement located, but not safely novel | immediate dimension consequence of the standard support profile; standard MDS minimum-weight generation is a close analogue, and Van den Nest et al. already organize LU--LC arguments around the subgroup generated by minimal supports |
| Is the Pauli-transition atlas/holonomy interpretation known? | no exact formulation located | best used as conceptual synthesis connecting the full-Weyl marginal proof to the existing prime-field holonomy computation, not as an independent theorem |
| Is the encoder conversion a separate novelty crown? | resolved negatively as architecture, open only at exact scope | Choi/AME/QMDS relation is known; factorwise Cliffordness is a corollary of C649, with no exact predecessor located |
| Is operator pushing new? | resolved negatively | Pastawski et al. Eq. (2.3) and stabilizer-isometry discussion |
| Does any genuine mystery remain inside this audit? | no mathematical mystery | only manual database coverage and manuscript proof/formalization gates remain |
