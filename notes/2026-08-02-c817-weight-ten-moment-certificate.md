# C817 weight-ten moment and stabilizer certificate

**Lane:** `clebsch`  
**Scope:** C817 subitem 6 only; mathematics freeze, with Paper IV read-only

## Verdict

The final structural-exclusion proposal is positive.  One global moment
identity reduces every hypothetical weight-ten codeword to two exact shapes.
The first dies on four dihedral orbits of four-subsets of a passant line; the
second dies on thirty-three dihedral orbits of the two secant neighbors of a
fixed support point.  The certificate uses only line intersection caps,
secant degrees, and stabilizer actions.  It contains no syndrome
meet-in-the-middle enumeration and covers both local pencil profiles.

The irreducibly finite leaves are small and structural:

- all \(35\) four-subsets of the seven internal points on one normalized
  passant reduce to four \(D_{14}\)-orbits; and
- all \(\binom{35}{2}=595\) pairs of secant neighbors of one normalized
  internal point reduce to thirty-three \(D_{28}\)-orbits.  A pruned
  one-point-per-fibre construction kills every representative before five of
  the seven fibres have been completed.

Thus the existing weight-ten XOR-disjointness leaves can be replaced by a
global moment proof with two compact stabilizer tables.

## Global moment reduction

Let \(S\) be a hypothetical weight-ten codeword support, and let \(n_i\) be
the number of passant lines meeting \(S\) in exactly \(i\) points.  Code
parity makes every occurring \(i\) even.  Every internal point lies on seven
passants, so
\[
 \sum_i i n_i=70.
\]

At a selected point, pencil parity gives secant degree zero or two.  Hence the
secant-join graph induced on \(S\) is a union of cycles and isolated vertices.
Let \(m\) be the number of its cycle vertices.  Its number of secant edges is
\(m\), so the number of passant pairs in \(S\) is \(45-m\).  Counting those
pairs by their unique joining line gives
\[
 \sum_i\binom{i}{2}n_i=45-m.
\]
Subtracting half the incidence equation yields
\[
 4n_4+12n_6+24n_8+\cdots=10-m.                 \tag{*}
\]

The right side is at most ten.  Thus no \(n_i\) with \(i\ge6\) occurs, and
\(m\in\{2,6,10\}\).  Two degree-two vertices cannot form a union of cycles,
so exactly two shapes remain:

\[
\begin{array}{c|c|c}
m&(n_2,n_4)&\text{global shape}\\ \hline
6&(33,1)&\text{four isolated vertices on the unique 4-line, plus six cycle vertices}\\
10&(35,0)&\text{ten cycle vertices; every passant meets }S\text{ in }0\text{ or }2
\end{array}
\]

This global dichotomy is strictly sharper than the local \(s=0\) and \(s=2\)
profiles.  In the \(m=6\) case, every isolated vertex must lie on a four-point
passant; uniqueness of that line puts all four isolated vertices on the same
line.  Every cycle vertex is passantly joined to all four.

## The four-set leaf for \(m=6\)

The stabilizer of a passant line acts effectively as \(D_{14}\) on its seven
internal points.  After cyclic labeling, its four orbits on four-subsets have
the following representatives.  The set \(X\) consists of all internal points
passantly joined to the four fixed points; allowing the three unused points
of the fixed line only enlarges \(X\), so this is a safe relaxation.

\[
\begin{array}{c|c|c|c|c}
\text{representative}&\text{orbit size}&|X|&
 \text{secant degrees in }X&
 \#\{Y\subseteq X:|Y|=6,\ G_{\rm sec}[Y]\text{ is 2-regular}\}\\ \hline
0123&7&7&(3,3,4,4,4,4,4)&0\\
0124&14&3&(0,0,0)&0\\
0134&7&5&(2,2,2,4,4)&0\\
0135&7&5&(2,2,2,3,3)&0
\end{array}
\]

The four orbit sizes sum to \(35\).  None supplies the six cycle vertices
required by \((*)\), so \(m=6\) is impossible.  This removes the old
\(s=0\) XOR certificate entirely.

## The secant-pair leaf for \(m=10\)

Fix a selected point \(P\).  Its support companions consist of one point in
each of the seven six-point passant fibres and two points among its \(35\)
secant neighbors.  The stabilizer
\(G_P\cong D_{28}\) has thirty-three orbits on the \(595\) unordered secant
pairs:
\[
 5\text{ orbits of size }7,qquad
 16\text{ of size }14,qquad
 12\text{ of size }28.
\]

For one representative of each orbit, add one point from each passant fibre,
rejecting a prefix as soon as either

1. a passant line contains three selected points, or
2. a selected point has more than two secant neighbors.

At completion every selected point would have to have secant degree exactly
two.  The complete prefix certificate is summarized by the last surviving
depth:
\[
\begin{array}{c|rrrrr}
\text{last nonzero depth}&0&1&2&3&4\\ \hline
\text{pair mass}&28&35&91&238&203
\end{array}
\]
The masses sum to \(595\).  No orbit survives the fifth fibre, well before
the seven-fibre support is complete.  The adjacent JSON records the
representative, orbit size, pair type, and exact survivor count at every
depth for all thirty-three orbits.  Thus \(m=10\) is impossible.

The search space here is not the old \(6^7\binom{35}{2}\) syndrome domain.
Stabilizer reduction is performed first, and the branch test uses only the
two human conditions above.  The complete replay visits a tiny prefix tree
for each of thirty-three representatives.

## Failure boundary for simpler duals

Before the moment route, two cheaper dual shapes were tested exactly.

A binary linear functional on the \(78\)-bit syndrome that is constant one on
a profile would have to be constant on every passant fibre, and in the
\(s=2\) case also on all secant neighbors.  The coefficient/augmented ranks
are
\[
 \begin{array}{c|cc}
 &\operatorname{rank}A&\operatorname{rank}[A|b]\\ \hline
 s=0&32&33\\
 s=2&34&35
 \end{array}
\]
so neither profile admits such a linear separator.

The next Boolean degree also fails as a common route.  Lift a syndrome to its
\(78\) linear and \(\binom{78}{2}\) quadratic monomials.  Already a canonical
\(596\)-element subset of the \(s=2\) family has coefficient rank \(595\) and
augmented rank \(596\).  Hence no quadratic polynomial can be constantly one
on the full \(s=2\) syndrome family while vanishing at zero.  These exact
rank gaps explain why the successful certificate must use global geometric
moments rather than a low-degree syndrome separator.

## Exact evidence and trust boundary

Replay from `rust/`:

```sh
python3 ../notes/2026-08-02-c817-weight-ten-moment-certificate.py \
  --check ../notes/2026-08-02-c817-weight-ten-moment-certificate.json
```

The deterministic standard-library script constructs all \(2184\) elements
of \(\PGL(2,13)\), all \(78\) internal points and passant lines, and the
complete line-type relation.  It verifies the moment solutions, all \(35\)
four-subsets on a normalized passant, the four line-stabilizer orbits, all
\(595\) normalized secant-neighbor pairs, the thirty-three point-stabilizer
orbits, and every pruned prefix.  It also verifies the linear and quadratic
rank obstructions.  There is no sampling, floating point, package dependency,
or early stop.

The C723 primary and independent checkers provide a genuinely independent
replay: they reconstruct the geometry separately and exclude the two original
local profiles by disjoint syndrome sets and a different dynamic program.
The new certificate shares neither their search decomposition nor their XOR
test.  Agreement therefore cross-checks the same weight-ten conclusion across
binary-incidence and global-geometric proof modes.

Evidence files:

- `notes/2026-08-02-c817-weight-ten-moment-certificate.py` — 16728 bytes,
  SHA-256
  `1af8b7d283488131256a7d014d53e87ae57114868d92c6ceb1daebb3e63e2043`;
- `notes/2026-08-02-c817-weight-ten-moment-certificate.json` — 14364 bytes,
  SHA-256
  `2b94c8a8d0a9ed1559f93753a6f2a541afba5b0b940572e63640b5df9843b162`;
- `notes/2026-08-02-c817-weight-ten-moment-certificate.sha256` — checksum
  manifest.

The JSON is canonical, sorted, deterministic, and checked byte-for-byte by
`--check`.  The finite leaves certify only the exact \(q=13\) line-type
geometry; no uniform weight-ten theorem is claimed.

## Novelty boundary

No novelty or priority claim is made.  Double-counting line moments and
stabilizer-orbit reductions are standard methods.  The exact two-shape
compression and the small orbit certificates for this passant code have not
received the task-wide original-source and forward-citation audit required
before publication positioning.

## Required closeout passes

### `ej`

The free upgrade is the global identity \((*)\).  It fuses the two local
profiles into a complete line-intersection census and shows that every
weight-ten obstruction is owned by one of two homogeneous shapes.  In
particular, the \(s=0\) branch is no longer a six-million-support syndrome
problem: it is four dihedral four-set types.

### `tt`

The decisive move is to count the same support twice before choosing a base
point.  Total incidences and passant pairs expose the integer slack
\(10-m\), whose divisibility by four forces \(m=6\) or \(10\).  Only after
this global compression should one normalize a line or point.  The resulting
stabilizer tables are proof leaves, not discovery-scale searches.

### `ej2`

The linear and quadratic rank failures locate the exact obstruction to a
small syndrome dual, while the successful moment identity lives one level
above the syndrome coordinates.  Thus the old near-injective XOR maps are
not the hidden explanation.  The true compression is the coupling between
even line intersections and the zero-or-two secant graph, with the two
dihedral normalizers supplying the finite endpoints.

### `aa`

The first linear-dual route failed for both profiles, and a quadratic common
separator already fails on \(596\) canonical \(s=2\) syndromes.  Distinct
alternatives were then tested: raw secant-degree feasibility survives, a
global line-moment reduction succeeds, the \(m=6\) line-normalizer branch
closes on four orbits, and the \(m=10\) point-normalizer branch closes on
thirty-three orbits.  The last route is the accepted exact alternative.

## Mystery ledger

- **Settled:** the local \(s=0/s=2\) split globalizes to exactly two shapes,
  \((m,n_2,n_4)=(6,33,1)\) and \((10,35,0)\).
- **Settled by `ej`:** the \(s=0\) finite leaf collapses to four
  \(D_{14}\)-orbits of four points on one passant.
- **Settled by `tt`:** the common obstruction is the integer moment slack
  \(10-m\), not a characteristic-\(13\) tangent product or a binary syndrome
  collision.
- **Settled by `ej2`:** exact rank gaps rule out linear and quadratic common
  syndrome separators and explain why the geometric moment layer is needed.
- **Settled by `aa`:** both global shapes close under distinct normalized
  stabilizers, yielding one moment-and-orbit proof of the two profiles.
- **Residual compression gap:** the thirty-three point-stabilizer rows die by
  depth at most four, but no basis-free Terwilliger identity replacing that
  small table has been found.  The table is complete and non-load-bearing for
  any broader field; a future formula would improve elegance, not validity.
- **Open novelty gate:** no publication novelty is asserted.  Any manuscript
  positioning still requires the task-wide original-source and
  forward-citation audit.
- **Next owning gate:** task-wide C817 closeout: novelty boundary,
  integration-options memo, final `ej`+`tt` pass, and explicit stop before
  manuscript changes.

No Paper-IV manuscript, Lean source, or release file was changed.
