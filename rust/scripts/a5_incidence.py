#!/usr/bin/env python3
import itertools, re, subprocess, sys
from collections import Counter
from a5_stab import mats, act

PBUCKETS={11:{1,2,3},17:{4,6,7,8,9}}
def orbit_map(q,k,G):
    allsets=set(itertools.combinations(range(q+1),k)); mp={}; reps=[]
    while allsets:
      A=min(allsets); idx=len(reps); reps.append(A)
      orb={tuple(sorted(act(g,x,q) for x in A)) for g in G}
      for B in orb: mp[B]=idx
      allsets.difference_update(orb)
    return reps,mp
def main():
 for q in map(int,sys.argv[1:]):
  G=list(mats(q)); rows,rmap=orbit_map(q,5,G); cols,cmap=orbit_map(q,6,G)
  print(f'Q {q} rows={len(rows)} cols={len(cols)}')
  incid=[]
  for i,A in enumerate(rows):
   xs=[(x,cmap[tuple(sorted((*A,x)))]) for x in range(q+1) if x not in A]
   cnt=Counter(b for x,b in xs)
   incid.append(set(cnt)&PBUCKETS[q])
   print(f'R q={q} idx={i} A={A} M={dict(sorted(cnt.items()))} onP={sum(v for b,v in cnt.items() if b in PBUCKETS[q])} xmap={xs}')
  Ps=sorted(PBUCKETS[q]); covers=[]
  for n in range(1,len(Ps)+1):
   for C in itertools.combinations(Ps,n):
    if all(S.intersection(C) for S in incid): covers.append(C)
   if covers: break
  print(f'COVER q={q} min={n} sets={covers}')
if __name__=='__main__':main()
