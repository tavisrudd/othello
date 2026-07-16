# C222 — compact Lean closure of the `A3/H3` synthesis

**Lane:** `clebsch`

**Status:** DESIRED; compact-proof gate.

## Objective

Kernel-check the mathematical layer introduced by C211 without replacing its short conceptual
proofs by large generated certificate trees. Reuse the existing Clebsch decoder and finite-geometry
formalization wherever possible.

The desired boundary is:

1. formalize the quadratic parameter relation used for the projectivized `H3` coordinates and its
   specialization to `F_11`;
2. verify the 15 mirrors, six fivefold points, and the `10` triple plus `15` double intersection
   ledger, together with the displayed projectivity to the Clebsch columns and dual secants;
3. verify the `A3` frame arrangement and its intersection ledger over `F_5`;
4. derive the arrangement complement counts and connect the resulting strata to the existing
   `Q11DecodingSynthesis` statements used by the manuscript; and
5. run focused axiom checks and update the manuscript's verification table only after the relevant
   declarations are kernel-backed.

## Compactness gate

Proceed only if the proof can be expressed through reusable definitions, small finite extensional
checks, matrix/projective identities, and short counting arguments. Do **not** generate or commit a
large case-split certificate tree merely to eliminate the Python checker.

If a subclaim requires such a tree, stop that subclaim, record the exact obstruction and estimated
certificate size, and leave the manuscript's current computer-assisted label intact. A compact
formalization of a strict subset may land only when the verification table names that subset
precisely.

## Out of scope

- the unrelated exhaustive `q=11`/`q=13` small-arc exclusions;
- a general Coxeter-arrangement library or the C212 reconstruction program;
- replacement of already honest Python-backed claims when no compact kernel proof is available;
- the two existing Dye consequences already isolated as axioms.

## Success criterion

C222 is complete when every new C211 claim named in the objective is either supported by focused,
axiom-audited Lean declarations or explicitly retained as computer-assisted with a documented
compactness obstruction. No large generated certificate tree is an acceptable deliverable.
