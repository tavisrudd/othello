# Post-C297 theorem program: omitted quadratic moduli before `layered-arcs`

**Lane**: `relconic`

**Date:** 2026-07-18

**Status:** active program map; C312--C316 complete, C317 ready, C299 deliberately deferred.

## Purpose

C297 proves that the C210 common-curvature/common-linear-direction family is a proper
codimension-three slice of the natural constant-p trace-compatible quadratic repair family. The
next work should decide the mathematical fate of those omitted moduli before the `layered-arcs`
manuscript is scoped. This program is theorem-led: exact trace algebra, invariant moduli,
bounded-degree incidence geometry, and Hasse--Weil are in scope; coefficient censuses and large
finite certificates are not.

The desired terminal result is a precise dichotomy. Either a positive-dimensional seed-legal
family survives as a principled input to collision and coverage analysis, or the C210 obstruction
extends to an explicitly larger family with every exceptional divisor classified. Seed legality
alone is not a construction. A bounded negative is acceptable when its scope and remaining moduli
are exact.

## Authoritative inputs

- C297 normal form, constant-p family, linear-p equations, and exact quotient:
  [`2026-07-18-c297-c210-normal-form-moduli.md`](2026-07-18-c297-c210-normal-form-moduli.md).
- C304 export of the constant-p repair theorem to fresh quadratic extensions:
  [`2026-07-18-c304-c210-alternative-towers-functions.md`](2026-07-18-c304-c210-alternative-towers-functions.md).
- C210 universal height-interpolation and bounded obstruction:
  [`2026-07-17-c210-bounded-two-repair-coset-obstruction.md`](2026-07-17-c210-bounded-two-repair-coset-obstruction.md).
- C301 bounded-degree Frobenius-component dichotomy:
  [`2026-07-18-c301-c210-exceptional-incidence-dichotomy.md`](2026-07-18-c301-c210-exceptional-incidence-dichotomy.md).
- C305 lossless scaling and height-plane reduction:
  [`2026-07-18-c305-c210-q512-generic-closure.md`](2026-07-18-c305-c210-q512-generic-closure.md).
- Live state and ownership:
  [`handoffs/2026-07-17-c210.md`](handoffs/2026-07-17-c210.md).

Closed C210 residue censuses, the `q=64` classification, and old ansatz notebooks are not startup
reading. Load one only when a task document names a specific lemma or identity from it.

## Shared notation and fixed boundary

Let `E/F` be quadratic of characteristic two, with `omega^2+omega+1=0` on the odd tower, and

    P(x,h)=[1:x:x^2+h].

The seed layers are `S_alpha,S_beta`. The repair layers are

    R_i={P(e_i*omega+r, A_i*r^2+B_i*r+C_i): r in F},

with `K_i=1+A_i`. C297's constant-p trace-compatible locus is parameterized by

    K_1=K,                 K_2=c*K,
    ell=P0*(1+sqrt(c)),    B_2+B_1=ell*K,

and its stated constant relation, where `c,P0 in F^*`, `K in E^*`, and `B_1,C_1 in E`. Use `P0`
for the forced repair pair sum in new reports so it is not confused with the point map `P(x,h)`.
C210 is the slice `c=1`, `K=1+a*omega`, `B_1=b*omega`.

Projective equivalence, semilinear equivalence, relabeling, and equation gauge remain distinct.
Only C297's proved actions may be used as geometric quotients.

## Dependency graph

| Task | State | Theorem package | Consumer |
|---|---|---|---|
| C312 | complete | universal seed--repair determinant and trace reduction; exact eight-packet coefficient system, but no global moduli solve | C313, C315 |
| C313 | complete | linear-p trace stratum empty over every odd scalar degree, before the seed gate | C316, C317 |
| C314 | complete | six-stratum invariant atlas, reconstruction, relabeling actions, degeneracy divisors, and marked stabilizers | C315, C316, later C299 |
| C315 | complete | the odd-degree tail survivor is exactly the nine-dimensional constant-height `E4` arithmetic open; all other atlas charts are empty | C316, C317 |
| C316 | complete | common height cancels; four lossless relative-offset maps have degrees `6,6,5,5`, with degree two on repair-conic coincidence | C317 |
| C317 | ready | fiber geometry and terminal asymptotic construction-versus-obstruction dichotomy | later C299 scope decision |

The C316 relative-offset incidence interface is committed and C317 is ready. Shared handoff and
queue edits remain serialized. C315 solves the committed coefficient system exported by C312;
this separation prevents a universal determinant lemma from turning into an unbounded moduli
classification. C316 proves that C305's two-height affine-bundle picture does not survive on
C315's `E4` family: the common height cancels, and four finite relative-offset maps replace it.
C317 consumes their exact eliminants, degrees, branch ideals, and exceptional skeleton.

## Red-team scope controls

- C312 stops at a necessary-and-sufficient invariant equation system. Solving that system belongs
  to C315 after C314 supplies a usable atlas.
- C314 may use several invariant charts or a quotient description. A global canonical section is
  not required and must not be assumed to exist.
- Full extra-stabilizer classification and intrinsic unmarked recognition strengthen C314 but do
  not gate C315 or C316; the marked atlas, transition maps, relabeling actions, and degeneracy
  divisors are sufficient for the core theorem program.
- C316 first audits the dimension and losslessness of the generalized height map. Dominance,
  branch, and genus claims start only after that audit.
- C317 applies curve theory component by component. It must not hide unresolved exceptional
  divisors behind the word “generic.”

## Proof and evidence policy

- Prefer invariant identities, trace reduction modulo `g^2+g`, divisor calculations, and
  normalization/genus arguments.
- Small symbolic calculations may discover or check identities, but a theorem statement must not
  rest on an unexplained CAS decomposition. The C210 small-characteristic primary-decomposition
  caution in the discovery track remains active.
- Do not enumerate fields or coefficient tuples as a substitute for a parameter-space theorem.
- Do not start a full `q=512` sweep or create a large certificate. C305 has rejected that route.
- Any computational claim that becomes load-bearing must follow the repository's atomic evidence
  rules; the intended tasks should normally close with proof-only reports.
- Before developing a nontrivial proof, follow the root guide's named-expert protocol and load only
  the relevant finite-field/algebraic-geometry dossier.
- Record incidental observations only in
  [`2026-07-16-relconic-discovery-track.md`](2026-07-16-relconic-discovery-track.md).

## Program exit gate

The program is ready to return to C299 only after C317 states one of the following with exact
scope:

1. a seed-legal positive-dimensional family and the remaining coverage theorem needed for a
   construction;
2. a uniform collision obstruction on the constant-p and resolved linear-p families, with every
   exceptional divisor closed; or
3. a bounded mixed result that identifies the surviving moduli and explains exactly why present
   curve methods do not decide them.

Until then, `layered-arcs` remains a working alias, not an agreed manuscript scope.
