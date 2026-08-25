# C960 ungated ranked transfer

**Lane**: `complete-ports`

**Date**: 2026-08-24
**Status**: active; theorem and priority audit passed, manuscript integration and deterministic
22-page authority gate passed, independent closeout pending

## Question

Can the exact ungated weighted formula for one recovered coordinate be extended to an arbitrary
nonzero subspace of internally recoverable target combinations, so that the distance-gated RGHW
theorem and the pointed finite-length theorem become specializations of one exact formula?

## Setup

Let the represented inner code have coordinate split (E=P\sqcup J), let

\[
 \Phi_I:\mathbb F_q^E\longrightarrow L^*
\]

be the inner functional map, and let (0\ne T\le U_P=\operatorname{im}G_P).

For (B\in\operatorname{Hom}_{\mathbb F_q}(T,L^*)), define the ordinary and target-constrained
minimum-support lifting functions

\[
 \lambda_{I,T}(B)=
 \min\left\{
 |\operatorname{supp}Y(T)|:
 Y:T\longrightarrow\mathbb F_q^E\text{ linear},\ 
 \Phi_IY=B
 \right\},
\]

\[
 \mu_{I,P,T}(B)=
 \min\left\{
 |\operatorname{supp}\beta(T)|:
 \alpha:T\longrightarrow\mathbb F_q^P,\ 
 \beta:T\longrightarrow\mathbb F_q^J\text{ linear},\ 
 G_P\alpha=\operatorname{id}_T,\ 
 \Phi_I(\alpha,\beta)=B
 \right\}.
\]

The value is (+\infty) if the displayed lifting set is empty. Here support of the image of a
linear map is the union of the supports of all its values. The minimum in \(\mu_{I,P,T}\) ranges
over the target normalization as well as the helper coefficients. In particular,

\[
 \mu_{I,P,T}(0)=\rho_T(I),
\]

the least helper-union size of an internal normalized recovery system for (T).
It is (+\infty) when (T\not\le W_P). Thus the exact finite formula also
covers a target subspace that has no inner recovery system but may acquire one
through a nonzero outer-functional sector.

Let (O\le L^N) be an (L)-linear outer code with (N\ge2), fix block (j), and assume the coordinate projection
(O\to L) at (j) is nonzero, hence surjective. Put

\[
 \mathcal B_T(O)=
 \operatorname{Hom}_{\mathbb F_q}\bigl(T,\operatorname{FD}(O)\bigr).
\]

For (B\in\mathcal B_T(O)), write (B=(B_h)_{h=1}^N), where
(B_h:T\to L^*).

## Exact theorem

Define

\[
 \Gamma_{j,T}(O,I)=
 \min\left\{
 \mu_{I,P,T}(0)+d(I^\perp),
 \min_{0\ne B\in\mathcal B_T(O)}
 \left(
 \mu_{I,P,T}(B_j)+
 \sum_{h\ne j}\lambda_{I,T}(B_h)
 \right)
 \right\}.
\tag{C960.1}
\]

Then \(\Gamma_{j,T}(O,I)\) is exactly the least helper-union size of a nonconfined normalized
recovery system for (T) at block (j) in (O\circ I).

For (1\le t\le\ell=\dim W_P), put

\[
 \Gamma_{j,t}(O,I)=
 \min_{\substack{T\le W_P\\ \dim T=t}}
 \Gamma_{j,T}(O,I).
\tag{C960.2}
\]

Then every normalized recovery system of helper cost at most (r), for every internally
recoverable (t)-dimensional target subspace, is confined to block (j) if and only if

\[
 r<\Gamma_{j,t}(O,I).
\tag{C960.3}
\]

Below that threshold, restriction to the target block and zero extension are inverse bijections on
normalized recovery systems and preserve coefficients and exact helper supports.

## Proof

A normalized recovery system is an \(\mathbb F_q\)-linear map

\[
 Y:T\longrightarrow (O\circ I)^\perp
\]

whose target-block coordinates have the prescribed target normalization. Write (Y_h) for its
restriction to inner block (h), and put

\[
 B_h=\Phi_IY_h.
\]

The blockwise functional-dual decomposition, applied pointwise to every (u\in T), says that
((B_h(u))_h\in\operatorname{FD}(O)). Linearity in (u) therefore gives

\[
 B=(B_h)_h\in\operatorname{Hom}_{\mathbb F_q}(T,\operatorname{FD}(O)).
\]

Conversely, choosing compatible linear lifts (Y_h) for the components of any such (B) produces
a linear map into the concatenated dual. The target-block normalization is exactly the constraint
in the definition of \(\mu_{I,P,T}(B_j)\).

The helper-coordinate sets of distinct inner blocks are disjoint. Hence, for fixed nonzero (B),
the minimum possible helper-union size is the sum of the independently minimized block supports,

\[
 \mu_{I,P,T}(B_j)+\sum_{h\ne j}\lambda_{I,T}(B_h).
\]

The projection hypothesis is used only here: if a functional-dual tuple were supported solely at
block (j), testing it against outer words whose (j)-th coordinate ranges over all of (L)
would force its (j)-th functional to vanish. Thus every nonzero (B\in\mathcal B_T(O)) has a
nonzero component outside block (j), and every realization in the nonzero-(B) sector is
nonconfined.

If (B=0), every block map takes values in (I^\perp=\ker\Phi_I). The target block costs at least
\(\mu_{I,P,T}(0)=\rho_T(I)\). Nonconfinement requires a nonzero map
(T\to I^\perp) in some other block. Every such map has image support at least (d(I^\perp)),
and equality is attained by

\[
 u\longmapsto f(u)v,
\]

where (0\ne f\in T^*) and (v\) is a minimum-weight word of (I^\perp). Hence the exact
zero-functional cost is

\[
 \rho_T(I)+d(I^\perp).
\]

The zero and nonzero functional sectors are exhaustive, which proves (C960.1). Minimizing over all
(t)-dimensional (T\le W_P) proves (C960.2)--(C960.3), including necessity because a minimizing
subspace and minimizing lifts attain the displayed cost. The coefficient/support bijection below
threshold is the same restriction--zero-extension argument as in the gated theorem.

## Specializations

### One target coordinate

For (P=\{x\}) and \(\dim T=1\), helper support is total word support minus the normalized target
coordinate. After identifying a basis of (T) and rescaling the target coefficient, (C960.1)
becomes the existing pointed weighted formula:

\[
 \Gamma_{j,1}(O,I)=Z_{j,x}(O,I)-1.
\]

Thus (r<\Gamma_{j,1}) is exactly (Z_{j,x}>r+1). This is a global-minimum specialization; no
pointwise identity between the target-constrained lifting functions is needed or claimed.

### Outer-dual-distance gate

Under trace duality, a nonzero element of \(\operatorname{FD}(O)\) has block support at least
(d(O^\perp)). If (0\ne B\in\mathcal B_T(O)), then some (u\in T) gives a nonzero tuple
(B(u)), so at least (d(O^\perp)-1) helper blocks have nonzero lifting cost. Consequently

\[
 d(O^\perp)>r+1
 \quad\Longrightarrow\quad
 \text{every nonzero-functional sector costs more than }r.
\]

At radius (r), the exact criterion therefore reduces to

\[
 r<\rho_T(I)+d(I^\perp).
\]

Minimizing over \(\dim T=t\) and using

\[
 \min_{\dim T=t}\rho_T(I)=M_t(D_P,K_P)
\]

recovers the manuscript's gated theorem exactly:

\[
 r<M_t(D_P,K_P)+d(I^\perp).
\]

The additive RGHW expression is the zero-functional candidate, hence an upper bound on the first
ungated escape cost. It becomes the exact numerical first escape cost once, for example,

\[
 d(O^\perp)\ge M_t(D_P,K_P)+d(I^\perp)+1.
\]

It should not be described as a general lower bound on the ungated obstruction.

## Anti-smuggling audit

- The optimization is over linear maps (T\to\operatorname{FD}(O)), not independently chosen
  functional tuples for a basis of (T). This retains all linear compatibility conditions.
- Each \(\lambda_{I,T}\) and \(\mu_{I,P,T}\) minimizes the union support of the whole image
  subspace. Summing per-vector or per-basis minima would be invalid and is not used.
- The target normalization map is minimized together with the target-block helper map. Fixing one
  section would define a legitimate finer cost but would not equal \(\rho_T(I)\) in general.
- Internal recoverability is not assumed in the exact finite theorem. It enters only when the
  uniform rank-(t) RGHW specialization minimizes over (T\le W_P).
- Blockwise additivity is legitimate only because distinct inner blocks have disjoint coordinate
  sets. No within-block support additivity is asserted.
- The target projection hypothesis is essential for identifying a nonzero functional sector with
  nonconfinement. Without it, a nonzero tuple supported at the target block can be block-confined.
- The zero-functional external cost is (d(I^\perp)), not a higher generalized weight, because a
  rank-one external perturbation suffices regardless of \(\dim T\).
- The assumption (N\ge2) is necessary for the zero-functional construction to have an external
  block. No one-block version of the displayed minimum is claimed.
- The theorem gives an exact finite-length optimization but not a closed formula for its lifting
  functions. The RGHW formula is the computable specialization after the outer-distance gate.
- No computation, certificate, or formal theorem is used in the proof.

## Priority audit

**Read-depth summary:** zero sources were read at full-text depth; five primary sources were read
partially at the exact portions listed below, and one August 2026 preprint was screened at
abstract/metadata depth. The audit supports a bounded priority boundary, not an exhaustive first-use
claim.

### Closest mathematical inputs

- **Partial:** Elimelech, Firer, and Schwartz, *The Generalized Covering Radii of Linear Codes*,
  arXiv:2012.06467, Sections I and III (Definition 1, Definition 4, and Lemma 5) and Section V
  (Proposition 25). Their fixed-instance problem is to lift several prescribed syndromes with
  minimum union support; their generalized covering radius maximizes that cost over the prescribed
  syndromes. Proposition 25 gives additivity of the worst-case radius under direct sums. After a
  basis of (T) is chosen, \(\lambda_{I,T}(B)\) is exactly the fixed-instance joint coset-support
  cost underlying this established invariant. The manuscript must attribute that relationship and
  must not present the ordinary lifting function as a new metric. Cache key `arXiv:2012.06467`;
  SHA-256 `3824adb41a84705d902d9d4933a9467103129c9e32a83f122b36da09eefc71f2`.
- **Partial:** Zhang, Yaakobi, Etzion, and Schwartz, *On the Access Complexity of PIR Schemes*,
  arXiv:1804.02692, Section III-B (Generalized coset weights, Lemma 7, and Theorems 8--10). They
  define the minimum union support of representatives of prescribed cosets and then the worst case
  over collections of cosets. This is the direct terminology predecessor for the ordinary block
  costs, but it has neither the target-coordinate normalization nor the outer-functional
  concatenation optimization. Cache key `arXiv:1804.02692`; SHA-256
  `904ff548b692a9a44ff89f238f0240004cc6cb2201b3f2e2e4b823dd16f83ccc`.
- **Partial:** Chen, Ling, and Xing, *Quantum Codes from Concatenated Algebraic-Geometric Codes*,
  published version, Section II through Theorem 2.1. They give the classical decomposition of the
  dual of a concatenated code into an outer-dual image plus the direct sum of inner duals. This is
  the algebraic ancestor of the block-functional decomposition. They do not optimize a prescribed
  target subspace over joint coset supports. Cache key `10.1109/TIT.2005.851760`; SHA-256
  `e566d78ab3a82d08ea4fc0441b98a85677dda41ee727a91b365c13b907733f0f`.
- **Partial:** Luo, Mitrpant, Vinck, and Chen, *Some New Characters on the Wire-Tap Channel of Type
  II*, published version, Section III (definitions (12)--(13), Theorems 2--3, and the inverse
  relation to relative generalized weights). This establishes the relative-weight/RDLP support
  hierarchy and its quotient-information role. It does not retain prescribed coset representatives
  or concatenated coefficient lifts. Cache key `10.1109/TIT.2004.842763`; SHA-256
  `eecbc9e01441c1a6955eeb60d17536856957c9d8b3b5ce110dbd1226d9276fd1`.
- **Partial, reused from C957:** Jin and Fu, *Constructions of Locally Repairable Codes via
  Concatenated Codes*, arXiv:2605.04618, Section 3 around Construction 3.2. They use a fixed
  single-parity-check inner code and outer codes over an extension field to obtain parameter
  properties of LRCs. They do not state a functional-fiber optimization or exact transfer of all
  bounded recovery systems. Cache key `arXiv:2605.04618`; SHA-256
  `69847fc4ed1ada75f615ab8d2b2c08484da31253d278f9485cd03f5ab9587d93`.
- **Abstract/metadata only:** Essayag and Zabokritskiy, *The Exact Second Generalized Covering Radius
  of Binary Primitive Triple-Error-Correcting BCH Codes*, arXiv:2608.07215v1, submitted 7 August
  2026. The abstract determines (R_2) for a BCH family and describes it as spanning every
  two-dimensional syndrome subspace with at most eight parity-check columns. It is a new result in
  the established generalized-covering direction, not a concatenation-transfer theorem. Cache key
  `arXiv:2608.07215`; SHA-256
  `aa881c58deef835be03ec522dc0e60a7c5860ea6af0a9dca1f02a3e9edda9490`.

### Search record

The first broad four-query web call exceeded the context-output budget and was discarded as a
command-shaping failure. It supplies no evidence. Replacement searches were narrow and used primary
sources for technical conclusions.

The official arXiv API was queried with `start=0` and `max_results=20`. The exact all-time queries

1. `all:"concatenated code" AND all:"generalized covering radius"`,
2. `all:"concatenated code" AND all:"generalized coset weight"`, and
3. `all:"functional dual" AND all:"recovery" AND all:code`

each returned a valid Atom response with explicit `totalResults=0`. For the interval 2026-07-24
00:00 through 2026-08-24 23:59, the exact query
`all:"generalized covering radius" AND submittedDate:[202607240000 TO 202608242359]` returned one
record, arXiv:2608.07215v1, while

1. `all:"concatenated code" AND (all:"generalized covering radius" OR all:"coset weight") AND
   submittedDate:[202607240000 TO 202608242359]`, and
2. `all:"local recovery" AND (all:"functional dual" OR all:"minimum-support lift") AND
   submittedDate:[202607240000 TO 202608242359]`

both returned explicit zero counts.

Exact web searches for `"generalized coset weights" linear code`, `"coset weight hierarchy"
coding theory`, `"tau-coset weight" code`, and `"relative generalized covering radius" code`
located the generalized-coset and generalized-covering literature above but no combined
concatenated-recovery statement. A zbMATH Open exact-phrase web search returned no relevant record.
MathSciNet and Google Scholar were not accessible. The Semantic Scholar API returned HTTP 429.
Crossref and OpenAlex token searches were too noisy to license a negative and were discarded.

### Priority boundary

The following ingredients are established mathematics and are attributed as such:

- minimum union support for several prescribed cosets or syndromes;
- generalized covering radii obtained by maximizing that cost;
- RGHWs/RDLPs of a nested pair;
- blockwise decompositions of concatenated dual codes; and
- support additivity across direct-sum coordinate blocks.

The manuscript-level result that survives the audit is the exact combination: target-normalized
joint coset-support costs indexed by a linear map (T\to\operatorname{FD}(O)), optimized over the
complete outer functional dual, give the first nonconfined recovery system in a finite
concatenation. Its zero-functional and outer-distance specializations are the existing RGHW
threshold, and its one-dimensional specialization is the pointed weighted theorem. No consulted
source states this formula or its exact coefficient/support transfer consequence. Because the
search was not exhaustive over MathSciNet or Google Scholar, the manuscript should describe the
classical components precisely and state the combined theorem without an absolute priority claim.

## Integration decision

The theorem survives the proof and bounded priority gates. Integration should use the native
description “minimum union support of prescribed cosets,” cite generalized covering radii, and
avoid introducing a branded fiber metric. The arbitrary-rank formula becomes the principal exact
finite theorem; the outer-distance RGHW theorem and the pointed weighted theorem become transparent
specializations.

## Applied manuscript changes

- Section 4 now defines the ordinary and target-constrained joint coset-support costs and proves
  `thm:ungated-ranked-confinement` for every nonzero target-message subspace. Internal
  recoverability is required only for the RGHW minimization over (T\le W_P).
- `thm:objectwise-confinement` and `thm:ranked-confinement` are derived from the exact finite
  formula after the outer-distance gate. The gate proof uses one vector (u\in T) on which the
  outer-functional map is nonzero and counts at least (d(O^\perp)-1) nonzero helper blocks.
- `thm:weighted-pointed-confinement` is the one-coordinate specialization. Its direct block-fiber
  argument remains in the proof to cover a zero target column, while a nonzero target column gives
  (Z_{j,x}=\Gamma_{j,T}+1).
- The bounded service-rate corollary now assumes the exact demandwise inequalities
  (r<\Gamma_{j,T_a}). The former outer-distance and inner inequalities remain a sufficient
  specialization and the route to the eventual-family statement.
- The abstract, introduction, main theorem, conclusion, README, metadata, theorem map, proof
  ledger, referee guide, referee dossier, verification prose, and claim manifest now present one
  exact finite theorem with the RGHW and scalar formulas as specializations.
- Zhang--Yaakobi--Etzion--Schwartz and Elimelech--Firer--Schwartz are cited for generalized coset
  weights and generalized covering radii. No new branded metric terminology was introduced.
- The information-loss diagram is stated as normalized recovery systems to exact helper supports
  to relative-weight minima. The text distinguishes this support hierarchy from the additional
  realization data needed by the finite concatenation formula.

## Validation so far

- source-only formal-boundary check: PASS, 22 claims, four reviewer terminals, no axiom audit run;
- deterministic `make update-pdf`: PASS, 22 pages, warning-free, 22 claims, four Lean terminals;
- visual inspection of the new theorem and specialization on rendered pages 8--10: PASS;
- `git diff --check`: PASS;
- no Lean source, theorem, terminal, toolchain pin, or expected-axiom file changed.

## Mystery ledger

### Hard red-team repairs

- The exact zero-functional escape construction needs a second inner block.  The theorem,
  abstract, main-theorem synopsis, service-rate corollary, reviewer guide, claim manifest, and
  proof records now state (N\ge2).  Without this hypothesis the displayed zero-sector candidate
  need not be attainable; this was a real missing hypothesis, not an expository preference.
- The target normalization is minimized together with the helper lift.  Fixing an arbitrary
  section of (G_P) would overcharge a target subspace and would not give an intrinsic minimum.
- The exact theorem allows every nonzero (T\le U_P), assigning cost infinity when no normalized
  inner system exists.  The RGHW and service-rate specializations correctly restrict to
  (T\le W_P).
- The nonzero target-block projection of the outer code remains explicit.  It is used to rule out
  nonzero functional-dual tuples supported only on the target block, so it cannot be dropped while
  retaining “nonzero functional sector = nonconfined sector.”

### Extra-juice and adversarial closeout

- **Settled:** the exact formula also removes the radius from the coarse specialization.  If
  \[
  d(O^\perp)\ge M_t(D_P,K_P)+d(I^\perp)+1,
  \]
  then every nonzero functional sector costs at least the zero-sector minimum and therefore
  \[
  \Gamma_{j,t}=M_t(D_P,K_P)+d(I^\perp).
  \]
  This is now recorded directly after the exact theorem.
- **Settled:** demandwise exact confinement, not the coarser outer-distance gate, is sufficient for
  bounded service-rate transfer.  The corollary now uses (r<\Gamma_{j,T_a}) and keeps
  (T_a\le W_P).
- **Settled:** the support cost is basis-independent because it is the union support of the image
  of a linear lift; choosing a basis only identifies it with the established joint-coset problem.
- **Settled:** there is no hidden cancellation between blocks.  Their coordinate sets are disjoint,
  so fixed-functional lift costs add exactly, while cancellation within a block is already included
  in the coset minimum.
- **Open, successor-owned:** determine whether these prescribed-coset support functions compose
  under repeated concatenation by an exact min-plus law.  The zero and nonzero functional sectors
  must remain distinguished; no composition theorem is asserted here.
- **No other unresolved theorem defect:** the proof, priority boundary, finite/eventual quantifiers,
  target-section minimization, two-block edge case, and terminology have explicit resolutions.

### Final validation

- source-only formal-boundary check: PASS, 22 claims, four reviewer terminals;
- deterministic PDF/release build: PASS after the two-block repair, 22 pages, warning-free, 22
  claims, four Lean terminals;
- `git diff --check`: PASS;
- no Lean source, theorem, reviewer terminal, toolchain pin, or expected-axiom file changed.
