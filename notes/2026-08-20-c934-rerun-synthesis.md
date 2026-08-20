# C934 repaired-manuscript rerun synthesis

**Date:** 2026-08-20

## 1. Frozen authority and inputs

This synthesis concerns only authority commit
`8a46b475da8241695ab83e2b90e5bce9e0188c0e` and the 11-page PDF with
SHA-256
`98b8669dce44baa12f5bf21235d32a6aa850a50b9daf622aa5790ea90288d655`.
Any later manuscript change lies outside this verdict.

| Packet | Scope | Report SHA-256 | Verdict |
|---|---|---|---|
| A | integral/modular direct image and Loewy structure | `fae407f68c589c1dd1e3d7835b39bcc5c9330889c74740076980c9114767cde4` | A |
| E | editorial, priority, title, abstract, and rendering | `e36b51fa695db832b38f51910e2334ceb2b7ebe90c76261423239f7b83b99f71` | A |
| G | Fano globalization, higher comparison, and relative Lefschetz | `677ad745b1ac3cec805f7e78638ced515978762ce7acdbea58fd5a29c97585dc` | A |

## 2. Final verdict

**Unanimous A -- accept / ready to submit.** All three fresh reruns independently
verify the repaired frozen PDF. No theorem, coefficient convention, priority
boundary, abstract claim, or presentation surface has a remaining required
finding.

The manuscript now supports a coherent combined theorem: the earlier global
mod-two lattice glue, the integral factor-three direct-image obstruction, the
canonical characteristic-three Loewy object, the Fano globalization of the
local class, and the explicit failure of relative hard Lefschetz modulo three.

## 3. Initial-repair closure

| Initial B finding | Fresh evidence | Closure |
|---|---|---|
| Derived reduction of the residual integral perverse object was not explicitly justified | A verifies that every displayed residual stalk and costalk group is free, so derived tensor with `F_3` introduces no Tor in those groups, preserves the perverse degree bounds, and yields a perverse `P_3`; E confirms the bridge is printed on pp. 9--10 | **Closed** |
| A torsion point-supported summand was not explicitly excluded | A verifies that such a direct summand would contribute torsion to the displayed free groups; the central Smith factor three then excludes the remaining free point summand | **Closed** |
| Cipriani's general closed-stratum classification was uncited | A and E verify the introduction and Section 7 citations to Lemma 3.12, Theorem 3.21, Corollary 3.22, and the projection sequences, together with an exact example-specific boundary | **Closed** |
| de Cataldo--Migliorini's rational intersection-form mechanism was uncited | E verifies the introduction and Section 7 attribution, including the rational coefficient boundary and the isolated-fourfold/decomposition references | **Closed** |
| Bibliography and rendering needed a new-PDF check | E inspects all 11 pages; A and G independently inspect their changed surfaces. Citations, equations, filtration, corollary, and bibliography render cleanly | **Closed** |

The repairs changed exposition and attribution, not the original theorem
mechanisms. The new Loewy and relative-hard-Lefschetz statements were then
audited as substantive upgrades rather than presumed consequences.

## 4. Integral and modular direct-image verdict

Packet A reconstructs equations (19)--(23) at the stated coefficient level.

- Proper base change and Thom excision give the printed stalk/costalk shifts.
- The three integral intersection blocks are exactly `[-1],[-3],[-1]`.
- The two unit blocks split simultaneously over `Z`; the residual object is
  perverse and has no integral point summand.
- Inverting three splits the central point object and recovers the rational
  intermediate extension.
- Derived reduction gives the exact attachment
  `F_3^11 ->> F_3 ->^0 F_3 -> F_3^11`; both dimensions 11 and the
  Bockstein/Tor companion are accounted for.

No hidden torsion summand, coefficient shift, or modular t-exactness assumption
remains.

## 5. Loewy upgrade verdict

**Pass at full advertised strength.** Packet A verifies that Cipriani's
projection sequences applied to the zero canonical map give the canonical
filtration

`0 < delta_0 < Q < P_3`

with successive factors
`delta_0, IC_Theta(F_3), delta_0`.

The lower adjacent extension cannot split because `Q=P_!P_3` has no point
quotient; the upper cannot split because `P_*P_3=P_3/delta_0` has no point
subobject. The chain is simultaneously the radical and socle filtration, the
composition series is unique, and `P_3` is uniserial of length three. Its
canonicity is canonicity of the subobject chain, not of a basis for either
one-dimensional point factor.

Packet E confirms that Theorem 1.4 states this structure prominently and
attributes the general framework without surrendering the computed
cubic-theta specialization.

## 6. Relative-hard-Lefschetz upgrade verdict

**Pass with exact multiplier `+3`.** Packet G verifies the outer perverse
cohomology sheaves as `Z_0` in degrees `-2` and `2`, with unit-normalized stalk
generators `h` and `[pt]`. For
`eta=c_1(O_M(-X))`, one has `eta|_X=h`, hence

`eta^2(h)=h^3=3[pt]`.

Thus Corollary 1.5's relative Lefschetz map is multiplication by positive
three, not merely by `+-3`; its reduction modulo three is zero and relative
hard Lefschetz fails. Packet A independently checks that the abstract's RHL
sentence follows from this calculation. Packet E confirms that presenting it
as a corollary preserves the theorem hierarchy.

## 7. Fano globalization and higher-degree comparison

Packet G revalidates equations (24)--(26).

- The degree-four point input to the resolved difference map has no excess,
  multiplicity, sign, or degree-six factor:
  `e^*u_4=ell` and `b_*u_4=[F]=theta^[3]`.
- The global restriction `u_4|_U` has infinite order although its link
  restriction is the order-three class `tau`.
- The rational boundary vanishes, and the integral generator proves the exact
  index-three sequence rather than merely a rational rank statement.
- The constant-to-IC triangle and integral degree-three endpoint surjectivity
  prove `H^k(Theta,Z)=IH^k(Theta,Z)` for every `k>=4`, including `k=4`.

The earlier degree-three mod-two lattice theorem remains unchanged.

## 8. Title, abstract, priority, and rendering

**Title: pass.** *Integral Cohomology and Modular Decomposition for the Theta
Divisor of a Cubic Threefold* remains accurate after the upgrades. “Modular
decomposition” now covers both the length-three characteristic-three object and
its relative-Lefschetz consequence, while the final phrase keeps the claim
example-specific.

**Abstract: pass at 147 tokens.** Independent rendered-PDF counts in all three
packets agree on **147 conservative whitespace tokens**, below both the
preferred 150 target and the hard 250 limit. The active-voice abstract states
the lattice, integral direct image, Loewy structure, Fano lift, higher-degree
comparison, and modular RHL failure without exceeding the theorems.

**Priority: pass.** The revised paper accurately assigns the rational formula
to Krämer, the rational intersection-form mechanism to de
Cataldo--Migliorini, the field rank criterion to
Juteau--Mautner--Williamson, the general small-extension classification to
Cipriani, and the abstract mod-two Smith data to Faulkner
Valiente--Miller Eismeier. The paper claims only its explicit integral,
modular, and Fano specialization. No unqualified firstness claim remains.

**Rendering: pass.** The full 11-page visual audit found no collision,
clipping, unresolved citation, broken reference, bad page break, or unreadable
density. The new Loewy filtration and Corollary 1.5 render cleanly.

## 9. Exact remaining findings

**Required findings: none.** No further referee rerun is needed on the frozen
authority.

Three optional copyedits do not condition acceptance:

1. define `Q=P_!P_3` immediately before the displayed Loewy filtration;
2. add `arXiv:2607.09379` to the Cipriani bibliography entry;
3. replace “This class has infinite order” after (24) by “The class `u_4|_U`
   has infinite order.”

Adopting any of these would change the frozen PDF and require ordinary
production validation, but none exposes a proof or attribution gap.

## 10. Venue consensus

### Mathematische Zeitschrift

**Consensus strongest acceptance-adjusted target.** Packets A and E explicitly
rank MZ first, and Packet G finds no obstacle. The paper is a complete
specialist theorem package whose example-specific breadth and 11-page scale
fit MZ well.

### Algebraic Geometry

**Defensible specialist stretch.** Packet G recommends submission on the
strength of the Fano globalization and explicit modular RHL failure; A and E
also regard AG as credible but higher-risk. The issue is editorial breadth,
not correctness or novelty misstatement. If optimizing prestige rather than
acceptance-adjusted value, AG is supportable; the consensus EV choice remains
MZ.

### Proceedings of the American Mathematical Society

**Strong conservative fallback, no longer the best fit.** All packets find the
paper mathematically suitable in scale, but the canonical Loewy structure,
integral direct image, and modular RHL upgrade now address a more specialist
geometry/topology audience than the original short lattice note.

## 11. Confidence and limits

Confidence is **high** in the unanimous mathematical and presentation verdict:
the integral/modular, geometric, and editorial surfaces were independently
reconstructed on the same frozen hash. Confidence in the MZ-over-AG ordering is
**medium-high** because venue selectivity is editorial.

The priority conclusion remains bounded to the audited corpus. The paper makes
no global firstness claim, so that inherent literature limit is not a
submission blocker.

## 12. Mystery ledger and submission status

The explicit `ej`+`tt` closeout finds no genuine mathematical mystery. The
extra mod-three degree-three class is the Tor/Bockstein companion of the
integral link class; the Loewy chain is canonical through maximal point
subobject and quotient; the relative Lefschetz sign is fixed as `+3`; and the
Fano class explains why the local order-three class is not global torsion.

**Submission status: ready.** The initial B findings are closed, all three
fresh packets return A, the abstract is 147 tokens, and no required finding
remains. The strongest consensus target is Mathematische Zeitschrift, with
Algebraic Geometry as a defensible stretch and Proceedings as a fallback.
