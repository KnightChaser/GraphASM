; src/graph/graph_bfs.asm

%include "src/auxiliary/queue/structs.inc"
%include "src/graph/structs.inc"

extern printf
extern queue_create
extern queue_enqueue
extern queue_dequeue
extern queue_is_empty
extern queue_destroy
extern graph_reset_visited

global graph_bfs

section .rodata
fmt_visit:    db  "Visited %ld", 10, 0    ; "%ld\n"

section .text
;------------------------------------------------------------------------------
; void graph_bfs(Graph *g, int64_t startVertex)
;   – performs BFS from startVertex, printing each visited vertex
; Args:
;   RDI = Graph* pointer
;   RSI = startVertex index
;------------------------------------------------------------------------------
graph_bfs:
    push    rbp
    mov     rbp, rsp
    push    rbx               ; preserve %rbx, will hold Graph*
    push    r12               ; perserve %r12, will hold startVertex
    push    r13               ; preserve %r13, will hold Queue*
    push    r14               ; preserve %r14, will hold the current vertex (during loop)
    push    r15               ; preserve %r15, will hold the adjacency cursor

    mov     rbx, rdi          ; rbx = Graph* g
    mov     r12, rsi          ; r12 = startVertex

    ; reset visited state of all vertices
    mov     rdi, rbx          ; rdi = Graph* g
    call    graph_reset_visited

    ; create queue
    call    queue_create
    test    rax, rax
    je      .cleanup          ; OOM -> bail
    mov     r13, rax

    ; graph->visited[startVertex] = true
    mov     byte [rbx + GRAPH_VISITED + r12], 1

    ; enqueue(q, startVertex)
    mov     rdi, r13          ; rdi = Queue*
    mov     rsi, r12          ; rsi = startVertex
    call    queue_enqueue

.bfs_loop:
    ; if queue is empty, done.
    mov     rdi, r13
    call    queue_is_empty    ; returns 1(true) if empty
    test    rax, rax
    jne     .bfs_done

    ; dequeue the current vertex and print it
    mov     rdi, r13
    call    queue_dequeue
    mov     r14, rax          ; r14 = current vertex
    lea     rdi, [rel fmt_visit]
    mov     rsi, r14          ; rsi = current vertex
    xor     rax, rax
    call    printf

    ; traverse the adjacency list of current vertex
    mov     r15, [rbx + GRAPH_ADJ_LISTS + r14 * 8] ; r15 = head pointer

.bfs_adj_loop:
    test    r15, r15
    je      .bfs_loop         ; if no more adjacencies, continue BFS loop

    ; adjVertex = temp->vertex
    mov     rax, [r15 + ADJNODE_VERTEX]
    ; if not visited, mark as visited and enqueue
    mov     dl, [rbx + GRAPH_VISITED + rax]
    test    dl, dl
    jne     .skip_bfs_adj_enqueue
    mov     byte [rbx + GRAPH_VISITED + rax], 1 ; mark as visited
    mov     rdi, r13          ; rdi = Queue*
    mov     rsi, rax          ; rsi = adjVertex
    call    queue_enqueue     ; enqueue the adjacent vertex
.skip_bfs_adj_enqueue:
    ; move to the next adjacency node
    mov     r15, [r15 + ADJNODE_NEXT] ; r15 = next adjacency node
    jmp     .bfs_adj_loop             ; continue traversing the adjacency list

.bfs_done:
    ; clean up queue since we're done
    mov     rdi, r13
    call    queue_destroy

.cleanup:
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    pop     rbp
    ret
