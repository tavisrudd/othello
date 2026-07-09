# C33 Report: Line-Capacity Follow-Up

Date: 2026-07-09

## Initial Plan

I read `2026-07-09-fable-line-capacity-review.md` before editing.  I accept its six corrections
as the working constraints for this pass.

Concrete sequence:

1. Correct the live-conic mining note:
   - remove/downgrade the reservoir -> Hall/matching target;
   - replace the "steer conic xor to zero, then solve the zone" phrasing with a maintenance
     strategy;
   - make the six-cell reservoir a base-layer move-availability fact, not a recursive engine;
   - restate the reservoir bound in the general `k`-cell and incidence/load form, with the
     Möbius/hyperbola graph hypothesis.
2. Correct the handoff:
   - remove the reservoir/Hall target from the q=23 recent-results bullet and Good Lean targets;
   - add the AG(2,q) blocking-set obstruction near residual-capacity decomposition;
   - scope "capacity-1 collapse" to local residual subboards only;
   - add the maintenance-strategy obligations: preservability and termination.
3. Update the live-conic steering plan where it implies a disjunctive conic-zone split.
4. Run a cheap existing-log check over the full q=23 `s4xormine` bucket logs:
   - do not launch a new solve;
   - verify the already-mined first-ply re-zeroing coverage and selected-witness support facts
     from `s4-dumps/2026-07-09/q23-zone2-all`;
   - record this as first-ply preservability evidence only, not as the deeper maintenance theorem.
5. Mark C33 reported in the task queue and add a dated handoff note.

No commit is made in this pass; project rules require asking before git-state changes.

## Corrections Applied

Files edited:

- `notes/2026-07-09-live-conic-bestreply-mining.md`
- `notes/2026-07-09-live-conic-steering-plan.md`
- `notes/handoffs/2026-07-06-projective-cap-game-handoff.md`

Corrections:

- Removed the positive "reservoir -> Hall/pairing certificate" target.  The notes now record the
  matching threshold calculation: the six-cell row bound gives min degree `q - 22` in a balanced
  `(q - 6) x (q - 6)` row/column graph, and the min-degree `>= n/2` matching lever only starts at
  `q >= 38`.
- Restated zero-xor steering as a maintenance invariant.  The notes now explicitly say an
  off-conic zone move is itself a conic intruder, so there is no disjunctive sum
  `conic_xor xor zone_value`; `conic_xor = 0` must be re-established after coupled moves.
- Named the two obligations: preservability, meaning a re-zeroing reply remains available, and
  termination, meaning the maintained invariant favours P2 at the end.
- Scoped the capacity-1 collapse claim.  The handoff now states that whole-board collapse is
  impossible in odd affine planes because a blocking set needs at least `2q - 1` points while an
  odd-q cap has at most `q + 1`.
- Restated the reservoir lemma as the general normalized `k`-cell bound
  `q - k - binom(k,2) - 1`, with the six-cell `q - 22` case as a base-layer move-availability
  fact.  The conic `-1` term is now tied explicitly to the residual Möbius/hyperbola graph form.
- Added the incidence/load formulation: legal cells on a target line are bounded below by target
  size minus saturated-line intersections and explicitly excluded structured cells.

## Existing-Log Check

No new q>=23 solves were launched.  I parsed the existing full q=23 all-bucket logs under
`rust/s4-dumps/2026-07-09/q23-zone2-all`.

Command:

```text
awk '
function val(name,   i,a){ for(i=1;i<=NF;i++){ split($i,a,"="); if(a[1]==name) return a[2]; } return "" }
BEGIN{minlive=999; minz=999; minzr=999; minzc=999; mintry=999; maxlive=-1; maxz=-1; maxzr=-1; maxzc=-1; maxtry=-1;}
/^XORMOVE /{moves++}
/^XORRESULT /{res++; if(val("status")=="hit") hits++; else otherres++; t=val("tried")+0; if(t<mintry)mintry=t; if(t>maxtry)maxtry=t; tried[t]++}
/^XORTRY /{tries++; v=val("value"); value[v]++; if(v=="P"){p++; live=val("live_on")+0; z=val("zone_v")+0; zr=val("zone_rows")+0; zc=val("zone_cols")+0; comp=val("zone_comp")+0; other=val("zone_other")+0; known=val("zone_nk_known")+0; cx=val("conic_nk_xor")+0; if(live<minlive)minlive=live; if(live>maxlive)maxlive=live; livehist[live]++; if(z<minz)minz=z; if(z>maxz)maxz=z; if(zr<minzr)minzr=zr; if(zr>maxzr)maxzr=zr; if(zc<minzc)minzc=zc; if(zc>maxzc)maxzc=zc; if(comp!=1) badcomp++; if(other!=1) badother++; if(known!=0) badknown++; if(cx!=0) badcx++; }}
END{print "files=" ARGC-1; print "moves=" moves " results=" res " hits=" hits " other_results=" otherres; print "tries=" tries " P=" value["P"] " N=" value["N"]; print "tried_minmax=" mintry ".." maxtry; printf "tries_hist="; for(i=1;i<=maxtry;i++) if(tried[i]) printf "%s%s:%d", (i==1?"":" "), i, tried[i]; print ""; print "selected_live_on=" minlive ".." maxlive; printf "selected_live_hist="; first=1; for(i=0;i<=maxlive;i++) if(livehist[i]){printf "%s%d:%d", (first?"":" "), i, livehist[i]; first=0;} print ""; print "selected_zone_v=" minz ".." maxz; print "selected_zone_rows=" minzr ".." maxzr " selected_zone_cols=" minzc ".." maxzc; print "selected_bad_comp=" badcomp+0 " bad_other=" badother+0 " bad_zone_nk_known=" badknown+0 " bad_conic_xor=" badcx+0; }' \
  s4-dumps/2026-07-09/q23-zone2-all/*.txt
```

Output:

```text
files=22
moves=5734 results=5734 hits=5734 other_results=
tries=6437 P=5734 N=703
tried_minmax=1..4
tries_hist=1:5146 2:490 3:81 4:17
selected_live_on=4..10
selected_live_hist=4:1049 5:2613 6:1637 7:39 10:396
selected_zone_v=100..120
selected_zone_rows=17..17 selected_zone_cols=17..17
selected_bad_comp=0 bad_other=0 bad_zone_nk_known=0 bad_conic_xor=0
```

Interpretation: this rechecks the first-ply preservability evidence already in the logs: every
q=23 first move has a selected P-valued reply with live-conic xor 0, every selected witness has full
unused row/column support, and the off-conic zone remains one large unresolved component.  This does
not prove the maintenance theorem after a further off-conic move; the next machine-check should
explicitly play one legal zone move from these zero-xor followers and ask whether a re-zeroing reply
exists.

## Exact One-Pair Follow-Up

I added an opt-in maintenance layer to `s4xormine` and ran the next check.  The mode:

1. selects a P-valued reply with the requested live-conic Node-Kayles xor;
2. enumerates every legal off-conic move from that follower;
3. enumerates replies whose live-conic graph has the requested xor, including exact small-graph
   Grundy evaluation when more than two intruder matchings create degree greater than two;
4. solves each candidate in the full coupled grid-cap game;
5. under `--require-maintenance`, rejects the follower unless every off-conic move has a P-valued
   re-zeroing reply.

The graph xor remains only a steering feature.  This check does not assume a conic/zone disjunctive
sum or equate the graph xor with the true position nimber.

Build command:

```text
rustc -O -C target-cpu=native ../notes/2026-07-06-grid-cap-solver.rs -o target/gridcap-maint
```

Exact one-follower command:

```text
target/gridcap-maint s4xormine 23 1,3,4,9 \
  --target-xor 0 --cap 50000000 --max-tries 10 --start 0 --limit 1 \
  --maintain --maintain-max-tries 1000
```

This refuted the naive choice of the first zero-xor P follower.  For `x=(0,0)`, follower
`y=(7,21)` has three exact maintenance failures:

```text
z=(11,16): status=no-hit candidates=20 tried=20
z=(15,16): status=no-hit candidates=22 tried=22
z=(16,11): status=no-hit candidates=29 tried=29
MAINTFOLLOW-DONE x=0,0 y=7,21 moves=108 zone-start=0 zone-end=108 zone-total=108 hits=105 no-candidates=0 no-hit=3 try-limited=0 xor-unknown=0 aborted=0 memo=174418
```

Strategy-level command shape:

```text
target/gridcap-maint s4xormine 23 1,3,4,9 \
  --target-xor 0 --cap 50000000 --max-tries 1000 \
  --start <chunk-start> --limit <chunk-size> \
  --require-maintenance --maintain-max-tries 1000 --maintain-summary-only
```

For `x=(0,0)`, this rejects three non-maintainable P followers and accepts `y=(17,10)`, which
covers all 102 off-conic moves.  I then ran all 259 first moves of bucket representative
`1,3,4,9` in 26 deterministic chunks of at most 10 moves.  Aggregate output:

```text
chunks=26 root_moves=259 summary_moves=259 summary_hits=259 accepted=259 missing_indices=0 duplicate_indices=0 bad_chunks=0
candidate_followers=2714 failed_followers=2455 all_maint_moves=296933 all_maint_hits=288835 all_maint_no_hit=8098 no_candidates=0 try_limited=0 xor_unknown=0 aborted=0 max_memo=22575285
selected_zone_moves=28646 selected_zone_hits=28646 selected_no_hit=0 selected_unknown=0 selected_zone_range=101..116
selected_xgeom=on:18 ext:138 int:103
selected_ygeom=on:6 ext:87 int:166
selected_live_on=4:9 5:12 6:106 7:42 8:54 9:12 10:24
```

Selected maintenance replies leave:

```text
maintenance_live_on=0:14205 2:12928 3:1314 4:181 5:6 6:12
```

Verdict: one-pair zero-xor preservability is positive for every first move in this q=23 bucket,
provided P2 selects for maintenance rather than taking the first zero-xor P witness.  It is not yet
an all-bucket q=23 statement, and it does not settle termination.  The `live_on <= 2` descent rate
is 27,133/28,646 (94.718%); the 1,513 positive residuals with `live_on = 3..6` are the next
termination/repair stratum.

Validation:

- ordinary `s4xormine` result rows for the first 10 root moves remain byte-identical to the
  pre-maintenance q=23 log;
- chunk indices cover `0..258` exactly once;
- all 26 chunks have `aborted=false`, with zero `try-limit`, `xor-unknown`, or candidate-empty
  maintenance rows;
- maximum chunk memo was 22,575,285 entries under the 50M cap.
