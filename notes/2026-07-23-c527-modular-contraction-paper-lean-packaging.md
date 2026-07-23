# C527 — C433/C526 modular contraction packaging for Paper 2 and Lean

**Lane:** `clebsch`

**Status:** `GATED; AFTER C526`

**Date:** 2026-07-23

## Goal

Package the C433 modular depth/Fourier theorem—and C526's final source-pairing disposition—as one
bounded Paper-2 theorem block plus one compact Lean terminal.  This is a packaging task, not a new
modular representation census, Paper-1 spine expansion, or full Paper-2 drafting campaign.

## Inputs and ownership

- `notes/2026-07-23-c433-modular-depth-fourier-exact-sequence.md`
- `notes/2026-07-23-c526-tate-pairing-rigid-target-bridge.md` and its completed evidence bundle
- `notes/2026-07-20-c425-clebsch-double-coset-depth-lean.md`
- `notes/2026-07-20-c426-clebsch-scheme-fourier-lean.md`
- `notes/2026-07-23-c511-weil-roof-phase-3-synthesis.md`
- the current Clebsch Paper-2 result ledger/outline named by the clebsch handoff.

The `clebsch` lane owns manuscript and Lean edits.  Before any Lean operation, read
`lean/AGENTS.md` completely and obey its guarded build, gate, axiom-audit, and process rules.

## Phase A — editorial placement

1. State the local q=11 theorem at its proved strength:

   - divided integral odd Fourier becomes a rank-two self-adjoint square-zero operator mod 11;
   - C411 depth kills the C412/C430 socle and selects a nondegenerate contracting complement;
   - matrix units and the valency metric make the ordered target flag projectively rigid;
   - the degree-5/6 `A5` interface remains semisimple.
2. Insert C526's disposition:

   - if positive, state the forced Tate/depth isometry and its exact naturality;
   - if negative, state the sharp source-pairing obstruction as the theorem boundary.
3. Place this as a local Modular Gateway model or appendix theorem in Paper 2.  Do not add it to
   Paper 1's protected replacement spine, and do not make novelty wording without a claim-specific
   literature audit.
4. Update the result ledger, proof/evidence map, and C320 adoption delta only if the theorem is
   actually adopted.

## Phase B — compact Lean terminal

Prefer generic finite-dimensional linear algebra plus frozen `Fin 4`/`Fin 3` data:

```text
F²=0,
im(F)=ker(F),
ker(D)=socle,
O=P_depth direct_sum im(F),
h²=0,
Fh+hF=1,
F self-adjoint for the valency form,
im(F) Lagrangian,
ordered target flag has projectively trivial isometric stabilizer.
```

Suggested module/gate names:

- `RelativeConicArcs.ClebschModularFourierContraction`
- `RelativeConicArcs.Gates.ClebschModularFourierContraction`

The finite leaf must recompute the identities from accepted matrices; it may not freeze the
conclusions as propositions.  Import C425/C426 terminals where useful, preserve their external
scheme-semantics boundary, use no project-local axioms, and run the exact terminal/axiom audit.
C526's source-pairing theorem is formalized only if its proof has a compact algebraic interface;
otherwise record it honestly as an external proved input.

## Acceptance and stops

Done means:

- one placement-ready Paper-2 theorem/boundary block;
- one import-only Lean gate with scoped build and axiom audit;
- exact theorem-to-evidence rows and source hashes;
- manuscript/result-ledger edits only within the adopted scope.

Stop rather than:

- drafting all of Paper 2;
- reopening C433/C526 calculations;
- formalizing Brauer-tree theory or general Tate cohomology merely to prove the frozen matrix leaf;
- importing the theorem into Paper 1;
- claiming a uniform q=7/q=11 family without C439's separate portability theorem.
