# C31 follow-up: one-pair zone-descent target

Date: 2026-07-08.

## Result

C31's high recursive ceilings are not persistent in the tested C20 regime.

For every reconstructed C20 P reply-state `S` at `q = 13, 17`, and for every legal opponent move
`m`, I checked the winning replies `r` from `S + m`.  Choosing a reply that minimizes

```text
max(zone(S+m+r), Z(S+m+r))
```

always lands in a grandchild with

```text
Z(S+m+r) <= 2.
```

At `q = 13`, the selected replies actually land at `Z = 0` and immediate zone at most `2`.
At `q = 17`, the selected replies land at `Z <= 2`; the largest remaining cost is the immediate
off-conic zone, which is at most `9` in this sample.

This sharpens the C31 target.  The useful empirical theorem is not just "P2 can keep the zone
bounded by 9."  It is:

```text
From the C20 P reply-state regime, one P2 response pair descends to the small steering family
Z <= 2, while the immediate off-conic zone stays bounded.
```

## Verification Output

Command:

```bash
env PYTHONDONTWRITEBYTECODE=1 python3 - <<'PY'
import importlib.util, sys, collections
from pathlib import Path
p=Path('notes/2026-07-08-zone-steering-census.py')
spec=importlib.util.spec_from_file_location('c31', p); c31=importlib.util.module_from_spec(spec); sys.modules[spec.name]=c31; spec.loader.exec_module(c31)
c20=c31.load_c20_module()
for q in [13,17]:
    game=c20.PrimeGridGame(q)
    states,_=c31.load_p_reply_states(Path('notes/data/c20-q13-q17-states.jsonl.gz'), q)
    steering=c31.Steering(game)
    max_best_child_z=0; max_best_child_zone=0; max_score=0
    per_state_max_childz=collections.Counter(); per_state_max_zone=collections.Counter(); examples=[]
    for mask,row in states:
        if game.value(mask): raise RuntimeError('bad')
        steering.z(mask)
        state_max_child_z=0; state_max_zone=0; state_max_score=0
        for m in c31.iter_bits(game.legal_mask(mask)):
            child=mask | (1<<m)
            best=None; best_z=None; best_zone=None; best_r=None
            for r in c31.iter_bits(game.legal_mask(child)):
                grand=child | (1<<r)
                if game.value(grand): continue
                cz=steering.z(grand); zone=steering.zone(grand); score=max(zone,cz)
                if best is None or score<best:
                    best=score; best_z=cz; best_zone=zone; best_r=r
            if best is None: raise RuntimeError('no reply')
            state_max_child_z=max(state_max_child_z,best_z)
            state_max_zone=max(state_max_zone,best_zone)
            state_max_score=max(state_max_score,best)
            if best_z>2 and len(examples)<5:
                examples.append((row, c31.cell(game,m), c31.cell(game,best_r), best_zone, best_z, best))
        per_state_max_childz[state_max_child_z]+=1
        per_state_max_zone[state_max_zone]+=1
        max_best_child_z=max(max_best_child_z,state_max_child_z)
        max_best_child_zone=max(max_best_child_zone,state_max_zone)
        max_score=max(max_score,state_max_score)
    print('\nq',q,'states',len(states))
    print('per_state max best_child_z',dict(sorted(per_state_max_childz.items())))
    print('per_state max best_child_zone',dict(sorted(per_state_max_zone.items())))
    print('max_child_z',max_best_child_z,'max_child_zone',max_best_child_zone,'max_score',max_score)
    print('examples child_z>2', examples[:1])
PY
```

Output:

```text
q 13 states 485
per_state max best_child_z {0: 485}
per_state max best_child_zone {0: 398, 1: 19, 2: 68}
max_child_z 0 max_child_zone 2 max_score 2
examples child_z>2 []

q 17 states 2662
per_state max best_child_z {0: 2472, 1: 105, 2: 85}
per_state max best_child_zone {0: 9, 2: 127, 3: 269, 4: 1156, 5: 672, 6: 310, 7: 59, 8: 46, 9: 14}
max_child_z 2 max_child_zone 9 max_score 9
examples child_z>2 []
```

## High-Z Structure

A feature scan of the q = 17 C31 states found that the high ceilings are concentrated, not diffuse:

- all `Z >= 8` states arise from intruder replies, not on-conic replies;
- all `Z = 9` states occur in only two full-`PGL(2,17)` bucket families:
  - 12 states in bucket `(0, 1, 2, 3, 6, 14)`, with `t4=[3,4,5,8]`;
  - 2 states in bucket `(0, 1, 2, 3, 4, 'inf')`, with `t4=[13,14,15,16]`;
- in the recorded optimal traces, every `Z = 9` state moves to a child with immediate zone `9`
  but recursive `childZ = 2`.

So the high q = 17 ceiling seems to be a one-pair repair cost rather than a long recursive
phenomenon.

## Proof Target

Replace the broad C31 theorem target

```text
bounded-zone steering lemma
+ bounded-zone terminal/endgame law
```

with the sharper two-layer target:

```text
small-zone base law:
    characterize / certify the Z <= 2 family;

one-pair descent law:
    from each C20 P reply-state S, every legal opponent move m has a winning reply r
    with Z(S+m+r) <= 2 and zone(S+m+r) <= B;

on-conic escape law:
    every odd-q frame has an on-conic escape into the C20 P reply-state regime.
```

For the current data, `B = 2` at q = 13 and `B = 9` at q = 17.  The next useful machine step is to
mine the chosen replies for a geometric description of the descent move, especially in the two
q = 17 high-Z bucket families above.
