# C84 facet: certificate-density viability gate

**Lane**: `cap`

**Status:** current plan; no new census or classifier before this gate is met.

The method is deliberately not fixed. Spectral, orbital, character-sum, or algebraic-geometric
counting may be used later, but only after a deterministic P-certificate family exists.

## Required theorem schema

Supply an event or certificate relation `E_q(y,w)` for the actual correlated fourth-centre family
with all four properties:

1. **Deterministic game implication:** prove from Node--Kayles semantics, without a value oracle,
   `E_q(y,w) → 𝒢(R_y)=0`.
2. **Controlled certificate complexity:** w must have a q-uniform bounded description or a proved
   compact recursive rule. It may not be an arbitrary winning strategy tree, lookup table, or
   replay of exact values; otherwise `∃w,E_q(y,w)` merely renames P.
3. **Full-dimensional raw-centre supply:** prove the projection `{y:∃w,E_q(y,w)}` has positive
   density in the raw legal-centre set `Y_D(q)`, not merely in an orbit quotient or in the pair
   space `(y,w)`.
4. **Exact counting input:** state the theorem that gives a q-uniform lower bound for that
   projection in the actual y-parameter family for all sufficiently large relevant q, including
   explicit field/characteristic exceptions and a separate finite-exception plan.

Transfer to `(ON)` is a later, separate obligation.

## Red-team failure modes

A candidate fails the gate if any of the following remains unresolved:

- **Tautological witness:** w contains an unrestricted strategy tree, Grundy value, winning-reply
  oracle, or q-dependent table.
- **Projection inflation:** many witnesses lie over few y-values; counting `(y,w)` does not bound
  the number of certified centres without a fiber bound.
- **Dimension without rational points:** a dimension-two closure lacks a geometrically relevant
  component over the base field or has no uniform rational-point lower bound.
- **Orbit-weight distortion:** an S4 quotient count is converted to raw-centre density without
  stabilizer and exceptional-orbit control.
- **Surrogate distribution:** the proof counts independent/random matchings rather than the
  correlated involution/dead-vertex family arising from y.
- **Spectral non sequitur:** expansion or eigenvalue control is asserted to imply Grundy zero
  without the deterministic certificate theorem.
- **Hidden old attack:** the proposal is pairing, a fixed word, a one-ply packet, a bounded feature
  table, or ledger transport under new terminology.
- **Nonuniformity:** certificate complexity, defining degrees, constants, or exception sets grow
  with q in a way that destroys a q-uniform positive density.

## Rejected substitutes

The gate is not met by:

- defining `E` with Grundy zero, conic xor zero, or a winning-reply count;
- a spectral statistic or empirical P-correlation without a strategy theorem;
- pairing, fixed homographies, or another dimension-one certificate;
- Fricke coordinates that merely rename conjugacy orbits;
- another one-ply feature, word, packet, bounded quotient, or finite template;
- the residual-grid ledger or greedy conic drain; or
- another q census before a certificate event is stated.

## Next deliverable

Write a short C84 certificate-event dossier containing at most three candidates. For each candidate:

1. state the witness and deterministic response/decomposition proof skeleton;
2. bound the description complexity of w and the witness multiplicity over y;
3. identify the raw y-locus, its relevant component, and its expected dimension;
4. name the precise counting theorem and required uniformity hypotheses;
5. explain why no closed-attack obstruction applies; and
6. define the fastest symbolic or existing-data falsification check.

Use q=13--29 artifacts only after the schema is written, and only for bounded falsification. Do not
fit a new classifier to those values.

## Decision rule

**Pass:** at least one candidate has a non-tautological deterministic implication, controlled
certificate complexity, and a credible raw-centre positive-density argument.

**Fail:** if none survives, mark C84 conceptually gated and deprioritize it. This null outcome is
acceptable and should be reported directly; do not substitute more counting terminology or
computation for the missing certificate.

## Scope of the gate

This is a portfolio decision rule, not a theorem that every possible abundance proof must admit a
bounded pointwise certificate. A genuinely different global recursion, averaging identity, or
distribution theorem for Node--Kayles values is not logically excluded. Re-entry through such a
route must state its theorem schema and explain how it proves P-density without assuming or
replaying exact values. Likewise, the three-candidate limit controls search breadth; failure of
three candidates is evidence to deprioritize C84, not a mathematical impossibility result.

The exact family is summarized in [Schreier abundance](schreier-abundance.md); closed mechanisms
are indexed in [closed attacks](closed-attacks.md). Before naming a counting theorem, apply the
model-separation rules in [the literature boundary](literature-boundary.md).
