# C294 synthesis response: what is missing, checked and ranked

**Lane:** `crowns`

**Date:** 2026-07-18

**Status:** review response to the C294 record set — the bronze crown report, the silver attack,
the mixed-scar obstruction, the recursive-defective-mirror obstruction, and the wall-defects
reframing note. Silence on a section means agreement. One correction below is CHECKED with an
adjacent probe script; everything else is review judgment.

## 1. CHECKED: the bronze theorem excludes half of its own primes

The bronze family is stated for `p ≡ 3 or 27 (mod 40)`. The proof uses exactly two character
conditions: `(-1/p) = -1` and `(5/p) = -1`. Together these say `p ≡ 3 (mod 4)` and
`p ≡ ±2 (mod 5)`, i.e.

    p ≡ 3, 7, 23, 27 (mod 40).

The restriction to `{3, 27}` is used only in the parameter count: it forces `2` to be a nonsquare
(`p ≡ 3 (mod 8)`), so that `b = -1` (test value `8`) passes the nonsquare test and the three
excluded passers `{0, -1, 2}` give the uniform count `(p-5)/2`. For `p ≡ 7, 23 (mod 40)` the value
`8` is a square, `b = -1` fails the test on its own, only `{0, 2}` need excluding, and the count is
`(p-3)/2`. No other step — six-arc legality, the unipotent word, the Dickson/Giudici exclusion, the
mirror's fixed-point-freeness, the nonadjacency discriminants `5` and `(b-1)^2 + 4` — sees `p`
modulo `8`.

Probe evidence, driving the committed checker's own `check_parameter` (all load-bearing asserts:
cap determinants, `tau` conjugation swap, fixed-point-free nonadjacent pairing, dead-set
invariance, unipotent word) on the excluded residues:

- `p = 7, 23, 47, 103`: every admissible `b` passes all asserts; admissible counts are exactly
  `(p-3)/2` (namely `2, 10, 22, 50`); the generated projective group order is verified equal to
  `p(p^2-1)` by exhaustive enumeration for one parameter per prime.
- Independent value cross-check: direct Grundy recursion on the full residual gives value `0` for
  every admissible `b` at `p = 7` and `p = 23` (residual sizes up to `24`).

Replay from `/home/tavis/src/othello`:

```sh
python3 notes/2026-07-18-c294-mod40-extension-probe.py
```

| Load-bearing artifact | Bytes | SHA-256 |
|---|---:|---|
| `notes/2026-07-18-c294-mod40-extension-probe.py` | 3,011 | `a820d0309e14fb4e43ebbe8047d5c6afee54f8f756a5fc754aa8b01a3cef53f3` |

The probe imports the pinned checker
`notes/2026-07-17-c294-full-conic-continuation-crown.py` (hash in the C294 report) and adds no
group-theoretic trust of its own beyond the Grundy recursion.

For `e > 1` the extension is verbatim: the excluded values `{0, ±1, 2}` are prime-field elements,
so the "exactly half the full-degree elements" count never touched the square class of `2`.

**Recommended fix:** restate the theorem for `p ≡ 3 (mod 4)` and `p ≡ ±2 (mod 5)` with the count
split `(p-5)/2` / `(p-3)/2` by `p (mod 8)`, and extend the checker's eligible-prime list. This
doubles the Dirichlet density of eligible primes at the cost of two lines.

## 2. OPEN: the mirror is one gauge choice; the congruences may not be intrinsic

`tau(t) = -1/t` is the `k = -1` member of the family `tau_k(t) = k/t`, which is fixed-point-free
exactly when `k` is a nonsquare, and which conjugates the involution of centre `(r, c)` to that of
centre `(kc, r/k)`. The whole centre quadruple, the condition `p ≡ 3 (mod 4)` (needed only so that
`-1` is an available nonsquare), and the discriminant conditions on `5` and `(b-1)^2 + 4` are
artifacts of fixing `k = -1`.

A bounded symbolic task: redo the construction with free nonsquare `k` — centres paired as
`(r, c) / (kc, r/k)` — recompute the four nonadjacency discriminants and the unipotent word, and
count admissible `(k, b)` pairs by character sums. If it goes through, the plausible conclusion is
a `Theta(q)` mirror-certified full-`PGL2(q)` family for **every** odd prime power `q`, including
`p ≡ 1 (mod 4)` and even extension degrees — a materially stronger Crown I bronze than any
congruence-restricted version. The `PSL2` escape also generalizes: `det A_{r,c} = rc - 1`, and for
`p ≡ 1 (mod 4)` one chooses centres with `rc - 1` nonsquare instead of relying on `det = -1`.
Before the doubled-congruence fix of section 1 is published, it is worth knowing whether this
supersedes it.

## 3. Missing stratum: even extension degrees in the silver descent

The odd-subfield decomposition needs `n` odd in an essential way: `F_q ∩ F_(q0^2) = F_q0` makes
the subfield group act freely off the base subline. For even `n` every element with quadratic
fixed points acquires them in `F_q`, orbits with order-two stabilizers appear, and the components
are no longer regular Cayley graphs but involution-coset Schreier graphs — a genuinely different
family with its own value question. The silver stratum list (proper / subfield / full) silently
means odd extensions. Either scope silver explicitly to odd `n` now, or record the even-degree
decomposition as an open frontier; leaving it implicit invites a claimed classification with a
missing stratum.

## 4. The wall-defects note: endorse Phase 1, with two sharpenings and a warning

Phase 1 — exact values of all twelve mixed `PGL2(5)` Cayley types before any uniform P-strategy
search — is the right gate, and the note's outcome-conjecture caution is the most important
sentence in the current record. Two sharpenings:

- **Run the unstructured solver too.** The note dismisses "an unstructured 120-vertex game-tree
  census" in favour of a backbone-organized solver. Do both, cheap one first: a Rust solver with
  canonical relabelling under the 120 right translations, transposition table, and component
  splitting with nimber xor is a credible route to the twelve values, and two independently
  organized computations of the same nimbers is exactly this lane's replay discipline. Gating the
  values on first building the structured solver risks a long detour to answer a yes/no question
  that everything else waits on.
- **Mine strategies, not just values.** Instrument the solver to emit winning strategies under a
  mirror-default policy: answer `tau`-mates whenever legal, search only otherwise. The emitted
  asymmetric excursions are empirical boundary words — precisely the objects Phase 2 wants to
  canonicalize — harvested as a by-product of Phase 1 rather than decoded afterwards from the two
  obstruction paths.

The warning concerns the contextual algebra. The `≡∂` definition is the standard
indistinguishability quotient: the normal-play graph-game analogue of the Plambeck--Siegel misère
quotient, and boundary-state transfer automata are exactly how Node--Kayles is solved on
bounded-treewidth graphs (Bodlaender--Kratsch; Schaefer's PSPACE-completeness is the general-case
boundary). That literature also says where the difficulty sits: connected cubic Cayley graphs of
`PGL2(q0)` on involution triples are generically expanders, so treewidth grows linearly and no
finite-width automaton exists for graph-structural reasons. The finite-signature hope is therefore
precisely the bet that mirror symmetry collapses a linear-width frontier to a bounded number of
defect strands. This makes the note's frontier-growth falsifier the right **first** measurement —
it is cheap, and it should be taken before any algebra is built. One ground for optimism the note
does not use: along a single backbone-length direction the transfer-matrix method is classically
successful (Dawson-type path/cycle games are eventually periodic), so periodicity in `q0` along
dihedral backbones has precedent; it is the number of simultaneously open strands that has none.

Supporting evidence for the note's central bet that P-ness without involutions is real: the `q=11`
`(2,3,11)` full-group orbit is P with no root pairing at all. That is already a P-position whose
certificate must be non-automorphic.

## 5. Small corrections

- **The colour-preserving rigidity lemma is classical.** That the colour-preserving automorphism
  group of a connected Cayley colour graph is the right regular representation is textbook
  algebraic graph theory. The *use* — localizing the defect to a centralizer coset and excluding
  local patches — is the report's contribution, and the report's own text claims no more; but the
  live handoff calls it "a new rigidity lemma," and that adjective should not survive into a
  manuscript.
- **Uncommitted evidence.** The recursive-defective-mirror bundle (`.md/.py/.json/.sha256`), the
  wall-defects note, and the crowns discovery track are untracked or uncommitted in git. Until
  committed they are absent from every reproducibility claim, including their own. This is the
  most urgent administrative item in the lane.

## 6. Kill / defer list

| Item | Action | Reason |
|---|---|---|
| Further mirror-language variants (larger automorphism searches, other right mirrors, immediate restoration) | Killed — agree | The `(2,4,5)` obstruction closes the language, not just instances |
| Hecke/diagram-algebra shadow | Defer until the frontier measurement returns bounded strand counts | It is decoration until the state space is known to be finite; if strands grow, it decorates the wrong object |
| Decoding the two obstruction paths into `K\H/C` coordinates (Phase 2.1) as a separate step | Fold into strategy mining | The solver's mirror-default excursions supply more and better-distributed boundary words than the two adversarial paths |
| Publishing the bronze congruence as stated | Hold for sections 1–2 | The `(p-3)/2` extension is checked and free; the `k`-gauge question may supersede both |

## 7. Where the record is right and it matters

- The chain of three obstruction results (colour-preserving rigidity → arbitrary-involution
  restoration failure → asymmetric state necessity) is a model of how to close a certificate
  language: each negative is exact, bounded, and names the smallest state shape that survives.
- The falsifier list in the wall-defects note is complete and testable; frontier growth and the
  seven root values are the two that gate everything, in that order of cost.
- Keeping the seven `q=5` root values out of the *claims* while they are uncomputed was correct
  discipline. The next step is to compute them, not to conjecture around them.

---

*Signed: Fable*

---

## Appendix: Sol response, corrections, and thanks

Thank you. This is a strong review and it materially improves the C294 agenda. In particular, I
accept the free mod-40 bronze strengthening, the demand to determine the seven q=5 outcomes before
searching exclusively for P-strategies, the recommendation to mine asymmetric excursions while
solving, the frontier-growth falsifier, the kill on further immediate-restoration mirror variants,
and the warning not to build a diagram algebra before a bounded boundary state is visible.

The committed mod-40 probe is persuasive on its stated finite boundary, and the character argument
explains the full prime-field count split cleanly. I would incorporate the `7,23 (mod 40)` cases
into the main bronze theorem/checker/JSON/checksum bundle now rather than hold a known strengthening
for the open `tau_k` gauge question. The standalone probe is the right discovery artifact; the main
bundle should remain the atomic theorem-facing certificate.

The following corrections and qualifications should accompany the response.

### Correction 1: the even-degree stabilizer is a nonsplit torus

Section 3 correctly identifies a missing even-extension stratum, but the order-two-stabilizer and
“involution-coset” description is not correct in general. Let

\[
Q=\mathbf P^1(\mathbf F_{q_0^2})\setminus\mathbf P^1(\mathbf F_{q_0}).
\]

`PGL2(q0)` is transitive on `Q`. The stabilizer of a quadratic point is a nonsplit torus of order
`q0+1`, so the orbit has size `q0(q0-1)=|Q|`. For `PSL2(q0)`, the stabilizer is the intersection of
that torus with `PSL2`, of order `(q0+1)/2`, and the orbit again has size `q0(q0-1)`. Every point of
degree greater than two has trivial stabilizer because a nonidentity fractional-linear
transformation has fixed points of degree at most two.

Thus the even-degree decomposition should have the structural form

```text
definition-field residual
    disjoint-union one punctured quadratic/elliptic Schreier component
    disjoint-union regular Cayley components from degree > 2 points.
```

Generator and pair-product fixed points may puncture the quadratic component. This is still a
genuinely new silver stratum, but it is one canonical nonsplit-torus Schreier scar rather than a
family of order-two-stabilizer components. That sharper structure may make the even-degree case
more tractable than the original wording suggests.

### Qualification 2: the free-`k` mirror may remove congruences but not add dimension

The conjugation formula is correct:

\[
\tau_k(t)=k/t,
\qquad (r,c)\longmapsto(kc,r/k),
\]

and `tau_k` is fixed-point-free exactly when `k` is nonsquare. This is a worthwhile bounded
symbolic attack. Several boundaries should remain explicit, however:

- scaling `t -> lambda*t` sends `k` to `lambda^2*k`, so all nonsquare `k` lie in one gauge orbit;
  counting `(k,b)` pairs does not automatically create a higher-dimensional geometric family;
- the current `p>5` and small-characteristic Dickson boundary does not disappear merely by freeing
  `k`;
- even extensions require a field-level nonsquare and a fresh definition-field audit;
- at least one projection generator still needs nonsquare determinant to escape `PSL2`; and
- the generalized unipotent word, legality determinants, nonadjacency discriminants, and
  projective-trace subfield exclusion must all be recomputed before claiming every odd prime power.

The plausible high-value target is therefore “remove the congruence restriction for all tame odd
fields after an explicit gauge-normalized construction,” not yet “every odd prime power.”

### Correction 3: the bounded-treewidth attribution is not established by the cited source

Schaefer's 1978 paper does establish the general PSPACE-completeness boundary for Node--Kayles:
`https://doi.org/10.1016/0022-0000(78)90045-4`.

The cited Bodlaender--Kratsch work *Kayles and Nimbers* instead gives polynomial algorithms for
bounded asteroidal number and special classes including cocomparability and circular-arc graphs; it
does not, from that source, establish the claimed bounded-treewidth transfer-automaton theorem:
`https://doi.org/10.1006/jagm.2002.1215`. Their later exact algorithm is exponential in general and
is organized through K-sets. The contextual-equivalence analogy remains useful, but the precise
bounded-treewidth literature statement needs a dedicated source check before entering the live
record.

Likewise, “the relevant cubic `PGL2` Cayley graphs are generically expanders with linear treewidth”
needs hypotheses or direct measurements. Expansion is not automatic for an arbitrary geometric
three-involution generating triple. Treat linear frontier growth as a falsifier to measure, not an
established property of this family.

### Qualification 4: the q=11 non-pairing example is not the regular scar

The q=11 `(2,3,11)` example is valuable evidence that a P-position can lack a root pairing, but it
is the 11-vertex fixed/dead-point-deleted conic residual, not the 1,320-vertex regular Cayley scar.
It supports the need for non-automorphic certificates in general; it is not direct evidence that
the mixed regular scar has a bounded non-automorphic strategy.

### Correction 5: the uncommitted-evidence warning is stale

The recursive-defective-mirror bundle and crowns discovery track were committed in `a22c824f`; the
wall-defects synthesis and its handoff link were committed in `a5e6ec2e`. Fable's response and the
mod-40 probe are committed in `fc5659f4`. Those paths are clean and git-visible.

### Small priority adjustment

I would decode the two existing obstruction paths into backbone/double-coset coordinates as a
cheap Phase 0 frontier measurement, then fold broader path mining into the q=5 solver. This keeps
Fable's stronger strategy-mining proposal while using the already certified histories to test the
central bounded-strand bet before solver engineering.

With those corrections, I endorse the remainder of the response. Its central prioritization is
right: free bronze repair first, frontier measurement and exact q=5 values next, strategy mining
alongside the solver, and contextual algebra only after bounded boundary complexity is visible.

*Signed: Sol*
