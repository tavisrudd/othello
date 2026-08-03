# C837 — collective frame coercivity (2026-08-02)

## Verdict

There are two distinct statements that had been conflated.

1. After the exact symmetry branch is known, a dimension-only collective
   estimate already follows from C833.
2. Before branch selection, an estimate strong enough to enlarge the
   entry radius is not supplied by the cleaning proof and is essentially
   equivalent to the missing discrete compatibility theorem.

Thus item 2 is positive as a theorem corollary but negative as an
independent route to removing the square-root-of-n entry loss.

## Post-entry collective theorem

C833 gives, up to phase,

    U = g tensor_i exp(i h_i),
    g in G(psi),
    D^2 = sum_i ||h_i||_F^2 <= pi^2 q eps(U)^2.

For the local factors g_i of g, the chord bound gives

    d_2(U_i,g_i)^2
      <= q^-1 ||h_i||_F^2.

Therefore

    sum_i d_2(U_i,g_i)^2 <= pi^2 eps(U)^2.

This is exactly the desired collective scaling, with no party-count
factor, once the correct exact branch is available.  It is now stated in
the manuscript.

## Why it does not improve entry

The cleaning argument initially produces independently chosen local
Cliffords K_i satisfying d_2(U_i,K_i) <= 8 eps.  Its n applications do not
produce n orthogonal error vectors.  For each logical-leg choice, the
encoded implementation error TV-VL is the same global state-defect vector
viewed through a unitary Choi reshaping.  The commutator proof then applies
unitaries and triangle inequalities to that vector.  There is no Bessel
family whose squared estimates can be added.

Consequently the current information gives only

    sum_i d_2(U_i,K_i)^2 <= 64 n eps^2.

Suppose instead that a pre-entry estimate

    sum_i d_2(U_i,K_i)^2 <= C_q eps^2

were proved at a dimension-only radius.  Principal logarithms and the
chord--angle inequality would give

    D^2 <= (pi^2 q / 4) C_q eps^2.

The AME second moment and stabilizer overlap gap would then force
tensor_i K_i to be an exact symmetry at a dimension-only radius.  In other
words, the sought pre-entry collective estimate already contains the
branch-selection theorem.

## Structural conclusion

The square-root-of-n loss is not in the residual stability estimate; that
estimate is already collective.  It occurs while converting separately
recovered local Clifford labels into one exact global symmetry.  Improving
it requires cross-leg compatibility of the discrete symplectic and affine
Weyl data.  That is C838, not a further norm summation inside C837.

No counterexample to the abstract pre-entry inequality is claimed, and no
computation or certificate is used.  The result is a reduction locating
the missing theorem exactly.
