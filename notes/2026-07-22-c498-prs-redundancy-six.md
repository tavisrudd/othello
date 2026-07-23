# C498 — PRS(q−5) redundancy-six census and corrected entry geometry

**Lane:** `reed-solomon` · **Date:** 2026-07-22 · **Status:** computational calibration complete;
split-member theorem and exceptional-net classification remain open.

## Result

For the quintic normal rational curve
\[
 C=\{(1,t,t^2,t^3,t^4,t^5):t\in\mathbf F_q\}\cup\{(0,0,0,0,0,1)\}
 \subset\mathbf P^5(\mathbf F_q),
\]
an exhaustive census was run for every prime power
\[
q\in\{7,8,9,11,13,16,17,19,23,25,27\}.
\]
In every field, the points outside all spans of four distinct points of \(C\) are exactly the
points whose Hankel-kernel net contains no totally split squarefree binary quartic.  Every such
point lies in a span of five distinct points of \(C\).  Thus the covering radius is exactly
\(\rho=5\) throughout the searched domain, including \(q=7,8\), below the \(q\ge9\)
Seroussi--Roth sufficient range.

The deep set has two strata:

1. A persistent degree-two-gcd stratum of exactly
   \[
   \frac{q(q+1)^2}{2}
   \]
   points in every searched field.  Its common quadratic is either a rational square (the
   tangent family) or irreducible (the sigma-secant family).  This is the redundancy-four
   tangent/secant problem embedded through the full binary-quadratic cofactor system.
2. A trivial-gcd exceptional stratum.  Its PGL2-orbit counts are
   \[
   18,11,4,2,1,0,0,0,0,0,0
   \]
   at \(q=7,8,9,11,13,16,17,19,23,25,27\), respectively.  In particular, the C491 pattern
   does **not** recur at \(q=17,19\): no exceptional net occurs anywhere in the searched band
   \(16\le q\le27\).

This is a bounded theorem.  It neither proves that exceptional nets never recur above 27 nor
supplies the asymptotic split-member bound.

## Exact census

| \(q\) | PG(5,q) points | deep points | PGL2 orbits | PGammaL2 orbits | gcd-2 points | trivial-gcd points |
|---:|---:|---:|---:|---:|---:|---:|
| 7 | 19,608 | 5,376 | 20 | 20 | 224 | 5,152 |
| 8 | 37,449 | 5,037 | 13 | 7 | 324 | 4,713 |
| 9 | 66,430 | 2,250 | 8 | 5 | 450 | 1,800 |
| 11 | 177,156 | 1,584 | 4 | 4 | 792 | 792 |
| 13 | 402,234 | 1,820 | 3 | 3 | 1,274 | 546 |
| 16 | 1,118,481 | 2,312 | 2 | 2 | 2,312 | 0 |
| 17 | 1,508,598 | 2,754 | 2 | 2 | 2,754 | 0 |
| 19 | 2,613,660 | 3,800 | 4 | 4 | 3,800 | 0 |
| 23 | 6,728,904 | 6,624 | 2 | 2 | 6,624 | 0 |
| 25 | 10,172,526 | 8,450 | 3 | 3 | 8,450 | 0 |
| 27 | 14,900,788 | 10,584 | 2 | 2 | 10,584 | 0 |

The variation in PGL2 orbit count inside the persistent stratum over non-prime fields is recorded
exactly in the JSON certificate; the tangent/sigma description is geometric and does not assert
that each is always one PGL2 orbit.

## Method and internal checks

The Rust generator constructs each finite field in a fixed polynomial basis and performs two
complete, independent scans of \(\mathbf P^5(\mathbf F_q)\):

- **Definition scan:** mark the union of the spans of every four-element subset of \(C\).
- **Hankel scan:** for \(f=(a_0,\ldots,a_5)\), form
  \[
  H_f=\begin{pmatrix}
  a_0&a_1&a_2&a_3&a_4\\
  a_1&a_2&a_3&a_4&a_5
  \end{pmatrix}
  \]
  and test every projective member of its kernel for four distinct roots in
  \(\mathbf P^1(\mathbf F_q)\).

The two deep sets must agree element-for-element.  The generator then:

- closes every deep point under three PGL2 generators and requires the orbits to partition the
  deep set;
- checks orbit-size divisibility in \(|\mathrm{PGL}_2(q)|=q^3-q\);
- computes Frobenius fusion, representative factor labels, net gcd degree, and the complete
  quartic-member histogram;
- requires zero totally split squarefree members in every recorded deep representative net; and
- checks **every** deep point, not merely each representative, for membership in a five-point
  NRC span.

All assertions pass in all eleven fields.

## Independent replay and trusted boundary

The Python replay shares no finite-field or linear-algebra code with the Rust generator.  For
\(q\le16\) it directly rebuilds the union of all four-point spans from the definition, recovering
the exact deep count.  It also independently reconstructs every recorded PGL2 orbit, Hankel net,
Frobenius link, stabilizer order, net gcd degree, and a five-span witness for every orbit
representative.

For the extra-juice extension \(q\in\{17,19,23,25,27\}\), the same Python replay checks all those
structural and representative-level claims and that the recorded orbit union has the stated size,
but skips its slower independent four-secant marking.  Exhaustiveness there rests on the Rust
generator's elementwise definition/Hankel agreement.  This boundary is deliberate and is not
described as a second exhaustive implementation.

From the repository root:

```sh
rustc -O notes/2026-07-22-c498-prs-deep-hole-census.rs -o /tmp/c498-census
C498_JSON_OUT=/tmp/c498-census.json /tmp/c498-census
cmp /tmp/c498-census.json notes/2026-07-22-c498-prs-deep-hole-census.json
python3 notes/2026-07-22-c498-prs-deep-hole-replay.py
python3 notes/2026-07-22-c498-prs-deep-hole-replay.py \
  --fields 17,19,23,25,27 --skip-direct
(cd notes && sha256sum -c 2026-07-22-c498-prs-redundancy-six.sha256)
```

The computation is deterministic, uses no randomness, and depends only on `rustc` and the Python
standard library.  Field moduli and all enumeration conventions are embedded in both programs.

## Ledger correction: the persistent gcd is always quadratic

C491 §9 called the uniform tangent/secant stratum the “degree \(r-3\) gcd” stratum.  That is true
at \(r=5\) only because \(r-3=2\).  If the Hankel kernel has vector dimension \(r-3\) and a common
factor of degree \(d\), its cofactor space has dimension at most \(r-1-d\).  Therefore
\[
r-3\le r-1-d,\qquad d\le2.
\]
Equality \(d=2\) gives the full binary-quadratic cofactor system.  Thus the tangent/sigma-secant
stratum persists at every redundancy through a **quadratic** common factor, not a degree-\(r-3\)
factor.

## Corrected theoretical entry gate

The original C498 card proposed a direct replacement of C491's fiber-square curve by a
fiber-square surface.  That is insufficient: for a quartic, two rational roots can leave an
irreducible quadratic.

For a trivial-gcd net \(W\subset H^0(\mathbf P^1,\mathcal O(4))\), the correct intrinsic object is
the basepoint-free morphism
\[
\phi_W:\mathbf P^1\longrightarrow\mathbf P(W^\vee)\cong\mathbf P^2.
\]
A net member is the pullback of a line.  On the open locus of three distinct points with
nondegenerate images, the surface
\[
T_W=\{(t_1,t_2,t_3)\in(\mathbf P^1)^3:
\det(\phi_W(t_1),\phi_W(t_2),\phi_W(t_3))=0\}
\]
parametrizes a rational line containing three rational points of the pulled-back divisor; its
fourth residual point is automatically rational.  Hence an \(\mathbf F_q\)-point of \(T_W\)
off the diagonals, ramification locus, and image-degeneracy locus gives a totally split squarefree
member.  Equivalently, one may use the discriminant double cover of the ordered-pair surface.

The determinant is alternating.  After division by the three pairwise brackets
\([t_1t_2][t_1t_3][t_2t_3]\), its residual equation has multidegree \((2,2,2)\) on
\((\mathbf P^1)^3\).  Thus a smooth residual trisecant surface is a K3 surface.  Because the
residual equation is symmetric, it descends through
\(\operatorname{Sym}^3(\mathbf P^1)\cong\mathbf P^3\) to a quadric; rational points upstairs,
rather than arbitrary rational degree-three divisors downstairs, encode three rational roots.
On the smooth stratum, the K3 cohomological estimate has the concrete shape
\[
\left|\#T_W(\mathbf F_q)-(q^2+1)\right|\le 22q,
\]
before subtracting the explicitly bounded bad curves.  Singular or reducible \((2,2,2)\)
surfaces are therefore the natural home of the exceptional-net classification.

The proof gate is therefore:

1. factor the determinant by the three pairwise diagonal factors and determine the residual
   \((2,2,2)\) trisecant surface;
2. prove its geometric irreducibility, or classify every reducible/non-geometrically-irreducible
   case, using the alternatives in
   \(4=\deg(\phi_W)\deg(\phi_W(\mathbf P^1))\), especially double covers of conics;
3. bound the rational points lost to diagonals, ramification, and non-squarefree line sections;
4. apply an explicit Lang--Weil/Chebotarev bound to the surviving surface.

This correction is load-bearing.  The census calibrates the exceptional locus but does not
substitute for those four steps.

## Extra-juice and Tao closeout

The cheap field extension settled the immediate C491 analogy: redundancy-five sporadics reappear
at 17 and 19, whereas redundancy-six trivial-gcd exceptional nets do not.  The clean vanishing
from 16 through 27 makes a true geometric/point-bound threshold more plausible, but gives no
license to promote 16 to a theorem.

The Tao pass found that plane-quartic line sections are the natural language and that a plain
fiber-square loses the residual quadratic splitting condition.  This turns the next step from a
generic point-count exercise into a precise irreducibility-and-degeneracy classification.  The
Vandermonde quotient further identifies the generic surface as a \((2,2,2)\) K3, giving a concrete
\(22q\) error term rather than an unspecified Lang--Weil constant.

## Mystery ledger

Settled in this chunk:

- **Do exceptional nets reappear at 17 or 19, as C491 sporadics do?** No; the exhaustive Rust
  census finds none at 17 or 19, nor at 23, 25, or 27.
- **Why did the C491 ledger predict gcd degree 3 at redundancy six?** The dimension inequality
  forces \(d\le2\); the old formula accidentally agreed only at redundancy five.
- **Is the fiber-square surface the correct quartic analogue?** No; the trisecant surface (or a
  discriminant double cover of the ordered-pair surface) is required.
- **What surface does the corrected construction produce?** After removing the three diagonal
  factors it is a symmetric \((2,2,2)\) surface, generically K3, with quadric quotient in
  \(\operatorname{Sym}^3(\mathbf P^1)\).

Open:

- **Intrinsic classification of the 18/11/4/2/1 exceptional orbit sets.** The JSON records complete
  representatives and net-member histograms, but no normal-form theorem yet.  Owner: C498,
  after factoring and stratifying the trisecant determinant.
- **Uniform vanishing threshold.** Exact evidence covers only the stated eleven fields.  Owner:
  C498's explicit surface point bound.
- **Persistent-stratum PGL2 splitting over extension fields.** The geometric tangent/sigma
  dichotomy is clear, but the arithmetic splitting into 4 or 3 PGL2 orbits at q=9,19,25 has not
  yet been expressed by an intrinsic square/trace invariant.  Owner: C498 exceptional-net
  classification stage if needed for the final PGammaL theorem.

## Artifacts

- `2026-07-22-c498-prs-redundancy-six.md` — this report.
- `2026-07-22-c498-prs-deep-hole-census.rs` — primary exhaustive generator (37,556 bytes).
- `2026-07-22-c498-prs-deep-hole-census.json` — canonical orbit certificate (27,077 bytes).
- `2026-07-22-c498-prs-deep-hole-replay.py` — independent Python replay (12,785 bytes).
- `2026-07-22-c498-prs-redundancy-six.sha256` — SHA-256 manifest.
