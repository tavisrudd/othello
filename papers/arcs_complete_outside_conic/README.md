# Secant defects with prescribed holes

[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.21682567-blue.svg)](https://doi.org/10.5281/zenodo.21682567)

## Read the paper

[**Open the paper (PDF) →**](arcs_complete_outside_conic.pdf)

This repository contains the manuscript
*Secant defects with prescribed holes: arcs, caps, and matching designs*
by Tavis Rudd, together with its public
computational evidence.

In any finite projective plane of order \(q\), if \(\mathcal H\) is an
arbitrary prescribed set of \(q+1\) points, every arc \(A\) disjoint from
\(\mathcal H\) whose secants cover all points outside
\(A\cup\mathcal H\) satisfies
\(|A|\geq\sqrt{2q}+3/2-8/\sqrt{2q}\).  The first two secant moments give the
exact defect identity behind this universal bound, with pointwise
nonnegative local summands. Equality converts the canonical
secant-concurrency decomposition of the Kneser graph into a maximum-matching
design; over a finite field that design has a rank-three projective
realization.  The same identity supplies a quantitative deletion bound away
from equality.

For the specialization \(\mathcal H=\mathcal C\), where \(\mathcal C\) is a
nonsingular conic, the paper classifies zero defect in characteristic two and
determines \(\rho_{\mathcal C}(13)=8\), \(\rho_{\mathcal C}(16)=9\),
\(\rho_{\mathcal C}(17)=9\), and \(\rho_{\mathcal C}(19)=10\). The defect
identity, equality criterion, and deletion stability are independently
formalized in Lean; the finite-field values use the trust boundaries stated
below.

The Lean formalization is distributed in
[`tavisrudd/finitegeom`](https://github.com/tavisrudd/finitegeom). Its archived
0.2.0 release has DOI
[`10.5281/zenodo.21664257`](https://doi.org/10.5281/zenodo.21664257), and the
later matching-packing/small-odd supplement is fixed at commit
[`575cf3e`](https://github.com/tavisrudd/finitegeom/commit/575cf3e991168fb96eb24c318263c5d0552aa531).
The generated exhaustive order-16 proof is in the separately pinned
[`finitegeom-q16-certificates`](https://github.com/tavisrudd/finitegeom-q16-certificates)
package at commit
[`0b04429b`](https://github.com/tavisrudd/finitegeom-q16-certificates/commit/0b04429b6da2226f5cb53d299264cb782e54e000),
which pins `finitegeom` at `a7665be6`, an ancestor of the commit above.
The manuscript identifies the exact gates, theorem names, trust boundaries,
and classical inputs. The Lean sources are not bundled here.

## Contents

- `arcs_complete_outside_conic.tex` — manuscript source.
- `verify_relative_conic_arcs.py` and its frozen output — independent
  finite-field witness verification.
- `check_evaluation_dichotomy.py` — small-field checks of the sharp
  evaluation threshold.
- `check_q11_structure.py` and `check_q11_structure.cpp` — independent
  \(q=11\) structure, invariance, and mutation checks.
- `check_match10_rank_three.py`, its JSON certificate, and checksum —
  rank-three realization evidence.
- The exact \(q=16\) augmentation generator `scripts/search_rhoc16.cpp` with
  its frozen report, and the line–triangle pattern checker
  `scripts/check_q16_uncovered_patterns.py` with its JSON certificate for the
  \(2630+3\) terminal partition, are in the `finitegeom-q16-certificates`
  package pinned above, not in this repository.
- `small_odd_relative_conic_classifier.cpp`, its four canonical JSON
  summaries, the independent \(q=13\) frame check, and their checksum —
  exhaustive lower classifications at \(q=13,17,19\). Lean independently
  checks all three attaining witnesses; the lower classifications remain
  trusted executions, as stated in the manuscript.

## Reproduction

Rebuild the manuscript and check the tracked PDF against that build:

```text
nix develop .#manuscript --command \
  python3 verification/check_manuscript_build.py
```

The pinned flake fixes the TeX toolchain and the checker fixes the build clock,
so the rebuilt PDF must equal the tracked one byte for byte; `--update`
refreshes the tracked PDF from the same build. With a full TeX Live
installation and no Nix, the underlying command is:

```text
SOURCE_DATE_EPOCH=1767225600 FORCE_SOURCE_DATE=1 \
  latexmk -xelatex -interaction=nonstopmode -halt-on-error \
  arcs_complete_outside_conic.tex
```

Run the independent witness verifier:

```text
python3 verify_relative_conic_arcs.py
```

Replay the compact public certificates:

```text
python3 check_match10_rank_three.py --check
```

The rank-three replay requires Singular. In a checkout of
`finitegeom-q16-certificates` at the pinned commit, the order-16 pattern
checker replays against the level data that package carries:

```text
python3 scripts/check_q16_uncovered_patterns.py --check
```

Replay the small odd-order classifications with:

```text
g++ -O3 -std=c++20 -Wall -Wextra -Werror \
  -Wno-array-bounds -Wno-stringop-overread \
  small_odd_relative_conic_classifier.cpp -o /var/tmp/classify-small-odd
/var/tmp/classify-small-odd 13 7 /var/tmp/q13.json
/var/tmp/classify-small-odd 17 8 /var/tmp/q17.json
/var/tmp/classify-small-odd 19 8 /var/tmp/q19-k8.json
/var/tmp/classify-small-odd 19 9 /var/tmp/q19.json --extension-witness
diff -u small_odd_q13.json /var/tmp/q13.json
diff -u small_odd_q17.json /var/tmp/q17.json
diff -u small_odd_q19_k8.json /var/tmp/q19-k8.json
diff -u small_odd_q19_k9.json /var/tmp/q19.json
python3 small_odd_q13_frame_check.py /var/tmp/q13-frame.json
diff -u small_odd_q13_frame_check.json /var/tmp/q13-frame.json
sha256sum -c small_odd_relative_conic.sha256
```

Regenerate the \(q=16\) search report from the same package checkout with:

```text
c++ -O3 -std=c++20 scripts/search_rhoc16.cpp -o search_rhoc16
./search_rhoc16 --emit-lean
```

The search report is a generation summary, not the formal certificate. The
kernel-checked transition and leaf modules in that package establish the
exhaustive covering-list result.
