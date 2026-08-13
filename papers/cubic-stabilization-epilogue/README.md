# Irrationality after one stabilization

Working authority for the unnumbered geometric epilogue to *Clebsch: Rigidity
from Sparse Shadows*.

The paper studies a non-isotrivial family of smooth cubic threefolds whose
members are universally `CH_0`-trivial, while their products with
`P^1` are irrational.  It also proves that `X x P^1` is irrational for every
smooth cubic threefold, that the quantum obstruction is birationally invariant
through dimension four, and that every smooth `V_14 x P^1` is irrational.

The manuscript is `cubic_stabilization_epilogue.tex`.  Build and check it with:

    make check

The paper is proof-first.  Exact computations used during discovery are not
part of its proof surface.  The current draft gives standalone human proofs of
the six-axis realization, all-degree finite-etale graph saturation, and the
one-step irrationality argument.
The built review copy is
[`cubic_stabilization_epilogue.pdf`](cubic_stabilization_epilogue.pdf).

The Mathlib-only formal companion is in [`lean/`](lean/).  It is an explicitly
partial reviewer artifact: its rejecting claim inventory covers every labelled
theorem-like environment and distinguishes proved fragments and conditional
deductions from claims that remain absent.  See
[`lean/README.md`](lean/README.md) for the exact interim coverage and replay
commands.
