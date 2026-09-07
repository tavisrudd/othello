# Tschinkel--Zhang v1/v2 source comparison

**Lane:** `cubic-threefolds`
**Date:** 2026-09-07
**Owner:** C1116 source audit input

Compared the complete `dp4.tex` diff and both `dp4.bbl` files downloaded from
https://arxiv.org/src/2608.20029v1 and
https://arxiv.org/src/2608.20029v2 . Official revision dates are August 20
and August 28, 2026. The PDF lengths are 24 and 25 pages.

## Findings

- The tangent-projection theorem adds explicit reducedness, irreducibility,
  nondegeneracy and projectivity, changes the principal citation to
  `projection`, Theorem 2.7, and revises the field-extension explanation.
  The Cox application verifies the added hypotheses.
- New Example 5.2 concerns a stably rational intersection of two quadrics
  nonrational over Q and R. The type-I3 cubic becomes Proposition 5.3.
- New Section 7 gives arithmetic consequences involving R-equivalence and
  zero-cycles, credited to Colliot-Thelene's encouragement.
- The type-I1 proof corrects rationality to stable rationality. There are
  further editorial changes, including deletion of a sentence attributing
  the explicit equivariant lift to normalization at a fixed point.
- The uniform bound 11 and the open one-extra-variable question remain.
  Neither bibliography cites Rudd. The diff introduces no rank-three quotient
  construction or exact-level-two theorem.

The author supplied the email and Zhijia Zhang's reply dated August 26,
7:02 AM. The email linked both repositories, stated exact level two and the
uniform surface upper bound, and requested correctness/positioning feedback.
Zhang confirmed a brief read and called the subtorus-quotient idea plausible
provided its details are justified; he withheld judgment on the QDM argument.
This establishes his awareness of the proposal before v2 on August 28, not
proof acceptance. The exact repository snapshot read was not identified.
Neither message specifically discusses the tangent-projection correction.
The correction overlaps an issue in our manuscript, but neither influence
nor deliberate omission is established. No message was sent to either author
by this session.

## Evidence and replay

Persistent downloaded source archives and extracted text are under
`/tmp/persistent/tavis/lit-search/comparisons/tz-2608.20029/`.
`source.diff` is the complete unified `dp4.tex` comparison. These are literature
cache bytes, not a new mathematical certificate. No copied source is committed.

| File | Bytes | SHA-256 |
|---|---:|---|
| v1.tar | 20670 | 66de1551dd657448a8294d5e0bdfa69ea3a61cc102105752a0c7c70645da397e |
| v2.tar | 22152 | 73d2b294d6462982c64def61cfc4cbf44275c6585adb265190941fc124b860dd |
| v1 dp4.tex | 59276 | f7d644fefeca4643d7dbb6e366a68b3119e3d67ee3b771f9ff1c4d7c8499e7ef |
| v2 dp4.tex | 62302 | cf71ff24da87db7b5d1ca80097f8a3da4b5ae9cbf8ff4d1e4b787b1941656095 |
| v1 dp4.bbl | 5814 | 10fbe73b6d7cfe4562772f480733632f6748a91bb18c2287e26619a2081753e4 |
| v2 dp4.bbl | 7091 | 3f2a7b9c687bdc4a666b06570792b9ba42d7a4f51302b95af52d3689081f5ca4 |

Replay from any directory with Python 3, after fetching the versioned archives
to the cache paths above:

```python
import difflib, pathlib, tarfile
p = pathlib.Path('/tmp/persistent/tavis/lit-search/comparisons/tz-2608.20029')
for name in ('dp4.tex', 'dp4.bbl'):
    texts = []
    for version in ('v1', 'v2'):
        with tarfile.open(p / (version + '.tar')) as archive:
            texts.append(archive.extractfile(name).read().decode().splitlines())
    (p / (name + '.diff')).write_text('\n'.join(
        difflib.unified_diff(*texts, fromfile='v1/' + name,
                            tofile='v2/' + name)) + '\n')
```

The official HTML independently confirms the new example/section, theorem
wording, unchanged bound and bibliography:
https://arxiv.org/html/2608.20029v2 . C1116 still owns checking the newly cited
projection theorem against its primary source; this comparison alone does not
validate that theorem's application. No priority verdict was attempted.
