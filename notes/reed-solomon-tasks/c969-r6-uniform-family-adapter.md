# C969 uniform R6 nucleus adapter

## The invariant line

For a redundancy-six syndrome in characteristic two, the first recurring
nonpersistent family is the third nucleus of the quintic normal rational
curve:

\[
 \mathcal N_3=\mathbf P\langle e_2,e_3\rangle.
\]

The vanishing binomial coefficients
`binom(4,2)`, `binom(5,2)`, `binom(4,3)`, and `binom(5,3)` make this projective
line invariant under `PGL(2,q)`. Consequently membership is intrinsic even
though the executable test is the sparse coordinate condition

\[
 s_i=0\quad\text{for }i\notin\{2,3\}.
\]

The nonzero projective points of this line form one `PGL(2,q)` orbit. No group
enumeration or finite registry lookup is needed for recognition.

## Arithmetic toggle

The representative `e3` has quartic Hankel net

\[
 \langle U^4,TU^3,T^4\rangle,
\]

or `span(1,t,t^4)` in an affine chart. A squarefree member can split into four
rational roots exactly when the three nonzero solutions of `u^3=alpha` are
rational. For `q=2^m` this is equivalent to `3 | q-1`, hence to even `m`.
Therefore every point of `N_3(F_q)` is deep exactly when `m` is odd.

The adapter checks all three necessary clauses: characteristic two, odd field
degree, and membership in `P<e2,e3>`. It emits family
`r6.char2_nucleus` with invariant
`r6.char2_three_nucleus:odd_extension_degree`. The common theorem-domain
replay then supplies the independent R6 radius-five promotion.

## Evidence boundary

The generated orbit registry contains the q=8 row and remains authoritative
there, including its exact orbit and stabilizer sizes. The formula adapter is
what makes q=32,128,... queryable without adding rows. The unit regression
checks acceptance over the frozen polynomial-basis model of `F_32` and
rejection over `F_16`, where the extension degree is even. Full semilinear
canonicalization over extension fields remains the explicit
`m(q^3-q)` fallback and is benchmarked separately from this constant-time
family detector.
