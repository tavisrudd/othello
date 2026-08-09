# C756 — all-\(k\) conic-filling classification

**Lane:** `clebsch`

**Status:** active open mathematics.  The saturated-external branch is closed
and transferred to C894.  C756 retains the saturated-internal branch and the
full nonsaturated branch.  The latter is not reduced to one conic point type.

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

The nonsaturated \(q=53\) star/covariance route assumes the primal arc is
all-internal.  Under polarity that gives an all-passant dual arrangement with
internal nodes.  No current theorem excludes external or mixed-type primal
arcs in the nonsaturated branch.  Therefore:

- the all-passant moment, separator, covariance, torus, and aligned results
  are conditional subbranch results;
- closing their remaining covariance rows would not close \(q=53\);
- \(q=47\) and \(q=49\), with defects eight and six at \(k=12\), precede the
  defect-two \(q=53\) case and remain unclassified.

Authority and full audit:
`notes/2026-08-09-c756-all-k-status-assumption-audit.md`.

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

### Nonsaturated — open before point-type specialization

For a deleted arc point \(P\), a spare external line gives

\[
 D_P(T)=(T^q-T)E_P(T),\qquad
 \deg E_P=\delta:=\binom{k-1}{2}-q. \tag{E}
\]

The clean uniform target remains a masked Rédei theorem forcing a missing
direction for every \(\delta\ge2\).  No such carrier is proved.

The immediate gate is point-type stratification.  For \(q=47,49,53\), record:

1. whether the deleted point is internal or external;
2. the number and placement of external points in the remaining arc;
3. the secant/passant types of the polar lines and the types of their nodes;
4. the spare-center count and direction masks;
5. which moment, separator, and covariance identities survive.

There is already one exact aggregate handle.  If \(e\) of the \(k\) arc
points are external, then the number of ordered deleted-point/spare-passant
pairs, each carrying a degree-\(\delta\) quotient (E), is

\[
 k\left(\frac{q+1}{2}-(k-1)\right)-e. \tag{F}
\]

At \(k=12\), an external versus internal deleted point supplies respectively
\(12/13\), \(13/14\), and \(15/16\) spare-line quotients for
\(q=47,49,53\).  Aggregate these equations over all \((P,\ell)\) before
normalizing one center.

Acceptance is either a proof that nonsaturation forces the all-internal model,
or a complete mixed-type equation/search ledger.  A bounded counterexample
search over the surviving type profiles is the next safeguard.

### Conditional subbranch: \(q=53\), all-internal/all-passant

Only in this subbranch, 55 internal nodes of 11 dual passants must be
direction-complete from all 16 internal nonnodes on a twelfth passant.  The
sixteen-center condition forces \(e_3,\ldots,e_{15}=0\); degree-nine node
separators exclude covariance ranks zero and one; nonsingular covariance
gives the rank-two critical system \(\nabla\mathcal Z=0\) with nonzero
off-diagonal separator Hessian.

Elliptic overlap leaves:

- aligned anisotropic covariance;
- nonaligned anisotropic traces \(-10,-14\);
- seven split-covariance trace/zero rows.

The aligned family is closed exactly.  Split offset descent has no admissible
eleven-state internal-node clique.  Trace-zero descent has exactly 44
direction-zero-normalized candidates in four dihedral orbits; all have open
separator Hessian and fail all eleven critical equations after the Laurent
center shift is recovered from the star centroid.

Authority:
`notes/2026-08-09-c756-aligned-critical-closure.md` and its committed exact
script/certificate bundle.

The nonaligned and split rows remain valid conditional work, but they are not
the main C756 frontier until the point-type gate is closed.

## Ordered next actions

1. Build the nonsaturated point-type ledger at \(q=47,49,53\), beginning
   with the deleted point type and mixed polar-line arrangement.
2. Derive the surviving direction, moment, separator, and covariance
   identities separately for each type profile.
3. Run a bounded all-type counterexample audit on the first open fields if the
   ledger makes a certified search feasible.
4. Resume the \(q=53\) nonaligned/split Gram-character collision only with its
   conditional scope explicit.
5. In parallel mathematical priority, seek the saturated-internal global
   dual-star nonblocking theorem.

## Stop rules

Do not:

- assume a nonsaturated arc is all-internal or its polar arrangement
  all-passant;
- call \(q=53\) the first open field, or infer general \(\delta\) from defect
  two without a propagation theorem;
- count progress in the conditional all-passant route as closure of the full
  nonsaturated branch;
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
- The \(q=53\) aligned certificate has independent formula-level invariant
  checks, not a second independent exhaustive search implementation.
- No all-type exact search currently covers \(q=47,49,53\).

## Current assessment

- Saturated-external: closed.
- Saturated-internal: sharply constrained but open at global coherence.
- Nonsaturated, arbitrary type: early; the previous 40% estimate counted a
  conditional all-internal specialization and is withdrawn.
- \(q=53\), all-internal, aligned: closed exactly.
- Near-term full all-\(k\) proof odds: below the former 20--25% estimate until
  the point-type audit is complete; a counterexample remains live.

## Durable pointers

- Current audit:
  `notes/2026-08-09-c756-all-k-status-assumption-audit.md`.
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
