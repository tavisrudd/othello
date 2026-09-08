"""Check the artifact's title, author, citation metadata and declared file set."""
import json
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[1]
source=(ROOT/'main.tex').read_text()
title=re.search(r'\\title\{([^{}]+)\}',source)[1]
title=' '.join(title.replace('\\\\',' ').split())
author=re.search(r'\\author\{([^{}]+)\}',source)[1]
metadata=json.loads((ROOT/'.zenodo.json').read_text())
assert metadata['title']==title,'Zenodo/manuscript title mismatch'
assert author=='Tavis Rudd' and metadata['creators'][0]['name']=='Rudd, Tavis','author mismatch'
assert metadata['creators'][0]['orcid']=='0009-0003-6405-3275','ORCID mismatch'
assert metadata['publication_type']=='preprint' and metadata['upload_type']=='publication'
assert metadata['license']=='cc-by-4.0' and metadata['access_right']=='open'
cff=(ROOT/'CITATION.cff').read_text()
assert f'title: "{title}"' in cff and 'license: CC-BY-4.0' in cff
assert 'family-names: Rudd' in cff and 'given-names: Tavis' in cff
assert '0009-0003-6405-3275' in cff and (ROOT/'LICENSE').is_file()
files=json.loads((ROOT/'verification/package-files.json').read_text())
assert files==sorted(set(files)),'package list must be sorted and unique'
for name in files:
 p=Path(name)
 assert not p.is_absolute() and '..' not in p.parts,'nonlocal package path'
 assert (ROOT/p).is_file(),f'missing package file: {name}'
 assert not any(part in {'submission','referee','correspondence'} for part in p.parts),'administrative package path'
print(f'PASS: title/author/citation metadata and {len(files)} declared artifact files.')
