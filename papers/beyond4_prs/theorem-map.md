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
| Polar flags | Polar construction and one-step escape | exact conditional construction and effective one-step implication | each step requires the displayed lower-cover, collision, component, and witness inputs | projective divided-power contraction plus manuscript geometry and cited point bounds |
| Stable components | All-level irreducible-component exclusion and uniform transverse theorems | unconditional manuscript theorem with partial coordinate formalization | \(\mathrm{SC}(j)\) holds for every \(j\geq6\); the displayed threshold leaves only persistent/modular loci and automatically lies in the Seroussi--Roth radius range, so this is unconditional deep-hole containment; in characteristic \(p>r-1\), the persistent families are the exact deep-hole list of cardinality \(q(q+1)^2/2\) | catalecticant-rowspace transport, integral rank-two/Lucas pullback, Plücker bridge, coherent-Fano identities, Certificate SC, and the imported Seroussi--Roth radius theorem |
| Lean boundary | R5--R7 algebra, arithmetic, coordinate identities, finite-table transcription, and conditional synthesis | one exact paper-facing closure, not a full formalization of the geometry | geometric classifications, cited theorems, group actions, and certificate semantics remain manuscript, literature, or public-validation inputs | `RelativeConicArcs.Gates.PRSBeyondRedundancyFour`, its axiom audit, and `supplement/LEAN-STATEMENTS.md` |

## Stable source labels

- `thm:r5`: complete redundancy-five classification.
- `cor:q8-quantum-extension`: balanced field-eight MDS, AME, and quantum-MDS consequence.
- `thm:spine`: R6/R7 classification spine and persistent orbit law.
- `thm:stable-component-headline`: all-level stable-component classification
  and uniform transverse consequence.
- `thm:polar-construction`: intrinsic polar-flag construction and squarefree
  lifting.
- `thm:induction`: one-step polar escape from an explicit lower package.
- `thm:r6`: complete redundancy-six classification.
- `thm:r7`: complete redundancy-seven split-free classification and the
  `q>=11` deep-hole corollary.

The complete set of 35 retained numbered labels is reconciled mechanically
against `supplement/LEAN-STATEMENTS.md` by `supplement/verify.py`.

## Companion-work boundary

Redundancy eight, redundancy nine, ordered-Hessian geometry, general
Lucas-carrier arithmetic, and the distinguished degree-nine endpoint are not
adopted by this manuscript and are not imported by its Lean gate. Their
development records and formal modules remain companion-work sources, not
paper dependencies.

## Excluded claims

- No arbitrary-redundancy Reed--Solomon deep-hole classification.
- No assertion that characteristic two has no higher modular carriers.
- No redundancy-eight, redundancy-nine, or redundancy-ten theorem.
- No promotion of the redundancy-seven `q=7,8,9` split-free tables to code
  deep holes without a covering-radius proof.
- No assertion that every Lucas-carrier point is deep.
- No claim that Lean proves the geometric component, point-existence, coding,
  group-action, or external-certificate inputs.
