# C817 pair-concurrence closure and minimal arity

**Lane:** `clebsch`

**Scope:** C817 subitem 2 only; mathematics freeze, with Paper IV read-only

## Verdict

The pair-only route is positive and strictly stronger than the current
triple-concurrence reconstruction.  Let \(\mathcal H\) be the 364-support
minimum hypergraph and let

\[
 c(x,y)=\#\{S\in\mathcal H:\{x,y\}\subseteq S\}
\]

be its weighted 2-section.  The five off-diagonal values are
\(6,7,8,9,12\).  One coherent refinement splits the two relations fused at
concurrence 6 and recovers all six elliptic relations.  Explicitly, for a
concurrence-6 pair put

\[
 d_7(x,y)=\#\{z:c(x,z)=c(z,y)=7\}.
\]

Then

\[
 d_7(x,y)=
 \begin{cases}
 2,&\rho(x,y)=1,\\
 4,&\rho(x,y)=3.
 \end{cases}
\]

All other elliptic relations already have distinct pair concurrences.  Thus
the full six-color scheme is the first coherent closure of the weighted
2-section.

More strongly, no closure is needed to recover the incidence rows.  The
concurrence-8 relation is exactly \(A_0\), and its 78 neighborhoods are the
78 passant incidence rows.  Hence the weighted 2-section alone reconstructs
\(M\), without the 1716-clique enumeration or any triple concurrence.

Every vertex lies in exactly 56 minimum supports, so the weighted 1-section
is constant.  Reconstruction arity is therefore exactly two: unary data is
trivial, while pair data recovers both the row family and, after one coherent
refinement, the full elliptic scheme.

## Pair-parity recovery of the code and hidden field

The pair layer contains an even cheaper synthesis.  Form the binary matrix

\[
 P_{xy}=c(x,y)\pmod2,\qquad P_{xx}=0.
\]

Only concurrence 7 and concurrence 9 are odd, so the pair table gives

\[
 P=A_{10}+A_{12}=B^2+B^4.
\]

This operator has rank 36 and \(A_0P=0\).  Therefore

\[
 \operatorname{im}P=K=\ker A_0.
\]

Thus the binary code itself is the image of the parity reduction of its
minimum-layer pair-concurrence matrix.  No orbit-spanning argument, coherent
refinement, polarity, or prior incidence matrix is needed to define it from
the abstract minimum hypergraph.

The same single operator recovers the hidden field.  Exact matrix powers give

\[
 P^7=e_K,
 \qquad
 B=P+P^7,
 \qquad
 B^3+B^2+e_K=0.
\]

Hence the weighted 2-section intrinsically reconstructs the code projector,
the distinguished scalar \(\alpha=B\), and

\[
 \mathbf F_2[B]\cong\mathbf F_8.
\]

This synthesizes C817 subitems 1 and 2: the hidden \(\mathbf F_8\)-symplectic
module is already encoded in the parity of minimum-support pair concurrence.

## Pair-only reconstruction theorem

From the abstract weighted graph \((X,c)\), define

\[
 R_m=\{(x,y):x\ne y,\ c(x,y)=m\}
 \qquad(m=6,7,8,9,12).
\]

Then the following objects are intrinsic to \((X,c)\):

1. the two parts of \(R_6\), separated by \(d_7=2\) and \(d_7=4\);
2. all six labeled relations \(A_0,A_1,A_3,A_9,A_{10},A_{12}\);
3. the passant row family
   \(\{R_8(x):x\in X\}\), consisting of 78 distinct seven-subsets; and
4. the automorphism group
   \(\operatorname{Aut}(X,c)=\PGL(2,13)\), of order 2184.

Consequently the minimum hypergraph automorphism group is also
\(\PGL(2,13)\): every hypergraph automorphism preserves \(c\), while the
projective group preserves the complete minimum layer.

## Human proof packet

The exact pair table is

\[
\begin{array}{c|cccccc}
\rho&0&1&3&9&10&12\\ \hline
c&8&6&6&12&7&9.
\end{array}
\]

Only \(A_1\) and \(A_3\) are fused.  The elliptic intersection row for
\(A_{10}^2\) is

\[
 (14,0,2,4,2,4,1)
\]

in relation order \((I,A_0,A_1,A_3,A_9,A_{10},A_{12})\).  Since
pair concurrence 7 is precisely relation \(A_{10}\), this row says that a
pair in \(A_1\) has two common concurrence-7 neighbors and a pair in \(A_3\)
has four.  This proves the displayed splitter.  It is part of the ordinary
length-two-walk signature used by coherent refinement, so every automorphism
of the five-color fusion preserves the split.  Conversely, every automorphism
of the full scheme preserves the fusion.  The two automorphism groups are
therefore equal, and the existing four-anchor rigidity theorem identifies
them with \(\PGL(2,13)\).

For row recovery, polarity sends an internal point
\(P=(x:y:z)\) to the passant line

\[
 P^\perp=(-z:2y:-x).
\]

For an internal point \(Q\),

\[
 Q\in P^\perp
 \iff \beta(P,Q)=0
 \iff \rho(P,Q)=0
 \iff c(P,Q)=8.
\]

Polarity bijects the 78 internal points with the 78 passant lines.  Thus the
neighborhoods in \(R_8\) are exactly the rows of \(M\), up to irrelevant row
order.  This is a direct structural proof once the pair table is known.

Finally, transitivity gives constant vertex degree, and double counting gives

\[
 \frac{364\cdot12}{78}=56.
\]

Thus the weighted 1-section contains no nonconstant reconstruction data,
establishing minimality of arity two.

## Exact evidence and trust boundary

Replay from `rust/`:

```sh
python3 ../notes/2026-08-02-c817-pair-concurrence-closure.py \
  --check ../notes/2026-08-02-c817-pair-concurrence-closure.json
```

The deterministic script constructs all 78 internal points, all 2184
projective transformations, and the four 91-support minimum orbits.  It counts
all pairs in all 364 supports, performs complete coherent signature refinement
on all \(78^2\) ordered pairs until stability, and independently checks the
split by the common-concurrence-7 formula.  It then constructs every passant
line and verifies that the 78 concurrence-8 neighborhoods, the 78 polar
neighborhoods, and the 78 incidence rows are identical as sets of canonical
seven-subsets.  It also reduces the full pair matrix modulo two and verifies
its rank, image containment, seventh-power projector, recovered \(A_9\), and
irreducible cubic identity.  There is no randomness, sampling, or early stop.

The automorphism order uses the already-frozen full-scheme four-anchor
rigidity theorem after the exact closure identifies the full scheme; this
script does not independently enumerate all permutations of 78 points.  The
existing Paper-IV replay independently reconstructs the same 364 supports,
pair table, six relations, row family, and projective automorphism group.  It
was replayed green in the same checkout with

```sh
python3 papers/q13-passant-code/verification/check_q13_tangent_code.py
```

and returned
`omega = 5, d = 12, 364 minimum words, 78 rows recovered,
Aut = PGL(2,13)`.

Evidence files:

- `notes/2026-08-02-c817-pair-concurrence-closure.py` — 12229 bytes,
  SHA-256 `8cfeb472c314e5821fd9eba1d59f934cc084e2c6b1a846954c4ab484c1117e48`;
- `notes/2026-08-02-c817-pair-concurrence-closure.json` — 1333 bytes,
  SHA-256 `a0d46db25200017e3e24cf7138f42ea90322687bcecf4f6495cdc5db373804ba`.

The adjacent checksum manifest freezes the same hashes.

## Required closeout passes

### `ej`

The first free upgrade is stronger than the requested coherent-closure
theorem: the unique concurrence-8 color directly recovers \(A_0\), and
polarity turns its neighborhoods into the incidence rows.  The deeper cheap
synthesis is the parity operator \(P=c\bmod2\): its image is the entire code,
its seventh power is the code projector, and \(P+P^7\) is the hidden
\(\mathbf F_8\) generator.  Thus the pair layer intrinsically reconstructs
\(M\), \(K\), and the field action by two complementary one-line operations.

### `tt`

The statement must distinguish raw pair weights from their coherent closure.
The number 6 alone does not distinguish \(A_1\) from \(A_3\); the splitter is
a global length-two-walk count derived from the weighted 2-section.  Calling
the result “pair-only” is correct because it uses no hyperedge statistic of
arity three, but calling the five raw weights already coherent would be
false.  The automorphism conclusion also retains the existing four-anchor
scheme-rigidity theorem as its final group-identification input.

### `ej2`

The current triple-concurrence histograms and 1716-clique leaf become
non-load-bearing for both scheme and row reconstruction.  They remain useful
as independent descriptive checks, but the causal proof can be reduced to one
intersection number and the polar-neighborhood identity.  This simultaneously
lowers computational trust cost and strengthens the minimal-arity statement.

`aa` was not triggered because the cheapest coherent-closure diagnostic passed
and yielded the stronger direct row-recovery theorem.

## Mystery ledger and novelty gate

- **Settled:** the five-color fusion is not coherent; the exact obstruction is
  \(p_{10,10}^{1}=2\ne4=p_{10,10}^{3}\).
- **Settled by `ej`:** concurrence-8 neighborhoods already are the passant
  rows, while pair parity has image \(K\) and recovers the hidden field via
  \(P^7=e_K\) and \(P+P^7=A_9\).  Neither clique selection, triples, nor orbit
  spanning are required for these reconstructions.
- **Settled by `tt`:** “pair-only” means closure under pair-derived walk
  counts, not separation by the raw concurrence value alone.
- **Settled by `ej2`:** reconstruction arity is exactly two, since every unary
  degree is 56 and the weighted 2-section recovers the full target.
- **Open evidence gap:** the pair-concurrence table still enters through the
  exact four-orbit minimum-layer computation.  A representation-theoretic
  derivation of all five values would be an optional strengthening, not a gap
  in the closure theorem.
- **Novelty:** no publication priority claim is made.  A targeted
  original-source and forward-citation audit is required before manuscript
  positioning.

Preliminary integration value is very high: the theorem is shorter, stronger,
and removes a finite leaf.  Proof page cost is low, trust cost decreases, and
dilution risk is low.  No Paper-IV source or release surface was changed.
