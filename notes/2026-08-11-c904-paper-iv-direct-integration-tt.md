# Paper IV direct integration: Frobenius packets and residual marking torsors

**Lane:** `clebsch`

**Date:** 2026-08-11

**Scope:** Tao-style structural exploration of a direct role for Paper IV in
Paper V and the geometric epilogue.  No manuscript, Lean, or mirror edit.

## Executive answer

Do not seek a geometric arrow from Paper IV's conic plane over `F_13` to the
`A_5` cubic.  The acting group `PGL_2(13)` has order `2184`, not divisible by
five, so there is no hidden `A_5` subgroup through which the six-axis geometry
could pass.  A direct incidence or subgroup bridge would be artificial.

The clean common theorem is instead **Frobenius descent of a hidden commutant
field and its residual marking torsor**.

- Paper IV reconstructs a binary module with commutant `F_8`; choosing the
  named scalar generator is a free `C_3=Gal(F_8/F_2)` torsor.
- Papers I--III and V reconstruct a golden orientation as a free `C_2` torsor.
- The epilogue's exotic gluing pair `{omega,omega^2}` is the free
  `C_2=Gal(F_4/F_2)` generator torsor of the mod-two heart.

The missing finite-to-geometric orientation theorem should identify the two
`C_2` torsors equivariantly under the same outer-normalizer quotient.  It
should **not** reduce the operator order `Z[sqrt(5)]` modulo two: that order
has polynomial `t^2-5`, whose reduction is `(t+1)^2`, not the separable field
`F_4`.  A torsor comparison avoids this false arithmetic shortcut.

Paper IV supplies the degree-three model and the general descent lemma.  This
gives it a direct structural role without assigning it a nonexistent cubic
map.

## 1. The exact Paper IV packet

Paper IV proves that the binary Bose--Mesner algebra acts on the code `K`
through

\[
\operatorname{End}_{\mathbf F_2\operatorname{PGL}(2,13)}(K)
=\mathbf F_8.
\]

For a root `alpha` of `t^3+t^2+1`, the three recovered relation operators act
as

\[
(A_9,A_{10},A_{12})=(\alpha,\alpha^2,\alpha^4).
\]

The name `alpha` is canonical only up to Frobenius.  Thus

\[
\mathscr G_8=\{\alpha,\alpha^2,\alpha^4\}
\]

is a canonical `C_3` torsor reconstructed from weighted pair data.

The four minimum-word orbit Gram operators are

\[
(N_1^tN_1,N_2^tN_2,N_3^tN_3,N_4^tN_4)
=(A_9,A_9,A_{12},A_{10}).
\]

Hence scalar projection forgets some geometric type: two distinct orbit
families have the same Gram scalar.  Before publication use, identify exactly
which `N_i` is octahedral and which three are toric.  The expected useful
corollary is that the three toric families map bijectively to the Frobenius
orbit `G_8`; the displayed manuscript does not presently label the `N_i`
strongly enough for that sentence to be quoted without this check.

This duplication is informative.  The commutant field recovers the finite
packet, but stabilizer geometry is needed to distinguish the actual family.
The upper gluing packet has the same two-stage structure: field-linear data
produces the five kernels, and the stabilizers `S_6` versus `A_5` select their
geometric type.

## 2. General Frobenius--Schur descent lemma

Extract the following standard structural statement from Paper IV's hidden-
field proof.

> **Frobenius--Schur descent lemma.** Let `V` be an irreducible
> `F_2 G`-module such that
> \[
> V\otimes\overline{\mathbf F}_2
> =W\oplus W^{(2)}\oplus\cdots\oplus W^{(2^{r-1})}
> \]
> is a multiplicity-free Frobenius orbit of absolutely simple constituents.
> Then
> \[
> \operatorname{End}_{\mathbf F_2G}(V)=\mathbf F_{2^r}.
> \]
> A recovered operator with irreducible degree-`r` minimal polynomial marks a
> generator, and the set of its Frobenius conjugates is a free
> `Gal(F_{2^r}/F_2)` torsor.

The proof is the one Paper IV already uses: Schur's lemma makes the geometric
commutant the product of `r` copies of the algebraic closure, Frobenius cycles
the factors transitively, and descent gives the field `F_{2^r}`.  A generator
is unique only up to the Galois action.

Two instances matter:

| branch | geometric orbit length | binary commutant | residual torsor |
|---|---:|---|---|
| Paper IV | 3 | `F_8` | `{alpha,alpha^2,alpha^4}` |
| exotic six-point heart | 2 | `F_4` | `{omega,omega^2}` |

This is a small lemma, but it supplies one mathematical language for both
branches and removes a matrix-centralizer certificate from the epilogue.

## 3. The correct upper orientation bridge

Let

- `O_gold` be the two golden orientations recovered in Papers I--III and
  identified by V;
- `E_ex={omega,omega^2}` be the two exotic gluing kernels.

Both are free `C_2` torsors:

- the nontrivial outer normalizer exchanges the golden orientations;
- the same quotient acts by Frobenius on `End_{A_5}(H_2)=F_4` and exchanges
  the exotic kernels.

The desired theorem is

\[
\mathscr O_{\mathrm{gold}}\simeq\mathscr E_{\mathrm{ex}}
\]

as torsors under the identified outer `C_2`.

Once equivariance is proved, one normalized comparison fixes the map.  No
integral golden operator has to reduce to `omega`, and no arbitrary choice of
a named field element enters the theorem.  Orientation reversal and Frobenius
conjugation become the same group action, which is the exact statement the
series narrative needs.

This replaces the current risky phrase “send the golden orientation to a
generator of `F_4`” by a coordinate-free assertion.  A named generator may be
used in a proof after choosing one basepoint, but it should disappear from the
theorem statement.

## 4. A three-lemma common spine

The upper and lower branches can share three short structural lemmas.

### Lemma A: Frobenius commutant descent

The multiplicity-free geometric orbit determines `F_{2^r}` and its generator
torsor, as above.

### Lemma B: cyclic torsor transport

If two nonempty free `C_r` torsors carry the same identified action, an
equivariant map is an isomorphism and is determined by one normalized pair.
This is the abstract form of both V's orientation return and the exotic-sheet
comparison.

### Lemma C: stabilizer selection

A commutant-field packet need not remember geometric type.  The geometry is
selected by the stabilizer of a packet member:

- in IV, `S_4` versus `D_24` distinguishes octahedral and toric families even
  when a Gram scalar repeats;
- in the epilogue, `S_6` versus `A_5` distinguishes classical and exotic
  principal gluings.

The first two lemmas are general and structural.  The third is instantiated
by exact orbit--stabilizer theorems in the two papers.

## 5. Clean publication integration

### Paper IV: add 1--2 pages, not a cubic section

After the hidden-field proposition:

1. state the Frobenius--Schur descent lemma at the natural generality above;
2. identify `G_8` as the residual generator torsor recovered from pair data;
3. if the orbit-label check passes, prove that the three toric Gram operators
   form exactly this Frobenius orbit;
4. explain that the octahedral duplicate shows why scalar data must be paired
   with stabilizer geometry.

The abstract need not mention the future cubic.  The conclusion may say that
Paper IV supplies the cubic Frobenius-descent instance of the series' residual-
marking principle.

### Paper V: add a short structural synthesis

Paper V may end with a two-row theorem or table:

- upper branch: a `C_2` orientation torsor killed by one odd calibration and a
  selected chordal line;
- lower branch: a `C_3` field-generator torsor recovered from weighted pairs,
  with only coordinate framing left after geometric reconstruction.

This does not claim that the branches have one common shadow functor.  It
states that both recover a carrier together with its residual cyclic marking,
using the reconstruction-profile language already isolated in C905.

### Geometric epilogue: consume the `C_2` theorem

The first section should:

1. recall the Frobenius--Schur lemma, citing Paper IV as the degree-three
   model;
2. compute the degree-two commutant `F_4` of the six-point heart;
3. identify the golden and exotic `C_2` torsors equivariantly;
4. only then choose `omega` locally to write matrices or graph lattices.

This gives Paper IV a direct role in the proof language while keeping the
epilogue self-contained.

## 6. What not to do

### No direct conic-plane/cubic map

The groups, dimensions, and geometries do not support it.  A forced incidence
arrow would weaken both papers.

### No `F_64` master field

The compositum of `F_4` and `F_8` is `F_64`, and the product of their Galois
torsors is formally a `C_6` torsor.  No common object in the series carries
that field or action.  Recording `F_64` would be numerology, not integration.

### No claim that all four Paper IV families are one field orbit

Only the three conjugate relation scalars form the `C_3` orbit.  The fourth,
octahedral family is geometrically distinct, and one Gram scalar repeats.

### No reduction of `Z[sqrt(5)]` to `F_4`

The reduction is nonreduced.  If a larger root--weight order eventually
realizes `Z[(1+sqrt(5))/2]`, that is a separate arithmetic theorem.  It is
unnecessary for the torsor comparison.

## 7. Why this improves the series punchline

The original series summary treated residual markings as nuisances to be
listed after reconstruction.  The better structural statement is:

> A sparse shadow reconstructs not only a carrier but also the finite Galois
> torsor measuring the remaining choice of scalar, orientation, or sheet.

Paper IV supplies the first non-binary example: pair data reconstructs a
degree-three commutant and its Frobenius generator torsor.  Paper V identifies
the upper degree-two orientation torsor.  The epilogue transports that torsor
to the exotic principal gluing and then to the cubic family.

This makes IV part of the mechanism that explains why the epilogue's sheet is
marked, rather than a parallel example mentioned only in a figure.

## 8. Acceptance gates

1. Label the four Paper IV orbit matrices and verify that the three toric Gram
   operators are exactly `alpha,alpha^2,alpha^4` in some Frobenius order.
2. State and prove the Frobenius--Schur descent lemma without depending on the
   `q=13` census.
3. Identify the outer `C_2` acting on V's golden orientation with the
   normalizer quotient acting on the exotic `F_4` pair.
4. Prove one normalized geometric comparison; obtain the other sheet by
   equivariance.
5. Ensure every theorem is phrased in torsor language, so named generators are
   proof coordinates rather than retained output.
6. Keep Paper IV's plane/polarity theorem logically independent and its
   abstract focused on that result.

## TT verdict

The missing object was not another carrier.  It was the **residual marking
torsor itself**.

Once those torsors are treated as reconstructed mathematical objects, Paper IV
and the upper branch become two degrees of one Frobenius-descent mechanism,
and the epilogue's exotic-sheet selection becomes the next theorem in that
mechanism.  This is the cleanest direct integration available and may also
replace the most doubtful step in the current revised plan.
