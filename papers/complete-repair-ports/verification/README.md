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
profile and radius-three reliability data.  The body proof uses the displayed
minor ledger and the structural sparse-paving argument; it does not use the
script as a proof.

The immutable inputs are recorded in formal-boundary.json:

- source commit e45c925e11112b4a21a17ff23029243904fc5865;
- finitegeom base commit b871c10b4a91200a0913644d39b9f0ce44f655ca;
- Lean v4.32.0-rc1;
- mathlib revision 571b8a8e54219b4d393f75f4b8653fac08197fcc;
- import-only gate RepairPorts.Gates.CompletePorts;
- 36 modules and 61 paper-facing terminals.

From a checkout of the source repository at the pinned source commit, the
guarded replay is:

~~~text
python3 lean/scripts/lean-build-queue.py build \
  RepairPorts.Gates.CompletePorts \
  RepairCodes.ProjectiveAxisTwistedCubicInvariants \
  --cores 0-3

python3 lean/scripts/lean-trust-spine.py audit --area complete_ports
~~~

To reproduce the standalone formal-area plan against a clean finitegeom
checkout at the pinned base commit:

~~~text
python3 lean/scripts/lean-area-export.py \
  --config lean/trust/export/complete_ports.toml \
  --source-commit e45c925e11112b4a21a17ff23029243904fc5865 \
  --finitegeom-repo /absolute/path/to/clean/finitegeom \
  --finitegeom-commit b871c10b4a91200a0913644d39b9f0ce44f655ca \
  plan
~~~

The plan must report 888036 closure bytes, no prose drift, the 36-module
closure listed in the JSON manifest, and only Classical.choice, Quot.sound,
and propext in the permitted logical-axiom set. The strict weighted example
remains conditional on the regular Singer-action hypothesis displayed in its
theorem statement.
