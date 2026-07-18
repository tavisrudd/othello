# C277 complete-ports paper-lane split

**Lane:** `complete-ports`

**Status:** COMPLETE — paper-preparation tasks C274--C276 are re-pegged to the dedicated
`complete-ports` lane, its focused handoff is live, and the completed RepairCodes handoff is
archived. All pre-C274 `[repaircodes]` pegs and all `RepairCodes`/`RepairPorts` Lean namespaces are
unchanged.

## Exact boundary

- moved to `complete-ports`: C274 theorem/evidence crosswalk, C275 publication manifest/allowlist,
  C276 rename census, and future paper-preparation tasks;
- retained in `repaircodes`: C111--C224 theorem/formalization history, the completed claim ledger,
  formal trust boundary, and every older task peg; and
- unchanged code identity: `RepairCodes`, `RepairPorts`, their Lean modules, and cited declarations.

Root routing now sends `go complete-ports` to the focused paper handoff and `go repaircodes` to the
archived theorem/formalization handoff. No paper source, report filename, Lean source, build
artifact, repository, or remote was renamed, copied, built, or published in C277.

## Next step

The live complete-ports handoff owns C276's atomic paper-only rename. Public export remains gated on
repository identity/remote, license, C220 inclusion, and the separately owned all-papers Lean export.
