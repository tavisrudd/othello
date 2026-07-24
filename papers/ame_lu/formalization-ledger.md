# Formalization ledger

The shared definitions are now fixed in
`RelativeConicArcs.AMELU.Definitions`, with import-only terminal
`RelativeConicArcs.Gates.AMELUDefinitions`.  No manuscript theorem is yet
adopted from Lean.

| Manuscript result | Formal status | Unformalized boundary | Action |
|---|---|---|---|
| `thm:dictionary` | arc-to-`[6,3,4]`, `[6,3,4]`-to-AME, projective-to-monomial-to-LC, and CSS support interface proved in `RelativeConicArcs.AMELU.Dictionary` | stabilizer action of `C × Cᵖ`, Lagrangian property, and minimum-support clause | close residual statement coverage before C570 adoption |
| `thm:lc-pencil` and `cor:lu-lc-pencil` | none adopted | projective invariant theory, exceptional fibres, and rigidity composition | C567 candidate package |
| `thm:lu-h3-grs` and `thm:q13-lu` | none adopted | stabilizer trace formula, geometric count, and exact contraction bridge | C568 candidate package |
| `thm:transport-divisor` | none adopted | cycle-cover algebra, rank bridge, and orbit geometry | C569 candidate package |
| `thm:lu-lc-rigidity` | proved in C560; not formalized | diagonal-tensor axis lemma, Weyl normalization, and MDS shortening bridge | C566 candidate package |

Any Lean action requires an allocated `ame-lu` task and the nested Lean guide.
A future ledger must state exact theorem names, imports, toolchain, axioms,
unsafe/native use, external computation, and the manuscript correspondence.
