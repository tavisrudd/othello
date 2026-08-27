# Canonicalization complexity

Write `q=p^m` and let the normalized syndrome be a divided-power binary form of
degree `r-1`. The exact lexicographic charts partition forms into rootless,
simple-root, multiple-root, and pure-power strata. They retain at most
`O(m*r*q^2)` semilinear transports; the explicit `m(q^3-q)` group enumeration
is a defensive correctness oracle.

For one transport, adjacent exact-linear-factor rows compute the symmetric-power
action in `O(r^2+r log q)` field operations. With the polynomial-basis backend's
schoolbook `O(m^2)` multiplication and reduction, a conservative end-to-end
bound is

```text
O((m*r*q^2 + q) * (r^2 + r*log(q)) * m^2)
```

base-prime coefficient operations. The reduced charts stream their candidates;
the defensive full-group oracle alone materializes cubic-order group data.

This is a structural canonicalization bound. It does not extend the paper's
covering-radius or deep-hole theorem domain.

## Simultaneous-marker locator

At redundancy `r>=6`, the locator route enumerates squarefree marker supports
of size `r-5`.  For each it constructs one contracted R5 pencil and enumerates
its projective members, at most `q+1` in the generic rank-two case.  Its
worst-case search count is therefore

```text
O(binomial(q+1,r-5) * q)
```

before field-operation costs for contraction, cubic splitting, magnitude
recovery, and certificate replay.  Degenerate terminal kernels remain bounded
by the global candidate limit.  This is a fixed-parameter acceleration over
direct degree-`r-2` support enumeration, not a uniform polynomial-in-`r`
algorithm.
