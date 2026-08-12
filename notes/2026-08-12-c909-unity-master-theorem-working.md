# C909 — unity master theorem for the cubic epilogue

Date: 2026-08-12

Status: active theorem architecture; no manuscript, PDF, mirror, or Lean edit

## Candidate master statement

Let `H_5^et` be the marked finite-etale elliptic-Hecke groupoid of principally
polarized fivefolds: an object is a ppav `(A,Theta)` together with a polarized
isogeny from a fifth power of a non-CM elliptic curve whose projective local
spectral packet is finite etale at every bad prime.  Let `J_3` denote the
intermediate-Jacobian image of smooth cubic threefolds in `A_5`.

> **Finite-etale separation theorem.**  If a smooth complex cubic threefold
> `X` has a marked intermediate Jacobian in `H_5^et`, then
> 
> 1. `X` is universally `CH_0`-trivial;
> 2. `X x P^1` is universally `CH_0`-trivial and irrational; and
> 3. every divided power of every divisor on `J(X)` belongs to the ordinary
>    integral divisor-product image.
>
> The nonstandard `A_5` pencil maps into the forgetful image of
> `H_5^et cap J_3`, giving an explicit non-isotrivial one-dimensional
> component of the separation locus.

The proof is short but not tautological.  Finite-etale packet saturation puts
`Theta^4/4!` in the ordinary divisor-product lattice.  Voisin's cubic
criterion turns algebraicity of this primitive minimal class into universal
`CH_0`-triviality.  The projective-bundle formula preserves that property,
while the all-cubic framed-monodromy theorem makes `X x P^1` irrational.
The `A_5` calculation verifies the packet hypothesis by its exotic
two-primary slope and scalar three-primary slope.

This changes the logical role of the special family: it is an explicit
positive-dimensional component of a generally defined arithmetic separation
locus, rather than the definition of the cycle-side theorem.

## Common Eisenstein packet

There is a striking arithmetic alignment that may explain why the two
detectors meet on the same cubic geometry.  Put

```text
O_3 = Z[t]/(t^2+t+1) = Z[zeta_3].
```

On the cycle side, the two exotic two-primary slopes are the two geometric
points of `Spec(O_3/2)=Spec(F_4)`; their involution is Frobenius
`omega -> omega^2`.  On the quantum side, the distinguished block has framed
monodromy eigenvalues `exp(+-pi i/3)`.  Multiplying the operator by `-1`
turns them into `zeta_3,zeta_3^2`, the two complex embeddings of `O_3`; their
involution is complex conjugation.  Thus both unordered quadratic packets
are fibers of the same involutive order.

This is presently an arithmetic comparison of characteristic polynomials,
not a common action of `O_3` on one geometric object.  The cycle proof uses
the reduction modulo two of its slope algebra; the quantum proof uses the
complex spectrum of negative framed monodromy.  A manuscript may use this as
motivation only if the audit confirms that neither sign nor framing depends
on arbitrary conventions.

## Exact unity and non-unity

The substantive master theorem is the separation-locus result.  It unifies
the arguments by their input-output architecture:

```text
finite-etale packet on J(X)
        -> integral minimal class -> universal CH0
all-cubic quantum packet
        -> survives P1 -> irrationality.
```

The two arrows remain logically independent.  No theorem currently derives
the quantum packet from the elliptic-Hecke packet, or conversely.  Any
abstract “two detectors” proposition would merely package a conjunction and
should not be advertised as new mathematics.  The unity comes instead from
identifying a natural general separation locus and proving that the special
family is a positive-dimensional component on which both independent
detectors fire.

## Gates

1. Verify that Voisin's criterion needs only algebraicity of the minimal
   class, with no extra effectiveness or relative-cycle hypothesis.
2. State the marked groupoid and its forgetful image precisely; do not call
   the image closed, irreducible, or special.
3. Determine whether any cubic family besides the `A_5` pencil is presently
   known to lie in the finite-etale elliptic-Hecke locus.  Absence is a
   bounded literature question, not part of the theorem.
4. Audit the Eisenstein comparison for exact sign, framing, and canonicity.
5. Decide whether the C909 full graded Hodge/product quotient through
   dimension seven belongs in the epilogue theorem or in a companion paper;
   it strengthens the finite-etale branch but can dilute the cubic headline.

## Mystery ledger

* **Settled:** the natural general domain for the cycle theorem is the marked
  finite-etale elliptic-Hecke locus in `A_5`, not only the `A_5` pencil.
* **Settled:** the quantum theorem applies to every point of the cubic
  intermediate-Jacobian locus, so its restriction to the intersection gives
  a general separation theorem.
* **Open:** whether the common Eisenstein order is a genuine functorial
  realization or only a canonical arithmetic analogy.
* **Open:** whether the intersection contains further positive-dimensional
  cubic families.
