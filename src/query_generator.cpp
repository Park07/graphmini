#include <iostream>
#include <vector>
#include <string>
#include <random>
#include <unordered_set>
#include <unordered_map>
#include <algorithm>
#include <queue>

#include "graph.h"

/**
 * The CORE LOGIC for generating a single query graph by sampling.
 * It takes the large data graph and the target number of vertices for the query.
 */
void generate_query_and_save(const Graph *data_graph, int target_vertices, const std::string &output_path)
{
    if (data_graph->getVerticesCount() < target_vertices)
    {
        std::cerr << "Error: Target query size is larger than the data graph." << std::endl;
        return;
    }

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<VertexID> dis(0, data_graph->getVerticesCount() - 1);

    std::unordered_set<VertexID> query_nodes_set;
    std::queue<VertexID> q;

    // 1. Pick a random start node and add it to the queue
    VertexID start_node = dis(gen);
    q.push(start_node);
    query_nodes_set.insert(start_node);

    // 2. Perform a Breadth-First Search (BFS) to find connected nodes
    while (!q.empty() && query_nodes_set.size() < target_vertices)
    {
        VertexID u = q.front();
        q.pop();

        ui u_degree = 0;
        const VertexID *u_neighbors = data_graph->getNeighbors(u, u_degree);

        if (u_degree == 0)
            continue;

        // Add a few random neighbors to expand the query
        for (int i = 0; i < std::min((ui)2, u_degree); ++i)
        { // Explore up to 2 neighbors
            std::uniform_int_distribution<ui> neighbor_dis(0, u_degree - 1);
            VertexID v = u_neighbors[neighbor_dis(gen)];

            if (query_nodes_set.find(v) == query_nodes_set.end() && query_nodes_set.size() < target_vertices)
            {
                query_nodes_set.insert(v);
                q.push(v);
            }
        }
    }

    // 3. Build the new query graph from the sampled nodes
    std::vector<VertexID> query_nodes_vec(query_nodes_set.begin(), query_nodes_set.end());
    ui num_query_vertices = query_nodes_vec.size();
    std::unordered_map<VertexID, VertexID> node_map; // Maps original ID to new ID (0..N-1)

    for (ui i = 0; i < num_query_vertices; ++i)
    {
        node_map[query_nodes_vec[i]] = i;
    }

    // 4. Create the query graph file content
    std::vector<std::pair<VertexID, VertexID>> query_edges;
    for (ui i = 0; i < num_query_vertices; ++i)
    {
        VertexID u_original = query_nodes_vec[i];

        ui u_degree = 0;
        const VertexID *u_neighbors = data_graph->getNeighbors(u_original, u_degree);

        for (ui j = 0; j < u_degree; ++j)
        {
            VertexID v_original = u_neighbors[j];
            // If the neighbor is also in our sampled set, add the edge
            if (query_nodes_set.count(v_original))
            {
                // To avoid duplicates, only add edges where u < v in the new mapping
                if (node_map[u_original] < node_map[v_original])
                {
                    query_edges.push_back({node_map[u_original], node_map[v_original]});
                }
            }
        }
    }

    // 5. Save the query graph to a file in a simple edge list format
    std::ofstream out_file(output_path);
    if (!out_file.is_open())
    {
        std::cerr << "Error: Could not open file for writing: " << output_path << std::endl;
        return;
    }

    // Header for many graph formats: t # num_vertices num_edges
    out_file << "t # " << num_query_vertices << " " << query_edges.size() << std::endl;

    // A common format is to list vertices with their labels
    // Assuming labels are not a primary concern for now, we assign a default label '0'
    for (ui i = 0; i < num_query_vertices; ++i)
    {
        out_file << "v " << i << " 0" << std::endl;
    }

    // Then list the edges
    for (const auto &edge : query_edges)
    {
        out_file << "e " << edge.first << " " << edge.second << std::endl;
    }

    out_file.close();
    std::cout << "Saved query graph to " << output_path << std::endl;
}

int main(int argc, char *argv[])
{
    if (argc != 5)
    {
        std::cerr << "Usage: " << argv[0] << " <data_graph_path> <num_queries_to_generate> <num_vertices_in_query> <output_dir>" << std::endl;
        return 1;
    }

    std::string data_graph_path = argv[1];
    int num_to_generate = std::stoi(argv[2]);
    int target_size = std::stoi(argv[3]);
    std::string output_dir = argv[4];

    // Use the Graph class from the copied files
    Graph data_graph(true); // Assuming `true` enables directionality if needed
    data_graph.loadGraphFromFile(data_graph_path);

    for (int i = 0; i < num_to_generate; ++i)
    {
        std::string file_path = output_dir + "/query_v" + std::to_string(target_size) + "_id" + std::to_string(i) + ".graph";
        generate_query_and_save(&data_graph, target_size, file_path);
    }

    std::cout << "\nFinished generating " << num_to_generate << " queries." << std::endl;

    return 0;
}