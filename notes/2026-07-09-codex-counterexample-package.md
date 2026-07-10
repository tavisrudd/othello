# C47 report: minimal-counterexample constraint package

Date: 2026-07-09.

## Result

C47 is complete.  The self-contained, D1-ready theorem package is:

```text
notes/2026-07-09-minimal-counterexample-constraints.md
```

The durable conclusions are:

1. `[LEAN]` excludes q in `{5,7,11,13}`.
2. `[COMPUTED]` puts the current frontier at `q >= 25`, with q=9,17,19,23 kept at their exact
   non-Lean trust tiers.  C30's q=17/19 books are rules-checked but have not elaborated in Lean;
   q=23 still awaits C54 bucket-label certification.
3. `[LEAN + PROVEN-PROSE]` any counterexample contains a trapped size-3 class with `onP=0`,
   `onN=q-4`: total on-conic P-value depletion.
4. `[COMPUTED NEGATIVE]` C42 supplies no census-propagation constraint.  The conditional row is
   retained only as a hypothetical implication, not as evidence.
5. `[PROVEN-PROSE]` C46 subsequently landed and the package now includes its full ladder
   `live_on >= max(0,q-(t^2+5t+5))` and inverse depth `T(q)`.
6. `[PROVEN-PROSE]` every play terminates in a complete arc and therefore has length at least
   `floor(b2(q))+1 = Omega(sqrt(q))`, with a direct secant-cover proof and the verified
   Alabdullah--Hirschfeld reference.
7. `[PROVEN-PROSE + citation]` C59 now bounds the other end of the terminal band: every terminal
   is the full conic or is at most the exact applicable Ball--Lavrauw/Voloch integer bound `B(q)`.
8. The appendix defines `dep(q)` explicitly as worst-class on-conic depletion and tabulates it
   with the partial steering statistic `Z(q)`, `mu_on(q)`, and `N_canon(q)`.  No OEIS submission
   was made.

## Scope decisions

- At initial publication C45/C46 were unavailable.  C46 subsequently landed and its proved-prose
  ladder has been incorporated; C45 remains unavailable and no result from it is assumed.
- No solve, certificate generation, Lean build, or memo traversal was run.  This kept C47
  independent of the active C30 certificate-build load.
- The q=23 appendix row uses C29's all-P bucket result plus C53's full-PGL bridge.  It is explicitly
  not represented as a completed q=23 feat census or a rules-checked certificate.
- `Z(q)` is labeled as a corpus maximum, not promoted to a q-only mathematical invariant.

## Primary-source check

The game-length row cites S. Alabdullah and J. W. P. Hirschfeld,
*A new lower bound for the smallest complete (k,n)-arc in PG(2,q)*,
Designs, Codes and Cryptography 87 (2019), 679--683,
[DOI 10.1007/s10623-018-00592-8](https://doi.org/10.1007/s10623-018-00592-8).
Its Theorem 2.1 gives the general `(k,n)` lower bound.  Setting `n=2` gives the `b2(q)` formula in
the package.  The package also derives the specialization directly by covering every outside point
with one of the cap's secants.

## Lightweight data check

Command (read-only arithmetic and parsing of the seven existing feat files):

```bash
awk 'BEGIN { split("3 5 7 9 11 13 17 19 23 25 27 29 31",a," "); print "q b2 lower"; for(i in a){q=a[i]; b=(q-3+sqrt((q-3)^2+8*(q-1)*(q*q+q+1)))/(2*(q-1)); printf "%d %.9f %d\n",q,b,int(b)+1 }}' | sort -n
for f in ../notes/data/codex-feat5.out ../notes/data/codex-feat7.out ../notes/data/codex-feat9.out ../notes/data/codex-feat11-c15.out ../notes/data/codex-feat13-c15.out ../notes/data/codex-feat17.out ../notes/data/codex-feat19-c15.out; do awk '/^CLS /{q=$2; sub("q=", "", q); n++; for(i=1;i<=NF;i++){if($i~/^onP=/){split($i,a,"="); s+=a[2]; if(n==1||a[2]<mn)mn=a[2]; if(n==1||a[2]>mx)mx=a[2]}}} END{printf "q=%s N=%d sum_onP=%d mu=%.9f min=%d max=%d dep=%d\n",q,n,s,s/n,mn,mx,q-4-mn}' "$f"; done
```

Output:

```text
q b2 lower
3 3.605551275 4
5 4.194933460 5
7 4.704959016 5
9 5.159414802 6
11 5.573006863 6
13 5.955042883 6
17 6.647685686 7
19 6.966013596 7
23 7.559426794 8
25 7.838039929 8
27 8.106392089 9
29 8.365541750 9
31 8.616376955 9
q=5 N=1 sum_onP=1 mu=1.000000000 min=1 max=1 dep=0
q=7 N=3 sum_onP=9 mu=3.000000000 min=3 max=3 dep=0
q=9 N=5 sum_onP=25 mu=5.000000000 min=5 max=5 dep=0
q=11 N=8 sum_onP=34 mu=4.250000000 min=2 max=5 dep=5
q=13 N=12 sum_onP=108 mu=9.000000000 min=9 max=9 dep=0
q=17 N=21 sum_onP=57 mu=2.714285714 min=1 max=3 dep=12
q=19 N=27 sum_onP=405 mu=15.000000000 min=15 max=15 dep=0
```

The q=23 values (`N_canon=40`, `mu_on=19`, `dep=0`) were cross-read from the C21 class-count
report and the C29/C53 all-P bucket coverage, rather than manufactured by the feat parser.

## Files changed

```text
notes/2026-07-09-minimal-counterexample-constraints.md
notes/2026-07-09-codex-counterexample-package.md
notes/2026-07-07-codex-task-queue.md   (C47 marked reported)
```
