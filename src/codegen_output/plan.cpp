#include "plan.h"
namespace minigraph {
uint64_t pattern_size() { return 4; }
void plan(const GraphType *graph, Context &ctx) {
  using MiniGraphType = MiniGraphCostModel;
  MiniGraphIF::DATA_GRAPH = graph;
  VertexSetType::MAX_DEGREE = graph->get_maxdeg();
#pragma omp parallel num_threads(ctx.num_threads) default(none)                \
    shared(ctx, graph)
  { // pragma parallel
    cc &counter = ctx.per_thread_result.at(omp_get_thread_num());
    cc &handled = ctx.per_thread_handled.at(omp_get_thread_num());
    double start = omp_get_wtime();
    ctx.iep_redundency = 0;
#pragma omp for schedule(dynamic, 1) nowait
    for (IdType i0_id = 0; i0_id < graph->get_vnum(); i0_id++) { // loop-0 begin
      VertexSet i0_adj = graph->N(i0_id);
      VertexSet s0 = i0_adj;
      if (s0.size() == 0)
        continue;
      /* VSet(0, 0) In-Edges: 0 Restricts: */
      VertexSet s1 = s0.bounded(i0_id);
      /* VSet(1, 0) In-Edges: 0 Restricts: 0 */
      for (size_t i1_idx = 0; i1_idx < s1.size(); i1_idx++) { // loop-1 begin
        const IdType i1_id = s1[i1_idx];
        VertexSet i1_adj = graph->N(i1_id);
        VertexSet s2 = i1_adj.subtract(i0_adj);
        if (s2.size() == 0)
          continue;
        /* VSet(2, 1) In-Edges: 1 Restricts: */
        VertexSet s3 = s0.subtract(i1_adj);
        /* VSet(3, 1) In-Edges: 0 Restricts: */
        for (size_t i2_idx = 0; i2_idx < s3.size(); i2_idx++) { // loop-2 begin
          const IdType i2_id = s3[i2_idx];
          VertexSet i2_adj = graph->N(i2_id);
          counter += s2.subtract_cnt(i2_adj);
          /* VSet(4, 2) In-Edges: 1 Restricts: */
        } // loop-2 end
      }   // loop-1 end
      handled += 1;
    } // loop-0 end
    ctx.per_thread_time.at(omp_get_thread_num()) = omp_get_wtime() - start;
  } // pragma parallel
} // plan
} // namespace minigraph
extern "C" void plan(const minigraph::GraphType *graph,
                     minigraph::Context &ctx) {
  return minigraph::plan(graph, ctx);
};