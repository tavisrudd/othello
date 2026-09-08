"""Check manuscript identities, package-local evidence and exact arithmetic."""
import hashlib
import json
import re
from fractions import Fraction as Q
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT  # All evidence is package-local.
V = ROOT / 'verification'
ENVS = 'theorem|proposition|lemma|corollary'
MACROS = 'coverage|lean|uses|proves|imports|evidence'

def read_json(name):
    return json.loads((V / name).read_text())

def ids(body, macro):
    return [s.strip() for arg in re.findall(r'\\'+macro+r'\{([^}]*)\}', body)
            for s in arg.split(',') if s.strip()]

def statements():
    out = {}
    for path in sorted((ROOT / 'sections').glob('*.tex')):
        text = path.read_text()
        for m in re.finditer(r'\\begin\{('+ENVS+r')\}(?:\[[^]]*\])?(.*?)\\end\{\1\}', text, re.S):
            body = m[2]
            label = [x for x in ids(body, 'label') if x.startswith(('thm:', 'prop:', 'lem:', 'cor:'))]
            assert len(label) == 1 and label[0] not in out, (path, label)
            clean = re.sub(r'\\(?:'+MACROS+r')\{[^}]*\}', '', body)
            clean = ' '.join(clean.split())
            out[label[0]] = dict(body=body, digest=hashlib.sha256(clean.encode()).hexdigest(),
                                path=str(path.relative_to(ROOT)))
    return out

def graph(stmts):
    edges=[]
    for label,row in stmts.items():
        for macro in ('uses','imports','evidence'):
            for source in ids(row['body'],macro):
                edges.append((source,label,macro))
    for path in sorted((ROOT/'sections').glob('*.tex')):
        for proof in re.findall(r'\\begin\{proof\}(?:\[[^]]*\])?(.*?)\\end\{proof\}',path.read_text(),re.S):
            target=ids(proof,'proves')
            assert len(target)==1, 'proof must name its statement'
            for macro in ('uses','imports','evidence'):
                for source in ids(proof,macro):edges.append((source,target[0],'logical' if macro=='uses' else macro))
    lines=['digraph dependencies {']
    for label in sorted(stmts): lines.append(f'  "{label}" [style=filled, fillcolor=white];')
    for source,label,kind in sorted(edges):
        style='dashed' if kind=='uses' else ('solid' if kind=='logical' else 'dotted')
        lines.append(f'  "{source}" -> "{label}" [style={style}, label="{kind}"];')
    return '\n'.join(lines+['}'])+'\n'

def arithmetic():
    n7={0:1,3:48,4:2940,5:26502,6:88158}
    n11={0:1,5:120,6:14520,7:80520,8:21442960,9:2387485210,10:23528401270}
    for p,k,n in [(7,6,n7),(11,10,n11)]:
        assert sum(n.values())==p**k
        assert all(x%(p-1)==0 for r,x in n.items() if r)
    moment=lambda p,n:sum(Q(x,p**r) for r,x in n.items())
    assert moment(7,n7)==Q(78835,16807)
    assert moment(11,n11)==Q(7151076991,2357947691)
    assert Q(7**6)/moment(7,n7)==Q(1977326743,78835)
    assert Q(11**10)/moment(11,n11)==Q(11**19,7151076991)
    for p,k,n in [(11,10,n11), (7,6,{0:1,3:6,4:1092,5:20202,6:96348}),
                  (7,6,{0:1,3:6,4:588,5:20286,6:96768})]:
        assert sum(n.values())==p**k
        value=Q(p**k)/moment(p,n)
        assert all(value>Q((p**a+1)*(p**(k-a)+1),4) for a in range(1,k))
    assert Q(7**6)/moment(7,n7)<Q(8*(7**5+1),4)
    a=Q(99,100)
    assert Q(14)/a**14<Q(16116,1000)
    assert Q(91,600)/a**14<1
    assert 13/a**4<Q(91,6)
    assert Q(455,100)/a**7<Q(91,6)
    assert 36*a**14/14>Q(223,100) and 54*a**14/14>Q(335,100)
    assert 2-Q(182,100)>0

def main():
    stmts=statements(); claims=read_json('claim-map.json')
    assert set(claims)==set(stmts), 'claim coverage mismatch'
    bib=set(re.findall(r'\\bibitem\{([^}]+)\}',(ROOT/'references.tex').read_text()))
    imported=read_json('imported-sources.json'); evidence=read_json('evidence.json')
    for key,source in imported.items():
        assert source['citation'] in bib and source['pinpoint'] and source['used'], key
        assert source['read_depth'] and source['conventions'], key
        for c in source['conventions']: assert all(c.get(k) for k in ('aspect','requirement','matched')),key
    alltext='\n'.join(p.read_text() for p in sorted((ROOT/'sections').glob('*.tex')))
    labels=re.findall(r'\\label\{([^}]+)\}',alltext)
    assert len(labels)==len(set(labels)), 'duplicate label'
    for key in re.findall(r'\\(?:eqref|ref)\{([^}]+)\}',alltext): assert key in labels,key
    for keys in re.findall(r'\\cite(?:\[[^]]*\])?\{([^}]+)\}',alltext):
        for key in keys.split(','): assert key in bib,key
    for label,row in stmts.items():
        claim=claims[label]
        assert claim['coverage']=='absent' and claim['declarations']==[],label
        assert ids(row['body'],'coverage')==['absent'] and not ids(row['body'],'lean'),label
        assert claim['statement_sha256']==row['digest'],f'statement drift: {label}'
        assert claim['terminal_sha256']==hashlib.sha256(b'[]').hexdigest(),label
        assert all(claim.get(k) for k in ('objects','hypotheses','conclusion','cautions')),label
        for key in ids(row['body'],'uses'): assert key in stmts,key
        for key in ids(row['body'],'imports'): assert key in imported,key
        for key in ids(row['body'],'evidence'): assert key in evidence,key
        assert ids(alltext,'proves').count(label)==1,f'proof identity: {label}'
    for macro,known in [('uses',stmts),('proves',stmts),('evidence',evidence),('imports',imported)]:
        for key in ids(alltext,macro): assert key in known,key
    for key,bundle in evidence.items():
        assert bundle['commands'] and bundle['role'] and bundle['limits'],key
        assert (ROOT/bundle['checksum_manifest']).is_file(),key
    local=read_json('local-hashes.json')
    for name,item in local.items():
        data=(ROOT/name).read_bytes()
        assert len(data)==item['bytes'] and hashlib.sha256(data).hexdigest()==item['sha256'],name
    inputs=read_json('input-hashes.json')
    for name,item in inputs.items():
        data=(REPO/name).read_bytes()
        assert len(data)==item['bytes'] and hashlib.sha256(data).hexdigest()==item['sha256'],name
    assert (V/'dependency-graph.dot').read_text()==graph(stmts),'dependency graph drift'
    arithmetic()
    print(f'PASS: {len(stmts)} statement identities; {len(inputs)} evidence/source hashes; references and exact spectrum/product/factory arithmetic.')
    print('Formal coverage absent; full large-census replay is separate from these local checks.')

if __name__=='__main__': main()
