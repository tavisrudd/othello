# C864 — pinned external order-16 trust fact and the Al-Seraji anchor

**Lane:** `build-sys` · **Task:** C864 · **Date:** 2026-08-04

Closes the "still required" item on the order-16 package: a compact pinned fact that lets monorepo
trust tooling reason about a closure this repository deliberately never builds, and the
Al-Seraji--Al-Ogali external-input anchor that depends on it. No Lean elaboration, generator run,
or build was performed; every claim below is derived from the recorded gate verification and from
committed bytes.

## What the mechanism is

An external certificate package now publishes its own `TRUST_FACT.json`, and the monorepo carries
a byte-identical pinned copy under `lean/trust/external/`.

The fact is derived from one completed guarded-queue run over the package's import-only gate. For
every declaration whose axiom dependencies that gate printed, it records the declaring module, the
exact axiom list, and whether the declaration is owned by the package or comes from the package's
pinned base dependency. It also records the gate, the pinned terminal, the Lean source commit the
gate ran against, the sealed manifest digest, the toolchain, the base dependency revision, and the
digest of the preserved gate log together with its replay command.

`lean/scripts/lean-external-fact.py` seals, pins, and checks it. `seal` runs no Lean and starts no
build. It refuses a run whose recorded tree was dirty, whose root was not the package, whose gate
did not end built or trace-current, whose recorded commit is no longer the package's HEAD, or
whose preserved evidence log differs byte for byte from the run's own log. A hand-edited fact does
not verify against a re-seal.

The certificate-package registry gained `trust_fact` and `trust_fact_sha256`. Three independent
checks now disagree if any one of them is edited alone: `lean-external-fact.py check` compares the
pinned copy with the registry hash and cross-checks package, gate, terminal, and manifest digest;
`lean-certificate-boundary.py --verify-official-libraries` additionally requires the pinned copy to
be byte-identical to the artifact the package published; and the trust spine reports
`external-package-fact-stale` or `external-package-fact-missing` rather than silently reading an
area as having no external anchors.

## How an external anchor is declared

An `[[external_input]]` entry may now carry `entry_package`. Its entry declarations are then
resolved against that package's pinned fact instead of against local extraction units.

This is the design decision the earlier anchor review left open, and it was taken over the
alternative of package-qualifying the declaration name inside `entry_declarations`. Keeping the
package in its own field leaves entry declarations as real fully qualified Lean names, so a reader
and a checker see the same string that Lean prints, and the fact that an anchor leaves this
repository is visible at the point of declaration rather than encoded in a name.

An anchor that resolves to the package's *dependency* rather than to the package itself is
rejected (`external-input-entry-not-owned`). Such a declaration belongs to a library this
repository does audit, and routing it through a certificate pin would remove it from that audit.

## The two anchors

`RelativeConicArcs.Q16Classification.rejection_profile` is the formal anchor for the
Al-Seraji--Al-Ogali class count. It is owned by the order-16 package, declared in that package's
`Q16Profile.lean`, and the pinned fact records it depending on `propext` and `Quot.sound` alone.
The separation the task requires is exhibited rather than asserted: the same fact records the exact
order-16 terminal `RelativeConicArcs.rhoC_GF16` depending only on `propext`, `Classical.choice`
and `Quot.sound`, so no literature-derived axiom enters the order-16 result, and the class-count
agreement is read off after the fact rather than assumed by it.

The Kim--Vu complete-arc bound is anchored to `RelativeConicArcs.Averaging.rhoC_le_of_kimVuBound`.
`KimVuBound` is declared and consumed only in `lean/RelativeConicArcs/Averaging.lean`, by that one
theorem, so the trust boundary is exactly "this hypothesis in, this density bound out."

The NRC/GRS dictionary entry remains unanchored on purpose. Closing it is the strong
projective-GRS theorem prepared in the detached repair worktree, which needs its own Lean gate and
its proof-lane review.

## One correctness repair found while anchoring

The trust spine reported `external-input-entry-missing` for the Kim--Vu anchor, whose declaration
plainly exists in the source. The check conflated two different states: a declaration absent from a
complete extraction, and a declaration that cannot be seen because the area's extraction has not
run at all. The arcs area has fifteen units with no facts artifact, so the second state is the live
one. The check now distinguishes them and reports `external-input-entry-unverified` at warning
severity when any unit of the area is unextracted; the absent extraction is already an error
against the unit itself. A correct anchor no longer produces a false "missing" claim, and a wrong
anchor in a fully extracted area is still an error.

## Evidence and replay

Source of the fact: the completed gate run recorded at package commit
`d780520bc995df9db2575b52261786a1142649b0`, clean tree, toolchain `leanprover/lean4:v4.32.0-rc1`,
gate `RelativeConicArcs.Gates.Q16CertificateTrust` reported trace-current with no leaf rebuilt. Its
log is preserved in the package as `evidence/gate-axioms.log`, sha256
`5fe9ebc40f6f684cb7c220f7120965e62fd561da550b65d34fc7fad7b299dbb7`, and is sealed by the package
manifest.

Package state after this work: `~/src/lean/finitegeom-q16-certificates`, commit
`1ea9caace0718c2e041662b0d39d0ec867f299cc`, manifest sha256
`100e1fea3c458f37737d779dadab62954459b3f2d45d982bdda464bb64f8d5d3` sealing all 1331 Lean modules,
published trust fact sha256 `bd1304f11dd59c2ef271861f3e9fcfb47341bd2c884e6066d7fa5a8780e52496`. The
manifest also needed re-sealing: it still described the sources as of the commit before the
umbrella-import repair, so the boundary check was red on both the pin and one source digest before
this session and is green after.

Replay, from the monorepo root:

```text
python3 lean/scripts/lean-external-fact.py check
python3 lean/scripts/lean-certificate-boundary.py --verify-official-libraries
python3 lean/scripts/lean-trust-spine.py audit
cd lean/scripts && python3 -m unittest test_lean_external_fact test_lean_trust_spine \
  test_lean_certificate_boundary test_lean_trust_extract
```

Results: both pin checks pass; the audit's external-input errors drop from three to one, the
remaining one being the NRC/GRS dictionary; 112 tests pass, of which 17 are new adversarial tests
for sealing and pinning and 7 are new tests for package-anchored inputs.

## Two things deliberately left undone

The shared generated trust views were not regenerated. A regeneration attempt showed the global
graph manifest and `trust/PORTFOLIO.md` diverging far beyond this change — declaration and gate
counts move substantially — and it would also have folded in a foreign lane's uncommitted facts
artifact for the complete-ports gate, which is modified in the working tree and belongs to another
lane. The regenerated files were restored to their committed content. The two new `enters_at`
edges these anchors create will land at the next coherent quiet-tree regeneration, which the
existing certificate-boundary programme already owns.

A legacy referee-facing violation is recorded rather than fixed: `RelativeConicArcs/TRUST.md` and
the `RelativeConicArcs.C637Witness**` module family carry a task-identifier-shaped label, which the
Lean artifact standard forbids. Renaming a module family is the owning proof lane's change, not a
byte-preserving build-system repair.

## Mystery ledger

Nothing here is unexplained. The one surprise, that the sealed manifest disagreed with the package
it described, has an exact cause: the manifest is sealed against the HEAD it is written at, and the
umbrella-import repair landed after the previous seal, so the package carried a manifest describing
its own predecessor. The re-seal closes it, and the boundary check would have caught any recurrence
because it verifies every sealed source digest, not only the manifest hash.

`rejection_profile` depending on `propext` and `Quot.sound` without `Classical.choice`, where every
other recorded package terminal also depends on `Classical.choice`, is not a mystery: it is a
kernel-checked decidable statement over a finite domain, and the surrounding arithmetic theorems
are not.
