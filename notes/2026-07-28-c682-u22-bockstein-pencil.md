# C682 \(U_{22}\) Bockstein section and orientation pencil

## Outcome

The marked characteristic-\(11\) section
\[
 U_{22}\cap\mathbf P(2\mathbf1\oplus V_4\oplus V_5)
\]
has a canonical globalization over the corrected
\(\mathbf Z_{11}\)-tower.  It is not obtained by choosing and lifting an
abstract \(V_3\)-projector.  It is the kernel of a divided
Clebsch--Gordan contraction with the lifted invariant dodecic.

Let \(\mathcal O=\mathbf Z_{11}\), let
\[
 E=\operatorname{Sym}^6(\mathcal O^2),
\]
and let \(I\in\operatorname{Sym}^{12}(\mathcal O^2)\) be the normalized
invariant dodecic on the selected corrected tower.  Write
\[
 \pi_{12}:\Lambda^3E\longrightarrow\operatorname{Sym}^{12}(\mathcal O^2)
\]
for the primitive highest-weight projection.  In the monomial and
lexicographic Pluecker bases its coefficient at
\(e_i\wedge e_j\wedge e_k\) is
\[
 \frac{(j-i)(k-i)(k-j)}2.
\]
If \(B_r\) denotes the primitive integral order-\(r\)
Clebsch--Gordan contraction, then
\[
 B_{11}(\pi_{12}(-),I)\equiv0\pmod {11}.
\]
Consequently
\[
 Q_I=\frac1{11}B_{11}(\pi_{12}(-),I):
 \Lambda^3E\longrightarrow\operatorname{Sym}^2(\mathcal O^2)
\]
is integral and base-change compatible.  The global section is
\[
 \boxed{\quad
 \Lambda_I=
 \mathbf P\bigl(\ker c_\omega\cap\ker Q_I\bigr)
 \subset\mathbf P(\ker c_\omega).
 \quad}
\]
Its reduction is exactly the previous complementary \(\mathbf P^{10}\):
modulo the \(21\) contraction equations, the three rows of \(Q_I\) span
\[
 p_{012},\qquad p_{013}+p_{356},\qquad p_{456}.
\]
Thus the formerly representation-theoretic quotient
\[
 2\mathbf1\oplus V_3\oplus V_4\oplus V_5
 \longrightarrow V_3
\]
is the special fibre of a concrete divided transvectant.

## The global invariant pencil

The same mechanism globalizes the two invariant target coordinates.
Let
\[
 \epsilon:\Lambda^3E\longrightarrow\mathcal O
\]
be the primitive \(\operatorname{SL}_2\)-invariant alternating
trilinear form.  Its nonzero Pluecker coefficients are
\[
\begin{array}{c|rrrrr}
ijk&036&045&126&135&234\\ \hline
\epsilon_{ijk}&-30&20&20&-5&2.
\end{array}
\]
The order-twelve contraction also vanishes modulo \(11\), so
\[
 \eta_I=\frac1{11}B_{12}(\pi_{12}(-),I)
\]
is a second integral invariant functional.  On the special
anticanonical carrier,
\[
 \epsilon=7u,\qquad \eta_I=8v
\]
modulo the contraction relations.  Therefore the normalization
\[
 \widetilde u=8\epsilon,\qquad
 \widetilde v=7\eta_I,\qquad
 r=\frac{\widetilde u}{\widetilde v}
\]
reduces exactly to the previous \(u/v\).

The denominator \(\widetilde v\) is a unit at all \(22\) special points.
Hence \(r\) is a regular function on the complete formal lift of the
section, not only a rational coordinate on a chosen chart.

## Formal \(22\)-section

Every special point is transverse: in a Grassmann chart the nine
fifth-transvectant isotropy equations and three \(Q_I\)-equations have
Jacobian rank \(12\).  Hensel's lemma therefore lifts each point uniquely
through every \(11\)-adic order.

Because the intersection is projective and its complete special fibre is
the reduced length-\(22\) scheme already certified, its formal completion
is
\[
 \mathcal Z_I
 =U_{22,\mathcal O}\cap\Lambda_I
 \simeq\bigsqcup_{1}^{22}\operatorname{Spf}\mathcal O.
\]
Equivalently, the marked section is finite etale of degree \(22\) over
the corrected local tower.  The primary certificate explicitly performs
all \(22\) unique lifts modulo \(11^2\); a separate implementation uses
reverse Grassmann charts and independently obtains the same values.

## What \(u/v\) remembers after globalization

The mod-\(11\) equation \(u^2=v^2\) hides a first-order refinement.
Modulo \(121\), multiplication by \(r\) on the \(22\)-point section has
characteristic polynomial
\[
 \boxed{\quad
 (T-100)(T-43)^5(T-45)^{10}(T-54)^6.
 \quad}
\]
The four roots have multiplicities
\[
 1,\quad5,\quad10,\quad6,
\]
exactly the four \(A_5\)-orbit sizes.  Reducing modulo \(11\) gives
\[
 (T-1)^{11}(T+1)^{11}=(T^2-1)^{11}.
\]
Thus the two length-eleven sheets are a special-fibre collision:
the lifted invariant pencil separates all four target orbits already at
first order.  In particular, \(u/v\) contains more information than the
binary incidence orientation.

The first-order values may be displayed as
\[
\begin{array}{c|c|c}
\text{orbit size}&r\bmod121&r\bmod11\\ \hline
1&100=1+9\cdot11&1\\
10&45=1+4\cdot11&1\\
5&43=-1+4\cdot11&-1\\
6&54=-1+5\cdot11&-1.
\end{array}
\]
This supplies the target-moduli meaning missing from the finite-field
calculation: the invariant pencil is the four-orbit quotient, while its
reduction is only the two-sheet quotient.

## Comparison with the incidence orientation

The two golden incidence parents are the size-\(1\) and size-\(5\)
points.  In the lifted pencil,
\[
 r_+=100,\qquad r_-=43\pmod {121}.
\]
The selected golden square root is
\[
 \sqrt5=48\pmod {121}.
\]
The raw ratio is therefore not exactly odd:
\[
 r_++r_-=22\ne0\pmod {121}.
\]
This falsifies the tempting all-order scalar identity
\(w=\sqrt5\,u/v\).

The correct comparison is the unique centered affine coordinate on the
two-point incidence fibre:
\[
 \boxed{\quad
 w=\sqrt5\,
 \frac{2r-r_+-r_-}{r_+-r_-}.
 \quad}
\]
It sends the selected and conjugate parents to
\(\sqrt5\) and \(-\sqrt5\), respectively.  Numerically,
\[
 \frac{r_++r_-}{2}=11,\qquad
 \frac{r_+-r_-}{2}=89,
\]
and hence
\[
 w=59r+77\pmod {121}.
\]
On the special fibre this becomes the clean formula
\[
 \boxed{w=4\,u/v\pmod {11}.}
\]

This is an object-level comparison.  The formal \(U_{22}\) section and
the local incidence fibre are both finite etale; \(r\) separates the two
golden sections, and the displayed affine normalization is the unique
deck-odd coordinate with square \(5\).  It also explains why equality of
the two \(C_2\)-actions did not force equality of their raw coordinates:
the global pencil has a nonzero first-order center because it resolves
two additional orbit types.

## Proof boundary

The integral formulas prove:

- the primitive projection
  \(\Lambda^3\operatorname{Sym}^6\to\operatorname{Sym}^{12}\);
- coefficientwise divisibility by \(11\) of the order-\(11\) and
  order-\(12\) contractions with the corrected invariant line;
- recovery of the previous sparse section and invariant coordinates;
- the formal finite-etale lift of the complete \(22\)-point section; and
- the centered comparison of its golden pair with the local incidence
  orientation.

The exact calculation checks the displayed reductions, all \(22\)
Jacobian lifts modulo \(121\), the four-value orbit quotient, and the
golden comparison.  It uses as classical inputs the
fifth-transvectant Grassmannian model of \(U_{22}\) and the local
degree-two incidence theorem already sourced for Paper III.

This does not prove good reduction of Hitchin's global incidence
comparison, identify the invariant pencil with a global rational
coordinate away from the corrected \(11\)-adic neighborhood, or make a
novelty claim.  It does not reopen the pre-release-green Paper III bytes.

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-28-c682-u22-bockstein-pencil.py --check
python3 ../notes/2026-07-28-c682-u22-bockstein-pencil-replay.py
```

The primary script derives the primitive integral Clebsch--Gordan maps,
constructs \(Q_I,\epsilon,\eta_I\), compares their reductions with the
previous section, and Hensel-lifts all \(22\) Grassmann points.  The
independent replay derives the projection from its Vandermonde formula,
reimplements the transvectants, uses reverse pivot charts, and recomputes
the four orbit values and golden affine comparison.

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-28-c682-u22-bockstein-pencil.py` | 28936 | `119ec828992bded6262565e6df70c1bc8e0083b8e556ce980dd1f21874ecf0f8` |
| `2026-07-28-c682-u22-bockstein-pencil.json` | 9899 | `c1bbc4fd62219274598c8ece334fff4c366c6c59d581334c50b06e5d2e173f77` |
| `2026-07-28-c682-u22-bockstein-pencil-replay.py` | 11929 | `2d3a5970fec306811037af132ef6b1545c6f68f71ffad8d5e9b781e39dc384d0` |

## `ej` + `tt` closeout and mystery ledger

- **Closed:** the marked \(\mathbf F_{11}\) section globalizes over the
  corrected tower by the divided order-\(11\) contraction \(Q_I\); no
  arbitrary lifted \(V_3\)-projector is needed.
- **Closed by `ej`:** the primitive projection coefficient is the
  Vandermonde factor
  \((j-i)(k-i)(k-j)/2\), making the construction visibly
  \(\operatorname{SL}_2\)-equivariant and integral.
- **Closed:** the invariant pencil globalizes as
  \((\epsilon,\eta_I)\), with exact special-fibre normalization
  \(\epsilon=7u,\eta_I=8v\).
- **Closed by `ej`:** the first \(11\)-adic digit splits the former
  \(11+11\) sheets into the four orbit sizes \(1,5,10,6\).  The special
  quadratic is the collision
  \((T^2-1)^{11}\), not the full generic quotient.
- **Corrected by `tt`:** raw \(u/v\) is not deck-odd beyond the special
  fibre.  The nonzero midpoint \(11\bmod121\) kills the proposed
  all-order scalar equality.
- **Closed by `tt`:** the centered affine transform of \(u/v\) is
  exactly the local incidence orientation coordinate; it reduces to
  \(w=4u/v\) modulo \(11\).
- **Still open:** construct the same pencil over a characteristic-zero
  Zariski neighborhood rather than the corrected formal
  \(\mathbf Z_{11}\)-neighborhood.  The exact missing gate is an
  algebraic family of invariant dodecics and marked binary charts, not
  another finite-field calculation.
- **Still open:** explain the first-order orbit values
  \(100,43,45,54\) directly from stabilizer geometry or a
  four-point invariant quotient, without Pluecker evaluation.
- **Still open:** decide whether the Bockstein center \(11\) of the
  golden pair is a coordinate-normalization artifact or the local trace
  of a canonical extension class.  Its falsifying and comparison roles
  are proved; its intrinsic arithmetic meaning is not.

C682 remains open; completion is the user's decision.
