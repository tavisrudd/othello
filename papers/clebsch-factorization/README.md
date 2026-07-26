# Clebsch factorization-memory paper

Working root for the standalone manuscript titled
*Conic-ideal quotients for the `A_3`, `B_3`, and `H_3` secant
configurations: quadratic sheet recovery and cubic orientation in types
`B_3` and `H_3`*.

- Owner: C577 in the `clebsch` lane.
- Inputs: the exact current-paper sections and supporting artifacts assigned by
  C575.
- Gate: open. Paper I has passed every local release gate; C182 waits only on
  the user-controlled immutable public deposit.
- Scope: matching products modulo the conic ideal, switch/divisibility,
  ranks `3,6,10`, balanced sheets, cubic orientation, six-profile
  reconstruction, modular depth, arithmetic splitting/gluing, and their
  verification architecture.
- Boundary: passage survival, four-sheet holonomy, theta/Fourier/quantum
  comparisons, carrier torsors, and Mathieu/characteristic-zero bridges remain
  outside this root unless a later editorial decision adopts them.

The warning-free candidate is `clebsch_factorization.tex`. Its standalone opening,
headline factorization theorem, marked-conic notation, matching-secant
quotient, switch mechanism, explicit rank-three matching configurations, and
exact `3,6,10` quotient-rank theorem are in place. The rank theorem separates
the symbolic conic-ideal/harmonic argument from the finite orbit calculation;
it packages the three ranks uniformly by Coxeter number
`dim W_T = h_T - 1 + 1_(h_T/2-1 even)`;
its `H_3` corollary identifies the five missing dimensions exactly as the
middle Fischer layer `Q H_2` and equivalently characterizes the image by
the covariant equation `Delta_Q f in F_11 Q`;
the balanced-sheet section proves a symbolic radical--Hadamard recovery
theorem, specializes it to the `7+7` and `11+11` sheets, and shows that the
first signed orientation moment is cubic;
the six-profile, modular-depth, arithmetic-gluing, and relative-cubic sections
are complete. A paper-specific twenty-statement trust manifest and aggregate
eight-bundle replay now separate conceptual, classical, certificate, and Lean
support. The conclusion states the exact reconstruction ladder and its
pointed/global limits. The full local release replay is green; a fresh
context-free referee-style coherence review is the remaining candidate gate.
C575's disposition is complete and authoritative. Import only the material
assigned to Paper II; the broad manuscript in
`../clebsch-hexagon-code/` remains an unchanged fallback, not a source to trim
wholesale.
