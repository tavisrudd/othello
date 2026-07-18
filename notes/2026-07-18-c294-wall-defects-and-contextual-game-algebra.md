# C294 reframing after the recursive-mirror obstruction: wall defects and contextual game algebra

**Date:** 2026-07-18
**Lane:** `crowns`
**Status:** research synthesis and next-attack specification. This note proves no new theorem and
introduces no new computational evidence.

## Executive diagnosis

The immediate C294 obstruction changes the object that silver should study. The missing ingredient
is not another vertex response or a more permissive automorphism search. It is the correct state
space.

The mixed `PGL2` Cayley scar has a right-regular mirror whose adjacency defect is localized to an
involution-centralizer coset. The first recursive idea was to answer ordinary moves by the mirror
and, after a defect move, restore some fixed-point-free involutory automorphism of the follower.
The exact `(2,4,5)` `PGL2(5)` obstruction closes that language for both root involution classes:
after an adversarial sequence of legal mirror rounds, a defect move has no response leaving any
fixed-point-free involutory automorphism at all. The obstruction permits arbitrary abstract
automorphisms, not merely colour-preserving right translations.

The correct conclusion is therefore:

> A defect move creates an asymmetric boundary state that must propagate through the game. It
> cannot be required to disappear after the same response.

The strongest candidate replacement is a contextual game algebra of boundary words on the
alternating dihedral backbones. The bulk mirror should cancel histories or contextual components,
while the surviving wall defect is carried as a small dynamical state until it closes, splits off a
direct base, or annihilates with another defect.

This reframing is promising but conjectural. The seven hard `PGL2(5)` root values remain unknown,
so C294 must determine the theorem before committing to a uniform P-strategy.

## What is still missing locally

### The outcome conjecture has not been established

The twelve mixed full `PGL2(5)` generator types include five with a two-ply abstract-pairing P
certificate and seven without one. The latter seven have deliberately unevaluated root values.
This is the first logical gap.

It is unsafe to continue searching exclusively for P-strategies. If one of the seven roots is N,
then the odd-subfield Cayley scar does not uniformly vanish. Silver would instead need its exact
nimber and the descent formula would combine it by xor with the definition-field residual.

The first mandatory computation is therefore an exact structural evaluation of all twelve mixed
`PGL2(5)` Cayley types, preferably their full nimbers. It should use the alternating-backbone
decomposition or another explicit quotient, not an unstructured 120-vertex game-tree census.

### The obstruction states are not yet mathematical objects

The current certificate records canonical induced-graph masks with 100 or 58 live vertices. Those
masks prove the automorphism obstruction, but they conceal the state geometry. A nearly discrete
stable-colour partition can arise because a few holes anchor cyclic coordinates; it does not show
that the state has high descriptive complexity.

Each obstruction path should be rewritten in coordinates

\[
K\backslash H/C,
\qquad K=\langle b,c\rangle,
\qquad C=C_H(z),
\]

with a cyclic coordinate on every two-colour dihedral backbone. For every move and response, record:

- the backbone and cyclic coordinate of each deleted vertex;
- intersection with, and distance from, the centralizer wall;
- the live intervals and exposed endpoints on paired backbones;
- third-matching connections between those endpoints; and
- the number of genuinely open boundary components.

The decisive discriminator is frontier growth. If the number of boundary components remains
bounded as the field and backbone lengths grow, a finite-state transfer remains credible. If it
grows linearly, the proposed compression is probably not the silver mechanism.

## The chamber-system and wall-defect framing

The regular Cayley graph of three involutions is naturally a three-coloured chamber system. Its
two-colour alternating cycles are rank-two residues, with lengths controlled by pair-product
orders. The group is a quotient of the corresponding three-involution triangle group, with
additional relations carrying the full trace/conjugacy data.

Under this interpretation:

- a right-regular involution is a reflection-like symmetry;
- its adjacency-defect centralizer coset is a wall;
- the two-colour backbones are residues crossing or running along that wall; and
- a defect move creates a domain-wall excitation rather than merely breaking a pairing.

The local questions become dynamical:

1. How does the defect propagate along alternating residues?
2. Is there a conserved charge, such as orientation, determinant colour, endpoint parity, or
   boundary-pairing type?
3. Can two defects annihilate or close into a direct finite base?
4. Are the scattering rules independent of the total backbone length?
5. Which full trace or triangle-group relation distinguishes types with the same sorted
   pair-product orders?

The last question is already load-bearing: distinct `PGL2(5)` conjugacy types can share the same
sorted pair-product orders. A successful uniform state therefore needs more than the three orders;
the missing coordinate is likely a trace, cross-ratio, or full triangle-group quotient invariant
controlling the twist of the third matching.

## The game-tree rather than vertex-automorphism object

Node--Kayles is normal play on the independence complex of the residual graph. A history is a chain
of independent sets, and a second-player strategy pairs opponent extensions with legal response
extensions. A fixed vertex involution is only one especially rigid way to construct such a
history-level matching.

The recent obstruction says that no new fixed-point-free vertex involution exists after certain
defect responses. It does not rule out a structured matching of histories, a correspondence between
different follower states, or contextual nimber cancellation.

A useful target is therefore a prefix-compatible matching on the game tree which is equivariant
away from the centralizer wall. The bulk histories are matched by the old mirror; the unmatched or
critical histories form a smaller boundary game. This resembles an equivariant discrete-Morse
matching on the independence complex, but ordinary homotopy equivalence is not enough: the matching
must be causal, meaning that every prescribed response is legal after the actual history.

This viewpoint explains why stable-colour asymmetry of a follower need not be fatal. The strategy
can remain algebraic even when the current graph has no nontrivial automorphism.

## Contextual boundary equivalence

The precise value-preserving object should be a category of coloured boundaried graphs obtained by
cutting the alternating backbones. For two pieces with the same boundary type, define contextual
equivalence by

\[
X\equiv_{\partial}Y
\quad\Longleftrightarrow\quad
\mathcal G(X\mathbin{\mathrm{glue}}Z)
=\mathcal G(Y\mathbin{\mathrm{glue}}Z)
\quad\text{for every admissible context }Z.
\]

This is the game-theoretic analogue of a Myhill--Nerode or transfer-matrix state. Unlike spectra,
orbit counts, or coherent-configuration data, it builds value preservation into the definition.

The generating operations should include:

- extending an alternating path;
- closing a path into a cycle;
- adding the third-generator matching;
- deleting a closed neighbourhood;
- gluing paired boundary endpoints; and
- disjoint union, evaluated by nimber xor.

The principal structural question is whether the C294 fragments generate a finite, finitely
presented, or eventually periodic quotient under these operations. A finite P/N quotient could be
enough for silver even if the full nimber quotient is infinite. If the mixed subfield scar has
nonzero nimbers, however, the descent formula may force the stronger signature.

The computation should discover and minimize this contextual automaton; the theorem should then
prove its local relations. A small transition table would be a conceptual result. A larger table of
root values would not.

## Double-coset and diagram-algebra coordinates

For a chosen two-colour subgroup `K=<b,c>` and mirror centralizer `C=C_H(z)`, the interaction of
backbones with the wall is controlled by the double-coset geometry `K\H/C`. It should determine:

- which backbones meet the defect coset;
- how many wall vertices each contains;
- how right multiplication pairs backbones;
- how the third matching transports cyclic coordinates; and
- how a closed-neighbourhood deletion changes the exposed boundary.

This may have a Hecke- or diagram-algebra shadow. Such linear or spectral data are not themselves
game-value quotients, but they may supply the finite combinatorial skeleton on which contextual
equivalence is imposed. The natural diagrammatic state is a collection of cut intervals and paired
endpoints. A defect move creates an open strand; later moves propagate, join, or close strands.

The useful physical metaphor is a domain wall or quasiparticle:

- the mirror-symmetric state is the vacuum;
- a defect exchange creates an excitation;
- ordinary mirror play transports or shortens the surrounding bulk;
- a boundary response moves the excitation according to local scattering rules; and
- a finite direct base evaluates a closed excitation.

This metaphor counts only if it yields a finite boundary word and exact local transition theorem.

## Recommended next attack

### Phase 1: determine the finite theorem

1. Compute the exact nimbers of all twelve mixed `PGL2(5)` Cayley types by a solver organized over
   alternating backbones.
2. Produce compact strategy or outcome certificates for the seven currently obstructed types.
3. Decide whether the correct uniform target is scar nimber zero, a finite nimber classification,
   or a P/N rule depending on trace/order data.

### Phase 2: expose the boundary state

1. Decode both certified recursive-mirror obstruction paths into backbone and double-coset
   coordinates.
2. Canonicalize the resulting cut-boundary words independently of the 120-vertex labels.
3. Measure frontier size and enumerate local transition types.
4. Use the `(2,3,4)` `PGL2(3)` P graph as the first direct closed-boundary base.

### Phase 3: construct the contextual quotient

1. Define the admissible boundary interfaces and gluing operation.
2. Compute contextual P/N or nimber signatures for the q=3 and q=5 fragments.
3. Minimize the transition system and identify candidate local relations, conserved charges, and
   eventual periodicities.
4. Prove a causal history-matching or equivalent value-preserving transfer for those relations.
5. Test the resulting rule on all seven q=5 falsification gates before extrapolating.

### Phase 4: reconnect to the infinite theorem

1. Express the boundary relations in pair-trace, determinant-class, and definition-field data.
2. Extend from regular subfield scars to the full-group third-matching recursion.
3. Isolate bounded exceptional triangle/trace types for direct certificates.
4. Only after the deterministic value theorem exists, use algebraic point counting or C210-style
   exceptional-locus analysis for abundance or transfer questions.

## Falsifiers and stop conditions

This route should be abandoned or sharply narrowed if any of the following occurs:

- the seven q=5 types have outcomes incompatible with a common boundary rule;
- the number of open boundary components grows without bound under ordinary mirror play;
- contextual signatures proliferate with backbone length without periodicity or finite relations;
- the third matching requires full group-element labels rather than bounded trace/double-coset
  data; or
- a proposed boundary equivalence preserves spectra or isomorphism types but fails a direct nimber
  gluing test.

Conversely, the strongest positive signal would be a small minimized boundary automaton that
classifies all q=3 and q=5 types and whose transitions depend only on explicit trace/order data.

## Contribution to the larger crowns program

This framing gives Crown I and Crown II a genuine potential interface. The hoped-for chain becomes

```text
continuation object
    -> intrinsic coloured matching / repair-port decomposition
    -> chamber system with centralizer walls
    -> contextual boundary-game signature
    -> exact P/N outcome or nimber.
```

Crown II would reconstruct the coloured matching and incidence data. Crown I would evaluate the
resulting boundary signature. Crown III would then be a factorization theorem rather than the
juxtaposition of independent reconstruction and value results.

The C210 common conic-matching synthesis fits in a supporting, not value-determining, role. Its
dead-set and repeated-hit accounting may bound how much geometric boundary is created or classify
the exceptional wall loci. It cannot determine mex directly. It should enter after a deterministic
boundary transition is stated, either to control frontier size or to prove that bad trace loci are
small.

The complete-ports interpretation supplies the same interface from coding theory: a family of
centres superposes pointed repair matchings on one helper set, and the boundary word measures
multi-target interference. Contextual game equivalence is the additional structure needed to turn
that shared carrier into a value theorem.

## Strongest current conjectural framing

The most credible high-level conjecture is:

> The mixed `PGL2` Cayley scar is governed by propagation and annihilation of a bounded wall defect
> in a contextual game algebra of alternating dihedral backbones. Its value is not controlled by a
> restored graph automorphism, but by a finite or eventually periodic boundary signature derived
> from double-coset and trace data.

The immediate risk is equally important: the boundary signature may grow without bound, or the
hard q=5 roots may already exhibit several nonzero nimbers. Either outcome would show that silver
at three centres needs a different scope. Determining that boundary is now more important than
inventing another mirror certificate.

## Source map and evidence boundary

This synthesis uses the following established local records:

- `notes/2026-07-17-c294-silver-attack.md` — odd-subfield decomposition and the regular Cayley scar;
- `notes/2026-07-17-c294-mixed-scar-obstruction.md` — colour-preserving rigidity and q=3,5 gates;
- `notes/2026-07-17-c294-recursive-defective-mirror.md` — exact obstruction to immediate arbitrary
  involution restoration;
- `notes/2026-07-17-c294-full-conic-continuation-crown.md` — full-group bronze family and Dickson
  boundary; and
- `notes/2026-07-18-c210-observations-and-synthesis-after-ansatz-failure.md` — common conic-matching,
  repair-port, and dead-set/redundancy synthesis.

The exact q=3 and q=5 statements above are inherited from those checked bundles. The chamber,
history-matching, contextual-algebra, double-coset, and domain-wall proposals are SYNTHESIS/OPEN.
They are an attack specification, not a theorem claim.
