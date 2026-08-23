# The b3=0 tail cannot close through Hochschild parity — the A2 category carries the danger profile — but the toric slice closes by openness of semisimplicity, and the general tail reduces to converse Hertling--Manin--Teleman

**Lane:** `cubic-threefolds` · **Task:** C925 · **Date:** 2026-08-23

Attempts the candidate closure raised at the end of the toric-sweep session:
"can a rank-two Serre-trace-one component live on a threefold with
\(HH_{\mathrm{odd}}=0\)?"  The answer is **yes, abundantly**, which kills
that route; the analysis nevertheless produces one unconditional positive
result and one clean reduction.

## 1. Negative: the danger profile is the \(A_2\) quiver category

The category \(D^b(kA_2)\) (representations of the \(A_2\) quiver; \(kA_2\)
= upper-triangular \(2\times2\) matrices) has exactly the profile the tail
would need to forbid:

* Hochschild homology of dimension two concentrated in degree zero —
  verified from the normalized bar complex, \(HH_\bullet=(2,0,0,0)\) in
  degrees \(0,1,2,3\) (hereditary kills the rest);
* numerical \(K_0\) of rank two with Euler Gram
  \(\bigl(\begin{smallmatrix}1&1\\0&1\end{smallmatrix}\bigr)\), whose
  pairing-determined monodromy \(T=G^{-T}G\) has trace one, satisfies
  \(T^3=-1\) (it is the shift acting as \(-1\): \(D^b(A_2)\) is fractional
  Calabi--Yau of dimension \(1/3\), \(S^3=[1]\)), order six, eigenvalues
  \(e^{\pm\pi i/3}\) — **the marked class**;
* the Bernardara--Macrì--Mehrotra--Stellari Gram of \(\mathcal Ku(Y_3)\),
  \(\bigl(\begin{smallmatrix}-1&-1\\0&-1\end{smallmatrix}\bigr)\), is the
  negative of the \(A_2\) Gram and produces the **literally identical**
  \(T\).  The marker is blind to the difference between the cubic's
  fractional CY-\(5/3\) component (with \(HH_{\pm1}=5\)) and the CY-\(1/3\)
  quiver category (with no odd Hochschild homology at all).

And the profile embeds admissibly into \(b_3=0\) geometry everywhere: an
exceptional pair with a one-dimensional total Hom generates an admissible
copy of \(D^b(A_2)\), e.g. \((\mathcal O,\mathcal O(E))\) for a
\((-1)\)-curve \(E\) on a del Pezzo surface \(S\)
(\(\chi(\mathcal O,\mathcal O(E))=1\) with the Hom in degree zero), pulled
back to the threefold \(S\times\mathbf P^1\), which has \(b_3=0\).

**Conclusion.**  No argument from Hochschild parity, numerical \(K_0\), or
the Serre trace alone can exclude marked spectral data on a \(b_3=0\)
carrier.  "Cubic spectral data need cubic odd cohomology" is *false at the
level of abstract components*; whatever truth it has must be quantum — about
which components actually arise as eigenvalue blocks of the carrier's own
quantum connection.  Certificate:
`notes/cubic-threefolds-tasks/c925-fable-a2-profile-check.py` (sha256
`ef22be5beac27253c323f58a31223605968f8eee2e45e3cf012fef51fa74b9ea`), output
`c925-fable-a2-profile-check-output.txt` (sha256
`1c2533ec7a46e9ac0066ca76f115336cb8752a66f72dbf423c0c9171f6e9bd39`); replay
`uv run --with sympy python3 notes/cubic-threefolds-tasks/c925-fable-a2-profile-check.py`.

## 2. Positive: the toric slice of the tail is closed, not vacuously

The toric sweep (`2026-08-23-c925-fable-toric-b3zero-levelt-sweep.md`)
proved more than "no blocks at the canonical point": it proved the small
quantum algebra is **étale** there for every smooth toric Fano threefold.
That upgrades the sweep's own "confirmatory but vacuous" assessment to a
closure of the toric slice:

**Proposition.**  Let \(V\) be a smooth toric Fano threefold appearing as a
carrier.  Then the ledger of \(V\)'s quantum connection over the coefficient
field of any Iritani bulk curve based at the small locus contains no
nontrivial Jordan block — in particular no marked block or triple.

*Proof.*  Étale-ness of a finite algebra is detected by its trace-form
discriminant, a polynomial in the structure constants.  The sweep certifies
the discriminant is nonzero at the canonical point; the accumulated bulk
curve is a formal arc whose special fibre is (a cocharacter rescaling of)
that point, so the discriminant is a unit in the arc's complete local
coefficient ring, hence nonzero in its fraction field.  An algebra with unit
discriminant over a field is étale, so \(E\star\) is semisimple over the
coefficient field: the ledger is a sum of simple sheets.  \(\square\)

The same argument closes the tail over **any** carrier whose small quantum
algebra is étale at the relevant base point — the hypothesis is one exact
discriminant evaluation per carrier, exactly what the sweep computes.

## 3. The general tail reduces to converse Hertling--Manin--Teleman

Hertling--Manin--Teleman is the implication "generically semisimple even
quantum cohomology \(\Rightarrow\) Hodge--Tate (in particular
\(b_3=0\))".  The tail needs a statement in the opposite direction, and §2
shows the precise form required:

> **(GS-carrier).**  For every smooth projective threefold \(V\) with
> \(b_1=b_3=0\) arising as a telescope carrier, the even quantum algebra of
> \(V\) is semisimple at (equivalently, near) the base point of the
> accumulated Iritani curve.

Given (GS-carrier), the Hensel argument of §2 runs verbatim and the tail is
empty; combined with the proved odd-cohomology persistence (Levelt report
§6e) the two halves mesh into the intended dichotomy — on every carrier,
either \(b_3\ne0\) and the marked triple persists, or \(b_3=0\) and no
marked block can be in the ledger at all.  Three remarks on status:

* (GS-carrier) is strictly weaker than generic semisimplicity of big quantum
  cohomology (Dubrovin-conjecture territory: every \(b_3=0\) Fano threefold
  has a full exceptional collection), but it is a pointwise, checkable
  statement: one discriminant per carrier.
* It is genuinely necessary to anchor at a semisimple **point**: generic
  semisimplicity alone would not forbid the accumulated curve lying inside
  the non-semisimple locus.  Openness from a point on the curve is what the
  Hensel argument uses.
* The sweep discharges it for all smooth toric Fano threefolds.  The
  non-toric \(b_3=0\) carriers reachable by the telescope are the remaining
  obligation; for Fano ones the classification is short (in Picard rank one
  just \(\mathbf P^3\), the quadric, \(V_5\), \(V_{22}\), all with known
  semisimple small quantum cohomology in the literature) and the same
  étale-at-a-point check applies variety by variety.  Non-Fano carriers
  remain the open boundary of the statement.

## 4. Lead for a structural (non-pointwise) closure: the marker as an irregular Hodge number

The Katzarkov--Kontsevich--Pantev-style expectation, in the form studied by
Sabbah and Yu, attaches to the quantum connection an irregular Hodge
filtration whose spectrum is determined by the Hodge numbers of the
underlying variety.  A regular-singular block of exponents
\(\pm1/6\) is Airy-type spectral data (the \(A_2\) degenerate critical
point: the classical Airy connection has formal exponents \(\pm1/6\)), and
the natural conjecture is that its fractional contribution to the irregular
Hodge spectrum is possible only when fed by off-diagonal Hodge classes —
which a Hodge--Tate carrier lacks.  If that held, the tail would close
structurally rather than carrier-by-carrier.  This is a lead, not a result:
nothing here verifies the required compatibility between block exponents
and the irregular Hodge spectrum.  Logged for a successor allocation.

## Mystery ledger (EJ+TT closeout, 2026-08-23)

| status | feature | evidence or remaining gate |
| --- | --- | --- |
| settled (negative) | Hochschild parity cannot close the tail: \(D^b(A_2)\) has the exact danger profile and embeds admissibly in \(b_3=0\) threefolds. | §1, certificate script. |
| settled | The marker is numerically blind to \(\mathcal Ku(Y_3)\) vs \(D^b(A_2)\); exclusion arguments must be quantum, not categorical-numerical. | §1, the two \(T\)'s are equal. |
| settled | Toric slice of the \(b_3=0\) tail closed unconditionally (étale at a point + Hensel). | §2, using the sweep's étale verdict. |
| open, reduced | The full tail is now the pointwise statement (GS-carrier): even quantum semisimplicity at the accumulated base point of each non-toric \(b_3=0\) carrier. | §3.  Fano cases finite and literature-supported; non-Fano carriers open. |
| open (lead) | Marker as an irregular Hodge number; would close the tail structurally. | §4, no verification yet. |

No manufactured mysteries: the two open rows are the whole remaining tail.
