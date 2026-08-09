# C756 — all-\(k\) conic-filling classification

**Lane:** `clebsch`

**Status:** active open mathematics.  The saturated-external branch is closed
and transferred to C894.  C756 retains the saturated-internal branch and the
full nonsaturated branch.  The latter is not reduced to one conic point type
in general, but the full \(q=53,k=12\) layer is now impossible.  The 230
normalized external-deletion stars and the 44 normalized all-passant stars
have zero complete centers; the other all-passant conic offset class has no
geometric star.  The character-weighted
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
- \(q=47\) has a bounded degree-eight star carrier, while \(q=49\) meets a
  characteristic-seven Hasse/divided-power wall;
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

## Current branch map

### Saturated-external — closed, publication work in C894

An exterior arc of \((q+1)/2\) external conic points exists only for
\(q\in\{3,7,11\}\), in one conic-stabilizer orbit per field; covering selects
the \(q=11\) hexagon.  The all-field proof and cold read are authoritative.
Do not reopen this branch in C756.

Authorities:
`notes/2026-08-08-c756-saturated-exterior-consolidated-proof.md` and
`notes/2026-08-08-c756-consolidated-proof-cold-referee-read.md`.

### Saturated-internal — open global-coherence gate

Put \(q=2m-1\).  Polarity turns a hypothetical example into \(m+1\) passants
in dual-arc position whose pairwise intersections form an internal star
\(\mathcal B(Y)\).  Covering is exactly

\[
 \mathcal B(Y)\text{ meets every secant and every passant}. \tag{A}
\]

Tangents automatically avoid the star.  The live geometric gate is:

> prove that every such coherent star for \(q>5\) misses a non-tangent line.

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
At \(q=47\), ordinary polarization produces a bounded quadratic-through-octic
carrier.  At \(q=49\), characteristic seven destroys the mixed moments from
degree seven onward; use Hasse/divided-power coefficients instead.  At
\(q=53\), the common range through degree fourteen gives the rank-two
critical core for both point types.

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

## Ordered next actions

1. Build the \(q=47\) octic carrier and the separate \(q=49\)
   Hasse/divided-power carrier before attempting a certified all-type search.
2. Cover higher nonsaturated sizes separately; do not infer them from the
   \(k=12\) layer.
3. In parallel mathematical priority, seek the saturated-internal global
   dual-star nonblocking theorem.

## Stop rules

Do not:

- assume a nonsaturated arc is all-internal or its polar arrangement
  all-passant, or conversely discard the type-uniform star identities merely
  because the arrangement is mixed;
- call \(q=53\) the first open field, or infer general \(\delta\) from defect
  two without a propagation theorem;
- reopen the closed \(q=53,k=12\) layer without identifying a normalization
  or projection-completeness flaw in its exact bundle;
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
- No all-type exact search currently covers \(q=47,49\).  The \(q=53\)
  search is complete only at \(k=12\); higher sizes remain separate.

## Current assessment

- Saturated-external: closed.
- Saturated-internal: sharply constrained but open at global coherence.
- Nonsaturated, arbitrary type: the first-size point/type/window ledger is
  exact, and its character total has the all-center trace/norm law (H'); no
  first-open field or higher size is classified.
- \(q=53,k=12\): closed exactly for every point type and covariance class.
- Near-term full all-\(k\) proof odds remain below the former 20--25% estimate:
  the distinct \(q=47\), \(q=49\), higher-size, and saturated-internal gates
  remain; a counterexample remains live.

## Durable pointers

- Current audit:
  `notes/2026-08-09-c756-all-k-status-assumption-audit.md`.
- Character-weighted all-center trace/norm identity:
  `notes/2026-08-09-c756-all-center-resultant-norm.md`.
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
