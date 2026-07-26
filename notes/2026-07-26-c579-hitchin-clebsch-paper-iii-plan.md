# C579 Hitchin--Clebsch Paper III plan

**Lane:** `clebsch`

**Date:** 2026-07-26

## Provenance

The user supplied two reports and one reproducibility archive from a prior
ChatGPT conversation. They are preserved byte-for-byte as:

- `notes/2026-07-26-clebsch-top3-execution-report.md`;
- `notes/2026-07-26-hitchin-clebsch-bridge-report.md`;
- `notes/artifacts/2026-07-26-clebsch-top3-reproducibility-bundle.tar.gz`.

Their hashes are frozen in
`notes/artifacts/2026-07-26-clebsch-top3-SHA256SUMS`. Import records
provenance; it does not promote every claim in the reports to a verified
repository result.

## Disposition

The reports supply a credible principal organizer for Paper III:

> The golden Clebsch orientation torsor is an arithmetic fibre of Hitchin's
> ordered-icosahedron double cover.

The target theorem has four linked clauses:

\[
 w^2=5J_0,\qquad
 J_0|_{V_I}=16\sigma_3^2,\qquad
 \pi^{-1}(xyz)=\operatorname{Spec}\mathbf Q(\sqrt5),\qquad
 \text{deck exchange modulo }11=T_{11}.
\]

This passes C579's conceptual standalone-value test, subject to the exact
tensor, arithmetic-certificate, and literature gates below. Paper III should
be rebuilt around this theorem under a working title such as *The arithmetic
Hitchin--Clebsch orientation cover*. The previous passage, four-sheet
holonomy, theta, Fourier, quantum, and Mathieu material survives only when it
is a proved consequence or application of this cover; otherwise it returns
to inventory.

Paper II remains closed to this material. Its finite cubic-first orientation,
golden parent pair, \(A_4\) hinge, and \(T_{11}\) split are inputs to the
bridge, not invitations to add a characteristic-zero second spine. After
Paper III is proved, Paper II may receive at most a short companion-paper
forward reference in a separately validated revision.

The atomistic pilot is a bounded negative result and is not Paper II or
Paper III content. It may be retained as research inventory, but its
area/chemical descriptor must not be presented as predictive.

## Imported evidence status

The archive is a valid gzip/tar stream. The exact standard-library replay

```text
cd /home/tavis/src/othello
tar -xOzf notes/artifacts/2026-07-26-clebsch-top3-reproducibility-bundle.tar.gz \
  research/clebsch_w6_exact.py | python3 -
```

reproduces

\[
 W_6|_{V_4}=-\frac{784000}{1247103}\sigma_3.
\]

This is one implementation, not an independent replay. Its otherwise exact
\(\mathbf Q(\sqrt5)\) calculation uses a floating-point sign only to choose
fixed antipodal representatives; the task-owned version must remove that
incidental floating-point branch.

The supplied rank-ten comparison program is a protocol, not a completed
certificate. It assumes that the input tensor is already expressed in the
ten-pair permutation basis. Paper II instead computes its nonzero
220-coordinate cubic in frozen quotient coordinates and records only its
support and digest. A proof needs both the exported tensor and an explicit
\(A_5\)-equivariant intertwiner, including the invariant pairing used to
identify a tensor with a cubic form.

The archive contains no checker for the arithmetic Hitchin clauses:
\(I_4=A_-\), \(I_8=A_+\), the comparison matrices, the order-four exchanger,
its spinor norm, or its image in \(T_{11}\). Those claims require a compact
exact certificate and an independent replay.

The finite-field formula

\[
 \#X_f(\mathbf F_q)=1+\chi_q(5J(f))
\]

is presently unconditional for the explicit abstract quadratic cover on its
nonbranch locus. Its identification with the geometric incidence
correspondence is justified only outside an unspecified finite set of primes.
No claim that every \(p\ne2,5\) is good is admitted without an integral
Mukai--Umemura model and normalization comparison.

## Queued gates

1. **C651 — exact tensor bridge.** Export Paper II's rank-ten signed cubic,
   construct and verify the \(A_5\)-equivariant intertwiner with the ten
   face-pair module, compare invariant pairings, and decide the exact scalar
   relating \(\mu_3\), \(\sigma_3\), and the restricted Gaunt/\(W_6\) cubic.
   Require a compact certificate and independent replay.
2. **C652 — arithmetic-cover certificate.** Check the two golden fibres,
   \(I_4=A_-\), \(I_8=A_+\), the comparison matrices, the order-four
   exchanger, the \(A_4\) intersection, the spinor square class, and the
   \(T_{11}\) specialization. Package exact scripts, canonical output,
   hashes, and an independent implementation.
3. **C653 — integral and novelty gate.** Audit rational forms of the
   Mukai--Umemura incidence cover, Dye, binary-sextic invariant theory, and
   finite-field reductions. Prove the largest justified integral base and
   exact bad-prime boundary obtainable from available equations, or retain
   the spread-out finite-set formulation.
4. **C579 — Paper III synthesis.** After C651--C653, replace the exploratory
   skeleton with the arithmetic orientation-cover paper, admit only
   consequences of its principal theorem, build a Paper III-specific trust
   surface, and run independent cold review.

## Acceptance boundary

Paper III is not yet drafted or release-certified. The imported reports
establish a high-value route and several exact candidate calculations. C579
passes only when the three prerequisite gates support one theorem complex
with a complete proof/evidence map and when nonconsequential inventory has
been cut.

## Mystery ledger

- **Settled:** Paper III has a credible principal organizer stronger than the
  previous passage catalogue.
- **Open under C651:** whether Paper II's signed cubic is literally the
  Hitchin/Gaunt cubic after the correct intertwiner, rather than merely lying
  on an abstractly unique invariant line.
- **Open under C652:** an independently replayed exact arithmetic
  specialization from the golden fibre to \(T_{11}\).
- **Open under C653:** the minimal bad-prime set and prior-art status of the
  \(5\)-twist and finite-field incidence interpretation.
- **Deferred:** theta, Fourier, quantum, Mathieu, and four-sheet holonomy
  comparisons unless C579 derives them from the orientation cover.
