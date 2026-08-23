# (GS-carrier) discharged for every rank-one b3=0 Fano threefold: P^3, Q^3, V5, V22 are all quantum-etale at the canonical point

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-23

Executes the pointwise reduction of
`2026-08-23-c925-fable-b3zero-tail-a2-reduction.md` §3 on the complete
Picard-rank-one slice.  The four smooth Fano threefolds with \(\rho=1\) and
\(b_3=0\) are \(\mathbf P^3\), the quadric \(Q^3\), \(V_5\) (the degree-five
del Pezzo threefold, index two, CCGK's \(B_5\)), and \(V_{22}\).

## Result

Each variety's quantum period was generated to forty terms from the closed
formulas in Coates--Corti--Galkin--Kasprzyk (arXiv:1303.3288, cached) — for
\(V_{22}\) via Theorem F.1 on \(\mathrm{Gr}(3,7)\) with \(d=3\), evaluated
by the same degree-three truncated abelianization as the V16 computation —
and run through the validated operator-guess/companion pipeline (imported
unmodified from `c925-fable-rank-one-exponents.py`).  Every regularized
series is asserted against CCGK's printed coefficients before use.  In all
four cases the characteristic polynomial of \(c_1\star\) at \(q=1\) is
squarefree, so on the rank-four hyperplane-cyclic even cohomology the
operator is semisimple with distinct eigenvalues and the quantum algebra is
étale at the canonical point:

| \(X\) | index | charpoly of \(c_1\star\) at \(q=1\) | verdict |
|---|---|---|---|
| \(\mathbf P^3\) | 4 | \((\lambda-4)(\lambda+4)(\lambda^2+16)\) | étale (cross-checks the toric sweep) |
| \(Q^3\) | 3 | \(\lambda(\lambda^3-108)\) | étale; matches the lane's known relation \(H^{\star4}=4qH\) |
| \(V_5\) | 2 | \(\lambda^4-44\lambda^2-16\) | étale |
| \(V_{22}\) | 1 | \((\lambda+4)(\lambda^3-8\lambda^2-56\lambda-76)\) | étale |

By the Hensel/discriminant argument of the tail-reduction report §2, each of
these carriers therefore has a purely simple-sheet ledger over the
coefficient field of any Iritani bulk curve based at its small locus: **no
Jordan block, marked or otherwise, can occur on any rank-one \(b_3=0\)
carrier.**  Combined with the toric sweep, the \(b_3=0\) tail is now closed
for all smooth toric Fano threefolds and all \(\rho=1\) Fano threefolds.

## What remains of the tail

1. Non-toric Fano threefolds with \(\rho\ge2\) and \(b_3=0\) (a finite
   Mori--Mukai list).  The period pipeline does not suffice there — with
   \(\rho\ge2\) the anticanonical-cyclic part need not exhaust the even
   cohomology — so these need genuine small-quantum presentations (Ciolli's
   computations of small quantum cohomology for low-rank Fano threefolds are
   the natural source) or Iritani-decomposition bookkeeping when the variety
   is a blow-up of an already-closed carrier along a point or rational
   curve.  Successor work.
2. Non-Fano \(b_3=0\) carriers: open boundary of the pointwise method, as
   before; the structural irregular-Hodge lead is unchanged.

## Incidental observation

\(V_{22}\)'s spectrum contains the rational eigenvalue \(-4\) next to an
irreducible cubic factor — the only rational spectral point among the four
outside \(\mathbf P^3\)'s lattice and \(Q^3\)'s zero.  Not consumed by
anything here; noted for the discovery track only if it recurs.

## Certificate

Script `notes/cubic-threefolds-tasks/c925-fable-gs-carrier-rank-one.py`,
sha256 `784d50ca7141a31f5524913b9aa9a63c9c5a2a520093d650da3209137939cce6`;
output `c925-fable-gs-carrier-rank-one-output.txt`, sha256
`0a5b114c09f77b479aa7b27ff172598a6d36614d6e11ed17575cc4b3073afdc6`.
Replay:

    uv run --with sympy python3 \
      notes/cubic-threefolds-tasks/c925-fable-gs-carrier-rank-one.py

Runs in about twelve seconds.  Trust boundary: single implementation; each
period is independently anchored to CCGK's printed regularized coefficients
(four to ten terms per variety), the operator relation spaces are
one-dimensional, and the squarefreeness decisions are exact
(\(\gcd(p,p')\) over \(\mathbf Q\)).  \(\mathbf P^3\) doubles as a
cross-check against the toric sweep's independent Batyrev/Landau--Ginzburg
computation, and \(Q^3\) against the lane's previously recorded quantum
relation.
