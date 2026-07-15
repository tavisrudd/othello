# Fable Clebsch research scripts — 2026-07-15

**Lane**: `clebsch`

These are the six scripts supplied verbatim in `/tmp/files.zip` after a PDF-only independent
review. They are preserved as source evidence, not submission checkers. Research-grade gaps are
documented in C184--C187 and include printed-but-unasserted conclusions, sampled degree-six work,
and the absence of a nonsingularity test in the seven-arc hit branch.

| file | SHA-256 | disposition |
|---|---|---|
| `q1_curves.py` | `70aa5695756edbff9bbc9a337e5173b4e4ffadec60bb0628dceb8cf050b34bac` | superseded by `papers/clebsch-hexagon-code/check_low_degree_loci.py` |
| `q4_decoding.py` | `cbe363fe79772566af5b7a5da6ee92540d8d75547d65e63441eb9ff22b520bd1` | superseded by `papers/clebsch-hexagon-code/check_decoding.py` |
| `followup.py` | `609cc9abfcc85b4e6969bfa80e67c023d11c3a9af8543b4bf75b74de2a738e45` | orbit/curve exploratory source for C184 and C186 |
| `flags.py` | `2b9e7385918fc412c54b0fc4271e2c5439f47c00b00851d9162ca2a37067ddb3` | adversarial follow-up; sampled curve claims remain exploratory |
| `q2_step1.py` | `78632bdf47a9211910caec4cd97f2325034d1bb7a9ffd71e76bf41eacc026ec6` | source for C187's small-`k` identities; hardened derivative pending |
| `q2_step2.py` | `4aae772869e1a3f398255e86ef92cdc23991517bb2682cdc5b190949303bacb2` | source for C187's q=11/q=13 enumeration; hardened replay pending |

The three scripts that also arrived loose under `notes/` were byte-identical to the archive copies
before being moved here. Any manuscript-cited computation must use the hardened paper-package
derivative, not these originals.

## Raw replay

On 2026-07-15 the originals replayed as follows:

```bash
python3 q2_step1.py
python3 q2_step2.py
UV_CACHE_DIR=/tmp/uv-cache uv run --with numpy python flags.py
```

`q2_step1.py` and `q2_step2.py` exited zero; the latter reported `10232` and `53960` distinct
frame-normalized seven-arcs and zero quadratic-containment hits at q=11 and q=13. `flags.py`
exited zero under the explicit NumPy environment and found three distinct local `C5` support
partitions among its first four conic directions. Its degree-six table is sampled and is not an
exhaustive certificate. The raw q2 step-2 script prints, but does not assert, its seven-arc totals
and zero-hit conclusion; C187 therefore requires a hardened derivative before manuscript use.
