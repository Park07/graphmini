#include <iostream>
#include <fstream>
#include <sstream>
#include <vector>
#include <string>

void convert_hku_to_graphmini(const std::string& input_path, const std::string& output_path) {
    std::ifstream input(input_path);
    std::ofstream output(output_path);
    
    if (!input.is_open() || !output.is_open()) {
        std::cerr << "Error opening files: " << input_path << " -> " << output_path << std::endl;
        return;
    }
    
    std::string line;
    int vertices = 0, edges = 0;
    std::vector<std::pair<int, int>> edge_list;
    
    while (std::getline(input, line)) {
        if (line.empty()) continue;
        
        std::istringstream iss(line);
        char type;
        iss >> type;
        
        if (type == 't') {
            iss >> vertices >> edges;
        }
        else if (type == 'e') {
            int u, v;
            iss >> u >> v;
            edge_list.push_back({u, v});
        }
    }
    
    // Write in GraphMini format
    output << vertices << std::endl;
    for (const auto& edge : edge_list) {
        output << edge.first << " " << edge.second << std::endl;
    }
    
    std::cout << "Converted " << input_path << " -> " << output_path 
              << " (" << vertices << " vertices, " << edge_list.size() << " edges)" << std::endl;
}

int main(int argc, char* argv[]) {
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <input_hku_file> <output_graphmini_file>" << std::endl;
        return 1;
    }
    
    convert_hku_to_graphmini(argv[1], argv[2]);
    return 0;
}
