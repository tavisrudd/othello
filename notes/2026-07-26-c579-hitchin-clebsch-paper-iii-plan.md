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

## Klein cubic elevation target

The intermediate-Jacobian kill test rules out the naive
two-dimensional invariant abelian subvariety. The correct object is the
two-dimensional multiplicity Hodge structure
\[
 U_H=\operatorname{Hom}_{A_5}
   \bigl(W_5,H^1(J(X),\mathbf Q)\bigr)
\]
in the decomposition
\[
 H^1(J(X),\mathbf Q)|_{A_5}\simeq W_5\otimes U_H.
\]
Roulleau proves \(J(X)\cong E^5\) as an unpolarized complex abelian
variety, with \(E\) carrying CM by \(\mathbf Q(\sqrt{-11})\). Hartlieb's
character tables and one-dimensional \(A_5\)-special family verify the
five-space multiplicity mechanism. The source audit and corrections to the
imported note are in
`notes/2026-07-26-klein-cubic-multiplicity-hodge-carrier.md`.

C654 will compute the two embedded \(A_5\)-commutant algebras and their
relative position. The intended golden invariant must be canonical under
basis and isogeny change and compatible with the polarization. Arbitrary
rank-one idempotents in \(M_2(\mathbf Q)\) do not meet this requirement.
A positive discriminant-five invariant could elevate the Klein lift into a
second principal clause of Paper III. A negative stops the simple
period-lattice lift without weakening the already established arithmetic
Hitchin--Clebsch cover.

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
2. **C652 — arithmetic-cover certificate.** Check the two golden fibres,
   \(I_4=A_-\), \(I_8=A_+\), the comparison matrices, the order-four
   exchanger, the \(A_4\) intersection, the spinor square class, and the
   \(T_{11}\) specialization. Also certify the two \(M_{11}\) parents,
   their \(\operatorname{PSL}_2(11)\) intersection, and the compatibility
   of Hadamard row--column exchange with the reduced Hitchin exchange before
   using the marked-torsor corollary. Package exact scripts, canonical
   output, hashes, and an independent implementation.
3. **C653 — integral and novelty gate.** Audit rational forms of the
   Mukai--Umemura incidence cover, Dye, binary-sextic invariant theory, and
   finite-field reductions. Prove the largest justified integral base and
   exact bad-prime boundary obtainable from available equations, or retain
   the spread-out finite-set formulation.
4. **C654 — Klein multiplicity relative position.** Build the exact rational
   ten-dimensional Klein representation and its polarization, embed the two
   \(A_5\) parents, certify their \(M_2(\mathbf Q)\) commutants and
   \(\mathbf Q(\sqrt{-11})\) intersection, define a canonical mixed
   invariant, and test whether its discriminant is \(5\). Treat the
   55-curve lattice as a second-stage integral route, not as assumed
   evidence.
5. **C655 — harmonic realization.** Certify the exact embedding of the ten
   icosahedral face axes in \(\mathcal H_6\), identify the Clebsch
   four-space as the Petersen \((-2)\)-eigenspace, and independently verify
   that the standard Gaunt cubic restricts to
   \(-784000/1247103\,\sigma_3\). Audit the physical order-parameter
   normalization against primary sources and state materials utility only
   as an untested benchmark.
6. **C579 — Paper III synthesis.** After C651--C653, and with C654's
   positive or negative disposition recorded, replace the exploratory
   skeleton with the arithmetic orientation-cover paper, admit only
   consequences of its principal theorem, build a Paper III-specific trust
   surface, and run independent cold review.

## Acceptance boundary

Paper III now has a compilable strong-form manuscript scaffold under
`papers/clebsch-passages/`. Its nine section files separate the core
Hitchin--Clebsch theorem, the certified finite cubic bridge, the exact
arithmetic specialization, the degree-six harmonic realization, and the
Klein multiplicity elevation. The
adjacent `WORKPLAN.md` records the dependency graph, and
`verification/trust_manifest.json` is the initial fourteen-claim trust ledger.
The structural checker deliberately reports a non-release surface while
C652--C655 remain open.

The final target is the strongest coherent theorem complex: a positive
C654 result is to be integrated as a second structural theorem, a positive
55-curve saturation test as its integral geometric realization, and C655's
harmonic identity as the bridge to an established physical order parameter.
The modular source layout is risk control during the calculation, not a
decision to publish the weaker core first.

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
- **Conceptually settled, citation-gated under C653:** localization at the
  square of a nonzero odd element makes any involutive integral algebra a
  rank-two invariant algebra, and the Clebsch chart's first odd generator is
  the cubic \(e_3=\sigma_3\).
- **Open under C652:** an independently replayed exact arithmetic
  specialization from the golden fibre to \(T_{11}\), together with the
  carrier-level identifications needed for the marked Hitchin--Mathieu
  torsor.
- **Open under C653:** the minimal bad-prime set and prior-art status of the
  \(5\)-twist and finite-field incidence interpretation.
- **Killed:** there is no \(PSL_2(11)\)- or \(A_5\)-stable elliptic
  subvariety carrying the orientation.
- **Open under C654:** whether the intrinsic relative position of the two
  \(A_5\) multiplicity structures has discriminant \(5\), and whether
  Roulleau's index-two 55-curve lattice sees the same finite torsor.
- **Deferred:** theta, Fourier, quantum, Mathieu, and four-sheet holonomy
  comparisons unless C579 derives them from the orientation cover.
