# Portfolio results summary snapshot

**Date:** 2026-09-04

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
4. *Minimum-word reconstruction of \(\operatorname{PG}(2,13)\) from a binary
   conic code* — a code whose minimum words reconstruct the geometry and the
   full symmetry group they came from. It was earlier titled *A binary
   [78,36,12] code from the passant lines of a conic over \(\mathbb F_{13}\)*.
5. *The Golden Companion Correspondence* — the marked chordal member of the
   same \(A_5\)-invariant cubic pencil as the conference member in sections 1
   and 3, with an exact oriented return to the six-axis carrier.
6. The cubic-threefold stabilization programme — the exotic cubic realization
   of the golden carrier. For every smooth complex cubic threefold \(X\), the
   product \(X\times\mathbf P^1\) is irrational; every smooth \(A_5\)-invariant
   cubic threefold in Roulleau's pencil is universally \(CH_0\)-trivial; and two
   explicit smooth cubic threefolds have exact stabilization level two. The
   one-stabilization epilogue and the exact-level-two paper are separate
   manuscripts. An older all-\(m\) route remains only as a conditional research
   programme.
7. The golden conference operator source programme — one marked order-six
   conference operator and the cubic, polar, determinantal, fermionic,
   anomaly, and lattice shadows it generates. This is a source-development
   body of mathematics feeding future forward versions of the paper in
   section 3, not a manuscript of its own.
8. *Secant defects with prescribed holes: arcs, caps, and matching
   designs*.
9. *Integral Secant Distributions and Improved Bounds for Complete
   \((k,n)\)-Arcs* — exact integer degree envelopes and modular-lift
   improvements for complete higher arcs.
10. *High-Weight Cosets of Generalized and Extended Reed–Solomon Codes*.
11. *Exact Transfer of Bounded Linear Recovery and Relative Weight
   Hierarchies* — local memory, exact rank-stratified transfer, and
   compositional recovery costs.
12. *Local-Unitary Rigidity and Quantitative Rounding for Stabilizer AME
   States* — every product-unitary intertwiner of a stabilizer absolutely
   maximally entangled state is local Clifford.  The transversal-group half of
   this material now stands alone as *Diagonal Isoduality and Transversal
   Clifford Groups of MDS–CSS Codes*.
13. *Frobenius-equivariant pair extension and robust repair of eight-arcs* —
   extending Frobenius-invariant arcs by conjugate point pairs.
14. *Semilinear rigidity of four-point-frame continuation graphs* — an abstract
   graph that remembers its ambient plane.
15. *The Clebsch Schur--Sarkisov spine* — the conic deep-hole port
   Schur-generates the two outer Fano modules, while the conic-link code is
   their defect-two jet modification.
16. *The discrepancy-one case of the Shen--Shoemaker extremal flip spectrum* —
   a short standalone correction note that supplies the two steps their proof
   chain omits, so their conclusions cover every codimension-two blow-up.
17. Unassigned adjacent results: a bridge from Brouwer's exceptional
   exterior-set census to the Clebsch hexagon, a residual-multiplier exclusion
   for Hadamard matrices of order 668 together with the class-exclusion
   programme at the new smallest open order 2092, a certified finite no-go for
   diagonal transversal non-Clifford gates, certified eliminations for
   projective planes of order twelve, the query complexity of reconstructing an
   aligned design, and a ladder of binary codes along the exceptional root
   systems that is proved but closed as a publication route.
18. Two open programmes with substantial partial results: complete arcs of
    square-root size relative to a conic, and the outcome of the cap game on
    odd projective planes.
19. *The Gram–discriminant shadow of four points and its Dickson tower* — the
    square-class coloring that a four-point Veronese Gram determinant induces
    on unordered four-subsets of a projective line, the family of hyperelliptic
    covers whose Frobenius traces control it, and the reconstruction theorem it
    forces. Not currently assigned to a manuscript.

The first five sections are the five numbered papers of *Clebsch: Rigidity from
Sparse Shadows*, in that order. The separately titled MDS--CSS
transversal-groups paper is an unnumbered companion whose Clebsch code is a
worked application. The first three released series papers carry the titles
under which versions one and two were published; where a forward version has
changed a title, the section says so.

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

Both inputs that were previously cited at order eleven are now proved from
scratch and machine-checked in Lean. Counting triple-concurrence points of a
six-arc is the same as counting its concurrent chord matchings, by a bijection
valid in an arbitrary finite projective plane, and the bound of ten such points
is a theorem over every field in which two is invertible. Equality is rigid in a
strong form. When a six-arc has ten triple-concurrence points, every chord lies
in exactly one non-concurrent chord matching, there are five such matchings, and
they share no chord, so they one-factorize the fifteen chords; two matchings of a
six-element set with no common chord close a hexagon; and the labelling that
produces puts the arc in the golden normal form
\[
 (1{:}0{:}0),\ (\varphi{:}1{:}1),\ (0{:}1{:}0),\ (1{:}\varphi{:}1),\
 (0{:}0{:}1),\ (1{:}1{:}2-\varphi),
 \qquad \varphi^2=\varphi+1,
\]
in a suitable frame, over any finite field in which two is invertible. Attaining
the bound therefore forces a golden root into the ground field. At order eleven
the two roots are \(\varphi=4\) and \(\varphi=8\), and each carries its golden
hexagon onto the displayed witness by an explicit projectivity of determinant
three. The older route through prism uniqueness and the perspectivity theorem —
two triangles in double perspective are in triple perspective, itself proved over
an arbitrary field — is off the critical path and unused.

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

The saturated-internal branch is reduced to a pure clique question and is closed
outright in one residue class. Dropping the arc condition and keeping only chord
externality makes such an arc a clique of size \((q+3)/2\) in the graph on the
\(q(q-1)/2\) internal points of the conic in which two points are adjacent when
their join is an external line. That graph has clique number \((q+3)/2\) for
\(q\equiv3\pmod4\) but \((q+1)/2\) for \(q\equiv1\pmod4\) with \(q>5\), over
every odd prime power up to \(49\). So for \(q\equiv1\pmod4\) the branch is
empty for a reason that uses neither the arc condition nor any conjecture, and
proving the clique bound \(\omega\le(q+1)/2\) in general closes that whole
residue class unconditionally and for all fields. The same mechanism provably
cannot decide \(q\equiv3\pmod4\): there the \((q+1)/2\) internal points of an
external line together with that line's pole form a genuine extremal clique, the
pole being the unique candidate extension exactly in that congruence class.
Containment in a Baer subline is separately excluded for every odd prime power by
an exact coboundary identity on the norm-one circle, which confines the
configuration to a single coset of size \((q+1)/2\); with the affine-line case
this forces \(q=5\). By exhaustive check the branch is empty for every odd prime
power up to \(43\), and in the class \(q\equiv3\pmod4\) up to \(151\).

A stronger route has since closed every prime field outright. Coherence of a
saturated-internal support has a standard incidence model: the support, its
Frobenius conjugate, and the character-opposite directions together with the
trace-zero direction form a dual \(3\)-net of order \((q+3)/2\). When \(q\) is
prime, Blokhuis–Korchmáros–Mazzocca's classification of such nets forces the two
affine components onto a conic, and the two-line subgroup classification then
leaves only \(q=5\). So the branch is empty over every prime field, using
neither the clique bound nor any Paley eigenfunction hypothesis; the clique and
Baer-subline statements above survive as independent checks. Proper prime powers
remain open, because there the net order exceeds the characteristic.

For those, the gate is now algebraic rather than combinatorial. Over every odd
prime power the two affine net components have the complementary-factor form
\((x,\pm S(x))\) on the nonroots of \(S\), where \(RS=X^q-X\),
\(\deg R=(q+3)/2\) and \(\deg S=(q-3)/2\); writing \(H_2\) for the remainder of
\(S^2\) modulo \(R\), conic containment is exactly \(\deg H_2\le2\), equivalently
the vanishing of one coefficient band of \(S^3\). The resulting
Frobenius-semilinear digit tower untwists, in canonical ghost-tail coordinates,
to a single ordinary stacked Cartier–Toeplitz matrix \(\mathbb M_R\) whose
entries are denominator-free polynomials in the coefficients of \(R\), so a
nonzero kernel is an exact determinantal condition rather than a search. Row
counting forces a kernel only at \(q=25,27,81\); over every other field a
surviving ghost would have to lie on a rank-drop stratum whose properness is
still to be proved. The first equation that is not a Frobenius shadow of the
ordinary barycentric identities descends to a pure homogeneous quadratic map on
\(\ker\mathbb M_R\) when \(p\ge7\), and stays a mixed quadratic/cubic map only in
characteristics three and five — exactly the three forced fields. A top-rung
no-wrap degree bound gives the uniform gap \(\deg H_2\le2\) or
\(\deg H_2\ge(p+1)/2\), so any surviving extension ghost has characteristic-scale
degree. Equivalently, the whole hierarchy is the division-free syndrome law
\(\sum_i w_i^{2j+1}x_i^m=0\) on the roots \(x_i\) of \(R\) with weights
\(w_i=1/R'(x_i)\), and the conic conclusion says exactly that \((w_i^2)\) is the
evaluation of a quadratic polynomial on those roots.

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

That first boundary and the next three size layers are now completely closed by
exact, independently replayable searches: no conic-filling arc of size \(12\),
\(13\), or \(14\) exists over any finite field. The last two fields fell on the
same day. At \(q=71\) the all-passant branch has no star at all — a complete
\(22{,}579{,}655\)-state anisotropic search — and all \(39\) mixed stars fail
their first forced equation \(E_8=0\); at \(q=73\) neither branch has a
geometric star. The earlier \(k=14\) closures are unchanged: at \(q=61\) none of
the \(96\) exact twelve-line mixed stars extends, and at \(q=67\) a complete
mixed search of \(946{,}250{,}059\) recursion states and all \(92\) all-passant
stars fail. No \(k=15\) census is planned, because these remain finite negative
classifications at stated domains rather than a uniform nonsaturated theorem,
and the leverage now sits in the structural gates rather than in one more size
layer.

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

That uniqueness is no longer confined to the field of eleven elements. For a
six-arc \(A\) in \(\operatorname{PG}(2,q)\) with \(q\ge11\) an arbitrary prime
power, \(\mathcal U(A)\) lies on a plane curve of degree at most three if and
only if \(q=11\) and \(A\) is projectively equivalent to the Clebsch hexagon,
in which case the least vanishing degree is two. Low-degree containment is
therefore a property of the Clebsch class over every field, not a coincidence
at one field order, and the argument is a human proof resting on the finite
\(q=11\) census plus the general bounded-degree envelope described under the
prescribed-hole paper below. It is routed to the computational companion of
this paper rather than to the paper itself, which does not carry the finite
input it needs.

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
Dye (1991) supplies the ten-Brianchon bound and the \(A_5\) stabilizer, although
that bound and its equality case are now proved here from scratch rather than
imported; Calvo
(2024) owns the modern reflection-arrangement ledger; and Jurrius–Pellikaan
(2015) own the general arrangement-decoder mechanism. What is claimed here is
the exact covering \(\mathcal U(A)=\mathcal C(\mathbb F_{11})\) — each source
gives only the classical inclusion — together with the rigidity, gap,
low-degree, decoding, and through-eight-points statements.

A later full human-proof audit corrected an overstatement adjacent to this
claim: in characteristic five the projective stabilizer is \(S_5\), not
\(A_5\), because the golden roots coalesce. It also exposed the complete
six-node exhaustion and the five chartwise singularity calculations in a
checkable human certificate. Neither correction changes the order-eleven
inverse theorem. The priority sentence is now restricted to the proved
seven-value concurrence spectrum rather than claiming an exhaustive absence
from the literature.

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

The completeness proof no longer rests on a false universal socle statement.
Its all-field exclusion is now assembled from exactly the required channels:
Steinberg absence, a determinant-normalized linear detector, prime-field
Fischer detectors, the full opposite-parity root-defect calculation (including
the \(T(2q)\) seam), affine-class contraction, and Faber's tame-subgroup
theorem. The endpoint lift is projectively intrinsic, and the exceptional
\(q=9\) case is handled explicitly. These repairs strengthen the proof surface
without weakening the theorem.

### Geometrically transversal one-factorizations of \(K_{10}\) are pencils

A second, field-uniform theorem has landed on the matching-design side.

> Let \(L_0,\dots,L_9\) be ten lines of \(\operatorname{PG}(2,K)\), no three
> concurrent, over any field \(K\). If the edges of \(K_{10}\) admit a
> one-factorization such that for each factor the five star points
> \(L_i\cap L_j\) with \(ij\) in that factor are collinear, then the nine
> factor transversals form a pencil.

The proof has two halves and no computation in either. The first is a
star-factorization interpolation identity: writing \(P\) for the product of the
carrier forms and \(Q\) for the product of the transversal forms, there are
nonzero scalars \(c_i\), unique up to common scaling, with
\(Q=\sum_ic_iP/\ell_i\), and comparing residues at each star point gives
\(t_M\doteq u_i+u_j\) for every edge \(ij\) of the factor \(M\), where
\(u_i=\ell_i/c_i\). A parity argument along an alternating cycle then shows
that a Hamilton pair of factors forces the pencil whenever the half-order is
odd, which is the case here. The second half handles the factorizations with no
Hamilton pair: every factor pair then has cycle type \(4+6\), the parity
constraints are exactly the twelve lines of the affine plane of order three on
the nine factor forms, and a non-pencil realization would have to be a
projective representation of that plane. Three of its lines suffice to kill it
— their vector planes meet in zero, so the carrier form would have to vanish
whenever two is invertible, and in characteristic two the triple closure
already forces the pencil. This **Hesse-tripod lemma** uses four carrier
variables and six factor points, which is minimal for the method, and it
applies to any larger transversal design containing the same incidence shadow.
It replaces an earlier 396-class census, which is no longer load-bearing.

For the regular matching design the theorem forces every canonical
one-factorization line, and at that point the field boundary is classical
rather than new: Nagy's theorem that the Ree unital \(R(3)\) embeds in
\(\operatorname{PG}(2,K)\) exactly when the field of eight elements is a
subfield of \(K\), uniquely and inside a subplane of order eight, applies
directly. The internal combinatorics were recomputed independently and agree:
the regular matching design has exactly 28 one-factorizations, each block lies
in four of them, and each pair shares exactly one block, a
\(2\)-\((28,4,1)\) design, while the nonhyperoval class has a single
one-factorization. What would be publishable is the automatic completion from
secant concurrences to the Ree-unital line structure, not the field boundary
itself; whether every rank-three realization of the regular design forces those
collinearities is open, and the literature-priority verdict on this material is
explicitly bounded and provisional.

## *Golden descent and operator realizations of the Clebsch cubic*

A note proving two independent results on the same Clebsch four-space. Its
released versions one and two carry the earlier title *Arithmetic and harmonic
realizations of the Clebsch cubic*; the forward version renamed it because it
now also carries a bounded selection of the conference-operator material of
section 6, running as one chain from the incidence descent
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

### Recognition from four-point shadows and from aligned designs

Two recognition theorems are proved and machine-checked in Lean but are not yet
in the manuscript; integrating them is authorized future work.

The first recognizes the golden conference class from cubic data alone, at full
generality rather than on a normalized family. For an arbitrary symmetric
zero-diagonal matrix with entries \(\pm1\), nonzero proportionality between the
triangle cubic and the commutator-Pfaffian cubic characterizes the golden
conference switching class, and the two orientations are projectively isolated.
The mechanism is a switching reduction: diagonal switching multiplies the
commutator-Pfaffian cubic by the product of the six switching signs and leaves
the triangle cubic unchanged, so switching by the root row carries any such
matrix into the normalized family together with its proportionality constant and
its conference square. One relabelling and one fixed diagonal switching then
carry every such matrix whose square is \(5\cdot1\) onto the displayed conference
matrix, which is exactly the uniqueness of the conference switching class.

The second is a faithfulness theorem for aligned designs at the quantifier range
the manuscript states. For every two-graph on a finite point set with at least
seven points, the aligned four-sets determine the triangle values on distinct
triples up to one global complement bit. Rooting at a point of an aligned
four-set whose triangle bit is zero makes the anchor's six edges vanish, which
replaces the two switching normalizations the earlier argument used, so the
general transport, the seven-point distinctness obligation, and the extension to
an arbitrary finite set all come out of one proof. The query family a decoder
working from one anchor uses is defined explicitly and has size \(3n^2-23n+45\).

Around those two theorems sit three exact certificate facts. Aligned
certificates at seven points have distance exactly two and correction radius
zero, and the whole spectrum is even by edge-toggle parity. The scalar third cut
moment separates all four classes at order twenty-six, so the full histogram is
unnecessary. Conference contraction forces the two-pivot plane, and the counting
that recovers the separator reduces coherent pentads and spanning aligned hexads
to intercalates in the Latin classes and Pasch configurations in the Steiner
classes.

A two-graph literature audit, still in progress, has found two defects in the
second theorem, and one of them is mathematical rather than bibliographic. The
hypothesis that the four triangle values on every four-set sum to zero is the
definition of a two-graph, verbatim, and the proof opens by fixing a root and
forming the graph on the remaining points whose edges are the triples through the
root — that is the descendant correspondence between two-graphs and switching
classes of graphs. The machinery is standard and currently uncited, here and in
the rigidity paper's use of the four-point identity; both need the same citation
repair. More seriously, the closest benchmark named in the manuscript is wrong.
It cites eventual reconstruction from local size five for arbitrary 3-uniform
hypergraphs, whereas Dammak, Lopez, Pouzet and Si Kaddour give four-local
reconstruction up to complementation for ordinary graphs, valid for
\(4\le k\le v-3\) and hence at \(k=4\) from seven points — the same two numbers as
the theorem. That coincidence is unexplained. Two-graphs on four points are
switching classes rather than graphs, eight against sixty-four, so the two-graph
hypothesis is weaker and its conclusion correspondingly weaker, and neither
theorem immediately implies the other. Whether the two-graph statement is a
corollary of the graph statement or genuinely independent is open and should be
settled before the next revision. No two-graph reconstruction theorem was located
at full search strength, and Seidel's 1976 and Seidel--Taylor's 1981 surveys are
carried as access gaps rather than as negatives.

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

### Branch, norm, and recognition closure

The rational degree-two incidence field is branched exactly along the reduced
multiplicity-one sextic \(J_0=0\). Its scale is intrinsic:
\(\iota_t^*J_0=16\sigma_3^2\). Consequently the two conjugate configurations
over the base point form the complete reduced fibre with residue algebra
\(\mathbb Q(\sqrt5)\); this is now proved in the paper rather than inferred
from the real boundary picture.

For a real symmetric even-order matrix with nonzero off-diagonal entries,
nonzero triangle--Pfaffian proportionality forces order six and a positive
scalar square. With equal absolute values it gives exactly the pentagon
conference class, and the proportionality sign is its orientation character.
The determinant-line comparison is signed: after compatible orientations,
\[
 \det[D_x,C_T]=-8000\,N_{E/\mathbb Q}(\det B_T).
\]
The positive block square is the signed odd-rank determinant-line contraction,
not the unsigned field norm. Deck exchange preserves the unmarked algebra
\(\mathbb Q[C]=\mathbb Q[-C]\) while reversing the marked generator and the
relative orientation.

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

Across Papers I--V, the common statement is a reconstruction-profile
calculus, not one functor on one category. Each sparse shadow recovers a
declared carrier up to an explicit projective orbit, orientation involution,
homogeneous fibre, or marking torsor; every asserted minimality has its own
collision or lower-bound witness. A calibrated odd datum kills the recurring
orientation \(C_2\), while Paper V shows that a chordal line is additionally
necessary and sufficient for exact oriented return. In short: sparse shadows
recover carriers, and their exact fibres measure what was forgotten.

This profile comparison also separates a classical exceptional-root tower from
the genuinely marked entry into it. The unmarked
\(E_6\to E_7\to E_8\to E_9\to E_{10}\) quadratic fold is classical, as is
the \(E_8\)-root-pair/Gosset/Schläfli bottom chain. What survives is an exact
finite-carrier composition: the Clebsch data selects an oriented golden
double-six on the \(27\)-line \(E_6\) carrier; the tritangent-support kernel
recovers the bare line/tritangent geometry; and a retained residue flag makes
the tower reversible. Forgetting the flag has explicit fibres. Already over a
bare \(E_6\) carrier there are \(432\) golden markings, \(864\) ordered
operator/apolar markings, and \(1728\) full Paper-V gateway markings. This
composition has not passed a publication-grade novelty audit and is not
assigned to a manuscript.

## *Minimum-word reconstruction of \(\operatorname{PG}(2,13)\) from a binary conic code*

This paper was earlier titled *A binary [78,36,12] code from the passant lines
of a conic over \(\mathbb F_{13}\)*; the current title names the reconstruction
rather than the parameters. A manuscript-only pre-release was deposited on
2026-08-03 at DOI `10.5281/zenodo.21783971`, with the Lean companion held back
for a forward version.

Take the conic in \(\operatorname{PG}(2,13)\), its \(78\) internal points and
its \(78\) passant lines, and let \(K\) be the kernel of the incidence matrix
between them. The parameters are the front door; the reason for the paper is
that the minimum words of \(K\) reconstruct the geometry and the symmetry group
they came from.

The minimum distance is exactly \(12\), proved without a support search. Segre
tangent triples exclude weight eight: after one point is fixed, a cyclic
42-vertex compatibility graph has clique number five while a weight-eight word
would need a seven-clique. The two forced weight-ten pencil profiles are
excluded, and a dihedral weight-twelve word is constructed. Exact
positive-semidefinite and line-moment certificates now carry both exclusions,
replacing the corresponding subset and syndrome searches. All \(364\) minimum
words split into one \(S_4\) and three \(D_{24}\) projective orbits — one
octahedral family and three chord-indexed punctured-conic families — and every
one of those orbits spans the whole code. The reason they all span is
structural: the code is \(12\)-dimensional over a canonical operator field
\(\mathbb F_8\), and that hidden scalar action forces each family to span.

The reconstruction is the headline, and it now runs on pair data alone. The
weighted pair concurrences among minimum words reconstruct the passant incidence
matrix, the code itself, and the six-class elliptic association scheme; the
resulting group action then reconstructs all points and lines of
\(\operatorname{PG}(2,13)\), the distinguished conic, and its polarity, with no
coordinates and no triple concurrence used anywhere. Equivalently, the weighted
two-section of the minimum-support hypergraph is a complete invariant of this
marked conic-plane presentation. The common automorphism group of the code, the
minimum-support hypergraph, and the association scheme is exactly
\(\operatorname{PGL}(2,13)\).

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

A later audit added pre-emptions and withdrew one claimed contradiction. The
object identified in the censuses is the cubic **correspondence** graph on
\(182\) vertices, not the passant-line/internal-point incidence graph, which is
\(7\)-regular on \(156\) vertices; an earlier version of this paragraph
conflated the two. That correspondence graph is `X.182.1` in Conder and
Potočnik's census of semisymmetric graphs — edge-transitive but not
vertex-transitive, one of the two cubic bipartite graphs of girth twelve at that
order — and it is pre-empted harder than the census alone shows: it is one of
exactly five graphs in Iofinova and Ivanov's 1985 classification of biprimitive
cubic semisymmetric graphs, the member with automorphism group
\(\operatorname{PGL}(2,13)\), whose two sides are its two degree-\(91\)
primitive actions. The amalgam, not merely the graph, is classical.

The two side kernels, however, are **not** pre-empted. They are
\([91,14,28]\) and \([91,14,26]\), they prove the semisymmetry independently
since a part-swapping automorphism would force them to be equivalent, and
Crnković, Rukavina and Šimac's semisymmetric paper — read at full text — does not
contain order \(182\), their graphs coming from a G-graph construction rather
than the census. An earlier reading held that this asymmetry contradicted a
published equivalence claim of theirs; it does not, and that same paper states
plainly that the two sides generally differ in minimum distance. The asymmetry
is real, the claimed contradiction is retracted.

The proof is led by a human argument; computation records discovery and is
retained only where finite bulk has resisted conceptual compression. Two Lean
surfaces support it — shared semantic modules carrying the logical spine, and a
paper-owned package checking the irreducibly finite leaves in small auditable
shards. Neither is a claim that the main theorem is machine-checked. The human
surface now prints the six orbital representatives, the required integral
scheme-product rows, the parity products identifying the binary projector, the
Frobenius descent and commutant argument producing \(\mathbb F_8\), and the
four orbit-Gram concurrence rows. A focused reread found no counterexample or
field, sign, polarity, or reconstruction defect. Full Lean closure and public
release remain open.

## *The Golden Companion Correspondence*

The fifth numbered Clebsch paper closes the marked round trip among the first
three papers. The five-dimensional residue of the quadratic-trade paper is the
**chordal** member of the same \(A_5\)-invariant cubic pencil whose
**conference** member appears in Papers I and III. Its
rational-normal-quartic singular locus recovers the original six-axis carrier,
and the normalized outer difference gives the oriented, image-restricted
inverse.

The marking is essential. Unmarked data does not choose a canonical inverse;
a chordal line supplies the additional datum needed for exact return. The
theorem is stated over its actual image and records the base-change boundary,
so it does not assert that every member of the invariant pencil comes from a
Clebsch carrier. The eleven-page paper has a self-contained finite certificate
for every frozen transitive input, and its final proof surface passed three
independent cold reads after two convention repairs.

The paper now ends with a normalization–residue theorem that names the golden
orientation in finite representation-theoretic terms. Let \(B\) be the oriented
conference matrix with \(B^2=5I_6\) on \(L=\mathbf Z^6\), adjoin the half-sum
\(h=\tfrac12(1,1,1,1,1,1)\), and put \(\varphi=(I+B)/2\). Then
\(L^{\max}=L+\mathbf Zh\) is the \(D_6\) weight lattice \(D_6^\vee\) and is the
minimal over-lattice of \(L\) preserved by \(\varphi\); since
\(\varphi^2-\varphi-1=0\), it carries the *maximal* golden order
\(\mathbf Z[\varphi]\), even though the equivariant endomorphism ring of \(L\)
itself is the index-two order \(\mathbf Z[\sqrt5]\). Reduction modulo two gives a
three-dimensional \(\mathbf F_4\)-space \(M=L^{\max}/2L^{\max}\) whose commutator
submodule \(H=[A_5,M]\) is its unique nonzero proper submodule, with \(M/H\) the
trivial line and the extension nonsplit; the extension group is one-dimensional
over \(\mathbf F_4\), so this is the unique nonsplit middle module. As an
\(\mathbf F_2A_5\)-module \(H\) is canonically the four-dimensional six-point
heart \(\operatorname{Aug}(\mathbf F_2^6)/\langle\mathbf1\rangle\), and
\(\bar\varphi\) acts on it as one of the two primitive endomorphisms
\(\omega,\omega^2\). Reversing the golden orientation sends \(B\mapsto-B\),
\(\varphi\mapsto1-\varphi\) and \(\omega\mapsto\omega^2\), which is exactly how
the outer coset of \(N_{S_6}(A_5)/A_5\) acts. So the golden orientation torsor
this series reconstructs *is* the exotic \(\mathbf F_4\)-gluing torsor
\(\{\omega,\omega^2\}\). That identification is the hinge the stabilization
programme below turns on.

There is a further proved arithmetic consequence that is not yet in the paper.
The extension-field census is the inertia stratification of the tame
icosahedral quotient, with branch signature \((2,3,5)\): the degree
\(12,20,30\) strata are disjoint, the complement is free, and this gives a
uniform finite-field split-type formula and zeta function. It remains outside
the manuscript until its classical attribution boundary and larger arithmetic
certificate are closed. The higher relative theorem over a localization of
\(\mathbb Z[\sqrt5]\) is also open; its obstruction is integral good reduction,
not another finite-field census.

## The cubic-threefold stabilization programme: the exotic cubic realization

This began as quarantined research built after the fifth paper was frozen, and
it now has several manuscript outputs of its own. The **one-stabilization epilogue** proves
that \(X\times\mathbf P^1\) is irrational for every smooth complex cubic
threefold \(X\), and carries the universal \(CH_0\)-triviality of Roulleau's
pencil alongside it; it is an unnumbered epilogue to the numbered series and
deliberately not a sixth numbered paper.  *Sharpness of Irrationality after One
Stabilization for Cubic Threefolds* proves exact stabilization level two for
two displayed smooth cubic threefolds.  An older all-\(m\) manuscript remains
explicitly conditional on two stated hypotheses about marked continuation
across the thresholds of one equivariant cobordism. None has been submitted,
and priority closure is not complete for the surrounding research material.

The exact-level-two result is constructive.  If a smooth quartic del Pezzo
surface \(S\) over a characteristic-zero field has a rational point and
stably permutation geometric Picard lattice, then \(S\times\mathbf A^2\) is
rational.  The engine is a descended unimodular tangent section for a
projectively linear torus action, producing a rational Rosenlicht quotient.
Applied to both explicit Tschinkel--Zhang cubic families, it gives
\(X_{j,r}\times\mathbf P^2\) rational for every member.  For the two displayed
smooth cubic threefolds \(X/\mathbf Q\), the one-stabilization theorem supplies
the lower bound and the quotient construction supplies the upper bound:
\[
 \ell_{\mathbf Q}(X)=\ell_{\mathbf C}(X_{\mathbf C})=2.
\]
Equivalently, \(Y=X\times\mathbf P^1\) is nonrational over both fields while
\(Y\times\mathbf A^1\) is rational over \(\mathbf Q\).  Exact Cox-weight,
saturation, tangent-matrix, localized-branch, inverse-graph, and Bézout checks
support the human proof; no Lean formalization of this new theorem is claimed.

A separate modular-resolvent companion identifies the signed nonstandard
\(A_5\)-cubic parameter with the sign/discriminant resolvent of the actual
relative norm-axis elliptic two-division cover.  With \(T=81t^2\) and \(r=9t\),
the base is \(X_0(6)\); the sign and split level-six subgroups, cyclic
\(A_3\)-monodromy, cusp widths, and the two additional modular-interior cubic
boundary values are explicit.  At the chordal value an exact orbit-and-ideal
certificate gives the reduced twelve-point icosahedral transverse divisor,
conditional only on the stated secant-cubic identification.  Golden
orientation turns the rational two-division triple into the cyclic cubic
splitting cover, with \(t=3(\eta(3\tau)/\eta(\tau))^6\).

### Which cubics, and why the exotic sheet is forced

The carrier is Roulleau's pencil of \(A_5\)-invariant cubic threefolds. Its six
\(D_5\) axes have Gram matrix \(6I-J\), while Winger's five \(A_4\) quotient
axes have Gram \(3(5I-J)\); this twin-simplex theorem makes the two
discriminants meet exactly in the unique \((\mathbf Z/3)^4\) heart, which forces
the generic three-primary gluing. The five marked principal halves of the
six-axis source \((E^5,6I-J)\) form one Hecke packet whose discriminant geometry
is \(\mathbf P^1(\mathbf F_4)\): three classical \(S_6\) sheets and two exotic
\(A_5\) sheets, every edge a primitive multiplier-four neighbour with Smith
kernel \((\mathbf Z/2)^2\oplus(\mathbf Z/4)^4\). The three \(\mathbf F_2\)
gluings preserve \(S_6\), while each exotic \(\mathbf F_4\) gluing has
stabilizer exactly \(A_5\), so strong Torelli puts the cubic family on the
exotic pair — the same two-element torsor the golden orientation supplies. On
the quartic side, an integral rigidity theorem forces every unimodular
standard-type \(S_6\) lattice to be the \(A_5\) root–weight lattice, whose
stabilizer is \(\Gamma_0(6)\), so the quartic's nonconstant period has closure
\(X_0(6)\) with cusp widths \(1,2,3,6\); the five kernels assemble into one
resolvent packet over \(X_0(3)\).

### What is proved fibrewise

For every one of the twenty \(A_5\)-stable principal gluings of \((E^5,6I-J)\),
the rank-fifteen lattice generated by fourfold divisor intersections is
saturated in its rational span. On the actual exotic cubic gluing a fifteen-term
rational identity places the minimal class \(\Theta^4/4!\) in that span, and two
coordinate projections have Smith types \((1^{14},7)\) and \((1^{14},17)\), whose
coprimality forces integral membership; an independent exact-arithmetic replay
confirms the certificate. Consequently **every smooth \(A_5\) cubic in the
pencil has universally trivial \(CH_0\)**, by Voisin's criterion, **and its
intermediate Jacobian satisfies the integral Hodge conjecture for one-cycles**,
by Beckmann–de Gaay Fortman. This is a fibrewise statement.

On the smooth family the Picard-level gate is also closed positively. The exotic
marking cuts the full mod-two elliptic monodromy from \(S_3\) to \(C_3\); on the
principal homology lattice that order-three generator satisfies
\(M^2+M+I\equiv0\pmod2\) and so fixes no vector of \(J[2]\), giving every
symmetric-line-bundle torsor a unique invariant quadratic refinement. The
primitive relative class therefore exists on the present smooth exotic marked
base with no extra cover, the four cusp widths becoming \(2,2,6,6\), and all
local mod-two theta residues vanish.

### The one open crown, and the routes that are closed

What remains on the smooth family is a single parity question: whether the
relative rationally connected Abel–Jacobi lift has odd index. The dichotomy is
exact — index one versus two on the unordered-theta side — because a Hecke conic
already supplies a degree-two closed point on a proper compactified generic
fibre.

The routes that would have settled it cheaply are closed negatively, each by an
exact calculation rather than a failed search. The charge-two universal-sheaf
gerbe has period two and generic index two, from a cyclic algebra with nonzero
residue on Druel's generic strictly-semistable Luna slice, and the residue
survives the marked base change; both visible type-\((5,1)\) divisor carriers
reduce to that same class. The twisted-cubic shortcut dies on an integral Hodge
lattice: all \(680\) degree-three divisor products span a saturated rank-\(50\)
lattice — the full rational codimension-three Hodge space, by skew Howe duality —
whose \(\Theta^2\) pairing ideal is exactly \(2\mathbf Z\). A complete mod-two
invariant census closes the universal-sheaf \(c_3\) escape through Wu's formula.
A degree-fifteen factorable-quadric packet, prime over \(\mathbf Q\) and
verified by two independent computer-algebra systems, makes the generic
charge-three and unordered-theta fibres two-equivalent, but is an odd
multisection rather than a zero-cycle on the Abel–Jacobi fourfold. Finally,
Shen's centered cycle is existential rather than canonical: the halving
obstruction lives in a higher-Chow kernel and its geometric halves form a torsor
under \(CH_1\) two-torsion of the theta sum divisor, not under \(J[2]\), so the
usual field-theoretic tools do not kill it. The exact positive residue there is
an odd-degree descent theorem.

### Uniform theorems extracted along the way

Two general statements came out of the same work and stand independently of the
cubic application. The **Jordan-scalar minimal-class theorem**: for every
principally polarized elliptic-power quotient whose self-dual gluing is scalar on
each local Jordan block, the primitive class \(\Theta^{g-1}/(g-1)!\) lies in the
integral divisor-product lattice. The mixed-adjugate proof is primitive at the
prime two, carries no hidden factorial, and covers every scalar type-\(A\)
root–weight gluing \(G_N=NI-J\) with \(N\ge3\); the exotic cubic gluing is
non-scalar and so is a genuine exception rather than an instance. A bounded
priority audit places the likely new crown in the primitive integral
divisor-product saturation itself, since the Weyl principally polarized abelian
varieties, the modular curves \(X_0(N)\), elliptic-product decomposition, the
integral Hodge conjecture, and minimal-class algebraicity are all prior art.

The complementary boundary is exact. A literal power \(E^g\) is primitive for
every principal polarization; for a quotient of \(pI_g\) by an arbitrary maximal
isotropic subgroup the minimal-class defect has no prime-to-\(p\) part and
divides \(p^{v_p((g-1)!)}\), so every such gluing is primitive once \(p\ge g\),
and an arbitrary isogeny of degree \(D\) has defect supported only at primes
dividing both \(D\) and \((g-1)!\). Small-prime defects genuinely occur — exact
minimal-class index two in every dimension \(g\ge3\), three in every \(g\ge4\),
and four in every \(g\ge5\), by a spectral stabilization theorem with
certificates — so "every gluing is primitive" is dead, and the obstruction is the
Tor boundary of the lifted divisor-product lattice rather than an Arf invariant
or an ambient Steenrod square. A squarefree minimal polynomial of the symmetric
slope implies primitivity at every prime including two; the converse is false at
odd primes, so the live classification is by \(p\)-typical nilpotent height.

### One-step stabilization: the irrationality half

The companion half concerns the quantum cohomology of a cubic threefold; the
computations are classical and exact. The argument that carries the headline is
the **atomic route**, and it is unconditional. Working inside the ordinary,
non-enhanced Hodge-atom package of Katzarkov, Kontsevich, Pantev and Yu, one
isolates the atom carried by the double zero packet of the cubic small quantum
connection and attaches to it a rank-two *atomic residue discriminant*
\(\delta^\sharp\), defined through a canonical elementary modification of the
even rank-two block. For the cubic atom \(\delta^\sharp=4/9\). The only curve
whose atom could carry the same Hodge representation has genus five, and there
\(\delta^\sharp=0\); surface representatives are excluded by parity ranks
together with the classification of minimal surfaces. The ordinary Hodge-atom
non-rationality criterion then obstructs rationality after one stabilization,
so **\(X\times\mathbf P^1\) is irrational for every smooth complex cubic
threefold \(X\)**. Kuznetsov's birational correspondence extends the same
conclusion to every smooth prime Fano threefold of genus eight.

The finer invariant \(\nu_6\) — the number of primitive-sixth framed
formal-monodromy eigenvalues of the numerical small even quantum connection —
gives a second, conditional proof of the same theorem. Here \(\nu_6(X)=2\) and
\(\nu_6(X\times\mathbf P^1)=4\); the product formula is unconditional, while the
blow-up and projective-bundle formulas each rest on one stated hypothesis, on
the reconstruction tail and on divisor-tagging specialization respectively.
Under those two hypotheses \(\nu_6\) is birationally invariant through dimension
four. The divisor-tagging hypothesis has since been narrowed: specialized
primitive-sixth vanishing is now proved for every Hirzebruch surface, by one
deformation to index at most one, an explicit rank-four Euler quartic and its
discriminant, and a non-collision argument for the centre specializations, with
the quadric surface handled instead by the Gromov–Witten product formula. What
is left of that hypothesis is a single named obstruction — a support or
base-change statement for the blow-up comparison after external specialization —
and it is now invoked only for surface centres that are neither minimal nor
geometrically ruled.

Full stable irrationality is **not** proved by the epilogue, and the
\(\nu_6\) argument first fails at \(m=2\), where cubic self-carrier centres
enter. A source-level audit settled what the ambient object is: the full reduced
cubic quantum module is the irreducible hypergeometric module
\(H(0,0,0,0;1/3,2/3)\) with local formal ranks \(1,1,2\), so globalizing the
rank-two block as a proper subobject is dead, while the local sectorial Stokes
lift has ordered ranks \(1,2,1\) and isolates the zero-exponential rank-two atom
canonically.

### The separation, and where the pencil sits

Together the two halves give an exact contrast for every smooth member of the
family: \(X\) is universally \(CH_0\)-trivial while \(X\times\mathbf P^1\) is
irrational. That is a strong separation between universal \(CH_0\)-triviality
and one-step stable rationality, and it is explicitly not a claim of stable
irrationality.

The separation is genuinely new for this pencil, and both natural ways of
dismissing it are closed. The pencil is not covered by Colliot-Thélène's
separated-variable criterion at any moduli point but one, and that exception is
the Fermat point — the qualifier is now a single named member rather than "all
but finitely many". It is likewise outside the coprime-degree locus of Yang, Yu
and Zhu for all but finitely many members, because every member of their normal
form carries an Eckardt point while the generic pencil member carries none. The
Eckardt statement is proved from complex reflection groups rather than by
elimination: an Eckardt point of a smooth cubic threefold is the centre of a
reflection fixing the defining form; when the automorphism group acts
irreducibly those reflections generate an irreducible rank-five complex
reflection group; and three is an invariant degree of only \(W(A_5)\), giving the
singular Segre cubic threefold, and \(G(3,p,5)\), giving the Fermat cubic
threefold. Exactly two members of the pencil carry Eckardt points, interchanged
by the normalizer of \(A_5\), each with exactly thirty of them, and both are the
Fermat cubic threefold. Voisin's criterion is unreachable by any
elliptic-product route: with the exotic two-primary gluing kernel the only
odd-degree product factorization of the intermediate Jacobian is \(1+4\),
realized at odd index twenty-five, so the pencil is not known to lie in a Voisin
component. The residual question there — whether the four-dimensional
odd-degree factor is a Jacobian — is closed negatively in genus four for all but
finitely many members, leaving only a genus-five route through an isogeny of
degree greater than one.

### The all-\(m\) manuscript, stated conditionally

The second manuscript asks when vanishing of the flat covector that the Gamma
integral structure attaches to the class of a point is a birational invariant,
and reduces that question to one marked continuation problem at each threshold
of a single equivariant cobordism. Granting that continuation — a
gauged-admissible marked Włodarczyk completion together with two stated marked
threshold-compatibility hypotheses, at every finite Artin truncation —
\(X\times\mathbf P^m\) is irrational for every smooth complex cubic threefold and
every \(m\ge0\). The endpoint contrast is unconditional and the transport
mechanism is proved under the gauged-admissibility conditions; what is not
proved is the comparison across thresholds, an isomorphism of the two adjacent
cyclic Rees \(z\)-modules intertwining formal monodromy and carrying the marked
row. A marked Gamma/window continuation conjecture, new to that paper, would
imply them.

An independent audit of an alternative *direct* route through the ordinary
quantum \(D\)-module confirms it proves the one-stabilization theorem after one
local repair: the intrinsic and asymptotic projective-bundle modules must be
compared inside Iritani and Koto's common faithful ring, not through a
nonexistent embedding of one completion into the other. That route compresses
the input to even rank two, nonzero nilpotent, and nonzero modified-residue
discriminant.

The present \(m=2\) finite frontier exhibits the programme's general
information-loss pattern in a particularly small form.  A generic cubic
spectral packet forgets its native integral order.  The candidate minimally
enriched shadow is a pointed first-failure profile: the orbit of the self-dual
Kummer coweight under generic algebra automorphisms, the first leakage of the
marked nilpotent line into an adjacent Rees
grade, and, on the leakage-zero locus, the first return to that line.  Exact
Rust certificates with independent Lean correspondence now exhaust the two
normalized rank-six native-order charts.  The dual-number chart has zero
leakage and residue discriminant zero; the distinct-root chart is conformal
throughout its complete five-parameter effective calibration family but has
unavoidable leakage \(1/6\), so the marked elementary modification is not
regular.  A further exact scan shows that the eight unit/top-fixed monomial
Weyl positions have three raw coweights, but their four divisor-generating
positions form exactly the two checked classes modulo the Kummer involution.
This does **not** prove the every-smooth \(m=2\) theorem: the remaining
geometric task is to descend an actual period-three correction occurrence to
such a native pointed port and prove the Bruhat reduction placing its
effective calibration in that finite monomial domain.

### Formal verification of the epilogue

The one-stabilization epilogue has a Lean companion bundled with it, held to the
same standard as the numbered series: no `sorry`, no compiled-evaluation axiom
at any terminal, and no project axiom standing in for a proof. The headline is
anchored to the atomic route, and the machinery underneath it is kernel-checked:
the rank-two residue rigidity algebra, the normalized Sylvester gauge shared by
the cubic block reduction and the spectral-factor gluing, block diagonality of a
pairing on separated spectral factors, the order comparison that selects the
exotic gluing, invariance of the residue discriminant, the all-degree graph
saturation theorem fed directly by the six-axis local chart, and the
unconditional half of the genus-eight corollary. The discriminant group of the
source polarization is built with its \(\mathbf Q/\mathbf Z\)-valued pairing and
splits at two and at three, and the selection of the exotic member is
formalized as Frobenius marking: scaling by a non-square scalar is an odd
permutation of the six labels whose action on the discriminant heart is exactly
the transported Frobenius involution, so no group-invariance hypothesis can
replace the marking. What remains supplied rather than proved is the
identification of that matrix-level equivariance with the equivariance of an
actual relative isogeny, and the marking of the actual geometric kernel.

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

A second audit at full parameter strength adds three verdicts and one free
upgrade. The \(2\text{-}(10,5,16)\) design formed by the thirty-six extremal
order-ten cut halves lies in a parameter family that is not merely known but
exhaustively enumerated: Morales and Velarde count \(27{,}121{,}734\) resolvable
designs with those parameters, of which \(2{,}006{,}690\) are simple. No novelty
attaches to the parameters, and the contribution is identifying which member the
conference structure produces. The upgrade comes from the same source: every
resolvable \(2\text{-}(10,5,16)\) design is automatically a
\(3\text{-}(10,5,6)\) design, and the seventy-two blocks here arise as the two
halves of thirty-six cuts, which is a natural resolvability candidate — if it is
resolvable it is a three-design at no cost, joining the programme's other
three-design results. That is a small computation and worth running. Separately,
"biangular tight frame in dimension nine" names an established object with its
own literature and should be cited rather than used as a generic description.
Against those, the three Paley three-designs \(3\text{-}(14,7,35)\),
\(3\text{-}(18,9,63)\) and \(3\text{-}(18,9,84)\) have no located predecessor at
full search strength, and neither do the Sylvester cut-frame identities
\(K^2=10K+75I\) and \((K-5I)^2=100I\), although the Sylvester graph and its
Bose--Mesner decomposition are catalogued machinery rather than new objects.

## *Secant defects with prescribed holes: arcs, caps, and matching designs*

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

### A bounded-degree envelope for the ordinary uncovered locus

The same defect identity supports a general degree obstruction, and this is
where the six-arc cubic tail quoted in the first section comes from. Put
\(N=\binom k2\), \(r=\lfloor k/2\rfloor\) and
\(\beta_k=N-k+\frac6r\binom k4\). If the ordinary uncovered locus of a
\(k\)-arc in \(\operatorname{PG}(2,q)\) with \(k\ge4\) lies in the zero set of
a nonzero form of degree \(d\), then
\[
 q^2-(N+d-1)q+\beta_k\le0,
\]
and in particular \(q\le N+d-2\); the final inequality needs no hypothesis
relating \(d\) and \(q\). So for fixed \(k\) and \(d\), degree-\(d\)
containment is possible over only finitely many field orders. Solving the
quadratic gives the exact window
\(q\le\bigl\lfloor(a+\sqrt{a^2-4\beta_k})/2\bigr\rfloor\) with \(a=N+d-1\), and
when \(a^2<4\beta_k\) no such containment exists at any field order in the
stated range; in the low-degree range \(d\le r-2\) this specializes to a linear
window that improves the coarse bound by \(k-3\) for even \(k\) and \(k-2\) for
odd \(k\). Dually, the least degree \(\delta(A)\) of a form vanishing on the
uncovered locus satisfies \(\delta(A)\ge q-\binom k2+2\), with an integral
surcharge \(\lceil\beta_k/q\rceil\) whenever \(q<\beta_k\).

Two refinements come from the components of the containing curve. In odd order
every line meets the uncovered locus of a \(k\)-arc in at most \(q-k+1\) points,
which follows from the Bichara–Korchmáros minimum-direction theorem for arcs in
odd-order Desarguesian planes as recorded by Giulietti and Montanucci. Splitting
off the rational line factors of total multiplicity \(s\) from a degree-\(d\)
containing curve then gives \(|\mathcal U(A)|\le(d-1)q+1-s(k-1)\) whenever a
residual component survives, and a corresponding one-degree improvement of the
main inequality. For a six-arc over the field of thirteen elements this caps a
cubic at 27 points of the uncovered locus while every six-arc there has at
least 32 of them.

These are human proofs. They are routed forward into this paper, which owns the
universal defect identity, rather than into a standalone note: the main estimate
is a short consequence of that identity together with classical point-count
bounds, and the nearest prior literature already studies minimum vanishing
degrees.

## *Integral Secant Distributions and Improved Bounds for Complete \((k,n)\)-Arcs*

The prescribed-hole method extends from ordinary arcs to selected block
families in symmetric designs.  Prescribing the two degree sums, lower degrees
on the required point class, and geometric upper caps gives two balanced
integer minima whose sum cannot exceed the fixed block-pair intersection
count.  Its real relaxation is exactly the classical BIBD variance, or
expander-mixing, inequality; the new information is the simultaneous integral
envelope and its arithmetic correction.

For a complete \((k,s)\)-arc, maximal secants form a linear hypergraph.  Their
matching number is the correct concurrence cap, and disjoint secant pairs
decompose canonically into concurrence cliques.  The resulting prescribed-hole
identity has a rigid zero-defect equality pattern.  More generally, for fixed
\(\lambda=uv\), \(d=u+v+1\), \(q=dn\), and \(s=(u+1)n+1\), every
\(\lambda\)-fold complete arc satisfies
\[
 k\ge udn^2+c_{\mathrm{lat}}n-O_{u,v}(1),
\]
where \(c_{\mathrm{lat}}\) is the minimum over an explicit integer offset of
the larger of the coverage and line-degree envelopes.  Every rational
resonance comes from one ordered factorization \(\lambda=uv\), and the integral
coefficient is strictly stronger than the spectral relaxation on every such
branch.

When \(d\) is a power of the characteristic, a modular-lift dichotomy gives a
further surcharge unless the dual maximal-secant family is already an exact
\(\lambda\bmod p\) multiset.  The exact core is excluded unconditionally in
the ordinary characteristic-three and the relevant even-degree branches,
giving the paper's sharpened applications.  The same integer-envelope theorem
also applies to projective point--hyperplane systems and robust
nonextendibility of projective codes.

The manuscript is eighteen pages with human proofs, an exact evidence bundle,
a partial Lean companion, hostile review, and a verified standalone export.
Its literature audit deliberately licenses no global firstness sentence: the
moment identity and its spectral form are classical, while the recorded search
found no direct predecessor for the simultaneous integer envelopes, their
unbounded resonance families, or the modular-lift surcharge.

The construction problem opened by these bounds is separate and remains
unfinished.  At \(q=9\), a Hermitian-unital plus five-orbit switch proves the
exact base value \(t_7(2,9)=39\).  Its nineteen maximal secants form a
five-character dual blocking core of size \(2q+1\).  At \(q=27\), the matching
candidate would be a 55-point blocking core with spectrum
\(1^{461}2^{17}3^{78}4^{194}5^7\), producing a complete \((279,19)\)-arc.
Trace-\(x/y\), trace-\(x\), and scalar-\(C_{13}\) invariant cores are excluded;
the Frobenius-fixed audit leaves two canonical four-point branches.  The
centered incidence descent produces a signed codeword of weight \(4q-6\), with
no tangents and opposite signs on every support two-secant.  This is a sharp
structural reduction, not an asymptotic construction or a completed theorem.

## *High-Weight Cosets of Generalized and Extended Reed–Solomon Codes*

A projective Reed–Solomon code is the evaluation code of polynomials of bounded
degree on the rational normal curve.  For every redundancy (r\ge6), the main
theorem classifies all cosets of weight at least (r-1) for sufficiently long
generalized and extended Reed–Solomon codes supported on a projective line with
any prescribed finite set of points deleted.  It yields exact deep-hole shells,
all MDS and NMDS one-column extensions, family-wise minimum-support counts, and
aggregate weight enumerators.  Detailed redundancy-five through
redundancy-seven results sharpen the uniform theorem.

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

The characteristic hypothesis has since been removed in all but one corner. The
main classification theorem's restriction to \(p>r-1\) is replaced by "\(p\)
odd, or \(p=2\) and \(r\ge8\)", via a level-uniform polar rank lemma together
with a trapped-row-space proposition read branchwise off the recursive
component table. The containment itself is strengthened to split-free subset
persistence. The imported radius and weight theorems the argument uses were
re-checked and carry no characteristic hypothesis of their own, so the
strengthening is genuine rather than inherited. One consequence is that
\(GF(64)\) is now closed by theorem rather than by computation.

Independently, the maximal-carrier discriminator resolves at every level:
each maximal Lucas carrier is the penultimate nucleus of the next rational
normal curve, with a prime-power Frobenius-quadric quotient. \(GF(27)\) is
closed in pointed form, by an authorized large two-point-switch certificate
rather than structurally, and the \(GF(16)\) and \(GF(32)\) certificates were
rebuilt under the correct degree-ten action after the earlier ones were found to
use the wrong group.

The fixed-level programme now reaches redundancy ten at its stated field
ranges. Redundancy eight is exact for \(q\ge43\), redundancy nine for
\(q\ge53\), and redundancy ten for \(q\ge59\); at each level the deep
syndromes are exactly the persistent tangent and conjugate-secant families of
size \(q(q+1)^2/2\), with the corresponding \(T/T^r\) orbit law modulo
inversion and Frobenius. These are field-ranged classifications, not an
all-field solution of the general deep-hole conjecture. The revised candidate
exposes the R5--R10 proof layers and separate radius gates; its independent
replay, Lean boundary export, standalone mirror, and release checks are green.

The methods combine exact invariant theory, Plücker inversion, Gale duality,
catalecticants and apolarity, finite-group descent, low-genus point bounds, and
independently replayed bounded classifications.

### A sharpened conjecture, and two routes to it closed by proof

Adjacent to the manuscript, and not part of it, the exceptional behaviour of
these classifications has been reduced to one conjectural inequality. Write
\(X(r)\) for the set of field orders at which the deep holes of the
redundancy-\(r\) projective Reed–Solomon code exceed the persistent locus
together with the modular carrier's deep part. The conjecture is:

> For every redundancy \(r\ge6\) and every prime power \(q\ge\max(16,r+3)\), the
> deep holes of \(\operatorname{PRS}_{q+1-r}(q)\) are exactly
> \(P_r\cup M^{\max}_{r,p}\) — equivalently,
> \(X(r)\cap\{q\ge r+3\}\subseteq\{7,8,9,11,13\}\).

The threshold constant sixteen is dramatically smaller than the proved threshold
\(6r-16+\lfloor2\sqrt{6r-18}\rfloor\), which is 29 at redundancy six and 59 at
redundancy ten. Its evidence is exhaustive censuses at redundancies three through
ten, complete non-regular classifications over *all* prime powers at redundancies
eight and nine, and certificate-backed stratum sweeps covering redundancy to 39
and field order to 127, in which none of the 171 in-scope cells fires. The two
hypotheses beyond \(r\ge6\) were shown to be the two branches of the single
inequality \(q\ge\max(16,r+3)\), crossing at redundancy thirteen, each
independently necessary with an explicit witness. The linear branch is already
slack, so the true boundary is a curve, located above two known cells and below a
third; deciding whether it flattens needs two cells that are out of budget by one
factor of \(q^2\).

Three predecessors were **falsified** on the way, each by exhaustive computation
rather than by argument: the conjecture that the deep holes are the persistent
locus alone at redundancy at least eight, killed by an exhaustive census of all
883,708,281 points of the projective eight-space over the field of thirteen
elements, which found one extra orbit; the monotonicity of the exceptional band,
since thirteen is exceptional at redundancy nine and not at eight; and two
successive guesses about which carrier shapes recur. The surviving replacements
are recorded as conjectures with their support stated, and one underlying
fixed-locus lemma — every exceptional deep hole stabilized by a split-torus
element of order \(\ell\) lies, projectively, on the stratum of indices congruent
to a fixed residue mod \(\ell\) — is **proved**.

Two routes to making the threshold rigorous are closed, both by located
obstructions rather than by exhaustion of effort. The Lang–Weil route fails for
*every* carrier, and the failure is quantitative and structural at once: the
error constant is about \(6.5\times10^{14}\) at redundancy nine, still around
\(10^6\) with Betti-number bounds, against an observed switch-off at field order
sixteen; the residual does not decay, sitting flat between 96 and 150 across a
wide range of fields where the true exceptional count is four and then zero; and
the geometric-irreducibility hypothesis fails exactly on the persistent points.
The multiplicative-subgroup-incidence route fails on both of its gate questions:
the relevant subgroups have index bounded, so their size grows like \(q\) where
the machinery needs \(q^{2/3}\), and every stratum-local statement is vacuous on
the regular orbits — which are the entire residual at redundancies eight and
nine. **The residual class with trivial stabilizer, meeting no stratum at all,
is what no stratum-local tool of any kind can reach**, and the named handle for
it is the Borel normal form.

One methodological note is recorded with these results because it changed the
procedure: two load-bearing premises across three tasks were false, both asserted
from the shape of the situation without one cheap probe — that sparsity implies
low Hankel rank, and that a constant answer implies a constant-threshold tool
will prove it. Both were caught by a gate placed before the build rather than
after it, and in one case the task succeeded anyway, on a domain an order of
magnitude larger than the false premise would have allowed.

## *Exact Transfer of Bounded Linear Recovery and Relative Weight Hierarchies*

The organizing object is the family of normalized recovery equations on a
target coordinate set. It retains exact helper supports and scalar recovery
coefficients.  Its associated nested code pair is the
shortening--puncturing pair of the inner dual; this removes any dependence on
a chosen generator-row basis and makes relative generalized Hamming weights
the natural rank-stratified invariants.

### General MDS local reconstruction

Let \(C\le\mathbf F^E\) be an \([n,k]\) MDS code with \(k>0\), let \(x\in E\),
and normalize every dual recovery word \(y\in C^\perp\) by \(y_x=1\). The
radius-\(r\) *normalized recovery-equation family* is
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
coefficients rather than only the supports is what makes the recovery structure
remember the code.  The Clebsch \([6,3,4]_{11}\) code's full radius-five
recovery-equation family reconstructs its inner code from a single target,
while its support-only clutter is the generic complete three-uniform hypergraph
on five helpers.

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
  equality of the complete pointed recovery structures.

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

### Relative weights, ungated transfer, and composition

Let \(K_P\subseteq D_P\) be the associated shortening--puncturing pair for a
target set \(P\).  For every \(t\), its \(t\)-th relative generalized Hamming
weight is exactly the minimum helper-union size of a normalized recovery
system for a \(t\)-dimensional recoverable target subspace.  Consequently the
relative-weight hierarchy gives the sharp dimension-by-dimension confinement
threshold, the best-target generalized-Hamming-weight identity, cooperative
locality min--max bounds, MDS rigidity, and demandwise service-rate and
reliability consequences.  The dual relative hierarchy likewise gives the
minimum number of failures leaving each dimension of target ambiguity; the
proof uses pointwise shortening--puncturing duality, not a false
hierarchy-level duality formula.

The distance gate can be removed completely.  For a target subspace \(T\),
minimize the target-normalized joint coset-support cost over every linear map
from \(T\) into the full outer functional dual, and add the independently
minimized costs in the other inner blocks.  The resulting number
\(\Gamma_{j,T}\) is exactly the first nonconfined helper cost at block \(j\).
Below it, restriction to the target block and zero extension are inverse
bijections on normalized recovery systems, preserving both coefficients and
exact supports.  The earlier relative-weight and pointed weighted formulas are
specializations of this ungated optimization, not competing theorems.

These costs compose exactly through repeated concatenation.  Ordinary
prescribed-coset support is substituted by a min-plus law over the labelled
intermediate functional maps.  Target-normalized numerical composition needs
the helper-restriction coset-support function together with the intermediate
target contribution; coefficient-level composition retains the full lift
relation.  Both forms are associative.  A single scalar threshold does not
compose by itself, because it forgets precisely the functional labels that the
next outer code constrains.  Compatible two-sector dual-distance recursions and
sharp cost envelopes follow from the same law.

The paper's main proofs are human proofs with cited classical inputs.  Its
paper-local Lean package verifies the associated-pair exact sequence and four
terminal statements; the stronger relative-weight, ungated-transfer, and
composition theorems are explicitly recorded as absent from that formal
package rather than being represented by certificates or assumed interfaces.

### Prescribed positive-density recovery structures

- Every fixed represented radius-\(r\) recovery structure satisfying
  \[
  r+1<z_x(I)
  \]
  occurs with density \(1/m\) in an asymptotically good fixed-alphabet
  concatenated family, where \(m\) is the inner length. The inequality is
  also the exact eventual confinement condition for the selected pointed
  recovery structure.

- Thus the construction transports an entire prescribed local object—support
  sets and coefficient fibres—not merely a locality number.

- For the Clebsch \([6,3,4]_{11}\) code, the full radius-five normalized
  recovery-equation family has \(z_x=8\), reconstructs the inner code from a
  single target, and occurs with density \(1/6\) in an asymptotically good fixed-
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
  recovery structure. The exact rows become
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

- Complete recovery-structure reliability satisfies deletion-contraction,
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

### The compiler the theory licenses: ergodis

The transfer and composition theorems above say that a large finite search
state is redundant in an exactly describable way: the coarsest congruence that
preserves every admitted observation is computable, and composing along it
preserves the witness. *ergodis* is the implementation of that statement — a
compiler and exact solver for finite algebraic optimization problems whose raw
combinatorial state admits a much smaller mathematically derived quotient. It
compiles functional labels, conserved gradings, generated spans, symmetries and
reconstructible coefficient blocks *before* optimization, delegates generic
search to an exact backend, and independently lifts and re-checks the returned
witness. It is not a reimplementation of a generic mixed-integer optimizer, and
a reduction belongs to it only when it requires information absent from the
emitted coefficient matrix or constraint graph.

Its governing theorem is that the finite many-sorted Moore contextual quotient
is the coarsest typed congruence, with classical deterministic-automaton
minimization as the one-sort corollary. That corollary is what makes the
implementation externally testable: the same code path that quotients a
recovery, weighted-tree, resource-allocation or hierarchical min-plus problem
also minimizes a deterministic finite automaton, so it can be raced against
specialized minimizers on their own published inputs.

**Measured against published tooling.** On the complete published explicit
Presburger-complement input list of the MATA automata library (TACAS'24), with
both systems minimizing the same derived, trimmed deterministic automaton and
determinization, trimming and parsing excluded from the timed region, ergodis
achieved a **2.699x geometric-mean speedup** over MATA's C++
`minimize_hopcroft`, with an instance-level paired-log statistic of `26.20` and
a median instance speedup of 2.809x across all 169 instances, winning 158 of
them. It won every instance of at least thirteen states; the losses were all on
automata of two to twelve states. On the smaller controls used during
development it is 1.61–3.30x faster than the same MATA implementation with
13–38x lower cold peak resident memory, while additionally emitting a compact
split transcript and verifying it before returning — the comparison tool returns
only the minimized automaton. A native-functor competitor, Boa, remains 2.48x
faster on the four-generator random family; that crossover is recorded rather
than omitted, and no claim of universally fastest minimization is made.

**Measured on the applications the theory was written for.** Eight coding and
storage workloads were run cold — one solve per fresh process — and warm, each
against a constraint-programming control, with the two sides required to return
the same normalized checksum. Over the twelve profiles where both sides
completed, the geometric-mean speedup is 104.16x cold and 81.48x warm, with
instance-log statistics of 44.80 and 34.80 and no individual profile below 39.60
in absolute value. Representative rows: the Ceph XOR support family at 33.71x
cold and 22.94x warm; recovery of a published binary \([4095,2718,6;2]\)
Hamming-outer locally repairable code at 657.88x cold, a median of three paired
completed runs with log-ratio statistic 49.09; GPU checkpoint recovery over an
MDS code with 10,000 shards and 64 failures at 102.42x cold and 103.23x warm.
Four profiles are lower bounds only, because the control exceeded the batch time
limit — the represented \(GF(4)\) tower at depth six and the warm Hamming case
among them. Two earlier headline ratios were **retracted** rather than softened
when the protocol was corrected: a 344,300x tower figure and a 432x Hamming
figure are not supported and should not be quoted.

**Measured against a SAT solver on its own certified problem.** On the first ten
rows of the official VLSAT-2 list, Ergodis certified all nine that are
officially unsatisfiable. On the four instances where the comparison solver also
finished, the geometric-mean speedup over Kissat 4.0.4 is 381.13x with an
instance-log statistic of 22.56; the remaining five give timeout lower bounds
between 2078x and 2835x. The loss is recorded and is a real one: the single
officially satisfiable control is a clean theorem miss for Ergodis and is
excluded from every speedup statistic. The protocol is deliberately unfavourable
to Ergodis — the comparison solver's proof output was disabled while Ergodis's
witness construction and output serialization were inside the timed region.

Self-regression is separately controlled. An earlier rerun of the original Rust
benchmark suite showed double-digit slowdowns against recorded numbers, but a
powered head-to-head of saved binaries over 101 paired rounds attributes them to
environment: the resolved differences are all within two percent, in both
directions, and survive a six-way multiple-comparison correction.

**Where it loses, measured before it was measured.** The scope disclaimer "not
a general replacement for a mixed-integer or constraint-programming solver" has
been replaced by a measured frontier. A one-page classifier of the instance
shapes the compiler can exploit, and a six-row prediction table naming three
expected losses and three expected wins, were written and cryptographically
hashed *before* any timing run. Five of the six rows landed on the predicted
side. Against a single-worker constraint-programming control the wins are
30.1x, 82.5x and 1,368.8x, plus one predicted loss that turned into a 3.75x win;
one row is a clean loss in which the compiler declines to answer at all, because
the instance exceeds a declared width bound. That refusal is worth stating
precisely: a ladder of eight instances of the same shape, varying only the
magnitude of the weights, shows *no performance crossover* — the margin is flat
within noise across a sixteen-fold width increase — and then a vertical cliff at
the kernel's declared width cap. The frontier there is a constant in the source,
not algorithmic degradation. On every row the compiler emits a certificate,
between eight and 3,600 bytes, replayed in microseconds; the control emits none.

**The remaining large loss was converted into a win.** The six-resource
generic-load scheduling row was the tier's worst result, losing to the control
by a factor of 13,689 (163 seconds against 4.6 milliseconds). Two successive
attacks closed it. Certified dominance pruning cut the dynamic program to 9.4
seconds — a 17.3x gain with every one of its 632,666 pruning deletions
certified, and the optimum, witness and transition count bit-identical to the
unpruned binary. The row was then won outright by replacing the layered Pareto
frontier with iterative branch and bound under a **Lagrangian dual bound whose
multiplier vector is derived from the inner maximum**, so dual feasibility holds
by construction and the checker need only verify nonnegativity. Multipliers are
integer numerators over a fixed denominator, so no floating-point value enters
the certificate. The result: 0.41 milliseconds against the control's 4.6, an
**11x win with a 128-byte certificate replayed in 0.8 microseconds**, against a
control that emits no proof at all. The independently computed linear-programming
relaxation value explains why the row was winnable — it is bound-closed and
conflict-free, so the whole contest is about the bound, not the search — and
resource-symmetry quotienting was rejected outright because no group exists to
exploit. The two routes are complementary rather than nested: the bound is
weakest where many demands each contribute a little, and on two such rows the
certified route does not finish while the dynamic program answers in
milliseconds. **No automatic rule yet chooses between them from the instance
alone**; that choice is the named successor.

**A second loss stands and is published.** The repair-scheduling application row
in the headline table uses unit capacities, so the instance never enters the
subset descent where the kernel's cost lives — it visits four search states. A
contended companion instance was added to measure the descent, and on solve work
alone the constraint-programming control is about 4.7x faster there. The
compiler still wins end to end by 4.4x cold, but that margin is the control's
interpreter and library import, and the report says so. Resident memory still
favours the compiler by more than an order of magnitude on every row.

**Certified infeasibility explanation is a second capability, not a speed
claim.** Every commercial optimizer answers an over-constrained roster with
"infeasible" and leaves a person to bisect by hand. A prototype built on the same
Hall matching machinery returns instead a minimal set of tasks whose eligible
resources are too few, together with those resources, and declines by name the
instance shapes it may not legitimately answer. On 78 generated instances an
independent maximum-matching oracle agrees on feasibility everywhere, all sixty
infeasible instances return certificates equal to the planted ground truth
exactly, and the median time to an explanation is 0.40 milliseconds against 61.2
for an unsatisfiable-core extraction and 57.8 for an irreducible-infeasible-subsystem
computation. The commercially interesting result is not the speed: on rosters
with several independent shortages the solver's core is *smaller* and deleting
the tasks it names leaves the roster still infeasible, every time, while the
decomposed Hall certificates restore feasibility every time. A core answers
"is there a conflict"; a planner needs "what are all the shortages, and who is
short".

**Trust tier.** The theorems are human proofs. The benchmark numbers are
reproducible measurements against pinned upstream revisions and a published
input list, not machine-checked facts, and they are specific to the machine and
the isolated minimization subproblem; they are not an end-to-end claim on the
comparison tool's original benchmark. The compiler's own outputs carry a
different and stronger guarantee: each run emits a certificate that is
independently replayed and verified before a result is returned, so a wrong
quotient is detected rather than trusted.

That guarantee was itself audited rather than assumed. A whole-code correctness
audit — parallel first-pass audits of the core library, the search engines and
the certificate and command-line plane, a vetting pass that refuted one finding
outright and corrected three severities downward, then a second round restricted
to the two highest severities — found **no committed result that was wrong**, and
two classes of defect that made the verification layer weaker than it appeared:
checks that structurally could not fail (a verification mode that printed
"certificate verified" with every witness unchecked; an instance loader whose
load-bearing fields silently defaulted, so a misspelled key caused a
misclassification whose digest still matched), and a definition of "verified" as
re-execution, which cannot catch a defect on the prover's side. The adopted
remedy is a rule rather than a refactor: **every advertised check must come with
a failing control** — a test constructing the smallest mutation that should make
that named check fail, per load-bearing field in isolation — and evidence records
must describe observed scope through typed fields rather than free-form strings.
Two claims were flagged as possibly wrong rather than merely unguarded and are
owed a re-examination.

The library has left the manuscript. It now lives in its own repository, split
from the research workspace that drives it, with evidence and reproducibility
artifacts kept on the private side and a filtered public snapshot produced by a
guarded export. The guard is enforced by tooling rather than by care: a lint rule
set, an export script, a staging clone whose push destination is deliberately
parked, independent pre-commit and pre-push hooks, and a fixture suite in which
every refusal — task identifiers, process documents, private path fragments,
oversize files, a dirty tree, an unrecorded tag, a broken replay command, a push
to the public destination — is tested and passes. It is licensed under the GNU
Affero General Public License, with commercial licensing on request; the
observational compiler, and therefore every benchmark claim above, is in the
freely available part. **Nothing has been published, pushed, or released.**

### The compiler as a dynamic decision engine, and a quantum decoder

A separate exploration asked whether the same quotient principle survives when
the problem's *structure* is fixed but its *data* changes continuously — a
repair hierarchy under a stream of failures, a network under changing
capacities, a quantum error-correcting code under measured syndromes. The
mathematical condition is an *optimization congruence*: a quotient on raw states
through which the optimal value and witness factor, to which composition
descends, and which every declared event respects. That is the Myhill–Nerode
condition generalized from language acceptance to optimal behaviour, and where
the quotient is finite the optimizer collapses to a finite weighted transducer —
a state machine that replaces the search.

The positive results are real and bounded. On coded-repair fleets a retained
composition tree answers an event in about 1.9 microseconds, flat in fleet size,
against a fresh solve of 4.93 milliseconds at 16,384 leaves, breaking even after
roughly one update; only two to four normalized boundary classes occur. Fixing
the *alphabet* rather than the state gives an exact computed transducer at 11.4x
fewer instructions than the tree — with the qualifier stated plainly, that
"transducer" means computed and not tabulated, since the reachable state set is
about 38,000 states out of 4.1e36 and a lookup table would miss almost always.
Boolean, counting and probability readouts all carry over the same state, each
checked against an oracle. One of them is a wrong answer and is recorded as one:
the probability readout over-counts by a factor of exactly twenty on a
three-pod fleet and returns values above one — it is a union-bound surrogate,
not a reliability.

**The decoder line is the substantial outcome.** Against PyMatching's sparse
blossom decoder, the dense compiled approach lost decisively — by 64x to 82x in
instructions at every distance, for structural reasons rather than
implementation ones. That loss caused a from-scratch, allocation-free sparse
matching kernel to be written, and after a sequence of narrowly targeted repairs
it stands at **sixteen of eighteen tested cells ahead by 2.5x to 11.5x**, with
two losses at a physical error rate of five percent (1.15x and 1.27x), which is
roughly fifty times hardware rates and is a scaling stress row rather than an
operating point. The margin grows with code distance and is largest exactly where
superconducting hardware operates: at a physical error rate of one in a thousand
it runs from 2.9x at distance three to **11.5x at distance twenty-five**.

Two things make that comparison unusually strong, and two limit it. In its
favour: there are **zero minimum-weight disagreements against the baseline across
all 360,000 shots**, and every answer is certified optimal by linear-programming
duality before it is returned — work the baseline does not do, and for which the
comparison nonetheless charges the new kernel. Against it: the family tested is
the repetition code under a phenomenological noise model with unit edge weights,
which specifically flatters the new kernel's fast paths; and the metric is
instructions per decode rather than the per-round latency and its tail, which is
what a real-time decoder's microsecond deadline actually governs. Both
limitations are stated in the source and are the reason the follow-on work
begins by rebuilding the benchmark grid rather than by tuning.

A **certified predecoder** — commit a correction only when it lies in the
intersection of optimal-witness corrections over every reachable boundary state,
which is a certificate and not a confidence heuristic — is a separate and
*negative* result. It is sound and general, and it does not reach distance nine
on the rotated surface code by any of five routes tried: enumeration cannot be
localized, because the committed quantity is a logical parity and the logical
operator spans the code; compilation dies on an exponential boundary alphabet;
the local-commit variant needs a radius growing like half the distance; the
margin variant costs 32,825 instructions per committed round against the
baseline's 2,296; and an exhaustive sweep over a twenty-bit ball of contexts
shows that no syndrome anywhere commits at the sound margin. **The construction
fails by one unit of margin**, which is a sharper statement than "it did not
work" and is what a successor would have to attack.

One correction belongs with this. A distance-one defect in the repository's own
rotated-surface-code construction — boundary checks placed so that two corner
data qubits lay in no check at any distance, one of them on the logical column,
making a single error there an undetected logical failure — was found and
repaired. **Every surface-code number taken before that repair is withdrawn.**
Every repetition-code number, which is the entire decoder comparison above, is
unaffected, because that family never used the defective construction.

### Structural causal models as a second context language

The same quotient primitive was pointed at a third kind of context: the set of
future *interventions* on a finite structural causal model. Two low-level states
are causally indistinguishable when no admissible intervention, followed by any
further admissible interventions, changes the observation. This reads exact
causal abstraction as a quotient to be *computed* rather than as a validity check
on a proposed abstraction, and it inverts the usual question — instead of "is
this proposed abstraction causally valid?", it computes the coarsest valid one
and returns a separating intervention whenever a proposed abstraction is too
coarse.

The spike is technically clean and its headline economic claim failed, for a
reason worth recording. An adversarial review killed the first lowering before
any code was written: a generator must be a total map on states, and pinning a
variable produces a solution of a *different* model, so the obvious encoding
computes plain observational equivalence while appearing to typecheck. The
repaired encoding carries the pinned assignment in the state. On that carrier the
minimum-cost intervention reaching a declared observation is one shortest path
over the monoid action on the quotient; it agrees with an enumeration oracle on
every query in six model families, every witness replays, and states compress by
up to 84x. But **hard interventions are idempotent and commutative**, so the
number of states materialized equals the number of solves a plain memo would
perform — measured at a ratio of 1.00 — and the compiled arm never crosses the
memoized re-solve, staying about 6.3x behind. Quotienting the graph is not what
failed: on the identical shortest-path problem over concrete states the compiled
quotient wins by 220x. *Materializing* the graph is what failed. The two
surviving directions follow directly: a compositional lowering along the model's
graph so the carrier is never materialized, and a non-idempotent edit vocabulary,
which is the only setting in which shortest path earns its keep.

### Symmetry reduction in exact quantum-code distance computation

The same "compile the symmetry, then search" principle applies to computing the
minimum distance of a quantum CSS code exactly, which is an integer program
over the code's coordinates. Two effects were separated and measured on the
bivariate-bicycle *gross code* \([[144,12,12]]\).

First, the conventional per-logical-class encoding destroys the code's own
symmetry: only an order-two matrix symmetry survives from a source translation
group of order \(72\). A class-independent global re-encoding restores the
\(\mathbf Z_{12}\times\mathbf Z_6\) translation action as a genuine symmetry of
the model, worth \(3.1\)x on its own. Second, adding automorphism-orbit
symmetry-breaking constraints on top of that gives a further \(4.2\)x. The
combined effect is a branch-and-bound tree reduced from \(13{,}228{,}127\) to
\(1{,}010{,}491\) nodes, a factor of \(13.1\). The same treatment on the binary
passant code \([78,36,12]_2\) gives \(6.5\)x, on top of a solver that already
recovers \(\operatorname{PGL}(2,13)\) unaided.

Every integer program closed at gap zero, so the distances themselves are
certified: \(d_Z=12\) for the gross code, matching the published value, and
\(d=12\) for the passant code, matching the independent committed computation
in the binary-conic-code work.

The same experiment has since been repeated against a commercial
mixed-integer solver, which makes the encoding claim sharper. The structural
fact underneath it is certified rather than measured: the gross code's semantic
translation group has order 72, while the conventional per-logical encoding
retains a matrix symmetry group of order two, and an independent
matrix-automorphism pass finds exactly that order-two group. Feeding the solver
the global re-encoding and then the certified orbit cover reduces twelve solves,
548,921 branch-and-bound nodes and 114.6 seconds to two solves, 26,930 nodes and
3.8 seconds: 20.38x fewer nodes, 30.43x fewer simplex iterations, 34.26x fewer
of the solver's own work units, and 30.10x less wall time, with every witness
passing an exact \(GF(2)\) replay and no solver log reporting a native symmetry
or orbital pass.

**Exact distances of large quantum codes.** The same front end has been used to
close distances that the published sources left as upper bounds. Two
non-abelian and dihedral lifted-product codes of length 1496, whose source
reports \([[1496,194,\le20]]\) and \([[1496,198,\le16]]\) from \(10^5\)
randomized trials, have exact distances 20 and 16; the first took about 3,089
and 1,159 seconds on its two check sides, the second about 548 and 100 seconds.
Among bivariate-bicycle codes, \([[288,12,18]]\), \([[360,12,24]]\) and
\([[784,24,24]]\) are certified exactly, the last in 127 seconds on sixteen
threads over 29.3 billion candidates in 23.4 MiB of resident memory.

That line has since been extended in three directions. First, **the entire
published lifted-product list of Liu and Marquardt now has exact distances**: the
six candidates left as randomized upper bounds from \(10^5\) trials are
\([[1428,186,18]]\), \([[1496,198,16]]\), \([[1496,192,16]]\),
\([[1496,198,14]]\), \([[1500,81,18]]\) and \([[1500,76,20]]\), and every
published bound turned out to be tight, so the contribution is the certification
rather than a corrected number. Among them \([[1428,186,18]]\) sets a new exact
rate–distance record \(kd^2/n=42.20\), beating the previous exactly known best by
1.245x and the bivariate-bicycle exact frontier by 2.20x, found in about 51
seconds of search through a verified right-translation anchor reduction worth a
factor of 42 to 60. Second, two codes from the published benchmark set of a
satisfiability-based distance solver were settled where that solver's own table
records that **none of its 46 configurations finished within a 7,200-second
limit**: `LP_714_100` is certified at exact distance 16 in under three seconds of
search on both check sides, and `LP_1768_224` is bracketed at \(22\le d\le24\)
against a published \(8\le d\le230\). For the second of those, an independently
verified bijection of all 1,768 coordinates transports both the physical row
space and the physical-plus-logical row space, proving \(d_X=d_Z\), so only one
direction needs the remaining exhaustion. Third, the bivariate-bicycle
\([[756,16,\cdot]]\) case is narrowed but **still open**: an exhaustion of
\(5.59\times10^{11}\) candidates gives \(28\le d\le34\) with \(d\) even, because
the all-ones vector lies in the check row space. It remains the one unfinished
exact distance in the portfolio.

The service pipeline around these computations was built and gated separately: a
live lower/upper bracket with provenance on each side so an interrupted job still
yields an answer, a competitive upper-bound pass, durable resume across process
and machine boundaries, an up-front feasibility estimate from sampled shards
accurate to nine percent on its acceptance run, and a certificate with a
verification mode. The cost of resumability was measured rather than assumed: on
a deep witness-free search it is about eight percent, and on a shallow search
that ends in a witness it is a factor of five, because independent shards cannot
share an improved bound. One finding constrains what such a certificate may
promise: the parallel search is deterministic in its conclusion but not in its
counters whenever a bound is published, giving a five percent spread in candidate
counts across repeated runs at eight threads and exact reproducibility at one.

**Trust tier for those distances.** Each is an exhaustive finite enumeration by
one reviewed implementation, with the witness at the attained weight decoded and
replayed by a second, independent implementation. That replay covers the upper
bound only: for the length-1496 dihedral code the checker confirms the
weight-16 witness but cannot independently re-run the hundred-billion-candidate
exhaustion behind the matching lower bound, which rests on the enumerator alone.
None of it is machine-checked in the proof-assistant sense. The comparisons
against outside tools are of three different strengths and should not be quoted
as one number: the gross-code round trip above is a clean same-machine,
same-solver, proof-to-proof comparison; the \([[360,12,24]]\) figure is a
cross-machine bound derived against a published 7,200-second timeout of a
specialized distance solver, self-described as single-round and exploratory; the
\([[288,12,18]]\) figure is against two sixty-second limits of a commercial
solver on one protocol; and the \([[756,16,\cdot]]\) case produced no comparison
at all, because the solver's installed licence rejected the model for size
before optimization — a licence artefact and not a measurement.

**A second modality: certified replay of a representation-theoretic
computation.** The same compile-then-search principle has been applied to a
frozen intertwiner calculation, rebuilt from \(GF(9)\) field arithmetic rather
than from the earlier symbolic answer. For the extra \(L(2,0)\) channel in
\(\operatorname{Sym}^2(\operatorname{Sym}^3E)\) it recovers 120 raw equations in
30 variables of rank 29 and Hom-dimension one, produces a deterministic 29-row
replay basis, and identifies exactly three minimum full-rank block cores, with
rank dropping only when the Weyl block is removed. The full five-channel corpus
is reproduced and agrees with the earlier extraction. This is a bounded finite
certificate over specific instances, not an all-field representation theorem,
and the source note says so. The engineering measurement alongside it — a 3.13x
faster replay from the compiled basis, with thirteen times fewer branch misses
under hardware counters — is reproducible rather than verifiable, like every
timing above.

**Trust tier and boundary.** The distances are certified by the solver's own
optimality proof together with explicit \(GF(2)\) invariance checks; nothing
here is machine-checked beyond that. The *node counts* are a property of one
solver's search: they are deterministic and replay exactly from committed logs,
but they are reproducible rather than verifiable, and every ratio quoted is
specific to that solver and that instance. Whether the reduction survives on
solvers with built-in orbital branching is untested and is the gate on any
external claim. This result is not assigned to a manuscript.

### Material outside the current manuscript

The paper deliberately omits extended EXIT theory, deletion--contraction,
secondary geometries, vector bandwidth, generic coefficient optimization,
and BGS packing. Sequential timing semantics and finite separator-control
algebras remain a separate theory layer. The formal library also contains a
\([10,4,6]_9\) seed with dual distance four that the manuscript does not use.

The admission rule for the main proof spine is deliberately strict: a result
enters the body only with an exact stable statement, a complete human proof
exposing the mechanism, an explicit claim-by-claim formal-coverage
classification, and exact attribution of imported inputs. Computations and
certificates may support appendices but do not carry a body theorem. Formal
absence is allowed only when it is stated plainly; it is not silently
promoted to verification.

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

## *Local-Unitary Rigidity and Quantitative Rounding for Stabilizer AME States*

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

The referee-repaired quantitative bridge covers \(m=2\) without losing the
printed radius or constant. A dimension-only \(8\varepsilon\) rounding result
for the induced logical action is now adopted: the physical Pauli correction
remains globally uncontrolled, but stabilizer cancellation removes it on one
chosen input leg. For odd-prime \([2m,m,m+1]\) MDS codes, a stronger banked
inter-code theorem says that fixed-party LU equivalence is exactly diagonal
equivalence to the target code or its dual; its criterion matches all twelve
earlier party-image censuses. The associated high-distance multiplier line and
five-type prime-field holonomy classification are also settled, while the
inter-code theorem remains reserved for a focused companion revision.

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
coefficient-aware recovery structure and the scheme-theoretic jet quotient
both recover information erased by support reduction, but no
recovery-equation-to-Rees-algebra functor is known.  Finally \(R_5\) supplies the
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

## *Standard Flips of Discrepancy One: Extremal \(J\)-Normalization*

This is a short standalone correction note, published locally with a DOI, and
the only externally released item to come out of the stabilization programme so
far. Shen and Shoemaker compute the extremal quantum spectrum of a standard flip
and show that the Gamma-class decomposition attached to the
Belmans–Fu–Raedschelders semiorthogonal decomposition is a decomposition into
asymptotic classes. Their identification of an explicit hypergeometric series
with the extremal \(J\)-function of the local model assumes \(r-s>1\), and their
Barnes asymptotic expansion is applied under the same inequality, while several
of their later theorems are stated in a range that includes blow-ups. The
printed proof chain therefore does not reach the discrepancy-one case
\(r=s+1\), \(s\ge1\), which contains **every codimension-two blow-up**.

The note supplies the two missing steps. First, the degree-\(d\) summand of
their series has \(z\)-order at most \(1-s-(r-s)d\), so at \(r=s+1\), \(s\ge1\)
it is at most \(-1\) for every \(d\ge1\); the series is therefore already
\(J\)-normalized with no mirror-map correction, and uniqueness of the
\(J\)-slice of Givental's cone identifies it with the extremal \(J\)-function.
The cone membership this uses is proved rather than quoted: for projective
bundles it follows from Brown's toric-fibration theorem with the twisted theory
of Coates and Givental, and the general case from a flag-bundle pullback and a
deformation to the associated graded, none of which restricts \(r-s\). The only
remaining formal failure is the degenerate endpoint \((r,s)=(1,0)\), whose point
fibres contain no extremal line. Second, at \(\nu=r-s=1\) the printed Barnes
sector is unavailable, because their own aperture theorem holds with the wider
opening only for \(\nu>1\); the correct half-width sector still meets the
neighbouring sector in an open sector of opening \(2\pi\) containing both the
nonzero-eigenvalue ray and the tame ray. With those two inputs repaired, their
conclusions extend to every standard flip of discrepancy one. Nothing else in
their argument is altered.

## Unassigned adjacent results

### Brouwer's exceptional exterior sets: a bridge, and a rediscovery

Brouwer's complete census of exceptional complete exterior sets of a conic —
published inside Blokhuis, Seress and Wilbrink 1992 and covering the field orders
7, 11, 19, 23, 27 and 31 — was reconstructed here and this programme's invariants
were run over it. Two things came out, and only one of them is new.

What is new is a **bridge between two disjoint literatures**: the exceptional
complete exterior set at field order 31 *is* the Clebsch hexagon together with
its ten Brianchon points, so the entries at field orders 11 and 31 of that census
are one projective figure at two completion levels — six points meeting the
completion size \((q+1)/2\) at eleven, and sixteen points meeting it at
thirty-one. The mechanism is exactly that: the figure has six vertices and ten
Brianchon points at every field order, while the completion level grows, so the
two equations \(6=(q+1)/2\) and \(6+10=(q+1)/2\) each have one solution. **That
is why the icosahedral group appears exactly twice in Brouwer's census.** No work
citing both literatures was located in any of three citation databases.

What is *not* new is the figure itself. A full-text reading of Dye's 1991 paper
on hexagons, conics and the icosahedral group, from page scans with every
load-bearing passage checked against the images rather than an optical
reconstruction, shows that Dye already proves for every field where the figure
exists that it is a single projective figure, that each of its fifteen chords
carries exactly two Brianchon points, that its stabilizer is the icosahedral
group, and — as an explicit congruence — that the Brianchon points are external
precisely when \(q\equiv1\pmod3\). Substituting the two field orders reproduces
the finding exactly. The contribution is therefore stated as the census bridge,
with Dye cited for the figure.

A declared null was refuted along the way. The match between ten vertices and
fifteen edges had been suspected of being forced by any six-arc and therefore
empty of content. It is not: across the 453 six-arcs inside the field-order-31
configuration the Brianchon count ranges over \(0,2,3,4,6,10\), and at field
orders 19, 23 and 27 the best six-subset of the exceptional configuration reaches
only 6, 4 and 6. Ten is the top of the spectrum, attained by the special
configurations and not by six-arcs in general, and exactly one of the 453 arcs has
its ten Brianchon points equal to the complementary ten points of the exterior
set. Stabilizers were separated by element-order spectrum rather than by order
alone. Both results carry the mining lane's provisional marker: they are one
session's reasoning over its own computation and have not been independently
vetted.

### Residual multipliers for Hadamard order 668

Order \(668=4\cdot167\) was, until August 2026, the smallest order with no
known Hadamard matrix. On 2026-08-12 a team at Anthropic (Levent Alpöge with
two colleagues and Claude) announced constructions for order 668 and the
eleven other previously open admissible orders below 2000, released as an
encoded string with a decoder rather than a paper, with the search method
undisclosed. That payload has since been decoded and identified here, and the
account is below. The results recorded first predate the announcement and
concern the Legendre-pair route, which
reduces to a census of possible fixed common multiplier subgroups for length
\(333\); they remain valid as statements about that route. Of the \(30\) mod-\(3\)-compatible subgroups,
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
matrix of order \(668\) is constructed here; existence at order \(668\) is now
settled externally, so the residual census is of interest only for the
Legendre-pair question at length \(333\).

### What the order-668 announcement actually contains

The announced payload was retrieved from two independent mirrors that returned
byte-identical bytes, and its decoder was never executed: its shell obfuscation
was undone statically and the decoding re-implemented from scratch. It carries
twelve orders — 668, 716, 892, 1132, 1244, 1388, 1436, 1676, 1772, 1916, 1948
and 1964 — under a header of twelve fixed-width records that consume the payload
exactly, which is the check that the header was read correctly. All twelve
decoded matrices satisfy \(HH^{\mathsf T}=nI\) exactly, verified in exact
integer arithmetic by two implementations with two parsers on bytes pinned by a
committed hash list. The payload contains no seed and no generator: every
character is a literal entry of a first row or a border, so the compression is
purely structural, and for order 668 the whole information content is 664 bits.
Whatever search produced the sequences left no trace in what was posted.

The structure is classical. Order 668 is a bordered Goethals–Seidel array with a
border of width four over four \(\pm1\) circulants of length 166, with one
deviation from the textbook array: the six blocks of the lower-right corner
carry an extra cyclic shift by two. The four sequences have row sums
\((2,0,0,0)\), their periodic autocorrelations sum to \(-4\) at every nonzero
shift, and their squared row sums total four, which is exactly the hypothesis
the bordered array needs. Orders 716, 1676 and 1772 have the same shape; orders
892, 1132, 1244, 1948 and 1964 are the plain Goethals–Seidel array over four
circulants of prime length; and orders 1388, 1436 and 1916 are bordered over
block-circulant super-blocks, where the array's reversal is a per-group block
reversal rather than a matrix transpose. The orthogonality statement is
formalized in Lean with the inner shift as a free parameter, so the classical
array is the zero case and order 668 is an instance of a stated theorem rather
than a one-off; order 668's orthogonality is proved there from its 664 sequence
characters rather than from its matrix entries.

The matrix has almost no symmetry: \(|\operatorname{Aut}(H_{668})|=4\), the
central sign involution times the half-shift by 83 and nothing else. The lower
bound is proved without a solver by dephasing, which is a complete invariant for
the row and column sign group; the matching upper bound came from two
independent graph-automorphism programs on the same coloured graph. Reaching it
required a vertex invariant, and which invariant can work is forced: on a
Hadamard matrix every pair and triple statistic is constant, and odd products
are not monomial invariants at all, so quadruples are the first level that is
both invariant and non-constant. Colouring rows by their multiset of quadruple
correlations splits the 668 rows into 336 classes and makes the search finish in
seconds where it made no progress at all otherwise. Order 716 also has
automorphism group of order four; order 892 has order six, from an element of
order three that permutes the four circulant blocks. Larger orders were not
computed and nothing is claimed about them. A separately posted order-2060
matrix was also checked and holds, and is a plain Goethals–Seidel array over
four blocks of order 515 disguised by a Chinese-remainder interleaving of the
index order; with it closed, the smallest open admissible order is
\(2092=4\cdot523\).

None of this touches the census above. Order 668 was settled by a bordered
Goethals–Seidel array with a four-row border over four circulants of length 166,
whereas the Legendre-pair route would give a bordered two-circulant matrix with
a two-row border over two circulants of order 333. The Legendre-pair test was
run on the decoded matrix, as given and after dephasing, and does not fire, so
no census exclusion is contradicted, none of the five residual survivors is
realized, and the existence question for a Legendre pair of length 333 remains
open. One priority exposure is recorded rather than resolved: \(333=37\cdot3^2\)
has the form \(pq^2\) and therefore falls inside the length family of a 2026
paper on binary Legendre pairs of length \(pq^2\), which was available here at
abstract and metadata depth only.

### The smallest open Hadamard order, 2092, and what has been excluded there

Order \(2092=4\cdot523\) is completely open, and the work on it is deliberately
reframed from a construction race into **class exclusion**: certified statements
that no Hadamard matrix of a named structural shape and multiplier symmetry
exists, which is a theorem, rather than a heuristic report that none was found.

On the bordered route, with a four-row border over four blocks on the cyclic
group of order 522, four multiplier shards are closed by proof or exhaustion —
one by an unsolvable linear congruence, one by exhausting all 2,496 admissible
roots over more than five billion probes with an independent enumeration oracle
confirming, one by an energy gap of 592 between a proved minimum of 2,665 and the
required 2,083, and one emptied at an intermediate level. A uniform level test
then empties 148 of the 167 nontrivial multiplier units outright, leaving only a
subgroup of order seven and groups of order at most four. On the plain route the
admissible parameter sets are exactly the 33 representations of 2092 as a sum of
four positive odd squares, and an exact size congruence proves **no plain
supplementary difference set on the cyclic group of order 523 is invariant under
any multiplier subgroup of order at least eighteen**, which closes the cheap
cyclotomic tier by theorem rather than by search.

Two negatives are recorded as searches rather than as theorems, and are labelled
that way. An unrestricted campaign of 288 billion mutations across 288
independent workers never beat a residual of 96; and a four-norm argument proves
that **no congruence of any modulus can ever exclude the surviving deviation
patterns**, so only a lattice or counting argument could, which tells a successor
where not to look. One incidental construction did fall out of the improved local
search: a certified Hadamard matrix of order 388 from a spin shard, obtained
through an exact per-swap delta identity that is proved and transfers to the
bordered sectors. The existence questions for order 2092 and for a Legendre pair
of length 333 are both untouched and open.

### A certified finite no-go for transversal non-Clifford gates

Over **every** binary quantum CSS code of length at most eight — an exhaustive
enumeration of 8,044,851 flags at length eight — an X-check weight of at most
seven admits no diagonal transversal gate at level three or above of the Clifford
hierarchy. Two corollaries follow: at length at most seven the hierarchy caps at
level two at every weight, so **eight qubits is the minimum length for a diagonal
transversal non-Clifford gate**; and at length eight, level three occurs only at
full X-check weight, uniquely for \([[8,3,2]]\). The threshold
\(w_X\ge2^{\ell-1}\) is attained at every level up to six along the Reed–Muller
ladder to length 64.

The proof gap is named exactly rather than absorbed: the \(\pm1\)-phase gate of
\([[8,3,2]]\) evades the textbook uniform-phase divisibility argument and yet
lands exactly on the threshold, so the threshold is not explained by that
argument. The length-nine pass at check weight at most six is excluded from the
claim, with the exact resume command recorded. Alongside the census, the complete
diagonal transversal group was computed for several small codes by Smith normal
form over all real phases, giving exact classifications — \([[16,4,2]]\) admits
exactly the triply-controlled phase gate, \([[32,5,2]]\) exactly the
quadruply-controlled one, and \([[31,1,3]]\) a logical group that is cyclic of
order sixteen, hence level four — together with exact negatives for the Steane,
\([[15,7,3]]\) and Shor codes. This is an exhaustive finite verification, not a
structural theorem, and it is not assigned to a manuscript.

### Projective planes of order twelve: certificates yes, elimination no

Two eliminations are certified and, being classical, are explicitly not claimed
as new: a plane of order twelve admits no point-regular collineation group, by a
multiplier-orbit certificate together with an exact exhaustion of \(1.18\times
10^{11}\) nodes, so every collineation of prime order fixes a point and a line;
and the order-six and order-seven controls are eliminated. A reduction is proved
— the order-thirteen tactical decomposition is solvable, so that case cannot die
at decomposition level — and a new bridge is recorded between hyperoval external
lines, one-factorizations of the complete graph on fourteen vertices, and
starters in the cyclic group of order thirteen, with all 133 starters enumerated
together with Hall-deficient witnesses.

The target itself was not reached, and the negative is stated as the sharp thing
it is: the order-thirteen-invariant hyperoval was not eliminated, no
sub-elimination was obtained, and the depth-three survivor counts show that
**assuming the hyperoval makes the problem harder rather than easier** — it
shrinks the exploitable symmetry group and raises the survivor count from
\(8.2\times10^8\) to \(2.04\times10^9\). What is kept is an exact reformulation
and a lossless reduction from eleven-factorial to 139 classes, brute-verified at
small parameters and validated end to end by reconstructing the plane of order
four and eliminating order six. The successor route is algebraic rather than
combinatorial. No novelty claim is made pending a literature audit.

### A code ladder along the exceptional root systems — pre-empted

This track is recorded for completeness and as a closed route, not as a claim.
A literature audit found the individual level codes to be folklore, the linking
operation to be a published theorem, and the tower itself to be named and related
in the strongly-regular-graph literature; a follow-up pass then removed the one
residue that had looked like new content. The verdicts are stated after the
construction below, and nothing here should be written up as novel.

Each exceptional level carries one binary code: restrict the affine linear
functions to the nonsingular vectors of a mod-two quadratic space. One repeated
operation links consecutive levels — take the link of a root, fold antipodal
pairs, shorten — giving
\[
 [496,11,240]_{E_{10}}
 \to [240,10,112]
 \to [120,9,56]_{E_8}
 \to [28,7,12]_{E_7}
 \to [27,6,12]_{E_6}.
\]
The \(240\)-point member is the root link of an \(E_{10}\) root and coincides
with the affine \(E_9\) code built from the affine root lattice; the
complementary \(256\)-point root hyperplane is \((E_8\oplus A_1)/2\) and gives
\([256,10,120]\) against an exact record of \(124\).

Attaining the unrestricted optimum is not a property of the exceptional series.
Scoring the whole family by type shows every tabulated even-rank level of both
types is optimal, minus type included, while the parabolic levels are the sole
shortfall and their deficit grows: optimal at rank five, one below at rank seven,
four below at rank nine. That growth is the one numerical pattern here with no
mechanism behind it.

Three barriers are closed by proof rather than by failed search. No
\(O_8^+(2)\)-invariant code of dimension ten contains the \(E_8\) code, so the
exact record dimension \([120,10,56]\) is incompatible with full root-pair
symmetry. No Plotkin \(|u|u+v|\) code at \([240,10]\) with length-\(120\) halves
beats distance \(112\). And every unsigned quantum lift stalls at CSS distance
four, one below the exact \([[28,14,5]]\) and \([[120,102,5]]\) records; the
canonical repair alphabet, \(E_8/2E_8\cong\mathbf F_4^4\) over the Eisenstein
integers with \(\omega\) acting freely on the \(120\) coordinates in \(40\)
orbits, does not fix it. The natural nine-dimensional \(\mathbf F_4\) code there
is Hermitian self-orthogonal at exactly the record dimension yet still has dual
distance four, because conjugation and every \(\mathbf F_4\)-linear functional
are additive and so inherit all \(32{,}130\) tetrads as weight-four dual words.
Additivity, not the alphabet, is the obstruction, and it explains the
distance-four stall at every level simultaneously.

**The pre-emption, in three layers.** The level codes are Calderbank--Kantor
two-weight codes; the \(E_8\) root-pair code, the \(E_7\) bitangent code and the
\(E_6\) code are known in substance, point set, weights and all, and the \(E_6\)
code reaches the same family by a second route through its own Cartan-cubic
monomial support, landing on the minus-type elliptic-quadric two-weight code — so
all three level codes are one family read at three ranks. The fold is
Brouwer--Shult (1990), available as Proposition
3.6.1 of Brouwer and Van Maldeghem's *Strongly Regular Graphs*: in the graph on
the nonsingular points of a quadratic form over \(\mathbf F_2\), the vertices at
distance two from a fixed vertex form the Taylor extension of the graph two ranks
down, and a Taylor extension is an antipodal double cover whose classes are the
fold. That theorem is about arbitrary finite graphs under a coclique-parity
condition — type and rank enter only on application — and it is a biconditional,
so it subsumes any binary converse worth proving. The same book names the bottom
three levels outright: the graph on the \(120\) root pairs comes from the \(E_8\)
root system, its local graph is the Gosset graph, itself the Taylor extension of
the Schläfli graph, labelled there the \(E_6\) graph. Finally the code-level fold
turns out to be a formal property of any matched Taylor double — every row has
fibre-difference all-ones, so the fibre-constant subcode has codimension one and
folds onto the base graph's code — verified against the quadric links, the Paley
two-graphs, the pentagon, and random graphs, with no quadratic form involved
anywhere. An earlier claim that the code-level fold works only at plus type, and
therefore carried content beyond the graph statement, was withdrawn as an
indexing error. What survives is the weight-enumerator statement at code level
and the affine-root-lattice carrier, which is too thin to carry a paper. Two
narrow frontiers remain: the parabolic deficit, and whether \(120\) points of
\(\operatorname{PG}(8,4)\) can sit in four-general position invariantly under a
large proper subgroup of \(O_8^+(2)\), which is not expected to work.

Two limits on the audit itself should travel with any use of this material.
Chakravarti's 1990 chapter in the IMA volume is held at metadata only and must be
read at full text before any design claim, and MathSciNet was not covered, so
every negative here carries a "to our knowledge". On the quantum side there is no
located predecessor for this particular construction, but an adjacent
code-conformal-field-theory literature builds stabilizer codes from \(E_8\) root
lattices, so no blanket absence claim is available there and that literature must
be cited rather than treated as unrelated.

### The query complexity of reconstructing an aligned design

The third paper proves that aligned four-sets determine a two-graph. That
raises a quantitative question the paper does not ask: how many alignment tests
does a reconstruction actually cost? A two-graph on \(n\) points carries
\(D=\binom{n-1}{2}\) bits, a 4-set is *aligned* when its four triples carry
equal \(\tau\), and a family of 4-sets is *separating* when the answers
determine the two-graph.

Adaptively the constant is exact. An explicit decoder reads the two-graph in
\(\binom n2+n-4\) alignment tests on every instance, against a counting lower
bound of \(\binom n2-n\), so the adaptive constant is exactly \(1/2\) and the
coherence restriction costs nothing to leading order. Nonadaptively the
constant is bracketed rather than known,
and the bracket has been narrowed by a factor of \(8/3\) from above, to

\[
  0.616\,n^2\;\le\;\mathrm{minimum}(n)\;\le\;\tfrac98n^2+O(n),
\]

replacing an earlier upper bound of \(3n^2-23n+45\). The upper bound is a
proved construction, not a search: nonadaptivity constrains the queries and not
the decoding, so a separating family may be built as a base on seven points plus
one attachment layer per further point, and the layer is assembled from blocks
of four points costing nine tests each. Correctness is an attachment lemma plus
a composition argument, resting on the exhaustively computed attachment
constants \(g(5)=9\) and \(g(6)=12\), each obtained from three independent
solvers, with \(g(7)=15\) exact.

The eight-point constant is now exact as well: \(g(8)=17\), closing an interval
that had stood at \(15\le g(8)\le17\). Both smaller sizes are excluded by
finite theorem rather than by timeout. The separation condition is recast
exactly — a triple family separates an attachment cut precisely when the graph
on the crossing point-pairs is non-bipartite, equivalently contains an
odd-cardinality Eulerian subgraph — and the resulting parity encoding, with
symmetry broken by a lex-leader over the stabilizer of one fixed triple, is
unsatisfiable at exact sizes 15 and 16 and satisfiable at 17. Since separation
is monotone under adding triples, the size-16 refutation alone excludes every
smaller family. The boundary is that both refutations are certified rather than
human: the solver emitted binary resolution proofs which an independent proof
checker verified, and the satisfying family at 17 was decoded and replayed by a
separate implementation of the cut-graph check. Reducing the size-16 refutation
to a human argument has been attempted and has not succeeded; what the proof
core does show is that the obstruction genuinely couples the \(2+6\), \(3+5\)
and \(4+4\) cut strata — any two of the three are satisfiable at size 16 and
all three together are not — so the target for a structural proof is a
three-stratum incompatibility theorem, and that statement is relative to the
current encoding rather than absolute.

Which end of the bracket is loose is settled in favour of the floor. A star-flip
argument gives \(\mathrm{minimum}(n)\ge\lceil n\,g(n-1)/4\rceil\), which already
beats the entropy floor wherever \(g\) is known exactly — 21 against 18 at seven
points, 30 against 25 at eight — but it caps out there, and the two natural
lower-bound routes, the polynomial method and a covering argument, are both
closed for stated reasons. Every exactly measured family costs between 2.25 and
3 alignment tests per recovered bit while the entropy floor licenses 1.2326, so
the remaining mechanism worth trying is a bound from the distance distribution of
the alignment code itself. None of this is in any manuscript.

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

That global rematching has since been attacked directly, and the outcome is a
sharper target plus the discharge of the smallest field. Two edge relations were
compared. The natural sparse one, joining a new defect to a consumed label when
the line through them carries a point of the residual, is **false as a universal
invariant**: nearly a fifth of the exhaustively enumerated exchanges over
\(\mathbb F_{11}\) are Hall-deficient under it. The complete relation, which
joins every new defect to every consumed label, needs no incidence data at all,
and its Hall condition collapses to the single count inequality
\(|\text{consumed}|\ge|\text{created}|\). With the charge accounting proved — the
charged support of the successor is \(|\operatorname{Def}(A)|-|\text{consumed}|
+|\text{created}|\) — strict support descent is *exactly* strict inequality
there. **So the live proof object is a counting statement, not a matching
statement, and the matching engine is a verifier rather than the algorithm.**

Over \(\mathbb F_{11}\) the statement is settled exhaustively across all
1,560,900 legal size-four states and all 10,890,000 complete exchanges: the count
inequality never fails, and both lexicographic orderings of charged support
against the overload coordinate strictly decrease every time. But strict support
descent *alone* is false there — 363,000 exchanges leave the support flat, and in
every one the overload drops to zero — so the correct well-founded coordinate at
that field is the lexicographic pair.

The decisive fact about \(\mathbb F_{11}\) is that it is game-semantically empty.
Every one of the 10,164,000 defect-creating exchanges has a zero-overload
successor, and every such successor has nonzero Grundy value on its legal-point
conflict graph, hence is a first-player win lying outside every sound survivor
set. **No complete old-labelled exchange creating a genuinely new defect can be
part of any sound survivor strategy at \(q=11\).** That upgrades an earlier
sampled observation to an exhaustive theorem, retroactively explains it, certifies
away every previously reported Hall failure there as sitting on a dead position,
and — the operative consequence — means **no amount of searching at \(q=11\) can
produce the counterexample the acceptance gate asks for**. The degeneracy is a
legal-density coincidence of the small field: a size-six residual there has about
1.2 legal moves and no positive overload, against 5.4 moves and three percent
positive overload at \(q=13\).

The search therefore moves to \(q=13\), which is the smallest field where the
question has content. There a deterministic sample of 50,000 states and 20.7
million exchanges gives strict surplus every time, with no equality cases and no
failures even under the sparse relation, on a domain that is demonstrably alive.
This is a large sample and not an exhaustion. What is open is unchanged in
substance and sharper in form: prove \(|\text{consumed}|\ge|\text{created}|\),
strictly for \(q\ge13\), from the projective incidence structure of a complete
exchange. There are zero counterexamples in 10.9 million exhaustive and 20.7
million sampled exchanges, and no proof.

## The Gram–discriminant shadow of four points and its Dickson tower

Let \(V\) be a two-dimensional vector space over a field \(K\), and for \(d\ge1\)
let \(B_d\) be the \(SL(V)\)-invariant bilinear form on \(\operatorname{Sym}^dV\)
normalized on pure powers by \(B_d(\ell^d,m^d)=[\ell,m]^d\), where \([\ \cdot\ ]\)
is the bracket of two linear forms. Given \(r\le d+1\) linear forms
\(\ell_1,\dots,\ell_r\) with product \(F=\prod_i\ell_i\), set
\[
 G_{d,r}(\ell_1,\dots,\ell_r)=\det\bigl(B_d(\ell_i^d,\ell_j^d)\bigr)_{i,j=1}^r .
\]
This is the Gram determinant of \(r\) points of the degree-\(d\) rational normal
curve against the invariant form. Over a finite field its square class is a
computable \(\pm1\) label attached to an \(r\)-subset of the projective line, and
the whole section is about what that label remembers. The case \(d=4\), \(r=4\)
is the four-point shadow used in the first of the numbered papers; everything
below is the family it sits in.

Nothing in this section is formally verified. The boundary that matters here is
between a proof, a symbolic identity checked exactly over \(\mathbf Q\) in a
stated range of \(m\), an exhaustive finite census over a stated range of primes,
and a statistical measurement; each claim below says which it is.

### The organizing factorization, and the part of it that is classical

Write \(\Delta(F)=\prod_{i<j}[\ell_i,\ell_j]^2\) for the discriminant of the root
form. Dividing the exterior product of the pure powers by the Vandermonde,
\[
 \Psi_{d,r}(F)=\frac{\ell_1^d\wedge\cdots\wedge\ell_r^d}{\prod_{i<j}[\ell_i,\ell_j]},
\]
gives a symmetric expression that descends to \(F\), and taking the induced norm
of the identity \(\ell_1^d\wedge\cdots\wedge\ell_r^d=\bigl(\prod_{i<j}[\ell_i,\ell_j]\bigr)\Psi_{d,r}\)
yields
\[
 G_{d,r}(F)=\Delta(F)\,\Phi_{d,r}(F),
 \qquad
 \Phi_{d,r}(F)=B_d^{\wedge r}\bigl(\Psi_{d,r}(F),\Psi_{d,r}(F)\bigr),
\]
with \(\Phi_{d,r}\) an invariant of binary \(r\)-ics of coefficient degree
\(2(d-r+1)\). The Gram divisor therefore splits canonically into the collision
boundary \(\Delta=0\) and an interior divisor \(\Phi_{d,r}=0\) on the moduli of
\(r\) points. At \(r=d+1\) the residual invariant has degree zero and one
recovers the ordinary Vandermonde identity; for \(r>d+1\) the determinant
vanishes for dimension reasons. At \(d=r=4\) the residual has degree two, the
degree-two invariant space of a binary quartic is one-dimensional and spanned by
the apolar invariant \(I\), so \(G_{4,4}=16\,\Delta I\) is forced without
expanding a determinant.

**Priority concession.** The map \(\Psi_{d,r}\) is the classical Wronskian
isomorphism \(\bigwedge^rS_d\simeq\operatorname{Sym}^r(S_{d-r+1})\) of
Abdesselam–Chipalkatti, given in an explicit arbitrary-field form by
McDowell–Wildon, and dividing an alternant by its Vandermonde is the standard
Schur-polynomial mechanism. The norm identity was not located in the inspected
sources, but it follows immediately once that map and the invariant form are put
side by side, so it is classified as a **classical-derived corollary and not as a
novelty theorem**. The quartic case is weaker still: Kaipa–Patanker–Pradhan
already derive the apolar factor \(\lambda^2-\lambda+1\) and count its
finite-field square classes. What follows the factorization is where a priority
claim can begin, and every such claim carries a "to our knowledge" qualified by
the audit's recorded coverage gaps — MathSciNet, Google Scholar and the
nineteenth-century symbolic and compound-matrix originals were not covered.

### Integrality, the modular radical, and the parity ceiling

Three structural laws bound where the shadow can carry information.

*Integrality with a content law.* \(\Phi_{2m,4}\in\mathbf Z[\lambda]\), and its
content is \(16\) when \(m\) is a power of two, \(p\) when \(m=p^k\) for an odd
prime \(p\), and \(1\) otherwise; computed exactly for \(m=2,\dots,18\). Because
\(G\), \(\Delta\) and \(\Phi\) are integral bracket polynomials, the
factorization reduces modulo every prime and never fails; what varies is whether
the reduction is informative, and \(\Phi\equiv0\bmod p\) happens exactly when
\(m=p^k\).

*Modular radical.* Over \(\mathbf F_p\) the form \(B_d\) is nondegenerate exactly
when \(d+1=ap^k\) with \(p\nmid a\) and \(a<p\); verified for all \(d<30\) and
\(p\le29\). The Wronskian map itself is available over every field, but a
nondegenerate Gram reading of it is characteristic-sensitive, and that
distinction is the useful modular content of the construction.

*Parity ceiling.* The invariant form on \(\operatorname{Sym}^dV\) is symmetric for
even \(d\) and alternating for odd \(d\). Hence \(G_{d,r}=0\) identically when
\(d\) and \(r\) are both odd, and \(G_{d,r}\) is a Pfaffian square when \(d\) is
odd and \(r\) even. A nontrivial quadratic-character shadow can therefore exist
only in even Veronese degree; verified symbolically at \((5,3)\), \((7,3)\),
\((7,5)\) and, with fully generic roots, at \((d,3)\) for \(d=5,7,9\), with the
Pfaffian square exhibited at \((5,4)\), \((7,4)\), \((7,6)\).

*Closed form at \(r=4\).* The Plücker relation for four linear forms makes
\(x=[12][34]\), \(y=-[13][24]\), \(z=[14][23]\) satisfy \(x+y+z=0\); with
\(I=-e_2\), \(\Delta=e_3^2\) and \(p_k=x^k+y^k+z^k\), Newton's identities collapse
to \(p_k=Ip_{k-2}+e_3p_{k-3}\) with no denominators, and
\[
 G_{d,4}=2p_{2d}-p_d^2\ (d\text{ even}),\qquad G_{d,4}=p_d^2\ (d\text{ odd}),
\]
so \(\Phi_{d,4}\in\mathbf Z[I,\Delta]\) with leading coefficient \(d^2\), and for
odd \(d\) the Pfaffian residual is exactly \(p_d/e_3\). Verified symbolically for
\(d=4,\dots,16\). The denominators visible in the older \((I,J)\) presentation are
an artefact of choosing \(J\) rather than \(\Delta\) as the second generator.
At \(r=3\) the answer is \(\Phi_{d,3}=2\Delta_3^{(d-2)/2}\) for even \(d\).

**A refuted guess.** The sharp conjecture \(\Phi_{d,r}=c\cdot\operatorname{perm}([ij]^{d-r+1})\)
is false, first at \((d,r)=(6,4)\): the Wronskian isomorphism is not an isometry,
because \(\operatorname{Sym}^r(\operatorname{Sym}^{d-r+1})\) is reducible. The
genuine plethysm decomposition of \(\Psi_{d,r}\), and with it a closed
transvectant formula for general \((d,r)\), is open; so is the \(r=5\) analogue
on \(x+y+z+w=0\).

### The tower of four-point covers over the rationals

Fix \(r=4\), put \(d=2m\), normalize the four points to \((\infty,0,1,\lambda)\)
and write \(u=\lambda(1-\lambda)\). Then \(\Phi_{2m,4}\) is a polynomial in
\(\lambda\) of degree \(4m-6\), and the square-class shadow is governed by the
hyperelliptic curve \(C_m:y^2=\Phi_{2m,4}(\lambda)\).

*A four-factor product law, proved for all \(m\):*
\[
 u^2\,\Phi_{2m,4}(\lambda)=\prod_{\varepsilon,\eta\in\{\pm1\}}
   \bigl(1+\varepsilon\lambda^m+\eta(1-\lambda)^m\bigr),
\]
one line from the Dickson definition. It gives the functional equation
\(\lambda^{4m-6}\Phi_{2m,4}(1/\lambda)=\Phi_{2m,4}(\lambda)\) with constant one,
and exhibits the branch locus as a union of four generalized Fermat loci. On the
\(u\)-line everything descends through Dickson polynomials: with
\(L_m=L_{m-1}-uL_{m-2}\) and \(P_m=(1-L_m^2)/u\) one has the proved closed form
\(\Phi_{2m,4}=P_m(P_m+4u^{m-1})\), equivalently an order-three linear recurrence.

*Genus law (proved).* \(\Phi_{2m,4}\) is squarefree over \(\overline{\mathbf Q}\)
except at the two roots of \(I=\lambda^2-\lambda+1\), where the multiplicity is
exactly two and only when \(m\equiv1\pmod 3\). Hence
\(g(C_m)=2m-4\), dropping to \(2m-6\) exactly on \(m\equiv1\pmod3\). An earlier
report gave the drop as \(2m-5\); that was an off-by-one from dividing out only
one factor of \(I\), and it is corrected here.

*Chevalley–Weil theorem (proved twice).* The square-class model of
\(\Phi_{2m,4}\) is exactly invariant under the anharmonic group acting on
\(\lambda\), so \(\operatorname{Aut}_{\mathbf Q}(C_m)\) contains a copy of
\(S_3\), and \(H^0(\Omega_{C_m})=a\cdot\mathrm{triv}+b\cdot\mathrm{sgn}+c\cdot\mathrm{std}\)
with
\[
 a=b=\Bigl\lfloor\frac{m-2}{3}\Bigr\rfloor,\qquad c=\frac{g-2a}{2},
 \qquad g=2m-4-2\,[\,m\equiv1\bmod3\,].
\]
The two proofs are independent: an explicit character computation on the basis
\(\lambda^i\,d\lambda/y\), symbolically verified for \(m\le40\), and an
equivariant Riemann–Hurwitz count. The equality \(a=b\) is forced rather than
coincidental, because every transposition has trace zero on \(H^0(\Omega)\) when
\(g\) is even. One correction travels with the theorem: the naive lift of
\(\tau:\lambda\mapsto1/\lambda\) satisfies \((\sigma\tau)^3=\iota\), the
hyperelliptic involution, so \(\sigma\) and \(\tau\) generate a dihedral group of
order twelve and the acting \(S_3\) is \(\langle\sigma,\iota\tau\rangle\); the
containment claimed earlier stands, its generator does not.

*The modular ladder and where it ends.* Explicit \(S_3\)-quotient models come
from the syzygy \(J=I^3/W^2\) with \(W=\lambda(\lambda-1)\), giving
\(C_m/S_3:Y^2=R_m(J)\) and \(C_m/S_3':Z^2=(4J-27)R_m(J)\).

| \(m\) | \(g(C_m)\) | \((a,b,c)\) | modular datum                                                                                    |
|------:|-----------:|:------------|:-------------------------------------------------------------------------------------------------|
| 3     | 2          | \((0,0,1)\) | the two descent quotients agree, elliptic of conductor 90; \(\operatorname{Jac}(C_3)\sim E_1^2\) |
| 4     | 2          | \((0,0,1)\) | both quotients elliptic of conductor 14, the unique newform at that level                        |
| 5     | 6          | \((1,1,2)\) | \(S_3\)-quotient conductors 150 and 2550; elliptic factor of level 150                           |
| 6     | 8          | \((1,1,3)\) | \(S_3\)-quotient conductors 1584 and 2046; elliptic factor of level 1584                         |
| 7     | 8          | \((1,1,3)\) | \(S_3\)-quotient conductors 637 and 6370                                                         |
| 8     | 12         | \((2,2,4)\) | isotypic surfaces absolutely simple; the standard part is a simple fourfold                      |

The three sign-side conductors all exceed the level-1600 bound of an earlier
newform search, which is why that search returned nothing. At \(m=3\) the
supersingular anomaly is resolved and is not complex multiplication: \(E_1\) has
conductor 90, rational torsion \(\mathbf Z/4\) and a rational 3-isogeny, and the
least common multiple of rational torsion orders across an isogeny class divides
\(p+1\) at every supersingular prime, which forces \(p\equiv11\pmod{12}\)
(exhaustive for \(p<2000\); 22 vanishing traces below 3000, all in that class).
Since \(\operatorname{Jac}(C_3)\sim E_1^2\), the whole \(m=3\) census is the
coefficient sequence of the weight-two level-90 newform of that class, which
replaces Weil-bound estimates by an exact modular law at \(m=3\).

**The ladder ends at \(m=8\), on statistical evidence rather than proof.**
Sato–Tate moments computed over roughly 975 good primes below 7703, against
reference moments derived by Weyl integration, match \(USp(4)\) and nothing else
for both isotypic abelian surfaces at \(m=8\), and match \(USp(8)\) for the
standard part, which is therefore a simple fourfold rather than two copies of a
surface. \(USp(4)\) forces trivial endomorphism ring, so the candidate uniform
conjecture — every isotypic factor of \(\operatorname{Jac}(C_m)\) is of
\(GL_2\)-type — is false at its first test beyond dimension one, and modularity
of the tower is a low-\(m\) accident: elliptic at \(m=3,4\), split with elliptic
factors at \(m=5,6,7\), generic from \(m=8\). This is a moment measurement, not a
theorem, and the identification of the two \(m=8\) surfaces remains open. The
level half of the conjecture does survive: conductors stay supported on the
proved bad-prime law \(\{2\}\cup H(m)\cup M(m)\cup E(m)\) — harmonic point,
collision locus, and a genuine double branch point, with no exception for
\(m=2,\dots,12\) — and the sign-side conductor uses every odd bad prime at
\(m=8,9,10\). Why the trivial side drops primes, and which, is unexplained.

### The finite-field census

Over \(\mathbf F_p\) the shadow of a four-point set is \(\chi(\Phi_{2m,4}(\lambda))\)
for the quadratic character \(\chi\), and the census is the sum of that character
over the \(\lambda\)-line.

*Periodicity, proved from an identity over \(\mathbf Z\).* Writing \(r=2m\),
\[
 u^2\Phi_{2m,4}(\lambda)=G_r(\lambda)
 =\bigl(1-\lambda^r-(1-\lambda)^r\bigr)^2-4\bigl(\lambda(1-\lambda)\bigr)^r,
\]
so the census depends on \(m\) only through \(2m\bmod(p-1)\). The census is a
character sum pulled back along the \(m\)-th power map from one fixed curve, and
it degenerates exactly when that pullback factors through a fixed curve of small
genus — which is the mechanism behind every stratum below.

*Master formula (proved; verified exactly on 308 parameter pairs,
\(m=2,\dots,8\), odd \(p<200\)).* With \(e=(p-1)/\gcd(r,p-1)\), the census is a
Plancherel pairing between a matrix of Jacobi sums of characters of order
dividing \(e\) and the Fourier matrix of \(\chi(F)\) on the subgroup of
\(r\)-th powers.

*Classification of the constant strata.* Exactly fifteen classes occur, and they
are of three provable kinds: two identically degenerate families (\(m\equiv0\) and
\(m\equiv1\bmod p-1\)); three infinite power-residue families
\(\lambda^m\in\mu_n\) for \(n\in\{3,4,8\}\), each infinite by Chebotarev under an
explicit square-class condition on \(p\), with \(n\in\{5,7,9,10,11,12\}\) provably
empty; and ten finite families, each closed by a Weil bound on one fixed curve
plus exhaustive search. The classification is exhaustive and complete for
\(5\le p<4000\) and every even \(r\). The stratum earlier recorded as the
sporadic point \((p,r)=(47,30)\) is the reduction \(3m\equiv-1\bmod p-1\), under
which the census becomes a character sum over the Fermat cubic
\(\xi^3+\eta^3=1\); Weil closes that family at \(p\le889\) and exhaustive search
gives exactly three members, \((17,6)\), \((17,10)\) and \((47,30)\). It is the
last member of a finite family, not an accident and not the seed of an infinite
one. What remains open is unconditional finiteness of the sporadic families in
every parameter corner, as opposed to the ranges censused.

*The non-split torus.* Setting \(\nu=1/u\) and \(\tau=\nu-2=z+z^{-1}\) makes the
census a function of two exponentials, \(\nu^m\) on the split torus and \(z^m\) on
the non-split one. On that side the census is a sum over the affine line
\(\operatorname{Tr}\lambda=1\) in \(\mathbf F_{p^2}\) and its Plancherel dual is
built from trace-one Gauss sums, the non-split analogue of Jacobi sums, whose
magnitudes are exactly \(p\), \(\sqrt p\) or \(1\); every one of the roughly
\(4.3\times10^6\) computed Fourier coefficients hits one of the three. The period
in \(m\) is exactly \(\operatorname{lcm}(p-1,p+1)=(p^2-1)/2\) — proved, with
minimality verified for \(5\le p<300\) — so the \(u\)-line sees the non-split
torus while the \(\lambda\)-line sees only the split one. An exhaustive sweep of
the full period window at every prime \(5\le p<300\) finds 319 constant non-split
strata, all accounted for: two identically constant infinite families, of which
\(m\equiv(p+1)/2\) is identically \(-1\) with closed-form census \(-(p-1)/2\);
torus power-residue families, with the \(\mu_3\) row unconditionally infinite;
fixed-exponent families closed by Weil bounds with complete member lists; and
exactly one point resisting every torus description, \((p,i,j)=(19,7,3)\), whose
family is proved finite with that single member. The classification is driven by
the correlation \(z^{(p+1)/2}=\chi(\nu)\) between the two tori. The Fermat-cubic
family has no torus mirror, verified exactly for \(p<400\), for the structural
reason that one reduction cannot pin two independent exponentials.

*Odd-bias theorem (proved).* The harmonic member has
\(\Phi_{2m,4}(1/2)=16(1-4^{1-m})\), which makes the census bias odd, and therefore
nonzero, at every prime not dividing \(4^{m-1}-1\). The excluded set is
uncharacterized.

### Reconstruction from the coloring

The coloring assigns to an unordered four-subset of \(\mathbf P^1(\mathbf F_q)\)
the square class of its Gram determinant. Its \(GL_2\)-weight is \(\det^{4d}\), a
square, and its point-weight \(2d\) is even, so it is never twisted by
\(\chi\circ\det\): it is \(PGL_2(\mathbf F_q)\)-invariant for every degree and
every odd \(q\), and also \(\operatorname{Gal}(\mathbf F_q/\mathbf F_p)\)-invariant.
The color of a four-set is \(\chi(G_r(\lambda))\) with \(r=2m\bmod(q-1)\), a
function of the anharmonic orbit of the cross-ratio alone, so the coloring
descends to the \(j\)-line.

**Reconstruction dichotomy (proved).** For every odd prime power \(q\) and every
\(m\), exactly one of two things happens: the coloring is constant and its
automorphism group is the full symmetric group \(\operatorname{Sym}(q+1)\), a
total loss of marking; or the coloring is nonconstant and its automorphism group
is exactly \(P\Gamma L_2(\mathbf F_q)\), so the shadow recovers the entire
projective structure. Nothing intermediate occurs. The proof combines
3-transitivity, an odd \((q+1)\)-cycle, and the classification of 3-transitive
groups; the boundary is that a census of 881 pairs \((m,q)\) with \(q\le121\)
found zero partial collapses, so the absence of intermediate behaviour is proved
in general while the exhaustive confirmation runs only to \(q\le121\). The
exceptional set is exactly the strata on which the coloring is constant including
its zeros, a proper subset of the constant-character strata classified above.

**Marking fibre.** In the reconstructing case the fibre is
\(P\Gamma L_2/PGL_2=\operatorname{Gal}(\mathbf F_q/\mathbf F_p)\), cyclic of order
\(\log_pq\) and independent of \(m\): the marking is recovered exactly over a
prime field, and over \(\mathbf F_{p^2}\) the residual ambiguity is one Frobenius
torsor of order two. This is the family-level form of the residual two-element
ambiguity in the fifth numbered paper.

**The Baer stratum.** Over \(\mathbf F_{p^2}\) at \(r=p+1\) the coloring becomes
the Baer-subline coloring: color zero exactly on the four-sets lying on a Baer
subline, \(+1\) elsewhere, and \(-1\) never occurring. The zero blocks are the
circles of the Miquelian inversive plane of order \(p\). This is the one place in
the whole sweep where partition refinement fails and the only case needing an
inversive-plane recognition theorem rather than refinement, and it is the only
query-complexity jump. A second new stratum is a total collapse at \(r=2p^i\) over
non-prime fields, a Frobenius twist of the known \(r=2\) collapse.
Reconstruction needs at least \(\lceil(q-1)/4\rceil\) queries by a touching bound
and \(\Theta(q\log q)\) by a counting bound, both proved, and
\((q-2)(3q-7)/2=O(q^2)\) non-adaptive queries suffice at every nonconstant
\((m,q)\) with \(q\le121\) except the Baer instances, where a quadratic query set
provably does not suffice.

**The \(q=11\) case of the first numbered paper is a corollary.** It is the point
\((m,q)=(2,11)\): 165 positive four-sets forming a \(3\)-\((12,4,3)\) design on the
harmonic orbit, with automorphism group of order \(1320=|PGL_2(11)|\). The
exhaustive check over \(9!\) candidates that the paper performs is recovered from
the dichotomy without search. The non-split torus does not disturb this: the
cross-ratio of a four-subset of \(\mathbf P^1(\mathbf F_q)\) is \(\mathbf F_q\)-rational,
and at \(q=p^2\), where \(\mathbf F_p\)-non-split values become rational, they carry
color \(+1\) for every \(m\) because \(\Phi\) lands in \(\mathbf F_p^\times\),
whose elements are squares in \(\mathbf F_{p^2}\); verified exhaustively over
every prime power \(q=p^k\le1000\) with \(k\ge2\).

### Three routes closed by measurement or proof

*No second quadratic-form invariant.* Over every field of characteristic other
than two and for every \(m\), the four-point pure-power Gram form is isometric to
a hyperbolic plane together with \(\langle-2,2\Phi_{2m,4}\rangle\). Its complete
isometry invariant is therefore the square class of \(\Phi_{2m,4}\), the coloring
already censused, and there is no second coloring to census — not pointwise over
\(\mathbf F_p\), not over \(\mathbf Q_p\) at rational \(\lambda\), not over
\(\mathbf Q(\lambda)\). The principal-minor sequence is \((0,-1,2,\Delta\Phi)\)
with the middle entries constant in both \(\lambda\) and \(m\), so the proposed
restricted-signature stratification of real configuration space is vacuous; and
the Hasse–Witt invariant is the quaternion class \((2,\Phi)(-1,-1)\), whose
ramification over \(\mathbf Q(\lambda)\) is exactly the branch divisor of
\(C_m\) and so carries nothing the cover does not. The replacement that does
refine is not a quadratic-form invariant at all: it is the square-class vector of
the four Fermat factors \(1+\varepsilon\lambda^m+\eta(1-\lambda)^m\), all sixteen
of whose strata occur, and whose periodicity is \(m\bmod(p-1)\) against
\(2m\bmod(p-1)\) for the discriminant — a doubling of the resolution of the
exponent stratification.

*No bridge to the second numbered paper.* That paper's quadratic-trade generator
transforms by \(\chi\circ\det\), the sheet sign of \(PGL_2/PSL_2\), whereas every
member of this family has even bracket weight and is a genuine \(PGL_2\)-invariant.
A twisted member would need \(rd\) odd, forcing \(d\) and \(r\) both odd, and
there \(G_{d,r}\) vanishes identically by the parity ceiling. So no member of the
family can generate the trade, and the bridge closes as a measured negative with
no verification item displaced. One exact identity survives as a by-product: the
three four-endpoint switch constants satisfy the Plücker relation \(u-v+w=0\), and
\(I=u^2-uv+v^2\), so the \(m=2\) color is the square class of the norm form of
that switch triple.

*No complex-multiplication route through Jacobi sums.* The hope that the four
Fermat factors would decompose the bias into Jacobi sums with complex
multiplication is refuted at \(m=3\), where the descent quotients are non-CM
elliptic curves with \(\operatorname{Jac}(C_3)\sim E_1^2\).

### Destination

None of this is currently assigned to a manuscript. A split into two papers is
under consideration — one on the coloring, its reconstruction dichotomy and its
finite-field strata, one on the arithmetic of the tower \(\{C_m\}\) — with the
classicality concession above written in from the start, so that the Wronskian
isomorphism is cited as the mechanism and the norm identity appears as an
organizing lemma rather than a headline.

## Status summary

- ***Reconstructing the Clebsch code and its golden orientation from its
  deep-hole syndrome locus:*** mathematics complete, including the golden
  orientation torsor and the structural determinantal six-node proof; the
  computational strengthenings travel in a companion, *Computational
  strengthenings of Clebsch syndrome rigidity*, with a five-mode claim ledger.
  Both previously cited order-eleven inputs are now proved from scratch and
  machine-checked: the ten-point bound on triple-concurrence points holds over
  every field in which two is invertible, and attaining it forces the golden
  normal form and hence a golden root in the ground field. What remains is
  publication packaging. The all-sizes extension of the conic-filling
  classification is **not proved**, but both of its branches moved. It is
  complete over every odd field up to \(43\); the saturated-external branch is
  closed uniformly; the saturated-internal branch is now empty over *every prime
  field*, because coherence produces a dual \(3\)-net whose affine components a
  classical net theorem forces onto a conic, leaving only proper extension
  fields, where the gate has become the exact determinantal condition that a
  stacked Cartier–Toeplitz matrix have nonzero kernel — forced by row count only
  at \(q=25,27,81\). The nonsaturated branch is reduced to slack at least two,
  and the complete \(k=12\), \(k=13\) and \(k=14\) layers are now impossible
  over every finite field. The exact remaining obstruction is an
  upper bound on the largest arc whose secants all avoid a fixed conic —
  measured to be tight, so possibly false. The companion also gains the
  all-field cubic tail: a six-arc has its uncovered locus on a curve of degree
  at most three only for the Clebsch hexagon at \(q=11\), for every prime power
  \(q\ge11\).
- ***Quadratic trade rigidity and cubic orientation in conic matching
  quotients:*** complete theorem arc, with the one-factorization property
  derived rather than assumed and the completeness theorem naming the two
  occurring configurations; public packaging remains. On the matching-design
  side a universal theorem has landed: over every field, every one-factorization
  of \(K_{10}\) whose factors have collinear star points has its nine
  transversals in a pencil, by an interpolation identity plus a three-line Hesse
  tripod that replaces an earlier 396-class census. For the regular design this
  forces the canonical one-factorization lines and hands the field boundary to
  Nagy's Ree-unital embedding theorem; the publishable part would be the
  automatic completion to the unital line structure, and the priority verdict
  there is bounded and provisional. The live frontier is the nine-point gain
  balance: the missing tenth carrier exists exactly when the thirty-six edge
  gains are balanced, and twenty-eight fixed-base triangle products are a
  complete frame-free test, so a single triangle with nonunit holonomy would be a
  projectively intrinsic counterexample needing no coordinate normalization.
  Either that balance is forced by the prescribed matching concurrences, or such
  a triangle exists; neither is settled. No manuscript edit has been made, and
  the integration decision is deferred behind that attempt.
- ***Golden descent and operator realizations of the Clebsch cubic:*** two
  recognition theorems are proved and machine-checked but not yet in the
  manuscript — the golden conference switching class is characterized by nonzero
  triangle-to-Pfaffian cubic proportionality for arbitrary sign matrices and is
  unique, and aligned four-sets determine a two-graph's triangle values up to one
  global complement bit on at least seven points. Both
  prior proof gaps are closed — the chart factorization is scheme-theoretic through
  a global Stein algebra, and the two realizations share one marked orientation
  source. The rational branch divisor and complete reduced fibre are now proved
  paper-locally, and the triangle--Pfaffian recognition theorem, signed norm
  identity, and marked/unmarked deck-exchange boundary are integrated. The
  forward version has absorbed a bounded operator core as one chain
  from the incidence descent to the harmonic return, plus the
  determinant-versus-permanent boundary; the released versions one and two are
  unchanged and keep the earlier title. The strongest bridge is explicitly
  relative to a marked datum with a complete ambiguity ledger; artifact locator
  and author metadata remain. A referee correction pass has since replaced the
  count of real regular configurations by the compact incidence trichotomy in
  both the reduced-branch-cycle and \(xyz\)-fibre arguments, introduced
  Hitchin's degenerate divisor and degree-ten invariant without a normalization,
  added the height-one normality lemma that fixes the Stein algebra's dimension,
  and restated the two-regular locus as a principal open set. A theorem-level
  red team of the operator section then found every mathematical assertion
  correct, with two proof-level repairs owed before the next cold read: a
  tangent-space dimension asserted where the text claims it is forced, and a
  local rigidity conclusion attributed to the constant-rank theorem without its
  hypothesis being established.
- ***Minimum-word reconstruction of \(\operatorname{PG}(2,13)\) from a binary
  conic code*** (formerly *A binary [78,36,12] code from the passant lines of a
  conic over \(\mathbb F_{13}\)*): minimum distance, the 364-word minimum layer
  and its four orbits, spanning through a hidden \(\mathbb F_8\) operator field,
  reconstruction of the whole marked plane from weighted pair concurrences alone,
  and the exact automorphism group are proved by a human
  argument, with a semantic Lean spine and sharded finite leaves supporting it.
  The published interval for this code's minimum distance was
  \(8\le d\le12\); this closes it at the top and adds everything above it. A
  manuscript-only pre-release is deposited; the underlying incidence graph is
  pre-empted as a known semisymmetric graph, and an earlier claim that its
  side-asymmetry contradicts published work is retracted. The human proof now
  exposes the orbital representatives, scheme products, \(\mathbb F_8\)
  commutant descent, and orbit-Gram transports that an audit found implicit.
  Full Lean closure and public release remain.
- ***The Golden Companion Correspondence:*** an eleven-page fifth numbered
  paper proves that Paper II's chordal cubic and Papers I/III's conference
  cubic lie in the same invariant pencil, recovers the six-axis carrier from
  the chordal singular quartic, and gives the exact marked oriented return.
  Human proof, finite evidence, literature ledger, clean standalone package,
  and three cold reads are green; the formal layer remains separate work. A
  normalization–residue theorem on the \(D_6\) weight lattice is now proved and
  assigned as the paper's closing structural theorem: the golden orientation
  torsor is canonically the exotic \(\mathbf F_4\)-gluing torsor, through the
  unique nonsplit \(\mathbf F_4A_5\)-extension. The paper's six-node count for
  the conference triangle cubic is now a structural theorem rather than a
  characteristic-zero computation: the cubic is the determinant of the
  three-by-three matrix of linear forms built from the coordinate functionals on
  the two eigenspaces of the conference matrix, its singular locus is the
  rank-at-most-one locus of that matrix, and that locus is exactly the six
  coordinate tensors — so the cubic has exactly six ordinary nodes in every
  characteristic outside \(\{2,3,5\}\) in which five is a square. This recasts
  the paper's geometric contrast as Segre against Veronese and supersedes an
  earlier Gröbner certification over \(\mathbf F_{11}\), which survives as an
  independent replay.
- **The cubic-threefold stabilization programme:** now several manuscript
  outputs rather than quarantined research. The one-stabilization epilogue proves
  unconditionally that \(X\times\mathbf P^1\) is irrational for every smooth
  complex cubic threefold, through the ordinary Hodge-atom package and a
  rank-two atomic residue discriminant equal to \(4/9\) on the cubic atom, and
  extends the conclusion to every smooth prime Fano threefold of genus eight by
  Kuznetsov's correspondence. It carries alongside it the proof that every
  smooth \(A_5\)-invariant cubic threefold in Roulleau's pencil is universally
  \(CH_0\)-trivial, with the integral Hodge conjecture for one-cycles on its
  intermediate Jacobian — a strong separation between universal
  \(CH_0\)-triviality and one-step stable rationality, and not a claim of stable
  irrationality. The separation is not reachable by the known criteria: every
  moduli point of the pencil but the Fermat point lies outside
  Colliot-Thélène's separated-variable locus, all but finitely many members lie
  outside the Yang–Yu–Zhu coprime-degree locus because Eckardt points separate
  them, and no elliptic-product route reaches Voisin's criterion. The second
  exact-level-two paper proves
  \(\ell_{\mathbf Q}(X)=\ell_{\mathbf C}(X_{\mathbf C})=2\) for two explicit
  smooth cubic threefolds and gives a two-variable rationality theorem for
  quartic del Pezzo surfaces with a rational point and stably permutation
  geometric Picard lattice. A modular-resolvent companion identifies the
  signed cubic parameter with the elliptic two-division discriminant cover over
  \(X_0(6)\). The older all-\(m\) manuscript states its claim conditionally, on a marked continuation
  across the thresholds of one equivariant cobordism; the endpoint contrast
  there is unconditional and the transport is proved, but the threshold
  comparison is not. The finer invariant \(\nu_6\) gives a second proof of the
  one-stabilization theorem under two stated hypotheses, one of which is now
  needed only for surface centres that are neither minimal nor geometrically
  ruled. A Lean companion is bundled with the epilogue and anchored to the
  atomic route. On the cycle side the surviving crown is unchanged — whether the
  relative Abel–Jacobi lift has odd index, an exact one-versus-two dichotomy,
  with every cheap route closed by exact calculation — and two uniform theorems
  extracted along the way, the Jordan-scalar minimal-class theorem and the
  prime-by-prime boundary on gluing defects, still lack priority closure.
- ***Standard Flips of Discrepancy One:*** a short standalone correction note,
  published locally with a DOI, supplying the two steps Shen and Shoemaker's
  proof chain omits — the \(J\)-normalization of the extremal hypergeometric
  series at \(r=s+1\), proved through cone membership rather than quoted, and
  the corrected Barnes aperture at discrepancy one — so that their conclusions
  reach every codimension-two blow-up. An independent cold read passed after
  explicit nonsplit-descent and formal-endpoint repairs.
- **The golden conference operator source programme:** mathematics proved and
  frozen across the cubic, polar, determinantal, pure-spinor, Boolean,
  measurement, fermionic, anomaly, Clifford, and lattice shadows, with the
  six determinantal nodes now certified by exact elimination and machine-checked;
  provenance descends from the unordered support two-graph with a sharp
  insufficiency boundary for the bare deep-hole conic. It is no longer a
  manuscript of its own — it feeds forward versions of the paper above. Its
  literature audit found five clean pre-emptions, two close to verbatim, so the
  classical-geometry layer needs attribution surgery; the operator layer has no
  located predecessor. A second audit adds that the order-ten cut-half design's
  parameter family is exhaustively enumerated, with a free three-design upgrade
  available if that design is resolvable, while the three Paley three-designs and
  the Sylvester cut-frame identities survive at full search strength. The exchange-statistics companion adds a general oriented
  top-exterior theorem, a universal balance obstruction that explains the
  unbalanced zeros without golden input, and the symmetric-cube permanent-side
  invariant, but the full photonic demonstrator is a no-go on 2026 hardware and
  only a coherent-light precursor is available.
- ***Arcs complete outside a conic:*** defect identity, zero-defect
  rigidity, and stability formally verified; six exact values of
  \(\rho_{\mathcal C}\); the \(q=16\) classification compressed to three
  exceptional cases. A bounded-degree envelope for the ordinary uncovered locus
  is now proved and routed into a forward version of this paper: containment in
  a degree-\(d\) curve forces \(q\le\binom k2+d-2\) with an exact root window
  and a parity-linear sharpening at low degree, the least vanishing degree is at
  least \(q-\binom k2+2\), and component-splitting adds a line bound
  \(|\mathcal U(A)\cap\ell|\le q-k+1\) in odd order. Its six-arc consequence —
  low-degree containment happens only for the Clebsch hexagon at \(q=11\), over
  every field — is routed to the first paper's computational companion instead.
  A publication audit settled the packaging: this split forward integration is
  the smallest defensible package, a standalone note is not opened, and the
  priority sentence is calibrated to "not located in the searched domain" rather
  than to an unqualified first claim.
- ***Integral Secant Distributions and Improved Bounds for Complete
  \((k,n)\)-Arcs:*** an eighteen-page manuscript proves exact integer degree
  envelopes whose real relaxation is classical spectral mixing, ordered
  factor-pair resonance families, and modular-lift surcharges with two
  unconditional geometric applications. The separate sharp-asymptotics
  programme proves \(t_7(2,9)=39\) structurally and reduces the first
  \(q=27\) target to two Frobenius branches and a signed support codeword; no
  asymptotic construction is yet claimed.
- ***High-Weight Cosets of Generalized and Extended Reed–Solomon Codes:***
  exact weight-(r) and weight-((r-1)) shells at arbitrary redundancy in the
  stated field range, with sharp refinements through redundancy seven; not a
  proof of the general deep-hole conjecture. The characteristic restriction is
  now gone in all but one corner — the main theorem holds for \(p\) odd and for
  \(p=2\) with \(r\ge8\) — which closes \(GF(64)\) by theorem, and the
  maximal-carrier discriminator is resolved at every level. Adjacent to the
  manuscript, the exceptional behaviour is now reduced to one conjectural
  inequality with a constant threshold of sixteen, far below the proved
  threshold, supported by exhaustive censuses and by certificate-backed sweeps in
  which no in-scope cell fires; three predecessor conjectures were falsified by
  exhaustive computation, and both proposed routes to rigour — Lang–Weil error
  terms and multiplicative-subgroup incidence — are closed by located
  obstructions. The residual is the class of orbits with trivial stabilizer,
  which meets no stratum and which no stratum-local tool can reach.
- ***Exact Transfer of Bounded Linear Recovery and Relative Weight
  Hierarchies:*** the associated shortening--puncturing pair's relative
  generalized Hamming weights are the exact rank-stratified helper costs; an
  ungated joint prescribed-coset optimization gives the exact first
  nonconfined cost; and the labelled costs and lift relations compose
  associatively by min-plus substitution through repeated concatenation. The
  twenty-four-page authority and verified standalone gates pass. Human proofs
  carry the main spine; the paper-local Lean package verifies four terminals
  and explicitly does not cover the stronger new theorems. The theory now has a
  working implementation, *ergodis*, whose governing quotient theorem is proved
  and whose speedup over the strongest published comparison tool on that tool's
  own input list is measured, not projected; it is being prepared for release
  under a dual licence. The measurement layer has widened: the automaton
  comparison now covers the full published list at 2.699x geometric mean with
  158 wins of 169, the eight coding and storage workloads it was written for
  give 104.16x cold and 81.48x warm geometric means against a
  constraint-programming control, and on the certified-unsatisfiable rows of the
  official VLSAT-2 list it beats a leading SAT solver by 381.13x where that
  solver finishes, with its one satisfiable miss recorded rather than excluded
  silently. Two earlier headline ratios were retracted when the protocol was
  corrected. Where the compiler loses is now measured rather than asserted: a
  shape classifier and a six-row prediction table were hashed before any timing
  run, five of six rows landed as predicted, and the one large predicted loss —
  a six-resource scheduling row losing by a factor of 13,689 — has since been
  **turned into an eleven-fold win with a 128-byte certificate** by a Lagrangian
  dual bound whose multipliers are derived rather than fitted, so dual
  feasibility holds by construction. One measured loss stands and is published:
  on a contended repair-scheduling instance the constraint-programming control
  is about 4.7x faster on solve work alone. A whole-code correctness audit found
  no committed result wrong and two structural weaknesses in the verification
  layer — checks that could not fail, and "verified" defined as re-execution —
  and the adopted rule is that every advertised check must ship with a failing
  control. The library has left the manuscript into its own repositories behind
  a tested publication guard; nothing has been pushed or released. The
  symmetry-reduction result for exact quantum-code distance
  computation is a measured consequence of the same principle and is not
  assigned to a manuscript; it has since closed exact distances that published
  sources left as upper bounds, including the entire published lifted-product
  list of Liu and Marquardt — among them a new exact rate–distance record at
  \([[1428,186,18]]\) — three bivariate-bicycle codes up to \([[784,24,24]]\),
  and \([[714,100,16]]\), whose distance a published satisfiability-based solver
  could not compute in two hours under any of its 46 configurations. Each is an
  exhaustive enumeration with the attained witness replayed by a second
  implementation and nothing machine-checked beyond that; \([[756,16,\cdot]]\)
  is narrowed to \(28\le d\le34\) with \(d\) even and remains the one unfinished
  exact distance. Two further applications of the same quotient principle are
  recorded with their outcomes: a from-scratch sparse matching decoder that is
  ahead of PyMatching in sixteen of eighteen cells by 2.5x to 11.5x with a
  linear-programming optimality certificate on every decode and zero
  minimum-weight disagreements over 360,000 shots, alongside a certified
  predecoder that is sound, general, and fails by exactly one unit of margin;
  and a structural-causal-model spike that is exact and compressing but whose
  amortization claim failed for the structural reason that hard interventions
  are idempotent, so the intervention set is the state set.
- ***Local-Unitary Rigidity of Stabilizer AME States:*** rigidity proved for
  every stabilizer AME state, not only the MDS–CSS family, and stable under
  approximate equality with explicit constants; the \(m=2\) proof bridge is
  repaired without weakening the headline. The dimension-only logical
  \(8\varepsilon\) rounding corollary is adopted, while the inter-code LU
  orbit theorem and high-distance multiplier lemma are banked for the
  companion. The marginal-to-rigidity chain and coset/syndrome dictionary are
  formally verified; encoder and exact transversal-group consequences remain
  human proofs. Uniform semilinear reconstruction is false even at zero error.
  An external referee edit packet has been applied in full: a phase-sign and
  empty-complement correction in the quadratic-growth corollary, the missing
  \(c=0\) branch of the rounding lemma, explicit traceless local logarithms in
  the main rounding theorem, a direct binary-MDS argument replacing an appeal to
  the general case, and five attribution and bibliography corrections. The
  quantitative tail has since been replaced by an intrinsic block-diagonal
  endomorphism algebra and a common-holonomy-centralizer theorem, with its
  prime-field algebra and determinant-one unit-group types classified, forced
  nonscalar endomorphisms through six parties, and a constructive classifier;
  the secondary quantitative appendix is compressed to its
  stabilizer-independent structural core, and two independent readings of the
  complete paper reconstructed the exact and quantitative theorem chains end to
  end with no scope, constant, characteristic, or field-linearity failure.
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
  remain and no matrix is constructed. Existence at \(668\) is settled
  externally, and the announced payload has now been decoded, verified in exact
  arithmetic by two implementations, formalized as an instance of a bordered
  Goethals–Seidel theorem in Lean, and classified: a four-row border over four
  circulants of length 166 with an extra inner shift, automorphism group of
  order four, and no contact with the Legendre-pair route, so the length-\(333\)
  Legendre-pair question is untouched and still open. The query
  complexity of reconstructing a two-graph from alignment tests is settled
  adaptively — the constant is exactly \(1/2\), so the coherence restriction is
  free to leading order — and bracketed nonadaptively between \(0.616\,n^2\) and
  \(\tfrac98n^2+O(n)\), with the evidence pointing at the floor rather than the
  construction as the loose end. The eight-point attachment constant is closed
  at \(g(8)=17\) by two verified refutations and a cross-implementation replay,
  and the obstruction is known to couple three cut strata, which is the target
  for replacing the certificate with a human proof. The exceptional
  code ladder from \(E_{10}\) down to \(E_6\) is proved and its three quantum and
  symmetry barriers are closed by proof, but the track is **pre-empted**: the
  level codes are Calderbank--Kantor two-weight codes, the fold is
  Brouwer--Shult, the tower is named and related in the strongly-regular-graph
  literature, and the code-level residue turned out to be a formal property of
  any matched Taylor double. It is not a publication route. The later marked
  Clebsch-entry composition is a distinct research-only candidate: it retains
  the residue flag, computes the exact forgotten fibres, and has not yet passed
  the novelty gate needed for manuscript placement. Four results have joined this
  group. Order \(2092=4\cdot523\), now the smallest open admissible Hadamard
  order, is being attacked as **class exclusion rather than construction**: four
  multiplier shards of the bordered route are closed by proof or exhaustion, a
  uniform level test empties 148 of the 167 nontrivial multiplier units, and on
  the plain route an exact size congruence proves no supplementary difference set
  is invariant under any multiplier subgroup of order at least eighteen — while a
  four-norm argument proves that no congruence of any modulus can ever exclude
  the surviving patterns, so a lattice or counting argument is the only route
  left. A certified finite no-go says that over every CSS code of length at most
  eight, X-check weight at most seven admits no diagonal transversal gate at
  Clifford-hierarchy level three or above, hence **eight qubits is the minimum
  length for a diagonal transversal non-Clifford gate**, with the proof gap named
  exactly at the one code that evades the textbook divisibility argument while
  landing on the threshold. For planes of order twelve, two classical
  eliminations are certified and the target case is not: the
  order-thirteen-invariant hyperoval survives, and the exhaustion shows that
  assuming the hyperoval makes the problem strictly harder. And Brouwer's
  exceptional exterior-set census is now bridged to the Clebsch hexagon — the
  entries at field orders 11 and 31 are one figure at two completion levels,
  which is why the icosahedral group occurs exactly twice — though the figure
  itself is pre-empted by Dye 1991, so the claim is the bridge and not the
  configuration.
- **The Gram–discriminant shadow of four points:** the factorization
  \(G_{d,r}=\Delta\Phi_{d,r}\) is a classical-derived corollary of the Wronskian
  isomorphism and is not claimed as new, and the quartic square-class case is
  substantially pre-existing. What is claimed begins after it: an integrality
  and content law, a modular nondegeneracy criterion, a parity ceiling that
  confines the shadow to even Veronese degree, a proved Dickson closed form and
  genus law for the four-point tower, a proved Chevalley–Weil isotypic
  multiplicity \(a=b=\lfloor(m-2)/3\rfloor\), a fifteen-class classification of
  the constant strata of the finite-field census with the former sporadic
  \((47,30)\) closed as the last member of a three-member family, a matching
  classification on the non-split torus, and a reconstruction dichotomy in which
  a nonconstant coloring has automorphism group exactly \(P\Gamma L_2\) and
  marking fibre exactly \(\operatorname{Gal}(\mathbf F_q/\mathbf F_p)\). Three
  routes are closed by proof or measurement: no second quadratic-form invariant
  exists, the bridge to the second numbered paper is blocked by a weight-parity
  obstruction, and the Jacobi-sum complex-multiplication route is refuted. The
  tower stops being modular at \(m=8\) on Sato–Tate moment evidence, which is a
  measurement and not a theorem. Not assigned to a manuscript; a two-paper split
  is under consideration.
- **Open programmes:** square-root complete arcs and the odd-plane cap game,
  both with substantial partial results and explicitly no global claim. The cap
  game's causal-local route is falsified by an explicit \(\mathbb F_{11}\)
  witness; the live target was a global Hall-type rematching and is now known to
  be a pure counting statement, since on the complete edge relation the Hall
  condition collapses to \(|\text{consumed}|\ge|\text{created}|\). That
  inequality holds across every one of the 10,890,000 complete exchanges over
  \(\mathbb F_{11}\), where the whole domain is also proved
  game-semantically dead, so the field is discharged as the equality base case
  and cannot supply the counterexample the acceptance gate asks for. The search
  moves to \(\mathbb F_{13}\), the smallest field with content, where a
  20.7-million-exchange sample gives strict surplus every time. No proof.
