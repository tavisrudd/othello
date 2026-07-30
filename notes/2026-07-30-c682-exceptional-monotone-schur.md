# C682 exceptional monotone signed block Schur complements

Date: 2026-07-30

## Outcome

The twelve exceptional modulo-\(60\) entrances are now organized as four
exact modulo-\(20\) block-transfer families
\[
4_6,\qquad 4_{s,3},\qquad 5_4,\qquad 6_5.
\]
For an entrance \(n=a+20r\), \(r\ge6\), write a free-basis descriptor as
\(F^u h^v g\) and give it the global level
\[
  j=\lfloor v/3\rfloor.
\]
In this ordering the incoming third transvectant is block tridiagonal:
source level \(j\) meets only target levels \(j-1,j,j+1\).  The interior
block sizes are \(4,4,5,6\), respectively.

All backward blocks are invertible at every integral interior level.  Exact
elimination against those blocks leaves fixed signed Schur complements.
Their sizes, indexed by \(s=r\bmod3\), are
\[
\begin{array}{c|ccc}
\rho&s=0&s=1&s=2\\ \hline
4_6&5&6&7\\
4_{s,3}&5&6&7\\
5_4&6&7&9\\
6_5&7&9&11.
\end{array}
\]
Thus the growing multiplicity spaces have been removed from the endpoint
problem.  The exact residual gate is the nonvanishing of these four
three-phase Schur sequences.

The selected endpoint determinants are exactly nonzero for all \(120\)
entrances \(6\le r\le35\).  This is finite evidence, not an all-\(r\)
theorem.  The signed invariant-cone or equivalent global-transfer argument
needed to prove endpoint nonvanishing for every \(r\ge6\) remains open.

## Backward-block factorization

Let \(K_-^{\rho,s}(j)\) be the block from source level \(j\) to target level
\(j-1\), and put
\[
 \det K_-^{\rho,s}(j)
 =c_\rho\prod_{m=-2}^{2}(j-m/3)^{e_{\rho,s}(m)}.
\]
The constant \(c_\rho\) is independent of \(s\), is nonzero, and is stored
exactly in the certificate.  The exponent vectors, in the order
\(m=-2,-1,0,1,2\), are
\[
\begin{array}{c|ccc}
\rho&s=0&s=1&s=2\\ \hline
4,4_s&(1,2,4,3,2)&(1,3,4,3,1)&(2,3,4,2,1)\\
5&(1,3,5,4,2)&(2,4,5,3,1)&(2,3,5,3,2)\\
6&(2,4,6,4,2)&(2,4,6,4,2)&(2,4,6,4,2).
\end{array}
\]
The only zeros are the boundary \(j=0\) and the virtual levels
\(\pm1/3,\pm2/3\).  Hence no integral interior transfer step is singular.

Every block entry has degree at most three in the family and level
parameters.  The determinant therefore has degree at most \(3b\) in each
parameter for block size \(b\).  The checker verifies the displayed
factorizations on exact \((3b+1)\)-by-\((3b+1)\) grids separately in the
three phases.  This proves the identities within the formal degree bounds;
it is not a fitted extrapolation.

## Signed Schur complement

At fixed \(r\), the lower space consists of full level blocks beginning at
level zero and possibly one partial terminal block.  The current space has
the same full blocks and a terminal block larger by one direction.
Order rows and columns by global level, then eliminate source levels
\(1,\ldots,L\) against target levels \(0,\ldots,L-1\) through
\(K_-(1),\ldots,K_-(L)\).

The uneliminated columns are:

- the full source block at level zero;
- the partial source block at level \(L+1\), when present; and
- one fixed endpoint return
  \((\,\cdot\,,F)_9\circ(\,\cdot\,,F)_3\circ(\,\cdot\,,F)_3\).

The uneliminated rows are the full target block at level \(L\) and the
partial target block at level \(L+1\).  Their square matrix is the signed
Schur complement recorded by the certificate.  Since every eliminated
backward block is invertible, its determinant is nonzero exactly when the
selected endpoint return escapes the global incoming image.

The partial source sizes for \(s=0,1,2\) are respectively
\[
\begin{array}{c|c}
\rho&\text{partial source sizes}\\ \hline
4,4_s&0,1,2\\
5&0,1,3\\
6&0,2,4.
\end{array}
\]
This accounts for every Schur size in the first table and explains why the
twelve modulo-\(60\) cases are four modulo-\(20\) transfer types rather than
twelve unrelated failures.

## Finite exact audit and boundary

The primary checker evaluates the signed complements with exact rational
arithmetic for \(6\le r\le35\).  It records the size and sign of every
determinant and hashes the canonical stream of all exact fractions.  None
vanishes.  The independent replay reconstructs the covariant seeds with the
separate dense modular transvectant engine, verifies the global Weyl
transitions out of sample, and reproduces the Schur determinants at all
three phases over two large primes.

What this proves:

- the four exact modulo-\(20\) block-tridiagonal recurrences;
- the all-level backward-block factorizations and their integral
  invertibility;
- the fixed Schur-complement sizes in every phase; and
- exact endpoint nonvanishing on the stated finite interval.

What it does not prove:

- endpoint nonvanishing for every \(r\ge6\);
- closure of the final twelve monotone entrances; or
- identification of the resulting path corner with the algebra of the
  three local returns.

## Reproducibility

From `rust/`, run

```text
python3 ../notes/2026-07-30-c682-exceptional-monotone-schur.py --check
python3 ../notes/2026-07-30-c682-exceptional-monotone-schur-replay.py
```

The primary check uses Python's standard library and the previously
verified exact global-Weyl operator artifact.  The replay uses the separate
dense modular generator/transvectant engine at
\(1000000007\) and \(1000000009\).

| file | bytes | SHA-256 |
|---|---:|---|
| `2026-07-30-c682-exceptional-monotone-schur.py` | 43495 | `8983b31f49c1c91322e5adbe7a2f7e283c64fb780675964f35f60fe5310c1c18` |
| `2026-07-30-c682-exceptional-monotone-schur.json` | 26444 | `b2ce05237a6d4f7080ee1e09f49111d6c4b111e2ba3dfa430793b8a28dbc1adb` |
| `2026-07-30-c682-exceptional-monotone-schur-replay.py` | 5593 | `2e7e6a7b0744d8413e7340cbdc11e9dd3dc98de14b95688ebc7d8bbb97cb7293` |

## `ej` + `tt` closeout

The cheap structural gain is the global level \(j=\lfloor v/3\rfloor\).
It does more than reindex the computation: it turns all twelve phase
failures into four block-tridiagonal families and exhibits the exact
partial-boundary sizes responsible for the phase changes.

The `ej` pass also isolates a uniform interior theorem.  Across all four
modules and all three phases, every backward determinant has roots only at
\(0,\pm1/3,\pm2/3\).  In particular, the residual obstruction is not an
interior singularity, a denominator accident, or a new bad prime.

The `tt` correction is that a long exact prefix cannot be promoted to the
desired theorem.  The invariant object is the moving terminal plane defined
by the signed Schur recursion.  The next proof must control its
transversality to the endpoint-return line, most plausibly by a signed cone
on its Plücker coordinates or a boundary Wronskian comparison.  More
determinant sampling would strengthen evidence but would not change the
logical gate.

## Mystery ledger

- **Settled:** the correct modulo-\(20\) global-level coordinate.
- **Settled:** the four block-tridiagonal recurrences and all twelve phase
  boundary shapes.
- **Settled:** exact backward-block factorizations and absence of every
  integral interior singularity.
- **Settled by `ej`:** the virtual-root set is universally
  \(\{0,\pm1/3,\pm2/3\}\); only multiplicities vary.
- **Settled by finite exact audit:** all selected endpoint determinants are
  nonzero for \(6\le r\le35\).
- **Open:** prove signed Schur endpoint transversality for every \(r\ge6\).
  The exact missing evidence is an invariant cone, Wronskian boundary
  comparison, or equivalent all-length transfer theorem.
- **Settled by the successor indicial analysis:** the \(6_5\) profile is
  phase-independent because every phase has two source chains in each
  \(h\bmod3\) residue.  The \(4,4_s,5\) phases cyclically permute
  unbalanced residue counts.  The formula
  \(\det K_-=C\prod_s(3j+s)_3^{c_s}\) gives every stored multiplicity; see
  `2026-07-30-c682-virtual-levels.md`.

Vibe: the obstruction is now sharply localized and structurally clean, but
the final all-length sign/transversality theorem has not yet landed.

Copyable continuation:

```text
go C682 clebsch prove the all-r signed Schur endpoint transversality for 4_6, 4s_3, 5_4, and 6_5
```
