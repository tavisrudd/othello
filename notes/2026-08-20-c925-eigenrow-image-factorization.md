# Module 57. Eigenrow image factorization and the fixed-summand obstruction

**Packet part:** Module 57. Stable index:
`notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md`

**Status:** the algebraic equivalence below is proved. It compresses each
one-wall `CanVarFactor` of Module 56 to one eigenrow identity plus the
canonical image factorization of the named wall operation. It also supplies
an immediate no-go test: the retained row must vanish on every fixed vector
of that operation. The actual fixed-phase primitive-sixth occurrence has not
yet been shown to pass this test.

## 57.1 Canonical image factorization

Let \(R\) be a commutative domain, let \(a\in R\setminus\{0\}\), let
\(u\in R^\times\), let \(V\) be an \(R\)-module, and let

\[
                 N\in\operatorname{End}_R(V),
                 \qquad r:V\longrightarrow R.                \tag{57.1}
\]

Put \(P=\operatorname{im}N\), let \(c:V\twoheadrightarrow P\) be the
corestriction of \(N\), and let \(v:P\hookrightarrow V\) be the inclusion.
Thus \(vc=N\).

### Theorem 57.1 -- eigenrow/image-factorization equivalence

The following are equivalent.

1. There is a row \(\rho:P\to R\) such that

   \[
                         rv=a\rho,
                     \qquad \rho c=ur.                        \tag{57.2}
   \]

2. The raw row is a left eigenrow for \(N\):

   \[
                              rN=au\,r.                        \tag{57.3}
   \]

When these conditions hold, \(\rho\) is unique and is given by

\[
                          \rho(Nx)=u\,r(x).                    \tag{57.4}
\]

#### Proof

If (57.2) holds, then

\[
                          rN=rvc=a\rho c=au\,r.
\]

Conversely, assume (57.3). If \(Nx=Ny\), then

\[
              au\bigl(r(x)-r(y)\bigr)=rN(x-y)=0.
\]

Because \(R\) is a domain, \(a\ne0\), and \(u\) is a unit, this implies
\(r(x)=r(y)\); hence (57.4) is well defined. It gives

\[
          \rho c(x)=\rho(Nx)=u r(x),
          \qquad
          rv(Nx)=r(Nx)=au r(x)=a\rho(Nx).
\]

Finally, \(a\rho=rv\) and injectivity of multiplication by \(a\) on \(R\)
give uniqueness. \(\square\)

For Module 56 take \(N=1-T\). Thus the one-wall factor equations are not
two unrelated analytic normalizations: with the canonical image packet,
they are exactly the single identity

\[
                          r(1-T)=au\,r.                        \tag{57.5}
\]

No choice of can/var maps remains at the algebraic level. What remains
geometric is the exact occurrence reader identifying this integral image
factorization with the actual fixed-phase Malgrange packet and its closed
base change.

## 57.2 Immediate obstruction and closed-fibre laws

### Corollary 57.1A -- fixed vectors are row-null

Under (57.3),

\[
                         \ker N\subseteq\ker r.                \tag{57.6}
\]

Indeed \(Nx=0\) gives \(au\,r(x)=0\), hence \(r(x)=0\). Consequently, a
single retained vector fixed by \(T\) and visible to \(r\) disproves the
proposed one-wall factor before any Stokes calculation.

If \(R\) is local with maximal ideal \(\mathfrak m\) and
\(a\in\mathfrak m\), reduction of (57.5) gives

\[
                         \bar r\,\bar T=\bar r.                \tag{57.7}
\]

Thus positive normal order forces closed-fibre invariance of the row, while
the integral lift records the first nonzero normal defect.

### Corollary 57.1B -- two canonical image factors imply Module 56

Let \(R\) be a DVR, let \(V\) be finite free, let
\(N_i=1-T_i\) for \(i=1,2\), and suppose the **same** row \(r\) obeys

\[
                         rN_i=a_i u_i r,
       \qquad a_i\in\mathfrak m\setminus\{0\},\quad
              u_i\in R^\times.                               \tag{57.8}
\]

Then each \(P_i=\operatorname{im}N_i\) is finite free, and Theorem 57.1
constructs abstract factor rows satisfying the algebraic hypotheses of
Theorem 56.1. Hence their directed cross rows reduce to zero.

For the **actual Malgrange conclusion**, assume separately that the natural
map

\[
  (\operatorname{im}N_i)\otimes_R k\longrightarrow V\otimes_R k          \tag{57.8a}
\]

is injective with image \(\operatorname{im}(\bar N_i)\), and that these
image identifications match the actual fixed-phase packets, can/var maps,
rows, Gabrielov paths, order, and direction. Under those exact-reader
hypotheses, Corollary 57.1B gives both Module 54 projected variations.

This is the leanest algebraic producer currently known. It does **not** make
the occurrence theorem automatic: integral images need not commute with
specialization, and an abstract image packet need not be the actual
Malgrange block with the chosen path and direction.

## 57.3 What the specialized schober formula really tests

In Spenko--Van den Bergh, Proposition 12.6, write
\(z_j=e^{-2\pi i\gamma_j}\) for the displayed coefficient and
\(d_j=\iota b_j\) for the displayed character shift. For the Fourier
covector \(r_\eta([P_\mu])=\eta^\mu\), a moved generator has row coefficient

\[
              1-\prod_{j\in\mathcal J}
                    (1-z_j\eta^{-d_j}).                       \tag{57.9}
\]

The corresponding identity-minus-map row coefficient is therefore

\[
              A_{\eta,z}:=\prod_{j\in\mathcal J}
                    (1-z_j\eta^{-d_j}),                       \tag{57.10}
\]

up to the chosen wall orientation. Along a named DVR arc this is a candidate
eigenrow normal on the **moving quotient** only after proving
\(0<\operatorname{ord}_s A_{\eta,z}<\infty\) and factoring
\(A_{\eta,z}=a u\) with \(u\) a unit. At a fixed primitive character it can
instead be a unit or vanish identically. A common generator is fixed by the
wall map; if the same Fourier/rank covector is nonzero there, Corollary
57.1A forbids (57.5) on the full chamber module.

Hence Proposition 12.6 proves neither outcome globally. It gives a decisive
finite test for the actual primitive projection:

\[
\boxed{
 \text{does the fixed-phase primitive receiver kill the common fixed
 summand while retaining the moving rank line?}
}                                                               \tag{57.11}
\]

If yes, the moved coefficient and its valuation supply a candidate
eigenvalue. One must still prove that a stable fixed-plus-moving
decomposition spans the receiver and that **every** moving generator has the
same eigenvalue. Only then does the sieve prove the full eigenrow law. If the
projector leaves fixed leakage, the common-row double-normal route cannot
apply to that receiver.

This distinction also explains why using the unprojected rank row is too
strong: every wall has an unaffected chamber summand on which rank is
usually nonzero. The primitive-character projector is not cosmetic; it is
the only plausible mechanism currently available for removing that fixed
leakage.

## 57.4 Upstream type boundary

The source API should no longer accept arbitrary independently labelled
`CanVarFactor` values. It should expose the constructor shape

\[
\begin{aligned}
 \mathsf{imageFactor}:{}&
   \mathsf{CommonRow}(o,\gamma,\chi,R,V,r)\\
 &\to \mathsf{PositiveNormal}(R,a)\\
 &\to \mathsf{NamedOperation}(o,\gamma,\chi,V,T)\\
 &\to \mathsf{EigenrowLaw}(r,1-T,a,u)\\
 &\to \mathsf{ExactImageReader}
       (\operatorname{im}(1-T),\mathsf{actualPacket})\\
 &\to \mathsf{CanVarFactor}(o,\gamma,\chi,R,V,r,T,a).
                                                                  \tag{57.12}
\end{aligned}
\]

The private `EigenrowLaw` constructor forces the full equation (57.5), not
only agreement on a chosen moving basis. `ExactImageReader` contains
the certificate that the canonical image itself is admissible and already
saturated, exact closed base change, and the
path-, direction-, and row-compatible identification with the actual
packet. A proposed source with a row-visible fixed vector cannot construct
`EigenrowLaw`; a nonflat specialization cannot construct
`ExactImageReader`.

Replacing \(\operatorname{im}(1-T)\) by its saturation is not permitted:
that would change the canonical corestriction used in Theorem 57.1.

As in Module 56, this eliminates representational mismatches, not
epistemic circularity. The trusted implementation must still prove the law
and reader from source geometry rather than from the desired projected
vanishing.

## 57.5 Hostile tests

1. **Fixed leakage.** Let \(V=R^2\), \(N=\operatorname{diag}(a,0)\), and
   \(r(x,y)=x+y\). Then the first basis vector has the desired normal defect,
   but the second is fixed and row-visible. No \(u\in R^\times\) makes
   \(rN=au r\).
2. **Moving quotient only.** Restrict the preceding example to the first
   summand. Then \(rN=ar\), and Theorem 57.1 constructs the factor. This
   shows exactly what quotienting the fixed summand accomplishes.
3. **Nonexact image specialization.** Over \(R=k[[s]]\), let
   \(N(e_2)=s e_1\), \(N(e_1)=0\). The integral image is \(sRe_1\), whose
   tensor with \(k\) is one-dimensional, while the image of
   \(\bar N=0\) is zero. Thus an abstract integral image is not the closed
   Malgrange image without the exact reader.
4. **Row invariance is weaker.** Equation (57.7) alone does not recover the
   positive-order lift: \(N=0\) makes every closed row invariant but supplies
   no nonzero normal defect or divided row.

## 57.6 Source audit

- Spenko--Van den Bergh, *Perverse schobers and GKZ systems*,
  [arXiv:2007.04924](https://arxiv.org/abs/2007.04924), Proposition 12.6.
  The Fourier-covector computation (57.10) is a direct algebraic consequence
  of their displayed moved-generator formula. Their Theorem 13.1 remains
  nonresonant and supplies no exact integral image specialization.
- Module 56 supplies the double-normal theorem consumed in Corollary 57.1B.
- Modules 25 and 40 explain why image formation and rank-one coimages require
  saturation/exact-base-change certificates over a trait.

## 57.7 EJ/TT and mystery ledger

**EJ.** The can/var factor is canonical once the eigenrow law is known. The
real source computation is therefore a left-eigenvector calculation for the
primitive projected wall operation, followed by one exact image-reader
theorem.

**TT.** Test the fixed summand first. It is cheaper and more decisive than
building a resonant Stokes receiver: one surviving row-visible fixed vector
refutes the common-row route. If the primitive projector kills it, compute
the Fourier covector on the moving window and only then invest in the
resonant image comparison.

| question | status | evidence or exact remaining gate |
|---|---|---|
| Are the two one-wall row equations independent? | **no** for the canonical image factorization | Theorem 57.1 |
| What is their single source condition? | \(r(1-T)=au r\) | (57.5) |
| What is the cheapest falsifier? | a row-visible \(T\)-fixed vector | Corollary 57.1A |
| Does the specialized schober formula give a candidate moving normal? | **conditionally** | (57.9)--(57.10), plus a named DVR arc and positive finite valuation |
| Does it prove the law on the full chamber module? | **no** | common fixed-generator obstruction |
| Can the primitive projector remove that obstruction? | **open occurrence calculation** | test (57.11) |
| Does integral image automatically equal closed Malgrange image? | **no** | hostile test 3 |
| Does this prove \(m=2\)? | **no** | primitive projection and exact image reader remain open |

## Boundary

The first \((1,1)\) source problem has a new pass/fail order. First compute
the primitive projected wall operation. Use the fixed-summand condition
(57.6), the moved coefficients, their DVR valuations, and uniformity across
a stable spanning decomposition as a sieve for the full identity (57.5).
Only if the identity itself passes should one construct the resonant
Fourier--Laplace image reader. This
does not prove the occurrence theorem, but it prevents spending analytic
effort on an algebraically impossible common-row receiver.
