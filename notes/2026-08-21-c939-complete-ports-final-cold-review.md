# C939 complete repair ports — final cold review

Date: 2026-08-21

- Frozen commit: `8bbb0f78797dc5eabebf1fd0528656b52b4cfbe7`
- Tracked PDF: `papers/complete-repair-ports/complete_repair_ports.pdf`
- PDF SHA-256: `211e6cdf896270aa7758fc79476ae2fe75f08db483cef8d2fadf732910d1f09a`
- Length: 23 pages
- Verdict: **GO**
- Exact issues: **none**

## Matched-availability theorem and proof

Theorem 6.5 is correct as stated.

- The two displayed five-edge clutters have the common helper-degree multiset
  `(1,1,1,1,2,2,2,2,3)`, matching number two, transversal number two, and
  exactly one minimum transversal each (`{0,8}` and `{1,7}`).
- The edge-subfamily union-size table is correct. Alternating its rows by
  inclusion–exclusion gives exactly
  `5s^3-7s^5-s^6+5s^7-s^9` and
  `5s^3-7s^5-2s^6+8s^7-3s^8`.
- The quotient-plane constructions realize exactly the prescribed collinear
  triples. The generic lift excludes a finite union of proper linear
  conditions, making every helper triple and quadruple independent while
  retaining precisely the five target-containing circuit-hyperplanes.
- Rational choices exist because the excluded set is finite over an infinite
  field. Reduction modulo one prime avoiding the finitely many nonzero
  determinants preserves both representations over the same finite prime
  field.
- The resulting rank-four sparse-paving matroids have five
  circuit-hyperplanes through the target and none away from it, so Lemma 6.3
  gives equal pointed rank-triple multiplicity enumerators.
- Maximum hyperplane-section size four gives `[10,4,6]_q`. Triple independence
  and a target circuit give dual distance four and `mu_x(0)=4`, hence
  `z_x=8`.
- One common asymptotically good `F_(q^4)`-linear outer family therefore gives
  length `10N`, dimension `4K_N`, distance lower bound `6D_N`, and, since
  `3+1<8`, exact radius-three port copies on target classes of density `1/10`.

## Conclusion

The Section 8 conclusion is fixed. It now identifies the structural
`[10,4,6]_q` pair, the matched pointed-perspective and coarse local data, the
higher-order overlap distinction, and the density-`1/10` common-outer transfer
as the central synthesis. The field-seven pair is correctly retained only as
the smaller explicit precursor.

## F29 certificate and replay boundary

Appendix A.2 accurately describes the concrete F29 bundle as an independent
cross-check, not a premise of the generic existence proof.

- `verification/matched-seed.json` has SHA-256
  `16a378edc882a6dda7f5642c7d21bfa49913b45ef5409398de117897b19dd2b8`,
  matching the PDF and release verifier.
- The documented leaf replay
  `python3 verification/matched-seed.py --check verification/matched-seed.json`
  passes.
- Inspection of the replay code confirms that it checks the two `4 x 10`
  matrices over F29, rank four, all three-column ranks, every four-column rank
  by elimination, the same four-column dependencies by the determinant
  formula, the complete circuit-hyperplane lists, exact primal and dual
  distances, pointed rank-triple histograms, degree/matching/transversal/blocker
  data, union profiles, and reliability coefficients.
- The paper's formal-boundary paragraph correctly excludes the quotient-plane
  construction, concrete `[10,4,6]_q` representations, finite clutter
  invariants, and human assembly of Theorem 6.5 from the paired Lean transfer
  declaration. Classical outer-family existence is also explicitly outside
  the Lean closure.

## External README and release entry point

The public paper README matches the PDF's principal theorem, parameters,
invariants, reliability laws, density, and structural construction. It clearly
separates the written seed proof, Lean-supported general components, classical
outer-family input, and finite cross-checks. Its documented `make check` entry
point invokes the release verifier, which is wired to both exact seed replays
and both pinned certificate hashes.

Running `make check` at the frozen commit completed successfully:

`complete-repair-ports release: PASS [paper surface, 23 pages, warning-free]`.

No paper correctness, evidence-boundary, reproducibility, or external-summary
issue remains.
