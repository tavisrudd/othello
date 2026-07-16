# C195–C196: exteriority versus prescribed-hole completeness

**Lane**: `relconic` — see `AGENTS.md` § Lane routing.

## Result

The `arcs_complete_outside_conic` manuscript now separates the two nearby conic conditions by
their ordinary-uncovered-locus containments:

\[
\text{complete exteriority}\Longrightarrow \mathcal C(\mathbb F_q)\subseteq U(A),
\qquad
\mathcal C\text{-completeness}\Longleftrightarrow U(A)\subseteq\mathcal C(\mathbb F_q).
\]

Hence an arc satisfying both conditions has `U(A)=C(F_q)`, but complete exteriority alone is not
enough. This is a definitional comparison, not a new theorem or classification claim.

## Strict q=7 foil

Blokhuis–Seress–Wilbrink's q=7 complete exterior four-arc has all six joins external to the
eight-point conic. For any four-arc, the six secants contain `6(q-1)` off-arc incidences and their
only repetitions are the three diagonal points, so

\[
|U(A)|=(q^2+q+1-4)-(6(q-1)-3)=(q-2)(q-3).
\]

At q=7 this gives `|U(A)|=20>8=|C(F_7)|`. Thus `C(F_7) ⊂ U(A)`, and this exterior four-arc is not
complete outside the prescribed conic. The q=11 Clebsch hexagon is exceptional because the reverse
inclusion also holds there, giving equality.

## Publication synchronization

The implication display and q=7 count were added to the manuscript introduction. The same
distinction is recorded in the paper README, proof/claim audit, and top-level paper index. The
rendered PDF was rebuilt successfully; the log contains no undefined references or citations.

