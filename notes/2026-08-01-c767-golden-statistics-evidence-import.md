# C767 — Exact Golden statistics and evidence import

**Lane:** `golden`

**Status:** complete

## Result

C765 now has one paper-local evidence surface importing the exact claims it
uses from C715, C718, and C719. The compact checker verifies all three source
manifests, reads their canonical JSON certificates, and independently
recomputes the paper-facing rational identities, census totals, postselection
probabilities, Hamming distances, schedules, and mesh count.

The paper-local files are:

- `papers/golden-quantum-statistics/verification/check_imports.py`;
- `papers/golden-quantum-statistics/verification/c767-import-certificate.json`;
- `papers/golden-quantum-statistics/verification/SHA256SUMS`;
- `papers/golden-quantum-statistics/pyproject.toml`;
- `papers/golden-quantum-statistics/uv.lock`.

The checker and certificate hashes are

```text
33ac273a4d3ad1a672b96aed77734e3e14e95f70a7a504f041858a9aac0c4c33   10345  papers/golden-quantum-statistics/verification/check_imports.py
d8e1f4fe2f7a4473229c9e4a37e19da0d95e40f9cf204900741b2ec30c7582ab    4811  papers/golden-quantum-statistics/verification/c767-import-certificate.json
d58925c8c32e80d8971af330033b085a31857e9be14ff63b70520657ab116203     168  papers/golden-quantum-statistics/pyproject.toml
1e477e1b1f12759445102c654ff14b01d32e392ef9f1ccfc4950d4c47818e5e5    1756  papers/golden-quantum-statistics/uv.lock
```

The certificate also records the SHA-256 digest and byte count of every
load-bearing file in the three imported source manifests.

## Exact claims checked

### Boolean boundary

The (20+44) split is now a human theorem rather than an enumeration. If
(S\) is the negative support of a Boolean mask, orthogonality of the two
Golden port spaces gives

\[
 K_T(x)=-2\sum_{i\in S}
 (Q_{T,-}^{\mathsf T}e_i)(e_i^{\mathsf T}Q_{T,+}).
\]

Thus `rank K <= |S|`; complementing the mask also gives
`rank K <= 6-|S|`. Every unbalanced mask has rank at most two, accounting for

\[
 2\binom60+2\binom61+2\binom62=44
\]

zero determinants. The common balanced spectrum proves that the remaining
(inom63=20) masks are invertible.

### Exchange invariants

From the exact spectrum ((1/5,4/5,4/5)), the standard-library checker
recomputes

\[
 h_3=\frac{313}{125},\quad
 \frac{h_3}{10}=\frac{313}{1250},\quad
 e_3=\frac{16}{125},\quad
 s_{(2,1)}=\frac85,
\]

together with

\[
 h_3-e_3=\frac{297}{125},\qquad
 h_3+2s_{(2,1)}+e_3=\frac{729}{125}.
\]

### Calibrated bosonic census

The C718 certificate contains all twenty balanced records. The checker
confirms the two permanent-probability multiset classes of sizes eight and
twelve and the three labelled values

\[
 \frac{16}{3125},\qquad \frac{36}{3125},\qquad \frac{64}{3125}.
\]

These remain calibrated pivot-frame quantities, not intrinsic scalars.

### Rational chiral filter

The checker imports the C719 path filter

\[
 \left(1,\frac7{13},\frac17,-\frac15,-\frac12,-1\right)
\]

and verifies

\[
 Z=\frac{72}{455}(11,-10,-8,5,4,-2),
 \qquad
 P_{F,T}=\frac{(72/455)^2q_T^2}{500}.
\]

It checks all six exact probabilities and independently verifies
(sum q_T=\sum q_T^3=0). C715 independently supplies the same primitive
charge vector and the general inverse/cost normalization. The manuscript uses
the C719 rational filter and does not conflate it with C715's separate
height-three integral witness.

### Decoder and circuit

The checker verifies that the six ten-bit words have all fifteen pairwise
Hamming distances equal to six. It confirms:

- the explicit three-cut classifier at positions `(0,1,2)` distinguishes all
  six words;
- there are 60 three-cut classifiers;
- the five-cut schedule is `(0,3,4,7,9)`;
- hard nearest-word decoding corrects two sign errors;
- the base six-mode compilation has fifteen two-mode cells and reconstructs
  the target to error below (2\times10^{-15}).

## Trust classification

| claim | trust class |
|---|---|
| rank proof for 44 zero masks | human derivation |
| symmetric-function and Schur--Weyl identities | human derivation and standard-library exact recomputation |
| correction radius from distance six | human coding argument |
| balanced permanent census | C718 generated certificate and independent replay |
| rational filter and exact probabilities | C715/C719 generated certificates and independent replays |
| six words and schedules | C719 generated certificate and paper-local recomputation |
| 15-cell compilation and reconstruction residual | C719 generated certificate and independent replay |
| experimental feasibility and source availability | not certified by C767; C769 and C768 respectively |
| novelty and priority | not certified by C767; C768 |

The paper-local checker does not reimplement the full symbolic algebra inside
the three source generators. It validates their committed hashes and
independently recomputes the exact claims selected by C765.

## Environment and replay

The paper-local `uv.lock` was generated with `uv 0.9.30` and pins Python
3.12-compatible `sympy==1.14.0` and its transitive dependencies. This closes
the bare-environment failure in which the C718 generator could not import
SymPy.

From the repository root:

```sh
python3 papers/golden-quantum-statistics/verification/check_imports.py --check
make -C papers/golden-quantum-statistics verify-sources
make -C papers/golden-quantum-statistics check
```

The first command is standard-library only and leaves the worktree unchanged.
`verify-sources` uses the locked `uv` environment to regenerate/check C715,
C718, and C719 and then runs each independent replay. The last command checks
the import certificate and builds the seven-page manuscript without warnings.

## EJ + Tao closeout

The free strengthening was the rank proof of the entire 44-mask zero side.
It removes a finite-search dependency from a headline theorem and explains why
the determinant boundary occurs exactly at balance.

The Tao-style trust audit separated three kinds of statement that had been
mixed in the first scaffold:

1. the (20+44) split and symmetric-function identities are human theorems;
2. the permanent values, sign words, and mesh are exact finite certificates;
3. feasibility, source availability, and priority are external empirical or
   bibliographic questions and are not licensed by the algebraic checker.

It also caught the distinction between C715's integral witness and C719's
rational filter. The paper now names only the latter as its physical chiral
control.

## Mystery ledger

| feature | state | evidence gap or owner |
|---|---|---|
| why all 44 unbalanced Boolean controls vanish | settled by the rank-two proof | C767 manuscript proof |
| why the calibrated permanent census has exactly two multiset classes | exactly certified but not conceptually classified | secondary; no new task allocated |
| whether the five-cut schedule is optimal under a realistic correlated noise model | current schedule is exact for the stated hard/soft model | C769 if experimental modeling requires more |
| whether the antisymmetric source exists experimentally | outside computational evidence | C768 literature audit |

No unexplained feature blocks the C767 acceptance gate.
