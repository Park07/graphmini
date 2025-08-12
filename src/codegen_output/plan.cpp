#include "plan.h"
namespace minigraph {
uint64_t pattern_size() { return 4; }
<<<<<<< Updated upstream
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
=======
static const Graph *graph;
using MiniGraphType = MiniGraphCostModel;
class Loop1 {
private:
  Context &ctx;
  // Adjacent Lists
  VertexSet &i0_adj;
  // Parent Intermediates
  VertexSet &s0;
  // Iterate Set
  VertexSet &s1;

public:
  Loop1(Context &_ctx, VertexSet &_i0_adj, VertexSet &_s0, VertexSet &_s1)
      : ctx{_ctx}, i0_adj{_i0_adj}, s0{_s0}, s1{_s1} {};
  void operator()(const tbb::blocked_range<size_t> &r) const { // operator begin
    const int worker_id = tbb::this_task_arena::current_thread_index();
    cc &counter = ctx.per_thread_result.at(worker_id);
    for (size_t i1_idx = r.begin(); i1_idx < r.end(); i1_idx++) { // loop-1begin
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
    } // loop-1 end
  } // operator end
}; // Loop

class Loop0 {
private:
  Context &ctx;

public:
  Loop0(Context &_ctx) : ctx{_ctx} {};
  void operator()(const tbb::blocked_range<size_t> &r) const { // operator begin
    const int worker_id = tbb::this_task_arena::current_thread_index();
    cc &counter = ctx.per_thread_result.at(worker_id);
    for (size_t i0_id = r.begin(); i0_id < r.end(); i0_id++) { // loop-0begin
>>>>>>> Stashed changes
      VertexSet i0_adj = graph->N(i0_id);
      VertexSet s0 = i0_adj;
      if (s0.size() == 0)
        continue;
<<<<<<< Updated upstream
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
        auto m0_s1 = m0.indices(s1);
        for (size_t i2_idx = 0; i2_idx < s1.size(); i2_idx++) { // loop-2 begin
          const IdType i2_id = s1[i2_idx];
          VertexSet m0_adj = m0.N(m0_s1[i2_idx]);
          counter += s1.intersect_cnt(m0_adj, m0_adj.vid());
          /* VSet(2, 2) In-Edges: 0 1 2 Restricts: 0 1 2 */
=======
      /* VSet(0, 0) In-Edges: 0 Restricts: */
      VertexSet s1 = s0.bounded(i0_id);
      /* VSet(1, 0) In-Edges: 0 Restricts: 0 */
      if (s1.size() > 4 * 28) {
        tbb::parallel_for(tbb::blocked_range<size_t>(0, s1.size(), 1),
                          Loop1(ctx, i0_adj, s0, s1), tbb::auto_partitioner());
        continue;
      }
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
>>>>>>> Stashed changes
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