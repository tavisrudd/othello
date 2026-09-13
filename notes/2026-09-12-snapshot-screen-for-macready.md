# Portfolio screen for Bill Macready

**Date:** 2026-09-12
**Source:** `notes/2026-07-31-results-summary-snapshot.md` (dated 2026-09-06), read in full.
**Purpose:** which of Tavis's mathematical results would interest Bill Macready, and why.

**Reader profile assumed.** Coauthor of the No Free Lunch theorems for optimization and
search; long-time CTO / chief scientist at D-Wave (quantum annealing, Ising and QUBO
formulations, hardware, quantum-versus-classical benchmarking); later Sanctuary AI. Current
interests, from the 2026-09-12 conversation: category theory for language design and for
compiling intermediate representations; a categorical foundation broader than Abbott–Zardini
neural circuit diagrams, able to represent symmetries, generalized tensors, predicate logic,
and tensor networks for modelling quantum systems; tensor logic (einsum-syntax Datalog) as an
external syntax; he is modelling his intermediate representation in Lean; possibly MLIR. He
likes Abbott's work.

**Lenses used.**
(a) symmetries and group actions realised as concrete structures representable in an IR;
(b) tensor-network or operator-algebraic content, fermions, Majorana, anomalies, lattice and
exceptional structures, anything modelling a quantum system;
(c) Ising/QUBO/annealing-shaped combinatorics, benchmarks, and anything bearing on NFL-style
claims about search versus structure;
(d) Lean formalization and machine-checked certificates as reusable or comparable artifacts;
(e) coding theory and quantum codes as compilation targets or as objects a categorical IR
would want to express;
(f) predicate-logic or rule-shaped statements of results.

**Scope note.** Ergodis, the exact-optimization engine, is excluded by instruction and is
being broadened for him on a separate track. Item 7 below is included because its content is
a certified structural fact about quantum codes and their encodings, not about the engine; the
engine's own benchmark table is screened out.

**Claim-status discipline.** Every hedge below is the snapshot's own. Nothing is upgraded.
Where the snapshot says "not proved", "conditional", "not claimed", "pre-empted", "certified
rather than human", or "not machine-checked", that wording is preserved.

---

## Ranked list

### 1. The golden conference operator and its cubic, fermionic, anomaly and lattice shadows

**Snapshot section:** "The golden conference operator source programme" (section 7). Source
body feeding forward versions of *Golden descent and operator realizations of the Clebsch
cubic*; not a manuscript of its own.

**The result.** A single marked symmetric operator `C` on six axes with `C^2 = 5I` generates,
by standard functorial operations, a large family of objects that look unrelated. The snapshot
states the claim directly: "a large family of apparently unrelated objects — cubics, polar
maps, determinantal resolutions, fermionic amplitudes, anomaly solutions, and lattices — are
images of that one operator under exterior power, golden compression, commutator,
determinant/Pfaffian, adjugation, and centered squaring, and not accidental formula matches."
Concretely: `Pf[D_x, C_T] = 4 Z_T(x)` and `det[D_x, C_T] = 16 Z_T(x)^2`; the chiral free-fermion
family `A_C(x) = [D_x, C]` anticommutes with `C`, exchanges the two golden three-spaces, and its
zero-mode locus is exactly the Joubert cubic, whose six nodes are "precisely the rank-two
cross-golden dimers, each leaving four Majorana zero modes"; "The Segre identities are the six-Weyl
`U(1)` anomaly equations", with two-Abelian-factor anomaly cancellation being exactly line
containment on the Segre cubic. On the Boolean side, "`C^2=5I` is equivalent to universal
maximum-determinant `K_{3,3}` frustration."

**Lenses:** (b) primarily — fermions, Majorana parity chambers, anomalies, exceptional
lattices, real equiangular tight frames and informationally complete POVMs all in one place;
(a) the whole construction is a functor-indexed family, which is the shape his IR is meant to
carry; (c) the `K_{3,3}` frustration and maximum-cut layer is literally an Ising ground-state
statement, and the ten-cut sign syndromes form a distance-six regular simplex that "corrects
two sign-readout errors".

**Why he specifically.** This is the portfolio's best single demonstration that one algebraic
generator, pushed through named functorial operations, reproduces a spread of physics-flavoured
structures — which is exactly the claim a categorical IR for quantum systems would want to be
able to state and check internally. The Ising-frustration equivalence gives him an entry point
from annealing, and the Majorana chamber count (860 gapped chambers, adjacency graph connected
of diameter ten, degree distribution `3^720 12^120 36^20`, realised as a coset-incidence graph
of a regular `S_6`-orbit) is the kind of finite symmetry data that an IR could represent as a
first-class object rather than as a numerical table.

**Marked as the snapshot marks it.** A full literature audit "found five clean pre-emptions,
two of them close to verbatim", binding anything drawn from the section: the centered-square
formula is Howard–Millson–Snowden–Vakil's verbatim; the six sisters and unordered support split
are theirs and Seidel's; the Fano-component realization is largely Gripaios–Nguyen's; the
order-ten shadow is classical (Fickus–Mixon, Bussemaker–Mathon–Seidel); the rational anomaly
inverse is prior art. "What survives with no located predecessor is the operator layer."
Separately, the physical demonstrator is "a **no-go for 2026 hardware**" and the companion is
written as a design-limit and theory note, not an experimental proposal. The mod-40 splitting
and fusion law is stated as conditional ("Under the frozen golden-marker hypotheses"). The
six determinantal nodes are kernel-checked in Lean.

**Send or ask.** Send the operator-layer statement only, with the pre-emption ledger attached,
and ask whether his categorical foundation can express "these six objects are images of one
operator under six named functors" as a typed statement rather than as six coincidences — and
whether the Majorana chamber complex is the kind of finite symmetric object his IR wants as a
primitive.

---

### 2. Local-unitary rigidity for stabilizer absolutely maximally entangled states

**Snapshot section:** *Local-Unitary Rigidity and Quantitative Rounding for Stabilizer AME
States* (section 12), with the transversal-group half standing alone as *Diagonal Isoduality
and Transversal Clifford Groups of MDS–CSS Codes*.

**The result.** An absolutely maximally entangled state of `2m` parties is one every
`m`-party marginal of which is maximally mixed — equivalently, a perfect tensor. The theorem
is that the weak equivalence collapses onto the strong one: every product-unitary intertwiner
between two such stabilizer states is a product of Clifford unitaries. The snapshot states the
generality explicitly: "This holds for arbitrary additive prime-power stabilizers: CSS
structure, equal phases, classical linearity, and the MDS hypothesis are all unnecessary for
rigidity, and the MDS–CSS theorem is a special case. The `m=1` Bell-pair boundary is sharp."
Rigidity is also quantitative: at phase-optimized global vector error `ε`, every local factor
lies within normalized Hilbert–Schmidt distance `2√2 q^2 ε` of an additive Clifford.

**Lenses:** (b) perfect tensors are the elementary cells of holographic tensor networks, so
this is a statement about the symmetry group of a tensor-network building block; (e) the
objects are quantum codes and their encoders; (d) the arbitrary-`m` marginal-to-rigidity chain
and the coset/syndrome dictionary are formally verified in Lean.

**Why he specifically.** If his foundation is to represent tensor networks, the first question
is what the automorphism group of a node is. This says the automorphism group of a perfect
tensor built from a stabilizer code is discrete and Clifford — no continuous local gauge
freedom beyond one-site scalar phases, which "form the full identity component". That is a
representability result: the local symmetry of these nodes is finite and nameable, so an IR
can carry it exactly instead of approximately. The quantitative version means the statement
survives numerical noise, which matters if the IR is ever compiled to hardware.

**Marked as the snapshot marks it.** No firstness claim is made; prior work is credited at
point of use (Wirthmüller, Anderson–Jochym-O'Connor, Sayginel et al.). The
marginal-to-rigidity chain and the generic coset/syndrome dictionary are formally verified;
"the full Choi/encoder construction and the exact GRS transversal-group computation remain
human proofs". Uniform semilinear reconstruction is false even at zero error, and the linear
identity `N(T) = T ⋊ C_2` is flagged as **false**, with `J^2 = -I` and `N(T)/T ≅ C_2` the
correct odd-characteristic relation.

**Send or ask.** Send the rigidity statement plus the `m=1` sharpness boundary, and ask
whether a categorical IR that represents tensor networks should carry "local symmetry group of
this node" as a type-level attribute — this theorem supplies a nontrivial family where that
attribute is exactly computed.

---

### 3. The Clebsch Schur–Sarkisov spine: a graded algebra that compiles to a quantum code

**Snapshot section:** *The Clebsch Schur--Sarkisov spine* (section 15). Not yet assigned to a
manuscript.

**The result.** Evaluation of binary forms of bounded degree on the rational points of the
projective line gives codes `R_d`, and coordinatewise Schur product of codewords is exactly
multiplication of forms: `R_a ⋆ R_b = R_{a+b}` for `a+b ≤ 10`. At `q=11` residue duality makes
`(E^{⋆2})^⊥ = E^{⋆3}` with `R_5` self-dual at the midpoint, and a jet modification
`0 → C_Γ → R_6 → J^{(2)}_{0,∞} → 0` produces a quantum CSS code whose logical Pauli spaces are
the jet quotients themselves: "The residue pairing becomes their Pauli commutator pairing. The
two second-jet lines therefore label the two logical `11`-level systems", giving
`[[12,2,(6,4)]]_11` and, over every odd prime power `q ≥ 7`, `[[q+1,2,(q-5,4)]]_q`. The
snapshot names its own next step in categorical language: "The next categorical target is a
**Conic Schur--Sarkisov correspondence**: construct the graded evaluation algebra
`A = ⊕_d R_d` together with its residue/Frobenius pairing and jet modifications, and recover
the three Fano objects and their Sarkisov centers functorially from that data."

**Lenses:** (a) and (e) together — a graded algebra with a pairing, whose module-level exact
sequences *are* the quantum code's logical structure; (b) the resulting pure CSS state is
3-uniform but not absolutely maximally entangled, and "the first failure of perfect-tensor
behavior is completely localized by the conic circuit geometry" (exactly fifteen of the
four-party marginals are deficient, on the three orbits of dual minimum supports).

**Why he specifically.** This is the closest thing in the portfolio to a worked example of
what he says he wants: an algebraic intermediate representation (graded evaluation algebra with
residue pairing) from which a concrete computational artifact (a quantum code with named
logical operators and distances) is recovered by structural operations rather than by
construction-by-hand. The Schur product is the einsum-shaped operation in his tensor-logic
vocabulary; here it is the algebra multiplication, and duality is the pairing. It also gives
him a live open problem stated as a functor that does not yet exist.

**Marked as the snapshot marks it.** "A base-change-compatible Rees construction and a master
correspondence among `Q^3, V_5, U_22` remain conjectural." "No novelty claim against the
asymmetric quantum GRS literature is made; the geometric jet/Sarkisov interpretation is the new
content here." Three bridges are "sharpened without yet proving them", including the absence of
any known recovery-equation-to-Rees-algebra functor. The entanglement-assisted
`[[12,4,4;2]]_11` construction's two-ebit count "equals the geometric defect numerically", but
"a canonical componentwise identification has not been proved".

**Send or ask.** Send the graded-algebra-to-code chain and the stated categorical target, and
ask whether his IR's notion of a compilation pass could express the jet modification as a
structured edit of a module rather than as a re-derivation of the code — that is precisely the
Rees-algebra functor the snapshot says is missing.

---

### 4. Exact composition of recovery costs: an associative min-plus law with labelled interfaces

**Snapshot section:** *Exact Transfer of Bounded Linear Recovery and Relative Weight
Hierarchies* (section 11), excluding its ergodis subsection.

**The result.** For a linear code, the normalized recovery-equation family at a target
coordinate retains exact helper supports *and* scalar recovery coefficients, and the associated
shortening–puncturing pair makes relative generalized Hamming weights the natural
rank-stratified invariants. The composition theorem is the part that matters here: "These costs
compose exactly through repeated concatenation. Ordinary prescribed-coset support is
substituted by a min-plus law over the labelled intermediate functional maps.
Target-normalized numerical composition needs the helper-restriction coset-support function
together with the intermediate target contribution; coefficient-level composition retains the
full lift relation. Both forms are associative. A single scalar threshold does not compose by
itself, because it forgets precisely the functional labels that the next outer code
constrains." Full repair reliability is a specialization of the Las Vergnas polynomial of the
matroid perspective `M \ x → M / x`, with pointed duality exchanging repair and failure.

**Lenses:** (f) and (a) — this is a compositionality theorem with an explicit statement of what
interface data must be carried for composition to be well defined; (e) the objects are codes
under concatenation, a genuine compilation pipeline.

**Why he specifically.** The sentence about the scalar threshold failing to compose is a
precise instance of the design failure that motivates typed intermediate representations: a
summary invariant is not a composable interface, and the theorem names exactly the extra
labels that restore associativity. Anyone designing an IR and its lowering passes has met the
same problem in informal form; here it has an exact answer in a nontrivial category of codes,
plus a matroid-theoretic deletion-contraction shadow.

**Marked as the snapshot marks it.** "The paper's main proofs are human proofs with cited
classical inputs. Its paper-local Lean package verifies the associated-pair exact sequence and
four terminal statements; the stronger relative-weight, ungated-transfer, and composition
theorems are explicitly recorded as absent from that formal package rather than being
represented by certificates or assumed interfaces." Two related claims were withdrawn rather
than weakened: universal log-concavity of the pointed profile is refuted by an explicit
counterexample, and a narrower representable-matroid form was killed by an infinite
series-parallel counterexample family. Also: "the functional-cost parameter is definitionally
the classical coset-leader/syndrome weight, and a rescaling theorem shows raw coefficient
values are arbitrary coordinate gauge, so no minimum-access or minimum-bandwidth claim follows
from them."

**Send or ask.** Send the composition law and the "a single scalar threshold does not compose
by itself" sentence, and ask what his IR carries at a lowering boundary — whether it already
has the analogue of the labelled functional map, or whether it currently passes a scalar and
would hit the same non-associativity.

---

### 5. Eight qubits is the minimum length for a diagonal transversal non-Clifford gate

**Snapshot section:** "A certified finite no-go for transversal non-Clifford gates", under
*Unassigned adjacent results* (section 17).

**The result.** Over every binary quantum CSS code of length at most eight — an exhaustive
enumeration of 8,044,851 flags at length eight — an X-check weight of at most seven admits no
diagonal transversal gate at level three or above of the Clifford hierarchy. Two corollaries:
"at length at most seven the hierarchy caps at level two at every weight, so **eight qubits is
the minimum length for a diagonal transversal non-Clifford gate**; and at length eight, level
three occurs only at full X-check weight, uniquely for `[[8,3,2]]`." The threshold
`w_X ≥ 2^(ℓ-1)` is attained at every level up to six along the Reed–Muller ladder to length 64.
Alongside it, complete diagonal transversal groups were computed by Smith normal form over all
real phases: `[[16,4,2]]` admits exactly the triply-controlled phase gate, `[[32,5,2]]` exactly
the quadruply-controlled one, and `[[31,1,3]]` a logical group cyclic of order sixteen, hence
level four.

**Lenses:** (e) transversal gates are precisely the logical operations that compile to
depth-one physical circuits, so this is a statement about what a quantum compiler can and
cannot emit; (f) the statement is a universally quantified rule over a finite domain with named
exceptions, which is the shape a Datalog-style external syntax would encode directly; (b).

**Why he specifically.** This is a hard compilation boundary stated as a theorem about a
finite domain, and the exceptional case is named rather than absorbed. For someone building an
IR whose target may include quantum hardware, "which logical gates survive transversal
compilation, and at what minimum length" is a lowering-legality predicate.

**Marked as the snapshot marks it.** "This is an exhaustive finite verification, not a
structural theorem, and it is not assigned to a manuscript." The proof gap is named rather than
absorbed: "the `±1`-phase gate of `[[8,3,2]]` evades the textbook uniform-phase divisibility
argument and yet lands exactly on the threshold, so the threshold is not explained by that
argument." The length-nine pass at check weight at most six is excluded from the claim.

**Send or ask.** Send the two corollaries and the named proof gap, and ask whether his IR would
want lowering-legality rules of this shape as data (a finite relation with a minimum-length
witness) or as a proved side condition — and whether the `[[8,3,2]]` exception is a case his
type system could carry.

---

### 6. The icosahedral group recovered from decoding data alone

**Snapshot section:** *Reconstructing the Clebsch code and its golden orientation from its
deep-hole syndrome locus* (section 1), the first of the five numbered Clebsch papers.

**The result.** For a six-point arc in the projective plane of order eleven, five conditions
are equivalent: its uncovered locus lies on some conic; that locus is all twelve rational
points of a nonsingular conic; the locus has at most fifteen points; the arc is projectively
equivalent to the Clebsch hexagon; and its stabilizer contains the alternating group on five
letters. Under the arc/MDS dictionary the uncovered locus is the set of deepest syndrome
directions of a `[6,3,4]_11` code, so, in the snapshot's words, "The icosahedral group is
*recovered* from a purely coding-theoretic hypothesis rather than assumed." The phenomenon is
rigid rather than stable: every non-Clebsch class has nearest-conic discrepancy at least
twelve, and each single-point perturbation is at symmetric difference at least eighteen — "the
distance jumps from `0` to at least `18` with nothing in between." Separately, "The fifteen
Clebsch secants *are* the projectivized `H_3` icosahedral mirrors", an equality of arrangements
exhibited by an explicit projectivity, with characteristic polynomial
`χ_{H_3}(t) = (t-1)(t-5)(t-9)`.

**Lenses:** (a) a symmetry group is an output of coarse data, not an input; (e) the data is
decoding data; (d) both previously cited order-eleven inputs "are now proved from scratch and
machine-checked in Lean", including that the ten-point bound on triple-concurrence points holds
over every field in which two is invertible, and that attaining it forces a golden normal form
and hence a golden root in the ground field.

**Why he specifically.** The reconstruction direction is the one his interests point at:
given only syndrome-level observations, the full symmetry group and the exact configuration are
forced, with a measured gap showing nothing sits between the symmetric solution and everything
else. That is a concrete instance of "structure is recoverable from coarse observations", with
the recovery fibre computed rather than estimated. The identification of the secants with a
reflection arrangement gives him a bridge between a coding object and a Coxeter-theoretic one.

**Marked as the snapshot marks it.** Priority boundary is explicit: the `q=11` six-arc itself
is classical (Edge 1956, Blokhuis–Seress–Wilbrink 1992, Korchmáros 1981; Dye 1991 for the
ten-Brianchon bound and the stabilizer; Calvo 2024 for the reflection-arrangement ledger;
Jurrius–Pellikaan 2015 for the arrangement-decoder mechanism). What is claimed is the exact
covering, plus the rigidity, gap, low-degree, decoding and through-eight-points statements. A
later audit corrected an adjacent overstatement: "in characteristic five the projective
stabilizer is `S_5`, not `A_5`, because the golden roots coalesce." The all-sizes extension of
the conic-filling classification is explicitly **not proved**.

**Send or ask.** Send the equivalence and the gap statement. Worth mentioning alongside it:
the computational companion "labels every claim by one of five explicit modes — human
structural proof, published theorem, Lean theorem, finite certificate, and trusted execution —
so no finite classification or orientation theorem is presented as machine-checked when it is
not." That five-mode ledger is a provenance type system for mathematical claims and is directly
comparable to what he would need in a Lean-modelled IR; ask whether his IR distinguishes those
modes.

---

### 7. Compiling a code's own symmetry into the encoding, and the exact distances it bought

**Snapshot section:** "Symmetry reduction in exact quantum-code distance computation" and
"Exact distances of large quantum codes", inside section 11.

**The result.** Computing the exact minimum distance of a quantum CSS code is an integer
program over the code's coordinates, and the conventional encoding throws away the code's
symmetry: "the conventional per-logical-class encoding destroys the code's own symmetry: only
an order-two matrix symmetry survives from a source translation group of order `72`." A
class-independent global re-encoding restores the full translation action as a genuine symmetry
of the model, worth 3.1x on its own; orbit symmetry-breaking constraints add 4.2x; the combined
branch-and-bound tree falls by a factor of 13.1 on the gross code `[[144,12,12]]`. Against a
commercial mixed-integer solver the same treatment reduced twelve solves and 548,921 nodes to
two solves and 26,930 nodes. The mathematical payoff: the entire published lifted-product list
of Liu and Marquardt now has exact distances, every published randomized bound turning out
tight, and among them `[[1428,186,18]]` sets an exact rate–distance record `kd^2/n = 42.20`,
beating the previous exactly known best by 1.245x.

**Lenses:** (c) directly — this is a measured case where the symmetry structure of the problem,
compiled into the encoding rather than discovered by the solver, is what produces the win, and
the snapshot records that "no solver log reporting a native symmetry or orbital pass" appeared;
(e) the objects are quantum codes.

**Why he specifically.** He wrote the theorems saying no search algorithm dominates across all
problems. The interesting counterpart is where the leverage actually lives, and this is a
clean instance: the same solver, the same instance, the difference being whether the semantic
symmetry group survives the encoding. Framed for him, the claim is not "our solver is better"
but "the encoding destroyed a group of order 72 and reduced it to order 2, and restoring it is
worth an order of magnitude" — a statement about representation, not about search. That is also
why it belongs to his IR interests rather than to the engine track.

**Marked as the snapshot marks it.** "None of it is machine-checked in the proof-assistant
sense." Each distance "is an exhaustive finite enumeration by one reviewed implementation, with
the witness at the attained weight decoded and replayed by a second, independent
implementation. That replay covers the upper bound only." The node counts "are a property of
one solver's search... reproducible rather than verifiable", and "Whether the reduction
survives on solvers with built-in orbital branching is untested and is the gate on any external
claim." The bivariate-bicycle `[[756,16,·]]` case is **still open**, narrowed to
`28 ≤ d ≤ 34` with `d` even. This result "is not assigned to a manuscript".

**Send or ask.** Send the order-72-to-order-2 encoding fact and the node-count table, with the
untested-orbital-branching gate stated. Ask whether his IR would treat "semantic symmetry group
of the source program" as something a lowering pass must preserve, and what it would take to
make that preservation checkable rather than incidental.

---

### 8. The golden orientation torsor is the exotic `F_4` gluing torsor

**Snapshot section:** *The Golden Companion Correspondence* (section 5), its closing
normalization–residue theorem; with the consequence used in the cubic-threefold programme
(section 6).

**The result.** Take the oriented conference matrix `B` with `B^2 = 5 I_6` on the rank-six
integer lattice, adjoin the half-sum, and set `φ = (I+B)/2`. The resulting maximal
over-lattice is the `D_6` weight lattice and is the minimal over-lattice preserved by `φ`;
since `φ^2 - φ - 1 = 0` it carries the maximal golden order `Z[φ]`, even though the equivariant
endomorphism ring of the original lattice is the index-two order `Z[√5]`. Reduction modulo two
gives a three-dimensional `F_4`-space whose commutator submodule is its unique nonzero proper
submodule, with nonsplit extension and one-dimensional extension group, and reversing the
golden orientation sends `φ → 1-φ` and `ω → ω^2`. The snapshot's conclusion: "So the golden
orientation torsor this series reconstructs *is* the exotic `F_4`-gluing torsor `{ω, ω^2}`.
That identification is the hinge the stabilization programme below turns on."

**Lenses:** (a) a one-bit orientation datum, tracked through several papers, is identified with
a specific module-theoretic torsor — the symmetry is pinned to a concrete finite structure;
(b) lattices and exceptional gluings.

**Why he specifically.** This is the portfolio's sharpest example of an invariant being
followed across representations until it lands on a canonical carrier. For an IR designer the
relevant pattern is the bookkeeping: the same bit appears as a geometric orientation, a
conference-matrix switching class, a signed cubic, and finally an `F_4` gluing class, and the
paper keeps a complete ambiguity ledger saying which markings transport and which do not. That
ledger discipline is transferable to compilation, where the same question — which choices are
gauge and which are semantic — is constant.

**Marked as the snapshot marks it.** The bridge in the companion paper is "explicitly
*relative* to a marked datum" with a complete ambiguity ledger; the selected sheet does not
reconstruct the marking. "Human proof, finite evidence, literature ledger, clean standalone
package, and three cold reads are green; the formal layer remains separate work." A further
proved arithmetic consequence (the inertia stratification with branch signature `(2,3,5)`)
"remains outside the manuscript until its classical attribution boundary and larger arithmetic
certificate are closed", and the higher relative theorem over a localization of `Z[√5]` is open.

**Send or ask.** Send the normalization–residue theorem and the ambiguity ledger. Ask whether
his foundation has a way to say "this object is defined only relative to a marking, and here is
the exact fibre of the forgetful map" — the snapshot's cross-paper summary is that "sparse
shadows recover carriers, and their exact fibres measure what was forgotten", which is a
statement about a forgetful functor's fibres.

---

### 9. A reconstruction dichotomy: either the full symmetric group or exactly `PΓL_2`

**Snapshot section:** *The Gram–discriminant shadow of four points and its Dickson tower*
(section 19), "Reconstruction from the coloring". Not assigned to a manuscript.

**The result.** A square-class label is attached to each unordered four-subset of the
projective line by the Gram determinant of the four points against the invariant form on a
Veronese degree. The dichotomy: "For every odd prime power `q` and every `m`, exactly one of
two things happens: the coloring is constant and its automorphism group is the full symmetric
group `Sym(q+1)`, a total loss of marking; or the coloring is nonconstant and its automorphism
group is exactly `PΓL_2(F_q)`, so the shadow recovers the entire projective structure. Nothing
intermediate occurs." In the reconstructing case the marking fibre is exactly the Galois group
of the field over its prime field, independent of the Veronese degree. There is also a parity
ceiling: a nontrivial quadratic-character shadow can exist only in even Veronese degree,
because the invariant form is alternating in odd degree.

**Lenses:** (a) an all-or-nothing symmetry statement with the residual ambiguity computed
exactly; (f) the statement is a clean two-case rule with a named exceptional set; (c) it comes
with query complexity — reconstruction needs at least `⌈(q-1)/4⌉` queries by a touching bound
and `Θ(q log q)` by a counting bound, both proved, with `O(q^2)` non-adaptive queries sufficing
in the censused range.

**Why he specifically.** Dichotomies with nothing in between are rare and are exactly what a
type system likes: a predicate on the coloring decides between two named groups, with no
intermediate case to handle. The accompanying Baer stratum is the one place where the standard
recovery algorithm fails and a different recognition theorem is needed — "the one place in the
whole sweep where partition refinement fails... and it is the only query-complexity jump" —
which is a concrete example of a single instance family breaking an otherwise uniform decision
procedure.

**Marked as the snapshot marks it.** "Nothing in this section is formally verified." The
organizing factorization is conceded as classical: it "is a classical-derived corollary of the
Wronskian isomorphism and is not claimed as new, and the quartic square-class case is
substantially pre-existing"; every priority claim carries a "to our knowledge" qualified by
recorded coverage gaps (MathSciNet, Google Scholar and the nineteenth-century symbolic
originals were not covered). The dichotomy is proved in general, but "the absence of
intermediate behaviour is proved in general while the exhaustive confirmation runs only to
`q ≤ 121`". The tower's modularity stops at `m=8` "on statistical evidence rather than proof",
from Sato–Tate moments — "a moment measurement, not a theorem".

**Send or ask.** Send the dichotomy, the marking fibre, and the Baer exception. Ask whether
his IR could express "the automorphism group of this labelled structure is exactly `G`, or else
everything" as a decidable property, and whether the Baer stratum is the kind of case his
foundation would want to surface as a distinct constructor rather than as a runtime failure.

---

### 10. The query complexity of reconstructing a two-graph, and the gap to the entropy floor

**Snapshot section:** "The query complexity of reconstructing an aligned design", under
*Unassigned adjacent results* (section 17). In no manuscript.

**The result.** A two-graph on `n` points carries `binom(n-1,2)` bits; a four-set is aligned
when its four triples carry equal values; a family of four-sets is separating when the answers
determine the two-graph. Adaptively the constant is exact: "An explicit decoder reads the
two-graph in `binom(n,2)+n-4` alignment tests on every instance, against a counting lower bound
of `binom(n,2)-n`, so the adaptive constant is exactly `1/2` and the coherence restriction
costs nothing to leading order." Nonadaptively it is bracketed between `0.616 n^2` and
`(9/8) n^2 + O(n)`, and the evidence points at the floor being loose, not the construction:
"Every exactly measured family costs between 2.25 and 3 alignment tests per recovered bit while
the entropy floor licenses 1.2326."

**Lenses:** (c) a measured gap between an information-theoretic floor and every realizable
query family, with both natural lower-bound routes (polynomial method, covering argument)
closed for stated reasons; (d) the eight-point attachment constant `g(8)=17` is closed by
solver refutations at sizes 15 and 16, with "binary resolution proofs which an independent
proof checker verified"; (f) the separation condition is recast as a clean rule — a triple
family separates a cut "precisely when the graph on the crossing point-pairs is non-bipartite,
equivalently contains an odd-cardinality Eulerian subgraph".

**Why he specifically.** The headline for a search theorist is the structure of the gap: the
adaptive constant is exactly `1/2` and the coherence restriction is free, while the nonadaptive
setting pays between two and three times the entropy floor with no known family doing better.
That is a concrete adaptivity separation with both ends measured. The certified-but-not-human
boundary is also his kind of question: the refutation is machine-verified, and reducing it to a
human argument has been attempted and failed, with the obstruction localized to a coupling of
three cut strata.

**Marked as the snapshot marks it.** "the boundary is that both refutations are certified
rather than human"; the satisfying family at 17 was decoded and replayed by a separate
implementation. "Reducing the size-16 refutation to a human argument has been attempted and has
not succeeded", and the three-stratum incompatibility target "is relative to the current
encoding rather than absolute". Separately, a two-graph literature audit found the underlying
machinery standard and currently uncited, and the closest named benchmark wrong: the
four-local reconstruction result of Dammak, Lopez, Pouzet and Si Kaddour is for ordinary graphs
and hits the same two numbers, and "Whether the two-graph statement is a corollary of the graph
statement or genuinely independent is open".

**Send or ask.** Send the adaptive constant, the nonadaptive bracket, and the per-bit cost
comparison. Ask which side he would bet is loose, and whether the "distance distribution of the
alignment code itself" route named in the snapshot looks tractable to him.

---

### 11. The order-668 Hadamard payload, decoded, and a Lean theorem for the array that produced it

**Snapshot section:** "Residual multipliers for Hadamard order 668", "What the order-668
announcement actually contains", and "The smallest open Hadamard order, 2092", under
*Unassigned adjacent results* (section 17).

**The result.** Order 668 was the smallest order with no known Hadamard matrix until August
2026, when a team at Anthropic announced constructions for it and eleven other open orders,
released as an encoded string with a decoder and an undisclosed search method. The payload was
retrieved from two mirrors returning byte-identical bytes, the decoder was never executed, its
obfuscation undone statically, and the decoding re-implemented from scratch; all twelve matrices
verify exactly in integer arithmetic by two implementations. The structural finding: "The
payload contains no seed and no generator: every character is a literal entry of a first row or
a border, so the compression is purely structural, and for order 668 the whole information
content is 664 bits. Whatever search produced the sequences left no trace in what was posted."
The matrix is a bordered Goethals–Seidel array over four circulants of length 166 with one
deviation from the textbook array, and "The orthogonality statement is formalized in Lean with
the inner shift as a free parameter, so the classical array is the zero case and order 668 is an
instance of a stated theorem rather than a one-off." Its automorphism group has order four, and
reaching that bound required a forced choice of invariant: "on a Hadamard matrix every pair and
triple statistic is constant, and odd products are not monomial invariants at all, so
quadruples are the first level that is both invariant and non-constant."

**Lenses:** (c) `±1` matrices with prescribed autocorrelation are the canonical hard
combinatorial search family, and this is a case study in what the search left behind versus what
structure explains; (d) the Lean formalization generalizes the instance to a parameterized
theorem, which is exactly the artifact reuse he would compare against; (a) the multiplier-orbit
and automorphism analysis is group-action bookkeeping throughout.

**Why he specifically.** Two things. First, the epistemics: a result announced as an opaque
artifact was decoded, verified, and then generalized into a Lean theorem with the shift as a
free parameter — turning a witness into a statement. That is the same move as turning a
compiled binary back into an IR. Second, the invariant-forcing argument is a clean, small
result about why a naive vertex invariant cannot work and why quadruple correlations are the
first level that can, which made an otherwise stalled graph-automorphism search finish in
seconds. Third, the successor work at order 2092 is deliberately reframed "from a construction
race into **class exclusion**", which is a search-versus-structure stance he would recognize.

**Marked as the snapshot marks it.** "No Legendre pair and no Hadamard matrix of order `668` is
constructed here; existence at order `668` is now settled externally, so the residual census is
of interest only for the Legendre-pair question at length `333`", which remains open. At order
2092, two negatives "are recorded as searches rather than as theorems, and are labelled that
way": an unrestricted campaign of 288 billion mutations never beat a residual of 96, and a
four-norm argument proves that "no congruence of any modulus can ever exclude the surviving
deviation patterns", so only a lattice or counting argument could. "Larger orders were not
computed and nothing is claimed about them." One priority exposure is recorded rather than
resolved, since `333 = 37·3^2` falls inside the length family of a 2026 paper available only at
abstract depth.

**Send or ask.** Send the decode-and-verify account, the Lean parameterized theorem, and the
quadruple-invariant argument. Ask whether he finds the class-exclusion reframing at order 2092
the right response to a search that cannot be beaten by more search — and whether the
four-norm no-congruence result is the kind of "which methods are excluded" statement his NFL
instincts would want stated more generally.

---

### 12. The Klein `E_8` transvectant operator and the minuscule branching `27 = 12 + 15`

**Snapshot section:** "The Klein `E_8` operator programme" and "The `E_6` minuscule
twenty-seven", attached to *The Clebsch Schur--Sarkisov spine* (section 15).

**The result.** On the Kleinian `E_8` invariant ring, a transvectant-derived map "restricts to
a non-`R`-linear differential operator of exact order three and degree `+6` on `R`, whose
complete fourteen-term normal-ordered expression is known and independently replayed". The
Klein `E_8` cubic is intrinsic to it as the radial third-transvectant symbol, and on every
McKay covariant block the full principal symbol uniformly selects the classical `E_8` matrix
factorizations. The operator's graded behaviour is settled in all weights: the global two-sided
defect vanishes for every `n > 52`, with thirteen exact exceptional degrees
`0,1,2,6,10,11,12,20,21,22,32,40,52`, and degree 22 the sole certified full-corner failure.
Separately, "The strongest outward connection is the `A_1 × A_5` minuscule branching
`27 = 12 + 15`": the double-six supplies the twelve lines and the complementary fifteen are
canonically recovered from the unique cubic through those twelve, carrying the exact minuscule
weight dictionary, all forty-five tritangent planes, and the Cartan cubic's mixed-plus-Pfaffian
monomial support.

**Lenses:** (b) exceptional lattices, McKay correspondence, matrix factorizations and
maximal Cohen–Macaulay modules — the singularity-category side of quantum-adjacent algebra;
(a) an explicit weight dictionary for a minuscule representation, which is a representable
symmetry structure of exactly the generalized-tensor kind he described wanting.

**Why he specifically.** The minuscule weight dictionary and the `27 = 12 + 15` branching are
the sort of concrete, fully indexed representation data an IR for generalized tensors would
have to carry, and here they come with a named operator producing them. The McKay side ties
finite subgroups of `SU(2)` to affine root data, which is a symmetry-to-lattice correspondence
he could use as a test case for whether his foundation represents both ends.

**Marked as the snapshot marks it.** "The ordinary MCM lift is only a split identity on `M_4`,
not a new matrix-factorization bridge." On the `E_6` side: "With no cohomological or Higgs
realization, this is a graded Cartan model but **not** a model of that variation", and the exact
full-27 Galois action "is not a monodromy trace-field statement". The marked icosian comparison
"is ruled out: no such comparison exists in the required equivariant category", and
"Identifying the operator algebra and spectrum is the surviving frontier there."

**Send or ask.** Send the minuscule branching and weight dictionary, with the stated boundary
that this is a graded Cartan model and not a model of the geometric variation. Ask whether his
foundation would represent minuscule weight data natively, and whether the row-exchange being
an `A_1` Weyl reflection — explicitly "not Galois conjugation and not the outer automorphism
exchanging `27` and `27^∨`" — is a distinction his type system would keep.

---

## Screened out, one line per section

- **Quadratic trade rigidity and cubic orientation in conic matching quotients (section 2).**
  Deep modular representation theory over `PGL_2` and a field-uniform one-factorization theorem
  for the complete graph on ten vertices, but the objects are matchings of conic points with no
  tensor, quantum, or compilation reading; the strongest crossover, "the conic quotient first
  remembers orientation cubically", is already covered by item 8.
- **Golden descent and operator realizations of the Clebsch cubic (section 3).** Its adopted
  arithmetic and harmonic theorems are about square classes and spherical harmonics on an
  icosahedron; the parts he would care about are the conference-operator material already
  ranked first, and the determinant-versus-permanent boundary already ranked inside it.
- **Minimum-word reconstruction of `PG(2,13)` from a binary conic code (section 4).** Closest
  runner-up: the minimum words of a `[78,36,12]_2` code reconstruct the plane, its conic and its
  polarity from weighted pair data alone, and a hidden `F_8` operator field forces every orbit
  to span — but it is one more instance of the reconstruction pattern item 6 already shows him,
  and its underlying incidence graph is pre-empted as a known semisymmetric graph.
- **The cubic-threefold stabilization programme (section 6).** Genuine headline mathematics —
  `X × P^1` is irrational for every smooth complex cubic threefold, with a Lean companion
  carrying no `sorry` and no compiled-evaluation axiom — but the content is birational geometry
  and quantum cohomology of a variety, not a quantum system; the one part with an IR-shaped
  hook, the exotic `F_4` gluing, is ranked at item 8. Note the older all-`m` manuscript is
  explicitly conditional on two stated hypotheses.
- **Secant defects with prescribed holes: arcs, caps, and matching designs (section 8).**
  Formally verified defect identity and zero-defect rigidity in Lean, which is real artifact
  value, but the mathematics is incidence counting in finite planes with no symmetry, tensor or
  compilation reading he would act on.
- **Integral Secant Distributions and Improved Bounds for Complete `(k,n)`-Arcs (section 9).**
  Integer envelopes whose real relaxation is the classical expander-mixing inequality; the only
  hook is that relaxation, and it is classical.
- **High-Weight Cosets of Generalized and Extended Reed–Solomon Codes (section 10).** Worth one
  sentence to him for a methodological reason rather than its content: two routes to making a
  threshold rigorous are closed by located obstructions, and "**The residual class with trivial
  stabilizer, meeting no stratum at all, is what no stratum-local tool of any kind can
  reach**" — a sharp statement of a method's reach, but embedded in a deep-hole classification
  he has no route into.
- **Ergodis, the compiler the theory licenses (inside section 11).** Excluded by instruction;
  being broadened for him separately. Its benchmark table, the certified infeasibility
  explanation, and the correctness audit's "every advertised check must come with a failing
  control" rule all belong to that track.
- **The compiler as a dynamic decision engine and quantum decoder (inside section 11).** Same
  exclusion; the sparse matching decoder ahead of PyMatching in sixteen of eighteen cells, and
  the certified predecoder that "fails by exactly one unit of margin", are engine results.
- **Structural causal models as a second context language (inside section 11).** Excluded as
  engine work, but flagged: computing the coarsest valid causal abstraction rather than checking
  a proposed one is the item in the whole portfolio closest to his Sanctuary-era interests, and
  if he asks about cognitive architectures this is the one to raise. Its headline economic claim
  failed, for the stated structural reason that hard interventions are idempotent and
  commutative.
- **Frobenius-equivariant pair extension and robust repair of eight-arcs (section 13).**
  Extension criteria and an exact extremal classification in a plane of order 25; no lens
  applies beyond generic finite-geometry symmetry.
- **Semilinear rigidity of four-point-frame continuation graphs (section 14).** An abstract
  graph whose automorphism group is exactly the projective stabilizer of the cap it came from —
  a reconstruction result of the same shape as items 6 and 9 but weaker and, per the snapshot,
  "publication-softened because it meets existing complement and pseudo-complement
  reconstruction literature".
- **Standard Flips of Discrepancy One (section 16).** A short correction note supplying two
  steps another paper's proof chain omits; valuable and released with a DOI, but purely internal
  to Gromov–Witten theory.
- **Brouwer's exceptional exterior sets (section 17).** A bridge between two disjoint
  literatures explaining why the icosahedral group appears exactly twice in a census; charming,
  but the figure itself "is pre-empted by Dye 1991, so the claim is the bridge and not the
  configuration", and both results carry a provisional marker as unvetted.
- **Projective planes of order twelve (section 17).** One line only if he asks about search:
  the exhaustion shows that "**assuming the hyperoval makes the problem harder rather than
  easier**", raising the survivor count rather than lowering it — a counterintuitive
  structure-versus-search datum, but the target case was not reached and no novelty claim is
  made.
- **The exceptional root-system code ladder (section 17).** Explicitly **pre-empted** in three
  layers — level codes are Calderbank–Kantor two-weight codes, the fold is Brouwer–Shult, the
  tower is named in the strongly-regular-graph literature — and closed as a publication route;
  do not send.
- **Complete arcs of square-root size relative to a conic (section 18).** An open construction
  programme whose live signal is twelve nonlinear repair layers at one field order; no global
  nonexistence claim is made anywhere, and there is nothing stable enough to send.
- **The cap game on odd projective planes (section 18).** A combinatorial game reduced to a
  counting inequality with zero counterexamples in 10.9 million exhaustive and 20.7 million
  sampled exchanges and no proof; the Grundy-value framing is search-adjacent but has no Ising
  or IR content, and the smallest field is proved game-semantically dead.

---

## Cross-cutting notes for the conversation

1. **The recurring shape of the whole portfolio is a reconstruction-profile calculus**, and the
   snapshot says so in his vocabulary: "Each sparse shadow recovers a declared carrier up to an
   explicit projective orbit, orientation involution, homogeneous fibre, or marking torsor...
   sparse shadows recover carriers, and their exact fibres measure what was forgotten." If he
   wants one sentence describing what the mathematics is about, that is it, and it is a
   statement about forgetful functors and their fibres.
2. **The five-mode claim ledger** (human structural proof, published theorem, Lean theorem,
   finite certificate, trusted execution) is the portfolio's own provenance type system and is
   the most directly transferable artifact for someone modelling an IR in Lean.
3. **Do not quote the golden conference operator programme without its pre-emption ledger.**
   Five clean pre-emptions bind that section, two close to verbatim; only the operator layer has
   no located predecessor.
4. **Nothing in the portfolio has been published or externally refereed**, per the snapshot's
   opening line, with the single exception of the discrepancy-one correction note, which is
   published locally with a DOI, and the manuscript-only pre-release of the `PG(2,13)` paper at
   `10.5281/zenodo.21783971`.

---

# From papers/summary/README.md

Second screen, same reader profile and lenses, same rules. Source:
`papers/summary/README.md`, read in full (1,144 lines). This is the public-facing portfolio
surface: selected headline results, one research frontier, a table of theorems over infinite
families, a papers-and-entry-points table with public PDF and repository links, abstracts with
non-specialist guides, and a verification philosophy. Hedges below are the README's own,
preserved verbatim.

## 1. Ranked list from the README

### 1. Strength-Two Trades and Transversal Cubic Gates: The Clebsch Cubic-Phase Codes and Their Magic

**README heading:** under *Papers and entry points* and *Further Geometry, Coding Theory, and
Quantum Information Papers*.

**Quoted key sentence.** "Two signed point sets that agree on every quadratic polynomial define
an error-detecting qudit code whose surviving third moment is a transversal logical cubic
phase." The abstract adds: "Conic matchings give error-detecting codes with binary-invariant
logical cubics, while an elementary translation trade supplies the same `[[2p,p−1,2]]_p`
parameters at every prime `p ≥ 5`", and "The ten-qudit example over F₁₁ is not
Clifford-equivalent to a product across any bipartition."

**Lens.** (b) and (e) together, with (f): a magic resource and its transversal gate are both
specified by finite geometry rather than chosen by hand, and the entanglement statement is a
quantified claim across all bipartitions.

**Why him.** This is the portfolio item closest to a quantum-compilation target with a cost
model attached. Magic-state distillation is the dominant overhead in fault-tolerant quantum
computing, and the paper compares joint preparation of a structured block against a specified
independent distillation menu: "for the `[[14,6,2]]₇` conic code joint preparation of the whole
block costs fewer than `16.116` raw inputs per accepted block against lower bounds of `54`, or
`36` when all weighted cubic types have unit cost." Someone who has spent a career on the
classical-versus-quantum resource question will read that as the interesting shape: preparing a
structured object directly beats assembling it from separately purified pieces. It is also the
one place the portfolio produces a *non-Clifford* logical gate, which is exactly what the
snapshot's own no-go census said is hard to get.

**Marked as the README marks it.** The resource comparison is stated with its model boundary
intact: "This comparison assumes independent uniform Z noise, ideal Clifford operations, and
input error at most 1%", and the guide repeats that "it is not an unrestricted protocol lower
bound."

**Send or ask.** This is the first thing to send him. Ask whether the geometric specification of
the logical phase — the same finite data fixing the code, its transversal gate, and its Pauli
spectrum — is the kind of thing his intermediate representation would want to derive rather than
declare.

---

### 2. Hodge Atoms as Occurrence-Indexed Marker Ledgers

**README heading:** under *Papers and entry points* and its own abstract entry.

**Quoted key sentence.** From the abstract: "Expanding the degree of each spectral component
into labelled occurrences, we form the thin groupoid generated by the elementary correspondences
and the free commutative monoid on its connected components. Its universal fold recovers the
Hodge-atom chemical formula, makes the three operation laws formal, and separates the abstract
atom quotient from the generally coarser quotient by isomorphism of geometric atomic
F-bundles."

**Lens.** (a) and (f) — this is the one paper in the portfolio whose method is explicitly
category-theoretic: an informal invariant calculus is reconstructed as the universal fold of a
thin groupoid, after which its operation laws hold formally rather than by inspection.

**Why him.** He described wanting a categorical foundation for an intermediate representation.
This paper is a worked instance of the move he is making: take a calculus people compute with
informally, find the groupoid and the universal property that generate it, and the composition
and operation laws stop being separate lemmas. The README also states the discipline that
matters for an IR: "All quantum-cohomological comparison results enter only through an explicit
provider record", and the guide says the paper "isolates the cited quantum-cohomological
providers from the formal ledger argument". That separation between a formal spine and an
explicit record of what it imports is precisely an interface boundary in a compiler.

**Marked as the README marks it.** The obstruction is deliberately narrow: the effective
quotient is birationally invariant by weak factorization, "and the resulting obstruction is
stated only for one rank-two projective-bundle step."

**Send or ask.** Send the abstract, not the paper, and ask whether "expand into labelled
occurrences, take the thin groupoid, take the universal fold" is a pattern he already has a name
for in his IR design — and whether the abstract-versus-geometric quotient boundary is the same
distinction as a semantic-versus-syntactic equality in his setting.

---

### 3. Balanced Cuts of Conference Matrices: Squared-Spectrum Rigidity and Hermitian Holonomy

**README heading:** under *Selected headline results*, "Order six is the unique nontrivial
cut-rigid symmetric conference order", and its own abstract entry.

**Quoted key sentence.** "We study the exchange spectrum `spec(RRᵀ/q)` and prove that it is
independent of `Y` exactly when `d ≤ 3`. Since the order-two case is trivial and no symmetric
conference matrix of order four exists, order six is the unique nontrivial case; its spectrum is
`{1/5, 4/5, 4/5}`. For the associated diagonal-control transfer, the twenty balanced sign
vectors in `{±1}⁶` are exactly the maximizers of each degree-three Schur sector over `[−1,1]⁶`."

**Lens.** (c) primarily and (b) alongside it. The second sentence is a continuous-relaxation
statement of exactly the kind he built a career around: a degree-three objective is maximized
over the solid cube, and the maximizers are proved to be twenty specific `±1` vertices. That is
the relaxation-is-tight question for a cubic pseudo-Boolean objective, stated and answered
exactly on a structured instance.

**Why him.** Three separate hooks. First, the `±1` optimization above. Second, the fermionic
reading: "We interpret the order-six transfer through a conference interferometer, separating
intrinsic, oriented, and calibrated observables and identifying the external resource required
for direct three-fermion emulation." Third, a clean invariant-theoretic statement he can use
directly: "In arbitrary real dimension, singular values classify unframed port transfers; for
invertible transfers, orientation adds exactly the determinant sign, and the determinant is, up
to scale, the unique minimal-degree orientation-covariant polynomial." That last is a
representability statement about what a port-to-port map can carry, which is an IR question.

**Marked as the README marks it.** The interferometer "is a theory and design-limit analysis,
not a report of a built device", and the guide repeats that "The conference interferometer is an
application of these matrix results."

**Send or ask.** Send this as the second paper. Ask whether the tight-relaxation phenomenon at
order six looks to him like an accident of the exceptional order or an instance of something he
has seen in Ising relaxations, and whether the determinant-as-unique-orientation-carrier
statement is the right primitive for signed transfer in a categorical IR.

---

### 4. Robust Local-Unitary Rigidity of Stabilizer AME States

**README heading:** under *Selected headline results*, "Exact and quantitative AME rigidity",
and in *Highlights*.

**Quoted key sentence.** "Every product-unitary intertwiner between additive stabilizer
`AME(2m,q)` states is Clifford on each party, for prime powers `q` and `m≥2`." The README adds
the algorithmic half the snapshot does not lead with: "The half-set invariant gives
deterministic prime-field recognition in `O(m³+log q)` field operations and exact randomized
witnesses with the same expected cost", and "Complementary marginal tests give optimal uniform
verification gap `(m+1)/(2m)`, also for nonstabilizer AME targets."

**Lens.** (b) perfect tensors as tensor-network cells; (e) stabilizer codes and encoders; and
here also (f), because recognition is reduced to a decidable four-variable test with a stated
cost.

**Why him.** Same reason as in the snapshot screen — the local symmetry group of a perfect
tensor is discrete and exactly Clifford — but the public version is stronger where he would
push: it gives a recognition *algorithm* with a field-operation bound, a certified robustness
radius, and a verification gap that also covers nonstabilizer targets. "In prime dimension,
four-party endomorphism algebras are `M_2(F_q)`, with compatible group `SL_2(q)`; six-party
algebras are nonscalar." A reference implementation is linked.

**Marked as the README marks it.** "The radius is a uniform two-parameter statement; the length
restriction `2m≤2(q²−1)` excludes unbounded fixed-`q` families." And: "The theorems have
manuscript proofs; these tests and the partial formalizations do not constitute end-to-end
formal coverage." "Weighted exact tradeoffs remain stabilizer-specific." The certified radius is
`min{1/(4 sqrt(2q)), 1/(8π sqrt(2m))}` and the local rounding distance is `8ε`.

**Send or ask.** Send the standout-results block rather than the whole abstract. Ask whether a
node-level recognition procedure with a proved operation count is the kind of primitive his IR
would want attached to a tensor type.

---

### 5. Exact Transversal Logical Groups of Quantum MDS–CSS Codes

**README heading:** under *Selected headline results*, "A Schur-square test determines MDS–CSS
transversal groups".

**Quoted key sentence.** "For odd-prime `[2m,m,m+1]q` MDS codes, the code conductor
`Cond(C,C⊥)=(C^(star 2))⊥` has dimension zero or one. Its dimension determines whether the
projective transversal group is `Fq² ⋊ SL₂(q)` or the smaller split-torus branch." The abstract
states it as: "Thus the codimension of the Schur square determines all transversal logical
unitaries."

**Lens.** (e) and (f) — a single linear-algebra dimension decides which group of logical gates
compiles transversally, which is a lowering-legality predicate with a one-line decision
procedure; (a) because the answer is a named group either way.

**Why him.** The Schur square is the coordinatewise (einsum-shaped) product of a code with
itself, so the deciding quantity is computed by the same operation his tensor-logic syntax would
express natively. A zero-or-one dimension count deciding between two named symmetry groups is
about as close to a typed, decidable compilation rule as mathematics of this kind gets. For
length six the criterion becomes geometric: "the nonzero-conductor branch is equivalent to the
six parity-check points lying on a conic."

**Marked as the README marks it.** The classification is for "odd prime fields"; the geometric
applications "are independent of the all-length proof"; and non-Clifford product
implementations are excluded by "an imported rigidity theorem", not by this paper.

**Send or ask.** Send the one-sentence criterion. Ask whether his IR could carry
"codimension of the Schur square" as a derived attribute that gates which gate set is legal.

---

### 6. Exact Compositional Transfer of Bounded Linear Recovery

**README heading:** under *Selected headline results*, "Labelled recovery costs compose, while
equations and minimal repairs have different confinement conditions".

**Quoted key sentence.** From the abstract: "The least helper count alone is insufficient:
composition also requires the functional supplied by each local choice." And: "Equation
confinement and confinement of minimal repairs therefore have different requirements."

**Lens.** (f) and (a) — a compositionality theorem that names exactly which data must survive a
lowering step, plus a separation showing that two conditions people conflate are genuinely
different.

**Why him.** Same argument as in the snapshot screen, but the README states it in interface
language he will recognize immediately: the summary number does not compose, the labelled
functional does, and the two confinement notions have different requirements. The guide says it
outright: "Distinguishing equations, support alternatives, and their minimum costs identifies
which information must survive composition and which locality guarantees preserve the available
repair choices." That sentence is a design rule for an intermediate representation stated as a
theorem about codes.

**Marked as the README marks it.** "The paper-local Lean companion covers only the
associated-pair exact sequence; the confinement and composition results have human proofs and
remain outside its formal coverage."

**Send or ask.** Send the two quoted sentences. Ask what his IR passes across a lowering
boundary today, and whether it has already hit the "the scalar does not compose" failure.

---

### 7. One-Stabilization Irrationality and Hodge Conservation for Fano Threefolds

**README heading:** under *Selected headline results* and *Highlights*.

**Quoted key sentence.** "Every smooth complex cubic threefold remains irrational after
multiplication by `P¹`. More generally, for every smooth complex Fano threefold of Picard rank
one, `X × P¹` is rational if and only if `X` is rational. This covers all seventeen families:
nine remain irrational and eight are rational." The mechanism: "The proof constructs numerical
birational invariants of fourfolds from selected generalized eigenspaces of quantum
multiplication."

**Lens.** (a) weakly and (d) — but the reason to show it to him is methodological: an invariant
built from generalized eigenspaces of an operator, shown to be blind to the contributions of
points, curves and surfaces, and therefore birationally invariant by weak factorization.

**Why him.** The proof strategy is spectral bookkeeping made into an invariant: select
eigenspaces, prove the unwanted centres contribute zero, then a structural theorem (weak
factorization) upgrades the count to an invariant. That is a recognizable engineering pattern —
design the observable so the noise terms vanish identically — and it is the portfolio's clearest
case of a numerical invariant doing geometric work. The all-seventeen-families classification
makes it a complete statement rather than a single example.

**Marked as the README marks it.** The Hodge refinement "gives neither an integral lattice nor a
polarization identification", and "The numerical proof is independent of the Hodge refinement."
"General projective-bundle machinery is confined to optional extensions." The attribution
boundary quotes the paper's own ledger: "Ordinary irrationality, quantum spectral methods and
much of the underlying Fano data are prior work" and "Exact whole-H³ one-stable conservation
priority comparison remains open." Verification: "Exact finite checks and a partial Lean
companion support specified steps... this is not an end-to-end Lean proof."

**Send or ask.** Mention rather than send; the mathematics is far from his areas. If he asks
what the flagship result is, this is it.

---

### 8. Reconstructing Projective Frames from Their Continuation Graphs

**README heading:** under *Selected headline results*, "Pairwise conflicts recover a projective
frame".

**Quoted key sentence.** "For every prime power `q ≥ 13`, the uncoloured continuation graph of a
four-point frame determines `q`, and every graph isomorphism extends uniquely to a semilinear
equivalence of the planes carrying one frame to the other. Recovering tangent traces, their four
centre classes, and the field action also gives polynomial-time recognition over a supplied
field with a checkable coordinate certificate."

**Lens.** (a) a symmetry-and-structure recovery result; (f) with an algorithm and an
independently checkable certificate attached.

**Why him.** The certificate is the interesting part and the README leads with it in a way the
snapshot does not: "The coordinate certificate makes a proposed reconstruction easy to check
independently of how it was found." That is the search-versus-verification asymmetry stated as a
deliverable — the recovery procedure and the checkable witness are separate artifacts, and only
the witness needs trusting. The small-field exceptions are exact rather than approximate:
"extra automorphisms at `q = 5,8` and semilinear rigidity at `q = 7,9,11`."

**Marked as the README marks it.** "The uniform proof is written mathematics; the finite census
is independently replayed computation, and no Lean formalization is claimed." The README title
differs from the snapshot's internal title *Semilinear rigidity of four-point-frame continuation
graphs*.

**Send or ask.** Send only if he asks about certificates. Ask whether his IR would want every
recovery or inference pass to emit a checkable witness separable from the procedure that found
it.

---

### 9. Reconstructing the Clebsch Code from Its Deep-Hole Syndrome Locus, with its computational companion

**README heading:** under *Selected headline results*, "Sparse data recover marked finite
geometry", and in *Clebsch: Rigidity from Sparse Shadows*.

**Quoted key sentence.** "Deep-hole data recover the non-GRS Clebsch code, its conic and
polarity, and a conference matrix up to switching and global negation, with `B² = 5I`; and
eleven is not an arbitrary choice of field, because a Sylvester-graph obstruction in the
computational companion shows that q = 11 is the only field order admitting a conic-filling
six-arc at all." The abstract adds: "The decoder data thus yield incidence, symmetry, the
conference structure, and the integral quadratic order `Z[B] ≃ Z[√5]`."

**Lens.** (a) a symmetry group and an arithmetic order recovered from decoding failures; (e) the
input is coding data.

**Why him.** The framing the README gives is the one he would find memorable and it is stated
plainly in the guide: the audience is "researchers interested in inverse problems or in what can
be learned from failures", and "Error-pattern data can expose a code's underlying geometry even
when the code is not given directly." The uniform consequence is a clean quantified rule: "any
k-arc whose uncovered locus is a nonsingular conic has q odd and `2k − 3 ≤ q ≤ (k(k − 1) + 3)/3`,
so for each fixed k the all-field conic-filling existence problem reduces to finitely many field
orders."

**Marked as the README marks it.** The companion is "housed in the `clebsch-rigidity`
repository rather than in a separate public mirror", and "separates structural arguments from
exhaustive checks and makes delicate finite claims inspectable", with "exact replay routes and a
claim-by-claim trust ledger".

**Send or ask.** Send the one-sentence framing about learning geometry from decoding failures.
Ask nothing; this is context, not a request.

---

### 10. Integral Cohomology and Modular Decomposition for the Theta Divisor of a Cubic Threefold

**README heading:** under *Selected headline results*, "Integral and modular decomposition for
the cubic-threefold theta divisor".

**Quoted key sentence.** "For the theta divisor of every smooth complex cubic threefold, the
integral middle lattice is free of rank `130` with Lefschetz saturation quotient `(Z/2)^10`."
And: "The same factor three makes relative hard Lefschetz fail modulo three, while an
infinite-order Fano class lifts the local order-three link class."

**Lens.** (a) and (b) — an explicit integral lattice with a named finite glue group, plus a
small-prime failure of a structural theorem that normally holds.

**Why him.** The interesting content for a non-specialist is the shape: a theorem that usually
holds fails at exactly one small prime, and the failure is traced to a single integral factor of
three in a resolution complex. That is a localized-obstruction story, and the integral lattice
with its `(Z/2)^10` glue is concrete finite data of the kind his IR would represent. It also
pairs with item 8 of the snapshot screen, where a different small-prime gluing (`F_4` at the
prime two) carries the orientation torsor.

**Marked as the README marks it.** The priority boundary quotes the paper's claim ledger —
"cubic-theta integral object and central Smith factor retained", "canonical `delta_0`--`IC`--
`delta_0` filtration and both nonsplit extensions retained", "explicit multiplier three and
failure over `F_3` retained" — and notes that "The manuscript separately credits the general
rational intersection-form, modular rank, and small-extension frameworks on which the
example-specific calculation sits."

**Send or ask.** Do not send. Mention only if small-prime obstructions come up.

---

## 2. Comparison with the snapshot ranking

### Where the two agree

Four items are in both top lists, and the agreement is close to exact.

- **Stabilizer AME local-unitary rigidity** is item 2 in the snapshot screen and item 4 here.
  Both state the same theorem with the same generality and the same sharp `m=1` boundary.
- **Exact compositional transfer of bounded linear recovery** is item 4 in the snapshot screen
  and item 6 here; both lead with the fact that a scalar cost does not compose and the labelled
  functional does.
- **The Clebsch deep-hole reconstruction** is item 6 in the snapshot screen and item 9 here.
- **The conference-matrix material** appears as item 1 in the snapshot screen, where it is an
  unpublished source programme, and as item 3 here, where a bounded slice of it is a finished
  public paper.

### Where the README states something more strongly than the snapshot

- **Fano threefolds.** The snapshot's headline is that `X × P¹` is irrational for every smooth
  complex cubic threefold, extended to genus-eight prime Fano threefolds by Kuznetsov's
  correspondence. The README states a strictly larger theorem: "for every smooth complex Fano
  threefold of Picard rank one, `X × P¹` is rational if and only if `X` is rational. This covers
  all seventeen families: nine remain irrational and eight are rational", plus a Hodge
  conservation theorem, a cancellation statement for a very general cubic or quartic, and an
  extension of the exponent count to additive homomorphisms on `K₀(Var_C)/(L − 1)`. The stated
  mechanism also differs: the snapshot describes an "atomic route" through a Hodge-atom package
  with atomic residue discriminant `4/9`, while the README describes "two counts on whole quantum
  primary factors: canonical rank-two residues and full odd dimension in even rank three". These
  are not obviously the same proof as described, and the README's version is the later one.
- **The Clebsch field-order uniqueness.** The README asserts flatly, in the infinite-families
  table, "`q = 11` is the only field order admitting a conic-filling six-arc" with quantifier
  range "Every field order", attributed to the computational companion via "a Sylvester-graph
  obstruction". The snapshot proves the six-arc case within its through-eight-points sieve but
  does not name a Sylvester-graph obstruction anywhere in that argument — it invokes that graph
  only in the unrelated order-ten conference setting. The claims are compatible in content; the
  stated mechanisms differ, and that is worth reconciling before either is quoted to him.
- **The transversal cubic phase gate.** The snapshot lists this as an open question: "The
  highest-value open quantum test is whether the exact square/cube Schur algebra produces a
  transversal non-Clifford phase on the two jet qudits." The README has a finished paper with
  the gate constructed, an infinite family `[[2p,p−1,2]]_p` at every prime `p ≥ 5`, and a
  preparation-cost comparison. This is the single largest positive delta between the two
  documents.
- **AME recognition.** The README carries a deterministic prime-field recognition procedure with
  an `O(m³+log q)` operation bound, an optimal uniform verification gap `(m+1)/(2m)`, and a
  linked reference implementation. The snapshot does not lead with any of this.

### Where the README is more cautious than the snapshot

- **Research frontiers.** The snapshot devotes long passages to open programmes — the cap game,
  square-root complete arcs, the nonsaturated conic-filling branch, the cubic-threefold parity
  crown, the Reed–Solomon threshold conjecture. The README exposes exactly one frontier item,
  framed monodromy, and says of it: "Its blow-up formulas and birational invariance through
  dimension four depend on explicit reconstruction-tail and residual divisor-tagging
  hypotheses." The public surface is deliberately narrow about what is unfinished.
- **AME robustness.** The README adds a restriction the snapshot does not state: "the length
  restriction `2m≤2(q²−1)` excludes unbounded fixed-`q` families", and gives the rounding
  distance as `8ε` with a two-parameter certified radius rather than the snapshot's
  `2√2 q² ε` form.
- **Reed–Solomon deep holes.** The README confines itself to the classification in an explicit
  field range with the characteristic caveat "odd characteristic and in characteristic two for
  `r ≥ 8`", and notes "R8–R10 remain companion records rather than claims of the submission."
  The snapshot additionally discusses the sharpened conjecture with threshold sixteen, the three
  falsified predecessor conjectures, and the two closed routes to rigour. None of that is public.
- **Verification.** Every README paper entry states its formal boundary explicitly and none
  claims end-to-end coverage; the snapshot is comparably careful but states the boundaries in
  running prose rather than as a per-paper field.

### README items with no snapshot counterpart

- **Hodge Atoms as Occurrence-Indexed Marker Ledgers** — the categorical paper, item 2 above.
  Nothing in the snapshot corresponds to it. For his interests this is the most important
  omission from the internal document.
- **Integral Cohomology and Modular Decomposition for the Theta Divisor of a Cubic Threefold** —
  a full paper with a DOI, rank-130 lattice and mod-three Loewy chain, absent from the snapshot.
- **Strength-Two Trades and Transversal Cubic Gates** — present in the snapshot only as a named
  open question, as noted above.
- **Exact Transversal Logical Groups of Quantum MDS–CSS Codes** — the snapshot treats the
  transversal-group material as a half of the AME paper that "now stands alone"; the README gives
  it as a separate paper with the Schur-square conductor test as its headline, which is a
  sharper and more usable statement than anything in the snapshot.
- **Balanced Cuts of Conference Matrices** — the snapshot has the underlying mathematics inside
  the operator source programme but does not record that a standalone paper exists, nor the
  cut-independence classification as its headline.

### Snapshot items with no README counterpart

Most of the snapshot screen's top twelve are not on the public surface at all: the golden
conference operator programme as a whole (only its balanced-cut slice is public), the exact
quantum-code distance computations and the encoding-symmetry result, the certified no-go for
diagonal transversal non-Clifford gates, the Clebsch Schur–Sarkisov spine, the golden
orientation torsor as the exotic `F_4` gluing torsor (partly public, inside *Chordal and
Conference Cubics*), the Gram–discriminant coloring and its reconstruction dichotomy, the
two-graph query complexity, the Hadamard order-668 decoding and the order-2092 class exclusions,
and the Klein `E_8` operator programme. If the conversation with him goes past the public
papers, everything in the first screen is material he cannot look up.

### Two inconsistencies to raise before sending anything

1. **The README quotes a retracted benchmark number.** Its research-software section says of
   ergodis: "The recorded gains range from `8x` to `344,300x`; the largest comparison isolates
   the theorem-driven compositional reduction." The snapshot states the opposite: "Two earlier
   headline ratios were **retracted** rather than softened when the protocol was corrected: a
   344,300x tower figure and a 432x Hamming figure are not supported and should not be quoted."
   The public surface currently quotes a figure the internal record says must not be quoted.
   This is ergodis material, which is out of scope for this screen, but it sits on the page that
   would be sent to him and should be fixed before that page is sent to anyone.
2. **A DOI mismatch on the `PG(2,13)` paper.** The snapshot records the pre-release at
   `10.5281/zenodo.21783971`; the README's entry for *Reconstructing PG(2,13), Its Conic, and
   Polarity from the Minimum Words of a Binary Conic Code* shows `10.5281/zenodo.21783970`.
   One of the two is wrong, or they refer to different deposit records.

## 3. Which entry points to actually send him

Send two papers, not a list.

1. **Strength-Two Trades and Transversal Cubic Gates: The Clebsch Cubic-Phase Codes and Their
   Magic** — repository `tavisrudd/clebsch-cubic-phase`, concept DOI
   `10.5281/zenodo.22666172`. This is the right first paper: quantum codes, transversal gates,
   magic resources, an explicit preparation-cost comparison with its model boundary stated, and
   an entanglement statement across every bipartition. It is the portfolio item whose subject
   matter he has the most direct professional history with, and it does not require any finite
   geometry to appreciate the headline.
2. **Balanced Cuts of Conference Matrices: Squared-Spectrum Rigidity and Hermitian Holonomy** —
   repository `tavisrudd/conference-cut-spectra`, DOI `10.5281/zenodo.21766747`. The right
   second paper: `±1` matrices, an exactly-tight cubic optimization over the cube, a fermionic
   interferometer reading, and the determinant-as-unique-orientation-carrier statement. The
   README's own audience line for it names "matrix theorists, algebraic combinatorialists, frame
   theorists, mathematical physicists, and quantum-information researchers", which is the closest
   the portfolio comes to describing him.

Hold in reserve, to send only if he asks for the method rather than the results:
**Hodge Atoms as Occurrence-Indexed Marker Ledgers** (`tavisrudd/hodge-atom-marker-ledger`, DOI
`10.5281/zenodo.22036390`). It is the categorical paper and therefore the closest match to what
he said he is building, but its subject matter is Hodge theory and quantum cohomology, so it
should be offered as "here is the shape of the argument", not as reading.

Do not open with the README itself. It is a long public index whose framing — reconstruction,
rigidity and rationality in geometry and coding — buries the two papers he would actually read,
and it currently carries the retracted benchmark figure noted above. Send the two PDFs with one
sentence each, and keep the README link as the follow-on.

## 4. Is the verification philosophy the artifact for his Lean modelling

Yes — it is short, it is the right kind of artifact, and it is the one piece of the README to
show him unprompted given that he is modelling his intermediate representation in Lean.

The section states five evidence modes: "1. an ordinary prose proof; 2. a cited result checked
against its hypotheses and conventions; 3. a Lean kernel-checked component; 4. a
certificate-checked finite computation; or 5. a trusted program execution or symbolic
experiment."

The load-bearing sentence, and the reason to show it to him, is the next one:

> "These categories support one another but do not collapse into one another. A certificate
> checks an output, not necessarily search completeness; Lean checks the formal statement, not
> automatically its correspondence with prose; and a computation can discover a pattern without
> proving it."

"Lean checks the formal statement, not automatically its correspondence with prose" is exactly
the trust boundary anyone formalizing an intermediate representation has to confront: the
kernel guarantees the theorem you wrote, not that the theorem you wrote is the one your compiler
means. Someone modelling an IR in Lean will hit that gap at the point where the formal semantics
must be shown to agree with the implementation, and this is a working programme that has already
named the gap and built a convention around it rather than papering over it.

Two supporting points to mention with it. First, the framing sentence is "Verification is
claim-level, not a single project-wide badge. A paper may use several evidence modes at once" —
per-claim provenance rather than a per-project seal, which is the right granularity for a
compiler where different passes carry different guarantees. Second, the status block at the top
of the README applies the same discipline to the whole portfolio: "These manuscripts have not
been externally refereed. Each paper is intended to stand on its own mathematically.
Verification is claim-specific and generally not end-to-end. Each repository distinguishes prose
proofs, cited inputs, kernel-checked formalizations, certificate-checked computations, and
trusted executions."

The section routes onward to `VERIFICATION.md` for "the paper-level evidence maps"; that file
was not read for this screen and should be checked before it is offered to him as a worked
example rather than as a statement of policy.
