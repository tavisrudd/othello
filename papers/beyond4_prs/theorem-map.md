# Theorem adoption map

This map freezes the claims adopted by the R5--R7 manuscript. “Complete”
describes the mathematical classification in its declared range; publication
readiness remains separately gated by the proof, evidence, trust, and release
ledgers.

| Source | Manuscript result | Adopted strength | Exact boundary | Proof/evidence type |
|---|---|---|---|---|
| R5 | Complete redundancy-five classification | complete classification | every prime power `q >= 7`; sporadic orbits exactly at `7,8,9,11,13,17,19` | characteristic-free Hankel/cubic-cover proof plus exhaustive finite certificates |
| R5 quantum corollary | Balanced \(q=8\) MDS extension, \(\operatorname{AME}(10,8)\), and \([[9,1,5]]_8\) quantum MDS code | exact derived corollary; no claim of a complete LU/LC orbit table | the `1116=360+756` relative projective extension directions at `(r,q)=(5,8)`; the only balanced prime-power row among R5--R7 | R5 extension dictionary and Certificate R5 count; standard MDS--AME/Choi correspondence; companion MDS--CSS LU and transversal-conversion theorems |
| R6 | Redundancy-six classification | complete classification | every prime power `q >= 7`; small exceptional tables at `7,8,9,11,13`; recurring binary nucleus orbit for odd `m >= 5` | polar-line proof plus bounded census and semilinear normal-form certificate |
| R7 | Redundancy-seven split-free syndrome classification | complete all-field split-free classification; deep-hole promotion only with the radius gate | finite certificate through `q=32`; geometric continuation from `q>=37`; genuine deep holes only for `q >= 11`; the `q=7,8,9` radius gate is not supplied | explicit degree-16 second-marker scheme, pointed linear-gcd and \(S_3\) bottom packages, contained rank-two proposition, and orbit-reduced finite certificate |
| Polar flags | Polar construction and finite-depth escape | exact conditional construction and effective finite-depth implication | every stage requires its displayed carrier, collision, marker, and terminal-cover inputs; these are proved here only at depths one and two | projective divided-power contraction plus manuscript geometry and cited point bounds |
| Lean boundary | R5--R7 algebra, arithmetic, coordinate identities, finite-table transcription, and conditional synthesis | one exact paper-facing closure, not a full formalization of the geometry | geometric classifications, cited theorems, group actions, and certificate semantics remain manuscript, literature, or public-validation inputs | `RelativeConicArcs.Gates.PRSBeyondRedundancyFour`, its axiom audit, and `supplement/LEAN-STATEMENTS.md` |

## Stable source labels

- `thm:r5`: complete redundancy-five classification.
- `cor:q8-quantum-extension`: balanced field-eight MDS, AME, and quantum-MDS consequence.
- `thm:spine`: R6/R7 classification spine and persistent orbit law.
- `thm:polar-construction`: intrinsic polar-flag construction and squarefree
  lifting.
- `thm:induction`: finite-depth polar escape from uniform stagewise marker
  exclusions and a terminal splitting cover; R6 and R7 instantiate depths one
  and two.
- `thm:r6`: complete redundancy-six classification.
- `thm:r7`: complete redundancy-seven split-free classification and the
  `q>=11` deep-hole corollary.

The complete set of 37 retained numbered labels is reconciled mechanically
against `supplement/LEAN-STATEMENTS.md` by `supplement/verify.py`.

## Companion-work boundary

Redundancy eight, redundancy nine, ordered-Hessian geometry, an all-level
classification of the recursively contained carrier, and higher Lucas-carrier
arithmetic are not adopted by this manuscript.  The finite-depth escape
theorem does not supply those carrier hypotheses.  Some reusable interfaces
remain in the regression-checked Lean import closure, but no theorem from that
companion work is mapped to a manuscript claim.

## Excluded claims

- No arbitrary-redundancy Reed--Solomon deep-hole classification.
- No assertion that characteristic two has no higher modular carriers.
- No redundancy-eight, redundancy-nine, or redundancy-ten theorem.
- No promotion of the redundancy-seven `q=7,8,9` split-free tables to code
  deep holes without a covering-radius proof.
- No assertion that every Lucas-carrier point is deep.
- No claim that Lean proves the geometric component, point-existence, coding,
  group-action, or external-certificate inputs.
