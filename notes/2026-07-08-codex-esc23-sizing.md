# C21 q=23 esc sizing report

Date: 2026-07-08

## Result

The q=23 campaign should not be launched blindly.

Class 0 did **not** complete under the requested sizing cap.  It hit the private-memo cap:

```text
CLS q=23 cls=0 S3=[(0, 0), (1, 1), (2, 3)] status=ABORTED peak-memo=200000001 cap=200000000
q= 23  PARTIAL  size3-classes=40  solved=0  aborted=1  total(q^2-9q+21)=343  min-escape=0  max-escape=0  even-escape=0/0  peak-private-memo-max=200000001  [2193.1s]
```

The canonical size-3 class count is:

```text
q=23 size-3 classes = 40
```

## Commands

Build:

```text
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o /tmp/gridcap-c21
```

Class-count smoke probe:

```text
/tmp/gridcap-c21 esc 23 --cap 1 0
```

Output:

```text
[esc q=23] 40 size-3 classes; cap=1; filter=[0]
CLS q=23 cls=0 S3=[(0, 0), (1, 1), (2, 3)] status=ABORTED peak-memo=2 cap=1
```

Sizing probe:

```text
timeout 3600 /tmp/gridcap-c21 esc 23 --cap 200000000 0
```

Outcome:

```text
status=ABORTED
peak-memo=200000001
cap=200000000
wall=2193.1s
```

## Extrapolation

This is a lower bound, because class 0 did not finish:

```text
per-class wall lower bound: > 2193.1s = > 36.6 min
full 40-class wall lower bound: > 24.4 core-hours
per-class private memo lower bound: > 200M entries
```

The private memo is a standard `HashMap<u128, bool, IdHash>`, not the compact global arena.
The run reached 200M entries without being killed, so the current box can at least reach that
cap.  But class 0 needs more than 200M entries, so this probe does **not** prove the full q=23
per-class campaign fits memory without a higher cap or a compact private memo.

## Interpretation

q=23 remains scientifically useful: it could add a mixed-value training column for the moduli
law hunt, and any class with escape 0 would falsify the min-escape conjecture.

Operationally, the current `esc` private-`HashMap` route is too large for a casual campaign.
Before a user-launched q=23 run, use one of:

- a higher explicit memory budget plus per-class wall accounting;
- a compact private memo representation;
- a smaller class-by-class pilot with progressive caps to estimate the final class-0 peak.

## Adversarial review

Sizing reviewer: because class 0 aborted, all full-campaign estimates are lower bounds.  I did
not extrapolate a completion time from a completed class.

Memory reviewer: `peak-memo=200000001` is entry count, not bytes.  The current implementation
uses `HashMap`, so byte footprint is substantially larger than `entries * 17 bytes`.

Scope reviewer: only class 0 was run, exactly as requested.  No q=23 campaign was launched.
