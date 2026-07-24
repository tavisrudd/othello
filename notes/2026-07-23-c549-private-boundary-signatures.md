# C549 — private-boundary truncation and residual signature quotient

**Lane:** `cap`. **Status:** active. **Predecessors:** C528/C547.

## Objective

Close the exact local boundary law exposed by C547 and test whether it can
explain the bounded Grundy values in the frozen q17/q19 residual cores.

For a complete triple gadget on `A=B∪U`, assume every other minimal forbidden
constraint meets `A` only through the labelled boundary `B`; the vertices in
`U` are private. Prove, or sharply falsify, that the rooted game depends on
`U` only through

```text
min(2, |U|)
+ the selected occupancy of A
+ the ambient state and constraints on B.
```

Then compute the induced signature quotient on the existing C528 q17/q19
corpus. The measurement must distinguish:

- a genuinely bounded signature family;
- growth caused only by redundant labels;
- growth in game-visible boundary behaviour.

## Acceptance

1. A Lean-checked rooted-game equivalence or an explicit minimal
   counterexample with a corrected signature.
2. An exact q17/q19 quotient census with tracked source, deterministic replay,
   compact certificate, hashes, and an independent check or an explicit
   reason none is available.
3. A theorem dependency/consumer map showing whether the result combines with
   `FiniteBuildGame.grundy_le_card_of_follower_signature`.
4. An `ej+tt` mystery closeout. No q23 run and no unsupported uniform SG
   claim.
