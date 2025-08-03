// /Users/williampark/graphmini
// convert_hku_data.cpp
#include <iostream>
#include <fstream>
#include <sstream>

int main(int argc, char* argv[]) {
    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <hku_data.graph> <output.txt>" << std::endl;
        return 1;
    }

    std::ifstream input(argv[1]);
    std::ofstream output(argv[2]);

    std::string line;
    while (std::getline(input, line)) {
        if (line.empty()) continue;

        std::istringstream iss(line);
        char type;
        iss >> type;

        if (type == 'e') {  // Only output edges
            int u, v;
            iss >> u >> v;
            output << u << " " << v << std::endl;
        }
    }

    return 0;
}
