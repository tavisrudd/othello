# Second-draft fix plan

## Governing decision

The revised main proof spine consists only of complete human proofs backed by
statement-adequate Lean declarations.  Computations and certificates are
appendix-only and cannot discharge a body theorem.

## Work order

1. C671 freezes the hierarchy and installs the control documents.
2. C672 is closed: MDS reconstruction, exact radius, code recovery, and intrinsic invariance pass the paper-facing Lean gate.
3. C673 is closed: exact confinement/transfer has a complete human proof,
   paper-facing zero/singleton/multisupport and pointed terminals, and a green
   axiom gate.
4. C674 is closed: trace duality, eventual exact confinement, coefficient-port
   copies, density, scaled parameters, and general MDS fingerprints pass the
   paper-facing gate; outer-family existence is the named classical input.
5. C675 proves and formalizes reliability and bounded EXIT.
6. C676 follows C675 for pointed Tutte and the filtration boundary.
7. C677 follows C672 for harmonic geometry.
8. C678 assembles the modular draft after C672--C677 pass.
9. C325 builds the appendix-only finite verifier after the appendix freezes.
10. C679 runs aggregate formal, prose, and independent-reader gates.

## Correctness gates

- Every body theorem has a stable label, complete proof, Lean terminal,
  statement-adequacy row, and declaration-level axiom audit.
- Exact hypotheses, field ranges, pointed equivalence conventions, and
  bounded/full-radius distinctions agree across prose and Lean.
- Named classical imports are quoted at the exact strength consumed.
- No generated record, native execution, script, or certificate occurs in a
  body theorem's dependency chain.

## Proof-architecture gates

- The MDS local-reconstruction theorem appears on page 2.
- The coefficient layer, rather than generic MDS support data, carries the
  reconstruction claim.
- Exact pointed confinement precedes asymptotic realization.
- Reliability and Tutte structure are general theorems before geometric data.
- Cubic and harmonic families demonstrate distinct port geometries; neither
  organizes the general theory.
- Every computed claim can be removed with the body proof spine still intact.

## Exposition gates

- Each substantial proof begins with its mechanism and expands its true
  bottleneck.
- Literature and provenance do not interrupt proofs.
- Verification language distinguishes manuscript proof, Lean, imported
  theorem, and appendix computation.
- The conclusion ends mathematically rather than with artifact administration.

## Cold-read sessions

| Session | Target | Acceptance gate |
|---|---|---|
| F1 | Theorem hierarchy | A reader finds the MDS theorem on page 2 and can state the causal spine without the applications |
| F2 | Human proofs | A qualified reader can reproduce every body proof without consulting Lean or a certificate |
| F3 | Formal adequacy | Every printed hypothesis and conclusion matches a named Lean terminal |
| F4 | Trust boundary | Imported mathematics and standard axioms are explicit; computations are absent from body dependencies |
| F5 | Computation independence | Removing the appendix leaves every body theorem proved |
| F6 | Exposition | Section openings and theorem statements alone tell a coherent paper story |

## Release rule

C679 may declare the private manuscript draft-ready.  It does not authorize a
fresh-history export, public repository initialization, archive creation, push,
or release.  Those actions retain the handoff's external-review, C287, identity,
and author gates.
