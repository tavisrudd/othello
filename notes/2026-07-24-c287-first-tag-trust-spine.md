# C287 first-tag trust-spine integration

**Lane**: `build-sys`
**Status**: DECLARATIONS LANDED; four Lean fact extractions missing

## Result

The reviewer-scale 26-file first-tag boundary now uses the existing C326 trust spine rather than a
second target-manifest format or checker.

`lean/trust/areas/finitegeom_first_tag.toml` owns exactly the 26 inventoried modules and declares
four extraction units:

| Extraction unit | Terminals |
|---|---:|
| `CapGame.Affine` | 1 |
| `ProjectiveCap.Binary` | 1 |
| `ProjectiveCap.EllipticMirror` | 2 |
| `ProjectiveCap.PlaneOutcome` | 3 |

The seven terminals are the exact declarations in the C287 theorem ledger. Each declares the
reviewer expectation `[Classical.choice, Quot.sound, propext]`; this is not observed evidence.
`lean/trust/FIRST_TAG.md` gives the public mathematical scope and states that extraction is missing.
The generated `lean/trust/PORTFOLIO.md` now renders both the four gates and seven declared axiom
sets. The global canonical graph manifest is unchanged: regenerating it from the current foreign
tree would mix unrelated topology and classification changes into this commit.

Modules elsewhere in the `CapGame`, `ProjectiveCap`, and `Sumfree` libraries remain classified as
unaudited. Adding this area does not imply portfolio-wide coverage.

## Validation

- A generator pass produced the new area tables. Its unrelated relconic table and global graph
  churn were discarded; only the C287 generated regions are retained.
- The area-filtered JSON audit reports exactly four findings, all `facts-missing`; it reports no
  structural, coverage, ownership, terminal, or axiom-declaration error for this area.
- `lean-trust-extract.py plan --area finitegeom_first_tag` resolves all four units and seven
  terminals against Lean 4.32.0-rc1 and Mathlib `571b8a8e54219b4d393f75f4b8653fac08197fcc`.
  It reports `quiet window: no — 7 foreign path(s)`, so no extraction was attempted.
- All 45 hermetic trust-spine tests and all 36 hermetic extraction-driver tests pass.

No Lean, Lake, generator, build, source export, or process intervention ran.

## Command-shaping correction

An initial unfiltered `lean-trust-spine.py check` emitted 3,556 lines / about 127,260 tokens of
portfolio-wide pre-existing findings before truncation. That invocation shape was discarded. The
replacement area-filtered JSON audit emits only the four relevant codes and counts; subsequent
validation used the bounded view. No state change occurred from the failed read-only check.

## Extra value

The integration supplies three later gates at no additional format cost:

1. The extraction driver already knows the exact units and terminals, so a quiet window requires no
   new wrapper or target-ledger implementation.
2. The generated portfolio table makes a declaration/observation mismatch mechanically visible to
   reviewers instead of relying on prose synchronization.
3. The 26-module ownership list prevents an unrelated module in the same three libraries from
   entering the first-tag trust claim merely because Lake can build it.

The remaining first-tag work is source-owner cleanup of seventeen blocked modules, including the
two approved wrapper-module deletions and consumer migrations, followed by inventory regeneration
and the guarded four-unit extraction in a quiet window. That quiet,
coherent tree is also the gate for regenerating the global graph manifest and all shared generated
portfolio regions together.
