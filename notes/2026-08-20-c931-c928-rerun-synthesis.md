# C931 -- C928 repaired-referee rerun synthesis

**Date:** 2026-08-20

## 1. Frozen authority and review surface

This synthesis concerns only the revised eight-page PDF at authority commit
`aa31d3ab6f6b266d9f09d4ba5f26ffaf16b6ae02` (`Repair C928 referee findings`).
The PDF
`papers/blown-up-theta-lattice/blown_up_theta_lattice.pdf` has independently
reverified SHA-256
`efb81f1dfa0802c2311a96d8312f5ab3b8ba5cbe85103f3d8b24bf225eb2b382`.
The freeze manifest has SHA-256
`cc0d74526004eab265da94b9e46652a6733d8194cedb1dba10572ffa11b1665d`.

The six fresh, mutually isolated inputs were:

| Packet | Scope | Report SHA-256 |
|---|---|---|
| A | endpoint, signs, factor order, coset, duality | `d223e7edd2c5ca167d212f922a8331d63076082148253196b50d36eeb2c3e277` |
| E | whole-paper editorial ceiling | `0c2c3f43054482c5a97f414011c8fa226e1caffa10eaa89b5ed9aa714213af3f` |
| G | cubic/Fano geometry | `2457b7552a3ea73bc3ddf33a9daa5a143b9176f6150113992d9f9b9bea5025f2` |
| L | integral symplectic Lefschetz lattice | `74fcb0d6f8de098cfb9c20811de7d78b14d11b3e0213e9ec2642a51d5dee64a6` |
| P | priority and literature boundary | `f36ae14bba7cb9d9dba04c71625ae583153deb569152caf52563b73d0505cbd3` |
| T | local topology and integral intersection cohomology | `15a5852f14b5514028c7dd81df4ae073e3c70c86a311ee7c02df74511781ec9c` |

No earlier report or synthesis enters this verdict.

## 2. Verdict

**A -- accept; submission-ready for Proceedings of the AMS.** All six fresh
referees return A, no packet requests a mathematical, citation, priority,
convention, or presentation repair, and the revised proof retains every stated
theorem. The independent rerun therefore closes the repair cycle.

| Packet | Verdict | Required finding left open | Proceedings call | Algebraic Geometry packet call |
|---|---|---|---|---|
| A | A | none | accept | decline on scope |
| E | A | none | accept / submit | decline at stretch ceiling |
| G | A | none | accept | passes this packet only |
| L | A | none | accept | no algebraic objection |
| P | A | none | accept | do not recommend at stretch ceiling |
| T | A | none | submit | credible stretch on this packet only |

The mixed last column is not a correctness split. Geometry, algebra, and
topology clear their specialist checks; the whole-paper and priority readers
place the surviving eight-page contribution below *Algebraic Geometry*'s
editorial significance ceiling.

## 3. Repair closure

| Adopted repair | Fresh evidence | Closure |
|---|---|---|
| Credit FVME Theorem 2.9, Corollary 2.10, and Proposition 2.14 for the abstract Smith factors and `Lambda/2Lambda` defect | L directly specializes the cited filtration and splittings to `0 + 1` on `P^3` and `2` on `P^1`; P and E verify the same boundary in the printed paper | **Closed.** The paper retains only its direct complete-graph blocks, explicit divided-power representatives, and Fano-labelled simultaneous placement. |
| State the integral intersection-cohomology convention and source | T verifies traditional middle perversity, `mbar(8)=3`, the unshifted `tau_{<=3} Rj_* Z_U` convention, the GM83 citation, and the natural ordinary-to-IH map | **Closed.** The link's degree-four `Z/3` is beyond the cutoff and cannot enter `IH^3`. |
| Display the dual exact sequence behind the escape lattice | A verifies exact dualization of `0 -> ker b_* -> H^3(M,Z) -> S -> 0`, the absence of an `Ext` term, and the identification of the exceptional image with `2E_M`; E confirms readability | **Closed.** Theorem 1.2 now has no implicit transition. |
| Mark Krämer's rational splitting noncanonical and standardize his name | P checks Krämer Corollary 6, its three shifts, coefficient boundary, citation, and spelling; E confirms the printed qualification | **Closed.** No integral splitting is inferred from the rational decomposition. |

## 4. Adopted and non-adopted findings

All four required findings above were adopted in the revised authority. The
fresh rerun adopts no further manuscript change.

Two suggestions are explicitly **not adopted**, because both are optional
wording expansions with zero theorem impact:

1. Packet A notes that “exchanging the two factors if needed” in Proposition
   4.3 could be deleted after the global sign has already been absorbed into
   `y`. It is correct as printed and leaves the canonical mod-two coset
   unchanged.
2. Packet G notes that Lemma 4.1 could spell out the intermediate divisor
   equality `q^*X=mP` before the fibre-degree argument forces `m=1`. The
   support and degree argument already supplies this step.

The editorial observation that *Algebraic Geometry* may demand broader scope
is not a repair request and should not trigger expansion of this short paper.

## 5. Theorem survival and proof audit

- **Theorem 1.1 survives integrally.** T verifies the link, pair, and
  Mayer--Vietoris input over `Z`; L verifies the Smith blocks and saturation;
  G and A verify the integral Fano/cylinder endpoint, multiplicity one,
  Pontryagin coefficient, factor order, and common sign. The fibre product is
  canonical modulo `L(wedge^3 Lambda)`.
- **Theorem 1.2 survives integrally.** A verifies the saturated dual sequence,
  the rank-ten free escape lattice, and the exact doubled exceptional image.
  No torsion or hidden `Ext` term is introduced.
- **Corollary 1.3 survives with the stated scope.** T verifies
  `IH^3(Theta,Z)=H^3(U,Z)=H^3(M,Z)` under the printed unshifted convention.
  The paper correctly makes no all-degree integral decomposition-theorem
  claim.
- **The novelty boundary survives.** L and P confirm that FVME owns the
  abstract Smith and saturation data. The bounded reviewed-source claim left
  to this paper is the explicit Fano-labelled simultaneous mod-two fibre
  product and its dual escape-lattice consequence, supported by the direct
  complete-graph representatives.

The authorized repair delta changed attribution and exposition, not a theorem
or proof mechanism. All specialist packets independently confirm no regression.

## 6. Abstract and format gates

**Pass.** The freeze records 138 prose words and 141 source whitespace tokens.
Independent conservative counts from the rendered PDF range from 176 to 179
tokens, even when displayed mathematics is fragmented. Every count is below
the required 250 words. The paper remains eight clean A4 pages; the editorial
and geometry packets report no collision, clipping, bad break, or bibliography
regression.

## 7. Venue decisions

### Proceedings of the American Mathematical Society

**Recommend submission now.** Every packet recommends acceptance or submission
at this venue. The result is concise, technically complete, accurately credited,
and organized around one integral-lattice theorem with a classical geometric
endpoint. No revision condition remains.

### Algebraic Geometry

**Do not recommend in the present eight-page form.** Some specialist packets
find no obstacle or regard it as a credible stretch, but the independent
whole-paper and priority judgments agree that the surviving contribution is a
focused refinement for one classical theta divisor after the general abstract
Lefschetz invariant is credited. This is an editorial scope ceiling, not a
mathematical or novelty-defect finding. Expanding the paper merely to chase the
venue would weaken the present submission strategy.

## 8. Confidence and limits

Confidence is **high** in the Proceedings-ready verdict: six independent
packets agree; the load-bearing integral topology, lattice algebra, Fano
geometry, endpoint signs, duality, intersection cohomology, source attribution,
and page/abstract gates were separately checked.

The priority conclusion is intentionally bounded: the Fano-labelled fibre
product and dual escape lattice were not found in the reviewed sources. It is
not a claim of exhaustive global novelty, and the manuscript makes no
unqualified firstness claim. The *Algebraic Geometry* call has **medium**
confidence because editorial significance is intrinsically less determinate
than correctness. No external journal decision or production-format check is
part of this rerun.

## 9. Mystery ledger -- explicit `ej` + `tt` closeout

The closeout pass asked whether any cheap strengthening, hidden coefficient
issue, or conceptual mismatch remained after the all-A gate.

| Question | Closeout result | Status / owner |
|---|---|---|
| Could the two optional proof phrases conceal a sign or multiplicity gap? | A shows factor exchange changes only the already absorbed global sign and not the mod-two coset; G shows the fibre-degree comparison forces Cartier multiplicity one. | **Settled; no edit.** |
| Does crediting FVME collapse the paper's theorem? | No. It removes novelty from the abstract Smith invariant but leaves the explicit representatives, Fano-labelled simultaneous placement, and dual consequence intact. | **Settled by L, P, E.** |
| Can the link's `Z/3` contaminate the integral middle group? | No. T verifies that it is in degree four and is removed by the degree-three Deligne truncation. | **Settled.** |
| Should the paper be enlarged for the stretch venue? | No cheap addition changes the editorial ceiling; the coherent eight-page Proceedings paper has higher expected value than scope inflation. | **Settled for this task; any future expansion needs a separately owned theorem.** |
| Is global priority proved exhaustively? | No, nor is it claimed. The defensible statement is the bounded reviewed-source absence recorded above. | **Open only as an inherent literature limit; no manuscript debt.** |

No genuine mathematical mystery remains on the frozen theorem surface. The
only residual uncertainties are global-literature completeness and journal
editorial taste, neither of which blocks submission.

## 10. Final readiness

**Final verdict: repaired, independently re-refereed, and ready for a
Proceedings submission package.** Six of six fresh verdicts are A; all four
repairs are closed; the abstract is safely below 250 words; no required finding
or proof debt remains.
