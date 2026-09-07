# Draft verification

Run from the paper directory:

```
nix develop .#manuscript --command make check
nix develop .#manuscript --command make pdf
```

The paper is an unnumbered research companion; every statement's formal coverage
is `absent`. No Lean command or terminal is used. This small source checker
implements the absent-coverage portion of the annotation conventions; it is not
a kernel-proof or public-release gate. `dependency_graph.py` records authored
statement edges and proof edges, with imports/evidence distinguished. The main
bibliographic source registry carries read depths, pinpoints and convention
boundaries; the canonical novelty authority remains the explicitly linked N1–N9
ledger in the C1102 literature audit, not a duplicated paper ledger.

`check.py` checks ten statement digests, annotation/claim agreement, unique proof
identities, citations and references, dependency-graph freshness, all registered
input hashes, the approved citation exception, and exact rational arithmetic.
`finite_check.py --check` independently re-expands the normal forms from the
matrix input, verifies signed moments and Schur ranks, repeats all 19608
projective p=7 Hessian ranks, and tests the translation family at seven primes.
Its certificate is generated with `--write`; it is not hand-edited. Python
standard library only, deterministic exact arithmetic, no random seed. A complete
small-prime enumeration does not certify the unrun p=11 census or global code
classification. The translation-family statement has a proof in the manuscript.

`input-hashes.json` pins the 104 existing files actually inventoried under the
four task-owned bundles and the key citation/shadow reports. The source scripts
and outputs remain at their monorepo paths. It does not inventory original
copyrighted paper PDFs or opaque serialized intermediates: scan/PDF hashes live
in the literature register; shadow intermediates are regenerated in the recorded
order. `local-hashes.json` pins the new finite checker and certificate.
Full replay commands and limits are in `evidence.json` and the source reports.
Some historical scripts retain obsolete scratch-directory search-path additions;
run from the documented bundle directory so sibling imports resolve there.
No standalone export is claimed; resolve/copy all dependencies before release.

The original p=7 census had two implementations. The new draft check gives a
fresh third traversal, deriving its tensor directly from the matrix rather than
reading the stored tensor. The factory's original independent checks compare
primal enumeration with MacWilliams and synthesis kernels with Fourier sums.
The p=11 census and fixed-space distance negative do not have independent full
second implementations. Their trust boundaries are explicit in the manuscript.

After any statement change, review its mathematics and claim row, then run
`python3 verification/refresh_claim_digests.py semantic-label ...`.
Regenerate the dependency graph separately. Never use digest refresh to hide an
unreviewed discrepancy. The draft checker rejects statement drift, missing
annotation identifiers, citation failures and source-hash changes. Negative
checks are recorded in the dated drafting report.
