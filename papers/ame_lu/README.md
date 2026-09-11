# Robust Local-Unitary Rigidity of Stabilizer AME States

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21681856-blue.svg)](https://doi.org/10.5281/zenodo.21681856)

## Read the paper

[**Open the paper (PDF) →**](ame-lu.pdf)

An absolutely maximally entangled state, or AME state, is maximally mixed on
every subset containing at most half its parties. Such states are perfect
tensors: any balanced cut identifies one half with the other by a unitary.

For additive stabilizer `AME(2m,q)` states, with `q=p^e` and `m≥2`, the paper
asks how much freedom remains in a product change of basis. It proves two
rigidity results: an exact conversion has Clifford factors, and a sufficiently
accurate product symmetry is close to an exact symmetry with a controlled
collective residual.

The local Clifford action is `Sp(2e,F_p)`. No `F_q`-linearity assumption is
made, and the result concerns the factors of the supplied unitary itself.

## The two rigidity results

| Result | Hypothesis | Conclusion |
|---|---|---|
| Exact rigidity | A product unitary maps one stabilizer `AME(2m,q)` state to another | Every one-party factor is Clifford; party relabelling is allowed |
| Robust rigidity | A product unitary approximately preserves a fixed stabilizer AME state, with defect below `R(n,q)` | It factors into an exact product symmetry and a quantitatively small residual |

For `n=2m`, define the phase-optimized state-vector defect and radius by

```text
ε(U)   = min_{|z|=1} ||Uψ − zψ||,
R(n,q) = min{1/(4 sqrt(2q)), 1/(8π sqrt(n))}.
```

If `ε(U)<R(n,q)`, then, up to a global phase,

```text
U = g ⊗_i exp(i h_i),       gψ ∝ ψ,
(sum_i ||h_i||_F²)^(1/2) ≤ π sqrt(q) ε(U).
```

Each `h_i` is traceless Hermitian with spectral spread at most `π`;
`||·||_F` is the unnormalized Frobenius norm. Before exact-branch selection,
every local factor rounds to a Clifford within normalized Hilbert–Schmidt
distance `8ε(U)`.

The radius is a two-parameter statement. The support count implies
`n≤2(q²−1)`, excluding unbounded fixed-`q` families. On Reed–Solomon families
with `n≤q+1`, the certified scale is `Theta(q^(-1/2))`. A one-party
three-eigenvalue perturbation shows that this dimension exponent is necessary
when the spectral-spread requirement and collective coefficient are both
retained. The upper and lower bounds match in order on every existing family with
`n≤Cq`; their general party-count dependence remains open.

## Why the proofs work

1. **A marginal exposes every Weyl axis.** Stabilizers supported on any
   `m+1` parties project bijectively onto the Weyl labels of each retained
   party. Tensor uniqueness then forces each local unitary to preserve
   those axes, which is precisely Cliffordness.
2. **Cleaning recovers the same discrete frames approximately.** Regard one
   party as the logical input of a stabilizer encoder. Three correctable
   regions and a Weyl–Fourier concentration argument round the local action.
3. **Overlap separation selects an exact symmetry.** Quantized stabilizer
   overlaps resolve the discrete branch. A balanced-cut estimate controls
   the combined residual generators.

The four-qutrit state

```text
ψ = (1/3) sum_{x,y in F_3} |x, y, x+y, x+2y>
```

runs through the stabilizer, transition-map, character-repair and verification
constructions. An `F_9` example explains why the additive local Clifford group
is larger than the `F_q`-linear subgroup.

## Finite structure and recognition

A half-set gives a systematic stabilizer matrix. Its invertible party blocks
define transition maps, and consistency around fundamental four-cycles gives
a complete invariant for fixed-party local-unitary equivalence.

**Input:** promised stabilizer-AME check matrices, with fixed party labels.
**Output:** inequivalence or compact symplectic witnesses. When stabilizer
phases are supplied, a linear solve supplies a Clifford–Pauli conversion.

Over a prime field, the four-entry intertwiner space turns the determinant
condition into one quadratic form. Decision is deterministic; exact witnesses
are constructed by a Las Vegas algorithm, whose randomness affects runtime
only. Using classical matrix arithmetic:

```text
O(m³ + log q) field operations from check matrices,
O(m² + log q) field operations from systematic matrices.
```

The witness bounds are expected. With `b=ceil(log_2 q)`, a sufficient bit bound
is `O(m³ b²+b³)`. Efficient nonbinary local-Clifford recognition was already
established by Bahramgiri and Beigi; the paper gives the AME reduction and
explicit growing-prime cost using classical quadratic-form methods.

For arbitrary additive prime-power dimension `q=p^e`, the general enumeration
bound remains

```text
O((me)^3 + |Sp(2e,F_p)| m² e³) operations in F_p.
```

Unknown party relabelling introduces a separate exhaustive-search factor of
at most `(2m)!`. The prime-field improvement does not replace the full
additive symplectic problem over extension fields.

The compatible symmetry group is controlled by an intrinsic endomorphism
algebra. In prime local dimension there are five possible algebra types.
Four-party states always have algebra `M_2(F_q)` and compatible symplectic
group `SL_2(q)`; six-party states always have algebra dimension at least two.
These prime-field refinements do not restrict the scope of the rigidity
results.

## Marginals, verification and conversion

- **Optimal marginal determination.** Exactly `m` appropriately chosen
  `m+1`-party marginals determine a stabilizer AME state among all density
  operators. Both the marginal size and number are minimal. Their support
  projectors give a commuting parent Hamiltonian at the smallest possible
  locality.
- **Complementary marginal tests.** Randomly test one of `2m` supports,
  each containing `m+1` parties. The optimal uniform verification gap is
  `ν=(m+1)/(2m)`, giving `1−F≤r/ν` from rejection probability `r`.
  Joint operations inside a tested subset are allowed; this is a restriction
  on total test support, not a count of laboratory measurement bases.
- **Universal extension.** The uniform gap and determination from any `m`
  tests in this complementary library hold for arbitrary AME targets. The
  exact weighted and test-count tradeoffs are proved for stabilizer targets;
  the universal weighted result is a lower bound.
- **An observable entry criterion.** Under a product-unitary preparation
  promise, a rejection bound below `ν(R²−R⁴/4)` implies robust rigidity.
  Independent all-pass repetitions give an explicit confidence bound and a
  sufficient sample count of order `max{q,n} log(1/α)`, up to integer rounding.
- **Exact stochastic conversion.** Every successful product-Kraus branch
  between two stabilizer AME states has factors proportional to Clifford
  unitaries. Exact single-copy conversion therefore has optimal success
  probability one or zero according to local Clifford equivalence.

## Reading guide and scope

Start with the two introductory rigidity theorems, the support dictionary,
and the exact proof. The worked example connects the notation before the
marginal and verification consequences. The robust proof uses the
Pauli-compatible Choi encoder constructed in the encoder subsection.
Prime-field algebra classification and the weighted/universal verification
proofs are separate routes for readers interested in those questions.

At the universal defect radius `sqrt(2)/68`, the rounded symplectic frames
already preserve the transition maps. This does **not** ensure a nearby exact
product symmetry: the stabilizer-character correction can remain large.
The paper distinguishes this obstruction from local Clifford rounding and
from the smaller global radius above.

The verification statements assume trusted measurements. The stochastic
conversion results are exact and single-copy; they do not cover approximate
filtering, catalysts or arbitrary tensor-network equivalence. Exact MDS–CSS
logical groups and six-point applications are treated separately.

## Proof and evidence boundary

The results have manuscript proofs, with standard inputs cited at their use.
The theorem proofs do not depend on a computation or certificate. The
companion recognition implementation has exhaustive small-field regression
tests and independent reference oracles. Selected support, axis, holonomy, character, Choi and second-moment
algebraic cores have partial Lean formalizations. The principal rigidity,
verification, low-party algebra and spectral-chart theorems are not
end-to-end formalized. Appendix D states the precise boundary; the paper does
not supply a self-contained replay contract for those partial developments.

## Build and verification

From this directory:

```text
make check
make software-check
python3 release/verify_release.py
```

`make check` lints the sources, rebuilds the PDF and rejects TeX warnings.
The default build uses Nix to obtain XeLaTeX and latexmk; an existing TeX
installation can be selected with `make check LATEXMK=latexmk`.
`make software-check` replays the exact recognition tests and verifies their
source/output hashes. The release verifier checks the recorded public-source,
software and PDF hashes. In a
paper-only checkout it reports that the formal companion is absent; it does
not claim to have checked those recorded formal artifacts.

## Companion implementation

[`software/prime-recognition/`](software/prime-recognition/) contains the
reference algorithm, a JSON example using the four-qutrit state, independent
exhaustive oracles, and a reproducible test record. It accepts promised
prime-field check matrices or systematic block arrays and returns compact
symplectic frames. It does not construct dense Clifford lifts or perform the
subsequent character repair. See its README for the exact input convention,
commands, test domains and evidence boundary.

## Files

- `ame-lu.pdf` is the paper; `main.tex` is its manuscript driver.
- `sections/` contains the proofs, worked example and appendices.
- `figures/` contains the source diagrams.
- `refs.bib` contains the bibliography, including version-pinned arXiv links.
- `release/` contains the artifact manifest and its verifier.
- `.zenodo.json` contains deposit metadata.

## Citation and license

The DOI link is [10.5281/zenodo.21681856](https://doi.org/10.5281/zenodo.21681856).
The current source revision may be newer than the deposited version.
The manuscript is licensed under Creative Commons Attribution 4.0
International; see [LICENSE](LICENSE).
