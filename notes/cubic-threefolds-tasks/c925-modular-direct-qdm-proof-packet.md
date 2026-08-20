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
- dependent provider typing:
  notes/2026-08-20-c925-dependent-provider-typing.md
- type-level precedent audit:
  notes/2026-08-20-c925-type-level-precedents.md
- Iritani provider-gap and threshold-image audit:
  notes/2026-08-20-c925-iritani-provider-gap.md
- Gamma--monodromy detour:
  notes/2026-08-20-c925-gamma-monodromy-detour.md
- mobile hyperplane line-bundle state:
  notes/2026-08-20-c925-mobile-line-bundle-state.md
- logarithmic exceptional-correction pencil:
  notes/2026-08-20-c925-logarithmic-pencil-law.md
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
- The minimal dependent provider record separates occurrence, orientation,
  exponent, component/kernel typing, and exact realization.  It proves no
  extra source augmentation is consumed and prevents those fields from
  being silently identified.
- The cubic/product source \((\chi,N,N^{m+1}=0,N^mV\ne0)\) is sufficient
  for the ExactTop endpoint.  Bare formal QDM is not yet comparison-sufficient:
  the current \(N_L=1-\tau_L\) uses tensor-by-\(L\) on \(K_0\), so the
  provider needs a compatible cyclotomic operation realization.  No extra
  point/Gamma row is consumed.
- For a fixed Iritani direct-sum comparison, rank/Boolean ExactTop transport
  needs only that the transported top image be a graph over the ambient top.
  Full \(N\)-equivariance and even strict image equality are stronger.
- Gamma framing identifies tensor-by-line-bundle with large-radius
  monodromy, so a horizontal common-loop comparison can transport the
  complex operation without preserving the Gamma lattice.  Iritani's
  Fourier projections already expose the correct local divisor directions;
  the exact cocharacter/Levelt instantiation remains typed provider work.
- A hypothetical birational map supplies its own coherent mobile hyperplane
  state.  Its strict-transform corrections form a signed
  Picard-groupoid/Cartier-\(b\)-divisor Writer law, and its source retains
  nonzero \(\operatorname{Top}_m\).  Raw exceptional corrections are not
  null—the linear-projection resolution creates a hostile \(J_3\)—so the
  open theorem must live in the common primitive-character receiver.
- For commuting unipotent pullback and exceptional actions, logarithm loses
  no Jordan data and replaces \(1-AC^a\) by \(X+aY\).  At \(m=2\) the
  correction is one mixed term after the pure exponent certificates; for
  general \(m\) it is a finite mixed-word interface.

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

The finite model currently has sixty-two checks.  It verifies only the
advertised algebraic laws and countermodels, never an external QDM provider.

## Next

1. Instantiate the descending-line cocharacter and formal Levelt monodromy
   functor for Iritani's completed comparison.
2. In the same primitive-character receiver, compute the projected
   exceptional logarithm \(Y\) and the contextual mixed graph/boundary
   defect of \(X+aY\) for every actual mobile occurrence.
3. Prove the sharp occurrence-indexed exceptional exponent/carrier bound.
4. If the monodromy route fails, construct the opposite-oriented enriched
   exact sequence and use the Module 25/26 boundary adapter.
5. Continue the higher-EV rank-row common-receiver audit in parallel.

C925 remains active until the user closes it.
