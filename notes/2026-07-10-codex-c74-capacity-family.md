# C74 — line-pencil capacity, the exact L(A) algebra, and the stabilizer barrier

**Date:** 2026-07-10  
**Round:** Codex odd-plane round 2  
**Inputs:** C73 max-incidence secants, round-1 fifteen-involution lemma, C70/C71 kill-set
incidence, committed q=11/17 data. No new q >= 23 solve was run.

## Verdict

**[PROVED]** C73's max-incidence line has a complete algebraic description. For a candidate
secant through frame point `F` and conic candidate `w`, send `(F,w)` to `(0,infinity)` and let
`U={u1,u2,u3,u4}` be the other four frame parameters. Put

```text
P2(U) = {ui*uj : i<j},       d(F,w) = |P2(U)|.
```

Then

```text
# legal S4 extensions on secant(F,w) = q - d(F,w),
4 <= d(F,w) <= 6.
```

Thus `L(A)` is exactly a minimizer of the pair-product collision count `d`. This is the
projective, field-uniform form of C73's used-line collision extremum.

**[PROVED]** The round-1 supply of fifteen pointed-pairing involutions decomposes locally as

```text
sum_(F,w) h(d(F,w)) = 15,
h(4)=3, h(5)=1, h(6)=0.
```

Consequently `L(A)` maximizes the local concentration of those fifteen certificates. Its tie
multiplicity is not accidental: if `H=Stab_PGL(2,q)(A)`, the `d=4` lines are in bijection with
the involutions of `H`. In odd characteristic their number is `0,1,3`, or `5`. If it is zero,
there are exactly fifteen tied `d=5` lines.

This explains all C73 tie patterns, including the two q=11 knife-edge rows: their five-set
stabilizer is `D10`, its five involutions give five tied full-reservoir lines, and all five
on-conic endpoints are N while each line still contains four off-conic P children.

**[PROVED / BLOCKED]** A natural Omega(q) family does exist: the legal off-conic centers on
`L(A)` form the explicit pencil

```text
tau_a(t)=a/t,      a in F_q^* \ P2(U),
```

of size `q-1-d`, plus the on-conic endpoint `w`. But it cannot inherit the round-1 stabilizer
capacity bound: every center whose involution stabilizes `A union {w}` lies in `P2(U)` and is
therefore an *illegal* center. The legal Omega(q) family and the six-set automorphism family are
disjoint. Closing C74 now requires a game-theoretic N-absorption bound for this one-intruder
pencil, not another stabilizer theorem.

**[PROVED]** More generally, every construction that counts nonidentity automorphisms of the
one-point completions of a fixed five-set has total supply `O(1)`, uniformly in q; a crude exact
bound is 838. Therefore no stabilizer-element family, including higher-order cyclic elements, can
meet C74's Omega(q) success gate. A growing family must use non-stabilizing incidences.

**[COMPUTED-EXACT, LABEL-BLIND]** There are exactly eight full-PGL five-set orbits at q=25, as
pre-registered before enumeration. Their complete fan-to-bucket matrix was computed without game
labels. Combining it with only the brief's already disclosed bucket labels `f_0=...=f_6=1`
gives row lower bounds

```text
(21, 9, 5, 9, 4, 4, 4, 0).
```

The sole unresolved row is

```text
(M_25 f)_7 = 6 f_10 + 3 f_14 + 6 f_16 + 6 f_17.
```

Hence q=25's minimum on-conic witness count cannot be 1 or 2. At the brief's 7/28 snapshot it is
already forced into the dichotomy

```text
min-witness(25) = 0        (ON is refuted),
or
min-witness(25) >= 3       (the 2 -> 1 trend rebounds).
```

The threatened row's three max-incidence lines all have on-conic endpoint in bucket 14. Thus its
strong ON form of `(L)` is exactly `f_14=P`; if bucket 14 is N but one of 10/16/17 is P, ON
survives while L's on-conic form fails, leaving L's off-conic ESC form as the decisive test.

**[COMPUTED-EXACT / q=25 LABEL-BLIND PREDICTION]** Whenever the known data has three or five tied
`d=4` maximum lines, those lines concur in one legal child, and that child is P in all ten tested
classes: q=11 `2/2`, q=13 `3/3`, q=19 `5/5`. At q=25, row 7's three maximum lines also concur,
at the legal off-conic point `(1:15:9)` in the Veronese model, with zero selected-frame chords
through it. Its value has not been read. The fixed prediction is that this common point is P. If
so, it supplies exactly the off-conic L escape needed even when bucket 14—or all four row-7
on-conic buckets—is N.

## 1. Exact line-pencil theorem

Let `C` be the conic, `A` a five-subset of `C`, `F in A`, and `w in C\A`. Let `ell=Fw`.
Conjugate by `PGL(2,q)` so `F=0`, `w=infinity`. Write the other four points of `A` as distinct
nonzero elements `U={u1,u2,u3,u4}`.

The `q-1` off-conic points on the secant `ell` are in bijection with the involutions

```text
tau_a(t)=a/t,    a in F_q^*.
```

The center `z_a` lies on the chord `ui uj` exactly when `tau_a(ui)=uj`, equivalently
`a=ui*uj`. Chords involving `F` meet `ell` only at `F`, not at an off-conic center. Since the
five points of `A` include the two burned directions, this chord test includes row, column, and
ordinary cap illegality. Therefore precisely `d=|P2(U)|` centers are illegal. The legal cells on
`ell` are the remaining `q-1-d` centers plus `w`, proving

```text
nlegal(F,w)=1+(q-1-d)=q-d.
```

Equal products cannot share an index: `ui*uj=ui*uk` would give `uj=uk`. Hence collisions occur
only between opposite edges of the `K4` on U, every product has multiplicity at most two, and
`d>=3`. Equality `d=3` would force all three opposite-edge equalities. Two of them imply, after
relabeling, `u3=-u2` and `u4=-u1`; the third would then force `u1^2=u2^2`, contradicting four
distinct points. Thus `d>=4`.

Moreover:

- `d=4` iff, after scaling, `U={r,-r,s,-s}` with `r != +/-s`. There are two repeated products.
- `d=5` iff exactly one opposite-edge product equality holds.
- `d=6` iff all six products are distinct.

This proof uses only division and `2 != 0`, so it applies to every odd prime power, including
GF(25).

## 2. The fifteen involutions are exactly the collision ledger

For fixed `(F,w)`:

- At `d=5`, the unique repeated product gives one involution swapping `F,w` and the two paired
  pairs of U. This is one pointed-pairing construction.
- At `d=4`, the two repeated products give two such fixed-point-free involutions. The map
  `t -> -t` fixes `F,w` and pairs `{r,-r}` and `{s,-s}`, giving the second-fixed-point fallback.
  Hence this line receives three constructions.
- At `d=6`, no pointed-pairing construction lands on the line.

The round-1 bijection with the fifteen choices of distinguished frame point and pairing proves

```text
sum h(d)=15,  h(4)=3, h(5)=1, h(6)=0.
```

This also supplies an independent conceptual proof of C73's selector: `L(A)` is the candidate
line receiving the largest local share of the invariant fifteen-unit supply.

## 3. Tie theorem

Let `H=Stab_PGL(2,q)(A)`.

Every involution `sigma in H`, acting on the odd five-set A, fixes a point `F in A`. A nonidentity
projectivity has at most two fixed points, so it fixes exactly one point of A; its second rational
fixed point `w` lies outside A, and the remaining four points occur in two transpositions. In
coordinates `(F,w)=(0,infinity)`, `sigma(t)=-t`, so the corresponding line has `d=4`.

Conversely, `d=4` gives `U={+/-r,+/-s}`, and `t -> -t` is an involution of H. These constructions
are inverse. Two distinct involutions of H cannot fix the same `F`: in affine coordinates their
product would be a nontrivial translation preserving the other four points, but every nontrivial
translation in odd characteristic has orbits of odd prime length on the affine line and cannot
preserve a four-set. Thus the involutions inject into A and there are at most five.

If H has even order it has an involution, and inverse-pairing of its non-involutive elements shows
the number of involutions is odd. Therefore it is `1`, `3`, or `5`; these are exactly the numbers
of tied `d=4` maximizers. If H has odd order, there is no `d=4` line and the fifteen-unit identity
forces exactly fifteen `d=5` maximizers.

Exact checks over every recorded class:

```text
q=11: min/tie  (4,1):6, (4,5):2
q=13:          (4,1):9, (4,3):3
q=17:          (4,1):21
q=19:          (4,1):12, (4,3):3, (4,5):2, (5,15):10
```

## 4. Why the stabilizer-capacity upgrade cannot grow

The legal line-center family has size `q-1-d`, but if `tau_a` stabilizes `A union {w}`, it must
pair the four points U among themselves. Therefore a occurs as at least two pair products and in
particular `a in P2(U)`. That center lies on a secant of two selected frame points and is illegal.
Conversely, repeated pair products are exactly the stabilizing centers on the line. Hence no legal
center is a six-set stabilizer.

There is also an absolute obstruction to replacing involutions by all automorphisms. For fixed A,
count pairs `(x,g)` with `x notin A`, nonidentity `g in PGL(2,q)`, and
`g(A union {x})=A union {x}`.

1. If `g(A)=A`, then `g(x)=x`. There are at most `|Stab(A)|-1 <= 5!-1` such g, each with at most
   two rational fixed points: at most 238 pairs.
2. Otherwise `g(A)=(A\{y}) union {x}` for unique `y in A`. Let `e in A` be the unique point sent
   to x. Choose `(e,y)` in 25 ways and a bijection `A\{e} -> A\{y}` in `4!` ways. A projectivity
   is determined by three point images, so each choice yields at most one g: at most 600 pairs.

Total: at most 838, independent of q. Thus any family whose weight is earned solely by being a
nontrivial automorphism of a one-point completion is O(1). C74 can grow only by counting
non-stabilizing centers, and those require a new game-value absorption theorem.

## 5. The sharpened L recursion target

The exact uniform target is now one-dimensional. Choose `(F,w)` minimizing `d`, normalize as
above, and put `B=P2(U)`. Prove

```text
IsP(A union {w})
or exists a in F_q^* \ B, IsP(A union {z_a}).
```

The second alternatives are one-intruder positions with involution `tau_a(t)=a/t`. Their conic
subgame is the matching from Lemma V after the exact deletion `tau_a(A)`, but it remains coupled
to the off-conic zone. This is strictly sharper than “some child on L is P”: the candidates,
forbidden parameters, matching, and initial kill-set are explicit. It is not yet proved; choosing
a by exact value would be circular.

The q=11 knife-edge is the mandatory base obstruction. Its endpoint is N on all five tied lines,
and each six-element legal-center pencil contains four P and two N off-conic children. Tangency
type alone does not separate them. Any proposed one-intruder lemma must reproduce that mixed
pattern rather than assume the endpoint or a fixed internal/external type is P.

## 6. Label-blind q=25 matrix and decision tree

The enumerator uses the project's field `F_5[u]/(u^2+3)` and checks

```text
|PGL(2,25)| = 15600,
# five-set orbits = 8,
# six-set orbits = 28.
```

The five-set orbit-size histogram is

```text
780:1, 2600:1, 7800:4, 15600:2
```

and sums to `C(26,5)=65780`. The six-set stabilizer histogram

```text
1:7, 2:12, 4:5, 6:3, 120:1
```

reproduces the committed fiber histogram `720:7, 360:12, 180:5, 120:3, 6:1` via
`fiber=720/|Stab|`. The q=11 and q=17 matrices and bucket ordering reproduce the earlier exact
enumerators, validating index alignment.

The eight rows are:

```text
R0 {0:20,1:1}
R1 {0:2,2:1,3:2,4:1,5:1,6:2,7:2,8:1,9:1,10:1,11:1,12:1,13:1,14:1,15:1,16:1,17:1}
R2 {0:2,2:1,3:1,6:1,7:1,9:1,10:1,12:1,15:1,16:1,17:1,18:1,19:1,20:3,21:1,22:1,23:1,24:1}
R3 {0:2,3:2,4:1,5:2,6:2,13:2,18:2,20:2,21:2,24:2,25:2}
R4 {2:2,5:2,8:2,9:2,10:2,11:2,13:2,16:2,21:4,25:1}
R5 {3:2,6:2,8:2,10:4,12:2,19:1,20:2,21:2,24:2,26:2}
R6 {3:2,6:2,11:2,15:2,16:4,18:2,20:2,21:2,22:1,27:2}
R7 {10:6,14:3,16:6,17:6}
```

At the brief's disclosed `f_0=...=f_6=1`, rows 0--6 have lower bounds
`21,9,5,9,4,4,4`; only R7 is uncovered. Its stabilizer has order six, and its complement splits
into orbits of sizes `6,3,6,6`, explaining the coefficients. The row's three L endpoints all
belong to bucket 14.

There is an additional value-blind ESC candidate. In every recorded tied `d=4` class, the three
or five maximum lines are concurrent at one legal point:

```text
q=11: 2/2 common points P
q=13: 3/3 common points P
q=19: 5/5 common points P
```

This was recognized after those labels were available and is therefore a post-hoc correlation at
q<=19, not a theorem. The q=25 geometry was then computed without labels. Row 0's five lines meet
at the already-known P conic endpoint `infinity`. Row 7's three lines meet at

```text
z = (1:15:9)
```

in the conic model `t -> (t^2:t:1)`. The point is off-conic and lies on none of the ten chords of
the five-frame, so it is a legal residual extension. **Pre-registered prediction:** this row-7
common point is P. This is the sharpest available out-of-sample test of L's ESC form and requires
no q=25 feat-wide selector computation.

This makes the q=25 branches exact:

- `f_10=f_14=f_16=f_17=N`: `(ON)` is refuted at R7. The primary L test becomes whether one of
  the legal off-conic pencil centers is P.
- `f_14=P`: R7 has at least three on-conic P witnesses and L's ON form passes there.
- `f_14=N` but one of `f_10,f_16,f_17=P`: ON survives with at least six witnesses, but L's
  on-conic form fails at R7. L's ESC form is then genuinely independent and decisive.

If q=25 is non-depleted, every on-conic endpoint is P and L cannot fail. Thus the nominal
`non-depleted / L-fails` cell of the 2x2 interpretation matrix is logically impossible.

## 7. Reproduction

```bash
cd rust

# Exact line-product theorem on all existing classes; asserts nlegal=q-d, d>=4,
# the d=4 +/- classification, and total involution supply 15 per class.
python3 scripts/c74_line_pencil.py 11 13 17 19

# Label-blind GF(25) orbit incidence and the disclosed-bucket lower bounds.
python3 scripts/c74_fan_orbits.py 25 --known-p 0,1,2,3,4,5,6

# Prime-field regression: reproduces the earlier q=11/q=17 M matrices.
python3 scripts/c74_fan_orbits.py 11 17

# Existing tied-line concurrence and the label-blind q=25 common point.
python3 scripts/c74_concurrence.py
```

Durable scripts:

- `rust/scripts/c74_line_pencil.py`
- `rust/scripts/c74_fan_orbits.py`
- `rust/scripts/c74_concurrence.py`

Both are pure enumeration/post-processing. Peak RSS is small; the q=25 run takes about nine
seconds and does not inspect game labels or touch the running census.

## 8. Scope and circularity audit

- `L(A)`, `d`, `P2(U)`, and the pencil are value-blind.
- The line theorem proves legality and candidate structure, not P-value.
- The sharpened recursion statement explicitly retains its game-value gap.
- Known q=25 labels are used only after the complete matrix and eight-orbit prediction were fixed.
- Unknown q=25 buckets remain unknown; absent labels are never assigned.
- Stabilizer-specialness is not resurrected: the legal Omega(q) family is proved non-stabilizing.
- No exact Grundy, remoteness, Z, or future-strategy coordinate enters a selector.
- All algebra is valid for odd prime powers; the GF(25) enumerator uses the project's exact field.
