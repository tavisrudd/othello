# C751 — Paper I proof-spine tightening

**Lane:** `clebsch`

**Date:** 2026-07-31

## Result

The focused Paper I manuscript now makes its headline rigidity theorem an
immediate equality-case argument.  The universal chord identity gives
`|U(A)| = 22-c(A)` at q=11, Dye gives `c(A) <= 10`, and the line bound gives
`|U(A)| <= 12` for every containing conic.  Equality forces the Clebsch
orbit; exteriority and Bezout identify the containing conic.  The uniform
conic-filling window follows this completed proof instead of interrupting it.

The code section now reaches the projective deep-hole conic and its exact
leader counts before the auxiliary A5 point-orbit ledger.  No theorem or
trust boundary changed.

The golden square has a structural pentagon proof.  After normalizing above
one axis, its C5 stabilizer makes the remaining signs constant on pentagon
sides and diagonals.  Equal signs contradict connectedness or transitivity of
the five-valent A5 orbital graph, so the two signs are opposite; separate
row-zero and adjacent/diagonal cancellations give `B^2=5I`.  The old
four-plus/four-minus count is then recovered as a corollary, not used as an
input.  The trace-dual node proof retains the full typed perfect pairing,
rank-four annihilator, four-parameter complement, determinant, and explicit
nonsingular specialization.

## Referee comparison

The first blind referee preferred the prior proof `91--88`: the revision won
architecture and economy but compressed the trace-dual calculation too far,
while the prior proof retained an unproved four-plus/four-minus orbital count.
The referee prescribed a hybrid with the revised causal order, a proved
orbital identity, the full trace-dual complement, an explicit holonomy sign,
and qualified Dye existence wording.

Two new anonymous candidates implemented that diagnosis.  The literal version
proves the orbital identity from a complete A5/C5 double-coset sign table; the
optimal version derives it from the stabilizer-forced signed pentagon.  Both
restore the full trace pairing and four-dimensional complement calculation,
pass the exact orientation replay, and build warning-free at `21+12` pages.
They are frozen respectively at commits `2556d91b` and `7cd7ccc9` and blobs
`3d5bfc31` and `2686b569`.

The second blind referee preferred the optimal pentagon version `96--91`:
the literal table scored correctness 97, transparency 90, architecture 88,
economy 84, confidence 96, overall 91; the optimal proof scored correctness
96, transparency 95, architecture 98, economy 98, confidence 95, overall 96.
The referee required four local closures: prove both orbitals self-paired and
one point per fibre independently; spell out the two `B^2` cancellations;
type the trace Hom spaces and rank-four annihilator; and state Dye's local
field hypotheses.

Commit `a27a5fca` closes all four, recovers the old `4+4` count afterward, and
adds the complementary holonomy check.  The same referee returned final
**GO**, expressly finding the recovered count noncircular.  The winning source
blob is `7ec1f4c1aa78f58729039ae4bd18ab4ac1c15662`; it entered the authoritative
history as commits `66484219` and `283e3509`.

## Validation

- exact orientation replay: green;
- isolated XeLaTeX build: warning-free, twenty-one pages;
- the candidate checker-output recapture is byte-for-byte identical to the
  tracked record (SHA-256 `cd4386...`);
- final authoritative PDF, statement identity, and trust manifest refreshed
  in commit `d9d515cf` against q11 pin `42ab1a2`;
- full authoritative release gate and final standalone synchronization:
  running.

## Mystery ledger

The first referee exposed the overcompressed trace-dual paragraph; restoring
the full complement settled it.  The second referee exposed the latent
self-pairing/fibre-bijection and cancellation obligations; all are now
explicit.  The old `4+4` assertion is demoted to a consequence of the
pentagon calculation.  No C751 mathematical mystery remains after final GO.
