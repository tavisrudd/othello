# Private finite-query known-answer control

This control derives from the frozen 22-candidate, 66-query incidence in the
C1011 report. It remains outside the public Ergodis package because its
projective matching construction and task identity are private research
inputs.

The public kernel receives only generic hypothesis masks. It independently:

- verifies the frozen 14-query nonadaptive witness;
- constructs another 14-query certificate using the edge-query connected-
  triple factor theorem; and
- constructs and verifies an adaptive tree of maximum depth 11.

Replay from this directory with Rust 1.87 or later:

```sh
python3 generate.py
choom -n 1000 -- cargo +1.87.0 run --release --locked
```
