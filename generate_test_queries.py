import os

def create_query_file(output_dir, name, vertices, edges):
    """Create a query graph file in HKU format"""
    os.makedirs(output_dir, exist_ok=True)
    filepath = os.path.join(output_dir, f"{name}.graph")
    
    with open(filepath, 'w') as f:
        f.write(f"t {len(vertices)} {len(edges)}\n")
        for v in vertices:
            f.write(f"v {v} 1\n")
        for u, v in edges:
            f.write(f"e {u} {v} 1\n")
    
    return filepath

# Create test queries that should work
base_dir = "/home/williamp/thesis_data/query_sets/test_queries"

# 4-vertex patterns that should work
patterns = {
    "4clique": (4, [(0,1), (0,2), (0,3), (1,2), (1,3), (2,3)]),  # Complete graph
    "4cycle": (4, [(0,1), (1,2), (2,3), (3,0)]),  # Square
    "4path": (4, [(0,1), (1,2), (2,3)]),  # Path
    "4star": (4, [(0,1), (0,2), (0,3)]),  # Star
    "4triangle_plus": (4, [(0,1), (1,2), (2,0), (2,3)]),  # Triangle with tail
}

for name, (n_vertices, edges) in patterns.items():
    vertices = list(range(n_vertices))
    filepath = create_query_file(f"{base_dir}/small_dense_4v", name, vertices, edges)
    print(f"Created: {filepath}")
