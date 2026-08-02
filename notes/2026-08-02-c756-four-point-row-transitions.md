# C756 — four-point row-transition profile

**Lane**: clebsch · **Date**: 2026-08-02 · **Scope**: saturated-internal,
bounded Route-Q discriminator

## Verdict

The declared four-point diagnostic closes negatively as a new proof mechanism.
The two (p=5) frames are the only complete row-permutation systems in the
prime-field candidate audit, and all (24) of their ordered transitions are
Möbius of rational degree one.  But that separation occurs already at the old
angle-bijection/first-moment gate: every one of the (167) negative candidates
has at most one bijective angle row, so none supplies even one complete
transition between two torus charts.

The partial relations show why there is no hidden bounded-degree repair.  Among
the functional partial transitions, the least rational degree reaches
(3,5,9,11,15,21) at (p=7,11,19,23,31,43), respectively.  The last three
values are the full interpolation scale ((p-1)/2).  Every canonical pole
divisor misses the entire norm-one torus, so poles do not impose a residual
torus constraint.  The only nonvacuous four-point comparisons in the negative
data are (252) comparisons at (p=11), and all preserve cross-ratio; they
occur on small injective partial relations already interpolated by Möbius maps.
Thus cross-ratio defect adds no separation beyond row collapse, while the
radial coordinate remains unconstrained at linear rational degree.  This
triggers Route Q's stop gate.

## Exact transition convention

For rows (i\ne\ell), complete the common-label correspondence by

\[
 \alpha_{ij}\longmapsto\alpha_{\ell j}\quad(j\ne i,\ell),
 \qquad
 \alpha_{i\ell}\longmapsto\alpha_{\ell i}.
\]

If both rows are angle bijections, this is exactly the chart transition

\[
 \rho_\ell\,(i\ \ell)\,\rho_i^{-1}:\Omega\longrightarrow\Omega,
 \qquad
 \Omega=\{x\in\mathbf F_{p^2}:x^{(p+1)/2}=-1\}.
\]

For a general pairwise-character candidate the labelled relation can instead
be nonfunctional, functional but noninjective, or an injective partial map.
The checker retains those cases separately rather than pretending that the
negative rows are torus bijections.

For each functional relation, the least rational degree is

\[
 \min\max(\deg P,\deg Q),
 \qquad P(x_r)=y_rQ(x_r),\quad Q(x_r)\ne0.
\]

Exact row reduction finds the first degree with a valid denominator.  When the
interpolant is not unique, a deterministic nullspace basis and pole-avoidance
rule select one reduced (P/Q); the JSON records a SHA-256 digest of every
ordered canonical denominator stream.  Direct evaluation checks every selected
interpolant.  Independently, a rank test on
((1,x,-y,-xy)) agrees exactly with the cross-ratio test at the Möbius
boundary.

## Bounded profile

The angle-row column gives the number of candidates by number of bijective
rows.  `fun/total` counts functional labelled relations among all ordered row
pairs.  No negative field has a complete permutation transition.

| (p) | candidates | bijective angle rows | fun/total | least rational degrees of functional relations |
|---:|---:|---:|---:|---|
| 5 | 2 | (4:2) | (24/24) | (1^{24}) |
| 7 | 5 | (1:5) | (80/100) | (1^{60},3^{20}) |
| 11 | 28 | (0:21,1:7) | (630/1176) | (1^{462},3^{126},5^{42}) |
| 19 | 55 | (1:55) | (1540/6050) | (1^{990},5^{440},9^{110}) |
| 23 | 39 | (0:26,1:13) | (1872/6084) | (1^{1716},11^{156}) |
| 31 | 17 | (1:17) | (4352/4624) | (1^{4080},15^{272}) |
| 43 | 23 | (1:23) | (11132/11638) | (1^{10626},21^{506}) |

The canonical denominator degrees are

| (p) | pole-divisor degree profile | norm-one torus poles |
|---:|---|---:|
| 5 | (0^{16},1^8) | 0 |
| 7 | (0^{80}) | 0 |
| 11 | (0^{422},1^{208}) | 0 |
| 19 | (0^{1100},4^{440}) | 0 |
| 23 | (0^{1872}) | 0 |
| 31 | (0^{4352}) | 0 |
| 43 | (0^{11132}) | 0 |

At (p=31,43), the unique bijective row of every negative candidate maps to
each other row by a degree-((p-1)/2) polynomial; the reverse labelled relation
is nonfunctional.  This is the cleanest exact witness that the unused radial
choice has survived intact rather than collapsing to bounded torus geometry.

The (p=5) cross-ratio count itself is vacuous because the odd coset has only
three elements.  Its meaningful statement is that every completed transition
is a permutation of those three elements, hence has a unique Möbius extension.
In the negative data, injective functional fragments have at most three values
except at (p=11); the (252) four-point comparisons there all have zero
defect.  A raw cross-ratio mismatch count on repeated values would therefore
measure only row collisions, not four-point rigidity.

## Conditional structural payoff

The profile exposes a useful conditional theorem.  Suppose a prime-field
simultaneous angle system has all row bijections and every completed transition
and its reverse has rational degree at most (d).  If

\[
 (p+1)/2>d^2+1,
\]

then the two opposite transitions compose to the identity at more points than
the degree of their rational difference.  They are global rational inverses,
so both have degree one.  Loops of chart changes then realize faithfully the
full symmetric group on the ((p+1)/2) labels remaining after one chart is
fixed: a transposition ((a\ b)) is the loop
((i\ a)(a\ b)(b\ i)).

For (p\ge11), this would embed (S_{(p+1)/2}) in
\(\operatorname{PGL}_2(\overline{\mathbf F}_p)\).  Its order is prime to (p),
while the tame finite subgroups of 
\(\operatorname{PGL}_2\) are cyclic, dihedral, (A_4,S_4,A_5); hence such an
embedding is impossible once ((p+1)/2\ge6).  Thus a genuinely uniform
bounded-degree lemma would close every prime (p\ge11) at once.  The diagnostic
does not supply that lemma: its negative controls instead attain linear degree,
and no negative candidate reaches the complete-chart hypothesis.

## Trust and replay

Run from the repository root:

```sh
python3 notes/2026-08-02-c756-four-point-row-transitions.py --check
sha256sum notes/2026-08-02-c756-four-point-row-transitions.{py,json}
```

The deterministic scope is every ordered labelled row relation of all (169)
normalized pairwise-character candidates over
(p\in\{5,7,11,19,23,31,43\}).  The checker independently reconstructs the
odd norm-one coset in each field, checks every angle-row image, verifies every
reported rational interpolant pointwise, and compares the Möbius interpolation
rank with cross-ratio preservation.  It certifies only this finite normalized
domain and the exact interpolation convention above.  It does not prove that a
hypothetical simultaneous angle system has bounded-degree transitions, nor does
it address extension fields.

| artifact | bytes | SHA-256 |
|---|---:|---|
| `notes/2026-08-02-c756-four-point-row-transitions.py` | 18,846 | `2cbc5d1c02266c439a811f7f2d8609746a640c602b039f0b7932cd7e062e36a8` |
| `notes/2026-08-02-c756-four-point-row-transitions.json` | 194,550 | `e68aa6480fe0a2dcf521a0427dc39814daf8cdb3148a714b2ff420b13e2fba96` |
| input `notes/2026-08-02-c756-prime-field-lacunary-first-cofactor.py` | 10,964 | `4fc33a8730c287319fcb8ab151aef72f2bcd1470a5f5c67a4b4b9b0aa65faf64` |
| input `notes/2026-08-01-c756-probability-cheap-tests.py` | 20,904 | `34fe706268e51f4ed09a95ec64424430e11f46d9e03fae320ca16eac0580fff2` |
| input `notes/2026-08-01-c756-saturated-internal-audit.json` | 3,842 | `acabee2fa04d61e6673c60a5cc429ba11f9e294e233a96c53d8451d91f6104d7` |

## EJ + TT closeout

**EJ.**  The free upgrade was to retain the full relation trichotomy instead of
discarding nonbijective rows.  It identifies the exact source of the apparent
high degree: the unique bijective row at (p=31,43) gives a full-domain
polynomial of degree ((p-1)/2) toward every other row, while the reverse
relation is nonfunctional.  The denominator census separately rules out a
hidden pole constraint on the norm-one torus.

**TT.**  The cheap structural upgrade is the symmetric-group obstruction above.
It shows that bounded degree would be far stronger than a numerical profile:
for large prime fields, opposite transitions would become birational, the chart
groupoid would become a projective (S_{(p+1)/2})-action, and tame subgroup
classification would finish.  What is missing is exactly the bounded-degree
input.  The finite controls cannot test it under full binomiality because only
the positive frames have all rows bijective.

## Mystery ledger

| mystery | status | exact gap / owner |
|---|---|---|
| Are the (p=5) transitions genuinely four-point exceptional? | settled negatively | their torus has three values, so Möbius extension is automatic and the four-point count is vacuous |
| Do negative pairwise candidates carry complete bounded-degree transitions? | settled negatively on the audited domain | every negative candidate has at most one bijective row; no complete negative transition exists |
| Do partial transitions have bounded rational degree? | settled negatively on the declared gate | least degree reaches (15,21=(p-1)/2) at (p=31,43) |
| Does the pole divisor constrain the torus? | settled negatively on the declared gate | every selected denominator has zero norm-one roots; most are constant |
| Does cross-ratio defect add a new finite separator? | settled negatively | the only (252) nonvacuous negative comparisons all have defect zero |
| What would make the route theorem-producing? | settled conditionally | a uniform degree bound (d) with ((p+1)/2>d^2+1) forces Möbius transitions and then an impossible tame (S_{(p+1)/2})-action |
| What is the next saturated-internal attack? | open under C756 | Route F: profile sparse integral Paley trades by Fourier values, valuations, and short autocorrelations; stop on any second-moment surrogate |
