# C925: unbounded negative-normal failure of universal INT-Psi

**Lane:** cubic-threefolds · **Task:** C925 · **Date:** 2026-08-24

## Theorem

For every pair of integers \(r\ge4\) and \(k\ge1\), there is a smooth
projective \((r+1)\)-fold \(X_{r,k}\) containing a rational curve
\(Z\cong\mathbf P^1\) in codimension \(r\) such that the first ambient
Novikov coefficient of Iritani's reconstructed comparison \(\Psi\) contains
the nonzero base-to-base term

\[
\boxed{q^k z^{r-4}\,\iota^*.} \tag{1}
\]

In particular, the universal base-square integrality hypothesis
(INT-\(\Psi\)) fails in every codimension at least four, and its positive
\(q\)-valuation loss is unbounded.

Take

\[
A=(r-1)(k+2),\qquad
N=\mathcal O(-(r-1)(k+1))\oplus\mathcal O(-1)^{\oplus(r-1)}, \tag{2}
\]

so \(\deg N=-A\), and let

\[
X_{r,k}=\mathbf P_{\mathbf P^1}(\mathcal O\oplus N) \tag{3}
\]

in the line convention. The subline \(\mathcal O\) defines a section \(Z\)
with normal bundle \(N\). Blowing up \(Z\) is therefore an ordinary smooth
projective edge in Iritani's theorem.

The earlier codimension-four example with
\(N=\mathcal O(-3)\oplus\mathcal O(-2)^3\) is the \((r,k)=(4,1)\)
antidegree, with a different splitting of the same total normal degree.

## First-order calculation

Choose the exceptional Fourier index \(l=r-2\). Iritani (5.44), at
exceptional degree one, gives the raw base mixing

\[
q^{-1}z^{r-2}. \tag{4}
\]

Lemma 5.12 normalizes the source by

\[
q^{-(l+1)/(r-1)}=q^{-1},
\]

so the normalized mixing is

\[
b=q^{-2}z^{r-2}. \tag{5}
\]

The centre ring extension (5.40) and the unit term
\((H+z)^{-2}=z^{-2}-2Hz^{-3}\) in the degree-one \(\mathbf P^1\)
fundamental solution give

\[
m=q^{A/(r-1)}z^{-2}=q^{k+2}z^{-2}. \tag{6}
\]

Both the Fourier character \(l+1=r-1\) and \(A\) are divisible by
\(r-1\), so every centre summand lies in the same nonzero Fourier/bulk mode.
There is no cancellation among the \(r-1\) summands.

At first ambient Novikov order, Birkhoff factorization is linear. On the
extremal base/constant-centre quotient, retain an arbitrary lower restriction
entry \(u\). The exact two-by-two calculation gives

\[
\delta\Psi_{mathrm{base},\mathrm{base}}=u b m,
\qquad
bm=q^kz^{r-4}. \tag{7}
\]

Because \(r\ge4\), the \(z\)-power in (7) is nonnegative and enters the
positive factor. On the unit column, \(u=\iota^*1=1\), proving (1). Returning
from the normalized source \(q^{-1}c_{r-2,1}\) to the raw exceptional column
also gives the nonzero term \(q^{k+1}z^{r-4}\).

The competing base one-point coefficient vanishes:

\[
c_1(X_{r,k})\cdot[Z]=2-A,qquad
\operatorname{vdim}\overline M_{0,1}(X_{r,k},[Z])=r+1-A<0. \tag{8}
\]

The term (7) is first order in its ambient Novikov monomial and has the
extremal displayed bidegree, so higher Novikov products and lower initial
terms cannot cancel it.

## Consequences

1. No finite universal \(q\)-shift repairs (INT-\(\Psi\)): choosing \(k\)
   larger defeats it.
2. A decorated quantum marker cannot be transported through arbitrary
   smooth weak-factorization edges by a fixed Novikov lattice. Any valid
   theorem needs factorization restrictions or an elementary-modification/
   Rees object that records the valuation jump.
3. Tschinkel--Zhang's stably rational cubic threefolds require an eventual
   failure of any purported all-stabilization marker. The family above gives
   a general local mechanism for such failure, though it does not assert that
   one of these precise edges occurs in their unknown rationalization chain.
4. The every-smooth \(m=2\) irrationality question remains open. This theorem
   closes only the universal (INT-\(\Psi\)) provider across arbitrary AKMW
   chains.

## Exact certificate

- `notes/cubic-threefolds-tasks/c925-int-psi-negative-normal-family-check.py`,
  5,008 bytes, SHA-256
  `87f6d04974ba2bd9dd4081746bccaa59e4e79c260ef18094bc7558833dc03fd6`;
- `notes/cubic-threefolds-tasks/c925-int-psi-negative-normal-family-check.json`,
  18,209 bytes, SHA-256
  `c97c6e2c495b7f0d6cae93f357c2e437dfaba72df5b91eb9029bc1c9c1099dd6`.

Replay:

    uv run --with sympy==1.14.0 python3 \
      notes/cubic-threefolds-tasks/c925-int-psi-negative-normal-family-check.py \
      --check-certificate \
      notes/cubic-threefolds-tasks/c925-int-psi-negative-normal-family-check.json

The script proves the symbolic two-by-two Birkhoff identity and checks 28
exact members \(4\le r\le10\), \(1\le k\le4\). The displayed algebra proves
the unrestricted integer family; the finite sweep is a regression witness,
not the source of the quantifier.

## Source and scope

- Hiroshi Iritani, *Quantum Cohomology of Blowups*, arXiv:2307.13555v3.
  **Read depth: partial** — (5.28), (5.40), (5.44), Lemma 5.12, and Section
  5.8.2. Shared-cache PDF SHA-256
  `c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b`.

This is a theorem about Iritani's formal reconstruction and its Novikov
lattice. It is not a rationality or irrationality theorem for the ambient
projective bundles, nor for cubic stabilizations.

## Mystery ledger

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | Universal base-square INT-\(\Psi\) | False for all \(r\ge4\), with leakage \(q^kz^{r-4}\). |
| settled | Bounded reindexing repair | Impossible because \(k\) is arbitrary. |
| settled | Fourier or base cancellation | Constant Fourier mode and negative virtual dimension (8). |
| open | Cubic \(m=2\) | Requires factorization control or a valuation-jump-tolerant marker. |

**Resume line:** go C925 cubic-threefolds — universal INT-\(\Psi\) now fails
in an unbounded family; retain \(2\le s(X)\le4\) for the explicit
Tschinkel--Zhang cubics and seek an intrinsic level-three quotient or a
factorization-specific \(m=2\) marker.
