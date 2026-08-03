# C838 — robust atlas compatibility (2026-08-02)

## Verdict

The symplectic and affine questions separate.

- Positive: the locally recovered symplectic maps satisfy every exact
  minimum-support atlas equation at a radius depending only on q and p.
- Negative for the proposed global improvement: localized commutators are
  exactly blind to local Weyl translations, hence to the stabilizer
  character.  They determine an exact symmetry only after an uncontrolled
  product-Pauli correction.

Thus the transport atlas removes the linear compatibility uncertainty but
does not remove the square-root-of-n decomposition threshold.

## Two-support localization

Fix an (m+1)-support A and i,j in A.  The set

    B = A^c union {i,j}

also has size m+1 and intersects A exactly in {i,j}.  For labels
ell in L(A) and r in L(B), consider

    C = [U W_ell U^dagger, W_r].

Approximate symmetry gives

    ||(C-I) psi|| <= 4 eps.

The commutator is supported only on i and j.  Replacing U_i,U_j by their
recovered Cliffords costs at most 64 sqrt(q) eps in operator norm.  The
resulting Clifford commutator is a scalar p-th root zeta, so

    |zeta-1| <= (4+64 sqrt(q)) eps.

Below

    R_atlas = min(tau_p/8,
                  2 sin(pi/p)/(4+64 sqrt(q))),

the p-th-root gap forces zeta=1.

## Exact atlas equation

Write a=ell_i, b=r_i and use the transition maps:

    ell_j = M_A(i,j) a,
    r_j   = M_B(i,j) b.

The scalar commutator identity is

    [F_i a,b] + [F_j M_A(i,j)a, M_B(i,j)b] = 0.

Isotropy of the original label group, applied with i-coordinate F_i a,
gives

    [F_i a,b] + [M_A(i,j)F_i a, M_B(i,j)b] = 0.

Subtracting and using the nondegenerate pairing and invertibility of M_B
yields

    F_j M_A(i,j) = M_A(i,j) F_i.

This holds for every atlas edge.  The exact atlas theorem then gives
F(L)=L, and the phase-correction lemma supplies a product Pauli W_v such
that W_v K is an exact symmetry.

## Affine obstruction

Multiplying K_i by a local Weyl changes the phase in

    K_i W_a K_i^dagger = phase times W_{F_i a}

but that phase cancels from every commutator.  Therefore all tests used
above are identical for K and W_v K for arbitrary product Weyl W_v.
They can recover the Lagrangian label group but cannot recover its
character.

The phase-correction label v need not lie in L and need not have bounded
weight.  Consequently the exact symmetry W_v K need not be locally close
to U, even though K is.  Showing that the correction is trivial modulo L,
or is collectively close, is exactly the pre-entry collective problem
identified in C837.

This is a structural information-theoretic boundary of the commutator
method, not merely a loose constant.  No computation or certificate is
used.
