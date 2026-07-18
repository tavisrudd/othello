# C210: odd-tower arithmetic completeness of the three `a!=0,b!=0` residue branches

**Lane**: `relconic` (task report; C210 remains active)

Date: 2026-07-18. This closes the arithmetic-completeness gate left open by
[`2026-07-17-c210-a-nonzero-dAS-branches.md`](2026-07-17-c210-a-nonzero-dAS-branches.md).

## Theorem

Let `k=GF(2^n)` with `n` odd, and work on

    a*delta*N*b*p != 0,       N=a^2+a+1,

with `theta=w^2+w+1`. The full three-equation residue system

    c_i = h0*A_i+B_i = 0,     i=0,1,2,

is exactly the union of the following branches (with `h1` free):

1. `e=0`, `h0=0`;
2. `e=delta`,
   `h0=p^2*theta+e^2+e*b+e*a*p`;
3. `delta=p`, `w in {0,1}`,
   `h0=e^2*a^2+e*a^2*p+e*a*p+e^2+e*b+e*p`.

Thus the bounded `GF(8)` and `GF(512)` observations were the first two exact
instances of a uniform odd-degree theorem: the algebraic excess of the
cross-determinant projection has no odd-degree rational point off the three
known branches.

## Exact projection argument

The already certified cross-determinants are

    E01 = e*(e+delta)*N*delta^4*p^7*R01^2,
    E12 = e*(e+delta)*N*delta^4*p^7*R12^2,
    E02 = e*(e+delta)*delta^2*p^6*P02.

The residuals `R01,R12,P02` have respectively `52,24,202` terms and are
homogeneous in `(delta,p)` of degrees `8,7,18`. Since `p!=0`, put
`d=delta/p` and use the lossless `p=1` chart. For

    I = (R01,R12,P02) in GF(2)[a,d,w],

exact Gröbner reduction gives

    (N*theta*(d+1))^6       in I,
    (N*theta*w*(w+1))^6    in I.

If a residue-system solution has neither `e=0` nor `e=delta`, all nonresidual
factors in the displayed cross-determinants are nonzero, so its projection
lies in `V(I)`. The quadratics `N=a^2+a+1` and `theta=w^2+w+1` split over
`GF(4)` and have no root in an odd-degree extension of `GF(2)`. Hence the two
ideal memberships force

    d=1,     w*(w+1)=0,

which is exactly the branch-3 projection `delta=p`, `w in {0,1}`. This is a
radical implication proved by explicit powers in the ideal; it does not rely
on `minAssGTZ`, primary decomposition, or a scheme-equality claim.

## Exact height argument

Projection completeness alone would leave an all-`A_i` loophole and would not
force the displayed `h0` values. The checker closes both issues.

On `e=0` and `e=delta`, the specialized coefficient vectors
`(A0,A1,A2)` are exactly equal. Their `(delta,p)` weights are `14,13,12`.
After the same `p=1` normalization, if `I_A` is their coefficient ideal, then

    (d*N*theta)^7 in I_A.

Thus at least one coefficient is nonzero on the stated odd-degree scope. The
direct branch identities `c_i(h0_branch)=0` then force `h0=h0_branch` for
branches 1 and 2. On branch 3, direct exact substitution gives the stronger
identity

    A0 = p^14*N^5

for both `w=0` and `w=1`, so the branch-3 height is forced as well. The checker
performs all twelve direct substitutions (three equations on branch 1, branch
2, and both branch-3 fibers).

## Artifact, replay, and cross-check

- Checker:
  `papers/arcs_complete_outside_conic/analyze_c210_a_nonzero_dAS_completeness.py`.
- Canonical output:
  `papers/arcs_complete_outside_conic/analyze_c210_a_nonzero_dAS_completeness_output.txt`.
- Replay from `papers/arcs_complete_outside_conic/`:

  ```bash
  python3 analyze_c210_a_nonzero_dAS_completeness.py | diff - analyze_c210_a_nonzero_dAS_completeness_output.txt
  sha256sum -c analyze_c210_SHA256SUMS
  ```

The checker rebuilds the three stripped conditions from the committed
universal resultant using pure-Python sparse `GF(2)` arithmetic. Exact
division reconstructs `R01,R12,P02`; simultaneous sparse substitution checks
the four branch fibers; Singular `std`/`reduce` certifies the two projection
memberships and the height-coefficient membership in Gröbner bases of sizes
`22` and `40`.

The independent bounded cross-check is the previously committed exhaustive
`GF(8)` residue-system census (`1,404,928` parameter points) and lossless
`p=1` `GF(512)` projection census (`261,632` `(delta,w)` pairs). Both found
exactly the branch union predicted here, and the `GF(8)` census independently
found no all-`A_i` base.

Trusted boundary: the committed universal resultant, the sparse-polynomial
reconstruction/substitution code, and Singular exact ideal membership over
`GF(2)[a,d,w]`. No finite census is used to infer the infinite-family theorem.

## SHA-256 and byte counts

    analyze_c210_a_nonzero_dAS_completeness.py          9605  60c849b819423fe76490001da2b7a6a90e557213d3ce25dc5de5b6d1da31e4ae
    analyze_c210_a_nonzero_dAS_completeness_output.txt  1847  6f37435ffc7573cc3d69e3d8818373bfe533a4903a38b274bf6c68aaf6dc8d2d

## Consequence and remaining boundary

Every `a!=0,b!=0` residue branch is now both complete and, by the committed
second-layer and genuineness packets, genuine-collision-bearing for every
odd-tower `q>=512`. This closes the last arithmetic factorization frontier.

This report does not itself prove the final global off-divisor `H=J=0`
obstruction or state the resulting bounded two-repair-coset mechanism theorem.
Those are the remaining C210 exit steps. The bounded `q=8` genuineness
exceptions on branches 1 and 2 and the separate `b=0` boundary still prevent a
whole-tower collision-forcing statement, but they do not affect the infinite
tail `q>=512`.
