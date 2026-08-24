# Integral Secant Distributions and Improved Bounds for Complete (k,n)-Arcs

This directory contains the authoritative manuscript source and its public
verification materials.  The paper studies complete higher arcs through the
numbers of maximal secants through each point.  Its principal
application is the lower bound

\[
t_{2q/3+1}(2,q)\ge q^2/3+4q/3-o(q)
\]

over the tower \(q=3^h\).

Build from the repository root with:

```text
make -C papers/integral_secant_arcs manuscript
```

Run the complete paper gate with:

```text
make -C papers/integral_secant_arcs check
```

The monorepo directory is the editing authority.  Public standalone releases
are exported from committed source.
