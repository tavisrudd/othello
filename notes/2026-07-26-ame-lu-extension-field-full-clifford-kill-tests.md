# Extension-field full-Clifford kill tests

**Date:** 2026-07-26

## Result

The first in-scope extension field already kills the proposed reduction of
every full local Clifford block to a standard semilinear
\(\Gamma\mathrm{SL}_2(q)\) block.  Over
\(\mathbb F_9=\mathbb F_3[s]/(s^2+1)\), at the admitted pencil parameter
\(t=1+s\), exact enumeration of all \(51{,}840\) elements of
\(\mathrm{Sp}_4(\mathbb F_3)\) finds 96 identity-party symplectic gauges
compatible with every minimum-support transition.  Only 16 normalize the
standard scalar field; the other 80 are nonsemilinear in the standard
\(\mathbb F_9^2\) structure.

One exotic base block, in coefficient order
\((x_0,x_1,z_0,z_1)\), is
\[
 F_0=\begin{pmatrix}
 2&0&1&0\\
 0&2&0&2\\
 2&0&0&0\\
 0&1&0&0
 \end{pmatrix}.
\]
The JSON certificate records all six transported local blocks.  The
checker verifies their symplecticity and all support-transition equations.
Because the minimum-support spaces generate the stabilizer label space,
these are label automorphisms.  A symplectic label automorphism lifts to a
product Clifford, and any resulting stabilizer-character discrepancy is
corrected by a product Weyl operator, so the example gives an actual local
Clifford state automorphism.

The surviving orbit invariant is
\(\Sigma_p\): the multiset of characteristic polynomials over
\(\mathbb F_p\) of the 450 oriented holonomies after restriction of
scalars.  It is invariant under arbitrary local
\(\mathrm{Sp}_{2e}(\mathbb F_p)\) blocks and party permutations.  In the
four exact finite censuses its packets equal the Galois-orbit packets of
the pencil coordinate \(z\):

| field | admitted \(t\) | \(z\)-classes | Galois-\(z\) packets | \(\Sigma_p\) packets | holonomy-algebra dimensions |
|---|---:|---:|---:|---:|---|
| \(\mathbb F_9\) | 4 | 1 | 1 | 1 | \(2^4\) |
| \(\mathbb F_{25}\) | 16 | 4 | 3 | 3 | \(4^{16}\) |
| \(\mathbb F_{27}\) | 24 | 6 | 2 | 2 | \(6^{24}\) |
| \(\mathbb F_{49}\) | 43 | 11 | 8 | 8 | \(2^{19},4^{24}\) |

Here an exponent denotes the number of parameters with that algebra
dimension.  Equality of Galois-\(z\) values is sufficient for LC
equivalence by global Frobenius followed by the existing all-odd-field
projective classification.  Thus, together with that theorem, the bounded
censuses give the full orbit partition in the four displayed fields.

They do **not** prove that \(\Sigma_p\) recovers the Galois orbit of \(z\)
over every extension field, classify the 96 gauges as a group, count phase
lifts, or classify party-moving automorphisms.  The algebra-dimension
pattern is finite evidence only.  The computation reuses the hash-pinned
C396 finite-field, shortening, and transition implementation; there is no
independent second arithmetic implementation.

## Replay and trusted boundary

Run from `/home/tavis/src/othello`:

```bash
python3 notes/2026-07-26-ame-lu-extension-field-full-clifford-kill-tests.py --check
(cd notes && sha256sum -c 2026-07-26-ame-lu-extension-field-full-clifford-kill-tests.sha256)
```

The deterministic checker uses moduli in low-to-high coefficient order:
\(s^2+1\) for \(\mathbb F_9\), \(s^2+3\) for
\(\mathbb F_{25}\), \(s^3+2s+1\) for \(\mathbb F_{27}\), and
\(s^2+1\) for \(\mathbb F_{49}\).  It trusts exact prime-field arithmetic,
the hash-pinned C396 implementation, Gaussian elimination, exhaustive
symplectic-basis enumeration, and the minimum-support generation theorem.

| file | bytes | SHA-256 |
|---|---:|---|
| checker `.py` | 19,856 | `ed7dfd2ae0e95cd015284bfdcd7708af0a7f1fed4ebeb46b21d7813f9a433a8f` |
| certificate `.json` | 4,521 | `f6bf150e8a925284303fccbf579fc338bd0eed26f42506a70a3a774421082af0` |
| C396 input `.py` | 41,305 | `b536913531c7393e92633b2c6521df50aa32a823a95cc4e92285a0955cc8fa49` |
