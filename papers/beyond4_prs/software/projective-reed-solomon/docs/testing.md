# Testing layers

The fast locked gate is:

```text
cargo fmt --all -- --check
cargo clippy --locked --all-targets -- -D warnings
cargo test --locked
```

It contains three complementary layers:

- 31 focused library tests for exact examples, registry boundaries,
  certificate corruption, canonicalization oracles, and decoder behavior;
- seven integration tests that exercise every compiled Clap subcommand. They
  cover a classify-to-verify positive-certificate round trip, corrupted
  certificate rejection, standard-input and file-input paths, distance/decode
  agreement, locator-certificate replay, candidate-budget exhaustion, and
  rejection beyond the R5--R10 classification boundary;
- five property tests, each with 256 cases and a committed fixed RNG seed,
  covering prime- and extension-field laws, projective scale invariance, and
  locator/support and syndrome/magnitude round trips.

The property tests look for algebraic implementation defects; they do not
replace exhaustive orbit checks or prove a covering-radius statement.

Four ignored release regressions cover the GF(8)/R7 distance audit, complete
GF(8) and GF(9) R5 chart enumerations, and the GF(32)/R17
characteristic-power boundary:

```text
cargo test --locked --release -- --ignored \
  --skip structural_canonicalization_extends_to_gf16_r11
```

The full GF(16)/R11 semilinear census is intentionally a separate command:

```text
cargo test --locked --release \
  tests::structural_canonicalization_extends_to_gf16_r11 \
  -- --ignored --exact
```
