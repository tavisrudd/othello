# Referee review: sharpening the A_5-pencil separation statements to a single exceptional point

Hostile review of the uncommitted change under `papers/cubic-stabilization-epilogue/`
(`git diff` plus the four untracked `verification/a5-pencil-eckardt-locus.*` /
`a5_pencil_eckardt_locus.py` files), dated 2026-08-19. Judged against
`papers/style-guide.md` and `notes/formal-annotation-conventions.md`.

## Verdict

The mathematics that was attacked mostly survives: the saturation is the right
operation, the Hessian is taken in legitimate coordinates, the coprimality of
`b^2+3b+9` with the singular-parameter polynomial is correct by hand, the
exclusion of `b=0` is sound, and both inclusions in `prop:A5-nonseparated` are
genuinely established. What does not survive is the write-up around it. The
proof of the headline theorem was not updated and still establishes only the old
finiteness statement, so as the tree stands `thm:separation-family` is stated
more strongly than it is proved. The paper's declared verification boundary
("No certificate, enumeration, or symbolic program is invoked as a premise") is
now flatly contradicted by the change, and no sentence anywhere in the
manuscript body discloses that a headline conclusion rests on an uncertified
Singular Groebner run — the disclosure lives only in `evidence.json`, and the
dependency graph carries no path from the new bundle to the theorem. The new
lattice remark contradicts itself within four lines ("it is not principally
polarized" / "the factor has exactly six principal polarizations") and, read
literally, closes the very route the surrounding prose says is open. Seven
further sites, including the abstract, still assert the superseded "all but
finitely many". The paper's own gate passes, which is the point: everything
below is in the prose the digests do not cover.

---

## 1. BLOCKER — the proof of `thm:separation-family` proves the old statement

**Location:** `sections/06-synthesis.tex:42-44`, inside
`\begin{proof}[Proof of Theorem~\ref{thm:separation-family}]`.

> Finally,
> Proposition~\ref{prop:A5-nonseparated} shows that all but finitely many
> points of this moduli curve lie outside the separated-variable locus.

The theorem it proves now reads (`sections/01-introduction.tex:167-170`):

> Every point of its coarse-moduli image
> except the one represented by the Fermat cubic threefold is not represented by
> any cubic whose defining form is a sum of cubic forms in disjoint groups of at
> most three variables.

The final clause of the theorem is strictly stronger than the final sentence of
its proof. The change sharpened the statement and left the proof behind. This is
not a stylistic lapse: as committed, the headline theorem is unproved.

**Required:** rewrite that sentence to invoke the sharpened
`prop:A5-nonseparated` and name the Fermat point. While there, note that this
proof carries no `\uses` annotation at all (`grep -n "uses{" sections/06-synthesis.tex`
returns nothing), which is the mechanism by which finding 2 became possible.

## 2. BLOCKER — the trust boundary is now misdeclared, and the graph hides it

Three separate failures, all one issue.

**(a) The verification README asserts the opposite of what is true.**
`verification/README.md:3-4`:

> The manuscript is intended to have a wholly human proof spine.  No certificate,
> enumeration, or symbolic program is invoked as a premise.

`verification/evidence.json` in the same diff says the spine is structural
"apart from three computations, all registered below". These two files
contradict each other, and the README was touched in this diff (the coverage
snapshot line) without the contradiction being fixed. Before the change one
could argue the Eckardt bundle only exhibited members and the finiteness was
structural; after the change the exact exceptional locus — and therefore the
final clause of a headline theorem — is the output of a Groebner elimination.
The claim is no longer defensible under any reading.

**(b) No sentence of the manuscript discloses the trust level.**
`grep -n "Singular\|trusted\|certificate" sections/*.tex cubic_stabilization_epilogue.tex`
returns nothing. The proof of `prop:A5-not-coprime` presents the computation as
plain mathematics (`sections/03-minimal-class.tex:511-514`):

> Saturating that ideal by the irrelevant ideal and eliminating the five
> coordinates gives \(b(b^2+3b+9)\), and doing the same for the Jacobian ideal
> alone gives the pencil's discriminant \(b(b+6)(b^2-3b-9)(7b^2+3b+9)\)

The style guide is explicit: "Say whether the claim is certificate-checked,
independently reproduced, or trusted as an execution," and requires the body to
carry enough to understand completeness. `evidence.json` correctly records
"trusted as an execution of Singular rather than certificate-checked"; the paper
does not. A referee reading only the manuscript cannot see the boundary.

**(c) The dependency graph has no path from the bundle to the theorem.**
`verification/dependency-graph.dot` records
`"a5-pencil-eckardt-locus" -> "prop:A5-not-coprime"` and
`"prop:A5-not-coprime" -> "prop:A5-nonseparated"`, but the only edge touching the
theorem is `"thm:separation-family" -> "prop:A5-not-coprime"` — the reverse
direction, inherited from the proof-level `\uses{lem:eckardt-rank,
thm:separation-family}` at `sections/03-minimal-class.tex:542`.
`thm:separation-family` carries no `\evidence` and its proof carries no `\uses`.
The graph therefore asserts, wrongly, that the headline theorem depends on no
computation.

**Required:** rewrite `verification/README.md:3-4` to state what is structural
and what is a trusted Singular execution; add one sentence to the body (in
`sections/03-minimal-class.tex`, at the elimination, or in the introduction's
verification paragraph) naming the trust category; add `\evidence` and/or the
missing `\uses` so the graph shows the dependency. Note that adding
`prop:A5-nonseparated -> thm:separation-family` while
`thm:separation-family -> prop:A5-not-coprime` stands makes the recorded graph
cyclic — the `B^\circ` reference in the proposition's proof should be detached
from the theorem first.

## 3. BLOCKER — `rem:four-dimensional-factor` contradicts itself and, read literally, closes the route it is introduced to keep open

**Location:** `sections/02-envelope.tex:699-706`.

> Consequently the four-dimensional factor has determinant \(25\) and
> polarization type \((1,1,1,5)\); it is not principally polarized.  Its
> discriminant group is canonically \(E[5]\), glued to that of the elliptic
> factor, and every subgroup of order five is isotropic, so the factor has
> exactly six principal polarizations, one for each of the six order-five
> subgroups of \(E[5]\).

"it is not principally polarized" and "the factor has exactly six principal
polarizations" cannot both describe the same object. The reasoning quoted —
isotropic order-five subgroups of the discriminant group — is the standard
descent construction, which produces six *principally polarized abelian
fourfolds isogenous to* the factor (the quotients by those subgroups), not six
principal polarizations on the factor itself. The remark names the wrong object.

This propagates into both rewritten sentences, which is why it is a blocker
rather than a wording slip. `sections/01-introduction.tex:345-347`:

> That would need both
> of the routes left open there to fail: no principal polarization of the
> four-dimensional factor of Proposition~\ref{prop:no-elliptic-product} may make
> it the Jacobian of an irreducible curve of genus four

and `sections/02-envelope.tex:675-679` likewise ("some principal polarization of
the four-dimensional factor of the second case may make it the Jacobian"). A
Jacobian is principally polarized. If the factor genuinely has no principal
polarization, as the remark states two sentences later, then route one is
*closed*, and the paper would be entitled to a stronger result than it claims.
Under the intended reading the route concerns the six quotients. As written the
manuscript says both things.

**Required:** decide which object route one is about, say so in one sentence,
and make the remark, the introduction, and the envelope discussion agree. "Six
principal polarizations" must become "six principally polarized abelian
fourfolds isogenous to it, one for each order-five subgroup of `E[5]`" or
equivalent.

## 4. SHOULD-FIX — `rem:four-dimensional-factor` asserts most of its content bare, with no proof, no computation pointer, and no annotation

Taking the claims in order, with what I could check:

| claim | status |
|---|---|
| `N = v^\perp = {x in Z^5 : sum x_i = 0}` with form `6<x,y>`, six times `A_4` | **derivable and correct**, granting the stated basis |
| splitting over `Z_2` and `Z_3` since 5 is a unit | **correct** |
| "the whole discriminant group is carried by `N`" | **correct** at 2 and 3, which is all that is used |
| `[Lambda : Zv + N] = 5` | **correct** |
| the four-dimensional factor has determinant 25, type `(1,1,1,5)` | **unsupported** |
| discriminant group canonically `E[5]`, glued to the elliptic factor | **asserted bare** |
| every order-five subgroup isotropic | correct, and trivially so (the pairing is alternating) |
| exactly six principal polarizations | **wrong object** (finding 3); "exactly" also unsupported |
| `D_5` acts through `\pm1` and fixes all six | **asserted bare**; given `\pm1`, "fixes all six" is immediate |

The first paragraph checks out and is internally consistent in a way that is not
automatic: if the five remaining axes are a basis with `kappa(v_i,v_i)=5`, the
form `6<x,y>` on the sum-zero sublattice forces `kappa(v_i,v_j) = -1`, and then
the sixth axis `-(v_1+...+v_5)` independently returns `kappa(v,v)=5` and
`[Lambda : Zv+N] = 5`. Good.

The second paragraph is where the problem is. "Consequently the four-dimensional
factor has determinant 25" does not follow from anything above it: `N` has rank
4 and determinant `6^4 * 5 = 6480`, whereas determinant 25 and type `(1,1,1,5)`
are statements about the alternating form on the rank-8 lattice of the abelian
fourfold `L cap (v^\perp \otimes M_Q)` from `prop:no-elliptic-product`. Those
are different lattices, and "Consequently" is carrying the entire passage
between them. The remark also uses "the four-dimensional factor" for both the
rank-4 lattice `N` ("the kernel ... lies inside the four-dimensional factor")
and the abelian fourfold, against the style guide's "Introduce one notation for
one role."

There is a tracked computation that presumably established some of this
(`notes/2026-08-19-c921-integral-glued-model.py`,
`notes/2026-08-19-c921-d5-genus-four-jacobians.py`), and the remark points at
none of it. Per `notes/formal-annotation-conventions.md`, `\evidence` records
the bundles a statement rests on; the remark carries no annotation of any kind.

Separately: **"whence the index \(25\) above" (`sections/02-envelope.tex:697`)
is a dangling back-reference.** `grep -n "25\b" sections/02-envelope.tex` finds
no occurrence of 25 earlier in the section. The reader is sent to a quantity
that is not there.

**Required:** either prove the determinant/type/discriminant-group chain or cite
the computation and register it as evidence; fix the dangling reference; stop
using one phrase for the lattice and the abelian variety.

## 5. SHOULD-FIX — "the pencil's discriminant" is the wrong object

**Location:** `sections/03-minimal-class.tex:513-515`, and
`verification/evidence.json` role text, and the claim-map cautions.

> doing the same for the Jacobian ideal
> alone gives the pencil's discriminant \(b(b+6)(b^2-3b-9)(7b^2+3b+9)\); both are
> squarefree.

The discriminant of a pencil of cubic forms in five variables is a binary form
of degree `5 * (3-1)^4 = 80`. What the elimination produces is the reduced locus
of singular parameters — the radical of the discriminant — a degree-6 polynomial.
Calling it "the discriminant" is a factual misstatement, and it invites a
referee to check a degree that will not match.

"both are squarefree" is decorative: nothing in the proof uses squarefreeness.
The coprimality argument in the next paragraph needs the two polynomials to
share no root, which is a different property.

**Required:** "the reduced locus of singular parameters", or "the radical of the
pencil's discriminant". Drop "both are squarefree" or say what it is for.

## 6. SHOULD-FIX — the elimination computes a closure; the proof never says so

**Location:** `sections/03-minimal-class.tex:508-513`.

> the parameters to be found are those for which the ideal generated by \(F_b\) and
> the three-by-three minors of its Hessian has a zero away from the origin.
> Saturating that ideal by the irrelevant ideal and eliminating the five
> coordinates gives \(b(b^2+3b+9)\)

Elimination gives the ideal of the Zariski *closure* of the projection, so the
displayed identification is `image ⊆ V(b(b^2+3b+9))` for free and the reverse
inclusion for nothing. The reverse is exactly the direction "Exactly two members
... carry an Eckardt point" needs.

It is true, and the fix is one sentence: the image is constructible by
Chevalley, its closure is finite, and a constructible subset of the affine line
with finite closure is finite hence closed, so image and closure agree. Without
it, a referee is entitled to say the proposition proves only "at most two".

Two related things that do **hold** and need no change, since they were the
obvious attacks:

- **Saturation by the irrelevant ideal is the right operation.** Over an
  algebraically closed field `V(I : J^\infty) = closure(V(I) \ V(J))`, so
  saturating by `(y_1,...,y_5)` removes exactly the zero section and nothing
  else, and by the argument above no spurious parameter survives. The script's
  docstring gets this right.
- **The Hessian is taken in legitimate coordinates.** `y_1..y_5` with
  `x_6 = -(y_1+...+y_5)` is a linear isomorphism onto the sum-zero subspace, and
  Hessian rank is invariant under linear change of coordinates
  (`H' = A^T H A`). Rank at most two transports. The 101 generators are `F`
  plus `C(5,3)^2 = 100` minors, as they should be.

## 7. SHOULD-FIX — the Fermat identification: one step is misstated and one citation over-reaches

**(a) `sections/03-minimal-class.tex:538-540`:**

> A conjugate of a form defined over \(\mathbf Q\) is
> projectively equivalent to it over \(\C\)

As literally written this is a triviality — the Galois conjugate of a form with
rational coefficients *is* that form — and it does not supply the step the proof
needs. `F_{3\omega}` is not defined over **Q**; it is defined over
**Q**(omega). The load-bearing statement is: if `X` is projectively equivalent
over **C** to a variety defined over **Q**, then so is every Galois conjugate of
`X`. That is true (apply sigma to the equivalence; the **Q**-form is fixed), and
it is what makes the two roots one moduli point. Rewrite it.

**(b) `sections/03-minimal-class.tex:506-507`:**

> They are the two
> Fermat members of Remark~\ref{rem:fermat-in-pencil}

`rem:fermat-in-pencil` (`sections/01-introduction.tex:186-205`) says:

> The pencil contains the Fermat cubic threefold; it is one of the two members
> that also admit the permutation action of \(A_5\)

That supplies **one** Fermat member, and its "two members" are the two admitting
the permutation action, of which the remark says only one is Fermat. The remark
does not contain "the two Fermat members"; that is the proposition's own
conclusion. The proof body gets this right — it derives the second member as a
Galois conjugate — so the fix is to stop attributing the conclusion to the
remark in the statement.

The argument the proof actually runs is sound: the Eckardt locus is `{0}` union
the two roots, `b=0` is singular, Fermat is a smooth member with an Eckardt
point, hence Fermat sits at a root. Good.

**(c) Model transport, unstated.** The `b` parameter lives in the six-point
model over **Q**; per `evidence.json` the Fermat form is exhibited in the
monomial model over **Q**(zeta_3). The proof moves "the pencil contains the
Fermat cubic threefold" between the two models without a word. One clause saying
the two models present the same pencil over **C** would close it.

## 8. SHOULD-FIX — seven sites still state the superseded "all but finitely many", including the abstract

The change updated the two propositions and the theorem and left everything that
describes them behind:

- `cubic_stabilization_epilogue.tex:94-95` (**the abstract**): "All but
  finitely many moduli points of this pencil lie outside the separated-variable
  locus covered by Colliot-Th\'el\`ene's criterion."
- `sections/01-introduction.tex:147`, the sentence immediately above the
  sharpened theorem: "all but finitely many moduli points represented by the
  pencil are not projectively equivalent to a cubic of separated-variable type."
- `sections/01-introduction.tex:331` and `:335`, the related-work survey, both
  "all but finitely many"; the second adds "the general member of the pencil
  carries none," which is now "every member but two".
- `sections/03-minimal-class.tex:619`: "All but finitely many moduli points of
  the pencil escape the separated-variable mechanism".
- `sections/06-synthesis.tex:43` (finding 1) and `:56`.

Plus two stale environment titles: `\begin{proposition}[Finite Eckardt locus]`
(`03:498`) and `\begin{proposition}[Finite separated-variable intersection]`
(`03:545`). Neither result is a finiteness statement any more.

Under the style guide's revision protocol ("Read only the theorem statements and
section openings. They should tell a coherent story"), the paper currently tells
two different stories.

## 9. SHOULD-FIX — the computation-free fallback no longer matches the statement it is attached to

**Location:** `sections/03-minimal-class.tex:574`.

> The order-three signatures give the same finiteness by a route that uses no
> computation.

It is no longer "the same". The signature route proves finiteness;
`prop:A5-nonseparated` now proves exactly one point. The value of the paragraph
— that the weaker conclusion survives without the registered computation — is
real and worth keeping, but the sentence must say that it gives *less* than the
proposition, so a reader knows precisely how much of the sharpened statement is
computation-dependent. This matters more after the change than before, because
the computation-dependent part is now load-bearing for the headline theorem
(finding 2).

The same defect is copied into the claim map: `prop:A5-nonseparated`'s
`hypotheses` field still reads "the order-three signature route printed after
the proof gives the same finiteness without any computation," while its
`conclusion` field was rewritten to "Exactly one moduli point".

## 10. SHOULD-FIX — claim-map rows: stale `hypotheses`, and a regression in `thm:separation-family`'s `cautions`

**(a) `lean/verification/claims.json`, `prop:A5-not-coprime`.** The `conclusion`
and `cautions` were rewritten; `hypotheses` was not, and still reads:

> Smoothness of the members, the Eckardt criterion of the preceding lemma, and
> the computed emptiness of the Eckardt scheme of the members listed in the
> registered evidence bundle.

The new proof does not use the emptiness of the Eckardt scheme of a list of
members at all; it uses the elimination over the whole pencil. The row's
recorded hypotheses describe the deleted proof. The digest gate cannot catch
this — it pins the statement and the terminals, not the row's own prose.

**(b) `thm:separation-family`'s `cautions` lost audit content.** Deleted:

> The typed irrationality input is the broader framed one-step input recorded
> under thm:every-cubic-conditional and does not use the A5 symmetry; the
> manuscript now takes its irrationality from the unconditional atomic route
> instead. Of its four clauses, the fibrewise triviality clause and the
> stabilization clauses are compositions of supplied premises with results
> registered elsewhere, and the non-isotriviality clause is the supplied
> predicate itself; the only clause consuming a nontrivial Lean argument is the
> irrationality one, through the one-step theorem.

None of that is implied by the new text, and it is exactly the kind of per-clause
audit the layer exists to carry. It should be restored alongside the new
separation-clause note.

What replaced it introduces a second problem: "since 2026-08-19 it is strictly
weaker than the manuscript statement" and "so the row is a fragment rather than a
conditional deduction until that field is sharpened" put a date-stamped timeline
and an open to-do into what is supposed to be a current-state record. State that
the Lean statement carries the finiteness shape and the manuscript names the
Fermat point; the pending work belongs in the task card.

The coverage move `conditional_deduction -> fragment` is itself right and
correctly propagated to `01-introduction.tex:151`, `dependency-graph.dot`, and
both README snapshots. The gate passes:
`PASS mode=source-only ... evidence=3 coverage={'absent': 3, 'complete': 1, 'conditional_deduction': 27, 'fragment': 28}`.

## 11. SHOULD-FIX — the evidence entry over-claims its cross-checks

`verification/evidence.json`, `a5-pencil-eckardt-locus.role`, and the matching
`cautions` in the claim map:

**(a) The `F_32003` cross-check has no tracked artifact.** The role says "the
same eliminations over F_32003 return the same Eckardt polynomial and the same
factor shape for the discriminant", and the claim map says "the registered
bundles record two independent cross-checks". Neither
`verification/a5-pencil-eckardt-locus.sha256` (three files, all from the run over
**Q**) nor `notes/2026-08-19-c921-pencil-tests.sha256` (seven files, none over
`F_32003`) contains any output of that run. It exists only as a prose sentence at
`notes/2026-08-19-c921-pencil-level-structure-and-eckardt.md:115` and `:235`.
`notes/research-reproducibility-conventions.md` is explicit that a claimed run is
never evidence. Either track the output or delete the claim.

**(b) The finite-field sweep is described as more than it is.** The role says the
enumeration over `F_11, F_19, F_29, F_31, F_41` "finds the same two loci". It
enumerates `P^4(F_q)` and therefore finds only `F_q`-rational Eckardt points; at
`q=11` and `q=29` it finds none at all, because `b^2+3b+9` is irreducible there
(`notes/2026-08-19-c921-pencil-eckardt-sweep.txt`). It corroborates the reduction
mod p, which is worth having, but "finds the same two loci" overstates a
rational-point count.

**(c) No toolchain version.** The replay command is
`nix shell nixpkgs#singular --command Singular -q ...` with no pin. The style
guide requires "toolchain version ... and archival version" for a trusted
execution. This matters here in a concrete way: see finding 12(c).

## 12. SHOULD-FIX — defects in the tracked artifacts themselves

Checksums verify and the generator reproduces the `.sing` byte-for-byte
(`sha256sum -c` passes; regeneration diffs clean). The problems are elsewhere.

**(a) The tracked `.sing` names a generator outside the paper.**
`verification/a5-pencil-eckardt-locus.sing:3` reads

> // notes/2026-08-19-c921-eckardt-elimination.py

while the registered generator is `verification/a5_pencil_eckardt_locus.py`. The
two differ only in their docstrings. `notes/formal-annotation-conventions.md`
requires that "every file the manuscript or its gate needs must live inside" the
paper directory, since the standalone export copies only that directory. A
replayer following the artifact's own header lands outside it.

**(b) The output's legend contradicts its own numbers.** The `.txt` prints

> dimension of its singular locus (-1 empty, so smooth):
> -2

and the same mismatch for the Eckardt scheme. Singular returns `-1` for the
dimension of the unit ideal, so an empty projective scheme prints `-2` after the
`- 1`. The value is right and the legend is wrong. A reader auditing the
certificate cannot tell whether `-2` means empty or means something went wrong —
which is the whole job of the legend. Fix the legend (or drop the `- 1`).

**(c) About 130 of the ~150 lines of the tracked certificate are
`// ** redefining ...` warnings** emitted by `LIB "primdec.lib";`. The script
calls no primary-decomposition routine — `sat` comes from `elim.lib`, `minor`
and `factorize` are builtins — so that library appears to be unused. Dropping it
would make the certificate readable and, more importantly, much less brittle:
as it stands the tracked SHA-256 changes on any Singular library update, for
reasons having nothing to do with the mathematics. Worth confirming the run
still works without it before removing.

**(d) JSON formatting.** The new `a5-pencil-eckardt-locus` block in
`evidence.json` is indented at 3/1 spaces against the file's 4/6, so the diff
shows the neighbouring `a5-pencil-eckardt` key as changed when only its position
moved.

## 13. MINOR — a loose end the sharpening creates and does not address

`prop:A5-not-coprime` now concludes "no other point is represented by a cubic
projectively equivalent to a member of the family of [YYZ]" — correctly hedged,
saying nothing about the Fermat point. But `rem:fermat-in-pencil` records that
"Yang--Yu--Zhu give that member an explicit degree-three unirational
parametrization \cite[Remark~3.6]{YYZ}". Whether the one exceptional moduli point
lies in the YYZ family is now the first question a referee will ask, and the
paper does not answer it. One sentence either way.

## 14. MINOR — the paragraph introducing the computation is superseded

`sections/03-minimal-class.tex:490-497`:

> The general member of the pencil carries no such point.  That is a
> computation, recorded in the evidence bundle named in the next proposition

This still advertises the older, weaker bundle (explicit members, empty Eckardt
scheme) and never mentions the elimination that now actually proves the
proposition. After the change it is orientation for a proof that no longer runs
that way. Either fold it into the new argument or cut it; the style guide's
"Delete repetition, throat-clearing" and "Preserve hierarchy" both apply.

## 15. MINOR — "wholly human proof spine"

`verification/README.md:3`. A trust boundary should name what is structural
argument and what is a trusted program execution. Labelling the proofs by who
wrote them tells a reader nothing about what is checked, and it is what made the
sentence in finding 2(a) survive a change that falsified it.

---

## What I checked and found sound

Stated briefly so these are not re-litigated.

- **Coprimality (attack 3) holds; verified by hand.** `b^2+3b+9` against each
  factor of `b(b+6)(b^2-3b-9)(7b^2+3b+9)`: at `b=0` it is `9`; at `b=-6` it is
  `36-18+9=27`; against `b^2-3b-9` the difference is `6(b+3)` and at `b=-3` it is
  `9`; against `7b^2+3b+9` the combination `7(b^2+3b+9)-(7b^2+3b+9)` is `18(b+3)`,
  same conclusion. No common root, so both Eckardt members are smooth. The
  identification of the roots as `b = 3\omega` is also right:
  `(-3 \pm 3i\sqrt3)/2 = 3 \cdot (-1 \pm i\sqrt3)/2`.
- **Excluding `b=0` (attack 2) is argued correctly.** `X_0` is singular, hence
  not in `B^\circ`, hence not a candidate for "smooth member with an Eckardt
  point". Restricting `lem:eckardt-rank` to smooth members is legitimate: an
  Eckardt point is defined through the tangent hyperplane section, which needs
  smoothness at `p`, and the lemma's proof uses `L \neq 0` exactly there. Two
  small gaps: that `p_3` restricted to the sum-zero subspace *is* the Segre cubic
  is stated nowhere in the manuscript, and its singularity is asserted without
  citation. Both are standard; one clause each would close them.
- **Both inclusions of `prop:A5-nonseparated` (attack 5) are established.**
  `\subseteq` runs through `lem:eckardt-rank`, whose proof does cover the
  separated-variable case explicitly (`03:469-479`, including the `3,1,1` and
  `1,1,1,1,1` partitions), into `prop:A5-not-coprime`; `\supseteq` is the Fermat
  form as five singleton groups. This one is clean.
- **The elimination's construction is right** in the two ways attacked:
  saturation by the irrelevant ideal, and the Hessian in `y_1..y_5`. See
  finding 6.
- **The lattice arithmetic in the remark's first paragraph is correct**, and
  internally consistent in a nontrivial way. See finding 4. `E[5]` does have
  exactly six order-five subgroups, and all are isotropic for an alternating
  pairing.
- **The gate passes and the coverage snapshots agree** across
  `lean/README.md`, `verification/README.md`, and `claims.json`. Which is the
  point of finding 8: every defect above lives in prose the digests do not
  cover, and `notes/formal-annotation-conventions.md` names that blind spot
  ("The digests cover theorem-like environments and terminals, not the prose
  between them"). This change is a live instance of it.

---
---

# Second pass — 2026-08-19, against commits `d7553b2be` and `da7ec8e8f`

Same hostile standard. Re-review of the committed state: `d7553b2be` (the
response to the nine first-pass findings, including the revert of
`thm:separation-family`) and `da7ec8e8f` (removal of task IDs and internal-note
paths from the generator and its certificate). The first pass above is
unmodified.

## Verdict

Six of the nine findings are genuinely closed, and two of the closures are
better than what I asked for: the Chevalley paragraph is correct and sufficient,
and the rewritten `rem:four-dimensional-factor` now carries a determinant
derivation that I checked line by line and that is right — including the index
25, which I had doubted. Finding 1 did dissolve; the theorem, its coverage, its
claim-map row and its proof are back to the pre-change state and no section
prose ties the theorem to the Fermat point. But three things did not get fixed
and one got worse. `verification/evidence.json` was not touched at all, so the
first pass's findings 11 and 12(d) stand untouched and the registry now
contradicts the body it registers: the proof says the eliminated ideal is "the
radical of the pencil's discriminant rather than the discriminant itself" while
the registry still calls it "the pencil's discriminant", and the registry `note`
is now the one remaining place in the repository that says the elimination
"locates the single exceptional point of the separation theorem" — a dependency
the revert was performed to remove. `da7ec8e8f` cleaned the artifact's
provenance but, by dropping both cross-check citations without tracking the
runs, left a three-link chain — proof body, registry, docstring — each asserting
that two independent cross-checks are recorded and none reaching an artifact a
referee can open. The new `verification/README.md` boundary paragraph is the
right idea and makes three claims that do not survive checking: that the
boundary is "visible from the manuscript" (the `\evidence` macro is
typographically empty, so it is visible only in the source), that exactly two
statements invoke a computation (`thm:separation-family` inherits one through
its own printed proof), and that no irrationality statement rests on one
(`thm:every-cubic-conditional` does, through the framed route). None of this is
caught by `make check`, which passes.

Gate at both commits: `PASS mode=source-only sources=139 terminals=283
manuscript_claims=59 machinery=46 imported_sources=23 evidence=3
coverage={'absent': 3, 'complete': 1, 'conditional_deduction': 28,
'fragment': 27}`. Checksums verify and the generator reproduces the `.sing`
byte-for-byte.

---

## A. Closed

**Finding 1 — dissolved, correctly and completely.** Verified against the
committed tree, not against the commit message. `sections/01-introduction.tex:153`
carries `\coverage{conditional_deduction}`; the statement's last sentence is
again "All but finitely many points of its coarse-moduli image are not
represented by cubics whose defining form is a sum of cubic forms in disjoint
groups of at most three variables"; `sections/06-synthesis.tex:42-44` still ends
"Proposition~\ref{prop:A5-nonseparated} shows that all but finitely many points
of this moduli curve lie outside the separated-variable locus", which is now
adequate for what it proves; the claim-map row and both coverage snapshots (27
fragmentary, 28 conditional) are unchanged from the pre-change state.
`grep -rn "Fermat" sections/` finds no site where the theorem is said to name the
Fermat point. The one exception is outside `sections/` and is finding N1 below.

**Finding 3 — closed.** The object is now named correctly and the three sites
agree. `rem:four-dimensional-factor` now says "The second case of the
proposition therefore admits exactly six principally polarized abelian
fourfolds, each five-isogenous to the intrinsic factor, one for each order-five
subgroup of \(E[5]\)", and the self-contradiction is gone: the intrinsic factor
is not principally polarized, and the six are different varieties.
`sections/02-envelope.tex:675-681` now reads "a four-dimensional factor of the
second case may be the Jacobian" with "Both are open", and adds "the second case
admits six of them, and the intrinsic factor they are isogenous to is not one".
`sections/01-introduction.tex:345-346` reads "no four-dimensional factor admitted
by Proposition~\ref{prop:no-elliptic-product} may be the Jacobian of an
irreducible curve of genus four". The genus-four route reads as open. Two
residual nits are in finding B4.

**Finding 5 — closed in the manuscript body**, not in the registry; see C1.
`sections/03-minimal-class.tex:512-514` now reads "whose zero set is the reduced
locus of singular parameters, that is the radical of the pencil's discriminant
rather than the discriminant itself", and "both are squarefree" is gone. Right
fix.

**Finding 6 — closed, and the added argument is correct and sufficient.**

> Elimination computes the ideal of the Zariski closure of the projection, so
> this identifies the set of parameters sought only up to closure.  Here the two
> agree: the set is constructible by Chevalley's theorem, its closure is finite,
> and a constructible subset of the affine line with finite closure is itself
> finite, hence closed.

That is exactly the missing step, stated at the right length, and it gives the
reverse inclusion the "exactly two" claim needs. Nothing to add.

**Finding 7 — closed on all three sub-points**, with one residual gap (B3). The
statement no longer attributes two Fermat members to `rem:fermat-in-pencil`
("Both are projectively equivalent over \(\C\) to the Fermat cubic threefold");
the proof cites the remark only for what it says ("the pencil contains the
Fermat cubic threefold"); the model-transport clause is present ("the two models
of the pencil used there and here present the same pencil over \(\C\)"); and the
Galois step is now stated in the form that carries weight:

> Now if a variety is
> projectively equivalent over \(\C\) to one defined over \(\mathbf Q\), so is
> each of its Galois conjugates: apply \(\sigma\) to the equivalence and use that
> \(\sigma\) fixes the \(\mathbf Q\)-form.

**Finding 9 — closed.** `sections/03-minimal-class.tex:591` now reads "The
order-three signatures give finiteness, though not the exact locus, by a route
that uses no computation", and the paragraph's closing sentence now draws the
line where it belongs: "The finiteness of the separated-variable locus therefore
does not depend on the registered computation; identifying that finite set as
the single Fermat point ... does." `prop:A5-nonseparated`'s claim-map
`hypotheses` was updated to match. The sibling row was not; see B5.

**Finding 10(b) — dissolved.** `thm:separation-family`'s claim-map row is
byte-identical to the pre-change state, so the deleted per-clause audit prose
and the dated to-do are both gone.

**Finding 12(a) — closed.** The `.sing` banner now reads "Generated file; do not
edit.  Its generator is verification/a5_pencil_eckardt_locus.py", which lives
inside the exported directory. See D3 for the banner's adequacy.

---

## B. Not closed, or closed with a residue

### B1. BLOCKER — the two cross-checks are now unreachable, and three places assert they are recorded

The proof body, newly added at `sections/03-minimal-class.tex:515-518`:

> the registered evidence bundle records
> the replay commands and two independent cross-checks.

`verification/evidence.json`, unchanged:

> Two independent cross-checks are recorded: the same eliminations over F_32003
> return the same Eckardt polynomial and the same factor shape for the
> discriminant, and a separate enumeration of P^4(F_q) over F_11, F_19, F_29,
> F_31 and F_41, sharing no code with this script, finds the same two loci

Neither is reachable. `verification/a5-pencil-eckardt-locus.sha256` lists three
files, all from the run over **Q**; there is no `F_32003` output anywhere in the
repository, tracked or otherwise. The enumeration over the five small fields
exists as `notes/2026-08-19-c921-pencil-eckardt-sweep.py` and its tracked output,
but `da7ec8e8f` deleted the only pointers to it, so nothing in the paper
directory names it. `notes/research-reproducibility-conventions.md` is explicit
that a claimed run is never sole evidence for a paper-facing result.

This is worse after `da7ec8e8f`, not better. Before it, a reader inside the
repository could follow the docstring to the sweep. Now the manuscript tells a
referee the bundle records two cross-checks, the bundle repeats it, and the
docstring says the agreement "is recorded here as a statement about the
mathematics, not as a dependency" — which is candid about its status but does not
rescue the two claims upstream of it that say "recorded".

**Required:** either move the sweep script and its output (and an `F_32003` run)
into `verification/` and into the checksum manifest, or delete the cross-check
sentence from `evidence.json` and from the proof body. The middle course —
claiming cross-checks that exist only in the author's working notes — is the one
option that should not survive.

Two accuracy problems in the same sentence, also unfixed from the first pass:
the enumeration finds `F_q`-**rational** Eckardt points, not "the same two
loci"; and at `q=11` and `q=29` it finds none at all, because `b^2+3b+9` is
irreducible there. And no Singular version is recorded anywhere, against the
style guide's "toolchain version ... archival version" for a trusted execution.

### B2. SHOULD-FIX — the new `verification/README.md` boundary paragraph makes three claims that do not check out

The rewrite is the right move and mostly good. Three problems.

**(a) "so the boundary is visible from the manuscript and not only from here" is
false for a reader of the PDF.** `formal-annotations.tex:40,43` define
`\coverage` and `\evidence` as `\newcommand{...}[1]{}` — typographically empty,
as `notes/formal-annotation-conventions.md` requires. A referee reading the
rendered paper sees no `\evidence` mark anywhere. What such a referee *does* see
is the new sentence in the proof of `prop:A5-not-coprime`, which is the real
mechanism and is not what the README points at. Say "visible in the source, and
in the manuscript at the proof of `prop:A5-not-coprime`", or point at the proof
sentence.

**(b) "Exactly two statements invoke one" omits `thm:separation-family`.** The
README continues "`prop:A5-not-coprime` ... and through which
`prop:A5-nonseparated` inherits the dependency". By the same inheritance, the
printed proof of `thm:separation-family` (`06-synthesis.tex:42-44`) cites
`prop:A5-nonseparated`, whose printed proof runs through `prop:A5-not-coprime`
and the elimination. The theorem therefore inherits it too. The escape is real —
the order-three signature route gives the theorem's finiteness with no
computation — but the theorem's proof does not cite that route, so as printed
the chain runs through the elimination. Either point the theorem's proof at the
signature paragraph, or say the theorem inherits the dependency and is
independently obtainable without it.

**(c) "No irrationality statement ... rests on any of them" is contradicted by
the paper's own framing.** `lem:hirzebruch-euler-spectrum` carries
`\evidence{hirzebruch-euler-spectrum}` (`05-framed-monodromy.tex:822`) and is a
lemma of the framed route, which `cubic_stabilization_epilogue.tex:87` describes
as "giving a second proof of the theorem" and which
`01-introduction.tex:241-243` describes as reproving the one-step conclusion,
landing on `thm:every-cubic-conditional`, "One-step irrationality from the framed
invariant". That is an irrationality statement. The sentence should read "No
irrationality statement on the unconditional atomic route rests on any of them;
the conditional framed route's second proof does."

**(d) The exhaustiveness is unsupported by the recorded layer, and the README
says so eighty lines later.** The opening paragraph asserts a negative
reachability fact about the whole manuscript. `dependency-graph.dot` has **no
outgoing edge from `lem:hirzebruch-euler-spectrum` at all**, and
`verification/README.md:99-101` states "Dependency edges are currently recorded
for the atomic route of Section 4 and the proof of the one-stabilization
theorem; a statement carrying no edge has none recorded rather than none." So
the recorded data can neither confirm nor refute the new opening claim. That is
allowed, but the opening should say the enumeration is the author's reading of
the proofs rather than a fact read off the graph.

### B3. SHOULD-FIX — the Galois step still needs σ to act on **C**

`sections/03-minimal-class.tex:536-541`. σ is introduced as "the nontrivial
element \(\sigma\) of \(\operatorname{Gal}(\mathbf Q(\sqrt{-3})/\mathbf Q)\)",
and the next sentence says "apply \(\sigma\) to the equivalence". The
equivalence is a **C**-linear change of coordinates; an automorphism of a
quadratic number field does not act on it. One clause fixes this: either choose
an extension of σ to an automorphism of **C**, or note that the projective
equivalence may be taken over \(\overline{\mathbf Q}\). As printed the step is
one symbol short of well defined.

Related, smaller: "the two models of the pencil used there and here present the
same pencil over \(\C\)" is asserted. It follows in one clause from what the
paper already proved — the invariant cubic space is two-dimensional and \(W_5\)
is irreducible, so any two models differ by an \(A_5\)-equivariant isomorphism,
unique up to scalar by Schur — and would cost nothing to say.

### B4. SHOULD-FIX — `rem:four-dimensional-factor`: the derivation is right, one step is elided, and three smaller things

I checked the whole chain independently and **it is correct**, which corrects my
first-pass suspicion about the index. Recorded here so it is not re-litigated,
using `sections/02-envelope.tex:554-566` for the definitions
(\(\Lambda=\mathbf Z^\Omega/\mathbf Z\mathbf 1\) with \(\kappa\) of matrix
\(6I_6-J_6\), \(M=H_1(E,\mathbf Z)\), \(L=H_1(J,\mathbf Z)\),
\(\Lambda\otimes M\subseteq L\) with quotient \(\ker f\), polarization form
\(\kappa\otimes\)(symplectic form of \(M\))):

- images of \(e_1,\dots,e_5\) are a basis of \(\Lambda\) with \(e_6=-(e_1+\dots+e_5)\),
  \(\kappa(e_i,e_i)=5\), \(\kappa(e_i,e_j)=-1\), so \(\det\Lambda=\det(6I_5-J_5)=6^4=1296\);
- \(N=v^\perp=\{\sum x_i=0\}\) with form \(6\langle\,,\rangle\), and \([\Lambda:\mathbf Zv+N]=5\), both as stated;
- \(\det(\Lambda\otimes M)=(\det\Lambda)^2=1296^2\), so \(L\) unimodular forces \([L:\Lambda\otimes M]=1296\);
- the first paragraph's "the kernel ... lies in \(N\otimes M\)" is what makes \(L_1=\mathbf Zv\otimes M\), and it is stated;
- \([\Lambda\otimes M:(\mathbf Zv\otimes M)\oplus(N\otimes M)]=25\), so \([L:(\mathbf Zv\otimes M)\oplus(N\otimes M)]=1296\cdot25=32400\), and \([L_4:N\otimes M]=|\ker f|=1296\), giving \([L:L_1\oplus L_4]=32400/1296=25\);
- \(\det L_1=25\), so \(\det L_1\cdot\det L_4=1\cdot25^2\) gives \(\det L_4=25\);
- \(\det L_4=25\) on rank eight forces polarization type \((1,1,1,5)\); \(\operatorname{disc}L_1=M/5M=E[5]\); the discriminant pairing is alternating so cyclic subgroups are isotropic; each of the six order-five subgroups gives an overlattice of determinant \(25/25=1\).

All correct. The problems are in the presentation.

**(a) One step is elided.** "\([\Lambda:\mathbf Zv+N]=5\), and tensoring with the
rank-two lattice \(M\) squares that to \(25\)" computes an index inside
\(\Lambda\otimes M\); the next paragraph uses \([L:L_1\oplus L_4]=25\), an index
inside \(L\). They agree only because the passage from \(\Lambda\otimes M\) to
\(L\) enlarges the \(N\)-summand alone, which is the first paragraph's kernel
claim. A referee has to reconstruct that; one clause would supply it.

**(b) "A rank-eight alternating lattice of determinant \(25\) has elementary
divisors \((1,1,1,5)\)" conflates two things.** Its elementary divisors are
\(1,1,1,1,1,1,5,5\); \((1,1,1,5)\) is the polarization type. Say type.

**(c) "acts on \(\operatorname{disc}L_4\) through \(\pm1\), since it preserves
\(N\) and acts trivially on \(M\)" — the stated reason proves more than the
stated conclusion.** If \(D_5\) is trivial on \(M\) then it is trivial on
\(\operatorname{disc}L_1=M/5M\) and, through the equivariant gluing, on
\(\operatorname{disc}L_4\). "Trivially" is both stronger and simpler than
"through \(\pm1\)"; as written the reader cannot tell whether the hedge is
deliberate.

**(d) "exactly six" counts overlattices, and the genus-four question is about
isomorphism classes.** Six unimodular overlattices, yes. Whether they give six
pairwise non-isomorphic principally polarized fourfolds is not addressed; the
\(D_5\)-invariance rules out an identification from the symmetry and nothing
else. "At most six, and exactly six unless two coincide" is the checkable claim.

**(e) Unreconciled with the proposition it serves.** The proof of
`prop:no-elliptic-product` builds its second-case factors by shrinking each
summand so that "both forms \(m\) times a unimodular one"; the remark's
\(L_4=L\cap(N_{\mathbf Q}\otimes M_{\mathbf Q})\) is the intrinsic abelian
subvariety. Whether the proposition's constructed factor is one of the six or
merely isogenous to them is the first thing a referee will ask, and the remark
does not say.

### B5. SHOULD-FIX — `prop:A5-not-coprime`'s claim-map `hypotheses` was not updated

First-pass finding 10(a) is still open. `lean/verification/claims.json`, the row
for `prop:A5-not-coprime`, `hypotheses`, unchanged:

> Smoothness of the members, the Eckardt criterion of the preceding lemma, and
> the computed emptiness of the Eckardt scheme of the members listed in the
> registered evidence bundle.

The `conclusion` and `cautions` of the same row were rewritten and the statement
digest refreshed to `74ad7b50...`; only `hypotheses` was left. The new proof does
not use the emptiness of the Eckardt scheme of a list of members — that bundle is
now corroboration — it uses the elimination over the whole pencil. The sibling
row's `hypotheses` was updated in the same commit, so this is an omission rather
than a decision.

Two smaller things in the same row: `conclusion` says "they are the two Fermat
members", the phrasing the manuscript statement deliberately dropped; and
`cautions` says "argued in the manuscript from Remark rem:fermat-in-pencil",
which is now accurate for the proof but reads as though the statement still
attributes it there.

### B6. SHOULD-FIX — three "all but finitely many" citations now understate the propositions they name

With the theorem reverted, the theorem-level sites are consistent and correctly
left alone. These three are proposition-level and are not:

- `sections/01-introduction.tex:331`: "Proposition~\ref{prop:A5-nonseparated}
  shows that all but finitely many moduli points on that pencil lie outside the
  separated-variable locus covered by \cite{CT}." Three lines below,
  `01:334-335` was updated to "Proposition~\ref{prop:A5-not-coprime} places every
  moduli point of that pencil except the Fermat point outside the explicit
  family". One paragraph, two propositions, cited at two different strengths.
- `sections/03-minimal-class.tex:634-636`: "All but finitely many moduli points
  of the pencil escape the separated-variable mechanism of \cite{CT} by
  Proposition~\ref{prop:A5-nonseparated} and the explicit family of \cite{YYZ}
  by Proposition~\ref{prop:A5-not-coprime}" — immediately after the section
  proved the sharper statement.
- `sections/06-synthesis.tex:55-58`: "by Proposition~\ref{prop:A5-nonseparated},
  for all but finitely many moduli points of the \(A_5\)-curve this universal
  \(CH_0\)-triviality is not accounted for".

None is false. All three name a proposition and then state less than it proves,
which is the reverse of the style guide's "State claims at their natural
strength".

Separately, the **abstract** (`cubic_stabilization_epilogue.tex:94-95`) still
says only "All but finitely many moduli points of this pencil lie outside the
separated-variable locus". With the theorem reverted this is defensible, but the
paper now proves that the exceptional set is the single Fermat point and the
abstract gives the reader no signal that it does. That is a deliberate call to
make, not an oversight to leave unmade.

### B7. MINOR — "prime to the discriminant" now sits awkwardly against the sentence that precedes it

`sections/03-minimal-class.tex:522-523`: "The roots of \(b^2+3b+9\) are prime to
the discriminant". Six lines earlier the proof made a point of distinguishing the
computed polynomial from the discriminant. Coprimality to the radical and to the
discriminant are the same condition, so this is not wrong, but naming "the
discriminant" here undoes the distinction just drawn. Say "prime to that
polynomial".

### B8. MINOR — line overrun in new prose

`sections/03-minimal-class.tex:591` runs to 96 columns against the file's
consistent ~76, because "though not the exact locus," was inserted without
rewrapping.

---

## C. New defects introduced by the fixes

### C1. SHOULD-FIX — `evidence.json` was not touched, and now contradicts the body it registers

The registry's `a5-pencil-eckardt-locus.role` still says:

> The same computation on the Jacobian ideal alone gives the pencil's
> discriminant b(b+6)(b^2-3b-9)(7b^2+3b+9).  Both eliminated ideals are
> squarefree.

The proof body now says the opposite about the first clause and dropped the
second. A registry entry whose job is to record what the bundle establishes now
disagrees with the manuscript sentence it backs. Fixing the body and not the
registry is the failure mode the annotation layer exists to prevent, and no gate
catches it because the registry's `role` is free prose.

Also still unfixed from the first pass: the entry's indentation is 3/1 spaces
against the file's 4/6, which is why the diff shows the neighbouring
`a5-pencil-eckardt` key as changed when only its position moved.

### C2. SHOULD-FIX — the registry `note` is now the only place tying the Fermat point to the separation theorem

`evidence.json`'s top-level `note`, added in `d7553b2be` and not revised when the
theorem was reverted:

> ... and the elimination determining the Eckardt locus and the singular locus of
> that pencil as a whole, which is what separates it from the explicit
> coprime-degree family of Yang, Yu and Zhu and which locates the single
> exceptional point of the separation theorem.

The separation theorem no longer names a single exceptional point. The
elimination locates the exceptional point of the two propositions. This is the
exact dependency the revert was performed to remove, surviving in the one file
that describes the computation's role. It should read "of
`prop:A5-not-coprime` and `prop:A5-nonseparated`".

### C3. MINOR — the graph edge at `thm:separation-family` now reads backwards

`prop:A5-not-coprime`'s proof still carries
`\uses{lem:eckardt-rank, thm:separation-family}` (`03-minimal-class.tex:580`),
and the rewritten proof uses the theorem only for the name \(B^\circ\). The graph
therefore records `"thm:separation-family" -> "prop:A5-not-coprime"`, showing the
theorem as an input to the proposition, while the printed logical dependency runs
the other way through `prop:A5-nonseparated` and is recorded nowhere. Detaching
\(B^\circ\) from the theorem (it is a two-word definition) would let the real
edge be added without making the graph cyclic, and would remove the reason the
README's enumeration in B2(b) reads as complete.

---

## D. The `da7ec8e8f` cleanup, judged on its own

### D1. The docstring does tell a referee what the script computes, the model, and both ideals — and it now asserts one thing it does not compute

On the coordinator's first question: yes, adequate. It states both eliminated
ideals up front, gives the model
(\(A_5=\mathrm{PSL}(2,5)\) on \(\PP^1(\F_5)\), the sum-zero subspace, \(T_1\) as
the orbit sum, the \(y\)-coordinatization), states each ideal and its saturation,
explains why the saturation is by \(\langle y_1..y_5\rangle\) and not the maximal
ideal, and gives the replay commands. It leans on nothing it no longer cites; the
one external pointer left is "the manuscript's lem:eckardt-rank", a stable
semantic label, which is the right kind of reference and resolves inside the
exported directory. Good.

One over-reach, new in this commit:

> The Eckardt locus comes out as b(b^2 + 3b + 9), whose
> factor b is the Segre cubic and is singular, so on the smooth locus of the
> pencil the Eckardt members are the conjugate pair b = 3 omega

The script computes `b(b^2+3b+9)`. That the factor `b` is the Segre cubic, that
it is singular, and therefore that the smooth Eckardt members are the conjugate
pair, are the manuscript's argument, not this script's output — and the Segre
identification is asserted without citation in both places. A referee-facing
artifact should not open by stating a conclusion it does not establish. Attribute
it: "the manuscript identifies the factor b as the Segre cubic".

### D2. SHOULD-FIX — the artifact carries no trust marker

Neither the docstring, nor the `.sing`, nor the `.txt` says anywhere that this is
a trusted execution rather than a certificate-checked computation. That statement
lives only in `evidence.json` and in the proof body. Under the referee-facing
standard the coordinator invoked — and given the new banner explicitly directs a
reader to the generator for documentation — the docstring is the natural home for
one sentence: a Gröbner elimination over **Q**, trusted as an execution, no
certificate produced. Its absence is more visible now that the docstring has been
rewritten to be self-contained.

### D3. The banner is adequate; two things it does not carry

> // Eckardt locus and singular locus of the nonstandard A_5-cubic pencil,
> // by elimination.  Generated file; do not edit.  Its generator is
> // verification/a5_pencil_eckardt_locus.py, which documents the model,
> // the two ideals, and the replay commands.

Names the object, marks the file generated, names an in-directory generator, and
says where the documentation is. That is what a generated-file header owes a
reader, and it fixes first-pass finding 12(a). It does not record the toolchain
version or the run date, which matters here because of D4.

### D4. SHOULD-FIX — first-pass findings 12(b) and 12(c) survived a regeneration

`da7ec8e8f` regenerated the `.sing` and reran Singular, so both were free.

**(b) The certificate's legend still contradicts its own numbers.** The tracked
`.txt` prints "dimension of its singular locus (-1 empty, so smooth):" followed
by `-2`, and the same for the Eckardt scheme. Singular returns `-1` for the
dimension of the unit ideal, so an empty projective scheme prints `-2`. The value
is right; the legend tells the reader the wrong number means empty.

**(c) 140 of the 168 lines of the certificate are `// ** redefining ...`
warnings** from `LIB "primdec.lib";`, which the script never uses — `sat` comes
from `elim.lib`, `minor` and `factorize` are builtins. The mathematics occupies
28 lines. This also makes the tracked SHA-256 hostage to any Singular library
update, which is the practical cost of D3's missing version pin.

---

## E. Checked and sound, second pass

Recorded so these are not reopened.

- The revert is complete and consistent across the statement, the annotation,
  the claim-map row, the proof, the dependency graph colouring, and both
  coverage snapshots. Nothing in `sections/` claims the theorem names the Fermat
  point.
- The Chevalley paragraph is correct and sufficient for the reverse inclusion.
- The determinant chain in `rem:four-dimensional-factor` is correct end to end,
  verified independently against the definitions at `02-envelope.tex:554-566`;
  see B4 for the working. \([L:L_1\oplus L_4]=25\) is right, which I had
  doubted.
- The Galois argument is now in the right form, modulo the extension of σ to
  **C** (B3).
- `\evidence` appears at exactly two sites, `03-minimal-class.tex:502` and
  `05-framed-monodromy.tex:822`, as the README claims; it is the reachability
  conclusions drawn from that, not the count, that fail (B2).
- Checksums verify, `python3 verification/a5_pencil_eckardt_locus.py` reproduces
  the tracked `.sing` byte-for-byte, and the eliminated ideals in the reran
  `.txt` are unchanged: `7b^6+24b^5-171b^4-432b^3-405b^2-486b` factoring as
  `b`, `b+6`, `b^2-3b-9`, `7b^2+3b+9`, and `b^3+3b^2+9b` factoring as `b`,
  `b^2+3b+9`.
- `make check`'s source-only gate passes at both commits, and again catches none
  of the above.
