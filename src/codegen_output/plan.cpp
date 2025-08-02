#include "plan.h"
namespace minigraph {
uint64_t pattern_size() { return 8; }
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
      MiniGraphEager m0(false, false);
      /* Vertices = VSet(0) In-Edges: 0 Restricts:  | Intersect = VSet(0)
       * In-Edges: 0 Restricts: */
      m0.build(s0, s0, s0);
      // skip building indices for m0 because they can be obtained directly
      for (size_t i1_idx = 0; i1_idx < s0.size(); i1_idx++) { // loop-1 begin
        const IdType i1_id = s0[i1_idx];
        VertexSet m0_adj = m0.N(i1_idx);
        VertexSet s1 = s0.subtract(m0_adj);
        if (s1.size() == 0)
          continue;
        /* VSet(1, 1) In-Edges: 0 Restricts: */
        VertexSet s2 = m0_adj;
        if (s2.size() == 0)
          continue;
        /* VSet(2, 1) In-Edges: 0 1 Restricts: */
        MiniGraphType m1(true, false);
        /* Vertices = VSet(1) In-Edges: 0 Restricts:  | Intersect = VSet(1)
         * In-Edges: 0 Restricts: */
        double m1_factor = 0;
        m1_factor += s2.size() * s2.size() * 0.6395197459907617 * s1.size() *
                     0.40898550551208834 * 1;
        m1_factor += s2.size() * s2.size() * 0.6395197459907617 * s1.size() *
                     0.40898550551208834 * s1.size() * 0.261554306598994 * 1;
        m1_factor += s2.size() * s2.size() * 0.6395197459907617 * s1.size() *
                     0.40898550551208834 * s1.size() * 0.261554306598994 *
                     s1.size() * 0.16726914371897844 * 1;
        m1.set_reuse_multiplier(m1_factor);
        m1.build(&m0, s1, s1, s2);
        MiniGraphType m2(false, false);
        /* Vertices = VSet(2) In-Edges: 0 1 Restricts:  | Intersect = VSet(1)
         * In-Edges: 0 Restricts: */
        double m2_factor = 0;
        m2_factor += s2.size() * s2.size() * 0.6395197459907617 * 1;
        m2.set_reuse_multiplier(m2_factor);
        m2.build(&m0, s2, s1, s2);
        // skip building indices for m2 because they can be obtained directly
        auto m0_s2 = m0.indices(s2);
        for (size_t i2_idx = 0; i2_idx < s2.size(); i2_idx++) { // loop-2 begin
          const IdType i2_id = s2[i2_idx];
          VertexSet m2_adj = m2.N(i2_idx);
          VertexSet m0_adj = m0.N(m0_s2[i2_idx]);
          VertexSet s3 = s1.subtract(m2_adj);
          if (s3.size() == 0)
            continue;
          /* VSet(3, 2) In-Edges: 0 Restricts: */
          VertexSet s4 = s2.subtract(m0_adj, m0_adj.vid());
          if (s4.size() == 0)
            continue;
          /* VSet(4, 2) In-Edges: 0 1 Restricts: 2 */
          MiniGraphType m3(true, false);
          /* Vertices = VSet(3) In-Edges: 0 Restricts:  | Intersect = VSet(3)
           * In-Edges: 0 Restricts: */
          double m3_factor = 0;
          m3_factor += s4.size() * s3.size() * 0.6395197459907617 * 1;
          m3_factor += s4.size() * s3.size() * 0.6395197459907617 * s3.size() *
                       0.40898550551208834 * 1;
          m3_factor += s4.size() * s3.size() * 0.6395197459907617 * s3.size() *
                       0.40898550551208834 * s3.size() * 0.261554306598994 * 1;
          m3.set_reuse_multiplier(m3_factor);
          m3.build(&m1, s3, s3, s4);
          auto m2_s4 = m2.indices(s4);
          for (size_t i3_idx = 0; i3_idx < s4.size();
               i3_idx++) { // loop-3 begin
            const IdType i3_id = s4[i3_idx];
            VertexSet m2_adj = m2.N(m2_s4[i3_idx]);
            VertexSet s5 = s3.subtract(m2_adj);
            if (s5.size() == 0)
              continue;
            /* VSet(5, 3) In-Edges: 0 Restricts: */
            MiniGraphType m4(true, false);
            /* Vertices = VSet(5) In-Edges: 0 Restricts:  | Intersect = VSet(5)
             * In-Edges: 0 Restricts: */
            double m4_factor = 0;
            m4_factor += s5.size() * s5.size() * 0.6395197459907617 * 1;
            m4_factor += s5.size() * s5.size() * 0.6395197459907617 *
                         s5.size() * 0.40898550551208834 * 1;
            m4.set_reuse_multiplier(m4_factor);
            m4.build(&m3, s5, s5, s5);
            // skip building indices for m4 because they can be obtained
            // directly
            for (size_t i4_idx = 0; i4_idx < s5.size();
                 i4_idx++) { // loop-4 begin
              const IdType i4_id = s5[i4_idx];
              VertexSet m4_adj = m4.N(i4_idx);
              VertexSet s6 = s5.subtract(m4_adj, m4_adj.vid());
              if (s6.size() == 0)
                continue;
              /* VSet(6, 4) In-Edges: 0 Restricts: 4 */
              MiniGraphType m5(true, false);
              /* Vertices = VSet(6) In-Edges: 0 Restricts: 4  | Intersect =
               * VSet(6) In-Edges: 0 Restricts: 4 */
              double m5_factor = 0;
              m5_factor += s6.size() * s6.size() * 0.6395197459907617 * 1;
              m5.set_reuse_multiplier(m5_factor);
              m5.build(&m4, s6, s6, s6);
              // skip building indices for m5 because they can be obtained
              // directly
              for (size_t i5_idx = 0; i5_idx < s6.size();
                   i5_idx++) { // loop-5 begin
                const IdType i5_id = s6[i5_idx];
                VertexSet m5_adj = m5.N(i5_idx);
                VertexSet s7 = s6.subtract(m5_adj, m5_adj.vid());
                if (s7.size() == 0)
                  continue;
                /* VSet(7, 5) In-Edges: 0 Restricts: 4 5 */
                auto m5_s7 = m5.indices(s7);
                for (size_t i6_idx = 0; i6_idx < s7.size();
                     i6_idx++) { // loop-6 begin
                  const IdType i6_id = s7[i6_idx];
                  VertexSet m5_adj = m5.N(m5_s7[i6_idx]);
                  counter += s7.subtract_cnt(m5_adj, m5_adj.vid());
                  /* VSet(8, 6) In-Edges: 0 Restricts: 4 5 6 */
                } // loop-6 end
              } // loop-5 end
            } // loop-4 end
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