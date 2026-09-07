"""Refresh specified statement digests only after reviewing their correspondence."""
import argparse,json
from check_formal_artifact import ROOT,statements,sha
if __name__=='__main__':
    ap=argparse.ArgumentParser();ap.add_argument('labels',nargs='*');ap.add_argument('--all',action='store_true');args=ap.parse_args()
    assert args.all or args.labels,'name reviewed statements or use --all for a reviewed baseline'
    path=ROOT/'verification/claims.json';data=json.loads(path.read_text());ss=statements((ROOT/'continuation_graph_rigidity.tex').read_text())
    assert set(args.labels)<=set(ss)
    for c in data['claims']:
        if args.all or c['label'] in args.labels:
            c['statement_sha256']=ss[c['label']][2];c['terminal_sha256']=sha(b'[]')
    path.write_text(json.dumps(data,indent=2,sort_keys=True)+'\n')
