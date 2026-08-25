# C961 — Composition of prescribed-coset recovery costs

**Lane**: `complete-ports`

**Status**: COMPLETE; EXACT ORDINARY AND TARGET-NORMALIZED COMPOSITION PROVED; SHARP
ENVELOPES AND SCALAR NONCOMPOSITION ESTABLISHED; PRIORITY BOUNDED; 24-PAGE MANUSCRIPT AND
STANDALONE RELEASE GATES PASS

## Question

For a tower of finite fields (F\subseteq L\subseteq M), let (B) be an inner
(F)-linear represented code with message space (L), let (A) be an (L)-linear represented code with
message space (M), and let (A\circ B) be their concatenation.  Determine whether the minimum union
supports of prescribed cosets, the target-normalized costs, and the exact nonconfinement thresholds
compose from the corresponding data of (A) and (B).

The target is an equality, not merely a support-distance estimate.  Zero and nonzero
outer-functional sectors must remain separate.

## Current answer

The ordinary prescribed-coset support function composes by an exact min-plus substitution.
For numerical target-normalized costs, the corresponding closed input is the prescribed-coset
support function of the helper restriction, together with the intermediate target contribution.
If exact equations are also to be transported, one must retain the corresponding lift relation,
not only its minimum support.  The numerical functions and the lift relations compose exactly and
associatively.  The scalar threshold (\Gamma) does not compose by itself: it forgets the
functional labels that the next outer code constrains.

## 1. Ordinary prescribed-coset support

Use the trace pairing to identify
\[
 \operatorname{Hom}_F(L,F)\cong L,
 \qquad
 \operatorname{Hom}_L(M,L)\cong M,
 \qquad
 \operatorname{Hom}_F(M,F)\cong M.
\]
Let
\[
 \phi_B:F^{E_B}\longrightarrow L,
 \qquad
 \phi_A:L^{E_A}\longrightarrow M
\]
be the resulting dual restriction maps.  The composite map on an array
(y=(y_e)_{e\in E_A}) is
\[
 \phi_{A\circ B}(y)=\phi_A\bigl((\phi_B(y_e))_{e\in E_A}\bigr).
\]
For a finite-dimensional (F)-space (T) and an (F)-linear prescribed map (b:T\to L), put
\[
 \Lambda_{B,T}(b)=
 \min_{\phi_By=b}|\operatorname{supp}y(T)|.
\]
For (c:T\to M), the exact composition law is
\[
 \boxed{
 \Lambda_{A\circ B,T}(c)=
 \min_{\substack{x:T\to L^{E_A}\\\phi_Ax=c}}
 \sum_{e\in E_A}\Lambda_{B,T}(x_e).
 }
 \tag{C1}
\]

**Proof.** Any lift (y:T\to F^{E_A\times E_B}) determines the intermediate maps
(x_e=\phi_B y_e).  The final support is a disjoint union over inner blocks, so its cardinality is
the sum of their union supports.  At fixed (x), the inner-block lifts are independent and attain
their minima separately.  Minimizing over the lifts (x) of (c) gives (C1).  No cancellation across
blocks is possible because their coordinate sets are disjoint.

Repeated application of (C1) is associative: both parenthesizations minimize over the same full
array of intermediate maps and add the same leaf-block support costs.  This is ordinary elimination
of independent variables in the min-plus semiring.

The trace identifications introduce no extra scalar.  If
(x_e:T\to L)_{e\in E_A}) is the intermediate array, then for (v\in T)
the leaf functional evaluated on a message (m\in M) is
\[
 \sum_e\operatorname{Tr}_{L/F}\bigl(x_e(v)\,\iota_A(m)_e\bigr)
 =\operatorname{Tr}_{M/F}\bigl(\phi_A(x(v))m\bigr).
\]
The equality is trace transitivity after the definition of (\phi_A); nondegeneracy of the trace
pairing gives exactly the constraint (\phi_Ax=c).

## 2. Target contributions and the boundary-conditioned kernel

Let a represented code have dual restriction map (\phi:F^E\to V) and split
(E=P\sqcup J).  For maps
\[
 a:T\to F^P,
 \qquad b:T\to V,
\]
define
\[
 \mathcal K_{\phi,P,T}(a,b)=
 \min\left\{
 |\operatorname{supp}y_J(T)|:
 y:T\to F^E,\ y_P=a,\ \phi y=b
 \right\},
 \tag{C2}
\]
with value infinity when the fiber is empty.  This is a literal boundary-conditioned minimum
support, not a new metric.

For numerical support costs the target coefficient map can be compressed to its message
contribution.  Write
\[
 \phi=(\phi_P,\phi_J),
 \qquad
 u=\phi_Pa:T\to U_P=\operatorname{im}\phi_P.
\]
Then
\[
 \mathcal K_{\phi,P,T}(a,b)
 =\Lambda_{\phi_J,T}(b-u),
 \tag{C3}
\]
because the target coordinates are uncharged and the helper constraint is exactly
(\phi_Jy_J=b-u).  Thus the helper-restriction prescribed-coset function
(\Lambda_{\phi_J,T}) is enough for numerical composition.  The scalar kernel (\mathcal K) retains
the target coefficient label but only the minimum support.  To transport all equations, retain the
lift relation
\[
 \mathscr L_{\phi,P,T}(a,b)=
 \{y_J:T\to F^J:\phi_Jy_J=b-\phi_Pa\},
 \tag{C4}
\]
together with its support filtration.  Blockwise concatenation is the fiber product of these
relations over the intermediate maps; helper coordinates in distinct blocks then form a disjoint
product.  Thus the relations compose associatively and their minimum-support marginalization is
the min-plus law below.

If the target set in (A\circ B) meets the inner block (e) in (P_e\subseteq E_B), write
(a=(a_e)_e).  Then
\[
 \boxed{
 \mathcal K_{A\circ B,P,T}(a,c)=
 \min_{\substack{x:T\to L^{E_A}\\\phi_Ax=c}}
 \sum_{e\in E_A}\mathcal K_{B,P_e,T}(a_e,x_e).
 }
 \tag{C5}
\]
Here (P) is the union of the copies of (P_e), and an empty (P_e) makes the local kernel equal to
the ordinary cost (\Lambda_{B,T}(x_e)).  The proof is the same blockwise disjoint-support argument
as for (C1).

Equivalently, set (u_e=\phi_{B,P_e}a_e).  The target-normalized numerical cost is
\[
 \boxed{
 \mu_{A\circ B,P,T}(c)=
 \min_{\substack{u,x:T\to L^{E_A}\\
                  u_e(T)\subseteq U_{P_e}\\
                  \phi_Au=\operatorname{id}_T,\ \phi_Ax=c}}
 \sum_{e\in E_A}\Lambda_{\phi_{B,J_e},T}(x_e-u_e).
 }
 \tag{C6}
\]
Here (\operatorname{id}_T) denotes the inclusion (T\hookrightarrow M).  For
(P_e=\varnothing), this local term is the ordinary full-block cost
(\Lambda_{B,T}(x_e)).  Formula (C6) is the exact numerical target composition law.  It also shows
why the single marginalized value (\mu_{I,P,T}(b)) is not the natural compositional input: the
next level optimizes over the labelled intermediate maps (u_e,x_e), not merely over their final
minimum.

## 3. Consequences for exact confinement

For a composite inner code (C=A\circ B), substitute (C1) and (C6) into C960's exact formula
\[
 \Gamma_{j,T}(O,C)=
 \min\left\{
 \rho_T(C)+d(C^\perp),
 \min_{0\ne H:T\to\operatorname{FD}(O)}
 \left(
 \mu_{C,P,T}(H_j)+\sum_{h\ne j}\Lambda_{C,T}(H_h)
 \right)
 \right\}.
\]
This gives an exact nested min-plus expression from the leaf-code kernels and the functional duals
at each level.  Its value is independent of parenthesization because (C4) is associative.

The same calculation gives the inner-dual distance needed by the zero-functional sector:
\[
 d((A\circ B)^\perp)=
 \min\left\{
 d(B^\perp),
 \min_{0\ne z\in\operatorname{FD}(A)}
 \sum_{e\in E_A}\Lambda_{B,\langle1\rangle}(z_e)
 \right\}.
 \tag{C7}
\]
The first term is a nonzero inner-dual word in one block; the second is a nonzero middle
functional tuple with independently minimum inner representatives.  This keeps the two sectors
separate at every depth.

The scalar threshold (\Gamma) is an output of this calculation, not a closed input to another
level: it retains only the least escape and discards the functional labels that the next level
constrains.

## 4. Explicit failure of scalar composition

Work over (F_2), identify the two-dimensional message space with (L=F_4), and write its nonzero
elements as (a=1), (b=\omega), and (c=\omega^2=a+b).  Take the first coordinate as target and let
the two represented inner codes have generator columns
\[
 I_1:(a,a,b),
 \qquad
 I_2:(a,a,c).
\]
For both codes the target has one-helper recovery cost (1) and the inner dual has distance (2), so
the zero-functional first-escape value is (3).  Their ordinary coset costs are
\[
\begin{array}{c|ccc}
 &a&b&c\\ \hline
 \Lambda_{I_1}&1&1&2\\
 \Lambda_{I_2}&1&2&1
\end{array}
\]
and their target-block helper costs are
\[
\begin{array}{c|ccc}
 &a&b&c\\ \hline
 \mu_{I_1}&0&2&1\\
 \mu_{I_2}&0&1&2.
\end{array}
\]
Let the length-two outer code have trace-dual (\operatorname{FD}(O)) equal to the
(L)-line spanned by ((1,\omega)).  Its nonzero sector has minimum
\[
 \min_{s\in L^\times}\bigl(\mu_{I_i}(s)+\Lambda_{I_i}(s\omega)\bigr)
 =\begin{cases}1,&i=1,\\2,&i=2.\end{cases}
\]
Hence the exact first nonconfined costs are (1) and (2), although the two zero-functional scalar
inputs are both (3).  A single scalar threshold therefore cannot be iterated; the labelled coset
costs in (C1) and (C6) are necessary.

## 5. Sharp support-distance envelopes

For fixed (B,T), let
\[
 \delta_{B,T}=\min_{0\ne z:T\to L}\Lambda_{B,T}(z),
 \qquad
 R_{B,T}=\max_{0\ne z:T\to L}\Lambda_{B,T}(z).
\]
If (c\ne0), then (C1) gives
\[
 \boxed{
 \delta_{B,T}\Lambda_{A,T}(c)
 \leq \Lambda_{A\circ B,T}(c)
 \leq R_{B,T}\Lambda_{A,T}(c).
 }
 \tag{C8}
\]
Every lift of (c) has at least (\Lambda_{A,T}(c)) nonzero coordinate maps, proving the lower
bound.  A support-minimizing lift has exactly that many, and each costs at most (R_{B,T}), proving
the upper bound.  Both constants are optimal without further hypotheses: take a one-coordinate
outer realization and prescribe a map attaining the relevant extremum.

Replacing (\Lambda_{B,T}) by the helper-restriction costs in (C6) gives the analogous sharp
weighted-support envelopes for target-normalized recovery.  These inequalities are the precise
coarsening obtained when the labelled fiber costs are replaced by their extreme nonzero values.

## 6. Proof audit

The following checks were carried out without computational premises.

1. **Type and trace check.**  The two constituent restriction maps are surjective transposes of
   injective encoders.  Trace transitivity gives the displayed composite restriction map, and
   nondegeneracy removes any possible ambiguity in its (M)-label.
2. **Both inequalities in (C1).**  Every composite lift supplies an intermediate array and has
   cost at least the sum of the corresponding inner minima.  Conversely, every intermediate array
   and a minimizing lift in each block produce a composite lift with exactly that sum.
3. **Target normalization.**  Every map (u_e:T\to U_{P_e}) has a linear target-coordinate lift,
   because (\phi_{B,P_e}) is surjective onto its image.  The condition
   (\phi_Au=\operatorname{id}_T) is therefore equivalent to the original target normalization,
   and the helper contribution in block (e) is exactly (x_e-u_e).
4. **Equation-level transport.**  Minimum-support kernels do not retain all helper coefficients.
   The relation (\mathscr L) does.  Its fiber-product composition proves equation-level transport;
   (C5) and (C6) are only its minimum-support marginals.
5. **Dual-distance sectors.**  A composite dual word either has zero intermediate label, in which
   case one inner-dual block realizes the first term of (C7), or a nonzero tuple in
   (\operatorname{FD}(A)), in which case independent block minima give the second.  The cases are
   disjoint and exhaustive.
6. **Scalar counterexample.**  Direct evaluation of the eight binary coefficient vectors in each
   length-three inner code gives the two displayed tables.  For the three nonzero multiples of
   ((1,\omega)), the target-plus-external costs are respectively ((1,4,2)) and ((2,2,3)).  Thus
   the minima are (1) and (2), while both persistent zero-sector values are (3).
7. **No hidden gate.**  The composition identities do not assume an outer-distance bound.  The
   projection-surjectivity hypothesis enters only when C960 interprets the optimized value as
   exact nonconfinement at a chosen outer block.
8. **Sharp envelopes.**  Each nonzero intermediate coordinate costs between (\delta_{B,T}) and
   (R_{B,T}); a one-coordinate outer realization shows that neither universal constant can be
   improved.

These checks leave no quantifier, off-by-one, cancellation, or attainability defect in
(C1)--(C8).

## 7. Literature and priority audit

Search date: 2026-08-24.  The audit used four full or partial primary texts and exact-title,
exact-phrase, forward-neighborhood, and recent-arXiv searches.  Three sources were read in relevant
full-text sections during C961; the generalized-coset-weight sources already audited in C960 were
reused for the boundary below.

- Aji and McEliece, *The Generalized Distributive Law*, Sections II--III, was read from the official
  author PDF (DOI 10.1109/18.825794; 19 pages; SHA-256
  `6aed6b53e9c21951f801b4bac509db26c6a68b65aa26c5a1de690cff0277779a`).  It treats the
  min-sum semiring and exact variable elimination on junction trees.  Therefore min-plus
  associativity and the generic elimination mechanism in (C1) carry no priority claim here.
- Guruswami and Sudan, *Decoding Concatenated Codes using Soft Information*, pp. 1--3, was read
  from the official author PDF (DOI 10.1109/CCC.2002.1004350; 10 pages; SHA-256
  `9de8a233c00ce45aea3db34023727a3f564c1ce8760c0e96452c3afe93407865`).  It passes
  symbol-indexed weights derived from inner coset-weight data to an outer decoder.  This is the
  closest operational precedent for retaining labelled inner costs rather than one scalar.
- Blomqvist, Gnilke, and Greferath, *On Decoding of Generalized Concatenated Codes and
  Matrix-Product Codes*, Sections III, VI, and VII, was read from arXiv:2004.03538 (23 pages;
  SHA-256 `77096b0638c851a7aad9aaff4b48c091cc5de04a5357913bfaa284080bbd1974`).  It reviews
  constituent encoding and repeated generalized-concatenated decoding.  Its objective is
  error/erasure and GMD decoding, not exact recovery-support or nonconfinement costs.
- Elimelech--Firer--Schwartz and Zhang et al., already read and pinned in C960, supply the
  generalized covering-radius and generalized coset-weight neighborhood.  They define joint coset
  support quantities but do not study their repeated-concatenation substitution in the inspected
  results.

The first attempted broad extraction of two large Blomqvist text ranges exceeded the output
budget and was discarded.  It was replaced by the bounded section reads listed above; no claim
rests on the discarded output.

Exact all-time searches for `"prescribed-coset support"`, `"coset weight" "concatenated
codes"`, `"min-plus" "concatenated codes"`, and `"repeated concatenation" "local
recovery"` found the soft-decoding and generalized-concatenated-decoding neighbors above, but no
source stating (C5)--(C7) for bounded recovery or exact confinement.  Exact arXiv API searches on
the interval 2026-07-24 through 2026-08-24 returned:

- two results for `"concatenated code"`, both quantum and unrelated to the claimed identity;
- zero results for the union of `"repeated concatenation"`, `"generalized concatenated"`, and
  `"coset weight"`; and
- two results for `"local recovery"` combined with composition, min-plus, or concatenation, both
  unrelated quantum papers.

**Priority boundary.**  The min-sum algebra, constituentwise decoding, and use of inner
coset-weight information are established.  The defensible paper-specific result is narrower: the
ordinary and target-normalized prescribed-coset support functions are the closed numerical state
for repeated concatenation; the support-filtered lift relation is the closed equation-level state;
substitution into the exact recovery theorem preserves the zero and nonzero functional sectors;
and the scalar confinement threshold is not a closed state.  No search result combined these
statements.  The manuscript should present the composition law as a structural consequence, not
as a new min-plus principle.

## 8. Manuscript decision

The result is concise enough to enter the paper as one proposition after the exact finite
confinement theorem, with the generic min-sum and soft-decoding precedents cited.  The manuscript
should state (C1), the target-normalized specialization (C6), the dual-distance sector formula
(C7), and the associativity consequence.  The full lift relation belongs in the proof.  The small
(F_2/F_4) example should be included only to justify the assertion that a scalar threshold is not
compositional.

## 9. Manuscript application and validation

The accepted material was added to Section 4.1 as
Proposition `prop:prescribed-coset-composition`.

- Equation `eq:coset-cost-composition` gives (C1).
- Equation `eq:coset-cost-envelope` records the sharp constants in (C8).
- Equation `eq:target-cost-composition` gives the target-normalized recursion (C6), explicitly
  retaining the target images rather than claiming that the marginalized target cost composes by
  itself.
- Equation `eq:dual-distance-composition` gives (C7), preserving the zero and nonzero intermediate
  sectors.
- The proof retains the actual target coefficient maps and full helper lift sets before
  minimum-support marginalization, so equation-level transport is not inferred from numerical
  costs alone.
- The binary/quaternary example proves that the persistent scalar
  (\rho_T(I)+d(I^\perp)) does not determine the next-level cost.

The proposition is classified `absent` in the claim manifest.  No Lean theorem, axiom, or
computational certificate is asserted for it.  The verification prose names the proposition among
the human proofs.  The bibliography credits min-sum elimination, soft concatenated decoding, and
repeated generalized-concatenated decoding at their established strength.

Authority commit `5e91f853f` contains the final sharp-envelope upgrade.  The deterministic release
gate passes at 24 pages, warning-free, with 23 classified claims and four Lean terminals.  The
standalone paper repository passes the same gate at commit `84e2175`; its export manifest identifies
authority commit `5e91f853f650a83022a5ed86741d59f84be3535f`.  The portfolio summary authority and
downstream repository were updated at commits `8e77c5d44` and `323a56f`.  No push or archival
deposit was made.

## 10. EJ and TT closeout

The closeout pass checked what data are genuinely closed under composition.

1. The ordinary labelled support function is closed under min-sum substitution.
2. The marginalized target-normalized cost is not closed by itself.  Numerical composition needs
   the helper-restriction support functions and target images; coefficient-level composition needs
   the support-filtered lift relation indexed by the actual target maps.
3. The persistent scalar threshold is not closed, as the explicit (F_2/F_4) pair shows.
4. Replacing the labelled costs by their least and greatest nonzero values gives the sharp envelope
   (C8); this was added to the proposition.
5. The local-to-global bottleneck remains intact through a tower: after the tower is evaluated as
   one composite inner code, restriction of a nonconfined system to a line still shows that its
   rank-one escape cost governs simultaneous bounded transfer at all recovered dimensions.

### Mystery ledger

- **Settled — minimal numerical state at a target boundary.**  Target images plus the
  helper-restriction prescribed-coset functions suffice; the proof of (C6) supplies both directions.
- **Settled — equation-level state.**  The full lift relation, not its minimum, composes by fiber
  product and retains target and helper coefficients.
- **Settled — distance coarsening.**  The sharp constants are (\delta_{B,T}) and (R_{B,T});
  one-coordinate outer realizations prove optimality.
- **Open — escape-depth profile.**  The nested minimization identifies the first escape from the
  deepest target block, but this task does not classify the least cost of first escape at each
  intermediate depth or relations among those depth-indexed costs.  No manuscript claim depends on
  such a classification, and no successor is allocated here.
- **Open — compressed equation-state representations.**  The lift relation is sufficient but may
  be much larger than necessary.  No canonical smaller representation preserving all coefficient
  equations and support filtrations was proved.  This is an algorithmic representation question,
  not a gap in the composition theorem.
