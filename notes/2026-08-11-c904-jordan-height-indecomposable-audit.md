# C904 Jordan-height boundary and indecomposable order-four base

Date: 2026-08-11

Status: exact bounded test plus a uniform indecomposability lemma; Paper V
research only; no manuscript or Lean edit

## Verdict

The proposed graph-slope formula

\[
 v_p\!\left(\operatorname {ord}
   (\gamma_T\bmod L_T^{g-1})\right)
 \stackrel{?}{=}
 \min\{v_p((g-1)!),\lfloor\log_p h(T)\rfloor\}
 \tag{1}
\]

survives the new exact boundary tests, but is not proved in general.

At \(p=2,g=5\), the first untested threshold was Jordan height four. Two
exact height-four symmetric slopes have divisor-product order four, as
(1) predicts. One is the spectral stabilization of a height-four rank-four
base; the other has characteristic polynomial \(x^5\), minimal polynomial
\(x^4\), and again exact order four. The latter is nevertheless orthogonally
decomposable, so it does not supply the desired indecomposable example.

The important upgrade is that the already certified regular-nilpotent
height-five order-four base is itself a **polarized-indecomposable**
principally polarized abelian fivefold. Thus the existing second-stage
divided-power defect is not an artifact of the decomposable stabilization
towers.

More generally:

> **Cyclic-primary indecomposability lemma.** Let \(T\) be a symmetric graph
> slope over \(\mathbf F_p\). If its characteristic and minimal polynomials
> agree and are a power \(f^e\) of one irreducible polynomial, then the
> associated principally polarized graph quotient is indecomposable.

Indeed, a product decomposition of a ppav gives a nontrivial
Rosati-symmetric integral idempotent. Under the principal polarization
identification

\[
 \operatorname {NS}(A)\simeq\operatorname {End}(A)^{\dagger},
\]

its reduction modulo \(p\) is a symmetric idempotent commuting with \(T\).
Since \(T\) is cyclic primary,

\[
 \operatorname {Cent}_{M_g(\mathbf F_p)}(T)
   =\mathbf F_p[T]\simeq\mathbf F_p[x]/(f^e)
\]

is local and has only the idempotents zero and one. An integral idempotent
reducing to zero is zero by \(p\)-adic iteration; one reducing to one is
one by applying the same argument to its complement. Hence no nontrivial
product idempotent exists.

For the regular nilpotent order-four base, the exact finite check gives the
same conclusion without invoking the centralizer theorem: among all 372
proper subspaces of \(\mathbf F_2^5\), four are invariant and none is
nondegenerate for the coefficient form.

## 1. Exact results

### Regular height five

For the committed regular-nilpotent slope,

\[
 \chi_T(x)=m_T(x)=x^5,\qquad h(T)=5.
\]

The candidate exponent is

\[
 \min\{v_2(4!),\lfloor\log_2 5\rfloor\}
 =\min\{3,2\}=2.
\]

Two independent exact divisor-lattice implementations give

\[
 \operatorname {ord}(\Theta^4/4!)=4,\qquad
 \operatorname {ord}(\Theta^5/5!)=4.
\]

The curve-product saturation quotient has index \(4096\) and elementary
divisors

\[
 [2,2,2,2,2,2,2,2,2,2,4].
\]

The local centralizer proof and the complete subspace enumeration both show
that the ppav is indecomposable.

### Height four in dimension five

The second slope has

\[
 \chi_T(x)=x^5,\qquad m_T(x)=x^4,\qquad h(T)=4.
\]

Again the candidate exponent is two, and both independent implementations
give curve and top order four. Its curve-product saturation quotient has
index \(1024\) and elementary divisors

\[
 [2,2,2,2,2,2,2,2,4].
\]

This example has four proper nondegenerate invariant subspaces and is
orthogonally decomposable. It tests the height-four value in (1), but it
does not improve the indecomposable theorem.

Together with the committed exhaustive \(p=2\), \(g=3,4\) censuses and the
certified \(p=3,g=4\) height-three example, every currently computed
Jordan-height boundary agrees with (1):

- height one: primitive;
- dyadic heights two and three at the first wall: order two;
- triadic height two: primitive;
- triadic height three: order three;
- dyadic heights four and five in dimension five: order four.

This is evidence, not an iff classification.

## 2. Why this is not yet the unbounded crown

The cyclic-primary lemma proves indecomposability independently of the
defect calculation. Therefore any exact family of cyclic-primary slopes
realizing the orders \(p^r\) would immediately give indecomposable
realizations, not merely product stabilizations.

The missing theorem is still the arithmetic one: prove that a regular
primary block of sufficient height has the order predicted by (1), or find
the first dependence on its bilinear type or full Jordan partition. The
present exact routines become too large before the first new unbounded
threshold (\(2^3\) requires height at least eight). No claim about that
threshold is made.

The clean next target is therefore:

> For a symmetric regular-primary slope \(T\), compute the Smith order of
> the divided minimal class directly from the \(p\)-typical filtration of
> the local algebra \(\mathbf F_p[T]\), and prove or correct (1).

This would simultaneously provide an intrinsic iff criterion, arbitrary
height, and indecomposable examples.

## 3. Reproducibility

The exact script is
notes/2026-08-11-c904-jordan-height-indecomposable.sage and its frozen
output is notes/2026-08-11-c904-jordan-height-indecomposable.out.

Replay from the repository root:

~~~bash
tmp_c904=$(mktemp -d)
nix shell nixpkgs#sage -c sage -c \
  'exec(preparse(open("notes/2026-08-11-c904-jordan-height-indecomposable.sage").read()))' \
  > "$tmp_c904/replay.out"
cmp -s "$tmp_c904/replay.out" \
  notes/2026-08-11-c904-jordan-height-indecomposable.out
~~~

The script pins and hashes two independent existing implementations. The
primary computation reconstructs the complete NS lattice and both curve and
top product lattices. The replay implementation independently reconstructs
the graph homology lattice and curve-product order. It also exhausts all 372
proper coefficient subspaces for invariant nondegenerate summands.

| file | bytes | SHA-256 |
|---|---:|---|
| 2026-08-11-c904-jordan-height-indecomposable.sage | 5,239 | 20145b427aeda02e5aadb2e3e923ee0f6ec27e075ad9bbf11c93b32efdb3ad8c |
| 2026-08-11-c904-jordan-height-indecomposable.out | 673 | 5b5466cb7af078d10bca2ef1be88b04162d521f4c0adf5ef876a0621e4c01112 |

Pinned inputs:

- graph-stabilization base certificate, SHA-256
  6c9e6b17fb8c8d7d7057721ddc3b16a7a759e1911de68fd6bb936c418243cc0e;
- arbitrary-Lagrangian implementation, SHA-256
  e39a9349ce4749d2bc9142de737dde443cc109e0fb08c53a90c9b993a329ff5a.

Trusted boundary: the computation proves the displayed finite lattice
orders and invariant-subspace counts. The indecomposability implication uses
the standard ppav decomposition/idempotent criterion and the exact graph
NS-to-Rosati dictionary. The script does not prove formula (1) beyond the
listed cases.

## Mystery ledger

- **Settled:** a second-stage order-four defect occurs on an indecomposable
  ppav; the regular-nilpotent fivefold already supplies it.
- **Settled:** the previously untested dyadic height-four boundary in
  dimension five agrees with the proposed formula.
- **Open:** arbitrary \(p\)-power height and the exact iff formula.
- **Open:** whether bilinear type or the full Jordan partition corrects the
  maximum-height prediction at higher layers.
- **Open:** an intrinsic Bockstein/local-algebra proof that avoids exterior
  monomial enumeration.

Vibe check: the bounded pass did not reach an unbounded tower, but it upgrades
the strongest known order-four defect from a product-tower seed to a genuine
indecomposable ppav and leaves the Jordan-height formula intact at its first
new boundary.
