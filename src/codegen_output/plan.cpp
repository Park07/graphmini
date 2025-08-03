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
      VertexSet s0 = i0_adj;
      if (s0.size() == 0)
        continue;
      /* VSet(0, 0) In-Edges: 0 Restricts: */
      VertexSet s1 = s0.bounded(i0_id);
      /* VSet(1, 0) In-Edges: 0 Restricts: 0 */
      MiniGraphType m0(true, false);
      /* Vertices = VSet(1) In-Edges: 0 Restricts: 0  | Intersect = VSet(1)
       * In-Edges: 0 Restricts: 0 */
      double m0_factor = 0;
      m0_factor += s0.size() * s1.size() * 0.6395197459907617 * 2;
      m0_factor += s0.size() * s1.size() * 0.6395197459907617 * s1.size() *
                   0.40898550551208834 * 1;
      m0.set_reuse_multiplier(m0_factor);
      m0.build(s1, s1, s0);
      for (size_t i1_idx = 0; i1_idx < s0.size(); i1_idx++) { // loop-1 begin
        const IdType i1_id = s0[i1_idx];
        VertexSet i1_adj = graph->N(i1_id);
        VertexSet s2 = s1.intersect(i1_adj);
        /* VSet(2, 1) In-Edges: 0 1 Restricts: 0 */
        VertexSet s3 = s2.bounded(i1_id);
        /* VSet(3, 1) In-Edges: 0 1 Restricts: 0 1 */
        MiniGraphEager m1(false, false);
        /* Vertices = VSet(2) In-Edges: 0 1 Restricts: 0  | Intersect = VSet(3)
         * In-Edges: 0 1 Restricts: 0 1 */
        m1.build(s2, s3, s2);
        auto m0_s2 = m0.indices(s2);
        // skip building indices for m1 because they can be obtained directly
        for (size_t i2_idx = 0; i2_idx < s2.size(); i2_idx++) { // loop-2 begin
          const IdType i2_id = s2[i2_idx];
          VertexSet m0_adj = m0.N(m0_s2[i2_idx]);
          VertexSet m1_adj = m1.N(i2_idx);
          VertexSet s4 = s2.subtract(m0_adj, m0_adj.vid());
          if (s4.size() == 0)
            continue;
          /* VSet(4, 2) In-Edges: 0 1 Restricts: 0 2 */
          VertexSet s5 = m1_adj;
          if (s5.size() == 0)
            continue;
          /* VSet(5, 2) In-Edges: 0 1 2 Restricts: 0 1 */
          auto m1_s4 = m1.indices(s4);
          for (size_t i3_idx = 0; i3_idx < s4.size();
               i3_idx++) { // loop-3 begin
            const IdType i3_id = s4[i3_idx];
            VertexSet m1_adj = m1.N(m1_s4[i3_idx]);
            counter += s5.intersect_cnt(m1_adj);
            /* VSet(6, 3) In-Edges: 0 1 2 3 Restricts: 0 1 */
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