# C756 — all-k conic-filling classification

**Lane**: `clebsch`

## Goal

Remove the \(k \le 8\) boundary from the conic-filling classification and prove, or
decisively fail to prove, the complete statement:

> For every \(k\) and every prime power \(q\), the only \(k\)-arcs in \(\mathrm{PG}(2,q)\)
> whose uncovered locus is the full point set of a nonsingular conic are the projective
> four-frame over \(\mathbb{F}_5\) and the Clebsch hexagon over \(\mathbb{F}_{11}\).

Quotable form: *deep-hole loci are conics exactly twice, ever.*

Optional stuck-state/review context:
`notes/clebsch-tasks/c756-proof-expert-dossier.md`.  Do not preload it during routine
continuation.

## Twelve-round autonomous continuation outcome (2026-08-09)

**This section supersedes the older “highest-EV next action” text below.**  The
full all-\(k\) theorem remains open, but the saturated-internal covering gate is
now substantially sharper and has new publishable partial theorems.

### New primary saturated gate

Put \(q=2m-1\) and let \(Y\) be a saturated-internal exterior arc of size
\(m+1\).  Under conic polarity, the points of \(Y\) become \(m+1\) passant
lines in dual-arc position.  Their pairwise intersections form an internal
star configuration \(\mathcal B(Y)\), and
\[
 Y\text{ covers every off-conic point}
 \quad\Longleftrightarrow\quad
 \mathcal B(Y)\text{ meets every secant and every passant}. \tag{A}
\]
Tangents automatically avoid \(\mathcal B(Y)\).  Thus one no longer needs to
classify or exclude every coherent equality support; it is enough to prove
that its star vertices miss one non-tangent line.  This is an
\((E\cup S)\)-blocking problem with much more structure than the general
minimum-size theory: every arrangement line contains its complete internal
half in \(\mathcal B(Y)\).

The exact line-profile identity
\[
 \sum_{j\ge1}(j-1)(j-2)a_j
 =\frac{m(m-2)(m-3)(m-5)}4 \tag{B}
\]
gives a new non-enumerative exclusion at \(q=7\).  Splitting the profile by
line type identifies the non-arrangement passant-pair count with
\(\sum_{A\in\binom Y4}r(A)\), where \(r(A)\) counts internal diagonal points
of the four-point quadrangle.  A certified \(q=9\) census gives the local law
\(r(A)=2\) for all 180 admissible quadrangles, contradicting the blocking
profile (independently, no saturated six-arc exists).

Define the diagonal character statistic
\[
 T_4(Y)=\sum_{A\in\binom Y4}(3-2r(A)).
\]
The full projective-plane incidence norm then proves the uniform necessary
condition
\[
 \boxed{
 T_4(Y)\ge
 \frac{m(m-2)(m-1)(m+1)}{8(2m-1)}>0
 } \tag{C}
\]
for every hypothetical covering support.  The naive local counterstatement
“coherent quadrangles have nonpositive bias” is false and is now closed by an
exact prime-field census: all diagonal types occur by \(q=17\), with positive
ambient coherent bias in several fields.  Any contradiction to (C) must use
global support compatibility.

### New global matching-frame gate

Switch the coherent support and let \(R\) be the outside-by-support block of
the signed elliptic-fusion matrix.  The global equality eigenvector gives
\[
 R\mathbf1=0,
 \qquad
 R^{\mathsf T}R=(m-2)((m+1)I-J). \tag{D}
\]
Every row is a signed matching vector
\[
 R_X=\sum_{(i,j)\in M_X}\pm(e_i-e_j),
\]
where \(M_X\) is the matching of chords through the outside internal point
\(X\).  Internal-point covering is exactly the assertion that every row is
nonzero.  At \(m=3\), these rows are the six roots of \(A_3\), explaining the
four-frame endpoint.  Abstract matching tight frames may exist for larger
\(m\); the open theorem concerns the conic-realizable subclass and must also
use the outside-external/secant-polar rows.

The unsigned star indicator also has the exact contraction
\[
 \mathbf1_{\mathcal B}=\frac12A\mathbf1_Y, \tag{E}
\]
where \(A\) is internal-point/passant-line incidence.  Equations (C)--(E),
not the earlier one-variable selector or \(p\)-adic lift, are the primary
saturated interface.

### Route decisions and current assessment

- The normalized pencil selector and its first two slices close back to the
  previously known matching/cycle gate.  Do not repeat that calculation.
- The signed passant incidence is switchable to symmetric or skew form and is
  integrally primitive in the tested Smith range; the hoped-for torsion
  obstruction is absent.  Its self-duality cocycle is structurally neat but
  not load-bearing for all-\(k\).
- Raw star cardinality and two generic moments stop after the \(q=7\)
  exclusion.  The useful continuation is the geometric two-species matching
  design, not more untyped moments.
- A focused source audit found no predecessor for (A), (C), or (D).  Cite the
  established \((E\cup S)\)-blocking literature and standard
  star-configuration ideals; claim novelty only for the structured conic-star
  consequences.  The adjacent 2025 blocking papers use different line
  families/properties and do not pre-empt these results.

Current subjective proof odds:

- complete saturated classification: **60--70%**;
- full all-\(k\) classification: **15--20%**, because the nonsaturated
  \(h\ge1\) theorem remains essentially unchanged;
- publishable specialist partial package even without closure: **85--90%**.

Current progress bars (mathematical closure, not drafting): saturated-external
`[##########] 100%`; saturated-internal `[######----] 60%`; nonsaturated
`[###-------] 30%`; full all-\(k\) assembly `[######----] 55%`.

**Highest-EV next action:** add the outside-external points to (D).  A covered
outside external point has a secant polar meeting the star vertices, hence a
second chord matching.  Derive the external-row frame and the mixed Gram with
the internal rows from the full projective incidence identity.  Continue only
if the mixed block supplies an identity independent of (B)--(E); stop if it is
just the secant/passant line-profile moments in matrix notation.  The parallel
nonsaturated action remains the masked Rédei theorem \(h\ge1\).

Durable round reports:

- `notes/2026-08-08-c756-normalized-pencil-selector.md`;
- `notes/2026-08-08-c756-self-dual-signed-incidence.md`;
- `notes/2026-08-08-c756-covering-dual-blocking.md`;
- `notes/2026-08-09-c756-star-discriminant-profile.md`;
- `notes/2026-08-09-c756-diagonal-type-allocation.md`;
- `notes/2026-08-09-c756-diagonal-character-ustatistic.md`;
- `notes/2026-08-09-c756-projective-incidence-cap.md`;
- `notes/2026-08-09-c756-local-diagonal-sign-stop.md`;
- `notes/2026-08-09-c756-outside-matching-tight-frame.md`;
- `notes/2026-08-09-c756-star-blocking-matching-frame-literature.md`.

## Reviewed publication route (2026-08-08)

**Decision:** replace the Paley-clique bound as the primary gate by equality in the
general binary passant incidence code.  For the nonsingular conic over odd \(q\), let
\(M_q\) be the passant-by-internal-point incidence matrix and
\(K_q=\ker_{\mathbb F_2}M_q\).  Droms--Mellinger--Meyer, Theorem 7.11, already proves
the elementary lower bound
\[
 d(K_q)\ge (q+3)/2,
\]
and the 2026-08-08 pass records the exact equality bridge: equality holds precisely
when the support is a \((q+3)/2\)-point internal arc whose pairwise joins are external.
Thus proving that, for \(q>3\), equality occurs only for \(q=5\), with the projective
four-frame, closes the saturated-internal branch.  The qualifier is real: \(K_3\) has
one equality word of weight three.  This target is
strictly more reusable than the crown formulation: it is intrinsic projective geometry,
connects directly to Paper IV's passant code, and does not require condition (A) or a
Paley normalization.

The second exact input recorded in that pass is the external-line triangle holonomy.
If three internal points on an external line are normalized by norm-minus-one roots
\(z_i\), then
\[
 \prod_{i<j}N(z_i-z_j)
 =\left(\frac{(z_1-z_2)(z_2-z_3)(z_3-z_1)}{z_1z_2z_3}\right)^2,
\]
and the factor in parentheses has Frobenius conjugate equal to its negative.  Its square
is therefore a nonsquare in \(\mathbb F_q\).  Consequently the orientation signs around
an external-line triple multiply to \(-1\); in particular, for \(q\equiv3\pmod4\), the
canonical extremal clique \(C_\ell\cup\{\ell^\perp\}\) cannot satisfy condition (A).
This is a useful exact exclusion, not by itself the classification.

**Bounded execution plan:**

1. **DONE:** prove the equality bridge and external-line orientation lemma in a dated
   reproducible note, check them in the smallest fields, and identify the Droms--
   Mellinger--Meyer attribution boundary.  See
   `notes/2026-08-08-c756-passant-code-equality.md` and its adjacent evidence bundle.
2. **DONE as a bounded discriminator:** fix an equality-support point \(P\) and use
   Paper IV's local Segre-tangent graph
   \(H_{q,P}\): its vertices are the internal passant-join neighbors of \(P\), and its
   edges impose both another passant join and the required tangent holonomy.  Equality
   requires a clique of size \((q+1)/2\).  Exact computation gives a strict gap for
   every tested \(q>5\), over all odd prime powers through \(49\), while \(q=5\) is
   sharp.  A numerical PSD completion gives bounds far below the forbidden target
   through \(q=19\), but the exact stabilizer-orbital completion grows from 3 variables
   at \(q=5\) to 101 at \(q=19\), with no stable dual support.  Paper IV's exact rank-28
   \(q=13\) matrix remains a field-specific prototype.  The pair-only elliptic scheme
   remains a comparison model:
   it loses the tangent/no-three-collinear information and cannot remove the
   \(q\equiv3\pmod4\) line-plus-pole cliques.
3. **STOP RULE TRIGGERED:** both promised certificate passes are spent.  The active
   support and certificate complexity grow with \(q\), so do not exactify the
   field-by-field theta optima or turn the numerical SDP pattern into a theorem.  Reopen
   this route only if a genuinely new closed-form feasible matrix or character
   inequality has bounded description independent of the orbital dimension.
4. Keep the equality classification and local graph as a clean open formulation, but
   route the next work to the publication fallback.  If a future equality proof lands,
   close the complete saturated classification and open a separate, unnumbered Clebsch
   companion-paper task; the live handoff fixes exactly four numbered papers.  The
   nonsaturated masked Rédei target \(h\ge1\) remains independent and necessary for the
   full all-\(k\) theorem.

**Publishable fallback — active scoping target:** the equality gate failed the bounded
stop rule, so scope a specialist partial-results companion after source audit: all-\(k\)
structural bounds,
the complete saturated-external classification, the code/crown reformulation, Baer
exclusion, mixed moments, and bounded-field evidence.  This fallback must state the
saturated-internal and nonsaturated gaps explicitly.  The present literature audit is
not publication-ready: the older Paley report predates the audit conventions, the
BEHW/Blokhuis chain is not source-complete, MathSciNet coverage is missing, and the
general passant-code equality cases require a focused predecessor check.  The immediate
deliverable is a theorem inventory and claim graph separating proved all-field results,
finite evidence, and open gaps, followed by a title/venue decision.  Do not draft a
manuscript under C756; after the audit, open a separate unnumbered companion task if the
package survives the novelty and coherence gate.

**Audit/scoping outcome (2026-08-08):** the package passes the specialist-paper
scope gate.  Established terminology calls condition (E) an **exterior set of a
conic**; C756's object is an exterior set that is also an arc.  The closest
Blokhuis--Seress--Wilbrink and Van de Voorde results concern exterior points of size
\((q+1)/2\), not internal points of size \((q+3)/2\), so they do not pre-empt the
internal equality problem.  The companion headline should nevertheless be the
complete extremal exterior-arc classification, not the elementary code bridge:
an exterior set of \((q+1)/2\) exterior points that is also an arc occurs only
for \(q\in\{3,7,11\}\), with one conic-stabilizer orbit in each field, and the
covering condition then selects the \(q=11\) Clebsch hexagon.  Include the
all-\(k\) LP bound and saturation dichotomy, then use the code bridge,
Baer-subline exclusion, and line holonomy as uniform internal partial results.  Omit
the negative-method catalogue and most mixed-moment machinery unless it shortens a
proof.  Primary venue fit: _Designs, Codes and Cryptography_; _Discrete Mathematics_
backup.  See
`notes/2026-08-08-c756-predecessor-audit-and-companion-scope.md`.

**Next-session entry:** turn the scoped package into a claim--proof--trust map and replay
the saturated-external classification end to end, including one explicit extension-field
audit.  Obtain the Droms--Mellinger--Meyer version of record and a human MathSciNet/Scopus
check if available; otherwise retain “to our knowledge” in the novelty ledger.  Preserve
the code equality and local tangent graph as open problems and diagnostic evidence; do not
spend another pass fitting optimal theta matrices or edit a manuscript under C756.

**Proof-trust/EJ outcome (2026-08-08):** the saturated-external theorem survives an
end-to-end dependency audit and a fresh \(q=27\) extension-field replay.  Its all-field
proof is human, not certificate-dependent.  Moreover, covering is not needed for the
strongest headline: the extremal exterior-arc hypothesis itself exhausts every passant
pencil and gives the perfect matching.  The \(q\equiv1\pmod4\) branch dies by the
complete-mapping group sum; the \(q\equiv3\pmod4\) branch runs through Segre sign
coherence, one-block Paley rigidity,
the primitive-Jacobi Frobenius collision theorem, a coset Weil exclusion of nontrivial
Frobenius, and the scalar Hasse endgame.  It leaves \(q\in\{3,7,11\}\); the endpoint
parameters form one inversion orbit per field, and covering removes \(q=3,7\).
The replay reproduced the committed \(q=27\) row exactly, and the matching certificate
passed its built-in check.  The
remaining release risk is proof integration: the chain is split across four reports,
and the new primitive-Jacobi collision lemma is the highest-risk referee target.  See
`notes/2026-08-08-c756-saturated-external-proof-trust-map.md`.

**TT compression (2026-08-08):** the hard step already proves the standalone
local Paley theorem
\[
 \operatorname{Aut}(P(q)[S])
 =S\rtimes\operatorname{Gal}(\mathbb F_q/\mathbb F_p)
 \qquad(q\equiv3\pmod4),
\]
with no matching, resultant, arc, or covering hypothesis.  Its shortest proof
uses only the signed adjacency convolution \(B\), the primitive-Jacobi
Frobenius collision class, and the Sidon/unit-modulus one-block argument.
Equivalently, every automorphism of a Paley out-neighbourhood extends uniquely
to a semilinear automorphism of the full tournament fixing the base vertex.
The second matrix, anticommutator, skew square root, simple-spectrum branch,
and Gaussian/Pfaffian obstruction are superseded proof-discovery scaffolding.
This is the most transferable C756 theorem.  The later exact-statement audit
found no covered-source predecessor for its full automorphism group or unique
local-to-global extension form; the qualified claim still awaits a human
MathSciNet/Scopus check.

**EJ2 extraction (2026-08-08):** the one-block step is an instance of a
general flat Sidon lemma: a constant-modulus function on a finite abelian
group whose Fourier support has unique nonzero ordered differences has one
Fourier mode.  Consequently, one faithful eigenblock with Sidon collision
class controls the full automorphism group of a cyclic Cayley digraph.  For
the Paley first subconstituent this gives three free corollaries: it is a
normal cyclic Cayley tournament with automorphism-group order \(n(q-1)/2\);
for prime \(q\) it is a cyclic directed regular representation; and one
primitive eigenblock reconstructs the cyclic coordinate up to translation
and Frobenius.  Treat the flat Sidon lemma as likely folklore and include
normal-Cayley/DRR terminology in the focused novelty audit.  Peisert and
higher-cyclotomic extensions are post-publication successors, not C756 scope.

**Next-session entry (superseding the one above):** extract the local Paley
automorphism theorem as a three-lemma engine beginning with the flat Sidon
lemma, and run a focused predecessor audit covering local automorphisms,
normal Cayley tournaments, and directed regular representations; then
consolidate the exterior-arc orbit classification and Clebsch
covering corollary around it.  Independently line-audit the primitive-Jacobi
half-carry argument and attach precise primary citations for Segre's lemma,
Stickelberger, the three-point multiplicative Weil bound, and Hasse.  If and
only if those bounded gates pass, allocate a separate unnumbered companion-paper
task.  Do not reopen theta fitting or run another field sweep.

**Focused local-Paley literature outcome (2026-08-08):** the audit is complete
at the covered-source level.  Goldberg (1970) determines the full Paley
tournament group but not its first subconstituent.  Javier--Llano--Zuazua
(2026), Proposition 4.4, is the closest local predecessor and already proves
that a prime Paley out-neighbourhood is a multiplicative circulant tournament;
it does not determine the local automorphism group, prove normality/DRR, or
show extension.  No inspected source states
\(\operatorname{Aut}(P(q)[S])=S\rtimes\operatorname{Gal}\) or the equivalent
unique-extension theorem.  Treat that exact theorem as qualified candidate
novelty, state normality and prime-field DRR only as corollaries, and make no
novelty claim for the elementary flat Sidon lemma.  The direct paper-series
connection is to Paper I's all-\(k\) boundary and Paper II's Paley-carrier
remark; Paper IV is a geometric/method interface only because
\(13\equiv1\pmod4\).  See
`notes/2026-08-08-c756-local-paley-rigidity-literature-audit.md`.

**Primitive-Jacobi proof audit (2026-08-08):** the local Paley theorem now
passes a line-by-line human proof audit.  The only major defect found was
expository but load-bearing: the collision report had not specified the
cyclotomic prime, the \(p-1\) ramification normalization, or the derivation of
the half-carry valuation from Stickelberger's digit sum.  Equations (3a)--(3b)
now repair that seam explicitly.  The multiplier lemma, imprimitive exclusion,
inverse-Frobenius exclusion, flat-Sidon collapse, and uniqueness of extension
all check.  Evans--Hollmann--Krattenthaler--Xiang Theorem 3.4 supplies the
matching Stickelberger normalization; Ball--Lavrauw published Lemma 12, Lidl--Niederreiter
Theorem 5.41, and Hasse supply the other classical inputs.  See
`notes/2026-08-08-c756-local-paley-proof-consolidation-and-jacobi-audit.md`.

**Next-session entry (superseding the one above):** consolidate the
saturated-exterior geometry around the now-audited local theorem in one
theorem-proof document: extremal arc to matching, complete-mapping parity,
Segre coherence, local Paley restriction-is-an-isomorphism, Frobenius Weil
exclusion, scalar Hasse endpoint, orbit uniqueness, and covering.  Install the
four exact citations and keep the \(q=3,7\) endpoints explicit.  Retain “to our
knowledge” unless a human MathSciNet/Scopus check closes the remaining index
gap.  Do not edit an existing numbered manuscript or reopen theta fitting under
C756.

**Saturated-exterior consolidation outcome (2026-08-08):** the bounded
geometry and citation gates pass.  The complete all-field proof is now in
`notes/2026-08-08-c756-saturated-exterior-consolidated-proof.md`.  It states
the extremal exterior-arc theorem first, proves the perfect-matching and
complete-mapping reductions, pins the Segre tangent-function scales, invokes
the audited local-Paley lemma, excludes nonidentity Frobenius by the coset
Weil bound, closes the scalar branch by Hasse, and checks the \(q=3,7,11\)
endpoints and inversion orbits inline.  The covering inequality explicitly
removes \(q=3,7\), leaving the Clebsch hexagon at \(q=11\).  Ball--Lavrauw
published Lemma 12, Evans--Hollmann--Krattenthaler--Xiang Theorem 3.4 and (3.2),
Lidl--Niederreiter Theorem 5.41, and Hasse's original theorem are installed
at the exact steps used.  The proof is independent of finite classification;
the matching certificate replay remains an external check.

**Next-session entry (superseding the one above):** give the consolidated
proof a cold specialist/referee read, with special attention to the Segre
normalization and primitive-Jacobi valuation, and seek the remaining human
MathSciNet/Scopus novelty check.  If that read finds no defect, allocate the
separate unnumbered companion-paper task and freeze its claim inventory:
local-Paley rigidity as the qualified candidate novelty, extremal
saturated-exterior arcs as the geometric headline, and the all-\(k\) bounds
plus saturated-internal work as explicitly partial context.  Do not draft or
edit a numbered manuscript under C756.

**Cold-read and allocation outcome (2026-08-08):** the internal referee pass
found no mathematical gap and one exact-locator defect: the scaled Segre
statement is Lemma 12 in the published Ball--Lavrauw paper, not Lemma 11.
The sign and \(t\)-conventions match, and every live locator is repaired.
The published PDF is cached and hashed in
`notes/2026-08-08-c756-consolidated-proof-cold-referee-read.md`.
The bounded C756 publication gate is therefore complete, subject to the
explicitly human MathSciNet/Scopus and external-specialist safeguards.
Companion work is allocated as C894 in
`notes/clebsch-tasks/c894-saturated-exterior-paley-companion.md`.
C756 remains active only for the genuinely open saturated-internal and
nonsaturated all-\(k\) branches; no manuscript drafting moves back into C756.

The twenty-sixth pass closed gate 1's containment half and advanced gate 2 without
closing it.  **Baer-subline containment is now settled unconditionally for every odd
prime power** (Theorem 6): a coherent system lies in no Baer subline missing \(\infty\),
so with Theorem 2 containment in any Baer subline forces \(q=5\) and an affine line.
The consequence that changes the programme: gate 1's stability statement is now
**sufficient on its own** — proving it closes the saturated-internal branch, with no
second step.  The single newly identified lever is that no argument so far uses both
halves of the crown at once; gate 1 uses independence only, gate 2 the bipartite half
only, and the two frames are exactly the configurations extremal for both.  See
`notes/2026-08-02-c756-baer-subline-containment.md` and
`notes/2026-08-02-c756-direction-coordinatization.md`.

The twenty-seventh pass acted on that lever and found the coupled object — the
cross-ratio \(g_{ij}\) of the two conjugate point-pairs, Theorem 9 — but its pigeonhole
runs one short in the unhelpful direction, forcing collisions rather than forbidding
them.  Do not retry it as a closure route; its successor target is a row-distinctness
lower bound.  See `notes/2026-08-02-c756-coupled-pair-invariant.md`.

The twenty-eighth pass changed the shape of the branch by going the other way — **dropping**
condition (A) instead of adding structure.  What is left is the invariant half alone: a
coherent system is in particular a clique of size \((q+3)/2\) in the graph \(\Gamma_q\) on
the \(q(q-1)/2\) internal points of the conic, adjacent when the join is an external line.
Exhaustively, \(\omega(\Gamma_q)=(q+3)/2\) for \(q\equiv3\pmod4\) but \((q+1)/2\) for
\(q\equiv1\pmod4\) with \(q>5\), for every odd prime power \(q\le49\).  So the invariant
half **alone** empties the branch for \(q\equiv1\pmod4\) — using neither (A), nor Paley
eigenfunctions, nor the Baker–Ebert–Hemmeter–Woldar conjecture — and it **provably cannot**
decide \(q\equiv3\pmod4\), because Theorem 10 exhibits the extremal \((q+3)/2\)-clique
there.  See `notes/2026-08-02-c756-invariant-half-clique.md`.  Gate 1's stability statement
is sufficient but, if the branch is true, vacuous for \(q>5\), so it is not a logical
weakening; gate 0 below replaces it for the \(q\equiv1\pmod4\) half.

The binding constraint on any replacement: exhaustive search is the only thing currently
covering the small fields, and small \(q\) is exactly where character-sum arguments
fail, since every Weil bound leaves a tail of order \(\sqrt q\).  So a structural
replacement must be an **exact** combinatorial argument with no error term, in the style
of Theorem 2 — whose chain ends in the integer inequality \(q-2\le(q+1)/2\) — and not
another analytic estimate.  Ranked gates:

0. **Invariant-half clique bound (new, and the highest-EV target for \(q\equiv1\pmod4\)).**
   Prove \(\omega(\Gamma_q)\le(q+1)/2\) for \(q\equiv1\pmod4\), \(q>5\), where \(\Gamma_q\)
   is the external-join graph on internal points.  This closes the saturated-internal branch
   for that whole residue class, unconditionally and for all fields, with no arithmetic
   normalization and no conjecture.  Theorem 10 already proves it for cliques containing all
   \((q+1)/2\) internal points of an external line: the pole is the only candidate extension
   and it works exactly when \(q\equiv3\pmod4\).  What is missing is a bound with no line
   hypothesis; at \(q=13\) most maximum cliques are not line-anchored, so it is not a
   corollary.  Do **not** aim this at \(q\equiv3\pmod4\): \(C_\ell\cup\{\ell^{\perp}\}\) is a
   genuine \((q+3)/2\)-clique, so that class needs (A) or the arc condition.  The cheap
   successor there is to test (A) directly against \(C_\ell\cup\{\ell^{\perp}\}\).
1. **Baer-subline containment — containment half CLOSED; stability half is now the
   whole gate.**  The twenty-sixth pass proved Theorem 6 unconditionally for every odd
   prime power: no coherent system lies in a Baer subline missing \(\infty\).  The proof
   is an exact coboundary identity, \(\chi(c-c')=\delta\lambda(c)\lambda(c')\) on the
   norm-one circle, so condition (A) alone confines the system to one \(\lambda\)-coset
   of size \((q+1)/2<(q+3)/2\).  Note the card's earlier framing was wrong and is
   corrected there: Theorems 2 and 4 are *not* the same argument on two containers —
   they load on opposite halves of the crown, and Theorem 4's container is not a Baer
   subline.  What remains is the stability conjecture, which is now **sufficient by
   itself**: the support of a \(\pm1\)-valued, Frobenius-odd
   \(\lambda_{\min}\)-eigenfunction of support at most \(q+3\) lies on a Baer subline.
   Supporting evidence: the known minimum-support eigenfunction, of support \(q+1\), is
   supported exactly on one, and the coboundary identity is precisely why.  The general
   second-minimum problem is open in the Paley literature, but the \(\pm1\) and
   Frobenius-odd hypotheses make this a much smaller target.
2. **Complete-mapping endgame — algebraic computation DONE, obstruction not extracted.**
   This is what closed the saturated-external branch: a complete mapping of the cyclic
   square group, a group-sum obstruction removing one residue class, then a genus-one
   character sum and Hasse's bound leaving three fields.  Theorem 5 supplies the internal
   analogue — \((q+1)/2\) derangements indexed by directions, with
   \(\sigma_{c^{-1}}=\sigma_c^{-1}\).  The twenty-sixth pass computed them algebraically
   (Theorem 7): each is an equality of two \(\mathbb F_q\)-linear functionals, giving
   scalar coordinates with \(X_c=\rho(c)X_{c^{-1}}\).  That yielded Theorem 8 — all mixed
   sums rational below level \((q+1)/2\), for every odd prime power — but **no cycle
   structure invariant**, and it showed the wall is a dimension count: a one-parameter
   direction family carries only \(|G|=(q+1)/2\) linear conditions, which is exactly where
   the twenty-fourth pass's tower also stopped.  Any continuation needs a *joint*
   invariant of two coordinates \((x_c,x_{c'})\), not another symmetric function of one.
3. **Rédei-type direction theorem (highest leverage — serves both open branches).**
   Theorem 5 says the \(q+3\) support points meet every line in \((q+1)/2\) of the
   \(q+1\) directions in zero or two points: a point set determining few directions with
   even multiplicity, which is Rédei–Szőnyi territory and exact rather than asymptotic.
   The nonsaturated branch's clean surviving target is *already* a masked Rédei direction
   theorem.  Both remaining obstructions in C756 are therefore direction theorems for
   point sets with character-restricted differences, and one sufficiently general tool
   could close both.  Weigh this before choosing where to spend the pass.
4. **Rédei polynomial at half size (most conservative).**  Blokhuis proved
   \(\omega(P(q^2))=q\) by a polynomial argument, and the master polynomial
   \(G=(R-\gamma)(R-\gamma^q)\) is literally the Rédei polynomial of the crown, with a
   Frobenius divisibility congruence already in hand from the lacunary pass.  Re-run
   Blokhuis' method at size \((q+3)/2\) using the crown's second condition as the extra
   input his proof does not have.

Closed, do not retry: density and stability arguments (Paley sits at edge density exactly
\(1/2\) and every published stability theorem needs strictly less); further spectral
bounds (interlacing is already tight, and that tightness is the eigenfunction property
restated); valuation-versus-Parseval counting (shown insufficient in the twenty-fourth
pass); ordinary rank, cofactor variants, and row-transition interpolation.  The
\((R,\gamma)\) composition normal form remains the fallback and is prime-only.

## Why this task exists

It is the only identified route to an A+ paper in the Clebsch/golden group. The
2026-08-01 review (`notes/2026-08-01-clebsch-golden-paper-review.md`, §12.6) found that
no repackaging of existing results clears A−/A: every headline concerns one exceptional
object over one or two small fields, with no infinite family, no asymptotic statement,
and no transferable technique. Exceptional-object papers reach the top tier only when the
exceptional object closes a general question, and the general question is currently open
at \(k = 9\).

If the theorem lands, the packaging is a **new** headline paper (rigidity + all-k
classification + golden operator), not a retrofit into Paper I.

## Current state (2026-08-08)

Twenty-nine research passes complete; the theorem is **not** proved.  The publication
route review records the Droms--Mellinger--Meyer lower-bound attribution, proves the exact
minimum-word/equality bridge and external-line holonomy lemma, constructs the local
Segre-tangent obstruction through every odd prime power \(q\le49\), and triggers the
precommitted stop rule after the orbital PSD complexity grows without a stable bounded
support.  The active next move is source audit and scoping of the explicit partial-results
fallback, not another field-by-field theta pass.  New report:
`notes/2026-08-08-c756-passant-code-equality.md`.  Earlier reports:
`notes/2026-08-02-c756-invariant-half-clique.md` and
`notes/2026-08-02-c756-coupled-pair-invariant.md` and
`notes/2026-08-02-c756-baer-subline-containment.md` and
`notes/2026-08-02-c756-direction-coordinatization.md` and
`notes/2026-08-02-c756-crown-reformulation-and-line-case.md` and
`notes/2026-08-02-c756-paley-eigenfunction-support-literature.md`, and
`notes/2026-08-02-c756-clique-orbit-crown-check.md`, and
`notes/2026-08-02-c756-split-fiber-census.md`, and
`notes/2026-08-01-c756-all-k-conic-filling.md` and
`notes/2026-08-01-c756-saturated-matching-attack.md`, and
`notes/2026-08-01-c756-segre-tangent-coherence.md`, and
`notes/2026-08-01-c756-paley-windmill-reduction.md`, and
`notes/2026-08-01-c756-paley-bispectral-reduction.md`, and
`notes/2026-08-01-c756-primitive-jacobi-collisions.md`, and
`notes/2026-08-01-c756-nonsaturated-direction-reduction.md`, and
`notes/2026-08-01-c756-segre-discriminant-comparison.md`, and
`notes/2026-08-01-c756-subresultant-moment-obstruction.md`, and
`notes/2026-08-01-c756-saturated-internal-branch.md`, and
`notes/2026-08-01-c756-intercept-subresultant-probe.md`, and
`notes/2026-08-01-c756-information-probability-structure-lottery.md`, and
`notes/2026-08-01-c756-masked-rs-collision-audit.md`, and
`notes/2026-08-01-c756-probability-cheap-tests.md`, and
`notes/2026-08-01-c756-kernel-curves.md`, and
`notes/2026-08-01-c756-coordinate-free-upgrades.md`, and
`notes/2026-08-02-c756-tt-angle-bijections.md`, and
`notes/2026-08-02-c756-cross-ratio-rank.md`, and
`notes/2026-08-02-c756-ball-lavrauw-tensor-interface.md`, and
`notes/2026-08-02-c756-alt-attacks.md`, and
`notes/2026-08-02-c756-prime-field-lacunary-first-cofactor.md`, and
`notes/2026-08-02-c756-four-point-row-transitions.md`, and
`notes/2026-08-02-c756-sparse-paley-trade-profile.md`, and
`notes/2026-08-02-c756-digit-tower-composition.md`.

Branch ledger:

- **saturated-external — closed:** the Clebsch hexagon over \(\mathbb F_{11}\) is the
  only covering example;
- **saturated-internal — reduced to one clique statement, still open:** coherent systems
  are exactly induced crown graphs in the Paley graph of order \(q^2\); the four-frame
  over \(\mathbb F_5\) is the only example, unconditionally, for every odd prime power
  \(q\le151\); systems contained in **any** Baer subline force \(q=5\) for all \(q\)
  (line case Theorem 2, circle case Theorem 6, both exact and prime-power-general); all
  mixed sums are rational below level \((q+1)/2\) for every odd prime power (Theorem 8);
  the invariant half alone (chord externality, condition (A) discarded) already empties the
  branch for every \(q\equiv1\pmod4\) with \(5<q\le49\), and provably cannot decide
  \(q\equiv3\pmod4\); and the remaining uniform gates are the invariant clique bound
  \(\omega(\Gamma_q)\le(q+1)/2\) for \(q\equiv1\pmod4\), and, for \(q\equiv3\pmod4\), the
  crown-restricted case of the Baker–Ebert–Hemmeter–Woldar gap conjecture or equivalently the
  Baer-subline stability statement;
- **nonsaturated — open for \(\delta\ge2\):** \(\delta=0,1\) are closed, while the
  direct Segre, global-moment, raw-subresultant, and dual-pencil low-degree norm repairs
  fail; the three exceptional missing-set kernels are smooth symmetry-specific curves
  rather than a common split-support carrier, and the all-internal near-transversal
  classification itself remains open.

What is now proved for all \(k\) and all \(q\):

- \(\mathcal U(A)=C\) splits into (E) every chord is external to \(C\) and (V) the chords
  cover all \(q^2\) points off \(C\); (E) is hereditary and equals
  \(\chi(\operatorname{Res}(f_i,f_j))=-1\) in the binary-quadratic model of the plane.
- Even \(q\) is impossible (the nucleus is never covered).
- A covering LP bound with the correct degree cap \(\lfloor k/2\rfloor\), replacing the
  \(k\le 8\)-only bound \(q\le(k(k-1)+3)/3\).
- A spare-external-line bound: either \(\binom{k-1}{2}\ge q\), or every arc point is
  saturated, which forces \(k=(q+1)/2\) with all arc points external or \(k=(q+3)/2\)
  with all internal. **Both known examples are exactly the two saturated types**, and in
  the saturated-external case the arc is a perfect matching of \(\mathbb P^1(\mathbb F_q)\)
  with all pairwise resultants non-residues.

What the saturated-external attack adds:

- after fixing one matching edge, the arc condition forces a complete mapping of the cyclic
  square group;
- this excludes every \(q\equiv1\pmod4\), hence every odd square field, by a group-sum
  obstruction;
- for \(q\equiv3\pmod4\), the coherent scalar matching branch reduces to a genus-one character
  sum and Hasse's bound forces \(q\in\{3,7,11\}\); only \(q=11\) also covers;
- Segre's lemma of tangents forces **every** saturated-external arc in the odd branch to be
  sign-coherent; conditional on the remaining first-subconstituent automorphism lemma, a coset
  Weil bound eliminates every nontrivial Frobenius form and reduces uniformly to the scalar branch;
- every surviving local automorphism produces a signed perfect-matching matrix \(M\) with
  \(M^2=-I\), two forced vector equations, and the single Paley anticommutator
  \(AM+MA=-2I\); the mixed sign diagonal is forced to be \(-1\);
- the anticommutator produces a second regular tournament matrix \(K\) commuting with the
  first-subconstituent Paley matrix \(B\), with the forced square
  \(K^2=-B^2-(q-1)I+2J\); if \(B\) has simple spectrum, every signed monomial solution is
  scalar and the existing Hasse argument closes it;
- the Gaussian-unit matrix \(W=(B+iK)/(1+i)\) is a regular simplex with
  \(WW^*=((q-1)/2)I-J\); its principal Pfaffian norm excludes every
  \(q\equiv3\pmod8\) for which \((q-1)/2\) is not a sum of two squares;
- Stickelberger's half-carry profile and a base-\(p\) digit-weight lemma prove that one
  faithful Jacobi eigenvalue has exactly its Frobenius collisions, including exclusion
  of collisions with imprimitive characters; the one-block Sidon argument therefore
  makes every matching multiplication--Frobenius, and the prior Weil/Hasse arguments
  close the saturated-external branch completely;
- polarity turns covering into the assertion that the complete node set of \((q+1)/2\) secants,
  consisting entirely of internal points, blocks every non-tangent line.

What the saturated-internal pass adds:

- after fixing one internal point, the other \((q+1)/2\) points map bijectively to the
  odd coset of the norm-one circle via their relative angles; the external branch's
  complete-mapping parity obstruction has no internal analogue;
- the secants of the conic through an internal arc point give a canonical scale-free
  tangent polynomial, so Segre's triangle identity forces unconditional sign coherence;
- coherent representatives form two Paley cliques joined by conjugation matching at
  exactly tight spectral interlacing; the resulting balance theorem and Parseval identity
  characterize the saturated size \(k=(q+3)/2\);
- a master polynomial \(G=\prod_i f_i\) satisfies the necessary Frobenius divisibility
  \(G\mid G'^q-(-1)^{(q+3)/2}G'\), furnishing a concrete lacunary-polynomial gate;
- the exact audit over every odd prime power \(q\le43\), independently replayed on five
  prime fields, finds only the two normalized \(q=5\) four-frames as coherent covering
  arcs; no coherent candidate survives for any audited \(q>5\).

What the first nonsaturated pass adds:

- deleting an arc point on a spare external line produces a \((k-1)\)-arc in the affine
  plane which determines exactly all \(q\) directions other than the deleted point;
- its direction discriminant factors as
  \(D_P(T)=(T^q-T)E_P(T)\), where
  \(\deg E_P=\binom{k-1}{2}-q\) and the root multiplicities of \(E_P\) are exactly
  the excess parallel-chord concurrences;
- equivalently, the complete chord product on the spare line is the binary Moore form,
  the forced \((k-2)\)-fold residual factor at the deleted point, and one canonical
  degree-\(\delta\) concurrence divisor;
- the residual divisor is completely split and supported on at most \(\delta\) exceptional
  directions involving at most \(2\delta\) chords;
- zero slack is impossible over every odd prime-power field except the already excluded
  \(q=3\); defect one factors into exactly \(q=5,9,27\), all removed by the certified
  bounded classification; hence every nonsaturated conic-filling arc satisfies
  \(\binom{k-1}{2}\ge q+2\);
- at defect two the residual divisor is either one double rational point or two distinct
  rational points, so its binary-quadratic discriminant is zero or a square; the first
  boundary not removed by the \(q\le43\) classification is \((q,k)=(53,12)\).

What the defect-two comparison adds:

- the residual quadratic has square-or-zero discriminant while the anisotropic
  \(Q|_\ell\) has nonsquare discriminant, but Segre reciprocity does not identify them;
- every tangent product factors as a conic-meeting factor times a spare-external factor;
  the latter is trivial in the saturated proof but has large positive degree here and
  absorbs the desired square-class comparison;
- after removing the selected spare line, its tangent factor restricts back to that line
  as a pure power at the selected arc point, so it contains no residual concurrence
  divisor;
- the smallest replacement carrier is the first subresultant of
  \(\mathcal H(U,T)=\prod_i(U+x_iT-y_i)\), which retains the repeated chord intercept as
  well as its direction.

What the subresultant and Tao-moment pass adds:

- the first subresultant has Vandermonde-minor coefficients \(A,B\), is nonzero at every
  uniquely represented direction, and therefore cannot inherit the Moore factor;
- the exact uniform forced factor is \(E_P^2\mid A,B\), but after division the coefficient
  degrees remain \(\Theta(q)\), with the predicted maxima attained by exact defect-two
  examples over \(\mathbb F_{13}\);
- all global slope moments satisfy
  \(\sum_{i<j}t_{ij}^m=r^m+s^m\) for \(1\le m\le q-2\), but explicit affine six-arcs
  realize both the one-triple and two-double residual shapes, so those moments do not
  obstruct either shape before conic externality;
- the remaining bounded nonsaturated attack is the dual conic-weighted pencil: internal chord poles
  form a defect-two near-transversal of the pencil through \(\ell^\perp\), retaining both
  direction and intercept.

What the bounded dual-pencil/intercept pass adds:

- the chord pole's coordinate along its line of the pencil through \(\ell^\perp\) is the
  repeated-chord intercept \(U^*=N/G\);
- the exact root formula is
  \(S_1=\pm E_P^2(GU-N)\), with
  \(G=\sum_m\Phi_m^2\), \(N=\sum_m r_m\Phi_m^2\), and
  \(\Phi_m=(T^q-T)/w_m\);
- the Moore mass fragments among the point pencils: after the only uniform forced factor
  \(E_P^2\), the residual degrees are \(2(q-n+1)\) and \(2(q-n+1)+1\), not
  \(O(\delta)\); six exact covering instances attain this scale, including degrees
  \(16\) and \(26\) at fixed \(\delta=2\);
- hence the proposed low-degree conic norm/Weil route fails.  This does not classify the
  all-internal near-transversals themselves; it closes only their last identified
  small-degree algebraic compression.

What the information/probability pass adds:

- deleting the spare-line point identifies the remaining affine points with degree-one
  Reed--Solomon words \(c_i(t)=y_i-tx_i\); chord directions and intercepts are exactly
  pairwise agreement coordinates and symbols;
- the arc condition makes every agreement cell contain one chord, covering makes every
  coordinate nonempty, and conic externality restricts every agreement symbol to a
  direction-dependent quadratic-character half-alphabet;
- for chord-direction multiplicities \(\mu_t\), the conditional entropy and Renyi
  collision statistic are
  \(H(U\mid T)=\binom{n}{2}^{-1}\sum_t\mu_t\log\mu_t\) and
  \(\Pr(T=T')=(\binom{n}{2}+2R)/\binom{n}{2}^2\), where
  \(R=\sum_t\binom{\mu_t}{2}\) counts pairs of parallel chords;
- covering gives a sharp convexity upper bound
  \(R\le R_{\rm cover}(n,\delta)\), equal to 3 at defect two.  A conic-character
  lower bound exceeding this threshold would be a uniform nonsaturated obstruction;
  the needed mask-to-variance inequality is not yet proved;
- six exact covering controls verify the collision dictionary and show ordinary covering
  disperses rather than concentrates excess chords.  The next cheap falsification test is
  to record \((\delta,R,R_{\rm cover})\) in the existing conic-external enumeration
  through \(q\le43\).

What the exhaustive masked-direction audit adds:

- every direction-cover-feasible conic-external arc, deleted point, and spare external
  line through \(q\le43\) is audited: 234,188 instances, with independently recomputed
  \(m(q)\) agreeing with the original certificate at all twelve fields;
- the only feasible fields are \(q=27,29,31,41,43\), and their minimum missing-direction
  counts are respectively \(6,2,4,6,8\): no instance has \(h=0\) or \(h=1\);
- the clean surviving nonsaturated target is therefore a masked Rédei direction theorem:
  a conic-external point set never determines all \(q\) directions on a spare external
  line.  This statement alone would close the nonsaturated branch;
- the bare inequality \(R>R_{\rm cover}\) is not the empirical law and becomes a
  fourth-moment fallback.  The exact identity
  \(\sum_{\mu_t>0}(\mu_t-1)=\delta+h\) holds throughout, while the occurrence of its
  all-doubled equality case \(R=\delta+h\) has unexplained residue-dependent texture;
- the threshold-unification hypothesis closes negative: except for the saturated
  \(q=11\) hexagon, extremal conic-external cliques cover only 64--94% of the off-conic
  plane.  Equalities \(m(q)=k_{\min}(q)\) are not evidence that every extremizer is a
  near-cover.

What the probability/information cheap-test pass adds:

- the saturated-internal entropic-uncertainty route closes negative as a new mechanism:
  the \(q=5\) frame has an exact Paley eigen-residual but a positive 0.94-nat uncertainty
  gap, while the exact residual is only the known coherence condition in Fourier form;
- the global split-support test is mixed-positive: maximum-coverage missing sets have
  unexpected first Hilbert defects in degrees \(4,7,6\) at \(q=13,29,31\), but the
  phenomenon is not uniform through degree 10 at \(q=23,37,41,43\);
- the quadratic Lloyd/Delsarte incidence route closes negative at the first live boundary:
  the exact covering profile
  \(N_1=2502,N_2=210,N_6=85,N_{11}=12\) satisfies all universal degree-two moments and
  the twelve forced arc vertices at \((q,k)=(53,12)\);
- prefix entropy survives its cheap falsifier: middle-depth extension counts collapse to
  only 7--21 values across 252--462 subsets of each tested maximum witness, but the
  geometric labels of those count classes are unknown and only one witness per field was
  tested;
- uniform local \(K_4/K_5\) cumulants close negative: mutual information is tiny at
  \(q=5,7\), and the \(q=11\) hexagon supplies the all-negative five-pattern absent in
  those two fields.

What the missing-set kernel-curve extraction adds:

- the first unexpected kernels for the selected maximum-coverage witnesses at
  \(q=13,29,31\) are one-dimensional and define smooth absolutely irreducible plane
  curves of degrees \(4,7,6\), genera \(3,15,10\), and respectively \(29,75,102\)
  rational points;
- their exact conic-preserving stabilizers equal the witness stabilizers and are
  \(S_3,D_{10},A_5\); the missing sets split into regular orbits
  \(6^4,10^5,60\);
- no curve contains an arc vertex or factors through the conic or chord lines, and their
  conic/chord intersection profiles have no common pattern;
- the \(q=31\) sextic lies in an exact two-dimensional \(A_5\)-stable character space
  containing \((y^2-xz)^3\), while the corresponding spaces at \(q=13,29\) have
  dimensions four and six.  More exactly, in the frozen normalization it is the product
  of the polar lines of the unique six-point orbit plus \(5(y^2-xz)^3\); the resulting
  pencil has singular parameters \(0,16,19\), smooth point counts
  \(12,42,72,102\), and two maximum members at parameters \(5,7\);
- hence the promoted split-support diagnostic closes as a uniform nonsaturated proof
  route.  The \(q=31\) \(A_5\) pencil remains a finite exceptional object, and the
  prefix-container diagnostic is the sole survivor of the probability cheap-test pair.

What the coordinate-free upgrade pass adds:

- every missing-set curve is the canonical kernel line of the evaluation map
  \(H^0(\mathbf P(\operatorname{Sym}^2V),\mathcal O(d))\to
  H^0(S_A,\mathcal O(d))\), so the \(q=13,29\) curves are as intrinsic as the
  six-axis \(q=31\) sextic even though their stabilizer-character spaces are larger;
- the Moore quotient is the residual Cartier divisor \(R_{P,\ell}\) in the exact
  restriction of the chord arrangement to a spare line;
- direction and intercept are respectively the base and fibre coordinates of the
  canonical incidence ruled surface over \(\ell\).  On it, the old first subresultant is
  a rank-two bundle section vanishing along \(2R_{P,\ell}\); this is the intrinsic
  Fitting/determinantal statement behind \(E_P^2\mid A,B\), and its nonzero fibre at a
  unique collision explains invariantly why no Moore factor divides;
- the Moore rational-point divisor globalizes only over the Frobenius-fixed members of
  the varying pencil: Frobenius moves every nonrational line to a different fibre.  Thus
  \(\ell\mapsto R_{P,\ell}\) is canonical on rational spare fibres but is not an ordinary
  algebraic divisor map on the full pencil; any global \(h\ge1\) proof must use the
  Frobenius graph/fixed locus or an additional polarity lift, not naive intersection
  theory on the blow-up;
- the completed saturated-external branch can be stated as a classification of
  fixed-point-free involutions of the conic carrying the resultant-character two-graph;
  fixed-edge complete-mapping coordinates belong only to its proof;
- the norm-one-torus/Cartier saturated-internal rewrite, dual internal-node
  near-transversal, and intrinsic prefix groupoid are frozen as explicit future
  interfaces, with stop conditions, rather than claimed as completed arguments.

What the TT simultaneous-angle pass adds:

- the forced angle bijection at every arc point gives the complete row identity
  \[
    \prod_{j\ne i}(X-\alpha_{ij})=X^{(q+1)/2}+1,
    \qquad \alpha_{ij}=f_j(z_i)^{1-q},
  \]
  so every intermediate elementary symmetric function and every power sum through
  degree \((q-1)/2\) vanishes; the prior master-polynomial constraint used only the
  constant coefficient;
- after clearing denominators, the product of the other quadratic evaluations on the
  two conjugate fibres is a pure binomial.  This is a simultaneous first-jet/cofactor
  condition at all \((q+3)/2\) closed points, giving roughly \(q^2/4\) exact row
  equations on \(O(q)\) geometric data;
- the first new equation \(\sum_{j\ne i}\alpha_{ij}=0\) holds in every row of both
  \(q=5\) frames and fails in at least one row of every one of the 167 normalized
  pairwise candidates at \(q=7,11,19,23,31,43\); in all tested fields except \(q=23\)
  it fails in all but one row of every candidate;
- the leading saturated proof targets are now the rank of the cross-ratio matrix
  \((\alpha_{ij})\) and a degree-bounded globalization of its first cofactor on the arc
  divisor.  Sparse signed-Paley-trade classification is the fallback; higher angle
  moments wait until the first moment stalls.

What the cross-ratio rank pass adds:

- with (X=\operatorname{diag}(z_i)), (Y=\operatorname{diag}(z_i^q)), the
  cross-ratio matrix has an exact rank-three double displacement;
- a hypothetical first-moment kernel therefore satisfies an exact quadratic
  kernel-propagation identity, giving the correct low-degree input for cofactor
  globalization;
- bare ordinary rank closes negative as the obstruction: singular negative candidates
  occur in every tested field, and (q=23) has rank-(k-2) candidates with seven
  already-vanishing rows;
- in the rank-(k-1) branch the target is alignment of the adjugate kernel line with
  the constant line; the rank-(\le k-2) branch needs a second-compound argument or
  exclusion from the full angle-binomial identities.

What the Ball--Lavrauw tangent-tensor interface adds:

- the parameter dictionary is exact: their planar tangent degree is
  $t=(q+1)/2$, C756's canonical $T_i$ is their tangent form, and the whole
  $(t+1)$-point arc is a $t$-socle;
- the planar tensor is only a bidegree-$(t,t)$ bilinear form on two Veronese slots.
  It globalizes the pairwise values $T_i(P_j)$, hence the norm/resultant and Segre
  reciprocity data already used by sign coherence, but not the conjugate-fibre phases
  $\alpha_{ij}$;
- the first cleared angle coefficient is a $t$-fold cofactor across all neighbours.
  Tensor specialization and jets remain rowwise, so recovering it reintroduces the
  original arc-dependent product without a degree drop or a nullity-one theorem;
- this is a uniform ground-field failure, before any Frobenius or Hasse-derivative
  seam.  The routed tensor interface therefore closes negatively;
- polarity does not produce the $k-1$ blockers required by generalized
  hyperfocused arcs: a passant chord's pole is not on the chord, and angle-pencil
  labels depend on the base point.  The prime-field four-point theorem is inapplicable.

What the alternative-attacks reset adds:

- five non-equivalent routes now have frozen inputs, outputs, and bounded stop gates:
  lacunary first cofactor, four-point row transitions, sparse integral Paley trades,
  coupled higher-moment compounds, and the independent masked Rédei gap;
- the first-cofactor lacunary route remains highest EV for one prime-field pass, but
  it must produce bounded support or a bounded-order Cartier recurrence rather than
  restate the rowwise vanishing;
- the row-transition route is the clean fallback: interpolate the simultaneous angle
  bijections on the norm-one torus and test least rational degree, pole divisor, and
  four-point cross-ratio defect using the existing matrices;
- ordinary rank, another spectral bound, raw entropy, local cumulants, and the
  missing-set kernel curves remain closed; the prefix groupoid is scouting rather
  than a proof route until it has a bounded intrinsic state catalogue.

What the prime-field lacunary first-cofactor pass adds:

- with
  \(E_2=\sum_{a<b}f_af_b\prod_{r\notin\{a,b\}}f_r^p\), the canonical reduced
  first-cofactor section is exactly
  \(\mathcal C=E_2'(X)(X-X^p)^{-1}\bmod G\); this removes the local factor
  without choosing a tangent direction;
- direct evaluation at every quadratic root independently checks both the cleared
  cofactor and its angle-moment normalization on all 169 audited prime-field
  candidates;
- the two \(p=5\) frames give \(\mathcal C=0\), while every one of the 167
  negative candidates gives a nonzero section;
- the declared lacunarity gate nevertheless closes negatively: support reaches
  \(p+3,p+3,p+2\) and first Cartier width reaches \(p,p,p-1\) at
  \(p=11,19,23\), so reduction modulo \(G\) has linear rather than bounded
  complexity;
- endpoint-supported subclasses with exponents \(\{0,2,p+1\}\) and
  \(\{0,1,2,p,p+1\}\) persist and pass to the four-point row-transition
  diagnostic; they do not control every coherent candidate and hence do not rescue
  the global lacunary route.

What the four-point row-transition pass adds:

- the two \(p=5\) frames are the only complete angle-row permutation systems in the
  audited prime fields, and all \(24\) ordered transitions are Möbius of degree one;
- this separation is not new rigidity: every negative candidate has at most one
  bijective row, so none supplies a complete negative transition and the gate collapses
  back to the already-known first angle moment;
- functional partial transitions have least rational degrees reaching
  \(3,5,9,11,15,21\) at \(p=7,11,19,23,31,43\); the \(p=31,43\) transitions from
  the unique bijective row attain the full polynomial scale \((p-1)/2\);
- every canonical pole divisor misses the full norm-one torus, while the only \(252\)
  nonvacuous negative four-point comparisons all preserve cross-ratio, so neither poles
  nor cross-ratio defect controls the surviving radial coordinate;
- conditionally, a uniform transition bound \(d\) with \((p+1)/2>d^2+1\) would force
  all opposite transitions to be Möbius and embed \(S_{(p+1)/2}\) in tame
  \(\operatorname{PGL}_2\), impossible for \(p\ge11\); the missing input is exactly
  the bounded-degree lemma, and the declared finite diagnostic supplies no route to it;
- Route Q therefore closes at its predeclared stop gate.  Route F, sparse integral Paley
  trades, is the next saturated-internal discriminator.

What the sparse Paley-trade census (Route F, twenty-third pass) adds:

- for all 129 bounded candidates (\(q\le23\)), the conjugation-odd vector
  \(x=\mathbf1_Z-\mathbf1_{Z^q}\) has exact cyclotomic Fourier values with
  \(\widehat x(w^q)=-\widehat x(w)\) and forced vanishing on rational frequencies;
- the two \(q=5\) frames are flat biunimodular trades: Fourier support exactly the
  eight nonrational square-class frequencies (the class has size \((q-1)^2/2=q+3\)
  only at \(q=5\)), every value \(\pm5\zeta^j\), uniform terminal valuation
  \(v_\pi=4=p-1\), and two-valued autocorrelation
  \(A=-2+5\cdot\mathbf1_{\text{nonrational nonsquares}}\);
- every negative candidate has full nonrational Fourier support, all-irrational
  squared moduli, many-valued autocorrelation, and uniform \(v_\pi\in\{1,3\}\);
- the digit mechanism is exact: \(v_\pi\ge2\) everywhere iff the oriented support sum
  \(\sigma\) is rational; conjugation-oddness kills the even digit, so \(v_\pi=2\)
  never occurs; the 13 \(\sigma_1=0\) candidates (all at \(q=23\)) have the larger
  coherence-violation count, proving the valuation tower transverse to coherence;
- additive energy and Parseval mass are constant per field, so the isolating profile
  is invisible to the second moment; Route F's continue gate passes with digit-1
  rationality and forced flatness as the two frozen theorem gates.

What the digit-tower and composition pass (twenty-fourth) adds:

- digit 1 is **proved** from coherence alone, and far more: for prime \(q\), every
  signed power sum \(P_{j+q(r-j)}\) vanishes through the critical level \(r=t\)
  (nonsquare-coset character independence plus Lucas; the critical level closes by the
  reflection \(P_{qt}=-P_t\)); hence \(s_1,\dots,s_t\) are rational and
  \(v_\pi(\widehat x)\ge t+1=(q+3)/2\) uniformly, with \(t+1\) the exact generic value
  attained by the frames (the census reading \(p-1\) was the \(q=5\) coincidence
  \(t+1=p-1\));
- balance needs no interlacing: coherence makes \(x\) an exact \(\pm q\)-eigenvector by
  a two-line Parseval argument;
- **composition normal form**: Newton converts the tower into
  \(Z=R^{-1}(\gamma)\) for monic rational \(R\) of degree \((q+3)/2\) and a quadratic
  point \(\gamma\), with \(G=(R-\gamma)(R-\gamma^q)\); both frames verified exactly
  (e.g. \(R=X^4+3X^3+4X^2+2X\), \(\gamma=2+3\sqrt2\));
- the tower explains the census valuations exactly: first failing level equals the
  uniform valuation for all 129 candidates, and \(v=2\) is impossible because level 2
  follows from level 1 for conjugation-odd vectors;
- pure valuation-versus-Parseval counting provably cannot finish; the finisher is the
  \((R,\gamma)\) classification — a completely-split-quadratic-fiber problem of
  monodromy/exceptional-polynomial type, with the Dickson window
  \((q+3)/2\mid8\Rightarrow q\in\{5,13\}\) and \(q=13\) already audit-excluded.

What the crown-reformulation and affine-line pass (twenty-fifth) adds:

- **Reformulation.**  A coherent system is exactly an induced *crown graph*
  (\(K_{n,n}\) minus a perfect matching, \(n=(q+3)/2\)) in the Paley graph of order
  \(q^2\) whose missing matching is Frobenius conjugation; equivalently a
  \(\pm1\)-valued, Frobenius-odd eigenfunction for the eigenvalue \(-(q+1)/2\) with
  support exactly \(q+3\).  Interlacing is tight, which is why no further spectral
  bound can finish the branch — that tightness *is* the eigenfunction statement.
- The known minimum-support eigenfunction of \(P(q^2)\) has support \(q+1\), inducing
  \(K_{m,m}\) on the norm-one circle, and is Frobenius-even; C756's object is its
  immediate neighbour.  Minimum support \(q+1\) is a theorem
  (Goryainov–Kabanov–Shalaginov–Valyuzhenich 2018), its classification is an open
  problem in that literature, and nothing is known for supports \(q+2,\dots,2q-1\).
- **Affine-line theorem (proved, all odd prime powers).**  A coherent system contained
  in an \(\mathbb F_q\)-affine line forces \(q=5\).  Both frames are of that shape and
  sit exactly on the boundary: the chain ends in \(q-2\le(q+1)/2\).  So for \(q>5\)
  every coherent system is line-free.
- **Reduction.**  Line-free cliques of size \((q+3)/2\) in \(P(q^2)\) are the
  Baker–Ebert–Hemmeter–Woldar regime.  Under their gap and two-orbit conjecture,
  \(q\equiv1\pmod4\) is impossible outright and \(q\equiv3\pmod4\) forces
  \(Z=a(Q_j\cup\{0\})+b\) — a three-field-element family.
- **Weil closure of that family (proved for \(q\ge83\)).**  Parametrizing the circle by
  \(c(t)=(t-\iota)/(t+\iota)\), the crown condition becomes
  \(\chi_q(F(t,t'))=-1\) on \(T_j\times T_j\) with \(F=N(P(t)t'+Q(t))\).  Because
  \(F\) is the norm of a form linear in \(t'\),
  \(\operatorname{disc}_{t'}F=\varepsilon L(t)^2\) is a nonsquare whenever
  \(L(t)\ne0\), and \(L\equiv0\) only when \(b\in\mathbb F_q\), which is excluded.
  Hence the inner sums are Weil sums of squarefree polynomials, giving
  \(O(q^{3/2})\) against a required \(q^2/4\).
- **Field generality.**  Unlike the prime-only composition tower, this whole route
  holds for every odd prime power, so it removes the \(q=27\) extension-field gap from
  this branch's argument.
- **Certified range extended without any conjecture.**  Coherence is a clique condition
  in a graph on the irrational elements whose affine automorphisms act transitively, so
  an exhaustive search through one vertex is complete.  It returns nothing for every odd
  prime power \(q\) with \(5<q\le151\), in both residue classes and including
  \(9,25,27,49,81,121,125\), so the \(q=27\) hygiene item is discharged; every search
  ran to completion and \(q=5\) returns exactly the two known frames as a positive
  control.  Beyond \(151\) the two published clique orbits are empty for every
  \(q\equiv3\pmod4\) up to \(503\) across 1,686,529,824 tested orbit members, but
  those rows are conditional on the two-orbit classification.
- **Latin-square constraint (Theorem 5).**  Coherence alone forces the direction of
  \(z_i-z_j^q\), for fixed \(i\), to run bijectively over the \((q+1)/2\) directions
  of class \(-\delta\) — geometrically, no point of \(Z\) lies on an
  \(\mathbb F_q\)-line containing two points of \(Z^q\).  The corresponding column
  statement follows formally from the unconditional identity
  \(D(j,i)=D(i,j)^{-1}\) and is not independent.  The resulting \(n-1\) derangements
  are the internal analogue of the complete mapping that closed the saturated-external
  branch, and this route does not pass through the clique conjecture at all.
- **Honest verification status.**  The gap conjecture is proved for no \(q\); Yip
  records that "no partial progress has been made".  The claimed check to \(q\le109\)
  is unattributed and the published orbit-complete table stops at \(q\le47\).  So the
  unconditional range is not materially extended; the gain is that the branch reduces
  to one named conjecture, and in fact only to its crown-restricted special case.
- The next unconditional target is therefore: no maximal clique of size \((q+3)/2\) in
  \(P(q^2)\) is completely joined, outside a perfect matching, to its Frobenius image.
  The reduction currently uses only clique-ness and discards the entire bipartite half
  of the crown; every published stability theorem fails because Paley sits at edge
  density exactly \(1/2\).

What the Baer-subline and coordinatization pass (twenty-sixth) adds:

- **Theorem 6, containment.**  On the norm-one circle, \(\chi(c-c')=\delta\lambda(c)\lambda(c')\)
  where \(\lambda\) is the order-two character of the circle group; this is a one-line
  rederivation of the Goryainov–Kabanov–Shalaginov–Valyuzhenich lemma that the circle
  induces \(K_{m,m}\), read as a coboundary rather than as a bipartite graph.  Condition
  (A) alone then forces \(\chi(a)=1\) and a single \(\lambda\)-coset, of size
  \((q+1)/2<(q+3)/2\).  Since every Baer subline missing \(\infty\) is \(aC+b\) — the
  orbit count \(q^2(q-1)\) matches the subline count exactly — no coherent system lies on
  one, for any odd prime power;
- with Theorem 2 this is the unified statement gate 1 asked for, and it upgrades the
  stability conjecture to sufficient on its own;
- the bound is **sharp**, and the extremal configuration is a full \(\lambda\)-coset.
  That derives the shape of the published Baker–Ebert–Hemmeter–Woldar cliques
  \(S_j=Q_j\cup\{0\}\) rather than importing it: a size-\((q+3)/2\) clique built from a
  circle must be a full coset plus exactly one point off the circle;
- empirically, once condition (B) is imposed the maximum inside a circle collapses from
  \((q+1)/2\) to \(2,3,4,4,4,5,5\) at \(q\le23\), apparently \(O(\sqrt q)\).  Recorded as
  structure only: proving it needs a character-sum clique bound, whose \(\sqrt q\) tail
  fails exactly at small \(q\);
- **Theorem 7, linearity.**  \(\operatorname{dir}(z-w^q)=c\) iff \(\varphi_c(z)=\psi_c(w)\)
  for \(\varphi_c(z)=z^q-cz\), \(\psi_c(z)=z-cz^q\), both \(\mathbb F_q\)-linear with
  one-dimensional kernels \(L_c,L_{c^{-1}}\) and common image line \(M_c\).  Fixing
  generators gives scalar coordinates \(x_c:Z\to\mathbb F_q\), injective on \(Z\) by (A),
  and every Theorem 5 matching becomes the set identity \(X_c=\rho(c)X_{c^{-1}}\);
- **Theorem 8, mixed moments.**  Comparing \(m\)-th power sums of that identity collapses
  to \(\sum_r\binom mr(-1)^rc^rN_r=0\) with \(N_r=M_{r,m-r}-M_{r,m-r}^q\), a degree-\(m\)
  polynomial vanishing on all \(|G|=(q+1)/2\) directions.  Hence all mixed sums
  \(M_{r,m-r}=\sum_iz_i^r(z_i^q)^{m-r}\) are rational for \(m<(q+1)/2\), for **every odd
  prime power**.  This reproves the twenty-fourth pass's digit tower without the Lucas
  argument, extends it from primes to prime powers and from pure to mixed sums, and
  explains its critical level as the direction count rather than as arithmetic.  At
  \(m=1\) it gives \(S=\sum z_i\in\mathbb F_q\), so \(S=0\) is a free normalization;
- **negative, and load-bearing for routing:** no cycle-structure obstruction was
  extracted, and the dimension count shows why — a one-parameter direction family supplies
  only \(|G|\) linear conditions, so gate 2's wall and the digit tower's wall are the same
  wall.  Continuation requires a joint invariant of two coordinates \((x_c,x_{c'})\);
- **newly identified lever:** gate 1 uses only the independence half of the crown and
  gate 2 only the bipartite half.  No argument in the branch couples them, and the two
  \(q=5\) frames are precisely the configurations extremal for both at once.

What the coupled pair-invariant pass (twenty-seventh) adds:

- **Theorem 9.**  The cross-ratio
  \(g_{ij}=(z_i-z_i^q)(z_j-z_j^q)/N(z_i-z_j)\in\mathbb F_q^\times\) is the unique
  \(\mathrm{PGL}(2,q)\)-invariant of the pair of conjugate point-pairs.  With
  \(\alpha_{ij}=N(z_i-z_j)\) and \(\beta_{ij}=N(z_i-z_j^q)\) one has the exact identity
  \(\beta=\alpha-4\varepsilon c_ic_j=\alpha(1-g)\), so (A) is \(\chi_q(\alpha)=\delta\)
  and, given (A), (B) is exactly \(\chi_q(1-g)=-1\).  This is the object the
  twenty-sixth pass's lever asked for: one invariant matrix carrying both halves;
- **the standing non-invariance caveat is localized.**  Coherence is not
  \(\mathrm{PGL}(2,q)\)-invariant, but Theorem 9 shows all of that failure sits in (A);
  (B) relative to (A) is invariant.  Projective tools are therefore available on the
  bipartite half and forbidden on the independence half — a division of labour, not a
  blanket restriction;
- \(\chi_q(g_{ij})=-\delta\eta_i\eta_j\) with \(\eta_i=\chi_q(c_i)\) is a third
  coboundary, implied by (A), which makes the row split by \(\eta_j\) exact;
- **negative, and the reason to stop here.**  The exact Jacobi count puts each row's
  \((q+1)/2\) entries inside a set of size \((q-1)/2\), so collisions
  \(g_{ij}=g_{ik}\) are **forced** rather than forbidden.  The pigeonhole is off by one
  in the direction that gives structure instead of contradiction, so this route does not
  close the branch.  The successor target is a row-*distinctness lower bound* for
  \(q>5\); a collision is a conic condition with \(\approx q\)-point fibres, so any bound
  must couple many rows;
- the two \(q=5\) frames realize the forced minimum of exactly one collision per row.
  With Theorem 2's tight \(q-2\le(q+1)/2\) and Theorem 6's saturated \(\lambda\)-coset,
  that is a third independent counting bound tight exactly at \(q=5\).

What the invariant-half clique pass (twenty-eighth) adds:

- **The relaxation.**  Discarding condition (A) and keeping only chord externality, every
  coherent system becomes a clique of size \((q+3)/2\) in \(\Gamma_q\), the graph on the
  \(q(q-1)/2\) internal points of the conic with adjacency "the join misses the conic".  The
  reduction is exact: (B) forces \(z_j\ne z_i^q\), so the \(n\) elements give \(n\) distinct
  internal points, and \(\alpha_{ij}\beta_{ij}=\operatorname{Res}(F_i,F_j)=B^2-QQ'\) has
  character \(-1\).  \(\Gamma_q\) is regular of degree \((q^2-1)/4\);
- **Theorem 10 (unconditional, all odd prime powers).**  An external line \(\ell\) carries
  \((q+1)/2\) internal points \(C_\ell\), automatically a clique.  An internal point off
  \(\ell\) is joined externally to all of \(C_\ell\) **iff** it is the pole \(\ell^{\perp}\)
  **and** \(q\equiv3\pmod4\).  The proof is exact: on \(v_0^{\perp}\cong\mathbb F_{q^2}\) the
  adjacency invariants are \(\chi_q(\sigma^2-1)\) over the trace values of a norm sphere, the
  set inclusion \(S_\lambda\subseteq S_1\) forces \(\chi_q(\lambda)=+1\) and hence equality by
  the counts \((q\pm1)/2\), and equality then forces
  \(\chi_q(\lambda-1)=\chi_q(1-\lambda)=+1\), contradicting the rational-trace requirement
  \(\chi_q(\lambda-1)=-1\).  No Weil bound is used; the analytic route would only give
  \(q\le16\);
- **The dichotomy.**  \(\omega(\Gamma_q)=(q+3)/2\) for \(q\equiv3\pmod4\), attained by
  \(C_\ell\cup\{\ell^{\perp}\}\), and \((q+1)/2\) for \(q\equiv1\pmod4\) with \(q>5\); checked
  for every odd prime power \(q\le49\), including \(9,25,27,49\).  \(q=5\) is the exception in
  its class, and its \(4\)-cliques are not line-anchored;
- **Consequence for routing.**  The invariant half decides \(q\equiv1\pmod4\) and provably
  cannot decide \(q\equiv3\pmod4\).  This is the operational form of the twenty-seventh pass's
  localization of non-invariance in (A);
- **Two free upgrades.**  \(N(\varphi_i(z_j))=\alpha_{ij}/\beta_{ij}=1/(1-g_{ij})\) in the
  chart carrying \((z_i,z_i^q)\) to \((0,\infty)\), so Theorem 9's level sets are the circles
  of the elliptic pencil with those limit points and Corollary 9.2 becomes a pencil-incidence
  statement with \(q+1\)-point fibres; and
  \(\prod_i\chi_q(c_i)=\chi_q(-\gamma_1)^{(q+3)/2}\) ties Theorem 9's signs to the composition
  normal form (prime \(q\) only, inheriting that form's status);
- **negative, and load-bearing:** maximum \(\Gamma_q\)-cliques are not a single orbit — the
  counts \(21,220,855,759\) at \(q=7,11,19,23\) exceed the external-line counts — so Theorem 10
  does not give the general bound, and gate 0 is not a corollary of it.

What is now settled computationally: the complete classification, every \(k\) at once,
for every odd prime power \(q\le 43\) — only the four-frame at \(q=5\) and the Clebsch
hexagon at \(q=11\).

Remaining frontier: counting cannot finish the job (both \(k_{\min}(q)\) and the largest
conic-external arc \(m(q)\) are \(\sqrt{2q}+O(1)\), and which is larger alternates with
\(q\)).  The sixth pass proves the primitive Jacobi collision lemma and closes the entire
saturated-external branch.  The seventh pass gives the strict nonsaturated bound, divides
the direction polynomial by its forced Moore factor, localizes the defect, and closes
\(\delta=0,1\).  The saturated-internal branch is now reduced to proving that no coherent
double-clique system exists for \(q>5\); the exact audit closes it only through \(q=43\).
At nonsaturated defect \(\delta=2\), both the direct Segre discriminant comparison and the
unweighted subresultant/moment repairs are closed negatively: the former loses the spare
factor, the subresultant remains degree \(\Theta(q)\) after its exact \(E_P^2\) division,
and both residual fibre shapes satisfy all global slope moments.  The dual-pencil
intercept calculation now proves that its natural conic-weighted norm also remains at
degree \(\Theta(q)\).  No current small-degree nonsaturated route remains.  The
all-internal defect-two near-transversal classification, genuinely pair-coupled carriers,
and second-order covering counts remain structural possibilities; residual slack
\(\delta\ge3\) stays open behind the defect-two gate.  The selected-witness kernel
curves do not supply the missing global carrier: their degrees and stabilizers are
field-specific.

**Signed-resultant/monodromy outcome (2026-08-08):** the user selected the
\((R,\gamma)\) route. Its first discriminator closes ordinary monodromy as a
standalone obstruction: over \(\mathbb F_7\),
\(R=X^5+4X^4+6X^2+2X\) has a totally split irrational quadratic fibre and
full geometric monodromy \(S_5\). The exact replacement is a signed/Kummer
pair resolvent. A new row-resultant identity proves that, on every split
quadratic fibre, F2 chord externality already implies the F1 derivative
class, so F1 is only a cheap enumeration filter. The TT2 check then shows
that pair resultants alone are still too coarse: they lose the separate
within- and cross-fibre signs. Theorem 13 makes constant within-fibre triangle
holonomy equivalent to coherence for \(q\equiv3\pmod4\), while
\(q\equiv1\pmod4\) retains an even switching ambiguity and a rank-one
Rédei-type matrix. Theorems 14--15 make triangle holonomy projectively
invariant and express it as
\(-\chi_q(g_{ij}g_{jk}g_{ki})\); every forced row collision is confined to
one switching-color class. The next gate is split by residue class:
projectively normalize a base conjugate pair and attack this cross-ratio
two-graph for \(q\equiv3\pmod4\), while testing rank-one 2-descent for
\(q\equiv1\pmod4\). If both signatures are generically permitted, stop the
monodromy route and move to masked Rédei. See
`notes/2026-08-08-c756-signed-resultant-monodromy-pivot.md` and its adjacent
evidence bundle.

**Signed-elliptic-fusion EJ outcome (2026-08-08):** the new closed-form
operator meets the exact condition that reopens the stopped equality route.
On internal conjugate pairs define \(K_{PQ}=\chi_q(g_{PQ})\) on external-join
edges and zero elsewhere. Up to switching when \(q\equiv1\pmod4\),
\[
 K^2=\chi_q(-1)K+(q^2-1)I/4.
\]
It is the Frobenius-odd compression of Paley character convolution. Its
distinguished eigenspace has a sharp support bound \((q+3)/2\), and equality
has exactly the signed F2 plus constant-holonomy pattern; for
\(q\equiv3\pmod4\) this is equivalent to coherence. Thus the live proof gate
is now classification of minimum-support eigenvectors of this signed elliptic
fusion, not another field-by-field theta fit. Uniformly, if \(A\) is the
binary passant/internal incidence operator, then
\(\bar K=A^2+((q+1)/2\bmod2)I\), so the general passant code is the image or
kernel of \(\bar K\) according to \(q\bmod4\). At \(q=13\), this is exactly
C817's projector \(A_9+A_{10}+A_{12}=e_K\) onto the \([78,36,12]_2\) code.
The complementary real projector is an orthobiangular tight frame with angles
\(0,\pm2/(q+1)\); equality systems are precisely its smallest possible
regular-simplex circuits. Any \(n-1\) signed members uniquely reconstruct the
last, distinct equality supports meet in at most \(n-2\), and for
\(q\equiv3\pmod4\) outside-sign parity makes every coherent support a maximal
external-join clique. This is now the preferred classification interface.
One point earlier, a signed seed of size \(m=(q+1)/2\) has completion scores
\(s_R\) with exact energy \(2m(m-1)\), and extends iff one uniquely determined
score reaches \(\pm m\).  The existing local-graph table actually excludes
even these seeds for every tested odd prime power \(5<q\le49\).
For each candidate completion the Schur defect
\(\Delta_R=m(m+1)-s_R^2-t_R\) is a nonnegative integer proportional to the
enlarged Gram determinant; it vanishes exactly at completion.  Otherwise the
reconstructed vector has squared distance at least \(2/m\) from every signed
frame vector, so there are no analytic near-misses.
Every \(\Delta_R\) is even and the total defect is
\(m(m+1)(2m-1)(m-2)\).  This closes parity and averaging as finishers: both
allow an isolated zero.  The Schur defect is therefore an exact equality
certificate, not yet the arithmetic obstruction.

The complementary projector now has an integral geometric square root.  If
\(Z\) is the passant/internal incidence matrix with its canonical row
switchings, then
\[
Z^{\mathsf T}Z=mI-\epsilon K.
\]
This unifies the real frame and binary incidence square.  A coherent
\(m\)-seed is an internal \(m\)-arc; its signed line-sum vector \(Zx\) has
exactly \(m\) nonzero entries, on the singleton passant lines.  It completes
at \(R\) exactly when \(Zx=\pm Ze_R\): the singleton passants must form the
passant pencil through \(R\), with one globally compatible sign.  Unsigned
concurrence is insufficient because it loses triangle holonomy.  The live
gate is consequently a signed tangent-pencil/coherent-\(m\)-arc
classification, with the full proof and certificate in
notes/2026-08-08-c756-signed-resultant-monodromy-pivot.md.

The normalized-pencil pass now makes that gate affine.  After sending the
deleted pair to \(\{0,1\}\), the seed is exactly one point on each nonsquare
direction through \(0\), and all its secants have square direction.  Each
nonsquare direction gives a balanced factorization
\(\widehat H_LQ_L=X^{q-1}-1\) with both factors of degree \((q-1)/2\).
This is not the nonsaturated masked identity: it is a family of injective
projection slices, whereas masked \(h=0\) is one chord product covering every
direction.  The genuine \(q=5\) frame also disproves the tempting claim that
each balanced factor is one quadratic-character coset.  See
notes/2026-08-08-c756-normalized-pencil-selector.md.

The infinite-tower positioning is bounded. The exceptional-root code ladder
pre-empted in the 2026-07-31 snapshot is a different Calderbank--Kantor/Taylor
family and does not pre-empt the signed real identity. But the general binary
conic-passant code and elliptic scheme are already known, and C756 already had
the Paley crown reformulation. Do not claim a new binary tower. The possible
publishable residue is the signed fusion, its Frobenius-odd support theorem,
and the exact all-\(k\)/Paper-IV bridge, after a focused novelty audit.

## Likely shape of a full all-\(k\) proof (2026-08-08)

This is a conjectural proof architecture, not a claimed theorem.  The most
likely final proof is not one monolithic argument.  It is a short synthesis
of the closed saturated-exterior chain with two remaining rigidity lemmas,
one saturated-internal and one nonsaturated.  The elegant outcome would prove
both lemmas from one half-Paley/Rédei rigidity theorem.

### Saturated-internal acceptance gate

Let \(Y\) be a hypothetical equality support of size
\(n=(q+3)/2=m+1\), and let \(y\) be its signed indicator.  The signed-fusion
equality and integral incidence factorization give
\[
 Ky=\epsilon my,\qquad
 Z^{\mathsf T}Z=mI-\epsilon K,\qquad
 Zy=0.
\]
The last equation is the decisive geometric form.  Every passant line meets
\(Y\) in zero or two points, and in the two-point case the signed incidences
cancel.  Through each \(P\in Y\), the other \(m\) support points occupy
exactly one point on each of the \(m\) passant lines through \(P\).  Thus an
equality support is a perfect signed transversal of every passant pencil, not
merely a small codeword or an extremal eigenvector.

Delete \(R\in Y\) and write \(x=y-\eta_Re_R\).  Then
\[
 Zx=-\eta_RZe_R. \tag{A}
\]
Consequently the uniform saturated theorem only needs the restricted
statement

> For \(q>5\), no coherent internal \(m\)-arc has signed
> singleton-passant vector equal, up to sign, to a point column of \(Z\).

This is the correct target.  Uniform nonexistence of every coherent
\(m\)-seed and the full minimum distance of every passant code would both be
stronger than necessary.  The proof should use (A) from the outset.

The likely route is to normalize \(R\) and two seed points projectively, then
parameterize the \(m\) passants through \(R\) by one quadratic-character half
of a projective line.  The seed chooses one second point \(P_u\) on each
passant.  Pairwise passant joins constrain the quadratic characters of the
divided differences of the selector \(u\mapsto P_u\); triangle holonomy
retains the compatible square-root signs that ordinary resultants lose.  A
Rédei--Szőnyi product over the full half-domain should then force the selector
to be fractional-linear or Frobenius-linear.  The expected projective outputs
are the known line-plus-pole false positives, rejected by the signed arc
condition, together with the exceptional \(q=5\) four-frame.

An equivalent classical formulation is a restricted minimum-word/tangent
theorem: classify signed internal arcs whose passant intersections are
everywhere even and whose deletion tangent vector is one signed pencil.  A
Segre tangent-polynomial proof of that statement would be an acceptable
branch-specific finisher even if no common master lemma emerges.

### Nonsaturated acceptance gate

For the nonsaturated branch, delete one arc point, choose the spare external
line, and form the masked Rédei direction polynomial.  The required theorem
remains
\[
 h\ge1:
\]
a conic-external arc cannot determine every direction on that line.  If
\(h=0\), the Rédei polynomial has a completely split complement on every
relevant direction.  Comparing those factorizations should again produce a
large partial character-preserving map.  Rigidity must force a projective
degeneration--a line, conic, or line-plus-pole configuration--contradicting
the arc and point-type hypotheses.  Once \(h\ge1\) is uniform, the existing
defect inequalities and certified boundary range are intended to exclude
every nonsaturated \(\delta\ge2\) family.

### Preferred common engine

The highest-value version of the proof establishes a theorem of the following
shape.

> **Half-Paley rigidity target.**  A map defined on a
> quadratic-character half of \(\mathbf P^1(\mathbb F_q)\), whose pairwise
> divided differences and triangle signs have the prescribed Paley pattern,
> extends projectively, apart from explicitly classified small exceptions.

The saturated branch applies this theorem to the signed passant-pencil
selector.  The nonsaturated branch applies it to the masked direction
selector.  In both cases the projective outputs are then rejected
geometrically, except for the required small examples.  Such a master lemma
would be the broadly reusable mathematical contribution and would explain
why the two apparently independent all-\(k\) obstructions belong in one
paper.

### Expected final assembly and investment order

The final proof should have four modules:

1. the existing reduction of arbitrary conic-filling arcs to the
   saturated-exterior, saturated-internal, and nonsaturated cases;
2. the already closed saturated-exterior classification;
3. the signed perfect-pencil theorem above, leaving only the \(q=5\)
   saturated-internal example; and
4. the masked direction theorem \(h\ge1\), followed by the existing
   parameter squeeze and finite boundary checks.

Current subjective distribution for the missing proof mechanism is:

- 30%: one joint, two-direction half-Paley/Rédei rigidity lemma closes both branches;
- 50%: a Segre tangent/polarity theorem closes saturation and a separate
  masked Rédei lemma closes nonsaturation;
- 15%: the signed \(p\)-adic/incidence-lattice model supplies the saturated
  obstruction; and
- 5%: composition-specific descent or another unexpected arithmetic route.

Do not invest further in theta/PSD strengthening, global defect moments,
generic monodromy, unsigned resultants, or unrestricted seed
classification.  They either discard the switching information or prove a
substantially stronger statement than all-\(k\) requires.  The normalized
selector comparison is complete and says the one-variable carriers differ.
The immediate highest-EV calculation is therefore the first joint invariant
of two balanced slices under \(\tau(v)=1-v^q\), with the prior
single-coordinate moment wall as a hard stop rule.

## Current boundary

- Open problem as stated: `papers/clebsch-rigidity/clebsch_rigidity.tex:1485-1489`.
- The \(k \ge 8\) / \(k \ge 9\) obstruction boundary:
  `papers/clebsch-hexagon-code/clebsch_hexagon_code.tex:1646-1647`.

## What must be proved

Two independent uniform obstructions are still required:

1. classify the saturated-internal family \(k=(q+3)/2\), proving that only the
   \(q=5\) four-frame covers; and
2. exclude every nonsaturated family with \(\delta\ge2\), beginning with the
   defect-two boundary \((q,k)=(53,12)\).

The old secant-pencil and field-by-field association-scheme certificate candidates are
superseded.  The cleanest saturated-internal statement is now equality in the signed
elliptic fusion, whose mod-two shadow at \(q=13\) is the binary passant-code projector:
for \(q>3\), prove that \(K_q\) meets the lower bound \((q+3)/2\) only at \(q=5\), with
four-frame supports.  Equivalently, after fixing a support point \(P\), exclude cliques
of size \((q+1)/2\) in the local Segre-tangent graph \(H_{q,P}\).  This formulation keeps
the no-three-collinear information lost by the global external-join graph.  It is open;
the optimal-PSD exactification route has stopped.  The older crown, Baer-subline, and
composition normal forms remain equivalent or weaker diagnostic interfaces, not the
next investment.
The nonsaturated branch has no bounded per-line algebraic-compression gate left.  Its clean active
target is now to prove \(h\ge1\): after deleting any arc point, a conic-external set cannot
determine every direction on a spare external line.  This is a masked Rédei--Szőnyi-style
direction theorem whose natural global carrier is the completely split chord polynomial;
the weighted collision statistic \(R\) remains a fallback.  The next global diagnostic
is to geometrically label the compressed prefix-extension classes.  The unexpected
\(q=13,29,31\) missing-set curves are now extracted and close as a uniform route.  Raw
entropic uncertainty, degree-two Lloyd moments, and unstructured local cumulants are
closed-negative.

Highest-EV next action: normalize two nonsquare directions \(L,L'\), express
the roots of \(\widehat H_L,\widehat H_{L'}\) as two projections of the same
radial selector, and test the first resultant/gcd invariant that uses
\(\chi_2(v-\tau(w))=-1\).  Continue only if its degree is bounded
independently of \(m\); stop if it reduces to the prior set equality or
single-coordinate moment theorem.  On failure, split the proof investment:
a Segre tangent/polarity theorem for saturation and masked \(h\ge1\) for
nonsaturation.  The signed \(p\)-adic lift of \(2K-\epsilon I\), using \(Z\)
as integral model, remains the saturated fallback.
Larger PSD algebras, total-defect averaging, parity, and more global moments
remain closed.  A focused original-source/forward-citation audit checks the
exact fusion/frame identities in parallel.  Do not return to full-support enumeration.  This closed-form operator satisfies the card's condition
for reopening the equality route.  The older local minimum-passant-code/forbidden-clique
certificate passes have met their stop rule and should not be repeated.  The historical
coordinate routes below explain the obstruction and remain reusable inputs, not the live
route.  The tight balance theorem proves that another global spectral bound cannot finish it.
The bare cross-ratio nonsingularity shortcut is closed, the Ball--Lavrauw tangent tensor
does not globalize its adjugate kernel line, and the prime-field first-cofactor section
has exact canonical form but linear reduced support and Cartier width.  The four-point
row-transition diagnostic also closes: its negative controls have no complete transition
systems, their partial rational degree grows linearly, and their pole and cross-ratio
profiles add no radial constraint.  Route F's sparse integral Paley-trade census
passed its continue gate, and the digit-tower pass has now converted it into proved
structure: coherence alone forces rational power sums through the critical degree,
uniform valuation \((q+3)/2\), and the composition normal form
\(G=(R-\gamma)(R-\gamma^q)\) with \(R\) rational of degree \((q+3)/2\) and \(\gamma\)
a quadratic point.  The \((R,\gamma)\) classification remains the arithmetic
fallback, but ordinary monodromy and pair resultants have failed their discriminators;
its surviving sign data are now compressed by the signed-fusion equality problem.  The direct adjugate/second-compound calculation stays
parked unless a global low-degree carrier emerges.
The fragmented-Moore/intercept mechanism is independently durable negative material: it is
the precise explanation requested here for why the chord-moment compression family cannot
close.  The exhaustive masked-direction audit kills threshold unification but promotes
the simpler \(h\ge1\) theorem, supported without exception in the certified range; this
sharpens but does not yet raise the 10--15% full-theorem odds.  The probability cheap tests
leave one bounded global lead but no new theorem.  Cheap
hygiene still owed before a later end-to-end handoff is one explicit
\(q=27\) extension-field audit of the closed saturated-external chain and one consolidated
read of the full eighteen-pass argument; neither item reopens a closed mathematical branch.

Decision split: do not price the saturated crown and the full theorem as one outcome.
The realistic publishable narrowing is the **complete saturated classification** — over
every field, the four-frame and Clebsch hexagon are the only saturated conic-filling arcs.
It needs only the coherent-double-clique gate and is currently estimated at roughly 50%
(the gate itself 55--65%, discounted for the outstanding extension-field and end-to-end
verification).  The full all-\(k\) theorem additionally requires a new nonsaturated
invariant and remains a 10--15% lottery ticket; the kernel-curve pass removes one of the
two surviving cheap global diagnostics without changing those odds.  A positive saturated result would trigger
its own paper-scoping task; it is not silently promoted to a manuscript under C756.

## Prior estimate

The review prior was ~30% for the full theorem (§12.6), before the last identified
small-degree nonsaturated route failed.  The saturated-internal audit produced a strong
normal form but not its final classification, while the bounded dual conic-weighted-pencil
norm fails by a proved degree-\(\Theta(q)\) fragmentation mechanism.  Recalibrated odds:
~10--15% for the full all-\(k\) theorem, and ~50% for the complete saturated
classification.  The latter is the active bet; the former remains alive only if genuinely
new nonsaturated structure appears.

## Scope

Research task, not a manuscript task. No edits to `papers/` under this ID; a positive
result triggers a separate paper task, and a negative result is written up as a dated
note plus, if warranted, an amended open-problem statement.

## Runner-up (not this task)

An all-good-reduction version of Paper II's classification. The missing ingredients are
named in `papers/clebsch-factorization/clebsch_factorization.tex:1390-1396` (integral
models, degeneration analysis). Bigger than a bounded push; do not fold it in here.
