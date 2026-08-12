# C909 low-corank graded quotients: `g = 4,5,6,7`

## Scope

This is an independent count check for the one-depth irreducible finite-etale
graph calculation.  Write `R` for the local DVR, `pi` for its uniformizer,
and `a` for the graph depth.  Only the exact low-corank blocks are used here:

\[
 Q_2 := R/\pi^aR,
 \qquad
 Q_3 := (R/\pi^aR)^3\oplus R/\pi^{2a}R.
\]

The four-slot squarefree block is `Q_2`; the six-slot squarefree block has
Smith exponents `(0,1,1,1,2)`, hence is `Q_3`.  A support with `k-ell`
doubled slots and `2 ell` single slots contributes the same residual block,
with multiplicity

\[
 N(g,k,\ell)
 = {g\choose k+\ell}{k+\ell\choose k-\ell}
 = {g\choose 2\ell}{g-2\ell\choose k-\ell}.
\]

The second equality is useful for checking `k <-> g-k` symmetry.  For `g <= 7`
only `ell=2,3` can occur.  In particular

\[
 N(g,k,2)={g\choose4}{g-4\choose k-2},
 \qquad
 N(g,k,3)={g\choose6}{g-6\choose k-3}.
\]

For `k=3`, the `ell=2` count is
\[
 {g\choose4}(g-4)=5{g\choose5},
\]
not merely `{g choose 5}`.  This is the main count-error trap.

## Complete table

Entries are `I_A^k/P_A^k`; `m Q` means `Q^m`.  A zero means no nontrivial
low-corank block.

| `g` | `k=0` | `k=1` | `k=2` | `k=3` | `k=4` | `k=5` | `k=6` | `k=7` |
|---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| 4 | 0 | 0 | `Q_2` | 0 | 0 | — | — | — |
| 5 | 0 | 0 | `5 Q_2` | `5 Q_2` | 0 | 0 | — | — |
| 6 | 0 | 0 | `15 Q_2` | `30 Q_2 ⊕ Q_3` | `15 Q_2` | 0 | 0 | — |
| 7 | 0 | 0 | `35 Q_2` | `105 Q_2 ⊕ 7 Q_3` | `105 Q_2 ⊕ 7 Q_3` | `35 Q_2` | 0 | 0 |

The dashes are outside the indicated dimension.  Expanded at the only
nontrivial middle degrees:

\[
\begin{array}{c|c}
 (g,k) & I_A^k/P_A^k \\ \hline
 (4,2)&(R/\pi^a)\\
 (5,2),(5,3)&(R/\pi^a)^5\\
 (6,2),(6,4)&(R/\pi^a)^{15}\\
 (6,3)&(R/\pi^a)^{33}\oplus R/\pi^{2a}\\
 (7,2),(7,5)&(R/\pi^a)^{35}\\
 (7,3),(7,4)&(R/\pi^a)^{126}\oplus(R/\pi^{2a})^7.
\end{array}
\]

## Block-count audit

| `(g,k)` | nonzero `(ell, N)` blocks |
|:---|:---|
| `(4,2)` | `(2,1)` |
| `(5,2)`, `(5,3)` | `(2,5)` |
| `(6,2)`, `(6,4)` | `(2,15)` |
| `(6,3)` | `(2,30)`, `(3,1)` |
| `(7,2)`, `(7,5)` | `(2,35)` |
| `(7,3)`, `(7,4)` | `(2,105)`, `(3,7)` |

Thus the codimension-three totals are
\[
 (R/\pi^a)^{5{g\choose5}+3{g\choose6}}
 \oplus (R/\pi^{2a})^{{g\choose6}},
\]
which gives `(5)`, `(33,1)`, and `(126,7)` for `g=5,6,7`, respectively.

## Verdict

No low-corank count error was found.  The factor `5` in the `ell=2`,
codimension-three contribution is essential, and the table includes the
dual high degrees by the same rectangular support/block decomposition.  This
note does not promote the separate all-`ell` filtered-matching lemma to a
theorem: for `g <= 7`, the displayed table only needs the already checked
four- and six-slot primitive blocks and their exact support multiplicities.
