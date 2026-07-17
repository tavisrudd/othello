# Fable 5 independent gap review: rp-next and predecessors

**Lane**: `rp-next`

**Date:** 2026-07-17
**Status:** ADVISORY REVIEW. Allocates no task, reopens no completed item, changes no gate.
**Charge:** identify what the completed program has missed that carries high A+ publication or
algorithm value.

## Provenance and independence caveat

Sources read in full: the archived `repairports` foundation (C215--C220), the `rp-next` reports
C226--C238, the applications brainstorm and its response, and both discovery tracks.

Deliberately **not** read, per explicit instruction: the C239 report and scratchpad, the C239
restricted-material file, and the two earlier Fable review notes (one reviews C239 directly; the
other carries a C239 provenance caveat). Overlap between this review and those documents is
therefore unchecked by design; this is an untainted independent pass. Any promotion decision
should first dedupe against them.

## Ranked missed opportunities

### 1. The peeling-optimality classification problem — the natural flagship theorem is never posed

C236 proves the cubic--axis family satisfies `L_3(S) = cl(S)` for every seed over every `GF(3^h)`,
and exhibits a harmonic seed whose radius-four sequential closure is inert while the seed spans.
Between those two data points sits an unasked classification question:

> Characterize the matroids (equivalently, represented codes) for which sequential radius-`r`
> Horn closure equals matroid closure on every survivor set.

Operationally: codes for which bounded-locality peeling achieves symbol-MAP erasure decoding on
every erasure pattern. This is the matroid-general form of the classical stopping-set-versus-MAP
question for iterative BEC decoding, where no general characterization exists. Cheap first probes:
is the property minor-closed? Dual-closed? Closed under 2-sums (C231 supplies the exact tool)?
An excluded-minor or structural characterization would lift the sequential-composition paper
(C238's Paper B) from "new composition calculus" to a theorem quoted outside the program. This is
the single highest-leverage gap found.

### 2. Branchwidth generalization of C231--C234 into an actual FPT theorem

The composition chain stops, deliberately and repeatedly, at 2-sum trees, and every report
disclaims an FPT/tree-DP claim. But C233's finite structural-control algebra (bounded by radius
and interface width alone) plus C234's finite delay syntax are exactly the ingredients of a
Courcelle/Hlineny-style result:

> Terminal closure, stopping cores, and repair depth are computable in `f(r,w) * poly(n)` on
> matroids of branchwidth `w`, given a branch decomposition.

The needed step is extending the interface calculus from single virtual elements to rank-`w`
separations (3-sums and general k-separations); the 2-sum case suggests the boundary message
generalizes from a scalar budget to a `w`-indexed cost table over the separation's connectivity
minor. Such a paper would sit alongside Tutte-polynomial-at-bounded-branchwidth as a recognized
algorithmic-matroid-theory result, and it is precisely the "theorem beyond matroid 2-sums" that
C238 names as Paper B's promotion gate — yet no task ever aimed at it.

### 3. Log-concavity of the pointed repair profile — the Hodge-theory door is ajar and untouched

C227 identifies `S_x(u) = sum_k a_k u^k` with a Las Vergnas perspective specialization; the
brainstorm mentions Lorentzian behavior once, as an exploratory warning, then drops it. The
concrete conjecture:

> For every matroid and nonloop `x`, the sequence `a_k(M,x)` — the number of `k`-subsets of the
> helpers whose closure contains `x` — is log-concave (possibly ultra-log-concave).

This is exactly the question shape that Lorentzian-polynomial and matroid-morphism machinery has
been resolving. Since `S_x` is a `y`-derivative difference of the ordinary rank polynomials of
`M\x` and `M/x`, existing Lorentzian results on rank polynomials may nearly close it. Every
committed uniform/cubic/harmonic profile in the certificates is immediate test data. If provable,
this is the prestige-mathematics outcome of the whole program; even as a data-verified conjecture
it materially strengthens the pointed-Tutte paper.

### 4. Cascade thresholds: the sequential bootstrap-percolation half of the probability story

C219's Poisson windows and C226's transforms are one-shot. Nobody has computed thresholds for the
iterated Horn cascade under random seeds — which is hypergraph bootstrap percolation on the
sigma-rule system (cubic) and on a Steiner quadruple system with a nucleus gate (harmonic), an
active area in probabilistic combinatorics. Two facts already in hand make this tractable:

- for the cubic family, C236 collapses the cascade threshold to the span threshold, which is
  exactly computable;
- for the harmonic family the closure/span gap is real, so "bootstrap percolation on
  `S(3,4,q+1)` gated by a common nucleus" is a new, well-posed threshold problem with a serial
  bottleneck twist.

This is the natural probability companion paper and the missing probabilistic leg of Paper B.

### 5. The code-equivalence cryptography export is entirely absent

C217's gauge theorem restates as: monomial equivalence of represented codes is support-matroid
isomorphism plus equality of fundamental circuit holonomies, with a linear-time comparison once
supports are aligned. C237 adds Schur-power matroid profiles as gauge-invariant fingerprints. The
corpus positions these only against McEliece square distinguishers as prior art, and never
mentions that the Linear Equivalence Problem now underlies NIST-onramp signature schemes (LESS;
matrix-code analog MEDS), where canonical forms and invariants are the entire attack surface.
Real caveat: the reduction needs accessible small circuits, so random instances resist it. But a
clean statement of the reduction (equivalence as matroid-iso plus holonomy), together with
holonomy/Schur profiles as distinguishers and preflight linters for structured instances, is a
publishable bridge into an active cryptanalytic community, and the certificate infrastructure to
demonstrate it already exists.

### 6. The quantum translation is unexplored

Stabilizer/CSS erasure decoding has precisely this structure: erased qubits, peeling decoders,
stopping sets — and, with erasure-dominant hardware (neutral atoms, erasure-converted qubits),
growing practical weight. Complete pointed ports, stopping cores, the C233 boundary-control
algebra (mapping to modular/code-surgery composition), and the capacitated service regions all
appear to transplant; "quantum" appears in the corpus once, in a nonclaims list. Higher risk than
items 1--5 — the symplectic CSS structure may break the clean matroid picture — but the payoff
class is large and the audience is the hottest in coding theory.

### 7. A cheap decisive check nobody ran: is the flagship construction a good LRC?

C216 plus C218 yield explicit asymptotically good fixed-alphabet families in which every
coordinate has locality four with a full Steiner repair design. No report compares their
rate/distance/locality/availability against alphabet-dependent LRC bounds (Cadambe--Mazumdar) or
Tamo--Barg-style constructions. If the family is near the bound frontier, the ports paper gains a
concrete headline; if far, the compilation-not-construction framing should be stated before a
referee states it. One afternoon of arithmetic; moves the B+/A- grade either way.

### Smaller items

- **Incremental/dynamic maintenance** of `q*`, stopping cores, and ETA under helper-state changes
  via monotone fixed-point restarts: the dynamic-algorithms community would take this as its own
  contribution, distinct from C238's cache framing.
- **The scaled-C216 complexity transfer** (inner length growing, uniform confinement bound) is
  named in the brainstorm response's Part II as the real open reduction but was never allocated;
  it is the only route to genuine hardness-inside-good-codes and should not stay buried in a
  critique paragraph.

## Overall assessment

The lane's exactness discipline is exceptional, but its search pattern has been inward — deeper
exactness on the same two flagships. Items 1--4 are all cases where a completed exact result sits
one reframing away from a question a broader community already cares about, and none needs a new
census. The highest-value moves now are classification, generalization, and export, not more
verified structure.

## Explicit nonclaims

This review proves nothing new. Each item is a direction with a stated first probe; the
none-found and priority conventions of the underlying reports apply unchanged. Promotion requires
normal C-ID allocation and, first, deduplication against the two unread Fable review notes and
the C239 audit.
