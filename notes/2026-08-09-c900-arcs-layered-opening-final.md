# C900 layered-opening final gate

## Verdict

HOLD.

The opening has one actionable layered-exposition defect: **rank-three
projective realization** is not operationally glossed before it carries a
headline equality conclusion.

The phrase first appears in the abstract (lines 51--52), then in the
introductory equality corollary (lines 158--159), and again in the literature
boundary (lines 260--261).  The operational definition does not appear until
Definition `def:rank-three-realization` in the secondary equality-classification
appendix (lines 1235--1242), which the reading map explicitly permits a
first-pass reader to skip.  Moreover, the introductory corollary describes the
dual realization on the \(\binom{k}{2}\) secant-points of the star--matching
incidence design, whereas the later definition is phrased primally as an
assignment of the \(k\) vertices to a \(k\)-arc whose matching chords are
concurrent.  Their dual equivalence is recoverable by an expert, but the opening
does not state it.  Thus an adjacent combinatorics or coding reader cannot tell
from the opening what has rank three, or exactly what geometric realization is
being asserted.

### Required repair

At the first substantive use in the introductory corollary, add one operational
clause, for example: a rank-three realization means a realization by a
\(k\)-arc in \(\operatorname{PG}(2,K)\) in which the chords indexed by every
matching are concurrent.  Then say explicitly that the displayed dual
star--matching incidence realization is the dual form of that realization.
The abstract can retain the compact term once the introduction supplies this
early gloss.  Keep the full formal definition in the appendix.

## Checks that pass

- **Matching and Kneser language:** The introduction labels secants by
  \(E(K_k)\), defines Kneser adjacency as disjoint endpoint pairs, and makes the
  concurrency-clique decomposition operational before using it.  With
  \(m=\lfloor k/2\rfloor\) already fixed, “maximum matching” is adequately
  determined.
- **Matching-design language:** The abstract explains
  \(\operatorname{MATCH}(k,\lfloor k/2\rfloor,1)\) operationally by saying
  that every pair of independent edges occurs once.  The later first formal
  use supplies the simple-family and \(\lambda=1\) content.
- **Star--matching language:** The introductory corollary says that shared-edge
  endpoints produce star lines and disjoint edges produce matching lines.  Its
  later corollary expands the two line sizes and incidences.
- **Principal theorem:** The exact prescribed-hole defect theorem is
  self-contained relative to the immediately preceding definitions of
  \(r(x)\), \(m\), \(N\), \(\mathcal X_{\mathcal H}(A)\), and
  \(I_{\mathcal H}(A)\).  Its hypotheses, domain, identity, and remainder are
  explicit.
- **Conceptual versus finite claims:** The opening visibly separates ordinary
  proofs of the universal identity, rigidity, and stability from the two finite
  trust classes: kernel-checked exclusion at order 16 and trusted classifier
  executions with independently checked witnesses at orders 13, 17, and 19.
- **Navigation:** The proof map explains the causal mechanism and bottleneck.
  The final reading map instead identifies the first-pass route, safe stopping
  point, and optional secondary layers.  The two devices have distinct jobs.
- **Coding interface:** It is explicitly labeled optional and described as a
  dictionary rather than a proof input.
- **Literature boundaries:** The introduction distinguishes saturating sets,
  almost-complete conic subsets, hyperfocusedness, complete exterior sets,
  subgeometry localization, classical secant equations, and abstract matching
  designs from the paper's contribution without repeatedly restating a novelty
  defense.

No other actionable opening-layer defect was found in the requested checks.
