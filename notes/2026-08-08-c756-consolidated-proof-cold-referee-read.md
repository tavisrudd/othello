# C756 — cold referee read of the consolidated saturated-exterior proof

**Lane:** clebsch · **Date:** 2026-08-08 · **Scope:** independent-style
internal proof read and exact-source check; no manuscript or Lean edits

## Verdict

The consolidated saturated-exterior proof passes this cold read. No
mathematical gap, hidden finite-classification premise, or endpoint exception
was found.

One publication-facing citation defect was found and repaired: the scaled
Segre lemma is **Lemma 12** in the published Ball--Lavrauw paper, not Lemma
11. The published statement has exactly the convention used in the proof:
an arc of size \(q+2-t\), tangent functions of degree \(t\), and
\[
 f_x(y)=(-1)^{t+1}f_y(x).
\]
The former locator evidently followed a prepublication numbering. Every live
C756 occurrence now says “published Lemma 12.”

This is an internal cold read, not a substitute for an external specialist
referee or the outstanding human MathSciNet/Scopus novelty check.

## 1. Source evidence

Ball--Lavrauw, *Planar arcs*, Journal of Combinatorial Theory, Series A 160
(2018), 261--287, DOI
[10.1016/j.jcta.2018.06.015](https://doi.org/10.1016/j.jcta.2018.06.015),
was read at full text in its published pagination.

Persistent literature-cache record:

| field | value |
|---|---|
| key | 10.1016/j.jcta.2018.06.015 |
| pages | 28 |
| extracted words | 11,995 |
| PDF SHA-256 | 03eea855f1b935a2c1fcf6ff96d31e505ca1427f477b0119df951e77a12061b8 |
| status | real PDF, text extracted |

The relevant passage is published §5, “The tangent functions,” immediately
after the definition and scaling of \(f_a\); the displayed symmetry is Lemma
12. This verifies both the locator and the sign convention used in equation
(8) of the consolidated proof.

## 2. Claim-by-claim read

### Matching and parity

- Nonzero pairwise resultants make the \((q+1)/2\) split root pairs disjoint,
  hence a perfect matching of \(\mathbf P^1(\mathbb F_q)\).
- The joins through each arc point exhaust its \((q-1)/2\) passants, so the
  remaining \(t=(q+3)/2\) lines are exactly the arc tangents required by
  Segre's lemma.
- Fixing \(\{0,\infty\}\) puts each other edge across \(S\) and \(N\).
  The fixed-edge determinant makes \(s\phi(s)\) a bijection.
- The resulting complete-mapping sum contradiction is valid exactly when
  \(m=(q-1)/2\) is even, excluding \(q\equiv1\pmod4\).

### Segre normalization

- The canonical tangent product has degree \(m+2=t\) and the correct simple
  zero lines.
- Because \(t\) is odd, the published Segre sign is \(+1\).
- Both fixed-edge evaluations are \(-2s\phi(s)\ne0\), so all scale factors
  are genuinely pinned; there is no pair-dependent rescaling left.
- The comparison first gives the mixed sign (10), and the nonsquare
  cross-resultant then gives the local Paley sign (11). The use of
  \(-1\in N\) in passing to \(f=-\phi\) is correct.

### Local rigidity and Frobenius removal

- The local theorem is used without a simple-spectrum assumption and only
  through one faithful eigenblock.
- Its primitive-Jacobi collision proof has already received the separate
  valuation-normalization audit; this read found no mismatch between that
  theorem's hypotheses and the geometric \(q=p^n\equiv3\pmod4\) regime.
- The \(q=3\) singleton is separated before the faithful-character proof.
- The mixed condition makes \(s\mapsto sf(s)\) a permutation, giving
  \(\gcd(p^j+1,m)=1\).
- In the coset sum, the two roots are distinct by that gcd and lie in \(N\),
  while the summation coset lies in \(S\). The three support points for every
  nontrivial indicator character are distinct. Averaging the trivial
  \(2\)-bound and the nontrivial \(2\sqrt q\)-bounds yields
  \(|H|\le2\sqrt q\).
- For \(j>0\), the elementary lower bound
  \((q-1)/(p^{\gcd(n,j)}-1)>2\sqrt q\) is strict because the quotient length
  is odd and at least three. Thus only the scalar branch remains.

### Hasse and endpoints

- The scalar parameter was renamed \(\nu\) in the consolidated proof to
  avoid collision with the extension degree \(n\).
- The cubic roots \(0,\nu,\nu^{-1}\) are distinct: \(\nu\) is a nonsquare,
  so \(\nu\ne1\), and the \(\nu=-1\) case was separately excluded for
  \(q>3\).
- The character calculation gives \(B_\nu=q-7\), and Hasse leaves exactly
  \(q=3,7,11\) among prime powers congruent to \(3\bmod4\).
- Direct endpoint arithmetic independently reproduces the admissible
  parameters \(3,5\) over \(\mathbb F_7\) and \(2,6\) over
  \(\mathbb F_{11}\); inversion pairs each row into one stabilizer orbit.
- The covering inequality gives \(4<9\) at \((q,k)=(3,2)\) and \(37<49\)
  at \((7,4)\).
- For \(q=11,\nu=2\), the displayed six coefficient points have fifteen
  chords whose union is exactly the 121 projective points of nonzero
  discriminant. This direct endpoint identity was replayed independently.

## 3. Publication boundary

The mathematical package is coherent enough to allocate a companion-paper
task. The allocation should nevertheless retain two explicit safeguards:

1. the local-Paley automorphism/unique-extension theorem remains qualified by
   “to our knowledge” until a human MathSciNet/Scopus search is recorded; and
2. an external finite-geometry/character-sum specialist should cold-read the
   Segre normalization and primitive-Jacobi valuation before submission.

Neither safeguard reopens the proved theorem. Saturated-internal and
nonsaturated conic-filling remain open and must be labeled as partial context,
not absorbed into the companion's conclusion.
