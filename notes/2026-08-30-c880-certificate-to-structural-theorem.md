# C880: from a checked certificate toward a structural theorem

**Date:** 2026-08-30
**Scope:** research tooling and the finite lower bound \(g(8)=17\); no Paper III edit

## Verdict

The certificate can already be reduced to a much smaller *semantic problem*,
but it has not yet been reduced to a short human proof.

The useful intermediate statement is this.  Let \(H\) be a 16-edge
3-uniform hypergraph on eight points.  For every point cut, every \(2+6\)
cut, every \(3+5\) cut, and every \(4+4\) cut, form the crossing-pair graph
from the selected triples.  Separation says that all these graphs are
non-bipartite.  The exact SAT result proves that this is impossible.  Semantic
ablation sharpens the target:

> Subject to the point-cut context clauses, each pair among the \(2+6\),
> \(3+5\), and \(4+4\) strata is satisfiable at size 16, but all three strata
> together are inconsistent.

Thus the likely structural proof is a **three-stratum incompatibility theorem**.
No single remaining cut stratum, and no pair of them, proves the result in the
present structural vocabulary.

## What the checked proof core says

`drat-trim -c` reduced the 322,844-clause exact-size-16 CNF to 82,368 input
clauses.  Lifting those clauses through compiler provenance gives:

| semantic family | total clauses | core clauses | used groups / groups |
|---|---:|---:|---:|
| anchor | 1 | 1 | 1 / 1 |
| upper cardinality | 1,799 | 1,033 | 1 / 1 |
| lower cardinality | 4,415 | 167 | 1 / 1 |
| context masks | 27,139 | 10,159 | 10,159 / 27,139 |
| cut encodings | 64,131 | 34,378 | 94 / 127 |
| lex symmetry | 225,359 | 36,630 | 627 / 719 |

The 94 retained cut groups split as 6 point cuts, 7 cuts of type \(2+6\), 50
of type \(3+5\), and 31 of type \(4+4\).  This core is a valid dependency
projection, not a structural proof: it is solver-order-dependent, asymmetric,
and still dominated by encoding and symmetry machinery.

The 27,139 redundant context masks have a useful invariant census:

| cut type | mask weight | number |
|---|---:|---:|
| point | 9 | 280 |
| point | 11 | 168 |
| point | 15 | 56 |
| \(2+6\) | 12 | 280 |
| \(2+6\) | 14 | 6,300 |
| \(2+6\) | 16 | 18,480 |
| \(4+4\) | 16 | 1,575 |

In particular, all 512 coloring contexts of every point link are already
present as direct clauses.  The point-cut parity gadgets are therefore
logically redundant; they remain useful only as propagation extensions.

## Ablation and the first candidate shapes

The semantic slicer retained exact cardinality, the anchor, all masks, and lex
leaders, then selected whole cut strata.  Every proper two-stratum slice was
SAT:

| retained non-singleton strata | clauses | omitted failure in one returned model |
|---|---:|---|
| \(2+6,3+5\) | 300,797 | exactly one \(4+4\) cut |
| \(2+6,4+4\) | 290,780 | exactly two \(3+5\) cuts |
| \(3+5,4+4\) | 308,840 | exactly three \(2+6\) cuts |

The last model is especially structured.  Up to relabelling it consists of all
triples containing at least two points of a fixed triple.  Its point degrees
are \(11,11,11,3,3,3,3,3\), its pair codegrees have histogram
\(0^{10}2^{15}6^3\), and its only failed cuts are the three \(2+6\) cuts
defined by pairs in the distinguished triple.  The other two models have less
rigid degree sequences and should be treated as samples, not classifications.

This yields a concrete next theorem-search programme:

1. enumerate the isomorphism classes of size-16 models for each two-stratum
   slice, blocking the full \(S_8\) orbit after every model;
2. express each class by point-degree, pair-codegree, and failed-cut profiles;
3. find a short set of invariant lemmas that forces this classification;
4. prove that each class violates the omitted stratum.

If the orbit lists stay small, this is a structural finite proof.  If they do
not, the profiles still identify the missing invariant for a stronger lemma.

## General certificate-to-theorem tooling

Three reusable private tools now implement the first layers:

- `c880_alignment_provenance.py` reconstructs clause and variable provenance
  for the frozen compiler and optionally maps every mask back to its cut and
  coloring context.
- `semantic_core.py` maps a checked DIMACS input core back to semantic groups,
  with interval-compressed clause and mask indices.
- `semantic_slice.py` selects whole semantic families without recompiling the
  model; `c880_alignment_profile.py` maps SAT near-misses back to invariant
  combinatorial data.

The general pipeline should be:

\[
\text{compiler provenance}
\to \text{checked proof core}
\to \text{semantic group core}
\to \text{group ablation/MUS}
\to \text{near-miss profiles}
\to \text{candidate invariant lemmas}
\to \text{independently checked lemma DAG}.
\]

The next reusable additions should be an orbit-aware model enumerator, a
group-level deletion/MUS driver, and a candidate-lemma checker.  The latter is
essential: arbitrary DRAT/RAT learned clauses are satisfiability-preserving but
need not be logical consequences in a form safe to publish as lemmas.  Every
candidate theorem should instead be checked as an implication against the
original semantic model, preferably with a small RUP/LRAT or VeriPB proof.

The eventual output should be a small proof DAG whose nodes are statements in
the source problem's vocabulary, with each edge carrying a machine-checkable
implication certificate.  Human proofs or Lean formalizations can then replace
nodes one at a time without trusting the theorem miner.  This architecture is
not SAT-specific: provenance groups can denote constraints, DP states,
automaton transitions, orbit representatives, or tropical inequalities.

## Reproduction

From the repository root:

```bash
PYTHONPATH=ergodis-private/python python -m unittest -v test_semantic_core

PYTHONPATH=ergodis-private/python python ergodis-private/python/semantic_core.py \
  --cnf k16.cnf --core k16.core.cnf --provenance k16.provenance.json \
  --out k16.semantic-core.json

PYTHONPATH=ergodis-private/python python ergodis-private/python/semantic_slice.py \
  --cnf k16.cnf --provenance k16.provenance.json \
  --select kind=anchor --select kind=cardinality_upper \
  --select kind=cardinality_lower --select kind=context_mask \
  --select kind=lex_symmetry --select kind=cut,side_size=2 \
  --select kind=cut,side_size=3 --out cut23.cnf

PYTHONPATH=ergodis-private/python python \
  ergodis-private/python/c880_alignment_profile.py --model cut23.model
```

## Trusted boundary

The semantic core trusts the already checked DRAT proof, byte-identical CNF
regeneration, and exact clause matching.  Provenance is checked against final
variable and clause counts and the CNF hash.  Ablation conclusions use SAT
models decoded only on the 56 semantic variables; the profiler independently
reconstructs all 127 cut graphs.  The three-stratum conclusion is relative to
the current basis (all masks, cardinality, anchor, and lex leaders), and does
not claim that no different higher-level lemma can replace a stratum.

## Mystery ledger

- **Settled:** raw proof-core minimization alone does not expose a human proof.
- **Settled:** the finite obstruction genuinely couples the \(2+6\), \(3+5\),
  and \(4+4\) cut strata under the current basis.
- **Settled:** point-cut parity gadgets add propagation, not logical content,
  once all low-weight point contexts are present.
- **Found:** a canonical-looking pair-star near-miss explains one entire
  omitted-stratum failure pattern.
- **Open:** whether the near-miss orbit classifications are small enough for a
  concise case theorem.
- **Open:** the invariant counting or parity lemma that proves the
  three-stratum incompatibility without enumeration.

## EJ / TT closeout

**EJ.** “Structural reduction” is not conflated with “structural proof.”  The
former is now concrete and reproducible; the latter remains the next theorem.
No asymmetric solver core or sampled near-miss is promoted to a classification.

**TT.** Core clauses are matched exactly, including duplicate clauses;
provenance is hash-bound to the certified CNF; semantic slices retain complete
groups; SAT assignments are replayed in original cut-graph semantics.  Unit
tests cover DIMACS parsing, duplicate mapping, compressed ranges, selectors,
and a known invariant near-miss profile.
