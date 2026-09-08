"""Additional cold-review denominator, torus and scroll checks; SymPy 1.14.0."""
import ast, hashlib, json
from pathlib import Path
import sympy as sp
root=Path(__file__).resolve().parents[1]
source=root/'papers/cubic-stabilization-irrationality/verification/derive_slice_cover.py'
module=ast.parse(source.read_text())
fn=next(n for n in module.body if isinstance(n,ast.FunctionDef) and n.name=='cox_data')
namespace={'sp':sp}
exec(compile(ast.Module(body=[fn],type_ignores=[]),str(source),'exec'),namespace)
names=['E1','E2','E3','E4','E5','L12','L13','L14','L15','L23','L24','L25','L34','L35','L45','Q']
symbols,coords,relations,jac,rows,minor=namespace['cox_data'](names)
a,b,z1,z2,z3=symbols
out=[]
for z in [(1,3,7),(2,5,11),(3,8,13),(4,9,17)]:
 J=jac[list(rows),:].subs(dict(zip((z1,z2,z3),z)))
 basis=J[:,[names.index(n) for n in ['E3','E4','L34','Q']]].T.nullspace()
 hyperplanes=[v.T*J for v in basis]
 denoms=sorted({str(sp.factor(sp.cancel(e).as_numer_denom()[1])) for H in hyperplanes for e in H})
 # Poles are harmless only when excluded by the printed smooth open.
 locus=sp.factor(a*b*(a-1)*(b-1)*(a-b)*minor.subs(dict(zip((z1,z2,z3),z))))
 pole_checks=[]
 for d in denoms:
  for factor,mult in sp.factor_list(sp.sympify(d))[1]:
   safe=sp.rem(locus,factor,a,b)==0
   pole_checks.append({"factor":str(factor),"excluded_by_delta_times_minor":safe})
 out.append({"z":z,"hyperplane_denominators":denoms,"pole_checks":pole_checks})
t1,t2,t3,k0,k1,k2,k3=sp.symbols('t1 t2 t3 k0 k1 k2 k3',nonzero=True)
correction={t1:k3/k0,t2:k3/k1,t3:k3/k2}
assert all(sp.simplify(lhs.subs(correction)-rhs)==0 for lhs,rhs in [(t1/t2,k1/k0),(t1/t3,k2/k0),(t1,k3/k0)])
u,v=sp.symbols('u v',nonzero=True)
Y=[u*v,v*v,u*v*v]
assert sp.cancel(Y[2]/Y[1])==u and sp.cancel(Y[2]/Y[0])==v
result={'sympy':sp.__version__,'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'witness_bases':out,'orbit_correction':'passed','scroll_inverse':'passed'}
Path(__file__).with_suffix('.json').write_text(json.dumps(result,indent=2,sort_keys=True)+'\n')
print(json.dumps(result,indent=2))
assert all(c['excluded_by_delta_times_minor'] for w in out for c in w['pole_checks'])
