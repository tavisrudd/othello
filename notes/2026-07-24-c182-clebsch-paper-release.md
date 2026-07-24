# C182 Paper I release elevation

**Lane**: `clebsch`

**Status**: substantial local release increment; immutable public deposit remains external.

## Result

Paper I now states and proves the universal chord-defect identity for a
$k$-arc, the sharp moment bound on its defect, and the stronger consequence
that $|\mathcal U(A)|=q+1$ forces both an explicit quadratic field-size
barrier and $q<\binom{k}{2}$.  The quadratic gives the sharp sieve bounds
$q\le5,11,15,22$ at $k=4,6,7,8$.  A passant count supplies the complementary
bound $q\ge2k-3$.  Hirschfeld's nucleus characterization shows more
generally that in even order a $(q+1)$-point uncovered locus cannot itself
be an arc, so conic filling is impossible.  The theorem and its
corollary subsume the four separate
$k=4,5,6,7$ counts.  The classification is complete through seven points,
and the rederived eight-point sieve leaves exactly
$q\in\{13,17,19\}$.

The introduction now poses reconstruction and algebraic degeneracy for
projective deep-hole loci as the general problem, and connects the
coset-leader distribution to the Davydov--Marcugini--Pambianco coset-weight
framework.  The unused nearest-conic and one-point-neighbour census,
internal claim-map table, and duplicated small-field table were removed.
The engine now appears in Section 2, its $k=6,q=11$ specialization is
worked there, and the later uncovered-locus proof delegates to it.  The
result is a warning-free 18-page manuscript, two pages shorter than the
preceding release candidate.

A final dependency audit makes Dye's $c(A)=10$ input explicitly
Clebsch-specific, restores the subgroup-overgroup subtraction underlying the
$A_5$ orbit table, and routes the conic identification through that orbit
proposition.  The $K_2$ identification again immediately follows the
displayed hexagon it names.

The closing copy-edit records $t(A)=0$ for $k\le5$, removes the unused
nearest-conic column and perturbation-checker reference, and states the exact
secant-covering reformulation of conic filling.

The final referee pass makes that reformulation logically exact by recording
$A\cap\mathcal Q(\mathbb F_q)=\varnothing$, moves projective equivariance to
the point where the degenerate-conic branch uses it, and aligns the named
rows of the mathematical and executable dependency tables.  It also records
that four, rather than one, non-Clebsch classes have least vanishing degree
four.  Finally, Dye's construction is available over $\mathbb F_9$ because
$5=-1$ is a square there and the characteristic is three; the family
formula then recovers completeness at $q=9$, independently of the
Sylvester-graph exclusion of conic filling.  The other root $q=5$ lies in
the exceptional characteristic and is not an instance of the paper's
associated-conic construction.

## Verification

- The universal identity and the $k=8$ sieve were independently rederived
  from the two chord moments before entering theorem environments.
- The statement-identity extractor now treats the universal theorem and the
  displayed $q=9$ polarity lemma as the single adopted row-24 claim group.
- The nineteen-row trust manifest validates with fifteen checks.
- The deterministic clean release replay passes all fifteen checks against
  the final source; its refreshed output certificate and trust-manifest hash
  are committed with the paper.

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
  one moment identity.  Comparing its forced defect with the universal
  defect ceiling yields the stronger quadratic barrier, which explains all
  four small-$k$ upper bounds at once; counting passants through a vertex
  supplies the matching lower window.  The nucleus proof in fact excludes
  any even-order $(q+1)$-point uncovered locus that is itself an arc, not
  only conics.
- **Open:** characterize equality or near-equality in the universal defect
  ceiling.  The proof shows that extremality constrains chord multiplicities
  to the largest possible concurrence, but turning that into geometry is a
  distinct successor problem.
- **Open:** whether eight-point conic filling occurs over
  $q\in\{13,17,19\}$.  The present paper proves only the sieve; an
  extension-and-rank census or new concurrency argument would be a distinct
  successor, not a release requirement.
- **Open, user-controlled:** immutable public provenance.  The acceptance
  gate is a DOI or SWHID plus a replayable archival artifact.
