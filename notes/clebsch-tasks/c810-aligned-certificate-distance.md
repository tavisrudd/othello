# C810 — Distance of aligned-design certificates

**Lane:** `clebsch`  
**Status:** complete; exact distance two at the first faithful order;
adversarial correction radius zero; paper promotion excluded

## Outcome

The exact census through seven points has \(2,4,10,27\) two-graph classes
modulo relabelling and complement. At seven points the labelled and quotient
minimum distances are both two. An edge-toggle parity proof shows that every
seven-point aligned certificate has odd weight, and an explicit inequivalent
pair attains distance two. Thus one substituted bit is detectable and one
erasure is correctable, but no unknown adversarial substitution is
deterministically correctable. The parity law extends to every
\(n\equiv3\pmod4\). The conference-only distance beyond the unique order-six
class was not entered after the unrestricted cheap-stop gate fired.

Full report and reproducible evidence:
`notes/2026-08-02-c810-aligned-certificate-distance.md`.

## Objective

Determine the minimum Hamming distance between labelled aligned-four-set indicator certificates of inequivalent two-graphs or symmetric conference switching classes, modulo the appropriate relabelling, switching, and complement equivalences, and derive the exact adversarial correction radius when it is positive.

## Cheap gates first

1. Enumerate the complete small two-graph space at the first tractable orders and compute exact distance spectra, beginning where canonicalization is cheap.
2. Use bitsets, canonical representatives, and nearest-neighbour search; do not begin with a quadratic all-pairs census at the first large order.
3. Search immediately for distance $1$, $2$, or $4$ collisions and calculate how a graph-edge change propagates through the aligned-four-set certificate.
4. Only after a stable signal, make a bounded literature check under reconstruction codes, Seidel switching codes, two-graph reconstruction, homogeneous-set reconstruction, and property testing.

## Mathematical continuation if the gate passes

Prove a lower bound or exact formula, identify equality cases, and distinguish deterministic error correction from merely probabilistic reconstruction. Treat labelled and quotient distances separately.

## Stop conditions

If inequivalent objects have identical certificates under the intended quotient, or the minimum distance remains bounded by a trivial local move, freeze that obstruction and state the strongest stochastic or restricted recovery result still available.

## Acceptance

An exact small-order distance table, a reproducible nearest-pair certificate, and either a proved correction theorem or a sharp structural obstruction with a credible proof route.

## Promotion boundary

Do not edit a paper source or public package. Freeze any positive result in the task report; manuscript integration, public positioning, and a new cold read require a separately allocated follow-up.
