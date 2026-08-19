# C914 — adversarial cold read of the manuscript change

**Lane:** `cubic-threefolds` · **Date:** 2026-08-18 · **Reviewer:** independent cold read of the
uncommitted C914 edit to `papers/cubic-stabilization-epilogue/`

## Verdict

The mathematics is sound. I checked both new proofs line by line and could not break either: the
Eckardt rank-at-most-two criterion is correct in characteristic zero, its two family consequences
are correct (and the manuscript's two-case split of the separated-variable argument repairs a real
gap in the task report's one-line version), the Yang--Yu--Zhu computation matches the actual
normal form of their Theorem 3.3, and every step of the two-adic argument in
`prop:no-elliptic-product` — surjectivity of the first-coordinate projection, the two intersections
with the first coordinate subspace, forced `omega`-stability of each summand, self-perpendicularity
of every `F_4`-line, the rank-at-least-four discriminant bound, and the one-plus-four realization at
an axis — holds up. I also replayed the evidence bundle independently and reproduced
`verification/a5-pencil-eckardt.txt` byte for byte, and the annotation gate passes. What is wrong is
in the *framing*: three places state the residual Voisin question as if the proposition had only one
open branch when its own statement has two, the introduction converts "not projectively equivalent
to a member of Yang--Yu--Zhu's explicit family" into "outside the coprime-degree locus", the
bridging sentence in Section 3 promises a shared mechanism that the neighbouring proposition does
not use, and the paragraph immediately after that neighbouring proposition still denies the result
that now sits above it. Those four are the ones I would fix before committing; the rest is small.

## Defects

### 1. The residual Voisin question is stated with one branch when the proposition has two

`sections/02-envelope.tex`, after the proof:

> "Entering Voisin's construction therefore requires the four-dimensional factor to be the Jacobian
> of an irreducible curve of genus four.  Whether it is remains open, so this pencil is not known to
> lie in one of those components."

`sections/01-introduction.tex`:

> "We do not claim that the \(A_5\)-curve is disjoint from her locus, which would need the
> four-dimensional factor of Proposition~\ref{prop:no-elliptic-product} not to be a curve Jacobian."

`claim-proof-novelty-ledger.md`:

> "Whether the pencil lies in one of her components is open and reduces to whether the
> four-dimensional factor is the Jacobian of an irreducible genus-four curve"

The proposition's own conclusion is "either \(k=1\), or \(k=2\) and the two factors have dimensions
one and four."  The `k=1` branch is not excluded — it is trivially inhabited by `mu = id`, `nu = 1` —
and it is a live route into Voisin's construction, because the claim she actually proves (proof of
Theorem 4.5, arXiv:1407.7261) is about an odd-degree isogeny `mu : J(C) -> J(X)` with
`mu^* theta_X = m theta_C` for `C` a **possibly** reducible curve. For `k=1` that means `J` is
odd-degree isogenous to the Jacobian of an irreducible genus-five curve, and nothing here rules that
out. The C914 task report gets this right in section 3.3, where it lists both branches; the
manuscript dropped the second one in all three places.

Fix: in all three, say that the pencil enters her locus if and only if either the four-dimensional
factor is a genus-four Jacobian or `J` is odd-degree isogenous to the Jacobian of an irreducible
genus-five curve. Copy the two bullets from the report verbatim.

### 2. The introduction upgrades "not a member of their family" to "outside the coprime-degree locus"

`sections/01-introduction.tex`:

> "Proposition~\ref{prop:A5-not-coprime} places all but finitely many moduli points of that pencil
> outside the coprime-degree locus of \cite{YYZ} as well"

and `claim-proof-novelty-ledger.md`:

> "all but finitely many of its moduli points lie outside the Yang--Yu--Zhu locus"

The proposition proves something narrower and says so correctly: only finitely many points of
`M_{H_1}` are represented by cubics *projectively equivalent to a member of the family of
[YYZ, Theorem 3.3]*. Two gaps between that and "the coprime-degree locus". First, Yang--Yu--Zhu's
own Question 1.3 asks whether there is a smooth cubic threefold isomorphic to none of theirs that
admits coprime-degree unirational parametrizations — so "the coprime-degree locus" is not known to
be their family. Second, their family gives a two-dimensional subvariety of moduli, and the
argument says nothing about its closure. `claims.json` is scoped correctly ("projectively
equivalent to a member of that family"); only the introduction and the ledger overreach.

Fix: write "outside the explicit family of \cite[Theorem~3.3]{YYZ}" in both, and let the sentence
about it being a separate mechanism carry the rest.

### 3. "Both run through one classical criterion" is false, and half of the new lemma is unused

`sections/03-minimal-class.tex`, the bridging paragraph:

> "Two comparisons place the pencil against the parts of the algebraic locus that were known before.
> Both run through one classical criterion."

The comparison against the separated-variable locus is `prop:A5-nonseparated`, whose proof runs
through order-three automorphism signatures and Gonzalez-Aguilera--Liendo's Theorem 2.5, not through
`lem:eckardt-rank`. It does not cite the new lemma at all. As a consequence the lemma's
separated-variable clause — a full paragraph of proof, the partition analysis and the two-singleton
case — is stated, proved, and then used by nothing in the manuscript. The task report saw this and
said so: it calls the clause a "free corollary, not used above" and notes it would reprove
`prop:A5-nonseparated` "in three lines, replacing the current argument", while recording that the
manuscript was not changed.

Fix: pick one. Either replace `prop:A5-nonseparated`'s proof with the three-line Eckardt argument,
which makes the bridging sentence true and removes the dependence on Gonzalez-Aguilera--Liendo, or
delete the separated-variable clause from the lemma and reword the bridging sentence to promise only
what the coprime-degree comparison delivers. The first is the better paper.

### 4. The paragraph after `prop:A5-nonseparated` now contradicts the proposition above it

`sections/03-minimal-class.tex`, unchanged by this edit:

> "Proposition~\ref{prop:A5-nonseparated} excludes only the separated-variable mechanism of
> \cite{CT}.  It does not assert that the \(A_5\)-curve is generically disjoint from the
> coprime-degree family of \cite{YYZ} or from every other known part of Voisin's
> algebraic-minimal-class locus."

The twin sentence in the introduction was replaced by this change; this one was not. It now sits
three lines below `prop:A5-not-coprime`, which asserts exactly the coprime-degree half it disclaims.
A reader hitting this paragraph will assume the new proposition was retracted.

Fix: rewrite as a pointer — that proposition excludes the separated-variable mechanism,
`prop:A5-not-coprime` the coprime-degree family, and `prop:no-elliptic-product` the product route
into Voisin's components, with the genus-four and genus-five questions left open.

### 5. "Eckardt point" is used five times and never defined

`sections/03-minimal-class.tex`, in the proof of `prop:A5-not-coprime`:

> "By Lemma~\ref{lem:eckardt-rank} those points are exactly the Eckardt points"

`lem:eckardt-rank` is titled "Eckardt criterion" but its statement only says "the tangent hyperplane
section \(T_pX\cap X\) is a cone with vertex \(p\)". The term "Eckardt point" then appears in the
introduction, in the bridging paragraph ("empty Eckardt scheme"), in that proof sentence, and
throughout `evidence.json`, with no definition anywhere in the manuscript.

Fix: name it in the lemma statement — "is a cone with vertex \(p\) (that is, \(p\) is an *Eckardt
point* of \(X\))" — and the proof sentence becomes a restatement rather than an appeal.

### 6. The Fermat control is not a member of the rational-model pencil

`sections/03-minimal-class.tex`:

> "while the Fermat member of the pencil returns its thirty Eckardt points in both."

`verification/evidence.json`:

> "the Fermat cubic threefold, which lies in the pencil, returns its thirty Eckardt points in both
> models"

In the monomial model the Fermat form is genuinely the `(1,0)` member of the pencil. In the rational
model it is not: the run's line is a control on `x1^3+...+x5^3` under the heading
"--- controls: Fermat and two Yang-Yu-Zhu members", and the rational-model pencil's own `(1,0)`
member is the Segre cubic. The script's docstring and the task report both say the monomial model
"contains the Fermat member explicitly", which the rational model does not. The Fermat member of the
rational-model pencil sits at a parameter that was never tested.

Fix: "the Fermat cubic threefold, which is a member of the pencil and appears explicitly in the
monomial model, returns thirty Eckardt points as a control in both rings." Same correction in
`evidence.json`.

(The number itself checks out independently: for `F = sum x_i^3` the Hessian is `diag(6x_i)`, rank at
most two forces at most two nonzero coordinates, and a point of `X` cannot have exactly one, so the
Eckardt scheme is the 10 coordinate pairs times 3 cube-root ratios = 30 reduced points, matching the
run's `eckardt-cone-degree 30`.)

### 7. A false sentence in the proof of `prop:no-elliptic-product` (harmless downstream)

`sections/02-envelope.tex`:

> "The image \(L'=\mu_*\bigl(\bigoplus_iH_1(A_i,\mathbf Z)\bigr)\) has odd index in \(L\) and is the
> orthogonal direct sum of the sub-Hodge structures \(L\cap(U_i\otimes M_{\mathbf Q})\), each
> carrying \(\nu\) times a unimodular alternating form."

`L'` is the direct sum of the `mu_*H_1(A_i,Z)`, each of which can sit strictly inside
`L cap (U_i tensor M_Q)`; the two agree only up to a divisor of `[L:L']`. Likewise it is the
`mu_*H_1(A_i,Z)` that carry `nu` times a unimodular form, not the saturations. The proof survives
untouched, because everything after this uses only the localization at two, where the index is odd
and the distinction disappears — but as written the sentence is false.

Fix: "…has odd index in the orthogonal direct sum of the sub-Hodge structures
\(L\cap(U_i\otimes M_{\mathbf Q})\); each summand of \(L'\) carries \(\nu\) times a unimodular
alternating form."

### 8. The evidence bundle does not certify what its registry entry says it certifies

`verification/evidence.json`, the `a5-pencil-eckardt` role:

> "verifying in each that the invariant cubics form a pencil"

That verification happens in Python — `dim of the invariant cubics: 2`,
`monomial-model invariant directions: 2`, `each monomial-model invariant is fixed by all of A_5: True`,
`T_1 is A_5-invariant and not S_6-invariant: True` — and goes to stdout. The registered artifact
`a5-pencil-eckardt.txt` contains only the Singular output, and the checksum manifest covers only
that file and the script. So the claim that both models really give the pencil is not in the
certificate.

Fix: have the script write its own stdout into the registered `.txt` (or a second hashed file), and
give it a `--check` mode that re-derives and compares, as `hirzebruch_euler_spectrum.py` already
does. The second replay command also needs a redirect if the `.txt` is to be compared rather than
eyeballed.

I did replay the bundle: `verification/a5_pencil_eckardt.py --sing` emits a Singular input
byte-identical to the one from `notes/2026-08-18-c914-a5-pencil-eckardt.py`, Singular 4.4.1 from
`nixpkgs#singular` reproduces `verification/a5-pencil-eckardt.txt` exactly, and both entries in
`a5-pencil-eckardt.sha256` verify. The bundle is sound; only its description overreaches.

### 9. The relative elliptic scheme is used where its geometric generic fibre is meant

`sections/02-envelope.tex`, four times in the new proposition and proof:

> "put \(M=H_1(\mathcal E,\mathbf Z)\)" … "At the geometric generic point \(\mathcal E\) has no
> complex multiplication" … "an elliptic curve isogenous to \(\mathcal E\)" … "\(J\sim\mathcal E^5\)"

`lem:relative-six-axis` introduces `\mathcal E` as an elliptic *scheme* over `B^\circ`; the paper's
fibre notation is `E` or `E_b`. `H_1` of a scheme over a curve is not a defined object, and "at the
geometric generic point `\mathcal E` has no complex multiplication" is really a statement about
`E` at that point — which is how the preceding non-CM paragraph phrases it.

Fix: introduce `E` for the geometric generic fibre of `\mathcal E` in the first line of the proof and
use it throughout.

### 10. `M_{H_1}` is used before the section defines it

`sections/03-minimal-class.tex`, `prop:A5-not-coprime` at line 494 uses `M_{H_1}`; the section's own
definition is the opening line of `prop:A5-nonseparated` at line 515: "Let \(M_{H_1}\) be the
coarse-moduli image of the nonstandard \(A_5\)-invariant cubic pencil." It is glossed once in the
introduction ("Its coarse-moduli image is Hartlieb's \(M_{H_1}\)"), so it is not strictly undefined,
but a "Let … be" that follows its own first use in the section reads as an editing accident.

Fix: move the definition into the bridging paragraph before both propositions.

### 11. Referential break: "its" in the paragraph after the new block

`sections/02-envelope.tex`:

> "Hartlieb proves that the closure of its intermediate-Jacobian image is a one-dimensional special
> subvariety"

Before this edit "its" already reached back past a paragraph; the new proposition, its proof, and the
van Geemen--Yamauchi discussion now put roughly 120 lines between the pronoun and any candidate
antecedent, and the nearest noun phrases are "the four-dimensional factor" and "this pencil".

Fix: either move the whole new block to after this paragraph — it reads better there anyway, since
that paragraph closes the description of the pencil — or write "the pencil's intermediate-Jacobian
image".

### 12. Two coordinate conventions inside one proof of `lem:eckardt-rank`

`sections/03-minimal-class.tex`:

> "For the family of \cite[Theorem~3.3]{YYZ} take \(p=[1:0:0:0:0]\).  It lies on the threefold, the
> tangent hyperplane there is \(\{x_3=0\}\), and the restriction of the equation to that hyperplane
> does not involve \(x_1\)"

The proof's first paragraph fixes coordinates `x_0,...,x_4` with `p=[1:0:0:0:0]`; this paragraph
silently switches to Yang--Yu--Zhu's `x_1,...,x_5`, where `p` is the point with `x_1 = 1`. Read in
the lemma's own labels, `{x_3 = 0}` is the wrong hyperplane and "does not involve `x_1`" is trivially
false for a cone with vertex `[1:0:0:0:0]`.

The computation is right in their coordinates — I checked it against the source. Their Theorem 3.3
is `F' = t1 x1^2 x3 + t2 x2^3 + t3 x1 x3^2 + t4 x4^2 x5 + t5 x4 x5^2 + t6 x1 x2 x3 + t7 x2 x4 x5`
with `t1,...,t5` nonzero; at `p` all partials vanish except `dF'/dx3 = t1`, and the restriction to
`{x3 = 0}` is `t2 x2^3 + t4 x4^2 x5 + t5 x4 x5^2 + t7 x2 x4 x5`, free of `x1`.

Fix: "in the coordinates of \cite[Theorem~3.3]{YYZ}, take \(p\) to be the point where their first
variable is one", and note that their `t_1` is nonzero by hypothesis.

### 13. All new dependency edges are recorded as conceptual, not logical

All three new statements carry `\uses` in the statement body only, so
`verification/dependency-graph.dot` records `lem:eckardt-rank -> prop:A5-not-coprime` and the three
inputs of `prop:no-elliptic-product` as dashed. Per `notes/formal-annotation-conventions.md` and
`dependency_graph.py`, a dependency recorded in a statement body is conceptual and one recorded at
the end of the proof is logical (solid). Every one of these is used inside the proof: the exotic
kernel from `prop:principal-gluing-packet`, the polarization identification from
`lem:relative-six-axis`, the Gram matrix from `prop:six-axis-polarization`, and the criterion from
`lem:eckardt-rank`. Separately, `prop:A5-not-coprime`'s proof invokes `thm:separation-family` for
`B^\circ`, which is recorded nowhere.

Fix: add proof-level `\uses` before each `\end{proof}` and regenerate the graph. The gate cannot
catch this — it passed.

### 14. The new ledger row makes an absence claim with no recorded search

`claim-proof-novelty-ledger.md`, the "No elliptic-product route" row:

> "No source stating the obstruction was located"

The ledger's "Current audit boundary" section was not extended by this change, and the C914 task
report records no literature search for the obstruction — its section 5 lists computational
negatives only. Under `notes/literature-audit-conventions.md` an absence claim needs its searched
domain and stop condition on the record.

Fix: either run and record a bounded search (the natural queries are odd-degree isogeny plus
principally polarized product decomposition, and `A_5`-invariant cubic threefold intermediate
Jacobian), or drop the sentence and let the van Geemen--Yamauchi comparison stand alone.

### 15. Smaller proof-level gaps

- `sections/02-envelope.tex`: "Shrinking each summand by an odd index makes the two forms \(\nu\)
  times a unimodular one for a single odd \(\nu\)." The reason is one line and should be there: an
  alternating form with elementary divisors `d_1 | ... | d_g`, all odd, becomes `d_g` times a
  unimodular form on the sublattice spanned by `(d_g/d_i) e_i` and `f_i`, of odd index
  `prod (d_g/d_i)`; take the larger `d_g` of the two summands. The task report has the concrete
  numbers — divisors `(3,3,3,3,3,3,15,15)` and index 25.
- `sections/02-envelope.tex`: "so the summands have \(\F_4\)-dimensions \(2\) and \(0\), or \(1\) and
  \(1\)" presumes exactly two summands. For `k >= 3` the right statement is that at most two are
  nonzero. The conclusion is unaffected, since the heart-carrying summand has `dim U_i >= 4` and the
  dimensions sum to five.
- `sections/03-minimal-class.tex`: "By the computation quoted above it is not everything, hence it is
  finite" uses without saying it that `B^\circ` is a connected curve, so that a proper closed subset
  is finite; and the passage from a finite set of parameters to finitely many points of `M_{H_1}`
  uses that `M_{H_1}` is the image of `B^\circ`. Both are one clause each.
- `sections/02-envelope.tex`: "\eqref{eq:six-axis-polarization-pullback} identifies
  \(L/(\Lambda\otimes M)\) with \(\ker f\)" — that equation is the polarization pullback; the kernel
  identification is the general fact about an isogeny. Cite the lemma, not the display.
- `sections/02-envelope.tex`: the hypotheses "isogeny of odd degree" and "for an odd \(\nu\)" are
  equivalent, since `deg mu = nu^5` for a five-dimensional target with principally polarized factors.
  Say so in a parenthesis or drop one.
- `verification/evidence.json`: "Cone dimension zero certifies that the member is smooth with empty
  Eckardt scheme." Two cones are reported and they certify different things — the Jacobian cone gives
  smoothness, the Eckardt cone gives emptiness. The run's own `mono(0,1)` row has
  `jacobian-cone-dim 1` with `eckardt-cone-dim 0`, so the sentence as written is contradicted by the
  artifact it describes.

## Taste, not defects

- `\nu` for the polarization multiplier collides with `\nu_6`, the paper's headline invariant, and
  with the block index `I_\nu` in `prop:A5-nonseparated` three pages later. `m` or `\lambda` would be
  cleaner. Likewise `b` now names the trace-determinant pairing, the pencil parameter (`X_b`, `F_b`,
  `B^\circ`) and a coordinate in `ca^3 + c'b^3 = 0`; and `J` (intermediate Jacobian) sits next to
  `J_6` (all-ones matrix) inside one formula. All survivable in context; `\nu` and the `ca^3+c'b^3`
  coordinate are the two I would rename.
- "Read the display above twice." reads as an instruction to the reader rather than mathematics, and
  it is ambiguous about which two readings are meant. "Apply the display in two ways:" with a colon
  would do the same work.
- The `L tensor Z_2` display ends with a full stop and is followed by lowercase "where". Comma, or
  start a new sentence.
- `sections/01-introduction.tex` wraps mid-clause — "although it is isogenous to the fifth power of /
  an elliptic curve; her / construction of components therefore" — and one source line in
  `02-envelope.tex` runs to 95 columns where the file's habit is about 76.
- The introduction's proof map was not updated: Section 2's entry does not mention the
  no-elliptic-product proposition and Section 3's still says only "generically outside the
  separated-variable locus".
- `verification/evidence.json`: the widened `note` now says "minimal rational ruled surface" while
  the `hirzebruch-euler-spectrum` entry's own `role` still says "Hirzebruch surface" twice. Harmless,
  but the widening is unrelated to C914 and the file is now internally inconsistent.
- `H^1` is the paper's habit elsewhere; the new proof works in `H_1` throughout. Equivalent here,
  since `W_5` is self-dual, but the switch is unremarked.

## Verified correct — no findings

- **`lem:eckardt-rank`, the criterion itself.** I re-derived it. With `p = [1:0:0:0:0]` and
  `F = x_0^2 L + x_0 Q + C`, the tangent hyperplane is `{L = 0}`, the section is `x_0 Q + C`
  restricted, and it is a cone with vertex `p` exactly when `Q` lies in `(L)`. The symmetric matrix
  of `4 x_0 L + 2 Q` is exactly the Hessian of `F` at `p`. The forward direction and the
  factorization converse are both right, including the degenerate branch where neither linear factor
  involves `x_0`, which forces `L = 0` against smoothness.
- **The separated-variable clause.** The partition analysis is correct: every partition of five into
  parts of size at most three either has a part of size two, or is `3+1+1` or `1^5` with at least two
  singletons. The two-case split matters — the task report's one-line version claims a point
  supported on a part of size at most two always exists, which is false when that part is a
  singleton, and the manuscript fixes it.
- **The whole two-adic argument of `prop:no-elliptic-product`,** step by step. Also checked: the
  discriminant group of `6I_5 - J_5` is `(Z/6)^4`, so the two-primary heart is four-dimensional over
  `F_2` and two-dimensional over `F_4`; an `F_4`-line is totally isotropic for the trace-determinant
  form and equals its own perpendicular, so two orthogonal lines coincide and cannot be
  complementary; `kappa(v,v) = 5` is a two-adic unit, so an axis splits off unimodularly and the heart
  lands entirely in its perpendicular. The realization at `k = 2` and the exclusion of every other
  product shape both hold.
- **The Voisin citation.** Her Theorem 4.5 proof does assume an odd-degree isogeny
  `mu : J(C) -> J(X)` with `mu^* theta_X = m theta_C`, `m` odd, `C` possibly reducible, and her
  explicit example is the `3 + 2` shape that the new proposition excludes. The framing paragraph
  describes her construction accurately. My only complaint is the missing `k = 1` branch, above.
- **`claims.json`.** All three rows describe their statements accurately and their `cautions` are
  appropriately blunt. The `prop:no-elliptic-product` row is *more* careful than the introduction: it
  lists "an odd multiple of the product polarization" as a hypothesis, which the introduction's
  sentence omits.
- **Counts and gate.** `python3 lean/verification/check_formal_artifact.py --source-only` passes;
  59 claims / 9 absent / 25 fragmentary / 24 conditional / 1 complete matches `claims.json` and both
  README snapshots.
- **Evidence replay.** Reproduced exactly, as described in defect 8.

---

# Second pass — after the repairs and the follow-up Section 3 rewrite

**Lane:** `cubic-threefolds` · **Date:** 2026-08-18 · re-audit of the same diff at its current state

## Verdict

Every repair I asked for landed and I could confirm each one by reading the file rather than the
summary: both open Voisin branches are stated, the Yang--Yu--Zhu scope is narrowed to their explicit
family, the Eckardt point is defined, the Fermat control wording is now accurate, the `L'` sentence
is correct, the second evidence artifact exists and its `--check` mode works, `E` is separated from
the elliptic scheme, the block moved so "its" recovers its antecedent, the Yang--Yu--Zhu paragraph
declares whose coordinates it works in, proof-level `\uses` are recorded, and the absence claim is
withdrawn. I re-ran everything: the gate passes, all three checksums verify, and I regenerated both
artifacts from the script and reproduced them byte for byte, including a fresh Singular 4.4.1 run.
Four things are wrong now that were not wrong before, two of them introduced by the repairs
themselves: the introduction's new sentence about Voisin inverts the polarity of what disjointness
would require; the compressed order-three paragraph drops the one step that made the Klein cubic
exclude those two families, so the alternative route as printed does not deliver the finiteness it
claims; the Klein cubic's membership in the pencil, which that paragraph now rests on, lost its
citation when the old proof was deleted; and the shrinking step in Section 2 assumes one multiplier
divides the other. Separately, the introduction still asserts a stronger no-elliptic-product statement
than the proposition proves — but that stronger statement is true and costs one deleted step to
prove, which is the one free upgrade in reach here.

## Repairs I verified

Items 1, 2, 4, 5, 6, 9, 10, 11, 12, 13, 14 and the smaller list in 15 are all correctly applied; I
checked each in the file. Notes where the check found more than a yes:

- **Item 8 (evidence bundle).** `verification/a5-pencil-models.txt` now carries the model checks and
  `--check` recomputes and compares them, exiting nonzero on a mismatch. I confirmed by running all
  three registered commands: the model file reproduces, `--check` agrees, and a fresh Singular run
  reproduces `a5-pencil-eckardt.txt` exactly. The rewritten `role` text matches what the two
  artifacts actually contain, including the two cones described separately and the corrected Fermat
  sentence. This one is fully closed.
- **Item 13 (annotation edges).** Both statement-level and proof-level `\uses` are present, so the
  graph now carries dashed and solid edges for each dependency, matching the pattern already used
  elsewhere; `thm:separation-family -> prop:A5-not-coprime` is recorded. No cycle: nothing points
  back from `prop:A5-nonseparated` or `prop:A5-not-coprime` into `thm:separation-family`.
- **Item 3.** Superseded by the follow-up rewrite; assessed in its own section below.

## Still wrong, most severe first

### A. The introduction's new Voisin sentence has its polarity inverted

`sections/01-introduction.tex`:

> "We do not claim that the \(A_5\)-curve is disjoint from her locus.  That would need both of the
> routes left open there to fail: the four-dimensional factor of
> Proposition~\ref{prop:no-elliptic-product} being the Jacobian of an irreducible curve of genus
> four, and the intermediate Jacobian itself being odd-degree isogenous to the Jacobian of an
> irreducible curve of genus five."

Disjointness requires both routes to *fail*, that is, requires the factor **not** to be a genus-four
Jacobian and the intermediate Jacobian **not** to be odd-degree isogenous to a genus-five Jacobian.
The colon then lists the two conditions in the affirmative, so the sentence reads as saying that
disjointness needs the factor to *be* a genus-four Jacobian — the opposite of what is meant. The
charitable reading, that the colon merely names the two routes, is available but is not the first
one. The version this replaced ("which would need the four-dimensional factor … **not** to be a curve
Jacobian") had the polarity right.

Fix: "That would need both routes left open there to fail: the four-dimensional factor of
Proposition~\ref{prop:no-elliptic-product} must not be the Jacobian of an irreducible curve of genus
four, and \(J\) must not be odd-degree isogenous to the Jacobian of an irreducible curve of genus
five." The ledger's version of the same sentence is phrased in the affirmative around "open along
exactly two routes" and is correct as it stands; only the introduction is inverted.

### B. The order-three paragraph drops the step that made the Klein cubic exclude those families

`sections/03-minimal-class.tex`:

> "The order-three signatures give the same finiteness by a different route: a separated-variable
> form admits an order-three automorphism of signature \((0,0,0,0,1)\) or \((0,0,0,1,1)\), which
> Gonz\'alez-Aguilera--Liendo identify as their families \(T_3^1\) and \(T_3^2\)
> \cite[Theorem~2.5]{GonzalezAguileraLiendo}, while the Klein cubic, which lies in the pencil, has
> signature \((0,0,1,1,2)\) \cite[Proposition~2.6]{GonzalezAguileraLiendo}; the pencil is an
> irreducible curve, so it meets each of those two closed loci in a finite set."

A cubic threefold can carry several order-three automorphisms and so lie in several of the `T_3^i`.
Knowing that the Klein cubic belongs to `T_3^4` therefore does not by itself put it outside `T_3^1`
and `T_3^2`. The deleted proof supplied exactly the missing step: "its automorphism group is
`PSL(2,F_11)`, which has a single conjugacy class of elements of order three". With that, `T_3^4` is
the only order-three family it can belong to and the exclusion works; without it, the paragraph's
"so it meets each of those two closed loci in a finite set" has no support, because nothing shows the
pencil is not contained in one of them.

Two smaller losses in the same sentence. The closedness of the two loci is now asserted ("those two
closed loci") where the deleted proof proved it, from finiteness of
`U^G / N_{GL_5(C)}(G) -> M`. And "the pencil is an irreducible curve" silently swaps `B^\circ` for
`M_{H_1}`; the argument runs either upstairs on `B^\circ`, which is visibly irreducible, or
downstairs on `M_{H_1}`, which needed Hartlieb's irreducibility. Upstairs is fine and shorter, but
the sentence should say which.

Fix: restore the single-conjugacy-class clause with its citation, and say the loci are closed
because the relevant quotient map to moduli is finite — three extra clauses, and the paragraph
becomes a genuine second route again.

### C. "the Klein cubic, which lies in the pencil" is now uncited, and is its only appearance

Same paragraph. Grepping the sections, `Klein` occurs exactly once in the whole manuscript, in that
clause, with no citation. The deleted proof carried it: "Hartlieb also proves that `M_G` is
irreducible, and for the nonstandard `A_5`-representation `H_1`, `M_{H_1}` is a one-dimensional
family containing the Klein cubic \cite[Lemmas~2.6--2.7 and Proposition~5.7]{Hartlieb}." That is the
fact the whole alternative route turns on, and it now stands bare.

Fix: restore the Hartlieb pinpoint on that clause. (I checked `verification/imported-sources.json`:
it has no entry for Gonz\'alez-Aguilera--Liendo or for those Hartlieb lemmas, so nothing in the
registry was orphaned by the deletion. I also grepped the sections for `M_{G`, `T_3`, and
`GonzalezAguileraLiendo`: the deleted proof's intermediate objects `M_{G_1}` and `M_{G_2}` appear
nowhere else, and the only surviving Gonz\'alez-Aguilera--Liendo citations are the two in this
paragraph, so the bibliography entry stays cited and nothing else broke.)

### D. Two multipliers, and the assumption that one divides the other

`sections/02-envelope.tex`:

> "Taking the larger of the two resulting multipliers, and shrinking the other summand again by an
> odd index, makes both forms \(m\) times a unimodular one for a single odd \(m\)."

Shrinking a summand whose form is `m_1` times a unimodular one can only multiply `m_1` by an odd
integer, so the larger of the two multipliers is reachable from the smaller only if the smaller
divides it. Nothing here establishes that. (It happens to hold in the computed instance — the task
report records Pfaffian 5 on the rank-two factor and elementary divisors `(3,3,3,3,3,3,15,15)` on the
rank-eight one, and 5 divides 15 — but the proof is an existence argument and should not depend on
the arithmetic of one case.)

Fix: take `m` to be the product of the two multipliers and shrink each summand by the complementary
odd factor. Both indices stay odd and the sentence gets no longer. The preceding elementary-divisor
sentence, which is new, is correct as written: the sublattice spanned by `d_g e_i / d_i` and `f_i`
does carry `d_g` times a unimodular form at odd index `prod_i (d_g / d_i)`.

### E. The introduction and ledger still overstate the no-elliptic-product result — and the
overstatement is a free upgrade

`sections/01-introduction.tex`:

> "Proposition~\ref{prop:no-elliptic-product} shows that the intermediate Jacobian of the geometric
> generic member admits no odd-degree isogeny from a product of elliptic curves"

and `claim-proof-novelty-ledger.md`: "Its intermediate Jacobian admits no odd-degree isogeny from a
product of elliptic curves". The proposition, now correctly scoped, says "no such `mu` has five
elliptic factors", where "such" carries `mu^* Theta = m sum_i Theta_i`. Neither of these two
sentences carries that condition, so as printed they claim strictly more than the proposition proves.

The upgrade: the stronger statement is true, and the printed proof already contains it. The only
step that uses the polarization condition is orthogonality of the decomposition `H_2 = ⊕ H_2^{(i)}`,
which feeds the `F_4`-line argument. Drop that step and the rest survives for any odd-degree isogeny
from a product: the module decomposition alone gives `H_2 = ⊕ H_2^{(i)}` with each summand an
`F_4`-subspace. If every factor is elliptic then every `U_i` is a line, so each `H_2^{(i)}` sits
inside the discriminant group of a rank-one lattice, which is cyclic; an `F_4`-subspace has even
`F_2`-dimension, so each `H_2^{(i)}` vanishes, so `H_2 = 0`, contradicting `|H_2| = 16`. That gives
"no odd-degree isogeny from a product of five elliptic curves, whatever polarizations the factors
carry" in two sentences, and it is exactly the sentence the introduction and the ledger already want
to write. Note the trimmed argument kills only the all-elliptic shape: a rank-two `U_i` has a
discriminant group on two generators, which can hold an `F_4`-line, so the `(1,2,2)` shape of van
Geemen and Yamauchi still needs the polarization hypothesis.

Fix: add that sentence to the proposition, or qualify the two prose claims. The first is better,
since it is what the paper wants to say.

### F. `prop:A5-nonseparated` now rests on a computation and its claim-map row does not say so

The rewritten proof runs through `prop:A5-not-coprime`, which carries `\evidence{a5-pencil-eckardt}`.
So a statement that was previously certificate-free — pure representation theory plus moduli
irreducibility — now depends transitively on the registered Eckardt computation. Its row in
`lean/verification/claims.json` still lists only "Smoothness of the pencil members, and the
separated-variable criterion for universal CH0-triviality of Colliot-Thelene" as hypotheses, and its
`cautions` still says "The projective-equivalence and dimension arguments over the coarse moduli
image are outside the companion's scope" — the dimension argument it refers to was in the deleted
proof and is now inherited rather than made. The added sentence about the Eckardt criterion is right
but does not mention the computation.

Fix: add the registered bundle to `hypotheses`, and rewrite the stale "dimension arguments" clause.
Whether the statement should also carry `\evidence` is a judgement call — the graph records the
dependency transitively through `prop:A5-not-coprime` — but the row's prose should not read as if
nothing computational entered.

### G. The five-line proof does not close the second clause of its own statement

`prop:A5-nonseparated` concludes "…all but finitely many points of \(M_{H_1}\) are represented by
universally \(CH_0\)-trivial cubic threefolds by Corollary~\ref{cor:universal-ch0}, **but are not
covered by the separated-variable criterion of Colliot-Th\'el\`ene**". The new proof ends at "The
remaining points are represented by universally \(CH_0\)-trivial cubic threefolds by
Corollary~\ref{cor:universal-ch0}" and never says the second half in words.

It does follow, in one step, from the proof's own first assertion: those remaining points are not
represented by any cubic projectively equivalent to a separated-variable form, so the criterion of
\cite{CT} does not apply to them. Add that clause. (Worth noting while you are there:
`cor:universal-ch0` gives universal `CH_0`-triviality for **every** smooth member, so the
"all but finitely many" in the statement is weaker than what is available; that is the statement's
pre-existing phrasing, not something the new proof introduced.)

### H. `claims.json` conclusion for `prop:no-elliptic-product` no longer matches the statement

> "…and the intermediate Jacobian is not odd-degree isogenous to a product of five elliptic curves."

The manuscript now says "no such \(\mu\) has five elliptic factors". The row's `hypotheses` field does
list "an odd multiple of the product polarization", so the row is not wrong taken whole, but its
`conclusion` sentence read alone is the very overstatement the statement was repaired to avoid.
Align it — or, if you take the upgrade in E, align both upward instead.

### I. Smaller items, still open or newly noticed

- `sections/02-envelope.tex`: `U_i` is used throughout the proof and never defined. One clause:
  "write `U_i ⊆ W_5` for the subspace with `mu_* H_1(A_i, Q) = U_i ⊗ M_Q`".
- `sections/02-envelope.tex`: "Its first-coordinate projection is all of \(\Lambda_1\otimes\mathbf
  Z_2\) and carries \(P_i\) onto \((\Lambda_1\cap U_i)\otimes\mathbf Z_2\), so \(\Lambda_1\otimes
  \mathbf Z_2 = \bigoplus_i(\Lambda_1\cap U_i)\otimes\mathbf Z_2\)." The "onto" is a conclusion, not
  an observation: what is immediate is the inclusion, and surjectivity onto each piece follows only
  after summing and comparing with the surjectivity of the projection on all of `L ⊗ Z_2`. Write
  "carries `P_i` into", then draw both conclusions.
- `sections/02-envelope.tex`: "Then \(\Lambda_1/\Lambda\) is the two-primary coefficient heart
  \(H_2\) of \eqref{eq:primary-discriminants}." This is an identification, not a definition —
  `H_2` was defined as `Aug(F_2^Omega)/<1>`, the radical quotient of the mod-two coefficient form.
  The two agree via `x -> 2x mod 2Lambda`, which sends `Lambda_1/Lambda` isomorphically onto
  `ker(kappa mod 2)` in `Lambda/2Lambda`, equivariantly, so the `F_4`-scalar `omega` and the pairing
  `b` transport. Since both `omega` and `b` are imported through this identification, it deserves the
  half-sentence.
- `sections/03-minimal-class.tex`, `lem:eckardt-rank`: "Two families always contain an Eckardt point:
  a smooth cubic threefold whose defining form is a sum of cubic forms in pairwise disjoint nonempty
  groups of at most three variables, and every member of the family of \cite[Theorem~3.3]{YYZ}." A
  family does not contain a point, its members carry one, and the two list items are not parallel —
  one is a threefold, the other is "every member of". This was in the original and I missed it. Try:
  "Every smooth cubic threefold in either of two classes carries one: those whose defining form is a
  sum of cubic forms in pairwise disjoint nonempty groups of at most three variables, and the members
  of the family of \cite[Theorem~3.3]{YYZ}." The same phrasing is copied into the `lem:eckardt-rank`
  row of `claims.json` ("both named families contain such a point").
- `sections/03-minimal-class.tex`: the proposition is now titled "Finite Eckardt locus" while its
  label is still `prop:A5-not-coprime`, which now names only its second sentence. Labels are stable
  identifiers and renaming churns the digests and the ledger, so this may not be worth doing — but if
  it is ever renamed, this is the moment, before the label is cited outside the paper.
- `sections/03-minimal-class.tex`: `M_{H_1}` is now introduced three times — in the bridging
  paragraph ("Write \(M_{H_1}\) for…"), in `prop:A5-not-coprime`'s statement ("the coarse-moduli
  image \(M_{H_1}\) of the pencil"), and again in `prop:A5-nonseparated`'s statement ("Let
  \(M_{H_1}\) be…"). The third should just use the symbol.
- `sections/02-envelope.tex`: "on a family whose intermediate Jacobian splits off factors of
  dimension at most three that route is automatic" still omits the conditions that make it automatic
  — the splitting has to be by an odd-degree isogeny with an odd multiple of the product
  polarization, which is the whole content of the following proposition.
- `sections/02-envelope.tex`: "In particular no such \(\mu\) has five elliptic factors" inherits
  "if \(m\) is odd" only from the preceding sentence; "such" on its own reaches back to the display,
  which has no parity condition. Two words fix it.
- `sections/02-envelope.tex`: "its degree is \(m^5\)" is asserted without the one-line reason
  (`deg lambda_{mu^* Theta} = (deg mu)^2` and `deg lambda_{m Theta_0} = m^{10}`). Correct, and worth
  a parenthesis since the whole parity argument hangs on it.
- `sections/03-minimal-class.tex`: "those points are exactly the ones carrying an Eckardt point" —
  moduli points do not carry Eckardt points; the threefolds representing them do. Also "The Fermat
  cubic threefold, which is a member of the pencil and appears there explicitly in the monomial
  model" has a stray "there".
- `sections/03-minimal-class.tex`: the three-way pointer says each proposition "excludes" a locus,
  where each in fact excludes all but finitely many moduli points. And one line of that paragraph
  runs to 95 columns where the file's habit is about 76.

## The two questions you asked

### Is the second proof — now the printed proof — correct, and is the swap the right call?

The five-line proof is correct for the first sentence of `prop:A5-nonseparated`: the lemma gives an
Eckardt point on any smooth separated-variable cubic, carrying one is a projective invariant, and
`prop:A5-not-coprime` bounds the Eckardt locus of the pencil. It does not close the second clause in
words, which is item G above, but that clause follows from its own first assertion in one step. The
restatement of `prop:A5-not-coprime` as a finiteness statement about the Eckardt locus, with the
coprime-degree conclusion as a corollary sentence, is the right shape: it is what the argument
actually proves, it makes the reuse by `prop:A5-nonseparated` immediate, and its rewritten claim-map
row matches both sentences.

On the swap itself I want to correct my first-pass advice, which was too quick. Replacing the proof
does buy real things — five lines instead of forty, one criterion serving both comparisons, and no
dependence on Hartlieb's closedness and irreducibility statements or on Gonz\'alez-Aguilera--Liendo.
But it also converts `prop:A5-nonseparated` from a certificate-free statement into one that rests
transitively on the registered Eckardt computation, and this repository's standing preference is for
structural proofs over certificates. Keeping the order-three route in print is what saves the swap:
it is the certificate-free argument, and as long as it stands as a real proof the finiteness does not
actually depend on the bundle.

So my preferred end state is the current one plus three things. Repair the order-three paragraph so
it is a genuine second proof rather than a sketch — items B and C, which together are about four
clauses. Then add one sentence saying that this second route uses no computation, so the finiteness
of the separated-variable locus does not depend on the registered bundle. Then make the claim-map row
say both (item F). That is better than either alternative I offered on the first pass: the short
proof is the one the reader meets, and the computation-free route is still on the page, stated
strongly enough to be checked.

### Does the evidence role text match what the two artifacts contain?

Yes. I checked it line against line. `a5-pencil-models.txt` contains exactly the six model facts the
role describes — group order sixty on the six-point model, the two ten-element triple orbits, the
invariant cubics forming a pencil (dimension two), `T_1` invariant under `A_5` and not under `S_6`,
two invariant directions in the monomial model fixed by all sixty elements, and the Fermat form being
one of them. `a5-pencil-eckardt.txt` contains exactly the two cone computations the role describes,
with the Jacobian cone certifying smoothness and the Eckardt cone its emptiness or degree, and the
counts in the role text match the rows: five smooth Eckardt-free members in the six-coordinate model,
three in the monomial model, thirty for the Fermat control in both rings, and nonempty Eckardt schemes
for the two Yang--Yu--Zhu members. The two disclaimers at the end — that the finite exceptional set is
not computed and that nothing is certified about singular members — are both accurate, and the
`mono(0,1)` row, which is singular with an empty Eckardt cone, is correctly not counted among the
three.

## Re-verified this pass

- Reproduced `verification/a5-pencil-models.txt` from the script, ran `--check` against the tracked
  copy (agrees, exit 0), regenerated the Singular input, ran Singular 4.4.1 from `nixpkgs#singular`,
  and reproduced `verification/a5-pencil-eckardt.txt` byte for byte. All three entries in
  `a5-pencil-eckardt.sha256` verify.
- `python3 lean/verification/check_formal_artifact.py --source-only` passes after the latest rewrite:
  59 claims, 9 absent, 25 fragmentary, 24 conditional, 1 complete, 2 evidence bundles, matching both
  README snapshots.
- Re-read the whole proof of `prop:no-elliptic-product` after the edits. Every step still holds,
  including the two rewritten ones: `L'` as an orthogonal direct sum of sublattices with the
  localization at two turning the inclusions into equalities, and the elementary-divisor construction.
  The only new defect is item D.
- No dependency cycle: `thm:separation-family -> prop:A5-not-coprime -> prop:A5-nonseparated`, with
  nothing pointing back.
- Nothing outside the deleted proof referenced `M_{G_1}`, `M_{G_2}`, or the signature families, and
  `verification/imported-sources.json` carries no entry for Gonz\'alez-Aguilera--Liendo or the
  Hartlieb lemmas that were dropped, so the deletion orphaned no registry row.

---

# Third pass — after the second round of repairs

**Lane:** `cubic-threefolds` · **Date:** 2026-08-18 · third re-audit of the same diff

## Verdict

The three things you asked me to look at hardest come out differently from one another. The new
closing paragraph of the proof of `prop:no-elliptic-product` is correct as written — I checked it
step by step and the polarization hypothesis really is unused in everything it appeals to — and the
proposition now reads cleanly with its two conclusions of different strength, subject to one wording
fix. The rebuilt order-three paragraph reaches the right conclusion and its two citations check out
against the primary source, which I fetched and read this pass: González-Aguilera and Liendo's
Theorem 2.5 lists exactly the two signatures the manuscript names, and their Proposition 2.6 states
both the single conjugacy class of order-three elements in `PSL(2, F_11)` and the Klein threefold's
membership in the order-three family of signature `(0,0,1,1,2)`, and draws the very inference the
manuscript needs. But the reconstruction introduced three defects that were not in the deleted text:
the closedness sentence names the wrong source for its finite morphism and misreads "smooth G-fixed
cubic locus" as a fixed locus that is smooth; the irreducibility sentence compares a family of forms
with loci in moduli, so as written it is neither the upstairs nor the downstairs argument; and the
normalization under which a signature is even well defined was dropped. None of these is fatal —
I verified the underlying claim independently — but all three are in the one paragraph you flagged
as reconstructed from my description rather than from the original, which is exactly where you
expected trouble. Everything else on your list landed correctly; the gate passes and both evidence
artifacts still replay byte for byte.

## The rebuilt order-three paragraph

Checked clause by clause against the deleted proof and against
`arXiv:1002.4136v2`, which I fetched and extracted this pass because it is not in the shared
literature cache. What holds up:

- "Multiplying the variables of a block of size one or two by \(\zeta_3\) fixes a
  separated-variable form" — correct, since `zeta_3^3 = 1` fixes a cubic summand in those variables
  and leaves the others alone, giving signature `(0,0,0,0,1)` or `(0,0,0,1,1)`.
- The two families and their signatures. González-Aguilera--Liendo Theorem 2.5 lists
  `T_3^1: p = 3, sigma = (0,0,0,0,1), F = L_3(x_0,x_1,x_2,x_3) + x_4^3` and
  `T_3^2: p = 3, sigma = (0,0,0,1,1), F = L_3(x_0,x_1,x_2) + M_3(x_3,x_4)`. The pinpoint is exact.
- The Klein cubic. Their Proposition 2.6 reads "The automorphisms group `Aut(X)` of the Klein
  threefold `X` is isomorphic to `PSL(2, F_11)`… one conjugacy class of elements of order 3… Since
  there is only one conjugacy class of orders 2 and 3, respectively, then `X` belongs to one and only
  one of the families with automorphisms of order 2 and 3, respectively… the Klein threefold belongs
  to `T_2^2` and `T_3^4`", and their `T_3^4` has `sigma = (0,0,1,1,2)`. So "so it lies in neither
  family" is not merely supported by the citation, it is the source's own conclusion. The restored
  single-conjugacy-class clause is doing exactly the work it needs to.
- I checked the group theory independently. `PSL(2, F_11)` has eight conjugacy classes — orders
  1, 2, 3, 5, 5, 6, 11, 11 — so exactly one of order three. And the Klein cubic really does sit in
  *this* pencil: its order-three class has character `-1` on a five-dimensional representation, which
  matches `W_5` and not `1 ⊕ W_4`, so the `A_5` inside `PSL(2, F_11)` acts through the nonstandard
  representation.
- The step is load-bearing rather than decorative, which is worth knowing before trimming it further:
  González-Aguilera--Liendo record `T_3^2` as having dimension one in moduli, the same dimension as
  `M_{H_1}`, so nothing but the Klein cubic rules out containment.

### Defect: the closedness sentence names the wrong finite morphism, and misreads "smooth"

> "Each is the image in moduli of a smooth fixed locus under a finite morphism, hence closed."

The deleted text read: "Hartlieb writes \(M_G\subset M\) for the image of the smooth \(G\)-fixed
cubic locus.  The morphism \(U^G/N_{\operatorname{GL}_5(\C)}(G)\longrightarrow M\) is finite; hence
\(M_G\) is closed." Two things went wrong in compression. The finite morphism is from the
**quotient** of the fixed locus by the normalizer, not from the fixed locus itself — the map from
`U^G` alone has positive-dimensional fibres, being constant on normalizer orbits, so it is not
finite and the sentence as written is false. And "the smooth `G`-fixed cubic locus" means the locus
of **smooth cubics** fixed by `G`; "a smooth fixed locus" reads it as a fixed locus that happens to
be a smooth variety, which is a different and unasserted claim. The attribution also went missing:
the whole `M_G` apparatus was Hartlieb's, cited in the deleted text and uncited now.

Fix: "Each is the image of `U^G / N_{GL_5(C)}(G)` in moduli, for `U^G` the locus of smooth cubics
fixed by the relevant group `G`, under a finite morphism, hence closed \cite[Lemmas~2.6--2.7]{Hartlieb}."
That also puts the Hartlieb lemmas on the sentence they actually support; see the next item.

### Defect: "the pencil is an irreducible curve, so it meets each of the two loci in a finite set"

You asked whether irreducibility is being used upstairs or downstairs. As written it is neither, and
that is the problem: the pencil is a family of cubic forms — a curve in the parameter space — while
`T_3^1` and `T_3^2` are loci in moduli, so "the pencil meets the two loci" has no literal referent.
The deleted text was unambiguous and worked downstairs: "Each intersection `M_{H_1} ∩ M_{G_i}` is
therefore a proper closed subset of the irreducible curve `M_{H_1}`. It is zero-dimensional and,
since the moduli space is of finite type over `C`, finite."

Both repairs work, and upstairs is the better one:

- **Upstairs.** The preimage in `B^\circ` of each locus is closed by continuity, and proper because
  the parameter of the Klein cubic is not in it; `B^\circ` is an irreducible curve, being a
  nonempty open subset of a `P^1`; so the preimage is finite and so is its image in `M_{H_1}`. This
  needs no irreducibility statement about `M_{H_1}` at all, so the only thing Hartlieb is needed for
  in the paragraph is the Klein cubic's membership.
- **Downstairs.** `M_{H_1}` is the image of the irreducible `B^\circ`, hence irreducible without
  citing anything, and a proper closed subset of a one-dimensional such set is finite since moduli is
  of finite type.

Whichever you take, say which object the word "irreducible" is attached to.

### Defect: the normalization that makes a signature well defined was dropped

The deleted text said the signature is what it is "up to permutation of the coordinates, replacement
of the chosen generator by its inverse, and multiplication of the linear lift by a scalar". That
qualifier is not decoration: González-Aguilera--Liendo fix `sigma` only "after a linear change of
coordinates that diagonalizes `phi`", and a lift to `GL_5` is defined only up to a scalar, so the raw
exponent tuple is not an invariant. Without the qualifier a reader cannot tell whether comparing
`(0,0,0,0,1)` and `(0,0,0,1,1)` with `(0,0,1,1,2)` is legitimate.

It is, and I checked it rather than assuming it. Writing a signature by its multiplicities of the
eigenvalues `1, zeta, zeta^2`, the three tuples give `(4,1,0)`, `(3,2,0)` and `(2,2,1)`; the scalar
shift cycles the multiplicities and inversion swaps the last two, so the orbits are
`{(4,1,0),(0,4,1),(1,0,4)}` and their swaps, `{(3,2,0),(0,3,2),(2,0,3)}` and their swaps, and
`{(2,2,1),(1,2,2),(2,1,2)}`. These are pairwise disjoint, so the Klein cubic's order-three signature
is genuinely distinct from both. As a cross-check, the shift of `(0,0,1,1,2)` with multiplicities
`(1,2,2)` has trace `1 + 2 zeta + 2 zeta^2 = -1`, which is the character value of the
five-dimensional representation of `PSL(2, F_11)` at its order-three class. Restore the qualifier.

### Gap: the containment the paragraph needs is never stated

The chain runs "separated-variable form admits such an automorphism → those are `T_3^1` and `T_3^2`
→ each locus is closed → the Klein cubic is in neither → finite intersection", and then concludes
about "the separated-variable locus". The link the deleted text supplied explicitly — "Their union
contains every separated-variable point of `M_{H_1}`" — is missing, so the paragraph never says that
the finite set it produced is the one it is claiming to bound. One clause. While you are there, "a
block of size one or two" is assumed to exist; the deleted text said why ("At least one block has
size one or two"), which is immediate since two blocks of size three would need six variables.

## The new closing paragraph of the proof of `prop:no-elliptic-product`

Mathematically correct. I re-derived every step:

- Dropping the polarization hypothesis still gives `L' ⊆ ⊕_i (L ∩ (U_i ⊗ M_Q)) ⊆ L` with odd index,
  hence `L ⊗ Z_2 = ⊕_i P_i` as a module direct sum.
- The chain from that decomposition to `H_2 = ⊕_i H_2^{(i)}` with each summand `omega`-stable uses
  only the display and the module decomposition — the first-coordinate projection argument, the
  intersection with the first coordinate subspace, and the fact that `u` runs over all of
  `Lambda_1 ∩ U_i`. Orthogonality and unimodularity are genuinely unused there, so the paragraph's
  claim about what the earlier argument needs is accurate.
- With every `U_i` a line, `H_2^{(i)}` is a quotient of one rank-one lattice by another, hence
  cyclic; it is killed by two because `2 Lambda_1 ⊆ Lambda`; an `F_4`-stable subspace has even
  `F_2`-dimension; so it vanishes, `H_2 = 0`, and `|H_2| = 16` is contradicted.

One presentational defect. The back-reference points at sentences that carry precisely the adjectives
it disclaims: "It is an orthogonal direct sum of sublattices … each summand carrying \(m\) times a
unimodular alternating form" and "\(L\otimes\mathbf Z_2\) is the orthogonal direct sum of the
\(P_i\) …, each unimodular". A reader following "uses only that the index is odd, not orthogonality"
has to strip those adjectives from two sentences and satisfy himself that the derivations in them
survive. They do, but he should not have to check. Split the module-level fact out first — "`L'` is
a direct sum of sublattices of the `L ∩ (U_i ⊗ M_Q)`, of odd index in `L`, so
`L ⊗ Z_2 = ⊕_i P_i`" — and then add "under the polarization hypothesis the sum is moreover
orthogonal and each `P_i` unimodular". The last paragraph then cites a clean sentence.

## Does the statement read correctly with two conclusions of different strength?

Yes, structurally. The dichotomy sits under "If \(m\) is odd then…", the realization sentence follows
it, and the strengthened conclusion opens with "Moreover" and explicitly releases the polarization
condition, so no reader will carry `m` into it. The derived degree `m^5` now carries its one-line
reason and is correct: `deg lambda_{mu^* Theta} = (deg mu)^2` since `Theta` is principal, and
`deg lambda_{m sum Theta_i} = m^{10}` for a five-dimensional product.

One wording fix. "whatever polarizations those factors carry" names a freedom that does not exist —
an elliptic curve has exactly one principal polarization, so nothing varies there. What is actually
released is the relation `mu^* Theta = m sum_i Theta_i`. Write "with no condition imposed on the
pulled-back polarization". The same phrase is in the ledger, and `claims.json` says "with no
hypothesis on the polarizations of the factors" for the same conclusion; all three want the same
correction.

## Smaller items, still open

- `claim-proof-novelty-ledger.md`, the "No elliptic-product route" row. Its proof-status cell still
  describes only the polarization-conditioned argument — "every summand of an odd-index orthogonal
  splitting", "the only product shape is one plus four" — and its literature-posture cell still says
  "the obstruction here is about realizing such a splitting by an odd-degree isogeny matching the
  polarizations". Both were accurate before the upgrade and are now half the story: the
  five-elliptic-factor conclusion needs no polarization matching at all. The other row's "Position of
  the pencil" cell states the upgraded form, so the ledger currently describes the result more
  strongly where it cites it than where it owns it.
- `lean/verification/claims.json`, `prop:no-elliptic-product`. The `hypotheses` field still lists
  "odd isogeny degree, and an odd multiple of the product polarization" flatly, while the
  `conclusion` field correctly flags that its last clause holds "with no hypothesis on the
  polarizations of the factors". Add "for the last conclusion, odd degree alone" so the two fields
  agree.
- `sections/02-envelope.tex`: "a quotient of a rank-one lattice pair" is an unusual way to say that
  both `Lambda_1 ∩ U_i` and `Lambda ∩ U_i` have rank one; and "being killed by two" would read better
  with its half-clause reason, that `Lambda_1 ⊆ (1/2) Lambda`.
- Not a manuscript item, but worth doing: González-Aguilera and Liendo, *Automorphisms of prime order
  of smooth cubic n-folds*, Arch. Math. 97 (2011) 25--37, arXiv:1002.4136v2, is not in
  `/tmp/persistent/tavis/lit-search/`. It is now cited for two load-bearing facts in a rebuilt
  argument, so it belongs in the shared cache.

## Repairs verified this pass

Items A, D, E, F, G, H and the whole of I landed correctly; B and C landed with the three residuals
above. Specifically checked in the files rather than taken from the summary: the introduction's two
routes now read "must not be the Jacobian…" and "must not be odd-degree isogenous…", so the polarity
is right, and its no-elliptic-product sentence is now covered by the upgraded proposition rather than
overshooting it; the multiplier step takes `m` to be the product of the two multipliers and shrinks
each summand by the complementary odd factor, which removes the divisibility assumption; the
`prop:A5-nonseparated` row lists the inherited computation in `hypotheses` and says in `cautions`
that the printed proof runs through the bundle while the computation-free route follows it; the
five-line proof now closes its second clause; `U_i` is defined; the projection carries `P_i` "into"
with equality drawn afterwards; the doubling identification of `Lambda_1/Lambda` with the coefficient
heart is stated with the transport of the `F_4`-scalars and the pairing, and it is correct — `x`
maps to `2x` modulo `2 Lambda` and lands on the kernel of `kappa` modulo two, equivariantly; the
lemma statement is parallel; `M_{H_1}` is introduced twice rather than three times; the framing
paragraph names the conditions that make Voisin's route automatic; the stray "there" is gone; the
pointer paragraph says "all but finitely many moduli points"; and no line in either new block exceeds
eighty columns. "Both comparisons run through one classical criterion" is now true, since both
printed proofs go through the lemma.

## Re-verified this pass

- `python3 lean/verification/check_formal_artifact.py --source-only` passes: 59 claims, 9 absent,
  25 fragmentary, 24 conditional, 1 complete, 2 evidence bundles.
- All three entries of `verification/a5-pencil-eckardt.sha256` verify; `--check` agrees with the
  tracked model file; regenerating the model artifact reproduces it; and a fresh Singular 4.4.1 run
  on the regenerated input reproduces `verification/a5-pencil-eckardt.txt` byte for byte. (The
  manifest lists bare filenames, so `sha256sum -c` has to be run from `verification/` rather than
  from the paper directory the replay commands assume — but `hirzebruch-euler-spectrum.sha256` has
  the same convention, so this is the house style, not a new defect.)
- The primary sources behind the rebuilt paragraph, read directly: González-Aguilera--Liendo
  Theorem 2.5 and Proposition 2.6, as quoted above.
