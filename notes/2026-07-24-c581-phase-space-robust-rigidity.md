# C581: quantitative phase-space rigidity

**Date:** 2026-07-31

**Lane:** `ame-lu`

**Status:** complete; positive ambient-Clifford theorem, negative semilinear upgrade

## Result

The rank-one contraction argument of C560 is quantitatively stable with an
explicit condition number. Let \(q=p^e\), let \(C,D\leq\mathbb F_q^6\) be
linear \([6,3,4]_q\) MDS codes, and let \(\Psi_C,\Psi_D\) be their normalized
equal-phase CSS states. Suppose, after an allowed party permutation, that

\[
 \min_{|\alpha|=1}\|(U_1\otimes\cdots\otimes U_6)\Psi_C-
 \alpha\Psi_D\|_2\leq\varepsilon .                            \tag{C581.1}
\]

Define

\[
 \tau_p=\min\left\{\frac13,\frac{\sin(\pi/p)}{2\sqrt2}\right\}.
\]

If \(2q^2\varepsilon<\tau_p\), then for every party \(i\) there is a
single-qudit Clifford \(K_i\), for the additive \(2e\)-dimensional
prime-field Weyl phase space, such that

\[
 q^{-1/2}\|U_i-K_i\|_{\rm HS}\leq2\sqrt2q^2\varepsilon .       \tag{C581.2}
\]

More locally, Hilbert--Schmidt error \(\eta\) between qualifying four-party
reduced states forces each of their four local factors within
\(\sqrt2q^2\eta\) of a Clifford, provided \(q^2\eta<\tau_p\). As in C560,
two four-party marginals covering all six parties suffice.

The word *Clifford* is essential. C623 makes every stronger uniform
conclusion false: at \(q=9\) there are exact nonsemilinear non-GRS
intertwiners, and at the \(q=25\) GRS boundary the fixed-party kernel is the
full \(\operatorname{Sp}_4(5)\). Thus no bound tending to zero with
\(\varepsilon\) can place all intertwiners near the semilinear subgroup, the
generic split torus, or a reconstructed Desarguesian spread. The theorem is
ambient prime-field phase-space rigidity, not robust exact reconstruction.

## 1. Quantitative diagonal-axis lemma

Let \(E_1,\ldots,E_r\), \(r\geq3\), be complex Hilbert spaces with
orthonormal \(N\)-frames \(e_{i1},\ldots,e_{iN}\), and put

\[
 T=a\sum_{j=1}^N\lambda_j e_{1j}\otimes\cdots\otimes e_{rj},
 \qquad a>0,\quad |\lambda_j|=1.                              \tag{C581.3}
\]

Let \(T'\) have the same form in other orthonormal frames, and suppose
unitaries \(A_i:E_i\to E_i'\) satisfy

\[
 \|(A_1\otimes\cdots\otimes A_r)T-T'\|_2\leq\eta,
 \qquad\delta=\eta/a<1/\sqrt2.                               \tag{C581.4}
\]

Then, in every factor, the frames admit a unique matching permutation such
that

\[
 \min_{|\alpha|=1}\|A_ie_{ij}-\alpha e'_{i,\pi_i(j)}\|_2
 \leq\sqrt2\delta.                                           \tag{C581.5}
\]

Indeed, contract the target tensor against one target frame vector. The
result has rank one. Pulling the contraction back through \(A_1\) and
flattening the remaining tensor between its second and last \(r-2\) factors
gives singular values

\[
 a|\langle e'_{1k},A_1e_{1j}\rangle|,
 \qquad1\leq j\leq N.
\]

Eckart--Young says that the sum of squares outside the largest coefficient
is at most \(\delta^2\). Since \(1-\delta^2>1/2\), two orthogonal rows cannot
choose the same dominant column, so the choices form a permutation. Applying
the same argument to the inverse equivalence gives the columnwise estimate,
and \(2(1-\sqrt{1-\delta^2})\leq2\delta^2\) gives (C581.5). This is C560's
rank-one proof with its discarded singular values retained. With unequal
nonzero coefficients, the same proof replaces \(a\) by the smallest
magnitude; that is the exact conditioning parameter.

## 2. From approximate axes to an exact Clifford

Use normalized Hilbert--Schmidt distance
\(d_2(V,W)=q^{-1/2}\|V-W\|_{\rm HS}\). Suppose conjugation by \(U\) sends
every Weyl axis within \(\kappa=\sqrt2\delta\) of a uniquely matched Weyl
axis.

Applying conjugation to a Weyl product in two ways shows that distinct
candidate labels would be at distance at most \(3\kappa\), whereas distinct
Weyl axes have phase-minimized distance \(\sqrt2\). Thus \(\delta<1/3\)
forces the label permutation to be additive. Conjugation preserves Weyl
commutators exactly. Replacing the four factors of a commutator by their
matched axes costs at most \(4\kappa\), while distinct \(p\)-th-root
commutator phases are separated by \(2\sin(\pi/p)\). Hence
\(\delta<\sin(\pi/p)/(2\sqrt2)\) forces the additive label permutation to
preserve the prime-field symplectic form. It is realized by an exact
Clifford \(K\).

It remains to control phases, not merely axes. Put \(V=K^\dagger U\) and
expand \(V=\sum_xc_xW_x\), with \(\sum_x|c_x|^2=1\). Axis closeness implies

\[
 \left|q^{-1}\operatorname{tr}(W_v^\dagger V W_vV^\dagger)\right|
 \geq1-\kappa^2/2
\]

for every \(v\). Character orthogonality gives

\[
 \sum_x|c_x|^4=q^{-2}\sum_v
 \left|q^{-1}\operatorname{tr}(W_v^\dagger V W_vV^\dagger)\right|^2
 \geq(1-\kappa^2/2)^2.
\]

Some \(|c_x|\geq1-\kappa^2/2\), so \(V\) is within \(\kappa\) of a phase
times \(W_x\). Absorbing that displacement into \(K\) proves

\[
 \min_{K\in\operatorname{Cliff}(q)}d_2(U,K)\leq\sqrt2\delta.  \tag{C581.6}
\]

This averaging step prevents an unjustified jump from an approximately
monomial adjoint action to a nearby implementing Clifford.

## 3. MDS--CSS conditioning

For a four-set \(S\), C560 writes the nonidentity reduced tensor as

\[
 T_S=q^{-4}\sum_{v\ne0}\lambda_v
 W_{1,L_1v}\otimes\cdots\otimes W_{4,L_4v}.
\]

After normalizing every Weyl operator by \(q^{-1/2}\), this is (C581.3) with

\[
 N=q^2-1,\qquad a=q^{-2}.                                    \tag{C581.7}
\]

The identity term cancels, so marginal Hilbert--Schmidt error \(\eta\) gives
\(\delta=q^2\eta\), proving the local bound. For pure unit vectors at
phase-optimized Euclidean distance at most \(\varepsilon\), their density
matrices have trace-norm distance at most \(2\varepsilon\). Partial trace
contracts trace norm and Hilbert--Schmidt norm is no larger than trace norm,
so every required marginal has \(\eta\leq2\varepsilon\), proving (C581.2).

The \(q^2\) factor is the reciprocal of one normalized Weyl-tensor
coefficient. It is the elementary worst-case scale for recovering every
axis from arbitrary marginal Hilbert--Schmidt perturbations. No matching
lower bound is claimed for globally compatible pure-state perturbations.

## 4. C623 boundary

The proof never reconstructs an \(\mathbb F_q\)-linear structure. It recovers
the complete additive Weyl axis set and then its \(\mathbb F_p\)-symplectic
commutator form. This is exactly why it survives C623.

- On the \(q=9\) non-GRS Frobenius--Gale divisor, exact zero-error
  intertwiners include 80 genuinely nonsemilinear elements in the order-96
  kernel.
- On the \(q=25\) GRS boundary, exact zero-error intertwiners fill
  \(\operatorname{Sp}_4(5)\), far beyond the semilinear subgroup.

An exact element outside either proposed smaller subgroup has positive
distance from that finite closed projective subgroup. Taking
\(\varepsilon=0\) disproves every uniform estimate toward it. The theorem
also does not estimate the pencil coordinate \(z\), distinguish nearby
Clifford orbits, or provide robust code reconstruction; those require
code-dependent separation data beyond the universal axis signal.

## 5. Literature boundary

One new source was consulted for this gate, and none was read at full-text
depth.

Arnab Auddy and Ming Yuan, *Perturbation Bounds for (Nearly) Orthogonally
Decomposable Tensors*, arXiv:2007.09024v2. **Read depth: `partial`**; cached
preprint key `arXiv:2007.09024`, SHA-256
`15f8c6ed870f85a90863fafa95a13a1df793bb7705b3ab3c210edb6383e7c746`;
abstract, Sections 1 and 2 through Theorems 2.4--2.5, and the stated proof
architecture were read. They prove dimension-independent perturbation bounds
for real order-\(p>2\) odeco singular tuples without a singular-value gap.
That is the closest general perturbation framework located. Their result is
broader as tensor perturbation theory; the argument here is a direct complex
equal-weight contraction proof and adds the Weyl multiplication, commutator,
and implementing-Clifford steps needed for this application.

C560 and C562 record the exact-rigidity literature boundary, including
Rains and Van den Nest--Dehaene--De Moor. No novelty or priority claim is
made for C581, no absence-of-prior-work verdict is used, and no manuscript
wording is adopted. A future adoption task should cite the general odeco
perturbation literature and present C581 only as the specialization needed
here, not as a new general tensor perturbation theorem.

## Acceptance gate

- **Positive:** C560's contraction locus is stable, with signal \(q^{-2}\),
  threshold \(\tau_p\), and factorwise bound (C581.2).
- **Positive:** the conclusion is a nearby implementing Clifford, not merely
  a nearby permutation of operator axes.
- **Positive:** the statement is uniform across C623's strata for the full
  additive Clifford target.
- **Negative:** uniform approximate semilinear, split-torus, or
  Desarguesian-spread reconstruction is impossible at zero error.
- **Deferred deliberately:** manuscript adoption, optimal constants, and
  code-parameter stability.

## `ej` + `tt` closeout

The free upgrade is the implementing-unitary bound: character averaging
turns approximate Weyl-axis normalization into distance from a genuine
Clifford without a dimension loss. The Tao check isolates the only small
denominator. Tensor-axis recovery has no coefficient-gap loss; the
\(p\)-dependent threshold enters only when distinct commutator roots must be
resolved exactly.

C623's exceptional strata are not badly conditioned versions of the generic
stratum. They have a different exact symmetry group. Treating their extra
elements as noise makes the stronger proposed theorem false at its base
point.

## Mystery ledger

| Feature | Disposition |
|---|---|
| Stability of C560's contraction locus | **Settled positively:** sine-angle error is at most \(\eta/a\), with \(a=q^{-2}\). |
| Equal coefficients and spectral-gap failure | **Settled:** order at least three identifies axes without coefficient separation. |
| Approximate axes versus an implementing Clifford | **Settled:** products, commutators, and character averaging prove (C581.6). |
| C623 enlarged kernels versus ambient rigidity | **Settled:** they are additive Cliffords inside the theorem's target. |
| Uniform semilinear or generic-torus rigidity | **Settled negatively:** exact C623 witnesses falsify it at zero error. |
| Optimality of the \(q^2\) pure-state factor | **Open but nonblocking:** no globally compatible lower bound is proved. |
| Robust recovery of \(z\) or the code | **Open outside C581:** it needs orbit-separation or reconstruction data. |

No unexplained degree of freedom remains in the axis-to-Clifford argument.

## Vibe check

Strong and clean. The robust theorem survives with a transparent condition
number, while C623 supplies an exact principled boundary rather than a
nuisance exception. It is useful as a quantitative upgrade but correctly
remains subordinate to the paper's exact rigidity theorem.
