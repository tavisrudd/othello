# FABLE DO NOT READ: restricted rp-next export branches

**Lane**: `rp-next`

**Date:** 2026-07-17
**Status:** GUARDED ADVISORY MATERIAL. Allocates no task and changes no gate.

Fable must not read, summarize, index, or follow links from this document. This companion isolates
cryptography- and quantum-related material formerly present in the two Fable 5 gap reviews and the
rp-next handoff.

## Independent-review item 5: code-equivalence cryptography export

C217's gauge theorem restates as: monomial equivalence of represented codes is support-matroid
isomorphism plus equality of fundamental circuit holonomies, with a linear-time comparison once
supports are aligned. C237 adds Schur-power matroid profiles as gauge-invariant fingerprints. The
corpus positions these only against McEliece square distinguishers as prior art, and never
mentions that the Linear Equivalence Problem now underlies NIST-onramp signature schemes (LESS;
matrix-code analog MEDS), where canonical forms and invariants are the entire attack surface.
Real caveat: the reduction needs accessible small circuits, so random instances resist it. But a
clean statement of the reduction (equivalence as matroid-iso plus holonomy), together with
holonomy/Schur profiles as distinguishers and preflight linters for structured instances, is a
publishable bridge into an active cryptanalytic community, and the certificate infrastructure to
demonstrate it already exists.

## Independent-review item 6: quantum translation

Stabilizer/CSS erasure decoding has precisely this structure: erased qubits, peeling decoders,
stopping sets — and, with erasure-dominant hardware (neutral atoms, erasure-converted qubits),
growing practical weight. Complete pointed ports, stopping cores, the C233 boundary-control
algebra (mapping to modular/code-surgery composition), and the capacitated service regions all
appear to transplant; "quantum" appears in the corpus once, in a nonclaims list. Higher risk than
items 1--5 — the symplectic CSS structure may break the clean matroid picture — but the payoff
class is large and the audience is the hottest in coding theory.

## Deep-dive item 5: code-equivalence cryptography export

### Sharpened statement

Two deliverables, cleanly separated:

1. **Reduction theorem:** monomial (linear) equivalence of represented codes, given circuit data,
   is support-matroid isomorphism plus equality of fundamental circuit holonomies (C217's gauge
   theorem, restated as a torsor decomposition of the Linear Equivalence Problem: combinatorial
   layer = matroid iso, algebraic layer = holonomy comparison, the latter linear-time once supports
   align).
2. **Invariant toolkit:** holonomy fingerprints and Schur-power matroid profiles (C237) as
   gauge-invariant distinguishers for *structured* instances.

### One level down

- Honest feasibility line: computing holonomies needs accessible small circuits. LEP-based
  signatures (LESS) use random codes, where finding low-weight codewords is itself hard, so no
  direct attack on the standard instances follows. The value concentrates in three places:
  structured/compressed variants proposed for smaller keys; the conceptual decomposition of LEP
  hardness (which layer is hard for random codes?); and non-adversarial tooling.
- Generalization the corpus misses: the C217 argument is generic multiplicative cohomology of a
  bipartite incidence graph under two scaling groups. **Matrix-code equivalence (MEDS setting) has
  row and column scaling groups and admits the same spanning-tree gauge normalization**, giving
  canonical forms and invariants there too — a second cryptosystem family for one theorem.
- Mandatory audit before any writing: the recent canonical-form line inside the LESS literature
  (information-set-based canonical forms used to shrink signatures). The holonomy view may be
  equivalent, cleaner, or subsumed; the audit decides the claim's shape.

### First probe

The audit above, plus one script: holonomy + Schur-profile fingerprints computed for pairs of
equivalent/inequivalent structured codes (GRS, LRC, the committed q=9 pair), demonstrating the
linter behavior end-to-end on existing certificates.

### Second-order wins if landed

1. **Canonical hashing of codes up to equivalence** (when circuits are accessible): deduplication
   for code tables and best-known-code databases — a service the coding community would actually
   use, and a crypto-grade application for C238's RepresentationID capsule.
2. A foundations contribution to LEP-based signatures: locating the hardness layer, valuable to
   that community whether or not any attack materializes.
3. Systematizing Schur-power stability could yield new distinguishers for structured McEliece
   variants — cryptanalysis papers adjacent to the C237 machinery.

### Risk / kill

If the audit shows the canonical-form literature already covers the reduction in equivalent
generality, downgrade to the toolkit/linter deliverable and cite; the MEDS generalization may
still be new.

## Deep-dive item 6: quantum/CSS translation

### Sharpened statement

Port the sequential-closure machinery to stabilizer erasure decoding. The crisp candidate
contribution: **complete-port peeling for qLDPC erasure decoding** — peel using *all* bounded
stabilizer-group elements through a qubit, not a fixed generator set.

### One level down

- Standard quantum erasure peeling (Delfosse--Zemor style, union-find) fires a check with exactly
  one erased qubit; its failure states depend on the chosen generator set. Berczi--Boros--Makino's
  observation that one-step Horn behavior is CNF-dependent is exactly this phenomenon. The
  complete bounded port (all group elements of weight at most `r+1` through the target) gives a
  canonical, generator-independent closure that strictly dominates fixed-check peeling at equal
  locality; the stopping-core theory then *quantifies* the gap between decoders — a measurable,
  publishable delta on hypergraph-product codes.
- The composition layer has a natural target: hypergraph-product and lifted-product codes have
  tensor/module structure; whether a C233-style boundary algebra composes across product or
  surgery interfaces is the analog of the 2-sum question, and lattice surgery is literally a
  boundary-interface operation.
- C235's capacitated regions map to measurement-capacity scheduling in erasure-dominant hardware
  (neutral atoms, erasure-converted qubits), where repair rounds and helper capacities are physical
  constraints.

### First probe

Focused audit (Delfosse--Zemor, union-find, qLDPC erasure literature) to fix the exact SOTA
boundary, then one experiment: on small hypergraph-product codes, compare recoverable-erasure
fractions of fixed-generator peeling versus complete-port sequential closure at equal radius. The
gap number decides everything.

### Second-order wins if landed

1. Entry into the highest-visibility audience in coding theory with a decoder-level, measurable
   claim rather than a framework claim.
2. Stabilizer signs form a gauge 1-cochain; the C217 holonomy machinery may say something about
   equivalence of stabilizer groups under local phase gauges — speculative, but it would be a
   second, deeper quantum export.
3. Even a clean negative (symplectic structure breaks the matroid picture, or the gap is negligible
   on good qLDPC families) sharpens the classical theory's boundary and is worth a note.

### Risk / kill

Union-find decoders already compute closures efficiently for topological codes; the win must come
from *non-topological* qLDPC families and from the generator-independence point. Kill if the
measured gap on product codes is negligible.

## Portfolio interactions and ranking

- Item 1 plus item 6: peeling-optimality classification restated for stabilizer codes.
- Item 5 plus C238: the RepresentationID capsule becomes a crypto-grade canonical-hash tool.
- Both items are export bets gated on their audits.

## Deferred follow-up items removed from the rp-next handoff

- **Complete-port quantum peeling:** first audit generator-independent erasure decoding, then
  compare fixed-generator and complete bounded-port closure on small non-topological product-code
  instances. Promote only for a material recoverability gap at matched locality.
- **Code-equivalence/canonicalization export:** requires a separate prior-art audit and explicit
  user promotion.

## Historical restricted results removed from the rp-next handoff

### C228 — operational meaning of coefficient holonomy

Under the checked ideal-LSSS dealer convention, both C217 `U(2,4)` representations are ordinary
multiplicative and neither is strongly multiplicative, for all dealer choices. The criterion
factors through the quadratic Veronese matroid, which is uniformly `U(3,4)` and hence cannot see the
two cross-ratio holonomy classes. Gauge covariance is explicit; the `2-of-3` port is `Q^2` but not
`Q^3`. This is the planned decisive negative, and the bounded search stops. Source:
`2026-07-16-c228-holonomy-lsss-mpc.md`.

### C237 — `U(3,8)` holonomy-sensitive MPC probe

Over `GF(101)`, an explicit `[8,3]` GRS representation and an explicit generic representation have
common support matroid `U(3,8)` but square matroids `U(5,8)` and `U(6,8)`. For every dealer the GRS
ideal LSSS is strongly multiplicative, while the generic one fails after every two-participant
adversary deletion. The standalone certificate exhausts all dealer/adversary pairs and replays the
gauge action. Source: `2026-07-16-c237-u38-holonomy-mpc.md`.
