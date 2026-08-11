# C904 Shen minimal-curve ordering audit

**Date:** 2026-08-10
**Scope:** targeted primary-source audit; no manuscript, Lean, or commit change

## Verdict

**No:** Shen does not prove that the minimal curve \(\eta\) on
\(D_+=F+F\) has an integral ordered lift through \(F\times F\).

What he proves is exactly

\[
 \widetilde\theta\in CH_1(F\times F),\qquad
 (\phi_+)_*\widetilde\theta=2\eta,
\]

where \(\widetilde\theta\) is integral and invariant under swapping the two
factors, while \(-[\eta]\) is the minimal cohomology class.  Dividing the
pushforward by two **downstairs** does not produce a class
\(\zeta\in CH_1(F\times F)\) satisfying \((\phi_+)_*\zeta=\eta\).

Lemma 5.6 proves that \(\phi_+\) has generic degree two.  Since
\(\phi_+(u,v)=\phi_+(v,u)\), its two generic sheets are precisely the two
orderings.  Therefore \(\phi_+\) factors as

\[
 F\times F\xrightarrow{q}\operatorname{Sym}^2F
 \xrightarrow{\bar\phi_+}D_+,
\]

with \(q\) the ordering double cover and \(\bar\phi_+\) birational.  Thus
\(\eta\) is naturally an **unordered downstairs class**.  Generically, each
component meeting the birational locus has a strict transform in
\(\operatorname{Sym}^2F\).  Shen does not state a global integral Chow lift
\(\bar\eta\in CH_1(\operatorname{Sym}^2F)\) with
\((\bar\phi_+)_*\bar\eta=\eta\), nor verify that \(\eta\) avoids the exceptional
locus of \(\bar\phi_+\).

Most importantly, neither Shen nor the source he cites analyzes whether the
restriction

\[
 q^{-1}(\bar\eta)\longrightarrow\bar\eta
\]

is split or connected.  An ordered degree-one lift is exactly the missing
splitting datum.

## Exact source trace

### Theorem 5.1

ArXiv extracted-text lines **1551--1600**, PDF pp. **17--18**:

- The theorem produces a symmetric integral
  \(\theta\in CH_1(F\times F)\).
- In the threefold proof, \(\theta\) is constructed as a sum of self-transpose
  correspondences \(T_i\circ{}^tT_i\).
- There is no statement about \(F\times F\to\operatorname{Sym}^2F\), the
  splitting of an ordering cover, or a degree-one lift of a later minimal
  curve.

Shen's technical meaning of “represented by a symmetric cycle” appears at
extracted-text lines **557--575**, PDF p. **8**.  The discussion explicitly
allows a diagonal part as well as a part descending from the unordered
Hilbert-square locus.  Symmetry is therefore not the same assertion as the
existence of one selected ordering.

### Lemma 5.6

ArXiv extracted-text lines **1865--1910**, PDF p. **21**:

- \(\phi_+(u,v)=\phi(u)+\phi(v)\) has image \(D_+\) of class \(3\Theta\).
- \(\phi_+\) has degree two onto \(D_+\).
- Its proof establishes generic degree two by comparison with the six points
  in a generic fibre of the difference map.

Because swap already gives two points in every generic fibre, degree two
shows that the induced map \(\operatorname{Sym}^2F\dashrightarrow D_+\) is
birational.  It does **not** show that the double cover splits after
restriction to any particular curve in \(D_+\).

The sole external citation in this setup is Clemens--Griffiths
Theorem 13.4 and its proof, used for the **difference** map \(\phi_-\): its
image is the theta divisor and its generic degree is six.  The cached primary
text, extracted lines **5450--5585** (published pp. **347--348**), studies the
double-six description of those six ordered pairs.  It contains no theorem
about the ordering double cover over Shen's later curve \(\eta\).

### Proposition 5.7

ArXiv extracted-text lines **1912--1950**, PDF pp. **21--22**:

1. Shen starts with the ordered symmetric cycle \(\theta\) from Theorem 5.1.
2. He removes its two projection terms to form another symmetric ordered
   cycle \(\widetilde\theta\).
3. His pairing calculation gives the factor two.
4. He then writes
   \((\phi_+)_*\widetilde\theta=2\eta\) for a cycle \(\eta\) supported on
   \(D_+\), and concludes that \(-[\eta]\) is minimal.

The proposition stops there.  It does not introduce a cycle
\(\zeta\) on \(F\times F\) mapping to \(\eta\), a cycle \(\bar\eta\) on
\(\operatorname{Sym}^2F\), the normalization of \(\eta\), or the induced
quadratic extension of its function field.

## What can and cannot be imported

Safe:

- \(2\eta\) has an integral ordered lift, namely \(\widetilde\theta\).
- \(D_+\) is birational to \(\operatorname{Sym}^2F\).
- Away from the exceptional/branch loci, \(\eta\) has an unordered strict
  transform and its ordered inverse image is a degree-two cover.

Not safe without a new proof:

- \(\eta\) itself is the pushforward of an integral cycle on \(F\times F\);
- the ordering cover over its normalization is split;
- one of its ordered components maps with odd degree;
- the class \(q_*\widetilde\theta\) is divisible by two in
  \(CH_1(\operatorname{Sym}^2F)\);
- a global integral strict transform of every component of \(\eta\) exists
  with pushforward coefficient one through the exceptional locus.

## Source ledger

1. **Mingmin Shen, _Rationality, universal generation and the integral
   Hodge conjecture_, arXiv:1602.07331.**  Read depth: **claim-specific
   partial**, Theorem 5.1 and proof, the definition/lemma on symmetric cycles,
   Lemma 5.6 and proof, and Proposition 5.7 and proof.  Cache SHA-256
   `2e0f3a438379830b85e0e63fce9b6d85e621c3e3d1fbbe84a4a6117773c1007c`.
2. **C. Herbert Clemens and Phillip A. Griffiths, _The intermediate Jacobian
   of the cubic threefold_, Ann. of Math. 95 (1972), 281--356.**  Read depth:
   **claim-specific partial**, Section 13 around Theorem 13.4 and the
   double-six proof.  Cache key `10.2307/1970801`, SHA-256
   `6cfe96ecb81179ce2756cb114414d3db1eab46274665c96c582d7f42c7a60a60`.

## Mystery ledger

- **Settled:** Shen provides an ordered lift only for \(2\eta\), not for
  \(\eta\).
- **Settled:** the quotient by swapping is birational to \(D_+\); the missing
  datum is the restricted ordering cover.
- **Open:** whether that cover is connected, split, or ramified on each
  component of the normalization of \(\eta\).  Required evidence: an explicit
  representative for \(\eta\), its strict transform, and the associated
  quadratic function-field extension.
- **Open:** whether a different minimal representative on \(D_+\) can be
  chosen with a split ordering cover.  Shen's theorem is existential and does
  not control this degree of freedom.

**Vibe:** hard boundary, not a hidden lift.  Shen's factor two records exactly
the loss of ordering; removing it is a new arithmetic/Chow problem, not a
corollary of Proposition 5.7.
