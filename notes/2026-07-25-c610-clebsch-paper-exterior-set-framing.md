# C610 — Paper I exterior-set and MDS framing

**Lane**: `clebsch`

**Status**: complete.

## Goal

Extract the strongest cheap presentation gain from C605 without adding a new
computational dependency:

1. state the length-at-most-eight projective MDS classification explicitly;
2. promote the sharp maximum-six all-passant-arc result from proof detail;
3. identify the terminal objects as exterior sets of a conic, while allowing
   both internal and exterior point types;
4. expose the conceptual \(q=13\) passant-saturation reduction; and
5. regenerate and pass Paper I's complete release surface.

## Boundary

Do not hold Paper I for a uniform conceptual proof at \(q=17,19\), introduce a
new theorem row when prose within the existing row suffices, or absorb the
broader coherent-configuration and incidence-code program owned by C611.

## Result

Paper I now states the coding-theoretic classification on page one:
among projective \([k,k-3,4]_q\) MDS codes with \(4\leq k\leq8\), the only
codes whose projective distance-three syndrome locus is a nonsingular conic
are the \([4,1,4]_5\) frame code and the \([6,3,4]_{11}\) Clebsch code, up to
monomial equivalence. This is the standard parity-check-column translation
of the existing arc classification, not a new computational dependency.

The terminal theorem now also records the stronger C605 result: for each
\(q\in\{13,17,19\}\), an arc all of whose chords are passant to a fixed
nonsingular conic has at most six points, and six-point examples exist. The
proof names these objects as exterior sets of a conic in the sense of
Blokhuis--Seress--Wilbrink and explicitly allows both internal and exterior
point types.

For \(q=13\), the proof exposes the elementary mechanism available before
search. An exterior point lies on six passants and therefore cannot support
the seven distinct chords through a vertex of an eight-arc. Every vertex
would consequently be internal, and its seven chords would exhaust its
complete seven-line passant pencil. The exact certificate search remains
responsible for the final incompatibility and for \(q=17,19\).

## Verification

- Warning-free forced build: 19 pages; PDF SHA-256
  `b3af5a3dba9815878422efd20df2c809a23ffa8593ec1226080ffbd3d760cf1b`.
- Statement identity and nineteen-row trust manifest regenerated.
- Eleven paper-local verification-tool tests pass.
- Trust-manifest validation passes with all sixteen checks present.
- The refreshed release certificate passes against Lean commit
  `6d4766d1ea5e9a36f1a507e549c223416a6b506f`; release-surface SHA-256
  `2332c6bbb7061c09e6605f53d6f560874825d97809efa934262ab0d5661d6ff0`.

The scholarly delta is committed at `ce2c94d1`; the refreshed certificate is
committed at `fd2dee6e`.

## Extra-juice and Tao-style closeout

The cheapest defensible gain was presentational but mathematically real:
the paper previously contained the ingredients while understating their
coding consequence and the sharpness of the terminal computation. Promoting
both makes the endpoint legible without manufacturing another theorem row
or enlarging the trust surface.

The natural stronger theorem would explain the maximum six uniformly.
At \(q=13\), passant-pencil saturation is a genuine first reduction; an
incidence-code argument may finish it conceptually. At \(q=17,19\), point
degrees leave slack, so a proof likely needs the conic stabilizer's coherent
configuration, a Terwilliger/Delsarte-type bound with the no-three-collinear
constraint, a rational dual certificate, or a Segre tangent identity. That
program is deliberately assigned to C611 and does not hold version 1.

## Mystery ledger

- **Why is six the common maximum?** Exact computation and independent replay
  settle the value for all three fields. The \(q=13\) local saturation
  mechanism is now printed, but a conceptual final contradiction remains
  open. C611 owns that bounded mechanism audit.
- **Does the coding statement need new formalization?** No. It is the
  classical projective parity-check-column and distance-three syndrome
  dictionary applied to the theorem already on the trust surface. A Lean
  implementation would improve assurance in version 2 but is not a new
  version-1 proof gap.
- **Should \(q=17,19\) delay Paper I?** No. Their exact terminal
  classifications have primary and independent replay, compact
  certificates, and a clean sixteen-check release. C611 may sharpen the
  explanation or route a general theorem to another paper.
