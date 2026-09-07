"""Source-only claim/evidence integrity gate. No Lean declarations are asserted."""
import hashlib,json,re
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
ENV=re.compile(r'\\begin\{(theorem|lemma|proposition|corollary|remark|problem)\}(?:\[[^\]]*\])?(.*?)\\end\{\1\}',re.S)
ANNOT=re.compile(r'\\(?:coverage|lean|uses|proves|imports|evidence)\{[^}]*\}')
def sha(data):return hashlib.sha256(data).hexdigest()
def statements(text):
    result={}
    for kind,body in ENV.findall(text):
        labels=[x for x in re.findall(r'\\label\{([^}]+)\}',body) if not x.startswith('eq:')]
        assert len(labels)==1,('statement label',kind,labels)
        label=labels[0];assert label not in result
        clean=' '.join(ANNOT.sub('',body).split())
        result[label]=(kind,body,sha(clean.encode()))
    return result

def dependency_graph(text):
    lines=['digraph claims {']
    for label,(kind,body,_) in sorted(statements(text).items()):
        lines.append('  '+json.dumps(label)+' [color="gray"];')
        for macro,style in [('uses','dashed'),('imports','dotted'),('evidence','dotted')]:
            for args in re.findall(r'\\'+macro+r'\{([^}]+)\}',body):
                for dep in args.split(','):lines.append('  '+json.dumps(dep)+' -> '+json.dumps(label)+' [style='+style+'];')
    return '\n'.join(lines+['}'])+'\n'

def main():
    text=(ROOT/'continuation_graph_rigidity.tex').read_text();ss=statements(text)
    claims=json.loads((ROOT/'verification/claims.json').read_text())['claims']
    assert {c['label'] for c in claims}==set(ss) and len(claims)==len(ss)
    evidence=json.loads((ROOT/'verification/evidence.json').read_text())['entries']
    imports=json.loads((ROOT/'verification/imported-sources.json').read_text())['entries']
    bib=set(re.findall(r'\\bibitem\{([^}]+)\}',text))
    for entry in imports.values():
        assert entry['citation'] in bib and entry['pinpoint'] and entry['used'] and entry['conventions']
        for convention in entry['conventions']:assert all(convention[k] for k in ('aspect','requirement','matched'))
    for entry in evidence.values():
        assert entry['role'] and entry['commands'] and (ROOT/entry['checksum_manifest']).is_file()
    for c in claims:
        kind,body,digest=ss[c['label']]
        assert re.findall(r'\\coverage\{([^}]+)\}',body)==['absent']==[c['coverage']]
        assert c['declarations']==[] and not re.search(r'\\lean\{',body)
        assert c['statement_sha256']==digest and c['terminal_sha256']==sha(b'[]')
        assert all(c[k] for k in ('objects','hypotheses','conclusion','cautions'))
        for macro,registry in [('uses',ss),('imports',imports),('evidence',evidence)]:
            for args in re.findall(r'\\'+macro+r'\{([^}]+)\}',body):assert all(x in registry for x in args.split(','))
    assert (ROOT/'verification/dependency-graph.dot').read_text()==dependency_graph(text)
    detached=re.findall(r'\\proves\{([^}]+)\}',text)
    assert len(detached)==len(set(detached)) and all(x in ss for x in detached)
    for display in re.findall(r'\\\[(.*?)\\\]',text,re.S):assert r'\label{eq:' not in display
    sizes=json.loads((ROOT/'verification/file-sizes.json').read_text())
    assert all((ROOT/name).stat().st_size==size for name,size in sizes.items())
    for line in (ROOT/'verification/SHA256SUMS').read_text().splitlines():
        digest,path=line.split('  ',1);assert sha((ROOT/path).read_bytes())==digest,('hash mismatch',path)
    for rec in json.loads((ROOT/'verification/boundary.json').read_text())['records']:
        if rec['q']==13:continue
        row='&'.join(str(rec[k]) for k in ('q','vertices','automorphism_order','block_cliques','parallel_classes','resolutions'))+r'\\'
        assert row in text,('table mismatch',rec['q'])
    assert not re.search(r'\\tag\{|\\(?:ref|eqref)\{(?:[0-9])',text)
    print('PASS %d source-only claims, evidence links, boundary table, dependency graph and hashes'%len(claims))
if __name__=='__main__':main()
