# C909 — exhaustive finite-field Dyck-profile audit

Date: 2026-08-11  
Status: exact bounded Sage computation over unramified \(p\)-adic rings; no
manuscript, PDF, mirror, Lean, or commit change

## Verdict

No profile failure was found.

For the squarefree matching component with \(2\ell\) distinct split slots,
the predicted Smith valuation profiles were verified after Teichmuller lifting
the roots to unramified \(p\)-adic coefficient rings.

### \(\ell=3\)

Every six-subset in the listed residue fields has profile
\[
(0,1,1,1,2)
\]
at \(a=1\):

\[
\begin{array}{c|c|c}
\text{residue field}&\text{subsets tested}&\text{profile counts}\\ \hline
\mathbf F_7&\binom76=7&(0,1,1,1,2):7\\
\mathbf F_8&\binom86=28&(0,1,1,1,2):28\\
\mathbf F_9&\binom96=84&(0,1,1,1,2):84\\
\mathbf F_{11}&\binom{11}6=462&(0,1,1,1,2):462
\end{array}
\]

The \(\mathbf F_7\) row includes all seven six-subsets, hence is stronger
than testing one chosen six-element set.

### \(\ell=4\)

The predicted profile is
\[
(0,1,1,1,1,1,2,2,2,2,2,2,2,3)
=(0,1^5,2^7,3).
\]

It was found for:

\[
\begin{array}{c|c|c}
\text{residue field}&\text{subsets tested}&\text{profile counts}\\ \hline
\mathbf F_8&\binom88=1&(0,1^5,2^7,3):1\\
\mathbf F_{11}&\binom{11}8=165&(0,1^5,2^7,3):165
\end{array}
\]

No bad tuple occurred.

Selected \(a=2\) checks, using the same Teichmuller root sets, gave the
exactly scaled profiles
\[
\ell=3:\ (0,2,2,2,4),
\]
and
\[
\ell=4:\ (0,2^5,4^7,6)
\]
over both \(\mathbf F_8\) and \(\mathbf F_{11}\).

## Computation

For each tuple, use the unramified \(p\)-adic ring \(S\) with residue field
\(\mathbf F_q\), and lift every selected residue root by its Teichmuller
representative \(t_i\).  In the integral graph basis
\[
X_i=p^a x_i,\qquad Y_i=y_i-t_i x_i,
\]
the scaled edge factor for
\(p^{2a}\Omega_{ij}\) is
\[
(t_j-t_i)X_iX_j+p^a(X_iY_j+X_jY_i).
\]
Multiplying these factors over all perfect matchings gives a matrix \(G\)
from the matching module to the ambient integral exterior lattice.  Its
nonzero \(p\)-adic Smith valuations are the saturation defect profile.

The \(\ell=3\) matrices have \(42\) nonzero ambient rows and \(15\) matching
columns.  The \(\ell=4\) matrices have \(256\) ambient rows and \(105\)
matching columns; their rational matching rank is \(14\), as expected after
the Pluecker relations.  Smith calculations were performed with sufficient
\(p\)-adic precision and exact=False; the displayed profiles are below the
precision bound.

## Interpretation

The tests support, but do not by themselves prove, root-independence of the
Dyck-height formula.  They cover the smallest dyadic unramified case
\(\mathbf F_8\), a quadratic extension \(\mathbf F_9\), the prime fields
\(\mathbf F_7,\mathbf F_{11}\), all relevant subsets in the stated domains,
and both \(a=1\) and selected \(a=2\) lifts.

No claim is made here for arbitrary-depth graphs, colliding roots, or Chow
lattices.

