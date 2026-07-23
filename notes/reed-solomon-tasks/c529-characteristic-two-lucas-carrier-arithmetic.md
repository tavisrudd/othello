# C529 — characteristic-two Lucas-carrier Frobenius arithmetic

**Lane:** `reed-solomon` · **Status:** queued next; C525 closed

## Objective

Determine arithmetic deepness on the characteristic-two modular-nucleus carriers left by C525.
For the coherent Lucas-nucleus flags obtained by iterating C512's contraction-kernel formula
\[
\mathcal M_n(\mathcal N)=
\mathbf P\ker\!\left(
\Gamma^nE\longrightarrow
\operatorname{Hom}(E^\vee,\Gamma^{n-1}E/\widetilde{\mathcal N})
\right),
\]
construct the restricted ordered-root cover, compute its geometric components and Frobenius action,
and decide which carrier points remain split-free over `F_(2^m)`.

The target is a representation-stable law in the binary digits of the NRC degree, not a list of
fixed-redundancy tables.  If such a law fails, isolate and prove the first level-dependent
obstruction.

Eventual report:
`notes/2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic.md`.

## Entry from C512 and C525

C512 proves:

- every modular contained polar flag is obtained by the explicit Lucas-nucleus
  contraction-kernel construction;
- containment is geometric but deepness can remain arithmetic;
- the characteristic-two `3`-nucleus line at C498 is deep precisely in odd extension degree; and
- its C509 contraction is one central sextic point, again with an odd-degree arithmetic law.

C525 proves that the characteristic-two ordered-Hessian degeneracy pullback has no further
nontrivial contained component: outside the persistent catalecticant and Lucas-nucleus carriers,
an effective genus-one slice supplies a split squarefree kernel member.  Therefore C529 owns only
arithmetic on the Lucas carrier, not another universal degeneracy classification.

Use the frozen C512 and C525 reports and evidence bundles.  Do not regenerate their ambient or
fixed-level censuses.

## First falsifiable gate

Reconstruct the C498 nucleus line and its C509 central contraction from one symbolic
contraction/ordered-root model.  Compute the constant geometric component group of the restricted
splitting cover and test:

> its Frobenius permutation, and hence split-free behavior, is determined functorially by the
> binary Lucas digit pattern and extension parity.

If the next coherent Lucas flag has additional geometric monodromy, a nonconstant
Artin--Schreier class, or arithmetic depending on more than those data, prove that first
obstruction and stop before proposing a uniform law.

## Execution order

1. Compute the relevant NRC nuclei symbolically from Lucas' binomial criterion and organize the
   nonzero contraction kernels by binary digit pattern.
2. Iterate the consecutive-row overlap map scheme-theoretically; discard zero/rank-one and
   noncoherent flags before any arithmetic computation.
3. Restrict the ordered-root/Hessian--Arf incidence to each surviving generic carrier and
   normalize its function field.  Separate constant component torsors from nonconstant
   Artin--Schreier covers.
4. Compute geometric monodromy and coefficientwise Frobenius on the components.  Recover the
   C498/C509 odd-extension laws as mandatory controls.
5. Translate rational split members into the exact PRS deepness criterion, retaining repeated-root
   and support-collision divisors.  Use a curve bound only after geometric integrality and the
   constant-field obstruction are settled.
6. State the maximal representation-stable family proved.  Record the first excluded binary
   pattern and its exact obstruction rather than extrapolating through it.

## Acceptance gates

- Symbolic Lucas-nucleus and iterated contraction-kernel description for the owned family.
- Exact restricted ordered-root cover with geometric component/monodromy calculation.
- Exact Frobenius deepness law, including extension-degree dependence and orbit transport.
- Conceptual recovery of the C498 and C509 characteristic-two arithmetic controls.
- A proved infinite representation-stable family, or a proved first obstruction showing why none
  follows from the proposed data.
- Explicit collision/deletion semantics and field threshold wherever a Hasse argument is used.
- Atomic generator/certificate/replay/checksum bundle for every paper-facing computation.

## Stop rules

- Stop at the first coherent Lucas carrier whose arithmetic is not controlled by the proposed
  binary-digit/Frobenius data, after proving its intrinsic obstruction.
- Do not replace the symbolic contraction and monodromy calculation by an ambient syndrome census.
- Do not classify persistent catalecticant carriers; they are outside this task.
- Do not assert that all Lucas-carrier points are deep from containment alone.
- Do not open C500 or manuscript work; it remains release-gated.

## Owned paths

- `notes/2026-07-23-c529-characteristic-two-lucas-carrier-arithmetic*`
- `notes/reed-solomon-tasks/c529-characteristic-two-lucas-carrier-arithmetic.md`
- the `reed-solomon` live handoff, archive, discovery track, and task lifecycle rows
