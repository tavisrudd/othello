# C704--C710 literature sweep before human proofs

**Lane:** `clebsch`

**Date:** 2026-07-31

**Scope:** C704, C705, C706, C708, C709, and C710.  C707 is queued and
therefore is not treated as a result.  This is a positioning and proof-audit
sweep, not a novelty or priority audit.

## Executive verdict

The recent Clebsch results divide cleanly into a literature-backed ambient
spine and task-owned exact operator statements.

* The Segre cubic, Igusa quartic, outer automorphism of \(S_6\),
  duad--syntheme geometry, Coble duality, Vinberg's
  \(\bigwedge^3 9\) model of \(E_8\), two-qubit Clifford group, doily,
  fermion-parity Pfaffian, and Hamming/McKay constructions are established
  background.
* The exact frozen formulas proved in C704--C710 are not imported from those
  sources.  They include the Joubert return from the conference operator,
  the adjugate factorization \(6Wq^{\mathsf T}\), the subgroup-specific
  splitting obstruction, the order-eight outer exchange and complete code
  tables, the commutator Majorana family with its cross-golden node
  stratification, and the negative/positive \(E_8\)-marking dichotomy.
* The June 2026 paper of Pokora--Szemberg is directly relevant to the
  classical Segre/Cremona--Richmond layer.  It gives a new residual
  construction of the Segre cubic and its fifteen-plane/duad--syntheme
  configuration.  It does not address the conference, Joubert, mixed
  adjugate, Clifford, Majorana, incidence-code, or marked-\(E_8\) operators
  used here.

The bounded sweep found no reason to retract or weaken any proved result.
It does require the human proofs to mark their interfaces explicitly:
classical identification first, task-owned normalization and calculation
second.  No statement below is a claim that the formulas are absent from
all literature.

## Result-by-result positioning

### C704 — functorial operator shadows

The literature supplies the outer \(S_6\) action on the six-point invariant
models, the signed Joubert covariant, the Segre cubic and its Igusa polar,
and the classical determinantal/small-resolution geometry.  Howard--
Millson--Snowden--Vakil and Kraft are the closest sources for the first two
ingredients; Dolgachev, Kondō, and Beckmann--Belmans supply the geometric
ambient layer.

The C704 contribution is the exact common-operator bridge:

\[
 \frac{\operatorname{diag}(*\!\bigwedge^3 C)}4=Z,
 \qquad
 \operatorname{Pf}[D_x,C]=4Z_C(x),
 \qquad
 \det[D_x,C]=16Z_C(x)^2,
\]

together with centered squaring as the Segre--Igusa polar map, the intrinsic
five-syntheme/Clebsch commuting diagram, and the cross-golden matrix
factorization and descent.  The human proof must therefore prove these
normalizations rather than cite only the classical varieties.

### C705 — adjugate, exceptional parents, and marking

The classical and modern spine is unusually rich: Segre--Igusa projective
duality; the two symmetric \(\overline M_{0,6}\) contractions; the
\(W(E_6)\) boundary model; Coble cubic/sextic duality; and the Vinberg
\(E_8\) grading.  Yoshida, Schock, Nguyen, Rains--Sam, Kondō, and
Beckmann--Belmans support those ambient statements.

The task-owned statements are the exact mixed-Jacobian identities and their
frozen markings: generic corank one with kernel lines \(q,W\),

\[
  \operatorname{adj}(A)=6Wq^{\mathsf T},
\]

the 70-dimensional third-compound span and unique outer five-space, the
bad-characteristic separation, the \(E_6\) first-normal jet, the
characteristic-zero Coble Hessian scalar, the affine-\(E_8\) mixed
potential, and the degree-\(6\)/degree-\(720\) Vinberg marking result.  The
human proof must keep the literature-backed existence of a parent separate
from each exact restriction, scalar, and monodromy calculation.

### C706 — equivariant Clifford lift

Kubischta--Teixeira classify all subgroups of the two-qubit Clifford group
that contain the Pauli group and record the full Clifford group of order
(11520).  This is the closest modern classification source.  It does not
perform the restriction/splitting calculation on the particular outer
\(S_6\), conference \(S_5\), and golden \(A_5\) actions used by C706.

C706 owns the nonsplitting of the full \(S_6\) extension, the two \(S_5\)
and four \(A_5\) complement classes, the conference twist that dies on
\(A_5\) but does not extend back to \(S_5\), the scalar-phase result, and
the six local \(S_5\) charts with pairwise \(S_4\) intersections but no
global gluing.  Its existing proof sections already contain the central
cocycle argument; the companion proof should make the remaining counting
and chart statements equally readable.

### C708 — doily codes and outer exchange

Muller--Saniga--Giorgetti--De Boutray--Holweck explicitly identify the
two-qubit doily with \(GQ(2,2)\cong W(3,2)\) and recall the
duad--syntheme/Cremona--Richmond model.  That supports the incidence
dictionary, not the C708 exchange matrix or code census.

C708 owns the order-eight frozen exchange, the \(36\) inner normalizations
and conference-selected golden six-pack, the \(F_{20}\) stabilizer and
twisted-conjugacy calculation, the \(D_{10}\) orbit fusion, and the complete
\(\mathbf F_2,\mathbf F_3,\mathbf F_5\) incidence-code tables.  The standard
binary \([[15,5,3]]_2\) CSS code is an output to identify, not a novelty
claim.  The important negative theorem is narrower: those code ranks do
not explain the three distinct bad-prime mechanisms in C705.

### C709 — six-Majorana lift

Grabsch--Cheipesh--Beenakker give the standard Pfaffian fermion-parity
formula for an antisymmetric Majorana Hamiltonian and explain parity change
at a zero crossing.  Landahl--Morrison give the graph-orientation/line-graph
dictionary for free-fermion subsystem Hamiltonians and the associated sign
freedom.  These sources validate the physical language used for the
antisymmetric matrix; they do not supply a Clebsch/Joubert conference
Hamiltonian.

C709 owns the split verdict: nontrivial \(K_6\) cycle flux survives diagonal
Majorana gauge, but no Pauli quadratic refinement or intrinsic spin
structure follows; total-order antisymmetrization is noncanonical; and the
canonical replacement

\[
 A_C(x)=[D_x,C]
\]

anticommutes with \(C\), exchanges its golden three-spaces, and has
Pfaffian \(4Z_C\).  The six cubic nodes are exactly its rank-two
cross-golden dimers, each with four Majorana zero modes.  The existing
human-proof companion covers this full chain.

### C710 — \(E_8\), Hamming, and the hyperbolic repair

McKay correspondence and Construction A from the extended binary Hamming
code are standard routes to \(E_8\); Suter is used here for the affine
Cartan/McKay side.  Rains--Sam supplies a separate Lie-\(E_8\) exceptional
ambient route relevant to C705, not the simultaneous rank-eight marking
asked for in C710.

C710 owns the explicit isometry between the frozen McKay quotient and the
Hamming model, including the affine root, and all three obstructions to a
simultaneous Clebsch marking: the \(180\) two-coordinate minors, the
\(S_6/S_5/A_5\) module test, and the absence of an \(E_8\) root subsystem in
\(Q_{10}\).  It also owns the exact positive replacement

\[
 L_{R_{10}}\oplus L_{R_{10}}^*\cong II_{10,10}
\]

and the recovery of the \(36\) self-adjoint isodualities.  The human proof
must present the three negative arguments independently before the
hyperbolic repair.

## Search boundary

The shared cache was verified before use (`344 entries, 0 problems` before
the final addition).  Searches then covered these bounded families:

* `Segre cubic adjugate Igusa mixed Hessian Coble Vinberg small resolution`;
* `two-qubit Clifford extension splitting Pauli doily CSS`;
* `R10 W10 E8 Hamming McKay Construction A II(10,10)`;
* `Majorana K6 Pfaffian parity Kasteleyn graph orientation`;
* `generalized quadrangle doily incidence codes W(3,2)`;
* 2025--2026 Segre, Pfaffian, Clifford, and Majorana updates.

The search used arXiv/author metadata and primary texts.  It did not close
citation graphs and did not cover MathSciNet, zbMATH, books without online
text, theses as a class, or non-English historical literature.  Formula
queries did not expose the exact frozen identities above, but under this
boundary that is only a positioning observation, never an absence or
priority claim.

## Sources and read depth

The first nine readings were already recorded during C704/C705 and are
inherited here; the remaining readings were performed in this sweep.  A
source marked `partial` was not read cover to cover.

* Howard--Millson--Snowden--Vakil, *A description of the outer
  automorphism of \(S_6\), and the invariants of six points in projective
  space*, arXiv:0710.5916 — `full text`; SHA-256
  `d2da258cd8513a9b782a8270baa82acc51bc8d552e18db104967c2a08bffebfc`.
* Hanspeter Kraft, *A Result of Hermite and Equations of Degree 5 and 6*,
  arXiv:math/0403323 — `partial`, Theorem B and §§2, 5; SHA-256
  `969440e0bedbc70fa9c2d97720407c9d7da821179aa5141b75b050a3c79afbec`.
* Shigeyuki Kondō, *The Segre cubic and Borcherds products*,
  arXiv:1110.1126 — `partial`, introduction and targeted §§2, 3, 6;
  SHA-256
  `0595df2ed7631ba366b1603aca9a924ef08cb93cdc84b906f2877b68c777e9be`.
* Masaaki Yoshida, *A \(W(E_6)\)-equivariant projective embedding of the
  moduli space of cubic surfaces*, arXiv:math/0002102 — `targeted full
  text`, §§2.2, 2.5, 3; SHA-256
  `1989e8d6349338045851d9d8428394ba7638689f903a1ebe1deffc78ab5485c5`.
* Nolan Schock, *The \(W(E_6)\)-invariant birational geometry of the moduli
  space of marked cubic surfaces*, arXiv:2309.15264 — `targeted full text`,
  introduction, Theorem 3.6, Remark 3.7; SHA-256
  `67c1f52c6df71abfb0a537aa55111929d05f812180070e891121d37440c896e5`.
* Quang Minh Nguyen, *Vector bundles, dualities, and classical geometry on
  a curve of genus two*, arXiv:math/0702724 — `partial`, abstract,
  introduction, and the Segre/Igusa restriction statements; SHA-256
  `93e0fb99b62a6b5f9c2229791b98b785e2946942e5946935ad7c4282311ab90b`.
* Eric M. Rains and Steven V. Sam, *Invariant theory of
  \(\bigwedge^3(9)\) and genus 2 curves*, arXiv:1702.04840 —
  `abstract/metadata`; SHA-256
  `4c46b1edef9252cae1917d9d4fbc91607ae792aafa895ccfae47d5b39dc56296`.
* Igor Dolgachev, *Corrado Segre and nodal cubic threefolds*,
  arXiv:1501.06432 — `targeted full text`, §§2--4; SHA-256
  `98a898303e06a395bad95888a826e677a955d4b8fc88914c6ede54e31406601e`.
* Shigeyuki Kondō, *Igusa quartic and Borcherds products*,
  arXiv:1406.2394 — `targeted full text`, introduction and Theorems
  8.9--8.10; SHA-256
  `5fc9f9a43827a81584f61e762d475f4ac98396b05af669ea417ce2a0649653c2`.
* Eric M. Rains and Steven V. Sam, *Vector bundles on genus 2 curves and
  trivectors*, arXiv:1605.04459 — `partial`, introduction, the displayed
  \(E_8\) grading, §5, Theorem 5.4 and following remarks; SHA-256
  `3550034bcb39e25b7631261cb72650d56839bc2ba411ba45cbcf71ec842d8613`.
* Thorsten Beckmann and Pieter Belmans, *Homological projective duality for
  the Segre cubic*, arXiv:2202.08601 — `partial`, introduction,
  Segre/Cremona--Richmond/Coble overview, and main duality framing;
  SHA-256
  `272f8bb917b42b9e0d63a05e87bc3e799e79208a65f329fb7aaafaae5b2f8cf8`.
* Eric Kubischta and Ian Teixeira, *Classification of the Subgroups of the
  Two-Qubit Clifford Group*, arXiv:2409.14624 — `partial`, introduction,
  background, and primitive entangling subgroup classification; SHA-256
  `fe363c337234b67343151f283e0b71664f06e4bd2889ffdc301d7461ebc71ef2`.
* Axel Muller, Metod Saniga, Alain Giorgetti, Henri De Boutray, and
  Frédéric Holweck, *Multi-qubit doilies: enumeration for all ranks and
  classification for ranks four and five*, arXiv:2206.03599 — `partial`,
  introduction and the duad--syntheme, Cremona--Richmond,
  \(GQ(2,2)\cong W(3,2)\) dictionary; SHA-256
  `a897add7b798f9c94d1ef8e540a9fa80fc58407c606601b7b218d2a3126fa5c9`.
* A. Grabsch, Y. Cheipesh, and C. W. J. Beenakker, *Pfaffian formula for
  fermion parity fluctuations in a superconductor and application to
  Majorana fusion detection*, arXiv:1903.11498 — `partial`, §§1--3, §6,
  Appendix A; SHA-256
  `5a437fbe55049c7c65c8b528dbc9a75bd92da64320da0d543f35300029631a13`.
* Andrew J. Landahl and Benjamin C. A. Morrison, *Free-Fermion Subsystem
  Codes*, arXiv:2201.07254 — `partial`, §II.A and its graph orientation,
  line-graph, and sign conventions; SHA-256
  `6f2cb7f9c6df639210189e2d67f20c4abf47cb6fe9d7ea46fafb58e428232958`.
* Ruedi Suter, *Quantum affine Cartan matrices, Poincaré series of binary
  polyhedral groups, and reflection representations*,
  arXiv:math/0503542 — `partial`, McKay/affine-Cartan setup and the binary
  icosahedral case; SHA-256
  `e47a79bb6132c84f58faf08aa84e7f0fcdc1feaf568a5e3242c90c293dd2c771`.
* Piotr Pokora and Tomasz Szemberg, *A Pascal-type construction of the
  Segre cubic and the Cremona--Richmond configuration*,
  arXiv:2606.18387 — `full text`; SHA-256
  `1d47430053479540c4c4a3f8386369647970e13bcc3c29cce6dfa9cc3eb01077`.

## Consequence for the human-proof pass

The proof companions should not attempt to reprove the general literature.
Each one should state the classical input in a short boundary paragraph,
then prove every task-owned implication from the frozen matrices,
polynomials, group actions, and lattices.  Computational enumeration may
serve as a certificate only after the reduction to a finite, explicitly
specified list has a human argument.  That is the standard applied in the
following C704--C710 human-proof sweep.
