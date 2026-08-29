# Quantum-codes discovery track

**Lane:** `quantum-codes`

Append-only log for incidental observations and musings encountered during
planned quantum-codes work. Entries follow `notes/discovery-track-conventions.md`;
they are leads rather than lane obligations and allocate no work by themselves.

### 2026-08-28 — the choice of logical basis may be worth ~3x in exact distance solving

**Provenance:** C997 gate experiment, baseline run of Bravyi et al.'s
`distance_test.py` on the `[[144,12,12]]` gross code; raw numbers in
`notes/quantum-codes-reports/2026-08-28-c997-symmetry-reduction-gate.md`
section 4.1 and `results_gross_per_logical.json`.
**Was I looking for this?:** No. The run existed only to measure a baseline
branch-and-bound node count against which to score symmetry breaking.
**Observed / musing:** Node counts across the twelve per-logical integer
programs rise close to monotonically with the logical index, from 688,440 at
qubit 6 to 2,010,404 at qubit 10 — a 2.9x spread over what is an arbitrary
choice of basis for the logical space. The `bposd` basis comes from row
reduction, so later basis vectors are denser and less structured. Nothing about
the code makes one logical qubit intrinsically harder than another; every one of
the twelve returns the same optimum, 12.
**Why it may matter / strongest question:** If the spread is caused by the
density of the representative rather than by anything intrinsic, then choosing
low-weight or otherwise well-structured logical representatives before solving
is a lever worth roughly 3x on the standard pipeline, costs almost nothing, is
independent of symmetry breaking, and appears to be unexploited — the 2026
benchmark papers do not discuss basis choice. Strongest question: does the node
count correlate with the weight of the logical representative, and does picking
minimum-weight-so-far representatives greedily compound with the symmetry
reduction or overlap with it?
**Evidence:** CHECKED for the observation (twelve solves, all closed at gap
zero, deterministic single-threaded CBC); OPEN for the causal explanation and
for any claimed speedup.
**Status:** open lead
