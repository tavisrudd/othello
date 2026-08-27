# C973 — Projective Reed--Solomon Toolkit leverage map

**Lane:** `reed-solomon` · **Date:** 2026-08-26 · **Status:** C974 implemented
the exact enumerative negative path; symbolic-selector and digit-recursive
optimizations remain successor interfaces

## Executive result

The simultaneous-marker theorem can improve the Projective Reed--Solomon
Toolkit in two distinct ways.

1. **Constructive shallow witness.**  At every `r>=6` in the proved field
   range, a syndrome outside `P_r union M^max_(r,p)` admits a deterministic
   split squarefree locator of degree `r-2`.  This is a theorem-gated fast
   `NOT_DEEP` path and a replacement for enumerating all degree-`r-5` marker
   prefixes.
2. **Parameterized large-characteristic classification.**  When `p>r-1`, the
   Lucas carrier is empty and the imported radius gate promotes the
   containment theorem to an exact persistent tangent/conjugate-secant
   classification.  After independent review, this can extend `classify`
   beyond its current R5--R10 registry without extending by experimental
   orbit tables.

The first path produces an ordinary locator witness and can reuse the current
certificate verifier.  The second produces a positive mathematical verdict
and therefore requires a new versioned theorem-domain rule and deep-certificate
replay route.

C974 subsequently implemented `simultaneous-locator` for every `r>=6`, with
typed forbidden roots, direct R5 pencil completion, ordinary locator replay,
and fail-closed budget semantics.  It is the exact enumerative realization of
Steps 4--5 below, not yet the symbolic selector of Steps 1--3.  The q=49 C973
orbit certificates demonstrate its first theorem-facing Lucas-carrier use.

## 1. Constructive locator route

For a request with redundancy `r`, put `m=r-5` and form the composite Hankel
map

\[
 T_f:\operatorname{Sym}^m(E^\vee)\longrightarrow\Gamma^4E.
\]

An implementation can proceed as follows.

1. Construct the pullbacks through `T_f` of the terminal Hankel determinant
   and the characteristic-appropriate residual-carrier generators.
2. Select a product `F=DA` whose pullback is symbolically nonzero.  If none is
   nonzero, report only that the syndrome is in the proved upper carrier; do
   not infer deepness.
3. Multiply `F(T_f(R))` by the Vandermonde and any forbidden-root factors.
   Successively specialize the `m` affine root variables, preserving a
   nonzero residual polynomial.  The theorem uses at most `mq` symbolic
   partial-specialization/zero tests.
4. Contract by the resulting marker locator, enumerate the `q+1` members of
   its terminal cubic pencil, and choose a completely split squarefree cubic
   avoiding all marker roots.
5. Multiply the marker and cubic locators, recover magnitudes, and invoke the
   existing exact locator verifier.

The final artifact already fits
`projective-reed-solomon-locator-certificate-v1`: its support is distinct, its
locator is reconstructed from that support, its nonzero magnitudes reproduce
the syndrome, and the verifier need not trust the selector.  Search-route
telemetry may be added to a result envelope, but certificate correctness does
not require a schema change.

The current `terminal_cubic_completions` and `locator_from_support` /
`recover_magnitudes` / `verify_certificate` primitives are reusable.  The new
code should enumerate the actual projective R5 pencil, rather than inherit the
current bounded 12-point terminal grid as if that grid proved the arbitrary-
level theorem.

## 2. Exact-distance and decode integration

The constructed degree-`r-2` locator proves only
`distance <= r-2`.  It is immediately sufficient for `NOT_DEEP`, but it does
not by itself prove the exact distance or nearest-word minimality.

For `distance` and `decode`, use it after the increasing-degree search through
`r-3`:

- if a lower-degree locator is found, return the existing minimal witness;
- if none is found and the simultaneous route returns a degree-`r-2` locator,
  that locator is minimal and the existing certificate is exact;
- if the theorem-domain hypotheses or symbolic route do not apply, fall back
  to the current exhaustive/budgeted search;
- failure of the fast route is never evidence that no locator exists.

Thus the theorem removes the expensive top-degree marker-prefix enumeration
on its applicable open, while preserving current fail-closed behavior and
candidate-budget semantics for the lower-degree search.

## 3. Classification decision tree

After the theorem is independently accepted, `classify` can use the following
order for arbitrary `r>=6` with `q>=r`.

1. Replay the intrinsic persistent tangent/sigma recognizer.
2. Test membership in the maximal Lucas carrier from the adjacent Pascal
   zero runs.
3. If outside both carriers and the C973 field threshold holds, construct the
   degree-`r-2` locator and return `NOT_DEEP` with its ordinary certificate.
4. If in the Lucas carrier, return `UNRESOLVED` unless a separately registered
   shallow/deep Lucas theorem applies; an exact locator may still turn this
   into `NOT_DEEP`.
5. If persistent and the covering-radius rule applies, return `DEEP`; otherwise
   keep the geometric family but return `UNRESOLVED` or `UNSUPPORTED` according
   to the registry.

In particular, for `p>r-1` and

\[
 q\ge 6r-16+\lfloor2\sqrt{6r-18}\rfloor,
\]

the Lucas branch is empty and the large-characteristic radius theorem makes
Steps 1 and 3 an exact all-syndrome classification.  In characteristic two,
the sharper containment threshold accelerates negative witnesses but does not
by itself settle points inside `M^max_(r,2)`.

## 4. Registry and certificate changes

The shipped `theorem-domain-v1.json` is a finite R5--R10 level table whose
parser recognizes only literal predicates of the form `q>=N`.  Do not append
infinitely many generated rows.  A software successor should introduce a new
registry version with a parameterized rule containing at least:

- `r>=6`, `q>=r`, and `p>r-1`;
- the exact `Q_r^*` formula and strict-inequality provenance;
- the split-free conclusion and the separate covering-radius premise;
- the two admitted persistent family identifiers;
- stable source locators into the reviewed paper theorem; and
- a rule version included in the positive certificate.

The existing `DeepFamilyEvidence::Persistent` representation is suitable for
the family evidence.  The verifier still needs a new registry-version branch
that recomputes the formula predicates, the persistent invariant, the
canonical transporter, and the radius source.  Merely changing
`BadRedundancy` or allowing R11+ input without this replay would broaden the
claim without a proof-carrying boundary.

Negative locator certificates need no C973 theorem source: their support and
magnitudes are independently checkable.  Positive deep certificates must cite
both the reviewed simultaneous-marker classification and the imported radius
gate.

## 5. Complexity boundary

The fixed-`r` marker selection uses `O((r-5)q)` symbolic zero tests and `O(q)`
terminal cubic tests.  With a dense selector, the number of coefficient slots
is at most `(d+m+s)^m`; it is exponential in `r`.  Therefore:

- advertise a deterministic fixed-parameter fast path in `q`;
- benchmark it against `ProjectivePrefixes` enumeration at the same `r,q`;
- report selector construction, partial zero testing, terminal factorization,
  and certificate replay separately; and
- make no uniform polynomial-in-`r` or polylogarithmic-in-`q` claim.

An arithmetic-circuit or sparse representation may improve practice, but that
is an implementation theorem only after exact symbolic zero testing is proved.
Black-box point evaluations cannot replace the residual-polynomial tests in
the current extraction proof.

## 6. Safe implementation sequence

1. Wait for external acceptance of the five inherited C973 seam inputs.
2. Add a private `simultaneous_marker_locator` prototype with exact terminal
   equations and direct locator verification; do not touch the theorem
   registry.
3. Cross-check every returned locator against `search_exact_locator` on
   feasible R6--R10 fields and add R11+ fixtures where the old classifier
   returns unsupported.
4. Install the routine as an optional fast `NOT_DEEP` / top-degree decode
   path with exhaustive fallback.
5. Only then version the parameterized large-characteristic theorem registry,
   deep certificate, docs, and verifier together.
6. Benchmark, run corrupted-certificate tests, and preserve the rule that
   `UNRESOLVED` and `UNSUPPORTED` never receive positive certificates.

This sequence gives the toolkit useful higher-redundancy witnesses before it
asks users to trust a broader positive classification surface.

## 7. Digit-stripping leverage

The later C973 digit-stripping theorem supplies a typed structural prepass for
`r-2=d=pD+a`:

- compute `nu(d)` and `eta(d)` from the base-`p` digits and return the exact
  carrier dimension `d+2-nu(d)-eta(d)`;
- report the exact projective carrier count and codimension `nu(d)+eta(d)`, so
  benchmark coverage is measured against the theorem-sized unresolved set;
- skip the Lucas branch entirely when `r-1` or `r` has one nonzero base-`p`
  digit;
- expose whether a carrier syndrome lies in the explicit determinant-twisted
  tensor submodule or has a nonzero nucleus/carrier quotient coordinate; and
- recurse on `D` for canonicalization before enumerating marker supports.

These calculations use integer digits and typed module cases; they should not
be represented by string family labels.  A future implementation should use
an enum distinguishing `TensorSubmodule`, `NucleusQuotient`, and
`CarrierQuotient`, plus structured digit and dimension fields.  This is an
optimization/diagnostic interface until a pointed-abundance theorem proves
that a quotient result can safely determine classification.

## Ownership

C973 itself changed no software file.  The user-authorized C974 successor
implemented, tested, documented, and archived the enumerative simultaneous
locator.  Symbolic-selector optimization, digit-recursive canonicalization,
registry migration, and any positive-classification expansion require new
successor ownership.
