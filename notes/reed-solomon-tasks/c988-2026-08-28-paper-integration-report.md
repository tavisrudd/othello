# C988 — paper integration of the strengthened all-characteristic containment

**Lane:** `reed-solomon` · **Date:** 2026-08-28 · **Status:** see §7

## 1. What changed in the manuscript

Theorem 1.1 (`thm:main`) no longer assumes `char F_q > r-1` for its
classification clause.  The hypothesis is now "`p` odd, or `p=2` and
`r>=8`"; the binary cases `r in {6,7}` are the only ones in which the maximal
Lucas carrier enters, and they are already settled for every prime power
`q>=7` by Theorems `thm:r6` and `thm:r7`.

The mechanism is the branchwise reading of the recursive component table,
now printed as two new statements in `sections/07-recursive-carriers.tex`:

- **Lemma `lem:polar-rank-two` (Polar rank containment).**  For `g` of degree
  `n` over any commutative ring, the `(s,t)`-coefficients of the `3x3`
  minors of the first polar's three-row catalecticant generate the ideal of
  `3x3` minors of `g` (`n>=5`), and likewise for `2x2` minors (`n>=3`).  This
  is C536's integral identity `J_n = I_n`, stated uniformly in the degree
  and proved in eight lines by the multilinear expansion of
  `c973-2026-08-28-level-uniform-polar-lemma.md` §5; the rank-one clause is
  the same expansion one size down.  The caveat that the hypothesis must be
  read at geometric parameters (false over `F_2` for rational parameters:
  `e_1+...+e_{n-1}`) is printed after the lemma.
- **Proposition `prop:trapped-row-space` (Trapped row spaces).**  Defines the
  locus `E_{r,p}` (equation `eq:exceptional-locus`): `P_r` for odd `p` or
  `p=2, r>=8`; `P_r ∪ M^max_{r,2}` for `p=2, r in {6,7}`.  If the marker row
  space `L_f` lies in the reduced terminal bad scheme then `[f] in E_{r,p}`.
  Persistent branch: induction on the degree with the lemma (no density of
  split markers used).  Residual branch `p != 2,3`: the projected Veronese
  contains no line, so `L_f` is a point, every `(m-1)`-fold contraction has
  two-row rank one, and the rank-one clause lifts.  Residual branch `p=3`:
  point case as before; ruling case by the printed consecutive-row
  calculation plus the rank-one clause.  Residual branch `p=2`: the plane
  `V(c_0,c_4)` forces `a_0=...=a_m=0=a_4=...=a_{m+4}`, leaving
  `P<e_2,e_3>` at `m=1`, `[e_3]` at `m=2`, nothing at `m>=3`.

Downstream hypotheses changed from "outside `P_r ∪ M^max_{r,p}`" to
"outside `E_{r,p}`": `lem:terminal-selector`,
`thm:simultaneous-marker-escape`, `cor:split-witness-abundance`,
`thm:recursive-carrier` (statement and proof), and the proof of `thm:main`.
`cor:one-column-extensions` and `thm:family-aggregate-nmds` now read "in the
classification range of Theorem `thm:main`".  `prop:upper-radius` and the
fixed-level roadmap no longer say "large characteristic".  Abstract,
introduction, results-at-a-glance table and caption, the proof-route figure,
the status table, and the conclusion were updated to match; the conclusion
now states that threshold sharpness is open and that the R11 finite closures
below the threshold are certificate-closed only.

Two layers of slack are recorded in one paragraph after the proposition:
`M^max_{r,p}` over-approximates the trapped locus for every `(r,p)` outside
the two binary cases, and `P_5 = V(D)` is where the terminal *counting*
argument fails, not where split witnesses fail to exist.

## 2. Gate 1 — persistent-locus check (blocking)

The classification clause of `thm:main` after the carrier step uses: the
four rational strata of `P_r` (curve, split-secant interiors, off-curve
tangent points, conjugate-secant points), the arc property of the normal
rational curve, the Seroussi–Roth–Dür radius gate at `s=0`, Seroussi–Roth's
unique-extension theorem at `s>0`, the Zhang–Wan–Kaipa full-support weights,
and the counts `q(q+1)^2/2` and `(q-1)s(2q+1-s)/2`.  None uses
`p > r-1`.  The only place `p` enters is the `PGL_2` orbit split on the
tangent fibre (`p | r-1`), which `prop:persistent-count-orbits` already states
and which affects orbit decomposition, not the deep set or its count.  The
R6 characteristic-five tangent split recorded in `thm:r6` is that phenomenon.
The proof of `thm:main` now says explicitly that nothing below the carrier
step uses the characteristic.

## 3. Gate 6 — primary sources

Report: `c988-2026-08-28-primary-source-verification.md`.  Seroussi–Roth
Theorem 1 and Corollary 1, Dür Theorem 2.4, and Zhang–Wan–Kaipa Theorems
I.4–I.6 carry no characteristic hypothesis; Seroussi–Roth's sole exception is
even `q` with dual dimension three, cleared by `r>=6`.  Three citation
repairs were applied:

1. `sections/06-high-weight-cosets.tex`: the tangent/conjugate-secant weights
   are ZWK Theorems I.4–I.6, not I.5–I.6 (I.4 covers the tangent at
   infinity).
2. `prop:persistent-count-orbits`: Kaipa 2017 Proposition 1 is the
   syndrome/MDS-extension dictionary and contains no tangent/secant geometry;
   the count citation is now ZWK alone.
3. `prop:upper-radius`: the range `r <= floor(q/2)+2` is Seroussi–Roth
   Corollary 1, not Theorem 1.

`verification/imported-sources.json` records the Theorem 1 / Corollary 1
split, the even-`q` exception, the ZWK dimension range `2<=k<=q-3`, and the
absence of characteristic hypotheses as matched conventions.  Open version
risk: the cached Kaipa 2017 is arXiv v1; the `Sec. IV` / `Prop. 4(1)`
pinpoints are unverified against the IEEE print version.

## 4. Gate 3 — deletion and retention

The manuscript never contained the carrier–nucleus identification, digit
stripping, or the GF(64) trace balance (they live in the C973 notes), so
nothing was demoted.  The R6/R7 binary modular material is retained and is
now load-bearing for the two exceptional cases.  The paragraph after
`thm:recursive-carrier` points to the supplement's R11 finite closures as
companion evidence, not claims.

## 5. Gate 4 — evidence registry

Report: `c988-2026-08-28-r11-evidence-registration.md` (supplement-only
bundles; see that file for paths, hashes, and replay commands).  Nothing in
the manuscript carries an `\evidence` annotation for them, so the
paper-side `verification/evidence.json` registry is unchanged; the
supplement schema, reproduction guide, bundle manifest, and
`verification-map.md` carry the new rows.

## 6. Gates 5 and 7 — maps, builds, reviews

- `verification/check_annotations.py --update` regenerated
  `verification/claim-map.json` for 52 labels (two new); `LINKS` wires
  `prop:trapped-row-space` into `thm:main`, `thm:simultaneous-marker-escape`,
  and `thm:recursive-carrier`, with `lem:polar-rank-two` and the
  stable-component certificate as its inputs.
- `supplement/LEAN-STATEMENTS.md` has rows for both new labels ("no direct
  declaration"); `supplement/verify.py` expects 52 labels.
- `theorem-map.md`, `claim-proof-novelty-ledger.md` (new rows `TRS`,
  `R11-FIN`; `UC` reworded), and `formalization-ledger.md` updated.
- Abstract is exactly 200 words (gate maximum).
- `make check`: canonical PDF 46 pages, warning-free.  `make tit-check`:
  33 single-column pages, warning-free.  No unresolved references.
- Cold read: `c988-2026-08-28-cold-read.md` (see §7).

## 7. Cold read and repairs

`c988-2026-08-28-cold-read.md` (finite-geometry/coding referee persona)
found the lemma and proposition sound by hand and raised four items, all
applied:

1. "The projected Veronese surface contains no line" was asserted, not
   proved.  Now: the residual surface is the projection of the Veronese
   surface from the rank-three tensor `v·v − u·w`, hence isomorphic to it,
   and Veronese images of curves have even degree.  The `p=3` "point or
   ruling" step now names the base curve `(s^4:s^3t:st^3:t^4)`.
2. `thm:recursive-carrier` cited the semilinear orbit law unconditionally;
   it now cites the count and, when `p ∤ r-1`, the orbit law.
3. The abstract sentence "the Lucas carrier traps nothing above the
   threshold" contradicted the binary exceptions; reworded.
4. Overclaim: `thm:r6`/`thm:r7` are full-support results, so for `p=2`,
   `r in {6,7}`, `s>0` only the containment is proved.  Abstract, Theorem 1.1
   commentary, results map, carrier-theorem remark, and conclusion now say
   "for full support" and state the open point-deleted carrier arithmetic.

Also applied: the forward reference to the composite-contraction display
was replaced by the defining adjunction inline; `J_n` is defined in the
lemma proof; "over an infinite field" became "over an algebraically closed
field"; the coinage "Lucas line" was removed; a sentence records that the
binary exclusion is a phenomenon (the trapped points are deep when `q=2^m`,
`m` odd), not a limitation of the method.  Pre-existing coinages the reader
flagged ("wild cone", "consecutive Fano identity") are outside this task's
edit and are left for the export/referee pass.

## 8. Status

Complete.  Final gates: `check_annotations` (52 labels), abstract 198/200
words, canonical PDF 47 pages and TIT PDF 33 pages both warning-free,
`supplement/verify.py` green with the refreshed local release manifest.
Not done here, by design: standalone export and math-papers
synchronization (needs `notes/export-and-mirror-conventions.md` and its own
task), and the certificate-free GF(27) switch lemma.

Mystery ledger: the only new unexplained feature is the sharpness of
`Q^*_{r,s}`; the four R11 fields below it are certificate-closed only, and no
field above it is known to fail.  No genuine mystery blocks closure.
