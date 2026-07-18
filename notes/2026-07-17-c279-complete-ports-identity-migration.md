# C279 complete-ports private identity migration

**Lane:** `complete-ports`

**Status:** COMPLETE — the private paper package, source/PDF stem, preparation artifacts, and
expert profile now use the canonical complete-ports identity. No repository was initialized or
copied, no remote or license was chosen, and no Lean or historical `repaircodes` identifier changed.

## Result

- Renamed the private package to `papers/complete-repair-ports/`, with
  `complete_repair_ports.tex` and a freshly built `complete_repair_ports.pdf`.
- Renamed the C274/C275 paper artifacts and expert profile; normalized contextual M1/M2 shorthand,
  registries, build commands, link targets, and the deny-by-default publication allowlist.
- Established the six-part manuscript skeleton: bounded ports; weighted-functional transfer;
  prescribed realization; reliability/bounded EXIT; pointed Tutte; and the cubic versus
  quartic-nucleus/harmonic flagships. The retained theorem text is not represented as a completed
  rewrite of the three newly introduced structural sections.
- Preserved every historical `repaircodes` lane peg and all `RepairCodes`/`RepairPorts` Lean names.

## Validation

From `papers/complete-repair-ports/`:

```text
nix shell nixpkgs#tectonic -c tectonic complete_repair_ports.tex
```

The build completed successfully. The PDF is 166269 bytes with SHA-256
`f706989dbaca842bfc72a3744321527558328db333f06e61af4c051473359198`.

Bounded stale-name scans leave the old package/stem only where C276 deliberately records the
before/after migration and where archived task prose records the historical identity. Contextual
M1/M2 labels are absent from C259, the renamed C274/C275 artifacts, the current handoff, and the
allowlist. All Markdown links changed by the migration resolve to tracked destinations.

## Boundary

This task does not perform the substantive six-part manuscript rewrite, decide C220, choose a
license or public destination, initialize fresh Git history, export files, publish, or push.
