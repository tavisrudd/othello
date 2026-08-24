# C925: the INT-Psi reconstruction gate and the stable-rationality boundary

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-24

## Outcome

Iritani's Section 5.8 reconstruction does **not**, as stated, propagate the
base-row integrality hypothesis (INT-\(\Psi\)) from the initial slice.  Its
Birkhoff lifting is integral once the **whole** reconstruction loop is over
the valuation ring, but the paper constructs that loop only over the Laurent
field.  The centre ring extension (5.40) has a genuine source of negative
valuation: for an effective class \(d\) on the centre,
\[
 Q_Z^d\longmapsto Q^{\iota_*d}q^{-\rho_Z\cdot d/(r-1)}.
\]
Thus a negative normal degree produces a positive power of \(q\).  For a
rational curve with normal bundle
\(\mathcal O(-1)\oplus\mathcal O(-1)\) in a threefold, this is \(q^2\), and
the degree-one term of the \(\mathbf P^1\) fundamental solution is nonzero.
The naive integral-input proof therefore stops before Birkhoff
factorization.  This does not yet prove that the actual base row of
\(\Psi\) is nonintegral: a sharper filtration coupling \(z\)-pole order to
\(q\)-valuation could still protect that row.

Separately, Tschinkel--Zhang now refute C925's every-smooth all-stabilization
target.  Their Theorem 1.3 and Proposition 5.1 give explicit stably rational
smooth cubic threefolds over \(\mathbf Q\).  Stable rationality persists over
\(\mathbf C\), so for each such threefold some projective stabilization is
rational.  More explicitly, their Section 4 proves that the relevant quartic
del Pezzo generic fibre becomes rational after adjoining eleven variables;
applying this over \(\mathbf Q(\mathbf P^1)\) shows, by the function-field
calculation, that their \(r=0\) cubic satisfies
\(X\times\mathbf P^{11}\dashrightarrow\mathbf P^{14}\).  This last cubic
bound is our deduction from their generic-fibre proof, not a separately
stated theorem of the paper.

The every-smooth \(m=2\) target survives.  For a Tschinkel--Zhang cubic, the
lane's unconditional \(m=1\) theorem and the preceding upper bound give
\[
 2\le s(X):=\min\{m:X\times\mathbf P^m\text{ is rational}\}\le10.
\]
An \(m=2\) theorem would sharpen this to \(3\le s(X)\le10\).  The upper
bound is improved by the successor projectivized-torsor argument in
`2026-08-24-c925-type-i1-level-ten-rationality.md`.  C925 should
therefore retain \(m=2\) as its endpoint and treat all-\(m\) transport only
as falsifier-guided mechanism analysis.

## 1. What Section 5.8 actually reconstructs

Iritani writes the decomposition in coordinates \((t,s,Q)\) and forms the
external direct sum \(M\) of the quantum D-modules of the base and centre.
The loop
\[
 (\Psi^\circ)^{-1}M
\]
is factorized into a negative fundamental-solution factor and the positive
factor \(\Psi^{-1}\).  The construction is explicitly over
\(\mathbf C((q^{-1/s}))[[Q,t,s]]\), and the uniqueness statement is a formal
Birkhoff factorization.  Neither the theorem nor the factorization lemma
asserts preservation of \(\mathbf C[[q^{-1/s}]]\).

Let \(\epsilon=q^{-1/s}\).  If the full loop is in
\(\operatorname{Mat}_n(\mathbf C[[\epsilon]])((z^{-1}))\) and its reduced
factorization has the required block-triangular shape, the ordinary
\(\epsilon\)-adic lifting recursion is
\[
 \mu_k+\phi_k
   =\beta_k-\sum_{i+j=k}\mu_i\phi_j,
\]
followed by projection to negative and nonnegative \(z\)-powers.  It uses no
division and therefore remains integral.  The exact checker verifies this
through \(\epsilon^5\), with exact finite \(z\)-support and deliberately full
matrix perturbations.  It also verifies that the positive factor reduces to
base row \((I,0)\).

This is only a conditional lifting lemma.  It cannot be applied merely from
integrality of the initial base row: Birkhoff factorization mixes all rows of
the loop.

## 2. The missing input is real

Iritani's centre extension (5.40) sends a centre Novikov monomial as above.
For \(Z=\mathbf P^1\) with
\(N_{Z/X}=\mathcal O(-1)\oplus\mathcal O(-1)\), codimension \(r=2\) and
\(\rho_Z\cdot[Z]=-2\), so
\[
 Q_Z\longmapsto Q^{\iota_*[Z]}q^2.
\]
Modulo \(H^2=0\), the linear Novikov coefficient of the \(\mathbf P^1\)
fundamental solution is
\[
 \frac1{(H+z)^2}=z^{-2}-2Hz^{-3},
\]
which is nonzero.  Hence the centre block of the reconstruction loop really
contains a positive-\(q\) term.  A proof that begins "the entire loop is
\(\epsilon\)-integral" is unavailable even at this basic flopping-type
centre.

The remaining possibilities are sharply separated:

1. prove a filtered Birkhoff lemma in which every positive \(q\)-valuation
   loss in a centre block carries enough negative \(z\)-order that it cannot
   enter the positive factor's base row; or
2. calculate the first dangerous coefficient for a negative-normal rational
   centre and exhibit actual base-row leakage.

The present calculation proves neither alternative.  In particular it is
not a counterexample to (INT-\(\Psi\)); it is a counterexample to the proposed
**whole-loop integral-input proof** of (INT-\(\Psi\)).

## 3. Exact certificate

Artifacts:

- `notes/cubic-threefolds-tasks/c925-fable-int-psi-reconstruction-check.py`
  — 8,883 bytes, SHA-256
  `b96c6cdf9dadf56d3a7dce112e742dea70f8fe3664772539d8e1468203e34235`;
- `notes/cubic-threefolds-tasks/c925-fable-int-psi-reconstruction-check.json`
  — 664 bytes, SHA-256
  `c2e26a999e2984d61bb28075847c5296b011fe8db9f23940e4dc0f812c75c1ca`.

Replay from the repository root with SymPy 1.14.0:

```text
uv run --with sympy==1.14.0 python3 \
  notes/cubic-threefolds-tasks/c925-fable-int-psi-reconstruction-check.py \
  --check-certificate \
  notes/cubic-threefolds-tasks/c925-fable-int-psi-reconstruction-check.json
```

The checker is deterministic exact algebra over \(\mathbf Q[\epsilon]\).
Leg A checks the lifting identity modulo \(\epsilon^5\), exact \(z\)-support,
absence of division, factor reductions, and the reduced base row.  Leg B
checks only the stated \(\mathbf P^1\) coefficient and the exponent in
(5.40).  There is no independent implementation: the formulas are direct
symbolic identities, and the source displays (5.40) and the standard
\(\mathbf P^1\) coefficient provide the independent mathematical check.

## 4. Sources and read depth

No source was read at full-text depth for this focused audit; both verdicts
rest on the listed partial reads.

- Hiroshi Iritani, *Quantum Cohomology of Blowups*, arXiv:2307.13555v3.
  **Read depth: partial** — Theorem 5.18, displays (5.37)--(5.40), and
  Section 5.8, especially (5.45)--(5.48) and the Birkhoff reconstruction.
  Shared-cache key `arXiv:2307.13555`, PDF SHA-256
  `c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b`.
- Yuri Tschinkel and Zhijia Zhang, *Universal torsors over quartic del Pezzo
  surfaces and stable rationality*, arXiv:2608.20029v1.
  **Read depth: partial** — abstract and introduction (Theorems 1.1--1.3),
  Section 4's "Levels of stable rationality", and Section 5 through
  Proposition 5.1 and its generic-fibre argument.  Shared-cache key
  `arXiv:2608.20029`, PDF SHA-256
  `be1dedd42662eae0c9d83d08d7379cdd78974000f0be048db50680833a5d01e6`.

## 5. Bounded adjacent-crown extraction

The exact pre-emption is only the every-smooth all-\(m\) crown; the
every-smooth \(m=2\) result survives.  The bounded pass inspected the paper's
two future-work paragraphs (stabilization level and density in moduli), its
comparison there with the older type-\(I_0\) bounds, and the explicit
type-\(I_1\) construction.  It produced four candidates:

1. determine or lower-bound \(s(X)\) for the explicit type-\(I_1\) cubic;
2. improve the restricted type-\(I_3\) permutation-resolution upper bound
   \(11\) for the type-\(I_1\) subgroup actually used by Proposition 5.1;
3. identify the first decorated-ledger failure along an explicit
   rationalization chain for that cubic; and
4. study density of the stably rational locus in cubic-threefold moduli.

Cheap tests of the top two: candidate 1 passes and is already exactly C925's
surviving \(m=2\) endpoint, so no new task is needed.  Candidate 2 is a
finite integral-permutation-lattice problem, but the paper provides only the
five-to-eleven resolution for type \(I_3\) and no smaller type-\(I_1\)
resolution or total-space construction; it does not beat candidate 1's EV
and is not allocated.  Candidate 3 lacks an explicit weak-factorization
chain, and candidate 4 is a moduli problem outside C925.  No successor ID is
allocated by this extraction pass.

## Mystery ledger

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled | Integral Birkhoff lifting itself introduces no denominators when the full input loop is integral. | Section 1 and certificate leg A. |
| settled | Iritani's stated reconstruction does not provide that full-loop premise; negative normal degree creates genuine positive powers of \(q\) in centre blocks. | Section 2, (5.40), certificate leg B. |
| settled | The every-smooth all-\(m\) target is false; special smooth cubic threefolds are stably rational. | Tschinkel--Zhang Theorem 1.3 and Proposition 5.1. |
| open | Does a joint \((q,z)\)-filtration protect only the positive factor's base row despite nonintegral centre blocks? | First successor in Section 2. |
| open | What is the exact stabilization level of the Tschinkel--Zhang cubic? | Current bounds \(2\le s(X)\le10\); the upper bound is the successor projectivized-torsor result, while \(m=2\) remains the lower-bound gate. |

## Next

For C925, compute the first reconstructed base-row coefficient for a
codimension-two rational curve with negative normal degree, retaining both
the \(q\)-valuation and \(z\)-order.  A nonnegative answer should be promoted
to the filtered Birkhoff invariant needed for all dimension-five AKMW edges;
a negative answer falsifies (INT-\(\Psi\)) and identifies the replacement
decoration.  Do not pursue an every-smooth all-\(m\) theorem.
