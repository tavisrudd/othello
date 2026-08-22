# Referee and cold-read dossier: Bounded Recovery Structures of Linear Codes

This is the internal context packet for independent criticism of *Bounded
Recovery Structures of Linear Codes: Transfer, Reliability, and Geometry*. It
defines the review questions and evidence boundary; it is not a review report
and must not be exported with the paper.

Predicted objections are editorial inferences from the subject literature, not
quotations or claims about any named scholar.

## Manuscript identity

- Driver: `complete_repair_ports.tex`.
- Main sections: `sections/01-complete-ports.tex` through
  `sections/06-geometric-flagships.tex`.
- Mathematical conclusion: `sections/08-conclusion.tex`.
- Formal-verification and finite-evidence appendix:
  `sections/07-verification-provenance.tex`.
- Public reader entry point: `README.md`.
- Private claim/control records: `theorem-map.md`, `proof_ledger.md`,
  `claim-proof-novelty-ledger.md`, `formalization-ledger.md`,
  `formal-statement-adequacy.md`, and `verification-map.md`.

The PDF under review must be rebuilt from the same source commit. Reviewers
should record the commit and PDF SHA-256 before reading.

## Result spine the reviewer must be able to recover

1. A bounded recovery structure has support, normalized coefficient, and
   probability layers.
2. For an `[n,k]` MDS code with `1 <= k < n`, the radius-`k` normalized
   equations at one target span the whole dual, have reconstruction radius `k`, and
   projects to the generic complete `k`-uniform support clutter.
3. Concatenation has an exact pointed nonembedded-witness threshold obtained
   from zero-functional and nonzero-functional costs; below it, support and
   normalized recovery equations transfer exactly.
4. A fixed represented recovery structure satisfying the persistent pointed obstruction
   bound occurs on a designated target class of density `1/m` in an
   asymptotically good fixed-alphabet family.
5. Repair reliability obeys deletion–contraction and pivotal identities;
   radius-truncated erasure failure gives a bounded-EXIT/cheapest-radius
   hierarchy.
6. Full-radius reliability is a Las Vergnas perspective-polynomial
   specialization, while an explicit represented pair shows that this
   unfiltered invariant does not determine the radius filtration.
7. Cubic–axis and quartic–nucleus systems are applications. The latter has a
   harmonic `S(3,4,q+1)` radius-four recovery structure with parallel nucleus repairs and a
   compulsory nucleus helper at every curve target.

## Claims the paper does not make

- It does not claim that every abstract repair hypergraph is representable.
- It does not optimize subsymbol access, helper bandwidth, or service regions.
- A finite radius is a bounded-query decoder, not full symbol-MAP decoding.
- It states no capacity or EXIT-area theorem for a radius cutoff.
- It states no random harmonic-cascade threshold or propagation-completeness
  theorem.
- A bounded none-found literature search is not a priority certificate.
- Exact finite tables and replay outputs illustrate or corroborate results;
  they do not prove a main-body theorem.

## Review panel

Use separate readers so that no one report is asked to cover every interface.
The names below identify standards of expertise, not simulated personal views.

### Coding theory and distributed storage

Use the Ravagnani/Yaakobi/Tamo/Oggier standard. Ask:

- Does the normalized recovery equations retain information genuinely absent from the
  support clutter, or is the reconstruction claim a reformulation of a known
  generalized-weight invariant?
- Is the helper-download model stated before any operational conclusion?
- Does exact coefficient equality transport a concrete decoder, with every
  scalar and normalization accounted for?
- Are locality, availability, bandwidth, access, MAP decoding, and capacity
  kept distinct?
- Is the pointed obstruction `z_x(I)` necessary and sufficient only in the
  stated eventual-confinement setting?

### Matroid and Tutte theory

Use the Britz/Las Vergnas standard. Ask:

- Are deletion, contraction, perspective direction, rank jumps, and variable
  substitutions consistent throughout?
- Is the full-radius specialization proved term by term rather than inferred
  from analogy?
- Does the filtration counterexample really have the same unfiltered pointed
  polynomial and different radius-three reliability curves?
- Does the prose credit the polynomial framework as classical while isolating
  the paper-specific filtration boundary?

### Finite geometry and MDS codes

Use the Lavrauw/Ball/Bartoli standard. Ask:

- Does the common-core MDS basis proof handle every target and every permitted
  parameter edge case?
- Are the twisted-cubic axis and quartic nucleus defined by the displayed
  projective columns, with characteristic and field-size hypotheses visible?
- Does the quartic proof handle infinity, the zero-sum branch, circuit
  minimality, and the sharp hyperplane-section bound without finite census?
- Are harmonic blocks reconciled with the cited projective orbit convention?
- Are the geometries clearly examples of the general theory rather than the
  source of its definitions?

### Probability and reliability

Use the O'Donnell/Janson standard. Ask:

- Is the survival-versus-erasure sign convention fixed once and respected by
  deletion–contraction and differentiation?
- Are pivotal influence, Russo–Margulis, blocker order, and the cheapest-radius
  transform exact finite identities under the stated product law?
- Are correlated laws mentioned only where the proof actually transports
  them?
- Have Poisson language and exact finite profiles been kept out of the main
  theorem chain?

### Formal verification and reproducibility

Use a mathlib-maintainer and computational-mathematics standard. Ask:

- For every paper-facing statement, do the printed domain, hypotheses, and
  conclusion match the named Lean declaration field by field?
- Does the axiom report contain only the documented logical axioms, with every
  mathematical input represented as a theorem hypothesis or manuscript
  citation?
- Are generated certificates, native evaluation, and private replay scripts
  absent from main-theorem dependency closures?
- Does the appendix distinguish kernel checking, classical imports,
  certificate checking, and trusted execution?
- Can the standalone export rebuild without private paths or monorepo state?

### Adjacent-field reader and copy critic

Use a mathematically mature reader who is not a coding theorist. Ask:

- By the end of page 2, can the reader state the object, principal theorem,
  and common-core mechanism?
- Does every change of language—dual words to recovery sets, recovery sets to Boolean
  reliability, codes to matroids, coordinates to projective geometry—receive
  one precise bridge?
- Can the reader skip the geometric applications and verification appendix
  without losing the general theorem chain?
- Are section openings informative, paragraphs single-purpose, notation
  stable, and theorem hypotheses recoverable without searching backward?
- Does the conclusion end mathematically rather than as a verification log?

## Cold-read protocol

Each reader receives only the rebuilt PDF and the relevant lens above. Do not
send private task reports, earlier referee findings, or proposed fixes. A
second-round reader must not see the first-round report.

Every report must contain:

1. a verdict: `GO`, `MINOR`, `MAJOR`, or `BLOCK`;
2. the strongest passage or proof mechanism;
3. the first point at which confidence dropped;
4. every required finding, with page and stable semantic label where possible;
5. a separation of mathematical error, missing proof, scope/novelty problem,
   formal-correspondence problem, reproducibility problem, and exposition;
6. one attempt to falsify the main theorem or its operational interpretation;
7. a statement of which sections were safely skippable and which were not.

A `GO` report must answer all questions in its assigned lens, not merely state
that the manuscript reads well. A `BLOCK` must identify the exact claim that
cannot be accepted and the evidence needed to reopen it.

## Final synthesis gate

The draft is ready for the later release decision only if:

- the coding/storage reader accepts the operational model and coefficient-layer
  significance;
- the matroid reader accepts the perspective specialization and filtration
  separation;
- the finite geometer accepts both characteristic-three applications without
  computational dependence;
- the formal reader confirms statement adequacy and a clean trust boundary;
- the adjacent reader finds the main theorem and mechanism by page 2;
- all required findings are resolved in source and the PDF is rebuilt; and
- a fresh second round receives no inherited findings and returns no blocker.

Public repository creation, DOI deposition, tagging, and pushing remain
separate author actions and are not authorized by a successful cold read.
