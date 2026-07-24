# C574: `MATCH(10,5,1)` rank-three realizability

**Lane:** `relconic`

**Date:** 2026-07-24

**Status:** complete. There are exactly two abstract classes. The classical class is realized in
\(\operatorname{PG}(2,8)\) by the regular hyperoval and is compatible with the prescribed conic;
the Mathon non-hyperoval class is not rank-three realizable over any field, while the classical
class is rank-three realizable over a field exactly when the field has characteristic two and
contains \(\mathbf F_8\). In particular, neither class is rank-three realizable over
\(\mathbf F_{37}\).

## Result

Write \(D_{\mathrm H}\) for the class with automorphism group of order \(1512\), obtained from a
hyperoval in \(\operatorname{PG}(2,8)\), and \(D_{\mathrm M}\) for Mathon's other class, with
automorphism group of order \(216\). The exact answer at the two C558 orders is

| order | \(D_{\mathrm H}\) | \(D_{\mathrm M}\) |
| --- | --- | --- |
| \(q=8\) | realized; conic-compatible | not realized |
| \(q=37\) | not realized | not realized |

Thus the only zero-defect size-ten candidate surviving both the abstract and rank-three gates is
the regular hyperoval in \(\operatorname{PG}(2,8)\). It is genuinely compatible with the relative
conic problem: if
\[
 \mathcal C=\{(t^2:t:1):t\in\mathbf F_8\}\cup\{(1:0:0)\}
\]
and \(N=(0:1:0)\) is its nucleus, then \(A=\mathcal C\cup\{N\}\) is the ten-point hyperoval. The
other \(63\) points of the plane are exactly its five-secant concurrence centres. Consequently
every point outside \(\mathcal C\) is either \(N\in A\) or lies on an \(A\)-secant, so \(A\) is
\(\mathcal C\)-complete and has zero relative defect.

The post-completion `ej` pass gives the exact characteristic obstruction:

- \(D_{\mathrm H}\) has no rank-three realization over any field of odd characteristic;
- \(D_{\mathrm M}\) has no rank-three realization over any field.

The third `ej` pass closes the remaining field-of-definition boundary:
\[
 D_{\mathrm H}\text{ is realizable over }K
 \quad\Longleftrightarrow\quad
 \operatorname{char}K=2\text{ and }\mathbf F_8\subseteq K.
\]
For finite fields, \(D_{\mathrm H}\) is therefore realizable over
\(\mathbf F_{2^m}\) exactly when \(3\mid m\).

## Abstract classification

A `MATCH(10,5,1)` block is a perfect matching of \(K_{10}\). Regard the \(45\) edges of \(K_{10}\)
as points and the \(63\) blocks as five-point lines. The matching axiom makes this a partial
geometry \(\operatorname{pg}(5,7,3)\) in Bose's \(K,R,T\) convention (equivalently
\(\operatorname{pg}(4,6,3)\) in the \(s,t,\alpha\) convention), with point graph
\(\overline{T(10)}\). Mathon's classification gives exactly two isomorphism classes.

The certificate independently constructs concrete representatives through the
Reichard--Woldar overlarge-\(S(3,4,8)\) model. After fixing one affine design on eight points, it
enumerates all \(30\) labeled affine designs on each remaining eight-set and solves the exact
126-block partition problem. There are exactly \(64\) labeled overlarge sets containing the fixed
design. The fixed design's \(\operatorname{AGL}(3,2)\) stabilizer of order \(1344\) has two orbits,
of sizes \(8\) and \(56\). These give automorphism orders
\[
 \frac{9\cdot1344}{8}=1512,\qquad \frac{9\cdot1344}{56}=216.
\]
The generated matching representatives each have \(63\) distinct blocks, every edge has
replication \(7\), and all \(630\) pairs of disjoint edges occur exactly once.

An independent \(\mathbf F_8\) incidence construction uses
\(x^3+x+1\) for the field, constructs the regular hyperoval, and groups its \(45\) secants by
their \(63\) off-hyperoval centres. The resulting matching design is carried to the orbit-eight
representative by the explicit transporter
\[
 (0,1,2,3,4,5,6,7,8,9)\longmapsto(0,1,2,3,5,4,7,6,8,9),
\]
and exhaustive permutation testing finds no transporter to the orbit-56 representative.

## Rank-three obstruction

For either labeled design, normalize four arc points to the projective frame
\[
 P_0=(1:0:0),\quad P_1=(0:1:0),\quad
 P_2=(0:0:1),\quad P_3=(1:1:1).
\]
Every remaining arc point avoids \(P_0P_1\), so write
\(P_i=(x_i:y_i:1)\), \(4\le i\le9\). For a matching block
\(\{\{a_j,b_j\}:1\le j\le5\}\), put
\(\ell_j=P_{a_j}\mathbin{\times}P_{b_j}\). Since the first two secants are distinct in an arc,
the five secants are concurrent exactly when
\[
 \det(\ell_1,\ell_2,\ell_j)=0,\qquad j=3,4,5.
\]
The certificate forms all \(63\cdot3=189\) equations.

For \(D_{\mathrm M}\) in characteristic two, and for both \(D_{\mathrm H}\) and
\(D_{\mathrm M}\) in characteristic \(37\), Gröbner reduction in the normalized chart gives
\[
 x_9-y_9=0,\qquad y_9^2+x_9-2y_9=0.
\]
Hence \(x_9=y_9=t\) and \(t(t-1)=0\). The two possibilities make \(P_9=P_2\) or \(P_9=P_3\),
contradicting distinctness of the arc. Equivalently, adjoining
\[
 u\,x_9(x_9-1)-1
\]
makes the concurrency ideal the unit ideal. Both degree-reverse-lexicographic and lexicographic
replays give the same result. In characteristic two the classical ideal is not the unit ideal,
and the direct \(\mathbf F_8\) hyperoval construction supplies the surviving realization.

The characteristic-two obstruction for \(D_{\mathrm M}\) already excludes that class over every
field of characteristic two, not merely \(\mathbf F_8\).

The second `ej` pass promotes the odd-characteristic probe to a theorem. Over \(\mathbf Q\),
Singular's `lift` expresses both forced relations as combinations of the \(189\) integral
concurrency equations. The two exact \(189\times2\) lift matrices verify the identities, have
SHA-256 hashes recorded in the JSON certificate, and have no denominator prime except \(2\).
The identities therefore reduce over every field of odd characteristic. They force the same
\(P_9=P_2\) or \(P_9=P_3\) degeneration for both abstract classes. Combining this with the
characteristic-two unit-ideal certificate for \(D_{\mathrm M}\) proves that \(D_{\mathrm M}\)
has no rank-three realization over any field.

Finally, the lexicographic characteristic-two basis for \(D_{\mathrm H}\) is triangular. Its first
equation is
\[
 y_9^5+y_9^4+y_9^3+y_9
 =y_9(y_9+1)(y_9^3+y_9+1).
\]
The roots \(0,1\) are exactly the two repeated-frame degeneracies. Thus every arc realization
forces \(y_9^3+y_9+1=0\), whose irreducibility over \(\mathbf F_2\) forces
\(\mathbf F_8\subseteq K\). Conversely, the direct regular-hyperoval construction over
\(\mathbf F_8\), followed by scalar extension, realizes the design over every such \(K\).
The JSON records all twelve equations of the triangular basis.

## Literature record

Opening summary: **0 sources were read at full text; 3 sources were read partially.** The
load-bearing completeness attribution is explicitly secondary because Mathon's primary article
could not be obtained in this session. The exact certificate independently reconstructs the two
classes, but it is not represented as a reading of Mathon's proof.

- Rudolf Mathon, *The partial geometries pg(5,7,3)*, *Congressus Numerantium* 31 (1981),
  129--139, Zbl 0513.05019. **Read depth: abstract/metadata only.** The bibliographic record was
  checked through zbMATH Open and the Congressus Numerantium serial record. The publisher archive
  exposes only recent open-access volumes, automated searches located no scan, and the article has
  no DOI. The proof itself was **NOT REACHED**.
- Brian Alspach and Katherine Heinrich, *Matching Designs*, *Australasian Journal of
  Combinatorics* 2 (1990), 39--55. **Read depth: partial**, published version, abstract and
  Section 1. It defines `MATCH` designs and attributes the exact two-class result to Mathon.
  Cache key `dblp:journals/ajc/AlspachH90`, SHA-256
  `1a9dd6fb3f004d30fd24b6f531e8cd47c950b491768ec3d29b580c01761fedbb`.
- Mustafa Gezek and Vladimir D. Tonchev, *On partial geometries arising from maximal arcs*.
  **Read depth: partial**, arXiv version, Introduction and Section 3. It states the exact two-class
  theorem, describes Mathon's pencil-pair completion method, records automorphism orders
  \(1512,216\), and distinguishes the hyperoval and non-hyperoval classes. Cache key
  `arXiv:2008.13246`, SHA-256
  `66f4d59fd19b3aa4307482b5dc479f22b8287e186f2c451881a9d02e8f9f3189`.
- Sven Reichard and Andrew J. Woldar, *Constructing partial geometries from overlarge sets of
  Steiner systems*, DOI `10.1007/s13366-021-00570-7`. **Read depth: partial**, author preprint,
  Sections 1, 5, and 6 through the indexed ResearchGate text. It gives the overlarge-design model
  used by the certificate and identifies its two outputs with Mathon's classes. The published
  version was not read; OpenAlex reports it closed with no repository full text, and the
  ResearchGate PDF endpoint was not obtainable for cache ingestion.

No absence-of-prior-work or novelty claim is made. MathSciNet and Google Scholar were not covered;
neither is needed for the positive attribution, but neither repairs the missing primary text.

## Reproducibility

The evidence bundle is

- `notes/2026-07-24-c574-match10-rank-three-realizability.py`;
- `notes/2026-07-24-c574-match10-rank-three-realizability.json`;
- `notes/2026-07-24-c574-match10-rank-three-realizability.sha256`.

Replay from `rust/` with Singular 4.4.1:

```bash
nix shell nixpkgs#singular --command \
  python3 ../notes/2026-07-24-c574-match10-rank-three-realizability.py --check
sha256sum -c ../notes/2026-07-24-c574-match10-rank-three-realizability.sha256
```

The JSON contains the two overlarge-design representatives, both \(63\)-block matching designs,
the direct \(\mathbf F_8\) design and transporter, both monomial-order algebraic checks in
characteristics \(2\) and \(37\), and the verified rational lift-matrix hashes and denominator-prime
sets, together with the twelve-equation characteristic-two lexicographic basis. The trusted boundary is exact integer/finite-field arithmetic, canonical exhaustive
enumeration, and Singular Gröbner bases and module lifts. The second monomial order and the
independent direct \(\mathbf F_8\) incidence construction are the replays. The computation does not
claim that Mathon's primary proof was read.

## `ej` + `tt` closeout

The first cheap strengthening exposed by the closeout is the characteristic-two exclusion of
\(D_{\mathrm M}\). The user-requested second pass extracts rational lift matrices whose only
denominator prime is \(2\), upgrading the odd-characteristic probe to the exact theorem that both
classes fail in every odd characteristic and hence that \(D_{\mathrm M}\) fails over every field.
The Tao-style normalization check removed any need
to invoke uniqueness of hyperovals in \(\operatorname{PG}(2,8)\): the direct algebraic obstruction
eliminates the second abstract class, while the explicit regular hyperoval supplies and identifies
the first. The third pass factors the surviving characteristic-two realization scheme and proves
that containing \(\mathbf F_8\) is necessary as well as sufficient.

## Mystery ledger

- **Two abstract classes:** settled computationally and corroborated by three partial secondary
  readings. The primary Mathon article remains an exact source-access gap; obtaining pages
  129--139 is the only way to upgrade the completeness attribution to primary-read depth.
- **Rank-three realizability at \(q=8,37\):** settled. Exactly \(D_{\mathrm H}\) at \(q=8\)
  survives.
- **Conic compatibility:** settled directly for the surviving regular hyperoval.
- **Wider characteristic spectrum:** settled at the characteristic level. Both classes fail in
  odd characteristic; \(D_{\mathrm M}\) also fails in characteristic two and hence over every
  field. The characteristic-two field-of-definition spectrum of \(D_{\mathrm H}\) is also settled:
  precisely the fields containing \(\mathbf F_8\). No genuine realizability mystery remains.
