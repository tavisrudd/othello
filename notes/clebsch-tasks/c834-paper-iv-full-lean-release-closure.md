# C834 — Paper IV full Lean release closure

**Lane:** `clebsch`

**Status:** active; required dependency of C761 by author direction 2026-08-02

## Current state

The incidence/dimension packet is partially closed.  The normalized 183-point coordinate model,
the 78 internal and 78 passant coordinate enumerations and their indexing equivalences, the
independent bit-row rank calculation, and the recovery/expansion masks transporting rank 42 to the
semantic incidence map now use kernel reduction.  The four-anchor signature injectivity leaf is
also kernel checked.  Focused guarded elaboration and the semantic rank-transport target are green.

The reusable weight-ten reachability kernel is also in place.  It checks generated transition
layers, proves coverage for every member of the complete Cartesian choice domain, supports compact
selected-row projections through a proved XOR homomorphism, and derives target exclusion from a
checked terminal list.  This infrastructure is kernel checked, but no native weight-ten leaf has
yet been removed.

Direct kernel reduction is not an admissible replacement for the larger finite leaves: even one
semantic unary-degree point and one raw isolated weight-ten shard exceed the measured memory gate.
The next implementation packet is the seven isolated-profile generated layer certificates on this
checker, followed by a compact projected-state cover for the cycle profile.  No native leaf may be
removed until its generated certificate is connected to the complete Cartesian domain.  Unary
constancy will use the manuscript's orbit-transitivity and double-count mechanism rather than
semantic support filtering.

## Objective

Replace Paper IV's partial formal mirror by a theorem-complete public Lean
development before release.  The terminal theorem must cover the complete
published result: parameters \([78,36,12]_2\), all 364 minimum words and their
four intrinsic families, spanning by every family, exact weighted-pair
reconstruction, the full marked \(\operatorname{PG}(2,13)\), and the
automorphism group.

## Meaning of “full Lean”

For release purposes, the formal package is complete when every manuscript
clause has an exact entry in the series-standard statement, trust, and formal
coverage ledgers, and every claim described as Lean-proved names an elaborated
declaration with its actual axioms.  Release-facing Lean terminals have no
declaration-local native-evaluation axiom or trusted Python premise.  Ordinary
foundational axioms reported by Mathlib—such as choice, propositional
extensionality, and quotient soundness—are permitted and must be listed.

Short structural human proofs and exact classical inputs remain legitimate
proof modes under the series trust standard.  They must be complete in the
manuscript or pinned to precise literature, and the aggregate must not advertise
their clauses as kernel checked.  Python programs may remain independent
cross-checks but carry no logical weight.

Proof-producing reflection, kernel reduction, generated proof terms, and
proved reusable finite certificates are permitted.  `native_decide` is not a
release proof endpoint.

## Required closure packets

1. **Incidence and dimension:** kernel-check the normalized conic, polarity,
   incidence matrix, rank 42, and code dimension 36.
2. **Distance:** internalize the weight-eight tangent/theta argument, including
   PSD and the equality/kernel calculation, and the weight-ten moment plus all
   stabilizer exclusions; derive minimum distance 12 without a trusted search.
3. **Minimum layer:** prove the complete 364-word exhaustion, identify one
   octahedral and three toric families intrinsically, compute stabilizers and
   prove every family spans.
4. **Pair recovery:** prove the exact pair table, the fused-color splitter,
   color-eight recovery of every polar row, parity-image equality with the
   code, unary constancy, and exact arity two.
5. **Symmetry and plane:** formalize the compact anchor and coordinate-algebra
   mechanisms; retain sharp three-transitivity, the Sylow/involution
   construction, and the classical adjoint/polarity dictionary as exact
   human/classical trust rows when formalizing their general group theory would
   create a disproportionate dependency tree.
6. **Hidden field:** construct the operator field, prove its identification
   with \(\mathbf F_8\), the equivalence \(K\simeq\mathbf F_8^{12}\), the three
   scalar actions, and the Gram/spanning consequences.
7. **Release aggregate:** expose one theorem matching the manuscript's main
   theorem, run a complete `#print axioms` audit, generate a theorem-to-source
   map, and make the public release gate reject native/trusted placeholders.

## Engineering constraints

- Reuse the shared semantic geometry; do not create a second coordinate model.
- Match the other numbered papers' release machinery: tracked statement
  identity, claim-by-claim trust manifest, formal theorem map, frozen axiom
  transcript, generated-artifact provenance, public release allowlist,
  aggregate import gate, and a single release verifier.  Paper IV may strengthen
  those standards, but it may not use a weaker or bespoke ledger.
- Shard expensive proof-producing computations and keep generated artifacts
  deterministic, reviewable, and hash-addressed.
- Each packet must have a cheap focused build before entering the aggregate.
- Keep statement identities synchronized with the manuscript; if a statement
  cannot be formalized as written, repair the proof or report the precise
  mathematical blocker rather than weakening it silently.

## Acceptance

- A clean public checkout builds the full aggregate under the pinned toolchain.
- The statement-identity, trust-manifest, formal-map, axiom-transcript,
  provenance, allowlist, and release-verifier surfaces use the same schema
  discipline and cross-checks as the rest of the series.
- The release correspondence covers every clause of the manuscript main
  theorem and distinguishes kernel, certificate, classical, and human proof
  modes exactly.
- Its axiom closure contains no native-evaluation or project-local axiom and no
  trusted-execution premise.
- Every former native or Python theorem boundary is replaced by a Lean proof,
  a proof-producing Lean certificate, or an explicitly nonformal independent
  replay.  Human and classical boundaries are retained only where the
  architecture report justifies them and the trust ledger states them exactly.
- Independent Python replay, source hygiene, warning-free PDF, isolated build,
  and immutable-artifact checks pass.
- Only after C834 is complete may C761 request publication authority.

## Stop boundary

C834 does not add new mathematical claims, pursue all-\(q\) generalizations,
or publish externally.  Its sole purpose is proof-complete formalization of the
frozen Paper IV theorem.
