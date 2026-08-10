# C905 — reconstruction profiles across the Clebsch series

**Date:** 2026-08-10

**Status:** active research report; internal theorem extraction and red-team
surface only. No manuscript or Lean source has been edited.

## 1. The correct common statement

The five papers do not define one common shadow functor on one category.
They do support a common **reconstruction-profile calculus**.

For a map of groupoids
\[
  S:\mathcal X\longrightarrow\mathcal Y
\]
and a target-valued construction (R:\mathcal Y\to\mathcal Z), a
reconstruction profile records
\[
 (\mathcal X,\sim_X; S; R; \operatorname{Fib}(S);
   \operatorname{Aut}_{\rm res}; m; w).
\]
Here (m) is an additional marking that kills the stated residual ambiguity,
and (w) is either a sharpness witness or the declaration **sufficiency
only**.  “Recovers” means that (R(S(X))) is naturally isomorphic to the
declared output, with no coordinate choice silently retained.

The common theorem supported by the current papers is therefore:

> **Clebsch reconstruction-profile theorem (paperwise form).**  Each of
> Papers I--V contains a reconstruction passage whose sparse shadow recovers
> the declared carrier up to an explicitly described projective orbit,
> orientation involution, or marking torsor.  Whenever the paper calls its
> input minimal, it also supplies a collision or lower-bound witness.  Across
> the upper branch, a single calibrated odd datum kills the recurring
> orientation (C_2); Paper V shows that a chosen chordal line is additionally
> necessary and sufficient for an exact oriented return.  Paper IV is a
> separate arity-two passage whose remaining ambiguity is only coordinate
> marking, not a hidden cubic choice.

This is a theorem schema instantiated by the rows below, not a claim that the
five shadow maps are naturally isomorphic.

## 2. Exact profiles

### Paper I: syndrome geometry and golden orientation

There are two nested profiles.

#### I.a — geometric recognition

- **Source:** a six-arc (A\subset\operatorname{PG}(2,11)), equivalently its
  six-column projective code presentation, modulo projective/monomial
  equivalence as appropriate.
- **Shadow:** its uncovered locus \(\mathcal U(A)\), equivalently the
  projective deep-hole syndrome locus.
- **Reconstructed output:** the Clebsch hexagon/code, its nonsingular conic,
  and the induced polarity.
- **Exact fibre statement:** modulo \(\operatorname{PGL}(3,11)\), the fibre is
  one isomorphism class.  Over a fixed conic \(\mathcal C\), the arcs form one
  orbit of \(\operatorname{Stab}(\mathcal C)\); for the Clebsch object this is
  the homogeneous space
  \[
    \operatorname{PGL}_2(11)/A_5,
  \]
  not a torsor.
- **Witness:** the rigidity theorem proves that conic containment, equality
  with the full nonsingular conic, and projective Clebsch equivalence are
  equivalent.  The all-field companion supplies the stronger existence
  sharpness: (q=11) is the unique field order for a conic-filling six-arc.

#### I.b — orientation recovery

- **Source retained after I.a:** the reconstructed twelve-point syndrome
  (A_5)-set together with the nearest-codeword support ambiguity.
- **Sparse shadow:** the two five-valent orbital relations, or equivalently
  the signed support-orbit data.
- **Reconstructed output:** the six-axis carrier, the conference switching
  class, its integral commutant \(\mathbf Z[\sqrt5]\), and the cubic line.
- **Residual fibre:** the unordered pair \(\{[B],[-B]\}\), a free (C_2)
  orientation torsor.  Switching is already part of the declared
  equivalence; exchange of the two orbitals negates (B).
- **Killing datum:** one calibrated triangle sign, equivalently a choice of
  one of the two support orbits as positive.
- **Witness:** the same syndrome/support structure is invariant under
  (B\mapsto-B); the determinant pencil's odd cubic term changes sign.

The statement “the syndrome locus recovers the orientation” must always mean
that it recovers the **unordered orientation torsor**, unless an odd
calibration is explicitly included.

### Paper II: quadratic trade, carrier gate, and cubic orientation

- **Source:** a full \(\operatorname{PGL}_2(q)\)-orbit of perfect matchings,
  with the paper's conic-product quotient configuration.
- **Shadow:** the one-dimensional, two-valued strength-two trade, or the equal
  degree-one and degree-two tensor moments of complementary halves.
- **Reconstructed output:** only the (B_3/\mathbf F_7) and
  (H_3/\mathbf F_{11}) matching configurations survive; within either, the
  unordered complementary sheet pair is intrinsic.
- **Residual fibre:** free sheet exchange (C_2).
- **Killing datum:** the first nonzero signed moment \(\mu_3\), or any
  calibrated nonzero odd functional of it.  Degree one and two vanish;
  degree three changes sign under the outer coset.
- **Sharpness of orientation degree:** exact among signed tensor moments,
  not among all nonlinear statistics.
- **Sharpness of the carrier hypothesis:** for either survivor, the fixed
  ambient conic fibre is an affine line of (q) pairwise nonconjugate points;
  (q-2) nonmatching orbits retain the same trade.  Complete splitting into
  secants selects the unique matching point.

Thus “quadratic trade reconstructs the matching object” is false without the
geometric Chow/splitting gate.  It reconstructs the sheets only **on the
declared matching carrier**.

### Paper III: arithmetic descent and low-order reconstruction

Paper III contributes two independent reconstruction profiles.

#### III.a — branch divisor plus one fibre

- **Source:** Hitchin's finite Stein double cover of the rational harmonic
  cubic space.
- **Sparse shadow:** the reduced branch sextic (J_0=0), together with the
  complete reduced fibre over \([xyz]\).
- **Reconstructed output:** the rational quadratic twist
  \[
    z^2=5J_0,
  \]
  and hence the function field
  \(\mathbf Q(\mathbf P(H))(\sqrt{5J_0})\).
- **Residual fibre from branch data alone:** rational quadratic twists
  indexed by \(\mathbf Q^\times/(\mathbf Q^\times)^2\).
- **Killing datum:** a complete étale fibre at a rational point where the
  branch section has square value; its residue quadratic algebra fixes the
  square class.  Here it is \(\mathbf Q(\sqrt5)\).
- **Sharpness:** the branch divisor alone is unchanged under
  (J_0\mapsto cJ_0), so it cannot recover the rational twist.

After a full bridge datum is fixed, a sheet supplies the conference source
or its opposite.  The sheet alone does **not** recover the ordering, chart
lift, outer labels, Petersen labels, or determinant-line orientations.

#### III.b — aligned four-set reconstruction

- **Source:** a two-graph \(\tau\) on a marked vertex set (V).
- **Shadow:** the family \(\mathcal A(\tau)\) of four-sets on which all four
  triple values agree; for conference matrices this is exactly the marked
  family of order-four principal minors equal to (-3).
- **Reconstructed output:** for \(|V|\ge7\), the two-graph up to complement;
  for symmetric conference matrices of order at least ten, the signing up to
  switching and global negation.
- **Residual fibre:** the complement involution (C_2), respectively global
  matrix negation after switching.
- **Killing datum:** one calibrated triangle product.
- **Sharpness witness:** the explicit non-complementary pair of two-graphs on
  six vertices with the same aligned family proves that seven is the least
  possible vertex threshold.
- **Query lower bound:** any binary-test decision tree determining a
  two-graph up to complement uses at least \(\binom n2-n\) tests; the stronger
  entropy lower bound applies to fixed test families.  The paper does not
  claim its displayed quadratic decoder is query-optimal.

### Paper IV: exact arity-two minimum-word reconstruction

- **Source:** the marked binary code--minimum-support presentation
  \((K,\mathcal H)\) on 78 unlabeled coordinates, up to isomorphism.
- **Shadow:** the weighted hypergraph (2)-section
  \(c(P,Q)=\#\{S\in\mathcal H:\{P,Q\}\subseteq S\}\).
- **Reconstructed output:** the incidence matrix and code, the full
  six-relation elliptic scheme, its \(\mathbf F_8\) operator field and
  automorphism group, and finally the marked \(\operatorname{PG}(2,13)\),
  distinguished conic, and polarity.
- **Exact arity:** two.  Unary incidence data are constant because every
  coordinate belongs to 56 minimum supports; weighted pairs recover the
  object.
- **Residual marking:** the reconstructed object is intrinsic only up to
  isomorphism.  Choosing an ordered projective frame/field labeling is a
  \(\operatorname{PGL}_2(13)\)-torsor; the 2184 ordered triples of distinct
  conic points exhibit it.
- **Sharpness boundary:** the paper proves arity minimality, not a global
  classification of every code/hypergraph having the same unary shadow.
  Constant unary data are a collision witness, not an exact global fibre
  theorem.

Paper IV must not be folded into the upper branch's orientation (C_2): it
has a coordinate-marking torsor after complete geometric reconstruction, not
an unresolved cubic companion.

### Paper V: carrier recovery and the exact marked return

Again there are two nested profiles.

#### V.a — the chordal residue recovers the carrier

- **Source/shadow:** the retained Paper-II residue
  \(\mathcal R_M=(G\curvearrowright W_5,[H_M])\).
- **Reconstructed output:** the singular rational normal quartic, its twelve
  \(A_5/C_5\) points, their equal-stabilizer pairing, the six-axis
  \(A_5/D_5\) carrier, and the unique invariant conference switching class up
  to opposite.
- **Residual fibre:** (C_2) conference opposition.  The projective cubic
  line does not retain a signed generator.
- **Essential marking:** the (A_5)-action.  An unmarked chordal cubic has
  projective automorphism group \(\operatorname{PGL}_2\), so its bare
  singular quartic does not remember the finite Clebsch axis marking.

#### V.b — oriented companion round trip

- **Source packages:** a chordal or conference generator in the common
  invariant pencil, together with (G\curvearrowright A_M) and a selected
  chordal line (L).
- **Sparse operator:** \(\Delta=q-1\), where (q) is the nontrivial outer
  normalizer action.
- **Reconstructed output:** exact inverse generators
  \[
    h\longmapsto c=8^{-1}\Delta h,
    \qquad
    c\longmapsto h=(\Delta|_L)^{-1}(8c).
  \]
  The map identifies the Paper-II sheet-orientation torsor with the
  conference-orientation torsor.
- **Fibre with full marking:** a singleton modulo the declared equivariant
  isomorphisms.
- **Sharpness witness:** without (L), a conference source does not
  distinguish the two chordal companion lines, which are exchanged by the
  outer involution.  Thus the selected chordal line is necessary, not merely
  convenient.
- **Boundary:** the inverse returns only the retained source outputs.  It does
  not reconstruct Paper II's full quotient or Paper III's global cover; the
  latter's chart lift is carried as part of the bridge datum.

## 3. What is truly common

The exact common mechanism is a three-stage factorization:
\[
 \boxed{
 \text{sparse invariant}
 \ \longrightarrow\ 
 \text{intrinsic carrier}
 \ \longrightarrow\ 
 \text{residual symmetry fibre}
 \ \xrightarrow{\text{minimal marking}}\
 \text{oriented/marked object}.}
\]

The residual symmetry has four observed types:

1. a homogeneous projective orbit when coordinates have been forgotten;
2. a free (C_2) orientation or complement fibre;
3. an arithmetic square-class family of rational twists; and
4. a finite or algebraic marking torsor (frame, labels, or selected companion).

These must not be conflated.  In particular, a groupoid fibre need not be a
torsor: Paper I's fixed-conic arcs form
\(\operatorname{PGL}_2(11)/A_5\), while Paper IV's ordered conic triples form
a genuine \(\operatorname{PGL}_2(13)\)-torsor.

## 4. External-field gateway matrix

The gateway question is assessed with the same profile discipline.

| bridge | strongest proved reverse direction | exact missing fibre or gate | status |
|---|---|---|---|
| Segre cubic \(\leftrightarrow\) Igusa quartic | explicit inverse polar formula on (e_5\ne0); the fifteen Segre planes are exactly the exceptional locus | none on the generic marked projective locus; level structure is required for the moduli interpretation | **genuinely birational** |
| ordered six-point moduli \(\leftrightarrow\) genus-two level-2 data | classical GIT/Torelli-level correspondence on the appropriate open locus | forgetting the level/order leaves an (S_6)-type marking torsor | **bidirectional after marking** |
| Clebsch (15/10/6) configuration \(\leftrightarrow\) two-qubit Pauli doily | exact (S_6\cong\operatorname{Sp}_4(2)\) incidence dictionary recovers observables, contexts, grids, and ovoids | Pauli phases and Clebsch conference signs differ by point gauge | **incidence-bidirectional; phase-negative** |
| Fano sheet design \(\leftrightarrow\) binary Hamming code | incidence span gives the code; minimum supports recover the Fano lines | one sheet/chirality bit is external to the bare design | **marked-bidirectional** |
| (H_3) biplane \(\to\) ternary Golay code | the eleven cross-sheet blocks generate the code | the code has many more weight-five supports and does not canonically select these eleven or the outer polarity; PGL chirality is not an (M_{11}) symmetry | **not bidirectional from the bare code** |
| (H_3) biplane \(\leftrightarrow\) regular 11-cell vertex--facet incidence | the biplane and its dual give the two incidence sides and every outer-coset element is a polarity | recovery of the full face poset/flag adjacency from this marked incidence has not been proved | **one inverse lemma short** |
| node--plane code \(\leftrightarrow\) (R_{10}), the two halves of (W_{10}) | the two minimum layers are exactly the duad and syntheme halves; the full (1440)-group exchanges them | a chosen exchange polarity lies in a 36-class; the golden marking narrows this only to a six-pack | **bidirectional as a marked finite code/design, not canonically polarized** |
| (R_{10}\to Q_{10}) by Construction A | standard lattice construction | recovering the code intrinsically from the abstract lattice requires a distinguished coordinate frame | **one-way unless framed** |
| Segre/Igusa shadows \(\leftarrow A=dZ\) | \(\operatorname{adj}A=6Wq^{\mathsf T}\) extracts both null factors; inverse polar recovers the Segre point generically | (A) is a common parent, but either bare sister need not recover the full ordered parent tensor without markings | **strong common-parent bridge** |
| Segre/Igusa boundary \(\leftarrow W(E_6)\) cubic-surface system | the two five-spaces are respectively boundary value and first-normal jet | global recovery of an ambient marked cubic surface from boundary value/jet is not proved | **one-way/local at present** |
| six odd theta characteristics/doily \(\leftrightarrow J[2]\) symplectic geometry | exact symplectic incidence and \(\operatorname{Sp}_4(2)\) action | the bare finite geometry forgets curve moduli and quadratic/phase refinements | **bidirectional only at level-2 incidence** |
| Klein/Hoggar, Paley/Hadamard, and (q=19)/57-cell corridors | classical unmarked carrier correspondences | no Clebsch-owned nonconstant statistic with proved inverse | **not yet a reconstruction bridge** |

## 5. Reusable theorem interfaces

The following statements are safe as internal interfaces for C906.

### Interface A — carrier before decoration

If a shadow first reconstructs a carrier (X) only up to (G)-isomorphism,
then a subsequent construction is canonical only if it is (G)-equivariant.
Choosing coordinates before proving equivariance merely hides a (G)-torsor.

### Interface B — exact (C_2) orientation

Suppose an even shadow (S) is fixed by a free involution
\(\iota:X\to X\), and an odd scalar/tensor (o) satisfies
\(o(\iota x)=-o(x)\ne0\).  If (S) recovers the unordered pair
\(\{x,\iota x\}\), then ((S,\operatorname{sgn}o)) recovers (x), and one
bit is information-theoretically necessary.  Papers I, II, III.b, and V
instantiate this lemma with different typed objects.

### Interface C — branch plus fibre

For quadratic covers with a fixed reduced branch section (J), the branch
divisor determines the cover only up to a rational square class.  A complete
étale fibre over one rational point with square (J)-value determines that
class.  This is the arithmetic analogue of the (C_2) orientation profile,
but its pre-calibration ambiguity is \(k^\times/(k^\times)^2\), not two
points.

### Interface D — exact arity

An arity-(r) reconstruction claim requires both a reconstruction map from
(r)-local data and a collision at arity (r-1).  Paper IV meets this for
(r=2); Paper III.b supplies a vertex-threshold collision instead.  These
are different kinds of minimality and should not be merged.

### Interface E — marked reversibility

A passage (F:X\to Y) is called bidirectional only after specifying
groupoids and exhibiting (G:Y\to X) with natural isomorphisms
\(GF\cong1_X\) and \(FG\cong1_Y\) on the declared image.  Carrying an
unreconstructed bridge datum through both maps is legitimate but must appear
in both object types.  Paper V is the model; a noninvertible exceptional fold
cannot be called a round trip.

## 6. Proof obligations still open in C905

1. Verify the stabilizer and fibre wording in every row against the paper's
   exact equivalence convention; especially distinguish an orbit from a
   torsor.
2. Decide whether the Fano/Hamming reverse is canonical from minimum supports
   under the exact code convention, or only after monomial-coordinate
   marking.
3. Determine whether the marked (H_3) biplane plus a polarity reconstructs
   the complete regular 11-cell abstract polytope, or only vertex--facet
   incidence.
4. State the Segre--Igusa inverse domain scheme-theoretically and avoid
   extending the inverse across the fifteen exceptional planes.
5. Run the required literature audit before calling the profile theorem,
   gateway packaging, or carrier/fibre synthesis new.
6. Hard-red-team every “minimal” above: where the source only proves a
   sufficient marking, replace “minimal” by “sufficient.”

## 6A. Negative profiles: failed bridges as theorems

A failed inverse should be recorded by its **first obstruction**, not merely
as an unsuccessful construction.  The present work already exhibits six
different obstruction mechanisms.

### N1 — automorphism obstruction

If (F:X\to Y) is equivariant and a point (y=F(x)) has stabilizer strictly
larger than the image of \(\operatorname{Stab}(x)\), then (y) cannot
canonically recover (x).  Any inverse requires enough marking to reduce the
extra stabilizer.

Applications already visible:

- an unmarked chordal cubic has \(\operatorname{PGL}_2\) symmetry and cannot
  recover the finite (A_5/D_5) axis marking;
- the ternary Golay automorphism group does not contain the relevant
  \(\operatorname{PGL}_2(11)\) chirality extension, so the code cannot encode
  that orientation equivariantly;
- an abstract Construction-A lattice cannot return a particular code without
  a distinguished coordinate frame when its lattice automorphisms move such
  frames.

This gives a lower bound by orbit size: at least
\([\operatorname{Stab}(y):\operatorname{Stab}(x)]\) candidate markings remain
whenever that quotient is finite and the action is transitive.

### N2 — torsor and monodromy obstruction

If the forgotten markings form a nontrivial (G)-torsor with full monodromy,
there is no intrinsic algebraic section.  The exact lower bound is the degree
of the smallest field extension or cover on which the torsor splits.

Examples:

- Paper III's branch divisor leaves the full square-class ambiguity; one
  fibre is needed to determine the rational twist;
- one marked Weierstrass point leaves an (S_5)-torsor of orderings of the
  other five; the frozen (S_6) Galois group proves that no rational intrinsic
  ordering exists.  Full ordered recovery requires the degree-(120) residual
  splitting cover after adjoining one branch point;
- Paper IV's geometry cannot canonically choose a projective frame because
  the ordered conic triples form a free \(\operatorname{PGL}_2(13)\)-torsor.

### N3 — representation-carrier obstruction

If the proposed raw statistic spans a (G)-module (U) and
\(\operatorname{Hom}_G(U,V)=0\) for the desired output carrier (V), no
equivariant linear recovery from that statistic exists.  One must increase
degree, assemble operators, or add data.

The C705 raw-adjugate failure is exact:
\[
 U=[4,2],\qquad
 \operatorname{Hom}_{S_6}(U,[2,2,2])=
 \operatorname{Hom}_{S_6}(U,[3,3])=0.
\]
It yields a degree lower bound: raw degree-two minors and their second
compound cannot produce the sextic outer polar; the third compound is the
first possible carrier, and its relevant Hom space is one-dimensional.

### N4 — contraction/exceptional-locus obstruction

A rational inverse cannot extend across a locus contracted to positive
dimensional fibres.  The exceptional divisor therefore gives both the exact
failure set and a lower bound on any additional separating data.

For Segre--Igusa polarity, the inverse scalar is proportional to (e_5(z)).
Its zero scheme on the Segre cubic is the reduced union of the fifteen Segre
planes, which contract to the fifteen singular Igusa lines.  Thus generic
bidirectionality is sharp: no regular inverse from the bare Igusa image can
recover a point within a contracted plane.

### N5 — locality/information obstruction

If all ((r-1))-local shadows agree while an (r)-local shadow separates the
object, arity (r) is necessary.  More generally, a (b)-ary query protocol
with (N) possible output classes needs at least \(\lceil\log_bN\rceil\)
answers, sharpened by entropy when answer distributions are biased.

Examples:

- Paper IV has constant unary data and complete weighted-pair recovery, so
  arity two is exact;
- Paper III's aligned-four-set oracle has explicit six-vertex collisions and
  a seven-vertex decoder, making the vertex threshold sharp;
- aligned-bit reconstruction also has decision-tree and fixed-query entropy
  lower bounds, although the exhibited decoder is not claimed optimal.

### N6 — noninjective structure-map obstruction

If a tower map is a quotient or fold with kernel (K\ne0), no inverse exists
on its whole codomain or even on its image without retaining a coset/section
choice.  A reverse theorem must therefore do one of three things:

1. characterize a subcategory on which the fold becomes injective;
2. retain the kernel coordinate as a marking; or
3. reconstruct only the quotient object and state the fibre (K).

This is the governing obstruction for C906.  The existing plus-type folds
may give canonical forward maps, but they are not round trips.  Their kernels
and automorphism orbits should be treated as mathematical output: they may
produce exact fibre-size formulas, minimal side-information bounds, and
nonexistence of equivariant sections.

### Reused no-section lemma

Let (F:X\to Y) be a (G)-equivariant map of finite transitive (G)-sets,
with (x\mapsto y).  A (G)-equivariant section through (y) exists only if
\(\operatorname{Stab}_G(y)\) fixes a point of the fibre (F^{-1}(y)).
For a homogeneous projection (G/H\to G/K), this is equivalent to (K)
being contained in a conjugate of (H); since (H\le K) for the natural
projection, a section exists only in the degenerate case (H=K).

This elementary lemma converts many “could the shadow canonically choose its
source?” questions into a stabilizer computation.  Its groupoid/algebraic
versions replace a fixed point by a reduction of structure group or a
rational section and expose the corresponding cohomological obstruction.
The finite two-fibre form and its exact one-bit advice cost were already
proved in C448; C486 further identifies the cocycle, torsor, and information
readouts as three realizations of the same sign-character class.  C905 reuses
that result and makes no novelty claim for the lemma.

### Quantities to extract in C906

For every exceptional fold or gateway, compute:

- fibre cardinality or kernel dimension;
- action of the target stabilizer on that fibre;
- existence or nonexistence of an equivariant section;
- minimal orbit size of a marking that permits a section;
- first tensor/locality degree at which the fibre is separated; and
- exceptional locus on which generic reverse recovery fails.

These negative quantities can be theorem-level outputs even when the hoped-for
bidirectional bridge is impossible.

## 6B. Local-to-global mappings beyond the present papers

The common profile suggests several broader local-to-global mechanisms.  Most
ambient frameworks are classical; a Clebsch-owned result would have to
identify a new exact instance, threshold, or obstruction rather than rename
the framework.

### LG1 — cochain reconstruction and synchronization

This is the cleanest immediate generalization of triangle holonomy.
Let (K) be a connected finite simplicial complex and (A) an abelian
coefficient group.  Regard edge labels as (b\in C^1(K;A)), with vertex
gauge (b\mapsto b+\delta f), and triangle holonomies as
\(c=\delta b\in C^2(K;A)\).  Then:

- a proposed local holonomy (c) has a global edge realization exactly when
  it is a coboundary (in particular \(\delta c=0\));
- when realizations exist, their switching classes form a torsor under
  \(H^1(K;A)\); and
- therefore triangle holonomy reconstructs the edge signing up to vertex
  gauge exactly when \(H^1(K;A)=0\).

For the complete simplex and (A=C_2), this specializes to the four-point
two-graph identity and the reconstruction of a conference switching class
from triangle products.  On a sparse observation complex, the first Betti
number gives an exact side-information lower bound: at least
\(\log_2|H^1(K;C_2)|\) bits are required to select a switching class.

This connects the series to group synchronization and discrete gauge theory.
It is not itself new; the possible new theorem would identify the minimal
Clebsch observation complex whose (H^1) vanishes, or compute the exact
cohomological defect along the exceptional tower.

For nonabelian edge labels, replace cochains by flat transition functions.
The solution set is a nonabelian (H^1)-type moduli set; trivial holonomy on
generating cycles plus a root calibration reconstructs vertex labels up to a
global left action.  Any claim here needs careful typing because nonabelian
“(H^2)” is not an ordinary group in general.

### LG2 — compatible local sections and contextuality

A measurement cover or incidence cover carries local sections on contexts.
Pairwise agreement on overlaps need not imply a global section; the
obstruction is a Čech/sheaf class.  The Pauli-doily bridge makes this relevant,
but C705's negative result is decisive: the ordinary Clebsch and Pauli context
signs lie in the same unrestricted point-gauge class.  Thus no new
contextuality invariant arises from the existing sign data.

A viable new question is narrower: retain (A_5/S_6)-equivariance or the
golden six-pack of polarities and compute whether the equivariant section
obstruction is nonzero.  Success would be an equivariant local-to-global
theorem; failure would prove that **all** contextwise measurements of the
declared type forget the golden marking.

### LG3 — pair refinement to coherent closure

Paper IV can be placed in a general two-stage procedure:

1. form a weighted pair coloring from a high-arity hypergraph;
2. refine colors by common-neighbor/intersection fingerprints until a coherent
   configuration is reached.

If the terminal coherent configuration separates all source relations and a
distinguished color reconstructs the incidence rows, the weighted two-section
recovers the source.  The obstruction is an unresolved fusion: two source
relations remain in the same coherent-closure color.  This supplies an exact
notion of **pair-reconstruction depth** analogous to Weisfeiler--Leman
refinement depth.

The Paper-IV instance has one initial fusion, split by one common-neighbor
count.  A worthwhile infinite-family theorem would characterize conic-code or
orthogonal-scheme parameters for which this refinement terminates with the
full scheme, and identify the first parameters where a nontrivial fusion
survives.  A mere restatement that coherent closure can be computed would be
classical and too weak.

### LG4 — local residues, amalgams, and universal completion

For incidence geometries and buildings, rank-one and rank-two residues give a
parabolic amalgam.  Local data determine the global geometry only up to a
cover; the fundamental group/deck group is the residual fibre.  Simple
connectedness makes the universal completion exact.

This is the most promising local-to-global interface for C906:

\[
 \text{six-axis carrier}
 \longrightarrow
 \text{marked low-rank residues/amalgam}
 \longrightarrow
 \text{universal completion of exceptional type}.
\]

The hard gates are concrete:

- identify which (E_6) parabolic residues the (6|15|6) grading actually
  determines;
- prove that their intersection maps, not just their isomorphism types, are
  recovered from the sparse carrier;
- compute the universal completion and its centre;
- prove simple connectedness or state the precise covering group; and
- recover the entry carrier from the completed marked geometry.

The general local-recognition technology is classical.  The possible new
content is a sparse Clebsch construction of the correct **marked amalgam** and
an exact information-fibre calculation.

### LG5 — local minors and global operators

Principal minors, block determinants, or local Plücker coordinates can recover
a global matrix only up to diagonal gauge and, on exceptional loci, further
ambiguity.  Papers I and III already use special cases.  The broader mapping
is:

\[
 \text{local determinants}
 \to \text{cycle/Plücker consistency}
 \to \text{global operator modulo gauge}.
\]

The negative C705 Hom calculation supplies a degree lower bound, while the
third/fourth compounds provide the first successful global carrier.  A new
family theorem would need to characterize when a prescribed collection of
low-order minors separates a structured operator orbit and compute its
exceptional locus.  Generic principal-minor recovery by itself is already a
mature subject.

### LG6 — local code shadows and global scalar fields

Punctures, shortenings, minimum-support sections, and local commutants may be
glued to a global code/module when their overlaps identify the same scalar
action.  The residual obstruction is descent of the local field generators:
on overlaps they may differ by Frobenius or another automorphism, producing an
\(\operatorname{Aut}(\mathbf F_{p^e})\)-cocycle.

Paper IV gives one global (\mathbf F_8\) recovery, but not this descent
theorem.  A plausible new statement would say that compatible local
degree-(e) commutant fields glue to a global (\mathbf F_{p^e}\)-module
exactly when the Frobenius cocycle is trivial; otherwise they determine only
the semilinear form.  Before promotion, this needs examples, counterexamples,
and a literature audit in code equivalence and Galois descent.

### Priority among the six

1. **LG1 is theorem-ready but mostly classical:** use it as the exact language
   and seek a genuinely new minimal observation complex.
2. **LG4 has the highest exceptional-tower upside:** the marked amalgam and
   covering fibre could turn the (E_6) entry problem into a local-recognition
   theorem.
3. **LG3 is the strongest algorithmic direction:** it can turn Paper IV's
   one-step split into an infinite-family reconstruction-depth theorem.
4. **LG6 is the most surprising cross-field direction:** local code statistics
   could reconstruct global extension-field linearity, but it is presently the
   least proved.
5. **LG2 and LG5 already have sharp negative controls:** pursue them only with
   an equivariant or exceptional-family refinement.

## 6C. Fishing questions: number theory and cap sets

### NT1 — Frobenius profiles of reconstruction fibres

When the residual fibre is a finite étale torsor over a number field, every
good prime supplies a Frobenius conjugacy class and hence a visible splitting
type.  This gives an arithmetic reconstruction profile:
\[
 \text{reductions of the sparse shadow at primes}
 \longrightarrow
 \text{Frobenius action on the forgotten fibre}
 \longrightarrow
 \text{Galois/monodromy group or character}.
\]

The quadratic orientation case is exact and elementary.  For
\(T=\operatorname{Spec}\mathbf Q(\sqrt d)\), a good prime records the value of
the quadratic character \((d/p)\): split primes expose two sheets, inert
primes expose one degree-two point.  No finite list of primes determines an
unbounded square class (d), so a finite reconstruction theorem requires a
bounded discriminant, a prescribed ramification set, or a finite candidate
family.  Under such a bound, the smallest separating prime set becomes a
real information-theoretic quantity.

For the ordered six-point (S_6)-torsor, factorization types of the branch
sextic give Frobenius cycle types.  C705 already uses a five-cycle, six-cycle,
and transposition to certify full (S_6).  A possible general theorem would
compute the minimal collection of good-prime cycle types needed to distinguish
the candidate monodromy groups arising from the Clebsch pencil or exceptional
tower.  The group certification method is classical; novelty would have to be
the exact family, sharp prime budget, or reconstruction consequence.

### NT2 — Hasse/no-section refinements

The phrase “no canonical global orientation” has an arithmetic strengthening:
a torsor may have points over many or every completion while lacking a global
point.  For each proposed exceptional entry torsor, ask:

1. is its obstruction merely noncanonicality under automorphisms;
2. is there no rational point at all;
3. does it split after a prescribed quadratic or finite extension; or
4. is there a genuine local--global failure measured by Galois cohomology?

The present quadratic Clebsch fibre is not a Hasse-principle counterexample;
it is simply a nonsplit quadratic étale algebra over \(\mathbf Q\).  Any
stronger arithmetic claim needs a genuinely nontrivial torsor class and a
place-by-place audit.

### NT3 — zeta functions and orbit counts

For a tame quotient such as the proposed (A_5) icosahedral tower, stabilizer
strata and Frobenius splitting types determine extension-field orbit counts
and hence zeta functions.  This is the cleanest number-theory output already
adjacent to the series.  It turns the reconstruction profile into arithmetic:
the same residual stabilizers that obstruct a section contribute the
correction terms in point counts over \(\mathbf F_{q^r}\).

The required gate is a scheme-level quotient with good-reduction and inertia
control; a collection of finite-field enumerations is not enough.

### NT4 — integral models and bad primes

The scalars (2,3,5) already mark genuinely different failures:

- characteristic two erases sign and coalesces outer shadows;
- characteristic three collapses the fourth-compound polar extraction; and
- characteristic five ramifies the golden eigenspace splitting while leaving
  the descended Segre--Igusa identity nondegenerate.

A useful arithmetic theorem would classify reconstruction profiles prime by
prime for one integral carrier: which shadow survives, which fibre enlarges,
and which marking ceases to descend.  This is more informative than listing
“bad primes,” because it measures the exact information lost at each one.

### CAP1 — affine cap autoconvolution

Let (A\subset\mathbf F_3^n) be a cap and (f=1_A).  The distinct-pair
missing-third profile
\[
 m_A(z)=\#\{\{x,y\}\subset A:x\ne y,\ x+y=-z\}
\]
is a local-to-global shadow.  The cap condition says (m_A(a)=0) for every
\(a\in A\).  Its ordered version is an autoconvolution, so Fourier transform
retains squares of Fourier coefficients and forgets phase.

This creates a precise reconstruction question:

> Among caps in \(\mathbf F_3^n\), when does the missing-third multiplicity
> profile determine the cap up to affine equivalence, and what are the exact
> homometric fibres when it does not?

The first falsifier has now been run and is positive in a stronger form than
expected.

> **Four-cap reflection theorem (exact finite result).**  For every
> four-element cap (A\subset\mathbf F_3^3), put
> \(s_A=\sum_{a\in A}a\) and
> \[
>   A^*=\{-s_A-a:a\in A\}.
> \]
> Then (m_{A^*}=m_A).  The complete labelled fibre of (m_A), among
> four-caps in \(\mathbf F_3^3\), is
> \[
>   \{A\}\quad\text{if (A) is planar},
>   \qquad
>   \{A,A^*\}\quad\text{if (A) is an affine basis}.
> \]
> In the second case (A^*\ne A), the degree-zero, degree-one, and degree-two
> moment functionals of the two caps agree, while their degree-three moment
> functionals differ.

The equality of shadows is conceptual.  Under the involution
\(a_i\mapsto-s_A-a_i\), the sum attached to a pair \(\{i,j\}\) becomes the
sum attached to its complementary pair \(\{k,l\}\), because
\[
 (-s_A-a_i)+(-s_A-a_j)
 =s_A-a_i-a_j=a_k+a_l
 \quad\text{in characteristic three}.
\]
The involution preserves the total sum and squares to the identity.  If it
fixes a four-set, that set is two centrally opposite pairs and is planar; a
planar four-cap is of exactly this form.  If the cap spans affine dimension
three, it and its mate are the even and odd halves of an affine three-cube.
In the normal form
\[
 A=\{0,u+v,u+w,v+w\},\qquad
 A^*=\{u,v,w,u+v+w\},
\]
their moments agree through degree two, while an affine transport of the
monomial (x_1x_2x_3) separates their degree-three evaluation functionals.

Exact exhaustion supplies the fibre-completeness check:

- there are (14{,}742) four-caps in \(\mathbf F_3^3\);
- (2{,}106) planar caps have singleton profile fibres; and
- the (12{,}636) affine bases form (6{,}318) two-element fibres.

The two strata are the two \(\operatorname{AGL}(3,3)\)-orbits: their
stabilizers have orders (144) and (24), while an unordered reflected pair
has stabilizer (48).  The replay
`notes/2026-08-10-c905-cap-autoconvolution.py` checks every cap, fibre,
reflection, and moment assertion without writing files.

Here "fibre" is deliberately a **labelled-ambient** statement.  The two
members of an affine-basis fibre are affinely equivalent (in the Boolean
normal form, a coordinate bit flip exchanges the parity halves).  Thus the
shadow forgets an orientation bit inside one affine isomorphism class; it
does not produce two new affine cap types.  This is the same distinction as
the series' structural fibre versus a marking torsor.

This is an exact cap-set analogue of the series mechanism:
\[
 \text{pair shadow}\Rightarrow\text{cap or unordered reflected pair},
 \qquad
 \text{one cubic functional}\Rightarrow\text{oriented cap}.
\]
No novelty claim is made until the bitrade, cap-autocorrelation, and
higher-order Fourier literature has been audited.

The reflection pair is the (n=3) member of an exact infinite family.

> **Parity-cap shadow theorem (proved).**  For (n\ge2), let
> \[
> E_n=\{x\in\{0,1\}^n:\textstyle\sum_i x_i\equiv0\pmod2\},\qquad
> O_n=\{x\in\{0,1\}^n:\textstyle\sum_i x_i\equiv1\pmod2\},
> \]
> regarded as subsets of \(\mathbf F_3^n\).  Then:
> 
> 1. (E_n), (O_n), and their union \(\{0,1\}^n\) are caps;
> 2. (m_{E_n}=m_{O_n});
> 3. their polynomial moment functionals agree in every degree (<n); and
> 4. the degree-(n) monomial (x_1\cdots x_n) separates them.

For (1), three binary vectors summing to zero in \(\mathbf F_3^n\) must have,
in every coordinate, either zero or three ones; hence the three vectors are
equal.  For (2), work in the integral group algebra of \((C_3)^n\), put
\[
 A=\prod_i(1+X_i),\qquad B=\prod_i(1-X_i),\qquad
 F_E=(A+B)/2,\quad F_O=(A-B)/2.
\]
The ordered distinct-pair enumerator is (F^2-F(X^2)).  Therefore
\[
 [F_E^2-F_E(X^2)]-[F_O^2-F_O(X^2)]
 =AB-B(X^2)=0,
\]
because both terms equal \(\prod_i(1-X_i^2)\).  Negating the pair-sum
coordinate gives the stated equality of missing-third profiles.

For (3), every projection of either parity half onto fewer than (n)
coordinates is uniform: each pattern has (2^{n-|S|-1}) lifts of either
parity.  Every monomial of degree (<n) uses fewer than (n) coordinates,
so its two sums agree.  The full product is one only at the all-one vector,
which lies in exactly one parity half, proving (4).

Thus the series' degree pattern has a cap-tower analogue:
\[
 \boxed{\text{the pair shadow forgets one parity bit, and polynomial degree
 (n) is necessary and sufficient to recover it.}}
\]
For (n=2) the pair profile has additional ambiguity; for (n=3) the exact
four-cap exhaustion proves that the fibre is precisely \(\{E_3,O_3\}\) up to
affine transport.  Dimension four is exceptional in a more interesting way.

> **Triality fibre theorem (exact finite result).**  In the fixed labelled
> ambient space \(\mathbf F_3^4\), the complete eight-cap fibre of the common
> profile of \(E_4\) and \(O_4\) has exactly three members:
> \[
>   E_4,\qquad O_4,\qquad
>   X_4=\{(2,2,2,2)+\varepsilon e_i:
>             1\le i\le4,\ \varepsilon\in\{1,2\}\}.
> \]
> Their polynomial moment functionals agree in degrees below four, while
> their degree-four moment vectors are pairwise distinct.

The completeness proof is structural.  The target profile
has one value of multiplicity four, at \((2,2,2,2)\), and all other nonzero
values have multiplicity one.  Any eight-set with that profile is therefore
partitioned into four pairs with a common sum.  Translating their common
midpoint to zero makes it
\(\{\pm v_1,\ldots,\pm v_4\}\).  Its twenty-four nonopposite pair sums are
exactly
\[
 R=\{r\in\mathbf F_3^4:\operatorname{wt}(r)=2\},
\]
the mod-three \(D_4\) roots.  With \(q(x)=\sum_i x_i^2\), the conditions
\(v_i+v_j,v_i-v_j\in R\) give
\[
 q(v_i)=1,\qquad v_i\mathbin{\cdot}v_j=0\quad(i\ne j).
\]
Conversely, an orthonormal basis has all \(\pm v_i\pm v_j\) in \(R\), and
basis independence makes the twenty-four sums distinct.  The fibre is thus
the set of orthonormal decompositions into four lines.

There are exactly three.  A unit vector over \(\mathbf F_3\) has Hamming
weight one or four.  If an orthonormal basis contains a weight-one line,
orthogonality forces the four coordinate lines.  Otherwise all four lines
have full support.  Normalize their first coordinates to one; orthogonality
then says that two sign rows differ in exactly two positions.  The full-sign
lines split into exactly the even and odd parity Hadamard frames.  These give
\(X_4,E_4,O_4\), respectively.

This triple is not accidental.  After translation by the common centre,
\(E_4\) and \(O_4\) are the two half-spin sign systems and \(X_4\) is the
coordinate vector system.  The order-four Hadamard matrix
\[
 H=\begin{pmatrix}
 1&1&1&1\\ 1&1&-1&-1\\ 1&-1&1&-1\\ 1&-1&-1&1
 \end{pmatrix}
 \quad (H^2=I\text{ over }\mathbf F_3)
\]
exchanges one spin system with the vector system, while coordinatewise
complement exchanges the two spin systems and fixes the vector system.
These transpositions generate the visible \(S_3\) triality on the fibre.
All three caps are therefore affinely equivalent: again the theorem detects
a marking fibre, now of size three, rather than three cap isomorphism types.
Precisely, the induced triality action is the homogeneous space
\(S_3/S_2\); the three-point fibre is not an \(S_3\)-torsor.

The moment statement is also conceptual.  For any centered orthonormal frame
\(\{\pm v_i\}\), odd moments through degree three cancel and the quadratic
moment tensor is
\(2\sum_i v_iv_i^{\mathsf T}=2I\).  Translating back preserves equality in
degrees below four.  The monomial \(x_1x_2x_3x_4\) takes summed values
\(1,0,2\) on \(E_4,O_4,X_4\), respectively, and separates the three.

The replay additionally checks the proof without using the classification:
the forced antipodal reduction leaves
\(\binom{40}{4}=91{,}390\) candidates, and exact exhaustion returns exactly
the three displayed sets.

The equality \(2^{n-1}=2n\), needed for the half-spin and vector systems to
have the same cardinality, singles out \(n=4\) among \(n\ge3\).  Thus this
third mate is exceptional rather than an obvious infinite extension.  The
exact fibre for \(n\ge5\) remains open here.

### CAP2 — power spectrum versus bispectrum

For functions on a finite abelian group, second-order correlation gives a
power spectrum and generally leaves phase/homometric ambiguity.  Third-order
correlation gives a bispectrum, which under suitable nonvanishing hypotheses
can recover the function up to translation.  This has the same structural
shape as
\[
 \text{quadratic data recover a carrier/unordered fibre},\qquad
 \text{cubic data orient it}.
\]

The analogy is not an identity of shadows.  The cap statistic above is a
**sum autoconvolution**: its Fourier transform is a square
\(\widehat f(\chi)^2\), not the modulus square
\(|\widehat f(\chi)|^2\) of ordinary difference autocorrelation.  Any use of
homometric or bispectral results must therefore translate the involution and
equivalence relation explicitly.

The parity-cap theorem supplies an infinite family in which one degree-(n)
monomial separates the displayed pair.  The Clebsch-owned question is not the
classical bispectrum theorem, but whether the displayed pair is the complete
second-order fibre, or whether a comparably sparse higher-order statistic
separates the complete fibre.  The targets are:

- an exact second-order fibre classification for a structured cap family;
- a sharp cubic separator and proof that quadratic statistics cannot orient;
- an affine-equivariant reconstruction algorithm; and
- a counterexample boundary outside the structured family.

This is the most plausible direct bridge from the series to additive
combinatorics and higher-order Fourier analysis.

### CAP3 — projective caps and secant-defect identities

The series' arcs are two-dimensional projective caps.  In higher projective
dimension, the first secant moment still counts pairs, but the planar second
moment no longer closes because two secant lines may be skew.  The resulting
error term is itself meaningful: it measures the intersection graph of
secants.

A possible theorem would express a prescribed-hole defect as
\[
 \text{planar matching-design defect}
 + \text{nonnegative/skew-secant correction},
\]
then characterize equality by caps whose secant geometry is locally planar or
polar.  Before pursuing this, one must check whether the correction is
actually sign-definite; skewness may destroy the positivity that powers the
plane theorem.

### CAP4 — exceptional minuscule configurations as caps

It is tempting to reduce the (27) minuscule weights or (27)-line
configuration modulo small primes and call the result a cap.  This is not
licensed by orbit counts or by the label (E_6).  The first gate is literal:

1. specify an affine or projective embedding over \(\mathbf F_q\);
2. test the no-three-collinear condition;
3. determine whether the incidence/cubic structure is recoverable from the
   cap; and
4. audit known exceptional caps and Weyl-group constructions.

Until those gates pass, this is a fishing question only.

### Best order of attack

1. Audit and conceptually package the completed four-cap theorem.
2. Determine the exact profile fibre of the affine-cube parity pair for
   (n\ge5); dimension four is now the exact three-point triality fibre.
3. Test the minimal bispectral data in CAP2.
4. Develop NT1 alongside C906, because its fibre actions are already needed
   for the exceptional tower.
5. Treat NT3 as the likely theorem and NT4 as its integral refinement.
6. Defer CAP3/CAP4 until their first positivity/incidence falsifiers pass.

## 6D. Hard red team and priority judo

### What classical work already owns

The first audit pre-empts every broad version of the cap/Fourier slogan.

1. The Boolean cube \(\{0,1\}^n\subset\mathbf F_3^n\) as a product cap is
   elementary and appears explicitly in modern cap-set work.
2. The even and odd halves of a binary hypercube are the classical minimum
   Steiner bitrade; at dimension three this is the Pasch trade.
3. Completeness of triple correlation/bispectrum up to translation, under
   the usual Fourier-rank hypotheses, is classical.  A generic claim that
   "quadratic data lose phase and cubic data restore it" is unavailable.
4. Reconstruction from \(k\)-decks under group actions is already a general
   subject.  The abstract reconstruction-profile schema is organizing
   language, not by itself a new theorem.
5. Principal-minor fibres are sharply understood in substantial generality;
   irreducibility/cut structure, not a Clebsch-specific slogan, governs the
   generic fibre.

Accordingly, none of those ingredients is a priority claim of C905.

### The surviving adjacent crown

The bounded judo target is the **composition** that the consulted classical
sources do not themselves formulate:

\[
 \text{classical parity trade}
 \hookrightarrow \text{two ternary caps}
 \xrightarrow{\text{full missing-third sum shadow}}
 \text{one labelled fibre},
\]
with all four of the following kept together:

1. equality of the complete distinct-pair sum profile, rather than equality
   of a design boundary or a difference autocorrelation;
2. complete fibre classification in \(\mathbf F_3^3\), followed by the
   exceptional three-point \(D_4\)-triality fibre in \(\mathbf F_3^4\);
3. a sharp polynomial-moment statement for the parity tower: every degree
   below \(n\) fails, while one degree-\(n\) monomial succeeds; and
4. the correct quotient statement: the ambiguity is a labelled orientation
   bit inside one affine isomorphism class.

This is the current strongest candidate, not yet a novelty verdict.  The
exact fibre for \(n\ge5\) is unknown, and broader homometric-set, cap-bitrade,
and additive-reconstruction literature has not yet been closed.

### Red-team limits on the theorem

- The degree lower bound concerns **polynomial evaluation moments**.  It does
  not lower-bound arbitrary invariants, query complexity, correlation order,
  or bispectral degree.
- Equality of \(m_{E_n}\) and \(m_{O_n}\) proves a two-point subfibre, not a
  complete fibre in general.  Dimension four already has a third mate; no
  complete classification is claimed for \(n\ge5\).
- Affine equivalence exchanges the two parity halves.  Hence this is an
  orientation/marking obstruction, not non-isomorphism reconstruction.
- The exhaustive \(n=3\) check is exact evidence but is not yet packaged to
  the repository's paper-facing reproducibility standard and has no
  independent replay.  It cannot enter a manuscript in its present form.
- Sum autoconvolution and difference autocorrelation have different Fourier
  transforms.  Results about homometry transfer only after a proved bridge.
- Characteristic three is load-bearing both in the cap condition and in the
  complementary-pair identity.  No field-uniform tower has been proved.

### Exact next tests

Only two adjacent candidates survive the bounded extraction pass:

1. explain the exact \(D_4\)-triality action on the three-point \(n=4\)
   fibre without exhaustion, then test \(n=5\) inside a symmetry-reduced
   candidate class;
2. determine the smallest affine-equivariant additional statistic that
   orients the full structured fibre, separating polynomial-moment degree
   from correlation order.

Failure is informative in both cases.  The third mate at \(n=4\) already
gives an exact lower bound of three for this pair-shadow reconstruction fibre;
failure of a bounded-order separator would give a genuine local-to-global
impossibility theorem for this tower.

## 6E. Claim-specific literature boundary

**Opening depth summary.**  Three sources below were read at full text, three
at stated partial depth, and one at abstract/accessible-excerpt depth only.
This is a bounded pre-emption audit, not a completed absence search.  It
licenses the classical-ownership statements above and no "first" or "to our
knowledge" sentence.

1. D. S. Krotov, I. Yu. Mogilnykh, and V. N. Potapov, *To the theory of
   q-ary Steiner and other-type trades*, arXiv:1412.3792v3.  **Read depth:
   full text**, cached as `arXiv:1412.3792`, SHA-256
   `a420770dcc6254368dc59e2512595400ed271aebe30b8b509c3b78a88ad92ad9`.
   Example 3 explicitly realizes the minimum Steiner bitrade as the even and
   odd halves of a hypercube and identifies the three-dimensional Pasch case.
2. R. Kakarala, *The bispectrum as a source of phase-sensitive invariants for
   Fourier descriptors: a group-theoretic approach*, arXiv:0902.0196v2.
   **Read depth: full text**, cached as `arXiv:0902.0196`, SHA-256
   `3fd164ae5da4c94a04e14c3f008efc3348640b5469e8c2e47c66edeb8fb48743`.
   The relied-on result is bispectral completeness up to translation under
   nonsingularity/maximal-rank hypotheses, including homogeneous-space
   variants; the cap sum-shadow comparison is the auditor's analogy, not the
   paper's claim.
3. A. Al Ahmadieh, *The Fiber of the Principal Minor Map*,
   arXiv:2309.00806v2.  **Read depth: full text**, cached as
   `arXiv:2309.00806`, SHA-256
   `2b3f517b0f9a67b499a9cb3c757f5c4016a551fca9a8b22fbd02e6eb7b365501`.
   The relied-on results are the single diagonal-equivalence fibre in the
   irreducible symmetric case and the cut/reducibility description of larger
   fibres.
4. F. Tyrrell, *New Lower Bounds for Cap Sets*, arXiv:2209.10045v2.
   **Read depth: partial**, Introduction and Section 2 through the product
   construction; cached as `arXiv:2209.10045`, SHA-256
   `fbad0ba9b7cd25c82ebbb9a79ddf63d2d1f815f55a5b676167122500d5b7b0c5`.
   These sections explicitly give \(\{0,1\}^n\) as the elementary product
   cap.  No claim is made about the unread remainder.
5. A. J. Radcliffe and A. D. Scott, *Reconstructing under Group Actions*,
   DOI `10.1007/s00373-006-0675-y`.  **Read depth:
   abstract/accessible-excerpt only**, reached through web metadata and an
   accessible excerpt; direct full-text caching failed because of the source
   endpoint's TLS certificate.  The abstract suffices only to establish that
   general \(k\)-deck reconstruction under group actions is prior terrain;
   it does not settle any exact Clebsch or cap fibre.
6. J. C. Baez, *The Octonions*, arXiv:math/0105155 (published web version).
   **Read depth: partial**, Section 2.4, "Spinors and Trialities," read in the
   author's HTML version; the arXiv PDF is cached as `arXiv:math/0105155`,
   SHA-256
   `f8087fb91b10cdbee2157e8eec8c33ac6b918b0de2c8c1fd16b4d8183f0868cc`.
   The relied-on result is the classical
   \(S_3=\operatorname{Out}(\operatorname{Spin}(8))\) permutation of the
   vector and two half-spin representations.  The reduction of the three
   weight systems modulo three and their identification with the computed
   cap fibre are C905's inference, not Baez's claim.
7. J. Awan, C. Frechette, Y. Li, and E. McMahon, *Demicaps in AG(4,3) and
   Their Relation to Maximal Cap Partitions*, arXiv:2106.14141.
   **Read depth: partial**, abstract, Sections 1--3, and the relevant affine
   group discussion in Section 5, through the arXiv HTML rendering; the PDF
   is cached as `arXiv:2106.14141`, SHA-256
   `d9ca802cbe9875cb5efa46562474eb71f50d63eb63931d6972eebd34f368a84c`.
   Its
   demicaps are anchored ten-point subcaps of maximal twenty-caps, not the
   eight-cap missing-third-profile fibre here.  This distinction is only a
   scope check, not an absence verdict about the whole cap literature.

The bounded exact-phrase/structure search that exposed the triality boundary
used these queries verbatim:

- `D4 triality vector spinor weights Hadamard matrix mod 3 cap`;
- `ternary cap D4 triality 8 points F3^4`;
- `homometric sets F3^4 triality cap pair sums`;
- `Steiner bitrade D4 triality ternary cap`;
- `"8-cap" "AG(4,3)"`;
- `"AG(4,3)" cap 8 triality`;
- `"F_3^4" cap Hadamard triality`; and
- `"pair sums" cap "F_3^4"`.

The results located the classical triality and the separate AG(4,3)
maximal-cap/demicap literature, but no result page advertised the exact
three-member missing-third-profile fibre.  Because this was a web-result
screen rather than a pinned multi-index citation-graph audit, it licenses no
negative novelty claim.

**Coverage gaps.**  The Radcliffe--Scott full text was not obtained.
MathSciNet is NOT COVERED.  The cap-homometry and cap-bitrade forward
citation graphs have not been exhaustively screened, and no three-index
forward-citation negative has been attempted.  Therefore the adjacent-crown
composition, including the triality fibre formulation, remains a research
candidate only.

## 7. C906 handoff rule

The exceptional tower may consume only a **proved carrier interface**:

- identify the carrier and its declared equivalence;
- prove the structure map is equivariant;
- compute the exact fibre or explicitly decline to;
- give a reverse map only on an explicitly characterized image; and
- record every marking carried rather than reconstructed.

This rules out calling the classical plus-type folds a bidirectional tower.
The possible new spin is narrower: sparse recognition of an entry level,
canonical marked placement into the existing tower, functorial forward folds,
and reverse recovery exactly on those images for which a section or retained
marking is actually proved.
