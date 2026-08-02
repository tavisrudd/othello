# C817 exact weight-eight theta certificate

**Lane:** `clebsch`  
**Scope:** C817 subitem 5 only; mathematics freeze, with Paper IV read-only

## Verdict

The spectral-obstruction proposal is positive.  The \(42\)-vertex tangent
graph \(\Gamma\) has
\[
 \omega(\Gamma)=\vartheta(\overline\Gamma)=5.
\]
An explicit integral block-circulant matrix \(C\) has diagonal \(40\), entry
\(-10\) on every edge of \(\Gamma\), and \(C\succeq0\).  Therefore a clique
with characteristic vector \(v\) and size \(c>0\) satisfies
\[
 0\le v^{\mathsf T}Cv
   =40c-20\binom c2
   =10c(5-c),
\]
so \(c\le5\).  The known five-clique proves sharpness.  Equivalently,
\(S=C/10\), with diagonal \(4\) and edge entry \(-1\), is an exact dual
Lov\'asz-theta certificate of value \(5\) for \(\overline\Gamma\).

This replaces both the subset enumeration and the five-row unique-closure
leaf in the weight-eight exclusion.  A hypothetical weight-eight word would,
after fixing one support point, require a seven-clique in \(\Gamma\); the
displayed quadratic-form inequality rules this out immediately.

## The certificate

Use the frozen vertex order
\[
 A_0,\ldots,A_{13},B_0,\ldots,B_{13},C_0,\ldots,C_{13}.
\]
Write \(C=(C_{ab})_{0\le a,b\le2}\) in \(14\)-by-\(14\) blocks.  The upper
blocks are circulant with the following first rows, the lower blocks are their
transposes, and the diagonal rows are symmetric:

\[
\begin{array}{c|rrrrrrrrrrrrrr}
00&40&9&8&-8&-10&0&-10&-2&-10&0&-10&-8&8&9\\
01&7&6&6&6&7&-1&-10&-10&-8&0&-8&-10&-10&-1\\
02&0&-10&2&-10&0&3&2&9&2&4&2&9&2&3\\
11&40&15&10&10&-6&-3&-10&-22&-10&-3&-6&10&10&15\\
12&-13&3&0&-10&8&-10&-10&14&-10&-10&8&-10&0&3\\
22&40&-9&-10&19&-10&2&8&-12&8&2&-10&19&-10&-9
\end{array}
\]

Comparison with the six difference rows defining \(\Gamma\) gives diagonal
\(40\) and edge entry \(-10\) by inspection.  Positive semidefiniteness has
the following compact exact proof.  The characteristic polynomial is
\[
\begin{aligned}
\chi_C(x)={}&x^{14}(x^2-94x+279)(x^2-26x+135)\\
&\cdot
(x^6-247x^5+22466x^4-910807x^3
  +15948097x^2-111043270x+189747571)^2\\
&\cdot
(x^6-533x^5+105578x^4-9736765x^3
  +438572569x^2-9062718662x+68467048091)^2.
\end{aligned}
\]
Every nonzero factor has alternating coefficients with positive absolute
values.  Hence substituting \(x=-t\), \(t\ge0\), gives a strictly positive
polynomial.  Since \(C\) is real symmetric, all its eigenvalues are real;
none is negative.  Thus \(C\succeq0\), with rank \(28\) and nullity \(14\).
The exact replay independently verifies the same conclusion by rational Schur
elimination with twenty-eight positive pivots.

The characteristic factorization is reconstructed without floating point.
The three cyclic Fourier blocks are multiplied in
\(\mathbf Z[z]/(z^{14}-1)\); their identity coefficients give all forty-two
power traces, and Newton identities give \(\chi_C\).  No numerical SDP solver
or algebra package belongs to the evidence path.

## Equality and the fourteen maximum cliques

Let
\[
 K_0=\{A_0,B_6,B_{12},C_1,C_3\}
\]
and let \(K_t\) be its fourteen simultaneous translates.  Their
characteristic vectors are linearly independent because \(A_t\) occurs in
exactly the column for \(K_t\).  Direct block multiplication gives
\[
 C\mathbf1_{K_t}=0
 \qquad(0\le t<14).
\]
Since \(C\) has nullity \(14\), these vectors form a basis of \(\ker C\).

If \(K\) is any five-clique, equality in the theta inequality forces
\(\mathbf1_K\in\ker C\).  Write
\[
 \mathbf1_K=\sum_t a_t\mathbf1_{K_t}.
\]
Looking at the \(A_t\)-coordinate gives
\(a_t=\mathbf1_K(A_t)\in\{0,1\}\), while summing all coordinates gives
\(5=5\sum_ta_t\).  Exactly one coefficient is therefore one.  Hence the
fourteen translates \(K_t\) are all maximum cliques.  The theta certificate
thus explains both the upper bound and the previously finite fourteen-clique
classification.

## Exact evidence and trust boundary

Replay from `rust/`:

```sh
python3 ../notes/2026-08-02-c817-weight-eight-theta-certificate.py \
  --check ../notes/2026-08-02-c817-weight-eight-theta-certificate.json
```

The deterministic standard-library script reconstructs all \(1764\) entries
of \(C\) and \(\Gamma\), checks every edge entry, verifies all fourteen
translated cliques and their kernel vectors, computes their exact rank,
reconstructs the complete characteristic polynomial by cyclic Fourier traces,
and performs an independent exact rational Schur elimination.  There is no
sampling, floating point, package dependency, or early stop.

The prior C722 checker independently constructs \(\Gamma\) from the six
difference sets and verifies its integral and Fourier power traces.  C722's
negative conclusion concerned raw adjacency spectra, inertia, and coloring;
it did not optimize the nonedge entries of a theta dual.  The new matrix is
precisely that missing positive-semidefinite completion.

Evidence files:

- `notes/2026-08-02-c817-weight-eight-theta-certificate.py` — 11140 bytes,
  SHA-256
  `38d4cbb937213f2d0dc18b1dbc37a95cda819aef875b6ff9aa27c7625e0cfbb0`;
- `notes/2026-08-02-c817-weight-eight-theta-certificate.json` — 3675 bytes,
  SHA-256
  `e5a9111c688494473aa4a9ce19a32a0eba66c90c97277305f1d69526f8690f15`;
- `notes/2026-08-02-c817-weight-eight-theta-certificate.sha256` — checksum
  manifest.

The JSON is canonical, sorted, deterministic, and checked byte-for-byte by
`--check`.  The evidence certifies the exact local graph theorem at \(q=13\);
it does not assert a uniform theta formula for other fields.

## Novelty boundary

No novelty or priority claim is made.  Lov\'asz theta duality and cyclic
Fourier diagonalization are standard.  The particular sharp completion for
the Paper-IV tangent graph and its kernel classification have not received
the task-wide original-source and forward-citation audit required before
publication positioning.

## Required closeout passes

### `ej`

Sharpness identifies the entire equality face.  The kernel is exactly the
span of the fourteen translated five-cliques, and their unique \(A_t\)
coordinates turn the spectral equality condition into a one-line
classification of all maximum cliques.  Thus the certificate replaces not
only the upper-bound enumeration but also the five-row unique-extension leaf.

### `tt`

The earlier adjacency spectrum was the wrong invariant: it fixes all
nonedges at zero.  Theta asks for a positive-semidefinite completion with only
the diagonal and edge entries prescribed.  The cyclic symmetry reduces this
to six first rows, while the translated clique orbit forces the
fourteen-dimensional kernel.  This is why the optimized certificate reaches
five although every raw spectral and inertia bound stopped much higher.

### `ej2`

The matrix \(S=C/10\) is simultaneously a theta dual, a strict vector
five-coloring Gram matrix, and an equality classifier.  Its nullspace is not
an accidental numerical defect: it is the cyclic module generated by the
maximum-clique vector.  The weight-eight obstruction and the exact maximum
clique orbit therefore become two shadows of one rank-\(28\) positive form.

`aa` was not triggered.  Raw adjacency spectra had failed in C722, but the
primary subitem-5 menu explicitly included Lov\'asz theta and
symmetry-reduced semidefinite certificates; that route passed its first
numerical falsifier and then its exact rational gate.

## Mystery ledger

- **Settled:** \(\omega(\Gamma)=\vartheta(\overline\Gamma)=5\), by an exact
  rank-\(28\) integral certificate rather than enumeration.
- **Settled by `ej`:** the fourteen translated witnesses are all maximum
  cliques, because they form a basis of the theta kernel.
- **Settled by `tt`:** C722's weak raw spectrum is compatible with the sharp
  result; the missing freedom was the nonedge completion in the theta dual.
- **Settled by `ej2`:** the theta equality module is exactly the cyclic
  maximum-clique module, explaining the nullity fourteen and the orbit count.
- **Open conceptual gap:** the displayed rational point in the theta face is
  compact and exact but not yet characterized as a canonical expression in
  the elliptic association algebra.  The cheapest remaining test would seek
  a basis-free formula from the translated-clique projector and the three
  orbit idempotents; this is optional and does not affect the proof.
- **Open novelty gate:** no publication novelty is asserted.  Any manuscript
  positioning still requires the task-wide original-source and
  forward-citation audit.
- **Next owning gate:** C817 subitem 6, a Terwilliger or exact-dual exclusion
  of both weight-ten pencil profiles.

No Paper-IV manuscript, Lean source, or release file was changed.
