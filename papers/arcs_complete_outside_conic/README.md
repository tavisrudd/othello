# Arcs complete outside a conic

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

The formal development is distributed separately in
[`tavisrudd/finitegeom`](https://github.com/tavisrudd/finitegeom). The
version-independent archival locator is the Zenodo concept DOI
[`10.5281/zenodo.21650878`](https://doi.org/10.5281/zenodo.21650878).
The manuscript identifies the exact gate, theorem names, trust boundary,
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
- `2026-07-25-c637-secant-hull-coupling.cpp`, its four canonical JSON
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
  2026-07-25-c637-secant-hull-coupling.cpp -o /var/tmp/classify-small-odd
/var/tmp/classify-small-odd 13 7 /var/tmp/q13.json
/var/tmp/classify-small-odd 17 8 /var/tmp/q17.json
/var/tmp/classify-small-odd 19 8 /var/tmp/q19-k8.json
/var/tmp/classify-small-odd 19 9 /var/tmp/q19.json --extension-witness
diff -u 2026-07-25-c637-q13.json /var/tmp/q13.json
diff -u 2026-07-25-c637-q17.json /var/tmp/q17.json
diff -u 2026-07-25-c637-q19-k8.json /var/tmp/q19-k8.json
diff -u 2026-07-25-c637-q19-k9.json /var/tmp/q19.json
python3 2026-07-25-c637-q13-frame-check.py /var/tmp/q13-frame.json
diff -u 2026-07-25-c637-q13-frame-check.json /var/tmp/q13-frame.json
sha256sum -c 2026-07-25-c637.sha256
```

Regenerate the \(q=16\) search report with:

```text
g++ -O3 -std=c++20 search_rhoc16.cpp -o /var/tmp/search_rhoc16
/var/tmp/search_rhoc16 --emit-lean
```

The search report is a generation summary, not the formal certificate. The
kernel-checked transition and leaf modules in the separate formal repository
establish the exhaustive covering-list result.
