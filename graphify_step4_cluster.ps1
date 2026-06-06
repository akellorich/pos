@'
import sys, json
from graphify.cluster import cluster
from pathlib import Path

# Run cluster
nodes, edges, hyperedges = cluster()
Path('graphify-out/.graphify_cluster.json').write_text(json.dumps({'nodes': nodes, 'edges': edges, 'hyperedges': hyperedges}, indent=2, ensure_ascii=False), encoding="utf-8")
print(f'Clustering: clustered into {len({n.get("community") for n in nodes if "community" in n})} hierarchical communities')
'@ | Out-File -FilePath graphify-out\.graphify_step_4_cluster_and_build_communities_1.py -Encoding utf8
& (Get-Content graphify-out\.graphify_python) graphify-out\.graphify_step_4_cluster_and_build_communities_1.py
Remove-Item -ErrorAction SilentlyContinue graphify-out\.graphify_step_4_cluster_and_build_communities_1.py
