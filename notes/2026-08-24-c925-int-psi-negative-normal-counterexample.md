# C925: universal INT-Psi fails at a negative-normal rational curve

> **Generalized later on 2026-08-24.** The same calculation gives an
> unbounded family in every codimension \(r\ge4\), with reconstructed
> base-square leakage \(q^kz^{r-4}\) for every \(k\ge1\); see
> `2026-08-24-c925-unbounded-int-psi-negative-normal-family.md`.

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-24

## Result

The base-row integrality hypothesis (INT-\(\Psi\)) formulated in
`2026-08-23-c925-fable-stokes-decorated-ledger.md` is false for general
Iritani blow-up edges.

There is a smooth projective fivefold \(X\) containing
\(Z\cong\mathbf P^1\) in codimension four with
\[
 N_{Z/X}\cong
 \mathcal O(-3)\oplus\mathcal O(-2)^{\oplus3}
\]
such that the coefficient of \(Q^{[Z]}\) in the base-to-base square block of
Iritani's reconstructed \(\Psi\) contains a nonzero \(q^{+1}\) term.  Thus
even the weakened integrality actually needed by the transport proof fails.

One realization is the line-projectivization
\[
 X=\mathbf P_{\mathbf P^1}
 \bigl(\mathcal O\oplus\mathcal O(-3)
                   \oplus\mathcal O(-2)^{\oplus3}\bigr),
\]
with \(Z\) the section defined by the subline \(\mathcal O\).  Its normal
bundle is the displayed quotient.  Blowing up this section is an ordinary
smooth projective Iritani edge.

This falsifies the proposed universal provider for the Stokes-decorated
ledger.  It does **not** prove that \(X_3\times\mathbf P^2\) is rational, or
that the every-cubic \(m=2\) irrationality statement is false: an AKMW chain
for a hypothetical parametrization might avoid this edge, and a weaker
factorization-specific lattice could still transport the marker.

## Calculation

Put \(r=4\), \(l=2\), and \(\rho_Z=c_1(N_{Z/X})\), so
\(\rho_Z\cdot[Z]=-9\).

1. Iritani (5.40) sends the degree-one centre monomial to
   \[
   Q_Z\longmapsto Q^{[Z]}q^{-(-9)/3}=Q^{[Z]}q^3.
   \]
   The unit component of the degree-one \(\mathbf P^1\) fundamental
   solution is nonzero:
   \[
   (H+z)^{-2}=z^{-2}-2Hz^{-3}\pmod{H^2}.
   \]
2. For the raw exceptional column \(c_{2,1}\), (5.44) at \(k=1\) gives
   \[
   q^{-1}\frac{(z)^{l+1}}z\,\iota_*1
     =q^{-1}z^2\iota_*1
   \]
   in the base row.  Lemma 5.12 uses the normalized source
   \(q^{-(l+1)/(r-1)}c_{2,1}=q^{-1}c_{2,1}\), so the normalized entry is
   \(q^{-2}z^2\).
3. The centre bulk phases are constant: \(\rho_Z\cdot[Z]=-9\) and
   \(l+1=3\) are divisible by \(r-1=3\).  Thus the degree-one centre term
   lies in the same constant Fourier mode as \(l=2\); there is no Fourier
   cancellation.
4. The competing base-block coefficient from the unit to \(\iota_*1\)
   vanishes.  Here \(c_1(X)\cdot[Z]=2-9=-7\), so the one-point space
   \(\overline M_{0,1}(X,[Z])\) appearing after the String Equation has
   virtual dimension \(-4\).
5. At first order in \(Q^{[Z]}\), Birkhoff factorization is linear.  Write
   \(\epsilon=q^{-1/3}\).  On the extremal base/constant-centre quotient,
   the normalized initial mixing and centre variation are
   \[
   b=\epsilon^6z^2,\qquad m=\epsilon^{-9}z^{-2}.
   \]
   Conjugation and projection to nonnegative \(z\)-powers give
   the base-to-base coefficient
   \(\delta\Psi_{\mathrm{base},\mathrm{base}}=bm\,\iota^*
   =q\,\iota^*\), independently of the remaining lower restriction data in
   (5.28).  On the unit column \(\iota^*1=1\), so it is nonzero.  The
   normalized exceptional-to-base coefficient is also \(q\), and returning
   from \(q^{-1}c_{2,1}\) to the raw exceptional column makes it \(q^2\).

The term is first order in its ambient Novikov monomial, has extremal
\((q,z)\)-bidegree, and has no base or Fourier competitor.  Hence higher
Novikov products and lower terms of the initial comparison cannot cancel it.

## Exact certificate

Artifacts:

- `notes/cubic-threefolds-tasks/c925-int-psi-negative-normal-counterexample-check.py`,
  5,797 bytes, SHA-256
  `129cb4e4641a230a6cb575be4f0bdde1587072bcd9acd4b1c0bb90290c390136`;
- `notes/cubic-threefolds-tasks/c925-int-psi-negative-normal-counterexample-check.json`,
  906 bytes, SHA-256
  `c4ceb723f9a1acdfce864f0ec2ba54abc4718c3dced7d602730e334ef4973366`.

Replay from the repository root:

```text
uv run --with sympy==1.14.0 python3 \
  notes/cubic-threefolds-tasks/c925-int-psi-negative-normal-counterexample-check.py \
  --check-certificate \
  notes/cubic-threefolds-tasks/c925-int-psi-negative-normal-counterexample-check.json
```

The checker uses exact symbolic algebra.  It verifies the degree and phase
arithmetic, the \(\mathbf P^1\) coefficient, the base virtual-dimension
vanishing, and the full two-by-two Birkhoff linearization with an arbitrary
lower restriction entry.  There is no independent implementation; every
checked identity is displayed above and the source formulas independently
fix its inputs.

## Source and read depth

No source was read at full-text depth for this focused audit.

- Hiroshi Iritani, *Quantum Cohomology of Blowups*, arXiv:2307.13555v3.
  **Read depth: partial** — definition (2.5) of the fundamental solution,
  Theorem 5.18, formulas (5.28), (5.40), (5.44), Lemma 5.12, and Section
  5.8.2's Birkhoff reconstruction.  Shared-cache key `arXiv:2307.13555`, PDF
  SHA-256
  `c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b`.

## Mystery ledger

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | Plain whole-loop integrality was insufficient but a joint \((q,z)\)-filtration might have saved the base row at mildly negative centres. | The earlier \(\mathcal O(-1)^2\) example is filtration-safe. |
| settled | The joint filtration itself fails universally once \(-\rho_Z\cdot d\) outruns the centre anticanonical pole order. | The codimension-four degree \(-9\) example gives \(q^{+1}\) already in the base-to-base block. |
| settled | Lower-triangular restriction data and the three Fourier modes cannot cancel the coefficient. | Arbitrary restriction parameter in the exact checker; constant-mode congruences. |
| open | Can weak factorization for a rationalization of a cubic stabilization be normalized to exclude such negative-normal edges? | No such factorization theorem is known or supplied by AKMW. |
| open | What replacement model transports the decoration through negative-normal edges? | A Rees lattice allowing controlled elementary modification, rather than raw base-row integrality. |

## Effect on C925

Route 1 of the Stokes-decorated-ledger note is closed false in its advertised
generality.  The every-smooth \(m=2\) theorem remains open, but it can no
longer be obtained by composing universal (INT-\(\Psi\)) across an arbitrary
AKMW chain.  The next valid choices are factorization control excluding
negative-normal edges or a decoration invariant under the explicit
\(q^{+1}\) elementary modification.
