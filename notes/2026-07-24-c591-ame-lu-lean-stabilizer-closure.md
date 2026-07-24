# Six-party Weyl stabilizer dictionary closure

## Result

The shared Lean dictionary now covers every clause of the manuscript's
arc--MDS--CSS--AME proposition.

`RelativeConicArcs.AMELU.StabilizerDictionary` adds:

| Mathematical clause | Terminal declaration |
|---|---|
| six-party tensor Weyl amplitude formula | `RelativeConicArcs.AMELU.tensorWeylAction_apply` |
| `C × C^\perp` stabilizes the equal-phase state | `RelativeConicArcs.AMELU.tensorWeylAction_equalPhaseState_of_mem_cssLabelSpace` |
| separate `X(C)` and `Z(C^\perp)` equations | `RelativeConicArcs.AMELU.tensorWeylAction_X_equalPhaseState`, `RelativeConicArcs.AMELU.tensorWeylAction_Z_equalPhaseState` |
| CSS label space is Lagrangian | `RelativeConicArcs.AMELU.cssLabelSpace_isPauliLagrangian` |
| exact `L_C(S)` support criterion | `RelativeConicArcs.AMELU.mem_cssSupportedLabelSpace_iff_support_subset` |
| universal AME support lower bound | `RelativeConicArcs.AMELU.card_pow_three_le_computationalSupport_of_isAME` |
| exact-code states have minimum support | `RelativeConicArcs.AMELU.equalPhaseState_hasMinimalComputationalSupport` |
| AME equal-phase converse | `RelativeConicArcs.AMELU.isMDSCode634_of_isAME_equalPhaseState` |
| exact equivalence | `RelativeConicArcs.AMELU.isAME_equalPhaseState_iff_isMDSCode634` |

## Proof mechanisms

Expanding the tensor product of `W(a,b)=X(a)Z(b)` leaves one input basis
label.  Its amplitude is the input at `y-a`, multiplied by
`χ(∑ᵢ bᵢ(yᵢ-aᵢ))`.  Translation by a codeword preserves `C`; orthogonality
to `C` makes the character phase one.  This proves the full CSS stabilizer
equation for every nontrivial additive-character convention, including the
fixed trace convention.

The symplectic pairing is `a·b' - b·a'`.  Dual-code orthogonality makes
`C×C^\perp` isotropic.  The standard coordinate bilinear form is
nondegenerate, so its orthogonal complement has dimension `6-dim C`; hence
an exact dimension-three code gives a six-dimensional CSS Lagrangian.

For minimum computational support, a diagonal maximally mixed three-party
marginal forces restriction of the nonzero amplitude support onto those
three parties to be surjective.  Therefore every six-party AME state has at
least `q^3` nonzero computational-basis amplitudes.  An exact
dimension-three equal-phase code has exactly `q^3`, so it attains the
universal minimum.

For the converse, the fixed normalization and unit norm force the code to
contain exactly `q^3` words and therefore have dimension three.  The AME
diagonal marginals make every three-coordinate projection surjective; equal
cardinalities make it injective.  A nonzero word of weight at most three
would vanish on some three-coordinate set, contradicting that injectivity.
Singleton then gives minimum distance exactly four.

## Verification and trust

The source module passed warning-free guarded elaboration with Lean
`v4.32.0-rc1`.  The measured `single`-profile queue built
`RelativeConicArcs.Gates.AMELUStabilizerDictionary` in 16.34 seconds with
1,872,416 KiB peak RSS and built the axiom terminal in 3.76 seconds with
1,809,352 KiB peak RSS.  Both exact no-build probes and the final trace-only
aggregate gate passed.

`RelativeConicArcs.Gates.AMELUStabilizerDictionaryAxioms` reports exactly
`propext`, `Classical.choice`, and `Quot.sound` for all seven audited
paper-facing terminals.  There is no `sorry`, native evaluation, generated
source, external certificate, project-specific axiom, or admitted
declaration.

## Closeout and mystery ledger

The `ej` and Tao-style closeout exposed two useful simplifications and no
remaining dictionary gap:

- **Character dependence:** settled.  Stabilization uses only the additive
  character law and dual orthogonality, so the theorem is stronger than the
  trace-specific manuscript convention without changing its statement.
- **Converse hypotheses:** settled for the adopted theorem.  The proof uses
  normalization and the positive diagonal of three-party marginals; the
  off-diagonal AME equations are not needed.  Factoring that weaker
  hypothesis into a separate public API would not strengthen the manuscript
  dictionary and is not required by a queued theorem package.
- **Minimum support:** settled as an actual comparison property, not only a
  cardinality calculation: every AME state has support at least `q^3`, and
  exact-code equal-phase states attain it.
- **Formal adoption:** statement coverage is complete.  C570 owns only the
  aggregate import, theorem-name reconciliation, and manuscript axiom audit.

No genuine mathematical mystery remains in the shared stabilizer dictionary.
