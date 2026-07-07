# C3 esc-mode validation gate report

Date: 2026-07-07

Scope: discharge the mandated `esc` validation gate for `q=17` and `q=19` against the
reference `escape` logs. No `q=23` campaign was started.

## Artifacts

Historical summary-marker logs:

- `notes/2026-07-06-escape-q17.log`
- `notes/2026-07-06-escape-q19.log`

Full private-memo rerun logs persisted from `/tmp`:

- `notes/2026-07-07-escape-q17-full.log`
- `notes/2026-07-07-escape-q19-full.log`

The historical logs contain only the two aggregate summary lines plus `Q17_DONE`/`Q19_DONE`.
The full logs contain every `CLS` row plus the same aggregate summary and the peak-private-memo
line. A literal diff against the historical logs is therefore intentionally nonempty; the
validation diff filters the per-class rows and peak line, then compares the aggregate summary.

## Build

Run from `notes/`:

```bash
rustc -O -C target-cpu=native 2026-07-06-grid-cap-solver.rs -o /tmp/gridcap
```

The build completed successfully.

## q=17

Command:

```bash
( ulimit -Sv 1000000
  /tmp/gridcap esc 17 > /tmp/esc17.out 2>/tmp/esc17.err )
```

Summary output:

```text
q= 17  root=P  size3-classes=21  total(q^2-9q+21)=157  min-escape=5  max-escape=11  bad-odd(even-escape) classes=12/21  parity-proof=BREAKS
      escape-histogram (escape:classes) = 5:3 10:12 11:6
      peak-private-memo max over classes = 1974487  [622.3s]
```

Reference check:

```bash
diff <(grep -v '^CLS \|peak-private' /tmp/esc17.out) <(head -2 2026-07-06-escape-q17.log)
echo diff17_exit=$?
```

Output:

```text
diff17_exit=0
```

Class-row check:

- Full log class rows: 21.
- Non-OK class rows: 0.

Result: PASS. All 21 size-3 classes completed with `status=OK`.

## q=19

Initial low-memory attempts established that the q=19 gate needs a larger virtual-memory
cap than q=17:

```text
ulimit -Sv 1000000: memory allocation of 1107296272 bytes failed
ulimit -Sv 2000000: memory allocation of 2214592528 bytes failed
```

Successful command:

```bash
( ulimit -Sv 4000000
  /tmp/gridcap esc 19 > /tmp/esc19.out 2>/tmp/esc19.err )
```

Summary output:

```text
q= 19  root=P  size3-classes=27  total(q^2-9q+21)=211  min-escape=211  max-escape=211  bad-odd(even-escape) classes=0/27  parity-proof=HOLDS (all bad even)
      escape-histogram (escape:classes) = 211:27
      peak-private-memo max over classes = 32256552  [12852.4s]
```

Reference check:

```bash
diff <(grep -v '^CLS \|peak-private' /tmp/esc19.out) <(head -2 2026-07-06-escape-q19.log)
echo diff19_exit=$?
```

Output:

```text
diff19_exit=0
```

Class-row check:

- Full log class rows: 27.
- Non-OK class rows: 0.

Result: PASS. All 27 size-3 classes completed with `status=OK`.

## Notes

- q=19 peak private memo was `32,256,552`, so the class-private path works for q=19 but
  does not fit under the original 1 GB/2 GB caps.
- The `esc` summary matches the reference `escape` summary and histogram for both q=17
  and q=19 after removing per-class `CLS` lines and the extra peak-memo line.
- The full q=17/q=19 logs are now persisted in `notes/` so the gate is auditable after `/tmp`
  cleanup.
- No q=23 or larger run was started.

## Operational consequence

C3 q=17/q=19 validation passed at the aggregate and per-class status level.

- q=23 is no longer blocked by this validation gate; it remains a heavy-compute launch decision
  and should wait for the box policy/user timing.
- GF(49) hygiene can now edit `notes/2026-07-06-grid-cap-solver.rs`; the old q=19 binary run is
  finished and its full output has been persisted.
