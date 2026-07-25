# C607 — fixed-parameter exact projective Reed--Solomon decoding

**Lane:** `reed-solomon`

**Dependency gate:** Start only after C545 publishes Version 1. This task must
not change the Version 1 manuscript or its reviewed release artifact.

## Target

Prove, at a publication-ready algorithmic complexity boundary, that the
length-\(q+1\) projective Reed--Solomon code of redundancy \(r\) has an exact
Las Vegas maximum-likelihood decoder with expected running time
\[
F(r)q^{O(1)},
\]
where the exponent of \(q\) is absolute. The decoder must return a nearest
codeword and a minimum-support error pattern whose syndrome identity and weight
are directly checkable.

The proposed reduction represents a weight-\(t\) error by distinct projective
positions and nonzero values, giving a constructible finite-field incidence of
bounded dimension, degree, and number of equations as functions of \(r\).
Degrees are tested in increasing order. A bounded-format finite-field
feasibility algorithm supplies the existence test and a rational point.

## Entry questions

1. State the cost model precisely: field operations, representation of
   \(\mathbf F_q\), factorization costs, and Las Vegas verification.
2. Audit prior work on parameterized Reed--Solomon decoding and on effective
   rational-point finding for bounded-format constructible sets. No novelty
   claim is allowed before that audit.
3. Replace the generic appeal to Gröbner decomposition, absolute
   factorization, Bertini sections, and effective Lang--Weil by exact cited
   algorithms with a composed complexity bound whose \(q\)-exponent is
   independent of \(r\).
4. Check both projective-position charts, collision removal, nonzero error
   values, termination at support \(r\), and reconstruction of the nearest
   codeword.

## Exit gate

- a complete theorem and proof with an explicit trust and complexity boundary;
- a claim-specific literature audit;
- an independent algorithmic-complexity review;
- exact separation between the enormous generic parameter function \(F(r)\)
  and any claim of practical decoding; and
- a decision whether the result belongs in a Version 2 application section or
  a separate decoding note.

