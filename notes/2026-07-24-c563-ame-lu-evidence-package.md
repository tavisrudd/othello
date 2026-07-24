# C563 — AME LU paper-local reproducibility package

**Lane:** `ame-lu`

**Date:** 2026-07-24

**Status:** complete; every computation retained by C561 has a paper-local
report, exact generator, compact certificate, manifest entry, and deterministic
replay

## Imported evidence

C561 retains the computational results of C374, C396, C397, C402, C546, C548,
and C550.  Their fourteen generators and canonical JSON certificates are now
under `papers/ame_lu/supplement/evidence/`, byte-identical to the frozen source
artifacts.  C395's arithmetic module is also imported because C396 hash-pins and
loads it; it is a load-bearing input, not an additional adopted theorem.

`papers/ame_lu/supplement/EVIDENCE.md` records, for each result:

- the exact paper-facing claim and domain;
- the generator and certificate;
- the independent arithmetic path, direct replay, or invariant check;
- what the certificate does and does not establish; and
- the trusted mathematical and computational boundary.

`EVIDENCE-MANIFEST.json` records SHA-256 hashes and byte counts for all fifteen
load-bearing files.  `verify.py` rejects schema drift, missing or escaping
paths, byte-count mismatches, hash mismatches, invalid replay commands, and any
nonzero generator exit.

## Exact replay

From the repository root:

```text
cd papers/ame_lu/supplement
python3 verify.py
python3 verify.py --replay
```

The first command checks fifteen byte counts and hashes without changing the
worktree.  The second repeats that gate, reconstructs all seven certificates in
memory, and requires byte-for-byte equality with the tracked JSON.  It uses
only the Python 3 standard library and deterministic exact arithmetic.

The independent checks are claim-specific rather than one nominal duplicate:
C374 compares CSS and full-Lagrangian shortenings and exhausts the GRS domain;
C396 compares symbolic identities with direct projectivity, Lagrangian, and
finite-field paths; C397 uses full-row-space, group-closure, Gale, and orbit-sum
checks; C402 compares concurrency determinants with direct shortened-
Lagrangian ranks; C546 separates projective enumeration from Fourier character
orthogonality; C548 compares quotient-field minors with direct finite-field
elimination; and C550 compares cycle-cover, fraction-free determinant, and
section/transport kernels.

## Synchronization

The package updates `verification-map.md`, the paper README, and the
adversarial evidence audit.  C560's headline rigidity theorem and C559's
fixed-copy boundary require no new computation; C396's imported bundle supplies
the computational part of the pencil corollary.  The package does not promote
detector exceptions into rigidity exceptions or enlarge any domain in
`theorem-map.md`.

## `ej` and Tao closeout

The closeout exposed one hidden reproducibility dependency: C396's apparently
self-contained checker imports the hash-pinned C395 arithmetic module.  Adding
that exact module makes the supplement genuinely portable instead of merely
copying the seven visible checker/certificate pairs.

The cheapest useful strengthening was a single replay driver over manifest
data.  This prevents documentation and execution lists from drifting and
checks the immutable bytes before importing or running any generator.  No
additional computation survives C561's theorem hierarchy, so importing source
experiments or unused reports would weaken rather than improve the public
package.

## Mystery ledger

| Feature | Disposition |
|---|---|
| Whether the seven adopted bundles are self-contained | **Settled:** C396 additionally needs the imported, hash-pinned C395 module. |
| Whether C546 should be omitted as only a boundary remark | **Settled negatively:** it remains an adopted paper-facing computational boundary in `theorem-map.md` and therefore receives a full bundle. |
| Whether C559/C560 need synthetic certificates | **Settled negatively:** their adopted content is conceptual proof; the verification map states that no new computation is required. |
| Whether any adopted computation lacks an independent path | **Settled:** every bundle records a direct replay, separate arithmetic derivation, or independent invariant check. |

No C563 reproducibility mystery remains.

## Vibe check

Strong.  The paper no longer depends on crowns-lane paths or remembered runs:
one compact, deterministic, paper-local package now carries every adopted
computational claim and its honest trust boundary.
