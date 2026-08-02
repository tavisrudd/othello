# Portfolio results summary snapshot

**Date:** 2026-07-31

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

**How to read the length.** Sections are not sized in proportion to the
mathematics they contain. Each one carries its scope boundaries, its priority
concessions, its refuted predecessors and its explicitly unclaimed
strengthenings alongside the results themselves, because those are the parts a
reader cannot reconstruct and most easily assumes away. A long section
therefore signals how much delimiting a result needed, not how much was proved,
and the density of theorem-grade content is well below what the volume of prose
suggests.

The results are grouped as follows.

1. *Reconstructing the Clebsch code and its golden orientation from its
   deep-hole syndrome locus* — how a six-point arc in the plane of order eleven
   is recovered from coarse decoding data.
2. *Quadratic trade rigidity and cubic orientation in conic matching quotients* —
   what survives when a matching of conic points is restricted to the conic.
3. *Golden descent and operator realizations of the Clebsch cubic* — two
   realizations of the same four-dimensional space, joined by a marked
   orientation source theorem, and the conference operator that carries it
   through the classical Clebsch–Segre shadows.
4. *A binary [78,36,12] code from the passant lines of a conic over
   \(\mathbb F_{13}\)* — a code whose minimum words reconstruct the geometry
   and the full symmetry group they came from.
5. The golden conference operator source programme — one marked order-six
   conference operator and the cubic, polar, determinantal, fermionic,
   anomaly, and lattice shadows it generates. This is a source-development
   body of mathematics feeding future forward versions of the paper in
   section 3, not a manuscript of its own.
6. *Arcs complete outside a conic: a prescribed-hole defect identity and
   matching-design rigidity*.
7. *Deep holes of projective Reed–Solomon codes beyond redundancy four: exact
   classifications at redundancies five through seven*.
8. *Complete Bounded Repair Ports: Transfer, Reliability, and Geometric
   Structure* — local memory and exact transfer of erasure repair.
9. *Local-Unitary Rigidity of Stabilizer AME States and Transversal Clifford
   Groups of MDS–CSS Codes* — every product-unitary intertwiner of a stabilizer
   absolutely maximally entangled state is local Clifford.
10. *Frobenius-equivariant pair extension and robust repair of eight-arcs* —
    extending Frobenius-invariant arcs by conjugate point pairs.
11. *Semilinear rigidity of four-point-frame continuation graphs* — an abstract
    graph that remembers its ambient plane.
12. *The Clebsch Schur--Sarkisov spine* — the conic deep-hole port
    Schur-generates the two outer Fano modules, while the conic-link code is
    their defect-two jet modification.
13. Unassigned adjacent results: a residual-multiplier exclusion for Hadamard
    matrices of order 668.
14. Two open programmes with substantial partial results: complete arcs of
    square-root size relative to a conic, and the outcome of the cap game on
    odd projective planes.

The first four sections are the four numbered papers of the Clebsch series, in
that order. The three released papers carry the titles under which versions one
and two were published; where a forward version has changed a title, the
section says so.

## *Reconstructing the Clebsch code and its golden orientation from its deep-hole syndrome locus*

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

A human cover theorem supplies the window the exhaustive searches once did. Let
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

### Beyond eight points: how far the classification now reaches

The natural completion of the statement above — that a deep-hole locus is a
full conic exactly twice, ever, at the four-frame over \(\mathbb F_5\) and the
Clebsch hexagon over \(\mathbb F_{11}\), for *every* arc size \(k\) — is **not
proved**. What is proved is a reformulation, two size-uniform necessary
conditions, a structural dichotomy that lands on both known examples, and a
complete classification, all sizes at once, over every field up to \(43\).

The reformulation splits the condition. \(\mathcal U(A)=\mathcal C\) holds
exactly when every chord of \(A\) is *external* to \(\mathcal C\) (disjoint
from it) and the chords cover all \(q^2\) points off \(\mathcal C\).
Externality is hereditary and the covering condition is not, and that
distinction is invisible to the chord-moment system, which counts chords
without seeing that they all avoid one conic. In the binary-quadratic model of
the plane, externality says every pairwise resultant is a quadratic nonresidue.
Even \(q\) is impossible outright: every tangent passes through the nucleus, so
no external chord covers it.

The two uniform conditions are a covering linear-programming bound and a
spare-line bound. The first uses the correct off-arc degree cap
\(\lfloor k/2\rfloor\) rather than the accident \(\lfloor k/2\rfloor=3\) that
the published \(k\le8\) bound \(q\le(k(k-1)+3)/3\) rests on, and so holds for
every \(k\). The second gives a dichotomy: either \(\binom{k-1}2\ge q\), or
every external line through every arc point is a chord, which forces all arc
points to have one type and \(k=(q+1)/2\) with every arc point external, or
\(k=(q+3)/2\) with every one internal. **Both known examples are exactly the
two saturated types** — the four-frame is the internal one, the hexagon the
external one — so the dichotomy locates them rather than merely admitting them.

The saturated-external branch is now closed. Fixing one matching edge turns the
arc condition into a complete mapping of the cyclic square group, which
excludes every \(q\equiv1\pmod4\) and hence every odd square field by a group-sum
obstruction; Segre's lemma of tangents forces every arc in the remaining branch
to be sign-coherent; Stickelberger's half-carry profile and a base-\(p\)
digit-weight lemma show one faithful Jacobi eigenvalue has exactly its Frobenius
collisions, which makes every matching multiplication-Frobenius and lets a
genus-one character sum with Hasse's bound finish, leaving \(q\in\{3,7,11\}\)
where \(q=7\) fails covering and \(q=11\) is the hexagon.

The nonsaturated branch is reduced but open. Deleting an arc point on a spare
external line gives an affine \((k-1)\)-arc determining every direction but one,
whose direction discriminant factors as \((T^q-T)E_P(T)\) with
\(\deg E_P=\binom{k-1}2-q\), the roots of \(E_P\) recording exactly the excess
parallel-chord concurrences. Zero slack is impossible over every odd field
except the already excluded \(q=3\); slack one factors into \(q=5,9,27\), all
removed by the classification below; so every nonsaturated conic-filling arc has
\(\binom{k-1}2\ge q+2\). At slack two the residual divisor is one double
rational point or two distinct rational points, and the first case the finite
classification does not already remove is \((q,k)=(53,12)\).

The bounded classification is complete for all sizes over each odd prime power
\(q\le43\): the only conic-filling arcs are the four-frame at \(q=5\) and the
hexagon at \(q=11\). Nine of the sixteen fields close by counting alone, because
the largest conic-external arc is smaller than the smallest possible
conic-filling one; the other seven need the conic-external arcs enumerated and
the covering condition tested on each.

**Why counting cannot finish it, stated with the measurement.** Both the
threshold size and the largest conic-external arc are \(\sqrt{2q}+O(1)\), and
which one wins alternates across the measured range with no trend — the ratio
\(\binom{m(q)}2/q\) stays inside \([0.67,1.55]\) throughout. Every further
refinement of the covering bound adds \(O(1)\) to one side while the other side
also drifts by \(O(1)\). A proof of the general theorem needs an upper bound
\(m(q)<\sqrt{2q}+O(1)\) on the largest arc all of whose secants avoid a fixed
conic, and the measurements say that inequality is tight rather than generous,
so it may simply be false for some \(q\). The underlying object is a clique
bound for a Paley-type graph on the \(q^2\) points off the conic.

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

### The golden orientation carried by the syndrome locus

The syndrome locus reconstructs more than the arc: it reconstructs an
unordered support-orientation torsor. The \(10+10\) split of coordinate
triples is a regular two-graph; on the frozen common marking its exchange is
simultaneously support complementation, Gale duality, and golden conjugation,
and its first surviving signed moment is cubic.

That torsor has an exact operator presentation. If \(B\) is either signed
continuation orbital on the fibre-odd six-axis lattice, then
\[
 c_{ijk}=B_{ij}B_{jk}B_{ki}
\]
is the support-orientation cubic. Switching axis representatives leaves the
triangle products unchanged, orbital exchange negates them, and the four-point
two-graph identity reconstructs \(B\) up to switching. So the cubic line and
the golden conference relation \(B^2=5I\) are two presentations of one integral
orientation torsor. Concretely,
\[
 \det(B+\operatorname{diag}x)=e_6-e_4+5e_2-125-2C_B,
\]
so the cubic is the sole nonsymmetric layer of the golden diagonal determinant
pencil; the off-diagonal equations of \(B^2=5I\) kill every signed moment below
degree three and push the cubic down to the augmentation five-space; and pair
balance is equivalent to \(B^2=5I\), so the cubic alone forces the unique golden
conference switching class. The cubic threefold on the augmentation projective
four-space has exactly six singular points \([\mathbf1-6e_a]\), all ordinary
nodes and forming a projective frame, so the cubic reconstructs the six-axis
carrier; its full projective automorphism group is the outer \(S_5\) of order
\(120\). Singular-locus completeness is structural rather than a Gröbner
computation: the cross-golden determinant is \(-C\), its trace dual is the
smooth Clebsch diagonal cubic surface, and the Hassett--Tschinkel determinantal
converse gives exactly six ordinary nodes.

Modulo \(2\) all signs coalesce and \(B-I\) is rank-one square-zero. The
natural fibre-odd integral commutant is the conductor-two order
\(\mathbf Z[\sqrt5]\), whose mod-\(2\) fibre is a dual-number point and whose
normalization has fibre \(\mathbf F_4\). The signed continuation operator is
the golden Gram conference matrix of the Schur--Sarkisov exploration up to a
signed permutation, so this is one conductor defect on one golden six-axis
algebra. The twelve-point Schläfli identification fails equivariantly, but both
objects map to the same six-axis \(A_5/D_5\) carrier: this construction is its
twisted transitive two-cover and the double-six is its split two-cover.

### The terminal fields as finite proof objects

The \(q=11\) fifteen-class census is an orbit ledger with canonical
representatives, stabilizers, masses summing to \(1548\), concurrence counts,
chord-defect uncovered sizes, and conic-intersection histograms; fourteen
nonsingular cubic minors replace the non-Clebsch row reductions, and the
Clebsch kernels are generated by \(Q\) and \(QX,QY,QZ\). Over
\(q=13,17,19\) the passant edges split into \(10/13/15\) projective root
orbits whose complete root-stabilizer extension DAGs have \(604\), \(4{,}442\),
and \(11{,}260\) nodes; the maximum six-arcs form \(2/22/94\) projective orbits
with \(546/50{,}184/395{,}124\) labelled representatives. At \(q=17,19\) all
maximal passant six-arcs have empty extension sets, and pair and triple inner
distributions separate every orbit. This is a finite coherent compression, not
a uniform theorem: the natural root-edge rational LP has optimum exactly the
smaller residual pencil, hence at least \((q-3)/2\) against a required bound of
four, so that first-order dual route fails for every odd \(q\ge13\).

The binary code attached to the \(q=13\) passant lines grew out of this
material and is now the separate paper of section 4 below.

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
classifications, each with its own replay routes. The companion labels every
claim by one of five explicit modes — human structural proof, published
theorem, Lean theorem, finite certificate, and trusted execution — so no finite
classification or orientation theorem is presented as machine-checked when it
is not. This paper and the two below share the title-page identity *The Clebsch
cubic: recovering, orienting, and realizing* while remaining logically
independent.

## *Quadratic trade rigidity and cubic orientation in conic matching quotients*

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

- **The ranks are proved conceptually, with no orbit row reduction.** One
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

- **Cubic survival is conceptual.** Both frozen configurations are reduced
  self-associated arithmetically Gorenstein sets of \(2q\) points, so quadratic
  recovery gives signed Gale self-duality and Cayley--Bacharach in degree two,
  and Hilbert symmetry then forces the cubic. The Gorenstein pairing comes from
  the signed coordinate form directly: the quadratic identity makes the affine
  evaluation space maximal isotropic, and quotient duality supplies the perfect
  degree-one-by-degree-two Artinian pairing. The Paley cross-sheet matrix
  explains the cross-sheet orientation but is not that pairing — it misses the
  radial/common-sum pair by one dimension. A full-support hyperplane-square
  lemma shortens the dependency further, forcing the Schur cube directly and
  leaving the Gorenstein argument as a geometric consequence and independent
  check. Radial nonvanishing for \(B_3\) and \(H_3\) is one proof, not two: an
  endpoint edge selects a unique cross-sheet matching pair, deleting it leaves
  a single alternating cycle, and the common \(c\leftrightarrow c^{-1}\) torus
  normal form reduces both cycle lengths to one Dickson recurrence. The graded
  corollary is \(L^{\circ3}=\mathbb F_q^{\Omega_T}\), so the evaluation algebra
  saturates at degree three.

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
Suppose only that quadratic products intrinsically recover a nontrivial
factorization bipartition, meaning that \((L^{\circ2})^\perp\) is a line whose
nonzero vectors have exactly two level sets on \(\Omega\). Then the only
resulting orbits are
\[
B_3/\mathbb F_7
\qquad\text{and}\qquad
H_3/\mathbb F_{11}.
\]
The one-factorization property is a conclusion rather than a hypothesis. A
two-valued one-dimensional strength-two trade gives two special-projective
sheets; the projective--trade bridge, a uniform Frobenius-digit first-wall
obstruction, the characteristic-three axis trade, and an exhaustive \(q=9\)
endpoint close every sheet multiplicity \(\lambda>1\); and the balanced
\(q+q\) one-factorization split follows.

This is already a coherent standalone theorem sequence: conic divisibility,
exact ranks, sheet recovery, cubic orientation, profile reconstruction,
modular explanation, arithmetic gluing, and a completeness theorem naming the
two occurring configurations.

## *Golden descent and operator realizations of the Clebsch cubic*

A note proving two independent results on the same Clebsch four-space. Its
released versions one and two carry the earlier title *Arithmetic and harmonic
realizations of the Clebsch cubic*; the forward version renamed it because it
now also carries a bounded selection of the conference-operator material of
section 5, running as one chain from the incidence descent
\(\sqrt{5J_0}\) through the relation \(C^2=5I\) to the triangle and
middle-exterior cubics, the commutator Pfaffian and cross-golden determinant,
the Joubert–Segre and Segre–Igusa shadows, and back to the degree-six harmonic
return. It deliberately does not import the quantum, anomaly, Majorana,
Coble–Burkhardt, exceptional-lattice, doily, or higher-conference branches;
those remain source inventory. The wider inventory the original note was drawn
from is larger than the note and is recorded separately below.

The forward version also states why the cubic shadow is a determinant rather
than a permanent. The map \(B_T(x):V_{T,+}\to V_{T,-}\) is intrinsic, so its
determinant is a map between determinant lines and becomes the displayed scalar
once orientations are chosen. A permanent has no basis-free counterpart: under
independent orthonormal frames the matrix changes as \(B\mapsto R_-^{\mathsf T}BR_+\),
and already the identity in dimension three, with a plane rotation on one side,
moves the permanent from \(1\) to \(\cos2\theta\).

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

### The marked orientation source

The two realizations are joined at one point: they are two realizations of a
single oriented Clebsch coordinate line. The common datum is a chosen sheet of
Hitchin's incidence cover on the golden Clebsch chart. With the frozen six-axis
marking and volume orientation, that sheet determines the pair
\[
 ([C],[Z_C]),
 \qquad
 Z_C(x)=\sum_{i<j<k}C_{ij}C_{jk}C_{ki}x_ix_jx_k,
\]
where \([C]\) is the switching class of the order-six golden conference matrix
and \(Z_C\) its oriented triangle cubic — the same orientation torsor the
syndrome locus produces. The same choice fixes the linear lift of Hitchin's
projective Clebsch chart, and the primitive pair-sum map
\(\beta:(y_i)\mapsto(y_i+y_j)_{i<j}\) on \(\sum y_i=0\) transports the sign to
the harmonic side.

The corrected arithmetic statement has global square class \(5J_0\), and the
chart factorization is scheme-theoretic rather than a function-field identity:
the quadratic involution splits the pullback into a global Stein algebra
\(\mathcal O\oplus\mathcal O(-3)\) with multiplication \(z^2=5J_0\). The fixed
Clebsch chart lives over \(\mathbf Q(\sqrt5)\) and the displayed golden
configurations are the complete reduced local fibre.

### What is not claimed

The bridge is explicitly *relative* to a marked datum: ordered golden-axis
representatives, representative-lattice orientation, five plane-triple labels,
a normalized linear chart lift, and compatible Petersen two-subset labels. The
selected sheet does not reconstruct any of them, and the ambiguity ledger is
complete — axis switching is quotiented, axis relabelling transports the
conference matrix and cubic variables, representative-lattice orientation
reversal changes nothing used, one-sided five-label relabelling changes the
marked datum, chart scaling is fixed by \(q_1=xyz\), golden Galois conjugation
negates the conference matrix, triangle cubic, and chart lift after transport
by the exchanger, and deck exchange negates the odd generator with its attached
relative source.

The full geometric integral localization remains unspecified. Pullback across
\(\sigma_3=0\) and the all-degree face-axis channels are open beyond the
retained theorems, and every functorial shadow of the conference operator
belongs to the separate golden-operator paper below rather than here.

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

## *A binary [78,36,12] code from the passant lines of a conic over \(\mathbb F_{13}\)*

Take the conic in \(\operatorname{PG}(2,13)\), its \(78\) internal points and
its \(78\) passant lines, and let \(K\) be the kernel of the incidence matrix
between them. The parameters are the front door; the reason for the paper is
that the minimum words of \(K\) reconstruct the geometry and the symmetry group
they came from.

The minimum distance is exactly \(12\), proved without a support search. Segre
tangent triples exclude weight eight: after one point is fixed, a cyclic
42-vertex compatibility graph has clique number five while a weight-eight word
would need a seven-clique. The two forced weight-ten pencil profiles are
excluded, and a dihedral weight-twelve word is constructed. All \(364\) minimum
words split into one \(S_4\) and three \(D_{24}\) projective orbits, and every
one of those orbits spans the whole code.

The reconstruction is the headline. Pair concurrence among minimum words
recovers whether two points are joined by a passant or a secant;
triple-concurrence profiles recover all six elliptic orbitals; and the \(78\)
all-zero-triple seven-cliques are exactly the passant incidence rows, so the
minimum layer rebuilds the incidence matrix it was defined by. The common
automorphism group of the code, the minimum-support hypergraph, and the
association scheme is exactly \(\operatorname{PGL}(2,13)\).

**Priority boundary.** The code itself is not new and the boundary is closer
than earlier drafts made visible. Droms, Mellinger and Meyer introduced this
passant-line/internal-point parity-check code and bounded its minimum distance;
the later code survey of Ma, Liu and Tian records
\(\tfrac{q+3}2\le d\le q-1\) for it, which at \(q=13\) is the interval
\(8\le d\le12\). This paper closes that interval at its upper endpoint and then
proves the classification, spanning, reconstruction, and symmetry statements,
for which no predecessor was located. Madison and Wu supply the general
dimension formula and Hollmann and Xiang the elliptic association scheme used
to explain the minimum layer.

The proof is led by a human argument; computation records discovery and is
retained only where finite bulk has resisted conceptual compression. Two Lean
surfaces support it — shared semantic modules carrying the logical spine, and a
paper-owned package checking the irreducibly finite leaves in small auditable
shards. Neither is a claim that the main theorem is machine-checked. Four
concrete transports and the public release remain open.

## The golden conference operator source programme

The results in this section are proved and available, but they are **not** a
manuscript. They are the source body from which forward versions of the paper
in section 3 draw; the legacy working title *The golden conference operator and
its shadow sisters* survives only as a label for the programme. Read the
priority note at the end of this section before quoting any of it: a
literature audit found five clean pre-emptions, two of them close to verbatim.

Let \(C\) be a marked symmetric conference operator on six axes with
\(C^2=5I\), and let \(C_T\) run through its coherent outer six-family. The
claim of this manuscript is that a large family of apparently unrelated
objects — cubics, polar maps, determinantal resolutions, fermionic amplitudes,
anomaly solutions, and lattices — are images of that one operator under
exterior power, golden compression, commutator, determinant/Pfaffian,
adjugation, and centered squaring, and not accidental formula matches.

### Cubic, polar, and determinantal shadows

The diagonal of the middle exterior operator \(*\bigwedge^3C_T\) is the signed
Joubert cubic vector; its six outer coordinates are the Joubert coordinates and
land on the Segre cubic, and centered squaring is the Segre--Igusa polar map.
The same cubics are Pfaffians,
\[
 \operatorname{Pf}[D_x,C_T]=4Z_T(x),
 \qquad
 \det[D_x,C_T]=16Z_T(x)^2,
\]
and over the golden splitting they are determinants of the cross-eigenspace
blocks. The Cartan restriction \(\operatorname{Pf}[D_x,C]=4Z_T(x)\) makes the
Segre coordinate, restricted branch sextic, and Igusa polar coordinate the
Pfaffian, determinant, and centered-determinant shadows of one return.

The six Pfaffian systems are the unique outer-equivariant synchronized product
of pure-spinor Cartan big cells. The synchronized tangent map and top cubic
covariant each have multiplicity one, the exact projected ideal is the reduced
Segre ideal with a reduced fifteen-line unstable base scheme and ten \(3+3\)
nodal images, and Wick identities govern each factor.

The cross-golden block and its adjugate give a \(3\times3\)
linear--quadratic matrix factorization whose two kernel incidences are the
golden-conjugate small resolutions of the six-node cubic. Its two conjugate
rank-one Ulrich/MCM sheaves descend to a rational rank-two MCM object carrying
\(J^2=5\), so the paired-tower descent persists in the cubic's singularity
category. Each small resolution is a \(\mathbf P^1\)-bundle over
\(\mathbf P^2\); smooth hyperplane sections are six-point blow-ups, and the two
conjugate blowdowns give the determinantal double-six. Centered squaring is
projectively birational away from the Igusa singular locus: on the resolved
Gauss map its fifteen singular lines have fibres given by strict transforms of
conics through four Segre base nodes, degenerating to six-line fibre closures
at the fifteen triple-line points.

### The Boolean layer and the order-ten lift

On the balanced Boolean layer, \(C^2=5I\) is equivalent to universal
maximum-determinant \(K_{3,3}\) frustration, and yields exactly six
\(A_5/D_5\) shadow fingerprints. The six ten-cut sign syndromes form a
distance-six regular simplex in the outer augmentation module; five-cycle
magnitudes certify golden membership, three optimal signs identify a sister
after certification, and the full syndrome corrects two sign-readout errors.

Transposing the same syndrome gives the ten-vector \(\operatorname{ETF}(5,10)\),
and
\[
 S_{10}=\tfrac12\bigl(R^{\mathsf T}R-6I\bigr)
\]
is the Petersen/Paley order-ten conference operator. The order-ten boundary
example is therefore itself a Naimark--Gram shadow of the order-six golden
system. Selected \((2,2,1,1)\)-coefficients of the determinant sextic are
exactly the four-cycle holonomies read by relative \(K_{3,3}\) matching signs,
so the algebraic sextic and the dimer fingerprint are canonically equivalent
orientation-free presentations: both recover the unoriented switching line
without a Pfaffian sign, and \(W=0\) is exactly the ten-node Segre polar base
locus.

Pushing the lift further stops for a stated reason. The \(36\) extremal
order-ten cuts form the single \(S_6/F_{20}\) orbit — canonically the same
\(S_6\)-set as the \(36\) involutory polarities — their halves form a
\(2\text{-}(10,5,16)\) design, and their sign lines a biangular tight frame in
dimension nine, so direct Gram-to-conference iteration stops. The large-angle
relation is the Sylvester graph, whose \(-3\)-eigenspace is the integral cut
frame; the resulting weighted operator satisfies \(K^2=10K+75I\) with
off-diagonal weights \(1,3\), and recentring gives the canonical reflection
\((K-5I)^2=100I\), so the conference failure is a redundancy change
\(2\to4\). In the Sylvester Bose--Mesner algebra \(K=-3A_1+A_2-A_3\), making
the quadratic identity primitive-idempotent machinery rather than a roux
continuation.

Two by-products are general rather than golden-specific: universal first and
second balanced-cut singular-value moments for every symmetric order-\(2m\)
conference matrix, and exact Paley order-fourteen and order-eighteen censuses
in which determinant strata already coarsen projective-linear orbits while
sharp three-transitivity upgrades oriented strata to \(3\)-designs, including
the maximum-cut designs \(3\text{-}(14,7,35)\), \(3\text{-}(18,9,63)\), and
\(3\text{-}(18,9,84)\). Their first nonautomatic incidence invariant is the
degree-four cross-ratio signature, which separates the two order-eighteen
maximum designs and the two determinant-\(2048\) orientation behaviours and is
a complete orbit invariant on every audited cut. A Cauchy--Binet refinement
splits the order-ten determinant into exactly two internal squared-minor energy
profiles and proves both antipodal cut frames have spherical design strength
exactly three; the extremal profile factors as \(t(t-5)^4\), every extremal
principal half has a sign kernel vector and borders — uniquely up to switching
the added vertex — to a symmetric order-six conference matrix, while the
converse border forces determinant \(48\). The \(36\) Sylvester vertices
therefore carry local \(10\to6\) retractions; their marking quotient to the six
golden sisters is open.

### Measurement, fermions, and anomalies

The two golden eigenspaces are Naimark-complementary \((6,3)\) real ETFs and
minimally informationally complete real-qutrit POVMs, but are neither
complex-qutrit informationally complete nor SICs. In the common six-path
dilation the cross-golden block is a postselected transfer Kraus operator whose
antisymmetric three-copy success probability is exactly \(Z_T^2/500\). Thus
\(A=dZ\) is amplitude response, \(W\) is centered success-probability contrast,
and inverse polarity recovers the projective signed amplitudes off \(e_5=0\).
Signed-moment cancellation from \(C^2=5I\) gives the sharp bound
\(|Z_T|\le8\), with maximum success \(16/125\) exactly on the twenty balanced
\(3+3\) phase vertices; at every optimum the squared singular spectrum is
\(\{4/5,4/5,1/5\}\), and the three-filter protocol is query-optimal in the
coherent black-box model. The twenty controls are the oriented lifts of the ten
Segre nodes and maximize all six protocols simultaneously, yet all optimal
probability contrasts vanish: \(W=e_5=0\).

On that optimal middle layer the signed cubic map is the exceptional outer
transform — it preserves complements, exchanges intersection sizes one and two,
and realizes the two orthogonal five-dimensional Johnson constituents. It is
cubic in both directions and correlation-immune through order two. At balanced
controls it is also a lossless three-fermion interferometer and a signed
\(K_{3,3}\) Majorana family with energies \(\{2,4,4\}\) and Pfaffian \(\pm32\).

The Segre identities are the six-Weyl \(U(1)\) anomaly equations. The \(44\)
nonbalanced real phase masks have zero amplitude and the \(20\) balanced masks
give vectorlike nodes, whereas the admissible filter \((-3,-2,-1,0,1,3)/3\)
produces the primitive chiral anomaly-free vector \((11,-10,-8,5,4,-2)\)
projectively. For two Abelian factors, anomaly cancellation is exactly line
containment on the Segre cubic: in the frozen marking the fifteen plane
components are the fixed path collisions, the six split degree-five del Pezzo
components are the six choices of one moving path control with the other five
fixed, their five vectorlike crossings form a synthematic-total component
syndrome, homogeneous control degree one is minimal, and through a generic
amplitude point the six chiral directions are exactly the six columns of the
response matrix \(dZ\), each itself anomaly-free and mixed-compatible. The two
mixed anomalies are the two mixed determinant--Pfaffian sums.

The amplitude map itself is the classical
\((\mathbf P^1)^6/\!\!/\operatorname{PGL}_2\) quotient with an explicit rational
inverse in the frozen path marking. Its pair-collision divisor is
simultaneously the pullback of the fifteen vectorlike planes and the
inverse-polar exceptional divisor, with
\(e_5(Z)=32\prod_{i<j}(x_j-x_i)\); the ten nodes are the \(3+3\) closed orbits,
six distinct paths give the smooth nonvectorlike locus, and strict chirality
also excludes \(Z_T=0\). A normalized preimage \(Z=\lambda q\) has exact
success \(p_T^{(3)}=\lambda^2q_T^2/500\). The standard primitive path is
uniquely minimal up to sign at common-affine height three but is not
success-optimal: the real orbit optimum improves success by
\(1.141022808280276\ldots\) and is only a supremum over rational filters.
Second-order closeout gives \(\prod_{T<U}(Z_T+Z_U)=-e_5(Z)^3\) and reduces
exact physical optimization on every smooth real fibre to seven pole chambers
with critical equations of degree at most four.

### Majorana parity chambers

The oriented real control sphere has exactly \(860\) gapped chambers: \(720\)
unbalanced chambers, \(24\) for each of \(30\) sign vectors, and \(140\)
balanced chambers, seven for each of \(20\) sign vectors. The generic adjacency
graph is connected of diameter ten, has \(2{,}160\) edges, and degree
distribution \(3^{720},12^{120},36^{20}\). It is the coset-incidence graph of a
regular \(S_6\)-orbit with balanced stabilizers \(S_3\times S_3\),
\(S_3\times S_2\), \(S_3\times S_2\); subgroup-factor width five explains
diameter ten, and the antipode exchanges the two 60-chamber pole orbits.

The \(140\) balanced indicators form \(M^{(3,3)}\oplus2M^{(3,2,1)}\). Their
exact incidence Gram operator has rank \(138\), with only the two forced
orbit-constant relations, and a standard-character projection labels the last
equal-dimensional ambiguity: \(S^{(5,1)}\) carries the eigenvalue four and both
quadratic packets, while \(S^{(3,3)}\) carries \(40,12,8\). The standard
block's antipode-even \(2\times2\) intersection operator has discriminant
\(16\cdot13\), and its odd block has one eigenvalue-four dark line with a
residual packet exactly three times the even packet. So \(\mathbf Q(\sqrt{13})\)
is an explained coset-spectral field, distinct from the golden coefficient
field \(\mathbf Q(\sqrt5)\).

Simultaneous closing multiplicities are exactly one, two, four, or six, and the
common six-wall locus is the reduced fifteen-line unstable base scheme, with
generic rank four and the six rank-two dimer vertices. Each gapped
six-Majorana class-D parity component is
\(SO(6)/U(3)\cong\mathbf P^3(\mathbf C)\), so there is no protected monodromy or
parity pump without added spatial, boundary, or defect structure.

The conference signing survives diagonal Majorana gauge as a nontrivial
\(\mathbf Z/2\) cycle flux on \(K_6\), but it is none of the sixteen Pauli
quadratic refinements and supplies no spin structure without extra
surface-embedding data; total-order antisymmetrization is noncanonical and
gives three spectral classes. The canonical positive replacement is the chiral
free-fermion family \(A_C(x)=[D_x,C]\): it anticommutes with \(C\), exchanges
the two golden three-spaces, and satisfies \(\operatorname{Pf}A_C=4Z_C\) and
\(\det A_C=16Z_C^2\). Hence the Joubert cubic is exactly its zero-mode and
fermion-parity wall, and its six nodes are precisely the rank-two cross-golden
dimers, each leaving four Majorana zero modes.

### Symmetry, exceptional, and lattice boundaries

- The full \(S_6\) Clifford extension is nonsplit; the conference \(S_5\)
  splits with two classes and the golden \(A_5\) with four; the distinguished
  conference twist is nonzero and nonextendable from \(A_5\) to \(S_5\); the
  scalar multiplier is trivial; and the six conjugate local \(S_5\) charts meet
  pairwise in \(S_4\) but do not glue.

- The Segre--Igusa mixed differential realizes the exceptional outer exchange
  between the synthematic-total Clifford-chart action and the ordinary
  conference-axis action, transporting the two classes of \(S_5\) in \(S_6\)
  rather than identifying their elements. Its frozen finite \(W_{10}\) exchange
  has order eight, so the operator alone selects no involutory polarity; all
  \(36\) inner normalizations survive, and the conference marking cuts them to
  the axis-indexed six-pack. They form one twisted-conjugacy orbit with
  stabilizer \(F_{20}\), explaining both \(36=720/20\) and \(6=120/20\), so the
  two golden six-sets are canonically \(S_5/F_{20}\). Complete
  \(\mathbf F_2,\mathbf F_3,\mathbf F_5\) doily incidence-code tables show the
  ranks do not explain the bad primes, and the sole CSS output is the standard
  binary \([[15,5,3]]_2\) code.

- The Coble conormal scalar lifts exactly to characteristic zero: in
  determinant-valued normalization the inverse-polar scalar is the source
  Hessian determinant, and the common affine-\(E_8\) parent is exact. The
  frozen Burkhardt branch sextic has Galois group exactly \(S_6\), so its
  one-point Vinberg marking first exists over degree six while the ordered
  Joubert marking lives on the degree-\(720\) splitting torsor; over the
  one-point field the remaining five points have full \(S_5\) monodromy, which
  closes intrinsic ordered recovery negatively. Full level-two marking is the
  exact repair, computed on all \(720\) sheets, and the Vinberg
  principal-Pfaffian cubic is identified with the frozen Jacobian Coble orbit by
  the Rains--Sam inverse theorem. The residual \(S_5\)-torsor records
  unavoidable noncanonicity, not unfinished work.

- The McKay affine-Cartan quotient and Hamming Construction-A \(E_8\) are
  explicitly isometric, including the affine root determined by the \(2.A_5\)
  dimension vector, but no simultaneous Clebsch marking exists: all \(180\)
  two-coordinate \(R_{10}\) minors miss \(H_8\), the ten-node module has no
  equivariant rank-eight carrier under \(S_6\), \(S_5\), or \(A_5\), and
  \(Q_{10}\) contains no unmarked \(E_8\) root subsystem. The exact positive
  replacement is \(L_{R_{10}}\oplus L_{R_{10}}^*\cong II_{10,10}\), where the
  exceptional isodualities exchange maximal isotropic halves and
  self-adjointness recovers exactly the \(36\) involutory polarities with
  \((5,5)\) graph eigenspaces.

### Provenance and its sharp boundary

Every projective or even golden shadow descends from the unordered support
two-graph — the exact minimal quotient of the monomial Clebsch code class —
by an orbit-incidence descent argument, and the \(A_6\)-orbit completes one
recovered class to the coherent outer six-family. One support-half bit is then
minimal for the signed odd shadows, while golden conjugation independently
exchanges the paired cross-golden resolutions and rank-one MCM summands.

The boundary is sharp in the other direction: the unlabelled deep-hole conic
alone is insufficient, since its \(\operatorname{PGL}_2(11)\) action is
transitive on the \(22\) Clebsch matching rows and no row-to-geometric-parent
bridge is supplied. The determinant sextic and dimer fingerprint close the
reverse cycle exactly at the unoriented two-graph level and no further.

### The six determinantal nodes, certified and machine-checked

For every golden sister the cubic determinantal wall \(\{Z_T=0\}\) has exactly
six singular points, the centered five-plus-one collision configurations
\([\mathbf1-6e_i]\), all rational ordinary double points and common to all six
walls. Their presence is elementary — at a five-plus-one collision every
perfect matching has two pairs inside the five-point block, so every
matching-bracket cubic vanishes to second order — and exact projective Jacobian
elimination rules out any other singular support: in the centered gauge the
homogeneous Jacobian ideal has projective dimension zero, one chart contains
the whole singular scheme, and its quotient algebra is reduced of dimension six
with six minimal primes. The statement is now kernel-checked in Lean rather
than resting on the earlier symbolic census: the centered lift, the cubic, and
its gradient are defined formally, the cubic is identified with the triangle
cubic of the fixed conference matrix, the five displayed quadrics are proved to
be its formal coordinate derivatives, and the elimination is carried by exact
ideal-membership identities reproved by Lean's linear-combination tactic.

### What the exchange-statistics reading does and does not add

A separate companion in this programme asks what the fermionic protocol
measures, and answers it in two layers, one general and one golden.

The general layer is an orbit theorem. For a linear map \(K:V\to W\) between
real Euclidean spaces of dimension \(n\ge2\), the double orbit under
\(O(W)\times O(V)\) is determined by the singular values; restricting to the
special orthogonal groups splits each invertible orbit into two, distinguished
by the sign of the oriented determinant, and the two merge on the singular
locus because a reflection can be absorbed in a zero singular direction. So the
intrinsic object is not a scalar but the top exterior map
\(\bigwedge^nK:\det V\to\det W\); orienting the two determinant lines turns it
into a signed scalar, reversing one port orientation reverses that scalar, and
the determinant-zero hypersurface is exactly where the oriented label
disappears. Relatedly, a degree-\(n\) polynomial transforming by
\(\det(R_-)\det(R_+)\) under frame changes is a scalar multiple of the
determinant, so the top exterior amplitude is the unique lowest-degree carrier
of that character. This is classical invariant reasoning and is claimed as
such. The permanent does not descend even through the special-orthogonal double
orbit.

There is also a universal reason the zeros sit where they do. For any
orthogonal \(d+d\) splitting of \(2d\) paths and any Boolean negative support
\(S\), \(\operatorname{rank}K_S\le\min(|S|,2d-|S|)\), so a filled
\(d\)-fermion determinant can be nonzero only at a balanced control. In
dimension three that universal obstruction accounts for the \(44\) unbalanced
zeros, and it is golden equispectrality — every balanced control invertible
with the same squared singular spectrum — that supplies the twenty nonzero
cases. The twenty-versus-forty-four boundary is therefore only half golden.

The permanent-side complement exists but is orientation-blind. The intrinsic
bosonic companion of the filled-fermion transfer is the trace of the transfer
on the symmetric cube: with \(K=Q_-^{\mathsf T}D_xQ_+\) and \(H=K^{\mathsf T}K\),
the total three-boson transfer probability is
\(\operatorname{tr}(\operatorname{Sym}^3H)=h_3(H)\) against the fermionic
\(\operatorname{tr}(\bigwedge^3H)=\det H\), and at every balanced mask for every
golden protocol the spectrum is \(\{1/5,4/5,4/5\}\) with
\(h_3=313/125\), \(\det=16/125\), and the exact difference
\(\operatorname{tr}(H)\operatorname{tr}(H^2)=297/125\). The bare permanent of
\(K\) is not a golden scalar at all — it depends on the ordered orthonormal port
bases — so a coherent calibrated permanent can retain the oriented control while
no probability-only intrinsic bosonic measurement can.

The physical demonstrator is a **no-go for 2026 hardware**, for one specific
reason: the required totally antisymmetric state of three photonic qutrits has
linear-optical preparation proposals but no located experimental realization,
and the demonstrated two-photon emulator does not close that gap. The best
directly relevant three-qutrit benchmark reaches fidelity \(0.910(6)\) at about
\(1.1\) fourfold events per second, far short of what the small chiral branch
needs. A bounded precursor is a go: implement and phase-characterize the
six-mode golden transfer with coherent light and run the ordinary three-boson
collision-free controls, which measures the calibrated transfer and its
determinant signs but must not be described as a direct three-fermion phase
measurement. The companion is accordingly written as a design-limit and theory
note, not an experimental proposal, and its attribution audit found the
determinant/permanent and partial-distinguishability background, the
conference-matrix and real equiangular-tight-frame dictionary, the real
six-line measurement, the Joubert–Segre invariant theory, and the anomaly
parametrizations all to be prior art now explicitly credited, together with one
material omission repaired — a second interferometric proposal for preparing
the \(N\)-particle, \(N\)-level singlet including the three-particle case.

### Priority: five clean pre-emptions in this programme

A full literature audit of the frozen manuscript found five clean
pre-emptions, two of them close to verbatim, and they bind anything drawn from
this section.

- **The centered-square formula is Howard–Millson–Snowden–Vakil's, verbatim.**
  Their Segre-to-Igusa duality map prints \(W_T=Z_T^2-\tfrac16\sum_UZ_U^2\)
  together with the Igusa equation and the inverse map. The derivation here via
  Newton's identities is a rederivation.
- **The six sisters, the five-cycle normal form, and the unordered support
  split are theirs and Seidel's.** The six mystic pentagons, the twelve
  five-cycles pairing into six under complementation, the six splits of the
  twenty triangles under exactly the conditions used here, and the identification
  of the \(S_6\)-action as the outer automorphism are all in
  Howard–Millson–Snowden–Vakil; Bussemaker–Mathon–Seidel add that the order-six
  conference two-graph is unique with automorphism group \(A_5\).
- **The Fano-component realization is largely Gripaios–Nguyen's** — the fifteen
  planes and six split degree-five del Pezzo components, the transitive
  \(S_6\)-action with stabilizer \(S_5\), the syntheme labelling, and the count
  of six lines through a generic point of the Segre cubic.
- **The order-ten shadow is a classical object.** Fickus–Mixon identify
  symmetric conference matrices of order \(N\) with the sign Gram matrices of
  real equiangular tight frames in dimension \(N/2\), and
  Bussemaker–Mathon–Seidel give the order-ten conference two-graph's
  uniqueness, its eigenvalues \(\pm3\), its automorphism group
  \(\operatorname{Sp}(4,2)\cong S_6\), and the switching class containing the
  Petersen graph.
- **The rational anomaly inverse is prior art**, as the source text already
  conceded.

What survives with no located predecessor is the operator layer: the
commutator-Pfaffian and middle-exterior presentations of the Joubert cubics,
the golden eigenspace compression with its determinantal and maximal
Cohen–Macaulay package, the Jacobian adjugate identity, the balanced-cut
maximum-determinant characterization of \(C^2=5I\), the synchronized
pure-spinor product, the unmarked-reconstruction boundary, and the exact
anomaly-cost clauses. The real picture is that the operator layer holds while
the classical-geometry layer is thinner than the earlier framing suggested;
four statements need attribution surgery rather than retraction.

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

That classification compresses almost to nothing. For 2630 of
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

The even branch closes by a congruence rather than a search. The sole
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

### Quantitative rigidity

Rigidity is stable, not merely exact. For two product-unitarily related
equal-phase \([6,3,4]_q\) MDS--CSS states with phase-optimized global vector
error \(\varepsilon\), every local factor lies within normalized
Hilbert--Schmidt distance
\[
 2\sqrt2\,q^2\varepsilon
\]
of an additive Clifford, below an explicit prime-field commutator threshold;
the four-party marginal form of the same bound is \(\sqrt2q^2\eta\). Weyl
products, commutators, and character averaging close the gap from approximate
axes to an implementing Clifford.

The bound is uniform across the enlarged extension-field kernels only for the
full prime-field Clifford target. Exact \(q=9\) nonsemilinear and \(q=25\) GRS
symplectic elements rule out every uniform semilinear, split-torus, or
Desarguesian-spread upgrade — even at zero error, so this is a structural
obstruction rather than a loss of precision.

### The Clebsch syndrome bridge

A generic coset/syndrome dictionary underlies the finite examples: translated
equal-phase states are classified by code cosets, distinct cosets are
orthogonal, dual-code phase stabilizers read the translation character, every
syndrome has exactly one representative on each three-party support, and
minimum weight three forces full support.

Applied to the Clebsch \([6,3,4]_{11}\) state, the twelve conic rays, \(120\)
syndromes, and transitive \(C_{10}\times A_5\) orbit combine with that
uniqueness to show that either side of every balanced \(3\mid3\) cut can create
the same extremal translate. The defining arc is nonconic, so the fixed-party
logical image is the split torus \(T\), not \(\operatorname{SL}_2(11)\); this is
a distinct statement from the computed \(S_5\) party image, and it supports no
Hamiltonian or golden-operator claim.

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

The arbitrary-\(m\) marginal-to-rigidity chain and the generic coset/syndrome
dictionary are formally verified, the latter isolating the Clebsch statement as
a two-paragraph structural lemma composed with a conic/count/orbit theorem and
a nonconic logical-phase theorem. The
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
cubic pieces in the conic matching quotient have a literal ambient
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

### Two exact non-code consequences

A full-document cross-area audit adds two statements that are not about codes
at all. The sparse sextic is the unique reduced point of the self-dual two-pole
Schubert problem \(\sigma_{(2,2,1)}^2=1\), with Wronskian \(x^5y^5\). And the
projected rational sextic is arithmetically Buchsbaum with Hartshorne--Rao
module \(k^2(-1)\), which identifies its defect-two jet quotient with its
complete projective-normality deficiency.

### The Klein \(E_8\) operator programme

An independent exploration attached to the same Clebsch material studies a
transvectant-derived operator on the Kleinian \(E_8\) invariant ring
\(R=\mathbf Q[f,h,t]/(t^2-h^3-1728f^5)\).

The affine \(E_8\) McKay test is resolved: \(\operatorname{Sym}^6=3'\oplus4\)
and \(\operatorname{Sym}^{12}=1\oplus3\oplus4\oplus5\), so the transvectant is
the unique common-vertex selector and rank four is forced. The ordinary MCM
lift is only a split identity on \(M_4\), not a new matrix-factorization
bridge. Internally, however, \(\delta(a)=(a,\Phi_{12})_3\) restricts to a
non-\(R\)-linear differential operator of exact order three and degree \(+6\)
on \(R\), whose complete fourteen-term normal-ordered expression is known and
independently replayed. The Klein \(E_8\) cubic is intrinsic to it: it is the
radial third-transvectant symbol, and on every McKay covariant block the full
principal symbol is \(10p\) times multiplication by the odd invariant \(t\),
uniformly selecting the classical \(E_8\) matrix factorizations.

The operator's graded behaviour is settled in all weights.

- The global two-sided defect vanishes for every \(n>52\), and its thirteen
  exact exceptional degrees are
  \(0,1,2,6,10,11,12,20,21,22,32,40,52\). Degree \(22\) is uniquely compatible
  with a repeated isotypic summand and is the sole certified full-corner
  failure.

- Every McKay block is maximal-rank in every weight. Exact global
  falling-factorial Weyl operators in the invariant exponents \((F,h)\) realize
  the third and ninth transvectants on the complete \(2,3,3'\) free modules,
  eliminating phase-specific operator construction; block three-term
  recurrences, signed block Wronskians satisfying the exact Green identity, and
  scalar \(C_5\)-chain boundary obstructions close all sixty-three
  modulo-\(60\) plateau entrances, so every graded path corner propagates.

- The local-return gate closes in a stronger form than asked: the nearest lower
  and upper Gram returns already generate every McKay block corner except the
  exact \((\mathbf3,22)\) failure, making the two-step upward return redundant.
  On every nontrivial block this two-return presentation is generator-minimal,
  and both generators are canonical positive Fischer energy forms.

- The previously unexplained virtual levels \(0,\pm1/3,\pm2/3\) are the
  order-three \(h=0\) indicial roots in the degree-\(60\) \(h^3/F^5\) level of
  \(t^2=1728F^5-h^3\). Source-chain residue counts give
  \[
   \det K_-(j)=C\prod_{s=0}^2\bigl((3j+s)_3\bigr)^{c_s},
  \]
  which explains every factor multiplicity, the identical normalized \(3,3'\)
  determinants, and the phase-independent \(6\)-profile.

Under the classical normalized transvectant and Bombieri--Fischer form, the raw
degree-ten scalar reduces from \(211625906798592000\) to \(64/1575\), while the
intrinsic golden factor \(st^6\) is unchanged. The combined normalized
operator/polar/incidence package has minimal base \(\mathbf Z[1/30]\) and
structural bad primes exactly \(2,3,5\); an \(11\)-elementary dodecic lattice
removes the apparent operator failures at \(7,11\), and the cross-Gram scalar
image — but not the normalized golden cover — has collision primes \(11,23\).
At \(23\) that image is the conductor-\(23\) suborder of the inert golden
algebra, and globally it is the conductor-\(253\) order over
\(\mathbf Z[1/30]\), whose only normalization defects are the split prime
\(11\) and the inert prime \(23\).

### The \(E_6\) minuscule twenty-seven

The strongest outward connection is the \(A_1\times A_5\) minuscule branching
\(27=12+15\). The double-six supplies the twelve lines, and the complementary
fifteen are canonically recovered from the unique cubic through those twelve
embedded lines. The operator-derived configuration carries the exact minuscule
\((2\otimes6^\vee)\oplus\bigwedge^26\) weight dictionary, all \(45\) tritangent
planes, and the Cartan cubic's mixed-plus-Pfaffian monomial support. Row
exchange is the \(A_1\) Weyl reflection — not Galois conjugation and not the
outer automorphism exchanging \(27\) and \(27^\vee\).

The abstract graded Cartan carrier has exact \(6|15|6\) cocharacter and signed
mixed-plus-Pfaffian cubic, and the row permutation requires an order-four
linear Weyl lift. The raw Cartan tensor descends exactly to the six-axis
orientation field \(\mathbf Q(\sqrt5)\); rational descent needs a determinant
twist on one row. Krämer--Litt--Maculan Hodge conjugation instead relates
\(V_L\) to \(V_{L^\vee}\) and so belongs to the outer side. With no
cohomological or Higgs realization, this is a graded Cartan model but **not** a
model of that variation; the exact full-\(27\) Galois action preserves both
rows and realizes the definition-field tower
\(\mathbf Q(\sqrt5)\subset\mathbf Q(\zeta_5)\), which is not a monodromy
trace-field statement.

## Unassigned adjacent results

### Residual multipliers for Hadamard order 668

Order \(668=4\cdot167\) is one of the smallest open Hadamard orders, and the
Legendre-pair route reduces to a census of possible fixed common multiplier
subgroups for length \(333\). Of the \(30\) mod-\(3\)-compatible subgroups,
\(21\) were excluded by published proof-carrying work; that baseline is
reproduced here and pushed to \(25\) by two independent mechanisms.

### A congruence on the nine-compression

Let \(H\) be the order-six subgroup generated by \(\{73,85\}\) or by
\(\{73,121\}\). For an \(H\)-invariant sign sequence the \(9\)-compression has
the shape \((c_0,x,y,c_3,x,y,c_6,x,y)\). The fixed columns have
multiplier-orbit sizes \(1,6,6,6,6,6,6\), so each \(c_i\) lies in
\(\{\pm1,\pm11,\pm13,\pm23,\pm25,\pm35,\pm37\}\) and is \(\equiv\pm1\pmod{12}\),
while the two moving orbits have stabilizer of order two, making \(x,y\) odd.
Normalizing each sequence to row sum one gives \(S+3(x+y)=1\) with
\(S=c_0+c_3+c_6\), which forces \(S\equiv1\pmod{12}\) and
\(x+y\equiv0\pmod4\). The shift-one compressed autocorrelation
\(R=S(x+y)+3xy\) is then \(\equiv5\pmod8\) in both admissible branches, so the
two compressions contribute \(2\pmod8\) while the Legendre compression identity
requires \(37\cdot(-2)=-74\equiv6\pmod8\).

### An orbit lock at shift 111

The second mechanism is a distance count. For a multiplier subgroup \(H\) and a
nonzero shift \(s\), let \(L_H(s)\) be the number of positions \(x\) with \(x\)
and \(x+s\) in the same \(H\)-orbit. Every \(H\)-invariant sign sequence agrees
at those positions, so \(D_u(s)\le333-L_H(s)\), while a Legendre pair needs
joint Hamming distance \(334\) at every nonzero shift. One shift therefore
excludes \(H\) as soon as \(L_H(s)\ge167\).

For the subgroup generated by \(\{73,112\}\), invariance at shift \(111\) forces
equality on all \(222\) nonmultiples of three, capping the joint distance at
\(222\); the subgroup generated by \(\{112\}\) falls the same way at shifts
\(111\) and \(222\). An exact six-case census shows this criterion does not
exclude the other five residual subgroups, so the mechanism is exhausted rather
than merely untried.

Hence \(25\) of the \(30\) subgroups are impossible, five residual cases remain,
and every subgroup of order six is closed. No Legendre pair and no Hadamard
matrix of order \(668\) is constructed here, and unrestricted order \(668\)
remains open.

## Two open programmes

### Complete arcs of square-root size relative to a conic

The construction problem behind the exact values of \(\rho_{\mathcal C}(q)\):
build \(\mathcal C\)-complete arcs of size \(O(\sqrt q)\), or prove an
infinite-family obstruction. The shape of the difficulty is sharp, and it
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
defect while dropping rank from 27 to 2. The created defect is traceable, inheriting the label of the causal half-move,
and two distinct marked projective replacement types — one created by the
opponent's half-move through endpoint degradation, one by the reply through
deletion of its own certificate — each close by a bounded local mechanism.

The stronger causal-local hope is dead, and the counterexample says where to
look instead. Uniform per-causal-move certificate-exchange nonpacking fails
already over \(\mathbb F_{11}\): for
\(A=\{(1,3),(5,2),(9,6),(10,1)\}\), \(o=(4,4)\), \(h=(7,10)\), both \(o\) and
\(h\) are defects of \(A\), while \(\operatorname{Def}(A+o)=\emptyset\) and
\(\operatorname{Def}(A+o+h)=\{(0,5),(6,5)\}\). The causal reply \(h\) was
itself a shared old certificate for both new fibres, so selecting it consumes
both copies and one causal label necessarily branches; a primary bitmask run
and an independent affine-determinant replay agree. The same witness still has
global cardinality surplus — seven old defect labels disappear and only two
genuinely new defects appear — so the live proof object is global rather than
causal-local: a Hall-type rematching that assigns every new defect a distinct
consumed ancestral label, with strict total support descent, described by
bounded projective incidence data and hereditarily compatible with the
overload coordinate and its boundary. The conditional causal-label theorem
itself remains correct; what the witness kills is the uniformity of its
hypothesis.

Ruled out along the way: any fixed finite exact residual signature, since sealed
conic subsets already give unboundedly many second-player-win heights; every
scalar extremal selector tested; and unrestricted coordinate encodings, which
are vacuous because a natural number can encode the whole residual.

## Status summary

- ***Reconstructing the Clebsch code and its golden orientation from its
  deep-hole syndrome locus:*** mathematics complete, including the golden
  orientation torsor and the structural determinantal six-node proof; the
  computational strengthenings travel in a companion, *Computational
  strengthenings of Clebsch syndrome rigidity*, with a five-mode claim ledger.
  What remains is publication packaging. The all-sizes extension of the
  conic-filling classification is **not proved**: it is complete over every odd
  field up to \(43\), the saturated branch is closed uniformly and the
  nonsaturated branch reduced to slack at least two, and the exact remaining
  obstruction is an upper bound on the largest arc whose secants all avoid a
  fixed conic — measured to be tight, so possibly false.
- ***Quadratic trade rigidity and cubic orientation in conic matching
  quotients:*** complete theorem arc, with the one-factorization property
  derived rather than assumed and the completeness theorem naming the two
  occurring configurations; public packaging remains.
- ***Golden descent and operator realizations of the Clebsch cubic:*** both
  prior proof gaps closed — the chart factorization is scheme-theoretic through
  a global Stein algebra, and the two realizations share one marked orientation
  source. The forward version has absorbed a bounded operator core as one chain
  from the incidence descent to the harmonic return, plus the
  determinant-versus-permanent boundary; the released versions one and two are
  unchanged and keep the earlier title. The strongest bridge is explicitly
  relative to a marked datum with a complete ambiguity ledger; artifact locator
  and author metadata remain.
- ***A binary [78,36,12] code from the passant lines of a conic over
  \(\mathbb F_{13}\):*** minimum distance, the 364-word minimum layer and its
  four orbits, spanning, reconstruction of the passant incidence rows and the
  elliptic scheme, and the exact automorphism group are proved by a human
  argument, with a semantic Lean spine and sharded finite leaves supporting it.
  The published interval for this code's minimum distance was
  \(8\le d\le12\); this closes it at the top and adds everything above it. Four
  concrete transports and public release remain.
- **The golden conference operator source programme:** mathematics proved and
  frozen across the cubic, polar, determinantal, pure-spinor, Boolean,
  measurement, fermionic, anomaly, Clifford, and lattice shadows, with the
  six determinantal nodes now certified by exact elimination and machine-checked;
  provenance descends from the unordered support two-graph with a sharp
  insufficiency boundary for the bare deep-hole conic. It is no longer a
  manuscript of its own — it feeds forward versions of the paper above. Its
  literature audit found five clean pre-emptions, two close to verbatim, so the
  classical-geometry layer needs attribution surgery; the operator layer has no
  located predecessor. The exchange-statistics companion adds a general oriented
  top-exterior theorem, a universal balance obstruction that explains the
  unbalanced zeros without golden input, and the symmetric-cube permanent-side
  invariant, but the full photonic demonstrator is a no-go on 2026 hardware and
  only a coherent-light precursor is available.
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
  every stabilizer AME state, not only the MDS–CSS family, and stable under
  approximate equality with explicit constants; the marginal-to-rigidity chain
  and the coset/syndrome dictionary are formally verified, the encoder and
  transversal-group consequences are not. Uniform semilinear reconstruction is
  false even at zero error.
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
  Rees-algebra functor, and master Fano correspondence remain open.  The
  next independent bridges are the contraction algebra of the width-three
  pagoda and globalization of the pointed Rees filtration to a
  K-stability test configuration.  The attached Klein \(E_8\) operator
  programme is graded-complete: the two-sided defect is classified in
  every weight with thirteen exceptional degrees, every McKay block is
  maximal-rank in every weight, the two-return presentation is
  generator-minimal, and the virtual levels are explained as indicial
  roots.  Identifying the operator algebra and spectrum is the surviving
  frontier there, and it is separate from the marked icosian comparison,
  which is ruled out: no such comparison exists in the required
  equivariant category.  The \(E_6\) minuscule branching \(27=12+15\)
  supplies a graded
  Cartan model but no cohomological or Higgs realization.
- **Unassigned adjacent results:** \(25\) of the \(30\) mod-\(3\)-compatible
  fixed common multiplier subgroups for Hadamard order \(668\) are impossible,
  by a nine-compression congruence and a shift-\(111\) orbit lock; five cases
  remain, no matrix is constructed, and the order remains open.
- **Open programmes:** square-root complete arcs and the odd-plane cap game,
  both with substantial partial results and explicitly no global claim. The cap
  game's causal-local route is falsified by an explicit \(\mathbb F_{11}\)
  witness; the live target is a global Hall-type rematching.
