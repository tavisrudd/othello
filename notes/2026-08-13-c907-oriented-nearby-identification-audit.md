# C907 audit: minimal oriented nearby identification

**Target:** the order-zero proper-support and intrinsic Seifert transport route.

**Verdict:** **The rank-four statement is formal after the local `j_!` Morse calculation; the literal directed `P^3` matrix still needs one pairing-level residual-excision theorem.** Proper `psi/phi` functoriality is necessary and, once that theorem is available, sufficient for transport. It does not supply the theorem by itself.

## What is already formal

Let `j:U -> X` be an actual-open compactification proper over the parameter and value disks, and let `p:X' -> X` be a proper modification over both coordinates which is the identity on `U`. For constructible coefficients `A`, functoriality gives canonical isomorphisms

\[
 Rp_*j'_!A\simeq j_!A,
 \qquad Rp_*Rj'_*A\simeq Rj_*A. \tag{1}
\]

They commute with the natural map `j_! -> Rj_*`, Verdier duality, and the nearby/vanishing-cycle and `can/var` transformations. Thus the complete pairing package is independent of the chosen proper modification. Applying this first to `phi_(L-u)` and then to `psi_delta` identifies the intrinsic value-cycle object with its calculation on the ratio model.

Consequently, the landed bad-image theorem plus the four local Morse calculations prove rank four for the intrinsic compact-support value-cycle group (with the usual proper-base-change identification). No common collar or common fan is required for that conclusion.

## What is not formal

The support calculation concerns the `j_!` value-cycle sheaf. Four rank-one local Morse groups do not determine their directed Seifert form. The latter also uses how those groups attach to the regular value fibre, namely the map `j_! -> Rj_*`, relative duality, `can/var`, and an ordered system of value paths.

This is a genuine logical distinction. A Hurwitz move of a distinguished path system preserves the proper family and all four local `A_1` germs, but mutates the ordered vanishing-cycle basis and its Seifert matrix. Changing the orientation of an individual thimble likewise changes off-diagonal signs. Complex orientation canonically orients the ambient complex manifold; it does not by itself select an oriented distinguished thimble basis. Thus neither local Morse triviality nor proper pushforward can force the displayed positive `P^3` matrix with its existing labels.

## Minimal sufficient theorem

The needed remaining assertion can be stated without a global Whitney collar. Call it the **oriented residual-excision theorem**.

Let `N` be a compact residual tube in the simultaneous ratio model containing the four sections and no other bounded critical point. After proper descent, the morphism of pairing diagrams

\[
 \left(\psi_\delta R\bar a_*j_!A
       \longrightarrow\psi_\delta R\bar a_*Rj_*A;\
       \operatorname{can},\operatorname{var}\right)
 \longrightarrow
 \left(\psi_\delta RL_{N!}A_{N\cap U}
       \longrightarrow\psi_\delta RL_{N*}A_{N\cap U};\
       \operatorname{can},\operatorname{var}\right) \tag{2}
\]

must be an isomorphism over the chosen value disk, compatibly with Poincare--Verdier duality. It is enough to prove this after value vanishing cycles for every `u` in that disk. A concrete sufficient version is that the exterior cone in (2) has zero `psi_delta phi_(L-u)` for **both** the compact and ordinary extensions, and that these vanishings are compatible with the natural `! -> *` map. The existing controlled-product argument for `j_!` is only half of this assertion; proper duality may supply the `Rj_*` half once the actual-boundary constructibility is written down.

In addition, at `delta=0` the residual pair in (2), including its compact/ordinary boundary map, must be identified with the oriented Lefschetz pair of

\[
 f_Q(y)+ZU,
 \qquad f_Q=y_1+y_2+y_3+Q/(y_1y_2y_3), \tag{3}
\]

not just with its four analytic critical germs. Fix a regular value, an ordered nonbraiding path star, the `can/var` convention, and orient the transverse `ZU` thimble to have self-Seifert value `+1`. Under these choices the standard central calculation gives the `P^3` matrix. Since the parameter disk is contractible and the four values stay distinct, (1) then transports that exact ordered matrix to nearby parameters.

## C907 consequence

The direct exterior model and the fibrewise table close the support and rank gate. They do not yet state (2), nor do they give a pairing-level excision from the intrinsic object to the full central Lefschetz pair (3). This is the sole concrete topology datum still needed for the internal order-zero `P^3` Stokes claim. Once it is proved, no additional global `can/var` calculation or common compactification is necessary: all subsequent transport is the formal functoriality in (1).
