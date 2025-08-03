// In file: ~/graphmini/src/query_generator.cpp

#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <sstream>
#include <random>
#include <unordered_set>
#include <unordered_map>
#include <algorithm>
#include <queue>
#include <cstdio>

struct SimpleGraph {
    int num_vertices = 0;
    std::vector<std::vector<int>> adj_list;

    bool loadFromFile(const std::string& file_path) {
        std::ifstream file(file_path);
        if (!file.is_open()) {
            std::cerr << "Error: Could not open data graph file: " << file_path << std::endl;
            return false;
        }

        int max_vertex_id = -1;
        std::vector<std::pair<int, int>> edges;
        std::string line;

        while (std::getline(file, line)) {
            if (line.empty() || line[0] == '#' || line[0] == '%') continue;

            std::stringstream ss(line);
            int u, v;
            if (ss >> u >> v) {
                edges.push_back({u, v});
                if (u > max_vertex_id) max_vertex_id = u;
                if (v > max_vertex_id) max_vertex_id = v;
            }
        }

        if (max_vertex_id == -1) {
            std::cerr << "Error: No edges were loaded from the file." << std::endl;
            return false;
        }

        num_vertices = max_vertex_id + 1;
        adj_list.resize(num_vertices);
        for (const auto& edge : edges) {
            if (edge.first < num_vertices && edge.second < num_vertices) {
                adj_list[edge.first].push_back(edge.second);
                adj_list[edge.second].push_back(edge.first);
            }
        }
        std::cout << "Successfully loaded data graph with " << num_vertices << " vertices." << std::endl;
        return true;
    }
};

void save_query_to_file(int num_vertices, const std::vector<std::pair<int, int>>& edges, const std::string& output_path) {
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
    std::cout << "Saved query to " << output_path << " (" << num_vertices << " vertices, " << edges.size() << " edges)" << std::endl;
}

// New, more robust generation logic
void generate_guaranteed_connected_subgraph(const SimpleGraph& data_graph, int target_vertices, const std::string& output_path) {
    if (data_graph.num_vertices < target_vertices) {
        std::cerr << "Error: Target query size is larger than the data graph." << std::endl;
        return;
    }

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(0, data_graph.num_vertices - 1);

    std::unordered_set<int> selected_nodes;
    std::queue<int> q;

    // 1. Find a random starting node that has at least one neighbor
    int start_node = -1;
    do {
        start_node = dis(gen);
    } while (data_graph.adj_list.at(start_node).empty());

    q.push(start_node);
    selected_nodes.insert(start_node);

    // 2. Perform a Breadth-First Search (BFS) to gather a connected set of nodes
    while (selected_nodes.size() < target_vertices && !q.empty()) {
        int u = q.front();
        q.pop();

        const auto& neighbors = data_graph.adj_list.at(u);
        if (neighbors.empty()) continue;

        // Add a random neighbor to the set
        std::uniform_int_distribution<> neighbor_dis(0, neighbors.size() - 1);
        int v = neighbors[neighbor_dis(gen)];

        if (selected_nodes.find(v) == selected_nodes.end()) {
           selected_nodes.insert(v);
           q.push(v);
        }
    }

    // 3. Create a mapping from original node IDs to new IDs (0 to N-1)
    std::vector<int> query_nodes_vec(selected_nodes.begin(), selected_nodes.end());
    int num_query_vertices = query_nodes_vec.size();
    std::unordered_map<int, int> node_map;
    for (int i = 0; i < num_query_vertices; ++i) {
        node_map[query_nodes_vec[i]] = i;
    }

    // 4. Add all the edges that exist between the selected nodes
    std::vector<std::pair<int, int>> query_edges;
    for (int u_original : query_nodes_vec) {
        for (int v_original : data_graph.adj_list.at(u_original)) {
            // If the neighbor was also selected, add the edge
            if (selected_nodes.count(v_original)) {
                if (node_map[u_original] < node_map[v_original]) { // Avoid duplicate edges
                    query_edges.push_back({node_map[u_original], node_map[v_original]});
                }
            }
        }
    }

    save_query_to_file(num_query_vertices, query_edges, output_path);
}

int main(int argc, char* argv[]) {
    // The script now passes 5 arguments, so we check for 6 (including the program name)
    if (argc != 6) {
        std::cerr << "Usage: " << argv[0] << " <data_graph_path> <num_queries> <num_vertices> <min_edges_ignored> <output_dir>" << std::endl;
        return 1;
    }

    std::string data_graph_path = argv[1];
    int num_to_generate = std::stoi(argv[2]);
    int target_size = std::stoi(argv[3]);
    // We ignore argv[4] (min_edges) for this simpler, more robust generator
    std::string output_dir = argv[5];

    SimpleGraph data_graph;
    if (!data_graph.loadFromFile(data_graph_path)) {
        return 1;
    }

    for (int i = 0; i < num_to_generate; ++i) {
        std::string file_path = output_dir + "/query_v" + std::to_string(target_size) + "_id" + std::to_string(i) + ".graph";
        generate_guaranteed_connected_subgraph(data_graph, target_size, file_path);
    }

    std::cout << "\nFinished generating " << num_to_generate << " queries." << std::endl;
    return 0;
}