# Theorem adoption map

This map freezes the claims adopted by the C538 manuscript. “Complete” means the stated
classification covers every admissible field in its declared code range. “High-field” means the
paper makes no claim below the displayed threshold.

| Source | Manuscript result | Adopted strength | Exact boundary | Proof/evidence type |
|---|---|---|---|---|
| C491 | Complete redundancy-five classification | complete classification | every prime power `q >= 7`; sporadic orbits exactly at `7,8,9,11,13,17,19` | characteristic-free Hankel/cubic-cover proof plus exhaustive finite certificates |
| C498 | Redundancy-six classification | complete classification | every prime power `q >= 7`; small exceptional tables at `7,8,9,11,13`; recurring binary nucleus orbit for odd `m >= 5` | polar-line proof plus bounded census and semilinear normal-form certificate |
| C509 | Redundancy-seven split-free syndrome classification | complete split-free classification; deep-hole classification only with the radius gate | every prime power `q >= 7` for split-freeness; genuine deep holes for `q >= 11`; the `q=7,8,9` radius gate is not supplied | pointed polar proof plus orbit-reduced finite certificate |
| C512 | Effective coherent polar induction | conditional containment theorem | applies at each fixed degree only after the lower splitting package, degree bounds, and contained-carrier calculation are verified | characteristic-free theorem; no census |
| C513 | Redundancy-eight theorem | high-field classification | `q >= 43`; no statement about extra orbits below `43` | three-marker genus-one cover and complete modular-lift calculation |
| C516 | Redundancy-nine theorem | high-field classification | `q >= 53`; no full bounded-field classification | four-marker cover, binary-quartic residual component theorem, and exact `q=49` carrier closure |
| C517 | Redundancy-nine Lean boundary | formal implication and algebra, not a full formalization | geometric integrality, Hasse–Weil existence, coding identification, and exhaustion remain explicit hypotheses | Lean algebra/synthesis terminals and axiom audit |
| C525 | Characteristic-two ordered-Hessian theorem | containment theorem | all degrees `n >= 5` under the displayed base-selection and Hasse–Weil inequalities | geometric component classification plus deterministic algebra regression |
| C529 | Power-of-two Lucas endpoint family | arithmetic component theorem | distinguished Borel endpoint for every `d=2^s`; split in its linearized net iff `s | m` | normalization and exact monodromy; bounded Lucas/cycle replay |
| C530 | Degree-nine `e_7` orbit | arithmetic component theorem and obstruction result | the full `PGL2` orbit is shallow over every admissible characteristic-two field; no claim on other carrier strata | Artin–Schreier normalization, `AGL_3(F2)` additive cover, subspace-polynomial witnesses |

## Main theorem labels

- `Theorem 1.1`: complete redundancy-five classification.
- `Theorem 1.2`: classification spine, with all-field and high-field clauses separated.
- `Theorem 4.1`: conditional effective coherent polar induction.
- `Theorem 5.1`: complete redundancy-six classification.
- `Theorem 5.2`: complete redundancy-seven split-free classification and the `q>=11` deep-hole corollary.
- `Theorem 6.1`: redundancy-eight high-field classification.
- `Theorem 6.2`: redundancy-nine high-field classification plus the characteristic-seven carrier boundary.
- `Theorem 7.1`: characteristic-two ordered-Hessian component and containment theorem.
- `Proposition 8.1`: power-of-two linearized root-cover arithmetic.
- `Theorem 8.2`: degree-nine `e_7` orbit and additive-cover shallowness.

## Excluded claims

- No arbitrary-redundancy Reed–Solomon deep-hole classification.
- No complete redundancy-eight or redundancy-nine bounded-field classification.
- No promotion of the redundancy-seven `q=7,8,9` split-free tables to code deep holes without a
  covering-radius proof.
- No redundancy-ten theorem.
- No assertion that every Lucas-carrier point is deep.
- No promotion of C529’s order-three component cycle to a full-kernel deepness law.
- No claim that the C517 Lean package proves the geometric component, point-existence, or coding inputs.
