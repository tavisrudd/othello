# C705 — Adjugate realization of the Segre--Igusa polar map

**Lane:** `clebsch`

**Opened:** 2026-07-30

**Status:** in progress

## Objective

Determine whether the six adjugates
\(\operatorname{adj}(B_T(x))\), for
\[
B_T=P_{T,-}D_xP_{T,+},
\]
assemble intrinsically into the Segre--Igusa polar map without first
passing through the six scalar squares \(Z_T^2\).

## Frozen input

Import C704's conference operator, golden eigenspaces, signed Joubert
coordinates, cross-block determinant, matrix factorization, and
Segre--Igusa diagram.  Do not recompute their discovery history.

## Main gates

1. Decompose the span of the quadratic \(2\times2\) minors of all six
   cross-golden blocks under the signed outer \(S_6\)-action.
2. Compute the equivariant Hom space from that span to the outer-standard
   Igusa carrier.
3. Test whether contraction with the six frozen coefficient tensors gives
   the polar coordinates \(W_T\) up to one exact scalar.
4. If the raw adjugates fail, test the trace-free, compound-matrix, and
   exterior-square variants.
5. Identify the base locus scheme-theoretically.

## Upgrades

- Recover the fifteen singular Igusa lines as rank conditions.
- Test direct kernel descriptions of the ten Segre nodes and fifteen
  planes.
- Express the inverse Igusa-to-Segre map in the same operator language.

## Mining subtask — common \(E_8\) shadow source

Test whether the two polar five-spaces and their intertwiner are projections
of the same \(E_8\)-level object, rather than merely meeting after descent to
the exceptional outer action of \(S_6\).

The nearer \(E_6\) gate is positive.  On an \(A_1\) boundary,
the surviving and first-normal-jet halves of Yoshida's ten-dimensional
\(W(E_6)\) Coble system are respectively the Segre and Igusa polar
five-spaces, with an exact constant basis change
\(M\nabla S=-2f\).  Globally the raw jet line bundle is
\(L_{\rm Igu}+B_3\); exact generic valuation on one \(B_3\) component and
\(S_6\)-transitivity show that the canonical \(B_3\) section is its common
fixed factor.  After division the system is the global Igusa contraction.
Full report:
`notes/2026-07-30-c705-e6-first-jet.md`.

1. Fix the exact \(E_8\) linkage already used for the Clebsch operator and
   branch it far enough to locate both outer five-dimensional \(S_6\)
   carriers simultaneously.
2. Search for one parent invariant, tensor, or differential whose two
   projections give \(q\) and \(W\), and whose mixed contraction gives
   \(A\) (hence explains \(\operatorname{adj}(A)=6Wq^{\mathsf T}\)).
3. Test whether the ten nodes, fifteen planes/lines, and bad-characteristic
   behavior are images of root-subsystem or discriminant strata upstairs.
4. Treat failure as evidence: identify the first incompatible branching or
   Hom space, and determine whether the nearest common source is instead
   \(E_6\), an \(A_2\)-lattice/Borcherds construction, or only outer
   \(S_6\).

The positive naming gate is an explicit common lift of \(q,W,A\); shared
\(S_6\) symmetry or membership in the same automorphic ecosystem is not
enough.  Until that gate passes, “\(E_8\) shadow sisters” remains a
conjectural strengthening of the proved “Clebsch shadow sisters.”

Situational source map:
`notes/2026-07-30-c705-shadow-sisters-literature-map.md`.

## Mining subtask — extended sister census

Determine whether the Segre--Igusa pair is the middle member of a larger
exceptional operator family.  A candidate earns “sister” status only if it
has:

1. two canonically paired exceptional carriers or polar systems;
2. one intrinsic parent tensor/operator producing both;
3. a generically corank-one mixed differential whose highest nonzero
   compound factors through the two polar directions;
4. complementary boundary contractions or rank strata; and
5. a restriction or degeneration compatible with the C705 identity.

Run the census in this dependency order.

1. **Ambient \(E_6\) lift.**  On Naruki's marked-cubic-surface space,
   identify the first-jet pairing of the two \(W(E_6)\)-equivariant
   contractions and test whether its restriction to every
   \(A_1\cong\overline M_{0,6}\) divisor is \(A\), up to the frozen
   determinant-line normalization.
2. **Coble cubic/sextic.**  Construct the mixed Jacobian of the dual Coble
   polar systems, determine its generic corank and minimal successful
   compound, and test whether the C705 factorization is a linear-section
   restriction.
3. **Weddle/Kummer sections.**  Restrict any Coble identity to the known
   genus-two special sections and decide whether this gives a new species
   or only inherited smaller shadows.
4. **Marked double-six.**  Compare its transpose-paired kernel systems
   with the sister criterion.  Record it as a sister only if a canonical
   mixed differential and compound factorization exist; otherwise classify
   the exact cousin relation.
5. **\(E_7/E_8\) extensions.**  Only after the preceding restriction maps
   are explicit, test Del Pezzo and Klein--McKay descendants for the same
   carrier/compound pattern.  Burkhardt and other modular varieties remain
   candidates, not presumed family members, until a paired carrier and
   parent operator are identified.

At every negative gate, record the first failed condition, the surviving
restriction, and the nearest positive relative.  The deliverable is a
rigid taxonomy—new sister, inherited shadow, elder parent, cousin, or
false analogy—not an unbounded catalogue of exceptional varieties.

The Coble gate is now closed with a revealing mixed verdict.  The
genus-two Coble cubic/sextic is the classical **elder dual parent**:
Nguyen's invariant \(P^4\) restriction is literally the
Segre-to-Igusa Gauss map, and the sextic restricts
scheme-theoretically as \(L^2I_4\).  It is not itself another sister
under the strict criterion.  At a general conormal pair its two Hessians
induce inverse second fundamental forms on the seven-dimensional
projective tangent spaces, so the canonical mixed differential has
corank zero.  More exactly, on the affine tangent cone,
\[
 BA(v)=\lambda v+d\lambda(v)x;
\]
the departure from a scalar is rank one, but its second factor is
\(d\lambda\), not the opposite polar line.  A smooth rational Burkhardt
witness has nonzero \(9\times9\) Coble-cubic Hessian determinant, closing
the ambient-corank escape.

The fixed-minus restriction is the nearest positive descendant.  Its
four quadrics give the classical double cover whose irreducible
ramification quartic is Weddle and whose branch quartic is Kummer.  The
homogeneous Jacobian has generic rank four and rank three on Weddle, so
its third compound is pointwise rank one; only the Kummer conormal is an
exceptional polar factor, while the other factor is the fold direction.
It is therefore an **inherited ramification shadow**, not an independent
sister.  Full report:
`notes/2026-07-30-c705-coble-mixed-jacobian.md`.

The final extra-juice pass exposed one higher-value local successor before
returning to \(E_8\).  Over \(\mathbf F_{101}\), all one hundred certified
conormal pairs satisfy
\[
 \nabla C_6(\nabla C_3(x))=\lambda(x)x,
\]
and at all ninety-seven samples with nonzero source Hessian,
\(\lambda/\det\operatorname{Hess}(C_3)\) is one constant.  The exact
characteristic-zero lift is now complete for the fixed rational Burkhardt
parameter.  If \(F=3G_\alpha\) and \(H\) is normalized by its first
Heisenberg-orbit coefficient, then
\[
 69984\,\nabla H(\nabla F)
 +\det\operatorname{Hess}(F)\,x=0\pmod F.
\]
Equivalently, the determinant-valued dual equation
\(\widehat H=-69984H\) has inverse-polar scalar exactly
\(\det\operatorname{Hess}(F)\).  Its scalar reduces to \(45\) modulo \(101\).
Full report and exact certificate:
`notes/2026-07-30-c705-coble-hessian-charzero.md`.

The common affine-\(E_8\) operator parent is now exact.  C682's paired
degree-ten return reconstructs the cubic Joubert tensor \(Z\), and
\[
 \mathscr P(x,\eta)=\langle\eta,Z(x)\rangle
\]
has mixed Hessian \(A\) with the two null projections \(q,W\).
Full report and certificate:
`notes/2026-07-30-c705-common-e8-parent.md`.

A genuine Lie-\(E_8\) route is feasible through the Vinberg grading
\(\mathfrak{sl}_9\oplus\bigwedge^3 9\oplus\bigwedge^6 9\): a stable
trivector constructs the Coble dual pair, whose fixed section is already
the Segre--Igusa pair.  The remaining strict gate is to match that
trivector's ordered Weierstrass marking to C704's frozen Joubert tensor.
Alternative attacks:
`notes/2026-07-30-c705-lie-e8-alt-attacks.md`.

## Mining subtask — Pauli-doily shadow

The \(S_6\cong\operatorname{Sp}_4(\mathbf F_2)\) dictionary is now exact:
the fifteen duads are the fifteen two-qubit Pauli points, synthemes are
commuting contexts, the ten \(3+3\) partitions are Mermin grids, and the six
stars are ovoids.  All ten Clebsch/Pfaffian grid parities equal \(-1\).

The first sign crown is negative and closed.  The Clebsch conference factor
in each context sign is point rephasing, and the \(K\)-diagonal triangle
tensor is an edge-cochain coboundary.  Thus unrestricted contextuality
cohomology does not see \(C\) or \(K\).  Full report and certificate:
`notes/2026-07-30-c705-clebsch-pauli-doily.md`.

The quotient nevertheless retains a finite exceptional sister structure.
It is Seymour's \(R_{10}\); its dual minimum blocks are duads while its
minimum blocks are synthemes, and together they form \(W_{10}\).  The
36 involutory exchanges are the exceptional outer involutions of \(S_6\).
The golden conference marking splits them into orbits \(6+30\), with the
small orbit canonically indexed by the six axes.  Direct frozen-sign
matching selects none; C708 now owns comparison with the actual polar
operator.

The nearest positive repair is C706's equivariant Clifford-lift gate.
Separate queued packages C707--C710 own the ETF/POVM, incidence-code,
Majorana, and \(E_8\)--Hamming questions; they do not enlarge C705's
acceptance gate.

## Required closeout

No first-gate closure is allowed.  Run distinct `ej1`, `tt1`, `ej2`, and
`tt2` passes, incorporating and retesting all in-scope leads between the
pairs.  A negative result must identify the minimal obstruction,
obstruction locus, nearest positive repair, converse content, propagation
law, and one adjacent crown.  The final report must contain a mystery
ledger and the complete reproducibility bundle required for any
paper-facing computational claim.

## Acceptance

A positive result is a coordinate-free trace/adjugate diagram for the
Segre gradient, with exact scalar and base locus.  A negative result is a
representation-theoretic obstruction after the full route family and
negative-yield protocol have been exhausted.

## Boundary

Do not sweep arbitrary quadratic functions of \(B_T\), enlarge to WP2's
marked double-six comparison, or make a novelty claim without the
proportional literature audit.
