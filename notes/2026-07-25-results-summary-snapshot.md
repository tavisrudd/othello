# Later-paper results summary snapshot

**Date:** 2026-07-25  
**Status:** read-only editorial snapshot; not a routing document  
**Scope:** major results banked after the Clebsch rigidity paper, including
results that may remain unpublished

This note combines the 2026-07-25 user-facing summaries of:

1. Clebsch Papers II and III; and
2. the later programs in `papers/papers-index.md`: complete bounded repair
   ports, Frobenius-equivariant robust completion, and continuation-graph
   rigidity.

It excludes `arcs_complete_outside_conic`, `beyond4_prs`, and `ame-lu`.
Publication order, lane routing, claim manifests, and release gates remain
governed by the live handoffs and paper-specific records. In particular,
banked mathematics listed here is not automatically adopted by a manuscript.

## Clebsch Paper II: factorization memory in a conic ideal

The central question is what remains of a pairing of marked conic points after
the associated products of secant equations are restricted to the conic.

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

This is already a coherent standalone theorem sequence: conic divisibility,
exact ranks, sheet recovery, cubic orientation, profile reconstruction,
modular explanation, and arithmetic gluing. The current split assigns twenty
trust-ledger rows to Paper II.

## Clebsch Paper III candidate: passages, holonomy, and the orientation torsor

The banked results concern which later constructions retain the orientation
bit and which erase it. The current split assigns eighteen candidate
trust-ledger rows to this inventory, but no Paper III should be released
unless one principal theorem organizes them.

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

### Further Clebsch results banked outside the current paper spines

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

The older `2026-07-20-clebsch-paper-planning.md` is now a redirect. Its
archived form used an obsolete two-paper allocation and briefly proposed one
enlarged replacement manuscript. The mathematics remains banked, but the
July 24 three-paper split controls current allocation. The proposed degree-23
\(M_{23}\)/Golay coherence test is a future unity test, not a banked result.

## Complete bounded repair ports

The organizing object is the complete radius-\(r\) repair port at a target
coordinate: every dual-word repair using at most \(r\) helpers, retaining
three distinct layers—support sets, normalized scalar recovery coefficients,
and failure probabilities.

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

### Complete-ports material outside the current manuscript

The current paper deliberately omits sequential-composition semantics,
general service regions, coefficient optimization, log-concavity history,
product constructions, generic tract/foundation exposition, and the
optional C220 blocker-stability strengthening. The formal library also
contains a \([10,4,6]_9\) seed with dual distance four that is not used in
the manuscript.

The six-part private manuscript is assembled and has survived multiple cold
reads. Remaining obstacles are release infrastructure and specialist
citation review, not missing central mathematics.

## Frobenius-equivariant robust completion

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

- The exceptional base order \(s=5\) is fully kernel-checked across all five
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

### Further banked structure

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
  work. No expansion or mixing claim is banked.

### Clebsch specialization

Every \(\mathbb F_{11}\)-rational six-arc, including the Clebsch hexagon
after scalar extension to \(\mathbb F_{121}\), has exactly
\[
76\cdot55=4180
\]
legal conjugate-pair extensions. After choosing one extension, exactly 4179
alternate pair repairs remain. This is reach of the general rational-six-arc
count, not another Clebsch characterization.

The focused manuscript and PDF exist. The foundational theorem chain is
complete; the exact 32-minimum upgrade still needs final manifest/release
bookkeeping before its adopted theorem set is frozen.

## Continuation-graph rigidity

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

This N1 theorem has survived the prior-art audit and is the current
standalone paper.

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

This N2 package is mathematically proved but publication-softened because it
meets existing complement and pseudo-complement reconstruction literature.
It remains in scope remarks pending the paywalled Drake-Sané and Metsch
comparison. It may never enter the N1 paper in full.

### Open rather than banked

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

The N1 manuscript exists with full written proofs. The planned
`ContinuationRigidity` Lean library has not yet been built, so formal release
closure remains its largest execution gate.

## Current packaging summary

- **Clebsch Paper II:** coherent standalone theorem spine; drafting and
  paper-specific trust remapping are gated behind Paper I submission
  readiness.
- **Clebsch Paper III:** substantial certified inventory; publication remains
  conditional on a single organizing theorem.
- **Complete bounded repair ports:** six-part private manuscript assembled;
  central finite-transfer and cubic results are kernel-checked; release waits
  on specialist citation review and public artifact/Lean-export gates.
- **Frobenius-equivariant robust completion:** focused manuscript and PDF
  exist; the foundational theorem chain and exact Q25 minimum are proved;
  integration of the final minimum-classification layer and release
  bookkeeping remain.
- **Continuation-graph rigidity:** N1 manuscript and written proof are
  complete; Lean formalization and final publication review remain. N2 is
  banked but publication-softened.

## Principal source records

- `notes/handoffs/2026-07-13-clebsch-paper.md`
- `notes/2026-07-24-clebsch-paper-split-trial.md`
- `notes/2026-07-24-c575-clebsch-split-disposition.md`
- `notes/2026-07-20-clebsch-paper-planning-archive.md`
- `notes/2026-07-21-clebsch-weil-roof-results-ledger.md`
- `papers/complete-repair-ports/proof_ledger.md`
- `notes/handoffs/2026-07-17-complete-ports-paper.md`
- `notes/handoffs/2026-07-14-alternate-orbit-repair.md`
- `papers/equivariant-robust-completion/README.md`
- `notes/handoffs/2026-07-17-continuation-paper.md`
- `notes/2026-07-10-continuation-graph-rigidity-upgrades.md`
