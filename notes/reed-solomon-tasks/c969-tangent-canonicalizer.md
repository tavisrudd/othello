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

### Intrinsic extractor

The implementation does not construct a separately encoded `F_(q^2)`. Given
the monic irreducible gcd

\[
 Q=X^2+q_1X+q_0,
\]

it uses the quadratic algebra `A=F_q[X]/(Q)`. If `a` denotes the class of `X`,
the first two trace equations for `lambda=lambda_0+lambda_1 a` have matrix

\[
 \begin{pmatrix}
 2&-q_1\\
 -q_1&q_1^2-2q_0
 \end{pmatrix}.
\]

Its determinant is the discriminant `q_1^2-4q_0`, which is nonzero because an
irreducible quadratic over a finite field is separable. Thus `s_0,s_1`
recover `lambda` uniquely in every characteristic, including characteristic
two.

Put `g=gcd(q+1,n)`, `rho=lambda^(q-1)`, and
`eta=rho^((q+1)/g)`. The kernel of `rho -> eta` is exactly `T^n`, so `eta`
represents the class in `T/T^n`. Instead of choosing between `eta` and
`eta^(-1)`, the extractor returns

\[
 \tau=\operatorname{Tr}_{E/F_q}(\eta)=\eta+\eta^{-1}.
\]

Two norm-one elements have the same `tau` exactly when they are equal or
inverse, because both are roots of `Z^2-tau Z+1`. Finally, taking the least
base-field Frobenius conjugate of `tau` gives the semilinear invariant. The
post-gcd cost is `O(log q)` field operations and uses neither a discrete
logarithm nor torus enumeration.

Regression tests recover traces `2,5,0` for the three q7/R5 classes and verify
the trace over all 336 PGL transports. A characteristic-two R7 fixture checks
the nontrivial order-three quotient over GF(8) across all 1,512 semilinear
transports. The canonicalizers below avoid choosing a target quadratic by
working directly with forced lexicographic coordinates; only their degenerate
root stratum remains open.

### Rootless-form lex chart

One full sigma subbranch can be canonicalized without selecting a target
quadratic. Let `F_s` be the degree-`n` binary form dual to the syndrome. For a
fixed projective bottom row `v` and any complement `w`, write every compatible
top row uniquely as

\[
 h w+c v,\qquad h\in F_q^*,\ c\in F_q.
\]

The first two transformed coordinates are

\[
 A=F_s(v^n),\qquad hB+cA,
 \quad B=F_s(wv^{n-1}).
\]

If `F_s` has no rational projective root, `A` is nonzero for all `q+1` choices
of `v`. After normalizing the first coordinate to one, lexicographic minimality
forces the second coordinate to zero. For each `h` this uniquely forces
`c=-hB/A`. Therefore every possible full-orbit minimizer occurs among exactly

\[
 m(q+1)(q-1)=m(q^2-1)
\]

semilinear transports. The implementation enumerates precisely these cosets,
retains the exact transporter, and returns the same minimum as full PGL
enumeration. If `F_s` has a rational root, a leading zero beats every point in
this chart and the next stratum applies. Over the q7/R5 quotient census, the
trace-zero and trace-five classes use 48 transports.

### Simple-root lex chart

Suppose `v` is a rational root and retain the notation above. If it is simple,
then `B` is nonzero. After normalizing, the transformed syndrome begins
`[0,1]`, and its third coordinate is

\[
 hC/B+2c,
 \qquad C=F_s(w^2v^{n-2}).
\]

In odd characteristic, lex order forces this coordinate to zero and uniquely
sets `c=-hC/(2B)` for each of the `q-1` scales `h`. In characteristic two, if
`C` is nonzero, lex order forces the third coordinate to one, uniquely setting
`h=B/C` and leaving the `q` shifts `c`. There are at most `n` rational roots,
so both cases use `O(m n q)` transports. The implementation checks the forced
prefix and retains exact transporters.

Multiple roots, and the characteristic-two `C=0` stratum, retain the full
explicit fallback. On q7/R5 the trace-two class has four simple roots and now
uses 24 rather than 336 transports. The R6 q17 sigma benchmark has one simple
root and uses 16 rather than 4,896 transports.
