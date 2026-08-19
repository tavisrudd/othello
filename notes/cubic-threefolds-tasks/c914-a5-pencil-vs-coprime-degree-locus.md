# C914 — The `A_5`-pencil against the known universally `CH_0`-trivial loci

**Lane:** `cubic-threefolds`

**Status:** active; both comparisons decided, manuscript restatement open

**Objective:** locate the nonstandard `A_5`-invariant cubic pencil relative to
the loci of smooth cubic threefolds already known to be universally
`CH_0`-trivial, and feed the verdict into the epilogue's introduction.

## Answered

The pencil contains the Fermat cubic threefold. `W_5` is the induced
representation `Ind_{A_4}^{A_5}(omega)` of a nontrivial cubic character, which
is monomial with cube-root entries, so the Fermat form is invariant. Report
and replay: `../2026-08-14-c914-a5-pencil-vs-known-loci.md`; script
`../2026-08-14-c914-a5-pencil-fermat-membership.py`.

Consequences already landed in the manuscript: the pencil is not the first
positive-dimensional family, and the Fermat member's universal
`CH_0`-triviality has three earlier proofs (Voisin 2017 Theorem 4.5,
Colliot-Thélène 2017, Yang--Yu--Zhu 2025 Remark 3.6).

The Eckardt-point separator hypothesis is refuted; see the report.

## Answered, 2026-08-18

The generic member does **not** lie in the Yang--Yu--Zhu locus: every member of
their normal form has an Eckardt point, and all but finitely many members of
the pencil have none. Verified in two independent models of the pencil, with
the Fermat cubic threefold as a control returning its thirty Eckardt points.

Voisin's criterion is not met by any elliptic-product route. With the exotic
two-primary gluing kernel that the epilogue's packet proposition assigns to
this family, every odd-degree isogeny onto `J(X_b)` from a product of
principally polarized factors has exactly the shape `1 + 4`; a splitting into
five elliptic curves is impossible because every `F_4`-line of the coefficient
heart is its own perpendicular for the discriminant pairing. The `1 + 4`
factorization itself exists, with odd index `25`.

**Correction, 2026-08-19, from C921.** The four-dimensional factor of that
`1 + 4` splitting is of symplectic type `(1,1,1,5)`, not principally polarized;
its six principal polarizations correspond to the six order-five subgroups of
`E_b[5]`. The report's rank-eight elementary divisors `(3,3,3,3,3,3,15,15)` are
those of a lattice glued only at two, since that is what its script builds. The
verdicts are unaffected and strengthened — they need odd divisors, and the
three-primary glue removes the threes. The manuscript's `prop:no-elliptic-product`
is correct as written and needs no repair. See
`../2026-08-19-c921-integral-glued-model.md`.

Report and replay: `../2026-08-18-c914-a5-pencil-vs-voisin-and-yyz.md`; scripts
`../2026-08-18-c914-a5-pencil-eckardt.py` and
`../2026-08-18-c914-a5-pencil-voisin-locus.py` with their tracked outputs.

## Applied, 2026-08-19

The restatement is in the epilogue: the Eckardt criterion and the two finiteness
propositions, the computation-free order-three route printed after them,
`prop:no-elliptic-product` with its polarization-free last conclusion, the
introduction sentences, the evidence-registry entry and the claim-map rows.
Four cold reads drove the repairs. Round four found no mathematical error and
verified the two load-bearing citations against the sources; its precision and
consistency findings are applied, including the signature normalization
restricted to cube roots of unity, the multiset form of the Klein-cubic
exclusion, the finiteness argument run in `B^\circ` rather than in moduli, and
the split of the module-level decomposition from the polarization hypothesis.
Reports: `../2026-08-18-c914-manuscript-cold-read.md` for rounds one to three,
`../2026-08-19-c914-round-four-mathematics.md` and
`../2026-08-19-c914-round-four-consistency.md`.

## Open

- [ ] González-Aguilera and Liendo, *Automorphisms of prime order of smooth
  cubic n-folds*, Arch. Math. 97 (2011) 25--37, arXiv:1002.4136v2, is now cited
  for two load-bearing facts and is not in the shared literature cache at
  `/tmp/persistent/tavis/lit-search/`. Add it.
- [ ] C921 owns the residual Voisin gate: whether the four-dimensional factor
  `A_b` is the Jacobian of an irreducible genus-four curve, or `J(X_b)` is
  odd-degree isogenous to an irreducible genus-five Jacobian.
