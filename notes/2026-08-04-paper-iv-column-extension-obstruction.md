# Paper IV column-extension obstruction

## Result

The fixed Paper IV code `[91,15,28]` cannot be extended by 49 columns to a
binary `[140,15,60]` code.  The obstruction is stronger than integral
infeasibility: the appended-column linear program has no nonnegative real
solution.

Consequently the conditional second gate—append 69 columns and test
`[160,15,69]`—was not run.  That gate was requested only if the first extension
was feasible.

## Exact formulation

For every nonzero column type `a` in `F_2^15`, let `x_a >= 0` be its
multiplicity.  For a message `u`, appending the multiset raises its codeword
weight by

```text
sum_{a dot u = 1} x_a.
```

The full extension problem has the length equation `sum_a x_a = 49` and one
distance inequality for each of the 32,767 nonzero messages.  The certificate
uses only 98 necessary distance consequences:

- the 78 base words of weight 28, each requiring an increment of at least 32;
- 20 specified base words of weight 36, each requiring an increment of at
  least 24.

It also uses the aggregate minimum-shell inequality.  A column meets at most
52 of the 78 minimum messages.  Summing their required increments gives the
valid cut

```text
sum_a (52 - coverage(a)) x_a <= 52.
```

## Farkas certificate

The JSON records 100 integer multipliers in this row order: the length
equality, aggregate cut, 78 minimum-word inequalities, and 20 additional-word
inequalities.  The equality multiplier is unrestricted, the aggregate-cut
multiplier is nonpositive, and all distance-row multipliers are nonnegative.

Their exact signed sum has right-hand side `1321`.  On every one of the 32,767
possible nonzero columns, its coefficient is nonpositive (maximum `0`, minimum
`-4919`).  Thus any `x_a >= 0` would make the combined left-hand side at most
zero while the same inequalities require it to be at least 1321, a
contradiction.

HiGHS 1.12.0 was used only to discover the infeasible subsystem and an
approximate dual ray.  The stored integer certificate was rounded with slack
and is replayed independently using exact integer arithmetic; HiGHS is not in
the trusted boundary.

## Replay

From the repository root:

```bash
python3 notes/2026-08-04-paper-iv-column-extension-obstruction.py --check
sha256sum -c notes/2026-08-04-paper-iv-column-extension-obstruction.sha256
```

The checker reconstructs the committed `[91,15,28]` generator, enumerates all
`2^15` messages, checks the minimum shell and the 20 extra rows, evaluates the
certificate on every nonzero appended column type, and compares the complete
derived record to the tracked JSON.

