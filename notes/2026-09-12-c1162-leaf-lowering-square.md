# C1162 — finite leaf-lowering square

**Lane**: `ergodis`
**Date**: 2026-09-12
**Status**: IN PROGRESS.

Continue within the user-authorized window ending 2026-09-13 01:30:51 UTC.
C1161 closed at monorepo `761a4d683`, core `9cd2980`.

Chosen family: existing C1091/C1092 privacy transcript over two GF(2) secrets
and one shared mask. Source states are subsets of the eight possible linear
observations; events append one observation. G retains the full joint observation
span; H updates that span. Leakage-only G is a negative control because it loses
mask correlations. This follows existing `transcript_leakage` semantics.

Deliverables: domain-neutral bounded finite square checker and counterexample-
guided table synthesis in core; actual privacy family and exhaustive independent
physical-assignment oracle in private; precise finite-domain evidence. Generic
Lean square/trace transport is useful if it fits the remaining window. No claim
that arbitrary source lowering or all field sizes are verified.

This is cold finite admission/synthesis, not a solve-loop optimization. Existing
hot layouts and loops are unchanged; no performance claim. Initial bound is 256
source subsets × eight events, 16 joint spans. Core trusts the supplied total
finite model; family tests must discharge its connection to production semantics.
