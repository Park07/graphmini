def graph_to_matrix(num_vertices, edges):
    # Create adjacency matrix
    matrix = [[0] * num_vertices for _ in range(num_vertices)]
    
    # Fill in edges (undirected)
    for u, v in edges:
        matrix[u][v] = 1
        matrix[v][u] = 1
    
    # Convert to string
    return ''.join(str(matrix[i][j]) for i in range(num_vertices) for j in range(num_vertices))

# Test pattern from your query file
edges = [(0,2), (1,2), (1,3)]
pattern = graph_to_matrix(4, edges)
print(f"Pattern: {pattern}")
print(f"Length: {len(pattern)}")

# Show as matrix
for i in range(4):
    print(' '.join(pattern[i*4:(i+1)*4]))
