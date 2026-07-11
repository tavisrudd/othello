#!/usr/bin/env python3
"""Frozen REBASE7 geometry test.

For a normalized d=4 six-cap S and a live boundary move x, R7(x) holds if
some legal opposite-boundary y gives an eight-cap with a cap-stabilizing
type-(2 fixed,3 swapped) homology and seven selected points on one conic.
No game value enters the predicate.
"""

from collections import Counter
from itertools import combinations
import importlib.util

spec=importlib.util.spec_from_file_location('R','scripts/r5_q11_voltage_signature.py')
R=importlib.util.module_from_spec(spec);spec.loader.exec_module(R)

def cross(q,x,y):
 return ((x[1]*y[2]-x[2]*y[1])%q,(x[2]*y[0]-x[0]*y[2])%q,(x[0]*y[1]-x[1]*y[0])%q)
def dot(q,x,y):return sum(a*b for a,b in zip(x,y))%q
def mv(q,M,v):return tuple(sum(M[i][j]*v[j] for j in range(3))%q for i in range(3))
def same(q,x,y):return cross(q,x,y)==(0,0,0)
def legal(q,p,S):return p not in S and all(R.det(p,a,b,q) for a,b in combinations(S,2))

def matchings(items):
 if not items:yield ();return
 a=items[0]
 for i in range(1,len(items)):
  b=items[i]
  for rest in matchings(items[1:i]+items[i+1:]):yield ((a,b),)+rest

def rank(q,rows):
 A=[list(r) for r in rows]; rr=0
 for c in range(len(A[0])):
  p=next((i for i in range(rr,len(A)) if A[i][c]%q),None)
  if p is None:continue
  A[rr],A[p]=A[p],A[rr]; z=pow(A[rr][c],q-2,q); A[rr]=[x*z%q for x in A[rr]]
  for i in range(len(A)):
   if i!=rr and A[i][c]%q:
    z=A[i][c];A[i]=[(A[i][j]-z*A[rr][j])%q for j in range(len(A[0]))]
  rr+=1
 return rr
def conic_row(q,p):
 x,y,z=p;return (x*x%q,y*y%q,z*z%q,x*y%q,x*z%q,y*z%q)
def seven_conic(q,T,excluded):return rank(q,[conic_row(q,p) for i,p in enumerate(T) if i!=excluded])<=5

def has_rebase7(q,T):
 assert len(T)==8
 for A,B in combinations(range(8),2):
  ell=cross(q,T[A],T[B])
  rem=tuple(i for i in range(8) if i not in (A,B))
  for pairs in matchings(rem):
   l1=cross(q,T[pairs[0][0]],T[pairs[0][1]]);l2=cross(q,T[pairs[1][0]],T[pairs[1][1]])
   c=cross(q,l1,l2)
   if c==(0,0,0):continue
   ec=dot(q,ell,c)
   if not ec:continue
   K=tuple(tuple((ec if i==j else 0)-2*c[i]*ell[j] for j in range(3)) for i in range(3))
   K=tuple(tuple(x%q for x in row) for row in K)
   if all(same(q,mv(q,K,T[i]),T[j]) for i,j in pairs):
    assert same(q,mv(q,K,T[A]),T[A]) and same(q,mv(q,K,T[B]),T[B])
    if seven_conic(q,T,A) or seven_conic(q,T,B):return True
 return False

def audit(q):
 recs,rows,_=R.geometry_records(q,True,True)
 labels={(cls,cell):v for cls,rec in recs.items() for cell,v,_ in rec['children']}
 seen=set(); joint=Counter(); first_fail={}; first_pass={}
 for row in rows:
  ik=(row['cls'],row['key'],row['cell'])
  if ik in seen:continue
  seen.add(ik)
  C=lambda t:R.norm((t*t,t,1),q)
  S=(C(0),*(C(u) for u in row['U']),R.norm((-row['a'],0,1),q))
  D0=tuple(R.norm((0,b,1),q) for b in range(1,q) if legal(q,R.norm((0,b,1),q),S))
  Da=tuple(R.norm((-row['a'],d,1),q) for d in range(1,q) if legal(q,R.norm((-row['a'],d,1),q),S))
  flags=[]
  for side,Xs,Ys in (('0',D0,Da),('a',Da,D0)):
   for x in Xs:
    ok=any(legal(q,y,S+(x,)) and has_rebase7(q,S+(x,y)) for y in Ys)
    flags.append(ok)
  allr=bool(flags) and all(flags)
  anyr=any(flags)
  value=labels[(row['cls'],row['cell'])]
  joint[(allr,anyr,value)]+=1
  ex=(row['cls'],row['key'],row['cell'],row['a'],len(D0),len(Da),sum(flags),len(flags))
  (first_pass if allr else first_fail).setdefault(value,ex)
 print('q',q,'incidences',len(seen),'joint',dict(sorted(joint.items())),'first_all',first_pass,'first_fail',first_fail)

if __name__=='__main__':
 print('FROZEN R7=every live boundary x has opposite y with cap-stabilizing rebase and 7-point conic subset')
 for q in (11,13):audit(q)
 print('q 17 SKIPPED_BY_PREDECLARED_SURVIVOR_GATE (q=11 and q=13 already refute R7)')
