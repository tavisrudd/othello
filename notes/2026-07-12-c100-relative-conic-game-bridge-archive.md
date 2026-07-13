# C100 relative-conic game bridge — archive

Append-only session history for
[`2026-07-12-c100-relative-conic-game-bridge.md`](2026-07-12-c100-relative-conic-game-bridge.md).

## 2026-07-12 — consumer review and adversarial pass complete

- Added ordinary canonical-projective coverage to the rules-only checker and proved the q=9
  witness complete with no legal cap extension; its actual projective position is P.
- Strengthened the localization bridge from persistent move containment to an exact recursive game
  equivalence for every injective parametrization of the holes.
- Proved that all q=11 seeded continuations are exactly the independent sets of the determinant
  conflict graph, then transported the antipodal residual P theorem back to the actual six-point
  projective-cap position.
- Tested all fifteen four-subsets of each q=9 and q=11 witness. For every legal intrusion, the
  probe searched for a legal reply into a projective copy of the six-point witness; zero subsets
  had this two-ply closure. The q=9 intrusion tablebase terminal leaves instead have eight points,
  and the q=11 witness's six quadratic monomials have full rank, so its points do not lie on a
  conic. No reachability conclusion was inferred from static existence.
- Proved that off-hole legal cap moves equal the defect theory's uncovered required locus. This
  translates the variables exactly, but `uncovered_bound` leaves that count as static slack and
  provides neither a monotone C80 drain nor a minimax reply bound; no C80 sharpening was retained.
- Adversarial review caught and closed the original semantic gap between “the residual graph is P”
  and “the seeded projective cap is P.” It also checked freshness, hole-range surjectivity, all
  continuation subsets, and the distinction between value and reachability.
- Focused builds passed for `ProjectiveBridge`, `Q9Terminal`, and `Q11Residual`. New load-bearing
  declarations print exactly `[propext, Classical.choice, Quot.sound]`.
