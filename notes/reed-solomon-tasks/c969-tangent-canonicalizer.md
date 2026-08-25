# C969 formula-speed tangent canonicalizer

## Lexicographic chart

Let a persistent tangent syndrome at redundancy `r` lie on the tangent line at
the NRC point `a`. Its degree-`r-2` locator kernel has common homogeneous gcd
`(T-aU)^2` (or `U^2` at infinity), so the repeated root is recovered
intrinsically.

Put `n=r-1`. After a projective transformation sends the tangent point to
infinity, the syndrome lies in `span(e_(n-1),e_n)`. Because the point is off
the NRC, its `e_(n-1)` coefficient is nonzero. Its normalized vector therefore
has exactly `n-1` leading zero coordinates.

At a finite tangent point, a vector in `span(nu(a),nu^[1](a))` either has
nonzero coordinate zero, or is a nonzero multiple of the derivative and has
nonzero coordinate one. It has at most one leading zero. Since C969 has
`n>=4`, the lexicographically least point of the full semilinear orbit must
send the repeated root to infinity. No other PGL chart can compete.

## Exact coset enumeration

For each Frobenius exponent `j`, first replace a finite root by `a^(p^j)`.
Every projective matrix sending that root to infinity has the unique
representative

\[
 \begin{pmatrix}\alpha&\beta\\1&-a^{p^j}\end{pmatrix},
 \qquad \alpha a^{p^j}+\beta\ne0.
\]

There are `q(q-1)` such matrices. If the root is already infinity, use

\[
 \begin{pmatrix}\alpha&\beta\\0&1\end{pmatrix},
 \qquad \alpha\ne0,
\]

with the same count. The implementation projectively normalizes every emitted
matrix, applies it through the common semilinear action, and chooses the
lexicographically least normalized output. This is the full set of possible
minimizers by the chart argument, so the result equals explicit PGL
enumeration.

The operation count is `m q(q-1)` transports rather than `m(q^3-q)`. The exact
transporter, including Frobenius exponent, normalized matrix, and output scale,
is retained in the certificate. Sigma syndromes and all nonpersistent inputs
continue to use the explicit fallback; no faster claim is made for them yet.

## Regression

Over `F_17`, the R6 tangent fixture's formula path examines 272 transports and
returns the same canonical syndrome as all 4,896 explicit PGL transports. A
nontrivial affine image canonicalizes to the same artifact. The refreshed
benchmark records the formula path separately from the still-generic terminal
oracle and from independent certificate replay.
