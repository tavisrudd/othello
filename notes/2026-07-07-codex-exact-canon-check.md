# Codex C8 exact-canon cross-validation report (2026-07-07)

## Result

No fingerprint-canon collision was found in the requested checks.

- q=11 full exact enumeration: `739` classes; Rust-style fingerprint unique count: `739`.
- q=13 full exact enumeration: `9299` classes; Rust-style fingerprint unique count: `9299`.
- Per-size exact counts and fingerprint counts match exactly for both q=11 and q=13.
- q=17 feat-log rekey:
  - size-3 classes: `21` exact, `21` fingerprint, no collisions;
  - logged size-4 children: `3297` records, `735` exact child classes, `735` fingerprint child
    classes, no collisions;
  - min-escape classes `[2, 17, 19]`: all `471` child records rekeyed, no collisions;
  - escape histogram reproduced: `5:3 10:12 11:6`.

This discharges the C8 audit check at the requested scale. It does not turn the production key
into an exact canonical form; it verifies that the 128-bit additive fingerprint does not merge
distinct exact classes in these q=11/q=13 full spaces or in the q=17 witness slice.

## Method

I used a private Python checker:

```text
/tmp/codex_exact_canon_check.py
```

The checker is prime-field only, which covers q=11, q=13, and q=17. It implements the same anchor
image set as `Board::canon()`:

```text
for every ordered occupied pair (u,v) and swap bit:
  translate u to (0,0)
  optionally swap coordinates
  scale v to (1,1)
```

For the exact key, it takes the lexicographically minimal sorted transformed cell list. For the
fingerprint key, it ports the Rust splitmix cell hashes and takes the minimal 128-bit additive
set hash over the same anchor images.

Commands:

```bash
python3 /tmp/codex_exact_canon_check.py /tmp/codex-feat17.out \
  > /tmp/codex-exact-canon-check.out
/tmp/gridcap-codex-c5 defect 11 13
```

The second command cross-checks the full exact totals against the existing Rust solver totals.
It printed:

```text
q= 11  root=P (2nd wins)  classes=739  min-dev-size=4  odd-maximal-caps=41 (min size 5)  even-but-N=214 odd-but-P=83
q= 13  root=P (2nd wins)  classes=9299  min-dev-size=4  odd-maximal-caps=770 (min size 7)  even-but-N=2887 odd-but-P=791
```

## Exact Counts

```text
Q11_COUNTS exact={0: 1, 1: 1, 2: 1, 3: 8, 4: 80, 5: 272, 6: 311, 7: 56, 8: 7, 9: 1, 10: 1}
Q11_HASH_COUNTS via_exact_reps={0: 1, 1: 1, 2: 1, 3: 8, 4: 80, 5: 272, 6: 311, 7: 56, 8: 7, 9: 1, 10: 1}
Q11_TOTAL exact=739 hash_unique=739 collisions=0

Q13_COUNTS exact={0: 1, 1: 1, 2: 1, 3: 12, 4: 192, 5: 1384, 6: 4075, 7: 3089, 8: 509, 9: 24, 10: 9, 11: 1, 12: 1}
Q13_HASH_COUNTS via_exact_reps={0: 1, 1: 1, 2: 1, 3: 12, 4: 192, 5: 1384, 6: 4075, 7: 3089, 8: 509, 9: 24, 10: 9, 11: 1, 12: 1}
Q13_TOTAL exact=9299 hash_unique=9299 collisions=0
```

## q=17 Witness Slice

Input was the regenerated q=17 feat log from C5:

```text
/tmp/codex-feat17.out
```

Rekey output:

```text
Q17_REKEY {
  's3_classes': 21,
  's3_exact': 21,
  's3_hash': 21,
  's3_hash_collisions': 0,
  'x_records': 3297,
  'child_exact': 735,
  'child_hash': 735,
  'child_hash_collisions': 0,
  'exact_value_mixed': 0,
  'escape_hist': Counter({10: 12, 11: 6, 5: 3}),
  'min_escape': 5,
  'min_classes': [2, 17, 19],
  'min_child_records': 471,
  'min_child_hash_collisions': 0
}
```

`exact_value_mixed=0` is an extra sanity check: every exact size-4 child class seen in the q=17
feat log had one logged game value.

