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

; 8 bytes for numVertices 
;   + (8 * MAX_VERTICES) for adj ptrs 
;   + (1 * MAX_VERTICES) for visited flags
%define GRAPH_SIZE (8 + 9 * MAX_VERTICES)

; --- Optional sanity checks (fail fast if someone edits struct layout) ---
%if GRAPH_ADJ_LISTS != 8
    %error "GRAPH_ADJ_LISTS offset changed (expected 8)"
%endif

%if GRAPH_VISITED != (8 + 8 * MAX_VERTICES)
    %error "GRAPH_VISITED offset mismatch (expected 8 + 8 * MAX_VERTICES)"
%endif

%if GRAPH_SIZE != (8 + 8 * MAX_VERTICES + MAX_VERTICES)
    %error "GRAPH_SIZE formula mismatch"
%endif
