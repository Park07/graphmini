// In file: ~/graphmini/src/query_generator.cpp

#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <sstream> // Required for robust line parsing
#include <random>
#include <unordered_set>
#include <unordered_map>
#include <algorithm>
#include <queue>
#include <cstdio>

// A simple, self-contained representation of a graph for this generator ONLY.
struct SimpleGraph {
    int num_vertices = 0;
    std::vector<std::vector<int>> adj_list;

    // A more robust function to load graph files.
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
            // Skip empty lines or lines that are comments
            if (line.empty() || line[0] == '#' || line[0] == '%') {
                continue;
            }

            std::stringstream ss(line);
            int u, v;

            // Try to read two integers from the line
            if (ss >> u >> v) {
                edges.push_back({u, v});
                if (u > max_vertex_id) max_vertex_id = u;
                if (v > max_vertex_id) max_vertex_id = v;
            }
        }

        if (max_vertex_id == -1) {
            std::cerr << "Error: No edges were loaded from the file. Check the file format and path." << std::endl;
            return false;
        }

        num_vertices = max_vertex_id + 1;
        adj_list.resize(num_vertices);
        for (const auto& edge : edges) {
            // Ensure we don't go out of bounds
            if (edge.first < num_vertices && edge.second < num_vertices) {
                adj_list[edge.first].push_back(edge.second);
                adj_list[edge.second].push_back(edge.first);
            }
        }
        std::cout << "Successfully loaded data graph '" << file_path << "' with " << num_vertices << " vertices." << std::endl;
        return true;
    }
};

void save_query_for_bash(int num_vertices, const std::vector<std::pair<int, int>>& edges, const std::string& output_path) {
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
    std::cout << "Saved query to " << output_path << std::endl;
}

void generate_query(const SimpleGraph& data_graph, int target_vertices, const std::string& output_path) {
    if (data_graph.num_vertices < target_vertices) {
        std::cerr << "Error: Target query size (" << target_vertices << ") is larger than the data graph (" << data_graph.num_vertices << ")." << std::endl;
        return;
    }

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dis(0, data_graph.num_vertices - 1);

    std::unordered_set<int> query_nodes_set;
    std::queue<int> q;

    int start_node = -1;
    int attempts = 0;
    do {
        start_node = dis(gen);
        attempts++;
    } while (data_graph.adj_list.at(start_node).empty() && attempts < data_graph.num_vertices);

    if (data_graph.adj_list.at(start_node).empty()) {
        std::cerr << "Error: Could not find a starting node with neighbors." << std::endl;
        return;
    }

    q.push(start_node);
    query_nodes_set.insert(start_node);

    while (!q.empty() && query_nodes_set.size() < target_vertices) {
        int u = q.front();
        q.pop();

        if (data_graph.adj_list.at(u).empty()) continue;

        std::uniform_int_distribution<> neighbor_dis(0, data_graph.adj_list.at(u).size() - 1);
        int v = data_graph.adj_list.at(u).at(neighbor_dis(gen));

        if (query_nodes_set.find(v) == query_nodes_set.end()) {
           query_nodes_set.insert(v);
           q.push(v);
        }
    }

    std::vector<int> query_nodes_vec(query_nodes_set.begin(), query_nodes_set.end());
    int num_query_vertices = query_nodes_vec.size();
    std::unordered_map<int, int> node_map;

    for (int i = 0; i < num_query_vertices; ++i) {
        node_map[query_nodes_vec[i]] = i;
    }

    std::vector<std::pair<int, int>> query_edges;
    for (int u_original : query_nodes_vec) {
        for (int v_original : data_graph.adj_list.at(u_original)) {
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

    SimpleGraph data_graph;
    if (!data_graph.loadFromFile(data_graph_path)) {
        return 1;
    }

    for (int i = 0; i < num_to_generate; ++i) {
        std::string file_path = output_dir + "/query_v" + std::to_string(target_size) + "_id" + std::to_string(i) + ".graph";
        generate_query(data_graph, target_size, file_path);
    }

    std::cout << "\nFinished generating " << num_to_generate << " queries for this category." << std::endl;
    return 0;
}