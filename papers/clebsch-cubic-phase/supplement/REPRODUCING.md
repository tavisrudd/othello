# Reproducing the cubic-phase calculations

All paths below are relative to the artifact root. The included programs use
exact modular and integer/rational arithmetic for decisions. The lightweight
certificates are deterministic. Historical sampled searches identify their
seeds and domains in their source; samples are not used as exhaustive bounds.

## Toolchain and routine checks

The committed `flake.lock` pins Nixpkgs, Python and TeX. The `manuscript-compute`
shell additionally supplies NumPy, SymPy, Rust and Cargo. Cargo lockfiles pin
Rust dependencies. Enter it for the optional commands below:

```sh
nix develop .#manuscript-compute
```

The ordinary `make check` uses only Python's standard library, takes several
seconds, and verifies the source identities plus the lightweight finite, shadow
and factory certificates. `make pdf-check` additionally needs the manuscript
shell's TeX tools and verifies a fresh byte-identical PDF.

## Signed matrices and invariant normal forms

```sh
cd supplement/reconstruction
python3 check1.py
python3 check3.py
```

`common.py` specifies the signed evaluation matrices and modular conventions.
The positive sheet precedes the negative sheet. `check1.py` verifies code-space
and Schur-space dimensions and signed moments. `check3.py` identifies the binary
quartic and octavic invariant normal forms using symbolic substitution.
The independent standard-library expansion is
`python3 verification/finite_check.py --check` from the artifact root.

## Exact Hessian spectra

Build the Rust census program from the artifact root:

```sh
cargo build --release --locked --manifest-path supplement/spectra/rank11/Cargo.toml
supplement/spectra/rank11/target/release/rank11 supplement/spectra/tensor7.txt --low 3
```

The program normalizes the first nonzero coordinate to one and exhausts the
projective domain; scalar homogeneity then gives vector counts. It uses exact
finite-field Gaussian elimination. The tensors record their field and number
of variables. The lightweight Python check derives the `p=7` tensor from the
matrices, providing an independent full traversal.

The large `p=11` replay is a separate command:

```sh
supplement/spectra/rank11/target/release/rank11 supplement/spectra/tensor11.txt --low 6
```

It visits `2593742460` projective representatives. The recorded run took about
82 seconds on 24 cores; wall time depends on hardware and available parallelism.
Set `RAYON_NUM_THREADS` to control the number of census/search workers.
`rank11-out.txt` records ranks and low-rank representatives. The vector counts
at ranks `0,5,6,7,8,9,10` are
`(1,120,14520,80520,21442960,2387485210,23528401270)`.
A hash check of this output does not independently repeat the enumeration.

`supplement/spectra/check2.py` is a second exact small-field implementation;
run it from its own directory. It also compares the translation and triangle
resources and writes the minimum-rank locus. The remaining symbolic scripts
expose tensor, minimum-locus and weighted cubic-rank calculations.

## Conic trades and distance-three exclusion

```sh
cargo build --release --locked --manifest-path supplement/classification/search/Cargo.toml
supplement/classification/search/target/release/conic-search trades 7
supplement/classification/search/target/release/conic-search dist3
```

`trades P` enumerates perfect matchings, quotients by translations, buckets
classes by first/second moments and tests third-moment differences. The affine
quotient and optional `--sym` restriction are stated in the program.
Stored unrestricted domains for `p=5,7,11,13,17,19` have respectively
`3,15,945,10395,2027025,34459425` translation classes and
`0,3,2,1,0,0` inequivalent hits. The `p=19` search took about five minutes on
24 cores. This is a bounded source classification, not an all-primes theorem.

`dist3` exhausts `61927311` reduced-row-echelon subspaces of the fixed
six-dimensional quotient, in dimensions two through six. It checks whether
the maximal admissible X-space separates the same evaluation columns as the
candidate logical space. No nonzero restricted cubic passes. The remaining
one-dimensional case is treated in the manuscript. The computation has one
implementation plus a domain-count check; it does not exclude other ambient
codes or code switching.

From `supplement/classification`, `python3 test3a_verify.py 7 11 13` rebuilds
reported matching hits independently of the Rust trade search. It invokes the
compiled census program for exact small cases. The `p=13` Hessian sample has
20000 vectors and is not an exact rank distribution; new `p=11,13` X-distance
values are upper bounds. Raw records and tensors are in `out/`.

## Chordal restriction

From the artifact root:

```sh
python3 supplement/replay_shadow.py
```

The runner copies the supplementary sources to a disk-backed cache directory,
then executes the nine reconstruction stages in order. The stages compute the
configuration, group action, `1+4+5` decomposition, augmentation embedding,
invariant pencil, Hankel identification, invariant cubics, sign actions and
field survey. It finishes by comparing the regenerated explicit shadow
certificate. Logs go to the user's cache; the tracked inputs are not overwritten.
Typical runtime is roughly half a minute.

The included axis certificate provides the comparison cubic from *Chordal and
Conference Cubics: Reconstruction and a Residual C₂-Torsor*. The portable
`verification/shadow-certificate.json` fixes coefficient order, the augmentation
embedding, actual and projectively normalized cubics, and the involution.
The geometric non-lifting test explicitly compares all preserving restrictions;
non-equivariance alone is not used to infer non-lifting. Arbitrary full-gate
lifts are not classified.

## Factory certificate

```sh
python3 supplement/factory/benchmark.py --check
```

The generator exhausts native and primitive error words and synthesis kernels,
uses independent MacWilliams/Fourier identities, and evaluates the interval
bounds rationally. The weight-distribution inputs, exact comparison table and
constants are in `certificate.json`. Its lower cubic-rank input is the
manuscript's `lem:waring`, not a rank theorem proved by the enumerator.
The comparison allows the stated four-, six- and seven-input primitive modules,
independent concatenation and weighted linear-form synthesis. It does not cover
pooled distillation, unrestricted adaptive protocols or noisy Clifford gates.
