# C80 — causal-label nonpacking and certificate exchange

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-29.
Canonical status: `2026-07-25-c80-status-ledger.md`.

## Verdict

Causal-label injectivity is now proved under an intrinsic nonpacked
certificate-exchange condition.

The first, stronger guess is false on every certified q23 replacement
type. A causal half-move can destroy every old `B_small` certificate
in several fibres at once: the three marked orbit representatives have
full old-certificate carrier packing numbers

```text
Type I     3
Type II    7
Type III   7
```

This is not one-to-many defect creation. In the three representatives,
respectively `2`, `6`, and `6` of those fully attacked fibres acquire
new `B_small` certificates after the causal move. Exactly one fibre in
each representative remains uncompensated and becomes a genuinely new
defect. Thus the exchange-corrected packing numbers are `1,1,1`.

Because the carrier and certificate-exchange definitions commute with
projective transport, the three complete marked `PGL_2(23)` orbits
inherit the same conclusion. Combined with the prior exhaustive
three-orbit census, the certified canonical q23 replacement corpus has
no one-to-many causal replacement.

This proves the requested conditional injectivity theorem and
identifies its exact finite q23 carrier. It does **not** prove the
exchange-nonpacking hypothesis for arbitrary odd `q`, nor
opponent-complete entry into the charged survivor. C82 remains gated.

## Definitions

Let `A` be a legal projective-cap position and let `L(A)` be its legal
move set. Write

```text
Cert_A(z) =
  {r in L(A+z) : B_small(A+z+r)}.

Def(A) =
  {z in L(A) : Cert_A(z) is empty}.
```

Fix a causal half-move `h in L(A)`. For a point
`z in L(A+h) \ Def(A)`, its old certificate fibre is nonempty.

The fibre is **fully attacked** by `h` when no old certificate reply
survives as the same `B_small` certificate:

```text
Cert_A(z) intersect Cert_(A+h)(z) = empty.
```

It is **uncompensated** when it has no certificate at all after `h`:

```text
Cert_(A+h)(z) = empty.
```

Let `K_A(h)` be the fully attacked fibres and `U_A(h)` the
uncompensated fibres. The strong carrier-nonpacking condition is
`|K_A(h)| <= 1`. The correct, weaker certificate-exchange
nonpacking condition is

```text
|U_A(h)| <= 1.
```

Both are defined by fixed-depth legality, `Omega=0`, and the
terminal/two-mutually-legal-move formula for `B_small`; neither uses
minimax, Grundy values, `F_d`, or recursive survivor membership.

## Secant-carrier lemma

For every old certificate `r in Cert_A(z)` that fails after `h`,
exactly the corrected local alternatives from the previous report
apply.

1. If `r` is illegal after `A+h+z`, the only new forbidden triple in
   the union contains `h` and `r`. Hence a selected pivot
   `a in A union {z}` lies on the secant `hr`. In residual grid
   coordinates the two burned directions are simply the corresponding
   fixed projective pivots at infinity.
2. If `r` remains legal, order-independence makes `h` legal after
   `A+z+r`. A terminal `B_small` certificate is then impossible. In
   the two-point case, `h` must literally be one of the two live
   boundary endpoints; playing it leaves the other endpoint alone.

Therefore every member of `K_A(h)` is carried by certificate-reply
secant deletion or literal endpoint consumption. This is a
field-independent projective statement.

## Exact defect-exchange identity

For every legal `z` after `A+h`,

```text
z in Def(A+h) \ Def(A)
  iff
z in U_A(h).
```

The proof is immediate but load-bearing. On the forward direction,
`z` had an old certificate and has none after `h`; consequently every
old certificate is attacked and no replacement certificate exists.
On the reverse direction, nonemptiness before and emptiness after are
exactly the two defect predicates.

It follows that certificate-exchange nonpacking implies

```text
|Def(A+h) \ Def(A)| <= 1.
```

The strong condition `|K_A(h)| <= 1` is sufficient but unnecessary:
new certificates may repair several attacked fibres.

## Causal-label injectivity theorem

Suppose the active old defects carry distinct ancestral labels, the
causal half-move `h` carries its own old label, and genuinely new
defects are points outside the old labelled defect support. Retain the
labels of surviving old defects. If `U_A(h)` is empty, no label is
transported. If `U_A(h)={z}`, give `z` the old label of `h`.

This update is injective.

Indeed, exchange nonpacking gives at most one new defect, so the
transported label cannot branch. The selected point `h` cannot remain
a current defect; by old-label injectivity, its label is therefore
absent from every retained defect. Hence it cannot collide with a
retained label.

The new label support is a strict subset of the old support whenever
the number of consumed old defects exceeds the number of
uncompensated fibres. In particular:

- with no new defect, selection of the labelled `h` already gives a
  strict drop;
- with one new defect reusing `h`'s label, one additional old defect
  must disappear.

This separates the two obligations that earlier reports conflated:
exchange nonpacking proves injectivity, while the strict-support
inequality proves well-founded descent.

## q23 carrier audit

The direct affine-determinant engine reconstructed one representative
of each complete marked q23 replacement orbit. For each causal
half-move it enumerated every compatible old nondefect, every old
`B_small` reply, every secant/endpoint attack, and every newly
emergent certificate.

| orbit type | fully attacked old fibres | repaired by new certificates | uncompensated/new defects |
| --- | ---: | ---: | ---: |
| I | 3 | 2 | 1 |
| II | 7 | 6 | 1 |
| III | 7 | 6 | 1 |

All old-certificate attacks in these representatives are
certificate-reply secant deletions; no endpoint-consumption example
appears. Type I's two repaired false-positive carriers receive `2`
and `1` new certificates. Types II and III have the same repair-count
multiset

```text
{1,1,1,2,2,2}.
```

In fact this equality is exact, not merely numerical. Immediately
before their causal reply, the Type-II and Type-III representatives
are the same residual state and use the same causal move. They are
different marked ancestry orbits only because the two preceding
selected points were played in the opposite historical roles. Thus
the certificate-exchange update has two local q23 types, while the
ancestral-label proof still has three marked provenance types. This
cleanly separates the memoryless repair lemma from the
history-dependent label-availability and support-surplus lemmas.

The important negative is that certificate uniqueness and even full
old-fibre destruction do not isolate the causal replacement. A
half-move can simultaneously delete seven old certificate fibres.
What prevents branching in q23 is immediate certificate exchange in
six fibres, not secant uniqueness.

As a cheap independent boundary check, both the bitmask engine and a
separate affine-determinant implementation exhaust every reachable
residual state after the fixed opening pair for `q=3,5,7`. They agree
that no old-labelled opponent or reply half-move creates more than
one genuinely ancestral-new defect. The unrestricted searches cover:

```text
q=3:       28 states,       36 opponent half-moves,      0 reply half-moves
q=5:      726 states,      825 opponent half-moves,  2,800 reply half-moves
q=7:   19,160 states,   44,737 opponent half-moves, 72,324 reply half-moves
```

This is a finite negative through q7, not a uniform theorem and not a
search of q11 or larger raw state spaces.

## Exact searched domain and trust boundary

The q23 audit uses one representative from each of the three complete,
pairwise-disjoint marked `PGL_2(23)` replacement orbits. The prior
canonical census proves that their `36,432` marked keys contain every
necessary replacement witness in the certified q23 P-control corpus.
Projective invariance transfers the carrier counts across each orbit.

The small-order sweep exhausts all reachable normalized residual
states at q3/q5/q7, first without a selected-size cutoff and then with
residual selected size at least four. Its stop condition is the first
old-labelled half-move creating two genuinely new defects relative to
the ancestral label support, or exhaustion. Exhaustion occurred in
all six searches.

The certificate does not search q11+, prove exchange nonpacking for
all q, certify opponent-complete charged-survivor entry, or release an
abundance problem for C82.

## Reproduction

Working directory:

```text
/home/tavis/src/othello/rust
```

Commands:

```text
python3 scripts/c80_causal_nonpacking.py
python3 scripts/c80_causal_nonpacking.py --check
```

The primary small-order engine uses the established normalized
bitmask geometry. The independent implementation rebuilds row,
column, and affine-collinearity legality from determinants, recomputes
`Omega`, `B_small`, and `Def`, independently enumerates the reachable
states, and must agree on every aggregate and stop result. The q23
representatives are replayed by the direct determinant engine against
the earlier orbit certificates.

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_causal_nonpacking.py` | 21,904 | `268b8a839aa8308c1e3b48aa82c6c8bcc7b74d4b6778216830bcfd43ff00bffe` |
| `notes/2026-07-29-c80-causal-nonpacking.json` | 27,185 | `a56cbd94660e3d455536187f442174b7c563088c7e242b48b4b6f8ff0aff644c` |

The JSON is canonical sorted data. `--check` regenerates it in a
temporary directory and requires byte equality.

## `ej` + `tt` closeout

The cheap `ej` gain is the exact exchange identity. It proves the
conditional label theorem without pretending that old-certificate
secants are sparse. The q23 counts expose a previously hidden
phenomenon: Type II and III each have seven fully attacked fibres but
six immediate certificate repairs. The live combinatorial object is
therefore a certificate-exchange complex, not a set of isolated
killing secants.

The Tao-style formulation separates three ranks:

```text
old certificates attacked,
attacked fibres repaired,
uncompensated fibres created.
```

Only the third rank controls label branching. The next high-EV theorem
is not “one half-move meets one certificate secant.” It is a
field-uniform exchange or matching lemma showing that all but at most
one fully attacked fibre acquire a replacement `B_small` certificate,
with the strict-support deletion surplus proved separately. This
formulation is projective, fixed-depth, and nonrecursive.

The additional closeout compression is that q23 Types II and III are
one local exchange and two ancestry gauges. The exchange theorem
should therefore be stated on the unmarked sequential state; only the
label-transport corollary should restore the marked history. Carrying
the orbit distinction into the local repair lemma would encode
irrelevant provenance.

No incidental discovery-track item arose.

## Mystery ledger

- **[SETTLED negative] Does one causal half-move attack at most one old
  certificate fibre in the q23 replacement corpus?** No. The three
  packing numbers are `3,7,7`.
- **[SETTLED] What is the correct injectivity hypothesis?** At most one
  fully attacked fibre remains uncompensated after newly emergent
  certificates are allowed.
- **[SETTLED] Does that condition prove causal-label injectivity?** Yes,
  by the exact defect-exchange identity and the fact that the selected
  causal label cannot belong to a retained defect.
- **[SETTLED finite] Does one-to-many ancestral replacement occur in
  the certified q23 corpus or the complete q3/q5/q7 raw domains?** No.
- **[SETTLED] Why do Types II and III have identical `7→6→1`
  carrier counts?** They are the exact same sequential state and
  causal move; only their marked ancestry histories differ.
- **[OPEN — C80] Why should all but at most one attacked fibre be
  repaired over arbitrary odd fields?** No field-uniform
  certificate-exchange or matching theorem is proved.
- **[OPEN — C80] Does the deletion surplus needed for strict ancestral
  support descent hold together with exchange nonpacking?** It holds
  in the finite q23 witnesses, not uniformly.
- **[OPEN — C80/C82 gate] Is the resulting charged survivor entered
  opponent-completely from every escape root?** Not proved.

## Vibe

This is a real conceptual advance but not the crown. Injectivity now
has a correct theorem and q23 audit; the naive secant-sparsity picture
is decisively false. The live problem is sharper: prove immediate
certificate exchange repairs every attacked fibre except one, while
preserving a strict ancestral-label surplus.

go C80 cap prove the uniform certificate-exchange repair lemma and strict-support surplus, or extract the first uncompensated one-to-many replacement
