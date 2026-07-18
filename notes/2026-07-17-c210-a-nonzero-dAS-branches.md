# C210: three explicit branches of the a!=0 D_AS residue system

**Lane**: `relconic` (task report; C210 remains active)

Date: 2026-07-17. Step-2(b) part 2, on top of the residue conditions
([`2026-07-17-c210-a-nonzero-residue-conditions.md`](2026-07-17-c210-a-nonzero-residue-conditions.md)):
`D_AS` on the `a!=0` stratum is cut by three `h1`-free, `h0`-linear conditions
`C0,C1,C2` (the `G2a`-residues; the `G1` place is automatically trivial), with
common content `(delta*N)^6`.  Write `c_i = C_i/(delta*N)^6 = h0*A_i + B_i`
(`A_i = dc_i/dh0`, `B_i = c_i|_{h0=0}`).  On a branch `c0=0` forces `h0 = B_0/A_0`,
and the branch is genuine when that value also kills `c1,c2`.

## Statement

Exact computation over `GF(2)(e,delta,a,b,p,w,h0,h1)` gives three explicit
branches, each an a-deformation of an a=0 branch, `h1` free throughout:

| branch | condition             | forced `h0` (derived, `h1` free)            | a=0 limit                 |
|--------|-----------------------|---------------------------------------------|---------------------------|
| 1      | `e=0`                 | `0`                                         | `0`                       |
| 2      | `e=delta`             | `p^2*theta + e^2 + e*b + e*a*p`             | `p^2*theta + e^2 + e*b`   |
| 3      | `delta=p`, `theta=1`  | `e^2*a^2 + e*a^2*p + e*a*p + e^2 + e*b + e*p`| `e*(e+b+p)`               |

(`theta = w^2+w+1`; `theta=1` means `w` in `GF(2)`, and both roots `w=0,1` are
checked.)  The forced `h0` on each branch is **derived** by exact polynomial
division `B_0/A_0` on the branch (not a guessed value), and then verified to make
all three conditions `c0=c1=c2` vanish.  Each reduces to the closed a=0 branch
value at `a=0`: the a-deformation is the single term `e*a*p` on branch 2, and
`a^2*e*(e+p) + a*e*p` on branch 3.  These are the a!=0 analogues of the a=0
branches `{e=0,h0=0}`, `{e=delta,h0=p^2*theta+e^2+e*b}`,
`{delta=p,theta=1,h0=e*(e+b+p)}`.

## What is and is not established

Established (exact, by substitution and division):

- branches 1-3 lie in the three-condition residue system, each with its explicit
  forced `h0`, `h1` free (the committed certificate verifies this directly by
  substitution/division). Their original-cover factorization membership is now
  certified separately, including direct `w=0,1` identities on merged-pole
  branch 3; see
  [`2026-07-17-c210-a-nonzero-exact-splits.md`](2026-07-17-c210-a-nonzero-exact-splits.md).

The branch conditions were found from the `h0`-cross-determinants
`E_{ij} = A_i*B_j + A_j*B_i`, which factor (exploration, regenerable from the
checker's `A_i,B_i`) as
`E01 = e*(e+delta)*N*delta^4*p^7*R01^2`,
`E12 = e*(e+delta)*N*delta^4*p^7*R12^2`,
`E02 = e*(e+delta)*delta^2*p^6*P02` with `gcd(R01,R12)=1`: the factors `e` and
`e+delta` give branches 1-2 directly, and `{delta=p, theta=1}` lies in
`V(R01,R12,P02)`, giving branch 3.  These factorizations are motivation only; the
load-bearing certification is the direct branch verification above.

Here `P02` is a nonsquare 202-term residual; the prior exploratory `R02^2`
description was not exact. See the finite census
[`2026-07-17-c210-a-nonzero-dAS-finite-census.md`](2026-07-17-c210-a-nonzero-dAS-finite-census.md).

**Open: arithmetic completeness.** Branches 1-3 are not yet shown to be *all*
of `D_AS` off `delta*p*N=0`. The algebraic cross-determinant projection has an
excess component, but exact odd-tower scans find no extra arithmetic point:
the complete GF(8) residue-system census equals the three-branch union, and the
lossless `p=1` GF(512) scan finds only the 1,022 branch-3 base points. This
supports, but does not prove, that the algebraic excess is arithmetically empty.
Completeness must eventually work with the full `D_AS` ideal
`(c0,c1,c2)` (`u`-free, `h1`-free, in `GF(2)[e,delta,a,b,p,w,h0]`) saturated by
`e*(e+delta)` (drops branches 1,2) and `delta*p*N`, checked equal to the branch-3
ideal `(delta+p, w^2+w, h0-h0_3)`; or the `A_i=0` sublocus must be shown to force
`theta=0` (excluded), mirroring a=0.  The a=0 report also recorded that
`minAssGTZ` returned a **wrong** decomposition on the analogous step, so this must
use exact division/resultant/radical arguments.

Also open (later parts): the separate `b=0,a!=0` inseparable stratum; symbolic
classification of both certified `tau`-quadratic components through
`A/(bQ)^2` and `(A+sigma)/(bQ)^2`; and the reconstruction-split locus `H=J=0`
and projective genuineness needed before calling any rational root a collision.
Full arithmetic completeness of the branch list is last and is needed only if
every known branch is certified collision-forcing.

## Artifact and replay

- Checker: `papers/arcs_complete_outside_conic/analyze_c210_a_nonzero_dAS_branches.py`
  (canonical JSON output `analyze_c210_a_nonzero_dAS_branches_output.txt`).
- Replay: `cd papers/arcs_complete_outside_conic && python3
  analyze_c210_a_nonzero_dAS_branches.py | diff -
  analyze_c210_a_nonzero_dAS_branches_output.txt`.
- The checker rebuilds `B0` from the committed universal resultant, reduces `W`
  mod `G2a`, strips the `(delta*N)^6` content, derives each forced `h0` by exact
  division on the branch, and asserts (numbered exit gates 1-21) that all three
  conditions vanish on each branch, that each derived `h0` matches the stated
  value and its a=0 limit, and that the conditions are `h1`-free.

## Exact checked counts and conventions

- All identities exact over `GF(2)[e,delta,a,b,p,w,h0,h1][u]`; no specialization.
- Branch verification is by exact `subst`; forced `h0` by exact `division`.
- Trusted boundary: Singular `reduce`/`std`/`coeffs`/`diff`/`subst`/`division`
  over `GF(2)(params)`; block order `(lp on u, dp on the rest)`.

## SHA-256 / byte counts

    analyze_c210_a_nonzero_dAS_branches.py         8995  b6339bfb8c1270b76fa5d93b8394409b9090e90f45414ecf2ef481585242114c
    analyze_c210_a_nonzero_dAS_branches_output.txt  1835  76c33187d6468785f3d122fb62b93ca84e4212cbfa593739a707a3316df3a99d
