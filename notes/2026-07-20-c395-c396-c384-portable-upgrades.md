# C395--C396 — portable upgrades from the C384 AME pencil

**Lane:** `crowns`

**Date:** 2026-07-20

**Status:** queued task design; formulas below are targets and cheap-gate evidence, not yet a
replacement for the required theorem/certificate bundles

## Starting point

C384 classifies the seven admissible `F_11` specializations of

```text
(0,1,1-t), (0,1,t-1),
(1,1-t,0), (1,t-1,0),
(1,0,-t),  (1,0,t)
```

into exactly two non-GRS monomial and LU classes. Exact symbolic exploration after C384 exposed a
portable static theorem and a separate, harder equivalence question. They are split so that the
all-field arc/GRS result cannot be blocked by a general local-equivalence classification.

## C395 — all-odd-field pencil and tetrahedral arithmetic phase

### Target theorem

Over every finite field `F_q` of odd order, prove directly that the twenty three-column minors are
nonzero exactly when

```text
t(t-1)(t^2-t+1)(t^2-3t+1) != 0.
```

Deduce the exact admissible-parameter count

```text
q - 4 - chi(-3) - chi(5),
```

with the quadratic character extended by `chi(0)=0`. Prove that the conic-evaluation determinant
is, up to the fixed displayed normalization,

```text
8 t (t-1)^2 (t^4-4t^3+7t^2-4t+1),
```

and hence that an admitted member is GRS exactly on the reciprocal-quartic locus. Use

```text
t^4-4t^3+7t^2-4t+1 = t^2 ((t+t^-1-2)^2+1)
```

to give an exact quadratic-character/root count for that locus. The candidate resultants against
the two arc quadratics are both `4`, and the candidate quartic discriminant is `272=2^4*17`; these
identities must be regenerated and independently replayed in the C395 evidence bundle.

Every admitted non-GRS member then yields a minimal-support stabilizer `AME(6,q)` by the standard
MDS dictionary. Do not claim a new MDS--AME construction or an LU classification.

### Tetrahedral specialization gate

The `t=-1` specialization is predicted to carry a projective `A4` action on its six points over
every admissible odd characteristic. Prove this from explicit integral projective matrices and
classify the full stabilizer. The bounded prime pilot predicts:

- generic full stabilizer `A4` of order 12;
- characteristic 17: an order-24 enhancement simultaneous with the GRS transition; and
- characteristic 31: an order-60 `A5` enhancement while the member remains non-GRS.

The task succeeds with the portable arc/GRS theorem even if the stabilizer-jump classification
fails. Stop the symmetry appendix on any additional enhancement prime or on a need for an
unbounded finite-field census; record the exact bounded counterexample instead.

### Evidence and literature gate

Create a deterministic checker/JSON/checksum bundle covering symbolic minors, conic determinant,
resultants/discriminant, small-field replay including prime powers, explicit group matrices, and
full stabilizer checks at all exceptional characteristics claimed. Begin with the finite-arc and
MDS sources already recorded by C341/C374/C384; perform a focused primary/forward audit before any
novelty or priority wording about the tetrahedral/octahedral/icosahedral phase.

## C396 — holonomy completeness and LU-invariant failure on the pencil

### Mandatory first result

Certify the sharp failure of C374's triple-marginal moment as a family classifier. The first pilot
is `q=13`: the exact projective quotient has two non-GRS monomial classes, but both have moment
distribution

```text
((4,66),(6,389)).
```

This is only an invariant collision, not proof of LU equivalence. The certificate must include
canonical representatives, inequivalence witnesses/canonicalization replay, non-GRS determinants,
and independent moment calculations.

### Positive holonomy gate

Determine the exact projective-equivalence relation on admissible parameters and test whether
C374's 450-entry minimal-support holonomy signature is a complete invariant for monomial classes
inside this pencil. The initial prime pilot found no holonomy collisions for

```text
q = 7,11,13,17,19,23,29,31
```

with respectively `1,2,2,4,4,5,7,7` projective classes. This is discovery evidence only. The task
must include prime-power fields, symbolic parameter relations, and an independent direct-Lagrangian
replay.

Aim for one of two exact outcomes:

1. a portable theorem that equality of holonomy signatures is equivalent to projective/monomial
   equivalence in this pencil, with explicit maps for every equality; or
2. the smallest certified collision, stated as a sharp bounded failure.

Stop on factorization through a known six-point projective invariant unless the exact translation
itself is the useful theorem. Do not promote LC separation to LU separation, do not run a
continuous-unitary search, and do not claim classification beyond this one-parameter pencil.

## Dependency and ownership

- C384 owns the exact q=11 two-class theorem and its evidence bundle.
- C374 owns the definitions and invariance proofs for the holonomy and marginal moments.
- C395 owns only the all-odd-field static/arithmetic theorem and its bounded symmetry appendix.
- C396 owns the q=13 moment failure and the pencil-internal holonomy completeness/failure gate.
- C341's finite-arc/MDS and C374's quantum literature boundaries remain authoritative inputs; the
  successors edit none of their source-lane files.
