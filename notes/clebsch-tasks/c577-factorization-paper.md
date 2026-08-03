# C577 — Paper II factorization memory

**Lane:** `clebsch`

**Opened:** 2026-07-24

**Status:** active.  The C749 human freeze, C750/C801 Lean closure,
Milnor--Serre exposition pass, deterministic packaging, and local standalone
forward commit are complete.  The authorized GitHub push is blocked only by
missing SSH/GitHub credentials in the current environment; the immutable
locator and locator insertion remain external.

## Objective

Release *Quadratic trade rigidity and cubic orientation in conic matching
quotients* as a standalone Paper II with no proof dependency on Paper I or
Paper III.

## Frozen spine

1. the matching-secant quotient and four-endpoint switch;
2. the \(A_3,B_3,H_3\) configurations and ranks \(3,6,10\);
3. quadratic balanced-sheet recovery and cubic-first orientation;
4. self-association, Schur powers, and Gorenstein duality;
5. decorated \(H_3\) profile, modular, arithmetic, and relative-cubic
   appendices; and
6. a Paper II-owned trust and replay surface.

## Current state

- The general self-associated/Schur-square/Gorenstein mechanism is credited
  to Rodr\'iguez-Pajares--Ruano--Salizzoni (2025).  Paper II's surviving
  headline is the reverse rigidity theorem: the exact \(B_3/H_3\) full-orbit
  classification follows from the two-valued quadratic-trade condition alone,
  without a self-duality or Gorenstein premise, and the recovered sheet sign
  has a nonzero cubic as its first signed tensor moment.
- The manuscript, conclusion, proof/evidence map, and verification
  architecture are complete.  C749 closed the reopened all-\(q\) human
  proof seam with a final context-free **GO**.
- The opening, section hierarchy, conclusion, verification prose, README,
  and appendix transition have passed the Milnor--Serre copy edit recorded
  in notes/2026-08-02-c577-paper-ii-milnor-serre-copy-edit.md.
- All paper-owned semantic evidence paths and the local aggregate replay are
  green.
- The authoritative Zenodo metadata now matches the final title and theorem
  scope at commit `8fa7ac41bfd31906891de8fa0c9c1d6bee799cb4`.  The canonical
  62-file export is committed forward in the standalone repository at
  `71751691b026ff99c53a64c522b0464a2c5582e0`; its isolated aggregate replay
  and export-manifest verification are green.  The attempted authorized push
  failed because this environment has neither a usable GitHub SSH key nor an
  authenticated `gh` session.
- Exact findings and completed trust/editorial repairs are recorded in
  `notes/2026-07-31-c577-paper-ii-new-math-audit.md`.

## Next action

From an authenticated environment, push standalone commit
`71751691b026ff99c53a64c522b0464a2c5582e0`, create the immutable public
release/archive, insert its locator in the authoritative manuscript and
README, regenerate and forward-commit the canonical export, then rerun the
isolated release and separate final release pass.

## Boundaries

- C665 results are Paper II v2 candidates and do not hold or enlarge v1.
- C682 characteristic-zero material is inventory unless separately promoted.
- Paper I supplies motivation and a future citation, never inherited proof.

## Acceptance and records

Acceptance requires the immutable locator, isolated replay of the frozen
package, a final PDF/release review with no material objection, and closure
of the 2026-07-31 all-`q` proof-depth finding.

Current priority boundary and adjacent-crown extraction:
`notes/2026-08-02-c577-paper-ii-priority-extraction.md`.  Current proof-depth
boundary and mystery ledger:
`notes/2026-07-31-c577-paper-ii-new-math-audit.md`.  Earlier theorem
development remains in
`notes/2026-07-25-c577-clebsch-factorization-memory.md`.
Packaging and synchronization report:
`notes/2026-08-02-c577-paper-ii-packaging-sync.md`.

C797 closes the stronger priority-judo continuation negatively: at \(q=7\),
seven \(S_4\)-fixed affine placements share the unique two-valued trade and
only one is a matching orbit.  This confirms that the perfect-matching carrier
in the current theorem is a genuine hypothesis; the sharp boundary is now
integrated in the manuscript.
