# C817 intrinsic conic and ambient-plane recovery

**Lane:** `clebsch`  
**Scope:** C817 subitem 4 only; mathematics freeze, with Paper IV read-only

## Verdict

The intrinsic conic-action proposal is positive, and the strongest compact
theorem is better than the stated success gate.  Let \(\mathcal H\) be the
minimum-support hypergraph and let
\[
 G=\operatorname{Aut}(\mathcal H)\cong\PGL(2,13).
\]
Then the set
\[
 \Omega=\operatorname{Syl}_{13}(G)
\]
has fourteen elements, and conjugation gives a faithful sharply
three-transitive action of \(G\) on \(\Omega\).  This is the abstract
\(\mathbf P^1(\mathbf F_{13})\), hence the conic-point \(G\)-set, recovered
without a stored conic, coordinates, or incidence matrix.

More strongly, the abstract group reconstructs the complete ambient plane and
its conic polarity.  If \(\mathcal I\) is the set of the \(169\) involutions of
\(G\), put
\[
 \Pi=\Omega\sqcup\mathcal I.
\]
Index both points and polar lines by \(\Pi\), and define incidence by

1. \(U\in U^\perp\) for \(U\in\Omega\), with no other
   \(\Omega\)--\(\Omega\) incidences;
2. \(U\in j^\perp\) exactly when \(j\) normalizes \(U\); and
3. for distinct involutions \(i,j\), put \(i\in j^\perp\) exactly when
   \(ij\) is an involution.

This incidence structure is \(\operatorname{PG}(2,13)\), the subset
\(\Omega\) is its nonsingular conic, and the indexing
\(a\leftrightarrow a^\perp\) is the conic polarity.  Thus the construction
recovers all \(183\) points, all \(183\) lines, the \(14\) tangent lines, the
\(78\) internal points and passant lines, the \(91\) external points and
secant lines, and their complete incidence.

The only missing data are deliberately nonintrinsic: a preferred ordered
projective frame, a named \(\mathbf F_{13}\)-coordinate, and a displayed
quadratic equation.  The conic and its polarity are canonical; their equation
is not canonical before coordinates are chosen.

## Sylow reconstruction of the conic

In the standard matrix model, every Sylow-\(13\) subgroup is conjugate to
\[
 U_\infty=\left\{
 \begin{bmatrix}1&t\\0&1\end{bmatrix}:t\in\mathbf F_{13}
 \right\}.
\]
It fixes the unique projective point \(\infty\), and its normalizer is the
Borel subgroup of order \(13\cdot12=156\).  Conjugation transports this
fixed-point assignment, giving a \(G\)-equivariant bijection
\[
 \operatorname{Syl}_{13}(G)\longrightarrow\mathbf P^1(\mathbf F_{13}).
\]
There are therefore \(2184/156=14\) Sylow subgroups.  Fractional linear
transformations act simply transitively on ordered triples of distinct
projective points, since both sets have size
\[
 14\cdot13\cdot12=2184=|G|.
\]
This proves sharp three-transitivity and faithfulness.  The construction of
\(\Omega\) itself uses only subgroup order and conjugation in the group
reconstructed from \(\mathcal H\); the matrix model proves its identity with
the familiar projective line and is not an input to the reconstruction.

The same count gives the exact coordinate ambiguity.  Ordered triples of
distinct elements of \(\Omega\) form a \(G\)-torsor.  Choosing one labels it
\((\infty,0,1)\) and supplies coordinates; no such choice can be
\(G\)-invariant.

## Adjoint-plane theorem

The conceptual proof of the stronger statement is the adjoint
three-dimensional representation.  In the standard model identify
\(\operatorname{PG}(2,13)\) with the projectivization of
\(\mathfrak{sl}_2(\mathbf F_{13})\).  For a traceless matrix \(A\),
Cayley--Hamilton gives
\[
 A^2=-\det(A)I.
\]
The \(14\) singular matrix lines are the nilpotent conic; the line generated
by a nilpotent \(N\) determines the Sylow subgroup
\(\{I+tN:t\in\mathbf F_{13}\}\).  Every nonsingular traceless matrix line is
an involution in \(\PGL(2,13)\), and every involution arises uniquely this
way.  Hence
\[
 \mathbf P(\mathfrak{sl}_2)=
 \operatorname{Syl}_{13}(G)\sqcup\{\text{involutions of }G\}
\]
intrinsically, with cardinalities \(14+169=183\).

The trace form
\[
 \langle A,B\rangle=\operatorname{tr}(AB)
\]
is the polar form of the determinant conic.  Its zero relation translates
exactly into the three group-theoretic incidence rules above:

- two nilpotent lines are orthogonal exactly when they coincide;
- an involution line is orthogonal to a nilpotent line exactly when it
  normalizes the associated Sylow subgroup; and
- for distinct involutions \([A],[B]\), one has
  \(\operatorname{tr}(AB)=0\) exactly when \([AB]\) is an involution.

This identifies the intrinsic incidence with trace orthogonality, proving all
projective-plane axioms and the conic polarity without an enumerative leaf.
The exact computation independently checks every incidence and every
point-pair axiom in the finite model.

## Recovery of the internal points, secants, and the old matrix

Let \(X\) be the \(78\)-vertex set of \(\mathcal H\).  For each \(P\in X\),
the stabilizer \(G_P\) is a nonsplit-torus normalizer \(D_{28}\).  Its center
has a unique nonidentity element \(j_P\).  The map
\[
 P\longmapsto j_P
\]
is a \(G\)-equivariant bijection from \(X\) to the size-\(78\) involution
class with centralizer order \(28\).  The other involution class has size
\(91\) and gives the external points.

The involution \(j_P\) is fixed-point-free on \(\Omega\), so its seven
two-cycles form a perfect matching of the recovered conic points.  These are
exactly the seven secants through \(P\).  Every one of the \(91\) conic
chords occurs in six such matchings, since
\[
 78\cdot7=91\cdot6.
\]
Its setwise stabilizer has order \(24\), recovering the split-torus
normalizers that index the three toric minimum families in subitem 3.

In coordinates, if \(P=(x:y:z)\), the central involution is
\[
 J_P=\begin{bmatrix}y&-x\\z&-y\end{bmatrix},
 \qquad J_P^2=(y^2-xz)I.
\]
Its paired conic points are collinear with \(P\), which verifies the matching
dictionary directly.  The old \(78\)-by-\(78\) internal-point/passant matrix
\(M\) is now the restriction of the recovered polarity incidence to the
internal involution class in both point and line positions.  Thus the result
is strictly stronger than recovering \(M\) as an unlabeled matrix.

## Exact evidence and trust boundary

Replay from `rust/`:

```sh
python3 ../notes/2026-08-02-c817-intrinsic-conic-action.py \
  --check ../notes/2026-08-02-c817-intrinsic-conic-action.json
```

The deterministic script exhausts all \(2184\) normalized projective
matrices.  It partitions all \(168\) order-\(13\) elements into the fourteen
Sylow subgroups, computes all normalizers and the complete conjugation action,
and checks all \(2184\) ordered distinct triples.  It then computes all
\(169\) involutions, all \(183^2\) polarity incidences, and the unique common
line for each of the \(\binom{183}{2}=16653\) distinct point pairs.  There is
no sampling or early stop.

Three exact invariant comparisons serve as independent cross-checks inside
the replay.  The Sylow fixed-point map is checked for every group element and
every Sylow subgroup; the abstract polarity incidence is compared entry by
entry with the coordinate trace form on all \(183\) points; and all \(546\)
internal-point/chord incidences are checked by projective collinearity.  The
subitem-3 evidence independently constructs the same group and the
\(78\)-point action.  No separate second software implementation is claimed;
the human adjoint-space proof removes dependence on the finite plane-axiom
enumeration.

Evidence files:

- `notes/2026-08-02-c817-intrinsic-conic-action.py` — 18706 bytes,
  SHA-256
  `11e30530ede8c1efbe6b7f1a599068a139e338d2e0bd75bf330a4062269ad348`;
- `notes/2026-08-02-c817-intrinsic-conic-action.json` — 5544 bytes,
  SHA-256
  `fab5601e67ec4eed7acc37811221e86d3f827033e495cc661eaf89d3983699fd`;
- `notes/2026-08-02-c817-intrinsic-conic-action.sha256` — checksum manifest.

The JSON is canonical, sorted, deterministic, and checked byte-for-byte by
`--check`.  The theorem assumes the already frozen identification
\(G=\operatorname{Aut}(\mathcal H)\cong\PGL(2,13)\); it does not recompute
the hypergraph automorphism group.

## Novelty boundary

No novelty or priority claim is made.  The adjoint realization of
\(\PGL_2\), its determinant conic, and the trace polarity are classical.  The
exact consequence that the Paper-IV minimum hypergraph reconstructs this
entire marked plane may be suitable for later integration, but it has not yet
received the task-wide original-source and forward-citation audit required
before publication positioning.

## Required closeout passes

### `ej`

The free upgrade is the secant-matching layer.  The center of every
\(D_{28}\) vertex stabilizer canonically supplies a fixed-point-free
involution of the recovered conic, so the \(78\) internal vertices recover
their \(91\)-chord incidence with no coordinates.  This also makes the
split-torus bases of the three toric families intrinsic.

### `tt`

The decisive change of viewpoint is to stop at neither the fourteen points
nor the secants: Sylow subgroups and involutions are respectively the
nilpotent and nonsingular lines of \(\mathfrak{sl}_2\).  Group multiplication
already encodes trace orthogonality.  This turns the proposed conic-action
recovery into a complete ambient-plane reconstruction and gives a short human
proof rather than a larger permutation certificate.

### `ej2`

The second-order gain is that the previously reconstructed incidence matrix
\(M\) is not an extra object.  It is exactly the internal--internal block of
the canonical polarity matrix on
\(\operatorname{Syl}_{13}(G)\sqcup\mathcal I\).  The four minimum families,
the hidden module, the conic, and the old incidence matrix now all live on one
group-intrinsic carrier.

`aa` was not triggered: the Sylow count, faithful action, secant matching,
and adjoint-plane upgrade all passed their cheapest exact falsifiers.

## Mystery ledger

- **Settled:** the fourteen Sylow-\(13\) subgroups are canonically the conic
  points, and conjugation is the faithful sharply three-transitive conic
  action.
- **Settled by `ej`:** the centers of the \(78\) vertex stabilizers recover
  the complete internal-point/secant incidence and the \(91\) chord set.
- **Settled by `tt`:** the abstract group recovers the full
  \(\operatorname{PG}(2,13)\), not merely its conic, through the
  Sylow-plus-involution adjoint model and intrinsic polarity.
- **Settled by `ej2`:** the old matrix \(M\) is exactly the
  internal--internal polarity block, so ambient reconstruction strictly
  subsumes unlabeled matrix reconstruction.
- **Exact residual ambiguity:** no preferred ordered triple of conic points,
  field-coordinate labeling, or displayed equation survives the full
  \(G\)-symmetry.  The \(2184\) ordered triples form a simply transitive
  \(G\)-torsor; choosing one is precisely choosing coordinates.
- **Open novelty gate:** no publication novelty is asserted.  Any manuscript
  positioning still requires the task-wide original-source and
  forward-citation audit.
- **Next owning gate:** C817 subitem 5, an exact compact spectral obstruction
  for weight eight.

No Paper-IV manuscript, Lean source, or release file was changed.
