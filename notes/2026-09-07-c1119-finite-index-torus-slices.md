# C1119: Finite-index slices and zero-cycles

**Lane:** `cubic-threefolds`

## Result and scope

The finite-index extension is proved with all the original tangent,
transversality, freeness, and descent hypotheses retained, in characteristic
zero. For lattice index d, the rational slice component has degree e dividing
d over the quotient. It need not have degree d. The O(1,2) scroll supplies a
fully specified example with d=2 and e=1.

For finitely many such constructions of a common birational quotient, with
indices d_i, every smooth proper model has a degree map on CH0 that is
surjective over every field extension, and its kernel is annihilated by
gcd(d_i). Thus coprime indices imply universal CH0-triviality. This is a
criterion, not an asserted new nonrational example with coprime-index slices.

New manuscript labels:

- `thm:finite-index-slice`;
- `rem:finite-index-scroll`;
- `cor:finite-index-chow`.

Each has absent Lean coverage. There is no new finite computational evidence
bundle: the proof and the scroll identities are elementary arguments printed
in full, not results certified by a new program. Existing certificates and
inputs are unchanged.

The author's accessibility instruction was applied immediately: the full
finite-index development follows the main rationality proofs and their
corollaries. It does not interrupt the quotient-to-Cox-to-cubic argument.
The opening roadmap identifies these subsequent sections as a later reading.
The abstract and main theorem statements retain the cubic headlines.

## Proof audit

1. **Component and descent.** Since Lambda contains the projection centre,
   its intersection with the isomorphism open is the inverse image of an
   open in a k-linear P^(n-r). The given geometric witness proves this open
   nonempty. Its closure C is therefore k-defined, geometrically integral,
   and k-rational. No arbitrary geometric component is assumed to descend.
2. **Isogeny.** The selected weight spaces form a Galois-stable set. Their
   difference lattice M' is therefore stable even for affine weight actions.
   The finite-index inclusion M' in M defines an isogeny T -> T' with
   finite etale kernel of order d in characteristic zero.
3. **Dominance.** At the witness, A(x) has kernel the all-ones vector.
   After removing the common character, differentiation along the orbit
   gives the last r columns of A(x) times the differential of the isogeny.
   Both are invertible: the first by the nonzero cofactor, the second in
   characteristic zero. Thus orbit and slice tangent spaces are
   complementary. T times C -> Z is etale at the witness and dominant.
   This ensures that C meets an invariant quotient open and dominates it.
4. **Divisibility.** After algebraic closure of constants, the generic orbit
   is a split-torus torsor and has a rational point by Hilbert 90. The
   complete orbit-section intersection is a torsor under a constant finite
   group H of order d. Its Galois action is by translations through a
   subgroup, so every field factor has degree dividing d. Geometric
   integrality of C ensures its generic fibre is one factor. Generic
   finite-flat rank preserves its degree under extension of constants.
   This proves e divides d; merely counting d geometric points would not.
5. **Zero-cycles.** A k-point in the parametrization domain supplies a
   k-point of each proper model, hence a degree-one cycle over all F/k.
   Resolve the parametrization; its smooth rational source has CH0=Z
   universally. Move a degree-zero cycle into the finite-flat locus, pull
   it back there, and push it forward. The pullback has degree zero and
   vanishes on the source; pushforward is multiplication by e. Hence d
   annihilates A0 too, and a Bezout combination of the d_i proves the gcd
   assertion. Surjectivity and kernel vanishing are separate arguments.

The characteristic-zero hypothesis is used both for the differential of
an arbitrary-index isogeny and for resolution of the rational maps. No
positive-characteristic extension is asserted.

## Examples and boundaries

The affine weights 0,d,1 give an effective action with correction equation
t^d=x0/x1. It illustrates genuine finite ambiguity but is not claimed to
satisfy the tangent hypotheses.

For the full example, Z=P1 times P1 embedded by O(1,2) has affine coordinates
[1:x:y:xy:y^2:xy^2]. Scaling y gives weights 0,1,2 of multiplicity two.
Select weights 0 and 2, use p=(1,1), and take the hyperplane restricting to
(x-1)(y^2-1)=0. It contains the tangent plane and the omitted weight-one
space. With u=x-1 and v=y-1, tangent projection is [uv:v^2:uv^2], with
inverse u=Y2/Y1 and v=Y2/Y0. The witness (2,-1) is free, lies on the
isomorphism open, and has evaluation row (-1,1). The rational component
meeting that open is y=-1 and maps birationally to the quotient k(x).
The other components lie outside the isomorphism open. Automorphisms of
the factors give the generic tangent-projection hypothesis at every point.
All of these identities are derived explicitly in the manuscript.

The example demonstrates why replacing e|d by e=d would be false. It is
already rational. Useful nonrational coprime-index examples still require
full geometric hypotheses, not just lattice determinants; future algorithmic
work in C963/C965 can use the criterion without claiming these examples exist.

## Source review and provenance

The cache was queried before fetching. Sources read at their actual
hypotheses and pinpoints:

- Colliot-Thelene--Coray, *L'equivalence rationnelle sur les points fermes
  des surfaces rationnelles fibrees en coniques*, Compositio Math. 39
  (1979), 301--332, Lemma 6.2 and Propositions 6.3--6.4, pp. 328--329.
  Numdam PDF: https://www.numdam.org/item/CM_1979__39_3_301_0.pdf .
  Cache key `numdam:CM_1979__39_3_301_0`, SHA-256
  `63ff5055d54ca6df220f493dd9414c33d73e49f7473a7d16b4b1a3d33e7cf321`.
  The source states the degree annihilation for smooth projective
  geometrically integral varieties in characteristic zero; the proof uses
  resolution, birational invariance and pullback/pushforward.
- Auel--Colliot-Thelene--Parimala, *Universal unramified cohomology of cubic
  fourfolds containing a plane*, Section 1.2, pp. 5--7 of the author PDF,
  especially the paragraph after Theorem 1.4. Author PDF:
  https://math.dartmouth.edu/~auel/papers/docs/ACTP_universaltriviality.pdf .
  Cache key `arXiv:1310.6705`, SHA-256
  `bb4706201295da590431d63639a3392f207f13f454d3eb7cb6bfa7cc186ea2fc`.
  This states the smooth proper formulation, universal N-torsion of A0,
  and the moving lemma. The distinction between A0 and a degree-one cycle
  is retained explicitly in our corollary.

Both are registered in the imported-source ledger with field, model,
degree, and index conventions. The scalar degree argument is classical;
the manuscript claims no priority for it. No absence-of-literature claim or
novelty verdict is made for the slice extension.

## Validation

The final authority `make check` passed after moving the extension behind
the main proofs (run-quiet directory
`/tmp/claude-run-quiet/20260907-161922-make-C-cubic-stabilization-irrationality-check/`).
The PDF has 16 pages, 157499 bytes, and SHA-256
`29b668b0b568272a87625147fe0e88751af386a7eee118c40d1bee98ed68cd87`.
Pages 11--13 were visually inspected, including the full finite-index
argument, scroll example, zero-cycle corollary and following section.
The source scan of Colliot-Thelene--Coray p. 329 was also inspected to
confirm the precise parametrization and characteristic hypotheses.
The main quotient/Cox/cubic route remains Sections 2--4; the extension is
Section 6. The abstract and headline statements were not expanded by C1119.
Standalone synchronization remains pending at this authority checkpoint.

## Mystery ledger — ej + tt

- **Settled:** a geometric slice witness does not alone prove dominance;
  the invertible orbit differential supplies the missing argument.
- **Settled:** a degree bound e<=d alone would not imply coprimality;
  constant-kernel torsor components give the required divisibility.
- **Settled:** e may be a proper divisor of d; the scroll supplies a full
  geometric example, not a toy weight action.
- **Settled:** zero-cycle degree surjectivity needs its own argument;
  the rational parametrization supplies a k-point.
- **Useful strengthening:** the gcd formulation admits several indices with
  gcd one even if no pair is coprime. No additional geometric input is needed.
- **Outside this task:** new nonrational quotients admitting such a
  collection are not supplied. This is an example-existence requirement
  for future work, not a gap in the conditional criterion.

The post-gate ej + tt pass checked these conclusions against the final
theorem and example. It retained the stronger gcd statement and the proper
divisor example, with all descent and component qualifications explicit.
No further task-owned theorem or unresolved case was found. There is no
incidental discovery-track entry to manufacture.
