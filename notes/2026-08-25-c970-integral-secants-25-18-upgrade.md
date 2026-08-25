# C970 — C949 upgrade of the integral-secant paper

**Lane:** `relconic`

**Status:** authority validated; standalone export pending

## Objective

Integrate C949's arbitrary-arc line-code obstruction into the C945 paper and
make

```text
t_{2q/3+1}(2,q) >= q^2/3 + 5q/3 - o(q),  q=3^h,
```

the characteristic-three headline. Preserve the former `4/3` theorem as the
modular-repair lower bound that supplies the lower side of the excluded band.

## Release gates

- print a complete human proof of the linear-gap theorem, including the exact
  moment identities, secant-offset localization, Szőnyi--Weiner Theorem 4.3
  convention match, the shell-support lower bound, and signed positive-line
  capacity;
- formalize only inexpensive arithmetic fragments in the paper-local Lean
  package and state the remaining geometric/formal boundary exactly;
- add the C949 exact arithmetic replay to the paper-owned evidence bundle;
- refresh the bounded literature audit through 25 August 2026 without a
  global priority claim;
- update the abstract (at most 200 words, active voice), introduction,
  blocking-set corollary, conclusion, reviewer guide, claims, trust surfaces,
  summary, metadata, PDF, and standalone export;
- pass manuscript, evidence, source-correspondence, guarded Lean, axiom, and
  cold mathematical audits.

## Mathematical boundary

The final C949 compression proves that the centered residue word needs at
least three generator lines and that signed capacity forces displacement at
least `q/3-o(q)` above the former `4/3` center. It proves no matching upper
construction and no optimality claim for `5/3`.

The paper does not claim that `5/3` is optimal and does not import C949's
separate exact-endpoint case analysis. It records only the consequence needed
for the asymptotic theorem: a matching family would have an exact signed
three-line residue word for all sufficiently large fields.

## Integrated result and proof chain

The revised title is *Integral Secant Distributions and Line-Code Obstructions
for Complete \((k,n)\)-Arcs*. The characteristic-three proof now has the
following explicit dependency chain:

```text
old modular-repair bound at 4/3
  -> two-sided O(q) band around that center
  -> bounded maximal-secant offset by the two-class Cauchy inequality
  -> O(q)-weight centered ternary line-code word
  -> exact short-line representation (Szőnyi--Weiner, Theorem 4.3)
  -> shell support forces at least three generator lines
  -> positive-line capacity forces displacement at least q/3-o(q)
  -> coefficient 5/3.
```

The source states the exponent and weight threshold of the imported
small-codeword theorem and uses its exact number of distinct generator lines.
It does not treat that imported theorem, the projective-plane line code, the
geometric capacity argument, or the asymptotic localization as Lean-verified.

## Validation

- `make check`: pass; 21-page deterministic PDF; no TeX warnings.
- Paper-local exact replay: pass; 1,580 checks, including the centered shell,
  exact cancellation, and phase boundary.
- Paper-local formal source/correspondence gate: pass; 23 claims, with 13
  absent and 10 fragmentary; 20 public Lean terminals and five machinery
  terminals.
- Guarded Lean build and axiom audit: pass from run
  `run-20260825-203608-c772a991`; the new terminals use only the declared
  Mathlib axioms.
- Repository paper-facts gate: no error; one build-tree bibliography warning
  remains outside the paper's tracked source surface.
- Sealed cold read: GO after repairing the boundary case `epsilon=1/3` in the
  final quantifier split. The reader independently checked uniform Cauchy
  localization, both pointwise shell inequalities, the imported theorem's
  convention, line-support size, positive-line capacity, and rigidity.
- Abstract: 166 source words, active voice.

## Literature refresh

The bounded audit was refreshed through 25 August 2026 with exact-formula,
theorem-family, line-code, and recent-date searches. It found no located
predecessor for the `5/3` coefficient or this paired shell/line-code argument.
The manuscript makes no global priority claim; its literature ledger records
the search boundary and the individually checked sources.

## Mystery ledger (`ej` + `tt` closeout)

- **Settled:** why the earlier `25/18` obstruction was loose. The centered
  shell itself forces three line generators, and signed positive-line capacity
  moves the first possible phase boundary to `5/3`.
- **Settled:** what equality-scale information survives. Any hypothetical
  `5/3+o(1)` family has an exact signed three-line residue word.
- **Open, owned by C949:** whether a regular capped inverse selection realizes
  one of the remaining three-line cores with nonzero `o(q)` repair, or a
  further obstruction raises the coefficient. This is the exact evidence gap
  behind every optimality claim, so the paper makes none.
