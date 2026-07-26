# Q16 certificate mechanism compression

**Lane:** `relconic`

## Result

The 2,630 full-rank quadratic-evaluation leaves in the checked
\(\mathrm{PG}(2,16)\) eight-arc classification share one elementary
incidence obstruction.

For every such leaf, the ordinary-uncovered locus contains:

- three distinct collinear points on a line \(L\); and
- three noncollinear points outside \(L\).

A quadratic through the first triple contains \(L\) as a component, because
its restriction to \(L\cong\mathbf P^1\) has degree two and three distinct
zeros.  The residual linear factor would then have to contain the three
off-line points, contradicting their noncollinearity.  Thus these six points
impose independent conditions on quadratics without a matrix inversion.

Exactly three of the 2,633 leaves lack this pattern.  Their quadratic kernels
are one-dimensional.  In the polynomial-basis encoding
\(\mathbf F_{16}=\mathbf F_2[\alpha]/(\alpha^4+\alpha+1)\), normalized kernel
generators and selected-point intersections are:

| leaf | kernel generator in \(X^2,Y^2,Z^2,XY,XZ,YZ\) order | selected points on it |
| --- | --- | --- |
| 89 | `(1,1,1,1,1,0)` | `(1,8,14)`, `(1,11,12)` |
| 90 | `(0,0,0,1,10,11)` | seven of the eight selected points |
| 2631 | `(1,9,9,11,11,9)` | `(1,6,12)`, `(1,11,7)` |

The first and third forms are the scalar-normalized versions of the two split
forms already proved in
`RelativeConicArcs.Q16Classification.exceptionalFormOne_factorization` and
`exceptionalFormThree_factorization`.  The middle form is the normalized
version of the nonsingular form presented by
`RelativeConicArcs.Q16Classification.exceptionalFormTwo_conic_equation`.
In every case the unique containing quadratic meets the selected arc.

Consequently the leaf stage of the proof has the conceptual form

\[
 2630\text{ line-plus-off-line-triangle obstructions}
 \quad+\quad
 3\text{ explicit one-dimensional kernels}.
\]

The augmentation covering list remains computational.  C663 owns the
separate attempt to replace that classification by a split-Chow or
projective-code theorem.

## Reproducible certificate

The deterministic checker and canonical output are:

- `papers/arcs_complete_outside_conic/check_q16_uncovered_patterns.py`;
- `papers/arcs_complete_outside_conic/check_q16_uncovered_patterns.json`;
- `papers/arcs_complete_outside_conic/check_q16_uncovered_patterns.sha256`.

From `papers/arcs_complete_outside_conic/`, replay with:

```text
python3 check_q16_uncovered_patterns.py --check
sha256sum -c check_q16_uncovered_patterns.sha256
```

The checker reads the exact 2,633 level-eight arcs from
`lean/RelativeConicArcs/Q16CertificateLevels.lean`, reconstructs every
ordinary-uncovered locus directly from the 28 secants, chooses the
lexicographically first displayed incidence pattern, and recomputes the
quadratic kernel and arc intersection for each of the three exceptions.
It uses exact arithmetic modulo \(x^4+x+1\), contains no random choice, and
stops after all 2,633 leaves.

The checked byte counts are 7,746 for the script and 124,491 for the JSON.
Their SHA-256 digests are respectively
`f40e088206d1cd47e2717d9a8aac40171e10eba9b018d5f7c141d405ee27ff9c`
and
`ef7b36ed5f926187747e3cbae02080c8cefef3c302c6143449bb3b96ba043007`.
The consumed level list has digest
`568be2fa296466c059a9cdcefcb4f830a861a1dba18e6a69eab29eb07872cfc1`.

The existing, independently shaped Lean certificates verify invertibility of
six-by-six evaluation matrices on precisely 2,630 leaves and the forced-hit
relations on the other three.  They are an independent cross-check of the
new incidence-pattern partition.  The new script does not certify
exhaustiveness of the augmentation list; that remains the job of the Lean
`StepBook.coverage` chain.

## Mystery ledger

- **Settled — why the 2,630 generic leaves fail.**  Every one contains the
  same line-plus-off-line-triangle obstruction; separate inverse matrices are
  unnecessary for human understanding.
- **Settled — the three exceptional leaves.**  Each has one quadratic
  kernel line, and its generator meets the selected arc explicitly.
- **Open — why every eight-arc reaches one of these leaf types.**  The
  augmentation certificate still supplies this exhaustive reduction.
  C663 owns the proposed split-Chow/projective-code replacement.
