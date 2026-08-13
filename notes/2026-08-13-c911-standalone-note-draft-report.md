# C911 — standalone discrepancy-one flip repair note: draft report

Date: 2026-08-13
Lane: `clebsch`

Status: IN PROGRESS (written incrementally).

## Scope

Produce a short standalone note from `notes/2026-08-13-c907-shen-shoemaker-codim2-repair.md`
(read-only source, owned by the C907 session), verify every cited item against the
cached preprint PDF, build it in `papers/`, and export a standalone repository under
`~/src/math-papers/`.

Target preprint: Y. Shen, M. Shoemaker, *Quantum spectrum and Gamma structure for
standard flips*, arXiv:2502.08762v2.
Cached PDF `/tmp/persistent/tavis/lit-search/pdf/arxiv_2502.08762.pdf`,
SHA-256 `2c1d25490d53d1eb04da11e4ad8eec2d9834b25e765462186181292e7f085cce`.

## Decisions

- Alias / directory: `papers/discrepancy-one-flips`, main source
  `discrepancy_one_flips.tex`, sections under `sections/`.  Nothing under
  `papers/` used that name before.
- Layout copied from `papers/cubic-stabilization-epilogue`: `Makefile`
  (`nix develop ..#manuscript` + `latexmk -xelatex`, `SOURCE_DATE_EPOCH`
  pinned), `flake.nix`/`flake.lock`, `LICENSE` (CC BY 4.0), `README.md`.
  No Lean, no verification directory, no certificate: the note has no
  computational content.
- The note is stated for the whole discrepancy-one range `r = s+1`, `s >= 1`,
  with the blow-up specialization `s = 1` (codimension-two blow-up
  `(r,s) = (2,1)`) written out, because the sector numbers in the C907 source
  are the `s = 1` values.
- No novelty sentence, no acknowledgements, no Lean, no C907 programme
  material.  Author: Tavis Rudd only.

## Verification against the PDF

Cached PDF hash re-checked: matches the recorded SHA-256.  All items below
were read in the extracted text `text/arxiv_2502.08762.txt` and, where the
wording matters, re-extracted from the PDF with `pdftotext -layout`.

Confirmed as printed in arXiv:2502.08762v2:

- Setup (Section 1.1): `V, V'` of rank `r, s` over `Z`, `F = P(V)` with
  `N_{F|X} = pi^*(V') (x) O_{P(V)}(-1)`; `s = 1` is a blow-up, `s = 0` is the
  degenerate projective-bundle case with `X = F`, `X' = empty`.  Standing
  assumption `r > s` (stated twice in Sections 3 and 4).
- Theorem 1.2 (quantum spectrum) is stated with the hypothesis
  "Assume that `r - s > 1`".
- Theorem 4.4 is stated with the hypothesis "Assume `r - s > 1`".
- Formula (35) is exactly
  `J^T = z e^{t/z} q^{c_1(T)/z} sum_d q^{(r-s)d} prod_{j=1}^{s}
  prod_{m=0}^{d-1}(sigma_j - H - mz) / prod_{i=1}^{r} prod_{m=1}^{d}
  (rho_i + H + mz)`.
  The numerator's `m = 0` factors carry no `z`; the `q`-exponent is
  `(r-s)d`, not `d` (the C907 note's `q^d` is the `r-s=1` specialization).
- Remark 4.5(3), verbatim: "In the case `r - s <= 1`, the right-hand side
  (35) is not of the form `1z + (lower order terms in z)` and therefore
  cannot be equal to the `J` function of `T`.  Nevertheless it can be shown
  using [11], [12], and Lemma 9.6 that (35) lies on the Lagrangian cone of
  `T`, and therefore gives an `I`-function for `T`."
- Theorem 4.6 gives presentations (36), (37); its proof specializes `t` in
  Theorem 4.4, derives a quantum differential equation for `J^T`, and quotes
  [14, Thm 10.3.1] / [39, Lemma 2].  Its only use of `r - s > 1` is through
  Theorem 4.4.
- Formulas (39)/(40): "By using the `J`-function formula in (35)" the
  modified extremal `J`-function of the local model is defined.  Sections 7
  and 8 use that object throughout, so the whole asymptotic analysis inherits
  the Theorem 4.4 hypothesis.
- Propositions 5.1, 5.2 and Corollary 5.3 use only the presentation (45) =
  (37) and the ring map of Theorem 3.3; they carry no `r - s > 1` hypothesis
  of their own.  So Theorem 1.2's hypothesis is inherited from Theorem 4.4
  as well.
- Lemma 7.4: `kappa_m = e^{-pi i c_1(V')} G^{r,0}_{s,r}(1-sigma_1, ...,
  1-sigma_s ; rho_1, ..., rho_r | e^{-pi i (2m+s)} (q/z)^{r-s})`.  Hence
  `p = s`, `q = r` and `nu = r - s` in the Appendix A convention.
- The sentence introducing (64) reads "For `r - s > 1`, we apply Barnes'
  asymptotic formula ... (see Theorem A.1)".  Sector (64) is
  `|arg(z/q) + pi(2m+s)/(r-s)| < (1 + 1/(r-s)) pi`, which is exactly
  Theorem A.1's `|arg t| < (nu + epsilon) pi` with `epsilon = 1`.
- Theorem A.1: `nu := q - p`, `epsilon = 1` if `nu > 1` and `epsilon = 1/2`
  if `nu = 1`; the expansion holds for `|arg t| < (nu + epsilon) pi`, with
  leading factor `exp(-nu t^{1/nu})`.
- Proposition 8.2's sector (78) is `|arg(z/q) - (1-s)pi/(r-s)| < pi/2 +
  pi/(r-s)`, and it is derived from Theorem A.2 (via (76)), whose hypothesis
  `|arg t| < (nu/2 + 1) pi` carries no `epsilon` and is valid at `nu = 1`.
- Theorem 1.4 asserts the results "also hold in the cases `s = 0` and
  `s = 1`"; its two halves are Theorem 9.9 and Theorem 9.14.  Remark 1.6's
  common-sector condition is `(r-s-6)/4 < k < 3(r-s+2)/4`, quoted from (64)
  and (78).

Computations performed here and used in the note:

- Maximal `z`-order of the degree-`d` summand of (35):
  `1 + s(d-1) - rd = 1 - s - (r-s)d`.  For `r-s = 1`, `s >= 1` this is
  `1 - s - d <= -1` for every `d >= 1`.  For `(r,s) = (1,0)` the `d = 1`
  summand has order `0`, so that case is genuinely excluded.
- At `nu = 1`, Theorem A.1 with `epsilon = 1/2` gives the center sector
  `|arg(z/q) + (2m+s)pi| < 3pi/2`; for `k = 0`, `m = 0`, `s = 1` this is
  `-5pi/2 < arg(z/q) < pi/2`.  (The task brief quoted `-3pi/2 < ... < pi/2`
  for the center sector; that value is the intersection, matching the C907
  source's display (8), not the Appendix A sector.  The note prints both.)
- At `nu = 1`, (78) gives the ambient sector
  `|arg(z/q) - (1-s)pi| < 3pi/2`; for `s = 1`, `|arg(z/q)| < 3pi/2`.
- Intersection for `k = 0`, `m = 0`: `(-s pi - pi/2, -s pi + 3pi/2)`, of
  width exactly `2 pi`, containing the eigenvalue ray `arg(z/q) = -s pi` and
  the tame ray `arg(z/q) = (1-s) pi`.  For `s = 1` this is
  `-3pi/2 < arg(z/q) < pi/2`, containing `-pi` and `0`, in agreement with the
  C907 source.  The same width-`2pi` conclusion holds for `k = 1`, `m = -1`.
- The eigenvalue at `r = s+1`, `k = 0` is `lambda_0 = (-1)^s q`; for `s = 1`
  this is `-q` and the exponential factor `exp(-lambda_0/z) = exp(q/z)`,
  matching the C907 source.

## Build

- (pending)

## Export

- (pending)

## Open items

- (pending)
