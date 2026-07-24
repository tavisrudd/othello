# Claim, proof, novelty, and formalization ledger

## Headline claims

| Claim | Proof location | Imported inputs | Finite evidence | Novelty wording | Lean successor |
|---|---|---|---|---|---|
| `rho(PRS(q-4))=4` for `q>=7` | manuscript §3 | Seroussi–Roth completeness range; ZWK coding dictionary | C491 census independently checks the low band | not claimed novel | C540 |
| Complete redundancy-five family list and counts | manuscript Theorem 1.1 and §3 | ZWK tangent/sigma families; KPP quartic orbit toolkit; Aubry–Perret bound | C491 generator/certificate/replay/manifest | new to our knowledge, subject to recorded MathSciNet gap | C540 |
| Redundancy-six all-field classification | manuscript Theorem 5.1 | C491 lower cover; standard torus action; NRC nuclei | C498 census and small-normal-form bundles | new to our knowledge; scalar radius excluded | C541 |
| Redundancy-seven all-field split-free classification and `q>=11` deep-hole classification | manuscript Theorem 5.2 | C498 pointed lower theorem; NRC nuclei; Seroussi–Roth radius gate for `q>=11` | C509 calibration bundle; `q=7,8,9` remains split-free only | new to our knowledge; scalar radius excluded | C541 |
| Effective coherent polar induction | manuscript Theorem 4.1 | Hasse–Weil/Aubry–Perret; Wang’s general splitting semantics; Lucas nucleus criterion | none required | novelty restricted to pointed Hankel functor, contained/transverse theorem, and explicit threshold | C539/C541 |
| Redundancy-eight `q>=43` | manuscript Theorem 6.1 | C512, C491 ordered-pair monodromy | C513 algebra/nucleus certificate and independent replay | new fixed-level delta to our knowledge | C542 |
| Redundancy-nine `q>=53` | manuscript Theorem 6.2 | C512, binary-quartic invariant theory, Hasse–Weil | C516 theorem bundle and q=49 carrier closure | new fixed-level delta to our knowledge | existing C517 plus C539/C544 reconciliation |
| Characteristic-two ordered-Hessian containment | manuscript Theorem 7.1 | classical twisted cubic/Veronese/NRC nucleus objects | C525 bounded regression and replay | no priority claim for classical objects; claim restricted to direct modular synthesis and PRS pullback | C543 |
| Power-of-two Lucas endpoint arithmetic | manuscript Proposition 8.1 | Lucas theorem and C512 contraction kernel | C529 generator/certificate/replay/manifest | no priority claim | C543 |
| Degree-nine `e_7` orbit is shallow | manuscript Theorem 8.2 | C529 kernel | C530 generator/certificate/replay/manifest | no priority claim | C543 |

## Cited and external hypotheses

- Seroussi–Roth: the normal-rational-curve completeness range used for the redundancy-five covering-radius gate.
- Zhang–Wan–Kaipa and Kaipa: projective syndrome/deep-hole/MDS-extension dictionary, automorphism action, and the lower-redundancy tangent/sigma families.
- Kaipa–Patanker–Pradhan: binary-quartic orbit and apolar-invariant toolkit where used.
- Aubry–Perret/Hasse–Weil: rational-point bounds for integral curves of arithmetic or geometric genus at most one.
- Cesaratto–Matera–Pérez: general factorization-pattern precedent, not a proof of the exceptional Hankel classifications.
- Gmainer–Havlicek: binomial-coordinate description of NRC nuclei.
- Wang: general Frobenius/monodromy semantics for splitting families, not the pointed Hankel induction theorem.

## Current formal boundary

C517 formalizes the redundancy-nine residual-quadratic algebra and final synthesis implication.
Its visible hypothesis structure leaves the following outside Lean:

1. the six-slice binary-quartic component theorem;
2. Hasse–Weil point existence with the exact deletion budget;
3. identification of persistent geometric families with PRS syndrome families;
4. exhaustion of the nonpersistent locus;
5. the genuine `PGL2/PGammaL2` action giving the orbit table.

C539–C544 must expose these rather than replace them with opaque certificate booleans.

## Literature wording gate

The paper uses “to our knowledge” once, for the integrated contribution. The attached C491–C516
claim-specific audits did not cover MathSciNet and therefore do not authorize an unqualified
priority claim. C525, C529, and C530 make no absence-based priority claim.
