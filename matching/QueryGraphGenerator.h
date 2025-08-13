class QueryGraphGenerator
{
public:
    // Generate patterns by random walk sampling
    static void generatePatternByRandomWalk(const Graph *data_graph,
                                            ui target_vertices,
                                            ui max_edges,
                                            Graph *&query_graph);

    // Generate multiple patterns for a category
    static void generatePatternSet(const Graph *data_graph,
                                   const std::string &category, // "small-sparse", etc.
                                   ui num_patterns,
                                   std::vector<Graph *> &patterns);
    void QueryGraphGenerator::generatePatternByRandomWalk(const Graph *data_graph,
                                                          ui target_vertices,
                                                          ui max_edges,
                                                          Graph *&query_graph)
};