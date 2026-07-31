# C713 — Paper I proof architecture and structural node proof

**Lane:** `clebsch`

**Date:** 2026-07-31

## Result

Paper I now presents its main argument in causal order: the universal
chord-defect identity is followed immediately by the line bound, the rigidity
theorem, and the across-fields consequence.  The code, decoder, orbit ledger,
support bipartition, and orientation developments follow that completed
recognition argument.

The orientation proof is divided into orbital balance, triangle holonomy, the
determinant pencil, the node frame, frame symmetry, and the integral commutant.
The common-neighbor calculation is explicit: the four relations
`I,R,A,A'` contribute `10,-10,0,0` to `(A-A')^2`, giving
`(A-A')^2=10(I-R)` before restriction to the fibre-odd lattice.

Singular-locus completeness is now structural.  Over
`E=Q(sqrt(5))`, explicit bases for the two golden eigenspaces turn the support
cubic into the determinant of the cross block
`U(t_-)^T diag(x) U(t_+)`.  Its trace-orthogonal four-space has an explicit
nonzero determinant; the `A_5` character calculation identifies that
determinant with the smooth Clebsch diagonal cubic surface.  Proposition 10 of
Hassett--Tschinkel then gives exactly six ordinary nodes for the dual cubic
threefold.  Pair balance identifies those nodes with the six displayed frame
points.  The previous five-chart Buchberger exhaustion remains in the
paper-owned replay as an independent exact check.

The Cheltsov--Tschinkel--Zhang interface was checked against the original
source.  Their Proposition 7.3 assumes that the cubic is already six-nodal, so
it identifies the `S_5` model but does not transfer singular-locus
completeness.  The manuscript now says this explicitly and does not reverse
that hypothesis.

## Evidence and trust boundary

The structural completeness proof uses Brendan Hassett and Yuri Tschinkel,
*Flops on holomorphic symplectic fourfolds and determinantal cubic
hypersurfaces*, Section 3, Proposition 10.  The consulted arXiv source is
`arXiv:0805.4162`, SHA-256
`89ca37f2a5908c3355fda20bda6e8e469d22ffcc5f93232de88a60a7f700f885`.
The CTZ interface check used `arXiv:2401.10974`, SHA-256
`5fb44374d4a2c1790c6246a522e12df32afc7c9a81c9ca8bcd1ade62215df089`.

`papers/clebsch-rigidity/check_orientation_two_graph.py` now checks the two
golden eigenbases, the exact identity `det(Phi_x)=-C(x)`, the four-dimensional
trace complement, and nonvanishing of its determinant.  Its deterministic
summary is captured in
`papers/clebsch-rigidity/verification/checker_outputs.json`; the five gradient
ideals and six Hessian blocks remain independent checks.  The exact replay is

```sh
cd papers/clebsch-rigidity
python3 check_orientation_two_graph.py
python3 verification/capture_checker_outputs.py \
  --output verification/checker_outputs.json
```

The script is 22,267 bytes with SHA-256
`fa6f415debda3fc5963b55933371ffcba8e1cd32a825581d6fe0b0d09a2b2c3b`.
The thirteen-entry checker-output certificate is 2,221 bytes with SHA-256
`49dfee6970dc4c6630b010fd2e71d5083a0656fba0aca2ad72c8c47e7b523744`.

No theorem statement or formal interface changed.  The pinned q11 package
therefore retains the same Lean terminals and exactly the two declared Dye
axioms; only the manuscript proof and paper-owned replay changed.

## Validation state

- statement identity regeneration/check: green, nineteen rows;
- trust-manifest regeneration/check against the pinned q11 checkout: green;
- all thirteen deterministic checker-output identities: green;
- warning-free XeLaTeX build: green, twenty-one pages.

The clean aggregate release gate, standalone synchronization, and final
closeout are pending the clean-source commits required by the release
protocol.

## Mystery ledger

The required `ej`+`tt` closeout pass has not yet run.  This section will be
replaced at final closeout.
