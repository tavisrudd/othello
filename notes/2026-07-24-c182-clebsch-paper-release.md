# C182 Paper I release elevation

**Lane**: `clebsch`

**Status**: substantial local release increment; immutable public deposit remains external.

## Result

Paper I now states and proves the universal chord-defect identity for a
$k$-arc, the sharp moment bound on its defect, and the stronger consequence
that $|\mathcal U(A)|=q+1$ forces $q<\binom{k}{2}$.  The same theorem
subsumes the four separate $k=4,5,6,7$ counts.  The classification is
complete through seven points, and the rederived eight-point moment sieve
leaves exactly $q\in\{13,16,17,19\}$.

The introduction now poses reconstruction and algebraic degeneracy for
projective deep-hole loci as the general problem, and connects the
coset-leader distribution to the Davydov--Marcugini--Pambianco coset-weight
framework.  The unused nearest-conic and one-point-neighbour census,
internal claim-map table, and duplicated small-field table were removed.
The result is a warning-free 19-page manuscript, one page shorter than the
preceding release candidate.

## Verification

- The universal identity and the $k=8$ sieve were independently rederived
  from the two chord moments before entering theorem environments.
- The statement-identity extractor now treats the universal theorem and the
  displayed $q=9$ polarity lemma as the single adopted row-24 claim group.
- The nineteen-row trust manifest validates with fifteen checks.
- The deterministic clean release replay is being refreshed against the
  final source and will be recorded in the live handoff.

## Release blocker

The previously cited GitHub commit is not publicly reachable, Software
Heritage has no archived origin for it, and this workspace has no GitHub or
Zenodo publication credential.  No DOI or SWHID has been invented.  Paper I
must not ship until an immutable deposit is made and its identifier is
inserted in the manuscript.

## Mystery ledger

- **Settled in the explicit extra-juice pass:** the field-size argument
  surprisingly does not use conic structure; the cardinality condition
  $|\mathcal U(A)|=q+1$ alone gives the strict bound.
- **Settled in the Tao-style pass:** the apparent four-case phenomenon is
  one moment identity, and the honest next boundary is the four-field
  eight-point residue rather than an unspecified open range.
- **Open:** whether eight-point conic filling occurs over
  $q\in\{13,16,17,19\}$.  The present paper proves only the sieve; an
  extension-and-rank census or new concurrency argument would be a distinct
  successor, not a release requirement.
- **Open, user-controlled:** immutable public provenance.  The acceptance
  gate is a DOI or SWHID plus a replayable archival artifact.
