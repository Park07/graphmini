#include "QueryGraphGenerator.h"
#include <vector>
#include <limits>
#include <cassert>
#include <algorithm>

void QueryGraphGenerator::generatePatternByRandomWalk(const Graph* data_graph,
                                                    ui target_vertices,
                                                    ui max_edges,
                                                    Graph*& query_graph) {
    std::set<VertexID> sampled_vertices;
    std::vector<std::pair<VertexID, VertexID>> sampled_edges;

    // Start random walk from random vertex
    VertexID current = rand() % data_graph->getVerticesCount();
    sampled_vertices.insert(current);

    // Random walk to collect vertices
    while (sampled_vertices.size() < target_vertices) {
        ui degree;
        const VertexID* neighbors = data_graph->getVertexNeighbors(current, degree);

        if (degree > 0) {
            VertexID next = neighbors[rand() % degree];
            sampled_vertices.insert(next);

            // Add edge if within edge budget
            if (sampled_edges.size() < max_edges) {
                sampled_edges.push_back({current, next});
            }
            current = next;
        }
    }

    // Create query graph from sampled vertices/edges
    createQueryGraphFromSample(sampled_vertices, sampled_edges, query_graph);
}