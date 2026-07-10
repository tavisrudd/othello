#!/usr/bin/env python3
import re,sys
from collections import defaultdict
for fn in sys.argv[1:]:
 q=None; P=defaultdict(list); summaries={}
 for line in open(fn):
  m=re.match(r'X q=(\d+) cls=(\d+) x=(\d+),(\d+) val=([PN])',line)
  if m and m.group(5)=='P': q=int(m.group(1));P[int(m.group(2))].append((int(m.group(3)),int(m.group(4))))
  m=re.match(r'CLS q=(\d+) cls=(\d+).* escape=(\d+).* onP=(\d+)',line)
  if m: q=int(m.group(1));summaries[int(m.group(2))]=(int(m.group(3)),int(m.group(4)))
 print('Q',q)
 for c,(esc,onp) in sorted(summaries.items()):
  pts=P[c]; col=True; eq=None
  if len(pts)>=3:
   (x1,y1),(x2,y2)=pts[:2]
   col=all(((x2-x1)*(y-y1)-(y2-y1)*(x-x1))%q==0 for x,y in pts[2:])
   eq=(x1,y1,x2,y2)
  print(f'CLS {c} escape={esc} onP={onp} allP_collinear={col} P={pts}')
