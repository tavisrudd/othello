# C834 — the shared q=13 passant-code library is free of native evaluation

**Date:** 2026-08-04

## What changed

The two replacements described at the end of
`notes/2026-08-03-c834-weight-eight-kernel-closure.md` are now elaborated in place, and the axiom
audit of the Paper IV gate reports no native-evaluation axiom for any terminal. No source file under
`lean/RelativeConicArcs/PassantCodeQ13/` contains `native_decide`.

`RelativeConicArcs.PassantCodeQ13.PencilJoins` gains the nodup fact for the displayed secant list
and the two rewriting lemmas `prod_secantLine` and `prod_guarded_eq_prod_pencil`, which turn a
product indexed by the secant-line subtype into a product over the displayed coordinate list and
then discard the lines outside a point's pencil.

`RelativeConicArcs.PassantCodeQ13.WeightEight` uses them for
`tangentProduct_eq_pencilEvaluationProduct`, which rewrites the tangent product of a point as the
evaluation product over that point's seven-member secant pencil. With the vertex triples and both
pencil families read from precomputed lists, `adjacent_iff_tangentCompatibleAtBase` becomes one
kernel reduction over the 1,764 ordered vertex pairs followed by a symbolic bridge to the semantic
distinctness, passant-join, and tangent-holonomy conditions. `fourCliqueSets_complete` is now proved
rather than computed, from the general lemma that a finite set of size `n` inside a duplicate-free
list is the member set of one of that list's sublists of length `n`.

## Evidence

Both builds ran through the guarded unattended queue on the `single` profile with one thread on
cores 20–23.

```sh
lean/scripts/lean-build-queue.py run RelativeConicArcs.PassantCodeQ13.WeightEight \
  --profile single --threads 1 --cores 20-23
lean/scripts/lean-build-queue.py run \
  RelativeConicArcs.Gates.PassantCodeQ13 RelativeConicArcs.Gates.PassantCodeQ13AxiomAudit \
  --profile single --threads 1 --cores 20-23
```

`RelativeConicArcs.PassantCodeQ13.WeightEight` elaborates in 4 minutes 12 seconds at a measured peak
of 10,865,992 kB, which is why the module stays on the strictly serial profile. The gate and its
audit build in 17 and 4 seconds. All 23 `#print axioms` terminals of
`RelativeConicArcs.Gates.PassantCodeQ13AxiomAudit` report axiom sets contained in
`[propext, Classical.choice, Quot.sound]`; the previous run reported the two declaration-local
native-evaluation axioms of `WeightEight.adjacent_iff_tangentCompatibleAtBase` and
`WeightEight.fourCliqueSets_complete`, and neither appears now.

## Method note

The rewrite by `prod_secantLine` must supply the factor function explicitly. Its left side is a
product indexed by the secant-line subtype whose body applies the factor function to `line.1`, so
the pattern is not a higher-order pattern and unification cannot infer the function from a body in
which the bound variable occurs twice under `Subtype.val`.

## What remains for the release theorem

The paper's own package under `papers/q13-passant-code/lean-certificates` is untouched and keeps its
own gate and axiom audit. Its sources still contain sixty-four native decisions across forty-five
modules: twenty-two in the minimum-word orbit enumeration, sixteen in the weight-ten profile
certificates, nine in the structural upgrade, eight in the association transport, six in the
automorphism anchors, and three in the association algebra.
