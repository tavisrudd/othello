# V16 completes another rank-one dictionary row: class {1/2,1/2}, as its Kuznetsov component predicts

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-23

Closes the queued ledger row "extend to V16/V18 once more period terms are
available" (Levelt-exponent report) for V16; V18 stays open, with the reason
recorded below.

## Result

The quantum period of V16 (index one, genus nine) is now generated to forty
terms from Theorem F.1 of Coates--Corti--Galkin--Kasprzyk (arXiv:1303.3288),
read exactly from the cached PDF pages 13--15 after the plain-text extraction
proved garbled: V16 is cut from \(\mathrm{Gr}(3,6)\) by
\((\det S^*)^{\oplus3}\oplus\Lambda^2S^*\), i.e. parameters
\(r=3,n=6,a=3,e=1\).  The abelianized sum was evaluated in
\(\mathbf Q[p_1,p_2,p_3]\) truncated at total degree three — the \(H^0\)
component of the \(\Omega\)-quotient is the coefficient of \(p_2p_3^2\) of
the degree-three part, so no higher monomials are ever needed — and the
result passes the decisive check: the first ten regularized coefficients
equal CCGK's printed
\(1,0,24,192,2904,40320,611520,9515520,152412120,2491104000\).

Through the same validated pipeline as V14/V12/V10 (operator guessed with a
one-dimensional relation space, order four, degree four; companion matrix;
block reduction):

| \(X\) | \(c_1\star\) charpoly at \(q=1\) | block | class | \(\delta^\sharp\) | component prediction |
|---|---|---|---|---|---|
| V16 | \((\lambda+4)^2(\lambda^2-16\lambda-64)\) | \(J_2\) at \(u=-4\) | \(\{1/2,1/2\}\) | \(0\) | \(\mathcal Ku(V16)=D^b(C_3)\): \(\{1/2,1/2\}\) ✓ |

Fifth dictionary row, fourth distinct variety carrying a \(J_2\); every row
continues to match the numerical Serre functor of the non-exceptional
component (cubic and V14 marked, V12/V16 Jacobian-type unmarked, V10
Enriques-type \(\{0,0\}\)).

## V18 deferred

V18 needs \(r=5\) (bundle \((S\otimes\det S^*)\oplus(\det S^*)^{\oplus2}\) on
\(\mathrm{Gr}(5,7)\)): the abelianized sum runs over five-tuples
(\(\sim10^6\) at forty terms) and no truncation as favourable as the
degree-three trick applies at that width without reorganizing the sum into
Schur/determinant form.  The practical alternatives are the Minkowski-mirror
period sequence 124 (fanosearch.net was unreachable today; the six-page
arXiv:1212.1785 announcement carries no table) or the quantum-Lefschetz route
through the \(G_2/P\) quantum Chevalley formula.  Prediction unchanged:
\(\mathcal Ku(V18)=D^b(C_2)\), class \(\{1/2,1/2\}\).

## Certificate

Script `notes/cubic-threefolds-tasks/c925-fable-v16-exponents.py`, sha256
`37592c163ab1ac33ec7a66fe042302ce5fddfbd14012bf3cc8bb53fde214a0cf`; output
`c925-fable-v16-exponents-output.txt`, sha256
`e8ea2fed31d392c03471d0a8a1d2488b1c3a093c4577f229fc14351f540b75c1`.  Replay:

    uv run --with sympy python3 \
      notes/cubic-threefolds-tasks/c925-fable-v16-exponents.py

Runs in seconds.  The operator-guessing, companion, and block-reduction
stages are imported from `c925-fable-rank-one-exponents.py`, unmodified, so
the exponent extraction is the same code validated on the cubic's known
product.  Single implementation of the Theorem F.1 sum; its independent
check is the nine-coefficient match against CCGK's printed series, which the
script asserts.
