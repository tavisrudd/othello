# C80 — two-mechanism causal-charge falsifier

**Lane:** `cap`. **Task:** C80. **Date:** 2026-07-28.
Canonical status: `2026-07-25-c80-status-ledger.md`.

## Verdict

The proposed field-uniform two-mechanism causal-charge update is false
already on its canonical q23 Type-I representative.

For the rank-27 target

```text
T = {
  (0,0), (1,1), (2,12), (3,8),
  (4,6), (7,5), (8,4), (13,7)
}
```

the causal opponent `x=(12,15)` creates the replacement defect
`z=(21,17)`. Before `x`, the unique `B_small` certificate for `z` is

```text
z -> r=(5,13),
Legal(T+z+r) = {w=(17,19), q=(22,9)}.
```

The earlier reports classified this as endpoint degradation: `r` was
said to survive while `q` was killed. Exact replay shows instead that
`x` kills both `r` and `q`:

```text
(8,4), x, r are collinear;
(4,6), x, q are collinear;
x is compatible with w.
```

Thus `r` is not a legal reply after `T+x+z`. The displayed
`T+x+z+r` mask in the predecessor certificate is not a valid cap; its
one-point “legal locus” cannot certify survival of `r`.

The actual local failure is simultaneous certificate-reply deletion
and boundary-endpoint deletion. It belongs to neither reported pure
case:

1. endpoint degradation with the certificate reply surviving;
2. certificate-reply deletion with both endpoints surviving.

This is the requested first field/order falsifier. The finite
ancestral charge on this edge remains injective—one old defect label
is transported to one replacement—but the claimed two-mechanism
classification cannot support a uniform proof.

## Uniform correction

There is a simple field-independent certificate-loss lemma.

Let `S` be a legal state, let `z` be legal, and suppose `r` certifies
`B_small(S+z+r)`. Let `h` be a later move compatible with `S+z`.

- If `r` is not legal after `S+z+h`, the certificate reply is deleted.
  Its boundary endpoints may independently be deleted as well.
- If `r` remains legal, then `h` is legal in `S+z+r`, since legality
  of the four-point union is order-independent. A terminal
  `B_small` boundary is therefore impossible. In the two-move case
  `Legal(S+z+r)={a,b}`, so `h` must equal `a` or `b`. The other
  endpoint remains legal because `a,b` are mutually legal. The former
  boundary becomes a singleton.

Consequently the genuine dichotomy is:

```text
certificate-reply deletion
  (possibly accompanied by endpoint deletion),

or

literal consumption of one of the two boundary endpoints.
```

An external move cannot preserve the certificate reply while killing
a different boundary endpoint. That purported Type-I mechanism is
not merely unproved; it is impossible. The q23 representative falls
under certificate-reply deletion with one simultaneous endpoint
deletion. Types II and III remain certificate-reply deletion with
both endpoints surviving. No certified q23 orbit currently exhibits
the endpoint-consumption case.

This corrected local lemma does not prove injective ancestry. A
single causal move can in principle delete several certificate
replies on different selected secants, so uniqueness of each former
certificate alone does not imply that at most one replacement defect
is created.

## Reproduction and trust boundary

Working directory:

```text
/home/tavis/src/othello/rust
```

Commands:

```text
python3 scripts/c80_q23_two_mechanism_falsifier.py
python3 scripts/c80_q23_two_mechanism_falsifier.py --check
```

The script replays the exact Type-I representative through both
engines already present in
`scripts/c80_q23_replacement_lineage.py`: the normalized bitmask
engine and the independent affine-determinant reference. It also
extracts the two distinct selected secants that delete `r` and `q`.
The engines agree on the complete legal locus after `T+x+z`, the old
and new defect sets, and the incompatibility of `r`.

| artifact | bytes | SHA-256 |
| --- | ---: | --- |
| `rust/scripts/c80_q23_two_mechanism_falsifier.py` | 7,496 | `8da9c9792c69cd6714521a79cc3d9a2f08a52e1c9b5e05f57783127f6565c090` |
| `notes/2026-07-28-c80-two-mechanism-falsifier.json` | 2,505 | `4bf4096dbb8f8b138dc82b0fc34df77925e6b04cb0ae69ce242f9877561fb0a3` |

The certificate proves the stated q23 counterexample and audits the
predecessor Type-I interpretation. It does not search another field,
disprove injective ancestry itself, or test opponent-complete entry
into a corrected charged survivor.

## `ej` + `tt` closeout

The cheap `ej` gain is the uniform correction above. It replaces a
false three-point secant story with an elementary order-independence
lemma and shows that the three finite q23 orbits currently realize
one certificate-deletion mechanism with two endpoint side effects,
not two exclusive mechanisms.

The Tao-style correction is to separate two questions that the prior
taxonomy conflated:

```text
why a former B_small certificate disappears;
why distinct new defects receive distinct consumed old labels.
```

Certificate disappearance is now classified uniformly. Injectivity
does not follow from it: a half-move may lie on several
certificate-reply secants. The next proof must either add a structural
hypothesis that makes those secants unique in the charged survivor,
or exhibit the first one-to-many creation event. No more q23 orbit
enumeration is needed merely to repair the terminology.

No incidental discovery-track item arose.

## Mystery ledger

- **[SETTLED negative] Is the reported Type-I certificate reply
  preserved?** No. It is killed on the selected secant through
  `(8,4)`.
- **[SETTLED negative] Do the two reported pure mechanisms exhaust
  the q23 corpus?** No. The Type-I representative deletes both the
  certificate reply and one boundary endpoint.
- **[SETTLED] What is the correct field-uniform local
  classification?** Certificate-reply deletion, possibly with endpoint
  side effects, or literal consumption of a two-point boundary
  endpoint.
- **[SETTLED] Does this invalidate the finite ancestral label on the
  representative?** No. Its one-to-one support drop remains valid.
- **[OPEN — C80] What structural condition prevents one causal
  half-move from deleting several unique certificate replies and
  creating several replacements?** Neither certificate uniqueness nor
  the corrected local dichotomy supplies injectivity.
- **[OPEN — C80/C82 gate] Does a corrected injective charged survivor
  have opponent-complete uniform entry?** No such theorem is proved.

## Vibe

This is a sharp negative, but a useful one: the attempted uniform proof
found a semantic flaw in the flagship finite mechanism before it was
promoted. The local certificate-loss lemma is now clean; the real crown
has narrowed to causal injectivity rather than a false two-case
geometry.

go C80 cap prove causal-label injectivity under a nonpacked secant condition or extract the first one-to-many replacement
