# C969 uniform R7 central adapter

## Structural contraction

In characteristic two, R6's recurring third-nucleus line is
`N_3=P<e2,e3>`. For an R7 syndrome `f=(s_0:...:s_6)`, the two consecutive
sextic polar rows both lie in that line exactly when

\[
 s_0=s_1=s_2=s_4=s_5=s_6=0.
\]

Projective normalization then forces `f=e3`. Thus the entire R6 nucleus line
contracts to one PGL-fixed central sextic nucleus point at R7. Recognition is
the exact coordinate equality `(0,0,0,1,0,0,0)` in the declared divided-power
convention; it is not an orbit-table heuristic.

## Arithmetic toggle

The central point has quintic Hankel web

\[
 W_{e_3}=\langle1,t,t^4,t^5\rangle.
\]

If `q=2^m` with odd `m`, a hypothetical split quintic could be contracted at
one of its roots to a split quartic on the deep R6 nucleus line, a
contradiction. If `m` is even, `F_4` is contained in the ground field and
`t^4+t` supplies its four affine roots plus infinity as a split binary
quintic. Hence the central point is split-free exactly for odd extension
degree.

The formula adapter emits family `r7.char2_central` and invariant
`r7.char2_central_nucleus:odd_extension_degree`. It checks characteristic,
extension parity, and exact central-point membership. The q=32 row may retain
frozen orbit evidence; higher odd binary extensions use the same formula
without growing the registry.

## Radius boundary

Formula recognition certifies the syndrome-side family only. The shared
theorem-domain check remains independent. No positive deep certificate is
emitted for this central family at q=7,9, where the radius remains open. At
q=8 exhaustive locator replay proves the central point has distance seven;
together with the separate diagonal tangent certificate this completes the
deep-hole extraction. From q=11 onward the R7 radius-six premise is available;
for the recurring central family the next case is q=32.

The all-field R7 theorem leaves no other recurring nonpersistent family:
outside the bounded q=7,8,9,11 certificate rows, the inventory is persistent
tangent/sigma plus this central point. The finite exception registry therefore
remains bounded rather than becoming a surrogate formula table.
