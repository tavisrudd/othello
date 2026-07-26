# C579 Hitchin--Clebsch Paper III plan

**Lane:** `clebsch`

**Date:** 2026-07-26

## Provenance

The user supplied three reports and two reproducibility archives from prior
ChatGPT conversations. They are preserved byte-for-byte as:

- `notes/2026-07-26-clebsch-top3-execution-report.md`;
- `notes/2026-07-26-hitchin-clebsch-bridge-report.md`;
- `notes/artifacts/2026-07-26-clebsch-top3-reproducibility-bundle.tar.gz`;
- `notes/2026-07-26-clebsch-targets-4-5-7-8-report.md`;
- `notes/artifacts/2026-07-26-clebsch-targets-4-5-7-8-bundle.tar.gz`;
- `notes/2026-07-26-klein-intermediate-jacobian-kill-test.md`.

Their hashes are frozen in the adjacent `SHA256SUMS` files. Import records
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

The new targets report supplies the missing conceptual algebra around the
first two clauses. For an integral algebra with a nontrivial involution and a
nonzero odd element \(C\), localization at \(C^2\) splits the algebra into
its invariant summand and \(C\) times that summand. Applied to the
sign-twisted \(A_5\)-action on the Clebsch four-space, the first odd
invariant is \(e_3=\sigma_3\). Thus C651's tensor identity is the concrete
finite-field realization of a general statement: forgetting orientation is
generically quadratic and the first recovering observable is cubic.

The general localization proof is complete elementary algebra. The exact
Clebsch specialization still needs C653 to verify the classical
\(A_5\)-invariant-ring citation and characteristic hypotheses before it
becomes manuscript prose. The report's Hitchin--Mathieu statement is a
marked-torsor theorem conditional on four banked identifications; it is not
yet evidence for those identifications. Its continuation-rigidity reduction
and repair-port compiler belong to other owning lanes and are not Paper III
claims.

## Klein cubic disposition

C654 closes the simple period-lattice lift negatively.  The exact rational
carrier has character
\[
 (10,2,-2,0,0,2,-1,-1)
\]
on the eight conjugacy classes and therefore matches Hartlieb's rational
sum of the conjugate degree-five characters.  Its two \(A_5\) commutants
are \(M_2(\mathbf Q)\), their intersection is
\(\mathbf Q(\sqrt{-11})\), and their canonical Reynolds mixed operator has
spectrum
\[
 1,1,\frac1{12},\frac1{12}.
\]
The value \(1/12\) follows structurally from the common CM
\(K\)-bimodule, self-adjointness, and the exact character trace
\(\operatorname{tr}(P_+P_-)=13/6\).  The noncommon discriminant is zero,
not five.  Paper III therefore contains no Klein theorem or speculative
Klein section.

The 55-curve index-two saturation remains outside C579.  It may return only
with an explicit cycle-class or Abel--Jacobi map to the arithmetic
orientation torsor; the bare index-two coincidence is not evidence for the
golden normalization.  The exact result and evidence are in
`notes/2026-07-26-c654-klein-relative-position.md`.

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

The second imported archive is also a valid gzip/tar stream. Its seven
members contain the report, repair-port compiler and tests, Clebsch repair
certificates, and a Hitchin--Mathieu arithmetic script. From a fresh
extraction, all seven repair-port unit tests pass, and the torsor script
reproduces the roots \(4,8\), the order calculation, and the count of two
unmarked equivariant bijections. The script explicitly does not recompute
the four load-bearing inputs: the two \(M_{11}\) embeddings, their
\(\operatorname{PSL}_2(11)\) intersection, Hadamard row--column exchange, or
the identification of reduced Hitchin exchange with \(T_{11}\). Therefore
it sharpens C652's acceptance statement but does not discharge C652.

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

1. **C651 — exact tensor bridge (complete).** Paper II's rank-ten signed
   cubic has been exported, an explicit \(A_5\)-equivariant isomorphism with
   the ten-pair permutation module has been checked on all 60 group
   elements, and full tensor contraction gives \(4\sigma_3\) over
   \(\mathbf F_{11}\). A primary certificate, independent replay, prose
   proof, and Lean terminal are recorded in
   `notes/2026-07-26-c651-hitchin-tensor-bridge.md`. The rational Gaunt
   coefficient cannot be reduced modulo \(11\), because its denominator is
   divisible by \(11\); the cross-characteristic conclusion is equality of
   the integral Clebsch cubic line, not equality of those normalizations.
2. **C652 — arithmetic-cover certificate (complete).** Section 4 proves the
   two golden fibres, unique common cubic, \(A_4\) hinge, order-four
   exchanger, spinor square class, \(T_{11}\) specialization, and marked
   torsor corollary in prose. A compact primary certificate and independent
   replay check the comparison matrices and the explicit Mathieu carriers:
   the two \(M_{11}\) parents, their frozen
   \(\operatorname{PSL}_2(11)\) intersection, \(M_{12}\) join, and Hadamard
   parent exchange. The theorem explicitly asserts no canonical unmarked
   identification. The report and evidence boundary are
   `notes/2026-07-26-c652-arithmetic-cover-certificate.md`.
3. **C653 — integral and novelty gate (complete).** The rational incidence
   extension is the \(5J_0\)-twist and restricts to the golden torsor.  The
   abstract integral quadratic algebra is etale away from \(2,5\) and its
   branch; the classical invariant presentation is justified over
   \(\mathbf Z[1/30]\); and the geometric incidence comparison retains an
   unspecified finite bad set because no consulted source or available
   equation controls its minimal support.  Hitchin pre-empts the
   degree-two-incidence crown and Dye pre-empts the square-\(5\) field
   criterion.  The surviving novelty boundary and source-depth audit are
   in `notes/2026-07-26-c653-hitchin-integral-novelty-gate.md`.
4. **C654 — Klein multiplicity relative position (complete, negative
   disposition).** The exact carrier, polarization, split commutants, CM
   intersection, character fingerprint, and Reynolds invariant are
   certified and independently replayed.  The residual spectrum is the
   scalar \(1/12\), so the discriminant-five lift is removed from Paper III.
5. **C655 — harmonic realization (complete).** The ten icosahedral face
   axes embed in \(\mathcal H_6\), the Clebsch four-space is the Petersen
   \((-2)\)-eigenspace, and two exact implementations prove that the
   spherical cubic restricts to
   \(-784000/1247103\,\sigma_3\). The Gaunt formula gives the explicit
   standard normalization
   \(\int F^3=-130/\sqrt{3553\pi}\,W_6(F)\). The primary-source audit
   confirms the degree-six bond-orientational meaning; materials utility
   remains an untested benchmark. The report and evidence bundle are
   `notes/2026-07-26-c655-clebsch-harmonic-bridge.md` and
   `papers/clebsch-passages/verification/evidence/harmonic_clebsch.*`.
6. **C579 — Paper III synthesis.** After C651--C653, and with C654's
   positive or negative disposition recorded, replace the exploratory
   skeleton with the arithmetic orientation-cover paper, admit only
   consequences of its principal theorem, build a Paper III-specific trust
   surface, and run independent cold review.

## Acceptance boundary

Paper III now has a compilable two-leg manuscript under
`papers/clebsch-passages/`. Its nine included section files separate the
core Hitchin--Clebsch theorem, the certified finite cubic bridge, the exact
arithmetic specialization, and the degree-six harmonic realization.  The
detachable Klein section and its four trust rows have been removed.
The adjacent `WORKPLAN.md` records the dependency graph, and
`verification/trust_manifest.json` is the live ten-claim ledger.

The final target is the strongest coherent theorem complex now supported:
the arithmetic orientation cover together with C655's harmonic
realization of the same integral Clebsch cubic line.  No equality of the
characteristic-zero Gaunt scalar with its mod-\(11\) normalization is
claimed, because the rational Gaunt coefficient has denominator divisible
by \(11\).

Paper III is not release-certified. C579 passes only when the prerequisite
gates support one theorem complex with a complete proof/evidence map, every
load-bearing trust row is closed, and nonconsequential inventory has been
cut.

## Mystery ledger

- **Settled:** Paper III has a credible principal organizer stronger than the
  previous passage catalogue.
- **Settled under C651:** after the explicit intertwiner and pair
  restriction, Paper II's signed cubic is \(4\sigma_3\) over
  \(\mathbf F_{11}\). The characteristic-zero Gaunt scalar has
  \(11\)-divisible denominator, so the common statement across
  characteristics is equality of the integral Clebsch line.
- **Settled under C653:** over the nonmodular base
  \(\mathbf Z[1/30]\), localization at the square of a nonzero odd element
  makes the involutive Clebsch invariant algebra a rank-two algebra over
  its even part, and its first odd generator is
  \(e_3=\sigma_3\).
- **Settled under C652:** the exact arithmetic specialization from the
  golden fibre to \(T_{11}\), the two Mathieu parents and their common
  \(\operatorname{PSL}_2(11)\), and the marked Hitchin--Mathieu torsor.
  There are exactly two unmarked equivariant bijections; no canonical
  unmarked identification is claimed.
- **Bounded under C653:** the abstract quadratic algebra has forced bad
  primes \(2,5\), while the geometric incidence comparison is proved only
  outside an unspecified finite set.  Its minimal bad-prime support
  remains unknown and must not be sharpened in C579 without new integral
  equations.
- **Killed:** there is no \(PSL_2(11)\)- or \(A_5\)-stable elliptic
  subvariety carrying the orientation.
- **Settled under C654:** the exact carrier matches the rational Klein
  character; its commutants meet in \(\mathbf Q(\sqrt{-11})\), and their
  residual Reynolds angle is the scalar \(1/12\), so the simple
  discriminant-five lift is false.
- **Deferred outside C579:** whether Roulleau's index-two 55-curve lattice
  sees the finite torsor; it requires an explicit cycle map before further
  work is justified.
- **Deferred:** theta, Fourier, quantum, Mathieu, and four-sheet holonomy
  comparisons unless C579 derives them from the orientation cover.
