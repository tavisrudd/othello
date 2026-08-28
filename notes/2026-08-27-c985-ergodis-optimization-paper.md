# C985 Ergodis exact algebraic optimization paper

**Lane:** `complete-ports`

**Status:** QUEUED AFTER C983; OPTIMIZATION-FACING PAPER RESEARCH

**Date:** 2026-08-27

## Objective

Develop a follow-on paper presenting ergodis as a structure-aware compiler and
exact solver for finite algebraic optimization.  The paper should combine the
C980 contextual-state and Pareto theorems with the cross-domain evidence from
C983, while keeping exact recovery as the deepest motivating application
rather than the definition of the tool.

## Primary audience

The primary audience is constraint programming and exact combinatorial
optimization: global constraints, decision diagrams, decomposition, dynamic
programming, solver compilation, and mathematical preprocessing.  Secondary
audiences are computational discrete optimization and operations research,
weighted automata and algebraic dynamic programming, and coding/storage
optimization.

## Proposed theorem and algorithm spine

1. define contextual observation and the typed quotient compiled by ergodis;
2. prove exact finite-state composition for the admitted algebraic interfaces;
3. develop the finite ordered-monoid and fixed-dimensional Pareto theorem,
   including the universal multiplicity cap `1+k(R-1)`;
4. compile exact nondominated frontiers with one retained witness per frontier
   point;
5. distinguish fixed-dimensional additive resources from per-helper capacity
   and packing states;
6. use one common witness-preserving kernel for recovery and the two genuine
   noncoding exemplars admitted by C983; and
7. separate gains from mathematical quotienting, algorithm design, and
   low-level implementation through explicit ablations.

## Evidence gate

The paper is not admitted on the strength of recovery benchmarks alone.  C983
must establish that the same quotient-and-compose kernel gives material exact
state reduction on at least two noncoding models without hiding
problem-specific solvers behind a common interface.

The evaluation should compare:

- one exact ergodis Pareto compilation;
- repeated scalar ergodis solves over representative weight vectors;
- CP-SAT or MILP given both direct and equivalently preprocessed models;
- the strongest natural specialized control for each exemplar; and
- cold construction, solve, witness-replay, memory, and frontier-size costs.

Claims must distinguish mathematical state reduction from Rust performance
engineering.  A negative C983 outcome should narrow or stop this paper rather
than manufacture breadth.

## Scope limits

The initial theorem concerns a fixed number of bounded additive resources.
Per-helper capacities, growing resource dimension, cross-helper network
coding, continuous optimization, approximation, and unrestricted side
constraints require larger interfaces or downstream solvers and are not
silently covered by the Pareto theorem.

## Inputs

- `notes/2026-08-27-c980-higher-rank-contextual-minimality.md`
- `notes/2026-08-27-c980-structural-compression-hostile-proof-literature-audit.md`
- `notes/2026-08-27-c983-ergodis-cross-domain-potential.md`
- `ergodis/`
