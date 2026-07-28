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
- verified values at \(q=5,8,9,11,16\), including
  \(\rho_{\mathcal C}(16)=9\); and
- a classification certificate excluding every eight-arc at \(q=16\).

The formal development is distributed separately in
[`tavisrudd/finitegeom`](https://github.com/tavisrudd/finitegeom). The
manuscript identifies the exact gate, theorem names, trust boundary, and
classical inputs. The formal sources are not bundled here.

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

Regenerate the \(q=16\) search report with:

```text
g++ -O3 -std=c++20 search_rhoc16.cpp -o /var/tmp/search_rhoc16
/var/tmp/search_rhoc16 --emit-lean
```

The search report is a generation summary, not the formal certificate. The
kernel-checked transition and leaf modules in the separate formal repository
establish the exhaustive covering-list result.
