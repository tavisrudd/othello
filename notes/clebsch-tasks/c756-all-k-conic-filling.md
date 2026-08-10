# C756 — all-\(k\) conic-filling classification

**Lane:** `clebsch`

**Status:** active open mathematics.  The saturated-external branch is closed
and transferred to C894.  C756 retains the saturated-internal branch and the
full nonsaturated branch.  The latter is not reduced to one conic point type
in general, but the entire \(k=12\) layer is now impossible over every finite
field.  At \(q=47\), all 22 external-deletion stars fail \(E_9=0\); at
\(q=49\), all 22 fail the divided equation \(E_7=0\); both genuine
all-passant rows have no geometric star.  At \(q=53\), the 230
external-deletion and 44 all-passant stars have zero complete centers.  The
direction bound excludes \(q>53\), while even fields and \(q\le43\) were
already settled.  At \(k=13\), exact twelve-line geometry also closes
\(q=59\), while at \(q=61\) exactly 96 normalized mixed leaves survive
geometry and every one fails the first forced equation \(E_6=0\); the
all-passant row has no leaf.  Thus the complete \(k=13\) layer is impossible
over every finite field.  At \(k=14\), none of the 96 exact \(q=61\) mixed
leaves admits a thirteenth line, so that field also closes.  At \(q=67\) the
mixed branch has no thirteen-line star, while all 92 all-passant stars fail
already at \(E_{12}\).  At \(q=71\), the all-passant branch has no star and
all 39 mixed stars fail their first forced equation \(E_8=0\).  At \(q=73\),
neither branch has a geometric star.  Thus the complete \(k=14\) layer is
also impossible over every finite field, and no \(k=15\) census is planned.
In the saturated-internal branch, coherence canonically produces a dual
3-net of order \((q+3)/2\); the collinear-component conic theorem and subgroup
arithmetic now exclude every prime \(q>5\).  Extension fields remain at a
precise characteristic-threshold version of that theorem.
The character-weighted
all-center residual sum is the difference of the \(\pm1\) root
multiplicities of an exact
degree-\(\delta S(A)\) norm polynomial; its trace coefficient gives the sum
modulo the characteristic.  At defect two the scalar resultant detects the
zero-weight case but necessarily loses the sign \(W=\pm2\).

> **LIVE CARD.**  Keep only current conclusions, gates, stop rules, ownership,
> and authoritative pointers here.  Put evidence, failed routes, correction
> trails, and detail in dated C756 reports.

## Goal

Remove the \(k\le8\) boundary and prove, or find a counterexample to, the
complete statement:

> For every \(k\) and every prime power \(q\), the only \(k\)-arcs in
> \(\mathrm{PG}(2,q)\) whose uncovered locus is the full point set of a
> nonsingular conic are the projective four-frame over \(\mathbb F_5\) and
> the Clebsch hexagon over \(\mathbb F_{11}\).

Quotable form if proved: *deep-hole loci are conics exactly twice, ever.*

## Scope correction

No current theorem excludes external or mixed-type primal arcs in the
nonsaturated branch.  The point-type audit now shows exactly where that
matters:

- polarity gives a mixed secant/passant arrangement, but every pairwise node
  is internal because it is the pole of a chord passant;
- at \(q=53,k=12\), moment collapse, covariance rank two, the critical
  equations, and the open separator Hessian hold for either deleted-point
  type and arbitrary types among the remaining points;
- the all-internal hypothesis first enters the old offset/node-character
  descent, where every polar line was parameterized as a passant;
- \(q=47\) has a bounded degree-eight star carrier, while at \(q=49\) the
  divided elementary form \(E_7\) retains the information lost by ordinary
  characteristic-seven moments;
- \(k=12\) is the first candidate size in these fields, not their only
  nonsaturated size.

Authorities:
`notes/2026-08-09-c756-all-k-status-assumption-audit.md` and
`notes/2026-08-09-c756-nonsaturated-point-type-ledger.md`.

## Ownership and routing

- C756 is a research task; do not edit `papers/` under this ID.
- C756 owns this card, dated C756 reports, and task-specific evidence.
- C894 owns the saturated-exterior/local-Paley publication package.
- Paper IV supplies reusable definitions and the weight-eight method but does
  not own or block this theorem.
- Optional stuck-state/referee context:
  `notes/clebsch-tasks/c756-proof-expert-dossier.md`.  Do not preload it for
  routine continuation.

## Proved common core

- The conic-filling condition is equivalent to hereditary chord externality
  plus full off-conic covering.
- Even \(q\) is impossible because the nucleus is never covered.
- In odd characteristic, chord externality is the fixed quadratic-character
  condition on pairwise binary-quadratic resultants.
- The covering LP has degree cap \(\lfloor k/2\rfloor\).
- A spare external line gives either
  \(\binom{k-1}{2}\ge q\), or saturation with
  \(k=(q+1)/2\) and all points external, or
  \(k=(q+3)/2\) and all points internal.
- In the nonsaturated case the direction quotient improves the bound to
  \(\binom{k-1}{2}\ge q+2\); defects zero and one are impossible.
- The classification is exact for every \(k\) and odd prime power \(q\le43\):
  only the \(q=5\) four-frame and \(q=11\) hexagon occur.
- No conic-filling \(12\)-arc exists over any finite field.
- No conic-filling \(13\)-arc exists over any finite field.
- No conic-filling \(14\)-arc exists over any finite field.
- A saturated-internal coherent support is a dual 3-net of order
  \((q+3)/2\); over prime fields this leaves only the \(q=5\) four-frame.
- Over every odd prime power, the two affine net components have the
  complementary-factor form
  \((x,\pm S(x))\) on the nonroots of \(S\), where
  \(RS=X^q-X\), \(\deg R=(q+3)/2\), and \(\deg S=(q-3)/2\).

## Current branch map

### Saturated-external — closed, publication work in C894

An exterior arc of \((q+1)/2\) external conic points exists only for
\(q\in\{3,7,11\}\), in one conic-stabilizer orbit per field; covering selects
the \(q=11\) hexagon.  The all-field proof and cold read are authoritative.
Do not reopen this branch in C756.

Authorities:
`notes/2026-08-08-c756-saturated-exterior-consolidated-proof.md` and
`notes/2026-08-08-c756-consolidated-proof-cold-referee-read.md`.

### Saturated-internal — prime fields closed; extension conic gate open

Put \(q=2m-1\).  Polarity turns a hypothetical example into \(m+1\) passants
in dual-arc position whose pairwise intersections form an internal star
\(\mathcal B(Y)\).  Covering is exactly

\[
 \mathcal B(Y)\text{ meets every secant and every passant}. \tag{A}
\]

Tangents automatically avoid the star.  The live geometric gate is:

> prove that every such coherent star over a proper extension field with
> \(q>5\) misses a non-tangent line.

Coherence now has a standard incidence model.  For an oriented support
\(Z\subset\mathbb F_{q^2}\), the three sets consisting of \(Z\), \(Z^q\),
and the character-opposite directions together with the trace-zero direction
form a dual 3-net of order \((q+3)/2\).  If \(q\) is prime, Theorem 5.1 of
Blokhuis--Korchmaros--Mazzocca forces the two affine components onto a conic;
splitting and the two-line subgroup classification leave only \(q=5\).
For proper prime powers the net order exceeds the characteristic.  The live
gate is the same conic conclusion using the extra Frobenius exchange and
quadratic-character direction component.

The extension seam is now algebraic.  If \(H_2\) is the degree-\(<\deg R\)
remainder of \(S^2\) modulo \(R\), conic containment is exactly
\(\deg H_2\le2\), equivalently the vanishing of the coefficient band
\[
 [X^j]S^3=0\qquad((q+3)/2\le j\le q-1).
\]
Writing the proper Laurent part of \(S^3/(X^q-X)\) as
\(\sum c_rX^{-r}\), the third odd divided coefficient forces
\(r(r+1)c_r=0\) through the whole required range.  Only
\(r\equiv0,-1\pmod p\) can survive.  If \(F=H_2/R\), this is the truncated
rank-two Cartier tail
\(F=A(Z^{-p})+ZB(Z^{-p})+O(Z^{-(n-2)})\).  Every higher odd coefficient
acts on the same tail through the exact nonlinear coupling
\[
 \frac{H_{2j}}R=\operatorname{pr}_{<0}(R^{j-1}F^j).
\]
The ghost module is affine-stable, so coordinate translation is not an
additional equation.  After reciprocation, the same condition is a
two-component Frobenius--Pade congruence against the unit reciprocal factor
\(R^\vee\), while the higher equations impose the nonlinear compatibility
with \(H_2\equiv S^2\pmod R\).  Its numerator space has dimension
\(q/p+2\); quotienting by the three-dimensional conic numerators leaves an
exact \(q/p-1\)-dimensional saturated ghost module.  More generally, the
rungs \(j=p^a\) form a
Frobenius-semilinear digit tower: for \(p\ge5\) every level
\(0\le a\le e-1\) is available, and for \(p=3\) every non-top level is.
Lucas selects the corresponding base-\(p\) digit of the Laurent index.  If
the descended digit maps have zero common kernel on the ghost quotient, the
extension conic lemma follows; otherwise only their common kernel must meet
the genuinely nonlinear \(j=2\) equation.
Multiplying back the root
divisor of \(S\) packages the entire hierarchy as a full-field norm
identity: the two completely split degree-\(q\) products
\(\prod_{x\in\mathbb F_q}(U+Vx\pm WS(x))\) differ by
\(\gamma WQ_D(V,W)C_S(U,V)\), whose \(U\)-degree is only \((q-3)/2\).

Exact necessary structure already available:

\[
 \sum_{j\ge1}(j-1)(j-2)a_j
 =\frac{m(m-2)(m-3)(m-5)}4, \tag{B}
\]

which excludes \(q=7\), plus the certified diagonal allocation excluding the
rigid \(q=9\) profile.  Covering also forces

\[
 T_4(Y)\ge
 \frac{m(m-2)(m-1)(m+1)}{8(2m-1)}>0. \tag{C}
\]

For the outside-by-support signed matching block,

\[
 R\mathbf1=0,
 \qquad R^{\mathsf T}R=(m-2)((m+1)I-J), \tag{D}
\]

and each row is a signed chord-matching vector.  These are necessary global
interfaces, not contradictions.  Local diagonal signs, Smith torsion, and the
abstract frame alone do not close the branch.

### Nonsaturated — mixed-type ledger complete, classification open

For a deleted arc point \(P\), a spare external line gives

\[
 D_P(T)=(T^q-T)E_P(T),\qquad
 \deg E_P=\delta:=\binom{k-1}{2}-q. \tag{E}
\]

The clean uniform target remains a masked Rédei theorem forcing a missing
direction for every \(\delta\ge2\).  No such carrier is proved.

The point-type gate is now exact.  If \(e\) of the \(k\) arc points are
external, then the number of ordered deleted-point/spare-passant pairs, each
carrying a degree-\(\delta\) quotient (E), is

\[
 k\left(\frac{q+1}{2}-(k-1)\right)-e. \tag{F}
\]

At \(k=12\), an external versus internal deleted point supplies respectively
\(12/13\), \(13/14\), and \(15/16\) spare-line quotients for
\(q=47,49,53\).  In the dual arrangement all 55 nodes are internal, even
when the eleven lines are a secant/passant mixture.  Simultaneous projection
forces

\[
\begin{array}{c|c|c}
q&P\text{ external}&P\text{ internal}\\ \hline
47&e_9,\ldots,e_{11}=0&e_9,\ldots,e_{12}=0\\
49&e_7,\ldots,e_{12}=0&e_7,\ldots,e_{13}=0\\
53&e_3,\ldots,e_{14}=0&e_3,\ldots,e_{15}=0.
\end{array}                                                \tag{G}
\]

The degree-nine separators and degree-ten generators lie in every window.
At \(q=47\), ordinary polarization produces an explicit bounded
quadratic-through-octic carrier: the 42 coefficients of the binary forms
\(E_2,\ldots,E_8\) determine all moment tensors through degree eleven and
one multilinear partition function packages the star product, generators,
and separators as its value, gradient, and Hessian.  At \(q=49\),
characteristic seven destroys the mixed moments from degree seven onward;
use Hasse/divided-power coefficients instead.  At \(q=53\), the common range
through degree fourteen gives the rank-two critical core for both point
types.

The aggregate collision identity

\[
 \delta\left(k\left(\frac{q+1}{2}-(k-1)\right)-e\right)
 =\sum_{X\notin A\cup C}(d_X-1)s_A(X)                   \tag{H}
\]

retains all deleted points and spare lines.  Its character-weighted refinement
is exact locally: on a spare line it is the quadratic-character sum over the
degree-\(\delta\) residual divisor \(E_{P,\ell}\).  At defect two it lies in
\(\{-2,0,2\}\).  If \(B_{P,\ell}\) is the residual Artin algebra and
\(u=(Q_\ell\bmod E_{P,\ell})^{(q-1)/2}\), then the local weight is
\(\operatorname{Tr}(u)\), its scalar resultant sign is \(N(u)\), and the
product of the characteristic norm polynomials over all deleted points and
centers is

\[
 (Z-1)^{(\delta S(A)+T_A)/2}(Z+1)^{(\delta S(A)-T_A)/2}. \tag{H'}
\]

Thus \(T_A\) is the difference of the \(\pm1\) root multiplicities of one
exact all-center resultant; its negative next-to-leading coefficient is
\(T_A\) modulo the characteristic.  At defect two,
\(W_{P,\ell}^2=2(1+\chi(\operatorname{Res}(E_{P,\ell},Q_\ell)))\).
The scalar norm alone cannot distinguish all-external from all-internal
residual pairs; the remaining covariance work must retain the trace of the
linear remainder of \(Q_\ell^{(q-1)/2}\) modulo \(E_{P,\ell}\).  Authority:
`notes/2026-08-09-c756-all-center-resultant-norm.md`.

The masked direction and intercept data also have a uniform finite-algebra
carrier.  Let \(A_{\rm node}\) be the split function algebra of the
\(q+\delta\) chord nodes and let
\(B_{\rm dir}=\operatorname{Map}(\mathbb F_q,\mathbb F_q)\) pull back along
the slope map.  The excess module
\[
 M=A_{\rm node}/B_{\rm dir}
\]
has dimension exactly \(\delta\).  Slope multiplication descends to \(M\)
and has characteristic polynomial \(E_P\); the classes
\([U],[U^2],\ldots\) form a canonical intercept flag spanning every repeated
fibre.  Fibrewise trace gives a canonical covariance form on \(M\), whose
intercept-power Gram determinant at multiplicity \(\mu\) is
\(\mu^{\mu-2}\prod_{a<b}(u_a-u_b)^2\).  The node-character condition is the
constant square class of \(Q(T,U)\in A_{\rm node}^\times\).  This quotient
lives only on the Frobenius-fixed finite base and does not assume a global
Moore Cartier divisor.  Weighting covariance by \(Q\) reduces the global
conic contribution to
\(\epsilon^{\delta+r}\prod_{\mu_t\ge2}
\chi(\sigma_t)^{\mu_t-2}\), where
\(\sigma_t=\sum_{\pi^{-1}(t)}Q(t,u)\); only multiplicity at least three
remains unknown.  Each \(\sigma_t\) depends only on the first two
coefficients of the repeated-root factor of \(F(U,t)\), and equivalently is
a square-normalized matching sum of
\(Q(v_i)Q(v_j)-B(v_i,v_j)^2\) over chord endpoints.  The
earlier Euler-character norm does not determine this value-level trace:
replacing the weights by their constant signs reduces weighted covariance
tautologically to ordinary covariance.

### \(q=53\): type-uniform critical core

For either deleted-point type, degree-nine node separators exclude covariance
ranks zero and one; nonsingular covariance gives

\[
 \operatorname{rank}M=2,
 \qquad \nabla\mathcal Z(c)=0,
 \qquad \partial_i\partial_j\mathcal Z(c)\ne0\ (i\ne j). \tag{I}
\]

External deletion is impossible before the covariance split.  Its unique
\(UV=2\) conic normal form has exactly 230 normalized eleven-line stars with
all 55 nodes internal and no triple concurrency.  Those leaves are the full
covariance-free geometric list, not merely the aligned split list, and none
has even one complete center among the fifteen required internal directions;
their best projections span at most 45 of 53 fibres.  This closes the seven
anisotropic rows, all disjoint-root split rows, the one-shared-root case, and
the aligned split case simultaneously.  Authority:
`notes/2026-08-09-c756-external-deletion-all-covariance-closure.md`.

### \(q=47,k=12\): complete negative classification

The residue-class sign must be changed from the \(q=53\) geometry:
\(\chi(-1)=-1\), so internal split-model nodes satisfy
\(\chi(UV-5)=-1\).  With that corrected predicate, external deletion has
exactly 22 normalized mixed secant/passant stars.  Every leaf has
\(E_9\ne0\), against the twelve-center interpolation window
\(E_9=E_{10}=E_{11}=0\); independently, no leaf has one complete center.
If there is no external point, all polar lines are passants, and the genuine
norm-normalized all-passant row has no eleven-line geometric star.  Therefore
\[
 \boxed{\text{no conic-filling }12\text{-arc exists over }\mathbf F_{47}.}
\]
This does not cover \(k>12\).  Authority:
notes/2026-08-09-c756-q47-k12-complete-closure.md.

### \(q=49,k=12\): complete negative classification

Native \(\mathbf F_{49}\) geometry gives exactly 22 normalized
external-deletion mixed-type stars, all with five secants and six passants.
Every leaf violates the first forced divided elementary identity
\(E_7=0\), and independently none has one complete center.  If all arc
points are internal, the anisotropic all-passant model has 600 states but no
eleven-line geometric star.  Hence
\[
 \boxed{\text{no conic-filling }12\text{-arc exists over }\mathbf F_{49}.}
\]
Together with the \(q\le43\), \(q=47\), and \(q=53\) results and the bound
\(55\ge q+2\), this closes \(k=12\) over every finite field.  Authority:
notes/2026-08-09-c756-q49-and-global-k12-closure.md.

### \(q=53,k=12\): complete negative classification

If no point is external, all twelve polar lines are passants.  The two
covariance-free conic offset classes have respectively zero and 44 normalized
eleven-line stars.  Every one of the 44 has zero complete centers among the
sixteen required directions; each center projection spans between 36 and 43
of the required 53 fibres.  Thus the all-internal branch also fails before
covariance, and
\[
 \boxed{\text{no conic-filling }12\text{-arc exists over }\mathbf F_{53}.}
\]
This does not cover \(k>12\), whose defect and interpolation window differ.
Authority: `notes/2026-08-09-c756-q53-k12-complete-closure.md` and its
exact script/certificate bundle.

There is also a shorter aggregate certificate for the 44 leaves.  If
\(\rho(c)\) is projection collision energy, pair-direction double counting
gives
\[
 \sum_{c\ {\rm internal}}\rho(c)
 =\#\{\{X,Y\}:XY\cap r_0\text{ is internal}\}.
\]
For every leaf, the eleven used centers contribute 657 and the sixteen
missing centers contribute 290.  A complete defect-two center has
\(\rho\in\{2,3\}\), so simultaneous completeness would give at most 48,
contradicting 290.  The common diagonal character sum \(-86\) and four-line
histogram \((48,138,118,26)\) are exact across all four normalized dihedral
orbits but presently have no symbolic all-\(q\) derivation.  Authority:
notes/2026-08-09-c756-star-collision-character-identity.md.

### \(q=59,61,k=13\): complete negative classification

At \(q=59\), the 30 normalized mixed seed rows and 15 present all-passant
seed rows have no twelve-line geometric star after respectively 187,764,531
and 3,042,991 search nodes.  At \(q=61\), the all-passant row again has no
star; the mixed row has exactly 96 normalized stars, all of type three
secants plus nine passants, and every one fails \(E_6=0\).  None of those 96
has even one complete center.  Hence no conic-filling \(13\)-arc exists over
any finite field.  Authority:
notes/2026-08-09-c756-global-k13-closure.md.

### \(q=61,67,k=14\): complete negative classification

At q=61 none of the 96 exact twelve-line mixed stars admits a compatible
thirteenth line, and the all-passant row has no twelve-line star.  At q=67,
the complete mixed search visits 946,250,059 recursion states and has no
thirteen-line geometric star.  The all-passant search has exactly 92 stars;
all 92 first fail \(E_{12}=0\), and none has a complete unused center.  These
are the first two closed fields in the four-field k=14 direction-bound
frontier.  Authorities:
notes/2026-08-09-c756-k14-ledger-q61-closure.md and
notes/2026-08-09-c756-q67-k14-closure.md.

### \(q=71,73,k=14\): complete negative classification

At q=71, the complete anisotropic all-passant search has no thirteen-line
star.  The mixed search visits 2,570,632,814 recursion nodes and returns 39
geometric stars; all 39 first fail the forced equation \(E_8=0\), and none
has a complete center.  At q=73, the all-passant search has no star in
38,310,405 states, while the independently implemented mixed search has no
star in 4,198,162,536 states.  Together with q=61,67, this closes \(k=14\)
over every finite field.  Authorities:
`notes/2026-08-10-c756-q71-k14-all-passant-closure.md`,
`notes/2026-08-10-c756-q71-k14-mixed-closure.md`,
`notes/2026-08-10-c756-q73-k14-all-passant-closure.md`, and
`notes/2026-08-10-c756-q73-and-global-k14-closure.md`.

## Ordered next actions

1. Do not open a \(k=15\) census.  Treat q=67,71,73 only as theorem-design
   data for the all-\(q\) branches.
2. For saturated-internal configurations, prove the special-direction conic
   lemma over proper extension fields by analyzing the nonlinear Cartier
   system \(\operatorname{pr}_{<0}(R^{j-1}F^j)\).  Couple the genuinely
   nonlinear quadratic rung \(j=2\) to the simultaneous semilinear digit
   tower \(j=p^a\), or classify the equivalent completely split lacunary norm
   pair; do not retry translations of the affine coordinate.
3. For the nonsaturated branch, prove the masked Redei missing-direction
   theorem for arbitrary defect through the \(\delta\)-dimensional excess
   node module.  Control its weighted global discriminant through the first
   two repeated-root coefficients or the equivalent Gram matching sums, then
   compare it with the constant conic square class through star realization.

## Stop rules

Do not:

- assume a nonsaturated arc is all-internal or its polar arrangement
  all-passant, or conversely discard the type-uniform star identities merely
  because the arrangement is mixed;
- call \(q=53\) the first open field, or infer general \(\delta\) from defect
  two without a propagation theorem;
- reopen the closed \(q=53,k=12\) layer without identifying a normalization
  or projection-completeness flaw in its exact bundle;
- reopen the closed \(q=47,k=12\) layer with the unchanged \(q=53\)
  node-character sign;
- replace the divided \(q=49\) identity \(E_7=0\) by the Frobenius-tautological
  power sum \(P_7=0\);
- infer any \(k=13\) coefficient window from \(k=12\); the exact table starts
  only at \(E_8\) for \(q=59\) and \(E_6\) for \(q=61\);
- rerun the closed aligned state graph, generic 11-variable elimination, or
  an unchanged quartic character bound;
- retry normalized one-variable selectors, their first two slices,
  unweighted subresultants, local diagonal-sign classification, Smith torsion,
  raw cardinality/parity/defect averaging, or abstract matching-frame
  contractions without a new global identity;
- classify arbitrary near transversals without retaining star realization;
- claim that counting in general cannot close the theorem merely because
  untyped low moments stalled;
- cross the degree-16 mask boundary blindly.  A targeted degree-16
  cross-center identity is allowed if its lost-information role is explicit;
- edit a manuscript under C756.

## Evidence boundaries

- The \(q\le43\) exhaustive classification has internal cross-checks; a wholly
  independent uncovered-set replay extends only through \(q\le19\).
- The saturated-external human proof has a successful cold read; C894 owns its
  remaining external-specialist safeguard.
- The \(q=53\) all-passant aligned certificate has independent formula-level
  invariant checks, not a second independent exhaustive search implementation.
- Exact all-type searches cover \(k=12\) at \(q=47,49,53\), with independent
  formula-level checks but not second independent exhaustive enumerators.
  Higher sizes remain separate.

## Current assessment

- Saturated-external: closed.
- Saturated-internal: sharply constrained but open at global coherence.
- Nonsaturated, arbitrary type: the first-size point/type/window ledger is
  exact, and its character total has the all-center trace/norm law (H');
  \(k=12\) is closed globally, but higher sizes are open.  The direction and
  intercept excess is compressed canonically into a \(\delta\)-dimensional
  module whose slope characteristic polynomial is \(E_P\).
- \(q=47,k=12\): closed exactly for every point type.
- \(q=49,k=12\): closed exactly for every point type.
- \(q=53,k=12\): closed exactly for every point type and covariance class.
- \(k=13\): closed exactly over every finite field; at \(q=61\), all 96
  geometric mixed leaves fail \(E_6=0\), and the other remaining rows have no
  twelve-line star.
- \(k=14\): q=61 closes by exact nonextension; q=67 has no mixed star and
  all 92 all-passant stars fail \(E_{12}\); at q=71 all 39 mixed stars fail
  \(E_8\), and q=73 has no geometric star of either type.  The layer is
  closed over every finite field.
- Saturated-internal: coherent supports are dual 3-nets; all prime fields
  \(q>5\) are excluded structurally.  Proper extension fields remain at the
  special-direction conic lemma, now reduced to the affine-stable
  \(r\equiv0,-1\pmod p\) Laurent ghosts and their higher-power coupling.
- Near-term full all-\(k\) proof odds remain below the former 20--25% estimate:
  the higher-size and saturated-internal gates remain; a counterexample
  remains live.

## Durable pointers

- Current audit:
  `notes/2026-08-09-c756-all-k-status-assumption-audit.md`.
- Character-weighted all-center trace/norm identity:
  `notes/2026-08-09-c756-all-center-resultant-norm.md`.
- q=47 quadratic-through-octic partition carrier:
  `notes/2026-08-09-c756-q47-octic-carrier.md`.
- Complete q=47,k=12 closure:
  `notes/2026-08-09-c756-q47-k12-complete-closure.md`.
- Complete q=49,k=12 and global k=12 closure:
  `notes/2026-08-09-c756-q49-and-global-k12-closure.md`.
- k=13 ledger and q=47,49,53 geometric closure:
  `notes/2026-08-09-c756-k13-ledger-low-field-closure.md`.
- Global k=13 closure at q=59,61:
  `notes/2026-08-09-c756-global-k13-closure.md`.
- k=14 ledger and q=61 extension closure:
  `notes/2026-08-09-c756-k14-ledger-q61-closure.md`.
- q=71 mixed closure:
  `notes/2026-08-10-c756-q71-k14-mixed-closure.md`.
- q=73 and global k=14 closure:
  `notes/2026-08-10-c756-q73-and-global-k14-closure.md`.
- Coherent dual-3-net reduction and prime-field theorem:
  `notes/2026-08-10-c756-coherent-dual-three-net.md`.
- Extension-field complementary-factor and Frobenius-ghost reduction:
  `notes/2026-08-10-c756-dual-net-frobenius-ghost-reduction.md`.
- Nonsaturated excess-node module:
  `notes/2026-08-10-c756-nonsaturated-excess-node-module.md`.
- External-deletion all-covariance closure:
  `notes/2026-08-09-c756-external-deletion-all-covariance-closure.md`.
- Complete \(q=53,k=12\) closure:
  `notes/2026-08-09-c756-q53-k12-complete-closure.md`.
- Mixed-type equation ledger:
  `notes/2026-08-09-c756-nonsaturated-point-type-ledger.md`.
- External-deletion aligned split closure:
  `notes/2026-08-09-c756-aligned-split-mixed-closure.md`.
- Universal and bounded foundation:
  `notes/2026-08-01-c756-all-k-conic-filling.md`.
- Saturated-internal foundation:
  `notes/2026-08-01-c756-saturated-internal-branch.md`.
- Nonsaturated direction quotient:
  `notes/2026-08-01-c756-nonsaturated-direction-reduction.md`.
- All-internal premise of the defect-two star model:
  `notes/2026-08-09-c756-defect-two-star-near-transversal.md`.
- Latest conditional chain:
  `notes/2026-08-09-c756-tt-star-moment-collapse.md`,
  `notes/2026-08-09-c756-ej-antipodal-fibres.md`,
  `notes/2026-08-09-c756-ej2-torus-contraction.md`,
  `notes/2026-08-09-c756-ej3-elliptic-overlap-squeeze.md`, and
  `notes/2026-08-09-c756-aligned-critical-closure.md`.

Historical method details remain in dated C756 reports, not this card.
