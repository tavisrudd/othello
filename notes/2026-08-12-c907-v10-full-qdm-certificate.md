# C907 V10: exact small-even QDM certificate

**Lane:** `clebsch`

**Status:** theorem-grade ordinary-small-even calculation: `nu_6(V10)=0`.
This closes the direct prime-Fano operator row, but does not prove an enriched
Stokes/Rees length bound.

## Full-QDM input and scalarization

Przyjalkowski, arXiv:math/0410327, Theorem 6.1.1, proves the exact V10
counting matrix

\[
A=\begin{pmatrix}
0&156&3600&33120\\
1&10&380&3600\\
0&1&10&156\\
0&0&1&0
\end{pmatrix},\qquad \alpha_{V10}=6.
\tag{1}
\]

Golyshev, arXiv:math/0510287, §§1.5--1.11 and 2.2--2.6, identifies the
rank-four algebraic quantum connection with the right-determinant scalar
module. For V10, algebraic even cohomology is all ordinary even cohomology
and has rank four. Thus this is the full ordinary small-even QDM. The exact
counting-matrix convention is

\[
A(t)_{ij}=a_{ij}t^{j-i+1},
\tag{2}
\]

with entries below the first subdiagonal zero and the subdiagonal entries
equal to one.  The exact right determinant of $D-A(t)$,
$D=t\partial_t$, is

\[
\widehat L_{10}=D^4-10tD(D+1)(2D+1)
-16t^2(37D^2+74D+39)-2040t^3(2D+3)-8784t^4.
\tag{3}
\]

Golyshev's Corollary 2.6, before regularization, gives the algebraic quantum
$D$-module as a subquotient of $D/D\widehat L_{10}$.  After tensoring with
$\mathbf C(t)$, both differential modules have rank four; a rank-four
subquotient of a rank-four differential module is the whole generic module.
They therefore agree as meromorphic connections.  Punctual extension data do
not affect formal type at infinity.

## Regularization is not the QDM calculation

The regularized period satisfies the rank-three D3 equation

\[
D^3-2t(2D+1)(11D^2+11D+3)-4t^2(D+1)(2D+1)(2D+3).
\tag{4}
\]

Golyshev, arXiv:0908.1458, §2.1 steps 4--7 and §2.3, lists (4) for V10.
Golyshev, arXiv:math/0510287, §§1.8--1.11 and 2.7--2.10, defines this as a
Fourier--Laplace/convolution regularization and removes trivial constituents.
So (4) alone cannot determine `nu_6`. Equation (3) is the rank-four irregular
QDM required here.

CCGK, arXiv:1303.3288v3, §12 gives the independent period formula, including
the e^(-6t) mirror-map factor and regularized prefix. The prior finite period
replay agrees with it but carries no full-QDM inference.

## Period boundary

Writing a solution of (3) as $G=\sum g_nt^n$ gives the five-term recurrence

\[
\begin{aligned}
0={}&n^4g_n-10n(n-1)(2n-1)g_{n-1}\\
&-16(37n^2-74n+39)g_{n-2}\\
&-2040(2n-3)g_{n-3}-8784g_{n-4}.
\end{aligned}
\tag{5}
\]

The three-term recurrence of the regularized period belongs to (4), after
the Fourier--Laplace/convolution operation and removal of its trivial
constituent.  It is not the recurrence (5), and no termwise identification
between the rank-four QDM solution and the regularized D3 solution is made.
The cited source constructs the relation at the $D$-module level.

An independent direct WZ attempt on the displayed harmonic double summand was
not completed: a certificate must telescope both the hypergeometric quotient
and (H_m-H_{m-1}=1/m). No such certificate is claimed. The source route is
stronger for this task because it computes the all-degree quantum connection,
not merely a scalar period recurrence. A source-independent alternative would
need an explicit rational pair of WZ certificates for the two harmonic layers.

## Formal type

The exponential polynomial at infinity of (3) is

\[
\lambda^4-20\lambda^3-592\lambda^2-4080\lambda-8784
=(\lambda+6)^2(\lambda^2-32\lambda-244).
\]

The simple branches are 16 plus-or-minus 10 sqrt(5), with power exponent -3/2.
The double -6 branch has first nonzero indicial polynomial

\[
-4(2\alpha+1)(2\alpha+3),
\]

so powers -1/2 and -3/2.  After the repeated leading factor, the next
nonzero Newton coefficient is this degree-two indicial polynomial; the
formal recursion therefore introduces no further ramified exponential
scale.  The difference one is resonant; no absence-of-log claim is made.

For index one restore $t=q/z$.  The scalar-to-connection cyclic lift is, up
to constant basis rescaling,

\[
z^{j-3/2}\theta^j\Phi,
\qquad 0\le j\le3.
\tag{6}
\]

Every exponential is unramified in $z^{-1}$.  The scalar residues
$3/2,3/2,1/2,3/2$, after the C907 threefold framing shift by $-3/2$, become
$0,0,-1,0$.  Hence all framed formal-monodromy eigenvalues are one:

\[
\chi^{fr}_{V10}(T)=(T-1)^4,\qquad nu_6(V10)=0.
\]

## Primary-source audit

1. Przyjalkowski, *Gromov-Witten invariants of Fano threefolds of genera 6 and
   8*, arXiv:math/0410327, SHA-256
   `39c13194bcc63073d38f403a739f403028c3a5516ba72934ee03ba99179fbde2`,
   12 pages. Read §2.1--2.2 and Theorem 6.1.1 with proof: matrix and shift.
2. Golyshev, *Classification Problems and Mirror Duality*,
   arXiv:math/0510287, SHA-256
   `eae5ffa17114b5b05f932aa257d80c41ecaaaf798fd51f2324eb572a3f0d62f8`,
   20 pages. Read §§1.5--1.11 and 2.2--2.10: rank-four algebraic quantum
   submodule, right determinant, and Fourier regularization.
3. Golyshev, *Deresonating a Tate Period*, arXiv:0908.1458v1, SHA-256
   `2b86febd353682123278f6dcde659dc5e6b1492979b19aa6e9616608109f2405`,
   13 pages. Read §2.1 and §2.3: regularized D3 equation (4).
4. Coates--Corti--Galkin--Kasprzyk, *Quantum Periods for 3-Dimensional Fano
   Manifolds*, arXiv:1303.3288v3, SHA-256
   `a01ad88951e72c9b6ef16e8be2e08408bc6e6cf20e9133befe009d62782d9686`,
   104 pages. Read §12 and Appendix B: period and regularization conventions.

## Replay

```sh
nix shell nixpkgs#sage --command sage \
  notes/2026-08-12-c907-v10-full-qdm-replay.sage \
  notes/2026-08-12-c907-v10-full-qdm-certificate.json
```

The replay computes the noncommutative determinant and every formal coefficient
above. It makes no big-QDM, odd-sector, or arbitrary-centre claim.

The checked replay script has SHA-256
`69a7fdd6137881c527fa97c3ec61edd50685a586967df91c10ed89c8e95434a7`;
its generated certificate has SHA-256
`9da93b850f7fb365e5fda786784801aebdac99283742165cd3a4cdf939e05d94`.
