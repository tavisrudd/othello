# Extension-field full-Clifford kill tests

Date: 2026-07-26

## Question

For \(q=p^e\), can the full local-Clifford classification be reduced from
\(\mathrm{Sp}_{2e}(\mathbb F_p)\) to the usual scalar-semilinear group
\(\Gamma\mathrm L_2(q)\), and what invariant does the exact
\(\mathbb F_p\)-linear minimum-support atlas supply?

## Exact tests

The replay script
`2026-07-26-ame-lu-extension-field-full-clifford-kill-tests.py` imports the
digest-pinned C396 pencil implementation, enumerates the \(q=9\) base
symplectic group, and computes the prime-field characteristic-polynomial
multiset
\[
  \Sigma_p=\{\!\{\chi_{\mathbb F_p}(H):
       H\text{ is one of the 450 oriented atlas holonomies}\}\!\}.
\]
It writes and checks
`2026-07-26-ame-lu-extension-field-full-clifford-kill-tests.json`.

Replay from the repository root:

```text
python3 notes/2026-07-26-ame-lu-extension-field-full-clifford-kill-tests.py --check
```

## Results

- The semilinearity conjecture is false.  At \(q=9\), parameter
  \((1,1)\), there are 96 identity-party compatible
  \(\mathrm{Sp}_4(\mathbb F_3)\) gauges.  Only 16 base blocks lie in the
  standard scalar-field normalizer; 80 are genuinely nonsemilinear.
- One nonsemilinear base block, in coordinate order
  \((x_0,x_1,z_0,z_1)\), is
  \[
  \begin{pmatrix}
  2&0&1&0\\
  0&2&0&2\\
  2&0&0&0\\
  0&1&0&0
  \end{pmatrix}.
  \]
- The \(\Sigma_p\) packets agree exactly with Frobenius orbits of the
  scalar parameter \(z\) in the tested non-GRS sectors:
  \(1/1\) packets at \(q=9\), \(3/3\) at \(q=25\), \(2/2\) at \(q=27\),
  and \(8/8\) at \(q=49\).

## Consequences

The minimum-support atlas gives an exact extension-field classification
problem in \(\mathrm{Sp}_{2e}(\mathbb F_p)\).  Its holonomy reduction is
the centralizing-base condition together with the requirement that every
propagated block remain symplectic.  Normal-subgroup cancellation is not
available, and no scalar-semilinear classification follows.

The surviving cheap theorem candidate is narrower: prove that
\(\Sigma_p\) determines the minimal polynomial, hence the Frobenius orbit,
of \(z\) on the admitted non-GRS pencil sector.  A full
\(\mathrm{Sp}_{2e}(\mathbb F_p)\) orbit classification is a separate
project.
