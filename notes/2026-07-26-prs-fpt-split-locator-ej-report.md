# Exact PRS decoding through split Hankel locators

**Date:** 2026-07-26  
**Lane:** `reed-solomon`  
**Prospective owner:** C607, after the existing Version 1 publication gate

## Executive decision

The proposed algorithmic result is correct at the level of deterministic
fixed-parameter distance decision, but its strongest presentation is not the
raw bounded-variable polynomial encoding.

The natural object is the affine linear system of error-locator polynomials
cut out by the syndrome Hankel equations.  Exact decoding asks whether this
linear system contains a polynomial that splits into distinct rational linear
factors.  This yields the four-way dictionary
\[
 \text{PRS syndrome distance}
 \;=\;
 \text{finite-field atomic moment rank}
 \;=\;
 \text{NRC/divided-power rank}
 \;=\;
 \text{split locator in a Hankel kernel}.
\]

The proposed companion paper should establish three results together:

1. exact syndrome distance for full-length projective Reed--Solomon codes is
   deterministically fixed-parameter tractable in the redundancy;
2. an explicit nearest codeword is recoverable deterministically in
   \(f(r)q\operatorname{poly}(\log q)\), which is linear in the explicit
   input/output length up to the parameter factor;
3. compressed support recovery has an independent arithmetic obstruction:
   already at redundancy four it contains deterministic square-root
   extraction over finite fields, and in general it contains factorization of
   completely split polynomials.

The geometric PRS classification remains essential.  Kayal decides an
existential question for one supplied syndrome.  A uniform covering-radius or
deep-hole classification is a structured universal--existential problem, and
explicit support recovery is a search problem.  The three tasks are not
interchangeable.

The bare Kayal corollary is a useful paragraph.  The decision/search/
classification trichotomy, expressed through split Hankel locators, is a
paper.

## 1. Correct core of the supplied report

Let
\[
 h(a)=(1,a,\ldots,a^{r-1})^{\mathsf T},\qquad
 h(\infty)=(0,\ldots,0,1)^{\mathsf T}.
\]
For a supplied syndrome \(s\in\mathbb F_q^r\), the assertion that \(s\) has
a representation using at most \(t\) projective NRC columns is expressible by
a polynomial system with a number of variables and degrees bounded by
functions of \(r\).  Kayal's bounded-variable finite-field solvability
algorithm therefore gives deterministic time
\[
 f(r)\operatorname{poly}(\log q)
\]
for the decision problem.

For an explicit received word, computing the syndrome already costs
\(\Omega(q)\) field operations.  Once the minimum feasible weight is known,
coordinate-by-coordinate self-reduction over \(\mathbb F_q\) recovers a
support and magnitudes in
\[
 f(r)q\operatorname{poly}(\log q).
\]
Writing an explicit nearest codeword also costs \(\Omega(q)\).  The exponent
one in \(q\) is therefore optimal in the explicit input/output model, though
not in the compressed syndrome-to-support model.

The unrestricted NP-hardness results for Reed--Solomon maximum-likelihood
decoding allow the redundancy to grow and do not conflict with this
parameterized statement.

### Quantitative correction

Kayal's Theorem 6.1.1 and Theorem 6.3.8 state a running time of the form
\[
 \operatorname{poly}\!\left(d^{c_n}m\log q\right),
 \qquad c_n=n^{O(n)},
\]
for \(n\) variables, not \(c_n=2^{O(n)}\).  This worsens the already enormous
parameter dependence but does not change fixed-parameter tractability.

Before publication, the proof must extract a single uniform bound
\[
 f(r)(\log q)^C
\]
with \(C\) independent of \(r\).  The displayed theorem appears to provide
exactly this, but the paper must not rely only on the weaker phrase
"polynomial for every fixed number of variables," which by itself can conceal
an XP exponent.

Primary source:

- Neeraj Kayal, *Derandomizing Some Number-Theoretic and Algebraic
  Algorithms*, IIT Kanpur PhD thesis, 2007, Chapters 6 and 8:
  <https://eccc.weizmann.ac.il/static/books/Derandomizing_some_number_theoretic_and_algebraic_algorithms/>.

## 2. Simplifications discovered in the extra-juice passes

### 2.1 Decide weight at most \(t\), not exact weight \(t\)

Allow zero magnitudes and repeated locations.  Any representation using fewer
than \(t\) support points pads to \(t\) slots, while repeated locations
consolidate.  This removes the need to impose nonzero magnitudes and pairwise
distinctness in the raw moment encoding.  Feasibility becomes monotone in
\(t\), so the minimum distance may be located by binary search over
\(0\leq t\leq r\).

The exact-weight formulation remains useful when counting ordered
decompositions, but it is unnecessary for distance decision.

### 2.2 Eliminate the magnitudes

For candidate locations \(x_1,\ldots,x_t\), the condition is
\[
 s\in\operatorname{span}\{h(x_1),\ldots,h(x_t)\}.
\]
Rank stratification and augmented minors reduce this to at most \(t+1\)
variables, rather than the \(2t+1\) variables in the raw incidence system.
This already improves the parameter hidden inside Kayal's \(c_n\).

### 2.3 Use the locator/Vieta formulation instead

The cleaner reduction first constructs the affine locator space
\(\mathcal L_t(s)\) from the Hankel recurrence equations.  Substitute
\[
 \Lambda_X(T)=\prod_{i=1}^t(T-x_i)
\]
into those linear coefficient equations.  Add one inverse variable for the
Vandermonde discriminant when exact squarefree degree \(t\) is required, and
treat the possible infinity root in a second chart.

This formulation uses approximately

- \(t+1\) variables;
- \(O(r)\) equations;
- degree \(O(t^2)\).

It is intrinsic to the PRS manuscript, avoids auxiliary magnitude variables,
and exposes the factorization problem that governs witness recovery.

## 3. The split-linear-system abstraction

The reusable intermediate problem is:

> **Split Linear-System Problem.** Given an affine linear system
> \(\mathcal L\) of degree-\(t\) polynomials over \(\mathbb F_q\), determine
> whether \(\mathcal L\) contains a completely split squarefree polynomial.

PRS maximum-likelihood decoding gives a structured Hankel subclass.  The
problem has three regimes.

| Regime | Locator geometry | Computational task |
|---|---|---|
| \(2t\leq r\) | the minimal locator is generically unique | factor the locator |
| \(2t>r\) | the locator space is positive-dimensional | select a split member, then factor it |
| maximal-distance syndromes | the relevant locator spaces are split-free | classify the exceptional spaces |

This separates four operations:

1. linear algebra constructs the locator system;
2. geometry selects, or proves the absence of, a split member;
3. finite-field arithmetic factors a selected locator;
4. linear algebra recovers the magnitudes.

Classical unique decoding and Prony/Berlekamp--Massey occupy the first row.
The second row is the genuine maximum-likelihood selection problem.  The PRS
deep-hole paper studies the third row.

## 4. Decision, search, and output models

The final paper must keep the following problems separate.

| Problem | Proposed unconditional deterministic bound | Boundary |
|---|---:|---|
| distance of a supplied syndrome | \(f(r)\operatorname{poly}(\log q)\) | Kayal plus locator/Vieta encoding |
| an unfactored locator | to be proved | may be easier than producing its roots |
| explicit support from a syndrome | \(f(r)q\operatorname{poly}(\log q)\) by self-reduction | polylogarithmic deterministic search meets root extraction |
| explicit nearest codeword from an explicit word | \(f(r)q\operatorname{poly}(\log q)\) | optimal in the explicit I/O model |

A randomized constructive theorem is likely stronger than the deterministic
support bound because randomized finite-field factorization is polynomial
time.  It must be proved from a cited constructive fixed-variable solver or a
complete locator-selection argument; it should not be inferred from Kayal's
decision theorem.

A conditional deterministic column, for example under the hypotheses needed
by the selected finite-field factorization algorithm, should be stated only
after the exact dependency is verified.

## 5. The redundancy-four square-root barrier

Let \(q\) be odd and let \(a\in\mathbb F_q^\times\) be a square.  Consider
\[
 s_a=(0,1,0,a)\in\mathbb F_q^4.
\]
Suppose
\[
 s_a=e_1h(x_1)+e_2h(x_2),\qquad h(x)=(1,x,x^2,x^3).
\]
The four moment equations give
\[
 e_2=-e_1,\qquad
 e_1(x_1-x_2)=1,\qquad
 x_1+x_2=0,\qquad
 x_1^2=a.
\]
An infinity-supported representation is impossible because its first two
coordinates cannot be \(0,1\).  Conversely, if \(u^2=a\), then
\[
 s_a=\frac1{2u}h(u)-\frac1{2u}h(-u).
\]
The syndrome has no weight-one representation, so every minimum-support
witness returns a square root of \(a\).

Consequently, a deterministic
\(f(r)\operatorname{poly}(\log q)\)-time support-recovery algorithm would
give deterministic polylogarithmic square-root extraction already at fixed
redundancy four.  The \(q\)-factor in the unconditional self-reduction is
therefore not merely an artifact of a careless proof.

Relevant arithmetic context:

- Victor Shoup, "On the deterministic complexity of factoring polynomials
  over finite fields," *Information Processing Letters* 33 (1990), 261--267,
  <https://doi.org/10.1016/0020-0190(90)90195-4>.

## 6. Proposed general factorization reduction

The quadratic example should be extended as follows.

Given a completely split squarefree polynomial \(F\) of degree \(t\),
construct canonically, without knowing its roots, a length-\(2t\) moment
sequence whose minimal recurrence polynomial is \(F\).  A minimum
\(t\)-atomic NRC representation of that sequence then recovers the roots of
\(F\), hence its complete factorization.

The construction is standard in Prony/linear-recurrence language: use a
cyclic companion realization or the coefficient sequence of a rational
function with denominator \(F\) and numerator coprime to \(F\).  Publication
requires an exact finite-field statement covering:

- the companion-matrix convention;
- proof that the recurrence is minimal;
- the projective/infinity chart;
- repeated-root exclusions;
- recovery of all roots from every minimum representation.

If established, the generic unique-locator part of PRS support recovery is
parameterized-equivalent, up to elementary linear algebra, to factoring a
split degree-\(t\) polynomial.  Beyond half distance, split-member selection
is an additional obstruction.

## 7. The logical hierarchy

For a supplied syndrome, shallowness is existential:
\[
 \exists(x_i,e_i)\quad s=\sum_i e_i h(x_i).
\]
Kayal applies.

Uniform shallowness outside a proposed carrier list is
\[
 \forall s\notin B_r\;\exists(x_i,e_i)\quad
 s=\sum_i e_i h(x_i).
\]
Existence of an unclassified deep syndrome reverses the alternation:
\[
 \exists s\notin B_r\;\forall(x_i,e_i)\quad
 s\neq\sum_i e_i h(x_i).
\]

Kayal's thesis explicitly raises the complexity of bounded-variable
finite-field formulas with alternating quantifiers after settling the
existential case.  A bounded search during this report did not locate a
later theorem that directly settles the exact structured
universal--existential regime above.  That is not a novelty verdict; it is a
required specialist-audit target.

This is the precise reason the generic FPT decoder does not subsume the PRS
classification.  The paper supplies structured quantifier elimination for
normal-rational-curve incidence.

## 8. Density and why root variables are structural

`RelativeConicArcs.PRSSquarefreeMarkerDensity` proves:

1. a polynomial over an infinite field that vanishes on every injective root
   tuple is zero;
2. the elementary-symmetric coefficient pullback is injective;
3. monic split-squarefree coefficient tuples are polynomially dense.

This is both a proof ingredient and an algorithmic warning.  No nonzero
polynomial identity in coefficient space can separate all split-squarefree
tuples from the ambient coefficient space.  A uniform splitting algorithm
must use rational-root witnesses, \(q\)-dependent Frobenius operations, or an
explicit factorization/root-finding procedure.  The Vieta root variables are
not gratuitous.

The density statement does not rule out every possible quantifier-free
Boolean description, and over a fixed finite field any subset is algebraic
with sufficiently high degree.  The paper should claim only the exact
no-polynomial-identity conclusion that is proved.

## 9. Broader algebraic-dictionary theorem

Let the parity-check columns be the rational points of finitely many charts of
an algebraic map
\[
 \phi_r:V_r\longrightarrow\mathbb A^r
\]
whose source dimension, defining equations, chart count, and degrees are
bounded by functions of \(r\).  Exact sparse representation of a supplied
syndrome by at most \(r\) dictionary atoms is a bounded-variable finite-field
feasibility problem.  Hence distance decision is FPT in \(r\).

This applies to full algebraically parametrized dictionaries.  It does not
automatically apply with the same bound to arbitrary punctured Reed--Solomon
codes: encoding membership in an arbitrary evaluation set can introduce
degree or input-size dependence on the puncturing set and restore an XP-type
exponent.

The general theorem belongs after the PRS theorem, not before it.  The PRS
locator structure provides the mechanism, the sharp search barrier, and the
connection to the companion geometry.

## 10. Counting and certificates

Kayal's chapter also gives deterministic approximations to rational-point
counts and geometric component data in the bounded-variable setting.  A
secondary direction is to estimate the number and dimension of ordered error
decompositions in FPT time, then reconcile those estimates with the orbit and
fiber counts in the PRS paper.

This should not enter the first theorem spine unless it yields an exact or
clearly useful list-size statement.

For \(r\leq7\), there is also a possible two-sided certificate picture:

- a shallow syndrome has a short support-and-magnitude witness;
- a classified deep syndrome has a carrier/orbit invariant and the paper's
  geometric certificate.

The relation to conventional NP/coNP terminology must be stated carefully:
the current decision procedure does not itself output a short certificate for
all negative instances.

## 11. Relation to the current PRS paper

The algorithmic note strengthens rather than replaces the geometric paper.

- Pointwise decoding is generic existential FPT.
- The PRS paper classifies the split-free locator systems at maximal distance.
- Classical decoding handles the unique-locator regime.
- Coherent polar geometry analyzes the positive-dimensional locator systems
  and their exceptional carriers.

The current PRS manuscript should not be reopened before Version 1 merely to
insert this result.  C607 is explicitly gated until that publication.  After
the theorem and literature audit are complete, add one discussion paragraph
to the next PRS version:

> For fixed redundancy, shallowness of a supplied syndrome is an existential
> bounded-variable finite-field feasibility problem and is therefore
> deterministically fixed-parameter tractable.  This pointwise result does
> not subsume the uniform classification proved here: completeness of a
> carrier list is a structured universal--existential assertion, while
> extraction of explicit support points introduces the separate
> finite-field factorization problem.  In locator language, the present
> classification describes the split-free exceptional Hankel systems beyond
> the classical unique-locator range.

No abstract or main-theorem change is recommended for the existing PRS paper.

## 12. Relation to AME--LU

The AME--LU theorem says that a stabilizer AME state is classified up to LU by
its minimum-support operator-pushing atlas, modulo local symplectic gauges and
party permutation.  For MDS--CSS states from evaluation codes, locator roots
and the associated minimal dependencies supply precisely the support data
from which this atlas is built:
\[
 \text{split locator}
 \longrightarrow
 \text{minimum code support}
 \longrightarrow
 \text{supported stabilizer label}
 \longrightarrow
 \text{local Weyl-frame transport}.
\]

This suggests, but does not yet prove, a bridge from locator-cover monodromy
to atlas holonomy.  If established, the centralizer of locator monodromy would
feed the exact sequence
\[
 1\longrightarrow L_\psi\longrightarrow\Gamma_\psi
 \longrightarrow\mathcal G_\psi\longrightarrow1
\]
and hence the product-unitary symmetry and transversal logical group.

The direct established consequence is already useful: every stabilizer AME
or quantum-MDS object produced by the PRS constructions inherits LU=LC
rigidity and the transversal non-Clifford no-go.  Translating PRS projective
orbit counts into exact quantum LU-class counts requires a separate audit of
local symplectic gauges, party permutations, diagonal multipliers, and
extension-field Frobenius operations.

### Recommended AME--LU change now

Do not change the title, abstract, theorem hierarchy, or proofs.  Do not add
the Kayal/FPT discussion or the speculative monodromy--holonomy bridge.

Because the four papers are intended to appear as a bundle, add one compact
companion paragraph after the MDS--CSS dictionary in the introduction:

> Two companion papers describe complementary finite-geometric data behind
> this dictionary.  The projective Reed--Solomon analysis constructs and
> classifies structured MDS extensions, hence explicit stabilizer AME states
> and quantum-MDS encoders to which
> Theorem~\ref{thm:lu-lc-rigidity} and
> Corollary~\ref{cor:transversal-clifford} apply.  The Clebsch factorization
> paper recovers the two arithmetic matching sheets of the \(H_3\)
> configuration and their cubic orientation; the orientation is
> LC-forgettable here, while the marginal incidence moment retains enough
> information to separate the \(H_3\) and GRS loci.

Add exact bibliography entries for the PRS and Clebsch-factorization
companions.  This is a reverse linkage and scope clarification, not a new
claim.  It should be checked against the final companion titles and exact
quantum corollary numbering.

## 13. Relation to Clebsch factorization

The Clebsch-factorization paper supplies three models for the split-locator
problem.

### 13.1 Recovery and orientation of factorization sheets

Quadratic tensor moments recover the unordered pair of factorization sheets;
a cubic anti-invariant orients them.  In locator language, these are candidate
low-degree covariants for recovering and choosing branches of a split cover.

### 13.2 Arithmetic descent and absence of a canonical selector

The marker algebra may be fused, rationally split, or exchanged by Frobenius.
The \(H_3\) base-choice cocycle gives an explicit failure of an equivariant
origin.  This warns that a canonical equivariant locator selector may fail
geometrically even before arithmetic root extraction is attempted.

### 13.3 Gorenstein/apolar structure

The self-associated configurations are arithmetically Gorenstein, with the
signed cubic as a Macaulay inverse system.  PRS Hankel locators are apolar data
for binary/divided-power forms.  A concrete successor question is whether the
Artinian Gorenstein algebra of a classified locator system has low-degree
inverse-system covariants that detect or orient its split components.

The most valuable unproved bridge is to identify whether the AME marginal
moment separating \(H_3\) from GRS is an invariant contraction or norm of the
Clebsch signed cubic.  A positive formula would replace two parallel
certificates by one factorization-memory tensor.  A negative result would
still clarify exactly which information the LU quotient forgets.

The Clebsch manuscript already cites the PRS and AME--LU companions and needs
no immediate structural change.  If the bridge is proved, add it as a
corollary or companion proposition rather than anticipatory prose.

## 14. Cross-bundle synthesis

The three papers retain successively coarser information:
\[
\begin{array}{c}
\text{root and factorization data}\\
\downarrow\ \text{Vieta--Hankel}\\
\text{minimum-support code geometry}\\
\downarrow\ \text{MDS--CSS}\\
\text{operator-pushing atlas}\\
\downarrow\ \text{atlas holonomy}\\
\text{LU class and transversal logical group}.
\end{array}
\]

The proposed bundle-level sentence is:

> Factorization memory becomes quantum rigidity: rational factorization of
> Hankel locator systems determines minimum-support code geometry, whose
> transport atlas controls the LU class and transversal logical group of the
> associated stabilizer AME state.

This is an interpretation of proved dictionaries plus two proposed bridges.
It must not be stated as a theorem until locator monodromy is connected
formally to atlas holonomy.

## 15. Literature and novelty boundary

The initial bounded searches found no source explicitly stating deterministic
FPT exact distance for full-length PRS parameterized by redundancy, but the
search domain must be widened before any novelty claim.  Searching only
"FPT Reed--Solomon" is inadequate.  The audit must include:

- finite-field Prony methods and sparse interpolation;
- Berlekamp--Massey and LFSR/error-locator synthesis;
- decoding beyond the BCH/unique-decoding radius;
- binary Waring and symmetric-tensor decomposition over nonclosed fields;
- split rank and rational secant decomposition;
- deterministic finite-field root extraction and factorization;
- parameterized nearest-codeword and maximum-likelihood decoding;
- fixed-variable finite-field feasibility and quantifier alternation;
- algebraic dictionary and sparse-representation algorithms.

Known adjacent sources include:

- Kayal's bounded-variable solvability theorem, cited above;
- Shoup's deterministic finite-field factorization work, cited above;
- Guruswami--Vardy on unrestricted RS maximum-likelihood hardness:
  <https://eccc.weizmann.ac.il/eccc-reports/2004/TR04-040/index.html>;
- classical and modern Prony/sparse-interpolation treatments;
- "A nearly optimal algorithm to decompose binary forms":
  <https://arxiv.org/abs/1810.12588>.

The likely novel package is not any individual ingredient.  It is the
parameterized synthesis:

1. deterministic FPT distance for the full projective dictionary;
2. the exact decision/search separation;
3. the square-root and split-factorization reductions;
4. the split-linear-system abstraction;
5. the connection between pointwise existential decoding and uniform
   split-free Hankel classification.

## 16. Strongest paper proposal

### Recommended title

**Exact projective Reed--Solomon decoding through split Hankel locators**

Recommended subtitle, if the venue permits one:

**Fixed-parameter decision and arithmetic barriers to support recovery**

More conceptual alternative:

**Finite-field Prony rank: fixed-parameter decision, factorization-hard
recovery, and split-free Hankel geometry**

The first title is preferable for IEEE Transactions on Information Theory.
The second is preferable only if the algebraic-dictionary and tensor-rank
theorems become substantial rather than concluding remarks.

### One-sentence headline

For full-length projective Reed--Solomon codes, exact syndrome distance is
deterministically fixed-parameter tractable in the redundancy, whereas
compressed minimum-support recovery already contains finite-field
factorization; the exceptional maximal-distance syndromes are precisely
split-free structured Hankel systems.

### Theorem spine

#### Theorem A: locator dictionary

Prove the exact equivalence among:

- support weight at most \(t\);
- a \(t\)-atomic projective moment representation;
- rational NRC/divided-power rank at most \(t\);
- existence of a split locator in the syndrome Hankel system.

Include infinity, lower-weight padding, repeated-root, and small-characteristic
conventions.

#### Theorem B: deterministic FPT distance

Use the locator/Vieta system and Kayal's exact uniform complexity theorem to
decide distance in \(f(r)\operatorname{poly}(\log q)\).  Deduce an explicit
nearest-codeword algorithm in
\(f(r)q\operatorname{poly}(\log q)\).

#### Theorem C: arithmetic search barrier

Prove the redundancy-four square-root reduction and the general reduction
from factoring completely split squarefree polynomials to PRS
minimum-support recovery.

#### Theorem D: constructive variants

Prove the strongest fully sourced statement available:

- unconditional randomized FPT support recovery;
- conditional deterministic FPT support recovery, if justified;
- unconditional deterministic \(q\)-linear recovery.

Omit any column that cannot be proved with an exact algorithmic citation.

#### Corollary E: algebraic dictionaries

State the bounded-complexity algebraic-dictionary generalization, with the
arbitrary-puncturing boundary explicit.

### Section spine

1. **Syndromes, moments, and split locators.** State Theorem A and explain the
   unique-locator versus split-selection transition.
2. **Fixed-parameter distance.** Give the Vieta/Kayal proof, uniform bound,
   charts, and explicit I/O model.
3. **Recovery and arithmetic barriers.** Prove Theorems C and D.
4. **Split-free systems and PRS geometry.** Explain the quantifier hierarchy
   and the relation to the companion classification without reproducing it.
5. **Algebraic dictionaries and applications.** Give Corollary E, the
   AME/MDS consequences, and bounded open problems.

Keep approximate counting, implementation experiments, and detailed
\(r\leq7\) algorithms out of the first version unless one supplies a theorem
that changes the spine.

## 17. Acceptance gates

Do not draft a novelty claim or alter the current PRS spine until all of the
following pass:

1. exact uniform-complexity extraction from Kayal;
2. exact locator dictionary in every characteristic and both projective
   charts;
3. complete proof of the split-polynomial factorization reduction;
4. sourced randomized and conditional search algorithms, or their deletion;
5. specialist literature audit across coding, Prony, Waring, and finite-field
   factorization;
6. explicit distinction among syndrome, locator, support, and codeword output;
7. proof that every broader algebraic-dictionary hypothesis is algorithmically
   constructible from the input representation;
8. an independent complexity-theory referee read;
9. an algebraic-coding referee read;
10. exact reconciliation with the PRS, AME--LU, and Clebsch companion claims.

## 18. Significance assessment

- Bare Kayal corollary as currently written: **6.5/10**.
- Locator reformulation plus exact FPT theorem: **7.5/10**.
- Full decision/search/classification package with general factorization
  reduction: **8--8.5/10** in algebraic coding theory and parameterized
  algebraic complexity.
- Practical decoder at the current generic \(f(r)\): **3/10**.

The result is not presently a FOCS/STOC-level algorithmic breakthrough: the
positive algorithm imports a general theorem and does not make \(f(r)\)
practical.  It can support a strong IEEE TIT or ISSAC-style paper if the
factorization barrier, native locator formulation, and literature boundary
survive review.

## 19. Recommended action

1. Preserve the current Version 1 PRS release gate.
2. Make only the two-sentence reverse companion linkage in AME--LU described
   above, after confirming the final citation keys.
3. Do not alter Clebsch factorization now.
4. After Version 1, reframe C607 from a generic Las Vegas decoder task into
   the locator-based decision/search paper proposed here.
5. Start C607 with the uniform Kayal audit and the exact locator dictionary;
   these are the two kill gates.
6. Prove the redundancy-four square-root proposition immediately.
7. Attempt the general split-factorization reduction before drafting an
   abstract.
8. Commission separate coding-theory and computational-algebra cold reads.
9. Add the restrained PRS discussion paragraph only after the companion
   theorem and novelty audit are green.

The highest-EV endpoint is a short, theorem-led companion paper.  It should
explain why exact distance is generically FPT, why explicit compressed
recovery remains arithmetic, and why the geometric deep-hole classification
solves a genuinely different uniform problem.
