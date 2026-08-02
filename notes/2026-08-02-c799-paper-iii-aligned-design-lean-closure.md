# C799 — Paper III aligned-design Lean closure

**Lane:** `clebsch`

**Date:** 2026-08-02

## Result

Paper III now has a paper-facing aligned-design API in
`RelativeConicArcs.AlignedTwoGraph`.  It defines ordered triangle bits, the
four-set parity law, aligned four-sets, global complementation, rooted graph
reconstruction, normalized anchor cuts, one-point and pair signatures, and
the three-outside-point data.  The formal package proves:

- complementation invariance and rooted XOR reconstruction;
- the Ramsey-monochromatic-triangle reduction to an aligned anchor;
- the exact three-balanced-cut collision in the four one-point tests;
- the complete two-cut classifier, including its sole distinct-balanced swap;
- symbolic elimination of that swap by the third outside point;
- injectivity of the complete normalized seven-point selected signature;
- consistency of complement bits across common seven-point restrictions;
- switching/global-negation reconstruction of Boolean signings;
- one-triangle orientation calibration;
- the principal-four identity `det = 3 - 2*w` for involutive edge signs;
- the selected-query polynomial `3*n^2 - 23*n + 45`; and
- the exact count `choose 6 3 = 20` for anchor tests.

The shared import-only gate now audits forty-seven declarations.  The API is
frozen for C815: that task may import `AlignedTwoGraph` but should not duplicate
its triangle, cut, signature, globalization, switching, or determinant
declarations.

## Trust boundary

The two-cut classifier uses native decision on exactly
`8^4 * 2^2 = 16,384` bounded Boolean cases.  Its resulting implementation
axiom is recorded verbatim in `verification/passages_axioms.txt`.  The
third-point elimination is symbolic and depends only on `propext`; it does not
repeat a larger finite search.

The classical theorem `R(3,3)=6`, extension of at most six specified vertices
to a seven-set in a finite set of cardinality at least seven, and the passage
from arbitrary labelled two-graphs to the normalized cut coordinates remain
explicit human combinatorial inputs.  Lean proves the reduction from a supplied
Ramsey triple, the normalized seven-point core, overlap consistency, and every
downstream algebraic transport.  The paper and all public trust surfaces state
this boundary; no complete manuscript row is mislabeled as wholly formal.

## Reproducibility

Authoritative working directory: `/home/tavis/src/othello`.

Primary single-file replay:

```sh
lean/scripts/guarded-lean RelativeConicArcs/AlignedTwoGraph.lean
```

Import-only aggregate replay:

```sh
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.Gates.ClebschPassages \
  --profile single --threads 1 --cores 20-23
```

Paper-local source and audit checks:

```sh
cd papers/clebsch-passages
python3 verification/verify_passages_lean.py \
  --lean-root /home/tavis/src/othello/lean --source-only
python3 verification/verify_release.py
```

The exact guarded gate output was parsed with the verifier's own
`parse_axioms` function and compared with both the forty-seven-declaration
manifest and the tracked axiom report.  The human signature tables in
Section 5 independently derive the finite classification and its third-point
contradiction.  No second executable classifier is included: the formal
checker exhausts the complete bounded domain, while the manuscript supplies
the independent conceptual replay.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `lean/RelativeConicArcs/AlignedTwoGraph.lean` | 18,205 | `85eb450500217a6949d57f6161a6354d9fc62047b7e4b0c4c1b5fdac81c27be0` |
| `lean/RelativeConicArcs/Gates/ClebschPassages.lean` | 5,254 | `1978f4e8e864c297c66ad947cae8d2e24584cb9a576f27bef68356e6e6a95608` |
| `papers/clebsch-passages/verification/passages_axioms.txt` | 7,105 | `a3c9529225248abf738d3c24711e6b504313230447be947b7c29c7da3893bd3b` |
| `papers/clebsch-passages/verification/passages_formal.json` | 12,538 | `ade247f86160e618a4922a9ac4f1c59ebab65ffb917a237dee355d0ec7aa28c9` |

## Validation

- `AlignedTwoGraph.lean`: guarded elaboration passed in 6.0 seconds.
- `RelativeConicArcs.Gates.ClebschPassages`: guarded exact-target build and
  trace-only aggregate passed; measured maximum RSS was 3,112,364 KiB.
- Forty-seven-declaration manifest/report equality and observed axiom equality:
  passed.
- Paper-local pinned-source replay: passed.
- Paper release aggregate: all checks passed, including the warning-free PDF.
- The unchanged golden-return source replay, guarded exact-target trace gate,
  and complete observed-versus-pinned axiom audit passed.

## Closeout: extra juice and Tao check

The first formal draft made the entire 4,096-state seven-point signature map
injective by an all-pairs native check.  That was mathematically opaque and too
slow for a permanent gate.  The closeout replaced it with the paper's actual
logic: native decision handles only the 16,384 two-cut cases, and a symbolic
eight-branch theorem proves that three pair outcomes cannot contain a swap.
This both exposes the reason for faithfulness and cuts the replay to seconds.

The same pass added three task-owned consequences at negligible cost: the
Ramsey-to-anchor reduction, the exact determinant expansion, and calibrated
orientation.  These close the conference transport line and give C815 a
stable API rather than a collection of paper-specific terminal lemmas.

## Mystery ledger

- **Settled:** why the third outside point is essential.  Pair signatures lose
  only the order of two distinct balanced cuts; three pair outcomes make any
  such swap contradict one of the other two pairs.
- **Settled:** why the replay should not enumerate all seven-point pairs.  The
  pair classifier plus symbolic compatibility is the structural compression.
- **No genuine mathematical mystery remains in C799.**  The classical Ramsey,
  finite-cardinality, and normalization steps are explicit formal-coverage
  boundaries, not unexplained phenomena.  C800 owns the later shared-manifest
  reconciliation after C815 and C823; C815 owns the next API consumer.

## Vibe check

Strong closure: the delicate finite ambiguity is now visible in the theorem
API, the expensive proof shape was removed, and the trust surface is more
precise than the manuscript's previous human-only label.
