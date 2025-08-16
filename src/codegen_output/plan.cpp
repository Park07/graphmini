#include "plan.h"
namespace minigraph {
uint64_t pattern_size() { return 8; }
void plan(const GraphType *graph, Context &ctx) {
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
      for (size_t i1_idx = 0; i1_idx < s0.size(); i1_idx++) { // loop-1 begin
        const IdType i1_id = s0[i1_idx];
        VertexSet i1_adj = graph->N(i1_id);
        VertexSet s1 = s0.subtract(i1_adj);
        /* VSet(1, 1) In-Edges: 0 Restricts: */
        VertexSet s2 = s0.intersect(i1_adj, i1_adj.vid());
        /* VSet(2, 1) In-Edges: 0 1 Restricts: 1 */
        for (size_t i2_idx = 0; i2_idx < s1.size(); i2_idx++) { // loop-2 begin
          const IdType i2_id = s1[i2_idx];
          VertexSet i2_adj = graph->N(i2_id);
          VertexSet s3 = i2_adj.subtract(i0_adj).subtract(i1_adj);
          if (s3.size() == 0)
            continue;
          /* VSet(3, 2) In-Edges: 2 Restricts: */
          VertexSet s4 = s1.subtract(i2_adj);
          /* VSet(4, 2) In-Edges: 0 Restricts: */
          VertexSet s5 = s2.subtract(i2_adj);
          /* VSet(5, 2) In-Edges: 0 1 Restricts: 1 */
          for (size_t i3_idx = 0; i3_idx < s4.size();
               i3_idx++) { // loop-3 begin
            const IdType i3_id = s4[i3_idx];
            VertexSet i3_adj = graph->N(i3_id);
            VertexSet s6 = s3.subtract(i3_adj);
            /* VSet(6, 3) In-Edges: 2 Restricts: */
            VertexSet s7 = s3.intersect(i3_adj);
            /* VSet(7, 3) In-Edges: 2 3 Restricts: */
            VertexSet s8 = s5.subtract(i3_adj);
            /* VSet(8, 3) In-Edges: 0 1 Restricts: 1 */
            for (size_t i4_idx = 0; i4_idx < s6.size();
                 i4_idx++) { // loop-4 begin
              const IdType i4_id = s6[i4_idx];
              VertexSet i4_adj = graph->N(i4_id);
              VertexSet s9 = i4_adj.subtract(i0_adj)
                                 .subtract(i1_adj)
                                 .subtract(i2_adj)
                                 .subtract(i3_adj);
              if (s9.size() == 0)
                continue;
              /* VSet(9, 4) In-Edges: 4 Restricts: */
              VertexSet s10 = s7.subtract(i4_adj);
              /* VSet(10, 4) In-Edges: 2 3 Restricts: */
              VertexSet s11 = s8.subtract(i4_adj);
              /* VSet(11, 4) In-Edges: 0 1 Restricts: 1 */
              for (size_t i5_idx = 0; i5_idx < s11.size();
                   i5_idx++) { // loop-5 begin
                const IdType i5_id = s11[i5_idx];
                VertexSet i5_adj = graph->N(i5_id);
                VertexSet s12 = s9.subtract(i5_adj);
                /* VSet(12, 5) In-Edges: 4 Restricts: */
                VertexSet s13 = s10.subtract(i5_adj);
                /* VSet(13, 5) In-Edges: 2 3 Restricts: */
                for (size_t i6_idx = 0; i6_idx < s13.size();
                     i6_idx++) { // loop-6 begin
                  const IdType i6_id = s13[i6_idx];
                  VertexSet i6_adj = graph->N(i6_id);
                  counter += s12.subtract_cnt(i6_adj);
                  /* VSet(14, 6) In-Edges: 4 Restricts: */
                } // loop-6 end
              }   // loop-5 end
            }     // loop-4 end
          }       // loop-3 end
        }         // loop-2 end
      }           // loop-1 end
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