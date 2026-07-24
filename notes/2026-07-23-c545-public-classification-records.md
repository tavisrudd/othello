# C545 public R5--R7 classification records

Date: 2026-07-23

## Result

The C1 and R1 release gates are closed.  The public supplement now exposes
canonical R5--R7 representatives, stabilizers, separating invariants,
Frobenius links, and completeness totals without relying on internal task
numbers in the manuscript.

Artifacts:

- `papers/beyond4_prs/supplement/build_classification_records.py`
- `papers/beyond4_prs/supplement/CLASSIFICATION-RECORDS.json`
- `papers/beyond4_prs/supplement/CLASSIFICATION-RECORDS.md`
- `papers/beyond4_prs/supplement/CLASSIFICATION-RECORDS.sha256`

The JSON is the authoritative machine record.  The Markdown table is a
human-readable projection.  Source-certificate hashes are embedded and also
covered by the checksum manifest.

## Boundaries

- R5 and R6 records are code-deep-hole classifications at their stated
  fields.
- R7 records at `q=7,8,9` are labelled split-free only.  The
  Seroussi--Roth radius premise promotes the listed classification only from
  `q>=11`.
- Completeness means the sum of the canonical `PGL2` orbit sizes equals the
  certified classified total.  It does not expand any certificate's field
  domain.
- The builder projects frozen certificates; it does not rerun a census.

## Replay

From the repository root:

```text
python3 papers/beyond4_prs/supplement/build_classification_records.py --check
```

From `papers/beyond4_prs/supplement/`:

```text
sha256sum -c CLASSIFICATION-RECORDS.sha256
```

Both pass.  Python bytecode compilation and the warning-gated manuscript
build also pass.  An exact manuscript scan finds no remaining internal
three-digit C-task reference.

