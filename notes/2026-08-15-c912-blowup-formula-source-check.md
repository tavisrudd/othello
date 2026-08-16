# C912 — the blowup formula, read at the source

**Date:** 2026-08-15
**Lane:** `cubic-threefolds`
**Task:** C912 (literature verification; no manuscript edit)
**Follows:** `2026-08-15-c912-step-iii-surface-induction.md`, Section 3 and its
step 1

The surface induction left exactly one unverified point: whether Iritani's
blowup formula holds in the *decorated* form the induction uses — atoms
transferring with their structure — or only at the level of multiplicity
sequences, which is all the computational literature checks. The paper is in the
lane's cache and has now been read. The decorated form is what Iritani proves,
and it is stronger than what the induction needs.

## Verdict

**Verified, at the level of the connection itself.** Iritani's decomposition is
an isomorphism of quantum D-modules that commutes with the quantum connection,
intertwines the Poincaré pairings, and — in the F-manifold corollary — preserves
the Euler vector fields. Formal monodromy, and therefore the primitive-sixth
count, is transported summand by summand. The multiplicity-sequence reading that
the computational literature verifies is a shadow of this, not the statement.

Ledger item C912-M34 is resolved. The surface induction now rests on two
imported statements rather than three, and the remaining two are the ones the
memo's shorter endpoint route already relies on.

## 1. What the source says

Iritani, *Quantum cohomology of blowups*, arXiv:2307.13555. Cached copy:
key `arXiv:2307.13555`, fetched 2026-08-10, 69 pages, PDF SHA-256
`c16f56b283863322df04dadaeb0780889abd67a664f56a74fea39bc7ba8a934b`;
`litcache.py verify` reports no problems across the manifest. Read: the
introduction's Section 1.1 (Theorem 1.1, Corollary 1.2, Remarks 1.3–1.5), the
statement of Theorem 5.18 with its seven properties, the connection formulas
(5.41)–(5.43) preceding it, and the paragraph of Section 5.8 on initial
conditions. Not read: the proof.

The setup is a smooth projective variety `X`, a smooth closed subvariety `Z` of
codimension `r`, and the blowup along `Z`. The Novikov rings of the three spaces
are embedded in a common ring `C((q^{-1/s}))[[Q]]` by the extension (1.1), where
`q` is the class of a line in the exceptional divisor.

**Theorem 1.1 / Theorem 5.18.** There are a formal invertible change of variables
and an isomorphism of modules over `C[z]((q^{-1/s}))[[Q, tau~]]`

```
Psi : QDM(blowup) -> tau* QDM(X)  +  sum_{j=0}^{r-2} sigma_j* QDM(Z)
```

with, among the seven listed properties:

1. `Psi` commutes with the quantum connection;
2. `Psi` intertwines the pairing of the blowup with the pairing of `X` plus
   `r-1` copies of the pairing of `Z`;
3. the two components are homogeneous, of degrees `0` and `-r`.

**Corollary 1.2.** The change of variables is an isomorphism of quantum
cohomology F-manifolds, and *it also preserves the Euler vector fields*.

## 2. Why this is exactly what the induction needed

The connection Iritani transports is the one this lane counts with. His
`nabla_{z d_z} = z d_z - z^{-1}(E_X star) + mu_X` is the memo's own
`z d_z Y = (z^{-1}U - mu)Y` up to sign convention, and the pulled-back summands
in (5.42) and (5.43) carry `E_X star` with `mu_X` and `E_Z star` with `mu_Z`
respectively. Since `Psi` commutes with the connection, the formal type of the
blowup's connection at a parameter is the direct sum of the formal type of `X`
at the corresponding parameter and `r-1` copies of that of `Z`. Formal monodromy
is a property of the formal type, so its eigenvalues are the union, with
multiplicity, of those of the summands. That is the decorated statement.

Two further points make it fit the induction rather than merely resemble it.

**The Euler field is preserved.** Atoms are defined by the spectrum of quantum
multiplication by the Euler vector field, so preservation of that field is what
makes the summands unions of atoms rather than an arbitrary regrouping.
Iritani's Figure 5 discussion makes the separation explicit near the origin:
the eigenvalues of `E_X star` are all zero there while those of the `Z` summands
sit at `-(r-1)lambda_j` with `(-lambda_j)^{r-1} = -q`, so the summands occupy
distinct eigenvalues and cannot mix.

**The base point moves, and the induction is stated to tolerate it.** The
summands appear as *pullbacks* along the change of variables, so the blowup at a
parameter decomposes into `X` and `Z` at different parameters. The inductive
statement is quantified over all parameters of the formal base, which is also how
the count is used everywhere else in this lane, so the shift is harmless. It
would not be harmless for a statement pinned to one base point.

**Specialization.** The isomorphism lives over the extended ring with fractional
powers of `q` and is formal, not analytic — Remark 1.5 says the decomposition is
not expected to be analytic in all variables. The primitive-sixth count is a
formal invariant, established earlier in this task, so nothing is lost.

## 3. For the surface case specifically

Applying the theorem with `Z` a point and `r = 2` gives one copy of the quantum
D-module of a point, which is rank one with trivial connection, hence a rank-one
atom with trivial formal monodromy. That is precisely the blow-down step of the
induction, and it comes from the general theorem with no surface-specific input
needed.

Iritani additionally records that Gyenge and Szabó studied the asymptotics of the
Euler eigenvalues associated with blowdowns to the minimal models of projective
surfaces — that is, the exact configuration the induction runs through. Their
paper has not been read here and is no longer needed as an import; it is
corroboration. This corrects the previous report's characterization of it, which
followed Böhning–von Bothmer–Su'a's phrase "previously verified in the surface
case" rather than the primary source's own description.

## 4. An unexpected dividend for the referee-foundation tranche

Section 5.8 states that the decomposition and its change of variables can be
uniquely reconstructed from initial conditions along the origin together with
genus-zero Gromov–Witten invariants of `X` and `Z`, and credits the idea to
Katzarkov–Kontsevich–Pantev–Yu and to Hinault–Yu–Zhang–Zhang.

That bears on ledger item C912-M16, which recorded that Hinault–Yu–Zhang–Zhang's
blowup theorem is asserted rather than derived, with existence referred to
earlier decomposition work. The earlier decomposition work is this paper, and the
existence statement is Theorem 5.18, now read at the source. Whether Iritani's
statement matches theirs clause for clause has not been checked — the settings
differ, his being quantum D-modules and theirs framed F-bundles — so this is a
located citation rather than a discharged item.

## Mystery ledger updates

| ID | Status | Discovery | Owner |
|---|---|---|---|
| C912-M34 | resolved | Iritani's blowup formula is an isomorphism of quantum D-modules commuting with the quantum connection, intertwining the pairings and preserving the Euler vector fields (Theorem 1.1, Theorem 5.18 properties (1)–(3), Corollary 1.2), so formal monodromy transports summand by summand. The decorated form the surface induction uses is verified at the source, and the induction now rests on two imports rather than three. | Sections 1–2 here |
| C912-M16 | confirmed (locator added) | The "earlier decomposition work" that Hinault–Yu–Zhang–Zhang refer to for existence is Iritani's Theorem 5.18, with uniqueness from initial conditions in his Section 5.8. Clause-by-clause agreement between the two statements is unchecked; the settings differ. | Section 4 here |

## Replay

No computation. The claims are quotations from a cached source; the exact
reading list, cache key and hash are in Section 1, and the cache manifest
verifies clean.
