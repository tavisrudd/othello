# C189 — The q=5 octahedral frame bridge

**Date**: 2026-07-15
**Lane**: `cap` — see CLAUDE.md § Lane routing.
**Status**: **QUEUED.** This note records a cross-paper consequence and its proof obligations; it
does not promote the expected conflict graph or game value to a theorem.

## Imported geometric input

Clebsch C187 combines exact chord-moment identities with exhaustive normalized searches for the
surviving seven-arc cases at `q=11,13`. It proves that, among `4 <= k <= 7`, equality
`U(A)=C(F_q)` for a nonsingular conic occurs only for `(k,q)=(4,5)` or `(6,11)`. Its hardened
finite checker also verifies that the standard projective frame in `PG(2,5)` has exactly six
uncovered points and that they are precisely the rational points of

`X^2 + Y^2 + Z^2 + XY + XZ + YZ = 0`.

The source and trust boundary are in
[`C187`](2026-07-15-c187-general-k-arc-conic-filling.md). C189 consumes that result; it must not
duplicate the frame/conic enumeration.

## Game-side target

Let `A` be the standard four-point frame and let `H=U(A)` be the six-point conic. Define the
pair-conflict graph on `H` by joining distinct `x,y` exactly when `A union {x,y}` is not an arc.
C189 should certify the following finite bridge.

1. The conflict graph is `K_6` with one perfect matching deleted, equivalently the octahedral
   graph `K_{2,2,2}`.
2. The three missing edges give a fixed-point-free antipodal involution. After either player chooses
   a conic point, the antipode is the unique remaining legal conic point; replying at the antipode
   is therefore a copycat strategy.
3. Since C187 gives `U(A)=H`, the relative-complete sealing bridge applies: there are no off-conic
   legal moves at the seed or any continuation. Thus the graph calculation proves the actual
   seeded projective-cap position `A` is P, not only an abstract residual graph.
4. Present the result beside the existing `q=11` Clebsch seed, whose sealed conflict graph is the
   icosahedral graph and whose seeded P-value is already Lean-proved. The intended comparison is a
   small polyhedral pair—octahedral at `(4,5)`, icosahedral at `(6,11)`—not a uniform odd-field
   strategy law.

## Acceptance gates

- Give explicit coordinates for the six conic points and all fifteen unordered pairs.
- Check all fifteen pair extensions against projective collinearity and prove the nonedges form
  exactly a perfect matching. A fail-closed finite checker may support this, but its script must be
  tracked in Git if cited.
- State and prove the graph-game copycat lemma, or reuse an existing general involution/pairing
  theorem with its hypotheses discharged for `K_6-M_3`.
- Use the recursive parametrized-hole/sealing bridge to transport the residual P-value back to the
  actual projective-cap seed.
- Add a focused Lean theorem and standard-axiom audit if this is promoted into either manuscript;
  until then, retain **QUEUED** status everywhere.
- Cross-reference, rather than restate, C187 and the q=11 icosahedral computation.

## Effect on the odd-q conjecture

C187 establishes one narrowly defined exclusion: for `4 <= |A| <= 7` and `q>=13`, the full
extension locus cannot satisfy `U(A)=C(F_q)` for a nonsingular conic. It does **not** exclude
`U(A)` being a proper subset of `C(F_q)`, other conic-localized seeds, or any sealing argument whose
hole set is not exactly the full rational conic. C189 should record the two equality cases and then
stop. This has **no theorem-status effect** on the conjecture that every odd `PG(2,q)` is P.

In particular it does not weaken, replace, or reformulate `(ON)`, which asks only that every
size-three residual position have **one P-valued on-conic child**. `(ON)` neither requires the full
extension locus to equal the conic nor requires the child to remain sealed there. The active
odd-plane work therefore remains the value-sensitive intrusion/steering problem.

## Cross-references

- Clebsch input: [`C187`](2026-07-15-c187-general-k-arc-conic-filling.md).
- Existing sealing and q=11 game bridge:
  [`C100`](2026-07-12-c100-relative-conic-game-bridge.md).
- Cap lane map:
  [`projective-cap handoff`](handoffs/2026-07-06-projective-cap-game-handoff.md).
- Odd-plane failure-mode map:
  [`odd-plane falsification map`](2026-07-09-odd-plane-falsification-map.md).
