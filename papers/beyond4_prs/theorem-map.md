# Theorem adoption map

This map freezes the claims adopted by the C538 theorem spine; it does not certify that the
fifteen-page announcement contains submission-length proofs. “Complete” describes the mathematical
classification claimed in its declared range. The claim remains release-gated wherever the proof
ledger says `OPEN-MATH` or `REVIEW-GATE`. “High-field” means the paper makes no claim below the
displayed threshold.

| Source | Manuscript result | Adopted strength | Exact boundary | Proof/evidence type |
|---|---|---|---|---|
| C491 | Complete redundancy-five classification | complete classification | every prime power `q >= 7`; sporadic orbits exactly at `7,8,9,11,13,17,19` | characteristic-free Hankel/cubic-cover proof plus exhaustive finite certificates |
| C498 | Redundancy-six classification | complete classification | every prime power `q >= 7`; small exceptional tables at `7,8,9,11,13`; recurring binary nucleus orbit for odd `m >= 5` | polar-line proof plus bounded census and semilinear normal-form certificate |
| C509 | Redundancy-seven split-free syndrome classification | complete all-field classification; deep-hole promotion only with the radius gate | finite certificate through `q=32`; geometric continuation from `q>=37`; genuine deep holes only for `q >= 11`; the `q=7,8,9` radius gate is not supplied | pointed transverse proof, characteristic-free contained rank-two proposition, and orbit-reduced finite certificate |
| C512 | Polar-flag construction and effective transverse induction | unconditional construction, uniform ordinary rank-two containment, plus conditional transverse theorem | applies at each fixed degree after the lower splitting package, degree bounds, and any residual marker/modular contained assertions are proved | characteristic-free construction, rank--nullity proposition, and transverse theorem; no census |
| C513 | Redundancy-eight theorem | unconditional high-field classification | `q >= 43`; `CC(7,1)` and `LP(6,1)` are proved; no statement about extra orbits below `43` | explicit recursive lower-carrier equations, geometric-`S3` three-marker cover, direct gcd-one treatment, uniform contained/collision propositions, and modular-lift calculation |
| C516 | Redundancy-nine theorem | conditional high-field classification | `q >= 53`; requires contained, six-slice, and rational-base assertions; no full bounded-field classification | four-marker proof, residual identities, conditional quartic slice theorem, and exact `q=49` carrier closure |
| C517 | Redundancy-nine Lean boundary | formal implication and algebra, not a full formalization | geometric integrality, Hasse–Weil existence, coding identification, and exhaustion remain explicit hypotheses | Lean algebra/synthesis terminals and axiom audit |
| C525 | Characteristic-two ordered-Hessian theorem | geometric degeneracy theorem plus conditional containment/effective corollary | all degrees `n >= 5` only after root-compatible pullback and global bad-union polynomial gates | geometric strata plus deterministic regression; union-degree constant remains open |
| C529 | Power-of-two Lucas endpoint family | arithmetic component theorem | distinguished Borel endpoint for every `d=2^s`; split in its linearized net iff `s | m` | normalization and exact monodromy; bounded Lucas/cycle replay |
| C530 | Degree-nine `e_7` orbit | arithmetic component theorem and obstruction result | the full `PGL2` orbit is shallow over every admissible characteristic-two field; no claim on other carrier strata | Artin–Schreier normalization, `AGL_3(F2)` additive cover, subspace-polynomial witnesses |

## Stable source labels

- `thm:r5`: complete redundancy-five classification.
- `thm:spine`: classification spine, with all-field and high-field clauses separated.
- `thm:polar-construction`: intrinsic polar-flag construction and squarefree lifting.
- `thm:induction`: conditional effective transverse induction, after a separately proved
  level-specific contained-component assertion.
- `thm:r6`: complete redundancy-six classification.
- `thm:r7`: complete redundancy-seven split-free classification and the `q>=11` deep-hole corollary.
- `thm:r8`: redundancy-eight high-field classification.
- `thm:r9`: redundancy-nine high-field classification plus the characteristic-seven carrier boundary.
- `thm:hessian`: characteristic-two ordered-Hessian component and containment theorem.
- `prop:linearized`: power-of-two linearized root-cover arithmetic.
- `thm:e7`: degree-nine `e_7` orbit and additive-cover shallowness.

## Excluded claims

- No arbitrary-redundancy Reed–Solomon deep-hole classification.
- No complete redundancy-eight or redundancy-nine bounded-field classification.
- No promotion of the redundancy-seven `q=7,8,9` split-free tables to code deep holes without a
  covering-radius proof.
- No redundancy-ten theorem.
- No assertion that every Lucas-carrier point is deep.
- No promotion of C529’s order-three component cycle to a full-kernel deepness law.
- No claim that the C517 Lean package proves the geometric component, point-existence, or coding inputs.
