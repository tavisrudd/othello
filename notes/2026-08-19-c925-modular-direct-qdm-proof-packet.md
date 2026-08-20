# C925 modular direct-QDM proof packet -- index

**Lane:** cubic-threefolds

**Status:** \(m=1\) modular proof verified; categorical generalizations
proved at their stated abstraction level; \(m=2\) and all-\(m\) providers
remain conditional

This file is the stable entry point for the C925 mathematics-only packet.
The numbered modules are split into bounded companion files.  Module numbers,
theorem numbers, and equation numbers are unchanged.

No manuscript or Lean source is part of this packet.

## Read order

| modules | subject | file |
|---|---|---|
| 0--3 | interface, generic blocks, markers, coefficient spines | notes/2026-08-19-c925-interfaces-and-coefficients.md |
| 4--6 | rank-two observation, comparison adapters, center pullback | notes/2026-08-19-c925-rank-two-and-adapters.md |
| 7--10 | categorical compiler, universal ledger, conservation, cubic marker | notes/2026-08-19-c925-compiler-ledger-marker.md |
| 11--13 | low-dimensional vanishing, projective endpoint, final \(m=1\) proof | notes/2026-08-19-c925-cubic-proof.md |
| 14--18 | configuration menu, hostile/source audits, external specializations, modular statement | notes/2026-08-19-c925-audits-and-final-statement.md |
| 19 | morphisms, compositions, higher-stabilization consequences | notes/2026-08-19-c925-morphisms-and-compositions.md |
| 20 | sparse reconstruction, effects, optics, and path functors | notes/2026-08-19-c925-sparse-effects-and-optics.md |
| 21.1--21.11 | \(m=2\) path, marked row, endpoint, and K-theoretic forcing | notes/2026-08-19-c925-m2-path-and-row.md |
| 21.12--21.16 | provider morphisms, reconstruction, Fourier/comma bridges | notes/2026-08-19-c925-m2-providers-and-reconstruction.md |
| 21.17--21.22 | torsor holonomy, character forcing, mutations, rank, leakage | notes/2026-08-19-c925-m2-holonomy-rank-and-leakage.md |
| 22 | conditional Section 6 \(m=1\) proof as a sibling specialization | notes/2026-08-19-c925-conditional-m1-specialization.md |
| 23 | universal sufficient shadows and non-\(m=2\) dividends | notes/2026-08-19-c925-universal-sufficient-shadows.md |
| 24 | corrected \(m=2\) roadmap, cofinal stabilizations, all-\(m\) criterion | notes/2026-08-20-c925-m2-cofinal-module.md |
| 25 | power-image functor, Bockstein leakage, ExactTop provider | notes/2026-08-20-c925-power-image-module.md |
| frontier | open experiments and provider targets | notes/2026-08-20-c925-exploration-frontier.md |

## Dependency spine

\[
\text{generic QDM blocks}
\longrightarrow
\text{lawful marker package}
\longrightarrow
\text{comparison ledger}
\longrightarrow
\text{center-null weak-factorization telescope}.
\]

For the cubic \(m=1\) specialization, Modules 0--13 supply a complete
mathematical proof from the audited external QDM inputs.

Modules 19--23 prove reusable categorical consequences:

- lawful morphisms and compositions;
- Reader/indexed-State/Writer and optic/path interfaces;
- sparse-shadow reconstruction;
- the augmented-row output-kernel ideal;
- universal center-null quotients and minimal sufficient shadows; and
- the conditional Section 6 argument as a separate specialization.

Modules 24--25 isolate the higher-stabilization frontier:

- irrationality on any unbounded stabilization set implies irrationality for
  every index;
- fixed projective factors give a cofinal tensor presentation;
- the strict Jordan transport gate may be weakened to an occurrence-indexed
  exact sequence, an exponent certificate, and one snake-boundary
  certificate; and
- the rank-row route remains the higher-EV uniform alternative.

## Current \(m=2\) alternatives

### Rank-row provider

Transport the fixed-phase Gamma/rank quotient through every actual blowup
step.  The complete defect is the boundary-to-rank leakage covector.
This route avoids a universal threefold carrier theorem but still needs the
analytic Gamma/Stokes/Orlov comparison in one coherent receiver.

### ExactTop provider

For each actual blowup occurrence, construct an oriented short exact
sequence in the enriched operation-framed heart, in either form

\[
0\to V_Y\to V_{\widetilde Y}\to E_\pi\to0
\quad\text{or}\quad
0\to E_\pi\to V_{\widetilde Y}\to V_Y\to0,
\qquad
N^2E_\pi=0,
\qquad
\tau_{\pi,2}=0
\quad\text{or}\quad
\tau^{\mathrm{op}}_{\pi,2}=0.
\]

This is strictly weaker than splitting the full packet.  It retains exactly
the cross-extension component capable of creating the forbidden \(J_3\).
Standard Orlov semiorthogonality has the variance of the second orientation;
the relevant Hom vanishing lives in the enriched heart, not after forgetting
to plain nilpotent \(K[N]\)-modules.
The occurrence-indexed QDM sequence, square-zero exceptional term, and boundary
vanishing remain open.

## Dated reports

- \(m=2\), cofinal-index, and all-\(m\) status:
  notes/2026-08-20-c925-m2-roadmap-and-unbounded-stabilizations.md
- power-image/Bockstein theorem and ExactTop audit:
  notes/2026-08-20-c925-power-image-leakage.md
- conditional \(m=1\) specialization:
  notes/2026-08-20-c925-framed-m1-specialization.md
- non-\(m=2\) categorical dividends:
  notes/2026-08-20-c925-non-m2-categorical-dividends.md

## Executable witnesses

The finite algebraic law model and exact output are:

- notes/cubic-threefolds-tasks/c925-categorical-law-check.py
- notes/cubic-threefolds-tasks/c925-categorical-law-check.json

The typed path/effect toy and output are:

- notes/cubic-threefolds-tasks/c925-sparse-shadow-path-toy.hs
- notes/cubic-threefolds-tasks/c925-sparse-shadow-path-toy-output.txt

These validate the advertised finite algebra only.  QDM comparison,
reconstruction, carrier, Stokes, Gamma, and weak-factorization provider
theorems remain mathematical inputs exactly where the modules say so.
