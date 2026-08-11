# Paper V and epilogue plan: third red team after Paper IV integration

**Lane:** `clebsch`

**Date:** 2026-08-11

**Scope:** hostile review of the revised publication architecture after adding
Paper IV's hidden-field torsor. No manuscript, Lean, mirror, or release edit.

## Verdict

**Conditional GO, with one crown-level gate and three scope corrections.**

The new architecture is better than the version in which Paper IV was merely
an independent box in the series diagram. The residual cyclic marking is a
real shared structure:

- Paper IV reconstructs a Frobenius orbit in its hidden \(\mathbf F_8\)
  commutant;
- Paper V reconstructs the upper golden-orientation \(C_2\)-torsor;
- the epilogue can compare that upper torsor with the Frobenius-conjugate
  exotic gluing pair in \(\mathbf F_4\).

This improves the series narrative and gives Paper IV a legitimate role.
It does **not** strengthen the successor's main separation theorem, and it
must not be advertised as a geometric bridge from the conic plane to the cubic.

The crown-level gate is sharper than “both sets have two elements.” One must
construct an **intrinsically normalized natural isomorphism**

\[
\mathscr O_{\mathrm{gold}}\simeq\mathscr E_{\mathrm{ex}}
\]

of \(C_2\)-torsors. Equivariance alone does not choose it: there are two
equivariant isomorphisms between two free \(C_2\)-torsors. If the normalization
is only a coordinate convention, the epilogue may still choose an exotic
sheet, but it cannot claim that Paper V's recovered orientation canonically
selects that sheet.

## What is now structurally right

### 1. Geometry and descent are separated

There is no direct Paper IV-to-cubic geometry. Indeed
\(|\operatorname{PGL}_2(13)|=2184\) is not divisible by five, so no hidden
\(A_5\) subgroup can mediate such an arrow. The lower conic-plane theorem and
the upper six-axis theorem remain different reconstructions.

Their common feature is instead the residual marking left after the carrier is
recovered. This is precise enough to be mathematical and weak enough to avoid
inventing a common shadow functor.

### 2. The false arithmetic bridge has been removed

The integral golden order cannot simply be reduced modulo two to obtain
\(\mathbf F_4\):

\[
t^2-5\equiv(t+1)^2\pmod2.
\]

The required comparison is between torsors carrying identified outer actions,
not between these rings. This correction is load-bearing.

### 3. Paper V stays structural

The added theorem is a two-row synthesis of residual cyclic markings, not an
integral or Hodge-theoretic construction. Paper V can still contain only
groupoids, natural transformations, stabilizers, multiplicity-one arguments,
and finite torsors. The integral envelope, \(\mathbf F_4\) heart, polarization,
and cubic realization stay in the epilogue.

### 4. Paper IV becomes relevant without being colonized

A one-page corollary extracting
\(\{\alpha,\alpha^2,\alpha^4\}\) as a Frobenius \(C_3\)-torsor is a natural
reframing of the existing hidden-field theorem. It improves the conclusion of
Paper IV without changing its abstract or turning it into infrastructure for a
future cubic theorem.

## Fatal or major mathematical risks

### F1. The normalization of the \(C_2\)-torsor map is not yet a theorem

The common outer \(C_2\)-action proves that any chosen comparison propagates
equivariantly; it does not supply the initial comparison. The epilogue needs a
human, invariant normalization, for example a sign or incidence functional
defined simultaneously from the marked golden plane and the exotic graph
form. A statement that “one normalized representative is checked” is adequate
only if the normalization is itself intrinsic and functorial under the carrier
groupoid.

**Kill criterion:** if no such invariant is found, retain the two torsors and
choose a sheet by convention, but delete every claim that the reconstructed
golden orientation canonically selects the exotic cubic sheet. The main
\(CH_0\)/irrationality theorem may survive; the strongest series-punchline
claim does not.

### M1. “Frobenius--Schur descent” must be formulated accurately

For the finite-field module, the endomorphism division algebra is a finite
field. The clean proof should start from the irreducible \(\mathbf F_2G\)-module
and its endomorphism field, then describe the scalar-extension constituents
through the embeddings of that field. It should not silently use semisimplicity
of the whole modular representation category.

Also, \(\{\alpha,\alpha^2,\alpha^4\}\) is the Frobenius orbit of the recovered
operator. It is not necessarily the set of all field generators: \(\mathbf
F_8\) has more than one Frobenius orbit of primitive elements. The revised plan
now uses “Frobenius-orbit torsor.”

### M2. The Paper IV toric labeling is not yet licensed

The printed Gram tuple

\[
(A_9,A_9,A_{12},A_{10})
\]

does not by itself identify which \(N_i\) is octahedral and which three are
toric. The desired sentence that the three toric families realize
\(\alpha,\alpha^2,\alpha^4\) requires an exact orbit-label check. The repeated
\(A_9\) is not an error; it is the evidence that the scalar packet alone does
not determine geometric type.

**Fallback:** if the toric labeling does not admit a short structural proof,
omit it. The hidden-field Frobenius orbit still gives the residual torsor.

### M3. The shared lemma is standard infrastructure, not a new crown

The commutant-field descent is a short application of Schur descent over a
finite field. It should unify notation and remove certificates, but it should
not be sold as a major new theorem. The successor's high-venue strength still
comes from:

1. the canonical integral envelope and exotic period realization;
2. primitive minimal-class algebraicity and universal \(CH_0\)-triviality;
3. the self-contained sixth-root obstruction proving irrationality after one
   stabilization.

The torsor synthesis upgrades causality and exposition, not the main theorem's
external mathematical strength.

## Publication and dependency risks

### 1. Avoid circular citation order

The clean order is Paper IV, then Paper V, then the epilogue. Paper IV should
not cite a theorem of V. V may cite the concrete hidden-field result of IV.
The epilogue should reprove the short general descent lemma so that it remains
standalone, while citing IV as the degree-three model.

### 2. Keep the Lean burden proportional

All numbered papers have a strict formalization standard. Adding only a
corollary to Paper IV should reuse its existing hidden-field proof. Moving the
general modular representation theorem into IV could create a new formal
dependency disproportionate to one page of exposition. Unless the proof is
already essentially present, the general theorem belongs to the epilogue.

### 3. Do not inflate abstracts

Paper IV's abstract should remain about the code, plane, conic, and polarity.
Paper V's abstract may say that the series reconstructs residual cyclic
markings, but should not mention \(\mathbf F_4\), cubic periods, or universal
\(CH_0\)-triviality. The epilogue abstract should not enumerate the four prior
papers.

### 4. Page budgets remain credible

- Paper IV: about 16 pages, at most 17.
- Paper V: 18--24 pages after the two-page residual-marking synthesis.
- Epilogue: approximately 46--57 pages; the torsor proof adds at most two pages.

If the Paper IV insertion or V synthesis exceeds these bounds, the authors are
proving infrastructure in the wrong paper.

## Structural-proof acceptance tests

Before any manuscript edit, require all of the following.

1. **Paper IV orbit test.** Label the four minimum-word orbit families and
   decide whether the three toric Gram operators are precisely the recovered
   Frobenius orbit. Record a fallback that omits the claim if not.
2. **Correct descent lemma.** Prove the finite-field commutant statement without
   an illicit modular semisimplicity assumption and without calling one
   Frobenius orbit all generators.
3. **Normalizer identification.** Identify the upper orientation involution
   and the exotic Frobenius involution as actions of the same outer-normalizer
   quotient on the same abstract six-set envelope.
4. **Intrinsic calibration.** Exhibit a groupoid-natural invariant selecting
   one golden/exotic pair. A bare coordinate declaration does not pass.
5. **No certificate dependency.** Replace hidden-field and torsor claims by
   Schur descent, stabilizer arguments, and one human normalization. A finite
   computation may remain discovery evidence but not a load-bearing proof.
6. **No false geometric arrow.** No statement maps the Paper IV conic plane,
   its \(\operatorname{PGL}_2(13)\)-action, or its four orbit families into the
   \(A_5\)-cubic geometry.
7. **No false master field.** Do not introduce \(\mathbf F_{64}\) merely as the
   compositum of \(\mathbf F_4\) and \(\mathbf F_8\).
8. **Submission DAG.** Paper IV depends only on its present sources; V depends
   on I--IV; the epilogue redefines its carrier and is logically standalone.

## Effect on the series and the successor

### Series

The upgrade is real and moderately large. The five papers no longer end with
“three branches agree and a fourth is parallel.” They end with a two-level
statement:

1. sparse shadows recover carriers;
2. they also recover the finite cyclic torsors measuring the last scalar,
   orientation, or sheet ambiguity.

That is a better conclusion to a reconstruction series.

### Individual papers

- **Paper IV:** small-to-medium upgrade; its hidden \(\mathbf F_8\) becomes a
  conceptual conclusion rather than a striking appendix fact.
- **Paper V:** medium-to-large upgrade; it synthesizes the entire numbered
  series while remaining structural.
- **Epilogue:** medium narrative upgrade; Paper V's orientation becomes a
  candidate causal selector of the exotic sheet. The main theorem itself is
  not strengthened.
- **Papers I--III:** small retrospective upgrade; their recovered markings now
  feed a named structural principle.

### Annals shape

This integration makes the epilogue read more like the payoff of the series,
but it cannot manufacture Annals strength. The successor is Annals-shaped only
if the integral-envelope, strong period-image, primitive minimal-class, and
sixth-root weak-factorization theorems all land. If the intrinsic \(C_2\)
calibration also lands, it substantially improves the “why these cubics?”
story. If it fails, the successor can still be a strong standalone
Inventiones/JAMS-level separation theorem, but its relation to the series is
provenance rather than necessity.

## Final hostile recommendation

Adopt the revised architecture, with this exact ownership split:

- **Paper IV:** one concrete Frobenius-orbit torsor corollary;
- **Paper V:** a two-page comparison of residual cyclic markings, no
  \(\mathbf F_4\) or geometry;
- **Epilogue:** the general descent lemma, the intrinsic \(C_2\)-torsor
  calibration, and every integral/geometric consequence.

Do not edit the manuscripts until the toric-label check and the intrinsic
calibration theorem are separately formulated. The first is bounded. The
second is the only new crown-level risk introduced by making Paper IV and V
causal rather than merely thematic.
