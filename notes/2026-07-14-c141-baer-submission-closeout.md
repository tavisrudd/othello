# C141 — Baer submission closeout

**Date:** 2026-07-14
**Lane:** `baer`
**Status:** STARTED — LaTeX source complete; PDF compile pending

## Goal

Produce the submission artifact and run the final manuscript-to-Lean, citation, trust, formatting,
and adversarial-referee audit before routing/archive disposition.

## Current result

The focused submission source is
[`frobenius_pair_extension.tex`](../papers/equivariant-robust-completion/frobenius_pair_extension.tex)
with a conventional BibTeX database in the same directory. It has stable theorem, equation, and
cross-reference labels; a self-contained proof spine; an explicit computer-assisted proof boundary
for the exceptional profile; and a paper-to-Lean declaration map.

Static closeout checks completed:

- every cited key exists exactly once in `refs.bib`;
- braces and begin/end environments balance, and `git diff --check` passes;
- the uniform Q25 theorem, global semantic count, collision equality/excess results, exceptional
  profile conclusion, and profile lower bounds match the checked Lean declarations;
- the saturation ceiling and geometric case split are explicitly identified as paper proofs;
- the external census/minimum are isolated as data and are not theorem inputs;
- the manuscript makes no historical-first, sharpness, generic-robustness, or `s=5`-family claim.

The adversarial pass added the missing derivation of the fixed-point first moment `48`, derived the
full-occupation completed-square identity instead of asserting it, and added exact source/declaration
locations for reproducibility. Final disposition awaits a successful TeX/BibTeX compile and warning
audit; no build was launched while another agent's heavyweight Lean build window was active.
