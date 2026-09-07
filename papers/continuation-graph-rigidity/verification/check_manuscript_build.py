"""Build twice with a fixed epoch; check or refresh the tracked PDF."""
import argparse,os,shutil,subprocess,tempfile
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
NAME='continuation_graph_rigidity'
def build():
    with tempfile.TemporaryDirectory(prefix='continuation-tex-') as temp:
        work=Path(temp)
        for p in ROOT.glob('*.tex'):shutil.copy2(p,work/p.name)
        env=dict(os.environ,SOURCE_DATE_EPOCH='1788739200',FORCE_SOURCE_DATE='1',TZ='UTC')
        for _ in range(3):
            p=subprocess.run(['pdflatex','-interaction=nonstopmode','-halt-on-error',NAME+'.tex'],cwd=work,env=env,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
            if p.returncode:raise RuntimeError('\n'.join(p.stdout.splitlines()[-25:]))
        log=(work/(NAME+'.log')).read_text()
        bad=[line for line in log.splitlines() if 'undefined' in line or 'Overfull' in line or 'multiply defined' in line]
        if bad:raise RuntimeError('\n'.join(bad))
        return (work/(NAME+'.pdf')).read_bytes()
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--update',action='store_true');args=ap.parse_args()
    a=build();b=build();assert a==b,'nondeterministic PDF'
    path=ROOT/(NAME+'.pdf')
    if args.update:path.write_bytes(a)
    else:assert path.read_bytes()==a,'tracked PDF is stale'
    print('PASS deterministic manuscript PDF (%d bytes)'%len(a))
if __name__=='__main__':main()
