# C973 one-hour-goal closeout — extra juice, Tao pass, and mysteries

**Lane:** `reed-solomon` · **Date:** 2026-08-26 · **Scope:** first proof
checkpoint only; C973 remains active

## Extra juice

Four upgrades became essentially free once the degree-six selector was
identified.

1. **The threshold improves instead of merely surviving.**  Using the exact
   R5 member count directly removes the extra singular-point deletion.  The
   uniform threshold becomes
   `6r-16+floor(2 sqrt(6r-18))`, with a separate binary improvement.
2. **The fixed levels unify exactly.**  R6--R10 specialize to integer bounds
   `28,35,42,50,56`, whose next prime powers are precisely
   `29,37,43,53,59`.  The uniform proof therefore recovers every existing
   asymptotic entry field rather than weakening any of them.
3. **Pointed escape is the same theorem.**  Prescribing `s` additional roots
   only adds `s` to the Vandermonde degree and `6s` to the terminal count.  No
   new stagewise package is needed.
4. **Witnesses become quantitative.**  Selector-zero counting plus the exact
   R5 count gives a fixed-`r` lower bound with leading term
   `q^(r-4)/(r-2)!`.  This supplies the natural bridge to sampling and the
   classifier without changing software claims now.

The Lucas pass then used the pointed viewpoint to close every R11 block
asymptotically and to expose the exact R12 obstruction.  This is stronger than
the task's minimum authorized exit of merely naming the first unresolved
block.

## Tao-style questions

### Why did the stagewise quadratic-looking collision count disappear?

Because distinctness is an alternating condition.  Multiplying one symmetric
selector by the Vandermonde packages every diagonal at once.  The relevant
degree is the degree in each root, `d+m-1`, rather than the sum of separate
bad-locus degrees over all stages.  In geometric language, the selector is a
section on `Sym^m(P^1)` and the Vandermonde is the discriminant section on its
ordered cover.

### Is degree six the real constant?

It is the honest uniform degree of `D` times one residual-carrier equation.
Characteristic two drops to four.  A smaller generic equation could improve
the marker-selection threshold, but that threshold is already dominated by
the terminal R5 count.  Chasing degree five would not strengthen the main
field range and is therefore low EV unless it also reveals new carrier
geometry.

### Why does the new threshold reproduce every fixed level?

The old fixed proofs and the new proof are charging the same object: twelve
bad terminal ordered pairs plus six per retained marker.  Stagewise
bookkeeping obscured that invariant total and added one conservative singular
deletion.  The numerical coincidence is consequently structural, not a lucky
rounding accident.

### What is the right all-level Lucas object?

Not the set of digit patterns alone.  Pascal zero runs determine a directed
contraction graph: a block is either transverse to the lower carrier or maps
coherently into a lower block.  Transverse vertices are handled by pointed
simultaneous escape; coherent edges require one-extra-root abundance on the
lower arithmetic construction.  R11 and R12 are the first two rows of this
graph.

### Can the witness lower bound become an asymptotic equality?

Possibly, but it would require controlling overlaps among marker/terminal
decompositions and the distribution of the degree-six selector hypersurface,
not just point existence.  The current lower bound already has the natural
factorial leading constant.  An equality or secondary term is a separate
incidence/Chebotarev problem and should not delay the main theorem.

## Mystery ledger

| Feature | Status | Evidence gap or next owner |
|---|---|---|
| Degree-six simultaneous selector | settled internally | C820 component converse plus characteristic-wise terminal ideals; independent geometry reconstruction remains mandatory. |
| Exact improved threshold | settled internally | Exact R5 count and strict inequality arithmetic; independent arithmetic reader remains mandatory. |
| Match with all R6--R10 entry fields | settled | Direct substitution and prime-power rounding; no computation needed. |
| Quantitative leading constant `1/(r-2)!` | settled as a lower bound | Pair multiplicity is exact; asymptotic equality is unproved and not needed. |
| R11 characteristic-seven fixed-root resultant | settled internally | Nonzero-resultant propriety and the determinant-zero chart need focused independent review. |
| Small pointed binary fields `16,32,64` | open | Existing certificates are unpointed; a compact pointed replay is required before claiming them. |
| R12 coherent `p=2,3,7` blocks | reduced exactly | One-extra-root abundance on the three R11 constructions is the next mathematical gate. |
| General Lucas zero-run contraction graph | open | Needs a theorem packaging transverse versus coherent edges and quantitative pointed propagation. |
| Paper compression estimate | provisional | The successor map targets a net 2--5 page reduction; only rebuilt canonical/TIT renders can settle it. |
| Novelty against work after the last audit | intentionally untested | Run the dedicated current literature delta only before a paper-facing novelty statement. |

No incidental result falls outside C973's requested theorem, quantitative, or
Lucas programme, so the discovery track receives no entry at this checkpoint.

## Highest-EV continuation

First obtain the independent three-lens review of the simultaneous theorem.
In parallel only after that review, package one-extra-root abundance on the
R11 binary, characteristic-three, and characteristic-seven constructions.
That single lemma decides whether the Lucas contraction graph can support an
all-level theorem or stops at a precise higher digit block.
