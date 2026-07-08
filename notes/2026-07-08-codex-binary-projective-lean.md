# Binary projective cap/Nofil theorem in Lean

Date: 2026-07-08.

## Result

The `q = 2` projective column is now formalized.

New files:

- `lean/CapGame/Embedding.lean`
- `lean/Sumfree/Nonzero.lean`
- `lean/ProjectiveCap/Binary.lean`

New public theorem names:

- `FiniteBuildGame.isP_embedding`: transports game values across a live embedded subboard.
- `Sumfree.Game.nonzero_initial_isP_zmod2_of_finrank_ge_two`: the nonzero part of a finite
  `ZMod 2` vector space of rank at least two is P for the restricted sum-free game.
- `ProjectiveCap.Projective.binaryPointEquivNonzero`: equivalence
  `Projectivization (ZMod 2) V ≃ {v : V // v ≠ 0}`.
- `ProjectiveCap.Projective.binary_nonzeroValid_iff_cap`: binary projective caps are exactly
  sum-free sets of nonzero vector representatives.
- `ProjectiveCap.Projective.initialPStatement_binary_of_finrank_ge_two`:
  `Projective.InitialPStatement (K := ZMod 2) (V := V)` from
  `2 ≤ Module.finrank (ZMod 2) V`.
- `ProjectiveCap.Projective.initialPStatement_binary_of_projectiveDim_ge_one`:
  the `PG(n,2)` formulation from `1 ≤ n` and `finrank V = n + 1`.

This proves the impartial shared cap/Nofil initial position on `PG(n,2)` is P for every
projective dimension `n ≥ 1`. Rank `1` / `PG(0,2)` remains correctly excluded.

## Proof Shape

The proof factors through the existing sum-free game theorem rather than recomputing a projective
strategy tree.

1. Over `ZMod 2`, every projective point has a unique nonzero vector representative.
2. A distinct binary projective collinear triple is exactly `x + y = z` on representatives.
3. Therefore the projective cap predicate transports to `Sumfree.Game.NonzeroValid`.
4. The existing rank-count sum-free theorem gives the P-position on the nonzero subboard.
5. `FiniteBuildGame.isP_equiv` transports the game value back to projective points.

The informal strategy remains: after P1 plays `a`, P2 chooses `b ≠ a`; the point `a+b` is
blocked, and translation by `a+b` pairs the remaining live nonzero vectors.

## Verification

Commands run from `lean/`:

```text
nix develop --command lake env lean CapGame/Embedding.lean
nix develop --command lake build CapGame.Embedding
nix develop --command lake env lean Sumfree/Nonzero.lean
nix develop --command lake build Sumfree.Nonzero
nix develop --command lake env lean ProjectiveCap/Binary.lean
nix develop --command lake build CapGame.Embedding Sumfree.Nonzero ProjectiveCap.Binary
nix develop --command lake env lean CapGame.lean
nix develop --command lake env lean Sumfree.lean
nix develop --command lake env lean ProjectiveCap.lean
```

All exited `0`. The final parallel umbrella checks printed Nix eval-cache "busy" messages as
ignored diagnostics, but Lean exited successfully.
