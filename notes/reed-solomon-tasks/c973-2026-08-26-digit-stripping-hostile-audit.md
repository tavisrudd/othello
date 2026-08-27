# C973 hostile audit — digit-stripping theorem

Date: 2026-08-26  
Verdict: passes author-side audit; independent specialist review still required

## 1. Convention seam

The syndrome module is `Gamma^(d+1) E`, not ordinary binary forms.  The action
used in the proof is fixed by the normal-rational-curve convention

```
nu(t+u)=T_u nu(t),
T_u e_j=sum_(i>=j) binom(i,j)u^(i-j)e_i.
```

This is the same convention used in the manuscript dictionary and the q=49
quadratic-module reduction.  No inverse or contragredient action is silently
substituted.

## 2. Support boundaries

For `d=pD+a`, the top high block `h=D` is truncated at low digit `a` in row
`d`, but its endpoint is nonzero and contributes neither to `Z_d` nor `C_d`.
The carrier lives in degree `d+1`; the apparent extra endpoint `j=d+1` is
excluded because its predecessor `j-1=d` is nonzero.  Thus the displayed
ranges `h<=D-1` in the tensor submodules are exact, not cosmetic.

At low digit zero, `j-1` borrows into the preceding high block.  This is why
`a=p-1` has the separate sequence (2).  The proof treats that case separately
and does not apply the no-borrow formula outside its range.

## 3. Equivariance seam

Lucas factors every upper-translation coefficient as

```
binom(ph'+b',ph+b)=binom(h',h)binom(b',b) mod p.
```

The exponent also factors as a low parameter power times a `p`th-power high
parameter, which is exactly the Frobenius twist.  Diagonal weights determine
the stated determinant shifts.  Inversion preserves every support block and
the rescaling identity supplies the same scalar as the determinant character.
Upper translations, the diagonal torus, and inversion generate the rational
rank-one action, so no generator is missing.

The statement is for rational `GL_2` modules.  Restriction to `GL_2(F_q)` may
identify torus characters or accidentally split an extension; the theorem
does not deny that possibility.

## 4. Quotient seam

The quotient is not inferred from dimensions.  The lower zero-coordinate
module is stable because

```
binom(D,h') binom(h',h)
 = binom(D,h) binom(D-h,h'-h).
```

If `h` is a zero position and `h'` is nonzero, this forces
`binom(h',h)=0`.  Therefore every nonzero quotient transition stays inside
the lower nucleus/carrier support.  Dimensions then agree automatically.

## 5. Endpoint and small-prime checks

- `a=p-2`: the left term of (1) has exponent `-1` and is correctly zero.
- `a=p-1`: equation (2), not (1), applies.
- `p=2,a=0`: (1) has zero left term and remains valid.
- `p=2,a=1`: (2) applies; determinant signs collapse harmlessly because
  `-1=1`.
- `D=1`: `Z_D=0`, and (1) reduces to the one-carry theorem.
- `d<p`: no Pascal zero exists; this is the separate base case in (8).

The bounded checker independently exercises these branches, but none of the
universal arguments depends on its range.

## 6. Nonsplitting seam

The proof uses distinct rational-torus weight characters, not merely distinct
eigenvalues of one finite torus.  Hence a rational-module section must lift a
quotient weight vector to its unique ambient coordinate.  The displayed
upper-unipotent leakage then rules out that section whenever both terms are
nonzero.  No claim is made that the extension represents a previously unknown
`Ext^1` class.

## 7. Coding-theory boundary

The theorem identifies syndrome submodules only.  It does not imply:

- that a shallow locator in a quotient lifts to the extension;
- that pointed abundance is stable under the filtration;
- that finite-group orbit types are the product of subquotient orbit types;
- that covering radius is known; or
- that a split-free direction is a deep hole without the separate radius
  gate.

The only immediate coding consequence is the empty-carrier family (9), where
the simultaneous-marker theorem already handles every nonpersistent syndrome.

## 8. Literature boundary

The preaudit found likely classical predecessors for the rational-module
filtration at insufficient read depth.  The paper should cite or derive the
structure conservatively and make no novelty claim until the primary texts
are read.  The PRS carrier identification and arithmetic pointed-abundance
application require separate positioning.

Vibe: the formulas survive the hostile audit; overclaiming their novelty or
their coding consequence would not.
