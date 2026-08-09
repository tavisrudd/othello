# C756 — all-\(k\) conic-filling classification

**Lane**: `clebsch`

**Status**: active open mathematics.  The saturated-exterior branch is closed and
transferred to C894.  C756 retains the saturated-internal and nonsaturated
branches.

> **KEEP THIS CARD CLEAN.**  This is a routing and current-context map, not a
> work log.  Record dated findings, validation details, failed attempts, and
> superseded plans in dated C756 reports; keep here only the current state,
> live gates, stop rules, ownership, and authoritative pointers.

## Goal

Remove the \(k\le8\) boundary from the conic-filling classification and prove,
or decisively fail to prove, the complete statement:

> For every \(k\) and every prime power \(q\), the only \(k\)-arcs in
> \(\mathrm{PG}(2,q)\) whose uncovered locus is the full point set of a
> nonsingular conic are the projective four-frame over \(\mathbb F_5\) and
> the Clebsch hexagon over \(\mathbb F_{11}\).

Quotable form: *deep-hole loci are conics exactly twice, ever.*

## Ownership and routing

- C756 is a research task, not a manuscript task.  Do not edit `papers/`
  under this ID.
- C756 owns its task card, dated C756 reports, and task-specific evidence.
- C894 owns the saturated-exterior/local-Paley companion, its publication
  safeguards, and any manuscript decision arising from that closed branch.
- Paper IV supplies reusable passant-code definitions and the weight-eight
  method, but neither owns nor blocks this theorem.
- Optional stuck-state/referee context:
  `notes/clebsch-tasks/c756-proof-expert-dossier.md`.  Do not preload it for
  routine continuation.

## Current branch map

### Saturated-external — closed and transferred

An exterior set of \((q+1)/2\) exterior conic points that is also an arc exists
only for \(q\in\{3,7,11\}\), in one conic-stabilizer orbit per field; covering
selects the \(q=11\) Clebsch hexagon.  The all-field proof is human and
independent of finite classification.  Its local-Paley engine and publication
package are routed to C894; do not reopen them here.

Authority:
`notes/2026-08-08-c756-saturated-exterior-consolidated-proof.md` and
`notes/2026-08-08-c756-consolidated-proof-cold-referee-read.md`.

### Saturated-internal — primary open branch

Put \(q=2m-1\).  A hypothetical saturated-internal example is an exterior arc
\(Y\) of size \(m+1\).  Under conic polarity its points become \(m+1\) passants
in dual-arc position, and their pairwise intersections form an internal star
configuration \(\mathcal B(Y)\).  The covering condition is exactly

\[
 Y\text{ covers every off-conic point}
 \quad\Longleftrightarrow\quad
 \mathcal B(Y)\text{ meets every secant and every passant}. \tag{A}
\]

Tangents automatically avoid \(\mathcal B(Y)\).  Thus the live geometric gate
is to prove that every such star for \(q>5\) misses a non-tangent line.

The exact line-profile identity is

\[
 \sum_{j\ge1}(j-1)(j-2)a_j
 =\frac{m(m-2)(m-3)(m-5)}4. \tag{B}
\]

It excludes \(q=7\).  The certified diagonal allocation excludes the rigid
\(q=9\) profile.  If \(r(A)\) counts internal diagonal points of a four-point
quadrangle and

\[
 T_4(Y)=\sum_{A\in\binom Y4}(3-2r(A)),
\]

full-plane incidence gives the necessary global bias

\[
 T_4(Y)\ge
 \frac{m(m-2)(m-1)(m+1)}{8(2m-1)}>0. \tag{C}
\]

Local diagonal signs alone cannot contradict (C); all diagonal types occur
and positive ambient coherent bias appears by \(q=17\).  Any contradiction
must use global compatibility.

The signed matching-frame form is the other live interface.  For the
outside-by-support block \(R\) of the switched elliptic-fusion matrix,

\[
 R\mathbf1=0,
 \qquad
 R^{\mathsf T}R=(m-2)((m+1)I-J). \tag{D}
\]

Every row is a signed chord-matching vector

\[
 R_X=\sum_{(i,j)\in M_X}\pm(e_i-e_j).
\]

Internal-point covering says exactly that every row is nonzero.  At \(m=3\)
these are the six roots of \(A_3\), explaining the four-frame endpoint.  The
unsigned star indicator also satisfies

\[
 \mathbf1_{\mathcal B}=\tfrac12A\mathbf1_Y, \tag{E}
\]

where \(A\) is internal-point/passant-line incidence.

Equivalent diagnostic interfaces remain available: equality in the binary
passant code at weight \((q+3)/2\), minimum-support signed elliptic-fusion
eigenvectors, the signed tangent-pencil equation \(Zx=\pm Ze_R\), and the
Paley crown formulation.  They are not separate open branches.

### Nonsaturated — independent open branch

The defect-zero and defect-one cases are closed.  The first unremoved
defect-two boundary is \((q,k)=(53,12)\).  The clean acceptance target is the
masked Rédei statement

\[
 h\ge1:
\]

after deleting an arc point, a conic-external set cannot determine every
direction on a spare external line.  Proving this uniformly is intended to
feed the existing defect squeeze for every \(\delta\ge2\).

The direct Segre comparison, global slope moments, unweighted subresultants,
dual-pencil weighted norm, selected missing-set kernel curves, Frobenius
fixed-locus interpolation, and the pair-coupled diagonal expansion do not give
a bounded-degree carrier.  At defect two the near-transversal must retain its
star realization: 55 internal nodes of 11 dual passants must be
direction-complete from all 16 internal nonnodes on a twelfth passant.
Arbitrary internal near-transversals exist directly, so the live structural
route is a star-specific direction theorem.

## What is already uniform

- Even \(q\) is impossible because the nucleus is never covered.
- The condition splits into hereditary chord externality and full off-conic
  covering.
- The covering LP has the correct degree cap \(\lfloor k/2\rfloor\).
- The spare-external-line dichotomy forces either
  \(\binom{k-1}{2}\ge q\), or saturation with
  \(k=(q+1)/2\) and all points external, or
  \(k=(q+3)/2\) and all points internal.
- The full classification is certified for every odd prime power \(q\le43\):
  only the \(q=5\) four-frame and \(q=11\) Clebsch hexagon occur.

## Next action

Attack the star-center gate at \((q,k)=(53,12)\): bound the number of
direction-complete internal centers on one arrangement passant for the 55
nodes of the other 11 passants.  The required configuration has all 16
internal nonnodes complete.  Any useful lemma must exploit the common-line
factorization of the star; arbitrary internal \(q+2\)-point near-transversals
realize both defect-two profiles.

## Stop rules

Do not retry these without a genuinely new bounded identity:

- normalized one-variable pencil selectors or their first two slices;
- field-by-field theta/PSD fitting or larger orbital algebras;
- raw star cardinality, parity, defect averaging, or more untyped moments;
- the unsigned two-species matching Gram or higher contractions of its
  secant/passant blocks;
- Frobenius fixed-locus interpolation or the quadratic pencil twist without
  an additional pair-parameter functional equation;
- pair-coupled diagonal inclusion--exclusion or higher concurrent-matching
  moments without a new global relation among the masks;
- arbitrary all-internal near-transversal classification, or the elementary
  pair budget over its directions, without the star realization;
- local diagonal-sign classification;
- signed \(p\)-adic/Smith torsion obstruction;
- ordinary monodromy, unsigned or pair-only resultants;
- ordinary rank, cofactor variants, row-transition interpolation, or
  unrestricted seed classification;
- direct Segre discriminants, low-degree subresultants, or naive global
  divisor interpolation for the nonsaturated branch.

## Current assessment

- Complete saturated classification: **60--70%**.
- Full all-\(k\) classification: **15--20%**, because masked Rédei
  \(h\ge1\) remains open.
- Publishable specialist partial package: **85--90%**, now owned by C894 for
  the closed saturated-exterior component.

Mathematical closure: saturated-external 100%; saturated-internal 60%;
nonsaturated 30%; full assembly 55%.

## Durable report index

Latest saturated-internal round:

- `notes/2026-08-08-c756-normalized-pencil-selector.md`;
- `notes/2026-08-08-c756-self-dual-signed-incidence.md`;
- `notes/2026-08-08-c756-covering-dual-blocking.md`;
- `notes/2026-08-09-c756-star-discriminant-profile.md`;
- `notes/2026-08-09-c756-diagonal-type-allocation.md`;
- `notes/2026-08-09-c756-diagonal-character-ustatistic.md`;
- `notes/2026-08-09-c756-projective-incidence-cap.md`;
- `notes/2026-08-09-c756-local-diagonal-sign-stop.md`;
- `notes/2026-08-09-c756-outside-matching-tight-frame.md`;
- `notes/2026-08-09-c756-two-species-matching-gram.md`;
- `notes/2026-08-09-c756-frobenius-fixed-locus-masked-remainder.md`;
- `notes/2026-08-09-c756-pair-coupled-diagonal-stop.md`;
- `notes/2026-08-09-c756-defect-two-star-near-transversal.md`;
- `notes/2026-08-09-c756-star-blocking-matching-frame-literature.md`.

Foundational branch authorities:

- `notes/2026-08-01-c756-all-k-conic-filling.md`;
- `notes/2026-08-01-c756-saturated-internal-branch.md`;
- `notes/2026-08-01-c756-nonsaturated-direction-reduction.md`;
- `notes/2026-08-01-c756-masked-rs-collision-audit.md`;
- `notes/2026-08-08-c756-passant-code-equality.md`;
- `notes/2026-08-08-c756-signed-resultant-monodromy-pivot.md`;
- `notes/2026-08-08-c756-saturated-exterior-consolidated-proof.md`;
- `notes/2026-08-08-c756-consolidated-proof-cold-referee-read.md`.

Historical method details live in the dated reports, not in this card.

## Current boundary

- Open problem statement:
  `papers/clebsch-rigidity/clebsch_rigidity.tex:1485-1489`.
- The \(k\ge8\) / \(k\ge9\) obstruction boundary:
  `papers/clebsch-hexagon-code/clebsch_hexagon_code.tex:1646-1647`.
