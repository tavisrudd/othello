# Paper: Arcs complete outside a prescribed conic

**Title:** *Arcs complete outside a prescribed conic — a secant-defect identity, lower bounds,
and verified examples.* Author: Tavis Rudd.

**Status:** the most finished unit in `papers/` — a self-contained manuscript with a compiled
PDF, a proof/claim audit, an independent verifier (SHA-256 stamped), and a completed strict-trust
Lean formalization under [`lean/RelativeConicArcs/`](../../lean/RelativeConicArcs/). Related to the
projective-cap program but **separate**: it draws only on classical index equations, not on the
game machinery. The sole unresolved reported finite value is `rho_C(16) in {8,9}`; an exact
construction-or-nonexistence certificate lane is active as C101.

**Object.** For a nonsingular conic 𝒞 ⊂ PG(2,q), study arcs A disjoint from 𝒞 whose secants
cover every point outside A ∪ 𝒞; ρ_𝒞(q) is the minimum size. Contributions:
- an exact **prescribed-hole defect identity** (splits the classical first/second secant-index
  equations over an exceptional set, with an exact — not estimated — remainder);
- coverage / uncovered-locus bounds, an equality criterion, and a quantitative stability bound;
- the asymptotic lower bound **ρ_𝒞(q) ≥ √(2q) + 3/2 − O(q^{−1/2})**;
- a projective-averaging upper-bound transfer (ρ_𝒞(q) ≤ t₂(2,q) when t₂(2,q) ≤ q; Kim–Vu
  corollary);
- even-characteristic nucleus constraints;
- verified small values: ρ_𝒞(8) = ρ_𝒞(9) = ρ_𝒞(11) = 6, 8 ≤ ρ_𝒞(16) ≤ 9.

The Lean package proves the elementary theorem chain, the conic/projective transport statements,
and a semantic bridge from a generic rules-only coordinate checker to relative completeness. Its
finite checks use kernel `decide`, never `native_decide`; the theorem and axiom manifest is
[`lean/RelativeConicArcs/TRUST.md`](../../lean/RelativeConicArcs/TRUST.md).

**Small-order structural note.** The `q=11` witness has `I_C=0`, so all 15 of its secants are
exterior to the conic. The moment equations force its 115 required points to have index distribution
`(N₁,N₂,N₃)=(90,15,10)`. In the auxiliary cap-game reading, all twelve conic points are
initially live and their conflict graph is the icosahedral graph; its antipodal involution proves
the residual position P. Lean checks this exact determinant graph and applies the generic proved
mirror theorem. These are consequences of the certified coordinates, not novelty claims, and the
game statement is not used in the paper's bounds.

**Novelty posture (self-stated):** a targeted search did not locate the relative-completeness
definition or the exact defect identity in this form; the note explicitly disclaims a priority
certificate (proofs are elementary consequences of classical index equations).

## Files here

- `arcs_complete_outside_conic.tex` / `.pdf` — the manuscript
- `arcs_complete_outside_conic_proof_audit.md` — proof/claim audit
- `verify_relative_conic_arcs.py` / `verify_relative_conic_arcs_output.txt` — the verifier + run
- `../../lean/RelativeConicArcs/` — standalone Lean formalization and kernel-checked certificates

## Related but separate

- The √(2q) scale coincides with `baer-equivariant-extension`'s Cor 3.4 (both are the classical
  Lunelli–Sce √(2q) complete-arc bound). Coordinate the novelty framing across the two so they
  don't appear to double-claim the same constant — see `../papers-planning.md`.
- The game-side conic-localization / off-conic "intruder calculus" (an open odd-plane research
  line, proved only q=5,7) motivated this geometry but is a **different, unfinished** candidate;
  it lives in the research track, not here.

No `../notes/` symlinks — this manuscript is self-contained.
