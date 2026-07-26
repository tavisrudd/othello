# C647 — AME--LU post-C562 literature and novelty audit

**Lane:** `ame-lu`

**Date:** 2026-07-25

**Baseline:** C562, commit `546e699f`

**Status:** complete; manuscript positioning repaired; no new priority claim

## Executive verdict

This audit covers every theorem family incorporated into the AME--LU paper
after the last claim-specific audit, C562.  It treats both results newly
proved after C562 and older lane results that entered the paper only after
that audit.

The paper's defensible novelty is the exact synthesis in its stated family:

1. all-prime-power LU-to-LC rigidity for equal-phase CSS states of linear
   `[2m,m,m+1]_q` MDS codes, factor by factor;
2. the Choi consequence for every product-unitary conversion between the
   associated one-logical-qudit quantum MDS encoders;
3. the odd-prime exact fixed-party projective group
   `F_q^2 ⋊ SL_2(q)` exactly on the diagonally isodual branch and
   `F_q^2 ⋊ T` otherwise; and
4. the explicit six-party geometry, extension-field sector algebra, and
   twelve computed party-extension splittings built around that spine.

No exact predecessor for this combined package was located.  Several
individual mechanisms are established prior art and must not be sold as
new:

- axis recovery and factorwise Cliffordness in the qubit case
  (Rains; Van den Nest--Dehaene--De Moor);
- connected local-unitary automorphism groups and projective finiteness for
  binary stabilizer codes (Wirthmüller);
- restrictions on diagonal and inter-code transversal gates for qubit
  stabilizer codes (Anderson--Jochym-O'Connor);
- extracting logical Clifford gates from code automorphisms, including
  phase correction and logical-action computation (Sayginel et al.);
- isometry-dual MDS constructions and self-dual CSS transversal gates;
- finite-field Weil representations and the Heisenberg commutator;
- nonabelian factor sets and splitting criteria from ordinary group
  extension theory; and
- the characteristic-zero six-point GIT/Igusa--Segre geometry.

The paper already avoids firstness.  That remains the right posture:
MathSciNet and Google Scholar were not covered, most 2026 sources were read
only partially, and the zbMATH endpoint failed for four of five new queries.

Seventeen individually discussed sources support this incremental audit:
**six at `full text`, ten at `partial`, and one at
`abstract/metadata only`**.  Earlier claim-specific audits remain the
source of truth for their larger screened sets.

## Claim-by-claim novelty map

| Current paper family | Closest prior art | Incremental verdict and authorized posture |
|---|---|---|
| Six-arc/MDS/CSS/AME dictionary | Standard AME--MDS and stabilizer-code dictionary, already cited and audited before C562 | Background, not novel. |
| Uniform LU-to-LC rigidity and the full-Weyl marginal criterion | Rains Theorem 13; Van den Nest et al. Theorem 1 and Lemma 2 | The mechanism has direct qubit ancestry.  No exact prime-power, all-length, equal-phase MDS/CSS statement was located.  Call it a finite-field/MDS realization of the Rains--Van den Nest mechanism; do not call the mechanism new. |
| Product-unitary encoder conversion and transversal non-Clifford no-go | Anderson--Jochym-O'Connor classify qubit diagonal and inter-code maps; the general transversal-gate no-go literature is much broader | The strong point here is that an *arbitrary* product-unitary conversion in this family is Clifford factor by factor.  No exact predecessor was located, but retain no firstness claim. |
| Projective finiteness and discrete LU symmetry | Wirthmüller Theorem 7 and Corollary 11 determine the connected binary automorphism group and give a protected-qubit finiteness criterion | The general phenomenon is prior art.  Present this paper's result as the prime-power MDS/CSS specialization following from its stronger rigidity theorem. |
| Exact diagonal-isodual group dichotomy | Isometry-dual MDS constructions; binary self-dual CSS Hadamard/phase criteria; Dasu--Burton's qubit multiblock diagonal-Clifford classification | No source located gives the exact odd-prime one-logical-qudit image `F_q^2 ⋊ SL_2(q)` iff diagonal isoduality and `F_q^2 ⋊ T` otherwise for every half-dimensional MDS code.  This is a central exact theorem, but the paper should continue to claim the statement rather than priority. |
| Diagonal multiplier line/nullity test | Hull, isometry-dual, and Schur-product/conductor methods are nearby coding-theory tools | The full-support and one-dimensionality proof is an elementary exact-half-MDS result specialized to the paper's phase question.  No exact predecessor was located.  Keep it as an intrinsic criterion, not as a broad new theory of code hulls. |
| GRS propagation; Weil split versus Heisenberg nonsplit | Grassl--Geiselmann--Beth and Aharonov--Ben-Or for polynomial/RS quantum codes; Gérardin for the genuine odd-field Weil representation | The lift distinction is a correct application of classical representation theory.  It clarifies two extensions that are easy to conflate; it is not a new metaplectic or Heisenberg theorem. |
| Party-moving exact sequence, outer action, normalized factor set, and splitting criterion | Standard nonabelian group-extension theory; Sayginel et al. for code-automorphism logical Cliffords | The abstract extension formalism is standard.  The new content is its exact realization for this family and the computed q-ary data.  Do not claim invention of the cocycle formalism. |
| Twelve computed party-extension splittings and `N(T)` enlargement | General code-automorphism searches and logical-action recovery in Sayginel et al. | No predecessor was located for these twelve exact rows.  Treat them as reproducible finite data and structural examples, not as a general splitting theorem or priority headline. |
| Pencil classification by `z`, H3/GRS separator, q=13 witness, divisor, and transport calculation | Classical six-point invariant theory and the earlier lane-specific audits | Bespoke exact results in the chosen finite-field family.  The current paper makes no independent priority claim, which remains appropriate. |
| Fixed-copy generic constancy | Standard invariant-theoretic rank/generic-minor reasoning | A useful mechanism boundary proved in the paper, not a claim to a new invariant-theory principle. |
| Extension-field Frobenius/Gale sector divisors | Standard semilinear equivalence and Gale association; no exact sector formula located | The formulas appear bespoke.  The paper correctly stops short of a full extension-field Clifford-orbit theorem because two representation-theoretic bridges remain hypotheses. |
| Characteristic-zero GIT interpretation | Howard--Millson--Snowden--Vakil, Section 2.3 | Classical context only.  The finite-field fixed-label phase theorem is an arithmetic slice, and the manuscript correctly says the GIT picture is unused in the proof. |

## Three literature-positioning repairs

The audit caused three compact manuscript changes.

1. Wirthmüller is now cited next to the LU-rigidity ancestry.  This prevents
   the projective-finiteness corollary from appearing to be a new general
   fact about stabilizer automorphism groups.
2. Anderson--Jochym-O'Connor are now cited for qubit diagonal and inter-code
   transversal restrictions.  The manuscript distinguishes their
   Clifford-hierarchy angle classification from the present factorwise
   Clifford theorem for arbitrary product-unitary MDS/CSS conversions.
3. Sayginel et al. are now cited for automorphism-derived logical Cliffords,
   Pauli phase correction, and logical-action recovery.  The manuscript
   distinguishes that computational program from its exact projective
   extension/factor-set and twelve q-ary splitting examples.

These repairs improve precedence without adding a literature subsection or
changing the theorem hierarchy.

## Closest-prior-art analysis

### LU rigidity and continuous automorphisms

C562 remains correct: Rains recovers the three Pauli axes of the binary
distance-two code from a diagonal tensor, and Van den Nest et al. use that
axis rigidity to force every local factor of a stabilizer-state LU
equivalence to be Clifford under a minimal-support condition.  The present
paper extends the tensor from three Pauli axes to all `q^2-1` nonidentity
finite-field Weyl axes and supplies the MDS shortening that realizes it
uniformly.

Wirthmüller is the missing comparison for the topology of the automorphism
group.  His Theorem 7 computes the identity component of a binary stabilizer
code's local-unitary automorphism group as a torus controlled by
contiguity/protection data; Corollary 11 makes the projective group finite
when every nontrivial qubit is protected.  The present paper's projective
finiteness is stronger in one direction—every product-unitary automorphism
is already projective Clifford in its MDS/CSS family—and broader in local
dimension, but it is not the first finiteness phenomenon.

### Transversal and inter-code maps

Anderson--Jochym-O'Connor prove that diagonal transversal rotations of
nontrivial qubit stabilizer codes have dyadic Clifford-hierarchy angles.
Their Proposition 4 covers strongly transversal diagonal maps between two
stabilizer codes with the same number of logical qubits.  Together with the
Zeng et al. decomposition recalled in their paper, this is a direct
predecessor to any broad claim about classifying inter-code transversal
maps.  It does not imply that every factor of an arbitrary product-unitary
map between the present prime-power MDS/CSS encoders is Clifford.

Dasu--Burton answer a complementary qubit question: the same local
Clifford tableau is applied at every coordinate across several identical
code blocks, with possible coupling of corresponding qubits.  The present
paper permits an independent one-qudit factor at every coordinate, uses one
code block, and computes the exact odd-prime logical image.  Neither result
subsumes the other.

The recent high-rate constructions in the manuscript use fold-transversal
or two-local layers to obtain a complete logical Clifford instruction set.
The multiple-logical-qubit no-go concerns fully transversal realization of
the full group.  These are important architectural boundaries but do not
pre-empt the one-logical-qudit exact positive theorem.

### Code automorphisms and party motion

Sayginel et al. map a stabilizer check matrix to related binary codes,
compute automorphism groups, restrict the resulting permutations to
allowed physical Clifford circuits, correct Pauli phases using
destabilizers, and recover the logical symplectic action.  This is direct
precedence for the broad idea “code symmetries yield logical Cliffords” and
for computational phase repair.

The present paper asks a different structural question: after quotienting
the scalar torus, what exact extension lies over the realized party
permutation group, what outer action and normalized factor set does it
carry, and does that extension split?  The twelve answers are new exact
data as far as the targeted search found.  Because the search was not
exhaustive and the domain is finite, the manuscript should simply state
and reproduce the data.

### Diagonal isoduality and exact logical groups

Isometry duality is established coding-theory language, and constructions
exist beyond GRS codes.  Binary self-dual CSS work supplies transversal
Hadamard and phase criteria in compatible logical bases.  Those sources
support the condition and nearby gate phenomena, but none located source
computes this paper's odd-prime exact group dichotomy for every linear
half-dimensional MDS code.

The diagonal multiplier line is therefore best advertised as the intrinsic
test that makes the exact group theorem usable.  It should not be reframed
as a general result on hulls, Schur products, or algebraic-geometry codes
without a separate audit.

### Weil and extension obstructions

Gérardin supplies a genuine odd-characteristic Weil extension of the
finite Heisenberg representation to the symplectic semidirect product.
The Weyl commutator supplies the elementary obstruction to splitting the
full affine scalar extension.  The paper's value here is terminological
and structural precision: the linear `SL_2(q)` factor splits, the affine
one-qudit projective Weyl group does not lift as a commuting translation
subgroup, and neither statement decides the separately realized
party-permutation extension.

## Search record

Searches were run on 2026-07-25.  Search-result screening used titles,
abstracts, and full metadata.  A record was promoted when it concerned
one of:

- local-unitary automorphisms or LU/LC equivalence of stabilizer/AME states;
- transversal or inter-code gates for stabilizer, MDS, CSS, polynomial, or
  Reed--Solomon quantum codes;
- code automorphisms producing logical Clifford gates;
- diagonal/isometry dual MDS codes; or
- semilinear/Frobenius equivalence of MDS or stabilizer codes.

### OpenAlex

Endpoint: `https://api.openalex.org/works`.  The exact search strings and
valid `meta.count` values were:

| Verbatim search string | Count | Screened | Outcome |
|---|---:|---:|---|
| `"transversal" "quantum MDS" Clifford` | 4 | 4 | No exact predecessor. |
| `"local unitary" "MDS" CSS AME` | 4 | 4 | No exact predecessor. |
| `"diagonally isodual" MDS transversal` | 0 | 0 | Valid JSON, empty result array. |
| `"isometry-dual" MDS quantum code transversal` | 0 | 0 | Valid JSON, empty result array. |
| `"party permutation" stabilizer state automorphism extension` | 0 | 0 | Valid JSON, empty result array. |
| `Frobenius semilinear Clifford MDS code equivalence` | 0 | 0 | Valid JSON, empty result array. |

Every nonempty set was screened to exhaustion.  These small keyword sets
are discovery checks, not proof that the literature contains only those
records.

### zbMATH Open

Endpoint: `https://api.zbmath.org/v1/document/_search`.

The queries `transversal quantum MDS Clifford`, `local unitary MDS CSS
AME`, `diagonally isodual MDS code`, `stabilizer state automorphism group
local unitary`, and `Frobenius semilinear MDS code equivalence` returned
HTTP 404 from the attempted endpoint.  They are recorded as **NOT
COVERED**, not as empty results.  The query `isometry dual MDS code`
returned one valid record, Zhu--Zhao (2026), which was promoted.

### Broad web discovery

The following exact queries were screened against the web index:

```text
site:arxiv.org quantum MDS code transversal logical gates Reed Solomon Clifford exact group qudit
site:arxiv.org "transversal non-Clifford" "quantum MDS"
site:arxiv.org MDS CSS "local unitary" "local Clifford" AME
site:arxiv.org stabilizer state local unitary automorphism group finite projective
site:arxiv.org classification transversal gates stabilizer codes local unitary product gate Clifford
site:arxiv.org transversal gates quantum Reed Solomon code non Clifford MDS
site:arxiv.org "quantum MDS" "transversal gates"
site:arxiv.org "transversal logical" "Reed-Solomon" Clifford
site:arxiv.org quantum code automorphisms logical Clifford party permutation extension factor set
site:arxiv.org "isometry-dual" MDS codes quantum
site:arxiv.org "diagonally isodual" MDS codes
```

They located the sources discussed below and the broad transversal-gate
literature already cited by the manuscript.  No exact combined theorem was
located.

No forward-citation enumeration was used for a negative in this audit, so
the three-service citation-graph rule is not triggered.

## Individually discussed sources and read depth

1. **Eric M. Rains, *Quantum Codes of Minimum Distance Two*.**
   **Read depth:** `partial`; inherited from C562: abstract and complete
   “Automorphisms and equivalences” section, especially Theorem 13,
   Corollary 14, and proofs.  Cache `arXiv:quant-ph/9704043v1`, SHA-256
   `ad906a12c2a5ac65e6efa575d72b94b7dd65bcb7d435145284ea8eb26dad3a4c`.
2. **M. Van den Nest, J. Dehaene, and B. De Moor, *Local Unitary versus
   Local Clifford Equivalence of Stabilizer States*.**
   **Read depth:** `full text`; inherited from C562, arXiv v2, all eight
   pages.  Cache `arXiv:quant-ph/0411115v2`, SHA-256
   `c0f8e192552369d5af9304ebf08995f59b6917e243a570f37ff1b29f3b4cb735`.
3. **Klaus Wirthmüller, *Automorphisms of Stabilizer Codes*.**
   **Read depth:** `partial`; arXiv v1 abstract, introduction, Section 3
   including Theorem 7 and Corollary 11 with proof structure, and
   conclusion.  Cache `arXiv:1102.5715`, SHA-256
   `5cfd43e7f314056c7c7f61e6da6599a56252a759c11552a7b2c4d50d736d8164`.
4. **Jonas T. Anderson and Tomas Jochym-O'Connor, *Classification of
   Transversal Gates in Qubit Stabilizer Codes*.**
   **Read depth:** `partial`; arXiv v1 abstract, introduction, proof
   outline, Proposition 3, Proposition 4, and conclusion.  Cache
   `arXiv:1409.8320`, SHA-256
   `59a664150f0c4e9ee19106d996db0416b2af6b7ac1d36bd9bb459f2be76e1a69`.
5. **Hasan Sayginel, Stergios Koutsioumpas, Mark Webster, Abhishek Rajput,
   and Dan E. Browne, *Fault-Tolerant Logical Clifford Gates from Code
   Automorphisms*.**
   **Read depth:** `partial`; arXiv v3 abstract, introduction, Sections
   III--V, and conclusion.  Cache `arXiv:2409.18175`, SHA-256
   `f95889863485fb43f2036783ebff3618661dff1bb68753f7dd22256e32adaa68`.
6. **Markus Grassl, Willi Geiselmann, and Thomas Beth, *Quantum
   Reed--Solomon Codes*.**
   **Read depth:** `full text`; inherited from C599, complete three-page
   arXiv version.  Cache `arXiv:quant-ph/9910059`, SHA-256
   `8d7123b601de2d682e7f1be51d026e2152ba3f941172829771aade932974602b`.
7. **Dorit Aharonov and Michael Ben-Or, *Fault-Tolerant Quantum
   Computation With Constant Error Rate*.**
   **Read depth:** `partial`; inherited from C599, Sections 3.5 and
   5.1--5.2 of the arXiv version.  Cache `arXiv:quant-ph/9906129`,
   SHA-256
   `75b88121b25c7e4a8766c4e5ee31218be946d25fccecf7b3717687011df32d1f`.
8. **Daniel Gottesman, *Fault-Tolerant Quantum Computation with
   Higher-Dimensional Systems*.**
   **Read depth:** `full text`; inherited from C599, complete arXiv v1,
   especially Sections 2, 4, and 5.  Cache
   `arXiv:quant-ph/9802007`, SHA-256
   `1b10e7abf1578ad6ba7410d4cd8235f23d6cf67a5e665f28f181dbcc808ba141`.
9. **Paul Gérardin, *Three Weil Representations Associated to Finite
   Fields*.**
   **Read depth:** `full text`; inherited from C619, all three published
   pages, especially Theorem 1.  Cache
   `10.1090/S0002-9904-1976-14017-7`, SHA-256
   `010d33d76214ba58404847f4bfba39f3a469b80ceb68a41e012b65e42f5c59e3`.
10. **Yunlong Zhu and Chang-An Zhao, *On Iso-Dual MDS Codes From Elliptic
    Curves*.**
    **Read depth:** `partial`; inherited from C622, arXiv preprint
    introduction, Theorem 3.1, Construction 2, Theorem 5.1, and
    conclusion.  Cache `arXiv:2502.02033`, SHA-256
    `e8af7e0dd247530d95a11c7df06dba3c5a38fb101895e6f1cc142351710408bf`.
11. **Theerapat Tansuwannont, Yugo Takada, and Keisuke Fujii, *Clifford
    Gates with Logical Transversality for Self-Dual CSS Codes*.**
    **Read depth:** `partial`; inherited from C622, introduction,
    compatible-basis definitions, Theorem 1, and Corollary 1.  Cache
    `arXiv:2503.19790`, SHA-256
    `1734a9034eabbf75450c00e41352fa2b049747384d06528053f834cacab3e82e`.
12. **Canze Zhu and Qunying Liao, *A Class of Double-Twisted Generalized
    Reed--Solomon Codes*.**
    **Read depth:** `abstract/metadata only`; inherited from C622,
    publisher title, abstract, introduction preview, and headings for DOI
    `10.1016/j.ffa.2024.102395`.  The subscription full text was not
    reachable.
13. **Shival Dasu and Simon Burton, *A Classification of Transversal
    Clifford Gates for Qubit Stabilizer Codes*.**
    **Read depth:** `full text`; inherited from C645, arXiv v1, all
    sections, especially Theorems 5.5 and 6.1.  Cache
    `arXiv:2507.10519`, SHA-256
    `da95db6671622a7356666212017749eb42da3e5ab545c3acb7e4a5013bc8452f`.
14. **Benjamin Howard, John Millson, Andrew Snowden, and Ravi Vakil, *A
    Description of the Outer Automorphism of S6, and the Invariants of Six
    Points in Projective Space*.**
    **Read depth:** `full text`; inherited from C645, arXiv v1, especially
    Sections 2.1--2.3.  Cache `arXiv:0710.5916`, SHA-256
    `d2da258cd8513a9b782a8270baa82acc51bc8d552e18db104967c2a08bffebfc`.
15. **Theerapat Tansuwannont, Tim Chan, and Ryuji Takagi, *Construction of
    the Full Logical Clifford Group for High-Rate Quantum Reed--Muller
    Codes Using Only Transversal and Fold-Transversal Gates*.**
    **Read depth:** `partial`; inherited from C642, arXiv v3 abstract,
    introduction, and main-contribution statements.  Cache
    `arXiv:2602.09788`, SHA-256
    `87b1aa032352eaa84281e439043345ef9961700befb166f2b1e6b091c9158b32`.
16. **Adam Holmes, *Quantum Logic Codes: Complete Transversal Logical
    Clifford Instruction Sets for High-Rate Stabilizer Quantum Error
    Correcting Codes*.**
    **Read depth:** `partial`; inherited from C642, arXiv v1 abstract,
    introduction, and main-contribution statements.  Cache
    `arXiv:2606.13521`, SHA-256
    `dccf2c8290055e5c4bcebfcf9634693f9bb2d897a38cc6b1f26cfbd42878944c`.
17. **Aranya Chakraborty and Daniel Gottesman, *No-Go Theorem on Fault
    Tolerant Gadgets for Multiple Logical Qubits*.**
    **Read depth:** `partial`; inherited from C642, arXiv v3 abstract,
    introduction, and main-contribution statements.  Cache
    `arXiv:2602.13395`, SHA-256
    `ea38a71b1ea58e03b3747c492d47a09edbb98649308f2599fb90cfa1f0045610`.

## Coverage gaps

- **MathSciNet:** NOT COVERED; institutional authentication unavailable.
- **Google Scholar:** NOT COVERED; automated access unavailable.
- **zbMATH Open:** four of five load-bearing query families were NOT
  COVERED because the attempted endpoint returned HTTP 404.
- **Publisher versions:** the Wirthmüller, Anderson--Jochym-O'Connor,
  Sayginel et al., and several 2026 records were characterized from arXiv
  versions, not checked published versions.  Zhu--Liao remained
  subscription-only.
- **Citation graphs:** no new citing-set enumeration was attempted.

These gaps license no absolute absence statement.  “No exact predecessor
was located in the recorded search” is the strongest audit wording.

## Authorized and forbidden manuscript posture

Authorized:

- “a finite-field extension/realization of the Rains--Van den Nest
  axis-recovery mechanism”;
- “the exact fixed-party projective logical group is ...” with the stated
  field and family boundaries;
- explicit comparisons distinguishing Wirthmüller, Anderson--Jochym-
  O'Connor, Sayginel et al., Dasu--Burton, and the high-rate constructions;
- “the computed extension splits in the twelve listed examples”; and
- “the Weil factor splits while the full affine scalar extension is
  obstructed by the Weyl commutator.”

Forbidden or unsupported:

- “the first LU-to-LC theorem for quantum MDS codes” without “to our
  knowledge” and a manual closure of the search gaps;
- “the first classification of transversal gates for quantum MDS codes”;
- “the first proof that stabilizer automorphism groups are finite”;
- “a new group-cohomological obstruction” or “a new metaplectic
  obstruction”;
- “diagonal isoduality is equivalent to GRS”;
- a uniform party-extension splitting theorem beyond the twelve rows;
- a full extension-field Clifford orbit theorem; or
- priority for the Igusa-quartic/Segre-cubic interpretation.

## High-EV follow-ups not added

The remaining reader ideas do not justify further theorem or prose burden
in this paper.  The only cheap follow-up with material publication value is
a public archive URL/DOI, which remains an author-controlled deposit gate.

The following should remain separate projects: general stabilizer-AME
rigidity, a global MDS--CSS orbit theorem modulo duality, higher Veronese
phase geometry, quantitative/approximate rigidity, and growing-copy
invariant bounds.

## Final novelty posture

The manuscript can confidently emphasize exactness, breadth in prime-power
dimension and length, and the integration of coding, Clifford, and
finite-geometry viewpoints.  It should not add “first” or “to our
knowledge” language.  The current theorem statements are already stronger
and more useful than a priority sentence, and the repaired literature
positioning makes their boundary visible to a specialist referee.

## Validation

- `make check` passed with no TeX warnings and verified all 17 evidence
  artifacts.
- The detached Lean aggregate run built
  `RelativeConicArcs.Gates.AMELUAggregate` and
  `RelativeConicArcs.Gates.AMELUAggregateAxioms`; the aggregate axiom gate
  passed.
- The final 26-page PDF has SHA-256
  `16721025793da0209380526370834721dd5ca04ad23cf9aa702bf2ffe9a56b6f`.
- Pages 2--4, which contain the revised positioning, were visually
  inspected.
- The release manifest and deterministic release replay are refreshed in
  the C647 closeout commit.
