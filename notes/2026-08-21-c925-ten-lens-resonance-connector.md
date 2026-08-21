# Ten views of the resonant rank connector

## Exact obstruction

Let \(R\) be the chosen trait ring, with fraction field \(K\), residue field
\(k\), and resonance parameter \(t\).  Let \(M_R\) be the occurrence-indexed
QDM lattice, let \(T_i,T_j\) be the two selected monodromies, and let \(r_R\)
be the marked row.  The telescope only needs

\[
  \overline r(1-\overline T_j)(1-\overline T_i)=0.
\]

The generic window calculation has the stronger shape

\[
  r_R(1-T_j)(1-T_i)=A_{ij}\lambda_{ij},
  \qquad A_{ij}\in (t),
\]

provided the named window-rank covector \(\lambda_{ij}\) extends to the actual
trait lattice.  It is not enough to define \(\lambda_{ij}\) generically by
division: over a DVR that would merely rename the desired divisibility.  The
source identity and the regular extension of this particular covector are the
load-bearing assertions.  The closed telescope only detects reduction modulo
\(t\); when \(A_{ij}\) has order greater than one, divisibility by \(A_{ij}\)
is a strictly stronger source statement.  The Lean modules
`Comparison.VariationNormalFactor` and
`Comparison.ResonantWindowRank` formalize the consumer and the finite
resonant rank calculation respectively.

## Ten languages

1. **DVR linear algebra.**  The telescope obstruction is the residue class of
   \(r_R(1-T_j)(1-T_i)\) in \(M_R^\vee/tM_R^\vee\).  The stronger named-window
   lift obstruction is its class modulo \(A_{ij}M_R^\vee\), equivalently the
   integrality of the prescribed quotient by \(A_{ij}\).  A unit Smith minor
   or saturation theorem for that named quotient closes the stronger problem.

2. **Rees modules.**  The stronger lift obstruction is failure of strictness
   for the \(A_{ij}\)-adic filtration.  Torsion-freeness of the cokernel of a
   comparison map is one sufficient provider; the quotient
   \(M_R^\vee/A_{ij}M_R^\vee\) is itself \(A_{ij}\)-torsion and is not the
   object to call torsion-free.

3. **Kashiwara--Malgrange filtration.**  After identifying the trait lattice
   with a canonical \(V^0\)-lattice of a specializable D-module, the
   obstruction becomes the degree-zero graded piece of the row morphism on
   nearby cycles.  Strict specialization then makes the generic normal factor
   vanish.  An arbitrary coefficient lattice has no canonical
   Kashiwara--Malgrange filtration.

4. **Perverse wall quiver.**  Once the actual projected variation is
   identified, with orientation, with the quiver's can/variation composite,
   the obstruction is the incoming-to-outgoing arrow detected by the rank
   covector.  A rank morphism extending through the intermediate extension
   annihilates that arrow.  The resonant window schober already has the source
   rank morphism; its identification with the actual QDM quiver is not yet
   supplied.

5. **Stokes-filtered local systems.**  After the actual receiver is identified
   with the named Stokes object, the obstruction is an off-diagonal Stokes
   coefficient after applying the row.  A morphism to the selected pure block
   kills different-exponent incoming terms by functoriality; it does not
   remove arbitrary mixing inside one repeated exponent.  Tame asymptotics in
   one sector do not construct that morphism or control the opposite-sector
   coordinate.

6. **Microlocal sheaves.**  After an oriented identification of the actual
   packet with a wall-conormal microstalk, the obstruction is the component of
   the row on that microstalk.  A morphism to a locally constant target has
   zero wall microstalk.  The required bridge is a non-characteristic
   microlocal identification; an ordinary one-variable Fourier transform of
   the constant target is not such a bridge.

7. **GKZ and window monodromy.**  On the resonant \(K_0\)-window
   representation, the obstruction is failure of its rank augmentation to
   extend to the resonant GKZ/QDM lattice.  Proposition 12.4 of
   Spenko--Van den Bergh and the formal finite identity show that every moved
   generator still has rank one at \(h=1\).  Their GKZ comparison is
   nonresonant, so a separate resonant comparison is needed on the actual
   side.

8. **Categorical schobers.**  At the stated level, rank is a homomorphism of
   the decategorified \(K_0\)-local systems, not an exact functor on the
   categorical schober.  A genuine categorical lift can instead use derived
   fibre at a common-open point, provided every wall kernel restricts to the
   diagonal there.  The transition formulas establish the \(K_0\) morphism;
   they do not establish this stronger categorical lift or identify the QDM
   realization.

9. **Gamma structure and Fourier--Mukai duality.**  Rank is an Euler pairing
   with a point class, with order and sign fixed by
   \(\operatorname{rk}E=\chi(E,\mathcal O_p)\) and Serre duality.  A common
   point outside all centers, preservation of that point object by the actual
   Fourier--Mukai comparison, preservation of the Euler pairing, and the
   actual Gamma-integral square would transport the row.  Formal pairing
   preservation alone does not.  Iritani's toric sectorial theorem gives this
   pattern for toric walls; Iritani's general blowup theorem gives only the
   formal QDM decomposition.

10. **Fukaya--Picard--Lefschetz theory.**  Under an HMS identification of the
    point/Gamma row and the oriented exceptional thimbles, the same covector
    is an intersection with a point brane or thimble.  A stop-removal or
    semiorthogonality theorem placing that brane in the correct orthogonal
    would give the row identity without computing the whole Stokes matrix.
    None of those HMS and orientation identifications is presently supplied.

## Flexible connectors

Three connector shapes dominate the list.

1. A **morphism of whole objects** in a category with canonical functorial
   Stokes or \(V\)-filtrations transports those filtrations.  A morphism of
   arbitrary Rees lattices additionally needs strictness.
2. A **pairing-dual point line** reduces the covector to preservation of one
   geometric object and one perfect pairing.
3. A **strict trait lattice** upgrades a named generic equality to an
   integral equality and then specializes the normal factor to zero.

The highest-value fusion is the GKZ--categorical--Gamma route.  First build
the resonant window rank as a natural transformation.  Then identify it with
Euler pairing by a common point object.  Finally use a Gamma/Fourier--Mukai
comparison, or a strict resonant extension of that comparison, to identify
the same morphism with the actual QDM row.  This asks for neither a full
Stokes basis nor every can/variation packet.

## Parallel augmented sources along a path

The quotient-line telescope does not require one augmentation to serve every
edge.  For an edge occurrence \(e\), let \(W_e\) be its window/GKZ source,
\(G_e\) a Gamma or narrow augmentation, and \(A_e\) the actual fixed-phase
receiver.  A saturated graph or cospan

\[
 W_e \longleftarrow \Gamma_e^{\mathrm{sat}}
      \longrightarrow G_e \longrightarrow A_e
\]

is enough when all legs carry the same named row and the final leg spans the
incoming image consumed by the actual receiver.  The next edge may use a
different \(G_e\).  A single point chosen in the common open of the whole weak
factorization gives the candidate adjacent-vertex identification of the
pairing-dual row lines.  This is a joint-shadow statement: no individual
augmentation need reconstruct the rich receiver.

The local bridges divide accordingly.

- The window leg supplies the normal factor and the resonant rank morphism.
- The Gamma/Fourier--Mukai leg supplies the Euler pairing and point object.
- The actual leg supplies the selected loop or formal phase and exact
  specialization.
- The common-open point supplies the adjacent row-line reindexing.

The same-map and same-row equations on the cospan remain essential.  Merely
having three abstract models with isomorphic generic fibres does not identify
their integral covectors.

## Failed shortcut

An ordinary one-dimensional Fourier--Laplace transform does not carry the
constant target used by the resonant rank morphism to a nonzero pure
zero-exponential co-Stokes block: it produces a punctual object, which is
lost after restriction to the punctured Fourier line.  The dual torus in the
GKZ theorem is also generally multidimensional.  Thus any microlocal or
Fourier bridge must name a non-characteristic functor and its boundary
projector explicitly.

## Local theorem to seek

For every dangerous overlap occurrence, construct one of the following
sufficient packages.  They are not equivalent in general.

- A trait-level morphism carrying the named resonant window rank covector to
  the actual QDM covector, with strict specialization.
- A pairing-preserving trait comparison carrying the named point line to the
  actual Gamma point line, with perfectness, Euler variance, trait
  compatibility, and normalization fixed.
- A saturated resonant QDM lattice in which the nonresonant Gamma/window
  comparison extends and its rank square remains exact.

Any of these packages feeds `VariationNormalFactor.AmbientCertificate`
directly.  A generic quotient obtained only after division by the normal
factor does not.

### Sharp pole-bound form

Write \(A_{ij}=t^a u\) with \(a\geq1\) and \(u\in R^\times\).  Relative to
the independently defined generic window covector, integral extension is
stronger than the telescope needs.  The exact local statement is

\[
 r_R(1-T_j)(1-T_i)=A_{ij}\lambda_{ij,K},
 \qquad
 \lambda_{ij,K}\in t^{1-a}M_R^\vee.
\]

Indeed, the right-hand side then belongs to \(tM_R^\vee\), and its closed
fibre is zero.  Conversely, once the displayed generic identity and the
canonical lattice are fixed, closed-fibre vanishing says exactly that the
transported named covector has pole order at most \(a-1\).  Rescaling the
lattice or defining the covector by division after seeing the answer would
make this formulation circular.

Thus the smallest occurrence-local source theorem is a rank-shadow pole
bound.  The morphism, pairing, strictness, perverse, and microlocal packages
above are alternative sufficient ways to prove that bound.  Requiring
\(\lambda_{ij,K}\in M_R^\vee\) remains an attractive uniform strengthening,
but is unnecessary when \(a>1\).
