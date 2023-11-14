#include "page_rank.h"

#include <stdlib.h>
#include <cmath>
#include <omp.h>
#include <utility>

#include "../common/CycleTimer.h"
#include "../common/graph.h"

// pageRank --
//
// g:           graph to process (see common/graph.h)
// solution:    array of per-vertex vertex scores (length of array is num_nodes(g))
// damping:     page-rank algorithm's damping parameter
// convergence: page-rank algorithm's convergence threshold
//
void pageRank(Graph g, double *solution, double damping, double convergence)
{
  // initialize vertex weights to uniform probability. Double
  // precision scores are used to avoid underflow for large graphs

  int numNodes = num_nodes(g);
  double equal_prob = 1.0 / numNodes;
  // for (int i = 0; i < numNodes; ++i)
  // {
  //   solution[i] = equal_prob;
  // }

  /*
     For PP students: Implement the page rank algorithm here.  You
     are expected to parallelize the algorithm using openMP.  Your
     solution may need to allocate (and free) temporary arrays.

     Basic page rank pseudocode is provided below to get you started:

     // initialization: see example code above
     score_old[vi] = 1/numNodes;

     while (!converged) {

       // compute score_new[vi] for all nodes vi:
       score_new[vi] = sum over all nodes vj reachable from incoming edges
                          { score_old[vj] / number of edges leaving vj  }
       score_new[vi] = (damping * score_new[vi]) + (1.0-damping) / numNodes;

       score_new[vi] += sum over all nodes v in graph with no outgoing edges
                          { damping * score_old[v] / numNodes }

       // compute how much per-node scores have changed
       // quit once algorithm has converged

       global_diff = sum over all nodes vi { abs(score_new[vi] - score_old[vi]) };
       converged = (global_diff < convergence)
     }

   */
  // init the variable for the given pseudocode
  bool converged = false;
  double global_diff = 0.0;
  double* score_new = (double*)malloc(sizeof(double) * numNodes);
  // score_old to be swap in the end of each iteration
  double* score_old = (double*)malloc(sizeof(double) * numNodes);
  // init score_old and outgoing_size_array
  int* outgoing_size_array = (int*)malloc(sizeof(int) * numNodes);
  
  for (int i = 0; i < numNodes; i+=1)
  {
    // init score_old to equal_prob
    score_old[i] = equal_prob;
    // init outgoing_size_array
    outgoing_size_array[i] = outgoing_size(g, i);
  }  
  // pre assign the variable for the given pseudocode to avoid the repeated assignment
  int32_t size;
  const Vertex* start;
  double no_outgoing_sum;
  double one_minus_damping = 1.0 - damping;
  // while (!converged) {
  while(!converged){
    // compute score_new[vi] for all nodes vi:
    
    for(int vi = 0 ; vi < numNodes ; vi+=1){
      score_new[vi] = 0.0;
      start = incoming_begin(g, vi);
      size = incoming_size(g, vi);
      // score_new[vi] = sum over all nodes vj reachable from incoming edges
      //  { score_old[vj] / number of edges leaving vj  }
      for(int vj = 0 ; vj < size ; vj+=1){
        score_new[vi] += score_old[start[vj]] / outgoing_size_array[start[vj]];
      }
    
      //score_new[vi] = (damping * score_new[vi]) + (1.0-damping) / numNodes;
      score_new[vi] = (damping * score_new[vi]) + one_minus_damping * equal_prob;
  
      
    }
    // score_new[vi] += sum over all nodes v in graph with no outgoing edges
    // { damping * score_old[v] / numNodes }
    no_outgoing_sum = 0.0;
    
    for(int v = 0 ; v < numNodes ; v += 1){
      if(outgoing_size_array[v] == 0){
        no_outgoing_sum += damping * score_old[v] / numNodes;
      }
    }
    
    for(int vi = 0 ; vi < numNodes ; vi+=1){
      score_new[vi] += no_outgoing_sum;
    }
    

    // compute how much per-node scores have changed
    // quit once algorithm has converged

    // global_diff = sum over all nodes vi { abs(score_new[vi] - score_old[vi]) };
    global_diff = 0.0;
    
    for(int vi = 0 ; vi < numNodes ; vi+=1){
      global_diff += abs(score_new[vi] - score_old[vi]);
    }
    // converged = (global_diff < convergence)
    converged = (global_diff < convergence);

    // swap score_new and score_old
    std::swap(score_new, score_old);
  }// end of while(!converged)

  // return the score_old to solution
  
  for(int i = 0 ; i < numNodes ; i+=1){
    solution[i] = score_old[i];
  }
  free(score_old);
  free(score_new);
  free(outgoing_size_array);
  return;
}


