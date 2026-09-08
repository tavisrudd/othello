# C1131: selective manuscript upgrades

**Lane:** cubic-threefolds. **Date:** 2026-09-08.
**Authorization:** the author accepted C1128’s selective inclusion recommendation and said go.
**Status:** both authoritative paper gates passed; local mirror synchronization pending.

## Result and placement

Paper 1 now leads with the intrinsic scalar proof, separates cyclic persistence
from modified-residue conjugacy, and consolidates the coefficient domains,
independent target variables, completions, derivations and regular inverse maps.
It distinguishes the exponent count from the lattice count. A rational
2+2 block calculation replaces the radical calculation on the main proof path;
the latter is retained as an independent appendix calculation. The lattice
count gives the degree-two obstruction, alongside degrees one and three, and
hence the complete complex Picard-rank-one index-two one-stabilization
classification. The classical rational degree-four and degree-five cases remain
explicitly restricted to the stated field. The spectrum’s cross-degree
separation and the additive method’s ceiling occupy short supporting passages.

Paper 2 explains the selected torus through its unimodular weight simplex,
prints the three-ratio correction and residual character matrices with their
basis convention, and separates geometric existence, tangent-projection
compatibility and arithmetic descent. It moves the dimension count up to the
surface theorem and states what a ground-field executable parametrization still
needs. Exact torus linearization levels form one short corollary; the diagonal
torsion consequence is one paragraph. The family/moduli proposal and optional
rational-polynomial spectrum remain outside the manuscripts.

The primary PDFs grow from 18 to 20 pages and from 17 to 19 pages, respectively.
The abstract monoid and its diagrams no longer precede the scalar proof.
Both original titles and the cubic headline route are retained. All rendered
pages were inspected in contact sheets; the comparison table, rational residue,
Fano table, torus normalization, linearization corollary and rank-four matrices
were also inspected at full page size. No clipping or layout defect was found.

## Evidence and validation

Each paper’s own make check passed, including all source/metadata gates,
exact algebra replays, deterministic PDF build and the unchanged rejection of
TeX warnings. No Lean source was changed and no Lean kernel was run. The primary
paper’s 24 labelled statements have nine absent, seven fragmentary and eight
conditional-deduction records; none is complete. The four added primary claims
are absent. Low-dimensional vanishing is now fragmentary because its existing
terminal covers the exponent count, not the new lattice count. The shared
inventory is 66 claims and 319 reviewer terminals; no coverage upgrade is claimed.

The public universal-residue bundle contains the exact SymPy derivation, exact
output, a separately implemented rational indicial cross-check and output,
replay wrapper, README and hash/byte-count manifest. Replay from Paper 1:

    uv run --with sympy==1.14.0 python verification/check_universal_residue.py

This is supporting verification of the printed finite algebra, not a substitute
for any geometric theorem. The imported matrix normalization and classification
citations are carried over from C1128’s recorded source audit. This integration
makes no new global novelty claim and is not a fresh cold specialist review.

In Paper 2 the slice-cover certificate changes only its schema and three new
residual-action fields. All old certificate values are byte-for-value unchanged.
The rank-four certificate changes only the input hash after the generator began
retaining those fields; all ranks, weights and 1,992 unimodular subsets are
unchanged. Both dependent hash assertions and both checksum manifests were
updated, and the independent checker passed. No acceptance gate was weakened.

Initial checks exposed three TeX layout warnings and the dependent rank-four
input pins. These were repaired before the passing gates. A final whitespace
cleanup is followed by a fresh Paper 2 gate. Build logs are recorded in the
local run-quiet cache; the durable evidence is the committed sources, outputs,
replay commands and hashes.

## ej + tt closeout and Mystery ledger

The explicit closeout pass asked whether the stronger invariant had been
introduced only at the eigenvalue level, and whether any arithmetic conclusion
silently exceeded the field or action hypotheses. The paper now locates the
extra requirement at regular lattice maps and inverses, counts whole primary
summands, permits only common residue shifts, and identifies degree two as the
resonant case. The stronger low-dimensional statement’s formal status is
honestly downgraded to fragmentary. The torus application specifies rational
actions, fixed added variables and the complex finite-subgroup conclusion.
The cheap evidence upgrade is retention and independent checking of the residual
matrices already computed by the generator; it introduces no new search.

- **Settled within this task:** why the quartic double solid differs from the
  exponent count: its discriminant is 1, with distinct canonical representatives
  but coincident exponent classes. The exact universal and indicial checks agree.
- **Settled within this task:** the full-I3 residual cubic algebra is not assumed
  to be the ordinary resolvent of the selected quartic algebra. The two lattice
  actions, rather than an unsupported resolvent identification, determine them.
- **Open review obligation, C978/C956:** independent specialist scrutiny of the
  regular-lattice comparisons and geometric descent; this integration does not
  close the author-retained review tasks or complete their custom protocol.
- **Open operational obligation, C958:** explicit descended forward/inverse maps
  over a specified ground field, including every open condition.
- **Separate follow-on gate:** intrinsic recovery and novelty of the family/moduli
  correspondence stay in C1128’s disposition, outside these papers.

No further mathematical mystery arose from the integration itself. The
incidental-discovery discriminator found no new side observation: the checks
above were explicitly sought as task deliverables, so no discovery entry is
manufactured.

## Workflow exceptions

Several overlarge combined reads were replaced by scoped reads; two failed
patches were atomic, and one JavaScript parsing error executed nothing. Two
simultaneous run-quiet invocations initially shared a command-derived log name;
subsequent gates used distinct full make -C paths. These were command-shaping
errors, not mathematical evidence. The final accepted runs have separate logs.
