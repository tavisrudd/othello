"""Published Lee–Przyjalkowski seed; independent citation counts, no negative verdict."""
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
from urllib.parse import quote
import importlib.util
import json

HERE = Path(__file__).resolve().parent
spec = importlib.util.spec_from_file_location("probe", HERE / "2026-09-09-c1133-citation-probe.py")
probe = importlib.util.module_from_spec(spec)
spec.loader.exec_module(probe)
probe.CACHE = Path("/tmp/persistent/tavis/lit-search/c1133-lp-publication-probe")
DOI = "10.4213/rm10239e"

if __name__ == "__main__":
    probe.CACHE.mkdir(exist_ok=True)
    jobs = [
        ("lp-published", "OpenAlex", "https://api.openalex.org/works/https://doi.org/" + DOI),
        ("lp-published", "Crossref", "https://api.crossref.org/works/" + quote(DOI, safe="")),
        ("lp-published", "Semantic Scholar", "https://api.semanticscholar.org/graph/v1/paper/DOI:" + DOI + "?fields=paperId,title,externalIds,citationCount"),
    ]
    with ThreadPoolExecutor(max_workers=3) as executor:
        rows = list(executor.map(probe.probe, jobs))
    for row in rows:
        row["seed"] = "doi:" + DOI
        row["identifier_verified_at"] = "https://www.mathnet.ru/eng/rm10239"
    Path(__file__).with_suffix(".json").write_text(json.dumps(rows, indent=2) + "\n")
    for row in rows:
        print(row["service"], row["status"], row["citation_count"])

