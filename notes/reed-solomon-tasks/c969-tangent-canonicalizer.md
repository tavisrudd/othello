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

## Sigma boundary

The analogous shortcut through one centered irreducible quadratic and its
normalizer is false. Over `F_7`, the R5 sigma recurrence with characteristic
polynomial `X^2+1` and initial pair `(1,1)` gives the syndrome
`[1,1,6,6,1]`. Restricting to centered irreducible forms gives minimum
`[1,1,6,6,1]`, while the full PGL orbit has the strictly smaller minimum
`[1,0,3,3,5]`.

Thus the gcd's centered form does not determine the relevant sigma fiber: a
future reduction must also track the induced torus/fiber invariant. The sigma
path deliberately retains exact explicit semilinear enumeration, and the
counterexample is frozen as a regression test.

### Fixed-pair quotient lemma

Over `E=F_(q^2)`, write a rational nonsplit-secant syndrome projectively as

\[
 s(\lambda,a)=\lambda\nu_n(a)+\lambda^q\nu_n(a^q),
 \qquad n=r-1.
\]

Multiplying `lambda` by `F_q^*` changes only the projective output scale, and
Hilbert 90 identifies these coefficient lines with the norm-one torus `T` via
`rho=lambda^(q-1)`.  An element fixing the conjugate pair diagonalizes over
`E`; if its eigenvalue ratio is `t in T`, its `Sym^n` action changes `rho` by
`t^n`.  Every `t in T` occurs.  The other normalizer component exchanges the
two conjugate eigenlines, sending `rho` to `rho^q=rho^(-1)`.  Hence the
fixed-pair projective-normalizer orbits are exactly the classes of

\[
 T/T^n
\]

modulo inversion (and the compatible base-field Frobenius action). This proves
the residual orbit invariant once a conjugate pair is fixed. It is not yet a
fast canonicalizer: the implementation still needs a basis-independent
extractor for the class and a proof that the class selects the
lexicographically minimal target quadratic. The `F_7` counterexample shows
exactly why choosing the target quadratic independently of this datum cannot
work.

As bounded regression evidence, for `q=7`, `r=5`, and the fixed recurrence
`X^2+1`, the eight projective initial conditions collapse under full PGL to
exactly three canonical syndromes:

```
[0,1,0,3,0], [1,0,3,3,5], [1,0,1,1,2].
```

Here the norm-one torus has order eight, while quotienting by fourth powers
gives a cyclic group of order four with three inversion orbits. The matching
count supports the proposed quotient and is frozen in the test suite, but it
does not replace the missing intrinsic-extraction and lexicographic-minimum
proofs.

The extractor need not construct a separately encoded `F_(q^2)`. Given the
monic irreducible gcd `Q`, use the quadratic algebra `A=F_q[X]/(Q)`. The trace
pairing is nondegenerate, so the first two syndrome coordinates uniquely solve
for `lambda in A` from `s_i=Tr(lambda a^i)`, `i=0,1`. Then
`rho=lambda^(q-1)` lies in `T`; projective rescaling by `F_q^*` leaves it
unchanged, while choosing the conjugate root inverts it. This gives the
implementation route for a basis-independent quotient-class extractor. What
remains genuinely geometric is the rule taking that class to the globally
lex-minimal irreducible target quadratic.
