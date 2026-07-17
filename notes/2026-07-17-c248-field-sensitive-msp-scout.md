# C248 field-sensitive monotone-span-program scout

**Lane:** `rp-next`
**Status:** COMPLETE — narrow theorem success, strong-separation kill. A complete linear repair port
is an exact monotone span program with one row per helper, and connected-port rigidity gives an
explicit additive-one field-sensitive lower bound for both flagships. The `AG(2,3)` and anharmonic
gadgets do not feed the known superlinear/exponential lifting theorems, so do not allocate the
proposed A/A+ succinctness paper.

## Decision

Retain one compact proposition: a connected repair port whose matroid is representable over `K` but
not `F` has optimal MSP size `n` over `K` and at least `n+1` over `F`, where `n` is its number of
helpers. This gives an infinite additive-one separation from the cubic and harmonic families.

Do not promote this to an asymptotic succinctness claim. The known strong field separations use a
growing rank matrix with a modular rectangle cover, or a growing family of contradictory formulas
with a characteristic-dependent Nullstellensatz-degree gap. A constant representability obstruction
does not supply either object.

## Exact port-to-MSP dictionary

Let a represented matroid have column vectors `(v_e)_{e in E}` over a field `K`, and distinguish a
target `x`. Its full repair function on the helpers is

```text
f_(M,x)(S) = 1  iff  v_x is in span_K {v_e : e in S}.
```

Use the helper vectors as the rows of a monotone span program, label the row `v_e` by variable `e`,
and take `v_x` as the target vector. The accepted sets are exactly the survivor sets that repair
`x`; the minterms are exactly `C - {x}` for circuits `C` containing `x`.

The MSP size is therefore the number of helper rows, **not the number of repair circuits**. For the
given scalar representation it is `|E|-1`. This corrects the motivating advisory's circuit-count
statement.

Conversely, an MSP may have several rows with the same variable label. Adjoin its target vector as
a dealer column and regard every program row as a separate helper column. The MSP is then a linear
repair port in which activating one variable makes its whole group of helper columns available.
Thus `mSP_K(f)` is the minimum total number of row-level helper coordinates among all grouped linear
port realizations of `f`. A scalar code port is the special case with one row in every group.

## One-row rigidity theorem

Write `mSP_F(f)` for minimum monotone-span-program row count over `F`.

> **Theorem (connected-port one-row barrier).** Let `M` be a connected `K`-representable matroid on
> `E`, let `x in E`, put `n=|E|-1`, and let `f=f_(M,x)`. Then
> `mSP_K(f)=n`. For every field `F` over which `M` is not representable,
> `mSP_F(f) >= n+1`.

Every helper is relevant because connectedness puts it in a circuit with `x`; hence every MSP needs
at least one row with each of the `n` labels. The given representation supplies exactly one, proving
the native equality.

If an `F`-MSP had exactly `n` rows, every label would occur exactly once. Adjoin its target vector.
A minimal accepted set is independent—otherwise one of its rows could be deleted without losing
the target—and hence is precisely a circuit through the target in the represented column matroid.
The MSP and `M` therefore have the same port. Every helper occurs in that port, so the new matroid is
connected. Lehman's port theorem says a connected matroid is uniquely determined by any one of its
ports. The new matroid must be `M`, contradicting nonrepresentability over `F`.

The theorem concerns the full port. A radius-truncated port can forget the circuits needed for
Lehman reconstruction, so the same conclusion does not follow for bounded repair without an
additional rigidity argument.

## Flagship instantiation

Let `q=3^h >= 9`.

- The completed cubic--axis matroid has `2q+2` coordinates and is connected, so every full target
  port has `n_cub=2q+1` helpers and native MSP size exactly `2q+1` over `GF(q)`.
- The quartic--nucleus harmonic matroid has `q+2` coordinates and is connected, so every full target
  port has `n_harm=q+1` helpers and native MSP size exactly `q+1` over `GF(q)`.

After contracting `A(infinity)` in the cubic family, or `{N,V(infinity)}` in the harmonic family,
the finite-curve triples on every two-dimensional `F_3`-subspace are the zero-sum lines of
`AG(2,3)`. Hence both flagship matroids have an `AG(2,3)` minor, and therefore an
`AG(2,3) - e` minor.

The foundation of `AG(2,3)-e` is the hexagonal/sixth-root-of-unity partial field. It is representable
over a field `F` exactly when `z^2-z+1=0` has a solution in `F`. Consequently, for every field
without such a solution,

```text
mSP_F(f_cub(q,x))  >= 2q+2,
mSP_F(f_harm(q,x)) >= q+2.
```

This includes finite fields of order congruent to `2 mod 3` and ordered fields. Characteristic
three is native; fields of other characteristics that contain a sixth root of unity, such as
`GF(4)` or the complex numbers, are not excluded by this minor.

The finite replay at `q=9` checks both contraction claims directly. Each contraction has exactly
the twelve zero-sum triples on nine points, every pair belongs to one such triple, and the small
circuit systems connect all 20 cubic and all 11 harmonic coordinates. The verifier and certificate
are [`2026-07-17-c248-field-sensitive-msp-scout.py`](2026-07-17-c248-field-sensitive-msp-scout.py)
and [`2026-07-17-c248-field-sensitive-msp-scout.json`](2026-07-17-c248-field-sensitive-msp-scout.json).

## Why the anharmonic gadget does not lift

C217's two four-point axis restrictions have the same support matroid `U(2,4)` and different
cross-ratio orbits. For any distinguished target, both compute the same two-of-three threshold
function. Since MSP complexity depends on the Boolean function and base field, not on which given
representation produced it, the cross-ratio distinction cannot change `mSP_F` at all.

The support matroid `U(2,4)` itself does give the one-row barrier over fields where it is not
representable, but that statement is independent of C217's holonomy values. The anharmonic pair is
a coefficient/MPC gadget, not an MSP-size gadget.

## Audit of the strong lower-bound imports

The mature field-separation results are real but do not transfer verbatim:

1. **Beimel--Weinreb.** Their separation theorem starts with a growing Boolean matrix `A_n` having
   both a small monochromatic `1 mod p` rectangle cover and high rank over wrong-characteristic
   fields. The cover gives an `n`-row MSP over `GF(p)`; `rank_F(A_n)` gives the wrong-field lower
   bound. An `AG(2,3)` minor supplies neither the matrix family nor the cover/rank gap.
2. **Pitassi--Robere.** Their lift starts with unsatisfiable CNFs `C_n` whose Nullstellensatz degree
   is small in one characteristic and linear in another, then composes the associated search
   relation with a separate “good” communication gadget satisfying a tensor-rank identity. The
   exponential characteristic separation uses the counting-principle formulas `MOD_n^p`.
   The local repair geometry is neither `C_n` nor their good gadget.
3. Plain block replication of a fixed access function has linear-size MSPs over every fixed field:
   first choose any constant MSP for the block over that field, then compose the copies with the
   same linear-size monotone formula. C216 preserves selected native repair relations inside larger
   codes, but it does not preserve an exact access function or amplify a lower-bound measure.

A genuine superlinear repair-port result would therefore need new work: construct a growing
flagship-derived access-function family and prove either a modular-cover/rank gap, a
characteristic-dependent linear-rank inequality with growing total-row consequence, or a
Nullstellensatz encoding with a growing degree gap. None is presently supplied by the
`AG(2,3)`/anharmonic gadgets.

## Literature boundary

The load-bearing sources were checked from the persistent cache:

- Karchmer--Wigderson, *On Span Programs*,
  [DOI 10.1109/SCT.1993.336536](https://doi.org/10.1109/SCT.1993.336536), cache SHA-256
  `24a99a09dd862488f8466b471543eb2bb04051e857bcc3d963f9f6d3658156b7`: MSP size is the number
  of matrix rows.
- Beimel--Weinreb, *Separating the Power of Monotone Span Programs over Different Fields*,
  [DOI 10.1137/S0097539704444038](https://doi.org/10.1137/S0097539704444038), cache SHA-256
  `c018eef97cf4376a5ac5e31b652bedae6969e91dfa836bc83be969b9b879f771`: Theorem 3.4 is the
  modular-cover/rank separation described above.
- Pitassi--Robere, *Lifting Nullstellensatz to Monotone Span Programs over Any Field*,
  [DOI 10.1145/3188745.3188911](https://doi.org/10.1145/3188745.3188911), cache SHA-256
  `021621499e6d0b2b8c657911fe8701c62356af192a4ea02a9276e9ff495a27b6`: Theorem 1.1 gives the
  degree lift and Theorem 7.3 the exponential characteristic separation.
- Martí-Farré--Padró--Vázquez, *On the Diameter of Matroid Ports*,
  [DOI 10.37236/902](https://doi.org/10.37236/902), cache SHA-256
  `59138f289babf3a327410ee98e36c1848f4f4c540c3e907e688441326f346ca2`: Theorem 2 states
  Lehman's unique connected-matroid reconstruction from one port.
- Baker--Lorscheid--Zhang, *Foundations of Matroids, Part 2*,
  [arXiv:2310.19952](https://arxiv.org/abs/2310.19952), cache SHA-256
  `13d55a34b9010502b817ab68736137b178d7f607d9999391e20a55dc0ddd03c2`: Appendix A.3.3 identifies
  the foundation and field condition of `AG(2,3)-e`.

## Disposition

C248 passes only its narrow theorem gate. The exact dictionary and one-row barrier are worth a
proposition or remark in the integrated repair-port paper. They do not support a stand-alone
field-sensitive succinctness paper, a superlinear lower bound, or an A/A+ complexity claim.

Close the lifting route unless a future task supplies a growing lower-bound object before invoking
the flagship geometry. Do not infer MSP-size hardness from characteristic obstruction,
non-equivalent coefficient realizations, or C216 replication alone.
