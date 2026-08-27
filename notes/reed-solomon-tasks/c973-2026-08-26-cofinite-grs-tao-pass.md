# C973 checkpoint — Tao pass on cofinite GRS transfer

**Lane:** `reed-solomon` · **Date:** 2026-08-26 · **Status:** structural
upgrade proved; MDS/NMDS novelty audit remains open

## What the first framing missed

The cofinite-GRS theorem was initially phrased as a classification of the
last two coset-leader shells.  The more invariant object is the single-element
extension of the parity-check matroid.

Let `H_S` be an `r x n` parity-check matrix of the redundancy-`r` GRS code on
`S`, and append a nonzero syndrome column `f`.  For
`C_hat_f=ker[H_S|f]`, the circuit definition of minimum distance gives, for
an arbitrary parity-check matrix `H`,

\[
d(\ker[H\mid f])=
\min\left\{d(\ker H),\ 1+\min_{f\in\langle H_T\rangle}|T|\right\}.
\]

The GRS arc property and the redundancy bound reduce this to the exact
identity

\[
                         d(\widehat C_f)=d_S(f)+1.
\]

The specialization proof is one line: every old circuit has size at least
`r+1`, while a smallest new circuit consists of `f` and a smallest retained-
column set spanning it.

This changes the interpretation of every C973 shell:

| syndrome weight | appended code | geometry in the proved large-characteristic range |
|---|---|---|
| `r` | MDS | omitted NRC point |
| `r-1` | NMDS | tangent, conjugate secant, or split-secant interior incident with an omitted point |
| at most `r-2` | Singleton defect at least two | outside the persistent/Lucas carrier, with an explicit locator certificate |

The NMDS assertion includes the dual condition.  If `r-1` retained columns
span `f`, NRC independence makes their span a hyperplane containing the
appended column.  Its annihilating functional gives a dual word of weight
`n+1-r`; every augmented dual word retains an old dual GRS part of weight at
least `n-r+1`.  Thus the dual distance is exactly `n+1-r`, and these are not
merely AMDS codes.

## Why this is higher EV

1. It unifies the PRS, affine-RS, cofinite-GRS, deep-hole, and MDS-extension
   statements in one dictionary rather than presenting affine RS as an
   application.
2. It upgrades the count in the transfer report to exact counts of MDS and
   NMDS projective extension columns (not stabilizer-orbit counts).
3. It makes the small-characteristic Lucas dimension formula an explicit
   bound on exceptional NMDS extensions.
4. It gives the software result enum a code-theoretic meaning independent of
   the phrase `deep hole`.

The paper can obtain this value without a new section: insert the identity
after the syndrome/MDS dictionary, then state `MDS / NMDS / defect >=2` in the
existing arbitrary-redundancy theorem.

## Literature boundary checked

Targeted primary-source searches recovered:

* Kaipa, *Deep holes and MDS extensions of Reed--Solomon codes*,
  arXiv:1612.05447, for the deep-hole/MDS one-digit equivalence;
* Bartoli--Davydov--Marcugini--Pambianco, *On Almost Complete Subsets of a
  Conic ...*, arXiv:1609.05657, for NRC completeness and RS extendability;
* Wang--Chen--Yan, *MDS and NMDS Codes from the Extended Twisted Generalized
  Reed--Solomon Codes*, arXiv:2605.23329, for a recent three-column twisted-
  GRS extension construction; and
* Li--Sun--Zhu, *A family of linear codes that are either non-GRS MDS codes
  or NMDS codes*, arXiv:2401.04360, for an adjacent constructed family and
  its weight distributions.

No search result stated the arbitrary-redundancy classification of all NMDS
one-column extensions of a cofinite ordinary GRS parity-check system.  This is
only a scoped negative search, not an absence result.  Before headline use,
the paper successor must audit `almost MDS`, `near MDS`, `single-element
extension`, and `NRC defect-one extension` terminology through the citation
graphs of those papers.

## Next theorem exposed

For an NMDS extension `C_hat_f`, its number of minimum-weight words is

\[
 (q-1)\#\{T\subset S:|T|=r-1,\ f\in\langle\nu(T)\rangle\}.
\]

Known NMDS weight-enumerator formulas can then propagate this leading count
to the rest of the enumerator.  The exact support count is not supplied by
the present shell theorem: Seroussi--Roth proves existence, while the C973
quantitative locator theorem applies outside the carrier.  Computing this
support count separately on tangent, conjugate-secant, and incident-split-
secant families is therefore the sharp next mathematical gate if the paper
wants a full NMDS enumerator rather than only an extension classification.

## Defects caught by the pass

1. `AMDS` would be an unnecessarily weak claim; the dual defect calculation
   proves `NMDS`.
2. Projective column counts, vector-column counts, and inequivalent-code
   counts are different.  C973 proves projective extension-column counts;
   scalar multiples rescale the new coordinate.  It does not yet quotient by
   the stabilizer of the retained support.
3. The cofinite-support construction fixes redundancy.  It must not be
   described as literal puncturing of a fixed-dimension PRS code.
4. The exact NMDS minimum-word count and orbit quotient remain open and must
   not be inferred from the shell count.

## `tt` verdict for paper integration

Use the circuit identity as a one-paragraph dictionary, not as a claimed new
theorem.  Promote the exact defect-one locus and its count to the theorem
headline: that is where C973 adds content beyond the classical deep-hole/MDS
equivalence.  Replace, rather than supplement, the separate affine-RS
application prose with the three-way `MDS / NMDS / defect at least two`
statement.  Do not spend paper space on the full NMDS weight enumerator unless
the family-wise support count is first proved and its prior art audited.

## Mystery ledger

| mystery | status | next gate |
|---|---|---|
| Are next-to-deep syndromes exactly defect-one extensions? | settled by the circuit identity | none |
| Are the extensions AMDS or NMDS? | settled: dual defect is also one | none |
| Is the NMDS extension classification already in the literature? | scoped searches found adjacent but not matching work | claim-specific citation-graph audit |
| Does the projective shell count equal an orbit count? | no; this was a potential category error | compute the support stabilizer action only if orbit enumeration is paper-relevant |
| Can the full NMDS weight enumerator be recovered cheaply? | reduced to the exact number of `(r-1)`-supports spanning each rank-two family | separate arithmetic support-count theorem |

The pass leaves one genuine mathematical mystery: the family-wise
`(r-1)`-support count.  Everything else above is a structural consequence of
the proved shell theorem.
