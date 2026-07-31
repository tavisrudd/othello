# C711 — Paper III sub-700 golden-return human proofs

**Lane:** `clebsch`

**Status:** complete; reported 2026-07-31

**Result:** `notes/2026-07-31-c711-paper-iii-sub700-human-proofs.md` supplies
seven certificate-independent proofs, a claim-to-lemma map, the frozen C680
interface, and formalization-ready C712 statements.  All C691/C682 primary
checks and independent replays pass.  The extra-juice closeout strengthens
support recovery: after choosing complement duality and orientation, the full
middle-exterior return reconstructs the conference operator itself.  The
second extra-juice pass further proves that its family-preserving projective
stabilizer and line stabilizer are exactly \(A_5\) and \(S_5\), while Hodge
complementation enlarges the full line normalizer to \(S_5\times C_2\) and
couples with the outer character to give exact stabilizer \(S_5\).  The third
pass identifies \((*,K/5)\) with the split quaternion algebra
\((-1,5)\cong M_2(\mathbf Q)\), explaining the \(10+10\) golden split and
making conjugation inner.  The fourth pass computes the normalized and
primitive-return quaternion orders: their indices in \(M_2(\mathbf Z)\) are
\(20\) and \(500\), with Smith quotients
\(\mathbf Z/2\oplus\mathbf Z/10\) and
\(\mathbf Z/10\oplus\mathbf Z/50\).  Adjoining
\(t=(1+K/5)/2\) removes the \(2\)-primary defect and leaves index \(5\),
giving the exact staircase \(500\to20\to5\to1\).  The fifth pass identifies
the residual order as the level-\(5\) Iwahori preserving the unique ramified
golden eigenline; its quotient is the one-dimensional opposite-root space.
The DOF pass identifies the ten-dimensional Morita factor with
\(\mathbf1\oplus\mathbf4\oplus\mathbf5\), the module on complementary support
pairs, and isolates the remaining three scalar linearizations, the two
Iwahori endpoints, the general-base \(\mu_3\) ambiguity, and the raw
differential scale.  The Milnor--Serre pass realizes the Iwahori as the
endomorphism intersection of an index-five lattice edge and exhibits
an operator \(w\), satisfying \(w^2=5I\), that exchanges its endpoints; the
endpoint freedom is therefore only an orientation choice.
The second pass uses point--pair incidence to diagonalize the ten-point
Morita carrier with eigenvalues \(6,1,-2\), giving canonical projectors onto
the \(1,4,5\) channels and locating prime \(3\) in their integral separation.
The third pass proves by projective incidence that the exterior-cube kernel
over every field is exactly \(\mu_3(F)\), distinguishing field-valued
faithfulness in characteristic \(3\) from the nonreduced group-scheme kernel.
C712 is unblocked.

## Objective

Replace certificate dependence in the Paper III inputs sourced from C-items
below C700.  The owned mathematical inputs are C691's conference/orientation
cubic and C682's golden return, middle-exterior operator, distinguished support
lattice, and golden descent.  Produce a manuscript-ready human proof companion
whose lemmas can be formalized directly by C712.

## Required theorem package

1. Construct the signed order-six conference matrix (C) from the golden
   six-axis Gram data and prove its switching covariance and (C^2=5I).
2. Prove that the triangle products
   (c_{ijk}=C_{ij}C_{jk}C_{ki}) give the normalized Clebsch orientation cubic,
   including orientation reversal and descent to the augmentation five-space.
3. Prove the converse reconstruction of the conference switching class from
   the triangle tensor, using the four-point two-graph identity and pair
   balance rather than a switching-class enumeration.
4. For (K=*\Lambda^3C), prove (K^2=125I) and
   (K_{SS}=4C_{ij}C_{jk}C_{ki}), with all Hodge-star and complementary-minor
   signs fixed.
5. Prove that the distinguished integral support lattice is recovered from
   (K\bmod2) up to complement duality, so reading the cubic from the diagonal
   is intrinsic to the actual C682 return and not to a bare rational conjugacy
   class.
6. Give the human derivation from C682's paired degree-ten return to (C),
   including the exact scalar, golden conjugation, and rational paired-tower
   descent.  Computational artifacts may audit the scalar but may not be the
   proof.
7. State the precise interface exported to C680 and C712: definitions,
   normalization, hypotheses, coefficient rings, orientation choices, and
   bad-prime boundary.

## Inputs

- C691 and `notes/2026-07-29-c691-cubic-golden-compatibility.md`.
- C682 and its golden-descent reports, especially
  `notes/2026-07-30-c682-golden-e8-descent.md` and
  `notes/2026-07-30-c682-golden-e8-weyl-descent.md`.
- The existing exact C691/C682 checkers and certificates, used only as
  independent audits after the human arguments are written.

## Acceptance

- Every exported claim has a complete prose proof with no appeal to a search,
  interpolation grid, stored matrix equality, or certificate as the logical
  reason it holds.
- Every exact scalar is derived from a displayed normalization and checked by
  an independent exact replay.
- The report contains a claim-to-lemma table and a formalization-ready list of
  definitions and theorem statements for C712.
- A cold reader can recover why the golden return produces the cubic without
  opening a script or C682's chronological archive.
- The required `ej`+`tt` closeout and mystery ledger are complete before
  C711 is reported.

## Boundary

C711 owns only source results with C-IDs below C700.  It does not prove or
rewrite C704's Segre--Igusa, commutator-Pfaffian, cross-block, Cartan-restriction,
or syntheme results; human proofs for C704/C709 and later are owned by the
other active proof effort.  C695/C697 supply background terminology only:
their full twenty-seven-line and Hodge packages are outside Paper III and
create no C711 proof obligation.

C711 does not edit Lean.  Once its definitions and normalizations pass cold
read, C712 is the immediate successor.
