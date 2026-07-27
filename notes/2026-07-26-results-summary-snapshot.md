# Portfolio results summary snapshot

**Date:** 2026-07-26

A self-contained summary of the major results of an ongoing programme in
finite geometry, coding theory, and combinatorial game theory. It is written
to be read on its own: every statement below is given with the hypotheses it
needs, and no external file is required to follow it.

Each section names the manuscript the results are destined for, or says that
they are not currently assigned to one. Several results are formally verified
in Lean 4; where that matters it is stated explicitly, and the boundary between
a human proof, a machine-checked proof, and an exhaustive finite verification
is stated rather than blurred. Nothing here has been published or externally
refereed.

The results are grouped as follows.

1. *Reconstructing the Clebsch code from its deep-hole syndrome locus* — how a
   six-point arc in the plane of order eleven is recovered from coarse decoding
   data.
2. *Quadratic recovery and cubic orientation in conic matching quotients* —
   what survives when a matching of conic points is restricted to the conic.
3. *Arithmetic and harmonic realizations of the Clebsch cubic* — two
   independent realizations of the same four-dimensional space.
4. *Arcs complete outside a conic: a prescribed-hole defect identity and
   matching-design rigidity*.
5. *Deep holes of projective Reed–Solomon codes beyond redundancy four: exact
   classifications at redundancies five through seven*.
6. *Complete Bounded Repair Ports: Transfer, Reliability, and Geometric
   Structure* — local memory and exact transfer of erasure repair.
7. *Local-Unitary Rigidity of Stabilizer AME States and Transversal Clifford
   Groups of MDS–CSS Codes* — every product-unitary intertwiner of a stabilizer
   absolutely maximally entangled state is local Clifford.
8. *Frobenius-equivariant pair extension and robust repair of eight-arcs* —
   extending Frobenius-invariant arcs by conjugate point pairs.
9. *Semilinear rigidity of four-point-frame continuation graphs* — an abstract
   graph that remembers its ambient plane.
10. *The Clebsch Schur--Sarkisov spine* — the conic deep-hole port
    Schur-generates the two outer Fano modules, while the conic-link code is
    their defect-two jet modification.
11. Two open programmes with substantial partial results: complete arcs of
    square-root size relative to a conic, and the outcome of the cap game on
    odd projective planes.

## *Reconstructing the Clebsch code from its deep-hole syndrome locus*

Let \(A\) be a \(k\)-arc in \(\operatorname{PG}(2,q)\) — a set of \(k\) points,
no three collinear. Its *uncovered locus* \(\mathcal U(A)\) is the set of points
outside \(A\) lying on no secant of \(A\). Under the arc/MDS dictionary, \(A\) is
the column set of a \([k,3,k-2]_q\) MDS code and \(\mathcal U(A)\) is its set of
deepest syndrome directions, so the results below say that coarse decoding data
determine a hidden projective configuration.

### Rigidity at \(q=11\)

For a six-arc \(A\subseteq\operatorname{PG}(2,11)\) the following are
equivalent: \(\mathcal U(A)\) lies on *some* conic; \(\mathcal U(A)\) is *all*
twelve \(\mathbb F_{11}\)-points of a nonsingular conic;
\(\#\mathcal U(A)\le15\); \(A\) is \(\operatorname{PGL}(3,11)\)-equivalent to
the Clebsch hexagon; and \(\operatorname{Stab}(A)\supseteq A_5\). The
icosahedral group is *recovered* from a purely coding-theoretic hypothesis
rather than assumed.

The phenomenon is rigid, not merely stable. Every non-Clebsch class has
projectively invariant nearest-conic discrepancy \(\delta\ge12\), the Clebsch
class is the unique zero, and each single-point perturbation \(U\) satisfies
\(\#(U\mathbin{\triangle}\mathcal C)\ge18\): the distance jumps from \(0\) to at
least \(18\) with nothing in between.

### Why eleven, without classification

For any \(\mathbb F_q\)-rational Clebsch hexagon \(H\),
\[
 |\mathcal U(H)|=q^2-14q+45,
\]
and for \(q\equiv3\pmod4\) every edge is a non-secant of Dye's associated conic,
so the off-conic excess is exactly \((q-4)(q-11)\). Within that congruence class
the conic is the whole uncovered locus exactly at \(q=11\).

Two synthetic replacements removed the census from the logical spine. The
\(q-5\) *line lemma* — every line carries at most \(q-5\) points of
\(\mathcal U(A)\) for a six-arc in odd characteristic — follows because the
fifteen chords properly \(5\)-edge-colour \(K_6\), hence one-factorize it; three
factor classes normalize to a triangular prism; and the two parallelism
conditions force \(a(b-1)=-1\) and \(a(b-1)=+1\) simultaneously. That bounds
\(|\mathcal U(A)|\le12\), which with Dye's bound \(c\le10\) forces \(c=10\) and
closes the degenerate line-pair branch. Separately the \(A_5\) orbit profile
\([6,10,12,15,30,30,30]\) is *derived* from fixed-point spectra and the subgroup
ledger; a second off-arc orbit would breach \(c\le15\), forcing \(c=10\) and
identifying \(\mathcal U\) with the unique orbit of size twelve — the conic.

### The classification through eight points

A universal chord-defect identity subsumes the earlier small-\(k\) counts. A
conic-filling uncovered locus forces an explicit quadratic field-size barrier
and \(q<\binom k2\); a passant count gives \(q\ge2k-3\); and Hirschfeld's
nucleus characterization excludes the even-order branch. The resulting
eight-point sieve leaves only \(q\in\{13,17,19\}\), and over each of those
fields the largest arc all of whose chords are passant to a fixed conic has
size six, so the necessary condition already fails at seven points. Hence for
\(4\le k\le8\),
\[
 \mathcal U(A)=\mathcal Q(\mathbb F_q)
 \iff (k,q)=(4,5)\ \text{or}\ (6,11),
\]
a projective four-frame in the first case and a Clebsch hexagon in the second.

A human cover theorem now supplies the window the searches used to supply. Let
\(\mathcal C\) be a nonsingular conic in \(\operatorname{PG}(2,q)\), \(q\) odd,
and \(A\) a \(k\)-arc disjoint from \(\mathcal C\) whose chords cover exactly
\(\operatorname{PG}(2,q)\setminus\mathcal C\). Then every chord is passant to
\(\mathcal C\) and
\[
 \binom k2\ge\frac{3(q-1)}2,
 \qquad
 q\le\frac{k(k-1)+3}3 .
\]
With \(q\ge2k-3\) this reconstructs the exact \(k=7,8\) terminal window and
identifies its two endpoint cases with minimum-weight supports of the
passant/internal incidence code. It does **not** exclude the five terminal
pairs — the \(q=13\) elliptic-scheme audit reaches only the integer bound
eight, one short — so the exhaustive terminal searches remain load-bearing.

### Arrangements, low-degree rigidity, and decoding

The fifteen Clebsch secants *are* the projectivized \(H_3\) icosahedral
mirrors, an equality of arrangements exhibited by an explicit
\(\mathbb F_{11}\) projectivity. The six fivefold points of the mirror
arrangement remain an arc in every characteristic but two, and the singularity
ledger \(6_5\,10_3\,15_2\) gives
\(\chi_{H_3}(t)=(t-1)(t-5)(t-9)\), hence projective complement \((q-5)(q-9)\).
Paired with the braid arrangement \(A_3\), whose complement is \((q-2)(q-3)\),
the two conic-size equations factor as \((q-4)(q-11)\) and \((q-1)(q-5)\),
isolating \(q=11\) and \(q=5\); the apparent \(q=4\) root is extraneous because
the \(H_3\) model is bad in characteristic two.

Clebsch is the unique class among the fifteen whose uncovered set lies on any
cubic: every non-Clebsch cubic evaluation matrix has full column rank ten,
while Clebsch has minimum degree two with a one-dimensional quadratic kernel.
This replaced a false predecessor — three other classes do have absolutely
irreducible loci at their minimum vanishing degree (a smooth quartic of genus
three, a quintic with one nonsplit node, a smooth sextic of genus ten), so
"unique class whose uncovered set is an irreducible curve's rational point set"
is wrong.

The complete syndrome-distance oracle is a four-case rule and the
nearest-codeword multiplicity distribution is exact. The twenty support triples
split into two complementary \(A_5\)-orbits of ten, but chirality is **not** the
coarsest equivariant rule: the stabilizer of an affine syndrome vector in the
order-600 monomial group has order five with four orbits of size five, so list
size five is the equivariant floor and is attained by four distinct decoders.
The two size-ten chirality decoders are the proper selections determined solely
by support, and form an unordered pair with no preferred orientation.

Side results: the dual code is again a Clebsch hexagon code (a self-duality
phenomenon, not coordinate-for-coordinate); the two icosahedral hexads are
*transverse* to \(S(5,6,12)\), so this is not a Golay/Mathieu phenomenon; and a
ten-arc with the same \(A_5\) symmetry has *empty* deep holes, so emptiness is
the generic behaviour under icosahedral symmetry and the hexagon is the
exception.

**Priority boundary.** The \(q=11\) six-arc itself is classical, with Edge
(1956), Blokhuis–Seress–Wilbrink (1992), and Korchmáros (1981) as prior names;
Dye (1991) supplies the ten-Brianchon bound and the \(A_5\) stabilizer; Calvo
(2024) owns the modern reflection-arrangement ledger; and Jurrius–Pellikaan
(2015) own the general arrangement-decoder mechanism. What is claimed here is
the exact covering \(\mathcal U(A)=\mathcal C(\mathbb F_{11})\) — each source
gives only the classical inclusion — together with the rigidity, gap,
low-degree, decoding, and through-eight-points statements.

The manuscript is split into a human core carrying the theorems and a separate
companion, *Computational strengthenings of Clebsch syndrome rigidity*,
carrying the fifteen-class, low-degree, cross-field and through-eight-points
classifications, each with its own replay routes.

## *Quadratic recovery and cubic orientation in conic matching quotients*

What remains of a pairing of marked conic points after the associated products
of secant equations are restricted to the conic.

### General quotient and the rank-three configurations

- For any perfect matching \(M\) of \(2m\) marked conic points, the product
  \(P_M\) of its secant equations has the same restriction to the conic for
  every \(M\). Hence
  \[
  \Phi_{M_0}(M)=\frac{P_M-P_{M_0}}{Q}
  \]
  defines an equivariant affine configuration in degree \(m-2\), independent
  of the reference matching up to translation. The four-endpoint Plücker
  switch gives the elementary divisibility mechanism.

- For the rank-three Coxeter configurations \(A_3,B_3,H_3\), the quotient
  configurations have exact ranks
  \[
  3,\qquad 6,\qquad 10.
  \]

- **The ranks are now proved conceptually, with no orbit row reduction.** One
  mechanism covers all three: the matching quotient is an affine connecting
  cocycle; its value span is stable under \(\operatorname{PGL}_2(q)\); the
  Fischer summands are defining-characteristic
  \(\operatorname{SL}_2(q)\)-modules; irreducibility forces every nonzero
  top-harmonic projection to fill its summand; and in even quotient degree one
  apolar trace detects the radial line. The \(H_3/\mathbb F_{11}\) containment,
  top harmonic summand, and rank ten follow from the same cocycle together with
  cyclic-Sylow cohomology and \(A_5\)-fixed spaces, leaving one scalar
  evaluation. The exact quotient matrices remain independent cross-checks
  rather than proof steps.

- Their arrangement complements have a uniform evaluation-code formula. For
  Coxeter number \(h\), under lattice-good reduction the code has parameters
  \[
  \bigl[(q-h/2)(q-h+1),\,3,\,(q-h/2-1)(q-h+1)\bigr]_q.
  \]
  At \(q=h+1\), the complement becomes the full rational conic. This gives the
  three phases
  \[
  (A_3,5),\qquad(B_3,7),\qquad(H_3,11),
  \]
  and the square of a Coxeter element generates the split maximal torus, with
  the two Legendre cosets as its moving orbits.

### Sheet recovery, cubic orientation, and profiles

- In the \(B_3\) and \(H_3\) cases, the two factorization sheets are
  intrinsically recoverable up to interchange: they are the unique
  complementary equal halves with matching first and second tensor moments.

- The signed moments vanish through degree two. Degree three is the first
  surviving signed moment, and its nonzero tensor transforms by the outer
  character. Thus the conic quotient first remembers orientation cubically.

- **Cubic survival is also conceptual now.** Both frozen configurations are
  reduced self-associated arithmetically Gorenstein sets of \(2q\) points, so
  quadratic recovery gives signed Gale self-duality and Cayley--Bacharach in
  degree two, and Hilbert symmetry then forces the cubic. A full-support
  hyperplane-square lemma shortens the dependency further, forcing the Schur
  cube directly and leaving the Gorenstein argument as a geometric consequence
  and independent check. The graded corollary is
  \(L^{\circ3}=\mathbb F_q^{\Omega_T}\), so the evaluation algebra saturates
  at degree three.

- In the \(H_3\) case, the mixed double-coset space
  \[
  A_4\backslash\mathrm{PGL}_2(11)/A_5
  \]
  has six labels in two \(1,4,6\) triples. Their depth profiles are
  \[
  v_1,v_4,v_6,-v_1,-v_4,-v_6,
  \qquad v_1+4v_4+6v_6=0.
  \]
  Although the profile map has rank two and a four-dimensional linear kernel,
  it separates all six labels. The singleton profiles recover the unordered
  matching pair; choosing a sheet recovers its decorated matching-table row.

- Modularly, the depth plane is
  \[
  P(1)^{A_4}/\operatorname{soc}P(1),
  \qquad \operatorname{Loewy}(P(1))=1\mid9\mid1.
  \]
  The primitive positive relation \(1:4:6\) is intrinsic. A separate
  relative-cubic construction produces a canonical Tate two-plane, but the
  two planes are provably not naturally identifiable: their labelled
  relations are \([2,8,1]\) and \([2,9,1]\).

### Arithmetic gluing

- The \(A_3\) orientation pair is inert over \(\mathbb F_5\) and fuses into
  one Frobenius orbit; the \(B_3\) and \(H_3\) pairs split over
  \(\mathbb F_7\) and \(\mathbb F_{11}\).

- In the golden case, the two \(A_5\) stabilizers meet in \(A_4\), generate
  \(\mathrm{PSL}_2(11)\), and are exchanged by the outer \(S_4/A_4\) hinge.
  The fixed-child 22-row model has the same free two-point orientation
  quotient.

### Why only two configurations occur

Let \(q\) be an odd prime power, \(G=\operatorname{PGL}_2(q)\),
\(G^+=\operatorname{PSL}_2(q)\), and let \(\Omega\) be any full \(G\)-orbit of
perfect matchings of \(\mathbb P^1(\mathbb F_q)\), with unital affine
evaluation space \(L\subseteq\mathbb F_q^\Omega\) in the conic-ideal quotient.
Suppose quadratic products intrinsically recover a nontrivial factorization
bipartition, meaning that \((L^{\circ2})^\perp\) is a line whose nonzero
vectors have exactly two level sets on \(\Omega\), and that the two fibres are
one-factorizations. Then the balanced setup is forced, and the only resulting
orbits are
\[
B_3/\mathbb F_7
\qquad\text{and}\qquad
H_3/\mathbb F_{11}.
\]
The one-factorization condition uses endpoint incidence rather than the
abstract quotient alone. The stronger trade-only strengthening is open and is
**not** claimed.

This is already a coherent standalone theorem sequence: conic divisibility,
exact ranks, sheet recovery, cubic orientation, profile reconstruction,
modular explanation, arithmetic gluing, and a completeness theorem naming the
two occurring configurations.

## *Arithmetic and harmonic realizations of the Clebsch cubic*

A short note proving two independent results on the same Clebsch four-space.
The wider inventory it was drawn from is larger than the note and is recorded
separately below.

### The two adopted theorems

- **Arithmetic.** Hitchin's degree-two incidence extension has rational square
  class \(5J_0\), restricts to the constant golden torsor on the principal open
  \(D(\sigma_3)\), and has an explicit golden fibre whose exchanger has
  nontrivial spinor class modulo \(11\). The rational incidence extension is
  \(\mathbf Q(\mathbf P(H_3))(\sqrt{5J_0})\) with \(J_0|_{V_I}=16\sigma_3^2\).

- **Harmonic.** The ten axes through opposite faces of an icosahedron give an
  exact \(A_5\)-equivariant embedding \(L:\mathbf R^{10}\to\mathcal H_6\),
  \(L(a)=\sum_e a_e P_6(u_e\cdot-)\). Its zonal Gram matrix is
  \[
  K=\tfrac1{243}\bigl(196I+47J-112A\bigr),
  \qquad G=K/13,
  \]
  with \(A\) the Petersen adjacency matrix, normalized Gram spectrum
  \(\tfrac{110}{1053},\tfrac{140}{1053},\tfrac{28}{1053}\), so \(L\) is
  injective. Labelling axes by two-subsets of five points, the Clebsch
  four-space is the Petersen \((-2)\)-eigenspace, disjoint pair labels are
  exactly the geometric Petersen adjacencies, and the normalized spherical
  cubic restricts to
  \[
  -\frac{784000}{1247103}\,\sigma_3.
  \]
  The factor \(13\) is an addition-theorem statement, not a patch: \(K\) is the
  reproducing kernel and \(G\) the normalized Gram matrix.

### What is not claimed

No canonical, arithmetic, or integral specialization relating these two
constructions to the finite matching tensor is claimed. The available finite
intertwiner is noncanonical, its irreducible scalings are independent, and no
common primitive lattice is defined, so sharing the four-space and the
polynomial \(\sigma_3\) is a common base object rather than a map between the
constructions. A genuine bridge would need a geometric correspondence, a
canonical normalization, and a primitive common lattice.

Two gaps are open in the current write-up and bound what may be asserted: the
inclusion of the Clebsch four-space into the seven-space of harmonic cubics is
used before it is defined, and the passage from the generic square class
\(K(\sqrt{cJ_0})\) to the residue algebra of the \(xyz\)-fibre lacks a local
comparison theorem, so \(c=5\) is not yet extracted at scheme level. Pullback
across \(\sigma_3=0\) and the all-degree face-axis channels are open beyond the
two retained theorems.

### The wider inventory of passages

The results below concern which later constructions retain the orientation bit
and which erase it. They are correct and available, but are **not** part of the
adopted note.

### Exact survival and loss

\[
\begin{array}{c|c}
\text{passage}&\text{information retained}\\ \hline
\text{unmarked conic child}&\text{no matching, parent, or orientation}\\
\text{first and second moments}&\text{unordered sheets}\\
\text{signed cubic}&\text{sheet orientation}\\
\text{singleton depth profile}&\text{decorated matching row}\\
\text{QR/Witt passage}&\text{a finite design/code shadow}\\
\text{theta signature}&\text{orientation erased}\\
\text{fixed-party quantum passage}&\text{orientation erased}\\
\text{ambient Fourier passage}&\text{a restricted shadow only}
\end{array}
\]

### Conditional mod-40 law

Under the frozen golden-marker hypotheses, splitting and fusion obey an exact
conditional mod-\(40\) law. Split-visible classes are
\[
11,19,21,29,
\]
split-fused classes are
\[
1,9,31,39,
\]
and the other eight unit classes are inert. Equivalently, existence is
controlled by \((5/\ell)\) and fusion by \((2/\ell)\).

### Four-sheet holonomy

- After quotienting constant sections, the fixed four-sheet section problem
  reduces to a \(9\times9\) operator built from two-matching holonomies.

- Generic extra sections occur only at
  \[
  z=2\quad\text{or}\quad w=\pm2/3,
  \]
  so the reduced rank-drop divisor is
  \[
  (z-2)(9z-4)=0.
  \]

- The axial locus has 96 relative frames; the two signed six-cycle loci have
  192 each. The exceptional-characteristic behavior at
  \(3,5,7,11,13,41\) is completely determined.

This detects two resonance values but does not reconstruct the pencil
parameter.

### Determinant-sign torsor

- The common two-valued object is
  \[
  T_q=\mathrm{PGL}_2(q)/\mathrm{PSL}_2(q).
  \]
  It is a free \(C_2\)-torsor with no equivariant section: comparing any two
  certified carriers requires exactly one marking bit.

- At \(q=7\) and \(q=11\), the silver and golden sheets realize \(T_q\); at
  \(q=5\), the two geometric lifts form one Frobenius orbit and there is no
  rational orientation bit.

- At \(q=11\), the matching sheets, fixed-child \(11+11\) quotient,
  determinant character, Čech readout, one-bit selector, design polarity,
  signed Fourier sectors, and Hadamard row-column swap are certified
  realizations of \(T_{11}\).

- The characteristic-zero golden object
  \(\operatorname{Spec}\mathbb Q(\sqrt5)\), with conjugation
  \(\phi\mapsto1-\phi\), reduces equivariantly to the roots \(4,8\) of
  \(T^2-T-1\) over \(\mathbb F_{11}\). This supplies a literal
  characteristic-zero-to-finite realization of the same torsor.

### Witt, Golay, Hadamard, and Mathieu shadow

- The quadratic-residue ternary span has the Golay-parameter weight
  distribution, and its minimum supports give the Witt design.

- Twelve full-support projective points have all 66 weight-five Witt points
  as their secant shadow.

- Parity extension yields the self-dual \([12,6,6]_3\) code and an order-12
  Hadamard matrix.

- The resulting \(S(5,6,12)\) has automorphism group \(M_{12}\). The two
  \(M_{11}\) parents meet in the frozen \(\mathrm{PSL}_2(11)\) and generate
  \(M_{12}\), while Hadamard row-column duality exchanges them by the forced
  outer automorphism.

### Further Clebsch results outside the current paper spines

- The integral Hadamard identities degenerate modulo three to an exact
  two-periodic complex:
  \[
  \ker H=\operatorname{im}H^{\mathsf T},\qquad
  \ker H^{\mathsf T}=\operatorname{im}H.
  \]
  The divided operator \(H/3\) is a canonical Bockstein inverse; its
  kernel/image is the extended ternary Golay code, and puncturing/shortening
  recovers the six-dimensional carrier and five-dimensional Lagrangian core.

- The modular carrier has a canonical nonsplit self-dual sandwich
  \[
  5\mid1\mid5^*
  \]
  at \(q=11\), with the \(3\mid1\mid3^*\) analogue at \(q=7\). The tempting
  identification with a genuine reduced Weil module is false.

- The golden six-arc has a unique \(\mathbb Q(\sqrt5)\)-split rational
  descent class with stabilizer \(S_3\); its degree-six resolvent is
  \(\mathbb Q(\sqrt5)^3\), intrinsically recovers
  \(\operatorname{Spec}\mathbb Q(\sqrt5)\), and has no rational section.
  Characteristic five gives a controlled degeneration to three ramified
  length-two points on a double conic line.

- Maximal quaternion orders reduce onto the frozen \(H_3\) and \(B_3\)
  sheets, with a single explicit characteristic-zero comparison matrix
  governing both golden reductions.

- The four golden companions form a canonical \(C_4\)-torsor whose square
  is the sheet involution. The \(A_3\) companion pair is the orientation
  torsor of an edge in the outer-\(S_6\) duad-syntheme-pentad geometry, with
  arithmetic model \(\mathbb Z[i]\).

- Golden-sheet existence, fusion, and Fourier phase are three distinct
  quadratic characters
  \[
  (5/q),\qquad(2/q),\qquad(-1/q).
  \]
  At \(q=31\) there is a certified simple first-order collision and a
  complete nonlift obstruction in the tested slice.

- The Klein cubic has exact local zeta and Newton data at \(31,41,61\),
  including ordinary versus supersingular behavior, a \(2+8\) root-orbit
  split, and saturated Weil bounds in the \(41\)- and \(61\)-towers. These
  zeta data do not detect the mod-\(40\) fusion bit.

- The two golden \(AME(6,11)\) states become equivalent after party
  permutation and also admit a fixed-party signed Fourier transport. Thus
  the quantum passage genuinely erases the geometric orientation; it is not
  an orientation detector.

- Several attractive identifications have been conclusively ruled out:
  theta parity does not distinguish the sheets; there is no permitted linear
  cubic carrier from the tested integral companion construction; the
  proposed small Weil-module and Adler/Klein five-space identifications fail;
  and the relative-cubic Tate plane is not naturally the modular depth plane.

Two further negatives delimit the inventory. The Klein cubic threefold's
intermediate Jacobian carries no two-dimensional \(G\)- or \(A_5\)-stable
arithmetic carrier of the kind that would realize the finite golden orientation
structure; and while the exact relative-commutant calculation for the
ten-dimensional rational Klein representation of \(\operatorname{PSL}_2(11)\)
is positive, its discriminant-five lift fails. The proposed degree-23
\(M_{23}\)/Golay coherence test is a future unity test, not a result.

## *Arcs complete outside a conic: a prescribed-hole defect identity and matching-design rigidity*

Let \(\mathcal C\) be a nonsingular conic in \(\operatorname{PG}(2,q)\) and let
\(A\) be a \(k\)-arc disjoint from it. Call \(A\) *complete outside*
\(\mathcal C\) when every point of
\(\operatorname{PG}(2,q)\setminus(A\cup\mathcal C)\) lies on a secant of \(A\),
and write \(\rho_{\mathcal C}(q)\) for the least size of such an arc. The
programme replaces a counting bound by an exact identity, then proves that its
equality case is rigid.

### The prescribed-hole defect identity

Counting incidences of the \(\binom k2\) secants against the prescribed hole
gives an exact defect identity, whose corollaries are the equality pattern, a
bound on the uncovered locus, and a quantitative stability statement. The
capacity lower bound it corrects yields the explicit additive asymptotic
\[
 \rho_{\mathcal C}(q)\ \ge\ \sqrt{2q}+\tfrac32-\frac8{\sqrt{2q}},
\]
stated as a concrete inequality rather than in \(O\)-notation, which is both
easier to formalize and a stronger claim.

Two structural bridges carry the weight. The *sharp evaluation dichotomy*: for
any feature map, hence every Veronese degree, a form vanishing on the uncovered
locus \(U\) and avoiding an arc \(A\) with \(|A|\le q\) exists exactly when the
span of \(\nu(U)\) is proper and contains no \(\nu(a)\). And the *arc /
codimension-three MDS syndrome dictionary*, under which relative completeness
*is* syndrome confinement and the defect identity *is* a weight-two
leader-collision identity.

### Exact values

\[
 \rho_{\mathcal C}(5)=4,\quad
 \rho_{\mathcal C}(8)=\rho_{\mathcal C}(9)=\rho_{\mathcal C}(11)=6,
\]
\[
 \rho_{\mathcal C}(13)=8,\quad
 \rho_{\mathcal C}(16)=9,\quad
 \rho_{\mathcal C}(17)=9,\quad
 \rho_{\mathcal C}(19)=10 .
\]
The value at \(q=16\) rests on an exhaustive projective classification proving
that no eight-point arc is complete outside any nonsingular conic; it
independently reproduces the known 2633 ordinary eight-arc classes, then refines
them into 2630 full-rank and 3 forced-hit quadratic-avoidance rejections.

That classification has since been compressed almost to nothing. For 2630 of
the 2633 leaves the ordinary-uncovered locus contains three distinct collinear
points on a line \(L\) together with three noncollinear points off \(L\); a
quadratic through the first triple must contain \(L\) as a component, since its
restriction to \(L\cong\mathbf P^1\) has degree two and three distinct zeros,
and the residual linear factor would then have to contain three noncollinear
points. So those six points impose independent conditions on quadratics with no
matrix inversion. Exactly three leaves lack the pattern and retain
one-dimensional quadratic kernels. The same elementary conic obstruction
reduces the exhaustive lower-bound checks at \(q=13,17,19\) in every case but a
single nine-arc at \(q=19\), whose uncovered locus is a pair of regular orbits
of a projective Heisenberg group \(C_3^2\) lying on distinct cubics of one
semi-invariant pencil, with its nine nearest conics forming one group orbit.

### Zero defect is rigid

The concurrence points of an arc canonically decompose the edges of the Kneser
graph \(KG(k,2)\) into matching cliques. Equality in the defect identity forces
those cliques to form a simple maximum-matching design represented by secant
concurrence in one projective plane; a second index equation then determines the
exact number of maximum-index centres and their incidence with every secant. At
defect \(\Delta\), at most \(m(m-1)\Delta/2\) Kneser edges lie in nonmaximum
cliques. The six-point realization is classified projectively, and for every
even \(k\ge6\), zero relative defect forces
\[
 q\in\{k-2,\ \tbinom{k-1}2,\ \tbinom{k-1}2+1\}.
\]

Sharper still: the maximum concurrence centres form a packing by
maximum-matching cliques, and the defect is at least the number of blocks by
which the packing falls short of a full matching design. A packing cannot be
exactly one block short — its leave is forced to be the missing maximum
matching — so abstract nonexistence of \(\operatorname{MATCH}(k,\lfloor
k/2\rfloor,1)\) gives the quantitative gap \(\Delta\ge2\).

The even branch is now closed by a congruence rather than a search. The sole
non-hyperoval characteristic-two zero-defect candidate is \((q,k)=(4096,92)\),
and it is impossible: conic polarity turns the 92 arc points into distinct
involutions stabilizing one 91-point subset of the conic; either tangent pair
generates a four-group fixing exactly its contact point; so the remaining 90
points would have to split into four-element orbits, and \(90\not\equiv0\pmod4\).

### The prescribed hole answers a question already asked

Taking the hole to be a line at infinity specializes the framework to complete
affine arcs: completeness outside \(L_\infty\) is exactly maximality of \(A\) as
an arc in the affine plane obtained by deleting that line, every secant meets a
disjoint line once so the incidence count is \(\binom k2\), and substitution
into the general inequality gives a complete affine bound with the zero-defect
theorem supplying the equality pattern at affine and ideal points alike. That
instance sits inside an existing research line — hyperfocused arcs and their
secret-sharing origin (Giulietti–Montanucci; Korchmáros–Szőnyi, who state
explicitly that some such constructions are complete in exactly this sense).
The boundary is narrow and stated as such: this shows the *line-hole instance*
was previously asked for, not that the conic parameter itself was.

Exact reconstruction of the arc from its ordinary uncovered locus,
semilinear-stabilizer recovery, the matching-design theorem, the equality
consequences, and the stability bound are all formally verified.

### Four routes that do not replace the finite classification

The exhaustive \(q=16\) eight-arc classification has resisted four independent
attempts at a structural replacement, and the failures are informative.

- Recasting the quadratic-evaluation obstruction intrinsically gives an exact
  field-uniform Hilbert/separator form, but that form does not force the
  \(q=16\) conclusion.
- A low-weight projective Reed–Muller route fails on a type distinction:
  complete linear factorization and sevenfold arc-point vanishing are properties
  of a *polynomial representative*, not of its codeword — the relevant
  evaluation fibre has dimension 168 — and conic support is abundant in the
  degree-28 code in any case.
- A Rédei-quotient projection from an uncovered conic point exposes a sharp
  local identity whose last branch is genuine rather than spurious: an exact
  \(\operatorname{GF}(16)\) arc satisfies the required divisibility on seven of
  its eight labelled fibres simultaneously, so neither a one-fibre nor a
  seven-fibre argument can force the second conic point to remain uncovered.
- Coupling the eight centre involutions across every uncovered conic point makes
  the condition much stronger — no simultaneous multi-base survivor exists among
  2,291,362 checked arc–conic pairs — but the pure involution-boundary data
  admit exact counterexamples, so the exclusion still has no proof independent
  of the classified list.

These attempts did produce a sharp finite target: every non-relative
arc–conic pair with at least six ordinary holes has at least six off-conic holes
visible on its fibres, with equality realized by two collinear triples on a
split quadratic meeting the arc once on each component. A classification-free
proof of that six-hole stability statement is the remaining route.

## *Deep holes of projective Reed–Solomon codes beyond redundancy four: exact classifications at redundancies five through seven*

A projective Reed–Solomon code is the evaluation code of polynomials of bounded
degree on the rational normal curve. Its *covering radius* and the geometry of
its deepest syndromes are classical open questions; the results below classify
them exactly at redundancies three, five, six, and seven, and give a uniform
high-field containment theorem at arbitrary redundancy. They do **not** prove
the general Reed–Solomon deep-hole conjecture.

### Redundancy three — all fields

Balanced four-cycle determinant monomials generate the full edge-torus
invariant quotient and reconstruct every rank-two syndrome from support size at
least five. The unique structural contraction is the rank-one/conic locus: all
raw balanced atlases coincide there, and the missing datum is exactly the
radical point outside the support. The atlas is the Plücker presentation of a
projected labelled sextic, hence a point of \(M_{0,6}\). Four abstract coherent
projections leave exactly a two-sheeted parent cover whose deck involution is
Gale association, and extra abstract projections cannot choose a sheet. Keeping
the literal complete child restores much more: it determines the unlabelled
six-arc for every \(q\ge16\) and every \(q=13\) fibre, with only the empty-child
and \(q=7\) two-point conic-complement failures. On a normalized chart the
residual kernel cubic factors as \(st(L_0s+L_1t)\), where \(L_1=0\) is the conic
branch divisor in every characteristic and \(L_0=0\) is the arc-boundary
collinearity — this factorization is what identifies the involution as Gale
association rather than merely observing a numerical double cover.

The nontrivial small-field recovery census is exact:
\((q,|L|,\#\text{parents},\text{min centres})\) takes the values
\((8,4,10,3)\), \((9,6,8,3)\), \((9,7,2,2)\), \((9,8,4,2)\), \((9,8,2,2)\),
\((11,12,22,3)\); every other nonempty residual fibre through \(q=13\) is a
singleton. The \(q=7\) two-point child is maximally nonrigid: all 294 literal
parents share one coherent signature even after both centres are used.

**Semilinear descent.** All gauges, compatibility equations, residual cubics,
Gale transforms, branch divisors, and complete-child cuts commute with
Frobenius. Off the conic divisor the only geometric descent obstruction is the
Gale \(C_2\) class — a Kummer square class in odd characteristic, an
Artin–Schreier trace bit in characteristic two. If \(H\) is the common diagonal
stabilizer, an unlabelled sheet descends exactly when the Frobenius bit lies in
the image of \(H\to C_2\); surjectivity identifies the sheets and destroys
uniqueness. Extension degree \(m\) multiplies the bit, so odd extensions
preserve it and even extensions split it. The exceptional \(q=8\) colour
collapse is a separate lossy \(C_3\) quotient, not a Gale obstruction.

### Redundancy five — complete all-field classification

For every prime power \(q\ge7\), \(\rho(\mathrm{PRS}(q-4))=4\). A syndrome is
deep exactly when its Hankel-kernel pencil contains no totally split squarefree
cubic. The full projective-semilinear classification consists of tangent,
conjugate-secant, tame osculating-pair, and characteristic-three nucleus/wild
Artin–Schreier families, with point counts \(q(q+1)\), \(q(q+1)(q-1)/2\),
\(q(q+1)/2\) when \(q\equiv2\pmod3\), and \(q(q-1)/2\) when \(q\equiv1\pmod3\);
in characteristic three there is also the common nucleus and one wild orbit of
size \((q^2-1)/2\) with stabilizer \(2q\). The tame criterion is Frobenius
twisting of the cyclic cubic deck transformation; the wild criterion is
irrational kernel for \(z\mapsto z^3+az\). In the geometrically \(S_3\) case the
off-diagonal fibre square is an absolutely irreducible \((2,2)\) curve of
arithmetic genus one; Aubry–Perret gives at least \(q-2\sqrt q\) rational
points, and after removing the diagonal and branch budget no sporadic orbit
survives above \(q=19\).

The complete sporadic census, grouped by branch divisor: fully split
equianharmonic tetrads (\(j=0\), stabilizer \(A_4\)) with \(q=7,13,19\) orbit
sizes \(28,182,570\); fully split non-equianharmonic tetrads (stabilizer
\(V_4\)) with \(q=9,11,13,17\) orbit sizes \(180,330,546,1224\); branch type
\(1+1+2\) (stabilizer \(C_2\)) with two size-168 orbits at \(q=7\), three
size-252 orbits at \(q=8\), two size-360 orbits at \(q=9\), one size-660 orbit
at \(q=11\); cuspidal type \(2+1+1\) with one size-168 orbit at \(q=7\); and
type \(1+3\) (stabilizer \(C_3\)) with one size-112 orbit at \(q=7\). The three
\(q=8\) size-252 orbits form a free \(\operatorname{Gal}(\mathbb F_8/\mathbb
F_2)\) torsor and fuse semilinearly. The \(A_4\) cases are exactly the
binary-quartic \(I=0\) locus.

### Redundancy six — all-field existence and orbit counts

For every \(q\ge7\), \(\rho(\mathrm{PRS}(q-5))=5\). Deepness is equivalent to a
Hankel-kernel net of quartics containing no totally split squarefree quartic.
The persistent tangent/conjugate-secant stratum has exactly \(q(q+1)^2/2\)
points and an explicit norm-one-torus orbit law. The remaining trivial-gcd
exceptions occur only at \(q=7,8,9,11,13\), together with one
characteristic-two nucleus orbit over \(\mathbb F_{2^m}\) for odd \(m\ge5\); all
are exhaustively certified. On an irreducible-quadratic fibre the stabilizer
acts on the norm-one torus by \(z\mapsto z^5\) and inversion: one orbit if
\(5\nmid q+1\), and three, with stabilizers \(10,5,5\), if \(5\mid q+1\). The
large-field proof contracts along the first-polar line to the redundancy-five
cubic-pencil theorem and bounds the secant, tame-cyclic, and ramification losses
separately by \(3\), \(4\), and \(6\). The exact trivial-gcd orbit counts at
\(q=7,8,9,11,13\) are \(18,11,4,2,1\) and there are no others; at \(q=11\) one
exceptional net is the collision-line configuration whose six lines exhaust the
twelve rational points of the relevant conic, and the other has normal form
\(\langle u,tu,u^2+5\rangle\) with \(u=t^2-2\), all fifteen split-quadratic
factor candidates sharing a root.

### Redundancy seven — complete all-field classification

The first-polar contraction reduces the problem to redundancy six. The
persistent stratum again has \(q(q+1)^2/2\) points, with an exact
\(T/T^6\)-mod-inversion-and-Frobenius orbit law. For every prime power
\(q\ge13\) these are all deep syndrome directions except for a single central
characteristic-two point when \(q=2^m\) with \(m\) odd. With
\(d=\gcd(6,q+1)\), inversion-fixed torus classes have
\((|O|,|\mathrm{Stab}|)=(q(q^2-1)/(2d),2d)\) and paired classes
\((q(q^2-1)/d,d)\), with Frobenius acting by multiplication by the defining
prime on \(C_d\). The high-field stop is quantitative: pointed genus-one
splitting plus a bidegree union bound and an at-most-eight ramification locus
leave an exceptional budget \(3+8+1=12<q+1\).

An exact marked-polar calibration closes every field below 37 without scanning
all of \(\mathbf P^6(\mathbb F_q)\). Exceptional deep orbits occur **exactly**
at \(q=7,8,9,11\), with \(\operatorname{PGL}_2\) orbit-size profiles
\(56^1,84^5,112^2,168^{45},336^{141}\) at \(q=7\);
\(63^1,72^1,84^3,168^4,252^{24},504^{86}\) at \(q=8\);
\(180^3,240^6,360^{18},720^{27}\) at \(q=9\); and \(264^2,440^1,660^2\) at
\(q=11\). A structurally independent replay tests every representative directly
against all five-point spans of the sextic rational normal curve, rebuilds its
full orbit and stabilizer, and reconstructs the semilinear cycles. What remains
open is conceptual compression of those four small-field profiles, not
classification.

One transient locus matters to the induction even though it contributes no deep
sextic. At \(q=19\) the pointed-bad contraction locus has one excess affine
orbit of size 19, represented by \(e_2=(0,0,1,0,0,0)\) with quartic net
\(W=\langle1,t^3,t^4\rangle\). It has exactly six split squarefree members, all
cubics completed by infinity, and no member with four finite roots; hence it is
pointed-bad but not redundancy-six deep, and no coherently parameterized sextic
polar line can remain inside it. This is the sharp falsifier for any induction
classifying bad fibres separately rather than bad polar flags. The numerical
discrepancy is settled; why it occurs specifically at \(q=19\), and whether it
relates to the equianharmonic \(q=19\) cubic-pencil orbit, is open.

### Arbitrary redundancy — coherent polar containment

Iterated contractions must retain every removed root as a forbidden marker;
classifying bad fibres independently loses exactly the information needed to
lift squarefree witnesses. With coherent polar flags in place, a
catalecticant-rowspace reduction and an integral Grassmannian calculation show
that every recursively pointed contained component is persistent or modular.
Consequently every split-free syndrome at redundancy \(r\) lies in those loci
once
\[
 q\ \ge\ 6r-15+\bigl\lfloor2\sqrt{6r-17}\bigr\rfloor .
\]
This is a uniform high-field containment theorem, not a general solution of the
Reed–Solomon deep-hole conjecture.

The methods combine exact invariant theory, Plücker inversion, Gale duality,
catalecticants and apolarity, finite-group descent, low-genus point bounds, and
independently replayed bounded classifications.

## *Complete Bounded Repair Ports: Transfer, Reliability, and Geometric Structure*

The organizing object is the complete radius-\(r\) repair port at a target
coordinate: every dual-word repair using at most \(r\) helpers, retaining
three distinct layers—support sets, normalized scalar recovery coefficients,
and failure probabilities.

### General MDS local reconstruction

Let \(C\le\mathbf F^E\) be an \([n,k]\) MDS code with \(k>0\), let \(x\in E\),
and normalize every dual repair word \(y\in C^\perp\) by \(y_x=1\). The
radius-\(r\) *coefficient port* is
\[
 \mathcal P_x^{\le r}(C)
 =\{y\in C^\perp:\ y_x=1,\ |\operatorname{supp}(y)\setminus\{x\}|\le r\}.
\]
It *reconstructs* at radius \(r\) when its linear span is \(C^\perp\); the
reconstruction radius \(\rho_x(C)\) is the least such \(r\), or infinity when
none exists. Using \(\dim C^\perp=n-k\) and \(d(C^\perp)=k+1\),
\[
 \operatorname{span}\mathcal P_x^{\le k}(C)=C^\perp,
 \qquad
 \rho_x(C)=k,
\]
and the support projection is the complete \(k\)-uniform clutter. Retaining the
coefficients rather than only the supports is what makes the port remember the
code: the Clebsch \([6,3,4]_{11}\) code's full radius-five coefficient port
reconstructs its inner code from a single pointed port, while its support-only
clutter is the generic complete three-uniform hypergraph on five helpers.

This theorem, the reconstruction radius, and the support/coefficient bridge are
formally verified.

### Exact transfer and confinement

- Complete bounded repair hypergraphs transfer exactly through concatenation
  when
  \[
  r+1<2d(I^\perp)
  \]
  and the outer functional-dual distance is at least \(r+2\). This preserves
  the entire bounded support hypergraph, not just the existence of a locality
  witness. Consequently it preserves exact locality, matching number
  \(\nu\), transversal number \(\tau\), and every other support-hypergraph
  invariant within the admitted radius.

- A stronger weighted-functional theorem replaces ordinary functional
  distance by the exact cost of realizing each outer functional in the inner
  coefficient fibres.

- The exact obstruction threshold separates three sources of low-weight
  nonembedded dual words: zero-functional multiblock words,
  singleton-functional words, and genuine multisupport-functional words.
  Under coordinate-surjective projections the singleton stratum disappears,
  and the global threshold becomes
  \[
  \min\bigl(2d(I^\perp),d_\lambda(O)\bigr).
  \]

- There is also an exact pointed confinement profile. It measures,
  coordinate by coordinate, the least nonembedded dual witness that could
  introduce a new repair at that target. Falling below this cost gives
  equality of the complete pointed repair ports.

- Both numerical transfer gates are uniformly sharp: explicit nondegenerate
  \(GF(3)\) examples produce literal repair-hypergraph failure at
  \[
  r+1=2d(I^\perp)
  \]
  and when the outer functional-dual distance falls to \(r+1\). This is a
  uniform non-weakenability result, not a necessity theorem for each fixed
  concatenation.

- A finite-separable trace theorem converts ordinary extension-field dual
  distance into the functional-dual condition while preserving exact
  support.

### Prescribed positive-density ports

- Every fixed represented radius-\(r\) port satisfying
  \[
  r+1<z_x(I)
  \]
  occurs with density \(1/m\) in an asymptotically good fixed-alphabet
  concatenated family, where \(m\) is the inner length. The inequality is
  also the exact eventual confinement condition for the selected pointed
  port.

- Thus the construction transports an entire prescribed local object—support
  sets and coefficient fibres—not merely a locality number.

- For the Clebsch \([6,3,4]_{11}\) code, the full radius-five coefficient
  port has \(z_x=8\), reconstructs the inner code from a single pointed port,
  and occurs with density \(1/6\) in an asymptotically good fixed-
  \(\mathbb F_{11}\) family. Its support-only clutter is the generic complete
  three-uniform hypergraph on five helpers, with
  \[
  (\nu,\tau)=(1,3);
  \]
  the coefficient layer is what retains the specific inner code.

### Cubic-axis family

In finite characteristic three, the axis-twisted-cubic construction gives a
uniform family with unusually explicit repair geometry.

- The code has parameters
  \[
  [2q+1,4,q-1]_q.
  \]

- Its small circuits are completely classified: axis triples and unique
  three-cubic/one-axis completions. Axis coordinates have exact locality two;
  cubic coordinates have exact locality three.

- Every cubic coordinate has
  \[
  (\nu,\tau)=\left(\frac{q-1}{2},q-2\right).
  \]
  The matching lower bound is constructive, using a shifted-inverse identity
  and a rainbow perfect matching.

- For \(q\ge9\), every coordinate satisfies the strict separation
  \[
  \tau>\nu.
  \]

- At \(q=9\), the three coordinate types have exact rows
  \[
  (4,7),\qquad(6,12),\qquad(7,13),
  \]
  with multiplicities \(9,9,1\) and minimal-repair counts
  \[
  28,\qquad36+8,\qquad36+12.
  \]
  The complete small-circuit inventory contains 120 axis triples and 84
  completed cubic quadruples. Every coordinate satisfies
  \(7\nu\le4\tau\), with equality on cubic coordinates.

- Projectively completing the seed gives
  \[
  [2q+2,4,q]_q
  \]
  with dual distance three. Radius four exhausts the complete minimal inner
  port. The exact rows become
  \[
  \left(\frac{q-1}{2},q-1\right)
  \]
  at cubic targets and
  \[
  \left(\frac{5q-3}{6},2q-3\right)
  \]
  at axis targets.

- Every repair witness supplies an exact normalized scalar recovery equation.
  The completed seed's three locality shapes have explicit nonzero
  coefficient formulas. A monomial-rescaling theorem shows that
  coefficient-cost claims are gauge-dependent unless the normalization is
  specified. These are direct one-symbol-per-helper scalar protocols, not
  minimum-bandwidth or minimum-access results under subpacketization.

### Fixed-alphabet asymptotic families

- The degree-four \(q=9\) lift has parameters
  \[
  [19N,4K,\ge8D]_9,
  \]
  coordinate multiplicities \(9N,9N,N\), exact locality three/two,
  transferred repair rows, and failure thresholds \(6,11,12\).

- This gives an unbounded \(GF(9)\) family of exact rate
  \[
  \frac{2}{19}
  \]
  and every eventual relative-distance bound
  \[
  c<\frac{39}{190}.
  \]
  A clean \(1/5\) lower bound follows immediately.

- The completed lift has
  \[
  [20N,4K,\ge9D]_9,
  \]
  an exact \(10N/10N\) coordinate split, exact locality three/two, and
  radius-four rows \((4,8)\) and \((7,15)\).

- Its unbounded family has exact rate
  \[
  \frac1{10}
  \]
  and every eventual relative-distance bound
  \[
  c<\frac{351}{1600},
  \]
  again with a clean \(1/5\) consequence.

The only nonformalized asymptotic input is the precisely isolated
Stichtenoth self-dual TVZ theorem.

### Reliability, EXIT, and pointed Tutte structure

- Complete-port reliability satisfies deletion-contraction,
  pivotal-influence formulas, Russo-Margulis differentiation, and a
  high-survival expansion governed by minimum blockers.

- Radius-truncated extrinsic BEC failure has its own erasure-sign
  deletion-contraction calculus. Successive truncation radii give the
  distribution of the cheapest available repair. At full radius this is
  symbol-MAP failure; finite radius describes a bounded-query decoder and
  carries no EXIT-area capacity claim.

- Full repair reliability is a specialization of the Las Vergnas polynomial
  of the matroid perspective
  \[
  M\backslash x\longrightarrow M/x.
  \]
  Pointed duality exchanges repair and failure.

- The standard pointed polynomial forgets the repair-radius filtration.
  Exact \(q=9\) coefficient differences demonstrate that two targets can
  agree at the full-polynomial level while differing at bounded radius.

### Quartic-nucleus and harmonic family

- A quartic normal rational curve with its nucleus gives
  \[
  [q+2,5,q-3]_q
  \]
  with dual distance five. Its radius-four circuits are exactly the blocks
  of the harmonic Steiner system
  \[
  S(3,4,q+1).
  \]

- At \(q=9\), the nucleus has row \((2,5)\), while a curve target has
  \((1,1)\).

- The reliability mechanisms differ sharply. The nucleus has a sparse
  Poisson repair window; a curve target has a compulsory-helper series
  bottleneck.

- Harmonic radius-four circuit closure obeys an exact nucleus-gate law. At
  \(q=9\), a block-free rank-five curve set spans linearly but is inert under
  bounded circuit closure; adjoining the nucleus completes the missing curve
  points in one round.

- For the harmonic \([11,5,6]_9\) code, the radius-four EXIT deficits are
  \[
  \frac{2}{77},\qquad\frac{23}{154},
  \]
  with corrected total area \(502/77\). The nucleus and derived-design
  Poisson errors are respectively
  \[
  O(n^{-1/4}),\qquad O(n^{-1/3}).
  \]

### Material outside the current manuscript

The paper deliberately omits sequential-composition semantics, general service
regions, coefficient optimization, the log-concavity history, product
constructions, generic tract/foundation exposition, and an optional
blocker-stability strengthening. The formal library also contains a
\([10,4,6]_9\) seed with dual distance four that the manuscript does not use.

The admission rule for the main proof spine is deliberately strict: a result
enters the body only with an exact stable statement, a complete human proof
exposing the mechanism, a matching formal declaration, a field-by-field
adequacy check, an axiom audit naming every imported classical input, and **no
computation or certificate anywhere in its logical dependency chain**.
Computations, finite tables, and certificates support appendices but may not
carry a body theorem. The general MDS reconstruction theorem above is what the
revised spine leads with.

### Related negatives

Three bounded negatives delimit the theory. Naive same-radius
deletion–contraction fails: deletion removes a repairable relay while
contraction admits an over-budget lifted circuit, with two explicit binary
witnesses. There is no finite transfer alphabet bounded by radius and interface
width — binary triangle relays at radius two and width two have pairwise
distinct first-finite-response times, and the proof discards the counts
entirely, so it is strictly stronger than "the counts are unbounded"; that
obstruction is purely a timing artifact, and forgetting arrival times restores
a finite structural control algebra. And on the cryptographic side, both
\(GF(9)\) holonomy classes are ordinary multiplicative but not strongly
multiplicative for every dealer, because the criterion factors through the
quadratic Veronese matroid and is uniformly \(U(3,4)\) — blind to cross-ratio,
so no realization can fix it.

Two claims were withdrawn rather than weakened. Universal log-concavity of the
pointed profile is refuted by an explicit simple rank-five binary seven-column
counterexample; and a narrower representable-matroid form, retained after
30,638 exhaustively enumerated pointed types passed, was then killed by an
infinite regular-graphic series-parallel counterexample family whose smallest
member has 14 helper edges (all 185,701 profiles through 13 edges pass). Series
composition survives as the positive island. Separately, the functional-cost
parameter is definitionally the classical coset-leader/syndrome weight, and a
rescaling theorem shows raw coefficient values are arbitrary coordinate gauge,
so no minimum-access or minimum-bandwidth claim follows from them.

The manuscript is assembled and has survived several independent readings. Its
remaining obstacles are specialist citation review and publication
infrastructure, not missing central mathematics.

## *Local-Unitary Rigidity of Stabilizer AME States and Transversal Clifford Groups of MDS–CSS Codes*

A pure state of \(2m\) parties, each of local dimension \(q\), is *absolutely
maximally entangled* when every \(m\)-party marginal is maximally mixed. Two
such states are *LU-equivalent* when a product of local unitaries carries one
to the other, and *LC-equivalent* when that product may be taken to consist of
Clifford unitaries. The question is when the weaker relation collapses onto the
stronger one.

### The general rigidity theorem

Let \(C\) be a linear \([2m,m,m+1]_q\) MDS code and
\(|\Psi_C\rangle=q^{-m/2}\sum_{c\in C}|c\rangle\) its equal-phase CSS state.
For every prime power \(q\) and every \(m\ge2\), every product-unitary
intertwiner between two such states is local Clifford. The proof is uniform in
length: shorten \(C\) and \(C^\perp\) to \(m+1\) retained coordinates, expand
the reduced density matrix in the full finite-field Weyl basis, and recover the
Weyl axes from the pure rank-one contractions of the resulting diagonal tensor.

The hypotheses then turn out to be unnecessary. For every stabilizer
\(\operatorname{AME}(2m,q)\) state with \(m\ge2\), the stabilizer labels
supported on any \(m+1\) parties form a \(q^2\)-element subgroup and project
bijectively onto the full local Pauli-label group at every retained party. The
reduced stabilizer projector is therefore full-Weyl diagonal up to arbitrary
nonzero phase coefficients, and the axis theorem forces every factor of an LU
intertwiner to be Clifford. This holds for arbitrary additive prime-power
stabilizers: CSS structure, equal phases, classical linearity, and the MDS
hypothesis are all unnecessary for rigidity, and the MDS–CSS theorem is a
special case. The \(m=1\) Bell-pair boundary is sharp.

### Consequences

- Any product physical unitary converting the associated \([[2m-1,1,m]]_q\)
  encoders is Clifford factor by factor, and so is its logical intertwiner.
- The product-unitary automorphism group of an equal-phase MDS–CSS state is
  finite modulo one-site scalar phases, those phases forming the full identity
  component.
- For odd prime \(q\), generalized and extended generalized Reed–Solomon codes
  of even length \(2m\le q+1\) attain exactly the projective one-qudit Clifford
  group \(\mathbb F_q^2\rtimes\operatorname{SL}_2(q)\). The first case beyond
  six parties is \(\operatorname{AME}(8,7)\leftrightarrow[[7,1,4]]_7\), whose
  projective transversal group has order \(16464\).

At \(m=3\) the general theorem is paired with a finer six-point-pencil
classification: a degree-eight quotient separates projective, monomial-code,
local-Clifford, and local-unitary equivalence; the conic/GRS locus has logical
symplectic group \(\operatorname{SL}_2(q)\); and the generic off-conic locus has
only the split torus. Fixed-copy scalar contractions are generically constant,
and exact marginal and four-copy witnesses detect only special strata.

### Corrections and boundaries

The linear identity \(N(T)=T\rtimes C_2\) is **false**; the exact
odd-characteristic relation is \(J^2=-I\) with \(N(T)/T\cong C_2\), and the
separate projective party extensions in the checked examples still split.

Full local Clifford blocks do **not** all reduce to standard semilinear
\(\Gamma\operatorname{SL}_2(q)\) blocks. Over \(\mathbb
F_9=\mathbb F_3[s]/(s^2+1)\), at the admitted pencil parameter \(t=1+s\), exact
enumeration of all \(51{,}840\) elements of \(\operatorname{Sp}_4(\mathbb F_3)\)
finds 96 identity-party symplectic gauges compatible with every
minimum-support transition, of which only 16 normalize the standard scalar
field; the other 80 are nonsemilinear in the standard \(\mathbb F_9^2\)
structure.

The arbitrary-\(m\) marginal-to-rigidity chain is formally verified. The
projective-finiteness corollary has a completed formal proof not yet integrated
into the same aggregate, and the full Choi/encoder construction and the exact
GRS transversal-group computation remain human proofs. Prior work is credited
at point of use — Wirthmüller for connected binary stabilizer automorphisms and
projective finiteness, Anderson–Jochym-O'Connor for qubit diagonal and
inter-code transversal restrictions, Sayginel et al. for automorphism-derived
logical Cliffords with phase correction — and no firstness claim is made.

## *Frobenius-equivariant pair extension and robust repair of eight-arcs*

The paper studies extensions of Frobenius-invariant arcs in
\[
PG(2,s^2)
\]
by nonfixed conjugate point pairs.

### General quadratic-Frobenius criterion

- There is an exact orbit-valued extension criterion coupling fixed carrier
  lines, nonfixed Frobenius orbits, old secants, and collisions. It constructs
  a fresh conjugate pair whose union with the old arc remains an arc.

- The carrierwise counting identity has an exact linewise correction:
  \[
  \operatorname{legal}(\ell)+M
   =N+B_\ell+\sum_q(\mu_\ell(q)-1).
  \]
  It separates invisible candidate mass from genuine collision redundancy
  without truncated subtraction.

- The associated equality/excess theorem classifies every first-order
  surplus as
  \[
  \text{invisible mass}+\text{collision redundancy}.
  \]
  Equality means universal visibility and collision-free charging. This is
  an algebraic classification of the count, not a geometric classification
  of near-saturated arcs.

- The general saturation obstruction gives
  \[
  2s(s-1)\le(k-1)^2
  \]
  under the no-pair-extension hypothesis, recovering the classical
  square-root scale in a Frobenius-orbit setting.

### Uniform extension and repair

- Every Frobenius-invariant eight-arc in \(PG(2,s^2)\), for every prime power
  \[
  s\ge5,
  \]
  admits a fresh nonfixed conjugate-pair extension.

- The exceptional base order \(s=5\) is verified formally across all five
  parity-allowed fixed-point profiles. The generic criterion handles
  \(s\ge7\); there is no intervening prime-power base order.

- For every \(s\ge7\), every invariant eight-arc has at least 319 legal
  conjugate pairs. Consequently, after deleting any selected nonfixed orbit
  from an invariant ten-arc, at least 318 alternate pair repairs remain.

- More generally, deletion from an invariant \((k+2)\)-arc leaves at least
  \(r\) alternate repairs whenever
  \[
  \left\lfloor\frac{(k-1)^2}{4}\right\rfloor+r+1
    \le\frac{s(s-1)}2.
  \]

- In particular, for \(s\ge4\) and \(k\le s+1\), at least one alternate
  repair always exists. The excluded point \((s,k)=(3,4)\) misses the
  inequality by exactly one candidate.

### Exact \(PG(2,25)\) exceptional profile

For invariant eight-arcs with exactly two fixed points:

- Every semantic arc has at least 32 fresh legal conjugate pairs.
- The bound 32 is attained.
- The complete extremal set, up to normalization, consists of five certified
  residual-group orbits of sizes
  \[
  200,\quad400,\quad400,\quad200,\quad400,
  \]
  whose disjoint union has size 1600.
- Every normalized row attaining 32 lies in this union, and every semantic
  equality case can be moved into it by a base-field collineation.
- Outside those five orbits, the legal-pair count is at least 33.

This is an exact minimum and extremal classification for the two-fixed-point
profile. It does not classify equality in the other fixed-point profiles or
enumerate the semantic arcs before normalization.

### Further structure

- The residual order-400 symmetry group is the product of two independent
  20-element base-field affine normalizers.

- The candidate obstruction factors through 651 canonical dual-line masks;
  the 310 carrier pairs occur ten per conjugation-fixed line.

- In every residual class, freshness removes three candidates and carrier
  incidence removes 140. Only the old-secant overlap varies, producing the
  computed legal-count spectrum \(32\)-\(47\). The minimum and five equality
  orbits are theorems; the complete spectrum remains computationally
  checked.

- The natural orbit-replacement graph on invariant ten-arcs is defined
  conceptually but not yet proved connected. Its exact local degree should
  be
  \[
  \deg(A)=\sum_{q\subset A}
  \#\operatorname{alternateLegalPairs}(A,q).
  \]
  Adjacency, injectivity, degree, and component structure remain future
  work. No expansion or mixing claim is made.

### Clebsch specialization

Every \(\mathbb F_{11}\)-rational six-arc, including the Clebsch hexagon
after scalar extension to \(\mathbb F_{121}\), has exactly
\[
76\cdot55=4180
\]
legal conjugate-pair extensions. After choosing one extension, exactly 4179
alternate pair repairs remain. This is reach of the general rational-six-arc
count, not another Clebsch characterization.

The manuscript exists and its foundational theorem chain is complete. The exact
minimum for \(PG(2,25)\) is proved and its extremal set classified; the
orbit-replacement graph is the natural next object and is untouched.

## *Semilinear rigidity of four-point-frame continuation graphs*

For a \(k\)-cap \(K\), let \(V_K\) be its legal one-point continuations and
join \(x,y\in V_K\) when \(K\cup\{x,y\}\) is no longer a cap. Equivalently,
\(x,y\) lie on a tangent through one selected point of \(K\).

### General embedded reconstruction

- In any finite partial linear space, each outside point lies on at most
  \(k\) visible selected tangents. Therefore, if every selected point lies
  on more than \(k\) visible tangents,
  \[
  K=\{p:d_K(p)>k\}.
  \]
  Any ambient incidence automorphism preserving the embedded continuation
  graph must preserve \(K\).

- In \(PG(n,q)\), a sufficient condition is
  \[
  1+q+\cdots+q^{n-1}
   >2k-1+\binom{k-1}{2}.
  \]

This is useful general infrastructure, but not the paper's intended
headline.

### The graph as a nonlinear code

- Each legal continuation \(x\) determines the \(k\)-tuple of tangent lines
  \(xt\), \(t\in K\). These tuples form an injective nonlinear length-\(k\)
  code.

- Distinct codewords agree in at most one coordinate, so their distance is at
  least \(k-1\). Graph adjacency is exactly distance \(k-1\).

- Equivalently, the graph is the line graph of a \(k\)-uniform linear
  hypergraph.

This dictionary is exact but does not make the code linear, additive, or
automatically subject to a MacWilliams extension theorem.

### Intrinsic tangent and centre recovery

- A clique not contained in one tangent trace has size at most
  \[
  k(k-2)+1.
  \]

- Hence the abstract graph recovers all tangent traces whenever
  \[
  q-\binom{k-1}{2}>k(k-2)+1.
  \]

- It then recovers the partition of those traces into their \(k\) selected
  centres whenever
  \[
  q+2-k>k\binom{k-2}{2}.
  \]

- For \(k=8\), the combined graph-reconstruction threshold is \(q\ge127\).
  The constants are explicit method bounds and are not expected to be sharp.

### Exact low-cardinality obstructions

- For a one-point cap, the graph is a disjoint union of projective-line
  cliques and has many nonambient automorphisms.

- For every two-point cap in every projective plane of order \(q\),
  \[
  G_K\cong K_q\square K_q.
  \]
  Thus the graph forgets the ambient plane completely.

- For a triangle in \(PG(2,q)\), legal points can be written as
  \((x,y)\in(\mathbb F_q^\times)^2\), with adjacency given by equality of
  \[
  x,\qquad y,\qquad x/y.
  \]
  Every automorphism of the multiplicative group induces a graph
  automorphism. When it is not Frobenius, it is not induced by a semilinear
  collineation.

These results show that a uniform semilinear-extension theorem cannot begin
before four selected points.

### Four-frame semilinear rigidity

Every four-arc in \(PG(2,q)\) is a projective frame. Its legal points have
the normal form
\[
\Omega=\{(x,y):x,y\notin\{0,1\},\ x\ne y\},
\]
with four recovered coordinates
\[
x,\qquad y,\qquad\frac{x}{y},\qquad\frac{x-1}{y-1}.
\]

The two simultaneous multiplicative isotopy equations force all coordinate
permutations to be one field automorphism. Consequently, for every prime
power \(q\ge13\),
\[
\operatorname{Aut}(G_K)
 =\operatorname{Stab}_{P\Gamma L(3,q)}(K),
\]
and
\[
|\operatorname{Aut}(G_K)|
 =24[\mathbb F_q:\mathbb F_p].
\]

At \(q=5\), the graph is \(K_6-3K_2\) and has automorphism group 48, twice
the projective frame stabilizer. The remaining orders \(7,8,9,11\) require a
finite exception table rather than a different uniform proof.

This four-frame rigidity theorem has survived the prior-art audit and is what
the standalone paper claims.

### Full continuation-complex reconstruction

The full continuation complex records every legal set of future moves, not
just incompatible pairs. Its minimal nonfaces are exactly:

- forbidden pairs lying with one point of \(K\) on a tangent; and
- collinear triples whose line avoids \(K\).

Banked consequences include:

- For a two-point cap in any projective plane of order \(q\ge3\), the complex
  reconstructs the affine plane, the two distinguished parallel classes,
  the projective completion, and the unordered selected pair. Thus it repairs
  the complete information loss of the rook graph.

- A general arrangement-completion theorem reconstructs a projective plane
  and a deleted line arrangement from the traces of the remaining lines under
  explicit profile bounds.

- For a \(k\)-arc with secant-arrangement profile \(a_K\), the abstract
  continuation complex reconstructs the complete plane, all secants, and
  \(K\) whenever
  \[
  q\ge
  \max\left\{
  a_K^2-a_K+k,\;
  k^2-3k+3,\;
  a_K+k^2-k+1
  \right\}.
  \]

- Every abstract complex isomorphism then extends uniquely to an incidence
  isomorphism; for Desarguesian planes it is semilinear.

The coarse first thresholds are \(q\ge9,34,95,764\) for \(k=3,4,5,8\).
These are reconstruction bounds, not claimed optimal thresholds.

The continuation-complex package is mathematically proved but
publication-softened because it meets existing complement and
pseudo-complement reconstruction literature. It remains in scope remarks
pending the paywalled Drake-Sané and Metsch comparison, and may never enter
that paper in full.

### Open rather than proved

The extremal quantities
\[
m(k)=\max\{\text{non-tangent clique size}\},
\qquad
r(k)=\max\{\text{mixed-centre disjointness clique size}\}
\]
currently satisfy
\[
m(k)\le k(k-2)+1,\qquad
r(k)\le k\binom{k-2}{2},
\]
but their exact values and asymptotics remain open.

The manuscript exists with full written proofs. Its planned formalization has
not yet been built, and that is its largest remaining gate.

## *The Clebsch Schur--Sarkisov spine*

This result is not yet assigned to a manuscript.  It joins the Clebsch
deep-hole construction to the pointed Sarkisov links of the
Mukai--Umemura threefold through the multiplication algebra of the complete
rational conic.

Let
\[
 R_d=\operatorname{ev}_{\mathbf P^1(\mathbf F_{11})}
 H^0(\mathbf P^1,\mathcal O(d))
\]
with the standard residue-coordinate normalization, and let
\[
 E=R_2=[12,3,10]_{11}.
\]
The code \(E\) is exactly the complete conic extension port that occurs in
the Clebsch deep-hole reconstruction.  Multiplication of binary forms gives,
for \(a+b\le10\),
\[
 R_a\star R_b=R_{a+b},
\]
where \(\star\) denotes coordinatewise Schur product and span.  Consequently
\[
 E^{\star2}=R_4=[12,5,8]_{11},
 \qquad
 E^{\star3}=R_6=[12,7,6]_{11}.
\]
These are precisely the two outer \(SL_2\)-modules \(U_4,U_6\) in the
\(V_5\) and Mukai--Umemura kernel descriptions.  At \(q=11\), residue/Serre
duality gives the exceptional balance
\[
 (E^{\star2})^\perp=E^{\star3},
 \qquad
 R_5=[12,6,7]_{11}=R_5^\perp.
\]
Thus the normal-quintic Sarkisov center is the self-dual degree-five
midpoint between the Schur-square and Schur-cube pieces.

The fixed rational sextic center of the conic link is evaluated from
\[
 W=\langle1,t,t^3,t^5,t^6\rangle
 \subset H^0(\mathbf P^1,\mathcal O(6)).
\]
Its code
\[
 C_\Gamma=[12,5,6]_{11}
\]
is therefore an elementary modification of the cubic Schur power:
\[
 0\longrightarrow C_\Gamma
 \longrightarrow E^{\star3}=R_6
 \longrightarrow J^{(2)}_{0,\infty}
 \longrightarrow0,
\]
where \(J^{(2)}_{0,\infty}\cong\mathbf F_{11}^2\) is the sum of the second-jet
lines at \(0\) and \(\infty\).  Dually,
\[
 0\longrightarrow E^{\star2}=R_4
 \longrightarrow C_\Gamma^\perp
 \longrightarrow (J^{(2)}_{0,\infty})^\vee
 \longrightarrow0.
\]
Here \(C_\Gamma^\perp=[12,7,4]_{11}\).  The two omitted jet lines are the
centered torus weights \(2,-2\); their omission raises the two tangent
contacts from order two to order three.  The strict transforms of those two
3-tangent lines are exactly the two components of the published Reid-pagoda
flop.  Hence the two Singleton-defect directions, missing weights,
second-jet gaps, and flop components are one pair of objects.

This supplies an exact cross-programme spine:
\[
\begin{array}{c}
\text{Clebsch deep-hole port }E=R_2\\
\downarrow\ \star2\hspace{32mm}\downarrow\ \star3\\
R_4\quad\xleftrightarrow{\ \perp\ }\quad R_6\\
\hspace{13mm}R_5=R_5^\perp\text{ at the midpoint},\\
\hspace{13mm}C_\Gamma=\ker(R_6\to J^{(2)}_{0,\infty}).
\end{array}
\]
It also sharpens three bridges without yet proving them.  The quadratic and
cubic pieces in the conic matching quotient now have a literal ambient
source in the square/cube filtration of the conic evaluation algebra, but
no natural transformation to that quotient has been constructed.  The
coefficient-enriched repair port and the scheme-theoretic jet quotient both
recover information erased by support reduction, but no coefficient-port
to Rees-algebra functor is known.  Finally \(R_5\) supplies the
extended-GRS stabilizer \(\operatorname{AME}(12,11)\) state; local-unitary
rigidity makes any proposed product-local realization of the geometric
duality a discrete local-Clifford question, but no such realization is
currently defined.

The next categorical target is a **Conic Schur--Sarkisov correspondence**:
construct the graded evaluation algebra
\[
 \mathcal A=\bigoplus_d R_d
\]
together with its residue/Frobenius pairing and jet modifications, and
recover the three Fano objects and their Sarkisov centers functorially from
that data.  What is proved above is the object-level multiplication,
duality, exact jet sequences, and identification of the two exceptional
components.  A base-change-compatible Rees construction and a master
correspondence among \(Q^3,V_5,U_{22}\) remain conjectural.

### Quantum consequences beyond AME

The jet exact sequences themselves define a quantum code.  Take
\(C_\Gamma\) as the \(X\)-check space and \(R_4\) as the \(Z\)-check
space.  The inclusion \(C_\Gamma\subset R_6=R_4^\perp\) makes the checks
commute, and their dimensions give two logical qudits.  More strongly,
their logical Pauli spaces are exactly
\[
 \mathcal L_X=R_6/C_\Gamma\simeq J^{(2)}_{0,\infty},
 \qquad
 \mathcal L_Z=C_\Gamma^\perp/R_4
 \simeq(J^{(2)}_{0,\infty})^\vee.
\]
The residue pairing becomes their Pauli commutator pairing.  The two
second-jet lines therefore label the two logical \(11\)-level systems.
The two logical-operator distances are six and four, giving
\[
 [[12,2,(6,4)]]_{11}.
\]
Its asymmetric quantum Singleton defect is two.  Its relative generalized
weight hierarchies are \((6,7)\) and \((4,5)\), so the minimum support for
both logical directions is only one coordinate larger than for the first.

The same construction works over every odd prime power \(q\ge7\):
\[
 [[q+1,2,(q-5,4)]]_q.
\]
Indeed the two check spaces are \(C_\Gamma(q)\) and \(R_{q-7}(q)\);
their logical quotients are precisely the two sequences dual to (19.17).
Minimum words span the MDS parent \(R_6(q)\), so the first quotient attains
distance \(q-5\), while the second attains distance four because
\(R_{q-7}(q)\) has distance eight.  The entire family has asymmetric
Singleton defect two.  No novelty claim against the asymmetric quantum
GRS literature is made; the geometric jet/Sarkisov interpretation is the
new content here.

The pure CSS state
\[
 |C_\Gamma\rangle
 =11^{-5/2}\sum_{c\in C_\Gamma}|c\rangle
\]
is 3-uniform but not AME.  Exactly fifteen four-party marginals, on the
three \(5+5+5\) orbits of dual minimum supports, have rank \(11^3\);
the other \(480\) have full rank \(11^4\).  Thus the first failure of
perfect-tensor behavior is completely localized by the conic circuit
geometry.  Global local Fourier transform exchanges this state with
\(|C_\Gamma^\perp\rangle\), preserving its entanglement profile while
exchanging the \(X/Z\) constraints.

In the raw homogeneous coordinates,
\[
 GG^{\mathsf T}=\operatorname{diag}(0,0,0,-1,1),
\qquad
\operatorname{Hull}(C_\Gamma)=\langle1,t,t^3\rangle.
\]
The associated entanglement-assisted construction is
\([[12,4,4;2]]_{11}\).  The two-ebit count equals the geometric defect
numerically; unlike the ordinary CSS quotient above, a canonical
componentwise identification has not been proved.

At \(q=13\), the degree-twelve finite power sum cancels the coordinate at
infinity, making
\[
 R_6(13)=[14,7,8]_{13}=R_6(13)^\perp.
\]
This second field resonance yields both
\[
 [[14,4,4]]_{13},
 \qquad
 [[14,2,(8,4)]]_{13}.
\]
The highest-value open quantum test is whether the exact square/cube
Schur algebra produces a transversal non-Clifford phase on the two jet
qudits.  A Rees-algebra lift would then be the gate for interpreting the
flop itself as gauge fixing or code deformation, rather than merely
quantizing its exceptional quotient.

This bridge does not remove the separate boundary in *Arithmetic and
harmonic realizations of the Clebsch cubic*: no canonical specialization
from those real/rational realizations to the finite matching tensor has been
proved.

## Two open programmes

### Complete arcs of square-root size relative to a conic

The construction problem behind the exact values of \(\rho_{\mathcal C}(q)\):
build \(\mathcal C\)-complete arcs of size \(O(\sqrt q)\), or prove an
infinite-family obstruction. The shape of the difficulty is now sharp, and it
is not the one expected.

*Arc legality is solved at linear size.* Two parallel subfield parabolas form a
uniform conic-disjoint \(2s\)-arc, and adding a repair layer yields a
conic-disjoint arc of size \(11s/840-O(\sqrt s)\) along every \(s=8^m\) with
\(m\) odd — proved via \(S_5\times C_2\times C_2\) monodromy, Chebotarev, and a
greedy bound on a collision graph of maximum degree six. This is the
programme's first infinite-family positive-density result.

*Coverage is what fails.* Saturation is the prerequisite bottleneck and
quadratic evaluation rank is downstream, which inverts the original working
assumption. Arcs inside a single Baer subplane are never conic-complete for
\(s\ge3\), leaving \((s^2-s)^2/2\) points uncovered against an ambient conic of
at most \(s^2+1\) points. A Kloosterman/Weil bound kills every full-domain
\(\operatorname{GF}(8)\)-coefficient scalar extension for \(s\ge16\), making
\(\operatorname{GF}(8)\) the unique escape; partial domains then die too, since
singleton forcing sends \(105\mid m\) and on that subtower the residue
hypergraph is empty. Generic quadratic repair coefficients are closed as well:
the joint monodromy group is a full wreath product, leaving a density
\(\approx0.0382\) missed by every chord class.

*The live signal.* Twelve genuinely nonlinear repair layers at \(s=8\) give
\(3s=24\) arcs whose nineteen uncovered points all lie on the line at infinity —
hence complete affine arcs, extending to complete 26-arcs disjoint from the
conic. A uniform characteristic-two version with the same three-layer coverage
would give \(3s+2\) and solve the problem on an infinite square-order sequence;
it is proved only at \(s=8\). The twelve layers form three
\(\operatorname{PGL}(3,64)\) classes but a single \(\operatorname{P\Gamma
L}(3,64)\) semilinear class, giving a \([24,3,22]_{64}\) MDS code with an
intrinsic \(10+10+4\) conic signature, and excluding hyperfocused arcs,
translation arcs, affinely regular polygons, and the nearest catalogued
construction.

*The field-varying route closed on coverage.* Fresh per-field coefficients do
produce collision-free four-layer arcs of size \(4Q\) for every odd-tower
\(Q\ge2^{45}\) — so the legality gate is genuinely passable at that scale — but
those arcs' finite secant directions form exactly seven reciprocal images, so at
most \(7Q-2\) points are covered and at least \(Q^2-7Q+2\) required non-conic
points are left uncovered, on the whole stratum and before any trace condition.
Together with an empty linear stratum and a degree-\(\le5\) collision law on
fixed coefficients, the entire constant-height four-carrier architecture is
closed on both gates at once.

Still open: nonquadratic repair graphs, other Baer-transversal designs, and
architectures with more than four carriers or non-constant height. **No global
nonexistence statement about \(\mathcal C\)-complete \(O(\sqrt q)\) arcs is
claimed anywhere.**

### The cap game on odd projective planes

In the cap (or *Nofil*) game on a finite geometry, players alternately add
points keeping the selected set a cap — no three collinear — and the last
player able to move wins. Affine spaces \(AG(n,q)\) are second-player wins for
every \(q\); so is \(\operatorname{PG}(n,2)\) for every \(n\),
\(\operatorname{PG}(2m-1,q)\) for odd \(q\) by a fixed-point-free elliptic
involution, and \(\operatorname{PG}(2,q)\) for all even \(q\). The open problem
is \(\operatorname{PG}(2,q)\) for odd \(q\), where the evidence says the answer
is not another static mirror.

The reduction chain is: the plane is a second-player win iff a single four-cap
frame is; the residual is a \(q\times q\) grid game; each size-three residual
has exactly \(q^2-9q+21\) legal size-four children; and a size-three residual
together with its burned directions forms a five-arc, hence determines a unique
conic. Both directions of the frame equivalence are formally verified. The
statement that every size-three residual has a second-player-win *on-conic*
size-four child is verified through \(q=25\); the two orders at which the
witness count is depleted are \(11\) and \(17\), and no residue of \(q\)
predicts them.

The current effort is a reply strategy with a stated interface. The boundary law
is settled: on the relevant residuals the game is Node-Kayles on the full legal
conflict graph, so a second-player win is equivalent to Grundy value zero. Total
capacity-two overload is the exact well-founded absorption coordinate, and the
maximal value-independent survivor defined from that boundary is a second-player
win by well-founded induction. A secant size barrier — an \(s\)-cap with the
relevant closure property forces \(q\le\binom s2\) — proves no fixed-size route
can be uniform. What is missing is a single statement: *for every opponent move,
choose a sound reply of lower rank*.

Candidate survivors get closer and each dies on a located edge. A bounded
small-shell incidence correspondence is sound and projective but has zero
coverage on the first \(q=23\) control. A rank-zero defect correspondence agrees
with the recursive survivor exactly on ten canonical controls and fails on the
eleventh. Strict obligation deletion agrees on 11,075 edges before failing at
control index 20, where the unique sound reply necessarily creates one new
defect while dropping rank from 27 to 2. That failure is the current lead rather
than a dead end: the created defect is traceable, inheriting the label of the
causal half-move, and two distinct marked projective replacement types — one
created by the opponent's half-move through endpoint degradation, one by the
reply through deletion of its own certificate — each close by a bounded local
mechanism with no branching or ancestry collision. A bounded-format uniform
update is the open target.

Ruled out along the way: any fixed finite exact residual signature, since sealed
conic subsets already give unboundedly many second-player-win heights; every
scalar extremal selector tested; and unrestricted coordinate encodings, which
are vacuous because a natural number can encode the whole residual.

## Status summary

- ***Reconstructing the Clebsch code from its deep-hole syndrome locus:***
  mathematics complete; the computational strengthenings travel in a companion,
  *Computational strengthenings of Clebsch syndrome rigidity*. What remains is
  publication packaging.
- ***Quadratic recovery and cubic orientation in conic matching quotients:***
  coherent standalone theorem sequence with conceptual proofs of its rank and
  cubic mechanisms and a completeness theorem naming the two occurring
  configurations; drafting follows.
- ***Arithmetic and harmonic realizations of the Clebsch cubic:*** two adopted
  theorems; two proof gaps must close or the arithmetic theorem must be weakened
  to exactly what is proved.
- ***Arcs complete outside a conic:*** defect identity, zero-defect
  rigidity, and stability formally verified; six exact values of
  \(\rho_{\mathcal C}\); the \(q=16\) classification compressed to three
  exceptional cases.
- ***Deep holes of projective Reed–Solomon codes beyond redundancy four:***
  exact at redundancies three, five, six, and seven, with a uniform high-field
  containment theorem at arbitrary redundancy; not a proof of the general
  deep-hole conjecture.
- ***Complete Bounded Repair Ports:*** manuscript assembled around the general
  MDS reconstruction theorem; central transfer and cubic results formally
  verified; specialist citation review outstanding.
- ***Local-Unitary Rigidity of Stabilizer AME States:*** rigidity proved for
  every stabilizer AME state, not only the MDS–CSS family; the marginal-to-
  rigidity chain is formally verified, the encoder and transversal-group
  consequences are not.
- ***Frobenius-equivariant pair extension and robust repair of eight-arcs:*** foundational
  theorem chain and the exact minimum for \(PG(2,25)\) proved; the
  orbit-replacement graph remains future work.
- ***Semilinear rigidity of four-point-frame continuation graphs:*** manuscript
  and written proofs complete; the formalization has not been built, and the
  continuation-complex package is publication-softened against existing
  reconstruction literature.
- ***The Clebsch Schur--Sarkisov spine:*** exact at the level of conic
  evaluation codes, Schur products, residue duality, jet quotients, and the
  two Reid-pagoda components.  Its jet quotients give an exact
  \([[q+1,2,(q-5,4)]]_q\) asymmetric CSS family and a fully resolved
  \(q=11\) four-marginal defect pattern; the transversal-gate test,
  Rees-algebra functor, and master Fano correspondence remain open.  A
  full-document cross-area audit adds two exact non-code consequences:
  the sparse sextic is the unique reduced point of the self-dual
  two-pole Schubert problem
  \(\sigma_{(2,2,1)}^2=1\), with Wronskian \(x^5y^5\); and the projected
  rational sextic is arithmetically Buchsbaum with Hartshorne--Rao module
  \(k^2(-1)\), identifying its defect-two jet quotient with its complete
  projective-normality deficiency.  The next independent bridges are the
  contraction algebra of the width-three pagoda, a specific
  \(E_8\)-McKay-module realization of the Klein transvectant, and
  globalization of the pointed Rees filtration to a K-stability test
  configuration.  The \(E_8\) item is a refinement of the substantial
  C381--C390 line, not a new area: it must be formulated directly for
  \(2.A_5\) modules and cannot reuse the equivariant marked-lattice
  comparison ruled out by C382.
- **Open programmes:** square-root complete arcs and the odd-plane cap game,
  both with substantial partial results and explicitly no global claim.
