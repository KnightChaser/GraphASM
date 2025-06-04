; src/graph/structs.inc

;------------------------------------------------------------------------------
; 1) Adjacency list node for the graph data structure
;------------------------------------------------------------------------------
; Each list node holds:
;    - 8 bytes: vertex index (int64_t)
;    - 8 bytes: pointer to the next adjacency node (AdjNode*)
;------------------------------------------------------------------------------

struc AdjNode
    .vertex    resq    1    ; 8 bytes: Vertex index (int64_t)
    .next      resq    1    ; 8 bytes: Pointer to the next adjacency node
endstruc

%define ADJNODE_VERTEX AdjNode.vertex
%define ADJNODE_NEXT   AdjNode.next
%define ADJNODE_SIZE   16              ; Size of AdjNode structure in bytes


;------------------------------------------------------------------------------
; 2) Graph structure containing the adjacency list
;------------------------------------------------------------------------------
; The graph structure holds:
;    - 8 bytes: Number of vertices (int64_t)
;    - 8 * MAX_VERTICES bytes: Array of pointers to adjacency lists (AdjNode*)
;    - MAX_VERTICES bytes: Visited flags for each vertex (1 byte each)
;------------------------------------------------------------------------------
%define MAX_VERTICES 1024

struc Graph
    .numVerticies    resq    1            ; 8 bytes: Number of vertices (int64_t)
    .adjLists        resq    MAX_VERTICES ; 8 bytes each: Array of pointers to adjacency lists (AdjNode*)
    .visited         resb    MAX_VERTICES ; 1 byte each: Visited flags for each vertex
endstruc

%define GRAPH_NUM_VERTICES  Graph.numVerticies
%define GRAPH_ADJ_LISTS     Graph.adjLists
%define GRAPH_VISITED       Graph.visited
%define GRAPH_SIZE          9224 ; Size of Graph structure in bytes
   ; 8 bytes for numVerticies
   ; 8 * MAX_VERTICES bytes for adjLists (8 * 1024 = 8192)
   ; MAX_VERTICES bytes for visited boolean flags (1 byte each)
