# Prime-power conjecture for finite projective planes

**External ID:** `BIG-412`
**Verdict:** no current bridge; there is a useful independent computational
programme.

## Exact target and local overlap

The conjecture says that every finite projective plane has prime-power order.
The first unknown order is 12: Bruck--Ryser--Chowla does not exclude it, while
order 10 is known not to exist by a very large computer-assisted proof.

The repository has two different kinds of finite-plane results:

- continuation complexes reconstruct an arbitrary projective plane from a
  suitable two-point-cap game object;
- conic, four-frame, coordinate and semilinear-rigidity results work in
  `PG(2,q)` and use the field structure essentially.

The first is functorial but conditional: if a plane exists, the complex
remembers it.  The second is strong but Desarguesian.  Neither constructs a
plane of non-prime-power order nor obstructs one.

## Why reconstruction is not an obstruction

For the two-point continuation complex, reconstruction has the form

```text
projective plane + marked pair -> complex -> same projective plane + pair.
```

This proves faithfulness of an encoding.  To affect the prime-power
conjecture, one would need an intrinsic condition on the complex that forces
Desarguesian coordinatization or a prime-power count.  The present theorem
supplies no such condition.  The continuation graph is even less useful here:
it collapses every plane of the same order to the same rook graph.

## A possible repository-derived research question

Characterize, without referring to a plane, the abstract simplicial complexes
that arise as two-point continuation complexes.  Then ask whether their links,
homology, automorphism groups or association scheme force a coordinatizing
division ring.  This is logically capable of producing an obstruction, but no
such invariant is presently visible.  It should be treated as exploratory,
not as a route already under control.

## Independent attack routes

1. **Proof-carrying SAT plus symmetry reduction.**  Encode incidence axioms
   for order 12, quotient by canonical graph isomorphism, and emit DRAT/LRAT or
   arithmetic certificates.  The order-10 oval recheck demonstrates the
   method but also its scale: terabyte certificates and thousands of core
   hours arose for a restricted subproblem.
2. **Eliminate structured subclasses first.**  Planes of order 12 with a
   specified automorphism, oval, polarity or subplane give bounded searches
   whose certificates can be independently checked.  This is plausibly
   tractable and scientifically useful even if the unrestricted case is not.
3. **Character-table/integral-lattice obstructions.**  Strengthen
   Bruck--Ryser--Chowla using modular representation, Smith normal form,
   character tables or semidefinite constraints on incidence matrices.
   Existing character-table methods explain order 6 but have not decided 10
   or 12; a genuinely new invariant is required.

## Tractability judgment

- Restricted order-12 symmetry classes: **credible medium project**.
- Full proof-carrying order-12 search: **extreme** with current evidence.
- Universal prime-power conjecture: **not presently tractable**.

## Promotion gate

Require either a certified new nonexistence class at order 12 or an intrinsic
continuation-complex invariant that rules out a non-prime-power order.  Mere
reconstruction of a hypothetical plane is not progress on the conjecture.

## Sources

- Curtis Bright et al., *Nonexistence Certificates for Ovals in a Projective
  Plane of Order Ten*, arXiv `2001.11974`; `abstract/metadata only` plus method
  summary: https://arxiv.org/abs/2001.11974.
- Máté Matolcsi and Máté Weiner, character-table approach to projective-plane
  nonexistence, arXiv `1709.06149`; `abstract/metadata only`:
  https://arxiv.org/abs/1709.06149.
- Local theorem inventory: `notes/2026-07-26-results-summary-snapshot.md`,
  continuation reconstruction and four-frame rigidity sections.
