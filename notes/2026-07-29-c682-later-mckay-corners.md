# C682 later McKay corners through degree \(72\)

## Outcome

Degree \(22\) is the unique genuine failure of the full Klein return corner
in the exact bounded range
\[
 \boxed{0\le n\le72.}
\]
Every later apparent deficit of the two upward returns is repaired by the
single nearest downward return.

Write
\[
\begin{aligned}
 U_{1,n}&=\Delta_n^\dagger\Delta_n,\\
 U_{2,n}&=(\Delta_{n+6}\Delta_n)^\dagger
                 (\Delta_{n+6}\Delta_n),\\
 L_{1,n}&=\Delta_{n-6}\Delta_{n-6}^\dagger,
\end{aligned}
\qquad
\Delta=(\,\cdot\,,\Phi_{12})_3.
\]
Then for every \(0\le n\le72\), \(n\ne22\),
\[
 \boxed{\quad
 \langle U_{1,n},U_{2,n},L_{1,n}\rangle
 =\operatorname{End}_{2.A_5}(\operatorname{Sym}^n).
 \quad}
\]
At degrees below \(6\), the absent \(L_{1,n}\) is simply omitted.  At
\(n=22\), adjoining \(L_{1,22}\) leaves the known dimension
\[
 8<10;
\]
the doubled \(3\)-block remains \(\mathbf C^2\), not \(M_2(\mathbf C)\).

This is a bounded classification, not an all-weight uniqueness theorem.

## Apparent deficits and repairs

At both certification primes, the algebra generated only by \(U_1,U_2\)
has the following dimensions.  The last column is the dimension after
adjoining \(L_1\).

| \(n\) | \(\dim\langle U_1,U_2\rangle\) | full commutant | with \(L_1\) |
|---:|---:|---:|---:|
| 22 | 8 | 10 | 8 |
| 26 | 11 | 13 | 13 |
| 30 | 15 | 17 | 17 |
| 31 | 16 | 18 | 18 |
| 41 | 28 | 30 | 30 |
| 42 | 28 | 32 | 32 |
| 46 | 34 | 38 | 38 |
| 50 | 40 | 44 | 44 |
| 51 | 44 | 46 | 46 |
| 60 | 61 | 63 | 63 |
| 61 | 61 | 65 | 65 |
| 62 | 61 | 67 | 67 |
| 66 | 70 | 76 | 76 |
| 70 | 79 | 85 | 85 |
| 71 | 83 | 87 | 87 |
| 72 | 88 | 90 | 90 |

At every other degree in the bounded domain, the modular \(U_1,U_2\) span
already reaches the full commutant dimension and therefore proves
characteristic-zero saturation.  The displayed upward deficits at
\(26,30,31\) are also verified over \(\mathbf Q\).  For the remaining
displayed degrees, only the stronger three-return characteristic-zero
saturation claim is needed or made; equality of the two-prime upward
dimensions with their characteristic-zero dimensions is not inferred.

The first repair, at degree \(26\), is especially instructive.  The
\(3'\)-multiplicity profile at degrees \(20,26,32\) is \(1,2,1\).
Upward straight returns alone preserve two lines, but the return through
degree \(20\) supplies a second noncommuting direction and generates
\(M_2\).  The same two-sided mechanism repairs every displayed later
deficit.

## Why degree \(22\) is different

For the \(3\)-block, the multiplicities at degrees \(16,22,28\) are
\[
 0,\ 2,\ 1.
\]
There is no lower \(3\)-space at all.  Every nonempty closed word must begin
upward; after its first return it factors through the one-dimensional upper
multiplicity space.  Hence every such word lies in
\(\operatorname{span}\{I,A^\dagger A\}\) on the doubled block.  No downward
return can add information because its \(3\)-component is zero.

Later local multiplicity peaks are therefore not automatically
bottlenecks.  They have nonzero lower and upper neighbors, and the two
directions need not preserve the same splitting.  The bounded calculation
shows that they do not: \(L_1\) supplies exactly the missing mixing.

This sharpens the earlier bottleneck lemma.  The \(0,2,1\) pattern at degree
\(22\) is not merely the first member of a family visible in short-return
tables; it is qualitatively one-sided.

## Proof and rank transfer

The calculation uses exact integer polynomial matrices reduced modulo
\[
 p=1\,000\,000\,007>72.
\]
For each degree it constructs \(U_1,U_2,L_1\), closes their unital matrix
algebra, and compares its dimension with
\[
 \sum_\rho m_\rho(n)^2
 =\dim\operatorname{End}_{2.A_5}(\operatorname{Sym}^n),
\]
where the multiplicities come from the exact affine-\(E_8\) recurrence.

Every return word is \(2.A_5\)-equivariant, so its characteristic-zero span
has dimension at most the displayed commutant dimension.  Reduction modulo
a prime not meeting the Fischer denominators cannot increase matrix rank.
Whenever the modular word span reaches the characteristic-zero upper bound,
the characteristic-zero span must have the same dimension.  This proves
saturation, rather than merely suggesting it from modular data.

The degree-\(22\) failure is not inferred from modular rank: it is the prior
characteristic-zero bottleneck theorem.  Exact rational arithmetic also
independently verifies the first three later repairs at degrees
\(26,30,31\).

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-29-c682-later-mckay-corners.py --check
python3 ../notes/2026-07-29-c682-later-mckay-corners-replay.py
```

The primary generator exhausts every integer degree \(0\le n\le72\) modulo
\(1000000007\).  The replay repeats the complete classification modulo
\(1000000009\) and then checks the repairs at \(26,30,31\) with the
independently implemented exact rational engine.

| new file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-29-c682-later-mckay-corners.py` | 5784 | `24df28ce6406450c775819a331c46fae86cc559c00f6880360408c62bd24789c` |
| `2026-07-29-c682-later-mckay-corners-replay.py` | 2424 | `1e2a75f40d886f5c4d95db2f645d632636d4b1fd9718c675635bc8d0e5ddd6d6` |
| `2026-07-29-c682-later-mckay-corners.json` | 5471 | `dc2bdc2ea66ea6199c4639a789d89578e40cf61e25babc684734696bc2ca7a2a` |

The load-bearing modular engine is
`2026-07-28-c682-klein-e8-first-failure-replay.py`, 15046 bytes, SHA-256
`67e08902c944aeaca6eef458107bd6022eb7e3b2cfcaffc1381e5884d516669c`.
The exact replay engine is
`2026-07-28-c682-klein-e8-operator-algebra.py`, 30188 bytes, SHA-256
`53b233ebe6bad4e1bcd6fcd40b20ac2329fabb0d69610ecd375d093826bcf963`.

The certificate proves no statement above degree \(72\).  In particular,
the eventual periodicity of multiplicity peaks does not imply periodicity
of the return algebra, and it is not used as an extrapolation.

## `ej` + `tt` closeout and mystery ledger

- **Closed in the bounded domain:** degree \(22\) is the only full-corner
  failure through degree \(72\).
- **Closed by `ej`:** all fifteen later two-prime upward deficits are
  repaired by one additional word, the nearest downward return \(L_1\),
  which proves characteristic-zero saturation.  Long balanced-word
  enumeration is unnecessary.
- **Settled by `tt`:** later multiplicity peaks are two-sided and should not
  be called bottlenecks merely because straight upward excursions fail.
  Degree \(22\) is exceptional because its lower multiplicity is zero.
- **Still open:** prove that \(U_1,U_2,L_1\) saturate every corner above
  degree \(72\), or locate the first counterexample.  A proof must use the
  finite free-covariant Weyl modules or another all-weight argument; the
  bounded modular sweep cannot decide it.
- **Still open:** if a later full-corner failure exists, classify its
  McKay block and explain why two-sided mixing degenerates there.
- **No other mystery remains inside the certified range.**

C682 remains open; completion is the user's decision.
