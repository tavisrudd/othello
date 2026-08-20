# C925 -- modular direct-QDM proof packet

**Lane:** cubic-threefolds

**Status:** active; mathematics only; no manuscript or Lean edits

## Goal

Build and rigorously vet a parameterized direct-QDM proof framework whose
caller selects the observed blocks, retained marks, path environment, and
commutative-monoid consumer.  Instantiate it for cubic
one-stabilization irrationality, then use the same interfaces to isolate the
exact \(m=2\) and all-\(m\) transport gates.

## Stable entry points

- proof-packet index:
  notes/2026-08-19-c925-modular-direct-qdm-proof-packet.md
- \(m=2\) and cofinal-index report:
  notes/2026-08-20-c925-m2-roadmap-and-unbounded-stabilizations.md
- power-image/ExactTop report:
  notes/2026-08-20-c925-power-image-leakage.md
- oriented-heart adapter:
  notes/2026-08-20-c925-oriented-heart-adapter.md
- non-\(m=2\) categorical dividends:
  notes/2026-08-20-c925-non-m2-categorical-dividends.md
- conditional Section 6 specialization:
  notes/2026-08-20-c925-framed-m1-specialization.md

The packet index owns the module-to-file map.  Do not append another large
module to this card or to the index; add one focused companion file and one
index row.

## Closed mathematics

- The modular \(m=1\) proof is sound from its stated Iritani,
  Iritani--Koto, and weak-factorization inputs.
- Guéré/BFGMP and KKPYY are lawful split specializations at the algebraic
  interface level, with their geometric provider hypotheses kept explicit.
- The augmented operator-row category has a genuine two-sided
  output-kernel ideal; the naked row-null class does not.
- Reader/indexed-State/Writer, optics, path functors, torsor holonomy,
  sparse reconstruction, and universal sufficient shadows have exact laws.
- Irrationality on any unbounded stabilization set implies irrationality at
  every index.
- Fixed-factor products have the unique extremal source line.
- The power-image functor and its snake boundary give the exact minimal
  extension leakage seen by the Jordan endpoint consumer.
- In an opposite-oriented exact heart, ambient-to-exceptional Hom
  orthogonality kills that boundary; a nonsplit quiver model shows this is
  weaker than splitting at the heart level.

## Open geometric providers

### Rank row

Construct one coherent fixed-phase Gamma/Stokes/Orlov comparison which
preserves the rank quotient through every actual blowup occurrence.  This is
the highest-EV route because it avoids a universal threefold carrier theorem
and is uniform in \(m\).

### ExactTop

Construct, in the correct oriented enriched exact heart, an actual
operation-framed blowup sequence whose exceptional term is killed at the
threshold and whose snake boundary vanishes.  At \(m=2\), the two oriented
cross terms are

\[
\Omega_2(\delta)=N_A\delta+\delta N_E
\quad(0\to A\to B\to E\to0),
\]

and

\[
\Omega^{\mathrm{op}}_2(\delta)=N_E\delta+\delta N_A
\quad(0\to E\to B\to A\to0).
\]

Standard Orlov semiorthogonality naturally targets the second orientation.

The internal center-square condition and the ambient--exceptional boundary
are independent gates.

## Validation

Exact replay:

    nix shell nixpkgs#python3 --command \
      python3 notes/cubic-threefolds-tasks/c925-categorical-law-check.py \
      | diff -u notes/cubic-threefolds-tasks/c925-categorical-law-check.json -

Typed replay:

    nix shell nixpkgs#ghc --command \
      runghc notes/cubic-threefolds-tasks/c925-sparse-shadow-path-toy.hs \
      | diff -u \
          notes/cubic-threefolds-tasks/c925-sparse-shadow-path-toy-output.txt -

The finite model currently has fifty-three checks.  It verifies only the
advertised algebraic laws and countermodels, never an external QDM provider.

## Next

1. Construct the opposite-oriented cyclotomic QDM blowup sequence
   \(0\to E\to B\to A\to0\) in the enriched operation-framed heart.
2. Prove the actual \(m=2\) exceptional term is square-zero and compute the
   opposite boundary for the base-ideal or normal-splitting Rees sequence.
3. Continue the higher-EV rank-row common-receiver audit in parallel.

C925 remains active until the user closes it.
