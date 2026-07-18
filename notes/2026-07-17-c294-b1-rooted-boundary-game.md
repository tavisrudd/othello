# C294 B1 continuation card: rooted boundary-game semantics

**Lane:** `crowns`  
**Selector:** `C294 B1`  
**Status:** active  
**Dependency:** current corrected component bundle only

## Goal

Define the smallest one-port impartial-game object that retains the causal fact lost by the failed
three-nimber signature: playing the attachment root deletes the shared core vertex and changes all
other pieces incident there. State a value-preserving replacement theorem or produce a minimized
counterexample to the proposed semantics.

This slice defines the mathematical object. It does not scale the solver, classify a hard q=5
follower, edit ProjectiveCap, or start Lean formalization.

## Required cold read

Read, in order:

1. `notes/2026-07-17-c294-routing.md`.
2. `notes/2026-07-17-c294-component-nimber.md`.
3. `notes/2026-07-07-named-expert-personas-context.md` and
   `notes/expert-personas/schaefer-siegel-nodekayles-certificates.md` before proof development.

Do not preload the wall-defect, linked-port, pairing, or bronze reports unless the proposed
definition reaches a specific ambiguity that the router summary cannot resolve.

## Fixed local model

- `G` is a finite residual graph of maximum degree at most three.
- A core vertex `b` is the single boundary port.
- A rooted attachment `(T,r)` is joined by the edge `b--r`.
- A move strictly inside `T-r` changes only the attachment and leaves `b` live.
- A move at `r` deletes `b`, `r`, and the neighbours of `r` in `T`; it therefore changes the mode
  of every other attachment and core edge incident at `b`.
- If `b` is played by the core context, `r` is deleted and the residual forest `T-r` splits off.

The false summary `(g(T), g(T-r), g(T-N[r]))` forgets which options preserve `b` and which kill it.

## Required deliverable

Write `notes/2026-07-17-c294-b1-rooted-boundary-game-result.md` containing:

1. finite definitions of live-port and dead-port states;
2. option labels that distinguish port-preserving and port-killing moves;
3. admissible one-port contexts and the gluing operation;
4. contextual P/N or nimber equivalence under every admissible context;
5. a replacement theorem with explicit hypotheses, or a bounded obstruction showing the state is
   still incomplete; and
6. the exact finite representation B2 must check.

Prefer a finite transition object or recursively interned option DAG. Do not propose another fixed
tuple of standalone nimbers without proving that it respects gluing.

## Gates and falsifiers

- Reconstruct why the 15/19-vertex witness can share the old triple but have nimbers 4 and 1.
- The proposed semantics must distinguish that witness before any larger enumeration.
- Port-killing transitions must be causal: a response may use only the actual current history.
- Disjoint closed components combine by xor; do not silently xor pieces that still share `b`.
- If one port is insufficient, state the smallest extra boundary data and minimize a witness. Do
  not jump directly to a many-backbone structural diagram.

## Owned paths and hand-back

- This card and `notes/2026-07-17-c294-b1-rooted-boundary-game-result.md`.
- Update `notes/2026-07-17-c294-routing.md` and the crowns handoff only when B1 exits.
- Computational witnesses, if needed, use a common `2026-07-17-c294-b1-*` stem with report,
  generator/checker, canonical output, and checksums committed atomically.

B1 passes only when B2 can implement the state without guessing semantics. On pass, mark B2 active;
on failure, keep B1 active with the minimized obstruction and revised target.

