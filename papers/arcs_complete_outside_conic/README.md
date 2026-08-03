# Arcs complete outside a conic

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.21682567.svg)](https://doi.org/10.5281/zenodo.21682567)

## Read the paper

[**Open the paper (PDF) →**](arcs_complete_outside_conic.pdf)

This repository contains the manuscript
*Arcs complete outside a conic: a prescribed-hole defect identity and
matching-design rigidity* by Tavis Rudd, together with its public
computational evidence.

For a nonsingular conic \(\mathcal C\subset PG(2,q)\), the paper studies arcs
\(A\) disjoint from \(\mathcal C\) whose secants cover every point outside
\(A\cup\mathcal C\). Its main contributions include:

- an exact prescribed-hole defect identity and its coverage consequences;
- matching-design rigidity in the zero-defect case;
- complete-affine and arbitrary-hole specializations;
- a lower bound for the minimum relative-complete arc size;
- evaluation obstructions for exceptional loci;
- a two-unit defect gap whenever the relevant maximum-matching design does
  not exist;
- verified values at \(q=5,8,9,11,13,16,17,19\), including
  \(\rho_{\mathcal C}(13)=8\), \(\rho_{\mathcal C}(16)=9\),
  \(\rho_{\mathcal C}(17)=9\), and \(\rho_{\mathcal C}(19)=10\); and
- a classification certificate excluding every eight-arc at \(q=16\).

The human-scale formal development is distributed in
[`tavisrudd/finitegeom`](https://github.com/tavisrudd/finitegeom). Its archived
0.2.0 release has DOI
[`10.5281/zenodo.21664257`](https://doi.org/10.5281/zenodo.21664257), and the
later matching-packing/small-odd supplement is fixed at commit
[`0b3f37d`](https://github.com/tavisrudd/finitegeom/commit/0b3f37d264f54b52e6c703a75e2704a3f9cbe4b4).
The generated exhaustive order-16 proof is in the separately pinned
[`finitegeom-q16-certificates`](https://github.com/tavisrudd/finitegeom-q16-certificates)
package at commit
[`ecee482d`](https://github.com/tavisrudd/finitegeom-q16-certificates/commit/ecee482dd8d3501a0077a0781398a34df5f0f604).
The manuscript identifies the exact gates, theorem names, trust boundaries,
and classical inputs. The formal sources are not bundled here.

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
- `search_rhoc16.cpp` and its frozen report — exact \(q=16\) augmentation
  generator.
- `check_q16_uncovered_patterns.py`, its JSON certificate, and checksum —
  line–triangle witnesses for the \(2630+3\) terminal partition.
- `small_odd_relative_conic_classifier.cpp`, its four canonical JSON
  summaries, the independent \(q=13\) frame check, and their checksum —
  exhaustive lower classifications at \(q=13,17,19\). Lean independently
  checks all three attaining witnesses; the lower classifications remain
  trusted executions, as stated in the manuscript.

## Reproduction

Build the manuscript with a full TeX Live installation:

```text
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
python3 check_q16_uncovered_patterns.py --check \
  --levels /absolute/path/to/finitegeom/RelativeConicArcs/Q16CertificateLevels.lean
```

The rank-three replay requires Singular; the other commands use the Python
standard library.

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

Regenerate the \(q=16\) search report with:

```text
g++ -O3 -std=c++20 search_rhoc16.cpp -o /var/tmp/search_rhoc16
/var/tmp/search_rhoc16 --emit-lean
```

The search report is a generation summary, not the formal certificate. The
kernel-checked transition and leaf modules in the separate formal repository
establish the exhaustive covering-list result.
