import sys

def convert_snap_to_hku(input_file, output_file):
    """
    Converts a SNAP edge list file to the HKU graph format.
    SNAP format:  node1 node2
    HKU format:   t #V #E
                  v vertex_id label
                  ...
                  e src_id dst_id label
    """
    print(f"Reading SNAP file: {input_file}...")
    edges = set()
    max_node_id = -1

    with open(input_file, 'r') as f_in:
        for line in f_in:
            if line.startswith('#'):
                continue
            try:
                u, v = map(int, line.strip().split())
                # Ensure undirected by adding both edge directions
                edges.add(tuple(sorted((u, v))))
                max_node_id = max(max_node_id, u, v)
            except ValueError:
                continue

    num_vertices = max_node_id + 1
    num_edges = len(edges)
    print(f"Graph stats: {num_vertices} vertices, {num_edges} unique edges.")
    print(f"Writing to HKU format file: {output_file}...")

    with open(output_file, 'w') as f_out:
        # Write header
        f_out.write(f"t {num_vertices} {num_edges}\n")

        # Write vertices (assigning a dummy label of 1, as slf expects)
        for i in range(num_vertices):
            f_out.write(f"v {i} 1\n")

        # Write edges (assigning a dummy label of 1)
        for u, v in sorted(list(edges)):
            f_out.write(f"e {u} {v} 1\n")

    print("Conversion complete!")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python3 snap_to_hku.py <input_snap_file> <output_hku_file>")
        sys.exit(1)

    convert_snap_to_hku(sys.argv[1], sys.argv[2])