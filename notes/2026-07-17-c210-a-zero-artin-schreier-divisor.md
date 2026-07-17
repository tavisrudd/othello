# C210: the a=0 Artin--Schreier divisor is explicit and collision-forcing

**Lane**: `relconic` (task report; C210 remains active)

Date: 2026-07-17. Closes the `a=0,b!=0` stratum of the two-coset shared-`(a,b)`
factorization program left open by
[`2026-07-17-c210-a-zero-verification.md`](2026-07-17-c210-a-zero-verification.md).

## Statement

On the `a=0,b!=0,delta!=0` stratum, with `theta=w^2+w+1`, `Q=u^2+u*delta+delta^2`,
`G1=u^2+u*p+p^2*theta`, `G2=u^3+u^2*delta+u*p^2*theta+delta*p^2*theta+delta^2*p`:

1. **Residue derivation.** `phi=A0*Q^2/(delta^2*G1^2*G2^2)` has order-two poles at
   the roots of `G1*G2` (`Res(G1,G1')=p^2`, `Res(G2,G2')=delta^4*p^2`; a shared
   `Q`-root cancels its pole).  With `W=(A0')^2*Q^4+A0*Q^2*(D')^2`, `D=delta*G1*G2`,
   the reduced AS-residue at a simple root `rho` vanishes iff `W(rho)=0`.
   `W == 0 mod G1` **identically** — both `G1`-residues vanish on the whole
   stratum — and `W mod G2` has `u`-coefficients `delta^7*p*P0`, `delta^8*p*P1`,
   `delta^6*P2` with each `P_i` `h1`-free and linear in `h0`.
2. **Explicit divisor.** Off `delta*b*p=0`, `D3 = V(P0,P1,P2)` decomposes exactly as

   | branch          | conditions                    | forced height                 |
   |-----------------|-------------------------------|-------------------------------|
   | trivial coset   | `e=0`                         | `h0=0`                        |
   | second coset    | `e=delta` (i.e. `f=0`)        | `h0=p^2*theta+e^2+e*b`        |
   | `delta=p`       | `delta=p`, `theta=1` (`w` in `GF(2)`) | `h0=e*(e+b+p)`        |

   with `h1` free on every branch.  Completeness: the `h0`-cross-determinant
   residuals are `(delta,p)`-homogeneous and `(delta,p,w)`-only; two-chart
   resultant elimination shows any further common zero needs `theta*w*(w+1)=0`;
   `w` in `GF(2)` forces `delta=p` (`delta`-gcd `(delta+1)^6` at `p=1`), and
   `theta=0` forces `delta=0` (a `GF(4)` gcd), besides having no rational `w`
   over any `GF(8^m)` with odd `m`.  The all-`alpha` (`h0`-free) candidate also
   forces `theta=0`.  The merged-pole locus `Res(G1,G2)=p^2*K1*K2` only shrinks
   `D3`: there `D'(rho)=0`, so `W == (A0'*Q^2)^2 mod (G1,G2)` and AS-triviality
   still forces `G2 | W`.
3. **Rational split, no conjugate escape.** On each branch the cover splits into
   explicitly rational components by exact polynomial identity, e.g. on
   `delta=p`: `N_B = p^12*Q^2*L1*L2` with `L1=u*e+e^2+t*b+e*b+e*p+h1`,
   `L2=L1+u*p`; the `e=0` / `e=delta` branches split as a `t`-linear `u`-free
   line times a `t`-linear `u`-degree-five cofactor.  The components are
   rational at every point of every branch over every field, so the
   conjugate-component (collision-free) scenario never occurs.
4. **Split locus.** `H=D*B+A*E` pulls back to `delta*G1`.  Over `GF(8^m)`, odd
   `m`, `G1/p^2=v^2+v+theta` with `tr(theta)=tr(1)=1`, so `G1` has no rational
   root: `H=J=0` is empty over the whole odd tower and every rational curve
   point reconstructs `r=J/H`.
5. **Genuineness.** Exact `GF(64)` incidence witnesses (committed projective
   `line_key`, not the resultant): at the `delta=p` point
   `(e,delta,b,p,w,h0,h1)=(1,2,1,2,0,2,3)` the genuine collision set equals
   `L1 u L2` exactly — `7+7` points per seed color, all triples of three
   distinct points, no others.  The `e=delta` point `(7,7,2,1,4,5,0)` has six
   genuine collisions and seven coincident-point artifacts per color (its
   trivial-coset line is a seed/repair coincidence, outside the
   two-nontrivial-coset design); the `e=0` point `(0,3,2,5,4,0,1)` has seven
   genuine collisions per color.

**Conclusion.** Off `D3` the cover is absolutely irreducible and Lang--Weil
forces reconstructible collisions (reconstruction valid by 4).  On `D3` every
branch splits into rational components carrying genuine collisions at every
odd-tower field.  **No collision-free coefficient stratum exists on
`a=0,b!=0`.**  The `a!=0` (`t`-degree-four) factorization divisors are the next
frontier.

## Artifact and replay

- Checker: `papers/arcs_complete_outside_conic/analyze_c210_a_zero_artin_schreier_divisor.py`
  (canonical JSON output `analyze_c210_a_zero_artin_schreier_divisor_output.txt`).
- Replay: `cd papers/arcs_complete_outside_conic && python3
  analyze_c210_a_zero_artin_schreier_divisor.py | diff -
  analyze_c210_a_zero_artin_schreier_divisor_output.txt`.
- The script rebuilds the cover from the committed universal resultant (no
  re-transcription), rederives `W`, `P0,P1,P2` in exact GF(2) set arithmetic,
  and re-certifies every load-bearing identity in Singular (reduce, exact
  division, resultants, two-chart gcds, one `GF(4)` gcd) plus the exact `GF(8)`
  census and `GF(64)` witnesses.

## Exact checked counts and conventions

- `GF(8)` census (`GF(2)[x]/(x^3+x+1)` bit encoding): solutions of
  `P0=P1=P2=0` with `delta,b,p!=0` — 6076, equal **as a set** to the branch
  union `2744 + 2744 + 588` (pairwise disjoint slices `e=0`; `e=delta`;
  `e` outside `{0,delta}` with `delta=p`, `w` in `GF(2)`).
- `G1` rational-root scan: `7*8*8` `(p,w,u)` triples, no root — the split-locus
  emptiness at `q=8`.
- Witness counts as in 5; the `delta=p` witness additionally asserts set
  equality with `L1 u L2` for both seed colors.
- Singular certificate: forty numbered exit gates; trusted boundary is
  Singular `reduce`/`resultant`/`gcd`/exact division over `GF(2)[params]` and
  one `GF(4)` gcd, plus Python exact GF(2) set arithmetic.

## What this does not prove

The boundaries `p=0`, `delta=0`, `b=0` (owned by earlier gates: coincident
repair pair, equal coset offsets, the closed `a=b=0` stratum); the `a!=0`
divisors; the classical AS-reduction and Lang--Weil theory (trusted); the
geometric structure of the `h0`-free sublocus inside `theta=0` (arithmetically
empty over the odd tower).

## Method notes

- The three `G2`-root conditions are dependent (the census shows codimension
  two, consistent with the residue-theorem constraint `sum c1 = 0` combined
  with `sqrt` additivity in characteristic two); the decomposition therefore
  went through `h0`-linearity and cross-determinants rather than naive
  codimension counting.
- `minAssGTZ` over `GF(2)` returned a **wrong** minimal-prime list for the
  residual system (claimed `V(delta+p)`; direct division shows the
  cross-determinants are not divisible by `delta+p`).  All decomposition steps
  in the committed checker use exact division, resultants, and gcds only.
