# C967 -- jet-quotient quantum-code compiler

**Lane:** quantum-codes

**Status:** queued; standalone compiler and research gate; no manuscript edits

## Placement

No existing paper owns this task. The nearest manuscript is *Diagonal
Isoduality and Transversal Clifford Groups of MDS--CSS Codes* (AME Paper II),
because it studies logical transversal groups of finite-field CSS codes. The
jet-quotient family is nevertheless neither AME nor the MDS--CSS family treated
there. C967 therefore owns a standalone quantum-code compiler/tool and may only
recommend a later publication surface after its mathematics and novelty gates.

The Clebsch Schur--Sarkisov calculations are a read-only source of the conic
evaluation, jet, residue, and Schur-product identities. Existing Clebsch and AME
manuscripts and formal companions remain out of scope.

## Frozen source surface to verify

For odd prime powers `q >= 7`, the proposed asymmetric CSS family has check
spaces `C_Gamma(q)` and `R_(q-7)(q)` and parameters

```text
[[q+1, 2, (q-5, 4)]]_q.
```

At `q=11`, freeze and independently reconstruct the more detailed packet:

- `E = R_2 = [12,3,10]_11`, `E^star2 = R_4`, and `E^star3 = R_6`;
- `R_4^perp = R_6` and `R_5` is self-dual;
- `C_Gamma = [12,5,6]_11` is the kernel of the two-jet map
  `R_6 -> J^(2)_(0,infinity)`;
- X and Z checks are `C_Gamma` and `R_4`;
- the logical quotients are `R_6/C_Gamma ~= J^(2)` and
  `C_Gamma^perp/R_4 ~= J^(2),dual`, with their residue/commutator pairing;
- the code is `[[12,2,(6,4)]]_11`, with relative generalized-weight
  hierarchies `(6,7)` and `(4,5)` and asymmetric Singleton defect two; and
- the associated state is 3-uniform, not AME.

At `q=13`, reproduce the stated resonance examples `[[14,4,4]]_13` and
`[[14,2,(8,4)]]_13`, keeping distinct constructions distinct in the output.
Any general relative-weight formula beyond these frozen cases must be proved,
not extrapolated.

## Deliverables

1. Give a canonical finite-field and projective-line normalization, including
   infinity, conic evaluation coordinates, jets, duality, and residue signs.
2. Emit exact X/Z check matrices, verify CSS commutation and dimensions, and
   provide quotient bases for logical X and Z operators with their full Pauli
   pairing matrix.
3. Emit independently replayable certificates for asymmetric distances and
   relative generalized weights. Derive them from the MDS parent and classified
   minimum words where possible; require a checker that rejects deliberately
   corrupted certificates.
4. Reproduce the complete `q=11` packet and both named `q=13` constructions,
   then test representative additional odd prime powers without replacing the
   general proof obligation by experiments.
5. Specify a durable compiler artifact and interface only after the mathematics
   is frozen: inputs, normalization metadata, matrices, logical bases,
   certificates, and explicit failure modes must round-trip exactly.
6. Separately compute the diagonal-phase constraints induced by the square and
   cube Schur algebra. Either exhibit and certify a transversal non-Clifford
   logical phase on the two jet qudits, or produce a bounded negative/no-go
   result stating exactly which phase class and fields were excluded.
7. Map every emitted object to its source theorem or new proof. Keep speculative
   Rees-lift interpretations of flops as gauge fixing/code deformation outside
   the compiler until a separate theorem and task authorize them.
8. Run a dedicated novelty audit before any comparative or publication claim,
   including asymmetric quantum GRS, CSS, generalized-weight, and transversal-
   gate literature.

## Acceptance gate

- The constructor works over exact odd prime-power fields, including extension
  fields where supported, and records its field representation.
- Check matrices commute; encoded dimensions, quotient bases, and logical Pauli
  pairing agree by two independent computations.
- Distance and relative-weight certificates replay exactly and corrupted
  certificates fail.
- The `q=11` and `q=13` outputs match every frozen parameter above, with no AME
  claim for the `q=11` jet-quotient state.
- The family theorem is supported by a symbolic proof map; finite sampling alone
  is not accepted as a general proof.
- Compiler completion does not depend on a positive transversal-gate result.
- No novelty claim or manuscript placement is made without the separate audit,
  and no Clebsch or AME manuscript is edited under C967.

## First action

Freeze exact source locators and conventions for `R_d`, `C_Gamma`, the two-jet
map, and the residue pairing. Then write a one-page mathematical schema and a
small hand-computed `q=11` fixture before choosing the implementation language.
