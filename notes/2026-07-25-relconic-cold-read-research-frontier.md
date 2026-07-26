# Relative-conic cold-read research frontier

**Lane:** `relconic`

**Date:** 2026-07-25

## Source and scope

Two independent cold readers read the complete current manuscript without
receiving prior reviews, intended answers, handoff history, or one another's
reports.  Each answered:

1. What questions does the paper beg?
2. What does it imply that one would next check or try to prove?
3. What strong mathematical connections does it miss or leave implicit?

This note records the consensus, separates cheap consequences from research
programs, and supplies stable entry points for the allocated successors.  An
item's presence here does not assert novelty or correctness beyond the theorem
statements already in the manuscript.

## Consensus

The readers independently identified the same central frontier.  The exact
defect does more than bound coverage: it turns equality into a rank-three
star--matching realization and small defect into an edge/vertex removal
statement for the bad-concurrence graph.  The next layer must therefore mix
matching compatibility with projective realizability.  Raw incidence moments
alone are already known to stop short.

The strongest underdeveloped connections were:

- rank-three matroid realization spaces, bracket algebra, characteristic sets,
  and universal partial fields;
- Johnson/Kneser association schemes, clique geometries, and design completion;
- completely regular or uniformly packed codes and Delsarte constraints on
  syndrome representation numbers;
- Hilbert functions, Veronese spans, separators, and finite-field
  Cayley--Bacharach phenomena;
- conic polarity and orthogonal association schemes; and
- six-point projective geometry as the first rank-three-sensitive layer behind
  a third secant moment.

The broad asymptotic question remains whether
\(\rho_{\mathcal C}(q)=\Theta(\sqrt q)\).  That is already the lane's governing
problem and is not duplicated as a new task below.

## Allocated research programs in expected-value order

### C625 — rank-three star--matching obstruction

Classify or obstruct rank-three realizations of the star--matching
pairwise-balanced design, with the surviving \((q,k)=(4096,92)\) equality
candidate as the first target.  Use matroid/bracket realization, conic polarity,
or a genuinely new global invariant.  Do not repeat the closed resolution,
binary-residue, tangent-spectrum, or quadratic/Arf gates from C556, C593, and
C596, and do not replace a structural argument by a broad finite census.

Entry report:
`notes/2026-07-25-c625-rank-three-star-matching-obstruction.md`.

### C626 — rank-three-sensitive third layer

Seek an inequality or invariant that detects projective compatibility among
concurrent triples of disjoint secants.  The raw statistic
\(\sum_x\binom{r(x)}3\) and its six-subset Gale transfer are already subordinate
to the defect by C555 and C592.  A successful result must retain bracket,
Brianchon, polarity, carrier, or square-restriction information that those
aggregates discard.  The handoff's unallocated square-restriction degeneracy
locus \(F_A|_{x^*}\in K[x_0,x_1]^2\) is an admissible first gate.

Entry report:
`notes/2026-07-25-c626-rank-three-sensitive-third-layer.md`.

### C627 — bad-concurrence removal and design completion

Starting from the checked edge and vertex-cover bounds, determine whether a
small-defect clique geometry can be completed or edited to a genuine
\(\operatorname{MATCH}(k,\lfloor k/2\rfloor,1)\) design or rank-three
realization.  The target output is a quantitative defect gap derived from
nonrealizability, or a precise falsifier showing why abstract removal/design
completion cannot preserve the geometric incidence data.  Do not reprove the
existing secant-deletion theorem.

Entry report:
`notes/2026-07-25-c627-bad-concurrence-design-completion.md`.

### C628 — uniform quadratic-hull obstruction

Recast the evaluation obstruction through Hilbert functions, Veronese spans,
and separators, then determine whether the \(q=16\) quadratic-avoidance theorem
extends structurally to other orders or degrees.  The unresolved
\(q=13,17,19\) lower-bound cases are bounded pilots, not a license for an
unstructured census.  Any paper-facing finite computation must satisfy the
repository reproducibility convention.

Entry report:
`notes/2026-07-25-c628-uniform-quadratic-hull-obstruction.md`.

## Cheap consequences retained in the current thread

The following are to be checked before deciding whether they belong in the
manuscript:

1. the discrete gap
   \(m\Delta_{\mathcal H}(A)=0\) or
   \(m\Delta_{\mathcal H}(A)\ge m-2\) for \(m\ge3\);
2. the exact even-\(k\) zero-defect spectrum for the line-hole/complete-affine
   specialization;
3. the odd-\(k\) conic equality formula and its first arithmetic sieve;
4. the equivalence between the hyperoval-scale equality branch and existence
   of a disjoint nonsingular conic;
5. the proposed forced tangent/bisecant/external secant split at
   \((q,k)=(4096,92)\); and
6. the exact parity-sensitive expansion of the integer threshold \(L_2(q)\),
   retained only if it improves the paper rather than adding algebraic bulk.

The open finite cases \(q=13,17,19\) move to C628 unless a cheap theorem settles
them without a classification computation.

## Manuscript decision gate

An item earns space in Version 1 only if it does at least one of the following:

- strengthens a displayed theorem at negligible proof cost;
- closes a visible logical branch, especially the affine, odd-\(k\), hyperoval,
  or \((4096,92)\) branch;
- materially clarifies the mechanism behind defect stability; or
- changes the reader's view of the main theorem without enlarging the trust
  surface.

Any addition must identify what it displaces.  Likely displacement candidates
are repeated prose summaries of the defect mechanism, secondary exact-value
commentary, or coarse asymptotic algebra superseded by a sharper compact
statement.  The main identity, matching-design theorem, ten-point realization
classification, \(q=16\) theorem, verification boundary, and reconstruction
theorem are not displacement candidates.

## Administrative note

The first allocator call returned C621--C624 because the live queue already
contained foreign-lane rows with those numbers that had not been recorded in
the allocation ledger.  Those foreign rows were left untouched.  The relconic
successors use the fresh replacement block C625--C628.  Resolving the preexisting
C621--C624 queue/ledger inconsistency belongs to the queue coordinator and must
not be handled by silently re-pegging either lane.
