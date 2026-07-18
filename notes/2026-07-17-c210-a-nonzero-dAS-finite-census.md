# C210: exact odd-tower census of the a!=0 D_AS residue system

**Lane**: `relconic` (task report; C210 remains active)

Date: 2026-07-17. This is step 0 of the probe-first completeness plan for the
three `h0`-linear residue conditions `c0,c1,c2`. It decides the first two odd
fields exactly and corrects the third cross-determinant residual used by the
earlier exploratory projection.

## Bounded result

Over `GF(8)`, with `delta,a,p != 0` and `e,b,w,h0` arbitrary, the zero set of
`c0=c1=c2=0` is exactly the union of the three known residue-system branches:

- `e=0`, `h0=0`;
- `e=delta`, `h0=p^2*(w^2+w+1)+e^2+e*b+e*a*p`; and
- `delta=p`, `w in GF(2)`, with
  `h0=e^2*a^2+e*a^2*p+e*a*p+e^2+e*b+e*p`.

The checker covers all `1,404,928` parameter points by solving the linear
`h0` coordinate over `175,616` bases. There are exactly `48,608` solutions,
all known: `42,336` off `K1*K2=0` and `6,272` on it. There are no all-`A_i`
bases and no extra solution.

The cross-determinants have exact residual forms

    E01 = e*(e+delta)*N*delta^4*p^7*R01^2,
    E12 = e*(e+delta)*N*delta^4*p^7*R12^2,
    E02 = e*(e+delta)*delta^2*p^6*P02,

where `R01,R12,P02` have respectively `52,24,202` terms. In particular, the
last identity corrects the earlier exploratory description
`E02=e*(e+delta)*delta*p^6*R02^2`: the load-bearing residual is the nonsquare
`P02` above. All three residuals are `(delta,p)`-homogeneous, of degrees
`8,7,18`, so `p=1` is a lossless chart when `p!=0`.

An exhaustive `GF(512)` scan of that chart checks all `511*512=261,632`
`(delta,w)` pairs. Univariate gcds in `a` yield exactly `1,022` common
`R01=R12=P02=0` roots: the two known branch-3 fibers `w=0,1`, each with all
`511` nonzero `a`. There is no off-branch base, hence no `(e,b,h0)` lift to
probe in this field.

Thus the algebraic excess projection has no odd-tower rational point outside
the three branches over either `GF(8)` or `GF(512)`. This supports the
arithmetically-empty/pollution interpretation, but does not prove it for every
`GF(8^m)`, odd `m`.

## Artifact and replay

- Checker:
  `papers/arcs_complete_outside_conic/analyze_c210_a_nonzero_dAS_census.py`.
- Canonical output:
  `papers/arcs_complete_outside_conic/analyze_c210_a_nonzero_dAS_census_output.txt`.
- Replay from `papers/arcs_complete_outside_conic/`:

  ```bash
  python3 analyze_c210_a_nonzero_dAS_census.py | diff - analyze_c210_a_nonzero_dAS_census_output.txt
  ```

The checker rebuilds `B0` from the committed universal resultant, constructs
and reduces `W` by sparse exact `GF(2)` arithmetic, divides the certified
common content, extracts the three residuals by exact division, and performs
the two finite-field scans. The gcd-root enumeration is independently replayed
by direct evaluation of all three residuals at every candidate root. Field
elements use polynomial-basis encodings `GF(2)[x]/(x^3+x+1)` and
`GF(2)[x]/(x^9+x^4+1)`; the latter modulus is certified in the checker by the
order `511=7*73` of `x`.

Trusted boundary: the committed universal resultant and pure-Python sparse
polynomial/finite-field arithmetic. The exploratory Singular factorization of
`P02` is not needed by the certificate. The computation does not establish
odd-tower completeness beyond degrees `3` and `9`, original-cover
factorization on the merged-pole branch, or the second-layer trace verdict.

## SHA-256 and byte counts

    analyze_c210_a_nonzero_dAS_census.py         23263  39889891bf98ee335ba77d131b669c03fe5ec78938ac61dece4c0dc94f89e166
    analyze_c210_a_nonzero_dAS_census_output.txt  1983  f5525fcbf2cd38b0a64a5443ba0ed875e90294889b53731e0b354d58c635c69b
    analyze_c210_SHA256SUMS                       8931  e9fe42494e9f7f8a7d17dba3a2966ecaa992d5b9ab2c42e1426c02c1a4be07a6

## Next gate

The probe found no fourth arithmetic branch through `GF(512)`. Follow the
planned critical path: exhibit exact quadratic splits of the original cover on
all three known residue branches (especially merged-pole branch 3), then run
the second-layer `Tr(A/(bQ)^2)` collision test. Full odd-tower arithmetic
completeness remains the final gate if every branch is collision-forcing.
