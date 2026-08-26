# Terminal-hyperplane solver

For redundancies `r=5,6,7`, increasing-degree search reaches the terminal
locator with a prefix of degree `d=r-4` and a three-root completion. Streaming
distinct projective prefixes costs respectively `O(q)`, `O(q^2)`, and `O(q^3)`.

After fixing the prefix and one completion root, the Hankel equation is bilinear
in the remaining two roots. Away from its explicit collision divisor, the last
root is a rational function of the preceding root. The collision divisor has
degree at most eleven, so testing twelve distinct field elements guarantees a
valid completion whenever the field is large enough. Small fields and defensive
checks use the generic exact terminal hyperplane enumeration.

The solver streams prefixes and completions. Its operation count concerns
locator selection; the reference implementation's exhaustive root-factor check
adds its own `O(q)` cost and must not be hidden inside that selector bound.
