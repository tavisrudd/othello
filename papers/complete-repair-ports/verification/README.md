# Formal verification boundary

This directory identifies the exact Lean boundary supporting the paper. It
does not treat a generated table or native computation as a proof of a body
theorem.

The field-seven sparse-paving representations have an independent exact
finite replay:

~~~text
python3 verification/f7-seed.py \
  --check verification/f7-seed.json
~~~

This checks the displayed circuit-hyperplane lists and their derived pointed
rank-triple multiplicity enumerator and radius-three reliability data.  The
body proof uses the displayed
minor ledger and the structural sparse-paving argument; it does not use the
script as a proof.

The stronger matched seeds also have a concrete independent instance over
`F_29`:

~~~text
python3 verification/matched-seed.py \
  --check verification/matched-seed.json
~~~

This checks the two `4 x 10` matrices, all three- and four-column ranks, the
complete circuit-hyperplane lists, `[10,4,6]` parameters and dual distance
four, equality of the pointed rank-triple histograms, the matched clutter
statistics, and the distinct reliability polynomials. The manuscript's
line-arrangement and generic-lift proof is independent of this concrete
cross-check.

The immutable inputs are recorded in formal-boundary.json:

- finitegeom repository https://github.com/tavisrudd/finitegeom;
- finitegeom release commit 36c83268ddaeec9ee22824cad44d6222a9e67081;
- Lean v4.32.0-rc1;
- mathlib revision 571b8a8e54219b4d393f75f4b8653fac08197fcc;
- import-only gate RepairPorts.Gates.CompletePorts;
- 36 modules and 61 paper-facing terminals.

From a checkout of the public finitegeom repository at the pinned release
commit, the complete library replay is:

~~~text
git clone https://github.com/tavisrudd/finitegeom.git
cd finitegeom
git checkout 36c83268ddaeec9ee22824cad44d6222a9e67081
nix run .#verify
~~~

The area statement is `trust/COMPLETE_PORTS.md`; its two content-addressed
source manifests agree on the 36-module closure and 61 terminals. The observed
axiom union is exactly `Classical.choice`, `Quot.sound`, and `propext`. The
strict weighted example remains conditional on the regular Singer-action
hypothesis displayed in its theorem statement.

The paper-local release verifier rejects stale PDFs, TeX warnings, stale seed
evidence, metadata drift, private-repository coupling, missing AI disclosure,
and malformed formal-boundary pins:

~~~text
nix develop .#manuscript --command \
  python3 verification/verify_release.py
~~~

After the area export has been adopted in a public finitegeom checkout, the
full release gate additionally binds the paper to that exported manifest and
the clean adopted finitegeom revision recorded as
`finitegeom_release_commit` in `formal-boundary.json`:

~~~text
nix develop .#manuscript --command \
  python3 verification/verify_release.py \
    --require-public-formal --lean-root /path/to/finitegeom
~~~

Refresh the tracked PDF only through the same deterministic checker:

~~~text
nix develop .#manuscript --command \
  python3 verification/verify_release.py --update-pdf
~~~
