# C733 — Paper III canonical orientation bridge

**Lane:** `clebsch`

**Opened:** 2026-07-31

**Status:** complete; relative marked theorem, global Stein-algebra repair,
ordinary and isolated aggregates, visual inspection, and fresh context-free
`GO` complete.

## Objective

Determine the strongest marking-independent theorem that carries a chosen
component of Hitchin's normalized incidence pullback to the conference source
and the degree-six Petersen/Gaunt sign.  Either prove that the sheet
canonically determines every auxiliary choice used by
([C,Z_C]_{\rm or}), or replace the current statement by an explicitly
relative marked theorem whose hypotheses contain those choices.

## Blocking question

The fixed isotropic plane supplies an unordered six-axis configuration.  The
current manuscript additionally uses:

- an ordering and representatives of the six axes;
- an orientation of the representative lattice;
- five plane-triple labels;
- a normalized linear lift of the projective Clebsch chart; and
- the primitive Petersen label map.

The golden exchanger checks compatibility at ([xyz]), but one fibre does not
prove that deck exchange canonically determines these data or that the result
is independent of them.  Assigning a deck-opposite source by convention is not
by itself a marking-independence theorem.

## Required disposition

Choose exactly one route from proved evidence:

1. **Canonical bridge:** define the intrinsic orientation torsor, classify the
   full ambiguity group of markings and lifts, and prove that the conference
   and Petersen signs descend equivariantly to it; or
2. **Relative marked theorem:** state the marking, lattice orientation, label
   identification, and lift normalization as explicit input, and remove every
   claim that the incidence sheet alone fixes them.

In either route, distinguish the fixed (U_t)-component from the varying
second incidence configuration and do not propagate a global marking from the
golden fibre by connectedness or local constancy without a defined algebraic
torsor and a monodromy proof.

## Disposition

Route 2 is complete.  The incidence sheet canonically selects only a
normalized component.  The ordered axis representatives, lattice orientation,
plane-triple labels, normalized chart lift, and compatible Petersen labels are
explicit inputs to a relative theorem.  Switching and coordinated relabelling
are equivariant, lattice-orientation reversal is proved irrelevant, and lift
normalization and cross-labelling remain visible hypotheses.  A companion
trace-splitting argument proves the global Stein algebra
\(\mathcal O\oplus\mathcal O(-3)\), \(z^2=5J_0\), so the unnormalized chart
factorization is also justified scheme-theoretically.

Full report: `notes/2026-07-31-c733-paper-iii-relative-orientation-bridge.md`.

## Acceptance gates

- theorem statement, source definition, and proof use exactly the same
  auxiliary data and equivalence relation;
- the action of axis switching, relabeling, lattice-orientation reversal,
  chart scaling, Galois conjugation, and deck exchange is complete;
- independence is proved for every choice called canonical, or the choice is
  retained visibly as a hypothesis;
- the claim/trust map is weakened or strengthened to the proved result;
- ordinary and isolated paper aggregates pass; and
- a fresh context-free referee returns `GO` with no canonicality blocker.

## Boundaries

C733 owns only the Paper III source bridge and its paper-owned trust surface.
It does not import outer-six, middle-exterior, Pfaffian/determinant,
Segre--Igusa, Cartan, physical, exceptional-parent, or lattice shadows from
the Golden paper.  It does not broaden the unspecified integral incidence
localization and does not add a global Hitchin-incidence claim to Lean.
