#include "bfs.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <cstddef>
#include <omp.h>

#include "../common/CycleTimer.h"
#include "../common/graph.h"

#include <vector>
#include <map>
using namespace std;

#define ROOT_NODE_ID 0
#define NOT_VISITED_MARKER -1
// #define VERBOSE

int global_depth = 0;

void vertex_set_clear(vertex_set *list)
{
    list->count = 0;
}

void vertex_set_init(vertex_set *list, int count)
{
    list->max_vertices = count;
    list->vertices = (int *)malloc(sizeof(int) * list->max_vertices);
    vertex_set_clear(list);
}

// Take one step of "top-down" BFS.  For each vertex on the frontier,
// follow all outgoing edges, and add all neighboring vertices to the
// new_frontier.



void top_down_step(
    Graph g,
    vertex_set *frontier,
    vertex_set *new_frontier,
    int *distances, int depth
    )
{
    // init the vector for each thread
    vector<vector<int>> thread_next(omp_get_max_threads());
    // declear the variables to avoid duplicate access
    int num_edges = g->num_edges, num_nodes = g->num_nodes;
    int *outgoing_start = g->outgoing_starts;
    #pragma omp parallel
    {
        // get the thread id of each thread
        int thread_id = omp_get_thread_num();
        #pragma omp for
        for (int i = 0; i < frontier->count; i++)
        {
            Vertex node = frontier->vertices[i];
            int start_edge = outgoing_start[node];
            int end_edge = (node == num_nodes - 1)
                            ? num_edges
                            : outgoing_start[node + 1];
            // attempt to add all neighbors to the new frontier
            for (int neighbor = start_edge; neighbor < end_edge; neighbor++)
            {
                int node_child = g->outgoing_edges[neighbor];
                if (distances[node_child] == NOT_VISITED_MARKER)
                {
                    distances[node_child] = depth + 1;
                    // push to the vector and process later
                    thread_next[thread_id].push_back(node_child);
                }
            }
        }
    }
    // go through every thread
    for (int i = 0; i < omp_get_max_threads(); i+=1)
    {
        // go through every node in the vector in each thread
        for (int j = 0; j < thread_next[i].size(); j+=1)
        {
            // since this part is not parallel, we don't need to deal with critical section
            int index = new_frontier->count++;
            new_frontier->vertices[index] = thread_next[i][j];
        }    
    }

}


void top_down_step_origin(
    Graph g,
    vertex_set *frontier,
    vertex_set *new_frontier,
    int *distances)
{
    // go through all nodes in the frontier
    for (int i = 0; i < frontier->count; i++)
    {

        int node = frontier->vertices[i];

        int start_edge = g->outgoing_starts[node];
        int end_edge = (node == g->num_nodes - 1)
                           ? g->num_edges
                           : g->outgoing_starts[node + 1];

        // attempt to add all neighbors to the new frontier
        for (int neighbor = start_edge; neighbor < end_edge; neighbor++)
        {
            int outgoing = g->outgoing_edges[neighbor];

            if (distances[outgoing] == NOT_VISITED_MARKER)
            {
                // add up the distances
                distances[outgoing] = distances[node] + 1;
                int index = new_frontier->count++;
                new_frontier->vertices[index] = outgoing;
            }
        }
    }
}

// Implements top-down BFS.
//
// Result of execution is that, for each node in the graph, the
// distance to the root is stored in sol.distances.
void bfs_top_down(Graph graph, solution *sol)
{
    int depth = 0;
    vertex_set list1;
    vertex_set list2;
    vertex_set_init(&list1, graph->num_nodes);
    vertex_set_init(&list2, graph->num_nodes);

    vertex_set *frontier = &list1;
    vertex_set *new_frontier = &list2;

    // initialize all nodes to NOT_VISITED
    for (int i = 0; i < graph->num_nodes; i++)
        sol->distances[i] = NOT_VISITED_MARKER;

    // setup frontier with the root node
    frontier->vertices[frontier->count++] = ROOT_NODE_ID;
    sol->distances[ROOT_NODE_ID] = 0;

    while (frontier->count != 0)
    {

#ifdef VERBOSE
        double start_time = CycleTimer::currentSeconds();
#endif

        vertex_set_clear(new_frontier);

        top_down_step(graph, frontier, new_frontier, sol->distances, depth);
        depth += 1;

#ifdef VERBOSE
        double end_time = CycleTimer::currentSeconds();
        printf("frontier=%-10d %.4f sec\n", frontier->count, end_time - start_time);
#endif

        // swap pointers
        vertex_set *tmp = frontier;
        frontier = new_frontier;
        new_frontier = tmp;
    }
    // free the list
    free(list1.vertices);
    free(list2.vertices);
}

void bottom_up_step(
    Graph g,
    vertex_set *frontier,
    vertex_set *new_frontier,
    int *distances, int depth
    )
{

    // init the vector for each thread
    vector<vector<int>> thread_next(omp_get_max_threads());
    
    // printf("%d\n", g->num_nodes);
    // bool is_frontier[g->num_nodes];
    bool *is_frontier = (bool *)malloc(sizeof(bool) * g->num_nodes);
    // printf("check\n");
    memset(is_frontier, false, sizeof(bool) * g->num_nodes);
    // go through all nodes in the frontier
    for (int i = 0; i < frontier->count; i++)
    {
        int node = frontier->vertices[i];
        is_frontier[node] = true;
    }
    

    int num_edges = g->num_edges, num_nodes = g->num_nodes;
    int *outgoing_start = g->outgoing_starts;
    int *incoming_start = g->incoming_starts;

    // scan all nodes that aren't visited yet
    #pragma omp parallel
    {
        // get the thread id of each thread
        int thread_id = omp_get_thread_num();
        #pragma omp for schedule(dynamic, 1024)
        for( int v = 0 ; v < num_nodes ; v += 1){ 
            if(distances[v] == NOT_VISITED_MARKER){
                int start_edge = incoming_start[v];
                int end_edge = (v == num_nodes - 1)
                                ? num_edges
                                : incoming_start[v + 1];
                for (int neighbor = start_edge; neighbor < end_edge; neighbor++)
                {
                    // to see if the neighbor is in the frontier
                    // for(int i = 0 ; i < frontier->count ; i+=1)

                    if(is_frontier[g->incoming_edges[neighbor]]){
                        distances[v] = depth+1;
                        // push to the vector and process later
                        thread_next[thread_id].push_back(v);
                        break;
                    }
                }
            }
        }   
    }
    // go through every thread
    for (int i = 0; i < omp_get_max_threads(); i+=1)
    {
        // go through every node in the vector in each thread
        for (int j = 0; j < thread_next[i].size(); j+=1)
        {
            // since this part is not parallel, we don't need to deal with critical section
            int index = new_frontier->count++;
            new_frontier->vertices[index] = thread_next[i][j];
        }    
    }
    free(is_frontier);
}

void bfs_bottom_up(Graph graph, solution *sol)
{
    // For PP students:
    //
    // You will need to implement the "bottom up" BFS here as
    // described in the handout.
    //
    // As a result of your code's execution, sol.distances should be
    // correctly populated for all nodes in the graph.
    //
    // As was done in the top-down case, you may wish to organize your
    // code by creating subroutine bottom_up_step() that is called in
    // each step of the BFS process.
    int depth = 0;
    vertex_set list1;
    vertex_set list2;
    vertex_set_init(&list1, graph->num_nodes);
    vertex_set_init(&list2, graph->num_nodes);

    vertex_set *frontier = &list1;
    vertex_set *new_frontier = &list2;

    // initialize all nodes to NOT_VISITED
    for (int i = 0; i < graph->num_nodes; i++)
        sol->distances[i] = NOT_VISITED_MARKER;

    // setup frontier with the root node
    frontier->vertices[frontier->count++] = ROOT_NODE_ID;
    sol->distances[ROOT_NODE_ID] = 0;

    while (frontier->count != 0)
    {

#ifdef VERBOSE
        double start_time = CycleTimer::currentSeconds();
#endif

        vertex_set_clear(new_frontier);

        bottom_up_step(graph, frontier, new_frontier, sol->distances, depth);
        depth += 1;

#ifdef VERBOSE
        double end_time = CycleTimer::currentSeconds();
        printf("frontier=%-10d %.4f sec\n", frontier->count, end_time - start_time);
#endif

        // swap pointers
        vertex_set *tmp = frontier;
        frontier = new_frontier;
        new_frontier = tmp;
    }

    // free the list
    free(list1.vertices);
    free(list2.vertices);

}

void bfs_hybrid(Graph graph, solution *sol)
{
    // For PP students:
    //
    // You will need to implement the "hybrid" BFS here as
    // described in the handout.
    int depth = 0;
    vertex_set list1;
    vertex_set list2;
    vertex_set_init(&list1, graph->num_nodes);
    vertex_set_init(&list2, graph->num_nodes);

    vertex_set *frontier = &list1;
    vertex_set *new_frontier = &list2;

    // initialize all nodes to NOT_VISITED
    for (int i = 0; i < graph->num_nodes; i++)
        sol->distances[i] = NOT_VISITED_MARKER;

    // setup frontier with the root node
    frontier->vertices[frontier->count++] = ROOT_NODE_ID;
    sol->distances[ROOT_NODE_ID] = 0;
    bool is_top_down = true;
    int n = graph->num_nodes;
    while (frontier->count != 0)
    {

#ifdef VERBOSE
        double start_time = CycleTimer::currentSeconds();
#endif

        vertex_set_clear(new_frontier);

        // the number of edges to check from the frontier (mf ), 
        int mf = 0;
        #pragma omp parallel for reduction(+:mf)
        for (int i = 0; i < frontier->count; i++)
        {
            int node = frontier->vertices[i];
            int start_edge = graph->outgoing_starts[node];
            int end_edge = (node == graph->num_nodes - 1)
                               ? graph->num_edges
                               : graph->outgoing_starts[node + 1];
            mf += end_edge - start_edge;
        }
        // the number of vertices in the frontier (nf ),
        int nf = frontier->count;

        // the number of edges to check from unexplored vertices (mu)
        int mu = 0;
        #pragma omp parallel for reduction(+:mu)
        for (int i = 0; i < graph->num_nodes; i++)
        {
            if (sol->distances[i] == NOT_VISITED_MARKER)
            {
                int start_edge = graph->incoming_starts[i];
                int end_edge = (i == graph->num_nodes - 1)
                                   ? graph->num_edges
                                   : graph->incoming_starts[i + 1];
                mu += end_edge - start_edge;
            }
        }
        
        int alpha = 14;
        int beta = 24;

        if ( is_top_down ){
            if(mf > mu/alpha){
                is_top_down = false;
            }
            else{
                is_top_down = true;
            }
        }
        else
        {
            if(nf < n/beta){
                is_top_down = true;
            }
            else{
                is_top_down = false;
            }
        }

        if ( is_top_down ){
            top_down_step(graph, frontier, new_frontier, sol->distances, depth);
        }
        else
        {
            bottom_up_step(graph, frontier, new_frontier, sol->distances, depth);
        }
        

        
        
        depth += 1;

#ifdef VERBOSE
        double end_time = CycleTimer::currentSeconds();
        printf("frontier=%-10d %.4f sec\n", frontier->count, end_time - start_time);
#endif

        // swap pointers
        vertex_set *tmp = frontier;
        frontier = new_frontier;
        new_frontier = tmp;
    }
    // free the list
    free(list1.vertices);
    free(list2.vertices);
}