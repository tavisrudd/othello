# C210 observations and synthesis after ansatz failure

**Lane:** `relconic`

**Date:** 2026-07-18

**Status:** synthesis after the completed C210 mechanism obstruction. This note records proved
results, publication judgments, cross-lane connections, open leads, and recommended next attacks.
It proves no new theorem and introduces no new computational evidence. Evidence tags below are:

- **PROVED:** a written mathematical proof exists in the cited C210 or source-lane report;
- **CHECKED:** an exact finite computation with a committed reproducibility boundary exists;
- **SYNTHESIS:** a conceptual identification or proposed common language, not yet a theorem package;
- **OPEN:** a scoped research attack or conjectural extension;
- **EDITORIAL:** a recommendation about manuscripts or task routing.

## Executive assessment

C210 did not construct the desired infinite family of `C`-complete arcs of sharp square-root
scale. It did something materially stronger than a failed search: it proved that the selected
trace-one two-repair-coset architecture is collision-forcing throughout the sufficiently large
odd `8`-tower, including every algebraic factorization and degeneration stratum in its certified
scope.

The scope has one important asymmetry. The obstruction is uniform for every nonconstant-height
specialization once `q>=32768`, and every exceptional stratum closes once `q>=512`; on the
constant-height stratum it closes the exact `GF(8)`-defined scalar-extension families, not fresh
constant-height coefficients chosen independently in each larger field.

The correct conclusion is therefore not “the construction search failed, move on.” The durable
output has four layers:

1. a publishable bounded mechanism obstruction with explicit thresholds;
2. a finite positive construction signal in `PG(2,64)`;
3. a reusable layered-arc/collision-curve calculus;
4. a plausible program-wide conic-matching language joining relative arcs, conic Schreier games,
   repair ports, continuation reconstruction, and code/deep-hole geometry.

The main weakness is concentration and exposition, not mathematical substance. The final theorem
is currently stated using internal “C210 ansatz” language and must be restated invariantly before
it is manuscript-ready. The strongest new open attack is to determine whether the collision
obstruction is robust under deletion to partial repair domains. The highest-upside broader theory
lead is a carrierwise Baer-fiber secant-defect identity coupling invisible mass to repeated-hit
redundancy, but its motivation must come from a new equality/stability statement rather than the
tautological recurrence of the `sqrt(2)` counting constant.

**EDITORIAL:** do not archive `relconic` merely because the full-coset ansatz is closed. Task
allocation and the lane-finish administration remain separate decisions, but the mathematical
program has a well-defined continuation.

## Plain-language account

The construction tried to build the desired arc from several regular layers of points. It had to
keep two promises:

1. no three chosen points ever lie on one line;
2. lines through pairs of chosen points cover everything required outside the conic.

C210 proved that this particular layer-and-repair recipe always breaks the first promise once the
field is large enough. Somewhere in every permitted nonconstant specialization, a seed point and
the relevant repair points line up. The algebraic collision curve is a machine for locating such
bad triples. Its ordinary part always supplies one, and every special branch that might have been
an escape was classified and shown to supply one as well. The reconstruction proof then shows that
these algebraic solutions are three real, distinct selected points, not duplicated points or fake
resultant roots.

This is much stronger than “we searched many parameters and did not find a construction.” It says
that every nonconstant-height specialization is eventually bad, every exceptional stratum is bad
from `q=512` onward, and every `GF(8)`-defined constant-height scalar family is eventually bad.
Fresh per-field constant-height choices remain outside the theorem. It is also much weaker than a
global impossibility theorem: a different template, a partial repair domain, an orbit or exchange
construction, or another geometric architecture may still produce `C`-complete arcs of order
`sqrt(Q)`.

## The motivating problem and notation

Let `C` be a nonsingular conic in `PG(2,Q)`. A `C`-complete arc is an arc

    A subset PG(2,Q) \ C

whose secants cover every point outside `A union C`. Thus it must satisfy two logically separate
gates:

1. **arc legality:** no three selected points are collinear;
2. **relative completeness:** every required point lies on a selected secant.

The existing relative-conic paper proves a lower scale of order `sqrt(Q)` and a general upper
transfer with a polylogarithmic loss. C210 sought an explicit infinite family of order `sqrt(Q)`.

For the square-order realization behind the selected construction, write `E/F` for a quadratic
extension, `|F|=q`, and `Q=q^2`. The C210 odd tower takes

    q = 8^m,  m odd.

A construction with `Theta(q)` selected points would therefore have the desired
`Theta(sqrt(Q))` size in the ambient plane.

## What C210 proved

The load-bearing theorem is
[`2026-07-17-c210-bounded-two-repair-coset-obstruction.md`](2026-07-17-c210-bounded-two-repair-coset-obstruction.md).

### Uniform nonconstant-height obstruction

**PROVED.** On the trace-one two-repair-coset ansatz with `delta*p != 0`, for every

    q >= 32768

and every nonconstant-height specialization `(a,b) != (0,0)`, there is a reconstructible genuine
seed--cross-repair collision. Consequently the selected point set is not an arc, before any affine
or projective coverage question is asked.

The larger threshold is needed only for the absolutely irreducible complement of the generic
`a!=0,b!=0` factorization divisor.

### Sharper exceptional-stratum obstruction

**PROVED.** Every specialization in each of the following classes is already collision-forcing for
every odd-tower `q>=512`:

- `a=0,b!=0`;
- `a!=0,b=0`;
- every factorization branch on `a!=0,b!=0`.

The generic off-divisor complement at `q=512` is not claimed: the explicit Hasse--Weil lower bound
is negative there. This is a limitation of the proof threshold, not evidence that the field has a
surviving construction.

### Constant-height scalar-extension boundary

**PROVED + CHECKED.** On `a=b=0`, no arc-legal trace-one configuration defined over `GF(8)` remains
collision-free throughout its intended odd scalar tower.

The exact full unnormalized census checked `150,528` configurations. Of these, `7,512` were
collision-free for both seed colors, and none was arc-legal. Equivalently, among the twelve
arc-legal common-trace-one configurations, every one has an odd-degree collision factor for at
least one seed color.

This is the exact fixed-coefficient scalar-extension scope. It is not a theorem about arbitrary
new constant-height coefficients chosen independently in each larger field outside the certified
family statement.

### Global reconstruction identity

**PROVED.** The universal collision quadratics have the exact identity

    H = D_quad*B_quad + A_quad*E_quad = delta*N*G1,
    N = a^2+a+1,
    G1 = u^2+u*p+p^2*(w^2+w+1).

This identity is independent of `b`. On an odd-degree extension of `GF(2)`, `N` has no root because
its roots lie in `GF(4)`. After writing `u=p*v`, the equation `G1=0` becomes

    v^2+v+theta = 0,  theta=w^2+w+1,

and `Tr(theta)=1`, so it also has no rational root. Hence `H!=0` at every rational finite collision
parameter in the intended tower.

Every rational point of the collision resultant therefore reconstructs the unique common root

    r = J/H.

The possible `H=J=0` resultant artifact is absent globally, not merely checked branch by branch.

### Exact Artin--Schreier normal form

**PROVED.** On the generic scope `a*delta*N*b*p != 0`, put

    theta = w^2+w+1,
    N = a^2+a+1,
    Q = u^2+u*delta+delta^2,
    G1 = u^2+u*p+p^2*theta,
    G2 = u^3+u^2*delta+u*p^2*theta
         +delta*p^2*theta+delta^2*p,
    G2a = G2+delta*a*G1,
    psi = tau^2+b*Q*tau,
    sigma = a*delta*N*G1*G2a.

The collision cover has the exact form

    F = psi^2 + sigma*psi + R1,
    R1 = a^2*Q^2*B0.

The alternate quadratic slope is excluded on this scope, so this single Artin--Schreier form owns
the generic factorization locus. This reduction is one of the main publishable algebraic steps: it
turns a large quartic collision equation into one controlled factorization and second-layer
classification problem.

### Complete factorization classification

**PROVED.** On `a!=0,b!=0`, the quartic collision cover has a unique Artin--Schreier factorization
divisor. Over every odd-degree field, the residue system has exactly three branches:

1. `e=0`, with forced height `h0=0`;
2. `e=delta`, with

       h0 = p^2*(w^2+w+1)+e^2+e*b+e*a*p;

3. `delta=p`, `w in {0,1}`, with

       h0 = e^2*a^2+e*a^2*p+e*a*p+e^2+e*b+e*p.

Exact ideal memberships in the lossless `p=1` chart prove:

- every off-`e=0,e=delta` solution lies on branch 3;
- the branch-1/2 coefficient system forces its displayed height;
- branch 3 has nonzero leading coefficient;
- the all-`A_i` height loophole is empty.

No primary decomposition, heuristic factorization, or finite-field extrapolation is load-bearing.

### Point supply and explicit thresholds

**PROVED.** Off the generic factorization divisor, the collision cover is absolutely irreducible
of bidegree at most `(6,4)`. Its normalization has

    g <= (6-1)*(4-1) = 15.

Hasse--Weil gives

    #C(F_q) >= q+1-30*sqrt(q).

At most ten normalized points lie over the two projective boundary fibers, so

    q+1-30*sqrt(q) > 10

for every `q>=32768`. A remaining point is finite, reconstructible by the global `H` identity, and
genuine because the repeated seed/repair coincidence components lie on the excluded factorization
branches.

On `a=0,b!=0`, the bidegree is at most `(6,2)`, the genus is at most five, and at most eight points
are lost on the boundary. On `a!=0,b=0`, the normalized Artin--Schreier curve has genus at most four
and at most seven deleted points. Their explicit inequalities are positive throughout the odd
tower for `q>=512`.

On the factorization branches, the second-layer covers have genus zero or two, or reduce to
affine-linear forms. Exact reconstruction separates repeated points from genuine collision points.

### Computational evidence boundary

The proof bundle includes exact finite checks, but the infinite theorem does not extrapolate them:

- all `1,404,928` `GF(8)` parameter points in the residue census;
- exactly `48,608` residue-system solutions, equal to the three-branch union;
- all `261,632` normalized `GF(512)` `(delta,w)` pairs;
- exactly `1,022` triple-residual roots there, all on branch 3;
- direct projective-incidence reconstruction checks over `GF(64)`;
- the full `150,528`-configuration constant-height census.

The scripts and outputs are pinned by
[`2026-07-17-c210-reproducibility-manifest.md`](2026-07-17-c210-reproducibility-manifest.md)
and `papers/arcs_complete_outside_conic/analyze_c210_SHA256SUMS`.

This is a conventional computer-assisted proof, not a Lean formalization. The trusted boundary
includes exact finite-field code and computer algebra, with independent finite checks where
recorded. The infinite-tail step uses exact identities, exhaustive algebraic branch classification,
absolute irreducibility, explicit normalization/genus bounds, and Hasse--Weil.

## What C210 did not prove

C210 does not prove any of the following:

- nonexistence of `C`-complete `O(sqrt(Q))` arcs;
- impossibility of removing the polylogarithmic loss in the general upper bound;
- an obstruction to a different repair architecture;
- an obstruction to partial repair domains;
- an obstruction to orbit, exchange, probabilistic, or non-Baer constructions;
- collision-forcing on the generic off-divisor `q=512` complement;
- whole-tower genuineness for every recorded `q=8` branch exception;
- failure of affine coverage in the final ansatz.

The last distinction is essential: the theorem kills arc legality first. It makes no claim that
coverage itself would have failed had the selected set remained an arc.

## Positive and structural results found along the way

The long mechanism audit is
[`2026-07-16-c210-square-root-mechanism-audit.md`](2026-07-16-c210-square-root-mechanism-audit.md).
The compact source for the observations below is the legacy
[`2026-07-16-c210-discovery-track.md`](2026-07-16-c210-discovery-track.md), now correctly classified
as a task-work mechanism notebook rather than an incidental discovery log.

### Baer-contained arcs are impossible

**PROVED; NOVELTY OPEN.** Let the ambient plane have order `s^2`, let `B` be a Baer subplane of
order `s`, and let an arc `A` lie in `B`. The external points of `PG(2,s^2)\B` partition into the
external fibers of extended `B`-lines. Only fibers belonging to secants of `A` are covered. Since
an arc in `B` has at most `s+2` points, at least `(s^2-s)/2` `B`-lines are nonsecants, leaving at
least

    (s^2-s)^2/2

external points uncovered. For `s>=3` this exceeds the `s^2+1` points of an ambient conic.
Therefore no arc contained in one Baer subplane can be complete outside any ambient conic.

This is a family-level construction obstruction independent of the later two-repair-coset theorem.
The argument is elementary enough that it should be treated as presumably known until the
classical Baer-subplane and complete-arc literature is checked.

### The fiberwise sharp constant is bookkeeping, not evidence

**SYNTHESIS.** A Baer external fiber has about `s^2` points. An arc of size `k~c*s` has about
`c^2*s^2/2` secants. Restricting the global pair-capacity count to a carrier of the same order
necessarily reproduces the numerical threshold

    c >= sqrt(2).

The repeated constant is therefore neither a coincidence nor evidence for a new theorem. The
carrierwise program is justified only if it produces a genuinely stronger equality or stability
statement with new nonnegative redundancy terms.

### Two parallel subfield parabolas

**PROVED, with priority check still required.** For `E/F` quadratic and offsets `alpha,beta` with
`delta=beta-alpha` outside `F`, the two layers

    {[1:t:t^2+alpha] : t in F}
    union
    {[1:t:t^2+beta] : t in F}

form a uniform conic-disjoint `2s`-arc. The mixed determinant factors as

    (u-t)*((v-t)*(v-u)+delta),

and cannot vanish because the product term lies in `F` while `delta` does not.

The direct two-layer coverage idea works only at the small tested exception `s=3`; at `s=8` it
still leaves only `330` required points, making it a much stronger seed than earlier mechanisms.
Because these are affine parts of two conics in one pencil, the first priority check is the
classical literature on arcs contained in unions or pencils of conics. Translation and
hyperfocused arcs are the second comparison. No novelty claim should precede either audit.

### Universal height-interpolation interface

**PROVED.** Write an affine point as

    P(x,h) = [1:x:x^2+h].

For `x!=x'`, the chord through `P(x,h)` and `P(x',h')` has height at horizontal coordinate `y`

    H(y) = h + (y-x)*(h'-h)/(x'-x) - (y-x)*(y-x').

This one formula drives collision avoidance, repair interaction, and coverage. An independent
`GF(9)` incidence checker verified all `52,488` relevant cases.

For a repair graph `g`, three repair parameters are noncollinear exactly when

    1 + g[r,s,u] != 0,

where `g[r,s,u]` is the second divided difference. For quadratic height functions, seed--repair
collisions reduce to an exact split-polynomial test. In characteristic two, the quadratic
`X^2+pX+q` splits distinctly exactly when

    p != 0  and  Tr(q/p^2)=0.

This is a reusable calculus, not merely an implementation trick.

### The `PG(2,64)` nonlinear signal

**CHECKED.** At subfield order `s=8`, twelve nonlinear quadratic full repair layers survive. They
form three fixed-seed stabilizer orbits of size four. Each gives a `24`-arc with the following
unexpected property:

- every uncovered projective point lies on the line at infinity;
- hence the `24`-arc is complete in `AG(2,64)`;
- any two missing directions can be adjoined legally;
- the resulting `26`-arc is ordinarily complete and remains disjoint from the standard conic.

This affine completeness was not the property optimized by the search.

Among the six secant classes `AA,AB,AR,BB,BR,RR`, the unique minimal affine cover is

    AA, AB, AR, BB, BR.

Repair--repair chords are needed only for arc legality. The three cross-layer classes leave `56`
affine points; adjoining either same-seed class reduces the residue to `14`; both close it. The
geometry of the `56`- and `14`-point residues remains unexplained.

### Trace sets and the first sporadic-family explanation

**PROVED/CHECKED at the stated boundaries.** For `U outside F`, same-layer chord values form

    S_U = {U*p+q : p in F^*, Tr(q/p^2)=0},

of size `s(s-1)/2`. This explains the seed-layer coverage sets in characteristic two.

One `q=64` orbit has a basis-free trace/norm description. Its six successful parameters form one
Frobenius orbit and satisfy an exact trace/norm law. The obvious fixed-coefficient scalar extension
is destroyed by the reciprocal-trace count

    N_00 = (s-3+K_s)/4,

where `K_s` is a Kloosterman sum. The classical bound `|K_s|<=2*sqrt(s)` forces `N_00>0` for every
`s>=16`, explaining `GF(8)` as an exceptional zero-count field.

The final C210 obstruction supersedes the notebook question of whether the other two full-coset
`q=64` orbits might yield an infinite scalar family. Their finite geometry and orbit relationship
may still be worth explaining, but they are no longer infinite-family candidates in the certified
two-coset scope.

### Minor mechanism-notebook residue

The following observations are not the main C210 theorem, but they complete the record of the
legacy mechanism notebook.

- **Almost-complete conics point in the wrong direction (`REASONED`).** An almost-complete subset
  of another conic leaves points of that conic uncovered. After projective transport, more than
  four remaining points force the exceptional conic to be the transported conic by Bezout, placing
  the selected points on the prescribed conic rather than avoiding it. This cheaply rejects a
  tempting transfer; it is not a global obstruction.
- **A third layer over the original subfield is trivially illegal (`PROVED`).** Every vertical line
  over a subfield parameter already contains the two seed points, so a third point with the same
  horizontal parameter makes a collinear triple. Repair layers must move to a nontrivial additive
  coset or use a partial domain.
- **Constant full-coset repair is sporadic (`CHECKED`, bounded).** At `s=5`, two constant repair
  layers give complete `15`-arcs, while `s=7` has no arc-legal layer. No symbolic parameter law is
  known, so this is not an allocated infinite-family route.
- **Affine repair heights add no tested family (`CHECKED`, bounded).** Every arc-legal affine graph
  in the tested orders has zero slope and merely recovers a constant layer. Re-entry requires a
  structural theorem rather than more affine coefficient enumeration.
- **The three `q=64` nonlinear orbits are inequivalent only relative to the fixed seed
  (`CHECKED`).** It remains open whether representatives become equivalent after allowing the
  two-layer seed itself to move in its larger family. Fixed-seed inequivalence is sufficient for
  the obstruction program, but a finite-construction paper may want the full equivalence answer.

## Publishable inventory and strength assessment

Grades are qualitative portfolio judgments, not claims about venue acceptance.

| Rank | Result or package | Surprise | Paper strength | Assessment |
|---:|---|:---:|:---:|---|
| 1 | Exact prescribed-hole defect identity and sharp `sqrt(2q)` lower scale | A- | A | The strongest organizing theory in the relative-conic program |
| 2 | C294 explicit `Theta(q)` full-`PGL2` P-family | A | A- | Unexpectedly clean crossing of the full-group boundary |
| 3 | C210 complete odd-tower two-repair-coset obstruction | B+ | B+ now; A- only if C297 establishes natural breadth and the proof is repackaged invariantly | Deep and decisive inside its certified family |
| 4 | C84 exact conic-Schreier catalogue and generic escape boundary | B+ | B+ | Strong structural core when packaged with C294 |
| 5 | `PG(2,64)` affine-complete `24`-arcs and complete conic-disjoint `26`-arcs | A- | B alone; A- inside the C210 sequel | The strongest accidental finite construction signal |

The Baer-contained obstruction is a clean compact proposition rather than a standalone paper, but
should be presented as presumably known until its priority check is complete.
The carrierwise Baer-fiber defect program is unproved, but a successful theorem could itself have
`A`-level strength.

**Portfolio vibe:** `A-`. There is one clearly strong general relative-conic paper, one likely
strong conic-game paper, and one technically substantial construction-obstruction sequel. The
main deficit is distillation and invariant exposition.

## Recommended manuscript packaging

### Paper I: keep the current relative-conic paper focused

The manuscript
`papers/arcs_complete_outside_conic/arcs_complete_outside_conic.tex` already has a coherent spine:

- an exact prescribed-hole defect identity;
- a sharp square-root lower bound with equality/stability information;
- a projective-averaging upper transfer;
- exact small-field values and an evaluation-rank obstruction.

**EDITORIAL:** add at most the short Baer-contained obstruction, with a presumed-known hedge until
the literature check is complete, and a carefully bounded pointer to the structured construction
barrier. Do not insert the entire C210 elimination: its specialized algebra would overwhelm the
present paper's general theorem.

### Working alias `layered-arcs`: layered Baer-transversal arcs and collision obstruction

A coherent C210 sequel should have the following theorem-led structure:

1. quadratic-extension and prescribed-conic setup;
2. the two parallel subfield-parabola seed arc;
3. universal chord-height and divided-difference calculus;
4. trace-set coverage and split-polynomial collision criteria;
5. the exact `PG(2,64)` affine-complete construction;
6. an invariant definition of the trace-one two-repair-coset family;
7. the complete odd-tower mechanism obstruction;
8. computational and symbolic certificates in appendices/supplement.

A suitable working title is:

> Layered arcs over quadratic extensions: finite constructions and an asymptotic collision
> obstruction

The principal editorial task is to replace the phrase “C210 ansatz with parameters
`a,b,delta,p,w`” by a natural family definition in terms of two seed layers, two additive repair
cosets, their height functions, and the trace-one compatibility condition.

The C297 normal-form and C298 robust-collision gates are now complete. Drafting may begin once the
relconic integrator freezes the exact `layered-arcs` claim set. The manuscript must state C210 as
the proper common-curvature/common-linear-direction slice identified by C297; C304 owns the omitted
moduli and must not be silently absorbed as though C210 had covered them.

### Gated working alias `conic-scar-games`: conic-involution Schreier games

C84 and C294 do not yet justify a joint manuscript. They share a conic-involution language, but no
proved value-preserving transfer connects C84's fourth-centre density family to C294's mixed
subfield Cayley scar. Keep the lanes and claims separate. If such a transfer theorem lands, a
future `conic-scar-games` manuscript could use the following spine:

1. off-conic centres as projection involutions of the conic;
2. fixed/dead-point-deleted conic Schreier residuals;
3. exact `V4`, `D8`, and `S4` boundary catalogues;
4. generic escape to `PSL2/PGL2`;
5. C294's positive-dimensional full-group mirror-certified P-family;
6. exact statement of the unresolved abundance and `(ON)` transfer boundary.

C84's failed certificate candidates are research boundaries, not an impossibility theorem unless a
certificate language is formalized first. The existing `dihedral-schreier-node-kayles` manuscript
continues to own the proper-small-subgroup catalogue and is not this gated synthesis.

## Literature and novelty boundary

The exact relative-conic problem is not supplied by the nearest established constructions.

- Kim and Vu's general complete-arc method gives the transferred
  `O(sqrt(Q)*(log Q)^c)` scale rather than the desired sharp `O(sqrt(Q))` family:
  [*Small complete arcs in projective planes*](https://doi.org/10.1007/s00493-003-0024-1).
- Prescribed-symmetry constructions give important finite examples but not this infinite
  conic-relative theorem: Lisoněk--Marcugini--Pambianco,
  [*Constructions of small complete arcs with prescribed symmetry*](https://cdm.ucalgary.ca/article/download/61979/46677/176938).
- The two-parabola seed is the union of affine parts of two conics in one pencil. Classical work on
  arcs in unions and pencils of conics is therefore the first novelty boundary and could subsume
  the seed directly. Translation and hyperfocused arcs also include additive-subgroup graph
  constructions and examples complete off a focus line, so the second comparison is with
  Faina--Parrettini--Pasticci,
  [*Hyperfocused arcs in PG(2,32)*](https://arxiv.org/abs/0803.3933), and its cited translation-arc
  lineage before any novelty claim.
- Modern curve-based completeness arguments also use normalization and finite-field point bounds;
  see Bastioni--Micheli,
  [*On complete m-arcs*](https://doi.org/10.1016/j.jalgebra.2023.09.027). C210's distinctive claim
  must be the prescribed-conic sharp-scale architecture and its exact collision obstruction, not
  the generic fact that algebraic curves and Hasse--Weil can prove completeness or collision.

The safe novelty posture is therefore:

- claim the exact prescribed-conic definitions and obstruction only after a dedicated comparison;
- present the divided-difference and trace-set calculus as reusable infrastructure until its
  relationship to translation-arc formulas is settled;
- treat the `PG(2,64)` `24/26` phenomenon as an exact finite result, with projective equivalence and
  priority still to audit;
- avoid describing the general use of curves, Artin--Schreier covers, or Hasse--Weil as new.

## Reusable C210 infrastructure

The reusable object is not one large resultant. It is the following proof pipeline:

    layer description
        -> universal chord/divided-difference formula
        -> collision resultant or Artin--Schreier cover
        -> exact reconstruction denominator
        -> factorization and exceptional-divisor classification
        -> normalization, genus, and deleted-point bound
        -> explicit finite-field collision threshold
        -> finite exceptional-field certificate

A reusable mathematical and certificate interface should distinguish:

- **Layer:** domain coset and height function;
- **CollisionCover:** exact polynomial and degree conventions;
- **Reconstruction:** the `H,J` data and proof that a resultant point is a real common root;
- **ExceptionalDivisor:** exhaustive branches and their exact algebraic certificates;
- **PointSupply:** absolute irreducibility, constant field, genus, boundary, and threshold;
- **Genuineness:** removal of repeated-point components;
- **FiniteExceptions:** exhaustive certificates only where asymptotic bounds are silent.

**EDITORIAL:** freeze the current hashed scripts. Extract shared software only when a second
construction actually consumes this interface; do not refactor the proof bundle merely to make it
look like a library.

## The common conic-matching object

### Proposed dictionary

**SYNTHESIS.** Away from the usual even-characteristic nucleus/degeneracy caveats, one off-conic
point `x` has four equivalent readings:

    off-conic point x
      |-- projection involution sigma_x on the conic
      |-- matching M_x of conic points
      |-- pointed repair port: {u,v} repairs x iff {x,u,v} is a 3-circuit
      `-- projective binary-quadratic-form / matrix A_x

For a set of centres `S`, the union of these matchings carries several theories at once:

- **relative-conic geometry:** arc collisions and secant coverage;
- **conic Schreier games:** Node--Kayles on the residual matching union;
- **repair codes:** interacting pointed repair ports and helper conflicts;
- **continuation rigidity:** reconstruction of centres and ambient incidence;
- **coding/gem geometry:** projective circuits, deep holes, and named uncovered loci.

C210 studies linear dependence/collisions and coverage in algebraic families of centres. C84 and
C294 study the game on the corresponding residual matching union. Complete ports studies one
pointed matching as a repair interface. Continuation asks how much of the centre configuration and
ambient geometry can be recovered from the abstract continuation structure.

This classical dictionary is useful program-wide notation, not by itself a theorem package.
Characteristic-two conventions and reconstruction lemmas should be written only for a concrete
consumer. The research opportunity begins with the exact multiplicity identity below.

### Exact dead-set and redundancy interface to seek

For centres `S`, the C84 dead conic set is cut out by centre--centre secants, together with the
individual generator fixed points required by the residual convention. The relative-conic paper's
secant incidence `I_C(S)` counts these hits with multiplicity. Their difference is a redundancy
term measuring several selected secants hitting the same conic vertex.

**OPEN:** formulate an exact identity relating:

- total secant incidence with `C`;
- the number of distinct fixed/dead residual vertices;
- repeated conic-hit multiplicity;
- the off-conic coverage defect.

This could sharpen the live-vertex/live-edge drain potential in the odd-plane game and provide the
carrierwise form of the relative-conic defect theorem.

## Contribution to the crowning-gems program

The live crowns map is
[`handoffs/2026-07-17-crowns.md`](handoffs/2026-07-17-crowns.md).

### Crown I: full-group value theory

The C294 bronze theorem is exact. Let `q=p^e`, where `p>5`, `e` is odd, and

    p congruent 3 or 27 (mod 40).

For every parameter `b` satisfying

    b notin {0,1,-1,2},
    (b-1)^2+4 is a nonsquare,
    F_p(b)=F_q,

take the four off-conic centres

    S_b = {(0,1,1), (-1,0,1), (1,b,1), (-b,-1,1)}.

Together with the conic frame points

    P_infinity = (1,0,0),  P_0 = (0,1,0),

they form a six-arc. Their projection involutions generate the full `PGL2(q)`, and the
fixed/dead-vertex-deleted conic residual is a Node--Kayles P-position.

The strategy certificate is the fixed-point-free involution

    tau(t) = -1/t,

which conjugates the four generators in two pairs, preserves the deleted set, and pairs live
nonadjacent vertices. The group proof uses a nontrivial unipotent, exclusion of Borel/torus/`S4`
maximal overgroups, a nonsquare determinant to leave `PSL2`, and the projective trace invariant

    kappa(A2*A0) = 1/(1-b)

to exclude every proper definition field.

For `e=1` there are exactly `(p-5)/2` admissible parameters. For `e>1` there are exactly

    (1/2) * sum_{d|e} mu(e/d)*p^d,

precisely half the full-degree elements. This is a one-dimensional `Theta(q)` full-group family,
not C84's two-dimensional density statement and not the missing off-conic-to-on-conic transfer.

C294 has reduced its silver boundary to a mixed-determinant-class regular `PGL2` Cayley scar. A
right-regular pairing kills the same-class cases; the complete remaining pairing defect lies in
one dihedral involution-centralizer coset.

C210 does not provide the missing Node--Kayles response, but its proof architecture suggests the
right organization:

1. prove the generic region by a value-preserving pairing or recursion;
2. define the exact scar by projective trace/determinant equations;
3. classify its components and definition fields;
4. prove a local value-preserving surgery on the scar;
5. isolate and verify only genuinely bounded exceptions.

**OPEN:** express the centralizer-coset defect using projective trace invariants and prove a
closed-neighborhood transfer or local response on that locus. Counting the locus alone does not
prove its game value.

### Crown II: intrinsic reconstruction

A colored projection matching `M_x` determines its centre `x`: the corresponding conic chords
reconstruct the unique projection centre. Therefore a colored family of matchings reconstructs the
centre configuration, its centre--centre secants, its collinear triples, and the associated
projective 3-circuits.

The substantive Crown II question is whether the matching colors can be recovered intrinsically
from the uncolored continuation or residual object. C210 supplies possible discriminators:

- fixed-point type;
- collision and divided-difference profiles;
- secant-intersection multiplicities;
- exceptional factorization type;
- interaction with the named deep-hole conic.

This should feed C295/Crown II, not expand the current N1-only continuation manuscript.

### Crown III: reconstruction plus exact value

The common conic-matching object provides a plausible combined pilot:

1. recover the matching/port decomposition intrinsically;
2. recover centres, incidence, and the associated code;
3. prove the residual game value by a C294-style mirror or exact catalogue;
4. show that geometry and value are intrinsic to the same abstract structure.

The Clebsch/frame continuation object remains the leading bounded pilot. C210 supplies the geometry
and collision side; C294 supplies a full-group value mechanism; complete ports supplies the coding
and repair interpretation.

## Contribution to the odd-`q` conjecture

The logical boundary is recorded in
[`handoffs/c84/odd-q-position.md`](handoffs/c84/odd-q-position.md).

### What C210 does not give

**BOUNDARY.** C210 gives no direct odd-`q` game theorem. Its final obstruction is in characteristic
two. Moreover, C84's exact `q=29` stress test shows that internal mirror/pairing and unrestricted
two-ply adaptive automorphism certificates do not explain the observed class-D P-density.

The Grundy-zero predicate is not presently a bounded algebraic condition. Hasse--Weil cannot count
P-positions directly.

The quantitative C84 evidence behind that boundary is important:

- for the rooted class-D family at `q=29`, exactly `139/753` legal fourth-centre residuals are
  P-positions;
- nevertheless, none of the `753` roots admits even the deliberately stronger unrestricted
  two-ply adaptive-pairing certificate in which each first move may choose an arbitrary reply and
  an arbitrary residual graph automorphism;
- `739` roots have no first move covered by such a response and the remaining `14` have exactly two;
- at `q=13`, `13/131` roots do pass the certificate, and direct Grundy recursion verifies all
  thirteen as P, showing that the event is meaningful rather than malformed.

C84 separately closes the following as uniform positive-density mechanisms:

- root pairing or another larger internal automorphism search;
- an immediate bounded reply core (`q=29` P roots have a worst first move whose winning replies
  leave a component of size at least `14`);
- fixed colored-word response rules (all `88` forced-reply word patterns also occur on losing
  replies);
- rooted-`S4` double-coset packets (no `q=23` or `q=29` P root is fully covered);
- transport of the residual-grid ledger, whose reservoir is absent in the conic-only state;
- static feature refinement, greedy drain, and enlarged finite selector libraries.

These are bounded mechanism negatives, not evidence that the observed P-density is false. Re-entry
requires a genuinely global recursion, averaging/distribution theorem, family-level correspondence,
or a formally specified certificate language that evades the recorded obstruction.

### What C210 can supply after a deterministic certificate exists

If a genuinely new deterministic P- or transfer-certificate event is stated, C210 provides a
template for the remaining steps:

    deterministic certificate
        -> algebraic success/failure locus in the varying fourth centre
        -> generic component plus exact exceptional divisors
        -> character-sum / Weil point count
        -> explicit small-bad-set or abundance theorem

In odd characteristic the specific Artin--Schreier layer is replaced by quadratic-character,
Kummer, or ordinary cover arithmetic, but the reconstruction and exceptional-locus discipline is
the same.

Three candidate certificate shapes survive the C84 negative boundary:

1. **family-level continuation pairing:** pair different fourth-centre residuals `R_y` and
   `R_y'`, rather than vertices inside each `R_y`;
2. **value-preserving exchange:** replace an off-conic P child by an on-conic child through an
   explicit continuation equivalence;
3. **recursive scar theorem:** solve the full-group residual through a structured growing
   two-color backbone rather than a bounded local certificate.

If any such theorem yields a bounded-degree failure condition, C210-style point counting could
prove the small-bad-set arrow needed for `(ON)`. C294's `Theta(q)` one-dimensional family is too
small by itself to outrun an arbitrary `O(q)` bad set; it is a testbed, not the missing density
theorem.

An intermediate algebraic deliverable is to classify, as the fourth centre varies:

- generator fixed-point type;
- repeated dead conic vertices;
- centre-secant intersections with the conic;
- subgroup and definition-field strata;
- centralizer and mirror-compatible loci.

This would not prove P-density, but it could remove the geometric bad sets from a future transfer
theorem.

## Contribution to gem mining and the Clebsch program

The live gem map is
[`handoffs/2026-07-14-gem-mining.md`](handoffs/2026-07-14-gem-mining.md).

### A curve-valued gem detector

**OPEN.** For every configuration in a complete projective-orbit census, attach its algebraic
collision/coverage cover and classify:

- factorization type;
- normalization genus;
- constant field;
- monodromy or Galois class;
- automorphism group;
- geometry of the deep-hole locus.

The declared null is the coefficient-generic geometrically integral curve of maximal expected
genus. A gem is a configuration where the curve unexpectedly splits, becomes rational or
low-genus, gains exceptional automorphisms, or has a deep-hole locus equal to a named variety.

This satisfies the gem program's strongest design rule: the invariant is valued in another
classified category, algebraic curves, rather than being another unexplained integer. The
`q=64` affine-complete C210 arc is evidence that the detector can produce a genuine surprise: the
search optimized legality, while the coverage geometry collapsed unexpectedly.

The natural first consumer is the C159 `U`-atlas. For each arc orbit, record both the geometry of
its deep-hole locus and the factorization/genus data of its collision/coverage cover. This may
separate configurations merged by size, stabilizer, and uncovered-point count.

### A secant-multiplicity hierarchy

**SYNTHESIS/OPEN.** Four existing results appear to be specializations of one carrierwise
secant-redundancy theory:

1. the prescribed-hole defect identity;
2. C174's six-arc chord/concurrency identity;
3. the Baer inverse/equality balances imported into the C210 audit;
4. C210's repeated-hit and collision accounting on Baer external fibers.

All measure the same loss: nominal pair capacity is wasted when several selected secants hit the
same carrier point. The settings differ only in the carrier on which multiplicity is measured:

- the whole plane;
- the prescribed conic;
- one Baer external fiber;
- the chord arrangement of one small subset.

A target identity has the schematic form

    uncovered required mass
      = nominal pair-capacity deficit
        + exceptional-set incidence
        + sum of nonnegative repeated-hit redundancies.

Its specializations should recover the current global defect theorem and the six-arc identity. A
Baer specialization may prove that arcs concentrated in a bounded number of Baer cosets cannot
attain the sharp `sqrt(2)` threshold.

This would be genuine new theory rather than a thematic comparison.

## Contribution to other papers

| Paper/lane | Possible C210 import | Recommendation |
|---|---|---|
| `arcs_complete_outside_conic` | Baer-contained obstruction; eventual carrierwise defect theorem; bounded pointer to the full-coset obstruction | Add only the short direct theorem now; keep the full C210 proof for a sequel |
| Clebsch | Clebsch exterior points as conic involutions/ports; healthy arc as named deep-hole-conic example | At most a concise conceptual dictionary; do not insert C210 algebra |
| `complete-ports` | C210 as an explicit multi-target port-interference and unavoidable-3-circuit family | Preserve the frozen single-target paper; use in a sequel |
| continuation rigidity | Matching-to-centre reconstruction and intrinsic recovery of incidence/code | Use in C295/Crown II; do not expand the current N1 manuscript |
| Nofil finite-geometry outcomes | Little direct C210 content; C294 is the relevant full-group residual result | Do not add C210 to the current manuscript; bound C294 carefully in the odd-plane frontier |
| C84/C294 conic games | Algebraic classification of dead-set, centralizer, subgroup, and certificate-failure loci | Use only after a deterministic value certificate is supplied |

### Multi-target complete repair ports

Each selected off-conic centre is a target whose conic chords form a pointed repair port. A family
of centres superposes several ports on the same helper set. C210's collision curves measure
interference among these targets: three selected centres become a projective 3-circuit precisely
when the port geometry is incompatible with the desired arc.

The final obstruction can therefore be re-read as a multi-target negative theorem:

> In the selected full two-coset quadratic architecture, sufficiently large trace-one scalar
> realizations necessarily contain target-interference circuits.

This is outside the frozen single-target reliability/Tutte scope of the current complete-ports
paper, but it is concrete sequel material rather than a vague analogy.

## Ranked next attacks

### 1. Robust collision geometry for partial repair domains

**OPEN; recommended next relconic task.** The full-coset theorem proves at least one collision but
does not determine how difficult it is to remove all collisions.

Form the collision hypergraph on selected seed and repair vertices. Determine:

- the number and distribution of genuine collision points;
- projection fiber sizes from the collision curve to each repair domain;
- matching number of vertex-disjoint collisions;
- minimum vertex hitting/transversal number;
- affine and projective coverage lost after deleting a hitting set.

There are two equally valuable outcomes:

- **robust obstruction:** `Omega(q)` vertex-disjoint collisions or a linear hitting number, ruling
  out near-full repair cosets and substantially broadening C210;
- **construction escape:** collisions concentrate over a small structured vertex set which can be
  deleted while retaining sufficient coverage.

The Hasse--Weil proof supplies `Theta(q)` curve points generically, but that alone does not show
that they project onto many distinct selected vertices. The projection/hitting problem is the exact
missing theorem.

Stop conditions:

- do not run another unrestricted coefficient census;
- first derive projection degrees and symbolic collision multiplicities;
- use a bounded exact field only to discriminate between robust matching and concentrated-fiber
  behavior;
- do not infer a linear hitting number from a linear rational-point count.

### 2. Close or delimit the generic `q=512` gap

**OPEN; C305, feasibility-gated exact closure.** Only `q=8` and `q=512` lie below the uniform
generic Hasse--Weil threshold, and the exceptional `q=512` strata are already closed. A bounded
generic sweep could sharpen the theorem to every odd-tower `q>=512`, while a survivor would be a
more interesting sporadic construction candidate.

The naive normalized and unnormalized scopes have about `512^4 = 68,719,476,736` and
`512^5 = 35,184,372,088,832` parameter points respectively. Their feasibility must not be assumed.
First prove that the scaling chart is lossless on the target specializations, identify every valid
symmetry or Frobenius quotient, implement the committed `H,J` reconstruction and direct
genuineness check, and benchmark a representative deterministic shard. Run the full sweep only if
that evidence gives a credible resource bound; otherwise seek an algebraic reduction and record
the finite gap honestly. Include the recorded `q=8` branch exceptions only if the same bounded
checker closes them cheaply.

### 3. Carrierwise Baer-fiber defect identity

**OPEN; highest theory upside.** Refine the global prescribed-hole remainder onto individual
extended Baer-line fibers. Separate:

- fibers invisible to selected pairs;
- nominal capacity lost to the prescribed conic;
- repeated pair hits on the same external point;
- arc-forced coupling between those terms.

The result is valuable only if it gives an equality/stability theorem or a bound stronger than the
existing scalar defect inequality. The main target is a bounded-Baer-coset obstruction.

### 4. Exact dead-set/redundancy identity

**OPEN; scoped common-interface result.** The off-conic-centre, projection-involution, chord-
matching, and pointed-port correspondences are classical geometry, not a new theorem package.
Record consumer-specific characteristic-two conventions only when needed. The research target is
the nonclassical item: an exact identity relating distinct dead conic vertices, secant-incidence
multiplicity, repeated hits, and off-conic coverage defect for a family of centres.

Test that identity on the C294 crown, the Clebsch six-set, and the C210 `q=64` arc. A general
dictionary should not be allocated unless one of those consumers exposes a genuinely missing
lemma.

### 5. C294 mixed-class Cayley scar

**OPEN; crown-owned.** Use projective trace/determinant coordinates to make the remaining dihedral
centralizer coset exact, then prove a value-preserving local surgery or recursive scar theorem.
C210 contributes exceptional-locus organization, not the game response.

### 6. Family-level odd-`q` continuation transfer

**OPEN; cap-owned.** Seek a value-preserving correspondence between different fourth-centre
residuals or between off-conic and on-conic children. This bypasses the exact C84 obstruction to
internal two-ply pairing. Algebraic point counting begins only after the deterministic game lemma
is stated.

### 7. Nonquadratic or partial repair graphs

**OPEN.** Use the exact divided-difference condition to select height functions from
translation-arc, oval/hyperoval, or related finite-field function theory whose internal legality is
proved structurally. Derive seed--repair trace equations before testing coefficients. Blindly
enumerating cubic or quartic graphs would repeat the closed mechanism search.

### 8. Probabilistic deletion and exchange

**OPEN; lower priority until attack 1.** Start from a high-coverage layered set, delete a hitting
set for collinear triples, and restore lost coverage by exchange. This is credible only after the
collision projection and coverage robustness are measured.

## Second zoom-out: the abstraction C210 may be missing

The first synthesis still treats C210 mainly as a completed ansatz obstruction with reusable
coordinates. A stronger mathematical reading changes the question from

> Which repair formula should be tried next?

to

> Why does every bounded-complexity full-layer construction produce a positive-dimensional
> forbidden-incidence variety, and which exceptional arithmetic geometries can prevent that
> variety from having rational points?

That shift exposes several missing theorem layers.

### Missing layer 1: a normal-form or universality theorem

The publication strength of the obstruction depends on how much of the natural construction space
the C210 parameters represent. The current proof classifies every specialization *inside* the
selected trace-one two-repair-coset family. It does not yet answer:

- whether every pair of full quadratic repair cosets compatible with the two seed layers is
  projectively equivalent to a C210 specialization;
- whether shared coefficients and trace-one relations are forced by arc legality or are a chosen
  slice;
- what the actual moduli dimension is after quotienting by the conic stabilizer, field
  automorphisms, seed interchange, repair interchange, and genuine projective equivalence;
- whether the three `q=64` fixed-seed orbits remain distinct under the full projective group;
- whether the weighted scaling used by the collision polynomial is equation gauge rather than a
  geometric symmetry.

The decisive strengthening would be:

> Every full quadratic two-repair-coset extension of the two-parabola seed satisfying the internal
> legality and common trace constraints is projectively equivalent to the C210 normal form.

If this is true, C210 becomes a classification theorem. If it is false, the omitted moduli identify
the exact surviving quadratic architecture and prevent the paper from overstating its scope.

### Missing layer 2: the current curve may already imply linear robustness

The final theorem uses one rational point of each collision component. Generically the same proof
gives

    #X(F_q) = q + O(sqrt(q)).

The actual collision triple has seed coordinate `t`, left-repair coordinate `r`, and right-repair
coordinate `r+u`; the collision curve is presented in `(u,t)`, with `r=J/H`. If each of the three
coordinate maps is nonconstant of uniformly bounded degree, then every selected vertex belongs to
only `O(1)` collision triples. Greedy matching in the resulting tripartite 3-uniform hypergraph
would give

    Omega(q)

pairwise vertex-disjoint genuine collisions. Every collision-free restriction would then have to
delete `Omega(q)` selected vertices.

This is not yet proved. The precise missing checks are:

1. bound the degrees of the `t`, `r`, and `r+u` maps on every genuine component;
2. classify components on which one of those maps is constant;
3. remove repeated-point and orientation duplicates;
4. repeat the projection audit on all three factorization branches and degenerate strata;
5. combine the resulting transversal bound with a coverage-loss estimate.

The current genus and point bounds (`q-4*sqrt(q)-6`, `q-2`, and the generic
`q+1-30*sqrt(q)-10`) provide most of the point-supply input. Thus the robust obstruction may be a
near-term theorem rather than a distant program. The first projection-degree/resultant audit uses
polynomials already present in the proof bundle and is the cheapest decisive go/no-go milestone in
the continuation program. It should run before the broader normal-form audit, without presuming
that degree bounds alone settle componentwise nonconstancy.

### Missing layer 3: exceptional incidence correspondences

Three one-dimensional layers have three parameters. Collinearity in the quadratic extension gives
two scalar conditions over the subfield, so the expected forbidden locus is a curve. A bounded-
degree geometrically integral curve defined over the base field has about `q` rational points.
Therefore a full-layer arc persisting over infinitely many fields must exhibit exceptional
behavior: its geometric components must be absent, vertical/degenerate, or permuted by Frobenius
without a base-defined component.

This is analogous to exceptional permutation polynomials. A polynomial can permute infinitely
many extensions only when the off-diagonal fiber product has no Frobenius-fixed component. Here a
prospective infinite arc is an **exceptional incidence correspondence** whose forbidden
collinearity variety remains rational-point-free despite its expected positive dimension.

Exceptional covers and correspondences already have a developed monodromy theory and
classification literature. The first step is therefore to place this collision correspondence
precisely in that framework and determine which classified exceptional types can occur at the
relevant bidegrees, not to rebuild the general theory from scratch.

The application program is:

1. define a parameter space `M` of bounded-complexity layered sections;
2. construct the universal collision family `X -> M`;
3. identify the open locus of geometrically integral fibers;
4. describe the reducibility, constant-field, degree-drop, and projection-collapse discriminant;
5. descend through successive proper exceptional loci by Noetherian induction;
6. classify the surviving monodromy and Frobenius types.

C210 is a complete computation of one nontrivial low-degree stratum. The possible headline theorem
is:

> A bounded-degree algebraic union of full subfield layers either belongs to an exceptional
> monodromy class or contains linearly many pairwise vertex-disjoint collinear triples for all
> sufficiently large fields.

### Missing layer 4: an Artin--Schreier cohomology explanation

The factorization problem naturally lives in

    K / {g^2+g : g in K} = H^1(K,Z/2).

The trace-one condition is a nontrivial Artin--Schreier torsor. The second-layer classes `chi0` and
`chi1` are cohomology classes; their pole residues control splitting, ramification, and genus. The
three exact factorization branches should therefore be explained as the boundary strata where the
relevant class becomes trivial or its pole divisor merges:

- `e=0`;
- `e=delta`;
- `delta=p`, `w in {0,1}`.

A conceptual proof could derive the uniqueness of the generic quadratic slope and the branch
completeness from valuations and residues, using ideal certificates only as verification. This is
worth doing inside `layered-arcs` drafting where it materially shortens or clarifies the proof. It
is not a standalone research gate for the exceptional-incidence program.

### Missing layer 5: the correct characteristic-two geometry

Invariantly, a nonsingular conic is the Veronese curve in the projective space of binary quadratic
forms. In odd characteristic, off-conic points, nonsingular forms, and projective involutions fit a
clean symmetric-square representation. In characteristic two, the nucleus makes polarity
degenerate and separates quadratic forms from symmetric bilinear forms.

The coordinate

    P(x,h) = [1:x:x^2+h]

should be understood as a section of an affine/normal bundle over the conic, with `h` carrying
weight two. The second divided difference is then an invariant curvature or second-jet condition
on sections. The concrete invariant-definition and gauge-versus-symmetry questions belong to
C297. Bundle and compactified-moduli language should be introduced only if it helps answer them.
This perspective may:

- supply the invariant definition missing from the C210 paper;
- distinguish genuine projective symmetries from polynomial gauge scalings;
- identify the three residue branches as boundary divisors of a compactified section moduli space;
- clarify exactly how the nucleus and odd-degree trace obstruction enter reconstruction.

### Missing layer 6: the secant map is an almost-perfect design

At size `k~c*q` in ambient order `Q=q^2`, the pair supply is `c^2*q^2/2`. A Baer external fiber
has order `q^2`; the first numerical possibility of surjectivity is `c=sqrt(2)`. Near this scale,
the pair-intersection maps must be simultaneously nearly surjective and nearly injective on every
carrier fiber.

This is closer to a perfect difference set, Sidon design, or approximate Steiner system than to an
ordinary complete-arc search. The expected general identity is

    coverage deficit
      = pair-capacity deficit
        + repeated-hit energy
        + exceptional-set expenditure.

The prescribed-hole defect identity, C174's chord-concurrency identity, the Baer inverse balances,
and C210's collision redundancies may be different carrierwise specializations of that formula.
Algebraicity alone cannot force high incidence energy: Singer difference sets and planar-function
relative difference sets are algebraic and attain perfect or Sidon-optimal behavior. Any
obstruction must isolate the restrictive feature actually present here, such as full
subfield-rational one-dimensional layers in a fixed bounded-degree section family. Proving an
energy incompatibility for that narrower class would obstruct a much wider family than the
selected C210 slice without contradicting the known perfect constructions.

### Missing layer 7: collision and coverage demand opposite arithmetic

A successful construction asks the same layer maps to produce opposite point-supply behavior:

    forbidden collision covers: no rational points;
    desired coverage covers:    rational points for every target.

Both sets of covers arise from the same coefficient family, so their monodromy and trace classes
are coupled. The deepest possible no-go theorem would show that coverage-rich bounded-complexity
families necessarily make at least one collision cover geometrically integral. C210 may be an
explicit instance of this collision/coverage monodromy incompatibility.

### Missing layer 8: the `q=64` object may be an arithmetic special fiber

The reciprocal-trace obstruction is counted by a Kloosterman sum. Kloosterman sums are Frobenius
traces of explicit elliptic curves, so the exceptional zero count at subfield order `8` may have an
elliptic-curve or isogeny explanation rather than being an isolated coefficient coincidence.

The finite classification should determine:

- full `PGL3(64)` equivalence of the twelve raw solutions and three fixed-seed orbits;
- stabilizers and field automorphisms of the resulting `24`- and `26`-arcs;
- automorphism group and equivalence class of the associated `[26,3,24]_64` MDS code;
- the classical elliptic-curve realization whose Frobenius trace is the relevant Kloosterman
  value;
- whether the unexplained `56 -> 14 -> 0` coverage residues are group or curve fibers.

The Kloosterman--elliptic identification is a bounded literature lookup. Questions about twists,
isogenies, or a moduli curve should be opened only if that lookup or the projective classification
reveals a concrete coincidence. The substantive work is projective/code equivalence, stabilizers,
and the `56 -> 14 -> 0` coverage residues.

### Missing layer 9: the open tower and function-theory boundaries

The final theorem closes `q=8^m` with `m` odd. It does not close even relative extension degrees,
where `GF(4)` appears, the trace of `1` changes, and the reconstruction denominator may vanish. The
first fixed `GF(8)` coefficient family is Kloosterman-obstructed in larger fields, but coefficient
families chosen anew on the even tower remain outside the theorem.

Odd-characteristic square orders are also underdeveloped. Planar functions and relative difference
sets provide genuine derivative-bijection mechanisms for pair-intersection maps. The bounded
`s=5` complete `15`-arc may be a small congruence/semifield signal rather than noise. Any revisit
must derive both cross-layer arc legality and coverage; planar-function terminology alone proves
neither.

The correct boundary audit includes:

- even-degree extensions of the characteristic-two family;
- other characteristic-two trace/linearized-function families;
- odd-characteristic planar or relative-difference-set layers;
- characteristic-two o-polynomial or hyperoval-derived internal repair layers;
- bounded-degree versus degree-growing or inseparable/linearized maps.

### Missing layer 10: partial domains are a two-hypergraph problem

The collision triples form a structured tripartite 3-uniform hypergraph. Coverage requirements
form a second hypergraph on the same layer vertices. The partial-domain problem is not simply
“delete bad parameters”; it is:

> Find a large independent set in the collision hypergraph that remains a covering set in the
> coverage hypergraph.

The exact algebraic degrees may supply bounded codegrees and pseudorandomness estimates. Depending
on the projection audit, appropriate tools include greedy matching, containers, random nibble,
absorption, deterministic switching along collision correspondences, and character-sum control of
coverage loss.

### Missing layer 11: the common matching object must be intrinsically identifiable

A *colored* family of conic projection matchings reconstructs its centres almost tautologically.
Crown II/III needs recovery from an uncolored continuation or residual object. The actual questions
are:

- is the decomposition into generator matchings unique;
- can the color classes be recognized intrinsically;
- can inequivalent centre configurations have the same uncolored residual graph;
- does generic full-`PGL2` generation destroy identifiability;
- which fixed-point, collision, port, or continuation predicates recover the decomposition?

The C294 family, the Clebsch configuration, and the C210 `q=64` arc are the correct bounded pilots.
Until this identifiability theorem exists, the common conic-matching dictionary is infrastructure,
not yet a reconstruction crown.

## Allocated post-C210 program

Repository tasks use global monotonic integer IDs, so the requested conceptual `C210.n` packages
are allocated as C297--C305, each explicitly recorded as a C210 follow-on.

| Task | C210 follow-on | Status/dependency | Deliverable |
|---|---|---|---|
| C298 | robust collision matching | complete | Linear matching/transversal obstruction proved away from two exact terminal stars; committed report is the producer for C303 |
| C305 | generic `q=512` closure | feasibility-gated | Prove the lossless quotient, benchmark a deterministic shard, and close the finite gap only within a justified resource bound |
| C297 | normal form and moduli | complete (`3955bf94`) | Proper codimension-three scope and exact projective/semilinear quotients; producer for C301/C304 and `layered-arcs` |
| C299 | invariant/residue exposition | gated on agreed `layered-arcs` claim set | Supply only the invariant and Artin--Schreier residue arguments that materially clarify the manuscript |
| C300 | `q=64` arithmetic classification | literature-first | Audit pencils/unions of conics and hyperfocused arcs, then settle projective/code equivalence, stabilizers, and coverage residues; keep the elliptic step to a bounded lookup |
| C301 | exceptional-incidence dichotomy | ready; C297/C298 complete | Put the collision correspondence into the existing exceptional-covers framework and prove the first applicable bounded-degree layer theorem |
| C302 | carrierwise secant-defect stability | queued | Unify global defect, C174, Baer fibers, and collision energy into an equality/stability theorem |
| C303 | partial-domain hypergraph | gated on C298/C302 | Decide whether large collision-free domains can retain relative coverage |
| C304 | alternative towers and function architectures | ready; C297 complete | Begin with C297's omitted constant-p moduli, then audit even extensions or run one theorem-led alternative-function pilot |

The parallel-ready set is C300's literature phase, C301, C302, C304, and C305's lossless-chart and
benchmark gates; a full C305 sweep is not presumed feasible. C299 is drafting support after the
integrator fixes the `layered-arcs` scope, not a gate for C301. C301 consumes the committed C297
normal form and C298 projection theorem. C303 consumes C298 plus C302 and treats the two terminal
stars separately. C304 begins with C297's omitted constant-p moduli and must not reopen undirected
polynomial coefficient mining.

## Recommended immediate deliverables

Parallel workers may take C300's literature phase, C301, C302, C304, or C305's feasibility phase
on distinct task-owned paths. The lane integrator alone updates the shared handoff; C303 remains
gated on C302, and C299 waits for an agreed `layered-arcs` drafting scope.

The completed C298 milestone was scoped as follows:

> Compute the degrees of the `t`, `r`, and `r+u` maps on every genuine collision component;
> classify constant-coordinate components and orientation/repeated-point duplicates; then decide
> whether the existing curves can support a uniform linear matching/transversal theorem.

This bounded triage decides whether partial domains remain viable inside the certified family. A
robust bounded-degree projection opens the `Omega(q)` matching proof; concentrated fibers identify
the exact escape locus. It must not infer a matching bound from point count alone. C297 has now
closed the manuscript-scope gate.

## Final vibe assessment

C210 is not a disappointing dead end. It is an overgrown but substantial proof bundle whose main
obstruction, finite construction, and structural calculus have not yet been distilled into their
best forms.

The negative theorem is strong because it closes every visible algebraic loophole in the selected
sharp-scale architecture; C297 has now proved exactly how noncanonical that architecture is. The
`q=64` object is strong because it exposes an unoptimized finite phenomenon. Classical conic
matchings provide a useful shared carrier for geometry, game value, repair, continuation, and
coding interpretations, but the new content must be an exact identity or reconstruction theorem,
not the dictionary itself.

The correct response is:

1. keep the relconic program live;
2. run C298's bounded projection triage and then the justified robust partial-domain attack;
3. put the `q=512` closure through a lossless-quotient and benchmark gate before any full sweep;
4. run C297 before packaging the full-coset theorem invariantly;
5. develop the carrierwise secant/matching identity if the collision work exposes the expected
   redundancy structure;
6. do not resume undirected coefficient mining.

## Source map

Primary C210 records:

- [`handoffs/2026-07-17-c210.md`](handoffs/2026-07-17-c210.md);
- [`2026-07-17-c210-bounded-two-repair-coset-obstruction.md`](2026-07-17-c210-bounded-two-repair-coset-obstruction.md);
- [`2026-07-16-c210-square-root-mechanism-audit.md`](2026-07-16-c210-square-root-mechanism-audit.md);
- [`2026-07-16-c210-discovery-track.md`](2026-07-16-c210-discovery-track.md);
- [`2026-07-17-c210-reproducibility-manifest.md`](2026-07-17-c210-reproducibility-manifest.md).

Cross-lane records used in the synthesis:

- [`2026-07-17-c294-full-conic-continuation-crown.md`](2026-07-17-c294-full-conic-continuation-crown.md);
- [`2026-07-17-c84-certificate-event-dossier.md`](2026-07-17-c84-certificate-event-dossier.md);
- [`handoffs/c84/README.md`](handoffs/c84/README.md);
- [`handoffs/c84/odd-q-position.md`](handoffs/c84/odd-q-position.md);
- [`handoffs/2026-07-17-crowns.md`](handoffs/2026-07-17-crowns.md);
- [`handoffs/2026-07-14-gem-mining.md`](handoffs/2026-07-14-gem-mining.md);
- [`handoffs/2026-07-17-complete-ports-paper.md`](handoffs/2026-07-17-complete-ports-paper.md);
- [`handoffs/2026-07-17-continuation-paper.md`](handoffs/2026-07-17-continuation-paper.md);
- [`handoffs/2026-07-17-nofil-paper.md`](handoffs/2026-07-17-nofil-paper.md).

Expert-lens protocol used for the second zoom-out:

- [`2026-07-07-named-expert-personas-context.md`](2026-07-07-named-expert-personas-context.md);
- [`expert-personas/hirschfeld-thas-storme-ball-lavrauw-projective-arcs.md`](expert-personas/hirschfeld-thas-storme-ball-lavrauw-projective-arcs.md);
- [`expert-personas/davydov-marcugini-pambianco-computational-arcs.md`](expert-personas/davydov-marcugini-pambianco-computational-arcs.md).
