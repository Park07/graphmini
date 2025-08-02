// In file: ~/graphmini/src/query_generator.cpp

#include <iostream>
#include <vector>
#include <string>
#include <random>
#include <unordered_set>
#include <unordered_map>
#include <algorithm>
#include <queue>
#include <fstream> // FIX: Included for file operations

#include "graph.h" // This now finds the header in src/

void save_query_for_bash(ui num_vertices, const std::vector<std::pair<VertexID, VertexID>>& edges, const std::string& output_path) {
    std::ofstream out_file(output_path);
    if (!out_file.is_open()) {
        std::cerr << "Error: Could not open file for writing: " << output_path << std::endl;
        return;
    }
    out_file << num_vertices << std::endl;
    for (const auto& edge : edges) {
        out_file << edge.first << " " << edge.second << std::endl;
    }
    out_file.close();
    std::cout << "Saved query for bash parsing to " << output_path << std::endl;
}

void generate_query_and_save(const Graph* data_graph, int target_vertices, const std::string& output_path) {
    if (data_graph->getVerticesCount() < target_vertices) {
        std::cerr << "Error: Target query size is larger than the data graph." << std::endl;
        return;
    }

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<VertexID> dis(0, data_graph->getVerticesCount() - 1);

    std::unordered_set<VertexID> query_nodes_set;
    std::queue<VertexID> q;

    VertexID start_node = dis(gen);
    q.push(start_node);
    query_nodes_set.insert(start_node);

    // FIX: Correctly access graph data using the new getter functions
    const ui* offsets = data_graph->getOffsets();
    const VertexID* edges = data_graph->getEdges();

    while (!q.empty() && query_nodes_set.size() < target_vertices) {
        VertexID u = q.front();
        q.pop();

        ui u_degree = offsets[u + 1] - offsets[u];
        if (u_degree == 0) continue;

        std::uniform_int_distribution<ui> neighbor_dis(0, u_degree - 1);
        VertexID v = edges[offsets[u] + neighbor_dis(gen)];

        if (query_nodes_set.find(v) == query_nodes_set.end()) {
           query_nodes_set.insert(v);
           q.push(v);
        }
    }

    std::vector<VertexID> query_nodes_vec(query_nodes_set.begin(), query_nodes_set.end());
    ui num_query_vertices = query_nodes_vec.size();
    std::unordered_map<VertexID, VertexID> node_map;

    for (ui i = 0; i < num_query_vertices; ++i) {
        node_map[query_nodes_vec[i]] = i;
    }

    std::vector<std::pair<VertexID, VertexID>> query_edges;
    for (ui i = 0; i < num_query_vertices; ++i) {
        VertexID u_original = query_nodes_vec[i];
        ui u_degree = offsets[u_original + 1] - offsets[u_original];

        for (ui j = 0; j < u_degree; ++j) {
            VertexID v_original = edges[offsets[u_original] + j];
            if (query_nodes_set.count(v_original)) {
                if (node_map[u_original] < node_map[v_original]) {
                    query_edges.push_back({node_map[u_original], node_map[v_original]});
                }
            }
        }
    }
    save_query_for_bash(num_query_vertices, query_edges, output_path);
}

int main(int argc, char* argv[]) {
    if (argc != 5) {
        std::cerr << "Usage: " << argv[0] << " <data_graph_path> <num_queries> <num_vertices> <output_dir>" << std::endl;
        return 1;
    }

    std::string data_graph_path = argv[1];
    int num_to_generate = std::stoi(argv[2]);
    int target_size = std::stoi(argv[3]);
    std::string output_dir = argv[4];

    Graph data_graph(true);
    data_graph.loadGraphFromFile(data_graph_path);

    for (int i = 0; i < num_to_generate; ++i) {
        std::string file_path = output_dir + "/query_v" + std::to_string(target_size) + "_id" + std::to_string(i) + ".graph";
        generate_query_and_save(&data_graph, target_size, file_path);
    }

    std::cout << "\nFinished generating " << num_to_generate << " queries." << std::endl;
    return 0;
}