; src/graph/graph_dfs.asm

%include "src/auxiliary/stack/structs.inc"
%include "src/graph/structs.inc"

extern printf
extern stack_create
extern stack_push
extern stack_pop
extern stack_is_empty
extern stack_destroy
extern graph_reset_visited

global graph_dfs

section .rodata
fmt_visit:  db "Visited %ld", 10, 0   ; "%ld\n"

section .text
;------------------------------------------------------------------------------
; void graph_dfs(Graph *g, int64_t startVertex)
;   – iterative DFS using your stack_*
;   - if startVertex is out of [0, g->numVertices), it will return immediately (no-op)
; Args:
;   RDI = Graph* pointer
;   RSI = startVertex index
;------------------------------------------------------------------------------
graph_dfs:
    push    rbp
    mov     rbp, rsp
    push    rbx               ; preserve %rbx, to save Graph*
    push    r12               ; preserve %r12, to save startVertex
    push    r13               ; preserve %r13, to save Stack*
    push    r14               ; preserve %r14, to save currentVertex
    push    r15               ; preserve %r15, to save adjacency cursor

    mov     rbx, rdi          ; rbx = Graph* g
    mov     r12, rsi          ; r12 = startVertex

    ; bound check
    mov     rcx, [rbx + GRAPH_NUM_VERTICES]
    cmp     r12, rcx
    jae     .bad_arg          ; out of range, no-op


    ; reset visited state of all vertices
    mov     rdi, rbx          ; rdi = Graph* g
    call    graph_reset_visited

    ; create stack
    call    stack_create
    test    rax, rax
    je      .cleanup
    mov     r13, rax          ; r13 = Stack* stack

    ; mark start visited and push it 
    mov     byte [rbx + GRAPH_VISITED + r12], 1
    mov     rdi, r13
    mov     rsi, r12          ; start vertex
    call    stack_push

.dfs_loop:
    ; if stack is empty, done
    mov     rdi, r13
    call    stack_is_empty    ; %rax=1 if empty
    test    rax, rax
    jne     .dfs_done

    ; pop currentVertex
    mov     rdi, r13
    call    stack_pop
    mov     r14, rax          ; r14 = currentVertex

    ; print visited vertex
    lea     rdi, [rel fmt_visit]
    mov     rsi, r14
    xor     rax, rax
    call    printf

    ; traverse the adjacency list 
    mov     r15, [rbx + GRAPH_ADJ_LISTS + r14 * 8] ; r15 = adjList head

.dfs_adj_loop:
    test    r15, r15
    je      .dfs_loop

    ; adjVertex = node->vertex
    mov     rax, [r15 + ADJNODE_VERTEX]
    ; if not visited, mark and push
    mov     dl, [rbx + GRAPH_VISITED + rax]
    test    dl, dl
    jne     .skip_push
    mov     byte [rbx + GRAPH_VISITED + rax], 1 ; mark as visited
    mov     rdi, r13
    mov     rsi, rax
    call    stack_push

.skip_push:
    mov     r15, [r15 + ADJNODE_NEXT] ; move to next adjacency node
    jmp     .dfs_adj_loop


.dfs_done:
    ; destroy stack since we're done
    mov     rdi, r13
    call    stack_destroy

.cleanup:
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    pop     rbp
    ret

.bad_arg:
    jmp     .cleanup
