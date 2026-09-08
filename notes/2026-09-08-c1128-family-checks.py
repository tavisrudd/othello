"""C1128: replay supplied family algebra and check audit repairs/extensions."""
import importlib.util
import json
from pathlib import Path
import sys
import sympy as s

ROOT=Path(__file__).resolve().parents[1]
INPUTS=ROOT/'notes/cubic-threefolds-tasks/c1128-astra-feedback-inputs'


def zero(value):
    assert s.expand(value)==0, value


def main():
    sys.dont_write_bytecode=True
    spec=importlib.util.spec_from_file_location('supplied',INPUTS/'followon_family_checks.py')
    m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
    supplied=m.run_checks()
    assert json.loads(json.dumps(supplied))==json.loads((INPUTS/'followon_family_checks.json').read_text())
    u,v,x,z,y,a,r,d,t,beta=s.symbols('u v x z y a r d t beta')
    tangent_resultant=s.resultant(-a*u*u+6*u+3*a,u*u+3,u)
    zero(tangent_resultant-36*(a*a+3))
    lam,mu,nu,xi=s.symbols('lam mu nu xi')
    B=lam*x**3+mu*x**2*y+xi*x*y**2+nu*y**3
    q=x*x+3*y*y
    g=-z**3+s.Rational(3,4)*q*z+B
    F=(z-x)*u*u+6*y*u*v+3*(z+x)*v*v+g
    # Global line equations remain valid when r-a=0.
    line=s.Matrix([[r-a,3+d],[3-d,3*(r+a)]])
    zero(s.rem(s.expand(line.det()),d*d-3*(a*a+3-r*r),d))
    # It has rank exactly one: its off-diagonal entries sum to 6.
    zero(line[0,1]+line[1,0]-6)
    exceptional=line.subs({r:a,d:3})
    assert exceptional.rank()==1
    # The omitted fourth binary-cubic direction is tangent to a coordinate orbit.
    vectorfield=lambda f: 3*v*s.diff(f,u)-u*s.diff(f,v)-6*y*s.diff(f,x)+2*x*s.diff(f,y)
    zero(vectorfield(F-B))
    zero(vectorfield(F.subs({lam:0,mu:0,xi:0,nu:1}))-6*x*y*y)
    # Projection from the fixed line gives a conic plus plane-cubic discriminant.
    M=s.Matrix([[z-x,3*y,0],[3*y,3*(z+x),0],[0,0,g]])
    zero(M.det()-3*(z*z-q)*g)
    resultant=s.factor(s.resultant(z*z-q,4*g,z))
    zero(resultant-(16*B*B-q**3))
    zero(s.discriminant(-g,z)+s.Rational(27,16)*(16*B*B-q**3))
    W,Q,BB,Eta=s.symbols('W Q BB Eta',nonzero=True)
    cardano_z=(W+Q/W)/2
    zero(8*W**3*(cardano_z**3-s.Rational(3,4)*Q*cardano_z-BB)
         -(W**6-8*BB*W**3+Q**3))
    zero((4*BB+Eta)**2-8*BB*(4*BB+Eta)+Q**3
         -(Eta**2-16*BB**2+Q**3))
    # A different genus-two curve is the double cover of the conic itself.
    conic_sub={x:1-3*t*t,y:2*t,z:1+3*t*t}
    zero((z*z-q).subs(conic_sub))
    conic_branch=s.expand(4*g.subs(conic_sub))
    zero(conic_branch-(4*B.subs(conic_sub)-(1+3*t*t)**3))
    # On this conic, splitting the rank-one quadratic needs sqrt(-(z-x)g).
    zero((-(z-x)*g).subs(conic_sub)+s.Rational(3,2)*t*t*conic_branch)
    seed_branch=s.expand(conic_branch.subs({lam:0,mu:0,xi:0,nu:1}))
    assert s.gcd(seed_branch,s.diff(seed_branch,t))==1
    output=dict(status='pass',sympy_version=s.__version__,supplied_replay='exact JSON equality',
                scope='Finite identities and seed checks; geometric and moduli claims require the report',
                supplied=supplied,
                repairs={'component_line_matrix':[[str(e) for e in row] for row in line.tolist()],
                         'exceptional_chart_rank':exceptional.rank(),
                         'point_not_on_lines_resultant':str(s.factor(tangent_resultant))},
                closeout={'omitted_direction':'(3v*d_u-u*d_v-6y*d_x+2x*d_y)F_seed = 6*x*y^2',
                          'fixed_line_discriminant':'3*(z^2-x^2-3*y^2)*g',
                          'projected_branch_resultant':'16*B^2-(x^2+3*y^2)^3',
                          'trigonal_discriminant':'disc_z(z^3-(3/4)*q*z-B) = -(27/16)*(16*B^2-q^3)',
                          'cardano_cover':'W^3=4*B+eta, z=(W+q/W)/2',
                          'conic_parameterization':[str(conic_sub[e]) for e in (x,y,z)],
                          'conic_double_cover_equation':'h^2 = -(3/2)*(4*B(1-3*t^2,2*t)-(1+3*t^2)^3)',
                          'conic_branch_seed':str(seed_branch)})
    print(json.dumps(output,indent=2)+'\n',end='')


if __name__=='__main__': main()
