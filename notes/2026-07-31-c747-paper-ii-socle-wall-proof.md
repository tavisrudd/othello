# C747 — Paper II socle and first-wall proof

**Lane:** clebsch

**Date:** 2026-07-31

**Status:** proof integrated; independent cold-read gate pending

## Outcome

The quadratic pullback obstruction is now a theorem rather than a
composition-factor heuristic. The proof has four structural pieces.

1. A \(p'\)-matching stabilizer supplies an actual nontrivial simple
   submodule of the self-dual sheet permutation module. Frobenius
   reciprocity first gives a simple quotient; the permutation pairing and
   self-duality give the required submodule. This handles the formerly
   hidden possibility that the principal projective cover is present.
2. The Lucas equations solve the finite-group root intertwining equations
   themselves. They give the exact affine-socle Hom space and its
   one-dimensional occurrence criterion
   \[
   e(p-1)/2\equiv1+s/2\pmod2.
   \]
3. The determinant-normalized four-factor calculation shows that
   \(\operatorname{Hom}_G(S^\square,\operatorname{Sym}^2F)=0\) for one
   actual outer extension. At the first Frobenius wall, the nonsquare
   diagonal sign and the dual-Weyl flip sign reverse together, so the
   finite-group wall rows have the same parity as the ordinary Lucas rows.
4. If the corresponding linear moment is nonzero, its cocycle
   \(z_i(g)(t)=i(t)c(g)\) is nontrivial. A retracted occurrence contracts
   functorially to
   \[
   (\dim S)[c]+i_*\rho_*[c].
   \]
   A nonretracted occurrence contracts to the two first-wall coordinates
   of \((1-z)^{p-2-s}\). The unique correction coefficient would have to
   satisfy both \((p-2-s)x=1\) and \(x=0\).

The same argument supplies a structural characteristic-three endpoint.
For a cyclic torus take \(L(2)\); with the Weyl involution take
\(L(2,2)\). Their zero-weight lines are fixed, while the zeroth affine
digit is \(0\), so neither simple occurs in \(F\). The forbidden square
parity therefore has zero linear moment and immediately contradicts the
sheet-sign kernel. This includes \(q=9\) and removes the former exhaustive
matching census from the proof.

## Red-team repairs

The hostile pass rejected two shortcuts.

- A first draft used a retraction \(E\to S\). Such a map need not exist,
  and it fails on the affine top factor. The corrected contraction uses
  only \(S\hookrightarrow F\twoheadrightarrow S\). It detects lower
  Fischer summands by \(\dim S\) and the top summand by \(\dim S+1\).
- The ordinary Lucas degree bound is insufficient for
  \(\operatorname{Sym}^2F\), whose root polynomial crosses \(q\). The
  corrected parity proof isolates the only possible factor \(t^q-t\) and
  checks the compensating dual-Weyl flip. Thus the \(G\)-Hom vanishing is
  an actual finite-group statement.
- The first integrated draft applied the first-wall conclusion before
  distinguishing one-digit from multi-digit test modules.  The corrected
  proof applies nonsplitting only to \(L(s)\).  Every multi-digit module in
  the exceptional table has an odd digit and is absent from the affine
  socle, except \(L(2,2)\); its unique Lucas sign word is alternating, so it
  is absent as well.

The first-wall row is now identified rather than named. Its zeroth-digit
map is
\[
v_m\longmapsto\sum_{j=0}^{r}(-1)^j\binom rj\,
v_j\otimes w_{r-j+m},\qquad r=p-2-s,
\]
and the first digit is the unique bracket
\(L(0)\to L(1)\otimes L(1)\). The digit equations force this row both at
the trace and at the \(Y\otimes R\) spill, proving uniqueness.

## Literature used

Three primary sources were read partially; no novelty or priority negative
is made.

- Robert Steinberg, *Representations of Algebraic Groups*, Nagoya Math. J.
  22 (1963), 33–56. **Read depth: partial** — Theorems 1.1 and 7.4.
  Cache key 10.1017/S0027763000011016, SHA-256
  3e8e8f596ffdf0dae5a1592d6c31c04f833ccefe606d7e995341ad0033f8f7b9.
- Eoghan J. McDowell and Mark Wildon, *Modular plethystic isomorphisms for
  two-dimensional linear groups*, J. Algebra 602 (2022), 441–483.
  **Read depth: partial** — pp. 1–4 and Corollary 1.5.
  Cache key arXiv:2105.00538, SHA-256
  8e9012cea77b2eca5aecf03238fd0565155a6941c89c98c422533d94aa94a890.
- Samuel Martin, *On certain tilting modules for \(\mathrm{SL}_2\)*,
  J. Algebra 506 (2018), 397–408. **Read depth: partial** — Lemma 2.3
  and its displayed dual-Weyl sequence. Cache key arXiv:1705.06980,
  SHA-256
  235d7b2f26ca808c6ddfad8d738b744aca23a06a623b3f27108a3c85dbc5f1f2.

Giudici's maximal-subgroup input retains the read-depth record in the C577
audit.

## Validation

- Statement identity and metadata gate: 28 statements and 13 evidence
  bundles, green.
- Full authoritative aggregate: green, including all certificate replays,
  the existing Lean axiom allowlist, the 36-page PDF rebuild, and the
  manuscript warning scan.
- PDF pages 6--10, containing the Lucas, contraction, first-wall, stabilizer,
  and exceptional-head arguments, were visually inspected after the clean
  build; no layout defect was found.
- Standalone synchronization and gate: pending the authoritative result.
- Independent modular and context-free cold reads: pending; C748 owns them.
- Two deliberately separated internal hostile reads have been completed.
  They are useful red-team evidence but are not recorded as the independent
  C748 verdicts.

## Mystery ledger

| feature | status | exact remaining gate |
|---|---|---|
| principal-projective escape | settled | a nontrivial simple quotient dualizes to a submodule directly |
| ordinary trace contraction | settled and corrected | use \(S\hookrightarrow F\twoheadrightarrow S\), not \(E\twoheadrightarrow S\) |
| first-wall scalar and spill | settled | the linear and constant coefficients of \((1-z)^{p-2-s}\) |
| actual outer-parity Hom vanishing | settled in the manuscript proof | C748 modular cold read |
| one-digit/multi-digit obstruction split | settled | nonsplitting for \(L(s)\); Lucas absence for every multi-digit test module |
| \(q=9\) finite census | removed from the proof | retained only as corroboration |
| formal closure | open by task order | C750 after C748–C749 freeze the human proof |

## Vibe check

Good but not yet frozen. The proof now exposes one functorial contraction
and one unavoidable adjacent-wall correction; the remaining risk is a
reader finding that the compact Lucas/outer-parity paragraph suppresses a
finite-group identification.
