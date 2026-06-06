import inspect
from graphify.cluster import cluster
print("Signature:", inspect.signature(cluster))
print("Source code:")
print(inspect.getsource(cluster))
