#!/usr/bin/env python3
import re, subprocess, sys
from collections import Counter

def inv(x,q): return pow(x,q-2,q)
def mats(q):
    for a in range(q):
      for b in range(q):
       for c in range(q):
        for d in range(q):
         if (a*d-b*c)%q==0: continue
         v=(a,b,c,d)
         z=next(x for x in v if x)
         zi=inv(z,q)
         if z!=1: continue
         yield tuple(x*zi%q for x in v)
def act(m,x,q):
    a,b,c,d=m
    if x==q:
        return q if c==0 else a*inv(c,q)%q
    den=(c*x+d)%q; num=(a*x+b)%q
    return q if den==0 else num*inv(den,q)%q
def cyc_type(m,S,q):
    seen=set(); out=[]
    for x in sorted(S):
      if x not in seen:
       y=x;n=0
       while y not in seen: seen.add(y);n+=1;y=act(m,y,q)
       out.append(n)
    return tuple(sorted(out,reverse=True))
def main():
 for q in map(int,sys.argv[1:]):
  txt=subprocess.check_output(['./target/gridcap-arena','s4bucketlist',str(q)],text=True)
  rows=[]
  for line in txt.splitlines():
   z=re.search(r'idx=(\d+) canon=\[([^]]+)\] size=(\d+)',line)
   if z: rows.append((int(z.group(1)),int(z.group(3)),set(map(int,z.group(2).split(',')))))
  G=list(mats(q)); assert len(G)==q*(q*q-1)
  print(f'Q {q} |PGL|={len(G)}')
  for idx,fib,S in rows:
   st=[m for m in G if {act(m,x,q) for x in S}==S]
   types=Counter(cyc_type(m,S,q) for m in st)
   invol=sum(v for k,v in types.items() if k in {(2,2,2),(2,2,1,1),(2,1,1,1,1)})
   print(f'B q={q} idx={idx} fiber={fib} stab={len(st)} invol={invol} cycles={dict(sorted(types.items()))}')
if __name__=='__main__':main()
