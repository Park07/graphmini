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

void save_query_for_bash(int num_vertices, const std::vector<std::pair<int, int>>& edges, const std::string& output_path);
void generate_query_connected_subgraph(const SimpleGraph& data_graph, int target_vertices, int min_edges, const std::string& output_path);
bool is_connected(int n, const std::vector<std::pair<int, int>>& edges);

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
    std::cout << "Saved query to " << output_path << " (" << num_vertices << " vertices, " << edges.size() << " edges)" << std::endl;
}

void generate_query_connected_subgraph(const SimpleGraph& data_graph, int target_vertices, int min_edges, const std::string& output_path) {
    std::random_device rd;
    std::mt19937 gen(rd());

    for (int attempt = 0; attempt < 1000; ++attempt) {
        // Find vertices with good connectivity
        std::vector<int> candidates;
        for (int i = 0; i < data_graph.num_vertices; ++i) {
            if (data_graph.adj_list[i].size() >= 3) {  // Only consider well-connected vertices
                candidates.push_back(i);
            }
        }

        if (candidates.size() < target_vertices) continue;

        // Start with a random well-connected vertex
        std::uniform_int_distribution<> start_dis(0, candidates.size() - 1);
        std::unordered_set<int> selected;
        std::queue<int> to_explore;

        int start = candidates[start_dis(gen)];
        selected.insert(start);
        to_explore.push(start);

        // BFS expansion to get exactly target_vertices
        while (selected.size() < target_vertices && !to_explore.empty()) {
            int current = to_explore.front();
            to_explore.pop();

            // Shuffle neighbors for randomness
            std::vector<int> neighbors = data_graph.adj_list[current];
            std::shuffle(neighbors.begin(), neighbors.end(), gen);

            for (int neighbor : neighbors) {
                if (selected.size() >= target_vertices) break;
                if (selected.find(neighbor) == selected.end()) {
                    selected.insert(neighbor);
                    to_explore.push(neighbor);
                }
            }
        }

        // Must have exactly target_vertices
        if (selected.size() != target_vertices) continue;

        // Create mapping and extract edges
        std::vector<int> nodes(selected.begin(), selected.end());
        std::unordered_map<int, int> node_map;
        for (int i = 0; i < nodes.size(); ++i) {
            node_map[nodes[i]] = i;
        }

        std::vector<std::pair<int, int>> edges;
        for (int u_orig : nodes) {
            for (int v_orig : data_graph.adj_list[u_orig]) {
                if (selected.count(v_orig) && u_orig < v_orig) {
                    edges.push_back({node_map[u_orig], node_map[v_orig]});
                }
            }
        }

        // Check if we have enough edges and the graph is connected
        if (edges.size() >= min_edges && is_connected(target_vertices, edges)) {
            save_query_for_bash(target_vertices, edges, output_path);
            return;
        }
    }

    std::cerr << "Failed to generate suitable query after 1000 attempts for " << output_path << std::endl;
}

// Add this connectivity check function:
bool is_connected(int n, const std::vector<std::pair<int, int>>& edges) {
    std::vector<std::vector<int>> adj(n);
    for (const auto& edge : edges) {
        adj[edge.first].push_back(edge.second);
        adj[edge.second].push_back(edge.first);
    }

    std::vector<bool> visited(n, false);
    std::queue<int> q;
    q.push(0);
    visited[0] = true;
    int count = 1;

    while (!q.empty()) {
        int u = q.front();
        q.pop();
        for (int v : adj[u]) {
            if (!visited[v]) {
                visited[v] = true;
                q.push(v);
                count++;
            }
        }
    }

    return count == n;
}

int main(int argc, char* argv[]) {
    if (argc != 6) {
        std::cerr << "Usage: " << argv[0] << " <data_graph_path> <num_queries> <num_vertices> <min_edges> <output_dir>" << std::endl;
        return 1;
    }

    std::string data_graph_path = argv[1];
    int num_to_generate = std::stoi(argv[2]);
    int target_size = std::stoi(argv[3]);
    int min_edges = std::stoi(argv[4]);
    std::string output_dir = argv[5];

    SimpleGraph data_graph;
    if (!data_graph.loadFromFile(data_graph_path)) {
        return 1;
    }

    for (int i = 0; i < num_to_generate; ++i) {
        std::string file_path = output_dir + "/query_v" + std::to_string(target_size) + "_id" + std::to_string(i) + ".graph";
        generate_query_connected_subgraph(data_graph, target_size, min_edges, file_path);
    }

    std::cout << "\nFinished generating " << num_to_generate << " queries." << std::endl;
    return 0;
}