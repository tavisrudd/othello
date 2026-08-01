# C759 — generated external trust exports

**Lane:** `build-sys`
**Outcome:** complete; external projections green, second-kernel pilot blocked at its version gate

## Delivered

`lean/scripts/external-trust-exports.py` generates three projections under
`lean/trust/external/`:

- `formalization.yaml`, following the mathlib-initiative v0.3 reporting shape while retaining a
  portfolio-specific `othello_trust` extension;
- `HEADLINE_RESULTS.md`, compact headline-gate and area-coverage tables; and
- `headline-theorems.json`, the exact machine-readable set of adopted public terminals.

The exporter reads the existing portfolio and paper registries, their area spines, fresh C681
paper-facts extraction, Lean facts artifacts, the canonical graph manifest, and the pinned
toolchain.  It introduces no terminal, axiom, title, manuscript identity, source hash, certificate
provenance, replay command, or review verdict as a new authority.  Every theorem record has the
stable identifier `trust-spine:<area>:terminal:<declaration>` and points back to its area and gate.

The current export contains exactly 95 declared terminals: 42 in `complete_ports`, seven in
`finitegeom_first_tag`, and 46 in `relconic`.  Thirty-six complete-ports terminals have current
extracted facts whose axiom sets equal the declared sets.  Six newer complete-ports terminals and
all 53 terminals in the other two areas remain explicitly `declared-unextracted`; neither the YAML
manifest nor the headline table promotes those declarations to observed verification.

Known certificate inputs retain their declared generator and input hashes.  The 15 relconic data
trees remain visibly `legacy-unverified`, exactly as their authoritative spines classify them;
the external view does not invent a content or regeneration claim for them.

## Determinism and rejection gate

`generate` writes each output atomically and only when bytes differ.  `check` reconstructs all
three outputs in memory and rejects a missing, stale, or manually edited file.  The adversarial
test changes an exported axiom list and confirms that the read-only check fails.  A second
generation from unchanged inputs changes no bytes.

Validation:

```text
python3 -m unittest lean/scripts/test_lean_trust_spine.py \
  lean/scripts/test_paper_facts.py lean/scripts/test_external_trust_exports.py
# 107 tests, all passed

python3 lean/scripts/external-trust-exports.py check
# external trust exports current: 95 terminals
```

## Second-kernel disposition

**Blocked.**  The task contract permits the disposable Nanoda feasibility pilot only after the
Lean 4.32 final-version gate.  `lean/lean-toolchain` pins
`leanprover/lean4:v4.32.0-rc1`, so the precondition is false.  The pilot stopped before setup:
zero downloads, zero generated challenge files, zero builds, and no persistent disposable state.
No sorried module was created or committed, and no Comparator or portfolio-wide second-kernel
rollout is inferred.

## Vibe check

Good: the low-risk interoperability layer is real and self-policing, and it exposes rather than
hides the portfolio's extraction gap.  The one deferred experiment is cleanly gated by the pinned
release candidate, not by an implementation failure.
