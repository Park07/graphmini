#include "plan.h"
namespace minigraph {
uint64_t pattern_size() { return 5; }
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
      VertexSet s0 = i0_adj.bounded(i0_id);
      if (s0.size() == 0)
        continue;
      /* VSet(0, 0) In-Edges: 0 Restricts: 0 */
      MiniGraphEager m0(true, false);
      /* Vertices = VSet(0) In-Edges: 0 Restricts: 0  | Intersect = VSet(0)
       * In-Edges: 0 Restricts: 0 */
      m0.build(s0, s0, s0);
      // skip building indices for m0 because they can be obtained directly
      for (size_t i1_idx = 0; i1_idx < s0.size(); i1_idx++) { // loop-1 begin
        const IdType i1_id = s0[i1_idx];
        VertexSet m0_adj = m0.N(i1_idx);
        VertexSet s1 = m0_adj.bounded(i1_id);
        if (s1.size() == 0)
          continue;
        /* VSet(1, 1) In-Edges: 0 1 Restricts: 0 1 */
        MiniGraphEager m1(true, false);
        /* Vertices = VSet(1) In-Edges: 0 1 Restricts: 0 1  | Intersect =
         * VSet(1) In-Edges: 0 1 Restricts: 0 1 */
        m1.build(&m0, s1, s1, s1);
        // skip building indices for m1 because they can be obtained directly
        for (size_t i2_idx = 0; i2_idx < s1.size(); i2_idx++) { // loop-2 begin
          const IdType i2_id = s1[i2_idx];
          VertexSet m1_adj = m1.N(i2_idx);
          VertexSet s2 = m1_adj.bounded(i2_id);
          if (s2.size() == 0)
            continue;
          /* VSet(2, 2) In-Edges: 0 1 2 Restricts: 0 1 2 */
          auto m1_s2 = m1.indices(s2);
          for (size_t i3_idx = 0; i3_idx < s2.size();
               i3_idx++) { // loop-3 begin
            const IdType i3_id = s2[i3_idx];
            VertexSet m1_adj = m1.N(m1_s2[i3_idx]);
            counter += s2.intersect_cnt(m1_adj, m1_adj.vid());
            /* VSet(3, 3) In-Edges: 0 1 2 3 Restricts: 0 1 2 3 */
          } // loop-3 end
        } // loop-2 end
      } // loop-1 end
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