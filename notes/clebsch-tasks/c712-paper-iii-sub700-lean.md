# C712 — Lean formalization of the sub-700 golden-return package

**Lane:** `clebsch`

**Status:** queued behind C711

## Objective

Formalize exactly the Paper III input package human-proved in C711: the golden
conference operator, orientation triangle tensor, middle-exterior diagonal,
support-lattice recovery, and the stated rational/golden descent interface.

## Dependency

C711 must first freeze the definitions, normalizations, coefficient rings,
orientation conventions, and theorem statements.  C712 must not formalize a
certificate-shaped surrogate while the human theorem surface is unsettled.

## Gates

1. Read and follow `lean/AGENTS.md` before any Lean operation.
2. Define the explicit integral order-six conference matrix and prove
   (C^2=5I), switching covariance, and the triangle-cubic identities over the
   most general practical commutative ring.
3. Formalize the two-graph reconstruction lemma and the augmentation descent.
4. Define the middle-exterior/Hodge operator needed for the fixed six-axis
   carrier and prove (K^2=125I) and its diagonal formula.
5. Formalize the mod-two support-recovery theorem with complement duality
   stated explicitly.
6. Formalize the C711 return-to-conference interface at the strongest level
   supported by repository definitions; keep any imported C682 matrix data and
   generated finite tables explicit in the trust boundary.
7. Produce a paper-facing theorem map naming every Lean declaration, toolchain,
   axiom report, generated input, native evaluation use, and manuscript claim
   covered.
8. Run the nested Lean validation and exit protocols, then add a paper-local
   replay against the pinned formal artifact.

## Acceptance

- No `sorry`, unreported axiom, unsafe shortcut, or unstated generated input.
- Every C711 exported lemma is either formalized or marked outside scope with a
  precise reason accepted before closeout.
- The formal definitions correspond to the paper's actual conference,
  orientation, support, and descent conventions rather than a post hoc finite
  encoding.
- The exact validation and trust report are committed with the source changes.
- The required `ej`+`tt` closeout and mystery ledger are complete before C712
  is reported.

## Boundary

C712 formalizes only the C711 sub-700 package.  Lean coverage of C704/C709 and
later shadow identities belongs to the separate above-700 proof/formalization
effort and must not be duplicated here.
