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
